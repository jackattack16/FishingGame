local FISH = require("src.fish")
local MATH_HELPERS = require("src.math_helpers")

local G = {}

function G.catch_fish(pond)
	return table.remove(pond, 1) -- remove and return the first fish from the pond and update the table
end

function G.make_pond(amount_of_fish_in_pond)
	local pond = {}

	for i = 1, amount_of_fish_in_pond do
		local rarity = MATH_HELPERS.round(RNG:randomNormal(1, 1)) -- adjust distribution eventually
		rarity = math.max(1, math.min(rarity, 4))
		pond[i] = FISH:new(rarity)
	end
	return pond
end

function G.count_rarity(pond, rarity)
	local number_of_fish = 0
	for _, fish in ipairs(pond) do
		if fish.rarity == rarity then
			number_of_fish = number_of_fish + 1
		end
	end
	return number_of_fish
end

return G
