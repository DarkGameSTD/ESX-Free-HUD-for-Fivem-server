cruise = false

if Config.EnableRegisterKeyMapping then
    CreateThread(function()
        while true do
            if not CheckIsDriver() and cruise then
                cruise = false
                SetCruiseData()
            end
            Wait(1700)
        end
    end)
    -- RegisterCommand("hud_cruisecontrol", function()
        -- if CheckIsDriver() then
            -- ToggleCruise()
        -- end
    -- end)
    -- RegisterKeyMapping('hud_cruisecontrol', 'Cruise Control', 'keyboard', Config.CruiseControlKey)
	AddEventHandler("onKeyDown", function(key)
		if key == string.lower(Config.CruiseControlKey) then
			if CheckIsDriver() then
				ToggleCruise()
			end
		end
	end)

else
    CreateThread(function()
        while true do
            local ped = PlayerPedId()
            if CheckIsDriver() then
                if IsControlJustPressed(0, Config.Keys[Config.CruiseControlKey]) then
                    ToggleCruise()
                end
            else
                if cruise then
                    cruise = false
                    SetCruiseData()
                end
                Wait(1500)
            end
            Wait(0)
        end
    end)
end


function SetCruiseData()
    nuiMessage("SET_CRUISE", {
        enabled = cruise,
        speed = cruiseSpeeds,
    })
end

function ToggleCruise()
    local ped = PlayerPedId()
	if CheckIsDriver() then
		local vehicle = vehicle
		local class = GetVehicleClass(vehicle)
		if class == 14 then
			return
		end
		local cruiseSpeed = GetEntitySpeed(vehicle)
		cruise = not cruise
		
		if SpeedType~=nil and SpeedType == "mph" then
			cruiseSpeeds = math.floor(cruiseSpeed * 2.23694)
		else
			cruiseSpeeds = math.floor(cruiseSpeed * 3.6)
		end
		SetCruiseData()

		if cruise then
			Config.Notification(Config.Notifications["CRUISE_ENABLED"].message, Config.Notifications["CRUISE_ENABLED"].type)
		else
			Config.Notification(Config.Notifications["CRUISE_DISABLED"].message, Config.Notifications["CRUISE_DISABLED"].type)
		end
		CreateThread(function()    
			while cruise do
				if IsVehicleOnAllWheels(vehicle) and GetEntitySpeed(vehicle) > (cruiseSpeed - 2.0) and not HasEntityCollidedWithAnything(vehicle) then
					SetVehicleForwardSpeed(vehicle, cruiseSpeed)
				else
					cruise = false
					SetCruiseData()
				end
				Wait(350)
			end
		end)
	end
end