-- NM-Blox-Scripter
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local State = { enabled = false }
local function root()
	local c = player.Character
	return c and c:FindFirstChild("HumanoidRootPart")
end
local function loop(name, delay, fn)
	task.spawn(function()
		while true do
			if State.enabled then
				local ok, err = pcall(fn)
				if not ok then warn("[NM:" .. name .. "]", err) end
			end
			task.wait(delay)
		end
	end)
end

-- Steal An Egg: pilih telur paling jarang, tween laju ke telur, bawa balik ke base serta-merta
local RS = game:GetService("ReplicatedStorage")
local PFS = game:GetService("PathfindingService")
local TweenService = game:GetService("TweenService")

local TWEEN_SPEED = 350 -- stud sesaat
local AVOID_GUARD = false -- true: langkau telur dalam zon pengawal (boss)

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

-- Tween melalui Humanoid klon supaya server tidak menganggapnya teleport
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

local function tweenTo(pos)
	local h, r = prepHumanoid(), root()
	if not h or not r then return false end
	h.WalkSpeed = 0
	local dist = (pos - r.Position).Magnitude
	local tw = TweenService:Create(r, TweenInfo.new(math.max(dist / TWEEN_SPEED, 0.05), Enum.EasingStyle.Linear), { CFrame = CFrame.new(pos) })
	local done = false
	tw.Completed:Connect(function() done = true end)
	tw:Play()
	local t0 = os.clock()
	while not done and State.enabled and h.Health > 0 and os.clock() - t0 < dist / TWEEN_SPEED + 3 do
		task.wait()
	end
	tw:Cancel()
	r.AssemblyLinearVelocity = Vector3.zero
	h.WalkSpeed = savedSpeed
	return done
end

local function travel(target, stopShort)
	local r = root()
	if not r then return false end
	local points = {}
	local path = PFS:CreatePath({ AgentRadius = 2, AgentHeight = 5, AgentCanJump = true })
	local ok = pcall(function() path:ComputeAsync(r.Position, target) end)
	if ok and path.Status == Enum.PathStatus.Success then
		for _, w in ipairs(path:GetWaypoints()) do points[#points + 1] = w.Position + Vector3.new(0, 3, 0) end
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
	for i, p in ipairs(points) do
		local cur = root()
		if i > 1 and i < #points and cur and (p - cur.Position).Magnitude < 8 then continue end
		if not tweenTo(p) then return false end
	end
	return true
end

local function inGuard(pos)
	if not (AVOID_GUARD and GuardGeo) then return false end
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
end

-- Pilih rarity tertinggi dahulu, kemudian drop weight terendah, kemudian jarak
local function pickEgg(r)
	local list = {}
	local snap = EggState and EggState.ReadFieldEggs and select(2, pcall(EggState.ReadFieldEggs))
	if type(snap) == "table" and snap.Records and STATES then
		for _, rec in ipairs(snap.Records) do
			if rec.State == STATES.Slot or rec.State == STATES.Dropped then
				local pos = eggPos(rec.Uid)
				local info = Assets and Assets.Directory and Assets.Directory[rec.AssetCategory]
				if pos then
					list[#list + 1] = {
						uid = rec.Uid, pos = pos,
						tier = info and info.Rarity and info.Rarity.RarityNumber or 0,
						weight = info and info.DropWeight or math.huge,
					}
				end
			end
		end
	else
		local folder = workspace:FindFirstChild("AreaEggSlotsClient")
		for _, m in ipairs(folder and folder:GetChildren() or {}) do
			local pos = eggPos(m.Name)
			if pos then list[#list + 1] = { uid = m.Name, pos = pos, tier = 0, weight = 0 } end
		end
	end
	local best
	for _, e in ipairs(list) do
		if not (failed[e.uid] and os.clock() - failed[e.uid] < 20) and not inGuard(e.pos) then
			e.dist = (e.pos - r.Position).Magnitude
			if not best or e.tier > best.tier
				or (e.tier == best.tier and e.weight < best.weight)
				or (e.tier == best.tier and e.weight == best.weight and e.dist < best.dist) then
				best = e
			end
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
	task.wait(1.5)
	carrying, carryUid = false, nil
end

loop("egg", 0.5, function()
	local h, r = hum(), root()
	if not h or not r or h.Health <= 0 then return end
	home = home or r.Position
	if heldEgg() then carrying = true end

	if carrying then
		if travel(home) then deposit() end
		return
	end

	local egg = pickEgg(r)
	if not egg then return end
	if not travel(egg.pos, 12) then return end
	local hh, rr = hum(), root()
	if hh and rr then hh:MoveTo(egg.pos) end
	task.wait(0.5)
	local carry = net("RF/EggWorld/AskFieldEggCarry")
	if not carry then return end
	local ok, res = pcall(function() return carry:InvokeServer({ Uid = egg.uid }) end)
	if ok and res ~= false then
		carrying, carryUid = true, egg.uid
		travel(home) -- balik serta-merta tanpa tunggu gelung seterusnya
		if carrying then deposit() end
	else
		failed[egg.uid] = os.clock()
	end
end)

-- Menu on/off
local gui = Instance.new("ScreenGui")
gui.Name = "NMMenu"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")
local btn = Instance.new("TextButton")
btn.Size = UDim2.fromOffset(140, 36)
btn.Position = UDim2.new(1, -150, 0, 10)
btn.BackgroundColor3 = Color3.fromRGB(26, 26, 23)
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Text = "NM: ON"
btn.Parent = gui
State.enabled = true
btn.MouseButton1Click:Connect(function()
	State.enabled = not State.enabled
	btn.Text = "NM: " .. (State.enabled and "ON" or "OFF")
end)
