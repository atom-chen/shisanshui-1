require "common/TestMode"
require "logic/login_sys/login_sys" 
require "logic/login_sys/forgetPassword_ui"

login_ui = ui_base.New()

local this = login_ui
local transform
local gameObject
local accLoginInfo
local toggle

local logoCoroutine = nil

Version = {
	Dev = 1,
	Test = 2,
	Release = 3,
}
--[[--
* @Description: 显示登陆ui
]]
function this.Show()
	if this.gameObject==nil then
		require ("logic/login_sys/login_ui")
		newNormalUI("Prefabs/UI/Login/login_ui")
		--测试用，直接登录		
	else
		this.gameObject:SetActive(true)
	end
    
end

--[[--
 * @Description: 启动事件
 ]]
 function this.Awake()
 	App = {}
 	App.versionType = Version.Release
 	App.xipai = -1
    local go = GameObject.Find("reporter");
    if go ~= nil then--and App.versionType ~= Version.Release then 
    	go:SetActive(true) 
    	go:GetComponent("Reporter").enabled = true
    end

	local s= YX_APIManage.Instance:read("temp.txt")
	if s~=nil then
      log("login_ui temp.txt str-----" .. s);
      local t=ParseJsonStr(s)
      if t.uid then
      	login_sys.share_uid = t.uid
      end
   	end
    -- local animations=child(this.transform,"tex_bg") 
    -- if animations~=nil then
    --     log()
    --     componentGet(animations.gameObject,"SkeletonAnimation"):ChangeQueue(2999)
    -- end
 end

function this.Start()
	this.RegisterEvents()
	this:RegistUSRelation()
	login_sys.isAgreeContract = true
	
	--this.InitSettingUI()
	login_sys.InitPlugins(true)	
	if App.versionType == Version.Dev then
		login_sys.AutoLogin()
	end	

	if IS_URL_TEST == true then
		newNormalUI("Prefabs/UI/testCmd/testUrl")
	end
end


function this.OnDestroy()
	this:UnRegistUSRelation()
	if logoCoroutine ~= nil then
		coroutine.stop(logoCoroutine)
	end

	if IS_URL_TEST == true then
		require "logic/testCmd/testUrl"
		testUrl.Hide()
	end
end

function this.OnApplicationQuit()
	
end


--[[function this.InitSettingUI()
	ui_sound_mgr.SceneLoadFinish() 
    ui_sound_mgr.PlayBgSound("hall_bgm")	
    ui_sound_mgr.controlValue(0.5)
    ui_sound_mgr.ControlCommonAudioValue(0.5)
end--]]

--[[--
 * @Description: 注册UI事件
 ]]
function this.RegisterEvents()
	local btnYouKe = child(this.transform, "loingPanel/btn_grid/btn_youke_login")
	--btnYouKe.gameObject:SetActive(LuaHelper.openGuestMode)
	if btnYouKe ~= nil then
		addClickCallbackSelf(btnYouKe.gameObject, this.OnBtnYouKeClick, this)
	end

	local btnQQ = child(this.transform, "loingPanel/btn_grid/btn_qq_login")
	if btnQQ ~= nil then
		addClickCallbackSelf(btnQQ.gameObject, this.OnBtnQQClick, this)
	end

	local btnWeiXin = child(this.transform, "loingPanel/btn_grid/btn_weixin_login")
	if btnWeiXin ~= nil then
		addClickCallbackSelf(btnWeiXin.gameObject, this.OnBtnWeiXinClick, this)
	end
    
    initToggleObj(this.transform,"loingPanel/checkBox",this.OnCheckStatusChange,this)    
	
	local btnService = child(this.transform,"loingPanel/text/service")
	if btnService ~= nil then 
		addClickCallbackSelf(btnService.gameObject,this.OnBtnPrivacyOnClick,this)
	end
	local btnPrivacy = child(this.transform,"loingPanel/text/Privacy")
	if btnPrivacy ~= nil then 
		addClickCallbackSelf(btnPrivacy.gameObject,this.OnBtnPrivacyOnClick,this)
	end
	local btnGameLicense = child(this.transform,"loingPanel/text/GameLicense")
	if btnGameLicense ~= nil then
		addClickCallbackSelf(btnGameLicense.gameObject,this.OnBtnGameLicense,this)
	end
	
	local btnChessLicense = child(this.transform,"loingPanel/text/ChessLicense") 
	if btnChessLicense ~= nil then
		addClickCallbackSelf(btnChessLicense.gameObject,this.OnBtnChessLicense,this)
	end


	local registerBtn = child(this.transform,"loingPanel/registerBtn") 
	if registerBtn ~= nil then
		addClickCallbackSelf(registerBtn.gameObject,this.registerUser,this)
	end
	
	this.account = subComponentGet(this.transform, "loingPanel/account", typeof(UIInput))
	this.password = subComponentGet(this.transform, "loingPanel/password", typeof(UIInput))
	if App.versionType == Version.Release then
		this.account.gameObject:SetActive(false)
		this.password.gameObject:SetActive(false)
	else
		this.account.gameObject:SetActive(true)
		this.password.gameObject:SetActive(true)
	end
    --subComponentGet(this.transform, "btn_grid", typeof(UIGrid)):Reposition()

