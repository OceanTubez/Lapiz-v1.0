local config = {}

config.Settings = {
  
  Firemode = "Semi", -- Can be any of these: Auto, Semi
  Firerate = 0.1, -- In seconds (how many secs per bullet for auto)
  BaseDamage = 20, -- Damage for all body parts excluding head
  
  -- Headshot configuration
  
  HeadshotMultiEnabled = false, -- multiply base damage instead of setting damage for headshots?
  HeadMultiplier = 1, -- How much damage is multiplied by if multiplier is enabled
  HeadshotDamageEnabled = true, -- set damage instead of multiplying base damage for headshots?
  HeadshotDamage = 45, -- How much damage per headshot if damage is enabled
  
  -- Animation configuration
  
  IdleAnimation = nil, -- Set to nil if none (must be looped if it is existing)
  FireAnimation = nil
  
}



return config
