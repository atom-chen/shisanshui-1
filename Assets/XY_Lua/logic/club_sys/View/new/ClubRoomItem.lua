local base = require "logic/framework/ui/uibase/ui_view_base"
local ClubRoomItem = class("ClubRoomItem", base)
require "logic/common_ui/PreRoom"

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
	self.detailBtn = child(self.gameObject, "detailBtn").gameObject
	self.headList = {}
	for i = 1, 6 do
		self.headList[i] = subComponentGet(self.transform, "head"..i, typeof(UITexture))
	end
	addClickCallbackSelf(self.gameObject, self.OnClick, self)
	addClickCallbackSelf(self.enterBtn, self.OnEnterClick, self)
	addClickCallbackSelf(self.detailBtn, self.OnDetailClick, self)
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
		end
		self.selfIconGo:SetActive(false)
		self.nameLabel.text = ""
		self.leaderNameLabel.text = ""
		self.enterBtn:SetActive(true)
		self.detailBtn:SetActive(false)
		return
	end
	self.enterBtn:SetActive(true)
	self.detailBtn:SetActive(false)
	local name = GameUtil.GetGameName(self.info.gid)
	self.nameLabel.text = tostring(self.info.rno)
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
	log(self.info)
	if self.info == nil then
		self:OnEnterClick()
		return
	end
	if self.callback ~= nil then
		self.callback(self.info)
	end
end

function ClubRoomItem:OnEnterClick()
    ui_sound_mgr.PlaySoundClip("common/audio_button_click")
  --   if openroom_main_ui ~= nil then 
  --     --open_room_data.RequesetClientConfig()
  --     openroom_main_ui.Show(1)
	 -- end
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

function ClubRoomItem:OnDetailClick()
    ui_sound_mgr.PlaySoundClip("common/audio_button_click")
end

return ClubRoomItem