if os.getenv("LOVE2D_TOOLS") then
	pcall(require, "_love2d_tools_bridge")
end
function love.load()
	RNG = love.math.newRandomGenerator() -- create  a global rng machine
	RNG:setSeed(os.time()) -- set the seed so runs can be reproduced in the future

	fish_to_catch = 5
	background_image = love.graphics.newImage("assets/background.png")
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.window.setMode(background_image:getWidth(), background_image:getHeight(), {
		resizable = true,
	})
end

function love.update(dt) end

-- Calls the code below every time a key is presed
function love.keypressed(key, scancode, isrepeat)
	if key == "space" then
		fish_to_catch = fish_to_catch - 1
	end
end

function love.draw()
	local scale = math.max(
		love.graphics.getWidth() / background_image:getWidth(),
		love.graphics.getHeight() / background_image:getHeight()
	)

	local x = (love.graphics.getWidth() - background_image:getWidth() * scale) / 2
	local y = (love.graphics.getHeight() - background_image:getHeight() * scale) / 2

	love.graphics.draw(background_image, x, y, 0, scale, scale)
end
