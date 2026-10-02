-- NM-HUB — modules/friends_drop.lua
-- Serahkan telur kepada rakan berhampiran: pergi ke rakan, drop telur, balik.
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local M = {}
M.state = false
M.cfg = nil
M.friends = {}

local function net(name)
	local p = RS:FindFirstChild("Packages")
	local n = p and p:FindFirstChild("Networking")
	return n and n:FindFirstChild(name)
end

local function rootOf(p)
	local c = p.Character
	return c and c:FindFirstChild("HumanoidRootPart")
end

-- senarai rakan sebenar dalam server ini
function M.refreshFriends()
	M.friends = {}
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player then
			local ok, isF = pcall(function() return player:IsFriendsWith(p.UserId) end)
			if ok and isF then M.friends[#M.friends + 1] = p end
		end
	end
	return M.friends
end

local function nearestFriend(r)
	M.refreshFriends()
	local best, bd
	for _, f in ipairs(M.friends) do
		local fr = rootOf(f)
		if fr then
			local d = (fr.Position - r.Position).Magnitude
			if not bd or d < bd then best, bd = f, d end
		end
	end
	return best, bd
end

local function heldEgg()
	local c = player.Character
	if not c then return nil end
	for _, i in ipairs(c:GetChildren()) do
		if i:IsA("Tool") and i.Name:lower():find("egg") then return i end
	end
	return nil
end

local function step()
	local r = rootOf(player)
	if not r or not heldEgg() then return end
	local f, d = nearestFriend(r)
	if not f or d > ((M.cfg and M.cfg.FriendsDropDist) or 50) then return end
	local steal = _G.NMHUB and _G.NMHUB.modules and _G.NMHUB.modules.auto_steal
	if steal and steal.state then steal.stop() end
	local fr = rootOf(f)
	if fr then
		r.CFrame = fr.CFrame + Vector3.new(0, 3, 0)
		local drop = net("RF/EggWorld/AskFieldEggDrop")
		if drop then pcall(function() drop:InvokeServer() end) end
	end
end

function M.start(cfg)
	if M.state then return end
	M.state = true
	M.cfg = cfg
	M.refreshFriends()
	task.spawn(function()
		while M.state do
			pcall(step)
			task.wait((M.cfg and M.cfg.FriendsWaitTime) or 5)
		end
	end)
end

function M.stop() M.state = false end
function M.setConfig(cfg) M.cfg = cfg end
return M
