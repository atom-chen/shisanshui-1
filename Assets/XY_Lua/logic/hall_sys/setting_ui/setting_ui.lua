--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion

setting_ui =ui_base.New()
local this = setting_ui

function this.Show()
	if IsNil(this.gameObject) then
		require ("logic/hall_sys/user_ui")
		this.gameObject=newNormalUI("Prefabs/UI/Setting/Setting")
	else
		this.gameObject:SetActive(true)
	end 
    hall_data.Init()
end

function this.Start()
    this.UpdataInfo()
    this:RegistUSRelation()
end

function this.OnDestroy()
    this:UnRegistUSRelation()
end

function this.UpdataInfo()
    --this.lab_name=child(this.transform,"setting_panel/panel_middle/tex_photo/lab_name") 
    --componentGet(this.lab_name.gameObject,"UILabel").text=data_center.GetLoginRetInfo().nickname

    --this.tex_photo=child(this.transform,"setting_panel/panel_middle/tex_photo")
    --hall_data.getuserimage(componentGet(this.tex_photo,"UITexture")) 

    this.toggle_music=child(this.transform,"setting_panel/panel_middle/toggle/toggle_music")
    if this.toggle_music~=nil then
        local volume = hall_data.GetPlayerPrefs("music")
        local slider = componentGet(this.toggle_music,"UISlider")
        slider.onDragFinished = function()
                this.musicclick(slider)
            end
        slider.value=tonumber(volume * 2)
    end

    this.toggle_musiceffect=child(this.transform,"setting_panel/panel_middle/toggle/toggle_musiceffect")
    if this.toggle_musiceffect~=nil then
        local volume = hall_data.GetPlayerPrefs("musiceffect")
        local slider = componentGet(this.toggle_musiceffect,"UISlider")
        slider.onDragFinished = function()
                this.musiceffectclick(slider)
            end
        slider.value=tonumber(volume * 2)
    end

    this.btn_change=child(this.transform,"setting_panel/panel_middle/toggle/btn_change")
    if game_scene.getCurSceneType() == scene_type.HENANMAHJONG or 
        game_scene.getCurSceneType() == scene_type.FUJIANSHISANGSHUI then
        local bgSP = subComponentGet(this.btn_change, "Background", "UISprite")
        if bgSP ~= nil then
            bgSP.spriteName = "zhanghaogenghuan01"
        end
    else
        if this.btn_change~=nil then
            local bgSP = subComponentGet(this.btn_change, "Background")
            if bgSP ~= nil then
                bgSP.spriteName = "zhanghaogenghuan01"
            end            
            addClickCallbackSelf(this.btn_change.gameObject, this.changeclick, this)
        end
    end

    this.btn_grid=child(this.transform,"setting_panel/panel_middle/toggle/list/Panel/Sprite/gird_table")

    local btn_close=child(this.transform,"setting_panel/btn_close")
    if btn_close~=nil then
        addClickCallbackSelf(btn_close.gameObject,this.Hide,this)
    end

    local tex_photo=child(this.transform,"setting_panel/panel(middle/tex_photo")
    if tex_photo~=nil then
        local tx=componentGet(tex_photo,"UITexture")
        hall_data.getuserimage(tx)
    end

    local gri_table=child(this.transform,"setting_panel/panel_middle/toggle/list/sv_zhuobu/gird_table")
    local deskBgNum = tonumber(hall_data.GetPlayerPrefs("desk"))
    for i=1,gri_table.transform.childCount do
        local btn_z=gri_table.transform:GetChild(i-1)
        if btn_z~=nil then
            if i == deskBgNum then
                componentGet(btn_z,"UIToggle").value = true
            else
                componentGet(btn_z,"UIToggle").value = false
            end
            addClickCallbackSelf(btn_z.gameObject,this.changedesk,this)
        end
    end

    local btn_mzsm=child(this.transform,"setting_panel/panel_middle/toggle/btn_mzsm")
    if btn_mzsm~=nil then
        addClickCallbackSelf(btn_mzsm.gameObject,this.OpenMZSM,this)
    end
    local btn_fwtk=child(this.transform,"setting_panel/panel_middle/toggle/btn_fwtk")
    if btn_fwtk~=nil then
        addClickCallbackSelf(btn_fwtk.gameObject,this.OpenFWTK,this)
    end
    local btn_yszc=child(this.transform,"setting_panel/panel_middle/toggle/btn_yszc")
    if btn_yszc~=nil then
        addClickCallbackSelf(btn_yszc.gameObject,this.OpenYSZC,this)
    end
    this.Init() 
