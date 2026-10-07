local FISH = require("src.fish")
local game_state = require("src.globals.globals")
local FISH_SPECIES = require("src.fish_species")
local HELPERS = require("src.math_helpers")

local G = {}

-- Percent chance of each rarity, from common (1) to rarest (4).
local RARITY_WEIGHTS = { 60, 28, 10, 2 }
local rarity_weight_total = 0
for _, weight in ipairs(RARITY_WEIGHTS) do
	assert(weight >= 0 and weight == math.floor(weight), "Rarity weights must be nonnegative integers")
	rarity_weight_total = rarity_weight_total + weight
end
assert(#RARITY_WEIGHTS == 4 and rarity_weight_total == 100, "Rarity weights must add up to 100")

---@param rng love.RandomGenerator
---@return integer
function G.get_random_rarity(rng)
	local roll = rng:random(1, rarity_weight_total)
	local cumulative_weight = 0
	for rarity, weight in ipairs(RARITY_WEIGHTS) do
		cumulative_weight = cumulative_weight + weight
		if roll <= cumulative_weight then
			return rarity
		end
	end
	error("Rarity weights must add up to 100")
end

---@param pond Fish[]
---@param bait_left integer
---@return Fish
function G.catch_fish(pond, bait_left)
	local fish = assert(table.remove(pond, 1), "Cannot catch a fish from an empty pond")
	return fish
end

---@param amount_of_fish_in_pond integer
---@param rng love.RandomGenerator
---@return Fish[]
function G.make_pond(amount_of_fish_in_pond, rng)
	local pond = {}

	-- for i = 1, amount_of_fish_in_pond do
	-- 	pond[i] = FISH:new(random_rarity(rng), rng)
	-- end

	for i = 1, amount_of_fish_in_pond do
		pond[i] = FISH:new_by_name("common_carp", rng)
	end
	return pond
end

---@param pond Fish[]
---@param rarity integer
---@return integer
function G.count_rarity(pond, rarity)
	local number_of_fish = 0
	for _, fish in ipairs(pond) do
		if fish.rarity == rarity then
			number_of_fish = number_of_fish + 1
		end
	end
	return number_of_fish
end

---@param fish_table Fish[]
---@return number
function G.get_sum_of_fish_values(fish_table)
	local total_value = 0
	for _, fish in pairs(fish_table) do
		total_value = total_value + fish.sell_price
	end

	return total_value
end

---@param rng love.RandomGenerator
function G.end_round(rng)
	-- Re-add the released fish back into the pond
	for _, fish in ipairs(game_state.fish_released_this_round) do
		table.insert(game_state.pond, rng:random(1, #game_state.pond + 1), fish)
	end

	-- Reset for the next round
	game_state.fish_caught_this_round = {}
	game_state.fish_released_this_round = {}
	game_state.current_fish = false
	game_state.bait_left = 5
	game_state.round = game_state.round + 1
	game_state.status_text = "Press space to catch a fish"
	game_state.state = "catching"

	game_state.pond = kill_fish(game_state.pond, rng, game_state.active_chemicals)
	check_breeding(game_state.pond, rng, game_state.active_chemicals)
	game_state.active_chemicals = update_chemicals(game_state.active_chemicals)
end

function update_chemicals(chemicals)
	local updated_chemicals = {}
	for _, chem_type in pairs(chemicals) do
		for _, chemical in pairs(chem_type) do
			chemical.duration = chemical.duration - 1
			if chemical.duration > 0 then
				updated_chemicals[chemical.type][#updated_chemicals + 1] = chemical
			end
		end
	end

	return updated_chemicals
end

function kill_fish(pond, rng, chemicals)
	local kill_chance_by_species = {}

	-- Count the number of fish of each type
	for index_in_pond, fish in ipairs(pond) do
		local fish_species = fish:get_identifier()
		if not kill_chance_by_species[fish_species] then
			local kill_chance = 0
			for _, chemical in pairs(chemicals.piscicide) do
				if chemical.species_for == fish_species then
					kill_chance = kill_chance + chemical.kill_chance
				end
			end
			kill_chance_by_species[fish_species] = math.min(kill_chance, 1)
		end
	end

	local new_pond = {}

	for _, fish in ipairs(pond) do
		local fish_species = fish:get_identifier()
		if kill_chance_by_species[fish_species] then
			local random_number = rng:random()
			if not (random_number < kill_chance_by_species[fish_species]) then
				new_pond[#new_pond + 1] = fish
			end
		end
	end
	return new_pond
end

---check the number of types of fish in a pond
---@param pond {}
---@param rng love.RandomGenerator
---@param chemicals {}
function check_breeding(pond, rng, chemicals)
	local fish_counts = {}

	-- Count the number of fish of each type
	for _, fish in ipairs(pond) do
		local fish_identifier = fish:get_identifier()
		if not fish_counts[fish_identifier] then
			fish_counts[fish_identifier] = 1
		else
			fish_counts[fish_identifier] = fish_counts[fish_identifier] + 1
		end
	end

	-- Breed the fish in place to prevent mutating a table while iterating
	local added_fish = {}

	for fish_type, amount in pairs(fish_counts) do
		local pair_count = math.floor(amount / 2)

		local food_mult = 1
		for index, chemical in pairs(chemicals.food) do
			if chemical.species_for == fish_type then
				food_mult = food_mult + chemical.breed_chance_mult
			end
		end

		local steralizer_mult = 1
		for index, chemical in pairs(chemicals.sterilizer) do
			if chemical.species_for == fish_type then
				steralizer_mult = steralizer_mult - chemical.breed_chance_mult
			end
		end

		for _ = 1, pair_count do
			local random_number = rng:random()
			if random_number < (FISH_SPECIES[fish_type].breed_chance * food_mult * steralizer_mult) then
				added_fish[#added_fish + 1] = FISH:new_by_name(fish_type, rng)
			end
		end
	end

	-- Re add the fish to the pond
	for _, fish in pairs(added_fish) do
		pond[#pond + 1] = fish
	end
end

---Gets the fish species in a pond
---@param pond {}
---@return string[]
function G.get_fish_species(pond)
	local fish_counts = {}

	-- Count the number of fish of each type
	for _, fish in ipairs(pond) do
		local fish_identifier = fish:get_identifier()
		if not HELPERS.has_value(fish_counts, fish_identifier) then
			fish_counts[#fish_counts + 1] = fish_identifier
		end
	end

	return fish_counts
end

return G
