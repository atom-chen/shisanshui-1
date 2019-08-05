--[[--
 * @Description: 组件表现基类
 * @Author:      shine
 * @FileName:    comp_show_base.lua
 * @DateTime:    2017-07-07 20:50:48
 ]]

require "logic/mahjong_sys/comp_show/mahjong_anim_state_control"

comp_show_base = 
{
    isInit = false,
    compTable = nil,
    outCardEfObj = nil,
    compResMgr = nil,
    compMJItemMgr = nil,
    compPlayerMgr = nil,

    lightDirTbl = {},  --下标为本地视图下标
    gvbl = nil,        --逻辑座位(带P)
    gvblnFun = nil,    --逻辑座位(不带P)
    gmls = nil         --本地座位  
}

game_state = {
    none         = "none",
    prepare      = "prepare",        --开始
    banker       = "banker",          --定庄
    deal         = "deal",               --抓牌
    changeflower = "changeflower",      --补花
    opengold     = "opengold",         --开金
    round        = "round",        --游戏阶段
    reward       = "reward",       --结算
    gameend      = "gameend",       --结束
}

comp_show_base.__index = comp_show_base

function comp_show_base.New()
    local self = {}
    setmetatable(self, comp_show_base)
    return self
end


function comp_show_base:RegisterEvents()
    Notifier.regist(cmdName.MSG_CHANGE_DESK,slot(self.OnChangeDesk, self)) --更换桌布
    Notifier.regist(cmdName.F1_ENTER_GAME, slot(self.OnPlayerEnter, self))  --玩家进入
    Notifier.regist(cmdName.F1_GAME_READY, slot(self.OnPlayerReady, self))  --玩家准备    
    Notifier.regist(cmdName.F1_GAME_START, slot(self.OnGameStart, self))    --游戏开始
    Notifier.regist(cmdName.F1_GAME_BANKER,slot(self.OnGameBanker, self))   --定庄
    --Notifier.regist(cmdName.F1_GAME_GOXIAPAO,slot(self.OnGoXiaPao, self))       --通知下跑
    --Notifier.regist(cmdName.F1_GAME_ALLXIAPAO,slot(self.OnALLPlayerXiaPao, self))            --所有玩家下跑
    Notifier.regist(cmdName.F1_GAME_DEAL, slot(self.OnGameDeal, self))      --发牌
    Notifier.regist(cmdName.F1_GAME_LAIZI, slot(self.OnGameLaiZi, self))    --定赖
    Notifier.regist(cmdName.F1_GAME_ASKPLAY, slot(self.OnAskPlay, self))    --通知出牌
    Notifier.regist(cmdName.F1_GAME_PLAY, slot(self.OnPlayCard, self))      --出牌
    Notifier.regist(cmdName.F1_GAME_ASKBLOCK,slot(self.OnGameAskBlock, self))                --提示吃碰杠胡操作
    Notifier.regist(cmdName.F1_GAME_GIVECARD, slot(self.OnGiveCard, self))  --摸牌
    Notifier.regist(cmdName.F1_GAME_TRIPLET, slot(self.OnTriplet, self))    --碰牌
    Notifier.regist(cmdName.F1_GAME_QUADRUPLET, slot(self.OnQuadruplet, self))  --杠牌
    Notifier.regist(cmdName.F1_GAME_REWARDS, slot(self.OnGameRewards, self))    --结算
    Notifier.regist(cmdName.F1_SYNC_TABLE, slot(self.OnSyncTable, self))    --重连同步表
    Notifier.regist(cmdName.F3_CHANGE_FLOWER, slot(self.OnChangeFlower, self)) -- 补花
    Notifier.regist(cmdName.F3_OPEN_GOLD, slot(self.OnGameOpenGlod, self))  -- 开金
    Notifier.regist(cmdName.F1_GAME_COLLECT, slot(self.OnGameCollect, self)) -- 吃

    Notifier.regist(cmdName.F1_GAME_TING, slot(self.OnTing, self))--听牌

    Notifier.regist(cmdName.F3_ROB_GOLD, slot(self.OnRobGold, self)) -- 抢金
end

