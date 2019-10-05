--[[--
 * @Description: 开房主界面逻辑处理
 * @Author:      
 * @FileName:    openroom_main_ui.lua
 * @DateTime:    2017-07-13 19:11:00
 ]]

require "logic/hall_sys/openroom/room_data"

openroom_main_ui = ui_base.New()
local this = openroom_main_ui

local toggleTbl = {}

RoomType = {
	Normal = 0,
	ClubRoom = 1
}

function this.Show(data)
	log(data)
	this.roomType = RoomType.Normal
	if data ~= nil then
		this.roomType = data
	end
	room_data.InitData()
	log("加载创建房间界面")
	if this.gameObject==nil then
		this.gameObject=newNormalUI("Prefabs/UI/OpenRoom/openroom_main_ui")
	else
		GameObject.Destroy(this.gameObject)
        this.gameObject=nil
	end
end


function this.Start()	
	toggleTbl.fzmjToggle = subComponentGet(this.transform, "panel_openroom/Panel_Left/majiangToggle", "UIToggle")
	toggleTbl.shisanshuiToggle = subComponentGet(this.transform, "panel_openroom/Panel_Left/13shuiToggle", "UIToggle")

	local btnCreate = child(this.transform, "panel_openroom/CreateBtn")
	if btnCreate ~= nil then
		addClickCallbackSelf(btnCreate.gameObject, this.OnBtnCreateClick, this)
	end

    local btn_close=child(this.transform,"panel_openroom/btn_close")
    if btn_close~=nil then
        addClickCallbackSelf(btn_close.gameObject,this.Hide,this)
    end	

    this.Init()
end

function this.Init()
    local toggle=child(this.transform,"panel_openroom/Panel_Right/fuzhoumj/toggletype_01/toggle_grid/toggle_01")
    componentGet(toggle,"UIToggle"):Set(true)
end


function this.Hide()
	if this.gameObject == nil then
		return
	else
		GameObject.Destroy(this.gameObject)
		this.gameObject = nil
	end
end


--///////////////////////////////外部获取接口start//////////////////////////////

function this.GetFzmjToggle()
	return toggleTbl.fzmjToggle
end

function this.GetShiSanShuiToggle()
	return toggleTbl.shisanshuiToggle
end
--///////////////////////////////外部获取接口end////////////////////////////////




--///////////////////////////////////点击事件处理start////////////////////////////////////////////

function this.OnBtnCreateClick(obj)
	waiting_ui.Show()

	--join_room_ctrl.QueryState()
	this.Hide()	
	if toggleTbl.fzmjToggle.value then
    	local param = fuzhoumj_room_ui.GetUserSelectData()
    	param.gid = 18		
        room_data.RequestFzMJCreateRoom(param)
    elseif toggleTbl.shisanshuiToggle.value then
		local config_rule ={}
		local gameDataInfo = room_data.GetSssRoomDataInfo()
		log(gameDataInfo)
		config_rule["rounds"] = gameDataInfo.play_num
		config_rule["pnum"] = gameDataInfo.people_num
		config_rule["nChooseCardTypeTimeOut"] = gameDataInfo.nChooseCardTypeTimeOut
		config_rule["costtype"] = gameDataInfo.costtype
		config_rule["nReadyTimeOut"] = gameDataInfo.nReadyTimeOut
		config_rule["leadership"] = gameDataInfo.isZhuang
		config_rule["joker"] = gameDataInfo.add_ghost
--		config_rule["addColor"] = gameDataInfo.add_card--加色不要了
		config_rule["buyhorse"] = gameDataInfo.nBuyCode
		config_rule["maxfan"] = gameDataInfo.max_multiple
		log("people num : "..gameDataInfo.people_num)
		
		log("addghost : "..tostring(gameDataInfo.add_ghost))
		PlayerPrefs.SetString("rounds", tostring(gameDataInfo.play_num))
		PlayerPrefs.SetString("pnum", tostring(gameDataInfo.people_num))
		PlayerPrefs.SetString("nChooseCardTypeTimeOut", tostring(gameDataInfo.nChooseCardTypeTimeOut))
		PlayerPrefs.SetString("costtype", tostring(gameDataInfo.costtype))
		PlayerPrefs.SetString("nReadyTimeOut", tostring(gameDataInfo.nReadyTimeOut))
		--PlayerPrefs.SetString("leadership", tostring(gameDataInfo.isZhuang))
		PlayerPrefs.SetString("joker", tostring(gameDataInfo.add_ghost))
		PlayerPrefs.SetString("buyhorse", tostring(gameDataInfo.nBuyCode))
--		PlayerPrefs.SetString("maxfan", gameDataInfo.max_multiple);
		config_rule.gid = ENUM_GAME_TYPE.TYPE_SHISHANSHUI
		room_data.GetSssRoomDataInfo().gid = ENUM_GAME_TYPE.TYPE_SHISHANSHUI
		if this.roomType == RoomType.Normal then
			room_data.RequestSssCreateRoom(config_rule, "GameSAR.createRoom")
		elseif this.roomType == RoomType.ClubRoom then
			config_rule["cid"] = ClubModel.currentClubInfo.cid
			config_rule["ishide"] = false
			config_rule["autocreate"] = false
			room_data.RequestSssCreateRoom(config_rule, "GameClub.CreateClubRoom")
		end
    end

    --测试使用
	--[[
	local input = componentGet(child(this.transform, "Input/Label"), "UILabel")
	if input ~= nil then
		log("roomNo: "..tostring(input.text))
		local roomNo = tonumber(input.text)
		if roomNo ~= nil then
			log("roomNo: "..tostring(roomNo))
			open_room_data.RequestGetInRoom(gameDataInfo.gid, roomNo)
			return
		end
	end
	--]]
end
--///////////////////////////////////点击事件处理end//////////////////////////////////////////////