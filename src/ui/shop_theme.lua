-- Shared palette, fonts and overall shop size. Individual sizes are in shop.json.
-- Dimensions adapt to the window, and fonts are rendered at their final pixel size.
return {
	colors = {
		backdrop = { 0.015, 0.035, 0.05, 0.86 },
		panel = { 0.035, 0.09, 0.13, 0.98 },
		card = { 0.065, 0.15, 0.19, 1 },
		text = { 0.91, 0.96, 0.94, 1 },
		muted = { 0.56, 0.72, 0.73, 1 },
		accent = { 0.48, 0.86, 0.67, 1 },
		button = { 0.16, 0.34, 0.34, 1 },
		disabled = { 0.10, 0.20, 0.23, 1 },
		transparent = { 0, 0, 0, 0 },
	},
	fonts = {
		path = "assets/fonts/Libron-Regular.ttf",
		default = 12, -- Default font size for the fishing screen and other game UI.
		title = 30,
		heading = 20,
		body = 16,
		small = 14,
	},
	layout = { width = 1000, height = 580, window_margin = 24 },
}