function comp_show_base:UnRegisterEvents()
    Notifier.remove(cmdName.MSG_CHANGE_DESK,slot(self.OnChangeDesk, self)) --更换桌布
    Notifier.remove(cmdName.F1_ENTER_GAME, slot(self.OnPlayerEnter, self))  --玩家进入
    Notifier.remove(cmdName.F1_GAME_READY, slot(self.OnPlayerReady, self))  --玩家准备 
    Notifier.remove(cmdName.F1_GAME_START, slot(self.OnGameStart, self))    --游戏开始
    Notifier.remove(cmdName.F1_GAME_BANKER,slot(self.OnGameBanker, self))   --定庄
    --Notifier.remove(cmdName.F1_GAME_GOXIAPAO,slot(self.OnGoXiaPao, self))--通知下跑
    --Notifier.remove(cmdName.F1_GAME_ALLXIAPAO,slot(self.OnALLPlayerXiaPao, self))--所有玩家下跑
    Notifier.remove(cmdName.F1_GAME_DEAL, slot(self.OnGameDeal, self))      --发牌
    Notifier.remove(cmdName.F1_GAME_LAIZI, slot(self.OnGameLaiZi, self))    --定赖
    Notifier.remove(cmdName.F1_GAME_ASKPLAY, slot(self.OnAskPlay, self))    --通知出牌
    Notifier.remove(cmdName.F1_GAME_PLAY, slot(self.OnPlayCard, self))      --出牌
    Notifier.remove(cmdName.F1_GAME_GIVECARD, slot(self.OnGiveCard, self))  --摸牌
    Notifier.remove(cmdName.F1_GAME_ASKBLOCK,slot(self.OnGameAskBlock, self))--提示吃碰杠胡操作
    Notifier.remove(cmdName.F1_GAME_TRIPLET, slot(self.OnTriplet, self))    --碰牌
    Notifier.remove(cmdName.F1_GAME_QUADRUPLET, slot(self.OnQuadruplet, self))  --杠牌
    Notifier.remove(cmdName.F1_GAME_REWARDS, slot(self.OnGameRewards, self))    --结算
    Notifier.remove(cmdName.F1_SYNC_TABLE, slot(self.OnSyncTable, self))    --重连同步表 
    Notifier.remove(cmdName.F3_CHANGE_FLOWER, slot(self.OnChangeFlower, self)) -- 补花 
    Notifier.remove(cmdName.F3_OPEN_GOLD, slot(self.OnGameOpenGlod, self))  -- 开金
    Notifier.remove(cmdName.F1_GAME_COLLECT, slot(self.OnGameCollect, self)) -- 吃
    Notifier.remove(cmdName.F3_ROB_GOLD, slot(self.OnRobGold, self)) -- 抢金

    Notifier.remove(cmdName.F1_GAME_TING, slot(self.OnTing, self))--听牌
end

function comp_show_base:Init()


    self.compTable = mode_manager.GetCurrentMode():GetComponent("comp_table")
    self.compResMgr = mode_manager.GetCurrentMode():GetComponent("comp_resMgr")
    self.compMJItemMgr = mode_manager.GetCurrentMode():GetComponent("comp_mjItemMgr")
    self.compPlayerMgr = mode_manager.GetCurrentMode():GetComponent("comp_playerMgr")
    self.compDice = mode_manager.GetCurrentMode():GetComponent("comp_dice")

    self.outCardEfObj = self.compResMgr:GetOutCardEfObj()
    self.gvbl = room_usersdata_center.GetViewSeatByLogicSeat
    self.gvblnFun = room_usersdata_center.GetViewSeatByLogicSeatNum
    self.gmls = room_usersdata_center.GetMyLogicSeat  

    self.config = self.compTable.mode.config
    self.curState = game_state.none

    self:RegisterEvents()
end

function comp_show_base:Uinit()
    self:UnRegisterEvents()
    mahjong_anim_state_control.Reset()
    self.isInit = false
    self.compTable = nil
    self.compResMgr = nil
    self.compMJItemMgr = nil
    self.compPlayerMgr = nil

    self.outCardEfObj = nil
    self.gvbl = nil 
    self.gmls = nil
    self.gvblnFun = nil
    self.lightDirTbl = {}

    self.curState = game_state.none

    roomdata_center.nCurrJu = 0
end

--[[--
 * @Description: 更换桌布  
 ]]
function comp_show_base:OnChangeDesk(tbl)
    self.compTable:ChangeDeskCloth()
end

--[[--
 * @Description: 玩家进入房间  
 ]]
