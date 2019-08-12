require "logic/mahjong_sys/_model/room_usersdata_center"
require "logic/mahjong_sys/_model/room_usersdata"
require "logic/mahjong_sys/_model/operatorcachedata"
require "logic/mahjong_sys/_model/operatordata"
require "logic/hall_sys/openroom/room_data"

--require "logic/mahjong_sys/ui_mahjong/mahjong_player_ui"
require "logic/animations_sys/animations_sys"
require "logic/shisangshui_sys/ui_shisangshui/shisangshui_ui_sys"
require "logic/shisangshui_sys/shisangshui_play_sys"
require "logic/shisangshui_sys/ui_shisangshui/shisanshui_player_ui"
require "logic/common_ui/chat_ui"
require "logic/hall_sys/setting_ui/setting_ui"
require "logic/hall_sys/record_ui/recorddetails_ui"


shisangshui_ui = ui_base.New()
local this = shisangshui_ui

local transform = this.transform

local operTipEX = nil

this.timerAlarm = nil

local function Onbtn_exitClick()
	
	
  if roomdata_center.isStart then
  	shisangshui_play_sys.VoteDrawReq(true)
  	return
  end
	
  ui_sound_mgr.PlaySoundClip("common/audio_close_dialog")
  local t= GetDictString(5001)
  message_box.ShowGoldBox(t,nil,1, {function ()  		
  		shisangshui_play_sys.LeaveReq()
  		message_box.Close()
  	end}, {"fonts_01"})
end

local function Onbtn_moreClick()
	log("Onbtn_moreClick")
	this.SetMorePanle()
end

local function OnBtn_WarningClick()
	
	help_ui.Show("rules/shisanshui")
end

local function Onbtn_readyClick()	
	ui_sound_mgr.PlaySoundClip("common/audio_ready")
	log("Onbtn_readyClick")
	shisangshui_play_sys.ReadyGameReq()
	--[[
	this.SetBeiShuBtnCount()
	local roomInfo = room_data.GetSssRoomDataInfo()
	if roomInfo.isZhuang == true then
		sessionData = player_data.GetSessionData()
		if tonumber(sessionData["_chair"]) == 1 then
			this.IsShowBeiShuiBtn(false)
		else
			this.IsShowBeiShuiBtn(true)
		end
	end
	]]
end

local function Onbtn_voiceClick()
	log("Onbtn_voiceClick")
end

local function Onbtn_inviteFriend()	--邀请好友
	log("Onbtn_inviteFriend")
	invite_sys.inviteFriend(room_data.GetSssRoomDataInfo().rno,"十三水",tostring(room_data.GetShareContent()))
end

local function Onbtn_dimissRoom()	--解散房间
	shisangshui_play_sys.DissolutionRoom()
end

local function Onbtn_chatClick()
--	log("Onbtn_chatClick isShowCahtUI"..tostring(isShowCahtUI))
		log("Onbtn_chatClick")
	this.SetChatTextInfo()
	this.SetChatImgInfo()
	this.SetChatPanle()
	
	--[[
	if chat_ui.gameObject == nil then
		chat_ui.Show()	
	else
		chat_ui.Hide()
	end
	chat_ui.gameObject.transform.localPosition=Vector3.New(325,-65,0)
	componentGet(chat_ui.transform,"UIPanel").alpha=0.8
	]]
end

local function Onbtn_guoClick()
	log("Onbtn_guoClick")
end

function OnBtn_SettingOnClick()
	log("++++++++SettingOnClick")
	setting_ui.Show()
end

--聊天蒙板
local function Onbtn_chatContainerClick()
	this.SetChatPanle()
end


--战绩UI
function OnBtn_AchievementOnClick()
	
	http_request_interface.getRoomByRid(roomdata_center.rid,1,function (code,m,str)
           local s=string.gsub(str,"\\/","/")  
           local t=ParseJsonStr(s)
           log(str)
           recorddetails_ui.Show(t)   
       end)
end

--语音接口
function this.OnBtn_SendVoiceMessageOnClick()
end

local widgetTbl = {}
local compTbl = {}

local special_card_type = {}


local gameDataInfo = {}


local function InitVoteView()
	this.voteView = vote_quit_view.New()
	this.voteView:SetTransform(child(widgetTbl.panel, "Anchor_TopRight/voteView"))
	this.voteView:Hide()
end

--[[--
 * @Description: 获取各节点对象  
 ]]
