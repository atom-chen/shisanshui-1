 --[[--
  * @Description: 网络消息分发机制管理
  * 1>. 服务器消息不阻塞，将服务器消息放入消息队列
  * 2>. 客户端分发中心注册模块消息处理完事件，如果队列中还有消息，
        接着派发下一条给对应模块，这里可通过注册消息事件处理
  * 3>. 增加模块消息最长处理时间，如果超过该时间段则强制派发下一条消息指令(模块那边需强制同步)
  * @Author:      shine
  * @FileName:    msg_dispatch_mgr.lua
  * @DateTime:    2017-05-20 14:16:41
  ]]

require "logic/mahjong_sys/_model/roomdata_center"
require "logic/mahjong_sys/_model/player_data"
require "logic/shisangshui_sys/shisangshui_play_sys"
require "logic/mahjong_sys/mahjong_play_sys"
require "logic/hall_sys/openroom/room_data"
require "logic/voteQuit/vote_quit_ui"

msg_dispatch_mgr = {}
local  this = msg_dispatch_mgr

local msgqueue = {}

local curGameType = 1

local mapEvent = {}
local eventNum = 0
local curEvent = nil

local isEnter = false
local isSend = false

local curSysTime = nil


--1代表第一个游戏的数据
local msgEventTable = 
{
  ["enter"] = cmdName.F1_ENTER_GAME,   --进入
  ["ready"] = cmdName.F1_GAME_READY,   --准备
  ["game_start"] = cmdName.F1_GAME_START, --游戏开始
  ["ask_xiapao"] = cmdName.F1_GAME_GOXIAPAO, -- 通知下跑
  ["xiapao"] = cmdName.F1_GAME_XIAPAO,    --下跑
  ["allplayerxiapao"] = cmdName.F1_GAME_ALLXIAPAO,    --所有玩家下跑
  ["laizi"] = cmdName.F1_GAME_LAIZI,    --定赖
  ["banker"] = cmdName.F1_GAME_BANKER,    --定庄
  ["deal"] = cmdName.F1_GAME_DEAL,      --发牌

  ["changeflower"] = cmdName.F3_CHANGE_FLOWER,  --补花
  ["opengold"] = cmdName.F3_OPEN_GOLD,        --开金

  ["play_start"] = cmdName.F1_GAME_PLAYSTART, --打牌开始
  ["ask_play"] = cmdName.F1_GAME_ASKPLAY, --提示出牌
  ["play"] = cmdName.F1_GAME_PLAY,     --出牌
  ["give_card"] = cmdName.F1_GAME_GIVECARD, --摸牌

  ["ask_block"] = cmdName.F1_GAME_ASKBLOCK, --提示操作
  ["triplet"] = cmdName.F1_GAME_TRIPLET,  --碰
  ["quadruplet"] = cmdName.F1_GAME_QUADRUPLET,  --杠
  ["collect"] = cmdName.F1_GAME_COLLECT,   --吃
  ["ting"] =  cmdName.F1_GAME_TING,     --听
  ["robgold"] =  cmdName.F3_ROB_GOLD,      --抢金

  ["win"] = cmdName.F1_GAME_WIN,                  --胡
  ["rewards"] = cmdName.F1_GAME_REWARDS,  --结算
  ["points_refresh"] = cmdName.F1_POINTS_REFRESH,  --玩家金币更新
  ["gameend"] = cmdName.F1_GAME_END,  --游戏结束
  ["ask_ready"] = cmdName.F1_ASK_READY,  --通知准备

  ["sync_begin"] = cmdName.F1_SYNC_BEGIN,  --重连同步开始
  ["sync_table"] = cmdName.F1_SYNC_TABLE,  --重连同步表
  ["sync_end"] = cmdName.F1_SYNC_END,  --通知准备

  ["leave"] = cmdName.F1_GAME_LEAVE,      --用户离开
  ["offline"] = cmdName.F1_GAME_OFFLINE,    --用户掉线


  ["chat"] =  cmdName.F1_GAME_CHAT,     --聊天

  ["autoplay"] = cmdName.F1_AutoPlay,     --托管

  ["vote_draw"] =  cmdName.F1_VOTE_DRAW,   --请求和局
  ["vote_draw_start"] = cmdName.F1_VOTE_START,  --请求和局开始
  ["vote_draw_end"] = cmdName.F1_VOTE_END,     --请求和局结束

 
  ["ask_choose"] = cmdName.ASK_CHOOSE, --选择牌型即摆牌
  ["choose_ok"] = cmdName.CHOOSE_OK, --某人已经选好牌型
  ["compare_start"] = cmdName.COMPARE_START, --比牌开始)
  ["compare_result"] = cmdName.COMPARE_RESULT,--比牌结果
  ["compare_end"] = cmdName.COMPARE_END,--比牌结束
  ["game_end"] = cmdName.GAME_END,-- 游戏结束
  ["autoplay"] = cmdName.AUTOPLAY ,--某人(chair1)修改了他的托管状态设置

  ["account"] = cmdName.F3_ACCOUNT,
  --["points_refresh"] = cmdName.Point_Refresh, ---数据刷新 
  ["room_sum_score"] = cmdName.ROOM_SUM_SCORE,
  ["ask_mult"] = cmdName.FuZhouSSS_ASKMULT,	--等待闲家选择倍数
  ["mult"] = cmdName.FuZhouSSS_MULT, -- 选择倍数通知(回复自己选择倍数)

  ["room_sum_score"] = cmdName.ROOM_SUM_SCORE,

  ["start_flag"] = cmdName.F3_START_FLAG,
  ["all_mult"] = cmdName.FuZhouSSS_ALLMULT
}

