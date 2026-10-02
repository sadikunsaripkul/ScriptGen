-- NM-HUB — modules/info_tracker.lua
-- Jejak telur rarity tinggi; papar dalam tab Info (registry.info).
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local M = {}
M.state = false
M.cfg = nil

local function safeRequire(...)
	local cur = RS
	for _, n in ipairs({ ... }) do
		cur = cur and cur:FindFirstChild(n)
	end
	if not cur then return nil end
	local ok, m = pcall(require, cur)
	return ok and m or nil
end

local EggState = safeRequire("Client", "EggState")
local Assets = safeRequire("Data", "Assets")

local function registry()
	local H = _G.NMHUB
	H.registry = H.registry or {}
	H.registry.info = H.registry.info or {}
	return H.registry.info
end

local function infoOf(rec)
	local info = Assets and Assets.Directory and Assets.Directory[rec.AssetCategory]
	local rar = info and info.Rarity
	return {
		name = (info and info.Egg and info.Egg.DisplayName) or rec.AssetCategory or "?",
		rarity = rar and rar.DisplayName or "?",
		tier = rar and rar.RarityNumber or 0,
	}
end

function M.push(e)
	local q = registry()
	e.timestamp = os.clock()
	e.expired = false
	table.insert(q, 1, e)
	while #q > ((M.cfg and M.cfg.MaxSlots) or 10) do
		table.remove(q, #q)
	end
end

function M.clear()
	local q = registry()
	for i = #q, 1, -1 do q[i] = nil end
end

local function step()
	local q = registry()
	for _, e in ipairs(q) do
		if os.clock() - (e.timestamp or 0) > 60 then e.expired = true end
	end
	if not (EggState and EggState.ReadFieldEggs) then return end
	local ok, snap = pcall(EggState.ReadFieldEggs)
	if not ok or type(snap) ~= "table" or not snap.Records then return end
	local minTier = ((M.cfg and M.cfg.MinRarityNum) or 8)
	local seen = {}
	for _, rec in ipairs(snap.Records) do
		local info = infoOf(rec)
		seen[rec.Uid] = true
		if info.tier >= minTier and not M.known[rec.Uid] then
			M.known[rec.Uid] = true
			if not (M.cfg and M.cfg.ShowExpired == false) then
				M.push({ name = info.name, rarity = info.rarity, tier = info.tier })
			end
		end
	end
	for uid in pairs(M.known) do
		if not seen[uid] then M.known[uid] = nil end
	end
end

function M.start(cfg)
	if M.state then return end
	M.state = true
	M.cfg = cfg
	M.known = {}
	task.spawn(function()
		while M.state do
			pcall(step)
			task.wait((M.cfg and M.cfg.RefreshRate) or 1)
		end
	end)
end

function M.stop()
	M.state = false
	M.known = nil
end
function M.setConfig(cfg) M.cfg = cfg end
return M
