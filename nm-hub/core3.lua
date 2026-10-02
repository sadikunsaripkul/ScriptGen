-- NM-HUB — core3.lua (vararg-safe)

local Players = game:GetService("Players")

local UTIL = {}

function UTIL.getPlayer()
    return Players.LocalPlayer
end

function UTIL.getChar()
    local lp = Players.LocalPlayer
    if not lp then return nil end
    return lp.Character
end

function UTIL.getHRP()
    local c = UTIL.getChar()
    if not c then return nil end
    return c:FindFirstChild("HumanoidRootPart")
end

function UTIL.getHumanoid()
    local c = UTIL.getChar()
    if not c then return nil end
    return c:FindFirstChildOfClass("Humanoid")
end

function UTIL.waitChar(timeout)
    timeout = timeout or 10
    local lp = Players.LocalPlayer
    if not lp then return nil end
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        return lp.Character
    end
    local t = 0
    while t < timeout do
        task.wait(0.1)
        t = t + 0.1
        if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            return lp.Character
        end
    end
    return nil
end

function UTIL.notify(text, dur)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "NM-HUB",
            Text = tostring(text),
            Duration = dur or 3,
        })
    end)
end

function UTIL.safeCall(fn, ...)
    local ok, res = pcall(fn, ...)
    if not ok then return nil end
    return res
end

function UTIL.deepCopy(t)
    if type(t) ~= "table" then return t end
    local o = {}
    for k, v in pairs(t) do o[k] = UTIL.deepCopy(v) end
    return o
end

function UTIL.tween(obj, props, time)
    return nil
end

function UTIL.getRank(r)
    if not r then return 0 end
    local cfg = _G.NMHUB and _G.NMHUB.config
    if not cfg then return 0 end
    local tbl = cfg.RarityRank
    if not tbl then return 0 end
    local rank = tbl[r]
    if rank == nil then return 0 end
    return rank
end

function UTIL.passesFilter(r, min)
    if not min then return true end
    if min == "All" then return true end
    return UTIL.getRank(r) >= UTIL.getRank(min)
end

function UTIL.getRarityColor(r)
    local cfg = _G.NMHUB and _G.NMHUB.config
    if not cfg then return Color3.fromRGB(235,235,245) end
    local tbl = cfg.RarityColor
    if not tbl then return Color3.fromRGB(235,235,245) end
    local col = tbl[r]
    if not col then return Color3.fromRGB(235,235,245) end
    return col
end

function UTIL.getFriends()
    return {}
end

function UTIL.ensureInfoQueue()
    if not _G.NMHUB then return {} end
    _G.NMHUB.registry = _G.NMHUB.registry or {}
    _G.NMHUB.registry.info = _G.NMHUB.registry.info or {}
    return _G.NMHUB.registry.info
end

function UTIL.pushInfo(e)
    local q = UTIL.ensureInfoQueue()
    local cfg = _G.NMHUB and _G.NMHUB.config
    local max = 10
    if cfg and cfg.Info and cfg.Info.MaxSlots then
        max = cfg.Info.MaxSlots
    end
    e = e or {}
    e.timestamp = e.timestamp or 0
    e.expired = false
    table.insert(q, 1, e)
    while #q > max do
        table.remove(q, #q)
    end
    return q
end

function UTIL.clearInfo()
    local q = UTIL.ensureInfoQueue()
    for i = #q, 1, -1 do
        q[i] = nil
    end
end

function UTIL.getClock()
    return "00:00"
end

function UTIL.hasFileAPI()
    return false
end

function UTIL.saveTable(path, tbl)
    return false
end

function UTIL.loadTable(path)
    return nil
end

function UTIL.getRemote(path)
    return nil
end

function UTIL.fireRF(path, ...)
    return nil
end

function UTIL.fireRE(path, ...)
    return false
end

function UTIL.magnitude(a, b)
    if not a or not b then return math.huge end
    local pa = a.Position
    local pb = b.Position
    if not pa or not pb then return math.huge end
    return (pa - pb).Magnitude
end

function UTIL.forEachDescendant(root, class, cb)
    if not root then return end
    for _, v in ipairs(root:GetDescendants()) do
        if v:IsA(class) then
            UTIL.safeCall(cb, v)
        end
    end
end

return UTIL
