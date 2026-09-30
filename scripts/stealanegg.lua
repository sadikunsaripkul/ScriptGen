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

-- Steal An Egg (struktur dipadankan daripada skrip awam: AreaEggSlotsClient + RF/EggWorld/*)
local RS = game:GetService("ReplicatedStorage")
local function net(name)
	local p = RS:FindFirstChild("Packages")
	local n = p and p:FindFirstChild("Networking")
	return n and n:FindFirstChild(name)
end
local function heldEgg()
	local c = player.Character
	if not c then return nil end
	for _, i in ipairs(c:GetChildren()) do
		if i:IsA("Tool") and i.Name:lower():find("egg") then return i end
	end
end
local home
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
	local r = root()
	if not r then return end
	home = home or r.CFrame
	local held = heldEgg()
	if held then
		local place = net("RF/EggWorld/AskPlaceEgg")
		local uid = held:GetAttribute("UID")
		if place and uid then
			r.CFrame = home
			task.wait(0.3)
			place:InvokeServer({ LocalCFrame = CFrame.new(0, 0, 0), Uid = uid })
		end
		return
	end
	local egg = nearestEgg(r)
	if not egg then return end
	r.CFrame = CFrame.new(egg.part.Position + Vector3.new(0, 2.5, 0))
	task.wait(0.15)
	local carry = net("RF/EggWorld/AskFieldEggCarry")
	if carry then
		carry:InvokeServer({ Uid = egg.uid })
	else
		local pp = egg.model:FindFirstChildWhichIsA("ProximityPrompt", true)
		if pp then fireproximityprompt(pp) end
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
