function love.load()
	local root = love.filesystem.getWorkingDirectory():gsub("\\", "/")
	package.path = root .. "/?.lua;" .. package.path
	for _, path in ipairs({ "main.lua", "src/render.lua", "src/shop.lua" }) do
		assert(loadfile(root .. "/" .. path))
	end
	local shop = require("src.shop")
	local state = require("src.globals.globals")
	local rng = love.math.newRandomGenerator(123)
	state.state = "shop"
	state.money = 20
	state.shop_purchases = {}
	state.pond = { { price = 4 } }
	local food = shop.categories[3].items[1]
	assert(shop.buy(food) and state.money == 15 and state.shop_purchases[food.id] == 1)
	assert(shop.buy(food) and state.money == 10 and state.shop_purchases[food.id] == 2)
	assert(#state.pond == 1 and state.pond[1].price == 4, "Prototype purchases must not alter fish")
	local equipment = shop.categories[5].items[1]
	assert(not shop.buy(equipment) and state.money == 10, "Cannot overspend")
	state.money = 100
	assert(shop.buy(equipment) and state.money == 40)
	assert(not shop.buy(equipment) and state.money == 40, "Cannot buy a unique item twice")
	assert(not shop.buy(shop.categories[7].items[1]) and state.money == 40)
	state.state = "catching"
	assert(not shop.buy(food) and state.money == 40, "No shopping during the catching phase")
	state.state = "shop"
	state.fish_caught_this_round = { { price = 12.25 }, { price = 2.50 } }
	assert(shop.sell_catch() and state.money == 54.75)
	assert(not shop.sell_catch() and state.money == 54.75, "Cannot sell twice")
	local released = { price = 7 }
	state.fish_released_this_round = { released }
	state.bait_left = 0
	local previous_round = state.round
	shop.next_round(rng)
	assert(state.money == 54.75 and state.state == "catching" and state.bait_left == 5)
	assert(state.round == previous_round + 1 and #state.pond == 2)
	assert(state.shop_purchases[food.id] == 2 and state.shop_purchases[equipment.id] == 1)
	assert(#state.fish_released_this_round == 0)
	state.state = "shop"
	state.fish_caught_this_round = { { price = 3.25 } }
	shop.next_round(rng)
	assert(state.money == 58, "Continue must sell remaining catch exactly once")
	print("Shop purchases, affordability, ownership, sales and round transitions verified")
	love.event.quit()
end
