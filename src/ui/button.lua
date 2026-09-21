local Button = {}
Button.__index = Button

---@param parent Container
---@param width number | "fit"
---@param height number | "fit"
---@param text string
---@param on_click function
---@param x_padding number
---@param y_padding number
---@param horizontal_text_align "center" | "none"
---@param vertical_text_align "center" | "none"
---@return Button
function Button:new(
	parent,
	width,
	height,
	text,
	on_click,
	x_padding,
	y_padding,
	horizontal_text_align,
	vertical_text_align
)
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
	if horizontal_text_align == "center" then
		if calculated_width > text_width then
			local remaining_width = calculated_width - text_width
			calculated_text_x_offset = remaining_width / 2
		end
	end

	local calculated_text_y_offset = 0
	if vertical_text_align == "center" then
		if calculated_height > text_height then
			local remaining_height = calculated_height - text_height
			calculated_text_y_offset = remaining_height / 2
		end
	end

	local new_button = {
		width = calculated_width,
		height = calculated_height,
		on_click = on_click,
		text = created_text,
		text_x_offset = calculated_text_x_offset,
		text_y_offset = calculated_text_y_offset,
	}

	setmetatable(new_button, Button)

	return new_button
end

local default_onclick = function()
	print("no function supplied")
end

function Button.get_defaults()
	return {
		width = "fit",
		height = "fit",
		text = "Text goes here",
		on_click = default_onclick,
		x_padding = 0,
		y_padding = 0,
		horizontal_text_align = "none",
		vertical_text_align = "none",
	}
end

function Button:render(x, y)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle("fill", x, y, self.width, self.height)
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.draw(self.text, x + self.text_x_offset, y + self.text_y_offset)
end

return Button
