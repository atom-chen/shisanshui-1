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
	this.AddCardTglClick(addCardTbl, {0, 1})
	--this.AddCardTglClick(multplyTbl, {1})
	
	this.AddCardTglClick(multplyTbl, {})
	multplyTbl[1].value = false
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

	local btn_2people = child(this.transform, "PeopleNum/2")
	peopleTbl[2] = btn_2people.gameObject:GetComponent(typeof(UIToggle))
	if btn_2people ~= nil then
		addClickCallbackSelf(btn_2people.gameObject, this.People2Click, this)
	end

	local btn_3people = child(this.transform, "PeopleNum/3")
	peopleTbl[3] = btn_3people.gameObject:GetComponent(typeof(UIToggle))
	if btn_3people ~= nil then
		addClickCallbackSelf(btn_3people.gameObject, this.People3Click, this)
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

	local btn_0card = child(this.transform, "AddCard/0")
	addCardTbl[0] = btn_0card.gameObject:GetComponent(typeof(UIToggle))
	if btn_0card ~= nil then
		addClickCallbackSelf(btn_0card.gameObject, function() this.Card0Click(gameobject) end, this)
	end

	local btn_1card = child(this.transform, "AddCard/1")
	addCardTbl[1] = btn_1card.gameObject:GetComponent(typeof(UIToggle))
	if btn_1card ~= nil then
		addClickCallbackSelf(btn_1card.gameObject, function() this.Card1Click(gameobject) end, this)
	end

	local btn_2card = child(this.transform, "AddCard/2")
	addCardTbl[2] = btn_2card.gameObject:GetComponent(typeof(UIToggle))
	if btn_2card ~= nil then
		addClickCallbackSelf(btn_2card.gameObject, function() this.Card2Click(gameobject) end, this)
	end

	local btn_1multple = child(this.transform, "Multple/1")
	multplyTbl[1] = btn_1multple.gameObject:GetComponent(typeof(UIToggle))
	if btn_1multple ~= nil then
		addClickCallbackSelf(btn_1multple.gameObject, function() this.Multple1Click(gameobject) end, this)
	end

	local btn_2multple = child(this.transform, "Multple/2")
	multplyTbl[2] = btn_2multple.gameObject:GetComponent(typeof(UIToggle))
	if btn_2multple ~= nil then
		addClickCallbackSelf(btn_2multple.gameObject, function() this.Multple2Click(gameobject) end, this)
	end

	local btn_3multple = child(this.transform, "Multple/3")
	multplyTbl[3] = btn_3multple.gameObject:GetComponent(typeof(UIToggle))
	if btn_3multple ~= nil then
		addClickCallbackSelf(btn_3multple.gameObject, function() this.Multple3Click(gameobject) end, this)
	end

	local btn_4multple = child(this.transform, "Multple/4")
	multplyTbl[4] = btn_4multple.gameObject:GetComponent(typeof(UIToggle))
	if btn_4multple ~= nil then
		addClickCallbackSelf(btn_4multple.gameObject, function() this.Multple4Click(gameobject) end, this)
	end

	local btn_5multple = child(this.transform, "Multple/5")
	multplyTbl[5] = btn_5multple.gameObject:GetComponent(typeof(UIToggle))
	if btn_5multple ~= nil then
		addClickCallbackSelf(btn_5multple.gameObject, function() this.Multple5Click(gameobject) end, this)
	end

	local btn_zhuang = child(this.transform, "Select/0")
	if btn_zhuang ~= nil then
		UIEventListener.Get(btn_zhuang.gameObject).onClick = this.ZhuangClick
	end

	local btn_buy_ghost = child(this.transform, "Select/1")
	if btn_buy_ghost ~= nil then
		UIEventListener.Get(btn_buy_ghost.gameObject).onClick = this.GhostClick
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

