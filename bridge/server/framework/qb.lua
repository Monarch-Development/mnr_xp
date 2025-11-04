---@diagnostic disable: duplicate-set-field, lowercase-global

if GetResourceState('qb-core') ~= 'started' then return end

local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function()
    local src = source

    TriggerEvent('mnr_xp:server:InitPlayerXp', src)
end)

framework = {}

function framework.GetIdentifier(source)
    local Player = QBCore.Functions.GetPlayer(source)

    return Player.PlayerData.citizenid
end