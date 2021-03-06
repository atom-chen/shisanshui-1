--[[--
 * @Description: 麻将玩法处理
 * @Author:      shine
 * @FileName:    mahjong_play_sys.lua
 * @DateTime:    2017-06-14 17:37:45

   1. 进入房间  
      event: enter
      发送进入房间请求 --> SOCKET_REQ_ENTER
      进入房间回复     --> SOCKET_ENTER_ROOM
      更新头像信息     --> VIEW_UPDATE_HEAD_INFO
      显示邀请好友按钮 --> VIEW_SHOW_INVITEWLAYER
      进入满员移除邀请好友按钮 --> VIEW_REMOVE_INVITELAYER

   2. 准备 
       event: go_ready
       server通知前段进行准备操作 --> SOCKET_ASK_READY
       event: ready
       请求准备   --> SOCKET_REQ_READY
       通知玩家准备  --> SOCKET_READY

   3. 发牌    
	   event: game_start
	   通知游戏开始  --> SOCKET_GAME_START
	   event: laizi
	   混牌动画  --> VIEW_HUN_ANIM
	   event: deal
	   骰子动画  --> VIEW_DICE_ANIM
	   显示定庄  --> VIEW_DING_ZHUANG
	   播放发牌动画 --> VIEW_START_DEAL_CARD_ANIM
	   显示剩余局数 --> VIEW_LEFT_JU_NUM

       event: go_xiapao
       server通知前端进行下跑 --> SOCKET_ASK_XIAPAO
       显示操作时间  --> VIEW_OPER_TIMER

       event: xiapao
       玩家下跑  --> SOCKET_XIAPAO
       请求下跑  --> SOCKET_REQ_XIAPAO

       event : allplayerxiapao
        通知所有玩家下跑的信息  --> SOCKET_ALLXIAPAO
       event: play_start
        牌局开始  --> SOCKET_PLAY_START 

    4. 打牌


    5. 结算


    6. 重连


    7. 申请退出

 ]]

require "logic/network/majong_request_interface"
require "logic/mahjong_sys/ui_mahjong/mahjong_ui"
require "logic/mahjong_sys/mode_manager"

mahjong_play_sys = {}
local this = mahjong_play_sys

local sessionData = {}
local heartTimer = nil
local heartTimer_c = nil

--[[--
 * @Description: 注册事件  
 ]]
function this.RegisterEvents() 
  Notifier.regist(cmdName.MSG_APP_PAUSE, this.OnAppPauseHandler)
end


--[[--
 * @Description: 反注册事件  
 ]]
function this.UnRegisterEvents()
  Notifier.remove(cmdName.MSG_APP_PAUSE, this.OnAppPauseHandler)
end

--[[--
 * @Description: 初始化  
 ]]
function this.Initialize()  
  this.RegisterEvents()
end

--[[--
 * @Description: 反初始化  
 ]]
function this.Uninitialize()
  mode_manager.UninitializeCurrMode()
	msg_dispatch_mgr.SetIsEnterState(false)
  msg_dispatch_mgr.ResetMsgQueue()  
  this.UnRegisterEvents()
  if heartTimer~=nil then
    heartTimer:Stop()
    heartTimer = nil
  end
end


--[[--
 * @Description: 进入游戏请求  
 ]]
function this.EnterGameReq(enterData)
	majong_request_interface.EnterGameReq(enterData)
end

--[[--
 * @Description: 游戏进入后处理 
 ]]
function this.HandlerEnterGame()
   map_controller.LoadLevelScene(900002, mahjong_play_sys)
   sessionData = player_data.GetSessionData()
end


--[[--
 * @Description: 加载完场景做的第一件事
 ]]
function this.HandleLevelLoadComplete()
  gs_mgr.ChangeState(gs_mgr.state_mahjong)
  map_controller.SetIsLoadingMap(false)

  this.Initialize()
  log("gs_mgr.state_mahjong-------------------------------------")
  mode_manager.InitializeMode(3)
  mode_manager.StartCurrentMode() 

  -- heartTimer = Timer.New(this.HeartBeatReq, 5, -1)
  -- heartTimer:Start()  
