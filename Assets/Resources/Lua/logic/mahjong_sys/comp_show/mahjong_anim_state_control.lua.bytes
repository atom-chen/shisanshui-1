-- 过程动画 简易状态机

mahjong_anim_state_control = {}

local stateList = nil
local currentIndex = 1

local animMap = {}
-- 预设名，动画名，动画时长
animMap[MahjongGameAnimState.start] = {"anim_gane_start", "duijukaishi", 1}
animMap[MahjongGameAnimState.changeFlower] = {"anim_buhua", "hua", 1,"man/buhua"}
animMap[MahjongGameAnimState.grabGold] = {"anim_kaiqiangjin", "qiangjin", 1}
animMap[MahjongGameAnimState.openGold] = {"anim_kaiqiangjin", "kaijin", 1}

function mahjong_anim_state_control.InitFuzhouAnims()
	stateList = {}
	table.insert(stateList,MahjongGameAnimState.start)
	table.insert(stateList,MahjongGameAnimState.changeFlower)
	table.insert(stateList,MahjongGameAnimState.openGold)
	table.insert(stateList,MahjongGameAnimState.grabGold)
end


function mahjong_anim_state_control.ShowAnimState(animState, callback, needwait,playSound)

	if currentIndex > #stateList or stateList[currentIndex] ~= animState then
		if callback ~= nil then
			callback()
		end
		return
	end
	local data = animMap[animState]
	currentIndex = currentIndex + 1
	if data == nil then
		if callback ~= nil then
			callback()
		end
		return
	end

	if playSound and data[4] ~= nil then
		ui_sound_mgr.PlaySoundClip(data[4]) 
	end
	mahjong_anim_state_control.PlayMahjongUIAnim(data[1],data[2])
	if needwait then
		coroutine.start(function()
			coroutine.wait(time)
			if callback ~= nil then
				callback()
			end
		end)
	else
		if callback ~= nil then
			callback()
		end
	end
end

function mahjong_anim_state_control.Reset()
	currentIndex = 1
end

function mahjong_anim_state_control.SetState(index)
	currentIndex = index
end



function mahjong_anim_state_control.PlayMahjongUIAnim(prefab, animName)
	mahjong_ui.ShowUIAnimation(prefab, animName)
end