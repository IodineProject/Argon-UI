loadstring([[
    function LPH_NO_VIRTUALIZE(f) return f end;
]])();

local cr = cloneref or function(o) return o; end;
local function sv(n) return cr(game:GetService(n)); end;
local Plrs, UIS, RS, TS, HS, Teams, GS = sv("Players"), sv("UserInputService"), sv("RunService"), sv("TweenService"), sv("HttpService"), sv("Teams"), sv("GuiService");
local LP = Plrs.LocalPlayer;
local AD, AI;
local Late = {};

local Library = {
    Version = "0.2.0",
    Folder = "Argon",
    Options = {},
    Toggles = {},
    Labels = {},
    Buttons = {},
    Registry = {},
    Signals = {},
    UnloadCallbacks = {},
    Windows = {},
    Toggled = false,
    Unloaded = false,
    NotifySide = "Right",
    DPIScale = 1,
    ForceCheckbox = false,
    ShowToggleFrameInKeybinds = true,
    ToggleKeybind = nil,
    Scheme = {
        BackgroundColor = Color3.fromRGB(14, 11, 21),
        SidebarColor = Color3.fromRGB(18, 14, 26),
        MainColor = Color3.fromRGB(22, 18, 31),
        WellColor = Color3.fromRGB(11, 9, 17),
        RaisedColor = Color3.fromRGB(30, 24, 41),
        OutlineColor = Color3.fromRGB(43, 35, 58),
        AccentColor = Color3.fromRGB(176, 146, 255),
        AccentColor2 = Color3.fromRGB(108, 76, 255),
        FontColor = Color3.fromRGB(242, 238, 255),
        MutedColor = Color3.fromRGB(141, 131, 166),
        RedColor = Color3.fromRGB(255, 92, 138),
        WarnColor = Color3.fromRGB(255, 192, 97),
        GoodColor = Color3.fromRGB(92, 227, 162),
        Font = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Medium),
        DisplayFont = Font.new("rbxasset://fonts/families/Michroma.json"),
    },
};
local S = Library.Scheme;
pcall(function() getgenv().Toggles = Library.Toggles; getgenv().Options = Library.Options; end);

local V2, U2, C3 = Vector2.new, UDim2.new, Color3.new;
local UO, US = UDim2.fromOffset, UDim2.fromScale;
local EIT = Enum.UserInputType;
local function mpos(i) return V2(i.Position.X, i.Position.Y); end;
local function nkp(t, v) return NumberSequenceKeypoint.new(t, v); end;
local function ns(...) local a = { ... }; local k = {}; for i = 1, #a, 2 do k[#k + 1] = nkp(a[i], a[i + 1]); end; return NumberSequence.new(k); end;

