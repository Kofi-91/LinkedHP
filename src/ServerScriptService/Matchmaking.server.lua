local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local QueueZone = workspace:WaitForChild("QueueZone") -- The part representing the queue zone
local playersInQueue = {}
local teleportingPlayers = {} -- Tracks players already queued for teleport
local PSID = "75907015334055" -- Private server ID

-- Validate QueueZone exists
if QueueZone then
	print("QueueZone is active.")
end

-- Create Region3 from the QueueZone part
local function getRegionFromPart(part)
	local size = part.Size
	local cframe = part.CFrame
	local min = cframe.Position - (size / 2)
	local max = cframe.Position + (size / 2)
	return Region3.new(min, max)
end

local queueRegion = getRegionFromPart(QueueZone)

-- Function to teleport players to a private server
local function teleportToPrivateServer()
	if #playersInQueue == 2 then
		local playersToTeleport = {playersInQueue[1], playersInQueue[2]}

		-- Mark players as teleporting
		for _, player in pairs(playersToTeleport) do
			teleportingPlayers[player.UserId] = true
		end

		-- Clear the queue of the teleporting players
		playersInQueue = {}

		local teleportOptions = Instance.new("TeleportOptions")
		teleportOptions.ShouldReserveServer = true

		TeleportService:TeleportAsync(PSID, playersToTeleport, teleportOptions)

		-- Clean up teleporting players after teleport
		for _, player in pairs(playersToTeleport) do
			teleportingPlayers[player.UserId] = nil
		end
	end
end

-- Function to add a player to the queue
local function addToQueue(player)
	if not table.find(playersInQueue, player) and not teleportingPlayers[player.UserId] then
		table.insert(playersInQueue, player)
		print(player.Name .. " joined the queue.")
	end

	if #playersInQueue == 2 then
		teleportToPrivateServer()
	end
end

-- Function to remove a player from the queue
local function removeFromQueue(player)
	local index = table.find(playersInQueue, player)
	if index then
		table.remove(playersInQueue, index)
		print(player.Name .. " left the queue.")
	end
end

-- Check which players are in the queue region
RunService.Heartbeat:Connect(function()
	local region = queueRegion
	local parts = workspace:FindPartsInRegion3(region, nil, math.huge)

	local playersInRegion = {}
	for _, part in pairs(parts) do
		local character = part.Parent
		local player = Players:GetPlayerFromCharacter(character)
		if player and not table.find(playersInRegion, player) then
			table.insert(playersInRegion, player)
		end
	end

	-- Add new players to the queue
	for _, player in pairs(playersInRegion) do
		addToQueue(player)
	end

	-- Remove players who have left the region
	for _, player in pairs(playersInQueue) do
		if not table.find(playersInRegion, player) and not teleportingPlayers[player.UserId] then
			removeFromQueue(player)
		end
	end
end)