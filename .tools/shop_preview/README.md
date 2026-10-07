Run `powershell -ExecutionPolicy Bypass -File .tools/shop_preview/run.ps1`
from the project folder. The runner creates a temporary asset fixture because
LÖVE cannot mount the parent project directory from this test's source folder.
It exercises the actual game handlers, captures both shop phases and purchase
states into `output/`, checks nested container layout and clicks, wrapped text
and child bounds, small and large window sizes, sharp font/sprite sampling,
automatic selling-to-packs transitions, and empty catches. It exits automatically.

Use `run.ps1 -Scenario catch` to check the fish popping off the hook and flying
into each bottom-bar row, resizing during flight, repeated inputs, and the
last fish landing before the shop opens. It saves animation checkpoints in
`output/` and uses elapsed seconds to exercise different update intervals.

For the phase, money, purchase-count and round checks without a window, run
`powershell -ExecutionPolicy Bypass -File .tools/shop_smoke/run.ps1` from the
project folder.
