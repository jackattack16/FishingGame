local Element = require("src.ui.element")
local Button = setmetatable({}, { __index = Element })
Button.__index = Button

---@param parent Container
---@param has_on_click boolean
---@param width number | "fit"
---@param height number | "fit"
---@param text string
---@param on_click function
---@param x_padding number
---@param y_padding number
---@param horizontal_text_align "center" | "none"
---@param vertical_text_align "center" | "none"
---@param style? {bg_color?: number[], text_color?: number[], radius?: number, border_color?: number[], border_width?: number}
---@return Button
function Button:new(
	parent,
	has_on_click,
	width,
	height,
	text,
	on_click,
	x_padding,
	y_padding,
	horizontal_text_align,
	vertical_text_align,
	style
)
	local new_button = Element.new(
		self,
		parent,
		has_on_click,
		width,
		height,
		text,
		x_padding,
		y_padding,
		horizontal_text_align,
		vertical_text_align,
		style
	)
	new_button.on_click = on_click
	return new_button
end

local default_onclick = function()
	print("no function supplied")
end

function Button.get_defaults()
	local defaults = Element.get_defaults()
	defaults.on_click = default_onclick
	defaults.has_on_click = true
	defaults.border_width = 4
	return defaults
end

return Button
