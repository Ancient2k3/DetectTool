local core, rs
core = game:GetService("CoreGui")
rs = game:GetService("RunService")

local screenui, selected_ui, move, resize, drag_ui
screenui = Instance.new("ScreenGui", core)
selected_ui = Instance.new("TextBox", screenui)
move = Instance.new("TextButton", screenui)
resize = Instance.new("TextButton", screenui)
drag_ui = Instance.new("Frame", screenui)

local vars, funcs = {
  ui_object = nil,
  mode = 2
}, {
  corner = function(t, r) Instance.new("UICorner", t).CornerRadius = UDim.new(r, 0) end,
  mb1c = function(t, script) t.MouseButton1Click:Connect(script) end
}

screenui.Name = "UIBuilder_xScripts"
selected_ui.Name = "UI-Object:Selected"
selected_ui.BackgroundTransparency = 0.5
selected_ui.BackgroundColor3 = Color3.new(0, 0, 0)
selected_ui.Position = UDim2.new(0, 20, 0, 6)
selected_ui.Size = UDim2.new(0, 155, 0, 18)
selected_ui.TextScaled = false
selected_ui.TextSize = 9
selected_ui.TextColor3 = Color3.new(1, 1, 1)
selected_ui.Font = Enum.Font.Code
selected_ui.PlaceholderText = "Path?"
selected_ui.Text = ""
selected_ui.ClearTextOnFocus = true
selected_ui.ClipsDescendants = true
selected_ui.Visible = true
funcs.corner(selected_ui, 0.1)

move.Name = "UI-Builder:Move"
move.BackgroundTransparency = 0.5
move.BackgroundColor3 = Color3.new(0, 0, 0)
move.Position = UDim2.new(0, 20, 0, 28)
move.Size = UDim2.new(0, 31, 0, 25)
move.TextScaled = true
move.TextSize = 9
move.TextColor3 = Color3.new(1, 1, 1)
move.Font = Enum.Font.Code
move.Text = "P"
move.Visible = true
funcs.corner(move, 0.1)

resize.Name = "UI-Builder:Resize"
resize.BackgroundTransparency = 0.5
resize.BackgroundColor3 = Color3.new(0, 0, 0)
resize.Position = UDim2.new(0, 55, 0, 28)
resize.Size = UDim2.new(0, 31, 0, 25)
resize.TextScaled = true
resize.TextSize = 9
resize.TextColor3 = Color3.new(1, 1, 1)
resize.Font = Enum.Font.Code
resize.Text = "S"
resize.Visible = true
funcs.corner(resize, 0.1)

drag_ui.Name = "UI-Builder:DRAG_MAIN"
drag_ui.BackgroundTransparency = 0.25
drag_ui.BackgroundColor3 = Color3.new(0, 0, 0)
drag_ui.Position = UDim2.new(0, 90, 0, 28)
drag_ui.Size = UDim2.new(0.025, 0, 0.05, 0)
drag_ui.Active = true
drag_ui.Draggable = false
drag_ui.ZIndex = 100
drag_ui.Visible = true
funcs.corner(drag_ui, 0.15)

function find_screenui(obj)
  if obj.ClassName == "ScreenGui" then
    return obj
  else
    find_screenui(obj.Parent)
  end
end

local original_drag_pos = drag_ui.Position
function set_drag_position()
  if vars.ui_object ~= nil then
    local obj = vars.ui_object
    
    local full_path = find_screenui(obj)
    if full_path ~= nil then
      full_path.Parent = screenui
    end
    
    drag_ui.BackgroundColor3 = Color3.new(1, 1, 0)
    drag_ui.Draggable = true
    drag_ui.Position = UDim2.new(0, obj.AbsolutePosition.X + obj.Size.X.Offset, 0, obj.AbsolutePosition.Y + obj.Size.Y.Offset)
  else
    drag_ui.BackgroundColor3 = Color3.new(0, 0, 0)
    drag_ui.Draggable = false
    drag_ui.Position = original_drag_pos
  end
end

function set_object_properties()
  local drag_ab = drag_ui.AbsolutePosition
  local drag_x, drag_y = drag_ab.X, drag_ab.Y
  local obj = vars.ui_object
  if obj == nil then return end
  if vars.mode > 0 and vars.mode < 2 then
    obj.Size = UDim2.new(0, drag_x - obj.AbsolutePosition.X, 0, drag_y - obj.AbsolutePosition.Y)
  else
    obj.Position = UDim2.new(0, drag_x - obj.Size.X.Offset, 0, drag_y - obj.Size.Y.Offset)
  end
end

funcs.mb1c(move, function()
  if selected_ui.Text ~= "" then
    vars.mode = 0
    move.TextColor3 = Color3.new(0, 1, 0)
    if resize.TextColor3 == Color3.new(0, 1, 0) then
      resize.TextColor3 = Color3.new(1, 1, 1)
    end
  else
    move.TextColor3 = Color3.new(1, 0, 0)
    task.wait(0.25) move.TextColor3 = Color3.new(1, 1, 1)
  end
end)

funcs.mb1c(resize, function()
  if selected_ui.Text ~= "" then
    vars.mode = 1
    resize.TextColor3 = Color3.new(0, 1, 0)
    if move.TextColor3 == Color3.new(0, 1, 0) then
      move.TextColor3 = Color3.new(1, 1, 1)
    end
  else
    resize.TextColor3 = Color3.new(1, 0, 0)
    task.wait(0.25) resize.TextColor3 = Color3.new(1, 1, 1)
  end
end)

selected_ui.FocusLost:Connect(function()
  if selected_ui.Text ~= "" then
    local obj_found = loadstring("return " .. selected_ui.Text .. " or nil")()
    if obj_found.Visible then
      vars.ui_object = obj_found
    end
  else
    vars.mode = 2
    vars.ui_object = nil
    if move.TextColor3 == Color3.new(0, 1, 0) then
      move.TextColor3 = Color3.new(1, 1, 1)
    end if resize.TextColor3 == Color3.new(0, 1, 0) then
      resize.TextColor3 = Color3.new(1, 1, 1)
    end
    selected_ui.PlaceholderText = "Can't be nil"
    task.wait(0.5) selected_ui.PlaceholderText = "Path?"
  end set_drag_position()
end)

rs.RenderStepped:Connect(function(dt)
  if dt and vars.ui_object ~= nil then
    if vars.mode < 2 then set_object_properties() end
  end
end)