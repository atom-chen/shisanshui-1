local base = require("logic.framework.ui.uibase.ui_window")
local ClubUI = class("ClubUI", base)
--local UIManager = UI_Manager:Instance() 
local addClickCallbackSelf = addClickCallbackSelf
local ClubListView = require("logic/club_sys/View/new/ClubListViewWithGrid")
local ClubInfoView = require("logic/club_sys/View/new/ClubInfoView")
local ClubMemberView = require("logic/club_sys/View/new/ClubMembersView")
local ClubRoomView = require("logic/club_sys/View/new/ClubRoomView")
local ClubInviteBtnsView = require("logic/club_sys/View/new/ClubInviteBtnsView")
local ClubNonView = require("logic/club_sys/View/new/ClubNonView")
local ClubManageView = require "logic/club_sys/View/new/ClubManageView"
require "logic/club_sys/ClubModel"

--ClubUI = ui_base.New()
local normalColor = Color(254 / 255, 234/ 255, 200 / 255)
local selectColor = Color(163 / 255, 88/ 255, 27 / 255)
local this

function ClubUI:OnInit()
	this = self
	self.model = ClubModel
	self.model:ctor()
	self.model:Init()
	self.closeBtnGo = child(self.gameObject, "Panel_Top/backBtn").gameObject
	addClickCallbackSelf(self.closeBtnGo, self.OnCloseBtnClick, self)

	self.bg1Go = child(self.gameObject, "Panel_Top/bg1").gameObject
	self.redGo = child(self.gameObject, "Panel_Middle/btns/redPoint").gameObject
	self.togglesList = {}
	self:InitToggles()

	self.shareBtnGo = child(self.gameObject, "Panel_Top/inviteBtn").gameObject
	addClickCallbackSelf(self.shareBtnGo, self.OnShareClick, self)

	--self.shareBtnGo:SetActive(not G_isAppleVerifyInvite)

	self.clubListView = ClubListView:create(child(self.gameObject, "Panel_Middle/clubListView"))

	self.currentToggleSp = nil
	self.curIndex = -1

	self.viewList = {}
	local roomView = ClubRoomView:create(child(self.gameObject, "Panel_Middle/clubRoomView"))
	self.viewList[1] = roomView
	local memberView = ClubMemberView:create(child(self.gameObject, "Panel_Middle/clubMemberView"))
	self.viewList[2] = memberView
	local infoView = ClubInfoView:create(child(self.gameObject, "Panel_Middle/clubInfoView"))
	self.viewList[3] = infoView
	local clubManageView = ClubManageView:create(child(self.gameObject, "Panel_Middle/clubManageView"))
	self.viewList[4] = clubManageView
	
	--代理商隐藏功能（个人俱乐部列表）
	if clubManageView.SetAgent and self.model then
		clubManageView:SetAgent(self.model:IsAgent())
	end
	
	self.clubInviteBtnsView = ClubInviteBtnsView:create(child(self.gameObject, "Panel_Middle/invitePanel"))
	
	self.Panel_Middle = child(self.gameObject,"Panel_Middle").gameObject
	self.nonClubView = ClubNonView:create(child(self.gameObject, "Panel_NonClub"))
	self.nonClubView:SetActive(false)
	
	
	self.createBtnGo = child(self.gameObject, "Panel_Bottom/createBtn").gameObject
	addClickCallbackSelf(self.createBtnGo, self.OnClubCreateClick, self)
	self.joinBtnGo = child(self.gameObject, "Panel_Bottom/joinBtn").gameObject
	addClickCallbackSelf(self.joinBtnGo, self.OnClubJoinClick, self)
end

function ClubUI:InitToggles()
	for i = 1, 4 do
		local go = child(self.gameObject, "Panel_Middle/btns/toggle".. i).gameObject
		local sp = subComponentGet(self.transform, "Panel_Middle/btns/toggle" .. i, typeof(UISprite))
		local lbl = subComponentGet(self.transform, "Panel_Middle/btns/toggle" .. i .. "/Label", typeof(UILabel))
		local index = i
		addClickCallbackSelf(go, function() self:OnToggleClick(index) end, self)
		self.togglesList[i] = {sp, lbl}
	end
