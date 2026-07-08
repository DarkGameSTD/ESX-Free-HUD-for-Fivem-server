ESX, FrameWork = GetCore()
local onlinePlayers = 0
AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	TriggerClientEvent("RV_HuD:RefreshOnlinePlayers", -1, GetNumberOfPlayer())
end)

ESX.RegisterServerCallback("RV_HuD:GetCash", function(source, cb)
	local identifier = ESX.GetPlayerFromId(source)
	cb(identifier.money)
end)

ESX.RegisterServerCallback("RV_HuD:GetBank", function(source, cb)
	local identifier = ESX.GetPlayerFromId(source)
	cb(identifier.bank)
end)

ESX.RegisterServerCallback("RV_HuD:GetIdentifier", function(source, cb)
	local identifier = ESX.GetPlayerFromId(source)
	cb(ESX.GetPlayerFromId(source))
end)

function GetPlayerRoleplayName(source)
	WaitCore()
	return string.gsub(ESX.GetPlayerFromId(source).name, "_"," ")
end

function GetIdentifier(source)
	WaitCore()
	if ESX.GetPlayerFromId(source) ~= nil then
		return ESX.GetPlayerFromId(source).identifier
	end
	return nil
end

function GetNumberOfPlayer()
	local players = ESX.GetPlayers()
	onlinePlayers = #players
	return #players
end

-- AddEventHandler('onResourceStart', function(resourceName)
--   if (GetCurrentResourceName() ~= resourceName) then return;end
--   TriggerClientEvent("RV_HuD:RefreshOnlinePlayers", -1, GetNumberOfPlayer())
--   print('Resource Ba Name ' .. resourceName .. ' Ba License Hazard Development Ba Link : discord.gg/ryY7gHGn3D Start Shod.')
-- end)