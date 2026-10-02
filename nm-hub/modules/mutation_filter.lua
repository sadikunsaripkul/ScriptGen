-- NM-HUB — modules/mutation_filter.lua
-- Tapis telur ikut mutasi. Mutasi sah (data komuniti Sep 2026):
-- Silver 1.2x, Bloom 1.25x, Golden 2.5x, Fractured ~2.75x, Scrambled ~2.75x,
-- Parasite 3x, Rainbow 3.5x, Spirit Bloom 3x, Luminous 10x
local M = {}
M.state = false
M.cfg = nil

M.MUTATIONS = {
	{ name = "Luminous", mult = 10 },
	{ name = "Rainbow", mult = 3.5 },
	{ name = "Parasite", mult = 3 },
	{ name = "Spirit Bloom", mult = 3 },
	{ name = "Fractured", mult = 2.75 },
	{ name = "Scrambled", mult = 2.75 },
	{ name = "Golden", mult = 2.5 },
	{ name = "Bloom", mult = 1.5 },
	{ name = "Silver", mult = 1.2 },
}

function M.filters()
	local H = _G.NMHUB
	H.filters = H.filters or {}
	H.filters.mutations = H.filters.mutations or {}
	return H.filters.mutations
end

-- tetapkan senarai mutasi yang diterima (nama tepat)
function M.setAllowed(list)
	local f = M.filters()
	for k in pairs(f) do f[k] = nil end
	for _, n in ipairs(list or {}) do f[n] = true end
end

function M.allow(name, on)
	M.filters()[name] = on ~= false
end

-- adakah senarai kosong (tiada tapisan)?
function M.isEmpty()
	local f = M.filters()
	for _ in pairs(f) do return false end
	return true
end

function M.isAllowed(name)
	if M.isEmpty() then return true end
	return M.filters()[name] == true
end

-- kesan mutasi telur daripada model (heuristik: nama + atribut)
function M.eggMutation(model)
	if not model then return nil end
	local attrs = { "Mutation", "EggMutation", "PetMutation" }
	for _, a in ipairs(attrs) do
		local v = model:GetAttribute(a)
		if type(v) == "string" and #v > 0 then return v end
	end
	local n = model.Name
	for _, m in ipairs(M.MUTATIONS) do
		if n:lower():find(m.name:lower(), 1, true) then return m.name end
	end
	return nil
end

function M.start(cfg)
	if M.state then return end
	M.state = true
	M.cfg = cfg
end
function M.stop() M.state = false end
function M.setConfig(cfg) M.cfg = cfg end
return M
