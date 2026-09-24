local BUTTON = require("src.ui.button")
local TEXT_BOX = require("src.ui.text_box")
local Container = {}
Container.__index = Container

-- Numeric and "px" sizes are content pixels. Percent and "full" sizes include padding.
local function resolve_size(value, window_size, position, padding)
	if type(value) == "number" then
		return value
	end
	if value == "full" then
		return math.max(0, window_size - position - (padding * 2))
	end
	if type(value) == "string" then
		local percent = value:match("^(%d+%.?%d*)%%$")
		if percent then
			return math.max(0, window_size * tonumber(percent) / 100 - (padding * 2))
		end
		local pixels = value:match("^(%d+%.?%d*)px$")
		if pixels then
			return tonumber(pixels)
		end
	end
	error("Container size must be a number, a pixel string like '200px', a percent string like '50%', or 'full'")
end

-- "full" places the far edge of the container at the window edge.
local function resolve_position(value, window_size, outer_size)
	if type(value) == "number" then
		return value
	end
	if value == "full" then
		return window_size - outer_size
	end
	if type(value) == "string" then
		local percent = value:match("^(%d+%.?%d*)%%$")
		if percent then
			return window_size * tonumber(percent) / 100
		end
		local pixels = value:match("^(%d+%.?%d*)px$")
		if pixels then
			return tonumber(pixels)
		end
	end
	error("Container position must be a number, a pixel string like '200px', a percent string like '50%', or 'full'")
end

local function resolve_geometry(container)
	local window_width, window_height = love.graphics.getDimensions()
	local x_value = container.x_spec or container.x
	local y_value = container.y_spec or container.y
	local width_value = container.width_spec or container.width
	local height_value = container.height_spec or container.height

	local provisional_x = x_value == "full" and 0 or resolve_position(x_value, window_width, 0)
	local provisional_y = y_value == "full" and 0 or resolve_position(y_value, window_height, 0)
	container.width = resolve_size(width_value, window_width, provisional_x, container.x_padding)
	container.height = resolve_size(height_value, window_height, provisional_y, container.y_padding)
	container.x = resolve_position(x_value, window_width, container.width + container.x_padding * 2)
	container.y = resolve_position(y_value, window_height, container.height + container.y_padding * 2)
end

---@param x number | string Number or "200px" sets pixels; "50%" is half the window width; "full" aligns the right edge.
---@param y number | string Number or "200px" sets pixels; "50%" is half the window height; "full" aligns the bottom edge.
---@param width number | string Number or "200px" sets content pixels; "50%" sets outer width to half the window; "full" fills from x to the right edge. Recomputed on layout.
---@param height number | string Number or "200px" sets content pixels; "50%" sets outer height to half the window; "full" fills from y to the bottom edge. Recomputed on layout.
---@param x_padding number
---@param y_padding number
---@param display_direction "row" | "column"
---@param spacing "between" | "evenly" | "together"
---@param style? {bg_color?: number[], text_color?: number[], radius?: number, wrap?: boolean, wrap_gap?: number, gap?: number} Colors use LOVE 0-1 RGB(A); radius is in pixels; gap is a percent of the main axis, and wrap_gap is a percent of the cross axis.
---@return Container
function Container:new(x, y, width, height, x_padding, y_padding, display_direction, spacing, style)
	style = style or {}
	local new_container = {
		x = type(x) == "number" and x or 0,
		y = type(y) == "number" and y or 0,
		width = type(width) == "number" and width or 0,
		height = type(height) == "number" and height or 0,
		x_spec = type(x) == "string" and x or nil,
		y_spec = type(y) == "string" and y or nil,
		width_spec = type(width) == "string" and width or nil,
		height_spec = type(height) == "string" and height or nil,
		x_padding = x_padding,
		y_padding = y_padding,
		display_direction = display_direction,
		spacing = spacing,
		bg_color = style.bg_color or { 0.847, 0.024, 0.024, 1 },
		text_color = style.text_color or { 0, 0, 0, 1 },
		radius = style.radius or 0,
		wrap = style.wrap or false,
		wrap_gap = style.wrap_gap or 0,
		gap = style.gap or 0,
		elements = {},
	}

	setmetatable(new_container, Container)
	new_container:layout()

	return new_container
