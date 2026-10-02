-- NM-HUB — modules/auto_hatch.lua — EKSPERIMEN: remote AskHatch belum disahkan
local RS = game:GetService("ReplicatedStorage")

local M = {}
M.state = false
M.cfg = nil

local function net(name)
	local p = RS:FindFirstChild("Packages")
	local n = p and p:FindFirstChild("Networking")
	return n and n:FindFirstChild(name)
end

function M.start(cfg)
	if M.state then return end
	M.state = true
	M.cfg = cfg
	task.spawn(function()
		while M.state do
			local hatch = net("RF/EggWorld/AskHatch")
			local finish = net("RF/EggWorld/AskFinishHatch")
			if hatch then pcall(function() hatch:InvokeServer() end) end
			if finish then pcall(function() finish:InvokeServer() end) end
			task.wait(2)
		end
	end)
end

function M.stop() M.state = false end
function M.setConfig(cfg) M.cfg = cfg end
return M
