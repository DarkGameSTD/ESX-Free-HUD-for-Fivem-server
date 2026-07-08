RegisterServerEvent("RV_HuD:EjectPlayers")
AddEventHandler("RV_HuD:EjectPlayers", function(table)
    for i=1, #table do
        if table[i] then
            if tonumber(table[i]) ~= 0 then
                TriggerClientEvent("RV_HuD:EjectPlayer", table[i])
            end
        end
    end
end)