Timer = require "hump.timer"
Camera = require "hump.camera"
Boat = require "boat"
Cow = require "cow"
Sheep = require "sheep"

function love.load()
    love.window.setTitle( "o-buut" )

    screenx = 1280
    screeny = 720
    love.window.setMode( screenx, screeny, {fullscreen=false} )
    love.graphics.setBackgroundColor( 103, 218, 255 )

    lost = false
    win = false
    looseSound = love.audio.newSource( "sounds/failmusic.ogg", "static" )
    winSound = love.audio.newSource( "sounds/winmusic.ogg", "static" )

    startSound = love.audio.newSource( "sounds/shiphorn.ogg", "static" )
    love.audio.play(startSound)

    splash = love.audio.newSource( "sounds/splash.ogg", "static" )
    sheepSounds = {
        love.audio.newSource( "sounds/baa1.ogg", "static" ),
        love.audio.newSource( "sounds/baa2.ogg", "static" ),
        love.audio.newSource( "sounds/baa3.ogg", "static" ),
        love.audio.newSource( "sounds/baa4.ogg", "static" )
    }
    mooSounds = {
        love.audio.newSource( "sounds/moo1.ogg", "static" ),
        love.audio.newSource( "sounds/moo2.ogg", "static" ),
        love.audio.newSource( "sounds/moo3.ogg", "static" ),
        love.audio.newSource( "sounds/moo4.ogg", "static" )
    }

    waterShading = love.graphics.newImage( "pics/seatoptile.png" )

    boat = Boat({x = 0, y = -80}, boatimg)
    camera = Camera(boat.pos.x, boat.pos.y)

    numberOfCows = 400
    numberOfSheeps = 10000
    caughtSheeps = 0

    heightHorizon = 160

    animalArea = {x=screenx*10, y= screeny*10}

    randomCluster = generateClusters()

    allAnimals = animalPlacement()

    --displacement between camera and boat (so the camera doesn't focus directly on the boat)
    function camdx()
        return 200 * boat.scale
    end
    function camdy()
        return 300 * boat.scale
    end
end

function love.update(dt)
    if not (lost or win) then
        Timer.update(dt)

        boat:update(dt)

        for i,v in ipairs(allAnimals) do
            v:update(dt)
        end

        if caughtSheeps >= numberOfSheeps * 0.3 then
            win = true
            love.audio.play(winSound)
        end


        local dx,dy = boat.pos.x + camdx() - camera.x, boat.pos.y + camdy() - camera.y
        camera:move(dx/2, dy/2)  --let the camera follow the boat
    end
end

function love.draw()

    camera:zoomTo(1/boat.scale)

    --camera:zoomTo(1/100)

    camera:attach() --everything here is is drawn relative to the camera! (which is following the boat)

    drawWater()
    drawWaterShading()
    animalDraw()
    boat:draw()
    --cow:draw()

    camera:detach() --from here stuff is drawn directly on screen again

    if lost then
        love.graphics.print( "Fail :-D", 500, 300, 10, 10 )
    end
    if win then
        love.graphics.print( "You won! <3", 500, 300, 10, 10 )
    end

end

function drawWater()
    love.graphics.setColor( 0, 50, 126, 255 )
    love.graphics.rectangle( "fill", -screenx*40, 0, screenx*80, screeny*80 )
    love.graphics.setColor( 255, 255, 255, 255 )
end

function animalPlacement()
    local cowImg = love.graphics.newImage( "pics/sharcow.png" )
    local sheepImg = love.graphics.newImage( "pics/fisheep.png" )

    local allAnimals = {}

    for i=1,numberOfSheeps do
        table.insert(allAnimals,Sheep(randomPosition(), sheepImg))
    end

    for i=1,numberOfCows do
        table.insert(allAnimals,Cow(randomPosition(), cowImg))
    end

    return allAnimals
end

function animalDraw( )
    for i,v in ipairs(allAnimals) do
        v:draw()
    end

end

function randomPosition()
    x = love.math.random( -screenx*10 ,screenx*10 )
    y = love.math.random( 50, screeny*10 )

    return {x = x, y = y}
end

function randomPositionNearSurface()
    x = love.math.random( -500 ,100 )
    y = love.math.random( 50, 100 )

    return {x = x, y = y}
end

function randomPositionInCluster()
    cluster = randomCluster[love.math.random(1,#randomCluster)]
    dx = love.math.random( -200 ,200 )
    dy = love.math.random( -200, 200 )

    return {x=cluster.x+dx,y=cluster.y+y}
end

function generateClusters()
    local cluster = {}
    for i=1,100 do
        table.insert(cluster,randomPositionNearSurface())
    end
    for i=1,100 do
        table.insert(cluster,randomPosition())
    end
    return cluster
end

function randomSheepSound()
    return sheepSounds[love.math.random(1,#sheepSounds)]
end

function randomSharkSound()
    return mooSounds[love.math.random(1,#mooSounds)]
end

function loose()
    lost = true
    love.audio.play(looseSound)
end

function drawWaterShading()
    for i=-100,100 do
        love.graphics.draw(waterShading, i*512, 0)
    end
end

function love.keypressed( key, isrepeat )
    if key == "r" then
        love.load() --restart game
    elseif key == "escape" or key == "q" then
        love.event.push("quit")
    end
end
