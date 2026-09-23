---@meta

---@class Container
---@field x number
---@field y number
---@field height number | "fit"
---@field width number | "fit"
---@field x_padding number
---@field y_padding number
---@field display_direction "row" | "column"
---@field spacing "between" | "evenly" | "together"
---@field bg_color number[]
---@field text_color number[]
---@field radius number
---@field elements table
---@field render fun(self: Container) Draws the container and elements to the screen
local Container = {}

---Add an element to this container, size and padding values are percents of the parent size
---@param component_type "button" | "text_box" Element to add.
---@param parameters? {width?: number | "fit", height?: number | "fit", text?: string, on_click?: function, x_padding?: number, y_padding?: number, horizontal_text_align?: "center" | "none", vertical_text_align?: "center" | "none", bg_color?: number[], text_color?: number[], radius?: number} Button options.
function Container:add_element(component_type, parameters) end
