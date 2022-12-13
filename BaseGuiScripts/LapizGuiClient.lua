local RS = game:GetService("ReplicatedStorage")
local Bindables = RS:WaitForChild("LapizObjects"):WaitForChild("ClientBindables")

local Bindables = {
    SetupGui = Bindables:WaitForChild("SetupGui"),
    UpdateClient = Bindables:WaitForChild("UpdateClient")
}

Bindables.SetupGui.Event:Connect(function())