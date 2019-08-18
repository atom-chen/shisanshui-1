--[[--
 * @Description: 加入房间逻辑处理
 * @Author:      shine
 * @FileName:    join_room_ctrl.lua
 * @DateTime:    2017-07-20 17:31:19
 ]]

require"logic/hall_sys/openroom/room_data"

join_room_ctrl = {}
local this = join_room_ctrl

ENTER_TYPE = 
{
    ENTER_COIN_RECONNECT = 1,  --金币场重连
    ENTER_CARD_RECONNECT = 2,  --房卡重连
    ENTER_SEC_RECONNECT = 3,   --游戏重进重连
}


function this.ReEnterRoomByQuery(_dsts)
    --重弹窗口处理
    message_box.ShowGoldBox("您已经在游戏中，是否重入？", nil, 2, {function ()
            message_box:Close()
        end, function ()
            local tbl = {_dst = _dsts[1]}
            log("tbl---------------------------------------"..GetTblData(tbl))
            this.EnterGameHandle(tbl)
            message_box:Close()
        end}, {"fonts_02", "fonts_01"})
end


--[[--
 * @Description: 加入房间处理  
 ]]
function this.JoinRoomByRno(rno)
    --log("JoinRoomByRno start--------------------------------------")
    http_request_interface.getRoomByRno(rno, function (code, m, str)
        local s = string.gsub(str, "\\/", "/")
        local dataTbl = ParseJsonStr(s)
        --log(dataTbl)

        if dataTbl ~= nil then
            --设置uri
            --messagedefine.chessPath = "/"..data.cser._svr_t.."/"..data.cser._svr_id
            --roomdata_center.SetRoomInfo(data.cser)

            --根据_dsts来确定是否重连，如果有就重连，木有就不重连
            if dataTbl._dsts ~= nil and #dataTbl._dsts > 0 then               
                this.ReEnterRoomByQuery(dataTbl._dsts)            
            else
                if tonumber(dataTbl.ret)~=0 then
                    waiting_ui.Hide()
                    if tonumber(dataTbl.ret) == 100 then
                        fast_tip.Show("房间不存在")
                    elseif tonumber(dataTbl.ret) == 101 then
                        fast_tip.Show("房间已开局")
                    end
                    return
                end

                --log("JoinRoomByRno end--------------------------------------" + dataTbl.data.gid)
                --log("JoinRoomByRno end--------------------------------------" + ENUM_GAME_TYPE.TYPE_SHISHANSHUI)
                --if dataTbl.data.gid == ENUM_GAME_TYPE.TYPE_SHISHANSHUI then

                    log("连接游戏服-------------------------------------")
                    local k=dataTbl.data
                    k.nGhostAdd = dataTbl.data.cfg.joker
                    k.nColorAdd = dataTbl.data.cfg.addColor
                    k.pnum = dataTbl.data.cfg.pnum
                    k.rounds = dataTbl.data.cfg.rounds
                    k.nBuyCode = dataTbl.data.cfg.buyhorse
                    k.nWaterBanker = dataTbl.data.cfg.leadership
                    k.nMaxMult = dataTbl.data.cfg.maxfan
					
					room_data.GetSssRoomDataInfo().isZhuang = k.nWaterBanker
					room_data.GetSssRoomDataInfo().isChip = k.nBuyCode
					room_data.GetSssRoomDataInfo().play_num = k.rounds
					room_data.GetSssRoomDataInfo().people_num = k.pnum
					room_data.GetSssRoomDataInfo().add_card = k.nColorAdd
					room_data.GetSssRoomDataInfo().add_ghost = k.nGhostAdd
					room_data.GetSssRoomDataInfo().max_multiple = k.nMaxMult
					
                    card_data_manage.roomMasterUid = dataTbl.data.uid
                    shisanshui_request_interface.EnterGameReq(messagedefine.chessPath, k)
                -- else
                --     local k=dataTbl.data.cfg
                --     k["gid"]=dataTbl.data.gid
                --     k["rid"]=dataTbl.data.rid
                --     k["uid"]=dataTbl.data.uid
                --     k["rno"]=dataTbl.data.rno                    
                --     fuzhoumj_room_ui.EnterGameReq(k)
                -- end

            end
        end        
    end)

   
end

function this.QueryState(callback)
  http_request_interface.QueryStatus({}, function (code, m, str)
     local s=string.gsub(str,"\\/","/")
     log("QueryState:"..tostring(s))
     local t=ParseJsonStr(s)   
     if t._dsts ~= nil and #t._dsts > 0 then     
        local tbl = {_dst = t._dsts[1]}
        this.EnterGameHandle(tbl)
     else
        if callback ~= nil then
            callback()
        end
     end
  end)
end

--[[--
 * @Description: 进入游戏处理  
 ]]
function this.EnterGameHandle(data)
    log("GetTblData----------------------------------"..GetTblData(data))
    --mahjong_play_sys.EnterGameReq(data)
    player_data.SetReconnectEpara(data) 
    --join_room.EnterGameHandle(data)
end