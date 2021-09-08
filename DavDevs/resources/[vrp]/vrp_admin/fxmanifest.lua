fx_version 'adamant'
game 'gta5'

author 'DavDevs'
contact 'discord.gg/'

client_scripts {
	'@vrp/lib/utils.lua',
	'shadow/*.lua'
}

server_scripts {
	'@vrp/lib/utils.lua',
	'@mysql-async/lib/MySQL.lua',
	'hunter.lua'
}

dependencies {
    'mysql-async'
}