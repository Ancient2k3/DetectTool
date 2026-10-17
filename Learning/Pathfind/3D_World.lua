local GRID_SIZE = 4
local DIRECTIONS = {}
local MODULE = {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local PNT = Instance.new("Part")
PNT.Name = "Point_" .. tostring(math.random(1000, 9000))
PNT.Anchored = true
PNT.CanCollide = false
PNT.CanQuery = false
PNT.CastShadow = false
PNT.Transparency = 0.25
PNT.Material = Enum.Material.Neon
PNT.Size = Vector3.new(1, 1, 1)
PNT.Shape = Enum.PartType.Ball
PNT.Color = Color3.new(1, 1, 0)
PNT.Position = Vector3.new(0, 9e4, 0)
PNT.Parent = workspace

for x = -1, 1 do
	for y = -1, 1 do
		for z = -1, 1 do
			if x ~= 0 or y ~= 0 or z ~= 0 then
				table.insert(DIRECTIONS, Vector3.new(x, y, z))
			end
		end
	end
end

local function snapToGrid(position)
	return Vector3.new(
		math.round(position.X / GRID_SIZE) * GRID_SIZE,
		math.round(position.Y / GRID_SIZE) * GRID_SIZE,
		math.round(position.Z / GRID_SIZE) * GRID_SIZE
	)
end

local function heuristic(p1, p2)
	return (p1 - p2).Magnitude
end

local function toKey(v)
	return string.format("%d,%d,%d", v.X, v.Y, v.Z)
end

local function getRaycastParams()
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.IgnoreWater = true

	local exclude = {PNT}

	if LocalPlayer and LocalPlayer.Character then
		table.insert(exclude, LocalPlayer.Character)
	end

	params.FilterDescendantsInstances = exclude

	return params
end

local function raycastTo(fromPos, toPos)
	local direction = toPos - fromPos

	if direction.Magnitude <= 0.01 then
		return nil
	end

	return workspace:Raycast(fromPos, direction, getRaycastParams())
end

local function hasClearSight(fromPos, toPos)
	return raycastTo(fromPos, toPos) == nil
end

local function isWalkable(position)
	local size = Vector3.new(
		GRID_SIZE - 0.1,
		GRID_SIZE - 0.1,
		GRID_SIZE - 0.1
	)

	local params = OverlapParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude

	local exclude = {PNT}

	if LocalPlayer and LocalPlayer.Character then
		table.insert(exclude, LocalPlayer.Character)
	end

	params.FilterDescendantsInstances = exclude

	return #workspace:GetPartBoundsInBox(
		CFrame.new(position),
		size,
		params
	) == 0
end

local function reconstructPath(cameFrom, currentKey, current, endPos)
	local path = {}
	local node = current
	local key = currentKey

	while node do
		table.insert(path, 1, node)
		node = cameFrom[key]
		key = node and toKey(node)
	end

	if (path[#path] - endPos).Magnitude > 0.01 then
		table.insert(path, endPos)
	else
		path[#path] = endPos
	end

	return path
end

function MODULE.find_exit(spos, epos)
	local startPos = snapToGrid(spos)
	local endPos = snapToGrid(epos)

	if hasClearSight(spos, epos) then
		return {spos, epos}
	end

	local initialHit = raycastTo(spos, epos)
	local seedPos = initialHit and snapToGrid(initialHit.Position) or startPos

	local openSet = {}
	local closedSet = {}
	local gScore = {}
	local fScore = {}
	local cameFrom = {}

	local startKey = toKey(startPos)
	local seedKey = toKey(seedPos)

	openSet[startKey] = startPos
	gScore[startKey] = 0
	fScore[startKey] = heuristic(startPos, endPos)

	if seedKey ~= startKey and isWalkable(seedPos) then
		openSet[seedKey] = seedPos
		gScore[seedKey] = heuristic(startPos, seedPos)
		fScore[seedKey] = gScore[seedKey] + heuristic(seedPos, endPos)
		cameFrom[seedKey] = startPos
	end

	while next(openSet) do
		local current
		local currentKey
		local lowestF = math.huge

		for key, node in pairs(openSet) do
			local score = fScore[key] or math.huge

			if score < lowestF then
				lowestF = score
				current = node
				currentKey = key
			end
		end

		PNT.Position = current
		task.wait()

		if hasClearSight(current, epos) then
			return reconstructPath(cameFrom, currentKey, current, epos)
		end

		openSet[currentKey] = nil
		closedSet[currentKey] = true

		for _, dir in ipairs(DIRECTIONS) do
			local neighbor = current + dir * GRID_SIZE
			local neighborKey = toKey(neighbor)

			if not closedSet[neighborKey] and isWalkable(neighbor) then
				local tentativeG = gScore[currentKey] + dir.Magnitude * GRID_SIZE

				if tentativeG < (gScore[neighborKey] or math.huge) then
					cameFrom[neighborKey] = current
					gScore[neighborKey] = tentativeG
					fScore[neighborKey] = tentativeG + heuristic(neighbor, endPos)

					openSet[neighborKey] = neighbor
				end
			end
		end
	end

	return {}
end

return MODULE
