---@type table<string, table<Food[], Piscicide[], Sterilizer[]>>
local chemical_types = {
	common_carp = {
		food = {
			{
				name = "Common Carp Feed",
				species_for = "common_carp",
				type = "food",
				description = "Increases chance for common carp to breed, lasts 2 rounds",
				breed_chance_mult = 0.2,
				price = 20,
				duration = 2,
			},
		},
		piscicide = {
			{
				name = "Common Carp Piscicides",
				species_for = "common_carp",
				type = "piscicide",
				description = "Chance for fish to die each round, lasts 2 rounds. Can have negitive side effects",
				kill_chance = 0.2,
				price = 22,
				duration = 2,
			},
		},
		sterilizer = {
			{
				name = "Common Carp Sterilizer",
				species_for = "common_carp",
				type = "sterilizer",
				description = "Greatly reduces chance for fish to breed, can have permanant side effects for effected fish. Lasts 2 rounds.",
				infertile_chance = 0.15,
				breed_chance_mult = 0.25,
				price = 28,
				duration = 2,
			},
		},
	},
	pacific_sardine = {
		food = {
			{
				name = "Pacific Sardine Feed",
				species_for = "pacific_sardine",
				type = "food",
				description = "Increases chance for Pacific Sardines to breed, lasts 2 rounds",
				breed_chance_mult = 1.2,
				price = 20,
				duration = 2,
			},
		},
		piscicide = {
			{
				name = "Pacific Sardine Piscicides",
				species_for = "pacific_sardine",
				type = "piscicide",
				description = "Chance for fish to die each round, lasts 2 rounds. Can have negitive side effects",
				kill_chance = 0.15,
				price = 22,
				duration = 2,
			},
		},
		sterilizer = {
			{
				name = "Pacific Sardine Sterilizer",
				species_for = "pacific_sardine",
				type = "sterilizer",
				description = "Greatly reduces chance for fish to breed, can have permanant side effects for effected fish. Lasts 2 rounds.",
				infertile_chance = 0.15,
				breed_chance_mult = 0.5,
				price = 28,
				duration = 2,
			},
		},
	},
	atlantic_herring = {
		food = {
			{
				name = "Atlantic Herring Feed",
				species_for = "atlantic_herring",
				type = "food",
				description = "Increases chance for Atlantic Herring to breed, lasts 2 rounds",
				breed_chance_mult = 1.2,
				price = 20,
				duration = 2,
			},
		},
		piscicide = {
			{
				name = "Atlantic Herring Piscicides",
				species_for = "atlantic_herring",
				type = "piscicide",
				description = "Chance for fish to die each round, lasts 2 rounds. Can have negitive side effects",
				kill_chance = 0.15,
				price = 22,
				duration = 2,
			},
		},
		sterilizer = {
			{
				name = "Atlantic Herring Sterilizer",
				species_for = "atlantic_herring",
				type = "sterilizer",
				description = "Greatly reduces chance for fish to breed, can have permanant side effects for effected fish. Lasts 2 rounds.",
				infertile_chance = 0.15,
				breed_chance_mult = 0.5,
				price = 28,
				duration = 2,
			},
		},
	},
	lanternfish = {
		food = {
			{
				name = "Lanternfish Feed",
				species_for = "lanternfish",
				type = "food",
				description = "Increases chance for Lanternfish to breed, lasts 2 rounds",
				breed_chance_mult = 1.2,
				price = 20,
				duration = 2,
			},
		},
		piscicide = {
			{
				name = "Lanternfish Piscicides",
				species_for = "lanternfish",
				type = "piscicide",
				description = "Chance for fish to die each round, lasts 2 rounds. Can have negitive side effects",
				kill_chance = 0.15,
				price = 22,
				duration = 2,
			},
		},
		sterilizer = {
			{
				name = "Lanternfish Sterilizer",
				species_for = "lanternfish",
				type = "sterilizer",
				description = "Greatly reduces chance for fish to breed, can have permanant side effects for effected fish. Lasts 2 rounds.",
				infertile_chance = 0.15,
				breed_chance_mult = 0.5,
				price = 28,
				duration = 2,
			},
		},
	},
	atlantic_cod = {
		food = {
			{
				name = "Atlantic Cod Feed",
				species_for = "atlantic_cod",
				type = "food",
				description = "Increases chance for Atlantic Cod to breed, lasts 2 rounds",
				breed_chance_mult = 1.2,
				price = 20,
				duration = 2,
			},
		},
		piscicide = {
			{
				name = "Atlantic Cod Piscicides",
				species_for = "atlantic_cod",
				type = "piscicide",
				description = "Chance for fish to die each round, lasts 2 rounds. Can have negitive side effects",
				kill_chance = 0.15,
				price = 22,
				duration = 2,
			},
		},
		sterilizer = {
			{
				name = "Atlantic Cod Sterilizer",
				species_for = "atlantic_cod",
				type = "sterilizer",
				description = "Greatly reduces chance for fish to breed, can have permanant side effects for effected fish. Lasts 2 rounds.",
				infertile_chance = 0.15,
				breed_chance_mult = 0.5,
				price = 28,
				duration = 2,
			},
		},
	},
	bluefish = {
		food = {
			{
				name = "Bluefish Feed",
				species_for = "bluefish",
				type = "food",
				description = "Increases chance for Bluefish to breed, lasts 2 rounds",
				breed_chance_mult = 1.2,
				price = 20,
				duration = 2,
			},
		},
		piscicide = {
			{
				name = "Bluefish Piscicides",
				species_for = "bluefish",
				type = "piscicide",
				description = "Chance for fish to die each round, lasts 2 rounds. Can have negitive side effects",
				kill_chance = 0.15,
				price = 22,
				duration = 2,
			},
		},
		sterilizer = {
			{
				name = "Bluefish Sterilizer",
				species_for = "bluefish",
				type = "sterilizer",
				description = "Greatly reduces chance for fish to breed, can have permanant side effects for effected fish. Lasts 2 rounds.",
				infertile_chance = 0.15,
				breed_chance_mult = 0.5,
				price = 28,
				duration = 2,
			},
		},
	},
	tuna = {
		food = {
			{
				name = "Tuna Feed",
				species_for = "tuna",
				type = "food",
				description = "Increases chance for Tuna to breed, lasts 2 rounds",
				breed_chance_mult = 1.2,
				price = 20,
				duration = 2,
			},
		},
		piscicide = {
			{
				name = "Tuna Piscicides",
				species_for = "tuna",
				type = "piscicide",
				description = "Chance for fish to die each round, lasts 2 rounds. Can have negitive side effects",
				kill_chance = 0.15,
				price = 22,
				duration = 2,
			},
		},
		sterilizer = {
			{
				name = "Tuna Sterilizer",
				species_for = "tuna",
				type = "sterilizer",
				description = "Greatly reduces chance for fish to breed, can have permanant side effects for effected fish. Lasts 2 rounds.",
				infertile_chance = 0.15,
				breed_chance_mult = 0.5,
				price = 28,
				duration = 2,
			},
		},
	},
}

return chemical_types
