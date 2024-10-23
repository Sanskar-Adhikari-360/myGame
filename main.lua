_G.love = require("love")
wf =  require("libaries/windfield")
function love.load()
    require 'bird'
    screen = {
        w = love.graphics.getWidth(),
        h = love.graphics.getHeight()
    }

    world = wf.newWorld(0,0)
    
    -- player = {}
    -- 
    -- player.x = 100
    -- player.y = 100
    -- player.speed = 300
    -- player.collider = world:newRectangleCollider(player.x,player.y,35,35)
    -- player.sprite = love.graphics.newImage("sprites/bluebird-upflap.png")

    background = love.graphics.newImage("sprites/background.png")
    backgroundScroll = 0
    pipe = love.graphics.newImage("sprites/pipe.png")
    ground  = love.graphics.newImage("sprites/ground.png")
    groundScroll = 0

    BACKGROUND_SCROLL_SPEED = 30
    GROUND_SCROLL_SPEED = 60
    BACKGROUND_LOOPING_POINT = screen.w/6.5
    -- box = world:newRectangleCollider(player.x,player.y,35,35)
end
function love.update(dt)
    -- player.x =  box:getX()
    -- player.y =  box:getY()


    if love.keyboard.isDown("q") then
        love.event.quit()
    end

    -- box:setLinearVelocity(vx,vy)
    -- player.x = box:getX()
    -- player.y = box:getY()
    world:update(dt)

    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
    %BACKGROUND_LOOPING_POINT
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
    %screen.w/4
end
function love.draw()
    love.graphics.draw(background,-backgroundScroll,0)
    love.graphics.draw(ground,-groundScroll,(screen.h - 16))
    -- love.graphics.draw(player.sprite,player.x,player.y,nil,nil,nil,15,12)
    birdRender()
    world:draw()
end
-- function love.keypressed(key)
--     if key == 'space' then
--       box:applyLinearImpulse(0, -1000)
--     end
--   end