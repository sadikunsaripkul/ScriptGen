-- ui/window.lua — modern pro final
local Players = game:GetService("Players")
local UIS     = game:GetService("UserInputService")
local Tween   = game:GetService("TweenService")

local C = {}
C.__index = C

local function tw(o, t, props)
    local t2 = Tween:Create(o, TweenInfo.new(t or 0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
    t2:Play()
    return t2
end

function C.new(ctx)
    local self = setmetatable({}, C)
    self.ctx = ctx
    local cfg = ctx.config or {}
    local T = cfg.Theme or {}
    local UI = cfg.UI or {}

    local lp = Players.LocalPlayer
    if not lp then return self end
    local pg = lp:WaitForChild("PlayerGui", 10)
    if not pg then return self end

    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800,600)
    local W = math.min(700, vp.X - 16)
    local H = math.min(470, vp.Y - 32)
    local SIDEBAR_W = 150
    local TOPBAR_H = 46

    local cBg = Color3.fromRGB(11, 11, 16)
    local cSurface = Color3.fromRGB(17, 17, 24)
    local cSurface2 = Color3.fromRGB(24, 24, 34)
    local cSurface3 = Color3.fromRGB(32, 32, 44)
    local cPurple = Color3.fromRGB(138, 90, 250)
    local cPurple2 = Color3.fromRGB(96, 60, 200)
    local cBlue = Color3.fromRGB(70, 130, 250)
    local cCyan = Color3.fromRGB(90, 210, 255)
    local cText = Color3.fromRGB(240, 240, 248)
    local cSub = Color3.fromRGB(125, 125, 150)
    local cMuted = Color3.fromRGB(75, 75, 95)
    local cBorder = Color3.fromRGB(34, 32, 52)
    local cDanger = Color3.fromRGB(240, 70, 70)

    local gui = Instance.new("ScreenGui")
    gui.Name = "NM-HUB_Window"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 99998
    gui.IgnoreGuiInset = true
    gui.Enabled = false
    gui.Parent = pg

    -- outer glow
    local glow = Instance.new("Frame", gui)
    glow.Size = UDim2.new(0, W + 20, 0, H + 20)
    glow.Position = UDim2.new(0.5, -W/2 - 10, 0.5, -H/2 - 10)
    glow.BackgroundColor3 = cPurple
    glow.BackgroundTransparency = 0.92
    glow.BorderSizePixel = 0
    glow.ZIndex = 0
    Instance.new("UICorner", glow).CornerRadius = UDim.new(0, 18)

    -- shadow
    local shadow = Instance.new("Frame", gui)
    shadow.Size = UDim2.new(0, W + 8, 0, H + 8)
    shadow.Position = UDim2.new(0.5, -W/2 - 4, 0.5, -H/2 + 6)
    shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
    shadow.BackgroundTransparency = 0.5
    shadow.BorderSizePixel = 0
    shadow.ZIndex = 1
    Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 14)

    local main = Instance.new("Frame", gui)
    main.Name = "Main"
    main.Size = UDim2.new(0, W, 0, H)
    main.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
    main.BackgroundColor3 = cBg
    main.BorderSizePixel = 0
    main.ZIndex = 2
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

    local mainStroke = Instance.new("UIStroke", main)
    mainStroke.Color = Color3.fromRGB(255, 255, 255)
    mainStroke.Thickness = 1
    mainStroke.Transparency = 0.85
    local gs = Instance.new("UIGradient", mainStroke)
    gs.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, cPurple),
        ColorSequenceKeypoint.new(0.5, cCyan),
        ColorSequenceKeypoint.new(1, cPurple),
    }
    gs.Rotation = 45

    -- TOPBAR
    local top = Instance.new("Frame", main)
    top.Name = "Topbar"
    top.Size = UDim2.new(0, W, 0, TOPBAR_H)
    top.BackgroundColor3 = cSurface
    top.BorderSizePixel = 0
    top.ZIndex = 10
    Instance.new("UICorner", top).CornerRadius = UDim.new(0, 12)

    -- bottom mask
    local tmask = Instance.new("Frame", top)
    tmask.Size = UDim2.new(0, W, 0, 14)
    tmask.Position = UDim2.new(0, 0, 0, TOPBAR_H - 14)
    tmask.BackgroundColor3 = cSurface
    tmask.BorderSizePixel = 0
    tmask.ZIndex = 10

    -- logo circle
    local logoWrap = Instance.new("Frame", top)
    logoWrap.Size = UDim2.new(0, 30, 0, 30)
    logoWrap.Position = UDim2.new(0, 12, 0, 8)
    logoWrap.BackgroundColor3 = cSurface2
    logoWrap.BorderSizePixel = 0
    logoWrap.ZIndex = 11
    Instance.new("UICorner", logoWrap).CornerRadius = UDim.new(1, 0)
    local lwSt = Instance.new("UIStroke", logoWrap)
    lwSt.Color = cPurple
    lwSt.Thickness = 1.5

    local topLogo = Instance.new("ImageLabel", logoWrap)
    topLogo.Size = UDim2.new(1, -4, 1, -4)
    topLogo.Position = UDim2.new(0, 2, 0, 2)
    topLogo.BackgroundTransparency = 1
    topLogo.Image = (cfg.Assets and cfg.Assets.Logo) or ""
    topLogo.ScaleType = Enum.ScaleType.Crop
    topLogo.ZIndex = 12
    Instance.new("UICorner", topLogo).CornerRadius = UDim.new(1, 0)

    local title = Instance.new("TextLabel", top)
    title.Size = UDim2.new(0, 200, 0, 20)
    title.Position = UDim2.new(0, 52, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = "NM-HUB"
    title.TextColor3 = cText
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 11

    local sub = Instance.new("TextLabel", top)
    sub.Size = UDim2.new(0, 200, 0, 14)
    sub.Position = UDim2.new(0, 52, 0, 24)
    sub.BackgroundTransparency = 1
    sub.Text = "Steal An Egg  ·  v"..(cfg.VERSION or "?")
    sub.TextColor3 = cSub
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 10
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.ZIndex = 11

    -- close
    local close = Instance.new("TextButton", top)
    close.Size = UDim2.new(0, 30, 0, 30)
    close.Position = UDim2.new(0, W - 42, 0, 8)
    close.BackgroundColor3 = cSurface2
    close.Text = "X"
    close.TextColor3 = cSub
    close.Font = Enum.Font.GothamBold
    close.TextSize = 13
    close.BorderSizePixel = 0
    close.AutoButtonColor = false
    close.ZIndex = 11
    Instance.new("UICorner", close).CornerRadius = UDim.new(0, 7)
    local clSt = Instance.new("UIStroke", close)
    clSt.Color = cBorder
    clSt.Thickness = 1
    close.MouseEnter:Connect(function()
        tw(close, 0.15, {BackgroundColor3 = cDanger, TextColor3 = Color3.fromRGB(255,255,255)})
    end)
    close.MouseLeave:Connect(function()
        tw(close, 0.15, {BackgroundColor3 = cSurface2, TextColor3 = cSub})
    end)

    -- minimize
    local mini = Instance.new("TextButton", top)
    mini.Size = UDim2.new(0, 30, 0, 30)
    mini.Position = UDim2.new(0, W - 76, 0, 8)
    mini.BackgroundColor3 = cSurface2
    mini.Text = "–"
    mini.TextColor3 = cSub
    mini.Font = Enum.Font.GothamBold
    mini.TextSize = 16
    mini.BorderSizePixel = 0
    mini.AutoButtonColor = false
    mini.ZIndex = 11
    Instance.new("UICorner", mini).CornerRadius = UDim.new(0, 7)
    local miSt = Instance.new("UIStroke", mini)
    miSt.Color = cBorder
    miSt.Thickness = 1
    mini.MouseEnter:Connect(function()
        tw(mini, 0.15, {BackgroundColor3 = cPurple, TextColor3 = Color3.fromRGB(255,255,255)})
    end)
    mini.MouseLeave:Connect(function()
        tw(mini, 0.15, {BackgroundColor3 = cSurface2, TextColor3 = cSub})
    end)

    -- SIDEBAR
    local sidebar = Instance.new("Frame", main)
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, SIDEBAR_W, 0, H - TOPBAR_H)
    sidebar.Position = UDim2.new(0, 0, 0, TOPBAR_H)
    sidebar.BackgroundColor3 = cBg
    sidebar.BorderSizePixel = 0
    sidebar.ZIndex = 5

    local sbLine = Instance.new("Frame", sidebar)
    sbLine.Size = UDim2.new(0, 1, 1, 0)
    sbLine.Position = UDim2.new(1, -1, 0, 0)
    sbLine.BackgroundColor3 = cBorder
    sbLine.BorderSizePixel = 0

    local sbPad = Instance.new("UIPadding", sidebar)
    sbPad.PaddingTop = UDim.new(0, 12)
    sbPad.PaddingLeft = UDim.new(0, 12)
    sbPad.PaddingRight = UDim.new(0, 12)

    local sbList = Instance.new("UIListLayout", sidebar)
    sbList.Padding = UDim.new(0, 3)

    -- CONTENT AREA
    local contentArea = Instance.new("Frame", main)
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(0, W - SIDEBAR_W, 0, H - TOPBAR_H)
    contentArea.Position = UDim2.new(0, SIDEBAR_W, 0, TOPBAR_H)
    contentArea.BackgroundColor3 = cBg
    contentArea.BorderSizePixel = 0
    contentArea.ZIndex = 5

    local contentScroll = Instance.new("ScrollingFrame", contentArea)
    contentScroll.Name = "Content"
    contentScroll.Size = UDim2.new(0, W - SIDEBAR_W - 32, 0, H - TOPBAR_H - 20)
    contentScroll.Position = UDim2.new(0, 16, 0, 12)
    contentScroll.BackgroundTransparency = 1
    contentScroll.BorderSizePixel = 0
    contentScroll.ScrollBarThickness = 3
    contentScroll.ScrollBarImageColor3 = cPurple
    contentScroll.ScrollBarImageTransparency = 0.4
    contentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    contentScroll.ZIndex = 6
    local csList = Instance.new("UIListLayout", contentScroll)
    csList.Padding = UDim.new(0, 16)

    self.gui = gui
    self.main = main
    self.top = top
    self.sidebar = sidebar
    self.content = contentScroll

    -- TABS
    local tabDefs = {
        {id="Visual",   num="01", name="Visual"},
        {id="Farm",     num="02", name="Farm"},
        {id="Friends",  num="03", name="Friend"},
        {id="Info",     num="04", name="Utility"},
        {id="Settings", num="05", name="Settings"},
    }
    self.tabButtons = {}
    self.tabPages = {}
    self.tabUnderlines = {}
    self.tabNums = {}

    local function selectTab(id)
        for n, b in pairs(self.tabButtons) do
            local isActive = (n == id)
            local lbl = b:FindFirstChild("Label")
            local num = b:FindFirstChild("Num")
            tw(b, 0.18, {BackgroundColor3 = isActive and cSurface2 or cBg})
            if lbl then tw(lbl, 0.18, {TextColor3 = isActive and cText or cSub}) end
            if num then tw(num, 0.18, {TextColor3 = isActive and cPurple or cMuted}) end
            local ul = self.tabUnderlines[n]
            if ul then ul.Visible = isActive end
        end
        for n, p in pairs(self.tabPages) do
            p.Visible = (n == id)
        end
        self.activeTab = id
    end

    for i, def in ipairs(tabDefs) do
        local btn = Instance.new("TextButton", sidebar)
        btn.Name = def.id.."Tab"
        btn.Size = UDim2.new(1, 0, 0, 36)
        btn.BackgroundColor3 = cBg
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.BorderSizePixel = 0
        btn.ZIndex = 6
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)

        local num = Instance.new("TextLabel", btn)
        num.Name = "Num"
        num.Size = UDim2.new(0, 26, 1, 0)
        num.Position = UDim2.new(0, 8, 0, 0)
        num.BackgroundTransparency = 1
        num.Text = def.num
        num.TextColor3 = cMuted
        num.Font = Enum.Font.GothamBold
        num.TextSize = 11
        num.TextXAlignment = Enum.TextXAlignment.Left
        num.ZIndex = 7

        local lbl = Instance.new("TextLabel", btn)
        lbl.Name = "Label"
        lbl.Size = UDim2.new(1, -40, 1, 0)
        lbl.Position = UDim2.new(0, 36, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = def.name
        lbl.TextColor3 = cSub
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 7

        local ul = Instance.new("Frame", btn)
        ul.Name = "Underline"
        ul.Size = UDim2.new(0, 4, 0, 4)
        ul.Position = UDim2.new(1, -10, 0.5, -2)
        ul.BackgroundColor3 = cPurple
        ul.BorderSizePixel = 0
        ul.Visible = false
        ul.ZIndex = 8
        Instance.new("UICorner", ul).CornerRadius = UDim.new(1, 0)

        self.tabButtons[def.id] = btn
        self.tabUnderlines[def.id] = ul

        local page = Instance.new("Frame", contentScroll)
        page.Name = def.id.."Page"
        page.Size = UDim2.new(0, W - SIDEBAR_W - 32, 0, 500)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.ZIndex = 6
        local pl = Instance.new("UIListLayout", page)
        pl.Padding = UDim.new(0, 14)

        self.tabPages[def.id] = page

        btn.MouseButton1Click:Connect(function() selectTab(def.id) end)
    end

    selectTab("Visual")

    -- drag
    local dragging, dragStart, startPos
    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = main.Position
        end
    end)
    top.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                       startPos.Y.Scale, startPos.Y.Offset + d.Y)
            glow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X - 10,
                                       startPos.Y.Scale, startPos.Y.Offset + d.Y - 10)
            shadow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X - 4,
                                         startPos.Y.Scale, startPos.Y.Offset + d.Y + 6)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    close.MouseButton1Click:Connect(function()
        local p = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        for _, x in ipairs(p:GetChildren()) do
            if x:IsA("ScreenGui") and x.Name:find("NM-HUB") then x:Destroy() end
        end
    end)
    mini.MouseButton1Click:Connect(function() gui.Enabled = false end)

    function self:show() gui.Enabled = true end
    function self:hide() gui.Enabled = false end
    function self:toggle() gui.Enabled = not gui.Enabled end
    function self:isOpen() return gui.Enabled end
    function self:getPage(name) return self.tabPages[name] end
    function self:selectTab(n) selectTab(n) end

    return self
end

return C
