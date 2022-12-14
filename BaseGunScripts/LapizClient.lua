--[[

Created by OceanTubez.

Version 1.0

Lapiz Gun System (client)

--]]
local tool = script.Parent
local config = require(tool:WaitForChild("Configuration")).Settings
local remotefolder = tool:WaitForChild("Events")
local bindablesfolder = game:GetService("ReplicatedStorage"):WaitForChild("Lapiz"):WaitForChild("ClientBindables")

local Remotes = {
	ChangeMagAmmo = remotefolder:WaitForChild("ChangeMagAmmo"),
	Shoot = remotefolder:WaitForChild("Shoot"),
	Inspect = remotefolder:WaitForChild("Inspect")
}

local Bindables = {
	SetupGui = bindablesfolder:WaitForChild("SetupGui"),
	Update = bindablesfolder:WaitForChild("Update")
}

local UIS = game:GetService("UserInputService")

UIS.InputBegan:Connect(function(input, gpe)

	if input.UserInputType == Enum.UserInputType.Keyboard then

		if input.KeyCode == Enum.KeyCode.R then

			Remotes.ChangeMagAmmo:FireServer()

		elseif input.KeyCode == Enum.KeyCode.F then

			Remotes.Inspect:FireServer()

		end

	end

end)

tool.Activated:Connect(function()

	Remotes.Shoot:FireServer(game.Players.LocalPlayer:GetMouse().Hit.Position)

end)

tool.Equipped:Connect(function()
	
	local char = tool.Parent
	game.ReplicatedStorage.Lapiz.ServerEvents.ConnectM6D:FireServer(config.GunModel.BodyAttach)
	char.Torso.ToolGrip.Part0 = char.Torso
	char.Torso.ToolGrip.Part1 = config.GunModel.BodyAttach
	
end)

tool.Unequipped:Connect(function()
	
	game.ReplicatedStorage.Lapiz.ServerEvents.DisconnectM6D:FireServer()
	
end)
