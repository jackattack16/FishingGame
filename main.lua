if os.getenv("LOVE2D_TOOLS") then
	pcall(require, "_love2d_tools_bridge")
end
function love.load()
	RNG = love.math.newRandomGenerator() -- create  a global rng machine
	RNG:setSeed(os.time()) -- set the seed so runs can be reproduced in the future

	fish_to_catch = 5
end

function love.update(dt) end

-- Calls the code below every time a key is presed
function love.keypressed(key, scancode, isrepeat)
	if key == "space" then
		fish_to_catch = fish_to_catch - 1
	end
end

function love.draw()
	local background = love.graphics.newImage("assets/background.png")
	local background_x_scale = love.graphics.getWidth() / background:getWidth()
	local background_y_scale = love.graphics.getHeight() / background:getHeight()

	love.graphics.draw(background, 0, 0, 0, background_x_scale, background_y_scale)
	love.graphics.print('FishingGame, press space to "catch" a fish', 24, 24)
	love.graphics.print("Fish left: " .. fish_to_catch, 25, love.graphics.getHeight() - 50)
end
