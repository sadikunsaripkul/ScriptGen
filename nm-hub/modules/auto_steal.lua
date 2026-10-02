-- NM-HUB — modules/auto_steal.lua
-- Enjin curi telur: pilih ikut rarity, gerak ke telur, bawa balik ke base, letak.
-- Tetapan dibaca daripada _G.NMHUB.filters: priority, stealMode, ignoreGuardian.
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local PFS = game:GetService("PathfindingService")
local TweenService = game:GetService("TweenService")

local M = {}
M.state = false
M.cfg = nil

local player = Players.LocalPlayer
local TWEEN_SPEED = 350
local CARRY_SPEED = 1500
local TREADMILL_PAD = 6

local home, carrying, carryUid, cloned, failed = nil, false, nil, nil, {}
local savedSpeed = 16
local mover = false

local function filters()
	_G.NMHUB.filters = _G.NMHUB.filters or {}
	return _G.NMHUB.filters
end

local function rankOf(r)
	local cfg = _G.NMHUB and _G.NMHUB.config
	return (cfg and cfg.RarityRank and cfg.RarityRank[r]) or 0
end

local function safeRequire(...)
	local cur = RS
	for _, n in ipairs({ ... }) do
		cur = cur and cur:FindFirstChild(n)
	end
	if not cur then return nil end
	local ok, m = pcall(require, cur)
	return ok and m or nil
end
local function net(name)
	local p = RS:FindFirstChild("Packages")
	local n = p and p:FindFirstChild("Networking")
	return n and n:FindFirstChild(name)
end

local Assets = safeRequire("Data", "Assets")
local EggState = safeRequire("Client", "EggState")
local AreaEggs = safeRequire("Shared", "Types", "AreaEggs")
local GuardGeo = safeRequire("Shared", "Util", "GuardAreaGeometry")
local STATES = AreaEggs and AreaEggs.States

local function root()
	local c = player.Character
	return c and c:FindFirstChild("HumanoidRootPart")
end
local function hum()
	local c = player.Character
	return c and c:FindFirstChildOfClass("Humanoid")
end
local function heldEgg()
	local c = player.Character
	if not c then return nil end
	for _, i in ipairs(c:GetChildren()) do
		if i:IsA("Tool") and i.Name:lower():find("egg") then return i end
	end
	return nil
end

local function setStatus(t)
	M.detail = t
end
M.detail = nil

player.CharacterAdded:Connect(function(c)
	home, carrying, carryUid, cloned = nil, false, nil, nil
	local r = c:WaitForChild("HumanoidRootPart", 10)
	task.wait(1)
	if r and not home then home = r.Position end
end)

local function prepHumanoid()
	local c, h = player.Character, hum()
	if not c or not h then return nil end
	if cloned ~= c then
		savedSpeed = h.WalkSpeed > 0 and h.WalkSpeed or 16
		h.Archivable = true
		local n = h:Clone()
		n.BreakJointsOnDeath = false
		h:Destroy()
		n.Parent = c
		if not n:FindFirstChildOfClass("Animator") then Instance.new("Animator", n) end
		cloned = c
		h = n
	end
	return h
end

local function tweenTo(pos, speedOverride, force)
	local h, r = prepHumanoid(), root()
	if not h or not r then return false end
	h.WalkSpeed = 0
	local speed = speedOverride or TWEEN_SPEED
	local dist = (pos - r.Position).Magnitude
	local tw = TweenService:Create(r, TweenInfo.new(math.max(dist / speed, 0.05), Enum.EasingStyle.Linear), { CFrame = CFrame.new(pos) })
	local finished = false
	tw.Completed:Connect(function() finished = true end)
	tw:Play()
	local t0 = os.clock()
	while not finished and (force or M.state) and h.Health > 0 and os.clock() - t0 < dist / speed + 3 do
		task.wait()
	end
	tw:Cancel()
	r.AssemblyLinearVelocity = Vector3.zero
	h.WalkSpeed = savedSpeed
	return finished
end

local function aabb(cf, size)
	local hx = (math.abs(cf.RightVector.X) * size.X + math.abs(cf.UpVector.X) * size.Y + math.abs(cf.LookVector.X) * size.Z) / 2
	local hz = (math.abs(cf.RightVector.Z) * size.X + math.abs(cf.UpVector.Z) * size.Y + math.abs(cf.LookVector.Z) * size.Z) / 2
	local p = cf.Position
	return { minX = p.X - hx - TREADMILL_PAD, maxX = p.X + hx + TREADMILL_PAD, minZ = p.Z - hz - TREADMILL_PAD, maxZ = p.Z + hz + TREADMILL_PAD, cx = p.X, cz = p.Z, y = p.Y }
