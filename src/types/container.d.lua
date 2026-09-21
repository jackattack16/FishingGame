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
---@field elements table
---@field add_element fun(self: Container, component_type: "button" | "text_box", parameters?: {width?: number | "fit", height?: number | "fit", text?: string, on_click?: function, x_padding?: number, y_padding?: number, horizontal_text_align?: "center" | "none", vertical_text_align?: "center" | "none"}) Add an element; unspecified button options use defaults.
---@field render fun(self: Container) Draws the container and elements to the screen
local Container = {}
