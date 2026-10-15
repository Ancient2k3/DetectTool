-- By Gemini
-- Định nghĩa kích thước của mỗi ô vuông trên lưới (Grid Size)
local GRID_SIZE = 4 

-- Các hướng di chuyển xung quanh một ô (8 hướng trên mặt phẳng XZ)
local DIRECTIONS = {
	Vector3.new(1, 0, 0), Vector3.new(-1, 0, 0),
	Vector3.new(0, 0, 1), Vector3.new(0, 0, -1),
	Vector3.new(1, 0, 1), Vector3.new(1, 0, -1),
	Vector3.new(-1, 0, 1), Vector3.new(-1, 0, -1)
}

-- Hàm làm tròn vị trí thực tế về tọa độ lưới
local function snapToGrid(position: Vector3): Vector3
	local x = math.round(position.X / GRID_SIZE) * GRID_SIZE
	local y = math.round(position.Y / GRID_SIZE) * GRID_SIZE -- Giữ nguyên Y hoặc làm tròn tùy cấu trúc map
	local z = math.round(position.Z / GRID_SIZE) * GRID_SIZE
	return Vector3.new(x, y, z)
end

-- Hàm Heuristic: Sử dụng khoảng cách Euclid giữa 2 điểm
local function heuristic(p1: Vector3, p2: Vector3): number
	return (p1 - p2).Magnitude
end

-- Hàm kiểm tra xem vị trí có bị vật cản (Obstacle) chặn hay không
local function isWalkable(position: Vector3): boolean
	-- Tạo một hộp kiểm tra va chạm nhỏ tại vị trí lưới
	local halfSize = Vector3.new(GRID_SIZE/2 - 0.1, 2, GRID_SIZE/2 - 0.1)
	local overlapParams = OverlapParams.new()
	overlapParams.FilterType = Enum.RaycastFilterType.Exclude
	-- Loại bỏ nhân vật của người chơi khỏi danh sách vật cản nếu cần
	if game.Players.LocalPlayer.Character then
		overlapParams.FilterDescendantsInstances = {game.Players.LocalPlayer.Character}
	end
	
	local parts = workspace:GetPartBoundsInBox(CFrame.new(position + Vector3.new(0, 1, 0)), halfSize, overlapParams)
	return #parts == 0
end

-- Tạo key dạng chuỗi cho bảng băm từ Vector3
local function toKey(v: Vector3): string
	return string.format("%d,%d,%d", v.X, v.Y, v.Z)
end

-- Hàm chính tìm đường đi A*
local function find_exit(spos: Vector3, epos: Vector3): {Vector3}
	local startPos = snapToGrid(spos)
	local endPos = snapToGrid(epos)
	
	local openSet = {}   -- Danh sách các nút đang chờ duyệt
	local closedSet = {} -- Danh sách các nút đã duyệt xong
	
	local gScore = {}    -- Chi phí thực tế từ startPos
	local fScore = {}    -- Chi phí ước tính tổng cộng (g + h)
	local cameFrom = {}  -- Lưu vết đường đi
	
	local startKey = toKey(startPos)
	openSet[startKey] = startPos
	gScore[startKey] = 0
	fScore[startKey] = heuristic(startPos, endPos)
	
	while next(openSet) ~= nil do
		-- Tìm nút có fScore thấp nhất trong openSet
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
		
		-- Nếu đã đến đích, tiến hành truy vết lại đường đi
		if (current - endPos).Magnitude < 0.1 then
			local path = {}
			local temp = current
			local tempKey = currentKey
			
			while temp do
				table.insert(path, 1, temp) -- Thêm vào đầu mảng để giữ đúng thứ tự từ đầu đến cuối
				temp = cameFrom[tempKey]
				tempKey = temp and toKey(temp)
			end
			return path
		end
		
		-- Di chuyển nút hiện tại từ openSet sang closedSet
		openSet[currentKey] = nil
		closedSet[currentKey] = true
		
		-- Duyệt qua các nút láng giềng (Neighbors)
		for _, dir in ipairs(DIRECTIONS) do
			local neighbor = current + (dir * GRID_SIZE)
			local neighborKey = toKey(neighbor)
			
			if not closedSet[neighborKey] and isWalkable(neighbor) then
				-- Chi phí di chuyển sang ô hàng xóm
				local tentative_gScore = gScore[currentKey] + (dir.Magnitude * GRID_SIZE)
				
				if tentative_gScore < (gScore[neighborKey] or math.huge) then
					-- Đường đi này tối ưu hơn đường cũ (nếu có)
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
	
	-- Trả về mảng rỗng nếu không tìm thấy đường đi thoát
	return {} 
end

-- Ví dụ cách gọi hàm:
-- local startPoint = workspace.StartPart.Position
-- local endPoint = workspace.EndPart.Position
-- local path = find_exit(startPoint, endPoint)
-- print("Số bước đi:", #path)
