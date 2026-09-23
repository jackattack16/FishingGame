local game = require("src.game_functions")
local render = require("src.render")
local game_state = require("src.globals.globals")
local rng
local container = require("src.ui.container")

if os.getenv("LOVE2D_TOOLS") then
	pcall(require, "_love2d_tools_bridge")
end
function love.load()
	rng = love.math.newRandomGenerator()
	rng:setSeed(os.time()) -- use a fresh seed each time the game starts

	game_state.pond = game.make_pond(50, rng)
	render.load()
	button_container = container:new(0, 0, 200, 500, 0, 0, "column", "evenly")
	button_container:add_element("button", {
		width = "fit",
		height = "fit",
		x_padding = 5,
		y_padding = 5,
		horizontal_text_align = "center",
		vertical_text_align = "center",
		text = "button1",
	})
end

function love.update(dt) end

function love.keypressed(key, scancode, isrepeat)
	if key == "space" then
		if
			not game_state.current_fish
			and #game_state.pond > 0
			and game_state.bait_left > 0
			and #game_state.fish_caught_this_round < 5
		then
			game_state.current_fish, game_state.bait_left = game.catch_fish(game_state.pond, game_state.bait_left)
			game_state.status_text = (
				"You caught a "
				.. game_state.current_fish.name
				.. "!\nDo you wnat to keep it? (Y/n)"
			)
		elseif #game_state.pond == 0 then
			print("You lost :(")
		elseif game_state.bait_left == 0 then
			print("Out of bait")
		end
	end

	if key == "y" then
		if game_state.current_fish then
			-- print("Fish caught!")
			game_state.fish_caught_this_round[#game_state.fish_caught_this_round + 1] = game_state.current_fish
		end

		game_state.current_fish = false
		game_state.status_text = "Press space to catch a fish"
		if game_state.bait_left == 0 then
			game_state.state = "shop"
		end
	end

	if key == "n" then
		if game_state.current_fish then
			-- print("Fish released!")
			game_state.fish_released_this_round[#game_state.fish_released_this_round + 1] = game_state.current_fish
		end

		game_state.current_fish = false
		game_state.status_text = "Press space to catch a fish"
		if game_state.bait_left == 0 then
			game_state.state = "shop"
		end
	end

	if key == "return" then
		if game_state.state == "shop" then
			game.end_round(rng)
		end
	end
end

function love.draw()
	if game_state.state == "catching" then
		render.draw_catching()
	elseif game_state.state == "shop" then
		render.draw_shop()
	end

	love.graphics.print("Money: " .. game_state.money, 480, 5)
	button_container:render()
end