local function InitWidgets()
	widgetTbl.panel = child(this.transform, "Panel")
	--返回大厅按钮
	widgetTbl.btn_exit = child(widgetTbl.panel, "Anchor_TopLeft/exit")
	if widgetTbl.btn_exit~=nil then
       addClickCallbackSelf(widgetTbl.btn_exit.gameObject,Onbtn_exitClick,this)
    end
    --更多按钮
	widgetTbl.btn_more = child(widgetTbl.panel, "Anchor_TopRight/more")
	if widgetTbl.btn_more~=nil then
       addClickCallbackSelf(widgetTbl.btn_more.gameObject,Onbtn_moreClick,this)
       widgetTbl.btn_more.gameObject:SetActive(true)
    end
	--提示按钮
    widgetTbl.btn_waring = child(widgetTbl.panel, "Anchor_TopRight/warning")
	if widgetTbl.btn_waring~=nil then
       addClickCallbackSelf(widgetTbl.btn_waring.gameObject,OnBtn_WarningClick,this)
       widgetTbl.btn_waring.gameObject:SetActive(true)
    end
    --更多面板
    widgetTbl.panel_more = child(widgetTbl.panel, "Anchor_TopRight/bg")
    if widgetTbl.panel_more~=nil then
       widgetTbl.panel_more.gameObject:SetActive(false)
    end
    --设置按钮
     widgetTbl.setting = child(widgetTbl.panel, "Anchor_TopRight/bg/setting")
    if widgetTbl.setting~=nil then
    	addClickCallbackSelf(widgetTbl.setting.gameObject,OnBtn_SettingOnClick,this)
       widgetTbl.setting.gameObject:SetActive(true)
    end
    --战绩按钮
      widgetTbl.result = child(widgetTbl.panel, "Anchor_TopRight/bg/result")
    if widgetTbl.result~=nil then
    	addClickCallbackSelf(widgetTbl.result.gameObject,OnBtn_AchievementOnClick,this)
       widgetTbl.result.gameObject:SetActive(true)
    end
    --准备按钮
	widgetTbl.btn_ready = child(widgetTbl.panel, "Anchor_Center/readyBtns/ready")
	if widgetTbl.btn_ready~=nil then
       addClickCallbackSelf(widgetTbl.btn_ready.gameObject,Onbtn_readyClick,this)
    end
    --语音按钮
	widgetTbl.btn_voice = child(widgetTbl.panel, "Anchor_Right/voice")
	if widgetTbl.btn_voice~=nil then
       addClickCallbackSelf(widgetTbl.btn_voice.gameObject,Onbtn_voiceClick,this)
       widgetTbl.btn_voice.gameObject:SetActive(true)
    end
    --聊天按钮
	widgetTbl.btn_chat = child(widgetTbl.panel, "Anchor_Right/chat")
	if widgetTbl.btn_chat~=nil then
       addClickCallbackSelf(widgetTbl.btn_chat.gameObject,Onbtn_chatClick,this)
       widgetTbl.btn_chat.gameObject:SetActive(true)
    end
	
	--邀请按钮
	widgetTbl.btn_invite = child(widgetTbl.panel, "Anchor_Center/readyBtns/invite")
	if widgetTbl.btn_invite~=nil then
	   addClickCallbackSelf(widgetTbl.btn_invite.gameObject,Onbtn_inviteFriend,this)
	   widgetTbl.btn_invite.gameObject:SetActive(true)
	end	
	
	--解散按钮
	widgetTbl.btn_dismiss = child(widgetTbl.panel, "Anchor_Center/readyBtns/dismiss")
	if widgetTbl.btn_dismiss~=nil then
	   addClickCallbackSelf(widgetTbl.btn_dismiss.gameObject,Onbtn_dimissRoom,this)
	   widgetTbl.btn_dismiss.gameObject:SetActive(true)
	end	

    --房号
    log("----------------------------------------------------label_gameinfo")
	widgetTbl.label_gameinfo = child(widgetTbl.panel, "Anchor_Bottom/gameInfo")
	if widgetTbl.label_gameinfo~=nil then
       widgetTbl.label_gameinfo.gameObject:SetActive(false)
    end

    widgetTbl.label_roomId = child(widgetTbl.panel, "Anchor_TopLeft/phoneInfo/gameInfo")
	if widgetTbl.label_roomId~=nil then
       widgetTbl.label_roomId.gameObject:SetActive(true)
    end

	--聊天面板
    widgetTbl.panel_chatPanel = child(widgetTbl.panel, "Anchor_Right/chatPanel")
    if widgetTbl.panel_chatPanel~=nil then
       widgetTbl.panel_chatPanel.gameObject:SetActive(false)
    end
    --聊天面板蒙板
    widgetTbl.panel_chatContainer = child(widgetTbl.panel, "Anchor_Right/chatPanel/Container")
    if widgetTbl.panel_chatContainer~=nil then
       addClickCallbackSelf(widgetTbl.panel_chatContainer.gameObject,Onbtn_chatContainerClick,this)
   	end
	
    --牌局信息
    widgetTbl.leftCard = child(widgetTbl.panel,"Anchor_TopLeft/leftCard/num")

    widgetTbl.rewards_panel = child(widgetTbl.panel,"Anchor_Center/rewards")
    if widgetTbl.rewards_panel~=nil then
    	this.FindChild_Rewards()
        widgetTbl.rewards_panel.gameObject:SetActive(false)
    end

    widgetTbl.firstGroupScore = child(widgetTbl.panel,"Anchor_Bottom/firstScore")
    if widgetTbl.firstGroupScore ~= nil then
    	 widgetTbl.firstGroupScore.gameObject:SetActive(false)
    end
    widgetTbl.secondGroupScore = child(widgetTbl.panel,"Anchor_Bottom/secondScore")
    if widgetTbl.secondGroupScore ~= nil then
    	 widgetTbl.secondGroupScore.gameObject:SetActive(false)
    end
    widgetTbl.threeGroupScore = child(widgetTbl.panel,"Anchor_Bottom/threeScore")
    if widgetTbl.threeGroupScore ~= nil then
    	widgetTbl.threeGroupScore.gameObject:SetActive(false)
    end
     widgetTbl.allScore = child(widgetTbl.panel,"Anchor_Bottom/allScore")
    if widgetTbl.allScore ~= nil then
    	widgetTbl.allScore.gameObject:SetActive(false)
    end


		--特殊牌型图标
	special_card_type.group = child(widgetTbl.panel,"Anchor_Center/special_card_type_group")
	if special_card_type.group ~= nil then
		for i =1, 6 do
			local special_card_icon = child(special_card_type.group,"special_card_type_"..i)
			special_card_type.group["special_card_type_"..i] = special_card_icon
			special_card_type.group["special_card_type_"..i].gameObject:SetActive(false)
			
		end
	end

    --创建用户列表
    this.playerList = {}
	local roomData = room_data.GetSssRoomDataInfo()
	local peopleNum = roomData.people_num
	log("PeopleNum:"..tostring(peopleNum))
    for i=1,6 do
    	local playerTrans = child(widgetTbl.panel, "Anchor_Center/Players/Player"..i)
    	if playerTrans ~= nil then
			if i < tonumber(peopleNum) or i == tonumber(peopleNum) then
			local viewSeateConfig = config_data_center.getConfigDataByID("dataconfig_shisanshuitableconfig","id",tonumber(peopleNum))
			local position = viewSeateConfig["pos"..tostring(i)]
			local posjson = string.gsub(position,"\\/","/")  
			local seateJson = ParseJsonStr(posjson)
			log("LocalPosition frome configTable:"..tostring(seateJson))
			
			local x = seateJson["x"]
			local y = seateJson["y"]
			local z = 0
			
			local prepare_x = seateJson["prepare_x"]
			local prepare_y = seateJson["prepare_y"]
			
			
			playerTrans.localPosition = Vector3(x,y,z)
			local playerComponent = shisanshui_player_ui.New(playerTrans)
			playerComponent.SetReadyLocalPosition(prepare_x,prepare_y)
    		table.insert(this.playerList, playerComponent)
		end
    		playerTrans.gameObject:SetActive(false)
    	end
    end
    
    --赖子
	compTbl.laizi = child(widgetTbl.panel, "Anchor_TopLeft/lai")
	if compTbl.laizi~=nil then
       compTbl.laizi.gameObject:SetActive(false)
    end
		
		
	    --倍数
    compTbl.xiapao = child(widgetTbl.panel, "Anchor_Center/xiapao")
	if compTbl.xiapao~=nil then
		for i=1,5 do
			local btn_xiapao = child(compTbl.xiapao, "pao"..i)
			addClickCallbackSelf(btn_xiapao.gameObject,

			function ()
				shisangshui_play_sys.beishu(i)
				this.ChooseMyMult()
			end,
			this)
			
		end
       compTbl.xiapao.gameObject:SetActive(false)
    end
	
	this.CardsTbl = {}
	for i = 1, 7 do
		this.CardsTbl[i] = {}
		for j = 1, 13 do
			this.CardsTbl[i][j] = child(widgetTbl.panel, "Anchor_Center/Players/Player"..i.."/cards/PlayerCard"..j)
			this.CardsTbl[i][j].gameObject:SetActive(false);
		end
	end