function comp_show_base:OnPlayerEnter(tbl)
    local logicSeat = tbl["_src"]
    local viewSeat = self.gvbl(logicSeat)
    if viewSeat == 1 then
        self.curState = game_state.prepare
        local logicSeat_number = room_usersdata_center.GetLogicSeatByStr(logicSeat)
        if roomdata_center.MaxPlayer() == 2 and logicSeat_number == 2 then 
            logicSeat_number = 3
        end
        local mjDirObj = self.compTable:GetMJDirObj()
        if mjDirObj ~= nil then
            local dirTran = child(mjDirObj.transform, "dark_dir/direction_0"..tostring(logicSeat_number))
            local dirLightTran = child(mjDirObj.transform, "light_dir/direction_"..tostring(logicSeat_number))
            if dirTran ~= nil then
                dirTran.gameObject:SetActive(true)
            end
            if dirLightTran ~= nil then
                dirLightTran.gameObject:SetActive(true)
                for i=1,4 do
                    local t = child(dirLightTran, "direction_0"..tostring(i))
                    if roomdata_center.MaxPlayer() == 2 and (i == 2 or i == 4 ) then
              
                    else
                      table.insert(self.lightDirTbl,t)
                    end
                    
                end
            end
        end
    end     
end

--[[--
 * @Description: 初始化准备  
 ]]
function comp_show_base:InitForReady()
    if self.compTable.Clear then
        self.compTable:Clear()
    end
    self.compTable:StopAllCoroutine()
    -- 停止所有动画
    self.compMJItemMgr:InitMJItems()
    self.compTable:InitWall()
    self.compDice.Init()
    self:SetOutCardEfObj(nil, true)        
    self.compPlayerMgr:ResetPlayer()
    print("#self.lightDirTbl------------------"..#self.lightDirTbl)
    for i,v in ipairs(self.lightDirTbl) do
        --print("#self.lightDirTbl------------------")
        v.gameObject:SetActive(false)
    end
end

--[[--
 * @Description: 玩家准备游戏  
 ]]
function comp_show_base:OnPlayerReady(tbl)
    local logicSeat = tbl["_src"]
    local viewSeat = self.gvbl(logicSeat)

    if viewSeat == 1 then
        self:InitForReady()
        self.isInit = true
    end
end

--[[--
 * @Description: 游戏开始  
 ]]
function comp_show_base:OnGameStart(tbl)
    mahjong_anim_state_control.Reset()
    mahjong_anim_state_control.ShowAnimState(MahjongGameAnimState.start)
    if isInit == false then
        self:InitForReady()
        self.isInit = true
    end
    self.compTable:ShowWall()
end

function comp_show_base:OnGameBanker( tbl )
    self.curState = game_state.banker
end

--[[--
 * @Description: 开始发牌  
 ]]
function comp_show_base:OnGameDeal(tbl)
    self.curState = game_state.deal
    self.compTable:ShowWall(function ()
        local dice_big = tbl["_para"]["dice"][1]
        local dice_small = tbl["_para"]["dice"][2]

        if dice_big < dice_small then
            local temp = dice_big
            dice_big = dice_small
            dice_small = temp
        end

        print("Dice========="..dice_big.." "..dice_small)

        self.compDice.Play(tbl["_para"]["dice"][1], tbl["_para"]["dice"][2], function ()
            print("GetBankerViewSeat()----------------------"..roomdata_center.GetBankerViewSeat())
            local viewSeat = roomdata_center.GetBankerViewSeat() + dice_big + dice_small -1
            viewSeat = viewSeat % 4
            if viewSeat == 0 then
                viewSeat = 4
            end

            local cards = tbl["_para"]["cards"]
            self.compTable:SendAllHandCard(
                mode_manager.GetCurrentMode().config.MahjongDunCount-dice_small - dice_big,
                viewSeat, cards, 
                function ()
                   self.compPlayerMgr:AllSortHandCard()
                    Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_GAME_DEAL)
            end)
        end)
        ui_sound_mgr.PlaySoundClip("common/audio_shaizi")
    end)
end

--[[--
 * @Description: 定癞  
 ]]
function comp_show_base:OnGameLaiZi(tbl)
    print(GetTblData(tbl))
    roomdata_center.hun = tbl["_para"]["laizi"][1]

    local cardValue = tbl._para.cards[1]
    local dun = tbl._para.sits[1]/2
    print("OnGameLaiZi !!!!!!!!!!!!! dun "..dun.." cardValue "..cardValue)
    self.compTable:ShowLai(dun, cardValue, true, function()
        self.compPlayerMgr:GetPlayer(1):ShowLaiInHand()
        self.compPlayerMgr:AllSortHandCard()
    end )

    Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_GAME_LAIZI)
