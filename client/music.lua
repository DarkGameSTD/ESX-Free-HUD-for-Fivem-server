musics = {}
myPlaylists = {}
playlists = {}
local streamerMode = false
local resume = false

if Config.Menu.media then
    xSound = exports.xsound
    function UpdateMyPlaylists()
		if next(myPlaylists) ~= nil then
			nuiMessage("UPDATE_MY_PLAYLISTS", myPlaylists) 
		end
    end
    
    function UpdatePlaylists()
		if next(playlists) ~= nil then
			nuiMessage("UPDATE_PLAYLISTS", playlists)
		end
    end
    
    RegisterNUICallback("createPlaylist", function(data, cb)
        TriggerServerEvent("RV_HuD:CreatePlaylist", data.name, data.cover, data.songs)
    end)
    
    RegisterNUICallback("DeletePlaylist", function(data, cb)
        TriggerServerEvent("RV_HuD:DeletePlaylist", data.id)
    end)
    
    RegisterNUICallback("addToPlaylist", function(data, cb)
        TriggerServerEvent("RV_HuD:AddSongToPlaylist", data.id, data.name, data.url)
		Wait(100)
		UpdateMyPlaylists()
		UpdatePlaylists()
    end)
    RegisterNUICallback("DeleteMusic", function(data, cb)
        TriggerServerEvent("RV_HuD:DeleteMusic", data.id, data.musicId)
    end)
    
    RegisterNUICallback("ChangePlaylistData", function(data, cb)
        TriggerServerEvent("RV_HuD:ChangePlaylistData", data.id, data.type, data.val)
    end)
    
    
    RegisterNetEvent("RV_HuD:SyncMyPlaylists")
    AddEventHandler("RV_HuD:SyncMyPlaylists", function(data)
        myPlaylists = data
        UpdateMyPlaylists()
		UpdatePlaylists()
    
    end)
    
    RegisterNetEvent("RV_HuD:SyncAllPlaylists")
    AddEventHandler("RV_HuD:SyncAllPlaylists", function(data)
        playlists = data
        UpdatePlaylists()
		
    end)
    
    RegisterNetEvent("RV_HuD:OnMyPlaylistChange")
    AddEventHandler("RV_HuD:OnMyPlaylistChange", function(id, data)
        for _,v in pairs(myPlaylists) do
            if tonumber(v.id) == tonumber(id) then
                myPlaylists[_] = data
            end
        end
		Wait(1000)
        UpdateMyPlaylists()
		UpdatePlaylists()
    end)
    
    RegisterNetEvent("RV_HuD:UpdateMyPlaylistLikes")
    AddEventHandler("RV_HuD:UpdateMyPlaylistLikes", function(id, data)
        for _,v in pairs(myPlaylists) do
            if tonumber(v.id) == tonumber(id) then
                myPlaylists[_].likes = data
            end
        end
        UpdateMyPlaylists()
    end)
    
    RegisterNetEvent("RV_HuD:UpdatePlaylistLikes")
    AddEventHandler("RV_HuD:UpdatePlaylistLikes", function(id, data)
    
        for _,v in pairs(playlists) do
            if tonumber(v.id) == tonumber(id) then
                playlists[_].likes = data
            end
        end
        UpdatePlaylists()
    end)
    
    RegisterNetEvent("RV_HuD:OnPlaylistChange")
    AddEventHandler("RV_HuD:OnPlaylistChange", function(id, data)
        for _,v in pairs(playlists) do
            if tonumber(v.id) == tonumber(id) then
                playlists[_] = data
            end
        end
        UpdatePlaylists()
    end)
    
    RegisterNetEvent("RV_HuD:OnMyNewPlaylistAdd")
    AddEventHandler("RV_HuD:OnMyNewPlaylistAdd", function(data)
        table.insert(myPlaylists, data)
		UpdatePlaylists()
        UpdateMyPlaylists()
		
    end)
    
    RegisterNetEvent("RV_HuD:OnNewPlaylistAdd")
    AddEventHandler("RV_HuD:OnNewPlaylistAdd", function(data)
        table.insert(playlists, data)
        UpdatePlaylists()
        UpdateMyPlaylists()
    end)
    
    RegisterNetEvent("RV_HuD:OnMyPlaylistRemove")
    AddEventHandler("RV_HuD:OnMyPlaylistRemove", function(id)
        for _,v in pairs(myPlaylists) do
            if tonumber(v.id) == tonumber(id) then
                table.remove(myPlaylists, _) 
            end
        end
        UpdatePlaylists()
        UpdateMyPlaylists()
    
    end)
    
    RegisterNetEvent("RV_HuD:OnPlaylistRemove")
    AddEventHandler("RV_HuD:OnPlaylistRemove", function(id)
        for _,v in pairs(playlists) do
            if tonumber(v.id) == tonumber(id) then
                table.remove(playlists, _) 
            end
        end
    end)
    
    RegisterNUICallback('getHudSetting', function(data, cb)
		if data.type == "streamerMode" then
			streamerMode = data.value
		end
	end)
	
    RegisterNUICallback('LikePlaylist', function(data, cb)
        TriggerServerEvent('RV_HuD:LikePlaylist', data.id)
        cb('ok')
    end)
    
    RegisterNUICallback('UnLikePlaylist', function(data, cb)
        TriggerServerEvent('RV_HuD:UnLikePlaylist', data.id)
        cb('ok')
    end)
    
    RegisterNUICallback("musicAction", function(data, cb)
		UpdateMyPlaylists()
        if not CheckPlayerInVehicle() then
            cb('ok')   
            return
        end
        if data.type == 'play' then
            TriggerServerEvent('RV_HuD:PlayMusic', {
                url = data.url,
                name = data.name,
                isPaused = false,
                volume = 0.01,
                newTimeStamp = false,
            })
            nuiMessage("SET_SONG_INFORMATIONS", {
                type = 'name',
                value = data.name,
            })
            nuiMessage("SET_SONG_INFORMATIONS", {
                type = 'url',
                value = data.url,
            })
            SetVehicleRadioEnabled(vehicle, false) 
            SetVehRadioStation(vehicle, "OFF")
        end
     
        if data.type == 'toggle' then
            TriggerServerEvent('RV_HuD:ToggleMusic')
            SetVehicleRadioEnabled(vehicle, true) 
        end
    
        if data.type == 'volume-up' then
            TriggerServerEvent('RV_HuD:VolumeUp')
        end
        if data.type == 'volume-down' then
            TriggerServerEvent('RV_HuD:VolumeDown')
        end
        if data.type == 'timestamp' then
            TriggerServerEvent('RV_HuD:SetTimeStamp', data.payload)
    
        end
        cb('ok')
    end)
    
    
    RegisterNetEvent("RV_HuD:SynchronizeMusics")
    AddEventHandler("RV_HuD:SynchronizeMusics", function(data, src)
        musics[src] = data
    end)
    
    RegisterNetEvent("RV_HuD:SetTimeStamp")
    AddEventHandler("RV_HuD:SetTimeStamp", function(src, timestamp)
        if xSound:soundExists('music-'..src) then
            xSound:setTimeStamp('music-'..src, timestamp)
        end
    end)
    
    RegisterNetEvent("RV_HuD:musicChange")
    AddEventHandler("RV_HuD:musicChange", function(src)
        if xSound:soundExists('music-'..src) then
            xSound:Destroy('music-'..src)
        end
    end)
    
    function GetOpenWindows(vehicle)
        local open = false
        for i=0, 3 do
            local door = i
            if door == 2 then
                door = 3
            elseif door == 3 then
                door = 2
            end
            local isclosed = IsvehicleWindowIntact(vehicle,i)
            if not isclosed and GetIsDoorValid(vehicle, door) then
                open = true
            end
        end
        return open
    end
    
    CreateThread(function()
        while true do
            for src, data in pairs(musics) do
                if data then
                    local player = GetPlayerFromServerId(src)
                    if player ~= -1 then
                        local ped = GetPlayerPed(player)
                        local vehicle = GetVehiclePedIsIn(ped)
                        
                        if vehicle and DoesEntityExist(vehicle) then
							
                            if not xSound:soundExists('music-'..src) then
                                xSound:PlayUrlPos('music-'..src, data.url, data.volume, GetEntityCoords(vehicle))
                                xSound:setVolumeMax('music-'..src, 0.09)
                                local myvehicle = GetVehiclePedIsIn(ped)
								
                                if vehicle == myvehicle then
                                    xSound:setVolume('music-'..src, data.volume)
									
                                else
                                    local count = 0
    
                                    if  GetOpenWindows(vehicle) then
                                        count = 1/13
                                    end
    
                                    local volume = ((0.01) + count)
                                    local distance = (#(GetEntityCoords(ped) - GetEntityCoords(vehicle))) / 90
                                    xSound:setVolume('music-'..src, volume-distance)
									
                                end
    
                            else
                                local url = xSound:getLink('music-'..src)
								
                                if url ~= data.url then
                                    xSound:Destroy('music-'..src)
                                    
                                    xSound:PlayUrlPos('music-'..src, data.url, data.volume, GetEntityCoords(vehicle))
                                    xSound:setVolumeMax('music-'..src, 0.09)       
                                    if xSound:isPaused('music-'..src) then
                                        xSound:Resume('music-'..src)      
                                    end
									
                                end
                                if streamerMode then
                                    xSound:setVolume('music-'..src, 0)
									
                                else
                                    local myvehicle = GetVehiclePedIsIn(ped)
									
									vol = xSound:getVolume('music-'..src)
									if vol ~= data.volume then
										if vehicle == myvehicle then
											xSound:setVolume('music-'..src, data.volume)
										else
		
											local count = 0
											if  GetOpenWindows(vehicle) then
												count = 1/13
											end
			
											local volume = ((0.01) + count)
											local distance = (#(GetEntityCoords(ped) - GetEntityCoords(vehicle))) / 90
											xSound:setVolume('music-'..src, volume-distance)
										end
									end
                                end 
                              
                                xSound:Position('music-'..src, GetEntityCoords(vehicle))
                                if data.isPaused  then
                                    xSound:Pause('music-'..src)
									resume = false
                                elseif not data.isPaused and xSound:isPaused('music-'..src) or not xSound:isPlaying('music-'..src) then
									xSound:Resume('music-'..src)
									resume = true
                                end
								dist = xSound:getDistance('music-'..src)
								if dist ~= 7 then
									xSound:Distance('music-'..src, 7)
								end
								
                            end  
                        else
                            if xSound:soundExists('music-'..src) then
                                xSound:Pause('music-'..src)   
								resume = false
                                local mysrc = GetPlayerServerId(PlayerId()) 
                                
                                if mysrc == src then
                                    TriggerServerEvent("RV_HuD:PauseMusic")
                                end
                            end 
                        end
                    end
                else
                    if xSound:soundExists('music-'..src) then
                        xSound:Destroy('music-'..src)
                    end      
                end
            end
            Wait(5)
        end
    end)
    
    RegisterNetEvent("RV_HuD:DestroyMusic")
    AddEventHandler("RV_HuD:DestroyMusic", function(src)
        if xSound:soundExists('music-'..src) then
            xSound:Destroy('music-'..src)     
        end    
    end)
    
    CreateThread(function()
        while true do
            local src = GetPlayerServerId(PlayerId()) 
            local cd = 2000
            if xSound:soundExists('music-'..src) and IsPedInAnyVehicle(PlayerPedId()) then
                local maxDuration = xSound:getMaxDuration('music-'..src)
                local timeStamp = xSound:getTimeStamp('music-'..src)
     
    
         
                nuiMessage("SET_SONG_INFORMATIONS", {
                    type = 'isPaused',
                    value = xSound:isPaused('music-'..src),
                })
                nuiMessage("SET_SONG_INFORMATIONS", {
                    type = 'volume',
                    value = xSound:getVolume('music-'..src),
                })
                if not xSound:isPaused('music-'..src) then
             
                    nuiMessage("SET_MUSIC_TIME", {
                        maxDuration = maxDuration,
                        timeStamp = timeStamp,
                    })
                    if (maxDuration == math.ceil(timeStamp)+1 or maxDuration == math.ceil(timeStamp)+2 or maxDuration == math.ceil(timeStamp)) and maxDuration ~= 0 then
                        nuiMessage("CHANGE_MUSIC")   
                    end
                end
           
                cd = 1000
            end
			UpdateMyPlaylists()
			UpdatePlaylists()
            Wait(cd)
        end
    end)
    
end