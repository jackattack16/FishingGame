function love.errorhandler(message)
	print(debug.traceback(message, 2))
	return function()
		return 1
	end
end

function love.load()
	local root = love.filesystem.getWorkingDirectory():gsub("\\", "/")
	package.path = root .. "/?.lua;" .. package.path
	local shop = require("src.shop")
	local state = require("src.globals.globals")
	local rng = love.math.newRandomGenerator(123)
	state.state, state.money = "shop", 20
	state.shop_purchases = {}
	state.pond = { { price = 4 } }
	state.fish_caught_this_round = { { price = 12.25 }, { price = 2.50 } }
	shop.open()
	assert(not shop.buy(shop.packs[1]) and state.money == 20, "Sell before shopping")
	local previous_round = state.round
	shop.next_round(rng)
	assert(state.round == previous_round and state.state == "shop", "Cannot skip the first phase")
	assert(shop.sell_catch() and state.money == 34.75 and shop.phase == "packs")
	assert(not shop.sell_catch() and state.money == 34.75, "Cannot sell twice")
	assert(shop.buy(shop.packs[1]) and state.money == 12.75 and state.shop_purchases.fish_pack == 1)
	assert(not shop.buy(shop.packs[2]) and state.money == 12.75, "Cannot overspend")
	assert(#state.pond == 1 and state.pond[1].price == 4, "Prototype purchases must not alter the pond")
	state.money = 100
	assert(shop.buy(shop.packs[2]) and state.money == 82)
	assert(shop.buy(shop.packs[3]) and state.money == 10)
	state.state = "catching"
	assert(not shop.buy(shop.packs[1]), "No shopping while catching")
	state.state = "shop"
	local released = { price = 7 }
	state.fish_released_this_round = { released }
	state.bait_left = 0
	shop.next_round(rng)
	assert(state.money == 10 and state.state == "catching" and state.bait_left == 5)
	assert(state.round == previous_round + 1 and #state.pond == 2)
	assert(state.shop_purchases.fish_pack == 1 and state.shop_purchases.machine_pack == 1)
	assert(#state.fish_released_this_round == 0)
	state.state = "shop"
	shop.open()
	assert(shop.phase == "sell", "Each shop starts with selling")
	assert(shop.sell_catch() and shop.phase == "packs" and state.money == 10, "Empty catches advance without payment")
	shop.next_round(rng)
	assert(state.money == 10 and state.round == previous_round + 2, "Next round must not pay twice")
	print("Shop phase guards, sales, pack purchases, affordability and round transitions verified")
	love.event.quit()
end
