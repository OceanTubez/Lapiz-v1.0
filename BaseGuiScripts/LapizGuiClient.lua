local RS = game:GetService("ReplicatedStorage")
local Bindables = RS:WaitForChild("Lapiz"):WaitForChild("ClientBindables")

local Bindables = {
	SetupGui = Bindables:WaitForChild("SetupGui"),
	UpdateClient = Bindables:WaitForChild("UpdateClient")
}

local Gui = script.Parent
local MainFrame = Gui:WaitForChild("MainFrame")

local DisplayLabels = {
	GunName = MainFrame:WaitForChild("GunName"),
	Ammo = MainFrame:WaitForChild("AmmoDisplay")
}


Bindables.SetupGui.Event:Connect(function(visible)

	MainFrame.Visible = visible

end)

Bindables.UpdateClient.Event:Connect(function(currentammo, spareammo, toolname)
	
	DisplayLabels.GunName.Text = toolname
	DisplayLabels.Ammo.Text = currentammo.." / "..spareammo

end)
