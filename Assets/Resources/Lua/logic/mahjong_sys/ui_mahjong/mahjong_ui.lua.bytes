--[[--
 * @Description: mahjong game ui component
 * @Author:      ShushingWong
 * @FileName:    mahjong_ui.lua
 * @DateTime:    2017-06-19 14:30:45
 ]]

require "logic/mahjong_sys/_model/room_usersdata_center"
require "logic/mahjong_sys/_model/room_usersdata"
require "logic/mahjong_sys/_model/operatorcachedata"
require "logic/mahjong_sys/_model/operatordata"
require "logic/mahjong_sys/ui_mahjong/mahjong_ui_sys"
require "logic/mahjong_sys/ui_mahjong/mahjong_player_ui"
require "logic/animations_sys/animations_sys"
require("logic/voteQuit/vote_quit_view")
require "logic/invite_sys/invite_sys"

--房间内显示玩法待合并
--require "logic/hall_sys/chooseroom_ui/rules_ui"
--require "logic/setting/setting_ui"


mahjong_ui = ui_base.New()
local this = mahjong_ui

local transform = this.transform

local operTipEX = nil


-- 退出按钮
local function Onbtn_exitClick()


  if roomdata_center.isStart or roomdata_center.isRoundStart then
  	message_box.ShowGoldBox("牌局中无法直接退出房间，您是否想发起解散房间投票？",nil,2, {function() message_box.Close() end,
  		function ()  		
  		mahjong_play_sys.VoteDrawReq(true)
  		message_box.Close()
  	end}, {"quxiao","fonts_01"}, {"a01", "a02"})
  	
  	return
  end

  ui_sound_mgr.PlaySoundClip("common/audio_close_dialog")
  local t= GetDictString(5001)
  message_box.ShowGoldBox(t,nil,2, { function() message_box.Close() end, 
  	function ()  		
  		mahjong_play_sys.LeaveReq()
  		message_box.Close()
  	end}, {"quxiao","fonts_01"}, {"a01", "a02"})
end


-- 更多按钮
local function Onbtn_moreClick()
	print("Onbtn_moreClick")
	this.SetMorePanle()
end





-- 准备按钮
local function Onbtn_readyClick()	
	ui_sound_mgr.PlaySoundClip("common/audio_ready")
	mahjong_play_sys.ReadyGameReq()
end

-- 邀请微信好友
local function Onbtn_inviteClick()
	invite_sys.inviteFriend(roomdata_center.roomnumber,"福州麻将",roomdata_center.gameRuleStr)
end

-- 解散房间
local function Onbtn_closeRoomClick()
	 message_box.ShowGoldBox("您确定要解散房间吗？",nil,2, {function() message_box.Close() end, function ()  		
  		mahjong_play_sys.DissolutionRoom()
  		message_box.Close()
  	end}, {"quxiao","fonts_01"}, {"a01", "a02"})
end


-- 语音按钮
local function Onbtn_voiceClick()
	print("Onbtn_voiceClick")
end

-- 聊天按钮
local function Onbtn_chatClick()
	print("Onbtn_chatClick")
	this.SetChatTextInfo()
	this.SetChatImgInfo()
	this.SetChatPanle()
end

--玩法
local function Onbtn_gameplayClick()
	print("Onbtn_gameplayClick")
	local tRuleName = "zhengzhoumj"
	local tType = player_data.GetGameId()
	if tType == 1 then
		tRuleName = "zhengzhoumj"
	elseif tType == 2 then
		tRuleName = "luoyangmj"
	elseif tType == 3 then
		tRuleName = "zhumadianmj"
	end
	--fast_tip.Show("功能暂未开放")
  help_ui.Show()
	--TODO
	--rules_ui.Show(tRuleName)
end

--设置
local function Onbtn_settingClick()
	print("Onbtn_settingClick")
	setting_ui.Show()
end

--战绩
local function Onbtn_resultClick()	
	local tShow = false
	if tShow== false then
		http_request_interface.getRoomByRid(roomdata_center.rid,1,function (code,m,str)
           local s=string.gsub(str,"\\/","/")  
           local t=ParseJsonStr(s)
           print("Onbtn_resultClick()--------"..str)
           recorddetails_ui.Show(t)   
       end)
		return
	end
	print("Onbtn_resultClick")
end

--托管
local function Onbtn_machineClick()
	print("Onbtn_machineClick")
	this.SetAutoPlayInfo()
end

--更多蒙板
local function Onbtn_moreContainerClick()
	this.SetMorePanle()
end
--聊天蒙板
local function Onbtn_chatContainerClick()
	this.SetChatPanle()
end


--胡牌点击事件
local function Onbtn_huClick()
	print("Onbtn_huClick")
	local tbl = operatorcachedata.GetOpTipsTblByType(MahjongOperTipsEnum.Hu)
	print("Onbtn_huClick-------"..tostring(tbl))
	mahjong_play_sys.HuPaiReq(tbl.nCard)
end

--听牌点击事件
local function Onbtn_tingClick()
	print("Onbtn_tingClick")
	mahjong_play_sys.TingReq()
end