end


	

	

local function Onbtn_rewardsBackClick()
	this.HideRewards()
	this.ShowReadyBtn()
end


function this.FindChild_Rewards()
	widgetTbl.rewards_back = child(widgetTbl.rewards_panel,"back")
	if widgetTbl.rewards_back~=nil then
       addClickCallbackSelf(widgetTbl.rewards_back.gameObject, Onbtn_rewardsBackClick, this)
    end
	--准备
	widgetTbl.rewards_ready = child(widgetTbl.rewards_panel,"ready")
	if widgetTbl.rewards_ready~=nil then
       addClickCallbackSelf(widgetTbl.rewards_ready.gameObject, Onbtn_readyClick, this)
    end
    widgetTbl.rewards_splayers = {}
    for i=1,4 do
    	local p = {}
    	p.rewards_player = child(widgetTbl.rewards_panel,"small/player"..i)
    	p.rewards_player_name = child(p.rewards_player,"name")
    	p.rewards_player_point = child(p.rewards_player,"point")
    	p.rewards_player_head = child(p.rewards_player,"head_bg/head_bg2/head")
    	p.rewards_player_vip = child(p.rewards_player_head,"vip")
    	p.rewards_player_vip.gameObject:SetActive(false)
    	p.rewards_player_zhuang = child(p.rewards_player_head,"zhuang")
    	p.rewards_player_zhuang.gameObject:SetActive(false)
    	table.insert(widgetTbl.rewards_splayers,p)
    end


    widgetTbl.rewards_bplayers = {}
    for i=1,1 do
    	local p = {}
    	p.rewards_player = child(widgetTbl.rewards_panel,"big/player"..i)
    	p.rewards_player_name = child(p.rewards_player,"name")
    	p.rewards_player_point = child(p.rewards_player,"point")
    	p.rewards_player_head = child(p.rewards_player,"head_bg/head_bg2/head")
    	p.rewards_player_vip = child(p.rewards_player_head,"vip")
    	p.rewards_player_vip.gameObject:SetActive(false)
    	p.rewards_player_zhuang = child(p.rewards_player_head,"zhuang")
    	p.rewards_player_zhuang.gameObject:SetActive(false)
    	p.rewards_player_itemEx = child(p.rewards_player,"itemEx")
    	p.rewards_player_itemEx.gameObject:SetActive(false)
    	p.rewards_player_scrollView = child(p.rewards_player,"Scroll View")
    	p.rewards_player_grid = child(p.rewards_player,"Grid")
    	table.insert(widgetTbl.rewards_bplayers,p)
    end
end

--[[--
 * @Description: 更多界面  
 ]]
