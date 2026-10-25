# Argon UI Library

A script-hub UI library for Roblox executors, built in the same shape as
[Obsidian](https://github.com/deividcomsono/Obsidian): one `Library.lua`, a
ThemeManager and SaveManager in `addons/`, an `Example.lua`, and image sources in
`assets/`. The API follows Obsidian's, so most Obsidian scripts port by swapping the
loadstring URLs.

Status: **prototype (0.2.0)**. Tested live on Potassium 2.5.6.

## Loading

```lua
local repo = "https://raw.githubusercontent.com/YOUR_NAME/Argon/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
```

For local testing, put this folder in your executor's `workspace/Argon/` and run
`Example.lua`. It reads from the workspace first and only falls back to the URL.

## Tree

```
Argon/
├── .vscode/            luau-lsp settings + executor globals for autocomplete
├── addons/
│   ├── SaveManager.lua configs: save, load, overwrite, delete, autoload
│   └── ThemeManager.lua themes: six built-ins, custom themes, default theme
├── assets/             PNG sources for everything the library draws
├── Example.lua         every control, both addons, a menu tab
├── Library.d.luau      type definitions
├── Library.lua         the library (assets embedded, works offline)
├── init.luau           Rojo / Wally entry
├── selene.toml, UNC.yml  lint setup for executor globals
└── README.md, CHANGELOG.md
```

## API

```lua
local Window = Library:CreateWindow({ Title = "Hub", Footer = "v1", Icon = "atom", NotifySide = "Right" })
local Tab = Window:AddTab("Main", "house")

local Box = Tab:AddGroupbox({ Side = "Left", Name = "Player", IconName = "user", Description = "movement" })

Box:AddToggle("Fly", { Text = "Fly", Default = false, Risky = false, Tooltip = "..." })
    :AddKeyPicker("FlyKey", { Default = "F", Mode = "Toggle", SyncToggleState = true })
    :AddColorPicker("FlyColor", { Default = Color3.new(1, 1, 1), Transparency = 0 })
Box:AddCheckbox("Idx", { Text = "...", Default = true })
Box:AddButton({ Text = "Go", Func = fn, DoubleClick = false }):AddButton({ Text = "Sub", Func = fn })
Box:AddLabel("Text", true)
Box:AddLabel("Keybind"):AddKeyPicker("Key", { Default = "X", Mode = "Press" })
Box:AddDivider()
Box:AddSlider("Speed", { Text = "Speed", Default = 16, Min = 0, Max = 100, Rounding = 0, Suffix = " studs" })
Box:AddInput("Name", { Text = "Name", Placeholder = "...", Numeric = false, Finished = false })
Box:AddDropdown("Part", { Text = "Part", Values = { "Head", "Torso" }, Default = 1, Multi = false, Searchable = true })
Box:AddDropdown("Target", { Text = "Target", SpecialType = "Player", ExcludeLocalPlayer = true })

local TB = Tab:AddRightTabbox()
local Sub = TB:AddTab("Tab 1")

Library.Toggles.Fly:OnChanged(function(v) end)
Library.Options.Speed:SetValue(50)
Library:Notify({ Title = "Hub", Description = "Loaded", Time = 4, Type = "Success" })
Library.ToggleKeybind = Library.Options.MenuKeybind
Library:OnUnload(fn); Library:Unload()
```

`Tab:AddLeftGroupbox(name, icon)` and `Tab:AddRightGroupbox(name, icon)` are shorthands for
`AddGroupbox`. `AddLabel(text, true)` wraps. A tabbox tab is a normal groupbox.
`Library.ToggleKeybind` takes a key picker or an `Enum.KeyCode` (default RightShift).

Key picker modes: `Always`, `Toggle`, `Hold`, `Press` (`Press` only on labels; a
toggle synced with `SyncToggleState` offers `Toggle` and `Hold`).

New options over Obsidian: `HoldToConfirm = seconds` on buttons, `SaveState = false` and
`MobileButton = true` on `CreateWindow`, `Closable = false` on notifications, and
notification `Type = "Info" | "Success" | "Warn" | "Error"`. New methods:
`Library:ResetKeybinds()`, `Library:OnAnyChanged(fn)`, `Window:SetMinimized(bool)` and
`Window:SelectTab(name)`. `Library.UnlockMouseWhileOpen` and `Library.NotifyOnError`
default to true. `Library.MaxNotifications` (default 6) caps how many notifications show
at once.

Not in this prototype yet: dependency boxes, key tab and key box, viewport, image and
video elements, draggable labels, watermark.

## Quality of life

Based on a source-level survey of Obsidian, LinoriaLib, Rayfield, Fluent, WindUI, Luna and
Orion, plus rebinding guidance (Xbox XAG 107, Game Accessibility Guidelines, WCAG 2.1.4,
UAAG 2.0, Unity's rebinding API).

**Keybinds**
- Click a key picker to rebind it. It reads "Press a key", and its outline lights up and
  drains over 6 seconds, after which the rebind cancels.
- Cancel with Escape, by clicking the picker again or by clicking anywhere else.
  Backspace or Delete clears the bind. (Roblox always opens its own menu on Escape, which
  is why the other ways to cancel exist.)
- Hold Ctrl, Shift or Alt for a combo (`Ctrl+K`). Releasing a modifier on its own binds
  the modifier. MB2 and MB3 can be bound.
- While you rebind, every other bind is blocked, including the menu key.
- A duplicate bind gets a warning that names the other bind.
- Right-click a picker for its modes, Clear and Reset. `Library:ResetKeybinds()` resets
  every bind.
- Rows in the keybind list toggle their bind when clicked, which also works on touch.
- Binds never fire while you type. Mouse-button binds don't fire while the cursor is over
  the menu.

**Controls**
- Click a slider's value, or right-click its track, to type an exact number. Enter
  commits, rounded and clamped. Anything that isn't a number gets rejected.
- Dropdowns: Up, Down and Enter navigate. A searchable dropdown focuses its search box
  when it opens. The list opens scrolled to the current choice.
- `HoldToConfirm` buttons charge a tube while held. Letting go early drains it back. Used
  for Unload and for deleting configs and themes.
- Pressing a disabled control squishes it, flashes its outline red and shows its
  `DisabledTooltip` right away.
- If a callback errors, its control flashes red and an Error notification shows the
  message, at most one every 2 seconds.

**Window**
- Remembers its position, size and last tab per window title, in
  `Argon/ui_<Title>.json`, and is kept on screen after a drag, a restore or a resize.
- The DPI scale never makes the window bigger than the screen. If the chosen scale doesn't
  fit, the largest one that does is used, and it is worked out again when the game window
  is resized. After a scale change the window moves fully on screen, below the top bar.
- Popups stay inside the window, and tooltips flip to the other side of the cursor at the
  screen's edges.
- Notifications pause their timer while hovered and close when clicked. When more than
  `Library.MaxNotifications` (6) are showing, the oldest one closes early; `Persist`
  notifications are never closed this way.
- Unlocks the mouse while open (needed in shift-lock and first-person games).
- On touch devices a draggable 48 px toggle button appears. A tap opens or closes the menu;
  a drag moves the button.
- Hiding the window with the close button tells you the key that brings it back.

**Configs** (SaveManager)
- Create, load, overwrite, delete (hold to confirm), refresh and autoload.
- Autosave saves the selected config shortly after any setting changes.
- Export copies the current settings as JSON to the clipboard. Import applies pasted JSON.

## Icons

`Library:GetIcon(name)` and every `Icon` / `IconName` field take a Lucide icon name, a
Roblox asset id, or an `rbxasset://` / `http` URL. Built-in names:

activity, aperture, app-window, atom, backpack, ban, bell, bolt, bot, box, boxes, car,
check, chevron-down, chevron-left, chevron-right, chevron-up, chevrons-up-down,
circle-check, circle-dot, circle-question-mark, circle-x, clock, cloud, code, coins,
copy, crosshair, crown, download, ellipsis, external-link, eye, eye-off, fish, flag,
flame, folder, footprints, gamepad-2, gauge, ghost, gift, globe, grip-vertical, hand,
hash, heart, house, image, info, key, keyboard, layers, layout-grid, link, list, lock,
lock-open, magnet, mail, map, maximize-2, message-circle, minimize-2, minus, moon,
mouse, mouse-pointer-2, mouse-pointer-click, move, orbit, package, paintbrush, palette,
panel-left, pencil, pickaxe, pin, plane, plus, power, radar, radio, refresh-cw, rocket,
rotate-ccw, save, scan, scroll-text, search, send, settings, shield, shopping-cart,
skull, sliders-horizontal, sliders-vertical, sparkle, sparkles, square-check, star,
sun, sword, swords, target, terminal, timer, toggle-right, trash, triangle-alert,
trophy, upload, user, users, wand-sparkles, wifi, wrench, x, zap

## How assets work

Everything Argon draws (the icon sheet, glow, shadow, gas haze and alpha checker) is a white PNG tinted at runtime, so themes recolour all of it. The
PNGs in `assets/` are embedded as base64 in `Library.lua`. On first load they are
written to `workspace/Argon/assets/` and loaded through `getcustomasset`. There is no
download and no third-party code. File names carry a hash, so changed assets replace
old ones. If an executor lacks `getcustomasset`, the UI still works without icons.

## Design

The identity is a noble gas struck into light. Controls behave like glass discharge
tubes:

- **Motif:** the tube. A line with lit middle and transparent ends, used for the
  active-tab underline, the sub-tab underline, the page title underline and each
  notification's timer, which drains toward its centre. Toggle tracks and slider fills are
  capsules.
- **Underlines** all behave the same way: on a switch the old one collapses and the new one
  draws out from the centre of its tab. Sub-tab labels brighten on hover.
- **Keybind list:** each bind is a row with a keycap pill, its name and its mode. Active binds
  light up: the name turns bright and the keycap takes the accent. The header counts active
  binds, and an empty list says "No binds". Like the window, it has a thin accent rim along
  its top edge.
- **Active tab:** an underline whose ends fade to transparent, with a soft glow. On a tab
  switch it collapses at the old tab and draws out from the centre of the new one. A glint
  sweeps the full line from left to right, easing in at the left end and out at the right.
  It runs once when the window opens, after a switch and when you hover the active tab,
  never on a timer.
- **Tab hover:** a fainter half-length underline draws out from the middle of the label
  text and fades up, the label slides 4 px right and the label and icon brighten. Hovering
  the active tab brightens its glow instead.
- **One glow:** the active-tab underline is the only thing that glows. Toggles, sliders,
  icons, window buttons and notifications don't, so the eye has one place to land.
- **Motion:** smooth and quick, never flashy. Things light up with an eased fade (Quint or
  Quad out). There is no flicker, sparkle or overshoot bounce. The window opens with a
  0.32 s scale-in while its top rim fades up, and closes in 0.14 s. Presses compress by
  2% and release without a bounce.
- **Haze:** gas texture drifting sideways in the window body at about 5% visibility.
  It is the only looping motion, and it pauses when the window is hidden.
- **Surfaces:** violet-tinted blacks. Wells (inputs, tracks) are darker than panels;
  raised controls are lighter. Every panel is lit from the top by a slight gradient.
- **Accent rule:** the accent appears only on lit things: on, selected, focused,
  progress. Rose means risky or close, amber warns, mint confirms.
- **States change shape, not only colour:** a toggle's knob moves and grows when on,
  a checkbox gains a check, the selected tab gets an underline, a highlight and an icon tint.
  They still read in greyscale.
- **Themes** are the noble gases' real discharge colours: Argon (lilac), Neon
  (red-orange), Krypton (silver), Xenon (blue), Helium (peach), Radon (red).

## Performance

- No per-frame work at rest. Animation runs on TweenService.
- The whole library holds three global input connections however many controls it has.
  Every drag (sliders, colour pickers, window, resize, keybind list) goes through one
  shared mouse-move handler that only calls the drag in progress. Drag handlers are
  wrapped in `LPH_NO_VIRTUALIZE` so a Luarmor build keeps them native.
- Destroying the ScreenGui from outside runs `Unload()`, so connections never outlive
  the UI.
- The haze is the only looped tween, and it stops when the window is hidden.
- Icons are one sprite sheet, so the library makes one `getcustomasset` call for all
  of them.

## Credits

Icons from [Lucide](https://lucide.dev), ISC License (see `assets/LUCIDE_LICENSE`).
API shape after Obsidian / LinoriaLib.
