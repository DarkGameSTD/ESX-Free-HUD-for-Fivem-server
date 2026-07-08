ESX, FrameWork = GetCore()
Config.nuiLoaded = false
Config.localesLoaded = false
local settingOpen = false
local toggleHuD = true
local havePhone = false

RegisterNetEvent("Hz_Inventory:TogglePhone", function(state)
	havePhone = state
end)

RegisterNetEvent("RV_Hud:ShowHud", function() ShowHud() end)
function ShowHud()
	nuiMessage("SET_HUD_LOADED")
	toggleHuD = true
	nuiMessage("SHOW_HUD")
end

RegisterNetEvent("RV_Hud:HideHud", function() HideHud() end)
function HideHud()
	toggleHuD = false
	nuiMessage("HIDE_HUD")
end

RegisterCommand(Config.HudSettingsCommand, function()
	TriggerEvent(Config.HudSettingsEvent)
end, false)

RegisterCommand("reload", function()
	LoadPlayerInformations()
end)

RegisterCommand("togglehud", function()
	if toggleHuD then
		HideHud()
	else
		ShowHud()
	end
end, false)

RegisterNUICallback("waypoint", function(data, cb)
	if Config.QuickLocations[data.type] then
		local type = Config.QuickLocations[data.type]
		local coords = GetEntityCoords(PlayerPedId())
		local distances = {}
		local lowestIndex = 0
		local lowestValue = false
		
		for i=1, #type do
			location = type[i]
			if location ~= nil then
				distance = #(coords.xyz - location)
				table.insert(distances, {index = i, distance = distance})
			end
		end
		for k, v in ipairs(distances) do
			if not lowestValue or v.distance < lowestValue then
				lowestIndex = v.index
				lowestValue = v.distance
			end
		end
		WayPoint = Config.QuickLocations[data.type][lowestIndex]
		DeleteWaypoint()
		SetNewWaypoint(WayPoint.x, WayPoint.y)
	end
	
end)

RegisterNUICallback("closeSettings", function(data, cb)
	SetNuiFocus(false, false)
	settingOpen = false
end)

RegisterNUICallback("localsLoaded", function(data, cb)
	Config.localesLoaded = true
end)

RegisterNUICallback("loaded", function(data, cb)
	Config.nuiLoaded = true
end)

Citizen.CreateThread(function()
	print('^8Instalizing...^0')
	WaitCore()
	nuiMessage("CHECK_NUI")
	while not Config.nuiLoaded do
        Wait(1000)
		nuiMessage("CHECK_NUI")
    end
	nuiMessage("SET_LOCALES", Config.Locales)
	while not Config.localesLoaded do
        Wait(1000)
		nuiMessage("SET_LOCALES", Config.Locales)
    end
	WaitNUI()
	local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
	local img_url = string.format("https://nui-img/%s/%s", mugshotStr, mugshotStr)
	xPlayer = TriggerCallback("RV_HuD:GetIdentifier")
	nuiMessage("SET_COUNTRY_CODE", Config.CountryCode)
	nuiMessage("SET_IDENTIFIER", xPlayer.identifier)
	nuiMessage("SET_WATERMARK_INFORMATIONS", Config.WaterMarkInformations)
	nuiMessage("TOGGLE_SECOND_JOB", Config.SecondJob.enable)
	nuiMessage("ENABLE_UI_KEYS", Config.EnableUIKeys)
	nuiMessage("LOAD_KEYS", Config.UIKeys)
	nuiMessage("SET_SHOW_MAP_WALKING", Config.ShowMapWhileWalking)
	nuiMessage("SET_DEFAULT_SPEED_TYPE", Config.DefaultSpeedType)
	nuiMessage("SET_MOUSE_CURSOR_KEY_LABEL", Config.MouseCursorKeyLabel)
	nuiMessage("SET_MENU", Config.Menu)
	nuiMessage('SET_SAFEZONE_NOTIFY', Config.EnableSafezoneNotify)
	nuiMessage('SET_PLAYER_PP', img_url)
	nuiMessage("TOGGLE_VEHICLE_MODES", Config.EnableVehicleModes)
	nuiMessage("ADJUST_HUD_POSITION", {top=0, left=13.0}) --13 left
	
end)

GetWeaponName = function(hash)
	for k,v in ipairs(ESX.GetWeaponList()) do
		if GetHashKey(v.name) == hash then
			return v.name
		end
	end
	return "no_name"
end

local safeMode = false
local street = nil
local zone = nil
local compass = nil
local lastweapon = nil
local onlinePlayers = 0
local lastmin = 0

