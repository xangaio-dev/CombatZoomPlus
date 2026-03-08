# CombatZoomPlus v12.0.1

**Automatically adjusts your camera zoom based on player state in World of Warcraft.**  
CombatZoomPlus changes the camera zoom when you are in combat, mounted, in an instance, or idle — and resets when the state changes.

---

## Features

- Auto zoom out when in **combat**  
- Auto zoom when **mounted**  
- Auto zoom for **instances** (dungeons, raids, PvP, scenarios)  
- Smooth resetting when returning to idle  
- Fully configurable in-game via slash commands  
- Saved settings per character  

---

## Installation

1. Download the `CombatZoomPlus` folder and place it in your `World of Warcraft/_retail_/Interface/AddOns/` directory.  
2. Ensure the folder contains:  
   - `CombatZoomPlus.lua`  
   - `CombatZoomPlus.toc`  
3. Reload UI or restart the game.  

---

## Slash Commands

| Command | Description |
|---------|-------------|
| `/czp help` | Show available commands |
| `/czp show` | Display current zoom settings |
| `/czp reset` | Reset zoom settings to default |
| `/czp idle <value>` | Set zoom for idle state |
| `/czp mounted <value>` | Set zoom for mounted state |
| `/czp combat <value>` | Set zoom for combat state |
| `/czp instance <value>` | Set zoom for instance state |

 ---

## Default Zoom Values

- Idle: 11 (1.1x)  
- Mounted: 26 (2.6x)  
- Combat: 32 (3.2x)  
- Instance: 22 (2.2x)  

---

## Release Notes

**v12.0.1**  
- ✅ Compatible with **Midnight Expansion**  
- Added in-game configurable zoom via slash commands  
- Added `/czp show` and `/czp reset`  
- Improved event handling for smoother zoom changes  
- Polished UI messages and slash command feedback  

---
