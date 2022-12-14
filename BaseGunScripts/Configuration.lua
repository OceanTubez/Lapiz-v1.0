local config = {}

config.Settings = {
	
	-- REALLY IMPORTANT
	
	GunModel = script.Parent:WaitForChild("Gun"), -- Reference your gun model for the weapon

	Firemode = "Semi", -- Can be any of these: Auto, Semi
	Firerate = 0.1, -- In seconds (how many secs per bullet for auto)
	BaseDamage = 20, -- Damage for all body parts excluding head
	AmmoPerMag = 12, -- Ammo per magazine before having to reload (also includes starting ammo)
	MaxAmmoPerMag = 12, -- max ammo per magazine
	BulletSpeed = 100, -- bullet velocity (higher = faster)

	-- Reload configuration

	ReloadTimeEnabled = false, -- Set reload time
	ReloadTime = nil, -- set reload time
	ReloadAnimationLengthEnabled = true, -- reload time in length of reload animation

	-- Ammo configuration

	LimitedAmmo = true, -- have limited ammo (spare ammo)
	MaxAmmo = 60, -- Max amount of ammo
	StartingAmmo = 45, -- spare ammo you start with

	-- Headshot configuration

	HeadshotMultiEnabled = false, -- multiply base damage instead of setting damage for headshots?
	HeadMultiplier = 1, -- How much damage is multiplied by if multiplier is enabled
	HeadshotDamageEnabled = true, -- set damage instead of multiplying base damage for headshots?
	HeadshotDamage = 45, -- How much damage per headshot if damage is enabled

	-- Animation configuration

	IdleAnimation = "rbxassetid://0", -- Set to "rbxassetid://0" if none (must be looped if it is existing) priority idle
	FireAnimation = "rbxassetid://0", -- must be priority action
	ReloadAnimation = "rbxassetid://0", -- must be proority action
	InspectAnimation = "rbxassetid://0", -- must also be action

	-- Viewmodel configuration [BETA] (feature enabled no choice yet)

	ViewModelEnabled = true, -- recommended to be turned on
	WalkCycle = true, -- Bobbing when moving?
	Sway = true, -- Swaying when moving camera?

	-- Sounds

	-- For normal sounds, check the sounds folder.

	-- For the 'precise' sounds, please configure them here.

	AnimationEventSounds = {

		["ExampleEvent"] = function()

			print("ExampleEvent Function ran!")

		end)

	}

}


return config
