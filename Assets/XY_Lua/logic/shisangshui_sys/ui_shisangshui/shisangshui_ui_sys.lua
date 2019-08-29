--[[--
 * @Description: 麻将UI 控制层
 * @Author:      ShushingWong
 * @FileName:    mahjong_ui_sys.lua
 * @DateTime:    2017-06-20 15:59:13
 ]]
require "logic/shisangshui_sys/shoot_ui/shoot_ui"
require "logic/shisangshui_sys/card_data_manage"
require "logic/shisangshui_sys/common_card/common_card"
require "logic/shisangshui_sys/small_result/small_result"
require "logic/shisangshui_sys/special_card_show/special_card_show"
require "logic/shisangshui_sys/play_mode_shisangshui"
require "logic/shisangshui_sys/place_card/place_card"
require "logic/shisangshui_sys/lib_recomand"
--require "logic/hall_sys/openroom/room_data"

shisangshui_ui_sys = {}

local this = shisangshui_ui_sys

local gvbl = room_usersdata_center.GetViewSeatByLogicSeat
local gvbln = room_usersdata_center.GetViewSeatByLogicSeatNum
local gmls = room_usersdata_center.GetMyLogicSeat
local result_para_data = {}

local function OnPlayerEnter( tbl )
	log(GetTblData(tbl))
	local viewSeat = gvbl(tbl["_src"])
	log("本地座位号："..viewSeat)
	local logicSeat = room_usersdata_center.GetLogicSeatByStr(tbl["_src"])
	local userdata = room_usersdata.New()
	userdata.name = tbl["_para"]["_uid"]
	userdata.coin = tbl["_para"]["score"]["coin"]
	userdata.viewSeat = viewSeat
	userdata.logicSeat = logicSeat
	userdata.vip  = 0
	userdata.headurl = "http://img.qq1234.org/uploads/allimg/150612/8_150612153203_7.jpg"
	local uid = tbl["_para"]["_uid"]	


--加载头像
	local param={["uid"]=uid,["type"]=1}
	http_request_interface.getGameInfo(param,function (code,m,str) 
			local s=string.gsub(str,"\\/","/")
	        local t=ParseJsonStr(s)

	        userdata.zhengzhoumj = t["data"]
	        userdata.uid = uid
			userdata.name = t["data"].nickname
			userdata.coin = coin
			userdata.vip  = 0

			http_request_interface.getImage({tbl["_para"]["_uid"]},function(code2,m2,str2)
				log(tostring(str2))
				local s2=string.gsub(str2,"\\/","/")
	        	local t2=ParseJsonStr(s2)

	        	if t2["data"][1].imagetype == 1 then
	        		userdata.headurl = "http://img.qq1234.org/uploads/allimg/150612/8_150612153203_7.jpg"
	        	elseif t2["data"][1].imagetype == 2 then
					userdata.headurl = t2["data"][1].imageurl--"http://img.qq1234.org/uploads/allimg/150612/8_150612153203_7.jpg"
				--	this.getuserimage(tx,itype,iurl)
				end
				room_usersdata_center.AddUser(logicSeat,userdata)
				
				shisangshui_ui.SetPlayerInfo( viewSeat, userdata)
				
				log("有玩家进来了，加载完头像了")
				--waiting_ui.Hide()
				if callback~=nil then
					callback()
				end
				end)
	    end)
	

	
--	room_usersdata_center.AddUser(room_usersdata_center.GetLogicSeatByStr(tbl["_src"]),userdata)
	

	log("----------------------------------------------------SetPlayerInfo")
--	shisangshui_ui.SetPlayerInfo( viewSeat, userdata)
	
	shisangshui_ui.ShowDissolveRoom(false)
	shisangshui_ui.ShowInviteBtn(true)
	--金币场不显示，以后处理
	if viewSeat == 1 then
		shisangshui_ui.SetGameInfo("房号", roomdata_center.roomnumber)
		shisangshui_ui.SetLeftCard()--显示房间局数
		shisangshui_ui.ShowDissolveRoom(true)--显有房主可以解散房间
	end
	
	--是否选择加一色坐庄，如果是，显示庄的头像
	local roomInfo = room_data.GetSssRoomDataInfo()
	if roomInfo.isZhuang == true then
		if tonumber(logicSeat) == 1 then --如果是P1房主则设置庄家标志
			shisangshui_ui.SetBanker(viewSeat)
		end
	end
	log("OnPlayerEnter------------------"..tostring(tonumber(gmls)))
	
