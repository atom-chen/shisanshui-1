
require "logic/shisangshui_sys/card_define"
require "logic/shisangshui_sys/large_result/large_result"
require "logic/shisangshui_sys/special_card_show/special_card_show"
require "logic/framework/data_center"
require "logic/shisangshui_sys/card_data_manage"

small_result = ui_base.New()
local this = small_result
local transform

--计时间Lbl
local timeLbl
--最大等待时间
local timeSecond = 0

local cardGrid = {}

local isEnterTotalResult = false
local fangzhuId

function this.Awake()
   this.initinfor()   
  	--this.registerevent() 
end

function this.Show(result)
	log("显示小结算界面")
	special_card_show.Hide()	----隐藏特殊牌型
	timeSecond = Time.time + 2
	fangzhuId = card_data_manage.roomMasterUid	------房主ID
	log("房主ID：".. fangzhuId)
	local stRewards = result["rewards"]
	if stRewards == nil then
		log("stRewards == nil")
	end
	if this.gameObject==nil then
		require ("logic/shisangshui_sys/small_result/small_result")
		this.gameObject=newNormalUI("Prefabs/UI/SmallResult/small_result")
	else
		GameObject.Destroy(this.gameObject)
        this.gameObject=nil
	end
	this.RnoInfo()
	this.LoadAllResult(stRewards)
	room_data.GetSssRoomDataInfo().cur_playNum = result["curr_ju"] +  1
	log("+++++++++++++++++++++++++++当前局++++++++++++++++++++"..tostring(room_data.GetSssRoomDataInfo().cur_playNum))
	if result["ju_num"] == result["curr_ju"] then
		isEnterTotalResult = true
		shisangshui_play_sys.Uninitialize()	
	else
		isEnterTotalResult = false
	end
end

--[[--
 * @Description: 逻辑入口  
 ]]
function this.Start()
	this.registerevent()
end


--[[--
 * @Description: 销毁  
 ]]
function this.OnDestroy()
end

function this.initinfor()
	this.registerevent()
	log("small_result initinfor")
	end
	
	

function this.Hide()
	room_data.SetReadyTime(0)
	if this.gameObject == nil then
		return
	else
		GameObject.Destroy(this.gameObject)
		this.gameObject = nil
	end
end

function this.RnoInfo()
	local roomInfo = room_data.GetSssRoomDataInfo()
	local rnoLbl = componentGet(child(this.transform,"Panel/Top/rno"), "UILabel")
	rnoLbl.text = tostring(roomInfo.rno)
	local roundLbl = componentGet(child(this.transform,"Panel/Top/round"), "UILabel")
	roundLbl.text = roomInfo.cur_playNum.."/"..roomInfo.play_num
	local roundLbl = componentGet(child(this.transform,"Panel/Top/nowTime"), "UILabel")
	roundLbl.text = ""
end



function this.LoadAllResult(result)
	local tbSort={}
	local selfId = data_center.GetLoginRetInfo().uid
	for i = 1, 6 do
		if result[i] ~= nil then
				-------非主机的其他用户----------
			if selfId ~= result[i]._uid then	
				log("判断是否本机"..selfId.."???"..result[i]._uid)
				table.insert(tbSort,result[i])
				--------主机用户放在首位---------
			else	
				log("判断:"..selfId .. "等于" .. result[i]._uid)
				local NameLbl = componentGet(child(this.transform,"Panel/Self/user/namelbl"), "UILabel") ----用户名设置
				local IDLbl = componentGet(child(this.transform,"Panel/Self/user/IDlbl"), "UILabel")
				
				IDLbl.text="ID:"..result[i]._uid			
				cardGrid = child(this.transform, "Panel/Self/user/cards")
				if cardGrid == nil then
					log("cardGrid == nil")
					return
				end
				
				for k, v in ipairs(result[i].stCards) do
					local cardObj =  newNormalUI("Prefabs/Card/"..tostring(v), cardGrid)
					if cardObj ~= nil then
					cardObj.transform.localScale = Vector3(0.3,0.3,0.3)
					componentGet(cardObj, "BoxCollider").enabled = false
					end
				end

				local gunNum = result[i].nShootNums
				for k = 1, 6 do
					if k <= gunNum then
						child(this.transform,"Panel/Self/user/gun"..k).gameObject:SetActive(true)
					else
						child(this.transform,"Panel/Self/user/gun"..k).gameObject:SetActive(false)
					end
				end
				
				local tex_photo= componentGet(child(this.transform, "Panel/Self/user/picFrame"), "UITexture")
                log("---------------------------------------------------------------------------") 
                local number= room_usersdata_center.GetLogicSeatByStr(result[i]._chair)
				local userData =room_usersdata_center.GetUserByLogicSeat(tonumber(number))
				
