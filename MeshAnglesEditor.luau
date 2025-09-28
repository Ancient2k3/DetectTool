-- Angles Editor (fixed)
local _ws = game:GetService("Workspace")
local _plrs = game:GetService("Players")
local _core = game:GetService("CoreGui")
local _times

if _core:FindFirstChild("_AnglesEditorScript") then
    _G._DelTimes += 1
    _times = _G._DelTimes
    _core["_AnglesEditorScript"]:Destroy()
    print("-- Old GUI Deleted " .. _times .. " --")
end if not _G._DelTimes then
    _G._DelTimes = 0
end

_G._UpvalueRange = _G._UpvalueRange or 0.01
local afunc, _plr = {
    black = Color3.new(0, 0, 0),
    white = Color3.new(1, 1, 1),
    green = Color3.new(0, 1, 0),
    yellow = Color3.new(1, 1, 0),
    red = Color3.new(1, 0, 0),
    uic = function(t, r)
        local uic = Instance.new("UICorner")
        uic.CornerRadius = UDim.new(r, 0)
        uic.Parent = t
    end,
    mb1c = function(t, func) t.MouseButton1Click:Connect(func) end,
    fl = function(t, func) t.FocusLost:Connect(func) end,
    tsda = { m = 0, p = 4, h = 20 }
}, _plrs.LocalPlayer

local _scriptdata = {
    framedata = {
        idbox_input_added = false,
        prted_input_added = false
    },
    direct = "rbxassetid://",
    meshid = "6750850554",
    textureid = "http://www.roblox.com/asset/?id=6783058251",
    parented = "Head",
    cframe = {0, -1.5, 0},
    angles = {0, 0, 0},
    vector = {0.8, 0.8, 0.8}
}

local _screenui = Instance.new("ScreenGui", _core)
local _df = Instance.new("Frame", _screenui)
local _sf = Instance.new("Frame", _df)
local _idbox = Instance.new("TextBox", _sf)
local _pwith = Instance.new("TextBox", _sf)
local _addmesh = Instance.new("TextButton", _sf)
local _holderscroll = Instance.new("ScrollingFrame", _df)

_screenui.Name = "_AnglesEditorScript"
_df.Name = "DragF"
_sf.Name = "PGirl"
_idbox.Name = "_Insert_Models_Id"
_pwith.Name = "_ParentedBox"
_addmesh.Name = "_AcceptMeshId"
_holderscroll.Name = "__Settings"

_df.BackgroundTransparency = 0.5
_df.BackgroundColor3 = afunc.black
_df.Position = UDim2.new(0.35, 0, 0.45, 0)
_df.Size = UDim2.new(0.4, 0, 0.4, 0)
_df.Active = true
_df.Draggable = true
_df.Visible = true
afunc.uic(_df, 0)

_sf.BackgroundTransparency = 0.6
_sf.BackgroundColor3 = afunc.black
_sf.Position = UDim2.new(0, 0, 0.7, 0)
_sf.Size = UDim2.new(1, 0, 0.3, 0)
_sf.Active = true
_sf.Draggable = false
_sf.Visible = true
afunc.uic(_sf, 0)

_idbox.BackgroundTransparency = 0.6
_idbox.BackgroundColor3 = afunc.black
_idbox.Position = UDim2.new(0.01, 0, 0.05, 0)
_idbox.Size = UDim2.new(0.4, 0, 0.9, 0)
_idbox.TextScaled = true
_idbox.TextSize = 12
_idbox.TextColor3 = afunc.white
_idbox.Font = Enum.Font.Code
_idbox.Text = tostring(_scriptdata.meshid or "")
_idbox.PlaceholderText = "< MeshId >"
_idbox.Visible = true
afunc.uic(_idbox, 0.05)

_pwith.BackgroundTransparency = 0.6
_pwith.BackgroundColor3 = afunc.black
_pwith.Position = UDim2.new(0.42, 0, 0.05, 0)
_pwith.Size = UDim2.new(0.25, 0, 0.9, 0)
_pwith.TextScaled = true
_pwith.TextSize = 12
_pwith.TextColor3 = afunc.yellow
_pwith.Font = Enum.Font.Code
_pwith.Text = tostring(_scriptdata.parented or "")
_pwith.PlaceholderText = "< Parent >"
_pwith.Visible = true
afunc.uic(_pwith, 0.05)

