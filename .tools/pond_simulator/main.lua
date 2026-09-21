-- Run from the repository root:
-- & 'C:\Program Files\LOVE\lovec.exe' .\.tools\pond_simulator 1000 pond_simulation.csv
-- Arguments: number of runs, output CSV path, optional random seed.

local function positive_integer(value, label)
	local number = tonumber(value)
	assert(number and number > 0 and number == math.floor(number), label .. " must be a positive integer")
	return number
end

local function csv_field(value)
	local string_value = tostring(value)
	return '"' .. string_value:gsub('"', '""') .. '"'
end

local function write_row(file, values)
	local fields = {}
	for index = 1, 20 do
		fields[index] = csv_field(values[index] or "")
	end
	assert(file:write(table.concat(fields, ","), "\n"))
end

function love.load(args)
	local runs = positive_integer(args[1] or "1000", "Runs")
	local output_path = args[2] or "pond_simulation.csv"
	local seed = args[3] and positive_integer(args[3], "Seed") or os.time()

	-- The separate LÖVE project has no copy of src/. Load the actual game modules.
	local root = love.filesystem.getWorkingDirectory():gsub("\\", "/")
	package.path = root .. "/?.lua;" .. package.path
	local game = require("src.game_functions")

	local rng = love.math.newRandomGenerator(seed)

	local file, open_error = io.open(output_path, "w")
	assert(file, "Could not open CSV: " .. tostring(open_error))
	assert(file:write(
		"record_type,run,pond_position,caught_order,species,rarity,length_cm,girth_cm,weight_kg,price,"
			.. "pond_total_value,caught_total_value,rarity_1_count,rarity_2_count,rarity_3_count,rarity_4_count,"
			.. "pond_value_min,pond_value_average,pond_value_max,seed\n"
	))

	local pond_value_min = math.huge
	local pond_value_max = -math.huge
	local pond_value_sum = 0

	for run = 1, runs do
		local pond = game.make_pond(50, rng)
		local original_pond = { unpack(pond) }
		local caught_order = {}
		local pond_total_value = 0
		for _, fish in ipairs(original_pond) do
			pond_total_value = pond_total_value + fish.price
		end
		pond_value_min = math.min(pond_value_min, pond_total_value)
		pond_value_max = math.max(pond_value_max, pond_total_value)
		pond_value_sum = pond_value_sum + pond_total_value

		local bait_left = 5
		local caught_total_value = 0

		for draw = 1, 5 do
			local fish
			fish, bait_left = game.catch_fish(pond, bait_left)
			caught_order[fish] = draw
			caught_total_value = caught_total_value + fish.price
		end

		for position, fish in ipairs(original_pond) do
			write_row(file, {
				"fish",
				run,
				position,
				caught_order[fish] or "",
				fish.name,
				fish.rarity,
				fish.length,
				string.format("%.10g", fish.girth),
				string.format("%.10g", fish.weight),
				string.format("%.2f", fish.price),
			})
		end

		write_row(file, {
			"pond_summary",
			run,
			[11] = string.format("%.2f", pond_total_value),
			[12] = string.format("%.2f", caught_total_value),
			[13] = game.count_rarity(original_pond, 1),
			[14] = game.count_rarity(original_pond, 2),
			[15] = game.count_rarity(original_pond, 3),
			[16] = game.count_rarity(original_pond, 4),
		})
	end

	write_row(file, {
		"simulation_summary",
		[17] = string.format("%.2f", pond_value_min),
		[18] = string.format("%.2f", pond_value_sum / runs),
		[19] = string.format("%.2f", pond_value_max),
		[20] = seed,
	})
	assert(file:close())
	print(string.format(
		"Wrote %d ponds and %d fish to %s (seed %d); pond total value min/avg/max: %.2f / %.2f / %.2f",
		runs,
		runs * 50,
		output_path,
		seed,
		pond_value_min,
		pond_value_sum / runs,
		pond_value_max
	))
	love.event.quit()
end