end

local function OnPlayerReady( tbl )
--	small_result.Hide()
	log(GetTblData(tbl))
	local logicSeat =  room_usersdata_center.GetLogicSeatByStr(tbl["_src"])
	local viewSeat = gvbl(tbl["_src"])
	shisangshui_ui.SetLeftCard()--显示房间局数
	if viewSeat == 1 then
		shisangshui_ui.ResetAll()
		shisangshui_ui.SetLeftCard()--显示房间局数
	end
	shisangshui_ui.SetPlayerReady(viewSeat, true)
	log("玩家准备好"..tostring(logicSeat))
	
	Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_GAME_READY)
end

local function OnGameStart( tbl )
	shisangshui_ui.ShowInviteBtn(false)
	shisangshui_ui.ShowDissolveRoom(false)
	shisangshui_ui.IsShowBeiShuiBtn(false)
	roomdata_center.isStart = true
	ui_sound_mgr.PlaySoundClip("common/duijukaishi")

	shisangshui_ui.ResetAll()
	
	
	Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_GAME_START)
end


local function OnPlayStart( tbl )
	 

	Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_GAME_PLAYSTART)
end

local function OnCompareStart(tbl)
	shisangshui_ui.ShowInviteBtn(false)
	shisangshui_ui.ShowDissolveRoom(false)
	coroutine.start(function ()
		 --播放比牌动画
   		shisangshui_ui.PlayerStartGameAnimation()
    	log("开始播放比牌动画")
    	coroutine.wait(1)
   		Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.COMPARE_START)
	end)
end

local function OnGameDeal( tbl )
	shisangshui_ui.SetAllPlayerReady(false)
	shisangshui_ui.IsShowBeiShuiBtn(false)
	shisangshui_ui.ShowCard(0)

	shisangshui_ui.DealCard(nil, function()
		player_component.CardList = tbl["_para"]["stCards"]
		recommendCards = tbl["_para"]["recommendCards"]
		log("牌的数据"..tostring(player_component.CardList))
	
		local isSpecial = tbl["_para"]["nSpecialType"]

		local score = tbl["_para"]["nSpecialScore"]
		if isSpecial == 0 then
			log("显示摆牌")
			place_card.Show(player_component.CardList, recommendCards)
		else
			log("显示特殊牌型")
			prepare_special.Show(player_component.CardList, isSpecial, 3, recommendCards)
		end
		Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_GAME_DEAL)
	end)

	--log(GetTblData(tbl))
	--shisangshui_ui.HideOperTips()
	--Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_GAME_DEAL)
end

local function OnGameLaiZi( tbl )
	--log(GetTblData(tbl))
	ui_sound_mgr.PlaySoundClip("common/laizi")
	shisangshui_ui.ShowHunPai(tbl["_para"]["laizi"][1])
end


local function OnPlayCard( tbl )
	local operPlayViewSeat = gvbl(tbl._src)
	if operPlayViewSeat ==1 then
		shisangshui_ui.HideOperTips()
	end
end

local function OnGiveCard( tbl )
	shisangshui_ui.HideOperTips()
end


local function OnGameRewards( tbl )
	
	
--	local viewSeat = gvbl(tbl["_src"])

