--[[--
 * @Description: 大厅ui组件
 * @Author:      shine
 * @FileName:    hall_ui.lua
 * @DateTime:    2017-05-19 14:33:25
 ]]
 
 require "logic/hall_sys/hall_data"
 require "logic/hall_sys/hall_ui_ctrl"  
 require "logic/network/http_request_interface"
 require "logic/hall_sys/user_ui"  
 require "logic/hall_sys/shop/shop_ui"  
 require "logic/hall_sys/certification_ui"
 require "logic/network/majong_request_protocol" 
 require "logic/hall_sys/openroom/openroom_main_ui"
 require "logic/hall_sys/setting_ui/setting_ui"
 require "logic/hall_sys/record_ui/record_ui"
 require "logic/hall_sys/announcement_ui/announcement_ui"
 require "logic/hall_sys/join_room/join_room_ui"
 require "logic/hall_sys/record_ui/recorddetails_ui"
 require "logic/hall_sys/share/share_ui"
 require"logic/hall_sys/service_ui"
 require"logic/hall_sys/help_ui"
 require"logic/hall_sys/activity/activity_ui"
 require "logic/common/join_room_ctrl"
 require"logic/hall_sys/record_ui/openrecord_ui"
 require"logic/club_sys/Window/ClubUI"


 hall_ui = ui_base.New()
 local this = hall_ui 
 local transform

 this.IsStartGame=true
 local arrowTimer

 function this.Awake() 
  log("hall_ui Awake")  
  this.registerevent()  
  this.InitInfo()
  this.checkInviteroom()
  this.InitSettingUI()
  hall_data.register()
  hall_data.Init() 
  this.LoadWebPage()
end

function this.checkInviteroom()
     local s= YX_APIManage.Instance:read("temp.txt")
  if s~=nil then
    log(s)
    log("hall_ui temp.txt str-----" .. s)
    local t=ParseJsonStr(s)
    if t.roomId then
      log("hall_ui temp.txt t.roomId-----" .. t.roomId)
      waiting_ui.Show()
      http_request_interface.getRoomByRno(tonumber(t.roomId),join_room_ui.OnGetINRoomReturnData)
    end
    -- delete file
    YX_APIManage.Instance:deleteFile("temp.txt")
  end
end

function this.InitSettingUI()
  ui_sound_mgr.SceneLoadFinish() 
  ui_sound_mgr.PlayBgSound("hall_bgm")
  local volume = tonumber(hall_data.GetPlayerPrefs("music"))
  if volume == nil then
    volume = 0.5
  end
  ui_sound_mgr.controlValue(volume)
  volume = tonumber(hall_data.GetPlayerPrefs("musiceffect"))
  if volume == nil then
    volume = 0.5
  end
  ui_sound_mgr.ControlCommonAudioValue(volume)
end
--[[--
 * @Description: 逻辑入口  
 ]]
 function this.Start()   
	--this:RegistUSRelation()
  if this.IsStartGame then 
    this.IsStartGame=false
  end  
end 

--[[--
 * @Description: 销毁  
 ]]
 function this.OnDestroy()
	--this:UnRegistUSRelation()
  hall_ui_ctrl.UInit()
  require"logic/common/global_define"
  local url=global_define.GetUrlData()
  local temp=SingleWeb.Instance:DestroyDicObj(url)
  if arrowTimer ~= nil then
    arrowTimer:Stop()
    arrowTimer = nil
  end
end

--注册事件
function this.registerevent() 
  this.ui_Top()
  this.ui_Middle()
  this.ui_Bottom() 
end


