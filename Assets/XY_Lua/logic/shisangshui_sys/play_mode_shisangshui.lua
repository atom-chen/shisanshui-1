--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion
require "logic/shisangshui_sys/table_component"
require "logic/shisangshui_sys/player_component"
require "logic/shisangshui_sys/prepare_special/prepare_special"
require "logic/shisangshui_sys/place_card/place_card"
require "logic/shisangshui_sys/resMgr_component"
require "logic/mahjong_sys/mode_components/mode_comp_base"
require "logic/hall_sys/openroom/room_data"
require "logic/shisangshui_sys/config/shisanshui_table_config"

play_mode_shisangshui = {}
local this = play_mode_shisangshui
this.cardData = nil
local instance = nil
this.resCardTable = {}

function play_mode_shisangshui.GetInstance()
    if (instance == nil) then
        instance = play_mode_shisangshui.create()
    end

    return instance
end

function play_mode_shisangshui.create(levelID)
--	this.LoadCardTable()
    local this = mode_base.create(levelID)
    this.Class = play_mode_shisangshui
    this.name = "play_mode_shisangshui"
	
	local gvbl = room_usersdata_center.GetViewSeatByLogicSeat
    local gvbln = room_usersdata_center.GetViewSeatByLogicSeatNum
    local gmls = room_usersdata_center.GetMyLogicSeat

    local ConstructComponents = nil

    local tableComponent = nil
    local resMgrComponet = nil

	this.base_init = this.Initialize
	local function OnPlayerEnter(tbl)
		log("有玩家进来了"..tostring(tbl))
        local logicSeat = tbl["_src"]
        local viewSeat = gvbl(logicSeat)
        if viewSeat == 1 then
        end  
		  Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_ENTER_GAME) 
    end
	
	
	local function OnPlayerReady(tbl)
		log("有人准备了")
	
		Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_GAME_READY)
	end
	
	local function OnGameStart(tbl)
		log("游戏开始")		
	--	Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_GAME_START)
	end
	
	local function OnGameDeal(tbl)
		log("发牌")
		--this.InitTable(function()
			-- player_component.CardList = tbl["_para"]["stCards"]
			-- recommendCards = tbl["_para"]["recommendCards"]
			-- log("牌的数据"..tostring(player_component.CardList))
		
			-- local isSpecial = tbl["_para"]["nSpecialType"]

			-- local score = tbl["_para"]["nSpecialScore"]
			-- if isSpecial == 0 then
			-- 	log("显示摆牌")
			-- 	place_card.Show(player_component.CardList, recommendCards)
			-- else
			-- 	log("显示特殊牌型")
			-- 	prepare_special.Show(player_component.CardList, isSpecial, 3, recommendCards)
			-- end
			-- Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_GAME_DEAL)
		--end)
	end
	
	local function OnAskChoose(tbl)
        log("摆牌")
        local timeo = tbl["timeo"]
		local timeEnd = Time.time + timeo
        room_data.SetPlaceCardTime(timeEnd)
		room_data.GetSssRoomDataInfo().placeCardTime = timeo
		Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.ASK_CHOOSE)
	end
	
	local function OnCompareStart(tbl)
		log("比牌开始")
		place_card.Hide()
		prepare_special.Hide()
	end
	
	local function OnCompareResult(tbl)
		log("比牌结果")
		if true then return end
		local myLogicSeat = tbl["_src"]
		local allCompareData = tbl["_para"]["stAllCompareData"]
		card_data_manage.allShootChairId = tbl["_para"]["nAllShootChairID"] ----全垒打玩家椅子id, 0表示没有全垒打
		
		
		local myViewSeat = room_usersdata_center.GetViewSeatByLogicSeat(myLogicSeat)
		--room_usersdata_center.GetViewSeatByLogicSeatNum 设置坐位号
		if allCompareData ~=nil then
		
			for i,v in ipairs(allCompareData) do
				local charid = v["chairid"]
				local viewSeatId = room_usersdata_center.GetViewSeatByLogicSeatNum(charid) --查找当前座位号
				log("+++++++桌子的座位号+++++++++++"..tostring(viewSeatId))
				local Player = tableComponent.GetPlayer(viewSeatId)
				Player.viewSeat = viewSeatId
				Player.compareResult = v

			end
		else
			log("比牌数据错误")
		end
			local myPlayer = tableComponent.GetPlayer(myViewSeat)
			card_data_manage.compareScores = tbl["_para"]["stCompareScores"]
		
		tableComponent.CompareStart(function()
		  --Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.COMPARE_RESULT)
		end)
	end
	
	local function OnCompareEnd(tbl)
		
		log("比牌结束")
		Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.COMPARE_END)
	end
	
	local function OnAutoPlay(tbl)
		log("托管")
		Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.AUTOPLAY)
	end
	
	local function OnGameRewards(tbl)
	--	log("结算")
