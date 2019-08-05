--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion
recorddetails_ui = ui_base.New()
local this = recorddetails_ui
this.data={}
function this.Show(data)
	if this.gameObject==nil then
		require ("logic/hall_sys/record_ui/recorddetails_ui")
		this.gameObject = newNormalUI("Prefabs/UI/Hall/recorddetails_ui")
	else
		this.gameObject:SetActive(true) 
	end
    this.addlistener()
    if data~=nil then
       this.data=data.data 
       this.InitPlayData()
       this.InitPointData()
       print("----------------init")
    else
        this.data=nil
    end 
end
function this.Hide()
    ui_sound_mgr.PlaySoundClip("common/audio_button_click")
    if this.gameObject==nil then
		return
	else
		GameObject.Destroy(this.gameObject)
        this.gameObject=nil
	end
end

function this.Start() 
    this:RegistUSRelation()
end

function this.OnDestroy()
    this:UnRegistUSRelation()
end

function this.addlistener()
    this.grid_reward = child(this.transform, "recorddetails_panel/Panel_Middle/sv_all/grid_reward")  
    this.grid_rank = child(this.transform, "recorddetails_panel/Panel_Middle/sv_all/grid_rank")  
    local btn_close=child(this.transform, "recorddetails_panel/btn_close")
    if btn_close~=nil then
        addClickCallbackSelf(btn_close.gameObject,this.Hide,this)
    end 
    local toggle_rank=child(this.transform,"recorddetails_panel/Panel_Middle/toggle_rank")  
    if toggle_rank~=nil then
        addClickCallbackSelf(toggle_rank.gameObject,this.InitPointData,this)
    end
    this.datatime=child(this.transform,"recorddetails_panel/Panel_Middle/sp_data/lab_data")

    local sharef=child(this.transform,"recorddetails_panel/Panel_Middle/btn_sharefriend")
    if sharef~=nil then
       addClickCallbackSelf(sharef.gameObject,this.sharef,this)
    end
    local shareq=child(this.transform,"recorddetails_panel/Panel_Middle/btn_sharefriendQ")
    if shareq~=nil then
       addClickCallbackSelf(shareq.gameObject,this.shareq,this)
    end
end

function this.shareq(obj1,obj2)
    ui_sound_mgr.PlaySoundClip("common/audio_button_click")
    print("share") 
    YX_MoblieAPI.Instance:GetCenterPicture("screenshot.png")
    YX_MoblieAPI.Instance.onfinishtx=function(tx) 
        local shareType = 1--0微信好友，1朋友圈，2微信收藏
        local contentType = 2 --1文本，2图片，3声音，4视频，5网页
        local title = "我在测试" 
        local filePath =YX_APIManage.Instance:onGetStoragePath().."screenshot.png"
        local url = "http://connect.qq.com/"
        local description = "test"
        YX_APIManage.Instance:WeiXinShare(shareType,contentType,title,filePath,url,description)
    end
    

end

function this.sharef(obj1,obj2)
    ui_sound_mgr.PlaySoundClip("common/audio_button_click")
    print("share")
     
    YX_MoblieAPI.Instance:GetCenterPicture("screenshot.png")
    YX_MoblieAPI.Instance.onfinishtx=function(tx) 
        local shareType = 0--0微信好友，1朋友圈，2微信收藏
        local contentType = 2 --1文本，2图片，3声音，4视频，5网页
        local title = "我在测试"  
        local filePath = YX_APIManage.Instance:onGetStoragePath().."screenshot.png"
        local url = "http://connect.qq.com/"
        local description = "test"
        YX_APIManage.Instance:WeiXinShare(shareType,contentType,title,filePath,url,description)
    end
   
end
 
function this.InitPlayData()  
   if this.data==nil then
       return
   end
   if this.data.ctime~=nil then
       componentGet(this.datatime,"UILabel").text=os.date("%Y/%m/%d %H:%M",this.data.ctime)
       this.datatime.gameObject:SetActive(true)
   end
   if this.data.clog.scorelog==nil or table.getCount(this.data.clog.scorelog)==0 then
      return
   end
   for i=1,table.getCount(this.data.clog.scorelog) do 
      local item=child(this.transform, "recorddetails_panel/Panel_Middle/sv_all/item_"..i)
      if item==nil then
          local old_item=child(this.transform, "recorddetails_panel/Panel_Middle/sv_all/item_reward")
          item=NGUITools.AddChild(this.grid_reward.gameObject,old_item.gameObject)
          item.transform.localScale={x=1,y=1,z=1}
          item.name="item_"..i
          componentGet(this.grid_reward.gameObject,"UIGrid"):Reposition()   
      end  
      
      local lab_number=child(item.transform,"sp_number/lab_number") 
      componentGet(lab_number.gameObject,"UILabel").text=i
      local k=1  
      for j,v in pairs(this.data.clog.chairs) do 
          local tex_photo=child(item.transform, "sv_user/grid_player/tex_photo_"..k)
          if tex_photo==nil then
              local old_tex_photo=child(item.transform, "sv_user/grid_player/tex_photo_"..(k-1))
              tex_photo=NGUITools.AddChild(child(item.transform,"sv_user/grid_player").gameObject,old_tex_photo.gameObject)
              tex_photo.transform.localScale={x=1,y=1,z=1}
              tex_photo.name="tex_photo_"..k 
              componentGet(child(item.transform,"sv_user/grid_player"),"UIGrid"):Reposition()
          end
          
          local imagetype=this.data.clog.imgs[j].type 
          local imageurl=this.data.clog.imgs[j].url
          hall_data.getuserimage(componentGet(tex_photo.gameObject,"UITexture"),imagetype,imageurl)
          local lab_name=child(tex_photo.transform,"lab_name")
          componentGet(lab_name.gameObject,"UILabel").text=v
          local lab_earn=child(tex_photo.transform,"lab_reward")
          if tonumber(this.data.clog.scorelog[i][j])>0 then
              componentGet(lab_earn.gameObject,"UILabel").text="+"..this.data.clog.scorelog[i][j]
          else
              componentGet(lab_earn.gameObject,"UILabel").text=this.data.clog.scorelog[i][j] 
          end
          k=k+1
      end 
   end