end

local rectCache, rectAt = {}, 0
local function treadmillRects()
	if os.clock() - rectAt < 2 then return rectCache end
	rectAt = os.clock()
	local rects, seen = {}, {}
	local rf = workspace:FindFirstChild("__ClientTreadmillRenders")
	for _, m in ipairs(rf and rf:GetChildren() or {}) do
		local slot = m.Name:match("^TreadmillRender_(.+)$")
		if slot and m:IsA("Model") and not seen[slot] then
			seen[slot] = true
			local ok, cf, size = pcall(m.GetBoundingBox, m)
			if ok then rects[#rects + 1] = aabb(cf, size) end
		end
	end
	local plots = workspace:FindFirstChild("Plots")
	for _, plot in ipairs(plots and plots:GetChildren() or {}) do
		local bottom = plot:FindFirstChild("TreadmillBottom")
		if bottom and bottom:IsA("BasePart") and not seen[plot.Name] then
			seen[plot.Name] = true
			rects[#rects + 1] = aabb(bottom.CFrame, bottom.Size)
		end
	end
	rectCache = rects
	return rects
end

local function pushOut(pos)
	for _, rc in ipairs(treadmillRects()) do
		if pos.X > rc.minX and pos.X < rc.maxX and pos.Z > rc.minZ and pos.Z < rc.maxZ then
			local dl, dr, dd, du = pos.X - rc.minX, rc.maxX - pos.X, pos.Z - rc.minZ, rc.maxZ - pos.Z
			local m = math.min(dl, dr, dd, du)
			if m == dl then return Vector3.new(rc.minX - 2, pos.Y, pos.Z), true end
			if m == dr then return Vector3.new(rc.maxX + 2, pos.Y, pos.Z), true end
			if m == dd then return Vector3.new(pos.X, pos.Y, rc.minZ - 2), true end
			return Vector3.new(pos.X, pos.Y, rc.maxZ + 2), true
		end
	end
	return pos, false
end

local function clip(p, d, lo, hi, t0, t1)
	if math.abs(d) < 1e-6 then
		if p < lo or p > hi then return nil, nil end
		return t0, t1
	end
	local a, b = (lo - p) / d, (hi - p) / d
	if a > b then a, b = b, a end
	if a > t0 then t0 = a end
	if b < t1 then t1 = b end
	if t0 > t1 then return nil, nil end
	return t0, t1
end
local function segHits(a, b, rc)
	local t0, t1 = clip(a.X, b.X - a.X, rc.minX, rc.maxX, 0, 1)
	if not t0 then return false end
	t0, t1 = clip(a.Z, b.Z - a.Z, rc.minZ, rc.maxZ, t0, t1)
	return t0 ~= nil
end
local function detour(a, b)
	for _, rc in ipairs(treadmillRects()) do
		if segHits(a, b, rc) then
			local y = (a.Y + b.Y) / 2
			local cs = {}
			for _, cx in ipairs({ rc.minX - 2, rc.maxX + 2 }) do
				for _, cz in ipairs({ rc.minZ - 2, rc.maxZ + 2 }) do
					cs[#cs + 1] = Vector3.new(cx, y, cz)
				end
			end
			local best, bl
			for _, c in ipairs(cs) do
				if not segHits(a, c, rc) and not segHits(c, b, rc) then
					local l = (c - a).Magnitude + (b - c).Magnitude
					if not bl or l < bl then best, bl = { c }, l end
				end
			end
			for _, c1 in ipairs(cs) do
				for _, c2 in ipairs(cs) do
					if c1 ~= c2 and not segHits(a, c1, rc) and not segHits(c1, c2, rc) and not segHits(c2, b, rc) then
						local l = (c1 - a).Magnitude + (c2 - c1).Magnitude + (b - c2).Magnitude
						if not bl or l < bl then best, bl = { c1, c2 }, l end
					end
				end
			end
			if best then return best end
		end
	end
	return nil
end

local function travel(target, stopShort, opts)
	opts = opts or {}
	local r = root()
	if not r then return false end
	local out, moved = pushOut(r.Position)
	if moved then
		setStatus("Keluar dari kawasan treadmill")
		if not tweenTo(out + Vector3.new(0, 3, 0), opts.speed, opts.force) then return false end
		r = root()
		if not r then return false end
	end
	target = pushOut(target)
	local points = {}
	if not opts.direct then
		local path = PFS:CreatePath({ AgentRadius = 2, AgentHeight = 5, AgentCanJump = true })
		local ok = pcall(function() path:ComputeAsync(r.Position, target) end)
		if ok and path.Status == Enum.PathStatus.Success then
			for _, w in ipairs(path:GetWaypoints()) do points[#points + 1] = w.Position + Vector3.new(0, 3, 0) end
		end
	end
	if #points == 0 then points[1] = target + Vector3.new(0, 3, 0) end
	if stopShort then
		local last = points[#points]
		local prev = points[#points - 1] or r.Position
		local d = last - prev
		if d.Magnitude > stopShort then
			points[#points] = last - d.Unit * stopShort
		else
			points[#points] = nil
		end
	end
	local outPts, prev = {}, r.Position
	for _, p in ipairs(points) do
		local d = detour(prev, p)
		if d then
			for _, c in ipairs(d) do outPts[#outPts + 1] = c end
		end
		outPts[#outPts + 1] = p
		prev = p
	end
	points = outPts
	for i, p in ipairs(points) do
		local cur = root()
		if not (i > 1 and i < #points and cur and (p - cur.Position).Magnitude < 8) then
			if not tweenTo(p, opts.speed, opts.force) then return false end
		end
	end
	return true
end

local function inGuard(pos)
	local f = filters()
	if f.ignoreGuardian or not GuardGeo then return false end
	local areas = workspace:FindFirstChild("__OBJECTS")
	areas = areas and areas:FindFirstChild("Areas")
	areas = areas and areas:FindFirstChild("GuardAreas")
	if not areas then return false end
	local ok, res = pcall(function()
		for _, e in ipairs(GuardGeo.ReadAreaBounds(areas)) do
			if e.Bounds and e.Bounds.Parent and GuardGeo.IsWithinFootprint(e.Bounds, pos) then return true end
		end
		return false
	end)
	return ok and res
end

local function eggPos(uid)
	local folder = workspace:FindFirstChild("AreaEggSlotsClient")
	local m = (folder and folder:FindFirstChild(uid)) or workspace:FindFirstChild(uid)
	if not m then return nil end
	if m:IsA("Model") then return m:GetPivot().Position end
	if m:IsA("BasePart") then return m.Position end
	return nil
end

local function eggMap()
	return (_G.NMHUB and _G.NMHUB.eggmap) or {}
end

local function listEggs()
	local list = {}
	local okSnap, snap = false, nil
	if EggState and EggState.ReadFieldEggs then okSnap, snap = pcall(EggState.ReadFieldEggs) end
	if okSnap and type(snap) == "table" and snap.Records and STATES then
		for _, rec in ipairs(snap.Records) do
			if rec.State == STATES.Slot or rec.State == STATES.Dropped then
				local pos = eggPos(rec.Uid)
				local info = Assets and Assets.Directory and Assets.Directory[rec.AssetCategory]
				local rar = info and info.Rarity
				if pos then
					list[#list + 1] = {
						uid = rec.Uid, pos = pos,
						rarity = rar and rar.DisplayName or (eggMap()[rec.AssetCategory] or "?"),
						tier = (rar and rar.RarityNumber) or rankOf(rar and rar.DisplayName) or 0,
						weight = info and info.DropWeight or math.huge,
					}
				end
			end
		end
	else
		local folder = workspace:FindFirstChild("AreaEggSlotsClient")
		for _, m in ipairs(folder and folder:GetChildren() or {}) do
			local pos = eggPos(m.Name)
			if pos then list[#list + 1] = { uid = m.Name, pos = pos, rarity = eggMap()[m.Name] or "?", tier = rankOf(eggMap()[m.Name]), weight = 0 } end
		end
		if #list == 0 then
			for _, m in ipairs(workspace:GetDescendants()) do
				if m:IsA("Model") and eggMap()[m.Name] then
					local part = m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart")
					if part then
						list[#list + 1] = { uid = m.Name, pos = part.Position, rarity = eggMap()[m.Name], tier = rankOf(eggMap()[m.Name]), weight = 0 }
					end
				end
			end
		end
	end
	return list
end

local function pickEgg(r)
	local f = filters()
	local best
	for _, e in ipairs(listEggs()) do
		local skip = failed[e.uid] and os.clock() - failed[e.uid] < 20
		if not skip and not inGuard(e.pos) then
			e.dist = (e.pos - r.Position).Magnitude
			local better
			if not best then
				better = true
			elseif f.priority == "Nearest" or f.priority == "Fastest" then
				better = e.dist < best.dist
			elseif f.priority == "Biggest" then
				better = e.weight < best.weight or (e.weight == best.weight and e.dist < best.dist)
			else -- Rarest
				better = e.tier > best.tier
					or (e.tier == best.tier and e.weight < best.weight)
					or (e.tier == best.tier and e.weight == best.weight and e.dist < best.dist)
			end
			if better then best = e end
		end
	end
	return best
end

local function deposit()
	local place = net("RF/EggWorld/AskPlaceEgg")
	local held = heldEgg()
	local uid = (held and held:GetAttribute("UID")) or carryUid
	if place and uid then
		pcall(function() place:InvokeServer({ LocalCFrame = CFrame.new(0, 0, 0), Uid = uid }) end)
		return
	end
	local drop = net("RF/EggWorld/AskFieldEggDrop")
	if drop then pcall(function() drop:InvokeServer() end) end
end

local function snapHome()
	local h, r = prepHumanoid(), root()
	if not h or not r or not home then return false end
	local dest = pushOut(home)
	local cf = CFrame.new(dest + Vector3.new(0, 3, 0))
	r.CFrame = cf
	r.AssemblyLinearVelocity = Vector3.zero
	task.wait(0.1)
	r = root()
	if r and (r.Position - cf.Position).Magnitude > 8 then r.CFrame = cf end
	return true
end

local function returnAndDeposit(force)
	if not home then
		setStatus("Set base dahulu (butang Set Base)")
		return
	end
	local f = filters()
	local arrived
	if f.stealMode == "Teleport" then
		setStatus("Teleport ke base")
		arrived = snapHome()
	else
		setStatus("Bawa telur balik ke base (laju)")
		arrived = travel(home, nil, { speed = CARRY_SPEED, force = force, direct = true })
	end
	if arrived then
		setStatus("Letak telur")
		deposit()
		task.wait(0.4)
		carrying, carryUid = false, nil
	end
end

if EggState and EggState.CarryChanged then
	pcall(function()
		EggState.CarryChanged:Connect(function(s)
			if type(s) == "table" then
				carrying = s.IsCarrying == true
				carryUid = s.Uid
			end
		end)
	end)
end

local function acquire()
	if mover then return false end
	mover = true
	return true
end

local function eggStep()
	local h, r = hum(), root()
	if not h or not r or h.Health <= 0 then
		setStatus("Menunggu watak")
		return
	end
	if not home then home = r.Position end
	if heldEgg() then carrying = true end

	if carrying then
		returnAndDeposit(false)
		return
	end

	local egg = pickEgg(r)
	if not egg then
		setStatus("Tiada telur sepadan")
		return
	end
	setStatus("Ke telur: " .. egg.rarity)
	if not travel(egg.pos, 12, {}) then return end
	local hh = hum()
	if hh then hh:MoveTo(egg.pos) end
	task.wait(0.5)
	local carry = net("RF/EggWorld/AskFieldEggCarry")
	if not carry then
		setStatus("Remote ambil telur tidak dijumpai")
		return
	end
	local ok, res = pcall(function() return carry:InvokeServer({ Uid = egg.uid }) end)
	if ok and res ~= false then
		carrying, carryUid = true, egg.uid
		setStatus("Dapat " .. egg.rarity .. ", pulang")
		returnAndDeposit(false)
	else
		failed[egg.uid] = os.clock()
		setStatus("Gagal ambil, langkau 20s")
	end
end

function M.setBase()
	local r = root()
	if r then
		home = r.Position
		setStatus("Base disimpan")
	end
end

function M.start(cfg)
	if M.state then return end
	M.state = true
	M.cfg = cfg
	local r0 = root()
	if r0 and not home then home = r0.Position end
	task.spawn(function()
		while M.state do
			if acquire() then
				local ok, err = pcall(eggStep)
				mover = false
				if not ok then setStatus("Ralat: " .. tostring(err)) end
			end
			task.wait(0.3)
		end
	end)
end

function M.stop()
	M.state = false
	setStatus("Berhenti")
end

function M.setConfig(cfg) M.cfg = cfg end
function M.getStatus()
	return { running = M.state, carrying = carrying, home = home, detail = M.detail }
end

return M