_addmesh.BackgroundTransparency = 0.6
_addmesh.BackgroundColor3 = afunc.black
_addmesh.Position = UDim2.new(0.68, 0, 0.05, 0)
_addmesh.Size = UDim2.new(0.3, 0, 0.9, 0)
_addmesh.TextScaled = true
_addmesh.TextColor3 = afunc.green
_addmesh.Font = Enum.Font.Code
_addmesh.Text = "Add"
_addmesh.Visible = true
afunc.uic(_addmesh, 0.05)

_holderscroll.BackgroundTransparency = 0.6
_holderscroll.BackgroundColor3 = afunc.black
_holderscroll.Position = UDim2.new(0.02, 0, 0.05, 0)
_holderscroll.Size = UDim2.new(0.8, 0, 0.625, 0)
_holderscroll.CanvasSize = UDim2.new(0, 0, 0, 0)
_holderscroll.ScrollBarThickness = 0.15
_holderscroll.Visible = true
afunc.uic(_holderscroll, 0.05)

function truncate_number(num, decimals)
    if decimals <= 0 then
        return math.floor(num)
    end
    local factor = 10 ^ decimals
    return math.floor(num * factor) / factor
end

function _addsetting(name, func)
    local btn = Instance.new("TextButton", _holderscroll)
    btn.Name = "_BTN_" .. name .. "_Action_#" .. math.random(1, 9999)
    btn.BackgroundTransparency = 0.6
    btn.BackgroundColor3 = afunc.black
    btn.Position = UDim2.new(0.02, 0, 0, afunc.tsda.m + afunc.tsda.p)
    btn.Size = UDim2.new(0.96, 0, 0, afunc.tsda.h)
    btn.TextScaled = true
    btn.TextSize = 12
    btn.TextColor3 = afunc.white
    btn.Font = Enum.Font.Code
    btn.Text = name
    btn.Visible = true
    afunc.uic(btn, 0.05)
    btn.MouseButton1Click:Connect(func)
    afunc.tsda.m = afunc.tsda.m + afunc.tsda.h + afunc.tsda.p
    _holderscroll.CanvasSize = UDim2.new(0, 0, 0, afunc.tsda.m)
    return btn
end

function _addpart_mesh(meshid, txtid, body, name, cframe, angles, vector)
    meshid = meshid or _scriptdata.direct .. tostring(_scriptdata.meshid)
    txtid = txtid or _scriptdata.textureid
    body = body or _scriptdata.parented or "Head"
    name = name or "ScriptedPart"
    cframe = cframe or {0, 0, 0}
    angles = angles or {0, 0, 0}
    vector = vector or {1, 1, 1}
    if tonumber(meshid) then
        meshid = _scriptdata.direct .. tostring(meshid)
    else
        if meshid:match("^%d+$") then
            meshid = _scriptdata.direct .. meshid
        end
    end
    local char = _plr.Character or _plr.CharacterAdded:Wait()
    if not char then return nil end
    local target = char:FindFirstChild(body) or char:FindFirstChildWhichIsA("BasePart")
    if not target then
        target = char:WaitForChild(body, 2)
        if not target then
            warn("Angles Editor: Could not find body part '" .. tostring(body) .. "' in character.")
            return nil
        end
    end
    local previous_part = char:FindFirstChild("ScriptedPart_HH")
    if previous_part and previous_part:GetAttribute("_MESHID") == tostring(meshid) then previous_part:Destroy() end
    local part = Instance.new("Part")
    part.Transparency = 0
    part.Anchored = false
    part.CanCollide = false
    part.Size = Vector3.new(1, 1, 1)
    part.Color = afunc.white
    part.Name = name
    part.Parent = char
    part:SetAttribute("_MESHID", tostring(meshid))
    local smesh = Instance.new("SpecialMesh", part)
    smesh.MeshType = Enum.MeshType.FileMesh
    smesh.MeshId = tostring(meshid)
    smesh.TextureId = tostring(txtid)
    smesh.Scale = Vector3.new(vector[1] or 1, vector[2] or 1, vector[3] or 1)
    local welding = Instance.new("Weld")
    welding.Parent = part
    welding.Part0 = target
    welding.Part1 = part
    local okCF = CFrame.new((cframe[1] or 0), (cframe[2] or 0), (cframe[3] or 0))
    local okAng = CFrame.Angles((angles[1] or 0), (angles[2] or 0), (angles[3] or 0))
    welding.C1 = okCF * okAng
    return part