--	shisangshui_ui.SetPlayerCoin(viewSeat, tbl["_para"][1].score)
	
	
	
	log(GetTblData(tbl))
	shisangshui_ui.DisablePlayerLightFrame()--关闭头像的光圈
	shisangshui_ui.HideDunCardType()
	--shisangshui_ui.HideOperTips()
	log("结算。。。。t")
	if tbl ~= nil and tbl._para ~= nil then
		result_para_data.data = tbl._para
		small_result.Show(result_para_data.data)
		result_para_data.state = 0
	end
	if tbl == nil or tbl._para == nil then
		log("tbl == nil or tbl._para = nil")
	end
	
	if tbl ~= nil and tbl._para ~= nil then
		local rewards = tbl._para.rewards
		if rewards ~= nil and #rewards > 0 then
			for i,reward in ipairs(rewards) do
				local viewSeat = gvbl(reward["_chair"])
				local score = reward["all_score"]
				log("总分： "..tostring(score))
				if score == nil then score = 0 end
				shisangshui_ui.SetPlayerCoin(viewSeat, tonumber(score))
				log("座位号:"..tostring(viewSeat).." 总积分:"..tostring(score))
			end
			
		end
	end
	
	Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_GAME_REWARDS) --确认完成结算完成消息
end



local function OnGameEnd( tbl )
--	roomdata_center.isStart = false
end

local function OnAskReady( tbl )
	local timeo = tbl.timeo
	local timeEnd = timeo
	log("等待举手, 时间："..tostring(timeo).."  结束时间： "..tostring(timeEnd))
	room_data.SetReadyTime(timeEnd)
	Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_ASK_READY)
end

local function OnSyncBegin( tbl )
	log("重连同步开始")
	log(GetTblData(tbl))

	Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_SYNC_BEGIN)
end

--重连同步
local function OnSyncTable( tbl )
	log("重连同步表")
	log(GetTblData(tbl))

	--[[
		self.m_stageNext = {
            prepare     = "mult",       --加倍
            mult        = "deal",       --发牌
            deal        = "choose",     --出牌(选择牌型)
            choose      = "compare",    --比牌
            compare     = "reward",     --结算
            reward      = "gameend",    --游戏结算
            gameend     = "prepare",    --下一局
        }
    else
        self.m_stageNext = {
            prepare     = "deal",       --发牌
            deal        = "choose",     --出牌(选择牌型)
            choose      = "compare",    --比牌
            compare     = "reward",     --结算
            reward      = "gameend",    --游戏结算
            gameend     = "prepare",    --下一局
        }
		]]

	local ePara = tbl._para
	local game_state = ePara.sCurrStage 		-- 游戏阶段
	local player_state = ePara.stPlayerState 	-- 玩家状态
	local player_UID = ePara.stPlayerUid 	-- 玩家状态
	
	local play_mshisangshui = play_mode_shisangshui.GetInstance()
	local tableCtl = play_mshisangshui.GetTabComponent()
	local playerList = tableCtl.PlayerList
	
	local stCards = ePara.stCards
	roomdata_center.isStart = true
	if game_state == "prepare" then  
		--牌隐藏
		for i = 1, #playerList do
			playerList[i].playerObj:SetActive(false)
		end		--准备阶段
		--显示准备提示准备
		for i=1,#player_state do
			--准备按扭
			local state = player_state[i]
			local userData = room_usersdata_center.GetUserByUid(player_UID[i])
			if state ~= nil and userData ~= nil then
				local viewSeat = userData.viewSeat
				if state == 2 then
					shisangshui_ui.SetPlayerReady(viewSeat, true)
					if viewSeat == 1 then
						shisangshui_ui.HideReadyBtn()
					end
				elseif state == 1 then
					shisangshui_ui.SetPlayerReady(viewSeat, false)
					if viewSeat == 1 then
						shisangshui_ui.ShowReadyBtn()
						--标记不用投票可直接退出
						if roomdata_center.nCurrJu <= 1 then
							roomdata_center.isStart = false
						end
					end
				end
			end
		end
	else
		shisangshui_ui.HideReadyBtn()
		shisangshui_ui.SetAllPlayerReady(false)
		for i = 1, #playerList do
			playerList[i].playerObj:SetActive(true)
		end
		--摆牌阶段
		if (game_state == "deal" or game_state == "choose") then
			if stCards == nil then
				log("重连牌为空")
				return
			end
			--未摆牌
			if ePara.nChoose == 0 then
				local timeo = ePara.nleftTime
				room_data.SetPlaceCardSerTime(timeo)
				
				local nSpecialType = ePara.nSpecialType
				if nSpecialType ~= nil and nSpecialType > 0 then
					prepare_special.Show(stCards, nSpecialType, 3, ePara.recommendCards)
				else
					place_card.Show(stCards, ePara.recommendCards)
				end
			--已摆牌
			elseif ePara.nChoose == 1 or  ePara.nChoose == 2 then
				place_card.Hide()
				playerList[1].ShowAllCard(0)
				for i = 2, #playerList do
					playerList[i].ShowAllCard(180)
				end
				
				playerList[1]:SetCardMesh(stCards)
			end
		end
		
		if game_state == "compare" then 
			place_card.Hide()
			for i = 1, #playerList do
				playerList[i].playerObj:SetActive(true)
			end
			local stCompare = ePara.stCompare
			local stAllCompareData = stCompare.stAllCompareData
			for i = 1, #playerList do
				playerList[i].ShowAllCard(0)
				local _, logicId = room_usersdata_center.GetUserByViewSeat(i)
				local comp_cards = stAllCompareData[i].stCards
				playerList[logicId]:SetCardMesh(comp_cards)
			end
			
		end

	end

	Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_SYNC_TABLE)
