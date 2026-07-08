# RV_HuD

A modern, configurable FiveM HUD resource for ESX servers. RV_HuD includes a full player HUD, vehicle HUD, multiple speedometer styles, in-game HUD settings, media playlists, nitro, seatbelt, cruise control, safezone notifications, stress support, and quick waypoint shortcuts.

## Features

- Player status HUD for health, armor, hunger, thirst, stress, stamina, oxygen, and altitude.
- Money and identity widgets for cash, bank, black money, boss money, VIP coin, job, second job/gang, player ID, and player name.
- Multiple vehicle speedometers including default, super, old school, sport, drift, bicycle, boat, and helicopter layouts.
- Vehicle controls for doors, windows, hood, trunk, seats, neons, indicators, hazard lights, engine toggle, cruise control, seatbelt, fuel, RPM, nitro, and vehicle modes.
- In-game HUD settings menu with draggable/freeform layout editing, streamer mode, cinematic mode, color customization, display modes, and persistent player preferences.
- Media player with playlists, song management, likes, volume control, play/pause, and synchronized playback through `xsound`.
- Safezone notification system with configurable coordinates.
- Optional stress HUD support with configurable stress gain/relief actions.
- Optional gift timer rewards.
- Voice HUD support for `pma-voice`, `mumble-voip`, and `saltychat`.
- Configurable quick waypoint shortcuts for banks, gas stations, shops, clothing shops, barber shops, and tattoo shops.

## Requirements

- FiveM server artifact with `cerulean` support.
- ESX framework.
- `oxmysql` by default.
- `xsound` for the media player.
- A supported voice resource:
  - `pma-voice`
  - `mumble-voip`
  - `saltychat`
- Optional integrations used by the default config:
  - `esx_society` for boss money.
  - `Coin-System` for VIP coin money.
  - `Hz_Notification` for notifications.
  - `Hz_Fuel` for fuel integration.

## Installation

1. Download or clone this resource into your server `resources` folder.
2. Make sure the folder name matches the resource name you want to start, for example:

   ```cfg
   ensure RV_HuD
   ```

3. Import `user.sql` into your database.
4. Start required dependencies before this resource:

   ```cfg
   ensure oxmysql
   ensure xsound
   ensure pma-voice
   ensure RV_HuD
   ```

5. Check `fxmanifest.lua` and confirm the database library matches your server:

   ```lua
   '@oxmysql/lib/MySQL.lua'
   ```

   If you use `mysql-async`, comment out `oxmysql` and uncomment the `mysql-async` line.

6. Configure the resource in `shared/config.lua` and `shared/stress_config.lua`.

## Database

Import `user.sql` to create the required tables:

- `hud_playlists` stores media playlists.
- `hud_playlist_songs` stores songs attached to playlists.
- `hud_stress` stores player stress values if you enable or restore the included stress server logic.

> Note: `user.sql` currently contains example playlist/stress rows from a development database. Remove sample `INSERT` rows before importing if you only want the table structure.

## Configuration

Main configuration lives in:

- `shared/config.lua`
- `shared/stress_config.lua`
- `shared/locales.lua`
- `shared/GetCore.lua`

Important options:

| Option | Description |
| --- | --- |
| `Config.Voice` | Voice system: `pma`, `mumble`, or `saltychat`. |
| `Config.SQL` | SQL wrapper: `oxmysql`, `ghmattimysql`, or `mysql-async`. |
| `Config.HudSettingsCommand` | Command used to open HUD settings. Default: `hudsettings`. |
| `Config.HudSettingsEvent` | Event used to open HUD settings. Default: `RV_HuD:OpenHudSettings`. |
| `Config.DefaultSpeedType` | Default speed unit: `kmh` or `mph`. |
| `Config.EnableSeatbelt` | Enables the built-in seatbelt system. |
| `Config.EnableVehicleModes` | Enables sport/drift vehicle modes. |
| `Config.EnableStress` | Enables the stress system. |
| `Config.Menu` | Toggles media, quick, vehicle, and settings menu sections. |
| `Config.Speedometers` | Toggles each speedometer style. |
| `Config.WaterMarkInformations` | Server logo, server name, and Discord link shown in the watermark. |

## Default Commands & Keys

| Command / Key | Description |
| --- | --- |
| `/hudsettings` | Opens the HUD settings menu. |
| `/togglehud` | Shows or hides the HUD. |
| `/reload` | Reloads HUD data. |
| `J` | Opens the HUD settings menu keybind. |
| `L` | Toggles seatbelt. |
| `B` | Toggles cruise control. |
| `Left Arrow` | Left indicator. |
| `Right Arrow` | Right indicator. |
| `Down Arrow` | Hazard lights. |
| `Delete` | Engine toggle when enabled. |
| `Left Ctrl` | Nitro key. |
| `Caps Lock` | Mouse cursor/menu interaction key. |

Keys can be changed in `shared/config.lua`.

## Events

Useful client events:

```lua
TriggerEvent("RV_Hud:ShowHud")
TriggerEvent("RV_Hud:HideHud")
TriggerEvent("RV_HuD:OpenHudSettings")
TriggerEvent("hud:client:UpdateStress", stressValue)
```

Useful server events:

```lua
TriggerServerEvent("hud:server:GainStress", amount)
TriggerServerEvent("hud:server:RelieveStress", amount)
TriggerServerEvent("RV_HuD:server:removeItem")
```

> Note: the included `server/stress.lua` logic is currently commented out. Enable or replace it before relying on the stress server events.

## Customization

- Add custom weapon images to `html/assets/weapons` and register them in `Config.AddonWeapons`.
- Edit text and notification strings in `shared/locales.lua`.
- Change default HUD colors, visibility, speedometer behavior, and widgets from `html/app/modules/hud.js`.
- Change server branding in `Config.WaterMarkInformations`.
- Add or remove safezones in `Config.SafezoneNotifyCoords`.
- Add or remove quick waypoint locations in `Config.QuickLocations`.
- Configure stress actions, whitelisted jobs, and whitelisted weapons in `shared/stress_config.lua`.

## File Structure

```text
RV_HuD/
├── client/              # Client-side Lua logic
├── server/              # Server-side Lua logic
├── shared/              # Shared config, locales, and ESX core loader
├── html/                # Vue-based NUI, CSS, assets, sounds, and speedometers
├── fxmanifest.lua       # FiveM resource manifest
└── user.sql             # Database tables
```

## Notes

- This resource is currently configured for ESX in `shared/GetCore.lua`.
- The default manifest uses `oxmysql`.
- Stress client/config support exists, but the default server stress implementation is commented out in `server/stress.lua`.
- Some default config entries reference custom resources such as `Hz_Notification`, `Hz_Fuel`, `Hz_BlackMoneyUpdate`, and `Coin-System`; update these integrations for your own server.
- If you do not use the optional stress or gift systems, disable them in the config.

## License

No license file is included. Add a license before publishing publicly if you want to define how others may use, modify, or redistribute this resource.
