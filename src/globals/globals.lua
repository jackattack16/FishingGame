---@type GameState
local game_state = {
	pond = {},
	current_fish = false,
	fish_caught_this_round = {},
	fish_released_this_round = {},
	bait_left = 5,
	state = "catching",
	status_text = "press space to catch a fish",
	money = 0,
}

return game_state
