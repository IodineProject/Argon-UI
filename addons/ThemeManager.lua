local HS = game:GetService("HttpService");

local TM = { Folder = "Argon", Library = nil, DefaultTheme = "Argon" };

local Keys = { "BackgroundColor", "SidebarColor", "MainColor", "WellColor", "RaisedColor", "OutlineColor", "AccentColor", "AccentColor2", "FontColor", "MutedColor" };
local Shown = { { "AccentColor", "Accent" }, { "AccentColor2", "Accent glow" }, { "BackgroundColor", "Background" }, { "MainColor", "Panels" }, { "OutlineColor", "Outline" }, { "FontColor", "Text" } };
local Fonts = { Accanthis = "AccanthisADFStd", ["Amatic SC"] = "AmaticSC", Arial = "Arial", Arimo = "Arimo", Balthazar = "Balthazar", Bangers = "Bangers", BuilderSans = "BuilderSans", ["Comic Neue"] = "ComicNeueAngular", Creepster = "Creepster", ["Denk One"] = "DenkOne", Fondamento = "Fondamento", ["Fredoka One"] = "FredokaOne", Gotham = "GothamSSm", ["Grenze Gotisch"] = "GrenzeGotisch", Guru = "Guru", ["Highway Gothic"] = "HighwayGothic", Inconsolata = "Inconsolata", ["Indie Flower"] = "IndieFlower", ["Josefin Sans"] = "JosefinSans", Jura = "Jura", Kalam = "Kalam", ["Legacy Arial"] = "LegacyArial", ["Luckiest Guy"] = "LuckiestGuy", Merriweather = "Merriweather", Michroma = "Michroma", Montserrat = "Montserrat", Nunito = "Nunito", Oswald = "Oswald", ["Patrick Hand"] = "PatrickHand", ["Permanent Marker"] = "PermanentMarker", ["Press Start 2P"] = "PressStart2P", Roboto = "Roboto", ["Roboto Condensed"] = "RobotoCondensed", ["Roboto Mono"] = "RobotoMono", ["Roman Antique"] = "RomanAntique", Sarpanch = "Sarpanch", ["Source Sans Pro"] = "SourceSansPro", ["Special Elite"] = "SpecialElite", ["Titillium Web"] = "TitilliumWeb", Ubuntu = "Ubuntu", Zekton = "Zekton" };

local function rgb(r, g, b) return Color3.fromRGB(r, g, b); end;
local function theme(bg, side, main, well, raised, out, a1, a2, font, muted)
    return { BackgroundColor = bg, SidebarColor = side, MainColor = main, WellColor = well, RaisedColor = raised, OutlineColor = out, AccentColor = a1, AccentColor2 = a2, FontColor = font, MutedColor = muted };
end;

TM.BuiltInThemes = {
    Argon = { 1, theme(rgb(14, 11, 21), rgb(18, 14, 26), rgb(22, 18, 31), rgb(11, 9, 17), rgb(30, 24, 41), rgb(43, 35, 58), rgb(176, 146, 255), rgb(108, 76, 255), rgb(242, 238, 255), rgb(141, 131, 166)) },
    Neon = { 2, theme(rgb(18, 10, 10), rgb(23, 13, 13), rgb(28, 16, 16), rgb(13, 7, 7), rgb(38, 22, 21), rgb(58, 33, 31), rgb(255, 112, 70), rgb(255, 46, 92), rgb(255, 240, 236), rgb(171, 135, 128)) },
    Krypton = { 3, theme(rgb(12, 13, 17), rgb(16, 17, 22), rgb(20, 21, 27), rgb(9, 10, 13), rgb(28, 30, 37), rgb(44, 47, 58), rgb(214, 220, 240), rgb(150, 162, 204), rgb(240, 242, 248), rgb(132, 137, 155)) },
    Xenon = { 4, theme(rgb(9, 11, 20), rgb(12, 15, 26), rgb(15, 19, 32), rgb(7, 9, 16), rgb(21, 27, 44), rgb(33, 42, 66), rgb(112, 176, 255), rgb(84, 96, 255), rgb(236, 243, 255), rgb(124, 138, 168)) },
    Helium = { 5, theme(rgb(17, 12, 10), rgb(22, 16, 13), rgb(27, 20, 16), rgb(13, 9, 7), rgb(37, 27, 22), rgb(57, 42, 34), rgb(255, 190, 128), rgb(255, 120, 96), rgb(255, 245, 236), rgb(170, 146, 128)) },
    Radon = { 6, theme(rgb(16, 8, 11), rgb(21, 11, 14), rgb(26, 13, 18), rgb(12, 6, 8), rgb(36, 18, 24), rgb(56, 28, 37), rgb(255, 84, 112), rgb(190, 30, 72), rgb(255, 236, 240), rgb(168, 126, 137)) },
};