end

function this.Init()
    -- this.musicclick(this.gameObject,this.toggle_music)
    -- this.musiceffectclick(this.gameObject,this.toggle_musiceffect)
    -- this.shakeclick(this.gameObject,this.toggle_shake) 
end

function this.OpenMZSM()
    log(global_define.httpmzsm)
    SingleWeb.Instance:Init(global_define.httpmzsm)
    local top,bottom,w=this.CalSize()
    log(top.."top"..bottom.."bottom"..w)
    SingleWeb.Instance:setsize(top,bottom,w,w)
    SingleWeb.Instance:Show()
    require"logic/WebViewBg/webViewBG_ui"
    webViewBG_ui:Show()
    webViewBG_ui.UpdateTitle("mzsm")
end
function this.OpenFWTK()
    log(global_define.httpfwtk)
    SingleWeb.Instance:Init(global_define.httpfwtk)
    local top,bottom,w=this.CalSize()
    SingleWeb.Instance:setsize(top,bottom,w,w)
    SingleWeb.Instance:Show()
    require"logic/WebViewBg/webViewBG_ui"
    webViewBG_ui:Show()
    webViewBG_ui.UpdateTitle("fwtk")
end

function this.OpenYSZC()
    log(global_define.httpyszc)
    SingleWeb.Instance:Init(global_define.httpyszc)
    local top,bottom,w=this.CalSize()
    SingleWeb.Instance:setsize(top,bottom,w,w)
    SingleWeb.Instance:Show()
    require"logic/WebViewBg/webViewBG_ui"
    webViewBG_ui:Show()
    webViewBG_ui.UpdateTitle("yszc")
end

function this.disableuserbtn()
    this.btn_change=child(this.transform,"setting_panel/panel_middle/toggle/btn_change")
    componentGet(this.btn_change.gameObject,"UIButton").isEnabled=false
end

function this.changedesk(obj1,obj2) 
    local s=string.split(obj2.name,"_")
    hall_data.SetPlayerPrefs("desk",s[2])
    Notifier.dispatchCmd(cmdName.MSG_CHANGE_DESK, tonumber(s[2]))
end

function this.musicclick(obj)
    local value=componentGet(obj.gameObject,"UISlider").value
    ui_sound_mgr.controlValue(value / 2) 
    hall_data.SetPlayerPrefs("music",value / 2)
end

function this.musiceffectclick(obj)
    local value=componentGet(obj.gameObject,"UISlider").value
    ui_sound_mgr.ControlCommonAudioValue(value / 2) 
    hall_data.SetPlayerPrefs("musiceffect",value / 2)
end

function  this.Hide()
    if not IsNil(this.gameObject) then 
      destroy(this.gameObject)
      this.gameObject=nil
  end
end

function this.CalSize()
    local screenRe=Screen.currentResolution
    --原设的屏幕分辨率
    local height=720
    local width=1280
    --获取当前实际屏幕分辨率和原设屏幕分辨率的宽、高之比
    local ScaleH=tonumber(tonumber(screenRe.height)/tonumber(height))
    local ScaleW=tonumber(tonumber(screenRe.width)/tonumber(width))
    --设置前端网页的左右边距
    local w=tonumber(tonumber(ScaleW)*tonumber(290))
    --设置前端网页的上边距
    local top=tonumber(tonumber(ScaleH)*tonumber(145))
    --设置前端网页的下边距
    local bottom=tonumber(tonumber(ScaleH)*tonumber(85))
    return top,bottom,w
end