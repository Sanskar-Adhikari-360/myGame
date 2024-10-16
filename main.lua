_G.love = require("love")
local bman = require 'simplebutton'
local anim8 = require 'libaries/anim8'
local sti = require "libaries/sti"
local bman = require 'simplebutton'
local Moan = require('libaries/Moan')
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
    player.speed = 0

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
        player.x = player.x + 1 + player.speed
        player.anim = player.animation.right
        player.animation.right:update(dt)
        playerDirection = "right"
    end
    if running and love.keyboard.isDown("a", "left") then
        player.x = player.x - 1 - player.speed
        player.anim = player.animation.left
        player.animation.left:update(dt)
        playerDirection = "left"
    end
    if running and love.keyboard.isDown("s", "down") then
        player.y = player.y + 1 + player.speed
        player.anim = player.animation.down
        player.animation.down:update(dt)
        playerDirection = "down"
    end
    if running and love.keyboard.isDown("w", "up") then
        player.y = player.y - 1 - player.speed
        player.anim = player.animation.up
        player.animation.up:update(dt)
        playerDirection = "up"
    end
    if running and playerDirection == "right" then
        player.x = player.x + 1 + player.speed
        player.anim = player.animation.right
        player.animation.right:update(dt)
    end
    if running and playerDirection == "left" then
        player.x = player.x - 1 - player.speed
        player.anim = player.animation.left
        player.animation.left:update(dt)
    end
    if running and playerDirection == "down" then
        player.y = player.y + 1 + player.speed
        player.anim = player.animation.down
        player.animation.down:update(dt)
    end
    if running and playerDirection == "up" then
        player.y = player.y - 1 - player.speed
        player.anim = player.animation.up
        player.animation.up:update(dt)
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

    if player.gameScore >= 5 then
        player.speed = 0.2
    end
    if player.gameScore  >= 10 then
        player.speed = 0.3
    end
    if player.gameScore  >= 15 then
        player.speed = 0.4
    end
    if player.gameScore >=  20 then
        player.speed = 0.5
    end
    if player.gameScore  >= 25 then
        player.speed  = 0.6
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
    love.graphics.print("Game Score:" .. player.gameScore,15,15)

    if not player.eaten then
        love.graphics.draw(food, foodState.x, foodState.y, nil, nil, nil, 40, 28)
    end
    
    if paused then
        love.graphics.print("Game Paused", 200, 200)
    end
    
    if player.x > 565 or player.x < 25 or player.y > 360 or player.y < 25 then
        running = false
        ended = true

    end
    if not running and ended then
        gameoverOverlay("fill",50,50,screen.w-100,screen.h-100,{0.5,0.5,0.5,0.5})
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
        bman.draw(startButton)
        bman.draw(exitButton)
    end
end

function gameoverOverlay(mode,x,y,width,height,bodyColor)
    
    gameMap:draw()
    love.graphics.setColor(bodyColor)
    love.graphics.rectangle(mode,x,y,width,height)
    love.graphics.setColor(1,1,1)
    love.graphics.print("GAME OVER!!",x+width*0.4,y+height*0.4)
    love.graphics.print(("YOUR SCORE WAS: " .. player.gameScore),x+width*0.35,y+height*0.4 + 40)
    love.graphics.print("DO YOU WISH TO TRY AGAIN?",x+width - 360,y+height*0.4 + 80)
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