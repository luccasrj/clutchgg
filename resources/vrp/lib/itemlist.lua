-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local itemlist = {
    ["WEAPON_PISTOL_MK2"] = {
        ["index"] = "fiveseven",
        ["name"] = "WEAPON_PISTOL_MK2",
        ["ammo"] = "WEAPON_PISTOL_AMMO",
    },
	["WEAPON_KNIFE"] = {
        ["index"] = "knife",
        ["name"] = "WEAPON_KNIFE",
        ["ammo"] = false,
    },
	["WEAPON_BOTTLE"] = {
        ["index"] = "bottle",
        ["name"] = "WEAPON_BOTTLE",
        ["ammo"] = false,
    },
	["WEAPON_KNUCKLE"] = {
        ["index"] = "socoingles",
        ["name"] = "WEAPON_KNUCKLE",
        ["ammo"] = false,
    },
	["WEAPON_PISTOL"] = {
        ["index"] = "m19",
        ["name"] = "WEAPON_PISTOL",
        ["ammo"] = "WEAPON_PISTOL_AMMO",
    },
	["WEAPON_COMBATPISTOL"] = {
        ["index"] = "combatpistol",
        ["name"] = "WEAPON_COMBATPISTOL",
        ["ammo"] = "WEAPON_PISTOL_AMMO",
    },
	["WEAPON_MICROSMG"] = {
        ["index"] = "microsmg",
        ["name"] = "WEAPON_MICROSMG",
        ["ammo"] = "WEAPON_PISTOL_AMMO",
    },
	["WEAPON_SMG_MK2"] = {
        ["index"] = "smgmk2",
        ["name"] = "WEAPON_SMG_MK2",
        ["ammo"] = "WEAPON_PISTOL_AMMO",
	},
	["WEAPON_ASSAULTSMG"] = {
        ["index"] = "assaultsmg",
        ["name"] = "WEAPON_ASSAULTSMG",
        ["ammo"] = "WEAPON_PISTOL_AMMO",
    },
	["WEAPON_COMBATPDW"] = {
        ["index"] = "combatpdw",
        ["name"] = "WEAPON_COMBATPDW",
        ["ammo"] = "WEAPON_PISTOL_AMMO",
    },
	["WEAPON_SAWNOFFSHOTGUN"] = {
        ["index"] = "dozecurta",
        ["name"] = "WEAPON_SAWNOFFSHOTGUN",
        ["ammo"] = "WEAPON_SHOTGUN_AMMO",
    },
	["WEAPON_HEAVYSHOTGUN"] = {
        ["index"] = "heavy12",
        ["name"] = "WEAPON_HEAVYSHOTGUN",
        ["ammo"] = "WEAPON_SHOTGUN_AMMO",
    },
	["WEAPON_ADVANCEDRIFLE"] = {
        ["index"] = "mtar21",
        ["name"] = "WEAPON_ADVANCEDRIFLE",
        ["ammo"] = "WEAPON_RIFLE_AMMO",
    },
	["WEAPON_BULLPUPRIFLE"] = {
        ["index"] = "famas",
        ["name"] = "WEAPON_BULLPUPRIFLE",
        ["ammo"] = "WEAPON_RIFLE_AMMO",
    },
	["WEAPON_COMPACTRIFLE"] = {
        ["index"] = "compactrifle",
        ["name"] = "WEAPON_COMPACTRIFLE",
        ["ammo"] = "WEAPON_RIFLE_AMMO",
    },
	["WEAPON_CARBINERIFLE"] = {
        ["index"] = "m4",
        ["name"] = "WEAPON_CARBINERIFLE",
        ["ammo"] = "WEAPON_RIFLE_AMMO",
    },
	["WEAPON_ASSAULTRIFLE_MK2"] = {
        ["index"] = "ak47",
        ["name"] = "WEAPON_ASSAULTRIFLE_MK2",
        ["ammo"] = "WEAPON_RIFLE_AMMO",
    },
	["WEAPON_CARBINERIFLE_MK2"] = {
        ["index"] = "ar15",
        ["name"] = "WEAPON_CARBINERIFLE_MK2",
        ["ammo"] = "WEAPON_RIFLE_AMMO",
    },
	["WEAPON_SPECIALCARBINE_MK2"] = {
        ["index"] = "g36c",
        ["name"] = "WEAPON_SPECIALCARBINE_MK2",
        ["ammo"] = "WEAPON_RIFLE_AMMO",
    },
	["WEAPON_BULLPUPRIFLE_MK2"] = {
        ["index"] = "bullpup",
        ["name"] = "WEAPON_BULLPUPRIFLE_MK2",
        ["ammo"] = "WEAPON_RIFLE_AMMO",
    },
	["WEAPON_TACTICALRIFLE"] = {
        ["index"] = "tacticalrifle",
        ["name"] = "WEAPON_TACTICALRIFLE",
        ["ammo"] = "WEAPON_RIFLE_AMMO",
    },
	["WEAPON_PISTOL_AMMO"] = {
		["index"] = "pistolammo",
		["name"] = "WEAPON_PISTOL_AMMO",
	},
	["WEAPON_SMG_AMMO"] = {
		["index"] = "smgammo",
		["name"] = "WEAPON_SMG_AMMO",
	},
	["WEAPON_RIFLE_AMMO"] = {
		["index"] = "rifleammo",
		["name"] = "WEAPON_RIFLE_AMMO",
	},
    ["WEAPON_SHOTGUN_AMMO"] = {
		["index"] = "shotgunammo",
		["name"] = "WEAPON_SHOTGUN_AMMO",
	},
	["WEAPON_COLETE"] = {
		["index"] = "colete",
		["name"] = "WEAPON_COLETE",
	},
	["WEAPON_BANDAGEM"] = {
		["index"] = "bandagem",
		["name"] = "WEAPON_BANDAGEM",
	},
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMBODY
-----------------------------------------------------------------------------------------------------------------------------------------
function itemBody(nameItem)
	local splitName = splitString(nameItem,"-")

	if itemlist[splitName[1]] then
		return itemlist[splitName[1]]
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMINDEX
-----------------------------------------------------------------------------------------------------------------------------------------
function itemIndex(nameItem)
	local splitName = splitString(nameItem,"-")

	if itemlist[splitName[1]] then
		return itemlist[splitName[1]]["index"]
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMNAME
-----------------------------------------------------------------------------------------------------------------------------------------
function itemName(nameItem)
	local splitName = splitString(nameItem,"-")

	if itemlist[splitName[1]] then
		return itemlist[splitName[1]]["name"]
	end

	return "Deletado"
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMTYPE
-----------------------------------------------------------------------------------------------------------------------------------------
function itemType(nameItem)
	local splitName = splitString(nameItem,"-")

	if itemlist[splitName[1]] then
		return itemlist[splitName[1]]["type"]
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMAMMO
-----------------------------------------------------------------------------------------------------------------------------------------
function itemAmmo(nameItem)
	local splitName = splitString(nameItem,"-")

	if itemlist[splitName[1]] then
		return itemlist[splitName[1]]["ammo"]
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function itemVehicle(nameItem)
	local splitName = splitString(nameItem,"-")

	if itemlist[splitName[1]] then
		return itemlist[splitName[1]]["vehicle"] or false
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
function itemWeight(nameItem)
	local splitName = splitString(nameItem,"-")

	if itemlist[splitName[1]] then
		return itemlist[splitName[1]]["weight"] or 0.0
	end

	return 0.0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMMAXAMOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function itemMaxAmount(nameItem)
	local splitName = splitString(nameItem,"-")

	if itemlist[splitName[1]] then
		return itemlist[splitName[1]]["max"] or nil
	end

	return nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAXSTORAGE
-----------------------------------------------------------------------------------------------------------------------------------------
function ItemMaxStorage(nameItem)
	local splitName = splitString(nameItem,"-")

	if itemlist[splitName[1]] then
		return itemlist[splitName[1]]["storage"] or nil
	end

	return nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMDESCRIPTION
-----------------------------------------------------------------------------------------------------------------------------------------
function itemDescription(nameItem)
	local splitName = splitString(nameItem,"-")

	if itemlist[splitName[1]] then
		return itemlist[splitName[1]]["desc"] or nil
	end

	return nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMECONOMY
-----------------------------------------------------------------------------------------------------------------------------------------
function itemEconomy(nameItem)
	local splitName = splitString(nameItem,"-")

	if itemlist[splitName[1]] then
		return itemlist[splitName[1]]["economy"] or "S/V"
	end

	return "S/V"
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMDURABILITY
-----------------------------------------------------------------------------------------------------------------------------------------
function itemDurability(nameItem)
	local splitName = splitString(nameItem,"-")

	if itemlist[splitName[1]] then
		return itemlist[splitName[1]]["durability"] or false
	end

	return false
end