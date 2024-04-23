RegisterCommand("pon",function(source,args,rawCmd)
    local user_id = vRP.getUserId(source)
    if not exports["common"]:Group().hasPermission(user_id,"staff") then
        return
    end

    local users = vRP.userList()
    local playerList = ""
    for k,v in pairs(users) do
        playerList = playerList..k..", "
    end
    TriggerClientEvent("Notify",source,"default","<b>Jogadores:</b> "..GetNumPlayerIndices().."<br>"..playerList,60000,"left","logo")
end)