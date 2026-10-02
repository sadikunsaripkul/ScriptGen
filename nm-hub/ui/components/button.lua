-- ui/components/button.lua
local C = {}
C.__index = C

function C.new(parent, opts)
    opts = opts or {}
    local cfg = _G.NMHUB and _G.NMHUB.config
    local T = cfg and cfg.Theme or {}

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = T.SurfaceAlt or Color3.fromRGB(30,30,44)
    btn.Text = opts.title or "Button"
    btn.TextColor3 = T.Text or Color3.fromRGB(235,235,245)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = T.Border or Color3.fromRGB(60,50,100)
    stroke.Thickness = 1

    btn.MouseButton1Click:Connect(function()
        if opts.onClick then pcall(opts.onClick) end
    end)

    local self = setmetatable({}, C)
    self.frame = btn
    return self
end

return C
