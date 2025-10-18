local targetName = "MyButtonRemote" -- change to the remote's Name

local originalNamecall
originalNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    if checkcaller() then return originalNamecall(self, ...) end
    local method = getnamecallmethod()
    if (method == "FireServer" or method == "InvokeServer") then
        if type(self) == "userdata" and (self.ClassName == "RemoteEvent" or self.ClassName == "RemoteFunction") then
            if self.Name == targetName then
                print("hello")
                return originalNamecall(self, ...)
            end
        end
    end
    return originalNamecall(self, ...)
end)

-- Version 2 --

local targetName = "MyButtonRemote"

local originalNamecall
originalNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    if checkcaller() then return originalNamecall(self, ...) end

    local method = getnamecallmethod()
    local args = {...}

    if (method == "FireServer" or method == "InvokeServer") then
        if typeof(self) == "Instance" and (self:IsA("RemoteEvent") or self:IsA("RemoteFunction")) then
            if self.Name == targetName then
                for _, arg in ipairs(args) do
                    if type(arg) == "table" and arg["Goal"] == "PingCheck" then
                        return originalNamecall(self, ...)
                    end
                end
                print("hello")
            end
        end
    end

    return originalNamecall(self, ...)
end)
