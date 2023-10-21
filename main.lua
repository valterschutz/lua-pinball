love = require "love"

gravity = 5
width = 512
height = 1024


local flipper_length = 80
Flipper = {
    start_x = width/2-flipper_length,
    -- start_x = 100,
    start_y = height-80,
    -- start_y = 100,
    width = flipper_length,
    height = 10,
    start_angle = 10,
    density = 1
}

Ball = {
    start_x = Flipper.start_x,
    start_y = 420,
    vx = 0,
    vy = 0,
    radius = 5,
    n_segments = 10,
    density = 1
}

function Flipper:new(o)
    o = o or {}
    self.__index = self
    setmetatable(o, self)
    -- o.hold_body = love.physics.newBody(world, o.start_x, o.start_y, "dynamic")
    o.hold_body = love.physics.newBody(world, 0, 0, "static")
    o.body = love.physics.newBody(world, o.start_x, o.start_y, "dynamic")
    o.shape = love.physics.newRectangleShape(o.width, o.height)
    o.fixture = love.physics.newFixture(o.body, o.shape, o.density)
    o.joint = love.physics.newRevoluteJoint(o.hold_body, o.body, o.start_x,o.start_y)
    o.joint:setMotorEnabled(true)
    o.joint:setMaxMotorTorque(1000) -- Set motor torque
    o.joint:setMotorSpeed(1)        -- Set motor speed (rotation speed)
    return o
end

function Flipper:draw()
    love.graphics.setColor(1,1,1)
    love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
end


function Ball:new(o)
    o = o or {}
    self.__index = self
    setmetatable(o, self)
    o.body = love.physics.newBody(world, o.start_x, o.start_y, "dynamic")
    o.shape = love.physics.newCircleShape(o.radius)
    o.fixture = love.physics.newFixture(o.body, o.shape, o.density)
    return o
end


function Ball:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.radius, self.segments)
end

function love.load()
    love.window.setMode(width, height)
    love.physics.setMeter(64)
    world = love.physics.newWorld(0, 64*gravity, true)
    ball = Ball:new()
    flipper = Flipper:new()
end

function love.update(dt)
    world:update(dt)
end

function love.draw()
    ball:draw()
    flipper:draw()
end
