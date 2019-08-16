--[[--
* @Description: 创建摆牌组件
 * @Author:      zhy
 * @FileName:    place_card.lua
 * @DateTime:    2017-07-1
 ]]

require "logic/shisangshui_sys/lib_normal_card_logic"
require "logic/shisangshui_sys/shisangshui_play_sys"
require "logic/shisangshui_sys/lib_laizi_card_logic"
require "logic/shisangshui_sys/common/array"
require "logic/shisangshui_sys/card_define"

 
place_card = ui_base.New()
local this = place_card 
local transform;
--13张牌Obj
local cardTranTbl = {}
--摆牌背景，包含位置
local cardPlaceTranList = {}
--已摆好牌索引
local place_index = 1
--牌父节点Obj
local placeCard
--准备Obj
local prepare
--1,初始状态 2，选中状态 3，已摆放状态
local CardType = {1, 2, 3}
--已选中扑克
local selectDownCards = {}
--已选中扑克
local selectUpCard

local up_placed_cards = {[1] = {}, [2] = {}, [3] = {}}

--timeLbl
local timeLbl
local timeSpt
local timeSecond
--下发和13张牌
local cardList
local left_card
--前，中，后 三墩牌的UISprite提示
local dunTipSpt = {}
--前，中，后 三墩牌的下架按扭
local dunDownBtn = {}
local first_auto_all_card = {}

local cardTipBtn = {}

local isXiangGong = false

local recommend_cards

local lastTime = 0  ----倒计时

local cardGrid

function this.Awake() 
   this.initinfor()   
  	--this.registerevent() 
end

function this.Show(cards, recommendCards)
	table.sort(cards, function(a, b) return GetCardValue(a) < GetCardValue(b)
		end)
	recommend_cards = recommendCards
	ui_sound_mgr.PlaySoundClip("dub/chupai_nv")
	--recommendCards["cards"] = cards
	log("place_card")
	cardList = cards
	place_index = 1
	if this.gameObject==nil then
		require ("logic/shisangshui_sys/place_card/place_card")
		this.gameObject=newNormalUI("Prefabs/UI/PlaceCard/place_card")
	else
		this.gameObject:SetActive(true)
	end
	timeSecond = Time.time + 3
  	--this.addlistener()
end

function this.Hide()
	log("摆牌隐藏")
	selectUpCard = nil
	cardPlaceTranList = {}
	cardTranTbl = {}
	selectDownCards = {}
	up_placed_cards = {[1] = {}, [2] = {}, [3] = {}} 
	first_auto_all_card = {}
	if cardTranTbl ~= nil then
		for i, v in pairs(cardTranTbl) do
			GameObject.Destroy(v);
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
	
	--cardList = {21, 53, 37, 6, 5, 7, 22, 9, 10, 11, 12, 13, 14}
	left_card = Array.Clone(cardList)
	this.LoadAllCard(cardList)
	this.TipsBtnShow(cardList)
	if recommend_cards == nil then
		this.AtutoPlaceCardType()
	else
		this.RecommendCardUpdate()
	end
	this.DunTipShow(false)
end

--[[--
 * @Description: 销毁  
 ]]
function this.OnDestroy()
end

local hoverObj = nil
function this.OnFingerHover(myself, finger)
	--log("OnFingerHoverForLua:"..tostring(finger.name))
	if hoverObj ~= nil and hoverObj.name == finger.name then
		return
	else
			--print("--------------")
			local data = UIEventListener.Get(finger.gameObject).parameter
			if data ~= nil and data.cardType == CardType[3] and hoverObj ~= nil then
				return
			end
			hoverObj = finger
			this.CardClick(hoverObj, true, true)
	end
end

function this.OnFingerUp(myself,fingerUpEvent)
	log("Lua fingerUpEvent++++++++++")
	hoverObj = nil
end

function this.OnSwipe(myself,direction,fingerSwipe)
	log("Direction:"..tostring(direction))
	if tostring(direction) == "Down" then
		--local data = UIEventListener.Get(fingerSwipe.gameObject).parameter
		--this.DownOneCard(data, true)
	end
end

---[[
function this.initinfor()
	for i = 1, 13 do
		local up_bg_data = {}
		cardPlaceTranList[i] = up_bg_data
		up_bg_data.tran = child(this.transform, "Panel_TopLeft/CardBg/"..i)
		up_bg_data.blank = true
		up_bg_data.card = nil
		up_bg_data.index = i
		UIEventListener.Get(up_bg_data.tran.gameObject).onClick = this.CardBgClick
		UIEventListener.Get(up_bg_data.tran.gameObject).parameter = up_bg_data
		placeCard = child(this.transform, "Panel_Bottom/placeCard")
		if placeCard ~= nil then
			placeCard.gameObject:SetActive(true)
		end
		prepare = child(this.transform, "Panel_Bottom/prepare")
		if prepare ~= nil then
			prepare.gameObject:SetActive(false)
		end
		timeLbl =  componentGet(child(this.transform, "Panel_TopLeft/Slider/timeLbl"), "UILabel")
		timeSpt =  componentGet(child(this.transform, "Panel_TopLeft/Slider/Foreground"), "UISprite")
	end
	
	---[[
	local dunTip3 = child(this.transform, "Panel_TopLeft/thirdDun")
	dunTipSpt[1] = dunTip3
	local dunTip2 = child(this.transform, "Panel_TopLeft/secondDun")
	dunTipSpt[2] = dunTip2
	local dunTip1 = child(this.transform, "Panel_TopLeft/firstDun")
	dunTipSpt[3] = dunTip1
	--]]
	
	local dunTip3 = child(this.transform, "Panel_TopLeft/thirdBtn")
	dunDownBtn[1] = dunTip3
	local DownBtn2 = child(this.transform, "Panel_TopLeft/secondBtn")
	dunDownBtn[2] = DownBtn2
	local DownBtn1 = child(this.transform, "Panel_TopLeft/firstBtn")
	dunDownBtn[3] = DownBtn1
	
	
	cardGrid = componentGet(child(this.transform, "CardGrid"), "UIGrid")
--]]
end

