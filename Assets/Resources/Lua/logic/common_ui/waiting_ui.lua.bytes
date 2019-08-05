--[[--
 * @Description: 协议等待框，一小段时间后触发
 * @Author:      shine
 * @FileName:    waiting_ui.lua
 * @DateTime:    2017-05-16
 ]]

waiting_ui = {} 
local this = waiting_ui

local timer_Elapse = nil -- timer
local flower = nil
local m_bCreated = false
local curWaitingCount = 0
--[[--
 * @Description: 逻辑入口  
 ]]
function this.Show()
	if not m_bCreated then
		newResidentMemoryUI("Prefabs/UI/Common/waiting_ui")
		m_bCreated = true
	end
	curWaitingCount = curWaitingCount + 1
	this.Init()
end

--[[--
 * @Description: 逻辑入口  
 ]]
function this.Hide()
	curWaitingCount = curWaitingCount - 1
	if m_bCreated and curWaitingCount <= 0 then
		this.Uninit()
		curWaitingCount = 0
	end
end

function this.Init()	
	this.gameObject:SetActive(true)
	--flower = child(this.transform, "sp_waiting").gameObject
	--flower:SetActive(false)
	
	if timer_Elapse == nil then
		timer_Elapse = Timer.New(this.OnTimer_Proc, 30, 1)
	end
	timer_Elapse:Reset(this.OnTimer_Proc, 30, 1)
	timer_Elapse:Stop()
	timer_Elapse:Start()	
end

function this.Uninit()
	--print("waiting uninit")
	this.gameObject:SetActive(false)
	
	if timer_Elapse ~= nil then
	    timer_Elapse:Stop()
	end
end

function this.OnTimer_Proc()
	--[[if flower ~= nil then
	    flower:SetActive(true)
	end]]
	--if curWaitingCount > 0 then
		this.Uninit()
		curWaitingCount = 0	
		fast_tip.Show("您的网络状态异常，请稍后再试")
	--end
end

