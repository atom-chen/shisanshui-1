--[[--
 * @Description: ui音效管理
 * @Author:      shine
 * @FileName:    ui_sound_mgr.lua
 * @DateTime:    2016-03-12 16:23:28
 ]]

ui_sound_mgr = {}
local this = ui_sound_mgr

local bgAudioSource = nil
local commAudioSource = nil
local commAudioSource2=nil

--[[--
 * @Description: 音效管理初始化  
 ]]
function this.Init()
	
end

function this.UnInit()

end

function this.SceneLoadFinish()
    local camera=GameObject.Find("Camera")  
	commAudioSource = subComponentGet(camera.transform, "comm_sound", "AudioSource")
	if commAudioSource == nil then
		local commSoundObj = child(camera.transform, "comm_sound")
		if commSoundObj ~= nil then
			commSoundObj.gameObject:AddComponent(typeof(AudioSource))	
		end	
	end	
    commAudioSource2 =subComponentGet(camera.transform, "comm_sound2", "AudioSource")
    if commAudioSource2 == nil then
		local commSoundObj = child(camera.transform, "comm_sound2")
		if commSoundObj ~= nil then
			commSoundObj.gameObject:AddComponent(typeof(AudioSource))	
		end	
	end	
	bgAudioSource = subComponentGet(camera.transform, "bg_sound", "AudioSource")
	if bgAudioSource == nil then
		local bgSoundObj = child(camera.transform, "bg_sound")
		if bgSoundObj ~= nil then
			bgSoundObj.gameObject:AddComponent(typeof(AudioSource))
		end
	end
end

--[[--
 * @Description: 播放背景音乐  
 ]]
function this.PlayBgSound(name)
	if bgAudioSource ~= nil then
		local bgAudioClip = newNormalObjSync("Sound/ui_sound/"..name, typeof(AudioClip))
		if bgAudioClip ~= nil then	
			bgAudioSource.clip = bgAudioClip
			bgAudioSource.loop = true
			bgAudioSource:Play()
		end
	end
end

--[[--
 * @Description: 暂停背景音乐  
 ]]
function this.PauseBgSound()
	if bgAudioSource ~= nil then	
		bgAudioSource:Pause()
	end
end

--[[--
 * @Description: 停止背景音乐  
 ]]
function this.StopBgSound( )
	if bgAudioSource ~= nil then	
		bgAudioSource:Stop()
	end
end

--[[--
 * @Description: 播放音效文件  
 ]]
function this.PlaySoundClip(name)
	if commAudioSource ~= nil then 
        
		local commAudioClip = newNormalObjSync("Sound/ui_sound/"..name, typeof(AudioClip))
        if commAudioSource.isPlaying then
            commAudioSource2.clip=commAudioClip
            commAudioSource2:Play()
        else
            if commAudioClip ~= nil then	
			    commAudioSource.clip = commAudioClip
			    commAudioSource:Play()
		    end
        end
		
	end
end

--[[--
 * @Description: 开始音频播放  
 ]]
function this.StartSound()
	if (not IsNil(commAudioSource)) then
		commAudioSource.enabled = true
	end
end

--[[--
 * @Description: 停止音频播放  
 ]]
function this.StopSound()
	
	if (not IsNil(commAudioSource)) then
		commAudioSource.enabled = false
	end
end

--[[--
 * @Description: 暂停音效文件  
 ]]
function this.PauseSoundClip()
	if commAudioSource ~= nil then
		commAudioSource:Pause()
	end
end

--[[--
 * @Description: 停止音效文件  
 ]]
function this.StopSoundClip()
	if commAudioSource ~= nil then
		commAudioSource:Stop()
	end
end

function this.PlayMessageClip(paras)
	local value = paras.para1
	this.PlayAnimationSounder(value)
end

function this.PlayAnimationSounder(name)
	if commAudioSource ~= nil then
		local commAudioClip = newNormalObjSync("Sound/animation/"..name, typeof(AudioClip))
		if commAudioClip ~= nil then	
			commAudioSource.clip = commAudioClip
			commAudioSource:Play()
		end
	end
end

function this.controlValue(value)
    componentGet(bgAudioSource,"AudioSource").volume=value
end

function this.ControlCommonAudioValue(value )
    componentGet(commAudioSource,"AudioSource").volume=value
end

function  this.GetBGVolume()
    return  componentGet(bgAudioSource,"AudioSource").volume 
end
function  this.GetCommonVolume()
    return  componentGet(commAudioSource,"AudioSource").volume 
end