--杠牌点击事件
local function Onbtn_gangClick()
	print("Onbtn_gangClick")
	mahjong_play_sys.QuadrupletReq()
end

--碰牌点击事件
local function Onbtn_pengClick()
	print("Onbtn_pengClick")
	mahjong_play_sys.TripletReq()
end

-- 抢点击事件
local function Onbtn_qiangClick()
	print("Onbtn_qiangClick")
	local tbl = operatorcachedata.GetOpTipsTblByType(MahjongOperTipsEnum.Qiang)
	mahjong_play_sys.HuPaiReq(tbl.nCard)
end

--吃牌点击事件
local function Onbtn_chiClick()
	print("Onbtn_chiClick")


	local cardCanCollect = operatorcachedata.GetOpTipsTblByType(MahjongOperTipsEnum.Collect)
	if #cardCanCollect == 1 then
		mahjong_play_sys.CollectReq(cardCanCollect[1])
	else
		this.cardShowView:ShowChi(cardCanCollect)
		mahjong_ui.HideOperTips()
	end

	--cardCollect = {13,14,15}
	-- local cardCollect = {}

	-- mahjong_play_sys.CollectReq(cardCollect)
end

--过牌点击事件
local function Onbtn_guoClick()
	print("Onbtn_guoClick")
	mahjong_play_sys.GiveUp()
	mahjong_ui.HideOperTips()
end

local function Onbtn_cancelMachineClick()
	mahjong_play_sys.AutoPlayReq(false)
end

local operNameTable = {
	[1] = "hu",
	[2] = "ting",
	[3] = "gang",
	[4] = "peng",
	[5] = "chi",
	[6] = "guo",
	[7] = "qiang"
}

local operEventTable = {
	[1] = Onbtn_huClick,
	[2] = Onbtn_tingClick,
	[3] = Onbtn_gangClick,
	[4] = Onbtn_pengClick,
	[5] = Onbtn_chiClick,
	[6] = Onbtn_guoClick,
	[7] = Onbtn_qiangClick
}


local widgetTbl = {}
local compTbl = {}
local zhuanTimer = nil

local function InitCardShowView()
	this.cardShowView = require "logic/mahjong_sys/ui_mahjong/mahjong_show_card_ui"
	this.cardShowView:SetTransform(child(widgetTbl.panel, "Anchor_Center/cardShowView"))
	--this.cardShowView:ShowHu({0, {{nCard = 21, nFan = 10, nLeft = 3},{nCard = 21, nFan = 10, nLeft = 3},{nCard = 21, nFan = 10, nLeft = 3},{nCard = 21, nFan = 10, nLeft = 3},{nCard = 21, nFan = 10, nLeft = 3},{nCard = 21, nFan = 10, nLeft = 3},{nCard = 21, nFan = 10, nLeft = 3},{nCard = 21, nFan = 10, nLeft = 3},{nCard = 21, nFan = 10, nLeft = 3},{nCard = 21, nFan = 10, nLeft = 3},{nCard = 21, nFan = 10, nLeft = 3},{nCard = 21, nFan = 10, nLeft = 3},{nCard = 21, nFan = 10, nLeft = 3},{nCard = 21, nFan = 10, nLeft = 3},{nCard = 21, nFan = 10, nLeft = 3},{nCard = 21, nFan = 10, nLeft = 3}}})
	-- this.cardShowView:ShowHua(Vector3(-371.2, -217.3, 0),{1,3,4,6,7, 1,3,4,5,1,34,5,2,23,4,25,234,2345,2345,1,12,3,4,5,34,23,134,4,13}, 1)
	-- this.cardShowView:ShowHua(Vector3(-600, -30, 0),{1,3,4,6,7}, 4)
	--this.cardShowView:ShowHua(Vector3(589, -23, 0),{1,3,4,6,7}, 2)
	--this.cardShowView:ShowHua(Vector3(-279, 267, 0),{1,3,4,6,7}, 3)
