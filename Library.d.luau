export type Scheme = {
    BackgroundColor: Color3,
    SidebarColor: Color3,
    MainColor: Color3,
    WellColor: Color3,
    RaisedColor: Color3,
    OutlineColor: Color3,
    AccentColor: Color3,
    AccentColor2: Color3,
    FontColor: Color3,
    MutedColor: Color3,
    RedColor: Color3,
    WarnColor: Color3,
    GoodColor: Color3,
    Font: Font,
    DisplayFont: Font,
}

export type Icon = { Url: string, ImageRectOffset: Vector2, ImageRectSize: Vector2 }

export type Notification = {
    Title: string?,
    Description: string,
    Time: number | Instance,
    Destroyed: boolean,
    ChangeTitle: (self: Notification, Text: string) -> (),
    ChangeDescription: (self: Notification, Text: string) -> (),
    Destroy: (self: Notification) -> (),
}

export type NotifyInfo = {
    Title: string?,
    Description: string?,
    Time: (number | Instance)?,
    Persist: boolean?,
    Type: ("Info" | "Success" | "Warn" | "Error")?,
}

export type ColorPicker = {
    Type: "ColorPicker",
    Value: Color3,
    Transparency: number?,
    Title: string?,
    SetValue: (self: ColorPicker, HSV: { number } | Color3, Transparency: number?) -> (),
    SetValueRGB: (self: ColorPicker, Color: Color3, Transparency: number?) -> (),
    OnChanged: (self: ColorPicker, Callback: (Color3) -> ()) -> (),
}

export type KeyPicker = {
    Type: "KeyPicker",
    Value: string,
    Mode: "Always" | "Toggle" | "Hold" | "Press",
    Toggled: boolean,
    GetState: (self: KeyPicker) -> boolean,
    SetValue: (self: KeyPicker, Data: { string } | string) -> (),
    OnClick: (self: KeyPicker, Callback: (boolean) -> ()) -> (),
    OnChanged: (self: KeyPicker, Callback: (string) -> ()) -> (),
}

export type ColorPickerInfo = { Default: Color3?, Title: string?, Transparency: number?, Callback: ((Color3) -> ())?, Changed: ((Color3) -> ())? }
export type KeyPickerInfo = { Default: string?, Mode: ("Always" | "Toggle" | "Hold" | "Press")?, Text: string?, NoUI: boolean?, SyncToggleState: boolean?, Callback: ((boolean) -> ())?, ChangedCallback: ((string) -> ())? }

export type Toggle = {
    Type: "Toggle" | "Checkbox",
    Value: boolean,
    Text: string,
    Disabled: boolean,
    Visible: boolean,
    SetValue: (self: Toggle, Value: boolean) -> (),
    SetText: (self: Toggle, Text: string) -> (),
    SetDisabled: (self: Toggle, Disabled: boolean) -> (),
    SetVisible: (self: Toggle, Visible: boolean) -> (),
    OnChanged: (self: Toggle, Callback: (boolean) -> ()) -> (),
    AddColorPicker: (self: Toggle, Idx: string, Info: ColorPickerInfo) -> Toggle,
    AddKeyPicker: (self: Toggle, Idx: string, Info: KeyPickerInfo) -> Toggle,
}

export type ToggleInfo = { Text: string?, Default: boolean?, Risky: boolean?, Disabled: boolean?, Visible: boolean?, Tooltip: string?, DisabledTooltip: string?, Callback: ((boolean) -> ())?, Changed: ((boolean) -> ())? }

export type Button = {
    Type: "Button",
    Text: string,
    Disabled: boolean,
    SetText: (self: Button, Text: string) -> (),
    SetDisabled: (self: Button, Disabled: boolean) -> (),
    SetVisible: (self: Button, Visible: boolean) -> (),
    AddButton: (self: Button, Info: ButtonInfo | string, Func: (() -> ())?) -> Button,
}

export type ButtonInfo = { Text: string, Func: () -> (), DoubleClick: boolean?, Risky: boolean?, Disabled: boolean?, Visible: boolean?, Tooltip: string?, DisabledTooltip: string? }

export type Label = {
    Type: "Label",
    Text: string,
    SetText: (self: Label, Text: string) -> (),
    SetVisible: (self: Label, Visible: boolean) -> (),
    AddColorPicker: (self: Label, Idx: string, Info: ColorPickerInfo) -> Label,
    AddKeyPicker: (self: Label, Idx: string, Info: KeyPickerInfo) -> Label,
}

export type LabelInfo = { Text: string, DoesWrap: boolean?, Size: number?, Visible: boolean? }

export type Slider = {
    Type: "Slider",
    Value: number,
    Min: number,
    Max: number,
    Rounding: number,
    SetValue: (self: Slider, Value: number) -> (),
    SetMin: (self: Slider, Value: number) -> (),
    SetMax: (self: Slider, Value: number) -> (),
    SetText: (self: Slider, Text: string) -> (),
    SetDisabled: (self: Slider, Disabled: boolean) -> (),
    SetVisible: (self: Slider, Visible: boolean) -> (),
    OnChanged: (self: Slider, Callback: (number) -> ()) -> (),
}

export type SliderInfo = { Text: string?, Default: number?, Min: number?, Max: number?, Rounding: number?, Prefix: string?, Suffix: string?, Compact: boolean?, HideMax: boolean?, FormatDisplayValue: ((Slider, number) -> string?)?, Disabled: boolean?, Visible: boolean?, Tooltip: string?, DisabledTooltip: string?, Callback: ((number) -> ())? }

export type Input = {
    Type: "Input",
    Value: string,
    SetValue: (self: Input, Text: string) -> (),
    SetDisabled: (self: Input, Disabled: boolean) -> (),
    SetVisible: (self: Input, Visible: boolean) -> (),
    OnChanged: (self: Input, Callback: (string) -> ()) -> (),
}

