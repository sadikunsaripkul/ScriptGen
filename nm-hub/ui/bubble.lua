-- ui/bubble.lua — draggable modern bubble
local Players = game:GetService("Players")
local UIS     = game:GetService("UserInputService")
local Tween   = game:GetService("TweenService")

local C = {}
C.__index = C

function C.new(ctx)
    local self = setmetatable({}, C)
    self.ctx = ctx
    self.cfg = ctx.config or {}

    local cfg = self.cfg
    local T  = cfg.Theme or {}
    local UI = cfg.UI or {}
    local pg = Players.LocalPlayer:WaitForChild("PlayerGui")

    local cPurple = T.Purple or Color3.fromRGB(140, 90, 250)
    local cViolet = Color3.fromRGB(180, 120, 255)
    local cBg     = Color3.fromRGB(14, 14, 22)

    local size = UI.BubbleSize or 56

    local gui = Instance.new("ScreenGui")
    gui.Name = "NM-HUB_Bubble"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 1000000
    gui.IgnoreGuiInset = true
    gui.Parent = pg
    if not gui.Parent then
        local ok, pg2 = pcall(function()
            return Players.LocalPlayer:WaitForChild("PlayerGui", 5)
        end)
        if ok and pg2 then gui.Parent = pg2 end
    end

    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800,600)
    local startX = math.floor(vp.X - size - 20)
    local startY = math.floor(vp.Y - size - 120)

    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.Size = UDim2.new(0, size + 24, 0, size + 24)
    glow.Position = UDim2.new(0, startX - 12, 0, startY - 12)
    glow.BackgroundTransparency = 1
    glow.Image = (cfg.Assets and cfg.Assets.Logo) or ""
    glow.ImageColor3 = cPurple
    glow.ImageTransparency = 0.75
    glow.ScaleType = Enum.ScaleType.Crop
    glow.ZIndex = 0
    glow.Parent = gui
    Instance.new("UICorner", glow).CornerRadius = UDim.new(1, 0)

    local ring = Instance.new("Frame")
    ring.Name = "Ring"
    ring.Size = UDim2.new(0, size + 8, 0, size + 8)
    ring.Position = UDim2.new(0, startX - 4, 0, startY - 4)
    ring.BackgroundTransparency = 1
    ring.ZIndex = 1
    ring.Parent = gui
    Instance.new("UICorner", ring).CornerRadius = UDim.new(1, 0)
    local rStroke = Instance.new("UIStroke", ring)
    rStroke.Color = cViolet
    rStroke.Thickness = 1
    rStroke.Transparency = 0.4

    local btn = Instance.new("TextButton")
    btn.Name = "MainBtn"
    btn.Size = UDim2.new(0, size, 0, size)
    btn.Position = UDim2.new(0, startX, 0, startY)
    btn.BackgroundColor3 = cBg
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Active = true
    btn.ZIndex = 2
    btn.Parent = gui
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = cPurple
    stroke.Thickness = 2.5

    local logo = Instance.new("ImageLabel")
    logo.Name = "Logo"
    logo.Size = UDim2.new(1, -6, 1, -6)
    logo.Position = UDim2.new(0, 3, 0, 3)
    logo.BackgroundTransparency = 1
    logo.Image = (cfg.Assets and cfg.Assets.Logo) or ""
    logo.ScaleType = Enum.ScaleType.Crop
    logo.ZIndex = 3
    logo.Parent = btn
    Instance.new("UICorner", logo).CornerRadius = UDim.new(1, 0)

    local pulse = Instance.new("Frame", gui)
    pulse.Name = "Pulse"
    pulse.Size = UDim2.new(0, size, 0, size)
    pulse.Position = UDim2.new(0, startX, 0, startY)
    pulse.BackgroundTransparency = 1
    pulse.ZIndex = 0
    pulse.Parent = gui
    Instance.new("UICorner", pulse).CornerRadius = UDim.new(1, 0)
    local pulseStroke = Instance.new("UIStroke", pulse)
    pulseStroke.Color = cPurple
    pulseStroke.Thickness = 2
    pulseStroke.Transparency = 0.7

    task.spawn(function()
        while pulse.Parent do
            pulseStroke.Transparency = 0.7
            pulse.Size = UDim2.new(0, size, 0, size)
            local tw1 = Tween:Create(pulse, TweenInfo.new(1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, size + 30, 0, size + 30),
            })
            local tw2 = Tween:Create(pulseStroke, TweenInfo.new(1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Transparency = 1,
            })
            tw1:Play(); tw2:Play()
            task.wait(1.6)
        end
    end)

    self.gui = gui
    self.btn = btn
    self.glow = glow
    self.ring = ring
    self.pulse = pulse

    local dragging, dragStart, startPos, moved
    local SNAP_DIST = 20

    local function setPos(pos)
        btn.Position = pos
        glow.Position = UDim2.new(pos.X.Scale, pos.X.Offset - 12, pos.Y.Scale, pos.Y.Offset - 12)
        ring.Position = UDim2.new(pos.X.Scale, pos.X.Offset - 4, pos.Y.Scale, pos.Y.Offset - 4)
        pulse.Position = pos
    end

    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            moved = false
            dragStart = input.Position
            startPos = btn.Position
            Tween:Create(btn, TweenInfo.new(0.12), {Size = UDim2.new(0, size - 4, 0, size - 4)}):Play()
        end
    end)

    btn.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            local d = input.Position - dragStart
            if math.abs(d.X) > 4 or math.abs(d.Y) > 4 then moved = true end
            local nx = startPos.X.Offset + d.X
            local ny = startPos.Y.Offset + d.Y
            setPos(UDim2.new(0, nx, 0, ny))
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            if not dragging then return end
            dragging = false
            Tween:Create(btn, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, size, 0, size)
            }):Play()
            local vp2 = workspace.CurrentCamera.ViewportSize
            local cur = btn.Position
            local x, y = cur.X.Offset, cur.Y.Offset
            if x < vp2.X / 2 - size then
                if x < SNAP_DIST then x = 20 end
            else
                if x > vp2.X - size - SNAP_DIST then x = vp2.X - size - 20 end
            end
            if y < SNAP_DIST then y = 20 end
            if y > vp2.Y - size - SNAP_DIST then y = vp2.Y - size - 40 end
            Tween:Create(btn, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, x, 0, y)
            }):Play()
            Tween:Create(glow, TweenInfo.new(0.25), {
                Position = UDim2.new(0, x - 12, 0, y - 12)
            }):Play()
            Tween:Create(ring, TweenInfo.new(0.25), {
                Position = UDim2.new(0, x - 4, 0, y - 4)
            }):Play()
            Tween:Create(pulse, TweenInfo.new(0.25), {
                Position = UDim2.new(0, x, 0, y)
            }):Play()
        end
    end)

    btn.MouseButton1Click:Connect(function()
        if moved then return end
        if self.onClick then pcall(self.onClick) end
        Tween:Create(btn, TweenInfo.new(0.08), {Size = UDim2.new(0, size - 6, 0, size - 6)}):Play()
        task.wait(0.08)
        Tween:Create(btn, TweenInfo.new(0.15, Enum.EasingStyle.Back), {Size = UDim2.new(0, size, 0, size)}):Play()
    end)

    UIS.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == (UI.ToggleKey or Enum.KeyCode.RightShift) then
            if self.onClick then pcall(self.onClick) end
        end
    end)

    btn.MouseEnter:Connect(function()
        Tween:Create(stroke, TweenInfo.new(0.15), {Thickness = 3.5}):Play()
    end)
    btn.MouseLeave:Connect(function()
        Tween:Create(stroke, TweenInfo.new(0.15), {Thickness = 2.5}):Play()
    end)

    return self
end

return C
