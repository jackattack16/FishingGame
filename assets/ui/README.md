# JSON UI declarations

The fishing HUD is in `assets/ui/fishing_hud.json`. The shop layout and its
repeated card templates are in `assets/ui/shop.json`; its backdrop is in
`assets/ui/shop_backdrop.json`.

`src/ui/declaration.lua` reads JSON into ordinary Lua tables and fills defaults:

```lua
local definitions, templates = require("src.ui.declaration").load("assets/ui/shop.json")
```

`src/ui/json_ui.lua` walks those tables and creates the existing UI components:

```lua
local view = require("src.ui.json_ui").load("assets/ui/fishing_hud.json", {
  money = function() return game_state.money end,
  bait = function() return game_state.bait_left end,
})
local left_bar = view.by_id.left_bar
```

A document has a `window` array of root containers and an optional `templates`
object. Containers contain an `elements` array. Components have `type` set to
`container`, `textbox`, `button`, `image`, or `spacer`. An optional `id` registers
the built component in `view.by_id`; the roots are also in `view.containers`.

## Values and sizes

Ordinary values are static. `{ "bind": "name" }` looks up a value in the Lua
context; dotted names such as `colors.panel` and `item.name` access nested tables.
A named getter receives the current scope and returns a value. The scope includes
`parent`, plus `item` and `index` inside a repeated component.

Properties are resolved when the tree is built. Rebuild the tree when a property,
condition, or repeated collection changes. The shop already rebuilds on tab
changes, purchases, sales and window resizing.

Root position and dimensions use the original container rules: numeric pixels,
`"200px"`, `"50%"`, or `"full"`. Child widths/heights use numeric percentages,
percentage strings, pixel strings, or `"fit"` for buttons, textboxes and images.
For a pixel measurement from Lua, use:

```json
{ "height": { "bind": "layout.header_height", "unit": "px" } }
```

Root `x_padding`/`y_padding` and nested container `padding` are pixels.
Button/textbox `x_padding`/`y_padding` are percentages of the parent. Their
`padding` shorthand supplies both axes. `gap` and `wrap_gap` are percentages.
Colors are RGB(A) arrays with values from 0 to 1.

## Live text and actions

Textbox variables retain getters and update when rendered:

```json
{
  "type": "textbox",
  "text": "Money: $${money}$",
  "variables": { "money": { "bind": "money" } }
}
```

Literal variable values work too. Dynamic text substitution currently belongs to
textboxes; buttons use the text resolved when built. `"on_click": "buy"` selects
`context.actions.buy`, which receives the captured scope only when clicked:

```lua
actions = {
  buy = function(scope) shop.buy(scope.item) end,
}
```

JSON contains names, not executable Lua. `has_on_click: false` disables a button.
An omitted button action keeps the framework's existing placeholder callback.

## Templates, repetition and conditions

Declare a reusable node under `templates`. `{ "use": "item_card" }` expands it;
fields on the instance override the template. Templates do not inherit templates.
To build one instance per item in a context array:

```json
{ "use": "item_card", "repeat": "items" }
```

The `items` binding may be a table or a getter returning an array. Bindings and
actions in each instance receive that instance's `item` and `index`.
`"when": { "bind": "can_show" }` includes a component only when the value is
truthy at build time. IDs on repeated nodes must resolve to unique names.

Fonts can name an entry in `context.fonts` or use `"default"`. Image strings are
asset paths; images are cached per build. A binding can also supply a `love.Font`,
`love.Image` or `love.Quad` directly, as the shop does for fish sprites.

Shop values and callbacks are in `src/ui/shop_menu.lua`; colors, fonts and logical
pixel dimensions remain in `src/ui/shop_theme.lua`. Shop items and gameplay
behavior remain in `src/shop.lua`. Reload the game after editing JSON.

## Verification

Run the focused loader checks with PowerShell:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .tools/json_ui_smoke/run.ps1
```

The existing `.tools/shop_preview/run.ps1` also exercises all seven tabs, real
mouse/keyboard actions, affordability, ownership, selling and resizing.