end

function this.registerUser()
	log("注册")
	forgetPassword_ui.Show()
end

function this.OnServiceClick()
    waiting_ui.Show()
	SingleWeb.Instance:Init("http://b.feiyubk.com/gamewap/qqhenan/view/fuwutiaokuan.html")
    SingleWeb.Instance.Complete=function ()waiting_ui.Hide() end 
end
function this.OnBtnPrivacyOnClick()
    waiting_ui.Show()
	SingleWeb.Instance:Init("http://b.feiyubk.com/gamewap/qqhenan/view/yinsizhengce.html")
    SingleWeb.Instance.Complete=function ()waiting_ui.Hide() end
end

function this.OnBtnGameLicense()
    waiting_ui.Show()
	SingleWeb.Instance:Init("http://b.feiyubk.com/gamewap/qqhenan/view/xukexieyi.html")
    SingleWeb.Instance.Complete=function ()
	    waiting_ui.Hide()
	    active.Show() 
	end
end

function this.OnBtnChessLicense()
    waiting_ui.Show()
	SingleWeb.Instance:Init("http://b.feiyubk.com/gamewap/qqhenan/view/yonghuxieyi.html")
    SingleWeb.Instance.Complete=function ()waiting_ui.Hide() end
end



function this.OnCheckStatusChange()
	local checkStatue = UIToggle.current.value;
	if checkStatue == true then
		
		login_sys.isAgreeContract = true;
		log("------------------------togglechgeistrue"..tostring(login_sys.isAgreeContract))		

		else
			login_sys.isAgreeContract = false;
			log("------------------------togglechgeisFlase"..tostring(login_sys.isAgreeContract))
		end
     ui_sound_mgr.PlaySoundClip("common/audio_button_click")

end

function this.OnBtnYouKeClick()
	login_sys.OnPhoneLoginOK(nil, nil, this.account.value, this.password.value)
end

function this.OnBtnQQClick()
	if login_sys.isClicked == true then
		log("is clicked,hold on!")
		return
	else
		login_sys.isClicked = true
	end
	--测试用，直接登录
	log("-------------------------------------OnBtnQQClick")
 
	login_sys.QQLogin() 
    
    ui_sound_mgr.PlaySoundClip("common/audio_button_click")
end

function this.OnBtnWeiXinClick()
	-- if login_sys.isClicked == true then
	-- 	log("is clicked,hold on!")
	-- 	return
	-- else
	-- 	login_sys.isClicked = true
	-- end
	-- --测试用，直接登录
	-- log("-------------------------------------OnBtnWeiXinClick")
	-- login_sys.WeiXinLogin()
 --    ui_sound_mgr.PlaySoundClip("common/audio_button_click")
 --界面处理 （To do）
	if login_sys.isClicked == true then
		log("is clicked,hold on!")
		return
	else
		--login_sys.isClicked = true
	end
	--测试用，直接登录
	log("-------------------------------------OnBtnYouKeClick")
	if tostring(Application.platform) ==  "WindowsEditor"   then
		log(this.account.value)
		if this.account.value == nil or this.account.value == "" then
			login_sys.OnPlatLoginOK(nil, nil, nil)
		else
			login_sys.OnPlatLoginOK(nil, nil, this.account.value)
		end
	elseif  tostring(Application.platform) == "Android" or  tostring(Application.platform) == "IPhonePlayer" then
		if App.versionType == Version.Release then
			login_sys.WeiXinLogin()
		elseif this.account.value == nil or this.account.value == "" then
			log("微信登录")
			login_sys.WeiXinLogin()
		else
			login_sys.OnPlatLoginOK(nil, nil, this.account.value)
		end
		--login_sys.OnPlatLoginOK(nil, nil, this.account.value)
	end
    ui_sound_mgr.PlaySoundClip("common/audio_button_click")
end

--[[--
 * @Description: 单机  
 ]]
function this.OnClickButtonSingle()
	if (this.gameObject ~= nil) then
		destroy(this.gameObject)
		this.gameObject = nil
	end

	TestMode.SetSingleMode(true)
	login_sys.OnPlatLoginOK()
    ui_sound_mgr.PlaySoundClip("common/audio_button_click")
end


