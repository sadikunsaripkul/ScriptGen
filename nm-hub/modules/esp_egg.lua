-- modules/esp_egg.lua
local Players = game:GetService("Players")
local RunSvc  = game:GetService("RunService")
local lp = Players.LocalPlayer

local M = {}
M.state = false
M.conn = nil
M.labels = {}
M.eggMap = nil
M.minRarityNum = 3

local rarityRank = {
    Common=1, Uncommon=2, Rare=3, Epic=4, Legendary=5,
    Mythic=6, Cosmic=7, Secret=8, Eternal=9, Divine=10,
}

local function loadMap()
    local ok, res = pcall(function()
        return loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/sadikunsaripkul/ScriptGen/main/nm-hub/config_eggmap.lua"
        ))()
    end)
    M.eggMap = (ok and type(res)=="table") and res or {}
end

local function passes(rarity)
    local rank = rarityRank[rarity] or 0
    return rank >= M.minRarityNum
end

local function findEggs()
    local list = {}
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name:lower():find("egg") then
            local part = v:FindFirstChild("HumanoidRootPart") or v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")
            if part then
                local data = M.eggMap[v.Name]
                local pet = data and data.pet or (v:GetAttribute("PetName") or "?")
                local rarity = data and data.rarity or (v:GetAttribute("Rarity") or "?")
                table.insert(list, {model=v, part=part, name=v.Name, pet=pet, rarity=rarity})
            end
        end
    end
    return list
end

local function getBB(part)
    if M.labels[part] and M.labels[part].Parent then return M.labels[part] end
    local bb = Instance.new("BillboardGui")
    bb.Size = UDim2.new(0, 180, 0, 42)
    bb.StudsOffset = Vector3.new(0, 3.5, 0)
    bb.AlwaysOnTop = true
    bb.Parent = part

    local f = Instance.new("Frame", bb)
    f.Size = UDim2.new(1, 0, 1, 0)
    f.BackgroundColor3 = Color3.fromRGB(11, 11, 17)
    f.BackgroundTransparency = 0.15
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)

    local s = Instance.new("UIStroke", f)
    s.Color = Color3.fromRGB(140, 90, 250)
    s.Thickness = 1.5

    local n = Instance.new("TextLabel", f)
    n.Name = "Name"
    n.Size = UDim2.new(1, -8, 0, 16)
    n.Position = UDim2.new(0, 4, 0, 4)
    n.BackgroundTransparency = 1
    n.Text = "?"
    n.TextColor3 = Color3.fromRGB(245, 245, 252)
    n.Font = Enum.Font.GothamBold
    n.TextSize = 11
    n.TextXAlignment = Enum.TextXAlignment.Left

    local i = Instance.new("TextLabel", f)
    i.Name = "Info"
    i.Size = UDim2.new(1, -8, 0, 14)
    i.Position = UDim2.new(0, 4, 0, 22)
    i.BackgroundTransparency = 1
    i.Text = "?"
    i.TextColor3 = Color3.fromRGB(145, 145, 170)
    i.Font = Enum.Font.Gotham
    i.TextSize = 10
    i.TextXAlignment = Enum.TextXAlignment.Left

    M.labels[part] = bb
    return bb
end

local function update()
    local seen = {}
    for _, e in ipairs(findEggs()) do
        if passes(e.rarity) then
            local bb = getBB(e.part)
            seen[e.part] = true
            local f = bb:FindFirstChildOfClass("Frame")
            if f then
                local n = f:FindFirstChild("Name")
                local i = f:FindFirstChild("Info")
                if n then n.Text = e.name end
                if i then i.Text = e.pet.."  |  "..e.rarity end
            end
        end
    end
    for part, bb in pairs(M.labels) do
        if not seen[part] or not part.Parent then
            pcall(function() bb:Destroy() end)
            M.labels[part] = nil
        end
    end
end

function M.start(cfg)
    if M.state then return end
    M.state = true
    M.cfg = cfg
    if not M.eggMap then loadMap() end
    if _G.NMHUB and _G.NMHUB.filters and _G.NMHUB.filters.esp_minRarityNum then
        M.minRarityNum = _G.NMHUB.filters.esp_minRarityNum
    end
    M.conn = RunSvc.Heartbeat:Connect(function() pcall(update) end)
end

function M.stop()
    if not M.state then return end
    M.state = false
    if M.conn then M.conn:Disconnect(); M.conn = nil end
    for _, bb in pairs(M.labels) do pcall(function() bb:Destroy() end) end
    M.labels = {}
end

function M.setMinRarityNum(n) M.minRarityNum = n end
function M.setConfig(cfg) M.cfg = cfg end
return M
