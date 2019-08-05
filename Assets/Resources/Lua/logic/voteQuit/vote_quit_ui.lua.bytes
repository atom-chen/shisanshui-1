
require("logic/voteQuit/vote_quit_view")
vote_quit_ui = ui_base.New()

local closeBtn
local contentLabel
local btnYes
local btnNo

local voteView

local callback = nil
local playerNum
local playName
local voteView = vote_quit_view.New()

local this = vote_quit_ui
local currTime=23
local timeTabel
local timeLabel
function this.Show(name, boolcallback, players, time)
	if this.gameObject==nil then
		--require ("logic/open_room/get_in_ui")
		this.gameObject = newNormalUI("Prefabs/UI/VoteQuit/vote_quit")
	else
		this.gameObject:SetActive(true)
		voteView:Show(players)
		contentLabel.text = this.GetStr()
	end
	playName = name
	callback = boolcallback
	playerNum = players
	this.CalTime(time or 30)

end

function this.ChangeTime()
	timeLabel.text=currTime
	currTime=currTime-1
end

function  this.CalTime( time)
	currTime = time
	timeTabel=Timer.New(this.ChangeTime,1,time)
	timeTabel:Start()
end

function this.Start()
	this.Init()
	this.RegisterEvents()
end

function this.AddVote(value, viewSeat)

	if this.gameObject == nil or this.gameObject.activeSelf == false then
		return
	end
	voteView:AddVote(value,viewSeat)
end


function this.Init()
	closeBtn = child(this.transform, "panel/btn_close")
	btnYes = child(this.transform, "panel/btn1")
	btnNo = child(this.transform, "panel/btn2")
	contentLabel = subComponentGet(this.transform, "panel/contentLabel", typeof(UILabel))
	contentLabel.text = this.GetStr()
	timeLabel=subComponentGet(this.transform,"panel/time/time","UILabel")
	timeLabel.text=currTime
	voteView:SetTransform(child(this.transform, "panel/voteView"))
	voteView:Show(playerNum)
end

function this.RegisterEvents()
	addClickCallback(closeBtn,this.OnClose,closeBtn.gameObject)
	addClickCallback(btnYes, this.OnYesClick, btnYes.gameObject)
	addClickCallback(btnNo, this.OnNoClick, btnNo.gameObject)
end

function this.GetStr()
	return "[bb0d01]" .. playName .. "[-]想要解散房间\n您是否同意解散？"
end


function this.OnClose()
	ui_sound_mgr.PlaySoundClip("common/audio_button_click")
	if callback ~= nil then
		callback(false)
	end
	this.Hide()
end

function this.OnYesClick()
	if callback ~= nil then
		callback(true)
	end
	this.Hide()
end

function this.OnNoClick()
	if callback ~= nil then
		callback(false)
	end
	this.Hide()
end

function this.Hide()
	if this.gameObject ~= nil then
		timeTabel:Stop()
		this.gameObject:SetActive(false)
		voteView:Hide()	
	end
end


function this.OnDestroy()
	this:UnRegistUSRelation()
end