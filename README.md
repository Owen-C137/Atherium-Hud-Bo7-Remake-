# Aetherium HUD - BO7 Remake for BO3

> This is not a complete 1:1 recreation. 

---
### Adding To The HUD

1. [How To Add Perks](https://github.com/Owen-C137/Atherium-Hud-Bo7-Remake-/wiki/How-To-Add-Perks)
2. [How To Add Weapons](https://github.com/Owen-C137/Aetherium-Hud-Bo7-Remake-/wiki/How-To-Add-Weapons)
3. [How To Add Powerups](https://github.com/Owen-C137/Aetherium-Hud-Bo7-Remake-/wiki/How-To-Add-New-Powerups)
4. [How To Change Player Icons](https://github.com/Owen-C137/Atherium-Hud-Bo7-Remake-/wiki/How-To-Change-Player-Portrait)
5. [How To Change AAT Icons](https://github.com/Owen-C137/Atherium-Hud-Bo7-Remake-/wiki/How-To-Change-AAT-Icons)

## Note:

This HUD is not fully finished there are still some features that need to be added and bugs to be fixed, 
this is a beta/test version to find issues before releasing publicly.

---

## Support
If you need help with installation or have any questions, feel free to join my Discord server for support:
- [Discord Invite Link](https://discord.gg/9aYFZ6Fq7W)
---

## Preview

Main HUD:
![Main HUD](https://i.ibb.co/ps1VxC0/Hud.png)

ScoreBoard:
![ScoreBoard](https://i.ibb.co/LDmVsM6s/Scoreboard.png)

Pause Menu:
![Pause Menu](https://i.ibb.co/gFb7mcn0/Pase-Menu.png)

Options Menu:
![Options Menu](https://i.ibb.co/RGRGf3TY/Options-Menu.png)

---

## Installation

### Step 1: Install Assets

1. Navigate to the `DRAG_IN_BO3_ROOT` folder
2. Copy the `model_export` folder into your **Black Ops 3 root directory**
   - Example: `D:\SteamLibrary\steamapps\common\Call of Duty Black Ops III\`
3. When prompted, merge/overwrite existing files

### Step 2: Install HUD Files

1. Navigate to the `USERMAPS` folder
2. Copy all folders (`fonts`, `localizedstrings`, `scripts`, `ui`, `zone_source`) into your **usermaps directory**
   - Example: `D:\SteamLibrary\steamapps\common\Call of Duty Black Ops III\usermaps\`
3. When prompted, merge/overwrite existing files

### Step 3: Update Your Map Scripts

**Main GSC File** (`usermaps\zm_yourmap\scripts\zm\zm_yourmap.gsc`):

Add this line **above** `#using scripts\zm\zm_usermap;`:

```gsc
// Aetherium HUD
#using scripts\zm\_zm_aetherium_hud;

#using scripts\zm\zm_usermap;
```

**Main CSC File** (`usermaps\zm_yourmap\scripts\zm\zm_yourmap.csc`):

Add this line **above** `#using scripts\zm\zm_usermap;`:

```gsc
// Aetherium HUD
#using scripts\zm\_zm_aetherium_hud;

#using scripts\zm\zm_usermap;
```

### Step 4: Update Zone File

**Zone File** (`zone_source\zm_yourmap.zone`):

Add this line **below** the `>group,modtools` line:

```
>class,zm_mod_level
>group,modtools

include,aetherium_hud
```

### Step 5: Compile Your Map

Done! Recompile and relink your map to see the HUD in action.

---

## Signatures

You can disable the Signatures that show in the bottom right corner by opening the file:
ui\uieditor\menus\StartMenu\AetheriumStartMenu.lua

Change: local ShowSignatures = true 
to false

---

## Compatibility

- **Zombies Mode** only (Multiplayer not supported)

---

## Troubleshooting

### HUD doesn't appear in-game
- Verify all files were copied to the correct directories
- Make sure you added the `#using` statements to **both** GSC and CSC files
- Check that `include,aetherium_hud` is in your zone file
- Recompile and relink your map

### UI Errors (63349, 74046, etc.)
- Make sure the `aetherium_hud.zpkg` zone file exists in `zone_source\`
- Verify all Lua widget files are present in `ui\uieditor\widgets\`
- Check console log (`console_mp.log`) for specific missing files


---

## Credits

- Kingslayer Kyle 
- Shidouri
- MadGaz
---

## For Support Join My Discord: 
- [Discord Invite Link](https://discord.gg/pzt9gRDPPS)

---

## License

This HUD system is free to use and modify for your custom zombie maps. Credit is appreciated but not required.

**Development Note:**
This HUD was created primarily through AI assistance.


