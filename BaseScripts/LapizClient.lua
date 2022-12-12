--[[

Created by OceanTubez.

Version 1.0

Lapiz Gun System (client)

--]]

local tool = script.Parent

local Remotes = {
  ChangeMagAmmo = tool:WaitForChild("ChangeMagAmmo"),
  Shoot = tool:WaitForChild("Shoot"),
  Inspect = tool:WaitForChild("Inspect")
}

local UIS = game:GetService("UserInputService")

UIS.InputBegan:Connect(function(input, gpe)
    
    if input.InputType == Enum.InputType.Keyboard then
      
      if input.KeyCode == Enum.KeyCode.R then
        
        Remotes.ChangeMagAmmo:FireServer()
        
      elseif input.KeyCode == Enum.KeyCode.F then
        
        Remotes.Inspect:FireServer()
        
      end
      
    end
    
end)

tool.Activated:Connect(function()
    
    Remotes.Shoot:FireServer()
    
end)
