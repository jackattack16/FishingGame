local math_helpers = require("src.math_helpers")
local game = require("src.game_functions")
local game_state = require("src.globals.globals")
local fish_species = require("src.fish_species")
local R = {}
local fish_sprite_batch
local fish_textures = {}

function R.load()
	local sprite_sheet = love.graphics.newImage("assets/sprites/common_fish.png")
	fish_sprite_batch = love.graphics.newSpriteBatch(sprite_sheet)
	for _, fish in pairs(fish_species) do
		local x_pos = (fish.sprite_index - 1) * 128
		local y_pos = 0 -- update to use rarity to index for sprites when i get more textures
		fish_textures[fish.sprite_index] = love.graphics.newQuad(x_pos, y_pos, 128, 128, sprite_sheet)
	end
end

local function make_fish_batch(fish_table, x_start, y_start, sprite_width)
	local i = 0
	for _, fish in pairs(fish_table) do
		fish_sprite_batch:add(fish_textures[fish.sprite_index], x_start + (i * sprite_width), y_start)
		i = i + 1
	end
end

function R.draw_catching()
	-- Draw the fish that the player has caught
	love.graphics.print("Caught Fish: " .. #game_state.fish_caught_this_round .. " / 5", 5, 5)
	fish_sprite_batch:clear()
	make_fish_batch(game_state.fish_caught_this_round, 0, 10, 128)
	love.graphics.draw(fish_sprite_batch, 0, 0)

	-- Draw the fish the player releases
	love.graphics.print("Released Fish", 5, 143)

	fish_sprite_batch:clear()
	make_fish_batch(game_state.fish_released_this_round, 0, 138, 128)
	love.graphics.draw(fish_sprite_batch, 0, 0)

	-- Draw the amount of bait left and the curent status_text
	love.graphics.print("Bait Left: " .. game_state.bait_left, 150, 5)
	love.graphics.print(game_state.status_text, 5, 256)
end

function R.draw_shop()
	-- Draw the caught fish and their prices and stats
	love.graphics.print("Caught Fish", 5, 5)
	fish_sprite_batch:clear()
	local i = 0
	for _, fish in pairs(game_state.fish_caught_this_round) do
		local x_offset = i * 128
		fish_sprite_batch:add(fish_textures[fish.sprite_index], x_offset, 10)
		love.graphics.print("$" .. fish.price, 64 + x_offset, 138)
		love.graphics.print(math_helpers.round(fish.weight, 2) .. "kg", 64 + x_offset, 153)
		love.graphics.print(math_helpers.round(fish.length, 2) .. "cm", 64 + x_offset, 168)
		i = i + 1
	end
	love.graphics.draw(fish_sprite_batch, 0, 0)

	-- Draw the total shop sell value
	love.graphics.print(
		"Sell for: $" .. game.get_sum_of_fish_values(game_state.fish_caught_this_round) .. "\nPress enter to sell",
		5,
		220,
		0,
		2,
		2
	)
end

return R
