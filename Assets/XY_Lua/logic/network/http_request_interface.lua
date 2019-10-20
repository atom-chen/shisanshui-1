--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
require "common/json" 
http_request_interface={}
local this=http_request_interface

local version=0 
local uid=0 
local session_key=0 
local deviceid=0 
local devicetype=0  
local siteid=0 


function this.setUserInfo(Uid, Session_key, Deviceid, Devicetype, Siteid, Version)
    uid=Uid 
    session_key=Session_key 
    deviceid=Deviceid 
    devicetype=Devicetype 
    siteid=Siteid 
    version=Version  
end

function this.GetTable(method,param)
    -- 福州 --- siteid android 1 ios 1001 pc 3001
    if tostring(Application.platform) ==  "WindowsEditor"   then
        siteid = 3001
    elseif tostring(Application.platform) == "Android" then
        siteid = 1
    elseif tostring(Application.platform) == "IPhonePlayer" then
        siteid = 1001
    end
    local t={["appid"]=4,["uid"]=uid,["session_key"]=session_key,["siteid"]=siteid,["version"]=version,["method"]=method,["deviceid"]=deviceid,["devicetype"]=devicetype,["param"]=param} 
    -- if ClubModel.agentInfo ~= nil and ClubModel.agentInfo.naid  ~= nil then
    --     t.naid = ClubModel.agentInfo.naid
    -- end
    return t
end 

--俱乐部
function this.SendHttpRequest(key, param, dontShowWaiting, needRetry, isQuit)
    -- 默认打开等待界面
    -- if not dontShowWaiting then
    --     -- waiting_ui.Show()
    --     UI_Manager:Instance():ShowUiForms("waiting_ui")
    -- end
    local t = this.GetTable(key, param)
    local rt = json.encode(t)
    -- 暂时先使用HttpPOSTRequest逻辑 之后整理
    -- if Debugger.useLog then
    --     logWarning(rt)
    -- end
    this.HttpPOSTRequest(rt,
        function(str, code, msg) 
             if Debugger.useLog then
                log("receive:" .. str)
            end
            local s =string.gsub(str,"\\/","/")
            this.OnReceiveHttpResponse(key, s)
        end,
        showaiting, needRetry, isQuit)
end

function this.SendHttpRequestWithCallback(key, param,callback, target, dontShowWaiting, needRetry, isQuit)
   -- if not dontShowWaiting then
   --      -- waiting_ui.Show()
   --      UI_Manager:Instance():ShowUiForms("waiting_ui")
   --  end
    local t = this.GetTable(key, param)
    local rt = json.encode(t)
    -- 暂时先使用HttpPOSTRequest逻辑 之后整理
    -- if Debugger.useLog then
    --     logWarning(rt)
    -- end
    this.HttpPOSTRequest(rt,
        function(str, code, msg) 
            --  if Debugger.useLog then
            --     logWarning("receive:" .. str)
            -- end
            local s =string.gsub(str,"\\/","/")
            this.OnReceiveHttpResponseWithCallback(key, s, callback, target)
        end,
        showaiting, needRetry, isQuit)
end

function this.OnReceiveHttpResponse(key, retStr)
    local tab = nil
    if not pcall( function () tab = ParseJsonStr(retStr) end) then
        ParseJsonStr(retStr)
        -- waiting_ui.Hide()
        UI_Manager:Instance():CloseUiForms("waiting_ui")
        return
    end
    log("收到消息了，该返回了"..key)
    Notifier.dispatchCmd(key, tab)
end

function this.OnReceiveHttpResponseWithCallback(key, retStr, callback, target)
    local tab = nil
    if not pcall( function () tab = ParseJsonStr(retStr) end) then
        -- waiting_ui.Hide()
        UI_Manager:Instance():CloseUiForms("waiting_ui")
        return
    end
    if callback ~= nil then
        if target ~= nil then
            callback(target, tab, retStr)
        else
            callback(tab)
        end
    end
end

