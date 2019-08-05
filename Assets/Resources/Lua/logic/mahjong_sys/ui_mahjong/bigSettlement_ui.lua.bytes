
require "logic/network/http_request_interface"
require "logic/hall_sys/openroom/room_data"
require "logic/mahjong_sys/_model/room_usersdata_center"
require "logic/mahjong_sys/mahjong_play_sys"

bigSettlement_ui = ui_base.New()
local this = bigSettlement_ui

local mPlayerItem
local mInfoItem

local rid = 0

local reward_data = nil
local banker = 1

function this.Init(t_rid)
	rid = t_rid
	http_request_interface.getRoomByRid(rid,1,function(code,m,str)
		local s=string.gsub(str,"\\/","/")
		print("-------this.OnGetRoomReturnDate-------"..tostring(s))
	    local t=ParseJsonStr(s)
	    if tonumber(t.ret)~=0 then
	        return
	    end
		reward_data = t["data"].accountc.rewards
		banker = t["data"].accountc.banker
	end)
end

function this.Show(t_rid)
	if rid ~= t_rid then
		reward_data = nil
	end
	rid = t_rid
	if this.gameObject==nil then
		require ("logic/mahjong_sys/ui_mahjong/bigSettlement_ui")
		this.gameObject = newNormalUI("Prefabs/UI/Mahjong/bigSettlement_ui")
	else
		this.gameObject:SetActive(true)
	end
end

function this.Hide()
 	this.gameObject:SetActive(false)
end

function this.Awake( )
 	-- body
 end

function this.Start()
	this:RegistUSRelation()
	this.RegisterEvents1()	
	
	print("rid:"..rid)
	if reward_data == nil then
		http_request_interface.getRoomByRid(rid,1,this.OnGetRoomReturnDate) 
	else
		this.ReflushUI(reward_data)
	end
end
function this.OnGetRoomReturnDate(code,m,str)
	local s=string.gsub(str,"\\/","/")
	print("-------this.OnGetRoomReturnDate-------"..tostring(s))
    local t=ParseJsonStr(s)
    if tonumber(t.ret)~=0 then
        return
    end
	
	local reward = t["data"].accountc.rewards
	if reward == nil then
		print("reward == nil")
	else
		print("总结算")
		this.ReflushUI(reward)
	end
end


function this.OnDestroy()
	this:UnRegistUSRelation()
end

 
function this.RegisterEvents1()
	local btnEnd = child(this.transform, "panel/btn/btn_end")
	if btnEnd ~=nil then 
	   addClickCallbackSelf(btnEnd.gameObject, this.OnBtnEndClick, this)
	end

	local btnShare = child(this.transform, "panel/btn/btn_share")
	if btnShare ~= nil then
		addClickCallbackSelf(btnShare.gameObject, this.OnBtnShareClick, this)
	end
end

function this.OnBtnEndClick()
	print("OnBtnEndClick--------------------------------------")
	this.Hide()
	mahjong_play_sys.LeaveReq()
end

function this.OnBtnShareClick()
	ui_sound_mgr.PlaySoundClip("common/audio_button_click")
    print("OnBtnShareClick")

    local picName= "screenshot"..tostring(os.date("%Y%m%d%H%M%S", os.time()))..".png"
	YX_MoblieAPI.Instance:GetCenterPicture(picName)
    YX_MoblieAPI.Instance.onfinishtx=function(tx) 
        local shareType = 0--0微信好友，1朋友圈，2微信收藏
        local contentType = 2 --1文本，2图片，3声音，4视频，5网页
        local title = "分享战绩"  
        local filePath = YX_APIManage.Instance:onGetStoragePath()..picName
        local url = "http://connect.qq.com/"
        local description = "分享战绩"
        YX_APIManage.Instance:WeiXinShare(shareType,contentType,title,filePath,url,description)
    end
end

