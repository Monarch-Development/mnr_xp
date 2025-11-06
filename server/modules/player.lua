local config = require 'config.server'
local database = require 'server.modules.database'

---@class player
---@field source number | string
---@field identifier string
---@field data table
local player = {}
player.__index = player

-- Creates a new player instance
---@param playerId number | string
---@return player
function player.new(playerId)
    local self = setmetatable({}, player)
    self.source = playerId
    self.identifier = framework.GetIdentifier(playerId)

    self.data = {}

    for name in pairs(config) do
        local playerXp = database.RetrievePlayerData(self.identifier, name)
        if playerXp then
            self.data[name] = { xp = playerXp.xp, level = playerXp.level, max = config[name].baseXp * playerXp.level }
        else
            self.data[name] = { xp = 0, level = 1, max = config[name].baseXp }
        end
    end

    return self
end

-- Calculates the XP required to reach the next level
---@param name string category name
---@return number
function player:requiredXp(name)
    local level = self.data[name] and self.data[name].level

    return config[name].baseXp * level
end

-- Calculates the new level and remaining XP based on the player's current XP
---@param name string category name
---@return number level, number xp
function player:newLevel(name)
    local entry = self.data[name]

    local level = entry.level
    local xp = entry.xp

    local requiredXp = self:requiredXp(name)
    if xp >= requiredXp then
        xp -= requiredXp
        level += 1
    end

    return level, xp
end

-- Adds XP to a player
---@param name string category name
---@param amount number XP to add
function player:addXp(name, amount)
    local entry = self.data[name]

    entry.xp += amount

    local newLevel, newXp = self:newLevel(name)
    local oldLevel = entry.level

    entry.level = newLevel
    entry.xp = newXp

    TriggerEvent('mnr:server:XpEarned', self.source, self.identifier, name, entry.xp, amount)
    if newLevel > oldLevel then
        entry.max = config[name].baseXp * newLevel
        TriggerEvent('mnr:server:LevelUp', self.source, self.identifier, name, oldLevel, newLevel)
    end

    return true
end

-- Returns the current XP of the player for a category
---@param name string category name
---@return number
function player:getXp(name)
    return self.data[name] and self.data[name].xp or 0
end

-- Returns the current level of the player for a category
---@param name string category name
---@return number
function player:getLevel(name)
    return self.data[name] and self.data[name].level or 1
end

-- Returns all XP data for the player
---@return table
function player:getAll()
    return self.data
end

function player:save()
    for name, data in pairs(self.data) do
        database.SavePlayerData(self.identifier, name, data)
    end
end

return player