--Panel_Top
function this.ui_Top()        
   this.btn_photo = child(this.transform, "Panel_TopLeft/btn_photo");--个人信息,单独列出来需要隐藏
   if this.btn_photo~=nil then
     addClickCallbackSelf(this.btn_photo.gameObject,this.Onbtn_goldClick,this)
   end
   local btn_s=child(this.btn_photo.transform,"sp_fkBackground/btn_shop")
   if btn_s~=nil then
     addClickCallbackSelf(btn_s.gameObject,this.shop,this)
   end

   local btn_sort = child(this.transform, "Panel_TopRight/Grid_TopRight/btn_mail")--邮件
   if btn_sort~=nil then
     addClickCallbackSelf(btn_sort.gameObject,this.announcement,this)
   end

   local btn_share = child(this.transform, "Panel_TopRight/Grid_TopRight/btn_share")--分享
   if btn_share~=nil then
     addClickCallbackSelf(btn_share.gameObject,this.share,this)
   end
   local btn_bindAgeng = child(this.transform, "Panel_TopLeft/btn_photo/btn_bindAgeng")--玩法
   if btn_bindAgeng~=nil then
     addClickCallbackSelf(btn_bindAgeng.gameObject,this.BindAgeng,this)
   end
   local btn_achievement = child(this.transform, "Panel_TopRight/Grid_TopRight/btn_achievement")--玩法
   if btn_bindAgeng~=nil then
     addClickCallbackSelf(btn_achievement.gameObject,this.OpenRecordUI,this)
   end
   local btn_setting = child(this.transform, "Panel_TopRight/Grid_TopRight/btn_setting")--设置
   if btn_setting~=nil then
     addClickCallbackSelf(btn_setting.gameObject,this.setting,this)
   end 

    local btn_copyWx = child(this.transform, "Panel_TopRight/Grid_TopRight/btn_copyWx")--设置
   if btn_copyWx~=nil then
     addClickCallbackSelf(btn_copyWx.gameObject,this.CopyKefu,this)
   end 

   local btn_club = child(this.transform, "Panel_Middle/btn_club")--
   if btn_club~=nil then
     addClickCallbackSelf(btn_club.gameObject,this.OpenClubUI,this)
   end 

    local btn_record=child(this.transform, "Panel_BottomRight/Grid_bottom/btn_zhanji")--战绩
    if btn_record~=nil then
     addClickCallbackSelf(btn_record.gameObject,this.OpenRecordUI,this)
   end
 end 

--Panel_Middle
function this.ui_Middle()

   local btn_join = child(this.transform, "Panel_Middle/btn_join")--房间1
   if btn_join~=nil then 
     addClickCallbackSelf(btn_join.gameObject, this.joinroom, this)
   end

   local btn_open = child(this.transform, "Panel_Middle/btn_open")--房间2
   if btn_open~=nil then
     addClickCallbackSelf(btn_open.gameObject, this.OpenRoomClick, this)
   end
   
  -- local animation4=child(btn_join.transform,"hudie_2") 
  -- if animation4~=nil then 
  --   local a=componentGet(animation4.gameObject,"SkeletonAnimation")
  --   a:ChangeQueue(3001)
  --   a.playComPleteCallBack=function()
  --   a.AnimationName="" 
  --           --log("````````````````0000000000")
  --         end
  --       end

  --       local animation3=child(btn_join.transform,"hudie_1") 
  --       if animation3~=nil then 
  --         local a=componentGet(animation3.gameObject,"SkeletonAnimation")
  --         a:ChangeQueue(3003)
  --         a.playComPleteCallBack=function()
  --         a.AnimationName="" 
  --           --log("````````````````0000000000")
  --         end
  --       end

  --       hall_data.animationtable ={animation3,animation4}

  --       arrowTimer = Timer
  --       arrowTimer = Timer.New(hall_data.staranimation, 1, -1)
  --       arrowTimer:Start() 


   this.toggle_record = child(this.transform, "Panel_Left/sp_left/toggle_record")--历史记录
   if this.toggle_record~=nil then
     addClickCallbackSelf(this.toggle_record.gameObject,this.record,this)
   end

   this.toggle_openrecord = child(this.transform, "Panel_Left/sp_left/toggle_openrecord")--开房记录
   if this.toggle_openrecord~=nil then
     addClickCallbackSelf(this.toggle_openrecord.gameObject,this.openrecord,this)
   end

    local switch_toggle=child(this.transform, "Panel_Left/sp_left/toggle_switch")--记录开关
    if switch_toggle~=nil then
     addClickCallbackSelf(switch_toggle.gameObject,this.freshrecord,this)
   end

   this.WrapContent_record = subComponentGet(this.transform, "Panel_Left/sp_left/sv_record/grid_record","UIWrapContent")
   if this.WrapContent_record ~= nil then
     this.WrapContent_record.onInitializeItem = record_ui.OnUpdateItem_record
   end

   this.WrapContent_openrecord = subComponentGet(this.transform, "Panel_Left/sp_left/sv_openrecord/grid_openrecord","UIWrapContent")
   if this.WrapContent_openrecord ~= nil then
     this.WrapContent_openrecord.onInitializeItem = record_ui.OnUpdateItem_openrecord
   end

   this.sp_record=child(this.transform, "Panel_Left/sp_left/sv_record/sp_record01")
   this.sp_openrecord=child(this.transform, "Panel_Left/sp_left/sv_openrecord/sp_record01")
 end

