-----------------------------------------------------------------------------------------------------------------------------------------
-- LIMPARCHAT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("limparchat",function(source,args,rawCmd)
    local user_id = vRP.getUserId(source)
    if not exports["common"]:Group().hasPermission(user_id,"staff") then
        return
    end

    TriggerClientEvent("chat:clear",-1)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("copiarpreset",function(source,args,rawCommand)
    local source = source
    local userId = vRP.getUserId(source)
    if not args[1] or parseInt(args[1]) <= 0 then
        return TriggerClientEvent("Notify",source,"negado","Insira um passaporte válido.",10000)
    end

    local otherPlayer = vRP.userSource(parseInt(args[1]))
    if not otherPlayer then 
        return TriggerClientEvent("Notify",source,"negado","Usuário desconectado.",10000)
    end

    local myClothes = vSKINSHOP.getCustomization(otherPlayer)
    if myClothes then
        TriggerClientEvent("updateRoupas",source,myClothes)
        return TriggerClientEvent("Notify",source,"sucesso","Roupa copiada com sucesso.",10000)
    end 
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("setarpreset",function(source,args,rawCommand)
    local source = source
    local userId = vRP.getUserId(source)
    if not exports["common"]:Group().hasPermission(userId,"staff") then
        return
    end

    if not args[1] or parseInt(args[1]) <= 0 then
        return TriggerClientEvent("Notify",source,"negado","Insira um passaporte válido.",10000)
    end

    local otherPlayer = vRP.userSource(parseInt(args[1]))
    if not otherPlayer then 
        return TriggerClientEvent("Notify",source,"negado","Usuário desconectado.",10000)
    end

    local myClothes = vSKINSHOP.getCustomization(source)
    if myClothes then
        TriggerClientEvent("updateRoupas",otherPlayer,myClothes)
        return TriggerClientEvent("Notify",source,"sucesso","Roupa adicionada com sucesso.",10000)
    end 
end)