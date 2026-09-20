local math_helpers = require("src.math_helpers")
local R = {}

function R.draw_catching()
	love.graphics.print("Caught Fish", 5, 5)
	fish_sprite_batch:clear()
	local i = 0
	for _, fish in pairs(game_state.fish_caught_this_round) do
		fish_sprite_batch:add(FISH_TEXTURES[fish.sprite_index], 0 + (i * 128), 10)
		i = i + 1
	end
	love.graphics.draw(fish_sprite_batch, 0, 0)

	love.graphics.print("Released Fish", 5, 143)

	fish_sprite_batch:clear()
	local i = 0
	for _, fish in pairs(game_state.fish_released_this_round) do
		fish_sprite_batch:add(FISH_TEXTURES[fish.sprite_index], 0 + (i * 128), 148)
		i = i + 1
	end
	love.graphics.draw(fish_sprite_batch, 0, 0)

	love.graphics.print("Bait Left: " .. game_state.bait_left, 150, 5)
end

function R.draw_shop()
	love.graphics.print("Caught Fish", 5, 5)
	fish_sprite_batch:clear()
	local i = 0
	for _, fish in pairs(game_state.fish_caught_this_round) do
		local x_offset = i * 128
		fish_sprite_batch:add(FISH_TEXTURES[fish.sprite_index], x_offset, 10)
		love.graphics.print("$" .. fish.price, 64 + x_offset, 138)
		love.graphics.print(math_helpers.round(fish.weight) .. "kg", 64 + x_offset, 153)
		love.graphics.print(math_helpers.round(fish.length) .. "cm", 64 + x_offset, 168)
		i = i + 1
	end
	love.graphics.draw(fish_sprite_batch, 0, 0)
end

return R
