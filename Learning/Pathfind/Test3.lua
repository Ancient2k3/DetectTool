local P = {}

local D = 40
local N = 3

local function dst(a, b)
    return (a - b).Magnitude
end

local function clear(a, b)
    local r = RaycastParams.new()
    r.FilterType = Enum.RaycastFilterType.Exclude
    r.FilterDescendantsInstances = {workspace.Points}
    r.IgnoreWater = true
    return workspace:Raycast(a, b - a, r) == nil
end

function P.create_path(s, e, pts)
    local ns = {}

    for _, p in ipairs(pts) do
        if p:IsA("BasePart") then
            table.insert(ns, {
                pos = p.Position,
                con = {}
            })
        end
    end

    if #ns == 0 then
        return {}
    end

    local function near(pos)
        local best, bd

        for _, n in ipairs(ns) do
            local d = dst(pos, n.pos)
            if not bd or d < bd then
                best, bd = n, d
            end
        end

        return best
    end

    for _, a in ipairs(ns) do
        local ds = {}

        for _, b in ipairs(ns) do
            if a ~= b then
                table.insert(ds, {
                    n = b,
                    d = dst(a.pos, b.pos)
                })
            end
        end

        table.sort(ds, function(a, b)
            return a.d < b.d
        end)

        local c = 0

        for _, v in ipairs(ds) do
            if c >= N then
                break
            end

            if v.d <= D and clear(a.pos, v.n.pos) then
                table.insert(a.con, v.n)
                table.insert(v.n.con, a)
                c += 1
            end
        end
    end

    local a, b = near(s), near(e)
    local op = {a}
    local came = {}
    local gs = {[a] = 0}
    local fs = {[a] = dst(a.pos, b.pos)}
    local inside = {[a] = true}

    while #op > 0 do
        local bi = 1

        for i = 2, #op do
            if (fs[op[i]] or math.huge) < (fs[op[bi]] or math.huge) then
                bi = i
            end
        end

        local cur = table.remove(op, bi)
        inside[cur] = nil

        if cur == b then
            local path = {}
            local n = cur

            while n do
                table.insert(path, 1, n.pos)
                n = came[n]
            end

            path[1] = s
            path[#path] = e
            return path
        end

        for _, v in ipairs(cur.con) do
            local g = gs[cur] + dst(cur.pos, v.pos)

            if g < (gs[v] or math.huge) then
                came[v] = cur
                gs[v] = g
                fs[v] = g + dst(v.pos, b.pos)

                if not inside[v] then
                    table.insert(op, v)
                    inside[v] = true
                end
            end
        end
    end

    return {}
end

return P
