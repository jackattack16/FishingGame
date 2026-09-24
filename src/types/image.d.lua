---@meta

---@class Image_Element: Element
---@field image love.Image The image or sprite sheet to draw.
---@field quad? love.Quad The selected sprite within the image.
---@field source_width number Width of the image or selected quad in pixels.
---@field source_height number Height of the image or selected quad in pixels.
---@field has_on_click false
local Image_Element = {}
