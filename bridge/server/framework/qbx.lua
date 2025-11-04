---@diagnostic disable: duplicate-set-field, lowercase-global

if GetResourceState('qbx_core') ~= 'started' then return end

RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function()
    local src = source

    TriggerEvent('mnr_xp:server:InitPlayerXp', src)
end)

framework = {}

function framework.GetIdentifier(source)
    local player = exports.qbx_core:GetPlayer(source)

    return player.PlayerData.citizenid
end