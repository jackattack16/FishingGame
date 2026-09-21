local BUTTON = require("src.ui.button")
local Container = {}
Container.__index = Container

---@param x number
---@param y number
---@param height number | "fit"
---@param width number | "fit"
---@param x_padding number
---@param y_padding number
---@param display_direction "row" | "column"
---@param spacing "between" | "evenly" | "together"
---@return Container
function Container:new(x, y, height, width, x_padding, y_padding, display_direction, spacing)
	local new_container = {
		x = x,
		y = y,
		width = width,
		height = height,
		x_padding = x_padding,
		y_padding = y_padding,
		display_direction = display_direction,
		spacing = spacing,
		elements = {},
	}

	setmetatable(new_container, Container)

	return new_container
end

---Add an element to this container. Button options are optional:<br>
---`width` / `height`: number or `"fit"` (default `"fit"`). These are percents<br>
---`text`: label (default `"Text goes here"`).<br>
---`on_click`: callback (default placeholder).<br>
---`x_padding` / `y_padding`: percents of the container width / height (default `0`).<br>
---`horizontal_text_align` / `vertical_text_align`: `"center"` or `"none"` (default `"none"`).
---@param component_type "button" | "text_box" Element to add.
---@param parameters? {width?: number | "fit", height?: number | "fit", text?: string, on_click?: function, x_padding?: number, y_padding?: number, horizontal_text_align?: "center" | "none", vertical_text_align?: "center" | "none"} Button options.
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
			button_paramaters.vertical_text_align
		)
	elseif component_type == "text_box" then
		-- new_element = BUTTON:new(parameters.width, parameters.height, parameters.text, parameters.on_click)
	end

	self.elements[#self.elements + 1] = new_element
end

function Container:render()
	--- Just doing column first
	local running_offset = 0 -- the sum of the meaningfull direction of the elements, so width or height depending on col or row
	for _, element in ipairs(self.elements) do
		local screen_x, screen_y

		screen_x = self.x_padding + self.x + running_offset
		screen_y = self.y_padding + self.y

		element:render(screen_x, screen_y)
	end
end

return Container
