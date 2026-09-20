---@meta

---@class GameState
---@field pond Fish[]
---@field current_fish Fish|false
---@field fish_caught_this_round Fish[]
---@field fish_released_this_round Fish[]
---@field bait_left number
---@field state "catching"|"shop"
---@field status_text string
---@field money number
local GameState = {}