Citizen.CreateThread(function()
	WaitCore()
	WaitNUI()
	Wait(10000)
	while true do 
		Wait(1000)
		local ped = PlayerPedId()
		local weapon = GetSelectedPedWeapon(PlayerPedId())
		local playerPos = GetEntityCoords(ped, true)
		-- if weapon ~= `WEAPON_UNARMED` then
		_, now = GetAmmoInClip(ped,weapon)		
		max = GetMaxAmmoInClip(ped,weapon,1)	
		ammo = GetAmmoInPedWeapon(ped,weapon)
		name = string.lower(GetWeaponName(weapon))
		name = string.gsub(name, "weapon_","")
		if name ~= "no_name" then
			if name ~= lastweapon then
				nuiMessage("SET_WEAPON_IMAGE", name)
				lastweapon = name
			end
			nuiMessage("SET_WEAPON_AMMO", {ammo = tonumber(ammo), maxAmmo = " / "..now})
		else
			if name ~= lastweapon then
				nuiMessage("SET_WEAPON_IMAGE", false)
				lastweapon = name
			end
		end
		
		-- print(GetNumberOfPlayers(), onlinePlayers)
		if onlinePlayers ~= GetNumberOfPlayers() then
			nuiMessage("SET_PLAYERS_AMOUNT", GetNumberOfPlayers())
			onlinePlayers = GetNumberOfPlayers()
		end
		
		if not inVeh then
			if GetClockMinutes() ~= lastmin then
				nuiMessage("UPDATE_CLOCK", GetClockHours()..":".. GetClockMinutes())
				lastmin = GetClockMinutes()
			end 
			
			if CompassMode == 'playerlook' then
				heading = tostring(round(360.0 - GetEntityHeading(ped)))
			else
				local camRot = GetGameplayCamRot(0)
				heading = tostring(round(360.0 - ((camRot.z + 360.0) % 360.0)))
			end
			
			local streetA, streetB = GetStreetNameAtCoord(playerPos.x, playerPos.y, playerPos.z)

			if not ((streetA == lastStreetA or streetA == lastStreetB) and (streetB == lastStreetA or streetB == lastStreetB)) then
				lastStreetA = streetA
				lastStreetB = streetB
			end
			lastcompass = degreesToIntercardinalDirection(heading)
			if lastStreetA ~= street  or lastStreetB ~= zone or lastcompass ~= compass then
				nuiMessage("SET_LOCATION",{
					heading = lastcompass,
					zone = GetStreetNameFromHashKey(lastStreetA),
					street = GetStreetNameFromHashKey(lastStreetB)
				})
				street = lastStreetA
				zone = lastStreetB
				compass = lastcompass
			end
		end
		
		if IsPedInAnyVehicle(ped) and IsRadarHidden() then
            DisplayRadar(true)
		elseif not IsPedInAnyVehicle(ped) and not IsRadarHidden() then
            if Config.ShowMapWhileWalking and IsRadarHidden() and havePhone then
                Wait(200)
				DisplayRadar(true)
			elseif not Config.ShowMapWhileWalking and not IsRadarHidden() then
				DisplayRadar(false)
            end
        end
		
		for i=1, #Config.SafezoneNotifyCoords do
			safe = Config.SafezoneNotifyCoords[i]
			distance = #(safe.coords - playerPos)
			if distance <= safe.radius and not safeMode then
				safeMode = true
				nuiMessage("SHOW_SAFEZONE_NOTIFY")
			elseif distance > safe.radius and safeMode then
				nuiMessage("HIDE_SAFEZONE_NOTIFY")
				SetPlayerCanDoDriveBy(PlayerId(), true)
				DisablePlayerFiring(PlayerId(), false)
				NetworkSetFriendlyFireOption(true)
				safeMode = false
			end
		end
		-- CreateThread(function()
		-- 	while safeMode do
		-- 		Wait(5)
		-- 		SetPlayerCanDoDriveBy(PlayerId(), false)
		-- 		DisablePlayerFiring(PlayerId(), true)
		-- 		DisableControlAction(0, 140)
		-- 		DisableControlAction(0, 106)
		-- 		DisableControlAction(0, 24, true) -- LEFT MOUSE BUTTON
		-- 		DisableControlAction(0, 25, true) -- RIGHT MOUSE BUTTON
		-- 		DisableControlAction(0, 37, true) -- TAB
		-- 		DisableControlAction(0, 140, true)
		-- 		NetworkSetFriendlyFireOption(false)
		-- 	end
		-- end)
	end
end)


RegisterNUICallback("EndGiftTimer",function()
	if Config.Gift.enable then
		TriggerServerEvent("RV_HuD:EndGiftTimer")
	end
end)

RegisterNetEvent('RV_HuD:RefreshOnlinePlayers', function(players)
	WaitCore()
	WaitNUI()
	nuiMessage("SET_PLAYERS_AMOUNT", players)
	onlinePlayers = players
end)

