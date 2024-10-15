-- _G.love = require("love")

-- function love.load()
--     -- love.graphics.setBackgroundColor (181 / 255, 92 / 255, 157 / 255)
--     background = love.graphics.newImage('sprites/background.png')
--     _G.sally = {}
--     _G.sally.x = 10
--     _G.sally.y = 10
--     math.randomseed(os.time())
--     _G.sally.goalx = math.random(1, 500)
--     _G.sally.goaly = math.random(1, 300)
--     _G.sally.result = false
-- end

-- function love.update(dt)
--     -- sally.x = sally.x + 4
--     if sally.x >= sally.goalx then
--         sally.result = true
        
--     end

--     if love.keyboard.isDown("d") then
--         sally.x = sally.x + 1
--     end
--     if love.keyboard.isDown("a") then
--         sally.x = sally.x - 1
--     end
--         if love.keyboard.isDown("s") then
--         sally.y = sally.y + 1
--     end
--         if love.keyboard.isDown("w") then
--         sally.y = sally.y - 1
--     end
-- end

-- function love.draw()
--     love.graphics.draw(background, 0,  0)
--     love.graphics.setColor (61 / 255, 168 / 255, 167 / 255)
--     love.graphics.rectangle("fill",sally.x,sally.y,50,50)

--     if not  sally.result then
--         love.graphics.setColor (0, 0, 0)
--         love.graphics.rectangle ("line", sally.goalx, sally.goaly, 40, 40)
        
--     end

--     if sally.result then
--     love.graphics.setColor (0, 0, 0)
--     love.graphics.print("YOU WINN!!!")  
--     end
-- end

_G.love = require("love")

function love.load()
    -- anim8 = require 'libaries/anim8.lua'
    local anim8 = require 'libaries/anim8'

    food = love.graphics.newImage('sprites/pixil-frame-0.png')
    background = love.graphics.newImage('sprites/background.png')
    _G.player = {}
    player.x = 10
    player.y = 10
    math.randomseed(os.time())
    player.goalx = math.random(1, 500)
    player.goaly = math.random(1, 300)
    player.result = false
    player.spriteSheet = love.graphics.newImage('sprites/snake-SWEN.png')
    player.grid =  anim8.newGrid(32,32,player.spriteSheet:getWidth(),player.spriteSheet:getHeight()) 

    player.animation = {}
    player.animation.down = anim8.newAnimation(player.grid('1-3',1),  0.1)
    player.animation.left = anim8.newAnimation(player.grid('1-3',2),  0.1)
    player.animation.right = anim8.newAnimation(player.grid('1-3',3),  0.1)
    player.animation.up = anim8.newAnimation(player.grid('1-3',4),  0.1)

    player.anim = player.animation.down
end

function love.update(dt)
    -- player.x = player.x + 4
    if player.x >= player.goalx and  player.y >= player.goaly then
        player.result = true
    end

    if love.keyboard.isDown("d","right") then
        player.x = player.x + 1
        player.anim = player.animation.right
    end
    if love.keyboard.isDown("a","left") then
        player.x = player.x - 1
        player.anim = player.animation.left
    end
        if love.keyboard.isDown("s","down") then
        player.y = player.y + 1
        player.anim = player.animation.down
    end
        if love.keyboard.isDown("w","up") then
        player.y = player.y - 1
        player.anim = player.animation.up
    end
    player.animation.down:update(dt)
end

function love.draw()
    -- love.graphics.setColor (61 / 255, 168 / 255, 167 / 255)
    love.graphics.draw(background,0,0)
    -- love.graphics.rectangle("fill",player.x,player.y,50,50)
    player.anim:draw(player.spriteSheet,player.x,player.y)

    if not  player.result then
        love.graphics.draw (food,player.goalx,player.goaly)
        -- love.graphics.setColor (0, 0, 0)
        -- love.graphics.rectangle ("line", player.goalx, player.goaly, 40, 40)
        
    end

    if player.result then
    -- love.graphics.setColor (0, 0, 0)
    love.graphics.print("YOU WINN!!!")  
    end
end



