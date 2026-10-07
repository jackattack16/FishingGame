local root = love.filesystem.getWorkingDirectory():gsub("\\", "/")
function love.errorhandler(message)
	print(debug.traceback(message, 2))
	return function()
		return 1
	end
end
package.path = root .. "/?.lua;" .. package.path
dofile(root .. "/main.lua")
local game_load, game_draw, game_update = love.load, love.draw, love.update
local shop = require("src.shop")
local state = require("src.globals.globals")
local stages, stage, pending, captured = {}, 1, true, false

local function click_control(id)
	shop.draw()
	local control = assert(shop.controls[id], "Missing control: " .. id)
	love.mousepressed(control.x + control.width / 2, control.y + control.height / 2, 1)
end

local function check_framework()
	local Container = require("src.ui.container")
	local parent = Container:new(20, 30, 260, 160, 10, 10, "row", "together", { wrap = true })
	local first = parent:add_element("container", { width = 50, height = 50, padding = 8 })
	local clicked = 0
	local button = first:add_element("button", {
		width = 100,
		height = 100,
		text = "Nested",
		on_click = function()
			clicked = clicked + 1
		end,
	})
	local second = parent:add_element("container", { width = 50, height = 50, padding = 8 })
	local third = parent:add_element("container", { width = 50, height = 50, padding = 8 })
	assert(second.x == first.x + first.width + 16, "Nested padding must count toward row width")
	assert(third.y == first.y + first.height + 16, "Wrapped rows must count nested padding")
	parent.x, parent.y = 100, 120
	parent:layout()
	assert(button.x == 118 and button.y == 138, "Moving the parent must relayout descendants")
	assert(parent:check_clicks(button.x + 2, button.y + 2) and clicked == 1)
	button.has_on_click = false
	assert(not parent:check_clicks(button.x + 2, button.y + 2) and clicked == 1)
	local font = love.graphics.newFont(18)
	local label = second:add_element("textbox", {
		width = 100,
		height = 100,
		text = "A long description wraps across several lines",
		text_align = "left",
		font = font,
	})
	label:render()
	assert(
		label.text:getFont() == font and label.text:getHeight() > font:getHeight(),
		"Descriptions must use the chosen font and wrap"
	)
	print("Nested layout, padding, wrapping, recursive clicks and styled text verified")
end

function love.load()
	local maximize = love.window.maximize
	love.window.maximize = function() end
	game_load()
	love.window.maximize = maximize
	local default_font = love.graphics.getFont()
	assert(default_font:getFilter() == "nearest", "The game's font must not be blurred by texture filtering")
	assert(require("src.fish_sprites").get_image():getFilter() == "nearest", "Fish sprites must use sharp sampling")
	assert(
		left_bar.elements[1].text:getFont() == default_font and bottom_bar.elements[1].text:getFont() == default_font,
		"Fishing UI must inherit the game's default font"
	)
	check_framework()
	state.money = 250
	stages = {
		{ "fishing-screen", function() end },
		{
			"caught-fish-screen",
			function()
				my_fishing_line.caught_fish = state.pond[1]
				my_fishing_line.bobber_y = love.graphics.getHeight() / 2
			end,
		},
		{
			"catch",
			function()
				-- Enter the menu through the actual final-catch key handler.
				my_fishing_line.caught_fish = false
				my_fishing_line.bobber_y = 1000
				for _ = 1, 5 do
					state.current_fish = table.remove(state.pond, 1)
					state.state = "fish_caught"
					my_fishing_line.state = "fish_caught"
					love.keypressed("y")
					game_update(1)
				end
				assert(state.state == "shop" and #state.fish_caught_this_round == 5)
			end,
		},
		{
			"shop-packs",
			function()
				local value = require("src.game_functions").get_sum_of_fish_values(state.fish_caught_this_round)
				click_control("sell_catch")
				assert(
					shop.phase == "packs"
						and #state.fish_caught_this_round == 0
						and math.abs(state.money - 250 - value) < 0.001
				)
				shop.draw()
				assert(not shop.controls.sell_body and shop.controls.pack_body, "Selling must replace the first phase")
			end,
		},
		{
			"shop-packs-bought",
			function()
				local money = state.money
				click_control("fish_pack")
				click_control("chemical_pack")
				click_control("machine_pack")
				assert(math.abs(state.money - money + 112) < 0.001)
				assert(
					state.shop_purchases.fish_pack == 1
						and state.shop_purchases.chemical_pack == 1
						and state.shop_purchases.machine_pack == 1
				)
			end,
		},
		{
			"shop-large-window",
			function()
				love.window.setMode(1920, 1080, { resizable = true })
				love.resize()
			end,
		},
		{
			"shop-small-window",
			function()
				love.window.setMode(800, 600, { resizable = true })
				love.resize()
				local money = state.money
				click_control("fish_pack")
				assert(
					math.abs(state.money - money + 22) < 0.001 and state.shop_purchases.fish_pack == 2,
					"Resized clicks must still work"
				)
			end,
		},
		{
			"shop-insufficient-funds",
			function()
				state.money = 0
				shop.resize()
				click_control("fish_pack")
				assert(state.money == 0 and state.shop_purchases.fish_pack == 2, "Cannot overspend")
			end,
		},
		{
			"shop-empty-catch",
			function()
				shop.open()
				assert(shop.phase == "sell")
			end,
		},
		{
			"shop-empty-packs",
			function()
				love.keypressed("return")
				assert(shop.phase == "packs" and state.money == 0, "An empty catch must continue without payment")
			end,
		},
	}
end

function love.update()
	if pending then
		pending, captured = false, false
		if stage > #stages then
			love.keypressed("return")
			assert(state.state == "catching" and state.round == 2 and state.bait_left == 5)
			assert(state.shop_purchases.fish_pack == 2 and state.shop_purchases.machine_pack == 1)
			print(
				"Both shop phases rendered; real purchases, automatic sale transition, resize, empty catch and next round verified"
			)
			love.event.quit()
			return
		end
		stages[stage][2]()
	end
end

local function check_bounds(container)
	local left, top = container.x + container.x_padding, container.y + container.y_padding
	for _, child in ipairs(container.elements) do
		local width = child.width + (child.is_container and child.x_padding * 2 or 0)
		local height = child.height + (child.is_container and child.y_padding * 2 or 0)
		assert(child.x >= left - 0.01 and child.y >= top - 0.01, "Child extends before its container")
		assert(child.x + width <= left + container.width + 0.01, "Child exceeds container width")
		assert(child.y + height <= top + container.height + 0.01, "Child exceeds container height")
		if child.is_container then
			check_bounds(child)
		elseif child.text then
			assert(child.text:getHeight() <= child.height + 1, "Text overflows: " .. child.text_string)
		end
	end
end

function love.draw()
	game_draw()
	if state.state == "shop" then
		check_bounds(shop.ui)
	end
	if stage <= #stages and not captured then
		captured = true
		local name = stages[stage][1]
		love.graphics.captureScreenshot(function(data)
			local file = assert(io.open(root .. "/.tools/shop_preview/output/" .. name .. ".png", "wb"))
			file:write(data:encode("png"):getString())
			file:close()
			stage, pending = stage + 1, true
		end)
	end
end
