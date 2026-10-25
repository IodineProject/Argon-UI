# Changelog

## 0.2.0

- Fixed: key pickers and colour swatches on toggle rows could not be clicked; the
  toggle row's click area sat above them.
- Fixed: mouse-button binds written as MB1, MB2 or MB3 (Obsidian style) never fired.
- Fixed: a toggle's knob jumped out of its track at the start of the switch animation.
- Fixed: a slider's value text overflowed its 90 px box and could run into the slider's
  name. The value now sizes to its text and the name truncates.
- Fixed: a colour picker opened near the window's right edge spilled out of the window,
  and off screen when the window was against the screen edge.
- Fixed: tooltips ran off the right and bottom of the screen.
- Key pickers are tighter and centre their key: a single key is a 20 px square (was
  44 px wide with the key on the left).
- Fixed: raising the DPI scale could push the window off screen, or make it bigger than
  the screen. The scale is now capped to fit, and the window moves back on screen.
- Fixed: destroying the ScreenGui without `Unload()` left the library's connections alive.
- Notifications are capped at `Library.MaxNotifications` (6); the oldest closes early.
- Fixed: at a DPI scale above 100% notifications were placed below the bottom of the
  screen (their column scaled past the screen height).
- Sub-tab underline matches the main tab's: transparent ends and the accent gradient. It
  collapses and redraws from the centre on a switch instead of sliding as a solid bar.
  Sub-tab labels brighten on hover.
- Notifications: the left stripe that drained to a dot became a bottom underline in the
  notification's colour, with transparent ends, that drains toward its centre.
- ThemeManager: the font dropdown lists all 41 font families Roblox ships (was 6) and is
  searchable. Saved themes that use the old names still load.
- Keybind list redesign: keycap pills, names that light up when active, modes on the
  right, an active count in the header, a "No binds" empty state and the accent top rim.
- Performance: all drags share one mouse-move connection (there was one per slider,
  colour picker and drag handle).
- Rebinding now has a listening state with a draining outline and a 6 second timeout.
  Escape, a second click or a click elsewhere cancels; Backspace and Delete clear;
  Ctrl, Shift and Alt combos work. Other binds and the menu key are blocked while you
  rebind, and duplicate binds get a warning.
- The key picker's right-click menu adds Clear and Reset. Added
  `Library:ResetKeybinds()`. Keybind list rows toggle when clicked.
- Mouse-button binds no longer fire while the cursor is over the menu.
- Sliders take a typed value (click the value, or right-click the track).
- Dropdowns: keyboard navigation, search box focused on open, list scrolled to the
  current choice.
- Buttons: `HoldToConfirm`. Disabled controls react when pressed. Callback errors flash
  the control and post an Error notification.
- Window: remembers position, size and last tab, stays on screen, unlocks the mouse
  while open, and has an optional mobile toggle button.
- Notifications pause on hover and close on click.
- SaveManager: autosave, export to clipboard, import from pasted JSON.
- Added `Library:OnAnyChanged(fn)`.
- The active tab's side rail became an underline with transparent ends. It collapses
  and redraws on a tab switch. A glint sweeps it from left to right, fading in and out at
  its ends, when the window opens, after a switch and on hover. The tab highlight is now
  symmetric.
- Effects pass for a calmer, more premium look. Removed the four-ray sparks (toggles,
  checkboxes, hold-to-confirm, key binds, tab switch, window open, mobile button) and the
  flicker strike (window rim, page icon, notification stripe, key binds, hold-to-confirm);
  both are replaced by smooth fades. Removed the glows on toggles, slider knobs, the brand
  and page icons, window buttons, the window rim and notifications; the active-tab underline
  is the only glow left. Overshoot bounces are now plain ease-outs, the press squish is 2%
  instead of 3.5%, and slider knobs grow on hover instead of glowing. The glint no longer
  runs on a timer. The Spark texture is gone from `assets/` and the embedded data.
- Tabs have a hover animation: a faint half-length underline draws out from the
  middle of the label text, the label slides and the label and icon brighten.

## 0.1.0 (prototype)

- Window with a sidebar of tabs, a page header (the tab's icon in a lit capsule with a
  charging underline), a search box, minimize and close (hide), a resize grip, a
  shadow, a drifting gas haze and a strike-on open animation.
- Groupboxes (left and right, with icon and description) and tabboxes.
- Toggle, checkbox, button with sub-buttons and double-click confirm, label (wrapping,
  indexed), divider, slider (prefix, suffix, rounding, compact, hide max, custom
  format), input (numeric, finished, max length), dropdown (single, multi, searchable,
  dictionary values, disabled values, player and team lists), colour picker (hue,
  saturation/value, alpha, hex), key picker (Always, Toggle, Hold, Press; right-click
  menu; synced toggles) and a keybind list.
- Notifications with Info, Success, Warn and Error types and a draining timer.
- Tooltips, DPI scaling and theme registry.
- ThemeManager: six built-in noble-gas themes, live colour and font editing, custom
  themes and a default theme.
- SaveManager: per-game and per-place configs, overwrite, delete, refresh and autoload.
- 120 Lucide icons and all textures embedded and loaded through `getcustomasset`.
