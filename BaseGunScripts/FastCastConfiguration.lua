-- Proceed with caution, this script is only for people who know how to edit fastcast behavior.

local fastcastconfig = {}

local FastCast = require(script.Parent:WaitForChild("Assets"):WaitForChild("FastCastRedux"))

local CastBehaviorTable = {
	
	CastBehavior = FastCast.newBehavior()
	
}

CastBehaviorTable.CastBehavior.Acceleration = Vector3.new(0, -game:GetService("Workspace").Gravity, 0)
CastBehaviorTable.CastBehavior.AutoIgnoreContainer = true
CastBehaviorTable.CastBehavior.CosmeticBulletContainer = game:GetService("Workspace"):WaitForChild("LapizBulletContainer")

local RaycastParamTable = {
	
	RayCastParam = RaycastParams.new()
	
}

RaycastParamTable.RayCastParam.FilterType = Enum.RaycastFilterType.Blacklist
RaycastParamTable.RayCastParam.IgnoreWater = true

fastcastconfig.GetCastBehavior = function()
	
	return CastBehaviorTable
	
end

fastcastconfig.GetRaycastParams = function()
	
	return RaycastParamTable
	
end

return fastcastconfig