end

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
    --更多面板
    widgetTbl.panel_more = child(widgetTbl.panel, "Anchor_TopRight/morePanel/bg")
    if widgetTbl.panel_more~=nil then
       widgetTbl.panel_more.gameObject:SetActive(false)
    end
    --更多面板蒙板
    widgetTbl.panel_moreContainer = child(widgetTbl.panel, "Anchor_TopRight/morePanel/bg/Container")
    if widgetTbl.panel_moreContainer~=nil then
       addClickCallbackSelf(widgetTbl.panel_moreContainer.gameObject,Onbtn_moreContainerClick,this)
   	end

    --准备按钮
	widgetTbl.btn_ready = child(widgetTbl.panel, "Anchor_Center/readyBtns/ready")
	if widgetTbl.btn_ready~=nil then
       addClickCallbackSelf(widgetTbl.btn_ready.gameObject,Onbtn_readyClick,this)
    end

    -- 邀请按钮
    widgetTbl.btn_invite = child(widgetTbl.panel, "Anchor_Center/readyBtns/invideFriend")
    if widgetTbl.btn_invite ~= nil then
    	addClickCallbackSelf(widgetTbl.btn_invite.gameObject, Onbtn_inviteClick)
    end

    -- 解散房间按钮
    widgetTbl.btn_closeRoom = child(widgetTbl.panel, "Anchor_Center/readyBtns/closeRoom")
    if widgetTbl.btn_closeRoom ~= nil then
    	addClickCallbackSelf(widgetTbl.btn_closeRoom.gameObject, Onbtn_closeRoomClick)
    end

    --语音按钮
	widgetTbl.btn_voice = child(widgetTbl.panel, "Anchor_Right/voice")
	if widgetTbl.btn_voice~=nil then
       addClickCallbackSelf(widgetTbl.btn_voice.gameObject,Onbtn_voiceClick,this)
       widgetTbl.btn_voice.gameObject:SetActive(false)
    end
    --聊天按钮
	widgetTbl.btn_chat = child(widgetTbl.panel, "Anchor_Right/chat")
	if widgetTbl.btn_chat~=nil then
       addClickCallbackSelf(widgetTbl.btn_chat.gameObject,Onbtn_chatClick,this)
       widgetTbl.btn_chat.gameObject:SetActive(true)
    end
    --玩法按钮
	widgetTbl.btn_gameplay = child(widgetTbl.panel, "Anchor_TopRight/morePanel/bg/gameplay")
	if widgetTbl.btn_gameplay~=nil then
       addClickCallbackSelf(widgetTbl.btn_gameplay.gameObject,Onbtn_gameplayClick,this)
       widgetTbl.btn_gameplay.gameObject:SetActive(true)
    end
    --设置按钮
	widgetTbl.btn_setting = child(widgetTbl.panel, "Anchor_TopRight/morePanel/bg/setting")
	if widgetTbl.btn_setting~=nil then
       addClickCallbackSelf(widgetTbl.btn_setting.gameObject,Onbtn_settingClick,this)
       widgetTbl.btn_setting.gameObject:SetActive(true)
    end
    --战绩按钮
	widgetTbl.btn_result = child(widgetTbl.panel, "Anchor_TopRight/morePanel/bg/result")
	if widgetTbl.btn_result~=nil then
       addClickCallbackSelf(widgetTbl.btn_result.gameObject,Onbtn_resultClick,this)
       widgetTbl.btn_result.gameObject:SetActive(true)
    end
    --托管按钮
	widgetTbl.btn_machine = child(widgetTbl.panel, "Anchor_TopRight/morePanel/bg/machine")
	if widgetTbl.btn_machine~=nil then
       addClickCallbackSelf(widgetTbl.btn_machine.gameObject,Onbtn_machineClick,this)
       --widgetTbl.btn_machine.gameObject:SetActive(true)
    end
    --托管面板
    widgetTbl.panel_machine = child(widgetTbl.panel, "Anchor_Bottom/machine")
	if widgetTbl.panel_machine~=nil then
		widgetTbl.panel_machine_btn = child(widgetTbl.panel, "Anchor_Bottom/machine/btn")
       addClickCallbackSelf(widgetTbl.panel_machine_btn.gameObject,Onbtn_cancelMachineClick,this)
       widgetTbl.panel_machine.gameObject:SetActive(false)
    end
    --房间号
    widgetTbl.roomNumLabel = subComponentGet(widgetTbl.panel, "Anchor_TopLeft/roomNum", typeof(UILabel))
    --玩法房号
    print("----------------------------------------------------label_gameinfo")
	widgetTbl.label_gameinfo = child(widgetTbl.panel, "Anchor_Bottom/gameInfo")
	if widgetTbl.label_gameinfo~=nil then
       widgetTbl.label_gameinfo.gameObject:SetActive(false)
    end

    --wifi状态
    widgetTbl.sprite_network = componentGet(child(widgetTbl.panel,"Anchor_TopLeft/phoneInfo/network"),"UISprite")
    --电池状态
    widgetTbl.sprite_power = componentGet(child(widgetTbl.panel,"Anchor_TopLeft/phoneInfo/power"),"UISprite")   

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
    --剩余牌数
    widgetTbl.leftCard = child(widgetTbl.panel,"Anchor_Center/gameInfo/leftCardInfo/leftCard")
    --局数
    widgetTbl.roundNum = child(widgetTbl.panel, "Anchor_Center/gameInfo/roundInfo/round")
    --结算面板
    widgetTbl.rewards_panel = child(widgetTbl.panel,"Anchor_Center/rewards")
    if widgetTbl.rewards_panel~=nil then
    	this.FindChild_Rewards()
        widgetTbl.rewards_panel.gameObject:SetActive(false)
    end

    widgetTbl.zhuanTips = child(widgetTbl.panel, "Anchor_Center/zhuanTips")
    widgetTbl.zhuanTips.gameObject:SetActive(false)

    --玩家信息
    this.playerList = {}
    for i=1,4 do
    	local playerTrans = child(widgetTbl.panel, "Anchor_Center/Players/Player"..i)
    	if playerTrans ~= nil then
    		local playerComponent = mahjong_player_ui.New(playerTrans)
        if roomdata_center.MaxPlayer() == 2 and (i == 2 or i == 4 ) then
    		  
        else
          table.insert(this.playerList, playerComponent)
        end
    		playerTrans.gameObject:SetActive(false)
    	end
    end



    --下跑
    compTbl.xiapao = child(widgetTbl.panel, "Anchor_Center/xiapao")
	if compTbl.xiapao~=nil then
		for i=0,3 do
			local btn_xiapao = child(compTbl.xiapao, "pao"..i)
			addClickCallbackSelf(btn_xiapao.gameObject,

			function ()
				mahjong_play_sys.XiaPaoReq(i,room_usersdata_center.GetMyLogicSeat())
			end,
			this)
		end
       compTbl.xiapao.gameObject:SetActive(false)
    end
 	compTbl.gameInfos = child(widgetTbl.panel, "Anchor_Center/gameInfo")
 	if compTbl.gameInfos ~= nil then
 		--compTbl.gameInfos.localPosition = Utils.WorldPosToScreenPos(Vector3(0, 0.64, 0))
 		-- compTbl.gameInfos.gameObject:SetActive(false)
 	end

 	compTbl.readyBtns = child(widgetTbl.panel, "Anchor_Center/readyBtns")
 	if compTbl.readyBtns ~= nil then
 		compTbl.readyBtns.gameObject:SetActive(true)
 	end


    --吃碰杠胡提示
    compTbl.opertips = child(widgetTbl.panel, "Anchor_Center/opertips")
	if compTbl.opertips~=nil then
		compTbl.opertips.operBtnsList = {}
		for i=1,#operNameTable do
			local btn_oper = child(compTbl.opertips, "Grid/"..operNameTable[i])
			addClickCallbackSelf(btn_oper.gameObject,

			function ()
				operEventTable[i]()
			end,
			this)

			compTbl.opertips.operBtnsList[operNameTable[i]] = btn_oper
		end

       compTbl.opertips.gameObject:SetActive(false)
    end
    
    --癞子
	compTbl.laizi = child(widgetTbl.panel, "Anchor_TopLeft/lai")
	if compTbl.laizi~=nil then
       compTbl.laizi.gameObject:SetActive(false)
    end

    --荒庄
    compTbl.huang = child(widgetTbl.panel, "Anchor_Center/huang")
    if compTbl.huang~=nil then
    	compTbl.huangSpriteTrans = child(compTbl.huang, "Sprite")
    	compTbl.huang.gameObject:SetActive(false)
    end

    InitCardShowView()
    InitVoteView()
    this.SetGameInfoVisible(false)
    this.SetAllHuaPointVisible(false)
    this.SetAllScoreVisible(false)
    this.HideAllReadyBtns()
