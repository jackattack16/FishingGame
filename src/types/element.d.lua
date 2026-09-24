---@meta

---@class Element
---@field x number
---@field y number
---@field height number
---@field width number
---@field text love.Text
---@field text_x_offset number
---@field text_y_offset number
---@field bg_color number[]
---@field text_color number[]
---@field radius number
---@field border_color number[]
---@field border_width number
---@field has_on_click boolean
local Element = {}

---Checks if the elements contains a point
---@param x number The x cordinate of the point to check
---@param y number The y cordinate of the point to check
function Element:contains_point(x, y) end
