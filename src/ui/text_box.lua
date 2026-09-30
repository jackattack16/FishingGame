local Element = require("src.ui.element")
local Text_Box = setmetatable({}, { __index = Element })
Text_Box.__index = Text_Box

---Draw text; use ${name}$ with a variables table for dynamic values.
---@param parent Container
---@param has_on_click boolean
---@param width number | "fit"
---@param height number | "fit"
---@param text string
---@param x_padding number
---@param y_padding number
---@param horizontal_text_align "center" | "none"
---@param vertical_text_align "center" | "none"
---@param style? {bg_color?: number[], text_color?: number[], radius?: number, border_color?: number[], border_width?: number, variables?: table<string, any>}
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
	local element = Element.new(
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
	element.variables = style and style.variables or {}
	return element
end

function Text_Box.get_defaults()
	local defaults = Element.get_defaults()
	defaults.has_on_click = false
	return defaults
end

function Text_Box:render()
	local rendered = self.text_string:gsub("%${([%w_]+)}%$", function(name)
		local value = self.variables[name]
		if type(value) == "function" then
			value = value()
		end
		return value == nil and "${" .. name .. "}$" or tostring(value)
	end)
	if rendered ~= self.rendered_text then
		if self.horizontal_text_align == "center" then
			self.text:setf(rendered, self.width, "center")
			self.text_x_offset = 0
		else
			self.text:set(rendered)
		end
		self.rendered_text = rendered
	end
	Element.render(self)
end

return Text_Box
