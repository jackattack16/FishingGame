---@meta

---@class Container
---@field x number Resolved screen x in pixels.
---@field x_spec? string Position unit string, recalculated during layout.
---@field y number Resolved screen y in pixels.
---@field y_spec? string Position unit string, recalculated during layout.
---@field height number Resolved content height in pixels.
---@field height_spec? string Size unit string, recalculated during layout.
---@field width number Resolved content width in pixels.
---@field width_spec? string Size unit string, recalculated during layout.
---@field x_padding number
---@field y_padding number
---@field display_direction "row" | "column"
---@field spacing "between" | "evenly" | "together"
---@field bg_color number[]
---@field text_color number[]
---@field radius number
---@field wrap boolean Wrap children into new rows or columns when they exceed the container's main-axis size.
---@field wrap_gap number Percent gap between wrapped rows or columns, based on container height for rows or width for columns.
---@field gap number Minimum percent gap between children, based on container width for rows or height for columns.
---@field elements table
---@field render fun(self: Container) Draws the container and elements to the screen
---@field layout fun(self: Container) Calculates child positions after layout properties change
local Container = {}

---Add a button or text box to this container.
---@param component_type "button" | "textbox" Element to add.
---@param parameters? {width?: number | "fit", height?: number | "fit", text?: string, on_click?: function, x_padding?: number, y_padding?: number, horizontal_text_align?: "center" | "none", vertical_text_align?: "center" | "none", bg_color?: number[], text_color?: number[], radius?: number, border_color?: number[], border_width?: number}
function Container:add_element(component_type, parameters) end

---Check for any click of the child elements
---@param mouse_x number Current x position of the mouse
---@param mouse_y number Current y position of the mouse
function Container:check_clicks(mouse_x, mouse_y) end
