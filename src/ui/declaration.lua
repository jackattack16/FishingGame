local json = require("src.vendor.json")

local function get_container_values(nested)
	return {
		type = "container",
		x = 0,
		y = 0,
		width = nested and 100 or "100%",
		height = nested and 100 or "100%",
		x_padding = 0,
		y_padding = 0,
		padding = 0,
		display_direction = "column",
		spacing = "together",
		bg_color = { 0, 0, 0, 0 },
		text_color = { 0, 0, 0, 1 },
		radius = 0,
		wrap = false,
		wrap_gap = 0,
		gap = 0,
		elements = {},
	}
end

local function get_text_values(component_type)
	return {
		type = component_type,
		width = "fit",
		height = "fit",
		text = "Text goes here",
		x_padding = 0,
		y_padding = 0,
		horizontal_text_align = "center",
		vertical_text_align = "center",
		bg_color = { 1, 1, 1, 1 },
		radius = 0,
		border_color = { 0, 0, 0, 1 },
		border_width = component_type == "button" and 4 or 0,
		has_on_click = component_type == "button",
		variables = {},
	}
end

-- Child sizes are numeric percentages in FishingGame; root geometry keeps its strings.
local function get_percentage(value, field, component_type)
	if type(value) == "table" and value.bind then
		return value
	end
	if type(value) == "string" then
		if value:match("^%d+%.?%d*px$") then
			return value
		end
		local percentage = value:match("^(%d+%.?%d*)%%$")
		if percentage then
			return tonumber(percentage)
		end
	end
	assert(
		(type(value) == "number" and value >= 0)
			or (value == "fit" and component_type ~= "container" and component_type ~= "spacer"),
		component_type
			.. "."
			.. field
			.. " must be a nonnegative percentage or pixel string"
			.. ((component_type ~= "container" and component_type ~= "spacer") and " or 'fit'" or "")
	)
	return value
end

local function get_element_values(element, nested)
	assert(type(element) == "table", "Each UI component must be an object")
	if element.use or element["repeat"] then
		return element
	end
	local component_type = element.type
	local values
	if component_type == "container" then
		values = get_container_values(nested)
	elseif component_type == "button" or component_type == "textbox" then
		values = get_text_values(component_type)
	elseif component_type == "image" then
		assert(element.image, "Image components need an image resource name or path")
		values = { type = "image", width = "fit", height = "fit", has_on_click = false }
	elseif component_type == "spacer" then
		values = { type = "spacer", has_on_click = false }
	else
		error("Unknown UI component type: " .. tostring(component_type))
	end

	-- Keep resource names, callback names, and binding declarations as data.
	for key, value in pairs(element) do
		if key ~= "elements" then
			values[key] = value
		end
	end

	if nested then
		values.width = get_percentage(values.width, "width", component_type)
		values.height = get_percentage(values.height, "height", component_type)
	end
	if component_type == "button" or component_type == "textbox" then
		values.x_padding = element.x_padding or element.padding or 0
		values.y_padding = element.y_padding or element.padding or 0
	end
	if component_type == "container" then
		assert(element.elements == nil or type(element.elements) == "table", "Container elements must be an array")
		for _, child in ipairs(element.elements or {}) do
			values.elements[#values.elements + 1] = get_element_values(child, true)
		end
	end
	return values
end

local function load(path)
	assert(type(path) == "string", "UI declarations need a JSON file path")
	local contents
	if love and love.filesystem then
		contents = assert(love.filesystem.read(path))
	else
		local file = assert(io.open(path, "r"))
		contents = file:read("*a")
		file:close()
	end
	local definition = json.decode(contents)
	assert(type(definition) == "table" and type(definition.window) == "table", "UI JSON needs a window array")

	local external_containers = {}
	for _, container in ipairs(definition.window) do
		assert(
			type(container) == "table" and (container.type == "container" or container.use),
			"Window entries must be containers"
		)
		external_containers[#external_containers + 1] = get_element_values(container, false)
	end
	return external_containers, definition.templates or {}
end

return { load = load, normalize = get_element_values }
