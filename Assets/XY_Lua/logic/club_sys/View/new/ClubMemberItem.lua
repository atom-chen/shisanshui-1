local base = require "logic/framework/ui/uibase/ui_view_base"
local ClubMemberItem = class("ClubMemberItem", base)
local ClubMemberEnum = ClubMemberEnum


function ClubMemberItem:InitView()
	-- self.type = ClubMemberEnum.member
	self.headIcon = self:GetComponent("headIcon", typeof(UITexture))
	self.nameLabel = self:GetComponent("name", typeof(UILabel))
	self.IDLabel = self:GetComponent("Id", typeof(UILabel))
	self.timeLabel = self:GetComponent("time", typeof(UILabel))
	
	self.tipBtn = self:GetGameObject("tipBtn")

	self.lastEnterLabel = self:GetComponent("lastEnterTimer", typeof(UILabel))
	-- self.lastLineGo = self:GetGameObject("lines/line3")

	self.bgSp = self:GetComponent("", typeof(UISprite))

	self.sureBtnGo = self:GetGameObject("sureBtn")
	self.refuseBtnGo = self:GetGameObject("refuseBtn")

	self.iconSp = child(self.transform,"icon").gameObject

	self.tickBtn = self:GetGameObject("tickBtn")

	if self.sureBtnGo and self.refuseBtnGo then
	 	addClickCallbackSelf(self.sureBtnGo, self.OnSureClick, self)
	 	addClickCallbackSelf(self.refuseBtnGo, self.OnRefuseClick, self)
	end
	if self.tickBtn then
		addClickCallbackSelf(self.tickBtn, self.tickClick, self)
	end
	addClickCallbackSelf(self.gameObject, self.OnClick, self)

	-- self:UpdateType()
end

function ClubMemberItem:SetInfo(info, callback, target)
	self.info = info
	-- self.type = type
	self.model = ClubModel

	-- self:UpdateType()
	-- 刷数据
	self:UpdateView()
end

function ClubMemberItem:SetTipBtnCallback(isMisdeed,callback)
	local isMisdeed = isMisdeed or 0
	if self.tipBtn then
 		self.tipBtn:SetActive(isMisdeed ~= 0)
 		if callback then
 			addClickCallbackSelf(self.tipBtn,callback,self)
 		end
 	end
end

function ClubMemberItem:SetCallback(callback, tickCallback, target)
	self.callback = callback
	self.tickBtnClick = tickCallback
	self.target = target
end


function ClubMemberItem:UpdateView()
	self.nameLabel.text = self.info.nickname
	HeadImageHelper.SetImage(self.headIcon, 2, self.info.imageurl, self.info.uid)
	self.IDLabel.text = "ID:" .. self.info.uid
	-- if self.type == ClubMemberEnum.member then
		self.lastEnterLabel.text = os.date("%Y/%m/%d", self.info.logintime)
		self.timeLabel.text = os.date("%Y/%m/%d", self.info.ptime)
	-- else
	-- 	self.timeLabel.text = os.date("%Y/%m/%d", self.info.atime)
	-- end

	if self.info.uid == self.model.selfPlayerId then
--		self.bgSp.spriteName = "common_54"
--		self:SetLabelsFormat(UILabelFormat.F10)
	else
--		self.bgSp.spriteName = "common_11"
--		self:SetLabelsFormat(UILabelFormat.F12)
	end

	if self.model:CheckIsClubCreater(self.model.currentClubInfo.cid, self.info.uid) then
--		self.iconSp.spriteName = "club_52"
		self.iconSp.gameObject:SetActive(true)
		if self.tickBtn then
			self.tickBtn.gameObject:SetActive(false)
		end
	elseif self.model:IsClubManager(nil, self.info.uid) then
--		self.iconSp.spriteName = "club_53"
		self.iconSp.gameObject:SetActive(false)
		if self.tickBtn then
			self.tickBtn.gameObject:SetActive(false)
		end
	else
		self.iconSp.gameObject:SetActive(false)
		if self.tickBtn and self.model:CheckIsClubCreater(self.model.currentClubInfo.cid, self.model.selfPlayerId) then
			self.tickBtn.gameObject:SetActive(true)
		elseif self.tickBtn then
			self.tickBtn.gameObject:SetActive(false)
		end
	end
end


function ClubMemberItem:SetLabelsFormat(format)
	self.nameLabel:SetLabelFormat(format)
	self.IDLabel:SetLabelFormat(format)
	self.timeLabel:SetLabelFormat(format)
	self.lastEnterLabel:SetLabelFormat(format)
end

-- function ClubMemberItem:UpdateType()
-- 	self.lastLineGo:SetActive(true)
-- 	self.lastEnterLabel.gameObject:SetActive(true)
-- 	if self.type == ClubMemberEnum.apply then
-- 		self.sureBtnGo:SetActive(self.type == ClubMemberEnum.apply)
-- 		self.refuseBtnGo:SetActive(self.type == ClubMemberEnum.apply)
-- 	end
-- end


function ClubMemberItem:OnClick()
	if self.callback ~= nil then
		self.callback(self.target, self)
	end
end

function ClubMemberItem:OnSureClick()
	ui_sound_mgr.PlayButtonClick()
	ClubModel:ReqDealClubApply(self.info.cpid, 1)
end

function ClubMemberItem:OnRefuseClick()
	ui_sound_mgr.PlayButtonClick()
	ClubModel:ReqDealClubApply(self.info.cpid, 0)
end

function ClubMemberItem:tickClick()
	ui_sound_mgr.PlayButtonClick()
	if self.tickBtnClick then
		self.tickBtnClick(self.target, self)
	end
end


return ClubMemberItem