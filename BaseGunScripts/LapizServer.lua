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

caster.RayHit:Connect(function(cast, result, velocity, bullet)

	local hit = result.Instance

	local char = hit:FindFirstAncestorWhichIsA("Model")

	local human = char:FindFirstChild("Humanoid")

	if char and human then
		
		if hit.Name == "Head" and config.HeadshotDamageEnabled then
		
			human:TakeDamage(config.HeadshotDamage)

		elseif hit.Name == "Head" and config.HeadshotMultiEnabled then

			human:TakeDamage(config.BaseDamage * config.HeadMultiplier)

		elseif hit.Name == "Head" and config.HeadshotDamageEnabled and config.HeadshotMultiEnabled then

			warn("Error Code L4: Headshot damage settings colliding values(check documentation for more info)")
		
		elseif hit.Name == "Head" and config.HeadshotMultiEnabled == false and config.HeadshotDamageEnabled == false then

			human:TakeDamage(config.BaseDamage)

		elseif hit.Name ~= "Head" then

			human:TakeDamage(config.BaseDamage)

		end
	end

end)

local Remotes = {
	ChangeMagAmmo = remotefold:WaitForChild("ChangeMagAmmo"),
	Shoot = remotefold:WaitForChild("Shoot"),
	Inspect = remotefold:WaitForChild("Inspect"),
	Update = remotefold:WaitForChild("Update"),
	SetupGui = remotefold:WaitForChild("SetupGui")
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

local IsReloading = false
local IsInspecting = false

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

	local foundPlayer = game:GetService("Players"):GetPlayerFromCharacter(char))

	Remotes.SetupGui:FireClient(foundPlayer)
	Remotes.Update:FireClient(foundPlayer, curAmmo.Value, spareAmmo.Value, tool.Name)
	
	local humanoid = char:WaitForChild("Humanoid")
	
	local LoadedIdle = humanoid:LoadAnimation(Anims.IdleAnim)
	local LoadedReload = humanoid:LoadAnimation(Anims.ReloadAnim)
	local LoadedShoot = humanoid:LoadAnimation(Anims.ShootAnim)
	local LoadedInspect = humanoid:LoadAnimation(Anims.InspectAnim)
	
	LoadedIdle:Play()

	Remotes.Shoot.OnServerEvent:Connect(function(plr, pos)

		if config.Firemode == "Semi" and CanShoot == true and IsReloading == false and IsInspecting == false then
	
			curAmmo.Value -= 1
			fireweapon(plr, pos)
			LoadedShoot:Play()
			CanShoot = false
			
	
		elseif config.Firemode == "Auto" and CanShoot == true and IsReloading == false and IsInspecting == false then
	
			RunService.RenderStepped:Connect(function(delta)
				
				curAmmo.Value -= 1
				fireweapon(plr, pos)
				LoadedShoot:Play()
				CanShoot = false

			end
	
		end
	
	end)

	Remotes.ChangeMagAmmo.OnServerEvent:Connect(function(plr)

		if not IsReloading then
			IsReloading = true

			LoadedReload:Play()
			reloadsound:Play()

			if config.ReloadTimeEnabled == true then

				task.wait(config.ReloadTime)

			elseif config.ReloadAnimationLengthEnabled == true then

				task.wait(LoadedReload.Length)

			elseif config.ReloadAnimationLengthEnabled == true and config.

				warn("Error Code L3: Reload Time colliding values (refer to documentation for more info)")

			end
	
			local amounttochange = maxAmmo.Value - curAmmo.Value
	
			spareAmmo.Value -= amounttochange
			curAmmo.Value = maxAmmo.Value
	
			IsReloading = false
		end

	end)

	Remotes.Inspect.OnServerEvent:Connect(function(plr)

		if not IsInspecting then
			IsInspecting = true

			inspectsound:Play()
			LoadedInspect:Play()
	
			task.wait(LoadedInspect.Length)
	
			IsInspecting = false
		end

	end

	tool.Unequipped:Connect(function()
		
		LoadedIdle:Stop()
		LoadedReload:Stop()
		LoadedInspect:Stop()
		LoadedShoot:Stop()
		game.ReplicatedStorage.Remote.DisconnectM6D:FireServer()
		
	end)i

	
end)

