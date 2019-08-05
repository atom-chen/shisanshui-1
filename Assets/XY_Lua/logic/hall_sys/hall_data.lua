--[[--
 * @Description: 大厅数据层
 * @Author:      shine
 * @FileName:    hall_data.lua
 * @DateTime:    2017-05-19 14:33:40
 ]]

hall_data = {}
local this = hall_data

--大厅存储的数据
this.roomdata={}
 
this.userimage=nil

local chooseRoomClick = false
this.playerprefs={
    music=1,
    musiceffect=1,
    desk=1,
    shake=1,
    check=1,
    gps=1,
}

--[[--
 * @Description: 数据初始化  
 ]]
function this.Init() 
    if tonumber(this.GetPlayerPrefs("FristLogin"))~=1 then
        for k ,v in pairs(this.playerprefs)do
            this.SetPlayerPrefs(k,v)  
            print(k.."k"..v.."v")
        end
        this.SetPlayerPrefs("FristLogin",1)  
    end  
   for k ,v in pairs(this.playerprefs)do
       this.playerprefs[k]=this.GetPlayerPrefs(k)  
   end   
   if tonumber(this.playerprefs.music)==1 then
       ui_sound_mgr.controlValue(0.5) 
   else
       ui_sound_mgr.controlValue(0)
   end
   if tonumber(this.playerprefs.musiceffect)==1 then
       ui_sound_mgr.ControlCommonAudioValue(0.5) 
   else
       ui_sound_mgr.ControlCommonAudioValue(0) 
   end 
end

function this.register()
    print(" Notifier.regist(cmdName.MSG_ROOMCARD_REFRESH,this.UpdateInfo)")
    Notifier.regist(cmdName.MSG_ROOMCARD_REFRESH,this.UpdateInfo)
end

function this.UpdateInfo(roomcard)
    data_center.GetLoginRetInfo().card=roomcard 
    if not IsNil(hall_ui.gameObject) then 
        hall_ui.InitInfo()
    end
    print("Updatacoin-----------------------------------") 
end
local times=0
this.animationtable={}
 function this.staranimation()
    times=times+1
    --print("times"..times)
    if times==10 then
        for i=1,table.getCount(this.animationtable) do
            local an=componentGet(this.animationtable[i].gameObject,"SkeletonAnimation") 
            an.AnimationName=this.animationtable[i].gameObject.name
            an.playComPleteCallBack=function()
                an.AnimationName="" 
                --print("````````````````0000000000")  
            end
        end
        times=0
    end
 end
 
function this.getuserimage(tx,itype,iurl)
    itype=itype or data_center.GetLoginRetInfo().imagetype
    iurl=iurl or data_center.GetLoginRetInfo().imageurl
    local imagetype=itype
    local imageurl=iurl
    if  tonumber(imagetype)~=2 then
        imageurl=global_define.defineimg
    end
    http_request_interface.getimage(imageurl,tx.width,tx.height,function (states,tex)tx.mainTexture=tex end)
end

function this.SetPlayerPrefs(key,v)
    PlayerPrefs.SetString(key,v)
end
function this.GetPlayerPrefs(key)
    return PlayerPrefs.GetString(key)
end

function this.SetChooseRoomClick(isClick)
    chooseRoomClick = isClick
end

function this.CheckIsChooseRoomClick()
    return chooseRoomClick
end
 

--[[


 
]]--