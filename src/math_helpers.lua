local M = {}

function M.round(num, numDecimalPlaces)
	if not numDecimalPlaces then
		return math.floor(num + 0.5)
	else
		local mult = 10 ^ (numDecimalPlaces or 0)
		return math.floor(num * mult + 0.5) / mult
	end
end

return M
