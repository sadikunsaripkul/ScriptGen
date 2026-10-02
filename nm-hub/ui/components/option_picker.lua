-- ui/components/option_picker.lua — mode: "list" / "bubble"
local C = {}
C.__index = C

function C.new(parent, opts)
    opts = opts or {}
    local cfg = _G.NMHUB and _G.NMHUB.config
    local T = cfg and cfg.Theme or {}
    local options = opts.options or {}
    local value = opts.default or options[1]

    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 32)
    row.BackgroundTransparency = 1
    row.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, -4, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = opts.title or "Option"
    label.TextColor3 = T.Text or Color3.fromRGB(235,235,245)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.5, -4, 1, 0)
    btn.Position = UDim2.new(0.5, 4, 0, 0)
    btn.BackgroundColor3 = T.SurfaceAlt or Color3.fromRGB(30,30,44)
    btn.Text = tostring(value)
    btn.TextColor3 = T.Text or Color3.fromRGB(235,235,245)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.Parent = row
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local popup = Instance.new("Frame")
    popup.Visible = false
    popup.Size = UDim2.new(0, 160, 0, 0)
    popup.AutomaticSize = Enum.AutomaticSize.Y
    popup.BackgroundColor3 = T.Surface or Color3.fromRGB(22,22,32)
    popup.BorderSizePixel = 0
    popup.ZIndex = 50
    popup.Parent = row
    Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 6)

    local stroke = Instance.new("UIStroke", popup)
    stroke.Color = T.Purple or Color3.fromRGB(138,92,246)
    stroke.Thickness = 1

    local pl = Instance.new("UIListLayout", popup)
    pl.Padding = UDim.new(0, 2)
    local pp = Instance.new("UIPadding", popup)
    pp.PaddingTop = UDim.new(0, 4)
    pp.PaddingBottom = UDim.new(0, 4)

    local self = setmetatable({}, C)
    self.value = value
    self.onSelect = opts.onSelect

    local function set(v, fire)
        self.value = v
        btn.Text = tostring(v)
        popup.Visible = false
        if fire and self.onSelect then pcall(self.onSelect, v) end
    end

    for _, opt in ipairs(options) do
        local o = Instance.new("TextButton")
        o.Size = UDim2.new(1, 0, 0, 26)
        o.BackgroundColor3 = T.SurfaceAlt or Color3.fromRGB(30,30,44)
        o.Text = tostring(opt)
        o.TextColor3 = T.Text or Color3.fromRGB(235,235,245)
        o.Font = Enum.Font.Gotham
        o.TextSize = 12
        o.BorderSizePixel = 0
        o.Parent = popup
        o.MouseButton1Click:Connect(function() set(opt, true) end)
    end

    btn.MouseButton1Click:Connect(function()
        popup.Visible = not popup.Visible
        popup.Position = UDim2.new(0.5, 4, 1, 4)
    end)

    self.set = set
    self.get = function() return self.value end
    self.frame = row
    return self
end

return C
