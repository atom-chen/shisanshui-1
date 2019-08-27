--[[--
 * @Description: 定义全局数据结构
 * @Author:      shine
 * @FileName:    global_define.lua
 * @DateTime:    2017-05-16
 ]]

global_define = {} 
local this = global_define

this.userNameLen = 7
this.color = 
{
	["WHITE"] = "[FFFFFF]",
	["GREEN"] = "[32E646]",
	["BLUE"]  = "[32E6F0]",
	["PURPLE"] = "[BE32F0]",
	["ORANGE"] = "[F0A032]",
}


ENUM_GAME_TYPE = 
{
	TYPE_FUZHOU_MJ = 18,
	TYPE_SHISHANSHUI = 22,
}

function  this.GetUrlData( )
   local t=http_request_interface.GetTable()
   local url= global_define.httpactivity.."?session_key="..t.session_key.."&siteid="..t.siteid.."&version="..t.version
   return url
end

--原来地址改
--this.sss_path = Application.persistentDataPath.."/games/gamerule/FuZhou_ShiSangShui_Rule.json"
this.sss_path = Application.persistentDataPath.."/games/gamerule/PuXian_ShiSangShui_Rule.json"

this.fzmj_path = Application.persistentDataPath.."/games/gamerule/FuZhouMJ.json"

this.hallShareTitle = "福州人自己的棋牌游戏"
this.hallShareFriendContent = "有闲你就来！最有榕城特色的福州麻将，最真实的在线十三水！就在有闲棋牌！"
this.hallShareFriendQContent = "有闲你就来！玩地道福州麻将和十三水，就来有闲棋牌，呀厉害！"
this.hallShareSubUrl = "/gamewap/youxianqipai/view/youxixiazai.html?uid=%s"

this.gameShareTitle = "开房打%s，速来：房间号[%s]"
this.gameShareContent = ""

this.http="http://b.feiyubk.com"
this.httpmzsm=this.http.."/gamewap/youxianqipai/view/yonghuxieyi.html"
this.httpfwtk=this.http.."/gamewap/youxianqipai/view/fuwutiaokuan.html"
this.httpyszc=this.http.."/gamewap/youxianqipai/view/yinsizhengce.html"
this.httpactivity=this.http.."/gamewap/youxianqipai/view/huodonggonggao.html"
this.defineimg="https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=190291064,674331088&fm=58" 

function this.CheckHasName(gid)
  for k,v in pairs(ENUM_GAME_TYPE) do
    if gid == v then
      return true
    end
  end
  return false
end