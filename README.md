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

- Catch random fish
- Give fish different weights and values
- Keep fish in an inventory
- Sell fish for money
- Buy upgrades that change future catches

Keep the project simple while we learn Lua and LÖVE. Add systems only when the current prototype needs them.
