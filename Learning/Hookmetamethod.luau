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
