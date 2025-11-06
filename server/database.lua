local config = require 'config.server'

-- Verifies if a table exists in the database
---@param name string Name of database table
---@return boolean exists Whether it exists or not
local function tableExists(name)
    local result = MySQL.scalar.await([[SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ?]], { name })

    return result > 0
end

-- Creates the table if not exists
---@param name string Name of database table
local function ensureDatabaseCategory(name)
    local exists = tableExists(name)

    if exists then
        print(('^2[Monarch XP] Verified table "%s".^0'):format(name))
        return
    end

    local query = ([[
        CREATE TABLE `%s` (
            `identifier` VARCHAR(64) NOT NULL PRIMARY KEY,
            `xp` INT NOT NULL DEFAULT 0,
            `level` INT NOT NULL DEFAULT 1
        )
    ]]):format(name)

    local success = MySQL.query.await(query)
    if success then
        print(('^2[Monarch XP] Created new table "%s".^0'):format(name))
    else
        print(('^1[Monarch XP] Error creating table "%s".^0'):format(name))
    end
end

for _, data in pairs(config) do
    ensureDatabaseCategory(data.database)
end