end

function _placingmesh()
    local success, res = pcall(function()
        return _addpart_mesh(_scriptdata.meshid, _scriptdata.textureid, _scriptdata.parented, "ScriptedPart_HH", _scriptdata.cframe, _scriptdata.angles, _scriptdata.vector)
    end)
    if not success then
        warn("Angles Editor: Failed to add mesh:", res)
    end
end

afunc.fl(_idbox, function(enterPressed)
    if not _scriptdata.framedata.idbox_input_added then
        _scriptdata.framedata.idbox_input_added = true
        if enterPressed then
            local txt = _idbox.Text and tostring(_idbox.Text) or ""
            txt = txt:match("^%s*(.-)%s*$")
            if txt == "" then
                _idbox.Text = "Empty"
                _idbox.TextColor3 = afunc.red
                wait(2.5)
                _idbox.Text = ""
                _idbox.TextColor3 = afunc.white
            else
                if tonumber(txt) or txt:match("^rbxassetid://") or txt:match("^https?://") or txt:match("^http://") or txt:match("^https://") then
                    if tonumber(txt) then
                        _scriptdata.meshid = _scriptdata.direct .. tostring(tonumber(txt))
                    else
                        _scriptdata.meshid = txt
                    end
                    _idbox.TextColor3 = afunc.green
                    wait(0.6)
                    _idbox.TextColor3 = afunc.white
                else
                    _idbox.Text = "Invalid Type"
                    _idbox.TextColor3 = afunc.red
                    wait(2.5)
                    _idbox.Text = ""
                    _idbox.TextColor3 = afunc.white
                end
            end
        end
        _scriptdata.framedata.idbox_input_added = false
    end
end)

afunc.fl(_pwith, function(enterPressed)
    if not _scriptdata.framedata.prted_input_added then
        _scriptdata.framedata.prted_input_added = true
        if enterPressed then
            local txt = _pwith.Text and tostring(_pwith.Text) or ""
            txt = txt:match("^%s*(.-)%s*$")
            if txt ~= "" then
                _scriptdata.parented = txt
                _pwith.TextColor3 = afunc.green
                wait(0.6)
                _pwith.TextColor3 = afunc.yellow
            end
        end
        _scriptdata.framedata.prted_input_added = false
    end
end)

afunc.mb1c(_addmesh, function()
    _placingmesh()
end)

_addsetting("Remove Script Mesh", function()
    local char = _plr.character
    local total_x = 0
    for i, v in pairs(char:GetChildren()) do
        if v:IsA("Part") and v.Name == "ScriptedPart_HH" then
            v:Destroy()
            total_x = i
        end
    end print(total_x .. " script meshes has been removed!")
end)

_addsetting("Copy Position Data", function()
    if setclipboard then
        local final_data
        local cf_a, cf_b, cf_c = unpack(_scriptdata.cframe)
        local an_a, an_b, an_c = unpack(_scriptdata.angles)
        local v_1, v_2, v_3 = unpack(_scriptdata.vector)
        final_data = "CFrame.new(" .. cf_a .. ", " .. cf_b .. ", " .. cf_c .. ") * CFrame.Angles(" .. an_a .. ", " .. an_b .. ", " .. an_c .. ")\nVector3.new(" .. v_1 .. ", " .. v_2 .. ", " .. v_3 .. ")"
        setclipboard(final_data)
        print(final_data .. "\n -- Copied to clipboard! --")
    else
        _plr:Kick("Executor's does not supported this script!")
    end
end)

local angle_x, angle_y, angle_z
local cframe_x, cframe_y, cframe_z
local negative_angle_x, negative_angle_y, negative_angle_z, negative_cframe_x, negative_cframe_y, negative_cframe_z