end


local function OnSyncEnd( tbl )
	log("重连同步结束")
	log(GetTblData(tbl))

	Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_SYNC_END)
end

local function OnLeaveEnd( tbl )
	log(GetTblData(tbl))

	local viewSeat = gvbl(tbl._src)
	if roomdata_center.isStart == true then
		shisangshui_ui.SetPlayerMachine(viewSeat, true)
	else
		shisangshui_ui.HidePlayer(viewSeat)
	end
	
	Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_GAME_LEAVE)
end

local function OnPlayerOffline( tbl )
	log(GetTblData(tbl))
	
	local viewSeat = gvbl(tbl._src)
--	shisangshui_ui.SetPlayerLineState(viewSeat, false)

	Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_GAME_OFFLINE)
end

--比牌的结果
local function OnCompareResult(tbl)
   card_data_manage.compareResultPara = tbl["_para"]

   log("比牌结果")
	local myLogicSeat = tbl["_src"]
	local allCompareData = tbl["_para"]["stAllCompareData"]
	--card_data_manage.allShootChairId = tbl["_para"]["nAllShootChairID"] ----全垒打玩家椅子id, 0表示没有全垒打
	
	
	local myViewSeat = room_usersdata_center.GetViewSeatByLogicSeat(myLogicSeat)
	if allCompareData ~=nil then
	
		for i,v in ipairs(allCompareData) do
			local charid = v["chairid"]
			local viewSeatId = room_usersdata_center.GetViewSeatByLogicSeatNum(charid) --查找当前座位号
			log("+++++++桌子的座位号+++++++++++"..tostring(viewSeatId))
			local Player = shisangshui_ui.GetPlayer(viewSeatId)
			Player.viewSeat = viewSeatId
			Player.compareResult = v

		end
	else
		log("比牌数据错误")
	end
	
	shisangshui_ui.CompareStart(function()
	  
	end)
 
end

local function OnGroupCompareResult(scoreData)
	local index = scoreData.index
	local ntotalScore = scoreData.totallScore
	log("+++++++++++++++++++OnGroupCompareResult+++++++++"..tostring(index))
	local scoreStr = ""
	local scoreExtStr = ""
	local score = 0
	local scoreExt = 0
	local allScore = 0
	if tonumber(index) == 1 then
		scoreStr = "nFirstScore"
		scoreExtStr = "nFirstScoreExt"

	elseif tonumber(index) == 2 then 
		scoreStr = "nSecondScore"
		scoreExtStr = "nSecondScoreExt"
	elseif tonumber(index) == 3 then 
		scoreStr = "nThirdScore"
		scoreExtStr = "nThirdScoreExt"
	end
	

	local compareScores = card_data_manage.compareResultPara["stCompareScores"]
	if compareScores ~= nil then
		for i,v in ipairs(compareScores) do
			if scoreStr ~= "" and scoreExtStr ~= "" then 
				score = score + v[scoreStr]
				scoreExt = scoreExt + v[scoreExtStr]
			end
		end
		
		log("++++++++++compareScores"..tostring(score).."+++++"..tostring(scoreExt))
		shisangshui_ui.SetGruopScord(index, score ,scoreExt,allScore)
	end
	
	if tonumber(index) == 4 then
		if ntotalScore ~= nil then
			shisangshui_ui.SetGruopScord(index, score ,scoreExt,ntotalScore)
		end
	end

