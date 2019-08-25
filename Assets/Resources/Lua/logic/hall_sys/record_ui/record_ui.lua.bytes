--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
 
--endregion

record_ui=ui_base.New()
local this=record_ui
this.roomstatus={
"已开房",
"已开局",
"已结算",
"未开局",
}
this.sp_room={
["已开房"]="weikaishi",
["已开局"]="jinxingzhong",
["已结算"]="jiesu",
["未开局"]="weikaishi"
}
this.gid={
[18]="福州麻将",
[22]="十三水"
} 

local WrapContent_record = nil
local WrapContent_openrecord = nil
local sp_record = nil
local sp_openrecord = nil

function this.Show()
    if IsNil(this.gameObject) then
        require ("logic/hall_sys/record_ui/record_ui")
        this.gameObject=newNormalUI("Prefabs/UI/Hall/record_ui")
    else
        this.gameObject:SetActive(true)
    end 

    WrapContent_record = subComponentGet(this.transform, "sp_left/sv_record/grid_record","UIWrapContent")
   if WrapContent_record ~= nil then
        WrapContent_record.onInitializeItem = record_ui.OnUpdateItem_record
   end

   WrapContent_openrecord = subComponentGet(this.transform, "sp_left/sv_openrecord/grid_openrecord","UIWrapContent")
   if WrapContent_openrecord ~= nil then
        WrapContent_openrecord.onInitializeItem = record_ui.OnUpdateItem_openrecord
   end

   sp_record=child(this.transform, "sp_left/sv_record/sp_record01")
   sp_openrecord=child(this.transform, "sp_left/sv_openrecord/sp_record01")
end

function this.UpdateRoomRecordSimpleData(data,code) 
    --code:1为历史记录，2 为开房记录  
    log("code:1为历史记录，2 为开房记录:"..code)
	this.open_roomRecordSimpleData =data  
	this.maxCount = table.getCount(this.open_roomRecordSimpleData)
    log(this.maxCount)
	this.InitPanelRecord(this.maxCount,code)  
end



function this.InitPanelRecord(count,code) 
	if code==1 then--历史记录
		WrapContent_record.minIndex = -count+1
		WrapContent_record.maxIndex = 0
        if WrapContent_record.transform.childCount >=4  then
		    return
	    end 
    end
    if code==2 then--开房记录
        WrapContent_openrecord.minIndex = -count+1
		WrapContent_openrecord.maxIndex = 0
        if WrapContent_openrecord.transform.childCount >=4  then
		    return
	    end 
    end
     
            
	log("InitPanelRecord")  
	if count >0 and count <=5 then
        if  code==1 then
            for i=0 ,WrapContent_record.transform.childCount-1 do
                destroy(WrapContent_record.transform:GetChild(i).gameObject)
            end
		    for i=0, count-1 do
			    local go= this.InitItem(this.open_roomRecordSimpleData[i+1],i,code)  
                this.OnUpdateItem_record(go,nil,-i)
		    end
        else
            for i=0 ,WrapContent_openrecord.transform.childCount-1 do
                destroy(WrapContent_openrecord.transform:GetChild(i).gameObject)
            end
		    for i=0, count-1 do
			    local go= this.InitItem(this.open_roomRecordSimpleData[i+1],i,code) 
                this.OnUpdateItem_openrecord(go,nil,-i)
		    end
        end 
	elseif count>5 then
		for a=0,4 do
			this.InitItem(this.open_roomRecordSimpleData[a+1],a,code)
            WrapContent_record.enabled = code==1  
            WrapContent_openrecord.enabled =code==2 
		end 
	end
end

function this.InitItem(data,i,code) 
    local tmpItem
	if code ==1 then
     	  tmpItem= NGUITools.AddChild(WrapContent_record.gameObject,sp_record.gameObject)
		  tmpItem.transform.localPosition = Vector3.New(0,-i*126,0)
		  tmpItem.gameObject:SetActive(true) 
          
	else
	      tmpItem = NGUITools.AddChild(WrapContent_openrecord.gameObject,sp_openrecord.gameObject)
		  tmpItem.transform.localPosition = Vector3.New(0,-i*126,0)
		  tmpItem.gameObject:SetActive(true) 
	end 
    return tmpItem
end