end


function this.ExitSystem()
  this.Uninitialize()

  if vote_quit_ui ~= nil then
    vote_quit_ui:Hide()
  end
end

--[[--
 * @Description: 切后台断线重连处理  
 ]]
function this.OnAppPauseHandler()
  --立刻发送心跳消息
  -- this.HeartBeatReq()
end

--[[--
 * @Description: 关闭游戏中心跳  
 ]]
function this.StopChessHearBeat()
  heartTimer:Reset(this.HeartBeatReq, 5, -1)
  heartTimer:Stop()  
end

--[[--
 * @Description: 重启心跳包  
 ]]
function this.ReStartHearBeat()
  if heartTimer ~= nil then
    heartTimer:Start()
  else
    heartTimer = Timer.New(this.HeartBeatReq, 5, -1)
    heartTimer:Start()    
  end
end

--///////////////////////////请求处理start///////////////////////////////////
function this.ReadyGameReq()
	majong_request_interface.ReadyGameReq(sessionData["_gt"], sessionData["_chair"])
end

--下跑
function this.XiaPaoReq(beishu)
    majong_request_interface.XiaPaoReq(beishu,sessionData["_gt"],sessionData["_chair"])
end

--出牌
function this.OutCardReq(cardValue)
    majong_request_interface.OutCardReq(cardValue,sessionData["_gt"],sessionData["_chair"])
end

--糊牌
function this.HuPaiReq(cardValue)
	--[[--
	 * @Description: {"card":10} 
	 ]]
  majong_request_interface.HuPaiReq(cardValue, sessionData["_gt"],sessionData["_chair"])
end

--听牌
function this.TingReq(cardValue)
	--TODO
    majong_request_interface.TingReq(cardValue,sessionData["_gt"],sessionData["_chair"])
end

--碰牌
function this.TripletReq(cardValue)
	--[[--
	 * @Description: [ 21, 21,21]   
	 ]]
	local tbl = operatorcachedata.GetOpTipsTblByType(MahjongOperTipsEnum.Triplet)
   majong_request_interface.TripletReq(tbl,sessionData["_gt"],sessionData["_chair"])
end

--杠牌
function this.QuadrupletReq(cardValue)
	--[[--
	 * @Description: [ 21, 21,21,21]   
	 ]]
	local tbl = operatorcachedata.GetOpTipsTblByType(MahjongOperTipsEnum.Quadruplet)
    majong_request_interface.QuadrupletReq(tbl,sessionData["_gt"],sessionData["_chair"])
end

--吃牌
function this.CollectReq(cardValue)
	--TODO
    majong_request_interface.CollectReq(cardValue,sessionData["_gt"],sessionData["_chair"])
end

--过（放弃）
function this.GiveUp()
    majong_request_interface.GiveUp(sessionData["_gt"],sessionData["_chair"])
end

--重新进入游戏
function this.reEnterGameReq(gameID,gameRule)
    majong_request_interface.reEnterGameReq(gameID,gameRule)
end

--申请退出，请求合局
function  this.VoteDrawReq(flag)
    majong_request_interface.VoteDrawReq(flag, sessionData["_gt"],sessionData["_chair"])
end

--玩家退出
function this.LeaveReq()
  majong_request_interface.LeaveReq(sessionData["_gt"],sessionData["_chair"])
end

-- 解散房间
function this.DissolutionRoom()
  majong_request_interface.Dissolution(sessionData["_gid"], sessionData["_gt"],sessionData["_chair"])
end

--聊天
function this.ChatReq(contenttype,content,givewho)
    majong_request_interface.ChatReq(contenttype,content,sessionData["_gt"],sessionData["_chair"],givewho)
end

--心跳
function this.HeartBeatReq()
	-- local beatTbl = {}
	-- beatTbl["_gt"] = sessionData["_gt"]
	-- beatTbl["_chair"] = sessionData["_chair"]
 --  majong_request_interface.HeartBeatReq(beatTbl)
end
--///////////////////////////请求处理end///////////////////////////////////