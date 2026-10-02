-- NM-HUB — Steal An Egg — config.lua

local CONFIG = {}

CONFIG.BASE_URL = "https://raw.githubusercontent.com/sadikunsaripkul/ScriptGen/main/nm-hub/"
CONFIG.VERSION  = "0.3.0"
CONFIG.GAME     = "Steal An Egg"

-- ASSETS
CONFIG.Assets = {
    Logo = "rbxassetid://114651091062453",
}

-- THEME
CONFIG.Theme = {
    Purple     = Color3.fromRGB(138,  92, 246),
    PurpleGlow = Color3.fromRGB(168,  85, 247),
    Blue       = Color3.fromRGB( 59, 130, 246),
    BlueGlow   = Color3.fromRGB( 96, 165, 250),
    Background = Color3.fromRGB( 12,  12,  18),
    Surface    = Color3.fromRGB( 22,  22,  32),
    SurfaceAlt = Color3.fromRGB( 30,  30,  44),
    Text       = Color3.fromRGB(235, 235, 245),
    SubText    = Color3.fromRGB(150, 150, 175),
    Border     = Color3.fromRGB( 60,  50, 100),
    Success    = Color3.fromRGB( 34, 197,  94),
    Danger     = Color3.fromRGB(239,  68,  68),
}

-- UI
CONFIG.UI = {
    BubbleSize         = 56,
    BubbleOutline      = 3,
    BubbleOutlineColor = CONFIG.Theme.Purple,
    BubbleGlow         = true,
    BubbleGlowColor    = CONFIG.Theme.PurpleGlow,
    WindowSize         = Vector2.new(640, 440),
    CornerRadius       = 10,
    ToggleKey          = Enum.KeyCode.RightShift,
    TabList            = { "Visual", "Farm", "Friends", "Info", "Settings" },
}

-- RARITY
CONFIG.RarityOrder = {
    "Common","Uncommon","Rare","Epic","Legendary",
    "Mythic","Cosmic","Secret","Eternal","Divine",
}
CONFIG.RarityRank = {
    Common=1, Uncommon=2, Rare=3, Epic=4, Legendary=5,
    Mythic=6, Cosmic=7, Secret=8, Eternal=9, Divine=10,
}
CONFIG.RarityColor = {
    Common    = Color3.fromRGB(180,180,180),
    Uncommon  = Color3.fromRGB(120,220,120),
    Rare      = Color3.fromRGB( 90,160,255),
    Epic      = Color3.fromRGB(180,100,255),
    Legendary = Color3.fromRGB(255,180, 60),
    Mythic    = Color3.fromRGB(255, 90, 90),
    Cosmic    = Color3.fromRGB(120, 90,255),
    Secret    = Color3.fromRGB(255, 50,180),
    Eternal   = Color3.fromRGB( 60,255,220),
    Divine    = Color3.fromRGB(255,240,120),
}

-- BIOME
CONFIG.Biomes = {
    "Forest","Lake","Desert","Jungle","Snow",
    "Volcano","Abyss","Prehistoric","Cosmic",
}

-- MUTATION
CONFIG.Mutations = { "Rainbow","Golden","Silver","Fractured","Luminous" }

-- REMOTES (dari recon)
CONFIG.Remotes = {
    Base = "ReplicatedStorage.Packages.Networking",
    EggCarry        = "RF/EggWorld/AskFieldEggCarry",
    EggDrop         = "RF/EggWorld/AskFieldEggDrop",
    EggPlace        = "RF/EggWorld/AskPlaceEgg",
    EggSnapshot     = "RF/EggWorld/AskFieldEggSnapshot",
    EggLiveSnapshot = "RF/EggWorld/AskLiveSnapshot",
    EggRarities     = "RF/EggWorld/AskFieldEggRarityShows",
    Hatch           = "RF/EggWorld/AskHatch",
    FinishHatch     = "RF/EggWorld/AskFinishHatch",
    WearTool        = "RF/EggWorld/AskWearTool",
    DoffTool        = "RF/EggWorld/AskDoffTool",
    WearBest        = "RF/Haul/WearBest",
    TreadmillRaise  = "RF/Treadmill/AskTierRaise",
    LobbyHop        = "RE/Homestead/AskLobbyHop",
    LiveScheduled   = "RF/LiveEvents/FetchScheduled",
    LiveCatalogue   = "RF/LiveEvents/FetchCatalogue",
    LiveRecurring   = "RF/LiveEvents/FetchRecurringEta",
    GuardWarning    = "RE/GuardPatrol/SpeedTollWarning",
    GuardRouse      = "RE/GuardPatrol/Rouse",
    Toasts          = "RE/Toasts/Line",
    Payouts         = "RE/Payouts/Shower",
}

