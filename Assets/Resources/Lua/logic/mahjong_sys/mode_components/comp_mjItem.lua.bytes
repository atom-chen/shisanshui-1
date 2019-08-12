--[[--
 * @Description: mahjong item component
 * @Author:      ShushingWong
 * @FileName:    comp_mjItem.lua
 * @DateTime:    2017-06-20 15:22:57
 ]]


comp_mjItem = {}

function comp_mjItem.create()
	require "logic/mahjong_sys/mode_components/mode_comp_base"
	local this = mode_comp_base.create()
	this.Class = comp_mjItem
	this.name = "comp_mjItem"

    this.paiValue = nil--牌值
    this.mjObj = nil--麻将对象
    this.mjModelObj = nil -- 麻将模型
    local meshFilter = nil--麻将meshFilter
    local hunObj = nil--混字对象
    local isFront = false--是否显示正面

    -- 麻将上的小箭头
    local tingIconGo = nil

    -- 显示小箭头的牌
    this.isTing = false

    this.eventPai = nil--点击牌事件
    this.dragEvent = nil -- 拖动牌事件
    this.isHun = false--是否癞子牌
	-- 是否为金牌
    this.isJin = false
    local meshRenderer = nil--麻将网格渲染
    local originalMat = nil--麻将原材质
    local originalPos = nil

	this.base_init = this.Initialize

	function this:Initialize()
		this.base_init()
	end


    --[[--
     * @Description: 获取unity相关组件  
     ]]
    local function CreateObj()
        local resMJObj = newNormalObjSync("Prefabs/Scene/Mahjong/MJ", typeof(GameObject))	
        this.mjObj = newobject(resMJObj)
        this.mjModelObj = child(this.mjObj.transform, "mjobj").gameObject
        meshFilter = this.mjObj:GetComponentInChildren(typeof(UnityEngine.MeshFilter))
        hunObj = child(this.mjObj.transform,"sr_hun").gameObject
        tingIconGo = child(this.mjObj.transform, "sr_select").gameObject
        meshRenderer = this.mjObj:GetComponentInChildren(typeof(UnityEngine.MeshRenderer))
        originalMat = meshRenderer.sharedMaterial
		this.mjObj.transform.localScale = Vector3.one * mahjongConst.MahjongScale
    end


    --[[--
     * @Description: 初始化  
     ]]
    function this:Init()
        this:Hide()
        this:SetHun(false)
        this:SetHighLight(false)
    end


	function this:DOLocalMove(pos, time, snap)
        snap = snap or false
        if(time == 0) then
            this.mjObj.transform.localPosition = pos
        else
            this.mjObj.transform:DOLocalMove(pos, time, snap)
        end
    end

    function this:DOLocalRotate(eulers, time, mode)
        mode = mode or DG.Tweening.RotateMode.Fast
        if time == 0 then
            this.mjObj.transform.localEulerAngles = eulers
        else
            this.mjObj.transform:DOLocalRotate(eulers, time, mode)
        end
    end

    -- 设置为2dlayer
    function this:Set2DLayer()
        RecursiveSetLayerValIncludeSelf(this.mjObj.transform, MahjongLayer.TwoDLayer)
    end

    -- 设置为3dlayer
    function this:Set3DLayer()
        RecursiveSetLayerValIncludeSelf(this.mjObj.transform, MahjongLayer.DefaultLayer)
    end
    --[[--
     * @Description: 显示  
     ]]
    function this:Show(front,isAnim)
        if front~=nil then
            isFront = front
        end
        if(this.mjObj~=nil) then
            this.mjObj:SetActive(true)
            if isFront then
                if isAnim~=nil and isAnim then
                    this.mjObj.transform:DOLocalRotate(Vector3(0,0,0), 0.3, DG.Tweening.RotateMode.Fast)
                else
                    this.mjObj.transform.localEulerAngles = Vector3(0, 0, 0)
                end
            else
                if isAnim~=nil and isAnim then
                    this.mjObj.transform:DOLocalRotate(Vector3(0,0,180), 0.3, DG.Tweening.RotateMode.Fast)
                else
                    this.mjObj.transform.localEulerAngles = Vector3(0, 0, 180)
                end
            end
        end
    end


    function this:SetParent(parent, inWorld)
        if this.mjObj ~= nil then
            this.mjObj.transform:SetParent(parent, inWorld or false)
        end
    end

    --[[--
     * @Description: 隐藏  
     ]]
    function this:Hide()
        if(this.mjObj~=nil) then
            this.mjObj:SetActive(false)
        end
		this:SetJin(false)
        this:SetHun(false)
    end

    --[[--
     * @Description: 设置mesh  
     ]]
    function this:SetMesh(value)
        this.paiValue = value
        if(this.paiValue~=nil and meshFilter~=nil) then
            local comp_resMgr = mode_manager.GetCurrentMode():GetComponent("comp_resMgr")
            local index = MahjongTools.MahjongValueToMeshIndex(this.paiValue)
            meshFilter.mesh = comp_resMgr:GetMahjongMesh(index)
        end
    end

    --[[--
     * @Description: 设置混显示  
     ]]
    function this:SetHun( isShow )
        if hunObj~=nil then
            this.isHun = isShow
            hunObj:SetActive(isShow)
        end
    end

	--[[--
     * @Description: 设置金显示  
     ]]
    function this:SetJin(isShow)
        if hunObj ~= nil then
            this.isJin = isShow
            hunObj:SetActive(isShow)
        end
    end

    -- 设置显示小箭头
    function this:SetTingIcon(value)
        if tingIconGo ~= nil then
            this.isTing = value
            tingIconGo:SetActive(value)
        end
    end

    --[[--
     * @Description: 设置高亮，相同牌显示  
     ]]
    function this:SetHighLight(isHighLight)
        if isHighLight then 
            meshRenderer.sharedMaterial = mode_manager.GetCurrentMode():GetComponent("comp_resMgr"):GetHighLightMat()
        else
            meshRenderer.sharedMaterial = originalMat
        end
    end

	function this:HideAndReset()
        if(this.mjObj~=nil) then
            this.mjObj:SetActive(false)
            this.mjObj.transform.localScale = Vector3.one * mahjongConst.MahjongScale
            this.mjObj.transform:SetParent(nil, false)
        end
        this:SetTingIcon(false)
        this:SetJin(false)
        this.eventPai = nil
    end


    function this:FlyToPos(x,z, time, scale)
        this.mjObj.transform:DOLocalMove(Vector3(x, 0, z), time, false)
        if scale ~= nil then
            this.mjObj.transform:DOScale(scale, time)
        end
    end

    --[[--
     * @Description: 点击按下状态  
     ]]
    function this:OnClickDown()
        if roomdata_center.CheckCardTing(this.paiValue) then
            this:SetTingIcon(false)
            mahjong_ui.cardShowView:ShowHu(roomdata_center.GetTingInfo(this.paiValue))
        end
        this.mjObj.transform:DOLocalMove(
            Vector3(this.mjObj.transform.localPosition.x,
                this.mjObj.transform.localPosition.y,
                mahjongConst.MahjongOffset_z/3),  
            0.05, false)
    end

    --[[--
     * @Description: 非点击状态  
     ]]
    function this:OnClickUp()
        -- 吃的时候不需要隐藏
         mahjong_ui.cardShowView:HideIfNotChi()
         this:SetTingIcon(roomdata_center.CheckCardTing(this.paiValue))

        this.mjObj.transform:DOLocalMove(
            Vector3(this.mjObj.transform.localPosition.x,this.mjObj.transform.localPosition.y,0), 
            0.05, false)
    end

    local listener = nil --拖动事件监听comp
    local clonemj = nil --拖动麻将comp
    this.isDrag = false -- 是否在拖动

    --[[--
     * @Description: 添加拖动事件监听comp  
     ]]
    function this:AddEventListener()
        if not IsNil(this.mjModelObj) then
            addDragCallbackSelf(this.mjModelObj, function (go, delta)
                if not this.isDrag then
                    if delta.y > 3 then 
                        originalPos = this.mjObj.transform.localPosition
                        this.mjObj.transform.localPosition = originalPos + Vector3(0,mahjongConst.MahjongOffset_y,0)
                        this.isDrag = true
                    end
                else
                    local v = mode_manager.GetCurrentMode():GetComponent("comp_clickevent").Camera2D:ScreenToWorldPoint(Input.mousePosition)
                    this.mjObj.transform.position = Vector3(v.x,v.y-mahjongConst.MahjongOffset_z,this.mjObj.transform.position.z)
                end
                --[[
                if clonemj == nil then
                    log("delta.y----------- delta.y "..tostring(delta.y))
                    if delta.y > 3 then 
                        clonemj = mode_manager.GetCurrentMode():GetComponent("comp_resMgr"):CeateMJItem(this)
                        clonemj.mjObj.transform.localPosition = clonemj.mjObj.transform.localPosition+ Vector3(0,0,-mahjongConst.MahjongOffset_y)
                        this.isDrag = true
                    end
                else
                    local v = mode_manager.GetCurrentMode():GetComponent("comp_clickevent").Camera2D:ScreenToWorldPoint(Input.mousePosition)
                    clonemj.mjObj.transform.position = Vector3(v.x,v.y-mahjongConst.MahjongOffset_z,clonemj.mjObj.transform.position.z)
                    --clonemj.mjObj.transform.localPosition = clonemj.mjObj.transform.localPosition+ Vector3(delta.x,delta.y,0)/210 -- 除数待修改，根据屏幕摄像机大小调整
                end]]

                --log("AddDragEvent--------------------AddDragEvent---------------"..tostring(delta))
            end)

            addDragEndCallbackSelf(this.mjModelObj, function (go)
                --log("Input.mousePosition-----------"..tostring(Input.mousePosition))
                if this.isDrag then
                    if Input.mousePosition.y > Screen.height/4 then
                        --this.dragEvent(this)
                        this.mode:GetComponent("comp_playerMgr"):GetPlayer(1):DragCardEvent(this)
                        --mahjong_play_sys.OutCardReq(this.paiValue)
                    end
                    this.mjObj.transform.localPosition = originalPos
                    
                    coroutine.start(function()
                        coroutine.wait(0.01)
                        this.isDrag = false
                    end)
                end
                --[[
                if clonemj~=nil then
                    if Input.mousePosition.y > Screen.height/4 then
                        --this.dragEvent(this)
                        this.mode:GetComponent("comp_playerMgr"):GetPlayer(1):DragCardEvent(this)
                        --mahjong_play_sys.OutCardReq(this.paiValue)
                    end
                    mode_manager.GetCurrentMode():GetComponent("comp_resMgr"):DestroyMJItem(clonemj)
                    clonemj = nil
                    
                    coroutine.start(function()
                        coroutine.wait(0.01)
                        this.isDrag = false
                    end)
                end]]

            end)
        end
    end

    --[[--
     * @Description: 移除拖动事件  
     ]]
    function this:ClearEvent()
        if clonemj~=nil then
            mode_manager.GetCurrentMode():GetComponent("comp_resMgr"):DestroyMJItem(clonemj)
            clonemj = nil
        end
        local listener = UIEventListener.Get(this.mjModelObj)
        if not IsNil(listener) then
            listener:Clear()
            listener = nil
        end
        if this.dragEvent~=nil then
            this.dragEvent = nil
        end
    end  

	this.base_unInit = this.Uninitialize
	
	function this:Uninitialize()
		this.base_unInit()
        if not IsNil(this.mjObj) then
            GameObject.DestroyImmediate(this.mjObj)
        end
	end

    --log("-----------创建麻将对象")
    CreateObj()

	return this
end