--[[--
 * @Description: 初始化消息事件  
 ]]
function this.Init()
  --注册消息处理回调事件
  Notifier.regist(cmdName.MSG_HANDLE_DONE, this.OnMsgHandleDone)
	UpdateBeat:Add(this.Update)
end

function this.UnInit()
   Notifier.remove(cmdName.MSG_HANDLE_DONE, this.OnMsgHandleDone)
end

function this.HandleRecvData(cmdId, msg)
  print("收到服务端协议cmdId======================================="..GetTblData(msg))

  if msg._st ~=nil and msg._st == "err" then
    this.HandleSTError(cmdId, msg)
    print("-------------!!!!!!!!!!!!!----------" .. GetTblData(msg))
  elseif cmdId == "query_state" then
    this.HandleQueryStateMsg(msg)
  elseif cmdId == "session" then
    this.HandleSessionMsg(msg)
  elseif cmdId == "game_cfg" then  
    this.SetRoomCfgData(msg)
  elseif cmdId == "table_limit" then
    --game_scene.DestroyCurSence()    
    --game_scene.gotoHall()
  elseif cmdId == "leave" then
    this.LeaveEventHandler(msg)
  elseif cmdId == "dissolution" then  -- 解散房间
    this.DissolutionHandler(msg)
  elseif cmdId == "error" then
    this.ErrorEventHandler(msg)
  elseif cmdId=="pushmsg" then
    this.UpdataInfoHandle(msg)
  else
    msg.time = os.clock()
    this.AddMsgToQueue(cmdId, msg)
  end
end

function this.HandleSTError(cmdId, msg)
  if cmdId == "enter" then
      if msg._para._errno ~= nil and tonumber(msg._para._errno) == 2009 then
        fast_tip.Show("房间人数已满，无法进入房间")
        waiting_ui.Hide()
      end
  end
end