end


function ClubUI:OnShareClick()
	-- self.clubInviteBtnsView:Show(self.model.currentClubInfo)
	invite_sys.inviteToClub(self.model.currentClubInfo)
end

function ClubUI:OnOpen()	
	-- if self.gameObject==nil then
	-- 	require ("logic/club_sys/Window/ClubUI")
	-- 	self.gameObject=newNormalUI("Prefabs/UI/club_ui/club_ui")
	-- else
	-- 	self.gameObject:SetActive(true)
	-- end
	-- self.transform = self.gameObject.transform
	-- self:OnInit()
	self:RegistEvent()
	self:isShowNonClubView(function()
		self.clubListView:UpdateList(true)
		self:UpdateCurClub()
		self:SetToggle(1, true)
	end)
end

function ClubUI:isShowNonClubView(callback)
	if isEmpty(self.model.unofficalClubList) then
		self.Panel_Middle.gameObject:SetActive(false)
		self.nonClubView:SetActive(true)
		self.shareBtnGo:SetActive(false)
	else
		self.Panel_Middle.gameObject:SetActive(true)
		self.nonClubView:SetActive(false)
		self.shareBtnGo:SetActive(true and not G_isAppleVerifyInvite)
		if callback then
			callback()
		end
	end
end

function ClubUI:OnClose()
	self:RemoveEvent()
	self:CallViewsFunc("OnClose")
end

function ClubUI:RegistEvent()
	Notifier.regist(GameEvent.OnCurrentClubChange, self.OnCurClubChange, self)
	Notifier.regist(GameEvent.OnSelfClubNumUpdate, self.OnClubListNumUpdate, self)
	Notifier.regist(GameEvent.OnPlayerApplyClubChange, self.RefreshApplyAndRed, self)
	Notifier.regist(GameEvent.OnClubInfoUpdate, self.UpdateCurClub, self)
	self:CallViewsFunc("RegistEvent")
end

function ClubUI:RemoveEvent()
	Notifier.remove(GameEvent.OnCurrentClubChange, self.OnCurClubChange, self)
	Notifier.remove(GameEvent.OnSelfClubNumUpdate, self.OnClubListNumUpdate, self)
	Notifier.remove(GameEvent.OnPlayerApplyClubChange, self.RefreshApplyAndRed, self)
	Notifier.remove(GameEvent.OnClubInfoUpdate, self.UpdateCurClub, self)
	self:CallViewsFunc("RemoveEvent")
end

function ClubUI:RefreshClubList()
	self.clubListView:UpdateList()
end

function ClubUI:OnClubListNumUpdate()
	self:isShowNonClubView(function() self:SetToggle(1, true) end)
	self.clubListView:UpdateList(true)
	self.clubList = self.model.unofficalClubList
	if not self.clubList or #self.clubList == 0 then
		self.bg1Go:SetActive(false)
	end
end	

function ClubUI.OnCurClubChange()
	self = this
	--log(GetTblData(self))
	self:UpdateCurClub()
	-- 切换俱乐部 刷新
	if self.viewList[self.curIndex] ~= nil then
		self.viewList[self.curIndex]:OnOpen()
	end
end

function ClubUI:UpdateCurClub()
	log("ClubUI:UpdateCurClub")
	local clubInfo = self.model.currentClubInfo
	if clubInfo == nil then
		UIManager:CloseUiForms("ClubUI")
		return
	end
	self:CallViewsFunc("SetInfo", clubInfo)
	self:RefreshApplyAndRed()
	self:RefreshMemberToggle()
	self:RefreshManagerBtn()
end

function ClubUI:RefreshApplyAndRed()
	local clubInfo = self.model.currentClubInfo
	if clubInfo == nil then
		UIManager:CloseUiForms("ClubUI")
		return
	end
	local canSeeApply = self.model:CheckCanSeeApplyList(clubInfo.cid)
	if canSeeApply and clubInfo.applyNum ~= nil and clubInfo.applyNum > 0 then
		self.redGo:SetActive(true)
	else
		self.redGo:SetActive(false)
	end
	self:RefreshClubList()