cframe_x = _addsetting("CFrame: {Up value, 0, 0}", function()
    local x_point = _scriptdata.cframe[1]
    local y_point = _scriptdata.cframe[2]
    local z_point = _scriptdata.cframe[3]
    x_point += _G._UpvalueRange
    _scriptdata.cframe = {x_point, y_point, z_point}
    cframe_x.Text = "CFrame: {" .. truncate_number(x_point, 3) .. ", " .. truncate_number(y_point, 3) .. ", " .. truncate_number(z_point, 3) .. "}"
    _placingmesh()
    print("CFrame changed to " .. truncate_number(x_point, 3) .. ", " .. truncate_number(y_point, 3) .. ", " .. truncate_number(z_point, 3))
end)

negative_cframe_x = _addsetting("CFrame: {Down value, 0, 0}", function()
    local x_point = _scriptdata.cframe[1]
    local y_point = _scriptdata.cframe[2]
    local z_point = _scriptdata.cframe[3]
    x_point -= _G._UpvalueRange
    _scriptdata.cframe = {x_point, y_point, z_point}
    negative_cframe_x.Text = "CFrame: {" .. truncate_number(x_point, 3) .. ", " .. truncate_number(y_point, 3) .. ", " .. truncate_number(z_point, 3) .. "}"
    _placingmesh()
    print("CFrame changed to " .. truncate_number(x_point, 3) .. ", " .. truncate_number(y_point, 3) .. ", " .. truncate_number(z_point, 3))
end)

cframe_y = _addsetting("CFrame: {0, Up value, 0}", function()
    local x_point = _scriptdata.cframe[1]
    local y_point = _scriptdata.cframe[2]
    local z_point = _scriptdata.cframe[3]
    y_point += _G._UpvalueRange
    _scriptdata.cframe = {x_point, y_point, z_point}
    cframe_y.Text = "CFrame: {" .. truncate_number(x_point, 3) .. ", " .. truncate_number(y_point, 3) .. ", " .. truncate_number(z_point, 3) .. "}"
    _placingmesh()
    print("CFrame changed to " .. truncate_number(x_point, 3) .. ", " .. truncate_number(y_point, 3) .. ", " .. truncate_number(z_point, 3))
end)

negative_cframe_y = _addsetting("CFrame: {0, Down value, 0}", function()
    local x_point = _scriptdata.cframe[1]
    local y_point = _scriptdata.cframe[2]
    local z_point = _scriptdata.cframe[3]
    y_point -= _G._UpvalueRange
    _scriptdata.cframe = {x_point, y_point, z_point}
    negative_cframe_y.Text = "CFrame: {" .. truncate_number(x_point, 3) .. ", " .. truncate_number(y_point, 3) .. ", " .. truncate_number(z_point, 3) .. "}"
    _placingmesh()
    print("CFrame changed to " .. truncate_number(x_point, 3) .. ", " .. truncate_number(y_point, 3) .. ", " .. truncate_number(z_point, 3))
end)

cframe_z = _addsetting("CFrame: {0, 0, Up value}", function()
    local x_point = _scriptdata.cframe[1]
    local y_point = _scriptdata.cframe[2]
    local z_point = _scriptdata.cframe[3]
    z_point += _G._UpvalueRange
    _scriptdata.cframe = {x_point, y_point, z_point}
    cframe_z.Text = "CFrame: {" .. truncate_number(x_point, 3) .. ", " .. truncate_number(y_point, 3) .. ", " .. truncate_number(z_point, 3) .. "}"
    _placingmesh()
    print("CFrame changed to " .. truncate_number(x_point, 3) .. ", " .. truncate_number(y_point, 3) .. ", " .. truncate_number(z_point, 3))
end)

negative_cframe_z = _addsetting("CFrame: {0, 0, Down value}", function()
    local x_point = _scriptdata.cframe[1]
    local y_point = _scriptdata.cframe[2]
    local z_point = _scriptdata.cframe[3]
    z_point -= _G._UpvalueRange
    _scriptdata.cframe = {x_point, y_point, z_point}
    negative_cframe_z.Text = "CFrame: {" .. truncate_number(x_point, 3) .. ", " .. truncate_number(y_point, 3) .. ", " .. truncate_number(z_point, 3) .. "}"
    _placingmesh()
    print("CFrame changed to " .. truncate_number(x_point, 3) .. ", " .. truncate_number(y_point, 3) .. ", " .. truncate_number(z_point, 3))
end)