end


function this.GetTransform()
	return widgetTbl.panel
end

local function Onbtn_rewardsBackClick()
	this.HideRewards()
	this.ShowReadyBtns()
end

function this.FindChild_Rewards()
	widgetTbl.rewards_back = child(widgetTbl.rewards_panel,"back")
	if widgetTbl.rewards_back~=nil then
       addClickCallbackSelf(widgetTbl.rewards_back.gameObject, Onbtn_rewardsBackClick, this)
    end
	--开始下一局
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
      if roomdata_center.MaxPlayer() == 2 and (i == 2 or i == 4 ) then
        
      else
        table.insert(widgetTbl.rewards_splayers,p)
      end
    	p.rewards_player.gameObject:SetActive(false)
    end

    widgetTbl.rewards_bplayers = {}
    for i=1,4 do
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
    	p.rewards_player_grid = child(p.rewards_player_scrollView,"Grid")
      if roomdata_center.MaxPlayer() == 2 and (i == 2 or i == 4 ) then
        
      else
        table.insert(widgetTbl.rewards_bplayers,p)
      end
    	p.rewards_player.gameObject:SetActive(false)
    end
end

function this.Awake()
	InitWidgets()
	mahjong_ui_sys.Init()
	msg_dispatch_mgr.SetIsEnterState(true)	
end

function this.Start()
	this.InitBatteryAndSignal()
end

function this.OnDestroy()
	if zhuanTimer ~= nil then
		zhuanTimer:Stop()
		zhuanTimer = nil
	end
	for i = 1, #this.playerList do
		this.playerList[i].OnDestroy()
	end
	this.playerList = {}
	widgetTbl = {}
	compTbl = {}	
	mahjong_ui_sys.UInit()

	this.UnInitBatteryAndSignal()
end

--显示准备按钮



function this.SetReadyBtnVisible(value)
	widgetTbl.btn_ready.gameObject:SetActive(value)
end

--邀请好友
function this.SetInviteBtnVisible(value)
	widgetTbl.btn_invite.gameObject:SetActive(value)
end

function this.SetCloseBtnVisible(value)
	widgetTbl.btn_closeRoom.gameObject:SetActive(value)
end


