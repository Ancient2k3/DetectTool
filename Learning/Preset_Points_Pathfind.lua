local ws
ws = game:GetService("Workspace")

if not _G.goal then _G.goal = v3.own end

local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Exclude
params.FilterDescendantsInstances = {ws._ScriptFolder, plr.Character}

function find_point(epos, pts)
  local clear_sight = {}
  pts = pts or {}
  if epos and #pts > 0 then
    for i = 1, #pts do
      local ray = ws:Raycast(pts[i], epos - pts[i], params)
      if not ray then
        table.insert(clear_sight, pts[i])
      end
    end
  end return clear_sight
end

function rmv_point(t, pts)
  local out, rmved = {}, nil
  if #pts > 0 then
    for i = 1, #pts do
      for idx = 1, #t do
        local dist = (pts[i] - t[idx]).magnitude <= 2
        if not dist then
          table.insert(out, t[idx])
        else
          rmved = t[idx]
        end
      end
    end
  end return out, rmved
end

local preset_points = {
Vector3.new(-39.4, 167.8, -147.2), Vector3.new(-29.3, 167.7, -193.6), Vector3.new(-39.6, 153.1, -277.5), Vector3.new(7.2, 3.6, -254.8)}

function generate_path(epos, pts)
  local out, epos, pts = {}, epos, pts
  if pts and #pts > 0 then
    for i = 1, #pts do
      local uh = find_point(epos, pts)
      table.insert(out, uh[1])
      pts, epos = rmv_point(pts, uh)
    end
  end return out
end

function reverse_index(t)
  local out = {}
  table.insert(out, v3.own)
  if t and #t > 0 then
    for i = 1, #t do
      table.insert(out, t[(#t + 1) - i])
    end
  end return out
end

local final = reverse_index(generate_path(_G.goal, preset_points))
table.insert(final, _G.goal)

for i = 1, #final do tpos(final[i]) task.wait(0.2) end
