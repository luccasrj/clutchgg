

fx_version "bodacious"
game "gta5"

ui_page "gui/index.html"

dependencies {
	"oxmysql"
}

server_scripts {
	"@oxmysql/lib/MySQL.lua",
	"lib/vehicles.lua",
	"lib/utils.lua",
	"modules/*",
	"classes/*",
	"mysql_driver.lua"
}

client_scripts {
	"lib/vehicles.lua",
	"lib/utils.lua",
	"client/*"
}

files {
	"loading/*",
	"loading/**/*",
	"lib/*",
	"gui/*",
	"gui/**/*"
}

loadscreen "loading/index.html"