-- 打开准备相关按钮
function this.ShowReadyBtns()
	local isFirstJu = not roomdata_center.isRoundStart
	this.SetReadyBtnVisible(true)
	this.SetInviteBtnVisible(isFirstJu)
	isRoomOwner = room_usersdata_center.GetMyLogicSeat() == 1
	this.SetCloseBtnVisible(isRoomOwner and isFirstJu)
	if isRoomOwner then
		LuaHelper.SetTransformLocalX(widgetTbl.btn_invite, 103)
		if isFirstJu then
			LuaHelper.SetTransformLocalX(widgetTbl.btn_closeRoom, -103)
		else
			LuaHelper.SetTransformLocalX(widgetTbl.btn_closeRoom, 0)
		end
	else
		LuaHelper.SetTransformLocalX(widgetTbl.btn_invite, 0)
	end
end

function this.HideAllReadyBtns()
	this.SetReadyBtnVisible(false)
	this.SetInviteBtnVisible(false)
	this.SetCloseBtnVisible(false)
end


function this.ShowHeadEffect(viewSeat)
	return animations_sys.PlayLoopAnimation(this.playerList[viewSeat].head, "anim_head_eff", "head aperture", 100, 100)
end



-- function  this.ShowReadyBtn(isRoomOwner)
-- 	-- widgetTbl.btn_ready.gameObject:SetActive(true)
-- 	isRoomOwner = room_usersdata_center.GetMyLogicSeat() == 1
-- 	compTbl.readyBtns.gameObject:SetActive(true)
-- 	widgetTbl.btn_ready.gameObject:SetActive(true)
-- 	widgetTbl.btn_closeRoom.gameObject:SetActive(isRoomOwner or false)
-- end

-- --隐藏准备按钮
-- function  this.HideReadyBtn()



-- 	-- widgetTbl.btn_ready.gameObject:SetActive(false)
-- 	-- compTbl.readyBtns.gameObject:SetActive(false)
-- 	widgetTbl.btn_ready:SetActive(false)
-- end

function this.SetGameInfoVisible(value)
	if compTbl.gameInfos ~= nil then
		compTbl.gameInfos.gameObject:SetActive(value or false)
	end
end

function this.GetPlayerHuaPointPos(viewSeat)
	local player = this.playerList[viewSeat]
	if player == nil then
		return nil
	else
		return player.GetHuaPointPos()
	end
end

function this.ShowUIAnimation(animationPrefab, animationName)
	animations_sys.PlayAnimation(widgetTbl.panel,animationPrefab,animationName,100,100,false,function(  ) end)
end

--[[--
 * @Description: 设置玩法、房号  
 * @param:       wanfaStr 玩法  RoomNum 房号
 * @return:      nil
 ]]



function  this.SetGameInfo(RoomNum)
	-- local str = wanfaStr.." | "..RoomNum
	-- if widgetTbl.label_gameinfo_comp == nil then
	-- 	widgetTbl.label_gameinfo_comp = widgetTbl.label_gameinfo.gameObject:GetComponent(typeof(UILabel))
	-- end
	-- widgetTbl.label_gameinfo_comp.text = str
	-- widgetTbl.label_gameinfo.gameObject:SetActive(true)
	widgetTbl.roomNumLabel.text = "房号:" .. RoomNum
end

-- 更新玩家花牌数量
function this.SetFlowerCardNum(viewSeat, count)
	if this.playerList[viewSeat] ~= nil then
		this.playerList[viewSeat].SetRoomCardNum(count)
	end

end

function this.SetMorePanle()
	if widgetTbl.panel_more.gameObject.activeSelf == true then
		widgetTbl.panel_more.gameObject:SetActive(false)
	else
		widgetTbl.panel_more.gameObject:SetActive(true)
	end
end

function this.SetChatPanle()
	if widgetTbl.panel_chatPanel.gameObject.activeSelf == true then
		widgetTbl.panel_chatPanel.gameObject:SetActive(false)
	else
		widgetTbl.panel_chatPanel.gameObject:SetActive(true)
	end
end

function this.HideChatPanel()
	widgetTbl.panel_chatPanel.gameObject:SetActive(false)
end

function this.InitBatteryAndSignal()
	--监听电量及网络信号强度
    YX_APIManage.Instance.batteryCallBack = function(msg)
    	local msgTable = ParseJsonStr(msg)
    	local precent = tonumber(msgTable.percent)	
    	print("battery:"..precent)	
		this.SetPowerState(precent)
    end

    YX_APIManage.Instance.signalCallBack = function(msg)
    	local msgTable = ParseJsonStr(msg)
    	local precent = tonumber(msgTable.percent)	
    	print("signal:"..precent)		
		this.SetNetworkState(precent)
    end
end

function this.UnInitBatteryAndSignal()
	YX_APIManage.Instance.batteryCallBack = nil
	YX_APIManage.Instance.signalCallBack = nil
end

function this.SetNetworkState(value)
	local spName = ""
	if value > 0.75 then
		spName = "paiju_13"
	elseif value >0.5 then
		spName = "paiju_14"
	elseif value >0.25 then
		spName = "paiju_15"
	else 
		spName = "paiju_16"
	end
	widgetTbl.sprite_network.spriteName = spName
end

