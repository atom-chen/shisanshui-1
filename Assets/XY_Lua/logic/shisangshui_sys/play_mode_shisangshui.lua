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
		print("有玩家进来了"..tostring(tbl))
	
	--	this.InitTable(function()end)
	
        local logicSeat = tbl["_src"]
        local viewSeat = gvbl(logicSeat)
        if viewSeat == 1 then
        --[[    local logicSeat_number = room_usersdata_center.GetLogicSeatByStr(logicSeat)            
            local mjDirObj = compTable:GetMJDirObj()
            if mjDirObj ~= nil then
                local dirTran = child(mjDirObj.transform, "dark_dir/direction_0"..tostring(logicSeat_number))
                local dirLightTran = child(mjDirObj.transform, "light_dir/direction_"..tostring(logicSeat_number))
                if dirTran ~= nil then
                    dirTran.gameObject:SetActive(true)
                end
                if dirLightTran ~= nil then
                    dirLightTran.gameObject:SetActive(true)
                    for i=1,4 do
                        local t = child(dirLightTran, "direction_0"..tostring(i))
                        table.insert(lightDirTbl,t)
                    end
                end
            end
			]]
        end  
		  Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_ENTER_GAME) 
    end
	
	
	local function OnPlayerReady(tbl)
		print("有人准备了")
	
		Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_GAME_READY)
	end
	
	local function OnGameStart(tbl)
		print("游戏开始")		
	--	Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_GAME_START)
	end
	
	local function OnGameDeal(tbl)
		print("发牌")
		
		this.InitTable(function()
			player_component.CardList = tbl["_para"]["stCards"]
			recommendCards = tbl["_para"]["recommendCards"]
			print("牌的数据"..tostring(player_component.CardList))
		
			local isSpecial = tbl["_para"]["nSpecialType"]

			local score = tbl["_para"]["nSpecialScore"]
			if isSpecial == 0 then
				print("显示摆牌")
				place_card.Show(player_component.CardList, recommendCards)
			else
				print("显示特殊牌型")
				prepare_special.Show(player_component.CardList, isSpecial, 3, recommendCards)
			end
			
			Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_GAME_DEAL)
		end)
		
	end
	
	local function OnAskChoose(tbl)
        print("摆牌")
        local timeo = tbl["timeo"]
		local timeEnd = Time.time + timeo
        room_data.SetPlaceCardTime(timeEnd)
		room_data.GetSssRoomDataInfo().placeCardTime = timeo
		Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.ASK_CHOOSE)
	end
	
	local function OnCompareStart(tbl)
		print("比牌开始")
		place_card.Hide()
		prepare_special.Hide()
	end
	
	local function OnCompareResult(tbl)
		print("比牌结果")
		local myLogicSeat = tbl["_src"]
		local allCompareData = tbl["_para"]["stAllCompareData"]
		card_data_manage.allShootChairId = tbl["_para"]["nAllShootChairID"] ----全垒打玩家椅子id, 0表示没有全垒打
		
		
		local myViewSeat = room_usersdata_center.GetViewSeatByLogicSeat(myLogicSeat)
		--room_usersdata_center.GetViewSeatByLogicSeatNum 设置坐位号
		if allCompareData ~=nil then
		
			for i,v in ipairs(allCompareData) do
				local charid = v["chairid"]
				local viewSeatId = room_usersdata_center.GetViewSeatByLogicSeatNum(charid) --查找当前座位号
				print("+++++++桌子的座位号+++++++++++"..tostring(viewSeatId))
				local Player = tableComponent.GetPlayer(viewSeatId)
				Player.viewSeat = viewSeatId
				Player.compareResult = v

			end
		else
			print("比牌数据错误")
		end
			local myPlayer = tableComponent.GetPlayer(myViewSeat)
			card_data_manage.compareScores = tbl["_para"]["stCompareScores"]
		
		tableComponent.CompareStart(function()
		  --Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.COMPARE_RESULT)
		end)
	end
	
	local function OnCompareEnd(tbl)
		
		print("比牌结束")
		Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.COMPARE_END)
	end
	
	local function OnAutoPlay(tbl)
		print("托管")
		Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.AUTOPLAY)
	end
	
	local function OnGameRewards(tbl)
	--	print("结算")
--		Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_GAME_REWARDS)
	end
	
	local function OnSyncTable(tbl)
		print("重连同步表")
		Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_SYNC_TABLE)
	end

	local function OnChooseOK(tbl)
		print("摆牌完成")
		--需要扣牌
		tableComponent.ChooseOKCard(tbl)

		Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.CHOOSE_OK)
	end

	local function OnPointsRefresh(tbl)
		print("数据刷新")
	--	Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.Point_Refresh)
	end
	local function OnGameEnd(tbl)
		print("游戏结束")
		this:ReSetAllStatus()
	--	shisangshui_play_sys.ReadyGameReq()--发送准备好的状态进入下一局
		Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_GAME_END)
	end
	
	local function OnUserLeave(tbl)
		print("用户离开")
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
		print("SceneRoot:"..tostring(sceneRoot).."peopleNum"..tostring(peopleNum))
		resCardTable = newNormalObjSync("Prefabs/Scene/shisangshui/"..tostring(sceneRoot))
   	--  	resCardTable = newNormalObjSync("Prefabs/Scene/shisangshui/SceneRoot5")
   		newobject(resCardTable)
	end

	
	 --[[--
     * @Description: 组装所需要的组件
     ]]
    function ConstructComponents()
        print("ConstructComponents---------------------------------------")
        -- 组装
     --   this:AddComponent(comp_clickevent.create())
     --   compResMgr = this:AddComponent(comp_resMgr.create())
     --  compMJItemMgr = this:AddComponent(comp_mjItemMgr.create())
     --   compTable = this:AddComponent(comp_table.create())
     --   compPlayerMgr = this:AddComponent(comp_playerMgr.create())
     	this.LoadCardTable()
     	tableComponent = this:AddComponent(table_component.create())
    -- 	resMgrComponet = this:AddComponent(resMgr_component.create())
    -- 	resMgrComponet.LoadCardMesh()
		tableComponent.InitPlayerTransForm()
		print("++++++++++++++++++Create Component")

	--	this.InitTable(function()
	--		tableComponent.ReSetAll()
	--		end)
        
    end

    function this:PreloadObjects()

        --预加载场景物体
    end

    function this:ReSetAllStatus()
    	print("重置游戏")
    	tableComponent.ReSetAll()
    end

    -- 执行下组装
    ConstructComponents()

	function this.GetTabComponent()
		return tableComponent
	end

    return this
end






