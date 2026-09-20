local FISH = require("src.fish")
local game_state = require("src.globals.globals")

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
local function random_rarity(rng)
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
---@return number
function G.catch_fish(pond, bait_left)
	local fish = assert(table.remove(pond, 1), "Cannot catch a fish from an empty pond")
	return fish, bait_left - 1
end

---@param amount_of_fish_in_pond integer
---@param rng love.RandomGenerator
---@return Fish[]
function G.make_pond(amount_of_fish_in_pond, rng)
	local pond = {}

	for i = 1, amount_of_fish_in_pond do
		pond[i] = FISH:new(random_rarity(rng), rng)
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
		total_value = total_value + fish.price
	end

	return total_value
end

---@param rng love.RandomGenerator
function G.end_round(rng)
	game_state.money = game_state.money + G.get_sum_of_fish_values(game_state.fish_caught_this_round)

	-- Re-add the released fish back into the pond
	for _, fish in ipairs(game_state.fish_released_this_round) do
		table.insert(game_state.pond, rng:random(1, #game_state.pond + 1), fish)
	end

	-- Reset for the next round
	game_state.fish_caught_this_round = {}
	game_state.fish_released_this_round = {}
	game_state.current_fish = false
	game_state.bait_left = 5
	game_state.status_text = "Press space to catch a fish"
	game_state.state = "catching"
end

return G
