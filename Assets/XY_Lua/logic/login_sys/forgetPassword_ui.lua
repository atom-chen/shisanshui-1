
forgetPassword_ui = ui_base.New()

local this = forgetPassword_ui

local logoCoroutine = nil

local param = {}
local tel_num = nil
local ver_num = nil
local password = nil


function this.Show()
	log("show")
	if this.gameObject==nil then
		require ("logic/login_sys/forgetPassword_ui")
		this.gameObject = newNormalUI("Prefabs/UI/Login/forgetPassword_ui")
		--测试用，直接登录		
	else
		this.gameObject:SetActive(true)
	end
    
end

function this.Start()
	this.InitView()
	this.UpdateView()
end

function this.PlayOpenAmination()
	
end

function this.InitView()
	local this = this
	local btn_close = child(this.gameObject.transform,"forgetPassword_panel/Panel_Top/btn_close")
	if btn_close ~= nil then
		addClickCallbackSelf(btn_close.gameObject,this.CloseWin,this)
	end
	local btn_sure = child(this.gameObject.transform,"forgetPassword_panel/Panel_Top/btn_sure")
	if btn_sure ~= nil then
		addClickCallbackSelf(btn_sure.gameObject,this.OnSureClick,this)
	end
	--绑定
	local Panel_Middle = child(this.gameObject.transform,"forgetPassword_panel/Panel_Middle")
	this.accountInput = componentGet(child(Panel_Middle,"tel_num/type_phonenum"),"UIInput")--手机号
	this.vernumInput = componentGet(child(Panel_Middle,"ver_num/type_vernum"),"UIInput")--验证码
	this.passwordInput = componentGet(child(Panel_Middle,"password/type_password"),"UIInput")--密码
	this.getVer_Btn = child(Panel_Middle,"getVerBtn")
	if this.getVer_Btn then
		addClickCallbackSelf(this.getVer_Btn.gameObject,this.OnGetVerClick,this)
	end

end


function this.GetValue()
	tel_num = this.accountInput.value
	ver_num = this.vernumInput.value
	password = this.passwordInput.value
end


function this.UpdateView()
	this.accountInput.value = ""
	this.vernumInput.value = ""
	this.passwordInput.value = ""
end

function this.CloseWin()
	ui_sound_mgr.PlayCloseClick()
	UI_Manager:Instance():CloseUiForms("forgetPassword_ui")
end

function this.OnGetVerClick()
	this:GetValue()
	if tel_num == "" or string.len(tel_num) ~= 11 then
		--UI_Manager:Instance():FastTip(LanguageMgr.GetWord(10311))
		fast_tip.Show("配牌错误，ID："..tostring(card))
		return
	end

	param.appid = 22
	param.phone = tel_num
--根据uid获得验证码 {"mtype":2忘记保险箱密码,"stype":发送类型（0手机1邮箱)}
	http_request_interface.getValidByUid(0,0,tel_num, function(code,m,str)
			log(str)
			local s=string.gsub(str,"\\/","/")  
			local t=ParseJsonStr(s) 
			this.RegisterCallBack(t)      
      	end)
	-- HttpProxy.SendGlobalRequest("/login",HttpCmdName.GetPhoneVerifyCode,param,
	-- 	function (msgTab)
	-- 		logError(1111,GetTblData(msgTab))
	-- 	end,this)
end

function this.RegisterCallBack( data )
	log("注册成功")
	loglog(GetTblData(data))
end

function this.OnClose()
	this.accountInput.value = ""
	this.vernumInput.value = ""
	this.passwordInput.value = ""

end


function this.OnSureClick()
	param = {}
	this:GetValue()
	if tel_num == "" or string.len(tel_num) ~= 11 then
		fast_tip.Show("请输入正确的手机号码")
		return
	elseif ver_num == "" or string.len(ver_num) ~= 6 then
		fast_tip.Show("请输入正确的验证码")
		return
	elseif password == "" or string.len(password) < 6 or string.len(password) > 15 then
		fast_tip.Show("请输入6~15位数字或者字母的密码")
		return
	end
	-- param.appid = global_define.appConfig.appId
	-- param.vercode = ver_num
	-- param.phone = tel_num
	-- param.pwd = password
	-- HttpProxy.SendGlobalRequest("/login",HttpCmdName.UpdatePwdByPhone,param,
	-- 	function (userInfo)
	-- 		logError(22222,GetTblData(userInfo))
	-- 	end,this)
--
--第三方账号绑定手机号或者邮箱{"uno":"手机或者邮箱","verify":验证码, pwd, nickname}
	http_request_interface.PhoneRegisterUser(tel_num,ver_num,password, "", function (code,m,str)
		if code then
			
		end
		local s=string.gsub(str,"\\/","/")  
        local t=ParseJsonStr(s)
        log(GetTblData(t))
		-- data_center.SetLoginAllInfo(t) 
  --       http_request_interface.setUserInfo(t["user"]["uid"],t["session_key"],t["user"]["deviceid"],1,t["passport"]["siteid"],1) --初始化赋值
		-- if data_center.GetAllInfor().ret == 0 then
		-- 	this.EnterHallRsp("")
		-- 	PlayerPrefs.SetInt("LoginType", this.loginType)
		-- 	PlayerPrefs.SetString("AccessToken", 0)
		-- 	PlayerPrefs.SetString("OpenID", NetWorkManage.Instance:GetMacAddress())
		-- 	local urlStr = string.format(data_center.url,data_center.GetLoginRetInfo().uid,data_center.GetLoginRetInfo().session_key)
		-- 	SocketManager:createSocket("hall",urlStr,"online", 1)		
		-- else
		-- 	log("LoginError:"..data_center.GetAllInfor().msg..tostring(data_center.GetAllInfor().ret));		
		-- end
	end)
	--this.Hide()
		
end