function TM:SetLibrary(l) self.Library = l; end;
function TM:SetFolder(f) self.Folder = f; self:BuildFolderTree(); end;

function TM:BuildFolderTree()
    local cur = "";
    for part in (self.Folder .. "/themes"):gmatch("[^/]+") do
        cur = cur == "" and part or (cur .. "/" .. part);
        if not isfolder(cur) then makefolder(cur); end;
    end;
end;

function TM:Path(n) return self.Folder .. "/themes/" .. n .. ".json"; end;

function TM:ThemeUpdate()
    local L = self.Library;
    local O = L.Options;
    for _, k in ipairs(Keys) do if O[k] and O[k].Value then L.Scheme[k] = O[k].Value; end; end;
    L:UpdateColorsUsingRegistry();
end;

function TM:ApplyScheme(t)
    local L = self.Library;
    for k, v in next, t do
        if typeof(v) == "Color3" then
            L.Scheme[k] = v;
            if L.Options[k] then L.Options[k]:SetValueRGB(v); end;
        end;
    end;
    if t.FontName and Fonts[t.FontName] then
        L.Scheme.Font = Font.new("rbxasset://fonts/families/" .. Fonts[t.FontName] .. ".json", Enum.FontWeight.Medium);
        if L.Options.FontFace then L.Options.FontFace:SetValue(t.FontName); end;
    end;
    L:UpdateColorsUsingRegistry();
end;

function TM:GetCustomTheme(n)
    local p = self:Path(n);
    if not isfile(p) then return nil; end;
    local ok, d = pcall(function() return HS:JSONDecode(readfile(p)); end);
    if not ok or type(d) ~= "table" then return nil; end;
    local t = {};
    for k, v in next, d do t[k] = (type(v) == "string" and v:match("^%x%x%x%x%x%x$")) and Color3.fromHex(v) or v; end;
    return t;
end;

function TM:ApplyTheme(n)
    local b = self.BuiltInThemes[n];
    local t = b and b[2] or self:GetCustomTheme(n);
    if not t then return false; end;
    self:ApplyScheme(t);
    return true;
end;

function TM:SaveCustomTheme(n)
    if not n or n:gsub(" ", "") == "" then return false, "no name"; end;
    self:BuildFolderTree();
    local d = {};
    for _, k in ipairs(Keys) do d[k] = self.Library.Scheme[k]:ToHex(); end;
    d.FontName = self.Library.Options.FontFace and self.Library.Options.FontFace.Value or "BuilderSans";
    writefile(self:Path(n), HS:JSONEncode(d));
    return true;
end;

function TM:Delete(n)
    local p = self:Path(n);
    if isfile(p) then delfile(p); return true; end;
    return false;
end;

