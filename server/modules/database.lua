local config = require 'config.server'

local database = {}

function database.RetrievePlayerData(identifier, name)
    local tableName = config[name] and config[name].database
    if not tableName then
        print(('^3[DATABASE] Category "%s" does not have a defined table^0'):format(name))
        return false
    end

    local query = ('SELECT `xp`, `level` FROM `%s` WHERE `identifier` = ?'):format(tableName)
    local result = MySQL.query.await(query, { identifier })

    if result and result[1] then
        local row = result[1]

        return { xp = row.xp, level = row.level }
    end

    return false
end

function database.SavePlayerData(identifier, name, data)
    local tableName = config[name] and config[name].database
    if not tableName then
        print(('^3[DATABASE] Category "%s" does not have a defined table^0'):format(identifier, name))

        return false
    end

    local query = ('INSERT INTO `%s` (`identifier`, `xp`, `level`) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE `xp` = ?, `level` = ?'):format(tableName)
    local success = MySQL.query.await(query, { identifier, data.xp, data.level, data.xp, data.level })

    if success then
        return true
    end

    return false
end

return database