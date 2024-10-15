

_G.love = require("love")

function love.load()
    -- anim8 = require 'libaries/anim8.lua'
    local anim8 = require 'libaries/anim8'
    local sti = require "libaries/sti"
    gameMap = sti("maps/gameMap.lua")

    food = love.graphics.newImage('sprites/pixil-frame-0.png')
    background = love.graphics.newImage('sprites/background.png')
    _G.player = {}
    player.x = 40
    player.y = 60
    player.gameScore = 0
    player.eaten = false
    player.spriteSheet = love.graphics.newImage('sprites/snake-SWEN.png')
    player.grid =  anim8.newGrid(32,32,player.spriteSheet:getWidth(),player.spriteSheet:getHeight()) 

    player.animation = {}
    player.animation.down = anim8.newAnimation(player.grid('1-3',1),0.1)
    player.animation.left = anim8.newAnimation(player.grid('1-3',2),0.1)
    player.animation.right = anim8.newAnimation(player.grid('1-3',3),0.1)
    player.animation.up = anim8.newAnimation(player.grid('1-3',4),0.1)

    player.anim = player.animation.down

    foodState = {}
    math.randomseed(os.time())
    foodState.x = math.random(1, 500)
    foodState.y = math.random(1, 300)
    
    sounds = {}
    sounds.slurp  = love.audio.newSource('audio/slurp.wav', 'static')
end

function love.update(dt)

    if love.keyboard.isDown("d","right") then
        player.x = player.x + 1
        player.anim = player.animation.right
        player.animation.right:update(dt)
    end
    if love.keyboard.isDown("a","left") then
        player.x = player.x - 1
        player.anim = player.animation.left
        player.animation.left:update(dt)
    end
        if love.keyboard.isDown("s","down") then
        player.y = player.y + 1
        player.anim = player.animation.down
        player.animation.down:update(dt)
    end
        if love.keyboard.isDown("w","up") then
        player.y = player.y - 1
        player.anim = player.animation.up
        player.animation.up:update(dt)
    end


end

function love.draw()
    
    -- love.graphics.setColor (61 / 255, 168 / 255, 167 / 255)
    -- love.graphics.draw(background,0,0)
    gameMap:draw()
    player.anim:draw(player.spriteSheet,player.x,player.y,nil,nil,nil,15,15)

    dist = math.sqrt((player.x - foodState.x)^2 + (player.y - foodState.y)^2)
    if dist <= 10 then 
        player.gameScore = player.gameScore + 1
        foodState.x = math.random(1, 500)
        foodState.y = math.random(1, 300)
        sounds.slurp:play()
    end
    love.graphics.print("Game Score:" ..  player.gameScore)  

    if not  player.eaten then
        love.graphics.draw (food,foodState.x,foodState.y,nil,nil,nil,40,28)
    end
end



