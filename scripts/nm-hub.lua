--[[
	NM-HUB v2 — Steal An Egg
	Base: repo terbuka monthonsova/Steal-An-Egg (EggESP) — dijenamakan NM-HUB.
	Enjin auto steal dipadankan dengan struktur game sebenar (AreaEggSlotsClient,
	RF/EggWorld/AskFieldEggCarry, GuardZone, kitaran siang/malam).
]]

local genv0 = (type(getgenv) == "function" and getgenv()) or _G

local ConfigModule = (function()
--[[
    Theme, layout constants, and shared visual settings.
]]

local Config = {}

Config.Theme = {
    bg = Color3.fromRGB(10, 5, 18),
    bgInner = Color3.fromRGB(18, 10, 32),
    border = Color3.fromRGB(88, 38, 158),
    borderSoft = Color3.fromRGB(58, 26, 102),
    textMain = Color3.fromRGB(238, 230, 255),
    textMuted = Color3.fromRGB(158, 130, 198),
    dotCore = Color3.fromRGB(130, 60, 220),
    dotRing = Color3.fromRGB(180, 100, 255),
    connector = Color3.fromRGB(72, 32, 128),
    shadow = Color3.fromRGB(0, 0, 0),
    treadmillBorder = Color3.fromRGB(200, 150, 255),
    treadmillTag = Color3.fromRGB(255, 210, 90),
    treadmillDotRing = Color3.fromRGB(220, 170, 255),
    treadmillBounds = Color3.fromRGB(190, 120, 255),
    trapOwn = Color3.fromRGB(255, 190, 90),
    trapEnemy = Color3.fromRGB(255, 70, 110),
    trapOwnBorder = Color3.fromRGB(255, 210, 120),
    trapEnemyBorder = Color3.fromRGB(200, 50, 90),
    trapOwnRing = Color3.fromRGB(255, 200, 130),
    trapEnemyRing = Color3.fromRGB(255, 100, 140),
    pathSafe = Color3.fromRGB(90, 255, 170),
    pathFallback = Color3.fromRGB(255, 180, 70),
}

Config.Layout = {
    boxWidth = 220,
    boxWidthMin = 180,
    boxWidthMax = 480,
    trapBoxWidthMin = 180,
    boxHeight = 72,
    stackGap = 6,
    dotRadius = 6,
    labelOffsetY = 42,
    stackNearXFactor = 0.92,
    stackMaxIterations = 32,
    screenSortYTolerance = 8,
    textPaddingX = 12,
    textPaddingY = 10,
    textLine1 = 0,
    textLine2 = 22,
    textLine3 = 44,
    distanceOffsetX = 54,
    accentWidth = 4,
    borderThickness = 1,
    connectorThickness = 2,
    treadmillBoundsPadding = 1.08,
    treadmillBoundsThickness = 2,
    trapBoundsPadding = 1.08,
    trapBoundsThickness = 2,
    pathLineThickness = 3,
    studsPerMeter = 1 / 0.28,
    hubPanelWidth = 280,
    hubRowHeight = 26,
    hubPadding = 10,
}

Config.Drawing = {
    font = Drawing.Fonts and Drawing.Fonts.UI or 2,
    textNameSize = 18,
    textRaritySize = 15,
    textDistanceSize = 14,
    keys = {
        "dot",
        "dotRing",
        "connector",
        "shadow",
        "box",
        "boxInner",
        "boxBorder",
        "accent",
        "accentTop",
        "textName",
        "textRarity",
        "textDistance",
    },
}

Config.Runtime = {
    maxDistance = 200,
    positionYOffset = 1.2,
    showTreadmill = true,
    showTreadmillBounds = true,
    showTraps = true,
    showTrapBounds = true,
    espRefreshInterval = 0.2,
    logicTickInterval = 0.15,
    hubStatusRefreshInterval = 1.5,
    eggDataCacheTtl = 0.5,
    speedBypassApplyInterval = 0.25,
    speedBypassMaintenanceInterval = 3,
    speedBypassBlockPivotAlways = false,
    obstacleCacheTtl = 1.0,
    treadmillYOffset = 2.5,
    pathCellSize = 4,
    pathSearchRadius = 220,
    pathSearchMargin = 20,
    pathObstaclePadding = 6,
    pathTreadmillPadding = 10,
    pathTrapPadding = 8,
    pathMaxCells = 9000,
    pathMaxIterations = 12000,
    pathRecalcInterval = 1.2,
    pathRecalcMoveThreshold = 6,
    pathDrawYOffset = 0.35,
    pathAvoidOwnTraps = false,
    pathLineThickness = 3,
    autoFarmEnabled = false,
    autoFarmRarities = nil,
    autoFarmZones = nil,
    autoFarmWalkSpeed = 300,
    antiLagbackSnapThreshold = 25,
    speedBypassOnAutoFarm = false,
    hubVisible = true,
    hubToggleKey = Enum.KeyCode.G,
    standbyPosition = Vector3.new(529.9063110351562, 71.74234771728516, -362.6047058105469),
    standbyStartRadius = 3,
    standbyArriveRadius = 6,
    pickupApproachRadius = 32,
    pickupCarryRadius = 8,
    pickupMoveRadius = 12,
    pickupSyncWalkSpeed = 24,
    pickupSyncSettleTicks = 4,
    autoFarmWalkPickupSync = true,
    depositApproachRadius = 24,
    pathWaypointRadius = 5,
    tweenSpeed = 700,
    movementHumanoidClone = true,
    guardZoneForceWalk = false,
    guardZoneWalkApproach = 80,
    guardZoneWalkSpeed = nil,
    autoFarmMutantOnly = false,
    autoFarmInfestedFirst = true,
    autoFarmInfestedOnly = false,
    autoFarmMaxRarityTierLock = true,
    autoFeedParasiteEnabled = true,
    autoFarmFilterWhitelist = true,
    autoFarmTargetRefreshInterval = 1.2,
    autoFarmPickupMaxFails = 5,
    autoFarmPhaseTimeout = 90,
    autoFarmPickupTimeout = 60,
    autoFarmDepositTimeout = 45,
    autoFarmStandbyStartTimeout = 30,
    autoFarmProgressMinDist = 3,
    autoFarmStuckTimeout = 22,
    autoFarmStandbyStallTimeout = 10,
    autoFarmPathStuckTicks = 25,
    waitForDayBeforeFarm = true,
    inventoryPlacementStep = 4,
    inventoryFeedRadius = 12,
    inventoryPlaceAttemptsPerTick = 8,
    inventoryMaxPlaceAttemptsPerEgg = 6,
    inventoryPlotFailStreak = 2,
    autoSellEnabled = false,
    autoSellFilterWhitelist = true,
    autoSellRarities = nil,
    autoSellInterval = 1.5,
    autoPlaceEnabled = true,
    autoPlaceInterval = 60,
    autoPlaceBatchSize = 5,
    autoPlaceAtStandbyOnly = true,
    autoDumpWorstEggsEnabled = true,
    autoDumpWorstEggCount = 10,
    autoDumpWorstEggCooldown = 15,
    autoPetCareEnabled = true,
    autoHatchEnabled = true,
    autoEquipBest = true,
    autoFuseEnabled = true,
    autoFuseMinCount = 3,
    equipBestCooldown = 5,
    autoUpgradeBasePen = true,
    autoCollectPenMoney = true,
    penCollectInterval = 20,
    penUpgradeCheckInterval = 10,
    penCollectAtStandbyOnly = true,
    penCollectVisitPen = true,
    penUpgradeAtStandbyOnly = true,
    penCollectArriveRadius = 8,
    penCollectClaimCooldown = 3,
    penAreaClaimScale = 0.74,
}

return Config

end)()

local UtilModule = (function()
--[[
    Shared helpers: math, screen projection, text formatting.
]]

local Util = {}

function Util.formatDistance(studs)
    if studs >= 1000 then
        return string.format("%.1fkm", studs / 1000)
    end

    return string.format("%dm", math.floor(studs + 0.5))
end

function Util.rectsOverlap(ax, ay, aw, ah, bx, by, bw, bh)
    return ax < bx + bw and ax + aw > bx and ay < by + bh and ay + ah > by
end

function Util.worldToScreen(camera, worldPos)
    local screenPos, onScreen = camera:WorldToViewportPoint(worldPos)
    return Vector2.new(screenPos.X, screenPos.Y), onScreen, screenPos.Z
end

function Util.isValidScreenPoint(pos)
    if not pos then
        return false
    end

    return pos.X == pos.X and pos.Y == pos.Y
        and math.abs(pos.X) < 100000
        and math.abs(pos.Y) < 100000
end

function Util.isReasonableScreenLine(from, to, viewportSize)
    if not Util.isValidScreenPoint(from) or not Util.isValidScreenPoint(to) then
        return false
    end

    local dx = to.X - from.X
    local dy = to.Y - from.Y
    local maxLen = math.max(viewportSize.X, viewportSize.Y) * 2.5

    return (dx * dx + dy * dy) <= maxLen * maxLen
end

function Util.clipWorldEdge(worldA, worldB, depthA, depthB, minDepth)
    minDepth = minDepth or 0.05

    if depthA <= minDepth and depthB <= minDepth then
        return nil, nil, false
    end

    local pointA, pointB = worldA, worldB

    if depthA <= minDepth then
        local delta = depthB - depthA

        if math.abs(delta) < 1e-6 then
            return nil, nil, false
        end

        local t = (minDepth - depthA) / delta

        if t <= 0 or t >= 1 then
            return nil, nil, false
        end

        pointA = worldA:Lerp(worldB, t)
    elseif depthB <= minDepth then
        local delta = depthA - depthB

        if math.abs(delta) < 1e-6 then
            return nil, nil, false
        end

        local t = (minDepth - depthB) / delta

        if t <= 0 or t >= 1 then
            return nil, nil, false
        end

        pointB = worldB:Lerp(worldA, t)
    end

    return pointA, pointB, true
end

function Util.projectBoxEdge(camera, worldA, worldB)
    local posA, _, depthA = Util.worldToScreen(camera, worldA)
    local posB, _, depthB = Util.worldToScreen(camera, worldB)
    local clipA, clipB, ok = Util.clipWorldEdge(worldA, worldB, depthA, depthB)

    if not ok then
        return nil, nil, false
    end

    if clipA ~= worldA then
        posA = Util.worldToScreen(camera, clipA)
    end

    if clipB ~= worldB then
        posB = Util.worldToScreen(camera, clipB)
    end

    local _, _, finalDepthA = Util.worldToScreen(camera, clipA)
    local _, _, finalDepthB = Util.worldToScreen(camera, clipB)

    if finalDepthA <= 0.05 or finalDepthB <= 0.05 then
        return nil, nil, false
    end

    if not Util.isReasonableScreenLine(posA, posB, camera.ViewportSize) then
        return nil, nil, false
    end

    return posA, posB, true
end

function Util.projectPathSegment(camera, worldA, worldB)
    return Util.projectBoxEdge(camera, worldA, worldB)
end

function Util.metersToStuds(meters)
    return meters * (1 / 0.28)
end

function Util.getPartWorldAABB(part)
    local cf = part.CFrame
    local size = part.Size
    local hx = size.X * 0.5
    local hy = size.Y * 0.5
    local hz = size.Z * 0.5
    local minX, minY, minZ = math.huge, math.huge, math.huge
    local maxX, maxY, maxZ = -math.huge, -math.huge, -math.huge

    for _, sx in ipairs({ -1, 1 }) do
        for _, sy in ipairs({ -1, 1 }) do
            for _, sz in ipairs({ -1, 1 }) do
                local point = cf:PointToWorldSpace(Vector3.new(hx * sx, hy * sy, hz * sz))
                minX = math.min(minX, point.X)
                minY = math.min(minY, point.Y)
                minZ = math.min(minZ, point.Z)
                maxX = math.max(maxX, point.X)
                maxY = math.max(maxY, point.Y)
                maxZ = math.max(maxZ, point.Z)
            end
        end
    end

    return minX, minY, minZ, maxX, maxY, maxZ
end

function Util.mergeAABB(aMinX, aMinY, aMinZ, aMaxX, aMaxY, aMaxZ, bMinX, bMinY, bMinZ, bMaxX, bMaxY, bMaxZ)
    return
        math.min(aMinX, bMinX),
        math.min(aMinY, bMinY),
        math.min(aMinZ, bMinZ),
        math.max(aMaxX, bMaxX),
        math.max(aMaxY, bMaxY),
        math.max(aMaxZ, bMaxZ)
end

function Util.groundBoundsFromAABB(minX, minY, minZ, maxX, maxY, maxZ, paddingXZ, groundY)
    paddingXZ = paddingXZ or 1.05

    local halfX = (maxX - minX) * 0.5 * paddingXZ
    local halfZ = (maxZ - minZ) * 0.5 * paddingXZ
    local bottomY = groundY or minY
    local topY = maxY
    local halfY = math.max((topY - bottomY) * 0.5, 0.05)
    local center = Vector3.new((minX + maxX) * 0.5, bottomY + halfY, (minZ + maxZ) * 0.5)

    return center, Vector3.new(halfX, halfY, halfZ)
end

function Util.groundBoundsFromPart(part, paddingXZ, groundY)
    local minX, minY, minZ, maxX, maxY, maxZ = Util.getPartWorldAABB(part)
    return Util.groundBoundsFromAABB(minX, minY, minZ, maxX, maxY, maxZ, paddingXZ, groundY)
end

function Util.groundBoundsFromModel(model, paddingXZ, groundY)
    local cf, size = model:GetBoundingBox()
    local half = size * 0.5
    local minX = cf.Position.X - half.X
    local minY = cf.Position.Y - half.Y
    local minZ = cf.Position.Z - half.Z
    local maxX = cf.Position.X + half.X
    local maxY = cf.Position.Y + half.Y
    local maxZ = cf.Position.Z + half.Z

    return Util.groundBoundsFromAABB(minX, minY, minZ, maxX, maxY, maxZ, paddingXZ, groundY)
end

function Util.estimateTextWidth(text, fontSize)
    local bytes = 0

    for i = 1, #text do
        local byte = string.byte(text, i)

        if byte and byte < 128 then
            bytes = bytes + 1
        else
            bytes = bytes + 2
        end
    end

    return bytes * fontSize * 0.62
end

function Util.getBoxCorners(center, halfSize)
    local hx, hy, hz

    if typeof(halfSize) == "Vector3" then
        hx, hy, hz = halfSize.X, halfSize.Y, halfSize.Z
    else
        hx, hy, hz = halfSize, halfSize, halfSize
    end

    local cx, cy, cz = center.X, center.Y, center.Z

    return {
        Vector3.new(cx - hx, cy - hy, cz - hz),
        Vector3.new(cx + hx, cy - hy, cz - hz),
        Vector3.new(cx - hx, cy - hy, cz + hz),
        Vector3.new(cx + hx, cy - hy, cz + hz),
        Vector3.new(cx - hx, cy + hy, cz - hz),
        Vector3.new(cx + hx, cy + hy, cz - hz),
        Vector3.new(cx - hx, cy + hy, cz + hz),
        Vector3.new(cx + hx, cy + hy, cz + hz),
    }
end

Util.BOX_EDGES = {
    { 1, 2 }, { 2, 4 }, { 4, 3 }, { 3, 1 },
    { 5, 6 }, { 6, 8 }, { 8, 7 }, { 7, 5 },
    { 1, 5 }, { 2, 6 }, { 3, 7 }, { 4, 8 },
}

function Util.createDrawing(className, props)
    local obj = Drawing.new(className)

    for key, value in pairs(props) do
        obj[key] = value
    end

    return obj
end

return Util

end)()

local TextLayoutModule = (function()
--[[
    Label text builders and dynamic box sizing.
]]

local TextLayout = {}

function TextLayout.create(deps)
    local Config = deps.Config
    local Util = deps.Util

    local theme = Config.Theme
    local layout = Config.Layout
    local drawing = Config.Drawing

    local function getTitleText(entry)
        local info = entry.info

        if entry.kind == "treadmill" then
            return "[MY TREADMILL] " .. info.name
        end

        if entry.kind == "trap" then
            if entry.isOwn then
                return "[MY TRAP] " .. info.name
            end

            return "[TRAP] " .. info.name
        end

        return info.name
    end

    local function getDetailText(entry)
        local info = entry.info

        if entry.kind == "trap" then
            return string.format("%s  |  %s  |  %s", info.rarityName, info.rarityValue, entry.owner)
        end

        if info.areaName then
            return string.format("%s  |  %s  |  %s", info.areaName, info.rarityName, info.rarityValue)
        end

        return string.format("%s  |  %s", info.rarityName, info.rarityValue)
    end

    local function computeBoxSize(entry)
        local horizontalPad = layout.textPaddingX * 2 + layout.accentWidth + 6
        local minWidth = entry.kind == "trap" and layout.trapBoxWidthMin or layout.boxWidthMin
        local titleWidth = Util.estimateTextWidth(getTitleText(entry), drawing.textNameSize)
        local detailWidth = Util.estimateTextWidth(getDetailText(entry), drawing.textRaritySize)
        local distanceWidth = Util.estimateTextWidth(Util.formatDistance(entry.distance), drawing.textDistanceSize)
        local contentWidth = math.max(titleWidth, detailWidth, distanceWidth) + horizontalPad

        return {
            width = math.clamp(contentWidth, minWidth, layout.boxWidthMax),
            height = layout.boxHeight,
        }
    end

    local function applyBoxSize(entry)
        local size = computeBoxSize(entry)
        entry.boxWidth = size.width
        entry.boxHeight = size.height
        return entry
    end

    return {
        GetTitleText = getTitleText,
        GetDetailText = getDetailText,
        ComputeBoxSize = computeBoxSize,
        ApplyBoxSize = applyBoxSize,
    }
end

return TextLayout

end)()

local EggDataModule = (function()
--[[
    Egg data layer: collect field eggs, resolve models, asset metadata.
]]

local EggData = {}

function EggData.create(deps)
    local Config = deps.Config
    local FarmFilters = deps.FarmFilters
    local Workspace = deps.Workspace
    local LocalPlayer = deps.LocalPlayer
    local EggState = deps.EggState
    local Assets = deps.Assets
    local Areas = deps.Areas
    local STATES = deps.STATES

    local theme = Config.Theme
    local runtime = Config.Runtime

    local cache = {
        all = {},
        at = 0,
    }

    local function getAssetInfo(category)
        local entry = Assets.Directory[category]

        if not entry then
            return {
                name = category,
                rarityId = "Unknown",
                rarityName = "Unknown",
                rarityColor = theme.textMuted,
                rarityValue = "?",
                rarityTier = 0,
                dropWeight = math.huge,
            }
        end

        local rarity = entry.Rarity

        return {
            name = entry.Egg.DisplayName,
            rarityId = rarity._id or "Unknown",
            rarityName = rarity.DisplayName,
            rarityColor = rarity.Color,
            rarityValue = rarity.DefaultRarityValue or ("Tier " .. tostring(rarity.RarityNumber)),
            rarityTier = rarity.RarityNumber or 0,
            dropWeight = entry.DropWeight or math.huge,
        }
    end

    local function resolveModel(uid)
        local direct = Workspace:FindFirstChild(uid)

        if direct and direct:IsA("Model") then
            return direct
        end

        local clientFolder = Workspace:FindFirstChild("AreaEggSlotsClient")

        if clientFolder then
            local clientModel = clientFolder:FindFirstChild(uid)

            if clientModel and clientModel:IsA("Model") then
                return clientModel
            end
        end

        return nil
    end

    local function getWorldPosition(model, record)
        local offset = Vector3.new(0, runtime.positionYOffset, 0)

        if model then
            local eggPoint = model:FindFirstChild("EggPoint", true)

            if eggPoint and eggPoint:IsA("BasePart") then
                return eggPoint.Position + offset
            end

            if model.PrimaryPart then
                return model.PrimaryPart.Position + offset
            end

            return model:GetPivot().Position + offset
        end

        if record and record.BoundsCFrame then
            return record.BoundsCFrame.Position + offset
        end

        return nil
    end

    local AREA_ID_ALIASES = {
        CherryBlossom = "Cherry Blossom",
    }

    local function resolveAreaEntry(areaId)
        if typeof(areaId) ~= "string" then
            return nil, areaId
        end

        local directory = Areas and Areas.Directory

        if not directory then
            return nil, areaId
        end

        local entry = directory[areaId]

        if entry then
            return entry, areaId
        end

        local aliasId = AREA_ID_ALIASES[areaId]

        if aliasId then
            entry = directory[aliasId]

            if entry then
                return entry, aliasId
            end
        end

        for id, config in pairs(directory) do
            if config._id == areaId then
                return config, id
            end
        end

        return nil, areaId
    end

    local function getAreaInfo(areaId)
        if typeof(areaId) ~= "string" then
            return {
                areaId = "Unknown",
                areaName = "Unknown",
                areaTier = 0,
            }
        end

        local entry, resolvedId = resolveAreaEntry(areaId)

        if not entry then
            return {
                areaId = areaId,
                areaName = areaId,
                areaTier = 0,
            }
        end

        local rarity = entry.Rarity

        return {
            areaId = resolvedId,
            areaName = entry.DisplayName or resolvedId,
            areaTier = rarity and rarity.RarityNumber or 0,
        }
    end

    local function compareEggRarity(a, b)
        if a.rarityTier ~= b.rarityTier then
            return a.rarityTier > b.rarityTier
        end

        if runtime.autoFarmInfestedFirst ~= false then
            local aInfested = a.hasParasite == true
            local bInfested = b.hasParasite == true

            if aInfested ~= bInfested then
                return aInfested
            end
        end

        if a.dropWeight ~= b.dropWeight then
            return a.dropWeight < b.dropWeight
        end

        return a.distance < b.distance
    end

    local function sortEggs(results)
        table.sort(results, function(a, b)
            if a.rarityTier ~= b.rarityTier then
                return a.rarityTier > b.rarityTier
            end

            if runtime.autoFarmInfestedFirst ~= false then
                local aInfested = a.hasParasite == true
                local bInfested = b.hasParasite == true

                if aInfested ~= bInfested then
                    return aInfested
                end
            end

            if a.dropWeight ~= b.dropWeight then
                return a.dropWeight < b.dropWeight
            end

            return a.distance < b.distance
        end)
    end

    local function lockCandidatesToMaxTier(candidates)
        if runtime.autoFarmMaxRarityTierLock == false or #candidates == 0 then
            return candidates
        end

        local maxTier = candidates[1].rarityTier or 0

        for index = 2, #candidates do
            local tier = candidates[index].rarityTier or 0

            if tier > maxTier then
                maxTier = tier
            end
        end

        local locked = {}

        for _, egg in ipairs(candidates) do
            if (egg.rarityTier or 0) == maxTier then
                table.insert(locked, egg)
            end
        end

        return locked
    end

    local function passesFarmFilters(egg)
        if not egg then
            return false
        end

        if FarmFilters and FarmFilters.IsEggAllowed then
            return FarmFilters.IsEggAllowed(egg)
        end

        return true
    end

    local function rebuildCache()
        local snapshot = EggState.ReadFieldEggs()
        local results = {}
        local character = LocalPlayer.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")

        for _, record in ipairs(snapshot.Records) do
            if record.State == STATES.Slot or record.State == STATES.Dropped then
                local model = resolveModel(record.Uid)
                local worldPos = getWorldPosition(model, record)

                if worldPos then
                    local info = getAssetInfo(record.AssetCategory)
                    local areaInfo = getAreaInfo(record.AreaId)
                    local distance = rootPart and (worldPos - rootPart.Position).Magnitude or 0

                    info.areaId = areaInfo.areaId
                    info.areaName = areaInfo.areaName
                    info.areaTier = areaInfo.areaTier

                    table.insert(results, {
                        uid = record.Uid,
                        kind = "egg",
                        record = record,
                        model = model,
                        worldPos = worldPos,
                        info = info,
                        distance = distance,
                        areaId = areaInfo.areaId,
                        areaName = areaInfo.areaName,
                        areaTier = areaInfo.areaTier,
                        rarityTier = info.rarityTier,
                        rarityNumber = info.rarityTier,
                        dropWeight = info.dropWeight,
                        hasParasite = record.HasParasite == true,
                    })
                end
            end
        end

        sortEggs(results)
        cache.all = results
        cache.at = os.clock()
    end

    local function ensureCache(force)
        local ttl = runtime.eggDataCacheTtl or 0.35

        if force or os.clock() - cache.at >= ttl then
            rebuildCache()
        end
    end

    local function collectAll(force)
        ensureCache(force)
        return cache.all
    end

    local function collect(force)
        ensureCache(force)
        local results = {}
        local maxDistance = runtime.maxDistance

        for _, egg in ipairs(cache.all) do
            if egg.distance <= maxDistance then
                table.insert(results, egg)
            end
        end

        return results
    end

    local function findBestForFarm(_maxDistance, force)
        local eggs = collectAll(force)
        local candidates = {}

        for _, egg in ipairs(eggs) do
            if passesFarmFilters(egg) then
                table.insert(candidates, egg)
            end
        end

        if #candidates == 0 then
            return nil
        end

        candidates = lockCandidatesToMaxTier(candidates)
        table.sort(candidates, compareEggRarity)

        return candidates[1]
    end

    local function findByUid(uid, force)
        if typeof(uid) ~= "string" then
            return nil
        end

        for _, egg in ipairs(collectAll(force)) do
            if egg.uid == uid then
                return egg
            end
        end

        return nil
    end

    return {
        Collect = collect,
        CollectAll = collectAll,
        FindBestForFarm = findBestForFarm,
        FindByUid = findByUid,
        InvalidateCache = function()
            cache.at = 0
        end,
        GetAssetInfo = getAssetInfo,
        ResolveModel = resolveModel,
        GetWorldPosition = getWorldPosition,
    }
end

return EggData

end)()

local TreadmillDataModule = (function()
--[[
    Local player treadmill data: resolve model, position, upgrade info.
]]

local TreadmillData = {}

function TreadmillData.create(deps)
    local Config = deps.Config
    local Util = deps.Util
    local Workspace = deps.Workspace
    local LocalPlayer = deps.LocalPlayer
    local PlotState = deps.PlotState
    local Save = deps.Save
    local Treadmills = deps.Treadmills
    local TreadmillUtil = deps.TreadmillUtil

    local runtime = Config.Runtime
    local theme = Config.Theme

    local function resolveModel(slot)
        local renderFolder = Workspace:FindFirstChild("__ClientTreadmillRenders")

        if renderFolder then
            local renderModel = renderFolder:FindFirstChild("TreadmillRender_" .. tostring(slot))

            if renderModel and renderModel:IsA("Model") then
                return renderModel
            end
        end

        return nil
    end

    local function resolveBottomPart(slot)
        local plot = PlotState.ResolvePlot()

        if plot and plot.PlotFolder then
            local bottom = plot.PlotFolder:FindFirstChild("TreadmillBottom")

            if bottom and bottom:IsA("BasePart") then
                return bottom
            end
        end

        local plots = Workspace:FindFirstChild("Plots")
        local plotModel = plots and plots:FindFirstChild(tostring(slot))

        if plotModel then
            local bottom = plotModel:FindFirstChild("TreadmillBottom")

            if bottom and bottom:IsA("BasePart") then
                return bottom
            end
        end

        return nil
    end

    local function resolveBounds(slot, model)
        local padding = Config.Layout.treadmillBoundsPadding
        local bottom = resolveBottomPart(slot)
        local groundY = bottom and (bottom.Position.Y - bottom.Size.Y * 0.5) or nil

        if model then
            local modelCf, modelSize = model:GetBoundingBox()
            local modelHalf = modelSize * 0.5
            local minX = modelCf.Position.X - modelHalf.X
            local minY = modelCf.Position.Y - modelHalf.Y
            local minZ = modelCf.Position.Z - modelHalf.Z
            local maxX = modelCf.Position.X + modelHalf.X
            local maxY = modelCf.Position.Y + modelHalf.Y
            local maxZ = modelCf.Position.Z + modelHalf.Z

            if bottom then
                local bMinX, bMinY, bMinZ, bMaxX, bMaxY, bMaxZ = Util.getPartWorldAABB(bottom)
                minX, minY, minZ, maxX, maxY, maxZ = Util.mergeAABB(
                    minX, minY, minZ, maxX, maxY, maxZ,
                    bMinX, bMinY, bMinZ, bMaxX, bMaxY, bMaxZ
                )
            end

            return Util.groundBoundsFromAABB(minX, minY, minZ, maxX, maxY, maxZ, padding, groundY)
        end

        if bottom then
            return Util.groundBoundsFromPart(bottom, padding, groundY)
        end

        return nil, nil
    end

    local function resolveWorldPosition(slot, model)
        local offset = Vector3.new(0, runtime.treadmillYOffset, 0)

        if model then
            local root = model:FindFirstChild("Root")

            if root and root:IsA("BasePart") then
                return root.Position + offset
            end

            if model.PrimaryPart then
                return model.PrimaryPart.Position + offset
            end

            return model:GetPivot().Position + offset
        end

        local plot = PlotState.ResolvePlot()

        if plot and plot.PlotFolder then
            local bottom = plot.PlotFolder:FindFirstChild("TreadmillBottom")

            if bottom and bottom:IsA("BasePart") then
                return bottom.Position + offset
            end
        end

        local plots = Workspace:FindFirstChild("Plots")
        local plotModel = plots and plots:FindFirstChild(tostring(slot))

        if plotModel then
            local bottom = plotModel:FindFirstChild("TreadmillBottom")

            if bottom and bottom:IsA("BasePart") then
                return bottom.Position + offset
            end
        end

        return nil
    end

    local function getInfo(level)
        local config = Treadmills.GetByUpgradeLevel(level)

        if not config then
            return {
                name = "Treadmill",
                rarityName = "Unknown",
                rarityColor = theme.textMuted,
                rarityValue = "Lv " .. tostring(level),
                rarityNumber = 0,
            }
        end

        local rarity = config.Rarity
        local speedLabel = TreadmillUtil.FormatSpeedMultiplierValue
            and TreadmillUtil.FormatSpeedMultiplierValue(config.SpeedMultiplier)
            or ("x" .. tostring(config.SpeedMultiplier))

        return {
            name = config.DisplayName,
            rarityName = rarity.DisplayName,
            rarityColor = rarity.Color,
            rarityValue = string.format("Lv %d  |  %s", level, speedLabel),
            rarityNumber = rarity.RarityNumber or 0,
        }
    end

    local function collect()
        if not runtime.showTreadmill then
            return nil
        end

        local slot = PlotState.ResolveLocalSlot()

        if slot == nil then
            return nil
        end

        local model = resolveModel(slot)
        local worldPos = resolveWorldPosition(slot, model)

        if worldPos == nil then
            return nil
        end

        local saveData = Save.Get(LocalPlayer)
        local level = 1

        if saveData and typeof(saveData.TreadmillUpgradeLevel) == "number" then
            level = saveData.TreadmillUpgradeLevel
        end

        local character = LocalPlayer.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        local distance = rootPart and (worldPos - rootPart.Position).Magnitude or 0

        if distance > runtime.maxDistance then
            return nil
        end

        local boundsCenter, boundsHalfSize = resolveBounds(slot, model)

        return {
            uid = "local_treadmill",
            kind = "treadmill",
            slot = slot,
            model = model,
            worldPos = worldPos,
            boundsCenter = boundsCenter,
            boundsHalfSize = boundsHalfSize,
            info = getInfo(level),
            distance = distance,
            rarityNumber = 9999,
        }
    end

    return {
        Collect = collect,
    }
end

return TreadmillData

end)()

local TrapDataModule = (function()
--[[
    Placed trap data via CollectionService tag "PlacedTrap".
]]

local TrapData = {}

function TrapData.create(deps)
    local Config = deps.Config
    local Util = deps.Util
    local CollectionService = deps.CollectionService
    local LocalPlayer = deps.LocalPlayer
    local Constants = deps.Constants
    local Gears = deps.Gears
    local Rarity = deps.Rarity

    local runtime = Config.Runtime
    local theme = Config.Theme
    local placedTrapTag = Constants.TAGS_MAP.Traps.PLACED_TRAP

    local function resolveGearInfo(trap)
        local gearName = trap:GetAttribute("GearName")

        if typeof(gearName) ~= "string" or gearName == "" then
            gearName = "Trap"
        end

        local gear = Gears.Directory[gearName]
        local displayName = gear and gear.DisplayName or gearName
        local rarityKey = gear and gear.Rarity
        local rarity = theme.textMuted

        if typeof(rarityKey) == "string" and Rarity.Rarities[rarityKey] then
            rarity = Rarity.Rarities[rarityKey]
        end

        return {
            gearName = gearName,
            name = displayName,
            rarityName = typeof(rarity) == "table" and rarity.DisplayName or tostring(rarityKey or "Trap"),
            rarityColor = typeof(rarity) == "table" and rarity.Color or theme.trapEnemy,
            rarityValue = trap:GetAttribute("TrapActive") == true and "TRIGGERED" or "ARMED",
            rarityNumber = typeof(rarity) == "table" and (rarity.RarityNumber or 0) or 0,
        }
    end

    local function resolveBounds(trap)
        local hitbox = trap:FindFirstChild("Hitbox")
        local padding = Config.Layout.trapBoundsPadding

        if hitbox and hitbox:IsA("BasePart") then
            return Util.groundBoundsFromPart(hitbox, padding)
        end

        return Util.groundBoundsFromPart(trap, padding)
    end

    local function getWorldPosition(trap)
        local hitbox = trap:FindFirstChild("Hitbox")

        if hitbox and hitbox:IsA("BasePart") then
            return hitbox.Position + Vector3.new(0, hitbox.Size.Y * 0.5 + 0.2, 0)
        end

        return trap.Position + Vector3.new(0, trap.Size.Y * 0.5 + 0.2, 0)
    end

    local function collect()
        if not runtime.showTraps then
            return {}
        end

        local results = {}
        local character = LocalPlayer.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")

        for _, trap in ipairs(CollectionService:GetTagged(placedTrapTag)) do
            if trap:IsA("BasePart") and trap.Parent then
                local worldPos = getWorldPosition(trap)
                local distance = rootPart and (worldPos - rootPart.Position).Magnitude or 0

                if distance <= runtime.maxDistance then
                    local owner = trap:GetAttribute("Owner")
                    local isOwn = typeof(owner) == "string" and owner == LocalPlayer.Name
                    local boundsCenter, boundsHalfSize = resolveBounds(trap)

                    table.insert(results, {
                        uid = "trap_" .. tostring(trap),
                        kind = "trap",
                        isOwn = isOwn,
                        instance = trap,
                        worldPos = worldPos,
                        boundsCenter = boundsCenter,
                        boundsHalfSize = boundsHalfSize,
                        info = resolveGearInfo(trap),
                        owner = typeof(owner) == "string" and owner or "Unknown",
                        distance = distance,
                        rarityNumber = isOwn and 9000 or 8500,
                    })
                end
            end
        end

        table.sort(results, function(a, b)
            if a.isOwn ~= b.isOwn then
                return a.isOwn
            end

            return a.distance < b.distance
        end)

        return results
    end

    return {
        Collect = collect,
    }
end

return TrapData

end)()

local DataCollectorModule = (function()
--[[
    Merge ESP targets from multiple data sources.
]]

local DataCollector = {}

function DataCollector.create(deps)
    local EggData = deps.EggData
    local TreadmillData = deps.TreadmillData
    local TrapData = deps.TrapData

    local function collect()
        local results = {}

        local treadmill = TreadmillData.Collect()
        if treadmill then
            table.insert(results, treadmill)
        end

        for _, trap in ipairs(TrapData.Collect()) do
            table.insert(results, trap)
        end

        for _, egg in ipairs(EggData.Collect()) do
            table.insert(results, egg)
        end

        return results
    end

    return {
        Collect = collect,
    }
end

return DataCollector

end)()

local StackLayoutModule = (function()
--[[
    Label stacking: prevent overlapping info boxes on screen.
]]

local StackLayout = {}

function StackLayout.create(deps)
    local Config = deps.Config
    local Util = deps.Util
    local TextLayout = deps.TextLayout

    local layout = Config.Layout

    local function assign(entries, camera)
        local visible = {}

        for _, entry in ipairs(entries) do
            local screenPos, onScreen, depth = Util.worldToScreen(camera, entry.worldPos)

            if onScreen and depth > 0 then
                entry.screenPos = screenPos
                entry.depth = depth
                TextLayout.ApplyBoxSize(entry)
                table.insert(visible, entry)
            end
        end

        table.sort(visible, function(a, b)
            if math.abs(a.screenPos.Y - b.screenPos.Y) > layout.screenSortYTolerance then
                return a.screenPos.Y > b.screenPos.Y
            end

            return a.screenPos.X < b.screenPos.X
        end)

        local placed = {}

        for _, entry in ipairs(visible) do
            local boxW = entry.boxWidth
            local boxH = entry.boxHeight
            local centerX = entry.screenPos.X
            local boxX = centerX - boxW * 0.5
            local boxY = entry.screenPos.Y - layout.labelOffsetY

            for _ = 1, layout.stackMaxIterations do
                local collided = false

                for _, rect in ipairs(placed) do
                    local nearX = math.abs(rect.cx - centerX) < boxW * layout.stackNearXFactor

                    if nearX and Util.rectsOverlap(boxX, boxY, boxW, boxH, rect.x, rect.y, rect.w, rect.h) then
                        boxY = math.min(boxY, rect.y - boxH - layout.stackGap)
                        collided = true
                    end
                end

                if not collided then
                    break
                end
            end

            entry.boxX = boxX
            entry.boxY = boxY
            entry.labelCenter = Vector2.new(centerX, boxY + boxH * 0.5)

            table.insert(placed, {
                x = boxX,
                y = boxY,
                w = boxW,
                h = boxH,
                cx = centerX,
            })

            table.sort(placed, function(a, b)
                return a.y < b.y
            end)
        end

        return visible
    end

    return {
        Assign = assign,
    }
end

return StackLayout

end)()

local DrawingPoolModule = (function()
--[[
    Drawing object pool: create, reuse, and hide ESP draw instances.
]]

local DrawingPool = {}

function DrawingPool.create(deps)
    local Config = deps.Config
    local Util = deps.Util

    local theme = Config.Theme
    local layout = Config.Layout
    local drawing = Config.Drawing

    local pool = {}

    local function createEntry()
        local font = drawing.font
        local outline = theme.shadow
        local radius = layout.dotRadius

        return {
            dot = Util.createDrawing("Circle", {
                Radius = radius,
                Filled = true,
                Thickness = 1,
                NumSides = 16,
                Visible = false,
            }),
            dotRing = Util.createDrawing("Circle", {
                Radius = radius + 2,
                Filled = false,
                Thickness = 1,
                NumSides = 16,
                Visible = false,
            }),
            connector = Util.createDrawing("Line", {
                Thickness = layout.connectorThickness,
                Visible = false,
            }),
            shadow = Util.createDrawing("Square", {
                Filled = true,
                Visible = false,
            }),
            box = Util.createDrawing("Square", {
                Filled = true,
                Visible = false,
            }),
            boxInner = Util.createDrawing("Square", {
                Filled = true,
                Visible = false,
            }),
            boxBorder = Util.createDrawing("Square", {
                Filled = false,
                Thickness = layout.borderThickness,
                Visible = false,
            }),
            accent = Util.createDrawing("Square", {
                Filled = true,
                Visible = false,
            }),
            accentTop = Util.createDrawing("Line", {
                Thickness = 2,
                Visible = false,
            }),
            textName = Util.createDrawing("Text", {
                Size = drawing.textNameSize,
                Center = false,
                Outline = true,
                OutlineColor = outline,
                Font = font,
                Visible = false,
            }),
            textRarity = Util.createDrawing("Text", {
                Size = drawing.textRaritySize,
                Center = false,
                Outline = true,
                OutlineColor = outline,
                Font = font,
                Visible = false,
            }),
            textDistance = Util.createDrawing("Text", {
                Size = drawing.textDistanceSize,
                Center = false,
                Outline = true,
                OutlineColor = outline,
                Font = font,
                Visible = false,
            }),
        }
    end

    local function hideEntry(entry)
        for _, key in ipairs(drawing.keys) do
            local obj = entry[key]

            if obj then
                obj.Visible = false
            end
        end
    end

    local function acquire(index)
        if not pool[index] then
            pool[index] = createEntry()
        end

        return pool[index]
    end

    local function hideFrom(index)
        for i = index, #pool do
            hideEntry(pool[i])
        end
    end

    local function hideAll()
        for _, entry in ipairs(pool) do
            hideEntry(entry)
        end
    end

    local function destroyAll()
        for _, entry in ipairs(pool) do
            for _, key in ipairs(drawing.keys) do
                local obj = entry[key]

                if obj then
                    obj:Remove()
                end
            end
        end

        table.clear(pool)
    end

    return {
        Acquire = acquire,
        HideFrom = hideFrom,
        HideAll = hideAll,
        DestroyAll = destroyAll,
    }
end

return DrawingPool

end)()

local BoundingBoxPoolModule = (function()
--[[
    Drawing pool for 3D bounding box edges (12 lines per box).
]]

local BoundingBoxPool = {}

local EDGE_COUNT = 12

function BoundingBoxPool.create(deps)
    local Config = deps.Config
    local Util = deps.Util

    local layout = Config.Layout
    local pool = {}

    local function createEntry()
        local lines = {}

        for i = 1, EDGE_COUNT do
            lines[i] = Util.createDrawing("Line", {
                Thickness = layout.treadmillBoundsThickness,
                Visible = false,
            })
        end

        return lines
    end

    local function hideEntry(lines)
        for i = 1, EDGE_COUNT do
            lines[i].Visible = false
        end
    end

    local function acquire(index)
        if not pool[index] then
            pool[index] = createEntry()
        end

        return pool[index]
    end

    local function hideFrom(index)
        for i = index, #pool do
            hideEntry(pool[i])
        end
    end

    local function hideAll()
        for _, lines in ipairs(pool) do
            hideEntry(lines)
        end
    end

    local function destroyAll()
        for _, lines in ipairs(pool) do
            for i = 1, EDGE_COUNT do
                lines[i]:Remove()
            end
        end

        table.clear(pool)
    end

    return {
        Acquire = acquire,
        HideFrom = hideFrom,
        HideAll = hideAll,
        DestroyAll = destroyAll,
    }
end

return BoundingBoxPool

end)()

local RendererModule = (function()
--[[
    ESP renderer: draw pooled labels for eggs, treadmill, and traps.
]]

local Renderer = {}

function Renderer.create(deps)
    local Config = deps.Config
    local Util = deps.Util
    local TextLayout = deps.TextLayout

    local theme = Config.Theme
    local layout = Config.Layout
    local drawing = Config.Drawing

    local function getAccentColor(entry, info)
        if entry.kind == "treadmill" then
            return theme.treadmillTag
        end

        if entry.kind == "trap" then
            return entry.isOwn and theme.trapOwn or theme.trapEnemy
        end

        return info.rarityColor
    end

    local function getBorderColor(entry)
        if entry.kind == "treadmill" then
            return theme.treadmillBorder
        end

        if entry.kind == "trap" then
            return entry.isOwn and theme.trapOwnBorder or theme.trapEnemyBorder
        end

        return theme.border
    end

    local function getRingColor(entry)
        if entry.kind == "treadmill" then
            return theme.treadmillDotRing
        end

        if entry.kind == "trap" then
            return entry.isOwn and theme.trapOwnRing or theme.trapEnemyRing
        end

        return theme.dotRing
    end

    local function getConnectorColor(entry)
        if entry.kind == "treadmill" then
            return theme.treadmillBorder
        end

        if entry.kind == "trap" then
            return entry.isOwn and theme.trapOwnBorder or theme.trapEnemyBorder
        end

        return theme.connector
    end

    local function getTitleColor(entry)
        if entry.kind == "treadmill" then
            return theme.treadmillTag
        end

        if entry.kind == "trap" then
            return entry.isOwn and theme.trapOwn or theme.trapEnemy
        end

        return theme.textMain
    end

    local function drawEntry(entry, draw)
        local info = entry.info
        local accentColor = getAccentColor(entry, info)
        local boxW = entry.boxWidth or layout.boxWidth
        local boxH = entry.boxHeight or layout.boxHeight

        draw.dot.Color = accentColor
        draw.dot.Position = entry.screenPos
        draw.dot.Visible = true

        draw.dotRing.Color = getRingColor(entry)
        draw.dotRing.Position = entry.screenPos
        draw.dotRing.Visible = true

        local boxTop = Vector2.new(entry.boxX, entry.boxY)
        local boxSize = Vector2.new(boxW, boxH)

        draw.shadow.Color = theme.shadow
        draw.shadow.Position = boxTop + Vector2.new(2, 2)
        draw.shadow.Size = boxSize
        draw.shadow.Transparency = 0.35
        draw.shadow.Visible = true

        draw.box.Color = theme.bg
        draw.box.Position = boxTop
        draw.box.Size = boxSize
        draw.box.Visible = true

        draw.boxInner.Color = theme.bgInner
        draw.boxInner.Position = boxTop + Vector2.new(3, 3)
        draw.boxInner.Size = Vector2.new(boxW - 6, boxH - 6)
        draw.boxInner.Transparency = 0.15
        draw.boxInner.Visible = true

        draw.boxBorder.Color = getBorderColor(entry)
        draw.boxBorder.Position = boxTop
        draw.boxBorder.Size = boxSize
        draw.boxBorder.Visible = true

        draw.accent.Color = accentColor
        draw.accent.Position = boxTop
        draw.accent.Size = Vector2.new(layout.accentWidth, boxH)
        draw.accent.Visible = true

        draw.accentTop.Color = accentColor
        draw.accentTop.From = boxTop
        draw.accentTop.To = boxTop + Vector2.new(boxW, 0)
        draw.accentTop.Visible = true

        draw.connector.Color = getConnectorColor(entry)
        draw.connector.From = entry.screenPos
        draw.connector.To = Vector2.new(entry.labelCenter.X, entry.boxY + boxH)
        draw.connector.Visible = true

        local textX = entry.boxX + layout.textPaddingX
        local baseY = entry.boxY + layout.textPaddingY

        draw.textName.Text = TextLayout.GetTitleText(entry)
        draw.textName.Color = getTitleColor(entry)
        draw.textName.Position = Vector2.new(textX, baseY + layout.textLine1)
        draw.textName.Visible = true

        draw.textRarity.Text = TextLayout.GetDetailText(entry)
        draw.textRarity.Color = entry.kind == "trap" and accentColor or info.rarityColor
        draw.textRarity.Position = Vector2.new(textX, baseY + layout.textLine2)
        draw.textRarity.Visible = true

        local distanceText = Util.formatDistance(entry.distance)
        local distanceWidth = Util.estimateTextWidth(distanceText, layout.textDistanceSize or drawing.textDistanceSize)

        draw.textDistance.Text = distanceText
        draw.textDistance.Color = theme.textMuted
        draw.textDistance.Position = Vector2.new(entry.boxX + boxW - layout.textPaddingX - distanceWidth, baseY + layout.textLine3)
        draw.textDistance.Visible = true
    end

    local function renderFrame(entries, pool)
        for index, entry in ipairs(entries) do
            drawEntry(entry, pool.Acquire(index))
        end

        pool.HideFrom(#entries + 1)
    end

    return {
        DrawEntry = drawEntry,
        RenderFrame = renderFrame,
    }
end

return Renderer

end)()

local BoundingBoxRendererModule = (function()
--[[
    Render 3D bounding boxes projected to screen lines.
]]

local BoundingBoxRenderer = {}

function BoundingBoxRenderer.create(deps)
    local Config = deps.Config
    local Util = deps.Util

    local theme = Config.Theme
    local runtime = Config.Runtime
    local layout = Config.Layout

    local function shouldDraw(entry)
        if entry.kind == "treadmill" then
            return runtime.showTreadmillBounds and entry.boundsCenter and entry.boundsHalfSize
        end

        if entry.kind == "trap" then
            return runtime.showTrapBounds and entry.boundsCenter and entry.boundsHalfSize
        end

        return false
    end

    local function getColor(entry)
        if entry.kind == "treadmill" then
            return theme.treadmillBounds
        end

        if entry.kind == "trap" then
            return entry.isOwn and theme.trapOwnBorder or theme.trapEnemyBorder
        end

        return theme.treadmillBounds
    end

    local function getThickness(entry)
        if entry.kind == "trap" then
            return layout.trapBoundsThickness
        end

        return layout.treadmillBoundsThickness
    end

    local function drawEntry(entry, camera, lines)
        local corners = Util.getBoxCorners(entry.boundsCenter, entry.boundsHalfSize)
        local color = getColor(entry)
        local thickness = getThickness(entry)

        for edgeIndex, edge in ipairs(Util.BOX_EDGES) do
            local fromPos, toPos, visible = Util.projectBoxEdge(
                camera,
                corners[edge[1]],
                corners[edge[2]]
            )
            local line = lines[edgeIndex]

            if visible then
                line.From = fromPos
                line.To = toPos
                line.Color = color
                line.Thickness = thickness
                line.Visible = true
            else
                line.Visible = false
            end
        end
    end

    local function renderFrame(entries, camera, pool)
        local boxIndex = 0

        for _, entry in ipairs(entries) do
            if shouldDraw(entry) then
                boxIndex = boxIndex + 1
                drawEntry(entry, camera, pool.Acquire(boxIndex))
            end
        end

        pool.HideFrom(boxIndex + 1)
    end

    return {
        DrawEntry = drawEntry,
        RenderFrame = renderFrame,
    }
end

return BoundingBoxRenderer

end)()

local PathfinderModule = (function()
--[[
    Grid A* pathfinding on the XZ plane with axis-aligned obstacle rects.
]]

local Pathfinder = {}

local DIRS = {
    { 1, 0, 1 },
    { -1, 0, 1 },
    { 0, 1, 1 },
    { 1, 1, 1.41421356237 },
    { -1, 1, 1.41421356237 },
    { 1, -1, 1.41421356237 },
    { -1, -1, 1.41421356237 },
}

local function segmentIntersectsAABB(x1, z1, x2, z2, minX, minZ, maxX, maxZ)
    local dx = x2 - x1
    local dz = z2 - z1
    local tMin = 0
    local tMax = 1

    local function clip(p, q)
        if math.abs(p) < 1e-8 then
            return q >= 0
        end

        local r = q / p

        if p < 0 then
            if r > tMax then
                return false
            end

            if r > tMin then
                tMin = r
            end
        else
            if r < tMin then
                return false
            end

            if r < tMax then
                tMax = r
            end
        end

        return true
    end

    if not clip(-dx, x1 - minX) then
        return false
    end

    if not clip(dx, maxX - x1) then
        return false
    end

    if not clip(-dz, z1 - minZ) then
        return false
    end

    if not clip(dz, maxZ - z1) then
        return false
    end

    return tMin <= tMax
end

local function isLineClear(x1, z1, x2, z2, obstacles)
    for _, obstacle in ipairs(obstacles) do
        if segmentIntersectsAABB(x1, z1, x2, z2, obstacle.minX, obstacle.minZ, obstacle.maxX, obstacle.maxZ) then
            return false
        end
    end

    return true
end

local function stringPull(points, obstacles)
    if #points <= 2 then
        return points
    end

    local pulled = { points[1] }
    local index = 1

    while index < #points do
        local farthest = index + 1

        for candidate = #points, index + 1, -1 do
            local from = pulled[#pulled]

            if isLineClear(from.X, from.Z, points[candidate].X, points[candidate].Z, obstacles) then
                farthest = candidate
                break
            end
        end

        table.insert(pulled, points[farthest])
        index = farthest
    end

    return pulled
end

function Pathfinder.create()
    local function cellKey(gx, gz)
        return gx .. ":" .. gz
    end

    local function isBlocked(gx, gz, grid)
        if gx < 0 or gz < 0 or gx >= grid.width or gz >= grid.height then
            return true
        end

        return grid.blocked[cellKey(gx, gz)] == true
    end

    local function worldToCell(x, z, grid)
        local gx = math.floor((x - grid.originX) / grid.cellSize)
        local gz = math.floor((z - grid.originZ) / grid.cellSize)
        return gx, gz
    end

    local function cellToWorld(gx, gz, grid)
        local x = grid.originX + (gx + 0.5) * grid.cellSize
        local z = grid.originZ + (gz + 0.5) * grid.cellSize
        return x, z
    end

    local function buildGrid(startPos, goalPos, obstacles, options)
        options = options or {}

        local cellSize = options.cellSize or 4
        local margin = options.margin or 16
        local padding = options.obstaclePadding or 2
        local maxCells = options.maxCells or 9000

        local minX = math.min(startPos.X, goalPos.X) - margin
        local maxX = math.max(startPos.X, goalPos.X) + margin
        local minZ = math.min(startPos.Z, goalPos.Z) - margin
        local maxZ = math.max(startPos.Z, goalPos.Z) + margin

        for _, obstacle in ipairs(obstacles) do
            minX = math.min(minX, obstacle.minX - margin)
            maxX = math.max(maxX, obstacle.maxX + margin)
            minZ = math.min(minZ, obstacle.minZ - margin)
            maxZ = math.max(maxZ, obstacle.maxZ + margin)
        end

        local width = math.max(1, math.ceil((maxX - minX) / cellSize))
        local height = math.max(1, math.ceil((maxZ - minZ) / cellSize))

        while width * height > maxCells do
            cellSize = cellSize + 1
            width = math.max(1, math.ceil((maxX - minX) / cellSize))
            height = math.max(1, math.ceil((maxZ - minZ) / cellSize))
        end

        local blocked = {}

        for gz = 0, height - 1 do
            for gx = 0, width - 1 do
                local x, z = cellToWorld(gx, gz, {
                    originX = minX,
                    originZ = minZ,
                    cellSize = cellSize,
                })

                for _, obstacle in ipairs(obstacles) do
                    if x >= obstacle.minX and x <= obstacle.maxX
                        and z >= obstacle.minZ and z <= obstacle.maxZ then
                        blocked[cellKey(gx, gz)] = true
                        break
                    end
                end
            end
        end

        local startGX, startGZ = worldToCell(startPos.X, startPos.Z, {
            originX = minX,
            originZ = minZ,
            cellSize = cellSize,
        })
        local goalGX, goalGZ = worldToCell(goalPos.X, goalPos.Z, {
            originX = minX,
            originZ = minZ,
            cellSize = cellSize,
        })

        blocked[cellKey(startGX, startGZ)] = nil
        blocked[cellKey(goalGX, goalGZ)] = nil

        return {
            originX = minX,
            originZ = minZ,
            cellSize = cellSize,
            width = width,
            height = height,
            blocked = blocked,
            startGX = startGX,
            startGZ = startGZ,
            goalGX = goalGX,
            goalGZ = goalGZ,
            obstaclePadding = padding,
        }
    end

    local function reconstruct(cameFrom, currentKey, grid, groundY)
        local points = {}
        local key = currentKey

        while key do
            local gx, gz = key:match("^(-?%d+):(-?%d+)$")
            gx = tonumber(gx)
            gz = tonumber(gz)
            local x, z = cellToWorld(gx, gz, grid)
            table.insert(points, 1, Vector3.new(x, groundY, z))
            key = cameFrom[key]
        end

        return points
    end

    local function simplify(points)
        if #points <= 2 then
            return points
        end

        local simplified = { points[1] }

        for index = 2, #points - 1 do
            local prev = simplified[#simplified]
            local current = points[index]
            local nextPoint = points[index + 1]
            local dirA = Vector3.new(current.X - prev.X, 0, current.Z - prev.Z)
            local dirB = Vector3.new(nextPoint.X - current.X, 0, nextPoint.Z - current.Z)

            if dirA.Magnitude > 0.01 and dirB.Magnitude > 0.01 then
                dirA = dirA.Unit
                dirB = dirB.Unit
                local dot = dirA:Dot(dirB)

                if dot < 0.995 then
                    table.insert(simplified, current)
                end
            else
                table.insert(simplified, current)
            end
        end

        table.insert(simplified, points[#points])
        return simplified
    end

    local function findPath(startPos, goalPos, obstacles, options)
        options = options or {}
        local groundY = options.groundY or startPos.Y

        if (Vector3.new(startPos.X, 0, startPos.Z) - Vector3.new(goalPos.X, 0, goalPos.Z)).Magnitude < (options.cellSize or 4) then
            return { startPos, goalPos }, true
        end

        if isLineClear(startPos.X, startPos.Z, goalPos.X, goalPos.Z, obstacles) then
            return {
                Vector3.new(startPos.X, groundY, startPos.Z),
                Vector3.new(goalPos.X, groundY, goalPos.Z),
            }, true
        end

        local grid = buildGrid(startPos, goalPos, obstacles, options)
        local startKey = cellKey(grid.startGX, grid.startGZ)
        local goalKey = cellKey(grid.goalGX, grid.goalGZ)

        local openSet = { startKey }
        local openMap = { [startKey] = true }
        local cameFrom = {}
        local gScore = { [startKey] = 0 }
        local fScore = { [startKey] = 0 }

        local function heuristic(gx, gz)
            local dx = math.abs(gx - grid.goalGX)
            local dz = math.abs(gz - grid.goalGZ)
            return math.max(dx, dz) + (1.41421356237 - 1) * math.min(dx, dz)
        end

        fScore[startKey] = heuristic(grid.startGX, grid.startGZ)

        local iterations = 0
        local maxIterations = options.maxIterations or 12000

        while #openSet > 0 and iterations < maxIterations do
            iterations = iterations + 1

            local bestIndex = 1
            local bestKey = openSet[1]
            local bestScore = fScore[bestKey] or math.huge

            for index = 2, #openSet do
                local key = openSet[index]
                local score = fScore[key] or math.huge

                if score < bestScore then
                    bestScore = score
                    bestKey = key
                    bestIndex = index
                end
            end

            local currentKey = bestKey
            table.remove(openSet, bestIndex)
            openMap[currentKey] = nil

            if currentKey == goalKey then
                local path = reconstruct(cameFrom, currentKey, grid, groundY)
                path[1] = Vector3.new(startPos.X, groundY, startPos.Z)
                path[#path] = Vector3.new(goalPos.X, groundY, goalPos.Z)
                path = simplify(path)
                path = stringPull(path, obstacles)
                return path, true
            end

            local cgx, cgz = currentKey:match("^(-?%d+):(-?%d+)$")
            cgx = tonumber(cgx)
            cgz = tonumber(cgz)

            for _, dir in ipairs(DIRS) do
                local ngx = cgx + dir[1]
                local ngz = cgz + dir[2]

                if not isBlocked(ngx, ngz, grid) then
                    local neighborKey = cellKey(ngx, ngz)
                    local tentative = (gScore[currentKey] or math.huge) + dir[3]

                    if tentative < (gScore[neighborKey] or math.huge) then
                        cameFrom[neighborKey] = currentKey
                        gScore[neighborKey] = tentative
                        fScore[neighborKey] = tentative + heuristic(ngx, ngz)

                        if not openMap[neighborKey] then
                            table.insert(openSet, neighborKey)
                            openMap[neighborKey] = true
                        end
                    end
                end
            end
        end

        return nil, false
    end

    return {
        BuildGrid = buildGrid,
        FindPath = findPath,
        IsLineClear = isLineClear,
    }
end

return Pathfinder

end)()

local ObstacleDataModule = (function()
--[[
    Collect treadmill/trap obstacle rects for pathfinding.
]]

local ObstacleData = {}

function ObstacleData.create(deps)
    local Config = deps.Config
    local Util = deps.Util
    local Workspace = deps.Workspace
    local CollectionService = deps.CollectionService
    local Constants = deps.Constants

    local layout = Config.Layout
    local runtime = Config.Runtime
    local placedTrapTag = Constants.TAGS_MAP.Traps.PLACED_TRAP

    local obstacleCache = {
        data = nil,
        origin = nil,
        radius = nil,
        at = 0,
    }

    local function boundsToObstacle(center, halfSize, extraPadding)
        extraPadding = extraPadding or runtime.pathObstaclePadding

        local hx, hz

        if typeof(halfSize) == "Vector3" then
            hx, hz = halfSize.X, halfSize.Z
        else
            hx, hz = halfSize, halfSize
        end

        hx = hx + extraPadding
        hz = hz + extraPadding

        return {
            minX = center.X - hx,
            maxX = center.X + hx,
            minZ = center.Z - hz,
            maxZ = center.Z + hz,
            kind = "obstacle",
        }
    end

    local function resolveTrapBounds(trap)
        local hitbox = trap:FindFirstChild("Hitbox")
        local padding = layout.trapBoundsPadding

        if hitbox and hitbox:IsA("BasePart") then
            return Util.groundBoundsFromPart(hitbox, padding)
        end

        return Util.groundBoundsFromPart(trap, padding)
    end

    local function collectTreadmills(origin, maxRadius)
        local obstacles = {}
        local seen = {}
        local padding = layout.treadmillBoundsPadding
        local renderFolder = Workspace:FindFirstChild("__ClientTreadmillRenders")

        if renderFolder then
            for _, model in ipairs(renderFolder:GetChildren()) do
                if model:IsA("Model") then
                    local slot = model.Name:match("^TreadmillRender_(.+)$")

                    if slot and not seen[slot] then
                        seen[slot] = true
                        local center, halfSize = Util.groundBoundsFromModel(model, padding)

                        if center and (not origin or (Vector3.new(center.X, 0, center.Z) - Vector3.new(origin.X, 0, origin.Z)).Magnitude <= maxRadius) then
                            table.insert(obstacles, boundsToObstacle(center, halfSize, runtime.pathTreadmillPadding or 8))
                        end
                    end
                end
            end
        end

        local plots = Workspace:FindFirstChild("Plots")

        if plots then
            for _, plot in ipairs(plots:GetChildren()) do
                local slot = plot.Name

                if not seen[slot] then
                    local bottom = plot:FindFirstChild("TreadmillBottom")

                    if bottom and bottom:IsA("BasePart") then
                        seen[slot] = true
                        local groundY = bottom.Position.Y - bottom.Size.Y * 0.5
                        local center, halfSize = Util.groundBoundsFromPart(bottom, padding, groundY)

                        if not origin or (Vector3.new(center.X, 0, center.Z) - Vector3.new(origin.X, 0, origin.Z)).Magnitude <= maxRadius then
                            table.insert(obstacles, boundsToObstacle(center, halfSize, runtime.pathTreadmillPadding or 8))
                        end
                    end
                end
            end
        end

        return obstacles
    end

    local function collectTraps(origin, maxRadius, avoidOwnTraps)
        local obstacles = {}

        for _, trap in ipairs(CollectionService:GetTagged(placedTrapTag)) do
            if trap:IsA("BasePart") and trap.Parent then
                local owner = trap:GetAttribute("Owner")
                local isOwn = typeof(owner) == "string" and owner == deps.LocalPlayer.Name

                if avoidOwnTraps ~= true or not isOwn then
                    local hitbox = trap:FindFirstChild("Hitbox")
                    local sample = hitbox and hitbox.Position or trap.Position

                    if not origin or (Vector3.new(sample.X, 0, sample.Z) - Vector3.new(origin.X, 0, origin.Z)).Magnitude <= maxRadius then
                        local center, halfSize = resolveTrapBounds(trap)

                        if center then
                            table.insert(obstacles, boundsToObstacle(center, halfSize, runtime.pathTrapPadding or 6))
                        end
                    end
                end
            end
        end

        return obstacles
    end

    local function collectAround(origin, maxRadius)
        maxRadius = maxRadius or runtime.pathSearchRadius

        local ttl = runtime.obstacleCacheTtl or 1.0
        local now = os.clock()

        if obstacleCache.data
            and obstacleCache.radius == maxRadius
            and obstacleCache.origin
            and (origin - obstacleCache.origin).Magnitude < 12
            and now - obstacleCache.at < ttl then
            return obstacleCache.data
        end

        local treadmills = collectTreadmills(origin, maxRadius)
        local traps = collectTraps(origin, maxRadius, runtime.pathAvoidOwnTraps == true)

        local all = {}

        for _, obstacle in ipairs(treadmills) do
            table.insert(all, obstacle)
        end

        for _, obstacle in ipairs(traps) do
            table.insert(all, obstacle)
        end

        obstacleCache.data = all
        obstacleCache.origin = origin
        obstacleCache.radius = maxRadius
        obstacleCache.at = now

        return all
    end

    return {
        CollectAround = collectAround,
        CollectTreadmills = collectTreadmills,
        CollectTraps = collectTraps,
        InvalidateCache = function()
            obstacleCache.at = 0
        end,
    }
end

return ObstacleData

end)()

local PathServiceModule = (function()
--[[
    Obstacle-avoiding path computation for auto farm movement.
]]

local PathService = {}

function PathService.create(deps)
    local Config = deps.Config
    local ObstacleData = deps.ObstacleData
    local Pathfinder = deps.Pathfinder

    local runtime = Config.Runtime

    local function mergeObstacles(...)
        local merged = {}
        local seen = {}

        for _, list in ipairs({ ... }) do
            if list then
                for _, obstacle in ipairs(list) do
                    local key = string.format(
                        "%.1f:%.1f:%.1f:%.1f",
                        obstacle.minX,
                        obstacle.minZ,
                        obstacle.maxX,
                        obstacle.maxZ
                    )

                    if not seen[key] then
                        seen[key] = true
                        table.insert(merged, obstacle)
                    end
                end
            end
        end

        return merged
    end

    local function collectObstaclesForSegment(playerPos, goalPos)
        local groundY = playerPos.Y - 2.5
        local startPos = Vector3.new(playerPos.X, groundY, playerPos.Z)
        local goalFlat = Vector3.new(goalPos.X, groundY, goalPos.Z)
        local segmentLength = (startPos - goalFlat).Magnitude
        local searchRadius = math.max(
            runtime.pathSearchRadius,
            segmentLength + runtime.pathSearchMargin
        )

        local midPos = startPos:Lerp(goalFlat, 0.5)

        local startObstacles = ObstacleData.CollectAround(startPos, searchRadius)
        local midObstacles = ObstacleData.CollectAround(midPos, searchRadius)
        local goalObstacles = ObstacleData.CollectAround(goalFlat, searchRadius)

        return startPos, goalFlat, mergeObstacles(startObstacles, midObstacles, goalObstacles)
    end

    local function computePathBetween(playerPos, goalPos)
        local startPos, goalFlat, obstacles = collectObstaclesForSegment(playerPos, goalPos)
        local groundY = startPos.Y

        return Pathfinder.FindPath(startPos, goalFlat, obstacles, {
            cellSize = runtime.pathCellSize,
            margin = runtime.pathSearchMargin,
            obstaclePadding = runtime.pathObstaclePadding,
            maxCells = runtime.pathMaxCells,
            groundY = groundY + runtime.pathDrawYOffset,
            maxIterations = runtime.pathMaxIterations,
        })
    end

    local function isLineClearBetween(playerPos, goalPos)
        if not playerPos or not goalPos then
            return false
        end

        local startPos, goalFlat, obstacles = collectObstaclesForSegment(playerPos, goalPos)

        return Pathfinder.IsLineClear(startPos.X, startPos.Z, goalFlat.X, goalFlat.Z, obstacles)
    end

    return {
        ComputePathBetween = computePathBetween,
        IsLineClearBetween = isLineClearBetween,
        Invalidate = function()
            if ObstacleData.InvalidateCache then
                ObstacleData.InvalidateCache()
            end
        end,
    }
end

return PathService

end)()

local GuardZoneModule = (function()
--[[
    Detect egg/guard zones where client-only tween desyncs from server hit detection.
]]

local GuardZone = {}

function GuardZone.create(deps)
    local Workspace = deps.Workspace
    local ReplicatedStorage = deps.ReplicatedStorage
    local Config = deps.Config
    local runtime = Config and Config.Runtime or {}

    local GuardAreaGeometry = nil

    pcall(function()
        GuardAreaGeometry = require(ReplicatedStorage.Shared.Util.GuardAreaGeometry)
    end)

    local separationLine = nil
    local areaEntries = {}

    local function getAreasFolder()
        local objects = Workspace:FindFirstChild("__OBJECTS")

        if not objects then
            return nil
        end

        return objects:FindFirstChild("Areas")
    end

    local function rebuildAreaEntries()
        table.clear(areaEntries)

        if not GuardAreaGeometry then
            return
        end

        local areasFolder = getAreasFolder()

        if not areasFolder then
            return
        end

        separationLine = areasFolder:FindFirstChild("SeparationLine")

        local guardAreas = areasFolder:FindFirstChild("GuardAreas")

        if guardAreas then
            for _, entry in ipairs(GuardAreaGeometry.ReadAreaBounds(guardAreas)) do
                table.insert(areaEntries, entry)
            end
        end

        local cherryBlossom = areasFolder:FindFirstChild("CherryBlossom")
        local bounds = cherryBlossom and cherryBlossom:FindFirstChild("Bounds")

        if bounds and bounds:IsA("BasePart") then
            table.insert(areaEntries, {
                AreaId = "CherryBlossom",
                Bounds = bounds,
            })
        end
    end

    local function isPastSeparationLine(position)
        if not GuardAreaGeometry or not separationLine or not position then
            return false
        end

        return GuardAreaGeometry.IsPastLine(separationLine, position)
    end

    local function isWithinGuardFootprint(position)
        if not GuardAreaGeometry or not position then
            return false
        end

        for _, entry in ipairs(areaEntries) do
            local bounds = entry.Bounds

            if bounds and bounds.Parent and GuardAreaGeometry.IsWithinFootprint(bounds, position) then
                return true
            end
        end

        return false
    end

    local function isGuardZonePosition(position)
        if not position then
            return false
        end

        if #areaEntries == 0 and not separationLine then
            rebuildAreaEntries()
        end

        return isPastSeparationLine(position) or isWithinGuardFootprint(position)
    end

    local function horizontalDistance(a, b)
        return (Vector3.new(a.X, 0, a.Z) - Vector3.new(b.X, 0, b.Z)).Magnitude
    end

    local function shouldUseWalkMovement(fromPos, toPos)
        if not fromPos then
            return false
        end

        if isGuardZonePosition(fromPos) then
            return true
        end

        if not toPos or not isGuardZonePosition(toPos) then
            return false
        end

        local approach = runtime.guardZoneWalkApproach or runtime.pickupApproachRadius or 80

        return horizontalDistance(fromPos, toPos) <= approach
    end

    rebuildAreaEntries()

    return {
        Refresh = rebuildAreaEntries,
        IsPastSeparationLine = isPastSeparationLine,
        IsWithinGuardFootprint = isWithinGuardFootprint,
        IsGuardZonePosition = isGuardZonePosition,
        ShouldUseWalkMovement = shouldUseWalkMovement,
    }
end

return GuardZone

end)()

local MovementModule = (function()
--[[
    Tween movement matching ObbyAntiTP bypass pattern:
    clone Humanoid -> WalkSpeed 0 -> tween PrimaryPart -> restore WalkSpeed on complete.
]]

local Movement = {}

function Movement.create(deps)
    local Config = deps.Config
    local LocalPlayer = deps.LocalPlayer
    local GuardZone = deps.GuardZone
    local TweenService = game:GetService("TweenService")

    local runtime = Config.Runtime

    local cache = nil
    local clonedCharacter = nil
    local bypassPrepared = false
    local activeTween = nil
    local activeTarget = nil
    local onCompleteCallback = nil
    local walkTarget = nil
    local walkCompleteCallback = nil
    local walkConnection = nil
    local walkStartedAt = 0
    local walkLastPos = nil
    local serverActionMode = false
    local onBypassPrepared = nil

    local function getCharacter()
        return LocalPlayer.Character
    end

    local function getRootPart()
        local character = getCharacter()
        return character and (character.PrimaryPart or character:FindFirstChild("HumanoidRootPart"))
    end

    local function getHumanoid()
        local character = getCharacter()
        return character and character:FindFirstChildOfClass("Humanoid")
    end

    local function horizontalDistance(a, b)
        return (Vector3.new(a.X, 0, a.Z) - Vector3.new(b.X, 0, b.Z)).Magnitude
    end

    local function isNear(position, target, radius)
        return horizontalDistance(position, target) <= radius
    end

    local function flatXZ(target, rootPart)
        local y = rootPart and rootPart.Position.Y or target.Y

        return Vector3.new(target.X, y, target.Z)
    end

    local function ensureCache(character, humanoid)
        if not cache or cache.Character ~= character then
            cache = { Character = character }

            for _, property in ipairs({ "WalkSpeed", "JumpPower", "JumpHeight", "AutoRotate", "PlatformStand" }) do
                cache[property] = humanoid[property]
            end
        end
    end

    local function savedWalkSpeed()
        return cache and cache.WalkSpeed or 16
    end

    local function restoreHumanoidWalkSpeed()
        local character = getCharacter()
        local humanoid = getHumanoid()

        if not humanoid then
            return
        end

        ensureCache(character, humanoid)
        humanoid.WalkSpeed = savedWalkSpeed()
        humanoid.PlatformStand = false
        humanoid.AutoRotate = true
    end

    local function clearStaleWalk()
        walkTarget = nil
        walkCompleteCallback = nil
        walkStartedAt = 0
        walkLastPos = nil
        clearWalkConnection()
        restoreHumanoidWalkSpeed()
    end

    local function zeroRootVelocity()
        local rootPart = getRootPart()

        if rootPart then
            rootPart.AssemblyLinearVelocity = Vector3.zero
            rootPart.AssemblyAngularVelocity = Vector3.zero
        end
    end

    local function shouldCloneHumanoid()
        return runtime.movementHumanoidClone ~= false
    end

    local function prepareTweenHumanoid(character, oldHumanoid)
        ensureCache(character, oldHumanoid)

        if not shouldCloneHumanoid() then
            oldHumanoid.WalkSpeed = 0
            return oldHumanoid
        end

        if clonedCharacter == character and oldHumanoid and oldHumanoid.Parent == character then
            oldHumanoid.WalkSpeed = 0
            return oldHumanoid
        end

        oldHumanoid.Archivable = true
        local humanoid = oldHumanoid:Clone()

        humanoid.BreakJointsOnDeath = false
        oldHumanoid:Destroy()
        humanoid.Parent = character
        humanoid.WalkSpeed = 0

        if not humanoid:FindFirstChildOfClass("Animator") then
            Instance.new("Animator", humanoid)
        end

        clonedCharacter = character
        bypassPrepared = true

        if onBypassPrepared then
            pcall(onBypassPrepared)
        end

        return humanoid
    end

    local function stopActiveTween(silent)
        if activeTween then
            activeTween:Cancel()
            activeTween = nil
        end

        activeTarget = nil
        zeroRootVelocity()
        restoreHumanoidWalkSpeed()

        local callback = onCompleteCallback
        onCompleteCallback = nil

        if callback and not silent then
            callback(false)
        end
    end

    local function clearWalkConnection()
        if walkConnection then
            walkConnection:Disconnect()
            walkConnection = nil
        end
    end

    local function cancelWalk()
        walkTarget = nil
        walkCompleteCallback = nil
        walkStartedAt = 0
        walkLastPos = nil
        clearWalkConnection()

        local humanoid = getHumanoid()
        local rootPart = getRootPart()

        if humanoid and rootPart then
            humanoid:MoveTo(rootPart.Position)
        end

        restoreHumanoidWalkSpeed()
    end

    local function prepareForServerAction()
        stopActiveTween(true)
        cancelWalk()
        zeroRootVelocity()

        local humanoid = getHumanoid()

        if humanoid then
            humanoid.PlatformStand = false
            humanoid.AutoRotate = true
        end
    end

    local function setServerActionMode(enabled)
        local want = enabled == true

        if want == serverActionMode then
            return
        end

        serverActionMode = want

        if serverActionMode then
            prepareForServerAction()
        end
    end

    local function isServerActionMode()
        return serverActionMode
    end

    local function prepareBypass()
        return getRootPart() ~= nil
    end

    local function walkTo(target, speed, onComplete)
        stopActiveTween(true)

        local character = getCharacter()
        local humanoid = getHumanoid()
        local rootPart = getRootPart()

        if not character or not humanoid or not rootPart then
            if onComplete then
                onComplete(false)
            end

            return false
        end

        ensureCache(character, humanoid)
        zeroRootVelocity()

        local flatTarget = flatXZ(target, rootPart)
        local arriveRadius = runtime.pathWaypointRadius or 5

        if isNear(rootPart.Position, flatTarget, arriveRadius) then
            walkTarget = nil
            walkCompleteCallback = nil
            clearWalkConnection()

            if onComplete then
                onComplete(true)
            end

            return true
        end

        if walkTarget and horizontalDistance(walkTarget, flatTarget) < 2 then
            walkCompleteCallback = onComplete
            return true
        end

        clearWalkConnection()

        humanoid.WalkSpeed = speed or runtime.pickupSyncWalkSpeed or 24
        humanoid.AutoRotate = true
        humanoid.PlatformStand = false
        humanoid:MoveTo(flatTarget)
        walkTarget = flatTarget
        walkCompleteCallback = onComplete
        walkStartedAt = os.clock()
        walkLastPos = rootPart.Position

        walkConnection = humanoid.MoveToFinished:Connect(function(reached)
            if not walkTarget or horizontalDistance(walkTarget, flatTarget) >= 2 then
                return
            end

            clearWalkConnection()

            local callback = walkCompleteCallback
            walkTarget = nil
            walkCompleteCallback = nil

            if callback then
                callback(reached)
            end
        end)

        return true
    end

    local function isWalking()
        return walkTarget ~= nil
    end

    local function isWalkNear(target, radius)
        local rootPart = getRootPart()

        if not rootPart or not target then
            return false
        end

        return horizontalDistance(rootPart.Position, target) <= (radius or 2)
    end

    local function cancelTween(silent)
        stopActiveTween(silent)
    end

    local function cancelMovement()
        stopActiveTween(true)
        cancelWalk()
    end

    local function buildTargetCFrame(rootPart, target)
        local flatTarget = flatXZ(target, rootPart)
        local delta = Vector3.new(flatTarget.X - rootPart.Position.X, 0, flatTarget.Z - rootPart.Position.Z)

        if delta.Magnitude > 0.05 then
            return CFrame.new(flatTarget, flatTarget + delta)
        end

        return CFrame.new(flatTarget) * rootPart.CFrame.Rotation
    end

    local function isTweeningTo(target)
        if activeTween == nil or activeTarget == nil then
            return false
        end

        local ok, playbackState = pcall(function()
            return activeTween.PlaybackState
        end)

        if ok and playbackState ~= Enum.PlaybackState.Playing then
            activeTween = nil
            activeTarget = nil
            restoreHumanoidWalkSpeed()
            return false
        end

        return horizontalDistance(activeTarget, target) < 2
    end

    local function updateWalkStale(rootPart, flatTarget)
        if not walkTarget then
            return false
        end

        if isNear(rootPart.Position, flatTarget, runtime.pathWaypointRadius or 5) then
            clearStaleWalk()
            return true
        end

        local now = os.clock()

        if walkLastPos and horizontalDistance(rootPart.Position, walkLastPos) >= 0.35 then
            walkLastPos = rootPart.Position
            walkStartedAt = now
            return false
        end

        walkLastPos = rootPart.Position

        if now - (walkStartedAt or now) >= 1.5 then
            clearStaleWalk()
            return true
        end

        return false
    end

    local function isMovingTo(target)
        local rootPart = getRootPart()

        if not rootPart or not target then
            return false
        end

        local flatTarget = flatXZ(target, rootPart)

        if isTweeningTo(flatTarget) then
            return true
        end

        if walkTarget and horizontalDistance(walkTarget, flatTarget) < 2 then
            if updateWalkStale(rootPart, flatTarget) then
                return false
            end

            if isNear(rootPart.Position, flatTarget, runtime.pathWaypointRadius or 5) then
                return false
            end

            return true
        end

        return false
    end

    local function isActivelyMovingTo(target)
        if not isMovingTo(target) then
            return false
        end

        return activeTween ~= nil or walkTarget ~= nil
    end

    local function ensureLocomotion()
        restoreHumanoidWalkSpeed()
        zeroRootVelocity()
    end

    local function tweenTo(target, speed, onComplete)
        if serverActionMode then
            walkTo(target, runtime.pickupSyncWalkSpeed or 24, onComplete)
            return nil
        end

        cancelWalk()

        local character = getCharacter() or LocalPlayer.CharacterAdded:Wait()

        if clonedCharacter and clonedCharacter ~= character then
            clonedCharacter = nil
            cache = nil
            bypassPrepared = false
        end

        local rootPart = character.PrimaryPart or character:FindFirstChild("HumanoidRootPart")
        local oldHumanoid = character:FindFirstChildOfClass("Humanoid")

        if not rootPart or not oldHumanoid then
            if onComplete then
                onComplete(false)
            end

            return nil
        end

        local flatTarget = flatXZ(target, rootPart)

        if activeTween and activeTarget and horizontalDistance(activeTarget, flatTarget) < 2 then
            onCompleteCallback = onComplete
            return activeTween
        end

        if isNear(rootPart.Position, flatTarget, runtime.pathWaypointRadius or 5) then
            if onComplete then
                onComplete(true)
            end

            return nil
        end

        stopActiveTween(true)

        prepareTweenHumanoid(character, oldHumanoid)
        zeroRootVelocity()

        local targetCFrame = buildTargetCFrame(rootPart, flatTarget)
        local distance = (targetCFrame.Position - rootPart.Position).Magnitude
        local tweenSpeed = math.max(speed or runtime.tweenSpeed or 450, 300)
        local tween = TweenService:Create(
            rootPart,
            TweenInfo.new(distance / tweenSpeed, Enum.EasingStyle.Linear),
            { CFrame = targetCFrame }
        )

        activeTween = tween
        activeTarget = flatTarget
        onCompleteCallback = onComplete

        tween:Play()

        tween.Completed:Once(function(playbackState)
            if activeTween ~= tween then
                return
            end

            activeTween = nil
            activeTarget = nil

            local callback = onCompleteCallback
            onCompleteCallback = nil

            zeroRootVelocity()

            if playbackState == Enum.PlaybackState.Completed then
                rootPart.CFrame = targetCFrame
            end

            local humanoid = getHumanoid()

            if humanoid and humanoid.Parent then
                humanoid.WalkSpeed = savedWalkSpeed()
            end

            if callback then
                callback(playbackState == Enum.PlaybackState.Completed)
            end
        end)

        return tween
    end

    local function moveToward(target, onComplete)
        return tweenTo(target, runtime.tweenSpeed, onComplete)
    end

    local function isInGuardZone()
        local rootPart = getRootPart()

        if not rootPart or not GuardZone or not GuardZone.IsGuardZonePosition then
            return false
        end

        return GuardZone.IsGuardZonePosition(rootPart.Position)
    end

    local function isTweening()
        if activeTween == nil then
            return false
        end

        local ok, playbackState = pcall(function()
            return activeTween.PlaybackState
        end)

        return ok and playbackState == Enum.PlaybackState.Playing
    end

    local function isTweenMode()
        return activeTween ~= nil
    end

    local function isBypassPrepared()
        return bypassPrepared
    end

    local function reset()
        stopActiveTween(true)
        cancelWalk()
        serverActionMode = false
        bypassPrepared = false
        clonedCharacter = nil
        cache = nil
    end

    local function setBypassPreparedCallback(callback)
        onBypassPrepared = callback
    end

    return {
        GetCharacter = getCharacter,
        GetRootPart = getRootPart,
        GetHumanoid = getHumanoid,
        HorizontalDistance = horizontalDistance,
        IsNear = isNear,
        PrepareBypass = prepareBypass,
        TweenTo = tweenTo,
        MoveToward = moveToward,
        WalkTo = walkTo,
        IsWalking = isWalking,
        IsWalkNear = isWalkNear,
        PrepareForServerAction = prepareForServerAction,
        SetServerActionMode = setServerActionMode,
        IsServerActionMode = isServerActionMode,
        CancelTween = cancelTween,
        CancelWalk = cancelWalk,
        CancelMovement = cancelMovement,
        EnsureLocomotion = ensureLocomotion,
        IsTweening = isTweening,
        IsTweenMode = isTweenMode,
        IsMovingTo = isMovingTo,
        IsActivelyMovingTo = isActivelyMovingTo,
        IsInGuardZone = isInGuardZone,
        IsBypassPrepared = isBypassPrepared,
        IsTweeningTo = isTweeningTo,
        Reset = reset,
        SetBypassPreparedCallback = setBypassPreparedCallback,
    }
end

return Movement

end)()

local AutoFarmModule = (function()
--[[
    Auto farm: standby -> rarest egg -> pickup -> return standby -> repeat.
]]

local AutoFarm = {}

local CARRY_RADIUS = 8
local PICKUP_MOVE_RADIUS = 12

local PHASE = {
    Standby = "Standby",
    GoToEgg = "GoToEgg",
    Pickup = "Pickup",
    ReturnStandby = "ReturnStandby",
    WaitDeposit = "WaitDeposit",
    ManageInventory = "ManageInventory",
    FeedParasite = "FeedParasite",
    WaitForDay = "WaitForDay",
    Idle = "Idle",
}

function AutoFarm.create(deps)
    local Config = deps.Config
    local EggData = deps.EggData
    local PathService = deps.PathService
    local Movement = deps.Movement
    local EggState = deps.EggState
    local AreaEggSlotIdentity = deps.AreaEggSlotIdentity
    local Passthrough = deps.Passthrough
    local SpeedBypass = deps.SpeedBypass
    local InventoryManager = deps.InventoryManager
    local DayCycle = deps.DayCycle
    local PetAutomation = deps.PetAutomation
    local LocalPlayer = deps.LocalPlayer

    local runtime = Config.Runtime

    local state = {
        enabled = false,
        phase = PHASE.Idle,
        targetEgg = nil,
        waypoints = nil,
        waypointIndex = 1,
        pathGoal = nil,
        carryUid = nil,
        isCarrying = false,
        lastPathCalc = 0,
        stuckTimer = 0,
        lastPosition = nil,
        connection = nil,
        characterConnection = nil,
        detail = nil,
        lastTargetRefresh = 0,
        pickupFailCount = 0,
        pickupSettleTicks = 0,
        requireStandbyOnStart = false,
        phaseEnteredAt = 0,
        lastProgressAt = 0,
        lastProgressPos = nil,
        standbyStartAt = 0,
        depositWaitSince = nil,
        carryConfirmedAt = nil,
        farmStartedAt = 0,
        wasDayBlocked = false,
        rushFarmAfterDay = false,
    }

    local function compareEggPriority(a, b)
        if not a then
            return false
        end

        if not b then
            return true
        end

        if a.rarityTier ~= b.rarityTier then
            return a.rarityTier > b.rarityTier
        end

        if runtime.autoFarmInfestedFirst ~= false then
            local aInfested = a.hasParasite == true
            local bInfested = b.hasParasite == true

            if aInfested ~= bInfested then
                return aInfested
            end
        end

        if a.dropWeight ~= b.dropWeight then
            return a.dropWeight < b.dropWeight
        end

        return a.distance < b.distance
    end

    local function formatTargetDetail(egg)
        local zoneLabel = egg.areaName or egg.info.areaName or "?"
        return string.format("[%s] %s (%s)", zoneLabel, egg.info.name, egg.info.rarityName)
    end

    local function isAtStandbyStart(rootPos, standbyPos)
        local radius = runtime.standbyStartRadius or runtime.standbyArriveRadius or 6
        return Movement.IsNear(rootPos, standbyPos, radius)
    end

    local function isAtStandby(rootPos, standbyPos)
        return Movement.IsNear(rootPos, standbyPos, runtime.standbyArriveRadius)
    end

    local function clearTargetPath()
        state.waypoints = nil
        state.pathGoal = nil
        state.waypointIndex = 1
    end

    local function setTargetEgg(egg, updatePhaseDetail)
        local changed = not state.targetEgg or not egg or state.targetEgg.uid ~= egg.uid

        state.targetEgg = egg

        if changed then
            state.pickupFailCount = 0
            clearTargetPath()
        end

        if egg and updatePhaseDetail then
            state.detail = formatTargetDetail(egg)
        end
    end

    local function setPhase(phase, detail)
        local phaseChanged = state.phase ~= phase
        local oldPhase = state.phase

        if phaseChanged or state.detail ~= detail then
            state.phase = phase
            state.detail = detail

            if phaseChanged then
                state.phaseEnteredAt = os.clock()

                local movementPhases = {
                    [PHASE.GoToEgg] = true,
                    [PHASE.Pickup] = true,
                    [PHASE.ReturnStandby] = true,
                }
                local sameMovement = movementPhases[oldPhase] and movementPhases[phase]

                if not sameMovement then
                    state.waypointIndex = 1
                    state.stuckTimer = 0
                    state.lastPosition = nil
                    Movement.CancelMovement()
                else
                    state.stuckTimer = 0
                end

                if phase == PHASE.WaitDeposit then
                    state.depositWaitSince = os.clock()
                elseif phase ~= PHASE.ReturnStandby or not state.isCarrying then
                    state.depositWaitSince = nil
                end
            end

            print(string.format("[EggESP Auto] %s%s", phase, detail and (" - " .. detail) or ""))
        end
    end

    local function setServerActionMode(enabled)
        if SpeedBypass and SpeedBypass.SetServerActionMode then
            SpeedBypass.SetServerActionMode(enabled)
        elseif Movement.SetServerActionMode then
            Movement.SetServerActionMode(enabled)
        end
    end

    local function noteProgress(rootPos)
        local now = os.clock()
        local minDist = runtime.autoFarmProgressMinDist or 3

        if state.lastProgressPos then
            if Movement.HorizontalDistance(rootPos, state.lastProgressPos) >= minDist then
                state.lastProgressAt = now
                state.lastProgressPos = rootPos
            end
        else
            state.lastProgressAt = now
            state.lastProgressPos = rootPos
        end
    end

    local function recoverFromStuck(reason)
        print(string.format("[EggESP Auto] Recovery: %s", reason))
        Movement.CancelMovement()
        if Movement.EnsureLocomotion then
            Movement.EnsureLocomotion()
        end
        setServerActionMode(false)
        clearTargetPath()
        state.pickupSettleTicks = 0
        state.pickupFailCount = 0
        state.lastProgressAt = os.clock()
        state.lastProgressPos = Movement.GetRootPart() and Movement.GetRootPart().Position or nil

        if state.isCarrying then
            local rootPart = Movement.GetRootPart()
            local standbyPos = runtime.standbyPosition

            if rootPart and isAtStandby(rootPart.Position, standbyPos) then
                state.depositWaitSince = os.clock()
                setPhase(PHASE.WaitDeposit, "recovery deposit")
            else
                setPhase(PHASE.ReturnStandby, reason)
            end

            return
        end

        if state.phase == PHASE.Pickup or state.phase == PHASE.GoToEgg then
            state.targetEgg = nil
        end

        setPhase(PHASE.Standby, reason)
    end

    local function checkWatchdog(rootPart)
        if not rootPart then
            return
        end

        local now = os.clock()
        local phaseAge = now - (state.phaseEnteredAt or now)
        local progressAge = now - (state.lastProgressAt or now)

        if state.requireStandbyOnStart then
            local standbyTimeout = runtime.autoFarmStandbyStartTimeout or 30

            if now - (state.standbyStartAt or now) >= standbyTimeout then
                state.requireStandbyOnStart = false
                clearTargetPath()
                print("[EggESP Auto] Recovery: standby start timeout")
            end
        end

        if state.isCarrying and state.depositWaitSince then
            local depositTimeout = runtime.autoFarmDepositTimeout or 45

            if now - state.depositWaitSince >= depositTimeout then
                state.isCarrying = false
                state.carryUid = nil
                state.depositWaitSince = nil
                recoverFromStuck("deposit timeout")
                return
            end
        end

        if state.phase == PHASE.Pickup then
            local pickupTimeout = runtime.autoFarmPickupTimeout or 60

            if phaseAge >= pickupTimeout then
                state.targetEgg = nil
                recoverFromStuck("pickup timeout")
                return
            end
        end

        if state.phase == PHASE.ManageInventory or state.phase == PHASE.FeedParasite then
            local phaseTimeout = runtime.autoFarmPhaseTimeout or 90

            if phaseAge >= phaseTimeout then
                if InventoryManager then
                    InventoryManager.Stop()
                end

                recoverFromStuck("inventory timeout")
                return
            end
        end

        local idlePhases = {
            [PHASE.GoToEgg] = true,
            [PHASE.Pickup] = true,
            [PHASE.ReturnStandby] = true,
            [PHASE.WaitDeposit] = true,
        }

        local stuckTimeout = runtime.autoFarmStuckTimeout or 22

        if idlePhases[state.phase] then
            if progressAge >= stuckTimeout then
                recoverFromStuck("stuck timeout")
            end
        end

        if state.phase == PHASE.Standby then
            local stallTimeout = runtime.autoFarmStandbyStallTimeout or 10
            local detail = state.detail or ""
            local waiting = detail == "no eggs"
                or detail == "waiting for spawn"
                or detail:find("waiting", 1, true) ~= nil

            if waiting and progressAge >= stallTimeout then
                state.lastProgressAt = os.clock()
                state.lastTargetRefresh = 0
                clearTargetPath()

                if EggData.InvalidateCache then
                    EggData.InvalidateCache()
                end

                PathService.Invalidate()

                if Movement.EnsureLocomotion then
                    Movement.EnsureLocomotion()
                end

                print("[EggESP Auto] Recovery: standby stall refresh")
            end
        end
    end

    local function getStatus()
        local inventoryStatus = InventoryManager and InventoryManager.GetStatus() or nil
        local dayStatus = DayCycle and DayCycle.GetStatus() or nil

        return {
            enabled = state.enabled,
            phase = state.phase,
            detail = state.detail,
            targetEgg = state.targetEgg,
            isCarrying = state.isCarrying,
            carryUid = state.carryUid,
            standby = runtime.standbyPosition,
            inventory = inventoryStatus,
            dayCycle = dayStatus,
            petAutomation = PetAutomation and PetAutomation.GetStatus() or nil,
            pickupFailCount = state.pickupFailCount or 0,
        }
    end

    local function shouldWaitForDay()
        if not runtime.waitForDayBeforeFarm or not DayCycle then
            return false
        end

        return DayCycle.IsEggAreaBlocked()
    end

    local function waitForDayDetail()
        if not DayCycle then
            return "waiting for day"
        end

        local seconds = DayCycle.SecondsUntilDay()

        if seconds > 0 then
            return string.format("%ds until day", seconds)
        end

        local _, reason = DayCycle.IsEggAreaBlocked()

        return reason or "waiting for day"
    end

    local function handleNightWait(rootPart, standbyPos, atStandby)
        if state.phase == PHASE.GoToEgg or state.phase == PHASE.Pickup then
            state.targetEgg = nil
            setPhase(PHASE.ReturnStandby, "night reset")
            return true
        end

        setPhase(PHASE.WaitForDay, waitForDayDetail())

        if not atStandby then
            followPath(standbyPos, runtime.standbyArriveRadius)
        else
            Movement.CancelMovement()
        end

        return true
    end

    local function triggerRushFarmAfterDay()
        state.rushFarmAfterDay = true
        state.lastTargetRefresh = 0
        state.lastPathCalc = 0
        state.targetEgg = nil
        clearTargetPath()

        if EggData.InvalidateCache then
            EggData.InvalidateCache()
        end

        PathService.Invalidate()
        Movement.CancelMovement()
    end

    local function resolveSlotKey(record)
        if record and AreaEggSlotIdentity.LooksLikeFirstAreaUid(record.Uid) then
            return AreaEggSlotIdentity.SlotKey(record.AreaId, record.NestId)
        end

        return nil
    end

    local function findRarestEgg(force)
        if EggData.InvalidateCache and force then
            EggData.InvalidateCache()
        end

        if EggData.FindBestForFarm then
            return EggData.FindBestForFarm(nil, force)
        end

        local eggs = EggData.CollectAll(force)
        return eggs[1]
    end

    local function refreshTargetEgg(force)
        local now = os.clock()
        local interval = state.rushFarmAfterDay and 0
            or (runtime.autoFarmTargetRefreshInterval or 0.75)

        if not force and interval > 0 and now - state.lastTargetRefresh < interval then
            return state.targetEgg
        end

        state.lastTargetRefresh = now

        local bestEgg = findRarestEgg(false)
        local current = state.targetEgg

        if not current then
            setTargetEgg(bestEgg, false)
            return bestEgg
        end

        local refreshed = EggData.FindByUid and EggData.FindByUid(current.uid, false) or nil

        if not refreshed then
            setTargetEgg(bestEgg, state.phase == PHASE.GoToEgg or state.phase == PHASE.Pickup)
            return state.targetEgg
        end

        if bestEgg and bestEgg.uid ~= refreshed.uid then
            if (bestEgg.rarityTier or 0) > (refreshed.rarityTier or 0) then
                setTargetEgg(bestEgg, true)
                return state.targetEgg
            end

            if (bestEgg.rarityTier or 0) == (refreshed.rarityTier or 0)
                and compareEggPriority(bestEgg, refreshed) then
                setTargetEgg(bestEgg, true)
                return state.targetEgg
            end
        end

        if refreshed.worldPos ~= current.worldPos then
            refreshed = EggData.FindByUid(current.uid, true) or refreshed
        end

        state.targetEgg = refreshed
        return refreshed
    end

    local function syncWaypointIndex(rootPos, waypoints)
        if not waypoints or #waypoints == 0 then
            state.waypointIndex = 1
            return
        end

        local bestIndex = state.waypointIndex
        local bestDistance = math.huge

        for index = state.waypointIndex, #waypoints do
            local distance = Movement.HorizontalDistance(rootPos, waypoints[index])

            if distance < bestDistance then
                bestDistance = distance
                bestIndex = index
            end
        end

        while bestIndex < #waypoints
            and Movement.IsNear(rootPos, waypoints[bestIndex], runtime.pathWaypointRadius) do
            bestIndex = bestIndex + 1
        end

        state.waypointIndex = math.clamp(bestIndex, 1, #waypoints)
    end

    local function refreshPath(goalPos, force)
        local rootPart = Movement.GetRootPart()

        if not rootPart or not goalPos then
            state.waypoints = nil
            state.pathGoal = nil
            return false
        end

        local now = os.clock()
        local sameGoal = state.pathGoal and Movement.HorizontalDistance(state.pathGoal, goalPos) < 2

        if not force and sameGoal and state.waypoints and now - state.lastPathCalc < runtime.pathRecalcInterval then
            syncWaypointIndex(rootPart.Position, state.waypoints)
            return true
        end

        PathService.Invalidate()

        local waypoints, found = PathService.ComputePathBetween(rootPart.Position, goalPos)

        if not waypoints or #waypoints == 0 then
            state.waypoints = nil
            state.pathGoal = goalPos
            state.lastPathCalc = now
            return false
        end

        state.waypoints = waypoints
        state.pathGoal = goalPos
        state.lastPathCalc = now
        syncWaypointIndex(rootPart.Position, waypoints)

        return waypoints ~= nil
    end

    local function followPath(goalPos, arriveRadius)
        setServerActionMode(false)

        if Movement.EnsureLocomotion then
            Movement.EnsureLocomotion()
        end

        local rootPart = Movement.GetRootPart()

        if not rootPart then
            return false
        end

        arriveRadius = arriveRadius or runtime.standbyArriveRadius

        if Movement.IsNear(rootPart.Position, goalPos, arriveRadius) then
            Movement.CancelMovement()
            return true
        end

        refreshPath(goalPos, false)

        local waypoints = state.waypoints
        local moveTarget = goalPos

        if waypoints and #waypoints > 0 then
            syncWaypointIndex(rootPart.Position, waypoints)

            if Movement.IsNear(rootPart.Position, waypoints[state.waypointIndex], runtime.pathWaypointRadius)
                and state.waypointIndex < #waypoints then
                state.waypointIndex = state.waypointIndex + 1
            end

            moveTarget = waypoints[state.waypointIndex] or waypoints[#waypoints]
        elseif PathService.IsLineClearBetween and PathService.IsLineClearBetween(rootPart.Position, goalPos) then
            moveTarget = goalPos
        else
            refreshPath(goalPos, true)
            waypoints = state.waypoints

            if waypoints and #waypoints > 0 then
                syncWaypointIndex(rootPart.Position, waypoints)
                moveTarget = waypoints[state.waypointIndex] or waypoints[#waypoints]
            else
                moveTarget = goalPos
            end
        end

        if not waypoints or #waypoints == 0 then
            if not Movement.IsActivelyMovingTo or not Movement.IsActivelyMovingTo(moveTarget) then
                Movement.MoveToward(moveTarget)
            end
        elseif not Movement.IsActivelyMovingTo or not Movement.IsActivelyMovingTo(moveTarget) then
            Movement.MoveToward(moveTarget, function(completed)
                if not completed or not state.enabled then
                    return
                end

                local currentRoot = Movement.GetRootPart()

                if not currentRoot then
                    return
                end

                if Movement.IsNear(currentRoot.Position, goalPos, arriveRadius) then
                    return
                end

                if waypoints and state.waypointIndex < #waypoints then
                    state.waypointIndex = state.waypointIndex + 1
                end
            end)
        end

        if state.lastPosition and Movement.HorizontalDistance(rootPart.Position, state.lastPosition) < 0.2
            and (Movement.IsTweening() or Movement.IsWalking()) then
            state.stuckTimer = state.stuckTimer + 1

            local stuckThreshold = runtime.autoFarmPathStuckTicks or 25

            if state.stuckTimer >= stuckThreshold then
                Movement.CancelMovement()
                if Movement.EnsureLocomotion then
                    Movement.EnsureLocomotion()
                end
                state.waypointIndex = math.min((state.waypointIndex or 1) + 1, #(waypoints or { 1 }))
                refreshPath(goalPos, true)
                state.stuckTimer = 0
                Movement.MoveToward(moveTarget)
            end
        else
            state.stuckTimer = 0
        end

        state.lastPosition = rootPart.Position

        return Movement.IsNear(rootPart.Position, goalPos, arriveRadius)
    end

    local function shouldWalkPickupSync()
        return runtime.autoFarmWalkPickupSync ~= false
    end

    local function carryRadius()
        return runtime.pickupCarryRadius or CARRY_RADIUS
    end

    local function pickupMoveRadius()
        return runtime.pickupMoveRadius
            or runtime.pathWaypointRadius
            or PICKUP_MOVE_RADIUS
    end

    local function eggDistance(rootPos, eggPos)
        return (rootPos - eggPos).Magnitude
    end

    local function refreshEggPosition(egg)
        if not egg or not EggData.FindByUid then
            return egg
        end

        local refreshed = EggData.FindByUid(egg.uid, true)

        if refreshed then
            state.targetEgg = refreshed
            return refreshed
        end

        return egg
    end

    local function approachForServerSync(rootPart, targetPos, arriveRadius)
        if not shouldWalkPickupSync() then
            return eggDistance(rootPart.Position, targetPos) <= arriveRadius
        end

        if eggDistance(rootPart.Position, targetPos) > arriveRadius then
            Movement.WalkTo(targetPos, runtime.pickupSyncWalkSpeed or 24)
            state.pickupSettleTicks = 0
            return false
        end

        local settleTicks = runtime.pickupSyncSettleTicks or 4

        if (state.pickupSettleTicks or 0) < settleTicks then
            state.pickupSettleTicks = (state.pickupSettleTicks or 0) + 1
            Movement.WalkTo(targetPos, runtime.pickupSyncWalkSpeed or 24)
            return false
        end

        return true
    end

    local function prepareForPickup(rootPart, eggPos)
        if eggDistance(rootPart.Position, eggPos) > carryRadius() then
            Movement.PrepareForServerAction()
            Movement.WalkTo(eggPos, runtime.pickupSyncWalkSpeed or 24)
            state.pickupSettleTicks = 0
            return false
        end

        Movement.WalkTo(eggPos, runtime.pickupSyncWalkSpeed or 24)

        local settleTicks = runtime.pickupSyncSettleTicks or 4

        if (state.pickupSettleTicks or 0) < settleTicks then
            state.pickupSettleTicks = (state.pickupSettleTicks or 0) + 1
            return false
        end

        return true
    end

    local function tryPickupEgg()
        local egg = refreshEggPosition(state.targetEgg)

        if not egg or not egg.record then
            setServerActionMode(false)
            return false
        end

        local slotKey = resolveSlotKey(egg.record)
        local ok, reason = EggState.CarryFieldEgg(egg.record.Uid, slotKey)

        if ok == true then
            setServerActionMode(false)
            state.pickupSettleTicks = 0
            state.pickupFailCount = 0
            state.isCarrying = true
            state.carryUid = egg.record.Uid
            state.carryConfirmedAt = os.clock()
            clearTargetPath()
            PathService.Invalidate()
            return true
        end

        if reason then
            state.detail = string.format("denied: %s", reason)
        end

        state.pickupSettleTicks = 0
        state.pickupFailCount = (state.pickupFailCount or 0) + 1
        local maxFails = runtime.autoFarmPickupMaxFails or 5

        if state.pickupFailCount >= maxFails then
            state.pickupFailCount = 0
            state.targetEgg = nil
            clearTargetPath()
            setServerActionMode(false)
            setPhase(PHASE.Standby, reason or "pickup failed")
        end

        return false
    end

    local function tickGoToEgg(rootPart, egg)
        egg = refreshEggPosition(egg)
        local eggPos = egg.worldPos
        local dist = eggDistance(rootPart.Position, eggPos)
        local carryR = carryRadius()
        local moveR = pickupMoveRadius()

        if state.phase == PHASE.Pickup or dist <= moveR then
            setPhase(PHASE.Pickup, dist <= carryR and egg.info.name or "approaching")

            if dist > carryR then
                Movement.WalkTo(eggPos, runtime.pickupSyncWalkSpeed or 24)
                state.pickupSettleTicks = 0
                return
            end

            if not prepareForPickup(rootPart, eggPos) then
                return
            end

            Movement.CancelMovement()

            if tryPickupEgg() then
                state.targetEgg = nil
                setPhase(PHASE.ReturnStandby, egg.info.name)
            elseif not state.isCarrying then
                Movement.WalkTo(eggPos, runtime.pickupSyncWalkSpeed or 24)
            else
                setPhase(PHASE.ReturnStandby, egg.info.name)
            end

            return
        end

        setServerActionMode(false)
        followPath(eggPos, moveR)
    end

    local function shouldAutoPlaceDuringFarm()
        if state.rushFarmAfterDay then
            return false
        end

        if not InventoryManager or not InventoryManager.ShouldAutoPlaceDue then
            return false
        end

        if not InventoryManager.ShouldAutoPlaceDue() then
            return false
        end

        local interval = runtime.autoPlaceInterval or 60
        local farmAge = os.clock() - (state.farmStartedAt or 0)

        return farmAge >= interval
    end

    local function beginGoToEgg()
        if EggData.InvalidateCache then
            EggData.InvalidateCache()
        end

        local egg = findRarestEgg(true)

        if not egg then
            return false
        end

        state.lastTargetRefresh = os.clock()
        setTargetEgg(egg, false)
        state.rushFarmAfterDay = false
        state.lastPathCalc = 0
        setPhase(PHASE.GoToEgg, formatTargetDetail(egg))
        return true
    end

    local function tick()
        if not state.enabled then
            return
        end

        if InventoryManager and InventoryManager.IsActive and InventoryManager.IsActive() then
            local invStatus = InventoryManager.GetStatus and InventoryManager.GetStatus()

            if invStatus and invStatus.autoPlaceBackground then
                InventoryManager.Tick()
                return
            end
        end

        local rootPart = Movement.GetRootPart()

        if not rootPart then
            setPhase(PHASE.Idle, "no character")
            return
        end

        if state.phase == PHASE.Idle then
            setPhase(PHASE.Standby, "recovered")
        end

        noteProgress(rootPart.Position)
        checkWatchdog(rootPart)

        local standbyPos = runtime.standbyPosition
        local atStandby = isAtStandby(rootPart.Position, standbyPos)
        local atStandbyStart = isAtStandbyStart(rootPart.Position, standbyPos)

        if state.isCarrying then
            state.depositWaitSince = state.depositWaitSince or os.clock()

            local depositApproach = runtime.depositApproachRadius or 24

            if shouldWalkPickupSync()
                and Movement.HorizontalDistance(rootPart.Position, standbyPos) <= depositApproach then
                if not approachForServerSync(rootPart, standbyPos, runtime.standbyArriveRadius) then
                    setPhase(PHASE.ReturnStandby, "sync home")
                    return
                end

                setPhase(PHASE.WaitDeposit, "waiting for claim")
                return
            end

            if atStandby then
                setPhase(PHASE.WaitDeposit, "waiting for claim")
                setServerActionMode(false)
                if Movement.EnsureLocomotion then
                    Movement.EnsureLocomotion()
                end
            else
                setPhase(PHASE.ReturnStandby)
                setServerActionMode(false)
                followPath(standbyPos, runtime.standbyArriveRadius)
            end

            return
        end

        if shouldWaitForDay() then
            state.wasDayBlocked = true

            if handleNightWait(rootPart, standbyPos, atStandby) then
                return
            end
        else
            if state.wasDayBlocked then
                triggerRushFarmAfterDay()

                if state.phase == PHASE.WaitForDay or state.phase == PHASE.ReturnStandby then
                    setPhase(PHASE.Standby, "eggs dropped")
                end
            end

            state.wasDayBlocked = false
        end

        if InventoryManager and InventoryManager.ShouldFeedParasite and InventoryManager.ShouldFeedParasite() then
            if not InventoryManager.IsActive() then
                InventoryManager.StartFeedParasite()
            end

            if InventoryManager.IsActive() then
                if state.phase ~= PHASE.FeedParasite then
                    setPhase(PHASE.FeedParasite, "feeding infested eggs")
                end

                InventoryManager.Tick()
                return
            end
        elseif state.phase == PHASE.FeedParasite then
            setPhase(PHASE.Standby, "infested fed")
        end

        if InventoryManager then
            if InventoryManager.ShouldManage() then
                if state.phase ~= PHASE.ManageInventory then
                    setPhase(PHASE.ManageInventory, "inventory full")
                    InventoryManager.Start()
                end

                InventoryManager.Tick()
                return
            end

            if state.phase == PHASE.ManageInventory then
                InventoryManager.Stop()
                setPhase(PHASE.Standby, "inventory cleared")
            end
        end

        if state.phase == PHASE.WaitDeposit then
            if atStandby then
                if shouldAutoPlaceDuringFarm()
                    and InventoryManager.StartBackgroundPlace
                    and InventoryManager.StartBackgroundPlace("between runs") then
                    setPhase(PHASE.Standby, "placing eggs")
                    return
                end

                setServerActionMode(false)
                setPhase(PHASE.Standby, "ready for next egg")
            else
                setServerActionMode(false)
                followPath(standbyPos, runtime.standbyArriveRadius)
            end

            return
        end

        if state.phase == PHASE.Standby then
            if state.requireStandbyOnStart and not atStandby and not atStandbyStart then
                setPhase(PHASE.Standby, "going to start")
                followPath(standbyPos, runtime.standbyArriveRadius)
                return
            end

            if state.requireStandbyOnStart and (atStandby or atStandbyStart) then
                state.requireStandbyOnStart = false
                clearTargetPath()
            end

            if InventoryManager and InventoryManager.ShouldManage() then
                setPhase(PHASE.ManageInventory, "inventory full")
                InventoryManager.Start()
                return
            end

            if shouldWaitForDay() then
                handleNightWait(rootPart, standbyPos, atStandby)
                return
            end

            if atStandby
                and shouldAutoPlaceDuringFarm()
                and InventoryManager.StartBackgroundPlace
                and InventoryManager.StartBackgroundPlace("farm standby") then
                setPhase(PHASE.Standby, "placing eggs")
                return
            end

            if beginGoToEgg() then
                -- fall through to GoToEgg handler in the same tick
            elseif state.rushFarmAfterDay then
                setPhase(PHASE.Standby, "waiting for spawn")
                return
            elseif not atStandby then
                followPath(standbyPos, runtime.standbyArriveRadius)
                return
            else
                setPhase(PHASE.Standby, "no eggs")
                if Movement.EnsureLocomotion then
                    Movement.EnsureLocomotion()
                end
                return
            end
        end

        if state.phase == PHASE.GoToEgg or state.phase == PHASE.Pickup then
            if InventoryManager and InventoryManager.ShouldManage() then
                state.targetEgg = nil
                setPhase(PHASE.ManageInventory, "inventory full")
                InventoryManager.Start()
                return
            end

            local egg = refreshTargetEgg(false)

            if not egg then
                setServerActionMode(false)
                setPhase(PHASE.Standby, "target lost")
                return
            end

            tickGoToEgg(rootPart, egg)
            return
        end

        if state.phase == PHASE.ReturnStandby then
            setServerActionMode(false)

            if atStandby then
                setPhase(PHASE.Standby, "home")
                return
            end

            followPath(standbyPos, runtime.standbyArriveRadius)
            return
        end

        setPhase(PHASE.Standby, "reset")
    end

    local function onCarryChanged(carryState)
        state.isCarrying = carryState.IsCarrying == true
        state.carryUid = carryState.Uid
        state.lastProgressAt = os.clock()

        if state.isCarrying then
            state.carryConfirmedAt = os.clock()
            state.depositWaitSince = nil
        else
            state.carryConfirmedAt = nil
            state.depositWaitSince = nil
            state.targetEgg = nil
            state.waypoints = nil
            state.pathGoal = nil
            setServerActionMode(false)
            state.pickupSettleTicks = 0

            if state.enabled then
                setPhase(PHASE.Standby, "deposit complete")
            end
        end
    end

    local function onCharacterAdded()
        if not state.enabled then
            return
        end

        Movement.Reset()
        setServerActionMode(false)
        clearTargetPath()
        state.targetEgg = nil
        state.isCarrying = false
        state.carryUid = nil
        state.pickupSettleTicks = 0
        state.pickupFailCount = 0
        state.depositWaitSince = nil
        state.carryConfirmedAt = nil
        state.requireStandbyOnStart = true
        state.standbyStartAt = os.clock()
        state.lastProgressAt = os.clock()
        state.lastProgressPos = nil
        PathService.Invalidate()
        setPhase(PHASE.Standby, "respawned")
    end

    local function start()
        if state.enabled then
            return getStatus()
        end

        state.enabled = true
        state.targetEgg = nil
        state.waypoints = nil
        state.pathGoal = nil
        state.waypointIndex = 1
        state.lastTargetRefresh = 0
        state.pickupFailCount = 0
        state.pickupSettleTicks = 0
        state.requireStandbyOnStart = false
        state.farmStartedAt = os.clock()
        state.standbyStartAt = os.clock()
        state.wasDayBlocked = shouldWaitForDay()
        state.rushFarmAfterDay = false
        state.phaseEnteredAt = os.clock()
        state.lastProgressAt = os.clock()
        state.lastProgressPos = nil
        state.depositWaitSince = nil
        state.carryConfirmedAt = nil
        setServerActionMode(false)
        PathService.Invalidate()

        if SpeedBypass then
            if runtime.speedBypassOnAutoFarm then
                SpeedBypass.Enable()
            else
                SpeedBypass.Disable()
            end
        end

        Passthrough.Enable()

        if InventoryManager and InventoryManager.NotifyFarmStarted then
            InventoryManager.NotifyFarmStarted()
        end

        if not state.connection then
            state.connection = EggState.CarryChanged:Connect(onCarryChanged)
        end

        if LocalPlayer and not state.characterConnection then
            state.characterConnection = LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
        end

        setPhase(PHASE.Standby, "started")

        print("[EggESP Auto] Workflow:")
        print("  1. Standby at home position")
        print("  2. Pick rarest allowed field egg (rarity filters apply)")
        print("  3. Carry egg back to standby")
        print("  4. Wait for auto deposit/claim")
        print("  5. Repeat from step 1")
        print("  Night reset: wait at standby until day")

        return getStatus()
    end

    local function stop()
        state.enabled = false
        state.targetEgg = nil
        state.waypoints = nil
        state.pathGoal = nil
        Movement.Reset()
        Passthrough.Disable()

        if SpeedBypass and runtime.speedBypassOnAutoFarm then
            SpeedBypass.Disable()
        end

        if InventoryManager then
            InventoryManager.Stop()
        end

        setPhase(PHASE.Idle, "stopped")

        return getStatus()
    end

    local function destroy()
        stop()

        if state.connection then
            state.connection:Disconnect()
            state.connection = nil
        end

        if state.characterConnection then
            state.characterConnection:Disconnect()
            state.characterConnection = nil
        end
    end

    return {
        Start = start,
        Stop = stop,
        Destroy = destroy,
        GetStatus = getStatus,
        Tick = tick,
        Phases = PHASE,
    }
end

return AutoFarm

end)()

local InventoryManagerModule = (function()
--[[
    Inventory management when egg bag is full:
    1. Feed parasite eggs to Monster Parasite (frog) when event is active
    2. Place unplaced eggs on plot, best rarity first
    3. If plot has no room, sell all remaining unplaced eggs
]]

local InventoryManager = {}

function InventoryManager.create(deps)
    local Config = deps.Config
    local Save = deps.Save
    local Eggs = deps.Eggs
    local Assets = deps.Assets
    local EggState = deps.EggState
    local PlotState = deps.PlotState
    local Remotes = deps.Remotes
    local Movement = deps.Movement
    local LocalPlayer = deps.LocalPlayer
    local Workspace = deps.Workspace
    local MonsterParasiteData = deps.MonsterParasiteData
    local PlacedEggRenderer = deps.PlacedEggRenderer
    local FarmFilters = deps.FarmFilters
    local AutoFarm = nil

    local runtime = Config.Runtime

    local PHASE = {
        Idle = "Idle",
        FeedParasite = "FeedParasite",
        GoToPlot = "GoToPlot",
        GoToMonster = "GoToMonster",
        PlaceEgg = "PlaceEgg",
        SellEggs = "SellEggs",
        WaitEquip = "WaitEquip",
        WaitAction = "WaitAction",
    }

    local state = {
        active = false,
        phase = PHASE.Idle,
        queue = {},
        queueIndex = 1,
        sellMode = false,
        sellUids = nil,
        sellIndex = 1,
        sellStep = nil,
        sellStepUid = nil,
        sellAttempts = 0,
        sellPass = 0,
        autoSellBackground = false,
        autoPlaceBackground = false,
        autoDumpWorstBackground = false,
        lastAutoSellAt = 0,
        lastAutoDumpWorstAt = 0,
        lastAutoPlaceAt = os.clock(),
        currentUid = nil,
        currentAction = nil,
        gridCursor = nil,
        detail = nil,
        waitUntil = 0,
        wearAttempts = 0,
        placeAttempts = 0,
        pendingFeed = false,
        plotFailStreak = 0,
        placeRoundSkipped = {},
        feedOnlyMode = false,
    }

    local function getRootPart()
        if Movement and Movement.GetRootPart then
            return Movement.GetRootPart()
        end

        local character = LocalPlayer.Character

        return character and character:FindFirstChild("HumanoidRootPart")
    end

    local function isNear(position, target, radius)
        if Movement and Movement.IsNear then
            return Movement.IsNear(position, target, radius)
        end

        return (Vector3.new(position.X, 0, position.Z) - Vector3.new(target.X, 0, target.Z)).Magnitude <= radius
    end

    local function tweenTo(target)
        if Movement and Movement.TweenTo then
            Movement.TweenTo(target, runtime.tweenSpeed)
        end
    end

    local function cancelTween()
        if Movement and Movement.CancelTween then
            Movement.CancelTween()
        end
    end

    local function setPhase(phase, detail)
        if state.phase ~= phase or state.detail ~= detail then
            state.phase = phase
            state.detail = detail
            print(string.format("[EggESP Inv] %s%s", phase, detail and (" - " .. detail) or ""))
        end
    end

    local function now()
        return os.clock()
    end

    local function waiting()
        return now() < state.waitUntil
    end

    local function pause(seconds)
        state.waitUntil = now() + (seconds or 0.15)
        setPhase(PHASE.WaitAction, state.detail)
    end

    local function getAssetRarityId(category)
        local entry = Assets.Directory[category]

        if not entry or not entry.Rarity then
            return nil
        end

        return entry.Rarity._id or entry.Rarity.DisplayName
    end

    local function shouldAutoSellEgg(entry)
        if not entry or runtime.autoSellEnabled ~= true then
            return false
        end

        if not FarmFilters or not FarmFilters.IsSellRarityEnabled then
            return false
        end

        local rarityId = getAssetRarityId(entry.category)

        return FarmFilters.IsSellRarityEnabled(rarityId)
    end

    local function getAssetTier(category)
        local entry = Assets.Directory[category]

        if not entry or not entry.Rarity then
            return 0
        end

        return entry.Rarity.RarityNumber or 0
    end

    local function getDropWeight(category)
        local entry = Assets.Directory[category]

        if not entry then
            return math.huge
        end

        return entry.DropWeight or math.huge
    end

    local function countEggs()
        local save = Save.Get()
        local inventory = save and save.EggInventory

        if typeof(inventory) ~= "table" then
            return 0, 0
        end

        local total = 0
        local unplaced = 0

        for _, egg in pairs(inventory) do
            if typeof(egg) == "table" then
                total = total + 1

                if egg.Placement == nil then
                    unplaced = unplaced + 1
                end
            end
        end

        return total, unplaced
    end

    local function isInventoryFull()
        local total = countEggs()
        local maxInventory = Eggs.MAX_INVENTORY or 115

        return total >= maxInventory
    end

    local function collectUnplacedEggs(parasiteOnly)
        local save = Save.Get()
        local inventory = save and save.EggInventory
        local results = {}

        if typeof(inventory) ~= "table" then
            return results
        end

        for uid, egg in pairs(inventory) do
            if typeof(uid) == "string" and typeof(egg) == "table" and egg.Placement == nil then
                local hasParasite = egg.HasParasite == true

                if parasiteOnly == nil or hasParasite == parasiteOnly then
                    table.insert(results, {
                        uid = uid,
                        record = egg,
                        category = egg.AssetCategory,
                        tier = getAssetTier(egg.AssetCategory),
                        dropWeight = getDropWeight(egg.AssetCategory),
                        hasParasite = hasParasite,
                    })
                end
            end
        end

        table.sort(results, function(a, b)
            if a.tier ~= b.tier then
                return a.tier > b.tier
            end

            if a.dropWeight ~= b.dropWeight then
                return a.dropWeight < b.dropWeight
            end

            return a.uid < b.uid
        end)

        return results
    end

    local function isParasiteEventActive()
        local folder = Workspace:FindFirstChild(MonsterParasiteData.WorldFolderName)

        if not folder then
            return false
        end

        for _, child in ipairs(folder:GetChildren()) do
            if child:IsA("BasePart") or child:IsA("Model") then
                return true
            end
        end

        return false
    end

    local function findMonsterPosition()
        local folder = Workspace:FindFirstChild(MonsterParasiteData.WorldFolderName)

        if not folder then
            return nil
        end

        local rootPart = getRootPart()
        local origin = rootPart and rootPart.Position or runtime.standbyPosition
        local bestPos = nil
        local bestDist = math.huge

        for _, child in ipairs(folder:GetChildren()) do
            local part = nil

            if child:IsA("BasePart") then
                part = child
            elseif child:IsA("Model") then
                part = child.PrimaryPart or child:FindFirstChildWhichIsA("BasePart", true)
            end

            if part then
                local dist = (part.Position - origin).Magnitude

                if dist < bestDist then
                    bestDist = dist
                    bestPos = part.Position
                end
            end
        end

        return bestPos
    end

    local function getPlotStandPosition()
        local plot = PlotState.ResolvePlot()

        if not plot then
            return runtime.standbyPosition
        end

        if plot.RespawnPointCFrame then
            return plot.RespawnPointCFrame.Position
        end

        if plot.CenterPoint then
            return plot.CenterPoint.Position
        end

        return runtime.standbyPosition
    end

    local function isEggUnplaced(uid)
        local save = Save.Get()
        local egg = save and save.EggInventory and save.EggInventory[uid]

        return typeof(egg) == "table" and egg.Placement == nil
    end

    local function getEquippedEggUid()
        local character = LocalPlayer.Character

        if not character then
            return nil
        end

        for _, child in ipairs(character:GetChildren()) do
            if child:IsA("Tool") and child:GetAttribute("ItemType") == "AssetEgg" then
                return child:GetAttribute("UID")
            end
        end

        return nil
    end

    local function initGridCursor(petArea)
        if state.gridCursor and state.gridCursor.initialized then
            return
        end

        local half = petArea.Size * 0.5
        local step = runtime.inventoryPlacementStep or 4
        local margin = step * 0.5

        state.gridCursor = {
            initialized = true,
            step = step,
            x = -half.X + margin,
            z = -half.Z + margin,
            xMax = half.X - margin,
            zMax = half.Z - margin,
        }
    end

    local function raycastPlacementCFrame(plot, localX, localZ)
        local petArea = plot.PetArea
        local half = petArea.Size * 0.5
        local rayHeight = math.max(half.Y + 80, 100)
        local localOrigin = Vector3.new(localX, rayHeight, localZ)
        local localTarget = Vector3.new(localX, -half.Y - 5, localZ)
        local worldOrigin = petArea.CFrame:PointToWorldSpace(localOrigin)
        local worldTarget = petArea.CFrame:PointToWorldSpace(localTarget)
        local direction = worldTarget - worldOrigin

        if direction.Magnitude < 0.01 then
            return nil
        end

        local filter = { petArea }
        PlacedEggRenderer.AppendRaycastTargets(filter, LocalPlayer.UserId)

        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Include
        params.FilterDescendantsInstances = filter
        params.IgnoreWater = true

        local result = Workspace:Raycast(worldOrigin, direction, params)

        if not result or result.Instance ~= petArea then
            return nil
        end

        return plot.CenterPoint.CFrame:ToObjectSpace(CFrame.new(result.Position))
    end

    local function nextPlacementCFrame()
        local plot = PlotState.ResolvePlot()

        if not plot or not plot.PetArea or not plot.CenterPoint then
            return nil
        end

        initGridCursor(plot.PetArea)

        local petArea = plot.PetArea
        local cursor = state.gridCursor
        local step = cursor.step

        while cursor.z <= cursor.zMax do
            while cursor.x <= cursor.xMax do
                local localX = cursor.x
                local localZ = cursor.z
                cursor.x = cursor.x + step

                local localCFrame = raycastPlacementCFrame(plot, localX, localZ)

                if localCFrame then
                    return localCFrame
                end
            end

            cursor.x = -petArea.Size.X * 0.5 + step * 0.5
            cursor.z = cursor.z + step
        end

        return nil
    end

    local function isEggEquipped(uid)
        return getEquippedEggUid() == uid
    end

    local function resetGridCursor()
        state.gridCursor = nil
    end

    local function unequipEggTools()
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid:UnequipTools()
        end

        EggState.DoffEggTool(nil)
    end

    local function prepareWear(uid)
        if isEggEquipped(uid) then
            return true
        end

        local equippedUid = getEquippedEggUid()

        if equippedUid and equippedUid ~= uid then
            unequipEggTools()
            pause(0.35)
            return false
        end

        if equippedUid == uid then
            pause(0.1)
            return false
        end

        local ok = EggState.WearEggTool(uid)
        state.wearAttempts = state.wearAttempts + 1

        if ok ~= true then
            pause(0.2)
            return false
        end

        pause(0.35)
        return isEggEquipped(uid)
    end

    local function buildQueue()
        local queue = {}

        if isParasiteEventActive() then
            for _, entry in ipairs(collectUnplacedEggs(true)) do
                table.insert(queue, { action = "feed", uid = entry.uid, tier = entry.tier })
            end
        end

        for _, entry in ipairs(collectUnplacedEggs(false)) do
            if not shouldAutoSellEgg(entry)
                and (not entry.hasParasite or not isParasiteEventActive()) then
                table.insert(queue, { action = "place", uid = entry.uid, tier = entry.tier })
            end
        end

        return queue
    end

    local function getAutoPlaceBatchSize()
        return math.clamp(math.floor(runtime.autoPlaceBatchSize or 5), 1, 20)
    end

    local function getAutoPlaceInterval()
        return math.clamp(math.floor(runtime.autoPlaceInterval or 60), 10, 600)
    end

    local function hasPlaceableEggs()
        for _, entry in ipairs(collectUnplacedEggs(false)) do
            if not shouldAutoSellEgg(entry)
                and (not entry.hasParasite or not isParasiteEventActive()) then
                return true
            end
        end

        return false
    end

    local function hasPlotSpace(force)
        local cache = state.plotSpaceCache
        local now = os.clock()

        if not force and cache and now - (cache.at or 0) < 2 then
            return cache.value == true
        end

        local plot = PlotState.ResolvePlot()

        if not plot or not plot.PetArea or not plot.CenterPoint then
            state.plotSpaceCache = { at = now, value = false }
            return false
        end

        local savedCursor = state.gridCursor
        state.gridCursor = nil
        initGridCursor(plot.PetArea)

        local cframe = nextPlacementCFrame()
        state.gridCursor = savedCursor

        local hasSpace = cframe ~= nil
        state.plotSpaceCache = { at = now, value = hasSpace }

        return hasSpace
    end

    local function buildPlaceBatchQueue(limit)
        local queue = {}
        local count = 0

        for _, entry in ipairs(collectUnplacedEggs(false)) do
            if not shouldAutoSellEgg(entry)
                and (not entry.hasParasite or not isParasiteEventActive()) then
                table.insert(queue, { action = "place", uid = entry.uid, tier = entry.tier })
                count = count + 1

                if count >= limit then
                    break
                end
            end
        end

        return queue
    end

    local function buildFeedQueue()
        local queue = {}

        for _, entry in ipairs(collectUnplacedEggs(true)) do
            table.insert(queue, { action = "feed", uid = entry.uid, tier = entry.tier })
        end

        table.sort(queue, function(a, b)
            return a.tier > b.tier
        end)

        return queue
    end

    local function hasParasiteEggsToFeed()
        if runtime.autoFeedParasiteEnabled == false then
            return false
        end

        if not isParasiteEventActive() then
            return false
        end

        return #collectUnplacedEggs(true) > 0
    end

    local function shouldFeedParasite()
        return hasParasiteEggsToFeed()
    end

    local function isActive()
        return state.active
    end

    local function collectUnplacedEggsForSell(filterByAutoSell)
        local results = collectUnplacedEggs(false)

        if filterByAutoSell == true then
            local filtered = {}

            for _, entry in ipairs(results) do
                if shouldAutoSellEgg(entry) then
                    table.insert(filtered, entry)
                end
            end

            results = filtered
        end

        table.sort(results, function(a, b)
            if a.tier ~= b.tier then
                return a.tier < b.tier
            end

            if a.dropWeight ~= b.dropWeight then
                return a.dropWeight > b.dropWeight
            end

            return a.uid > b.uid
        end)

        return results
    end

    local function collectAutoSellCandidates()
        return collectUnplacedEggsForSell(true)
    end

    local function buildWorstSellUids(limit)
        limit = limit or runtime.autoDumpWorstEggCount or 10
        local candidates = collectUnplacedEggsForSell(false)
        local uids = {}

        for index = 1, math.min(limit, #candidates) do
            table.insert(uids, candidates[index].uid)
        end

        return uids
    end

    local function shouldUseWorstEggDump()
        return runtime.autoDumpWorstEggsEnabled ~= false
            and isInventoryFull()
            and not hasPlotSpace(true)
    end

    local function shouldDumpWorstEggs()
        if runtime.autoDumpWorstEggsEnabled == false then
            return false
        end

        if not isInventoryFull() then
            return false
        end

        if hasPlotSpace(true) then
            return false
        end

        local _, unplaced = countEggs()

        return unplaced > 0
    end

    local function beginWorstEggDumpSell(reason)
        if state.sellMode or (state.active and not state.autoPlaceBackground) then
            return false
        end

        if not shouldDumpWorstEggs() then
            return false
        end

        local sellUids = buildWorstSellUids()

        if #sellUids == 0 then
            return false
        end

        state.sellMode = true
        state.autoSellBackground = true
        state.autoDumpWorstBackground = true
        state.sellUids = sellUids
        state.sellIndex = 1
        state.sellStep = nil
        state.sellStepUid = nil
        state.sellAttempts = 0
        state.sellPass = 0
        state.lastAutoDumpWorstAt = now()
        setPhase(PHASE.SellEggs, reason or string.format("dump worst x%d", #sellUids))

        print(string.format("[EggESP Inv] Dumping %d worst eggs (bag full, plot full)", #sellUids))

        return true
    end

    local function beginBackgroundSell(reason)
        local candidates = collectAutoSellCandidates()

        if #candidates == 0 then
            return false
        end

        state.sellMode = true
        state.autoSellBackground = true
        state.sellUids = { candidates[1].uid }
        state.sellIndex = 1
        state.sellStep = nil
        state.sellStepUid = nil
        state.sellAttempts = 0
        state.sellPass = 0
        setPhase(PHASE.SellEggs, reason or "auto sell")
        return true
    end

    local function finishBackgroundSell()
        state.sellMode = false
        state.autoSellBackground = false
        state.autoDumpWorstBackground = false
        state.sellUids = nil
        state.sellIndex = 1
        state.sellStep = nil
        state.sellStepUid = nil
        state.sellAttempts = 0
        state.lastAutoSellAt = now()
        setPhase(PHASE.Idle, "auto sell idle")
    end

    local function finishBackgroundPlace()
        local placed = state.autoPlacePlacedCount or 0
        local target = state.autoPlaceTargetCount or getAutoPlaceBatchSize()

        state.autoPlaceBackground = false
        state.autoPlaceTargetCount = nil
        state.autoPlacePlacedCount = nil
        state.autoPlaceTriedUids = nil
        state.lastAutoPlaceAt = now()
        stop()
        setPhase(PHASE.Idle, string.format("auto place %d/%d", placed, target))
    end

    local function tryRefillAutoPlaceQueue()
        if not state.autoPlaceBackground then
            return false
        end

        local target = state.autoPlaceTargetCount or getAutoPlaceBatchSize()
        local placed = state.autoPlacePlacedCount or 0

        if placed >= target then
            return false
        end

        local tried = state.autoPlaceTriedUids or {}

        for _, item in ipairs(state.queue) do
            tried[item.uid] = true
        end

        for _, entry in ipairs(collectUnplacedEggs(false)) do
            if not tried[entry.uid]
                and not shouldAutoSellEgg(entry)
                and (not entry.hasParasite or not isParasiteEventActive()) then
                table.insert(state.queue, {
                    action = "place",
                    uid = entry.uid,
                    tier = entry.tier,
                })
                tried[entry.uid] = true
                state.autoPlaceTriedUids = tried
                return true
            end
        end

        state.autoPlaceTriedUids = tried

        return false
    end

    local function finishAutoPlaceRoundIfDone()
        if not state.autoPlaceBackground then
            return false
        end

        local target = state.autoPlaceTargetCount or getAutoPlaceBatchSize()
        local placed = state.autoPlacePlacedCount or 0

        if placed >= target then
            print(string.format("[EggESP Inv] Auto place round done: placed %d/%d", placed, target))
            finishBackgroundPlace()
            return true
        end

        if state.queueIndex > #state.queue then
            if not tryRefillAutoPlaceQueue() then
                if placed > 0 then
                    print(string.format("[EggESP Inv] Auto place round done: placed %d/%d", placed, target))
                end

                finishBackgroundPlace()
                return true
            end

            state.queueIndex = #state.queue

            local nextItem = state.queue[state.queueIndex]

            if nextItem then
                state.currentAction = nextItem.action
                state.currentUid = nextItem.uid
                setPhase(PHASE.GoToPlot, string.format("tier %d", nextItem.tier))
            end
        end

        return false
    end

    local function beginBackgroundPlace(reason)
        if not hasPlaceableEggs() then
            state.lastAutoPlaceAt = now()
            return false
        end

        local batchSize = getAutoPlaceBatchSize()
        local queue = buildPlaceBatchQueue(batchSize)

        if #queue == 0 then
            state.lastAutoPlaceAt = now()
            return false
        end

        state.active = true
        state.autoPlaceBackground = true
        state.autoPlaceTargetCount = batchSize
        state.autoPlacePlacedCount = 0
        state.autoPlaceTriedUids = {}

        for _, item in ipairs(queue) do
            state.autoPlaceTriedUids[item.uid] = true
        end

        state.feedOnlyMode = false
        state.queue = queue
        state.queueIndex = 1
        state.sellMode = false
        state.sellUids = nil
        state.sellIndex = 1
        state.sellStep = nil
        state.sellStepUid = nil
        state.sellAttempts = 0
        state.sellPass = 0
        state.currentUid = nil
        state.currentAction = nil
        state.wearAttempts = 0
        state.placeAttempts = 0
        state.pendingFeed = false
        state.plotFailStreak = 0
        state.placeRoundSkipped = {}
        state.waitUntil = 0
        state.autoSellBackground = false
        resetGridCursor()

        setPhase(PHASE.GoToPlot, reason or string.format("auto place x%d", #queue))
        applyQueueStart()

        return true
    end

    local function shouldAutoPlaceDue()
        if runtime.autoPlaceEnabled == false then
            return false
        end

        if state.active or state.sellMode then
            return false
        end

        if not hasPlaceableEggs() then
            return false
        end

        local interval = getAutoPlaceInterval()

        return now() - (state.lastAutoPlaceAt or 0) >= interval
    end

    local function canAutoPlaceNow()
        if not shouldAutoPlaceDue() then
            return false
        end

        if runtime.autoPlaceAtStandbyOnly == false then
            return true
        end

        local rootPart = getRootPart()

        if not rootPart then
            return false
        end

        return isNear(rootPart.Position, runtime.standbyPosition, runtime.standbyArriveRadius or 6)
    end

    local function notifyFarmStarted()
        state.lastAutoPlaceAt = now()

        if state.active and state.autoPlaceBackground then
            finishBackgroundPlace()
        end
    end

    local function enterSellMode(reason)
        if state.sellMode then
            return
        end

        state.sellMode = true
        state.sellUids = {}
        state.sellIndex = 1
        state.sellStep = nil
        state.sellStepUid = nil
        state.sellAttempts = 0
        state.autoSellBackground = false
        state.autoDumpWorstBackground = false

        local useSellFilter = runtime.autoSellEnabled == true
        local sellUids

        if shouldUseWorstEggDump() then
            sellUids = buildWorstSellUids()
        else
            sellUids = {}

            for _, entry in ipairs(collectUnplacedEggsForSell(useSellFilter)) do
                table.insert(sellUids, entry.uid)
            end
        end

        for _, uid in ipairs(sellUids) do
            table.insert(state.sellUids, uid)
        end

        state.currentUid = nil
        state.currentAction = nil
        state.placeRoundSkipped = {}
        cancelTween()

        if #state.sellUids == 0 then
            print("[EggESP Inv] Nothing left to sell")
            state.sellMode = false
            if not state.active then
                setPhase(PHASE.Idle, "nothing to sell")
            else
                state.active = false
                setPhase(PHASE.Idle, "all eggs placed")
            end
            return
        end

        setPhase(PHASE.SellEggs, reason or "plot full")
    end

    local function getStatus()
        local total, unplaced = countEggs()

        return {
            active = state.active,
            phase = state.phase,
            detail = state.detail,
            sellMode = state.sellMode,
            autoSellBackground = state.autoSellBackground,
            autoPlaceBackground = state.autoPlaceBackground,
            autoPlaceEnabled = runtime.autoPlaceEnabled ~= false,
            autoPlaceBatchSize = getAutoPlaceBatchSize(),
            autoPlaceInterval = getAutoPlaceInterval(),
            autoPlacePlacedCount = state.autoPlacePlacedCount,
            autoPlaceTargetCount = state.autoPlaceTargetCount,
            autoSellEnabled = runtime.autoSellEnabled == true,
            feedOnlyMode = state.feedOnlyMode,
            parasiteEventActive = isParasiteEventActive(),
            parasiteEggsPending = #collectUnplacedEggs(true),
            queueRemaining = math.max(#state.queue - state.queueIndex + 1, 0),
            eggTotal = total,
            eggUnplaced = unplaced,
            inventoryFull = isInventoryFull(),
        }
    end

    local function applyQueueStart()
        if #state.queue == 0 then
            if state.feedOnlyMode then
                stop()
                return
            end

            local _, unplaced = countEggs()

            if unplaced > 0 and isInventoryFull() then
                enterSellMode("no queue")
            else
                state.active = false
                setPhase(PHASE.Idle, "nothing to do")
            end

            return
        end

        local first = state.queue[state.queueIndex]
        state.currentAction = first.action
        state.currentUid = first.uid

        if first.action == "feed" then
            setPhase(PHASE.GoToMonster, string.format("tier %d", first.tier))
        else
            setPhase(PHASE.GoToPlot, string.format("tier %d", first.tier))
        end
    end

    local function start()
        if state.active then
            return getStatus()
        end

        state.active = true
        state.feedOnlyMode = false
        state.queue = buildQueue()
        state.queueIndex = 1
        state.sellMode = false
        state.sellUids = nil
        state.sellIndex = 1
        state.sellStep = nil
        state.sellStepUid = nil
        state.sellAttempts = 0
        state.sellPass = 0
        state.currentUid = nil
        state.currentAction = nil
        state.wearAttempts = 0
        state.placeAttempts = 0
        state.pendingFeed = false
        state.plotFailStreak = 0
        state.placeRoundSkipped = {}
        state.waitUntil = 0
        resetGridCursor()

        applyQueueStart()

        return getStatus()
    end

    local function startFeedParasite()
        if state.active then
            return getStatus()
        end

        local queue = buildFeedQueue()

        if #queue == 0 then
            setPhase(PHASE.Idle, "no infested eggs")
            return getStatus()
        end

        state.active = true
        state.feedOnlyMode = true
        state.queue = queue
        state.queueIndex = 1
        state.sellMode = false
        state.sellUids = nil
        state.sellIndex = 1
        state.sellStep = nil
        state.sellStepUid = nil
        state.sellAttempts = 0
        state.sellPass = 0
        state.currentUid = nil
        state.currentAction = nil
        state.wearAttempts = 0
        state.placeAttempts = 0
        state.pendingFeed = false
        state.plotFailStreak = 0
        state.placeRoundSkipped = {}
        state.waitUntil = 0
        state.autoSellBackground = false

        applyQueueStart()

        return getStatus()
    end

    local function stop()
        state.active = false
        state.queue = {}
        state.queueIndex = 1
        state.sellUids = nil
        state.sellIndex = 1
        state.sellStep = nil
        state.sellStepUid = nil
        state.sellAttempts = 0
        state.sellPass = 0
        state.currentUid = nil
        state.currentAction = nil
        state.sellMode = false
        state.feedOnlyMode = false
        state.autoPlaceBackground = false
        state.pendingFeed = false
        state.placeRoundSkipped = {}
        setPhase(PHASE.Idle, "stopped")
        cancelTween()

        return getStatus()
    end

    local function finish()
        if state.autoPlaceBackground then
            finishBackgroundPlace()
            return
        end

        local total, unplaced = countEggs()
        print(string.format("[EggESP Inv] Done - total=%d unplaced=%d", total, unplaced))

        if state.feedOnlyMode then
            stop()
            return
        end

        if unplaced > 0 and isInventoryFull() then
            state.sellMode = false
            enterSellMode("finish fallback")
            return
        end

        stop()
    end

    local function advanceQueue()
        state.queueIndex = state.queueIndex + 1
        state.wearAttempts = 0
        state.placeAttempts = 0
        state.pendingFeed = false

        if state.queueIndex <= #state.queue then
            local nextItem = state.queue[state.queueIndex]

            while nextItem and not isEggUnplaced(nextItem.uid) do
                state.queueIndex = state.queueIndex + 1
                nextItem = state.queue[state.queueIndex]
            end
        end

        if state.queueIndex <= #state.queue then
            local nextItem = state.queue[state.queueIndex]
            state.currentAction = nextItem.action
            state.currentUid = nextItem.uid

            if nextItem.action == "feed" then
                setPhase(PHASE.GoToMonster, string.format("tier %d", nextItem.tier))
            else
                setPhase(PHASE.GoToPlot, string.format("tier %d", nextItem.tier))
            end

            return
        end

        if state.autoPlaceBackground then
            if finishAutoPlaceRoundIfDone() then
                return
            end

            if state.queueIndex <= #state.queue then
                local nextItem = state.queue[state.queueIndex]
                state.currentAction = nextItem.action
                state.currentUid = nextItem.uid
                setPhase(PHASE.GoToPlot, string.format("tier %d", nextItem.tier))
            end

            return
        end

        -- Queue exhausted — rebuild from live save (fed/placed eggs drop out)
        local fresh = state.feedOnlyMode and buildFeedQueue() or buildQueue()

        if #fresh > 0 then
            state.queue = fresh
            state.queueIndex = 1
            applyQueueStart()
            return
        end

        if state.feedOnlyMode then
            finish()
            return
        end

        local _, unplaced = countEggs()

        if unplaced > 0 and isInventoryFull() then
            enterSellMode("still full after place")
        else
            finish()
        end
    end

    local function allUnplacedSkipped()
        local unplaced = collectUnplacedEggs(false)

        if #unplaced == 0 then
            return false
        end

        for _, entry in ipairs(unplaced) do
            if not state.placeRoundSkipped[entry.uid] then
                return false
            end
        end

        return true
    end

    local function skipEggPlacement(reason)
        local uid = state.currentUid
        print(string.format("[EggESP Inv] Skip place: %s%s", reason or "unknown", uid and (" (" .. uid:sub(1, 8) .. ")") or ""))

        if uid then
            state.placeRoundSkipped[uid] = true

            if state.autoPlaceTriedUids then
                state.autoPlaceTriedUids[uid] = true
            end
        end

        state.placeAttempts = 0
        state.wearAttempts = 0
        unequipEggTools()

        if state.autoPlaceBackground then
            tryRefillAutoPlaceQueue()
            advanceQueue()
            return
        end

        state.plotFailStreak = state.plotFailStreak + 1

        if allUnplacedSkipped() then
            enterSellMode("cannot place remaining eggs")
            return
        end

        if state.plotFailStreak >= (runtime.inventoryPlotFailStreak or 2) then
            enterSellMode("plot full")
            return
        end

        advanceQueue()
    end

    local function shouldManage()
        if not isInventoryFull() then
            return false
        end

        local _, unplaced = countEggs()

        if unplaced == 0 then
            return false
        end

        if not hasPlotSpace(true) then
            return false
        end

        return true
    end

    local function resetSellStep()
        state.sellStep = nil
        state.sellStepUid = nil
        state.sellAttempts = 0
    end

    local function tickSell()
        if not state.sellUids or state.sellIndex > #state.sellUids then
            if state.autoSellBackground then
                if state.autoDumpWorstBackground then
                    print(string.format("[EggESP Inv] Worst egg dump done (%d sold)", #(state.sellUids or {})))
                end

                finishBackgroundSell()
                return false
            end

            local _, unplaced = countEggs()
            print(string.format("[EggESP Inv] Sell pass done (%d left unplaced)", unplaced))

            if unplaced > 0 and isInventoryFull() then
                state.sellPass = state.sellPass + 1

                if state.sellPass >= 3 then
                    print("[EggESP Inv] Sell gave up after 3 passes")
                    state.sellMode = false
                    stop()
                    return false
                end

                state.sellUids = {}
                state.sellIndex = 1
                resetSellStep()

                if shouldUseWorstEggDump() then
                    state.sellUids = buildWorstSellUids()
                else
                    local useSellFilter = runtime.autoSellEnabled == true

                    for _, entry in ipairs(collectUnplacedEggsForSell(useSellFilter)) do
                        table.insert(state.sellUids, entry.uid)
                    end
                end

                if #state.sellUids > 0 then
                    setPhase(PHASE.SellEggs, string.format("retry pass %d", state.sellPass + 1))
                    return true
                end
            end

            finish()
            return false
        end

        if waiting() then
            return true
        end

        local uid = state.sellUids[state.sellIndex]

        if not isEggUnplaced(uid) then
            resetSellStep()
            state.sellIndex = state.sellIndex + 1
            return true
        end

        if state.sellStepUid ~= uid then
            resetSellStep()
            state.sellStepUid = uid
            state.sellStep = "equip"
        end

        if state.sellStep == "equip" then
            setPhase(PHASE.SellEggs, string.format("equip %s", uid:sub(1, 8)))

            if isEggEquipped(uid) then
                state.sellStep = "sell"
                return true
            end

            unequipEggTools()
            local ok = EggState.WearEggTool(uid)
            state.sellAttempts = state.sellAttempts + 1

            if ok ~= true then
                if state.sellAttempts >= 10 then
                    print(string.format("[EggESP Inv] Cannot equip to sell: %s", uid:sub(1, 8)))
                    resetSellStep()
                    state.sellIndex = state.sellIndex + 1
                else
                    pause(0.25)
                end

                return true
            end

            pause(0.3)
            return true
        end

        if state.sellStep == "sell" then
            if not isEggEquipped(uid) then
                state.sellStep = "equip"
                return true
            end

            setPhase(PHASE.SellEggs, string.format("sell %s", uid:sub(1, 8)))
            Remotes.PetSatchel.SellPet:FireServer({ uid })
            state.sellStep = "wait"
            state.sellAttempts = 0
            pause(0.35)
            return true
        end

        if state.sellStep == "wait" then
            if not isEggUnplaced(uid) then
                print(string.format("[EggESP Inv] Sold egg %s", uid:sub(1, 8)))
                unequipEggTools()
                resetSellStep()
                state.sellIndex = state.sellIndex + 1
                return true
            end

            state.sellAttempts = state.sellAttempts + 1

            if state.sellAttempts >= 6 then
                print(string.format("[EggESP Inv] Sell failed for %s, skipping", uid:sub(1, 8)))
                unequipEggTools()
                resetSellStep()
                state.sellIndex = state.sellIndex + 1
                return true
            end

            if isEggEquipped(uid) then
                Remotes.PetSatchel.SellPet:FireServer({ uid })
            else
                state.sellStep = "equip"
            end

            pause(0.3)
            return true
        end

        state.sellStep = "equip"
        return true
    end

    local function tickFeed(item)
        local monsterPos = findMonsterPosition()

        if not monsterPos then
            advanceQueue()
            return true
        end

        local rootPart = getRootPart()

        if not rootPart then
            return true
        end

        local arriveRadius = runtime.inventoryFeedRadius or 12

        if not isNear(rootPart.Position, monsterPos, arriveRadius) then
            setPhase(PHASE.GoToMonster, string.format("tier %d", item.tier))
            tweenTo(monsterPos)
            return true
        end

        setPhase(PHASE.FeedParasite, string.format("tier %d", item.tier))

        if not isEggEquipped(item.uid) then
            if state.wearAttempts >= 12 then
                advanceQueue()
                return true
            end

            setPhase(PHASE.WaitEquip, string.format("tier %d", item.tier))

            if not prepareWear(item.uid) then
                return true
            end
        end

        if state.pendingFeed then
            return true
        end

        state.pendingFeed = true

        local success, result = pcall(function()
            return Remotes.MonsterParasite.AskFeed:InvokeServer()
        end)

        unequipEggTools()
        state.pendingFeed = false

        if success and typeof(result) == "table" and result.Success == true then
            print("[EggESP Inv] Fed parasite egg to monster")
            pause(1.5)
        else
            print("[EggESP Inv] Feed failed, skipping egg")
            pause(0.3)
        end

        advanceQueue()
        return true
    end

    local function tickPlace(item)
        if not isEggUnplaced(item.uid) then
            advanceQueue()
            return true
        end

        local plotPos = getPlotStandPosition()
        local rootPart = getRootPart()

        if not rootPart then
            return true
        end

        local arriveRadius = runtime.standbyArriveRadius or 6

        if not isNear(rootPart.Position, plotPos, arriveRadius) then
            setPhase(PHASE.GoToPlot, string.format("tier %d", item.tier))
            tweenTo(plotPos)
            return true
        end

        setPhase(PHASE.PlaceEgg, string.format("tier %d", item.tier))

        if not isEggEquipped(item.uid) then
            if state.wearAttempts >= 12 then
                skipEggPlacement("cannot equip")
                return true
            end

            setPhase(PHASE.WaitEquip, string.format("tier %d", item.tier))

            if not prepareWear(item.uid) then
                return true
            end
        end

        if not isEggUnplaced(item.uid) then
            advanceQueue()
            return true
        end

        setPhase(PHASE.PlaceEgg, string.format("tier %d", item.tier))

        local attemptsThisTick = runtime.inventoryPlaceAttemptsPerTick or 6
        local tried = 0
        local gridExhausted = false

        while tried < attemptsThisTick do
            tried = tried + 1
            state.placeAttempts = state.placeAttempts + 1

            local localCFrame = nextPlacementCFrame()

            if not localCFrame then
                gridExhausted = true
                break
            end

            local ok, err = EggState.PlantEgg(item.uid, localCFrame)

            if ok == true then
                state.plotFailStreak = 0
                state.placeRoundSkipped[item.uid] = nil
                unequipEggTools()
                print(string.format("[EggESP Inv] Placed egg tier %d (%s)", item.tier, item.uid))
                state.plotSpaceCache = nil

                if state.autoPlaceBackground then
                    state.autoPlacePlacedCount = (state.autoPlacePlacedCount or 0) + 1
                end

                pause(0.4)
                advanceQueue()
                return true
            end

            if err then
                state.detail = tostring(err)
            end
        end

        if gridExhausted and state.autoPlaceBackground then
            skipEggPlacement("plot full")
            return true
        end

        if gridExhausted then
            enterSellMode("plot full")
            return true
        end

        local maxAttempts = runtime.inventoryMaxPlaceAttemptsPerEgg or 12

        if state.placeAttempts >= maxAttempts then
            skipEggPlacement("placement failed")
            return true
        end

        pause(0.1)
        return true
    end

    local function tick()
        if not state.active then
            return false
        end

        if waiting() then
            return true
        end

        if state.sellMode then
            return tickSell()
        end

        if state.queueIndex > #state.queue then
            if state.autoPlaceBackground then
                if finishAutoPlaceRoundIfDone() then
                    return state.active
                end

                return state.active
            end

            local fresh = buildQueue()

            if #fresh > 0 then
                state.queue = fresh
                state.queueIndex = 1
                applyQueueStart()
                return state.active
            end

            local _, unplaced = countEggs()

            if unplaced > 0 and isInventoryFull() then
                enterSellMode("still full")
            else
                finish()
            end

            return state.active
        end

        local item = state.queue[state.queueIndex]

        while item and item.action == "place" and not isEggUnplaced(item.uid) do
            state.queueIndex = state.queueIndex + 1
            item = state.queue[state.queueIndex]
        end

        if not item or state.queueIndex > #state.queue then
            if state.autoPlaceBackground then
                if finishAutoPlaceRoundIfDone() then
                    return state.active
                end

                return state.active
            end

            local fresh = buildQueue()

            if #fresh > 0 then
                state.queue = fresh
                state.queueIndex = 1
                applyQueueStart()
                return state.active
            end

            local _, unplaced = countEggs()

            if unplaced > 0 and isInventoryFull() then
                enterSellMode("still full")
            else
                finish()
            end

            return state.active
        end

        state.currentUid = item.uid
        state.currentAction = item.action

        if item.action == "feed" then
            tickFeed(item)
        else
            tickPlace(item)
        end

        return state.active
    end

    local function tickAutoSell()
        if runtime.autoSellEnabled ~= true then
            return false
        end

        if state.active then
            return false
        end

        if state.sellMode then
            if state.autoSellBackground then
                return tickSell()
            end

            return false
        end

        if waiting() then
            return false
        end

        local interval = runtime.autoSellInterval or 1.5

        if now() - (state.lastAutoSellAt or 0) < interval then
            return false
        end

        return beginBackgroundSell("auto sell")
    end

    local function tickAutoDumpWorstEggs()
        if runtime.autoDumpWorstEggsEnabled == false then
            return false
        end

        if state.sellMode then
            if state.autoDumpWorstBackground then
                return tickSell()
            end

            return false
        end

        if state.active and not state.autoPlaceBackground then
            return false
        end

        if not shouldDumpWorstEggs() then
            return false
        end

        local cooldown = runtime.autoDumpWorstEggCooldown or 15

        if now() - (state.lastAutoDumpWorstAt or 0) < cooldown then
            return false
        end

        return beginWorstEggDumpSell(string.format("dump worst x%d", runtime.autoDumpWorstEggCount or 10))
    end

    local function tickAutoPlace()
        if runtime.autoPlaceEnabled == false then
            return false
        end

        if AutoFarm and AutoFarm.GetStatus then
            local farmStatus = AutoFarm.GetStatus()

            if farmStatus.enabled then
                return false
            end
        end

        if state.active then
            if state.autoPlaceBackground then
                return tick()
            end

            return false
        end

        if state.sellMode then
            return false
        end

        if waiting() then
            return false
        end

        local interval = getAutoPlaceInterval()

        if now() - (state.lastAutoPlaceAt or 0) < interval then
            return false
        end

        if not canAutoPlaceNow() then
            return false
        end

        return beginBackgroundPlace(string.format("auto place x%d", getAutoPlaceBatchSize()))
    end

    local function setAutoFarm(autoFarm)
        AutoFarm = autoFarm
    end

    return {
        Start = start,
        StartFeedParasite = startFeedParasite,
        Stop = stop,
        Tick = tick,
        TickAutoSell = tickAutoSell,
        TickAutoDumpWorstEggs = tickAutoDumpWorstEggs,
        TickAutoPlace = tickAutoPlace,
        ShouldDumpWorstEggs = shouldDumpWorstEggs,
        BeginWorstEggDumpSell = beginWorstEggDumpSell,
        ShouldAutoPlaceDue = shouldAutoPlaceDue,
        StartBackgroundPlace = beginBackgroundPlace,
        NotifyFarmStarted = notifyFarmStarted,
        SetAutoFarm = setAutoFarm,
        GetStatus = getStatus,
        ShouldManage = shouldManage,
        ShouldFeedParasite = shouldFeedParasite,
        IsActive = isActive,
        IsInventoryFull = isInventoryFull,
        Phases = PHASE,
    }
end

return InventoryManager

end)()

local PetAutomationModule = (function()
--[[
    Auto hatch ready eggs, fuse duplicate pets (3+ same category), equip best.
]]

local PetAutomation = {}

function PetAutomation.create(deps)
    local Config = deps.Config
    local Save = deps.Save
    local Eggs = deps.Eggs
    local EggState = deps.EggState
    local Remotes = deps.Remotes
    local PlacedEggRenderer = deps.PlacedEggRenderer
    local LocalPlayer = deps.LocalPlayer
    local Workspace = deps.Workspace
    local FuseKernel = require(deps.ReplicatedStorage.Shared.Util.FuseKernel)

    local runtime = Config.Runtime

    local state = {
        lastWearBestAt = 0,
        pendingWearBest = false,
        lastActionAt = 0,
        detail = nil,
        lastHatchUid = nil,
        hatchCooldownUntil = 0,
    }

    local function getSave()
        return Save.Get()
    end

    local function isEnabled()
        if runtime.autoPetCareEnabled == false then
            return false
        end

        return runtime.autoHatchEnabled ~= false
            or runtime.autoFuseEnabled ~= false
            or runtime.autoEquipBest ~= false
    end

    local function setDetail(detail)
        if state.detail ~= detail then
            state.detail = detail

            if detail then
                print(string.format("[EggESP Pet] %s", detail))
            end
        end
    end

    local function now()
        return Workspace:GetServerTimeNow()
    end

    local function canWearBest()
        local cooldown = runtime.equipBestCooldown or 5

        return now() - state.lastWearBestAt >= cooldown
    end

    local function requestWearBest(force)
        if runtime.autoEquipBest == false then
            return false
        end

        if not force and not canWearBest() then
            state.pendingWearBest = true
            return false
        end

        local ok, result = pcall(function()
            return Remotes.Haul.WearBest:InvokeServer()
        end)

        state.lastWearBestAt = now()

        if ok and typeof(result) == "table" and result[1] == true then
            state.pendingWearBest = false
            setDetail("equipped best pets")
            return true
        end

        state.pendingWearBest = true
        return false
    end

    local function flushWearBest()
        if state.pendingWearBest and canWearBest() then
            requestWearBest(true)
        end
    end

    local function isUidInFusionSlots(saveData, uid)
        for _, slotUid in ipairs(saveData.FusionSlots or {}) do
            if slotUid == uid then
                return true
            end
        end

        return false
    end

    local function isEquipped(saveData, uid)
        for _, equippedUid in ipairs(saveData.EquippedAssets or {}) do
            if equippedUid == uid then
                return true
            end
        end

        return false
    end

    local function collectFusableByCategory(saveData)
        local groups = {}

        for uid, item in pairs(saveData.Inventory or {}) do
            if not isUidInFusionSlots(saveData, uid) and not isEquipped(saveData, uid) then
                local allowed = FuseKernel.MayEnterFuse(uid, item, nil, false)

                if allowed then
                    local category = item.Category
                    local bucket = groups[category]

                    if not bucket then
                        bucket = {}
                        groups[category] = bucket
                    end

                    table.insert(bucket, uid)
                end
            end
        end

        return groups
    end

    local function getFusionSlotCategory(saveData)
        for _, uid in ipairs(saveData.FusionSlots or {}) do
            if uid then
                local item = saveData.Inventory[uid]

                if item then
                    return item.Category, uid
                end
            end
        end

        return nil
    end

    local function countFilledFusionSlots(saveData)
        local count = 0

        for _, uid in ipairs(saveData.FusionSlots or {}) do
            if uid then
                count = count + 1
            end
        end

        return count
    end

    local function ensureFusionBriefing()
        local saveData = getSave()

        if not saveData or saveData.FusionInfoAcknowledged then
            return true
        end

        local ok, result = pcall(function()
            return Remotes.Fusery.ConfirmBriefing:InvokeServer()
        end)

        return ok and result == true
    end

    local function tryFinishFuseReveal(saveData)
        if saveData.FusionEggReward == false then
            return false
        end

        setDetail("finishing fuse reveal")

        local ok, success = pcall(function()
            return Remotes.Fusery.FinishReveal:InvokeServer()
        end)

        if ok and success == true then
            state.pendingWearBest = true
            setDetail("fuse complete")
            return true
        end

        return false
    end

    local function tryLoadFusionPet(uid)
        local ok, success, err = pcall(function()
            return Remotes.Fusery.LoadPet:InvokeServer(uid)
        end)

        if not ok then
            return false, tostring(success)
        end

        if success == true then
            return true
        end

        return false, typeof(err) == "string" and err or "load failed"
    end

    local function tryBeginFuse(saveData)
        if countFilledFusionSlots(saveData) < 3 then
            return false
        end

        if saveData.FusionLocked or saveData.FusionEggReward ~= false then
            return false
        end

        local eggCount = 0

        for _ in pairs(saveData.EggInventory or {}) do
            eggCount = eggCount + 1
        end

        if eggCount >= Eggs.MAX_INVENTORY then
            setDetail("fuse blocked - egg bag full")
            return false
        end

        if not ensureFusionBriefing() then
            return false
        end

        setDetail("starting fuse")

        local ok, success, err = pcall(function()
            return Remotes.Fusery.BeginFuse:InvokeServer()
        end)

        if not ok then
            return false
        end

        if success ~= true then
            local message = typeof(err) == "string" and err or "begin fuse failed"
            setDetail(message)
            return false
        end

        setDetail("fuse started")
        return true
    end

    local function tryContinueFusion(saveData)
        if saveData.FusionLocked then
            return tryFinishFuseReveal(saveData)
        end

        if saveData.FusionEggReward ~= false then
            return tryFinishFuseReveal(saveData)
        end

        local filled = countFilledFusionSlots(saveData)

        if filled >= 3 then
            return tryBeginFuse(saveData)
        end

        if filled == 0 then
            return false
        end

        local requiredCategory = getFusionSlotCategory(saveData)

        if not requiredCategory then
            return false
        end

        local groups = collectFusableByCategory(saveData)
        local candidates = groups[requiredCategory]

        if not candidates or #candidates == 0 then
            return false
        end

        for _, uid in ipairs(candidates) do
            if countFilledFusionSlots(getSave() or saveData) >= 3 then
                break
            end

            local loaded = tryLoadFusionPet(uid)

            if loaded then
                setDetail(string.format("loaded fuse pet %s", uid:sub(1, 8)))
                return true
            end
        end

        return false
    end

    local function tryStartNewFusion(saveData)
        if runtime.autoFuseEnabled == false then
            return false
        end

        if saveData.FusionLocked or saveData.FusionEggReward ~= false then
            return false
        end

        if countFilledFusionSlots(saveData) > 0 then
            return false
        end

        local minCount = runtime.autoFuseMinCount or 3
        local groups = collectFusableByCategory(saveData)
        local bestCategory
        local bestUids

        for category, uids in pairs(groups) do
            if #uids >= minCount then
                if not bestUids or #uids > #bestUids then
                    bestCategory = category
                    bestUids = uids
                end
            end
        end

        if not bestUids then
            return false
        end

        local loaded = 0

        for index = 1, math.min(3, #bestUids) do
            if tryLoadFusionPet(bestUids[index]) then
                loaded = loaded + 1
            end
        end

        if loaded > 0 then
            setDetail(string.format("loading %s for fuse (%d/3)", bestCategory, loaded))
            return true
        end

        return false
    end

    local function collectReadyEggUids()
        local ready = {}
        local eggs = EggState.ReadOwnerEggs(LocalPlayer.UserId)

        for uid, record in pairs(eggs) do
            if record.Placement ~= nil and EggState.IsReadyToHatch(uid) then
                table.insert(ready, uid)
            end
        end

        table.sort(ready)
        return ready
    end

    local function hatchEgg(uid)
        if now() < state.hatchCooldownUntil then
            return false
        end

        setDetail(string.format("hatching %s", uid:sub(1, 8)))

        local activated, activateErr = PlacedEggRenderer.ActivateLocalEgg(uid)

        if activated == true then
            state.lastHatchUid = uid
            state.hatchCooldownUntil = now() + 2
            state.pendingWearBest = true
            return true
        end

        local began, beginErr = EggState.BeginHatch(uid)

        if began ~= true then
            setDetail(typeof(beginErr) == "string" and beginErr or "hatch begin failed")
            return false
        end

        local finished, finishErr = EggState.FinishHatch(uid)

        if finished == true then
            state.lastHatchUid = uid
            state.hatchCooldownUntil = now() + 1.5
            state.pendingWearBest = true
            setDetail("hatched egg")
            return true
        end

        setDetail(typeof(finishErr) == "string" and finishErr or "hatch finish failed")
        return false
    end

    local function tryHatchReadyEggs()
        if runtime.autoHatchEnabled == false then
            return false
        end

        local ready = collectReadyEggUids()

        for _, uid in ipairs(ready) do
            if uid ~= state.lastHatchUid or #ready == 1 then
                if hatchEgg(uid) then
                    return true
                end
            end
        end

        if #ready > 0 and ready[1] then
            return hatchEgg(ready[1])
        end

        return false
    end

    local function tick()
        if not isEnabled() then
            return false
        end

        local saveData = getSave()

        if not saveData then
            return false
        end

        if tryFinishFuseReveal(saveData) then
            flushWearBest()
            return true
        end

        if tryContinueFusion(saveData) then
            return true
        end

        if tryStartNewFusion(saveData) then
            return true
        end

        if tryHatchReadyEggs() then
            flushWearBest()
            return true
        end

        flushWearBest()
        return false
    end

    local function getStatus()
        local saveData = getSave()
        local readyCount = #collectReadyEggUids()
        local fuseGroups = saveData and collectFusableByCategory(saveData) or {}
        local fuseReady = 0

        for _, uids in pairs(fuseGroups) do
            if #uids >= (runtime.autoFuseMinCount or 3) then
                fuseReady = fuseReady + 1
            end
        end

        return {
            enabled = isEnabled(),
            detail = state.detail,
            readyEggs = readyCount,
            fuseableGroups = fuseReady,
            pendingWearBest = state.pendingWearBest,
            fusionLocked = saveData and saveData.FusionLocked or false,
            fusionSlots = saveData and countFilledFusionSlots(saveData) or 0,
        }
    end

    return {
        Tick = tick,
        GetStatus = getStatus,
        RequestWearBest = requestWearBest,
    }
end

return PetAutomation

end)()

local BasePenAutomationModule = (function()
--[[
    Auto upgrade base pen + auto collect money while in / near the pet area.
]]

local BasePenAutomation = {}

function BasePenAutomation.create(deps)
    local Config = deps.Config
    local Save = deps.Save
    local Remotes = deps.Remotes
    local AssetRoster = deps.AssetRoster
    local PlotState = deps.PlotState
    local LocalPlayer = deps.LocalPlayer
    local Movement = deps.Movement
    local AutoFarm = deps.AutoFarm
    local ReplicatedStorage = deps.ReplicatedStorage

    local runtime = Config.Runtime

    local BaseUpgrade = require(ReplicatedStorage.Client.BaseUpgrade)
    local BaseUpgradeTransitionLifecycle = require(ReplicatedStorage.Client.BaseUpgradeTransitionLifecycle)
    local OfflineAssets = require(ReplicatedStorage.Client.Types.OfflineAssets)
    local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
    local Player = require(ReplicatedStorage.Shared.Player)

    local MIN_CLAIM_MONEY = Constants.OFFLINE_ASSETS.MIN_CLAIM_MONEY

    local state = {
        detail = nil,
        lastUpgradeCheck = 0,
        lastCollectCheck = 0,
        lastClaimAttempt = 0,
        visitingPen = false,
    }

    local function setDetail(detail)
        if state.detail ~= detail then
            state.detail = detail

            if detail then
                print(string.format("[EggESP Pen] %s", detail))
            end
        end
    end

    local function getSave()
        if not Save.IsLocalDataLoaded() then
            return nil
        end

        return Save.Get()
    end

    local function getRootPart()
        if Movement and Movement.GetRootPart then
            return Movement.GetRootPart()
        end

        local character = LocalPlayer.Character

        return character and character:FindFirstChild("HumanoidRootPart")
    end

    local function getFeetPosition()
        local feet = Player.Optional.FeetCFrame(LocalPlayer)

        if feet then
            return feet.Position
        end

        local rootPart = getRootPart()

        return rootPart and rootPart.Position
    end

    local function getPetArea()
        return AssetRoster.FindPenArea(LocalPlayer)
    end

    local function getPenCenter(petArea)
        return petArea.Position + Vector3.new(0, 2, 0)
    end

    local function isInsidePetAreaXZ(position, petArea)
        if not position or not petArea then
            return false
        end

        local localPos = petArea.CFrame:PointToObjectSpace(position)
        local scale = runtime.penAreaClaimScale or 0.74
        local halfX = petArea.Size.X * scale * 0.5
        local halfZ = petArea.Size.Z * scale * 0.5

        return math.abs(localPos.X) <= halfX and math.abs(localPos.Z) <= halfZ
    end

    local function isNearStandby(position)
        if not position then
            return false
        end

        local standby = runtime.standbyPosition
        local radius = runtime.standbyArriveRadius or 6

        return (Vector3.new(position.X, 0, position.Z) - Vector3.new(standby.X, 0, standby.Z)).Magnitude <= radius
    end

    local function autoFarmBlocksPenVisit()
        if not AutoFarm or not AutoFarm.GetStatus then
            return false
        end

        local status = AutoFarm.GetStatus()

        if status.isCarrying then
            return true
        end

        local phase = status.phase

        if phase == "GoToEgg" or phase == "ReturnStandby" or phase == "Pickup" then
            return true
        end

        if status.inventory and status.inventory.active then
            return true
        end

        return false
    end

    local function canVisitPen()
        if autoFarmBlocksPenVisit() then
            return false
        end

        if Movement and Movement.IsTweening and Movement.IsTweening() then
            return state.visitingPen
        end

        return true
    end

    local function readOfflineSummary()
        local ok, summary = pcall(function()
            return Remotes.AwayEarnings.FetchSummary:InvokeServer()
        end)

        if not ok or not OfflineAssets.OfflineClaimSummary(summary) then
            return nil
        end

        return summary
    end

    local function tryClaimOfflineMoney()
        local now = os.clock()
        local cooldown = runtime.penCollectClaimCooldown or 3

        if now - state.lastClaimAttempt < cooldown then
            return false
        end

        local summary = readOfflineSummary()

        if not summary then
            return false
        end

        local amount = math.max(summary.TotalAmount or 0, 0)

        if amount < MIN_CLAIM_MONEY then
            return false
        end

        local feetPos = getFeetPosition()
        local petArea = getPetArea()

        if not feetPos or not petArea or not isInsidePetAreaXZ(feetPos, petArea) then
            return false
        end

        state.lastClaimAttempt = now

        local ok, success, _, result = pcall(function()
            return Remotes.AwayEarnings.AskCollect:InvokeServer({
                Kind = "Claim",
            })
        end)

        if ok and success == true and OfflineAssets.OfflineRedeemResult(result) then
            setDetail(string.format("claimed offline $%s", tostring(math.floor(result.AwardedAmount or 0))))
            return true
        end

        setDetail("offline claim failed")
        return false
    end

    local function ensureInsidePenForCollect()
        local petArea = getPetArea()

        if not petArea then
            return false
        end

        local feetPos = getFeetPosition()

        if feetPos and isInsidePetAreaXZ(feetPos, petArea) then
            return true
        end

        if runtime.penCollectVisitPen ~= true or not canVisitPen() then
            return false
        end

        if runtime.penCollectAtStandbyOnly == true and not isNearStandby(feetPos) then
            return false
        end

        local rootPart = getRootPart()

        if not rootPart or not Movement or not Movement.TweenTo then
            return false
        end

        local target = getPenCenter(petArea)

        if Movement.IsNear and Movement.IsNear(rootPart.Position, target, runtime.penCollectArriveRadius or 8) then
            return isInsidePetAreaXZ(getFeetPosition(), petArea)
        end

        if not Movement.IsTweeningTo or not Movement.IsTweeningTo(target) then
            state.visitingPen = true
            Movement.TweenTo(target, runtime.tweenSpeed, function(completed)
                state.visitingPen = false

                if completed then
                    tryClaimOfflineMoney()
                end
            end)
        end

        return false
    end

    local function tryCollectMoney()
        if runtime.autoCollectPenMoney ~= true then
            return false
        end

        if not getSave() then
            return false
        end

        local feetPos = getFeetPosition()
        local petArea = getPetArea()

        if not petArea then
            return false
        end

        if runtime.penCollectAtStandbyOnly == true and not isNearStandby(feetPos) then
            return false
        end

        if isInsidePetAreaXZ(feetPos, petArea) then
            return tryClaimOfflineMoney()
        end

        ensureInsidePenForCollect()
        return false
    end

    local function tryUpgradeBase()
        if runtime.autoUpgradeBasePen ~= true then
            return false
        end

        if runtime.penUpgradeAtStandbyOnly == true then
            local feetPos = getFeetPosition()

            if not isNearStandby(feetPos) then
                return false
            end
        end

        local saveData = getSave()

        if not saveData then
            return false
        end

        if BaseUpgradeTransitionLifecycle.IsPlaying() then
            return false
        end

        if not BaseUpgrade.IsNextTierAffordable(saveData) then
            return false
        end

        local nextTier, nextConfig = BaseUpgrade.ResolveNextTier(saveData)

        if not nextTier or not nextConfig then
            return false
        end

        local ok, started = pcall(BaseUpgrade.PurchaseNextTier)

        if ok and started then
            setDetail(string.format("upgrading base to tier %s", tostring(nextTier)))
            return true
        end

        return false
    end

    local function tick()
        local now = os.clock()
        local didWork = false

        local upgradeInterval = runtime.penUpgradeCheckInterval or 10

        if now - state.lastUpgradeCheck >= upgradeInterval then
            state.lastUpgradeCheck = now

            if tryUpgradeBase() then
                didWork = true
            end
        end

        local collectInterval = runtime.penCollectInterval or 20

        if now - state.lastCollectCheck >= collectInterval then
            state.lastCollectCheck = now

            if tryCollectMoney() then
                didWork = true
            end
        end

        return didWork
    end

    local function getStatus()
        local saveData = getSave()
        local summary = nil
        local claimable = 0
        local affordable = false
        local nextTier = nil
        local petArea = getPetArea()
        local feetPos = getFeetPosition()

        if saveData then
            affordable = BaseUpgrade.IsNextTierAffordable(saveData)
            nextTier = select(1, BaseUpgrade.ResolveNextTier(saveData))
        end

        local ok, fetched = pcall(readOfflineSummary)

        if ok and fetched then
            summary = fetched
            claimable = math.max(fetched.TotalAmount or 0, 0)
        end

        return {
            enabled = runtime.autoUpgradeBasePen == true or runtime.autoCollectPenMoney == true,
            autoUpgrade = runtime.autoUpgradeBasePen == true,
            autoCollect = runtime.autoCollectPenMoney == true,
            detail = state.detail,
            claimableOffline = claimable,
            canUpgrade = affordable,
            nextTier = nextTier,
            baseLevel = saveData and saveData.BaseUpgradeLevel or nil,
            inPenArea = petArea ~= nil and isInsidePetAreaXZ(feetPos, petArea) or false,
            visitingPen = state.visitingPen,
        }
    end

    return {
        Tick = tick,
        GetStatus = getStatus,
        TryUpgrade = tryUpgradeBase,
        TryCollect = tryCollectMoney,
    }
end

return BasePenAutomation

end)()

local DayCycleModule = (function()
--[[
    Day/night egg reset cycle — block field farming during night reset.
]]

local DayCycle = {}

function DayCycle.create(deps)
    local Workspace = deps.Workspace
    local AreaEggCycle = deps.AreaEggCycle
    local AreaEggResetCycle = deps.AreaEggResetCycle
    local AreaEggResetWall = deps.AreaEggResetWall

    local function serverTime()
        return Workspace:GetServerTimeNow()
    end

    local function getPhase()
        if Workspace:GetAttribute("Event_AdminAbuse") == true then
            return "Day"
        end

        local now = serverTime()

        if AreaEggCycle.IsNightPhase(now) then
            return "Night"
        end

        if AreaEggCycle.IsWithinNightTransition(
            now,
            AreaEggResetCycle.NightLightingTransitionSeconds,
            AreaEggResetCycle.NightLightingStartDelaySeconds
        ) then
            return "NightTransition"
        end

        return "Day"
    end

    local function isEggAreaBlocked()
        if AreaEggResetWall.IsSealed() then
            return true, "wall sealed"
        end

        local phase = getPhase()

        if phase == "Night" then
            return true, "night reset"
        end

        if phase == "NightTransition" then
            return true, "night approaching"
        end

        return false, nil
    end

    local function secondsUntilDay()
        local now = serverTime()

        if not AreaEggCycle.IsNightPhase(now) then
            return 0
        end

        return math.ceil(AreaEggCycle.SecondsUntilReset(now))
    end

    local function getStatus()
        local blocked, reason = isEggAreaBlocked()
        local phase = getPhase()
        local untilDay = secondsUntilDay()

        return {
            phase = phase,
            blocked = blocked,
            reason = reason,
            secondsUntilDay = untilDay,
        }
    end

    return {
        GetPhase = getPhase,
        IsEggAreaBlocked = isEggAreaBlocked,
        SecondsUntilDay = secondsUntilDay,
        GetStatus = getStatus,
    }
end

return DayCycle

end)()

local PassthroughModule = (function()
--[[
    Disable collision on configured world objects so auto farm can walk through them.
]]

local Passthrough = {}

function Passthrough.create(deps)
    local Workspace = deps.Workspace

    local ROOT_PATHS = {
        "Stands.Models.GearShopStand",
        "__OBJECTS.Machines.FuseMachine.Model.Base",
    }

    local saved = {}
    local active = false

    local function resolvePath(path)
        local current = Workspace

        for segment in string.gmatch(path, "[^%.]+") do
            current = current and current:FindFirstChild(segment)

            if not current then
                return nil
            end
        end

        return current
    end

    local function rememberPart(part)
        if saved[part] then
            return
        end

        saved[part] = {
            CanCollide = part.CanCollide,
            CanTouch = part.CanTouch,
            CanQuery = part.CanQuery,
        }
    end

    local function disablePart(part)
        rememberPart(part)
        part.CanCollide = false
        part.CanTouch = false
        part.CanQuery = false
    end

    local function applyToInstance(instance)
        if instance:IsA("BasePart") then
            disablePart(instance)
        end

        for _, descendant in ipairs(instance:GetDescendants()) do
            if descendant:IsA("BasePart") then
                disablePart(descendant)
            end
        end
    end

    local function restorePart(part, props)
        if part.Parent and props then
            part.CanCollide = props.CanCollide
            part.CanTouch = props.CanTouch
            part.CanQuery = props.CanQuery
        end
    end

    local function enable()
        if active then
            return
        end

        active = true

        for _, path in ipairs(ROOT_PATHS) do
            local instance = resolvePath(path)

            if instance then
                applyToInstance(instance)
            else
                warn("[NMHUB] Passthrough target not found: " .. path)
            end
        end
    end

    local function disable()
        if not active then
            return
        end

        for part, props in pairs(saved) do
            restorePart(part, props)
        end

        table.clear(saved)
        active = false
    end

    return {
        Enable = enable,
        Disable = disable,
        IsActive = function()
            return active
        end,
    }
end

return Passthrough

end)()

local SpeedBypassModule = (function()
--[[
    WalkSpeed bypass + anti-lagback (ObbyAntiTP).
    Destroying the LocalScript is not enough — its Heartbeat connection keeps running.
]]

local SpeedBypass = {}

function SpeedBypass.create(deps)
    local Config = deps.Config
    local RunService = deps.RunService
    local Workspace = deps.Workspace
    local LocalPlayer = deps.LocalPlayer
    local ReplicatedStorage = deps.ReplicatedStorage
    local Movement = deps.Movement

    local runtime = Config.Runtime

    local heartbeatConnection = nil
    local characterConnection = nil
    local attributeConnection = nil
    local childConnection = nil
    local maintenanceThread = nil
    local walkSpeedConnection = nil
    local active = false
    local serverActionMode = false
    local hookedFunctions = {}
    local disabledConnections = {}
    local metaHookInstalled = false
    local oldNamecall = nil
    local remotesModule = nil

    local NEUTER_NAMES = {
        check = true,
        lagback = true,
        punish = true,
        kill = true,
    }

    local ANTI_TP_MARKERS = {
        "ObbyAntiTP",
        "ObbyAntiTp",
    }

    local function getCharacter()
        return LocalPlayer.Character
    end

    local function getRootPart()
        local character = getCharacter()
        return character and character:FindFirstChild("HumanoidRootPart")
    end

    local function getHumanoid()
        local character = getCharacter()
        return character and character:FindFirstChildOfClass("Humanoid")
    end

    local function sourceMatchesAntiTp(source)
        if type(source) ~= "string" then
            return false
        end

        for _, marker in ipairs(ANTI_TP_MARKERS) do
            if source:find(marker, 1, true) then
                return true
            end
        end

        return false
    end

    local function destroyAntiTpScripts(root)
        if not root then
            return
        end

        for _, instance in ipairs(root:GetDescendants()) do
            if instance.Name == "ObbyAntiTPClient" and instance:IsA("LocalScript") then
                instance.Disabled = true
                instance:Destroy()
            end
        end
    end

    local function forceAntiTpOff()
        pcall(function()
            Workspace:SetAttribute("ClientObbyAntiTp", false)
        end)
    end

    local function shouldBlockLagbackPivot(targetInstance)
        if not active then
            return false
        end

        local character = getCharacter()

        if not character or not targetInstance then
            return false
        end

        if targetInstance ~= character then
            local rootPart = getRootPart()
            if targetInstance ~= rootPart then
                return false
            end
        end

        if serverActionMode then
            return false
        end

        if Movement and Movement.IsServerActionMode and Movement.IsServerActionMode() then
            return false
        end

        if Movement and Movement.IsTweening and Movement.IsTweening() then
            return true
        end

        if Movement and Movement.IsTweenMode and Movement.IsTweenMode() then
            return true
        end

        if Movement and Movement.IsBypassPrepared and Movement.IsBypassPrepared() then
            return true
        end

        return runtime.speedBypassBlockPivotAlways == true
    end

    local function installNamecallHook()
        if metaHookInstalled or typeof(getrawmetatable) ~= "function" then
            return
        end

        local ok, mt = pcall(getrawmetatable, game)

        if not ok or not mt or typeof(mt.__namecall) ~= "function" then
            return
        end

        oldNamecall = mt.__namecall

        pcall(function()
            setreadonly(mt, false)
        end)

        mt.__namecall = function(self, ...)
            local method = getnamecallmethod()

            if method == "PivotTo" and shouldBlockLagbackPivot(self) then
                return self
            end

            return oldNamecall(self, ...)
        end

        pcall(function()
            setreadonly(mt, true)
        end)

        metaHookInstalled = true
    end

    local function restoreNamecallHook()
        if not metaHookInstalled or not oldNamecall then
            return
        end

        local ok, mt = pcall(getrawmetatable, game)

        if ok and mt then
            pcall(function()
                setreadonly(mt, false)
            end)

            mt.__namecall = oldNamecall

            pcall(function()
                setreadonly(mt, true)
            end)
        end

        metaHookInstalled = false
        oldNamecall = nil
    end

    local function neuterAntiTpFunctions()
        if typeof(getgc) ~= "function" or typeof(hookfunction) ~= "function" then
            return
        end

        pcall(function()
            for _, fn in ipairs(getgc(true)) do
                if type(fn) == "function" and not hookedFunctions[fn] then
                    local okName, fnName = pcall(debug.info, fn, "n")
                    local okSource, fnSource = pcall(debug.info, fn, "s")

                    if okName and NEUTER_NAMES[fnName] and okSource and sourceMatchesAntiTp(fnSource) then
                        hookedFunctions[fn] = hookfunction(fn, function()
                            return nil
                        end)
                    end
                end
            end
        end)
    end

    local function disableTrackedConnection(connection)
        if not connection or disabledConnections[connection] then
            return
        end

        pcall(function()
            connection:Disable()
        end)

        disabledConnections[connection] = true
    end

    local function disconnectAntiTpSignals()
        if typeof(getconnections) ~= "function" then
            return
        end

        pcall(function()
            for _, connection in ipairs(getconnections(RunService.Heartbeat)) do
                local fn = connection.Function

                if fn then
                    local okSource, fnSource = pcall(debug.info, fn, "s")

                    if okSource and sourceMatchesAntiTp(fnSource) then
                        disableTrackedConnection(connection)
                    end
                end
            end
        end)

        pcall(function()
            for _, connection in ipairs(getconnections(RunService.Stepped)) do
                local fn = connection.Function

                if fn then
                    local okSource, fnSource = pcall(debug.info, fn, "s")

                    if okSource and sourceMatchesAntiTp(fnSource) then
                        disableTrackedConnection(connection)
                    end
                end
            end
        end)

        pcall(function()
            if not remotesModule then
                remotesModule = require(ReplicatedStorage.Shared.Remotes)
            end

            local refresh = remotesModule.RigSync and remotesModule.RigSync.Refresh

            if refresh and refresh.OnClientEvent then
                for _, connection in ipairs(getconnections(refresh.OnClientEvent)) do
                    local fn = connection.Function

                    if fn then
                        local okSource, fnSource = pcall(debug.info, fn, "s")

                        if okSource and sourceMatchesAntiTp(fnSource) then
                            disableTrackedConnection(connection)
                        end
                    end
                end
            end
        end)
    end

    local function reapplyAntiTpBypass()
        if not active then
            return
        end

        forceAntiTpOff()
        installNamecallHook()
        neuterAntiTpFunctions()
        disconnectAntiTpSignals()
        destroyAntiTpScripts(LocalPlayer:FindFirstChild("PlayerScripts"))
        destroyAntiTpScripts(getCharacter())
    end

    local lastApplyAt = 0

    local function applySpeed()
        if serverActionMode then
            return
        end

        if Movement and Movement.IsServerActionMode and Movement.IsServerActionMode() then
            return
        end

        if Movement and Movement.IsTweening and Movement.IsTweening() then
            return
        end

        if Movement and Movement.IsTweenMode and Movement.IsTweenMode() then
            return
        end

        local now = os.clock()
        local applyInterval = runtime.speedBypassApplyInterval or 0.25

        if now - lastApplyAt < applyInterval then
            return
        end

        lastApplyAt = now

        local humanoid = getHumanoid()

        if not humanoid or humanoid.Health <= 0 then
            return
        end

        local speed = runtime.autoFarmWalkSpeed or 300

        if humanoid.WalkSpeed + 0.01 < speed then
            humanoid.WalkSpeed = speed
        end

        humanoid.AutoRotate = true
        humanoid.PlatformStand = false
    end

    local function bindHumanoid(humanoid)
        if walkSpeedConnection then
            walkSpeedConnection:Disconnect()
            walkSpeedConnection = nil
        end

        if not humanoid then
            return
        end

        walkSpeedConnection = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if active and Movement and Movement.IsTweening and Movement.IsTweening() then
                if humanoid.Parent and humanoid.WalkSpeed ~= 0 then
                    humanoid.WalkSpeed = 0
                end

                return
            end

            if active and Movement and Movement.IsTweenMode and Movement.IsTweenMode() then
                if humanoid.Parent and humanoid.WalkSpeed ~= 0 then
                    humanoid.WalkSpeed = 0
                end

                return
            end

            if active then
                applySpeed()
            end
        end)
    end

    local function onCharacter(character)
        destroyAntiTpScripts(character)
        bindHumanoid(character:FindFirstChildOfClass("Humanoid"))
        task.defer(reapplyAntiTpBypass)
    end

    local function enable()
        if active then
            reapplyAntiTpBypass()
            return
        end

        active = true
        reapplyAntiTpBypass()

        if not attributeConnection then
            attributeConnection = Workspace:GetAttributeChangedSignal("ClientObbyAntiTp"):Connect(function()
                if active then
                    forceAntiTpOff()
                end
            end)
        end

        if not childConnection then
            childConnection = LocalPlayer.PlayerScripts.DescendantAdded:Connect(function(instance)
                if active and instance.Name == "ObbyAntiTPClient" and instance:IsA("LocalScript") then
                    instance.Disabled = true
                    instance:Destroy()
                    task.defer(reapplyAntiTpBypass)
                end
            end)
        end

        if not characterConnection then
            characterConnection = LocalPlayer.CharacterAdded:Connect(onCharacter)
        end

        if LocalPlayer.Character then
            onCharacter(LocalPlayer.Character)
        end

        if not heartbeatConnection then
            heartbeatConnection = RunService.Heartbeat:Connect(applySpeed)
        end

        if not maintenanceThread then
            maintenanceThread = task.spawn(function()
                local maintenanceInterval = runtime.speedBypassMaintenanceInterval or 3

                while active do
                    reapplyAntiTpBypass()
                    task.wait(maintenanceInterval)
                end
            end)
        end

        applySpeed()
    end

    local function disable()
        active = false

        if heartbeatConnection then
            heartbeatConnection:Disconnect()
            heartbeatConnection = nil
        end

        maintenanceThread = nil
        restoreNamecallHook()
    end

    local function destroy()
        disable()

        if walkSpeedConnection then
            walkSpeedConnection:Disconnect()
            walkSpeedConnection = nil
        end

        if characterConnection then
            characterConnection:Disconnect()
            characterConnection = nil
        end

        if attributeConnection then
            attributeConnection:Disconnect()
            attributeConnection = nil
        end

        if childConnection then
            childConnection:Disconnect()
            childConnection = nil
        end

        hookedFunctions = {}
        disabledConnections = {}
    end

    return {
        Enable = enable,
        Disable = disable,
        Destroy = destroy,
        ApplySpeed = applySpeed,
        Reapply = reapplyAntiTpBypass,
        SetServerActionMode = function(enabled)
            local want = enabled == true

            if want == serverActionMode then
                return
            end

            serverActionMode = want

            if Movement and Movement.SetServerActionMode then
                Movement.SetServerActionMode(enabled)
            end
        end,
        IsEnabled = function()
            return active
        end,
    }
end

return SpeedBypass

end)()

local DiagnosticsModule = (function()
--[[
    Runtime diagnostics for MCP debug and hub status panel.
]]

local Diagnostics = {}

function Diagnostics.create(deps)
    local Config = deps.Config
    local EggData = deps.EggData
    local DataCollector = deps.DataCollector
    local AutoFarm = deps.AutoFarm
    local InventoryManager = deps.InventoryManager
    local Passthrough = deps.Passthrough
    local SpeedBypass = deps.SpeedBypass
    local Controller = deps.Controller
    local BasePenAutomation = deps.BasePenAutomation
    local LocalPlayer = deps.LocalPlayer

    local runtime = Config.Runtime

    local function collect()
        local eggsAll = EggData.CollectAll(false)
        local eggsVis = EggData.Collect(false)
        local bestFarm = EggData.FindBestForFarm and EggData.FindBestForFarm(nil, false) or eggsAll[1]

        local espCounts = {
            egg = #eggsVis,
            treadmill = runtime.showTreadmill and 1 or 0,
            trap = 0,
        }

        local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local standbyDist = nil

        if rootPart then
            standbyDist = (rootPart.Position - runtime.standbyPosition).Magnitude
        end

        local autoStatus = AutoFarm.GetStatus()
        local inventoryStatus = InventoryManager and InventoryManager.GetStatus() or nil
        local dayStatus = autoStatus.dayCycle
        local target = autoStatus.targetEgg
        local penStatus = BasePenAutomation and BasePenAutomation.GetStatus() or nil
        local targetMismatch = false

        if target and bestFarm and target.uid and bestFarm.uid and target.uid ~= bestFarm.uid then
            targetMismatch = true
        end

        return {
            hub = {
                active = Controller.IsActive(),
                menuVisible = runtime.hubVisible,
            },
            esp = {
                maxDistance = runtime.maxDistance,
                showTreadmill = runtime.showTreadmill,
                showTraps = runtime.showTraps,
                eggsTotal = #eggsAll,
                eggsVisible = #eggsVis,
                espCounts = espCounts,
            },
            autoFarm = {
                enabled = autoStatus.enabled,
                phase = autoStatus.phase,
                isCarrying = autoStatus.isCarrying,
                target = target and {
                    name = target.info.name,
                    rarity = target.info.rarityName,
                    tier = target.rarityTier,
                    zone = target.areaName or target.info.areaName,
                    zoneTier = target.areaTier or target.info.areaTier,
                    distance = math.floor(target.distance),
                } or nil,
                bestCandidate = bestFarm and {
                    name = bestFarm.info.name,
                    rarity = bestFarm.info.rarityName,
                    tier = bestFarm.rarityTier,
                    zone = bestFarm.areaName or bestFarm.info.areaName,
                    zoneTier = bestFarm.areaTier or bestFarm.info.areaTier,
                    distance = math.floor(bestFarm.distance),
                    uid = bestFarm.uid,
                } or nil,
                targetMismatch = targetMismatch,
                pickupFails = autoStatus.pickupFailCount,
            },
            basePen = penStatus,
            inventory = inventoryStatus,
            dayCycle = dayStatus,
            player = {
                atStandby = standbyDist ~= nil and standbyDist <= runtime.standbyArriveRadius,
                distToStandby = standbyDist and math.floor(standbyDist) or nil,
            },
            modules = {
                passthrough = Passthrough.IsActive(),
                speedBypass = SpeedBypass and SpeedBypass.IsEnabled() or false,
            },
        }
    end

    return {
        Collect = collect,
    }
end

return Diagnostics

end)()

local FarmFiltersModule = (function()
--[[
    Auto farm filters — allowed egg rarities and field zones.
]]

local FarmFilters = {}

local AREA_ID_ALIASES = {
    CherryBlossom = "Cherry Blossom",
}

function FarmFilters.create(deps)
    local Config = deps.Config
    local Rarity = deps.Rarity
    local Areas = deps.Areas
    local Assets = deps.Assets

    local runtime = Config.Runtime

    local rarityOptions = {}
    local zoneOptions = {}
    local rarityByKey = {}
    local zoneById = {}

    local function resolveZoneId(areaId)
        if typeof(areaId) ~= "string" then
            return nil
        end

        if zoneById[areaId] then
            return areaId
        end

        local aliasId = AREA_ID_ALIASES[areaId]

        if aliasId and zoneById[aliasId] then
            return aliasId
        end

        for id, option in pairs(zoneById) do
            if option.label == areaId then
                return id
            end
        end

        return areaId
    end

    local function buildOptions()
        rarityOptions = {}
        rarityByKey = {}
        zoneOptions = {}
        zoneById = {}

        local rarityGroups = {}

        if Assets and Assets.Directory then
            for _, entry in pairs(Assets.Directory) do
                local rarity = entry and entry.Rarity

                if typeof(rarity) == "table" then
                    local key = rarity._id or rarity.DisplayName or "Unknown"
                    local group = rarityGroups[key]

                    if not group then
                        group = {
                            key = key,
                            label = rarity.DisplayName or key,
                            tier = rarity.RarityNumber or 0,
                            ids = {},
                        }
                        rarityGroups[key] = group
                    end

                    local found = false

                    for _, existingId in ipairs(group.ids) do
                        if existingId == key then
                            found = true
                            break
                        end
                    end

                    if not found then
                        table.insert(group.ids, key)
                    end
                end
            end
        end

        if next(rarityGroups) == nil and Rarity and Rarity.Rarities then
            for id, entry in pairs(Rarity.Rarities) do
                local key = entry._id or id

                rarityGroups[key] = {
                    key = key,
                    label = entry.DisplayName or id,
                    tier = entry.RarityNumber or 0,
                    ids = { id },
                }
            end
        end

        for _, group in pairs(rarityGroups) do
            table.insert(rarityOptions, group)
            rarityByKey[group.key] = group
        end

        table.sort(rarityOptions, function(a, b)
            if a.tier ~= b.tier then
                return a.tier < b.tier
            end

            return a.label < b.label
        end)

        if Areas and Areas.Directory then
            for id, entry in pairs(Areas.Directory) do
                local zoneId = entry._id or id
                local option = {
                    id = zoneId,
                    label = entry.DisplayName or zoneId,
                    tier = entry.Rarity and entry.Rarity.RarityNumber or 0,
                }

                zoneById[zoneId] = option
                table.insert(zoneOptions, option)
            end
        end

        for aliasId, canonicalId in pairs(AREA_ID_ALIASES) do
            if zoneById[canonicalId] then
                zoneById[aliasId] = zoneById[canonicalId]
            end
        end

        table.sort(zoneOptions, function(a, b)
            if a.tier ~= b.tier then
                return a.tier < b.tier
            end

            return a.label < b.label
        end)
    end

    buildOptions()

    local function isMutantRecord(record)
        if typeof(record) ~= "table" then
            return false
        end

        if typeof(record.BaseMutation) == "string" and record.BaseMutation ~= "" then
            return true
        end

        local mutations = record.Mutations

        if typeof(mutations) ~= "table" then
            return false
        end

        if #mutations > 0 then
            return true
        end

        for _ in pairs(mutations) do
            return true
        end

        return false
    end

    local function isInfestedRecord(record)
        return typeof(record) == "table" and record.HasParasite == true
    end

    local function ensureRarityTable()
        if runtime.autoFarmRarities ~= nil then
            return
        end

        runtime.autoFarmRarities = {}

        for _, option in ipairs(rarityOptions) do
            for _, id in ipairs(option.ids) do
                runtime.autoFarmRarities[id] = true
            end
        end
    end

    local function ensureZoneTable()
        if runtime.autoFarmZones ~= nil then
            return
        end

        runtime.autoFarmZones = {}

        for _, option in ipairs(zoneOptions) do
            runtime.autoFarmZones[option.id] = true
        end
    end

    local function ensureSellRarityTable()
        if runtime.autoSellRarities ~= nil then
            return
        end

        runtime.autoSellRarities = {}

        for _, option in ipairs(rarityOptions) do
            for _, id in ipairs(option.ids) do
                runtime.autoSellRarities[id] = false
            end
        end
    end

    local function ensureTables()
        ensureRarityTable()
        ensureZoneTable()
        ensureSellRarityTable()
    end

    local function isRarityEnabled(rarityId)
        if typeof(rarityId) ~= "string" then
            return runtime.autoFarmFilterWhitelist ~= true
        end

        ensureRarityTable()

        if runtime.autoFarmFilterWhitelist == true then
            if runtime.autoFarmRarities[rarityId] == true then
                return true
            end

            local option = rarityByKey[rarityId]

            if option then
                for _, id in ipairs(option.ids) do
                    if runtime.autoFarmRarities[id] == true then
                        return true
                    end
                end
            end

            return false
        end

        if runtime.autoFarmRarities[rarityId] ~= nil then
            return runtime.autoFarmRarities[rarityId] == true
        end

        local option = rarityByKey[rarityId]

        if option then
            for _, id in ipairs(option.ids) do
                if runtime.autoFarmRarities[id] == false then
                    return false
                end
            end
        end

        return true
    end

    local function isZoneEnabled(areaId)
        if typeof(areaId) ~= "string" then
            return runtime.autoFarmFilterWhitelist ~= true
        end

        ensureZoneTable()

        local resolvedId = resolveZoneId(areaId)

        if runtime.autoFarmFilterWhitelist == true then
            if runtime.autoFarmZones[resolvedId] == true then
                return true
            end

            for aliasId, canonicalId in pairs(AREA_ID_ALIASES) do
                if resolvedId == aliasId or resolvedId == canonicalId then
                    if runtime.autoFarmZones[aliasId] == true or runtime.autoFarmZones[canonicalId] == true then
                        return true
                    end
                end
            end

            return false
        end

        local allowed = runtime.autoFarmZones[resolvedId]

        if allowed == nil then
            return true
        end

        return allowed == true
    end

    local function isSellRarityEnabled(rarityId)
        if typeof(rarityId) ~= "string" then
            return runtime.autoSellFilterWhitelist ~= true
        end

        ensureSellRarityTable()

        if runtime.autoSellFilterWhitelist == true then
            if runtime.autoSellRarities[rarityId] == true then
                return true
            end

            local option = rarityByKey[rarityId]

            if option then
                for _, id in ipairs(option.ids) do
                    if runtime.autoSellRarities[id] == true then
                        return true
                    end
                end
            end

            return false
        end

        if runtime.autoSellRarities[rarityId] ~= nil then
            return runtime.autoSellRarities[rarityId] == true
        end

        local option = rarityByKey[rarityId]

        if option then
            for _, id in ipairs(option.ids) do
                if runtime.autoSellRarities[id] == false then
                    return false
                end
            end
        end

        return true
    end

    local function setSellRarityEnabled(key, enabled)
        ensureSellRarityTable()

        local option = rarityByKey[key]

        if not option then
            return false
        end

        for _, id in ipairs(option.ids) do
            runtime.autoSellRarities[id] = enabled == true
        end

        return true
    end

    local function getSellRarityEnabled(key)
        ensureSellRarityTable()

        local option = rarityByKey[key]

        if not option then
            return false
        end

        for _, id in ipairs(option.ids) do
            if runtime.autoSellRarities[id] == true then
                return true
            end
        end

        return false
    end

    local function setAllSellRarities(enabled)
        ensureSellRarityTable()

        for _, option in ipairs(rarityOptions) do
            setSellRarityEnabled(option.key, enabled)
        end
    end

    local function isEggAllowed(egg)
        if not egg then
            return false
        end

        local rarityId = egg.info and egg.info.rarityId or egg.rarityId
        local areaId = egg.areaId or (egg.info and egg.info.areaId)

        if runtime.autoFarmMutantOnly == true and not isMutantRecord(egg.record) then
            return false
        end

        if runtime.autoFarmInfestedOnly == true and not isInfestedRecord(egg.record) then
            return false
        end

        return isRarityEnabled(rarityId) and isZoneEnabled(areaId)
    end

    local function setRarityEnabled(key, enabled)
        ensureRarityTable()

        local option = rarityByKey[key]

        if not option then
            return false
        end

        for _, id in ipairs(option.ids) do
            runtime.autoFarmRarities[id] = enabled == true
        end

        return true
    end

    local function setZoneEnabled(zoneId, enabled)
        ensureZoneTable()

        local resolvedId = resolveZoneId(zoneId)
        runtime.autoFarmZones[resolvedId] = enabled == true

        for aliasId, canonicalId in pairs(AREA_ID_ALIASES) do
            if resolvedId == canonicalId or resolvedId == aliasId then
                runtime.autoFarmZones[aliasId] = enabled == true
                runtime.autoFarmZones[canonicalId] = enabled == true
            end
        end

        return true
    end

    local function getRarityEnabled(key)
        ensureRarityTable()

        local option = rarityByKey[key]

        if not option then
            return true
        end

        for _, id in ipairs(option.ids) do
            if runtime.autoFarmRarities[id] == false then
                return false
            end
        end

        return true
    end

    local function getZoneEnabled(zoneId)
        ensureZoneTable()

        if runtime.autoFarmZones[zoneId] == false then
            return false
        end

        return true
    end

    local function setAllRarities(enabled)
        ensureRarityTable()

        for _, option in ipairs(rarityOptions) do
            setRarityEnabled(option.key, enabled)
        end
    end

    local function setAllZones(enabled)
        ensureZoneTable()

        for _, option in ipairs(zoneOptions) do
            runtime.autoFarmZones[option.id] = enabled == true
        end
    end

    return {
        GetRarityOptions = function()
            return rarityOptions
        end,
        GetZoneOptions = function()
            return zoneOptions
        end,
        EnsureInitialized = ensureTables,
        IsEggAllowed = isEggAllowed,
        IsMutantRecord = isMutantRecord,
        IsInfestedRecord = isInfestedRecord,
        IsRarityEnabled = isRarityEnabled,
        IsZoneEnabled = isZoneEnabled,
        GetRarityEnabled = getRarityEnabled,
        GetZoneEnabled = getZoneEnabled,
        SetRarityEnabled = setRarityEnabled,
        SetZoneEnabled = setZoneEnabled,
        SetAllRarities = setAllRarities,
        SetAllZones = setAllZones,
        IsSellRarityEnabled = isSellRarityEnabled,
        GetSellRarityEnabled = getSellRarityEnabled,
        SetSellRarityEnabled = setSellRarityEnabled,
        SetAllSellRarities = setAllSellRarities,
        ResolveZoneId = resolveZoneId,
        RebuildOptions = buildOptions,
    }
end

return FarmFilters

end)()

local FarmFilterUIModule = (function()
--[[
    Shared rarity / zone filter UI for VoidUI hub builders.
]]

local FarmFilterUI = {}

local TWEEN_MIN = 300
local TWEEN_MAX = 1000
local TWEEN_STEP = 50

local PLACE_BATCH_MIN = 1
local PLACE_BATCH_MAX = 20
local PLACE_BATCH_STEP = 1

local PLACE_INTERVAL_MIN = 10
local PLACE_INTERVAL_MAX = 600
local PLACE_INTERVAL_STEP = 10

function FarmFilterUI.clampTweenSpeed(speed)
    return math.clamp(math.floor(speed or 700), TWEEN_MIN, TWEEN_MAX)
end

function FarmFilterUI.clampAutoPlaceBatchSize(size)
    return math.clamp(math.floor(size or 5), PLACE_BATCH_MIN, PLACE_BATCH_MAX)
end

function FarmFilterUI.clampAutoPlaceInterval(seconds)
    return math.clamp(math.floor(seconds or 60), PLACE_INTERVAL_MIN, PLACE_INTERVAL_MAX)
end

function FarmFilterUI.addVoidAutoPlace(page, runtime)
    if not page or not runtime then
        return
    end

    local placeSec = page:Section({ Title = "AUTO PLACE" })

    placeSec:Toggle({
        Title = "Auto Place Enabled",
        Desc = "Place unplaced inventory eggs on your plot periodically",
        Value = runtime.autoPlaceEnabled ~= false,
        Flag = "autoPlaceEnabled",
        Callback = function(enabled)
            runtime.autoPlaceEnabled = enabled ~= false
        end,
    })

    placeSec:Slider({
        Title = "Eggs Per Round",
        Desc = "How many eggs to place each auto-place cycle",
        Min = PLACE_BATCH_MIN,
        Max = PLACE_BATCH_MAX,
        Value = FarmFilterUI.clampAutoPlaceBatchSize(runtime.autoPlaceBatchSize),
        Suffix = "",
        Flag = "autoPlaceBatchSize",
        Callback = function(value)
            runtime.autoPlaceBatchSize = FarmFilterUI.clampAutoPlaceBatchSize(value)
        end,
    })

    placeSec:Slider({
        Title = "Place Interval",
        Desc = "Seconds between auto-place rounds",
        Min = PLACE_INTERVAL_MIN,
        Max = PLACE_INTERVAL_MAX,
        Value = FarmFilterUI.clampAutoPlaceInterval(runtime.autoPlaceInterval),
        Suffix = " sec",
        Flag = "autoPlaceInterval",
        Callback = function(value)
            runtime.autoPlaceInterval = FarmFilterUI.clampAutoPlaceInterval(value)
        end,
    })

    placeSec:Paragraph({
        Title = "Auto Place",
        Content = "Skips when there are no unplaced eggs or no free plot space.",
    })
end

function FarmFilterUI.buildDrawingAutoPlaceRows(runtime)
    local rows = {}

    if not runtime then
        return rows
    end

    local function currentBatch()
        return FarmFilterUI.clampAutoPlaceBatchSize(runtime.autoPlaceBatchSize)
    end

    local function setBatch(size)
        runtime.autoPlaceBatchSize = FarmFilterUI.clampAutoPlaceBatchSize(size)
    end

    local function currentInterval()
        return FarmFilterUI.clampAutoPlaceInterval(runtime.autoPlaceInterval)
    end

    local function setInterval(seconds)
        runtime.autoPlaceInterval = FarmFilterUI.clampAutoPlaceInterval(seconds)
    end

    table.insert(rows, {
        label = "Auto Place Enabled",
        isOn = function()
            return runtime.autoPlaceEnabled ~= false
        end,
        toggle = function()
            runtime.autoPlaceEnabled = not (runtime.autoPlaceEnabled ~= false)
        end,
    })

    table.insert(rows, {
        label = function()
            return string.format("Place Batch: %d eggs", currentBatch())
        end,
        hideToggle = true,
        isOn = function()
            return true
        end,
        toggle = function()
            local nextBatch = currentBatch() + PLACE_BATCH_STEP

            if nextBatch > PLACE_BATCH_MAX then
                nextBatch = PLACE_BATCH_MIN
            end

            setBatch(nextBatch)
        end,
    })

    table.insert(rows, {
        label = "Place Batch -1",
        hideToggle = true,
        isOn = function()
            return false
        end,
        toggle = function()
            setBatch(currentBatch() - PLACE_BATCH_STEP)
        end,
    })

    table.insert(rows, {
        label = "Place Batch +1",
        hideToggle = true,
        isOn = function()
            return true
        end,
        toggle = function()
            setBatch(currentBatch() + PLACE_BATCH_STEP)
        end,
    })

    table.insert(rows, {
        label = function()
            return string.format("Place Interval: %ds", currentInterval())
        end,
        hideToggle = true,
        isOn = function()
            return true
        end,
        toggle = function()
            local nextInterval = currentInterval() + PLACE_INTERVAL_STEP

            if nextInterval > PLACE_INTERVAL_MAX then
                nextInterval = PLACE_INTERVAL_MIN
            end

            setInterval(nextInterval)
        end,
    })

    table.insert(rows, {
        label = "Place Interval -10s",
        hideToggle = true,
        isOn = function()
            return false
        end,
        toggle = function()
            setInterval(currentInterval() - PLACE_INTERVAL_STEP)
        end,
    })

    table.insert(rows, {
        label = "Place Interval +10s",
        hideToggle = true,
        isOn = function()
            return true
        end,
        toggle = function()
            setInterval(currentInterval() + PLACE_INTERVAL_STEP)
        end,
    })

    return rows
end

function FarmFilterUI.addVoidFarmSettings(section, runtime)
    if not section or not runtime then
        return
    end

    section:Slider({
        Title = "Tween Speed",
        Desc = "Movement speed while auto farming (300-1000)",
        Min = TWEEN_MIN,
        Max = TWEEN_MAX,
        Value = FarmFilterUI.clampTweenSpeed(runtime.tweenSpeed),
        Suffix = "",
        Flag = "tweenSpeed",
        Callback = function(value)
            runtime.tweenSpeed = FarmFilterUI.clampTweenSpeed(value)
        end,
    })

    section:Toggle({
        Title = "Strict Filters (Whitelist)",
        Desc = "Only farm rarities/zones that are toggled ON",
        Value = runtime.autoFarmFilterWhitelist ~= false,
        Flag = "filterWhitelist",
        Callback = function(enabled)
            runtime.autoFarmFilterWhitelist = enabled == true
        end,
    })
end

function FarmFilterUI.buildDrawingFarmSettingsRows(runtime)
    local rows = {}

    local function currentSpeed()
        return FarmFilterUI.clampTweenSpeed(runtime and runtime.tweenSpeed)
    end

    local function setSpeed(speed)
        if runtime then
            runtime.tweenSpeed = FarmFilterUI.clampTweenSpeed(speed)
        end
    end

    table.insert(rows, {
        label = function()
            return string.format("Tween Speed: %d", currentSpeed())
        end,
        hideToggle = true,
        isOn = function()
            return true
        end,
        toggle = function()
            local nextSpeed = currentSpeed() + TWEEN_STEP

            if nextSpeed > TWEEN_MAX then
                nextSpeed = TWEEN_MIN
            end

            setSpeed(nextSpeed)
        end,
    })

    table.insert(rows, {
        label = "Tween Speed -50",
        hideToggle = true,
        isOn = function()
            return false
        end,
        toggle = function()
            setSpeed(currentSpeed() - TWEEN_STEP)
        end,
    })

    table.insert(rows, {
        label = "Tween Speed +50",
        hideToggle = true,
        isOn = function()
            return true
        end,
        toggle = function()
            setSpeed(currentSpeed() + TWEEN_STEP)
        end,
    })

    table.insert(rows, {
        label = "Strict Filters (Whitelist)",
        isOn = function()
            return runtime and runtime.autoFarmFilterWhitelist ~= false
        end,
        toggle = function()
            if runtime then
                runtime.autoFarmFilterWhitelist = not (runtime.autoFarmFilterWhitelist ~= false)
            end
        end,
    })

    return rows
end

function FarmFilterUI.buildDrawingSetStandbyRow(localPlayer, pathService, runtime)
    return {
        label = "Set Standby Here",
        hideToggle = true,
        isOn = function()
            return false
        end,
        toggle = function()
            local character = localPlayer and localPlayer.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")

            if rootPart and runtime then
                runtime.standbyPosition = rootPart.Position

                if pathService then
                    pathService.Invalidate()
                end
            end
        end,
    }
end

function FarmFilterUI.buildDrawingPenSettingsRows(runtime, penAutomation)
    local rows = {
        {
            label = "Collect At Home Only",
            isOn = function()
                return runtime and runtime.penCollectAtStandbyOnly ~= false
            end,
            toggle = function()
                if runtime then
                    runtime.penCollectAtStandbyOnly = not (runtime.penCollectAtStandbyOnly ~= false)
                end
            end,
        },
        {
            label = "Walk Into Pen",
            isOn = function()
                return runtime and runtime.penCollectVisitPen ~= false
            end,
            toggle = function()
                if runtime then
                    runtime.penCollectVisitPen = not (runtime.penCollectVisitPen ~= false)
                end
            end,
        },
        {
            label = "Upgrade At Home Only",
            isOn = function()
                return runtime and runtime.penUpgradeAtStandbyOnly ~= false
            end,
            toggle = function()
                if runtime then
                    runtime.penUpgradeAtStandbyOnly = not (runtime.penUpgradeAtStandbyOnly ~= false)
                end
            end,
        },
    }

    if penAutomation then
        table.insert(rows, {
            label = "Collect Pen Money Now",
            hideToggle = true,
            isOn = function()
                return false
            end,
            toggle = function()
                penAutomation.TryCollect()
            end,
        })

        table.insert(rows, {
            label = "Upgrade Base Now",
            hideToggle = true,
            isOn = function()
                return false
            end,
            toggle = function()
                penAutomation.TryUpgrade()
            end,
        })
    end

    return rows
end

function FarmFilterUI.buildDrawingMiscMovementRows(runtime, speedBypass)
    return {
        {
            label = "Speed Bypass On Auto Farm",
            isOn = function()
                return runtime and runtime.speedBypassOnAutoFarm ~= false
            end,
            toggle = function()
                if runtime then
                    runtime.speedBypassOnAutoFarm = not (runtime.speedBypassOnAutoFarm ~= false)
                end
            end,
        },
        {
            label = function()
                return string.format("Walk Speed: %d", runtime and runtime.autoFarmWalkSpeed or 300)
            end,
            hideToggle = true,
            isOn = function()
                return true
            end,
            toggle = function()
                if not runtime then
                    return
                end

                local nextSpeed = (runtime.autoFarmWalkSpeed or 300) + 25

                if nextSpeed > 400 then
                    nextSpeed = 100
                end

                runtime.autoFarmWalkSpeed = nextSpeed

                if speedBypass and speedBypass.ApplySpeed then
                    speedBypass.ApplySpeed()
                end
            end,
        },
    }
end

function FarmFilterUI.addVoidPenSettings(section, runtime, penAutomation)
    if not section or not runtime then
        return
    end

    section:Toggle({
        Title = "Collect At Home Only",
        Desc = "Only collect pen money when near standby position",
        Value = runtime.penCollectAtStandbyOnly ~= false,
        Flag = "penCollectHomeOnly",
        Callback = function(enabled)
            runtime.penCollectAtStandbyOnly = enabled == true
        end,
    })

    section:Toggle({
        Title = "Walk Into Pen",
        Desc = "Tween into pet area to claim offline money",
        Value = runtime.penCollectVisitPen ~= false,
        Flag = "penCollectVisitPen",
        Callback = function(enabled)
            runtime.penCollectVisitPen = enabled == true
        end,
    })

    section:Toggle({
        Title = "Upgrade At Home Only",
        Desc = "Only upgrade base pen while near standby",
        Value = runtime.penUpgradeAtStandbyOnly ~= false,
        Flag = "penUpgradeHomeOnly",
        Callback = function(enabled)
            runtime.penUpgradeAtStandbyOnly = enabled == true
        end,
    })

    section:Slider({
        Title = "Upgrade Check Interval",
        Desc = "How often to try upgrading base pen",
        Min = 5,
        Max = 60,
        Value = runtime.penUpgradeCheckInterval or 10,
        Suffix = " sec",
        Flag = "penUpgradeInterval",
        Callback = function(value)
            runtime.penUpgradeCheckInterval = math.floor(value)
        end,
    })

    if penAutomation then
        section:Button({
            Title = "Collect Pen Money Now",
            Icon = "lucide:coins",
            Callback = function()
                penAutomation.TryCollect()
            end,
        })

        section:Button({
            Title = "Upgrade Base Now",
            Icon = "lucide:arrow-up",
            Callback = function()
                penAutomation.TryUpgrade()
            end,
        })
    end
end

function FarmFilterUI.addVoidMiscMovement(section, runtime, speedBypass)
    if not section or not runtime then
        return
    end

    section:Toggle({
        Title = "Speed Bypass On Auto Farm",
        Desc = "Enable anti-lagback speed when auto farm starts",
        Value = runtime.speedBypassOnAutoFarm ~= false,
        Flag = "speedBypassOnFarm",
        Callback = function(enabled)
            runtime.speedBypassOnAutoFarm = enabled == true
        end,
    })

    section:Slider({
        Title = "Walk Speed (Bypass)",
        Desc = "Humanoid WalkSpeed when speed bypass is active",
        Min = 100,
        Max = 400,
        Value = runtime.autoFarmWalkSpeed or 300,
        Suffix = "",
        Flag = "autoFarmWalkSpeed",
        Callback = function(value)
            runtime.autoFarmWalkSpeed = math.floor(value)

            if speedBypass and speedBypass.ApplySpeed then
                speedBypass.ApplySpeed()
            end
        end,
    })
end

function FarmFilterUI.addInfestedFarmVoid(section, runtime, onChange)
    if not section or not runtime then
        return
    end

    section:Toggle({
        Title = "Infested First",
        Desc = "Prioritize parasite / infested field eggs when auto farming",
        Value = runtime.autoFarmInfestedFirst ~= false,
        Flag = "infestedFirst",
        Callback = function(enabled)
            runtime.autoFarmInfestedFirst = enabled ~= false

            if onChange then
                onChange()
            end
        end,
    })

    section:Toggle({
        Title = "Infested Only",
        Desc = "Farm only infested field eggs (HasParasite)",
        Value = runtime.autoFarmInfestedOnly == true,
        Flag = "infestedOnly",
        Callback = function(enabled)
            runtime.autoFarmInfestedOnly = enabled == true

            if onChange then
                onChange()
            end
        end,
    })

    section:Toggle({
        Title = "Feed Frog After Farm",
        Desc = "Feed infested inventory eggs to the parasite frog before next run",
        Value = runtime.autoFeedParasiteEnabled ~= false,
        Flag = "autoFeedParasite",
        Callback = function(enabled)
            runtime.autoFeedParasiteEnabled = enabled ~= false
        end,
    })

    section:Toggle({
        Title = "Highest Rarity First",
        Desc = "Farm only the top enabled rarity tier until none remain",
        Value = runtime.autoFarmMaxRarityTierLock ~= false,
        Flag = "maxRarityTierLock",
        Callback = function(enabled)
            runtime.autoFarmMaxRarityTierLock = enabled ~= false

            if onChange then
                onChange()
            end
        end,
    })
end

function FarmFilterUI.buildDrawingInfestedRows(runtime, onChange)
    return {
        {
            label = "Infested First",
            isOn = function()
                return runtime.autoFarmInfestedFirst ~= false
            end,
            toggle = function()
                runtime.autoFarmInfestedFirst = not (runtime.autoFarmInfestedFirst ~= false)

                if onChange then
                    onChange()
                end
            end,
        },
        {
            label = "Infested Only",
            isOn = function()
                return runtime.autoFarmInfestedOnly == true
            end,
            toggle = function()
                runtime.autoFarmInfestedOnly = not (runtime.autoFarmInfestedOnly == true)

                if onChange then
                    onChange()
                end
            end,
        },
        {
            label = "Feed Frog After Farm",
            isOn = function()
                return runtime.autoFeedParasiteEnabled ~= false
            end,
            toggle = function()
                runtime.autoFeedParasiteEnabled = not (runtime.autoFeedParasiteEnabled ~= false)
            end,
        },
        {
            label = "Highest Rarity First",
            isOn = function()
                return runtime.autoFarmMaxRarityTierLock ~= false
            end,
            toggle = function()
                runtime.autoFarmMaxRarityTierLock = not (runtime.autoFarmMaxRarityTierLock ~= false)

                if onChange then
                    onChange()
                end
            end,
        },
    }
end

function FarmFilterUI.addMutantOnlyVoid(section, runtime, onChange)
    if not section or not runtime then
        return
    end

    section:Toggle({
        Title = "Mutant Only",
        Desc = "Farm only mutated field eggs (Golden / Silver / Rainbow / …)",
        Value = runtime.autoFarmMutantOnly == true,
        Flag = "mutantOnly",
        Callback = function(enabled)
            runtime.autoFarmMutantOnly = enabled == true

            if onChange then
                onChange()
            end
        end,
    })
end

function FarmFilterUI.buildDrawingMutantOnlyRow(runtime, onChange)
    return {
        label = "Mutant Only",
        isOn = function()
            return runtime.autoFarmMutantOnly == true
        end,
        toggle = function()
            runtime.autoFarmMutantOnly = not (runtime.autoFarmMutantOnly == true)

            if onChange then
                onChange()
            end
        end,
    }
end

function FarmFilterUI.buildVoidTab(window, ctx)
    local FarmFilters = ctx.FarmFilters
    local EggData = ctx.EggData
    local PathService = ctx.PathService

    if not FarmFilters or not window then
        return nil
    end

    local function invalidateFarmTarget()
        if EggData and EggData.InvalidateCache then
            EggData.InvalidateCache()
        end

        if PathService then
            PathService.Invalidate()
        end
    end

    FarmFilters.EnsureInitialized()

    local filterTab = window:Tab({ Title = "Filters", Icon = "lucide:filter" })
    local filterPage = filterTab:Page({ Title = "Farm Targets", Columns = 2 })
    local raritySec = filterPage:Section({ Title = "RARITY", Column = 1 })
    local zoneSec = filterPage:Section({ Title = "ZONES", Column = 2 })

    local rarityCount = 0

    for _, option in ipairs(FarmFilters.GetRarityOptions()) do
        rarityCount = rarityCount + 1
        raritySec:Toggle({
            Title = option.label,
            Value = FarmFilters.GetRarityEnabled(option.key),
            Flag = "rarity_" .. option.key,
            Callback = function(enabled)
                FarmFilters.SetRarityEnabled(option.key, enabled)
                invalidateFarmTarget()
            end,
        })
    end

    local zoneCount = 0

    for _, option in ipairs(FarmFilters.GetZoneOptions()) do
        zoneCount = zoneCount + 1
        zoneSec:Toggle({
            Title = option.label,
            Value = FarmFilters.GetZoneEnabled(option.id),
            Flag = "zone_" .. option.id:gsub("%s+", "_"),
            Callback = function(enabled)
                FarmFilters.SetZoneEnabled(option.id, enabled)
                invalidateFarmTarget()
            end,
        })
    end

    filterPage:Section({ Title = "INFO", Column = 1 }):Paragraph({
        Title = "Auto Farm",
        Content = string.format(
            "Toggle each rarity / zone — farm only what is ON (%d rarities, %d zones). Mutant-only is on the Farm tab.",
            rarityCount,
            zoneCount
        ),
    })

    if FarmFilterUI.addVoidAutoSellPage then
        FarmFilterUI.addVoidAutoSellPage(filterTab, ctx)
    end

    return filterTab
end

function FarmFilterUI.addVoidAutoSellPage(filterTab, ctx)
    local FarmFilters = ctx.FarmFilters
    local runtime = ctx.runtime

    if not FarmFilters or not filterTab or not runtime then
        return nil
    end

    FarmFilters.EnsureInitialized()

    local sellPage = filterTab:Page({ Title = "Auto Sell" })
    local sellSec = sellPage:Section({ Title = "AUTO SELL" })

    sellSec:Toggle({
        Title = "Auto Sell Enabled",
        Desc = "Sell unplaced eggs by selected rarities",
        Value = runtime.autoSellEnabled == true,
        Flag = "autoSellEnabled",
        Callback = function(enabled)
            runtime.autoSellEnabled = enabled == true
        end,
    })

    sellSec:Slider({
        Title = "Sell Interval",
        Desc = "Delay between each auto-sell attempt",
        Min = 0.5,
        Max = 10,
        Value = runtime.autoSellInterval or 1.5,
        Suffix = " sec",
        Flag = "autoSellInterval",
        Callback = function(value)
            runtime.autoSellInterval = value
        end,
    })

    local raritySec = sellPage:Section({ Title = "SELL RARITIES" })

    for _, option in ipairs(FarmFilters.GetRarityOptions()) do
        raritySec:Toggle({
            Title = "Sell " .. option.label,
            Desc = "Auto-sell unplaced eggs of this rarity",
            Value = FarmFilters.GetSellRarityEnabled(option.key),
            Flag = "sell_rarity_" .. option.key,
            Callback = function(enabled)
                FarmFilters.SetSellRarityEnabled(option.key, enabled)
            end,
        })
    end

    sellPage:Section({ Title = "INFO" }):Paragraph({
        Title = "Auto Sell",
        Content = "Toggle ON the rarities you want sold from inventory (unplaced eggs only). Does not sell equipped or placed eggs.",
    })

    return sellPage
end

function FarmFilterUI.buildDrawingSellRows(FarmFilters, runtime)
    local rows = {}

    if not FarmFilters or not runtime then
        return rows
    end

    FarmFilters.EnsureInitialized()

    table.insert(rows, {
        label = "Auto Sell Enabled",
        isOn = function()
            return runtime.autoSellEnabled == true
        end,
        toggle = function()
            runtime.autoSellEnabled = not (runtime.autoSellEnabled == true)
        end,
    })

    for _, option in ipairs(FarmFilters.GetRarityOptions()) do
        table.insert(rows, {
            label = "Sell " .. option.label,
            isOn = function()
                return FarmFilters.GetSellRarityEnabled(option.key)
            end,
            toggle = function()
                local enabled = FarmFilters.GetSellRarityEnabled(option.key)
                FarmFilters.SetSellRarityEnabled(option.key, not enabled)
            end,
        })
    end

    return rows
end

function FarmFilterUI.buildDrawingRows(FarmFilters, section, invalidateFarmTarget)
    local rows = {}

    if not FarmFilters then
        table.insert(rows, {
            label = "Filters unavailable",
            isOn = function()
                return false
            end,
            toggle = function() end,
        })

        return rows
    end

    FarmFilters.EnsureInitialized()

    if section == "rarity" then
        for _, option in ipairs(FarmFilters.GetRarityOptions()) do
            table.insert(rows, {
                label = option.label,
                isOn = function()
                    return FarmFilters.GetRarityEnabled(option.key)
                end,
                toggle = function()
                    local enabled = FarmFilters.GetRarityEnabled(option.key)
                    FarmFilters.SetRarityEnabled(option.key, not enabled)
                    invalidateFarmTarget()
                end,
            })
        end

        return rows
    end

    for _, option in ipairs(FarmFilters.GetZoneOptions()) do
        table.insert(rows, {
            label = option.label,
            isOn = function()
                return FarmFilters.GetZoneEnabled(option.id)
            end,
            toggle = function()
                local enabled = FarmFilters.GetZoneEnabled(option.id)
                FarmFilters.SetZoneEnabled(option.id, not enabled)
                invalidateFarmTarget()
            end,
        })
    end

    return rows
end

return FarmFilterUI

end)()

local HubDrawingModule = (function()
--[[
    Steal An Egg hub — Drawing UI (works on Potassium / loadfile).
    Default toggle: G | click tabs + rows
]]

local Hub = {}

function Hub.create(deps)
    local Config = deps.Config
    local Util = deps.Util
    local UserInputService = deps.UserInputService
    local AutoFarm = deps.AutoFarm
    local SpeedBypass = deps.SpeedBypass
    local Diagnostics = deps.Diagnostics
    local PathService = deps.PathService
    local FarmFilters = deps.FarmFilters
    local FarmFilterUI = deps.FarmFilterUI
    local EggData = deps.EggData
    local BasePenAutomation = deps.BasePenAutomation
    local LocalPlayer = deps.LocalPlayer or game:GetService("Players").LocalPlayer

    local theme = Config.Theme
    local layout = Config.Layout
    local runtime = Config.Runtime
    local font = Config.Drawing.font

    local visible = runtime.hubVisible ~= false
    local activeTab = "Farm"
    local clickRegions = {}
    local inputConnection = nil
    local callbacks = {}

    local statusCache = {
        at = 0,
        lines = { "Loading...", "", "" },
    }

    local TABS = {
        { id = "Farm", label = "FRM" },
        { id = "Rarity", label = "RAR" },
        { id = "Zone", label = "ZON" },
        { id = "Sell", label = "SEL" },
        { id = "ESP", label = "ESP" },
        { id = "Pet", label = "PET" },
        { id = "Misc", label = "MSC" },
    }

    local function buildFilterRows(section)
        if FarmFilterUI and FarmFilterUI.buildDrawingRows then
            return FarmFilterUI.buildDrawingRows(FarmFilters, section, invalidateFarmTarget)
        end

        return {
            {
                label = "Filters unavailable",
                isOn = function()
                    return false
                end,
                toggle = function() end,
            },
        }
    end

    local function invalidateFarmTarget()
        if EggData and EggData.InvalidateCache then
            EggData.InvalidateCache()
        end

        if PathService then
            PathService.Invalidate()
        end
    end

    local draw = {
        shadow = Util.createDrawing("Square", { Filled = true, Visible = false }),
        panel = Util.createDrawing("Square", { Filled = true, Visible = false }),
        border = Util.createDrawing("Square", { Filled = false, Thickness = 1, Visible = false }),
        sidebar = Util.createDrawing("Square", { Filled = true, Visible = false }),
        title = Util.createDrawing("Text", { Size = 15, Center = false, Outline = true, Visible = false }),
        hint = Util.createDrawing("Text", { Size = 12, Center = false, Outline = true, Visible = false }),
        section = Util.createDrawing("Text", { Size = 13, Center = false, Outline = true, Visible = false }),
    }

    local tabDrawings = {}
    local rowDrawings = {}
    local statusDrawings = {}

    local function setDiagnostics(diagnostics)
        Diagnostics = diagnostics
    end

    local function ensureTabs(count)
        while #tabDrawings < count do
            table.insert(tabDrawings, {
                bg = Util.createDrawing("Square", { Filled = true, Visible = false }),
                label = Util.createDrawing("Text", { Size = 11, Center = true, Outline = true, Visible = false }),
            })
        end
    end

    local function ensureRows(count)
        while #rowDrawings < count do
            table.insert(rowDrawings, {
                bg = Util.createDrawing("Square", { Filled = true, Visible = false }),
                track = Util.createDrawing("Square", { Filled = true, Visible = false }),
                knob = Util.createDrawing("Square", { Filled = true, Visible = false }),
                label = Util.createDrawing("Text", { Size = 13, Center = false, Outline = true, Visible = false }),
            })
        end
    end

    local function ensureStatusLines(count)
        while #statusDrawings < count do
            table.insert(statusDrawings, Util.createDrawing("Text", {
                Size = 12,
                Center = false,
                Outline = true,
                Visible = false,
            }))
        end
    end

    local function hideTabs(fromIndex)
        for index = fromIndex, #tabDrawings do
            tabDrawings[index].bg.Visible = false
            tabDrawings[index].label.Visible = false
        end
    end

    local function hideRows(fromIndex)
        for index = fromIndex, #rowDrawings do
            local row = rowDrawings[index]
            row.bg.Visible = false
            row.track.Visible = false
            row.knob.Visible = false
            row.label.Visible = false
        end
    end

    local function hideStatus(fromIndex)
        for index = fromIndex, #statusDrawings do
            statusDrawings[index].Visible = false
        end
    end

    local function hideAll()
        for _, object in pairs(draw) do
            object.Visible = false
        end

        hideTabs(1)
        hideRows(1)
        hideStatus(1)
        clickRegions = {}
    end

    local function buildTabRows(tabId)
        if tabId == "Farm" then
            local rows = {
                {
                    label = function()
                        return AutoFarm.GetStatus().enabled and "Auto Farm [ON]" or "Auto Farm [OFF]"
                    end,
                    isOn = function()
                        return AutoFarm.GetStatus().enabled
                    end,
                    toggle = function()
                        local status = AutoFarm.GetStatus()

                        if status.enabled then
                            if callbacks.onAutoFarmStop then
                                callbacks.onAutoFarmStop()
                            end
                        elseif callbacks.onAutoFarmStart then
                            callbacks.onAutoFarmStart()
                        end
                    end,
                },
                {
                    label = "Wait For Day (night reset)",
                    isOn = function()
                        return runtime.waitForDayBeforeFarm ~= false
                    end,
                    toggle = function()
                        runtime.waitForDayBeforeFarm = not (runtime.waitForDayBeforeFarm ~= false)
                    end,
                },
            }

            if FarmFilterUI and FarmFilterUI.buildDrawingFarmSettingsRows then
                for _, row in ipairs(FarmFilterUI.buildDrawingFarmSettingsRows(runtime)) do
                    table.insert(rows, row)
                end
            end

            if FarmFilterUI and FarmFilterUI.buildDrawingMutantOnlyRow then
                table.insert(rows, FarmFilterUI.buildDrawingMutantOnlyRow(runtime, invalidateFarmTarget))
            end

            if FarmFilterUI and FarmFilterUI.buildDrawingInfestedRows then
                for _, row in ipairs(FarmFilterUI.buildDrawingInfestedRows(runtime, invalidateFarmTarget)) do
                    table.insert(rows, row)
                end
            end

            if FarmFilterUI and FarmFilterUI.buildDrawingSetStandbyRow then
                table.insert(rows, FarmFilterUI.buildDrawingSetStandbyRow(LocalPlayer, PathService, runtime))
            end

            return rows
        end

        if tabId == "Rarity" then
            return buildFilterRows("rarity")
        end

        if tabId == "Zone" then
            return buildFilterRows("zone")
        end

        if tabId == "Sell" then
            if FarmFilterUI and FarmFilterUI.buildDrawingSellRows then
                return FarmFilterUI.buildDrawingSellRows(FarmFilters, runtime)
            end

            return {}
        end

        if tabId == "ESP" then
            return {
                {
                    label = "Treadmill ESP",
                    isOn = function()
                        return runtime.showTreadmill == true
                    end,
                    toggle = function()
                        runtime.showTreadmill = not runtime.showTreadmill
                    end,
                },
                {
                    label = "Treadmill Bounds",
                    isOn = function()
                        return runtime.showTreadmillBounds == true
                    end,
                    toggle = function()
                        runtime.showTreadmillBounds = not runtime.showTreadmillBounds
                    end,
                },
                {
                    label = "Trap ESP",
                    isOn = function()
                        return runtime.showTraps == true
                    end,
                    toggle = function()
                        runtime.showTraps = not runtime.showTraps
                    end,
                },
                {
                    label = "Trap Bounds",
                    isOn = function()
                        return runtime.showTrapBounds == true
                    end,
                    toggle = function()
                        runtime.showTrapBounds = not runtime.showTrapBounds
                    end,
                },
                {
                    label = "Avoid Own Traps",
                    isOn = function()
                        return runtime.pathAvoidOwnTraps == true
                    end,
                    toggle = function()
                        runtime.pathAvoidOwnTraps = not runtime.pathAvoidOwnTraps

                        if PathService then
                            PathService.Invalidate()
                        end
                    end,
                },
            }
        end

        if tabId == "Pet" then
            local rows = {
                {
                    label = "Pet Care (Master)",
                    isOn = function()
                        return runtime.autoPetCareEnabled ~= false
                    end,
                    toggle = function()
                        runtime.autoPetCareEnabled = not (runtime.autoPetCareEnabled ~= false)
                    end,
                },
                {
                    label = "Auto Hatch Ready Eggs",
                    isOn = function()
                        return runtime.autoHatchEnabled ~= false
                    end,
                    toggle = function()
                        runtime.autoHatchEnabled = not (runtime.autoHatchEnabled ~= false)
                    end,
                },
                {
                    label = "Auto Equip Best",
                    isOn = function()
                        return runtime.autoEquipBest ~= false
                    end,
                    toggle = function()
                        runtime.autoEquipBest = not (runtime.autoEquipBest ~= false)
                    end,
                },
                {
                    label = "Auto Fuse (3+ dupes)",
                    isOn = function()
                        return runtime.autoFuseEnabled ~= false
                    end,
                    toggle = function()
                        runtime.autoFuseEnabled = not (runtime.autoFuseEnabled ~= false)
                    end,
                },
                {
                    label = "Auto Upgrade Base Pen",
                    isOn = function()
                        return runtime.autoUpgradeBasePen ~= false
                    end,
                    toggle = function()
                        runtime.autoUpgradeBasePen = not (runtime.autoUpgradeBasePen ~= false)
                    end,
                },
                {
                    label = "Auto Collect Pen Money",
                    isOn = function()
                        return runtime.autoCollectPenMoney ~= false
                    end,
                    toggle = function()
                        runtime.autoCollectPenMoney = not (runtime.autoCollectPenMoney ~= false)
                    end,
                },
            }

            if FarmFilterUI and FarmFilterUI.buildDrawingPenSettingsRows then
                for _, row in ipairs(FarmFilterUI.buildDrawingPenSettingsRows(runtime, BasePenAutomation)) do
                    table.insert(rows, row)
                end
            end

            if FarmFilterUI and FarmFilterUI.buildDrawingAutoPlaceRows then
                for _, row in ipairs(FarmFilterUI.buildDrawingAutoPlaceRows(runtime)) do
                    table.insert(rows, row)
                end
            end

            return rows
        end

        local miscRows = {
            {
                label = "Speed Bypass",
                isOn = function()
                    return SpeedBypass and SpeedBypass.IsEnabled() or false
                end,
                toggle = function()
                    if not SpeedBypass then
                        return
                    end

                    if SpeedBypass.IsEnabled() then
                        SpeedBypass.Disable()
                    else
                        SpeedBypass.Enable()
                    end
                end,
            },
        }

        if FarmFilterUI and FarmFilterUI.buildDrawingMiscMovementRows then
            for _, row in ipairs(FarmFilterUI.buildDrawingMiscMovementRows(runtime, SpeedBypass)) do
                table.insert(miscRows, row)
            end
        end

        return miscRows
    end

    local function refreshStatus()
        if not Diagnostics then
            statusCache.lines = { "No diagnostics", "", "" }
            return
        end

        local diag = Diagnostics.Collect()
        local lines = {
            string.format(
                "Eggs %d/%d | %s | carry:%s",
                diag.esp.eggsVisible,
                diag.esp.eggsTotal,
                diag.autoFarm.phase,
                tostring(diag.autoFarm.isCarrying)
            ),
            "Target: none",
            "",
        }

        if diag.autoFarm.target then
            local t = diag.autoFarm.target
            local zone = t.zone and ("[" .. t.zone .. "] ") or ""
            local tier = t.zoneTier and t.zoneTier > 0 and (" T" .. t.zoneTier) or ""

            lines[2] = string.format("Target: %s%s%s (%s) %dm", zone, t.name, tier, t.rarity, t.distance)
        elseif diag.autoFarm.bestCandidate then
            local c = diag.autoFarm.bestCandidate
            local zone = c.zone and ("[" .. c.zone .. "] ") or ""
            local tier = c.zoneTier and c.zoneTier > 0 and (" T" .. c.zoneTier) or ""

            lines[2] = string.format("Next: %s%s%s (%s) %dm", zone, c.name, tier, c.rarity, c.distance)
        end

        if diag.inventory and diag.inventory.active then
            lines[3] = string.format("Inv: %s - %s", diag.inventory.phase, diag.inventory.detail or "")
        elseif diag.basePen and (diag.basePen.claimableOffline or 0) > 0 then
            lines[3] = string.format("Pen: claim $%d", diag.basePen.claimableOffline)
        elseif diag.basePen and diag.basePen.canUpgrade and diag.basePen.nextTier then
            lines[3] = string.format("Pen: upgrade T%s ready", tostring(diag.basePen.nextTier))
        elseif diag.autoFarm.targetMismatch then
            lines[3] = "Target stale — refreshing"
        elseif diag.dayCycle and diag.dayCycle.blocked then
            lines[3] = "Night reset — waiting for day"
        end

        statusCache.lines = lines
    end

    local function render(camera)
        if not visible or not camera then
            hideAll()
            return
        end

        local sidebarW = 38
        local panelW = layout.hubPanelWidth or 280
        local totalW = panelW + sidebarW
        local rowH = layout.hubRowHeight or 26
        local pad = layout.hubPadding or 10
        local tabH = 32
        local statusLines = 3
        local rows = buildTabRows(activeTab)
        local rowCount = #rows
        local contentH = 44 + rowCount * (rowH + 4) + statusLines * 14 + pad
        local panelH = math.max(contentH, 220)

        local viewport = camera.ViewportSize
        local x = viewport.X - totalW - 14
        local y = 14

        clickRegions = {}

        draw.shadow.Size = Vector2.new(totalW + 4, panelH + 4)
        draw.shadow.Position = Vector2.new(x + 2, y + 2)
        draw.shadow.Color = theme.shadow
        draw.shadow.Transparency = 0.4
        draw.shadow.Visible = true

        draw.panel.Size = Vector2.new(totalW, panelH)
        draw.panel.Position = Vector2.new(x, y)
        draw.panel.Color = Color3.fromRGB(16, 16, 18)
        draw.panel.Transparency = 0.06
        draw.panel.Visible = true

        draw.border.Size = Vector2.new(totalW, panelH)
        draw.border.Position = Vector2.new(x, y)
        draw.border.Color = theme.border
        draw.border.Transparency = 0.1
        draw.border.Visible = true

        draw.sidebar.Size = Vector2.new(sidebarW, panelH)
        draw.sidebar.Position = Vector2.new(x, y)
        draw.sidebar.Color = Color3.fromRGB(12, 12, 14)
        draw.sidebar.Transparency = 0.02
        draw.sidebar.Visible = true

        local contentX = x + sidebarW

        draw.title.Text = "Steal An Egg"
        draw.title.Font = font
        draw.title.Color = theme.textMain
        draw.title.Position = Vector2.new(contentX + pad, y + pad)
        draw.title.Visible = true

        draw.hint.Text = string.format("[%s] hide", runtime.hubToggleKey and runtime.hubToggleKey.Name or "G")
        draw.hint.Font = font
        draw.hint.Color = theme.textMuted
        draw.hint.Position = Vector2.new(contentX + pad, y + pad + 16)
        draw.hint.Visible = true

        draw.section.Text = activeTab
        draw.section.Font = font
        draw.section.Color = theme.dotRing
        draw.section.Position = Vector2.new(contentX + pad, y + pad + 34)
        draw.section.Visible = true

        ensureTabs(#TABS)

        for index, tab in ipairs(TABS) do
            local tabY = y + (index - 1) * (tabH + 2) + 8
            local tabDraw = tabDrawings[index]
            local selected = tab.id == activeTab

            tabDraw.bg.Size = Vector2.new(sidebarW - 4, tabH)
            tabDraw.bg.Position = Vector2.new(x + 2, tabY)
            tabDraw.bg.Color = selected and theme.dotCore or Color3.fromRGB(22, 22, 26)
            tabDraw.bg.Transparency = selected and 0.05 or 0.15
            tabDraw.bg.Visible = true

            tabDraw.label.Text = tab.label
            tabDraw.label.Font = font
            tabDraw.label.Color = selected and theme.textMain or theme.textMuted
            tabDraw.label.Position = Vector2.new(x + sidebarW * 0.5, tabY + 10)
            tabDraw.label.Visible = true

            table.insert(clickRegions, {
                x1 = x + 2,
                y1 = tabY,
                x2 = x + sidebarW - 2,
                y2 = tabY + tabH,
                action = function()
                    activeTab = tab.id
                end,
            })
        end

        hideTabs(#TABS + 1)

        ensureRows(rowCount)

        for index, rowDef in ipairs(rows) do
            local rowY = y + pad + 54 + (index - 1) * (rowH + 4)
            local row = rowDrawings[index]
            local enabled = rowDef.isOn()
            local labelText = typeof(rowDef.label) == "function" and rowDef.label() or rowDef.label
            local rowW = panelW - pad * 2

            row.bg.Size = Vector2.new(rowW, rowH)
            row.bg.Position = Vector2.new(contentX + pad, rowY)
            row.bg.Color = Color3.fromRGB(24, 24, 27)
            row.bg.Transparency = 0.08
            row.bg.Visible = true

            local hideToggle = rowDef.hideToggle == true

            row.track.Visible = not hideToggle
            row.knob.Visible = not hideToggle

            if not hideToggle then
                row.track.Size = Vector2.new(38, 18)
                row.track.Position = Vector2.new(contentX + pad + rowW - 44, rowY + 4)
                row.track.Color = enabled and theme.dotCore or Color3.fromRGB(46, 46, 52)
                row.track.Transparency = 0.05

                row.knob.Size = Vector2.new(14, 14)
                row.knob.Position = enabled
                    and Vector2.new(contentX + pad + rowW - 22, rowY + 6)
                    or Vector2.new(contentX + pad + rowW - 40, rowY + 6)
                row.knob.Color = Color3.fromRGB(245, 245, 247)
                row.knob.Transparency = 0
            end

            row.label.Text = labelText
            row.label.Font = font
            row.label.Color = theme.textMain
            row.label.Position = Vector2.new(contentX + pad + 6, rowY + 5)
            row.label.Visible = true

            table.insert(clickRegions, {
                x1 = contentX + pad,
                y1 = rowY,
                x2 = contentX + pad + rowW,
                y2 = rowY + rowH,
                action = rowDef.toggle,
            })
        end

        hideRows(rowCount + 1)

        if os.clock() - statusCache.at >= (runtime.hubStatusRefreshInterval or 0.5) then
            refreshStatus()
            statusCache.at = os.clock()
        end

        ensureStatusLines(statusLines)

        local statusY = y + panelH - pad - statusLines * 14

        for index = 1, statusLines do
            local line = statusDrawings[index]
            line.Text = statusCache.lines[index] or ""
            line.Font = font
            line.Color = theme.textMuted
            line.Position = Vector2.new(contentX + pad, statusY + (index - 1) * 14)
            line.Visible = line.Text ~= ""
        end

        hideStatus(statusLines + 1)
    end

    local function pointInRegion(mouseX, mouseY, region)
        return mouseX >= region.x1 and mouseX <= region.x2 and mouseY >= region.y1 and mouseY <= region.y2
    end

    local function handleClick(input)
        if not visible or input.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return
        end

        local mouse = UserInputService:GetMouseLocation()

        for _, region in ipairs(clickRegions) do
            if pointInRegion(mouse.X, mouse.Y, region) then
                region.action()
                return
            end
        end
    end

    local function handleInput(input, processed)
        if processed then
            return
        end

        if input.KeyCode == (runtime.hubToggleKey or Enum.KeyCode.G) then
            visible = not visible
            runtime.hubVisible = visible
            return
        end

        handleClick(input)
    end

    local function setCallbacks(newCallbacks)
        callbacks = newCallbacks or {}
    end

    local function start()
        if inputConnection then
            inputConnection:Disconnect()
        end

        inputConnection = UserInputService.InputBegan:Connect(handleInput)
        print(string.format("[NMHUB] Hub ready — %s to toggle | tabs: FRM RAR ZON ESP PET MSC", (runtime.hubToggleKey or Enum.KeyCode.G).Name))
    end

    local function stop()
        hideAll()

        if inputConnection then
            inputConnection:Disconnect()
            inputConnection = nil
        end
    end

    local function destroy()
        stop()

        for _, object in pairs(draw) do
            object:Remove()
        end

        for _, tab in ipairs(tabDrawings) do
            tab.bg:Remove()
            tab.label:Remove()
        end

        for _, row in ipairs(rowDrawings) do
            row.bg:Remove()
            row.track:Remove()
            row.knob:Remove()
            row.label:Remove()
        end

        for _, line in ipairs(statusDrawings) do
            line:Remove()
        end

        tabDrawings = {}
        rowDrawings = {}
        statusDrawings = {}
    end

    return {
        Start = start,
        Stop = stop,
        Destroy = destroy,
        Render = render,
        SetCallbacks = setCallbacks,
        SetVisible = function(value)
            visible = value == true
            runtime.hubVisible = visible
        end,
        IsVisible = function()
            return visible
        end,
        ToggleVisible = function()
            visible = not visible
            runtime.hubVisible = visible
            return visible
        end,
        SetDiagnostics = setDiagnostics,
    }
end

return Hub

end)()

local VoidUIModule = (function()
--[[
    VoidUI — voidw0rld (flat charcoal, accent only on active)
    Docs: CHANGELOG.md · VoidUI.API.md
    Usage:
      local VoidUI = loadstring(game:HttpGet(".../VoidUI.lua"))()

    API sketch:
      local W = VoidUI:CreateWindow({ Title=..., Icon=..., Accent=..., Search=true, OpenButton=true })
      Page:Section({ Title=..., Icon="rbxassetid://...", TitleSize=, IconSize=, HeaderScale= })
      CreateWindow({ SectionHeader={ TitleSize=14, IconSize=15, Scale=1 } })  -- defaults; override per game
      S:Toggle / Slider / Dropdown / Button / Input / Keybind  — row icons omitted (section header only)
      S:PriorityList({ Values=..., MaxVisible=, RowHeight=, Resizable=true, Callback=fn })
      S:Panel({ Title=, Desc=, Values={{Name,Id,Image,Right,Sub}}, Flag= }) -- progress / item rows
      W:Popup({ Title=..., Size=..., Icon=... })  -- Hidden host page; does not add a Farm subtab
      VoidUI:Notify({ Title=, Content=, Icon=, Duration= })
      Assets: "rbxassetid://N" | number | "lucide:name" anywhere Icon/Image is accepted
]]

local VoidUI = {
    Version = "1.8.5",
    _windows = {},
}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")

local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

---------------------------------------------------------------------------
-- Theme
---------------------------------------------------------------------------
local Theme = {
    -- Neutral charcoal. Accent is brand — use only for ON / selected / fill.
    Accent = Color3.fromRGB(162, 89, 255),
    AccentDim = Color3.fromRGB(124, 58, 210),
    Bg = Color3.fromRGB(16, 16, 18),
    BgPanel = Color3.fromRGB(20, 20, 22),
    BgSidebar = Color3.fromRGB(14, 14, 16),
    BgSection = Color3.fromRGB(24, 24, 27),
    BgHover = Color3.fromRGB(36, 36, 40),
    BgInput = Color3.fromRGB(18, 18, 20),
    BgToggleOff = Color3.fromRGB(46, 46, 52),
    Stroke = Color3.fromRGB(48, 48, 54),
    Divider = Color3.fromRGB(38, 38, 42),
    Text = Color3.fromRGB(245, 245, 247),
    TextDim = Color3.fromRGB(158, 158, 166),
    TextMute = Color3.fromRGB(112, 112, 120),
    Shadow = Color3.fromRGB(0, 0, 0),
    Danger = Color3.fromRGB(255, 92, 110),
    Success = Color3.fromRGB(92, 214, 148),
    RWin = 12,
    RCard = 8,
    RCtrl = 8,
}

local Fonts = {
    Title = Enum.Font.GothamBold,
    Body = Enum.Font.GothamMedium,
    Desc = Enum.Font.Gotham,
    Mono = Enum.Font.Code,
}

-- Dropdown / PriorityList entry helpers (string or { Name, Image, Icon, Id })
local function entryKey(v)
    if type(v) == "table" then
        return tostring(v.Id or v.Name or v.Title or v.Text or v[1] or "?")
    end
    return tostring(v)
end
local function entryLabel(v)
    if type(v) == "table" then
        return tostring(v.Name or v.Title or v.Text or v.Id or "?")
    end
    return tostring(v)
end
local function entryAsset(v)
    if type(v) ~= "table" then return nil end
    local a = v.Image or v.Icon or v.Asset
    if type(a) == "number" then return "rbxassetid://" .. tostring(a) end
    return a
end
-- Accept number / "rbxassetid://…" / "lucide:…" / table with Icon|Image|Asset
local function normalizeAsset(a)
    if a == nil or a == false or a == "" then return nil end
    if type(a) == "number" then return "rbxassetid://" .. tostring(a) end
    if type(a) == "string" then return a end
    if type(a) == "table" then return entryAsset(a) end
    return nil
end
VoidUI.NormalizeAsset = normalizeAsset
local function entriesEqual(a, b)
    if a == b then return true end
    if type(a) == "table" or type(b) == "table" then
        return entryKey(a) == entryKey(b)
    end
    return tostring(a) == tostring(b)
end

local TI = TweenInfo.new
local function tween(obj, info, props)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

---------------------------------------------------------------------------
-- Icons — Lucide / Geist / Craft (Footagesus/Icons, same as WindUI)
-- Usage: "swords" | "lucide:swords" | "geist:window" | "craft:macbook-stroke"
--        or raw "rbxassetid://..."
---------------------------------------------------------------------------
local ICON_CDN = {
    lucide = "https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/lucide/dist/Icons.lua",
    craft = "https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/craft/dist/Icons.lua",
    geist = "https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/geist/dist/Icons.lua",
    solar = "https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/solar/dist/Icons.lua",
}

local IconPacks = {}
local IconAlias = {
    home = "house",
    sword = "swords",
    bag = "backpack",
    gear = "settings",
    plant = "leaf",
    cart = "shopping-cart",
    shop = "shopping-cart",
    piggy = "piggy-bank",
    money = "coins",
    keys = "key",
    robot = "bot",
    turtle = "origami",
    chevron = "chevron-down",
    close = "x",
    minimize = "minus",
    search = "search",
    warn = "triangle-alert",
    check = "check",
    info = "info",
    dice = "dices",
    expand = "maximize-2",
    target = "crosshair",
    flame = "flame",
    bolt = "zap",
    eye = "eye",
    lock = "lock",
    unlock = "lock-open",
    server = "server",
    code = "code",
    list = "list",
    grid = "layout-grid",
    user = "user",
    star = "star",
    play = "play",
    pause = "pause",
    plus = "plus",
    minus = "minus",
}

local function httpGet(url)
    local ok, body = pcall(function()
        if type(game.HttpGetAsync) == "function" then
            return game:HttpGetAsync(url)
        end
        return game:HttpGet(url)
    end)
    if ok and type(body) == "string" and #body > 50 and body:sub(1, 1) ~= "<" then
        return body
    end
    return nil
end

local function loadIconPack(pack)
    pack = string.lower(pack or "lucide")
    if IconPacks[pack] then return IconPacks[pack] end
    local url = ICON_CDN[pack]
    if not url then return nil end
    local src = httpGet(url)
    if not src then return nil end
    local fn = (loadstring or load)(src, "@Icons-" .. pack)
    if not fn then return nil end
    local ok, data = pcall(fn)
    if ok and type(data) == "table" then
        IconPacks[pack] = data
        return data
    end
    return nil
end

-- returns rbxassetid string or nil
local function resolveIcon(name)
    if not name or name == "" then return nil end
    if typeof(name) ~= "string" then
        name = tostring(name)
    end
    if name:find("rbxasset", 1, true) or name:find("http", 1, true) then
        return name
    end

    local pack, iconName = "lucide", name
    local colon = name:find(":", 1, true)
    if colon then
        pack = string.lower(name:sub(1, colon - 1))
        iconName = name:sub(colon + 1)
    else
        iconName = IconAlias[string.lower(name)] or string.lower(name)
    end

    local set = loadIconPack(pack)
    if not set then
        -- fallback lucide
        if pack ~= "lucide" then
            set = loadIconPack("lucide")
            iconName = IconAlias[string.lower(iconName)] or iconName
        end
    end
    if not set then return nil end

    local id = set[iconName] or set[IconAlias[iconName]]
    if type(id) == "string" then return id end
    if type(id) == "number" then return "rbxassetid://" .. tostring(id) end
    if type(id) == "table" and id.Image then
        local img = id.Image
        if type(img) == "number" then return "rbxassetid://" .. tostring(img) end
        return img
    end
    return nil
end

local function makeIcon(parent, iconName, size, color, z)
    size = size or 18
    local asset = resolveIcon(iconName)
    local holder = Instance.new("Frame")
    holder.BackgroundTransparency = 1
    holder.Size = UDim2.fromOffset(size, size)
    holder.Parent = parent

    local img
    if asset then
        img = Instance.new("ImageLabel")
        img.BackgroundTransparency = 1
        img.Image = asset
        img.ImageColor3 = color or Theme.TextDim
        img.ScaleType = Enum.ScaleType.Fit
        img.Size = UDim2.fromScale(1, 1)
        img.ZIndex = z or 2
        img.Parent = holder
        holder:SetAttribute("IsIcon", true)
        return holder, img
    end
    local dot = Instance.new("Frame")
    dot.BackgroundColor3 = color or Theme.TextDim
    dot.BackgroundTransparency = 0.45
    dot.AnchorPoint = Vector2.new(0.5, 0.5)
    dot.Position = UDim2.fromScale(0.5, 0.5)
    dot.Size = UDim2.fromOffset(math.max(4, math.floor(size * 0.28)), math.max(4, math.floor(size * 0.28)))
    dot.Parent = holder
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(1, 0)
    c.Parent = dot
    return holder, nil
end

local function setIconColor(iconImg, color)
    if iconImg and iconImg:IsA("ImageLabel") then
        iconImg.ImageColor3 = color
    end
end

VoidUI.ResolveIcon = resolveIcon
VoidUI.SetIconPack = function(_, pack)
    loadIconPack(pack)
end

---------------------------------------------------------------------------
-- Helpers
---------------------------------------------------------------------------
local function protect(gui)
    if syn and syn.protect_gui then
        pcall(syn.protect_gui, gui)
    elseif protect_gui then
        pcall(protect_gui, gui)
    end
    local parent
    if gethui then
        pcall(function() parent = gethui() end)
    end
    if not parent then
        pcall(function() parent = CoreGui end)
    end
    if not parent then
        parent = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui")
    end
    gui.Parent = parent
    return gui
end

local function corner(parent, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 12)
    c.Parent = parent
    return c
end

local function stroke(parent, color, thick, trans)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.Stroke
    s.Thickness = thick or 1
    s.Transparency = trans or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function pad(parent, t, r, b, l)
    local p = Instance.new("UIPadding")
    p.PaddingTop = UDim.new(0, t or 0)
    p.PaddingRight = UDim.new(0, r or t or 0)
    p.PaddingBottom = UDim.new(0, b or t or 0)
    p.PaddingLeft = UDim.new(0, l or r or t or 0)
    p.Parent = parent
    return p
end

local function list(parent, dir, padPx, hAlign, vAlign)
    local l = Instance.new("UIListLayout")
    l.FillDirection = dir or Enum.FillDirection.Vertical
    l.Padding = UDim.new(0, padPx or 8)
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.HorizontalAlignment = hAlign or Enum.HorizontalAlignment.Left
    l.VerticalAlignment = vAlign or Enum.VerticalAlignment.Top
    l.Parent = parent
    return l
end

local function mk(class, props, children)
    local i = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then
            i[k] = v
        end
    end
    if children then
        for _, c in ipairs(children) do
            c.Parent = i
        end
    end
    if props and props.Parent then
        i.Parent = props.Parent
    end
    return i
end

-- Soft text bloom (after mk — locals aren't visible before declaration)
local function bloomLabel(opts)
    local parent = opts.Parent
    local text = opts.Text or ""
    local size = opts.TextSize or 13
    local font = opts.Font or Fonts.Title
    local color = opts.Color or Theme.Text
    local accent = opts.Accent or Theme.Accent
    local align = opts.TextXAlignment or Enum.TextXAlignment.Left
    local height = opts.Height or (size + 4)
    local bloom = opts.Bloom == true
    local layoutOrder = opts.LayoutOrder

    local wrap = mk("Frame", {
        Name = opts.Name or "BloomText",
        BackgroundTransparency = 1,
        Size = opts.Size or UDim2.new(1, 0, 0, height),
        Position = opts.Position,
        LayoutOrder = layoutOrder,
        Parent = parent,
    })

    if bloom then
        mk("TextLabel", {
            BackgroundTransparency = 1,
            Font = font,
            TextSize = size,
            TextColor3 = accent,
            TextTransparency = 0.78,
            TextXAlignment = align,
            Text = text,
            Size = UDim2.fromScale(1, 1),
            Position = UDim2.fromOffset(0, 0),
            ZIndex = 1,
            Parent = wrap,
        })
    end

    local label = mk("TextLabel", {
        BackgroundTransparency = 1,
        Font = font,
        TextSize = size,
        TextColor3 = color,
        TextXAlignment = align,
        Text = text,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 2,
        Parent = wrap,
    })
    return wrap, label
end

local function hover(btn, onEnter, onLeave)
    btn.MouseEnter:Connect(onEnter)
    btn.MouseLeave:Connect(onLeave)
end

local function ripples(btn, color)
    -- light press flash
    btn.MouseButton1Down:Connect(function()
        tween(btn, TI(0.08), { BackgroundTransparency = math.min((btn.BackgroundTransparency or 0) + 0.1, 0.5) })
    end)
    btn.MouseButton1Up:Connect(function()
        tween(btn, TI(0.12), { BackgroundTransparency = btn:GetAttribute("_bt") or 0 })
    end)
end

---------------------------------------------------------------------------
-- Notifications
---------------------------------------------------------------------------
local notifHost

local function ensureNotifHost()
    if notifHost and notifHost.Parent then return notifHost end
    local sg = Instance.new("ScreenGui")
    sg.Name = "VoidUI_Notify"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder = 9999
    sg.IgnoreGuiInset = true
    protect(sg)
    notifHost = mk("Frame", {
        Name = "Host",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -18, 0, 18),
        Size = UDim2.fromOffset(280, 640),
        Parent = sg,
    })
    list(notifHost, Enum.FillDirection.Vertical, 8, Enum.HorizontalAlignment.Right)
    return notifHost
end

-- Toast: same charcoal card as the hub. Timer is the only accent.
function VoidUI:Notify(opts)
    opts = opts or {}
    local host = ensureNotifHost()
    local duration = opts.Duration or 3.2
    local accent = opts.Accent or Theme.Accent
    local iconName = opts.Icon

    local card = mk("Frame", {
        BackgroundColor3 = Theme.Bg,
        BackgroundTransparency = 0.04,
        Size = UDim2.fromOffset(260, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        ClipsDescendants = true,
        Parent = host,
    })
    corner(card, Theme.RCard or 8)
    stroke(card, Theme.Stroke, 1, 0.35)
    pad(card, 10, 12, 12, 12)

    local textLeft = 0
    if iconName then
        local ih = makeIcon(card, iconName, 14, Theme.TextDim, 3)
        ih.Position = UDim2.fromOffset(0, 1)
        textLeft = 22
    end

    local title = mk("TextLabel", {
        BackgroundTransparency = 1,
        Font = Fonts.Title,
        TextSize = 13,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Text = opts.Title or "Notification",
        Size = UDim2.new(1, -textLeft, 0, 16),
        Position = UDim2.fromOffset(textLeft, 0),
        ZIndex = 2,
        Parent = card,
    })

    if opts.Content and opts.Content ~= "" then
        mk("TextLabel", {
            BackgroundTransparency = 1,
            Font = Fonts.Desc,
            TextSize = 11,
            TextColor3 = Theme.TextMute,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true,
            Text = opts.Content,
            Size = UDim2.new(1, -textLeft, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Position = UDim2.fromOffset(textLeft, 17),
            ZIndex = 2,
            Parent = card,
        })
    end

    local timerTrack = mk("Frame", {
        BackgroundColor3 = Theme.Divider,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, -12, 1, 11),
        Size = UDim2.new(1, 24, 0, 1),
        ZIndex = 3,
        Parent = card,
    })
    local timer = mk("Frame", {
        BackgroundColor3 = accent,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
        Parent = timerTrack,
    })

    card.Position = UDim2.fromOffset(24, 0)
    card.BackgroundTransparency = 1
    tween(card, TI(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.06,
        Position = UDim2.fromOffset(0, 0),
    })
    tween(timer, TI(duration, Enum.EasingStyle.Linear), { Size = UDim2.new(0, 0, 1, 0) })

    task.delay(duration, function()
        if not card.Parent then return end
        local tw = tween(card, TI(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(18, 0),
        })
        tw.Completed:Wait()
        card:Destroy()
    end)
    return card
end

---------------------------------------------------------------------------
-- CreateWindow
---------------------------------------------------------------------------
function VoidUI:CreateWindow(cfg)
    cfg = cfg or {}
    -- drop previous windows so a failed/partial run doesn't leave a blank shell
    for i = #VoidUI._windows, 1, -1 do
        local w = VoidUI._windows[i]
        pcall(function()
            if w and w.Destroy then w:Destroy() end
        end)
        VoidUI._windows[i] = nil
    end
    -- load lucide pack once (cached) so sidebar icons aren't blank on first paint
    loadIconPack("lucide")

    local accent = cfg.Accent or Theme.Accent
    local title = cfg.Title or "VoidUI"
    local author = cfg.Author or cfg.Subtitle or ""
    local logoIcon = cfg.Icon or "rbxassetid://111627748770819"
    local size = cfg.Size or UDim2.fromOffset(720, 560)
    local toggleKey = cfg.ToggleKey or Enum.KeyCode.RightShift
    local folder = cfg.Folder -- optional config folder name

    -- deep copy theme overrides first (radius tokens live on T)
    local T = {}
    for k, v in pairs(Theme) do T[k] = v end
    T.Accent = accent
    if cfg.Theme and type(cfg.Theme) == "table" then
        for k, v in pairs(cfg.Theme) do T[k] = v end
    end

    local glass = cfg.Transparency
    if glass == nil then
        glass = (cfg.Transparent == false) and 0.02 or 0.06
    end
    glass = math.clamp(tonumber(glass) or 0.06, 0, 0.6)
    local compactOn = cfg.Compact ~= false -- hide per-row Desc (Lumen density)
    local bloomOn = cfg.Bloom == true -- off by default (glow titles = slop)
    local wantOpenBtn = cfg.OpenButton ~= false
    local wantSearch = cfg.Search ~= false
    local rWin = T.RWin or 12
    local rCard = T.RCard or 8
    local rCtrl = T.RCtrl or 8
    local cornerR = cfg.CornerRadius or rWin

    local function styleScroll(sf)
        sf.ScrollBarThickness = 2
        sf.ScrollBarImageColor3 = T.TextMute
        sf.ScrollBarImageTransparency = 0.45
        sf.BorderSizePixel = 0
    end

    local function prettySectionTitle(s)
        s = tostring(s or "")
        if s == "" or s:find("%l") then return s end
        return (s:gsub("%S+", function(w)
            if #w <= 3 then return w end
            return w:sub(1, 1) .. w:sub(2):lower()
        end))
    end

    -- Section header sizing (window default → per-Section override)
    -- Compact by default — 1.7.11's 16/20 was too loud for lucide icons.
    local secHdrCfg = type(cfg.SectionHeader) == "table" and cfg.SectionHeader or {}
    local winSecTitleSize = math.clamp(tonumber(cfg.SectionTitleSize or secHdrCfg.TitleSize) or 13, 11, 22)
    local winSecIconSize = math.clamp(tonumber(cfg.SectionIconSize or secHdrCfg.IconSize) or 14, 12, 28)
    local winSecHdrScale = math.clamp(tonumber(cfg.SectionHeaderScale or secHdrCfg.Scale) or 1, 0.75, 1.75)

    local screen = Instance.new("ScreenGui")
    screen.Name = "VoidUI_" .. tostring(math.random(1000, 9999))
    screen.ResetOnSpawn = false
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.DisplayOrder = 100
    screen.IgnoreGuiInset = true
    protect(screen)

    -- Soft black drop shadow only (no purple window bloom)
    local shadow = mk("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 0.72,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(size.X.Scale, size.X.Offset + 28, size.Y.Scale, size.Y.Offset + 28),
        ZIndex = 0,
        Parent = screen,
    })

    -- Frame + clip (CanvasGroup blanks content on some executors)
    local main = mk("Frame", {
        Name = "Main",
        BackgroundColor3 = T.Bg,
        BackgroundTransparency = glass,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = size,
        ZIndex = 1,
        ClipsDescendants = true,
        Parent = screen,
    })
    corner(main, cornerR)
    stroke(main, T.Stroke, 1, 0.45)

    -- Sidebar
    local sidebarW = 52
    local sidebar = mk("Frame", {
        Name = "Sidebar",
        BackgroundColor3 = T.BgSidebar,
        BackgroundTransparency = math.clamp(glass * 0.55, 0, 0.35),
        Size = UDim2.new(0, sidebarW, 1, 0),
        BorderSizePixel = 0,
        Parent = main,
    })
    mk("Frame", {
        BackgroundColor3 = T.Stroke,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.fromScale(1, 0),
        Size = UDim2.new(0, 1, 1, 0),
        BackgroundTransparency = 0.35,
        Parent = sidebar,
    })

    local logo = mk("Frame", {
        Name = "Logo",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 54),
        Parent = sidebar,
    })
    local logoIsAsset = typeof(logoIcon) == "string" and (logoIcon:find("rbxasset", 1, true) or logoIcon:find("http", 1, true))
    local logoTint = Color3.new(1, 1, 1)
    local logoHolder = makeIcon(logo, logoIcon, logoIsAsset and 28 or 20, logoTint, 2)
    logoHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    logoHolder.Position = UDim2.fromScale(0.5, 0.5)

    local sideNav = mk("ScrollingFrame", {
        Name = "Nav",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(0, 54),
        Size = UDim2.new(1, 0, 1, -54),
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = sidebar,
    })
    list(sideNav, Enum.FillDirection.Vertical, 4, Enum.HorizontalAlignment.Center)
    pad(sideNav, 2, 0, 12, 0)

    -- Content shell (transparent so main corner radius fits clean — no bottom seam)
    local content = mk("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(sidebarW, 0),
        Size = UDim2.new(1, -sidebarW, 1, 0),
        ClipsDescendants = true,
        Parent = main,
    })

    -- Top bar (title + window controls)
    local topBar = mk("Frame", {
        Name = "TopBar",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 56),
        ZIndex = 20,
        Parent = content,
    })
    pad(topBar, 0, 16, 0, 20)

    local titleHost = mk("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(wantSearch and 0.48 or 0.62, 0, 1, 0),
        Parent = topBar,
    })
    local titleWrap = bloomLabel({
        Parent = titleHost,
        Name = "Title",
        Text = title,
        TextSize = 18,
        Font = Fonts.Title,
        Color = T.Text,
        Accent = accent,
        Bloom = bloomOn,
        Height = 24,
    })
    titleWrap.Position = UDim2.fromOffset(0, author ~= "" and 6 or 16)

    if author ~= "" then
        mk("TextLabel", {
            BackgroundTransparency = 1,
            Font = Fonts.Desc,
            TextSize = 12,
            TextColor3 = T.TextMute,
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = author,
            Position = UDim2.fromOffset(0, 32),
            Size = UDim2.new(1, 0, 0, 14),
            Parent = titleHost,
        })
    end

    -- thin hairline under header
    mk("Frame", {
        BackgroundColor3 = T.Stroke,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 20, 1, 0),
        Size = UDim2.new(1, -40, 0, 1),
        Parent = topBar,
    })

    local winBtns = mk("Frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -4, 0.5, 0),
        Size = UDim2.fromOffset(72, 30),
        Parent = topBar,
    })
    list(winBtns, Enum.FillDirection.Horizontal, 8, Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Center)

    -- Search: compact icon → expands into a clean find field
    local searchBox
    local searchHost
    local searchExpanded = false
    local setSearchOpen
    local searchCountLbl
    if wantSearch then
        searchHost = mk("Frame", {
            Name = "SearchHost",
            BackgroundColor3 = T.BgInput,
            BackgroundTransparency = 0,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -88, 0.5, 0),
            Size = UDim2.fromOffset(32, 32),
            ClipsDescendants = true,
            Parent = topBar,
        })
        corner(searchHost, rCtrl)
        local searchStroke = stroke(searchHost, T.Stroke, 1, 0.4)

        local sIconHold = makeIcon(searchHost, "lucide:search", 15, T.TextMute, 3)
        sIconHold.AnchorPoint = Vector2.new(0, 0.5)
        sIconHold.Position = UDim2.new(0, 9, 0.5, 0)
        sIconHold.ZIndex = 3

        searchBox = mk("TextBox", {
            BackgroundTransparency = 1,
            Font = Fonts.Body,
            TextSize = 12,
            TextColor3 = T.Text,
            PlaceholderText = "Find options…",
            PlaceholderColor3 = T.TextMute,
            Text = "",
            ClearTextOnFocus = false,
            Visible = false,
            Position = UDim2.fromOffset(32, 0),
            Size = UDim2.new(1, -58, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 3,
            Parent = searchHost,
        })

        local clearBtn = mk("TextButton", {
            BackgroundTransparency = 1,
            Text = "",
            Visible = false,
            AutoButtonColor = false,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -6, 0.5, 0),
            Size = UDim2.fromOffset(22, 22),
            ZIndex = 4,
            Parent = searchHost,
        })
        local clearIcon = makeIcon(clearBtn, "lucide:x", 12, T.TextMute, 5)
        clearIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        clearIcon.Position = UDim2.fromScale(0.5, 0.5)

        searchCountLbl = mk("TextLabel", {
            BackgroundTransparency = 1,
            Font = Fonts.Body,
            TextSize = 10,
            TextColor3 = T.TextMute,
            Text = "",
            Visible = false,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -28, 0.5, 0),
            Size = UDim2.fromOffset(28, 14),
            TextXAlignment = Enum.TextXAlignment.Right,
            ZIndex = 4,
            Parent = searchHost,
        })

        local hitOpen = mk("TextButton", {
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
            Size = UDim2.fromScale(1, 1),
            ZIndex = 2,
            Parent = searchHost,
        })

        setSearchOpen = function(on, focus)
            searchExpanded = on
            hitOpen.Visible = not on
            if on then
                tween(searchHost, TI(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Size = UDim2.fromOffset(220, 32),
                })
                searchStroke.Color = T.Stroke
                searchStroke.Transparency = 0.15
                searchBox.Visible = true
                clearBtn.Visible = true
                if focus then
                    task.defer(function()
                        searchBox:CaptureFocus()
                    end)
                end
            else
                searchBox.Text = ""
                searchCountLbl.Visible = false
                searchCountLbl.Text = ""
                searchBox.Visible = false
                clearBtn.Visible = false
                tween(searchHost, TI(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Size = UDim2.fromOffset(32, 32),
                })
                searchStroke.Color = T.Stroke
                searchStroke.Transparency = 0.4
            end
        end

        hitOpen.MouseButton1Click:Connect(function()
            setSearchOpen(true, true)
        end)

        searchBox.Focused:Connect(function()
            searchStroke.Transparency = 0.1
        end)
        searchBox.FocusLost:Connect(function()
            if searchBox.Text == "" then
                setSearchOpen(false, false)
            else
                searchStroke.Transparency = 0.15
            end
        end)
        clearBtn.MouseButton1Click:Connect(function()
            searchBox.Text = ""
            setSearchOpen(false, false)
        end)
    end

    local function winBtn(iconName, cb)
        local b = mk("TextButton", {
            BackgroundColor3 = T.BgInput,
            BackgroundTransparency = 0.15,
            Text = "",
            Size = UDim2.fromOffset(28, 28),
            AutoButtonColor = false,
            Parent = winBtns,
        })
        corner(b, rCtrl)
        local h, img = makeIcon(b, iconName, 14, T.TextDim, 2)
        h.AnchorPoint = Vector2.new(0.5, 0.5)
        h.Position = UDim2.fromScale(0.5, 0.5)
        hover(b, function()
            tween(b, TI(0.12), { BackgroundColor3 = T.BgHover })
            setIconColor(img, T.Text)
        end, function()
            tween(b, TI(0.12), { BackgroundColor3 = T.BgInput })
            setIconColor(img, T.TextDim)
        end)
        b.MouseButton1Click:Connect(cb)
        return b
    end

    -- Horizontal subtabs strip
    local subTabBar = mk("Frame", {
        Name = "SubTabs",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 56),
        Size = UDim2.new(1, 0, 0, 36),
        Visible = false,
        Parent = content,
    })
    pad(subTabBar, 0, 16, 0, 16)
    local subTabList = mk("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Parent = subTabBar,
    })
    list(subTabList, Enum.FillDirection.Horizontal, 6, Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Center)

    -- Pages host
    local pages = mk("Frame", {
        Name = "Pages",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 56),
        Size = UDim2.new(1, 0, 1, -56),
        ClipsDescendants = true,
        Parent = content,
    })

    ---------------------------------------------------------------------------
    -- Drag
    ---------------------------------------------------------------------------
    local dragging, dragStart, startPos
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            local np = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            main.Position = np
            shadow.Position = np
        end
    end)

    ---------------------------------------------------------------------------
    -- Window API
    ---------------------------------------------------------------------------
    local Window = {
        ScreenGui = screen,
        Main = main,
        Theme = T,
        Accent = accent,
        SectionHeader = {
            TitleSize = winSecTitleSize,
            IconSize = winSecIconSize,
            Scale = winSecHdrScale,
        },
        _tabs = {},
        _activeTab = nil,
        _flags = {},
        _searchEntries = {},
        _searchQuery = "",
        Visible = true,
        _openBtn = nil,
    }

    -- Search = command palette: results drop down as a list; click jumps there
    local searchPanel

    local function closeSearchPanel()
        if searchPanel then
            searchPanel:Destroy()
            searchPanel = nil
        end
    end

    local function navigateTo(e)
        closeSearchPanel()
        if setSearchOpen then setSearchOpen(false, false) end
        Window:SetVisible(true)
        if e.Tab then Window:SelectTab(e.Tab) end
        if e.Tab and e.Page and e.Tab.SelectPage then e.Tab:SelectPage(e.Page) end
        -- scroll to the row + flash it after layout settles
        task.defer(function()
            task.wait(0.05)
            local frame = e.Page and e.Page.Frame
            local row = e.Row
            if not (frame and row and row.Parent) then return end
            local y = row.AbsolutePosition.Y - frame.AbsolutePosition.Y + frame.CanvasPosition.Y - 64
            frame.CanvasPosition = Vector2.new(0, math.max(0, y))
            local flash = mk("Frame", {
                BackgroundColor3 = T.BgHover,
                BackgroundTransparency = 0.35,
                Size = UDim2.fromScale(1, 1),
                ZIndex = 5,
                Parent = row,
            })
            corner(flash, 10)
            task.delay(0.35, function()
                if flash.Parent then
                    local tw = tween(flash, TI(0.8), { BackgroundTransparency = 1 })
                    tw.Completed:Wait()
                    flash:Destroy()
                end
            end)
        end)
    end

    local function applySearch(query)
        query = string.lower(tostring(query or "")):gsub("^%s+", ""):gsub("%s+$", "")
        Window._searchQuery = query
        closeSearchPanel()

        if query == "" then
            if searchCountLbl then
                searchCountLbl.Text = ""
                searchCountLbl.Visible = false
            end
            return
        end

        local matches = {}
        for _, e in ipairs(Window._searchEntries) do
            if e.Row and e.Row.Parent and e.Text ~= "" and string.find(e.Text, query, 1, true) then
                matches[#matches + 1] = e
                if #matches >= 30 then break end
            end
        end

        if searchCountLbl then
            searchCountLbl.Text = tostring(#matches)
            searchCountLbl.Visible = true
        end

        if not searchHost then return end

        local itemH = 44
        local gap = 2
        local padV = 6
        local shown = math.min(#matches, 6)
        local listH = (shown == 0) and 36 or (shown * itemH + math.max(0, shown - 1) * gap)
        local panelW = 280
        local panelH = listH + padV * 2

        -- Parent under content + delta AbsolutePosition — avoids GuiInset mismatch
        -- that was shoving the panel up over the search input.
        searchPanel = mk("Frame", {
            Name = "SearchResults",
            BackgroundColor3 = T.BgSection,
            BorderSizePixel = 0,
            Size = UDim2.fromOffset(panelW, panelH),
            ZIndex = 5,
            Parent = content,
        })
        corner(searchPanel, rCard)
        stroke(searchPanel, T.Stroke, 1, 0.35)
        pad(searchPanel, padV, 6, padV, 6)

        local function placePanel()
            if not (searchPanel and searchPanel.Parent and searchHost.Parent) then return end
            local hp = searchHost.AbsolutePosition
            local hs = searchHost.AbsoluteSize
            local cp = content.AbsolutePosition
            local cs = content.AbsoluteSize
            local x = hp.X - cp.X + hs.X - panelW
            local y = hp.Y - cp.Y + hs.Y + 8
            -- keep inside content bounds
            x = math.clamp(x, 8, math.max(8, cs.X - panelW - 8))
            -- never cover the search input / top bar
            y = math.max(y, 60)
            y = math.clamp(y, 60, math.max(60, cs.Y - panelH - 8))
            searchPanel.Position = UDim2.fromOffset(x, y)
        end
        placePanel()
        task.defer(placePanel)

        if #matches == 0 then
            mk("TextLabel", {
                BackgroundTransparency = 1,
                Font = Fonts.Body,
                TextSize = 12,
                TextColor3 = T.TextMute,
                Text = "No results",
                Size = UDim2.fromScale(1, 1),
                ZIndex = 81,
                Parent = searchPanel,
            })
            return
        end

        local host = mk("ScrollingFrame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.fromScale(1, 1),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = T.TextMute,
            ScrollBarImageTransparency = 0.4,
            CanvasSize = UDim2.fromOffset(0, #matches * itemH + math.max(0, #matches - 1) * gap),
            ScrollingEnabled = #matches > shown,
            ZIndex = 81,
            Parent = searchPanel,
        })
        styleScroll(host)
        list(host, Enum.FillDirection.Vertical, gap)

        for _, e in ipairs(matches) do
            local item = mk("TextButton", {
                BackgroundColor3 = T.BgHover,
                BackgroundTransparency = 1,
                AutoButtonColor = false,
                Text = "",
                Size = UDim2.new(1, 0, 0, itemH),
                ZIndex = 82,
                Parent = host,
            })
            corner(item, 10)

            local ic = makeIcon(item, "lucide:corner-down-right", 13, T.TextMute, 83)
            ic.AnchorPoint = Vector2.new(0, 0.5)
            ic.Position = UDim2.new(0, 10, 0.5, 0)

            mk("TextLabel", {
                BackgroundTransparency = 1,
                Font = Fonts.Title,
                TextSize = 13,
                TextColor3 = T.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Text = e.Title,
                Position = UDim2.fromOffset(32, 6),
                Size = UDim2.new(1, -40, 0, 16),
                ZIndex = 83,
                Parent = item,
            })
            mk("TextLabel", {
                BackgroundTransparency = 1,
                Font = Fonts.Desc,
                TextSize = 11,
                TextColor3 = T.TextMute,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Text = e.TabTitle .. "  ·  " .. e.Section,
                Position = UDim2.fromOffset(32, 23),
                Size = UDim2.new(1, -40, 0, 14),
                ZIndex = 83,
                Parent = item,
            })

            item.MouseEnter:Connect(function()
                tween(item, TI(0.1), { BackgroundTransparency = 0.4 })
            end)
            item.MouseLeave:Connect(function()
                tween(item, TI(0.1), { BackgroundTransparency = 1 })
            end)
            item.MouseButton1Click:Connect(function()
                navigateTo(e)
            end)
        end
    end

    function Window:Search(query)
        query = tostring(query or "")
        if searchBox then
            if query ~= "" and setSearchOpen then
                setSearchOpen(true, false)
            end
            searchBox.Text = query
        end
        applySearch(query)
    end

    if searchBox then
        searchBox:GetPropertyChangedSignal("Text"):Connect(function()
            applySearch(searchBox.Text)
        end)
        -- dragging the window would leave the panel floating at a stale spot
        topBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                closeSearchPanel()
            end
        end)
        -- / or Ctrl+F opens find
        UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if UserInputService:GetFocusedTextBox() then return end
            local open = false
            if input.KeyCode == Enum.KeyCode.Slash then
                open = true
            elseif input.KeyCode == Enum.KeyCode.F and (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)) then
                open = true
            end
            if open and setSearchOpen then
                setSearchOpen(true, true)
            end
        end)
    end

    local function setPagesOffset(hasSub)
        if hasSub then
            subTabBar.Visible = true
            pages.Position = UDim2.fromOffset(0, 92)
            pages.Size = UDim2.new(1, 0, 1, -92)
        else
            subTabBar.Visible = false
            pages.Position = UDim2.fromOffset(0, 56)
            pages.Size = UDim2.new(1, 0, 1, -56)
        end
    end

    function Window:SetVisible(v)
        self.Visible = v and true or false
        main.Visible = self.Visible
        shadow.Visible = self.Visible
        if not self.Visible then
            closeSearchPanel()
            if setSearchOpen then setSearchOpen(false, false) end
        end
        if self._openBtn then
            self._openBtn.Visible = true
            if self._styleOpenOrb then
                self._styleOpenOrb(self.Visible)
            end
        end
    end

    function Window:Toggle()
        self:SetVisible(not self.Visible)
    end

    function Window:SetTransparency(amount)
        amount = math.clamp(tonumber(amount) or glass, 0, 0.6)
        glass = amount
        main.BackgroundTransparency = amount
        sidebar.BackgroundTransparency = math.clamp(amount * 0.55, 0, 0.35)
    end

    function Window:Destroy()
        screen:Destroy()
        for i, w in ipairs(VoidUI._windows) do
            if w == self then
                table.remove(VoidUI._windows, i)
                break
            end
        end
    end

    function Window:SelectTab(tab)
        if not tab then return end
        for _, t in ipairs(self._tabs) do
            t:_setActive(t == tab)
        end
        self._activeTab = tab
        -- rebuild subtabs
        for _, c in ipairs(subTabList:GetChildren()) do
            if c:IsA("GuiObject") then c:Destroy() end
        end
        local hasSub = #tab._pages > 1
        setPagesOffset(hasSub)
        if hasSub then
            for _, page in ipairs(tab._pages) do
                local btn = mk("TextButton", {
                    BackgroundColor3 = T.BgHover,
                    BackgroundTransparency = page._active and 0 or 1,
                    AutoButtonColor = false,
                    Font = Fonts.Body,
                    TextSize = 12,
                    Text = page.Title,
                    TextColor3 = page._active and T.Text or T.TextMute,
                    Size = UDim2.fromOffset(0, 26),
                    AutomaticSize = Enum.AutomaticSize.X,
                    Parent = subTabList,
                })
                corner(btn, rCtrl)
                pad(btn, 0, 12, 0, 12)
                btn.MouseEnter:Connect(function()
                    if not page._active then
                        tween(btn, TI(0.1), { BackgroundTransparency = 0.55 })
                    end
                end)
                btn.MouseLeave:Connect(function()
                    if not page._active then
                        tween(btn, TI(0.1), { BackgroundTransparency = 1 })
                    end
                end)
                btn.MouseButton1Click:Connect(function()
                    tab:SelectPage(page)
                end)
                page._subBtn = btn
                page._under = nil
            end
        end
        if tab._activePage then
            tab:SelectPage(tab._activePage)
        elseif tab._pages[1] then
            tab:SelectPage(tab._pages[1])
        end
    end

    winBtn("lucide:minus", function()
        Window:SetVisible(false)
        VoidUI:Notify({ Title = title, Content = "Hidden — tap the float icon or toggle key", Duration = 2 })
    end)
    winBtn("lucide:x", function()
        Window:Destroy()
    end)

    -- Toggle key (mutable — Keybind can rebind via Window:SetToggleKey)
    local toggleKeyState = toggleKey
    function Window:SetToggleKey(key)
        if typeof(key) == "EnumItem" then
            toggleKeyState = key
        end
    end
    function Window:GetToggleKey()
        return toggleKeyState
    end

    UserInputService.InputBegan:Connect(function(input, gp)
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        if input.KeyCode ~= toggleKeyState then return end
        if UserInputService:GetFocusedTextBox() then return end
        Window:Toggle()
    end)

    -- Floating open button — matte circle, no glow/wash
    if wantOpenBtn then
        local obWrap = mk("Frame", {
            Name = "OpenOrb",
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0, 1),
            Position = UDim2.new(0, 18, 1, -18),
            Size = UDim2.fromOffset(48, 48),
            ZIndex = 50,
            Parent = screen,
        })

        local glow = mk("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 0, 0),
            Parent = obWrap,
        })

        local ob = mk("TextButton", {
            Name = "OpenButton",
            BackgroundColor3 = T.Bg,
            BackgroundTransparency = 0.04,
            Text = "",
            AutoButtonColor = false,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(44, 44),
            ZIndex = 51,
            Parent = obWrap,
        })
        corner(ob, 22)
        local obStroke = stroke(ob, T.Stroke, 1, 0.3)

        local wash = mk("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 0, 0),
            Parent = ob,
        })

        local oh = makeIcon(ob, logoIsAsset and logoIcon or "lucide:layout-dashboard", logoIsAsset and 22 or 18, Color3.new(1, 1, 1), 52)
        oh.AnchorPoint = Vector2.new(0.5, 0.5)
        oh.Position = UDim2.fromScale(0.5, 0.5)

        local function styleOpenOrb(uiVisible)
            if uiVisible then
                tween(ob, TI(0.15), { BackgroundTransparency = 0.2, BackgroundColor3 = T.Bg })
                obStroke.Transparency = 0.5
            else
                tween(ob, TI(0.15), { BackgroundTransparency = 0.02, BackgroundColor3 = T.BgSection })
                obStroke.Transparency = 0.25
            end
        end

        hover(ob, function()
            tween(ob, TI(0.12), { Size = UDim2.fromOffset(46, 46) })
        end, function()
            tween(ob, TI(0.12), { Size = UDim2.fromOffset(44, 44) })
            styleOpenOrb(Window.Visible)
        end)

        -- drag whole wrap
        local draggingOb, d0, p0
        ob.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingOb = true
                d0 = input.Position
                p0 = obWrap.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        draggingOb = false
                    end
                end)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if draggingOb and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local d = input.Position - d0
                obWrap.Position = UDim2.new(p0.X.Scale, p0.X.Offset + d.X, p0.Y.Scale, p0.Y.Offset + d.Y)
            end
        end)

        local moved = false
        ob.InputChanged:Connect(function(input)
            if draggingOb and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                if (input.Position - d0).Magnitude > 6 then moved = true end
            end
        end)
        ob.MouseButton1Click:Connect(function()
            if moved then moved = false return end
            Window:Toggle()
        end)

        Window._openBtn = obWrap
        Window._styleOpenOrb = styleOpenOrb
        styleOpenOrb(true)
    end

    ---------------------------------------------------------------------------
    -- Tab (sidebar entry)
    ---------------------------------------------------------------------------
    function Window:Tab(opts)
        opts = opts or {}
        local tabTitle = opts.Title or "Tab"
        local tabIcon = opts.Icon or "lucide:house"
        local selected = opts.Selected

        local btn = mk("TextButton", {
            Name = "Tab_" .. tabTitle,
            BackgroundTransparency = 1,
            Text = "",
            Size = UDim2.fromOffset(40, 40),
            AutoButtonColor = false,
            Parent = sideNav,
        })

        local indicator = mk("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 0, 0),
            Parent = btn,
        })

        local iconBg = mk("Frame", {
            BackgroundColor3 = T.BgHover,
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(32, 32),
            Parent = btn,
        })
        corner(iconBg, 16)

        local iconHolder, iconLbl = makeIcon(iconBg, tabIcon, 18, T.TextDim, 2)
        iconHolder.AnchorPoint = Vector2.new(0.5, 0.5)
        iconHolder.Position = UDim2.fromScale(0.5, 0.5)

        -- sidebar tooltip (tab name)
        local tip
        local function hideTip()
            if tip then tip:Destroy() tip = nil end
        end
        local function showTip()
            hideTip()
            local abs = btn.AbsolutePosition
            local sz = btn.AbsoluteSize
            local inset = GuiService:GetGuiInset()
            local x = abs.X + sz.X + 10 + (screen.IgnoreGuiInset and inset.X or 0)
            local y = abs.Y + sz.Y * 0.5 + (screen.IgnoreGuiInset and inset.Y or 0)
            tip = mk("Frame", {
                Name = "TabTip",
                BackgroundColor3 = T.BgSection,
                BorderSizePixel = 0,
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.fromOffset(x, y),
                AutomaticSize = Enum.AutomaticSize.XY,
                ZIndex = 900,
                Parent = screen,
            })
            corner(tip, rCtrl)
            stroke(tip, T.Stroke, 1, 0.35)
            pad(tip, 4, 8, 4, 8)
            mk("TextLabel", {
                BackgroundTransparency = 1,
                Font = Fonts.Body,
                TextSize = 11,
                TextColor3 = T.Text,
                Text = tabTitle,
                AutomaticSize = Enum.AutomaticSize.XY,
                ZIndex = 901,
                Parent = tip,
            })
        end

        local pageHost = mk("Frame", {
            Name = "TabHost_" .. tabTitle,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Visible = false,
            Parent = pages,
        })

        local Tab = {
            Title = tabTitle,
            Button = btn,
            Host = pageHost,
            _pages = {},
            _activePage = nil,
            _window = Window,
        }

        local darkIcon = Color3.new(1, 1, 1)
        function Tab:_setActive(on)
            pageHost.Visible = on
            if on then
                tween(iconBg, TI(0.15), { BackgroundTransparency = 0.35, BackgroundColor3 = accent })
                if iconLbl then
                    tween(iconLbl, TI(0.15), { ImageColor3 = Color3.new(1, 1, 1) })
                end
            else
                tween(iconBg, TI(0.15), { BackgroundTransparency = 1 })
                if iconLbl then
                    tween(iconLbl, TI(0.15), { ImageColor3 = T.TextDim })
                end
            end
        end

        btn.MouseEnter:Connect(function()
            showTip()
            if not pageHost.Visible then
                tween(iconBg, TI(0.12), { BackgroundColor3 = T.BgHover, BackgroundTransparency = 0.25 })
            end
        end)
        btn.MouseLeave:Connect(function()
            hideTip()
            if not pageHost.Visible then
                tween(iconBg, TI(0.12), { BackgroundTransparency = 1 })
            end
        end)

        function Tab:SelectPage(page)
            for _, p in ipairs(self._pages) do
                p.Frame.Visible = (p == page)
                p._active = (p == page)
                if p._subBtn then
                    p._subBtn.TextColor3 = p._active and T.Text or T.TextMute
                    p._subBtn.BackgroundTransparency = p._active and 0 or 1
                end
            end
            self._activePage = page
        end

        ---------------------------------------------------------------------------
        -- Page (horizontal sub-tab) — if only one, no subtab UI
        ---------------------------------------------------------------------------
        function Tab:Page(popts)
            popts = popts or {}
            local pageTitle = popts.Title or tabTitle

            local frame = mk("ScrollingFrame", {
                Name = "Page_" .. pageTitle,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2.fromScale(1, 1),
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.None,
                Visible = false,
                Parent = pageHost,
            })
            styleScroll(frame)
            -- two-column optional layout container
            local body = mk("Frame", {
                Name = "Body",
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(14, 8),
                Size = UDim2.new(1, -28, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = frame,
            })
            local function updateCanvas()
                frame.CanvasSize = UDim2.fromOffset(0, 12 + body.AbsoluteSize.Y + 48)
            end
            body:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateCanvas)
            task.defer(updateCanvas)

            local columns = popts.Columns or 1
            local colFrames = {}
            if columns >= 2 then
                local row = mk("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Parent = body,
                })
                local layout = Instance.new("UIListLayout")
                layout.FillDirection = Enum.FillDirection.Horizontal
                layout.Padding = UDim.new(0, 12)
                layout.SortOrder = Enum.SortOrder.LayoutOrder
                layout.Parent = row
                for i = 1, columns do
                    local col = mk("Frame", {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1 / columns, -6, 0, 0),
                        AutomaticSize = Enum.AutomaticSize.Y,
                        LayoutOrder = i,
                        Parent = row,
                    })
                    list(col, Enum.FillDirection.Vertical, 10)
                    colFrames[i] = col
                end
            else
                list(body, Enum.FillDirection.Vertical, 10)
                colFrames[1] = body
            end

            local Page = {
                Title = pageTitle,
                Frame = frame,
                Body = body,
                _active = false,
                _columns = colFrames,
            }

            function Page:Section(sopts)
                sopts = sopts or {}
                local colIndex = sopts.Column or 1
                local parentCol = colFrames[colIndex] or colFrames[1]
                local secTitle = prettySectionTitle(sopts.Title or "Section")
                local secIcon = normalizeAsset(sopts.Icon or sopts.Image)

                local wrap = mk("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Parent = parentCol,
                })
                list(wrap, Enum.FillDirection.Vertical, 6)

                -- Section header size: Section opts > Window SectionHeader > defaults (14 / 15)
                local hdrScale = math.clamp(tonumber(sopts.HeaderScale or sopts.Scale) or winSecHdrScale, 0.75, 1.75)
                local titleSize = math.clamp(
                    math.floor((tonumber(sopts.TitleSize) or winSecTitleSize) * hdrScale + 0.5),
                    11, 22
                )
                local iconSize = math.clamp(
                    math.floor((tonumber(sopts.IconSize) or winSecIconSize) * hdrScale + 0.5),
                    12, 28
                )
                local labelH = titleSize + 4
                local headH = math.max(labelH + 2, iconSize + 6, 20)

                local headRow = mk("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, headH),
                    Parent = wrap,
                })
                local titleX = 0
                if secIcon then
                    local iconCol = (type(secIcon) == "string" and secIcon:find("rbxassetid", 1, true))
                        and Color3.new(1, 1, 1) or T.TextDim
                    local ih = makeIcon(headRow, secIcon, iconSize, iconCol, 2)
                    ih.AnchorPoint = Vector2.new(0, 0.5)
                    ih.Position = UDim2.new(0, 0, 0.5, 0)
                    titleX = iconSize + 8
                end
                bloomLabel({
                    Parent = headRow,
                    Name = "SectionTitle",
                    Text = secTitle,
                    TextSize = titleSize,
                    Font = Fonts.Body,
                    Color = T.TextDim,
                    Accent = accent,
                    Bloom = bloomOn,
                    Height = labelH,
                    Position = UDim2.fromOffset(titleX, math.floor((headH - labelH) / 2)),
                    Size = UDim2.new(1, -titleX, 0, labelH),
                })

                local card = mk("Frame", {
                    BackgroundColor3 = T.BgSection,
                    BackgroundTransparency = math.clamp(glass * 0.15, 0, 0.1),
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Parent = wrap,
                })
                corner(card, rCard)
                stroke(card, T.Stroke, 1, 0.42)
                pad(card, 4, 4, 4, 4)
                list(card, Enum.FillDirection.Vertical, 0)

                local Section = { Frame = card, Title = secTitle }
                local rowOrder = 0

                -- No hairline between rows — padding separates (Callisto/Lumen)
                local function addDivider()
                end

                local function registerSearch(row, titleText, descText)
                    table.insert(Window._searchEntries, {
                        Row = row,
                        Tab = Tab,
                        Page = Page,
                        Title = tostring(titleText or ""),
                        Section = tostring(secTitle or ""),
                        TabTitle = tostring(tabTitle or ""),
                        Text = string.lower(table.concat({
                            tostring(titleText or ""),
                            " ",
                            tostring(descText or ""),
                            " ",
                            tostring(secTitle or ""),
                            " ",
                            tostring(tabTitle or ""),
                        })),
                    })
                end

                -- base row: title left + control right. Compact hides Desc.
                local function makeRow(titleText, descText, iconSpec)
                    if compactOn then descText = nil end
                    addDivider()
                    rowOrder = rowOrder + 1
                    local row = mk("Frame", {
                        BackgroundColor3 = T.BgSection,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 0),
                        AutomaticSize = Enum.AutomaticSize.Y,
                        LayoutOrder = rowOrder,
                        Active = true,
                        Parent = card,
                    })
                    row:SetAttribute("_bt", 1)
                    pad(row, 8, 10, 8, 10)

                    local hitBg = mk("Frame", {
                        BackgroundColor3 = T.BgHover,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 1, 0),
                        ZIndex = 0,
                        Parent = row,
                    })
                    corner(hitBg, rCtrl)
                    row.MouseEnter:Connect(function()
                        tween(hitBg, TI(0.1), { BackgroundTransparency = 0.88 })
                    end)
                    row.MouseLeave:Connect(function()
                        tween(hitBg, TI(0.1), { BackgroundTransparency = 1 })
                    end)

                    local left = mk("Frame", {
                        BackgroundTransparency = 1,
                        Position = UDim2.fromOffset(0, 0),
                        Size = UDim2.new(1, -112, 0, 0),
                        AutomaticSize = Enum.AutomaticSize.Y,
                        Parent = row,
                    })
                    list(left, Enum.FillDirection.Vertical, 1)

                    mk("TextLabel", {
                        BackgroundTransparency = 1,
                        Font = Fonts.Title,
                        TextSize = 14,
                        TextColor3 = T.Text,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Text = titleText or "",
                        Size = UDim2.new(1, 0, 0, 18),
                        Parent = left,
                    })

                    if descText and descText ~= "" then
                        mk("TextLabel", {
                            BackgroundTransparency = 1,
                            Font = Fonts.Desc,
                            TextSize = 12,
                            TextColor3 = T.TextMute,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            TextWrapped = true,
                            Text = descText,
                            Size = UDim2.new(1, 0, 0, 0),
                            AutomaticSize = Enum.AutomaticSize.Y,
                            Parent = left,
                        })
                    end

                    local right = mk("Frame", {
                        BackgroundTransparency = 1,
                        AnchorPoint = Vector2.new(1, 0.5),
                        Position = UDim2.new(1, 0, 0.5, 0),
                        Size = UDim2.fromOffset(110, 28),
                        Parent = row,
                    })
                    registerSearch(row, titleText, descText)
                    return row, left, right
                end

                -----------------------------------------------------------------
                -- Toggle
                -----------------------------------------------------------------
                function Section:Toggle(o)
                    o = o or {}
                    local value = o.Value and true or false
                    local row, _, right = makeRow(o.Title or "Toggle", o.Desc, o.Icon or o.Image)

                    right.Size = UDim2.fromOffset(50, 28)
                    local track = mk("Frame", {
                        BackgroundColor3 = value and accent or T.BgToggleOff,
                        Size = UDim2.fromScale(1, 1),
                        Parent = right,
                    })
                    corner(track, 14)
                    local knob = mk("Frame", {
                        BackgroundColor3 = Color3.new(1, 1, 1),
                        Size = UDim2.fromOffset(24, 24),
                        Position = value and UDim2.new(1, -27, 0.5, -12) or UDim2.new(0, 3, 0.5, -12),
                        Parent = track,
                    })
                    corner(knob, 12)

                    local hit = mk("TextButton", {
                        BackgroundTransparency = 1,
                        Text = "",
                        Size = UDim2.fromScale(1, 1),
                        Parent = track,
                    })

                    local api = {
                        Value = value,
                        Row = row,
                        Set = function(self, v, silent)
                            self.Value = v and true or false
                            local on = self.Value
                            local col = on and accent or T.BgToggleOff
                            local pos = on and UDim2.new(1, -27, 0.5, -12) or UDim2.new(0, 3, 0.5, -12)
                            -- apply immediately so remote/silent Set never leaves stale visuals
                            pcall(function()
                                track.BackgroundColor3 = col
                                knob.Position = pos
                            end)
                            pcall(function()
                                tween(track, TI(0.18), { BackgroundColor3 = col })
                                tween(knob, TI(0.18, Enum.EasingStyle.Quart), { Position = pos })
                            end)
                            if not silent and o.Callback then
                                task.spawn(o.Callback, self.Value)
                            end
                        end,
                        SetVisible = function(self, vis)
                            if row then row.Visible = vis and true or false end
                        end,
                    }

                    hit.MouseButton1Click:Connect(function()
                        api:Set(not api.Value)
                    end)

                    if o.Flag then Window._flags[o.Flag] = api end
                    return api
                end

                -----------------------------------------------------------------
                -- Slider
                -----------------------------------------------------------------
                function Section:Slider(o)
                    o = o or {}
                    local min, max = o.Min or 0, o.Max or 100
                    local value = math.clamp(o.Value or min, min, max)
                    local suffix = o.Suffix or ""
                    local decimals = o.Decimals or 0

                    addDivider()
                    rowOrder = rowOrder + 1
                    local row = mk("Frame", {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 0),
                        AutomaticSize = Enum.AutomaticSize.Y,
                        LayoutOrder = rowOrder,
                        Parent = card,
                    })
                    pad(row, 8, 8, 8, 10)
                    list(row, Enum.FillDirection.Vertical, 6)
                    registerSearch(row, o.Title or "Slider", o.Desc)

                    local top = mk("Frame", {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 20),
                        LayoutOrder = 1,
                        Parent = row,
                    })
                    local sliderTitleX = 0
                    mk("TextLabel", {
                        BackgroundTransparency = 1,
                        Font = Fonts.Title,
                        TextSize = 14,
                        TextColor3 = T.Text,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Text = o.Title or "Slider",
                        Position = UDim2.fromOffset(0, 0),
                        Size = UDim2.new(1, -78, 1, 0),
                        Parent = top,
                    })
                    local function fmt(v)
                        return (decimals > 0 and string.format("%." .. decimals .. "f", v) or tostring(math.floor(v + 0.5)))
                    end
                    local valBox = mk("TextBox", {
                        BackgroundColor3 = T.BgInput,
                        Font = Fonts.Title,
                        TextSize = 12,
                        TextColor3 = T.Text,
                        Text = fmt(value),
                        ClearTextOnFocus = false,
                        TextXAlignment = Enum.TextXAlignment.Center,
                        AnchorPoint = Vector2.new(1, 0.5),
                        Position = UDim2.new(1, 0, 0.5, 0),
                        Size = UDim2.fromOffset(56, 22),
                        Parent = top,
                    })
                    corner(valBox, rCtrl)
                    stroke(valBox, T.Stroke, 1, 0.4)
                    if suffix ~= "" then
                        mk("TextLabel", {
                            BackgroundTransparency = 1,
                            Font = Fonts.Desc,
                            TextSize = 10,
                            TextColor3 = T.TextMute,
                            Text = suffix,
                            AnchorPoint = Vector2.new(1, 0.5),
                            Position = UDim2.new(1, -68, 0.5, 0),
                            Size = UDim2.fromOffset(20, 14),
                            TextXAlignment = Enum.TextXAlignment.Right,
                            Parent = top,
                        })
                        valBox.Position = UDim2.new(1, 0, 0.5, 0)
                        valBox.Size = UDim2.fromOffset(56, 22)
                    end

                    if not compactOn and o.Desc and o.Desc ~= "" then
                        mk("TextLabel", {
                            BackgroundTransparency = 1,
                            Font = Fonts.Desc,
                            TextSize = 13,
                            TextColor3 = T.TextMute,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            TextYAlignment = Enum.TextYAlignment.Top,
                            TextWrapped = true,
                            Text = o.Desc,
                            Size = UDim2.new(1, 0, 0, 0),
                            AutomaticSize = Enum.AutomaticSize.Y,
                            LayoutOrder = 2,
                            Parent = row,
                        })
                    end

                    local trackWrap = mk("Frame", {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 18),
                        LayoutOrder = 3,
                        Parent = row,
                    })
                    local track = mk("Frame", {
                        BackgroundColor3 = T.BgToggleOff,
                        AnchorPoint = Vector2.new(0, 0.5),
                        Position = UDim2.new(0, 0, 0.5, 0),
                        Size = UDim2.new(1, 0, 0, 4),
                        Parent = trackWrap,
                    })
                    corner(track, 2)
                    local fill = mk("Frame", {
                        BackgroundColor3 = accent,
                        Size = UDim2.new((value - min) / math.max(max - min, 1e-6), 0, 1, 0),
                        Parent = track,
                    })
                    corner(fill, 2)
                    local knob = mk("Frame", {
                        BackgroundColor3 = Color3.new(1, 1, 1),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.new((value - min) / math.max(max - min, 1e-6), 0, 0.5, 0),
                        Size = UDim2.fromOffset(12, 12),
                        ZIndex = 3,
                        Parent = track,
                    })
                    corner(knob, 6)
                    stroke(knob, T.Stroke, 1, 0.35)

                    local sliding = false
                    local api = { Value = value }

                    local function applyVisual(raw)
                        local p = (raw - min) / math.max(max - min, 1e-6)
                        fill.Size = UDim2.new(p, 0, 1, 0)
                        knob.Position = UDim2.new(p, 0, 0.5, 0)
                        if not valBox:IsFocused() then
                            valBox.Text = fmt(raw)
                        end
                    end

                    local function setFromX(x, silent)
                        local rel = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
                        local raw = min + rel * (max - min)
                        if decimals <= 0 then
                            raw = math.floor(raw + 0.5)
                        else
                            local m = 10 ^ decimals
                            raw = math.floor(raw * m + 0.5) / m
                        end
                        api.Value = raw
                        applyVisual(raw)
                        if not silent and o.Callback then
                            task.spawn(o.Callback, raw)
                        end
                    end

                    function api:Set(v, silent)
                        v = math.clamp(tonumber(v) or min, min, max)
                        if decimals <= 0 then
                            v = math.floor(v + 0.5)
                        else
                            local m = 10 ^ decimals
                            v = math.floor(v * m + 0.5) / m
                        end
                        self.Value = v
                        applyVisual(v)
                        if not silent and o.Callback then task.spawn(o.Callback, v) end
                    end

                    valBox.FocusLost:Connect(function()
                        local n = tonumber(valBox.Text)
                        if n then
                            api:Set(n)
                        else
                            valBox.Text = fmt(api.Value)
                        end
                    end)

                    track.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            sliding = true
                            setFromX(input.Position.X)
                        end
                    end)
                    UserInputService.InputChanged:Connect(function(input)
                        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                            setFromX(input.Position.X)
                        end
                    end)
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            sliding = false
                        end
                    end)

                    if o.Flag then Window._flags[o.Flag] = api end
                    return api
                end

                -----------------------------------------------------------------
                -- Dropdown
                -----------------------------------------------------------------
                function Section:Dropdown(o)
                    o = o or {}
                    local values = o.Values or { "Option 1" }
                    local multi = o.Multi == true
                    local current = o.Value
                    if multi then
                        if type(current) ~= "table" then current = {} end
                    else
                        if current == nil then current = values[1] end
                    end

                    local row, _, right = makeRow(o.Title or "Dropdown", o.Desc, o.Icon or o.Image)
                    right.Size = UDim2.fromOffset(136, 30)

                    local box = mk("TextButton", {
                        BackgroundColor3 = T.BgInput,
                        AutoButtonColor = false,
                        Text = "",
                        Size = UDim2.fromScale(1, 1),
                        Parent = right,
                    })
                    corner(box, rCtrl)
                    stroke(box, T.Stroke, 1, 0.4)

                    local rail = mk("Frame", {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 0, 0, 0),
                        Parent = box,
                    })

                    local function displayLabel(v)
                        local key = entryKey(v)
                        for _, opt in ipairs(values) do
                            if entryKey(opt) == key then return entryLabel(opt) end
                        end
                        return entryLabel(v)
                    end

                    local function labelText()
                        if multi then
                            local n = #current
                            if n == 0 then return o.Placeholder or "Select..." end
                            if n == 1 then return displayLabel(current[1]) end
                            return n .. " selected"
                        end
                        if current == nil then return o.Placeholder or "Select..." end
                        return displayLabel(current)
                    end

                    local txt = mk("TextLabel", {
                        BackgroundTransparency = 1,
                        Font = Fonts.Body,
                        TextSize = 13,
                        TextColor3 = T.Text,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextTruncate = Enum.TextTruncate.AtEnd,
                        Text = "",
                        Position = UDim2.fromOffset(14, 0),
                        Size = UDim2.new(1, -36, 1, 0),
                        Parent = box,
                    })

                    local previewIcon
                    local function refreshPreview()
                        if previewIcon then previewIcon:Destroy() previewIcon = nil end
                        local asset = (not multi) and entryAsset(current) or nil
                        local leftPad = 14
                        if asset then
                            previewIcon = makeIcon(box, asset, 20, Color3.new(1, 1, 1), 3)
                            previewIcon.AnchorPoint = Vector2.new(0, 0.5)
                            previewIcon.Position = UDim2.new(0, 8, 0.5, 0)
                            leftPad = 36
                        end
                        txt.Position = UDim2.fromOffset(leftPad, 0)
                        txt.Size = UDim2.new(1, -(leftPad + 22), 1, 0)
                        txt.Text = labelText()
                    end
                    refreshPreview()
                    local chevHolder = makeIcon(box, "lucide:chevron-down", 14, T.TextDim, 2)
                    chevHolder.AnchorPoint = Vector2.new(1, 0.5)
                    chevHolder.Position = UDim2.new(1, -8, 0.5, 0)

                    local open = false
                    local menu
                    local menuShadow
                    local dismiss

                    local api = {
                        Value = current,
                        Values = values,
                        Row = row,
                    }
                    function api:SetVisible(vis)
                        if row then row.Visible = vis and true or false end
                    end

                    local function closeMenu()
                        open = false
                        rail.BackgroundTransparency = 0.55
                        if chevHolder:FindFirstChildWhichIsA("ImageLabel") then
                            tween(chevHolder:FindFirstChildWhichIsA("ImageLabel"), TI(0.15), { Rotation = 0 })
                        end
                        if menu then menu:Destroy() menu = nil end
                        if menuShadow then menuShadow:Destroy() menuShadow = nil end
                        if dismiss then dismiss:Destroy() dismiss = nil end
                    end

                    local function isSelected(v)
                        if multi then
                            for _, x in ipairs(current) do
                                if entriesEqual(x, v) then return true end
                            end
                            return false
                        end
                        return entriesEqual(current, v)
                    end

                    local function fire()
                        if o.Callback then task.spawn(o.Callback, current) end
                    end

                    local function openMenu()
                        if open then closeMenu() return end
                        open = true
                        rail.BackgroundTransparency = 0.15
                        local chevImg = chevHolder:FindFirstChildWhichIsA("ImageLabel")
                        if chevImg then tween(chevImg, TI(0.15), { Rotation = 180 }) end

                        local abs = box.AbsolutePosition
                        local boxSz = box.AbsoluteSize
                        -- Taller rows so game asset icons (Shop/Craft) are readable
                        local itemH = 44
                        local iconSz = 28
                        local gap = 3
                        local padTop, padBot = 6, 8
                        local searchH = 0
                        local wantFilter = (o.Search ~= false) and (#values >= 6 or o.Search == true)
                        if wantFilter then searchH = 34 end
                        local countH = multi and 22 or 0

                        local maxListH = math.floor((workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.Y or 720) * 0.42)
                        maxListH = math.clamp(maxListH, 180, 320)
                        local fullListH = #values * itemH + math.max(0, #values - 1) * gap
                        local listH = math.min(fullListH, maxListH)
                        local menuW = math.max(boxSz.X, 200)
                        local menuH = padTop + padBot + searchH + countH + listH

                        -- GuiInset-safe place (same ScreenGui IgnoreGuiInset)
                        local inset = GuiService:GetGuiInset()
                        local posX = abs.X + (screen.IgnoreGuiInset and inset.X or 0)
                        local posYBelow = abs.Y + boxSz.Y + 6 + (screen.IgnoreGuiInset and inset.Y or 0)
                        local posYAbove = abs.Y - menuH - 6 + (screen.IgnoreGuiInset and inset.Y or 0)
                        local screenH = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.Y or 1080
                        local openUp = (posYBelow + menuH + 12) > screenH and posYAbove > 8
                        local posXFinal = math.clamp(posX + boxSz.X - menuW, 8, math.max(8, (workspace.CurrentCamera.ViewportSize.X or 1280) - menuW - 8))
                        local posY = openUp and math.max(8, posYAbove) or math.max(8, posYBelow)

                        -- Above Window:Popup (700+) so menus are visible inside modals
                        local z0 = 920
                        dismiss = mk("TextButton", {
                            BackgroundTransparency = 1,
                            Text = "",
                            AutoButtonColor = false,
                            Active = true,
                            Size = UDim2.fromScale(1, 1),
                            ZIndex = z0,
                            Parent = screen,
                        })
                        dismiss.MouseButton1Click:Connect(closeMenu)

                        menuShadow = mk("ImageLabel", {
                            BackgroundTransparency = 1,
                            Image = "rbxassetid://6014261993",
                            ImageColor3 = Color3.new(0, 0, 0),
                            ImageTransparency = 0.55,
                            ScaleType = Enum.ScaleType.Slice,
                            SliceCenter = Rect.new(49, 49, 450, 450),
                            Position = UDim2.fromOffset(posXFinal - 10, posY - 8),
                            Size = UDim2.fromOffset(menuW + 20, menuH + 20),
                            ZIndex = z0 + 1,
                            Parent = screen,
                        })

                        menu = mk("Frame", {
                            BackgroundColor3 = T.BgSection,
                            BorderSizePixel = 0,
                            Position = UDim2.fromOffset(posXFinal, posY),
                            Size = UDim2.fromOffset(menuW, menuH),
                            ZIndex = z0 + 2,
                            Parent = screen,
                        })
                        corner(menu, rCard)
                        stroke(menu, T.Stroke, 1, 0.4)
                        pad(menu, padTop, 6, padBot, 6)

                        local countLbl
                        local rebuildList
                        local function refreshCount()
                            if not countLbl then return end
                            local n = (type(current) == "table") and #current or 0
                            countLbl.Text = n == 0 and "None selected" or (n .. " selected")
                        end

                        if multi then
                            local countBar = mk("Frame", {
                                BackgroundTransparency = 1,
                                Position = UDim2.fromOffset(0, searchH),
                                Size = UDim2.new(1, 0, 0, countH),
                                ZIndex = z0 + 4,
                                Parent = menu,
                            })
                            countLbl = mk("TextLabel", {
                                BackgroundTransparency = 1,
                                Font = Fonts.Body,
                                TextSize = 11,
                                TextColor3 = T.TextMute,
                                TextXAlignment = Enum.TextXAlignment.Left,
                                Text = "",
                                Size = UDim2.new(1, -48, 1, 0),
                                ZIndex = z0 + 5,
                                Parent = countBar,
                            })
                            local clearBtn = mk("TextButton", {
                                BackgroundTransparency = 1,
                                AutoButtonColor = false,
                                Font = Fonts.Body,
                                TextSize = 11,
                                TextColor3 = T.TextDim,
                                Text = "Clear",
                                AnchorPoint = Vector2.new(1, 0.5),
                                Position = UDim2.new(1, 0, 0.5, 0),
                                Size = UDim2.fromOffset(44, 18),
                                ZIndex = z0 + 5,
                                Parent = countBar,
                            })
                            clearBtn.MouseButton1Click:Connect(function()
                                current = {}
                                api.Value = current
                                refreshPreview()
                                fire()
                                refreshCount()
                                rebuildList(true)
                            end)
                            refreshCount()
                        end

                        local filterQ = ""
                        local scroll
                        rebuildList = function(keepScroll)
                            local keepY = 0
                            if keepScroll and scroll then
                                keepY = scroll.CanvasPosition.Y
                            end
                            if scroll then scroll:Destroy() end
                            local filtered = {}
                            local q = string.lower(filterQ)
                            for _, v in ipairs(values) do
                                if q == "" or string.find(string.lower(entryLabel(v)), q, 1, true) then
                                    filtered[#filtered + 1] = v
                                end
                            end

                            local fH = #filtered * itemH + math.max(0, #filtered - 1) * gap
                            local viewH = math.min(math.max(fH, itemH), maxListH)
                            local newMenuH = padTop + padBot + searchH + countH + viewH
                            menu.Size = UDim2.fromOffset(menuW, newMenuH)
                            if menuShadow then
                                menuShadow.Size = UDim2.fromOffset(menuW + 20, newMenuH + 20)
                            end

                            scroll = mk("ScrollingFrame", {
                                BackgroundTransparency = 1,
                                BorderSizePixel = 0,
                                Position = UDim2.fromOffset(0, searchH + countH),
                                Size = UDim2.new(1, 0, 0, viewH),
                                CanvasSize = UDim2.fromOffset(0, fH),
                                ScrollingEnabled = fH > viewH,
                                ZIndex = z0 + 3,
                                Parent = menu,
                            })
                            styleScroll(scroll)
                            local listHost = mk("Frame", {
                                BackgroundTransparency = 1,
                                Size = UDim2.new(1, 0, 0, fH),
                                ZIndex = z0 + 4,
                                Parent = scroll,
                            })
                            list(listHost, Enum.FillDirection.Vertical, gap)

                            if keepScroll then
                                local y = keepY
                                task.defer(function()
                                    if scroll and scroll.Parent then
                                        local maxY = math.max(0, fH - viewH)
                                        scroll.CanvasPosition = Vector2.new(0, math.clamp(y, 0, maxY))
                                    end
                                end)
                            end

                            if #filtered == 0 then
                                mk("TextLabel", {
                                    BackgroundTransparency = 1,
                                    Font = Fonts.Body,
                                    TextSize = 12,
                                    TextColor3 = T.TextMute,
                                    Text = "No matches",
                                    Size = UDim2.new(1, 0, 0, itemH),
                                    ZIndex = z0 + 5,
                                    Parent = listHost,
                                })
                                return
                            end

                            for _, v in ipairs(filtered) do
                                local selected = isSelected(v)
                                local item = mk("TextButton", {
                                    BackgroundColor3 = T.BgHover,
                                    BackgroundTransparency = selected and 0.15 or 1,
                                    AutoButtonColor = false,
                                    Active = true,
                                    Text = "",
                                    Size = UDim2.new(1, 0, 0, itemH),
                                    ZIndex = z0 + 5,
                                    Parent = listHost,
                                })
                                corner(item, rCtrl)

                                local textLeft = 14
                                local asset = entryAsset(v)
                                if asset then
                                    local slot = mk("Frame", {
                                        BackgroundColor3 = T.BgInput,
                                        BackgroundTransparency = 0.35,
                                        Size = UDim2.fromOffset(iconSz, iconSz),
                                        AnchorPoint = Vector2.new(0, 0.5),
                                        Position = UDim2.new(0, 10, 0.5, 0),
                                        ClipsDescendants = true,
                                        ZIndex = z0 + 6,
                                        Parent = item,
                                    })
                                    corner(slot, 7)
                                    local ic = makeIcon(slot, asset, iconSz - 4, Color3.new(1, 1, 1), z0 + 7)
                                    ic.AnchorPoint = Vector2.new(0.5, 0.5)
                                    ic.Position = UDim2.fromScale(0.5, 0.5)
                                    ic.Size = UDim2.fromOffset(iconSz - 4, iconSz - 4)
                                    textLeft = 10 + iconSz + 10
                                end

                                mk("TextLabel", {
                                    BackgroundTransparency = 1,
                                    Font = Fonts.Body,
                                    TextSize = 13,
                                    TextScaled = false,
                                    TextColor3 = T.Text,
                                    TextXAlignment = Enum.TextXAlignment.Left,
                                    TextYAlignment = Enum.TextYAlignment.Center,
                                    TextTruncate = Enum.TextTruncate.AtEnd,
                                    Text = entryLabel(v),
                                    Size = UDim2.new(1, -(textLeft + 28), 1, 0),
                                    Position = UDim2.fromOffset(textLeft, 0),
                                    ZIndex = z0 + 6,
                                    Active = false,
                                    Parent = item,
                                })

                                local chkHold
                                local function setRowSelected(on)
                                    item.BackgroundTransparency = on and 0.15 or 1
                                    item.BackgroundColor3 = T.BgHover
                                    if on then
                                        if not chkHold then
                                            chkHold = makeIcon(item, "lucide:check", 13, accent, z0 + 7)
                                            chkHold.AnchorPoint = Vector2.new(1, 0.5)
                                            chkHold.Position = UDim2.new(1, -8, 0.5, 0)
                                        end
                                    elseif chkHold then
                                        chkHold:Destroy()
                                        chkHold = nil
                                    end
                                end
                                setRowSelected(selected)

                                item.MouseEnter:Connect(function()
                                    if not isSelected(v) then
                                        tween(item, TI(0.1), { BackgroundTransparency = 0.2, BackgroundColor3 = T.BgHover })
                                    end
                                end)
                                item.MouseLeave:Connect(function()
                                    if not isSelected(v) then
                                        tween(item, TI(0.1), { BackgroundTransparency = 1 })
                                    end
                                end)

                                item.MouseButton1Click:Connect(function()
                                    if multi then
                                        local found
                                        for i, x in ipairs(current) do
                                            if entriesEqual(x, v) then found = i break end
                                        end
                                        if found then
                                            table.remove(current, found)
                                        else
                                            table.insert(current, v)
                                        end
                                        api.Value = current
                                        refreshPreview()
                                        fire()
                                        setRowSelected(isSelected(v))
                                        refreshCount()
                                    else
                                        current = v
                                        api.Value = current
                                        refreshPreview()
                                        closeMenu()
                                        fire()
                                    end
                                end)
                            end
                        end

                        if wantFilter then
                            local searchBar = mk("Frame", {
                                BackgroundColor3 = T.BgInput,
                                Size = UDim2.new(1, 0, 0, 28),
                                ZIndex = 502,
                                Parent = menu,
                            })
                            corner(searchBar, 8)
                            stroke(searchBar, T.Stroke, 1, 0.4)
                            local sIcon = makeIcon(searchBar, "lucide:search", 13, T.TextMute, 503)
                            sIcon.Position = UDim2.fromOffset(8, 7)
                            local sBox = mk("TextBox", {
                                BackgroundTransparency = 1,
                                Font = Fonts.Body,
                                TextSize = 12,
                                TextColor3 = T.Text,
                                PlaceholderText = "Search…",
                                PlaceholderColor3 = T.TextMute,
                                Text = "",
                                ClearTextOnFocus = false,
                                Position = UDim2.fromOffset(28, 0),
                                Size = UDim2.new(1, -34, 1, 0),
                                TextXAlignment = Enum.TextXAlignment.Left,
                                ZIndex = 503,
                                Parent = searchBar,
                            })
                            -- don't dismiss when clicking search
                            sBox.Focused:Connect(function() end)
                            sBox:GetPropertyChangedSignal("Text"):Connect(function()
                                filterQ = sBox.Text
                                rebuildList()
                            end)
                        end

                        rebuildList()
                    end

                    box.MouseButton1Click:Connect(openMenu)
                    hover(box, function()
                        if not open then
                            tween(box, TI(0.12), { BackgroundColor3 = T.BgHover })
                        end
                    end, function()
                        if not open then
                            tween(box, TI(0.12), { BackgroundColor3 = T.BgInput })
                        end
                    end)

                    function api:Set(v, silent)
                        if multi then
                            current = type(v) == "table" and v or { v }
                        else
                            current = v
                        end
                        self.Value = current
                        refreshPreview()
                        if not silent then fire() end
                    end

                    function api:Refresh(newValues)
                        values = newValues or values
                        self.Values = values
                    end

                    if o.Flag then Window._flags[o.Flag] = api end
                    return api
                end

                -----------------------------------------------------------------
                -- Button (default = WindUI-clean row: title/desc + action icon)
                -- Style: "Clean" (default) | "Accent" | "Soft" | "Ghost" (filled CTA)
                -----------------------------------------------------------------
                function Section:Button(o)
                    o = o or {}
                    local style = string.lower(tostring(o.Style or "clean"))
                    -- Always show a trailing icon so rows read as clickable.
                    -- Prefer explicit Icon/Image; else chevron (not play — that made every button identical).
                    local iconName = normalizeAsset(o.Icon or o.Image) or "lucide:chevron-right"

                    -- Clean row — whole row is clickable (not just the icon)
                    if style == "clean" or style == "row" or style == "icon" then
                        local row, _, right = makeRow(o.Title or "Button", o.Desc, o.LeadingIcon or o.LeadingImage)
                        right.Size = UDim2.fromOffset(34, 34)
                        local ih, img = makeIcon(right, iconName, 18, T.TextDim, 2)
                        ih.AnchorPoint = Vector2.new(0.5, 0.5)
                        ih.Position = UDim2.fromScale(0.5, 0.5)

                        local hitBg = row:FindFirstChildWhichIsA("Frame") -- first child is hover bg from makeRow
                        local hit = mk("TextButton", {
                            BackgroundTransparency = 1,
                            AutoButtonColor = false,
                            Text = "",
                            Size = UDim2.fromScale(1, 1),
                            ZIndex = 25,
                            Parent = row,
                        })

                        local function setHover(on)
                            if hitBg then
                                tween(hitBg, TI(0.1), { BackgroundTransparency = on and 0.88 or 1 })
                            end
                            if img then setIconColor(img, on and accent or T.TextDim) end
                        end
                        hit.MouseEnter:Connect(function() setHover(true) end)
                        hit.MouseLeave:Connect(function() setHover(false) end)
                        hit.MouseButton1Click:Connect(function()
                            if o.Callback then task.spawn(o.Callback) end
                        end)
                        return hit
                    end

                    -- Filled CTA (optional)
                    addDivider()
                    rowOrder = rowOrder + 1
                    local row = mk("Frame", {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, o.Desc and 52 or 42),
                        LayoutOrder = rowOrder,
                        Parent = card,
                    })
                    pad(row, 6, 6, 6, 6)
                    registerSearch(row, o.Title or "Button", o.Desc)

                    local bg, bgHover, textCol, strokeCol, strokeT
                    if style == "ghost" then
                        bg = T.BgInput
                        bgHover = T.BgHover
                        textCol = T.Text
                        strokeCol = T.Stroke
                        strokeT = 0.4
                    elseif style == "soft" then
                        bg = T.BgHover
                        bgHover = Color3.fromRGB(48, 48, 54)
                        textCol = T.Text
                        strokeCol = T.Stroke
                        strokeT = 0.45
                    else
                        bg = accent
                        bgHover = T.AccentDim
                        textCol = Color3.new(1, 1, 1)
                        strokeCol = nil
                    end

                    local b = mk("TextButton", {
                        BackgroundColor3 = bg,
                        AutoButtonColor = false,
                        Text = "",
                        Size = UDim2.fromScale(1, 1),
                        Parent = row,
                    })
                    corner(b, 11)
                    if strokeCol then
                        stroke(b, strokeCol, 1, strokeT)
                    end

                    local inner = mk("Frame", {
                        BackgroundTransparency = 1,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.fromScale(0.5, 0.5),
                        Size = UDim2.new(1, -18, 1, -6),
                        Parent = b,
                    })
                    list(inner, Enum.FillDirection.Horizontal, 8, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center)

                    local ih = makeIcon(inner, iconName, 15, textCol, 2)
                    ih.Size = UDim2.fromOffset(15, 15)
                    ih.LayoutOrder = 1

                    local labels = mk("Frame", {
                        BackgroundTransparency = 1,
                        Size = UDim2.fromOffset(0, 0),
                        AutomaticSize = Enum.AutomaticSize.XY,
                        LayoutOrder = 2,
                        Parent = inner,
                    })
                    list(labels, Enum.FillDirection.Vertical, 1, Enum.HorizontalAlignment.Left)

                    mk("TextLabel", {
                        BackgroundTransparency = 1,
                        Font = Fonts.Title,
                        TextSize = 13,
                        TextColor3 = textCol,
                        Text = o.Title or "Button",
                        Size = UDim2.fromOffset(0, 16),
                        AutomaticSize = Enum.AutomaticSize.X,
                        Parent = labels,
                    })
                    if not compactOn and o.Desc and o.Desc ~= "" then
                        mk("TextLabel", {
                            BackgroundTransparency = 1,
                            Font = Fonts.Desc,
                            TextSize = 11,
                            TextColor3 = style == "accent" and Color3.fromRGB(230, 220, 255) or T.TextMute,
                            TextTransparency = style == "accent" and 0.28 or 0,
                            Text = o.Desc,
                            Size = UDim2.fromOffset(0, 14),
                            AutomaticSize = Enum.AutomaticSize.X,
                            Parent = labels,
                        })
                    end

                    hover(b, function()
                        tween(b, TI(0.12), { BackgroundColor3 = bgHover })
                    end, function()
                        tween(b, TI(0.12), { BackgroundColor3 = bg })
                    end)
                    b.MouseButton1Click:Connect(function()
                        if o.Callback then task.spawn(o.Callback) end
                    end)
                    return b
                end

                -----------------------------------------------------------------
                -- Input
                -----------------------------------------------------------------
                function Section:Input(o)
                    o = o or {}
                    -- stacked full-width so long strings (URLs) don't blow the layout
                    addDivider()
                    rowOrder = rowOrder + 1
                    local row = mk("Frame", {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 0),
                        AutomaticSize = Enum.AutomaticSize.Y,
                        LayoutOrder = rowOrder,
                        Parent = card,
                    })
                    pad(row, 6, 8, 6, 8)
                    list(row, Enum.FillDirection.Vertical, 5)
                    registerSearch(row, o.Title or "Input", o.Desc)

                    local inputHead = mk("Frame", {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 18),
                        LayoutOrder = 1,
                        Parent = row,
                    })
                    mk("TextLabel", {
                        BackgroundTransparency = 1,
                        Font = Fonts.Title,
                        TextSize = 14,
                        TextColor3 = T.Text,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Text = o.Title or "Input",
                        Size = UDim2.new(1, 0, 0, 18),
                        Parent = inputHead,
                    })
                    if not compactOn and o.Desc and o.Desc ~= "" then
                        mk("TextLabel", {
                            BackgroundTransparency = 1,
                            Font = Fonts.Desc,
                            TextSize = 11,
                            TextColor3 = T.TextMute,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            TextWrapped = true,
                            Text = o.Desc,
                            Size = UDim2.new(1, 0, 0, 0),
                            AutomaticSize = Enum.AutomaticSize.Y,
                            LayoutOrder = 2,
                            Parent = row,
                        })
                    end

                    local boxHost = mk("Frame", {
                        BackgroundColor3 = T.BgInput,
                        Size = UDim2.new(1, 0, 0, 32),
                        ClipsDescendants = true,
                        LayoutOrder = 3,
                        Parent = row,
                    })
                    corner(boxHost, 8)
                    stroke(boxHost, Color3.fromRGB(48, 46, 58), 1, 0.5)

                    local box = mk("TextBox", {
                        BackgroundTransparency = 1,
                        Font = Fonts.Body,
                        TextSize = 13,
                        TextColor3 = T.Text,
                        PlaceholderText = o.Placeholder or "...",
                        PlaceholderColor3 = T.TextMute,
                        Text = o.Value and tostring(o.Value) or "",
                        ClearTextOnFocus = false,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Size = UDim2.fromScale(1, 1),
                        Parent = boxHost,
                    })
                    pad(box, 0, 8, 0, 8)

                    local api = { Value = box.Text, Row = row }
                    box.FocusLost:Connect(function(enter)
                        api.Value = box.Text
                        if o.Callback then task.spawn(o.Callback, box.Text, enter) end
                    end)
                    function api:Set(v, silent)
                        box.Text = tostring(v or "")
                        self.Value = box.Text
                        if not silent and o.Callback then task.spawn(o.Callback, box.Text, false) end
                    end
                    function api:SetVisible(vis)
                        row.Visible = vis and true or false
                    end
                    if o.Flag then Window._flags[o.Flag] = api end
                    return api
                end

                -----------------------------------------------------------------
                -- Keybind
                -----------------------------------------------------------------
                function Section:Keybind(o)
                    o = o or {}
                    local key = o.Value or Enum.KeyCode.Unknown
                    local _, _, right = makeRow(o.Title or "Keybind", o.Desc, o.Icon or o.Image)
                    right.Size = UDim2.fromOffset(110, 32)
                    local box = mk("TextButton", {
                        BackgroundColor3 = T.BgInput,
                        AutoButtonColor = false,
                        Font = Fonts.Body,
                        TextSize = 12,
                        TextColor3 = T.Text,
                        Text = key.Name or "None",
                        Size = UDim2.fromScale(1, 1),
                        Parent = right,
                    })
                    corner(box, 12)
                    stroke(box, T.Stroke, 1, 0.4)

                    local listening = false
                    local api = { Value = key }

                    local function setKey(k, silent)
                        key = k
                        api.Value = k
                        box.Text = (k and k.Name) or "None"
                        if o.WindowToggle and Window.SetToggleKey then
                            Window:SetToggleKey(k)
                        end
                        if not silent and o.Callback then task.spawn(o.Callback, k) end
                    end
                    api.Set = function(_, k, silent) setKey(k, silent) end

                    if o.WindowToggle and Window.SetToggleKey then
                        Window:SetToggleKey(key)
                    end

                    box.MouseButton1Click:Connect(function()
                        listening = true
                        box.Text = "..."
                        box.TextColor3 = accent
                    end)

                    UserInputService.InputBegan:Connect(function(input, gp)
                        if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                            listening = false
                            box.TextColor3 = T.Text
                            if input.KeyCode == Enum.KeyCode.Escape then
                                setKey(Enum.KeyCode.Unknown)
                            else
                                setKey(input.KeyCode)
                            end
                            return
                        end
                        -- Window toggle is handled by Window listener — don't double-fire Pressed
                        if o.WindowToggle then return end
                        if UserInputService:GetFocusedTextBox() then return end
                        if not listening and key and key ~= Enum.KeyCode.Unknown and input.KeyCode == key then
                            if o.Pressed then task.spawn(o.Pressed) end
                        end
                    end)

                    if o.Flag then Window._flags[o.Flag] = api end
                    return api
                end

                -----------------------------------------------------------------
                -- Paragraph / Label
                -----------------------------------------------------------------
                function Section:Paragraph(o)
                    o = o or {}
                    addDivider()
                    rowOrder = rowOrder + 1
                    local row = mk("Frame", {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 0),
                        AutomaticSize = Enum.AutomaticSize.Y,
                        LayoutOrder = rowOrder,
                        Parent = card,
                    })
                    pad(row, 8, 8, 8, 10)
                    list(row, Enum.FillDirection.Vertical, 3)
                    registerSearch(row, o.Title, o.Content or o.Desc)
                    if o.Title then
                        local pHead = mk("Frame", {
                            BackgroundTransparency = 1,
                            Size = UDim2.new(1, 0, 0, 17),
                            LayoutOrder = 1,
                            Parent = row,
                        })
                        mk("TextLabel", {
                            BackgroundTransparency = 1,
                            Font = Fonts.Title,
                            TextSize = 14,
                            TextColor3 = T.Text,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            Text = o.Title,
                            Size = UDim2.new(1, 0, 0, 17),
                            Parent = pHead,
                        })
                    end
                    local body = mk("TextLabel", {
                        BackgroundTransparency = 1,
                        Font = Fonts.Desc,
                        TextSize = 13,
                        TextColor3 = T.TextMute,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextYAlignment = Enum.TextYAlignment.Top,
                        TextWrapped = true,
                        Text = o.Content or o.Desc or "",
                        Size = UDim2.new(1, 0, 0, 0),
                        AutomaticSize = Enum.AutomaticSize.Y,
                        LayoutOrder = 2,
                        Parent = row,
                    })
                    return {
                        Set = function(_, text)
                            body.Text = tostring(text or "")
                        end,
                    }
                end

                function Section:Divider()
                    rowOrder = rowOrder + 1
                    local row = mk("Frame", {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 12),
                        LayoutOrder = rowOrder,
                        Parent = card,
                    })
                    mk("Frame", {
                        BackgroundColor3 = T.Divider,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.fromScale(0.5, 0.5),
                        Size = UDim2.new(1, -12, 0, 1),
                        BorderSizePixel = 0,
                        Parent = row,
                    })
                end

                -----------------------------------------------------------------
                -- PriorityList — smooth drag-reorder (ghost + LayoutOrder swap)
                -----------------------------------------------------------------
                function Section:PriorityList(o)
                    o = o or {}
                    local items = {}
                    for i, v in ipairs(o.Values or {}) do
                        items[i] = v
                    end

                    local ROW_H = math.clamp(math.floor(tonumber(o.RowHeight) or 40), 32, 56)
                    local ROW_GAP = 4
                    local showItemIcons = o.ShowItemIcons ~= false -- default on; AE Auto Join sets false

                    addDivider()
                    rowOrder = rowOrder + 1
                    local wrap = mk("Frame", {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 0),
                        AutomaticSize = Enum.AutomaticSize.Y,
                        LayoutOrder = rowOrder,
                        Parent = card,
                    })
                    pad(wrap, 6, 8, 8, 8)
                    list(wrap, Enum.FillDirection.Vertical, 4)
                    registerSearch(wrap, o.Title or "Priority", o.Desc)

                    if o.Title then
                        local head = mk("Frame", {
                            BackgroundTransparency = 1,
                            Size = UDim2.new(1, 0, 0, 18),
                            Parent = wrap,
                        })
                        mk("TextLabel", {
                            BackgroundTransparency = 1,
                            Font = Fonts.Title,
                            TextSize = 14,
                            TextColor3 = T.Text,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            Text = o.Title,
                            Size = UDim2.new(1, 0, 0, 18),
                            Parent = head,
                        })
                    end
                    if not compactOn and o.Desc and o.Desc ~= "" then
                        mk("TextLabel", {
                            BackgroundTransparency = 1,
                            Font = Fonts.Desc,
                            TextSize = 11,
                            TextColor3 = T.TextMute,
                            TextWrapped = true,
                            Text = o.Desc,
                            Size = UDim2.new(1, 0, 0, 0),
                            AutomaticSize = Enum.AutomaticSize.Y,
                            Parent = wrap,
                        })
                    end

                    local function contentH(n)
                        n = math.max(tonumber(n) or 1, 1)
                        return n * ROW_H + math.max(0, n - 1) * ROW_GAP
                    end

                    local maxVis = tonumber(o.MaxVisible) or tonumber(o.VisibleRows)
                    local resizable = o.Resizable == true
                    local minH = tonumber(o.MinHeight) or contentH(3)
                    local maxH = tonumber(o.MaxHeight) or contentH(10)
                    local viewH = tonumber(o.Height)
                    if not viewH and maxVis then
                        viewH = contentH(maxVis)
                    end
                    local useScroll = viewH ~= nil or resizable
                    if useScroll and not viewH then
                        viewH = contentH(math.min(5, math.max(#items, 3)))
                    end
                    if viewH then
                        viewH = math.clamp(viewH, minH, maxH)
                    end

                    local scroll
                    local listFrame
                    if useScroll then
                        scroll = mk("ScrollingFrame", {
                            BackgroundTransparency = 1,
                            BorderSizePixel = 0,
                            Size = UDim2.new(1, 0, 0, viewH),
                            CanvasSize = UDim2.fromOffset(0, contentH(#items)),
                            ScrollBarThickness = 3,
                            ScrollBarImageColor3 = accent,
                            ScrollBarImageTransparency = 0.4,
                            ScrollingEnabled = true,
                            ClipsDescendants = true,
                            Parent = wrap,
                        })
                        styleScroll(scroll)
                        listFrame = mk("Frame", {
                            BackgroundTransparency = 1,
                            Size = UDim2.new(1, 0, 0, 0),
                            AutomaticSize = Enum.AutomaticSize.Y,
                            Parent = scroll,
                        })
                    else
                        listFrame = mk("Frame", {
                            BackgroundTransparency = 1,
                            Size = UDim2.new(1, 0, 0, 0),
                            AutomaticSize = Enum.AutomaticSize.Y,
                            ClipsDescendants = false,
                            Parent = wrap,
                        })
                    end
                    list(listFrame, Enum.FillDirection.Vertical, ROW_GAP)

                    local api = { Values = items, Height = viewH, RowHeight = ROW_H }
                    local rowFrames = {}
                    local drag = {
                        active = false,
                        idx = 0,
                        ghost = nil,
                        grabDY = 0,
                    }

                    local function fire()
                        if o.Callback then task.spawn(o.Callback, items) end
                    end

                    local function paintRest(r, i, lit)
                        r.LayoutOrder = i
                        local num = r:FindFirstChild("Num")
                        if num then num.Text = "#" .. tostring(i) end
                        if lit then
                            r.BackgroundColor3 = T.BgHover
                            local st = r:FindFirstChildOfClass("UIStroke")
                            if st then
                                st.Color = T.Stroke
                                st.Transparency = 0.25
                            end
                        else
                            r.BackgroundColor3 = T.BgInput
                            local st = r:FindFirstChildOfClass("UIStroke")
                            if st then
                                st.Color = T.Stroke
                                st.Transparency = 0.5
                            end
                        end
                    end

                    local function syncOrders(litIdx)
                        for i, r in ipairs(rowFrames) do
                            paintRest(r, i, litIdx == i)
                        end
                        api.Values = items
                    end

                    local function moveItem(from, to)
                        if from == to or from < 1 or to < 1 or from > #items or to > #items then return end
                        local it = table.remove(items, from)
                        table.insert(items, to, it)
                        local rf = table.remove(rowFrames, from)
                        table.insert(rowFrames, to, rf)
                        syncOrders(to)
                    end

                    -- probe = จุดกลาง ghost (สิ่งที่ตาเห็น) ไม่ใช่แค่เมาส์
                    -- threshold ตามทิศ: ขึ้น/ลง swap ไว ไม่ต้องลากพ้น midpoint
                    local function probeY(mouseY)
                        if drag.ghost and drag.ghost.Parent then
                            return drag.ghost.AbsolutePosition.Y + drag.ghost.AbsoluteSize.Y * 0.5
                        end
                        return mouseY
                    end

                    local function nextTarget(py)
                        local i = drag.idx
                        if i > 1 then
                            local above = rowFrames[i - 1]
                            -- ลากขึ้น: แค่กลาง ghost โผล่เข้า ~78% ของแถวบน → สลับเลย
                            local thresh = above.AbsolutePosition.Y + above.AbsoluteSize.Y * 0.78
                            if py < thresh then
                                return i - 1
                            end
                        end
                        if i < #rowFrames then
                            local below = rowFrames[i + 1]
                            -- ลากลง: กลาง ghost แตะ ~22% ของแถวล่าง → สลับ
                            local thresh = below.AbsolutePosition.Y + below.AbsoluteSize.Y * 0.22
                            if py > thresh then
                                return i + 1
                            end
                        end
                        return i
                    end

                    local function clearGhost()
                        if drag.ghost then
                            drag.ghost:Destroy()
                            drag.ghost = nil
                        end
                    end

                    local function endDrag()
                        if not drag.active then return end
                        drag.active = false
                        clearGhost()
                        for i, r in ipairs(rowFrames) do
                            r.BackgroundTransparency = 0
                            local sc = r:FindFirstChild("DragScale")
                            if sc then sc:Destroy() end
                            paintRest(r, i, false)
                        end
                        fire()
                    end

                    local function startDrag(idx, input)
                        if drag.active or idx < 1 or idx > #rowFrames then return end
                        local src = rowFrames[idx]
                        drag.active = true
                        drag.idx = idx
                        -- sticky grab: offset จากมุมบนซ้ายแถว → เมาส์ (ไม่หักครึ่งสูงซ้ำ)
                        drag.grabOX = input.Position.X - src.AbsolutePosition.X
                        drag.grabOY = input.Position.Y - src.AbsolutePosition.Y

                        src.BackgroundTransparency = 0.55

                        local sg = listFrame:FindFirstAncestorOfClass("ScreenGui")
                        local ghostParent = sg or listFrame
                        local g = src:Clone()
                        g.Name = "VoidDragGhost"
                        g.BackgroundTransparency = 0.08
                        g.BackgroundColor3 = T.BgSection
                        g.Size = UDim2.fromOffset(src.AbsoluteSize.X, src.AbsoluteSize.Y)
                        g.AnchorPoint = Vector2.new(0, 0)
                        g.Parent = ghostParent
                        for _, d in ipairs(g:GetDescendants()) do
                            if d:IsA("GuiObject") then
                                d.ZIndex = (d.ZIndex or 1) + 800
                            end
                        end
                        g.ZIndex = 900
                        local gst = g:FindFirstChildOfClass("UIStroke")
                        if gst then
                            gst.Color = T.Stroke
                            gst.Transparency = 0.2
                            gst.Thickness = 1
                        end
                        local gsc = g:FindFirstChild("DragScale")
                        if gsc then gsc:Destroy() end
                        drag.ghost = g

                        local function screenToParent(sx, sy)
                            if ghostParent:IsA("ScreenGui") then
                                -- AbsolutePosition == ScreenGui coords เมื่อ IgnoreGuiInset
                                if ghostParent.IgnoreGuiInset then
                                    return sx, sy
                                end
                                local inset = GuiService:GetGuiInset()
                                return sx - inset.X, sy - inset.Y
                            end
                            local p = ghostParent.AbsolutePosition
                            return sx - p.X, sy - p.Y
                        end

                        local function setGhostPos(pos)
                            if not drag.ghost then return end
                            local px, py = screenToParent(pos.X - drag.grabOX, pos.Y - drag.grabOY)
                            drag.ghost.Position = UDim2.fromOffset(px, py)
                        end
                        setGhostPos(input.Position)
                        drag._setGhostPos = setGhostPos
                        syncOrders(idx)
                    end

                    local function onDragMove(input)
                        if not drag.active then return end
                        local pos = input.Position
                        if input.UserInputType == Enum.UserInputType.MouseMovement then
                            local m = UserInputService:GetMouseLocation()
                            pos = Vector3.new(m.X, m.Y, 0)
                        end
                        if drag._setGhostPos then drag._setGhostPos(pos) end
                        -- หลังวาง ghost แล้วค่อยวัด — ใช้กลาง ghost + threshold ไว
                        local target = nextTarget(probeY(pos.Y))
                        if target ~= drag.idx then
                            moveItem(drag.idx, target)
                            drag.idx = target
                        end
                    end

                    local function buildRows()
                        clearGhost()
                        drag.active = false
                        for _, r in ipairs(rowFrames) do
                            if r and r.Parent then r:Destroy() end
                        end
                        for i = #rowFrames, 1, -1 do rowFrames[i] = nil end

                        for i, v in ipairs(items) do
                            local r = mk("TextButton", {
                                BackgroundColor3 = T.BgInput,
                                AutoButtonColor = false,
                                Text = "",
                                Size = UDim2.new(1, 0, 0, ROW_H),
                                LayoutOrder = i,
                                Parent = listFrame,
                            })
                            corner(r, rCtrl)
                            stroke(r, T.Stroke, 1, 0.5)
                            rowFrames[i] = r

                            local grip = makeIcon(r, "lucide:grip-vertical", 14, T.TextMute, 2)
                            grip.AnchorPoint = Vector2.new(0, 0.5)
                            grip.Position = UDim2.new(0, 8, 0.5, 0)

                            local left = 28
                            if showItemIcons then
                                local asset = entryAsset(v) or normalizeAsset(type(v) == "table" and (v.Image or v.Icon))
                                if asset then
                                    local ic = makeIcon(r, asset, 16, T.Text, 2)
                                    ic.AnchorPoint = Vector2.new(0, 0.5)
                                    ic.Position = UDim2.new(0, 26, 0.5, 0)
                                    left = 48
                                end
                            end

                            mk("TextLabel", {
                                Name = "Num",
                                BackgroundTransparency = 1,
                                Font = Fonts.Title,
                                TextSize = 11,
                                TextColor3 = T.TextMute,
                                Text = "#" .. i,
                                AnchorPoint = Vector2.new(0, 0.5),
                                Position = UDim2.new(0, left, 0.5, 0),
                                Size = UDim2.fromOffset(28, 16),
                                ZIndex = 2,
                                Parent = r,
                            })
                            mk("TextLabel", {
                                Name = "Label",
                                BackgroundTransparency = 1,
                                Font = Fonts.Body,
                                TextSize = 13,
                                TextColor3 = T.Text,
                                TextXAlignment = Enum.TextXAlignment.Left,
                                TextTruncate = Enum.TextTruncate.AtEnd,
                                Text = entryLabel(v),
                                AnchorPoint = Vector2.new(0, 0.5),
                                Position = UDim2.new(0, left + 28, 0.5, 0),
                                Size = UDim2.new(1, -(left + 38), 0, 18),
                                ZIndex = 2,
                                Parent = r,
                            })

                            r.InputBegan:Connect(function(input)
                                if input.UserInputType ~= Enum.UserInputType.MouseButton1
                                    and input.UserInputType ~= Enum.UserInputType.Touch then
                                    return
                                end
                                local live = r.LayoutOrder
                                startDrag(live, input)
                            end)

                            r.MouseEnter:Connect(function()
                                if drag.active then return end
                                tween(r, TI(0.1), { BackgroundColor3 = T.BgHover })
                            end)
                            r.MouseLeave:Connect(function()
                                if drag.active then return end
                                tween(r, TI(0.1), { BackgroundColor3 = T.BgInput })
                            end)
                        end
                        api.Values = items
                        if scroll then
                            local h = contentH(#items)
                            scroll.CanvasSize = UDim2.fromOffset(0, h)
                            scroll.ScrollingEnabled = h > (scroll.AbsoluteSize.Y > 0 and scroll.AbsoluteSize.Y or (viewH or 0))
                        end
                    end

                    local function applyViewH(h)
                        if not scroll then return end
                        viewH = math.clamp(math.floor(tonumber(h) or viewH or minH), minH, maxH)
                        api.Height = viewH
                        scroll.Size = UDim2.new(1, 0, 0, viewH)
                        local ch = contentH(#items)
                        scroll.CanvasSize = UDim2.fromOffset(0, ch)
                        scroll.ScrollingEnabled = ch > viewH
                        if o.OnResize then task.spawn(o.OnResize, viewH) end
                    end

                    UserInputService.InputChanged:Connect(function(input)
                        if not drag.active then return end
                        if input.UserInputType ~= Enum.UserInputType.MouseMovement
                            and input.UserInputType ~= Enum.UserInputType.Touch then
                            return
                        end
                        onDragMove(input)
                    end)
                    UserInputService.InputEnded:Connect(function(input)
                        if not drag.active then return end
                        if input.UserInputType == Enum.UserInputType.MouseButton1
                            or input.UserInputType == Enum.UserInputType.Touch then
                            endDrag()
                        end
                    end)

                    function api:Set(listVals, silent)
                        items = {}
                        for i, v in ipairs(listVals or {}) do items[i] = v end
                        buildRows()
                        if not silent then fire() end
                    end
                    function api:Get()
                        return items
                    end
                    function api:SetHeight(h, silent)
                        applyViewH(h)
                        if not silent and o.OnResize then task.spawn(o.OnResize, api.Height) end
                    end
                    function api:GetHeight()
                        return api.Height
                    end

                    buildRows()

                    -- Bottom grip — thin hit area (PriorityList resize)
                    if resizable and scroll then
                        local grip = mk("TextButton", {
                            BackgroundTransparency = 1,
                            AutoButtonColor = false,
                            Text = "",
                            Size = UDim2.new(1, 0, 0, 10),
                            Parent = wrap,
                        })
                        mk("Frame", {
                            BackgroundColor3 = accent,
                            BackgroundTransparency = 0.55,
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            Position = UDim2.fromScale(0.5, 0.5),
                            Size = UDim2.fromOffset(28, 2),
                            BorderSizePixel = 0,
                            Parent = grip,
                        })
                        local resizing = false
                        local startY, startH = 0, viewH or minH
                        grip.InputBegan:Connect(function(input)
                            if input.UserInputType ~= Enum.UserInputType.MouseButton1
                                and input.UserInputType ~= Enum.UserInputType.Touch then
                                return
                            end
                            resizing = true
                            startY = input.Position.Y
                            startH = viewH or scroll.AbsoluteSize.Y
                        end)
                        UserInputService.InputChanged:Connect(function(input)
                            if not resizing then return end
                            if input.UserInputType ~= Enum.UserInputType.MouseMovement
                                and input.UserInputType ~= Enum.UserInputType.Touch then
                                return
                            end
                            applyViewH(startH + (input.Position.Y - startY))
                        end)
                        UserInputService.InputEnded:Connect(function(input)
                            if not resizing then return end
                            if input.UserInputType == Enum.UserInputType.MouseButton1
                                or input.UserInputType == Enum.UserInputType.Touch then
                                resizing = false
                            end
                        end)
                    end

                    if o.Flag then Window._flags[o.Flag] = api end
                    return api
                end

                -- Item / progress rows (icon + name + right text). Refresh with api:Set.
                function Section:Panel(o)
                    o = o or {}
                    local items = {}
                    for i, v in ipairs(o.Values or {}) do
                        items[i] = v
                    end
                    local ROW_H = math.clamp(math.floor(tonumber(o.RowHeight) or 44), 36, 64)

                    addDivider()
                    rowOrder = rowOrder + 1
                    local wrap = mk("Frame", {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 0),
                        AutomaticSize = Enum.AutomaticSize.Y,
                        LayoutOrder = rowOrder,
                        Parent = card,
                    })
                    pad(wrap, 6, 8, 8, 8)
                    list(wrap, Enum.FillDirection.Vertical, 4)
                    registerSearch(wrap, o.Title or "Panel", o.Desc)

                    if o.Title then
                        local head = mk("Frame", {
                            BackgroundTransparency = 1,
                            Size = UDim2.new(1, 0, 0, 18),
                            Parent = wrap,
                        })
                        mk("TextLabel", {
                            BackgroundTransparency = 1,
                            Font = Fonts.Title,
                            TextSize = 14,
                            TextColor3 = T.Text,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            Text = o.Title,
                            Size = UDim2.new(1, 0, 0, 18),
                            Parent = head,
                        })
                    end
                    if not compactOn and o.Desc and o.Desc ~= "" then
                        mk("TextLabel", {
                            BackgroundTransparency = 1,
                            Font = Fonts.Desc,
                            TextSize = 11,
                            TextColor3 = T.TextMute,
                            TextWrapped = true,
                            Text = o.Desc,
                            Size = UDim2.new(1, 0, 0, 0),
                            AutomaticSize = Enum.AutomaticSize.Y,
                            Parent = wrap,
                        })
                    end

                    local listHost = mk("Frame", {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 0),
                        AutomaticSize = Enum.AutomaticSize.Y,
                        Parent = wrap,
                    })
                    list(listHost, Enum.FillDirection.Vertical, 4)

                    local emptyLab = mk("TextLabel", {
                        BackgroundTransparency = 1,
                        Font = Fonts.Desc,
                        TextSize = 12,
                        TextColor3 = T.TextMute,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Text = o.EmptyText or "Nothing selected",
                        Size = UDim2.new(1, 0, 0, 18),
                        Visible = #items == 0,
                        Parent = wrap,
                    })

                    local api = { Values = items, Flag = o.Flag }

                    local function rowName(v)
                        if type(v) == "table" then
                            return tostring(v.Name or v.Title or v.Id or "")
                        end
                        return tostring(v or "")
                    end
                    local function rowRight(v)
                        if type(v) == "table" then
                            return tostring(v.Right or v.Value or "")
                        end
                        return ""
                    end
                    local function rowSub(v)
                        if type(v) == "table" then
                            return tostring(v.Sub or v.Desc or "")
                        end
                        return ""
                    end

                    local function buildRows()
                        for _, ch in ipairs(listHost:GetChildren()) do
                            if ch:IsA("GuiObject") then ch:Destroy() end
                        end
                        emptyLab.Visible = #items == 0
                        for i, v in ipairs(items) do
                            local sub = rowSub(v)
                            local h = (sub ~= "" and ROW_H) or math.max(36, ROW_H - 6)
                            local r = mk("Frame", {
                                BackgroundColor3 = T.BgInput,
                                Size = UDim2.new(1, 0, 0, h),
                                LayoutOrder = i,
                                Parent = listHost,
                            })
                            corner(r, rCtrl)
                            stroke(r, T.Stroke, 1, 0.5)
                            local left = 10
                            local asset = entryAsset(v)
                            if asset then
                                local ic = makeIcon(r, asset, 22, T.Text, 2)
                                ic.AnchorPoint = Vector2.new(0, 0.5)
                                ic.Position = UDim2.new(0, 10, 0.5, 0)
                                left = 40
                            end
                            local rightTxt = rowRight(v)
                            local rightW = 0
                            if rightTxt ~= "" then
                                local rl = mk("TextLabel", {
                                    BackgroundTransparency = 1,
                                    Font = Fonts.Title,
                                    TextSize = 12,
                                    TextColor3 = T.TextDim,
                                    TextXAlignment = Enum.TextXAlignment.Right,
                                    Text = rightTxt,
                                    AnchorPoint = Vector2.new(1, 0.5),
                                    Position = UDim2.new(1, -10, 0.5, sub ~= "" and -6 or 0),
                                    Size = UDim2.fromOffset(88, 16),
                                    Parent = r,
                                })
                                rightW = 96
                            end
                            mk("TextLabel", {
                                BackgroundTransparency = 1,
                                Font = Fonts.Body,
                                TextSize = 13,
                                TextColor3 = T.Text,
                                TextXAlignment = Enum.TextXAlignment.Left,
                                TextTruncate = Enum.TextTruncate.AtEnd,
                                Text = rowName(v),
                                AnchorPoint = Vector2.new(0, 0.5),
                                Position = UDim2.new(0, left, 0.5, sub ~= "" and -7 or 0),
                                Size = UDim2.new(1, -(left + rightW + 4), 0, 16),
                                Parent = r,
                            })
                            if sub ~= "" then
                                mk("TextLabel", {
                                    BackgroundTransparency = 1,
                                    Font = Fonts.Desc,
                                    TextSize = 11,
                                    TextColor3 = T.TextMute,
                                    TextXAlignment = Enum.TextXAlignment.Left,
                                    TextTruncate = Enum.TextTruncate.AtEnd,
                                    Text = sub,
                                    AnchorPoint = Vector2.new(0, 1),
                                    Position = UDim2.new(0, left, 1, -6),
                                    Size = UDim2.new(1, -(left + 10), 0, 14),
                                    Parent = r,
                                })
                            end
                        end
                        api.Values = items
                    end

                    function api:Set(listVals, _silent)
                        items = {}
                        for i, v in ipairs(listVals or {}) do items[i] = v end
                        buildRows()
                    end
                    function api:Get()
                        return items
                    end

                    buildRows()
                    if o.Flag then Window._flags[o.Flag] = api end
                    return api
                end

                return Section
            end

            -- Hidden pages (Popup host) stay off the subtab bar
            if popts.Hidden then
                return Page
            end
            -- convenience: Tab:Section goes to first/default page
            table.insert(Tab._pages, Page)
            if not Tab._activePage then
                Tab._activePage = Page
                Page.Frame.Visible = true
                Page._active = true
            end
            -- Tab() with Selected=true runs SelectTab before any Page exists,
            -- so subtabs never appear until user re-clicks. Refresh when pages grow.
            if Window._activeTab == Tab then
                if #Tab._pages >= 2 then
                    Window:SelectTab(Tab)
                elseif #Tab._pages == 1 then
                    Tab:SelectPage(Page)
                end
            end
            return Page
        end

        -- Tab:Section → auto page
        function Tab:Section(sopts)
            if #self._pages == 0 then
                self:Page({ Title = self.Title })
            end
            return self._pages[1]:Section(sopts)
        end

        btn.MouseButton1Click:Connect(function()
            Window:SelectTab(Tab)
        end)

        table.insert(Window._tabs, Tab)
        if selected or #Window._tabs == 1 then
            -- defer so Pages added right after Tab() are visible to SelectTab
            task.defer(function()
                if Tab.Host and Tab.Host.Parent then
                    Window:SelectTab(Tab)
                end
            end)
        else
            Tab:_setActive(false)
        end
        return Tab
    end

    -- Config helpers
    function Window:GetFlag(name)
        return self._flags[name]
    end

    function Window:SaveConfig(name)
        if not (writefile and folder) then return false end
        local data = {}
        for flag, api in pairs(self._flags) do
            if api and api.Value ~= nil then
                local v = api.Value
                if typeof(v) == "EnumItem" then
                    data[flag] = { __enum = v.EnumType.Name, name = v.Name }
                else
                    data[flag] = v
                end
            end
        end
        pcall(function()
            if makefolder and not isfolder(folder) then makefolder(folder) end
            writefile(folder .. "/" .. (name or "config") .. ".json", HttpService:JSONEncode(data))
        end)
        return true
    end

    function Window:LoadConfig(name)
        if not (readfile and isfile and folder) then return false end
        local path = folder .. "/" .. (name or "config") .. ".json"
        if not isfile(path) then return false end
        local ok, raw = pcall(readfile, path)
        if not ok then return false end
        local ok2, data = pcall(HttpService.JSONDecode, HttpService, raw)
        if not ok2 or type(data) ~= "table" then return false end
        for flag, val in pairs(data) do
            local api = self._flags[flag]
            if api and api.Set then
                if type(val) == "table" and val.__enum then
                    local enumType = Enum[val.__enum]
                    if enumType then
                        pcall(function() api:Set(enumType[val.name], true) end)
                    end
                else
                    pcall(function() api:Set(val, true) end)
                end
            end
        end
        return true
    end

    ---------------------------------------------------------------------------
    -- Popup / Modal (settings-style floating page)
    ---------------------------------------------------------------------------
    function Window:Popup(opts)
        opts = opts or {}
        local pTitle = opts.Title or "Settings"
        local pIcon = opts.Icon or "lucide:settings"
        local pSize = opts.Size or UDim2.fromOffset(420, 480)

        local overlay = mk("TextButton", {
            Name = "PopupOverlay",
            BackgroundColor3 = Color3.new(0, 0, 0),
            BackgroundTransparency = 0.45,
            Text = "",
            AutoButtonColor = false,
            Size = UDim2.fromScale(1, 1),
            ZIndex = 700,
            Parent = screen,
        })

        local panel = mk("Frame", {
            Name = "Popup",
            BackgroundColor3 = T.Bg,
            BackgroundTransparency = math.clamp(glass, 0.02, 0.12),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = pSize,
            ZIndex = 710,
            Parent = screen,
        })
        corner(panel, rWin)
        stroke(panel, T.Stroke, 1, 0.4)

        local header = mk("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 48),
            ZIndex = 711,
            Parent = panel,
        })
        pad(header, 0, 14, 0, 14)
        local ih = makeIcon(header, pIcon, 16, T.TextDim, 712)
        ih.Position = UDim2.fromOffset(0, 16)
        mk("TextLabel", {
            BackgroundTransparency = 1,
            Font = Fonts.Title,
            TextSize = 15,
            TextColor3 = T.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = pTitle,
            Position = UDim2.fromOffset(24, 14),
            Size = UDim2.new(1, -64, 0, 22),
            ZIndex = 712,
            Parent = header,
        })
        local closeBtn = mk("TextButton", {
            BackgroundColor3 = T.BgInput,
            AutoButtonColor = false,
            Text = "",
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.fromOffset(28, 28),
            ZIndex = 712,
            Parent = header,
        })
        corner(closeBtn, rCtrl)
        local cx = makeIcon(closeBtn, "lucide:x", 14, T.TextDim, 713)
        cx.AnchorPoint = Vector2.new(0.5, 0.5)
        cx.Position = UDim2.fromScale(0.5, 0.5)

        mk("Frame", {
            BackgroundColor3 = T.Stroke,
            BackgroundTransparency = 0.55,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 14, 0, 48),
            Size = UDim2.new(1, -28, 0, 1),
            ZIndex = 711,
            Parent = panel,
        })

        local body = mk("ScrollingFrame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(0, 52),
            Size = UDim2.new(1, 0, 1, -60),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ZIndex = 711,
            Parent = panel,
        })
        styleScroll(body)
        pad(body, 12, 14, 18, 14)
        list(body, Enum.FillDirection.Vertical, 10)

        local Popup = {
            Title = pTitle,
            Frame = panel,
            Body = body,
            _closed = false,
        }

        local function destroy()
            if Popup._closed then return end
            Popup._closed = true
            overlay:Destroy()
            panel:Destroy()
            if opts.OnClose then task.spawn(opts.OnClose) end
        end
        Popup.Close = destroy
        Popup.Destroy = destroy
        closeBtn.MouseButton1Click:Connect(destroy)
        if opts.CloseOnOverlay ~= false then
            overlay.MouseButton1Click:Connect(destroy)
        end

        -- Isolated hidden page so Popup sections never land on Auto Join / first Farm page
        function Popup:Section(sopts)
            sopts = sopts or {}
            local secTitle = prettySectionTitle(sopts.Title or "Section")
            local hostTab = Window._tabs[1]
            if not hostTab then
                return nil
            end
            if not Window._popupHostPage then
                Window._popupHostPage = hostTab:Page({ Title = "_popup_host", Hidden = true })
            end
            local real = Window._popupHostPage:Section({
                Title = secTitle,
                Column = 1,
                Icon = sopts.Icon or sopts.Image,
            })
            if real and real.Frame and real.Frame.Parent then
                local secWrap = real.Frame.Parent
                if secWrap and secWrap:IsA("GuiObject") then
                    secWrap.Parent = body
                end
            end
            return real
        end

        return Popup
    end

    table.insert(VoidUI._windows, Window)

    if cfg.OpenCallback then
        task.spawn(cfg.OpenCallback, Window)
    end

    return Window
end

function VoidUI:SetAccent(color)
    Theme.Accent = color
end

return VoidUI

end)()

local VoidUIHubModule = (function()
--[[
    Steal An Egg hub — VoidUI (https://github.com/Sanchez1911/VoidUI)
]]

local VoidUIHub = {}

local EXECUTOR_IDENTITY = 8

local function withExecutorIdentity(fn)
    local previousIdentity

    if type(getthreadidentity) == "function" then
        local ok, value = pcall(getthreadidentity)

        if ok then
            previousIdentity = value
        end
    end

    if type(setthreadidentity) == "function" then
        pcall(setthreadidentity, EXECUTOR_IDENTITY)
    end

    local ok, result = pcall(fn)

    if type(setthreadidentity) == "function" and previousIdentity ~= nil then
        pcall(setthreadidentity, previousIdentity)
    end

    if not ok then
        error(result, 0)
    end

    return result
end

local function tryExecutorIdentity(fn)
    local ok, result = pcall(withExecutorIdentity, fn)

    return ok, result
end

local VOIDUI_SHA = "ed27ccf745d7835dd9e16245979407fb4440d2bb"
local VOIDUI_URL = "https://raw.githubusercontent.com/Sanchez1911/VoidUI/" .. VOIDUI_SHA .. "/VoidUI.lua"

local LOCAL_VOIDUI = {
    "Steal-An-Egg/EggESP/ui/VoidUI.lua",
    "EggESP/ui/VoidUI.lua",
}

local function loadVoidUI()
    local genv = (type(getgenv) == "function" and getgenv()) or _G

    if genv.__EGGESP_VOIDUI then
        return genv.__EGGESP_VOIDUI
    end

    local ok, body = pcall(function()
        return game:HttpGet(VOIDUI_URL)
    end)

    if ok and typeof(body) == "string" and #body > 500 then
        if body:find("Soft text bloom %(accent glow", 1, true) and not body:find("after mk", 1, true) then
            error("VoidUI stale cache — reopen with SHA URL", 0)
        end

        local fn, err = loadstring(body, "@VoidUI")

        if fn then
            local ok2, lib = pcall(fn)

            if ok2 and lib then
                genv.__EGGESP_VOIDUI = lib
                return lib
            end

            error("VoidUI exec: " .. tostring(lib), 0)
        end

        error("VoidUI compile: " .. tostring(err), 0)
    end

    if type(readfile) == "function" and type(loadstring) == "function" then
        local isfileFn = type(isfile) == "function" and isfile or nil

        for _, path in ipairs(LOCAL_VOIDUI) do
            if not isfileFn or isfileFn(path) then
                local readOk, source = pcall(readfile, path)

                if readOk and typeof(source) == "string" and #source > 500 then
                    local fn = loadstring(source, "@" .. path)

                    if fn then
                        local ok3, lib = pcall(fn)

                        if ok3 and lib then
                            genv.__EGGESP_VOIDUI = lib
                            return lib
                        end
                    end
                end
            end
        end
    end

    error("[NMHUB] VoidUI load failed — run hub via loadstring(readfile(...)) or check HttpGet", 0)
end

function VoidUIHub.create(deps)
    local Config = deps.Config
    local AutoFarm = deps.AutoFarm
    local SpeedBypass = deps.SpeedBypass
    local Diagnostics = deps.Diagnostics
    local PathService = deps.PathService
    local FarmFilters = deps.FarmFilters
    local FarmFilterUI = deps.FarmFilterUI
    local EggData = deps.EggData
    local BasePenAutomation = deps.BasePenAutomation
    local LocalPlayer = deps.LocalPlayer or game:GetService("Players").LocalPlayer
    local DrawingHub = deps.DrawingHub
    local RunService = deps.RunService or game:GetService("RunService")

    local theme = Config.Theme
    local runtime = Config.Runtime

    local VoidUI = nil
    local callbacks = {}
    local statusTask = nil
    local statusRunning = false
    local statusParagraph = nil
    local window = nil
    local controls = {}
    local useDrawingFallback = false
    local pendingVoidBuild = false
    local buildAttempts = 0
    local MAX_BUILD_ATTEMPTS = 40

    local function getVoidUI()
        if VoidUI then
            return VoidUI
        end

        VoidUI = loadVoidUI()
        return VoidUI
    end

    local function destroyOrphanVoidWindows()
        local genv = (type(getgenv) == "function" and getgenv()) or _G
        local lib = genv.__EGGESP_VOIDUI or VoidUI

        if not lib or not lib._windows then
            return
        end

        for i = #lib._windows, 1, -1 do
            local entry = lib._windows[i]

            pcall(function()
                if entry and entry.Destroy then
                    entry:Destroy()
                end
            end)
        end
    end

    local function activateDrawingFallback(reason)
        if useDrawingFallback or not DrawingHub then
            return false
        end

        destroyOrphanVoidWindows()

        useDrawingFallback = true
        pendingVoidBuild = false
        print("[NMHUB] VoidUI unavailable: " .. tostring(reason))
        print(string.format("[NMHUB] Using Drawing hub (%s to toggle)", (runtime.hubToggleKey or Enum.KeyCode.G).Name))

        if DrawingHub.SetCallbacks then
            DrawingHub.SetCallbacks(callbacks)
        end

        if DrawingHub.SetDiagnostics and Diagnostics then
            DrawingHub.SetDiagnostics(Diagnostics)
        end

        DrawingHub.Start()
        return true
    end

    local function setDiagnostics(diagnostics)
        Diagnostics = diagnostics
    end

    local function formatStatus()
        if not Diagnostics then
            return "Diagnostics unavailable"
        end

        local diag = Diagnostics.Collect()
        local lines = {
            string.format(
                "Eggs %d/%d | Phase: %s | Carrying: %s",
                diag.esp.eggsVisible,
                diag.esp.eggsTotal,
                diag.autoFarm.phase,
                tostring(diag.autoFarm.isCarrying)
            ),
        }

        if diag.autoFarm.target then
            local target = diag.autoFarm.target
            local zone = target.zone and ("[" .. target.zone .. "] ") or ""
            local tier = target.zoneTier and target.zoneTier > 0 and (" T" .. target.zoneTier) or ""

            table.insert(
                lines,
                string.format(
                    "Target: %s%s%s (%s) %dm",
                    zone,
                    target.name,
                    tier,
                    target.rarity,
                    target.distance
                )
            )
        elseif diag.autoFarm.bestCandidate then
            local candidate = diag.autoFarm.bestCandidate
            local zone = candidate.zone and ("[" .. candidate.zone .. "] ") or ""
            local tier = candidate.zoneTier and candidate.zoneTier > 0 and (" T" .. candidate.zoneTier) or ""

            table.insert(
                lines,
                string.format(
                    "Next: %s%s%s (%s) %dm",
                    zone,
                    candidate.name,
                    tier,
                    candidate.rarity,
                    candidate.distance
                )
            )
        else
            table.insert(lines, "Target: none")
        end

        if diag.inventory and diag.inventory.active then
            table.insert(
                lines,
                string.format("Inventory: %s (%s)", diag.inventory.phase, diag.inventory.detail or "")
            )
        end

        if diag.dayCycle and diag.dayCycle.blocked then
            table.insert(lines, "Night reset: waiting for day")
        end

        if diag.basePen then
            local pen = diag.basePen
            local penParts = {}

            if pen.claimableOffline and pen.claimableOffline > 0 then
                table.insert(penParts, string.format("claim $%d", pen.claimableOffline))
            end

            if pen.canUpgrade and pen.nextTier then
                table.insert(penParts, string.format("upgrade T%s ready", tostring(pen.nextTier)))
            end

            if pen.detail and pen.detail ~= "" then
                table.insert(penParts, pen.detail)
            end

            if #penParts > 0 then
                table.insert(lines, "Pen: " .. table.concat(penParts, " | "))
            end
        end

        if diag.autoFarm.targetMismatch then
            table.insert(lines, "Target stale — refreshing next tick")
        end

        return table.concat(lines, "\n")
    end

    local function syncAutoFarmToggle()
        if controls.autoFarm and controls.autoFarm.Set then
            local enabled = AutoFarm.GetStatus().enabled
            controls.autoFarm:Set(enabled, true)
        end
    end

    local function startStatusLoop()
        if statusRunning then
            return
        end

        statusRunning = true

        statusTask = task.spawn(function()
            while statusRunning and statusParagraph and statusParagraph.Set do
                if not window or not window.ScreenGui or not window.ScreenGui.Parent then
                    break
                end

                syncAutoFarmToggle()
                statusParagraph:Set(formatStatus())
                task.wait(runtime.hubStatusRefreshInterval or 0.5)
            end

            statusRunning = false
            statusTask = nil
        end)
    end

    local function stopStatusLoop()
        statusRunning = false
    end

    local function attachBuilt(state)
        if not state or not state.window then
            return false
        end

        window = state.window
        statusParagraph = state.statusParagraph
        controls = state.controls or {}
        VoidUI = state.voidUI or VoidUI
        pendingVoidBuild = false
        useDrawingFallback = false

        if window.SetVisible then
            window:SetVisible(runtime.hubVisible ~= false)
        end

        startStatusLoop()

        return true
    end

    local function getBuildContext()
        return {
            theme = theme,
            runtime = runtime,
            callbacks = callbacks,
            formatStatus = formatStatus,
            AutoFarm = AutoFarm,
            SpeedBypass = SpeedBypass,
            PathService = PathService,
            FarmFilters = FarmFilters,
            FarmFilterUI = FarmFilterUI,
            EggData = EggData,
            BasePenAutomation = BasePenAutomation,
            LocalPlayer = LocalPlayer,
        }
    end

    local function tryBuild()
        if window or useDrawingFallback or not pendingVoidBuild then
            return
        end

        pendingVoidBuild = false
        activateDrawingFallback("VoidUI not built — use loadstring(readfile(hub_loader))()")
    end

    local function setCallbacks(newCallbacks)
        callbacks = newCallbacks or {}

        if DrawingHub and DrawingHub.SetCallbacks then
            DrawingHub.SetCallbacks(callbacks)
        end
    end

    local function start()
        if useDrawingFallback then
            if DrawingHub then
                DrawingHub.Start()
            end

            return
        end

        if window then
            startStatusLoop()

            if window.SetVisible then
                window:SetVisible(runtime.hubVisible ~= false)
            end

            return
        end

        pendingVoidBuild = true
        tryBuild()
    end

    local function stop()
        if useDrawingFallback then
            if DrawingHub then
                DrawingHub.Stop()
            end

            return
        end

        stopStatusLoop()

        if window and window.SetVisible then
            window:SetVisible(false)
        end
    end

    local function destroy()
        if useDrawingFallback then
            if DrawingHub then
                DrawingHub.Destroy()
            end

            return
        end

        stopStatusLoop()

        if window and window.Destroy then
            window:Destroy()
        end

        window = nil
        statusParagraph = nil
        controls = {}
    end

    return {
        Start = start,
        Stop = stop,
        Destroy = destroy,
        TryBuild = tryBuild,
        GetBuildContext = getBuildContext,
        AttachBuilt = attachBuilt,
        ActivateDrawingFallback = activateDrawingFallback,
        Render = function(_camera)
            if useDrawingFallback and DrawingHub then
                DrawingHub.Render(_camera)
            end
        end,
        SetCallbacks = setCallbacks,
        SetVisible = function(value)
            runtime.hubVisible = value == true

            if useDrawingFallback and DrawingHub then
                DrawingHub.SetVisible(value)
                return
            end

            if window and window.SetVisible then
                window:SetVisible(runtime.hubVisible)
            end
        end,
        IsVisible = function()
            if useDrawingFallback and DrawingHub then
                return DrawingHub.IsVisible()
            end

            if window and window.Visible ~= nil then
                return window.Visible
            end

            return runtime.hubVisible ~= false
        end,
        ToggleVisible = function()
            if useDrawingFallback and DrawingHub then
                return DrawingHub.ToggleVisible()
            end

            if window and window.Toggle then
                window:Toggle()
                runtime.hubVisible = window.Visible
                return window.Visible
            end

            runtime.hubVisible = not (runtime.hubVisible ~= false)

            if window and window.SetVisible then
                window:SetVisible(runtime.hubVisible)
            end

            return runtime.hubVisible
        end,
        SetDiagnostics = function(diagnostics)
            setDiagnostics(diagnostics)

            if DrawingHub and DrawingHub.SetDiagnostics then
                DrawingHub.SetDiagnostics(diagnostics)
            end
        end,
    }
end

return VoidUIHub

end)()

local ControllerModule = (function()
--[[
    ESP lifecycle controller: start/stop render loop.
]]

local Controller = {}

function Controller.create(deps)
    local Config = deps.Config
    local RunService = deps.RunService
    local Workspace = deps.Workspace
    local DataCollector = deps.DataCollector
    local StackLayout = deps.StackLayout
    local DrawingPool = deps.DrawingPool
    local Renderer = deps.Renderer
    local BoundingBoxPool = deps.BoundingBoxPool
    local BoundingBoxRenderer = deps.BoundingBoxRenderer
    local AutoFarm = deps.AutoFarm
    local PetAutomation = deps.PetAutomation
    local BasePenAutomation = deps.BasePenAutomation
    local InventoryManager = deps.InventoryManager
    local Hub = deps.Hub

    local runtime = Config.Runtime

    local renderConnection = nil
    local logicConnection = nil
    local camera = Workspace.CurrentCamera
    local active = false

    local cachedTargets = {}
    local cachedVisible = {}
    local lastEspRefresh = 0
    local lastLogicTick = 0

    local function setHub(hub)
        Hub = hub
    end

    local function refreshEspData(now)
        cachedTargets = DataCollector.Collect()
        cachedVisible = StackLayout.Assign(cachedTargets, camera)
        lastEspRefresh = now
    end

    local function runLogicTick(now)
        if PetAutomation then
            PetAutomation.Tick()
        end

        if BasePenAutomation then
            BasePenAutomation.Tick()
        end

        if InventoryManager and InventoryManager.TickAutoPlace then
            InventoryManager.TickAutoPlace()
        end

        if InventoryManager and InventoryManager.TickAutoSell then
            InventoryManager.TickAutoSell()
        end

        if InventoryManager and InventoryManager.TickAutoDumpWorstEggs then
            InventoryManager.TickAutoDumpWorstEggs()
        end

        AutoFarm.Tick()
        lastLogicTick = now
    end

    local function renderVisuals()
        if not camera then
            camera = Workspace.CurrentCamera

            if not camera then
                return
            end
        end

        Renderer.RenderFrame(cachedVisible, DrawingPool)
        BoundingBoxRenderer.RenderFrame(cachedTargets, camera, BoundingBoxPool)

        if Hub then
            Hub.Render(camera)
        end
    end

    local function onRenderStep()
        local now = os.clock()
        local espInterval = runtime.espRefreshInterval or 0.12

        if now - lastEspRefresh >= espInterval then
            refreshEspData(now)
        end

        renderVisuals()
    end

    local function onLogicStep()
        local now = os.clock()
        local logicInterval = runtime.logicTickInterval or 0.1

        if now - lastLogicTick >= logicInterval then
            runLogicTick(now)
        end
    end

    local function start()
        if renderConnection then
            renderConnection:Disconnect()
        end

        if logicConnection then
            logicConnection:Disconnect()
        end

        lastEspRefresh = 0
        lastLogicTick = 0
        cachedTargets = {}
        cachedVisible = {}

        logicConnection = RunService.Heartbeat:Connect(onLogicStep)
        renderConnection = RunService.RenderStepped:Connect(onRenderStep)
        active = true

        if Hub then
            Hub.Start()
        end

        print("[NMHUB] Active")
    end

    local function stop()
        if renderConnection then
            renderConnection:Disconnect()
            renderConnection = nil
        end

        if logicConnection then
            logicConnection:Disconnect()
            logicConnection = nil
        end

        active = false
        cachedTargets = {}
        cachedVisible = {}
        DrawingPool.HideAll()
        BoundingBoxPool.HideAll()

        if Hub then
            Hub.Stop()
        end

        print("[NMHUB] Stopped")
    end

    local function destroy()
        stop()
        AutoFarm.Destroy()

        if Hub then
            Hub.Destroy()
        end

        DrawingPool.DestroyAll()
        BoundingBoxPool.DestroyAll()
    end

    return {
        Start = start,
        Stop = stop,
        Destroy = destroy,
        RenderOnce = function()
            onLogicStep()
            onRenderStep()
        end,
        IsActive = function()
            return active
        end,
        SetHub = setHub,
    }
end

return Controller

end)()

local Config = ConfigModule
local Util = UtilModule
genv0.__EGGESP_VOIDUI = VoidUIModule

local ROOT = "NMHUB"
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local deps = {
    Config = Config,
    Util = Util,
    Workspace = Workspace,
    RunService = RunService,
    UserInputService = UserInputService,
    LocalPlayer = Players.LocalPlayer,
    CollectionService = CollectionService,
    ReplicatedStorage = ReplicatedStorage,
    EggState = require(ReplicatedStorage.Client.EggState),
    Assets = require(ReplicatedStorage.Data.Assets),
    Areas = require(ReplicatedStorage.Data.Areas),
    Constants = require(ReplicatedStorage.Shared.Globals.Constants),
    Gears = require(ReplicatedStorage.Data.Gears),
    Rarity = require(ReplicatedStorage.Data.Rarity),
    PlotState = require(ReplicatedStorage.Client.PlotState),
    Save = require(ReplicatedStorage.Shared.Save),
    Treadmills = require(ReplicatedStorage.Data.Treadmills),
    TreadmillUtil = require(ReplicatedStorage.Shared.Util.TreadmillUtil),
    STATES = require(ReplicatedStorage.Shared.Types.AreaEggs).States,
    AreaEggSlotIdentity = require(ReplicatedStorage.Shared.Util.AreaEggSlotIdentity),
    Eggs = require(ReplicatedStorage.Shared.Types.Eggs),
    Remotes = require(ReplicatedStorage.Shared.Remotes),
    MonsterParasiteData = require(ReplicatedStorage.Data.MonsterParasite),
    AreaEggCycle = require(ReplicatedStorage.Shared.Util.AreaEggCycle),
    AreaEggResetCycle = require(ReplicatedStorage.Data.AreaEggResetCycle),
    AreaEggResetWall = require(ReplicatedStorage.Client.AreaEggResetWall),
    PlacedEggRenderer = require(ReplicatedStorage.Shared.Eggs.PlacedEggRenderer),
    AssetRoster = require(ReplicatedStorage.Client.AssetRoster),
}

local TextLayout = TextLayoutModule.create(deps)
deps.TextLayout = TextLayout

local FarmFilters = FarmFiltersModule.create(deps)
deps.FarmFilters = FarmFilters

local EggData = EggDataModule.create(deps)
local TreadmillData = TreadmillDataModule.create(deps)
local TrapData = TrapDataModule.create(deps)
local DataCollector = DataCollectorModule.create({
    EggData = EggData,
    TreadmillData = TreadmillData,
    TrapData = TrapData,
})
local StackLayout = StackLayoutModule.create(deps)
local DrawingPool = DrawingPoolModule.create(deps)
local BoundingBoxPool = BoundingBoxPoolModule.create(deps)
local Renderer = RendererModule.create(deps)
local BoundingBoxRenderer = BoundingBoxRendererModule.create(deps)
local Pathfinder = PathfinderModule.create()
local ObstacleData = ObstacleDataModule.create(deps)
local PathService = PathServiceModule.create({
    Config = Config,
    ObstacleData = ObstacleData,
    Pathfinder = Pathfinder,
})
local GuardZone = GuardZoneModule.create({
    Config = Config,
    Workspace = Workspace,
    ReplicatedStorage = ReplicatedStorage,
})
local Movement = MovementModule.create({
    Config = Config,
    LocalPlayer = deps.LocalPlayer,
    GuardZone = GuardZone,
})
deps.Movement = Movement

local DayCycle = DayCycleModule.create(deps)
local Passthrough = PassthroughModule.create(deps)
local SpeedBypass = SpeedBypassModule.create(deps)

-- SpeedBypass hooks fight simple tween movement; only wire when user enables it manually.

local InventoryManager = InventoryManagerModule.create(deps)
local PetAutomation = PetAutomationModule.create(deps)

local AutoFarm = AutoFarmModule.create({
    Config = Config,
    EggData = EggData,
    PathService = PathService,
    Movement = Movement,
    EggState = deps.EggState,
    AreaEggSlotIdentity = deps.AreaEggSlotIdentity,
    Passthrough = Passthrough,
    SpeedBypass = SpeedBypass,
    InventoryManager = InventoryManager,
    DayCycle = DayCycle,
    PetAutomation = PetAutomation,
    LocalPlayer = deps.LocalPlayer,
})

if InventoryManager.SetAutoFarm then
    InventoryManager.SetAutoFarm(AutoFarm)
end

local BasePenAutomation = BasePenAutomationModule.create({
    Config = Config,
    Save = deps.Save,
    Remotes = deps.Remotes,
    AssetRoster = deps.AssetRoster,
    PlotState = deps.PlotState,
    LocalPlayer = deps.LocalPlayer,
    Movement = Movement,
    AutoFarm = AutoFarm,
    ReplicatedStorage = ReplicatedStorage,
})

local Controller = ControllerModule.create({
    Config = Config,
    RunService = RunService,
    Workspace = Workspace,
    DataCollector = DataCollector,
    StackLayout = StackLayout,
    DrawingPool = DrawingPool,
    Renderer = Renderer,
    BoundingBoxPool = BoundingBoxPool,
    BoundingBoxRenderer = BoundingBoxRenderer,
    AutoFarm = AutoFarm,
    PetAutomation = PetAutomation,
    BasePenAutomation = BasePenAutomation,
    InventoryManager = InventoryManager,
    Hub = nil,
})

local Diagnostics = DiagnosticsModule.create({
    Config = Config,
    EggData = EggData,
    DataCollector = DataCollector,
    AutoFarm = AutoFarm,
    InventoryManager = InventoryManager,
    Passthrough = Passthrough,
    SpeedBypass = SpeedBypass,
    Controller = Controller,
    BasePenAutomation = BasePenAutomation,
    LocalPlayer = deps.LocalPlayer,
})

local DrawingHub = HubDrawingModule.create({
    Config = Config,
    Util = Util,
    UserInputService = UserInputService,
    AutoFarm = AutoFarm,
    SpeedBypass = SpeedBypass,
    PathService = PathService,
    Diagnostics = Diagnostics,
    FarmFilters = FarmFilters,
    FarmFilterUI = FarmFilterUIModule,
    EggData = EggData,
    BasePenAutomation = BasePenAutomation,
    LocalPlayer = deps.LocalPlayer,
})

local genv = (type(getgenv) == "function" and getgenv()) or _G
local forceDrawing = genv.__HUB_FORCE_DRAWING == true

local Hub = forceDrawing and DrawingHub or VoidUIHubModule.create({
    Config = Config,
    Util = Util,
    UserInputService = UserInputService,
    RunService = RunService,
    AutoFarm = AutoFarm,
    SpeedBypass = SpeedBypass,
    PathService = PathService,
    DrawingHub = DrawingHub,
    Diagnostics = Diagnostics,
    FarmFilters = FarmFilters,
    FarmFilterUI = FarmFilterUIModule,
    EggData = EggData,
    BasePenAutomation = BasePenAutomation,
    LocalPlayer = deps.LocalPlayer,
})

Controller.SetHub(Hub)

Hub.SetCallbacks({
    onAutoFarmStart = function()
        Config.Runtime.autoFarmEnabled = true
        AutoFarm.Start()
    end,
    onAutoFarmStop = function()
        Config.Runtime.autoFarmEnabled = false
        AutoFarm.Stop()
    end,
})

local function startAutoFarm()
    Config.Runtime.autoFarmEnabled = true
    return AutoFarm.Start()
end

local function stopAutoFarm()
    Config.Runtime.autoFarmEnabled = false
    return AutoFarm.Stop()
end

local API = {
    Root = ROOT,
    Start = Controller.Start,
    Stop = Controller.Stop,
    Destroy = Controller.Destroy,
    RenderOnce = Controller.RenderOnce,
    IsActive = Controller.IsActive,

    SetMaxDistance = function(studs)
        Config.Runtime.maxDistance = studs or math.huge
    end,

    SetAutoFarmMaxDistance = function(_studs)
        -- removed — auto farm has no max travel distance
    end,

    SetShowTreadmill = function(enabled)
        Config.Runtime.showTreadmill = enabled == true
    end,

    SetShowTreadmillBounds = function(enabled)
        Config.Runtime.showTreadmillBounds = enabled == true
    end,

    SetShowTraps = function(enabled)
        Config.Runtime.showTraps = enabled == true
    end,

    SetShowTrapBounds = function(enabled)
        Config.Runtime.showTrapBounds = enabled == true
    end,

    SetTreadmillBoundsMeters = function(scale)
        Config.Layout.treadmillBoundsPadding = math.max((scale or 10) / 10, 0.5)
    end,

    SetPathAvoidOwnTraps = function(enabled)
        Config.Runtime.pathAvoidOwnTraps = enabled == true
        PathService.Invalidate()
    end,

    StartAutoFarm = startAutoFarm,
    StopAutoFarm = stopAutoFarm,

    GetAutoFarmStatus = function()
        return AutoFarm.GetStatus()
    end,

    GetInventoryStatus = function()
        return InventoryManager.GetStatus()
    end,

    GetPetAutomationStatus = function()
        return PetAutomation.GetStatus()
    end,

    GetBasePenStatus = function()
        return BasePenAutomation.GetStatus()
    end,

    GetDayCycleStatus = function()
        return DayCycle.GetStatus()
    end,

    SetWaitForDayBeforeFarm = function(enabled)
        Config.Runtime.waitForDayBeforeFarm = enabled ~= false
    end,

    StartInventoryManage = function()
        return InventoryManager.Start()
    end,

    StopInventoryManage = function()
        return InventoryManager.Stop()
    end,

    GetDiagnostics = function()
        return Diagnostics.Collect()
    end,

    SetStandbyPosition = function(x, y, z)
        Config.Runtime.standbyPosition = Vector3.new(x, y, z)
        PathService.Invalidate()
    end,

    SetStandbyFromPlayer = function()
        local character = deps.LocalPlayer and deps.LocalPlayer.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")

        if rootPart then
            Config.Runtime.standbyPosition = rootPart.Position
            PathService.Invalidate()
            return rootPart.Position
        end

        return nil
    end,

    SetTweenSpeed = function(speed)
        Config.Runtime.tweenSpeed = math.clamp(speed or 700, 300, 1000)
    end,

    SetHubVisible = function(enabled)
        Hub.SetVisible(enabled == true)
    end,

    ToggleHub = function()
        return Hub.ToggleVisible()
    end,

    EnableSpeedBypass = function()
        SpeedBypass.Enable()
    end,

    DisableSpeedBypass = function()
        SpeedBypass.Disable()
    end,

    GetConfig = function()
        return Config
    end,

    Modules = {
        Config = Config,
        Util = Util,
        TextLayout = TextLayout,
        EggData = EggData,
        TreadmillData = TreadmillData,
        TrapData = TrapData,
        DataCollector = DataCollector,
        StackLayout = StackLayout,
        DrawingPool = DrawingPool,
        BoundingBoxPool = BoundingBoxPool,
        Renderer = Renderer,
        BoundingBoxRenderer = BoundingBoxRenderer,
        Pathfinder = Pathfinder,
        ObstacleData = ObstacleData,
        PathService = PathService,
        Movement = Movement,
        AutoFarm = AutoFarm,
        InventoryManager = InventoryManager,
        PetAutomation = PetAutomation,
        BasePenAutomation = BasePenAutomation,
        DayCycle = DayCycle,
        Passthrough = Passthrough,
        SpeedBypass = SpeedBypass,
        Diagnostics = Diagnostics,
        FarmFilters = FarmFilters,
        FarmFilterUI = FarmFilterUIModule,
        Hub = Hub,
        Controller = Controller,
    },
}

getgenv().EggESP = API
getgenv().NMHUB = API

return API
