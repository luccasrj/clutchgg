Database = {}

function Database.resetId(characterId)
    if characterId then
        exports.oxmysql:query("DELETE FROM `characters` WHERE `id` = @characterId",{ characterId = characterId })

        exports.oxmysql:query("DELETE FROM `characters_data` WHERE `user_id` = @characterId",{ characterId = characterId })

        exports.oxmysql:query("DELETE FROM `groups` WHERE `character_id` = @characterId",{ characterId = characterId })

    end
end

function Database.changeId(source,oldId,newId)
    if oldId and newId then
        local oldIdExists = exports.oxmysql:query_async("SELECT `id` FROM `characters` WHERE `id` = @oldId",{ oldId = newId })
        if #oldIdExists > 0 then
            if source == 0 then 
            end
            if source ~= 0 then 
                TriggerClientEvent("Notify",source,"negado","O ID antigo ainda existe.") 
            end
            return
        end

        local newIdExists = exports.oxmysql:query_async("SELECT `id` FROM `characters` WHERE `id` = @newId",{ newId = newId })
        if #newIdExists > 0 then
            if source == 0 then 
            end
            if source ~= 0 then 
                TriggerClientEvent("Notify",source,"negado","O ID novo já existe.") 
            end
        end
        
        exports.oxmysql:query("UPDATE `characters` SET `id` = @newId WHERE `id` = @oldId",{ newId = newId, oldId = oldId })

        exports.oxmysql:query("UPDATE `characters_data` SET `user_id` = @newId WHERE `user_id` = @oldId",{ newId = newId, oldId = oldId })

        exports.oxmysql:query("UPDATE `groups` SET `character_id` = @newId WHERE `character_id` = @oldId",{ newId = newId, oldId = oldId })
    end
end

RegisterCommand("resetid",function(source,args,rawCmd)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id == 0 or user_id == 1 then
        if not args[1] then return end
        local characterId = parseInt(args[1])
        local characterSource = vRP.userSource(characterId)
        if characterSource then
            TriggerClientEvent("Notify",source,"sucesso",""..characterId.." está conectado ao servidor.",10000)
            return
        end

        Database.resetId(characterId)
    end
end)

RegisterCommand("alterarid",function(source,args,rawCmd)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id == 0 or user_id == 1 or user_id == 2 then
        if not args[1] or not args[2] then return end

        local oldId = parseInt(args[1])
        local newId = parseInt(args[2])
        if vRP.userSource(oldId) then
            TriggerClientEvent("Notify",source,"sucesso",""..oldId.." está conectado ao servidor.",10000)

            return
        end

        if vRP.userSource(newId) then
            TriggerClientEvent("Notify",source,"sucesso",""..newId.." está conectado ao servidor.",10000)
            return
        end

        Database.changeId(0,oldId,newId)
    end
end)