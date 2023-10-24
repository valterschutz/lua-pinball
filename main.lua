local love = require "love"

local lib = require "lib"
local Timer = require "timer"

local Ball = lib.Ball
local Flipper = lib.Flipper
local Edge = lib.Edge
local create_wall = lib.create_wall

love.physics.setMeter(64)
love.keyboard.setKeyRepeat(false)

G_gravity = 10
G_screen_width = 512
G_screen_height = 1024
G_flipper_width = 100
G_flipper_height = 10
G_flipper_gap = 10
G_flipper_y_pos = G_screen_height-80


local ball, lflipper, rflipper, lwall, rwall, ceil, lborder, rborder
function love.load()
    love.window.setMode(G_screen_width, G_screen_height)
    G_world = love.physics.newWorld(0, 64*G_gravity, true)
    ball = Ball:new()
    lflipper = Flipper:new("left")
    rflipper = Flipper:new("right")
    lwall = create_wall("left")
    rwall = create_wall("right")
    ceil = Edge:new(0, 0, G_screen_width, 0)
    lborder = Edge:new(0, 0, 0, G_screen_height)
    rborder = Edge:new(G_screen_width, 0, G_screen_width, G_screen_height)
end

function love.update(dt)
    Timer.update(dt)
    G_world:update(dt)
end

function love.draw()
    ball:draw()
    lflipper:draw()
    rflipper:draw()
    lwall:draw()
    rwall:draw()
    ceil:draw()
    lborder:draw()
    rborder:draw()
end

function love.keypressed(key)
    if key == "left" then
        lflipper:activate()
    end
    if key == "right" then
        rflipper:activate()
    end
end

function love.keyreleased(key)
    if key == "left" then
        lflipper:deactivate()
    end
    if key == "right" then
        rflipper:deactivate()
    end
end
