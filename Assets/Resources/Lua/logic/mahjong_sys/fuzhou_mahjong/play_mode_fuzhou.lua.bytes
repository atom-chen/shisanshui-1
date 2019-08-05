--[[--
 * @Description: 福州麻将玩法
 * @Author:      shine
 * @FileName:    play_mode_fuzhou.lua
 * @DateTime:    2017-06-13 10:22:49
 ]]
require "logic/mahjong_sys/mode_base"
require "logic/mahjong_sys/mode_components/comp_clickevent"
require "logic/mahjong_sys/mode_components/comp_resMgr"
require "logic/mahjong_sys/mode_components/comp_mjItemMgr"
--require "logic/mahjong_sys/mode_components/comp_table"
--require "logic/mahjong_sys/mode_components/comp_playerMgr"

require "logic/mahjong_sys/fuzhou_mahjong/fuzhou_comp_show"
require "logic/mahjong_sys/fuzhou_mahjong/components/comp_table_fuzhou"
require "logic/mahjong_sys/fuzhou_mahjong/components/comp_playerMgr_fuzhou"
require "logic/mahjong_sys/mode_components/comp_dice"


play_mode_fuzhou = {}
local instance = nil

function play_mode_fuzhou.GetInstance()
    if (instance == nil) then
        instance = play_mode_fuzhou.create()
    end

    return instance
end

function play_mode_fuzhou.create(levelID)
    local this = mode_base.create(levelID)
    this.Class = play_mode_fuzhou
    this.name = "play_mode_fuzhou"
    this.config = require "logic/mahjong_sys/fuzhou_mahjong/config/play_mode_config_fuzhou"

    mahjong_anim_state_control.InitFuzhouAnims()
    --------------------------------  

    local ConstructComponents = nil

    this.base_init = this.Initialize
    function this:Initialize()
        this.base_init()   
        fuzhou_comp_show:Init()            
    end

    this.base_uninit = this.Uninitialize
    function this:Uninitialize()
        this.base_uninit()
        fuzhou_comp_show:Uinit()
        instance = nil        
        roomdata_center.isRoundStart = false
        roomdata_center.nCurrJu = 0
    end

    --[[--
     * @Description: 组装所需要的组件
     ]]
    function ConstructComponents()
        print("ConstructComponents---------------------------------------")
        -- 组装
        this:AddComponent(comp_clickevent.create())
        this:AddComponent(comp_resMgr.create())
        this:AddComponent(comp_mjItemMgr.create())
        this:AddComponent(comp_table_fuzhou.create())
        this:AddComponent(comp_playerMgr_fuzhou.create())      
        this:AddComponent(comp_dice.create())   
    end

    function this:PreloadObjects()
        --预加载场景物体
    end

    -- 执行下组装
    ConstructComponents()

    return this
end
