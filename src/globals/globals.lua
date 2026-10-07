---@type GameState
local game_state = {
	pond = {},
	current_fish = false,
	fish_caught_this_round = {},
	fish_released_this_round = {},
	bait_left = 2,
	state = "catching",
	status_text = "press space to catch a fish",
	money = 0,
	round = 1,
	shop_purchases = {},
	fish_pack = {},
	active_chemicals = {
		food = {},
		piscicide = {},
		sterilizer = {},
	},
	chemical_pack = {},
}

return game_state