function this.AddMsgToQueue(cmdId, msg)
  --解析数据(上面已经解析了)
  local msgTable = {}
  msgTable.cmdId = cmdId
  msgTable.msg = msg

  --将解析后的数据加入队列
  table.insert(msgqueue, msgTable)
  print("msgqueue================================"..tostring(#msgqueue))
end

--[[--
 * @Description: 移除消息  
 ]]
function this.RemoveMsgFromQueue(msg)
  
end

--[[--
 * @Description: 重置消息队列  
 ]]
function this.ResetMsgQueue(msg)
  isSend = false
  msgqueue = {}
end

function this.Update()
  curGameType = data_center.GetGameType()
  if eventNum == 0 then
    --将第一个数据发送出去给注册模块
    if (#msgqueue>0) and (msgqueue[1]~=nil) and (isEnter) and (not isSend) then
      isSend = true
      curEvent = msgEventTable[msgqueue[1].cmdId]

      curSysTime = os.clock()
      msgqueue[1].msg.time = curSysTime - msgqueue[1].msg.time
      print("curEvent================================"..tostring(msgqueue[1].cmdId))
      Notifier.dispatchCmd(curEvent, msgqueue[1].msg)
    end
  end
end

function this.RemapMsgToPlayer()
  
end


function this.AddMsgMap(_event)
  if _event == curEvent then
    eventNum = eventNum + 1
    mapEvent[_event] = eventNum
  else
    warning("curEvent havn't handle done, please wait for a moment")
  end
end

--[[--
 * @Description: 消息事件完成后的回调处理
 ]]
function this.OnMsgHandleDone(_event)
  print("OnMsgHandleDone-xx----------------------------------"..tostring(_event))
  --这里做一个事件认证
  if _event == curEvent then    
    eventNum = eventNum - 1
  end

  if eventNum <= 0 then
    msgqueue[1] = nil
    table.remove(msgqueue, 1)
    eventNum = 0
    isSend = false        
  end
end

--[[--
 * @Description: 设置进入状态  
 ]]
function this.SetIsEnterState(state)
  isEnter = state

end

--[[--
 * @Description: 处理查询状态后消息处理  
 ]]
function this.HandleQueryStateMsg(msg)
	print("处理查询状态后消息处理")
	if msg._para._dst ~= nil and msg._para._dst.status == "enter" then
		print("msg._para._gid-----------------------------"..tostring(msg._para._dst._gid))
		if msg._para._dst._gid == ENUM_GAME_TYPE.TYPE_FUZHOU_MJ then
			player_data.ReSetSessionData(msg._para)
			local t=
			{
				[messagedefine.EField_Session]=msg._para._dst,
				para = --msg._para.para
        {
          _gid = msg._para._dst._gid,
          _glv = msg._para._dst._glv,
          _gsc = msg._para._dst._gsc,
        }
			}    
			player_data.SetReconnectEpara(t.para)

			mahjong_play_sys.EnterGameReq(t)    
		elseif tonumber(msg._para._dst._gid) == tonumber(ENUM_GAME_TYPE.TYPE_SHISHANSHUI) then
			player_data.ReSetSessionData(msg._para)
			player_data.SetReconnectEpara(msg._para.para)   
			if msg._para._dst ~= nil then
				local gamedata = {}
				
				--[[
				local gamedata = room_data.GetSssRoomDataInfo()
				gamedata["nGhostAdd"] = msg._para.para._gt_cfg.cfg.nGhostAdd
				gamedata["nColorAdd"] = msg._para.para._gt_cfg.cfg.nColorAdd
				gamedata["pnum"] = msg._para.para._gt_cfg.cfg.pnum
				gamedata["rounds"] = msg._para.para._gt_cfg.cfg.rounds
				gamedata["nBuyCode"] = msg._para.para._gt_cfg.cfg.nBuyCode
				gamedata["nWaterBanker"] = msg._para.para._gt_cfg.cfg.nWaterBanker
				gamedata["nMaxMult"] = msg._para.para._gt_cfg.cfg.nMaxMult
				gamedata["rno"] = msg._para.para._gt_cfg.rno
				gamedata["uid"] = msg._para.para._gt_cfg.uid
				gamedata["rid"] = msg._para.para._gt_cfg.rid
				gamedata.gid = msg._para.para._gt_cfg.gid
			]]
				
				local dst = msg._para._dst
				shisangshui_play_sys.EnterGameReq(gamedata, dst)
				print("十三水重连")
			end
		end
	elseif hall_data.CheckIsChooseRoomClick() then
		hall_data.SetChooseRoomClick(false)
		Notifier.dispatchCmd(cmdName.MSG_NOT_ENTER_STATE)
  else
    --重连后啥都木有
    game_scene.DestroyCurSence()    
    game_scene.gotoHall()    
	end
end

--[[--
 * @Description: 处理会话消息  
 ]]
function this.HandleSessionMsg(msg)
    msg_dispatch_mgr.ResetMsgQueue()
    waiting_ui.Hide()
    player_data.SetSessionData(msg)   	
    if msg._para._gid == ENUM_GAME_TYPE.TYPE_FUZHOU_MJ then
      mahjong_play_sys.HandlerEnterGame()
    elseif msg._para._gid == ENUM_GAME_TYPE.TYPE_SHISHANSHUI then
	   shisangshui_play_sys.HandlerEnterGame()
    end
end

--[[--
 * @Description: 设置房间配置数据  
 ]]
function this.SetRoomCfgData(msg)
  print("msg._para._gid---------------------------"..tostring(msg._para._gid))

  print("ENUM_GAME_TYPE.TYPE_SHISHANSHUI---------------------------"..tostring(ENUM_GAME_TYPE.TYPE_SHISHANSHUI))
  if msg._para._gid == ENUM_GAME_TYPE.TYPE_FUZHOU_MJ then
    roomdata_center.SetRoomCfgInfo(msg)  
  elseif msg._para._gid == ENUM_GAME_TYPE.TYPE_SHISHANSHUI then    
    print("msg._para.rno---------------------------"..tostring(msg._para.rno))
    roomdata_center.SetShiSangShuiRoomCfgInfo(msg)
  end
end

--[[--
 * @Description: 解散房间事件处理  
 ]]
function this.DissolutionHandler(msg)
    -- game_scene.DestroyCurSence()    
    -- game_scene.gotoHall()
    if room_usersdata_center.GetMyLogicSeat() ~= 1 then
        message_box.ShowGoldBox("房主已经解散了该房间，请进入其他房间进行游戏", nil, 1, {function ()message_box:Close()end}, {"fonts_01"})
    end
    -- if msg._para._gid == ENUM_GAME_TYPE.TYPE_FUZHOU_MJ then
    --   -- mahjong_play_sys.LeaveReq()  
    -- elseif msg._para._gid == ENUM_GAME_TYPE.TYPE_SHISHANSHUI then
      
    -- end
end

--[[--
 * @Description: 离开事件处理  
 ]]
function this.LeaveEventHandler(msg)
  -- leave 之后 接受不到voteend事件  所以把通知 放到leave中
  if msg._para.reason ~= nil and msg._para.reason == 3 then
    message_box.ShowGoldBox("房间已经成功解散，请进入其他房间进行游戏", nil, 1, {function ()message_box:Close()end}, {"fonts_01"})
  end

  if msg._st == "rsp" then
    --
  elseif msg._st == "svr" and msg._src == "p1" then
    if msg._para.reason ~= nil and msg._para.reason == 5 then
      message_box.ShowGoldBox("此账号在别处登录", nil, 1, {function ()message_box:Close()end}, {"fonts_01"})
    end 
  elseif  msg._para.reason ~= nil and msg._para.reason == 3 and msg._src == "p1"  then
    
  elseif msg._para.reason ~= nil and msg._para.reason == 9 and msg._src == "p1"  then
    
  else
    msg.time = os.clock()
    this.AddMsgToQueue("leave", msg)
    return
  end 
  vote_quit_ui.Hide()
  game_scene.DestroyCurSence()    
  game_scene.gotoHall()
end


--[[--
 * @Description: 错误处理  
 ]]
function this.ErrorEventHandler(msg)
  if msg._para.id == 10005 then
    Notifier.dispatchCmd(cmdName.MSG_CARD_XIANGGONG)
  end
end


--[[--
 * @Description: 推送数据处理  
]]

function this.UpdataInfoHandle(msg)
     print("HandlePushMsg------"..tostring(msg))
    local tmp = msg._para.msg
    --local t = json.encode(tmp)
    local s=string.gsub(tmp,"\\","")
    s=string.sub(s, 1, -1)
    print(s)
    if s== nil or s =="" then
      return
    end
    local t = json.decode(s)
    if t ~= nil then 
      if t["type"] == 10004 then
          http_request_interface.getAccount("",function ( code,m,str )
              local t=ParseJsonStr(str) 
              local ret = t.ret
              if ret and tonumber(ret) == 0 then
                  local account = t.account
                  local card = account.card 
                  Notifier.dispatchCmd(cmdName.MSG_ROOMCARD_REFRESH,card) 
                  print("card"..card)
              end
          end)
      end
   end
end