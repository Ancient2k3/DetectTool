local core = game:GetService("CoreGui")
local menu = nil
loadstring(game:HttpGet("https://github.com/notpoiu/cobalt/releases/latest/download/Cobalt.luau"))()

function get_cobalt()
  for _, v in pairs(core:GetDescendants()) do
    if v:IsA("ScreenGui") and v.Name == "Cobalt" then
      return v
    end
  end return nil
end

repeat task.wait(0.01)
  menu = get_cobalt()
until game:IsLoaded() and menu ~= nil

print("Cobalt found...")
menu.UIScale.Scale = 0.8