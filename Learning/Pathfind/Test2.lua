local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local plr = Players.LocalPlayer

local tool = Instance.new("Tool")
tool.RequiresHandle = false
tool.Name = "Bouncy Path Visualizer"
tool.Parent = plr:WaitForChild("Backpack")

local CONFIG = {
	Speed = 60,
	BallSize = Vector3.new(1.5, 1.5, 1.5),
	MaxBounces = 20,
	VisualizationDuration = 0.05,
	LookAheadPadding = 0.5 
}

local function getNearestPlayer(originPosition)
	local nearestPlr = nil
	local minDistance = math.huge
	
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= plr and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = player.Character.HumanoidRootPart
			local dist = (hrp.Position - originPosition).Magnitude
			if dist < minDistance then
				minDistance = dist
				nearestPlr = player
			end
		end
	end
	return nearestPlr
end

local function drawLine(from, to, color, thickness)
	local dist = (from - to).Magnitude
	if dist == 0 then return end
	
	local line = Instance.new("Part")
	line.Size = Vector3.new(thickness or 0.2, thickness or 0.2, dist)
	line.CFrame = CFrame.new(from:Lerp(to, 0.5), to)
	line.Anchored = true
	line.CanCollide = false
	line.Material = Enum.Material.Neon
	line.Color = color or Color3.new(0, 1, 0)
	line.Transparency = 0.3
	line.Parent = Workspace
	
	Debris:AddItem(line, CONFIG.VisualizationDuration)
end

local function spawnProjectile(startPos, startDir)
	local ball = Instance.new("Part")
	ball.Size = CONFIG.BallSize
	ball.Shape = Enum.PartType.Ball
	ball.Color = Color3.new(1, 0.5, 0)
	ball.Material = Enum.Material.Neon
	ball.Anchored = true
	ball.CanCollide = false
	ball.Position = startPos
	ball.Parent = Workspace
	
	local currentPos = startPos
	local currentDir = startDir.Unit
	local bounceCount = 0
	
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {ball, plr.Character}
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude

	local connection
	connection = RunService.Heartbeat:Connect(function(dt)
		if not ball or not ball.Parent then 
			connection:Disconnect()
			return 
		end
		
		local moveDistance = CONFIG.Speed * dt
		local checkDistance = moveDistance + CONFIG.LookAheadPadding
		
		local hit = Workspace:Raycast(currentPos, currentDir * checkDistance, raycastParams)
		
		if hit then
			bounceCount = bounceCount + 1
			if bounceCount > CONFIG.MaxBounces then
				ball:Destroy()
				connection:Disconnect()
				return
			end
			
			local safetyStopPos = hit.Position + (hit.Normal * CONFIG.LookAheadPadding)
			drawLine(currentPos, safetyStopPos, Color3.new(0, 1, 0), 0.3)
			
			currentDir = currentDir - (2 * currentDir:Dot(hit.Normal) * hit.Normal)
			currentDir = currentDir.Unit
			currentPos = safetyStopPos
		else
			local targetPos = currentPos + (currentDir * moveDistance)
			drawLine(currentPos, targetPos, Color3.new(0, 1, 0), 0.3)
			currentPos = targetPos
		end
		
		ball.Position = currentPos
		
		local nearestTarget = getNearestPlayer(currentPos)
		if nearestTarget and nearestTarget.Character:FindFirstChild("HumanoidRootPart") then
			local targetHrp = nearestTarget.Character.HumanoidRootPart
			local toPlayerDir = (targetHrp.Position - currentPos)
			
			local pathParams = RaycastParams.new()
			pathParams.FilterDescendantsInstances = {ball, plr.Character, nearestTarget.Character}
			pathParams.FilterType = Enum.RaycastFilterType.Exclude
			
			local pathCheck = Workspace:Raycast(currentPos, toPlayerDir, pathParams)
			
			if not pathCheck then
				drawLine(currentPos, targetHrp.Position, Color3.new(1, 0, 0), 0.15)
			end
		end
	end)
	
	Debris:AddItem(ball, 10)
end

tool.Activated:Connect(function()
	local character = plr.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then return end
	
	local mouse = plr:GetMouse()
	local spawnPos = character.HumanoidRootPart.Position + (character.HumanoidRootPart.CFrame.LookVector * 2)
	local targetPos = mouse.Hit.Position
	local direction = (targetPos - spawnPos).Unit
	
	spawnProjectile(spawnPos, direction)
end)
