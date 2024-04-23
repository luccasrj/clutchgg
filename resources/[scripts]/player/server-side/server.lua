-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("player",cRP)
vCLIENT = Tunnel.getInterface("player")
vSKINSHOP = Tunnel.getInterface("skinshop")
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCKS
-----------------------------------------------------------------------------------------------------------------------------------------
local locks = {}

function Lock(key, ms)
	while locks[key] and locks[key] > GetGameTimer() do Wait(100) end
	locks[key] = GetGameTimer() + ms
	return function()
	locks[key] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.permissionVIP()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if exports["common"]:Group().hasPermission(user_id,"staff") then
			return true
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CARRYFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:carryFunctions")
AddEventHandler("player:carryFunctions",function(mode)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRPC.inVehicle(source) then
			local otherPlayer = vRPC.nearestPlayer(source,1.1)
			if otherPlayer then
				if exports["common"]:Group().hasPermission(user_id,"staff") then
					if mode == "bracos" then
						vCLIENT.toggleCarry(otherPlayer,source)
					elseif mode == "ombros" then
						TriggerClientEvent("rope:toggleRope",source,otherPlayer)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:PLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:drag")
AddEventHandler("player:drag",function(mode)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local otherPlayer = vRPC.nearestPlayer(source,1.1)
		if otherPlayer then
			if exports["common"]:Group().hasPermission(user_id,"paramedic") or exports["common"]:Group().hasPermission(user_id,"police") then
				vCLIENT.toggleCarry(otherPlayer,source)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:WINSFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:winsFunctions")
AddEventHandler("player:winsFunctions",function(mode)
	local source = source
	local vehicle,vehNet = vRPC.vehSitting(source)
	if vehicle then
		TriggerClientEvent("player:syncWins",-1,vehNet,mode)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:IDENTITYFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
local cooldown = {}
RegisterServerEvent("player:identityFunctions")
AddEventHandler("player:identityFunctions",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not cooldown[user_id] or os.time() - cooldown[user_id] > 10 then 
			cooldown[user_id] = os.time()
			local identity = vRP.userIdentity(user_id)
			if identity then
				local name = "Nenhum"
				local squad_user = exports["common"]:Group().getSquad(user_id)
				if squad_user and squad_user.squadName then 
					name = squad_user.squadName
				end
				TriggerClientEvent("Notify",source,"identidade","<b>Nome:</b> "..identity["surname"].."</b> <br> <b>ID: </b>"..parseFormat(user_id).."<br>",5000,"left")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESET
-----------------------------------------------------------------------------------------------------------------------------------------
local config_peds = {
	[-1667301416] = "mp_f_freemode_01",
	[1885233650] = "mp_m_freemode_01",
}
local intro = {
	["mp_m_freemode_01"] = {
		["hat"] = { item = -1, texture = 0 },
		["pants"] = { item = 67, texture = 3 },
		["vest"] = { item = 0, texture = 0 },
		["backpack"] = { item = 0, texture = 0 },
		["bracelet"] = { item = -1, texture = 0 },
		["decals"] = { item = 0, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["shoes"] = { item = 59, texture = 19 },
		["tshirt"] = { item = 15, texture = 0 },
		["torso"] = { item = 394, texture = 1 },
		["accessory"] = { item = 0, texture = 0 },
		["watch"] = { item = -1, texture = 0 },
		["arms"] = { item = 0, texture = 0 },
		["glass"] = { item = 0, texture = 0 },
		["ear"] = { item = -1, texture = 0 }
	},
	["mp_f_freemode_01"] = {
		["hat"] = { item = -1, texture = 0 },
		["pants"] = { item = 3, texture = 0 },
		["vest"] = { item = 0, texture = 0 },
		["backpack"] = { item = 0, texture = 0 },
		["bracelet"] = { item = -1, texture = 0 },
		["decals"] = { item = 0, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["shoes"] = { item = 74, texture = 20 },
		["tshirt"] = { item = 14, texture = 0 },
		["torso"] = { item = 406, texture = 3 },
		["accessory"] = { item = 0, texture = 0 },
		["watch"] = { item = -1, texture = 0 },
		["arms"] = { item = 4, texture = 0 },
		["glass"] = { item = 0, texture = 0 },
		["ear"] = { item = -1, texture = 0 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:PRESETINTRO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:presetIntro")
AddEventHandler("player:presetIntro",function(source)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local model_ped = GetEntityModel(GetPlayerPed(source))
		if config_peds[model_ped] then
			TriggerClientEvent("updateRoupas",source,intro[config_peds[model_ped]])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OUTFIT - REMOVER
-----------------------------------------------------------------------------------------------------------------------------------------
local removeFit = {
	["homem"] = {
		["hat"] = { item = -1, texture = 0 },
		["pants"] = { item = 14, texture = 0 },
		["vest"] = { item = 0, texture = 0 },
		["backpack"] = { item = 0, texture = 0 },
		["bracelet"] = { item = -1, texture = 0 },
		["decals"] = { item = 0, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["shoes"] = { item = 5, texture = 0 },
		["tshirt"] = { item = 15, texture = 0 },
		["torso"] = { item = 15, texture = 0 },
		["accessory"] = { item = 0, texture = 0 },
		["watch"] = { item = -1, texture = 0 },
		["arms"] = { item = 15, texture = 0 },
		["glass"] = { item = 0, texture = 0 },
		["ear"] = { item = -1, texture = 0 }
	},
	["mulher"] = {
		["hat"] = { item = -1, texture = 0 },
		["pants"] = { item = 14, texture = 0 },
		["vest"] = { item = 0, texture = 0 },
		["backpack"] = { item = 0, texture = 0 },
		["bracelet"] = { item = -1, texture = 0 },
		["decals"] = { item = 0, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["shoes"] = { item = 5, texture = 0 },
		["tshirt"] = { item = 15, texture = 0 },
		["torso"] = { item = 15, texture = 0 },
		["accessory"] = { item = 0, texture = 0 },
		["watch"] = { item = -1, texture = 0 },
		["arms"] = { item = 15, texture = 0 },
		["glass"] = { item = 0, texture = 0 },
		["ear"] = { item = -1, texture = 0 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:PRESETFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:outfitFunctions")
AddEventHandler("player:outfitFunctions",function(mode)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if mode == "aplicar" then
			local result = vRP.getSrvdata("saveClothes:"..user_id)
			if result["pants"] ~= nil then
				TriggerClientEvent("updateRoupas",source,result)
				TriggerClientEvent("Notify",source,"importante","Roupas aplicadas.",3000)
			else
				TriggerClientEvent("Notify",source,"importante","Roupas não encontradas.",3000)
			end
		elseif mode == "preaplicar" then
			local result = vRP.getSrvdata("premClothes:"..user_id)
			if result["pants"] ~= nil then
				TriggerClientEvent("updateRoupas",source,result)
				TriggerClientEvent("Notify",source,"importante","Roupas aplicadas.",3000)
			else
				TriggerClientEvent("Notify",source,"importante","Roupas não encontradas.",3000)
			end
		elseif mode == "salvar" then
			local custom = vSKINSHOP.getCustomization(source)
			if custom then
				vRP.setSrvdata("saveClothes:"..user_id,custom)
				TriggerClientEvent("Notify",source,"importante","Roupas salvas.",3000)
			end
		elseif mode == "presalvar" then
			local custom = vSKINSHOP.getCustomization(source)
			if custom then
				vRP.setSrvdata("premClothes:"..user_id,custom)
				TriggerClientEvent("Notify",source,"importante","Roupas salvas.",3000)
			end
		elseif mode == "remover" then
			local model = vRP.modelPlayer(source)
			if model == "mp_m_freemode_01" then
				TriggerClientEvent("updateRoupas",source,removeFit["homem"])
			elseif model == "mp_f_freemode_01" then
				TriggerClientEvent("updateRoupas",source,removeFit["mulher"])
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MÁSCARA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("mascara",function(source,args,rawCommand)
	local userId = vRP.getUserId(source)
	if exports["common"]:Group().hasPermission(userId,"staff") then
		TriggerClientEvent("changeClothes",source,args[1],args[2],"mask")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLUSA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("blusa",function(source,args,rawCommand)
	local userId = vRP.getUserId(source)
	if exports["common"]:Group().hasPermission(userId,"staff") then
		TriggerClientEvent("changeClothes",source,args[1],args[2],"tshirt")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- JAQUETA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("jaqueta",function(source,args,rawCommand)
	local userId = vRP.getUserId(source)
	if exports["common"]:Group().hasPermission(userId,"staff") then
		TriggerClientEvent("changeClothes",source,args[1],args[2],"torso")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COLETE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("colete",function(source,args,rawCommand)
	local userId = vRP.getUserId(source)
	if exports["common"]:Group().hasPermission(userId,"staff") then
		TriggerClientEvent("changeClothes",source,args[1],args[2],"vest")
	end
end)
-------------------------------------------------------------------------------------------------------------------------------------------
-- CALÇA
-------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("calca",function(source,args,rawCommand)
	local userId = vRP.getUserId(source)
	if exports["common"]:Group().hasPermission(userId,"staff") then
		TriggerClientEvent("changeClothes",source,args[1],args[2],"pants")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MÃOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("maos",function(source,args,rawCommand)
	local userId = vRP.getUserId(source)
	if exports["common"]:Group().hasPermission(userId,"staff") then
		TriggerClientEvent("changeClothes",source,args[1],args[2],"arms")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACESSÓRIOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("acessorios",function(source,args,rawCommand)
	local userId = vRP.getUserId(source)
	if exports["common"]:Group().hasPermission(userId,"staff") then
		TriggerClientEvent("changeClothes",source,args[1],args[2],"accessory")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOCHILA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("mochila",function(source,args,rawCommand)
	local userId = vRP.getUserId(source)
	if exports["common"]:Group().hasPermission(userId,"staff") then
		TriggerClientEvent("changeClothes",source,args[1],args[2],"backpack")
	end
end)
-------------------------------------------------------------------------------------------------------------------------------------------
-- SAPATOS
-------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("sapatos",function(source,args,rawCommand)
	local userId = vRP.getUserId(source)
	if exports["common"]:Group().hasPermission(userId,"staff") then
		TriggerClientEvent("changeClothes",source,args[1],args[2],"shoes")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHAPÉU
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("chapeu",function(source,args,rawCommand)
	local userId = vRP.getUserId(source)
	if exports["common"]:Group().hasPermission(userId,"staff") then
		TriggerClientEvent("changeClothes",source,args[1],args[2],"hat")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ÓCULOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("oculos",function(source,args,rawCommand)
	local userId = vRP.getUserId(source)
	if exports["common"]:Group().hasPermission(userId,"staff") then
		TriggerClientEvent("changeClothes",source,args[1],args[2],"glass")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDEATHS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:deathLogs")
AddEventHandler("player:deathLogs",function(nSource)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and source ~= nSource then
		local nuser_id = vRP.getUserId(nSource)
		if nuser_id then
			exports["common"]:Log().embedDiscord(user_id,nil,nil,"commands-death","**Matou:** ```"..nuser_id.."```\nMatou às "..os.date("%d/%m/%y %H:%M:%S"),8686827)
		end
	end
	
	if user_id then
		local nuser_id = vRP.getUserId(nSource)
		if nuser_id then
			TriggerEvent("clutch-game:RegisterDeath",source,nSource)
		end
	end
end)