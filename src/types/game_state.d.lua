---@meta

---@class GameState
---@field pond Fish[]
---@field current_fish Fish|false
---@field fish_caught_this_round Fish[]
---@field fish_released_this_round Fish[]
---@field bait_left number
---@field state "catching"|"shop"|"fish_caught"|"transferring_fish"|"shop_packs"|"fish_pack_open"|"failed_purchase"|"chem_pack_open"
---@field status_text string
---@field money number
---@field round integer
---@field shop_purchases table<string, integer>
---@field fish_pack Fish[]
---@field active_chemicals ActiveChemicals
---@field chemical_pack table<string, Chemical[]>
local GameState = {}