function this.HttpPOSTRequest(rt,callback,dontShowWaiting, needRetry, retryTime,isQuit) 
    NetWorkManage.Instance:HttpPOSTRequest(rt,function(code, msg, str)
        -- if not dontShowWaiting then
        --     waiting_ui.Hide()
        -- end 
        if code == 0 then
            -- waiting_ui.Hide()
            UI_Manager:Instance():CloseUiForms("waiting_ui")
            callback(str,code, msg)
            
            -- if timeStart~=nil then
            -- if timeStart~=nil then
            --     timeStart:Stop()
            --     timeStart=nil
            -- end
        else
            if needRetry == nil then
                needRetry = true
            end
            if not needRetry then
                this.ShowError(code,rt,callback,dontShowWaiting, needRetry, retryTime,isQuit)
            else
                if retryTime == 3 then
                    this.ShowError(code,rt,callback,dontShowWaiting, needRetry, retryTime,isQuit)
                    return
                end
                retryTime = retryTime or 1
                retryTime = retryTime + 1
                this.HttpPOSTRequest(rt,callback,dontShowWaiting, needRetry, retryTime,isQuit)
                --timeStart= Timer.New(function ()this.HttpPOSTRequest(rt,callback,dontShowWaiting, needRetry, retryTime,isQuit)end,3,1)
                -- timeStart:Start()
            end
        end    
    end)
end

-- 绑定代理
function this.BindAgent(ag_uid, callback)
    local param = {["ag_uid"] = ag_uid}
    local t = this.GetTable("GameMember.bindAgent", param)
    local rt = json.encode(t)
    this.HttpPOSTRequest(rt, function(str)
        local retStr = ParseJsonStr(str)
        if callback ~= nil then
            callback(retStr.ret)
        end
    end)
end

--[[
-----测试用--------- 
]]-----------

--获取个人游戏信息{"uid":113565,"type":1}
function this.getGameInfo(param,callback) 
    local t=this.GetTable("GameMember.getGameInfo",param) 
    local rt=json.encode(t)
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
    callback(code,m,str)
end) 
    log("-----------Finish_getGameInfo--------") 
end
  

--设置游戏配置 param:	(string)	"1|1|1"
function  this.setting(param,callback) 
    local t=this.GetTable("GameMember.setting",param) 
    local rt=json.encode(t)
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
    callback(code,m,str)
end) 
    log("-----------Finish_setting--------") 
end

function this.delEmail(param,callback)
    local t=this.GetTable("GameEmail.delEmail",param) 
    local rt=json.encode(t)
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
    callback(code,m,str)
    end)
end

--用户反馈 param:	(string)	"我的金币丢了"
function  this.feedBack(param,callback)
    local t=this.GetTable("GameTools.feedBack",param)  
    local rt=json.encode(t) 
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
    callback(code,m,str)
end) 
    log("-----------Finish_feedBack--------") 
end



--获得用户反馈信息列表 param:	(string)	
function  this.getFeedBack(param,callback)
    local t=this.GetTable("GameTools.getFeedBack",param)  
    local rt=json.encode(t)
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
    callback(code,m,str)
end) 
    log("-----------Finish_getFeedBack--------") 
end



--修改用户资料 {"nickname":用户呢称,有修改就传,没修改传空,"sex":用户性别,有修改就传,没修改传空,0未知,1男2女}
function  this.actUser(nickname,sex,callback)
    local param={["nickname"]=nickname,["sex"]=sex} 
    local t=this.GetTable("GameMember.actUser",param)
    local rt=json.encode(t)  
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
    callback(code,m,str)
end) 
    log("-----------Finish_actUser--------") 
end


--mtype， 0 注册   1 修改密码
--根据uid获得验证码 {"mtype":2忘记保险箱密码,"stype":发送类型（0手机1邮箱)}
function  this.getValidByUid(mtype,stype,uno,callback)
    --local param={["mtype"]=mtype,["stype"]=stype}
    --local param={["mtype"]=mtype,["stype"]=stype,["uno"]=uno}
    local param={["mtype"]=mtype,["uno"]=uno}
    local t=this.GetTable("GameMember.getValid",param)
    local rt=json.encode(t)
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
    callback(code,m,str)
end) 
    log("-----------Finish_getValidByUid--------") 
end



--获得用户详细信息 {"uid":用户id,"gid":游戏id}
function  this.getUserInfo(uid,gid,callback)
    log("获得用户详细信息")
    local param={["uid"]=uid,["gid"]=gid}
    local t=this.GetTable("GameMember.getUserInfo",param)
    local rt=json.encode(t) 
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
    callback(code,m,str)
