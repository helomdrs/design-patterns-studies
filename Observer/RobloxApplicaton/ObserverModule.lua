-- HELOMDRS
--[[ The observer module made on a ModuleScript localizated on ServerScriptService ]]
local module = {}

-- CLASS METHODS
function module.new()
    local dataTable = setmetatable(
		{
            -- all available lists registered in the module
			availableLists = {}
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

--[[ The same observer object can have multiple lists opened, each one with its own
remote event to update the players, using just the list id as a parameter ]]
function module:openNewList(listId : string, updateEvent : RemoteEvent) : nil
    if not self.availableLists[listId] then
        self.availableLists[listId] = {
            UpdateEvent = updateEvent,
            Players = {}
        }
    else
        print(listId, 'list already exists')
    end
end

function module:registerObserver(listId : string, player : Player) : nil
    if self.availableLists[listId] then
        table.insert(self.availableLists[listId].Players, player)
    else
        print(listId, 'dont exist yet, please create it first with the update event')
    end
end

function module:unregisterObserver(listId : string, player : Player) : nil
    if self.availableLists[listId] then
        local playerPosOnList = table.find(self.availableLists[listId].Players, player)
        if playerPosOnList then
            table.remove(self.availableLists[listId].Players, player)
            print(player, 'removed from', listId, 'list')
            --[[ here we can even close the list if there's no more players on it ]]
        else
            print(player, 'is not on', listId, 'list')
        end
    end
end

--[[ it can be used with a Players.PlayerRemoving event ]]
function module:unregisterPlayerOfAllLists(player : Player) : nil
    for listId, _ in pairs(self.availableLists) do
        module:unregisterObserver(listId, player)
    end
end

--[[ in this case, the value is a number but it can be anything ]]
function module:notifyObservers(listId : string, value : number) : nil
    if self.availableLists[listId] then
        local updateEvent = self.availableLists[listId].UpdateEvent
        for _, player in ipairs(self.availableLists[listId].Players) do
            updateEvent:FireClient(player, value)
        end
    end
end

return module