local ANIMATION = require("src.animation")
local FISHSPRITES = require("src.fish_sprites")

local Fishing_Line = {
	state = "idle",
	bobber_x = 0,
	bobber_y = 0,
	top_x = 0,
	top_y = 0,
	caught_fish = false,
}

Fishing_Line.__index = Fishing_Line

function Fishing_Line:start_catching_animation(fish_id)
	if self.state == "idle" then
		self.state = "catching_fish"
		self.caught_fish = fish_id
	end
end

function Fishing_Line:start_reset_animation()
	if self.state == "fish_caught" then
		self.state = "resetting"
	end
end

function Fishing_Line:animate(dt)
	if
		self.state == "catching_fish"
		and self.catching_animation.current_frame < self.catching_animation.total_frames
	then
		self.bobber_y = self.catching_animation:evaluate()
	else
		if
			self.state == "catching_fish"
			and self.catching_animation.current_frame >= self.catching_animation.total_frames
		then
			self.state = "fish_caught"
			self.catching_animation:reset()
		end
	end

	if self.state == "resetting" and self.release_animation.current_frame < self.release_animation.total_frames then
		self.bobber_y = self.release_animation:evaluate()
	else
		if
			self.state == "resetting"
			and self.release_animation.current_frame >= self.release_animation.total_frames
		then
			self.state = "idle"
			self.caught_fish = false
			self.release_animation:reset()
		end
	end
end

function Fishing_Line:render()
	love.graphics.setColor({ 0.62, 0.65, 0.68 })
	love.graphics.line(self.top_x, self.top_y, self.bobber_x, self.bobber_y)
	love.graphics.setColor({ 1, 1, 1 })
	if self.caught_fish then
		FISHSPRITES.draw(self.caught_fish, self.bobber_x, self.bobber_y, 0, 1, 1, 64, 64)
	end
end

function Fishing_Line:new(x_position)
	local new_line = {
		state = "idle",
		bobber_x = x_position,
		bobber_y = 1000,
		top_x = x_position,
		top_y = 0,
		catching_animation = ANIMATION:new(0.17, 0.67, 0.6, 1.7, 1000, 500, 90, { cx3 = 0.63, cy3 = 0.93 }),
		release_animation = ANIMATION:new(0.37, -0.52, 0.62, 0.56, 500, 1000, 60),
	}
	setmetatable(new_line, Fishing_Line)
	return new_line
end

return Fishing_Line