export type InputInfo = { Text: string?, Default: string?, Placeholder: string?, Numeric: boolean?, Finished: boolean?, ClearTextOnFocus: boolean?, MaxLength: number?, AllowEmpty: boolean?, EmptyReset: string?, Disabled: boolean?, Visible: boolean?, Tooltip: string?, Callback: ((string) -> ())? }

export type Dropdown = {
    Type: "Dropdown",
    Value: any,
    Values: { any },
    Multi: boolean,
    SetValue: (self: Dropdown, Value: any) -> (),
    SetValues: (self: Dropdown, Values: { any }) -> (),
    AddValues: (self: Dropdown, Values: { any } | any) -> (),
    GetActiveValues: (self: Dropdown) -> number,
    SetDisabled: (self: Dropdown, Disabled: boolean) -> (),
    SetVisible: (self: Dropdown, Visible: boolean) -> (),
    Refresh: (self: Dropdown) -> (),
    OnChanged: (self: Dropdown, Callback: (any) -> ()) -> (),
}

export type DropdownInfo = { Text: string?, Values: { [any]: any }?, Default: any, Multi: boolean?, Searchable: boolean?, AllowNull: boolean?, MaxVisibleDropdownItems: number?, SpecialType: ("Player" | "Team")?, ExcludeLocalPlayer: boolean?, DisabledValues: { any }?, KeepDisabledValuePosition: boolean?, FormatDisplayValue: ((any) -> string)?, Disabled: boolean?, Visible: boolean?, Tooltip: string?, Callback: ((any) -> ())? }

export type Groupbox = {
    Name: string,
    AddToggle: (self: Groupbox, Idx: string, Info: ToggleInfo) -> Toggle,
    AddCheckbox: (self: Groupbox, Idx: string, Info: ToggleInfo) -> Toggle,
    AddButton: (self: Groupbox, Info: ButtonInfo | string, Func: (() -> ())?) -> Button,
    AddLabel: (self: Groupbox, ...any) -> Label,
    AddDivider: (self: Groupbox) -> { SetVisible: (any, boolean) -> () },
    AddSlider: (self: Groupbox, Idx: string, Info: SliderInfo) -> Slider,
    AddInput: (self: Groupbox, Idx: string, Info: InputInfo) -> Input,
    AddDropdown: (self: Groupbox, Idx: string, Info: DropdownInfo) -> Dropdown,
}

export type Tabbox = { AddTab: (self: Tabbox, Name: string) -> Groupbox }

export type GroupboxInfo = { Side: ("Left" | "Right")?, Name: string?, IconName: string?, Description: string? }

export type Tab = {
    Name: string,
    AddGroupbox: (self: Tab, Info: GroupboxInfo) -> Groupbox,
    AddLeftGroupbox: (self: Tab, Name: string, Icon: string?) -> Groupbox,
    AddRightGroupbox: (self: Tab, Name: string, Icon: string?) -> Groupbox,
    AddTabbox: (self: Tab, Info: GroupboxInfo) -> Tabbox,
    AddLeftTabbox: (self: Tab, Name: string?) -> Tabbox,
    AddRightTabbox: (self: Tab, Name: string?) -> Tabbox,
}

export type WindowInfo = { Title: string?, Footer: string?, Icon: (string | number)?, Size: (UDim2 | Vector2)?, Position: UDim2?, Center: boolean?, AutoShow: boolean?, Resizable: boolean?, NotifySide: ("Left" | "Right")?, ToggleKeybind: Enum.KeyCode? }

export type Window = {
    Title: string,
    Tabs: { [string]: Tab },
    AddTab: (self: Window, Name: string, Icon: string?) -> Tab,
    SelectTab: (self: Window, Tab: Tab | string) -> (),
    SetTitle: (self: Window, Text: string) -> (),
    SetFooter: (self: Window, Text: string) -> (),
    SetMinimized: (self: Window, Minimized: boolean) -> (),
    Toggle: (self: Window, Visible: boolean?) -> (),
}

export type Library = {
    Version: string,
    Folder: string,
    Options: { [string]: any },
    Toggles: { [string]: Toggle },
    Labels: { [string]: Label },
    Scheme: Scheme,
    Toggled: boolean,
    Unloaded: boolean,
    NotifySide: "Left" | "Right",
    DPIScale: number,
    MaxNotifications: number?,
    ForceCheckbox: boolean,
    ToggleKeybind: (KeyPicker | Enum.KeyCode)?,
    ScreenGui: ScreenGui,
    KeybindFrame: Frame,
    CreateWindow: (self: Library, Info: WindowInfo) -> Window,
    Notify: (self: Library, Info: NotifyInfo | string, Time: number?) -> Notification,
    Toggle: (self: Library, Visible: boolean?) -> (),
    SetDPIScale: (self: Library, Scale: number) -> (),
    SetNotifySide: (self: Library, Side: "Left" | "Right") -> (),
    GetIcon: (self: Library, Name: string | number) -> Icon?,
    AddToRegistry: (self: Library, Instance: Instance, Properties: { [string]: string | () -> any }) -> Instance,
    UpdateColorsUsingRegistry: (self: Library) -> (),
    AddTooltip: (self: Library, Info: string?, DisabledInfo: string?, Hover: GuiObject, Element: any?) -> (),
    SafeCallback: (self: Library, Callback: (...any) -> ...any, ...any) -> (),
    GiveSignal: (self: Library, Connection: RBXScriptConnection) -> RBXScriptConnection,
    OnUnload: (self: Library, Callback: () -> ()) -> (),
    Unload: (self: Library) -> (),
    ClosePopups: () -> (),
}

return nil
