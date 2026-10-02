-- NM-HUB — loader.lua (diagnostik penuh)
local BASE = "https://raw.githubusercontent.com/sadikunsaripkul/ScriptGen/main/nm-hub/"

local function log(...)
	print("[NMHUB]", ...)
end
local function fail(msg)
	warn("[NMHUB] GAGAL: " .. tostring(msg))
	-- GUI ralat yang sentiasa kelihatan supaya kegagalan tidak senyap
	pcall(function()
		local Players = game:GetService("Players")
		local pg = Players.LocalPlayer:WaitForChild("PlayerGui", 5)
		if not pg then return end
		local g = Instance.new("ScreenGui")
		g.Name = "NMHUB_Error"
		g.ResetOnSpawn = false
		g.Parent = pg
		local f = Instance.new("Frame")
		f.Size = UDim2.fromOffset(420, 90)
		f.Position = UDim2.new(0.5, -210, 0.5, -45)
		f.BackgroundColor3 = Color3.fromRGB(40, 12, 12)
		f.Parent = g
		Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
		local t = Instance.new("TextLabel")
		t.Size = UDim2.new(1, -16, 1, -16)
		t.Position = UDim2.fromOffset(8, 8)
		t.BackgroundTransparency = 1
		t.TextWrapped = true
		t.TextColor3 = Color3.fromRGB(255, 200, 200)
		t.Font = Enum.Font.Gotham
		t.TextSize = 13
		t.Text = "NM-HUB gagal dimuat:\n" .. tostring(msg) .. "\n(tampal ini kepada pemaju)"
		t.Parent = f
	end)
end

local function fetch(path)
	local lastErr
	for attempt = 1, 3 do
		local ok, res = pcall(function()
			return game:HttpGet(BASE .. path .. "?v=" .. tostring(attempt) .. math.floor(os.clock() * 1000))
		end)
		if ok and type(res) == "string" and #res > 10 then
			return res
		end
		lastErr = tostring(res)
		task.wait(0.5)
	end
	fail("muat turun " .. path .. " gagal: " .. lastErr)
	return nil
end

local function compile(src, name)
	if not src then return nil end
	local fn, err
	if type(loadstring) == "function" then
		fn, err = loadstring(src, name)
	elseif type(load) == "function" then
		fn, err = load(src, name)
	end
	if not fn then
		fail("kompil " .. name .. ": " .. tostring(err))
		return nil
	end
	return fn
end

local function safeLoad(path)
	local src = fetch(path)
	if not src then return nil end
	local fn = compile(src, path)
	if not fn then return nil end
	local ok, res = pcall(fn)
	if not ok then
		fail("jalankan " .. path .. ": " .. tostring(res))
		return nil
	end
	return res
end

log("memuat fail... (v0.3.0)")

local CONFIG = safeLoad("config.lua")
if not CONFIG then return end
log("config OK")

local UTIL = safeLoad("core3.lua")
local EGGMAP = safeLoad("config_eggmap.lua")
if not UTIL then return end
log("core OK")

local NMHUB = {
	config=CONFIG, util=UTIL, eggmap=EGGMAP or {}, modules={}, registry={},
	version=CONFIG.VERSION, loaded=false,
}
_G.NMHUB = NMHUB

NMHUB.ui = {
	bubble  = safeLoad("ui/bubble.lua"),
	window  = safeLoad("ui/window.lua"),
	sidebar = safeLoad("ui/sidebar.lua"),
	tabs    = safeLoad("ui/tabs.lua"),
	content = safeLoad("ui/content.lua"),
	pages   = safeLoad("ui/pages3.lua"),
}
NMHUB.components = {
	toggle        = safeLoad("ui/components/toggle.lua"),
	button        = safeLoad("ui/components/button.lua"),
	section       = safeLoad("ui/components/section.lua"),
	option_picker = safeLoad("ui/components/option_picker.lua"),
	search_box    = safeLoad("ui/components/search_box.lua"),
	checklist     = safeLoad("ui/components/checklist.lua"),
	text_input    = safeLoad("ui/components/text_input.lua"),
}

for _, n in ipairs({
	"esp_egg","auto_steal","auto_hatch","auto_place","auto_treadmill",
	"speed_boost","area_priority","mutation_filter","friends_drop",
	"anti_lag","server_guard","info_tracker","invisible",
}) do
	NMHUB.modules[n] = safeLoad("modules/" .. n .. ".lua")
end
log("modul dimuat: auto_steal =", tostring(NMHUB.modules.auto_steal ~= nil))

if NMHUB.ui.window then
	local okW, win = pcall(function() return NMHUB.ui.window.new(NMHUB) end)
	if okW and win then
		NMHUB.windowInstance = win

		if NMHUB.ui.pages then
			local okP, pagesErr = pcall(function()
				NMHUB.pagesInstance = NMHUB.ui.pages.new(NMHUB, win)
			end)
			if not okP then fail("pages err: " .. tostring(pagesErr)) end
		else
			fail("ui.pages nil")
		end

		if NMHUB.ui.bubble then
			local okB, bub = pcall(function() return NMHUB.ui.bubble.new(NMHUB) end)
			if okB and bub then
				NMHUB.bubbleInstance = bub
				bub.onClick = function() win:toggle() end
			else
				fail("bubble err: " .. tostring(bub))
			end
		end

		-- papar tetingkap serta-merta supaya UI pasti kelihatan walaupun gelembung gagal
		if win.show then win:show() end
	else
		fail("window err: " .. tostring(win))
	end
else
	fail("ui.window tidak dimuat")
end

NMHUB.loaded = true
log("LOADED v" .. tostring(NMHUB.version) .. " — tekan RightShift atau klik gelembung")
