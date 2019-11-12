require "logic/recharge/rechargeConfig"
recharge_sys = {}
local this = recharge_sys
-- "stype":支付平台类型(1微信2支付宝3爱贝4UC5腾讯6笨手机8百度),

function this.requestIAppPayOrder( stype,pid,num,uid)
    if not stype or not pid then return end
    log("准备发送预付单")
    http_request_interface.GetPayOrder(stype,pid,num,uid,function ( code,m,str )
        local s=string.gsub(str,"\\/","/")  
        local t=ParseJsonStr(s)
        log("requestIAppPayOrder  callback ==".. s);
        if t.ret == 0 then -- 下单成功
            if stype == rechargeConfig.IAppPay then
                if t.transid then
                    YX_APIManage.Instance:startIAppPay(tostring(t.transid),function ( msg )
                        log("requestIAppPayOrder  callback success startIAppPay  " ..  msg);
                        --{"ret":0,"account":{"uid":5647672,"diamond":0,"card":100000,"coin":5000000,"vip":0,"safecoin":0,"bankrupt":0,"bankruptc":0,"feewin":0,"feelose":0}}
                        http_request_interface.getAccount("",function ( code,m,str )
                            local s=string.gsub(str,"\\/","/")
                            log("getAccount callback =="..s)
                            local t=ParseJsonStr(s)
                            if t.ret == 0 then
                              -- 刷新当前携带货币数量
                            end
                        end)
                        local msgT=ParseJsonStr(msg)
                        if msgT.result == 0 then
                        else
                        end
                    end)
                end
            elseif stype == rechargeConfig.WeChat then
                local result = t.result
                local tbl = {}
                tbl.partnerid = result.mch_id
                tbl.prepayid = result.prepay_id
                tbl.noncestr = result.nonce_str
                tbl.timestamp = result.stamp
                --tbl.timestamp = YX_APIManage.Instance:nowTime()
                tbl.sign = result.sign
                local jsonStr = json.encode(tbl)
                log(jsonStr)
                YX_APIManage.Instance:startIAppPay(jsonStr,function ( msg )
                        log("支付成功返回  callback success startIAppPay  " ..  msg);
                        --{"ret":0,"account":{"uid":5647672,"diamond":0,"card":100000,"coin":5000000,"vip":0,"safecoin":0,"bankrupt":0,"bankruptc":0,"feewin":0,"feelose":0}}
                        http_request_interface.getAccount("",function ( code,m,str )
                            local s=string.gsub(str,"\\/","/")
                            log("getAccount callback =="..s)
                            local t=ParseJsonStr(s)
                            if t.ret == 0 then
                              -- 刷新当前携带货币数量
                              hall_data.UpdateInfo(t.account.card)
                            end
                        end)
                        local msgT=ParseJsonStr(msg)
                        if msgT.result == 0 then
                        else
                        end
                    end)
            end      
        else if t.ret == 99999 then -- 下单成功 
            fast_tip.Show("请输入正确的代充值的玩家id")       
        end
    end)
end