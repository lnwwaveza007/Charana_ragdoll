ragdollgodmode = false
oldhealth = 0
ESX = nil
local Bullet = { 453432689, 1593441988, 584646201, -1716589765, 324215364, 736523883, -270015777, -1074790547, -2084633992, -1357824103, -1660422300, 2144741730, 487013001, 2017895192, -494615257, -1654528753, 100416529, 205991906, 1119849093, -1045183535 }

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--function
function checkArray (array, val)
	  for name, value in ipairs(array) do
		  if value == val then
			  return true
		  end
	  end
  
	  return false
  end

function RespawnPed(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	ClearPedBloodDamage(ped)

	TriggerServerEvent('esx:onPlayerSpawn')
	TriggerEvent('esx:onPlayerSpawn')
	TriggerEvent('playerSpawned') -- compatibility with old scripts, will be removed soon
end

function falldown(ped)
	SetEntityProofs(ped, true, false, false, false, false, false, false, false)
	SetPedToRagdoll(ped, 5000, 5000, 0, 0, 0, 0)
	Citizen.Wait(5000)
	SetEntityProofs(ped, false, false, false, false, false, false, false, false)
end

--Make player fall down
Citizen.CreateThread(function()
    while true do
		ped = GetPlayerPed(-1)
		if HasPedBeenDamagedByWeapon(ped, GetHashKey("WEAPON_PISTOL"), 0) or HasPedBeenDamagedByWeapon(ped, GetHashKey("WEAPON_ASSAULTRIFLE"), 0) then
			print("Bello")
			if GetEntityHealth(ped) <= 120 then
				ResurrectPed(ped)
				SetEntityHealth(ped, 120)
				falldown(GetPlayerPed(-1))
			end
			Wait(1)
			ClearEntityLastDamageEntity(ped)
		end
    	Wait(1)
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
		--print(PlayerId())
        local plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
        if IsEntityDead(GetPlayerPed(-1)) then 
			local d = GetPedCauseOfDeath(GetPlayerPed(-1))
			print(tostring(d))
			if checkArray(Bullet, d) then
				print("Dead")
				Wait(1)
				--Make player dont die
				local playerPed = PlayerPedId()
				local coords = GetEntityCoords(playerPed)
				TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)
				
				local formattedCoords = {
					x = ESX.Math.Round(coords.x, 1),
					y = ESX.Math.Round(coords.y, 1),
					z = ESX.Math.Round(coords.z, 1)
				}
				StopScreenEffect('DeathFailOut')
				RespawnPed(playerPed, formattedCoords, 0.0)
				--
				SetEntityHealth(GetPlayerPed(-1), 120)
				falldown(GetPlayerPed(-1))
			end
        end
    end
end)

RegisterCommand('teststun', function(source, args)
	ragdollgodmode = true
	--SetEntityInvincible(GetPlayerPed(-1), true)
	SetEntityProofs(GetPlayerPed(-1), true, false, false, false, false, false, false, false)
	SetPedToRagdoll(GetPlayerPed(-1), 5000, 5000, 0, 0, 0, 0)
	Citizen.Wait(5000)
	--SetEntityInvincible(GetPlayerPed(-1), false)
	SetEntityProofs(GetPlayerPed(-1), false, false, false, false, false, false, false, false)
	ragdollgodmode = false
end, false)
