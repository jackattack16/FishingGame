local Element = require("src.ui.element")
local Spacer = setmetatable({}, { __index = Element })
Spacer.__index = Spacer

---@param width number Resolved width in pixels.
---@param height number Resolved height in pixels.
---@return Spacer
function Spacer:new(width, height)
	return setmetatable({ width = width, height = height, has_on_click = false }, self)
end

function Spacer:render() end

return Spacer
