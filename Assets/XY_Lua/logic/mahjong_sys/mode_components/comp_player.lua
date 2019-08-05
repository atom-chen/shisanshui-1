--[[--
 * @Description: player component
 * @Author:      ShushingWong
 * @FileName:    comp_player.lua
 * @DateTime:    2017-06-20 15:25:09
 ]]

comp_player = {}

function comp_player.create()
	require "logic/mahjong_sys/mode_components/mode_comp_base"
    require "logic/mahjong_sys/mode_components/comp_operatorcard"
	local this = mode_comp_base.create()
	this.Class = comp_player
	this.name = "comp_player"

    this.playerObj = nil
    this.viewSeat = -1
    this.handCardPoint = nil
    local operCardPoint = nil 
    this.outCardPoint = nil
    this.handCardList = {}
    this.outCardList = {}

    -- 花牌节点
    this.huaPointRoot  = nil
    local operCardList = {}
    local canOutCard = false
    this.handCardCount = 0
    local curClickMJItem = nil

	this.base_init = this.Initialize

	function this:Initialize()
		this.base_init()
	end

    --[[--
     * @Description: 创建玩家组件对象  
     ]]
    local function CreateObj()
        local resPlayerObj = newNormalObjSync("Prefabs/Scene/Mahjong/MJPlayer", typeof(GameObject))	
        this.playerObj = newobject(resPlayerObj)
    end

    --[[--
     * @Description: 初始化节点  
     ]]
    local function InitPoint()
      	this.handCardPoint = child_ext(this.playerObj.transform, "HandCardPoint")
        operCardPoint = child_ext(this.playerObj.transform, "OperCardPoint")
        this.outCardPoint = child_ext(this.playerObj.transform, "OutCardPoint")
        this.huaPointRoot = child_ext(this.playerObj.transform, "huaPoint")

         if this.viewSeat == 1 then
            this.handCardPoint.localScale = Vector3.one
            LuaHelper.SetTransformX(this.handCardPoint, -2.45)
            local pos = operCardPoint.localPosition
            pos.z = -3.65
            pos.x = -3.9
            operCardPoint.localPosition = pos
        end
    end  

    --[[--
     * @Description: 初始化  
     ]]
    function this:Init()
        this.StopAllCoroutine()
        if this.viewSeat == 1 then
            for i,v in ipairs(this.handCardList) do
                RecursiveSetLayerVal(v.mjObj.transform,this.outCardPoint.gameObject.layer)
            end
        end
        InitPoint()
        this.handCardList = {}
        this.outCardList = {}
        operCardList = {}
        canOutCard = false
        this.handCardCount = 0
    end



    local function IsRoundSendCard( handCardCount )
        local normalCount = {}
        local maxCount = this.mode.config.MahjongHandCount + 1
        while maxCount > 0 do
            table.insert(normalCount,maxCount)
            maxCount = maxCount - 3
        end
        for i,v in ipairs(normalCount) do
            if handCardCount == v then 
                return true
            end
        end
        return false
    end

    --[[--
     * @Description: 摸牌  
     ]]
    function this:AddHandCard(mj,isDeal)
        this.handCardCount = this.handCardCount + 1

        mj.mjObj.transform:SetParent( this.handCardPoint, false)
        local x = #this.handCardList * mahjongConst.MahjongOffset_x + this:GetOperTotalWidth()
        --print("this.handCardCount------"..this.handCardCount)
        if isDeal == false and IsRoundSendCard(this.handCardCount) then
            --print("IsRoundSendCard(this.handCardCount)------"..tostring(IsRoundSendCard(this.handCardCount)))
            x = x +mahjongConst.MahjongOffset_x/2
        end
        mj.mjObj.transform:DOLocalMove(Vector3(x, 0, 0), 0.05,false)
        mj.mjObj.transform:DOLocalRotate(Vector3.zero, 0.05,DG.Tweening.RotateMode.Fast)
                        
        if this.viewSeat == 1 then
            RecursiveSetLayerVal(mj.mjObj.transform, this.handCardPoint.gameObject.layer)
            mj:AddEventListener() 

            mj.eventPai = function( mj )
                this:ClickCardEvent( mj )
            end

            mj.dragEvent = function( mj )
                this:DragCardEvent( mj )
            end            

            if roomdata_center.hun~=nil and roomdata_center.hun == mj.paiValue then
                mj:SetHun(true)
            end

            if roomdata_center.jin ~= nil and roomdata_center.jin == mj.paiValue then
                mj:SetJin(true)
            end
        end
    
        table.insert(this.handCardList,mj)
    end

    --[[--
     * @Description: 发牌墩下标对应手牌下标转换  
     ]]
    local DunIndexToHandIndex = {
        [1] = 1, [2] = 4,  [3]  = 2, [4]  = 5,  [5]  = 3, [6]  = 6,  [7]  = 11,
        [8] = 7, [9] = 12, [10] = 8, [11] = 13, [12] = 9, [13] = 10, [14] = 14,
    }


    --[[--
     * @Description: 拿墩的形式摸牌  
     ]]
    function this:AddDun( mj )
        this.handCardCount = this.handCardCount + 1
        mj.mjObj.transform:SetParent(this.handCardPoint, false)
        local x = 0
        local z = 0
        if DunIndexToHandIndex[this.handCardCount]>0 and DunIndexToHandIndex[this.handCardCount]<4 then
            x = (DunIndexToHandIndex[this.handCardCount]+2) * mahjongConst.MahjongOffset_x
            z = mahjongConst.MahjongOffset_y
        elseif DunIndexToHandIndex[this.handCardCount]>=11 and DunIndexToHandIndex[this.handCardCount]<=14 then
            x = (DunIndexToHandIndex[this.handCardCount]-5) * mahjongConst.MahjongOffset_x
            z = mahjongConst.MahjongOffset_y
        else
            x = (DunIndexToHandIndex[this.handCardCount]-1) * mahjongConst.MahjongOffset_x
        end

        mj.mjObj.transform:DOLocalMove(Vector3(x, 0, z), 0.05,false)
        mj.mjObj.transform:DOLocalRotate(Vector3(-90,0,0), 0.05,DG.Tweening.RotateMode.Fast)

        if this.viewSeat == 1 then
            mj.eventPai = function( mj )
                this:ClickCardEvent( mj )
            end
        end

        this.handCardList[DunIndexToHandIndex[this.handCardCount]] = mj
        --table.insert(this.handCardList,mj)

    end

    local ArrangeHandCard_c --起牌动画协程
    
    --[[--
     * @Description: 起牌动画  
     ]]
    function this:ArrangeHandCard(callback)
        ArrangeHandCard_c = coroutine.start(function ()
            for i=1,#this.handCardList do
                local mj = this.handCardList[i]
                local x = 0
                local z = 0
                if i >=1 and i<=3 then
                    z = mahjongConst.MahjongOffset_y
                elseif i >=11 and i<=14 then
                    z = mahjongConst.MahjongOffset_y
                end
                x = (i-1) * mahjongConst.MahjongOffset_x
                mj.mjObj.transform:DOLocalMove(Vector3(x, 0, z), 0.3,false)
            end
            coroutine.wait(0.3)

            for i=1,#this.handCardList do
                local mj = this.handCardList[i]
                local x = (i-1) * mahjongConst.MahjongOffset_x

                mj.mjObj.transform:DOLocalMove(Vector3(x, 0, 0), 0.1,false)

            end
            coroutine.wait(0.2)

            for i=1,#this.handCardList do
                local mj = this.handCardList[i]
                local x = (i-1) * mahjongConst.MahjongOffset_x

                mj.mjObj.transform:DOLocalMove(Vector3(x, 0.45, 0), 0.3,false):SetEase(DG.Tweening.Ease.InBack)

            end
            coroutine.wait(0.3)

            for i=1,#this.handCardList do
                local mj = this.handCardList[i]
                local x = (i-1) * mahjongConst.MahjongOffset_x

                mj.mjObj.transform:DOLocalMove(Vector3(x, 0, 0), 0.5,false):SetEase(DG.Tweening.Ease.OutQuart)
                mj.mjObj.transform:DOLocalRotate(Vector3.zero, 0.5,DG.Tweening.RotateMode.Fast):SetEase(DG.Tweening.Ease.OutQuart)

            end
            coroutine.wait(0.5)

            for i=1,#this.handCardList do
                if this.viewSeat == 1 then
                    RecursiveSetLayerVal(this.handCardList[i].mjObj.transform,this.handCardPoint.gameObject.layer)
                    this.handCardList[i]:AddEventListener()
                    this.handCardList[i].dragEvent = function(mj)
                        this:DragCardEvent(mj)
                    end
                end
            end

            if callback~=nil then
                callback()
            end

            --compPlayerMgr:GetPlayer(1):AddDragEvent()
        end)
    end

    --[[--
     * @Description: 显示手牌中混牌  
     ]]
    function this:ShowLaiInHand()
        for i=1,#this.handCardList do
            if this.handCardList[i].paiValue == roomdata_center.hun then
                this.handCardList[i]:SetHun( true )
            end
        end
    end

    --[[--
     * @Description: 癞子牌置前  
     ]]
    local function PutFrontHun( list )
        for i=1,#list do
            local mj = list[i]
            if mj.isHun == true then
                local index = i-1
                while index > 0 do 
                    local temp = list[index]
                    list[index] = list[index+1]
                    list[index+1] = temp
                    index = index -1
                end
            end
        end
    end

    --[[--
     * @Description: 癞子牌置前  
     ]]
    local function PutFrontJin( list )
        for i=1,#list do
            local mj = list[i]
            if mj.isJin == true then
                local index = i-1
                while index > 0 and not list[index].isJin do 
                    local temp = list[index]
                    list[index] = list[index+1]
                    list[index+1] = temp
                    index = index -1
                end
            end
        end
    end

    --[[--
     * @Description: 插入排序，只能用于排序麻将组件  
     ]]
    function this.InsertSort( list )
        for i = 2,#list,1 do
            local insertItem = list[i]
            local insertIndex = i - 1
            while (insertIndex > 0 and insertItem.paiValue < list[insertIndex].paiValue)
            do
                list[insertIndex + 1] = list[insertIndex]
                insertIndex = insertIndex -1
            end
            list[insertIndex + 1] = insertItem
        end
    end


    local SortHandCard_c -- 排手牌协程

    --[[--
     * @Description: 排手牌  
     ]]
    function this:SortHandCard(isNeedAnim)
        local operWidth = this:GetOperTotalWidth()

        local lastMJ = this.handCardList[#this.handCardList]
        this.InsertSort(this.handCardList)
        PutFrontJin(this.handCardList)
        local needInsertAnim = false
        if isNeedAnim == true and lastMJ ~= this.handCardList[#this.handCardList] then
            needInsertAnim = true
        end
        
        for i=1,#this.handCardList do
            local x = operWidth + (i-1) * mahjongConst.MahjongOffset_x
            local mj = this.handCardList[i]
            if mj == lastMJ and needInsertAnim then
                SortHandCard_c = coroutine.start(function ()
                        if this.viewSeat == 1 then
                            mj.eventPai = nil
                        end

                        mj.mjObj.transform:DOLocalMove(mj.mjObj.transform.localPosition + Vector3(0, 0,mahjongConst.MahjongOffset_z ), 0.1,false)
                        mj.mjObj.transform:DOLocalRotate(Vector3(0,20,0), 0.1,DG.Tweening.RotateMode.Fast)
                        coroutine.wait(0.1)

                        mj.mjObj.transform:DOLocalMove(Vector3(x, 0, mahjongConst.MahjongOffset_z), 0.3,false)
                        coroutine.wait(0.3)

                        mj.mjObj.transform:DOLocalRotate(Vector3.zero, 0.1,DG.Tweening.RotateMode.Fast)
                        coroutine.wait(0.05)

                        mj.mjObj.transform:DOLocalMove(Vector3(x, 0, 0), 0.1,false)
                        coroutine.wait(0.1)

                        if this.viewSeat == 1 then
                            mj.eventPai = function( mj )
                                this:ClickCardEvent( mj )
                            end
                        end
                    end)
            else
                if this.viewSeat == 1 then
                    mj.eventPai = nil
                end

                if IsRoundSendCard(#this.handCardList) and i == #this.handCardList then 
                    x = x + mahjongConst.MahjongOffset_x/2 
                end
                mj.mjObj.transform:DOLocalMove(Vector3(x, 0, 0), 0.05,false):OnComplete(function()
                    if this.viewSeat == 1 then
                        mj.eventPai = function( mj )
                            this:ClickCardEvent( mj )
                        end
                    end
                end)
                mj.mjObj.transform:DOLocalRotate(Vector3.zero, 0.05,DG.Tweening.RotateMode.Fast)
            end
        end
    end

    --[[--
     * @Description: 获取操作牌  
     ]]
    function this:GetOperTotalWidth()
        local sum = 0
        for i,v in ipairs(operCardList) do
            sum = sum + v:GetWidth() + mahjongConst.MahjongOperCardInterval
        end
        if this.viewSeat == 1 then 
            return sum /3*2
        else
            return sum /4*3 - 0.5
        end
    end

    --[[--
     * @Description: 排操作牌  
     ]]
    function this:SortOper()
        local xOffset = 0
        for i=1,#operCardList do
            local oper = operCardList[i]
            oper.operObj.transform.localPosition = Vector3(xOffset, 0, 0)
            xOffset = xOffset + operCardList[i]:GetWidth() + mahjongConst.MahjongOperCardInterval
        end
    end

    --[[--
     * @Description: 设置是否能出牌  
     ]]
    function this:SetCanOut( isCanCout )
        canOutCard = isCanCout
        --[[
        if canOutCard == false and curClickMJItem~=nil then
            for i,v in ipairs(this.handCardList) do
                if v == curClickMJItem then
                    curClickMJItem:OnClickUp()
                    curClickMJItem =nil
                    break
                end
            end
        end]]
    end

    --[[--
     * @Description: 初始化手牌拖动事件  
     ]]
    function this:AddDragEvent()
        for i,v in ipairs(this.handCardList) do
            v.dragEvent = function( v )
                this:DragCardEvent( v )
            end
            v:AddEventListener() 
        end
    end

    --[[--
     * @Description: 麻将点击事件  
     ]]
    function this:ClickCardEvent( mj )
        ui_sound_mgr.PlaySoundClip("common/audio_card_click")
        if mj == curClickMJItem then
            if canOutCard then
                local paiVal = mj.paiValue
                print("-----------ClickCardEvent paiVal"..paiVal)
                mahjong_play_sys.OutCardReq(paiVal)
            end
        else
            if curClickMJItem~=nil then
                curClickMJItem:OnClickUp()
            end
            curClickMJItem = mj
            curClickMJItem:OnClickDown()
            mode_manager.GetCurrentMode():GetComponent("comp_playerMgr"):SetHighLight(curClickMJItem.paiValue)
        end
    end

    function this:CancelClick()
        if curClickMJItem~=nil then
            curClickMJItem:OnClickUp()
            curClickMJItem = nil
        end
    end

    --[[--
     * @Description: 麻将拖动事件  
     ]]
    function this:DragCardEvent(mj)
        if curClickMJItem~=nil and curClickMJItem~=mj then
            curClickMJItem:OnClickUp()
        end
        if canOutCard then
            local paiVal = mj.paiValue
            print("-----------DragCardEvent paiVal"..paiVal)
            curClickMJItem = mj
            mahjong_play_sys.OutCardReq(paiVal)
        end
    end

    --[[--
     * @Description: 出牌  
     ]]
    function this:OutCard(paiValue, callback)
        this.handCardCount = this.handCardCount - 1
        if this.viewSeat == 1 then
            local isOut = false
            for i = 1,#this.handCardList,1 do
                if this.handCardList[i].paiValue == paiValue and curClickMJItem == this.handCardList[i] then
                    local item = this.handCardList[i]
                    this.handCardList[i].eventPai = nil
                    this.handCardList[i]:ClearEvent()
                    table.remove(this.handCardList,i)
                    curClickMJItem = nil
                    this:DoOutCard(item, callback)
                    isOut = true
                    break
                end
            end
            
            if isOut then
                return
            end

            for i = 1,#this.handCardList,1 do
                if this.handCardList[i].paiValue == paiValue then
                    local item = this.handCardList[i]
                    this.handCardList[i].eventPai = nil
                    this.handCardList[i]:ClearEvent()
                    table.remove(this.handCardList,i)
                    this:DoOutCard(item, callback)
                    break
                end
            end
            
        else
            local index = math.random(1, #this.handCardList)
            local item = this.handCardList[index]
            table.remove(this.handCardList,index) 
            item:SetMesh(paiValue)
            this:DoOutCard(item, callback)
        end
    end

    local DoOutCard_c -- 出牌动作协程

    --[[--
     * @Description: 出牌动作  
     ]]
    function this:DoOutCard(item, callback)
        DoOutCard_c = coroutine.start(function ()
            --print("DoOutCard viewSeat"..this.viewSeat.." mjvalue "..item.paiValue)
            --print("DoOutCard viewSeat"..this.viewSeat.." mjname "..item.mjObj.name)
            local mj = item
            mj.mjObj.transform:SetParent(this.outCardPoint, false)
            if this.viewSeat == 1 then
                RecursiveSetLayerVal(mj.mjObj.transform,this.outCardPoint.gameObject.layer)
                --mj.mjObj.layer = this.outCardPoint.gameObject.layer
            end

            if mj.isHun == true then
                mj:SetHun(false)
            end

            local endPos = this:GetOutCardPos()
            mj.mjObj.transform:DOLocalMove(endPos + Vector3(0.1, 0, -0.15), 0.3,false):SetEase(DG.Tweening.Ease.OutQuart)
            mj.mjObj.transform:DOLocalRotate(Vector3.zero, 0.3,DG.Tweening.RotateMode.Fast)
            table.insert(this.outCardList,mj)
            coroutine.wait(0.5)
            this:SortHandCard(true)
            mj.mjObj.transform:DOLocalMove(endPos, 0.2,false):SetEase(DG.Tweening.Ease.InExpo):OnComplete(function ()
                if callback ~= nil then
                    callback(mj.mjObj.transform.position + Vector3.New(0, 0.102, 0))
                end
            end)
        end)
    end

    --[[--
     * @Description: 获取出牌位置  
     ]]
    function this:GetOutCardPos()
        local x, z
        local x_num = mahjongConst.OutCardNum_x
        if roomdata_center.MaxPlayer() == 2 then
            x_num = mahjongConst.OutCardNum_x + 5
        elseif roomdata_center.MaxPlayer() == 3 then
            x_num = mahjongConst.OutCardNum_x + 2
        end
        x = #this.outCardList % x_num
        z = #this.outCardList / x_num
        return Vector3(x * mahjongConst.MahjongOffset_x, 0, -math.floor(z) * mahjongConst.MahjongOffset_z)
    end

    --[[--
     * @Description: 获取出牌和操作中指定牌值的牌  
     ]]
    function this:GetSameValueItem(value)
        local t = {}
        --出牌
        for i=1,#this.outCardList do
            if this.outCardList[i].paiValue == value then
                table.insert(t,this.outCardList[i])
            end
        end
        --操作牌
        for i=1,#operCardList do
            local oper = operCardList[i]
            --print("#oper.itemList--------------------"..#oper.itemList)
            for j=1,#oper.itemList do
                if oper.itemList[j].paiValue == value then
                    table.insert(t,oper.itemList[j])
                end
            end
        end
        return t
    end

    --[[--
     * @Description: 获取最后出的牌  
     ]]
    function this:GetLastOutCard()
        if (#this.outCardList > 0) then
            local mj = this.outCardList[#this.outCardList]
            table.remove(this.outCardList)
            return mj
        else
            logError("!!!!GetLastOutCard error")
            return nil
        end
    end

    --[[--
     * @Description: 执行操作牌  
     ]]
    function this:OperateCard( operData,mj )
        --print("!!!!!!!!---------OperateCard----------operData.operType "..operData.operType)
        --print("!!!!!!!!---------OperateCard----------operData.operCard "..tostring(operData.operCard))
        if(operData.operType == MahjongOperAllEnum.TripletLeft or
           operData.operType == MahjongOperAllEnum.TripletCenter or
           operData.operType == MahjongOperAllEnum.TripletRight or
           operData.operType == MahjongOperAllEnum.BrightBarLeft or
           operData.operType == MahjongOperAllEnum.BrightBarCenter or
           operData.operType == MahjongOperAllEnum.BrightBarRight ) then
            this:CreateOperCard(operData,mj)
        end
        if operData.operType == MahjongOperAllEnum.DarkBar then
            this:CreateOperCard(operData)
        end
        if(operData.operType == MahjongOperAllEnum.AddBar or
            operData.operType == MahjongOperAllEnum.AddBarLeft or
            operData.operType == MahjongOperAllEnum.AddBarCenter or
            operData.operType == MahjongOperAllEnum.AddBarRight ) then
            this:AddOperCard(operData)
            this:SortOper()
        end
        if operData.operType == MahjongOperAllEnum.Collect then
            this:CreateOperCard(operData,mj)
        end
        this:SortHandCard(false)
    end

    --[[--
     * @Description: 创建一个操作组  
     ]]
    function this:CreateOperCard( operData,mj )
        local xOffset = 0
        for i=1,#operCardList do
            xOffset = xOffset + operCardList[i]:GetWidth() + mahjongConst.MahjongOperCardInterval
        end
        local oper = comp_operatorcard.create()
        print("operCardPoint----------------------------------------"..tostring(operCardPoint.name))
        oper.operObj.transform.parent = operCardPoint
        oper.operObj.transform.localPosition = Vector3(xOffset, 0, 0)
        oper.operObj.transform.localRotation = Vector3.zero
        oper:Show(operData, this:GetOperCardList(operData, mj))
        table.insert(operCardList, oper)
    end

    --[[--
     * @Description: 获取具体操作的牌组对象列表  
     ]]
    function this:GetOperCardList( operData,mj )
        local index = 1
        local list = {}

        local searchCard = operData.otherOperCard
        if operData.operType == MahjongOperAllEnum.DarkBar then
            table.insert(searchCard,operData.operCard)
        end

        for i=1,#searchCard do
            this.handCardCount = this.handCardCount - 1
            if this.viewSeat == 1 then
                print("this:GetOperCardList( operData,mj )")
                index = 1
                while(index<=#this.handCardList) do
                    if(this.handCardList[index].paiValue == searchCard[i]) then
                        local mjItem = this.handCardList[index]
                        mjItem:SetTingIcon(false)
                        mjItem.eventPai = nil
                        table.remove(this.handCardList,index)
                        table.insert(list,mjItem)
                        break
                    end
                    index = index + 1
                end
            else
                local index = math.random(1,#this.handCardList)
                local mjItem = this.handCardList[index]
                mjItem:SetMesh(searchCard[i])
                table.remove(this.handCardList,index)
                table.insert(list,mjItem)
            end
        end


        if mj~=nil then
            table.insert(list,mj)
            this.InsertSort(list)
        end
        return list
    end

    --[[--
     * @Description: 给操作组添加牌  
     ]]
    function this:AddOperCard( operData )
        --print("!!!!!!!!---------AddOperCard----------operData.operCard "..operData.operCard.." operCardList[i].keyItem.paiValue "..operCardList[i].keyItem.paiValue)
        for i=1,#operCardList do
            if(operCardList[i].keyItem~=nil and operData.operCard == operCardList[i].keyItem.paiValue) then
                local mj = nil
                local index = 1
                this.handCardCount = this.handCardCount - 1
                if this.viewSeat == 1 then
                    while(index<=#this.handCardList) do
                        if(this.handCardList[index].paiValue == operData.operCard) then
                            mj = this.handCardList[index]
                            mj.eventPai = nil
                            table.remove(this.handCardList,index)
                            break
                        end
                        index = index + 1
                    end
                else
                    local index = math.random(1,#this.handCardList)
                    mj = this.handCardList[index]
                    mj:SetMesh(operData.operCard)
                    table.remove(this.handCardList,index)
                end
                operCardList[i]:AddShow(operData,mj,true)
            else
                --print("!!!!!!!!---------AddOperCard----------operData.operCard "..operData.operCard.." operCardList[i].keyItem.paiValue "..operCardList[i].keyItem.paiValue)
            end
        end
    end

    --[[--
     * @Description: 恢复出牌
     ]]
    function this:ResetOutCard(cardItems,cardsValue)
        --print("------------ResetOutCard")
        for i=1,#cardItems do
            local mj = cardItems[i]
            mj:SetMesh(cardsValue[i])
            mj.mjObj.transform:SetParent(this.outCardPoint,false)
            local endPos = this:GetOutCardPos()
            mj.mjObj.transform.localPosition = endPos
            mj.mjObj.transform.localEulerAngles = Vector3.zero
            if mj.paiValue == roomdata_center.jin then
                mj:SetJin(true)
            end
            table.insert(this.outCardList,mj)
        end
    end

    --[[--
     * @Description: 恢复操作牌  
     ]]
    function this:ResetOperCard(GetResetCardsFunc,operData)
        for i=1,#operData do
            local data = operData[i]
            local ucFlag = data.ucFlag  -- 类型
            local card = data.card      -- 操作牌
            local operWho = data.value  -- 拿谁的牌

            --创建一个操作牌组
            local xOffset = 0
            for i=1,#operCardList do
                xOffset = xOffset + operCardList[i]:GetWidth() + mahjongConst.MahjongOperCardInterval
            end
            local oper = comp_operatorcard.create()
            oper.operObj.transform:SetParent(operCardPoint, false)
            oper.operObj.transform.localPosition = Vector3(xOffset, 0, 0)
            oper.operObj.transform.localEulerAngles = Vector3.zero

            --计算操作牌方向
            local operWhoViewSeat = room_usersdata_center.GetViewSeatByLogicSeatNum(operWho)
            local offset = operWhoViewSeat - this.viewSeat 

            if offset<1 then
                offset = offset +roomdata_center.MaxPlayer()      -- 3：左 2：中 1：右
            end

            --吃
            if ucFlag == 16 then        
                local operType = MahjongOperAllEnum.Collect
                local od = operatordata:New(operType,card,{card+1,card+2})
                local cards = GetResetCardsFunc(3)
                cards[1]:SetMesh(card)
                cards[2]:SetMesh(card+1)
                cards[3]:SetMesh(card+2)
                oper:ReShow(od, cards)
            --碰
            elseif ucFlag == 17 then    
                local operType
                if(offset == 3) then
                    operType = MahjongOperAllEnum.TripletLeft
                end
                if(offset == 2) then
                    operType = MahjongOperAllEnum.TripletCenter
                end
                if(offset == 1) then
                    operType = MahjongOperAllEnum.TripletRight
                end
                local od = operatordata:New(operType,card,{card,card})
                local cards = GetResetCardsFunc(3)
                for i=1,#cards do
                    cards[i]:SetMesh(card)
                end
                oper:ReShow(od, cards)
            --明杠
            elseif ucFlag == 18 then    
                if(offset == 3) then
                    operType = MahjongOperAllEnum.BrightBarLeft
                end
                if(offset == 2) then
                    operType = MahjongOperAllEnum.BrightBarCenter
                end
                if(offset == 1) then
                    operType = MahjongOperAllEnum.BrightBarRight
                end
                local od = operatordata:New(operType,card,{card,card,card})
                local cards = GetResetCardsFunc(4)
                for i=1,#cards do
                    cards[i]:SetMesh(card)
                end
                oper:ReShow(od, cards)
            --暗杠
            elseif ucFlag == 19 then    
                operType = MahjongOperAllEnum.DarkBar
                local od = operatordata:New(operType,card,{card,card,card})
                local cards = GetResetCardsFunc(4)
                for i=1,#cards do
                    cards[i]:SetMesh(card)
                end
                oper:ReShow(od, cards)
            --碰杠
            elseif ucFlag == 20 then    
                operType = MahjongOperAllEnum.AddBar
                local od = operatordata:New(operType,card,{card,card,card})
                local cards = GetResetCardsFunc(4)
                for i=1,#cards do
                    cards[i]:SetMesh(card)
                end
                oper:ReShow(od, cards)
            end

            table.insert(operCardList, oper)
        end
    end

    --[[--
     * @Description: 恢复手牌  
     ]]
    function this:ResetHandCard(cardItems,cardsValue)
        if cardsValue~=nil then
            table.sort(cardsValue)
        end
        for i=1,#cardItems do
            local mj = cardItems[i]
            mj.mjObj.transform:SetParent(this.handCardPoint, false)
            local x = #this.handCardList * mahjongConst.MahjongOffset_x + this:GetOperTotalWidth()

            --if isStart== false then
            --    x = x +mahjongConst.MahjongOffset_x/2
            --end

            mj.mjObj.transform.localPosition = Vector3(x, 0, 0)
            mj.mjObj.transform.localEulerAngles = Vector3.zero            

            if this.viewSeat == 1 then
                mj:SetMesh(cardsValue[i])
                RecursiveSetLayerVal(mj.mjObj.transform,this.handCardPoint.gameObject.layer)
                mj:AddEventListener()

                if roomdata_center.hun~=nil and roomdata_center.hun == mj.paiValue then
                    mj:SetHun(true)
                end

                if roomdata_center.jin ~= nil and roomdata_center.jin == mj.paiValue then
                    mj:SetJin(true)
                end

                mj.eventPai = function( mj )
                    this:ClickCardEvent( mj )
                end

                mj.dragEvent = function( mj )
                    this:DragCardEvent( mj )
                end                
            else
                mj:SetMesh(MahjongTools.GetRandomCard())
            end
            this.handCardCount = this.handCardCount + 1
            table.insert(this.handCardList,mj)
        end

        if this.viewSeat == 1 then
            this:SortHandCard(false)
        end

    end

    function this.StopAllCoroutine()
    end


	this.base_unInit = this.Uninitialize
	
	function this:Uninitialize()
		this.base_unInit()
        coroutine.stop(ArrangeHandCard_c)
        coroutine.stop(SortHandCard_c)
        coroutine.stop(DoOutCard_c)
        
        ArrangeHandCard_c = nil
        SortHandCard_c = nil
        DoOutCard_c = nil
	end

    CreateObj()
    -- InitPoint()

	return this
end