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
    food = love.graphics.newImage('sprites/pixil-frame-0.png')
    background = love.graphics.newImage('sprites/background.png')
    _G.player = {}
    player.x = 10
    player.y = 10
    math.randomseed(os.time())
    player.goalx = math.random(1, 500)
    player.goaly = math.random(1, 300)
    player.result = false
end

function love.update(dt)
    -- player.x = player.x + 4
    if player.x >= player.goalx then
        player.result = true
        
    end

    if love.keyboard.isDown("d") then
        player.x = player.x + 1
    end
    if love.keyboard.isDown("a") then
        player.x = player.x - 1
    end
        if love.keyboard.isDown("s") then
        player.y = player.y + 1
    end
        if love.keyboard.isDown("w") then
        player.y = player.y - 1
    end
end

function love.draw()
    love.graphics.setColor (61 / 255, 168 / 255, 167 / 255)
    love.graphics.draw(background,0,0)
    love.graphics.rectangle("fill",player.x,player.y,50,50)

    if not  player.result then
        love.graphics.draw (food,player.goalx,player.goaly)
        -- love.graphics.setColor (0, 0, 0)
        -- love.graphics.rectangle ("line", player.goalx, player.goaly, 40, 40)
        
    end

    if player.result then
    love.graphics.setColor (0, 0, 0)
    love.graphics.print("YOU WINN!!!")  
    end
end



