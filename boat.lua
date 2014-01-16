Class = require "hump.class"


Boat = Class{
    init = function(self, pos)
        self.pos = pos
    end,
    speed = function (self)
        return 500 * self.scale
    end,
    img = love.graphics.newImage( "pics/boat.png" ),
    scale = 1,

    boatWidth = function (self)
        return self.img:getWidth() * self.scale
    end,

    boatHeight = function (self)
        return self.img:getHeight() * self.scale
    end,

    netImg = love.graphics.newImage( "pics/net.png" ),
    netWidth = function (self)
        return self.netImg:getWidth() * self.scale
    end,

    netPos = function (self)
        return {x = self.pos.x + (self:boatWidth()/2) - (self:netWidth()/2), y = self.pos.y + self:boatHeight() / 2 }
    end,
    netDepth = {0},
    wantedScale = 1,

    timeOfLastThrow = 0,
    throwDT = 0.5
}

function Boat:update(dt)
    self.pos.y = -self:boatHeight() / 2

    if love.timer.getTime() - self.timeOfLastThrow > self.throwDT then
        if love.keyboard.isDown( "left" ) then
        	self.pos.x = self.pos.x - self:speed()*dt
        end
        if love.keyboard.isDown( "right" ) then
        	self.pos.x = self.pos.x + self:speed()*dt
        end
        if love.keyboard.isDown( " " ) then
        	self:throwNet()
        end
    end

    self:tweenScale(dt)

    if self.scale <= 0 then
        loose()
    end
end

function Boat:draw()
    love.graphics.setColor( 255, 255, 255, 50 )
    love.graphics.rectangle( "fill", self:netPos().x, self:netPos().y, self:netWidth(), screeny*self.scale )
    love.graphics.setColor( 255, 255, 255, 255 )

    love.graphics.draw(self.img, self.pos.x, self.pos.y, 0, self.scale)

    love.graphics.draw(self.netImg, self:netPos().x, self:netPos().y + self.netDepth[1], 0, self.scale)
end

function Boat:throwNet()
    Timer.tween(self.throwDT/2, self.netDepth, {screeny * self.scale})
    Timer.add(self.throwDT/2, function () Timer.tween(self.throwDT, self.netDepth, {0}) end)

    self.timeOfLastThrow = love.timer.getTime()
    Timer.add(self.throwDT,function ( )
    	for i,v in ipairs(allAnimals) do
    		if self:netCatches(v) then
                table.remove(allAnimals,i)
                self.wantedScale = self.wantedScale + v.sizeImpact
                v:sound()
                if v.name == "sheep" then
                    caughtSheeps = caughtSheeps + 1
                end
    		end
    	end
    end)

    --love.audio.play(splash)
end

function Boat:netCatches(animal)
    widthTest = animal.pos.x < self:netPos().x+self:netWidth() and animal.pos.x+animal.width > self:netPos().x
    lengthTest = animal.pos.y < screeny*self.scale
    return widthTest and lengthTest
end

function Boat:tweenScale(dt)
    d = self.wantedScale - self.scale
    self.scale = self.scale + d*dt
end


return Boat