end

--[[--
 * @Description: 请求出牌  
 ]]
function comp_show_base:OnAskPlay(tbl)
    local viewSeat = self.gvbl(tbl._src)

    local time = roomdata_center.timersetting.giveTimeOut - tbl.time
    if viewSeat == 1 then
        self.compTable:SetTime(time,true,3)
    else
        self.compTable:SetTime(time)
    end

    self.curState = game_state.round
    
    if viewSeat == 1 then
       
        self.compPlayerMgr:GetPlayer(viewSeat):SetCanOut(true)            
    end

    --展示东南西北
    for i,v in ipairs(self.lightDirTbl) do
        v.gameObject:SetActive(false)
    end
    self.lightDirTbl[viewSeat].gameObject:SetActive(true)

    Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_GAME_ASKPLAY)
end

--[[--
 * @Description: 出牌  
 ]]
function comp_show_base:OnPlayCard(tbl)
    print(GetTblData(tbl))
    local src = tbl["_src"]
    local viewSeat = room_usersdata_center.GetViewSeatByLogicSeat(src)

    if viewSeat == 1 then
        mahjong_ui.cardShowView:Hide()
       self.compPlayerMgr:GetPlayer(viewSeat):HideTingInHand()
       self.compPlayerMgr:GetPlayer(viewSeat):SetCanOut(false)
       self.compPlayerMgr:HideHighLight()
    end

    local value = tbl["_para"]["cards"][1]
    --print("!!!!!!!!!!!!!!!viewSeat"..tostring(viewSeat))
    self.compPlayerMgr:GetPlayer(viewSeat):OutCard(value, function (pos)
       self.compResMgr:SetOutCardEfObj(pos)
    end)

    ui_sound_mgr.PlaySoundClip("common/audio_card_out")
    ui_sound_mgr.PlaySoundClip("man/"..value)

    Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_GAME_PLAY)
end

--[[--
 * @Description: 弃牌处理
 ]]
function comp_show_base:OnGiveCard(tbl)
    print(GetTblData(tbl))
    local src = tbl["_src"]
    local viewSeat = room_usersdata_center.GetViewSeatByLogicSeat(src)

    local value = MahjongTools.GetRandomCard()
    if viewSeat == 1 then
        value = tbl["_para"]["cards"][1]
    end

    self.compTable:SendCard(viewSeat, value)
    Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_GAME_GIVECARD)
end

function comp_show_base:OnGameAskBlock( tbl )
    local time = roomdata_center.timersetting.blockTimeOut - tbl.time
    self.compTable:SetTime(time,true,3)

    self.curState = game_state.round
end

--[[--
 * @Description: 碰牌处理  
 ]]
function comp_show_base:OnTriplet( tbl )
    print(GetTblData(tbl))
    local operPlayViewSeat = self.gvbl(tbl._src)
    local lastPlayViewSeat = self.gvblnFun(tbl._para.tripletWho)
    local offset = lastPlayViewSeat - operPlayViewSeat 
    local mj = self.compPlayerMgr:GetPlayer(lastPlayViewSeat):GetLastOutCard()

    if offset<1 then
        offset = offset +roomdata_center.MaxPlayer()
    end

    local operType = nil
    -- 3：左 2：中 1：右
    if(offset == 3) then
        operType = MahjongOperAllEnum.TripletLeft
    end
    if(offset == 2) then
        operType = MahjongOperAllEnum.TripletCenter
    end
    if(offset == 1) then
        operType = MahjongOperAllEnum.TripletRight
    end
    local operData = operatordata:New(operType, tbl._para.cardTriplet.triplet, tbl._para.cardTriplet.useCards)

    self:SetOutCardEfObj(nil, true)
    self.compPlayerMgr:GetPlayer(operPlayViewSeat):OperateCard(operData, mj)

    ui_sound_mgr.PlaySoundClip("man/peng")
    Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_GAME_TRIPLET)
end

function comp_show_base:OnTing(tbl)
    roomdata_center.SetHintInfoMap(tbl)
    self.compPlayerMgr:GetPlayer(1):ShowTingInHand()
    Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_GAME_TING)
end

--[[--
 * @Description: 杠牌处理  
 ]]
