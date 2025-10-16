-- Auto Welcome Message Fun_Randomizer --
local plrs
plrs = game:GetService("Players")

local plr
plr = plrs.LocalPlayer

local talk_message = loadstring(game:HttpGet("https://raw.githubusercontent.com/Ancient2k3/DetectTool/refs/heads/main/TalkMSG/MSG_STORAGE.luau"))() or {
    "Hello [owner]!",
    "Yooo, Hi friend of mine [user]!",
    context = {
        "%[owner%]",
        "%[user%]"
    }
}

function _randomuser()
    if #plrs:GetPlayers() > 1 then
        local plr = plrs:GetPlayers()[math.random(1, #plrs:GetPlayers())]
        return plr
    end
end

function _talk(str)
    str = tostring(str)
    local oldtxt = game:GetService("TextChatService")
    local newtxt = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
    if newtxt then newtxt.SayMessageRequest:FireServer(str_chat, "All")
    elseif oldtxt then
        local General = oldtxt.TextChannels.RBXGeneral
        if General then General:SendAsync(str) end
    end
end

function _randomtalk()
    local GetStr, NewStr = talk_message[math.random(1, #talk_message)], "N/A"
    if GetStr:match(talk_message.context[1]) then
        NewStr = string.gsub(GetStr, talk_message.context[1], plr.DisplayName)
    elseif GetStr:match(talk_message.context[2]) then
        NewStr = string.gsub(GetStr, talk_message.context[2], _randomuser().DisplayName)
    end _talk(NewStr)
end

_randomtalk()
