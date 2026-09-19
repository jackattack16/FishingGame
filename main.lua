local game = require("src.game_functions")

if os.getenv("LOVE2D_TOOLS") then
	pcall(require, "_love2d_tools_bridge")
end
function love.load()
	love.window.setMode(700, 300, { x = 300, y = 100 })
	RNG = love.math.newRandomGenerator() -- create  a global rng machine
	RNG:setSeed(1000) -- set the seed so runs can be reproduced in the future
	CURRENT_POND = game.make_pond(50) -- to keep the seeded thing the same hopefully
	local sprite_sheet = love.graphics.newImage("assets/sprites/common_fish.png")
	fish_sprite_batch = love.graphics.newSpriteBatch(sprite_sheet)

	FISH_TEXTURES = {}

	for _, fish in pairs(FishTypes) do
		local x_pos = 0 + ((fish.sprite_index - 1) * 128)
		local y_pos = 0 -- update to use rarity to index for sprites when i get more textures
		local index = fish.sprite_index
		FISH_TEXTURES[index] = love.graphics.newQuad(x_pos, y_pos, 128, 128, sprite_sheet)
	end

	fish_caught_this_round = {}
	fish_released_this_round = {}
	current_fish = false
	bait_left = 10
end

function love.update(dt) end

function love.keypressed(key, scancode, isrepeat)
	if key == "space" then
		if not current_fish and #CURRENT_POND > 0 and bait_left > 0 then
			current_fish = game.catch_fish(CURRENT_POND)
			bait_left = bait_left - 1
			print("you caught a " .. current_fish.name)
			print("Do you wnat to keep it? (Y/n)")
		elseif #CURRENT_POND == 0 then
			print("You lost :(")
		elseif bait_left == 0 then
			print("Out of bait")
		end
	end

	if key == "y" then
		if current_fish then
			print("Fish caught!")
			fish_caught_this_round[#fish_caught_this_round + 1] = current_fish
		end
		current_fish = false
	end

	if key == "n" then
		if current_fish then
			print("Fish released!")
			fish_released_this_round[#fish_released_this_round + 1] = current_fish
		end
		current_fish = false
	end
end

function love.draw()
	love.graphics.print("Caught Fish", 5, 5)

	fish_sprite_batch:clear()
	local i = 0
	for _, fish in pairs(fish_caught_this_round) do
		fish_sprite_batch:add(FISH_TEXTURES[fish.sprite_index], 0 + (i * 128), 10)
		i = i + 1
	end
	love.graphics.draw(fish_sprite_batch, 0, 0)

	love.graphics.print("Released Fish", 5, 143)

	fish_sprite_batch:clear()
	local i = 0
	for _, fish in pairs(fish_released_this_round) do
		fish_sprite_batch:add(FISH_TEXTURES[fish.sprite_index], 0 + (i * 128), 148)
		i = i + 1
	end
	love.graphics.draw(fish_sprite_batch, 0, 0)

	love.graphics.print("Bait Left: " .. bait_left, 150, 5)
end
