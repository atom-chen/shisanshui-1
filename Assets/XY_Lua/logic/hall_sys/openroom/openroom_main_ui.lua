--[[--
 * @Description: 开房主界面逻辑处理
 * @Author:      shine
 * @FileName:    openroom_main_ui.lua
 * @DateTime:    2017-07-13 19:11:00
 ]]

require "logic/hall_sys/openroom/room_data"

openroom_main_ui = ui_base.New()
local this = openroom_main_ui

local toggleTbl = {}

function this.Show()
	room_data.InitData()
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
		config_rule["rounds"] = gameDataInfo.play_num
		config_rule["pnum"] = gameDataInfo.people_num
		
		config_rule["leadership"] = gameDataInfo.isZhuang
		config_rule["joker"] = gameDataInfo.add_ghost
		config_rule["addColor"] = gameDataInfo.add_card
		config_rule["buyhorse"] = gameDataInfo.isChip
		config_rule["maxfan"] = gameDataInfo.max_multiple
		print("people num : "..gameDataInfo.people_num)
		
		print("addghost : "..gameDataInfo.add_ghost)
		config_rule.gid = 22
		room_data.GetSssRoomDataInfo().gid = 22
		room_data.RequestSssCreateRoom(config_rule)
    end

    --测试使用
	--[[
	local input = componentGet(child(this.transform, "Input/Label"), "UILabel")
	if input ~= nil then
		print("roomNo: "..tostring(input.text))
		local roomNo = tonumber(input.text)
		if roomNo ~= nil then
			print("roomNo: "..tostring(roomNo))
			open_room_data.RequestGetInRoom(gameDataInfo.gid, roomNo)
			return
		end
	end
	--]]
end
--///////////////////////////////////点击事件处理end//////////////////////////////////////////////