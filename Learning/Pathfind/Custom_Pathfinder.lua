-- Custom Pathfinder using Preset Points --
local ws, plrs
ws = game:GetService("Workspace")
plrs = game:GetService("Players")

local plr, mdl, params
plr = plrs.LocalPlayer
mdl = {}
params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Exclude
params.FilterDescendantsInstances = {ws._ScriptFolder, plr.Character}

function can_reach(a, b)
    local dir = b - a
    if dir.Magnitude < 1e-5 then
        return true
    end return ws:Raycast(a, dir, params) == nil
end

function mdl.create_path(spos, epos, pts)
    if not spos or not epos then return nil end
    pts = pts or {}
    local nodes = {spos}
    for _, p in ipairs(pts) do
        if p then local duplicate = false
            for _, node in ipairs(nodes) do
                if (p - node).Magnitude < 0.1 then
                    duplicate = true
                    break
                end
            end if not duplicate
                and (p - epos).Magnitude >= 0.1 then
                table.insert(nodes, p)
            end
        end
    end table.insert(nodes, epos)
    local count = #nodes
    local goal = count
    local dist = {}
    local prev = {}
    local visited = {}
    for i = 1, count do
        dist[i] = math.huge
    end dist[1] = 0
    while true do local u = nil
        local best = math.huge
        for i = 1, count do
            if not visited[i] and dist[i] < best then
                u = i
                best = dist[i]
            end
        end if not u then return nil end
        if u == goal then break end
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
    end local path = {}
    local current = goal
    while current do table.insert(path, 1, nodes[current])
        if current == 1 then break end
        current = prev[current]
    end if path[1] ~= spos then return nil end
    return path
end

return mdl, "v0.1"
