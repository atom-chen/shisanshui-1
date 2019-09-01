  
require "logic/network/shisanshui_request_protocol"
require "logic/network/messagedefine"

shisanshui_request_interface = {}
local this = shisanshui_request_interface

--ÇëÇó½øÈëÓÎÏ·
function this.EnterGameReq(urlValue, gameData, dst)
  local urlStr = string.format(data_center.url, data_center.GetLoginRetInfo().uid, data_center.GetLoginRetInfo().session_key)

  log(urlStr)
  SocketManager:createSocket("game", urlStr, "chess", 1, gameData._dst)

  SocketManager:onGameOpenCallBack(function (  )
    log("连上服务器返回")
    log("onGameOpenCallBack-------- EnterGameReq")
    log(GetTblData(gameData))
    local pkgBuffer = shisanshui_request_protocol.EnterGameReq(urlValue, gameData, dst);
    log(pkgBuffer)
    network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL, pkgBuffer)
  end)  

end

-- ÇëÇó×¼±¸ÓÎÏ·
function this.ReadyGameReq(_tableId, _seat)
    local pkgBuffer = majong_request_protocol.ReadyGame(messagedefine.chessPath,_tableId, _seat);
      log("pkgBuffer================"..tostring(pkgBuffer));
   network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL,pkgBuffer)
end

function this.CompareFinish(_tableId,_seat)
	local pkgBuffer = shisanshui_request_protocol.cancel_compare(messagedefine.chessPath,_tableId, _seat);
    log("pkgBuffer================"..tostring(pkgBuffer));
    network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL,pkgBuffer)
end

-- Ñ¡ÔñÌØÊâÅÆÐÍ
function this.ChooseCardTypeReq(_tableId, _seat, nSelect)
    local pkgBuffer = shisanshui_request_protocol.ChooseCardType(messagedefine.chessPath,_tableId, _seat, nSelect);
      log("pkgBuffer================"..tostring(pkgBuffer));
   network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL,pkgBuffer)
end

-- °ÚÅÆ
function this.PlaceCard(_tableId, _seat, cards)
    local pkgBuffer = shisanshui_request_protocol.PlaceCard(messagedefine.chessPath,_tableId, _seat, cards);
      log("pkgBuffer================"..tostring(pkgBuffer));
   network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL,pkgBuffer)
end

--½øÈë´óÌü²éÑ¯ÓÎÏ·×´Ì¬(ÖØÁ¬)
function this.QueryGameStateReq()
    local pkgBuffer = majong_request_protocol.QueryGameState(messagedefine.onlinePath);
      log("pkgBuffer================"..tostring(pkgBuffer));
    network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL, pkgBuffer)
end

--闲家选择倍数
function this.beishuReq(beishu,tableID,seat)
     local pkgBuffer = shisanshui_request_protocol.requestMult(messagedefine.chessPath,beishu,tableID,seat);
       log("pkgBuffer================"..tostring(pkgBuffer));
   network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL,pkgBuffer)
end

--³öÅÆ
function this.OutCardReq(cardValue,tableID,seat)
    local pkgBuffer = majong_request_protocol.requestOutCard(messagedefine.chessPath,cardValue,tableID,seat);
      log("pkgBuffer================"..tostring(pkgBuffer))
    network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL,pkgBuffer)
end

--ºýÅÆ
function this.HuPaiReq(cardValue,tableID,seat)
    local pkgBuffer = majong_request_protocol.requestHu(messagedefine.chessPath,cardValue,tableID,seat);
      log("pkgBuffer================"..tostring(pkgBuffer))
    network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL,pkgBuffer)
end

--ÌýÅÆ
function this.TingReq(cardValue,tableID,seat)
    local pkgBuffer = majong_request_protocol.requestTing(messagedefine.chessPath,cardValue,tableID,seat);
      log("pkgBuffer================"..tostring(pkgBuffer))
    network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL,pkgBuffer)
end

--ÅöÅÆ
function this.TripletReq(cardtbl,tableID,seat)
   local pkgBuffer = majong_request_protocol.requestTriplet(messagedefine.chessPath,cardtbl,tableID,seat);
     log("pkgBuffer================"..tostring(pkgBuffer))
   network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL,pkgBuffer)
end

--¸ÜÅÆ
function this.QuadrupletReq(cardtbl,tableID,seat)
    local pkgBuffer = majong_request_protocol.requestQuadruplet(messagedefine.chessPath,cardtbl,tableID,seat);
      log("pkgBuffer================"..tostring(pkgBuffer))
   network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL,pkgBuffer)
end

--³ÔÅÆ
function this.CollectReq(cardValue,tableID,seat)
    local pkgBuffer = majong_request_protocol.requestCollect(messagedefine.chessPath,cardValue,tableID,seat);
	log("pkgBuffer================"..tostring(pkgBuffer));
    network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL,pkgBuffer)
end

--¹ý£¨·ÅÆú£©
function this.GiveUp(tableID,seat)
    local pkgBuffer = majong_request_protocol.requestGiveUp(messagedefine.chessPath,tableID,seat);
      log("pkgBuffer================"..tostring(pkgBuffer));
    network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL,pkgBuffer)
end

--ÖØÐÂ½øÈëÓÎÏ·
function this.reEnterGameReq(gameID,gameRule)
    local pkgBuffer = majong_request_protocol.reEnterGame(messagedefine.chessPath,gameID,gameRule);
      log("pkgBuffer==================================="..tostring(pkgBuffer));
   network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL,pkgBuffer)
end

--申请退出，请求合局
function  this.VoteDrawReq(flag, tableID, seat)
    local pkgBuffer = majong_request_protocol.requestVoteDraw(messagedefine.chessPath, flag, tableID, seat)
    log("pkgBuffer==================================="..tostring(pkgBuffer))
    network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL,pkgBuffer)
end

--Íæ¼ÒÍË³ö
function this.LeaveReq(tableID,seat)
     local pkgBuffer = majong_request_protocol.requestLeave(messagedefine.chessPath, tableID, seat);
       log("pkgBuffer==================================="..tostring(pkgBuffer));
    network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL,pkgBuffer)
end
----解散房间
function this.Dissolution( gid, tableid, seat)
    local pkgBuffer = shisanshui_request_protocol.requestDissolution(messagedefine.chessPath, gid, tableid, seat);
       log("pkgBuffer==================================="..tostring(pkgBuffer));
    network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL,pkgBuffer)
end

--ÁÄÌì
function this.ChatReq(contenttype,content,tableID,seat,geivewho)
    local pkgBuffer = majong_request_protocol.requestChat(messagedefine.chessPath,contenttype,content,tableID,seat,geivewho);
    network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL,pkgBuffer)
end

--ÐÄÌø
function this.HeartBeatReq(session)
     local pkgBuffer = majong_request_protocol.HeartBeat(messagedefine.chessPath, session);
     network_mgr.sendPkgNoWaitForRsp(net_cmd.CMD_LOGIN_HALL, pkgBuffer)
end

