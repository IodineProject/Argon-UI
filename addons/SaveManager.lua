local HS = game:GetService("HttpService");

local SM = { Folder = "Argon", SubFolder = "", Ignore = {}, Library = nil };

SM.Parser = {
    Toggle = {
        Save = function(i, o) return { type = "Toggle", idx = i, value = o.Value }; end,
        Load = function(i, d) local t = SM.Library.Toggles[i]; if t and t.Value ~= d.value then t:SetValue(d.value); end; end,
    },
    Slider = {
        Save = function(i, o) return { type = "Slider", idx = i, value = tostring(o.Value) }; end,
        Load = function(i, d) local o = SM.Library.Options[i]; if o then o:SetValue(tonumber(d.value)); end; end,
    },
    Dropdown = {
        Save = function(i, o) return { type = "Dropdown", idx = i, value = o.Value, multi = o.Multi }; end,
        Load = function(i, d) local o = SM.Library.Options[i]; if o then o:SetValue(d.value); end; end,
    },
    ColorPicker = {
        Save = function(i, o) return { type = "ColorPicker", idx = i, value = o.Value:ToHex(), transparency = o.Transparency }; end,
        Load = function(i, d) local o = SM.Library.Options[i]; if o then o:SetValueRGB(Color3.fromHex(d.value), d.transparency); end; end,
    },
    KeyPicker = {
        Save = function(i, o) return { type = "KeyPicker", idx = i, mode = o.Mode, key = o.Value, modifiers = o.Modifiers }; end,
        Load = function(i, d) local o = SM.Library.Options[i]; if o then o:SetValue({ d.key, d.mode, d.modifiers or {} }); end; end,
    },
    Input = {
        Save = function(i, o) return { type = "Input", idx = i, text = o.Value }; end,
        Load = function(i, d) local o = SM.Library.Options[i]; if o and type(d.text) == "string" then o:SetValue(d.text); end; end,
    },
};
SM.Parser.Checkbox = SM.Parser.Toggle;

function SM:SetLibrary(l) self.Library = l; end;
function SM:SetFolder(f) self.Folder = f; self:BuildFolderTree(); end;
function SM:SetSubFolder(f) self.SubFolder = f; self:BuildFolderTree(); end;
function SM:SetIgnoreIndexes(t) for _, k in ipairs(t) do self.Ignore[k] = true; end; end;

function SM:IgnoreThemeSettings()
    self:SetIgnoreIndexes({ "BackgroundColor", "SidebarColor", "MainColor", "WellColor", "RaisedColor", "OutlineColor", "AccentColor", "AccentColor2", "FontColor", "MutedColor", "FontFace", "ThemeManager_ThemeList", "ThemeManager_CustomThemeList", "ThemeManager_CustomThemeName" });
end;

function SM:Dir()
    local d = self.Folder .. "/settings";
    if self.SubFolder ~= "" then d = d .. "/" .. self.SubFolder; end;
    return d;
end;

function SM:BuildFolderTree()
    local cur = "";
    for part in self:Dir():gmatch("[^/]+") do
        cur = cur == "" and part or (cur .. "/" .. part);
        if not isfolder(cur) then makefolder(cur); end;
    end;
end;

