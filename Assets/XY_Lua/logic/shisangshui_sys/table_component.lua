table_component = {}

function table_component.create()
	require "logic/mahjong_sys/mode_components/mode_comp_base"
	local this = mode_comp_base.create()
	this.Class = table_component
	this.name = "table_component"
	this.PlayerList = {} 	--玩家列表
	this.PlayerTransformList = {}
	this.tableCenter = nil
	this.cardTranPool = {}	
	this.gun = nil
	this.CardModelTrans = {}

	local pokerObj = nil

	this.resMgrComponet = resMgr_component.create()
	this.resMgrComponet.LoadCardMesh()


 	this.base_init = this.Initialize
 	this.base_uninit = this.Uninitialize
	function this:Initialize()
		this.base_init()
	end

	--[[--
	 * @Description: 初始化手牌  
	 ]]
	function this.InitCardPool(callback)
		if this.cardTranPool == nil or #this.cardTranPool < 1 then
			for i = 1, #this.PlayerList * 13 do 
				local cardPrefab = newNormalObjSync("Prefabs/Scene/shisangshui/Card")
				local cardTran =  newobject(cardPrefab).transform
				cardTran.parent = this.tableCenter.transform
				cardTran.localPosition = Vector3(0, i/20, 0)
				cardTran.localEulerAngles = Vector3(0, 0, 180)
				table.insert(this.cardTranPool, cardTran)
			end
		end

		pokerObj = child(this.tableCenter.transform, "Poker_Animaiton").gameObject
		pokerObj:SetActive(false)
		this.DealAnimation(callback)
	end

	--发牌动作
	function  this.DealAnimation(callback)
		local count = 1
		this.ResetDeal()
		ui_sound_mgr.PlaySoundClip("audio/xipai")

		coroutine.start(function ()
			pokerObj:SetActive(true)
			coroutine.wait(1)
			
			pokerObj:SetActive(false)
			this.tableCenter:SetActive(true)
			this.ShowDeal()
			for i =1, #this.cardTranPool / #this.PlayerList do
				for j ,Player in ipairs(this.PlayerList) do				
					--需要边移动边旋转
					local tmpTran = Player.playerObj.transform
					this.cardTranPool[count]:DOMove(tmpTran.position, 0.3, false)
					local toRotate = this.cardTranPool[count].localRotation + Vector3(0, i*50, 0)
					this.cardTranPool[count]:DOBlendableLocalRotateBy(toRotate, i*0.05, DG.Tweening.RotateMode.Fast)
					count = count + 1
				end
				coroutine.wait(0.01)
			end

			coroutine.wait(0.5)
			this.ResetDeal()
			if callback ~= nil then 
				callback()
				callback = nil			
			end
		end)
	end

	--初始化开局人数，创建开局人数列表
	function this.InitPlayerTransForm()
		this.gun = GameObject.Find("qiang")
		this.gun:SetActive(false)
		this.tableCenter = GameObject.Find("tableCenter")
		if this.tableCenter == nil then 
			log("tableCenter is nil Error")
		end
		if #this.PlayerList > 0 then 
			log("===InitPlayerTransFormError"..tostring(#this.PlayerList)) --
			return 
		end
		local PlayerTransformList = {}
		local room_num = room_data.GetSssRoomDataInfo().people_num
		for i = 1, room_num do
			local player = GameObject.Find("Player_"..tostring(i))
			PlayerTransformList[i] = player
		end
		--local PlayerTransformList = GameObject.FindGameObjectsWithTag("CardPlayer")
		for i = 1, #PlayerTransformList do
			local player = player_component.create()
			player.playerObj = PlayerTransformList[i]
			--log("玩家数组："..PlayerTransformList[i].name)
			player.viewSeat = i
			
			--local logicSeat = room_usersdata_center.SetMyLogicSeat(player.viewSeat)
			--player.usersdata = room_usersdata_center.usersDataList[logicSeat]
			player.resMgrComponet = this.resMgrComponet
			local cards = player.playerObj.transform:GetComponentsInChildren(typeof(UnityEngine.MeshFilter))
			log("==============InitPlayerTransForm cards Array Length"..tostring(cards.Length))
			if cards ~= nil then 
				for j = 0, cards.Length -1 do
					local cardObj = cards[j]
					table.insert(player.CardList, cardObj)
					if i == 1 then
						local cardPosition = cardObj.transform.localPosition
						local cardRotation = cardObj.transform.localRotation
						local cardScale = cardObj.transform.localScale
						local cardTrans = {}
						cardTrans.cardPosition = cardPosition
						cardTrans.cardRotation = cardRotation
						cardTrans.cardScale = cardScale
						table.insert(this.CardModelTrans,cardTrans)
					end
				end
			end
			player.playerObj:SetActive(false)
			player.CardOrgineTrans = this.CardModelTrans
			table.insert(this.PlayerList,player)
			table.insert(this.PlayerTransformList,PlayerTransformList[i].transform)
			if player == nil then
				log("Error Player is nil")
				return
			end
		end		
	end

	--[[--
	 * @Description: 获取玩家  
	 ]]
	function this.GetPlayer(index)
		return this.PlayerList[index]
	end

	--[[--
	 * @Description: 初始化牌形  
	 ]]
	function this.InitCard(callback)		
		this.InitCardPool(function()
			this.tableCenter:SetActive(false)
			if this.PlayerList ~= nil then				
				for i, player in pairs(this.PlayerList) do
					player.playerObj:SetActive(true)																									  
					player:shuffle()	 --摆牌
				end
			end
			
			coroutine.start(function()
				coroutine.wait(0.8)
				if callback ~= nil then
					callback()	
					callback = nil
					this.tableCenter:SetActive(false)
				end	
			end)
		end)			
	end

	--[[--
	 * @Description: 摆牌ok处理   
	 ]]
	function this.ChooseOKCard(tbl)
		log("============摆牌ok处理============="..tostring(tbl._src))
	--	local logicSeat = room_usersdata_center.GetLogicSeatByStr(tbl._src)
		local viewSeat = room_usersdata_center.GetViewSeatByLogicSeat(tbl._src) --查找当前座位号
		if this.PlayerList ~= nil then
			for i, player in pairs(this.PlayerList) do
				log("viewSeat-----------------------------------"..tostring(viewSeat))
				log("player.viewSeat-----------------------------------"..tostring(player.viewSeat))
				if tostring(viewSeat) == tostring(player.viewSeat) then
					player.playerObj:SetActive(true)
					player.ShowAllCard(180)
					break
				end
			end
		end		
	end


	--[[--
	 * @Description: 牌形比较处理 
	 ]]
	function this.CardCompareHandler()
		local scoreData = {}    --积分数据表
 
		local firstSort = {}    --第一次排序表
		local secondSort = {}   --第二次排序表
		local threeSort = {}    --第三次排序表
		local sortIndex = nil
		for i,v in ipairs(this.PlayerList) do
			sortIndex = v.compareResult["nOpenFirst"]
			table.insert(firstSort, sortIndex)
			sortIndex = v.compareResult["nOpenSecond"]
			table.insert(secondSort, sortIndex)
			sortIndex = v.compareResult["nOpenThird"]
			table.insert(threeSort, sortIndex)
		end
		table.sort(firstSort)
		table.sort(secondSort)
		table.sort(threeSort)

		for j,k in ipairs(firstSort) do
			for i ,Player in ipairs(this.PlayerList) do
				if tonumber(Player.compareResult["nOpenFirst"]) == tonumber(k) then
					if tonumber(Player.compareResult["nSpecialType"]) < 1 then    	--检查是不是特殊牌型,特殊牌型不翻牌
						Player:PlayerGroupCard("Group1")
						local cards = Player:showFirstCardByType() 					--这里在通知UI界面显示相应排型
						Notifier.dispatchCmd(cmdName.ShowPokerCard,cards)
						coroutine.wait(1)
						break
					end
				end
			end
		end
		--这里增加一个事件，通知UI更新第一墩的积分数据
		-- scoreData.index = 1
		-- scoreData.totallScore = 0			
		-- Notifier.dispatchCmd(cmdName.First_Group_Compare_result, scoreData)
		
		
		for j,k in ipairs(secondSort) do
			for i ,Player in ipairs(this.PlayerList) do
				if tonumber(Player.compareResult["nOpenSecond"]) == tonumber(k) then
					if tonumber(Player.compareResult["nSpecialType"]) < 1 then 	--检查是不是特殊牌型,特殊牌型不翻牌
						Player:PlayerGroupCard("Group2")
						local cards = Player:showSecondCardByType() 			--这里在通知UI界面显示相应排型
						Notifier.dispatchCmd(cmdName.ShowPokerCard, cards)
						coroutine.wait(1)
						break
					end
				end
			end
		end
		--这里增加一个事件，通知UI更新第二墩的积分数据
		-- scoreData.index = 2
		-- scoreData.totallScore = 0
		-- Notifier.dispatchCmd(cmdName.Second_Group_Compare_result, scoreData)

		
		for j,k in ipairs(threeSort) do
			for i ,Player in ipairs(this.PlayerList) do
				if tonumber(Player.compareResult["nOpenThird"]) == tonumber(k) then
					if tonumber(Player.compareResult["nSpecialType"]) < 1 then --检查是不是特殊牌型,特殊牌型不翻牌
						Player:PlayerGroupCard("Group3")
						local cards = Player:showThreeCardByType() ----这里在通知UI界面显示相应排型
						Notifier.dispatchCmd(cmdName.ShowPokerCard,cards)
						coroutine.wait(1)
						break
					end
				end
			end
		end
		
		--这里增加一个事件，通知UI更新第三墩的积分数据
		-- scoreData.index = 3
		-- scoreData.totallScore = 0
		-- Notifier.dispatchCmd(cmdName.Three_Group_Compare_result, scoreData)
		--总分
		local myPlayer = this.GetPlayer(1)
		local totallScore = myPlayer.compareResult["nTotallScore"]
		log("++++++++++++++++++totallScorefasdfsfsf++++++++++++++++++++++++++++="..tostring(totallScore))
		
		-- scoreData.index = 4
		-- scoreData.totallScore = totallScore
		-- Notifier.dispatchCmd(cmdName.Three_Group_Compare_result,scoreData)
		
		if compareFinshCallback ~= nil then
			compareFinshCallback()
			compareFinshCallback = nil
		end
		
		--摆牌结束，通知UI播入打枪动画跟特殊牌型动画
		--Notifier.dispatchCmd(cmdName.ShootingPlayerList,this.PlayerList)
		--播放打枪动画
		this.PlayGunAnim()

		--播放特殊牌形动画		
	end


	--[[--
	 * @Description: 比牌开始  
	 ]]
	function this.CompareStart(compareFinshCallback)
		log("CompareStart......................")
		-- for i ,Player in pairs(this.PlayerList) do
		-- 	Player:SetCardMesh() --设置牌的值
		-- 	--为特殊牌型显示一个展示图标
		-- 	if tonumber(Player.compareResult["nSpecialType"]) > 0 then
		-- 		local data = {}
		-- 		data.viewSeat = Player.viewSeat
		-- 		data.position = Utils.WorldPosToScreenPos(Player.playerObj.transform.position)
		-- 		Notifier.dispatchCmd(cmdName.SpecialCardType, data)
		-- 	end			
		-- end

--		coroutine.start(this.CardCompareHandler)
	end


	function this.sortPlayerList(sortKey)
		local test = true;
		table.sort(this.PlayerList, function (player1,player2)
			local firstType1 = player1.compareResult[sortKey]
			local firstType2 = player2.compareResult[sortKey]			
			--log("firstType1"..tostring(firstType1).."secondType"..tostring(firstType2))
			if firstType1 < firstType2 then
				return true
			elseif firstType1 == firstType2 then
				--牌形相同，再做进一步判断，暂时返回true
				--log("++++++++++++the same Group ++++++++++"..tostring(sortKey))
				--[[
				if test == true then
					test = false
					return test
				else
					test =true
					return test
				end
				]]
				return false
			else
				return false
			end	
		end)
		return this.PlayerList
	end


	--进入下一局重置所有的动作
	function this.ReSetAll()
		this.ResetPlayerList()
		log("重置所有比牌动作")
	end

	--重置发牌动作
	function this.ResetDeal()
		this.tableCenter:SetActive(true)
		for i = 1, #this.cardTranPool do
			this.cardTranPool[i].transform.parent = this.tableCenter.transform
			this.cardTranPool[i].transform.localPosition = Vector3(0,i/20,0)
			this.cardTranPool[i].transform.localEulerAngles = Vector3(0,0,180)
			this.cardTranPool[i].gameObject:SetActive(false)
		end
	end
	
	function this.ShowDeal()
		for i = 1, #this.cardTranPool do
			this.cardTranPool[i].gameObject:SetActive(true)
		end
	end

	--重置发牌动作
	function this.ResetPlayerList()
		for i ,Player in pairs(this.PlayerList) do
			Player:PlayerReset()
		end
	end
	
	
	
	--播放打枪动画及以后流程
	function this.PlayGunAnim()				
		local animator =  componentGet(this.gun.transform,"Animator")
		if this.gun ~= nil and animator ~=nil then	
			local isPlayed = false
			
			coroutine.wait(1.5)
			coroutine.start(function()
				for i,v in ipairs(this.PlayerList) do
					if v.compareResult["stShoots"] ~= nil then
						local shootList = v.compareResult["stShoots"]--找出每个人的打枪列表
						if shootList ~= nil and #shootList > 0 then
							if isPlayed ==false then
								log("打枪全屏动画")
								animations_sys.PlayAnimation(shisangshui_ui.transform, "shisanshui_shoot_kuang", "bomb box", 100, 100, false)
								--ui_sound_mgr.PlaySoundClip("audio/daqiang")  ---打枪
								ui_sound_mgr.PlaySoundClip("dub/daqiang_nv")  ---打枪提示
								isPlayed = true
								coroutine.wait(2.0)
								ui_sound_mgr.PlaySoundClip("audio/daqiangzhunbei")  ---打枪准备
								coroutine.wait(0.5)
							end
						
							for j,k in ipairs(shootList) do
								local shootTargetViewSeat = room_usersdata_center.GetViewSeatByLogicSeatNum(k)
								local shootTargeObj = nil
								shootTargeObj = this.GetPlayer(shootTargetViewSeat).playerObj

								if shootTargeObj ~= nil then
									animator.transform.parent.localPosition = v.playerObj.transform.localPosition
									animator.transform.parent:LookAt(shootTargeObj.transform)   --把枪指向要打的人的对象
									
								    --for i =1 ,3 do --打枪三次
									local screenPos =  Utils.WorldPosToScreenPos(shootTargeObj.transform.position)  
									screenPos.z = 0
									if this.gun.gameObject.activeSelf == false then
										this.gun:SetActive(true)
									end
									animator:SetBool("gun_fire", true)
									ui_sound_mgr.PlaySoundClip("audio/daqiang")  --枪声
									coroutine.wait(0.1)
									local anim1 = animations_sys.PlayAnimationByScreenPosition(shisangshui_ui.transform,screenPos.x + tonumber(math.random(-30,30)),screenPos.y + tonumber(math.random(-30,30)),"shisanshui_shoot","Shoot2",100,100,false,callback)
									ui_sound_mgr.PlaySoundClip("audio/daqiang")  --枪声
									coroutine.wait(0.1)
									local anim2 = animations_sys.PlayAnimationByScreenPosition(shisangshui_ui.transform,screenPos.x + tonumber(math.random(-30,30)),screenPos.y + tonumber(math.random(-30,30)),"shisanshui_shoot","Shoot2",100,100,false,callback)
									ui_sound_mgr.PlaySoundClip("audio/daqiang")  --枪声
									coroutine.wait(0.1)
									local anim3 = animations_sys.PlayAnimationByScreenPosition(shisangshui_ui.transform,screenPos.x + tonumber(math.random(-30,30)),screenPos.y + tonumber(math.random(-30,30)),"shisanshui_shoot","Shoot2",100,100,false,callback)
									animator:SetBool("gun_fire", false)
									this.gun:SetActive(false)
									coroutine.wait(1)
									animations_sys.StopPlayAnimation(anim1)
									animations_sys.StopPlayAnimation(anim2)
									animations_sys.StopPlayAnimation(anim3)
									
								end
							end
						end
					end
				end
				this.gun:SetActive(false)
				
				
				for i, v in ipairs(this.PlayerList) do
					if v.compareResult["nSpecialType"] ~= 0 and v.compareResult["nSpecialType"] ~= nil then
						log("打枪完成, 开始特殊牌型展示")
						special_card_show.Show(v.compareResult["stCards"], v.compareResult["nSpecialType"], 2)
						coroutine.wait(2)
					end
				end
		
				if card_data_manage.allShootChairId ~= 0 then
					log("播放全垒打动画")
					animations_sys.PlayAnimation(shisangshui_ui.transform,"daqiang_quanleida","homer",100,100,false)
					ui_sound_mgr.PlaySoundClip("dub/quanleida_nv")  ---全垒打
					coroutine.wait(2)
				end
				
		
				shisangshui_play_sys.CompareFinish()--告诉服务器
				Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.COMPARE_RESULT)--比牌结束
				log("====================开始结算=======================")
				
				--结算动画处理
				local totalPoints = {}
				for i,player in ipairs(this.PlayerList) do
					local points = player.compareResult["nTotallScore"]
					table.insert(totalPoints,points)
					shisangshui_ui.ShowPlayerTotalPoints(player.viewSeat,points)
				end
				table.sort(totalPoints)
				local maxTotalPoint =  totalPoints[#totalPoints]
				if maxTotalPoint ~= nil then
					for i,player in ipairs(this.PlayerList) do
						if tonumber(maxTotalPoint) == tonumber(player.compareResult["nTotallScore"]) then
							shisangshui_ui.SetPlayerLightFrame(player.viewSeat)
							coroutine.wait(1)
							shisangshui_ui.DisablePlayerLightFrame()
							--	coroutine.wait(0.1)
							break
						end
					end
				end
			end)
		end
	end
	

	return this
end
