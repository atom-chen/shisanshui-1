--[[--
 * @Description: 创建房间组件
 * @Author:      zhy,  shine走读
 * @FileName:    shisangshui_room_ui.lua
 * @DateTime:    2017-05-19 14:33:25
 ]]
 
require "logic/hall_sys/hall_data"
require "logic/network/shisanshui_request_interface"
require "logic/common_ui/message_box"
require "logic/network/majong_request_protocol"
require "logic/hall_sys/openroom/room_data"
 
shisangshui_room_ui = ui_base.New()
local this = shisangshui_room_ui 
local transform

local gameDataInfo = {}  
local gray_Color=Color.New(71/255,71/255,71/255,1)
--加色按扭
local addCardTbl = {}
--人数按扭
local peopleTbl = {}
--买码按扭
local addChipTbl = {}
--最大倍数按扭
local multplyTbl = {}


function this.Awake()
   this.InitWidgets()   
end

--[[--
 * @Description: 逻辑入口  
 ]]
function this.Start()
	this.registerevent()
	gameDataInfo = room_data.GetSssRoomDataInfo()
	log("-----13水创建房间")
	this.TglSelect(0, addCardTbl)
--	multplyTbl[1].value = false
end

--[[--
 * @Description: 销毁  
 ]]
function this.OnDestroy()
end


function this.InitWidgets()
	this.PlayerNumDesLbl = child(this.transform, "PlayNum/PlayerNumDesLbl")
	if this.PlayerNumDesLbl~=nil then

	end
end

function this.OpenOther(backName) --进入牌桌准备
end

--注册事件
function this.registerevent()
	this.OpetionClickEvent()
end

----------------------------------按扭事件注册-------------------------------
function this.OpetionClickEvent()
	--opetion Event register
	local btn_4play = child(this.transform, "PlayNum/4")--金币添加 
    if btn_4play~=nil then
       addClickCallbackSelf(btn_4play.gameObject,this.Play4Click,this)
    end

	local btn_8Play = child(this.transform, "PlayNum/8")
	if btn_8Play ~= nil then
		addClickCallbackSelf(btn_8Play.gameObject, this.Play8Click, this)
	end
	
	local btn_16Play = child(this.transform, "PlayNum/16")
	if btn_16Play ~= nil then
		addClickCallbackSelf(btn_16Play.gameObject, this.Play16Click, this)
	end

	local btn_4people = child(this.transform, "PeopleNum/4")
	peopleTbl[4] = btn_4people.gameObject:GetComponent(typeof(UIToggle))
	if btn_4people ~= nil then
		addClickCallbackSelf(btn_4people.gameObject, this.People4Click, this)
	end

	local btn_5people = child(this.transform, "PeopleNum/5")
	peopleTbl[5] = btn_5people.gameObject:GetComponent(typeof(UIToggle))
	if btn_5people ~= nil then
		addClickCallbackSelf(btn_5people.gameObject, this.People5Click, this)
	end

	local btn_6people = child(this.transform, "PeopleNum/6")
	peopleTbl[6] = btn_6people.gameObject:GetComponent(typeof(UIToggle))
	if btn_6people ~= nil then
		addClickCallbackSelf(btn_6people.gameObject, function() this.People6Click(gameobject) end, this)
	end

	local Pay0 = child(this.transform, "Pay/0")
	if Pay0 ~= nil then
		addClickCallbackSelf(Pay0.gameObject, function() this.AddPay0Click(gameobject) end, this)
	end
	
	local Pay1 = child(this.transform, "Pay/1")
	if Pay1 ~= nil then
		addClickCallbackSelf(Pay1.gameObject, function() this.AddPay1Click(gameobject) end, this)
	end

	local btn_buy_ghost0 = child(this.transform, "AddGhost/0")
	if btn_buy_ghost0 ~= nil then
		UIEventListener.Get(btn_buy_ghost0.gameObject).onClick = this.Ghost0Click
	end
	local btn_buy_ghost1 = child(this.transform, "AddGhost/1")
	if btn_buy_ghost1 ~= nil then
		UIEventListener.Get(btn_buy_ghost1.gameObject).onClick = this.Ghost1Click
	end
	local btn_buy_ghost2 = child(this.transform, "AddGhost/2")
	if btn_buy_ghost2 ~= nil then
		if App.versionType ~= Version.Release then
			UIEventListener.Get(btn_buy_ghost2.gameObject).onClick = this.Ghost2Click
		else
			btn_buy_ghost2.gameObject:SetActive(false)
		end
	end
	
	local btn_add_chip = child(this.transform, "AddChip/0")
	addChipTbl[0] = btn_add_chip.gameObject:GetComponent(typeof(UIToggle))
	if btn_add_chip ~= nil then
		addClickCallbackSelf(btn_add_chip.gameObject, function() this.AddChip0Click(gameobject) end, this)
	end
	
	local btn_buy_chip = child(this.transform, "AddChip/1")
	addChipTbl[1] = btn_buy_chip.gameObject:GetComponent(typeof(UIToggle))
	if btn_buy_chip ~= nil then
		addClickCallbackSelf(btn_buy_chip.gameObject, function() this.AddChip1Click(gameobject) end, this)
	end

	local btn_buy_chip2 = child(this.transform, "AddChip/2")
	addChipTbl[2] = btn_buy_chip2.gameObject:GetComponent(typeof(UIToggle))
	if btn_buy_chip2 ~= nil then
		addClickCallbackSelf(btn_buy_chip2.gameObject, function() this.AddChip2Click(gameobject) end, this)
	end

	local btn_buy_chip3 = child(this.transform, "AddChip/3")
	addChipTbl[3] = btn_buy_chip3.gameObject:GetComponent(typeof(UIToggle))
	if btn_buy_chip3 ~= nil then
		addClickCallbackSelf(btn_buy_chip3.gameObject, function() this.AddChip3Click(gameobject) end, this)
	end




	local PlaceTime0 = child(this.transform, "PlaceTime/0")
	if PlaceTime0 ~= nil then
		addClickCallbackSelf(PlaceTime0.gameObject, function() this.PlaceTime0Click(gameobject) end, this)
	end
	
	local PlaceTime1 = child(this.transform, "PlaceTime/1")
	if PlaceTime1 ~= nil then
		addClickCallbackSelf(PlaceTime1.gameObject, function() this.PlaceTime1Click(gameobject) end, this)
	end

	local PlaceTime2 = child(this.transform, "PlaceTime/2")
	if PlaceTime2 ~= nil then
		addClickCallbackSelf(PlaceTime2.gameObject, function() this.PlaceTime2Click(gameobject) end, this)
	end

		local ReadyTime0 = child(this.transform, "ReadyTime/0")
	if ReadyTime0 ~= nil then
		addClickCallbackSelf(ReadyTime0.gameObject, function() this.ReadyTime0Click(gameobject) end, this)
	end
	
	local ReadyTime1 = child(this.transform, "ReadyTime/1")
	if ReadyTime1 ~= nil then
		addClickCallbackSelf(ReadyTime1.gameObject, function() this.ReadyTime1Click(gameobject) end, this)
	end

	local ReadyTime2 = child(this.transform, "ReadyTime/2")
	if ReadyTime2 ~= nil then
		addClickCallbackSelf(ReadyTime2.gameObject, function() this.ReadyTime2Click(gameobject) end, this)
	end
