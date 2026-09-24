local Element = require("src.ui.element")
local Image_Element = setmetatable({}, { __index = Element })
Image_Element.__index = Image_Element

---Draw an Image, or one sprite from a sheet when a Quad is provided.
---@param parent Container
---@param image love.Image
---@param quad? love.Quad
---@param width number | "fit" Percent of parent width, or the image/quad width.
---@param height number | "fit" Percent of parent height, or the image/quad height.
---@return Image_Element
function Image_Element:new(parent, image, quad, width, height)
	assert(image and image:typeOf("Image"), "Image element requires a love.Image")
	assert(not quad or quad:typeOf("Quad"), "Image element quad must be a love.Quad")

	local source_width, source_height
	if quad then
		local _, _, quad_width, quad_height = quad:getViewport()
		source_width, source_height = quad_width, quad_height
	else
		source_width, source_height = image:getDimensions()
	end

	assert(width == "fit" or type(width) == "number", "Image element width must be a percentage or 'fit'")
	assert(height == "fit" or type(height) == "number", "Image element height must be a percentage or 'fit'")

	return setmetatable({
		image = image,
		quad = quad,
		width = width == "fit" and source_width or (width / 100) * parent.width,
		height = height == "fit" and source_height or (height / 100) * parent.height,
		source_width = source_width,
		source_height = source_height,
		has_on_click = false,
	}, self)
end

function Image_Element:render()
	local old_r, old_g, old_b, old_a = love.graphics.getColor()
	love.graphics.setColor(1, 1, 1, 1)
	local scale_x = self.width / self.source_width
	local scale_y = self.height / self.source_height
	if self.quad then
		love.graphics.draw(self.image, self.quad, self.x, self.y, 0, scale_x, scale_y)
	else
		love.graphics.draw(self.image, self.x, self.y, 0, scale_x, scale_y)
	end
	love.graphics.setColor(old_r, old_g, old_b, old_a)
end

return Image_Element
