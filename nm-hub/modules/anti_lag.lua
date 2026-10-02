-- NM-HUB — modules/anti_lag.lua — matikan kesan berat (partikel, bayang, post FX)
local Lighting = game:GetService("Lighting")
local Terrain = workspace:FindFirstChildOfClass("Terrain")

local M = {}
M.state = false
M.cfg = nil
M.saved = nil
M.conns = {}

local function killClass(className, prop)
	local n = 0
	for _, d in ipairs(workspace:GetDescendants()) do
		if d:IsA(className) then
			if M.saved[d] == nil then M.saved[d] = d[prop] end
			d[prop] = false
			n += 1
		end
	end
	return n
end

function M.start(cfg)
	if M.state then return end
	M.state = true
	M.cfg = cfg
	M.saved = {}
	if cfg and cfg.AntiLag_Shadows ~= false then
		M.saved.GlobalShadows = Lighting.GlobalShadows
		Lighting.GlobalShadows = false
	end
	if cfg and cfg.AntiLag_PostFX ~= false then
		for _, e in ipairs(Lighting:GetChildren()) do
			if e:IsA("PostEffect") then
				M.saved[e] = e.Enabled
				e.Enabled = false
			end
		end
	end
	if cfg and cfg.AntiLag_Particles ~= false then
		killClass("ParticleEmitter", "Enabled")
		killClass("Trail", "Enabled")
		killClass("Sparkles", "Enabled")
		killClass("Smoke", "Enabled")
		killClass("Fire", "Enabled")
	end
	table.insert(M.conns, workspace.DescendantAdded:Connect(function(d)
		if not M.state then return end
		if d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Sparkles") or d:IsA("Smoke") or d:IsA("Fire") then
			task.defer(function() d.Enabled = false end)
		end
	end))
end

function M.stop()
	M.state = false
	for _, c in ipairs(M.conns) do pcall(function() c:Disconnect() end) end
	M.conns = {}
	if M.saved then
		for obj, val in pairs(M.saved) do
			pcall(function()
				if obj == Lighting then return end
				if typeof(obj) == "boolean" then return end
				obj.Enabled = val
			end)
		end
		if M.saved.GlobalShadows ~= nil then Lighting.GlobalShadows = M.saved.GlobalShadows end
	end
	M.saved = nil
end

function M.setConfig(cfg) M.cfg = cfg end
return M
