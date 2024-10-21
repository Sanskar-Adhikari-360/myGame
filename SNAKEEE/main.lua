_G.love = require("love")
local bman = require 'simplebutton'
local anim8 = require 'libaries/anim8'
local sti = require "libaries/sti"
local bman = require ('simplebutton')
local Moan = require('libaries/Moan')
local camera = require("libaries/camera")
local cam = camera()
local wf = require ('libaries/windfield')
gameMap = sti("maps/testMap.lua")
local screen = {
    w = love.graphics.getWidth(),
    h = love.graphics.getHeight()
}

function love.load()
    world = wf.newWorld(0,0)
    world:addCollisionClass('Player')
    world:addCollisionClass('Wall')
    love.graphics.setDefaultFilter("nearest","nearest")
    font = love.graphics.newFont(18)
    love.graphics.setFont(font)

    food = love.graphics.newImage('sprites/pixil-frame-0.png')
    background = love.graphics.newImage('sprites/background.png')
    _G.player = {}
    player.collider =  world:newRectangleCollider(410,65,12,12)
    player.collider:setCollisionClass('Player')
    player.x = 40
    player.y = 60
    player.gameScore = 0
    player.eaten = false
    player.spriteSheet = love.graphics.newImage('sprites/snake-SWEN.png')
    player.grid = anim8.newGrid(32, 32, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())
    playerDirection = "right"
    player.speed = 300

    player.animation = {}
    player.animation.down = anim8.newAnimation(player.grid('1-3', 1), 0.1)
    player.animation.left = anim8.newAnimation(player.grid('1-3', 2), 0.1)
    player.animation.right = anim8.newAnimation(player.grid('1-3', 3), 0.1)
    player.animation.up = anim8.newAnimation(player.grid('1-3', 4), 0.1)

    player.anim = player.animation.right

    walls = {}
    if gameMap.layers["DNIobject"] then
        for i, obj in ipairs(gameMap.layers["DNIobject"].objects) do
            local wall = world:newRectangleCollider(obj.x,obj.y,obj.width,obj.height)
            wall:setType('static')
            wall:setCollisionClass('Wall')
            table.insert(walls, wall)
            if obj.x then
               print(obj.x)
            end        
        end
    end

    foodState = {}
    math.randomseed(os.time())
    foodState.x = math.random(600, 1430)
    foodState.y = math.random(0,875)
    

    sounds = {}
    sounds.slurp = love.audio.newSource('audio/slurp.wav', 'static')
    sounds.gameOver = love.audio.newSource('audio/gameOver.wav', 'static')

    state = {}
    menu = true
    paused = false
    running = false
    ended = false

    bman.default.width = 100
    bman.default.height = 40
    bman.default.alignment = 'center'

end

function love.update(dt)

    if player.collider:enter('wall') then
        player.collider:applyLinearImpulse(1000, 0)
        player.collider:applyAngularImpulse(5000)
    end

    local vx = 0
    local vy = 0
    if not paused and running and love.keyboard.isDown("d", "right") then
        vx = player.speed 
        player.anim = player.animation.right
        player.animation.right:update(dt)
        playerDirection = "right"
    end
    if not paused and running and love.keyboard.isDown("a", "left") then
        vx = player.speed*-1
        player.anim = player.animation.left
        player.animation.left:update(dt)
        playerDirection = "left"
    end
    if not paused and running and love.keyboard.isDown("s", "down") then
       vy = player.speed
        player.anim = player.animation.down
        player.animation.down:update(dt)
        playerDirection = "down"
    end
    if not paused and running and love.keyboard.isDown("w", "up") then
        vy = player.speed*-1
        player.anim = player.animation.up
        player.animation.up:update(dt)
        playerDirection = "up"
    end

    player.collider:setLinearVelocity(vx,vy)
    
    -- if not paused and running and playerDirection == "right" then
    --     player.x = player.x + 1 + player.speed
    --     player.anim = player.animation.right
    --     player.animation.right:update(dt)
    -- end
    -- if not paused and running and playerDirection == "left" then
    --     player.x = player.x - 1 - player.speed
    --     player.anim = player.animation.left
    --     player.animation.left:update(dt)
    -- end
    -- if not paused and running and playerDirection == "down" then
    --     player.y = player.y + 1 + player.speed
    --     player.anim = player.animation.down
    --     player.animation.down:update(dt)
    -- end
    -- if not paused and running and playerDirection == "up" then
    --     player.y = player.y - 1 - player.speed
    --     player.anim = player.animation.up
    --     player.animation.up:update(dt)
    -- end
    -- if not paused and  running and love.keyboard.isDown("space") then
    --     running = false
    --     paused = true
    -- elseif paused and love.keyboard.isDown("space") then
    --     paused  = false
    --     running = true
    -- end


    
    bman.update(dt)
    function love.mousepressed(x, y, msbutton, istouch, presses)
    bman.mousepressed(x, y, msbutton)
