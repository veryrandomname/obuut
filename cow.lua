Class = require "hump.class"
Animal = require "animal"

Cow = Class{
    init = Animal.init,
    sizeImpact = -5,
    name = "cow"
}
Cow:include(Animal) --make the cow an animal

function Cow:randomizeVelocity()
    self.velocity.x = self.velocity.x + love.math.random(-100,100)
    self.velocity.y = self.velocity.y + love.math.random(-100,100)

    if self.velocity.x > 1000 then
        self.velocity.x = 1000
    end
    if self.velocity.x < -1000 then
        self.velocity.x = -1000
    end

    if self.velocity.y > 1000 then
        self.velocity.y = 1000
    end
    if self.velocity.y < -1000 then
        self.velocity.y = -1000
    end
end

function Cow:sound()
    love.audio.play(randomSharkSound())
end

function Cow:draw()
    love.graphics.setColor( 255, 200, 200, 255 )
    love.graphics.draw(self.img, self.pos.x, self.pos.y)
    love.graphics.setColor( 255, 255, 255, 255 )
end

return Cow