-- NM-HUB — modules/invisible.lua
-- Ghost mode + evasive dari Guardian

local Players = game:GetService("Players")
local RunSvc  = game:GetService("RunService")
local lp      = Players.LocalPlayer

local M = {}
M.state     = false
M.cfg       = nil
M.conn      = nil
M.charConn  = nil
M.saved     = {}
M.lastNotify= 0

-- ─── GHOST ───
local function setGhost(on)
    local char = lp.Character
    if not char then return end
    for _, v in ipairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            if on then
                M.saved[v] = M.saved[v] or v.Transparency
                v.Transparency = 0.9
            else
                v.Transparency = M.saved[v] or 0
            end
        elseif v:IsA("Decal") or v:IsA("Texture") then
            if on then
                M.saved[v] = M.saved[v] or v.Transparency
                v.Transparency = 0.9
            else
                v.Transparency = M.saved[v] or 0
            end
        elseif v:IsA("Accessory") then
            if on then
                M.saved[v] = true
                v.Parent = nil
            end
        end
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        if on then
            hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            hum.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
        else
            hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
            hum.HealthDisplayType = Enum.HumanoidHealthDisplayType.DisplayWhenDamaged
        end
    end
end

-- ─── GUARDIAN ───
local function getGuardians()
    local list = {}
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and (v.Name:lower():find("guard") or v:GetAttribute("IsGuardian")) then
            local hrp = v:FindFirstChild("HumanoidRootPart")
            if hrp then table.insert(list, hrp) end
        end
    end
    return list
end

local function nearestGuardian()
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, math.huge end
    local best, bd = nil, math.huge
    for _, g in ipairs(getGuardians()) do
        local d = (hrp.Position - g.Position).Magnitude
        if d < bd then best, bd = g, d end
    end
    return best, bd
end

-- ─── EVASIVE ───
local function evasiveTick()
    local cfg = M.cfg
    if not cfg then return end
    local _, dist = nearestGuardian()
    local safe = cfg.Invisible_SafeDist or 30
    if dist >= safe then return end

    local mode = cfg.Invisible_Mode or "Notify Only"
    if mode == "Auto-Hide" then
        local char = lp.Character
        if char then
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.Transparency = 1 end
            end
        end
    elseif mode == "Auto-Teleport" then
        local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = hrp.CFrame + Vector3.new(0, 0, safe * 2)
        end
    elseif mode == "Notify Only" then
        if tick() - M.lastNotify > 3 then
            M.lastNotify = tick()
            if _G.NMHUB and _G.NMHUB.util then
                _G.NMHUB.util.notify("Guardian deket: " .. math.floor(dist) .. " studs", 2)
            end
        end
    end
end

-- ─── API ───
function M.start(cfg)
    if M.state then return end
    M.cfg = cfg or M.cfg
    M.state = true

    if M.cfg and M.cfg.Invisible_Ghost then setGhost(true) end

    M.charConn = lp.CharacterAdded:Connect(function()
        task.wait(1)
        if M.state and M.cfg and M.cfg.Invisible_Ghost then setGhost(true) end
    end)

    M.conn = RunSvc.Heartbeat:Connect(function()
        pcall(evasiveTick)
    end)
end

function M.stop()
    if not M.state then return end
    M.state = false
    if M.conn then M.conn:Disconnect(); M.conn = nil end
    if M.charConn then M.charConn:Disconnect(); M.charConn = nil end
    setGhost(false)
end

function M.setConfig(cfg) M.cfg = cfg end

return M
