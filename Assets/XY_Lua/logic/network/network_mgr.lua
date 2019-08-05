--[[--
 * @Description: 游戏服务通道lua代理
                 用来进行网络数据接收处理，发包时需要注册收包函数，并可以取消注册
                 network_mgr建立在一个时期内，只能有一条链接存在
 * @Author:      shine
 * @FileName:    network_mgr.lua
 * @DateTime:    2017-05-26 16:53:13
 ]]

require "logic/network/http_request_interface"

network_mgr = {}
local this = network_mgr

function this.sendPkgWaitForRsp( cmdID, pkgBuffer )
-- LogW("sendPkgWaitForRsp------",cmdID,pkgBuffer )
    SocketManager:onGameSendData(pkgBuffer)
end

function this.sendPkgNoWaitForRsp( cmdID, pkgBuffer )
-- LogW("sendPkgNoWaitForRsp------",cmdID,pkgBuffer )
    SocketManager:onGameSendData(pkgBuffer)
end

--[[--
 * @Description: 切换网络状态  
 ]]
function this.NetworkReachability(netstate)
    print("netstate------------------------"..tostring(netstate))
    if netstate == 1 then   --1 代表wifi 
        fast_tip.Show("切换至WIFI网络")
    elseif netstate == 2 then  --2 代表移动
        fast_tip.Show("切换至移动网络")
    elseif netstate == 0 then  --0 无网络
        fast_tip.Show("未开启网络")
    end
    
    SocketManager:reconnect()
end

local durationTime = 0
function this.AppPauseNotify(pause)    
    if pause == 1 then
        durationTime = os.time()
    else
        durationTime = os.time() - durationTime
        --print("durationTime2-----------------------"..tostring(os.time()))   
        SocketManager:setLeaveTime(durationTime)    
    end  
end