--Panel_Bottom
function this.ui_Bottom()
   local btn_shop = child(this.transform, "Panel_BottomRight/Grid_bottom/btn_shop")--商店
   if btn_shop~=nil then
     addClickCallbackSelf(btn_shop.gameObject,this.shop,this)
   end

   local btn_kefu = child(this.transform, "Panel_BottomRight/Grid_bottom/btn_customerservice")--客服
   if btn_kefu~=nil then
     addClickCallbackSelf(btn_kefu.gameObject,this.service,this)
   end

   local btn_huodong = child(this.transform, "Panel_BottomRight/Grid_bottom/btn_activity")--活动
   if btn_huodong~=nil then
     addClickCallbackSelf(btn_huodong.gameObject,this.activity,this)
   end
 end


--------------------------------------按钮相关逻辑-----------------------------------------
function hall_ui:OpenClubUI()
  --ClubUI:OnOpen()
   UI_Manager:Instance():ShowUiForms("ClubUI")
end

function this.Onbtn_goldClick()
  log("Onbtn_goldClick") 
   --- notice_ui.Show("wadawd46ad56wa4dadwadaaaaaadawdadadadawdawadadawdawdwdaww",5)
   ui_sound_mgr.PlaySoundClip("common/audio_button_click")
 end
 function this.share()
  -- if App.versionType == Version.Release then

  --     ui_sound_mgr.PlaySoundClip("common/audio_button_click")
  --     log("this.sharefriendQ")
  --     local shareType = 1--0微信好友，1朋友圈，2微信收藏
  --     local contentType = 5 --1文本，2图片，3声音，4视频，5网页
  --     local title = global_define.hallShareTitle
  --     local filePath = ""
  --     local subUrl = string.format(global_define.hallShareSubUrl,data_center.GetLoginRetInfo().uid)
  --     local url = data_center.shareUrl .. subUrl
  --     log("sharefriend----" .. url)

  --     local description = global_define.hallShareFriendQContent
  --     YX_APIManage.Instance:WeiXinShare(shareType,contentType,title,filePath,url,description)

  --     return
  -- end 
  share_ui.Show()
  ui_sound_mgr.PlaySoundClip("common/audio_button_click")
end
function this.BindAgeng()
  UIManager:ShowUiForms("ClubInputUI", nil, nil, ClubInputUIEnum.InputCode)
