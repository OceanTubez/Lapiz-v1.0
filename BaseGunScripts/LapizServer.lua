--[[

Created by OceanTubez.

Version 1.0

Lapiz Gun System (server)

--]]
local tool = script.Parent
local assets = tool:WaitForChild("Assets")
local animfolder = tool:WaitForChild("Animations")
local remotefold = tool:WaitForChild("Events")
local CanShoot = tool:WaitForChild("CanShoot")
local soundfolder = tool:WaitForChild("")

local settingmodule = require(tool:WaitForChild("Configuration"))
local FastCast = require(assets:WaitForChild("FastCastRedux"))

local RunService = game:GetService("RunService")

local config = settingmodule.Settings

-- Setting up sounds

local firesound = soundfolder:WaitForChild("FireSound")
local reloadsound = soundfolder:WaitForChild("ReloadSound")
local inspectsound = soundfolder:WaitForChild("InspectSound")

-- Setting up fastcast

FastCast.VisualizeCasts = false

local caster = FastCast.new()

local function fireweapon(plr, mospos)

	local origin = config.GunModel:WaitForChild("FirePoint").WorldPosition
	local vectordirection = (mospos - origin).Unit

	caster:Fire(origin, vectordirection, config.BulletSpeed)

end

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

CanShoot.Changed:Connect(function()

	if CanShoot.Value == false then

		task.wait(config.Firerate)
		CanShoot.Value = true

	end

end)

tool.Equipped:Connect(function()
	
	if not config.GunModel:IsA("Model") then warn("Error Code L1: Unable to detect GunModel. (refer to documentation for more info)")
 	if not config.GunModel:FindFirstChild("FirePoint") then warn("Error Code L2: Unable to detect FirePoint. (refer to documentation for more info)")
	
	local char = tool.Parent
	game.ReplicatedStorage.Remote.ConnectM6D:FireServer(config.GunModel.BodyAttach)
	char.Torso.ToolGrip.Part0 = char.Torso
	char.Torso.ToolGrip.Part1 = config.GunModel.BodyAttach
	
	local humanoid = char:WaitForChild("Humanoid")
	
	local LoadedIdle = humanoid:LoadAnimation(Anims.IdleAnim)
	local LoadedReload = humanoid:LoadAnimation(Anims.ReloadAnim)
	local LoadedShoot = humanoid:LoadAnimation(Anims.ShootAnim)
	local LoadedInspect = humanoid:LoadAnimation(Anims.InspectAnim)
	
	LoadedIdle:Play()

	Remotes.Shoot.OnServerEvent:Connect(function(plr, pos)

		if config.Firemode == "Semi" and CanShoot == true then
	
			curAmmo.Value -= 1
			fireweapon(plr, pos)
			LoadedShoot:Play()
			CanShoot = false
			
	
		elseif config.Firemode == "Auto" and CanShoot == true then
	
			RunService.RenderStepped:Connect(function(delta)
				
				curAmmo.Value -= 1
				fireweapon(plr, pos)
				LoadedShoot:Play()
				CanShoot = false

			end
	
		end
	
	end)

	Remotes.ChangeMagAmmo.OnServerEvent:Connect(function(plr)

		LoadedReload:Play()
		reloadsound:Play()

		

	end)

	
end)


tool.Unequipped:Connect(function()
	
	game.ReplicatedStorage.Remote.DisconnectM6D:FireServer()
	
end)
