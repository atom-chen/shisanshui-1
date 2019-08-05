--[[--
 * @Description: 处理本地座位号转换，校验
 * @Author:      --
 * @FileName:    player_seat_mgr.lua
 * @DateTime:    2017-06-19 16:13:09
 ]]

require "logic/mahjong_sys/_model/roomdata_center"
player_seat_mgr = {}
local this = player_seat_mgr

local myLocalSeat = nil
local myServerSeatId = nil 

function this.Init()
	
end

function this.SetMyLocalSeat(localSeat)
	myLocalSeat = localSeat
end

function this.GetMyLocalSeat()
	return myLocalSeat or 1
end

function this.SetMyServerSeatId(serverSeatId)
	myServerSeatId = serverSeatId
end

function this.GetMyServerSeatId()
	return myServerSeatId
end

function this.GetLocalSeatByStr(seatStr)
	local localSeat 
	if seatStr == "p1" then
		localSeat = this.GetLocalSeat(1)
	elseif seatStr == "p2" then
		localSeat = this.GetLocalSeat(2)
	elseif seatStr == "p3" then
		localSeat = this.GetLocalSeat(3)
	elseif seatStr == "p4" then
		localSeat = this.GetLocalSeat(4)
	elseif seatStr == "p5" then
		localSeat = this.GetLocalSeat(5)
	elseif seatStr == "p6" then
		localSeat = this.GetLocalSeat(6)
	end
	return localSeat
end

function this.GetLocalSeat(seatId)
	local svrSeatId = this.GetMyServerSeatId()
	if not svrSeatId or svrSeatId == -1 then
		return seatId
	end
	local myLocalSeat = this.GetMyLocalSeat()
	local maxCount = roomdata_center.GetCurPlayerMaxCount()
	seatId = seatId or -1
	local localSeat = ((seatId - svrSeatId) % maxCount + myLocalSeat) % maxCount
	if localSeat == 0 then
		localSeat = maxCount
	end
	return localSeat
end

function this.GetServerSeat(localSeat)
	local svrSeatId = this.GetMyServerSeatId()
	if not svrSeatId or svrSeatId == -1 then
		return localSeat
	end
	local myLocalSeat = this.GetMyLocalSeat()
	local maxCount = roomdata_center.GetCurPlayerMaxCount()
	localSeat = localSeat or -1
	local seatId = (localSeat - myLocalSeat + svrSeatId ) % maxCount
	if seatId == 0 then
		seatId = maxCount
	end
	return seatId
end

function this.IsSeatLeagl(localSeat)
	if type(localSeat) ~= "number" then
		return false
	end
	local maxCount = roomdata_center.GetCurPlayerMaxCount()
	if localSeat >=1 and localSeat <= maxCount then
		return true
	end
	return false
end

function this.GetNexSeat(localSeat)
	local curSeat = localSeat + 1
	local maxCount = roomdata_center.GetCurPlayerMaxCount()
	if curSeat > maxCount then
		return 1
	end
	return curSeat
end

function this.GetPreviousSeat(localSeat)
	local curSeat = localSeat - 1
	if curSeat <=0 then
		return roomdata_center.GetCurPlayerMaxCount()
	end
	return curSeat
end

function this.IsMySelf(uId)
	if uId == uid then
		return true
	end
	return false
end
