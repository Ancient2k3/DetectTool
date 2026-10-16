local MODULE = {}

local function heuristic(p1, p2)
  return (p1 - p2).Magnitude
end

function MODULE.find_exit(spos, epos, node_list)
  local nodes = {}
  for _, pos in ipairs(node_list) do
    table.insert(nodes, pos)
  end
  
  local startNode = spos
  local endNode = epos
  
  table.insert(nodes, startNode)
  table.insert(nodes, endNode)
  
  local openSet = { [startNode] = true }
  local closedSet = {}
  local gScore = { [startNode] = 0 }
  local cameFrom = {}
  
  while next(openSet) ~= nil do
    local current = nil
    local lowestG = math.huge
    
    for node in pairs(openSet) do
      local score = gScore[node] or math.huge
      if score < lowestG then
        lowestG = score
        current = node
      end
    end
    
    if current == endNode then
      local path = {}
      local temp = current
      while temp do
        table.insert(path, 1, temp)
        temp = cameFrom[temp]
      end
      return path
    end
    
    openSet[current] = nil
    closedSet[current] = true
    
    for _, neighbor in ipairs(nodes) do
      if not closedSet[neighbor] and neighbor ~= current then
        
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        if game.Players.LocalPlayer and game.Players.LocalPlayer.Character then
          raycastParams.FilterDescendantsInstances = {game.Players.LocalPlayer.Character}
        end
        
        local direction = neighbor - current
        local raycastResult = workspace:Raycast(current, direction, raycastParams)
        
        if not raycastResult then
          local tentative_gScore = gScore[current] + direction.Magnitude
          if tentative_gScore < (gScore[neighbor] or math.huge) then
            cameFrom[neighbor] = current
            gScore[neighbor] = tentative_gScore
            openSet[neighbor] = true
          end
        end
        
      end
    end
  end
  
  return {}
end

return MODULE
