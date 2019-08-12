--[[--
 * @Description: 加入房间逻辑处理
 * @Author:      shine
 * @FileName:    join_room_ctrl.lua
 * @DateTime:    2017-07-20 17:31:19
 ]]

join_room_ctrl = {}
local this = join_room_ctrl

ENTER_TYPE = 
{
    ENTER_COIN_RECONNECT = 1,  --金币场重连
    ENTER_CARD_RECONNECT = 2,  --房卡重连
    ENTER_SEC_RECONNECT = 3,   --游戏重进重连
}

--[[--
 * @Description: 加入房间处理  
 ]]
function this.JoinRoomHandler(enterData, enterType)
    --默认重连状态设置
    if enterType == nil then
        enterType = ENTER_TYPE.ENTER_COIN_RECONNECT
    end

    local param = {}
    param.gid = enterData.cser._gid
    param.rid = enterData.rid
    http_request_interface.ToRoom(param, function (code, m, str)
        --错误码处理
        if code == 101 then

        elseif code == 102 then

        end

        local s=string.gsub(str, "\\/", "/")
        local data = ParseJsonStr(s) 
        log("data--------------------------------------"..tostring(str))
        if data ~= nil then
            --设置uri
            messagedefine.chessPath = "/"..data.cser._svr_t.."/"..data.cser._svr_id
            --roomdata_center.SetRoomInfo(data.cser)

            --根据_dsts来确定是否重连，如果有就重连，木有就不重连
            if data._dsts ~= nil and #data._dsts > 0 then
                if enterType == enterType.ENTER_COIN_RECONNECT or enterType == enterType.ENTER_CARD_RECONNECT then
                    --重弹窗口处理
                    message_box.ShowGoldBox("您已经在游戏中，是否重入？", nil, 2, {function ()
                            message_box:Close()
                        end, function ()
                            local tbl = {_dst = data._dsts[1]}
                            this.EnterGameHandle(tbl)
                            message_box:Close()
                        end}, {"fonts_02", "fonts_01"})
                elseif enterType == enterType.ENTER_SEC_RECONNECT then
                    local tbl = {_dst = data._dsts[1]}
                    this.EnterGameHandle(tbl)
                end                
            else
                local tbl={para=data.cser}
                this.EnterGameHandle(tbl)
            end
        end
    end)
end

function this.QueryState()
    log("只在进第一次进游戏时查询状态00022222300")
  http_request_interface.QueryStatus({}, function (code, m, str)
     local s=string.gsub(str,"\\/","/")
     log("s--------------------------------"..tostring(s))
     local t=ParseJsonStr(s)   
     if data._dsts ~= nil and #t._dsts > 0 then     
        local tbl = {_dst = t._dsts[1]}
        this.EnterGameHandle(tbl)
     end
  end)
end

--[[--
 * @Description: 进入游戏处理  
 ]]
function this.EnterGameHandle(data)
    log("GetTblData----------------------------------"..GetTblData(data))
    mahjong_play_sys.EnterGameReq(data)
    player_data.SetReconnectEpara(data) 
    --join_room.EnterGameHandle(data)
end