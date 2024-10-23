_G.love = require("love")
wf =  require("libaries/windfield")
function love.load()
    screen = {
        w = love.graphics.getWidth(),
        h = love.graphics.getHeight()
    }

    world = wf.newWorld(0,500)
    
    player = {}
    
    player.x = 100
    player.y = 100
    player.speed = 300
    -- player.collider = world:newRectangleCollider(player.x,player.y,35,35)
    player.sprite = love.graphics.newImage("sprites/bluebird-upflap.png")

    background = love.graphics.newImage("sprites/background.png")
    pipe = love.graphics.newImage("sprites/pipe.png")
    ground  = love.graphics.newImage("sprites/ground.png")
    box = world:newRectangleCollider(player.x,player.y,35,35)
end
function love.update(dt)
    player.x =  box:getX()
    player.y =  box:getY()


    if love.keyboard.isDown("q") then
        love.event.quit()
    end

    -- box:setLinearVelocity(vx,vy)
    player.x = box:getX()
    player.y = box:getY()
    world:update(dt)
end
function love.draw()
    love.graphics.draw(background,0,0)
    love.graphics.draw(ground,0,(screen.h - 16))
    love.graphics.draw(player.sprite,player.x,player.y,nil,nil,nil,15,12)
    world:draw()
end
function love.keypressed(key)
    if key == 'space' then
      box:applyLinearImpulse(0, -1000)
    end
  end