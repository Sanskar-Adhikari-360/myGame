screen = {
    w = love.graphics.getWidth(),
    h = love.graphics.getHeight()
}

bird = {}
bird.image  = love.graphics.newImage("sprites/bluebird-upflap.png")
bird.width = bird.image:getWidth()
bird.height = bird.image:getHeight()
bird.x = screen.w/4
bird.y = screen.h/2

function birdRender()
    love.graphics.draw(bird.image,bird.x,bird.y,nil,nil,nil,16,16)
end