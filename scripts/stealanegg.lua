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

-- Steal An Egg: berjalan (bukan teleport) kerana game ada anti-teleport yang membunuh pemain
local RS = game:GetService("ReplicatedStorage")
local PFS = game:GetService("PathfindingService")
local function net(name)
	local p = RS:FindFirstChild("Packages")
	local n = p and p:FindFirstChild("Networking")
	return n and n:FindFirstChild(name)
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
end

local home
player.CharacterAdded:Connect(function(c)
	home = nil
	local r = c:WaitForChild("HumanoidRootPart", 10)
	task.wait(1)
	if r then home = r.Position end
end)

local function walkTo(target, timeout)
	local h, r = hum(), root()
	if not h or not r then return false end
	h.WalkSpeed = 24
	local t0 = os.clock()
	local path = PFS:CreatePath({ AgentRadius = 2, AgentHeight = 5, AgentCanJump = true })
	local ok = pcall(function() path:ComputeAsync(r.Position, target) end)
	local points = {}
	if ok and path.Status == Enum.PathStatus.Success then
		for _, w in ipairs(path:GetWaypoints()) do points[#points + 1] = w.Position end
	else
		points[1] = target
	end
	for _, p in ipairs(points) do
		h:MoveTo(p)
		while State.enabled and os.clock() - t0 < timeout do
			r = root()
			if not r or h.Health <= 0 then return false end
			if (Vector3.new(r.Position.X, 0, r.Position.Z) - Vector3.new(p.X, 0, p.Z)).Magnitude < 4 then break end
			task.wait(0.1)
		end
		if not State.enabled or os.clock() - t0 >= timeout then return false end
	end
	return true
end

local function nearestEgg(r)
	local folder = workspace:FindFirstChild("AreaEggSlotsClient")
	if not folder then return nil end
	local best, bd = nil, math.huge
	for _, m in ipairs(folder:GetChildren()) do
		local part = m:FindFirstChild("Hitbox") or (m:IsA("Model") and m.PrimaryPart) or m:FindFirstChildWhichIsA("BasePart")
		if part then
			local d = (part.Position - r.Position).Magnitude
			if d < bd then best, bd = { uid = m.Name, part = part, model = m }, d end
		end
	end
	return best
end

loop("egg", 0.5, function()
	local h, r = hum(), root()
	if not h or not r or h.Health <= 0 then return end
	home = home or r.Position
	if h.Health < h.MaxHealth * 0.5 then
		walkTo(home, 15)
		task.wait(3)
		return
	end
	local held = heldEgg()
	if held then
		if walkTo(home, 25) then
			local place = net("RF/EggWorld/AskPlaceEgg")
			local uid = held:GetAttribute("UID")
			if place and uid then
				place:InvokeServer({ LocalCFrame = CFrame.new(0, 0, 0), Uid = uid })
			end
		end
		return
	end
	local egg = nearestEgg(r)
	if not egg then return end
	if walkTo(egg.part.Position, 25) then
		local carry = net("RF/EggWorld/AskFieldEggCarry")
		if carry then
			carry:InvokeServer({ Uid = egg.uid })
		else
			local pp = egg.model:FindFirstChildWhichIsA("ProximityPrompt", true)
			if pp then fireproximityprompt(pp) end
		end
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
