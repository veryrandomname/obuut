Class = require "hump.class"
Animal = require "animal"

Sheep = Class{
    init = Animal.init,
    name = "sheep"
}
Sheep:include(Animal) --make the cow an animal

function Sheep:sound()
    love.audio.play(randomSheepSound())
end


return Sheep