end
----------------------------------按扭事件注册END-------------------------------


local toggleType = {[1] = "addCard", [2] = "peopleNum", [3] = "addChip", [4] = "multply"}
--显示加一色按扭处理 1， Toggle选中的Key值 2， 按按扭的Tbl
function this.TglSelect(addCardNum, btnTbl)
	for i, v in pairs(btnTbl) do
		v.value = false
	end
	if btnTbl[addCardNum] ~= nil then
		btnTbl[addCardNum].value = true
	end
	--TODO
	--gameDataInfo.add_card = addCardNum
	room_data.SetSssRoomDataInfo(gameDataInfo)
end

---------------------------点击事件-------------------------
function this.Play4Click(obj)
	gameDataInfo.play_num = PlayNum[1]
	room_data.SetSssRoomDataInfo(gameDataInfo)
	log("gameDataInfo.play_num: "..gameDataInfo.play_num)
end

function this.Play8Click()
	gameDataInfo.play_num = PlayNum[2]
	room_data.SetSssRoomDataInfo(gameDataInfo)
	log("gameDataInfo.play_num: "..gameDataInfo.play_num)
end

function this.Play16Click()
	gameDataInfo.play_num = PlayNum[3]
	room_data.SetSssRoomDataInfo(gameDataInfo)
	log("gameDataInfo.play_num: "..gameDataInfo.play_num)
end

function this.People4Click()
	if gameDataInfo.add_card == 2 then
		this.TglSelect(0, addCardTbl)
		gameDataInfo.add_card = 0
	end
	if gameDataInfo.isZhuang == true then
		this.TglSelect(1, addCardTbl)
		gameDataInfo.add_card = 1
	end
	gameDataInfo.people_num =PeopleNum[3]
	room_data.SetSssRoomDataInfo(gameDataInfo)
	log("gameDataInfo.people_num: "..gameDataInfo.people_num)
end

