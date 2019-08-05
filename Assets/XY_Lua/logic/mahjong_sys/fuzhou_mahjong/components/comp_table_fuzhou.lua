--[[--
 * @Description: 福州麻将桌组件
 * @Author:      shine
 * @FileName:    comp_table_fuzhou.lua
 * @DateTime:    2017-07-11 16:35:59
 ]]

--comp_table_fuzhou = comp_table.New()
comp_table_fuzhou = {}
function comp_table_fuzhou.create()
	require "logic/mahjong_sys/mode_components/comp_table"
	local this = comp_table.create()
	this.Class = comp_table_fuzhou
	this.name = "comp_table"

    this.baseUnInit = this.Uninitialize
    this.baseStopAllCoroutine = this.StopAllCoroutine
    -- 金牌
    this.mjJin = nil 

    function this:SendAllHandCard(dun,viewSeat,cards,cb)
        this.SendAllHandCard_c = coroutine.start(function ()            
            this.sendIndex = dun * 2 + (viewSeat-1) * this.config.MahjongDunCount * 2--发牌位置
            this.lastIndex = this.sendIndex + 2
            local cardsIndex = 1
            local zhunagOffset =  roomdata_center.zhuang_viewSeat - 1
            local waitTime = 0.1
            local mjList = {}
            local playerNum = roomdata_center.MaxPlayer()
            --5圈牌
            for i = 1,5,1 do
                --4人
                for j = 1,playerNum,1 do
                    local num = 4
                    -- 庄 多摸一张
                    if (i == 5) then
                        if (1 == j) then
                            num = 1
                        else
                            num = 0
                        end
                    end

                    local playerVSeat = j + zhunagOffset
                    if playerVSeat > playerNum then
                        playerVSeat = playerVSeat -playerNum
                    end

                    --牌数
                    for k = 1,num,1 do
                        if (this.sendIndex <= 0) then
                            this.sendIndex = this.config.MahjongTotalCount
                        end

                        local mj = this:GetMJItem(this.sendIndex)                       
                  
                        waitTime = 1
                        this.sendIndex = this.sendIndex - 1 

                        local paiValue = MahjongTools.GetRandomCard()
                        if playerVSeat == 1 and cards ~= nil then
                            paiValue = cards[cardsIndex]
                            cardsIndex = cardsIndex + 1
                        end

                        if mj ~= nil then
                            mj:SetMesh(paiValue)
                            table.insert(mjList, mj)
                        end
                    end

                    
                    this.compPlayerMgr:GetPlayer(playerVSeat):AddDun(mjList)  

                    mjList = {}

                    ui_sound_mgr.PlaySoundClip("common/audio_deal_card")
                        
                  
                end

                -- if i < 5 or (i == 5 and j == 1) then
                coroutine.wait(0.8)
                -- end
            end
            if cb ~= nil then
                cb()
            end
        end)
    end


    function this:GetNextLastIndex(currentLastIndex, totalCount)
        local totalCount = this.config.MahjongTotalCount
        currentLastIndex = currentLastIndex - 1
        if math.fmod(currentLastIndex,2) == 0 then
            currentLastIndex = currentLastIndex + 4
            if currentLastIndex > totalCount then
                currentLastIndex = currentLastIndex - totalCount
            end
        end
        return currentLastIndex
    end



    function this:SendCardFromLast(viewseat, paiValue,isDeal)
        if this.lastIndex > this.config.MahjongTotalCount then
            this.lastIndex = this.lastIndex - this.config.MahjongTotalCount
        end
        mj = this:GetMJItem(this.lastIndex)

        -- this.lastIndex = this.lastIndex - 1
        -- if math.fmod(this.lastIndex,2) == 0 then
        --     this.lastIndex = this.lastIndex + 4
        -- end
        this.lastIndex = this:GetNextLastIndex(this.lastIndex)

        this:UpdateJinPosition()

        mj:SetMesh(paiValue)

        this.compPlayerMgr:GetPlayer(viewseat):AddHandCard(mj,isDeal)
    end


    --从牌尾拿牌
    function this:GetResetCardsFromLast(count)
        local list = {}
        for i = 1, count do 
            if this.lastIndex > this.config.MahjongTotalCount then
                this.lastIndex = this.lastIndex - this.config.MahjongTotalCount
            end
            mj = this:GetMJItem(this.lastIndex)

            -- this.lastIndex = this.lastIndex - 1
            -- if math.fmod(this.lastIndex,2) == 0 then
            --     this.lastIndex = this.lastIndex + 4
            -- end
            this.lastIndex = this:GetNextLastIndex(this.lastIndex)
            table.insert(list, mj)
        end
        return list
    end

    local changeFlower_c
    function this:ShowChangeFlowers(viewSeat, flowerCards, flowerCount, newCards, callback,isDeal)
        flowerCount = #flowerCards
        changeFlower_c = coroutine.start(function()
        this.compPlayerMgr:GetPlayer(viewSeat):RemoveChangeFlowers(flowerCards,flowerCount, isDeal)
        if isDeal then
            coroutine.wait(0.5)
        else
            coroutine.wait(0.9)
        end
        for i = 1, flowerCount do
            local value = MahjongTools.GetRandomCard()
            if viewSeat == 1 then
                value = newCards[i]
            end

            this:SendCardFromLast(viewSeat, value,isDeal)
        end

        coroutine.wait(0.05)

        if isDeal then
            this.compPlayerMgr:GetPlayer(viewSeat):SortHandCard(false)
        else
            -- 打牌阶段 补花不需要排序
            -- this.compPlayerMgr:GetPlayer(viewSeat):SortHandCard(true)
        end

        if callback ~= nil then
            callback()
        end
        end)
    end

    -- 在最后一张牌移动之前调用
    function this:UpdateJinPosition()
        if this.mjJin == nil then
            return
        end

        -- local targetIndex
        -- if math.fmod(this.lastIndex, 2) == 0 then
        --     targetIndex = this.lastIndex + 8 * 2
        -- else
        --     targetIndex = this.lastIndex + 8 * 2 + 1
        -- end        

        -- if targetIndex > this.config.MahjongTotalCount then
        --     targetIndex = targetIndex - this.config.MahjongTotalCount
        -- end

        -- local mj = this:GetMJItem(targetIndex)
        -- local pos = mj.mjObj.transform.localPosition
        -- local eulers = mj.mjObj.transform.localEulerAngles

        -- this.mjJin.mjObj.transform:SetParent(mj.mjObj.transform.parent, false)

        -- -- if this.mjJin.mjObj.transform.parent ~= parent then
        -- --     this.mjJin.mjObj.transform:SetParent(parent, false)
        -- -- end
        -- -- local x = 0
        -- -- if math.fmod(this.lastIndex, 2) == 0 then
        -- --     x = pos.x
        -- -- else
        -- --     x = pos.x - mahjongConst.MahjongOffset_x
        -- -- end
        -- this.mjJin:DOLocalMove(Vector3(pos.x, pos.y + mahjongConst.MahjongOffset_y, pos.z), 0)
        -- this.mjJin:DOLocalRotate(Vector3(0, 180, 0), 0)
        this:UpdateJinAtLastIndex()
       
    end

    -- 在最后一张牌上
    function this:UpdateJinAtLastIndex()
        local mj = this.compMjItemMgr.mjItemList[this.lastIndex]
        local pos = mj.mjObj.transform.localPosition
        local eulers = mj.mjObj.transform.localEulerAngles
        local parent = mj.mjObj.transform.parent
        if this.mjJin.mjObj.transform.parent ~= parent then
            this.mjJin.mjObj.transform:SetParent(parent, false)
        end
        local x = 0
        local y = 0
        x = pos.x
        y = pos.y + mahjongConst.MahjongOffset_y
        this.mjJin:DOLocalMove(Vector3(x, pos.y + mahjongConst.MahjongOffset_y, pos.z), 0)
        local eulerY = 180
        if this.lastIndex >= 1 and this.lastIndex <= 36 then
            eulerY = 0
        end
        this.mjJin:DOLocalRotate(Vector3(0, eulerY, 0), 0)
    end

    -- 在最后一墩上
    function this:UpdateJinAtLastDun()
        local mj = this.compMjItemMgr.mjItemList[this.lastIndex]
        if mj == nil then
            logError("mj is nil", this.lastIndex)
        end
        if not Mathf.Approximately(mj.mjObj.transform.localPosition.y ,mahjongConst.MahjongOffset_y) then
            local tmpIndex = this:GetNextLastIndex(this.lastIndex)
          
            -- 前移一墩
            mj = this.compMjItemMgr.mjItemList[this.lastIndex]
        end

        local pos = mj.mjObj.transform.localPosition
        local eulers = mj.mjObj.transform.localEulerAngles
        local parent = mj.mjObj.transform.parent
        if this.mjJin.mjObj.transform.parent ~= parent then
            this.mjJin.mjObj.transform:SetParent(parent, false)
        end
        local x = 0
        local y = 0
        x = pos.x
        y = pos.y + mahjongConst.MahjongOffset_y
        this.mjJin:DOLocalMove(Vector3(x, pos.y + mahjongConst.MahjongOffset_y, pos.z), 0)
        this.mjJin:DOLocalRotate(Vector3(0, 180, 0), 0)
    end

    local HideAllFlowerInTable_c
    function this:HideAllFlowerInTable(callback)
        HideAllFlowerInTable_c = coroutine.start(function()
            this.compPlayerMgr:HideHuaInTable()
            coroutine.wait(0.5)
            if nil ~= callback then
                callback()
            end
        end)

    end


    local ShowJin_c

    function this:ShowJin(cardValue, isJin,isAnim, callback)

        local jinIndex = this.lastIndex
        if(jinIndex>this.config.MahjongTotalCount) then
            jinIndex = jinIndex - this.config.MahjongTotalCount
        end
        local mj = this.compMjItemMgr.mjItemList[jinIndex] 
        mj:SetMesh(cardValue)

        if isJin then
            this.mjJin = mj
            mj:SetJin(false)
        end

        this.lastIndex = this:GetNextLastIndex(this.lastIndex)

        -- this.lastIndex = this.lastIndex - 1
        -- if math.fmod(this.lastIndex,2) == 0 then
        --     this.lastIndex = this.lastIndex + 4
        -- end

        --@todo  更新牌数量，this.lastIndex 
        if not isAnim then
            if isJin then
                this:UpdateJinPosition()
            else
                mj:HideAndReset()
            end
            return
        end

       

        local originPos = mj.mjObj.transform.localPosition
        local euler = mj.mjObj.transform.localEulerAngles
        local originRoot = mj.mjObj.transform.parent
        ShowJin_c = coroutine.start(function() 

        

        this:MoveMjTo3DCenter(mj, 0.2)
        coroutine.wait(0.25)
        this:MoveMjTo2DCenter(mj, 0)

        coroutine.wait(0.5)

        -- 是金 则返回原位置
        if isJin then
            mj:Set3DLayer()
            mj.mjObj.transform:SetParent(originRoot, true)
            -- mj:DOLocalMove(originPos, 0.2)
            -- mj:DOLocalRotate(euler, 0.2)

            -- coroutine.wait(0.2)
            mj.Show(true, false)
            this:UpdateJinPosition()
            
        else
            this:DoHideHuaCardsToPoint({mj}, roomdata_center.zhuang_viewSeat, 0.2, nil, true)
            roomdata_center.AddFlowerCardToZhuang(cardValue)
            coroutine.wait(0.2)
        end
        if callback ~= nil then
            callback()
        end
        end)
    end


    -- 牌移动到3d中心
    function this:MoveMjTo3DCenter(mj, time, pos,rotate)
        pos = pos or Vector3.zero
        rotate = rotate or Vector3(-50, 0 ,0 )
        mj.mjObj.transform:SetParent(this.threeDCenterRoot, true)
        mj:DOLocalMove(pos, time)
        mj:DOLocalRotate(rotate, time)
    end

    -- 默认角度为0  表示正朝相机
    function this:MoveMjTo2DCenter(mj, time, pos, rotate)
        pos = pos or Vector3.zero
        mj:Set2DLayer()
        mj.mjObj.transform:SetParent(this.twoDCenterRoot, false)
        mj:DOLocalMove(pos, time)
        if rotate ~= nil then
            mj:DOLocalRotate(rotate, time)
        else
            mj:DOLocalRotate(Vector3.zero, time)
        end
    end

    -- 移动到玩家花牌位置
    function this:DoHideHuaCardsToPoint(mjList, viewSeat, time, callback, is2d)
        local point = mahjong_ui.GetPlayerHuaPointPos(viewSeat)
        -- point = Utils.NGUIPosTo2DCameraPos(point)
        if is2d then
            point = Utils.NGUIPosTo2DCameraPos(point)
        else
            point = Utils.NGUIPosTo3DCameraPos(point)
        end
        if point == nil then
            logError("找不到 viewSeat  " .. viewSeat)
        end
        for i = 1, #mjList do 
            -- mjList[i]:Set2DLayer()
            mjList[i].mjObj.transform:DOMove(point, time, false)
            mjList[i].mjObj.transform:DOScale(0.2, time)
        end

        if callback ~= nil then
            callback()
        end
        coroutine.wait(0.2)
        for i = 1, #mjList do
            mjList[i]:HideAndReset()
        end
    end


    function this:MoveMjListTo3DCenter(mjList, time, rotate)
        local count = #mjList
        local tmpPos = Vector3.zero
        for i = 1, count do
            tmpPos.x = -mahjongConst.MahjongOffset_x * (count - 1) / 2 + (i - 1) * mahjongConst.MahjongOffset_x
            this:MoveMjTo3DCenter(mjList[i], time, tmpPos, rotate)
        end
    end

    function this:MoveMjListTo2DCenter(mjList, time, rotate)
         local count = #mjList
        local tmpPos = Vector3.zero
        for i = 1, count do
            tmpPos.x = -mahjongConst.MahjongOffset_x * (count - 1) / 2 + (i - 1) * mahjongConst.MahjongOffset_x
            this:MoveMjTo2DCenter(mjList[i], time, tmpPos, rotate)
        end
    end

    function this:GetMJItem(index)
        local mj = this.compMjItemMgr.mjItemList[index]
        roomdata_center.UpdateRoomCard(-1)
        -- roomdata_center.leftCard = roomdata_center.leftCard -1
        -- mahjong_ui.SetLeftCard( roomdata_center.leftCard )
        return mj
    end

    function this:Clear()
        this.mjJin = nil
    end

    function this:StopAllCoroutine()
        this:baseStopAllCoroutine()
        coroutine.stop(ShowJin_c)
        coroutine.stop(HideAllFlowerInTable_c)
        coroutine.stop(changeFlower_c)
        coroutine.stop(HideAllFlowerInTable_c)
    end

    function this:Uninitialize()
        this.baseUnInit()
        coroutine.stop(ShowJin_c)
        coroutine.stop(HideAllFlowerInTable_c)
        coroutine.stop(changeFlower_c)
    end

	return this
end