--		Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_GAME_REWARDS)
	end
	
	local function OnSyncTable(tbl)
		log("重连同步表")
		Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_SYNC_TABLE)
	end

	local function OnChooseOK(tbl)
		log("摆牌完成")
		--需要扣牌
		tableComponent.ChooseOKCard(tbl)

		local viewSeat = gvbl(tbl["_src"])
		shisangshui_ui.ShowCard(viewSeat)
		Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.CHOOSE_OK)
	end

	local function OnPointsRefresh(tbl)
		log("数据刷新")
	--	Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.Point_Refresh)
	end
	local function OnGameEnd(tbl)
		log("游戏结束")
		this:ReSetAllStatus()
	--	shisangshui_play_sys.ReadyGameReq()--发送准备好的状态进入下一局
		Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_GAME_END)
	end
	
	local function OnUserLeave(tbl)
		log("用户离开")
		local viewSeat = gvbl(tbl._src)
	if roomdata_center.isStart == true then
		shisangshui_ui.SetPlayerMachine(viewSeat, true)
	else
		shisangshui_ui.HidePlayer(viewSeat)
	end
		Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_GAME_LEAVE)
	end

    function this:Initialize()
        this.base_init()
        Notifier.regist(cmdName.F1_ENTER_GAME, OnPlayerEnter)--玩家进入
        Notifier.regist(cmdName.F1_GAME_READY,OnPlayerReady)--玩家准备
        Notifier.regist(cmdName.F1_GAME_START,OnGameStart)--游戏开始
        Notifier.regist(cmdName.F1_GAME_DEAL,OnGameDeal)--发牌
		Notifier.regist(cmdName.ASK_CHOOSE, OnAskChoose) --摆牌
		Notifier.regist(cmdName.CHOOSE_OK,OnChooseOK)
		Notifier.regist(cmdName.COMPARE_START,OnCompareStart)  --比牌开始
		Notifier.regist(cmdName.COMPARE_RESULT,OnCompareResult) --比牌结果
		Notifier.regist(cmdName.COMPARE_END,OnCompareEnd) -- 比牌结束
		Notifier.regist(cmdName.AUTOPLAY,OnAutoPlay) --某人(chair1)修改了他的托管状态设置
		
        Notifier.regist(cmdName.F1_GAME_REWARDS,OnGameRewards)--结算
        Notifier.regist(cmdName.Point_Refresh,OnPointsRefresh)--数据刷新
        Notifier.regist(cmdName.F1_GAME_END,OnGameEnd)--游戏结束
        Notifier.regist(cmdName.F1_SYNC_TABLE,OnSyncTable)--重连同步表
		Notifier.regist(cmdName.F1_GAME_LEAVE,OnUserLeave)--游戏结束离开通知。
	
    end

    this.base_uninit = this.Uninitialize

    function this:Uninitialize()
        this.base_uninit()

        Notifier.remove(cmdName.F1_ENTER_GAME, OnPlayerEnter)--玩家进入
        Notifier.remove(cmdName.F1_GAME_READY,OnPlayerReady)--玩家准备
        Notifier.remove(cmdName.F1_GAME_START,OnGameStart)--游戏开始
        Notifier.remove(cmdName.F1_GAME_DEAL,OnGameDeal)--发牌
      
		Notifier.remove(cmdName.ASK_CHOOSE,OnAskChoose) --摆牌
		Notifier.remove(cmdName.COMPARE_START,OnCompareStart)  --比牌开始
		Notifier.remove(cmdName.COMPARE_RESULT,OnCompareResult) --比牌结果
		Notifier.remove(cmdName.COMPARE_END,OnCompareEnd) -- 游戏结束
		Notifier.remove(cmdName.AUTOPLAY,OnAutoPlay) --某人(chair1)修改了他的托管状态设置
		Notifier.remove(cmdName.CHOOSE_OK,OnChooseOK)
        Notifier.remove(cmdName.F1_GAME_REWARDS,OnGameRewards)--结算
        Notifier.remove(cmdName.Point_Refresh,OnPointsRefresh)--数据刷新
        Notifier.remove(cmdName.F1_GAME_END,OnGameEnd)--游戏结束
        Notifier.remove(cmdName.F1_SYNC_TABLE,OnSyncTable)--重连同步表
		Notifier.remove(cmdName.F1_GAME_LEAVE,OnUserLeave)--游戏结束离开通知。
        instance = nil
    end

	function this.InitTable(callback)
		tableComponent.InitCard(callback)
	end

	function this.LoadCardTable(args)
		local gameOjb =  GameObject.Find("MJScene")
		if gameOjb ~= nil then
			GameObject.Destroy(gameOjb)
		end
		local roomData = room_data.GetSssRoomDataInfo()
		local peopleNum = roomData.people_num
		local sceneRoot = shisanshui_table_config.tableEnum[peopleNum]
		log("SceneRoot:"..tostring(sceneRoot).."peopleNum"..tostring(peopleNum))
		resCardTable = newNormalObjSync("Prefabs/Scene/shisangshui/"..tostring(sceneRoot))
   		newobject(resCardTable)
	end

	
	 --[[--
     * @Description: 组装所需要的组件
     ]]
    function ConstructComponents()
        log("ConstructComponents---------------------------------------")
     	this.LoadCardTable()
     	tableComponent = this:AddComponent(table_component.create())
		tableComponent.InitPlayerTransForm()
		log("++++++++++++++++++Create Component")        
    end

    function this:PreloadObjects()

        --预加载场景物体
    end

    function this:ReSetAllStatus()
    	log("重置游戏")
    	tableComponent.ReSetAll()
    end

    -- 执行下组装
    ConstructComponents()

	function this.GetTabComponent()
		return tableComponent
	end

    return this
end






