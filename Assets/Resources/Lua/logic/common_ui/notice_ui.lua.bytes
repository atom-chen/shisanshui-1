--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion 
notice_ui = ui_base.New()
local this = notice_ui 
local delte=320
local startlabel=320
local endlabel=-320 

this.messagetable={}
function this.Show(str,duration)
	if this.gameObject==nil then
		require ("logic/common_ui/notice_ui")
		this.gameObject=newNormalUI("Prefabs/UI/Common/notice_ui")
        table.insert(this.messagetable,str) 
        corRunmessage(this.messagetable[1],duration)
        table.remove(this.messagetable,1)
	else  
		this.gameObject:SetActive(true) 
        table.insert(this.messagetable,str)
	end  
end

function this.Hide()
    if not IsNil(this.gameObject) then
        GameObject.Destroy(this.gameObject)
        this.gameObject=nil
    end 
end


function corRunmessage(str,duration)
   this.label=child(this.transform,"sv_zoumadeng/Label")
   if this.label~=nil then 
       log(str ..this.label.name)
       componentGet(this.label.gameObject,"UILabel").text=str
       startlabel=componentGet(this.label.gameObject,"UILabel").width/2+delte
       endlabel=-componentGet(this.label.gameObject,"UILabel").width/2-delte
       this.label.transform.localPosition={x=startlabel,y=this.label.transform.localPosition.y,z=this.label.transform.localPosition.z}
       this.cor=coroutine.create(movelabel)
       coroutine.resume(this.cor,duration)
   end
end

function movelabel(duration) 
    while true do 
        this.label.transform.localPosition={x=this.label.transform.localPosition.x-startlabel*2/duration/50,y=this.label.transform.localPosition.y,z=this.label.transform.localPosition.z}
        coroutine.wait(0.02)
        log(this.label.transform.localPosition.x)
        if tonumber(this.label.transform.localPosition.x)<endlabel then   
            if table.getCount(this.messagetable)>0 then 
                local s=this.messagetable[1]
                log(table.getCount(this.messagetable))
                table.remove(this.messagetable,1) 
                corRunmessage(s)
            else 
                this.Hide() 
                coroutine.yield() 
            end 
        end
    end
end

 