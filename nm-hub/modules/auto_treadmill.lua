-- NM-HUB — modules/auto_treadmill.lua — pergi treadmill berhampiran base & naikkan tier
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local TREADMILL_PAD = 6

local M = {}
M.state = false
M.cfg = nil

local function net(name)
	local p = RS:FindFirstChild("Packages")
	local n = p and p:FindFirstChild("Networking")
	return n and n:FindFirstChild(name)
end

local function treadmillRects()
	local rects, seen = {}, {}
	local rf = workspace:FindFirstChild("__ClientTreadmillRenders")
	for _, m in ipairs(rf and rf:GetChildren() or {}) do
		local slot = m.Name:match("^TreadmillRender_(.+)$")
		if slot and m:IsA("Model") and not seen[slot] then
			seen[slot] = true
			local ok, cf, size = pcall(m.GetBoundingBox, m)
			if ok then
				local hx, hz = size.X / 2 + TREADMILL_PAD, size.Z / 2 + TREADMILL_PAD
				local p = cf.Position
				rects[#rects + 1] = { minX = p.X - hx, maxX = p.X + hx, minZ = p.Z - hz, maxZ = p.Z + hz, cx = p.X, cz = p.Z, y = p.Y }
			end
		end
	end
	local plots = workspace:FindFirstChild("Plots")
	for _, plot in ipairs(plots and plots:GetChildren() or {}) do
		local bottom = plot:FindFirstChild("TreadmillBottom")
		if bottom and bottom:IsA("BasePart") and not seen[plot.Name] then
			seen[plot.Name] = true
			local hx, hz = bottom.Size.X / 2 + TREADMILL_PAD, bottom.Size.Z / 2 + TREADMILL_PAD
			local p = bottom.Position
			rects[#rects + 1] = { minX = p.X - hx, maxX = p.X + hx, minZ = p.Z - hz, maxZ = p.Z + hz, cx = p.X, cz = p.Z, y = p.Y }
		end
	end
	return rects
end

function M.step()
	local steal = _G.NMHUB and _G.NMHUB.modules and _G.NMHUB.modules.auto_steal
	local home = steal and steal.getStatus and steal.getStatus().home
	local c = player.Character
	local r = c and c:FindFirstChild("HumanoidRootPart")
	if not r then return end
	local best, bd
	for _, rc in ipairs(treadmillRects()) do
		local d = home and (Vector3.new(rc.cx, 0, rc.cz) - Vector3.new(home.X, 0, home.Z)).Magnitude or 0
		if not bd or d < bd then best, bd = rc, d end
	end
	if not best then return end
	if r.Position.X > best.minX and r.Position.X < best.maxX and r.Position.Z > best.minZ and r.Position.Z < best.maxZ then
		local raise = net("RF/Treadmill/AskTierRaise")
		if raise then pcall(function() raise:InvokeServer() end) end
		return
	end
	-- pergi ke treadmill hanya jika auto_steal tak berjalan
	if steal and steal.state then return end
	local h = c:FindFirstChildOfClass("Humanoid")
	if h then h:MoveTo(Vector3.new(best.cx, best.y + 3, best.cz)) end
end

function M.start(cfg)
	if M.state then return end
	M.state = true
	M.cfg = cfg
	task.spawn(function()
		while M.state do
			pcall(M.step)
			task.wait((cfg and cfg.TreadmillInterval) or 1)
		end
	end)
end

function M.stop() M.state = false end
function M.setConfig(cfg) M.cfg = cfg end
return M