end

--显示每一墩牌的数据 
local function OnShowPokerCard(tbl)
	if tbl == nil then
		log("OnShowPokerCard....tbl == nil")
		return
	end
	local position = tbl.nguiPosition
	--this.ShowCommonCard(tbl.cardTable,tbl.type, position)
--	shisangshui_ui.SetPlayerLightFrame(tbl.chairid)--暂时不显示框
	log("显示每一墩牌的数据")
end


--//////////////////////////投票 start////////////////////////////

local function OnVoteDraw(tbl)
	local viewSeat = gvbl(tbl["_src"])
	vote_quit_ui.AddVote(tbl._para.accept, viewSeat)
	shisangshui_ui.voteView:AddVote(tbl._para.accept, viewSeat)
	Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.OnVoteDraw)
end

local function OnVoteStart(tbl)
	log("OnVoteStart~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
	local viewSeat = gvbln(tbl["_para"].who)
	local time = tbl._para.timeout
	local name = room_usersdata_center.GetUserByViewSeat(viewSeat).name
	if viewSeat ~= 1 then
		vote_quit_ui.Show(name, function(value) 
			if value == true then
				large_result.Hide()
				place_card.Hide()
				small_result.Hide()
			end
			shisangshui_play_sys.VoteDrawReq(value, time)
		 end, roomdata_center.MaxPlayer())
	end
	shisangshui_ui.voteView:Show(roomdata_center.MaxPlayer())
	Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.OnVoteStart)
end

local function OnVoteEnd()
	vote_quit_ui.Hide()
	shisangshui_ui.voteView:Hide()
	Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.OnVoteEnd)
end

--更新玩家积分
local function RoomSumScore(tbl)
	log("更新玩家积分")
	local _para = tbl._para
	
	local viewSeat = gvbl(tbl["_src"])
	local score = _para["nRoomSumScore"]
	--local viewSeat = _para["_chair"]
	log("总分： "..tostring(score))
	if score == nil then score = 0 end
	shisangshui_ui.SetPlayerCoin(viewSeat, tonumber(score))
	log("座位号:"..tostring(viewSeat).." 总积分:"..tostring(score))
	
	Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.ROOM_SUM_SCORE)
end

--//////////////////////////投票 end//////////////////////////////

local function OnPointsRefresh( tbl )
	--[[
	log("=======数据刷新----------"..tostring(tbl))
	local viewSeat = gvbl(tbl["_src"])

	shisangshui_ui.SetPlayerCoin(viewSeat, tbl["_para"][1].score)

	if viewSeat == 1 then
		Notifier.dispatchCmd(cmdName.MSG_COIN_REFRESH, tbl["_para"][1].score)	
	end
]]
	Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_POINTS_REFRESH)
end

--聊天
local function OnPlayerChat( tbl )
	log(GetTblData(tbl))

	local viewSeat = gvbl(tbl._src)
	local contentType = tbl["_para"]["contenttype"]
	local content = tbl["_para"]["content"]
	local givewho = gvbl(tbl["_para"]["givewho"])

	if roomdata_center.isStart == true then		
	else		
	end
	shisangshui_ui.DealChat(viewSeat,contentType,content,givewho)

	Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_GAME_CHAT)
end

--提示闲家选择倍数
local function OnAskMult(tbl)
	log("提示闲家选择倍数")
	shisangshui_ui.SetBeiShuBtnCount()
	local roomInfo = room_data.GetSssRoomDataInfo()
	if roomInfo.isZhuang == true then
		sessionData = player_data.GetSessionData()
		if tonumber(sessionData["_chair"]) == 1 then
			shisangshui_ui.IsShowBeiShuiBtn(false)
		else
			shisangshui_ui.IsShowBeiShuiBtn(true)
		end
	end
	
	Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.FuZhouSSS_ASKMULT)
end

