--[[--
 * @Description: 传说中的数据中心(这里只存放一些通用数据)
 * @Author:      shine
 * @FileName:    data_center.lua
 * @DateTime:    2017-05-16 14:16:14
 ]]

data_center = {}
local this = data_center

--登录信息
local userInfo = {}
local gold={};
local all= {};
local qqHallLoginInfo = {}
userInfo.nickname = nil;
userInfo.uid = nil;
userInfo.diamond = nil;
userInfo.coin = nil;
userInfo.ingot = nil;
userInfo.score = nil;
userInfo.cvalue = nil;
userInfo.vip = nil;
userInfo.safecoin = nil;
userInfo.bankrupt = nil;
userInfo.phone = nil;
userInfo.email = nil;
userInfo.ttype = nil;
userInfo.sitemid = nil;
userInfo.pwd = nil;
userInfo.session_key = nil;


--游戏类型
local gameType = 1
--local ServerUrlType = 2

local HTTPNETTYPE = 
{
	INTERNET_TEST = 1,
	LOCAL_FZMJ_TEST = 2,
	LOCAL_SSS_TEST = 3,
	DEVELOP_TEST = 4,
	RELEASE = 5,
	DEFAULT = 6,
}

--ws 服务器地址控制
local srvUrlType = NetWorkManage.Instance.ServerUrlType

if srvUrlType == HTTPNETTYPE.INTERNET_TEST then 		--外网测试
	this.url = "ws://huanyingwl.com:8001?uid=%s&token=%s"
	this.shareUrl = "http://fjmj.dstars.cc"
elseif srvUrlType == HTTPNETTYPE.LOCAL_FZMJ_TEST then 	--福州麻将内网
	this.url = "ws://192.168.2.202:8001?uid=%s&token=%s"
	this.shareUrl = "http://b.feiyubk.com"
elseif srvUrlType == HTTPNETTYPE.LOCAL_SSS_TEST then	--十三水内网
	this.url = "ws://192.168.2.13:8011?uid=%s&token=%s"
	this.shareUrl = "http://b.feiyubk.com"
elseif srvUrlType == HTTPNETTYPE.DEVELOP_TEST then 	--开发调试
	this.url = "ws://192.168.43.148:8001?uid=%s&token=%s"
	this.shareUrl = "http://b.feiyubk.com"
elseif srvUrlType == HTTPNETTYPE.RELEASE then 		--发布
	this.shareUrl = "http://fjmj.dstars.cc"
	this.url = "ws://fjmj.dstars.cc:8001?uid=%s&token=%s"
else
	this.url = "ws://fjmj.dstars.cc:8001?uid=%s&token=%s"
	this.shareUrl = "http://fjmj.dstars.cc"
end

--php 服务器地址控制
if srvUrlType == HTTPNETTYPE.INTERNET_TEST then
	NetWorkManage.Instance.BaseUrl = "http://huanyingwl.com/dstars_4/api/flashapi.php"
elseif srvUrlType == HTTPNETTYPE.LOCAL_FZMJ_TEST then --福州麻将内网
	NetWorkManage.Instance.BaseUrl = "http://192.168.43.148/dstars_4/api/flashapi.php"
elseif srvUrlType == HTTPNETTYPE.LOCAL_SSS_TEST then  --十三水内网
	NetWorkManage.Instance.BaseUrl = "http://192.168.43.148/dstars_4/api/flashapi.php"
elseif srvUrlType == HTTPNETTYPE.DEVELOP_TEST then
	NetWorkManage.Instance.BaseUrl = "http://192.168.43.148/dstars_4/api/flashapi.php"
elseif srvUrlType == HTTPNETTYPE.RELEASE then
	NetWorkManage.Instance.BaseUrl = "http://fjmj.dstars.cc/dstars/api/flashapi.php"
else
	NetWorkManage.Instance.BaseUrl = "http://fjmj.dstars.cc/dstars/api/flashapi.php"
end



---------------------------设置数据start-------------------------
function this.SetLoginRetInfo(loginInfo)
	userInfo = loginInfo
	print("loginUserInfo======================="..tostring(loginInfo))
end
function this.SetLoginAllInfo(AllfInfo)
    all=AllfInfo
	userInfo=all["user"]
end

function this.SetQQHallLoginInfo( AllfInfo )
	qqHallLoginInfo = AllfInfo
end

---------------------------设置数据end--------------------------






---------------------------外部接口start--------------------------
--获取登录信息
function this.GetLoginRetInfo()
	return userInfo
end

function this.GetAllInfor()
    return all
end

function this.GetGameType()
	return gameType
end

function this.GetQQHallLoginInfo(  )
	return qqHallLoginInfo
end

---------------------------外部接口end--------------------------