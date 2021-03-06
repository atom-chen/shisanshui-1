require "logic/network/majong_request_protocol"
require "logic/network/messagedefine"


majong_request_interface = {}
local this = majong_request_interface

--请求进入游戏
function this.EnterGameReq(gameData)
    local urlStr = string.format(data_center.url, data_center.GetLoginRetInfo().uid, data_center.GetLoginRetInfo().session_key)
    log(urlStr)
    
    local srvName = ""
    local srvID = nil

    if gameData._dst ~= nil then
      srvName = gameData._dst._svr_t
      srvID = gameData._dst._svr_id
    else
      srvName = gameData._svr_t 
      srvID = gameData._svr_id

      if srvName == nil and srvID == nil then
        srvName = "chess"
        srvID = 1
      end
    end

    SocketManager:createSocket("game", urlStr, srvName, srvID, gameData._dst)

    SocketManager:onGameOpenCallBack(function ()
      log("onGameOpenCallBack-------- EnterGameReq")
      local pkgBuffer = majong_request_protocol.EnterGameReq(gameData)
      network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL, pkgBuffer)
    end)
end

-- 请求准备游戏
function this.ReadyGameReq(_tableId, _seat)
    local pkgBuffer = majong_request_protocol.ReadyGame(messagedefine.chessPath,_tableId, _seat);
      log("pkgBuffer==================================="..tostring(pkgBuffer));
   network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL,pkgBuffer)
end

--进入大厅查询游戏状态(重连)
function this.QueryGameStateReq(paraData)
    local pkgBuffer = majong_request_protocol.QueryGameState(messagedefine.onlinePath, paraData);
      log("pkgBuffer==================================="..tostring(pkgBuffer));
    network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL, pkgBuffer)
end

--下跑
function this.XiaPaoReq(beishu,tableID,seat)
     local pkgBuffer = majong_request_protocol.requestXiaPao(messagedefine.chessPath,beishu,tableID,seat);
       log("pkgBuffer==================================="..tostring(pkgBuffer));
   network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL,pkgBuffer)
end

--出牌
function this.OutCardReq(cardValue,tableID,seat)
    local pkgBuffer = majong_request_protocol.requestOutCard(messagedefine.chessPath,cardValue,tableID,seat);
      log("pkgBuffer==================================="..tostring(pkgBuffer))
    network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL,pkgBuffer)
end

--糊牌
function this.HuPaiReq(cardValue,tableID,seat)
    local pkgBuffer = majong_request_protocol.requestHu(messagedefine.chessPath,cardValue,tableID,seat);
      log("pkgBuffer==================================="..tostring(pkgBuffer))
    network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL,pkgBuffer)
end

--听牌
function this.TingReq(cardValue,tableID,seat)
    local pkgBuffer = majong_request_protocol.requestTing(messagedefine.chessPath,cardValue,tableID,seat);
      log("pkgBuffer==================================="..tostring(pkgBuffer))
    network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL,pkgBuffer)
end

--碰牌
function this.TripletReq(cardtbl,tableID,seat)
   local pkgBuffer = majong_request_protocol.requestTriplet(messagedefine.chessPath,cardtbl,tableID,seat);
     log("pkgBuffer==================================="..tostring(pkgBuffer))
   network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL,pkgBuffer)
end

--杠牌
function this.QuadrupletReq(cardtbl,tableID,seat)
    local pkgBuffer = majong_request_protocol.requestQuadruplet(messagedefine.chessPath,cardtbl,tableID,seat);
      log("pkgBuffer==================================="..tostring(pkgBuffer))
   network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL,pkgBuffer)
end

--吃牌
function this.CollectReq(cardCollect,tableID,seat)
    local pkgBuffer = majong_request_protocol.requestCollect(messagedefine.chessPath,cardCollect,tableID,seat);
    log("pkgBuffer==================================="..tostring(pkgBuffer))
   network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL,pkgBuffer)
end

--过（放弃）
function this.GiveUp(tableID,seat)
    local pkgBuffer = majong_request_protocol.requestGiveUp(messagedefine.chessPath,tableID,seat);
      log("pkgBuffer==================================="..tostring(pkgBuffer));
    network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL,pkgBuffer)
end

--重新进入游戏
function this.reEnterGameReq(gameID,gameRule)
    local pkgBuffer = majong_request_protocol.reEnterGame(messagedefine.chessPath,gameID,gameRule);
      log("pkgBuffer==================================="..tostring(pkgBuffer));
   network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL,pkgBuffer)
end

--申请退出，请求合局
function  this.VoteDrawReq(flag, tableID,seat)
    local pkgBuffer = majong_request_protocol.requestVoteDraw(messagedefine.chessPath,flag, tableID,seat);
    -- logError("pkgBuffer==================================="..tostring(pkgBuffer));
    network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL,pkgBuffer)
end

--玩家退出
function this.LeaveReq(tableID,seat)
     local pkgBuffer = majong_request_protocol.requestLeave(messagedefine.chessPath, tableID, seat);
       log("pkgBuffer==================================="..tostring(pkgBuffer));
    network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL,pkgBuffer)
end

function this.Dissolution( gid, tableid, seat)
    local pkgBuffer = majong_request_protocol.requestDissolution(messagedefine.chessPath, gid, tableid, seat);
       log("pkgBuffer==================================="..tostring(pkgBuffer));
    network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL,pkgBuffer)
end

--聊天
function this.ChatReq(contenttype,content,tableID,seat,geivewho)
    local pkgBuffer = majong_request_protocol.requestChat(messagedefine.chessPath,contenttype,content,tableID,seat,geivewho);
    log("pkgBuffer==================================="..tostring(pkgBuffer));
    network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL,pkgBuffer)
end

--心跳
function this.HeartBeatReq(session)
     local pkgBuffer = majong_request_protocol.HeartBeat(messagedefine.chessPath, session);
      log("pkgBuffer==================================="..tostring(pkgBuffer));
     network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL, pkgBuffer)
end