--加一色不可按，不变灰的按扭Key值 1,Toggle的Tbl，2，Key值
function this.AddCardTglClick(btnTbl, addCardNum)
	for i, v in pairs(btnTbl) do
		local trans = btnTbl[i].gameObject
		local boxCollider = componentGet(trans, "BoxCollider")
        local btn=componentGet(trans.gameObject, "UIButton")
		local lbl = componentGet(child(trans.transform, "Label"), "UILabel")
		local bg = componentGet(child(trans.transform, "Background"), "UISprite")
		lbl.color = gray_Color
		btn.isEnabled=false
		--boxCollider.enabled = false 
		for j = 1, #addCardNum do
			if i == addCardNum[j] then
				--boxCollider.enabled = true  
                btn.isEnabled=true
			    lbl.color = Color.New(139 / 255, 37 / 255, 13 / 255)
				bg.color = Color.white
			end
		end
	end
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

function this.People2Click()
	log("gameDataInfo.people_num: "..PeopleNum[1])
	gameDataInfo.people_num = PeopleNum[1]
	log("gameDataInfo.people_num: "..gameDataInfo.people_num)
	this.TglSelect(0, addCardTbl)
	gameDataInfo.add_card = 0
	room_data.SetSssRoomDataInfo(gameDataInfo)
	this.AddCardTglClick(addCardTbl, {0})
end

function this.People3Click()
	log("gameDataInfo.people_num: "..gameDataInfo.people_num)
	this.TglSelect(0, addCardTbl)
	this.AddCardTglClick(addCardTbl, {0})
	gameDataInfo.people_num = PeopleNum[2]
	gameDataInfo.add_card = 0
	room_data.SetSssRoomDataInfo(gameDataInfo)
end

function this.People4Click()
	log("gameDataInfo.people_num: "..gameDataInfo.people_num)
	if gameDataInfo.add_card == 2 then
		this.TglSelect(0, addCardTbl)
		gameDataInfo.add_card = 0
	end
	if gameDataInfo.isZhuang == true then
		this.TglSelect(1, addCardTbl)
		this.AddCardTglClick(addCardTbl, {1})
		gameDataInfo.add_card = 1
	end
	gameDataInfo.people_num =PeopleNum[3]
	room_data.SetSssRoomDataInfo(gameDataInfo)
	this.AddCardTglClick(addCardTbl, {0, 1})
end

function this.People5Click()
	this.TglSelect(1, addCardTbl)
	this.AddCardTglClick(addCardTbl, {1})
	gameDataInfo.add_card = 1
	gameDataInfo.people_num = PeopleNum[4]
	room_data.SetSssRoomDataInfo(gameDataInfo)
	log("gameDataInfo.people_num: "..gameDataInfo.people_num)
end

function this.People6Click(gameobject)
	this.TglSelect(2, addCardTbl)
	this.AddCardTglClick(addCardTbl, {2})
	log("gameDataInfo.people_num: "..gameDataInfo.people_num)
	gameDataInfo.add_card = 2
	gameDataInfo.people_num = PeopleNum[5]
	room_data.SetSssRoomDataInfo(gameDataInfo)
end

function this.Card0Click(gameobject)
	gameDataInfo.add_card = AddCard[1]
	room_data.SetSssRoomDataInfo(gameDataInfo)
	log("gameDataInfo.add_card: "..gameDataInfo.add_card)
end

function this.Card1Click(gameobject)
	gameDataInfo.add_card = AddCard[2]
	room_data.SetSssRoomDataInfo(gameDataInfo)
	log("gameDataInfo.add_card: "..gameDataInfo.add_card)
end

function this.Card2Click(gameobject)
	gameDataInfo.add_card = AddCard[3]
	room_data.SetSssRoomDataInfo(gameDataInfo)
	log("gameDataInfo.add_card: "..gameDataInfo.add_card)
end

function this.GhostClick(obj)
	local tgl = componentGet(obj.transform, "UIToggle")
	if tgl.value then
		gameDataInfo.add_ghost = 1
	else
		gameDataInfo.add_ghost = 0
	end
	room_data.SetSssRoomDataInfo(gameDataInfo)
	log("gameDataInfo.add_ghost: "..gameDataInfo.add_ghost)