angle_x = _addsetting("Angles: {Up value, 0, 0}", function()
    local x_point = _scriptdata.angles[1]
    local y_point = _scriptdata.angles[2]
    local z_point = _scriptdata.angles[3]
    x_point += _G._UpvalueRange
    _scriptdata.angles = {x_point, y_point, z_point}
    angle_x.Text = "Angles: {" .. truncate_number(x_point, 3) .. ", " .. truncate_number(y_point, 3) .. ", " .. truncate_number(z_point, 3) .. "}"
    _placingmesh()
    print("CFrame changed to " .. truncate_number(x_point, 3) .. ", " .. truncate_number(y_point, 3) .. ", " .. truncate_number(z_point, 3))
end)

negative_angle_x = _addsetting("Angles: {Down value, 0, 0}", function()
    local x_point = _scriptdata.angles[1]
    local y_point = _scriptdata.angles[2]
    local z_point = _scriptdata.angles[3]
    x_point -= _G._UpvalueRange
    _scriptdata.angles = {x_point, y_point, z_point}
    negative_angle_x.Text = "Angles: {" .. truncate_number(x_point, 3) .. ", " .. truncate_number(y_point, 3) .. ", " .. truncate_number(z_point, 3) .. "}"
    _placingmesh()
    print("CFrame changed to " .. truncate_number(x_point, 3) .. ", " .. truncate_number(y_point, 3) .. ", " .. truncate_number(z_point, 3))
end)

angle_y = _addsetting("Angles: {0, Up value, 0}", function()
    local x_point = _scriptdata.angles[1]
    local y_point = _scriptdata.angles[2]
    local z_point = _scriptdata.angles[3]
    y_point += _G._UpvalueRange
    _scriptdata.angles = {x_point, y_point, z_point}
    angle_y.Text = "Angles: {" .. truncate_number(x_point, 3) .. ", " .. truncate_number(y_point, 3) .. ", " .. truncate_number(z_point, 3) .. "}"
    _placingmesh()
    print("CFrame changed to " .. truncate_number(x_point, 3) .. ", " .. truncate_number(y_point, 3) .. ", " .. truncate_number(z_point, 3))
end)

negative_angle_y = _addsetting("Angles: {0, Down value, 0}", function()
    local x_point = _scriptdata.angles[1]
    local y_point = _scriptdata.angles[2]
    local z_point = _scriptdata.angles[3]
    y_point -= _G._UpvalueRange
    _scriptdata.angles = {x_point, y_point, z_point}
    negative_angle_y.Text = "Angles: {" .. truncate_number(x_point, 3) .. ", " .. truncate_number(y_point, 3) .. ", " .. truncate_number(z_point, 3) .. "}"
    _placingmesh()
    print("CFrame changed to " .. truncate_number(x_point, 3) .. ", " .. truncate_number(y_point, 3) .. ", " .. truncate_number(z_point, 3))
end)

angle_z = _addsetting("Angles: {0, 0, Up value}", function()
    local x_point = _scriptdata.angles[1]
    local y_point = _scriptdata.angles[2]
    local z_point = _scriptdata.angles[3]
    z_point += _G._UpvalueRange
    _scriptdata.angles = {x_point, y_point, z_point}
    angle_z.Text = "Angles: {" .. truncate_number(x_point, 3) .. ", " .. truncate_number(y_point, 3) .. ", " .. truncate_number(z_point, 3) .. "}"
    _placingmesh()
    print("CFrame changed to " .. truncate_number(x_point, 3) .. ", " .. truncate_number(y_point, 3) .. ", " .. truncate_number(z_point, 3))
end)

negative_angle_z = _addsetting("Angles: {0, 0, Down value}", function()
    local x_point = _scriptdata.angles[1]
    local y_point = _scriptdata.angles[2]
    local z_point = _scriptdata.angles[3]
    z_point -= _G._UpvalueRange
    _scriptdata.angles = {x_point, y_point, z_point}
    negative_angle_z.Text = "Angles: {" .. truncate_number(x_point, 3) .. ", " .. truncate_number(y_point, 3) .. ", " .. truncate_number(z_point, 3) .. "}"
    _placingmesh()
    print("CFrame changed to " .. truncate_number(x_point, 3) .. ", " .. truncate_number(y_point, 3) .. ", " .. truncate_number(z_point, 3))
end)
