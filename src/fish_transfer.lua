local fish_sprites = require("src.fish_sprites")
local Transfer = {}

-- Seconds, so the effect takes the same time at any frame rate.
local POP_TIME, FLIGHT_TIME, LAND_TIME = 0.16, 0.57, 0.12
local DURATION = POP_TIME + FLIGHT_TIME + LAND_TIME

local function lerp(a, b, t)
	return a + (b - a) * t
end

local function bezier(a, b, c, d, t)
	local u = 1 - t
	return u ^ 3 * a + 3 * u ^ 2 * t * b + 3 * u * t ^ 2 * c + t ^ 3 * d
end

function Transfer.start(fish, x, y, target)
	local width, height = love.graphics.getDimensions()
	Transfer.active = { fish = fish, x = x / width, y = y / height, target = target, elapsed = 0 }
end

-- Return true only on the frame the fish has finished landing.
function Transfer.update(dt)
	local active = Transfer.active
	if not active then
		return false
	end
	active.elapsed = active.elapsed + dt
	if active.elapsed >= DURATION then
		Transfer.active = nil
		return true
	end
	return false
end

function Transfer.get_pose()
	local active = Transfer.active
	if not active then
		return
	end
	local width, height = love.graphics.getDimensions()
	local x, y = active.x * width, active.y * height
	local target_x, target_y, size = active.target()
	local direction = target_x < x and -1 or 1
	local pop_x, pop_y = x + direction * 24, y - math.min(80, height * 0.12)
	local target_scale = size / 128
	if active.elapsed < POP_TIME then
		local t = active.elapsed / POP_TIME
		local ease = 1 - (1 - t) ^ 2
		return lerp(x, pop_x, ease), lerp(y, pop_y, ease), direction * 0.2 * ease, lerp(1, 1.12, ease)
	elseif active.elapsed < POP_TIME + FLIGHT_TIME then
		local t = (active.elapsed - POP_TIME) / FLIGHT_TIME
		local ease = t * t * (3 - 2 * t)
		return bezier(pop_x, pop_x + direction * 100, target_x, target_x, ease),
			bezier(pop_y, pop_y - 90, target_y - 140, target_y, ease),
			direction * (0.2 * (1 - ease) + 0.55 * math.sin(math.pi * ease)),
			lerp(1.12, target_scale, ease)
	end
	local t = (active.elapsed - POP_TIME - FLIGHT_TIME) / LAND_TIME
	return target_x, target_y, 0, target_scale * (1 + 0.12 * math.sin(math.pi * t))
end

function Transfer.draw()
	if Transfer.active then
		local x, y, rotation, scale = Transfer.get_pose()
		love.graphics.setColor(1, 1, 1, 1)
		fish_sprites.draw(Transfer.active.fish, x, y, rotation, scale, scale, 64, 64)
	end
end

return Transfer