function this.SetPowerState(value)
	local spName = ""
	if value > 0.8 then
		spName = "paiju_17"
	elseif value >0.6 then
		spName = "paiju_18"
	elseif value >0.4 then
		spName = "paiju_19"
	elseif value >0.2 then
		spName = "paiju_20"
	else 
		spName = "paiju_21"
	end
	widgetTbl.sprite_power.spriteName = spName
end

local autoPlay = false
function this.SetAutoPlayInfo()
	if autoPlay == false then
		autoPlay = true
	else
		autoPlay = false
	end
	mahjong_play_sys.AutoPlayReq(autoPlay)
end

local chatTextTab = {"快点出牌，别浪费时间。","你们是一起的吗？","我要的牌怎么还不来？","哎呀，这个牌来丫好。","完了，出错牌了。","今天手气真差，一张好牌都没有。","哇，你们这个牌也太好了。","丫霸！怎么又是你胡了。","再打一盘我先走啦，大家慢慢卡溜。"}
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

local chatImgTab = {"1","2","3","4","5","6","7","8","9","10","11","12"}
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
	print(chatTextTab[tIndex])
	mahjong_play_sys.ChatReq(1,chatTextTab[tIndex],nil)
end

function this.Onbtn_chatImgClick(self, obj)
	local tItemName = obj.gameObject.name
	tItemName = string.sub(tItemName,string.len("item")+1)
	local tIndex = tonumber(tItemName)
	print("Image name:"..chatImgTab[tIndex])
	mahjong_play_sys.ChatReq(2,chatImgTab[tIndex],nil)
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
    if viewSeat ==  1 then
		  this.HideChatPanel()
    end
	elseif contentType == 3 then
		--语音聊天
	elseif contentType == 4 then
		--玩家互动
		this.playerList[givewho].ShowInteractinAnimation(viewSeat,content)	
	end
end

-- 剩余牌数
function this.SetLeftCard( num )

	if widgetTbl.leftCard_comp == nil then
		widgetTbl.leftCard_comp = widgetTbl.leftCard.gameObject:GetComponent(typeof(UILabel))
	end

	widgetTbl.leftCard_comp.text = num
end

--设置玩家信息
function this.SetPlayerInfo( viewSeat, usersdata)
	if this.playerList[viewSeat] ~= nil then
		this.playerList[viewSeat].Show(usersdata, viewSeat)
	end
end

function this.SetAllHuaPointVisible(value)
	for i = 1, #this.playerList do
		this.playerList[i].SetHuaPointVisible(value)
	end
end

function this.SetAllScoreVisible(value)
	for i = 1, #this.playerList do
		this.playerList[i].SetScoreVisible(value)
	end
end

--隐藏玩家信息
function this.HidePlayer(viewSeat)
	if this.playerList[viewSeat] ~= nil then
		this.playerList[viewSeat].Hide()
	end
end

--设置托管状态
function this.SetPlayerMachine(viewSeat, isMachine )
	if this.playerList[viewSeat] ~= nil then
		this.playerList[viewSeat].SetMachine(isMachine)
	end
end

--设置玩家在线状态
function this.SetPlayerLineState(viewSeat, isOnLine )
	if this.playerList[viewSeat] ~= nil then
		this.playerList[viewSeat].SetOffline(not isOnLine)
	end
end

--更新玩家金币

function this.SetPlayerCoin( viewSeat,value)
	if this.playerList[viewSeat] ~= nil then
		--this.playerList[viewSeat].SetScore(value)
	end
end


--更新玩家分数
function this.SetPlayerScore( viewSeat,value)
	if this.playerList[viewSeat] ~= nil then
		this.playerList[viewSeat].SetScore(value)
	end
end


--设置玩家准备状态
function this.SetPlayerReady( viewSeat,isReady )
	--print("viewSeat-------------------------------------"..tostring(viewSeat))
	if this.playerList[viewSeat] ~= nil then
		this.playerList[viewSeat].SetReady(isReady)
	end
end

function this.SetShoot()
	if this.playerList[viewSeat] ~= nil then
		return this.playerList[viewSeat].ShootTran
	end
end

--[[--
 * @Description: 定庄  
 * @param:       viewSeat 视图座位号 
 * @return:      nil
 ]]
function this.SetBanker( viewSeat )
	if this.playerList[viewSeat] ~= nil then
		this.playerList[viewSeat].SetBanker(true)
	end
end


function this.SetRoundInfo(cur, total)
	total = total or 4
	if widgetTbl.roundNum_comp == nil then
		widgetTbl.roundNum_comp = widgetTbl.roundNum.gameObject:GetComponent(typeof(UILabel))
	end
	widgetTbl.roundNum_comp.text = "局数:[FFEAAFFF]" .. cur .. "/" .. total .. "[-]"
end


--显示下跑按钮
function this.ShowXiaPaoBtn()
	compTbl.xiapao.gameObject:SetActive(true)
end

--显示下跑按钮
function this.HideXiaPaoBtn()
	compTbl.xiapao.gameObject:SetActive(false)
end

--[[--
 * @Description: 设置所有玩家下跑倍数  
 * @param:       viewSeat 视图座位号 beishu 倍数
 * @return:      nil
 ]]
