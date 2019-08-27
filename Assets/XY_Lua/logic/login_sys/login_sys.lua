--[[--
* @Description: 登陆流程管理类
* @Author:      shine
* @FileName:    login_sys.lua
* @DateTime:    2017-05-16 11:50:39
]]
require "logic/network/majong_request_interface"
require "logic/network/http_request_interface" 
require "logic/common_ui/fast_tip"
ClubModel = require ("logic/club_sys/ClubModel")
SocketManager = require("logic.network.SocketManager"):create()


login_sys = {}
local this = login_sys



--内网
--local url = "ws://211.159.188.91:8001?uid=1002&token=b"
--this.url = "ws://192.168.2.6:8001?uid=%s&token=%s"

--外网
--this.url = "ws://211.159.188.91:8001?uid=%s&token=%s"

-- this.url = "ws://192.168.2.173:8021?uid=%s&token=%s"

local logoutTimer = nil

local DoReqServerData = nil     --请求服务器数据（一些大厅里面刚进去就需要从服务器拉取的数据在这里处理）

this.isAgreeContract = true	--是否同意用户协议
this.loginType = 9   --登录类型，默认游客登录
this.isClicked = false --判断登录界面快速多次点击限制
this.share_uid = "" -- 分享用户id 
--[[--
* @Description: 启动事件
]]
function this.Start()
end

--[[--
* @Description: 注册事件
]]
function this.RegisterEvents()

end

--[[--
 * @Description: 将各个系统的lua文件集中包含
 ]]
function RequireSystemLuas()
	require "logic/framework/data_center"
end

--[[--
* @Description: 启动游戏
]]
function this.StartGame()
	RequireSystemLuas()
	this.RegisterEvents()
	
	--联网模式下不需要调用，由服务器切换
	if TestMode.IsCmdSingleMode() then
		--直接进入大厅（To do）
	end
end


function this.InitPlugins(istest)
	YX_APIManage.Instance:InitPlugins(istest)
	YX_APIManage.Instance:YX_IsEnableBattery(true);
	YX_APIManage.Instance:YX_GetPhoneStreng();
end



function this.AutoLogin(account)
	log("===============Application.platform----"..tostring(Application.platform))
	this.loginType = PlayerPrefs.GetInt("LoginType")

	--if tostring(Application.platform) == "WindowsEditor" then
	--	if this.loginType > 0 then				
			this.OnPlatLoginOK(nil, nil, account)
	--	end
	-- elseif tostring(Application.platform)  == "Android" or tostring(Application.platform) == "IPhonePlayer" then
	-- 	if PlayerPrefs.HasKey("LoginType") and PlayerPrefs.HasKey("AccessToken") and PlayerPrefs.HasKey("OpenID") then												
	-- 		if this.loginType > 0 then				
	-- 			local msgTable = {}
	-- 			msgTable.LoginType = this.loginType
	-- 			msgTable.AccessToken = PlayerPrefs.GetString("AccessToken")
	-- 			msgTable.OpenID = PlayerPrefs.GetString("OpenID")

	-- 			--如果是安卓手机游客登录流程
	-- 			if this.loginType == 9 then
	-- 				this.OnPlatLoginOK(nil, nil, account)
	-- 			else --微信或QQ自动登录流程
	-- 				this.LoginAndJumintoLobby(msgTable)
	-- 			end
	-- 		end
	-- 	end				
	-- end
end

