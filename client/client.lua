local config = require 'config.client'

-- Event triggered to see xp and levels in a menu
---@param data table
RegisterNetEvent('mnr_xp:client:OpenXpMenu', function(data)
    if GetInvokingResource() then
        return
    end

    if not data then
        return
    end

    local menu = {}
    for name, category in pairs(data) do
        local visual = config[name]
        menu[#menu + 1] = {
            title = visual.label or locale('option_unknown'),
            readOnly = true,
            icon = visual.icon or 'fa-solid fa-star',
            progress = category.xp / category.max * 100,
            colorScheme = visual.color or 'violet',
            description = locale('option_description', category.level, category.xp),
        }
    end

    lib.registerContext({ id = 'mnr:menu:xp', title = locale('menu_title'), options = menu })

    lib.showContext('mnr:menu:xp')
end)