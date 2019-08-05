require "logic/invite_sys/inviteConfig"

invite_sys = {}
local this = invite_sys

-- 房间邀请

function this.inviteFriend(_roomID, _gameName, _gameRule)
	
	local roomID = _roomID
	local gameName = _gameName
	local gameRule = _gameRule
	local shareStr = string.format(global_define.gameShareTitle, gameName,roomID)
	local shareType = 0
	local contentType = 5 
	local title = shareStr
	local filePath = ""
	local url = string.format(inviteConfig.MWInviteURL,roomID,data_center.GetLoginRetInfo().uid)
	local description = gameRule
	print("inviteFriend------- url " .. url)
	YX_APIManage.Instance:WeiXinShare(shareType,contentType,title,filePath,url,description)

end