local RS = game:GetService("ReplicatedStorage")
local Bindables = RS:WaitForChild("LapizObjects"):WaitForChild("ClientBindables")

local Bindables = {
    SetupGui = Bindables:WaitForChild("SetupGui"),
    UpdateClient = Bindables:WaitForChild("UpdateClient")
}

local Gui = script.Parent
local MainFrame = Gui:WaitForChild("MainFrame")

local DisplayLabels = {
    GunName = MainFrame:WaitForChild("GunName"),
    CurrentAmmo = MainFrame:WaitForChild("CurrentAmmo"),
    SpareAmmo = MainFrame:WaitForChild("SpareAmmo")
}

Bindables.SetupGui.Event:Connect(function(visible)

    MainFrame.Visible = visible

end)

Bindables.UpdateClient.Event:Connect(function(currentammo, spareammo, toolname)

    DisplayLabels.GunName = toolname
    DisplayLabels.CurrentAmmo = currentammo
    DisplayLabels.SpareAmmo = spareammo

end)