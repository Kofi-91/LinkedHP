--[[
	validateAction - A utility function to check if an action is actually valid to do.
	This is done by checking for the existence of action modules stored in ReplicatedStorage.Platformer.Scripts.Actions.

	Since using FindFirstChild can be expensive and this function will be called frequently by players,
	we opt to cache the list of valid actions.
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local actions = ReplicatedStorage.Platformer.Scripts.Actions

local validActions = {
	None = true,
}

for _, action in actions:GetChildren() do
	validActions[action.Name] = true
end

local function validateAction(action: string): boolean
	return validActions[action] or false
end

return validateAction