local base = require "logic/framework/ui/uibase/ui_view_base"
local ClubSelfItemView = class("ClubSelfItemView", base)

local selectColor = Color.New(34/255, 46/255, 106/255)
local disselectColor = Color.New(163/255, 88/255, 27/255)

function ClubSelfItemView:InitView()
	self.model = ClubModel
	self.nameLabel = subComponentGet(self.transform, "name", typeof(UILabel))
	self.IdLabel = subComponentGet(self.transform, "id", typeof(UILabel))
	self.clubusernum = subComponentGet(self.transform, "clubusernum", typeof(UILabel))
	self.icon = subComponentGet(self.transform, "icon", typeof(UITexture))
	self.newIconGo = child(self.transform,"newIcon").gameObject
	self.selfIconGo = child(self.transform,"selfIcon").gameObject
	self.redIconGo = child(self.transform,"redPoint").gameObject
	self.redIconGo:SetActive(false)

	self.selectIconGo = child(self.transform,"selectIcon").gameObject

	self.bg = subComponentGet(self.transform,"", typeof(UISprite))


	addClickCallbackSelf(self.gameObject, self.OnClick, self)
	self.exitBtn = child(self.transform,"exitBtn").gameObject
	if self.exitBtn then 
		addClickCallbackSelf(self.exitBtn, self.ExitClick, self) 
	end
	self:SetSelected(false)
end

function ClubSelfItemView:ExitClick()
	self.transform.parent.parent.parent.parent.gameObject:SetActive(false)
	self.model:ReqQuitClub(self.clubInfo.cid)
end

function ClubSelfItemView:SetCallback(callback, target)
	self.callback = callback
	self.target = target
end

function ClubSelfItemView:OnClick()
	log("俱乐部切换")
	if self.callback ~= nil then
		self.callback(self.target, self)
	end
end

function ClubSelfItemView:SetInfo(clubInfo)
	self.clubInfo = clubInfo
	self.IdLabel.text = "亲友圈号:" .. self.clubInfo.shid
	self.clubusernum.text = "人数："..self.clubInfo.clubusernum
	self.nameLabel.text = self.clubInfo.cname
	--self.icon.spriteName = ClubUtil.GetClubIconName(self.clubInfo.icon)
	hall_data.getuserimage(self.icon, nil, self.clubInfo.icon)
	--self.newIconGo:SetActive(self.model:CheckClubIsNew(self.clubInfo.cid))
	local isCreater = self.model:IsClubCreater(self.clubInfo.cid)
	self.selfIconGo:SetActive(isCreater)
	self.exitBtn:SetActive(not isCreater)
	self.redIconGo:SetActive(self.model:CheckCanSeeApplyList(self.clubInfo.cid) and self.clubInfo.applyNum ~= nil 
		and self.clubInfo.applyNum > 0 )
end

function ClubSelfItemView:SetSelected(value, force)
	if self.isSelect == value and not force then
		return 
	end
	self.isSelect = value
	self.selectIconGo:SetActive(value)
	if self.isSelect then
		--self.nameLabel:SetLabelFormat( UILabelFormat.F10)
		--self.IdLabel:SetLabelFormat(UILabelFormat.F10)
		self.bg.spriteName = "common_04"
	else
		--self.nameLabel:SetLabelFormat( UILabelFormat.F12)
		--self.IdLabel:SetLabelFormat(UILabelFormat.F12)
		self.bg.spriteName = "common_82"
	end
end


return ClubSelfItemView