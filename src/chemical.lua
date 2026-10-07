local CHEMICAL_TYPES = require("src.chemical_types")
local Chemical = {}

Chemical.__index = Chemical

---Creates a new chemical
---@param type "food" | "piscicide" | "sterilizer"
---@param target_fish string
---@return Chemical
function Chemical:new(type, target_fish)
	local new_chemical
	if type == "food" then
		new_chemical = make_instance(CHEMICAL_TYPES[target_fish].food[1])
	elseif type == "piscicide" then
		new_chemical = make_instance(CHEMICAL_TYPES[target_fish].piscicide[1])
	elseif type == "sterilizer" then
		new_chemical = make_instance(CHEMICAL_TYPES[target_fish].sterilizer[1])
	end
	return new_chemical
end

function make_instance(definition)
	local instance = {}
	for key, value in pairs(definition) do
		instance[key] = value
	end
	return instance
end

return Chemical