function comp_show_base:OnQuadruplet( tbl )
    print(GetTblData(tbl))
    local operPlayViewSeat = self.gvbl(tbl._src)
    local lastPlayViewSeat = self.gvblnFun(tbl._para.quadrupletWho)
    local offset = lastPlayViewSeat - operPlayViewSeat 
    local mj  = nil

    if offset<1 then
        offset = offset +roomdata_center.MaxPlayer()
    end

    local quadrupletType = tbl._para.quadrupletType

    local operType
    local operData
    -- 3：左 2：中 1：右
    if quadrupletType == 1 then     --明杠
        mj =self.compPlayerMgr:GetPlayer(lastPlayViewSeat):GetLastOutCard()
        if(offset == 3) then
            operType = MahjongOperAllEnum.BrightBarLeft
        end
        if(offset == 2) then
            operType = MahjongOperAllEnum.BrightBarCenter
        end
        if(offset == 1) then
            operType = MahjongOperAllEnum.BrightBarRight
        end
        operData = operatordata:New(operType,tbl._para.cardQuadruplet.quadruplet, tbl._para.cardQuadruplet.useCards)
        self.compResMgr:HideOutCardEfObj()
    end

    if quadrupletType == 2 then
        operType = MahjongOperAllEnum.AddBar
        operData = operatordata:New(operType,tbl._para.cardQuadruplet.useCards[1], nil)
    end

    if quadrupletType == 3 then
        operType = MahjongOperAllEnum.DarkBar
        table.remove(tbl._para.cardQuadruplet.useCards)
        operData = operatordata:New(operType,tbl._para.cardQuadruplet.useCards[1], tbl._para.cardQuadruplet.useCards)
    end

    ui_sound_mgr.PlaySoundClip("man/gang")
    self.compPlayerMgr:GetPlayer(operPlayViewSeat):OperateCard(operData, mj)                
    Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_GAME_QUADRUPLET)
end

function comp_show_base:OnGameCollect(tbl)
    print(GetTblData(tbl))

    local operPlayViewSeat = self.gvbl(tbl._src)
    local lastPlayViewSeat = operPlayViewSeat-1
    if lastPlayViewSeat<1 then
        lastPlayViewSeat = roomdata_center.MaxPlayer()
    end
    --print("lastPlayViewSeat"..lastPlayViewSeat.."self.gvbl(tbl._para.collectWho)"..self.gvblnFun(tbl._para.collectWho)) 
    local mj = self.compPlayerMgr:GetPlayer(lastPlayViewSeat):GetLastOutCard()

    local operType = MahjongOperAllEnum.Collect
    
    local operData = operatordata:New(operType, tbl._para.cardCollect.collect, tbl._para.cardCollect.useCards)

    self:SetOutCardEfObj(nil, true)
    self.compPlayerMgr:GetPlayer(operPlayViewSeat):OperateCard(operData, mj)

    ui_sound_mgr.PlaySoundClip("man/chi")
    Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F1_GAME_COLLECT)
end

--[[--
 * @Description: 结算处理  
 ]]
function comp_show_base:OnGameRewards()
    self.compTable:StopTime()
    isInit = false
    self.compPlayerMgr:GetPlayer(1):SetCanOut(false)
    --ui_sound_mgr.PlaySoundClip("man/hu")
end


function comp_show_base:OnRobGold()
    mahjong_anim_state_control.ShowAnimState(MahjongGameAnimState.grabGold)
    Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F3_ROB_GOLD)
end