function this.ReflushUI(result)

	--local len = 4
	--for i=1,len do
	local template = child(this.transform,"panel/player1") 
	for k, v in pairs(result) do
		local i = room_usersdata_center.GetLogicSeatByStr(k)
		if v~= nil then
		    local good = child(this.transform,"panel/center/player"..tostring(i))     
		   	if good==nil then 
			    good = GameObject.Instantiate(template.gameObject)
			    good.transform.parent=child(this.transform,"panel/center") 
	            good.name="player"..tostring(i)
	            good.transform.localScale={x=1,y=1,z=1}    
		   	end    	    
		   	good.gameObject:SetActive(true)
		   	--头像
		   	local tHead=componentGet(child(good.transform,"head"),"UITexture")
		   	local imageurl=v["img"]["url"]
		   	local imagetype =v["img"]["type"]
		   	this.getuserimage(tHead,imagetype,imageurl)
		   	--房主
		   	local bMaster = false
		   	if i==banker then
		   		bMaster = true
		   	end
		   	local masterTran = child(good.transform,"head/master")
		   	masterTran.gameObject:SetActive(bMaster)

		   	SetLableName(good.transform,"name","用户"..v["nickname"])
		   	SetLableName(good.transform,"id","ID:"..v["uid"])

		   	local tScore = v["all_score"]
		   	local score_add = child(good.transform,"score/add")
		   	local score_sub = child(good.transform,"score/sub")
		   	local winTran = child(good.transform,"win")
		   	local winFrame = child(good.transform,"frame")
		   	if tScore > 0 then
		   		score_add.gameObject:SetActive(true)
		   		score_sub.gameObject:SetActive(false)
		   		SetLableName(score_add.transform,"","+"..tostring(tScore))
		   		winTran.gameObject:SetActive(true)
		   		winFrame.gameObject:SetActive(true)
		   	else
		   		score_add.gameObject:SetActive(false)
		   		score_sub.gameObject:SetActive(true)
		   		SetLableName(score_sub.transform,"",""..tostring(tScore))
		   		winTran.gameObject:SetActive(false)
		   		winFrame.gameObject:SetActive(false)
		   	end

		   	--设置玩牌信息
		   	this.setPlayGameInfo(child(good.transform,"grid"),v)
		end
	end
	local grid=child(this.transform,"panel/center")
    componentGet(grid,"UIGrid"):Reposition()   
end

