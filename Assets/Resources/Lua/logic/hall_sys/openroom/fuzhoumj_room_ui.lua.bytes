--[[--
 * @Description: 福州麻将开房ui逻辑
 * @Author:      huangxupeng,shine整理
 * @FileName:    fuzhoumj_room_ui.lua
 * @DateTime:    2017-07-13 11:28:08
 ]]

fuzhoumj_room_ui={}
local this=fuzhoumj_room_ui 

local toggleTbl = {}

local paramtable=
{
    ["halfpure"]=0,
    ["allpure"]=0,
    ["kindD"]=0,
    ["DkingD"]=0,
    ["rounds"]=0,
    ["pnum"]=0,
    ["settlement"]=0, 
}


function this.Start()
    this.InitWidgets()
    this.SetWidgetValue()
end

function  this.Hide()
    if not IsNil(this.gameObject) then 
		GameObject.Destroy(this.gameObject)
        this.gameObject=nil
	end
end


function this.InitWidgets()    
    toggleTbl.toggle_halfpure = subComponentGet(this.transform, "toggletype_01/toggle_grid/toggle_01", "UIToggle")
    toggleTbl.toggle_allpure = subComponentGet(this.transform, "toggletype_01/toggle_grid/toggle_02", "UIToggle")
    toggleTbl.toggle_kingD = subComponentGet(this.transform, "toggletype_01/toggle_grid/toggle_03", "UIToggle")
    toggleTbl.toggle_DkingD = subComponentGet(this.transform, "toggletype_01/toggle_grid/toggle_04", "UIToggle")

    toggleTbl.toggle_pnum_grid = child(this.transform, "toggletype_02/toggle_grid")
    toggleTbl.toggle_pnum_4 = subComponentGet(this.transform, "toggletype_02/toggle_grid/toggle_01", "UIToggle")
    toggleTbl.toggle_pnum_3 = subComponentGet(this.transform, "toggletype_02/toggle_grid/toggle_02", "UIToggle")
    toggleTbl.toggle_pnum_2 = subComponentGet(this.transform, "toggletype_02/toggle_grid/toggle_03", "UIToggle")

    toggleTbl.toggle_rounds_grid = child(this.transform, "toggletype_03/toggle_grid")
    toggleTbl.toggle_rounds_4 = subComponentGet(this.transform, "toggletype_03/toggle_grid/toggle_01", "UIToggle")
    toggleTbl.toggle_rounds_8 = subComponentGet(this.transform, "toggletype_03/toggle_grid/toggle_01", "UIToggle")
    toggleTbl.toggle_rounds_16 = subComponentGet(this.transform, "toggletype_03/toggle_grid/toggle_01", "UIToggle")

    toggleTbl.toggle_settlement_grid = child(this.transform, "toggletype_04/toggle_grid")
    toggleTbl.toggle_settlement_1 = subComponentGet(this.transform, "toggletype_04/toggle_grid/toggle_01", "UIToggle")
    toggleTbl.toggle_settlement_2 = subComponentGet(this.transform, "toggletype_04/toggle_grid/toggle_02", "UIToggle")    
end

function this.SetToggleState(toggle, value)
    if value == 1 then
        toggle:Set(true)
    else
        toggle:Set(false)
    end
end

function this.SetWidgetValue()
    local fzmjroomDataInfo = room_data.GetFzmjRoomDataInfo()
    if fzmjroomDataInfo ~= nil then        
        this.SetToggleState(toggleTbl.toggle_halfpure, fzmjroomDataInfo.halfpure)
        this.SetToggleState(toggleTbl.toggle_allpure, fzmjroomDataInfo.allpure)        
        this.SetToggleState(toggleTbl.toggle_kingD, fzmjroomDataInfo.kindD)
      --  this.SetToggleState(toggleTbl.toggle_DkingD, fzmjroomDataInfo.DkingD)

        if fzmjroomDataInfo.pnum == 4 then
            this.SetToggleState(toggleTbl.toggle_pnum_4, 1)
        elseif fzmjroomDataInfo.pnum  == 3 then
            this.SetToggleState(toggleTbl.toggle_pnum_3, 1)
        else
            this.SetToggleState(toggleTbl.toggle_pnum_2, 1)
        end

        if fzmjroomDataInfo.rounds == 4 then
            this.SetToggleState(toggleTbl.toggle_rounds_4, 1)
        elseif fzmjroomDataInfo.rounds == 8 then
            this.SetToggleState(toggleTbl.toggle_rounds_8, 1)
        else
            this.SetToggleState(toggleTbl.toggle_rounds_16, 1)
        end

        if fzmjroomDataInfo.settlement == 1 then
            this.SetToggleState(toggleTbl.toggle_settlement_1, 1)
        else
            this.SetToggleState(toggleTbl.toggle_settlement_2, 1)
        end
    end
end

function this.GetUserSelectData()
    for i=0,toggleTbl.toggle_pnum_grid.transform.childCount-1,1 do
        local toggle_pnum=toggleTbl.toggle_pnum_grid.transform:GetChild(i)                
        if componentGet(toggle_pnum, "UIToggle").value==true then
            paramtable["pnum"]= 4-i
        end
    end
  
    for i=0,toggleTbl.toggle_rounds_grid.transform.childCount-1,1 do
        local toggle_rounds = toggleTbl.toggle_rounds_grid.transform:GetChild(i)
        if componentGet(toggle_rounds, "UIToggle").value==true then            
            paramtable["rounds"]= 2 ^ (i+2)
        end
    end
    for i=0,toggleTbl.toggle_settlement_grid.transform.childCount-1,1 do
        local toggle_settlement=toggleTbl.toggle_settlement_grid.transform:GetChild(i)
        if componentGet(toggle_settlement, "UIToggle").value==true then
            paramtable["settlement"]= i
        end
    end
    if componentGet(toggleTbl.toggle_halfpure.gameObject, "UIToggle").value==true then
        paramtable["halfpure"]=1
        paramtable["allpure"]=1
        log(11111111 .."halfpureallpure")
    end
    if componentGet(toggleTbl.toggle_allpure.gameObject, "UIToggle").value==true then
        paramtable["allpure"]=1
    end
    if componentGet(toggleTbl.toggle_kingD.gameObject, "UIToggle").value==true then
        paramtable["kindD"]=1
    end
    --[[if componentGet(toggleTbl.toggle_DkingD.gameObject, "UIToggle").value==true then
        paramtable["DkingD"]=1
    end]]-- 
    return paramtable
end
 
function this.EnterGameReq(t)
    local gameData = {}
    gameData["pnum"] = t["pnum"]
    gameData["rounds"] = t["rounds"]
    gameData["nHalfColor"] = t["halfpure"]
    gameData["nOneColor"] = t["allpure"]
    gameData["nGoldDragon"] = t["kindD"]
    gameData["nSingleGold"] = t["DkingD"]
    gameData["nGunAll"] = (t["settlement"] == 0) and 1 or 0
    gameData["nGunOne"] = (t["settlement"] == 1) and 1 or 0
    gameData["uid"] = t["uid"]
    gameData["rno"] = t["rno"]
    gameData["rid"] = t["rid"]
    gameData["gid"] = t["gid"]
    majong_request_interface.EnterGameReq(gameData)
end