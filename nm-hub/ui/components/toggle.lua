-- ui/components/toggle.lua
local Tween = game:GetService("TweenService")
local C = {}
C.__index = C

function C.new(parent, opts)
    opts = opts or {}
    local cfg = _G.NMHUB and _G.NMHUB.config
    local T = cfg and cfg.Theme or {}
    local state = opts.default or false

    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 32)
    row.BackgroundTransparency = 1
    row.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = opts.title or "Toggle"
    label.TextColor3 = T.Text or Color3.fromRGB(235,235,245)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 44, 0, 22)
    btn.Position = UDim2.new(1, -50, 0.5, -11)
    btn.BackgroundColor3 = state and (T.Purple or Color3.fromRGB(138,92,246)) or Color3.fromRGB(60,60,80)
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.Parent = row
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 16, 0, 16)
    dot.Position = state and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 4, 0.5, -8)
    dot.BackgroundColor3 = Color3.fromRGB(255,255,255)
    dot.BorderSizePixel = 0
    dot.Parent = btn
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local self = setmetatable({}, C)
    self.state = state
    self.onChange = opts.onChange

    local function set(v, anim)
        self.state = v
        local target = v and (T.Purple or Color3.fromRGB(138,92,246)) or Color3.fromRGB(60,60,80)
        local pos = v and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 4, 0.5, -8)
        if anim ~= false then
            Tween:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = target}):Play()
            Tween:Create(dot, TweenInfo.new(0.15), {Position = pos}):Play()
        else
            btn.BackgroundColor3 = target
            dot.Position = pos
        end
        if self.onChange then pcall(self.onChange, v) end
    end

    btn.MouseButton1Click:Connect(function() set(not self.state) end)

    self.set = set
    self.get = function() return self.state end
    self.frame = row
    return self
end

return C