function this.setPlayGameInfo(parent,reward)

	local tList = {}	
	for kk, score in pairs(reward.score) do
		--固定
		if score["selfdraw"] ~= nil then
			local item = {}
			item.selfdraw = score["selfdraw"]
			table.insert(tList,item)
		end
		if score["gunwin"] ~= nil then
			local item = {}
			item.gunwin = score["gunwin"]
			table.insert(tList,item)
		end
		if score["nJiePao"] ~= nil then
			local item = {}
			item.nJiePao = score["nJiePao"]
			table.insert(tList,item)
		end
		--不固定
		if score["nXianJin"] ~= nil and score["nXianJin"] >0 then
			local item = {}
			item.nXianJin = score["nXianJin"]
			table.insert(tList,item)
		end
		if score["nWuHuaWuGang"] ~= nil and score["nWuHuaWuGang"] >0 then
			local item = {}
			item.nWuHuaWuGang = score["nWuHuaWuGang"]
			table.insert(tList,item)
		end
		if score["nOneFlower"] ~= nil and score["nOneFlower"] >0 then
			local item = {}
			item.nOneFlower = score["nOneFlower"]
			table.insert(tList,item)
		end
		if score["nGoldBird"] ~= nil and score["nGoldBird"] >0 then
			local item = {}
			item.nGoldBird = score["nGoldBird"]
			table.insert(tList,item)
		end
		if score["nGoldDragon"] ~= nil and score["nGoldDragon"] >0 then
			local item = {}
			item.nGoldDragon = score["nGoldDragon"]
			table.insert(tList,item)
		end
		if score["nHalfQYS"] ~= nil and score["nHalfQYS"] >0 then
			local item = {}
			item.nHalfQYS = score["nHalfQYS"]
			table.insert(tList,item)
		end
		if score["nQYS"] ~= nil and score["nQYS"] >0 then
			local item = {}
			item.nQYS = score["nQYS"]
			table.insert(tList,item)
		end
		if score["nSanJinDao"] ~= nil and score["nSanJinDao"] >0 then
			local item = {}
			item.nSanJinDao = score["nSanJinDao"]
			table.insert(tList,item)
		end
	end

	if reward["flowerFan"] ~= nil and reward["flowerFan"] > 0 then
		local item = {}
		item.flowerFan = reward["flowerFan"]
		table.insert(tList,item)
	end
	if reward["gangFan"] ~= nil and reward["gangFan"] > 0 then
		local item = {}
		item.gangFan = reward["gangFan"]
		table.insert(tList,item)
	end
	if reward["lianZhuangFan"] ~= nil and reward["lianZhuangFan"] > 0 then
		local item = {}
		item.lianZhuangFan = reward["lianZhuangFan"]
		table.insert(tList,item)
	end

	local i = 1
	for k, v in pairs(tList) do
		local good = child(parent.transform,"item"..tostring(i))     
	   	if good==nil then 
	   		print("--------------------:"..tostring(i))
		    local o_good = child(parent.transform,"item"..tostring(1))
		    good = GameObject.Instantiate(o_good.gameObject)
		    good.transform.parent=o_good.transform.parent 
            good.name="item"..tostring(i)
            good.transform.localScale={x=1,y=1,z=1}    
	   	end    	    
	   	good.gameObject:SetActive(true)

	   	local infoLabel = componentGet(good.transform,"UILabel")

	   	if v.selfdraw ~= nil then
	   		infoLabel.text = "自摸胡："..tostring(v.selfdraw).."次"
   		elseif v.gunwin ~= nil then
   			infoLabel.text = "点炮胡："..tostring(v.gunwin).."次"
   		elseif v.nJiePao ~= nil then
   			infoLabel.text = "接炮："..tostring(v.nJiePao).."次"		   

		elseif v.nXianJin ~= nil then
			infoLabel.text = "闲金："..tostring(v.nXianJin).."次"	
		elseif v.nWuHuaWuGang ~= nil then
			infoLabel.text = "无花无杠："..tostring(v.nWuHuaWuGang).."次"	
		elseif v.nOneFlower ~= nil then
			infoLabel.text = "一张花："..tostring(v.nOneFlower).."次"	
		elseif v.nGoldBird ~= nil then
			infoLabel.text = "金雀："..tostring(v.nGoldBird).."次"	
		elseif v.nGoldDragon ~= nil then
			infoLabel.text = "金龙："..tostring(v.nGoldDragon).."次"
		elseif v.nHalfQYS ~= nil then
			infoLabel.text = "半清一色："..tostring(v.nHalfQYS).."次"	
		elseif v.nQYS ~= nil then
			infoLabel.text = "清一色："..tostring(v.nQYS).."次"	
		elseif v.nSanJinDao ~= nil then
			infoLabel.text = "三金倒："..tostring(v.nSanJinDao).."次"

		elseif v.flowerFan ~= nil then
			infoLabel.text = "花："..tostring(v.flowerFan).."次"	
		elseif v.gangFan ~= nil then
			infoLabel.text = "杠："..tostring(v.gangFan).."次"	
		elseif v.lianZhuangFan ~= nil then
			infoLabel.text = "连庄："..tostring(v.lianZhuangFan).."次"	
		end

	   	i = i + 1
	end
	componentGet(parent,"UIGrid"):Reposition()  
end

function this.getuserimage(tx,imagetype,imageurl)
    local imagetype= imagetype
    local imageurl=imageurl
    if  tonumber(imagetype)~=2 then
        imageurl="https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=190291064,674331088&fm=58"  
    end
    http_request_interface.getimage(imageurl,tx.width,tx.height,function (states,tex)tx.mainTexture=tex end)
end
