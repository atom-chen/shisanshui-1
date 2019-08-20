local base = require "logic/framework/ui/uibase/ui_view_base"
local ClubNonView = class("ClubNonView",base)

function ClubNonView:InitView()
	self.model = ClubModel
	
	self.copyQQBtn = child(self.gameObject,"right/copy1Btn").gameObject
	self.copyWechatBtn = child(self.gameObject,"right/copy2Btn").gameObject
	self.qqLbl = subComponentGet(self.transform,"right/QQLbl","UILabel")
	self.wechatLbl = subComponentGet(self.transform,"right/WechatLbl","UILabel")
	
	self.rightGo = child(self.gameObject,"right").gameObject
	--self.rightGo:SetActive(not G_isAppleVerifyInvite)
	
	self.qqLbl.text = "QQ:"--..global_define.qq
	self.wechatLbl.text = "微信:"--..global_define.winXin


	addClickCallbackSelf(self.copyWechatBtn, self.CopyWeiXin, self)
	addClickCallbackSelf(self.copyQQBtn, self.CopyQQ, self)
end

function ClubNonView:CopyWeiXin()
	local str = tostring(global_define.winXin)
	YX_APIManage.Instance:onCopy(str,function() UIManager:FastTip(LanguageMgr.GetWord(6043))end)
end

function ClubNonView:CopyQQ()
	local str = tostring(global_define.qq)
	YX_APIManage.Instance:onCopy(str,function() UIManager:FastTip(LanguageMgr.GetWord(6043))end)
end

return ClubNonView