function this.People5Click()
	gameDataInfo.add_card = 1
	gameDataInfo.people_num = PeopleNum[4]
	room_data.SetSssRoomDataInfo(gameDataInfo)
	log("gameDataInfo.people_num: "..gameDataInfo.people_num)
end

function this.People6Click(gameobject)
	log("gameDataInfo.people_num: "..gameDataInfo.people_num)
	gameDataInfo.add_card = 2
	gameDataInfo.people_num = PeopleNum[5]
	room_data.SetSssRoomDataInfo(gameDataInfo)
end

function this.Ghost0Click(obj)
	gameDataInfo.add_ghost = 0
	room_data.SetSssRoomDataInfo(gameDataInfo)
end

function this.Ghost1Click(obj)
	gameDataInfo.add_ghost = 1
	room_data.SetSssRoomDataInfo(gameDataInfo)
end

function this.Ghost2Click(obj)
	gameDataInfo.add_ghost = 2
	room_data.SetSssRoomDataInfo(gameDataInfo)
end

function this.TglGray(tran, isGray)
	local selectLbl = child(tran.transform, "select")
	local Checkmark = componentGet(child(tran.transform, "Checkmark"), "UISprite")
	local lbl = child(tran.transform, "Label")
	local noGray = true
	if isGray then
		noGray = false
	end
	if selectLbl ~= nil then
		selectLbl.gameObject:SetActive(noGray)
		if isGray then
			Checkmark.color = Color.New(1, 1, 1, 0)
		else
			Checkmark.color = Color.New(1, 1, 1, 1)
		end
		lbl.gameObject:SetActive(isGray)
	end
end

function this.AddChip0Click(gameobject)
	gameDataInfo.nBuyCode = 0--BuyCode[1]
	room_data.SetSssRoomDataInfo(gameDataInfo)
	log("gameDataInfo.nBuyCode: "..tostring(gameDataInfo.nBuyCode))
end

function this.AddChip1Click(gameobject)
	gameDataInfo.nBuyCode = 5--BuyCode[2]
	room_data.SetSssRoomDataInfo(gameDataInfo)
	log("gameDataInfo.nBuyCode: "..tostring(gameDataInfo.nBuyCode))
end

function this.AddChip2Click(gameobject)
	gameDataInfo.nBuyCode = 10--BuyCode[3]
	room_data.SetSssRoomDataInfo(gameDataInfo)
	log("gameDataInfo.nBuyCode: "..tostring(gameDataInfo.nBuyCode))
end

function this.AddChip3Click(gameobject)
	gameDataInfo.nBuyCode = 14--BuyCode[4]
	room_data.SetSssRoomDataInfo(gameDataInfo)
	log("gameDataInfo.nBuyCode: "..tostring(gameDataInfo.nBuyCode))
end

function this.AddPay0Click()
	gameDataInfo.costtype = PayType[2]
	room_data.SetSssRoomDataInfo(gameDataInfo)
	log("gameDataInfo.costtype: "..tostring(gameDataInfo.costtype))
end

function this.AddPay1Click()
	gameDataInfo.costtype = PayType[1]
	room_data.SetSssRoomDataInfo(gameDataInfo)
	log("gameDataInfo.costtype: "..tostring(gameDataInfo.costtype))
end

function this.PlaceTime0Click()
	gameDataInfo.nChooseCardTypeTimeOut = 60--BuyCode[4]
	room_data.SetSssRoomDataInfo(gameDataInfo)
end
function this.PlaceTime1Click()
	gameDataInfo.nChooseCardTypeTimeOut = 120--BuyCode[4]
	room_data.SetSssRoomDataInfo(gameDataInfo)
end
function this.PlaceTime2Click()
	gameDataInfo.nChooseCardTypeTimeOut = 180--BuyCode[4]
	room_data.SetSssRoomDataInfo(gameDataInfo)
end

function this.ReadyTime0Click()
	gameDataInfo.nReadyTimeOut = ReadyTimeOut[1]
	room_data.SetSssRoomDataInfo(gameDataInfo)
	log("gameDataInfo.nReadyTimeOut: "..tostring(gameDataInfo.nReadyTimeOut))
end
function this.ReadyTime1Click()
	gameDataInfo.nReadyTimeOut = ReadyTimeOut[2]
	room_data.SetSssRoomDataInfo(gameDataInfo)
	log("gameDataInfo.nReadyTimeOut: "..tostring(gameDataInfo.nReadyTimeOut))
end
function this.ReadyTime2Click()
	gameDataInfo.nReadyTimeOut = ReadyTimeOut[3]
	room_data.SetSssRoomDataInfo(gameDataInfo)
	log("gameDataInfo.nReadyTimeOut: "..tostring(gameDataInfo.nReadyTimeOut))
end
---------------------------点击事件END-------------------------


