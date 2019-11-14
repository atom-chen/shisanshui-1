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
	-- self.autoOpenBtnGo = child(self.transform,"Grid/autoCreateRoomBtn").gameObject
	-- addClickCallbackSelf(self.autoOpenBtnGo,self.OnautoOpenBtnClick,self)
	self.Grid = child(self.transform,"Grid").gameObject
	self.cid = nil
	self.tipGo = child(self.transform,"tips").gameObject

	self.itemList = {}

	self.wrapTr = child(self.transform,"container/scrollview/ui_wrapcontent")
	self:InitItems()
	self.wrap = ui_wrap:create(self:GetGameObject("container"))
	self.wrap:InitUI(585)
	self.wrap.OnUpdateItemInfo = function(go, rindex, index)
			self:OnItemUpdate(go, index, rindex) 
		end
	self.wrap:InitWrap(0, 2, 350, true)
	
end

function ClubRoomView:InitItems()
	local itemGo = self:GetGameObject("container/scrollview/ui_wrapcontent/item")
	local item = ClubRoomItem:create(itemGo)
	self.itemList[1] = item
	item:SetCallback(function(item)
		local title = "加入房间"--LanguageMgr.GetWord(10230)
		local content, contentTbl = "是否确定加入房间"--ShareStrUtil.GetRoomShareStr(item.info.gid,item.info,true)
		log(item)
		MessageBox.ShowYesNoBox("是否确定加入俱乐部房间",function()
			join_room_ctrl.JoinRoomByRno(item.rno)
		end)
	end, self)

	for i = 2, 10 do
		local go = newobject(itemGo)
		go.transform:SetParent(self.wrapTr, false)
		item = ClubRoomItem:create(go)
		self.itemList[i] = item
		item:SetActive(false)
		self.itemList[i]:SetCallback(function(item)
				local title = "加入房间"--LanguageMgr.GetWord(10230)
				local content, contentTbl = "是否确定加入房间"--ShareStrUtil.GetRoomShareStr(item.info.gid,item.info,true)
				log(item)
				MessageBox.ShowYesNoBox("是否确定加入俱乐部房间",function()
					join_room_ctrl.JoinRoomByRno(item.rno)
				end)
			end, self)
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
	--UIManager:ShowUiForms("openroom_ui", nil, nil,nil)

	local msg = {}
	local str = "经典"
	room_data.GetSssRoomDataInfo().people_num = tonumber(PlayerPrefs.GetString("pnum", "6"))
	str = str..room_data.GetSssRoomDataInfo().people_num.."人；"
	room_data.GetSssRoomDataInfo().play_num = tonumber(PlayerPrefs.GetString("rounds", "10"))
	str = str..room_data.GetSssRoomDataInfo().play_num.."局；"
	room_data.GetSssRoomDataInfo().nChooseCardTypeTimeOut = tonumber(PlayerPrefs.GetString("nChooseCardTypeTimeOut", "30"))
	str = str..room_data.GetSssRoomDataInfo().nChooseCardTypeTimeOut.."秒摆牌；"
	room_data.GetSssRoomDataInfo().nReadyTimeOut = tonumber(PlayerPrefs.GetString("nReadyTimeOut", "5"))
	str = str..room_data.GetSssRoomDataInfo().nReadyTimeOut.."秒准备；"
	room_data.GetSssRoomDataInfo().add_ghost = tonumber(PlayerPrefs.GetString("joker", "0"))
	if room_data.GetSssRoomDataInfo().add_ghost == 0 then
		str = str.."无大小王；"
	elseif room_data.GetSssRoomDataInfo().add_ghost == 1 then
		str = str.."双王；"
	else

	end
	room_data.GetSssRoomDataInfo().costtype = tonumber(PlayerPrefs.GetString("costtype", "1"))
	if room_data.GetSssRoomDataInfo().costtype == 0 then
		str = str.."房主支付；"
	else
		str = str.."AA支付；"
	end
	room_data.GetSssRoomDataInfo().nBuyCode = tonumber(PlayerPrefs.GetString("buyhorse", "0"))
	if room_data.GetSssRoomDataInfo().nBuyCode == 0 then
		str = str.."没马牌；"
	elseif room_data.GetSssRoomDataInfo().nBuyCode == 5 then
		str = str.."马牌方块5"
	elseif room_data.GetSssRoomDataInfo().nBuyCode == 10 then
		str = str.."马牌方块10"
	elseif room_data.GetSssRoomDataInfo().nBuyCode == 14 then
		str = str.."马牌方块A"
	end

	msg.content = str
	PreRoom.Show(msg)
