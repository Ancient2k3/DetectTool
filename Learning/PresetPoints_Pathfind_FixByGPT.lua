-- Not tested yet --
local ws = game:GetService("Workspace")

local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Exclude
params.FilterDescendantsInstances = {
    ws._ScriptFolder,
    plr.Character
}

function can_reach(a, b)
    local dir = b - a
    if dir.Magnitude < 1e-5 then
        return true
    end return ws:Raycast(a, dir, params) == nil
end

function generate_path(startPos, endPos, pts)
    if not startPos or not endPos then return nil end
    pts = pts or {}
    -- Tạo danh sách node: điểm đầu, waypoint, điểm đích
    local nodes = {startPos}
    for _, p in ipairs(pts) do
        if p then
            local duplicate = false
            -- Bỏ waypoint trùng với điểm đã có
            for _, node in ipairs(nodes) do
                if (p - node).Magnitude < 0.1 then
                    duplicate = true
                    break
                end
            end
            if not duplicate
                and (p - endPos).Magnitude >= 0.1 then
                table.insert(nodes, p)
            end
        end
    end
    table.insert(nodes, endPos)
    local count = #nodes
    local goal = count
    local dist = {}
    local prev = {}
    local visited = {}
    for i = 1, count do
        dist[i] = math.huge
    end
    dist[1] = 0
    -- Dijkstra trên đồ thị visibility
    while true do
        local u = nil
        local best = math.huge
        for i = 1, count do
            if not visited[i] and dist[i] < best then
                u = i
                best = dist[i]
            end
        end
        -- Không còn node nào tới được
        if not u then
            return nil
        end
        -- Đã tới đích
        if u == goal then
            break
        end
        visited[u] = true
        for v = 1, count do
            if not visited[v] and v ~= u then
                if can_reach(nodes[u], nodes[v]) then
                    local cost = (nodes[v] - nodes[u]).Magnitude
                    local newDist = dist[u] + cost

                    if newDist < dist[v] then
                        dist[v] = newDist
                        prev[v] = u
                    end
                end
            end
        end
    end
    -- Truy ngược đường đi từ đích về đầu
    local path = {}
    local current = goal
    while current do
        table.insert(path, 1, nodes[current])
        if current == 1 then
            break
        end
        current = prev[current]
    end
    if path[1] ~= startPos then
        return nil
    end
    return path
end

return generate_path
