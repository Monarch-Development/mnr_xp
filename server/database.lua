local categories = require 'config.categories'

-- Verifies if a table exists in the database
---@param tableName string
---@return boolean exists
local function tableExists(tableName)
    local result = MySQL.scalar.await([[SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ?]], { tableName })

    return result > 0
end

-- Creates the table if not exists
---@param tableName string
local function ensureDatabaseCategory(tableName)
    local exists = tableExists(tableName)

    if exists then
        print(('^2[Monarch XP] Verified table "%s".^0'):format(tableName))
        return
    end

    local query = ([[
        CREATE TABLE `%s` (
            `identifier` VARCHAR(64) NOT NULL PRIMARY KEY,
            `xp` INT NOT NULL DEFAULT 0,
            `level` INT NOT NULL DEFAULT 1
        )
    ]]):format(tableName)

    local success = MySQL.query.await(query)
    if success then
        print(('^2[Monarch XP] Created new table "%s".^0'):format(tableName))
    else
        print(('^1[Monarch XP] Error creating table "%s".^0'):format(tableName))
    end
end

for _, data in pairs(categories) do
    ensureDatabaseCategory(data.database)
end