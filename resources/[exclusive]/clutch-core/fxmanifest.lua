fx_version "bodacious"
game { "gta5" }

author "luccasrj"

shared_script "common/Configs/Configuration.lua"

client_scripts {
    "@vrp/lib/utils.lua",
    "common/*",
    "common/**/*",
    "client/index.lua",
    "client/**/*"
}

server_scripts {
    "@vrp/lib/utils.lua",
    "common/*",
    "common/**/*",
    "server/index.lua",
    "server/**/*"
}        

ui_page "web/index.html"

files {
    "web/*",
    "web/**/*",
}                                                        