function comp_show_base:OnSyncTable(tbl)
    local ePara = tbl._para
    local game_state = ePara.game_state         -- 游戏阶段
    local dealer = ePara.dealer                 -- 庄家
    local dice = ePara.dice                     -- 骰子
    local laizi = ePara.laizi                   -- 癞子
    local player_state = ePara.player_state     -- 玩家状态
    local tileCount = ePara.tileCount           -- 各玩家手牌数
    local tileLeft = ePara.tileLeft             -- 剩余牌子
    local tileList = ePara.tileList             -- 玩家手牌值
    local combineTile = ePara.combineTile       -- 各玩家吃碰杠
    local xiapao = ePara.xiapao                 -- 下跑
    local winTile = ePara.winTile               -- 各家所赢
    local discardTile = ePara.discardTile       -- 各玩家出的牌
    local whoisOnTurn = ePara.whoisOnTurn       -- 谁的回合
    local flowerTile = ePara.flowerTile         -- 花
    local subRound = ePara.subRound             -- 当前局
    local goldCard = {
        nOpenGoldCard = ePara.nOpenGoldCard,     -- 开的金牌
        nGoldCardPos = ePara.nGoldCardPos,       -- 金牌在剩余牌堆tileLeft的位置
    }

    local state = MahjongSyncGameState[game_state]
    if state == nil then
        logError("找不到state", game_state);
        state = 0
    end

    -- if state >= 200 then   --准备
    --     self:InitForReady()
    -- end

    -- if state >= 300 then        -- xiapao
    --     self.compTable:ReShowWall()
    -- end

    -- if state >= 400 then    -- 发牌
    --     self.curState = game_state.deal
    --     mahjong_anim_state_control.SetState(2)
    -- end


    -- if state >= 500 then
    --     self:OnResetWall(dice)
    --     -- self:OnResetHandCard(tileCount, tileList)
    --     if state >= 510 then --补花
    --         mahjong_anim_state_control.SetState(3)
    --     end
    --     if state >= 520 then  -- 开金
    --          --恢复花
    --         if flowerTile~=nil then
    --             self:OnResetFlowerCards( flowerTile )
    --         end
    --     end
    --     if state < 600 then
    --         --恢复玩家牌
    --         self:OnResetCard( discardTile ,combineTile,tileCount,tileList)
    --     end
        
    -- end

    -- if state >= 600 then  -- 打牌阶段
    --      self.curState = game_state.round
    --     --恢复癞子
    --     if laizi~=nil then
    --         self:OnResetLai(laizi)
    --     end
    --       --恢复金
    --     if goldCard~=nil then
    --         self:OnResetGoldCard( goldCard.nOpenGoldCard )
    --     end

    --     --恢复玩家牌
    --     self:OnResetCard( discardTile ,combineTile,tileCount,tileList)
        
    --     -- 手牌依赖operate card
    --     -- self:OnResetOperateCard(combineTile)
    --     -- self:OnResetDiscardCard(discardTile)

    --       --是否玩家出牌
    --     if whoisOnTurn == self.gmls() then
    --        self.compPlayerMgr:GetPlayer(1):SetCanOut(true)
    --     end  

    --     --展示东南西北
    --     for i,v in ipairs(self.lightDirTbl) do
    --         v.gameObject:SetActive(false)
    --     end
    --     self.lightDirTbl[self.gvblnFun(whoisOnTurn)].gameObject:SetActive(true)   
    -- end


    --local nleftTime = ePara.nleftTime             -- 
    --local cardLastDraw = ePara.cardLastDraw       -- 
    if game_state == "prepare" then         --准备阶段
        self:InitForReady()
    elseif game_state == "xiapao" then      --下跑阶段
        self:InitForReady()
        self.compTable:ReShowWall()
    elseif game_state == "deal" then        --发牌阶段
        self:InitForReady()
        self.curState = game_state.deal
        self.compTable:ReShowWall()
        mahjong_anim_state_control.SetState(2)
    elseif game_state == "laizi" then       --癞子阶段
        self:InitForReady()
        --恢复牌墙
        self:OnResetWall(dice)
        --恢复玩家牌
        self:OnResetCard( discardTile ,combineTile,tileCount,tileList)

    elseif game_state == "changeflower" then
          self:InitForReady()
        --恢复牌墙
        self:OnResetWall(dice)
        --恢复玩家牌
        self:OnResetCard( discardTile ,combineTile,tileCount,tileList)
        mahjong_anim_state_control.SetState(3)
    elseif game_state == "opengold" then
         mahjong_anim_state_control.SetState(3)
        self:InitForReady()
        --恢复牌墙
        self:OnResetWall(dice)
      
        --恢复花
        if flowerTile~=nil then
            self:OnResetFlowerCards( flowerTile )
        end

        if goldCard~=nil then
            self:OnResetGoldCard(goldCard.nOpenGoldCard)
        end

        --恢复玩家牌
        self:OnResetCard( discardTile ,combineTile,tileCount,tileList)

    elseif game_state == "round" then       --出牌阶段
         mahjong_anim_state_control.SetState(3)
        self:InitForReady()
        self.curState = game_state.round
        --恢复牌墙
        self:OnResetWall(dice)
        --恢复癞子
        if laizi~=nil then
            self:OnResetLai(laizi)
        end
       
        --恢复花
        if flowerTile~=nil then
            self:OnResetFlowerCards( flowerTile )
        end
        --恢复金
        if goldCard~=nil then
            self:OnResetGoldCard( goldCard.nOpenGoldCard )
        end

        --恢复玩家牌
        self:OnResetCard( discardTile ,combineTile,tileCount,tileList)

        --是否玩家出牌
        if whoisOnTurn == self.gmls() then
           self.compPlayerMgr:GetPlayer(1):SetCanOut(true)
        end  

        --展示东南西北
        for i,v in ipairs(self.lightDirTbl) do
            v.gameObject:SetActive(false)
        end
        self.lightDirTbl[self.gvblnFun(whoisOnTurn)].gameObject:SetActive(true)   

    elseif game_state == "reward" then      --结算阶段
        --todo
    elseif game_state == "gameend" then     --结束阶段
        --todo
    end        

    if subRound ~= 0 and tileLeft ~= 0 then
        self:OnResetGameInfo(subRound, tileLeft)
    end

