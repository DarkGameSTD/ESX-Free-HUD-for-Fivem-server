local firstLoad = false

function LoadHUD()
	WaitNUI()
    WaitCore()
    WaitPlayer()
	Wait(10)
    nuiMessage("SET_GIFT_INFORMATIONS", {
        text = Config.Gift.text,
        time = Config.Gift.time,
        enable = Config.Gift.enable,
    })
    TriggerServerEvent('RV_HuD:RequestPlaylists')
    TriggerServerEvent("RV_HuD:CheckPlayerStress")
    LoadPlayerInformations()
    nuiMessage("SET_HUD_LOADED")
	TriggerServerEvent("RV_HuD:StartGiftTimer")
    ShowHud()
	LoadPlayerInformations()
	if Config.nuiLoaded then print('^2HuD inistalized!^0') end
end


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
	WaitNUI()
	WaitCore()
	WaitPlayer()
    LoadHUD()
end)

CreateThread(function()
	WaitNUI()
	WaitCore()
	WaitPlayer()
    if not firstLoad then
        LoadHUD()
    end
end)

AddEventHandler("playerSpawned", function()
	WaitNUI()
	WaitCore()
	WaitPlayer()
    if not firstLoad then
        firstLoad = true
        if Config.ShowMapWhileWalking then
            DisplayRadar(true)
        else
            DisplayRadar(false)
        end
    end
end)

local isMapHidden = IsRadarHidden()
CreateThread(function()
    while true do
        Wait(1000)
        if IsRadarHidden() then
            if not isMapHidden then
                isMapHidden = true
                setShowMapWalking(false)
            end
        else
            if isMapHidden then
                isMapHidden = false
                setShowMapWalking(true)
            end
        end
    end
end)

function setShowMapWalking(state)
	if Config.ShowMapWhileWalking and state then
		DisplayRadar(true)
	elseif not state then
		DisplayRadar(state)	
	else
		DisplayRadar(false)
	end
end