function this.SetMorePanle()
	if widgetTbl.panel_more.gameObject.activeSelf == true then
		widgetTbl.panel_more.gameObject:SetActive(false)
	else
		widgetTbl.panel_more.gameObject:SetActive(true)
	end
end


function this.Awake()
	this:RegistUSRelation()
	InitWidgets()
	InitVoteView()
	this.InitSettingBgm()
	
	shisangshui_ui_sys.Init()
	msg_dispatch_mgr.SetIsEnterState(true)	
end

function this.Start()
	gameDataInfo = room_data.GetSssRoomDataInfo()
	if gameDataInfo.isChip then
		child(this.transform, "Panel/Anchor_TopRight/mapai").gameObject:SetActive(true)
	else
		child(this.transform, "Panel/Anchor_TopRight/mapai").gameObject:SetActive(false)
	end
end

function this.OnDestroy()
	this.playerList = {}
	widgetTbl = {}
	compTbl = {}	
	shisangshui_ui_sys.UInit()
end

--æ˜¾ç¤ºå‡†å¤‡æŒ‰é’®
function  this.ShowReadyBtn()
	widgetTbl.btn_ready.gameObject:SetActive(true)
end

--éšè—å‡†å¤‡æŒ‰é’®
function  this.HideReadyBtn()
	widgetTbl.btn_ready.gameObject:SetActive(false)
end


function this.SetChatPanle()
	log("关闭聊天界面")
	if widgetTbl.panel_chatPanel.gameObject.activeSelf == true then
		widgetTbl.panel_chatPanel.gameObject:SetActive(false)
	else
		widgetTbl.panel_chatPanel.gameObject:SetActive(true)
	end
end

function this.HideChatPanel()
	widgetTbl.panel_chatPanel.gameObject:SetActive(false)
end

--[[--
 * @Description: è®¾ç½®çŽ©æ³•ã€æˆ¿å·  
 * @param:       wanfaStr çŽ©æ³•  RoomNum æˆ¿å·
 * @return:      nil
 ]]
function  this.SetGameInfo(wanfaStr,RoomNum)
	local str = wanfaStr..RoomNum
	if widgetTbl.label_gameinfo_comp == nil then
		widgetTbl.label_gameinfo_comp = widgetTbl.label_gameinfo.gameObject:GetComponent(typeof(UILabel))
	end
	
	local configStr = ""
	local configData = room_data.GetSssRoomDataInfo()
	if configData.isZhuang  == true then
		configStr = "加一色做庄;"
	end
--	    0x4F,   --小鬼  79
--    0x5F,   --大鬼	95
	if configData.isChip == true then
		configStr = configStr.."买码;"
	else
		configStr = configStr.."无码;"
	end
	
	if tonumber(configData.add_card) == 1 then
		configStr = configStr.."加一色;"
	else
		configStr = configStr.."加二色;"
	end
	
	if tonumber(configData.add_ghost)  == 0x4f then
		configStr = configStr.."大鬼;"
	elseif tonumber(configData.add_ghost)  == 0x5f then
		configStr = configStr.."小鬼;"
	end
	configStr = configStr.."闲家倍数:"..tostring(configData.max_multiple)
	widgetTbl.label_gameinfo_comp.text = configStr
	widgetTbl.label_gameinfo_comp.gameObject:SetActive(false)

	
	local label_roomId_comp = widgetTbl.label_roomId.gameObject:GetComponent(typeof(UILabel))
	
	label_roomId_comp.text = str

end

function this.SetLeftCard( num )
	if widgetTbl.leftCard_comp == nil then
		widgetTbl.leftCard_comp = widgetTbl.leftCard.gameObject:GetComponent(typeof(UILabel))
	end

	widgetTbl.leftCard_comp.text = tostring(room_data.GetSssRoomDataInfo().cur_playNum).."/"..tostring(room_data.GetSssRoomDataInfo().play_num).."局数"
	log("当前局数:"..tostring(room_data.GetSssRoomDataInfo().cur_playNum))
	
end

--设置用户信息
function this.SetPlayerInfo( viewSeat, usersdata)
	if this.playerList[viewSeat] ~= nil then
		this.playerList[viewSeat].Show(usersdata,viewSeat)
	end
end

function this.DealChat(viewSeat,contentType,content,givewho)
	if contentType == 1 then
		--文字聊天
		--fast_tip.Show(content)
		this.playerList[viewSeat].SetChatText(content)
		if viewSeat == 1 then
			this.HideChatPanel()
		end
	elseif contentType ==2 then
		--表情聊天
		--fast_tip.Show("Image name:"..content)
		this.playerList[viewSeat].SetChatImg(content)
		if viewSeat == 1 then
			this.HideChatPanel()
		end
	elseif contentType == 3 then
		--语音聊天
	elseif contentType == 4 then
		--玩家互动
		this.playerList[givewho].ShowInteractinAnimation(viewSeat,content)	
	end
end

function this.HideChatPanel()
	widgetTbl.panel_chatPanel.gameObject:SetActive(false)
end

--éšè—çŽ©å®¶ä¿¡æ¯
function this.HidePlayer(viewSeat)
	if this.playerList[viewSeat] ~= nil then
		this.playerList[viewSeat].Hide()
	end
end

function this.ShowPlayerTotalPoints(viewSeat,totalPoint)
	if this.playerList[viewSeat] ~= nil then
		this.playerList[viewSeat].SetTotalPoints(totalPoint)
	end
end

function this.IsShowBeiShuiBtn(isShow)
	compTbl.xiapao.gameObject:SetActive(isShow)
end

