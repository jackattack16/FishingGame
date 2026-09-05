# Contributing to FishingGame

Thanks for helping improve FishingGame. Keep changes small, focused, and easy
to test.

## Development setup

1. Install [LÖVE](https://love2d.org/).
2. Clone the repository.
3. Open the project in VS Code and install the recommended extensions.
4. Run the game from the project folder with `love .`.

## Branches

Create a branch from the default branch for each change:

```text
feature/fishing-minigame
fix/inventory-overflow
balance/fish-values
docs/update-setup
```

## Commits

Use a short imperative subject with a simple type prefix:

```text
feat: add fishing minigame
fix: prevent duplicate fish rewards
balance: adjust common fish value
docs: update setup instructions
```

## Pull requests

- Keep each pull request focused on one feature, fix, or cleanup.
- Link the related GitHub issue when one exists.
- Explain what changed and how it was tested.
- Include screenshots or a short gameplay clip for visible changes.
- Mention known issues and follow-up work.
- Keep formatting-only changes separate from gameplay changes.

Every pull request must pass the StyLua formatting check before merging.

## Code style

Lua formatting is defined in `.stylua.toml` and runs automatically on save in
VS Code. Use the project formatter instead of manually applying a different
style.

## Definition of done

A change is ready to merge when:

- The game starts successfully with `love .`.
- The relevant behavior has been tested in-game.
- Lua files are formatted.
- Documentation is updated when setup or player-facing behavior changes.
- The pull request description is complete.