end) 
    log("-----------Finish_getUserInfo--------") 
end

--根据uid获取用户信息
function this.GetUserInfo(uid,callback)
    local param = {["uid"] = uid}
    local t = this.GetTable("GameMember.getUserInfo100", param)
    local rt = json.encode(t)
    this.HttpPOSTRequest(rt, function(str)
        log("----------GetUserInfo--------"..str)
        if callback ~= nil then
            callback(str)
        end
    end, true)
    log("-----------Finish_GetUserInfo--------") 
end


--获得系统时间
function  this.sysTime(param,callback) 
    local t=this.GetTable("GameMember.sysTime",param)
    local rt=json.encode(t)
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
    callback(code,m,str)
end) 
    log("-----------Finish_sysTime--------") 
end

 
--用户设置头像{"imagetype":用户头像类型(1系统2自定义),"imageurl":"用户头像地址"}
function  this.setImage(imagetype,imageurl,callback)
    local param={["imagetype"]=imagetype,["imageurl"]=imageurl}
    local t=this.GetTable("GameMember.setImage",param)
    local rt=json.encode(t)
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
    callback(code,m,str)
end) 
    log("-----------Finish_setImage--------") 
end



--获得用户头像[用户id,用户id,用户id.....][6,7,8]
function  this.getImage(param,callback) 
    log("获得用户头像")
    local t=this.GetTable("GameMember.getImage",param)
    local rt=json.encode(t)
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
    callback(code,m,str)
end) 
    log("-----------Finish_getImage--------") 
end


--{"share_uid":"分享用户ID","rtype":第三方注册类型(2微信 3QQ 4ucgame 5ysdk微信 6ysdkQQ 7笨手机 8富豪 9游客 10奇酷),"openid":微信code,"access_token":token,"logintime":登陆时间,"subrtype":"code 或者 openid"}
function  this.otherLogin(rtype,openid,access_token,logintime,subrtype,share_uid,callback)
    log("第三方注册登录")
    local param={["rtype"]=rtype,["openid"]=openid,["access_token"]=access_token,["logintime"]=logintime,["subrtype"]=subrtype,["share_uid"] = share_uid} 
    local t=this.GetTable("GameMember.otherLogin",param) 
    local rt=json.encode(t) 
    log("http_request_interface------" .. rt)
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
        log("收到返回")
        log(str)
        if code == -1 then
            fast_tip.Show("您的网络状态不好，请稍后再试")
        else 
            callback(code,m,str)
        end 
    end) 
end

function this.getFreshToken( code , callback)
    local rt = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=wx066fcebf5c777f09&secret=9af1fcaff5152062529ea91356146888&code="..code.."&grant_type=authorization_code"

    log(rt)
    NetWorkManage.Instance:HttpPostRequestWithData(rt,nil,function (code,m,str)
        log("收到返回")
        log(str)
        if code == -1 then
            fast_tip.Show("您的网络状态不好，请稍后再试")
        else 
            callback(code,m,str)
        end 
    end) 
end

--{"share_uid":"分享用户ID","rtype":第三方注册类型(2微信 3QQ 4ucgame 5ysdk微信 6ysdkQQ 7笨手机 8富豪 9游客 10奇酷),"openid":微信code,"access_token":token,"logintime":登陆时间,"subrtype":"code 或者 openid"}
function  this.PhoneLogin(rtype,openid,access_token,logintime,subrtype,share_uid,uno,verify,pwd,callback)
    log("第三方注册登录")
    local param={["rtype"]=rtype,["openid"]=openid,["access_token"]=access_token,["logintime"]=logintime,["subrtype"]=subrtype,["share_uid"] = share_uid,["uno"]=uno,["verify"]=verify,["pwd"]=pwd} 
    local t=this.GetTable("GameMember.Login",param) 
    local rt=json.encode(t) 
    log("http_request_interface------" .. rt)
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
        log("收到返回")
        log(str)
        if code == -1 then
            fast_tip.Show("您的网络状态不好，请稍后再试")
        else 
            callback(code,m,str)
        end 
    end) 
