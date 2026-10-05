local game = require("src.game_functions")
local render = require("src.render")
local game_state = require("src.globals.globals")
local rng
local UI = require("src.ui.json_ui")
local elapsed = 0
local fishing_line = require("src.fishing_line")
local shop = require("src.shop")
local fish_transfer = require("src.fish_transfer")

if os.getenv("LOVE2D_TOOLS") then
	pcall(require, "_love2d_tools_bridge")
end

function love.load()
	love.window.maximize()
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.graphics.setLineStyle("rough")
	local font_settings = shop.theme.fonts
	love.graphics.setFont(
		font_settings.path and love.graphics.newFont(font_settings.path, font_settings.default)
			or love.graphics.newFont(font_settings.default)
	)
	rng = love.math.newRandomGenerator()
	rng:setSeed(os.time()) -- use a fresh seed each time the game starts
	shop.rng = rng
	shop.load()

	game_state.pond = game.make_pond(50, rng)
	render.load()
	local screen_width, screen_height = love.graphics.getDimensions()
	local hud = UI.load("assets/ui/fishing_hud.json", {
		money = function()
			return game_state.money
		end,
		bait = function()
			return game_state.bait_left
		end,
	})
	left_bar, bottom_bar = hud.by_id.left_bar, hud.by_id.bottom_bar
	water_shader = love.graphics.newShader("src/shaders/water.frag")
	distort_shader = love.graphics.newShader("src/shaders/distort.frag")
	pixelate_shader = love.graphics.newShader("src/shaders/pixelate.frag")
	grain_shader = love.graphics.newShader("src/shaders/grain.frag")

	-- Particle sprite sheet: 16x16 tiles, fish is first, bubble is second.
	-- ParticleSystems render the whole source image per particle, so each tile
	-- gets sliced into its own 16x16 canvas.
	local TILE_SIZE = 16
	local particle_sheet = love.graphics.newImage("assets/sprites/particles.png")

	local function make_tile_image(tile_index)
		local tile = love.graphics.newCanvas(TILE_SIZE, TILE_SIZE)
		tile:setFilter("nearest", "nearest")
		love.graphics.push("all")
		love.graphics.setCanvas(tile)
		love.graphics.clear(0, 0, 0, 0)
		love.graphics.draw(particle_sheet, 0, 0, 0, 1, 1, (tile_index - 1) * TILE_SIZE, 0)
		love.graphics.pop()
		return tile
	end

	local fish_particle_image = make_tile_image(1)
	local bubble_particle_image = make_tile_image(2)

	-- A small school of fish that swim steadily across the screen, left to right.
	particle_system = love.graphics.newParticleSystem(fish_particle_image, 30)
	particle_system:setParticleLifetime(22, 32)
	particle_system:setEmissionRate(1)
	particle_system:setDirection(0)
	particle_system:setSpread(0.08)
	particle_system:setSpeed(65, 105)
	particle_system:setLinearAcceleration(0, -0.5, 0, 0.5)
	particle_system:setEmissionArea("uniform", 25, screen_height, 0)
	particle_system:setColors(1, 1, 1, 1, 1, 1, 1, 0)
	particle_system:emit(8)

	-- Occasional bubbles rising from the bottom.
	bubble_system = love.graphics.newParticleSystem(bubble_particle_image, 24)
	bubble_system:setParticleLifetime(12, 20)
	bubble_system:setEmissionRate(1)
	bubble_system:setDirection(-math.pi / 2)
	bubble_system:setSpread(0.15)
	bubble_system:setSpeed(60, 110)
	bubble_system:setLinearAcceleration(0, -10, 0, -4)
	bubble_system:setSizes(0.35, 0.55)
	bubble_system:setSizeVariation(0.5)
	bubble_system:setColors(0.85, 0.95, 1.0, 0.85, 0.85, 0.95, 1.0, 0)
	bubble_system:setEmissionArea("uniform", screen_width, 25, 0)
	bubble_system:emit(6)

	local fishing_line_x = (love.graphics.getWidth() - love.graphics.getWidth() * 0.1) / 2
		+ (love.graphics.getWidth() * 0.1)
	my_fishing_line = fishing_line:new(fishing_line_x)
end

function love.mousepressed(x, y, mouse_button)
	if game_state.state == "shop" then
		shop.mousepressed(x, y, mouse_button)
	end
end

function love.update(dt)
	elapsed = elapsed + dt
	particle_system:update(dt)
	bubble_system:update(dt)
	my_fishing_line:animate(dt)
	if fish_transfer.update(dt) then
		if game_state.bait_left == 0 then
			game_state.state = "shop"
			shop.open()
		else
			game_state.state = "catching"
		end
	end
end

function love.resize()
	render.resize()
	shop.resize()
	left_bar:layout()
	bottom_bar:layout()
	bubble_system:setEmissionArea("uniform", love.graphics.getWidth(), 25, 0)
end

local function finish_catch(fish_list, row_number)
	if not check_requirements("can_release_or_save") then
		return
	end
	local fish = game_state.current_fish
	local index = #fish_list + 1
	fish_list[index] = fish
	fish_transfer.start(fish, my_fishing_line.bobber_x, my_fishing_line.bobber_y, function()
		return render.get_bottom_fish_slot(row_number, index)
	end)
	game_state.current_fish = false
	my_fishing_line.caught_fish = false
	my_fishing_line:start_reset_animation()
	game_state.bait_left = game_state.bait_left - 1
	game_state.state = "transferring_fish"
end

function love.keypressed(key, scancode, isrepeat)
	if isrepeat then
		return
	end
	if game_state.state == "shop" then
		shop.keypressed(key)
		return
	end
	if key == "space" then
		if game_state.state == "catching" and #game_state.pond == 0 then
			game_state.state = "shop"
			shop.open()
			shop.message = "The pond is empty. Restocking effects are coming later."
			return
		end
		if check_requirements("can_catch_fish") then
			game_state.current_fish = game.catch_fish(game_state.pond, game_state.bait_left)
			if game_state.current_fish then
				my_fishing_line:start_catching_animation(game_state.current_fish)
			end

			game_state.state = "fish_caught"
		end
	end

	if key == "y" then
		finish_catch(game_state.fish_caught_this_round, 1)
	end

	if key == "n" then
		finish_catch(game_state.fish_released_this_round, 2)
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
