local core = game:GetService("CoreGui")

local _active = false
local _codes = game:HttpGet("https://raw.githubusercontent.com/Ancient2k3/Tensura/refs/heads/main/FLY.luau")

local screenui = Instance.new("ScreenGui", core)
screenui.Name = "FLY:SIMPLE"

local btn = Instance.new("TextButton", screenui)
btn.Name = "_TRIGGER"
btn.BackgroundTransparency = 0.5
btn.BackgroundColor3 = Color3.new(0, 0, 0)
btn.Position = UDim2.new(0.7, 0, -0.15, 0)
btn.Size = UDim2.new(0.05, 0, 0.1, 0)
btn.TextScaled = true
btn.TextSize = 12
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Text = "BAY"
btn.Font = Enum.Font.Arcade
btn.Visible = true
btn.ZIndex = 1
Instance.new("UICorner", btn).CornerRadius = UDim.new(0.15, 0)

loadstring(_codes:gsub("Script_FlyingEnabled", "FLY_SPECIAL"))()

btn.MouseButton1Click:Connect(function()
  if not _active then _active = true
    btn.TextColor3 = Color3.new(0, 1, 0)
    _G.FLY_SPECIAL = true
  else _active = false
    btn.TextColor3 = Color3.new(1, 1, 1)
    _G.FLY_SPECIAL = false
  end
end)