function TM:ReloadCustomThemes()
    self:BuildFolderTree();
    local out = {};
    for _, f in ipairs(listfiles(self.Folder .. "/themes")) do
        local n = f:match("([^/\\]+)%.json$");
        if n then out[#out + 1] = n; end;
    end;
    table.sort(out);
    return out;
end;

function TM:SaveDefault(n) self:BuildFolderTree(); writefile(self.Folder .. "/themes/default.txt", n); end;

function TM:LoadDefault()
    local p = self.Folder .. "/themes/default.txt";
    local n = isfile(p) and readfile(p) or self.DefaultTheme;
    if not self:ApplyTheme(n) then self:ApplyTheme(self.DefaultTheme); n = self.DefaultTheme; end;
    local O = self.Library.Options;
    if O.ThemeManager_ThemeList and self.BuiltInThemes[n] then O.ThemeManager_ThemeList:SetValue(n); end;
end;

function TM:CreateThemeManager(g)
    local L = self.Library;
    local O = L.Options;
    for _, s in ipairs(Shown) do
        g:AddLabel(s[2]):AddColorPicker(s[1], { Default = L.Scheme[s[1]], Title = s[2] });
    end;
    g:AddDropdown("FontFace", { Text = "Font", Values = (function() local t = {}; for k in next, Fonts do t[#t + 1] = k; end; table.sort(t); return t; end)(), Default = "BuilderSans", Searchable = true });
    local names = {};
    for k, v in next, self.BuiltInThemes do names[v[1]] = k; end;
    g:AddDivider();
    g:AddDropdown("ThemeManager_ThemeList", { Text = "Theme", Values = names, Default = 1 });
    g:AddButton("Set as default", function()
        self:SaveDefault(O.ThemeManager_ThemeList.Value);
        L:Notify({ Title = "Themes", Description = "Default theme set to " .. O.ThemeManager_ThemeList.Value, Time = 3 });
    end);
    O.ThemeManager_ThemeList:OnChanged(function(v) if v then self:ApplyTheme(v); end; end);
    g:AddDivider();
    g:AddInput("ThemeManager_CustomThemeName", { Text = "Custom theme name", Placeholder = "My theme" });
    g:AddButton("Create theme", function()
        local n = O.ThemeManager_CustomThemeName.Value;
        if self:SaveCustomTheme(n) then
            O.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes());
            O.ThemeManager_CustomThemeList:SetValue(n);
            L:Notify({ Title = "Themes", Description = "Saved theme " .. n, Time = 3 });
        else
            L:Notify({ Title = "Themes", Description = "Give the theme a name first", Time = 3, Type = "Warn" });
        end;
    end);
    g:AddDropdown("ThemeManager_CustomThemeList", { Text = "Custom themes", Values = self:ReloadCustomThemes(), AllowNull = true });
    g:AddButton("Load theme", function()
        local n = O.ThemeManager_CustomThemeList.Value;
        if n and self:ApplyTheme(n) then L:Notify({ Title = "Themes", Description = "Loaded theme " .. n, Time = 3 }); end;
    end):AddButton("Overwrite", function()
        local n = O.ThemeManager_CustomThemeList.Value;
        if n and self:SaveCustomTheme(n) then L:Notify({ Title = "Themes", Description = "Overwrote theme " .. n, Time = 3 }); end;
    end);
    g:AddButton({ Text = "Delete theme", Risky = true, HoldToConfirm = .8, Func = function()
        local n = O.ThemeManager_CustomThemeList.Value;
        if n and self:Delete(n) then
            O.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes());
            O.ThemeManager_CustomThemeList:SetValue(nil);
            L:Notify({ Title = "Themes", Description = "Deleted theme " .. n, Time = 3 });
        end;
    end }):AddButton("Refresh", function()
        O.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes());
    end);
    g:AddButton("Set custom as default", function()
        local n = O.ThemeManager_CustomThemeList.Value;
        if n then self:SaveDefault(n); L:Notify({ Title = "Themes", Description = "Default theme set to " .. n, Time = 3 }); end;
    end);
    for _, k in ipairs(Keys) do if O[k] then O[k]:OnChanged(function() self:ThemeUpdate(); end); end; end;
    O.FontFace:OnChanged(function(v)
        if v and Fonts[v] then
            L.Scheme.Font = Font.new("rbxasset://fonts/families/" .. Fonts[v] .. ".json", Enum.FontWeight.Medium);
            L:UpdateColorsUsingRegistry();
        end;
    end);
    self:LoadDefault();
end;

function TM:CreateGroupBox(tab) return tab:AddLeftGroupbox("Themes", "palette"); end;
function TM:ApplyToTab(tab) self:CreateThemeManager(self:CreateGroupBox(tab)); end;
function TM:ApplyToGroupbox(g) self:CreateThemeManager(g); end;

return TM;
