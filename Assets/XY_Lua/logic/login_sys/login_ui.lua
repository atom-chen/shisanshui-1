--[[--
 * @Description: 登陆界面
 * @Author:      shine
 * @FileName:    login_ui.lua
 * @DateTime:    2017-05-18 15:06:02
 ]]

require "common/TestMode"
require "logic/login_sys/login_sys" 

login_ui = ui_base.New()

local this = login_ui
local transform
local gameObject
local accLoginInfo
local toggle

local logoCoroutine = nil

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
 	print("login_ui Awake")
	local s= YX_APIManage.Instance:read("temp.txt")
	if s~=nil then
      print("login_ui temp.txt str-----" .. s);
      local t=ParseJsonStr(s)
      if t.uid then
      	login_sys.share_uid = t.uid
      end
   	end
    -- local animations=child(this.transform,"tex_bg") 
    -- if animations~=nil then
    --     print()
    --     componentGet(animations.gameObject,"SkeletonAnimation"):ChangeQueue(2999)
    -- end
 end

function this.Start()
	this.RegisterEvents()
	this:RegistUSRelation()
	login_sys.isAgreeContract = true
	
	--this.InitSettingUI()
	login_sys.InitPlugins(true)	
	login_sys.AutoLogin()	

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
	
    --subComponentGet(this.transform, "btn_grid", typeof(UIGrid)):Reposition()

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
    SingleWeb.Instance.Complete=function ()waiting_ui.Hide()active.Show() end
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
		print("------------------------togglechgeistrue"..tostring(login_sys.isAgreeContract))		

		else
			login_sys.isAgreeContract = false;
			print("------------------------togglechgeisFlase"..tostring(login_sys.isAgreeContract))
		end
     ui_sound_mgr.PlaySoundClip("common/audio_button_click")

end

function this.OnBtnYouKeClick()
	--界面处理 （To do）
	if login_sys.isClicked == true then
		print("is clicked,hold on!")
		return
	else
		--login_sys.isClicked = true
	end
	login_sys.OnPlatLoginOK()
	--测试用，直接登录
	-- print("-------------------------------------OnBtnYouKeClick")
	-- if tostring(Application.platform) ==  "WindowsEditor"   then
	-- 	login_sys.OnPlatLoginOK()
	-- elseif  tostring(Application.platform) == "Android" or  tostring(Application.platform) == "IPhonePlayer" then
	-- 	login_sys.WeiXinLogin()
	-- end
 --    ui_sound_mgr.PlaySoundClip("common/audio_button_click")
end

function this.OnBtnQQClick()
	if login_sys.isClicked == true then
		print("is clicked,hold on!")
		return
	else
		login_sys.isClicked = true
	end
	--测试用，直接登录
	print("-------------------------------------OnBtnQQClick")
 
	login_sys.QQLogin() 
    
    ui_sound_mgr.PlaySoundClip("common/audio_button_click")
end

function this.OnBtnWeiXinClick()
	-- if login_sys.isClicked == true then
	-- 	print("is clicked,hold on!")
	-- 	return
	-- else
	-- 	login_sys.isClicked = true
	-- end
	-- --测试用，直接登录
	-- print("-------------------------------------OnBtnWeiXinClick")
	-- login_sys.WeiXinLogin()
 --    ui_sound_mgr.PlaySoundClip("common/audio_button_click")
 --界面处理 （To do）
	if login_sys.isClicked == true then
		print("is clicked,hold on!")
		return
	else
		--login_sys.isClicked = true
	end
	--测试用，直接登录
	print("-------------------------------------OnBtnYouKeClick")
	if tostring(Application.platform) ==  "WindowsEditor"   then
		login_sys.OnPlatLoginOK(nil, nil, "00000000000000000000000000000000000000000")
	elseif  tostring(Application.platform) == "Android" or  tostring(Application.platform) == "IPhonePlayer" then
		login_sys.WeiXinLogin()
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


