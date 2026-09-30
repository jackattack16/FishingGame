local fish_species = require("src.fish_species")

local FishSprites = {}
local image
local quads = {}

function FishSprites.load()
	if image then
		return
	end

	image = love.graphics.newImage("assets/sprites/common_fish.png")
	local sheet_width, sheet_height = image:getDimensions()
	for _, species in pairs(fish_species) do
		local x = (species.sprite_index - 1) * 128
		local y = 0 -- Use rarity to select a row when more textures are added.
		quads[species.sprite_index] = love.graphics.newQuad(x, y, 128, 128, sheet_width, sheet_height)
		--- update sprite index when more rows are added
	end
end

---@return love.Image
function FishSprites.get_image()
	FishSprites.load()
	return image
end

---@param fish Fish
---@return love.Quad
function FishSprites.get_quad(fish)
	FishSprites.load()
	return assert(quads[fish.sprite_index], "No sprite for fish index: " .. tostring(fish.sprite_index))
end

---@param fish Fish
---@param x number
---@param y number
---@param rotation? number Radians.
---@param scale_x? number
---@param scale_y? number Defaults to scale_x.
---@param origin_x? number
---@param origin_y? number
function FishSprites.draw(fish, x, y, rotation, scale_x, scale_y, origin_x, origin_y)
	love.graphics.draw(
		FishSprites.get_image(),
		FishSprites.get_quad(fish),
		x,
		y,
		rotation or 0,
		scale_x or 1,
		scale_y or scale_x or 1,
		origin_x or 0,
		origin_y or 0
	)
end

return FishSprites