end

function ClubRoomView:OnJoinBtnClick()
	-- ui_sound_mgr.PlayButtonClick()
	--self.OnItemClick()
	--UI_Manager:Instance():ShowUiForms("joinRoom_ui",UiCloseType.UiCloseType_CloseNothing)
	ClubModel:QuickEnter(self.model.currentClubInfo.cid, function(msgtab )
		if msgtab.ret == 0 then
			MessageBox.ShowYesNoBox("是否确定加入俱乐部房间",function()
				join_room_ctrl.JoinRoomByRno(msgtab.roomRno)
			end)
		else
			fast_tip.Show("没有合适的房间，请自己创建房间")
		end
	end)
	-- for i = 1, #self.dataList do
	-- 	if self.dataList[i] ~= nil then
	-- 		local item = {}
	-- 		item.info = self.dataList[i]
	-- 		self:OnItemClick(item)
	-- 		return
	-- 	end
	-- end
	-- fast_tip.Show("没有合适的房间，请自己创建房间")
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
	-- if clubInfo.uid == useinfo.uid then
	-- 	self.autoOpenBtnGo.gameObject:SetActive(true)
	-- 	self.Grid.transform.localPosition = Vector3(-281,-206,0)
	-- else
	-- 	self.autoOpenBtnGo.gameObject:SetActive(false)
	-- 	self.Grid.transform.localPosition = Vector3(-137,-206,0)
	-- end
	--componentGet(self.Grid,"UIGrid"):Reposition()
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
		self.wrap:InitWrap(0, 2, 350, true)
	else
		self.wrap:InitWrap(self:GetRoomsNum(#self.dataList),2, 350, true)
	end

	-- if self.dataList == nil or #self.dataList == 0 then
	-- 	self.tipGo:SetActive(true)
	-- else
	-- 	self.tipGo:SetActive(false)
	-- end

	self:InitAutoBtn()
end

function ClubRoomView:GetRoomsNum(num)
	-- if num < 6 then
	-- 	return 6
	-- else
		return num
	--end
end

function ClubRoomView:OnItemUpdate(go, index, rindex)
	if self.itemList[index] ~= nil then
		self.itemList[index]:SetActive(true)
		if rindex > #self.dataList then
			self.itemList[index]:SetInfo(nil)
		else
			self.itemList[index]:SetInfo(self.dataList[rindex])
		end
	end
end


function ClubRoomView:OnItemClick(item)
	log("加入房间")
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
	local title = "加入房间"--LanguageMgr.GetWord(10230)
	local content, contentTbl = "是否确定加入房间"--ShareStrUtil.GetRoomShareStr(item.info.gid,item.info,true)
	-- if contentTbl then
	-- 	local subTitle = "文字丢失"--LanguageMgr.GetWord(10049, GameUtil.GetGameName(item.info.gid), string.gsub(contentTbl[1], "、", ""))
	-- 	contentTbl[1] = ""
	-- 	local contentStr = "文字丢失"--LanguageMgr.GetWord(10231)..table.concat(contentTbl)
	-- 	contentTbl = {title,subTitle,contentStr}
	-- end
	log(item)
	MessageBox.ShowYesNoBox("是否确定加入俱乐部房间",function()
		join_room_ctrl.JoinRoomByRno(item.info.rno)
	end)
end

return ClubRoomView