--[[

Created by OceanTubez.

Version 1.0

Lapiz Gun System (server)

--]]
local tool = script.Parent
local assets = tool:WaitForChild("Assets")
local animfolder = tool:WaitForChild("Animations")
local remotefold = tool:WaitForChild("Events")

local settingmodule = require(tool:WaitForChild("Configuration"))
local FastCast = require(assets:WaitForChild("FastCastRedux"))

local config = settingmodule.Settings

local Remotes = {
	ChangeMagAmmo = remotefold:WaitForChild("ChangeMagAmmo"),
	Shoot = remotefold:WaitForChild("Shoot"),
	Inspect = remotefold:WaitForChild("Inspect")
}

-- Setting up ammo

local curAmmo = tool:WaitForChild("Ammo")
local maxAmmo = tool:WaitForChild("MaxAmmo")
local spareAmmo = tool:WaitForChild("SpareAmmo")
local maxspareAmmo = tool:WaitForChild("MaxSpareAmmo")

curAmmo.Value = config.AmmoPerMag
maxAmmo.Value = config.MaxAmmoPerMag
spareAmmo.Value = config.StartingAmmo
maxspareAmmo.Value = config.MaxAmmo

-- Setting up animations

local Anims = {
	IdleAnim = animfolder:WaitForChild("Idle"),
	ReloadAnim = animfolder:WaitForChild("Reload"),
	InspectAnim = animfolder:WaitForChild("Inspect"),
	ShootAnim = animfolder:WaitForChild("Shoot")
}

Anims.IdleAnim.AnimationId = config.IdleAnimation
Anims.ReloadAnim.AnimationId = config.ReloadAnimation
Anims.ShootAnim.AnimationId = config.FireAnimation
Anims.InspectAnim.AnimationId = config.InspectAnimation

tool.Equipped:Connect(function()
	
	local char = tool.Parent
	game.ReplicatedStorage.Remote.ConnectM6D:FireServer(config.GunModel.BodyAttach)
	char.Torso.ToolGrip.Part0 = char.Torso
	char.Torso.ToolGrip.Part1 = config.GunModel.BodyAttach
	
end)

Remotes.ChangeMagAmmo.OnServerEvent:Connect(function()



end)