end
 
--第三方账号绑定手机号或者邮箱{"uno":"手机或者邮箱","verify":验证码}
function  this.otherBind(uno,verify,callback)
    local param={["uno"]=uno,["verify"]=verify} 
    local t=this.GetTable("GameMember.otherBind",param) 
    local rt=json.encode(t)  
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
    callback(code,m,str)
end) 
    log("-----------Finish_otherBind--------") 
end

--第三方账号绑定手机号或者邮箱{"uno":"手机或者邮箱","verify":验证码, pwd, nickname}
function  this.PhoneRegisterUser(uno,verify,pwd,nickname,callback)
    local param={["uno"]=uno,["verify"]=verify,["pwd"]=pwd,["nickname"]=nickname} 
    local t=this.GetTable("GameMember.registerUser",param) 
    local rt=json.encode(t)  
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
        callback(code,m,str)
    end) 
    log("-----------Finish_otherBind--------") 
end



--ysdk查询余额{"openid":openid,"access_token":pay_token,"openkey":openkey,"pf":"pf","pfkey":pfkey,"accout_type":qq或者wx}
function  this.getBalanceM(openid,access_token,openkey,pf,pfkey,accout_type,callback)
    local param={["openid"]=openid,["access_token"]=access_token,["openkey"]=openkey,["pf"]=pf,["pfkey"]=pfkey,["accout_type"]=accout_type}
    local t=this.GetTable("GameMember.getBalanceM",param)
    local rt=json.encode(t) 
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
    callback(code,m,str)
end) 
    log("-----------Finish_getBalanceM--------") 
end



--验证身份证{"name":"姓名","id_no":"身份证号"}
function  this.idCardVerify(name,id_no,callback)
    local param={["name"]=name,["id_no"]=id_no}
    local t=this.GetTable("GameMember.idCardVerify",param)
    local rt=json.encode(t)
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
    callback(code,m,str)
end) 
    log("-----------Finish_idCardVerify--------") 
end





--获得账户信息null
function  this.getAccount(param,callback) 
    local t=this.GetTable("GameMember.getAccount",param)
    local rt=json.encode(t)
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
    callback(code,m,str)
end) 
    log("-----------Finish_getAccount--------") 
end




--是否填写过身份 null
function  this.checkIdCard(param,callback) 
    local t=this.GetTable("GameMember.checkIdCard",param) 
    local rt=json.encode(t)
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
    callback(code,m,str)
end) 
    log("-----------Finish_checkIdCard--------") 
end




--获得客户端配置 null
function  this.getClientConfig(param,callback) 
    local t=this.GetTable("GameSAR.getClientConfig",param) 
    local rt=json.encode(t)
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
    callback(code,m,str)
end) 
    log("-----------Finish_getClientConfig--------")
end


--获取房间列表{gid:游戏ID}
function this.getRoomListByGid(param,callback)
    local t=this.GetTable("GameSAR.getRoomListByGid",param) 
    local rt=json.encode(t)
    waiting_ui.Show()
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
        waiting_ui.Hide()
        if code == -1 then
            fast_tip.Show("您的网络状态不好，请稍后再试")
        else 
            callback(code,m,str)
        end 
    end)
    log("-----------Finish_getRoomListByGid--------")
end

--快速入座{gid:游戏ID}
function this.roomFastEnter(param,callback)
    local t=this.GetTable("GameSAR.roomFastEnter",param) 
    local rt=json.encode(t)
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
        callback(code,m,str)
    end)
    log("-----------Finish_roomFastEnter--------")
end


--开房{"gid":游戏id,"rounds":局数,"pnum",人数,"hun",混牌,"hutype":胡牌,"wind":风牌,"lowrun":下跑,"gangrun":杠跑,"dealeradd":庄家加底,"gfadd":杠上花加倍,"spadd":七对加倍}
function  this.createRoom(param, callback, method) 
   -- local param={["gid"]=gid,["rounds"]=rounds,["pnum"]=pnum,["hun"]=hun,["hutype"]=hutype,["wind"]=wind,["lowrun"]=lowrun,["gangrun"]=gangrun,["dealeradd"]=dealeradd,["gfadd"]=gfadd,["spadd"]=spadd} 
    local t=this.GetTable(method,param)  
    local rt=json.encode(t)
	log ("createroom:  "..tostring(rt))
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
        log(str)
        callback(code,m,str) 
    end) 
    log("-----------Finish_createRoom--------") 
