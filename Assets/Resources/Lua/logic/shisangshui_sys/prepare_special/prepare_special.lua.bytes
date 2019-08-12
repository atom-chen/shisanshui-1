--[[--
 * @Description: 发牌下来时判断特殊牌型
 * @Author:      zhy
 * @FileName:    prepare_special.lua
 * @DateTime:    2017-07-05
 ]]
 
require "logic/shisangshui_sys/place_card/place_card"
require "logic/shisangshui_sys/shisangshui_play_sys"
require "logic/shisangshui_sys/lib_sp_card_logic"

 
prepare_special = ui_base.New()
local this = prepare_special 
local transform;  

--计时间进度条
local timeSpt
--计时间Lbl
local timeLbl
--描述文字
local descLbl
--最大等待时间
local timeSecond = 10
--所有牌
local my_cards = {}

local cardTranTbl = {}
--特殊牌型
local card_type

local recommendCards

function this.Awake()
   this.initinfor()
  	--this.registerevent() 
end

function this.Show(cards, nSpecialType, dun, recCards)
	timeSecond = 30
	recommendCards = recCards
	log("---------cards------"..tostring(cards).."  dun: "..tostring(dun))
	my_cards = cards
	if this.gameObject==nil then
		require ("logic/shisangshui_sys/prepare_special/prepare_special")
		this.gameObject=newNormalUI("Prefabs/UI/PrepareSpecial/prepare_special")
	else
		for i, v in ipairs(cardTranTbl) do
			if v ~= nil then
				GameObject.Destroy(v.gameObject)
			end
		end
        this.gameObject:SetActive(true)
	end
	this.LoadAllCard(cards, nSpecialType, dun)
  	--this.addlistener()
end

function this.Hide()
	for i, v in ipairs(cardTranTbl) do
		if v ~= nil then
			GameObject.Destroy(v.gameObject)
		end
	end
	
	if this.gameObject == nil then
		return
	else
		GameObject.Destroy(this.gameObject)
		this.gameObject = nil
	end
end

--[[--
 * @Description: 逻辑入口  
 ]]
function this.Start()
	this.registerevent()
end

--[[--
 * @Description: 销毁  
 ]]
function this.OnDestroy()
end

function this.initinfor()
	timeSpt = componentGet(child(this.transform, "ready/timeSpt"), "UISprite")
	timeLbl = componentGet(child(this.transform, "ready/timeLbl"), "UILabel")
	descLbl = componentGet(child(this.transform, "message/descLbl"), "UILabel")
end

--注册事件
function this.registerevent()
	this.BtnClickEvent()
end

function this.LoadAllCard(cards, nSpecialType, dun)
---[[
	local cardGrid = child(this.transform, "cardGrid")
	if cardGrid == nil then
		log("cardGrid == nil")
		return
	end
	
	for i, v in ipairs(cards) do
		local cardObj = newNormalUI("Prefabs/Card/"..tostring(v), cardGrid)
		cardTranTbl[v] = cardObj
		componentGet(child(cardTranTbl[v].transform, "bg"),"UISprite").depth = i * 2 + 3
		componentGet(child(cardTranTbl[v].transform, "num"),"UISprite").depth = i * 2 + 5
		componentGet(child(cardTranTbl[v].transform, "color1"),"UISprite").depth = i * 2 + 5
		componentGet(child(cardTranTbl[v].transform, "color2"),"UISprite").depth = i * 2 + 5
		if room_data.GetSssRoomDataInfo().isChip == true and card == 40 then
			componentGet(child(cardTranTbl[v].transform, "ma"),"UISprite").depth = i * 2 + 4
		end
	end
	this.SpecialCard(cards, nSpecialType, dun)
	--]]

	--obj.transform.localPosition = Vector3.New(delte.x, delte.y, obj.transform.localPosition.z)
end

function this.SpecialCard(cards, nSpecialType, dun)
	descLbl.text = "出现特殊牌型"..tostring(GStars_Special_Type_Name[nSpecialType]).."，预计赢取每家"..tostring(dun).."墩，是否按特殊牌型出牌？"
	return card_type
end



function this.BtnClickEvent()
	local btn_confirm = child(this.transform, "message/confirmbtn")
	if btn_confirm ~= nil then
		addClickCallbackSelf(btn_confirm.gameObject, this.ConfirmClick, this)
	end
	
	local cancelbtn = child(this.transform, "message/cancelbtn")
	if cancelbtn ~= nil then
		addClickCallbackSelf(cancelbtn.gameObject, this.CancelClick, this)
	end
end
----------------------------------按扭事件注册END-------------------------------

---------------------------点击事件-------------------------
function this.ConfirmClick(obj)
	shisangshui_play_sys.ChooseCardTypeReq(1)
	this.Hide()
end

function this.CancelClick(obj)
	shisangshui_play_sys.ChooseCardTypeReq(0)
	place_card.Show(my_cards, recommendCards)
	this.Hide()
end
---------------------------点击事件END-------------------------

function this.Update()
	local timeEnd = room_data.GetPlaceCardTime()
	local curTime = Time.time
	local leftTime = timeEnd - curTime
	if leftTime <= 0 then
		--shisangshui_play_sys.PlaceCard(first_auto_all_card)
		this.Hide()
		return
	end
	if math.floor(leftTime) < 0 then
		leftTime = 0
	end
	
	timeLbl.text = tostring(math.floor(leftTime))
	timeSpt.fillAmount = math.floor(leftTime) / room_data.GetSssRoomDataInfo().placeCardTime
end


