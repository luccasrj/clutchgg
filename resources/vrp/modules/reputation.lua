local reputationList = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETREPUTATION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getReputation(user_id)
    local user_id = parseInt(user_id)
    return reputationList[user_id] and reputationList[user_id] or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INSERTREPUTATION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.insertReputation(user_id,reputation,amount)
	local user_id = parseInt(user_id)

	if reputationList[user_id][reputation] == nil then
		reputationList[user_id][reputation] = 0
	end

	if reputationList[user_id][reputation] < 1000 then 
		reputationList[user_id][reputation] = reputationList[user_id][reputation] + amount
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKREPUTATION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.checkReputation(user_id,reputation)
	local user_id = parseInt(user_id)

	if reputationList[user_id][reputation] == nil then
		reputationList[user_id][reputation] = 0
	end

	return parseInt(reputationList[user_id][reputation])
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEREPUTATION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.removeReputation(user_id,reputation,amount)
    local user_id = parseInt(user_id)

    if reputationList[user_id][reputation] then
        if amount > reputationList[user_id][reputation] then
            reputationList[user_id][reputation] = 0
            return
        end

        reputationList[user_id][reputation] = reputationList[user_id][reputation] - amount
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESETREPUTATION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.resetReputation(user_id,reputation)
    local user_id = parseInt(user_id)

    if reputationList[user_id] and reputationList[user_id][reputation] then
        reputationList[user_id][reputation] = nil
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET SQUAD REP
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.squadReputation(squad)
	if reputationList[squad] then 
		return reputationList[squad]
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SET REPUTATION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.setSquadReputation(squad,amount)
	if reputationList[squad] and reputationList[squad] < 1000 then 
		reputationList[squad] = reputationList[squad] + amount 
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SET REPUTATION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.reduceSquadReputation(squad,amount)
	if reputationList[squad] then 
		reputationList[squad] = reputationList[squad] - amount 
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SET REPUTATION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.resetSquadReputation(squad)
	if reputationList[squad] then 
		reputationList[squad] = 0
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:KICKALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("admin:KickAll")
AddEventHandler("admin:KickAll",function()
	Citizen.CreateThread(function()
		while true do
			print("[^1Session^7] Finalizado o kick de todos os usuarios, desligamento pronto.")
			Citizen.Wait(1000)
		end
	end)
end)
