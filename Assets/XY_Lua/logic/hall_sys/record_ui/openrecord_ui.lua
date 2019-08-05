--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion
openrecord_ui=ui_base.New()
local this=openrecord_ui 
local record1={}
local record2={}
function this.Show(t,code)
	if IsNil(this.gameObject) then
		require ("logic/hall_sys/record_ui/openrecord_ui")
		this.gameObject=newNormalUI("Prefabs/UI/Hall/openrecord_ui")
	else
		this.gameObject:SetActive(true)
	end  
   
    this.addlistener() 
    if t~=nil then
        for k,v in pairs(t.data) do
            if code~=2 then
                table.insert(record1,v)
            else 
                table.insert(record2,v)
            end
        end
    end
    if code~=2 then 
        componentGet(this.toggle_record1,"UIToggle").value=true
        this.UpdateRoomRecordSimpleData(record1,1) 
    else
        componentGet(this.toggle_record2,"UIToggle").value=true
        this.UpdateRoomRecordSimpleData(record2,2) 
    end
end 
function this.Start() 
    this:RegistUSRelation()
end

function this.OnDestroy()
    this:UnRegistUSRelation()
end

function this.Hide()
    if not IsNil(this.gameObject) then
        GameObject.Destroy(this.gameObject)
        this.gameObject=nil
    end
    record1={}
    record2={}
    page1=0
    page2=0
end
 
function this.addlistener()
    local btn_close=child(this.transform,"openrecord_panel/btn_close")
    if btn_close~=nil then
        addClickCallbackSelf(btn_close.gameObject,this.Hide,this)
    end

    this.toggle_record2=child(this.transform,"openrecord_panel/Panel_Middle/toggle_jieshu")
    if this.toggle_record2~=nil then
        addClickCallbackSelf(this.toggle_record2.gameObject,this.Refresh2,this)
    end
    this.toggle_record1=child(this.transform,"openrecord_panel/Panel_Middle/toggle_weikaishi")
    if this.toggle_record1~=nil then
        addClickCallbackSelf(this.toggle_record1.gameObject,this.Refresh1,this)
    end

    this.wrap_weikaiqi=componentGet(child(this.transform,"openrecord_panel/Panel_Middle/sv_all/wrap_weikaiqi").gameObject,"UIWrapContent")
    if this.wrap_weikaiqi ~= nil then
   		this.wrap_weikaiqi.onInitializeItem = this.OnUpdateItem
   	end

    this.wrap_yijieshu=componentGet(child(this.transform,"openrecord_panel/Panel_Middle/sv_all/wrap_yijieshu").gameObject,"UIWrapContent")
    if this.wrap_yijieshu ~= nil then
   		this.wrap_yijieshu.onInitializeItem = this.OnUpdateItem
   	end

    this.item=child(this.transform,"openrecord_panel/Panel_Middle/sv_all/item_1") 
    this.itemheight=componentGet(this.item.gameObject,"UISprite").height
end

local page1=0
local page2=0
function this.Refresh1()

    http_request_interface.getRoomSimpleList(nil,{0,1,3},page1, function (code, m, str)
           local s=string.gsub(str,"\\/","/")  
           local t=ParseJsonStr(s)  
           print(str)
           record1={}
           for k,v in pairs(t.data) do
              table.insert(record1,v)  
           end  
           this.UpdateRoomRecordSimpleData(record1,1) 
    end)
end
function this.Refresh2()
    http_request_interface.getRoomSimpleList(nil,{2}, page2, function (code, m, str) 
           local s=string.gsub(str,"\\/","/")  
           local t=ParseJsonStr(s)  
           record2={}
           for k,v in pairs(t.data) do 
              table.insert(record2,v) 
           end
           this.UpdateRoomRecordSimpleData(record2,2)  
    end) 
end
function this.UpdateRoomRecordSimpleData(data,code)
	this.roomrecord =data    
    if data~=nil then 
	    this.maxCount = table.getCount(this.roomrecord) 
        print("maxcount"..this.maxCount)
	    this.InitPanelRecord(this.maxCount,code)  
    end
    
end

function this.InitPanelRecord(count,code)
    if code==1 then  
		this.wrap_weikaiqi.minIndex = -count+1
		this.wrap_weikaiqi.maxIndex = 0 
        if this.wrap_weikaiqi.transform.childCount >=4  then
		    return
	    end 
    else 
        this.wrap_yijieshu.minIndex = -count+1
		this.wrap_yijieshu.maxIndex = 0 
        if this.wrap_yijieshu.transform.childCount >=4  then
		    return
	    end 
    end  

	if count >0 and count <=5 then
        if  code==1 then
            for i=0 ,this.wrap_weikaiqi.transform.childCount-1 do
                destroy(this.wrap_weikaiqi.transform:GetChild(i).gameObject)
            end
		    for i=0, count-1 do
			    local go= this.InitItem(this.roomrecord[i+1],i,code)  
                print("create1")
                this.OnUpdateItem(go,nil,-i)
		    end
        else
            for i=0 ,this.wrap_yijieshu.transform.childCount-1 do
                destroy(this.wrap_yijieshu.transform:GetChild(i).gameObject)
            end
		    for i=0, count-1 do
			    local go= this.InitItem(this.roomrecord[i+1],i,code) 
                print("create2")
                this.OnUpdateItem(go,nil,-i)
		    end
        end 
	elseif count>5 then
		for a=0,4 do 
			this.InitItem(this.roomrecord[a+1],a,code) 
            this.wrap_weikaiqi.enabled =code==1  
            this.wrap_yijieshu.enabled =code==2 
		end 
	end