end

function this.Multple1Click(gameobject)
	gameDataInfo.max_multiple = MaxMultiple[1]
	room_data.SetSssRoomDataInfo(gameDataInfo)
	log("gameDataInfo.max_multiple: "..gameDataInfo.max_multiple)
end

function this.Multple2Click(gameobject)
	gameDataInfo.max_multiple = MaxMultiple[2]
	room_data.SetSssRoomDataInfo(gameDataInfo)
	log("gameDataInfo.max_multiple: "..gameDataInfo.max_multiple)
end

function this.Multple3Click(gameobject)
	gameDataInfo.max_multiple = MaxMultiple[3]
	room_data.SetSssRoomDataInfo(gameDataInfo)
	log("gameDataInfo.max_multiple: "..gameDataInfo.max_multiple)
end

function this.Multple4Click(gameobject)
	gameDataInfo.max_multiple = MaxMultiple[4]
	room_data.SetSssRoomDataInfo(gameDataInfo)
	log("gameDataInfo.max_multiple: "..gameDataInfo.max_multiple)
end

function this.Multple5Click(gameobject)
	gameDataInfo.max_multiple = MaxMultiple[5]
	room_data.SetSssRoomDataInfo(gameDataInfo)
	log("gameDataInfo.max_multiple: "..gameDataInfo.max_multiple)
end

function this.Multple6Click(gameobject)
	gameDataInfo.max_multiple = MaxMultiple[6]
	room_data.SetSssRoomDataInfo(gameDataInfo)
	log("gameDataInfo.max_multiple: "..gameDataInfo.max_multiple)
end

function this.ZhuangClick(obj)
	local tgl = componentGet(obj.transform, "UIToggle")
	--水庄
	if tgl.value then
		gameDataInfo.isZhuang = true
		--倍数置亮
		this.AddCardTglClick(multplyTbl, {1, 2, 3, 4, 5})
		multplyTbl[1].value = true
		this.TglGray(multplyTbl[1].transform, false)
		
		--加色
		this.TglSelect(1, addCardTbl)
		gameDataInfo.add_card = 1
		this.AddCardTglClick(addCardTbl, {1})
		--人数
		this.TglSelect(4, peopleTbl)
		gameDataInfo.people_num = 4
		this.AddCardTglClick(peopleTbl, {4,5})
		--马牌
		this.TglSelect(0, addChipTbl)
		gameDataInfo.isChip = false
		this.AddCardTglClick(addChipTbl, {0})
	else --不是加一色做庄
		gameDataInfo.isZhuang = false
		--倍数置灰
		this.TglSelect(100, multplyTbl)
		gameDataInfo.max_multiple = 1
		this.AddCardTglClick(multplyTbl, {})
		for i = 1, #multplyTbl do
			this.TglGray(multplyTbl[i].transform, true)
		end
		
		--加色
		--this.TglSelect(0, addCardTbl)
		this.AddCardTglClick(addCardTbl, {0, 1})
		--人数
		this.TglSelect(4, peopleTbl)
		gameDataInfo.people_num = 4
		this.AddCardTglClick(peopleTbl, {2, 3, 4, 5, 6})
		--马牌
		this.AddCardTglClick(addChipTbl, {0, 1})
	end
	room_data.SetSssRoomDataInfo(gameDataInfo)
	log("gameDataInfo.isZhuang: "..tostring(gameDataInfo.isZhuang))
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
	gameDataInfo.isChip = false
	room_data.SetSssRoomDataInfo(gameDataInfo)
	log("gameDataInfo.isChip: "..tostring(gameDataInfo.isChip))
end

function this.AddChip1Click(gameobject)
	gameDataInfo.isChip = true
	room_data.SetSssRoomDataInfo(gameDataInfo)
	log("gameDataInfo.isChip: "..tostring(gameDataInfo.isChip))
end
---------------------------点击事件END-------------------------