--选择倍数回调
local function OnMult(tbl)
	
	local para = tbl["_para"]
	local p1 = para["p1"]
	local p2 = para["p2"]
	local p3 = para["p3"]
	local p4 = para["p4"]
	local p5 = para["p5"]
	local p6 = para["p6"]
	local viewSeat = 1
	local value = 0
	if p1 ~= nil then
		viewSeat =  gvbln(1)
		value = p1
	elseif p2 ~= nil  then
		viewSeat = gvbln(2)
		value = p2
	elseif p3 ~= nil then
		viewSeat =  gvbln(3)
		value = p3
	elseif p4 ~= nil then
		viewSeat =  gvbln(4)
		value = p4
	elseif p5 ~= nil then
		viewSeat =  gvbln(5)
		value = p5
	elseif p6 ~= nil then
		viewSeat =  gvbln(6)
		value = p6
	end
		shisangshui_ui.SetBeiShu(viewSeat,value)
		log("个人选择倍数回调，座位"..tostring(viewSeat).."倍数"..tostring(value))
	Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.FuZhouSSS_MULT)
end

--所有人倍数回调
local function OnAllMult(tbl)
	log("所有人倍数回调")
	--[[
		local para = tbl["_para"]
		if para ~= nil then
			for i,v in ipairs(para) do
				local viewSeat =  gvbln(i)
				shisangshui_ui.SetBeiShu(viewSeat,v)
			end
		end
	
	]]
	Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.FuZhouSSS_ALLMULT)
end

--显示特殊排型图标
local function OnSpecialCardType(tbl)
	shisangshui_ui.ShowSpecialCardIcon(tbl)
end

function this.Init()
	log("-----------Start Regist Event UI ---------------!!!!!!!!!!")
	Notifier.regist(cmdName.F1_ENTER_GAME, OnPlayerEnter)--玩家进入
	Notifier.regist(cmdName.F1_GAME_READY,OnPlayerReady)--玩家准备
	Notifier.regist(cmdName.F1_GAME_START,OnGameStart)--游戏开始

	Notifier.regist(cmdName.F1_GAME_PLAYSTART,OnPlayStart)--打牌开始
	Notifier.regist(cmdName.F1_GAME_DEAL,OnGameDeal)--发牌

	Notifier.regist(cmdName.F1_GAME_GIVECARD,OnGiveCard)--摸牌
	Notifier.regist(cmdName.F1_GAME_PLAY,OnPlayCard)--出牌


	Notifier.regist(cmdName.F1_GAME_REWARDS,OnGameRewards)--结算
	Notifier.regist(cmdName.F1_POINTS_REFRESH,OnPointsRefresh)--玩家金币更新
	Notifier.regist(cmdName.F1_GAME_END,OnGameEnd)--游戏结束
	Notifier.regist(cmdName.F1_ASK_READY,OnAskReady)--通知准备

	Notifier.regist(cmdName.F1_SYNC_BEGIN,OnSyncBegin)--重连同步开始
	Notifier.regist(cmdName.F1_SYNC_TABLE,OnSyncTable)--重连同步表
	Notifier.regist(cmdName.F1_SYNC_END,OnSyncEnd)--重连同步结束
	
	Notifier.regist(cmdName.F1_SYNC_TABLE,OnSyncTable)--重连同步表

	Notifier.regist(cmdName.F1_GAME_LEAVE,OnLeaveEnd)--用户离开
	Notifier.regist(cmdName.F1_GAME_OFFLINE,OnPlayerOffline)--用户掉线
	
	Notifier.regist(cmdName.COMPARE_START, OnCompareStart)  --比牌开始
	Notifier.regist(cmdName.COMPARE_RESULT,OnCompareResult) --比牌结果
	Notifier.regist(cmdName.First_Group_Compare_result,OnGroupCompareResult) --第一组比牌完成通知
	Notifier.regist(cmdName.Second_Group_Compare_result,OnGroupCompareResult)
	Notifier.regist(cmdName.Three_Group_Compare_result,OnGroupCompareResult)
	
	Notifier.regist(cmdName.ShowPokerCard,OnShowPokerCard)
	Notifier.regist(cmdName.ShootingPlayerList,ShootingPlayerList)
	Notifier.regist(cmdName.F1_GAME_CHAT,OnPlayerChat)--用户聊天
	Notifier.regist(cmdName.F1_POINTS_REFRESH,OnPointsRefresh)--玩家金币更新

	Notifier.regist(cmdName.F1_VOTE_DRAW, OnVoteDraw)		--请求和局/投票
	Notifier.regist(cmdName.F1_VOTE_START, OnVoteStart)		--请求和局开始
	Notifier.regist(cmdName.F1_VOTE_END, OnVoteEnd)		--请求和局结束	
	
	Notifier.regist(cmdName.ROOM_SUM_SCORE, RoomSumScore)		--重入更新积分
	Notifier.regist(cmdName.SpecialCardType,OnSpecialCardType) -- 在特殊排型上显一个张特殊牌型的图标
	
	Notifier.regist(cmdName.FuZhouSSS_ASKMULT,OnAskMult) --等待闲家选择倍数 
	Notifier.regist(cmdName.FuZhouSSS_MULT, OnMult)  -- 选择倍数通知(回复自己选择倍数)
	Notifier.regist(cmdName.FuZhouSSS_ALLMULT, OnAllMult)  --选择倍数通知(所有人的选择倍数)
	
