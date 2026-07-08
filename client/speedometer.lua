local EngineStatus = false
local vehicle = nil
local isDriver = false
local inVeh = false
local party = false
local SpeedType = Config.DefaultSpeedType
local speed = 0
local lastStreetA = nil
local lastStreetB = nil
local RefreshRate = Config.SpeedometerRefreshRateTimes["medium"]
local wins = {}
local neons = {
	left = false,
	right = false,
	front = false,
	back = false,
}
local doors = {
	D_L = false,
	D_R = false,
	P_L = false,
	P_R = false,
	BONNET = false,
	BOOT = false,
}

RegisterNUICallback("toggleNeon", function(data, cb)
	local type = data.type
	Prop = ESX.Game.GetVehicleProperties(vehicle)
	if type == 'all' then
		for i=0, 3, 1 do
			if IsVehicleNeonLightEnabled(vehicle, i) then
				SetVehicleNeonLightEnabled(vehicle, i, false)
				neons[GetNeonFromIndex(i)] = false
			else
				SetVehicleNeonLightEnabled(vehicle, i, true)
				neons[GetNeonFromIndex(i)] = true
			end
		end
	elseif type == 'party' then
		i = -1
		party = not party
		while party do
			Wait(1)
			i = i+1
			SetVehicleNeonLightEnabled(vehicle, i, true)
			Wait(60)
			SetVehicleNeonLightEnabled(vehicle, i+1, true)
			Wait(90)
			SetVehicleNeonLightEnabled(vehicle, i, false)
			if i >= 4 then	i = -1 end
		end
		if not party then
			for i=0, 3, 1 do
				SetVehicleNeonLightEnabled(vehicle, i, false)
				neons[GetNeonFromIndex(i)] = false
			end
		end
	elseif type == 'neon' then
		if IsVehicleNeonLightEnabled(vehicle, data.value) then
			SetVehicleNeonLightEnabled(vehicle, data.value, false)
			neons[GetNeonFromIndex(data.value)] = false
		else
			SetVehicleNeonLightEnabled(vehicle, data.value, true)
			neons[GetNeonFromIndex(data.value)] = true
		end
	end
	Wait(100)
	for k,v in pairs(neons) do	nuiMessage("NEON_ENABLED", {type = k, value = v}) end
	nuiMessage("NEON_LIGHTS", {r = Prop.r, g = Prop.g, b = Prop.g})
	
end)