RegisterNetEvent('RV_HuD:SetGiftTimer', function(time)
	if Config.Gift.enable then
		WaitNUI()
		nuiMessage("SET_PLAYER_GIFT_TIME", time)
	end
end)

RegisterNetEvent(Config.HudSettingsEvent, function()
	settingOpen = not settingOpen
	SetNuiFocus(settingOpen, settingOpen)
	if settingOpen then
		nuiMessage("OPEN_HUD_SETTINGS")
	else
		nuiMessage("CLOSE_HUD_SETTINGS")
	end
end)

local Mouse = false
if Config.EnableRegisterKeyMapping then
    CreateThread(function()
        while true do
            if not CheckIsDriver() and Mouse then
                Mouse = false
                SetCursorData(Mouse)
            end
            Wait(1700)
        end
    end)
    -- RegisterCommand("hud_mousecursor", function()
        -- if CheckIsDriver() then
            -- ToggleCursor()
        -- end
    -- end)
    -- RegisterKeyMapping('hud_mousecursor', 'Cursor Control', 'keyboard', Config.MouseCursorKey)
	
	-- RegisterCommand("hud_cmousecursor", function()
		-- Mouse = false
        -- SetCursorData(Mouse)
    -- end)
    -- RegisterKeyMapping('hud_cmousecursor', 'Close Cursor Control', 'keyboard', 'ESCAPE')
	AddEventHandler("onKeyDown", function(key)
		if key == string.lower("escape") then
			Mouse = false
			SetCursorData(Mouse)
		end
		if key == string.lower(Config.MouseCursorKey) then
			if CheckIsDriver() then
				ToggleCursor()
			end
		end
	end)
else
    CreateThread(function()
        while true do
            local ped = PlayerPedId()
            if CheckIsDriver() then
                if IsControlJustPressed(0, Config.Keys[Config.MouseCursorKey]) then
                    ToggleCursor()
                end
            else
                if Mouse then
                    Mouse = false
                    SetCursorData(Mouse)
                end
                Wait(1500)
            end
            Wait(5)
        end
    end)
end

function ToggleCursor()
	Mouse = not Mouse
	SetNuiFocus(Mouse, Mouse)
end

function SetCursorData(toggle)
	nuiMessage("SET_CURSORMOUSE")
	SetNuiFocus(toggle, toggle)
end

-- RegisterNUICallback("OnInputFocusRemove", function(data, cb)
	-- if not settingOpen then
		-- Mouse = false
		-- SetCursorData(Mouse)
	-- end
-- end)

-- RegisterNUICallback("OnInputFocus", function(data, cb)
	-- Mouse = true
	-- SetCursorData(Mouse)
-- end)

RegisterNUICallback("closeNUI", function(data, cb)
	Mouse = false
	SetCursorData(Mouse)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
		HideHudComponentThisFrame(1) -- WANTED_STARS
		if Config.GtaDefaultUIs.enable then
			if Config.GtaDefaultUIs.hide.vehicle_name then
				HideHudComponentThisFrame(6) -- VEHICLE_NAME
			else
				ShowHudComponentThisFrame(6) -- VEHICLE_NAME
			end
			
			if Config.GtaDefaultUIs.hide.area_name then
				HideHudComponentThisFrame(7) -- AREA_NAME
			else
				ShowHudComponentThisFrame(7) -- AREA_NAME
			end
			
			if Config.GtaDefaultUIs.hide.vehicle_class then
				HideHudComponentThisFrame(8) -- VEHICLE_CLASS
			else
				ShowHudComponentThisFrame(8) -- VEHICLE_CLASS
			end
			
			if Config.GtaDefaultUIs.hide.vehicle_name then
				HideHudComponentThisFrame(6) -- VEHICLE_NAME
			else
				ShowHudComponentThisFrame(6) -- VEHICLE_NAME
			end
			
			if Config.GtaDefaultUIs.hide.street_name then
				HideHudComponentThisFrame(9) -- STREET_NAME
			else
				ShowHudComponentThisFrame(9) -- STREET_NAME
			end
			
			if Config.GtaDefaultUIs.hide.cash then
				HideHudComponentThisFrame(3) -- CASH
			else
				ShowHudComponentThisFrame(3) -- CASH
			end
			
			if Config.GtaDefaultUIs.hide.mp_cash then
				HideHudComponentThisFrame(4) -- MP_CASH
			else
				ShowHudComponentThisFrame(4) -- MP_CASH
			end
			
			if Config.GtaDefaultUIs.hide.hud_components then
				HideHudComponentThisFrame(21) -- HUD_COMPONENTS
			else
				ShowHudComponentThisFrame(21) -- HUD_COMPONENTS
			end
			
			if Config.GtaDefaultUIs.hide.hud_weapons then
				HideHudComponentThisFrame(22) -- HUD_WEAPONS
			else
				ShowHudComponentThisFrame(22) -- HUD_WEAPONS
			end
			
			if Config.GtaDefaultUIs.hide.ammo then
				HideHudComponentThisFrame(2) -- WEAPON_ICON
			else
				ShowHudComponentThisFrame(2) -- WEAPON_ICON
			end
			
		else
			HideHudComponentThisFrame(3) -- CASH
			HideHudComponentThisFrame(4) -- MP_CASH
			HideHudComponentThisFrame(6) -- VEHICLE_NAME
			HideHudComponentThisFrame(7) -- AREA_NAME
			HideHudComponentThisFrame(8) -- VEHICLE_CLASS
			HideHudComponentThisFrame(9) -- STREET_NAME
			HideHudComponentThisFrame(21) -- HUD_COMPONENTS
			HideHudComponentThisFrame(22) -- HUD_WEAPONS
			HideHudComponentThisFrame(2) -- WEAPON_ICON
		end
	end
end)

