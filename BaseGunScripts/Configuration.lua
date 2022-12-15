local config = {}

config.Settings = {

	-- REALLY IMPORTANT

	GunModel = script.Parent:WaitForChild("Gun"), -- Reference your gun model for the weapon

	Firemode = "Semi", -- Can be any of these: Auto, Semi
	Firerate = 0.1, -- In seconds (how many secs per bullet for auto)
	BaseDamage = 25, -- Damage for all body parts excluding head
	AmmoPerMag = 12, -- Ammo per magazine before having to reload (also includes starting ammo)
	MaxAmmoPerMag = 12, -- max ammo per magazine
	BulletSpeed = 1000, -- bullet velocity (higher = faster)

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
	HeadshotDamage = 10, -- How much damage per headshot if damage is enabled

	-- Animation configuration

	IdleAnimation = "rbxassetid://9065227216", -- Set to nil if none (must be looped if it is existing) priority idle
	FireAnimation = "rbxassetid://9065222174", -- must be priority action
	ReloadAnimation = "rbxassetid://9065224798", -- must be proority action
	InspectAnimation = "rbxassetid://9065227216",

	-- Viewmodel configuration [BETA] (feature enabled no choice yet)

	ViewModelEnabled = true, -- recommended to be turned on
	WalkCycle = true, -- Bobbing when moving?
	Sway = true, -- Swaying when moving camera?
	
	-- FastCast config [BETA] (for more config go to fastcast config scritp itself)
	
	FastCastCustomizationEnabled = true,
	BulletTemplate = game:GetService("ReplicatedStorage"):WaitForChild("Lapiz"):WaitForChild("BulletTemplates"):WaitForChild("Bullet") -- Custom Bullet (reference here)

}


return config
