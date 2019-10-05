PreRoom = ui_base.New() 
local this = PreRoom  

print("老大哥苏震西藏城木苏震要")
function PreRoom.Show(content)
    log("this.Show(content)")
    if this.gameObject == nil then
        local obj = newNormalUI("Prefabs/UI/club_ui/PreRoom")
        this.gameObject = obj
        if obj ~= nil then
    		this.Init(content)
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

function this.Init(content) 
	--content
    this.closebtn=child(this.transform,"bg/sv_gold/btn_close");
    if this.closebtn~=nil then
        addClickCallbackSelf(this.closebtn.gameObject,this.Close,this)
    end

    local lb_content_gt = child(this.transform, "bg/sv_gold/lab_content")
    this.lb_content_g=componentGet(lb_content_gt.gameObject,"UILabel") 
    this.lb_content_g.text=content  

    local btnCreate=child(this.transform,"bg/btnCreate") 
    addClickCallbackSelf(btnCreate.gameObject,this.OnCreate,this)
    local btnDetail=child(this.transform,"bg/btnDetail") 
    addClickCallbackSelf(btnDetail.gameObject,this.OnDetail,this)
end

function this.OnCreate()
    
end
 
 function this.OnDetail()
    ui_sound_mgr.PlaySoundClip("common/audio_button_click")
    if openroom_main_ui ~= nil then 
        --open_room_data.RequesetClientConfig()
        openroom_main_ui.Show(1)
    end
    this.Close()
end