end

--获得用户已开房间列表 {"gid":游戏id,"status":状态0已开房1已开局2已结算,"page":第几页,从0开始}
function  this.getGameRoomList(gid,status,page,callback) 
    local param={["gid"]=gid,["status"]=status,["page"]=page}
    local t=this.GetTable("GameSAR.getGameRoomList",param) 
    local rt=json.encode(t)  
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
        callback(code,m,str)
    end) 
    log("-----------Finish_getGameRoomList--------") 
end

function this.getRoomSimpleList(gid,status,page,callback)
    local param={["gid"]=gid,["status"]=status,["page"]=page}
    local t=this.GetTable("GameSAR.getRoomSimpleList",param) 
    local rt=json.encode(t)  
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
        callback(code,m,str)
    end) 
    log("-----------Finish_getGameRoomList--------")     
end

-- 根据房号查找房间信息{"gid":游戏id,"rno":房号}
function  this.getRoomByRno(rno, callback)
    log("this.getRoomByRno")
    local param={["rno"]=rno}
    local t=this.GetTable("GameSAR.getRoomByRno", param) 
    local rt=json.encode(t)
    waiting_ui.Show()
    NetWorkManage.Instance:HttpPOSTRequest(rt, function (code,m,str)        
        callback(code,m,str)
    end) 

    log("-----------Finish_getRoomByRno--------")
end

--根据房id查找房间信息 {"rid":房号}
function  this.getRoomByRid(rid,rank,callback) 
    local param={["rid"]=rid,["rank"]=rank} 
    local t=this.GetTable("GameSAR.getRoomByRid",param) 
    local rt=json.encode(t)  
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
        callback(code,m,str)
    end) 
    log("-----------Finish_getRoomByRid--------") 
end


--根据用户ID获取玩牌列表 {"gid":游戏id,"status":状态0已开房1已开局2已结算,"page":第几页,从0开始}
function  this.getGameRoomListByUid(gid,status,page,callback) 
    local param={["gid"]=gid,["status"]=status,["page"]=page} 
    local t=this.GetTable("GameSAR.getGameRoomListByUid",param) 
    local rt=json.encode(t)  
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
        callback(code,m,str)
    end) 
    log("-----------Finish_getGameRoomListByUid--------") 
end

--根据用户ID获取简单玩牌数据列表 {"gid":游戏id,"status":状态0已开房1已开局2已结算,"page":第几页,从0开始}
function this.getRoomSimpleByUid(gid,status,page,callback)
    local param={["gid"]=gid,["status"]=status,["page"]=page} 
    local t=this.GetTable("GameSAR.getRoomSimpleByUid",param) 
    local rt=json.encode(t)  
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
        callback(code,m,str)
    end) 
    log("-----------Finish_getGameRoomSimpleByUid--------") 
end


--获得公告列表 null
function  this.getNotice(param,callback)  
    local t=this.GetTable("GameEmail.getNotice",param) 
    local rt=json.encode(t) 
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
        callback(code,m,str)
    end) 
    log("-----------Finish_getNotice--------") 
end



--获得接收到的邮件 param:		int 页码,第一次传0
function  this.getEmails(param,callback)  
    local t=this.GetTable("GameEmail.getEmails",param)
    local rt=json.encode(t) 
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
        callback(code,m,str)
    end) 
    log("-----------Finish_getEmails--------") 
end




--读邮件 param:		int 邮件eid
function  this.readEmail(param,callback)  
    local t=this.GetTable("GameEmail.readEmail",param)
    local rt=json.encode(t)  
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
        callback(code,m,str)
    end) 
    log("-----------Finish_readEmail--------") 
end





--领取邮件附件 param:		int 邮件eid
function  this.getEmailAttachment(param,callback)  
    local t=this.GetTable("GameEmail.getEmailAttachment",param)
    local rt=json.encode(t)  
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
        callback(code,m,str)
    end) 
    log("-----------Finish_getEmailAttachment--------") 
end



