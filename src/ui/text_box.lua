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
---@param style? {bg_color?: number[], text_color?: number[], radius?: number, border_color?: number[], border_width?: number, variables?: table<string, any>, font?: love.Font, text_align?: "left" | "center" | "right"}
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
	element.text_align = style and style.text_align
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
	if rendered ~= self.rendered_text or self.rendered_width ~= self.width then
		if self.text_align or self.horizontal_text_align == "center" then
			self.text:setf(rendered, self.width, self.text_align or "center")
			self.text_x_offset = 0
		else
			self.text:set(rendered)
		end
		self.rendered_text = rendered
		self.rendered_width = self.width
		if self.vertical_text_align == "center" then
			self.text_y_offset = math.max(0, (self.height - self.text:getHeight()) / 2)
		end
	end
	Element.render(self)
end

return Text_Box
