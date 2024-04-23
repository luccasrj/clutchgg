function setBarbershop(ped,status)
    local myClothes = { status[1] or 0, status[2] or 0, status[3] or 0, status[4] or 0, status[5] or 0, status[6] or 0, status[7] or 0, status[8] or 0, status[9] or 0, status[10] or 0, status[11] or 0, status[12] or 0, status[13] or 0, status[14] or 0, status[15] or 0, status[16] or 0, status[17] or 0, status[18] or 0, status[19] or 0, status[20] or 0, status[21] or 0, status[22] or 0, status[23] or 0, status[24] or 0, status[25] or 0, status[26] or 0, status[27] or 0, status[28] or 0, status[29] or 0, status[30] or 0, status[31] or 0, status[32] or 0, status[33] or 0, status[34] or 0, status[35] or 0, status[36] or 0, status[37] or 0, status[38] or 0, status[39] or 0, status[40] or 0, status[41] or 0 }
    local weightFace = myClothes[2] / 100 + 0.0
    local weightSkin = myClothes[4] / 100 + 0.0

	SetPedHeadBlendData(ped,myClothes[41],myClothes[1],0,myClothes[41],myClothes[1],0,weightFace,weightSkin,0.0,false)

	SetPedEyeColor(ped,myClothes[3])

	if myClothes[5] == 0 then
		SetPedHeadOverlay(ped,0,myClothes[5],0.0)
	else
		SetPedHeadOverlay(ped,0,myClothes[5],1.0)
	end

	SetPedHeadOverlay(ped,6,myClothes[6],1.0)

	if myClothes[7] == 0 then
		SetPedHeadOverlay(ped,9,myClothes[7],0.0)
	else
		SetPedHeadOverlay(ped,9,myClothes[7],1.0)
	end

	SetPedHeadOverlay(ped,3,myClothes[8],1.0)

	SetPedComponentVariation(ped,2,myClothes[9],0,1)
	SetPedHairColor(ped,myClothes[10],myClothes[11])

	SetPedHeadOverlay(ped,4,myClothes[12],myClothes[13] * 0.1)
	SetPedHeadOverlayColor(ped,4,1,myClothes[14],myClothes[14])

	SetPedHeadOverlay(ped,8,myClothes[15],myClothes[16] * 0.1)
	SetPedHeadOverlayColor(ped,8,1,myClothes[17],myClothes[17])

	SetPedHeadOverlay(ped,2,myClothes[18],myClothes[19] * 0.1)
	SetPedHeadOverlayColor(ped,2,1,myClothes[20],myClothes[20])

	SetPedHeadOverlay(ped,1,myClothes[21],myClothes[22] * 0.1)
	SetPedHeadOverlayColor(ped,1,1,myClothes[23],myClothes[23])

	SetPedHeadOverlay(ped,5,myClothes[24],myClothes[25] * 0.1)
	SetPedHeadOverlayColor(ped,5,1,myClothes[26],myClothes[26])

	SetPedFaceFeature(ped,0,myClothes[27] * 0.1)
	SetPedFaceFeature(ped,1,myClothes[28] * 0.1)
	SetPedFaceFeature(ped,4,myClothes[29] * 0.1)
	SetPedFaceFeature(ped,6,myClothes[30] * 0.1)
	SetPedFaceFeature(ped,8,myClothes[31] * 0.1)
	SetPedFaceFeature(ped,9,myClothes[32] * 0.1)
	SetPedFaceFeature(ped,10,myClothes[33] * 0.1)
	SetPedFaceFeature(ped,12,myClothes[34] * 0.1)
	SetPedFaceFeature(ped,13,myClothes[35] * 0.1)
	SetPedFaceFeature(ped,14,myClothes[36] * 0.1)
	SetPedFaceFeature(ped,15,myClothes[37] * 0.1)
	SetPedFaceFeature(ped,16,myClothes[38] * 0.1)
	SetPedFaceFeature(ped,17,myClothes[39] * 0.1)
	SetPedFaceFeature(ped,19,myClothes[40] * 0.1)
end

function setClothing(ped,data)
	print(data)
	if not data then
		return
	end
	
	SetPedComponentVariation(ped,4,data["pants"]["item"],data["pants"]["texture"],1)
	SetPedComponentVariation(ped,3,data["arms"]["item"],data["arms"]["texture"],1)
	SetPedComponentVariation(ped,5,data["backpack"]["item"],data["backpack"]["texture"],1)
	SetPedComponentVariation(ped,8,data["tshirt"]["item"],data["tshirt"]["texture"],1)
	SetPedComponentVariation(ped,9,data["vest"]["item"],data["vest"]["texture"],1)
	SetPedComponentVariation(ped,11,data["torso"]["item"],data["torso"]["texture"],1)
	SetPedComponentVariation(ped,6,data["shoes"]["item"],data["shoes"]["texture"],1)
	SetPedComponentVariation(ped,1,data["mask"]["item"],data["mask"]["texture"],1)
	SetPedComponentVariation(ped,10,data["decals"]["item"],data["decals"]["texture"],1)
	SetPedComponentVariation(ped,7,data["accessory"]["item"],data["accessory"]["texture"],1)

	if data["hat"]["item"] ~= -1 and data["hat"]["item"] ~= 0 then
		SetPedPropIndex(ped,0,data["hat"]["item"],data["hat"]["texture"],1)
	else
		ClearPedProp(ped,0)
	end

	if data["glass"]["item"] ~= -1 and data["glass"]["item"] ~= 0 then
		SetPedPropIndex(ped,1,data["glass"]["item"],data["glass"]["texture"],1)
	else
		ClearPedProp(ped,1)
	end

	if data["ear"]["item"] ~= -1 and data["ear"]["item"] ~= 0 then
		SetPedPropIndex(ped,2,data["ear"]["item"],data["ear"]["texture"],1)
	else
		ClearPedProp(ped,2)
	end

	if data["watch"]["item"] ~= -1 and data["watch"]["item"] ~= 0 then
		SetPedPropIndex(ped,6,data["watch"]["item"],data["watch"]["texture"],1)
	else
		ClearPedProp(ped,6)
	end

	if data["bracelet"]["item"] ~= -1 and data["bracelet"]["item"] ~= 0 then
		SetPedPropIndex(ped,7,data["bracelet"]["item"],data["bracelet"]["texture"],1)
	else
		ClearPedProp(ped,7)
	end
end