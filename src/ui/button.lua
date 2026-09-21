local Button = {}
Button.__index = Button

---@param x number
---@param y number
---@param height number
---@param width number
---@param on_click function
---@return Button
function Button:new(x, y, height, width, bg_r, bg_g, bg_b, on_click)
	local new_button = {
		x = x,
		y = y,
		height = height,
		width = width,
		r_color = bg_r,
		g_color = bg_g,
		b_color = bg_b,
		on_click = on_click,
	}

	return new_button
end

return Button
