Fish = {}

Fish._index = Fish

-- Create a constructor of sorts for fish types from the FishTypes table
function Fish:new(fishType)
	local defualts = FishTypes[fishType]
	local fish = {
		name = defualts.name,
		weight = RNG:random(defualts.min_weight, defualts.max_weight),
		base_price = defualts.base_price,
		multiplier = defualts.multiplier,
		rarity = defualts.rarity,
	}

	setmetatable(fish, Fish)
	return fish
end

function Fish:getValue()
	return self.weight * self.base_price
end

-- Define species / types of fish
FishType = {
	grouper = {
		name = "Grouper",
		min_weight = 3,
		max_weight = 15,
		base_price = 0.5,
		multiplier = 1,
		rarity = 1,
	},
	mackerel = {
		name = "Mackerel",
		min_weight = 1,
		max_weight = 5,
		base_price = 0.75,
		multiplier = 1,
		rarity = 1,
	},
}
