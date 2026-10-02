-- ui/content.lua — renderer
local C = {}
C.__index = C

function C.new(parent)
    local self = setmetatable({}, C)
    self.parent = parent

    function self:clear()
        for _, c in ipairs(parent:GetChildren()) do
            if not c:IsA("UIListLayout") then c:Destroy() end
        end
    end

    function self:addSection(title)
        local cfg = _G.NMHUB and _G.NMHUB.config
        local T = cfg and cfg.Theme or {}

        local wrap = Instance.new("Frame")
        wrap.Size = UDim2.new(1, 0, 0, 0)
        wrap.AutomaticSize = Enum.AutomaticSize.Y
        wrap.BackgroundTransparency = 1
        wrap.Parent = parent

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 22)
        lbl.BackgroundTransparency = 1
        lbl.Text = title
        lbl.TextColor3 = T.PurpleGlow or Color3.fromRGB(168,85,247)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = wrap

        local body = Instance.new("Frame")
        body.Size = UDim2.new(1, 0, 0, 0)
        body.Position = UDim2.new(0, 0, 0, 26)
        body.AutomaticSize = Enum.AutomaticSize.Y
        body.BackgroundColor3 = T.Surface or Color3.fromRGB(22,22,32)
        body.BorderSizePixel = 0
        body.Parent = wrap
        Instance.new("UICorner", body).CornerRadius = UDim.new(0, 8)

        local pad = Instance.new("UIPadding", body)
        pad.PaddingTop = UDim.new(0, 6)
        pad.PaddingBottom = UDim.new(0, 6)
        pad.PaddingLeft = UDim.new(0, 8)
        pad.PaddingRight = UDim.new(0, 8)

        local layout = Instance.new("UIListLayout", body)
        layout.Padding = UDim.new(0, 6)
        layout.SortOrder = Enum.SortOrder.LayoutOrder

        return body
    end

    return self
end

return C
