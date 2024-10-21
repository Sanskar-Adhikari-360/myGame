_G.love = require("love")

function love.load()
    player = {}
    player.x =  50
    player.y = 150
    player.sprite = love.graphics.newImage('sprites/bluebird-upflap.png')
end
function love.update(dt)
    if love.keyboard.isDown('q') then
        love.event.quit()
    end
    if love.keyboard.isDown('w') then
        player.y = player.y - 5
    end
    player.x = player.x + 5
end
function love.draw()
    love.graphics.draw(player.sprite,player.x,player.y)
end