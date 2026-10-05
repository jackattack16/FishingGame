Run `powershell -ExecutionPolicy Bypass -File .tools/shop_preview/run.ps1`
from the project folder. The runner creates a temporary asset fixture because
LÖVE cannot mount the parent project directory from this test's source folder.
It exercises the actual game handlers, captures every shop tab and purchase
state into `output/`, checks nested container layout and clicks, wrapped text,
small and large window sizes, sharp font/sprite sampling and a theme-only
restyle, and exits automatically. Its temporary
theme changes do not modify `src/ui/shop_theme.lua`.

Use `run.ps1 -Scenario catch` to check the fish popping off the hook and flying
into each bottom-bar row, resizing during flight, repeated inputs, and the
last fish landing before the shop opens. It saves animation checkpoints in
`output/` and uses elapsed seconds to exercise different update intervals.

For the money/ownership and round checks without a window, run
`"C:/Program Files/LOVE/lovec.exe" .tools/shop_smoke` from the project folder.
