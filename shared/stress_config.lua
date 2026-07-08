Config = Config or {}

local inPaintBall = false
Config.EnableStress = true
Config.StressMysqlTable = "hud_stress"
Config.StressWhitelistJobs = { -- Add jobs you want to disable stress
    'police',
	'ambulance',
	'sheriff',
	'fbi',
	'doc',
	'mt',
	'government',
}

Config.WhitelistedWeaponStress = { 
    `weapon_petrolcan`,
    `weapon_hazardcan`,
    `weapon_fireextinguisher`,
    `WEAPON_UNARMED`
}

Config.RemoveStress = {
    ["eat"] = {
        min = 1,
        max = 10,
        enable = true,
        func = function()
            RegisterNetEvent('devcore_needs:client:StartEat')
            AddEventHandler('devcore_needs:client:StartEat', function()
                local val = math.random(Config.RemoveStress["eat"].min, Config.RemoveStress["eat"].max)
                TriggerServerEvent('hud:server:RelieveStress', val)
            end)
            RegisterNetEvent('esx_basicneeds:onEat')
            AddEventHandler('esx_basicneeds:onEat', function()
                local val = math.random(Config.RemoveStress["eat"].min, Config.RemoveStress["eat"].max)
                TriggerServerEvent('hud:server:RelieveStress', val)
            end) 
            RegisterNetEvent('consumables:client:Eat')
            AddEventHandler('consumables:client:Eat', function()
                local val = math.random(Config.RemoveStress["eat"].min, Config.RemoveStress["eat"].max)
                TriggerServerEvent('hud:server:RelieveStress', val)
            end) 
            RegisterNetEvent("esx_basicneeds:onUse")
            AddEventHandler("esx_basicneeds:onUse", function(type)
                if type == 'food' then
                    local val = math.random(Config.RemoveStress["eat"].min, Config.RemoveStress["eat"].max)
                    TriggerServerEvent('hud:server:RelieveStress', val)
                end
            end)
        end
    },
    ["drink"] = {
        min = 1,
        max = 10,
        enable = true,
        func = function()
            RegisterNetEvent('consumables:client:Drink')
            AddEventHandler('consumables:client:Drink', function()
                local val = math.random(Config.RemoveStress["drink"].min, Config.RemoveStress["drink"].max)
                TriggerServerEvent('hud:server:RelieveStress', val)
            end)
            RegisterNetEvent('consumables:client:DrinkAlcohol')
            AddEventHandler('consumables:client:DrinkAlcohol', function()
                local val = math.random(Config.RemoveStress["drink"].min, Config.RemoveStress["drink"].max)
                TriggerServerEvent('hud:server:RelieveStress', val)
            end) 
            RegisterNetEvent('devcore_needs:client:DrinkShot')
            AddEventHandler('devcore_needs:client:DrinkShot', function()
                local val = math.random(Config.RemoveStress["drink"].min, Config.RemoveStress["drink"].max)
                TriggerServerEvent('hud:server:RelieveStress', val)
            end) 
            RegisterNetEvent('devcore_needs:client:StartDrink')
            AddEventHandler('devcore_needs:client:StartDrink', function()
                local val = math.random(Config.RemoveStress["drink"].min, Config.RemoveStress["drink"].max)
                TriggerServerEvent('hud:server:RelieveStress', val)
            end) 
            RegisterNetEvent('esx_optionalneeds:onDrink')
            AddEventHandler('esx_optionalneeds:onDrink', function()
                local val = math.random(Config.RemoveStress["drink"].min, Config.RemoveStress["drink"].max)
                TriggerServerEvent('hud:server:RelieveStress', val)
            end) 
            RegisterNetEvent('esx_basicneeds:onDrink')
            AddEventHandler('esx_basicneeds:onDrink', function()
                local val = math.random(Config.RemoveStress["drink"].min, Config.RemoveStress["drink"].max)
                TriggerServerEvent('hud:server:RelieveStress', val)
            end)
			
			RegisterNetEvent('Hz_Basic:onDrink')
            AddEventHandler('Hz_Basic:onDrink', function()
                local val = math.random(Config.RemoveStress["drink"].min, Config.RemoveStress["drink"].max)
                TriggerServerEvent('hud:server:RelieveStress', val)
            end) 
			
            RegisterNetEvent("esx_basicneeds:onUse")
            AddEventHandler("esx_basicneeds:onUse", function(type)
                if type == 'drink' then
                    local val = math.random(Config.RemoveStress["drink"].min, Config.RemoveStress["drink"].max)
                    TriggerServerEvent('hud:server:RelieveStress', val)
                end
            end)
        end
    },
    ["death"] = {
        enable = true,
        func = function()
            -- AddEventHandler('esx:onPlayerDeath', function() 
                -- TriggerServerEvent('hud:server:RelieveStress', 100)
            -- end)
            
            RegisterNetEvent('Hz_AmbulanceJob:NewRespawn')
            AddEventHandler('Hz_AmbulanceJob:NewRespawn', function() 
                TriggerServerEvent('hud:server:RelieveStress', 100)
            end)
        end
    },
    ["swim"] = {
        min = 1,
        max = 2,
        enable = true,
        func = function()
            CreateThread(function()
                while true do
                    local ped = PlayerPedId()
                    if IsPedSwimming(ped) then
                        local val = math.random(Config.RemoveStress["swim"].min, Config.RemoveStress["swim"].max)
                        TriggerServerEvent('hud:server:RelieveStress', val)
                    end
                    Wait(10000)

                end
            end)
        end
    },
    ["run"] = {
        min = 1,
        max = 2,
        enable = true,    
        func = function()
            CreateThread(function()
                while true do
                    local ped = PlayerPedId()
                    if IsPedRunning(ped) and not InPaintball then
                        local val = math.random(Config.RemoveStress["run"].min, Config.RemoveStress["run"].max)
                        TriggerServerEvent('hud:server:RelieveStress', val)
                    end
                    Wait(10000)
                end
            end)
        end
    }
}

