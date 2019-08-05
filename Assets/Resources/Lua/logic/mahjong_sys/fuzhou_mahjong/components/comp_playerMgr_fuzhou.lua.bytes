--[[--
 * @Description: 福州玩家管理组件
 * @Author:      ShushingWong
 * @FileName:    comp_playerMgr_fuzhou.lua
 * @DateTime:    2017-07-13 11:15:47
 ]]


comp_playerMgr_fuzhou = {}
function comp_playerMgr_fuzhou.create()
	require "logic/mahjong_sys/mode_components/comp_playerMgr"
	local this = comp_playerMgr.create()
	this.Class = comp_playerMgr_fuzhou
	this.name = "comp_playerMgr"

	this.comp_player_class = require "logic/mahjong_sys/fuzhou_mahjong/components/comp_player_fuzhou"

	return this
end