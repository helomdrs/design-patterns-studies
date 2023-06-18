local Singleton = {}

local instance = nil

function Singleton:new()
    if not instance then
        instance = {}
        setmetatable(instance, self)
        self.__index = self
    end

    return instance
end