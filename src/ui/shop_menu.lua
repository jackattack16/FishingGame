local UI = require("src.ui.json_ui")
local theme = require("src.ui.shop_theme")
local game = require("src.game_functions")
local state = require("src.globals.globals")
local fish_sprites = require("src.fish_sprites")
local Menu = {}
local definitions, templates

local function percent(pixels, size)
	return size > 0 and pixels / size * 100 or 0
end
local function dollars(value)
	return string.format("$%.2f", value)
end

-- JSON owns the component tree; Lua provides values and actions for each build.
function Menu.build(shop, fonts, viewport)
	if not definitions then
		definitions, templates = require("src.ui.declaration").load("assets/ui/shop.json")
	end
	local layout = {}
	for name, value in pairs(theme.layout) do
		layout[name] = (name == "columns" or name == "catch_columns") and value or value * viewport.scale
	end
	local colors = theme.colors
	local function owned(context)
		return state.shop_purchases[context.item.id] or 0
	end
	local function can_buy(context)
		local item = context.item
		return not item.planned and state.money >= item.price and not (item.unique and owned(context) > 0)
	end
	local context = {
		shop = shop,
		state = state,
		fonts = fonts,
		viewport = viewport,
		layout = layout,
		colors = colors,
		root_width = layout.width - layout.padding_x * 2,
		root_height = layout.height - layout.padding_y * 2,
		small_height = fonts.small:getHeight(),
		heading_height = fonts.heading:getHeight(),
		body_font_height = fonts.body:getHeight(),
		title_height = fonts.title:getHeight(),
		statistic_height = function(c)
			return c.parent.height - fonts.small:getHeight()
		end,
		cash = function()
			return dollars(state.money)
		end,
		pond_stock = function()
			return #state.pond .. " fish  +  " .. #state.fish_released_this_round .. " returning"
		end,
		catch_value = function()
			return dollars(game.get_sum_of_fish_values(state.fish_caught_this_round))
		end,
		catches = function()
			return state.fish_caught_this_round
		end,
		items = function()
			return shop.categories[shop.tab].items or {}
		end,
		subtitle = function()
			return shop.categories[shop.tab].subtitle
		end,
		catch_tab = function()
			return shop.tab == 1
		end,
		item_tab = function()
			return shop.tab ~= 1
		end,
		empty_catch = function()
			return #state.fish_caught_this_round == 0
		end,
		has_catch = function()
			return #state.fish_caught_this_round > 0
		end,
		tab_id = function(c)
			return "tab" .. c.index
		end,
		tab_width = function(c)
			return percent(
				(c.parent.width - layout.tabs_gap * (#shop.categories - 1)) / #shop.categories,
				c.parent.width
			)
		end,
		tab_color = function(c)
			return shop.tab == c.index and colors.accent or colors.button
		end,
		tab_text_color = function(c)
			return shop.tab == c.index and colors.panel or colors.text
		end,
		catch_card_width = function(c)
			return percent(
				(c.parent.width - layout.catch_gap * (layout.catch_columns - 1)) / layout.catch_columns,
				c.parent.width
			)
		end,
		item_card_width = function(c)
			return percent((c.parent.width - layout.card_gap * (layout.columns - 1)) / layout.columns, c.parent.width)
		end,
		catch_gap_percent = function(c)
			return percent(layout.catch_gap, c.parent.width)
		end,
		card_gap_percent = function(c)
			return percent(layout.card_gap, c.parent.width)
		end,
		card_wrap_gap_percent = function(c)
			return percent(layout.card_gap, layout.body_height)
		end,
		empty_gap = function(c)
			return math.max(
				0,
				(c.parent.height - fonts.heading:getHeight() - fonts.body:getHeight() - layout.item_gap) / 2
			)
		end,
		fish_image = function()
			return fish_sprites.get_image()
		end,
		catch_quad = function(c)
			return fish_sprites.get_quad(c.item)
		end,
		item_quad = function(c)
			return fish_sprites.get_quad({ sprite_index = c.item.sprite })
		end,
		catch_stats = function(c)
			return string.format("%.2f kg / %.1f cm", c.item.weight, c.item.length)
		end,
		catch_price = function(c)
			return dollars(c.item.price)
		end,
		item_has_sprite = function(c)
			return c.item.sprite ~= nil
		end,
		item_title_width = function(c)
			return c.item.sprite
					and percent(c.parent.width - layout.item_sprite_size - layout.item_sprite_gap, c.parent.width)
				or 100
		end,
		owned_text = function(c)
			local count = owned(c)
			return count > 0 and (c.item.unique and "OWNED" or ("BOUGHT x" .. count)) or ""
		end,
		item_price = function(c)
			return c.item.planned and "Coming soon" or dollars(c.item.price)
		end,
		can_buy = can_buy,
		buy_text = function(c)
			if c.item.planned then
				return "Soon"
			end
			if c.item.unique and owned(c) > 0 then
				return "Owned"
			end
			return can_buy(c) and "Buy" or ("Need " .. dollars(c.item.price - state.money))
		end,
		buy_color = function(c)
			return can_buy(c) and colors.button or colors.disabled
		end,
		buy_text_color = function(c)
			return can_buy(c) and colors.text or colors.muted
		end,
		sell_color = function()
			return #state.fish_caught_this_round > 0 and colors.button or colors.disabled
		end,
		sell_text_color = function()
			return #state.fish_caught_this_round > 0 and colors.text or colors.muted
		end,
		next_text = function()
			return #state.fish_caught_this_round > 0 and "Sell & next round" or "Next round"
		end,
		actions = {
			select_tab = function(c)
				shop.select_tab(c.index)
			end,
			buy = function(c)
				shop.buy(c.item)
			end,
			sell_catch = function()
				shop.sell_catch()
			end,
			next_round = function()
				shop.next_round(shop.rng)
			end,
			noop = function() end,
		},
	}
	local view = UI.build(definitions, context, templates)
	return view.by_id.shop_root, view.by_id
end

return Menu
