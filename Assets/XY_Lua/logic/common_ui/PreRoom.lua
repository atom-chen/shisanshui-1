PreRoom = ui_base.New() 
local this = PreRoom  

print("老大哥苏震西藏城木苏震要")
function PreRoom.Show(msg)
    log("this.Show(msg)")
    if this.gameObject == nil then
        local obj = newNormalUI("Prefabs/UI/club_ui/PreRoom")
        this.gameObject = obj
        if obj ~= nil then
    		this.Init(msg)
    	end 
    	return obj
    end
end


function this.Close()
	if this.gameObject~=nil then
        log("nil------------------")
        GameObject.Destroy(this.gameObject)
        this.gameObject=nil
    end
end 

function this.Init(msg) 
    this.cid = ClubModel.currentClubInfo.cid
	--content
    this.closebtn=child(this.transform,"bg/sv_gold/btn_close");
    if this.closebtn~=nil then
        addClickCallbackSelf(this.closebtn.gameObject,this.Close,this)
    end

    local lb_content_gt = child(this.transform, "bg/sv_gold/lab_content")
    this.lb_content_g=componentGet(lb_content_gt.gameObject,"UILabel") 
    this.lb_content_g.text=msg.content  

    local btnCreate=child(this.transform,"bg/btnCreate") 
    addClickCallbackSelf(btnCreate.gameObject,this.OnCreate,this)
    local btnDetail=child(this.transform,"bg/btnDetail") 
    addClickCallbackSelf(btnDetail.gameObject,this.OnDetail,this)
end

function this.OnCreate()
    tables = {}
    tables.gid = 11
    tables.ishide = false
    tables.autocreate = false
    -- 临时处理，中途加入
    tables.bMidJoin = 1



    room_data.GetSssRoomDataInfo().people_num = tonumber(PlayerPrefs.GetString("pnum", "6"))
    tables.pnum = room_data.GetSssRoomDataInfo().people_num
    room_data.GetSssRoomDataInfo().play_num = tonumber(PlayerPrefs.GetString("rounds", "10"))
    tables.rounds = room_data.GetSssRoomDataInfo().play_num
    room_data.GetSssRoomDataInfo().nChooseCardTypeTimeOut = tonumber(PlayerPrefs.GetString("nChooseCardTypeTimeOut", "30"))
    tables.nChooseCardTypeTimeOut = room_data.GetSssRoomDataInfo().nChooseCardTypeTimeOut
    room_data.GetSssRoomDataInfo().nReadyTimeOut = tonumber(PlayerPrefs.GetString("nReadyTimeOut", "5"))
    tables.nReadyTimeOut = room_data.GetSssRoomDataInfo().nReadyTimeOut
    room_data.GetSssRoomDataInfo().add_ghost = tonumber(PlayerPrefs.GetString("joker", "0"))
    tables.joker = room_data.GetSssRoomDataInfo().add_ghost
    room_data.GetSssRoomDataInfo().costtype = tonumber(PlayerPrefs.GetString("costtype", "1"))
    tables.costtype = room_data.GetSssRoomDataInfo().costtype
    room_data.GetSssRoomDataInfo().nBuyCode = tonumber(PlayerPrefs.GetString("buyhorse", "0"))
    tables.buyhorse = room_data.GetSssRoomDataInfo().nBuyCode
    --tables.rounds = 10
    tables.maxfan = 1
    --tables.buyhorse = false
    --tables.addColor = 0
    --tables.joker = 0
    tables.leadership = false
    --tables.pnum = 2
    --tables.costtype = 1
    --tables.nReadyTimeOut = 5
    --tables.nChooseCardTypeTimeOut = 60      
    tables.cid = this.cid
    join_room_ctrl.CreateClubRoom(tables)

    this.Close()
end
 
 function this.OnDetail()
    ui_sound_mgr.PlaySoundClip("common/audio_button_click")
    if openroom_main_ui ~= nil then 
        --open_room_data.RequesetClientConfig()
        openroom_main_ui.Show(1)
    end
    this.Close()
end