--                hall_data.getuserimage(tex_photo,2,room_usersdata_center.GetUserByLogicSeat(number).headurl)
                log("---------------------------------------------------------------------------")
				NameLbl.text = userData.name
				
				if result[i].nSpecialType~=nil then
					local SpecialSprite=componentGet(child(this.transform, "Panel/Self/user/specialCard"), "UISprite")
					if result[i].nSpecialType ~=0 then
						log("特殊牌型索引"..result[i].nSpecialType)
						SpecialSprite.spriteName = result[i].nSpecialType					
					else
						SpecialSprite.gameObject:SetActive(false)
					end
				else
					log("result["..i.."].nSpecialType=nil")
				end
				local ScoreLbl = componentGet(child(this.transform, "Panel/Self/user/scorelbl"), "UILabel")
				local negScoreLbl = componentGet(child(this.transform, "Panel/Self/user/negscorelbl"), "UILabel")
				local totalScores=result[i].all_score
				if totalScores<=0 then
					negScoreLbl.gameObject:SetActive(true)
					ScoreLbl.gameObject:SetActive(false)
					negScoreLbl.text ="得分:"..tostring(totalScores)
				else
					negScoreLbl.gameObject:SetActive(false)
					ScoreLbl.gameObject:SetActive(true)
					ScoreLbl.text ="得分:+"..tostring(totalScores)
				end
				------------判断本机用户是否房主-----------------------
				local fangzhu = componentGet(child(this.transform, "Panel/Self/user/fangzhu"), "UISprite")	
				if selfId == fangzhuId then	
					fangzhu.gameObject:SetActive(true)
				else
					fangzhu.gameObject:SetActive(false)
				end
			end
		end
	end
	this.ShowOthersResult(tbSort)
end


--------------------显示客机用户的结算数据-----------------
function this.ShowOthersResult(tbSort)
	table.sort(tbSort,function (a,b) return a.all_score > b.all_score end)			
		for i=1,5 do
			if tbSort[i] ~= nil then 
				local NameLbl = componentGet(child(this.transform,"Panel/resultList/userGrid/user"..i.."/namelbl"), "UILabel") ----用户名设置
				local IDLbl = componentGet(child(this.transform,"Panel/resultList/userGrid/user"..i.."/IDlbl"), "UILabel")		
				IDLbl.text="ID:"..tbSort[i]._uid				
				cardGrid = child(this.transform, "Panel/resultList/userGrid/user"..i.."/cards")
				if cardGrid == nil then
					log("cardGrid == nil")
					return
				end
				
				for k, v in ipairs(tbSort[i].stCards) do
					local cardObj =  newNormalUI("Prefabs/Card/"..tostring(v), cardGrid)
					if cardObj ~= nil then
					cardObj.transform.localScale = Vector3(0.3,0.3,0.3)
					componentGet(cardObj,"BoxCollider").enabled = false
					end
				end

				local gunNum = tbSort[i].nShootNums
				for k = 1, 6 do
					if k <= gunNum then
						child(this.transform,"Panel/resultList/userGrid/user"..i.."/gun"..k).gameObject:SetActive(true)
					else
						child(this.transform,"Panel/resultList/userGrid/user"..i.."/gun"..k).gameObject:SetActive(false)
					end
				end

				local tex_photo= componentGet(child(this.transform, "Panel/resultList/userGrid/user"..i.."/picFrame"), "UITexture")
                log("---------------------------------------------------------------------------") 
                local number= room_usersdata_center.GetLogicSeatByStr(tbSort[i]._chair)   
				local userData =room_usersdata_center.GetUserByLogicSeat(tonumber(number))