RegisterNUICallback("vehicleDoors", function(data, cb)
	if GetVehicleDoorLockStatus(vehicle) == 0 or GetVehicleDoorLockStatus(vehicle) == 1 then
		if GetVehicleDoorAngleRatio(vehicle, data.value) > 0.0 then
			SetVehicleDoorShut(vehicle, data.value, false)
			doors[GetDoorFromIndex(data.value)] = false
		else
			SetVehicleDoorOpen(vehicle, data.value, false, true)
			doors[GetDoorFromIndex(data.value)] = true
		end
		Wait(50)
		if doors.P_R and doors.P_L and doors.BONNET and doors.BOOT and not doors.D_R and not doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-65.png")
		elseif doors.P_R and doors.P_L and doors.BONNET and not doors.BOOT and not doors.D_R and not doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-64.png")
		elseif doors.P_R and doors.P_L and not doors.BONNET and doors.BOOT and not doors.D_R and not doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-63.png")
		elseif doors.P_R and doors.P_L and not doors.BONNET and not doors.BOOT and not doors.D_R and not doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-62.png")
		elseif doors.P_R and doors.P_L and doors.BONNET and doors.BOOT and not doors.D_R and doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-61.png")
		elseif doors.P_R and doors.P_L and doors.BONNET and doors.BOOT and doors.D_R and not doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-60.png")
		elseif not doors.P_R and doors.P_L and doors.BONNET and doors.BOOT and doors.D_R and not doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-59.png")
		elseif doors.P_R and not doors.P_L and doors.BONNET and doors.BOOT and not doors.D_R and doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-58.png")
		elseif doors.P_R and not doors.P_L and doors.BONNET and doors.BOOT and doors.D_R and not doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-57.png")
		elseif not doors.P_R and doors.P_L and doors.BONNET and doors.BOOT and not doors.D_R and doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-56.png")
		elseif doors.P_R and doors.P_L and doors.BONNET and not doors.BOOT and doors.D_R and not doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-55.png")
		elseif doors.P_R and doors.P_L and  doors.BONNET and not doors.BOOT and not doors.D_R and doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-54.png")
		elseif doors.P_R and not doors.P_L and doors.BONNET and not doors.BOOT and doors.D_R and not doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-53.png")
		elseif not doors.P_R and doors.P_L and doors.BONNET and not doors.BOOT and not doors.D_R and doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-52.png")
		elseif not doors.P_R and doors.P_L and doors.BONNET and not doors.BOOT and doors.D_R and not doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-51.png")
		elseif doors.P_R and not doors.P_L and doors.BONNET and not doors.BOOT and not doors.D_R and doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-50.png")
		elseif doors.P_R and doors.P_L and not doors.BONNET and doors.BOOT and doors.D_R and not doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-49.png")
		elseif doors.P_R and doors.P_L and not doors.BONNET and doors.BOOT and not doors.D_R and doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-48.png")
		elseif doors.P_R and not doors.P_L and not doors.BONNET and doors.BOOT and doors.D_R and not doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-47.png")
		elseif not doors.P_R and doors.P_L and not doors.BONNET and doors.BOOT and not doors.D_R and  doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-46.png")
		elseif not doors.P_R and doors.P_L and not doors.BONNET and doors.BOOT and doors.D_R and not doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-44.png")
		elseif  doors.P_R and not doors.P_L and not doors.BONNET and doors.BOOT and not doors.D_R and doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-43.png")
		elseif  doors.P_R and doors.P_L and not doors.BONNET and not doors.BOOT and doors.D_R and not doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-42.png")
		elseif  doors.P_R and doors.P_L and not doors.BONNET and not doors.BOOT and not doors.D_R and doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-41.png")
		elseif  doors.P_R and not doors.P_L and not doors.BONNET and not doors.BOOT and doors.D_R and not doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-40.png")
		elseif not doors.P_R and  doors.P_L and not doors.BONNET and not doors.BOOT and not doors.D_R and doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-39.png")
		elseif not doors.P_R and  doors.P_L and not doors.BONNET and not doors.BOOT and doors.D_R and not doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-38.png")
		elseif  doors.P_R and not doors.P_L and not doors.BONNET and not doors.BOOT and not doors.D_R and  doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-37.png")
		elseif doors.P_R and doors.P_L and doors.BONNET and doors.BOOT and doors.D_R and doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-36.png")
		elseif doors.P_R and not doors.P_L and doors.BONNET and doors.BOOT and doors.D_R and doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-35.png")
		elseif not doors.P_R and doors.P_L and doors.BONNET and doors.BOOT and doors.D_R and doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-34.png")
		elseif not doors.P_R and not doors.P_L and doors.BONNET and doors.BOOT and doors.D_R and doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-33.png")
		elseif doors.P_R and not doors.P_L and doors.BONNET and doors.BOOT and not doors.D_R and not doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-32.png")
		elseif not doors.P_R and doors.P_L and doors.BONNET and doors.BOOT and not doors.D_R and not doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-31.png")
		elseif not doors.P_R and not doors.P_L and doors.BONNET and doors.BOOT and doors.D_R and not doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-30.png")
		elseif not doors.P_R and not doors.P_L and doors.BONNET and doors.BOOT and not doors.D_R and doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-29.png")
		elseif not doors.P_R and not doors.P_L and doors.BONNET and doors.BOOT and not doors.D_R and not doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-28.png")
		elseif doors.P_R and doors.P_L and doors.BONNET and not doors.BOOT and doors.D_R and doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-27.png")
		elseif not doors.P_R and doors.P_L and doors.BONNET and not doors.BOOT and doors.D_R and doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-26.png")
		elseif doors.P_R and not doors.P_L and doors.BONNET and not doors.BOOT and doors.D_R and doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-25.png")
		elseif not doors.P_R and not doors.P_L and doors.BONNET and not doors.BOOT and doors.D_R and doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-24.png")
		elseif doors.P_R and not doors.P_L and  doors.BONNET and not doors.BOOT and not doors.D_R and not doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-23.png")
		elseif not doors.P_R and  doors.P_L and doors.BONNET and not doors.BOOT and not doors.D_R and not doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-22.png")
		elseif not doors.P_R and not doors.P_L and doors.BONNET and not doors.BOOT and  doors.D_R and not doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-21.png")
		elseif not doors.P_R and not doors.P_L and doors.BONNET and not doors.BOOT and not doors.D_R and doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-20.png")
		elseif  doors.P_R and  doors.P_L and not doors.BONNET and doors.BOOT and doors.D_R and doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-19.png")
		elseif not doors.P_R and doors.P_L and not doors.BONNET and doors.BOOT and doors.D_R and doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-18.png")
		elseif doors.P_R and not doors.P_L and not doors.BONNET and doors.BOOT and doors.D_R and doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-17.png")
		elseif not doors.P_R and not doors.P_L and not doors.BONNET and doors.BOOT and doors.D_R and doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-16.png")
		elseif doors.P_R and not doors.P_L and not doors.BONNET and doors.BOOT and not doors.D_R and not doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-15.png")
		elseif not doors.P_R and  doors.P_L and not doors.BONNET and doors.BOOT and not doors.D_R and not doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-14.png")
		elseif not doors.P_R and not doors.P_L and not doors.BONNET and doors.BOOT and doors.D_R and not doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-13.png")
		elseif not doors.P_R and not doors.P_L and not doors.BONNET and doors.BOOT and not doors.D_R and doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-12.png")
		elseif not doors.P_R and not doors.P_L and  doors.BONNET and not doors.BOOT and not doors.D_R and not doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-11.png")
		elseif not doors.P_R and not doors.P_L and not doors.BONNET and  doors.BOOT and not doors.D_R and not doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-10.png")
		elseif  doors.P_R and  doors.P_L and not doors.BONNET and not doors.BOOT and  doors.D_R and  doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-9.png")
		elseif not doors.P_R and  doors.P_L and not doors.BONNET and not doors.BOOT and  doors.D_R and  doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-8.png")
		elseif doors.P_R and not doors.P_L and not doors.BONNET and not doors.BOOT and  doors.D_R and  doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-7.png")
		elseif not doors.P_R and not doors.P_L and not doors.BONNET and not doors.BOOT and doors.D_R and doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-6.png")
		elseif doors.P_R and not doors.P_L and not doors.BONNET and not doors.BOOT and not doors.D_R and not doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-5.png")
		elseif not doors.P_R and doors.P_L and not doors.BONNET and not doors.BOOT and not doors.D_R and not doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-4.png")
		elseif not doors.P_R and not doors.P_L and not doors.BONNET and not doors.BOOT and doors.D_R and not doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-3.png")
		elseif not doors.P_R and not doors.P_L and not doors.BONNET and not doors.BOOT and not doors.D_R and doors.D_L then
			nuiMessage("VEHICLE_DOORS", "vehicle-2.png")
		else
			nuiMessage("VEHICLE_DOORS", "vehicle-1.png")
		end
	end
end)

