--[[--
 * @Description: 房间玩家数据缓存中心
 * @Author:      ShushingWong
 * @FileName:    room_usersdata_center.lua
 * @DateTime:    2017-06-19 15:25:45
 ]]


require "logic/mahjong_sys/utils/player_seat_mgr"

room_usersdata_center = {}
local this = room_usersdata_center

local usersDataList = {}
local offset = 0 --offset = viewSeat - logicSeat

function this.AddUser( logicSeat ,userdata)
	usersDataList[logicSeat] = userdata
end

function this.SetOffset( logicSeat )
	offset = 1 - logicSeat
end

function this.GetLogicIDbySerID(chairID)
	local logicID = chairID + offset
	if logicID <= 0 then
		logicID = logicID + roomdata_center.MaxPlayer()
	end
	log("转换ID， 人数： "..tostring(roomdata_center.MaxPlayer()).." chiarID: "..chairID.." offset: "..tostring(offset))
	return logicID
end

function this.SetMyLogicSeat( serverSeat )
	player_seat_mgr.SetMyServerSeatId(serverSeat)
end

function this.GetUserByLogicSeat( logicSeat )
	return usersDataList[logicSeat]
end

function this.GetUserByUid(uid)
	for i, v in pairs(usersDataList) do
		if tonumber(v.name) == tonumber(uid) then
			return v
		end
	end
end

function this.GetLogicSeatByStr(seatStr)
	local LogicSeat  = string.sub(seatStr, 2)
	LogicSeat = tonumber(LogicSeat)
	--[[
	if seatStr == "p1" then
		LogicSeat = 1
	elseif seatStr == "p2" then
		LogicSeat = 2
	elseif seatStr == "p3" then
		LogicSeat = 3
	elseif seatStr == "p4" then
		LogicSeat = 4
	end]]
	return LogicSeat
end

function this.GetLogicSeatByStr(seatStr)
	local LogicSeat 
	if seatStr == "p1" then
		LogicSeat = 1
	elseif seatStr == "p2" then
		LogicSeat = 2
	elseif seatStr == "p3" then
		LogicSeat = 3
	elseif seatStr == "p4" then
		LogicSeat = 4
	elseif seatStr == "p5" then
		LogicSeat = 5
	elseif seatStr == "p6" then
		LogicSeat = 6
	end
	return LogicSeat
end

function this.GetUserByViewSeat( viewSeat )
	local logicSeat = viewSeat-offset

	if logicSeat>roomdata_center.MaxPlayer() then
		logicSeat = logicSeat-roomdata_center.MaxPlayer()
	elseif logicSeat<1 then
		logicSeat = logicSeat+roomdata_center.MaxPlayer()
	end

	return usersDataList[logicSeat], logicSeat
end

function this.GetLogicSeatNumByViewSeat(viewSeat)
	local logicSeatNum = player_seat_mgr.GetServerSeat(viewSeat)
	return logicSeatNum
end

function this.GetLogicSeatByViewSeat(viewSeat)

	local logicSeatNum = this.GetLogicSeatNumByViewSeat(viewSeat)
	local LogicSeat  = "p"..logicSeatNum
	--[[
	if logicSeatNum == 1 then
		LogicSeat = "p1"
	elseif logicSeatNum == 2 then
		LogicSeat = "p2"
	elseif logicSeatNum == 3 then
		LogicSeat = "p3"
	elseif logicSeatNum == 4 then
		LogicSeat = "p4"
	end]]
	return LogicSeat
end

function this.GetViewSeatByLogicSeat(logicSeat)	
	local viewSeat = player_seat_mgr.GetLocalSeatByStr(logicSeat)

	return viewSeat
end

function this.GetViewSeatByLogicSeatNum( logicSeat )
	local viewSeat = player_seat_mgr.GetLocalSeat(logicSeat)

	return viewSeat
end


function this.GetMyLogicSeat()

	local logicSeat = player_seat_mgr.GetMyServerSeatId()
	return logicSeat
end
