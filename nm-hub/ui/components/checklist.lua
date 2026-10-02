-- ui/components/checklist.lua
local C = {}
C.__index = C

function C.new(parent, opts)
    opts = opts or {}
    local cfg = _G.NMHUB and _G.NMHUB.config
    local T = cfg and cfg.Theme or {}

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 0, opts.height or 180)
    scroll.BackgroundColor3 = T.SurfaceAlt or Color3.fromRGB(30,30,44)
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Parent = parent
    Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 6)

    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0, 2)
    local pad = Instance.new("UIPadding", scroll)
    pad.PaddingTop = UDim.new(0, 6)
    pad.PaddingLeft = UDim.new(0, 8)

    local self = setmetatable({}, C)
    self.items = opts.items or {}
    self.filter = ""
    self.onToggle = opts.onToggle
    self.rows = {}
    self.scroll = scroll

    local function render()
        for _, r in ipairs(self.rows) do r:Destroy() end
        self.rows = {}
        local f = self.filter:lower()
        for _, item in ipairs(self.items) do
            local label = (item.label or ""):lower()
            if f == "" or label:find(f, 1, true) then
                local row = Instance.new("TextButton")
                row.Size = UDim2.new(1, 0, 0, 26)
                row.BackgroundTransparency = 1
                row.Text = ""
                row.Parent = scroll

                local chk = Instance.new("Frame")
                chk.Size = UDim2.new(0, 16, 0, 16)
                chk.Position = UDim2.new(0, 0, 0.5, -8)
                chk.BackgroundColor3 = item.checked and (T.Purple or Color3.fromRGB(138,92,246)) or Color3.fromRGB(60,60,80)
                chk.BorderSizePixel = 0
                chk.Parent = row
                Instance.new("UICorner", chk).CornerRadius = UDim.new(0, 4)

                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(1, -24, 1, 0)
                lbl.Position = UDim2.new(0, 24, 0, 0)
                lbl.BackgroundTransparency = 1
                lbl.Text = item.label or "?"
                lbl.TextColor3 = T.Text or Color3.fromRGB(235,235,245)
                lbl.Font = Enum.Font.Gotham
                lbl.TextSize = 12
                lbl.TextXAlignment = Enum.TextXAlignment.Left
                lbl.Parent = row

                row.MouseButton1Click:Connect(function()
                    item.checked = not item.checked
                    chk.BackgroundColor3 = item.checked and (T.Purple or Color3.fromRGB(138,92,246)) or Color3.fromRGB(60,60,80)
                    if self.onToggle then pcall(self.onToggle, item.id, item.checked, item) end
                end)

                table.insert(self.rows, row)
            end
        end
    end

    self.setItems = function(items)
        self.items = items or {}
        render()
    end
    self.setFilter = function(f)
        self.filter = f or ""
        render()
    end
    render()

    self.frame = scroll
    return self
end

return C