RegisterNUICallback("toggleWindow", function(data, cb)
	wins[data.door] = not wins[data.door]
	if wins[data.door] or IsVehicleWindowIntact(vehicle, data.window) then
		RollDownWindow(vehicle, data.window)
	else
		RollUpWindow(vehicle, data.window)
	end
end)

RegisterNUICallback("getHudSetting", function(data, cb)
	if data.type == "speedType" then
		SpeedType = data.value
	elseif data.type == "compassBehaviour" then
		CompassMode = data.value
	elseif data.type == "speedoRefreshRate" then
		RefreshRate = Config.SpeedometerRefreshRateTimes[data.value]
	end
end)

Citizen.CreateThread(function()
	local lastVehicle = nil
	
	while true do
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		local PlayerIsDriver = GetPedInVehicleSeat(vehicle, -1) == PlayerPedId()
		if DoesEntityExist(vehicle) and vehicle ~= 0 and vehicle ~= nil then
			if lastVehicle ~= vehicle then 
				lastVehicle = vehicle
				TriggerEvent('enterVehicle', vehicle, PlayerIsDriver)
				if PlayerIsDriver then
					isDriver = true
				end
			else
				if not isDriver and PlayerIsDriver then
					isDriver = true
					TriggerEvent('enterVehicle', vehicle, true)
				elseif isDriver and not PlayerIsDriver then
					TriggerEvent('exitVehicle', vehicle, false)
					isDriver = false
				end
			end
		else
			if lastVehicle then
				TriggerEvent('exitVehicle', lastVehicle,isDriver)
				if isDriver then
					isDriver = false
				end
				lastVehicle = nil
			end
		end
		Citizen.Wait(500)
	end
end)

