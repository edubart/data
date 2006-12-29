function onUse(cid, item, frompos, item2, topos) 
	doorPos = {x = frompos.x, y = frompos.y, z = frompos.z, stackpos = 253}
	if isInArray(CLOSED_QUEST_DOOR, item.itemid) == 1 then
		if TEST_SERVER == "ON" then
			doPlayerSendTextMessage(cid, 22, "It is locked.")
			return 1
		end
		if getPlayerStorageValue(cid, item.uid) == item.actionid then
			doTransformItem(item.uid, item.itemid + 1)
			if getPlayerPosition(cid).x == doorPos.x and getPlayerPosition(cid).y == doorPos.y + 1 then
				doMoveCreature(cid, NORTH)
			elseif getPlayerPosition(cid).x == doorPos.x - 1 and getPlayerPosition(cid).y == doorPos.y then
				doMoveCreature(cid, EAST)
			elseif getPlayerPosition(cid).x == doorPos.x and getPlayerPosition(cid).y == doorPos.y - 1 then
				doMoveCreature(cid, SOUTH)
			elseif getPlayerPosition(cid).x == doorPos.x + 1 and getPlayerPosition(cid).y == doorPos.y then
				doMoveCreature(cid, WEST)
			elseif getPlayerPosition(cid).x == doorPos.x + 1 and getPlayerPosition(cid).y == doorPos.y - 1 then
				doMoveCreature(cid, SOUTHWEST)
			elseif getPlayerPosition(cid).x == doorPos.x - 1 and getPlayerPosition(cid).y == doorPos.y - 1 then
				doMoveCreature(cid, SOUTHEAST)
			elseif getPlayerPosition(cid).x == doorPos.x + 1 and getPlayerPosition(cid).y == doorPos.y + 1 then
				doMoveCreature(cid, NORTHWEST)
			elseif getPlayerPosition(cid).x == doorPos.x - 1 and getPlayerPosition(cid).y == doorPos.y + 1 then
				doMoveCreature(cid, NORTHEAST)
			end
		else
			doPlayerSendTextMessage(cid, 22, "The door seems to be sealed against unwanted intruders.")
		end
	elseif isInArray(OPENED_QUEST_DOOR, item.itemid) == 1 then
		if getThingfromPos(doorPos).itemid > 0 then
			doPlayerSendCancel(cid, "Sorry, not possible.")
			return 1
		end
	else
		return 0
    end
    return 1
end