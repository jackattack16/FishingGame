local game = require("src.game_functions")
local render = require("src.render")
local game_state = require("src.globals.globals")
local rng
local container = require("src.ui.container")
local elapsed = 0
local fishing_line = require("src.fishing_line")

if os.getenv("LOVE2D_TOOLS") then
	pcall(require, "_love2d_tools_bridge")
end

function love.load()
	love.window.maximize()
	rng = love.math.newRandomGenerator()
	rng:setSeed(os.time()) -- use a fresh seed each time the game starts

	game_state.pond = game.make_pond(50, rng)
	render.load()
	local screen_width, screen_height = love.graphics.getDimensions()
	left_bar = container:new(
		0,
		0,
		"10%",
		"85%",
		10,
		10,
		"column",
		"together",
		{ wrap = true, gap = 2, bg_color = { 0, 0, 0, 0.5 } }
	)

	left_bar:add_element("textbox", {
		text = "Money: $${money}$",
		width = 100,
		bg_color = { 0, 0, 0, 0 },
		text_color = { 1, 1, 1 },
		variables = {
			money = function()
				return game_state.money
			end,
		},
	})
	left_bar:add_element("textbox", {
		text = "Bait: ${bait}$",
		width = 100,
		bg_color = { 0, 0, 0, 0 },
		text_color = { 1, 1, 1 },
		variables = {
			bait = function()
				return game_state.bait_left
			end,
		},
	})
	left_bar:add_element("textbox", {
		text = "Press y to save catch",
		width = 100,
		y_padding = 5,
		bg_color = { 0, 0, 0, 0 },
		text_color = { 1, 1, 1 },
	})
	left_bar:add_element("textbox", {
		text = "Press n to release catch",
		width = 100,
		y_padding = 5,
		bg_color = { 0, 0, 0, 0 },
		text_color = { 1, 1, 1 },
	})
	bottom_bar = container:new(
		0,
		"85%",
		"full",
		"15%",
		10,
		10,
		"row",
		"together",
		{ wrap = true, gap = 10, bg_color = { 0, 0, 0, 0.5 } }
	)
	bottom_bar:add_element("button", {
		text = "Settings",
		bg_color = { 0.153, 0.153, 0.153 },
		height = 100,
		width = 10,
	})
	water_shader = love.graphics.newShader("src/shaders/water.frag")
	distort_shader = love.graphics.newShader("src/shaders/distort.frag")
	pixelate_shader = love.graphics.newShader("src/shaders/pixelate.frag")
	grain_shader = love.graphics.newShader("src/shaders/grain.frag")

	local particle_image = love.graphics.newImage("assets/sprites/fish_particle.png")
	particle_system = love.graphics.newParticleSystem(particle_image, 100)
	particle_system:setParticleLifetime(1, 50)
	particle_system:setEmissionRate(5)
	particle_system:setDirection(0)
	particle_system:setLinearAcceleration(2, -0.25, 4, 0.25)
	particle_system:setEmissionArea("uniform", 25, screen_height, 0)
	particle_system:setColors(1, 1, 1, 1, 1, 1, 1, 0)
	particle_system:setSpeed(2, 3)
	particle_system:emit(50)

	local fishing_line_x = (love.graphics.getWidth() - love.graphics.getWidth() * 0.1) / 2
		+ (love.graphics.getWidth() * 0.1)
	my_fishing_line = fishing_line:new(fishing_line_x)
end

function love.mousepressed(x, y, mouse_button) end

function love.update(dt)
	elapsed = elapsed + dt
	particle_system:update(dt)
	my_fishing_line:animate(dt)
end

function love.resize()
	render.resize()
	left_bar:layout()
	bottom_bar:layout()
end

function love.keypressed(key, scancode, isrepeat)
	if key == "space" then
		if check_requirements("can_catch_fish") then
			game_state.current_fish = game.catch_fish(game_state.pond, game_state.bait_left)
			if game_state.current_fish then
				my_fishing_line:start_catching_animation(game_state.current_fish)
			end

			game_state.state = "fish_caught"
		end
	end

	if key == "y" then
		if check_requirements("can_release_or_save") then
			game_state.fish_caught_this_round[#game_state.fish_caught_this_round + 1] = game_state.current_fish
			game_state.current_fish = false
			my_fishing_line:start_reset_animation()

			game_state.bait_left = game_state.bait_left - 1
			if game_state.bait_left == 0 then
				game_state.state = "shop"
			else
				game_state.state = "catching"
			end
		end
	end

	if key == "n" then
		if check_requirements("can_release_or_save") then
			game_state.fish_released_this_round[#game_state.fish_released_this_round + 1] = game_state.current_fish
			game_state.current_fish = false
			my_fishing_line:start_reset_animation()

			game_state.bait_left = game_state.bait_left - 1
			if game_state.bait_left == 0 then
				game_state.state = "shop"
			else
				game_state.state = "catching"
			end
		end
	end
end

function love.draw()
	local pixel_width, pixel_height = love.graphics.getPixelDimensions()
	water_shader:send("u_resolution", { pixel_width, pixel_height })
	water_shader:send("u_time", elapsed)
	distort_shader:send("u_time", elapsed)
	grain_shader:send("u_time", elapsed)

	render.render_game()
end

---@param check_for "can_catch_fish" | "can_release_or_save"
---@return boolean
function check_requirements(check_for)
	if check_for == "can_catch_fish" then
		if game_state.state == "catching" and my_fishing_line.state == "idle" and game_state.bait_left > 0 then
			return true
		else
			return false
		end
	end

	if check_for == "can_release_or_save" then
		if
			game_state.state == "fish_caught"
			and my_fishing_line.state == "fish_caught"
			and game_state.bait_left > 0
		then
			return true
		else
			return false
		end
	end

	return false
end