-- DEFAULTS
CONFIG.Defaults = {
    ESP_Egg = false, ESP_MinRarity = "Rare", ESP_BiomeFilter = "All",
    ESP_MaxDistance = 500, ESP_ShowTier = true, ESP_ShowDistance = true, ESP_ShowTracer = false,

    Invisible = false, Invisible_Mode = "Notify Only", Invisible_SafeDist = 30,
    Invisible_Ghost = true, Invisible_HideName = true,
    Invisible_Radar = true, Invisible_IgnoreGuardian = false,

    AutoSteal = false, StealMode = "Teleport", SelectRarity = "Rarest",
    StealDelay = 0.2, IgnoreGuardian = false,

    AutoHatch = false, HatchSpeed = "Normal",
    AutoPlace = false, PlaceMode = "Best First",
    AutoTreadmill = false, TreadmillInterval = 1.0,
    SpeedBoost = false, WalkSpeed = 32,

    FriendsDrop = false, FriendsTarget = nil,
    FriendsDropDist = 50, FriendsWaitTime = 5.0, FriendsAutoBack = true,

    Info_MinRarity = "Secret", Info_ShowExpired = false, Info_AutoTrack = true,

    AntiLag = false, AntiLag_FPS = 60, AntiLag_Particles = true,
    AntiLag_Shadows = true, AntiLag_Textures = false,
    AntiLag_PostFX = true, AntiLag_Terrain = false,

    ServerGuard = false, ServerGuard_Action = "Notify Only",
    ServerGuard_HopMin = 15, ServerGuard_WhitelistOnly = false,

    Debug_Console = false, SafeMode = true,
}

-- MODULE CONFIG
CONFIG.Invisible = {
    Modes = { "Off", "Auto-Hide", "Auto-Teleport", "Notify Only" },
    SafeDistRange = { 10, 200 },
    RadarColor = Color3.fromRGB(255, 90, 90),
    AlertColor = Color3.fromRGB(255, 50, 50),
}

CONFIG.ServerGuard = {
    ActionList = { "Auto-Leave", "Auto-Hop", "Notify Only" },
    HopMinRange = { 1, 120 }, DefaultHopMin = 15,
    KickDelay = 1.0, HopDelay = 3.0,
    Whitelist = {}, Persist = true,
    SavePath = "or4cle_serverguard.json",
}

CONFIG.Info = {
    MaxSlots = 10, MinRarity = "Secret",
    ShowExpired = false, AutoTrack = true, RefreshRate = 1.0,
}

CONFIG.Farm = {
    StealModes   = { "Teleport", "Idle" },
    SelectRarity = { "Rarest", "Biggest", "Nearest", "Fastest" },
    HatchSpeeds  = { "Safe", "Normal", "Turbo" },
    PlaceModes   = { "Best First", "FIFO", "Rarity Only" },
}

CONFIG.AntiLag = {
    FPSOptions = { 30, 45, 60, 0 },
    KillParticles = true, KillShadows = true,
    KillTextures = false, KillPostFX = true, LowerTerrain = false,
}

CONFIG.Keybinds = { ToggleUI = Enum.KeyCode.RightShift }
CONFIG.Debug = false

return CONFIG
