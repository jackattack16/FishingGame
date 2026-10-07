---@class Animation
---@field curve love.BezierCurve
---@field start_value number
---@field total_change number
---@field total_frames number
---@field current_frame number
local Animation = {}

Animation.__index = Animation
---Creates a new bezier animation curve
---@param cx1 number
---@param cy1 number
---@param cx2 number
---@param cy2 number
---@param starting_value number
---@param ending_value number
---@param number_of_frames number
---@param more_points? {cx3?: number, cy3?: number, cx4?: number, cy4?: number}
---@return Animation
function Animation:new(cx1, cy1, cx2, cy2, starting_value, ending_value, number_of_frames, more_points)
	local start_x, start_y = 0, 0
	local end_x, end_y = 1, -1
	local control_1_x, control_1_y = cx1, 0 - cy1
	local control_2_x, control_2_y = cx2, 0 - cy2
	local points = { start_x, start_y, control_1_x, control_1_y, control_2_x, control_2_y }

	if more_points ~= nil then
		if more_points.cx3 and more_points.cy3 then
			local control_3_x, control_3_y = more_points.cx3, 0 - more_points.cy3
			table.insert(points, control_3_x)
			table.insert(points, control_3_y)
			if more_points.cx4 and more_points.cy4 then
				table.insert(points, more_points.cx4)
				table.insert(points, 0 - more_points.cy4)
			end
		end
	end

	table.insert(points, end_x)
	table.insert(points, end_y)
	local new_curve = love.math.newBezierCurve(points)

	local new_animation = {
		curve = new_curve,
		start_value = starting_value,
		total_change = ending_value - starting_value,
		total_frames = number_of_frames,
		current_frame = 0,
	}
	setmetatable(new_animation, Animation)
	return new_animation
end

---Evaluates the curve
function Animation:evaluate()
	local _, progress = self.curve:evaluate(self.current_frame / self.total_frames)

	local new_value = self.start_value + (-progress * self.total_change)

	self.current_frame = self.current_frame + 1
	return new_value
end

function Animation:reset()
	self.current_frame = 0
end

return Animation
