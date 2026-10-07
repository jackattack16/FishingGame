local UI = require("src.ui.json_ui")
local theme = require("src.ui.shop_theme")
local game = require("src.game_functions")
local state = require("src.globals.globals")
local fish_sprites = require("src.fish_sprites")
local Menu = {}
local definitions, templates

local function dollars(value)
	return string.format("$%.2f", value)
end

-- Keep sizes editable as "40px" in JSON. Scale a copy for the current window;
-- percentages stay percentages, and fonts are created at their actual pixel size.
local function scale_sizes(value, scale)
	if type(value) ~= "table" then
		return value
	end
	local copy = {}
	for key, child in pairs(value) do
		local pixels = type(child) == "string" and child:match("^(%d+%.?%d*)px$")
		local pixel_number = key == "radius"
			or key == "border_width"
			or (value.type == "container" and (key == "padding" or key == "x_padding" or key == "y_padding"))
		if pixels then
			copy[key] = tostring(tonumber(pixels) * scale) .. "px"
		elseif pixel_number and type(child) == "number" then
			copy[key] = child * scale
		else
			copy[key] = scale_sizes(child, scale)
		end
	end
	return copy
end

function Menu.build(shop, fonts, viewport)
	if not definitions then
		definitions, templates = require("src.ui.declaration").load("assets/ui/shop.json")
	end
	local function can_buy(c)
		return state.money >= c.item.price
	end
	local context = {
		fonts = fonts,
		colors = theme.colors,
		viewport = viewport,
		root_width = (theme.layout.width - definitions[1].x_padding * 2) * viewport.scale,
		root_height = (theme.layout.height - definitions[1].y_padding * 2) * viewport.scale,
		packs = shop.packs,
		catches = state.fish_caught_this_round,
		sell_phase = shop.phase == "sell",
		pack_phase = shop.phase == "packs",
		empty_catch = #state.fish_caught_this_round == 0,
		phase_title = shop.phase == "sell" and "1 / 2   SELL / PROCESS" or "2 / 2   PACK SHOP",
		cash = "Cash  " .. dollars(state.money),
		round = "Round  " .. state.round,
		pond_stock = "Pond  " .. #state.pond .. " fish",
		message = shop.message,
		sale_text = #state.fish_caught_this_round > 0 and ("Sell catch  " .. dollars(
			game.get_sum_of_fish_values(state.fish_caught_this_round)
		)) or "Continue to packs",
		fish_image = fish_sprites.get_image,
		catch_quad = function(c)
			return fish_sprites.get_quad(c.item)
		end,
		catch_id = function(c)
			return "catch_card" .. c.index
		end,
		catch_stats = function(c)
			return string.format("%.2f kg / %.1f cm", c.item.weight, c.item.length)
		end,
		catch_price = function(c)
			return dollars(c.item.price)
		end,
		pack_price = function(c)
			return dollars(c.item.price)
		end,
		bought_text = function(c)
			local count = state.shop_purchases[c.item.id] or 0
			return count > 0 and ("Bought x" .. count) or ""
		end,
		buy_text = function(c)
			return can_buy(c) and "Buy pack" or "Too expensive"
		end,
		buy_color = function(c)
			return can_buy(c) and theme.colors.button or theme.colors.disabled
		end,
		buy_text_color = function(c)
			return can_buy(c) and theme.colors.text or theme.colors.muted
		end,
		actions = {
			buy = function(c)
				shop.buy(c.item)
			end,
			sell_catch = function()
				shop.sell_catch()
			end,
			next_round = function()
				shop.next_round(shop.rng)
			end,
		},
	}
	local view = UI.build(scale_sizes(definitions, viewport.scale), context, scale_sizes(templates, viewport.scale))
	return view.by_id.shop_root, view.by_id
end

return Menu
