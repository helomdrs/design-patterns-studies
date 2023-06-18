-- HELOMDRS
--[[ A server script localizated on ServerScriptService that control players stats ]]

-- SERVICES
local ServerScriptService = game:GetService('ServerScriptService')
local ServerStorage = game:GetService('ServerStorage')

-- FOLDERS
local serverModules : Folder = ServerScriptService:WaitForChild('ServerModules')
local serverComms : Folder = ServerStorage:WaitForChild('ServerComms')

-- MODULES
local ObserverModule : ModuleScript = require(serverModules:WaitForChild('ObserverModule'))

-- EVENTS
local updateStats : BindableEvent = serverComms.Events:WaitForChild('UpdateStats')
local playerOnMinigame : BindableEvent = serverComms.Events:WaitForChild('PlayerEnteredMinigame')

-- METHODS
local function onUpdateStats(player : Player, stats : string, value : number) : nil
    -- in this case, we are considering the stats value beign the same as the listId of the observer module
    ObserverModule:notifyObservers(player, stats, value)
end

--[[ the same observer module can have multiple lists of players registered for multiple reasons ]]
local function managePlayerOnObserver(player : Player, toRegister : boolean, listId : string) : nil
    if toRegister then
        ObserverModule:registerPlayer(listId, player)
    else
        ObserverModule:unregisterObserver(listId, player)
    end
end

-- CONNECTIONS
-- [[ another script control the changes of that stats, adding or removing values to it. ]]
updateStats.Event:Connect(onUpdateStats)

--[[ player has entered a minigame that don't occur in a separated place, so it's necessary
to register who is in the minigame at the moment, registering and unregistering them as they 
enter and leave the minigame. ]]
playerOnMinigame.Event:Connect(managePlayerOnObserver)
