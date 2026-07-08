local Core = nil
function GetCore()
	local Framework = "ESX"
	local counter = 0
	while not Core  do
		TriggerEvent('esx:getSharedObject', function(obj) Core = obj end)
		counter = counter + 1
		if counter == 3 then
			break
		end
	end
	return Core, Framework
end

function WaitCore()
	while Core == nil do
		Wait(10)
	end
end