end
function this.activity(obj1,obj2)
  waiting_ui.Show()
  ui_sound_mgr.PlaySoundClip("common/audio_button_click")
  coroutine.start(function ()
    coroutine.wait(0.1)
    waiting_ui.Hide()
    activity_ui.Show() 
    coroutine.wait(0.3)
    require"logic/common/global_define"
    local url=global_define.GetUrlData()
    local webPage=SingleWeb.Instance:GetDicObj(url);
    local width=UnityEngine.Screen.width
    local height=UnityEngine.Screen.height
    local wrate=width/1280
    local hrate=height/720
    local left=wrate*135
    local right=wrate*130
    local top=hrate*110
    local bottom=hrate*40 
    webPage:SetSize(top,bottom,left,right)
    webPage:Show()
    end)
  --[[local t=http_request_interface.GetTable()
  local web= SingleWeb.Instance:Init(global_define.httpactivity.."?session_key="..t.session_key.."&siteid="..t.siteid.."&version="..t.version,"activity")
  local width=UnityEngine.Screen.width
  local height=UnityEngine.Screen.height
  local wrate=width/1280
  local hrate=height/720
  local left=wrate*135
  local right=wrate*130
  local top=hrate*110
  local bottom=hrate*40 
  SingleWeb.Instance:setsize(web,top,bottom,left,right)
  SingleWeb.Instance:AddOnCompeleteDelegete(web,function ()
    waiting_ui.Hide()
    activity_ui.Show() 
    SingleWeb.Instance:Show(web)
    child(obj2.transform,"sp_red").gameObject:SetActive(false)
    end)
  SingleWeb.Instance:AddOnReceiveDelegate(web,function(web,message)   
    if message.path=="move" then  
      SingleWeb.Instance:Hide(web) 
      activity_ui.Hide()
      openroom_main_ui.Show()
    end
    if message.path=="yaoqing" then  
      SingleWeb.Instance:Hide(web) 
      activity_ui.Hide()
      share_ui.Show()
    end
    end)--]]
  end

  function this.shop()
    waiting_ui.Show()
    ui_sound_mgr.PlaySoundClip("common/audio_button_click")
    http_request_interface.getProductCfg(0,function(code,m,str)
      log(str)
      local s=string.gsub(str,"\\/","/")  
      local t=ParseJsonStr(s) 
      shop_ui.productlist=t.productlist
      shop_ui.Show()
      waiting_ui.Hide()
      end)
  end

  function this.CopyKefu()
    log("复制客服微信号")
    fast_tip.Show("复制客服微信号成功")
    YX_APIManage.Instance:onCopy("sorrysz121",function()
        log("复制客服微信号成功")
        UI_Manager:Instance():FastTip("复制客服微信号成功")--LanguageMgr.GetWord(6043))
      end)
  end

  function this.service()
    ui_sound_mgr.PlaySoundClip("common/audio_button_click")
    service_ui.Show()
  end

  function this.help() 
    ui_sound_mgr.PlaySoundClip("common/audio_button_click")
    help_ui.Show() 
  end



  function this.OpenRoomClick() 
    ui_sound_mgr.PlaySoundClip("common/audio_button_click")
    log('-------------OpenRoomClick-------')
    if openroom_main_ui ~= nil then 
      --open_room_data.RequesetClientConfig()
      openroom_main_ui.Show()
    else
      log('-------------shisangshui_room_ui_ui = nil-------')
    end 
  end

  local recorddata={}
  local openrecorddata={}
  function this.freshrecord(obj1,obj2) 
   ui_sound_mgr.PlaySoundClip("common/audio_button_click")
   if componentGet(obj2.gameObject,"UIToggle").value==false then
    http_request_interface.getRoomSimpleByUid(nil, 2, 0, function (code, m, str)
      local s=string.gsub(str,"\\/","/")  
      local t=ParseJsonStr(s) 
      local sp_nocord=child(this.transform,"Panel_Left/sp_left/sp_norecord")
      componentGet(this.toggle_record,"UIToggle").value=true
      recorddata=t.data
      record_ui.Show()
      record_ui.UpdateRoomRecordSimpleData(t.data,1)
      log(str)
      if table.getCount(t.data)==0 then
       --sp_nocord.gameObject:SetActive(true)
       record_ui.SetNoRecord(false)
     else
       record_ui.SetNoRecord(true)
       --sp_nocord.gameObject:SetActive(false)
     end
     end)
    http_request_interface.getRoomSimpleList(nil,99,0,function (code,m,str)
      local s=string.gsub(str,"\\/","/")  
      local t=ParseJsonStr(s)
              --record_ui.UpdateRoomRecordSimpleData(t.data,2)
              openrecorddata=t.data
              log(str)
              local sp_nocord=child(this.transform,"Panel_Left/sp_left/sp_norecord") 
              end) 
  else
    recorddata={}
    openrecorddata={}
  end  
end

function this.OpenRecordUI() 

    --record_ui.Show()
    --if true then return end
    ui_sound_mgr.PlaySoundClip("common/audio_button_click")
    log("OpenRecordUI")
    http_request_interface.getRoomSimpleByUid(nil, 2, 0, function (code, m, str)
        local s=string.gsub(str,"\\/","/")  
        local t=ParseJsonStr(s) 
        local sp_nocord=child(this.transform,"Panel_Left/sp_left/sp_norecord")
        componentGet(this.toggle_record,"UIToggle").value=true
        recorddata=t.data
        record_ui.Show()
        record_ui.UpdateRoomRecordSimpleData(t.data,1)
        log(str)
        if table.getCount(t.data)==0 then
            --sp_nocord.gameObject:SetActive(true)
            record_ui.SetNoRecord(false)
        else
            --sp_nocord.gameObject:SetActive(false)
            record_ui.SetNoRecord(true)
        end
   end)
      --开房记录
    -- http_request_interface.getRoomSimpleList(nil,99,0,function (code,m,str)
    --       local s=string.gsub(str,"\\/","/")  
    --       local t=ParseJsonStr(s)
    --       --record_ui.UpdateRoomRecordSimpleData(t.data,2)
    --       openrecorddata=t.data
    --       log(str)
    --       local sp_nocord=child(this.transform,"Panel_Left/sp_left/sp_norecord") 
    --   end) 