end

function this.UInit()
	Notifier.remove(cmdName.F1_ENTER_GAME, OnPlayerEnter)--玩家进入
	Notifier.remove(cmdName.F1_GAME_READY,OnPlayerReady)--玩家准备
	Notifier.remove(cmdName.F1_GAME_START,OnGameStart)--游戏开始

	Notifier.remove(cmdName.F1_GAME_PLAYSTART,OnPlayStart)--打牌开始
	Notifier.remove(cmdName.F1_GAME_DEAL,OnGameDeal)--发牌

	Notifier.regist(cmdName.CHOOSE_OK,OnChooseOK)
	Notifier.remove(cmdName.F1_GAME_GIVECARD,OnGiveCard)--摸牌
	Notifier.remove(cmdName.F1_GAME_PLAY,OnPlayCard)--出牌

	Notifier.remove(cmdName.F1_GAME_REWARDS,OnGameRewards)--结算
	Notifier.remove(cmdName.F1_POINTS_REFRESH,OnPointsRefresh)--玩家金币更新
	Notifier.remove(cmdName.F1_GAME_END,OnGameEnd)--游戏结束
	Notifier.remove(cmdName.F1_ASK_READY,OnAskReady)--通知准备

	Notifier.remove(cmdName.F1_SYNC_BEGIN,OnSyncBegin)--重连同步开始
	Notifier.remove(cmdName.F1_SYNC_TABLE,OnSyncTable)--重连同步表
	Notifier.remove(cmdName.F1_SYNC_END,OnSyncEnd)--重连同步结束

	Notifier.remove(cmdName.F1_GAME_LEAVE,OnLeaveEnd)--用户离开
	Notifier.remove(cmdName.F1_GAME_OFFLINE,OnPlayerOffline)--用户掉线

	Notifier.remove(cmdName.COMPARE_START,OnCompareStart)  --比牌开始
	Notifier.remove(cmdName.COMPARE_RESULT,OnCompareResult) --比牌结果
	Notifier.remove(cmdName.First_Group_Compare_result,OnGroupCompareResult) --第一组比牌完成通知
	Notifier.remove(cmdName.Second_Group_Compare_result,OnGroupCompareResult)
	Notifier.remove(cmdName.Three_Group_Compare_result,OnGroupCompareResult)
	Notifier.remove(cmdName.ShowPokerCard,OnShowPokerCard)
	Notifier.remove(cmdName.ShootingPlayerList,ShootingPlayerList)
	Notifier.remove(cmdName.F1_POINTS_REFRESH,OnPointsRefresh)--玩家金币更新

	Notifier.remove(cmdName.F1_GAME_CHAT,OnPlayerChat)--用户聊天
	Notifier.remove(cmdName.F1_VOTE_DRAW, OnVoteDraw)		--请求和局/投票
	Notifier.remove(cmdName.F1_VOTE_START, OnVoteStart)		--请求和局开始
	Notifier.remove(cmdName.F1_VOTE_END, OnVoteEnd)		--请求和局结束	
	
	
	Notifier.remove(cmdName.ROOM_SUM_SCORE, RoomSumScore)		--重入更新积分
	
	Notifier.remove(cmdName.SpecialCardType,OnSpecialCardType) -- 在特殊排型上显一个张特殊牌型的图标
	Notifier.remove(cmdName.FuZhouSSS_ASKMULT,OnAskMult) --等待闲家选择倍数 
	Notifier.remove(cmdName.FuZhouSSS_MULT, OnMult)  -- 选择倍数通知(回复自己选择倍数)
	Notifier.remove(cmdName.FuZhouSSS_ALLMULT, OnAllMult)  --选择倍数通知(所有人的选择倍数)
