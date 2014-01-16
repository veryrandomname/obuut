Class = require "hump.class"

Animal = Class{
    init = function(self, pos, img)
        self.pos = pos
        self.img = img
        self.width = img:getWidth()
        self.velocity = {x=0,y=0}
    end,
    sizeImpact = 0.2,
    name = "animal"
}


function Animal:update(dt)
    self:randomizeVelocity()

    self.pos.x = self.pos.x + self.velocity.x*dt
    self.pos.y = self.pos.y + self.velocity.y*dt

    if self.pos.y < 0 then
        self.pos.y = 0
        self.velocity.y = 100
    end

    if self.pos.y > animalArea.y then
        self.pos.y = animalArea.y
        self.velocity.y = -100
    end
    if self.pos.x < -animalArea.x then
        self.pos.x = -animalArea.x
        self.velocity.x = 100
    end
    if self.pos.x > animalArea.x then
        self.pos.x = animalArea.x
        self.velocity.x = -100
    end

end

function Animal:draw()
    love.graphics.draw(self.img, self.pos.x, self.pos.y)
end

function Animal:randomizeVelocity()
    self.velocity.x = self.velocity.x + love.math.random(-10,10)
    --self.velocity.y = self.velocity.y + love.math.random()

    if self.velocity.x > 100 then
        self.velocity.x = 100
    end
    if self.velocity.x < -100 then
        self.velocity.x = -100
    end
end

function Animal:sound()
end

return Animal