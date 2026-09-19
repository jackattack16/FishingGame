local function distanceBetweenPoints(x1, y1, x2, y2)
	return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

--- @class MathHelp
local MathHelp = {}

local function isBody(value)
	return type(value) == "userdata" and value:typeOf("Body")
end

--- Calculates the distance between two physics bodies or points.
--- @overload fun(self: MathHelp, x1: number, y1: number, x2: number, y2: number): number
--- @overload fun(self: MathHelp, body1: love.Body, body2: love.Body): number
--- @overload fun(self: MathHelp, body: love.Body, x: number, y: number): number
--- @overload fun(self: MathHelp, x: number, y: number, body: love.Body): number
--- @param arg1 love.Body|number The first body, or the first point's x coordinate.
--- @param arg2 love.Body|number The second body, or the first point's y coordinate.
--- @param arg3? love.Body|number A point coordinate or body, depending on the overload.
--- @param arg4? number The second point's y coordinate when passing four numbers.
--- @return number distance The straight-line distance between the two positions.
function MathHelp:getDistance(arg1, arg2, arg3, arg4)
	if type(arg1) == "number" and type(arg2) == "number" and type(arg3) == "number" and type(arg4) == "number" then
		return distanceBetweenPoints(arg1, arg2, arg3, arg4)
	elseif isBody(arg1) and isBody(arg2) then
		local x1, y1 = arg1:getPosition()
		local x2, y2 = arg2:getPosition()
		return distanceBetweenPoints(x1, y1, x2, y2)
	elseif isBody(arg1) and type(arg2) == "number" and type(arg3) == "number" then
		local x1, y1 = arg1:getPosition()
		return distanceBetweenPoints(x1, y1, arg2, arg3)
	elseif type(arg1) == "number" and type(arg2) == "number" and isBody(arg3) then
		local x2, y2 = arg3:getPosition()
		return distanceBetweenPoints(arg1, arg2, x2, y2)
	end

	error("getDistance expects two bodies, a body and an (x, y) point, or four coordinates", 2)
end

return MathHelp
