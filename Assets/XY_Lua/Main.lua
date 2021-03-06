--[[--
 * @Description: 作为Unity调用Lua的一些常用函数的桥梁
                 目前包括：
                 		  Update
                 		  LateUpdate
                 		  FixedUpdate
 * @Author:      shine
 * @FileName:    Main.lua
 * @DateTime:    2017-05-16 14:39:51
 ]]
require "Global"
require "logic/framework/game"


require "logic/mahjong_sys/mode_components/comp_mjItemMgr"
require "logic/mahjong_sys/mode_components/comp_table"
require "logic/mahjong_sys/mode_components/comp_playerMgr"
require "logic/mahjong_sys/fuzhou_mahjong/play_mode_fuzhou"
local model
local tab
local function Update()
	if Input.inputString == "@" then
		require "logic/mahjong_sys/mahjong_play_sys"
		map_controller.LoadLevelScene(900002, mahjong_play_sys)
	end
	if Input.inputString == "1" then
		model = play_mode_fuzhou.GetInstance()
		model:Start()
		tab = model:GetComponent("comp_table")
		tab:ShowWall(function() end)
		model:OnResetWall({2,3})
		roomdata_center.zhuang_viewSeat = 1
	end
	if Input.inputString == "2" then
		tab:SendAllHandCard(2, 1, nil, function() end)
	end
end


--[[--
 * @Description: lua层的主入口
 ]]
function Main()	
	log("lua层的主入口")
	math.randomseed(os.clock())		
	GameManager.OnInitOK(false, "", 0)
	-- UpdateBeat:Add(Update)
end