end

function love.mousereleased(x, y, msbutton, istouch, presses)
    bman.mousereleased(x, y, msbutton)

end

    -- if player.gameScore >= 5 then
    --     player.speed = player.speed*0.2
    -- end
    -- if player.gameScore  >= 10 then
    --     player.speed = player.speed*0.3
    -- end
    -- if player.gameScore  >= 15 then
    --     player.speed = player.speed*0.4
    -- end
    -- if player.gameScore >=  20 then
    --     player.speed = player.speed*0.5
    -- end
    -- if player.gameScore  >= 25 then
    --     player.speed  = player.speed*0.6
    -- end
    cam:lookAt(player.x,player.y)
    if cam.x < screen.w/2 then
        cam.x = screen.w/2
    end 
    if cam.y < screen.h/2 then
        cam.y = screen.h/2
    end
    local mapW = gameMap.width*gameMap.tilewidth 
    local mapH = gameMap.height*gameMap.tileheight

    -- RIght border of the map
    if cam.x >  (mapW - screen.w/2) then
    cam.x  = (mapW - screen.w/2)
    end
        -- Left border of the map
        if cam.y >  (mapH - screen.h/2) then
            cam.y  = (mapH - screen.h/2)
            end
    world:update(dt)
    player.x = player.collider:getX()
    player.y = player.collider:getY()

    if player.collider:enter('Wall') then
        running = false
        ended = true
    end
end


function love.draw()
    cam:attach()
        gameMap:drawLayer(gameMap.layers["Grass"])
        gameMap:drawLayer(gameMap.layers["Trees"])
        gameMap:drawLayer(gameMap.layers["More tress"])
        player.anim:draw(player.spriteSheet, player.x, player.y, nil, nil, nil, 15, 15)
        if not player.eaten then
            love.graphics.draw(food, foodState.x, foodState.y, nil, nil, nil, 40, 28)
        end
        world:draw()
    cam:detach()
    dist = math.sqrt((player.x - foodState.x) ^ 2 + (player.y - foodState.y) ^ 2)
    if dist <= 10 then
        player.gameScore = player.gameScore + 1
        foodState.x = math.random(600, 1430)
        foodState.y = math.random(0,875)
        sounds.slurp:play()
    end
    print("X is: " .. player.x .. "Y is: " .. player.y)
    love.graphics.print("Game Score:" .. player.gameScore,15,15)

    -- if not player.eaten then
    --     love.graphics.draw(food, foodState.x, foodState.y, nil, nil, nil, 40, 28)
    -- end
    if paused then
        love.graphics.print("Game Paused", 200, 200)
    end
    
    if player.x > 565 or player.x < 25 or player.y > 360 or player.y < 25 then
        running = true
        ended = false

    end
    if not running and ended then
        gameoverOverlay("fill",50,50,screen.w-100,screen.h-100,{0.5,0.5,0.5,0.5})
    end

    if menu then
        love.graphics.draw(background)
        local startButton = bman.new("Start Game", screen.w / 2 - 50, screen.h / 2 - 50)
        local exitButton = bman.new("Exit", screen.w / 2 - 50, screen.h / 2 - 50 + 50)
        startButton.onClick = function()
        love.graphics.clear()
        menu = false
        running = true    
        end
        exitButton.onClick = function()
            love.event.quit()
        end
        bman.draw(startButton)
        bman.draw(exitButton)
    end

end


function gameoverOverlay(mode,x,y,width,height,bodyColor)
    love.graphics.setColor(bodyColor)
    love.graphics.rectangle(mode,x,y,width,height)
    love.graphics.setColor(1,1,1)
    love.graphics.print("GAME OVER!!",x+width*0.4,y+height*0.4)
    love.graphics.print(("YOUR SCORE WAS: " .. player.gameScore),x+width*0.35,y+height*0.4 + 40)
    love.graphics.print("DO YOU WISH TO TRY AGAIN?",x+width*0.3,y+height*0.4 + 80)
    local gameoverOverlayYesButton = bman.new("YES",  x+width*0.2, y+height*0.8)
    local gameoverOverlayNoButton = bman.new("NO", x+width*0.6, y+height*0.8)
    bman.draw(gameoverOverlayYesButton)
    bman.draw(gameoverOverlayNoButton)
    gameoverOverlayNoButton.onClick = function()
    ended  = false
    menu = true
    end
    gameoverOverlayYesButton.onClick = function()
        player.x = 40  
        player.y = 60
        player.gameScore = 0
        playerDirection = "down"
        ended = false
        running = true
    end
end