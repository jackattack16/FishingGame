function love.load()
	local root = love.filesystem.getWorkingDirectory():gsub("\\", "/")
	package.path = root .. "/?.lua;" .. package.path

	local game = require("src.game_functions")
	local game_state = require("src.globals.globals")
	local rng = love.math.newRandomGenerator(123)
	local kept_fish = { price = 12 }
	local released_fish = { price = 4 }

	game_state.pond = {}
	game_state.fish_caught_this_round = { kept_fish }
	game_state.fish_released_this_round = { released_fish }
	game_state.bait_left = 0
	game_state.money = 3
	game_state.state = "shop"
	game_state.status_text = "Ready to sell"

	game.end_round(rng)

	assert(game_state.money == 15)
	assert(#game_state.pond == 1 and game_state.pond[1] == released_fish)
	assert(#game_state.fish_caught_this_round == 0)
	assert(#game_state.fish_released_this_round == 0)
	assert(game_state.current_fish == false)
	assert(game_state.bait_left == 5)
	assert(game_state.state == "catching")
	assert(game_state.status_text == "Press space to catch a fish")
	print("Round reset verified")
	love.event.quit()
end
