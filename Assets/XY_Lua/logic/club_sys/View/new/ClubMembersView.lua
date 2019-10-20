local base = require "logic/framework/ui/uibase/ui_view_base"
local ClubMembersView = class("ClubMembersView", base)
local ui_wrap = require "logic/framework/ui/uibase/ui_wrap"
local ButtonInfo = require("logic/club_sys/Data/ButtonInfo")
local ClubMemberItem = require("logic/club_sys/View/new/ClubMemberItem")
local ClubApplyUINew = require "logic/club_sys/Window/ClubApplyUINew"
--local UIManager = UI_Manager:Instance() 


function ClubMembersView:InitView()
	self.model = ClubModel
	self.itemList = {}
	self.info = nil
	self:InitItem()
	self.btnsView = require ("logic/club_sys/View/ClubBtnsView"):create(self:GetGameObject("container/btnsPanel"))
	self.panel = subComponentGet(self.transform,"container/scrollview",typeof(UIPanel))
	self.membernum = child(self.gameObject,"panel_bottom/bottom/num").gameObject--人数
	self.bottom = child(self.gameObject,"panel_bottom").gameObject
	self.redGo = child(self.gameObject,"panel_bottom/bottom/redPoint").gameObject
	self.redNumLabel = subComponentGet(self.transform,"panel_bottom/bottom/redPoint/Label", typeof(UILabel))

	self.applyView = ClubApplyUINew:create(child(self.gameObject.transform.parent, "club_apply_ui"))
--	self.btnsView:SetLimit(-208, 600, 330, -330)
	self.btnsView:SetActive(false)
	self.wrap = ui_wrap:create(self:GetGameObject("container"))
	self.wrap:InitUI(160)
	self.wrap.OnUpdateItemInfo = function(go, rindex, index)  self:OnItemUpdate(go, index, rindex)  end
	self.wrap:InitWrap(0)
	self:InitApplyBtn()
end


function ClubMembersView:InitApplyBtn()
	self.applyBtn =self:GetGameObject("panel_bottom/bottom/applyBtn")
	addClickCallbackSelf(self.applyBtn, self.OnApplyBtnClick, self)
end

function ClubMembersView:OnApplyBtnClick()
	ui_sound_mgr.PlayButtonClick()
	if isClicked == true then
		--UIManager:CloseUiForms("ClubApplyUI")
		UI_Manager:Instance():FastTip("语言丢失")--LanguageMgr.GetWord(10100))
		return
    else
		isClicked = true
		Timer.New(function() isClicked = false end,1,1):Start()
    end
	
	--ui_sound_mgr.PlayButtonClick()
	--ui_sound_mgr.PlaySoundClip(data_center.GetAppConfDataTble().appPath.."/sound/common/audio_button_click")
	--数据上报
	report_sys.EventUpload(1)
	self.applyView:SetActive(true)
	self.applyView:OnOpen(self.cid)
	--UI_Manager:Instance():ShowUiForms("ClubApplyUI",UiCloseType.UiCloseType_CloseNothing,nil,self.cid)
end

function ClubMembersView:RefreshApplyAndRed()
	local clubInfo = self.model.currentClubInfo
	local canSeeApply = self.model:CheckCanSeeApplyList(clubInfo.cid)
	log("刷新申请按扭红点")
	if canSeeApply and clubInfo.applyNum ~= nil and clubInfo.applyNum > 0 then
		self.redGo:SetActive(true)
		log("显示申请按扭红点")
		self.redNumLabel.text = clubInfo.applyNum
	else
		self.redGo:SetActive(false)
	end	
end


function ClubMembersView:RegistEvent()
	Notifier.regist(GameEvent.OnClubMemberUpdate, self.UpdateView, self)
	Notifier.regist(GameEvent.OnClubInfoUpdate, self.OnClubInfoUpdate, self)
	Notifier.regist(GameEvent.OnPlayerApplyClubChange, self.RefreshApplyAndRed, self)

end

function ClubMembersView:RemoveEvent()
	Notifier.remove(GameEvent.OnClubMemberUpdate, self.UpdateView, self)
	Notifier.remove(GameEvent.OnClubInfoUpdate, self.OnClubInfoUpdate, self)
	Notifier.regist(GameEvent.OnPlayerApplyClubChange, self.RefreshApplyAndRed, self)

end

function ClubMembersView:OnClose()
	self:RemoveEvent()
end


function ClubMembersView:OnOpen()
	--if self.isNeedReq then
	self:RegistEvent()
	self.model:ReqGetClubUser(self.cid)
	--	self.isNeedReq = false
	--end
end

