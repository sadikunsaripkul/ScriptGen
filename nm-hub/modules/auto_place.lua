-- NM-HUB — modules/auto_place.lua — letak telur yang sedang dipegang sekarang
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local M = {}
M.state = false
M.cfg = nil

local function net(name)
	local p = RS:FindFirstChild("Packages")
	local n = p and p:FindFirstChild("Networking")
	return n and n:FindFirstChild(name)
end

local function heldEgg()
	local c = player.Character
	if not c then return nil end
	for _, i in ipairs(c:GetChildren()) do
		if i:IsA("Tool") and i.Name:lower():find("egg") then return i end
	end
	return nil
end

function M.placeNow()
	local held = heldEgg()
	local uid = held and held:GetAttribute("UID")
	if not uid then return false end
	local place = net("RF/EggWorld/AskPlaceEgg")
	if place then
		local ok = pcall(function() place:InvokeServer({ LocalCFrame = CFrame.new(0, 0, 0), Uid = uid }) end)
		return ok
	end
	local drop = net("RF/EggWorld/AskFieldEggDrop")
	if drop then return pcall(function() drop:InvokeServer() end) end
	return false
end

function M.start(cfg)
	if M.state then return end
	M.state = true
	M.cfg = cfg
	task.spawn(function()
		while M.state do
			pcall(M.placeNow)
			task.wait(1)
		end
	end)
end

function M.stop() M.state = false end
function M.setConfig(cfg) M.cfg = cfg end
return M
