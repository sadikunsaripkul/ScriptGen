-- ui/components/section.lua
local C = {}
C.__index = C

function C.new(parent, opts)
    opts = opts or {}
    local cfg = _G.NMHUB and _G.NMHUB.config
    local T = cfg and cfg.Theme or {}

    local wrapper = Instance.new("Frame")
    wrapper.Size = UDim2.new(1, 0, 0, 0)
    wrapper.AutomaticSize = Enum.AutomaticSize.Y
    wrapper.BackgroundTransparency = 1
    wrapper.Parent = parent

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 24)
    title.BackgroundTransparency = 1
    title.Text = opts.title or "Section"
    title.TextColor3 = T.PurpleGlow or Color3.fromRGB(168,85,247)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = wrapper

    local body = Instance.new("Frame")
    body.Size = UDim2.new(1, 0, 0, 0)
    body.Position = UDim2.new(0, 0, 0, 26)
    body.AutomaticSize = Enum.AutomaticSize.Y
    body.BackgroundColor3 = T.Surface or Color3.fromRGB(22,22,32)
    body.BorderSizePixel = 0
    body.Parent = wrapper
    Instance.new("UICorner", body).CornerRadius = UDim.new(0, 8)

    local pad = Instance.new("UIPadding", body)
    pad.PaddingTop = UDim.new(0, 6)
    pad.PaddingBottom = UDim.new(0, 6)
    pad.PaddingLeft = UDim.new(0, 8)
    pad.PaddingRight = UDim.new(0, 8)

    local layout = Instance.new("UIListLayout", body)
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    local self = setmetatable({}, C)
    self.body = body
    self.frame = wrapper
    return self
end

return C
