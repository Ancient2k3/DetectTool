-- Rework cuz my scripting skill upgrades --
local ws, plrs, core, tws
ws = game:GetService("Workspace")
plrs = game:GetService("Players")
core = game:GetService("CoreGui")
tws = game:GetService("TweenService")

local screenui, dashboard, board
local datas = {
    folders = {"_SkyIsAzure", "UI_INSTANCES", "UI_ASSETS"},
    buttons = {
        vars = {toggle_ui = false, current_pos = 0.005},
        idk = loadstring(game:HttpGet("https://raw.githubusercontent.com/Ancient2k3/DetectTool/refs/heads/main/src/maps.lua"))()
    },
    tween_anims = {}
}

repeat task.wait() until type(datas.buttons.idk) == "table"

for index = 2, #datas.folders do
    if not core:FindFirstChild(datas.folders[1]) then
        Instance.new("Folder", core).Name = datas.folders[1]
    end
    if not core[datas.folders[1]]:FindFirstChild(datas.folders[index]) then
        Instance.new("Folder", core[datas.folders[1]]).Name = datas.folders[index]
    end
end

screenui = Instance.new("ScreenGui", core[datas.folders[1]]:FindFirstChild("UI_INSTANCES"))
dashboard = Instance.new("TextButton", screenui)
board = Instance.new("ScrollingFrame", screenui)

screenui.Name = "_START"
dashboard.Name = "_TOGGLE"
board.Name = "_HOLDER"

dashboard.BackgroundColor3 = Color3.new(0, 0, 0)
dashboard.BackgroundTransparency = 0.5
dashboard.Size = UDim2.new(0.05, 0, 0.1, 0)
dashboard.TextScaled = true
dashboard.Position = UDim2.new(0.78, 0, -0.1, 0)
dashboard.TextColor3 = Color3.new(1, 1, 1)
dashboard.Font = Enum.Font.PatrickHand
dashboard.Text = "「Script」"
Instance.new("UICorner", dashboard).CornerRadius = UDim.new(0.15, 0)

board.Size = UDim2.new(0.3, 0, 0.1, 0)
board.Position = UDim2.new(1.2, 0, 0.18, 0)
board.BackgroundColor3 = Color3.new(0, 0, 0)
board.BackgroundTransparency = 0.5
board.CanvasSize = UDim2.new(2, 0, 0, 0)
board.ScrollBarThickness = 1

datas.tween_anims.show = tws:Create(board, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
    Position = UDim2.new(0.695, 0, 0.18, 0)
})

datas.tween_anims.hide = tws:Create(board, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
    Position = UDim2.new(1.2, 0, 0.18, 0)
})

function _make_button(name, url)
    local btn = Instance.new("TextButton", board)
    btn.BackgroundColor3 = Color3.new(0, 0, 0)
    btn.BackgroundTransparency = 0.5
    btn.Size = UDim2.new(0.03, 0, 0.9, 0)
    btn.TextScaled = true
    btn.Position = UDim2.new(datas.buttons.vars.current_pos, 0, 0, 0)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.PatrickHand
    btn.Text = name
    datas.buttons.vars.current_pos = datas.buttons.vars.current_pos + 0.040
    btn.MouseButton1Click:Connect(function()
        loadstring(game:HttpGet(url))()
    end)
end

dashboard.MouseButton1Click:Connect(function()
    if not datas.buttons.vars.toggle_ui then
        datas.tween_anims.show:Play()
        dashboard.TextColor3 = Color3.new(0, 1, 0)
    else
        datas.tween_anims.hide:Play()
        dashboard.TextColor3 = Color3.new(1, 1, 1)
    end
    datas.buttons.vars.toggle_ui = not datas.buttons.vars.toggle_ui
end)

for name, url in pairs(datas.buttons.idk) do
    _make_button(name, url)
    print("[+]: created " .. name .. " button.")
end
