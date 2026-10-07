local Container = require("src.ui.container")
local declaration = require("src.ui.declaration")
local UI = {}

local function lookup(context, name)
	local value = context
	for part in name:gmatch("[^.]+") do
		assert(type(value) == "table", "Cannot resolve UI binding: " .. name)
		value = value[part]
	end
	assert(value ~= nil, "Unknown UI binding: " .. name)
	if type(value) == "function" then
		return value(context)
	end
	return value
end

local function resolve(value, context)
	if type(value) == "table" and value.bind then
		local resolved = lookup(context, value.bind)
		return value.unit == "px" and (tostring(resolved) .. "px") or resolved
	end
	return value
end

local function scope(context, parent, item, index)
	local result = {}
	for key, value in pairs(context) do
		result[key] = value
	end
	result.parent = parent
	if item ~= nil then
		result.item, result.index = item, index
	end
	return result
end

local function expand(node, templates)
	local result = {}
	if node.use then
		local template = assert(templates[node.use], "Unknown UI template: " .. tostring(node.use))
		assert(not template.use, "UI templates cannot inherit another template")
		for key, value in pairs(template) do
			result[key] = value
		end
	end
	for key, value in pairs(node) do
		result[key] = value
	end
	result.use = nil
	return result
end

local function child_size(value, parent_size)
	if type(value) == "string" then
		local pixels = value:match("^(%d+%.?%d*)px$")
		if pixels then
			return parent_size > 0 and tonumber(pixels) / parent_size * 100 or 0
		end
	end
	return value
end

local function build_node(node, parent, context, templates, view)
	local options = expand(node, templates)
	if options["repeat"] then
		local items = lookup(context, options["repeat"])
		assert(type(items) == "table", "UI repeat binding must return an array")
		options["repeat"] = nil
		for index, item in ipairs(items) do
			build_node(options, parent, scope(context, parent, item, index), templates, view)
		end
		return
	end
	context = scope(context, parent)
	if options.when ~= nil and not resolve(options.when, context) then
		return
	end
	local children = options.elements or {}
	local variables = options.variables or {}
	local callback = options.on_click
	options.elements, options.variables, options.on_click = nil, nil, nil
	options.when = nil
	for key, value in pairs(options) do
		options[key] = resolve(value, context)
	end
	-- Normalize after resolving bindings, keeping each node's children for this walker.
	options = declaration.normalize(options, parent ~= nil)
	if parent then
		options.width = child_size(options.width, parent.width)
		options.height = child_size(options.height, parent.height)
	end
	options.variables = {}
	for name, value in pairs(variables) do
		if type(value) == "table" and value.bind then
			local binding = value.bind
			options.variables[name] = function()
				return lookup(context, binding)
			end
		else
			options.variables[name] = value
		end
	end
	if callback then
		assert(type(callback) == "string", "on_click must name a Lua action")
		local action = assert(context.actions and context.actions[callback], "Unknown UI action: " .. callback)
		options.on_click = function()
			action(context)
		end
	end
	if type(options.font) == "string" then
		options.font = options.font == "default" and love.graphics.getFont()
			or assert(context.fonts and context.fonts[options.font], "Unknown UI font: " .. options.font)
	end
	if type(options.image) == "string" then
		view.images[options.image] = view.images[options.image] or love.graphics.newImage(options.image)
		options.image = view.images[options.image]
	end
	local component
	if parent then
		component = parent:add_element(options.type, options)
	else
		assert(options.type == "container", "UI roots must be containers")
		component = Container:new(
			options.x,
			options.y,
			options.width,
			options.height,
			options.x_padding,
			options.y_padding,
			options.display_direction,
			options.spacing,
			options
		)
		view.containers[#view.containers + 1] = component
	end
	if options.id then
		assert(not view.by_id[options.id], "Duplicate UI id: " .. tostring(options.id))
		view.by_id[options.id] = component
	end
	for _, child in ipairs(children) do
		assert(component.is_container, "Only containers can have elements")
		build_node(child, component, context, templates, view)
	end
	return component
end

-- Returns the ordinary Container/Element objects, plus an index for named controls.
function UI.build(definitions, context, templates)
	local view = { containers = {}, by_id = {}, images = {} }
	for _, node in ipairs(definitions) do
		build_node(node, nil, context or {}, templates or {}, view)
	end
	return view
end

function UI.load(path, context)
	local definitions, templates = declaration.load(path)
	return UI.build(definitions, context, templates)
end

return UI
