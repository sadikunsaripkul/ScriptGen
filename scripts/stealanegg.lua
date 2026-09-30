-- NM-Blox-Scripter
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local State = { enabled = false, runId = tostring(os.clock()) .. tostring(math.random(1, 1e9)) }
_G.NMRun = State.runId
local function root()
	local c = player.Character
	return c and c:FindFirstChild("HumanoidRootPart")
end
local function loop(name, delay, fn)
	task.spawn(function()
		while _G.NMRun == State.runId do
			if State.enabled then
				local ok, err = pcall(fn)
				if not ok then
					warn("[NM:" .. name .. "]", err)
					if State.onError then State.onError(tostring(err)) end
				end
			end
			task.wait(delay)
		end
	end)
end

-- Steal An Egg: tetingkap tetapan + pilih telur ikut rarity + tween laju pulang ke base
local RS = game:GetService("ReplicatedStorage")
local PFS = game:GetService("PathfindingService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local FILE = "NM-Blox-Scripter_StealAnEgg.json"
local Settings = { mode = "rarest", speed = 350, avoidGuard = false, autoPlace = true, rarities = {}, treadmill = false, esp = false, antiAfk = true, carryMode = true, carrySpeed = 1500, carryMethod = "teleport" }
local TREADMILL_PAD = 6
pcall(function()
	if isfile and isfile(FILE) then
		for k, v in pairs(HttpService:JSONDecode(readfile(FILE))) do Settings[k] = v end
	end
end)
local function saveSettings()
	pcall(function() if writefile then writefile(FILE, HttpService:JSONEncode(Settings)) end end)
end

local statusLabel
local function setStatus(t)
	if statusLabel then statusLabel.Text = t end
end
State.onError = function(e) setStatus("Ralat: " .. e) end

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

local rarityList = {}
do
	local seen = {}
	if Assets and Assets.Directory then
		for _, e in pairs(Assets.Directory) do
			local r = type(e) == "table" and e.Rarity
			if type(r) == "table" and r.DisplayName and not seen[r.DisplayName] then
				seen[r.DisplayName] = true
				rarityList[#rarityList + 1] = { name = r.DisplayName, tier = r.RarityNumber or 0 }
			end
		end
	end
	table.sort(rarityList, function(a, b) return a.tier < b.tier end)
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

local home, carrying, carryUid, cloned
local failed = {}
local savedSpeed = 16

player.CharacterAdded:Connect(function(c)
	home, carrying, carryUid, cloned = nil, false, nil, nil
	local r = c:WaitForChild("HumanoidRootPart", 10)
	task.wait(1)
	if r then home = r.Position end
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
	local speed = speedOverride or Settings.speed
	local dist = (pos - r.Position).Magnitude
	local tw = TweenService:Create(r, TweenInfo.new(math.max(dist / speed, 0.05), Enum.EasingStyle.Linear), { CFrame = CFrame.new(pos) })
	local finished = false
	tw.Completed:Connect(function() finished = true end)
	tw:Play()
	local t0 = os.clock()
	while not finished and (force or State.enabled) and h.Health > 0 and os.clock() - t0 < dist / speed + 3 do
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

-- opts: speed (override), force (jalan walau skrip OFF), allowTreadmill
local function travel(target, stopShort, opts)
	opts = opts or {}
	local avoid = not Settings.treadmill and not opts.allowTreadmill
	local r = root()
	if not r then return false end
	if avoid then
		local out, moved = pushOut(r.Position)
		if moved then
			setStatus("Keluar dari kawasan treadmill")
			if not tweenTo(out + Vector3.new(0, 3, 0), opts.speed, opts.force) then return false end
			r = root()
			if not r then return false end
		end
		target = pushOut(target)
	end
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
	if avoid then
		local out, prev = {}, r.Position
		for _, p in ipairs(points) do
			local d = detour(prev, p)
			if d then
				for _, c in ipairs(d) do out[#out + 1] = c end
			end
			out[#out + 1] = p
			prev = p
		end
		points = out
	end
	for i, p in ipairs(points) do
		local cur = root()
		if not (i > 1 and i < #points and cur and (p - cur.Position).Magnitude < 8) then
			if not tweenTo(p, opts.speed, opts.force) then return false end
		end
	end
	return true
end

local function inGuard(pos)
	if not (Settings.avoidGuard and GuardGeo) then return false end
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
						rarity = rar and rar.DisplayName or "?",
						color = rar and typeof(rar.Color) == "Color3" and rar.Color or nil,
						tier = rar and rar.RarityNumber or 0,
						weight = info and info.DropWeight or math.huge,
					}
				end
			end
		end
	else
		local folder = workspace:FindFirstChild("AreaEggSlotsClient")
		for _, m in ipairs(folder and folder:GetChildren() or {}) do
			local pos = eggPos(m.Name)
			if pos then list[#list + 1] = { uid = m.Name, pos = pos, rarity = "?", tier = 0, weight = 0 } end
		end
	end
	return list
end

local function pickEgg(r)
	local list = listEggs()
	local best
	for _, e in ipairs(list) do
		local skip = failed[e.uid] and os.clock() - failed[e.uid] < 20
		if not skip and Settings.rarities[e.rarity] ~= false and not inGuard(e.pos) then
			e.dist = (e.pos - r.Position).Magnitude
			local better
			if not best then
				better = true
			elseif Settings.mode == "nearest" then
				better = e.dist < best.dist
			else
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
	end
	task.wait(0.4)
	carrying, carryUid = false, nil
end

local mover = false
local function acquire()
	if mover then return false end
	mover = true
	return true
end
local function release() mover = false end

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

local function returnAndDeposit(speed, force)
	if not home then
		setStatus("Set base dahulu")
		return
	end
	local arrived
	if Settings.carryMode and Settings.carryMethod == "teleport" then
		setStatus("Teleport ke base")
		arrived = snapHome()
	else
		setStatus("Bawa telur balik ke base (laju)")
		arrived = travel(home, nil, { speed = speed, force = force, direct = Settings.carryMode })
	end
	if arrived then
		if Settings.autoPlace then
			setStatus("Letak telur")
			deposit()
		else
			setStatus("Di base (letak automatik OFF)")
			task.wait(1)
		end
	end
end

local function goTreadmill()
	local best, bd
	for _, rc in ipairs(treadmillRects()) do
		local d = home and (Vector3.new(rc.cx, 0, rc.cz) - Vector3.new(home.X, 0, home.Z)).Magnitude or 0
		if not bd or d < bd then best, bd = rc, d end
	end
	if not best then
		setStatus("Treadmill tidak dijumpai")
		return
	end
	local r = root()
	if r and r.Position.X > best.minX and r.Position.X < best.maxX and r.Position.Z > best.minZ and r.Position.Z < best.maxZ then
		setStatus("Melatih di treadmill")
		return
	end
	setStatus("Ke treadmill")
	travel(Vector3.new(best.cx, best.y + 3, best.cz), nil, { allowTreadmill = true })
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

do
	local r0 = root()
	if r0 then home = r0.Position end
end

-- Mod bawa telur: pegang telur -> terus pulang ke base pada kelajuan penuh (walau skrip OFF)
task.spawn(function()
	while _G.NMRun == State.runId do
		task.wait(0.05)
		if Settings.carryMode and not mover then
			local h = hum()
			if h and h.Health > 0 and (carrying or heldEgg()) and acquire() then
				local ok, err = pcall(returnAndDeposit, Settings.carrySpeed, true)
				release()
				if not ok then setStatus("Ralat: " .. tostring(err)) end
				task.wait(0.3)
			end
		end
	end
end)

-- ESP telur: Highlight ikut warna rarity + label nama rarity
local function clearEsp()
	local folder = workspace:FindFirstChild("AreaEggSlotsClient")
	for _, m in ipairs(folder and folder:GetChildren() or {}) do
		local h = m:FindFirstChild("NMESP")
		if h then h:Destroy() end
		local b = m:FindFirstChild("NMESPLabel")
		if b then b:Destroy() end
	end
end

task.spawn(function()
	local wasOn = false
	while _G.NMRun == State.runId do
		task.wait(1)
		if Settings.esp then
			wasOn = true
			pcall(function()
				local folder = workspace:FindFirstChild("AreaEggSlotsClient")
				if not folder then return end
				for _, e in ipairs(listEggs()) do
					local m = folder:FindFirstChild(e.uid)
					if m and not m:FindFirstChild("NMESP") then
						local col = e.color or Color3.fromHSV(math.clamp(e.tier / 10, 0, 1) * 0.8, 0.8, 1)
						local h = Instance.new("Highlight")
						h.Name = "NMESP"
						h.FillColor = col
						h.FillTransparency = 0.5
						h.OutlineColor = Color3.new(1, 1, 1)
						h.Adornee = m
						h.Parent = m
						local adornee = m:IsA("BasePart") and m or m:FindFirstChildWhichIsA("BasePart", true)
						if adornee then
							local b = Instance.new("BillboardGui")
							b.Name = "NMESPLabel"
							b.Size = UDim2.fromOffset(120, 22)
							b.StudsOffset = Vector3.new(0, 4, 0)
							b.AlwaysOnTop = true
							b.Adornee = adornee
							local t = Instance.new("TextLabel")
							t.Size = UDim2.fromScale(1, 1)
							t.BackgroundTransparency = 1
							t.Text = e.rarity
							t.TextColor3 = col
							t.TextStrokeTransparency = 0.3
							t.Font = Enum.Font.GothamBold
							t.TextSize = 14
							t.Parent = b
							b.Parent = m
						end
					end
				end
			end)
		elseif wasOn then
			wasOn = false
			pcall(clearEsp)
		end
	end
end)

-- Anti-AFK: klik maya bila Roblox mahu buang anda kerana idle
pcall(function()
	local VU = game:GetService("VirtualUser")
	player.Idled:Connect(function()
		if Settings.antiAfk then
			VU:CaptureController()
			VU:ClickButton2(Vector2.new())
		end
	end)
end)

-- Tetingkap tetapan
do
	local old = player.PlayerGui:FindFirstChild("NMBloxScripter")
	if old then old:Destroy() end
	local gui = Instance.new("ScreenGui")
	gui.Name = "NMBloxScripter"
	gui.ResetOnSpawn = false
	gui.Parent = player:WaitForChild("PlayerGui")

	local BG, PANEL, ACC = Color3.fromRGB(20, 20, 18), Color3.fromRGB(34, 34, 30), Color3.fromRGB(240, 169, 59)
	local win = Instance.new("Frame")
	win.Size = UDim2.fromOffset(300, 400)
	win.Position = UDim2.new(0, 20, 0.5, -200)
	win.BackgroundColor3 = BG
	win.Active = true
	win.Parent = gui
	Instance.new("UICorner", win).CornerRadius = UDim.new(0, 10)
	local stroke = Instance.new("UIStroke", win)
	stroke.Color = ACC
	stroke.Thickness = 1.5

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -40, 0, 32)
	title.Position = UDim2.fromOffset(10, 0)
	title.BackgroundTransparency = 1
	title.Text = "NM-Blox-Scripter v2 | Steal An Egg"
	title.TextColor3 = ACC
	title.Font = Enum.Font.GothamBold
	title.TextSize = 14
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = win

	local mini = Instance.new("TextButton")
	mini.Size = UDim2.fromOffset(28, 24)
	mini.Position = UDim2.new(1, -34, 0, 4)
	mini.BackgroundColor3 = PANEL
	mini.Text = "-"
	mini.TextColor3 = Color3.new(1, 1, 1)
	mini.Font = Enum.Font.GothamBold
	mini.Parent = win
	Instance.new("UICorner", mini)

	local body = Instance.new("ScrollingFrame")
	body.Size = UDim2.new(1, -12, 1, -40)
	body.Position = UDim2.fromOffset(6, 34)
	body.BackgroundTransparency = 1
	body.BorderSizePixel = 0
	body.ScrollBarThickness = 4
	body.AutomaticCanvasSize = Enum.AutomaticSize.Y
	body.CanvasSize = UDim2.new()
	body.Parent = win
	local layout = Instance.new("UIListLayout", body)
	layout.Padding = UDim.new(0, 5)

	mini.MouseButton1Click:Connect(function()
		body.Visible = not body.Visible
		win.Size = body.Visible and UDim2.fromOffset(300, 400) or UDim2.fromOffset(300, 32)
	end)
	UIS.InputBegan:Connect(function(i, gp)
		if not gp and i.KeyCode == Enum.KeyCode.RightShift then gui.Enabled = not gui.Enabled end
	end)

	local dragging, dragStart, startPos
	win.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			if i.Position.Y - win.AbsolutePosition.Y < 34 then
				dragging, dragStart, startPos = true, i.Position, win.Position
				i.Changed:Connect(function()
					if i.UserInputState == Enum.UserInputState.End then dragging = false end
				end)
			end
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - dragStart
			win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)

	local function btn(text, h)
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(1, -8, 0, h or 30)
		b.BackgroundColor3 = PANEL
		b.TextColor3 = Color3.new(1, 1, 1)
		b.Font = Enum.Font.Gotham
		b.TextSize = 13
		b.Text = text
		b.AutoButtonColor = true
		b.Parent = body
		Instance.new("UICorner", b)
		return b
	end
	local function header(text)
		local l = Instance.new("TextLabel")
		l.Size = UDim2.new(1, -8, 0, 20)
		l.BackgroundTransparency = 1
		l.Text = text
		l.TextColor3 = ACC
		l.Font = Enum.Font.GothamBold
		l.TextSize = 12
		l.TextXAlignment = Enum.TextXAlignment.Left
		l.Parent = body
	end
	local function toggle(text, get, set)
		local b = btn("")
		local function paint() b.Text = (get() and "[ON]  " or "[OFF] ") .. text; b.TextColor3 = get() and ACC or Color3.fromRGB(200, 200, 200) end
		b.MouseButton1Click:Connect(function() set(not get()); paint(); saveSettings() end)
		paint()
		return b
	end

	local master = btn("", 38)
	master.Font = Enum.Font.GothamBold
	local function paintMaster()
		master.Text = State.enabled and "SKRIP: ON (tekan untuk henti)" or "SKRIP: OFF (tekan untuk mula)"
		master.BackgroundColor3 = State.enabled and Color3.fromRGB(60, 120, 60) or Color3.fromRGB(120, 50, 50)
	end
	master.MouseButton1Click:Connect(function() State.enabled = not State.enabled; paintMaster() end)
	State.enabled = false
	paintMaster()

	statusLabel = Instance.new("TextLabel")
	statusLabel.Size = UDim2.new(1, -8, 0, 34)
	statusLabel.BackgroundColor3 = BG
	statusLabel.TextColor3 = Color3.fromRGB(180, 220, 180)
	statusLabel.Font = Enum.Font.Code
	statusLabel.TextSize = 12
	statusLabel.TextWrapped = true
	statusLabel.Text = "Status: menunggu"
	statusLabel.Parent = body

	header("PERGERAKAN")
	local speedBtn = btn("")
	local function paintSpeed() speedBtn.Text = "Kelajuan tween: " .. Settings.speed .. "  (klik: +50, lepas 700 ulang 100)" end
	speedBtn.MouseButton1Click:Connect(function()
		Settings.speed = Settings.speed >= 700 and 100 or Settings.speed + 50
		paintSpeed(); saveSettings()
	end)
	paintSpeed()
	local homeBtn = btn("Set base/rumah di posisi saya sekarang")
	homeBtn.MouseButton1Click:Connect(function()
		local r = root()
		if r then home = r.Position; setStatus("Base disimpan") end
	end)
	toggle("Elak zon pengawal/boss", function() return Settings.avoidGuard end, function(v) Settings.avoidGuard = v end)

	header("VISUAL & UTILITI")
	toggle("ESP telur (warna ikut rarity)", function() return Settings.esp end, function(v) Settings.esp = v end)
	toggle("Anti-AFK", function() return Settings.antiAfk end, function(v) Settings.antiAfk = v end)

	header("TREADMILL")
	toggle("Treadmill (latih bila tiada telur)", function() return Settings.treadmill end, function(v) Settings.treadmill = v end)
	local tn = btn("OFF = skrip elak kawasan treadmill", 22)
	tn.TextSize = 11
	tn.TextColor3 = Color3.fromRGB(150, 150, 150)

	header("BAWA TELUR")
	toggle("Auto pulang ke base bila pegang telur", function() return Settings.carryMode end, function(v) Settings.carryMode = v end)
	local methodBtn = btn("")
	local function paintMethod() methodBtn.Text = "Cara pulang: " .. (Settings.carryMethod == "teleport" and "TELEPORT terus (paling laju)" or "Tween lurus (selamat)") end
	methodBtn.MouseButton1Click:Connect(function()
		Settings.carryMethod = Settings.carryMethod == "teleport" and "tween" or "teleport"
		paintMethod(); saveSettings()
	end)
	paintMethod()
	local carryBtn = btn("")
	local function paintCarry() carryBtn.Text = "Kelajuan tween pulang: " .. Settings.carrySpeed .. "  (klik: +250, had 3000)" end
	carryBtn.MouseButton1Click:Connect(function()
		Settings.carrySpeed = Settings.carrySpeed >= 3000 and 500 or Settings.carrySpeed + 250
		paintCarry(); saveSettings()
	end)
	paintCarry()

	header("PILIHAN TELUR")
	local modeBtn = btn("")
	local function paintMode() modeBtn.Text = "Keutamaan: " .. (Settings.mode == "rarest" and "Paling jarang dahulu" or "Paling dekat dahulu") end
	modeBtn.MouseButton1Click:Connect(function()
		Settings.mode = Settings.mode == "rarest" and "nearest" or "rarest"
		paintMode(); saveSettings()
	end)
	paintMode()
	toggle("Letak telur di base automatik", function() return Settings.autoPlace end, function(v) Settings.autoPlace = v end)

	header("RARITY YANG DIAMBIL")
	if #rarityList == 0 then
		local l = btn("Senarai rarity tidak dijumpai (semua telur diambil)")
		l.AutoButtonColor = false
	end
	for _, rr in ipairs(rarityList) do
		toggle(rr.name, function() return Settings.rarities[rr.name] ~= false end, function(v) Settings.rarities[rr.name] = v end)
	end
end

local function eggStep()
	local h, r = hum(), root()
	if not h or not r or h.Health <= 0 then
		setStatus("Menunggu watak")
		return
	end
	home = home or r.Position
	if heldEgg() then carrying = true end

	if carrying then
		returnAndDeposit(Settings.carryMode and Settings.carrySpeed or nil)
		return
	end

	local egg = pickEgg(r)
	if not egg then
		if Settings.treadmill then
			goTreadmill()
		else
			setStatus("Tiada telur sepadan tetapan")
		end
		return
	end
	setStatus("Ke telur: " .. egg.rarity)
	if not travel(egg.pos, 12) then return end
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
		returnAndDeposit(Settings.carryMode and Settings.carrySpeed or nil)
	else
		failed[egg.uid] = os.clock()
		setStatus("Gagal ambil, langkau 20s")
	end
end

loop("egg", 0.5, function()
	if not acquire() then return end
	local ok, err = pcall(eggStep)
	release()
	if not ok then error(err, 0) end
end)
