--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

require "logic/common/global_define"
require "logic/hall_sys/openroom/fuzhoumj_room_ui"
require "logic/shisangshui_sys/card_data_manage"
 
join_room_ui = ui_base.New()
local this = join_room_ui 

local i=0
this.roomnumber={}

function this.Show()
	if this.gameObject==nil then
		require ("logic/hall_sys/join_room/join_room_ui")
		this.gameObject=newNormalUI("Prefabs/UI/OpenRoom/join_room")
	else  
        this.gameObject:SetActive(true)
	end 
    this.addlistener()
end

function this.Start() 
    this:RegistUSRelation()
end

function this.OnDestroy()
    this:UnRegistUSRelation()
end
function this.addlistener()
    local btn_close=child(this.transform,"join_panel/btn_close")
    if btn_close~=nil then
        addClickCallbackSelf(btn_close.gameObject,this.Hide,this)
    end

   local btn_join = child(this.transform, "btn_join")--房间1
   if btn_join~=nil then 
     addClickCallbackSelf(btn_join.gameObject, this.joinroom, this)
   end

   local btn_open = child(this.transform, "btn_open")--房间2
   if btn_open~=nil then
     addClickCallbackSelf(btn_open.gameObject, this.OpenRoomClick, this)
   end

    local rnoInput = subComponentGet(this.transform, "join_panel/Panel_Middle/gird_number/rnoInput", typeof(UIInput))
    if rnoInput~=nil then
        EventDelegate.Add(rnoInput.onChange, EventDelegate.Callback(function() 
            local len = string.len(rnoInput.value)
            if len > 6 then
                message_box.ShowGoldBox("请输入6位数字的房间号", nil, 2, {function ()
                            message_box:Close()
                        end, function ()
                            message_box:Close()
                        end}, {"fonts_02", "fonts_01"}
                        )
                rnoInput.value = ""
                return
            end
            if tonumber(rnoInput.value) then
                if len == 6 then
                    this.rno = tonumber(rnoInput.value)
                end
                this.setnumberInput(rnoInput.value, len)
            else
                message_box.ShowGoldBox("请输入6位数字的房间号", nil, 2, {function ()
                            message_box:Close()
                        end, function ()
                            message_box:Close()
                        end}, {"fonts_02", "fonts_01"}
                        )
            end
            --callback(self) 
        end))
    end

    this.grid_number=child(this.transform,"join_panel/Panel_Middle/gird_number")

    local btn_grid=child(this.transform,"join_panel/Panel_Middle/grid_input")
    
    for k=0,btn_grid.transform.childCount-1,1 do
        local btn_n=btn_grid.transform:GetChild(k)
        addClickCallbackSelf(btn_n.gameObject,this.setnumber,this)
    end
end

function this.setnumberInput(rno, len)
    for i = 0, len - 1 do
        local num = math.floor((rno % 10 ^ (i + 1))  /  (10 ^ (i )) )
        local sp_current=this.grid_number.transform:GetChild(len -1 - i)
        local sp_number=child(sp_current.transform,"Sprite")
        sp_number.gameObject:SetActive(true)
        componentGet(sp_number,"UILabel").text= tostring(num)
    end
end

function this.joinroom()
  ui_sound_mgr.PlaySoundClip("common/audio_button_click")
  this.RequestGetInRoom(this.rno)
  --join_room_ui.Show()
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

function this.RequestGetInRoom(rno)
    -- local rno=""
    -- for i,v in ipairs(t) do
    --     rno=rno..v
    -- end
    this.Hide()
    join_room_ctrl.JoinRoomByRno(rno)
end


function  this.Hide()
    ui_sound_mgr.PlaySoundClip("common/audio_button_click")
    if not IsNil(this.gameObject) then  
        i=0
		GameObject.Destroy(this.gameObject)
        this.gameObject=nil
	end
end