end

function this.GetHeadPic(textureComp, url )
	log("GetHeadPic "..url)

	DownloadCachesMgr.Instance:LoadImage(url,function( code,texture )
		--log("!!!!!!!!!state:"..tostring(state))
		textureComp.mainTexture = texture 
	end)
end

--打枪
function ShootingPlayerList(player_list)
--[[
	coroutine.start(function()
		log("打枪完成, 开始特殊牌型展示 ")
		
		for i, v in ipairs(player_list) do
			if v.compareResult["nSpecialType"] ~= 0 and v.compareResult["nSpecialType"] ~= nil then
				special_card_show.Show(v.compareResult["stCards"], v.compareResult["nSpecialType"], 2)
				coroutine.wait(2)
			end
		end
		
		log("打枪完成, 开始我给垒打展示 ")
		if card_data_manage.allShootChairId ~= 0 then
			animations_sys.PlayAnimation(shisangshui_ui.transform,"daqiang_quanleida","homer",100,100,false)
			coroutine.wait(2)
		end
		
		--结算动画处理
		local totalPoints = {}
		for i,player in ipairs(player_list) do
			local points = player.compareResult["nTotallScore"]
			table.insert(totalPoints,points)
			shisangshui_ui.ShowPlayerTotalPoints(player.viewSeat,points)
		end
		table.sort(totalPoints)
		local maxTotalPoint =  totalPoints[#totalPoints]
		if maxTotalPoint ~= nil then
			for i,player in ipairs(player_list) do
				if tonumber(maxTotalPoint) == tonumber(player.compareResult["nTotallScore"]) then
				shisangshui_ui.SetPlayerLightFrame(player.viewSeat)
				coroutine.wait(2.9)
				shisangshui_ui.DisablePlayerLightFrame()
				coroutine.wait(0.1)
				break
				end
			end
		end
	
		
		
		shisangshui_play_sys.CompareFinish()--告诉服务器
		Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.COMPARE_RESULT)--比牌结束
		log("====================开始结算=======================")
	end)	
	]]
end

function this.ShowShootKuang(tran, callback)
	animations_sys.PlayAnimation(tran,"shisanshui_shoot_kuang","bomb box",100,100,false, callback)
end

function this.ShowShoot(tran, callback)
	animations_sys.PlayAnimation(tran,"shisanshui_shoot","Shoot",100,100,false, callback)
end

function this.ShowShootHole(tran, callback)
	animations_sys.PlayAnimation(tran,"shisanshui_shoot","Shoot2",100,100,false, callback)
end

function this.ShowCommonCard(cards, nSpecitialType, pos)
	common_card.Show(cards, nSpecitialType, pos)
end

function this.getuserimage(tx,itype,iurl)
    itype=itype or data_center.GetLoginRetInfo().imagetype
    iurl=iurl or data_center.GetLoginRetInfo().imageurl
    local imagetype=itype
    local imageurl=iurl
    if  tonumber(imagetype)~=2 then
        imageurl="https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=190291064,674331088&fm=58"  
    end
    http_request_interface.getimage(imageurl,tx.width,tx.height,function (states,tex)tx.mainTexture=tex end)
end

local function OnChooseOK(tbl)
		log("摆牌完成")
		--需要扣牌
		local logicSeat = room_usersdata_center.GetLogicSeatByStr(tbl["_src"])
		shisangshui_ui.ShowCard(logicSeat)

		--Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.CHOOSE_OK)
	end