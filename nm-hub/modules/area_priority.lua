-- NM-HUB — modules/area_priority.lua
-- Keutamaan kawasan: simpan pilihan, auto_steal membacanya melalui filters.area.
local M = {}
M.state = false
M.cfg = nil

function M.filters()
	local H = _G.NMHUB
	H.filters = H.filters or {}
	return H.filters
end

function M.setArea(name)
	if name == nil or name == "All" then
		M.filters().area = nil
	else
		M.filters().area = name
	end
end

function M.getArea()
	return M.filters().area
end

function M.start(cfg)
	if M.state then return end
	M.state = true
	M.cfg = cfg
end
function M.stop() M.state = false end
function M.setConfig(cfg) M.cfg = cfg end
return M
