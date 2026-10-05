local root = love.filesystem.getWorkingDirectory():gsub("\\", "/")
function love.errorhandler(message)
	print(debug.traceback(message, 2))
	return function()
		return 1
	end
end
package.path = root .. "/?.lua;" .. package.path
dofile(root .. "/main.lua")
local game_load, game_draw, game_update = love.load, love.draw, love.update
local state = require("src.globals.globals")
local transfer = require("src.fish_transfer")
local render = require("src.render")
local stages, stage, pending, captured = {}, 1, true, false
local start_x, start_y

local function check_frame_rates()
	local reference
	for _, rate in ipairs({ 30, 60, 144 }) do
		transfer.start({}, 400, 400, function()
			return 200, 650, 48
		end)
		local elapsed = 0
		while elapsed < 0.425 do
			local dt = math.min(1 / rate, 0.425 - elapsed)
			assert(not transfer.update(dt))
			elapsed = elapsed + dt
		end
		local pose = { transfer.get_pose() }
		if reference then
			for index, value in ipairs(pose) do
				assert(math.abs(value - reference[index]) < 0.000001, "Flight must be independent of frame rate")
			end
		else
			reference = pose
		end
		assert(transfer.update(1) and not transfer.update(1), "Landing must complete exactly once")
	end
end

local function catch()
	love.keypressed("space")
	for _ = 1, 91 do
		game_update(1 / 60)
	end
	assert(state.state == "fish_caught" and my_fishing_line.state == "fish_caught")
end

local function finish_flight()
	for _ = 1, 65 do
		game_update(1 / 60)
	end
end

function love.load()
	local maximize = love.window.maximize
	love.window.maximize = function() end
	game_load()
	love.window.maximize = maximize
	check_frame_rates()
	catch()
	start_x, start_y = my_fishing_line.bobber_x, my_fishing_line.bobber_y
	stages = {
		{ "hook", function() end },
		{
			"detach",
			function()
				local fish = state.current_fish
				love.keypressed("y")
				assert(state.state == "transferring_fish" and state.bait_left == 4)
				assert(not my_fishing_line.caught_fish and not state.current_fish)
				assert(transfer.active.fish == fish and state.fish_caught_this_round[1] == fish)
				local x, y, rotation, scale = transfer.get_pose()
				assert(x == start_x and y == start_y and rotation == 0 and scale == 1)
			end,
		},
		{
			"pop",
			function()
				game_update(0.08)
				local _, y, _, scale = transfer.get_pose()
				assert(y < start_y and scale > 1, "Fish must pop up off the hook")
				love.keypressed("y")
				love.keypressed("n")
				love.keypressed("space")
				assert(#state.fish_caught_this_round == 1 and #state.fish_released_this_round == 0)
				assert(
					state.bait_left == 4 and #state.pond == 49,
					"Inputs during flight must not consume more fish or bait"
				)
			end,
		},
		{
			"flight",
			function()
				game_update(0.25)
			end,
		},
		{
			"resized-flight",
			function()
				love.window.setMode(800, 600, { resizable = true })
				love.resize()
				game_update(0.2)
			end,
		},
		{
			"landing",
			function()
				game_update(0.25)
				local x, y, rotation, scale = transfer.get_pose()
				local target_x, target_y, size = render.get_bottom_fish_slot(1, 1)
				assert(x == target_x and y == target_y and rotation == 0 and scale > size / 128)
			end,
		},
		{
			"landed",
			function()
				game_update(0.1)
				assert(not transfer.active and state.state == "catching")
				finish_flight()
			end,
		},
		{
			"release-flight",
			function()
				catch()
				love.keypressed("n")
				assert(#state.fish_released_this_round == 1 and state.bait_left == 3)
				game_update(0.4)
			end,
		},
		{
			"released",
			function()
				finish_flight()
				assert(not transfer.active and state.state == "catching")
				-- Catch the remaining bait through the actual game handlers.
				for _ = 1, 2 do
					catch()
					love.keypressed("y")
					finish_flight()
				end
			end,
		},
		{
			"last-fish-flight",
			function()
				catch()
				love.keypressed("y")
				game_update(0.4)
				assert(
					state.bait_left == 0 and state.state == "transferring_fish",
					"The shop must wait for the last fish"
				)
			end,
		},
		{
			"shop-after-landing",
			function()
				finish_flight()
				assert(not transfer.active and state.state == "shop")
				assert(
					#state.fish_caught_this_round == 4 and #state.fish_released_this_round == 1 and #state.pond == 45
				)
			end,
		},
	}
end

function love.update()
	if pending then
		pending, captured = false, false
		if stage > #stages then
			print(
				"Catch flight verified: detach, pop, resized landing, input guards, release and final-fish shop transition"
			)
			love.event.quit()
			return
		end
		stages[stage][2]()
	end
end

function love.draw()
	game_draw()
	if stage <= #stages and not captured then
		captured = true
		love.graphics.captureScreenshot(function(data)
			local file = assert(
				io.open(root .. "/.tools/shop_preview/output/catch-animation-" .. stages[stage][1] .. ".png", "wb")
			)
			file:write(data:encode("png"):getString())
			file:close()
			stage, pending = stage + 1, true
		end)
	end
end
