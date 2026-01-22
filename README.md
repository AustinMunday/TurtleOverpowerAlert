```md
# TurtleOverpowerAlert

Turtle WoW (1.12) Warrior addon that shows an on screen alert when Overpower is available.

## What it does
- Displays a large on screen message when Overpower becomes usable
- Re checks automatically when you change targets, stances, or cooldowns update
- Works by detecting Overpower on your action bars and watching when the action becomes usable

## Requirements
- Turtle WoW client (1.12 addon format)
- Warrior class
- Overpower must be placed on any action bar slot

## Install
1. Download the latest release zip from this repo (Releases).
2. Extract the folder `OverpowerAlert` into your Turtle WoW AddOns folder:
   - `World of Warcraft/Interface/AddOns/`
3. You should end up with:
   - `World of Warcraft/Interface/AddOns/OverpowerAlert/OverpowerAlert.toc`
4. Restart the game.
5. On the character select screen, click AddOns and enable `OverpowerAlert`.

## Usage
- Put Overpower on any action bar slot.
- When Overpower is available, the addon will show:
  - OVERPOWER NOW

## Commands
- `/opalert scan` re scan your action bars for Overpower
- `/opalert test` shows the alert for testing

## Troubleshooting
- If you never see the alert, make sure:
  - You are on a Warrior
  - Overpower is on your action bars (any slot)
  - The addon is enabled on the character select AddOns screen
- If you moved Overpower to a different slot, run:
  - `/opalert scan`

## Planned improvements
- Optional sound alert
- Option to show only while in combat
- Customizable text, size, and position

## License
MIT
```
