--[[
	Replication - This script handles the replication of platforming actions that players are doing.
	Actions are validated and then replicated using an attribute on the character model.
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Constants = require(ReplicatedStorage.Platformer.Constants)
local validateString = require(ServerScriptService.Utility.TypeValidation.validateString)
local validateAction = require(script.validateAction)

local remotes = ReplicatedStorage.Platformer.Remotes
local setActionRemote = remotes.SetAction

local function onSetActionEvent(player: Player, action: string)
	-- Validate arguments
	if not validateString(action) then
		return
	end

	-- Make sure the player has a character
	local character = player.Character
	if not character then
		return
	end

	-- Make sure this is a valid action
	if not validateAction(action) then
		return
	end

	-- Since the client is already setting ACTION_ATTRIBUTE, we have the server set a separate REPLICATED_ACTION_ATTRIBUTE.
	-- This avoids issues where a client with poor connection could have the attribute overwritten by the server.
	character:SetAttribute(Constants.REPLICATED_ACTION_ATTRIBUTE, action)
end

setActionRemote.OnServerEvent:Connect(onSetActionEvent)