function this.ShowInviteBtn(isShow)
	widgetTbl.btn_invite.gameObject:SetActive(isShow)
end

function this.ShowDissolveRoom(isShow)
	widgetTbl.btn_dismiss.gameObject:SetActive(isShow)
end

--è®¾ç½®æ‰˜ç®¡çŠ¶æ€
function this.SetPlayerMachine(viewSeat, isMachine )
	if this.playerList[viewSeat] ~= nil then
		this.playerList[viewSeat].SetMachine(isMachine)
	end
end

--è®¾ç½®çŽ©å®¶åœ¨çº¿çŠ¶æ€
function this.SetPlayerLineState(viewSeat, isOnLine )
	if this.playerList[viewSeat] ~= nil then
		this.playerList[viewSeat].SetOffline(not isOnLine)
	end
end

function this.SetHideTotaPoints()
	for i,v in ipairs(this.playerList) do
		v.HideTotalPoints()
	end
end

--æ›´æ–°çŽ©å®¶é‡‘å¸
function this.SetPlayerCoin(viewSeat,value)
	if this.playerList[viewSeat] ~= nil then
		this.playerList[viewSeat].SetScore(value)
	end
end

--è®¾ç½®çŽ©å®¶å‡†å¤‡çŠ¶æ€
function this.SetPlayerReady( viewSeat,isReady )
	log("viewSeat-------------------------------------"..tostring(viewSeat))
	if this.playerList[viewSeat] ~= nil then
		this.playerList[viewSeat].SetReady(isReady)
	end
end

function this.SetAllPlayerReady(isReady)
	for i,v in ipairs(this.playerList) do
		v.SetReady(isReady)
	end
end


--设置头像的光圈
this.lightFrameObj = nil
function this.SetPlayerLightFrame(viewSeat)
	if this.lightFrameObj ~= nil then
		animations_sys.StopPlayAnimation(this.lightFrameObj)
	end
	local Player = this.playerList[viewSeat]
	if Player ~= nil then
		if this.playerList[viewSeat].transform == nil then 
			log("+++++++++AnimationError!!!!!!!")
		end
		log("当前桌面对应的座位号"..tostring(Player.viewSeat).."transformName"..tostring(Player.transform.name))
		this.lightFrameObj = animations_sys.PlayAnimationWithLoop(Player.transform,"shisanshui_icon_frame","flame",114,124)
		componentGet(this.lightFrameObj.gameObject,"SkeletonAnimation"):ChangeQueue(3001)
	end
end

function this.DisablePlayerLightFrame()
	if this.lightFrameObj ~= nil then
		animations_sys.StopPlayAnimation(this.lightFrameObj)
	end
end


function this.SetGruopScord(index, score ,scoreExt, allScore)
	local  str = ""
	local  addStr = ""
	local  addExtStr = ""
	local  positiveColor1 = ""
	local  positiveColor2 = ""
	if tonumber(score) > 0 then 
		addStr = "+" 
		positiveColor1 = "[ffdd0a]"
	else
		positiveColor1 = "[43ccf0]"
	end
	if tonumber(scoreExt) > 0 then 
		addExtStr = "+" 
		positiveColor2 = "[ffdd0a]"
	else
		positiveColor2 = "[43ccf0]"
	end
	if tonumber(index) == 1 then
		str = "[a6f7b2]".."首墩 ".."[-]"..tostring(positiveColor1)..tostring(addStr)..tostring(score).."[-]"..tostring(positiveColor2).." ("..tostring(addExtStr)..tostring(scoreExt)..")".."[-]"
		--subComponentGet
		local labelWidget  = child(widgetTbl.firstGroupScore,"Label")
		local label = componentGet(labelWidget,"UILabel")
		label.text = str
		widgetTbl.firstGroupScore.gameObject:SetActive(true)
	elseif tonumber(index) == 2 then
		str = "[a6f7b2]".."中墩 ".."[-]"..tostring(positiveColor1)..tostring(addStr)..tostring(score).."[-]"..tostring(positiveColor2).." ("..tostring(addExtStr)..tostring(scoreExt)..")".."[-]"
		--subComponentGet
		local labelWidget  = child(widgetTbl.secondGroupScore,"Label")
		local label = componentGet(labelWidget,"UILabel")
		label.text = str
		widgetTbl.secondGroupScore.gameObject:SetActive(true)
	elseif tonumber(index) == 3 then
		str = "[a6f7b2]".."尾墩 ".."[-]"..tostring(positiveColor1)..tostring(addStr)..tostring(score).."[-]"..tostring(positiveColor2).." ("..tostring(addExtStr)..tostring(scoreExt)..")".."[-]"
		--subComponentGet
		local labelWidget  = child(widgetTbl.threeGroupScore,"Label")
		local label = componentGet(labelWidget,"UILabel")
		widgetTbl.threeGroupScore.gameObject:SetActive(true)
		label.text = str
	elseif tonumber(index) == 4 then
		
		if allScore ~= nil then
			if tonumber(allScore) > 0 then
				addStr = "+" 
				positiveColor1 = "[ffdd0a]"
			else
				positiveColor1 = "[43ccf0]"
			end
		end
		str = "[ffdd0a]".."总分 ".."[-]"..tostring(positiveColor1)..tostring(allScore).."[-]"
		--subComponentGet
		local labelWidget  = child(widgetTbl.allScore,"Label")
		local label = componentGet(labelWidget,"UILabel")
		widgetTbl.allScore.gameObject:SetActive(true)
		label.text = str
	end
end

