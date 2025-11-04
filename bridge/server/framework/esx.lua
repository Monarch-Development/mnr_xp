---@diagnostic disable: duplicate-set-field, lowercase-global

if GetResourceState('es_extended') ~= 'started' then return end

local ESX = exports['es_extended']:getSharedObject()

AddEventHandler('esx:playerLoaded', function(playerId)
    local src = playerId

    TriggerEvent('mnr_xp:server:InitPlayerXp', src)
end)

framework = {}

function framework.GetIdentifier(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    return xPlayer.identifier
end