AddEventHandler('exitVehicle',function()
	inVeh = false
	vehicle = nil
	nuiMessage("IN_VEHICLE", {value = false, type = 0})
	SetPlayerCanDoDriveBy(PlayerId(), true)
end)

AddEventHandler('enterVehicle',function(_,isDriver)
    vehicle = _
    if isDriver then
        if not inVeh then
            inVeh = true
			
            Citizen.CreateThread(function()
                while inVeh do
					
					if DoesEntityExist(vehicle) and vehicle ~= 0 and vehicle ~= nil then
						local PlayerPed = PlayerPedId() 
						local playerPos = GetEntityCoords(PlayerPed, true)
						local heading = 0
						local Dlights = GetVehicleDashboardLights()
						local EngineStatus = GetIsVehicleEngineRunning(vehicle)					
						local speedVeh = GetEntitySpeed(vehicle)
						
						if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPed), -1) == PlayerPed then
							nuiMessage("SET_IN_PASSENGER_SIDE", false)
						else
							nuiMessage("SET_IN_PASSENGER_SIDE", true)
						end
						
						if SpeedType == "mph" then
							speed = math.floor(speedVeh * 2.23694)
						else
							speed = math.floor(speedVeh * 3.6)
						end

						nuiMessage("IN_VEHICLE", {value = true, type = GetVehicleType(vehicle)})
						nuiMessage("UPDATE_CLOCK", GetClockHours()..":".. GetClockMinutes())
						nuiMessage("FUEL", Config.Fuel(vehicle))
						nuiMessage("VEHICLE_LIGHTS", CheckLight())
						nuiMessage("ENGINE_STATUS", EngineStatus)					
						nuiMessage("SET_LIGHT_DATA", {sirenOn = IsVehicleSirenOn(vehicle), inPoliceVehicle = IsPoliceCar(), inAmbulanceVehicle = IsAmbulanceCar() })
						if Dlights == 4 or Dlights == 260 or Dlights == 132 or Dlights == 388 then
							nuiMessage("handbrake", 1)
							nuiMessage("abs", 0)
						elseif Dlights == 16 or Dlights == 272 or Dlights == 144 or Dlights == 400 then
							nuiMessage("handbrake", 0)
							nuiMessage("abs", 1)
						else
							nuiMessage("handbrake", 0)
							nuiMessage("abs", 0)
						end	
						if CompassMode == 'playerlook' then
							heading = tostring(round(360.0 - GetEntityHeading(PlayerPed)))
						else
							local camRot = GetGameplayCamRot(0)
							heading = tostring(round(360.0 - ((camRot.z + 360.0) % 360.0)))
						end
						
						local streetA, streetB = GetStreetNameAtCoord(playerPos.x, playerPos.y, playerPos.z)
						if not ((streetA == lastStreetA or streetA == lastStreetB) and (streetB == lastStreetA or streetB == lastStreetB)) then
							lastStreetA = streetA
							lastStreetB = streetB
							compass = degreesToIntercardinalDirection(heading)
							nuiMessage("SET_LOCATION",{
								heading = compass,
								zone = GetStreetNameFromHashKey(lastStreetA),
								street = GetStreetNameFromHashKey(lastStreetB)
							})
						end

						nuiMessage("SET_SPEED",{
							current = tonumber(speed), 
							rpm = tonumber(GetVehicleCurrentRpm(vehicle)), 
							max = tonumber(GetVehicleModelEstimatedMaxSpeed(vehicle)), 
							wind = tonumber(GetWindSpeed()), 
							roll = tonumber(GetEntityRotation(vehicle).y), 
							gear = tonumber(GetVehicleCurrentGear(vehicle)), 
							headingValue = tonumber(GetEntityHeading(vehicle))
						})
						
					end
					Citizen.Wait(RefreshRate)
				end
            end)
        end
    end
	if isDriver then
		SetPlayerCanDoDriveBy(PlayerId(), false)
	end
