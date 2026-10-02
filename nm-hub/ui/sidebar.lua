-- ui/sidebar.lua
local C = {}
C.__index = C

function C.new(parent, opts)
    opts = opts or {}
    local cfg = _G.NMHUB and _G.NMHUB.config
    local T = cfg and cfg.Theme or {}

    local self = setmetatable({}, C)
    self.buttons = {}
    self.active = nil
    self.onSelect = opts.onSelect

    for i, name in ipairs(opts.tabs or {}) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 32)
        btn.BackgroundColor3 = T.Background
        btn.Text = name
        btn.TextColor3 = T.SubText
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 13
        btn.BorderSizePixel = 0
        btn.LayoutOrder = i
        btn.Parent = parent
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

        btn.MouseButton1Click:Connect(function()
            self:setActive(name)
            if self.onSelect then pcall(self.onSelect, name) end
        end)

        self.buttons[name] = btn
    end

    function self:setActive(name)
        for n, b in pairs(self.buttons) do
            b.BackgroundColor3 = (n == name) and (T.Purple) or (T.Background)
            b.TextColor3 = (n == name) and (T.Text) or (T.SubText)
        end
        self.active = name
    end

    return self
end

return C
