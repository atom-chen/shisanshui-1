--[[--
 * @Description: 麻将桌组件
 * @Author:      shine
 * @FileName:    comp_table.lua
 * @DateTime:    2017-06-13 10:52:51
 ]]


comp_table = {}
comp_table.__index = comp_table
function comp_table.New()
    local self = {}
    setmetatable(self, comp_table)
    return self
end

function comp_table.create()
	require "logic/mahjong_sys/mode_components/mode_comp_base"
	local this = mode_comp_base.create()
	this.Class = comp_table
	this.name = "comp_table"

	this.config = nil

    this.compMjItemMgr = nil -- 麻将子管理组件
    this.compPlayerMgr = nil -- 玩家管理组件
    local tableObj = nil -- 桌子对象
    local tableModelObj = nil -- 桌子模型对象

    --local diceObj1 = nil -- 骰子1对象
    --local diceObj2 = nil -- 骰子2对象

    local mjSelectObj = nil -- 麻将选择效果对象
    local mjDirObj = nil -- 牌桌东南西北对象

    local timeLeft_trans = {} --倒计时十位列表
    local timeRight_trans = {} --倒计时个位列表

    this.threeDCenterRoot = nil
    this.twoDCeneterRoot = nil

    this.base_init = this.Initialize


	function this:Initialize()
		this.base_init()
        this.compMjItemMgr = this.mode:GetComponent("comp_mjItemMgr")
        this.compPlayerMgr = this.mode:GetComponent("comp_playerMgr")
        this.config = this.mode.config

        log("----------------------enter comp_table")
        this:InitTable()
        this:GetWallPoints() 
	end

	this.base_unInit = this.Uninitialize

    --[[--
     * @Description: 初始化牌桌对象  
     ]]
	function this:InitTable()
		local resTableObj = newNormalObjSync("Prefabs/Scene/Mahjong/MJTable", typeof(GameObject))	
		tableObj = newobject(resTableObj)

        tableModelObj = child(tableObj.transform, "majiangzhuo").gameObject
        this:ChangeDeskCloth()

        local mjSelect = newNormalObjSync("Prefabs/Scene/Mahjong/mj_select", typeof(GameObject))
        mjSelectObj = newobject(mjSelect)

        mjDirObj = child(tableObj.transform, "direction")

        this.threeDCenterRoot = child(tableObj.transform, "3DCenterPoint")
        this.twoDCenterRoot = child(tableObj.transform, "2DCenterPoint")

        local timeleft = child(mjDirObj, "time/left")
        local timeright = child(mjDirObj, "time/right")
        for i=0,9 do
            local numl = child(timeleft,tostring(i))
            table.insert(timeLeft_trans,numl)
            local numr = child(timeright,tostring(i))
            table.insert(timeRight_trans,numr)
        end
	end

    local mjWallPoints = {} --牌墙节点

    --[[--
     * @Description: 初始化墙节点  
     ]]
    function this:GetWallPoints()
        local mjWall = tableObj.transform:FindChild("MJWall")
        for i=1,4,1 do
            mjWallPoints[i] = mjWall:FindChild(i):FindChild("WallPoint")
        end
    end

    --[[--
     * @Description: 初始化麻将墙  
     ]]
    function this:InitWall()
        local x,y,z,index = 0,0,0,1
        for i=1,this.config.MahjongDunCount,1 do
            x= (i-1)*mahjongConst.MahjongOffset_x
            for j=1,2,1 do
                y = (j-1)*mahjongConst.MahjongOffset_y
                for k=1,4,1 do
                    local mj = this.compMjItemMgr.mjItemList[(k-1) * this.config.MahjongDunCount * 2 + index]
                    mj:Set3DLayer()
                    mj:HideAndReset()
                    mj.mjObj.transform:SetParent(mjWallPoints[k], false)
                    mj.mjObj.transform.localPosition = Vector3(x, y, 0)
                end
                index = index + 1
            end
        end
    end

    --[[--
     * @Description: 初始化骰子  
     ]]

    --[[function this:InitDice()
        if diceObj1 == nil then
            local diceObj1_prefab = newNormalObjSync("Prefabs/Scene/Mahjong/Dice1", typeof(GameObject))   
            diceObj1 = newobject(diceObj1_prefab)
        end
        if diceObj2 == nil then
            local diceObj2_prefab = newNormalObjSync("Prefabs/Scene/Mahjong/Dice2", typeof(GameObject))   
            diceObj2 = newobject(diceObj2_prefab)
        end
        diceObj1.transform.localPosition = Vector3(2.165,3.94,-8.56)
        diceObj1.transform.localScale = Vector3.one
        diceObj2.transform.localPosition = Vector3(3.44,3.94,-8.56)
        diceObj2.transform.localScale = Vector3.one
        diceObj1:SetActive(false)
        diceObj2:SetActive(false)
    end]]

    --[[--
     * @Description: 获取牌桌东南西北  
     ]]
    function this:GetMJDirObj()
        return mjDirObj
    end

    local InitWall_c -- 显示牌墙协程

    --[[--
     * @Description: 显示麻将墙  
     ]]
    function this:ShowWall(cb)
        InitWall_c = coroutine.start(function ()            
            local x,y,z,index = 0,0,0,1
            for i=1,this.config.MahjongDunCount,1 do
                x= (i-1)*mahjongConst.MahjongOffset_x
                for j=1,2,1 do
                    y = (j-1)*mahjongConst.MahjongOffset_y
                    for k=1,4,1 do
                        local mj = this.compMjItemMgr.mjItemList[(k-1) * this.config.MahjongDunCount * 2 + index]
                        mj.mjObj.transform:SetParent(mjWallPoints[k], true)
                        mj.mjObj.transform.localPosition = Vector3(x, y, 0)
                        mj:Show(false)
                    end
                    index = index + 1
                end
                coroutine.wait(0.05)
            end
            if cb~=nil then
                cb()
            end
        end)
    end

    --local InitDice_c -- 显示骰子协程

    --[[--
     * @Description: 显示骰子  
     ]]
    --[[function this:ShowDoce( value1,value2 ,cb)
        InitDice_c = coroutine.start(function ()
            local waypoints1 = {
                [1] = Vector3(2.140431,5.189945,-7.631653),
                [2] = Vector3(1.786758,6.359834,-6.399758),
                [3] = Vector3(1.060219,6.62951,-4.455368),
                [4] = Vector3(0.4832134,4.765876,-2.965402),
                [5] = Vector3(0.01906872,2.737945,-1.825694),
                [6] = Vector3(-0.5259883,0.938169,-0.4511081),
                [7] = Vector3(-0.6681621,1.333151,0.05976445),
                [8] = Vector3(-0.9877434,0.7205464,1.009628),
            }
            local array1 = Util.GetVector3ArrayByTable(waypoints1)
            local waypoints2 = {
                [1] = Vector3(3.036277,5.210092,-7.210227),
                [2] = Vector3(2.691669,6.32902,-6.067851),
                [3] = Vector3(1.867319,6.599809,-4.194177),
                [4] = Vector3(1.320772,4.714365,-2.907488),
                [5] = Vector3(1.239914,2.699825,-1.556226),
                [6] = Vector3(0.697602,0.8688488,-0.4408205),
                [7] = Vector3(0.4924293,1.277444,0.2510005),
                [8] = Vector3(0.1524448,0.7205464,1.14141),
            }
            local array2 = Util.GetVector3ArrayByTable(waypoints2)
            diceObj1:SetActive(true)
            diceObj2:SetActive(true)
            diceObj1.localEulerAngles = MahjongDiceVector[math.random(1,6)]
            diceObj2.localEulerAngles = MahjongDiceVector[math.random(1,6)]
            diceObj1.transform:DOLocalRotate(MahjongDiceVector[value1],0.2,DG.Tweening.RotateMode.Fast):SetLoops(5)
            diceObj2.transform:DOLocalRotate(MahjongDiceVector[value2],0.2,DG.Tweening.RotateMode.Fast):SetLoops(5)
            diceObj1.transform:DOLocalPath(array1,1,DG.Tweening.PathType.CatmullRom,DG.Tweening.PathMode.Full3D,10,Color.clear)
            diceObj2.transform:DOLocalPath(array2,1,DG.Tweening.PathType.CatmullRom,DG.Tweening.PathMode.Full3D,10,Color.clear)
            coroutine.wait(2)
            cb()
            coroutine.wait(3)
            diceObj1:SetActive(false)
            diceObj2:SetActive(false)
        end)
    end]]

    -- local this.sendIndex --发牌索引
    -- local this.lastIndex --尾牌索引

    --this.SendAllHandCard_c -- 发牌协程

    --[[--
     * @Description: 发手牌  
     * @param:       dun        牌墩，从视图玩家1左边开始数，墩数从1开始 
     * @param:       viewSeat   取哪个视图玩家前面的牌墙
     * @param        cards      玩家手牌数据
     * @return:      nil
     ]]
    function this:SendAllHandCard(dun,viewSeat,cards,cb)
        this.SendAllHandCard_c = coroutine.start(function ()            
            this.sendIndex = dun * 2 + (viewSeat-1) * 34 --发牌位置
            this.lastIndex = this.sendIndex + 2
            local cardsIndex = 1
            local zhunagOffset =  roomdata_center.zhuang_viewSeat - 1
            local waitTime = 0.1

            --4圈牌
            for i = 1,4,1 do
                --人数
                for j = 1,roomdata_center.MaxPlayer(),1 do
                    local num = 4
                    if (i == 4) then
                        if (1 == j) then
                            num = 2
                        else
                            num = 1
                        end
                    end
                    --牌数
                    for k = 1,num,1 do
                        if (this.sendIndex <= 0) then
                            this.sendIndex = 136
                        end

                        local mj = this:GetMJItem(this.sendIndex)                       
                        if i==4 and j==1 and k==1 then                            
                            this.sendIndex = this.sendIndex - 4                   
                        elseif i==4 and j==1 and k==2 then
                            if zhunagOffset == 0 then
                                waitTime = 0.5
                            end
                            this.sendIndex = this.sendIndex + 3
                        elseif i==4 and j==4 then
                            this.sendIndex = this.sendIndex - 2
                        else
                            waitTime = 0.2
                            this.sendIndex = this.sendIndex - 1 
                        end                     

                        local playerVSeat = j + zhunagOffset
                        if playerVSeat > roomdata_center.MaxPlayer() then
                            playerVSeat = playerVSeat - roomdata_center.MaxPlayer()
                        end

                        local paiValue = MahjongTools.GetRandomCard()
                        if playerVSeat == 1 then
                            paiValue = cards[cardsIndex]
                            cardsIndex = cardsIndex + 1
                        end

                        if mj ~= nil then
                            mj:SetMesh(paiValue)
                            this.compPlayerMgr:GetPlayer(playerVSeat):AddDun(mj)
                        end
                    end
                    ui_sound_mgr.PlaySoundClip("common/audio_deal_card")

                    coroutine.wait(waitTime)
                end
            end

            for i=1,roomdata_center.MaxPlayer() do
                if i == 1 then
                    this.compPlayerMgr:GetPlayer(i):ArrangeHandCard(cb)
                else
                    this.compPlayerMgr:GetPlayer(i):ArrangeHandCard()
                end
            end

        end)
    end

    --[[--
     * @Description: 显示癞子  
     ]]
    local InitShowLai_c = nil
    function this:ShowLai(dun, cardValue, isAnim,callback)
        log("ShowLai !!!!!!!!!!!!! dun "..dun.." cardValue "..cardValue)
        local laiIndex = this.lastIndex+(dun-1)*2
        if(laiIndex>this.config.MahjongTotalCount) then
            laiIndex = laiIndex - this.config.MahjongTotalCount
        end

        local tempIndex = this.lastIndex
        local tempMJ = nil

        InitShowLai_c = coroutine.start(function ()  
            if not IsNil(mjSelectObj) and isAnim then                 
                for i=1, dun do                                               
                    tempMJ = this.compMjItemMgr.mjItemList[tempIndex]  
                    if tempMJ ~= nil then
                        mjSelectObj.transform.position = tempMJ.mjObj.transform.position
                        if i==1 then
                            mjSelectObj.transform.rotation = tempMJ.mjObj.transform.rotation
                        end
                        coroutine.wait(0.2) 
                    end
                    tempIndex = tempIndex + 2
                    if tempIndex > this.config.MahjongTotalCount then
                        tempIndex = tempIndex - this.config.MahjongTotalCount
                    end
                end

                if not IsNil(mjSelectObj) then
                    mjSelectObj.transform.position = Vector3.zero
                end

            end

            local mj = this.compMjItemMgr.mjItemList[laiIndex]
            mj:SetMesh(cardValue)
            mj:Show(true,isAnim)

            if callback~=nil then
                callback()
            end

        end)
        
    end

    --[[--
     * @Description: 摸牌  
     ]]
    function this:SendCard( viewSeat,paiValue,isHead )
        local isSendHead = isHead or true
        local mj
        if isSendHead then 
            if (this.sendIndex == 0) then
                this.sendIndex = this.config.MahjongTotalCount
            end
            --TODO 需要处理取到已经被摸走的牌
            mj = this:GetMJItem(this.sendIndex)
            this.sendIndex = this.sendIndex -1
        else
            if this.lastIndex == 137 then 
                this.lastIndex = 1
            end
            mj = this:GetMJItem(this.lastIndex)
            this.lastIndex = this.lastIndex +1
        end
        mj:SetMesh(paiValue)
        this.compPlayerMgr:GetPlayer(viewSeat):AddHandCard(mj,false)
    end

    --[[--
     * @Description: 得到一个牌子  
     ]]
    function this:GetMJItem(index)
        local mj = this.compMjItemMgr.mjItemList[index]
        roomdata_center.leftCard = roomdata_center.leftCard -1
        mahjong_ui.SetLeftCard( roomdata_center.leftCard )
        return mj
    end

    --[[--
     * @Description: 恢复完整牌墙  
     ]]
    function this:ReShowWall()
        local x,y,z,index = 0,0,0,1
        for i=1,this.config.MahjongDunCount,1 do
            x= (i-1)*mahjongConst.MahjongOffset_x
            for j=1,2,1 do
                y = (j-1)*mahjongConst.MahjongOffset_y
                for k=1,4,1 do
                    local mj = this.compMjItemMgr.mjItemList[(k-1) * this.config.MahjongDunCount * 2 + index]
                    mj.mjObj.transform:SetParent(mjWallPoints[k], false)
                    mj.mjObj.transform.localPosition = Vector3(x, y, 0)
                    mj:Show(false)
                end
                index = index + 1
            end
        end
    end

    --[[--
     * @Description: 恢复牌墙  
     ]]
    function this:ResetWall(dun,viewSeat)
        local x,y,z,index = 0,0,0,1
        for i=1,this.config.MahjongDunCount,1 do
            for j=1,2,1 do
                for k=1,4,1 do
                    local mj = this.compMjItemMgr.mjItemList[(k-1) * this.config.MahjongDunCount * 2 + index]
                    mj:Show(false)
                end
                index = index + 1
            end
        end

        this.sendIndex = dun * 2 + (viewSeat-1) * this.config.MahjongDunCount * 2 --发牌位置
        this.lastIndex = this.sendIndex + 2

        log("-----------------ResetWall------------this.sendIndex "..tostring(this.sendIndex).." this.lastIndex "..tostring(this.lastIndex))
    end



    --[[--
     * @Description: 得到一组牌子，重连用  
     ]]
    function this:GetResetCards( count )
        local list = {}
        for i=1,count do
            if (this.sendIndex <= 0) then
                this.sendIndex = this.config.MahjongTotalCount
            end
            local mj = this:GetMJItem(this.sendIndex)
            table.insert(list,mj)
            this.sendIndex = this.sendIndex -1
        end
        return list
    end

    local time_timer = nil --倒计时 计时器
    local time_isAlarm = false
    local time_alarmTime = 0
    local time_count = 0 --倒计时 次数
    local time_callback = nil -- 回调
    --local time_callback_leftTime = nil -- 在剩余多少时间时回调

    --[[--
     * @Description: 设置定时器  
     ]]
    function this:SetTime(time,isAlarm,alarmTime,fun,funLeftTime)
        if time_timer~=nil then
            time_timer:Stop()
            time_timer = nil
        end
        time_count = math.floor(time)

        time_isAlarm = isAlarm or false
        time_alarmTime = alarmTime or 0

        if fun~=nil then
            time_count = time_count - funLeftTime
            time_callback = fun
            --time_callback_leftTime = funLeftTime
        end

        time_timer = Timer.New(this.UpdateTime, 1, time_count+1)
        time_timer:Start()  
    end

    --[[--
     * @Description: 更新时间  
     ]]
    function this.UpdateTime()
        if time_count <= 0 and time_callback~=nil then
            time_callback()
            this:StopTime(false)
        end

        if time_count >= 0 then
            if tiem_isAlarm and time_count < time_alarmTime then
                ui_sound_mgr.PlaySoundClip("common/timeup_alarm")
            end

            local leftNum = math.floor(time_count/10)
            local rightNum = time_count-leftNum*10
            for i,v in ipairs(timeLeft_trans) do
                v.gameObject:SetActive(false)
            end
            for i,v in ipairs(timeRight_trans) do
                v.gameObject:SetActive(false)
            end
            timeLeft_trans[leftNum+1].gameObject:SetActive(true)
            timeRight_trans[rightNum+1].gameObject:SetActive(true)
            time_count = time_count - 1
        end
    end

    --[[--
     * @Description: 停止定时器  
     ]]
    function this:StopTime(isHide)
        isHide = isHide or true
        if isHide then
            for i,v in ipairs(timeLeft_trans) do
                v.gameObject:SetActive(false)
            end
            for i,v in ipairs(timeRight_trans) do
                v.gameObject:SetActive(false)
            end
        end
        --timeLeft_trans[1].gameObject:SetActive(true)
        --timeRight_trans[1].gameObject:SetActive(true)
        if time_timer~=nil then
            time_timer:Stop()
            time_timer = nil
        end
        time_count = 0
        time_isAlarm = false
        time_alarmTime = 0
        time_callback = nil
        --time_callback_leftTime = nil
    end

    --[[--
     * @Description: 更换桌布  
     ]]
    function this:ChangeDeskCloth()
        local clothNum = hall_data.GetPlayerPrefs("desk")
        if clothNum~= "1" and clothNum~= "2" and clothNum~= "3" then
            return
        end
        local matName = "zhuozi_0"..clothNum
        local mat = newNormalObjSync("Materials/"..matName, typeof(UnityEngine.Material))
        local meshRenderer = tableModelObj:GetComponent(typeof(UnityEngine.MeshRenderer))
        meshRenderer.sharedMaterial = mat
    end

    function this:StopAllCoroutine()
        coroutine.stop(InitWall_c)
        coroutine.stop(InitDice_c)
        coroutine.stop(this.SendAllHandCard_c)
        coroutine.stop(InitShowLai_c)
        InitWall_c = nil
        InitDice_c = nil
        InitShowLai_c = nil
        this.SendAllHandCard_c = nil
    end
	
	function this:Uninitialize()
		this.base_unInit()
        this:StopAllCoroutine()
        this.compMjItemMgr = nil 
        this.compPlayerMgr = nil
        this:StopTime()
	end

	--log("----------------------init comp_table")
	--InitTable()
    --GetWallPoints()	

	return this
end
