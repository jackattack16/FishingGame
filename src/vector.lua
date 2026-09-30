---@class Vector
---@field x number
---@field y number
---@field z number
local Vector = {}

Vector.__index = Vector

---@param x? number
---@param y? number
---@param z? number
---@return Vector
function Vector.new(x, y, z)
	local new_vector = {
		x = x or 0,
		y = y or 0,
		z = z or 0,
	}
	setmetatable(new_vector, Vector)

	return new_vector
end

---@param vec1 Vector
---@param vec2 Vector
---@return Vector
function Vector.__add(vec1, vec2)
	return Vector.new(vec1.x + vec2.x, vec1.y + vec2.y, vec1.z + vec2.z)
end

---@param vec1 Vector
---@param vec2 Vector
---@return Vector
function Vector.__sub(vec1, vec2)
	return Vector.new(vec1.x - vec2.x, vec1.y - vec2.y, vec1.z - vec2.z)
end

---@param vec1 Vector
---@param scalar number
---@return Vector
function Vector.__mul(vec1, scalar)
	if type(scalar) == "number" then
		return Vector.new(vec1.x * scalar, vec1.y * scalar, vec1.z * scalar)
	end
end

---@param vec1 Vector
---@param vec2 Vector
---@return number
function Vector.dot(vec1, vec2)
	return (vec1.x * vec2.x) + (vec1.y * vec2.y) + (vec1.z * vec2.z)
end

---@param vec1 Vector
---@param vec2 Vector
---@return Vector
function Vector.cross(vec1, vec2)
	local i = (vec1.y * vec2.z) - (vec2.y * vec1.z)
	local j = (vec1.x * vec2.z) - (vec2.x * vec1.z)
	local k = (vec1.x * vec2.y) - (vec2.y * vec1.x)

	return Vector.new(i, -j, k)
end

---@return number
function Vector:magnitude()
	return math.sqrt((self.x ^ 2) + (self.y ^ 2) + (self.z ^ 2))
end

return Vector
