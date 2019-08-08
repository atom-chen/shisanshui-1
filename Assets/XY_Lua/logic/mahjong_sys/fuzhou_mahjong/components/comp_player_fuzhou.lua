--[[--
 * @Description: 玩家组件
 * @Author:      ShushingWong
 * @FileName:    comp_player_fuzhou.lua
 * @DateTime:    2017-07-13 11:22:26
 ]]

comp_player_fuzhou = {}
function comp_player_fuzhou.create()
	require "logic/mahjong_sys/mode_components/comp_player"
	local this = comp_player.create()
	this.Class = comp_player_fuzhou
	this.name = "comp_player"

    -- 缓存在桌子中间花牌
    this.showHuaInTableCardList = {}

	local compTable = nil

	function this:GetTable()
        if compTable ~= nil then
            return compTable
        end
        compTable = mode_manager.GetCurrentMode():GetComponent("comp_table")
        return compTable
    end


    local DunIndexToLocalHandIndex = 
    {
        [1] = 4,
        [2] = 2,
        [3] = 3,
        [4] = 1,
    }

    function this:AddDun(mjs)
        if mjs == nil or #mjs == 0 then
            return
        end

        local listCount = #mjs

        local mjList = {}
        if listCount == 4 then
            for i, v in ipairs(mjs) do
                mjList[DunIndexToLocalHandIndex[i]] = mjs[i]
            end
        else
            mjList[1] = mjs[1]
        end


        local x
        local z = 0

        if this.viewSeat == 1 then
        -- 组 最左边位置
            if listCount > 1 then
                x = 5.3
            else
                x = 6.4
            end
        else
            x = this.handCardCount * mahjongConst.MahjongOffset_x
            --别人的牌墩 默认放在中间
            if x < 7 * mahjongConst.MahjongOffset_x then
                x = 7 * mahjongConst.MahjongOffset_x
            end
        end


        
        local moveMjFunc = function(mj, x, z) 
            mj.mjObj.transform:SetParent(this.handCardPoint, false) 
            mj.mjObj.transform:DOLocalMove(Vector3(x, 0, z), 0.05, false)
            mj.mjObj.transform:DOLocalRotate(Vector3(-90,0,0), 0.05,DG.Tweening.RotateMode.Fast)
            if this.viewSeat == 1 then
                mj.eventPai = function( mj )
                    this:ClickCardEvent( mj )
                end
            end
        end


        --庄家单张
        if listCount == 1 then
            moveMjFunc(mjList[1], x, z)
        else
            -- 将四张牌一起挪到指定位置
            moveMjFunc(mjList[3], x, mahjongConst.MahjongOffset_y)
            moveMjFunc(mjList[1], x, 0)
            x = x + mahjongConst.MahjongOffset_x
            moveMjFunc(mjList[4], x, mahjongConst.MahjongOffset_y)
            moveMjFunc(mjList[2], x, 0)
        end

        this:ArrangeMjList(mjList)    

        if listCount == 1 then
            table.insert(this.handCardList, mjList[1])
        else
            for i = 1, 4 do
                table.insert(this.handCardList, mjList[i])
            end
        end
    end


    local ArrangeMjList_c
    -- 将两墩展开，上层两张牌放到后面，并掀开
    function this:ArrangeMjList(mjList, callback)
        --向后平移/向下
        local moveFunc = function(mj, down)
            local pos = mj.mjObj.transform.localPosition
            if not down then
                mj.mjObj.transform:DOLocalMove(Vector3(pos.x + mahjongConst.MahjongOffset_x * 2, 0, pos.z), 0.2, false)
            else
                mj.mjObj.transform:DOLocalMove(Vector3(pos.x, 0, 0), 0.2, false)
            end
        end


        ArrangeMjList_c = coroutine.start(function()
                    coroutine.wait(0.05)
                    if #mjList == 4 then
                        --平移
                       
                        moveFunc(mjList[3])
                        moveFunc(mjList[4])

                        coroutine.wait(0.2)
                        -- 下移
                        moveFunc(mjList[3], true)
                        moveFunc(mjList[4], true)
                    end

                    coroutine.wait(0.1)

                    -- 翻牌
                    for i, v in ipairs(mjList) do
                        v.mjObj.transform:DOLocalRotate(Vector3.zero, 0.2, DG.Tweening.RotateMode.Fast)
                    end

                    coroutine.wait(0.2)

                    for i, v in ipairs(mjList) do   
                        if this.viewSeat == 1 then
                            RecursiveSetLayerVal(mjList[i].mjObj.transform,MahjongLayer.TwoDLayer)
                            mjList[i]:AddEventListener()
                            mjList[i].dragEvent = function(mj)
                                this:DragCardEvent(mj)
                            end
                        end
                    end

                    -- 移动到牌的位置
                    for i, v in ipairs(mjList) do 
                        mjList[i].mjObj.transform:DOLocalMove(Vector3(mahjongConst.MahjongOffset_x * (this.handCardCount + i - 1), 0, 0), 0.2, false)
                    end


                    coroutine.wait(0.1)

                    

                    this.handCardCount = this.handCardCount + #mjList
                end
                )    

    end

    -- function this.InsertSort( list )
    --      for i = 2,#list,1 do
    --         local insertItem = list[i]
    --         local insertIndex = i - 1
    --         while (insertIndex > 0 and (insertItem.paiValue < list[insertIndex].paiValue or insertItem.isJin))
    --         do
    --             list[insertIndex + 1] = list[insertIndex]
    --             insertIndex = insertIndex -1
    --         end
    --         list[insertIndex + 1] = insertItem
    --     end
    -- end


    local RemoveFlowers_c

    -- 通用玩家显示补花操作
    -- 位置， 花牌，花牌数量, 替换牌，回调
    function this:RemoveChangeFlowers( flowerCards, flowerCount, isDeal)
        if flowerCount == 0 then
            return 0
        end

        this.handCardCount = this.handCardCount - flowerCount
        -- 飞到屏幕中心时间
        local moveToCenterTime = 0.2
        -- 隐藏时间
        local hideTime = 0

        local time = 0
        
        ChangeFlowers_c = coroutine.start(function()

        local mjList = {}
        -- 飞到屏幕中间
        if this.viewSeat == 1 then
            mjList = this:GetSelfCardsByCardValueList(flowerCards, true, true)
            --this:DoSelfCardsMoveToCenter(mjList, moveToCenterTime)
        else
            mjList = this:GetOterCardsByCount(flowerCards, flowerCount, true)
            --this:DoOtherCardsMoveToCenter(mjList, moveToCenterTime)
        end

       
        if isDeal then
            this:DoMoveToHuaPoint(mjList, this.viewSeat == 1)
            coroutine.wait(0.2)
        else
            coroutine.wait(0.3)
            
            for i = 1, #mjList do 
                local pos = mjList[i].mjObj.transform.localPosition
                pos.z = pos.z + mahjongConst.MahjongOffset_y
                mjList[i]:DOLocalMove(pos, 0.2)
            end
            coroutine.wait(0.2)
            this:GetTable():DoHideHuaCardsToPoint(mjList, this.viewSeat, 0.3, nil, this.viewSeat == 1)
        end

        -- this:SortHandCard(false)

        -- coroutine.wait(0.3)
        -- 隐藏
        -- this:GetTable():DoHideHuaCardsToPoint(mjList, this.viewSeat, hideTime)


        end)

       return time + hideTime
    end

    function this:DoMoveToHuaPoint(mjList,isSelf)
        local mj
        local moveTime = 0.2
        local x, y
        for i = 1, #mjList do
            mj = mjList[i]
            mj:SetParent(this.huaPointRoot)
            if isSelf then
                mj:Set3DLayer()
            end
            x = (math.fmod(#this.showHuaInTableCardList, 12) + 3)* mahjongConst.MahjongOffset_x
            z = math.floor(#this.showHuaInTableCardList / 12) * mahjongConst.MahjongOffset_z
            mj:DOLocalMove(Vector3(x,0,z), moveTime)
            table.insert(this.showHuaInTableCardList, mj)
        end
    end

    function this:DoHideFlowerCards()
        if #self.showHuaInTableCardList == 0 then
            return
        end
        this:GetTable():DoHideHuaCardsToPoint(this.showHuaInTableCardList ,this.viewSeat, 0.2, function() this.showHuaInTableCardList = {} end)
    end


    function this:DoSelfCardsMoveToCenter(mjList, time)
        this:GetTable():MoveMjListTo2DCenter(mjList, time)
    end

    function this:DoOtherCardsMoveToCenter(mjList, time)
        this:GetTable():MoveMjListTo3DCenter(mjList, time)
        coroutine.wait(time+ 0.05)
        this:GetTable():MoveMjListTo2DCenter(mjList, 0)
    end

    -- 获取自己手牌中指定列表
    -- reverse : 是否反序查找 
    -- remove : 是否要移除列表
    function this:GetSelfCardsByCardValueList(cardValues, reverse, remove)
        local count = #cardValues
        if count == 0 then
            return nil
        end

        local beginInex = (reverse and #this.handCardList) or 1
        local step = (reverse and -1) or 1
        local endIndex = (reverse and 1) or #this.handCardList
        local targetList = {}
        for i = 1, #cardValues do
            for j = beginInex, endIndex, step do
                if cardValues[i] == this.handCardList[j].paiValue then
                    table.insert(targetList, this.handCardList[j])
                    if remove then
                        table.remove(this.handCardList, j)
                        beginInex = (reverse and #this.handCardList) or 1
                    end
                    break
                end
            end
        end
        if #targetList ~= #cardValues then
            logError('补花异常，数目不对应', #cardValues, #targetList)
        end


        return targetList
    end

    -- 默认倒着移除
    function this:GetOterCardsByCount(flowerCards, count, remove)
        local targetList = {}
        for i = count, 1, -1 do
            local handCards = #this.handCardList
            table.insert(targetList, this.handCardList[handCards - i + 1])
            this.handCardList[handCards - i + 1]:SetMesh(flowerCards[i])
            if remove then
                table.remove(this.handCardList,handCards - i + 1)
            end
        end
        return targetList
    end

    function this:ShowLaiInHand()
        for i=1,#this.handCardList do
            if this.handCardList[i].paiValue == roomdata_center.hun then
                this.handCardList[i]:SetHun( true )
            elseif this.handCardList[i].paiValue == roomdata_center.jin then
                this.handCardList[i]:SetJin(true)
            end
        end
    end


    function this:ShowJinInHand()
         for i=1,#this.handCardList do
            if this.handCardList[i].paiValue == roomdata_center.jin then
                this.handCardList[i]:SetJin(true)
            end
        end
        self:SortHandCard(false)
    end

    function this:ShowTingInHand()
        for i = 1, #this.handCardList do
            if roomdata_center.CheckCardTing(this.handCardList[i].paiValue) then
                this.handCardList[i]:SetTingIcon(true)
            end
        end
    end

    function this:HideTingInHand()
          for i = 1, #this.handCardList do
            this.handCardList[i]:SetTingIcon(false)
        end
    end

    --出牌动作
    function this:DoOutCard(item, callback)
        this.DoOutCard_c = coroutine.start(function ()
            --log("DoOutCard viewSeat"..this.viewSeat.." mjvalue "..item.paiValue)
            --log("DoOutCard viewSeat"..this.viewSeat.." mjname "..item.mjObj.name)
            local mj = item;
            mj.mjObj.transform:SetParent( this.outCardPoint, false)
            if this.viewSeat == 1 then
                RecursiveSetLayerVal(mj.mjObj.transform,this.outCardPoint.gameObject.layer)
                --mj.mjObj.layer = this.outCardPoint.gameObject.layer
            end

            if mj.isHun == true then
                mj:SetHun(false)
            end

            if mj.paiValue == roomdata_center.jin then
                mj:SetJin(true)
            end
            -- if mj.isJin then 
            --     mj:SetJin(false)
            -- end

            local endPos = this:GetOutCardPos();
             mj.mjObj.transform:DOLocalMove(endPos, 0.2,false):OnComplete(function ()
                if callback ~= nil then
                    callback(mj.mjObj.transform.position + Vector3.New(0, 0.102, 0))
                end
            end)
            -- mj.mjObj.transform:DOLocalMove(endPos + Vector3(0.1, 0, -0.15), 0.1,false);
            -- mj.mjObj.transform:DOLocalMove(endPos, 0.2,false);
            mj.mjObj.transform:DOLocalRotate(Vector3.zero, 0.1,DG.Tweening.RotateMode.Fast);
            table.insert(this.outCardList,mj)
            -- coroutine.wait(0.2)
            this:SortHandCard(true)
           
        end)
    end

    this.playerBase_unInit = this.Uninitialize
    function this:Uninitialize()
		this.playerBase_unInit()
        this.StopAllCoroutine()
	end

    function this.StopAllCoroutine()
        coroutine.stop(ArrangeMjList_c)
        coroutine.stop(BuHuaInHand_c)
        coroutine.stop(ChangeFlowers_c)
    end

	return this
end

return comp_player_fuzhou