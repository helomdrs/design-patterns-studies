local Singleton = {}

function Singleton:new()
    local instance = {}
    setmetatable(instance, self)
    self.__index = self
    return instance
end

local instance = Singleton:new()

return instance