--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion
help_ui = ui_base.New()
local this = help_ui 

function this.Show(rulestype)
	if this.gameObject==nil then
		require ("logic/hall_sys/help_ui")
		this.gameObject=newNormalUI("Prefabs/UI/Hall/help_ui")
	else 
        i=0
		GameObject.Destroy(this.gameObject)
        this.gameObject=nil
	end 
    this.addlistener()  
     if rulestype=="rules/shisanshui" then
        this.readss() 
    else
        this.readfz() 
    end 
end
function this.Start() 
    this:RegistUSRelation()
end

function this.OnDestroy()
    this:UnRegistUSRelation()
end
function this.addlistener()
   local btn_close=child(this.transform,"panel_help/btn_close")
   if btn_close~=nil then
      addClickCallbackSelf(btn_close.gameObject,this.Hide,this)
   end

   this.toggle_fuzhoumj=child(this.transform,"panel_help/Panel_Left/sv_playrole/toggle_grid/fzmj_toggle")
   if this.toggle_fuzhoumj~=nil then
      addClickCallbackSelf(this.toggle_fuzhoumj.gameObject,this.readfz,this)
   end

   this.toggle_sss=child(this.transform,"panel_help/Panel_Left/sv_playrole/toggle_grid/sss_toggle")
   if this.toggle_sss~=nil then
      addClickCallbackSelf(this.toggle_sss.gameObject,this.readss,this)
   end
end

function this.Hide()
    if not IsNil(this.gameObject) then 
        currenttype=nil
		GameObject.Destroy(this.gameObject)
        this.gameObject=nil
	end
    
end  
function this.readfz() 
    read("rules/fuzhoumj","back_1") 
end

function this.readss() 
    read("rules/shisanshui","back_2") 
end
this.currentPosy=0 

function read(rulestype,backname)  
    local sv=child(this.transform,"panel_help/Panel_Right") 
    componentGet(sv.gameObject,"UIScrollView"):ResetPosition()
    this.currentPosy=0   
    if rulestype==nil then
        return
    end
    if rulestype=="rules/shisanshui" then
        componentGet(this.toggle_sss.gameObject,"UIToggle").value=true
    else
        componentGet(this.toggle_fuzhoumj.gameObject,"UIToggle").value=true
    end 
    local path=rulestype or "rules/shisanshui"  
    local i=1 --子目录数量
    local m=1--主目录数量  
    local txt=newNormalObjSync(path) 
    local t=string.split(tostring(txt),"##")
    for k=1,table.getCount(t),1  do 
        local str=t[k]--DelS(t[k]) 
        local tt= string.split(str,"-")     
        if table.getCount(tt)>1 then    
           if string.find(tt[1], "main", 1)~=nil  then
              m=this.addmainlab(m,tt[2],backname)  
           end
           if string.find(tt[1], "child", 1)~=nil then
               if table.getCount(tt)>2 then  
                for i=3, table.getCount(tt) do
                    tt[2]=tt[2].."-"..tt[i]
                end 
               end
              i=this.addchildlab(i,tt[2],backname)  
           end
        elseif t[k]~=nil then   
           this.upchildlab(i,str,backname)
    end 
    end
     
end

function DelS(s)
        assert(type(s)=="string")
        return s:match("^%s*(.-)%s*$")
end
 


function this.addmainlab(m,str,backname)    
     local lab_message01=child(this.transform, "panel_help/Panel_Right/"..backname.."/lab_main"..tostring(m)) 
     if lab_message01~=nil then
         componentGet(lab_message01.transform,"UILabel").text=str
     else
         local lab_message=child(this.transform, "panel_help/Panel_Right/"..backname.."/lab_main"..tostring(m-1))
         lab_message01=GameObject.Instantiate(lab_message.gameObject)
         lab_message01.transform.parent=lab_message.transform.parent  
         lab_message01.name="lab_main"..tostring(m)
         lab_message01.transform.localScale={x=1,y=1,z=1}  
         lab_message01.transform.localPosition={x=0,y=this.currentPosy-7,z=0} 
         componentGet(lab_message01,"UILabel").text=str
     end   
     this.currentPosy=lab_message01.transform.localPosition.y-componentGet(lab_message01.gameObject,"UILabel").height-20  
     m=m+1   
     return m
end

function this.addchildlab(i,str,backname)  
    local lab_message01=child(this.transform, "panel_help/Panel_Right/"..backname.."/lab_child"..tostring(i))
    if lab_message01~=nil then
       componentGet(lab_message01.transform,"UILabel").text=str
    else 
       local lab_message=child(this.transform, "panel_help/Panel_Right/"..backname.."/lab_child"..tostring(i-1))
       lab_message01=GameObject.Instantiate(lab_message.gameObject)
       lab_message01.transform.parent=lab_message.transform.parent 
       lab_message01.name="lab_child"..tostring(i)
       lab_message01.transform.localScale={x=1,y=1,z=1}  
       lab_message01.transform.localPosition={x=0,y=this.currentPosy,z=0}
       componentGet(lab_message01,"UILabel").text=str  
    end    
    this.currentPosy=lab_message01.transform.localPosition.y-componentGet(lab_message01.gameObject,"UILabel").height 
    i=i+1
   return i
end

function  this.upchildlab(i,str,backname)
   local lab_message01=child(this.transform, "panel_help/Panel_Right/"..backname.."/lab_child"..tostring(i-1))
   componentGet(lab_message01.transform,"UILabel").text=componentGet(lab_message01.transform,"UILabel").text.."\n"..str
   this.currentPosy=lab_message01.transform.localPosition.y-componentGet(lab_message01.gameObject,"UILabel").height

   return i
end

function this.OnDestroy()
	this:UnRegistUSRelation()
end