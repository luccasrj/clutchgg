Citizen.CreateThread(function()
	while true do
		N_0xf4f2c0d4ee209e20()
		N_0x9e4cfff989258472()
		SetPlayerTargetingMode(2)
		DistantCopCarSirens(false)

		SetCreateRandomCops(false)
		CancelCurrentPoliceReport()
		SetCreateRandomCopsOnScenarios(false)
		SetCreateRandomCopsNotOnScenarios(false)

		Citizen.Wait(1000)
	end
end)


Citizen.CreateThread(function()
	while true do
		if IsPedArmed(PlayerPedId(),6) then
			DisableControlAction(1,140,true)
			DisableControlAction(1,141,true)
			DisableControlAction(1,142,true)
		end
		
		AddTextEntry("FE_THDR_GTAO","CLUTCH")

		HideHudComponentThisFrame(2)
		HideHudComponentThisFrame(3)
		HideHudComponentThisFrame(4)
		HideHudComponentThisFrame(5)
		HideHudComponentThisFrame(6)
		HideHudComponentThisFrame(7)
		HideHudComponentThisFrame(8)
		HideHudComponentThisFrame(9)
		HideHudComponentThisFrame(10)
		HideHudComponentThisFrame(11)
		HideHudComponentThisFrame(12)
		HideHudComponentThisFrame(13)
		HideHudComponentThisFrame(15)
		HideHudComponentThisFrame(17)
		HideHudComponentThisFrame(18)
		HideHudComponentThisFrame(20)
		HideHudComponentThisFrame(21)
		HideHudComponentThisFrame(22)
		RemoveAllPickupsOfType(0x550447A9)
		RemoveAllPickupsOfType(0xF92F486C)
		RemoveAllPickupsOfType(0x602941D0)
		RemoveAllPickupsOfType(0xE013E01C)
		RemoveAllPickupsOfType(0x881AB0A8)
		RemoveAllPickupsOfType(0xA421A532)
		RemoveAllPickupsOfType(0x5C517D97)
		RemoveAllPickupsOfType(0xDE58E0B3)
		RemoveAllPickupsOfType(0xF25A01B9)
		RemoveAllPickupsOfType(0xF99E15D0)
		RemoveAllPickupsOfType(0x20796A82)
		RemoveAllPickupsOfType(0xE4BD2FC6)
		RemoveAllPickupsOfType(0x84837FD7)
		RemoveAllPickupsOfType(0x77F3F2DD)
		RemoveAllPickupsOfType(0x116FC4E6)
		RemoveAllPickupsOfType(0xC02CF125)
		RemoveAllPickupsOfType(0x4BFB42D1)
		RemoveAllPickupsOfType(0xE33D8630)
		RemoveAllPickupsOfType(0x2C014CA6)
		RemoveAllPickupsOfType(0xE175C698)
		RemoveAllPickupsOfType(0x1CD2CF66)
		RemoveAllPickupsOfType(0x8F707C18)
		RemoveAllPickupsOfType(0xCE6FDD6B)
		RemoveAllPickupsOfType(0x20893292)
		RemoveAllPickupsOfType(0x14568F28)
		RemoveAllPickupsOfType(0x711D02A4)
		RemoveAllPickupsOfType(0x1E9A99F8)
		RemoveAllPickupsOfType(0xDE78F17E)
		RemoveAllPickupsOfType(0xFE18F3AF)
		RemoveAllPickupsOfType(0x5DE0AD3E)
		RemoveAllPickupsOfType(0x6773257D)
		RemoveAllPickupsOfType(0xEE0E26F3)
		RemoveAllPickupsOfType(0xA7EA40CE)
		RemoveAllPickupsOfType(0xA04E8B0D)
		RemoveAllPickupsOfType(0x6E717A95)
		RemoveAllPickupsOfType(0x90EFDF3B)
		RemoveAllPickupsOfType(0x4B5259BE)
		RemoveAllPickupsOfType(0xC3CD8B31)
		RemoveAllPickupsOfType(0x4C35269)
		RemoveAllPickupsOfType(0x94FA0B5E)
		RemoveAllPickupsOfType(0x31EA45C9)
		RemoveAllPickupsOfType(0x80AB931C)
		RemoveAllPickupsOfType(0xE7CF07CC)
		RemoveAllPickupsOfType(0x4316CC09)
		RemoveAllPickupsOfType(0xA5B8CAA9)
		RemoveAllPickupsOfType(0x41D2CF56)
		RemoveAllPickupsOfType(0x4F92184)
		RemoveAllPickupsOfType(0x98D79EF)
		RemoveAllPickupsOfType(0xFDEE8368)
		RemoveAllPickupsOfType(0x65948212)
		RemoveAllPickupsOfType(0xCC8B3905)
		RemoveAllPickupsOfType(0x68605A36)
		RemoveAllPickupsOfType(0xD0AACEF7)
		RemoveAllPickupsOfType(0xA717F898)
		RemoveAllPickupsOfType(0xB86AEE5B)
		RemoveAllPickupsOfType(0x84D676D4)
		RemoveAllPickupsOfType(0xA54AE7B7)
		RemoveAllPickupsOfType(0xD3A39366)
		RemoveAllPickupsOfType(0x2E071B5A)
		RemoveAllPickupsOfType(0xCC7CCD1B)
		RemoveAllPickupsOfType(0x65A7D8E9)
		RemoveAllPickupsOfType(0x2C804FE3)
		RemoveAllPickupsOfType(0xB2B5325E)
		RemoveAllPickupsOfType(0x3B662889)
		RemoveAllPickupsOfType(0xF33C83B0)
		RemoveAllPickupsOfType(0x8187206F)
		RemoveAllPickupsOfType(0x9299C95B)
		RemoveAllPickupsOfType(0x741C684A)
		RemoveAllPickupsOfType(0xBCC5C1F2)
		RemoveAllPickupsOfType(0x81EE601E)
		RemoveAllPickupsOfType(0x977C0F2)
		RemoveAllPickupsOfType(0xFA51ABF5)
		RemoveAllPickupsOfType(0x815D66E8)
		RemoveAllPickupsOfType(0x8C0FCB13)
		RemoveAllPickupsOfType(0x6E4E65C2)
		RemoveAllPickupsOfType(0xDF711959)
		RemoveAllPickupsOfType(0xBDD874BC)
		RemoveAllPickupsOfType(0xB2930A14)
		RemoveAllPickupsOfType(0xA91FDC8B)
		RemoveAllPickupsOfType(0x789576E2)
		RemoveAllPickupsOfType(0x8967B4F3)
		RemoveAllPickupsOfType(0xF0EA0639)
		RemoveAllPickupsOfType(0xFE73AB5)
		RemoveAllPickupsOfType(0x872DC888)
		RemoveAllPickupsOfType(0xBFEE6C3B)
		RemoveAllPickupsOfType(0xF9E2DF1F)
		RemoveAllPickupsOfType(0x3B0F70A7)
		RemoveAllPickupsOfType(0x22B15640)
		RemoveAllPickupsOfType(0xBD4DE242)
		RemoveAllPickupsOfType(0xBDB6FFA5)
		RemoveAllPickupsOfType(0x88EAACA7)
		RemoveAllPickupsOfType(0x5E0683A1)
		RemoveAllPickupsOfType(0x2E764125)
		RemoveAllPickupsOfType(0x5307A4EC)
		RemoveAllPickupsOfType(0x295691A9)
		RemoveAllPickupsOfType(0x4E301CD0)
		RemoveAllPickupsOfType(0x9CF13918)
		RemoveAllPickupsOfType(0xBED46EC5)
		RemoveAllPickupsOfType(0x693583AD)
		RemoveAllPickupsOfType(0xFF0A8297)
		RemoveAllPickupsOfType(0xC01EB678)
		RemoveAllPickupsOfType(0x278D8734)
		RemoveAllPickupsOfType(0xFD9CAEDE)
		RemoveAllPickupsOfType(0xD8257ABF)
		RemoveAllPickupsOfType(0xF5C5DADC)
		RemoveAllPickupsOfType(0x8ADDEC75)
		RemoveAllPickupsOfType(0x79284A9)
		RemoveAllPickupsOfType(0x9F55D149)
		RemoveAllPickupsOfType(0x85CAA9B1)
		RemoveAllPickupsOfType(0x1D9588D3)
		RemoveAllPickupsOfType(0x2F36B434)
		RemoveAllPickupsOfType(0xD3722A5B)
		RemoveAllPickupsOfType(0x2DD30479)
		RemoveAllPickupsOfType(0x763F7121)
		RemoveAllPickupsOfType(0x5EA16D74)
		RemoveAllPickupsOfType(0xC69DE3FF)
		RemoveAllPickupsOfType(0xAF692CA9)
		RemoveAllPickupsOfType(0xF9AFB48F)
		RemoveAllPickupsOfType(0x499A096A)
		RemoveAllPickupsOfType(0x6C5B941A)
		RemoveAllPickupsOfType(0x93EBB26)
		RemoveAllPickupsOfType(0x624F7213)
		RemoveAllPickupsOfType(0xA9355DCD)
		RemoveAllPickupsOfType(0x5DB6C18A)
		RemoveAllPickupsOfType(0xE46E11B4)
		RemoveAllPickupsOfType(0x614BFCAC)
		RemoveAllPickupsOfType(0x6D60976C)
		RemoveAllPickupsOfType(0x4D36C349)
		RemoveAllPickupsOfType(0x96B412A3)
		RemoveAllPickupsOfType(0x3A4C2AD2)
		RemoveAllPickupsOfType(0xEF2B7390)
		RemoveAllPickupsOfType(0x1CD604C7)
		RemoveAllPickupsOfType(0xFE2A352C)
		RemoveAllPickupsOfType(0xC5B72713)
		RemoveAllPickupsOfType(0x3DE942BD)
		RemoveAllPickupsOfType(0x968339D)
		RemoveAllPickupsOfType(0x5A26FE0)
		RemoveAllPickupsOfType(0x7C119D58)
		RemoveAllPickupsOfType(0xCC90A373)
		RemoveAllPickupsOfType(0xFD16169E)
		RemoveAllPickupsOfType(0xDDE4181A)
		RemoveAllPickupsOfType(0xEBF89D5F)
		RemoveAllPickupsOfType(0xE5121369)

		SetMaxWantedLevel(0)
		DisableVehicleDistantlights(true)
		ClearPlayerWantedLevel(PlayerId())
		DisablePlayerVehicleRewards(PlayerId())
		SetEveryoneIgnorePlayer(PlayerPedId(),true)
		SetPlayerCanBeHassledByGangs(PlayerPedId(),false)
		SetIgnoreLowPriorityShockingEvents(PlayerPedId(),true)
		ReplaceHudColour(116, 15)

		SetPedDensityMultiplierThisFrame(0.0)
		SetScenarioPedDensityMultiplierThisFrame(0.0,0.0)
		SetParkedVehicleDensityMultiplierThisFrame(0.0)
		SetRandomVehicleDensityMultiplierThisFrame(0.0)
		SetVehicleDensityMultiplierThisFrame(0.0)
		SetGarbageTrucks(false)
		SetRandomBoats(false)

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(PlayerPedId())
		local idle = 1000
		if IsPedInAnyVehicle(ped) then
			local speed = GetEntitySpeed(vehicle)*2.236936
			if GetPedInVehicleSeat(vehicle,-1) == ped then
				idle = 5
				if speed <= 100.0 then
					if IsControlPressed(1,21) then
						SetVehicleReduceGrip(vehicle,true)
					else
						SetVehicleReduceGrip(vehicle,false)
					end
				end
			end
		end
		Citizen.Wait(idle)
	end
end)