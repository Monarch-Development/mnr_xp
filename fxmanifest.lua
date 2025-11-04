fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'mnr_xp'
description 'XP management system for frameworks'
author 'IlMelons'
version '1.0.0'
repository 'https://github.com/Monarch-Development/mnr_xp'

shared_scripts {
    '@ox_lib/init.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config/categories.lua',
    'server/**/*.lua',
}

client_scripts {
    'client/*.lua',
}