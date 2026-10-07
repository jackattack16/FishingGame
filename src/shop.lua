local game = require("src.game_functions")
local game_state = require("src.globals.globals")
local UI = require("src.ui.json_ui")
local menu = require("src.ui.shop_menu")

local Shop = { phase = "sell", message = "Sell your catch before visiting the pack shop." }

-- Purchases spend money and record a count. Pack contents come later.
Shop.packs = {
	{
		id = "fish_pack",
		name = "Fish pack",
		tag = "POND STOCK",
		price = 15,
		description = "New species and a chance at rarer fish for your pond.",
	},
	{
		id = "chemical_pack",
		name = "Chemical pack",
		tag = "POND CARE",
		price = 18,
		description = "Medicine, water treatments and selective fish removal.",
	},
	{
		id = "machine_pack",
		name = "Machine pack",
		tag = "EQUIPMENT",
		price = 72,
		description = "Machines to support your pond and future catches.",
	},
}

local theme = require("src.ui.shop_theme")
Shop.theme = theme
local fonts, backdrop, font_scale = {}, nil, nil

local function dollars(value)
	return string.format("$%.2f", value)
end

local function invalidate()
	Shop.ui, Shop.controls = nil, nil
end

function Shop.open()
	Shop.phase = "sell"
	Shop.message = #game_state.fish_caught_this_round > 0 and "Sell your catch before visiting the pack shop."
		or "No catch this round. Continue to the pack shop."
	invalidate()
end

function Shop.buy(item)
	if game_state.state ~= "shop" or Shop.phase ~= "packs" then
		return false
	end
	local owned = game_state.shop_purchases[item.id] or 0
	if game_state.money < item.price then
		Shop.message = "You need " .. dollars(item.price - game_state.money) .. " more for " .. item.name .. "."
		invalidate()
		return false
	end
	game_state.money = math.floor((game_state.money - item.price) * 100 + 0.5) / 100
	
	game_state.shop_purchases[item.id] = owned + 1
	Shop.message = "Purchased " .. item.name .. " for " .. dollars(item.price) .. "."
	invalidate()
	return true
end

function Shop.sell_catch()
	if game_state.state ~= "shop" or Shop.phase ~= "sell" then
		return false
	end
	local value = game.get_sum_of_fish_values(game_state.fish_caught_this_round)
	game_state.money = math.floor((game_state.money + value) * 100 + 0.5) / 100
	game_state.fish_caught_this_round = {}
	Shop.phase = "packs"
	Shop.message = value > 0 and ("Sold your catch for " .. dollars(value) .. ".")
		or "Choose packs for your next round."
	invalidate()
	return true
end

function Shop.next_round(rng)
	if game_state.state ~= "shop" or Shop.phase ~= "packs" then
		return
	end
	game.end_round(rng)
	invalidate()
end

function Shop.load()
	fonts, font_scale = {}, nil
	backdrop = UI.load("assets/ui/shop_backdrop.json", { colors = theme.colors }).by_id.backdrop
	invalidate()
end

function Shop.resize()
	invalidate()
	if backdrop then
		backdrop:layout()
	end
end

local function ensure_ui()
	if not Shop.ui then
		local viewport = Shop.get_viewport()
		if font_scale ~= viewport.scale then
			for _, role in ipairs({ "title", "heading", "body", "small" }) do
				local size = math.max(1, math.floor(theme.fonts[role] * viewport.scale + 0.5))
				fonts[role] = theme.fonts.path and love.graphics.newFont(theme.fonts.path, size)
					or love.graphics.newFont(size)
				fonts[role]:setFilter("nearest", "nearest")
			end
			font_scale = viewport.scale
		end
		Shop.ui, Shop.controls = menu.build(Shop, fonts, viewport)
	end
end

function Shop.get_viewport()
	local width, height = love.graphics.getDimensions()
	local layout = theme.layout
	local scale = math.max(
		0.01,
		math.min((width - layout.window_margin) / layout.width, (height - layout.window_margin) / layout.height)
	)
	return {
		x = math.floor((width - layout.width * scale) / 2 + 0.5),
		y = math.floor((height - layout.height * scale) / 2 + 0.5),
		scale = scale,
	}
end

function Shop.draw()
	ensure_ui()
	love.graphics.push("all")
	love.graphics.setShader()
	backdrop:render()
	Shop.ui:render()
	love.graphics.pop()
end

function Shop.mousepressed(x, y, mouse_button)
	if game_state.state ~= "shop" or mouse_button ~= 1 then
		return
	end
	ensure_ui()
	Shop.ui:check_clicks(x, y)
end

function Shop.keypressed(key)
	if game_state.state ~= "shop" then
		return
	end
	if key == "return" or key == "kpenter" then
		if Shop.phase == "sell" then
			Shop.sell_catch()
		else
			Shop.next_round(Shop.rng)
		end
	end
end

return Shop
