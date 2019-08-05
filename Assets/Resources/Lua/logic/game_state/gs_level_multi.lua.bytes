--[[--
 * @Description: 游戏状态, 多人模式
 * @Author:      shine
 * @FileName:    gs_level_multi.lua
 * @DateTime:    2017-05-16 17:47:37
 ]]
require "logic/game_state/gs_base"

gs_level_multi = gs_base.New()
gs_level_multi.__index = gs_level_multi

--[[--
 * @Description: 构造函数  
 ]]
function gs_level_multi.New()
	local self = {}
	setmetatable(self, gs_level_multi)

	return self
end

--[[--
 * @Description: 初始化
 ]]
function gs_level_multi:Init()

end

--[[--
 * @Description: 反初始化
 ]]
function gs_level_multi:Uninit( ... )

end

--[[--
 * @Description: 进入状态
 ]]
function gs_level_multi:EnterState( ... )
	--print("gs_level_multi:EnterState", LOG.gs)
	self.active = true
end

--[[--
 * @Description: 离开状态
 ]]
function gs_level_multi:ExitState( ... )
	--print("gs_level_multi:ExitState", LOG.gs)
	self.active = false
end