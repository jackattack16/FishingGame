local game = require("src.game_functions")
local render = require("src.render")

game_state = {}

if os.getenv("LOVE2D_TOOLS") then
	pcall(require, "_love2d_tools_bridge")
end
function love.load()
	love.window.setMode(700, 300, { x = 300, y = 100 })
	RNG = love.math.newRandomGenerator() -- create  a global rng machine
	RNG:setSeed(1000) -- set the seed so runs can be reproduced in the future

	game_state.pond = game.make_pond(50)
	game_state.current_fish = false
	game_state.fish_caught_this_round = {}
	game_state.fish_released_this_round = {}
	game_state.bait_left = 5
	game_state.state = "catching"

	local sprite_sheet = love.graphics.newImage("assets/sprites/common_fish.png")
	fish_sprite_batch = love.graphics.newSpriteBatch(sprite_sheet)
	FISH_TEXTURES = {}

	for _, fish in pairs(FishTypes) do
		local x_pos = 0 + ((fish.sprite_index - 1) * 128)
		local y_pos = 0 -- update to use rarity to index for sprites when i get more textures
		local index = fish.sprite_index
		FISH_TEXTURES[index] = love.graphics.newQuad(x_pos, y_pos, 128, 128, sprite_sheet)
	end
end

function love.update(dt) end

function love.keypressed(key, scancode, isrepeat)
	if key == "space" then
		if not game_state.current_fish and #game_state.pond > 0 and game_state.bait_left > 0 then
			game_state.current_fish, game_state.bait_left = game.catch_fish(game_state.pond)
			print("you caught a " .. game_state.current_fish.name .. " \n Do you wnat to keep it? (Y/n)")
		elseif #game_state.pond == 0 then
			print("You lost :(")
		elseif game_state.bait_left == 0 then
			print("Out of bait")
		end
	end

	if key == "y" then
		if game_state.current_fish then
			print("Fish caught!")
			game_state.fish_caught_this_round[#game_state.fish_caught_this_round + 1] = game_state.current_fish
		end

		game_state.current_fish = false
		if game_state.bait_left == 0 then
			game_state.state = "shop"
		end
	end

	if key == "n" then
		if game_state.current_fish then
			print("Fish released!")
			game_state.fish_released_this_round[#game_state.fish_released_this_round + 1] = game_state.current_fish
		end

		game_state.current_fish = false
		if game_state.bait_left == 0 then
			game_state.state = "shop"
		end
	end
end

function love.draw()
	if game_state.state == "catching" then
		render.draw_catching()
	elseif game_state.state == "shop" then
		render.draw_shop()
	end
end