function ClubMembersView:InitItem()
	local go_pre = self:GetGameObject("container/scrollview/ui_wrapcontent/item")
	local parent = self:GetGameObject("container/scrollview/ui_wrapcontent")
	if go_pre == nil or parent == nil then
		return
	end
	for i = 1, 5 do
		local go
		if i == 1 then
			go = go_pre
		else
			go = newobject(go_pre)
			go.transform:SetParent(parent.transform,false)
		end
		local item = ClubMemberItem:create(go)
		item:SetCallback(self.OnItemClick, self.tickClick, self)
		item:SetActive(false)
		table.insert(self.itemList, item)
	end
end

function ClubMembersView:SetInfo(clubInfo)
	self.isNeedReq = true
	self.clubInfo = clubInfo
	self.cid = clubInfo.cid


	-- self:UpdateView()
end

function ClubMembersView:CallUpdateView()
	local time = FrameTimer.New(
		function() 
			self:UpdateView()
		end,1,1)
	time:Start()
end

function ClubMembersView:OnClubInfoUpdate()
	self:CallUpdateView()
end

function ClubMembersView:UpdateView()
	self.memberList = self.model:GetMemberListByType(ClubMemberEnum.member)
	local count = 0
	if self.memberList ~= nil then
		count = #self.memberList 
	end
	self.wrap:InitWrap(count)
	if self.clubInfo == nil or #self.clubInfo == 0 then
		return
	end
	--是否在成员列表中显示申请列表按钮
	if self.model:CheckCanSeeApplyList(self.cid) and (self.model:CheckIsClubCreater(self.cid,self.model.selfPlayerId) or self.clubInfo.cfg.mcactuser == 1 ) then--会长或管理员
		self.bottom.gameObject:SetActive(true)
--		self.panel:SetRect(0,45,804,362)
		self.applyBtn.gameObject:SetActive(true)
		self:RefreshApplyAndRed()

	else

		self.bottom.gameObject:SetActive(false)
--		self.panel:SetRect(0,3,804,446)
	end
	--更新俱乐部人数
	componentGet(self.membernum,"UILabel").text = tostring(count).."/"..tostring(self.clubInfo.maxusernum)

end


function ClubMembersView:OnItemUpdate(go, index, rindex)
	if self.itemList[index] ~= nil then
		self.itemList[index]:SetInfo(self.memberList[rindex])
	end
end


function ClubMembersView:OnItemClick(item)
	-- local info = item.info
	-- self.info = info
	-- -- 非管理员
	-- if not self.model:CheckCanSeeApplyList(self.cid) then
	-- 	self:PlayerInfoAction(info)
	-- 	return
	-- end
	-- local buttonInfoTab = {}

	-- if self.model:IsClubCreater(self.cid) then
	-- 	buttonInfoTab = self:GetCreaterBtnInfos(info)
	-- else
	-- 	buttonInfoTab = self:GetManagerBtnInfo(info)
	-- end
	-- self.btnsView:Show(buttonInfoTab)
end

function ClubMembersView:tickClick(item)
	local info = item.info
	self.info = info
	-- 非管理员
	message_box.ShowGoldBox("是否确定踢出成员", nil, 2, {function ()
            message_box:Close()
			self.model:ReqKickClubUser(self.cid,self.info.uid,4)
        end, function ()
            message_box:Close()
        end}, {"fonts_02", "fonts_01"})
	--self:QuitClubAction(info)
end


-- 代理商按钮列表
function ClubMembersView:GetCreaterBtnInfos(info)
	local tab = {}
	tab[1] = self:GetPlayerBtnInfo(info)
	if info.uid == self.model.selfPlayerId then 
		return tab
	end
	local btnInfo = nil
	if self.model:IsClubManager(self.cid, info.uid) then
		btnInfo = self:GetRemoveManagerBtnInfo(info)
	else
		btnInfo = self:GetSetManagerBtnInfo(info)
	end
	table.insert(tab, 1, btnInfo)

	btnInfo = self:GetQuitClubBtnInfo(info)
	table.insert(tab, 1, btnInfo)

	btnInfo = self:GetTransferClubBtnInfo(info)
	table.insert(tab, 1, btnInfo)
	return tab
end

function ClubMembersView:GetManagerBtnInfo(info)
	local tab = {}
	tab[1] = self:GetPlayerBtnInfo(info)
	if self.model:CheckCanSeeApplyList(self.cid, info.uid) and not self.model:IsClubManager(self.cid, info.uid) then
		table.insert(tab, 1,self:GetQuitClubBtnInfo(info))
	end
	return tab
end

