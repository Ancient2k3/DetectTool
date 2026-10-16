local GRID_SIZE = ... or 4
local DIRECTIONS = {}
local MODULE = {}

local PNT = Instance.new("Part", workspace)
PNT.Name = "Point_"..tostring(math.random(1000, 9000))
PNT.Anchored = true
PNT.CanCollide = false
PNT.CastShadow = false
PNT.Transparency = 0.25
PNT.Material = Enum.Material.Neon
PNT.Size = Vector3.new(1, 1, 1)
PNT.Shape = "Ball"
PNT.Color = Color3.new(1, 1, 0)
PNT.Position = Vector3.new(0, 9e4, 0)

for x = -1, 1 do
  for y = -1, 1 do
	for z = -1, 1 do
	  if not (x == 0 and y == 0 and z == 0) then
	    table.insert(DIRECTIONS, Vector3.new(x, y, z))
	  end
	end
  end
end

function snapToGrid(position)
  local x = math.round(position.X / GRID_SIZE) * GRID_SIZE
  local y = math.round(position.Y / GRID_SIZE) * GRID_SIZE
  local z = math.round(position.Z / GRID_SIZE) * GRID_SIZE
  return Vector3.new(x, y, z)
end

function heuristic(p1, p2)
  return (p1 - p2).Magnitude
end

function isWalkable(position, startPos, endPos)
  local size = Vector3.new(GRID_SIZE - 0.1, GRID_SIZE - 0.1, GRID_SIZE - 0.1)
  local overlapParams = OverlapParams.new()
  overlapParams.FilterType = Enum.RaycastFilterType.Exclude
  if game.Players.LocalPlayer.Character then
    overlapParams.FilterDescendantsInstances = {game.Players.LocalPlayer.Character}
  end
  local parts = workspace:GetPartBoundsInBox(CFrame.new(position), size, overlapParams)
  if #parts > 0 then return false end

  local dirToTarget = (endPos - startPos).Unit
  local dirToNode = (position - startPos)
  local projection = dirToNode:Dot(dirToTarget)
  local closestPoint = startPos + dirToTarget * projection
  if (position - closestPoint).Magnitude < (GRID_SIZE * 0.5) then
    return true
  end

  local checkDirections = {
    Vector3.new(1, 0, 0), Vector3.new(-1, 0, 0),
    Vector3.new(0, 1, 0), Vector3.new(0, -1, 0),
    Vector3.new(0, 0, 1), Vector3.new(0, 0, -1)
  }
  local raycastParams = RaycastParams.new()
  raycastParams.FilterType = Enum.RaycastFilterType.Exclude
  if game.Players.LocalPlayer.Character then
    raycastParams.FilterDescendantsInstances = {game.Players.LocalPlayer.Character}
  end
  for _, checkDir in ipairs(checkDirections) do
    local raycastResult = workspace:Raycast(position, checkDir * GRID_SIZE, raycastParams)
    if raycastResult then
      return true
    end
  end

  return false
end

function toKey(v)
  return string.format("%d,%d,%d", v.X, v.Y, v.Z)
end

function MODULE.find_exit(spos, epos)
  local startPos = snapToGrid(spos)
  local endPos = snapToGrid(epos)
  local openSet = {}   
  local closedSet = {} 
  local gScore = {}    
  local fScore = {}    
  local cameFrom = {}
  local startKey = toKey(startPos)
  openSet[startKey] = startPos
  gScore[startKey] = 0
  fScore[startKey] = heuristic(startPos, endPos)
  while next(openSet) ~= nil do task.wait()
	local current = nil
	local currentKey = nil
	local lowestF = math.huge
	for key, node in pairs(openSet) do
	  local score = fScore[key] or math.huge
	  if score < lowestF then
		lowestF = score
		current = node
	    PNT.Position = current
		currentKey = key
	  end
	end
	if (current - endPos).Magnitude < (GRID_SIZE * 1.5) then
	  local path = {}
	  local temp = current
	  local tempKey = currentKey
	  while temp do task.wait()
		table.insert(path, 1, temp)
		temp = cameFrom[tempKey]
		tempKey = temp and toKey(temp)
	  end
	  table.insert(path, epos) 
	  return path
	end
	openSet[currentKey] = nil
	closedSet[currentKey] = true
	for _, dir in ipairs(DIRECTIONS) do
	  local neighbor = current + (dir * GRID_SIZE)
	  local neighborKey = toKey(neighbor)
	  if not closedSet[neighborKey] and isWalkable(neighbor, startPos, endPos) then
		local tentative_gScore = gScore[currentKey] + (dir.Magnitude * GRID_SIZE)
		if tentative_gScore < (gScore[neighborKey] or math.huge) then
		  cameFrom[neighborKey] = current
		  gScore[neighborKey] = tentative_gScore
		  fScore[neighborKey] = tentative_gScore + heuristic(neighbor, endPos)
		  if not openSet[neighborKey] then
			openSet[neighborKey] = neighbor
		  end
		end
	  end
	end
  end
  return {} 
end

return MODULE
