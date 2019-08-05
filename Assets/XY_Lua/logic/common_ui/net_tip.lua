--[[--
 * @Description: 弹出框，持续一段时间后自动关闭
 * @Author:      shine
 * @FileName:    net_tip.lua
 * @DateTime:    2017-07-19
 ]]

net_tip = ui_base.New()
local this = net_tip

local timer_Elapse = nil -- timer

local lb_text = nil

local msg = nil
local outlineColor = nil

local Init = nil
local StartTimer = nil
local StopTimer = nil
local OnTimer_Proc = nil
local supportEncoding = true

local count = 0


local function StopTimer()
	if timer_Elapse ~= nil then
		timer_Elapse:Stop()
		timer_Elapse = nil
	end
end

local function OnTimer_Proc()
	if count > 6 then
		count = 0
	end

	local dot = ""
	for i=1, count do
		dot = dot.."."
	end
	lb_text.text = msg..dot
end

local function StartTimer()
	StopTimer()
	timer_Elapse = Timer.New(OnTimer_Proc, 0.5, -1)
	timer_Elapse:Start()
end


--[[--
 * @Description: 逻辑入口  
 参数：encoding -是否支持bbcode默认支持
 ]]
function this.Show(text, pos, encoding, outlineColorValue)
	if pos == nil then
		pos = Vector3.New(0, 0, -1000)  --处理角色页面层级问题
	end
	supportEncoding = encoding
	outlineColor = outlineColorValue
	this.ShowByTime(text, pos)
end

--[[--
 * @Description: 逻辑入口  
 ]]
function this.ShowByTime(text, pos)
	msg = text

	-- init	
	if not IsNil(this.gameObject) then
		--快速显示
		--this:FastShow()
		--[[this:RefreshPanelDepth()
		this:RegistUSRelation()

		this.Init()
		this.transform.localPosition = pos]]
	else
		local netTip = newNormalUI("Prefabs/UI/Common/net_tip")
		if netTip ~= nil then
			netTip.transform.localPosition = pos
			this.Init()
		end
	end
end

function this.ResetFastTip()
	outlineColor = nil 
end


function this.FakeDestroy()
	--this:FastHide()
	this:UnRegistDialogueEvent()
	this:UnRegistUSRelation()
    GameObject.Destroy(this.gameObject)
    this.gameObject=nil
end

--[[--
 * @Description: 逻辑入口  
 ]]
function this.Hide()
	if not IsNil(this.gameObject) then		
		this.FakeDestroy()
	end
	StopTimer()
end

function this.Start()
	this.Init()
end

function this.OnDestroy()
	StopTimer()

	lb_text = nil
	--lb_nobbcode_text = nil
	this.gameObject = nil

	count = 0

	this:UnRegistDialogueEvent()
	this:UnRegistUSRelation()
end

function this.Init()	
	lb_text = subComponentGet(this.transform, "Label", "UILabel")
	
	if lb_text ~= nil then
		local bEncode = not(supportEncoding == false)
		lb_text.transform.gameObject:SetActive(bEncode)
		--lb_nobbcode_text.transform.gameObject:SetActive(not bEncode)
		lb_text.text = msg
		--lb_nobbcode_text.text = msg

		if (outlineColor ~= nil) then
			lb_text.effectStyle = UILabel.Effect.Outline
			lb_text.effectColor = outlineColor
		end
	end	
	StartTimer()
end


function this.DeTectTipIsShow()
	if not IsNil(this.gameObject) then
		return true 
	end
	return false
end