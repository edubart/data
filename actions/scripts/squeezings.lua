--gear storage
local STORAGE_VALUE_LOCATION = 12345
--shovel
local TILE_SAND 		= 	9059
local ITEM_SCARAB_COIN 		= 	2159
local TUMB_ENTRANCE		= 	1345
local SCARAB_TILE		=	101
local MUD_HOLE		=	489
local SCARAB_COIN_TILE		= 	102
local duration = 5 * 60000 -- 5 minutes
--pick
local MUD_HOLE2		=	392
local FRAGILE_ICE	=	7200
local ICE_FISHHOLE	=	7236


local function __doTransformHole__(parameters)
	local thing = getTileItemById(parameters.pos, MUD_HOLE)
	local newItem = doTransformItem(thing.uid, parameters.oldType)
	if parameters.oldaid ~= 0 and newItem then
		doSetItemActionId(thing.uid, parameters.oldaid)
	end
end

local function __doTransformHole__2(parameters)
	local thing = getTileItemById(parameters.pos, MUD_HOLE2)
	local newItem = doTransformItem(thing.uid, parameters.oldType)
	if parameters.oldAid ~= 0 and newItem then
		doSetItemActionId(thing.uid, parameters.oldAid)
	end
end

function onUse(cid, item, frompos, item2, topos)
	--Jammed
	local tim = getPlayerStorageValue(cid, STORAGE_VALUE_LOCATION)
	if tim ~= -1 and os.time() < tim then
		doPlayerSay(cid, "The tool jammed. Please wait " .. -(os.time()-tim) .. " seconds before using it again.", TALKTYPE_ORANGE)
		return true
	end
	if math.random(1, 10) == 1 then
		setPlayerStorageValue(cid, STORAGE_VALUE_LOCATION, os.time()+60)
		doPlayerSay(cid, "The tool jammed. Please wait 60 seconds before using it again.", TALKTYPE_ORANGE)
		return true
	end

	--Rope
	if useRope(cid, item, frompos, item2, topos) then
		return true
	end
	
	--Shovel
	if (isInArray(CLOSED_HOLE, item2.itemid) ) then
		if item2.itemid == 8579 then
			doTransformItem(item2.uid, 8585)
		else
			doTransformItem(item2.uid, item2.itemid + 1)
		end
		if item2.actionid ~= 0 then
			doSetItemActionId(item2.uid, item2.actionid)
		end
		doDecayItem(item2.uid)
		return true
	elseif (item2.itemid == TILE_SAND) then
		if (item2.actionid == TUMB_ENTRANCE) then
			if (math.random(1, 5) == 1) then
				doTransformItem(item2.uid, 489)
				if item2.actionid ~= 0 then
					doSetItemActionId(item2.uid, item2.actionid)
				end
				addEvent(__doTransformHole__, duration, {oldType = item2.itemid, pos = topos, oldaid = item2.actionid})
			end
		elseif (item2.actionid == SCARAB_TILE) then
			if (math.random(1, 20) == 1) then
				doSummonCreature("Scarab", topos)
				doSetItemActionId(item2.uid, SCARAB_TILE + 2)
			end
		elseif (item2.actionid == SCARAB_COIN_TILE) then
			if (math.random(1, 20) == 1) then
				doCreateItem(ITEM_SCARAB_COIN, topos)
				doSetItemActionId(item2.uid, SCARAB_COIN_TILE + 2)
			end
		elseif (item2.actionid == SCARAB_TILE + 2) then
			if (math.random(1, 40) == 1) then
				doSetItemActionId(item2.uid, SCARAB_TILE)
			end
		elseif (item2.actionid == SCARAB_COIN_TILE + 2) then
			if (math.random(1, 40) == 1) then
				doSetItemActionId(item2.uid, SCARAB_COIN_TILE)
			end
		end
		doSendMagicEffect(topos, CONST_ME_POFF)
		doDecayItem(item2.uid)
		return true
	end

	--Pick
	local itemGround = getThingFromPos({x = topos.x, y = topos.y, z = topos.z + 1, stackpos = STACKPOS_GROUND})
	if(isInArray(ROPE_SPOT, itemGround.itemid) ) then
		doTransformItem(item2.uid, MUD_HOLE2)
		doSendMagicEffect(topos, CONST_ME_POFF)
		if item2.actionid ~= 0 then
			doSetItemActionId(item2.uid, item2.actionid)
		end
		addEvent(__doTransformHole__2, duration, {oldType = item2.itemid, pos = topos, oldaid = item2.actionid})
		return true
	end
	if(item2.itemid == FRAGILE_ICE) then
		doTransformItem(item2.uid, ICE_FISHHOLE)
		if item2.actionid ~= 0 then
			doSetItemActionId(item2.uid, item2.actionid)
		end
		doSendMagicEffect(topos, CONST_ME_BLOCKHIT)
		return true
	end
	
	--Machete
	if (isInArray(JUNGLE_GRASS_REMOVE, item2.itemid) ) then
		doRemoveItem(item2.uid)
		return true
	elseif (isInArray(JUNGLE_GRASS_TRANSFORM, item2.itemid) ) then
		doTransformItem(item2.uid, item2.itemid - 1)
		if item2.actionid ~= 0 then
			doSetItemActionId(item2.uid, item2.actionid)
		end
		doDecayItem(item2.uid)
		return true
	elseif (isInArray(SPIDER_WEB, item2.itemid) ) then
		doTransformItem(item2.uid, item2.itemid +6)
		if item2.actionid ~= 0 then
			doSetItemActionId(item2.uid, item2.actionid)
		end
		doDecayItem(item2.uid)
		return true
	end
	return false
end