end

function ClubUI:RefreshMemberToggle()
	local clubInfo = self.model.currentClubInfo 
	if clubInfo.ctype == 1 then
		self.togglesList[2][1].gameObject:SetActive(false)
		self.togglesList[3][1].transform.localPosition = Vector3(61, 0,0)
		if self.curIndex == 2 then
			self:SetToggle(1)
		end
	else
		self.togglesList[2][1].gameObject:SetActive(true)
		self.togglesList[3][1].transform.localPosition = Vector3(217, 0,0)
	end
end



function ClubUI:RefreshManagerBtn()
	local clubInfo = self.model.currentClubInfo
	local isCreater = self.model:IsClubCreater(clubInfo.cid)
	self.togglesList[4][1].gameObject:SetActive(isCreater)
	if not isCreater and self.curIndex == 4 then
		self:SetToggle(1)
	end
end


function ClubUI:CallViewsFunc(funcName, param)
	for i = 1, #self.viewList do
		if self.viewList[i] ~= nil and self.viewList[i][funcName] ~= nil then
			if param == nil then
				self.viewList[i][funcName](self.viewList[i])
			else
				self.viewList[i][funcName](self.viewList[i], param)
			end
		end
	end
end



function ClubUI:OnCloseBtnClick()
	ui_sound_mgr.PlayCloseClick()
	UIManager:CloseUiForms("ClubUI")
	--UI_Manager:Instance():ShowUiForms("hall_ui",UiCloseType.UiCloseType_CloseOther)
end

function ClubUI:PlayOpenAmination()

end


function ClubUI:OnToggleClick(index)
	ui_sound_mgr.PlayButtonClick()
	self:SetToggle(index)
end

function ClubUI:SetToggle(index, force)
	if index == self.curIndex and not force then
		return
	end

	self.curIndex = index
	if self.currentToggleSp ~= nil then
		self.currentToggleSp[1].spriteName = "button_25"
--		self.currentToggleSp[2].myFormat = UILabelFormat.F42
--		self.currentToggleSp[2]:resetMyFormatData(true)
	end
	self.currentToggleSp = self.togglesList[index]
	self.currentToggleSp[1].spriteName = "button_26"
--	self.currentToggleSp[2].myFormat = UILabelFormat.F53

	--self.currentToggleSp[2]:resetMyFormatData(true)

	if self.viewList[index] == nil then
		return
	end
	for i = 1, #self.viewList do
		if self.viewList[i] ~= nil then
			if i == index then
				self.viewList[i]:SetActive(true)
				self.viewList[i]:OnOpen()
			else
				self.viewList[i]:SetActive(false)
			end
		end
	end

	self.bg1Go:SetActive( index ~= 4)
end

-- function ClubUI:

function ClubUI:OnRefreshDepth()
  local uiEffect = child(self.gameObject.transform, "Panel_Top/bg/top/tittle/Effect_youxifenxiang")
  if uiEffect and self.sortingOrder then
    local topLayerIndex = self.sortingOrder +self.m_subPanelCount +1
--    Utils.SetEffectSortLayer(uiEffect.gameObject, topLayerIndex)
  end
end



function ClubUI:OnClubCreateClick()
    ui_sound_mgr.PlaySoundClip("common/audio_button_click")
	--ui_sound_mgr.PlayButtonClick()
	--UI_Manager:Instance():ShowUiForms("ClubCreateUI")
	--if self.model:IsAgent() or G_isAppleVerifyInvite  then
	-- if self.model:IsAgent() then
	-- 	UI_Manager:Instance():ShowUiForms("ClubCreateUI")
	-- else
	-- 	UIManager:ShowUiForms("ClubInputUI", nil, nil, ClubInputUIEnum.InputCode)
	-- end
		UI_Manager:Instance():ShowUiForms("ClubCreateUI")
end

function ClubUI:OnClubJoinClick()
	--ui_sound_mgr.PlayButtonClick()
    ui_sound_mgr.PlaySoundClip("common/audio_button_click")
	UI_Manager:Instance():ShowUiForms("join_ui_new")
end


return ClubUI