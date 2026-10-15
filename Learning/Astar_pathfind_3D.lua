-- By Gemini
-- Định nghĩa kích thước khối lập phương trên lưới
local GRID_SIZE = 4 

-- 26 Hướng di chuyển trong không gian 3D (Trái, Phải, Lên, Xuống, Trước, Sau và các góc chéo)
local DIRECTIONS = {}
for x = -1, 1 do
	for y = -1, 1 do
		for z = -1, 1 do
			if not (x == 0 and y == 0 and z == 0) then
				table.insert(DIRECTIONS, Vector3.new(x, y, z))
			end
		end
	end
end

-- Hàm làm tròn vị trí về tâm của khối lập phương trên lưới 3D
local function snapToGrid(position: Vector3): Vector3
	local x = math.round(position.X / GRID_SIZE) * GRID_SIZE
	local y = math.round(position.Y / GRID_SIZE) * GRID_SIZE -- BẬT LÀM TRÒN Y CHO 3D
	local z = math.round(position.Z / GRID_SIZE) * GRID_SIZE
	return Vector3.new(x, y, z)
end

-- Hàm Heuristic tính khoảng cách đường chéo thẳng trong không gian 3D (Euclidean Distance)
local function heuristic(p1: Vector3, p2: Vector3): number
	return (p1 - p2).Magnitude
end

-- Kiểm tra va chạm trong không gian 3D (Khối hộp)
local function isWalkable(position: Vector3): boolean
	-- Tạo một hộp kiểm tra kích thước bằng với GRID_SIZE
	local size = Vector3.new(GRID_SIZE - 0.1, GRID_SIZE - 0.1, GRID_SIZE - 0.1)
	local overlapParams = OverlapParams.new()
	overlapParams.FilterType = Enum.RaycastFilterType.Exclude
	
	if game.Players.LocalPlayer.Character then
		overlapParams.FilterDescendantsInstances = {game.Players.LocalPlayer.Character}
	end
	
	-- Quét vùng không gian xem có Part nào chiếm chỗ không
	local parts = workspace:GetPartBoundsInBox(CFrame.new(position), size, overlapParams)
	return #parts == 0
end

local function toKey(v: Vector3): string
	return string.format("%d,%d,%d", v.X, v.Y, v.Z)
end

-- Hàm chính tìm đường thoát trong không gian 3D
local function find_exit(spos: Vector3, epos: Vector3): {Vector3}
	local startPos = snapToGrid(spos)
	local endPos = snapToGrid(epos)
	
	-- Nếu điểm đích bị chặn hoàn toàn bởi vật cản, tìm ô trống gần đích nhất
	if not isWalkable(endPos) then
		warn("Điểm đích bị chặn, đường đi có thể không tới chính xác vị trí!")
	end

	local openSet = {}   
	local closedSet = {} 
	local gScore = {}    
	local fScore = {}    
	local cameFrom = {}  
	
	local startKey = toKey(startPos)
	openSet[startKey] = startPos
	gScore[startKey] = 0
	fScore[startKey] = heuristic(startPos, endPos)
	
	while next(openSet) ~= nil do
		local current = nil
		local currentKey = nil
		local lowestF = math.huge
		
		for key, node in pairs(openSet) do
			local score = fScore[key] or math.huge
			if score < lowestF then
				lowestF = score
				current = node
				currentKey = key
			end
		end
		
		-- Điểm dừng: Khi khoảng cách đến đích nằm trong phạm vi 1 ô lưới
		if (current - endPos).Magnitude < (GRID_SIZE * 1.5) then
			local path = {}
			local temp = current
			local tempKey = currentKey
			
			while temp do
				table.insert(path, 1, temp)
				temp = cameFrom[tempKey]
				tempKey = temp and toKey(temp)
			end
			-- Thêm điểm đích thực tế vào cuối hàng đợi
			table.insert(path, epos) 
			return path
		end
		
		openSet[currentKey] = nil
		closedSet[currentKey] = true
		
		for _, dir in ipairs(DIRECTIONS) do
			local neighbor = current + (dir * GRID_SIZE)
			local neighborKey = toKey(neighbor)
			
			if not closedSet[neighborKey] and isWalkable(neighbor) then
				-- Tính toán chi phí dựa trên khoảng cách vector 3D (đi chéo sẽ tốn chi phí cao hơn đi thẳng)
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
