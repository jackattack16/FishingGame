local game = require("src.game_functions")
local game_state = require("src.globals.globals")
local UI = require("src.ui.json_ui")
local menu = require("src.ui.shop_menu")

local Shop = { tab = 1, message = "Sell your catch, then stock up for the next round." }

-- These are shop prototypes from gameplay_loop.md. Purchases record ownership
-- and spend money; their pond, processing, and finance effects are not wired yet.
Shop.categories = {
	{ name = "Catch", subtitle = "Sell raw to fish merchants, or prepare your catch for restaurant orders." },
	{
		name = "Fish",
		subtitle = "Restock the hatchery with new species and different ages.",
		items = {
			{
				id = "common_fry",
				name = "Common fry",
				description = "A starter group of young carp, sardines and herring.",
				price = 8,
				sprite = 1,
			},
			{
				id = "adult_carp",
				name = "Adult carp",
				description = "Mature stock ready for your next catching round.",
				price = 14,
				sprite = 1,
			},
			{
				id = "cod_fry",
				name = "Cod fry",
				description = "Introduce Atlantic cod to your pond.",
				price = 18,
				sprite = 5,
			},
			{
				id = "bluefish",
				name = "Young bluefish",
				description = "A premium species for more lucrative catches.",
				price = 24,
				sprite = 6,
			},
			{
				id = "tuna",
				name = "Young tuna",
				description = "Build up stock for future restaurant contracts.",
				price = 32,
				sprite = 7,
			},
			{
				id = "lanternfish",
				name = "Lanternfish",
				description = "A rare new arrival for your hatchery.",
				price = 45,
				sprite = 4,
			},
		},
	},
	{
		name = "Food",
		subtitle = "Feed your stock to encourage growth and breeding.",
		items = {
			{
				id = "pond_feed",
				name = "Pond feed",
				description = "Everyday food for all the fish in your pond.",
				price = 5,
			},
			{
				id = "growth_feed",
				name = "Growth feed",
				description = "Help young fish mature into more valuable catches.",
				price = 10,
			},
			{
				id = "carp_feed",
				name = "Carp breeding food",
				description = "Encourage your carp to breed between rounds.",
				price = 12,
			},
			{
				id = "cod_feed",
				name = "Cod breeding food",
				description = "Species-specific food for growing your cod stock.",
				price = 16,
			},
		},
	},
	{
		name = "Chemicals",
		subtitle = "Manage fish health, unwanted species and water conditions.",
		items = {
			{
				id = "medicine",
				name = "Pond medicine",
				description = "Treat unhealthy fish before your next harvest.",
				price = 12,
			},
			{
				id = "pesticide",
				name = "Selective pesticide",
				description = "Control unwanted fish. Related species may be affected.",
				price = 18,
			},
			{
				id = "ph_treatment",
				name = "pH treatment",
				description = "Adjust pond conditions to help manage algae.",
				price = 8,
			},
		},
	},
	{
		name = "Equipment",
		subtitle = "Invest in machines and better information about your pond.",
		items = {
			{
				id = "water_filter",
				name = "Water filter",
				description = "Cleaner water to reduce sickness in the hatchery.",
				price = 60,
				unique = true,
			},
			{
				id = "auto_breeder",
				name = "Automatic breeder",
				description = "Help replenish fish stock between catching rounds.",
				price = 95,
				unique = true,
			},
			{
				id = "pond_monitor",
				name = "Pond monitor",
				description = "See which species are in the pond and their health.",
				price = 45,
				unique = true,
			},
			{
				id = "fish_distractor",
				name = "Fish distractor",
				description = "Distract certain species while you are fishing.",
				price = 35,
				unique = true,
			},
			{
				id = "fountain",
				name = "Pond fountain",
				description = "Manage algae with a new fountain for your pond.",
				price = 50,
				unique = true,
			},
		},
	},
	{
		name = "Refining",
		subtitle = "Prepare fish for restaurant orders and more valuable sales.",
		items = {
			{
				id = "slicing_table",
				name = "Slicing table",
				description = "Prepare sliced fish for restaurant orders.",
				price = 70,
				unique = true,
			},
			{
				id = "cooking_station",
				name = "Cooking station",
				description = "Cook your catch for more lucrative buyers.",
				price = 120,
				unique = true,
			},
			{
				id = "inspection_station",
				name = "Inspection station",
				description = "Check fish for sickness before fulfilling an order.",
				price = 85,
				unique = true,
			},
		},
	},
	{
		name = "Finance",
		subtitle = "Loans, debt payments and investments will live here.",
		items = {
			{
				id = "short_loan",
				name = "Short-term loan",
				description = "Smaller loans with lower interest and higher payments.",
				planned = true,
			},
			{
				id = "long_loan",
				name = "Long-term loan",
				description = "Borrow more with a longer repayment period.",
				planned = true,
			},
			{
				id = "family_loan",
				name = "Family support",
				description = "Occasional help with lower interest and less pressure.",
				planned = true,
			},
			{
				id = "debt_payment",
				name = "Repay debt",
				description = "Pay interest or principal and improve your credit score.",
				planned = true,
			},
			{
				id = "investment",
				name = "Invest savings",
				description = "Set money aside for the future of your hatchery.",
				planned = true,
			},
		},
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
	Shop.tab = 1
	Shop.message = "Sell your catch, then stock up for the next round."
	invalidate()
end

function Shop.buy(item)
	if game_state.state ~= "shop" or item.planned then
		return false
	end
	local owned = game_state.shop_purchases[item.id] or 0
	if item.unique and owned > 0 then
		Shop.message = "You already own " .. item.name .. "."
		return false
	end
	if game_state.money < item.price then
		Shop.message = "You need " .. dollars(item.price - game_state.money) .. " more for " .. item.name .. "."
		return false
	end
	game_state.money = math.floor((game_state.money - item.price) * 100 + 0.5) / 100
	game_state.shop_purchases[item.id] = owned + 1
	Shop.message = "Purchased " .. item.name .. " for " .. dollars(item.price) .. "."
	invalidate()
	return true
end

function Shop.sell_catch()
	if game_state.state ~= "shop" or #game_state.fish_caught_this_round == 0 then
		return false
	end
	local value = game.get_sum_of_fish_values(game_state.fish_caught_this_round)
	game_state.money = math.floor((game_state.money + value) * 100 + 0.5) / 100
	game_state.fish_caught_this_round = {}
	Shop.message = "Sold your catch for " .. dollars(value) .. "."
	invalidate()
	return true
end

function Shop.next_round(rng)
	if game_state.state ~= "shop" then
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

function Shop.select_tab(index)
	Shop.tab = index
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
	local index = tonumber(key)
	if index and Shop.categories[index] then
		Shop.select_tab(index)
	elseif key == "return" or key == "kpenter" then
		if #game_state.fish_caught_this_round > 0 then
			Shop.sell_catch()
		else
			Shop.next_round(Shop.rng)
		end
	end
end

return Shop