--                hall_data.getuserimage(tex_photo,2,room_usersdata_center.GetUserByLogicSeat(number).headurl)
                NameLbl.text = userData.name
  
                log("---------------------------------------------------------------------------")
				if tbSort[i].nSpecialType~=nil then
					local SpecialSprite=componentGet(child(this.transform, "Panel/resultList/userGrid/user"..i.."/specialCard"), "UISprite")
					if tbSort[i].nSpecialType ~=0 then
						log("特殊牌型索引"..tbSort[i].nSpecialType)
						SpecialSprite.spriteName = tbSort[i].nSpecialType					
					else
						SpecialSprite.gameObject:SetActive(false)
					end
				else
					log("tbSort["..i.."].nSpecialType=nil")
				end
				local ScoreLbl = componentGet(child(this.transform, "Panel/resultList/userGrid/user"..i.."/scorelbl"), "UILabel")
				local negScoreLbl = componentGet(child(this.transform, "Panel/resultList/userGrid/user"..i.."/negscorelbl"), "UILabel")
				local totalScores = tbSort[i].all_score
				if totalScores<=0 then
					negScoreLbl.gameObject:SetActive(true)
					ScoreLbl.gameObject:SetActive(false)
					negScoreLbl.text ="得分:"..tostring(totalScores)
				else
					negScoreLbl.gameObject:SetActive(false)
					ScoreLbl.gameObject:SetActive(true)
					ScoreLbl.text ="得分:+"..tostring(totalScores)
				end
		-------------非本机用户显示房主标志-------------
				local fangzhu = componentGet(child(this.transform, "Panel/resultList/userGrid/user"..i.."/fangzhu"), "UISprite")
				if tbSort[i]._uid == fangzhuId then		
					fangzhu.gameObject:SetActive(true)
				else
					fangzhu.gameObject:SetActive(false)
				end
			else
				log("------user"..i..".tbSort=nill------")
				local trans = child(this.transform, "Panel/resultList/userGrid/user"..i)
				trans.gameObject:SetActive(false)
			end
		end
		local userNum = #tbSort
		-- local selfPos = child(this.transform, "Panel/Self")
		-- local other1Pos = child(this.transform, "Panel/resultList")
		-- if userNum == 1 then
		-- 	selfPos.transform.localPosition =  Vector3(330,0,0)	
		-- 	other1Pos.transform.localPosition =  Vector3(634,0,0)	
		-- elseif userNum == 2 then
		-- 	selfPos.transform.localPosition =  Vector3(178,0,0)
		-- 	other1Pos.transform.localPosition =  Vector3(483,0,0)
		-- elseif userNum == 3 then
		-- 	selfPos.transform.localPosition =  Vector3(30,0,0)
		-- 	other1Pos.transform.localPosition =  Vector3(330,0,0)
		-- else
		-- 	other1Pos.gameObject:AddComponent(typeof(ScrollViewMoveFixed))
		-- end
end





--注册事件
function this.registerevent()
	--this.OpetionClickEvent()
	log("注册事件")
	timeLbl = componentGet(child(this.transform, "Panel/ready/readylbl"), "UILabel")
	this.BtnClickEvent()
end


function this.BtnClickEvent()
	local btn_ready = child(this.transform, "Panel/ready")
	if btn_ready ~= nil then
		addClickCallbackSelf(btn_ready.gameObject, this.ReadyClick, this)
	end
end

---------------------------点击事件-------------------------
function this.ReadyClick(obj)
	this.Hide()
	log("结算完成： "..tostring(isEnterTotalResult))
	if isEnterTotalResult then
		large_result.Show()
	else
		this.reset()
	end
	log("-----ReadyClick-----")
end

function this.reset()
--	shisangshui_play_sys.ReSetAllStatus()--重置游戏桌的状态。
	Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_GAME_REWARDS) --确认完成结算完成消息
	shisangshui_play_sys.ReadyGameReq()--发送准备好的状态进入下一局
--	log("重新进入下一局")

end

function this.Update()
	local timeEnd = room_data.GetReadyTime()
	local curTime = Time.time
	local leftTime = timeEnd - curTime
	if leftTime <= 0 and curTime > timeSecond then
		--shisangshui_play_sys.PlaceCard(first_auto_all_card)
		this.ReadyClick()
		return
	end
	if leftTime <= 0 and curTime < timeSecond then
		timeLbl.text = ("继续（" .. 10 .."s）")
		return
	end
	if math.floor(leftTime) < 0 then
		leftTime = 0
	end	
	timeLbl.text = ("继续（" .. math.floor(leftTime) .."s）")
end
--[[local leftTime	
function this.ShowCountDown()	
	local timeEnd = room_data.GetReadyTime()	
		this.StartTimer()
		this.StopTimer()
	end
end

function this.StartTimer()		
	timer_Elapse = Timer.New(this.OnTimer_Proc,1,1)
	timer_Elapse:Start()
end

function this.OnTimer_Proc()
	leftTime = leftTime -1;
	timeLbl.text = ("准备（" .. math.floor(leftTime) .."s）")
	if leftTime <= 0 then
		this.ReadyClick()
	end
end

function this.StopTimer()
	if timer_Elapse ~= nil then
		timer_Elapse:Stop()
		timer_Elapse = nil
	end
end--]]