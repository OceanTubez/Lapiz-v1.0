--[[

Created by OceanTubez.

Version 1.0

Lapiz Gun System (server)

--]]
local tool = script.Parent
local assets = tool:WaitForChild("Assets")

local handle = tool:WaitForChild("Handle")

local settingmodule = require(tool:WaitForChild("Configuration"))
local FastCast = require(assets:WaitForChild("FastCastRedux"))

local config = settingmodule.Settings

local Remotes = {
  ChangeMagAmmo = tool:WaitForChild("ChangeMagAmmo"),
  Shoot = tool:WaitForChild("Shoot"),
  Inspect = tool:WaitForChild("Inspect")
}

-- Setting up ammo

local curAmmo = handle:WaitForChild("Ammo")
local maxAmmo = handle:WaitForChild("MaxAmmo")
local spareAmmo = handle:WaitForChild("SpareAmmo")
local maxspareAmmo = handle:WaitForChild("MaxSpareAmmo")

curAmmo.Value = config.AmmoPerMag
maxAmmo.Value = config.MaxAmmoPerMag
spareAmmo.Value = config.StartingAmmo
maxspareAmmo.Value = config.MaxAmmo

-- Setting up animations

local Anims = {
  IdleAnim = tool:WaitForChild("Idle"),
  ReloadAnim = tool:WaitForChild("Reload"),
  InspectAnim = tool:WaitForChild("Inspect"),
  ShootAnim = tool:WaitForChild("Shoot")
}

Anims.IdleAnim.AnimationId = config.IdleAnimation

Remotes.ChangeMagAmmo.OnServerEvent:Connect(function()
    
    
    
end)

