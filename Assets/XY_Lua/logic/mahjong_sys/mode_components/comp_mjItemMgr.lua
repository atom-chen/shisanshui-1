--[[--
 * @Description: mahjong manager
 * @Author:      ShushingWong
 * @FileName:    comp_mjItemMgr.lua
 * @DateTime:    2017-06-20 15:23:41
 ]]

require "logic/mahjong_sys/mode_components/comp_mjItem"

comp_mjItemMgr = {}

function comp_mjItemMgr.create()
	require "logic/mahjong_sys/mode_components/mode_comp_base"
	local this = mode_comp_base.create()
	this.Class = comp_mjItemMgr
	this.name = "comp_mjItemMgr"

    this.mjItemList = {}--麻将子组件列表，从视图玩家1左边第一墩从下至上开始

    this.mjObjDict = {}
    
	this.base_init = this.Initialize

    local config = nil
	function this:Initialize()
		this.base_init()
        log("----------------------InitMJItems")
        this:InitMJItems()
	end


    --[[--
     * @Description: 初始化麻将子  
     ]]
    function this:InitMJItems()
        if config == nil then
            config = this.mode.config
        end
        if #this.mjItemList == 0 then

            for i=1,config.MahjongTotalCount,1 do
                local mj = comp_mjItem.create()
                mj.mode = this.mode
                mj.mjObj.name = "MJ"..i

                mj:Init()
                table.insert(this.mjItemList, mj)
                this.mjObjDict[mj.mjObj] = mj            
            end
        else

            for i=1,config.MahjongTotalCount,1 do

                this.mjItemList[i]:Init()
            end
        end

    end


	this.base_unInit = this.Uninitialize
	
	function this:Uninitialize()
		this.base_unInit()
        for i,v in ipairs(this.mjItemList) do
            if v~=nil then
                v:Uninitialize()
            end
        end
	end



	return this
end