end

function this.InitItem(data,i,code) 
    local tmpItem
	if code ==1 then
     	  tmpItem= NGUITools.AddChild(this.wrap_weikaiqi.gameObject,this.item.gameObject)
		  tmpItem.transform.localPosition = Vector3.New(0,-i*this.itemheight,0)
		  tmpItem.gameObject:SetActive(true)  
	else
	      tmpItem = NGUITools.AddChild(this.wrap_yijieshu.gameObject,this.item.gameObject)
		  tmpItem.transform.localPosition = Vector3.New(0,-i*this.itemheight,0)
		  tmpItem.gameObject:SetActive(true)  
	end  
    return tmpItem
end


function this.OnUpdateItem(go,index,realindex)
    print(realindex.."realindex")
    local rindext=1-realindex 
    local t= this.roomrecord[rindext]
    go.name=rindext
    addClickCallbackSelf(go.gameObject,this.messagebox,this)
    this.UpdateInfo(go,t) 
    if this.maxCount==rindext and this.maxCount>4 then
        if this.roomrecord==record2 and this.maxCount>4 then
             page2=page2+1
            this.Refresh2() 
        elseif this.roomrecord==record1 then
            page1=page1+1
            this.Refresh1() 
        end
    end
end
 

function this.messagebox(obj1,obj2)
   local statusn=tonumber(this.roomrecord[tonumber(obj2.name)].status)+1
   if this.roomstatus[statusn]=="已开房" then
    message_box.ShowGoldBox("牌局还未开始，请进入游戏",nil,2,{function()message_box:Close() end,function()message_box:Close()this.enter(obj1,child(obj2.transform,"btn_enter"))  end},{"quxiao","queding"},{"a01","a02"}) 
    elseif this.roomstatus[statusn]=="未开局" then
     message_box.ShowGoldBox("房间未开启，房卡已经返还",nil,1,{function()message_box:Close() end},{"quxiao"},{"a01"})
    elseif this.roomstatus[statusn]=="已结算" then
        this.opendetail(this.roomrecord[tonumber(obj2.name)])
    end
end

function this.opendetail(data)
    openrecord_ui.Hide()
    local rid=data.rid
    waiting_ui.Show()
    http_request_interface.getRoomByRid(rid,1,function (code,m,str)
               local s=string.gsub(str,"\\/","/")  
               local t=ParseJsonStr(s)
               print(str)
               recorddetails_ui.Show(t) 
               waiting_ui.Hide()  
           end) 
end 
function this.UpdateInfo(go,t)
    local lab_data=child(go.transform,"sp_data/lab_data")
    if lab_data~=nil then
        componentGet(lab_data.gameObject,"UILabel").text=os.date("%Y/%m/%d %H:%M",t.ctime)
    end  
    local lab_rno=child(go.transform,"lab_rno")
    if lab_rno~=nil then
        componentGet(lab_rno.gameObject,"UILabel").text=t.rno
    end
    local lab_status=child(go.transform,"lab_status")
    if lab_status~=nil then
        componentGet(lab_status.gameObject,"UILabel").text=this.roomstatus[tonumber(t.status)+1]
    end
    local btn_enter=child(go.transform,"btn_enter")
    if this.roomstatus[tonumber(t.status)+1]=="已结算" or this.roomstatus[tonumber(t.status)+1]=="未开局" then 
        componentGet(btn_enter.gameObject,"UIButton").enabled=false
        addClickCallbackSelf(btn_enter.gameObject,function()end,this)
        componentGet(child(btn_enter.transform,"Background").gameObject,"UISprite").spriteName="jinruyouxi"
    else
        componentGet(child(btn_enter.transform,"Background").gameObject,"UISprite").spriteName="jinruyouxi01"
        componentGet(btn_enter.gameObject,"UIButton").enabled=true
        addClickCallbackSelf(btn_enter.gameObject,this.enter,this)
    end
end
this.roomstatus={
"已开房",
"已开局",
"已结算",
"未开局",
}
function this.enter(obj1,obj2)   
    print(obj2.name.."namedadwad1231312")
    table.foreach(record1[tonumber(obj2.transform.parent.name)],print)
    join_room_ctrl.JoinRoomByRno(record1[tonumber(obj2.transform.parent.name)].rno)
end