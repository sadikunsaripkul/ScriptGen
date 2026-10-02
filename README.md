# ScriptGen

Skrip Roblox oleh NM-HUB.

## NM-HUB v2 — Steal An Egg (single file)
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/sadikunsaripkul/ScriptGen/main/scripts/nm-hub.lua"))()
```
Satu fail tunggal (tiada muat turun tambahan; VoidUI dibundel). UI: VoidUI dengan fallback Drawing (kekunci G). API penuh di `getgenv().NMHUB` — contohnya `getgenv().NMHUB.SetStandbyFromPlayer()` sebelum mula auto farm.

Enjin auto steal dipadankan dengan struktur game sebenar: `AreaEggSlotsClient`, remote `RF/EggWorld/AskFieldEggCarry` (Uid = nama model), zon pengawal, kitaran siang/malam, pengelakan treadmill/perangkap, pergerakan tween + fallback berjalan.

Atribusi: base repo terbuka [monthonsova/Steal-An-Egg](https://github.com/monthonsova/Steal-An-Egg) (EggESP), dijenamakan semula sebagai NM-HUB.
