-- NM-HUB — loader.lua
local BASE = "https://raw.githubusercontent.com/sadikunsaripkul/ScriptGen/main/nm-hub/"

local function fetch(path)
    local ok, res = pcall(function() return game:HttpGet(BASE .. path) end)
    if not ok or not res or #res < 10 then return nil end
    return res
end

local function compile(src, name)
    if not src then return nil end
    local fn, err
    if type(loadstring) == "function" then
        fn, err = loadstring(src, name)
    elseif type(load) == "function" then
        fn, err = load(src, name)
    end
    if not fn then return nil, err end
    return fn
end

local function safeLoad(path)
    local src = fetch(path)
    if not src then warn("[NMHUB] fetch nil: "..path) return nil end
    local fn, cerr = compile(src, path)
    if not fn then warn("[NMHUB] compile err "..path..": "..tostring(cerr)) return nil end
    local ok, res = pcall(fn)
    if not ok then warn("[NMHUB] run err "..path..": "..tostring(res)) return nil end
    return res
end

local CONFIG = safeLoad("config.lua")
if not CONFIG then return end

local UTIL = safeLoad("core3.lua")
local EGGMAP = safeLoad("config_eggmap.lua")
if not UTIL then return end

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

-- window dulu
if NMHUB.ui.window then
    local okW, win = pcall(function() return NMHUB.ui.window.new(NM-HUB) end)
    if okW and win then
        NMHUB.windowInstance = win

        -- pages
        if NMHUB.ui.pages then
            local okP, pagesErr = pcall(function()
                NMHUB.pagesInstance = NMHUB.ui.pages.new(NM-HUB, win)
            end)
            if not okP then warn("[NMHUB] pages err: "..tostring(pagesErr)) end
        else
            warn("[NMHUB] ui.pages nil")
        end

        -- bubble
        if NMHUB.ui.bubble then
            local okB, bub = pcall(function() return NMHUB.ui.bubble.new(NM-HUB) end)
            if okB and bub then
                NMHUB.bubbleInstance = bub
                bub.onClick = function() win:toggle() end
            else
                warn("[NMHUB] bubble err: "..tostring(bub))
            end
        end
    else
        warn("[NMHUB] window err: "..tostring(win))
    end
end

NMHUB.loaded = true
warn("[NMHUB] loaded v"..NM-HUB.version)