function this.SetOutTime(timeo)
	timeSecond = timeo
end

--注册事件
function this.registerevent()
--[[
	local btn_1place = child(this.transform, "Panel_TopLeft/CardBg/1")
	if btn1place ~= nil then
		addClickCallbackSelf(btn_1place.gameObject, this. )
	end
	--]]
	local cardTip1 = child(this.transform, "Panel_Bottom/placeCard/tips/cardTip1")
	if cardTip1 ~= nil then
		cardTipBtn[1] = cardTip1
		UIEventListener.Get(cardTip1.gameObject).onClick = this.BtnClick
	end
	local cardTip2 = child(this.transform, "Panel_Bottom/placeCard/tips/cardTip2")
	if cardTip2 ~= nil then
		cardTipBtn[2] = cardTip2
		UIEventListener.Get(cardTip2.gameObject).onClick = this.BtnClick
	end
	local cardTip3 = child(this.transform, "Panel_Bottom/placeCard/tips/cardTip3")
	if cardTip3 ~= nil then
		cardTipBtn[3] = cardTip3
		UIEventListener.Get(cardTip3.gameObject).onClick = this.BtnClick
	end
	local cardTip4 = child(this.transform, "Panel_Bottom/placeCard/tips/cardTip4")
	if cardTip4 ~= nil then
		cardTipBtn[4] = cardTip4
		UIEventListener.Get(cardTip4.gameObject).onClick = this.BtnClick
	end
	local cardTip5 = child(this.transform, "Panel_Bottom/placeCard/tips/cardTip5")
	if cardTip5 ~= nil then
		cardTipBtn[5] = cardTip5
		UIEventListener.Get(cardTip5.gameObject).onClick = this.BtnClick
	end
	local cardTip6 = child(this.transform, "Panel_Bottom/placeCard/tips/cardTip6")
	if cardTip6 ~= nil then
		cardTipBtn[6] = cardTip6
		UIEventListener.Get(cardTip6.gameObject).onClick = this.BtnClick
	end
	local cardTip7 = child(this.transform, "Panel_Bottom/placeCard/tips/cardTip7")
	if cardTip7 ~= nil then
		cardTipBtn[7] = cardTip7
		UIEventListener.Get(cardTip7.gameObject).onClick = this.BtnClick
	end
	local cardTip8 = child(this.transform, "Panel_Bottom/placeCard/tips/cardTip8")
	if cardTip8 ~= nil then
		cardTipBtn[8] = cardTip8
		UIEventListener.Get(cardTip8.gameObject).onClick = this.BtnClick
	end
	local cardType1 = child(this.transform, "Panel_TopRight/cardType1")
	if cardType1 ~= nil then
		UIEventListener.Get(cardType1.gameObject).onClick = this.BtnClick
	end
	local cardType2 = child(this.transform, "Panel_TopRight/cardType2")
	if cardType2 ~= nil then
		UIEventListener.Get(cardType2.gameObject).onClick = this.BtnClick
	end
	local cardType3 = child(this.transform, "Panel_TopRight/cardType3")
	if cardType3 ~= nil then
		UIEventListener.Get(cardType3.gameObject).onClick = this.BtnClick
	end
	local cardType4 = child(this.transform, "Panel_TopRight/cardType4")
	if cardType4 ~= nil then
		UIEventListener.Get(cardType4.gameObject).onClick = this.BtnClick
	end
	local OkBtn = child(this.transform, "Panel_Bottom/prepare/OkBtn")
	if OkBtn ~= nil then
		UIEventListener.Get(OkBtn.gameObject).onClick = this.BtnClick
	end
	local CancelBtn = child(this.transform, "Panel_Bottom/prepare/CancelBtn")
	if CancelBtn ~= nil then
		UIEventListener.Get(CancelBtn.gameObject).onClick = this.BtnClick
	end
	
	local firstBtn = child(this.transform, "Panel_TopLeft/firstBtn")
	if firstBtn ~= nil then
		UIEventListener.Get(firstBtn.gameObject).onClick = this.BtnClick
	end
	
	local secondBtn = child(this.transform, "Panel_TopLeft/secondBtn")
	if secondBtn ~= nil then
		UIEventListener.Get(secondBtn.gameObject).onClick = this.BtnClick
	end
	
	local thirdBtn = child(this.transform, "Panel_TopLeft/thirdBtn")
	if thirdBtn ~= nil then
		UIEventListener.Get(thirdBtn.gameObject).onClick = this.BtnClick
	end
end
	
