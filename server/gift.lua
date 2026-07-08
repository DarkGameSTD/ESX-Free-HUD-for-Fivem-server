local HasGift = {}
local Reward = {}
local GiftTime = {}
AddEventHandler('playerDropped', function (reason)
	xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer ~= nil and HasGift[xPlayer.identifier] then
		GiftTime[xPlayer.identifier] = os.time()
	end
end)

RegisterServerEvent("RV_HuD:EndGiftTimer", function()
	xPlayer = ESX.GetPlayerFromId(source)
	if not Reward[xPlayer.identifier] and HasGift[xPlayer.identifier] then
		Reward[xPlayer.identifier] = true
		local random = math.random(1,#Config.Gift.rewards)
		rewardss = Config.Gift.rewards[random]
		if rewardss ~= nil and xPlayer ~= nil then
			if rewardss.type == "item" then
				if xPlayer.addInventoryItem(rewardss.name, rewardss.amount, nil, nil) then
					Config.Notification(Config.Notifications["GIFTED"].message, Config.Notifications["GIFTED"].type, true, xPlayer.source)
				else
					print("inventory is full for reward | "..xPlayer.identifier)
				end
			elseif rewardss.type == "money" then
				xPlayer.addMoney(rewardss.amount)
				Config.Notification(Config.Notifications["GIFTED"].message, Config.Notifications["GIFTED"].type, true, xPlayer.source)
			elseif rewardss.type == "weapon" then
				xPlayer.addWeapon(rewardss.name, 250)
				Config.Notification(Config.Notifications["GIFTED"].message, Config.Notifications["GIFTED"].type, true, xPlayer.source)
			else
				print("invalid type reward")
			end
		else
			print("invalid table reward")
		end
	end
end)

RegisterServerEvent("RV_HuD:StartGiftTimer", function()
	xPlayer = ESX.GetPlayerFromId(source)
	if not Reward[xPlayer.identifier] then
		if not HasGift[xPlayer.identifier] then
			HasGift[xPlayer.identifier] = true
			Reward[xPlayer.identifier] = false
			GiftTime[xPlayer.identifier] = os.time()
			TriggerClientEvent("RV_HuD:SetGiftTimer", xPlayer.source, GiftTime[xPlayer.identifier])
		else
			Reward[xPlayer.identifier] = true
			GiftTime[xPlayer.identifier] = 0
			--TriggerClientEvent("RV_HuD:SetGiftTimer", xPlayer.source, GiftTime[xPlayer.identifier])
		end
	end
end)