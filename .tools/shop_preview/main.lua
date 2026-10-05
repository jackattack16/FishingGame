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
			"fish",
			function()
				click_control("tab2")
				assert(shop.tab == 2, "Nested tab buttons must switch categories")
				shop.draw()
				assert(
					shop.controls.common_fry.y == shop.controls.adult_carp.y
						and shop.controls.adult_carp.y == shop.controls.cod_fry.y,
					"Three percentage-sized cards must fit on the first row"
				)
				assert(
					shop.controls.tuna.y == shop.controls.lanternfish.y
						and shop.controls.tuna.y > shop.controls.cod_fry.y
				)
			end,
		},
		{
			"food-bought",
			function()
				love.keypressed("3")
				click_control("pond_feed")
				click_control("pond_feed")
				assert(state.money == 240 and state.shop_purchases.pond_feed == 2)
			end,
		},
		{
			"chemicals",
			function()
				love.keypressed("4")
			end,
		},
		{
			"equipment-owned",
			function()
				love.keypressed("5")
				click_control("water_filter")
				assert(state.money == 180 and state.shop_purchases.water_filter == 1)
			end,
		},
		{
			"refining",
			function()
				love.keypressed("6")
			end,
		},
		{
			"finance",
			function()
				love.keypressed("7")
			end,
		},
		{
			"empty-catch",
			function()
				love.keypressed("1")
				love.keypressed("return")
				assert(#state.fish_caught_this_round == 0)
			end,
		},
		{
			"large-window",
			function()
				love.window.setMode(1920, 1080, { resizable = true })
				love.resize()
				love.keypressed("2")
				shop.draw()
				assert(shop.controls.common_fry.y == shop.controls.cod_fry.y, "Cards must still fit at large sizes")
			end,
		},
		{
			"small-window",
			function()
				love.window.setMode(800, 600, { resizable = true })
				love.resize()
				love.keypressed("5")
				local money = state.money
				click_control("pond_monitor")
				assert(
					state.money == money - 45 and state.shop_purchases.pond_monitor == 1,
					"Click coordinates must remain correct after resizing"
				)
			end,
		},
		{
			"insufficient-funds",
			function()
				state.money = 0
				love.keypressed("2")
				click_control("common_fry")
				assert(state.money == 0 and not state.shop_purchases.common_fry)
			end,
		},
		{
			"theme-preview",
			function()
				shop.theme.colors.panel = { 0.13, 0.08, 0.11, 1 }
				shop.theme.colors.card = { 0.22, 0.14, 0.16, 1 }
				shop.theme.colors.accent = { 0.97, 0.72, 0.36, 1 }
				shop.theme.colors.button = { 0.40, 0.23, 0.22, 1 }
				shop.theme.fonts.body, shop.theme.fonts.heading = 18, 22
				shop.theme.layout.radius, shop.theme.layout.button_border = 14, 1
				shop.load()
				love.keypressed("3")
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
			assert(state.shop_purchases.pond_feed == 2 and state.shop_purchases.water_filter == 1)
			print("All seven tabs rendered; real keyboard/mouse purchases, sale, resize and continue verified")
			love.event.quit()
			return
		end
		stages[stage][2]()
	end
end

function love.draw()
	game_draw()
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