function this.TipsBtnShow(cards)
	local normal_cards, nLaziCount, laiziCards = this.GetallCardType(Array.Clone(cards))
	local bFound, temp = libRecomand:Get_Pt_Straight_Flush_Laizi_second(Array.Clone(normal_cards), nLaziCount)
	log("剩余牌的数量:"..tostring(#normal_cards))
	this.BtnGray(cardTipBtn[1], bFound)
	
	bFound, temp = libRecomand:Get_Pt_Four_Laizi_second(Array.Clone(normal_cards), nLaziCount)
	this.BtnGray(cardTipBtn[2], bFound)
	
	bFound, temp = libRecomand:Get_Pt_Full_Hosue_Laizi_second(Array.Clone(normal_cards), nLaziCount)
	--bFound, temp = libRecomand:Get_Pt_Full_Hosue_Laizi_Ext(Array.Clone(normal_cards), nLaziCount)
	
	this.BtnGray(cardTipBtn[3], bFound)
	
	bFound, temp = libRecomand:Get_Pt_Flush_Laizi_second(Array.Clone(normal_cards), nLaziCount)
	this.BtnGray(cardTipBtn[4], bFound)
	
	bFound, temp = libRecomand:Get_Pt_Straight_Laizi_second(Array.Clone(normal_cards), nLaziCount)
	this.BtnGray(cardTipBtn[5], bFound)
	
	bFound, temp = libRecomand:Get_Pt_Three_Laizi_second(Array.Clone(normal_cards), nLaziCount)
	this.BtnGray(cardTipBtn[6], bFound)
	
	bFound, temp = libRecomand:Get_Pt_Five_Laizi_second(Array.Clone(normal_cards), nLaziCount)
	this.BtnGray(cardTipBtn[7], bFound)
	
	bFound, temp = libRecomand:Get_Pt_One_Pair_Laizi_second(Array.Clone(normal_cards),nLaziCount)
	this.BtnGray(cardTipBtn[8],bFound)
end

function this.BtnGray(trans, isCanClick)
	--local collider = componentGet(trans, "BoxCollider")
	-- local enbale_bg = componentGet(child(trans, "Background"), "UISprite")
	-- local disable_bg = componentGet(child(trans, "Background (1)"), "UISprite")
	local active1 = child(trans, "active")
	local inactive = child(trans, "inactive")
	--if collider == nil or bg == nil then
	--	print("collider = nil or bg = nil : "..trans.name)
	--	return
	--end
	if isCanClick then
	
		--collider.enabled = true
	--	bg.spriteName = "pzaj-001"
		-- enbale_bg.gameObject:SetActive(true)
		-- disable_bg.gameObject:SetActive(false)
		
		active1.gameObject:SetActive(true)
		inactive.gameObject:SetActive(false)
	else
		
		--collider.enabled = false
	--	bg.spriteName = "pzaj-002"
		
		-- enbale_bg.gameObject:SetActive(false)
		-- disable_bg.gameObject:SetActive(true)
		
		active1.gameObject:SetActive(false)
		inactive.gameObject:SetActive(true)
	end
end


function this.LoadAllCard(cards)
---[[
	log("---------LOadAllCard-----")
	local CardGrid = child(this.transform, "CardGrid")
	if CardGrid == nil then
		log("CardGrid == nil")
		return
	end
	
	for i = 1, #cards do
		local card = cards[i]
		local card_data = {}
		card_data.tran = newNormalUI("Prefabs/Card/"..tostring(card), CardGrid)
		if card_data.tran == nil then
			fast_tip.Show("配牌错误，ID："..tostring(card))
			break
		end
		if cardTranTbl[card] ~= nil then
			cardTranTbl[card + 100] = card_data
		else
			cardTranTbl[card] = card_data
		end
		local k = i - 1
		card_data.tran.transform.localPosition = Vector3.New(-558 + 93 * k, 0, 0)
		card_data.tran.transform.localScale = Vector3.New(0.9, 0.9, 0.9)
		card_data.tran.name = tostring(i)
		card_data.pos = Vector3.New(-558 + 93 * k, 0, 0)
		card_data.name = tostring(i)
		card_data.index = i
		local object2 = card_data.tran
		local cardData = {}
		cardData.card = cards[i]
		cardData.down_index = i
		cardData.up_index = 0
		cardData.cardType = CardType[1]
		cardData.tran = card_data.tran
		cardData.pos = card_data.pos
		componentGet(child(card_data.tran.transform, "bg"),"UISprite").depth = i * 2 + 3
		componentGet(child(card_data.tran.transform, "num"),"UISprite").depth = i * 2 + 5
		componentGet(child(card_data.tran.transform, "color1"),"UISprite").depth = i * 2 + 5
		componentGet(child(card_data.tran.transform, "color2"),"UISprite").depth = i * 2 + 5
		if room_data.GetSssRoomDataInfo().isChip == true and card == 40 then
			componentGet(child(card_data.tran.transform, "ma"),"UISprite").depth = i * 2 + 4
		end
		UIEventListener.Get(card_data.tran.gameObject).onClick = this.CardClick
		UIEventListener.Get(card_data.tran.gameObject).parameter = cardData

        UIEventListener.Get(card_data.tran.gameObject).OnHover = function (obj, isOver)
        	log("悬浮")
        	if isOver then
	    		local finger = {}
	    		finger.Selection = obj
	            this.OnFingerHover(nil, finger)
	        end
        end 
	end
	--]]

	--obj.transform.localPosition = Vector3.New(delte.x, delte.y, obj.transform.localPosition.z)
end

function this.CardClick(obj, fast)
	local cardData = UIEventListener.Get(obj).parameter
	if cardData == nil then
		log("-----cardData = nil-----")
	end
	local cardNowType = cardData.cardType
	local cardNum = cardData.card
	log("CardType: "..tostring(cardNowType).."  num: "..cardNum)
	if(tonumber(cardNowType) == CardType[1]) then
		obj.transform:DOLocalMoveY(40, 0.05, true)
		local selectDownCardData = {}
		cardData.cardType = CardType[2]
		--selectDownCards[tonumber(obj.name)] = cardData
		table.insert(selectDownCards, cardData)
		UIEventListener.Get(obj).parameter = cardData
	elseif (tonumber(cardNowType) == CardType[2]) then
		if fast ~= nil and fast == true then
			local pos = obj.transform.localPosition
			obj.transform.localPosition = Vector3.New(pos.x, 0, pos.z)
		else
			obj.transform:DOLocalMoveY(0, 0.05, true)
		end
		local selectDownCardData = {}
		cardData.cardType = CardType[1]
		--selectDownCards[tonumber(obj.name)] = cardData		
		UIEventListener.Get(obj).parameter = cardData
		--local _key = tonumber(obj.name)
		--selectDownCards[_key] = nil
		local indexKey = this.GetDownCardKey(cardData)
		table.remove(selectDownCards, indexKey)
	else
		if obj.transform.localScale ~= Vector3.New(0.91, 0.91, 0.91) then
			log("换牌错误")
			return
		end
		if selectUpCard == nil then
			selectUpCard = obj
			UIEventListener.Get(selectUpCard.gameObject).parameter = cardData
			return
		else
			local selectCardData = UIEventListener.Get(selectUpCard.gameObject).parameter
			obj.transform:DOLocalMove(selectUpCard.transform.localPosition, 0.3, true)
			selectUpCard.transform:DOLocalMove(obj.transform.localPosition, 0.3, true)
			
			local _, dun, dun_no = this.GetDun(cardData.up_index)
			local _select, select_dun, select_dun_no = this.GetDun(selectCardData.up_index)
			up_placed_cards[dun][dun_no], up_placed_cards[select_dun][select_dun_no] = 
				up_placed_cards[select_dun][select_dun_no], up_placed_cards[dun][dun_no]
				
			cardData.up_index, selectCardData.up_index = selectCardData.up_index, cardData.up_index
			selectUpCard = nil
			if place_index >= 14 then
				this.XiangGongTip()
			end
		end
	end
end

function this.GetDownCardKey(cardData)
	for i = 1, #selectDownCards do
		if selectDownCards[i].down_index == cardData.down_index then
			return i
		end
	end
end

function this.GetConfirmCard()
	local confirmCards = {}
	for i = 1, 5 do
		confirmCards[i] = up_placed_cards[1][i].card
	end
	for i = 1, 5 do
		confirmCards[i + 5] = up_placed_cards[2][i].card
	end
	for i = 1, 3 do
		confirmCards[i + 10] = up_placed_cards[3][i].card
	end
	return confirmCards
end

function this.CardBgClick(obj)
	local place_up_index = tonumber(obj.name)
	local select_num = 0
	for i, v in ipairs(selectDownCards) do
		if v ~= nil then
			select_num = select_num + 1
		end
	end
	local place_up_max = this.GetMaxFromPosInDun(place_up_index)
	if select_num > place_up_max then
		local CanPlaceMaxPos = this.GetMaxPosInDun (place_up_index)
		if select_num > CanPlaceMaxPos then
			local box= message_box.ShowGoldBox("选中的牌太多",nil,1,{function ()message_box:Close()end},{"fonts_01"})
			return
		else
			place_up_index = this.GetMinDun(place_up_index)
		end
	end
	table.sort(selectDownCards, function (a, b)
			return GetCardValue(a.card) < GetCardValue(b.card)
		end)
		
    local place, dun = this.GetDun(place_up_index)
	for i, v in ipairs(selectDownCards) do
		if place_index > 13 then
			return
		end

		for i = place_up_index, 13 do
			if cardPlaceTranList[place_up_index].blank == true then
				break
			else
				place_up_index = place_up_index + 1
			end
		end
		cardPlaceTranList[place_up_index].blank = false
		cardPlaceTranList[place_up_index].card = v.card
		local cardData = UIEventListener.Get(v.tran.gameObject).parameter
		local cardNum = cardData.card
		v.tran.transform:DOLocalMove(cardPlaceTranList[place_up_index].tran.transform.localPosition, 0.3, true)
		v.tran.transform:DOScale(Vector3.New(0.91, 0.91, 0.91), 0.3)
		cardData.cardType = CardType[3]
		cardData.up_index = place_up_index
		UIEventListener.Get(v.tran.gameObject).parameter = cardData
		--log("selectDownCards: i:  "..i.."  v: "..v.tran.name)
		this.UpdateLeftCard(left_card, cardData.card)
		
		local dun, dun_no = this.GetDunNo(place_up_index)
		up_placed_cards[dun][dun_no] = cardData
		place_index = place_index + 1
		if place_index == 14 then
			this.PlaceCardFinish()
			break
		end
		place_up_index = place_up_index + 1
		 	end
	for k,v in ipairs(selectDownCards) do
		selectDownCards[k] = nil
	end
	selectDownCards = {}
	this.DunBtnShow(place_up_index - 1)
	this.TipsBtnShow(left_card)
	this.BuPai()

	coroutine.start(function ()
		coroutine.wait(0.31)
		cardGrid:Reposition()
	end
	)
end
 
function this.GetMaxFromPosInDun(index)
	local place_max = this.GetDun(index)
	local now_num = 0
	for i = index, place_max do
		if cardPlaceTranList[i].blank == true then
			now_num = now_num + 1
		end
	end
	log("max_pos_plaxe_card_num: "..place_max)
	return now_num
end

function this.GetMinDun(index)
	local min
	if index <= 5 then
		min = 1
	elseif index >= 11 then
		min = 11
	else
		min = 6
	end
	return min
end

function this.GetMaxPosInDun(index)
	local place_max = this.GetMinDun(index)
	local now_num = 0
	local num = 4
	if index > 10 then
		num = 2
	end
	for i = place_max, place_max + num do
		if cardPlaceTranList[i].blank == true then
			now_num = now_num + 1
		end
	end
	log("max_pos_plaxe_card_num: "..place_max)
	return now_num
end


function this.GetDun(index)
	local place_max, dun, dun_no
	if index <= 5 then
		place_max = 5
		dun = 1
		dun_no = index
	elseif index >= 11 then
		place_max = 13
		dun = 3
		dun_no = index - 10
	else
		place_max = 10
		dun = 2
		dun_no = index - 5
	end
	return place_max, dun, dun_no
end

function this.GetDunNo(index)
	local place_max, dun_no
	if index <= 5 then
		dun = 1
		dun_no = index
	elseif index >= 11 then
		dun = 3
		dun_no = index - 10
	else
		dun = 2
		dun_no = index - 5
	end
	return dun, dun_no
end

function this.BtnClick(obj)
	--同花顺
	--同花顺
	if obj.name == "cardTip1" then
		local active1 = child(obj.transform, "active")
		if active1.gameObject.activeSelf == false then
			return
		end
		local normal_cards, nLaziCount, laiziCards = this.GetallCardType(Array.Clone(left_card))
		local bFound, temp = libRecomand:Get_Pt_Straight_Flush_Laizi_second(normal_cards, nLaziCount)
		this.CardTypeBottomClick(1, temp, laiziCards)
	--铁枝
	elseif obj.name == "cardTip2" then
		local active1 = child(obj.transform, "active")
		if active1.gameObject.activeSelf == false then
			return
		end
		local normal_cards, nLaziCount, laiziCards = this.GetallCardType(Array.Clone(left_card))
		local bFound, temp = libRecomand:Get_Pt_Four_Laizi_second(normal_cards, nLaziCount)
		this.CardTypeBottomClick(2, temp, laiziCards)
	--葫芦
	elseif obj.name == "cardTip3" then
		local active1 = child(obj.transform, "active")
		if active1.gameObject.activeSelf == false then
			return
		end
		local normal_cards, nLaziCount, laiziCards = this.GetallCardType(Array.Clone(left_card))
		local bFound, temp = libRecomand:Get_Pt_Full_Hosue_Laizi_second(normal_cards, nLaziCount)
		--local bFound, temp = libRecomand:Get_Pt_Full_Hosue_Laizi_Ext(normal_cards, nLaziCount)
	
		this.CardTypeBottomClick(3, temp, laiziCards)
		--同花
	elseif obj.name == "cardTip4" then
		local active1 = child(obj.transform, "active")
		if active1.gameObject.activeSelf == false then
			return
		end
		local normal_cards, nLaziCount, laiziCards = this.GetallCardType(Array.Clone(left_card))
		local bFound, temp = libRecomand:Get_Pt_Flush_Laizi_second(normal_cards, nLaziCount)
		this.CardTypeBottomClick(4, temp, laiziCards)
		--顺子
	elseif obj.name == "cardTip5" then
		local active1 = child(obj.transform, "active")
		if active1.gameObject.activeSelf == false then
			return
		end
		local normal_cards, nLaziCount, laiziCards = this.GetallCardType(Array.Clone(left_card))
		local bFound, temp = libRecomand:Get_Pt_Straight_Laizi_second(normal_cards, nLaziCount)
		this.CardTypeBottomClick(5, temp, laiziCards)
	--三条
	elseif obj.name == "cardTip6" then
		local active1 = child(obj.transform, "active")
		if active1.gameObject.activeSelf == false then
			return
		end
		local normal_cards, nLaziCount, laiziCards = this.GetallCardType(Array.Clone(left_card))
		local bFound, temp = libRecomand:Get_Pt_Three_Laizi_second(normal_cards, nLaziCount)
		this.CardTypeBottomClick(6, temp, laiziCards)
		--五同
	elseif obj.name == "cardTip7" then
		local active1 = child(obj.transform, "active")
		if active1.gameObject.activeSelf == false then
			return
		end
		local normal_cards, nLaziCount, laiziCards = this.GetallCardType(Array.Clone(left_card))
		local bFound, temp = libRecomand:Get_Pt_Five_Laizi_second(normal_cards, nLaziCount)
		this.CardTypeBottomClick(7, temp, laiziCards)
	elseif obj.name == "cardTip8" then
		local active1 = child(obj.transform, "active")
		if active1.gameObject.activeSelf == false then
			return
		end
		local normal_cards, nLaziCount, laiziCards = this.GetallCardType(Array.Clone(left_card))
		local bFound, temp = libRecomand:Get_Pt_One_Pair_Laizi_second(normal_cards, nLaziCount)
		this.CardTypeBottomClick(8, temp, laiziCards)
	elseif obj.name == "cardTip9" then
		local active1 = child(obj.transform, "active")
		if active1.gameObject.activeSelf == false then
			return
		end
		local normal_cards, nLaziCount, laiziCards = this.GetallCardType(Array.Clone(left_card))
		local bFound, temp = libRecomand:Get_Pt_Two_Pair_Laizi_second(normal_cards, nLaziCount)
		this.CardTypeBottomClick(9, temp, laiziCards)
	--确定
	elseif obj.name == "OkBtn" then
		log("------OkBtn click--")
		isXiangGong = this.XiangGong()
		if isXiangGong then
			local box= message_box.ShowGoldBox("此牌为相公",nil,1,{function ()message_box:Close()end},{"fonts_01"})
			return
		end
		local confirm_cards = this.GetConfirmCard()
		for i, v in ipairs(confirm_cards) do
			if confirm_cards[i] > 100 then
				confirm_cards[i] = confirm_cards[i] - 100 --加一色的ID为大于100，这里发送给服务器得减去100
				
			end
			
		end
		if #confirm_cards < 13 then
			log("摆的牌少于13张")
			return
		end
		local check = this.CheckSendCard(confirm_cards)
		if check == false then
			return	
		end
		shisangshui_play_sys.PlaceCard(confirm_cards)
		this.Hide()
	elseif obj.name == "CancelBtn" then
		if placeCard ~= nil then
			placeCard.gameObject:SetActive(true)
		end
		if prepare ~= nil then
			prepare.gameObject:SetActive(false)
		end
		this.DownCardClick(1)
		this.DownCardClick(2)
		this.DownCardClick(3)
	elseif obj.name == "cardType1" then
		log("-----cardType1-------")
		this.AutoPlace1Click(1)
	elseif obj.name == "cardType2" then
		log("-----cardType2-------")
		this.AutoPlace1Click(2)
	elseif obj.name == "cardType3" then
		log("-----cardType3-------")
		this.AutoPlace1Click(3)
	elseif obj.name == "cardType4" then
		log("-----cardType4-------")
		this.AutoPlace1Click(4)
	--选好的牌下架
	elseif obj.name == "firstBtn" then
		this.DownCardClick(3)
	elseif obj.name == "secondBtn" then
		this.DownCardClick(2)	
	elseif obj.name == "thirdBtn" then
		this.DownCardClick(1)
	end
end

function this.CardTypeBottomClick(index, temp, laiziCards)
	if temp == nil  or #temp == 0 then
		log("没有相应的推荐牌型:"..tostring(index))
		return
	end
	local allResult = libRecomand:Get_Rec_Cards_Laizi(temp, laiziCards)
	this.DownSelectCard()
	if bottonSelectCardsBtn == index and allCardTypeIndex >= #allResult then
		allCardTypeIndex = 0
		isSelectDown = true
		return
	end
	if bottonSelectCardsBtn ~= index then
		allCardTypeIndex = 0
	end
	isSelectDown = false
	allCardTypeIndex = allCardTypeIndex + 1
	local cards = this.FindSameCard(allResult[allCardTypeIndex])
	for i, v in ipairs(cards) do
		local y = cardTranTbl[v].tran.transform.localPosition.y
		if cardTranTbl[v] ~= nil and cardTranTbl[v].tran.transform.localPosition.y < 50 then
			this.CardClick(cardTranTbl[tonumber(v)].tran.gameObject, true)
		elseif cardTranTbl[tonumber(v) + 100] ~= nil then
			this.CardClick(cardTranTbl[tonumber(v) + 100].tran.gameObject, true)
		end
	end
	animationMove = true
	coroutine.start(function ()
		coroutine.wait(animationWaitTime)
		animationMove = false
	end
	)
	bottonSelectCardsBtn = index
end

function this.GetallCardType(cards)
	local normalCards = {}
    local laiziCards = {}
    for _, v in ipairs(cards) do
        local nValue = GetCardValue(v)
        if LibLaiZi:IsLaiZi(nValue) then
            table.insert(laiziCards, v)
        else
            table.insert(normalCards, v)
        end
    end
    local nLaziCount = #laiziCards
	return normalCards, nLaziCount, laiziCards
end

function this.DownSelectCard()
	---[[
	for i, v in ipairs(selectDownCards) do
		local obj = v.tran.gameObject
		local cardData = UIEventListener.Get(obj).parameter
		local pos = obj.transform.localPosition
		obj.transform.localPosition = Vector3.New(pos.x, 0, pos.z)
		cardData.cardType = CardType[1]
		--selectDownCards[tonumber(obj.name)] = cardData		
		UIEventListener.Get(obj).parameter = cardData
	end
	selectDownCards = {}
	--]]
end

function this.FindSameCard(cards)
	for i = 1, #cards do
		for j = i + 1, #cards do
			if cards[i] == cards[j] then
				cards[i] = 100 + cards[i]
				break
			end
		end
	end
	return cards
end

function this.AutoPlace1Click(index)
	---[[
	local change_cards = Array.Clone(first_auto_all_card)
	if recommend_cards ~= nil then
		local rec_cards = recommend_cards[index]["Cards"]
		change_cards = Array.Clone(rec_cards)
	end
	change_cards = this.FindSameCard(change_cards)
	for i = 1, #change_cards do
		local destOjbPos = cardPlaceTranList[i]
		local cardNum = change_cards[i]
		if cardTranTbl[cardNum] == nil then
			log("推荐的牌有一张找不到："..tostring(cardNum))
			fast_tip.Show("推荐的牌有一张找不到,推荐牌型错误")
			return
		end
		cardTranTbl[cardNum].tran.transform:DOLocalMove(destOjbPos.tran.transform.localPosition, 0.3, true)
		--cardTranTbl[cardNum].tran.transform:DOScale(Vector3.New(0.65, 0.65, 0.65), 0.5)
		local parameterData = UIEventListener.Get(cardTranTbl[cardNum].tran.gameObject).parameter
		parameterData.cardType = CardType[3]
		parameterData.up_index = i
		
		local dun, dun_no =  this.GetDunNo(i)
		up_placed_cards[dun][dun_no] = parameterData
		this.UpdateLeftCard(left_card, parameterData.card)
	end
	place_index = 14
	--]]
	for i = 1, #cardPlaceTranList do
		cardPlaceTranList[i].blank = true
	end
	this.DunTipShow(true)
	selectDownCards = {}
	this.PlaceCardFinish()
end

function this.DunBtnShow(placing_index)
	local dun_max_index, dun = this.GetDun(placing_index)
	log(placing_index.."  dun_max_index:..  "..dun_max_index.."   dun: "..dun)
	if dun ~= 3 then
		for i = dun_max_index, dun_max_index - 4, -1 do
			if cardPlaceTranList[i].blank == true then
				dunDownBtn[dun].gameObject:SetActive(false)
				dunTipSpt[dun].gameObject:SetActive(true)
				return
			end
		end
		dunDownBtn[dun].gameObject:SetActive(true)
		dunTipSpt[dun].gameObject:SetActive(false)
	else
		for i = dun_max_index, 11, -1 do
			if cardPlaceTranList[i].blank == true then
				dunDownBtn[dun].gameObject:SetActive(false)
				dunTipSpt[dun].gameObject:SetActive(true)
				return
			end
		end
		dunDownBtn[dun].gameObject:SetActive(true)
		dunTipSpt[dun].gameObject:SetActive(false)
	end
end

function this.DunTipShow(isShowBtn)
	for i = 1, 3 do
		dunDownBtn[i].gameObject:SetActive(isShowBtn)
	end
	local isShowSpt = true
	if isShowBtn then
		isShowSpt = false
	end
	for i = 1, 3 do
		dunTipSpt[i].gameObject:SetActive(isShowSpt)
	end
end
	
function this.DownCardClick(dun)
	
	log("this.DownCardClick: "..dun)
	if placeCard ~= nil then
		placeCard.gameObject:SetActive(true)
	end
	if prepare ~= nil then
		prepare.gameObject:SetActive(false)
	end
	local dun_cards = up_placed_cards[dun]
	log("this.DownCardClick: "..#dun_cards)
	for i, v in pairs(dun_cards) do
		v.tran.transform:DOLocalMove(v.pos, 0.3, true)
		v.tran.transform:DOScale(Vector3.New(1, 1, 1), 0.3)
		v.cardType = CardType[1]
		
		left_card[#left_card + 1] = v.card
		print ("DownCardClick up_index: "..v.up_index)
		cardPlaceTranList[v.up_index].blank = true
	end
	if dun ~= 3 then
		place_index = place_index - 5
	else
		place_index = place_index - 3
	end
	up_placed_cards[dun] = {}
	dunDownBtn[dun].gameObject:SetActive(false)
	dunTipSpt[dun].gameObject:SetActive(true)	
	this.TipsBtnShow(left_card)
	coroutine.start(function ()
		coroutine.wait(0.31)
		cardGrid:Reposition()
	end
	)
end


function this.BuPai()
	if #left_card > 5 then
		return
	end
	if #left_card == 0 then
		return
	end
	local leftCardNum = #left_card
	local blankNum = 0
	for i = 1, 5 do
		if cardPlaceTranList[i].blank == true then
			blankNum = blankNum + 1
		end
	end
	if blankNum == leftCardNum then
		local down_card = this.GetDownCardSelect()
		this.CardBgClick(cardPlaceTranList[1].tran.gameObject)
		return
	end
	blankNum = 0
	for i = 6, 10 do
		if cardPlaceTranList[i].blank == true then
			blankNum = blankNum + 1
		end
	end
	if blankNum == leftCardNum then
		local down_card = this.GetDownCardSelect()
		this.CardBgClick(cardPlaceTranList[6].tran.gameObject)
		return
	end
	
	blankNum = 0
	for i = 11, 13 do
		if cardPlaceTranList[i].blank == true then
			blankNum = blankNum + 1
		end
	end
	if blankNum == leftCardNum then
		local down_card = this.GetDownCardSelect()
		this.CardBgClick(cardPlaceTranList[11].tran.gameObject)
		return
	end
end

function this.GetDownCardSelect()
	local downCard = {}
	for i, v in pairs(cardTranTbl) do
		local oneCard = UIEventListener.Get(v.tran.gameObject).parameter
		if oneCard.cardType == CardType[1] or oneCard.cardType == CardType[2] then
			table.insert(downCard, oneCard)
			--selectDownCards[tonumber(oneCard.card)] = oneCard
			table.insert(selectDownCards, oneCard)
		end
	end
	return downCard
end

function this.PlaceCardFinish()
	if placeCard ~= nil then
		placeCard.gameObject:SetActive(false)
	end
	if prepare ~= nil then
		prepare.gameObject:SetActive(true)
	end
	this.XiangGongTip()
end

function this.XiangGongTip()
	isXiangGong = this.XiangGong()
	local errorTipLbl = child(this.transform, "Panel_Bottom/prepare/errorTipLbl")
	if errorTipLbl ~= nil then
		if isXiangGong then
			errorTipLbl.gameObject:SetActive(true)
		else
			errorTipLbl.gameObject:SetActive(false)
		end
	end
end

function this.XiangGong()
	local xianggong = LibLaiziCardLogic:CompareCards_Laizi(this.CardGroup(1), this.CardGroup(2))
	log("isXianggong: "..tostring(xianggong))
	if xianggong >= 0 then
		xianggong = LibLaiziCardLogic:CompareCards_Laizi(this.CardGroup(2), this.CardGroup(3))
		if xianggong >= 0 then
			return false
		end
	end
	return true
end

--之前客户端算的自动摆牌，现在不要了
---[[
function this.AtutoPlaceCardType()
	auto_place_card = Array.Clone(cardList)
	local first_five_cards = LibNormalCardLogic:GetMaxFiveCard(Array.Clone(auto_place_card))
	local card_type1 = LibNormalCardLogic:GetCardType(first_five_cards)
	local thirdCardLbl =  componentGet(child(this.transform, "Panel_TopRight/cardType1/thirdCardLbl"), "UILabel")
	local thirdCheckCardLbl =  componentGet(child(this.transform, "Panel_TopRight/cardType1/thirdCardLbl1"), "UILabel")
	if thirdCardLbl ~= nil or thirdCheckCardLbl ~=nil then
		thirdCardLbl.text = GStars_Normal_Type_Name[card_type1]
		thirdCheckCardLbl.text = GStars_Normal_Type_Name[card_type1]
	end
	auto_place_card = this.UpdateLeftCard(auto_place_card, first_five_cards)
	
	local next_five_card = LibNormalCardLogic:GetMaxFiveCard(Array.Clone(auto_place_card))
	local secondCardLbl =  componentGet(child(this.transform, "Panel_TopRight/cardType1/secondCardLbl"), "UILabel")
	local secondCheckCardLbl =  componentGet(child(this.transform, "Panel_TopRight/cardType1/secondCardLbl1"), "UILabel")
	local card_type2 = LibNormalCardLogic:GetCardType(next_five_card)
	if secondCardLbl ~= nil or secondCheckCardLbl ~= nil then
		secondCardLbl.text = GStars_Normal_Type_Name[card_type2]
		secondCheckCardLbl.text = GStars_Normal_Type_Name[card_type2]
	end
	auto_place_card = this.UpdateLeftCard(auto_place_card, next_five_card)
	
	local firstCardLbl =  componentGet(child(this.transform, "Panel_TopRight/cardType1/firstCardLbl"), "UILabel")
	local firstCheckCardLbl =  componentGet(child(this.transform, "Panel_TopRight/cardType1/firstCardLbl1"), "UILabel")
	local card_type3 = LibNormalCardLogic:GetCardType(auto_place_card)
	if firstCardLbl ~= nil or firstCheckCardLbl ~= nil then
		firstCardLbl.text = GStars_Normal_Type_Name[card_type3]
		firstCheckCardLbl.text = GStars_Normal_Type_Name[card_type3]
	end
	local last_three_card = Array.Clone(auto_place_card)
	first_auto_all_card = {first_five_cards[1], first_five_cards[2], first_five_cards[3],
							first_five_cards[4], first_five_cards[5],
							next_five_card[1], next_five_card[2], next_five_card[3],
							next_five_card[4], next_five_card[5],
							last_three_card[1], last_three_card[2], last_three_card[3],
							last_three_card[4], last_three_card[5]}
end
--]]

function this.RecommendCardUpdate()
	if recommend_cards == nil then
		return
	end
	for i = 1, 4 do
		if recommend_cards[i] == nil or #recommend_cards[i]["Cards"] < 13 then
			local tipObj = child(this.transform, "Panel_TopRight/cardType"..i)
			tipObj.gameObject:SetActive(false)
		else
			local tipObj = child(this.transform, "Panel_TopRight/cardType"..i)
			tipObj.gameObject:SetActive(true)
			local types = recommend_cards[i]["Types"]
			local thirdCardLbl =  componentGet(child(this.transform, "Panel_TopRight/cardType"..tostring(i).."/thirdCardLbl"), "UILabel")
			local thirdCheckCardLbl =  componentGet(child(this.transform, "Panel_TopRight/cardType"..tostring(i).."/thirdCardLbl1"), "UILabel")
			if thirdCardLbl ~= nil or thirdCheckCardLbl ~= nil then
				thirdCardLbl.text = GStars_Normal_Type_Name[types[1]]
				thirdCheckCardLbl.text = GStars_Normal_Type_Name[types[1]]
			end
			local secondCardLbl =  componentGet(child(this.transform, "Panel_TopRight/cardType"..tostring(i).."/secondCardLbl"), "UILabel")
			local secondCheckCardLbl =  componentGet(child(this.transform, "Panel_TopRight/cardType"..tostring(i).."/secondCardLbl1"), "UILabel")
			if secondCardLbl ~= nil or secondCheckCardLbl ~= nil  then
				secondCardLbl.text = GStars_Normal_Type_Name[types[2]]
				secondCheckCardLbl.text = GStars_Normal_Type_Name[types[2]]
			end
			local firstCardLbl =  componentGet(child(this.transform, "Panel_TopRight/cardType"..tostring(i).."/firstCardLbl"), "UILabel")
			local firstCheckCardLbl =  componentGet(child(this.transform, "Panel_TopRight/cardType"..tostring(i).."/firstCardLbl1"), "UILabel")
			if firstCardLbl ~= nil or firstCheckCardLbl ~= nil then
				firstCardLbl.text = GStars_Normal_Type_Name[types[3]]
				firstCheckCardLbl.text = GStars_Normal_Type_Name[types[3]]
			end
		end
	end
end

function this.CardGroup(dun)
	local tbl ={}
	if dun == 1 then
		for i = 1, 5 do
			tbl[i] = up_placed_cards[1][i].card
		end
	elseif dun == 2 then
		for i = 1, 5 do
			tbl[i] = up_placed_cards[2][i].card
		end
	elseif dun == 3 then
		for i = 1, 3 do
			tbl[i] = up_placed_cards[3][i].card
		end
	end
	return tbl
end

--检查是否与原始牌一致
function this.CheckSendCard(sendCards)
	local clone_cards = Array.Clone(sendCards)
	local src_cards = Array.Clone(cardList)
	for i = #src_cards, 1, -1 do
		for j = #clone_cards, 1, -1 do
			if src_cards[i] == clone_cards[j] then
				table.remove(src_cards, i)
				table.remove(clone_cards, j)
			end
		end
	end
	if #clone_cards > 0 then
		fast_tip.Show("发送牌与原始牌不符")
		return false
	end
	return true
end	
	
--只能用做有序的
function this.UpdateLeftCard(srcCard, temp)
	if type(temp) == "table" then
		Array.DelElements(srcCard, temp)
		--[[
		for j = #temp, 1, -1 do
			for i = #srcCard, 1, -1 do
				if temp[j] == srcCard[i] then
					table.remove(srcCard, i)
					table.remove(temp, j)
					break
				end
			end
		end
		--]]
	else
		for i = #srcCard, 1, -1 do
			if temp == srcCard[i] then
				table.remove(srcCard, i)
			end
		end
	end
	return srcCard
end

	
function this.Update()
	local timeEnd = room_data.GetPlaceCardTime()
	local curTime = Time.time
	local leftTime = timeEnd - curTime
	if leftTime <= 0 and curTime > timeSecond then
		--shisangshui_play_sys.PlaceCard(first_auto_all_card)
		--this.Hide()
		return
	end
	lastTime = lastTime + Time.deltaTime
	if lastTime >= 1 and leftTime <= 11 then
		ui_sound_mgr.PlaySoundClip("audio/baipaishijianshengyu10sjinggao")
		lastTime = 0
	end
	if math.floor(leftTime) < 0 then
		leftTime = 0
	end
	timeLbl.text = tostring(math.floor(leftTime))
	timeSpt.fillAmount = leftTime / room_data.GetSssRoomDataInfo().placeCardTime
end