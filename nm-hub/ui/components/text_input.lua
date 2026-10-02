-- ui/components/text_input.lua
local C = {}
C.__index = C

function C.new(parent, opts)
    opts = opts or {}
    local cfg = _G.NMHUB and _G.NMHUB.config
    local T = cfg and cfg.Theme or {}

    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 32)
    row.BackgroundTransparency = 1
    row.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, -4, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = opts.title or "Input"
    label.TextColor3 = T.Text or Color3.fromRGB(235,235,245)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.6, -4, 1, 0)
    box.Position = UDim2.new(0.4, 4, 0, 0)
    box.BackgroundColor3 = T.SurfaceAlt or Color3.fromRGB(30,30,44)
    box.Text = opts.default or ""
    box.PlaceholderText = opts.placeholder or ""
    box.PlaceholderColor3 = T.SubText or Color3.fromRGB(150,150,175)
    box.TextColor3 = T.Text or Color3.fromRGB(235,235,245)
    box.Font = Enum.Font.Gotham
    box.TextSize = 12
    box.BorderSizePixel = 0
    box.ClearTextOnFocus = false
    box.Parent = row
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

    local self = setmetatable({}, C)
    self.onChanged = opts.onChanged

    box.FocusLost:Connect(function()
        if self.onChanged then pcall(self.onChanged, box.Text) end
    end)

    self.get = function() return box.Text end
    self.set = function(v) box.Text = v end
    self.frame = row
    return self
end

return C
