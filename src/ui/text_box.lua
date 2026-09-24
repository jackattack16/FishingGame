local Element = require("src.ui.element")
local Text_Box = setmetatable({}, { __index = Element })
Text_Box.__index = Text_Box

---@param parent Container
---@param has_on_click boolean
---@param width number | "fit"
---@param height number | "fit"
---@param text string
---@param x_padding number
---@param y_padding number
---@param horizontal_text_align "center" | "none"
---@param vertical_text_align "center" | "none"
---@param style? {bg_color?: number[], text_color?: number[], radius?: number, border_color?: number[], border_width?: number}
---@return Text_Box
function Text_Box:new(
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
	return Element.new(
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
end

function Text_Box.get_defaults()
	local defaults = Element.get_defaults()
	defaults.has_on_click = false
	return defaults
end

return Text_Box
