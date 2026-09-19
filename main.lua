local game = require("src.game_functions")

if os.getenv("LOVE2D_TOOLS") then
	pcall(require, "_love2d_tools_bridge")
end
function love.load()
	RNG = love.math.newRandomGenerator() -- create  a global rng machine
	RNG:setSeed(1000) -- set the seed so runs can be reproduced in the future

	local sprite_sheet = love.graphics.newImage("assets/sprites/common_fish.png")
	fish_sprite_batch = love.graphics.newSpriteBatch(sprite_sheet)

	FISH_TEXTURES = {}

	for _, fish in pairs(FishTypes) do
		local x_pos = 0 + ((fish.sprite_index - 1) * 128)
		local y_pos = 0 -- update to use rarity to index for sprites when i get more textures
		local index = fish.sprite_index
		FISH_TEXTURES[index] = love.graphics.newQuad(x_pos, y_pos, 128, 128, sprite_sheet)
	end

	caught_fish = {}
end

function love.update(dt) end

function love.keypressed(key, scancode, isrepeat)
	if key == "space" then
		current_fish = game.catch_fish()
		caught_fish[#caught_fish + 1] = current_fish
	end
end

function love.draw()
	love.graphics.print("FishingGame", 24, 24)

	fish_sprite_batch:clear()

	for _, fish in pairs(caught_fish) do
		fish_sprite_batch:add(FISH_TEXTURES[fish.sprite_index], 5, 5)
	end

	love.graphics.draw(fish_sprite_batch, 0, 0)
end