function ClubMembersView:GetPlayerBtnInfo(info)
	if self.playerBtnInfo == nil then
		self.playerBtnInfo = ButtonInfo:create()
		self.playerBtnInfo.text = "查看"
		self.playerBtnInfo.bgSp = "button_03"
		self.playerBtnInfo.callback = self.PlayerInfoAction
		self.playerBtnInfo.target = self
	end
	self.playerBtnInfo.data = info
	return self.playerBtnInfo
end

function ClubMembersView:GetSetManagerBtnInfo(info)
	if self.setManagerBtnInfo == nil then
		self.setManagerBtnInfo = ButtonInfo:create()
		self.setManagerBtnInfo.text = "设为管理员"
		self.setManagerBtnInfo.bgSp = "button_03"
		self.setManagerBtnInfo.callback = self.SetManagerAction
		self.setManagerBtnInfo.target = self
	end
	self.setManagerBtnInfo.data = info
	return self.setManagerBtnInfo
end

function ClubMembersView:GetRemoveManagerBtnInfo(info)
	if self.removeManagerBtnInfo == nil then
		self.removeManagerBtnInfo = ButtonInfo:create()
		self.removeManagerBtnInfo.text = "取消管理员"
		self.removeManagerBtnInfo.bgSp = "button_05"
		self.removeManagerBtnInfo.callback = self.RemoveManagerAction
		self.removeManagerBtnInfo.target = self
	end
	self.removeManagerBtnInfo.data = info
	return self.removeManagerBtnInfo
end

function ClubMembersView:GetQuitClubBtnInfo(info)
	if self.quitClubBtnInfo == nil then
		self.quitClubBtnInfo = ButtonInfo:create()
		self.quitClubBtnInfo.text = "踢出俱乐部"
		self.quitClubBtnInfo.bgSp = "button_05"
		self.quitClubBtnInfo.callback = self.QuitClubAction
		self.quitClubBtnInfo.target = self
	end
	self.quitClubBtnInfo.data = info
	return self.quitClubBtnInfo
end

--转让俱乐部按钮
function ClubMembersView:GetTransferClubBtnInfo(info)
	if self.transferClubBtnInfo == nil then
		self.transferClubBtnInfo = ButtonInfo:create()
		self.transferClubBtnInfo.text = "转让给他"
		self.transferClubBtnInfo.bgSp = "button_05"
		self.transferClubBtnInfo.callback = self.TransferClubAction
		self.transferClubBtnInfo.target = self
	end
	self.transferClubBtnInfo.data = info
	return self.transferClubBtnInfo
end

function ClubMembersView:PlayerInfoAction(info)
	ui_sound_mgr.PlayButtonClick()
	UIManager:ShowUiForms("personInfo_ui", nil, nil, info.uid)
end

function ClubMembersView:SetManagerAction(info)
	ui_sound_mgr.PlayButtonClick()
	local msgBox = MessageBox.ShowYesNoBox("文字丢失",--LanguageMgr.GetWord(10046, info.nickname),
	function()
		self.model:ReqSetManager(self.cid, info.uid, 0)
	end)
	if msgBox and msgBox.EnableContentBBCode then
		msgBox:EnableContentBBCode()
	end
end

function ClubMembersView:RemoveManagerAction(info)
	ui_sound_mgr.PlayButtonClick()
	local msgBox = MessageBox.ShowYesNoBox(LanguageMgr.GetWord(10047, info.nickname),
	function()
		self.model:ReqSetManager(self.cid, info.uid, 1)
	end)
	if msgBox and msgBox.EnableContentBBCode then
		msgBox:EnableContentBBCode()
	end
end

function ClubMembersView:QuitClubAction(info)
	ui_sound_mgr.PlayButtonClick()
	if info == nil then
		return
	end
	UIManager:ShowUiForms("ClubKickUI",nil,nil,self.cid,info)
	--[[MessageBox.ShowYesNoBox(LanguageMgr.GetWord(10048, info.nickname),
	function()
		self.model:ReqKickClubUser(self.cid, info.uid)
	end)--]]
end

--转让俱乐部Action
function ClubMembersView:TransferClubAction(info)
	ui_sound_mgr.PlayButtonClick()
	if info == nil then
		return
	end

	--俱乐部是否可转让查询结果回调函数
	local function checkCallBack(ret)
		if ret == true then --可转让
			MessageBox.ShowYesNoBox(LanguageMgr.GetWord(10303),
					function()
						self.model:ReqTransferClub(self.clubInfo.cid, self.clubInfo.cname, info.uid, info.nickname)
					end)
		else --不可转让
			MessageBox.ShowSingleBox(LanguageMgr.GetWord(10307))
		end
	end

	--查询俱乐部是否可转让
	self.model:ReqCheckTransferClub(self.clubInfo.cid, info.uid, checkCallBack)
end

return ClubMembersView