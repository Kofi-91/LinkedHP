local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local dataStore = DataStoreService:GetDataStore("PlayerCoinData") -- Same DataStore used for saving coins

local function loadPlayerCoins(player: Player): number
	local success, data = pcall(function()
		return dataStore:GetAsync(player.UserId)
	end)

	if success and data then
		return data
	else
		warn("Failed to load coins for player: " .. player.Name)
		return 0 -- Default to 0 coins if data cannot be loaded
	end
end

local function onPlayerAdded(player: Player)
	-- Create leaderstats for display
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local coins = Instance.new("IntValue")
	coins.Name = "Coins"
	coins.Parent = leaderstats

	-- Retrieve coins from DataStore and set value
	local savedCoins = loadPlayerCoins(player)
	coins.Value = savedCoins
end

local function onPlayerRemoving(player: Player)
	-- No saving needed in this script
end

local function initialize()
	Players.PlayerAdded:Connect(onPlayerAdded)
	Players.PlayerRemoving:Connect(onPlayerRemoving)
end

initialize()