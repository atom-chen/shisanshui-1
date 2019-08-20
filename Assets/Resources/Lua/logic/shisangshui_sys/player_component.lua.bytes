player_component = {}

function player_component.create()
	require "logic/mahjong_sys/mode_components/mode_comp_base"
	require "logic/mahjong_sys/mode_components/comp_operatorcard"
	require "logic/shisangshui_sys/resMgr_component"
	require "logic/shisangshui_sys/card_define"
	local this = mode_comp_base.create()
	this.Class = player_component
	this.name = "player_component"
	
	this.playerObj = nil --Íæ¼Ò¶ÔÏó
	this.viewSeat = -1		--×øÎ»
	this.CardList = {}		--ÊÖÅÆ¶ÔÏó
	this.compareResult = {} --±ÈÅÆÊý¾Ý
	this.compareScores = {}
	this.base_init = this.Initialize
	this.Group1 = nil
	this.Group2 = nil
	this.Group3 = nil
	this.resMgrComponet = nil
	this.CardOrgineTrans = {}
	this.usersdata = nil
	
	function this:Initialize()
		this.base_init()
	end
	
	--翻牌
	function this:PlayerGroupCard(group)
		local groupTrans =	this.playerObj.transform:FindChild(group)
		local cards = groupTrans.transform:GetComponentsInChildren(typeof(UnityEngine.MeshFilter))
		log("PlayFirstGroupCard"..tostring(cards.Length))

		for j = 0, cards.Length -1 do
			local cardObj = cards[j]
			local y = cardObj.transform.localRotation.eulerAngles.y
			cardObj.transform:DOLocalRotate(Vector3(0, y, 0), 0.05, DG.Tweening.RotateMode.Fast)

			--组牌放大处理(To Do)
		--	cardObj.transform:DOScale(Vector3(2, 2, 2), 0.6):SetEase(DG.Tweening.Ease.OutBounce):OnComplete(function ()
		--		cardObj.transform:DOScale(Vector3.one, 0.2)
		--	end)			
		end
	end

	--获取第一墩牌
	function this:showFirstCardByType()
		local dataTable = {}
		local cardTable = {}
		local cardType = this.compareResult["nFirstType"]
	--	local chairid = this.compareResult["chairid"]
		if tonumber(cardType) > 0 then
			local stCards = this.compareResult["stCards"]
			if stCards == nil or #stCards < 1 then return end
			for i = 1 ,#stCards do
				if i > 10 and i < 14 then
					table.insert(cardTable,stCards[i])
				end
			end
			dataTable.cardTable = cardTable
			dataTable.type = cardType
			dataTable.chairid = this.viewSeat
			local position = this.playerObj.transform:FindChild("2d_card_point").transform.position
			dataTable.nguiPosition = Utils.WorldPosToScreenPos(position)
			return dataTable
		end
	end

	--获取第二墩牌
	function this:showSecondCardByType()
		local dataTable = {}
		local cardTable = {}
		local cardType = this.compareResult["nSecondType"]
	--	local chairid = this.compareResult["chairid"]
		if tonumber(cardType) > 0 then
			local stCards = this.compareResult["stCards"]
			if stCards == nil or #stCards < 1 then return end
			for i = 1 ,#stCards do
				if i > 5 and i < 11 then
					table.insert(cardTable,stCards[i])
				end
			end
			dataTable.cardTable = cardTable
			dataTable.type = cardType
			dataTable.chairid = this.viewSeat
			local position = this.playerObj.transform:FindChild("2d_card_point").transform.position
			dataTable.nguiPosition = Utils.WorldPosToScreenPos(position)
			return dataTable
		end
	end

	--获取第三墩牌
	function this:showThreeCardByType()
		local dataTable = {}
		local cardTable = {}
		local cardType = this.compareResult["nThirdType"]
	--	local chairid = this.compareResult["chairid"]
		if tonumber(cardType) > 0 then
			local stCards = this.compareResult["stCards"]
			if stCards == nil or #stCards < 1 then return end
			for i = 1 ,#stCards do
				if i > 0 and i < 6 then
					table.insert(cardTable,stCards[i])
				end
			end
			dataTable.cardTable = cardTable
			dataTable.type = cardType
			dataTable.chairid = this.viewSeat
			local position = this.playerObj.transform:FindChild("2d_card_point").transform.position
			dataTable.nguiPosition = Utils.WorldPosToScreenPos(position)
			return dataTable
		end
	end

	--获取打枪列表
	function this:GetMyShootingList()
		local chairid = this.compareResult["chairid"]
		if this.isMe then
			local shootList = this.compareResult["stShoots"]
			if shootList ~= nil then
				return shootList
			end
		end
		return nil
	end

	--设置材质
	function this:SetCardMesh(cards)
		if this.compareResult == nil then
			log("SetCard Mesh Error")
		end
		local stCards = cards
		if cards == nil then
			stCards = this.compareResult["stCards"]
			if stCards == nil or #stCards < 1 then return end
		end
		
		local meshtable1 = {}
		local meshtable2 = {}
		local meshtable3 = {}
		for i = 1 ,#stCards do
			local cardIndex = stCards[i]
			local meshValue = card_define.cardDic[cardIndex]
			local mesh = this.resMgrComponet.GetCardMesh(meshValue)
			if i >0 and i < 6 then --ºó¶Õ
				table.insert(meshtable3,mesh)
			elseif i > 5 and i < 11 then  --ÖÐ¶Õ
				table.insert(meshtable2,mesh)
			elseif i > 10 and i < 14 then --Ç°¶Õ
				table.insert(meshtable1,mesh)
			end
		end
		
		if this.Group1 == nil then 
			this.Group1 = this.playerObj.transform:FindChild("Group1")
		end
		this:SetCardMeshWithGroup(this.Group1,meshtable1)
		
		if this.Group2 == nil then 
			this.Group2 = this.playerObj.transform:FindChild("Group2")
		end
		this:SetCardMeshWithGroup(this.Group2,meshtable2)
		
		if this.Group3 == nil then 
			this.Group3 = this.playerObj.transform:FindChild("Group3")
		end
		this:SetCardMeshWithGroup(this.Group3,meshtable3)
	end
	
	function this:SetCardMeshWithGroup(group,mesh)
		local cardMeshFilterArray = group.transform:GetComponentsInChildren(typeof(UnityEngine.MeshFilter))
			for j = 0, cardMeshFilterArray.Length -1 do
				local subCardMeshFilter = cardMeshFilterArray[j]
				subCardMeshFilter.mesh = mesh[j+1]
			end
	end
	
	--理牌
	function this:shuffle(callback)
		local xoffset = 0
		local yoffset = 0
		xoffset =  -13 /2
	for k,cardObj in pairs(this.CardList) do
		cardObj.transform.parent.parent = this.playerObj.transform
		cardObj.transform.parent.localPosition = Vector3(xoffset,yoffset,0)
		cardObj.transform.parent.localEulerAngles = Vector3(0,0,0)
		cardObj.transform.localPosition = Vector3(0,0,0)
		cardObj.transform.localEulerAngles = Vector3(0,0,180)
		cardObj.gameObject:SetActive(false)
		xoffset = xoffset + 1
		yoffset = yoffset + 0.01
	end
		
		log("CardList"..tostring(#this.CardList))
		coroutine.start(function()
		for k,vv in pairs(this.CardList) do
			vv.gameObject:SetActive(true)
			coroutine.wait(0.01)
		end
		--[[
		for i,v in pairs(this.CardList) do
			v.transform.parent:DOLocalMoveZ(4,0.2,false)
			v.transform.parent:DOLocalMoveZ(0,0.2,false)
			coroutine.wait(0.1)
		end
		
		]]
		
	--	this:CardRest(this.CardOrgineTrans)
	--[[	
		local group3 = this.playerObj.transform:FindChild("Group3")
		this:ShowCardShanXing(group3,1,180)
		local group2 = this.playerObj.transform:FindChild("Group2")
		this:ShowCardShanXing(group2,6,180)
		local group1 = this.playerObj.transform:FindChild("Group1")
		this:ShowCardShanXing(group1,11,180)
		]]
	
		
		
		
	--[[	
		local group1 = this.playerObj.transform:FindChild("Group1")
		this:ShowCardShanXing(group1,1,1.2,0.3,6,-45)
		local group2 = this.playerObj.transform:FindChild("Group2")
		this:ShowCardShanXing(group2,4,1.2,0.7,3,-45)
		local group3 = this.playerObj.transform:FindChild("Group3")
		this:ShowCardShanXing(group3,9,1.2,1,0,-45)
	]]		
	
	
	
		if callback ~= nil then 
			callback()
		end	
	end
	
	)
	end
	
	function this.ShowAllCard(rotateZ)
		this:CardRest(this.CardOrgineTrans)
		rotateZ = tonumber(rotateZ)
		local group3 = this.playerObj.transform:FindChild("Group3")
		this:ShowCardShanXing(group3,1,rotateZ)
		local group2 = this.playerObj.transform:FindChild("Group2")
		this:ShowCardShanXing(group2,6,rotateZ)
		local group1 = this.playerObj.transform:FindChild("Group1")
		this:ShowCardShanXing(group1,11,rotateZ)
	end
	

	--理牌动画
	function this:ShowCardShanXing(parentObj,index,rotateZ)
		local count  = index + 4
		if index == 11 then
			 count  = index + 2
		end
		
		for i = index ,count do
			local obj = this.CardList[i]
			parentObj.transform.localPosition = Vector3(0,0,0)
			obj.transform.parent.localPosition = Vector3(0,0,0)
			
			obj.transform.parent.parent = parentObj.transform
			local x = obj.transform.localRotation.eulerAngles.x
			local y = obj.transform.localRotation.eulerAngles.y
			local z = obj.transform.localRotation.eulerAngles.z
			obj.transform.localEulerAngles = Vector3(x,y,rotateZ)
		end 
	
	end

	--玩家重置
	function this:PlayerReset()
		--[[for k,cardObj in pairs(this.CardList) do	
			cardObj.transform.parent.localEulerAngles = Vector3(0,0,0)
			cardObj.transform.localEulerAngles = Vector3(0,0,180)
			cardObj.gameObject:SetActive(false)
		end]]
	this.playerObj:SetActive(false)
	this.compareResult = {}
	log("++++++++++玩家数据重置,座位号:"..tostring(this.viewSeat))
	end

	--牌重置
	function this:CardRest(transform)
		for i = 1,#this.CardList do
			local trans = transform[i]
			local card = this.CardList[i]
			card.transform.localPosition = trans.cardPosition
			card.transform.localRotation = trans.cardRotation
			card.transform.localScale = trans.cardScale
		end
	end

	return this
end


