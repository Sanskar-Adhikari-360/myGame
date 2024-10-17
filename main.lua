_G.love = require("love")
local bman = require 'simplebutton'
local anim8 = require 'libaries/anim8'
local sti = require "libaries/sti"
local butt = require "libaries/butt/butt"
local bman = require 'simplebutton'
gameMap = sti("maps/gameMap.lua")
local screen = {
    w = love.graphics.getWidth(),
    h = love.graphics.getHeight()
}

function love.load()
    love.graphics.setDefaultFilter("nearest","nearest")
    font = love.graphics.newFont(18)
    love.graphics.setFont(font)

    food = love.graphics.newImage('sprites/pixil-frame-0.png')
    background = love.graphics.newImage('sprites/background.png')
    _G.player = {}
    player.x = 40
    player.y = 60
    player.gameScore = 0
    player.eaten = false
    player.spriteSheet = love.graphics.newImage('sprites/snake-SWEN.png')
    player.grid = anim8.newGrid(32, 32, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())
    playerDirection = "down"

    player.animation = {}
    player.animation.down = anim8.newAnimation(player.grid('1-3', 1), 0.1)
    player.animation.left = anim8.newAnimation(player.grid('1-3', 2), 0.1)
    player.animation.right = anim8.newAnimation(player.grid('1-3', 3), 0.1)
    player.animation.up = anim8.newAnimation(player.grid('1-3', 4), 0.1)

    player.anim = player.animation.down

    foodState = {}
    math.randomseed(os.time())
    foodState.x = math.random(35, screen.w - 35)
    foodState.y = math.random(35, screen.h - 35)
    

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

    if running and love.keyboard.isDown("d", "right") then
        player.x = player.x + 1
        player.anim = player.animation.right
        player.animation.right:update(dt)
        playerDirection = "right"
    end
    if running and love.keyboard.isDown("a", "left") then
        player.x = player.x - 1
        player.anim = player.animation.left
        player.animation.left:update(dt)
        playerDirection = "left"
    end
    if running and love.keyboard.isDown("s", "down") then
        player.y = player.y + 1
        player.anim = player.animation.down
        player.animation.down:update(dt)
        playerDirection = "down"
    end
    if running and love.keyboard.isDown("w", "up") then
        player.y = player.y - 1
        player.anim = player.animation.up
        player.animation.up:update(dt)
        playerDirection = "up"
    end
    if running and playerDirection == "right" then
        player.x = player.x + 1
    end
    if running and playerDirection == "left" then
        player.x = player.x - 1
    end
    if running and playerDirection == "down" then
        player.y = player.y + 1
    end
    if running and playerDirection == "up" then
        player.y = player.y - 1
    end
    if running and love.keyboard.isDown("space") then
        running = false
        paused = true
    elseif paused and love.keyboard.isDown("space") then
        paused  = false
        running = true
    end

    
    bman.update(dt)
    function love.mousepressed(x, y, msbutton, istouch, presses)
    bman.mousepressed(x, y, msbutton)
end

function love.mousereleased(x, y, msbutton, istouch, presses)
    bman.mousereleased(x, y, msbutton)

end

end


function love.draw()
    bman.draw()
    gameMap:draw()
    player.anim:draw(player.spriteSheet, player.x, player.y, nil, nil, nil, 15, 15)

    dist = math.sqrt((player.x - foodState.x) ^ 2 + (player.y - foodState.y) ^ 2)
    if dist <= 10 then
        player.gameScore = player.gameScore + 1
        foodState.x = math.random(35, screen.w - 35)
        foodState.y = math.random(35, screen.h - 35)
        sounds.slurp:play()
    end
    love.graphics.print("Game Score:" .. player.gameScore)

    if not player.eaten then
        love.graphics.draw(food, foodState.x, foodState.y, nil, nil, nil, 40, 28)
    end
    
    if paused then
        love.graphics.print("Game Paused", 200, 200)
    end
    
    if player.x > 565 or player.x < 25 or player.y > 360 or player.y < 25 then
        love.graphics.clear()
        running = false
        ended = true
        love.graphics.print("GAME OVER YOU DEER")
        sounds.gameOver:play()
    end
    if menu then
        love.graphics.draw(background)
        local startButton = bman.new("Start Game", screen.w / 2 - 50, screen.h / 2 - 50)
        local exitButton = bman.new("Exit", screen.w / 2 - 50, screen.h / 2 - 50 + 50)
        startButton.onClick = function()
        menu = false
        running = true    
        end
        exitButton.onClick = function()
            love.event.quit()
        end
        bman.draw()
    end
end

