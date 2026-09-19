if os.getenv("LOVE2D_TOOLS") then
	pcall(require, "_love2d_tools_bridge")
end

function love.load()
	RNG = love.math.newRandomGenerator() -- create  a global rng machine
	RNG:setSeed(os.time()) -- set the seed so runs can be reproduced in the future

	fish_to_catch = 5
	background_image = love.graphics.newImage("assets/background.png")
	water_overlay = love.graphics.newImage("assets/water.png")
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.window.setMode(background_image:getWidth(), background_image:getHeight(), {
		resizable = true,
	})

	world = love.physics.newWorld(0, 10 * 64, true)

	line_start_x = 215
	line_start_y = 6
	line_time = 0

	top_of_line = love.physics.newBody(world, line_start_x, line_start_y, "kinematic")
	bobber = love.physics.newBody(world, 190, 600, "dynamic")

	rope = love.physics.newRopeJoint(top_of_line, bobber, line_start_x, line_start_y, bobber:getX(), bobber:getY(), 450)

	bobber_radius = 2.5 * math.pi
end

function love.update(dt)
	local line_time = line_time + dt

	top_of_line:setPosition(line_start_x, line_start_y)
	world:update(dt)

	local line_x = bobber:getX() - top_of_line:getX()
	local line_y = bobber:getY() - top_of_line:getY()

	-- Measure the signed angle from straight down so left and right swings
	-- rotate the bobber in opposite directions.
	bobber_angle = math.atan2(line_x, line_y) * -1
end

-- Calls the code below every time a key is presed
function love.keypressed(key, scancode, isrepeat)
	if key == "space" then
		fish_to_catch = fish_to_catch - 1
	end
end

function love.draw()
	love.graphics.setColor(1, 1, 1)
	local scale = math.max(
		love.graphics.getWidth() / background_image:getWidth(),
		love.graphics.getHeight() / background_image:getHeight()
	)

	-- Draw the background
	local background_x = (love.graphics.getWidth() - background_image:getWidth() * scale) / 2
	local background_y = (love.graphics.getHeight() - background_image:getHeight() * scale) / 2

	love.graphics.draw(background_image, background_x, background_y, 0, scale, scale)

	-- Draw the fishing line
	local top_of_line_x, top_of_line_y = top_of_line:getPosition()
	local bobber_x, bobber_y = bobber:getPosition()
	love.graphics.setColor(0, 0, 0)
	love.graphics.line(top_of_line_x, top_of_line_y, bobber_x, bobber_y)
	love.graphics.setColor(1, 1, 1)
	love.graphics.arc("fill", bobber_x, bobber_y, bobber_radius, bobber_angle, bobber_angle + math.pi)
	love.graphics.setColor(1, 0, 0)
	love.graphics.arc("fill", bobber_x, bobber_y, bobber_radius, bobber_angle + math.pi, bobber_angle + (2 * math.pi))

	-- Draw the overlayed water for depth
	love.graphics.setColor(1, 1, 1, 0.75)
	love.graphics.draw(water_overlay, background_x, background_y, 0, scale, scale)
end
