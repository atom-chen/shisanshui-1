--[[--
 * @Description: 房间数据
 * @Author:      zhy, shine走读代码
 * @FileName:    room_data.lua
 * @DateTime:    2017-06-30
 ]]

require "logic/network/shisanshui_request_interface"
require "logic/network/messagedefine"
require "logic/shisangshui_sys/card_data_manage"

require "logic/common/global_define"

room_data = {}
local this = room_data 

--局数
PayType = {
	[1] = 0,
	[2] = 1, 
	[3] = 2,
	[4] = 3
}

--局数
PlayNum = {
	[1] = 10,
	[2] = 20, 
	[3] = 30,
	[4] = 40
}
--局数
placeCardTime = {
	[1] = 60,
	[2] = 120, 
	[3] = 180
}
--人数
PeopleNum={
	[1] = 2,
	[2] = 3,
	[3] = 4,
	[4] = 5,
	[5] = 6
}
--加色
AddCard={
	[1] = 0,
	[2] = 1,
	[3] = 2
}
--买码
AddChip={
	[1] = 0,
	[2] = 1
}
--闲家最大倍数
MaxMultiple={
	[1] = 1,
	[2] = 2,
	[3] = 3,
	[4] = 4,
	[5] = 5
}

BuyHorse = {
	[1] = 0,
	[2] = 5,
	[3] = 10,
	[4] = 14,
}

--十三水房间配置数据
local sssroomDataInfo = 
{
	--加一色做庄
	isZhuang=false,
	--买码
	nBuyCode=false,
	--总局数
	play_num = PlayNum[1],
	--当前局
	cur_playNum = 8,
	-- 人数
	people_num = PeopleNum[3],
	-- 加色
	add_card= AddCard[1],
	-- 大小鬼
	add_ghost = AddChip[1],
	-- 闲家最大倍数
	max_multiple = MaxMultiple[1],
	gid =11,
	rno = nil,
	uid = nil,
	rid = nil,
	defaut = {},
	
	ready_time = 0,
	place_card_time = 0,--截止时间
	placeCardTime = 180,
	nChooseCardTypeTimeOut = 60,
	nReadyTimeOut = 30,
	costtype = PayType[2],
}


--福州麻将配置数据
local fzmjroomDataInfo = 
{
	rounds = 4,
	pnum = 4,
	settlement = "",
	halfpure = nil,   --半清一色
	allpure = nil,    --全清一色
	kindD = nil,      --可胡金龙
	DkingD = nil,     --单调剩金不平胡
	gid =18,
    selectindex={},
}


function this.InitData()
	log("room_data.InitData-------------------------------------2")
	--读取十三水配置数据
	this.ReadSssConfData()

	--读取福州麻将配置数据
	--this.ReadFzmjConfData()
end

--[[--
 * @Description: 读取十三水配置数据  
 ]]
function this.ReadSssConfData()
	local sss_path = Application.persistentDataPath.."/games/gamerule/PuXian_ShiSangShui_Rule.json"
	log(sss_path)
	--log("读取十三水配置数据:" + sss_path)
	--local str = FileReader.ReadFile(global_define.sss_path)
	local str = FileReader.ReadFile(sss_path)
	log(str)
 	local roomConfData = nil
 	if nil ~= str and "" ~= str then
		roomConfData = ParseJsonStr(str)
	end
	local tmp_table = nil
	roomConfData = nil
	if roomConfData ~= nil then
		for i,v in ipairs(roomConfData) do
			if	i == 1 then	
	 			tmp_table = v
				for a,b in ipairs(tmp_table)  do
					if b~=nil then
						sssroomDataInfo.play_num = b["exData"][1]
					end
				end
			else
				sssroomDataInfo.nBuyCode =false
				sssroomDataInfo.isZhuang =false
				sssroomDataInfo.add_card =0
				sssroomDataInfo.add_ghost =0
				sssroomDataInfo.max_multiple =1
				sssroomDataInfo.people_num = 4
			end
		end	
	end
end

--[[--
 * @Description: 读取福州麻将配置数据  
 ]]
function this.ReadFzmjConfData()
 	local str = FileReader.ReadFile(global_define.fzmj_path)
 	--log("str========================="..tostring(str))
 	local roomConfData = nil
 	if nil ~= str and "" ~= str then
		roomConfData = ParseJsonStr(str)
	end 
	local tmp_table = nil
	for i,v in ipairs(roomConfData) do		 
		if	i == 1 then	
 			tmp_table = v 
			for a,b in ipairs(tmp_table)  do
				if b~=nil then
					fzmjroomDataInfo.rounds = b["exData"][b["selectIndex"][1]]  
				end
			end
		elseif i == 2 then
			tmp_table = v
			for c,d in ipairs(tmp_table) do
				if c==1 and d~=nil then
					if d["exData"][1]~=nil then
						fzmjroomDataInfo.pnum = d["exData"][d["selectIndex"][1]] 
					end
				elseif c==2 and d~=nil then
					fzmjroomDataInfo.settlement = d["selectIndex"][1] 
				end
			end
		elseif i==3 then 
            tmp_table = v
            for e,f in ipairs(tmp_table) do
                fzmjroomDataInfo.selectindex["playtype"]=f["selectIndex"] 
            end 
            for k,v in  pairs(fzmjroomDataInfo.selectindex["playtype"]) do
                if v==1 then 
                    fzmjroomDataInfo.halfpure =1
                end
			    if v==2 then
                    fzmjroomDataInfo.allpure =1
                end
                if v==3 then
                     fzmjroomDataInfo.kindD =1
                end 
            end 
		end  
        
	end	