end

-- 补花
function comp_show_base:OnChangeFlower(tbl)
    local paramTbl = tbl._para
    local playerIndex = paramTbl["nFlowerWho"]      --谁补花
    local flowerCards = paramTbl["stFlowerCards"]       --花牌
    local newCards = paramTbl["stNewCards"]     --替换的花牌
    local totalCards = paramTbl["nTotalFlowerCard"]     --花牌总数量
    local leftCardNum = paramTbl["nCardLeft"]   --剩余牌数

    local viewSeat = self.gvblnFun(playerIndex)

    local isDeal = false
    if self.curState == game_state.deal then
        isDeal = true
    end

    if not isDeal then
        ui_sound_mgr.PlaySoundClip("man/buhua")
    end

    mahjong_anim_state_control.ShowAnimState(MahjongGameAnimState.changeFlower, 
        function()
            roomdata_center.SetPlayerFlowersCards(viewSeat, flowerCards)
            self.compTable:ShowChangeFlowers(viewSeat, flowerCards, totalCards, newCards, function() 
                Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F3_CHANGE_FLOWER)
            end,isDeal)
    end, true,true)
end


-- 牌值  是否为金牌
function comp_show_base:OnGameOpenGlod(tbl)
    print(GetTblData(tbl))
    local cardValue = tbl._para.nCard
    local isGold = tbl._para.bGold

    self.curState = game_state.opengold

    self.compTable:HideAllFlowerInTable(function ()

    mahjong_anim_state_control.ShowAnimState(MahjongGameAnimState.openGold, 
        function()
            self.compTable:ShowJin(cardValue, isGold, true, function()
                self.compPlayerMgr:GetPlayer(1):ShowJinInHand()
                Notifier.dispatchCmd(cmdName.MSG_HANDLE_DONE, cmdName.F3_OPEN_GOLD)
            end)
            if isGold then
                roomdata_center.jin = cardValue
                mahjong_ui.SetAllScoreVisible(true)
            else
                roomdata_center.UpdateRoomCard(-1)
                roomdata_center.AddFlowerCardToZhuang(cardValue)
            end
        end, true)
    end)
    ui_sound_mgr.PlaySoundClip("common/kaijin")
end


function comp_show_base:OnResetFlowerCards(flowerCardsList)
    roomdata_center.playerFlowerCards = {}
    for i = 1, roomdata_center.MaxPlayer() do
        local count = #flowerCardsList[i]
        local cards = self.compTable:GetResetCardsFromLast(count)
        local viewSeat = self.gvblnFun(i)
        roomdata_center.SetPlayerFlowersCards(viewSeat, flowerCardsList[i])
        for j = 1, #cards do
            cards[j]:HideAndReset()
        end
    end
end



--恢复牌墙
function comp_show_base:OnResetWall(dice)
    roomdata_center.SetRoomLeftCard(mode_manager.GetCurrentMode().config.MahjongTotalCount)
    local dice_big = dice[1]
    local dice_small = dice[2]
    if dice_big < dice_small then
        local temp = dice_big
        dice_big = dice_small
        dice_small = temp
    end
    local viewSeat = roomdata_center.zhuang_viewSeat + dice_big + dice_small -1
    viewSeat = viewSeat % 4
    if viewSeat == 0 then
        viewSeat = 4
    end
    self.compTable:ResetWall(mode_manager.GetCurrentMode().config.MahjongDunCount-dice_small - dice_big, viewSeat)
