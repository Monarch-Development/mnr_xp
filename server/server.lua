---@description Dependency ensuring
assert(GetResourceState('ox_lib') == 'started', 'ox_lib not found or not started before this script, install or start before ox_lib')

---@description Name/Update Checker
---@diagnostic disable-next-line: missing-parameter
local correctName = GetResourceMetadata(GetCurrentResourceName(), 'name')

AddEventHandler('onResourceStart', function(name)
    if GetCurrentResourceName() ~= name then return end

    assert(GetCurrentResourceName() == correctName, ('The resource name is incorrect. Please set it to %s.^0'):format(correctName))
end)

lib.versionCheck(('Monarch-Development/%s'):format(correctName))

local config = require 'config.server'
local class = require 'server.modules.player'

local players = {}

-- Helper function to check memory to validate params
---@param src number Id of the player
---@param name? string Name of the category
local function registryCheck(src, name)

    if src and not players[src] then
        return false
    end

    if name and not config[name] then
        return false
    end

    return true
end

-- Event triggered after player character login to initialize his class
---@param source number
AddEventHandler('mnr_xp:server:InitPlayerXp', function(source)
    local src = source

    if not players[src] then
        players[src] = class.new(src)
    end
end)

AddEventHandler('playerDropped', function()
    local src = source

    if not registryCheck(src) then
        return
    end

    players[src]:save()
    players[src] = nil
end)

-- Event triggered when a scheduled restart of the server is near
---@param data table
AddEventHandler('txAdmin:events:scheduledRestart', function(data)
    if data.secondsRemaining ~= 60 then return end

    for _, player in pairs(players) do
        player:save()
    end
end)

-- Event triggered to add XP to a player
---@param source number
---@param name string
---@param amount number
AddEventHandler('mnr_xp:server:AddXp', function(source, name, amount)
    local src = source

    if not registryCheck(src, name) then
        return
    end

    players[src]:addXp(name, amount)
end)

-- Function with its relative export to get XP of a player
---@param source number
---@param name string
---@return number | boolean
local function GetXp(source, name)
    local src = source

    if not registryCheck(src, name) then
        return false
    end

    return players[src]:getXp(name)
end

exports('GetXp', GetXp)

-- Function with its relative export to get the level of a player
---@param source number
---@param name string
---@return number | boolean
local function GetLevel(source, name)
    local src = source

    if not registryCheck(src, name) then
        return false
    end

    return players[src]:getLevel(name)
end

exports('GetLevel', GetLevel)

-- Command for menu view of levels and xp
lib.addCommand('xp', {
    help = locale('command_help'),
}, function(source)
    local src = source

    if not registryCheck(src) then
        return
    end

    local data = players[src]:getAll()

    TriggerClientEvent('mnr_xp:client:OpenXpMenu', src, data)
end)