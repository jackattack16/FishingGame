---@meta

---@class Food
---@field name string
---@field type "food"
---@field species_for string Fish species key from src/fish_species.lua.
---@field description string
---@field breed_chance_mult number
---@field price number
---@field duration number
local Food = {}

---@class Piscicide
---@field name string
---@field type "piscicide"
---@field species_for string Fish species key from src/fish_species.lua.
---@field description string
---@field kill_chance number
---@field price number
---@field duration number
local Piscicide = {}

---@class Sterilizer
---@field name string
---@field type "sterilizer"
---@field species_for string Fish species key from src/fish_species.lua.
---@field description string
---@field infertile_chance number
---@field breed_chance_mult number
---@field price number
---@field duration number
local Sterilizer = {}

---@alias Chemical Food | Piscicide | Sterilizer

---@class ActiveChemicals
---@field food Food[]
---@field piscicide Piscicide[]
---@field sterilizer Sterilizer[]
local ActiveChemicals = {}