end)

if Config.EnableRegisterKeyMapping then
	-- if Config.EnableEngineToggle then
		-- RegisterCommand("hud_enginecontrol", function()
			-- if inVeh then
				-- ToggleEngineStatus()
			-- end
		-- end)
		-- RegisterKeyMapping('hud_enginecontrol', 'Engine Control', 'keyboard', Config.VehicleEngineToggleKey)
	-- end
	
	-- if Config.EnableIndicators then
		-- RegisterCommand("hud_indicatorleft", function()
			-- if inVeh then
				-- ToggleIndicators("left")
			-- end
		-- end)
		-- RegisterKeyMapping('hud_indicatorleft', 'Indicator Control Left', 'keyboard', Config.leftindicator)
		
		-- RegisterCommand("hud_indicatorright", function()
			-- if inVeh then
				-- ToggleIndicators("right")
			-- end
		-- end)
		-- RegisterKeyMapping('hud_indicatorright', 'Indicator Control Right', 'keyboard', Config.rightindicator)
		
		-- RegisterCommand("hud_hazardlight", function()
			-- if inVeh then
				-- ToggleIndicators("both")
			-- end
		-- end)
		-- RegisterKeyMapping('hud_hazardlight', 'Hazard Control Light', 'keyboard', Config.hazardlights)
		
	-- end
	
	AddEventHandler("onKeyDown", function(key)
		if Config.EnableEngineToggle then
			if key == string.lower(Config.VehicleEngineToggleKey) then
				if CheckIsDriver() then
					ToggleEngineStatus()
				end
			end
		end
		if Config.EnableIndicators then
			if key == string.lower(Config.leftindicator) then
				if CheckIsDriver() then
					ToggleIndicators("left")
				end
			end
			if key == string.lower(Config.rightindicator) then
				if CheckIsDriver() then
					ToggleIndicators("right")
				end
			end
			if key == string.lower(Config.hazardlights) then
				if CheckIsDriver() then
					ToggleIndicators("both")
				end
			end
		end
	end)
else
    CreateThread(function()
        while true do
            local ped = PlayerPedId()
            if inVeh then
                if IsControlJustPressed(0, Config.Keys[Config.VehicleEngineToggleKey]) then
					ToggleEngineStatus()
                end
				if IsControlJustPressed(0, Config.Keys[Config.leftindicator]) then
					ToggleIndicators("left")
                end
				if IsControlJustPressed(0, Config.Keys[Config.rightindicator]) then
					ToggleIndicators("right")
                end
				if IsControlJustPressed(0, Config.Keys[Config.hazardlights]) then
					ToggleIndicators("both")
                end
            end
            Wait(5)
        end
    end)
end

function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num + 0.5 * mult)
end

function GetPlayerVehicle()
	return vehicle
end

function CheckPlayerInVehicle()
	return inVeh
end

function CheckIsDriver()
	return isDriver
end

