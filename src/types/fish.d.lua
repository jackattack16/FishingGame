---@meta

---@class Fish
---@field name string
---@field sprite_index integer
---@field length number
---@field girth number
---@field weight number
---@field multiplier number
---@field rarity integer
---@field price number
---@field draw fun(self: Fish, x: number, y: number, rotation?: number, scale_x?: number, scale_y?: number, origin_x?: number, origin_y?: number) Draw the sprite; rotation is in radians and origin is in sprite pixels.
local Fish = {}

---@class FishSpecies
---@field name string
---@field min_length integer
---@field max_length integer
---@field girth_ratio number
---@field factor number
---@field base_price number
---@field multiplier number
---@field rarity integer
---@field sprite_index integer
local FishSpecies = {}
