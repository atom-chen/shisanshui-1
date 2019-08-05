--[[--
 * @Description: 骰子组件
 * @Author:      ShushingWong
 * @FileName:    comp_dice.lua
 * @DateTime:    2017-07-11 14:45:43
 ]]

comp_dice = {}

function comp_dice.create()
	require "logic/mahjong_sys/mode_components/mode_comp_base"
	local this = mode_comp_base.create()
	this.Class = comp_dice
	this.name = "comp_dice"

	local fun_createDice
	local fun_getSaiziRotate

	local AllTime
    local bAni
    local bLaterHide
    local midTime
    local passTime
    local rSpeed = 3000
    local offsetMax = Vector3(0, 0.723, 0.286)
    local offsetMin = Vector3(0, 0.723, 0.138)
    local objSelf
    local quatSaizi0 = Quaternion.identity
    local quatSaizi1 = Quaternion.identity
    local dice1_trans
	local dice2_trans

	local callback


	this.base_init = this.Initialize

	function this:Initialize()
		this.base_init()
	end

	--[[--
	 * @Description: 创建骰子  
	 ]]
	fun_createDice = function()
		local resDiceObj = newNormalObjSync("Prefabs/Scene/Mahjong/MJDice", typeof(GameObject))	
		objSelf = newobject(resDiceObj)
		dice1_trans = child(objSelf.transform,"Dice1")
		dice2_trans = child(objSelf.transform,"Dice2")
		objSelf:SetActive(false)
	end

	--[[--
	 * @Description: 得到骰子旋转  
	 * @param:       string name 
	 * @return:      nil
	 ]]
	fun_getSaiziRotate = function(value)
		local identity;
        local quaternion2;

        if value == 4 then
        	identity = Quaternion.identity * Quaternion.AngleAxis(-90, Vector3.forward)
            quaternion2 = Quaternion.AngleAxis(math.random(0,360), Vector3.left)
        elseif value == 1 then
        	identity = Quaternion.identity * Quaternion.AngleAxis(180, Vector3.right)
            quaternion2 = Quaternion.AngleAxis(math.random(0,360), Vector3.up)
        elseif value == 2 then
        	identity = Quaternion.identity * Quaternion.AngleAxis(90, Vector3.forward)
            quaternion2 = Quaternion.AngleAxis(math.random(0,360), Vector3.left)
        elseif value == 3 then
        	identity = Quaternion.identity * Quaternion.AngleAxis(-90, Vector3.right)
            quaternion2 = Quaternion.AngleAxis(math.random(0,360), Vector3.forward)
        elseif value == 5 then
        	identity = Quaternion.identity * Quaternion.AngleAxis(90, Vector3.right)
            quaternion2 = Quaternion.AngleAxis(math.random(0,360), Vector3.forward)
        elseif value == 6 then
        	identity = Quaternion.identity
            quaternion2 = Quaternion.AngleAxis(math.random(0,360), Vector3.up)
        end
        return (identity * quaternion2)
    end

    --[[--
     * @Description: 初始化  
     ]]
    this.Init = function()
    	bAni = false
        AllTime = 2
        passTime = 0
        midTime = 0
        dice1_trans.localRotation = fun_getSaiziRotate(math.random(1, 6))
        dice2_trans.localRotation = fun_getSaiziRotate(math.random(1, 6))
        objSelf:SetActive(false)
    end

    --[[--
     * @Description: 显示  
     ]]
    this.Play = function(val1,val2,cb,isLaterHide)
    	if (not bAni) then
            if not objSelf.activeSelf then
                objSelf:SetActive(true)
            end
            midTime = AllTime * 0.5
            passTime = 0
            bLaterHide = isLaterHide or true
            local num1 = val1
            local num2 = val2
            quatSaizi0 = fun_getSaiziRotate(num1)
            quatSaizi1 = fun_getSaiziRotate(num2)
            bAni = true
            callback = cb
        end
    end

    --[[--
     * @Description: 隐藏  
     ]]
    this.Hide = function()
    	objSelf:SetActive(false)
    end

    local m_coroutine

    this.Update = function()
    	if bAni then
            passTime = passTime + Time.deltaTime
            if passTime < AllTime then
                local t = passTime / AllTime
                objSelf.transform:Rotate(Vector3.up, (Time.deltaTime * Mathf.Lerp(rSpeed, 0, t)))
                objSelf.transform:Rotate(Vector3.up, 1)
                if passTime < midTime then
                    t = passTime / midTime;
                    dice1_trans.localPosition = Vector3.Lerp(offsetMin, offsetMax, t)
                    dice2_trans.localPosition = Vector3(-dice1_trans.localPosition.x,dice1_trans.localPosition.y,-dice1_trans.localPosition.z)
                    dice1_trans.localRotation = Quaternion(math.random(0, 1),math.random(0, 1),math.random(0, 1),math.random(0, 1))--UnityEngine.Random.rotation
                    dice2_trans.localRotation = Quaternion(math.random(0, 1),math.random(0, 1),math.random(0, 1),math.random(0, 1))--UnityEngine.Random.rotation
                else
                    t = (passTime - midTime) / (AllTime - midTime)
                    dice1_trans.localPosition = Vector3.Lerp(offsetMax, offsetMin, t)
                    dice2_trans.localPosition = Vector3(-dice1_trans.localPosition.x,dice1_trans.localPosition.y,-dice1_trans.localPosition.z)
                    dice1_trans.localRotation = Quaternion.Slerp(dice1_trans.localRotation, quatSaizi0, t)
                    dice2_trans.localRotation = Quaternion.Slerp(dice2_trans.localRotation, quatSaizi1, t)
                end
            elseif not bLaterHide then
                bAni = false
            elseif passTime > AllTime then
                if bLaterHide then
                	m_coroutine = coroutine.start(function ()
                		coroutine.wait(4)
                		this.Hide()
                	end)
                end
                bAni = false
                if callback ~=nil then
                	callback()
                	callback = nil
                end
            end
        end
    end

	this.base_unInit = this.Uninitialize
	
	function this:Uninitialize()
		this.base_unInit()
		if m_coroutine~=nil then
			coroutine.stop(m_coroutine)
			m_coroutine = nil
		end
	end

	fun_createDice()

	return this
end