function CheckLight()
	local light, lightsOn , highbeamsOn = GetVehicleLightsState(vehicle)
	if light == 0 then
		return false
	end
	if lightsOn == 1 or highbeamsOn == 1 then
		return true
	else
		return false
	end
end

function IsAmbulanceCar()
	for i=1, #Config.AmbulanceVehicles do
		VehicleHash = GetEntityModel(vehicle)	
		Ambulance = Config.AmbulanceVehicles[i]
		if VehicleHash == Ambulance then	
			return true
		else
			return false
		end
	end
	return false
end

function IsPoliceCar()
	for i=1, #Config.PoliceVehicles do
		VehicleHash = (GetEntityModel(vehicle))
		Police = Config.PoliceVehicles[i]
		if VehicleHash == Police then	
			return true
		else
			return false
		end
	end
	return false
end

function ToggleEngineStatus()
	EngineStatus = not EngineStatus
	if Config.EnableEngineToggle then
		nuiMessage("ENGINE_STATUS", EngineStatus)
		
		if EngineStatus ~= (not GetIsVehicleEngineRunning(vehicle)) then
			EngineStatus = (not GetIsVehicleEngineRunning(vehicle))
		end
		SetVehicleEngineOn(vehicle, EngineStatus, Config.ForceEngineOff, Config.ForceEngineOff)
		if EngineStatus then
			Config.Notification(Config.Notifications["ENGINE_ON"].message, Config.Notifications["ENGINE_ON"].type)
		else
			Config.Notification(Config.Notifications["ENGINE_OFF"].message, Config.Notifications["ENGINE_OFF"].type)
		end
	end
end

function ToggleIndicators(type)
	if Config.EnableIndicators then
		indicator = GetVehicleIndicatorLights(vehicle)
		if type == "right" then
			if indicator == 0 then
				SetVehicleIndicatorLights(vehicle, 0, true)
				SetVehicleIndicatorLights(vehicle, 1, false)
				nuiMessage("VEHICLE_SIGNALS", {leftindicator = false, rightindicator = true, hazardlights = false})
			else
				SetVehicleIndicatorLights(vehicle, 0, false)
				SetVehicleIndicatorLights(vehicle, 1, false)
				nuiMessage("VEHICLE_SIGNALS", {leftindicator = false, rightindicator = false, hazardlights = false})
			end
		elseif type == "left" then
			if indicator == 0 then
				SetVehicleIndicatorLights(vehicle, 1, true)
				SetVehicleIndicatorLights(vehicle, 0, false)
				nuiMessage("VEHICLE_SIGNALS", {leftindicator = true, rightindicator = false, hazardlights = false})
			else
				SetVehicleIndicatorLights(vehicle, 0, false)
				SetVehicleIndicatorLights(vehicle, 1, false)
				nuiMessage("VEHICLE_SIGNALS", {leftindicator = false, rightindicator = false, hazardlights = false})
			end
		elseif type == "both" then
			if indicator == 0 then
				SetVehicleIndicatorLights(vehicle, 1, true)
				SetVehicleIndicatorLights(vehicle, 0, true)
				nuiMessage("VEHICLE_SIGNALS", {leftindicator = false, rightindicator = false, hazardlights = true})
			else
				SetVehicleIndicatorLights(vehicle, 0, false)
				SetVehicleIndicatorLights(vehicle, 1, false)
				nuiMessage("VEHICLE_SIGNALS", {leftindicator = false, rightindicator = false, hazardlights = false})
			end
		end	
	end
end

GetNeonFromIndex = function(Index)
	if Index == 0 then
		return "left"
	elseif Index == 1 then
		return "right"
	elseif Index == 2 then
		return "front"
	elseif Index == 3 then
		return "back"
	end
end

GetDoorFromIndex = function(Index)
	if Index == 0 then
		return "D_L"
	elseif Index == 1 then
		return "D_R"
	elseif Index == 2 then
		return "P_L"
	elseif Index == 3 then
		return "P_R"
	elseif Index == 4 then
		return "BONNET"
	elseif Index == 5 then
		return "BOOT"
	end
end