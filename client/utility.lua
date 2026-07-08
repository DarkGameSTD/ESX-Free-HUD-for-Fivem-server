ESX, FrameWork = GetCore()

function WaitPlayer()
	while ESX == nil do
		Citizen.Wait(5)
		ESX, FrameWork = GetCore()
	end
	while ESX.GetPlayerData()  == nil do
		Citizen.Wait(5)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(5)
	end
end

function WaitNUI()
    while not Config.nuiLoaded do
        Wait(50)
		nuiMessage("CHECK_NUI")
    end
end

function TriggerCallback(name, data)
    local incomingData = false
    local status = 'UNKOWN'
    local counter = 0
    WaitCore()
	ESX.TriggerServerCallback(name, function(payload)
		status = 'SUCCESS'
		incomingData = payload
	end, data)
    CreateThread(function()
        while incomingData == 'UNKOWN' do
            Citizen.Wait(1000)
            if counter == 4 then
                status = 'FAILED'
                incomingData = false
                break
            end
            counter = counter + 1
        end
    end)

    while status == 'UNKOWN' do
        Citizen.Wait(0)
    end
    return incomingData
end

function nuiMessage(action, payload)
	if payload then
		-- print(action, json.encode(payload))
		SendNUIMessage({action = action, payload = payload})
	else
		SendNUIMessage({action = action})
	end
end