local function con(sig, f) local c = sig:Connect(f); Library.Signals[#Library.Signals + 1] = c; return c; end;
function Library:GiveSignal(c) self.Signals[#self.Signals + 1] = c; return c; end;

local function tw(o, t, p, st, dr)
    local x = TS:Create(o, TweenInfo.new(t, st or Enum.EasingStyle.Quint, dr or Enum.EasingDirection.Out), p);
    x:Play();
    return x;
end;

local function mk(c, p)
    local o = Instance.new(c);
    local par;
    for k, v in next, p do
        if k == "Parent" then par = v; elseif type(k) == "number" then v.Parent = o; else o[k] = v; end;
    end;
    if par then o.Parent = par; end;
    return o;
end;

local function reg(o, m)
    local r = Library.Registry[o] or {};
    for k, v in next, m do
        r[k] = v;
        if type(v) == "function" then o[k] = v(); else o[k] = S[v]; end;
    end;
    Library.Registry[o] = r;
    return o;
end;

local function setk(o, p, k, t)
    local r = Library.Registry[o] or {};
    r[p] = k;
    Library.Registry[o] = r;
    local v = type(k) == "function" and k() or S[k];
    if t and t > 0 then tw(o, t, { [p] = v }); else o[p] = v; end;
end;

function Library:AddToRegistry(o, m) return reg(o, m); end;
function Library:RemoveFromRegistry(o) self.Registry[o] = nil; end;
function Library:UpdateColorsUsingRegistry()
    for o, m in next, self.Registry do
        if o.Parent then
            for k, v in next, m do
                local ok = pcall(function() o[k] = type(v) == "function" and v() or S[v]; end);
                if not ok then self.Registry[o] = nil; break; end;
            end;
        else
            self.Registry[o] = nil;
        end;
    end;
end;
Library.UpdateColors = Library.UpdateColorsUsingRegistry;

local function fw(w) return function() return Font.new(S.Font.Family, w); end; end;
local function fdisp() return S.DisplayFont; end;
local function acs() return ColorSequence.new(S.AccentColor, S.AccentColor2); end;
local FM, FB, FS = fw(Enum.FontWeight.Medium), fw(Enum.FontWeight.Bold), fw(Enum.FontWeight.SemiBold);

local function fr(p) p.BorderSizePixel = 0; return mk("Frame", p); end;
local function rc(o, r) return mk("UICorner", { CornerRadius = UDim.new(0, r), Parent = o }); end;
local function st(o, k, tr, th) return reg(mk("UIStroke", { Transparency = tr or 0, Thickness = th or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = o }), { Color = k or "OutlineColor" }); end;
local function pd(o, l, r, t, b) return mk("UIPadding", { PaddingLeft = UDim.new(0, l), PaddingRight = UDim.new(0, r or l), PaddingTop = UDim.new(0, t or l), PaddingBottom = UDim.new(0, b or t or l), Parent = o }); end;
local function ls(o, p, h, ha, va)
    return mk("UIListLayout", { Padding = UDim.new(0, p or 0), FillDirection = h and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical, SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = ha or Enum.HorizontalAlignment.Left, VerticalAlignment = va or Enum.VerticalAlignment.Top, Parent = o });
end;
local function gloss(o, b) return mk("UIGradient", { Rotation = 90, Color = ColorSequence.new(C3(1, 1, 1), Color3.fromRGB(b or 214, b or 214, b or 214)), Parent = o }); end;
local function tl(p, f)
    p.BackgroundTransparency = 1;
    p.BorderSizePixel = 0;
    p.TextSize = p.TextSize or 14;
    p.TextXAlignment = p.TextXAlignment or Enum.TextXAlignment.Left;
    p.RichText = p.RichText ~= false;
    local o = mk(p.ClassName or "TextLabel", (function() p.ClassName = nil; return p; end)());
    reg(o, { FontFace = f or FM });
    if not (Library.Registry[o] or {}).TextColor3 then reg(o, { TextColor3 = "FontColor" }); end;
    return o;
end;

local function b64d(s)
    local f = (crypt and crypt.base64 and crypt.base64.decode) or (crypt and crypt.base64decode) or base64_decode or base64decode;
    if f then local ok, r = pcall(f, s); if ok and type(r) == "string" and #r > 0 then return r; end; end;
    local al = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    local m = {};
    for i = 1, 64 do m[al:byte(i)] = i - 1; end;
    local o, n, bits, cnt = {}, 0, 0, 0;
    for i = 1, #s do
        local v = m[s:byte(i)];
        if v then
            bits = bits * 64 + v;
            cnt += 6;
            if cnt >= 8 then
                cnt -= 8;
                local b = math.floor(bits / 2 ^ cnt);
                bits = bits % 2 ^ cnt;
                n += 1;
                o[n] = string.char(b);
            end;
        end;
    end;
    return table.concat(o);
end;

local function mkdirs(p)
    local cur = "";
    for part in p:gmatch("[^/]+") do
        cur = cur == "" and part or (cur .. "/" .. part);
        if not isfolder(cur) then makefolder(cur); end;
    end;
end;

local AC = {};
local function asset(n)
    local c = AC[n];
    if c then return c; end;
    local id = "";
    if AD and AD[n] and writefile and getcustomasset and isfile then
        pcall(function()
            local d = Library.Folder .. "/assets";
            mkdirs(d);
            local p = d .. "/" .. n .. "_" .. AD.v .. ".png";
            if not isfile(p) then
                writefile(p, b64d(AD[n]));
                pcall(function()
                    for _, f in ipairs(listfiles(d)) do
                        local nm = f:match("([^/\\]+)$");
                        if nm and nm:match("^" .. n .. "_%x+%.png$") and nm ~= n .. "_" .. AD.v .. ".png" then delfile(f); end;
                    end;
                end);
            end;
            id = getcustomasset(p);
        end);
    end;
    AC[n] = id;
    return id;
end;
Library.GetAsset = function(_, n) return asset(n); end;

function Library:GetIcon(n)
    if type(n) == "number" then return { Url = "rbxassetid://" .. n, ImageRectOffset = Vector2.zero, ImageRectSize = Vector2.zero }; end;
    if type(n) ~= "string" then return nil; end;
    if n:find("rbxasset") or n:find("http") then return { Url = n, ImageRectOffset = Vector2.zero, ImageRectSize = Vector2.zero }; end;
    local i = AI and AI[n];
    if not i then return nil; end;
    local u = asset("Icons");
    if u == "" then return nil; end;
    return { Url = u, ImageRectOffset = V2((i % 12) * 48, math.floor(i / 12) * 48), ImageRectSize = V2(48, 48) };
end;

local function ic(par, n, sz, key, p)
    local d = Library:GetIcon(n);
    local o = mk("ImageLabel", { BackgroundTransparency = 1, Size = UO(sz, sz), Image = d and d.Url or "", ImageRectOffset = d and d.ImageRectOffset or Vector2.zero, ImageRectSize = d and d.ImageRectSize or Vector2.zero, ScaleType = Enum.ScaleType.Fit, Parent = par });
    if p then for k, v in next, p do o[k] = v; end; end;
    reg(o, { ImageColor3 = key or "MutedColor" });
    return o, d ~= nil;
end;

local function img(par, n, p, key)
    local o = mk("ImageLabel", { BackgroundTransparency = 1, Image = asset(n), Parent = par });
    for k, v in next, p do o[k] = v; end;
    if key then reg(o, { ImageColor3 = key }); end;
    return o;
end;

local function deny(o, s)
    if s then setk(s, "Color", "RedColor", .06); task.delay(.35, function() setk(s, "Color", "OutlineColor", .25); end); end;
    local u = o:FindFirstChildOfClass("UIScale") or mk("UIScale", { Parent = o });
    u.Scale = .97;
    tw(u, .3, { Scale = 1 });
end;
Library.Deny = function(_, o, s) deny(o, s); end;

local errT = 0;
function Library:SafeCallback(f, ...)
    if type(f) ~= "function" then return true; end;
    local ok, e = pcall(f, ...);
    if not ok then
        warn("[Argon] callback error: " .. tostring(e));
        if Library.NotifyOnError ~= false and os.clock() - errT > 2 then
            errT = os.clock();
            task.defer(function() Library:Notify({ Title = "Callback error", Description = tostring(e):sub(1, 160), Time = 5, Type = "Error" }); end);
        end;
    end;
    return ok;
end;

Library.ChangeHooks = {};
function Library:OnAnyChanged(f) self.ChangeHooks[#self.ChangeHooks + 1] = f; end;
function Library:_bump() for _, f in ipairs(self.ChangeHooks) do task.spawn(f); end; end;

local SG = mk("ScreenGui", { Name = HS:GenerateGUID(false), ZIndexBehavior = Enum.ZIndexBehavior.Sibling, ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 999 });
pcall(function() if protectgui then protectgui(SG); end; end);
SG.Parent = (gethui and gethui()) or sv("CoreGui");
Library.ScreenGui = SG;
local Modal = mk("TextButton", { Text = "", Modal = true, BackgroundTransparency = 1, Size = UO(1, 1), Position = UO(-4, -4), Visible = false, Parent = SG });
Library.UnlockMouseWhileOpen = true;
local Scales = {};
local function scl(o) local u = mk("UIScale", { Scale = Library.DPIScale, Parent = o }); Scales[#Scales + 1] = u; return u; end;

function Library:SetDPIScale(v)
    v = tonumber(v) or 100;
    if v > 4 then v /= 100; end;
    self._dpiWant = v;
    local ss, top = SG.AbsoluteSize, -SG.AbsolutePosition.Y;
    for _, w in ipairs(self.Windows) do
        local z = w.Holder.Size;
        local h = w._fullH and w._fullH() or z.Y.Offset;
        if ss.X > 0 and z.X.Offset > 0 and h > 0 then v = math.min(v, (ss.X - 16) / z.X.Offset, (ss.Y - top - 16) / h); end;
    end;
    v = math.max(v, .5);
    self.DPIScale = v;
    for _, u in ipairs(Scales) do u.Scale = v; end;
    if self._nfit then self._nfit(); end;
    task.defer(function() for _, w in ipairs(self.Windows) do if w._inside then w._inside(); end; end; end);
end;
con(SG:GetPropertyChangedSignal("AbsoluteSize"), function()
    if Library._nfit then Library._nfit(); end;
    if #Library.Windows > 0 then Library:SetDPIScale(Library._dpiWant or Library.DPIScale); end;
end);

local Tip = fr({ Name = "Tooltip", AutomaticSize = Enum.AutomaticSize.XY, Size = UO(0, 0), Visible = false, ZIndex = 200, Parent = SG });
reg(Tip, { BackgroundColor3 = "MainColor" }); rc(Tip, 6); st(Tip); pd(Tip, 8, 8, 5, 5); scl(Tip);
local TipL = tl({ Text = "", TextSize = 13, AutomaticSize = Enum.AutomaticSize.XY, Size = UO(0, 0), ZIndex = 201, Parent = Tip });
mk("UISizeConstraint", { MaxSize = V2(260, 999), Parent = TipL }).Parent = TipL;
TipL.TextWrapped = true;
local tipTok = 0;
local tipMove;

local tipPos = LPH_NO_VIRTUALIZE(function(p)
    local ss, ts = SG.AbsoluteSize, Tip.AbsoluteSize;
    local x, y = p.X + 14, p.Y + 10;
    if x + ts.X > ss.X - 4 then x = p.X - 10 - ts.X; end;
    if y + ts.Y > ss.Y - 4 then y = p.Y - 6 - ts.Y; end;
    Tip.Position = UO(math.max(x, 4), math.max(y, 4));
end);
local function tipShow(t)
    TipL.Text = t;
    tipPos(UIS:GetMouseLocation());
    Tip.Visible = true;
    task.defer(function() if Tip.Visible then tipPos(UIS:GetMouseLocation()); end; end);
end;
local function tipHide()
    tipTok += 1;
    Tip.Visible = false;
    if tipMove then tipMove:Disconnect(); tipMove = nil; end;
end;

function Library:AddTooltip(info, dis, obj, el)
    if not info and not dis then return; end;
    local function txt() return (el and el.Disabled and dis) or info; end;
    con(obj.MouseEnter, function()
        local t = txt();
        if not t or Library.Unloaded then return; end;
        tipTok += 1;
        local my = tipTok;
        task.delay(.35, function()
            if my ~= tipTok then return; end;
            tipShow(t);
            if tipMove then tipMove:Disconnect(); end;
            tipMove = UIS.InputChanged:Connect(LPH_NO_VIRTUALIZE(function(i)
                if i.UserInputType == EIT.MouseMovement then tipPos(UIS:GetMouseLocation()); end;
            end));
        end);
    end);
    con(obj.MouseLeave, tipHide);
end;

function Library:_tipNow(t)
    if not t then return; end;
    tipTok += 1;
    local my = tipTok;
    tipShow(t);
    task.delay(1.6, function() if my == tipTok then Tip.Visible = false; end; end);
end;

local NotifHold = fr({ Name = "Notifications", BackgroundTransparency = 1, Size = U2(0, 320, 1, -24), Position = U2(1, -12, 0, 12), AnchorPoint = V2(1, 0), ZIndex = 150, Parent = SG });
ls(NotifHold, 8, false, Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Bottom);
scl(NotifHold);
Library._nfit = function() NotifHold.Size = U2(0, 320, 0, math.max(SG.AbsoluteSize.Y - 24, 0) / Library.DPIScale); end;
Library._nfit();

function Library:SetNotifySide(s)
    self.NotifySide = s;
    local r = s ~= "Left";
    NotifHold.AnchorPoint = V2(r and 1 or 0, 0);
    NotifHold.Position = U2(r and 1 or 0, r and -12 or 12, 0, 12);
    NotifHold:FindFirstChildOfClass("UIListLayout").HorizontalAlignment = r and Enum.HorizontalAlignment.Right or Enum.HorizontalAlignment.Left;
end;

local Notifs = {};
function Library:Notify(info, tm)
    if type(info) == "string" then info = { Description = info, Time = tm }; end;
    info = info or {};
    local N = { Title = info.Title, Description = info.Description or "", Time = info.Time or 5, Destroyed = false };
    local r = self.NotifySide ~= "Left";
    local key = info.Type == "Warn" and "WarnColor" or info.Type == "Error" and "RedColor" or info.Type == "Success" and "GoodColor" or "AccentColor";
    local slot = fr({ BackgroundTransparency = 1, Size = U2(0, 300, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, ClipsDescendants = false, Parent = NotifHold });
    local card = fr({ Active = true, Size = U2(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Position = UO(r and 340 or -340, 0), Parent = slot });
    reg(card, { BackgroundColor3 = "MainColor" }); rc(card, 8); st(card); gloss(card);
    local tube = fr({ Size = U2(1, -24, 0, 2), Position = U2(.5, 0, 1, 0), AnchorPoint = V2(.5, 1), ZIndex = 2, Parent = card });
    reg(tube, { BackgroundColor3 = key }); rc(tube, 1);
    mk("UIGradient", { Transparency = ns(0, 1, .22, 0, .78, 0, 1, 1), Parent = tube });
    local body = fr({ BackgroundTransparency = 1, Size = U2(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = card });
    pd(body, 14, 14, 10, 13); ls(body, 3);
    local tt;
    if N.Title then tt = tl({ Text = N.Title, TextSize = 14, Size = U2(1, 0, 0, 16), LayoutOrder = 1, Parent = body }, FB); end;
    local dd = tl({ Text = N.Description, TextSize = 13, Size = U2(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, TextWrapped = true, LayoutOrder = 2, Parent = body });
    reg(dd, { TextColor3 = N.Title and "MutedColor" or "FontColor" });
    tw(card, .38, { Position = UO(0, 0) });
    tube.BackgroundTransparency = 1;
    tw(tube, .45, { BackgroundTransparency = 0 }, Enum.EasingStyle.Quad);
    function N:ChangeTitle(t) if tt then tt.Text = t; end; end;
    function N:ChangeDescription(t) dd.Text = t; end;
    function N:Destroy()
        if N.Destroyed then return; end;
        N.Destroyed = true;
        local k = table.find(Notifs, N);
        if k then table.remove(Notifs, k); end;
        tw(card, .25, { Position = UO(r and 340 or -340, 0) }, Enum.EasingStyle.Quint, Enum.EasingDirection.In);
        task.delay(.26, function() slot:Destroy(); end);
    end;
    local nb = mk("TextButton", { Text = "", BackgroundTransparency = 1, Size = US(1, 1), ZIndex = 5, Parent = card });
    local dt;
    if typeof(N.Time) == "Instance" then
        local c; c = N.Time.Destroying:Connect(function() c:Disconnect(); N:Destroy(); end);
    elseif not info.Persist then
        dt = tw(tube, N.Time, { Size = U2(0, 0, 0, 2) }, Enum.EasingStyle.Linear);
        dt.Completed:Connect(function(ps) if ps == Enum.PlaybackState.Completed then N:Destroy(); end; end);
    end;
    con(nb.MouseEnter, function() if dt and not N.Destroyed then dt:Pause(); end; end);
    con(nb.MouseLeave, function() if dt and not N.Destroyed then dt:Play(); end; end);
    con(nb.MouseButton1Click, function() if info.Closable ~= false then N:Destroy(); end; end);
    N._keep = info.Persist or typeof(N.Time) == "Instance";
    Notifs[#Notifs + 1] = N;
    if #Notifs > (self.MaxNotifications or 6) then for _, o in ipairs(Notifs) do if not o._keep then o:Destroy(); break; end; end; end;
    return N;
end;

local KBF = fr({ Name = "Keybinds", Active = true, Size = UO(220, 0), AutomaticSize = Enum.AutomaticSize.Y, Position = U2(0, 12, .5, -60), Visible = false, ZIndex = 120, Parent = SG });
reg(KBF, { BackgroundColor3 = "MainColor" }); rc(KBF, 10); st(KBF); gloss(KBF); scl(KBF);
local kbrim = fr({ Size = U2(1, -40, 0, 1), Position = UO(20, 0), ZIndex = 2, Parent = KBF });
reg(kbrim, { BackgroundColor3 = "AccentColor" });
mk("UIGradient", { Transparency = ns(0, 1, .5, .05, 1, 1), Parent = kbrim });
local KBH = fr({ BackgroundTransparency = 1, Size = U2(1, 0, 0, 36), Parent = KBF });
Late[#Late + 1] = function() ic(KBH, "keyboard", 14, "AccentColor", { Position = U2(0, 14, .5, 0), AnchorPoint = V2(0, .5) }); end;
tl({ Text = "Keybinds", TextSize = 13, Position = UO(36, 0), Size = U2(1, -110, 1, 0), Parent = KBH }, FB);
local KBC = tl({ Text = "", TextSize = 12, AnchorPoint = V2(1, 0), Position = U2(1, -14, 0, 0), Size = UO(70, 36), TextXAlignment = Enum.TextXAlignment.Right, Parent = KBH });
reg(KBC, { TextColor3 = "MutedColor" });
local kbdv = fr({ Size = U2(1, -28, 0, 1), Position = UO(14, 36), Parent = KBF });
reg(kbdv, { BackgroundColor3 = "OutlineColor" });
mk("UIGradient", { Transparency = ns(0, 1, .15, 0, .85, 0, 1, 1), Parent = kbdv });
local KBL = fr({ BackgroundTransparency = 1, Position = UO(0, 37), Size = U2(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = KBF });
pd(KBL, 14, 14, 8, 12); ls(KBL, 4);
local KBE = tl({ Text = "No binds", TextSize = 12, Size = U2(1, 0, 0, 20), LayoutOrder = -1, Parent = KBL });
reg(KBE, { TextColor3 = "MutedColor" });
Library.KeybindFrame = KBF;
Library.KeybindContainer = KBL;
Library.KeybindMenu = { SetVisibilityControl = function() end };

local DF;
con(UIS.InputChanged, LPH_NO_VIRTUALIZE(function(i)
    if DF and (i.UserInputType == EIT.MouseMovement or i.UserInputType == EIT.Touch) then DF(i); end;
end));
local function dgo(i, f, done)
    DF = f;
    local c; c = i.Changed:Connect(function()
        if i.UserInputState == Enum.UserInputState.End then c:Disconnect(); if DF == f then DF = nil; end; if done then done(); end; end;
    end);
end;
local function draggable(handle, target, done)
    local st0, pos0;
    local mv = LPH_NO_VIRTUALIZE(function(i)
        local d = i.Position - st0;
        target.Position = U2(pos0.X.Scale, pos0.X.Offset + d.X, pos0.Y.Scale, pos0.Y.Offset + d.Y);
    end);
    con(handle.InputBegan, function(i)
        if i.UserInputType == EIT.MouseButton1 or i.UserInputType == EIT.Touch then
            st0, pos0 = i.Position, target.Position;
            dgo(i, mv, done);
        end;
    end);
end;
draggable(KBH, KBF);

local KeyNames = { LeftShift = "LShift", RightShift = "RShift", LeftControl = "LCtrl", RightControl = "RCtrl", LeftAlt = "LAlt", RightAlt = "RAlt", MouseButton1 = "MB1", MouseButton2 = "MB2", MouseButton3 = "MB3", Return = "Enter", Backspace = "Bksp", CapsLock = "Caps" };
local function kname(k) return KeyNames[k] or k; end;

local Pickers = {};
local function kbc()
    local n, v = 0, 0;
    for k in next, Pickers do
        if not k.NoUI and k.Value ~= "None" and k.Value ~= "" then v += 1; if k:GetState() then n += 1; end; end;
    end;
    KBC.Text = n > 0 and (n .. " active") or "";
    KBE.Visible = v == 0;
end;
local PopClosers = {};
local function closePops(except) for f in next, PopClosers do if f ~= except then f(); end; end; end;
Library.ClosePopups = function() closePops(); end;

local function overUI(o)
    local m = UIS:GetMouseLocation() - GS:GetGuiInset();
    local p, s = o.AbsolutePosition, o.AbsoluteSize;
    return m.X >= p.X and m.X <= p.X + s.X and m.Y >= p.Y and m.Y <= p.Y + s.Y;
end;

local GB = {};
GB.__index = GB;

local function entry(self, row, text, el)
    local t = self.Tab;
    if t then t.Entries[#t.Entries + 1] = { Row = row, Text = (text or ""):lower(), El = el, Box = self.Box }; end;
end;

local function rowf(self, h)
    self.N += 1;
    return fr({ BackgroundTransparency = 1, Size = U2(1, 0, 0, h), LayoutOrder = self.N, Parent = self.Container });
end;

local function vis(el, row) function el:SetVisible(v) el.Visible = v; row.Visible = v; if el._sv then el._sv(v); end; end; if el.Visible == false then row.Visible = false; end; end;

local function addonsHolder(row, right)
    local h = fr({ BackgroundTransparency = 1, Size = U2(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, Position = U2(1, -(right or 0), 0, 0), AnchorPoint = V2(1, 0), ZIndex = 3, Parent = row });
    ls(h, 6, true, Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Center);
    return h;
end;

local mkColorPicker, mkKeyPicker;

local function baseToggle(self, idx, info, isBox)
    info = info or {};
    local T = { Value = info.Default == true, Type = isBox and "Checkbox" or "Toggle", Text = info.Text or idx, Risky = info.Risky, Disabled = info.Disabled == true, Visible = info.Visible ~= false, Callback = info.Callback, Changed = info.Changed, Addons = {}, _win = self.Window };
    local row = rowf(self, 22);
    local btn = mk("TextButton", { Text = "", BackgroundTransparency = 1, Size = US(1, 1), Parent = row, ZIndex = 2 });
    local lab, ad;
    if isBox then
        local box = fr({ Size = UO(18, 18), Position = U2(0, 0, .5, 0), AnchorPoint = V2(0, .5), Parent = row });
        reg(box, { BackgroundColor3 = "WellColor" }); rc(box, 5); local bst = st(box);
        T._dv = { box, bst };
        local fill = fr({ Size = US(1, 1), BackgroundColor3 = C3(1, 1, 1), BackgroundTransparency = 1, Parent = box });
        rc(fill, 5); reg(mk("UIGradient", { Rotation = 45, Parent = fill }), { Color = acs });
        local ck = ic(box, "check", 14, "FontColor", { Position = US(.5, .5), AnchorPoint = V2(.5, .5), ImageTransparency = 1 });
        lab = tl({ Text = T.Text, Position = UO(28, 0), Size = U2(1, -28, 1, 0), Parent = row });
        T._disp = function(a)
            local on = T.Value;
            local t = a and .16 or 0;
            if t > 0 then
                tw(fill, t, { BackgroundTransparency = on and 0 or 1 });
                tw(ck, t, { ImageTransparency = on and 0 or 1 });
                ck.Size = UO(on and 10 or 14, on and 10 or 14);
                tw(ck, .2, { Size = UO(14, 14) });
            else
                fill.BackgroundTransparency = on and 0 or 1;
                ck.ImageTransparency = on and 0 or 1;
            end;
            bst.Transparency = on and 1 or 0;
        end;
        T._hov = function(h) setk(bst, "Color", h and "AccentColor" or "OutlineColor", .12); end;
    else
        lab = tl({ Text = T.Text, Size = U2(1, -48, 1, 0), Parent = row });
        local track = fr({ Size = UO(36, 18), Position = U2(1, 0, .5, 0), AnchorPoint = V2(1, .5), Parent = row });
        reg(track, { BackgroundColor3 = "WellColor" }); rc(track, 9); local tst = st(track);
        T._dv = { track, tst };
        local fill = fr({ Size = US(1, 1), BackgroundColor3 = C3(1, 1, 1), BackgroundTransparency = 1, Parent = track });
        rc(fill, 9); reg(mk("UIGradient", { Parent = fill }), { Color = acs });
        local knob = fr({ Size = UO(12, 12), Position = U2(0, 3, .5, 0), AnchorPoint = V2(0, .5), ZIndex = 3, Parent = track });
        rc(knob, 7); reg(knob, { BackgroundColor3 = "MutedColor" });
        T._disp = function(a)
            local on = T.Value;
            local t = a and .2 or 0;
            local kp = on and U2(1, -17, .5, 0) or U2(0, 3, .5, 0);
            local ks = on and UO(14, 14) or UO(12, 12);
            if t > 0 then
                tw(knob, t, { Position = kp, Size = ks });
                tw(fill, t, { BackgroundTransparency = on and 0 or 1 });
            else
                knob.Position, knob.Size = kp, ks;
                fill.BackgroundTransparency = on and 0 or 1;
            end;
            setk(knob, "BackgroundColor3", on and "FontColor" or "MutedColor", t);
            tst.Transparency = on and 1 or 0;
        end;
        T._hov = function(h) setk(tst, "Color", h and "AccentColor" or "OutlineColor", .12); end;
    end;
    local ah = addonsHolder(row, isBox and 0 or 46);
    local lx = isBox and 28 or 0;
    con(ah:GetPropertyChangedSignal("AbsoluteSize"), function() lab.Size = U2(1, -lx - (isBox and 0 or 48) - (ah.AbsoluteSize.X / Library.DPIScale) - 6, 1, 0); end);
    local function labc()
        setk(lab, "TextColor3", T.Risky and "RedColor" or "FontColor", .15);
        tw(lab, .15, { TextTransparency = T.Disabled and .55 or (T.Value and 0 or .22) });
    end;
    function T:Display(a) T._disp(a); labc(); end;
    function T:OnChanged(f) T.Changed = f; end;
    function T:SetValue(v)
        v = v == true;
        local ch = v ~= T.Value;
        T.Value = v;
        T:Display(ch);
        for _, a in ipairs(T.Addons) do
            if a.Type == "KeyPicker" and a.SyncToggleState then a.Toggled = v; a:Update(); end;
        end;
        if not Library:SafeCallback(T.Callback, v) or not Library:SafeCallback(T.Changed, v) then deny(T._dv[1], T._dv[2]); end;
        if ch then Library:_bump(); end;
    end;
    function T:SetText(t) T.Text = t; lab.Text = t; end;
    function T:SetDisabled(d) T.Disabled = d == true; labc(); row.Active = not T.Disabled; end;
    function T:AddColorPicker(i, inf) mkColorPicker(ah, i, inf, T); return T; end;
    function T:AddKeyPicker(i, inf) mkKeyPicker(ah, i, inf, T); return T; end;
    vis(T, row);
    con(btn.MouseButton1Click, function()
        if T.Disabled then deny(T._dv[1], T._dv[2]); Library:_tipNow(info.DisabledTooltip); return; end;
        T:SetValue(not T.Value);
    end);
    con(btn.MouseEnter, function() if not T.Disabled then T._hov(true); end; end);
    con(btn.MouseLeave, function() T._hov(false); end);
    Library:AddTooltip(info.Tooltip, info.DisabledTooltip, btn, T);
    T:Display(false);
    Library.Toggles[idx] = T;
    entry(self, row, T.Text, T);
    return T;
end;

function GB:AddToggle(idx, info)
    if Library.ForceCheckbox then return baseToggle(self, idx, info, true); end;
    return baseToggle(self, idx, info, false);
end;
function GB:AddCheckbox(idx, info) return baseToggle(self, idx, info, true); end;

local function mkButton(parent, B, order)
    local f = fr({ Size = U2(0, 0, 1, 0), LayoutOrder = order or 1, Parent = parent });
    reg(f, { BackgroundColor3 = "RaisedColor" }); rc(f, 6); local bs = st(f); gloss(f);
    mk("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill, Parent = f });
    local sc = mk("UIScale", { Parent = f });
    local hl = fr({ Size = US(1, 1), BackgroundTransparency = 1, Parent = f, ZIndex = 2 }); rc(hl, 6);
    reg(hl, { BackgroundColor3 = "AccentColor" });
    local lab = tl({ Text = B.Text, TextSize = 14, Size = US(1, 1), TextXAlignment = Enum.TextXAlignment.Center, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 3, Parent = f }, FS);
    local btn = mk("TextButton", { Text = "", BackgroundTransparency = 1, Size = US(1, 1), ZIndex = 4, Parent = f });
    local function base() setk(lab, "TextColor3", B.Risky and "RedColor" or "FontColor"); lab.TextTransparency = B.Disabled and .6 or 0; end;
    base();
    local armed, armTok = false, 0;
    local hold = B.HoldToConfirm == true and .8 or tonumber(B.HoldToConfirm);
    if hold then
        local chg = fr({ Size = US(0, 1), BackgroundColor3 = C3(1, 1, 1), BackgroundTransparency = .3, ZIndex = 2, Parent = f });
        rc(chg, 6);
        reg(mk("UIGradient", { Parent = chg }), { Color = function() return B.Risky and ColorSequence.new(S.RedColor, S.AccentColor2) or acs(); end });
        local htok, ht = 0, nil;
        local function cancel()
            htok += 1;
            if ht then ht:Cancel(); ht = nil; end;
            tw(chg, .18, { Size = US(0, 1) });
            if lab.Text ~= B.Text then lab.Text = B.Text; base(); end;
        end;
        con(btn.MouseButton1Down, function()
            if B.Disabled then return; end;
            htok += 1;
            local my = htok;
            lab.Text = "Hold";
            setk(lab, "TextColor3", "FontColor", .1);
            chg.BackgroundTransparency = .3;
            ht = tw(chg, hold, { Size = US(1, 1) }, Enum.EasingStyle.Linear);
            task.delay(hold, function()
                if my ~= htok then return; end;
                htok += 1;
                ht = nil;
                tw(chg, .4, { BackgroundTransparency = 1 }, Enum.EasingStyle.Quad);
                task.delay(.41, function() if htok == my + 1 then chg.Size, chg.BackgroundTransparency = US(0, 1), .3; end; end);
                lab.Text = B.Text;
                base();
                if not Library:SafeCallback(B.Func) then deny(f, bs); end;
            end);
        end);
        con(btn.MouseButton1Up, cancel);
        con(btn.MouseLeave, cancel);
    end;
    con(btn.MouseEnter, function() if B.Disabled then return; end; setk(bs, "Color", "AccentColor", .12); tw(bs, .12, { Transparency = .35 }); tw(hl, .12, { BackgroundTransparency = .94 }); end);
    con(btn.MouseLeave, function() setk(bs, "Color", "OutlineColor", .15); tw(bs, .15, { Transparency = 0 }); tw(hl, .15, { BackgroundTransparency = 1 }); tw(sc, .2, { Scale = 1 }); end);
    con(btn.MouseButton1Down, function() if B.Disabled then return; end; tw(sc, .08, { Scale = .98 }, Enum.EasingStyle.Quad); tw(hl, .08, { BackgroundTransparency = .82 }); end);
    con(btn.MouseButton1Up, function() tw(sc, .22, { Scale = 1 }); tw(hl, .25, { BackgroundTransparency = .94 }); end);
    con(btn.MouseButton1Click, function()
        if B.Disabled then deny(f, bs); Library:_tipNow(B.DisabledTooltip); return; end;
        if hold then return; end;
        if B.DoubleClick and not armed then
            armed = true; armTok += 1; local my = armTok;
            lab.Text = "Are you sure?"; setk(lab, "TextColor3", "WarnColor", .1);
            task.delay(1.6, function() if my == armTok and armed then armed = false; lab.Text = B.Text; base(); end; end);
            return;
        end;
        if armed then armed = false; armTok += 1; lab.Text = B.Text; base(); end;
        if not Library:SafeCallback(B.Func) then deny(f, bs); end;
    end);
    function B:SetText(t) B.Text = t; lab.Text = t; end;
    function B:SetDisabled(d) B.Disabled = d == true; base(); end;
    Library:AddTooltip(B.Tooltip, B.DisabledTooltip, btn, B);
    return f;
end;

local function binfo(...)
    local a, b = ...;
    if type(a) == "table" then return a; end;
    return { Text = a, Func = b };
end;

function GB:AddButton(...)
    local B = binfo(...);
    B.Type = "Button";
    B.Visible = B.Visible ~= false;
    local row = rowf(self, 30);
    ls(row, 6, true).HorizontalFlex = Enum.UIFlexAlignment.Fill;
    mkButton(row, B, 1);
    local n = 1;
    local gb = self;
    function B:AddButton(...)
        local Sb = binfo(...);
        n += 1;
        mkButton(row, Sb, n);
        Sb.AddButton = B.AddButton;
        return Sb;
    end;
    vis(B, row);
    entry(gb, row, B.Text, B);
    if B.Idx then Library.Buttons[B.Idx] = B; end;
    return B;
end;

function GB:AddLabel(...)
    local a, b, c = ...;
    local L;
    if type(b) == "table" then L = b; L.Idx = a; elseif type(a) == "table" then L = a; else L = { Text = a, DoesWrap = b, Idx = c }; end;
    L.Type = "Label";
    L.Text = L.Text or "";
    L.Visible = L.Visible ~= false;
    L.Addons = {};
    L._win = self.Window;
    local row = rowf(self, 20);
    local lab = tl({ Text = L.Text, TextSize = L.Size or 14, Size = U2(1, 0, 1, 0), TextWrapped = L.DoesWrap == true, Parent = row });
    reg(lab, { TextColor3 = "MutedColor" });
    if L.DoesWrap then
        row.Size = U2(1, 0, 0, 0);
        row.AutomaticSize = Enum.AutomaticSize.Y;
        lab.Size = U2(1, 0, 0, 0);
        lab.AutomaticSize = Enum.AutomaticSize.Y;
    else
        lab.TextTruncate = Enum.TextTruncate.AtEnd;
    end;
    local ah = addonsHolder(row, 0);
    con(ah:GetPropertyChangedSignal("AbsoluteSize"), function() if not L.DoesWrap then lab.Size = U2(1, -(ah.AbsoluteSize.X / Library.DPIScale) - 8, 1, 0); end; end);
    function L:SetText(t) L.Text = t; lab.Text = t; end;
    function L:AddColorPicker(i, inf) mkColorPicker(ah, i, inf, L); setk(lab, "TextColor3", "FontColor"); return L; end;
    function L:AddKeyPicker(i, inf) mkKeyPicker(ah, i, inf, L); setk(lab, "TextColor3", "FontColor"); return L; end;
    vis(L, row);
    if L.Idx then Library.Labels[L.Idx] = L; Library.Options[L.Idx] = L; end;
    entry(self, row, L.Text, L);
    return L;
end;

function GB:AddDivider()
    local row = rowf(self, 9);
    local l = fr({ Size = U2(1, 0, 0, 1), Position = U2(0, 0, .5, 0), Parent = row });
    reg(l, { BackgroundColor3 = "OutlineColor" });
    mk("UIGradient", { Transparency = ns(0, 1, .15, 0, .85, 0, 1, 1), Parent = l });
    return { SetVisible = function(_, v) row.Visible = v; end };
end;

local function fmtn(v, r)
    if r and r > 0 then return string.format("%." .. r .. "f", v); end;
    return tostring(math.floor(v + .5));
end;

function GB:AddSlider(idx, info)
    info = info or {};
    local Sl = { Value = info.Default or info.Min or 0, Min = info.Min or 0, Max = info.Max or 100, Rounding = info.Rounding or 0, Prefix = info.Prefix or "", Suffix = info.Suffix or "", Type = "Slider", Text = info.Text or idx, Disabled = info.Disabled == true, Visible = info.Visible ~= false, Callback = info.Callback, Changed = info.Changed, HideMax = info.HideMax, Compact = info.Compact, FormatDisplayValue = info.FormatDisplayValue };
    local row = rowf(self, Sl.Compact and 22 or 38);
    local lab, val;
    if not Sl.Compact then lab = tl({ Text = Sl.Text, Size = U2(1, -90, 0, 18), TextTruncate = Enum.TextTruncate.AtEnd, Parent = row }); end;
    val = tl({ Text = "", TextSize = 13, Size = UO(0, 18), AutomaticSize = Enum.AutomaticSize.X, Position = U2(1, 0, 0, Sl.Compact and 2 or 0), AnchorPoint = V2(1, 0), TextXAlignment = Enum.TextXAlignment.Right, Parent = row }, FS);
    reg(val, { TextColor3 = "MutedColor" });
    local track = fr({ Size = Sl.Compact and U2(1, -98, 0, 6) or U2(1, 0, 0, 6), Position = Sl.Compact and U2(0, 0, .5, -3) or UO(0, 26), Parent = row });
    reg(track, { BackgroundColor3 = "WellColor" }); rc(track, 3); st(track);
    con(val:GetPropertyChangedSignal("AbsoluteSize"), function()
        local w = val.AbsoluteSize.X / Library.DPIScale + 8;
        if lab then lab.Size = U2(1, -w, 0, 18); else track.Size = U2(1, -w, 0, 6); end;
    end);
    local fill = fr({ Size = US(0, 1), BackgroundColor3 = C3(1, 1, 1), Parent = track }); rc(fill, 3);
    reg(mk("UIGradient", { Parent = fill }), { Color = acs });
    local knob = fr({ Size = UO(12, 12), AnchorPoint = V2(.5, .5), Position = US(0, .5), ZIndex = 3, Parent = track });
    rc(knob, 6); reg(knob, { BackgroundColor3 = "FontColor" });
    local hit = mk("TextButton", { Text = "", BackgroundTransparency = 1, Size = U2(1, 12, 0, 20), Position = U2(0, -6, .5, 0), AnchorPoint = V2(0, .5), ZIndex = 4, Parent = track });
    local function disp(a)
        local p = Sl.Max > Sl.Min and (Sl.Value - Sl.Min) / (Sl.Max - Sl.Min) or 0;
        p = math.clamp(p, 0, 1);
        if a then
            tw(fill, .12, { Size = US(p, 1) }); tw(knob, .12, { Position = US(p, .5) });
        else
            fill.Size = US(p, 1); knob.Position = US(p, .5);
        end;
        local s = Sl.FormatDisplayValue and Sl.FormatDisplayValue(Sl, Sl.Value);
        if not s then
            s = Sl.Prefix .. fmtn(Sl.Value, Sl.Rounding) .. Sl.Suffix;
            if not Sl.HideMax and not Sl.Compact then s = s .. "<font transparency=\"0.45\"> / " .. Sl.Prefix .. fmtn(Sl.Max, Sl.Rounding) .. Sl.Suffix .. "</font>"; end;
        end;
        val.Text = s;
        if lab then lab.TextTransparency = Sl.Disabled and .55 or 0; end;
    end;
    local function rnd(v)
        local m = 10 ^ Sl.Rounding;
        return math.floor(v * m + .5) / m;
    end;
    function Sl:Display(a) disp(a); end;
    function Sl:OnChanged(f) Sl.Changed = f; end;
    function Sl:SetValue(v, a)
        v = tonumber(v);
        if not v then return; end;
        v = math.clamp(rnd(v), Sl.Min, Sl.Max);
        local ch = v ~= Sl.Value;
        Sl.Value = v;
        disp(a ~= false);
        if ch then
            if not Library:SafeCallback(Sl.Callback, v) or not Library:SafeCallback(Sl.Changed, v) then deny(track); end;
            Library:_bump();
        end;
    end;
    function Sl:SetMin(m) Sl.Min = m; Sl:SetValue(math.max(Sl.Value, m)); disp(); end;
    function Sl:SetMax(m) Sl.Max = m; Sl:SetValue(math.min(Sl.Value, m)); disp(); end;
    function Sl:SetText(t) Sl.Text = t; if lab then lab.Text = t; end; end;
    function Sl:SetDisabled(d) Sl.Disabled = d == true; disp(); end;
    local drag = false;
    local function upd(x)
        local p = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1);
        Sl:SetValue(Sl.Min + (Sl.Max - Sl.Min) * p, false);
    end;
    local smv = LPH_NO_VIRTUALIZE(function(i) upd(i.Position.X); end);
    con(hit.InputBegan, function(i)
        if Sl.Disabled then if i.UserInputType == EIT.MouseButton1 or i.UserInputType == EIT.Touch then deny(track); Library:_tipNow(info.DisabledTooltip); end; return; end;
        if i.UserInputType == EIT.MouseButton1 or i.UserInputType == EIT.Touch then
            drag = true;
            upd(i.Position.X);
            tw(knob, .12, { Size = UO(14, 14) });
            dgo(i, smv, function()
                drag = false;
                tw(knob, .2, { Size = UO(12, 12) });
            end);
        end;
    end);
    con(hit.MouseEnter, function() if not Sl.Disabled and not drag then tw(knob, .12, { Size = UO(14, 14) }); end; end);
    con(hit.MouseLeave, function() if not drag then tw(knob, .15, { Size = UO(12, 12) }); end; end);
    Library:AddTooltip(info.Tooltip, info.DisabledTooltip, hit, Sl);
    local vbtn = mk("TextButton", { Text = "", BackgroundTransparency = 1, Size = US(1, 1), ZIndex = 3, Parent = val });
    local edit;
    local function enterEdit()
        if Sl.Disabled then deny(track); return; end;
        if edit then return; end;
        closePops();
        val.TextTransparency = 1;
        edit = fr({ Size = UO(math.max(val.AbsoluteSize.X / Library.DPIScale, 64) + 6, 22), Position = U2(1, 3, .5, 0), AnchorPoint = V2(1, .5), ZIndex = 5, Parent = val });
        reg(edit, { BackgroundColor3 = "WellColor" }); rc(edit, 5); local es = st(edit, "AccentColor");
        local eb = tl({ ClassName = "TextBox", Text = fmtn(Sl.Value, Sl.Rounding), ClearTextOnFocus = false, TextSize = 13, Size = U2(1, -12, 1, 0), Position = UO(6, 0), TextXAlignment = Enum.TextXAlignment.Right, RichText = false, ZIndex = 6, Parent = edit }, FS);
        eb:CaptureFocus();
        eb.SelectionStart = 1;
        eb.CursorPosition = #eb.Text + 1;
        local c; c = eb.FocusLost:Connect(function(enter)
            c:Disconnect();
            local n = tonumber((eb.Text:gsub("[^%d%.%-]", "")));
            local e = edit;
            edit = nil;
            if enter and not n then deny(e, es); task.delay(.3, function() e:Destroy(); val.TextTransparency = 0; end); return; end;
            if enter and n then Sl:SetValue(n); end;
            e:Destroy();
            val.TextTransparency = 0;
        end);
    end;
    con(vbtn.MouseButton1Click, enterEdit);
    con(hit.MouseButton2Click, enterEdit);
    con(vbtn.MouseEnter, function() if not Sl.Disabled then setk(val, "TextColor3", "AccentColor", .1); end; end);
    con(vbtn.MouseLeave, function() setk(val, "TextColor3", "MutedColor", .15); end);
    Sl.Value = math.clamp(rnd(Sl.Value), Sl.Min, Sl.Max);
    disp();
    vis(Sl, row);
    Library.Options[idx] = Sl;
    entry(self, row, Sl.Text, Sl);
    return Sl;
end;

local function field(row, y, h)
    local f = fr({ Size = U2(1, 0, 0, h or 30), Position = UO(0, y), Parent = row });
    reg(f, { BackgroundColor3 = "WellColor" }); rc(f, 6);
    local s = st(f);
    return f, s;
end;

function GB:AddInput(idx, info)
    info = info or {};
    local I = { Value = info.Default or "", Type = "Input", Text = info.Text, Numeric = info.Numeric, Finished = info.Finished, MaxLength = info.MaxLength, Disabled = info.Disabled == true, Visible = info.Visible ~= false, Callback = info.Callback, Changed = info.Changed, AllowEmpty = info.AllowEmpty ~= false, EmptyReset = info.EmptyReset };
    local hasT = I.Text ~= nil and I.Text ~= "";
    local row = rowf(self, hasT and 50 or 30);
    if hasT then tl({ Text = I.Text, Size = U2(1, 0, 0, 18), Parent = row }); end;
    local f, fs = field(row, hasT and 20 or 0);
    local box = tl({ ClassName = "TextBox", Text = I.Value, PlaceholderText = info.Placeholder or "", ClearTextOnFocus = info.ClearTextOnFocus == true, Size = U2(1, -20, 1, 0), Position = UO(10, 0), TextSize = 14, TextTruncate = Enum.TextTruncate.AtEnd, RichText = false, Parent = f });
    reg(box, { PlaceholderColor3 = "MutedColor" });
    box.TextEditable = not I.Disabled;
    local function fire()
        Library:SafeCallback(I.Callback, I.Value);
        Library:SafeCallback(I.Changed, I.Value);
        Library:_bump();
    end;
    function I:OnChanged(fn) I.Changed = fn; end;
    function I:SetValue(t)
        t = tostring(t or "");
        if I.MaxLength and #t > I.MaxLength then t = t:sub(1, I.MaxLength); end;
        if I.Numeric and t ~= "" and not tonumber(t) and t ~= "-" and t ~= "." then t = t:gsub("[^%d%.%-]", ""); end;
        if t == "" and not I.AllowEmpty and I.EmptyReset then t = I.EmptyReset; end;
        I.Value = t;
        if box.Text ~= t then box.Text = t; end;
        fire();
    end;
    function I:SetDisabled(d) I.Disabled = d == true; box.TextEditable = not I.Disabled; box.TextTransparency = I.Disabled and .5 or 0; end;
    function I:SetText(t) I.Text = t; end;
    con(box.Focused, function() setk(fs, "Color", "AccentColor", .12); end);
    con(box.FocusLost, function(enter)
        setk(fs, "Color", "OutlineColor", .15);
        if I.Finished then if enter then I:SetValue(box.Text); else box.Text = I.Value; end; end;
    end);
    if not I.Finished then
        con(box:GetPropertyChangedSignal("Text"), function() if box.Text ~= I.Value then I:SetValue(box.Text); end; end);
    end;
    Library:AddTooltip(info.Tooltip, info.DisabledTooltip, f, I);
    vis(I, row);
    Library.Options[idx] = I;
    entry(self, row, (I.Text or "") .. " " .. (info.Placeholder or ""), I);
    return I;
end;

local function popup(win, anchor, w, h)
    local pop = win.Pop;
    local sc = Library.DPIScale;
    local rp = (anchor.AbsolutePosition - win.Root.AbsolutePosition) / sc;
    local as = anchor.AbsoluteSize / sc;
    local rh, rw = win.Root.AbsoluteSize.Y / sc, win.Root.AbsoluteSize.X / sc;
    local x, y = math.clamp(rp.X, 6, math.max(6, rw - 6 - (w or as.X))), rp.Y + as.Y + 4;
    if y + h > rh - 6 and rp.Y - h - 4 > 6 then y = rp.Y - h - 4; end;
    local f = fr({ Size = UO(w or as.X, h), Position = UO(x, y), ZIndex = 60, Active = true, Parent = pop });
    reg(f, { BackgroundColor3 = "MainColor" }); rc(f, 8); st(f, "OutlineColor"); gloss(f, 226);
    img(f, "Shadow", { Size = U2(1, 40, 1, 40), Position = UO(-20, -14), ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(40, 40, 56, 56), ImageColor3 = C3(0, 0, 0), ImageTransparency = .45, ZIndex = 59 });
    local sh = f:FindFirstChildOfClass("ImageLabel");
    sh.Parent = pop; sh.Position = UO(x - 20, y - 14); sh.Size = UO((w or as.X) + 40, h + 40);
    local us = mk("UIScale", { Scale = .96, Parent = f });
    tw(us, .16, { Scale = 1 });
    return f, sh;
end;

function GB:AddDropdown(idx, info)
    info = info or {};
    local D = { Values = info.Values or {}, Multi = info.Multi == true, Type = "Dropdown", Text = info.Text, Searchable = info.Searchable, MaxVisibleDropdownItems = info.MaxVisibleDropdownItems or 8, SpecialType = info.SpecialType, ExcludeLocalPlayer = info.ExcludeLocalPlayer, AllowNull = info.AllowNull, FormatDisplayValue = info.FormatDisplayValue, DisabledValues = info.DisabledValues or {}, Disabled = info.Disabled == true, Visible = info.Visible ~= false, Callback = info.Callback, Changed = info.Changed };
    D.Value = D.Multi and {} or nil;
    local win = self.Window;
    local hasT = D.Text ~= nil and D.Text ~= "";
    local row = rowf(self, hasT and 50 or 30);
    local lab;
    if hasT then lab = tl({ Text = D.Text, Size = U2(1, 0, 0, 18), Parent = row }); end;
    local f, fs = field(row, hasT and 20 or 0);
    local disp = tl({ Text = "---", Size = U2(1, -36, 1, 0), Position = UO(10, 0), TextTruncate = Enum.TextTruncate.AtEnd, Parent = f });
    local chev = ic(f, "chevron-down", 14, "MutedColor", { Position = U2(1, -10, .5, 0), AnchorPoint = V2(1, .5) });
    local btn = mk("TextButton", { Text = "", BackgroundTransparency = 1, Size = US(1, 1), ZIndex = 3, Parent = f });
    local keys, labels = {}, {};
    local function norm()
        table.clear(keys); table.clear(labels);
        local src = D.Values;
        if D.SpecialType == "Player" then
            src = {};
            for _, p in ipairs(Plrs:GetPlayers()) do if not (D.ExcludeLocalPlayer and p == LP) then src[#src + 1] = p.Name; end; end;
            table.sort(src);
        elseif D.SpecialType == "Team" then
            src = {};
            for _, t in ipairs(Teams:GetTeams()) do src[#src + 1] = t.Name; end;
            table.sort(src);
        end;
        if #src > 0 or next(src) == nil then
            for _, v in ipairs(src) do keys[#keys + 1] = v; labels[v] = tostring(v); end;
        end;
        if #keys == 0 then
            for k, v in next, src do keys[#keys + 1] = k; labels[k] = tostring(v); end;
            table.sort(keys, function(a, b) return labels[a] < labels[b]; end);
        end;
    end;
    local function isDis(k) for _, d in ipairs(D.DisabledValues) do if d == k or d == labels[k] then return true; end; end; return false; end;
    local function shown(k) local l = labels[k] or tostring(k); return D.FormatDisplayValue and D.FormatDisplayValue(k) or l; end;
    local function text()
        if D.Multi then
            local t = {};
            for _, k in ipairs(keys) do if D.Value[k] then t[#t + 1] = shown(k); end; end;
            return #t > 0 and table.concat(t, ", ") or "---";
        end;
        return D.Value ~= nil and shown(D.Value) or "---";
    end;
    local open, pf, psh, plist, pitems = false, nil, nil, nil, {};
    local vord, ibtn, hi, kcon = {}, {}, 0, nil;
    local function hil(i, scroll)
        if ibtn[vord[hi]] then tw(ibtn[vord[hi]], .1, { BackgroundTransparency = 1 }); end;
        hi = i;
        local b = ibtn[vord[hi]];
        if not b then return; end;
        tw(b, .1, { BackgroundTransparency = .4 });
        if scroll and plist then
            local top, vh = (hi - 1) * 28, plist.AbsoluteWindowSize.Y / Library.DPIScale;
            local cp = plist.CanvasPosition.Y;
            if top < cp then plist.CanvasPosition = V2(0, top); elseif top + 26 > cp + vh then plist.CanvasPosition = V2(0, top + 26 - vh); end;
        end;
    end;
    local closeF;
    local function render()
        disp.Text = text();
        for k, it in next, pitems do
            local on = D.Multi and D.Value[k] or (not D.Multi and D.Value == k);
            setk(it.L, "TextColor3", on and "FontColor" or "MutedColor", .1);
            it.M.Visible = on and true or false;
            if it.C then it.C.ImageTransparency = on and 0 or 1; end;
        end;
        disp.TextTransparency = D.Disabled and .5 or 0;
    end;
    local function fire()
        if not Library:SafeCallback(D.Callback, D.Value) or not Library:SafeCallback(D.Changed, D.Value) then deny(f, fs); end;
        Library:_bump();
    end;
    local function pick(k)
        if isDis(k) then return; end;
        if D.Multi then
            D.Value[k] = not D.Value[k] or nil;
        else
            if D.Value == k and D.AllowNull then D.Value = nil; else D.Value = k; end;
        end;
        render();
        fire();
        if not D.Multi and closeF then closeF(); end;
    end;
    closeF = function()
        if not open then return; end;
        open = false;
        PopClosers[closeF] = nil;
        tw(chev, .15, { Rotation = 0 });
        setk(fs, "Color", "OutlineColor", .12);
        if pf then local a, b = pf, psh; tw(a:FindFirstChildOfClass("UIScale"), .1, { Scale = .97 }); task.delay(.06, function() a:Destroy(); b:Destroy(); end); end;
        pf, psh = nil, nil;
        table.clear(pitems);
        if kcon then kcon:Disconnect(); kcon = nil; end;
    end;
    local function build(q)
        for _, c in ipairs(plist:GetChildren()) do if c:IsA("GuiObject") then c:Destroy(); end; end;
        table.clear(pitems);
        table.clear(vord);
        table.clear(ibtn);
        hi = 0;
        local n = 0;
        local ord = {};
        for _, k in ipairs(keys) do if not isDis(k) or info.KeepDisabledValuePosition then ord[#ord + 1] = k; end; end;
        if not info.KeepDisabledValuePosition then for _, k in ipairs(keys) do if isDis(k) then ord[#ord + 1] = k; end; end; end;
        for _, k in ipairs(ord) do
            local l = shown(k);
            if not q or q == "" or l:lower():find(q:lower(), 1, true) then
                n += 1;
                local it = mk("TextButton", { Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Size = U2(1, 0, 0, 26), LayoutOrder = n, Parent = plist });
                reg(it, { BackgroundColor3 = "RaisedColor" }); rc(it, 5);
                local m = fr({ Size = UO(3, 12), Position = U2(0, 4, .5, 0), AnchorPoint = V2(0, .5), Visible = false, Parent = it });
                reg(m, { BackgroundColor3 = "AccentColor" }); rc(m, 2);
                local L = tl({ Text = l, TextSize = 14, Size = U2(1, -40, 1, 0), Position = UO(14, 0), TextTruncate = Enum.TextTruncate.AtEnd, Parent = it });
                local C;
                if D.Multi then C = ic(it, "check", 14, "AccentColor", { Position = U2(1, -8, .5, 0), AnchorPoint = V2(1, .5), ImageTransparency = 1 }); end;
                if isDis(k) then L.TextTransparency = .6; end;
                pitems[k] = { L = L, M = m, C = C };
                if not isDis(k) then vord[#vord + 1] = k; ibtn[k] = it; end;
                local vi = #vord;
                con(it.MouseEnter, function() if not isDis(k) then hil(vi, false); end; end);
                con(it.MouseLeave, function() tw(it, .12, { BackgroundTransparency = 1 }); end);
                con(it.MouseButton1Click, function() pick(k); end);
            end;
        end;
        render();
        local start = 1;
        if not D.Multi and D.Value ~= nil then for i, k in ipairs(vord) do if k == D.Value then start = i; end; end; end;
        if #vord > 0 then task.defer(function() if plist then hil(start, true); end; end); end;
    end;
    local function openF()
        if D.Disabled then deny(f, fs); Library:_tipNow(info.DisabledTooltip); return; end;
        if open then return; end;
        closePops(closeF);
        if D.SpecialType then norm(); end;
        open = true;
        PopClosers[closeF] = f;
        local cnt = math.min(#keys, D.MaxVisibleDropdownItems);
        local sh = D.Searchable and 36 or 0;
        local h = math.max(cnt, 1) * 28 + 10 + sh;
        pf, psh = popup(win, f, nil, h);
        tw(chev, .15, { Rotation = 180 });
        setk(fs, "Color", "AccentColor", .12);
        local list = mk("ScrollingFrame", { Name = "List", BackgroundTransparency = 1, BorderSizePixel = 0, Size = U2(1, -8, 1, -10 - sh), Position = UO(4, 5 + sh), CanvasSize = UO(0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 2, ScrollingDirection = Enum.ScrollingDirection.Y, ZIndex = 61, Parent = pf });
        reg(list, { ScrollBarImageColor3 = "AccentColor" });
        ls(list, 2);
        plist = list;
        if D.Searchable then
            local sf = fr({ Size = U2(1, -10, 0, 28), Position = UO(5, 5), Parent = pf });
            reg(sf, { BackgroundColor3 = "WellColor" }); rc(sf, 5); st(sf);
            ic(sf, "search", 13, "MutedColor", { Position = U2(0, 8, .5, 0), AnchorPoint = V2(0, .5) });
            local sb = tl({ ClassName = "TextBox", Text = "", PlaceholderText = "Search", ClearTextOnFocus = false, Size = U2(1, -34, 1, 0), Position = UO(28, 0), TextSize = 13, RichText = false, Parent = sf });
            reg(sb, { PlaceholderColor3 = "MutedColor" });
            con(sb:GetPropertyChangedSignal("Text"), function() if pf then build(sb.Text); end; end);
            task.defer(function() if open then sb:CaptureFocus(); end; end);
        end;
        build(nil);
        kcon = UIS.InputBegan:Connect(function(i)
            if not open then return; end;
            local kc = i.KeyCode;
            if kc == Enum.KeyCode.Down and #vord > 0 then hil(math.min(#vord, hi + 1), true);
            elseif kc == Enum.KeyCode.Up and #vord > 0 then hil(math.max(1, hi - 1), true);
            elseif (kc == Enum.KeyCode.Return or kc == Enum.KeyCode.KeypadEnter) and vord[hi] then pick(vord[hi]); end;
        end);
    end;
    con(btn.MouseButton1Click, function() if open then closeF(); else openF(); end; end);
    con(btn.MouseEnter, function() if not open and not D.Disabled then setk(fs, "Color", "AccentColor", .12); tw(fs, .12, { Transparency = .4 }); end; end);
    con(btn.MouseLeave, function() if not open then setk(fs, "Color", "OutlineColor", .12); tw(fs, .12, { Transparency = 0 }); end; end);
    function D:OnChanged(fn) D.Changed = fn; end;
    function D:SetValue(v)
        if D.Multi then
            local t = {};
            if type(v) == "table" then for k, on in next, v do if type(k) == "number" then t[on] = true; elseif on then t[k] = true; end; end; end;
            D.Value = t;
        else
            if v ~= nil and labels[v] == nil then for k, l in next, labels do if l == v then v = k; break; end; end; end;
            if v ~= nil and labels[v] == nil then v = nil; end;
            D.Value = v;
        end;
        render();
        fire();
    end;
    function D:SetValues(v) D.Values = v; norm(); if open then build(nil); end; render(); end;
    function D:AddValues(v) if type(v) ~= "table" then v = { v }; end; for _, x in ipairs(v) do table.insert(D.Values, x); end; D:SetValues(D.Values); end;
    function D:GetActiveValues() if not D.Multi then return D.Value ~= nil and 1 or 0; end; local n = 0; for _ in next, D.Value do n += 1; end; return n; end;
    function D:SetDisabled(d) D.Disabled = d == true; if lab then lab.TextTransparency = D.Disabled and .55 or 0; end; render(); end;
    function D:SetText(t) D.Text = t; if lab then lab.Text = t; end; end;
    function D:Refresh() norm(); render(); end;
    norm();
    local def = info.Default;
    if D.Multi then
        if type(def) == "table" then for k, v in next, def do if type(k) == "number" then D.Value[type(v) == "number" and keys[v] or v] = true; elseif v then D.Value[k] = true; end; end;
        elseif type(def) == "number" and keys[def] then D.Value[keys[def]] = true;
        elseif def ~= nil and labels[def] then D.Value[def] = true; end;
    else
        if type(def) == "number" and keys[def] then D.Value = keys[def];
        elseif def ~= nil then
            if labels[def] then D.Value = def; else for k, l in next, labels do if l == def then D.Value = k; end; end; end;
        end;
    end;
    if D.SpecialType == "Player" then
        con(Plrs.PlayerAdded, function() D:Refresh(); end);
        con(Plrs.PlayerRemoving, function() task.defer(function() D:Refresh(); end); end);
    end;
    render();
    Library:AddTooltip(info.Tooltip, info.DisabledTooltip, btn, D);
    D._sv = function(v) if not v then closeF(); end; end;
    vis(D, row);
    Library.Options[idx] = D;
    entry(self, row, (D.Text or "") .. " " .. table.concat((function() local t = {}; for _, k in ipairs(keys) do t[#t + 1] = labels[k]; end; return t; end)(), " "), D);
    return D;
end;

mkColorPicker = function(holder, idx, info, parent)
    info = info or {};
    local P = { Value = info.Default or C3(1, 1, 1), Transparency = info.Transparency, Title = info.Title, Type = "ColorPicker", Callback = info.Callback, Changed = info.Changed };
    P.Hue, P.Sat, P.Vib = P.Value:ToHSV();
    local win = parent and parent._win or Library._cwin;
    local sw = mk("TextButton", { Text = "", AutoButtonColor = false, Size = UO(26, 16), BackgroundColor3 = C3(1, 1, 1), BorderSizePixel = 0, Parent = holder });
    rc(sw, 4); local sws = st(sw);
    local chk = img(sw, "Checker", { Size = US(1, 1), ScaleType = Enum.ScaleType.Tile, TileSize = UO(8, 8), Visible = P.Transparency ~= nil });
    rc(chk, 4);
    local col = fr({ Size = US(1, 1), Parent = sw }); rc(col, 4);
    local open, pf, psh = false, nil, nil;
    local closeF;
    local svf, svc, huc, hexb, alb, alc, alg;
    local function upd(fromHex)
        P.Value = Color3.fromHSV(P.Hue, P.Sat, P.Vib);
        col.BackgroundColor3 = P.Value;
        col.BackgroundTransparency = P.Transparency or 0;
        if pf then
            svf.BackgroundColor3 = Color3.fromHSV(P.Hue, 1, 1);
            svc.Position = US(P.Sat, 1 - P.Vib);
            huc.Position = US(.5, P.Hue);
            if not fromHex then hexb.Text = "#" .. P.Value:ToHex():upper(); end;
            if alb then alg.Color = ColorSequence.new(P.Value); alc.Position = US(P.Transparency or 0, .5); end;
        end;
    end;
    local function fire()
        Library:SafeCallback(P.Callback, P.Value);
        Library:SafeCallback(P.Changed, P.Value);
        Library:_bump();
    end;
    function P:OnChanged(f) P.Changed = f; end;
    function P:SetHSVFromRGB(c) P.Hue, P.Sat, P.Vib = c:ToHSV(); end;
    function P:SetValue(hsv, tr)
        if typeof(hsv) == "Color3" then P:SetHSVFromRGB(hsv); else P.Hue, P.Sat, P.Vib = hsv[1], hsv[2], hsv[3]; end;
        if tr ~= nil then P.Transparency = tr; end;
        upd(); fire();
    end;
    function P:SetValueRGB(c, tr) P:SetValue(c, tr); end;
    function P:Display() upd(); end;
    closeF = function()
        if not open then return; end;
        open = false;
        PopClosers[closeF] = nil;
        sws.Transparency = 0;
        if pf then local a, b = pf, psh; task.delay(.04, function() a:Destroy(); b:Destroy(); end); end;
        pf, psh = nil, nil;
    end;
    local function dragger(area, fn)
        local mv = LPH_NO_VIRTUALIZE(function(i) if pf then fn(mpos(i)); end; end);
        con(area.InputBegan, function(i)
            if i.UserInputType == EIT.MouseButton1 or i.UserInputType == EIT.Touch then
                fn(mpos(i));
                dgo(i, mv);
            end;
        end);
    end;
    local function openF()
        if open then closeF(); return; end;
        win = (parent and parent._win) or Library._cwin;
        if not win then return; end;
        closePops(closeF);
        open = true;
        PopClosers[closeF] = sw;
        sws.Transparency = 1;
        local hasA = P.Transparency ~= nil;
        pf, psh = popup(win, sw, 228, hasA and 268 or 248);
        local ttl = tl({ Text = P.Title or (parent and parent.Text) or "Color", TextSize = 13, Position = UO(12, 8), Size = U2(1, -24, 0, 16), ZIndex = 61, Parent = pf }, FB);
        svf = fr({ Size = UO(176, 176), Position = UO(12, 32), ZIndex = 61, Parent = pf }); rc(svf, 6);
        local wo = fr({ Size = US(1, 1), BackgroundColor3 = C3(1, 1, 1), ZIndex = 62, Parent = svf }); rc(wo, 6);
        mk("UIGradient", { Transparency = ns(0, 0, 1, 1), Parent = wo });
        local bo = fr({ Size = US(1, 1), BackgroundColor3 = C3(0, 0, 0), ZIndex = 63, Parent = svf }); rc(bo, 6);
        mk("UIGradient", { Rotation = 90, Transparency = ns(0, 1, 1, 0), Parent = bo });
        svc = fr({ Size = UO(10, 10), AnchorPoint = V2(.5, .5), BackgroundTransparency = 1, ZIndex = 65, Parent = svf }); rc(svc, 5);
        mk("UIStroke", { Color = C3(1, 1, 1), Thickness = 2, Parent = svc });
        local hb = fr({ Size = UO(14, 176), Position = UO(200, 32), BackgroundColor3 = C3(1, 1, 1), ZIndex = 61, Parent = pf }); rc(hb, 5);
        local hk = {};
        for i = 0, 6 do hk[#hk + 1] = ColorSequenceKeypoint.new(i / 6, Color3.fromHSV(i / 6 % 1, 1, 1)); end;
        mk("UIGradient", { Rotation = 90, Color = ColorSequence.new(hk), Parent = hb });
        huc = fr({ Size = U2(1, 4, 0, 4), AnchorPoint = V2(.5, .5), BackgroundColor3 = C3(1, 1, 1), ZIndex = 63, Parent = hb }); rc(huc, 2);
        st(huc, "WellColor");
        local y = 214;
        if hasA then
            alb = fr({ Size = UO(202, 12), Position = UO(12, y), BackgroundColor3 = C3(1, 1, 1), ZIndex = 61, Parent = pf }); rc(alb, 5);
            local ck = img(alb, "Checker", { Size = US(1, 1), ScaleType = Enum.ScaleType.Tile, TileSize = UO(8, 8), ZIndex = 61 }); rc(ck, 5);
            local ov = fr({ Size = US(1, 1), BackgroundColor3 = C3(1, 1, 1), ZIndex = 62, Parent = alb }); rc(ov, 5);
            alg = mk("UIGradient", { Transparency = ns(0, 0, 1, 1), Parent = ov });
            alc = fr({ Size = UO(4, 16), AnchorPoint = V2(.5, .5), BackgroundColor3 = C3(1, 1, 1), ZIndex = 63, Parent = alb }); rc(alc, 2);
            st(alc, "WellColor");
            dragger(alb, function(p) P.Transparency = math.clamp((p.X - alb.AbsolutePosition.X) / alb.AbsoluteSize.X, 0, 1); upd(); fire(); end);
            y += 20;
        end;
        local hf = fr({ Size = UO(202, 26), Position = UO(12, y), ZIndex = 61, Parent = pf });
        reg(hf, { BackgroundColor3 = "WellColor" }); rc(hf, 5); st(hf);
        hexb = tl({ ClassName = "TextBox", Text = "", ClearTextOnFocus = false, Size = U2(1, -16, 1, 0), Position = UO(8, 0), TextSize = 13, RichText = false, ZIndex = 62, Parent = hf });
        con(hexb.FocusLost, function()
            local ok, c = pcall(Color3.fromHex, (hexb.Text:gsub("#", "")));
            if ok and c then P:SetHSVFromRGB(c); upd(true); fire(); end;
            upd();
        end);
        dragger(svf, function(p)
            P.Sat = math.clamp((p.X - svf.AbsolutePosition.X) / svf.AbsoluteSize.X, 0, 1);
            P.Vib = 1 - math.clamp((p.Y - svf.AbsolutePosition.Y) / svf.AbsoluteSize.Y, 0, 1);
            upd(); fire();
        end);
        dragger(hb, function(p) P.Hue = math.clamp((p.Y - hb.AbsolutePosition.Y) / hb.AbsoluteSize.Y, 0, .999); upd(); fire(); end);
        upd();
    end;
    con(sw.MouseButton1Click, openF);
    con(sw.MouseEnter, function() setk(sws, "Color", "AccentColor", .1); end);
    con(sw.MouseLeave, function() setk(sws, "Color", "OutlineColor", .1); end);
    upd();
    if parent then parent.Addons[#parent.Addons + 1] = P; end;
    Library.Options[idx] = P;
    return P;
end;

local KModes = { "Always", "Toggle", "Hold", "Press" };
local ModOf = { LeftControl = "Ctrl", RightControl = "Ctrl", LeftShift = "Shift", RightShift = "Shift", LeftAlt = "Alt", RightAlt = "Alt" };
local ModKeys = { Ctrl = { Enum.KeyCode.LeftControl, Enum.KeyCode.RightControl }, Shift = { Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift }, Alt = { Enum.KeyCode.LeftAlt, Enum.KeyCode.RightAlt } };
local ModOrder = { "Ctrl", "Shift", "Alt" };
local MBShort = { MouseButton1 = "MB1", MouseButton2 = "MB2", MouseButton3 = "MB3" };
local function nkey(v) return MBShort[v] or v; end;
Library.Picking = false;

local function modDown(m) for _, k in ipairs(ModKeys[m]) do if UIS:IsKeyDown(k) then return true; end; end; return false; end;
local function heldMods(skip)
    local t = {};
    for _, m in ipairs(ModOrder) do if m ~= skip and modDown(m) then t[#t + 1] = m; end; end;
    return t;
end;
local function modsOk(list)
    if type(list) ~= "table" then return true; end;
    for _, m in ipairs(list) do if ModKeys[m] and not modDown(m) then return false; end; end;
    return true;
end;
local function kdisp(v, mods)
    local s = kname(v);
    if type(mods) == "table" and #mods > 0 then s = table.concat(mods, "+") .. "+" .. s; end;
    return s;
end;
local function sameMods(a, b)
    a, b = type(a) == "table" and a or {}, type(b) == "table" and b or {};
    if #a ~= #b then return false; end;
    for i = 1, #a do if a[i] ~= b[i] then return false; end; end;
    return true;
end;


mkKeyPicker = function(holder, idx, info, parent)
    info = info or {};
    local isLabel = parent and parent.Type == "Label";
    local K = { Value = nkey(info.Default or "None"), Mode = info.Mode or "Toggle", Modifiers = info.DefaultModifiers or {}, Default = nkey(info.Default or "None"), DefaultMode = info.Mode or "Toggle", DefaultModifiers = info.DefaultModifiers or {}, Text = info.Text or (parent and parent.Text) or idx, Type = "KeyPicker", SyncToggleState = info.SyncToggleState and parent and not isLabel, NoUI = info.NoUI, Callback = info.Callback, ChangedCallback = info.ChangedCallback, Changed = info.Changed, Toggled = false, Held = false, Clicked = {}, Blacklist = info.Blacklisted or {} };
    if K.Mode == "Press" and not isLabel then K.Mode = "Toggle"; end;
    if K.SyncToggleState and K.Mode ~= "Toggle" and K.Mode ~= "Hold" then K.Mode = "Toggle"; end;
    K.Modes = K.SyncToggleState and { "Toggle", "Hold" } or (isLabel and KModes or { "Always", "Toggle", "Hold" });
    local pill = mk("TextButton", { Text = "", AutoButtonColor = false, Size = UO(0, 20), AutomaticSize = Enum.AutomaticSize.X, BorderSizePixel = 0, ClipsDescendants = true, Parent = holder });
    reg(pill, { BackgroundColor3 = "WellColor" }); rc(pill, 5); local ps = st(pill);
    pd(pill, 5, 5, 0, 0);
    local pl = tl({ Text = kdisp(K.Value, K.Modifiers), TextSize = 12, Size = UO(0, 20), AutomaticSize = Enum.AutomaticSize.X, TextXAlignment = Enum.TextXAlignment.Center, Parent = pill }, FS);
    mk("UISizeConstraint", { MinSize = V2(10, 20), Parent = pl });
    reg(pl, { TextColor3 = "MutedColor" });
    local drain = mk("UIGradient", { Transparency = ns(0, 0, .5, 0, .502, 1, 1, 1), Offset = V2(.5, 0), Enabled = false, Parent = ps });
    local kbr, kbl, kbk, kbs, kbm;
    if not K.NoUI then
        kbr = mk("TextButton", { Text = "", AutoButtonColor = false, BackgroundTransparency = 1, BorderSizePixel = 0, Size = U2(1, 0, 0, 22), Visible = false, Parent = KBL });
        ls(kbr, 8, true, Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Center);
        local cap = fr({ Size = UO(0, 18), AutomaticSize = Enum.AutomaticSize.X, LayoutOrder = 1, Parent = kbr });
        reg(cap, { BackgroundColor3 = "WellColor" }); rc(cap, 5); kbs = st(cap); pd(cap, 5, 5, 0, 0);
        kbk = tl({ Text = "", TextSize = 11, Size = UO(0, 18), AutomaticSize = Enum.AutomaticSize.X, TextXAlignment = Enum.TextXAlignment.Center, Parent = cap }, FS);
        mk("UISizeConstraint", { MinSize = V2(8, 18), Parent = kbk });
        kbl = tl({ Text = "", TextSize = 13, Size = UO(0, 22), TextTruncate = Enum.TextTruncate.AtEnd, LayoutOrder = 2, Parent = kbr });
        mk("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill, Parent = kbl });
        kbm = tl({ Text = "", TextSize = 11, Size = UO(0, 22), AutomaticSize = Enum.AutomaticSize.X, TextXAlignment = Enum.TextXAlignment.Right, LayoutOrder = 3, Parent = kbr });
        reg(kbm, { TextColor3 = "MutedColor" });
    end;
    local listen, ltok, lconE, lconB, pendMod, lastBind = false, 0, nil, nil, nil, 0;
    function K:GetState()
        if K.Mode == "Always" then return true; end;
        if K.Mode == "Hold" then return K.Held; end;
        if K.Mode == "Press" then return false; end;
        return K.Toggled;
    end;
    function K:Update()
        if not listen then pl.Text = kdisp(K.Value, K.Modifiers); end;
        local on = K:GetState();
        setk(pl, "TextColor3", (listen or on) and "AccentColor" or "MutedColor", .1);
        if kbr then
            kbr.Visible = K.Value ~= "None" and K.Value ~= "";
            kbk.Text, kbl.Text, kbm.Text = kdisp(K.Value, K.Modifiers), K.Text, K.Mode:lower();
            setk(kbl, "TextColor3", on and "FontColor" or "MutedColor", .12);
            setk(kbk, "TextColor3", on and "AccentColor" or "MutedColor", .12);
            setk(kbs, "Color", on and "AccentColor" or "OutlineColor", .12);
            kbs.Transparency = on and .4 or 0;
            kbc();
        end;
    end;
    function K:OnClick(f) K.Clicked[#K.Clicked + 1] = f; end;
    function K:OnChanged(f) K.Changed = f; end;
    function K:SetValue(v)
        if type(v) == "table" then
            K.Value = nkey(v[1] or K.Value);
            if v[2] and table.find(K.Modes, v[2]) then K.Mode = v[2]; end;
            if type(v[3]) == "table" then K.Modifiers = v[3]; end;
        else
            K.Value = nkey(v);
        end;
        K.Held = false;
        K:Update();
        Library:SafeCallback(K.ChangedCallback, K.Value, K.Modifiers);
        Library:SafeCallback(K.Changed, K.Value, K.Modifiers);
        Library:_bump();
    end;
    local function doClick()
        if K.Mode == "Toggle" then
            K.Toggled = not K.Toggled;
            if K.SyncToggleState and parent then parent:SetValue(K.Toggled); end;
        end;
        K:Update();
        Library:SafeCallback(K.Callback, K.Mode == "Press" and true or K:GetState());
        for _, f in ipairs(K.Clicked) do Library:SafeCallback(f, K:GetState()); end;
    end;
    K._match = function(i)
        local v = K.Value;
        if v == "None" or v == "" then return false; end;
        local hit = (i.UserInputType == EIT.Keyboard and i.KeyCode.Name == v) or (i.UserInputType ~= EIT.Keyboard and MBShort[i.UserInputType.Name] == v);
        return hit and modsOk(K.Modifiers);
    end;
    K._press = function() doClick(); end;
    if kbr then con(kbr.MouseButton1Click, function() if K.Mode == "Toggle" or K.Mode == "Press" then doClick(); end; end); end;
    K._hold = function(h) if K.Mode == "Hold" then K.Held = h; if K.SyncToggleState and parent then parent:SetValue(h); end; K:Update(); Library:SafeCallback(K.Callback, h); end; end;
    local function finish(commit, v, mods)
        if not listen then return; end;
        listen = false;
        ltok += 1;
        Library.Picking = false;
        pendMod = nil;
        if lconB then lconB:Disconnect(); lconB = nil; end;
        if lconE then lconE:Disconnect(); lconE = nil; end;
        drain.Enabled = false;
        lastBind = os.clock();
        setk(ps, "Color", "OutlineColor", .15);
        if not commit then K:Update(); return; end;
        if K.SyncToggleState and parent then K.Toggled = parent.Value; end;
        K:SetValue({ v, K.Mode, mods or {} });
        pl.TextTransparency = .7;
        tw(pl, .3, { TextTransparency = 0 }, Enum.EasingStyle.Quad);
        if v ~= "None" then
            local clash;
            for o in next, Pickers do if o ~= K and o.Value == v and sameMods(o.Modifiers, mods) then clash = o; break; end; end;
            local tk = Library.ToggleKeybind;
            if not clash and typeof(tk) == "EnumItem" and tk.Name == v and #(mods or {}) == 0 then clash = { Text = "the menu" }; end;
            if clash then
                setk(ps, "Color", "WarnColor", .05);
                task.delay(.8, function() if not listen then setk(ps, "Color", "OutlineColor", .3); end; end);
                Library:Notify({ Title = "Keybind", Description = kdisp(v, mods) .. " is also bound to " .. tostring(clash.Text) .. ".", Time = 4, Type = "Warn" });
            end;
        end;
    end;
    K._cancel = function() finish(false); end;
    local function begin()
        if listen then finish(false); return; end;
        if Library.Picking or (parent and parent.Disabled) then
            if parent and parent.Disabled then deny(pill, ps); end;
            return;
        end;
        closePops();
        listen = true;
        Library.Picking = true;
        ltok += 1;
        local my = ltok;
        pl.Text = "Press a key";
        setk(pl, "TextColor3", "AccentColor", .1);
        setk(ps, "Color", "AccentColor", .1);
        drain.Offset = V2(.5, 0);
        drain.Enabled = true;
        tw(drain, 6, { Offset = V2(-.5, 0) }, Enum.EasingStyle.Linear);
        task.delay(6, function() if listen and my == ltok then finish(false); end; end);
        task.defer(function()
            if not listen or my ~= ltok then return; end;
            lconB = UIS.InputBegan:Connect(function(i)
                if not listen or UIS:GetFocusedTextBox() then return; end;
                local t = i.UserInputType;
                if t == EIT.Keyboard then
                    local n = i.KeyCode.Name;
                    if n == "Unknown" then return; end;
                    if n == "Escape" then finish(false); return; end;
                    if n == "Backspace" or n == "Delete" then finish(true, "None", {}); return; end;
                    if table.find(K.Blacklist, n) then deny(pill, ps); return; end;
                    if ModOf[n] then
                        pendMod = n;
                        local hm = heldMods();
                        pl.Text = table.concat(hm, "+") .. "+...";
                        return;
                    end;
                    finish(true, n, heldMods());
                elseif t == EIT.MouseButton1 then
                    if not overUI(pill) then finish(false); end;
                elseif t == EIT.MouseButton2 or t == EIT.MouseButton3 then
                    finish(true, MBShort[t.Name], heldMods());
                end;
            end);
            lconE = UIS.InputEnded:Connect(function(i)
                if not listen or not pendMod then return; end;
                if i.UserInputType == EIT.Keyboard and i.KeyCode.Name == pendMod then
                    local n = pendMod;
                    finish(true, n, heldMods(ModOf[n]));
                end;
            end);
        end);
    end;
    con(pill.MouseButton1Click, begin);
    con(pill.MouseEnter, function() if not listen then setk(ps, "Color", "AccentColor", .1); tw(ps, .1, { Transparency = .45 }); end; end);
    con(pill.MouseLeave, function() if not listen then setk(ps, "Color", "OutlineColor", .15); end; tw(ps, .15, { Transparency = 0 }); end);
    local mopen, mf, msh;
    local function mclose() if mf then mf:Destroy(); msh:Destroy(); mf, msh = nil, nil; end; mopen = false; PopClosers[mclose] = nil; end;
    con(pill.MouseButton2Click, function()
        if listen or os.clock() - lastBind < .35 then return; end;
        local win = (parent and parent._win) or Library._cwin;
        if not win then return; end;
        if mopen then mclose(); return; end;
        closePops(mclose);
        mopen = true;
        PopClosers[mclose] = pill;
        local items = {};
        for _, m in ipairs(K.Modes) do items[#items + 1] = { m, "mode" }; end;
        items[#items + 1] = { "Clear", "clear" };
        items[#items + 1] = { "Reset", "reset" };
        mf, msh = popup(win, pill, 110, #items * 24 + 15);
        local l = fr({ BackgroundTransparency = 1, Size = U2(1, -8, 1, -8), Position = UO(4, 4), ZIndex = 61, Parent = mf });
        ls(l, 0);
        for n, it in ipairs(items) do
            if it[2] ~= "mode" and items[n - 1] and items[n - 1][2] == "mode" then
                local sp = fr({ BackgroundTransparency = 1, Size = U2(1, 0, 0, 7), LayoutOrder = n * 2 - 1, ZIndex = 62, Parent = l });
                local ln = fr({ Size = U2(1, -12, 0, 1), Position = U2(0, 6, .5, 0), ZIndex = 62, Parent = sp });
                reg(ln, { BackgroundColor3 = "OutlineColor" });
            end;
            local b = mk("TextButton", { Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Size = U2(1, 0, 0, 24), LayoutOrder = n * 2, ZIndex = 62, Parent = l });
            reg(b, { BackgroundColor3 = "RaisedColor" }); rc(b, 4);
            local cur = it[2] == "mode" and K.Mode == it[1];
            local mk2 = fr({ Size = UO(3, 12), Position = U2(0, 3, .5, 0), AnchorPoint = V2(0, .5), Visible = cur, ZIndex = 63, Parent = b });
            reg(mk2, { BackgroundColor3 = "AccentColor" }); rc(mk2, 2);
            local t = tl({ Text = it[1], TextSize = 13, Size = U2(1, -16, 1, 0), Position = UO(12, 0), ZIndex = 63, Parent = b });
            reg(t, { TextColor3 = cur and "FontColor" or "MutedColor" });
            con(b.MouseEnter, function() tw(b, .1, { BackgroundTransparency = .4 }); end);
            con(b.MouseLeave, function() tw(b, .1, { BackgroundTransparency = 1 }); end);
            con(b.MouseButton1Click, function()
                if it[2] == "mode" then K.Mode = it[1]; K.Held = false; K.Toggled = K.SyncToggleState and parent and parent.Value or false; K:Update();
                elseif it[2] == "clear" then K:SetValue({ "None", K.Mode, {} });
                else K:SetValue({ K.Default, K.DefaultMode, K.DefaultModifiers }); end;
                mclose();
            end);
        end;
    end);
    Pickers[K] = true;
    K.Reset = function() K:SetValue({ K.Default, K.DefaultMode, K.DefaultModifiers }); end;
    if K.SyncToggleState and parent then K.Toggled = parent.Value == true; end;
    K:Update();
    if parent then parent.Addons[#parent.Addons + 1] = K; end;
    Library.Options[idx] = K;
    return K;
end;

local function mkGroup(tab, col, info, isTabbox)
    local g = setmetatable({ Tab = tab, Window = tab.Window, N = 0, Name = info.Name }, GB);
    local box = fr({ Size = U2(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = col });
    reg(box, { BackgroundColor3 = "MainColor" }); rc(box, 8); st(box); gloss(box, 222);
    tab.BoxN += 1;
    box.LayoutOrder = tab.BoxN;
    g.Box = box;
    g.Frame = box;
    if not isTabbox then
        local hdr = fr({ BackgroundTransparency = 1, Size = U2(1, 0, 0, 34), Parent = box });
        local x = 12;
        local icn = info.IconName or info.Icon;
        if icn then local i, ok = ic(hdr, icn, 15, "AccentColor", { Position = U2(0, 12, .5, 0), AnchorPoint = V2(0, .5) }); if ok then x = 34; else i:Destroy(); end; end;
        g.Title = tl({ Text = info.Name or "Groupbox", TextSize = 14, Position = UO(x, 0), Size = U2(1, -x - 12, 1, 0), Parent = hdr }, FB);
        if info.Description then
            local d = tl({ Text = info.Description, TextSize = 12, Position = U2(1, -12, 0, 0), AnchorPoint = V2(1, 0), Size = U2(.5, 0, 1, 0), TextXAlignment = Enum.TextXAlignment.Right, Parent = hdr });
            reg(d, { TextColor3 = "MutedColor" });
        end;
        local ln = fr({ Size = U2(1, -24, 0, 1), Position = UO(12, 34), Parent = box });
        reg(ln, { BackgroundColor3 = "OutlineColor" });
        mk("UIGradient", { Transparency = ns(0, 0, .7, .2, 1, 1), Parent = ln });
    end;
    local ct = fr({ BackgroundTransparency = 1, Position = UO(0, isTabbox and 40 or 35), Size = U2(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = box });
    pd(ct, 12, 12, 10, 12);
    ls(ct, 8);
    g.Container = ct;
    return g;
end;

local Tab = {};
Tab.__index = Tab;

function Tab:AddGroupbox(info)
    info = info or {};
    local side = tostring(info.Side or "Left"):lower();
    return mkGroup(self, side == "right" and self.Right or self.Left, info, false);
end;
function Tab:AddLeftGroupbox(name, icon) return self:AddGroupbox({ Side = "Left", Name = name, IconName = icon }); end;
function Tab:AddRightGroupbox(name, icon) return self:AddGroupbox({ Side = "Right", Name = name, IconName = icon }); end;

function Tab:AddTabbox(info)
    info = info or {};
    local side = tostring(info.Side or "Left"):lower();
    local col = side == "right" and self.Right or self.Left;
    local tab = self;
    local TB = { Tabs = {} };
    local holder = mkGroup(tab, col, { Name = info.Name }, true);
    local box = holder.Box;
    holder.Container:Destroy();
    local bar = fr({ BackgroundTransparency = 1, Size = U2(1, -16, 0, 30), Position = UO(8, 6), Parent = box });
    local bl = ls(bar, 4, true);
    bl.HorizontalFlex = Enum.UIFlexAlignment.Fill;
    local ln = fr({ Size = U2(1, -24, 0, 1), Position = UO(12, 39), Parent = box });
    reg(ln, { BackgroundColor3 = "OutlineColor" });
    mk("UIGradient", { Transparency = ns(0, 0, .7, .2, 1, 1), Parent = ln });
    local RW = U2(.8, 0, 0, 2);
    local rail = fr({ Size = RW, AnchorPoint = V2(.5, .5), Position = U2(.5, 0, 1, 2), BackgroundColor3 = C3(1, 1, 1), ZIndex = 3 });
    rc(rail, 1);
    reg(mk("UIGradient", { Transparency = ns(0, 1, .22, 0, .78, 0, 1, 1), Parent = rail }), { Color = acs });
    local cur;
    local function sel(t, a)
        local prev = cur;
        cur = t;
        for _, x in ipairs(TB.Tabs) do
            local on = x == t;
            x.Container.Visible = on;
            setk(x.L, "TextColor3", on and "FontColor" or "MutedColor", a and .12 or 0);
            tw(x.B, a and .15 or 0, { BackgroundTransparency = on and .55 or 1 });
        end;
        if a and prev and prev ~= t then
            tw(rail, .12, { Size = U2(0, 0, 0, 2) }, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
            task.delay(.13, function()
                if cur ~= t then return; end;
                rail.Parent = t.B;
                tw(rail, .3, { Size = RW });
            end);
        else
            rail.Parent, rail.Size = t.B, RW;
        end;
    end;
    function TB:AddTab(name)
        local b = mk("TextButton", { Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Size = U2(0, 0, 1, 0), Parent = bar });
        reg(b, { BackgroundColor3 = "RaisedColor" }); rc(b, 6);
        mk("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill, Parent = b });
        local l = tl({ Text = name, TextSize = 13, Size = US(1, 1), TextXAlignment = Enum.TextXAlignment.Center, Parent = b }, FS);
        local g = setmetatable({ Tab = tab, Window = tab.Window, N = 0, Box = box, Frame = box, Name = name }, GB);
        local ct = fr({ BackgroundTransparency = 1, Position = UO(0, 40), Size = U2(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Visible = false, Parent = box });
        pd(ct, 12, 12, 10, 12); ls(ct, 8);
        g.Container = ct;
        local t = { B = b, L = l, Container = ct, G = g };
        TB.Tabs[#TB.Tabs + 1] = t;
        con(b.MouseButton1Click, function() sel(t, true); end);
        con(b.MouseEnter, function() if cur ~= t then setk(l, "TextColor3", "FontColor", .12); end; end);
        con(b.MouseLeave, function() if cur ~= t then setk(l, "TextColor3", "MutedColor", .15); end; end);
        if #TB.Tabs == 1 then sel(t, false); else setk(l, "TextColor3", "MutedColor"); end;
        return g;
    end;
    return TB;
end;
function Tab:AddLeftTabbox(name) return self:AddTabbox({ Side = "Left", Name = name }); end;
function Tab:AddRightTabbox(name) return self:AddTabbox({ Side = "Right", Name = name }); end;

function Tab:UpdateWarningBox() end;

function Library:CreateWindow(info)
    info = info or {};
    local W = { Tabs = {}, TabList = {}, Title = info.Title or "Argon", Footer = info.Footer or ("v" .. Library.Version) };
    Library.Windows[#Library.Windows + 1] = W;
    Library._cwin = W;
    if info.NotifySide then Library:SetNotifySide(info.NotifySide); end;
    if info.ToggleKeybind then Library.ToggleKeybind = info.ToggleKeybind; end;
    local sz = info.Size or UO(760, 520);
    if typeof(sz) == "Vector2" then sz = UO(sz.X, sz.Y); end;
    local hold = fr({ Name = "Window", BackgroundTransparency = 1, Size = sz, AnchorPoint = info.Center == false and V2(0, 0) or V2(.5, .5), Position = info.Position or (info.Center == false and UO(80, 80) or US(.5, .5)), Visible = false, Parent = SG });
    scl(hold);
    local sh = img(hold, "Shadow", { Size = U2(1, 48, 1, 48), Position = UO(-24, -18), ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(40, 40, 56, 56), ImageColor3 = C3(0, 0, 0), ImageTransparency = .3, ZIndex = 0 });
    local root = fr({ Size = US(1, 1), ZIndex = 1, Active = true, Parent = hold });
    reg(root, { BackgroundColor3 = "BackgroundColor" }); rc(root, 10); st(root);
    local rsc = mk("UIScale", { Parent = root });
    W.Root, W.Holder = root, hold;
    local hz = fr({ BackgroundTransparency = 1, Size = U2(1, -2, 1, -2), Position = UO(1, 1), ClipsDescendants = true, Parent = root });
    local hzi = img(hz, "Haze", { ScaleType = Enum.ScaleType.Tile, TileSize = UO(128, 128), ImageTransparency = .945, Size = U2(1, 256, 1, 0) }, "AccentColor");
    mk("UIGradient", { Rotation = 90, Transparency = ns(0, .55, .35, 0, .8, .35, 1, 1), Parent = hzi });
    local hzt = TS:Create(hzi, TweenInfo.new(36, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), { Position = UO(-128, 0) });
    local side = fr({ Size = U2(0, 190, 1, 0), Parent = root });
    reg(side, { BackgroundColor3 = "SidebarColor" }); rc(side, 10);
    local sfl = fr({ Size = U2(0, 12, 1, 0), Position = U2(1, -12, 0, 0), Parent = side });
    reg(sfl, { BackgroundColor3 = "SidebarColor" });
    local sdv = fr({ Size = U2(0, 1, 1, 0), Position = U2(1, 0, 0, 0), ZIndex = 2, Parent = side });
    reg(sdv, { BackgroundColor3 = "OutlineColor" });
    local brand = fr({ BackgroundTransparency = 1, Size = U2(1, 0, 0, 62), Parent = side });
    local em = fr({ Size = UO(32, 32), Position = U2(0, 16, .5, 0), AnchorPoint = V2(0, .5), ZIndex = 3, Parent = brand });
    reg(em, { BackgroundColor3 = "RaisedColor" }); rc(em, 9); st(em, "AccentColor", .55); gloss(em, 200);
    local emi = ic(em, info.Icon or "atom", 18, "AccentColor", { Position = US(.5, .5), AnchorPoint = V2(.5, .5), ZIndex = 4 });
    local ttl = tl({ Text = W.Title, TextSize = 13, Position = UO(58, 0), Size = U2(1, -64, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 3, Parent = brand }, fdisp);
    local bln = fr({ Size = U2(1, -28, 0, 1), Position = UO(14, 62), Parent = side });
    reg(bln, { BackgroundColor3 = "OutlineColor" });
    mk("UIGradient", { Transparency = ns(0, 1, .2, 0, .8, 0, 1, 1), Parent = bln });
    local tabsf = mk("ScrollingFrame", { BackgroundTransparency = 1, BorderSizePixel = 0, Size = U2(1, 0, 1, -112), Position = UO(0, 72), CanvasSize = UO(0, 0), ScrollBarThickness = 0, ScrollingDirection = Enum.ScrollingDirection.Y, Parent = side });
    local selbg = fr({ Size = U2(1, -20, 0, 36), Position = UO(10, 0), BackgroundColor3 = C3(1, 1, 1), BackgroundTransparency = 0, Visible = false, Parent = tabsf });
    rc(selbg, 8);
    reg(mk("UIGradient", { Transparency = ns(0, 1, .5, .9, 1, 1), Parent = selbg }), { Color = acs });
    local ULW = U2(1, -44, 0, 2);
    local uline = fr({ Size = ULW, AnchorPoint = V2(.5, .5), Position = U2(.5, 0, 0, 33), BackgroundColor3 = C3(1, 1, 1), Visible = false, ZIndex = 3, Parent = tabsf });
    rc(uline, 1);
    reg(mk("UIGradient", { Transparency = ns(0, 1, .22, 0, .78, 0, 1, 1), Parent = uline }), { Color = acs });
    local ucore = fr({ BackgroundTransparency = 1, Size = US(1, 1), ClipsDescendants = true, ZIndex = 4, Parent = uline });
    local GW = .4;
    local glint = fr({ Size = US(GW, 1), Position = US(-GW, 0), BackgroundColor3 = C3(1, 1, 1), BackgroundTransparency = 1, ZIndex = 4, Parent = ucore });
    mk("UIGradient", { Transparency = ns(0, 1, .5, 0, 1, 1), Parent = glint });
    local GD, sweeping, sweepTok = 1.15, false, 0;
    local function gat(x) return GD * (x + GW / 2) / (1 + GW); end;
    local gpos = TS:Create(glint, TweenInfo.new(GD, Enum.EasingStyle.Linear), { Position = US(1, 0) });
    local gin = TS:Create(glint, TweenInfo.new(gat(.4), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { BackgroundTransparency = .05 });
    local gout = TS:Create(glint, TweenInfo.new(GD - gat(.6), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { BackgroundTransparency = 1 });
    local function sweep()
        if sweeping or not uline.Visible then return; end;
        sweeping = true;
        glint.Position, glint.BackgroundTransparency = US(-GW, 0), 1;
        gpos:Play();
        gin:Play();
        task.delay(gat(.6), function() gout:Play(); end);
        task.delay(GD, function() sweeping = false; end);
    end;
    local uglow = img(tabsf, "Glow", { Size = U2(1, -24, 0, 18), AnchorPoint = V2(.5, .5), Position = U2(.5, 0, 0, 33), ImageTransparency = .72, Visible = false, ZIndex = 2 }, "AccentColor");
    local foot = fr({ BackgroundTransparency = 1, Size = U2(1, 0, 0, 40), Position = U2(0, 0, 1, -40), Parent = side });
    local fln = fr({ Size = U2(1, -28, 0, 1), Position = UO(14, 0), Parent = foot });
    reg(fln, { BackgroundColor3 = "OutlineColor" });
    mk("UIGradient", { Transparency = ns(0, 1, .2, 0, .8, 0, 1, 1), Parent = fln });
    local dot = fr({ Size = UO(6, 6), Position = U2(0, 18, .5, 0), AnchorPoint = V2(0, .5), Parent = foot });
    reg(dot, { BackgroundColor3 = "GoodColor" }); rc(dot, 3);
    local ftl = tl({ Text = W.Footer, TextSize = 12, Position = UO(32, 0), Size = U2(1, -40, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd, Parent = foot });
    reg(ftl, { TextColor3 = "MutedColor" });
    local main = fr({ BackgroundTransparency = 1, Size = U2(1, -191, 1, 0), Position = UO(191, 0), Parent = root });
    local hdr = fr({ BackgroundTransparency = 1, Size = U2(1, 0, 0, 56), Parent = main });
    local pem = fr({ Size = UO(30, 30), Position = U2(0, 20, .5, 0), AnchorPoint = V2(0, .5), ZIndex = 3, Parent = hdr });
    reg(pem, { BackgroundColor3 = "RaisedColor" }); rc(pem, 9); local pes = st(pem, "AccentColor", .55); gloss(pem, 200);
    local pei = ic(pem, "layout-grid", 16, "AccentColor", { Position = US(.5, .5), AnchorPoint = V2(.5, .5), ZIndex = 4 });
    local ptl = tl({ Text = "", TextSize = 15, Position = UO(62, -4), Size = U2(1, -390, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd, Parent = hdr }, fdisp);
    local ptb = fr({ Size = UO(26, 2), Position = U2(0, 62, .5, 11), BackgroundColor3 = C3(1, 1, 1), Parent = hdr });
    rc(ptb, 1); reg(mk("UIGradient", { Parent = ptb }), { Color = acs });
    local hln = fr({ Size = U2(1, 0, 0, 1), Position = UO(0, 56), Parent = main });
    reg(hln, { BackgroundColor3 = "OutlineColor" });
    mk("UIGradient", { Transparency = ns(0, 0, .85, 0, 1, 1), Parent = hln });
    local ctl = fr({ BackgroundTransparency = 1, Size = UO(0, 28), AutomaticSize = Enum.AutomaticSize.X, Position = U2(1, -14, .5, 0), AnchorPoint = V2(1, .5), Parent = hdr });
    ls(ctl, 6, true, Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Center);
    local srch = fr({ Size = UO(196, 30), LayoutOrder = 1, Parent = ctl });
    reg(srch, { BackgroundColor3 = "WellColor" }); rc(srch, 8); local sst = st(srch);
    ic(srch, "search", 14, "MutedColor", { Position = U2(0, 10, .5, 0), AnchorPoint = V2(0, .5) });
    local sbox = tl({ ClassName = "TextBox", Text = "", PlaceholderText = "Search", ClearTextOnFocus = false, Size = U2(1, -40, 1, 0), Position = UO(32, 0), TextSize = 14, RichText = false, Parent = srch });
    reg(sbox, { PlaceholderColor3 = "MutedColor" });
    con(sbox.Focused, function() setk(sst, "Color", "AccentColor", .12); end);
    con(sbox.FocusLost, function() setk(sst, "Color", "OutlineColor", .12); end);
    local function wbtn(icon, order, key)
        local b = mk("TextButton", { Text = "", AutoButtonColor = false, Size = UO(30, 30), LayoutOrder = order, BorderSizePixel = 0, Parent = ctl });
        reg(b, { BackgroundColor3 = "RaisedColor" }); rc(b, 15); local bs = st(b);
        local i = ic(b, icon, 15, "MutedColor", { Position = US(.5, .5), AnchorPoint = V2(.5, .5) });
        con(b.MouseEnter, function() setk(bs, "Color", key, .12); setk(i, "ImageColor3", key, .12); end);
        con(b.MouseLeave, function() setk(bs, "Color", "OutlineColor", .15); setk(i, "ImageColor3", "MutedColor", .15); end);
        return b;
    end;
    local minb = wbtn("minus", 2, "AccentColor");
    local clsb = wbtn("x", 3, "RedColor");
    local body = fr({ BackgroundTransparency = 1, Size = U2(1, 0, 1, -57), Position = UO(0, 57), ClipsDescendants = true, Parent = main });
    W.Body = body;
    local rim = fr({ Size = U2(1, -40, 0, 1), Position = UO(20, 0), BackgroundTransparency = 1, ZIndex = 8, Parent = root });
    reg(rim, { BackgroundColor3 = "AccentColor" });
    mk("UIGradient", { Transparency = ns(0, 1, .5, .05, 1, 1), Parent = rim });
    local veil = fr({ Size = US(1, 1), BackgroundTransparency = 1, ZIndex = 40, Parent = root });
    reg(veil, { BackgroundColor3 = "BackgroundColor" }); rc(veil, 10);
    local pop = fr({ Name = "Pop", BackgroundTransparency = 1, Size = US(1, 1), ZIndex = 50, Parent = root });
    W.Pop = pop;
    local grip = mk("TextButton", { Text = "", BackgroundTransparency = 1, Size = UO(18, 18), Position = U2(1, -2, 1, -2), AnchorPoint = V2(1, 1), ZIndex = 9, Parent = root });
    ic(grip, "grip-vertical", 12, "MutedColor", { Position = US(.5, .5), AnchorPoint = V2(.5, .5), Rotation = 45, ImageTransparency = .5 });
    grip.Visible = info.Resizable ~= false;
    local rz0, rs0;
    local rzm = LPH_NO_VIRTUALIZE(function(i)
        local d = (i.Position - rz0) / Library.DPIScale;
        local ap = hold.AnchorPoint;
        local nw, nh = math.max(rs0.X + d.X, 640), math.max(rs0.Y + d.Y, 420);
        local ow, oh = hold.Size.X.Offset, hold.Size.Y.Offset;
        hold.Size = UO(nw, nh);
        hold.Position += UO((nw - ow) * ap.X * Library.DPIScale, (nh - oh) * ap.Y * Library.DPIScale);
    end);
    con(grip.InputBegan, function(i)
        if i.UserInputType == EIT.MouseButton1 or i.UserInputType == EIT.Touch then
            rz0, rs0 = i.Position, hold.AbsoluteSize / Library.DPIScale;
            dgo(i, rzm, function() W._save(); end);
        end;
    end);
    local stPath = Library.Folder .. "/ui_" .. (tostring(W.Title):gsub("[^%w]", "")) .. ".json";
    local saved;
    if info.SaveState ~= false and isfile and readfile then
        pcall(function() if isfile(stPath) then saved = HS:JSONDecode(readfile(stPath)); end; end);
        if type(saved) ~= "table" then saved = nil; end;
    end;
    local saveTok = 0;
    local curTabRef;
    local function clamp()
        local ss, rp, as = SG.AbsoluteSize, hold.AbsolutePosition - SG.AbsolutePosition, hold.AbsoluteSize;
        local dx, dy = 0, 0;
        if rp.X + as.X < 120 then dx = 120 - (rp.X + as.X); elseif rp.X > ss.X - 120 then dx = (ss.X - 120) - rp.X; end;
        if rp.Y < 0 then dy = -rp.Y; elseif rp.Y > ss.Y - 60 then dy = (ss.Y - 60) - rp.Y; end;
        if dx ~= 0 or dy ~= 0 then hold.Position += UO(dx, dy); end;
    end;
    W._inside = function()
        local ss, rp, as, top = SG.AbsoluteSize, hold.AbsolutePosition - SG.AbsolutePosition, hold.AbsoluteSize, -SG.AbsolutePosition.Y;
        local dx = math.clamp(rp.X, 8, math.max(8, ss.X - as.X - 8)) - rp.X;
        local dy = math.clamp(rp.Y, top + 8, math.max(top + 8, ss.Y - as.Y - 8)) - rp.Y;
        if dx ~= 0 or dy ~= 0 then hold.Position += UO(dx, dy); W._save(); end;
    end;
    W._save = function()
        if info.SaveState == false or not writefile then return; end;
        saveTok += 1;
        local my = saveTok;
        task.delay(.5, function()
            if my ~= saveTok or Library.Unloaded then return; end;
            pcall(function()
                mkdirs(Library.Folder);
                local p, z = hold.Position, hold.Size;
                writefile(stPath, HS:JSONEncode({ xs = p.X.Scale, x = p.X.Offset, ys = p.Y.Scale, y = p.Y.Offset, w = z.X.Offset, h = W._fullH and W._fullH() or z.Y.Offset, tab = curTabRef and curTabRef() }));
            end);
        end);
    end;
    if saved and not info.Position then
        if tonumber(saved.w) and tonumber(saved.h) then hold.Size = UO(math.max(saved.w, 640), math.max(saved.h, 420)); end;
        if tonumber(saved.x) and tonumber(saved.y) then hold.Position = U2(saved.xs or 0, saved.x, saved.ys or 0, saved.y); end;
    end;
    task.defer(function() Library:SetDPIScale(Library._dpiWant or Library.DPIScale); end);
    draggable(brand, hold, function() clamp(); W._save(); end);
    draggable(hdr, hold, function() clamp(); W._save(); end);
    local strikeTok = 0;
    local mini, fullH = false, nil;
    W._fullH = function() return mini and fullH or hold.Size.Y.Offset; end;
    function W:SetMinimized(v)
        mini = v;
        if v then
            fullH = hold.Size.Y.Offset;
            body.Visible = false;
            tw(hold, .3, { Size = UO(hold.Size.X.Offset, 57) });
            side.Visible = false;
            main.Size = U2(1, 0, 1, 0); main.Position = UO(0, 0);
        else
            tw(hold, .3, { Size = UO(hold.Size.X.Offset, fullH or 520) });
            task.delay(.12, function() if not mini then body.Visible = true; side.Visible = true; main.Size = U2(1, -191, 1, 0); main.Position = UO(191, 0); end; end);
        end;
    end;
    con(minb.MouseButton1Click, function() W:SetMinimized(not mini); end);
    local warned = false;
    con(clsb.MouseButton1Click, function()
        Library:Toggle(false);
        if not warned then
            warned = true;
            local k = Library.ToggleKeybind;
            local kn = typeof(k) == "EnumItem" and k.Name or (type(k) == "table" and k.Value) or "RightShift";
            Library:Notify({ Title = W.Title, Description = "Hidden. Press " .. kname(kn) .. " to bring it back.", Time = 4 });
        end;
    end);
    function W:_show(v)
        strikeTok += 1;
        local my = strikeTok;
        local alive = function() return my == strikeTok; end;
        if v then
            closePops();
            hold.Visible = true;
            rsc.Scale = .965;
            veil.BackgroundTransparency = 0;
            rim.BackgroundTransparency = 1;
            tw(rsc, .32, { Scale = 1 });
            tw(veil, .3, { BackgroundTransparency = 1 }, Enum.EasingStyle.Quad);
            tw(rim, .6, { BackgroundTransparency = 0 }, Enum.EasingStyle.Quad);
            task.delay(.35, function() if alive() then sweep(); end; end);
            hzt:Play();
        else
            closePops();
            tipHide();
            tw(rsc, .14, { Scale = .975 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
            tw(veil, .12, { BackgroundTransparency = 0 }, Enum.EasingStyle.Quad);
            task.delay(.14, function() if alive() then hold.Visible = false; hzt:Pause(); end; end);
        end;
    end;
    local tabY = 0;
    local curTab;
    curTabRef = function() return curTab and curTab.Name; end;
    local function filter()
        if not curTab then return; end;
        local q = sbox.Text:lower();
        local boxes = {};
        for _, e in ipairs(curTab.Entries) do
            local own = e.El == nil or e.El.Visible ~= false;
            local m = q == "" or e.Text:find(q, 1, true) ~= nil;
            e.Row.Visible = own and m;
            if e.Box then boxes[e.Box] = boxes[e.Box] or false; if own and m then boxes[e.Box] = true; end; end;
        end;
        for b, any in next, boxes do b.Visible = q == "" or any; end;
    end;
    con(sbox:GetPropertyChangedSignal("Text"), filter);
    local function selTab(t, a)
        if curTab == t then return; end;
        closePops();
        local prev = curTab;
        curTab = t;
        for _, x in ipairs(W.TabList) do
            local on = x == t;
            x.Page.Visible = on;
            setk(x.L, "TextColor3", on and "FontColor" or "MutedColor", a and .15 or 0);
            setk(x.I, "ImageColor3", on and "AccentColor" or "MutedColor", a and .15 or 0);
        end;
        ptl.Text = t.Name;
        if a then W._save(); end;
        local d = Library:GetIcon(t.IconName or "layout-grid");
        if d then pei.Image, pei.ImageRectOffset, pei.ImageRectSize = d.Url, d.ImageRectOffset, d.ImageRectSize; end;
        if a then
            pei.ImageTransparency = 1;
            tw(pei, .3, { ImageTransparency = 0 }, Enum.EasingStyle.Quad);
            ptb.Size = UO(0, 2);
            tw(ptb, .4, { Size = UO(26, 2) });
        end;
        local y = t.Y;
        selbg.Visible, uline.Visible, uglow.Visible = true, true, true;
        local up = U2(.5, 0, 0, y + 33);
        t.HL.BackgroundTransparency, t.HL.Size = 1, U2(0, 0, 0, 2);
        tw(t.L, .2, { Position = UO(t.LX, 0), TextTransparency = 0 });
        if prev then prev.HL.BackgroundTransparency, prev.HL.Size = 1, U2(0, 0, 0, 2); tw(prev.L, .15, { Position = UO(prev.LX, 0), TextTransparency = 0 }); end;
        if a and prev then
            tw(selbg, .32, { Position = UO(10, y) });
            tw(uline, .12, { Size = U2(0, 0, 0, 2) }, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
            tw(uglow, .12, { ImageTransparency = 1 }, Enum.EasingStyle.Quad);
            task.delay(.13, function()
                if curTab ~= t then return; end;
                uline.Position, uglow.Position = up, up;
                uline.Size = U2(0, 0, 0, 2);
                tw(uline, .38, { Size = ULW });
                tw(uglow, .45, { ImageTransparency = .72 });
                task.delay(.28, function() if curTab == t then sweep(); end; end);
            end);
        else
            selbg.Position = UO(10, y);
            uline.Position, uglow.Position, uline.Size = up, up, ULW;
        end;
        if a then
            t.Page.Position = UO(0, 8);
            tw(t.Page, .28, { Position = UO(0, 0) });
        end;
        filter();
    end;
    function W:AddTab(name, icon)
        local t = setmetatable({ Name = name, IconName = icon, Window = W, Entries = {}, BoxN = 0, Y = tabY }, Tab);
        local b = mk("TextButton", { Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Size = U2(1, -20, 0, 36), Position = UO(10, tabY), ZIndex = 2, Parent = tabsf });
        local i, ok = ic(b, icon or "layout-grid", 17, "MutedColor", { Position = U2(0, 16, .5, 0), AnchorPoint = V2(0, .5), ZIndex = 3 });
        local l = tl({ Text = name, TextSize = 14, Position = UO(ok and 42 or 18, 0), Size = U2(1, -50, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 3, Parent = b }, FS);
        reg(l, { TextColor3 = "MutedColor" });
        local hl = fr({ Size = U2(0, 0, 0, 2), Position = UO(0, 33), AnchorPoint = V2(.5, .5), BackgroundColor3 = C3(1, 1, 1), BackgroundTransparency = 1, ZIndex = 3, Parent = l });
        rc(hl, 1);
        reg(mk("UIGradient", { Transparency = ns(0, 1, .22, 0, .78, 0, 1, 1), Parent = hl }), { Color = acs });
        t.B, t.L, t.I, t.HL, t.LX = b, l, i, hl, ok and 42 or 18;
        tabY += 40;
        tabsf.CanvasSize = UO(0, tabY);
        local page = mk("ScrollingFrame", { BackgroundTransparency = 1, BorderSizePixel = 0, Size = US(1, 1), CanvasSize = UO(0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3, ScrollBarImageTransparency = .3, ScrollingDirection = Enum.ScrollingDirection.Y, Visible = false, Parent = body });
        reg(page, { ScrollBarImageColor3 = "AccentColor" });
        local inr = fr({ BackgroundTransparency = 1, Size = U2(1, -28, 0, 0), Position = UO(14, 14), AutomaticSize = Enum.AutomaticSize.Y, Parent = page });
        pd(inr, 0, 0, 0, 14);
        local L = fr({ BackgroundTransparency = 1, Size = U2(.5, -6, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = inr });
        local R = fr({ BackgroundTransparency = 1, Size = U2(.5, -6, 0, 0), Position = U2(.5, 6, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = inr });
        ls(L, 12); ls(R, 12);
        t.Page, t.Left, t.Right = page, L, R;
        con(page:GetPropertyChangedSignal("CanvasPosition"), function() closePops(); end);
        con(b.MouseEnter, function()
            if curTab == t then
                tw(uglow, .15, { ImageTransparency = .5 });
                sweep();
                return;
            end;
            setk(l, "TextColor3", "FontColor", .12);
            setk(i, "ImageColor3", "FontColor", .12);
            tw(l, .12, { TextTransparency = .15 });
            tw(l, .2, { Position = UO(t.LX + 4, 0) });
            hl.Position, hl.Size, hl.BackgroundTransparency = U2(l.TextBounds.X / l.AbsoluteSize.X / 2, 0, 0, 33), U2(0, 0, 0, 2), 1;
            tw(hl, .3, { Size = UO(73, 2), BackgroundTransparency = .45 });
        end);
        con(b.MouseLeave, function()
            if curTab == t then tw(uglow, .25, { ImageTransparency = .72 }); return; end;
            setk(l, "TextColor3", "MutedColor", .15);
            setk(i, "ImageColor3", "MutedColor", .15);
            tw(l, .15, { TextTransparency = 0, Position = UO(t.LX, 0) });
            tw(hl, .2, { BackgroundTransparency = 1 });
        end);
        con(b.MouseButton1Click, function() selTab(t, true); end);
        W.Tabs[name] = t;
        W.TabList[#W.TabList + 1] = t;
        if #W.TabList == 1 then selTab(t, false); end;
        if saved and saved.tab == name and #W.TabList > 1 then selTab(t, false); end;
        return t;
    end;
    function W:SelectTab(n) local t = type(n) == "table" and n or W.Tabs[n]; if t then selTab(t, true); end; end;
    function W:SetTitle(t) W.Title = t; ttl.Text = t; end;
    function W:SetFooter(t) W.Footer = t; ftl.Text = t; end;
    function W:SetCornerRadius() end;
    function W:Toggle(v) Library:Toggle(v); end;
    if not Library.MobileButton and (info.MobileButton == true or (info.MobileButton == nil and UIS.TouchEnabled and not UIS.KeyboardEnabled)) then
        local mb = mk("TextButton", { Name = "MobileToggle", Text = "", AutoButtonColor = false, Size = UO(48, 48), Position = U2(0, 16, .5, 0), AnchorPoint = V2(0, .5), ZIndex = 140, BorderSizePixel = 0, Parent = SG });
        reg(mb, { BackgroundColor3 = "MainColor" }); rc(mb, 24); st(mb, "AccentColor", .35); gloss(mb); scl(mb);
        ic(mb, info.Icon or "atom", 22, "AccentColor", { Position = US(.5, .5), AnchorPoint = V2(.5, .5), ZIndex = 141 });
        local s0, p0, mv;
        local mbm = LPH_NO_VIRTUALIZE(function(i)
            local d = i.Position - s0;
            if d.Magnitude > 6 then mv = true; end;
            if mv then mb.Position = U2(p0.X.Scale, p0.X.Offset + d.X, p0.Y.Scale, p0.Y.Offset + d.Y); end;
        end);
        con(mb.InputBegan, function(i)
            if i.UserInputType == EIT.MouseButton1 or i.UserInputType == EIT.Touch then
                s0, p0, mv = i.Position, mb.Position, false;
                dgo(i, mbm, function() if not mv then Library:Toggle(); end; end);
            end;
        end);
        Library.MobileButton = mb;
    end;
    if info.AutoShow ~= false then task.defer(function() Library:Toggle(true); end); end;
    return W;
end;

function Library:Toggle(v)
    if v == nil then v = not self.Toggled; end;
    self.Toggled = v;
    Modal.Visible = v and self.UnlockMouseWhileOpen ~= false;
    for _, w in ipairs(self.Windows) do w:_show(v); end;
end;

function Library:OnUnload(f) self.UnloadCallbacks[#self.UnloadCallbacks + 1] = f; end;

function Library:Unload()
    if self.Unloaded then return; end;
    self.Unloaded = true;
    for _, c in ipairs(self.Signals) do pcall(function() c:Disconnect(); end); end;
    for _, f in ipairs(self.UnloadCallbacks) do self:SafeCallback(f); end;
    pcall(function() SG:Destroy(); end);
    table.clear(self.Registry);
end;
con(SG.Destroying, function() Library:Unload(); end);

local function typing() return UIS:GetFocusedTextBox() ~= nil; end;

function Library:ResetKeybinds(skip)
    for k in next, Pickers do
        if not (skip and table.find(skip, k)) then k.Reset(); end;
    end;
end;


local function overMenu()
    if not Library.Toggled then return false; end;
    for _, w in ipairs(Library.Windows) do
        if w.Holder.Visible and overUI(w.Holder) then return true; end;
        for _, c in ipairs(w.Pop:GetChildren()) do if c:IsA("Frame") and overUI(c) then return true; end; end;
    end;
    return KBF.Visible and overUI(KBF);
end;

con(UIS.InputBegan, function(i, gp)
    if Library.Unloaded then return; end;
    if i.UserInputType == EIT.MouseButton1 or i.UserInputType == EIT.Touch then
        task.defer(function()
            for f, anc in next, PopClosers do
                local any = typeof(anc) == "Instance" and anc.Parent ~= nil and overUI(anc);
                for _, w in ipairs(Library.Windows) do
                    for _, c in ipairs(w.Pop:GetChildren()) do if c:IsA("Frame") and overUI(c) then any = true; end; end;
                end;
                if not any then f(); end;
            end;
        end);
    end;
    if Library.Picking then return; end;
    if i.KeyCode == Enum.KeyCode.Escape and next(PopClosers) then closePops(); return; end;
    if typing() then return; end;
    local tk = Library.ToggleKeybind;
    local hit = false;
    if type(tk) == "table" and tk._match then hit = tk._match(i);
    elseif typeof(tk) == "EnumItem" then hit = i.KeyCode == tk;
    elseif tk == nil then hit = i.KeyCode == Enum.KeyCode.RightShift; end;
    if hit then Library:Toggle(); return; end;
    local mb = i.UserInputType ~= EIT.Keyboard;
    if mb and overMenu() then return; end;
    for k in next, Pickers do
        if k ~= tk and k._match(i) then
            if k.Mode == "Hold" then k._hold(true); else k._press(); end;
        end;
    end;
end);

con(UIS.InputEnded, function(i)
    if Library.Unloaded then return; end;
    for k in next, Pickers do if k.Mode == "Hold" and k.Held and k._match(i) then k._hold(false); end; end;
end);

AD, AI = { v = "253b93c4", Icons = "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", Glow = "iVBORw0KGgoAAAANSUhEUgAAAIAAAACACAYAAADDPmHLAAAOjElEQVR42u2dTYwVVRbH6QbGkRlRQaEZW0ZBGKQFbYSh+RJsYZoG+ZKPNi0yNMLQDgQy0yIMAYk2TkDASAaSDh/BRCAsEGKchDAJC0IyMSQTNiTsXMzCnetZnqmX/E9ycnJv1a16VfXqvbqLs+h69966Xf/f+bi33qsaRkTDvJXX/EXwAPiL4AHw5gHw5gHw5gHw5gHw5gFoQGtKaB6AkghdWjC84CUHwgtfchAaWfTmlK0hYWgk4ZtztoYAod6FjxJpeEqWBgwegJSEr1bwERFWLRB1BUK9C59U5KQWB4i6AKEexHcV3iTYyJTMFYa4IJQegGqFdxH8F1WaCxB1C0IRxY8SPkp0LeBjVVoUEGEwxAGhVAC4im8TPo7gv6zS4gDhCkJhICiK+NUKbxP8cYuNspitvQ2ILEBoWACq8XqT8CbRw0T+VUwLgyMMBhMIhY0GRRI/rvBhokshf22wJyxmamuCIgyGJCDUDIIih3xX4bXoNqFHxzQbGDYYokAoZEookvhJhNeim8R+UthTjib7mKAwwZAUhJpCUEvx43q9TXgtuhb7aWFjHE320VCYYLCBkDQa5AZBngDEEd/k9WHCS9G12GOFPeNoso+GQsMQBoIpGiSFoK4ASCK+zetljjcJLz1dis5iPgsbZ7DxMNNn3E9CIWGQkcEEwigFgika1ByCIopv8nqZ40dbvH2sRXAWuQU2IcK4nYZDAjHWEhVGG2oEUzQoDAR55n1X8R83iG8SfoxBeC04i/ob2HPCWpXJz7i9hEIC8WxIVNAg2GoDVwgyrQdqUfRFiT/KUXyT8C1CcCn087CJjsbtWxUUEoZxlogQBsGoGBDkUhTmHfpdxE8ivBS9VYheEfO3sBdgL0YYt+N+EwUMrQqGpCCkAUGhAMhL/Cjhpegs9iTYZCJ6SdkUmD4+WfR7UQAxUUUGGwh1A0Feeb8a8aXX61AvhdeiTxYiT4X9DjbNYvw5t5+igJAwSBB0apDRIE0IUk8FeXq/XudHiS9DvsnrTcJr0Vnsl4loOqxN2CsweYzbvSyg0DCYQDBFA5kSXCGQ+wSZR4Giiy9DvvR6DvVaeJPoLPIMIpoJe9Vi/PkM0c8EgwaBU4OMBqaUUDgIsgLAFvpNmzxR4nPI117PoV4KL0WfIcR+jYjaiWgW7HWL8eft6POqAoJhkCBwatDRgFNCFAS2zaI4qaAmAMTx/rC8HyW+DPna66dYhGfRWezZRDSHiH4Pm2sx/nwO+jAUDIMJhCmGaKBTQhgELvVAZlEga+93Cf264IsSX3r9NIPw7UJ0FruDiOYR0XwiWgBbqIyPz0fbDgEFw9BuAGGaigYuEMjCMGkqqCkAUd4fFvp13tfVvov47PVtBuHZ0zuE4BWB3yCixbAlsDdh/Dd//oaAYj7G4sigQWgT0cAFAr060PVAVCpINQrUyvtl3ud1/lhV8Gnxdch/BfmZQz17PHs6i85CdxLRW0S0lIiWWWwp2nQKMBgGjgwcETg1zMRcdErQELSo1QHvE4TVA5lHgby8Pyz0y7zvIv50IT57vfT4hfBiFr0i6h+IqIuIlhNRNxGtgK2E8d/daNOFPksFDIsFCBwROBrMFCnBBQJTPRCVCjKJAnl7vy30P6PW+Trsa/E55M9Gnp4nPP5NePEyCNkNkd8molVEtJqI1hDRWmVr8NkqtF2Jvl0Y6y2MzRFhHs49W6QEDYFOBxPUZpEtFeQWBaoFIIn320L/eLXO1zlfij8L+XguPHIRwnWnEH4FhFwNgdcR0Xoi2kBEG2GbYPz3BrRZhz6rMcYKAUInzrUI556LucwyQCBrArlPMD4kFVQbBTIFIE3vt4V+uc5/SeV8KX4HijT2eg713UJ4Fr0ibg8RvUtEvUT0HmwzjP/uRZse9GEYGIRukRo4GizAXDQEsjCU+wRhqSD3KJAVAC7eb6r6OfTzOn+qKvjaQ8RfjrAthd8EQSvivk9EW4hoKxH1wbbB+O+taPM++ryLMSQIK3EuGwTtqjCcKvYJdCrQqwLXKFATAJLs+rl6vyn0T8Eau02Izzlfir8MgryNPP4OvJeFZ9ErQm8noj8R0U4i6le2E59tR1uGgUHYiLHX4FzLcW4JgawJZmLu01Q9IFNBkiiQ6u5gVt7PALjmfq76deifjrX2a6i4OeebxF8LT+1BKN8Cr2bRPySiXUS0m4j2wPbC+O/daPOhgKEPY/Vi7PU4lwkCrglex5xnqHqAUwGvClxrAZfdwUIBYFv3myp/7f069HPe5zX+IhX2WfwN8NRKTv8jEX0ghN8Nof9CRANE9BER7SOij2H7cGwAbfaiD4PwAcbcjHNsUBBwOlgk9gp0PTBVLA1tUUCvCDJPA3lU/6Z1fxzv59DfgeXXkgjxt8Jz+4XwAxD5ABEdJKJDRHRY2SF8dgBtBwQI/RhzawQESzDHDpEK4kYBvS+Q6Wogy+o/rPiTlX+U9/NGD4f+TlTiK5GP1wvxK+F6Bzy3EtL/CjH/BoGPBPP/NJjzYDDno8F8P4cdxbFP0eYQ+uzDGHsw5g6cgyFYjzmsxJw6RSrgjaKoKNBiiAJhaSDV1UDe4Z+LP1vlb/L+OWKjh/N+Nyryd5CX2fMrAv0ZglU8eL8QviLw34N5HQ8u7IlgXieDeZ2CncSx42gzKEDYj7H2YOwdIhL0YA6rMSeuB3ijaE5IFDCtCEzFYKZpIA0A0gr/svI3ef9i7MZ1IeyuQ2Xei/y8XXj+RwjlldD+GUT9AmJ/FczhH4HHnQnmcRZ2Bse+Qpsv0OczjHEAY3Ik2I5z9mIO6zCnLsxxsSUKyBVBFmkgFwBc87/e948T/rnyl7mfvX8FPI5D/xYUaf3C8yuCfQJPPgZRT0PsoeC854OLfyE490XYBRwbQpvT6HMMY3yCMTkS9OOcW0QqWI25ySjAtQCvCOKmAdNdwlTrgGoAqDb/c/VvCv8zReUvc7/0/k1Yo/ehUt+NfL0fXjuIkP4lvHsIQn8dCPBN4IlXAjGuwq7g2NdoM4Q+X2KMQYy5H+fYjXP2YQ6bVBTQtcAs/E+mNGBbDaRRB+QKgEv+N+38hYV/3vThyr/b4P0c+veiaDuE0H0MAlbC+7ngPJeCC385OMe14BzXA0FuBOe5CbuBY9fQ5hL6nMEYxzDmIZxjr0gFOgp0ixXBArEvEJYGJljSQLV1QCoANGUEgNz3n6Sqf1P458p/LfLueyjG2PsHULkfQf4+BS8+B8++CpG/C8b+ZyDMraBQuw27hWPfoc1V9DmHMU5hzCM4x4CIAlsxl42YG68ITGlArgYmqfsDWQDQVEsAbAWgvvEj87+p+jeF/x7s128zeP8girjTCOWXIOi3gSd+D8HvBALdDQq2e7C7OHYbbb5Fn0sY4zTGHDREgW2YS48lDZhWA7oOkDeI4haCdQGArQDke/5h+Z+r/+W4V6/D/y7s3h1Q3n8W+fwyvLoi7L8g9r+Dgu1+MN5/YPdx7C7afI8+lzHGWRUFDuCcuwxpYBXmqlcDpjrgBVEHRBWChQRgREIAbAVgmwJgAS6izP8bsPzS4f8gNnKOYzk3hDB+DaH9NgT+gYgeBOM8DLz2Eewhjv2ANrfR5xrGGMKYx3GOg4Y00Iu5yTpgMf4HCUBbzEIw06VgVgAkWQHwnT9TAcjLvzUi//fhDh6v+zn8n0DePo/K/jry+x14+QOI/mMQvv8L+xHHHqDNHfS5jjHOY8wTIg3wvsBOsRrYiDnyctBUCPIdwiQrgYYCoNUBgIUKgLUKAF7778My7Sh29c4gdF9BhX8Lnn0f3l4R/Cci+hn2E449RJu76HMDY1zAmCdxjsM4J+8J9KlCUAKw0AGA1jIBYNoCti0B5QYQrwA2YRt2Gy7+XtzRO4x9fc7/F1HI3URIv4d8/wheXxH+f7CfcewR2txDn5sY46KoAz7HuT7Gufsxl82YG68E5IaQbSlo2hL2AHgAfArwKaAEAPgisIGLQL8MLMky0G8ElXwjyG8F+61gfzOo0W8G+dvBJb8d7L8Q4r8Q4r8S5r8S5r8U6r8U6r8W7r8W7n8YUtIfhvifhpX8p2H+x6H+x6H+5+H+5+H+ARGlfkCEf0RMyR8R4x8S5R8S5R8TV/bHxPkHRfoHRfpHxZb9UbH+YdElf1i0f1y8f1y8f2FE2V8Y4V8Z418Z418aVfaXRvnXxvnXxvkXR5b9xZH+1bH+1bH+5dFlf3m0f328f318ZCqIC0FSEFoUDDIyMBAu9rzydCl6SxXCpyV+IQFwrQdcIHCNBjYQJAwMhIRCRopWJfRzov0EJbpNeFevdxV/eB7iZwGAayqIgsCUEmwgmCICw6CBkFDYrMUg+DgxrvZ4m/CmkB9X/OYsxc8KgDQgiEoJGgRbVDABMc4Ah+kzKbjN27XwUSG/UOJnCUBSCEw7hjoa2EAwRQWGYayCIspknzEWb7cJb/N60zq/puLnDUBcCEzRIAoEDYMEQkIRZU8rwbXoUcKHeX0S8esSABcImmNCEAaCCQYJhIQiyp40CK5FDxM+jvjNtRI/DwDiQpAUBBMMEggNhYs9YRBci16N8DUXPy8AbBDESQkuIJhg0ECYwLAJrQU3ie4ifNKQ35SHNnkB4ApBEhCiYDBB4WK6f5joSYWvqfh5A1BtSrCBYINBAxEGh0lkk+A20W3CFy7kFwGAaqNBGAgaBg1EEnssRPQ0hW+qhRa1AiAOBGEgaBhcgIhrYYKPNMwnTPhCiV9rAMIgcAHBBQYTEHFtZEzR4wrfVEsNag1AWiCYYLABkcRGOIheV8IXDYAoCOKAYIMhDRuekvBNRbnuRQKgGhCigIgDh8sYYXOoC+GLDIArCFEwuAJRreDNjnMt5HUuMgBxQHCBIW1rqmfh6wmAuCBkBUTc89fFda0nAKqBIS+ru2tZrwAUDYS6vYb1DkCtgGiYa9ZoAKQNRsNfm7IA4M0D4M0D4M0D4M0D4M0D4M0D4M0D4I2G/R95VExdSYONgQAAAABJRU5ErkJggg==", Shadow = "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", Haze = "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", Checker = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAJElEQVR42mOoqKj4jw+fOHECL2YYNWBYGEBIASELRg0YFgYAAMT83x81dySCAAAAAElFTkSuQmCC" }, { ["activity"] = 0, ["aperture"] = 1, ["app-window"] = 2, ["atom"] = 3, ["backpack"] = 4, ["ban"] = 5, ["bell"] = 6, ["bolt"] = 7, ["bot"] = 8, ["box"] = 9, ["boxes"] = 10, ["car"] = 11, ["check"] = 12, ["chevron-down"] = 13, ["chevron-left"] = 14, ["chevron-right"] = 15, ["chevron-up"] = 16, ["chevrons-up-down"] = 17, ["circle-check"] = 18, ["circle-dot"] = 19, ["circle-question-mark"] = 20, ["circle-x"] = 21, ["clock"] = 22, ["cloud"] = 23, ["code"] = 24, ["coins"] = 25, ["copy"] = 26, ["crosshair"] = 27, ["crown"] = 28, ["download"] = 29, ["ellipsis"] = 30, ["external-link"] = 31, ["eye"] = 32, ["eye-off"] = 33, ["fish"] = 34, ["flag"] = 35, ["flame"] = 36, ["folder"] = 37, ["footprints"] = 38, ["gamepad-2"] = 39, ["gauge"] = 40, ["ghost"] = 41, ["gift"] = 42, ["globe"] = 43, ["grip-vertical"] = 44, ["hand"] = 45, ["hash"] = 46, ["heart"] = 47, ["house"] = 48, ["image"] = 49, ["info"] = 50, ["key"] = 51, ["keyboard"] = 52, ["layers"] = 53, ["layout-grid"] = 54, ["link"] = 55, ["list"] = 56, ["lock"] = 57, ["lock-open"] = 58, ["magnet"] = 59, ["mail"] = 60, ["map"] = 61, ["maximize-2"] = 62, ["message-circle"] = 63, ["minimize-2"] = 64, ["minus"] = 65, ["moon"] = 66, ["mouse"] = 67, ["mouse-pointer-2"] = 68, ["mouse-pointer-click"] = 69, ["move"] = 70, ["orbit"] = 71, ["package"] = 72, ["paintbrush"] = 73, ["palette"] = 74, ["panel-left"] = 75, ["pencil"] = 76, ["pickaxe"] = 77, ["pin"] = 78, ["plane"] = 79, ["plus"] = 80, ["power"] = 81, ["radar"] = 82, ["radio"] = 83, ["refresh-cw"] = 84, ["rocket"] = 85, ["rotate-ccw"] = 86, ["save"] = 87, ["scan"] = 88, ["scroll-text"] = 89, ["search"] = 90, ["send"] = 91, ["settings"] = 92, ["shield"] = 93, ["shopping-cart"] = 94, ["skull"] = 95, ["sliders-horizontal"] = 96, ["sliders-vertical"] = 97, ["sparkle"] = 98, ["sparkles"] = 99, ["square-check"] = 100, ["star"] = 101, ["sun"] = 102, ["sword"] = 103, ["swords"] = 104, ["target"] = 105, ["terminal"] = 106, ["timer"] = 107, ["toggle-right"] = 108, ["trash"] = 109, ["triangle-alert"] = 110, ["trophy"] = 111, ["upload"] = 112, ["user"] = 113, ["users"] = 114, ["wand-sparkles"] = 115, ["wifi"] = 116, ["wrench"] = 117, ["x"] = 118, ["zap"] = 119 };
for _, f in ipairs(Late) do f(); end;

return Library;
