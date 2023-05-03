-- HELOMDRS
--[[ A simple player's stamina local database singleton ]]

local module = {}

-- SERVICES
local RunService = game:GetService('RunService')
local DataStoreService = game:GetService('DataStoreService')

-- CONSTANTS
local RETRY_LIMIT = 5
local RETRY_INTERVAL = 1

-- CONSTRUCTOR
function module.new()
	local dataTable = setmetatable(
		{
			-- Staminas availables
			StaminasKeys = {
				Default = "Default",
				Mana = "Mana",
				Energy = "Energy"
			},

			-- Datastore keys
			DATASTORE_KEY = "Players_Staminas",
			PLAYER_KEY = "_Stamina",

			-- Roblox's Datastore
			staminaDataStore = nil,

			-- Local dictionary datastore
			staminaData = {}
		},
		module
	)

	local proxyTable = setmetatable({},
		{
			__index = function(self, index)
				return dataTable[index]
			end,

			__newindex = function(self, index, newValue)
				dataTable[index] = newValue
			end
		}
	)

	return proxyTable
end

-- LOCAL FUNCTIONS
-- Create the default data to be saved on datastore
local function getDefaultData()
	return {Default = 10}
end

-- CLASS METHODS
function module:getAllPlayerData(player)
	if RunService:IsClient() then return end
	local playerData = self.staminaData[player.UserId]
	if playerData ~= nil then
		return playerData
	else 
		warn('stamina data not yet set for', player)
	end
end

-- Get the stamina data from the local dictionary
function module:getPlayerData(player, parameter)
	if RunService:IsClient() then return end
	local playerData = self.staminaData[player.UserId]
	if playerData ~= nil then
		if not parameter then parameter = "Default" end
		return playerData[parameter]
	else 
		warn('stamina data not yet set for', player)
	end
end

-- Set the stamina data on the local dictionary
function module:setPlayerData(player, parameter, value)
	if RunService:IsClient() then return end
	if not parameter then parameter = "Default" end
	self.staminaData[player.UserId][parameter] = value
end

-- Load the saved or new data from the datastore to the local dictionary - called on playeradded
function module:loadPlayerData(player)
	if RunService:IsClient() then return end
	self.staminaDataStore = DataStoreService:GetDataStore(self.DATASTORE_KEY)
	local pKey = tostring(player.UserId)..(self.PLAYER_KEY)
	
	local currentRetries = 0
	repeat
		currentRetries += 1

		local success, loadedData = pcall(function()
			return self.staminaDataStore:GetAsync(pKey)
		end)

		if success then
			self.staminaData[player.UserId] = loadedData or getDefaultData()

			for _, key in ipairs(self.StaminasKeys:GetChildren()) do
				if self.staminaData[player.UserId][key.Value] == nil then
					self.staminaData[player.UserId][key.Value] = 0
				end
			end
			print('loaded player stamina data:', self.staminaData[player.UserId])
			break
		end

		wait(RETRY_INTERVAL)
	until currentRetries == RETRY_LIMIT
end

-- Save the data from the local dic to the datastore - called on player removing
function module:savePlayerData(player)
	if RunService:IsClient() then return end
	print('saving player stamina data', self.staminaData[player.UserId])
	
	local pKey = tostring(player.UserId)..(self.PLAYER_KEY)
	local success, errorMsg = pcall(function()
		return self.staminaDataStore:SetAsync(pKey, self.staminaData[player.UserId])
	end)

	if not success then
		warn(errorMsg)
	else
		self.staminaData[player.UserId] = nil
	end
end

-- Erease the player's data from the datastore
function module:RemovePlayerData(player)
	if RunService:IsClient() then return end
	local pKey = tostring(player.UserId)..(self.PLAYER_KEY)
	local success, removedData = pcall(function()
		return self.staminaDataStore:RemoveAsync(pKey)
	end)
	if success then
		print('datastore cleaned', removedData)
		self.staminaData[player.UserId] = nil
	else 
		print('could not clean currency data')
	end
end

module.__index = module

local singleton = module.new()

return singleton