function this.SetXiaoPao( viewSeat,beishu )
	--for i=1,#this.playerList do
	if this.playerList[viewSeat] ~= nil then
		this.playerList[viewSeat].SetPao(beishu)
	end
	--end
end

--隐藏所有吓跑
function this:HideAllXiaPao()
	for i=1,#this.playerList do
		this.playerList[i].HidePao()
	end
end

--显示混牌
function this.ShowHunPai( value )
	if compTbl.laizi_comp == nil then
		compTbl.laizi_comp = child(compTbl.laizi,"card_bg/card").gameObject:GetComponent(typeof(UISprite))
	end
	compTbl.laizi_comp.spriteName = value.."_hand"
	compTbl.laizi.gameObject:SetActive(true)
end

--隐藏混牌
function this.HideHunPai()
	compTbl.laizi.gameObject:SetActive(false)
end

--[[--
 * @Description: 
 * MahjongOperTipsEnum = {
    None                = 0x0001,
    GiveUp              = 0x0002,--过,
    Collect             = 0x0003,--吃,
    Triplet             = 0x0004,--碰,
    Quadruplet          = 0x0005,--杠,
    Ting                = 0x0006,--听,
    Hu                  = 0x0007,--胡,
}

local operNameTable = {
	[1] = "hu",
	[2] = "ting",
	[3] = "gang",
	[4] = "peng",
	[5] = "chi",
	[6] = "guo",
}
  
 ]]
