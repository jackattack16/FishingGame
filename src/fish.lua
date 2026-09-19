Fish = {}

Fish.__index = Fish

function get_fish_of_rarity(rarity)
	local valid_fish = {}
	for fish_type, fish in pairs(FishTypes) do
		if fish.rarity == rarity then
			valid_fish[#valid_fish + 1] = fish_type -- Add the fish at the next free index (#tablename is the length of table)
		end
	end
	return valid_fish
end

-- Create a fish from the FishType table.
-- Length and girth are in cm; weight is in kg.
-- Weight = (length * girth^2) / factor.

function Fish:new(rarity)
	local valid_fish = get_fish_of_rarity(rarity)
	assert(#valid_fish > 0, "No fish of rarity: " .. tostring(rarity))

	local fish_index = RNG:random(1, #valid_fish) -- lua starts at 1 for indexes
	local fish_type = valid_fish[fish_index]

	local chosen_fish = FishTypes[fish_type]
	local length = RNG:random(chosen_fish.min_length, chosen_fish.max_length)
	local girth = length * chosen_fish.girth_ratio
	local fish = {
		name = chosen_fish.name,
		sprite_index = chosen_fish.sprite_index,
		length = length,
		girth = girth,
		weight = (length * girth * girth) / chosen_fish.factor,
		base_price = chosen_fish.base_price,
		multiplier = chosen_fish.multiplier,
		rarity = chosen_fish.rarity,
	}

	setmetatable(fish, Fish)
	return fish
end

function Fish:getValue()
	return self.weight * self.base_price
end

-- Define species / types of fish
-- Ranges are typical game-sized fish, not species maxima. Girth ratios and
-- metric factors are approximate and chosen to give plausible weights.
-- TODO: add a seprate feild a unique index for the FISH_TEXTURES table
-- FISH_TEXTURES table so they can be indexed
-- Right now its fine, but once the spritesheet becomes 2 demensions then its going to be hard
-- There might be a mathmatical way to find it but i dont remember right now
FishTypes = {
	common_carp = {
		name = "Common Carp",
		min_length = 25,
		max_length = 55,
		girth_ratio = 0.75,
		factor = 25000,
		base_price = 0.5,
		multiplier = 1,
		rarity = 1,
		sprite_index = 1,
	},
	pacific_sardine = {
		name = "Pacific Sardine",
		min_length = 18,
		max_length = 25,
		girth_ratio = 0.62,
		factor = 21000,
		base_price = 0.75,
		multiplier = 1,
		rarity = 1,
		sprite_index = 2,
	},
	atlantic_herring = {
		name = "Atlantic Herring",
		min_length = 25,
		max_length = 35,
		girth_ratio = 0.55,
		factor = 27000,
		base_price = 0.75,
		multiplier = 1,
		rarity = 1,
		sprite_index = 3,
	},
	lanternfish = {
		name = "Lanternfish",
		min_length = 5,
		max_length = 15,
		girth_ratio = 0.50,
		factor = 24000,
		base_price = 0.75,
		multiplier = 1,
		rarity = 4,
		sprite_index = 4,
	},
	atlantic_cod = {
		name = "Atlantic Cod",
		min_length = 35,
		max_length = 100,
		girth_ratio = 0.63,
		factor = 28000,
		base_price = 0.75,
		multiplier = 1,
		rarity = 2,
		sprite_index = 5,
	},
	bluefish = {
		name = "Bluefish",
		min_length = 35,
		max_length = 90,
		girth_ratio = 0.64,
		factor = 28000,
		base_price = 0.75,
		multiplier = 1,
		rarity = 3,
		sprite_index = 6,
	},
	tuna = {
		name = "Tuna",
		min_length = 40,
		max_length = 115,
		girth_ratio = 0.72,
		factor = 28000,
		base_price = 0.75,
		multiplier = 1,
		rarity = 3,
		sprite_index = 7,
	},
}

return Fish
