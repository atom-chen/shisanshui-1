--[[--
 * @Description: player manager
 * @Author:      ShushingWong
 * @FileName:    comp_playerMgr.lua
 * @DateTime:    2017-06-20 15:25:17
 ]]



comp_playerMgr = {}

function comp_playerMgr.create()
	require "logic/mahjong_sys/mode_components/mode_comp_base"
	local this = mode_comp_base.create()
	this.Class = comp_playerMgr
	this.name = "comp_playerMgr"

    this.comp_player_class = require "logic/mahjong_sys/mode_components/comp_player"

    local playerList = {}--玩家组件列表
    
	this.base_init = this.Initialize

	function this:Initialize()
		this.base_init()        
        --compResMgr = this.mode:GetComponent("comp_resMgr")
        this:InitPlayer()
	end


    --[[--
     * @Description: 初始化玩家组件  
     ]]
    function this:InitPlayer()
        local playersPoint = GameObject.New("Players")

        for i=1,roomdata_center.MaxPlayer(),1 do
            local player = this.comp_player_class.create()
            player.mode = this.mode
            player.playerObj.transform:SetParent(playersPoint.transform, false)
            if roomdata_center.MaxPlayer() == 2 and i == 2 then
                player.playerObj.transform.localEulerAngles = Vector3(0, -90 * i, 0)
                -- player.playerObj.transform.localPosition = Vector3(0,0, -0.12)
            else
                player.playerObj.transform.localEulerAngles = Vector3(0, -90 * (i-1), 0)
            end

            if i == 3 then
                player.playerObj.transform.localPosition = Vector3(0,0, -0.12)
            end

            player.playerObj.name = "Player"..i
            player.viewSeat = i
            --playerList[i] = player
            table.insert(playerList,player)
        end
    end

    --[[--
     * @Description: 获取玩家组件  
     ]]
    function this:GetPlayer(index)
        return playerList[index]
    end


    function this:HideHuaInTable()
        for i = 1,#playerList,1 do
            playerList[i]:DoHideFlowerCards()
        end
    end

    --[[--
     * @Description: 所有玩家手牌排序  
     ]]
    function this:AllSortHandCard()
        for i=1,#playerList do
            playerList[i]:SortHandCard(false)
        end
    end

    --[[--
     * @Description: 重置玩家，游戏开始前  
     ]]
    function this:ResetPlayer()
        for i = 1,#playerList,1 do
            playerList[i].Init()
        end
    end


    local highLightCache = {} --高亮

    --[[--
     * @Description: 设置相同牌高亮  
     ]]
    function this:SetHighLight(value)
        this:HideHighLight()
        for i = 1,#playerList,1 do
            local t = playerList[i]:GetSameValueItem(value)
            for i=1,#t do
                table.insert(highLightCache,t[i])
            end
        end
        for i=1,#highLightCache do
            highLightCache[i]:SetHighLight(true)
        end
    end


    --[[--
     * @Description: 隐藏高亮  
     ]]
    function this:HideHighLight()
        for i=1,#highLightCache do
            highLightCache[i]:SetHighLight(false)
        end
        highLightCache = {}
    end

	this.base_unInit = this.Uninitialize
	
	function this:Uninitialize()
		this.base_unInit()
        for i = 1,#playerList,1 do
            playerList[i]:Uninitialize()
        end
	end

	return this
end