-- NM-HUB — modules/server_guard.lua
-- Pantau bilangan pemain; Auto-Hop bila bawah minimum.
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local M = {}
M.state = false
M.cfg = nil
M.lastAction = 0

local function action()
	return (M.cfg and M.cfg.ServerGuard_Action) or "Notify Only"
end

local function hopMin()
	return (M.cfg and M.cfg.ServerGuard_HopMin) or 15
end

local function step()
	local n = #Players:GetPlayers()
	if n >= hopMin() then return end
	if os.clock() - M.lastAction < 30 then return end
	M.lastAction = os.clock()
	if action() == "Auto-Hop" then
		warn("[NMHUB] ServerGuard: pemain " .. n .. " < " .. hopMin() .. ", hop server")
		pcall(function() TeleportService:Teleport(game.PlaceId) end)
	elseif action() == "Auto-Leave" then
		warn("[NMHUB] ServerGuard: pemai " .. n .. " rendah")
	end
end

function M.start(cfg)
	if M.state then return end
	M.state = true
	M.cfg = cfg
	task.spawn(function()
		while M.state do
			pcall(step)
			task.wait(10)
		end
	end)
end

function M.stop() M.state = false end
function M.setConfig(cfg) M.cfg = cfg end
return M
