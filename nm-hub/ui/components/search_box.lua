-- ui/components/search_box.lua
local C = {}
C.__index = C

function C.new(parent, opts)
    opts = opts or {}
    local cfg = _G.NMHUB and _G.NMHUB.config
    local T = cfg and cfg.Theme or {}

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, 0, 0, 30)
    box.BackgroundColor3 = T.SurfaceAlt or Color3.fromRGB(30,30,44)
    box.Text = ""
    box.PlaceholderText = opts.placeholder or "Cari..."
    box.PlaceholderColor3 = T.SubText or Color3.fromRGB(150,150,175)
    box.TextColor3 = T.Text or Color3.fromRGB(235,235,245)
    box.Font = Enum.Font.Gotham
    box.TextSize = 13
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.ClearTextOnFocus = false
    box.BorderSizePixel = 0
    box.Parent = parent
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
    local pad = Instance.new("UIPadding", box)
    pad.PaddingLeft = UDim.new(0, 10)

    local self = setmetatable({}, C)
    self.onChanged = opts.onChanged

    box:GetPropertyChangedSignal("Text"):Connect(function()
        if self.onChanged then pcall(self.onChanged, box.Text) end
    end)

    self.get = function() return box.Text end
    self.set = function(v) box.Text = v end
    self.frame = box
    return self
end

return C
