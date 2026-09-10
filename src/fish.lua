Fish = {}

Fish._index = Fish

-- Create a constructor of sorts for fish types from the FishTypes table
function Fish:new(fishType)
	local defualts = FishTypes[fishType]

	local fish = {
		name = defualts.name,
		weight = defualts.weight,
		multiplier = defualts.multiplier,
		rarity = defualts.rarity,
	}

	setmetatable(fish, Fish)
	return fish
end

-- Define species / types of fish
FishTypes = {
	grouper = {
		name = "Grouper",
		weight = 3,
		multiplier = 1,
		rarity = 1,
	},
	mackerel = {
		name = "Mackerel",
		weight = 1,
		multiplier = 1,
		rarity = 1,
	},
}