--[[--
* @Description: 平台登陆成功回调
* @param:       平台登陆信息
]]
function this.OnPlatLoginOK(accInfo, isReconnet,account)	
	if this.isAgreeContract == false then
		--弹出提示框没有同意服务条款
		fast_tip.Show("请选择同意服务条款")
		this.isClicked = false
		 return 
	end
	
	log("-------------------------"..tostring(ret));
	this.loginType = 9
	--平台成功回调后开始连接服务器并登陆服务器 
	log("this.share_uid=="..this.share_uid)
    --http_request_interface.otherLogin(this.loginType, NetWorkManage.Instance:GetMacAddress(),
    if account == nil then account = NetWorkManage.Instance:GetMacAddress() end
    http_request_interface.otherLogin(this.loginType, account,--NetWorkManage.Instance:GetMacAddress(),
    		0,0,0,this.share_uid,function (code,m,str)
		if code then
			
		end
		this.isClicked = false
		local s=string.gsub(str,"\\/","/")  
        local t=ParseJsonStr(s)
		data_center.SetLoginAllInfo(t) 
        http_request_interface.setUserInfo(t["user"]["uid"],t["session_key"],t["user"]["deviceid"],1,t["passport"]["siteid"],1) --初始化赋值
		if data_center.GetAllInfor().ret == 0 then
	-- 		network_mgr.SetNetChnl(NetEngine.Instance:GetGameChnl())
	-- 		local uid = data_center.GetLoginRetInfo()
	-- 		log("URL:"..this.url)
	-- 		local urlStr = string.format(this.url,data_center.GetLoginRetInfo().uid,data_center.GetLoginRetInfo().uid)
	-- 		network_mgr.Connect(urlStr)
			
	-- --		majong_request_interface.HeartBeatReq()

			this.EnterHallRsp("")

			PlayerPrefs.SetInt("LoginType", this.loginType)
			PlayerPrefs.SetString("AccessToken", 0)
			PlayerPrefs.SetString("OpenID", NetWorkManage.Instance:GetMacAddress())

			--俱乐部请求
			ClubModel:ctor()
			ClubModel:Init()
			Notifier.dispatchCmd(GameEvent.LoginSuccess)
			local urlStr = string.format(data_center.url,data_center.GetLoginRetInfo().uid,data_center.GetLoginRetInfo().session_key)
			SocketManager:createSocket("hall",urlStr,"online", 1)		
		else
			log("LoginError:"..data_center.GetAllInfor().msg..tostring(data_center.GetAllInfor().ret));		
		end
	end)	
end

--[[--
* @Description: 手机登陆成功回调
* @param:       手机登陆信息
]]
function this.OnPhoneLoginOK(accInfo, isReconnet,tel_num, password, ver_num)	
	if this.isAgreeContract == false then
		--弹出提示框没有同意服务条款
		fast_tip.Show("请选择同意服务条款")
		this.isClicked = false
		 return 
	end
	
	log("-------------------------"..tostring(ret));
	this.loginType = 9
	--平台成功回调后开始连接服务器并登陆服务器 
	log("this.share_uid=="..this.share_uid)
    http_request_interface.PhoneLogin(this.loginType, account,--NetWorkManage.Instance:GetMacAddress(),
    		0,0,0,this.share_uid,tel_num,ver_num,password, function (code,m,str)
		if code then
		end
		local s=string.gsub(str,"\\/","/")  
        local t=ParseJsonStr(s)
		data_center.SetLoginAllInfo(t) 
        http_request_interface.setUserInfo(t["user"]["uid"],t["session_key"],t["user"]["deviceid"],1,t["passport"]["siteid"],1) --初始化赋值
		if data_center.GetAllInfor().ret == 0 then
	-- 		network_mgr.SetNetChnl(NetEngine.Instance:GetGameChnl())
	-- 		local uid = data_center.GetLoginRetInfo()
	-- 		log("URL:"..this.url)
	-- 		local urlStr = string.format(this.url,data_center.GetLoginRetInfo().uid,data_center.GetLoginRetInfo().uid)
	-- 		network_mgr.Connect(urlStr)
			
	-- --		majong_request_interface.HeartBeatReq()

			this.EnterHallRsp("")

			PlayerPrefs.SetInt("LoginType", this.loginType)
			PlayerPrefs.SetString("AccessToken", 0)
			PlayerPrefs.SetString("OpenID", NetWorkManage.Instance:GetMacAddress())


			local urlStr = string.format(data_center.url,data_center.GetLoginRetInfo().uid,data_center.GetLoginRetInfo().session_key)
			SocketManager:createSocket("hall",urlStr,"online", 1)		
		else
			log("LoginError:"..data_center.GetAllInfor().msg..tostring(data_center.GetAllInfor().ret));		
		end
	end)
end

function this.WeiXinLogin()
	if this.isAgreeContract == false then 
		fast_tip.Show("请选择同意服务条款")
		this.isClicked = false
		return 
	end
	this.loginType = 2
	
--	YX_APIManage.Instance:WeiXinLogin(this.LoginAndJumintoLobby(msg))
	YX_APIManage.Instance:WeiXinLogin(function(msg)	
		local msgTable = ParseJsonStr(msg)
		data_center.SetLoginRetInfo(msgTable)

		log("Unity_WeiXinLogin=="..tostring(msgTable.access_token));
		if msgTable.result == 0 then
			log("this.share_uid=="..this.share_uid)
			http_request_interface.otherLogin(this.loginType, msgTable.access_token, msgTable.access_token, 0, "code", this.share_uid, function (code,m,str)
			-- this.share_uid = ""
			log("Unity_WeiXin1=="..str)
			log("Unity_WeiXin1=="..tostring(code))
			log("Unity_WeiXin1=="..m)
			this.isClicked = false
			local s=string.gsub(str,"\\/","/")
			log("Unity_WeiXin2=="..s)

			local t=ParseJsonStr(s)
			LogW("ttttttttttttttt---",t)
			data_center.SetLoginAllInfo(t)
			http_request_interface.setUserInfo(t["user"]["uid"],t["session_key"],t["user"]["deviceid"],1,t["passport"]["siteid"],1) --初始化赋值
				if data_center.GetAllInfor().ret == 0 then
		-- 			network_mgr.SetNetChnl(NetEngine.Instance:GetGameChnl())
		-- 			local urlStr = string.format(data_center.url,data_center.GetLoginRetInfo().uid,data_center.GetLoginRetInfo().uid)
		-- 			network_mgr.Connect(urlStr)
		-- --		majong_request_interface.HeartBeatReq()
					PlayerPrefs.SetInt("LoginType", this.loginType)
					PlayerPrefs.SetString("AccessToken", t["access_token"])
					PlayerPrefs.SetString("OpenID", t["openid"])


					this.EnterHallRsp("")
					local urlStr = string.format(data_center.url,data_center.GetLoginRetInfo().uid,data_center.GetLoginRetInfo().session_key)
					SocketManager:createSocket("hall",urlStr,"online", 1)	  
				else
					log("LoginError:"..data_center.GetAllInfor().msg..tostring(data_center.GetAllInfor().ret));
				end
			end)
		else
			log("Login Failed"..tostring(msgTable))
		end
	end)
	
end

function this.QQLogin()
	if this.isAgreeContract == false then 
		fast_tip.Show("请选择同意服务条款")
		this.isClicked = false			
		return 
	end
	this.loginType = 3
	
	log("loginType:"..this.loginType)
--	YX_APIManage.Instance:QQLogin(this.LoginAndJumintoLobby(msg))
	  YX_APIManage.Instance:QQLogin(function(msg)
			local msgTable = ParseJsonStr(msg)
		log("Unity_QQLogin=="..tostring(msgTable.access_token));
		log("Unity_QQLoginOpenId=="..tostring(msgTable.openId));
		if msgTable.result == 0 then
			http_request_interface.otherLogin(this.loginType,msgTable.openId,msgTable.access_token,0,"code",this.share_uid,function (code,m,str)
		    this.isClicked = false
			local s=string.gsub(str,"\\/","/")
			local t=ParseJsonStr(s)
	--		PlayerPrefs:SetString("assess_token",t)
			data_center.SetLoginAllInfo(t)
				if data_center.GetAllInfor().ret == 0 then --登录成功
				-- network_mgr.SetNetChnl(NetEngine.Instance:GetGameChnl())
				-- local urlStr = string.format(data_center.url,data_center.GetLoginRetInfo().uid,data_center.GetLoginRetInfo().uid)
				-- network_mgr.Connect(urlStr)
	--			majong_request_interface.HeartBeatReq()
				PlayerPrefs.SetInt("LoginType",this.loginType);
				PlayerPrefs.SetString("AccessToken",msg)
				this.EnterHallRsp("") 
				local urlStr = string.format(data_center.url, data_center.GetLoginRetInfo().uid, data_center.GetLoginRetInfo().session_key)
				SocketManager:createSocket("hall",urlStr,"online", 1)	
			else
				log("LoginError:"..data_center.GetAllInfor().msg..tostring(data_center.GetAllInfor().ret));
			end 
			end)
		else
			log("Login Failed"..tostring(msgTable))
		end
	end)
	
end

function this.LoginAndJumintoLobby(msgTable)
	if this.isAgreeContract == false then 
		fast_tip.Show("请选择同意服务条款")
		this.isClicked = false
		return 
	end
	this.loginType = msgTable.LoginType

	log("this.share_uid=="..this.share_uid)
	LogW("LoginAndJumintoLobby------",msgTable)
	http_request_interface.otherLogin(msgTable.LoginType, msgTable.OpenID, msgTable.AccessToken, 0, "openid", this.share_uid, function (code,m,str)
		this.share_uid = ""
		log("Unity_WeiXin1=="..str)
		log("Unity_WeiXin1=="..tostring(code))
		log("Unity_WeiXin1=="..m)
		this.isClicked = false
		local s=string.gsub(str,"\\/","/")
		log("Unity_WeiXin2=="..s)
		local t=ParseJsonStr(s)
		LogW("LoginAndJumintoLobby  ttttttttttttttt---",t)
		data_center.SetLoginAllInfo(t)
		http_request_interface.setUserInfo(t["user"]["uid"],t["session_key"],t["user"]["deviceid"],1,t["passport"]["siteid"],1) --初始化赋值
		if data_center.GetAllInfor().ret == 0 then
			PlayerPrefs.SetInt("LoginType", this.loginType)
			PlayerPrefs.SetString("AccessToken", t["access_token"])
			PlayerPrefs.SetString("OpenID", t["openid"])

			this.EnterHallRsp("")
			local urlStr = string.format(data_center.url,data_center.GetLoginRetInfo().uid,data_center.GetLoginRetInfo().session_key)
			SocketManager:createSocket("hall",urlStr,"online", 1)	  
		else
			log("LoginError:"..data_center.GetAllInfor().msg..tostring(data_center.GetAllInfor().ret));
		end
	end)	
end


--[[--
 * @Description: 进入新手引导场景
 ]]
function this.GotoGuide()

end

--[[--
* @Description: 注销
]]
function this.Logout()
	beginner_guide_sys.Uninit()
	--发送注销请求（To Do）

	logoutTimer = Timer.New(function () this.HandleLogout() end, 0.2, 1)
	logoutTimer:Start()
end

--[[--
* @Description: 注销回包
]]
function this.OnLogout(pkgData)	
	if logoutTimer ~= nil then 
		logoutTimer:Stop()
	end
	this.HandleLogout()
end

--[[--
* @Description: 处理登出
* @param:       string name
* @return:      nil
]]
function this.HandleLogout(reason)
	network_mgr.ResetNetWork()

	game_scene.DestroyCurSence()
	GameKernel.ShowUpdateUI()
end

--[[--
 * @Description: 加载完场景做的第一件事
 ]]
function this.HandleLevelLoadComplete()
	gs_mgr.ChangeState(gs_mgr.state_login)
	map_controller.SetIsLoadingMap(false)

    --删除掉资源热更界面
    local assetUpdateObj = find("AssetUpdateManager")
    if assetUpdateObj ~= nil then
    	destroy(assetUpdateObj)
    end	
end

--[[--
	*@Description: 退出场景前做的最后一件事
]]
function this.ExitSystem()

end


--[[--
 * @Description: 登录大厅处理
 ]]
function this.EnterHallRsp(buffer)
	--if accInfo ~= nil then
		--accLoginInfo = accInfo   --登录用户信息后续再加 先屏蔽

	--	local accInfo = data_center.GetLoginRetInfo()
	--	data_center.SetLoginRetInfo(accInfo)

		--local_storage_sys.SetString_Machine(local_storage_sys.role_accounts, accInfo.Uid) 
		--local_storage_sys.SetString_Machine(local_storage_sys.role_passwd, accInfo.Passwd)
		this.isClicked = false
		destroy(login_ui.gameObject)
		login_ui.gameObject=nil	


		log("登录大厅成功")
		map_controller.LoadHallScene(900001)	
	--end
end

 --[[--
 * @Description: 进入游戏
 ]]
function this.EnterGame()
	this.ReqEnterGame()
end

function this.ReqEnterGame()
	local req = CSPlayerEnterGameReq()
	NetworkMgr.sendPkgWaitForRsp(CS_PLAYER_ENTER_GAME_REQ, req:SerializeToString(), this.OnEnterGameRsp)
end

function this.OnEnterGameRsp(pkgData)
	local rsp = CSPlayerEnterGameRes()
	netdata_rsp_handler.ParseFromString(rsp, pkgData, true)
	if rsp.RetCode==0 then
		Notifier.regist(cmdName.MSG_WAIT_ENTER_GAME_FINISH, this.OnMsgWaitEnterGameFinish)
	end
end

function this.OnMsgWaitEnterGameFinish()
	DoReqServerData()
	if m_function~=nil and msg~=nil then
		mIsInRoleShow = false
		Notifier.remove(cmdName.MSG_WAIT_ENTER_GAME_FINISH, this.OnMsgWaitEnterGameFinish)

		m_function(msg)
	end
end

--[[--
 * @Description: 这时候是entergame 最开始的请求数据时间  
 ]]
function DoReqServerData()
	--test_sys.Init()
end

function this.ReConnectForGM(url)
	--重新进行连接（To DO）
end