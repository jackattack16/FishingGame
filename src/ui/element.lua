local Element = {}
Element.__index = Element

---@generic T: Element
---@param self T
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
---@return T
function Element:new(
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
	style = style or {}
	x_padding = (x_padding / 100) * parent.width
	y_padding = (y_padding / 100) * parent.height

	local created_text = love.graphics.newText(love.graphics.getFont(), text)
	local text_width = created_text:getWidth()
	local text_height = created_text:getHeight()

	local calculated_width
	if width == "fit" then
		calculated_width = text_width + (x_padding * 2)
	else
		calculated_width = (width / 100) * parent.width
	end

	local calculated_height
	if height == "fit" then
		calculated_height = text_height + (y_padding * 2)
	else
		calculated_height = (height / 100) * parent.height
	end

	local calculated_text_x_offset = 0
	if horizontal_text_align == "center" and calculated_width > text_width then
		calculated_text_x_offset = (calculated_width - text_width) / 2
	end

	local calculated_text_y_offset = 0
	if vertical_text_align == "center" and calculated_height > text_height then
		calculated_text_y_offset = (calculated_height - text_height) / 2
	end

	local new_element = {
		width = calculated_width,
		height = calculated_height,
		text = created_text,
		text_x_offset = calculated_text_x_offset,
		text_y_offset = calculated_text_y_offset,
		bg_color = style.bg_color or { 1, 1, 1, 1 },
		text_color = style.text_color or parent.text_color or { 0, 0, 0, 1 },
		radius = style.radius or 0,
		border_color = style.border_color or { 0, 0, 0, 1 },
		border_width = style.border_width or 0,
		has_on_click = has_on_click,
	}

	return setmetatable(new_element, self)
end

function Element.get_defaults()
	return {
		width = "fit",
		height = "fit",
		text = "Text goes here",
		x_padding = 0,
		y_padding = 0,
		horizontal_text_align = "center",
		vertical_text_align = "center",
		border_color = { 0, 0, 0, 1 },
	}
end

function Element:render()
	local x, y = self.x, self.y
	local old_r, old_g, old_b, old_a = love.graphics.getColor()
	local old_line_width = love.graphics.getLineWidth()
	love.graphics.setColor(self.bg_color[1], self.bg_color[2], self.bg_color[3], self.bg_color[4] or 1)
	love.graphics.rectangle("fill", x, y, self.width, self.height, self.radius, self.radius)
	if self.border_width > 0 then
		local border_width = math.min(self.border_width, self.width, self.height)
		local inset = border_width / 2
		love.graphics.setLineWidth(border_width)
		love.graphics.setColor(
			self.border_color[1],
			self.border_color[2],
			self.border_color[3],
			self.border_color[4] or 1
		)
		love.graphics.rectangle(
			"line",
			x + inset,
			y + inset,
			self.width - border_width,
			self.height - border_width,
			math.max(0, self.radius - inset),
			math.max(0, self.radius - inset)
		)
	end
	love.graphics.setColor(self.text_color[1], self.text_color[2], self.text_color[3], self.text_color[4] or 1)
	love.graphics.draw(self.text, x + self.text_x_offset, y + self.text_y_offset)
	love.graphics.setLineWidth(old_line_width)
	love.graphics.setColor(old_r, old_g, old_b, old_a)
end

function Element:contains_point(x, y)
	return x >= self.x and x < self.x + self.width and y >= self.y and y < self.y + self.height
end

return Element
