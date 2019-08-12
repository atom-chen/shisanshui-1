--[[--
 * @Description: 游戏状态, 单人模式
 * @Author:      shine
 * @FileName:    gs_level_single.lua
 * @DateTime:    2017-05-16 17:47:37
 ]]
require "logic/game_state/gs_base"

gs_level_single = gs_base.New()
gs_level_single.__index = gs_level_single

--[[--
 * @Description: 构造函数  
 ]]
function gs_level_single.New()
	local self = {}
	setmetatable(self, gs_level_single)

	return self
end

--[[--
 * @Description: 初始化
 ]]
function gs_level_single:Init()

end

--[[--
 * @Description: 反初始化
 ]]
function gs_level_single:Uninit( ... )

end

--[[--
 * @Description: 进入状态
 ]]
function gs_level_single:EnterState( ... )
	--log("gs_level_single:EnterState", LOG.gs)
	self.active = true
end

--[[--
 * @Description: 离开状态
 ]]
function gs_level_single:ExitState( ... )
	--log("gs_level_single:ExitState", LOG.gs)
	self.active = false
end

--[[--
 * @Description: 处理网络链接关闭
 ]]
function gs_level_single:HandleOnNetworkClose()
	--log("gs_level_single:HandleOnNetworkClose(), nothing to do", LOG.gs)
	-- override, nothing to do
end

