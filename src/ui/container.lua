local BUTTON = require("src.ui.button")
local Container = {}
Container.__index = Container

---@param x number
---@param y number
---@param width number | "fit"
---@param height number | "fit"
---@param x_padding number
---@param y_padding number
---@param display_direction "row" | "column"
---@param spacing "between" | "evenly" | "together"
---@param style? {bg_color?: number[], text_color?: number[], radius?: number} Colors use LÖVE's 0-1 RGB(A) values; radius is in pixels.
---@return Container
function Container:new(x, y, width, height, x_padding, y_padding, display_direction, spacing, style)
	style = style or {}
	local new_container = {
		x = x,
		y = y,
		width = width,
		height = height,
		x_padding = x_padding,
		y_padding = y_padding,
		display_direction = display_direction,
		spacing = spacing,
		bg_color = style.bg_color or { 0.847, 0.024, 0.024, 1 },
		text_color = style.text_color or { 0, 0, 0, 1 },
		radius = style.radius or 0,
		elements = {},
	}

	setmetatable(new_container, Container)

	return new_container
end

function Container:add_element(component_type, parameters)
	local new_element
	if component_type == "button" then
		local button_paramaters = BUTTON.get_defaults()
		for key, value in pairs(parameters or {}) do
			button_paramaters[key] = value
		end
		new_element = BUTTON:new(
			self,
			button_paramaters.width,
			button_paramaters.height,
			button_paramaters.text,
			button_paramaters.on_click,
			button_paramaters.x_padding,
			button_paramaters.y_padding,
			button_paramaters.horizontal_text_align,
			button_paramaters.vertical_text_align,
			button_paramaters
		)
	elseif component_type == "text_box" then
	end

	self.elements[#self.elements + 1] = new_element
end

function Container:render()
	local old_r, old_g, old_b, old_a = love.graphics.getColor()
	love.graphics.setColor(self.bg_color[1], self.bg_color[2], self.bg_color[3], self.bg_color[4] or 1)
	love.graphics.rectangle(
		"fill",
		self.x,
		self.y,
		self.width + (self.x_padding * 2),
		self.height + (self.y_padding * 2),
		self.radius,
		self.radius
	)
	local directional_offset = 0 -- the sum of the meaningfull direction of the elements, so width or height depending on col or row\
	local element_number = 0

	local spacing_offset = 0
	if self.spacing == "evenly" or self.spacing == "between" then
		for _, element in ipairs(self.elements) do
			if self.display_direction == "row" then
				spacing_offset = (spacing_offset + element.width)
			elseif self.display_direction == "column" then
				spacing_offset = (spacing_offset + element.height)
			end
		end
	end

	if self.spacing == "evenly" then
		if self.display_direction == "row" then
			spacing_offset = math.max(0, self.width - spacing_offset) / (#self.elements + 1)
		elseif self.display_direction == "column" then
			spacing_offset = math.max(0, self.height - spacing_offset) / (#self.elements + 1)
		end
	elseif self.spacing == "between" and #self.elements > 1 then
		if self.display_direction == "row" then
			spacing_offset = math.max(0, self.width - spacing_offset) / (#self.elements - 1)
		elseif self.display_direction == "column" then
			spacing_offset = math.max(0, self.height - spacing_offset) / (#self.elements - 1)
		end
	end

	for _, element in ipairs(self.elements) do
		local screen_x, screen_y

		screen_x = self.x_padding + self.x
		screen_y = self.y_padding + self.y

		if self.display_direction == "row" then
			screen_x = screen_x + directional_offset
			directional_offset = directional_offset + element.width
		elseif self.display_direction == "column" then
			screen_y = screen_y + directional_offset
			directional_offset = directional_offset + element.height
		end

		if self.spacing == "evenly" then
			if self.display_direction == "row" then
				screen_x = screen_x + (spacing_offset * (1 + element_number))
			elseif self.display_direction == "column" then
				screen_y = screen_y + (spacing_offset * (1 + element_number))
			end
		elseif self.spacing == "between" then
			if self.display_direction == "row" then
				screen_x = screen_x + (spacing_offset * element_number)
			elseif self.display_direction == "column" then
				screen_y = screen_y + (spacing_offset * element_number)
			end
		end
		element:render(screen_x, screen_y)
		element_number = element_number + 1
	end
	love.graphics.setColor(old_r, old_g, old_b, old_a)
end

return Container
