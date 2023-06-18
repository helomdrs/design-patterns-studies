-- Class Subject
Subject = {}

function Subject:new()
    local newObj = { observers = {} }
    self.__index = self
    return setmetatable(newObj, self)
end

function Subject:registerObserver(observer)
    table.insert(self.observers, observer)
end

function Subject:unregisterObserver(observer)
    local index = nil
    for i, obs in ipairs(self.observers) do
        if obs == observer then
            index = i
            break
        end
    end

    if index ~= nil then
        table.remove(self.observers, index)
    end
end

function Subject:notifyObservers()
    for _, observer in ipairs(self.observers) do
        observer:update()
    end
end

-- Class Observer
Observer = {}

function Observer:new(name)
    local newObj = { name = name }
    self.__index = self
    return setmetatable(newObj, self)
end

function Observer:update()
    print(self.name .. " foi atualizado!")
end

-- Usage of Observer
local subject = Subject:new()

local observer1 = Observer:new("Observer 1")
local observer2 = Observer:new("Observer 2")
local observer3 = Observer:new("Observer 3")

subject:registerObserver(observer1)
subject:registerObserver(observer2)
subject:registerObserver(observer3)

subject:notifyObservers()

subject:unregisterObserver(observer2)

subject:notifyObservers()