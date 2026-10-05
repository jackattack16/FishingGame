function love.errorhandler(message)
	print(debug.traceback(message, 2))
	return function()
		return 1
	end
end

function love.load()
	local UI = require("src.ui.json_ui")
	local state = { money = 12 }
	local chosen = {}
	local definitions = {
		{
			type = "container",
			width = 200,
			height = 120,
			elements = {
				{
					type = "textbox",
					id = "money",
					width = "100%",
					height = "20px",
					text = "Money: ${money}$",
					variables = { money = { bind = "money" } },
				},
				{ use = "choice", ["repeat"] = "items" },
				{ type = "textbox", when = { bind = "hidden" }, text = "Hidden" },
			},
		},
	}
	local templates = {
		choice = {
			type = "button",
			id = { bind = "item.id" },
			text = { bind = "item.name" },
			width = "100%",
			height = "20px",
			on_click = "choose",
			has_on_click = { bind = "item.enabled" },
		},
	}
	local context = {
		money = function()
			return state.money
		end,
		hidden = false,
		items = { { id = "one", name = "One", enabled = true }, { id = "two", name = "Two", enabled = false } },
		actions = {
			choose = function(c)
				chosen[#chosen + 1] = c.item.id
			end,
		},
	}
	local view = UI.build(definitions, context, templates)
	assert(#view.containers[1].elements == 3, "Repeat and conditional children must build correctly")
	assert(math.abs(view.by_id.money.height - 20) < 0.000001, "Pixel heights must resolve correctly")
	view.by_id.money:render()
	assert(view.by_id.money.rendered_text == "Money: 12")
	state.money = 99
	view.by_id.money:render()
	assert(view.by_id.money.rendered_text == "Money: 99", "Text bindings must stay live")
	local first, second = view.by_id.one, view.by_id.two
	assert(view.containers[1]:check_clicks(first.x + 1, first.y + 1))
	assert(chosen[1] == "one")
	assert(not view.containers[1]:check_clicks(second.x + 1, second.y + 1))
	second.has_on_click = true
	assert(view.containers[1]:check_clicks(second.x + 1, second.y + 1))
	assert(chosen[2] == "two", "Repeated callbacks must capture the correct item")
	local rebuilt = UI.build(definitions, context, templates)
	assert(rebuilt.by_id.two.has_on_click == false and templates.choice.on_click == "choose")
	local bad = { { type = "container", width = { bind = "missing" } } }
	local ok, message = pcall(UI.build, bad, context)
	assert(not ok and message:match("Unknown UI binding"))
	local hud = UI.load("assets/ui/fishing_hud.json", {
		money = function()
			return 3
		end,
		bait = function()
			return 5
		end,
	})
	assert(#hud.containers == 2 and #hud.by_id.left_bar.elements == 4)
	print(
		"JSON UI verified: recursive builds, live text, repeated callback scopes, false values, pixel sizes and errors"
	)
	love.event.quit()
end