end

---Add a button or text box to this container.
---@param component_type "button" | "textbox"
---@param parameters? {width?: number | "fit", height?: number | "fit", text?: string, on_click?: function, x_padding?: number, y_padding?: number, horizontal_text_align?: "center" | "none", vertical_text_align?: "center" | "none", bg_color?: number[], text_color?: number[], radius?: number, border_color?: number[], border_width?: number}
function Container:add_element(component_type, parameters)
	local new_element
	if component_type == "button" then
		local button_paramaters = BUTTON.get_defaults()
		for key, value in pairs(parameters or {}) do
			button_paramaters[key] = value
		end
		new_element = BUTTON:new(
			self,
			button_paramaters.has_on_click,
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
	elseif component_type == "textbox" then
		local text_box_paramaters = TEXT_BOX.get_defaults()
		for key, value in pairs(parameters or {}) do
			text_box_paramaters[key] = value
		end
		new_element = TEXT_BOX:new(
			self,
			text_box_paramaters.has_on_click,
			text_box_paramaters.width,
			text_box_paramaters.height,
			text_box_paramaters.text,
			text_box_paramaters.x_padding,
			text_box_paramaters.y_padding,
			text_box_paramaters.horizontal_text_align,
			text_box_paramaters.vertical_text_align,
			text_box_paramaters
		)

	end

	self.elements[#self.elements + 1] = new_element
	self:layout()
end

function Container:layout()
	resolve_geometry(self)
	local is_row = self.display_direction == "row"
	local available = is_row and self.width or self.height
	local cross_available = is_row and self.height or self.width
	local gap = (self.gap / 100) * available
	local wrap_gap = (self.wrap_gap / 100) * cross_available
	local lines = {}
	local line = { elements = {}, main_size = 0, cross_size = 0 }

	for _, element in ipairs(self.elements) do
		local main_size = is_row and element.width or element.height
		local cross_size = is_row and element.height or element.width
		if self.wrap and #line.elements > 0 and line.main_size + gap + main_size > available then
			lines[#lines + 1] = line
			line = { elements = {}, main_size = 0, cross_size = 0 }
		end
		if #line.elements > 0 then
			line.main_size = line.main_size + gap
		end
		line.elements[#line.elements + 1] = element
		line.main_size = line.main_size + main_size
		line.cross_size = math.max(line.cross_size, cross_size)
	end
	if #line.elements > 0 then
		lines[#lines + 1] = line
	end

	local cross_offset = 0
	for _, current_line in ipairs(lines) do
		local count = #current_line.elements
		local free_space = math.max(0, available - current_line.main_size)
		local spacing_offset = 0
		if self.spacing == "evenly" then
			spacing_offset = free_space / (count + 1)
		elseif self.spacing == "between" and count > 1 then
			spacing_offset = free_space / (count - 1)
		end

		local main_offset = 0
		for index, element in ipairs(current_line.elements) do
			local spacing_gap = 0
			if self.spacing == "evenly" then
				spacing_gap = spacing_offset * index
			elseif self.spacing == "between" then
				spacing_gap = spacing_offset * (index - 1)
			end
			if is_row then
				element.x = self.x + self.x_padding + main_offset + spacing_gap
				element.y = self.y + self.y_padding + cross_offset
				main_offset = main_offset + element.width + gap
			else
				element.x = self.x + self.x_padding + cross_offset
				element.y = self.y + self.y_padding + main_offset + spacing_gap
				main_offset = main_offset + element.height + gap
			end
		end
		cross_offset = cross_offset + current_line.cross_size + wrap_gap
	end
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
	for _, element in ipairs(self.elements) do
		element:render()
	end
	love.graphics.setColor(old_r, old_g, old_b, old_a)
end

function Container:check_clicks(mouse_x, mouse_y)
	for _, element in ipairs(self.elements) do
		if element.has_on_click and element:contains_point(mouse_x, mouse_y) then
			element.on_click()
			return
		end
	end
end
return Container