--播放开始比牌的动画效果
function this.PlayerStartGameAnimation()
	animations_sys.PlayAnimation(this.gameObject.transform,"shisanshui_kaishibipai","kaishibipai",100,100,false, function() end)
	ui_sound_mgr.PlaySoundClip("dub/kaishibipai_nv")
end

--[[--
 * @Description: å®šåº„  
 * @param:       viewSeat è§†å›¾åº§ä½å· 
 * @return:      nil
 ]]
function this.SetBanker( viewSeat )
	if this.playerList[viewSeat] ~= nil then
		this.playerList[viewSeat].SetBanker(true)
	end
end


--é‡ç½®æ‰€æœ‰çŠ¶æ€ï¼Œç”¨äºŽæ¸¸æˆç»“æŸåŽ
function this.ResetAll()
	for i=1,#this.playerList do
		
	if room_data.GetSssRoomDataInfo().isZhuang == false then
		this.playerList[i].SetBanker(false)
	end
		this.playerList[i].HideTotalPoints()
	end
	
	this.HideReadyBtn()
	this.HideScoreGroup()
	this.HideRewards()
	this.HideSpecialCardIcon()
end

  function this.HideScoreGroup()
    	widgetTbl.firstGroupScore.gameObject:SetActive(false)
    	widgetTbl.secondGroupScore.gameObject:SetActive(false)
    	widgetTbl.threeGroupScore.gameObject:SetActive(false)
		widgetTbl.allScore.gameObject:SetActive(false)
   end

--[[--
 * @Description: 
 * tbl = {
 * [1] = {"name" = "123","point" = 500}
 * [2] = {"name" = "123","point" = 500}
 * }  
 ]]
function this.SetRewards( tbl )
	widgetTbl.rewards_panel.gameObject:SetActive(true)

	 for i=1,4 do
	 	local p = widgetTbl.rewards_splayers[i]
	 	--æ˜µç§°
	 	if p.rewards_player_name_comp == nil then
	 		p.rewards_player_name_comp = p.rewards_player_name:GetComponent(typeof(UILabel))
	 	end
	 	p.rewards_player_name_comp.text = tbl[i].name
	 	--é‡‘å¸
	 	if p.rewards_player_point_comp == nil then
	 		p.rewards_player_point_comp = p.rewards_player_point:GetComponent(typeof(UILabel))
	 	end 
	 	p.rewards_player_point_comp.text = tbl[i].point
	 	--åº„
	 	if tbl[i].isBanker then
	 		p.rewards_player_zhuang.gameObject:SetActive(true)
	 	end
	 	--å¤´åƒ
	 	if p.rewards_player_headTexture==nil then
			p.rewards_player_headTexture = p.rewards_player_head.gameObject:GetComponent(typeof(UITexture))
		end
		mahjong_ui_sys.GetHeadPic(p.rewards_player_headTexture,tbl[i].url)

		 local p = widgetTbl.rewards_bplayers[1]
		 p.rewards_player.gameObject:SetActive(false)
	 end
end

function this.HideRewards()
	widgetTbl.rewards_panel.gameObject:SetActive(false)
end

--´òÇ¹
function this.GetShootTran( viewSeat )
	log("Shoot-------------------------------------"..tostring(viewSeat))
	if this.playerList[viewSeat] ~= nil then
		return this.playerList[viewSeat].ShootTran()
	end
end

function this.GetShootHoleTran(viewSeat, index)
	log("Shoot-------------------------------------"..tostring(viewSeat))
	if this.playerList[viewSeat] ~= nil then
		return this.playerList[viewSeat].ShootHoleTran(index)
	end
end


function this.InitSettingBgm()
	ui_sound_mgr.SceneLoadFinish() 
    ui_sound_mgr.PlayBgSound("game_bgm")	
    ui_sound_mgr.controlValue(0.5)
    ui_sound_mgr.ControlCommonAudioValue(0.5)
end

local chatTextTab = {"我是一个神枪手，打枪本领强！","今天忘记洗手了，牌敢不敢再臭点！","哎，你慢慢配牌，我去海边吹下风！","颤抖吧，这把要全垒打！","哈喽，快摊牌咯！","特殊牌，我要特殊牌！","嗨，你的枪生锈了！","为什么中枪的总是我，目仔koko滴！","我有事先走了，下次再玩吧！","这牌敢不敢再水一点！"}
function this.SetChatTextInfo()
	for i=1,table.getCount(chatTextTab),1 do       
       local good = child(widgetTbl.panel_chatPanel,"panel/ScrollView/grid_text/item"..tostring(i))     
	   if good==nil then 
		    local o_good = child(widgetTbl.panel_chatPanel,"panel/ScrollView/grid_text/item"..tostring(i-1)) 
		    good = GameObject.Instantiate(o_good.gameObject)
		    good.transform.parent=o_good.transform.parent 
            good.name="item"..tostring(i)
            good.transform.localScale={x=1,y=1,z=1}    
            local grid=child(widgetTbl.panel_chatPanel,"panel/ScrollView/grid_text")
            componentGet(grid,"UIGrid"):Reposition()  
	   end  
	   addClickCallbackSelf(good.gameObject,this.Onbtn_chatTextClick,this)    
	   good.gameObject:SetActive(true)
	   local lab_msg=child(good.transform,"msg") 
	   componentGet(lab_msg,"UILabel").text=chatTextTab[i]		
    end 
end