end

function this.setting()
  ui_sound_mgr.PlaySoundClip("common/audio_button_click")
  setting_ui.Show() 
end
function this.record()
  ui_sound_mgr.PlaySoundClip("common/audio_button_click")  
  local sp_nocord=child(this.transform,"Panel_Left/sp_left/sp_norecord")
  if table.getCount(recorddata)==0 then
   sp_nocord.gameObject:SetActive(true)
 else
   sp_nocord.gameObject:SetActive(false)
 end 
 record_ui.UpdateRoomRecordSimpleData(recorddata,1)
end
function this.openrecord()
  ui_sound_mgr.PlaySoundClip("common/audio_button_click")  
  local sp_nocord=child(this.transform,"Panel_Left/sp_left/sp_norecord")
  if table.getCount(openrecorddata)==0 then
   sp_nocord.gameObject:SetActive(true)
 else
   sp_nocord.gameObject:SetActive(false)
 end 
 record_ui.UpdateRoomRecordSimpleData(openrecorddata,2)
end

function this.announcement(obj1,obj2)
  ui_sound_mgr.PlaySoundClip("common/audio_button_click") 
  local sp_red=child(obj2.transform,"sp_redpoint")
  http_request_interface.getEmails(0,function (code,m,str)
    log(str)
    local s=string.gsub(str,"\\/","/")  
    local t=ParseJsonStr(s)
    announcement_ui.Show()
    announcement_ui.UpdateEmailRecordSimpleData(t.data,1)
    sp_red.gameObject:SetActive(false)
    end)
end

function this.joinroom()
  ui_sound_mgr.PlaySoundClip("common/audio_button_click")
  join_room_ui.Show()
end

--------------------------------------更新用户信息-----------------------------------------
function this.InitInfo()
  local lab_name=child(this.transform,"Panel_TopLeft/btn_photo/sp_nameBackground/lab_name")
  if lab_name~=nil then
    componentGet(lab_name.gameObject,"UILabel").text=data_center.GetLoginRetInfo().nickname
  end
  App.uid = tonumber(data_center.GetLoginRetInfo().uid)
  local lab_id=child(this.transform,"Panel_TopLeft/btn_photo/sp_nameBackground/lab_id")
  if lab_id~=nil then
    componentGet(lab_id.gameObject,"UILabel").text="ID:"..data_center.GetLoginRetInfo().uid
  end
  local lab_card=child(this.transform,"Panel_TopLeft/btn_photo/sp_fkBackground/lab_id")
  if lab_card~=nil then
    this.fangka = componentGet(lab_card.gameObject,"UILabel")
    this.fangka.text=data_center.GetLoginRetInfo().card
  end
  local tx_photo=child(this.transform,"Panel_TopLeft/btn_photo/sp_photo/tex_photo")
  if lab_name~=nil then 
    hall_data.getuserimage(componentGet(tx_photo,"UITexture"))
  end

end

function this.UpdateFangka( num )
    this.fangka.text=data_center.GetLoginRetInfo().card
end

function  this.LoadWebPage()
  require"logic/common/global_define"
  local url=global_define.GetUrlData()
  if(url == nil) then
    log("url wei nil")

  else
    log("url bu wei nil")
  end
  SingleWeb.Instance:InitWebPage(url)
  local webPage=SingleWeb.Instance:GetDicObj(url)
  webPage.receive=function(webView, message)
  if message.path=="move" then  
      --SingleWeb.Instance:Hide(web) 
      local webPage=SingleWeb.Instance:GetDicObj(url)
      webPage:Hide()
      activity_ui.Hide()
      openroom_main_ui.Show()
    end
    if message.path=="yaoqing" then  
     local webPage=SingleWeb.Instance:GetDicObj(url)
     webPage:Hide()
     activity_ui.Hide()
     share_ui.Show()
   end
 end

  function this.UpdateAgent(msg)
      log("服务器返回邀请码")
      log(msg)
    local invicode = subComponentGet(this.transform, "Panel_TopRight/Grid_TopRight/inviteCode","UILabel")
    invicode.text = "邀请码："..msg.exid
    child(this.transform, "Panel_TopLeft/btn_photo/btn_bindAgeng").gameObject:SetActive(false)
  end
end