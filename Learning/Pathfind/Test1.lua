local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local CONFIG = {
	MaxBounces = 100,
	RayLength = 500,
	LookAheadPadding = 0.05
}

local function find_target(start_pos, end_pos)
	local pathNodes = { start_pos }
	
	local randomDir = Vector3.new(
		math.random(-100, 100),
		math.random(-100, 100),
		math.random(-100, 100)
	)
	if randomDir.Magnitude == 0 then randomDir = Vector3.new(0, 1, 0) end
	local currentDir = randomDir.Unit
	
	local currentPos = start_pos
	local bounceCount = 0
	
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	
	local character = Players.LocalPlayer and Players.LocalPlayer.Character
	if character then
		raycastParams.FilterDescendantsInstances = { character }
	end

	while bounceCount < CONFIG.MaxBounces do
		local toTargetDir = (end_pos - currentPos)
		local targetCheck = Workspace:Raycast(currentPos, toTargetDir, raycastParams)
		
		if not targetCheck then
			table.insert(pathNodes, end_pos)
			return pathNodes
		end
		
		local hit = Workspace:Raycast(currentPos, currentDir * CONFIG.RayLength, raycastParams)
		
		if hit then
			bounceCount = bounceCount + 1
			
			local cornerPos = hit.Position
			local safetyStopPos = hit.Position + (hit.Normal * CONFIG.LookAheadPadding)
			
			table.insert(pathNodes, cornerPos)
			
			currentDir = currentDir - (2 * currentDir:Dot(hit.Normal) * hit.Normal)
			currentDir = currentDir.Unit
			currentPos = safetyStopPos
			
			if (end_pos - currentPos).Magnitude < 1 then
				table.insert(pathNodes, end_pos)
				return pathNodes
			end
		else
			break
		end
	end
	
	return nil
end