end

function comp_show_base:OnResetLai(laizi)
    if laizi.sit[1]~=nil and laizi.card[1]~=nil then
        roomdata_center.hun = laizi.laizi[1]
        self.compTable:ShowLai(laizi.sit[1]/2, laizi.card[1])
    end
end


function comp_show_base:OnResetHandCard(tileCount, tileList)
     --手牌
    for i=1,roomdata_center.MaxPlayer() do
        local count = tileCount[i]
        local viewSeat = self.gvblnFun(i)
        local cardItems =self.compTable:GetResetCards(count)
        if viewSeat == 1 then
           self.compPlayerMgr:GetPlayer(viewSeat):ResetHandCard(cardItems, tileList)
        else
           self.compPlayerMgr:GetPlayer(viewSeat):ResetHandCard(cardItems)
        end
    end
    self.compPlayerMgr:GetPlayer(1):ShowJinInHand()
end

function comp_show_base:OnResetOperateCard(combineTile)
     --操作牌
    for i=1,roomdata_center.MaxPlayer() do
        local operData = combineTile[i]
        local viewSeat = self.gvblnFun(i)
        self.compPlayerMgr:GetPlayer(viewSeat):ResetOperCard(
            function(count)
                return self.compTable:GetResetCards(count)
            end,
        operData)        
    end
end

function comp_show_base:OnResetDiscardCard(discardTile)
     local hasoutCard = false
    --出牌
    for i=1,roomdata_center.MaxPlayer() do
        local count = #discardTile[i]
        local viewSeat = self.gvblnFun(i)
        local cardItems =self.compTable:GetResetCards(count)
        if not hasoutCard and count > 0 then
            hasoutCard = true
        end
        self.compPlayerMgr:GetPlayer(viewSeat):ResetOutCard(cardItems, discardTile[i])
    end
    if hasoutCard then
        roomdata_center.beginSendCard = true
    end
end


--恢复玩家牌
function comp_show_base:OnResetCard( discardTile, combineTile, tileCount, tileList)
    local hasoutCard = false
    --出牌
    for i=1,roomdata_center.MaxPlayer() do
        local count = #discardTile[i]
        local viewSeat = self.gvblnFun(i)
        local cardItems =self.compTable:GetResetCards(count)
        if not hasoutCard and count > 0 then
            hasoutCard = true
        end
        self.compPlayerMgr:GetPlayer(viewSeat):ResetOutCard(cardItems, discardTile[i])
    end
    if hasoutCard then
        roomdata_center.beginSendCard = true
    end

    --操作牌
    for i=1,roomdata_center.MaxPlayer() do
        local operData = combineTile[i]
        local viewSeat = self.gvblnFun(i)
        self.compPlayerMgr:GetPlayer(viewSeat):ResetOperCard(
            function(count)
                return self.compTable:GetResetCards(count)
            end,
        operData)        
    end

    --手牌
    for i=1,roomdata_center.MaxPlayer() do
        local count = tileCount[i]
        local viewSeat = self.gvblnFun(i)
        local cardItems =self.compTable:GetResetCards(count)
        if viewSeat == 1 then
           self.compPlayerMgr:GetPlayer(viewSeat):ResetHandCard(cardItems, tileList)
        else
           self.compPlayerMgr:GetPlayer(viewSeat):ResetHandCard(cardItems)
        end
    end
    self.compPlayerMgr:GetPlayer(1):ShowJinInHand()

end

function comp_show_base:OnResetGameInfo(subRound, leftCard)
    mahjong_ui.SetGameInfoVisible(true)
    roomdata_center.nCurrJu = subRound
    mahjong_ui.SetRoundInfo(subRound, roomdata_center.nJuNum)
    roomdata_center.SetRoomLeftCard(leftCard)
end


function comp_show_base:OnResetGoldCard( jin )
     if jin ~= nil then
        roomdata_center.jin = jin
        self.compTable:ShowJin(jin, true)
    end
end

--[[--
 * @Description: 设置出牌特效  
 ]]
function comp_show_base:SetOutCardEfObj(pos, isHide)
    if isHide ~= nil and isHide then
        self.outCardEfObj.transform.position = self.outCardEfObj.transform.position + Vector3(0, -1, 0)
    else
        self.outCardEfObj.transform.position = pos
    end
end

