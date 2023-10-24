local Timer = require "timer"
local love = require "love"

local Flipper = {}

function Flipper:new(type)
    local start_x = G_screen_width/2 +
        (type == "left" and -G_flipper_width or G_flipper_width)/2 +
        (type == "left" and -G_flipper_gap or G_flipper_gap)
    local o = {
        start_x = start_x,
        start_y = G_flipper_y_pos,
        width = G_flipper_width,
        height = G_flipper_height,
        start_angle = 10,
        density = 0.01,
        speed = type == "left" and 10 or -10
    }
    self.__index = self
    setmetatable(o, self)
    o.hold_body = love.physics.newBody(G_world, o.start_x, o.start_y, "static")
    o.body = love.physics.newBody(G_world, o.start_x, o.start_y, "dynamic")
    o.shape = love.physics.newRectangleShape(o.width, o.height)
    o.fixture = love.physics.newFixture(o.body, o.shape, o.density)
    local joint_x = o.start_x + (type == "left" and -o.width/2 or o.width/2)
    o.joint = love.physics.newRevoluteJoint(o.hold_body, o.body, joint_x, o.start_y)
    o.joint:setMotorEnabled(true)
    o.joint:setMaxMotorTorque(1000000)
    o.joint:setMotorSpeed(0)
    local lower_limit = type == "left" and -math.pi/4 or -math.pi/8
    local upper_limit = type == "left" and math.pi/8 or math.pi/4
    o.joint:setLimits(lower_limit, upper_limit)
    o.joint:setLimitsEnabled(true)
    o.is_up = false
    return o
end

function Flipper:ignore_limits()
    -- print("inside ignore limits")
    self.joint:setLimitsEnabled(false)
    Timer.after(0.01, function()
        self.joint:setLimitsEnabled(true)
        -- print("limits enabled?")
    end)
end

function Flipper:activate()
    self:ignore_limits()
    self.joint:setMotorSpeed(-self.speed)
    self.is_up = true
end

function Flipper:deactivate()
    self:ignore_limits()
    self.joint:setMotorSpeed(self.speed)
    self.is_up = false
end

function Flipper:toggle()
    if self.is_up then
        self:deactivate()
    else
        self:activate()
    end
end

function Flipper:draw()
    love.graphics.setColor(1,1,1)
    love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
end

local Ball = {}

function Ball:new()
    local o = {
        start_x = 50,
        start_y = 10,
        vx = 0,
        vy = 0,
        radius = 10,
        n_segments = 10,
        density = 0.01
    }
    self.__index = self
    setmetatable(o, self)
    o.body = love.physics.newBody(G_world, o.start_x, o.start_y, "dynamic")
    o.shape = love.physics.newCircleShape(o.radius)
    o.fixture = love.physics.newFixture(o.body, o.shape, o.density)
    o.fixture:setRestitution(0.5)
    return o
end


function Ball:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.radius, self.segments)
end

local Edge = {}
function Edge:new(x1, y1, x2, y2)
    local o = {}
    self.__index = self
    setmetatable(o, self)
    local mx = (x1+x2)/2
    local my = (y1+y2)/2
    o.body = love.physics.newBody(G_world, mx, my, "static")
    local dx, dy = x1-x2, y1-y2
    o.shape = love.physics.newEdgeShape(-dx/2, -dy/2, dx/2, dy/2)
    o.fixture = love.physics.newFixture(o.body, o.shape)
    return o
end

function Edge:draw()
    love.graphics.line(self.body:getWorldPoints(self.shape:getPoints()))
end

local function create_wall(type)
    local x1, y1, x2, y2
    if type == "left" then
        x1 = 0
        y1 = G_screen_height/5
        x2 = G_screen_width/2-G_flipper_width-15
        y2 = G_flipper_y_pos
    elseif type == "right" then
        x1 = G_screen_width
        y1 = G_screen_height/5
        x2 = G_screen_width/2+G_flipper_width+15
        y2 = G_flipper_y_pos
    end
    return Edge:new(x1, y1, x2, y2)
end


return {
    Flipper = Flipper,
    Ball = Ball,
    Edge = Edge,
    create_wall = create_wall
}
