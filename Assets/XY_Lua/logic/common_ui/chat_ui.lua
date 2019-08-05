--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion
chat_ui=ui_base.New()
local this=chat_ui

function this.Show() 
	if  IsNil(this.gameObject) then
		require ("logic/common_ui/chat_ui") 
		this.gameObject=newNormalUI("Prefabs/UI/Common/chatPanel")
	else
		this.gameObject:SetActive(true) 
	end
    this.addlistener() 
end


function this.addlistener() 
    this.SetChatTextInfo()
    this.SetChatImgInfo()
    local bg =child(this.transform,"panel/bg/Sprite")
    print(bg.name)
    if bg~=nil then
        addClickCallbackSelf(bg.gameObject,this.Hide,this)
    end
end


local chatTextTab = {"别墨迹，赶紧的。","弄啥嘞，快点出牌中不中？","咋就恁爱碰啊？","哎，这牌不上张啊。","得了，我的牌真臭！","幺嗬，这牌怪带劲啊！","可以呀，你这牌不赖啊。","去球，今儿个点真背！","铁刀来了！"}
function this.SetChatTextInfo()
	for i=1,table.getCount(chatTextTab),1 do       
       local good = child(this.transform,"panel/ScrollView/grid_text/item"..tostring(i))     
	   if good==nil then 
		    local o_good = child(this.transform,"panel/ScrollView/grid_text/item"..tostring(i-1)) 
		    good = GameObject.Instantiate(o_good.gameObject)
		    good.transform.parent=o_good.transform.parent 
            good.name="item"..tostring(i)
            good.transform.localScale={x=1,y=1,z=1}    
            local grid=child(this.transform,"panel/ScrollView/grid_text")
            componentGet(grid,"UIGrid"):Reposition()  
	   end  
	   addClickCallbackSelf(good.gameObject,this.Onbtn_chatTextClick,this)    
	   good.gameObject:SetActive(true)
	   local lab_msg=child(good.transform,"msg") 
	   componentGet(lab_msg,"UILabel").text=chatTextTab[i]		
    end 
end

local chatImgTab = {"1","2","3","4","5","6","7","8","9","10","11","12"}
function this.SetChatImgInfo()
	for i=1,table.getCount(chatImgTab),1 do       
       local good = child(this.transform,"panel/ScrollView/grid_img/item"..tostring(i))     
	   if good==nil then 
		    local o_good = child(this.transform,"panel/ScrollView/grid_img/item"..tostring(i-1)) 
		    good = GameObject.Instantiate(o_good.gameObject)
		    good.transform.parent=o_good.transform.parent 
            good.name="item"..tostring(i)
            good.transform.localScale={x=1,y=1,z=1}    
            local grid=child(this.transform,"panel/ScrollView/grid_img")
            componentGet(grid,"UIGrid"):Reposition()   
	   end    
	   addClickCallbackSelf(good.gameObject,this.Onbtn_chatImgClick,this)  
	   good.gameObject:SetActive(true)
	   local sprite_msg=child(good.transform,"img") 
       componentGet(sprite_msg,"UISprite").spriteName=chatImgTab[i]
    end 
end

--[[
tIndex--聊天选项对应ID
chatTextTab---聊天选项table
]]--

function this.Onbtn_chatTextClick(self, obj)
	local tItemName = obj.gameObject.name
	tItemName = string.sub(tItemName,string.len("item")+1)
	local tIndex = tonumber(tItemName)
	print(chatTextTab[tIndex])
	--mahjong_play_sys.ChatReq(1,chatTextTab[tIndex],nil)
end

function this.Onbtn_chatImgClick(self, obj)
	local tItemName = obj.gameObject.name
	tItemName = string.sub(tItemName,string.len("item")+1)
	local tIndex = tonumber(tItemName)
	print("Image name:"..chatImgTab[tIndex])
	--mahjong_play_sys.ChatReq(2,chatImgTab[tIndex],nil)
end

--[[
消息接收

]]--
function this.DealChat(viewSeat,contentType,content,givewho)

	if contentType == 1 then
		--文字聊天 
		this.playerList[viewSeat].SetChatText(content)
		this.Hide()
	elseif contentType ==2 then
		--表情聊天
		--fast_tip.Show("Image name:"..content)
		this.playerList[viewSeat].SetChatImg(content)
		this.Hide()
	elseif contentType == 3 then
		--语音聊天
	elseif contentType == 4 then
		--玩家互动
		this.playerList[givewho].ShowInteractinAnimation(viewSeat,content)	
	end
end

function this.Hide()
    if not IsNil(this.gameObject) then
        GameObject.Destroy(this.gameObject)
        this.gameObject=nil
    end
end