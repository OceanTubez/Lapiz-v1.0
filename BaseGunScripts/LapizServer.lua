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
local soundfolder = tool:WaitForChild("Sounds")

local settingmodule = require(tool:WaitForChild("Configuration"))
local CustomFastCastConfig = require(tool:WaitForChild("FastCastConfiguration"))
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

local castbehavior = CustomFastCastConfig.GetCastBehavior()
local castParams = CustomFastCastConfig.GetRaycastParams()

castbehavior.CastBehavior.RaycastParams = castParams.RayCastParam

if config.FastCastCustomizationEnabled == true then castbehavior.CastBehavior.CosmeticBulletTemplate = config.BulletTemplate end


local function fireweapon(plr, mospos)

	local origin = config.GunModel:WaitForChild("FirePoint").Position
	local vectordirection = (mospos - origin).Unit

	caster:Fire(origin, vectordirection, config.BulletSpeed, castbehavior)

end

caster.RayHit:Connect(function(cast, result, velocity, bullet)

	local hit = result.Instance

	local char = hit:FindFirstAncestorWhichIsA("Model")

	local human = char:FindFirstChild("Humanoid")

	if char and human then
		
		if hit.Name ~= "Head" then
			
			human:TakeDamage(config.BaseDamage)

		elseif hit.Name == "Head" and config.HeadshotDamageEnabled then

			human:TakeDamage(config.HeadshotDamage)

		elseif hit.Name == "Head" and config.HeadshotMultiEnabled then

			human:TakeDamage(config.BaseDamage * config.HeadMultiplier)

		elseif hit.Name == "Head" and config.HeadshotDamageEnabled and config.HeadshotMultiEnabled then

			warn("Error Code L4: Headshot damage settings colliding values(check documentation for more info)")

		elseif hit.Name == "Head" and config.HeadshotMultiEnabled == false and config.HeadshotDamageEnabled == false then

			human:TakeDamage(config.BaseDamage)
		end
	end

	game:GetService("Debris"):AddItem(bullet, 2)

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

if config.LimitedAmmo == false then spareAmmo.Value = math.huge end


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

local function updategui(plr)
	
	Remotes.Update:FireClient(plr, curAmmo.Value, spareAmmo.Value, tool.Name)
	
end

tool.Equipped:Connect(function()
	
	castParams.RayCastParam.FilterDescendantsInstances = {tool.Parent, castbehavior.CastBehavior.CosmeticBulletContainer}

	if not config.GunModel:IsA("Model") then warn("Error Code L1: Unable to detect GunModel. (refer to documentation for more info)") end
	if not config.GunModel:FindFirstChild("FirePoint") then warn("Error Code L2: Unable to detect FirePoint. (refer to documentation for more info)") end

	local char = tool.Parent

	local foundPlayer = game:GetService("Players"):GetPlayerFromCharacter(char)

	Remotes.SetupGui:FireClient(foundPlayer, true)
	updategui(foundPlayer)

	local humanoid = char:WaitForChild("Humanoid")

	local LoadedIdle = humanoid:LoadAnimation(Anims.IdleAnim)
	local LoadedReload = humanoid:LoadAnimation(Anims.ReloadAnim)
	local LoadedShoot = humanoid:LoadAnimation(Anims.ShootAnim)
	local LoadedInspect = humanoid:LoadAnimation(Anims.InspectAnim)

	LoadedIdle:Play()

	Remotes.Shoot.OnServerEvent:Connect(function(plr, pos)


		if config.Firemode == "Semi" and curAmmo.Value >= 1 and CanShoot.Value == true and IsReloading == false and IsInspecting == false then

			curAmmo.Value -= 1
			fireweapon(plr, pos)
			LoadedShoot:Play()
			CanShoot.Value = false
			firesound:Play()
			updategui(foundPlayer)


		elseif config.Firemode == "Auto" and curAmmo.Value >= 1 and CanShoot.Value == true and IsReloading == false and IsInspecting == false then

			RunService.RenderStepped:Connect(function(delta)

				curAmmo.Value -= 1
				fireweapon(plr, pos)
				LoadedShoot:Play()
				CanShoot.Value = false
				firesound:Play()
				updategui(foundPlayer)

			end)

		end

	end)

	Remotes.ChangeMagAmmo.OnServerEvent:Connect(function(plr)

		if not IsReloading and spareAmmo.Value >= 1 then
			IsReloading = true

			LoadedReload:Play()
			reloadsound:Play()

			if config.ReloadTimeEnabled == true then

				task.wait(config.ReloadTime)

			elseif config.ReloadAnimationLengthEnabled == true then

				task.wait(LoadedReload.Length)

			elseif config.ReloadAnimationLengthEnabled == true and config.ReloadTimeEnabled then

				warn("Error Code L3: Reload Time colliding values (refer to documentation for more info)")
			end

			local amounttochange = maxAmmo.Value - curAmmo.Value

			spareAmmo.Value -= amounttochange
			curAmmo.Value += amounttochange
			
			updategui(foundPlayer)

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

	end)

	tool.Unequipped:Connect(function()

		Remotes.SetupGui:FireClient(foundPlayer, false)
		LoadedIdle:Stop()
		LoadedReload:Stop()
		LoadedInspect:Stop()
		LoadedShoot:Stop()

	end)

end)





