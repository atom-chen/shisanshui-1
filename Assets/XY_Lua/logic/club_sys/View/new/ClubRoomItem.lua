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
	self.enterBtn = child(self.gameObject, "enterBtn").gameObject
	self.headList = {}
	for i = 1, 6 do
		self.headList[i] = subComponentGet(self.transform, "head"..i, typeof(UITexture))
	end
	addClickCallbackSelf(self.gameObject, self.OnClick, self)
	addClickCallbackSelf(self.enterBtn, self.OnEnterClick, self)
end

function ClubRoomItem:SetCallback(callback, target)
	self.callback = callback
	self.target = target
end

function ClubRoomItem:SetInfo(info)
	log("刷新")
	self.info = info
	self:UpdateView()
end

function ClubRoomItem:UpdateView()
	log(self.info)
	self.numLabel.text =""
	self.roundLabel.text = ""
	self.icon.gameObject:SetActive(false)
	if self.info == nil then
		log("刷新俱乐部房间信息")
		for k = 1, 6 do
			self.headList[k].gameObject:SetActive(false)
			log(self.headList[k].gameObject.name)
		end
		log("刷新俱乐部房间信息2")
		self.selfIconGo:SetActive(false)
		self.nameLabel.text = ""
		self.leaderNameLabel.text = ""
		self.enterBtn:SetActive(true)
		return
	end
	self.enterBtn:SetActive(false)
	local name = GameUtil.GetGameName(self.info.gid)
	self.nameLabel.text = "【" .. self.info.rno .. "】"
	self.leaderNameLabel.text = self.info.homenickname or ""

	if self.info.cfg == nil then
		return
	end

	-- if self.info.cfg.rounds == 0 then
	-- 	self.roundLabel.text = "打课"
	-- else
	-- 	self.roundLabel.text = (self.info.cfg.rounds or 0) .. "局"
	-- end
	-- self.numLabel.text = (self.info.cur_pnum or 0) .. "/" .. (self.info.cfg.pnum or 0) .. "人"

	self.selfIconGo:SetActive(false)--self.info.uid == self.model.selfPlayerId)

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

function ClubRoomItem:OnEnterClick()
	--UIManager:ShowUiForms("openroom_ui", nil, nil,nil)


    ui_sound_mgr.PlaySoundClip("common/audio_button_click")
    if openroom_main_ui ~= nil then 
      --open_room_data.RequesetClientConfig()
      openroom_main_ui.Show(1)
  end
end

return ClubRoomItem