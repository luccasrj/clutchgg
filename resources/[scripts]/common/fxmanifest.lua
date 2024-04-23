fx_version "bodacious"
game { "gta5" }

use_fxv2_oal "yes"
lua54 "yes"

client_scripts {
    "@vrp/lib/vehicles.lua",
    "@vrp/lib/utils.lua",
    "src/shared/*",
    "src/vRP.lua",
    "src/client/**/*"
}

server_scripts {
    "@vrp/lib/vehicles.lua",
    "@vrp/lib/utils.lua",
    "src/shared/*",
    "src/sha256.lua",
    "src/vRP.lua",
    "src/server/**/*"
}

data_file "WEAPONCOMPONENTSINFO_FILE" "src/shared/weapons/weaponcomponents.meta"
data_file "PED_PERSONALITY_FILE" "src/shared/weapons/pedpersonality.meta"
data_file "WEAPON_ANIMATIONS_FILE" "src/shared/weapons/weaponanimations.meta"
data_file "WEAPON_METADATA_FILE" "src/shared/weapons/weaponarchetypes.meta"
data_file "WEAPONINFO_FILE" "src/shared/weapons/weapons_parafal.meta"
data_file "WEAPONINFO_FILE_PATCH" "src/shared/weapons/weapons_parafal.meta"