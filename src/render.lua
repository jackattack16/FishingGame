local game_state = require("src.globals.globals")
local fish_sprites = require("src.fish_sprites")
local shop = require("src.shop")
local fish_transfer = require("src.fish_transfer")
local R = {}
local fish_sprite_batch
local algae_canvas
local second_algae_canvas
function R.load()
	fish_sprite_batch = love.graphics.newSpriteBatch(fish_sprites.get_image())
	R.resize()
end

function R.resize()
	local width, height = love.graphics.getDimensions()
	algae_canvas = love.graphics.newCanvas()
	second_algae_canvas = love.graphics.newCanvas()

	love.graphics.push("all")
	love.graphics.setCanvas(algae_canvas)
	love.graphics.clear(0, 0, 0, 0)
	love.graphics.setColor({ 0.043, 0.251, 0.129 })
	love.graphics.setLineWidth(10)
	love.graphics.line(width * 0.2, height, width * 0.2, height * 0.75)
	love.graphics.line(width * 0.4, height, width * 0.4, height * 0.5)
	love.graphics.line(width * 0.7, height, width * 0.7, height * 0.8)
	love.graphics.line(width * 0.9, height, width * 0.9, height * 0.6)
	love.graphics.pop()
end

local function make_fish_batch(fish_table, x_start, y_start, sprite_width)
	local i = 0
	for _, fish in pairs(fish_table) do
		fish_sprite_batch:add(fish_sprites.get_quad(fish), x_start + (i * sprite_width), y_start)
		i = i + 1
	end
end

function R.draw_catching()
	-- Draw the fish that the player has caught
	love.graphics.print("Caught Fish: " .. #game_state.fish_caught_this_round .. " / 5", 5, 5)
	fish_sprite_batch:clear()
	make_fish_batch(game_state.fish_caught_this_round, 0, 10, 128)
	love.graphics.draw(fish_sprite_batch, 0, 0)

	-- Draw the fish the player releases
	love.graphics.print("Released Fish", 5, 143)

	fish_sprite_batch:clear()
	make_fish_batch(game_state.fish_released_this_round, 0, 138, 128)
	love.graphics.draw(fish_sprite_batch, 0, 0)

	-- Draw the amount of bait left and the curent status_text
	love.graphics.print("Bait Left: " .. game_state.bait_left, 150, 5)
	love.graphics.print(game_state.status_text, 5, 256)
end

function R.draw_shop()
	shop.draw()
end

local function bottom_fish_row_geometry(row_number)
	local button = bottom_bar.elements[1]
	local font = love.graphics.getFont()
	local row_height = bottom_bar.height / 2
	local row_y = bottom_bar.y + bottom_bar.y_padding + (row_number - 1) * row_height
	local label_x = button.x + button.width + 16
	local fish_x = label_x + math.max(font:getWidth("Released:"), font:getWidth("Caught:")) + 12
	local right_edge = bottom_bar.x + bottom_bar.x_padding + bottom_bar.width
	local sprite_size = math.max(0, math.min(row_height - 4, (right_edge - fish_x) / 5))
	return label_x, row_y, row_height, fish_x, sprite_size
end

-- Both the row and the flight use this slot, including after a window resize.
function R.get_bottom_fish_slot(row_number, index)
	local _, row_y, row_height, fish_x, size = bottom_fish_row_geometry(row_number)
	return fish_x + (index - 0.5) * size, row_y + row_height / 2, size
end

local function draw_bottom_fish_row(fish_list, label, row_number)
	local label_x, row_y, row_height = bottom_fish_row_geometry(row_number)
	local font = love.graphics.getFont()

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print(label, math.floor(label_x + 0.5), math.floor(row_y + (row_height - font:getHeight()) / 2 + 0.5))
	for index, fish in ipairs(fish_list) do
		if not fish_transfer.active or fish_transfer.active.fish ~= fish then
			local x, y, size = R.get_bottom_fish_slot(row_number, index)
			fish_sprites.draw(fish, x, y, 0, size / 128, size / 128, 64, 64)
		end
	end
end

function R.render_game()
	local width, height = love.graphics.getDimensions()

	love.graphics.setColor({ 1, 1, 1, 1 })
	love.graphics.setShader(water_shader)
	love.graphics.rectangle("fill", 0, 0, width, height)
	love.graphics.setShader()

	love.graphics.setColor({ 0.063, 0.208, 0.478, 0.25 })
	love.graphics.rectangle("fill", 0, 0, width, height)
	love.graphics.draw(particle_system, -15, 0)
	love.graphics.draw(bubble_system, width / 2, height + 10)

	love.graphics.setCanvas(second_algae_canvas)
	love.graphics.clear(0, 0, 0, 0)
	love.graphics.setColor({ 1, 1, 1, 1 })
	love.graphics.setShader(distort_shader)
	love.graphics.draw(algae_canvas, 0, 0)
	love.graphics.setShader()
	love.graphics.setCanvas()

	love.graphics.setShader(pixelate_shader)
	love.graphics.draw(second_algae_canvas, 0, 0)
	love.graphics.setShader()
	-- if game_state.state == "shop" then
	-- 	R.draw_shop() -- disabled for terminal testing
	-- 	return
	-- end
	left_bar:render()
	bottom_bar:render()
	draw_bottom_fish_row(game_state.fish_caught_this_round, "Caught:", 1)
	draw_bottom_fish_row(game_state.fish_released_this_round, "Released:", 2)
	my_fishing_line:render()
	fish_transfer.draw()
end

return R
