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

After using the round's bait, the hatchery shop opens in **Sell / Process**.
Selling pays for the catch and replaces that screen with **Fish pack**,
**Chemical pack** and **Machine pack** cards. An empty catch can continue
directly to packs. Buy with the mouse, then choose **Next round**; Enter sells
or continues in the first phase and starts the next round in the second.
Processing is coming soon. Pack purchases deduct cash and show purchase counts;
pack contents and their gameplay effects are placeholders.

The shop uses the components in `src/ui/`: nested containers lay out the
sections and cards, text boxes handle labels, and image elements draw fish.
Edit `assets/ui/shop.json` for layout, padding, card dimensions and corner
styling. Sizes are written directly, such as `"44px"` or `"32%"`; shared label,
button and card templates keep repeated styling together. Edit
`src/ui/shop_theme.lua` for the palette, fonts and overall shop size.
Lua bindings are in `src/ui/shop_menu.lua`.
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
