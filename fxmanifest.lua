fx_version 'cerulean'
games { 'gta5' }
author '^AF^#8585'
server_only 'yes'

server_scripts {
     '@mysql-async/lib/MySQL.lua',
     'server.lua',
     'bot.js'
} 
client_script{
     'client.lua'
}