function SM:Serialize()
    local L = self.Library;
    local d = { objects = {} };
    for i, o in next, L.Toggles do
        if not self.Ignore[i] and self.Parser[o.Type] then d.objects[#d.objects + 1] = self.Parser[o.Type].Save(i, o); end;
    end;
    for i, o in next, L.Options do
        if not self.Ignore[i] and self.Parser[o.Type] then d.objects[#d.objects + 1] = self.Parser[o.Type].Save(i, o); end;
    end;
    return HS:JSONEncode(d);
end;

function SM:Apply(d)
    self.Loading = true;
    for _, o in ipairs(d.objects or {}) do
        if o.idx and not self.Ignore[o.idx] and self.Parser[o.type] then
            pcall(self.Parser[o.type].Load, o.idx, o);
        end;
    end;
    task.delay(.2, function() self.Loading = false; end);
end;

function SM:Export()
    local j = self:Serialize();
    if setclipboard then pcall(setclipboard, j); return true, j; end;
    return false, j;
end;

function SM:Import(j)
    local ok, d = pcall(function() return HS:JSONDecode(j); end);
    if not ok or type(d) ~= "table" or type(d.objects) ~= "table" then return false, "bad json"; end;
    self:Apply(d);
    return true;
end;

function SM:Save(n)
    if not n or n:gsub(" ", "") == "" then return false, "no config name"; end;
    self:BuildFolderTree();
    local ok, e = pcall(function() writefile(self:Dir() .. "/" .. n .. ".json", self:Serialize()); end);
    if not ok then return false, tostring(e); end;
    return true;
end;

function SM:Load(n)
    if not n then return false, "no config selected"; end;
    local p = self:Dir() .. "/" .. n .. ".json";
    if not isfile(p) then return false, "missing file"; end;
    local ok, d = pcall(function() return HS:JSONDecode(readfile(p)); end);
    if not ok or type(d) ~= "table" then return false, "bad json"; end;
    self:Apply(d);
    return true;
end;

function SM:Delete(n)
    local p = self:Dir() .. "/" .. n .. ".json";
    if isfile(p) then delfile(p); return true; end;
    return false;
end;

function SM:RefreshConfigList()
    self:BuildFolderTree();
    local out = {};
    for _, f in ipairs(listfiles(self:Dir())) do
        local n = f:match("([^/\\]+)%.json$");
        if n then out[#out + 1] = n; end;
    end;
    table.sort(out);
    return out;
end;

function SM:GetAutoloadConfig()
    local p = self:Dir() .. "/autoload.txt";
    return isfile(p) and readfile(p) or nil;
end;

function SM:SaveAutoloadConfig(n) self:BuildFolderTree(); writefile(self:Dir() .. "/autoload.txt", n); end;

function SM:DeleteAutoLoadConfig()
    local p = self:Dir() .. "/autoload.txt";
    if isfile(p) then delfile(p); end;
end;

function SM:LoadAutoloadConfig()
    local n = self:GetAutoloadConfig();
    if not n then return; end;
    local ok, e = self:Load(n);
    local L = self.Library;
    if ok then L:Notify({ Title = "Configs", Description = "Autoloaded config " .. n, Time = 3, Type = "Success" });
    else L:Notify({ Title = "Configs", Description = "Autoload failed: " .. tostring(e), Time = 4, Type = "Error" }); end;
end;

function SM:BuildConfigSection(tab)
    local L = self.Library;
    local O = L.Options;
    local g = tab:AddRightGroupbox("Configuration", "save");
    g:AddInput("SaveManager_ConfigName", { Text = "Config name", Placeholder = "My config" });
    g:AddButton("Create config", function()
        local n = O.SaveManager_ConfigName.Value;
        local ok, e = self:Save(n);
        if ok then
            O.SaveManager_ConfigList:SetValues(self:RefreshConfigList());
            O.SaveManager_ConfigList:SetValue(n);
            L:Notify({ Title = "Configs", Description = "Created config " .. n, Time = 3, Type = "Success" });
        else
            L:Notify({ Title = "Configs", Description = "Could not save: " .. tostring(e), Time = 3, Type = "Warn" });
        end;
    end);
    g:AddDivider();
    g:AddDropdown("SaveManager_ConfigList", { Text = "Config list", Values = self:RefreshConfigList(), AllowNull = true });
    g:AddButton("Load config", function()
        local n = O.SaveManager_ConfigList.Value;
        local ok, e = self:Load(n);
        L:Notify({ Title = "Configs", Description = ok and ("Loaded config " .. n) or ("Could not load: " .. tostring(e)), Time = 3, Type = ok and "Success" or "Warn" });
    end):AddButton("Overwrite", function()
        local n = O.SaveManager_ConfigList.Value;
        local ok, e = self:Save(n);
        L:Notify({ Title = "Configs", Description = ok and ("Overwrote config " .. n) or ("Could not save: " .. tostring(e)), Time = 3, Type = ok and "Success" or "Warn" });
    end);
    g:AddButton({ Text = "Delete config", Risky = true, HoldToConfirm = .8, Func = function()
        local n = O.SaveManager_ConfigList.Value;
        if n and self:Delete(n) then
            O.SaveManager_ConfigList:SetValues(self:RefreshConfigList());
            O.SaveManager_ConfigList:SetValue(nil);
            L:Notify({ Title = "Configs", Description = "Deleted config " .. n, Time = 3 });
        end;
    end }):AddButton("Refresh", function()
        O.SaveManager_ConfigList:SetValues(self:RefreshConfigList());
    end);
    local al = g:AddLabel("Autoload: " .. (self:GetAutoloadConfig() or "none"), true);
    g:AddButton("Set as autoload", function()
        local n = O.SaveManager_ConfigList.Value;
        if not n then return; end;
        self:SaveAutoloadConfig(n);
        al:SetText("Autoload: " .. n);
        L:Notify({ Title = "Configs", Description = n .. " will load automatically", Time = 3 });
    end):AddButton("Reset", function()
        self:DeleteAutoLoadConfig();
        al:SetText("Autoload: none");
    end);
    g:AddDivider();
    g:AddToggle("SaveManager_Autosave", { Text = "Autosave", Default = false });
    local atok = 0;
    L:OnAnyChanged(function()
        if self.Loading or not (L.Toggles.SaveManager_Autosave and L.Toggles.SaveManager_Autosave.Value) then return; end;
        local n = O.SaveManager_ConfigList.Value;
        if not n then return; end;
        atok += 1;
        local my = atok;
        task.delay(1.5, function() if my == atok and not self.Loading then self:Save(n); end; end);
    end);
    g:AddButton("Export", function()
        local ok = self:Export();
        L:Notify({ Title = "Configs", Description = ok and "Config copied to clipboard" or "Clipboard is not available here", Time = 3, Type = ok and "Success" or "Warn" });
    end):AddButton("Import", function()
        local ok, e = self:Import(O.SaveManager_ImportBox.Value);
        L:Notify({ Title = "Configs", Description = ok and "Config imported" or ("Could not import: " .. tostring(e)), Time = 3, Type = ok and "Success" or "Warn" });
    end);
    g:AddInput("SaveManager_ImportBox", { Text = "Import JSON", Placeholder = "Paste JSON", Finished = true });
    self:SetIgnoreIndexes({ "SaveManager_ConfigList", "SaveManager_ConfigName", "SaveManager_Autosave", "SaveManager_ImportBox" });
    return g;
end;

return SM;
