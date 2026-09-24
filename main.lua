local game = require("src.game_functions")
local render = require("src.render")
local game_state = require("src.globals.globals")
local rng
local container = require("src.ui.container")

if os.getenv("LOVE2D_TOOLS") then
	pcall(require, "_love2d_tools_bridge")
end
function love.load()
	love.window.maximize()
	rng = love.math.newRandomGenerator()
	rng:setSeed(os.time()) -- use a fresh seed each time the game starts

	game_state.pond = game.make_pond(50, rng)
	render.load()
	left_bar = container:new(
		0,
		0,
		"10%",
		"85%",
		0,
		0,
		"column",
		"between",
		{ wrap = true, gap = 10, bg_color = { 1, 0, 0, 1 } }
	)

	left_bar:add_element("textbox", {
		text = "Money",
		width = 100,
		y_padding = 5,
	})
	bottom_bar = container:new(
		0,
		"85%",
		"full",
		"15%",
		0,
		0,
		"row",
		"together",
		{ wrap = true, gap = 10, bg_color = { 0, 1, 0, 1 } }
	)
	bottom_bar:add_element("button", {
		text = "Settings",
		bg_color = { 0.2, 0.2, 0.2 },
		height = 100,
		width = 10,
	})
end

function love.mousepressed(x, y, mouse_button) end

function love.resize()
	left_bar:layout()
	bottom_bar:layout()
end

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
	left_bar:render()
	bottom_bar:render()
end
