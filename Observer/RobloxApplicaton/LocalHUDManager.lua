-- HELOMDRS
--[[ A local script localizated on StarterGui that control HUD operations ]]

-- SERVICES
local ReplicatedStorage = game:GetService('ReplicatedStorage')

-- FOLDERS
local hudEvents : Folder = ReplicatedStorage:WaitForChild('HUDEvents')

-- EVENTS
local updateStatsOnHUD : RemoteEvent = hudEvents:WaitForChild('UpdateStats')

-- METHODS
local function updateStats(player : Player, statsId : string, value : number) : nil
    print(player.Name, statsId, 'has increased to', value)
    -- Operations of update HUD objects here
end

-- CONNECTIONS

--[[ receives the signal from the observer module]]
updateStatsOnHUD.OnClientEvent:Connect(updateStats)