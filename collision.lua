local collision = {}

collision.areColliding = function(obj1, obj2)
    return obj1.x + obj1.width > obj2.x and obj1.x < obj2.x + obj2.width and
    obj1.y + obj1.height > obj2.y and obj1.y < obj2.y + obj2.height
end

return collision