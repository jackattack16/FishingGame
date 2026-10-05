---@meta

---@class GameState
---@field pond Fish[]
---@field current_fish Fish|false
---@field fish_caught_this_round Fish[]
---@field fish_released_this_round Fish[]
---@field bait_left number
---@field state "catching"|"shop"|"fish_caught"|"transferring_fish"
---@field status_text string
---@field money number
---@field round integer
---@field shop_purchases table<string, integer>
local GameState = {}
