# Aetherium HUD - BO7 Remake for BO3

> This is not a complete 1:1 recreation. This HUD was created with the available tools and assets in BO3 modding.

---

## Note:

This HUD is not fully finished there are still some features that need to be added and bugs to be fixed, 
this is a beta/test version to find issues before releasing publicly.

---

## Installation

### Step 1: Install Model Assets

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

1. Open **Launcher** (Mod Tools)
2. Select your map from the dropdown
3. Click **"Compile"** and wait for it to finish
4. Click **"Link"** after compilation completes
5. Launch your map and enjoy the new HUD!

---

## Signitures

You can disable the signitures that show in the bottom right corner by opening the file:
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

**Kingslayer Kyle** 
**Shidouri** 
**MadGaz** 
---

## Support Join My Discord: [Discord Invite Link](https://discord.gg/fRhT4GNryr)

---

## License

This HUD system is free to use and modify for your custom zombie maps. Credit is appreciated but not required.

**Development Note:**
This HUD was created primarily through AI assistance.