--获得新邮件 null
function  this.getNewEmails(param,callback)  
    local t=this.GetTable("GameEmail.getNewEmails",param)
    local rt=json.encode(t) 
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
        callback(code,m,str)
    end) 
    log("-----------Finish_getNewEmails--------") 
end



--创建订单 {"stype":支付平台类型(1微信2支付宝3爱贝4UC5腾讯6笨手机8百度),"dpid":钻石价格id,"orderid":百度支付单号}
function  this.prepay(param,callback)  
    local t=this.GetTable("GameOrder.prepay",param)
    local rt=json.encode(t)
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
        callback(code,m,str)
    end) 
    log("-----------Finish_prepay--------") 
end


function this.getTask(param,callback)
    local t=this.GetTable("Modwelfare.getTask",param)
    local rt=json.encode(t)
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
        callback(code,m,str)
    end) 
    log("-----------Finish_getTask--------") 
    -- body
end

function this.getimage(url,width,height,callback)
    if string.len(url) < 10 then
        log("图片地址太短："..url)
        return
    end
    NetWorkManage.Instance:HttpDownImage(url,width,height,function (states,tex)
        callback(states,tex)
    end)
   
end

function this.GetLotteryDayData(param,callback)
    log("inter----------------GetLotteryDayData")
    local t=this.GetTable("ModDayrwd.roll",param)
    local rt=json.encode(t)
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
        callback(code,m,str)
    end) 
    log("-----------GetLotteryDayData--------") 

end

function this.GetLotteryCfgData(param,callback)
    local t=this.GetTable("ModDayrwd.getRollSignin",param)
    local rt=json.encode(t)
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
        callback(code,m,str)
    end) 
    log("-----------GetLotteryCfgDayData--------") 

end

function this.rwd(param,callback)
    local t=this.GetTable("Modwelfare.rwd",param)
    local rt=json.encode(t)
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
        callback(code,m,str)
    end) 
    log("-----------Finish_rwd--------") 
end

--获取商品配置列表
function this.getProductCfg(param,callback)
    local t=this.GetTable("GameStore.getProductCfg",param) 
    local rt=json.encode(t)
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
        callback(code,m,str)
    end)
    log("-----------Finish_roomFastEnter--------")
end


-- 请求支付订单
-- "stype":支付平台类型(1微信2支付宝3爱贝4UC5腾讯6笨手机8百度),
-- "dpid":钻石价格id,
-- "orderid":百度支付单号
function this.GetPayOrder( stype,pid,num,callback)
    if not stype or not pid or not num then return end

     local param={["pid"]=pid,["stype"]=stype,["num"]=num,["openid"] = App.openid} 
    local t=this.GetTable("GameStore.prepay",param) 
    local rt=json.encode(t)
     log("-----------GetPayOrder--------" .. rt )
    NetWorkManage.Instance:HttpPOSTRequest(rt,function (code,m,str)
        if code == -1 then
            fast_tip.Show("您的网络状态不好，请稍后再试")
        else 
            callback(code,m,str)
        end 
    end) 
    log("-----------Finish_GetIAppPayOrder--------") 
end

--endregion


function this.ToRoom(param, callback)
    waiting_ui.Show()
    local t=this.GetTable("GameSAR.toRoom", param)     
    local rt=json.encode(t)  
    log("ToRoom------" .. rt)   
    NetWorkManage.Instance:HttpPOSTRequest(rt, function (code, m, str)        
        waiting_ui.Hide()
        if code == -1 then
            fast_tip.Show("网络连接失败，请稍后重试")
        else 
            callback(code, m, str)
        end 
    end)   
end

--[[--
 * @Description: 只在进第一次进游戏时查询状态  
 ]]
function this.QueryStatus(param, callback)
    log("只在进第一次进游戏时查询状态")
    --waiting_ui.Show()
    local t=this.GetTable("GameSAR.queryStatus", param) 
    local rt=json.encode(t)    
    log("rt------------------------------"..tostring(rt))
    NetWorkManage.Instance:HttpPOSTRequest(rt, function (code, m, str)        
        --waiting_ui.Hide()
        if code == -1 then
            fast_tip.Show("网络连接失败，请稍后重试")
        else 
            callback(code, m, str)
        end 
    end)    
end
