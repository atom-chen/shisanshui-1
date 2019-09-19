local base = require "logic/framework/ui/uibase/ui_view_base"
local ClubRoomItem = class("ClubRoomItem", base)

function ClubRoomItem:InitView()
	self.model = ClubModel
	self.nameLabel = subComponentGet(self.transform, "room", typeof(UILabel))
	self.roundLabel = subComponentGet(self.transform, "round", typeof(UILabel))
	self.numLabel = subComponentGet(self.transform, "num", typeof(UILabel))
	self.icon = subComponentGet(self.transform, "icon", typeof(UISprite))
	self.leaderNameLabel = subComponentGet(self.transform, "name", typeof(UILabel))
	self.selfIconGo = child(self.gameObject, "selfIcon").gameObject
	self.selfIconGo:SetActive(false)
	self.headList = {}
	for i = 1, 6 do
		self.headList[i] = subComponentGet(self.transform, "head"..i, typeof(UITexture))
	end
	addClickCallbackSelf(self.gameObject, self.OnClick, self)
end

function ClubRoomItem:SetCallback(callback, target)
	self.callback = callback
	self.target = target
end

function ClubRoomItem:SetInfo(info)
	self.info = info
	self:UpdateView()
end

function ClubRoomItem:UpdateView()
	local name = GameUtil.GetGameName(self.info.gid)
	self.nameLabel.text = name .. "【" .. self.info.rno .. "】"
	self.leaderNameLabel.text = self.info.homenickname or ""

	if self.info.cfg == nil then
		return
	end

	if self.info.cfg.rounds == 0 then
		self.roundLabel.text = "打课"
	else
		self.roundLabel.text = (self.info.cfg.rounds or 0) .. "局"
	end
	self.numLabel.text = (self.info.cur_pnum or 0) .. "/" .. (self.info.cfg.pnum or 0) .. "人"

	self.selfIconGo:SetActive(self.info.uid == self.model.selfPlayerId)

	for i = 1, 6 do
		if i <= #self.info.imageurls then
			self.headList[i].gameObject:SetActive(true)
		else
			self.headList[i].gameObject:SetActive(false)
		end
	end
--	self.icon.spriteName = GameUtil.GetGameIcon(self.info.gid)--屏蔽图标
end

function ClubRoomItem:OnClick()
	if self.callback ~= nil then
		self.callback(self.target, self)
	end
end


return ClubRoomItem