end

function this.InitPointData()
   if this.data==nil then
       return
   end
   if this.data.accountc.rewards==nil or table.getCount(this.data.accountc.rewards)==0 then
      return
   end
    local i=1
    for k,v in pairs(this.data.accountc.rewards) do   
      local item=child(this.transform, "recorddetails_panel/Panel_Middle/sv_all/grid_rank/item_"..i)
      if item==nil then
          local old_item=child(this.transform, "recorddetails_panel/Panel_Middle/sv_all/item_rank")
          item=NGUITools.AddChild(this.grid_rank.gameObject,old_item.gameObject)
          item.transform.localScale={x=1,y=1,z=1}
          item.name="item_"..i
          componentGet(this.grid_rank.gameObject,"UIGrid"):Reposition()  
      end 
      local lab_number=child(item.transform,"sp_number/lab_number")
      componentGet(lab_number.gameObject,"UILabel").text =i
      
      local lab_name=child(item.transform,"lab_name")
      componentGet(lab_name.gameObject,"UILabel").text=v.nickname
       
      local lab_rounds=child(item.transform,"lab_rounds")
      componentGet(lab_rounds.gameObject,"UILabel").text="对局数:"..this.data.accountc.ju_num
      if tonumber(this.data.uid)==tonumber(v.uid) then
          child(item.transform,"fangzhu").gameObject:SetActive(true)
      else 
          child(item.transform,"fangzhu").gameObject:SetActive(false)
      end
      local lab_win=child(item.transform,"lab_win")
      componentGet(lab_win.gameObject,"UILabel").text="胜局:"..v.hu_num 
      local sp=child(item.transform,"number_grid/Sprite") 
      lab_gnumber=componentGet(child(item.transform,"lab_gnumber").gameObject,"UILabel")
      lab_bnumber=componentGet(child(item.transform,"lab_bnumber").gameObject,"UILabel")
      if  tonumber(v.all_score) >=0  then
            lab_gnumber.gameObject:SetActive(true)
            lab_bnumber.gameObject:SetActive(false)  
            lab_gnumber.text="+"..v.all_score
        else 
            lab_bnumber.gameObject:SetActive(true)
            lab_gnumber.gameObject:SetActive(false)
            lab_bnumber.text=v.all_score
        end 
      local tex_photo=child(item.transform,"tex_photo") 
      local imagetype=v.img.type 
      local imageurl=v.img.url
      hall_data.getuserimage(componentGet(tex_photo.gameObject,"UITexture"),imagetype,imageurl)
      i=i+1
   end
end

 

--[[
{"ret":0,"data":{"rid":13,"uid":4426802,"rno":"183335","gid":18,"cfg":{"rounds":4,"pnum":0,"hun":1,"hutype":0,"wind":1,"lowrun":0,"gangrun":0,"dealeradd":1,"gfadd":1,"spadd":0},"accountc":{"banker":0,"curr_ju":1,"ju_num":0,"rewards":{"p2":{"uid":796136,"hu_score":0,"all_score":0,"hu_num":0,"score":[{"self_draw_count":0},{"revealed_gang_count":0},{"conceled_gang_count":0},{"dealer_add_count":0},{"gangflower_count":0},{"huang_pai_count":0}],"nickname":"玩家","img":{"url":null,"type":null}},"p3":{"uid":3475308,"hu_score":0,"all_score":0,"hu_num":0,"score":[{"self_draw_count":0},{"revealed_gang_count":0},{"conceled_gang_count":0},{"dealer_add_count":0},{"gangflower_count":0},{"huang_pai_count":0}],"nickname":"玩家","img":{"url":null,"type":null}},"p4":{"uid":6913856,"hu_score":0,"all_score":0,"hu_num":0,"score":[{"self_draw_count":0},{"revealed_gang_count":0},{"conceled_gang_count":0},{"dealer_add_count":0},{"gangflower_count":0},{"huang_pai_count":0}],"nickname":"玩家","img":{"url":null,"type":null}},"p1":{"uid":14011913,"hu_score":0,"all_score":0,"hu_num":0,"score":[{"self_draw_count":0},{"revealed_gang_count":0},{"conceled_gang_count":0},{"dealer_add_count":0},{"gangflower_count":0},{"huang_pai_count":0}],"nickname":"玩家88D7F67B","img":{"url":"16","type":1}}}},"status":2,"uri":"","ctime":0,"clog":{"chairs":{"p1":"玩家88D7F67B","p2":"玩家","p3":"玩家","p4":"玩家"},"imgs":{"p1":{"url":"16","type":1},"p2":{"url":null,"type":null},"p3":{"url":null,"type":null},"p4":{"url":null,"type":null}},"scorelog":[]},"cost":0,"expiretime":0}}
]]--