local chatImgTab = {"1","2","3","4","5","6","7","8","9"}
function this.SetChatImgInfo()
	for i=1,table.getCount(chatImgTab),1 do       
       local good = child(widgetTbl.panel_chatPanel,"panel/ScrollView/grid_img/item"..tostring(i))     
	   if good==nil then 
		    local o_good = child(widgetTbl.panel_chatPanel,"panel/ScrollView/grid_img/item"..tostring(i-1)) 
		    good = GameObject.Instantiate(o_good.gameObject)
		    good.transform.parent=o_good.transform.parent 
            good.name="item"..tostring(i)
            good.transform.localScale={x=1,y=1,z=1}    
            local grid=child(widgetTbl.panel_chatPanel,"panel/ScrollView/grid_img")
            componentGet(grid,"UIGrid"):Reposition()   
	   end    
	   addClickCallbackSelf(good.gameObject,this.Onbtn_chatImgClick,this)  
	   good.gameObject:SetActive(true)
	   local sprite_msg=child(good.transform,"img") 
       componentGet(sprite_msg,"UISprite").spriteName=chatImgTab[i]
    end 
end

function this.Onbtn_chatTextClick(self, obj)
	local tItemName = obj.gameObject.name
	tItemName = string.sub(tItemName,string.len("item")+1)
	local tIndex = tonumber(tItemName)
	log(chatTextTab[tIndex])
	shisangshui_play_sys.ChatReq(1,chatTextTab[tIndex],nil)
end

function this.Onbtn_chatImgClick(self, obj)
	local tItemName = obj.gameObject.name
	tItemName = string.sub(tItemName,string.len("item")+1)
	local tIndex = tonumber(tItemName)
	log("Image name:"..chatImgTab[tIndex])
	shisangshui_play_sys.ChatReq(2,chatImgTab[tIndex],nil)
end

--显示特殊牌型的图标
function this.ShowSpecialCardIcon(tbl)
	local iconImage = special_card_type.group["special_card_type_"..tbl.viewSeat]
	iconImage.gameObject.transform.localPosition = tbl.position
	iconImage.gameObject:SetActive(true)
	
end

function this.HideSpecialCardIcon()
	for i =1 , 6 do
		special_card_type.group["special_card_type_"..i].gameObject:SetActive(false)
	end
end

--设置闲家选择倍数的超时时间
function this.SetTimeAlarm()
	if this.timerAlarm == nil then
		this.timerAlarm = Timer.New(this.ChooseMyMult,5,false)
	else
		this.timerAlarm:Reset(this.ChooseMyMult,5,false)
	end
	this.timerAlarm:Start()
end

--确认选择好倍数
function this.ChooseMyMult()
	if this.timerAlarm ~= nil then
		this.timerAlarm:Stop()
	end
	this.IsShowBeiShuiBtn(false)

end

function this.SetBeiShuBtnCount()
	local roomData = room_data.GetSssRoomDataInfo()
	for i = 1,5 do
		local child =  child( compTbl.xiapao,"pao"..tostring(i))
		if child ~= nil then
			if tonumber(i) <= tonumber(roomData.max_multiple) then
				child.gameObject:SetActive(true)
			else
				child.gameObject:SetActive(false)
			end
		end
	end
	local gridComp =  compTbl.xiapao.gameObject:GetComponent(typeof(UIGrid))
	if gridComp ~= nil then
		gridComp:Reposition()
	else
		log("===选择倍数UIGrid为空！===")
	end
end

--显示闲家倍数
function this.SetBeiShu(viewSeat, beishu)
	if this.playerList[viewSeat] ~= nil then
		this.playerList[viewSeat].SetBeiShu(beishu)
	end 
end

--[[--
 * @Description: 获取玩家  
 ]]
function this.GetPlayer(viewSeat)
	return this.playerList[viewSeat]
end

--发牌
function this.DealCard(data, callback)
	local roomData = room_data.GetSssRoomDataInfo()
	local peopleNum = roomData.people_num
	this.peoCardsTbl = {}
	this.peoCardsTbl[2] = {this.CardsTbl[1], this.CardsTbl[5]}
	this.peoCardsTbl[3] = {this.CardsTbl[1], this.CardsTbl[4], this.CardsTbl[6]}
	this.peoCardsTbl[4] = {this.CardsTbl[1], this.CardsTbl[3], this.CardsTbl[5], this.CardsTbl[7]}
	this.peoCardsTbl[5] = {this.CardsTbl[1], this.CardsTbl[2], this.CardsTbl[4], this.CardsTbl[5], this.CardsTbl[7]}
	this.peoCardsTbl[6] = {this.CardsTbl[1], this.CardsTbl[2], this.CardsTbl[3], this.CardsTbl[4], this.CardsTbl[5], this.CardsTbl[6]}
	this.peoCardsTbl[7] = this.CardsTbl
	this.curPeoCardsTbl = this.peoCardsTbl[peopleNum]
	for i = 1, peopleNum do
		this.playerList[i].CardsTbl = this.curPeoCardsTbl[i]
		for j = 1, 13 do
			this.curPeoCardsTbl[i][j] = child(widgetTbl.panel, "Anchor_Center/Players/Player"..i.."/cards/PlayerCard"..j)
			--local pos = this.CardsTbl[i][j].transform.position = Vector3.New(0, 0, 0)
			this.curPeoCardsTbl[i][j].gameObject:SetActive(true);
		end
	end
	coroutine.start(function()
		coroutine.wait(2)
		if callback ~= nil then
			callback()	
			callback = nil
		end
	end)
end

function this.CompareStart(callback)
	this.CardCompareHandler(callback)