function this.OnUpdateItem_record(go,index,realindex)
    local rindext=1-realindex   
    if go~=nil then 
        go.name=rindext
        table.foreach(this.open_roomRecordSimpleData[rindext],print)
        local lab_date=child(go.transform, "lab_date")--日期
        local lab_type=child(go.transform, "lab_type")--类型
        local lab_reward=child(go.transform, "lab_reward")--盈利 
        addClickCallbackSelf(go.gameObject,this.opendetails,hall_ui)   
        if this.open_roomRecordSimpleData[rindext].gid~=nil then
           componentGet(lab_type,"UILabel").text="牌局类型:"..this.gid[tonumber(this.open_roomRecordSimpleData[rindext].gid)]
        end
        if this.open_roomRecordSimpleData[rindext].ts~=nil then
        componentGet(lab_date,"UILabel").text ="日期:".. os.date("%Y.%m.%d",this.open_roomRecordSimpleData[rindext].ts)
        end 

        local lab_bnumber=componentGet(child(go.transform,"lab_bnumber"),"UILabel")
        local lab_gnumber=componentGet(child(go.transform,"lab_gnumber"),"UILabel") 
        if  tonumber(this.open_roomRecordSimpleData[rindext].all_score) >=0  then
            lab_gnumber.gameObject:SetActive(true)
            lab_bnumber.gameObject:SetActive(false)  
            lab_gnumber.text="+"..this.open_roomRecordSimpleData[rindext].all_score
        else 
            lab_bnumber.gameObject:SetActive(true)
            lab_gnumber.gameObject:SetActive(false)
            lab_bnumber.text=this.open_roomRecordSimpleData[rindext].all_score
        end
    end 
    if rindext==this.maxCount and this.maxCount>5 then   
        http_request_interface.getRoomSimpleByUid(nil,2,this.recordpage,function (code,m,str)
            local s=string.gsub(str,"\\/","/")  
            local t=ParseJsonStr(s)
            log(str)
            local count=table.getCount(this.open_roomRecordSimpleData)
            for i=1,table.getCount(t.data) do
                this.open_roomRecordSimpleData[i+count]=t.data[i]
            end
            this.recordpage=this.recordpage+1
           this.UpdateRoomRecordSimpleData(this.open_roomRecordSimpleData,1)
        end) 
    end
end
 

function this.OnUpdateItem_openrecord(go,index,realindex)
    
    local rindext=1-realindex   
    if go~=nil then
        go.name=rindext
        local lab_date=child(go.transform, "lab_date")--日期
        local lab_type=child(go.transform, "lab_type")--类型
        local lab_status=child(go.transform, "lab_status")--状态  
        local sp_reward=child(go.transform,"sp_reward")
        componentGet(sp_reward,"UISprite").spriteName=this.sp_room[this.roomstatus[this.open_roomRecordSimpleData[rindext].status+1]]  
        componentGet(lab_status,"UILabel").text=this.roomstatus[this.open_roomRecordSimpleData[rindext].status+1]
        addClickCallbackSelf(go.gameObject,this.opendetails,hall_ui)
        componentGet(lab_type,"UILabel").text="房号:"..this.open_roomRecordSimpleData[rindext].rno
        componentGet(lab_date,"UILabel").text ="日期:".. os.date("%Y.%m.%d",this.open_roomRecordSimpleData[rindext].ctime)  
        
    end
    if rindext==this.maxCount and this.maxCount>5 then  
        http_request_interface.getRoomSimpleList(nil,99,this.openpage,function (code,m,str)
            local s=string.gsub(str,"\\/","/")  
            local t=ParseJsonStr(s)
            log(str)
            local count=table.getCount(this.open_roomRecordSimpleData)
            for i=1,table.getCount(t.data) do
                this.open_roomRecordSimpleData[i+count]=t.data[i]
            end
            this.openpage=this.openpage+1
           this.UpdateRoomRecordSimpleData(this.open_roomRecordSimpleData,2)
        end) 
    end
end
this.openpage=0
this.recordpage=0
function this.opendetails(obj1,obj2)
    ui_sound_mgr.PlaySoundClip("common/audio_button_click")
    local rid=this.open_roomRecordSimpleData[tonumber(obj2.name)].rid 
--    log(rid.."------------rid")
    if componentGet(hall_ui.toggle_openrecord.gameObject,"UIToggle").value==true then   
        if this.open_roomRecordSimpleData[tonumber(obj2.name)].status==2 then 
            http_request_interface.getRoomSimpleList(nil,{2}, 0, function (code, m, str) 
               local s=string.gsub(str,"\\/","/")  
               local t=ParseJsonStr(s)
               log(str)
               openrecord_ui.Show(t,2)    
            end)
        else
            http_request_interface.getRoomSimpleList(nil,{0,1,3}, 0, function (code, m, str)
               local s=string.gsub(str,"\\/","/")  
               local t=ParseJsonStr(s)
               log(str)
               openrecord_ui.Show(t,1)    
            end)
        end
        
    else
        if rid==0 then 
           recorddetails_ui.Show()    
        else
           http_request_interface.getRoomByRid(rid,1,function (code,m,str)
               local s=string.gsub(str,"\\/","/")  
               local t=ParseJsonStr(s)
               log(str)
               recorddetails_ui.Show(t)   
           end)
        end 
    end
    
    
   

end

--[[ 
  
]]--