function degreesToIntercardinalDirection( dgr )
    dgr = dgr % 360.0
    
    if (dgr >= 0.0 and dgr < 22.5) or dgr >= 337.5 then
        return "N "
    elseif dgr >= 22.5 and dgr < 67.5 then
        return "NE"
    elseif dgr >= 67.5 and dgr < 112.5 then
        return "E"
    elseif dgr >= 112.5 and dgr < 157.5 then
        return "SE"
    elseif dgr >= 157.5 and dgr < 202.5 then
        return "S"
    elseif dgr >= 202.5 and dgr < 247.5 then
        return "SW"
    elseif dgr >= 247.5 and dgr < 292.5 then
        return "W"
    elseif dgr >= 292.5 and dgr < 337.5 then
        return "NW"
    end
end

Citizen.CreateThread(function()
    local minimap = RequestScaleformMovie("minimap")
    while not HasScaleformMovieLoaded(minimap) do
      Wait(0)
    end
    
    while true do
        Citizen.Wait(5)
        Citizen.InvokeNative(0xF6E48914C7A8694E, minimap, "SETUP_HEALTH_ARMOUR")
        Citizen.InvokeNative(0xC3D0841A0CC546A6, 3)
        Citizen.InvokeNative(0xC6796A8FFA375E53)
        Citizen.InvokeNative(0xF6E48914C7A8694E, minimap, "HIDE_SATNAV")
        Citizen.InvokeNative(0xC6796A8FFA375E53)
		local startMinimapX, startMinimapY = -0.001, -0.042
		SetMinimapComponentPosition('minimap', 'L', 'B', -0.0045+startMinimapX, 0.002+startMinimapY, 0.150, 0.188888)
		SetMinimapComponentPosition('minimap_mask', 'L', 'B', 0.020+startMinimapX, 0.032+startMinimapY, 0.111, 0.159)
		SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.03+startMinimapX, 0.022+startMinimapY, 0.266, 0.237)
		SetMinimapClipType(0)
		SetBlipAlpha(GetNorthRadarBlip(), 0)
		BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
    end
	
	if (not HasScaleformMovieLoaded(minimap)) then
		RequestScaleformMovie("minimap");

		while (not HasScaleformMovieLoaded(minimap)) do
			Wait(100)

		end
	end
	
	
	SetRadarBigmapEnabled(true, false)
    Citizen.Wait(0)
    SetRadarBigmapEnabled(false, false)
end)


function GetMinimapAnchor()
    -- Safezone goes from 1.0 (no gap) to 0.9 (5% gap (1/20))
    -- 0.05 * ((safezone - 0.9) * 10)
    local safezoneg = GetSafeZoneSize()
    local safezone_x = 1.0 / 20.0
    local safezone_y = 1.0 / 20.0
    local aspect_ratio = GetAspectRatio(0)
    local res_x, res_y = GetActiveScreenResolution()
    local xscale = 1.0 / res_x
    local yscale = 1.0 / res_y
    local Minimap = {}
    Minimap.width = xscale * (res_x / (4 * aspect_ratio))
    Minimap.height = yscale * (res_y / 5.674)
    Minimap.left_x = xscale * (res_x * (safezone_x * ((math.abs(safezoneg - 1.0)) * 10)))
    Minimap.bottom_y = 1.0 - yscale * (res_y * (safezone_y * ((math.abs(safezoneg - 1.0)) * 10)))
    Minimap.right_x = Minimap.left_x + Minimap.width
    Minimap.top_y = Minimap.bottom_y - Minimap.height
    Minimap.x = Minimap.left_x
    Minimap.y = Minimap.top_y
    Minimap.xunit = xscale
    Minimap.yunit = yscale
    return Minimap
end


RegisterKeyMapping('hudsettings', 'Hud settings menu', 'keyboard', Config.SettingsMenu)