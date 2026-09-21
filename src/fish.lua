local math_helpers = require("src.math_helpers")
local fish_species = require("src.fish_species")
local RARITY_PRICE_BONUS = { 2.3, 3, 8, 25 }

local Fish = {}

Fish.__index = Fish

---@param rarity integer
---@return string[]
local function get_fish_of_rarity(rarity)
	local valid_fish = {}
	for fish_type, fish in pairs(fish_species) do
		if fish.rarity == rarity then
			valid_fish[#valid_fish + 1] = fish_type -- Add the fish at the next free index (#tablename is the length of table)
		end
	end
	return valid_fish
end

-- Create a fish from the FishType table.
-- Length and girth are in cm; weight is in kg.
-- Weight = (length * girth^2) / factor.

---@param rarity integer
---@param rng love.RandomGenerator
---@return Fish
function Fish:new(rarity, rng)
	local valid_fish = get_fish_of_rarity(rarity)
	assert(#valid_fish > 0, "No fish of rarity: " .. tostring(rarity))

	local fish_index = rng:random(1, #valid_fish) -- lua starts at 1 for indexes
	local fish_type = valid_fish[fish_index]

	local chosen_fish = fish_species[fish_type]
	local length = rng:random(chosen_fish.min_length, chosen_fish.max_length)
	local girth = length * chosen_fish.girth_ratio
	local fish = {
		name = chosen_fish.name,
		sprite_index = chosen_fish.sprite_index,
		length = length,
		girth = girth,
		weight = (length * girth * girth) / chosen_fish.factor,
		multiplier = chosen_fish.multiplier,
		rarity = chosen_fish.rarity,
	}

	fish.price = math_helpers.round(
		(fish.weight * fish.multiplier)
			+ (chosen_fish.base_price * (chosen_fish.rarity / 2))
			+ RARITY_PRICE_BONUS[chosen_fish.rarity],
		2
	)

	setmetatable(fish, Fish)
	return fish
end

return Fish
