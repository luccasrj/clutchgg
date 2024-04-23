fx_version "bodacious"
game { "gta5" }

use_fxv2_oal "yes"
lua54 "yes"

client_scripts {
    "@vrp/lib/utils.lua",
    "src/___vRP__.lua",
    "src/__client__.lua",
    "src/client/*"
}

server_scripts {
    "@vrp/lib/utils.lua",
    "src/___vRP__.lua",
    "src/__server__.lua",
    "src/server/*"
}

ui_page "src/ui/index.html"

files {
    "src/ui/*",
    "src/ui/**/*"
}