end

--[[--
 * @Description: 牌形比较处理 
 ]]
function this.CardCompareHandler(callback)
	local scoreData = {}    --积分数据表

	local firstSort = {}    --第一次排序表
	local secondSort = {}   --第二次排序表
	local threeSort = {}    --第三次排序表
	local sortIndex = nil
	for i,v in ipairs(this.playerList) do
		sortIndex = v.compareResult["nOpenFirst"]
		table.insert(firstSort, sortIndex)
		sortIndex = v.compareResult["nOpenSecond"]
		table.insert(secondSort, sortIndex)
		sortIndex = v.compareResult["nOpenThird"]
		table.insert(threeSort, sortIndex)
	end
	table.sort(firstSort)
	table.sort(secondSort)
	table.sort(threeSort)

	--比头墩
	for j,k in ipairs(firstSort) do
		for i ,Player in ipairs(this.playerList) do
			if tonumber(Player.compareResult["nOpenFirst"]) == tonumber(k) then
				if tonumber(Player.compareResult["nSpecialType"]) < 1 then    	--检查是不是特殊牌型,特殊牌型不翻牌
					for 1, 3 do
						local tran = newNormalUI("Prefabs/Card/"..tostring(card), Player[i])
						tran.transform.localScale = Vector3.New(0.85, 0.85, 0.85)
						tran.transform.localPosition = Vector3.New(0, 0, 0)
						--Player:PlayerGroupCard("Group1")
						--local cards = Player:showFirstCardByType() 					--这里在通知UI界面显示相应排型
						--Notifier.dispatchCmd(cmdName.ShowPokerCard,cards)
					end
					coroutine.wait(1)
					break
				end
			end
		end
	end
	--这里增加一个事件，通知UI更新第一墩的积分数据
	-- scoreData.index = 1
	-- scoreData.totallScore = 0			
	-- Notifier.dispatchCmd(cmdName.First_Group_Compare_result, scoreData)
	
	--比中墩
	for j,k in ipairs(secondSort) do
		for i ,Player in ipairs(this.playerList) do
			if tonumber(Player.compareResult["nOpenSecond"]) == tonumber(k) then
				if tonumber(Player.compareResult["nSpecialType"]) < 1 then 	--检查是不是特殊牌型,特殊牌型不翻牌
					-- Player:PlayerGroupCard("Group2")
					-- local cards = Player:showSecondCardByType() 			--这里在通知UI界面显示相应排型
					-- Notifier.dispatchCmd(cmdName.ShowPokerCard, cards)

					for 4, 8 do
						local tran = newNormalUI("Prefabs/Card/"..tostring(card), Player[i])
						tran.transform.localScale = Vector3.New(0.85, 0.85, 0.85)
						tran.transform.localPosition = Vector3.New(0, 0, 0)
						--Player:PlayerGroupCard("Group1")
						--local cards = Player:showFirstCardByType() 					--这里在通知UI界面显示相应排型
						--Notifier.dispatchCmd(cmdName.ShowPokerCard,cards)
					end
					coroutine.wait(1)
					break
				end
			end
		end
	end
	--这里增加一个事件，通知UI更新第二墩的积分数据
	scoreData.index = 2
	scoreData.totallScore = 0
	Notifier.dispatchCmd(cmdName.Second_Group_Compare_result, scoreData)

	--比尾墩
	for j,k in ipairs(threeSort) do
		for i ,Player in ipairs(this.playerList) do
			if tonumber(Player.compareResult["nOpenThird"]) == tonumber(k) then
				if tonumber(Player.compareResult["nSpecialType"]) < 1 then --检查是不是特殊牌型,特殊牌型不翻牌

					for 9, 13 do
						local tran = newNormalUI("Prefabs/Card/"..tostring(card), Player[i])
						tran.transform.localScale = Vector3.New(0.85, 0.85, 0.85)
						tran.transform.localPosition = Vector3.New(0, 0, 0)
						--Player:PlayerGroupCard("Group1")
						--local cards = Player:showFirstCardByType() 					--这里在通知UI界面显示相应排型
						--Notifier.dispatchCmd(cmdName.ShowPokerCard,cards)
					end

					-- Player:PlayerGroupCard("Group3")
					-- local cards = Player:showThreeCardByType() ----这里在通知UI界面显示相应排型
					-- Notifier.dispatchCmd(cmdName.ShowPokerCard,cards)
					coroutine.wait(1)
					break
				end
			end
		end
	end
	
	--这里增加一个事件，通知UI更新第三墩的积分数据
	-- scoreData.index = 3
	-- scoreData.totallScore = 0
	-- Notifier.dispatchCmd(cmdName.Three_Group_Compare_result, scoreData)
	--总分
	-- local myPlayer = this.GetPlayer(1)
	-- local totallScore = myPlayer.compareResult["nTotallScore"]
	-- log("++++++++++++++++++totallScorefasdfsfsf++++++++++++++++++++++++++++="..tostring(totallScore))
	
	-- scoreData.index = 4
	-- scoreData.totallScore = totallScore
	-- Notifier.dispatchCmd(cmdName.Three_Group_Compare_result,scoreData)
	
	if callback ~= nil then
		callback()
		callback = nil
	end
	
	--摆牌结束，通知UI播入打枪动画跟特殊牌型动画
	--Notifier.dispatchCmd(cmdName.ShootingPlayerList,this.playerList)
	--播放打枪动画
	--this.PlayGunAnim()

	--播放特殊牌形动画		
end