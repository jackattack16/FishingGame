if os.getenv("LOVE2D_TOOLS") then
	pcall(require, "_love2d_tools_bridge")
end
function love.load()
	RNG = love.math.newRandomGenerator() -- create  a global rng machine
	RNG:setSeed(os.time()) -- set the seed so runs can be reproduced in the future
end

function love.update(dt) end

function love.draw()
	love.graphics.print("FishingGame", 24, 24)
end
