function love.load()
    collision = require("collision")

    WW, WH = love.graphics.getDimensions()
    player = {
        x = 125,
        y = 275,
        width = 50,
        height = 50,
        xv = 400
    }
    enemy = {
        x = 0, 
        y = 0,
        image = love.graphics.newImage("enemy.png"),
        exploded = false,
        lockedX = nil,
        timer = 2,
        maxTime = 2,
        xv = 0
    }
    enemy.width = enemy.image:getWidth()
    enemy.height = enemy.image:getHeight()

    score = 0
    font = love.graphics.newFont(35)
    text = love.graphics.newText(font, tostring(score))

    loop = love.audio.newSource("loop.wav", "stream")
    loop:setLooping(true)
    loop:play()
    pitch = 1
end

function love.draw()
    if not lost then
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
        if not enemy.exploded then
            love.graphics.setColor(1, 0, 0)
            love.graphics.rectangle("fill", enemy.x, enemy.y, enemy.width, 50)
        else
            love.graphics.draw(enemy.image, enemy.x, enemy.y)
        end
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(text)
    else
        love.graphics.draw(text)
    end
end

function love.update(dt)
    if love.keyboard.isDown("a") then
        player.x = player.x - player.xv * dt
    end
    if love.keyboard.isDown("d") then
        player.x = player.x + player.xv * dt
    end
    if player.x < 0 then player.x = 0 end
    if player.x + player.width > WW then
        player.x = WW - player.width
    end

    if enemy.xv == 0 then
        enemy.timer = enemy.timer - dt
        if enemy.timer < 0 then
            enemy.lockedX = player.x
            if enemy.x > player.x then
                enemy.xv = -500
            else
                enemy.xv = 500
            end
        end
    end
    if enemy.exploded == true then enemy.exploded = false end
    if (enemy.xv > 0 and enemy.x + enemy.width / 2 > enemy.lockedX + player.width / 2) or 
    (enemy.xv < 0 and enemy.x + enemy.width / 2 < enemy.lockedX + player.width / 2) then
        enemy.xv = 0
        enemy.exploded = true
        enemy.timer = enemy.maxTime
        enemy.maxTime = enemy.maxTime - 0.1
    end
    if enemy.exploded then
        if  collision.areColliding(enemy, player) then
            lost = true
            text = love.graphics.newText(font, "lost!, score: "..tostring(score))
        else
            score = score + 1
            text = love.graphics.newText(font, tostring(score))
            loop:setPitch(loop:getPitch() * 1.2)
        end
    end
    enemy.x = enemy.x + enemy.xv * dt
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    if key == "space" then
        lost = false
        player = {
            x = 125,
            y = 275,
            width = 50,
            height = 50,
            xv = 400
        }
        enemy = {
            x = 0, 
            y = 0,
            image = love.graphics.newImage("enemy.png"),
            exploded = false,
            lockedX = nil,
            timer = 2,
            maxTime = 2,
            xv = 0
        }
        enemy.width = enemy.image:getWidth()
        enemy.height = enemy.image:getHeight()
    
        score = 0
        font = love.graphics.newFont(35)
        text = love.graphics.newText(font, tostring(score))

        loop:stop()
        loop = love.audio.newSource("loop.wav", "stream")
        loop:setLooping(true)
        loop:play()
        loop:setPitch(1)
    end
end