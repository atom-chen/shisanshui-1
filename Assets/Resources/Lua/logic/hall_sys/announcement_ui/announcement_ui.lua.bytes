--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion
announcement_ui =ui_base.New()
local this = announcement_ui
this.eid={}
this.currentindex=1 
this.page=0
function this.Show()
	if this.gameObject==nil then
		require ("logic/hall_sys/announcement_ui/announcement_ui")
		this.gameObject=newNormalUI("Prefabs/UI/Hall/announcement_ui")
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
    local btn_close=child(this.transform,"panel_announcement/btn_close")
    if btn_close~=nil then
        addClickCallbackSelf(btn_close.gameObject,this.Hide,this)
    end 
    this.WrapContent_record=componentGet(child(this.transform,"panel_announcement/Panel_Left/sv_email/toggle_grid"),"UIWrapContent")
    if this.WrapContent_record ~= nil then
   		this.WrapContent_record.onInitializeItem = this.OnUpdateItem_emailrecord
   	end
    this.item=child(this.WrapContent_record.transform.parent,"item")
    this.itemheight=componentGet(child(this.item.transform,"Background"),"UISprite").height   
    local btn_delete=child(this.transform,"panel_announcement/Panel_Right/btn_delete")
    if btn_delete~=nil then
        addClickCallbackSelf(btn_delete.gameObject,this.delete,this)
    end
end

function  this.Hide()
    ui_sound_mgr.PlaySoundClip("common/audio_button_click")
    if not IsNil(this.gameObject) then 
		GameObject.Destroy(this.gameObject)
        this.gameObject=nil
        this.emailrecord=nil
	end
end
this.emailrecord={}
function this.delete(obj1,obj2) 
    print(this.currentindex)
    if this.currentindex==nil or this.emailrecord[this.currentindex]==nil then
        return
    end    
    http_request_interface.delEmail(this.emailrecord[this.currentindex].eid,function(code,m,str)
        table.remove(this.emailrecord,this.currentindex)
        local lab_content=child(this.transform,"panel_announcement/Panel_Right/sp_background/lab_details") 
        componentGet(lab_content.gameObject,"UILabel").text=""
        for i=this.WrapContent_record.transform.childCount,1,-1 do
             GameObject.Destroy(this.WrapContent_record.transform:GetChild(i-1).gameObject) 
        end
        this.UpdateEmailRecordSimpleData(this.emailrecord,1)
        --this.WrapContent_record:WrapContent()
        currentindex=nil
    end)
    
end


function this.UpdateEmailRecordSimpleData(data,code)
	this.emailrecord =data  
	this.maxCount = table.getCount(this.emailrecord) 
	this.InitPanelRecord(this.maxCount,code)  
end



function this.InitPanelRecord(count,code) 
	if code==1 then  
		this.WrapContent_record.minIndex = -count+1
		this.WrapContent_record.maxIndex = 0 
        if this.WrapContent_record.transform.childCount >=8  then
		    return
	    end 
    end 
	print("InitPanelRecord") 
	if count >0 and count <=8 then
        for i=0, this.WrapContent_record.transform.childCount-1 do
			destroy(this.WrapContent_record.transform:GetChild(i).gameObject)
		end
		for i=0, count-1 do
			local go =this.InitItem(this.emailrecord[i+1],i,code)  
            this.OnUpdateItem_emailrecord(go.gameObject,nil,-i)
		end
	elseif count >8 then
		for a=0,7 do
			this.InitItem(this.emailrecord[a+1],a,code)
         	this.WrapContent_record.enabled = code==1 
		end 
	end
end

function this.InitItem(data,i,code) 
    print("create")
    local tmpItem
	if code ==1 then 
	          tmpItem = NGUITools.AddChild(this.WrapContent_record.gameObject,this.item.gameObject)
		      tmpItem.transform.localPosition = Vector3.New(0,-i*this.itemheight,0)
		      tmpItem.gameObject:SetActive(true) 
 	end 
    return tmpItem
end
 
function this.OnUpdateItem_emailrecord(go,index,realindex)
    print("update")
    local rindext=1-realindex   
    local redpoint=child(go.transform,"sp_red")
    redpoint.gameObject:SetActive(this.emailrecord[rindext].status==0) 
    if rindext~=this.currentindex then
        componentGet(go.gameObject,"UIToggle").value=false  
    else
        componentGet(go.gameObject,"UIToggle").value=true 
        local redpoint=child(go.transform,"sp_red")
        redpoint.gameObject:SetActive(false)
        local lab_content=child(this.transform,"panel_announcement/Panel_Right/sp_background/lab_details") 
        componentGet(lab_content.gameObject,"UILabel").text=this.emailrecord[rindext].content
    end 
    if go~=nil then
        local lab_name=child(go.transform,"lab_name")   
        componentGet(lab_name.gameObject,"UILabel").text=this.emailrecord[rindext].title 
        go.name=rindext  
        addClickCallbackSelf(go.gameObject,this.toggleclick,this) 
    end
    if rindext==this.maxCount and this.maxCount>=8 then  
        http_request_interface.getEmails(this.page+1,function (code,m,str) 
            local s=string.gsub(str,"\\/","/")  
            local t=ParseJsonStr(s) 
            if t.ret==0 then 
                local count=table.getCount(this.emailrecord)
                for i=1,table.getCount(t.data) do
                    this.emailrecord[i+count]=t.data[i]
                end
                this.UpdateEmailRecordSimpleData(this.emailrecord,1)
                this.page=this.page+1
           end
        end) 
    end
end
function this.toggleclick(obj1,obj2) 
    this.currentindex=tonumber(obj2.name)
    local lab_content=child(this.transform,"panel_announcement/Panel_Right/sp_background/lab_details") 
    componentGet(lab_content.gameObject,"UILabel").text=this.emailrecord[tonumber(obj2.name)].content
    local redpoint=child(obj2.transform,"sp_red") 
    redpoint.gameObject:SetActive(false)
    http_request_interface.readEmail(this.emailrecord[tonumber(obj2.name)].eid,function(code,m,str)print(str) end) 
    local isshow=true
    for i=0,obj2.transform.parent.childCount-1 do
        local redpoint=child(obj2.transform.parent:GetChild(i),"sp_red")
        if redpoint.gameObject.activeSelf then
            isshow=true
        else isshow=false
        end
    end
    local email= child(hall_ui.transform, "Panel_TopRight/Grid_TopRight/btn_mail")
    child(email.transform,"sp_redpoint").gameObject:SetActive(isshow)
end 