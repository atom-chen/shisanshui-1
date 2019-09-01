--[[--
 * @Description: 大厅UI控制
 * @Author:      shine
 * @FileName:    hall_ui_ctrl.lua
 * @DateTime:    2017-05-19 14:32:55
 ]]

hall_ui_ctrl = {}
local this = hall_ui_ctrl

local firstLogin = true
local loadDataCor = nil 

function this.Init()
    -- body
end

function this.UInit()
  if loadDataCor ~= nil then
    coroutine.stop(loadDataCor)
    loadDataCor = nil
  end    
end

--[[--
 * @Description: 加载完场景做的第一件事
 ]]
function this.HandleLevelLoadComplete()
	log("gs_mgr.state_main_hall-------------------------------")
  	gs_mgr.ChangeState(gs_mgr.state_main_hall)
  	map_controller.SetIsLoadingMap(false)


    --查询游戏重连状态
    if firstLogin then
        loadDataCor = coroutine.start(function ()
            http_request_interface.getClientConfig(nil, this.OnGetClientConfig)
        end)
        firstLogin = false
    end
end

function this.OnGetClientConfig(code, m, str)
  --等获取游戏配置列表后再查询状态  
  log("this.OnGetClientConfig============"..str)
  local realUrl =nil
  local s = string.gsub(str,"\\/","/")
  local data = ParseJsonStr(s)
  if str ==nil then
    return 
  else
    if data ~= nil then
      local tmp = data["gameinfo"]["roomgame"]
      local gidTbl = {}
      for i,v in ipairs(tmp) do
        realUrl= data["mjupdateurl"]..v["grule"]
        if PlayerPrefs.HasKey("jsonversion") and PlayerPrefs.GetInt("jsonversion") == tonumber(data["jsonversion"]) 
          and FileReader.IsFileExists(Application.persistentDataPath.."/"..v["grule"]) then 
          --return
        else
          PlayerPrefs.SetInt("jsonversion", tonumber(data["jsonversion"]))
          --request_config["gid"]=gid
          log("拉取json文件")
          NetWorkManage.Instance:HttpDownTextAsset(realUrl, function(code, msg)
          end, Application.persistentDataPath.."/games/gamerule")
        end

        table.insert(gidTbl, tonumber(v["gid"]))
      end

      player_data.SetGidTbl(gidTbl)
    end

    local paraData = {}
    paraData._gids = player_data.GetGidTbl() 

    join_room_ctrl.QueryState()
    -- 大厅queryState
    --[[LogW("--------gidss------" ,paraData._gids )
    local pkgBuffer = majong_request_protocol.QueryGameState(messagedefine.onlinePath, paraData);
    SocketManager:onHallSendData( pkgBuffer ) ]]
    -- majong_request_interface.QueryGameStateReq(paraData)    
  end
end

function this.dogif(sp,t)  
    local time=0
    while true do
        if time<1 then
            time=time+Time.deltaTime
        else
            time=0
            local t1
            local t2 
            t1,t2 = math.modf(Time.time/3)    
            for i=1,table.getCount(sp),1 do
                sp[i].alpha=t2*i
            end
        end
    end 
end 
