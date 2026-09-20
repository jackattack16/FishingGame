# Pond simulator

From the repository root in PowerShell, run:

```powershell
& 'C:\Program Files\LOVE\lovec.exe' .\tools\pond_simulator 1000 pond_simulation.csv
```

Arguments are the number of ponds, output CSV path, and optional random seed. The defaults are `1000`, `pond_simulation.csv`, and the current time. Each run creates a fresh 50-fish pond and catches the first five fish using the game's own functions. The seed is saved in the final CSV row, so passing it as the third argument reproduces that run. The output file is overwritten on each run.

The CSV has three `record_type` values:

- `fish`: one row for every generated fish; `caught_order` is 1–5 for caught fish and blank otherwise. `price` is calculated by the game's `Fish:new` function.
- `pond_summary`: one row per run with the value of all 50 fish, the value of the five caught fish, and counts for each rarity.
- `simulation_summary`: one final row with the minimum, average, and maximum of `pond_total_value` across all runs, plus the seed.

All values use the game's price units. Delete this directory to remove the simulator. The separate change to the game's seed is in `main.lua`.
