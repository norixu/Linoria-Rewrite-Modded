# 📦 Linoria Rewrite (Modded) – Complete Setup & Guide

Full guide covering **Library, UI creation, SaveManager, ThemeManager, configs, and themes**.

---

# ⚡ Installation

```lua
local repo = "https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/"

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ofugii/Linoria-Rewrite-Modded/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
```

---

# 🧠 GLOBAL SETUP (DO THIS FIRST)

These are **required** or things will break.

```lua
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
```

---

# 🪟 UI SETUP (WINDOW → TABS → SECTIONS)

## Create Window

```lua
local Window = Library:CreateWindow({
    Title = "My Script",
    Center = true,
    AutoShow = true
})
```

## Create Tabs

```lua
local Tabs = {
    Main = Window:AddTab("Main"),
    Settings = Window:AddTab("Settings")
}
```

## Create Section

```lua
local Section = Tabs.Main:AddSection("Main Controls")
```

---

# 🎛 CONTROLS SETUP

## Button

```lua
Section:AddButton({
    Text = "Do Something",
    Callback = function()
        print("clicked")
    end
})
```

## Toggle

```lua
Section:AddToggle("AutoFarm", {
    Text = "Auto Farm",
    Default = false,
    Callback = function(Value)
        print("AutoFarm:", Value)
    end
})
```

## Slider

```lua
Section:AddSlider("WalkSpeed", {
    Text = "Walk Speed",
    Default = 16,
    Min = 0,
    Max = 100,
    Callback = function(Value)
        print("Speed:", Value)
    end
})
```

## Dropdown

```lua
Section:AddDropdown("SelectWeapon", {
    Values = {"Sword", "Gun", "Bow"},
    Default = 1,
    Callback = function(Value)
        print("Selected:", Value)
    end
})
```

---

# ⚙️ SAVEMANAGER SETUP (CONFIG SYSTEM)

## Step 1 — Configure behavior

```lua
SaveManager:IgnoreThemeSettings() -- prevents themes inside configs
SaveManager:SetIgnoreIndexes({ "MenuKeybind" }) -- ignore keybind saving
```

## Step 2 — Set folders

```lua
SaveManager:SetFolder("MyScriptHub")
SaveManager:SetSubFolder("GameName") -- optional but recommended
```

📁 Result:

```
MyScriptHub/GameName/settings/
```

## Step 3 — Build config UI

```lua
SaveManager:BuildConfigSection(Tabs.Settings)
```

## Step 4 — Load default config (optional)

```lua
SaveManager:LoadAutoloadConfig()
```

---

# 🎨 THEMEMANAGER SETUP (UI COLORS)

## Step 1 — Set folder

```lua
ThemeManager:SetFolder("MyScriptHub")
```

📁 Result:

```
MyScriptHub/themes/
```

## Step 2 — Build theme UI

```lua
ThemeManager:ApplyToTab(Tabs.Settings)
```

---

# 💾 USING CONFIGS (MANUAL CONTROL)

## Save config

```lua
SaveManager:Save("myconfig")
```

## Load config

```lua
SaveManager:Load("myconfig")
```

## Autoload system

```lua
SaveManager:LoadAutoloadConfig()
```

---

# 🎨 USING THEMES

* Themes control:

  * Background color
  * Accent color
  * UI styling

* Managed automatically through the UI created by:

```lua
ThemeManager:ApplyToTab(...)
```

---

# 🔑 KEYBIND SETUP (TOGGLE UI)

```lua
Library:SetToggleKey(Enum.KeyCode.RightControl)
```

---

# 🚀 FULL WORKING EXAMPLE

```lua
local repo = "https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/"

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ofugii/Linoria-Rewrite-Modded/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

-- Window
local Window = Library:CreateWindow({
    Title = "Complete UI",
    Center = true,
    AutoShow = true
})

local Tabs = {
    Main = Window:AddTab("Main"),
    Settings = Window:AddTab("Settings")
}

local Section = Tabs.Main:AddSection("Controls")

Section:AddToggle("ExampleToggle", {
    Text = "Example Toggle",
    Default = false,
    Callback = function(Value)
        print(Value)
    end
})

-- Managers Setup
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

ThemeManager:SetFolder("MyScriptHub")
SaveManager:SetFolder("MyScriptHub")
SaveManager:SetSubFolder("ExampleGame")

-- Build UI
ThemeManager:ApplyToTab(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

SaveManager:LoadAutoloadConfig()

Library:SetToggleKey(Enum.KeyCode.RightControl)
```

---

# ⚠️ TROUBLESHOOTING

## UI not showing

* Run script after game loads
* Check executor supports `loadstring`

## Configs not saving

* Forgot `SetLibrary`
* Folder not set
* Missing `BuildConfigSection`

## Themes not working

* Forgot `ApplyToTab`
* Folder mismatch

## Settings tab empty

* Missing:

```lua
ThemeManager:ApplyToTab(...)
SaveManager:BuildConfigSection(...)
```

---

# 📌 BEST PRACTICES

* Always separate **Main** and **Settings** tabs
* Use unique IDs for toggles/sliders
* Keep folder names consistent across scripts
* Always call:

```lua
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
```

---

# 📄 NOTES

* Requires executor with HTTP + `loadstring`
* Configs saved locally (executor workspace)
* Themes are shared if folder matches

---

# 🧾 CREDITS

* Linoria UI Library
* Rewrite + Modded

---
