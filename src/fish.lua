local math_helpers = require("src.math_helpers")
local fish_species = require("src.fish_species")
local fish_sprites = require("src.fish_sprites")
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

local function set_fish_prices(fish, species)
	fish.sell_price = math_helpers.round(
		(fish.weight * fish.multiplier)
			+ (species.base_price * (species.rarity / 2))
			+ RARITY_PRICE_BONUS[species.rarity],
		2
	)
	fish.buy_price = math_helpers.round((fish.sell_price / 3.5) * fish.rarity, 2)
	-- Keep the existing field working for code that still reads fish.price.
	fish.price = fish.sell_price
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

	set_fish_prices(fish, chosen_fish)

	setmetatable(fish, Fish)
	return fish
end

---@param x number
---@param y number
---@param rotation? number Radians.
---@param scale_x? number Defaults to 1.
---@param scale_y? number Defaults to scale_x.
---@param origin_x? number Rotation and scaling origin within the sprite; defaults to 0.
---@param origin_y? number Rotation and scaling origin within the sprite; defaults to 0.
function Fish:draw(x, y, rotation, scale_x, scale_y, origin_x, origin_y)
	fish_sprites.draw(self, x, y, rotation, scale_x, scale_y, origin_x, origin_y)
end

---@param name string Fish species key from src/fish_species.lua.
---@param rng love.RandomGenerator
---@return Fish
function Fish:new_by_name(name, rng)
	assert(fish_species[name], "Not a valid fish species")

	local chosen_fish = fish_species[name]
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

	set_fish_prices(fish, chosen_fish)

	setmetatable(fish, Fish)
	return fish
end

---Get the identifer in the format of the species table
---@return string
function Fish:get_identifier()
	return tostring(string.gsub(string.lower(self.name), " ", "_"))
end

return Fish