Config.AddStress = {
    ["shoot"] = {
        min = 1, -- minimum amount to add stress
        max = 10, -- maximum amount to add stress
        enable = true,
        func = function()
            CreateThread(function()            
                while true do
                    local ped = PlayerPedId()
                    local weapon = GetSelectedPedWeapon(ped)
                    if weapon ~= `WEAPON_UNARMED` then
                        if IsPedShooting(ped) then
							
                            if math.random() < 0.15 and not IsWhitelistedWeaponStress(weapon) and not InPaintball then
							
                                TriggerServerEvent('hud:server:GainStress', math.random(Config.AddStress["shoot"].min, Config.AddStress["shoot"].max))
                            end
                        end
                    else
                        Wait(1000)
                    end
                    Wait(1000)
                end
            end)
        end
    },
    ["drive_fast"] = {
        min = 1, -- minimum amount to add stress
        max = 5, -- maximum amount to add stress
        enable = true,
        func = function()
            CreateThread(function()            
                while true do
                    local ped = PlayerPedId()
                    if IsPedInAnyVehicle(ped, false) then
                        local speed = GetEntitySpeed(vehicle) * 3.6
                        local stressSpeed = 100 -- KMH value
                        if speed >= stressSpeed then
                            TriggerServerEvent('hud:server:GainStress', math.random(Config.AddStress["drive_fast"].min, Config.AddStress["drive_fast"].max))
                        end
                    end
                    Wait(10000)
                end
            end)
        end
    },
	["falling"] = {
        min = 1, -- minimum amount to add stress
        max = 6, -- maximum amount to add stress
        enable = true,
        func = function()
            CreateThread(function()            
                while true do
                    local ped = PlayerPedId()
                    if not IsPedInAnyVehicle(ped, false) then
                        local x,y,z = table.unpack(GetEntityCoords(ped))
						local FoundGround, GroundZ = GetGroundZFor_3dCoord(x,y,z, true)
						local distance = GetDistanceBetweenCoords(x,y,GroundZ , x,y,z, true)
						local Falling = IsPedFalling(ped)
                        if Falling == 1 and FoundGround and distance >= 10.0 then
                            TriggerServerEvent('hud:server:GainStress', math.random(Config.AddStress["falling"].min, Config.AddStress["falling"].max))
                        end
                    end
                    Wait(5000)
                end
            end)
        end
    },
}

RegisterNetEvent("Hz_PaintBall:inPaintBall")
AddEventHandler("Hz_PaintBall:inPaintBall", function(toggle)
	inPaintBall = toggle
end)