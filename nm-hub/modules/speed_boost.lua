-- NM-HUB — modules/speed_boost.lua
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local M = {}
M.state = false
M.cfg = nil
M.saved = nil
M.conn = nil

local function humanoid()
	local c = player.Character
	return c and c:FindFirstChildOfClass("Humanoid")
end

function M.start(cfg)
	if M.state then return end
	M.state = true
	M.cfg = cfg
	local h = humanoid()
	if h then
		M.saved = h.WalkSpeed
		h.WalkSpeed = (cfg and cfg.WalkSpeed) or 32
	end
	M.conn = player.CharacterAdded:Connect(function(c)
		task.wait(0.5)
		local hh = c:FindFirstChildOfClass("Humanoid")
		if hh and M.state then hh.WalkSpeed = (M.cfg and M.cfg.WalkSpeed) or 32 end
	end)
end

function M.stop()
	M.state = false
	if M.conn then M.conn:Disconnect(); M.conn = nil end
	local h = humanoid()
	if h and M.saved then h.WalkSpeed = M.saved end
	M.saved = nil
end

function M.setConfig(cfg) M.cfg = cfg end
return M
