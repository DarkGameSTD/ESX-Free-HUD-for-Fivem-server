musics = {}
playlists = {}
playlistSongs = {}
local insertData = {}

if Config.Menu.media then
    CreateThread(function()
        Wait(1000)
		MySQL.Async.fetchAll('SELECT * FROM hud_playlists', {}, function(result)
			MySQL.Async.fetchAll('SELECT * FROM hud_playlist_songs', {}, function(result2)
				playlists = result
				playlistSongs = result2
				if playlists ~= nil then
					for _,v in pairs(playlists) do
						v.likes = json.decode(v.likes)
						if not v.musics then
							v.musics = {}
						end
						for __,vv in pairs(playlistSongs) do
						  
							if vv.playlist_id == v.id then
								table.insert(v.musics, {url = vv.url, name = vv.name, id = vv.id, playlist_id = vv.playlist_id})
							end
						end
					end    
				end
			end)
		end)
    end)
    
    AddEventHandler('playerDropped', function()
        local src = source
        if musics[src] then
            musics[src] = false
            TriggerClientEvent("RV_HuD:DestroyMusic", -1, src)
            TriggerClientEvent("RV_HuD:SynchronizeMusics", -1, data, src)
        end
    end)
    
    function AddSongToPlaylist(playListId, name, url)
        local playlist = GetPlaylistById(playListId)
        if playlist then  
            for _,v in pairs(playlist.musics) do
                if v.url == url then
                    return
                end
            end
           
            local parameters = { ['@playlistId'] = playListId,  ['@url'] = url, ['@name'] = name }
			MySQL.Async.fetchAll('INSERT INTO hud_playlist_songs (playlist_id, url, name) VALUES (@playlistId, @url, @name)', parameters, function(insertData)
				if insertData then
					local id = insertData.insertId
					table.insert(playlist.musics, {
						id = id,
						playlist_id = playListId,
						name = name,
						url = url,            
					})
				end
			end)
            -- MySQL.Async.fetchAll('INSERT INTO `hud_playlist_songs` (`id`, `url`, `name`) VALUES ('..playListId..', '..json.encode(url)..', '..json.encode(name)..')')
        end
    end
    
    RegisterServerEvent("RV_HuD:ChangePlaylistData")
    AddEventHandler("RV_HuD:ChangePlaylistData", function(playlistid, type, newval)
        local src = source
        local identifier = GetIdentifier(src)
        local playlist = GetPlaylistById(playlistid)
    
        if playlist and playlist.owner == identifier then
            playlist[type] = newval
            MySQL.Async.fetchAll(string.format("UPDATE `hud_playlists` SET "..type.." = '%s' WHERE id='%s'", newval, playlistid))
            TriggerClientEvent("RV_HuD:OnMyPlaylistChange", src, playlistid, GetPlaylistById(playlistid))
            TriggerClientEvent("RV_HuD:OnPlaylistChange", -1, playlistid, GetPlaylistById(playlistid)) 
        end
    end)
    
    RegisterServerEvent("RV_HuD:DeleteMusic")
    AddEventHandler("RV_HuD:DeleteMusic", function(id, musicId)
        local src = source
        local identifier = GetIdentifier(src)
        local playlist = GetPlaylistById(id)
    
        if playlist and playlist.owner == identifier then
            for _,v in pairs(playlist.musics) do
                if tonumber(v.id) == tonumber(musicId) then
                    table.remove(playlist.musics, _)
                    TriggerClientEvent("RV_HuD:OnMyPlaylistChange", src, id, playlist)
                    TriggerClientEvent("RV_HuD:OnPlaylistChange", -1, id, playlist) 
                    MySQL.Async.fetchAll(string.format("DELETE FROM `hud_playlist_songs` WHERE id = '%s'", musicId))
                end
            end
        end
    end)
    
    RegisterServerEvent("RV_HuD:musicChange")
    AddEventHandler("RV_HuD:musicChange", function()
        local src = source
        TriggerClientEvent('RV_HuD:musicChange', -1, src)
    end)
    
    
    RegisterServerEvent("RV_HuD:LikePlaylist")
    AddEventHandler("RV_HuD:LikePlaylist", function(id)
        local src = source
        local playlist = GetPlaylistById(id)
        local identifier = GetIdentifier(src)
		
        if playlist.likes ~= nil then
            for _,v in ipairs(playlist.likes) do
                if v == identifier then
                    return
                end
            end
            --table.insert(playlist.likes, identifier)
            MySQL.Async.fetchAll(string.format("UPDATE `hud_playlists` SET likes = %q WHERE id='%s'", json.encode(playlist.likes), id))
            TriggerClientEvent("RV_HuD:UpdateMyPlaylistLikes", src, id, playlist.likes)        
            TriggerClientEvent("RV_HuD:UpdatePlaylistLikes", -1, id, playlist.likes)
    
        end
    end)
    
    
    RegisterServerEvent("RV_HuD:UnLikePlaylist")
    AddEventHandler("RV_HuD:UnLikePlaylist", function(id)
        local src = source
        local playlist = GetPlaylistById(id)
        local identifier = GetIdentifier(src)
        if playlist then
            local index = false
            for _,v in pairs(playlist.likes) do
                if v == identifier then
                    index = _
                end
            end
            if index then
                --table.remove(playlist.likes, index)
                MySQL.Async.fetchAll(string.format("UPDATE `hud_playlists` SET likes = %q WHERE id='%s'", json.encode(playlist.likes), id))
                TriggerClientEvent("RV_HuD:UpdateMyPlaylistLikes", src, id, playlist.likes)        
                TriggerClientEvent("RV_HuD:UpdatePlaylistLikes", -1, id, playlist.likes)
            end
        end
    end)
    
    RegisterServerEvent('RV_HuD:AddSongToPlaylist')
    AddEventHandler('RV_HuD:AddSongToPlaylist', function(playListId, name, url)
        local src = source
        AddSongToPlaylist(playListId, name, url)
        TriggerClientEvent("RV_HuD:OnMyPlaylistChange", src, playListId, GetPlaylistById(playListId))
        TriggerClientEvent("RV_HuD:OnPlaylistChange", -1, playListId, GetPlaylistById(playListId)) 
    end)
    
    function GetPlaylistById(id)
		if playlists ~= nil then
			for _,v in pairs(playlists) do
				if tonumber(v.id) == tonumber(id) then
					return v, _
				end 
			end
		end
        return false
    end
    
    function GetMyPlaylists(source)
        local myPlaylists = {}
        local identifier = GetIdentifier(source)
        if identifier then
			if playlists ~= nil then
				for _,v in pairs(playlists) do
					if v.owner == identifier then
						table.insert(myPlaylists, v)
					end
				end
			end
        end
        return myPlaylists
    end
    
    RegisterServerEvent("RV_HuD:CreatePlaylist")
    AddEventHandler("RV_HuD:CreatePlaylist", function(name, cover, songs)
		
        local src = source
        local identifier = GetIdentifier(src)
        local playerName = GetPlayerRoleplayName(src)
        if identifier and playerName then
			MySQL.Async.fetchAll(string.format("INSERT INTO `hud_playlists` (name, cover, owner, creatorname, likes) VALUES ('%s', '%s', '%s', '%s', %q)", name, cover, identifier, playerName, json.encode({})), function(insertData)
				if insertData then
					local id = insertData.insertId
					local data = {
						id = id,
						owner = identifier,
						name = name,
						cover = cover,
						musics = {},
						likes = {},
						creatorname = playerName,
					}
					table.insert(playlists, data)
					for _,v in pairs(songs) do
						AddSongToPlaylist(id, v.name, v.url)
					end
					TriggerClientEvent("RV_HuD:OnMyNewPlaylistAdd", src, GetPlaylistById(id))
					TriggerClientEvent("RV_HuD:OnNewPlaylistAdd", -1, GetPlaylistById(id))            
				end
			end)
        end
    end)
    
    RegisterServerEvent("RV_HuD:DeletePlaylist")
    AddEventHandler("RV_HuD:DeletePlaylist", function(id)
        local src = source
        local identifier = GetIdentifier(src)
        local playlist, index = GetPlaylistById(id)
        if identifier and playlist and playlist.owner == identifier then
            table.remove(playlists, index)
            MySQL.Async.fetchAll(string.format("DELETE FROM `hud_playlists` WHERE id = '%s' AND owner = '%s'", id, identifier))
            MySQL.Async.fetchAll(string.format("DELETE FROM `hud_playlist_songs` WHERE playlist_id = '%s'", id))
            
            TriggerClientEvent("RV_HuD:OnMyPlaylistRemove", src, id)
            TriggerClientEvent("RV_HuD:OnPlaylistRemove", -1, id)  
        end
    end)
    
    RegisterServerEvent("RV_HuD:RequestPlaylists")
    AddEventHandler("RV_HuD:RequestPlaylists", function()
        local src = source
        TriggerClientEvent('RV_HuD:SyncAllPlaylists', src, playlists)
        TriggerClientEvent('RV_HuD:SyncMyPlaylists', src, GetMyPlaylists(src))
    end)
    
    RegisterServerEvent("RV_HuD:PlayMusic")
    AddEventHandler("RV_HuD:PlayMusic", function(data)
        local src = source
        if not musics[src] then
            musics[src] = {}
        else
            data.volume = musics[src].volume
        end
        
        musics[src] = data
        TriggerClientEvent("RV_HuD:SynchronizeMusics", -1, data, src)
    end)
    
    RegisterServerEvent("RV_HuD:DestroyMusic")
    AddEventHandler("RV_HuD:DestroyMusic", function()
        local src = source
        if musics[src] then
            musics[src] = false
            TriggerClientEvent("RV_HuD:DestroyMusic", -1, src)
            TriggerClientEvent("RV_HuD:SynchronizeMusics", -1, data, src)
        end
    end)
    
    RegisterServerEvent("RV_HuD:ToggleMusic")
    AddEventHandler("RV_HuD:ToggleMusic", function()
        local src = source
        if musics[src] then
            musics[src].isPaused = not musics[src].isPaused
            TriggerClientEvent("RV_HuD:SynchronizeMusics", -1, musics[src], src)
        end
    end)
    
    
    RegisterServerEvent("RV_HuD:PauseMusic")
    AddEventHandler("RV_HuD:PauseMusic", function()
        local src = source
        if musics[src] then
            if not musics[src].isPaused then            
                musics[src].isPaused = true
                TriggerClientEvent("RV_HuD:SynchronizeMusics", -1, musics[src], src)
            end
        end
    end)
    
    RegisterServerEvent("RV_HuD:ResumeMusic")
    AddEventHandler("RV_HuD:ResumeMusic", function()
        local src = source
        if musics[src] then
            if musics[src].isPaused then
                musics[src].isPaused = false
                TriggerClientEvent("RV_HuD:SynchronizeMusics", -1, musics[src], src)
            end
        end
    end)
    
    
    RegisterServerEvent('RV_HuD:VolumeUp')
    AddEventHandler('RV_HuD:VolumeUp', function()
        local src = source
        if musics[src] then
        
            musics[src].volume = musics[src].volume + 0.1
            if musics[src].volume > 1.0 then
                musics[src].volume = 1.0
            end
            TriggerClientEvent("RV_HuD:SynchronizeMusics", -1, musics[src], src)
        end
    end)
    
    
    RegisterServerEvent('RV_HuD:SetTimeStamp')
    AddEventHandler('RV_HuD:SetTimeStamp', function(timestamp)
        local src = source
        TriggerClientEvent("RV_HuD:SetTimeStamp", -1, src, timestamp)
    end)
    
    RegisterServerEvent('RV_HuD:VolumeDown')
    AddEventHandler('RV_HuD:VolumeDown', function()
        local src = source
        if musics[src] then
    
            musics[src].volume = musics[src].volume - 0.1
            if musics[src].volume < 0.1 then
                musics[src].volume = 0.1
            end
            TriggerClientEvent("RV_HuD:SynchronizeMusics", -1, musics[src], src)
        end
    end)
end
