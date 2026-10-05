# FishingGame

A small fishing roguelite built with [LÖVE](https://love2d.org/) and Lua.

## Development

Install LÖVE, clone the repository, then run from the project folder:

```bash
love .
```

### Code style

Lua files use [StyLua](https://github.com/JohnnyMorganz/StyLua) with the shared
configuration in `.stylua.toml`. Install the recommended VS Code extension to
format automatically on save. GitHub Actions checks the same formatting rules
on every push and pull request. Other editors can use the same StyLua config.

## Early goals

After using the round's bait, the hatchery shop opens. Sell the catch, browse
with the mouse or keys 1-7, then choose **Next round**. Enter sells the catch
first and continues on the next press. Fish, food, chemicals, equipment and
refining purchases deduct cash and show ownership; their gameplay effects
are placeholders. Financing and restaurant orders are shown as coming soon.

The shop uses the components in `src/ui/`: nested containers lay out the
sections and cards, text boxes handle labels, and image elements draw fish.
Edit `src/ui/shop_theme.lua` for colors, font sizes or a custom font path,
padding, spacing, card dimensions and corner/border styling. The component
layout is in `assets/ui/shop.json`; Lua bindings are in `src/ui/shop_menu.lua`.
The fishing HUD is in `assets/ui/fishing_hud.json`. See `assets/ui/README.md`
for declaration syntax and loader examples. Items and buying behavior are in
`src/shop.lua`. Reload the game after theme edits.

Saving or releasing a fish pops it off the hook and flies it into its bottom-bar
slot. The shop opens after the last fish lands. Adjust the timing and motion in
`src/fish_transfer.lua`.

- Catch random fish
- Give fish different weights and values
- Keep fish in an inventory
- Sell fish for money
- Buy upgrades that change future catches

Keep the project simple while we learn Lua and LÖVE. Add systems only when the current prototype needs them.
