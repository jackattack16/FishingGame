local fish = require("src.fish")

local G = {}

function G.catch_fish()
	local random_number = RNG:random()
	local fish_rarity = 1
	if random_number >= 0.55 and random_number < 0.75 then
		fish_rarity = 2 -- uncommon
	elseif random_number >= 0.75 and random_number < 0.85 then
		fish_rarity = 3 -- rare
	elseif random_number >= 0.85 and random_number < 0.95 then
		fish_rarity = 4 -- epic
	else
		endfish_rarity = 5 --legendary
	end
	-- print(fish_rarity)

	local caught_fish = fish:new(fish_rarity)

	print(caught_fish.name)

	return caught_fish
end

return G