--显示操作提示
function this.ShowOperTips()

	if operTipEX~=nil then
		animations_sys.StopPlayAnimation(operTipEX)
	end

	local ol = operatorcachedata.GetOperTipsList()
	local ShowList = {}

	for i,v in pairs(compTbl.opertips.operBtnsList) do
		v.gameObject:SetActive(false)
	end

	for i,v in ipairs(ol) do
		repeat
	        if v.operType == MahjongOperTipsEnum.GiveUp then
				compTbl.opertips.operBtnsList["guo"].gameObject:SetActive(true)
				table.insert(ShowList,compTbl.opertips.operBtnsList["guo"])
				break
			end
			if v.operType == MahjongOperTipsEnum.Collect then
				compTbl.opertips.operBtnsList["chi"].gameObject:SetActive(true)
				table.insert(ShowList,compTbl.opertips.operBtnsList["chi"])
				break
			end
			if v.operType == MahjongOperTipsEnum.Triplet then
				compTbl.opertips.operBtnsList["peng"].gameObject:SetActive(true)
				table.insert(ShowList,compTbl.opertips.operBtnsList["peng"])
				break
			end
			if v.operType == MahjongOperTipsEnum.Quadruplet then
				compTbl.opertips.operBtnsList["gang"].gameObject:SetActive(true)
				table.insert(ShowList,compTbl.opertips.operBtnsList["gang"])
				break
			end
			if v.operType == MahjongOperTipsEnum.Ting then
				compTbl.opertips.operBtnsList["ting"].gameObject:SetActive(true)
				table.insert(ShowList,compTbl.opertips.operBtnsList["ting"])
				break
			end
			if v.operType == MahjongOperTipsEnum.Hu then
				compTbl.opertips.operBtnsList["hu"].gameObject:SetActive(true)
				table.insert(ShowList,compTbl.opertips.operBtnsList["hu"])
				break
			end
			if v.operType == MahjongOperTipsEnum.Qiang then
				compTbl.opertips.operBtnsList["qiang"].gameObject:SetActive(true)
				table.insert(ShowList,compTbl.opertips.operBtnsList["qiang"])
				break
			end
			break
    	until true
	end

	for i=1,#ShowList do

		ShowList[i].localPosition = Vector3(-130*(#ShowList-i),0,0)
	end

	operTipEX = animations_sys.PlayAnimationWithLoop(ShowList[1],"circle","chi",100,100)

	compTbl.opertips.gameObject:SetActive(true)
end

--隐藏操作提示
function this.HideOperTips()
	compTbl.opertips.gameObject:SetActive(false)
end

--游戏结束
function this.GameEnd()
	this.cardShowView:Hide()
	this.cardShowView:ShowHuBtn(false)
	this.SetAllHuaPointVisible(false)
	this.SetAllScoreVisible(false)
end

--重置所有状态，用于游戏结束后
function this.ResetAll()
	for i=1,#this.playerList do
		this.playerList[i].SetBanker(false)
		this.playerList[i].SetRoomCardNum(0)
	end
	--this.HideAllXiaPao()
	this.HideRewards()
	--this.HideHunPai()
	this.SetGameInfoVisible(false)
	this.cardShowView:Hide()
	this.cardShowView:ShowHuBtn(false)
	-- this.HideAllReadyBtns()
end

function this.ShowZhuanTips()
	if zhuanTimer ~= nil then
		zhuanTimer:Stop()
	end
	if widgetTbl.zhuanTips ~= nil then
		widgetTbl.zhuanTips.gameObject:SetActive(true)
		zhuanTimer = Timer.New(function ()
			if widgetTbl.zhuanTips ~= nil then
				widgetTbl.zhuanTips.gameObject:SetActive(false)
			end
			zhuanTimer = nil
			-- body
		end, 1)
		zhuanTimer:Start()
	end
end

--[[--
 * @Description: 
 * tbl = {
 * [1] = {"name" = "123","point" = 500}
 * [2] = {"name" = "123","point" = 500}
 * }  
 ]]
function this.SetRewards( tbl ,win_viewSeat,isBigReward,t_rid)
  if isBigReward then
    bigSettlement_ui.Init(t_rid)
    addClickCallbackSelf(widgetTbl.rewards_ready.gameObject, function ()
      this.HideRewards()
      bigSettlement_ui.Show(t_rid)
    end, this) 
  else
    addClickCallbackSelf(widgetTbl.rewards_ready.gameObject, Onbtn_readyClick, this)
  end
  print("SetRewards----------")
	widgetTbl.rewards_panel.gameObject:SetActive(true)


	 for i=1,roomdata_center.MaxPlayer() do
	 	local p = widgetTbl.rewards_splayers[i]
	 	--昵称
	 	if p.rewards_player_name_comp == nil then
	 		p.rewards_player_name_comp = p.rewards_player_name:GetComponent(typeof(UILabel))
	 	end
	 	p.rewards_player_name_comp.text = tbl[i].name
	 	--金币
	 	if p.rewards_player_point_comp == nil then
	 		p.rewards_player_point_comp = p.rewards_player_point:GetComponent(typeof(UILabel))
	 	end 

	 	p.rewards_player_point_comp.text = tbl[i].point
	 	--庄
	 	if tbl[i].isBanker then
	 		p.rewards_player_zhuang.gameObject:SetActive(true)
    else
      p.rewards_player_zhuang.gameObject:SetActive(false)
	 	end
	 	--头像
	 	if p.rewards_player_headTexture==nil then
			p.rewards_player_headTexture = p.rewards_player_head.gameObject:GetComponent(typeof(UITexture))
		end
		mahjong_ui_sys.GetHeadPic(p.rewards_player_headTexture,tbl[i].url)
		--大信息框
	 	if i==win_viewSeat then
	 		local bp = widgetTbl.rewards_bplayers[i]
	 		--昵称
		 	if bp.rewards_player_name_comp == nil then
		 		bp.rewards_player_name_comp = bp.rewards_player_name:GetComponent(typeof(UILabel))
		 	end
		 	bp.rewards_player_name_comp.text = tbl[i].name
		 	--金币
		 	if bp.rewards_player_point_comp == nil then
		 		bp.rewards_player_point_comp = bp.rewards_player_point:GetComponent(typeof(UILabel))
		 	end 
		 	bp.rewards_player_point_comp.text = tbl[i].point
		 	--庄
		 	if tbl[i].isBanker then
		 		bp.rewards_player_zhuang.gameObject:SetActive(true)
      else
        bp.rewards_player_zhuang.gameObject:SetActive(false)
		 	end
		 	--头像
		 	if bp.rewards_player_headTexture==nil then
				bp.rewards_player_headTexture = bp.rewards_player_head.gameObject:GetComponent(typeof(UITexture))
			end
			bp.rewards_player_headTexture.gameObject:SetActive(true)
			mahjong_ui_sys.GetHeadPic(bp.rewards_player_headTexture,tbl[i].url)
			--积分内容
			--p.rewards_player_itemEx = child(p.rewards_player,"itemEx")
    		--p.rewards_player_scrollView = child(p.rewards_player,"Scroll View")

    		destroyAllChild(bp.rewards_player_grid)

			for i,v in ipairs(tbl[i].scoreItem) do
				local item = newobject(bp.rewards_player_itemEx.gameObject)
				item.transform.parent = bp.rewards_player_grid
				item.transform.localScale = Vector3.one
				local des = child(item.transform,"des")
				des.gameObject:GetComponent(typeof(UILabel)).text = v.des
				local num = child(item.transform,"num")
				num.gameObject:GetComponent(typeof(UILabel)).text = v.num
				local p_des = child(item.transform,"p")
				p_des.gameObject:GetComponent(typeof(UILabel)).text = v.p
				item.gameObject:SetActive(true)
			end
			bp.rewards_player_grid:GetComponent(typeof(UIGrid)).enabled = true
		 	
		 	p.rewards_player.gameObject:SetActive(false)
		 	bp.rewards_player.gameObject:SetActive(true)
		 else
		 	local bp = widgetTbl.rewards_bplayers[i]
		 	p.rewards_player.gameObject:SetActive(true)
		 	bp.rewards_player.gameObject:SetActive(false)
		end

	 end
end

function this.HideRewards()
	widgetTbl.rewards_panel.gameObject:SetActive(false)
end


function this.ShowHuang(callback)
	compTbl.huangSpriteTrans.localPosition = Vector3(0,500,0)
	compTbl.huangSpriteTrans:DOLocalMove(Vector3(0,100,0),1,false):SetEase(DG.Tweening.Ease.OutBounce):OnComplete(function()
		callback()
		compTbl.huang.gameObject:SetActive(false)
	end)
	compTbl.huang.gameObject:SetActive(true)
end