end

--////////////////////////////// /////////十三水数据处理start///////////////////////////////
--[[--
 * @Description: 十三水房间创建请求 
 ]]
function this.RequestSssCreateRoom(data)	
	http_request_interface.createRoom(data, this.OnGetSssCreateRoomData)
end

function this.OnGetSssCreateRoomData(code, m, str)	
	log("createroom from php: "..str)
	local s=string.gsub(str, "\\/", "/")
	log(s)
	local t=ParseJsonStr(s)
	
    if tonumber(t.ret) == 102 then
        local box= message_box.ShowGoldBox("钻石不足",nil,1,{function ()
                message_box:Close()
            end},{"fonts_01"})
    else
		log("dataTbl.data------------------------------"..str)
		card_data_manage.roomMasterUid = room_data.GetUid()   ------创建房间获取房主uid
		if t["data"]["rno"] ~= nil then
			join_room_ctrl.JoinRoomByRno(t["data"]["rno"])
		end	
	end
end

--在open_room_data根据房号查找房间后调用 PHP返回的数据，然后进入C++服务器请求
function this.OnGetJoinRoomData(data)
	log("OnGetJoinRoomData===="..tostring(data))
	if data == nil then
		return 
	end

	if data["ret"] == 100 then
		log( "房间号不存在，请重新输入")
		this.ResetLabeltext()
		this.ResetCurIndex()
	elseif data["ret"] == 101 then
		log( "房间已开局，请重新输入")
	else
		shisanshui_request_interface.EnterGameReq(data)
	end
end

function this.SetSssDataInfo(dataInfo)
	
end
--///////////////////////////////////////十三水数据处理end/////////////////////////////////


--///////////////////////////////////////福州麻将数据处理start///////////////////////////////
--[[--open_room_data Init=======
 * @Description: 福建麻将创建房间请求  
 ]]
function this.RequestFzMJCreateRoom(data)
	log("-------RequestOpenRoom------------- "..fzmjroomDataInfo.gid)
	data["gid"] =fzmjroomDataInfo.gid

	http_request_interface.createRoom(data, this.OnGetFzmjCreateRoomData)
end

function this.OnGetFzmjCreateRoomData(code, m, str)	
	local s=string.gsub(str,"\\/","/")
	local t=ParseJsonStr(s)

	if tonumber(t.ret) == 0 then
		if t["data"]["rno"] ~= nil then
			join_room_ctrl.JoinRoomByRno(t["data"]["rno"])
		end
	elseif tonumber(t.ret) == 102 then
		fast_tip.Show("房卡不足")
		waiting_ui.Hide()
	end
end

function this.SetFzmjDataInfo(dataInfo)
	-- body
end
--///////////////////////////////////////福州麻将数据处理end/////////////////////////////////


--////////////////////////////////////////外部调用接口start//////////////////////////////////
--[[--
 * @Description: 获取十三水房间配置数据  
 ]]
function this.GetSssRoomDataInfo()
	return sssroomDataInfo
end

function this.SetSssRoomDataInfo(data)
	sssroomDataInfo = data
end

function this.GetUid()
	return sssroomDataInfo.uid
end

function this.GetRid()
	return sssroomDataInfo.rid
end

function this.SetReadyTime(readyTime)
	sssroomDataInfo.ready_time = readyTime + Time.time
end

function this.SetPlaceCardTime(placeCardTime)
	sssroomDataInfo.place_card_time = placeCardTime
end

function this.SetPlaceCardSerTime(timeo)
	if timeo ~= nil then
		sssroomDataInfo.place_card_time = timeo + Time.time
	end
end

function this.GetReadyTime()
	if sssroomDataInfo.ready_time == nil then
		sssroomDataInfo.ready_time = 0
	end
	return sssroomDataInfo.ready_time
end

function this.GetPlaceCardTime()
	if sssroomDataInfo.place_card_time == nil then
		sssroomDataInfo.place_card_time = 0
	end
	return sssroomDataInfo.place_card_time
end

function this.GetShareTitle()
	local title = "开房打十三水，速来：房间号："..tostring(sssroomDataInfo.rno).."]"
	return title
end

function this.GetShareContent()
	
	local context = "有闲你就来，最有榕城特色的十三水，最真实的在线十三水！就在有闲棋牌"
	return context
end

--[[--
 * @Description: 获取福州麻将配置数据  
 ]]
function this.GetFzmjRoomDataInfo()
	return fzmjroomDataInfo
end

--////////////////////////////////////////外部调用接口end////////////////////////////////////

