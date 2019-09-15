local base = require "logic/framework/ui/uibase/ui_view_base"
local ClubRoomView = class("ClubRoomView", base)
local ClubRoomItem = require("logic/club_sys/View/new/ClubRoomItem")
local ui_wrap = require "logic/framework/ui/uibase/ui_wrap"

function ClubRoomView:InitView()
	self.model = ClubModel
	self.createBtnGo = child(self.transform,"Grid/createRoomBtn").gameObject
	addClickCallbackSelf(self.createBtnGo, self.OnCreateBtnClick, self)
	self.joinBtnGo = child(self.transform,"Grid/joinRoomBtn").gameObject
	addClickCallbackSelf(self.joinBtnGo, self.OnJoinBtnClick, self)
	self.autoOpenBtnGo = child(self.transform,"Grid/autoCreateRoomBtn").gameObject
	addClickCallbackSelf(self.autoOpenBtnGo,self.OnautoOpenBtnClick,self)
	self.Grid = child(self.transform,"Grid").gameObject
	self.cid = nil
	self.tipGo = child(self.transform,"tips").gameObject

	self.itemList = {}

	self.wrapTr = child(self.transform,"container/scrollview/ui_wrapcontent")
	self:InitItems()
	self.wrap = ui_wrap:create(self:GetGameObject("container"))
	self.wrap:InitUI(350)
	self.wrap.OnUpdateItemInfo = function(go, rindex, index)
			self:OnItemUpdate(go, index, rindex) 
		end
	self.wrap:InitWrap(0)
	
end

function ClubRoomView:InitItems()
	local itemGo = self:GetGameObject("container/scrollview/ui_wrapcontent/item")
	local item = ClubRoomItem:create(itemGo)
	self.itemList[1] = item
	item:SetCallback(self.OnItemClick, self)

	for i = 2, 5 do
		local go = newobject(itemGo)
		go.transform:SetParent(self.wrapTr, false)
		item = ClubRoomItem:create(go)
		self.itemList[i] = item
		item:SetActive(false)
		self.itemList[i]:SetCallback(self.OnItemClick, self)
	end
	-- coroutine.start(function()
	-- 		coroutine.wait(0.2)
	-- 		local grid = self:GetGameObject("container/scrollview/ui_wrapcontent")
	-- 		componentGet(grid,"UIGrid"):Reposition()
	-- 	end)
	self:Reposition()
end

function ClubRoomView:Reposition()
	coroutine.start(function()
			coroutine.wait(0.2)
			--self:GetGameObject("container/scrollview").transform.localPosition = Vector3.New(0, -100, 0)
			-- local grid = componentGet(self:GetGameObject("container/scrollview/ui_wrapcontent"),"UIGrid")
			-- if grid ~= nil then
			-- 	grid:Reposition()
			-- end
		end)
end

function ClubRoomView:RegistEvent()
	Notifier.regist(GameEvent.OnAllClubRoomListUpdate, self.UpdateDatas, self)
end

function ClubRoomView:RemoveEvent()
	Notifier.remove(GameEvent.OnAllClubRoomListUpdate, self.UpdateDatas, self)
end

function ClubRoomView:OnOpen()
	self.wrap:ResetPosition()
	self:Reposition()
end

function ClubRoomView:OnClose()
end



function ClubRoomView:OnCreateBtnClick()
	ui_sound_mgr.PlayButtonClick()
	UIManager:ShowUiForms("openroom_ui", nil, nil,nil)
end

function ClubRoomView:OnJoinBtnClick()
	ui_sound_mgr.PlayButtonClick()
	UI_Manager:Instance():ShowUiForms("joinRoom_ui",UiCloseType.UiCloseType_CloseNothing)
end

function ClubRoomView:OnautoOpenBtnClick()
	ui_sound_mgr.PlayButtonClick()
	UI_Manager:Instance():ShowUiForms("autoCreateRoom_ui",UiCloseType.UiCloseType_CloseNothing,nil,self.cid)
end

function ClubRoomView:SetInfo()
	-- self.model:ReqGetRoomList()
	self:UpdateDatas()
end

function ClubRoomView:InitAutoBtn()
	local clubInfo = self.model.currentClubInfo
	local useinfo = data_center.GetLoginUserInfo()
	if clubInfo == nil then return end
	self.cid = clubInfo.cid
	if clubInfo.uid == useinfo.uid then
		self.autoOpenBtnGo.gameObject:SetActive(true)
		self.Grid.transform.localPosition = Vector3(-281,-206,0)
	else
		self.autoOpenBtnGo.gameObject:SetActive(false)
		self.Grid.transform.localPosition = Vector3(-137,-206,0)
	end
	componentGet(self.Grid,"UIGrid"):Reposition()
end

function ClubRoomView:UpdateDatas()
	if not self.model:HasClub() then
		return
	end
	if self.model.currentClubInfo == nil then
		return
	end
	self.dataList = self.model:GetRoomListByCid()
	if self.dataList == nil then
		self.wrap:InitWrap(0)
	else
		self.wrap:InitWrap(#self.dataList)
	end

	if self.dataList == nil or #self.dataList == 0 then
		self.tipGo:SetActive(true)
	else
		self.tipGo:SetActive(false)
	end

	self:InitAutoBtn()
end



function ClubRoomView:OnItemUpdate(go, index, rindex)
	if self.itemList[index] ~= nil then
		self.itemList[index]:SetActive(true)
		self.itemList[index]:SetInfo(self.dataList[rindex])
	end
end


function ClubRoomView:OnItemClick(item)
	ui_sound_mgr.PlayButtonClick()
	-- local content = LanguageMgr.GetWord(10049, GameUtil.GetGameName(item.info.gid))
	-- content = content.."\n"..ShareStrUtil.GetRoomShareStr(item.info.gid, item.info, true)
	-- MessageBox.ShowYesNoBox(content,
	-- function()
	-- 	join_room_ctrl.JoinRoomByRno(item.info.rno)
	-- end)
	
	-- local title = LanguageMgr.GetWord(10049, GameUtil.GetGameName(item.info.gid))
	-- logError(GetTblData(item.info))
	-- local content, contentTbl = ShareStrUtil.GetRoomShareStr(item.info.gid, item.info, true)
	-- if contentTbl then
	-- 	local subTitle = string.format("付费方式: %s   ", string.gsub(contentTbl[1], "、", ""))
	-- 	contentTbl[1] = ""
	-- 	local contentStr = table.concat(contentTbl)
	-- 	contentTbl = {title,subTitle,contentStr}
	-- end
	-- MessageBox.ShowYesNoBox(contentTbl,
	-- function()
	-- 	join_room_ctrl.JoinRoomByRno(item.info.rno)
	-- end)
	
	--TER0327-label
	local title = "文字丢失"--LanguageMgr.GetWord(10230)
	local content, contentTbl = "文字丢失"--ShareStrUtil.GetRoomShareStr(item.info.gid,item.info,true)
	if contentTbl then
		local subTitle = "文字丢失"--LanguageMgr.GetWord(10049, GameUtil.GetGameName(item.info.gid), string.gsub(contentTbl[1], "、", ""))
		contentTbl[1] = ""
		local contentStr = "文字丢失"--LanguageMgr.GetWord(10231)..table.concat(contentTbl)
		contentTbl = {title,subTitle,contentStr}
	end
	MessageBox.ShowYesNoBox(contentTbl,function()
		join_room_ctrl.JoinRoomByRno(item.info.rno)
	end)
end

return ClubRoomView