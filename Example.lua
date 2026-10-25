local repo = "https://github.com/IodineProject/Argon-UI/main/";
local function fetch(p)
    if isfile and isfile("Argon/" .. p) then return readfile("Argon/" .. p); end;
    return game:HttpGet(repo .. p);
end;

local Library = loadstring(fetch("Library.lua"))();
local ThemeManager = loadstring(fetch("addons/ThemeManager.lua"))();
local SaveManager = loadstring(fetch("addons/SaveManager.lua"))();

local Options = Library.Options;
local Toggles = Library.Toggles;

local Window = Library:CreateWindow({
    Title = "Argon",
    Footer = "example v" .. Library.Version,
    Icon = "atom",
    NotifySide = "Right",
});

local Tabs = {
    Main = Window:AddTab("Main", "house"),
    Combat = Window:AddTab("Combat", "swords"),
    Visuals = Window:AddTab("Visuals", "eye"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
};

local LeftGroupBox = Tabs.Main:AddGroupbox({ Side = "Left", Name = "Groupbox", IconName = "boxes", Description = "controls" });

LeftGroupBox:AddToggle("MyToggle", {
    Text = "This is a toggle",
    Tooltip = "Hover text for the toggle",
    DisabledTooltip = "This toggle is locked",
    Default = true,
    Callback = function(v) print("[cb] MyToggle:", v); end,
})
    :AddColorPicker("ColorPicker1", { Default = Color3.fromRGB(255, 92, 138), Title = "First colour", Callback = function(v) print("[cb] Color1:", v); end })
    :AddColorPicker("ColorPicker2", { Default = Color3.fromRGB(92, 227, 162), Title = "Second colour", Transparency = 0 });

Toggles.MyToggle:OnChanged(function() print("MyToggle changed to:", Toggles.MyToggle.Value); end);

LeftGroupBox:AddCheckbox("MyCheckbox", { Text = "This is a checkbox", Default = true });
LeftGroupBox:AddToggle("RiskyToggle", { Text = "Risky toggle", Risky = true, Tooltip = "Risky options show in red" });

local MyButton = LeftGroupBox:AddButton({
    Text = "Button",
    Func = function() Library:Notify({ Title = "Button", Description = "You clicked the button.", Time = 4 }); end,
    Tooltip = "A plain button",
});
MyButton:AddButton({
    Text = "Sub button",
    DoubleClick = true,
    Func = function() Library:Notify({ Title = "Sub button", Description = "Double click confirmed.", Time = 4, Type = "Success" }); end,
    Tooltip = "Click twice to confirm",
});
LeftGroupBox:AddButton({ Text = "Disabled button", Disabled = true, DisabledTooltip = "Can't press this", Func = function() end });
LeftGroupBox:AddButton({ Text = "Hold to confirm", Risky = true, HoldToConfirm = .8, Func = function() Library:Notify({ Title = "Confirmed", Description = "Held long enough.", Time = 3, Type = "Success" }); end });

LeftGroupBox:AddLabel("This is a label");
LeftGroupBox:AddLabel("This label wraps its text when it runs longer than the groupbox is wide.", true);
LeftGroupBox:AddLabel("TestLabel", { Text = "This label is stored in Options.TestLabel", DoesWrap = true });

LeftGroupBox:AddDivider();

LeftGroupBox:AddSlider("MySlider", {
    Text = "Walk speed",
    Default = 16,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Suffix = " studs",
    Callback = function(v) print("[cb] MySlider:", v); end,
});
Options.MySlider:OnChanged(function() print("MySlider changed to:", Options.MySlider.Value); end);

LeftGroupBox:AddSlider("MySlider2", {
    Text = "Custom display",
    Default = 0,
    Min = 0,
    Max = 5,
    Rounding = 0,
    FormatDisplayValue = function(s, v)
        if v == s.Max then return "Everything"; end;
        if v == s.Min then return "Nothing"; end;
    end,
});

LeftGroupBox:AddInput("MyTextbox", {
    Text = "Textbox",
    Default = "",
    Placeholder = "Type something",
    Finished = false,
    Callback = function(v) print("[cb] Text:", v); end,
});

LeftGroupBox:AddLabel("Color"):AddColorPicker("ColorPicker", { Default = Color3.fromRGB(0, 255, 140), Title = "Label colour", Transparency = 0 });

LeftGroupBox:AddLabel("Keybind"):AddKeyPicker("KeyPicker", {
    Default = "MB2",
    Mode = "Toggle",
    Text = "Auto lockpick safes",
    Callback = function(v) print("[cb] Keybind clicked!", v); end,
    ChangedCallback = function(k) print("[cb] Keybind changed!", k); end,
});
Options.KeyPicker:OnClick(function() print("Keybind clicked!", Options.KeyPicker:GetState()); end);

LeftGroupBox:AddLabel("Press keybind"):AddKeyPicker("KeyPicker2", { Default = "X", Mode = "Press", Text = "Increase number" });

local DropdownGroupBox = Tabs.Main:AddGroupbox({ Side = "Right", Name = "Dropdowns", IconName = "list" });

DropdownGroupBox:AddDropdown("MyDropdown", { Text = "A dropdown", Values = { "This", "is", "a", "dropdown" }, Default = 1, Tooltip = "Pick one" });
Options.MyDropdown:OnChanged(function() print("Dropdown:", Options.MyDropdown.Value); end);

DropdownGroupBox:AddDropdown("MySearchableDropdown", { Text = "A searchable dropdown", Values = { "Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Golf", "Hotel", "India", "Juliet", "Kilo", "Lima" }, Default = 1, Searchable = true });

DropdownGroupBox:AddDropdown("MyMultiDropdown", { Text = "A multi dropdown", Values = { "Head", "Torso", "Arms", "Legs" }, Default = { "Head", "Torso" }, Multi = true });

DropdownGroupBox:AddDropdown("MyDictionaryDropdown", {
    Text = "A dictionary dropdown",
    Values = { item01 = "Excalibur", item05 = "Aegis Shield", item06 = "Wooden Club" },
    Default = "item01",
    DisabledValues = { "item05" },
});

DropdownGroupBox:AddDropdown("MyDisabledDropdown", { Text = "A disabled dropdown", Values = { "Locked" }, Default = 1, Disabled = true });
DropdownGroupBox:AddDropdown("MyPlayerDropdown", { Text = "A player dropdown", SpecialType = "Player", ExcludeLocalPlayer = true });

local TabBox = Tabs.Main:AddRightTabbox();
local Tab1 = TabBox:AddTab("Tab 1");
Tab1:AddToggle("Tab1Toggle", { Text = "Tab 1 toggle" });
local Tab2 = TabBox:AddTab("Tab 2");
Tab2:AddToggle("Tab2Toggle", { Text = "Tab 2 toggle" });
Tab2:AddSlider("Tab2Slider", { Text = "Tab 2 slider", Default = 3, Min = 0, Max = 10, Rounding = 0 });

local AimBox = Tabs.Combat:AddLeftGroupbox("Aim", "crosshair");
AimBox:AddToggle("SilentAim", { Text = "Silent aim" }):AddKeyPicker("SilentAimKey", { Default = "E", Mode = "Hold", Text = "Silent aim", SyncToggleState = true });
AimBox:AddSlider("AimFov", { Text = "Field of view", Default = 120, Min = 10, Max = 400, Rounding = 0, Suffix = "°" });
AimBox:AddDropdown("AimPart", { Text = "Target part", Values = { "Head", "Torso", "Closest" }, Default = 1 });

local MoveBox = Tabs.Combat:AddRightGroupbox("Movement", "footprints");
MoveBox:AddToggle("Fly", { Text = "Fly" }):AddKeyPicker("FlyKey", { Default = "F", Mode = "Toggle", Text = "Fly", SyncToggleState = true });
MoveBox:AddSlider("FlySpeed", { Text = "Fly speed", Default = 80, Min = 10, Max = 300, Rounding = 0 });
MoveBox:AddToggle("Noclip", { Text = "Noclip", Risky = true });

local EspBox = Tabs.Visuals:AddLeftGroupbox("ESP", "scan");
EspBox:AddToggle("EspBoxes", { Text = "Boxes" }):AddColorPicker("EspBoxColor", { Default = Color3.fromRGB(176, 146, 255) });
EspBox:AddToggle("EspNames", { Text = "Names" });
EspBox:AddToggle("EspHealth", { Text = "Health bars", Default = true });
EspBox:AddSlider("EspDistance", { Text = "Max distance", Default = 1500, Min = 100, Max = 5000, Rounding = 0, Suffix = " studs" });

Library:OnUnload(function() print("Unloaded!"); end);

local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu", "wrench");
MenuGroup:AddToggle("KeybindMenuOpen", { Text = "Keybind list", Default = Library.KeybindFrame.Visible, Callback = function(v) Library.KeybindFrame.Visible = v; end });
MenuGroup:AddDropdown("NotificationSide", { Text = "Notification side", Values = { "Left", "Right" }, Default = "Right", Callback = function(v) Library:SetNotifySide(v); end });
MenuGroup:AddDropdown("DPIDropdown", { Text = "DPI scale", Values = { "75%", "100%", "125%", "150%", "175%", "200%" }, Default = "100%", Callback = function(v) Library:SetDPIScale(tonumber((v:gsub("%%", "")))); end });
MenuGroup:AddDivider();
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" });
MenuGroup:AddButton({ Text = "Reset keybinds", Func = function() Library:ResetKeybinds(); Library:Notify({ Title = "Keybinds", Description = "Every keybind is back to its default.", Time = 3 }); end });
MenuGroup:AddButton({ Text = "Unload", Risky = true, HoldToConfirm = 1, Func = function() Library:Unload(); end });

Library.ToggleKeybind = Options.MenuKeybind;

ThemeManager:SetLibrary(Library);
SaveManager:SetLibrary(Library);
SaveManager:IgnoreThemeSettings();
SaveManager:SetIgnoreIndexes({ "MenuKeybind" });
ThemeManager:SetFolder("Argon");
SaveManager:SetFolder("Argon/example");
SaveManager:BuildConfigSection(Tabs["UI Settings"]);
ThemeManager:ApplyToTab(Tabs["UI Settings"]);
SaveManager:LoadAutoloadConfig();

Library:Notify({ Title = "Argon", Description = "Loaded. Press RightShift to hide or show the menu.", Time = 5 });
