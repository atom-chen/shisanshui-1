local poolBaseClass = require "logic/common/poolBaseClass"
-- local openroom_poplist = require"logic/hall_sys/openroom/openroom_poplist"
local openroom_clubTab = require"logic/hall_sys/openroom/openroom_clubTab"
local openroom_gameItemBtn = require"logic/hall_sys/openroom/openroom_gameItemBtn"
local openroom_content_view = require "logic/hall_sys/openroom/openroom_content_view"
local openroom_window = require "logic/hall_sys/openroom/openroom_window"
require "logic/hall_sys/openroom/openroom_model"

local clubModel = ClubModel
local openroom_model = openroom_model
local GameModel = GameModel

local base = require("logic.framework.ui.uibase.ui_window")
local openroom_ui = class("openroom_ui",base)
local tips_view = require "logic/hall_sys/openroom/comp/tips_view"
local defaultTitleStr = "创建房间"
local tipsStr = "勾选自动开房后,当前房间牌局开始之后会自动参照当前配置自动开启一个新房间,前往开房管理界面可以停止自动开房功能"
function openroom_ui:ctor()
	base.ctor(self)
	self.curGameGid = 0
	self.curTypeIndex = 0
	self.clubGameGidList = nil
	self.gameBtnObjList = {}
	openroom_model:Init()
end

function openroom_ui:OnInit()
	base.OnInit(self)
	self:FindChild()
	self:InitPool()
end

--[[--
 * @Description: 默认不传俱乐部gid列表  
 ]]
function openroom_ui:OnOpen(clubInfo)
	base.OnOpen(self,clubInfo)

	self.openroom_clubTab:SetData(openroom_model:GetOpenRoomClubList(),function (clubInfo)
		self.curGameGid = 0
		self.curTypeIndex = 0
		self:UpdateCurClubInfo(clubInfo)

		self:SetHideRidToggle()
		self:SetAutoOpenToggle()
		if self.isOfficial then
			self:ResetGameItemBtn()
		else
			self:ResetGameItemBtnWithoutSec()
		end

		-- FrameTimer.New(
		-- 	function() 
		-- 		self:Show()
		-- 	end,1,1):Start()
	end,clubInfo or clubModel.currentClubInfo or clubModel.officalClubList[1])

end

function openroom_ui:UpdateCurClubInfo(clubInfo)
	self.currentClubInfo = clubInfo or clubModel.currentClubInfo
	if self.currentClubInfo then
		-- if clubModel:CheckCidIsOffical(self.currentClubInfo["cid"]) then
		-- 	self.titleLbl.text = defaultTitleStr
		-- else
		-- 	self.titleLbl.text = self.currentClubInfo["cname"]
		-- end
		self.canClubCost = clubModel:CheckCostCreater(self.currentClubInfo)
		self.cid = self.currentClubInfo.cid
		self.clubGameGidList = ClubUtil.GetOpenClubGids(self.currentClubInfo.gids)
		self.isOfficial = self.currentClubInfo.ctype == 1
		self.isCustomRoomCard = (self.currentClubInfo.costcfg~=nil) and (table.getCount(self.currentClubInfo.costcfg)>0)
	end
	self:InitAutoOpenToggle()

end

function openroom_ui:close()
	self.currentClubInfo = nil
	self.canClubCost = nil
	self.cid = nil
	self.clubGameGidList = nil
	self.isOfficial = nil
	self.isCustomRoomCard = nil
	self.content:DelCache()
	ui_sound_mgr.PlayCloseClick()
	UI_Manager:Instance():CloseUiForms("openroom_ui")
end

function openroom_ui:PlayOpenAmination()
end

function openroom_ui:OnRefreshDepth()

  local uiEffect = child(self.gameObject.transform, "Panel_Top/Background/Title/Effect_chengyuan")
  if uiEffect and self.sortingOrder then
    local topLayerIndex = self.sortingOrder +self.m_subPanelCount +1
--    Utils.SetEffectSortLayer(uiEffect.gameObject, topLayerIndex)
  end
end

function openroom_ui:FindChild()

	self.btn_close=child(self.transform,"Panel_Top/backBtn")
	addClickCallbackSelf(self.btn_close.gameObject,self.close,self)

	-- self.poplist_go = child(self.transform,"Panel_Left/Sprite_menuPanel").gameObject
	-- self.openroom_poplist = openroom_poplist:create(self.poplist_go)
	-- self.openroom_poplist:SetToggleCallback(function (gameType) self:OnPopListToggleClick(gameType) end )

	self.clubTab_go = child(self.transform,"Panel_Top/clubTab").gameObject
	self.openroom_clubTab = openroom_clubTab:create(self.clubTab_go)

	-- self.clubName = subComponentGet(self.transform,"Panel_Top/clubInfo_name","UILabel")
	-- self.clubId = subComponentGet(self.transform,"Panel_Top/clubInfo_cid","UILabel")

	self.gameList_scrollView = subComponentGet(self.transform,"Panel_Left/gameBtn_list","UIScrollView")
	self.gameListGrid_tr = child(self.transform,"Panel_Left/gameBtn_list/grid")
	self.gameItemBtn_tr = child(self.transform,"Panel_Left/gameItemBtn")
	self.gameItemSecBtn_tr = child(self.transform,"Panel_Left/gameItemSecBtn")
	self.poolRoot_tr = child(self.transform,"Panel_Left/gameItemSecPool")
	self.gameItemSecBtnList = {}
	-- table.insert(self.gameBtnObjList,openroom_gameItemBtn:create(self.gameItemBtn_tr.gameObject))

	self.createBtn_tr = child(self.transform,"Panel_Right/createBtn")
	addClickCallbackSelf(self.createBtn_tr.gameObject,self.OnCreateBtnClick,self)

	self.hideRidToggle = subComponentGet(self.transform,"Panel_Right/hideRoom","UIToggle")
	addClickCallbackSelf(self.hideRidToggle.gameObject,self.OnHideBtnClick,self)

	self.autoOpenToggle = subComponentGet(self.transform,"Panel_Right/autoOpen","UIToggle")
	addClickCallbackSelf(self.autoOpenToggle.gameObject,self.OnAutoBtnClick,self)

	self.roonCard_lb = subComponentGet(self.transform,"Panel_Right/roonCard","UILabel")
	self.content_go = child(self.transform,"Panel_Right/content").gameObject
	self.content = openroom_content_view:create(self.content_go)
	self.content.main_ui = self

	self.toggleWindowBg_go = child(self.transform,"Panel_Center/window").gameObject
	self.toggleWindow = openroom_window:create(self.toggleWindowBg_go)
	self.toggleWindow.content = self.content
	self.content.toggleWindow = self.toggleWindow
	--tips提示
	self.tips_view = tips_view:create(self:GetGameObject("Panel_Right/autoOpenTips"))	--tips提示
	self.tips_view:SetActive(false)

	self.tips_view:SetTipsEnable(tipsStr)
	-- self.titleLbl = subComponentGet(self.transform,"Panel_Top/Background/Title","UILabel")
end

function openroom_ui:InitPool()
	local createFunc = function () 
		local prefab = newobject(self.gameItemSecBtn_tr.gameObject)
		return prefab	
	end

	local recycleFunc = function (obj)
		obj.transform:SetParent(self.poolRoot_tr,false)
	end

	self.gameItemSecBtnPool = poolBaseClass:create(createFunc,nil,recycleFunc)

end

--[[--
 * @Description: 显示无分类  
 ]]
function openroom_ui:ResetGameItemBtnWithoutSec()
	local gametype = GameModel:GetTypeList()
	local gametypeList = {}

	-- for i,cfg in pairs(gametype) do
	-- 	local gLst = self:SelectClubGid(cfg.gids)
	-- 	if table.getn(gLst) > 0 then
	-- 		table.insert(gametypeList,{gids = gLst,name = cfg.name,order = cfg.order,id = i})
	-- 	end
	-- end
	table.insert(gametypeList,{gids = {22},name = "shisangshui",order = 11,id = 1})
	
	-- for i=#gametypeList,1,-1 do
	-- 	for j=1,i-1 do
	-- 		if gametypeList[j].order > gametypeList[j+1].order then
	-- 			local temp = gametypeList[j+1]
	-- 			gametypeList[j+1] = gametypeList[j]
	-- 			gametypeList[j] = temp
	-- 		end
	-- 	end
	-- end

	local showList = {}
	for _,v in ipairs(gametypeList) do
		for _,gid in ipairs(v.gids) do
			table.insert(showList,gid)
		end
	end

	for i=1,#self.gameBtnObjList do
		local item = self.gameBtnObjList[i]
		if not IsNil(item.gameObject) then
			item:SetActive(false)
		end
	end

	self:OnOpenGameItemBtn(nil,showList,true)
	componentGet(self.gameListGrid_tr,"UITable"):Reposition()
	self.gameList_scrollView:ResetPosition()

end

--[[--
 * @Description: 显示二级分类按钮  
 ]]
function openroom_ui:ResetGameItemBtn()
	local gametype = GameModel:GetTypeList()
	local showList = {}
	if self.isOfficial then
		local RecentlyGids = self:GetRecentlyGidsData()
		if #RecentlyGids.gids > 0 then
			table.insert(showList,RecentlyGids)
		end
	end
	for i,cfg in pairs(gametype) do
		local gLst = self:SelectClubGid(cfg.gids)
		if table.getn(gLst) > 0 then
			table.insert(showList,{gids = gLst,name = cfg.name,order = cfg.order,id = i})
		end
	end
	
	for i=#showList,1,-1 do
		for j=1,i-1 do
			if showList[j].order > showList[j+1].order then
				local temp = showList[j+1]
				showList[j+1] = showList[j]
				showList[j] = temp
			end
		end
	end
	self.showList = showList
	
	for i=table.getn(self.showList) + 1,#self.gameBtnObjList do
		local item = self.gameBtnObjList[i]
		if not IsNil(item.gameObject) then
			item:SetActive(false)
		end
	end
	for i,cfg in ipairs(self.showList) do
		local item
		if i<=#self.gameBtnObjList then
			item = self.gameBtnObjList[i]
		else
			local obj = newobject(self.gameItemBtn_tr.gameObject)
			obj.transform:SetParent(self.gameListGrid_tr,false)
			item = openroom_gameItemBtn:create(obj)
			table.insert(self.gameBtnObjList,item)
		end
		item.gids = cfg.gids
		item:SetCallback(function (obj) self:OnGameItemBtnClick(obj) end )
		item:SetName(i)
		item:SetText(cfg.name)
		item:SetActive(true)
		item.self_toggle.value = false
	end
	componentGet(self.gameListGrid_tr,"UITable"):Reposition()
	self.gameList_scrollView:ResetPosition()

	local firstItem = self.gameBtnObjList[1]
	if firstItem and firstItem.isActive then 
		firstItem:OnBtnClick()
	else
		self.curGameGid = 0
		self:RecycleGameItemSecBtn()
		self:ReflashPanel()
	end
end

--[[--
 * @Description: 常玩游戏列表  
 ]]
function openroom_ui:GetRecentlyGidsData()
	local gLst = {}
	if PlayerPrefs.HasKey(global_define.CUR_GAME_ID) then
		local gid = tonumber(PlayerPrefs.GetString(global_define.CUR_GAME_ID))
		if IsTblIncludeValue(gid,self.clubGameGidList or {}) then
    		table.insert(gLst,gid)
    	end
    end

    if PlayerPrefs.HasKey(global_define.NEXT_GAME_ID) then
    	local gid = tonumber(PlayerPrefs.GetString(global_define.NEXT_GAME_ID))
		if IsTblIncludeValue(gid,self.clubGameGidList or {}) then
    		table.insert(gLst,gid)
    	end
    end 

    return {gids = gLst,name = "常玩",order = 0,id = 0}
end

--[[--
 * @Description: 当前俱乐部拥有游戏
 ]]
function openroom_ui:SelectClubGid(gidList)
	local gidList = gidList or {}
	if self.clubGameGidList then
		local selectList = {}
		for _,gid in ipairs(gidList) do
			for _,clubGid in ipairs(self.clubGameGidList) do
				if clubGid == gid then
					table.insert(selectList,gid)
				end
			end
		end
		return selectList
	end
	return gidList
end

--[[--
 * @Description: 大类点击事件  
 ]]
function openroom_ui:OnGameItemBtnClick(obj)
	local index = tonumber(obj.name)
	local isOpen = true
	if self.curTypeIndex == index then
		isOpen = false
	end
	if obj then
		local t = componentGet(obj.transform,"UIToggle")
		if t then
			t.value = isOpen
		end
	end
	if isOpen then
		self.curTypeIndex = index
	else
		self.curTypeIndex = 0 
	end
	self:OnOpenGameItemBtn(obj,self.showList[index].gids,isOpen)

	componentGet(self.gameListGrid_tr,"UITable"):Reposition()
	self.gameList_scrollView:ResetPosition()
end

--[[--
 * @Description: 展开大类显示二级分类  
 ]]
function openroom_ui:OnOpenGameItemBtn(obj,gids,isOpen)
	self:RecycleGameItemSecBtn()

	if isOpen then
		local typeIndex
		if obj then
			typeIndex = obj.transform:GetSiblingIndex()
		else
			typeIndex = -1
		end

		for i=#gids,1,-1 do
			local item = self:GetGameItemSecBtn(typeIndex + 1)
			item:SetCallback(function (obj) self:OnGameItemSecBtnClick(obj) end )
			item:SetName(gids[i])
			--item:SetText(GameModel:GetGameName(gids[i]))
			item:SetText("shisangshui")
		end
	end
	
	local firstItem = self.gameItemSecBtnList[1]
	if firstItem then 
		firstItem:OnBtnClick()
	else
		self.curGameGid = 0
		self:ReflashPanel()
	end
end

--[[--
 * @Description: 二级类点击  
 ]]
function openroom_ui:OnGameItemSecBtnClick(obj)
	local gid = tonumber(obj.name)
	if obj then
		local t = componentGet(obj.transform,"UIToggle")
		if t then
			t.value = true
		end
	end

	for i,v in ipairs(self.gameItemSecBtnList) do
		if gid == v.gid then
			v:SetValue(true)
		else
			v:SetValue(false)
		end
	end

	self.curGameGid = gid
	self:ReflashPanel()
end

--[[--
 * @Description: 回收  
 ]]
function openroom_ui:RecycleGameItemSecBtn()
	for i,v in ipairs(self.gameItemSecBtnList) do
		self.gameItemSecBtnPool:Recycle(v.gameObject)
	end
	self.gameItemSecBtnList = {}

end

--[[--
 * @Description: 二级子游戏点击  
 ]]
function openroom_ui:GetGameItemSecBtn(index)
	local obj = self.gameItemSecBtnPool:Get()
	local tr = obj.transform
	tr:SetParent(self.gameListGrid_tr,false)
	tr:SetSiblingIndex(index)
	item = openroom_gameItemBtn:create(obj)
	item:SetActive(true)
	table.insert(self.gameItemSecBtnList,1,item)
	return item
end

-- function openroom_ui:Show()
-- 	self:SetHideRidToggle()
-- 	if self.currentClubInfo and not self.isOfficial then
-- 		self.clubName.text = self.currentClubInfo.cname
-- 		self.clubId.text = "ID:"..self.currentClubInfo.shid
-- 	else
-- 		self.clubName.text = ""
-- 		self.clubId.text = ""
-- 	end
-- 	self.openroom_poplist:SetMenuLabel()
-- 	self:ResetGameItemBtn(0)
-- 	local curGameID
-- 	if PlayerPrefs.HasKey("CUR_GAME_ID") then
--     	curGameID = PlayerPrefs.GetString("CUR_GAME_ID")    	
--     end 
--     local isMemory = false
--     local gids = self:GetGidList(0)
--     if curGameID then
--     	for i,v in ipairs(self.gameBtnObjList) do
--     		if gids[i] == tonumber(curGameID) then
--     			self:SetGameBtnPos(i,#gids)
--     			self:OnGameItemBtnClick(self.gameBtnObjList[i].gameObject)
--     			isMemory = true
--     			return
--     		end
--     	end
--     end
--     if not isMemory then
-- 		if gids and #gids>0 then
-- 			self:OnGameItemBtnClick(self.gameBtnObjList[1].gameObject)
-- 			return
-- 		end
-- 	end
-- 	self:SetContentActive(false)
-- 	self.curGameGid = nil
-- end

-- function openroom_ui:SetGameBtnPos(index,count)
-- 	if count > 6 then
-- 		if index> count/2 then
-- 			self.gameList_scrollView:SetDragAmount(0, index/count, false)
-- 		else
-- 			self.gameList_scrollView:SetDragAmount(0, (index-1)/count, false)
-- 		end
-- 	end
-- end

----------------- 右侧 开放设置 相关 -----------------

function openroom_ui:ReflashPanel()
	if self.curGameGid and self.curGameGid~=0 then
		self:SetContentActive(true)
		-- local paneltable = openroom_model:GetPanelTableByGid(self.curGameGid,self:IsClub())
		-- FrameTimer.New(
		-- 	function() 
		-- 		self.content:Show(paneltable,self.canClubCost)
		-- 	end,1,1):Start()
	else
		self:SetContentActive(false)
	end
end

function openroom_ui:SetContentActive(flag)
	self.content:SetActive(flag)
	if not flag then
		self:SetRoomCard("")
	end
end

function openroom_ui:IsClub()
	local isClub = false
	if self.clubGameGidList and not self.isOfficial then
		isClub = true
	end
	return isClub
end

function openroom_ui:SetRoomCard(str)
	if self.roonCard_lb and str then
		self.roonCard_lb.text = str
	end
end

function openroom_ui:OnHideBtnClick()
	local hdievalue = self:GetHideRidValue()
	if hdievalue == 1 or hdievalue == true then
		self.autoOpenToggle.value = false
		self:SetAutoOpenToggleEnable(false)
	else
		self:SetAutoOpenToggleEnable(true)
	end
end

function openroom_ui:OnAutoBtnClick() 
	local autovalue = self:GetAutoOpenValue()
	if autovalue == 1 or autovalue == true then
		self:SetHideRidToggleEnable(false)
		self.hideRidToggle.value = false
	else
		self:SetHideRidToggleEnable(true)
	end
end

function openroom_ui:OnAutoTipsClick()
	
end

function openroom_ui:SetHideRidToggle()
	if self.hideRidToggle then
		if self.isOfficial then
			--if PlayerPrefs.HasKey(global_define.HideRoomNumFlag) then
		    	-- local hideRoomNumFlag = PlayerPrefs.GetString(global_define.HideRoomNumFlag)    
				self.hideRidToggle.value = true
				self.autoOpenToggle.value = false
				self:SetHideRidToggleEnable(false)
				return
		    -- end 
		else
			self:SetHideRidToggleEnable(true)
			if PlayerPrefs.HasKey(global_define.ClubHideRoomNumFlag) then
		    	local hideRoomNumFlag = PlayerPrefs.GetString(global_define.ClubHideRoomNumFlag)    
				self.hideRidToggle.value = tonumber(hideRoomNumFlag) == 1
				return
		    end 
		end    
	    self.hideRidToggle.value = self.isOfficial	--官方俱乐部默认勾选隐藏房号
	end
end

function openroom_ui:SetAutoOpenToggle()
	local hideValue = self:GetHideRidValue()
	if self.autoOpenToggle then
		if self.isOfficial then
			self.autoOpenToggle.gameObject:SetActive(false)
			self.tips_view.gameObject:SetActive(false)
			return
		else
			if hideValue == true then
				self:SetAutoOpenToggleEnable(false)
				return
			end
			self:SetAutoOpenToggleEnable(true)
		end
		self.autoOpenToggle.value = false
	end
end


function openroom_ui:InitAutoOpenToggle()
	local useinfo = data_center.GetLoginUserInfo()
	if self.currentClubInfo.uid and self.currentClubInfo.uid == useinfo.uid then
		self.autoOpenToggle.gameObject:SetActive(true)
		
		self.tips_view.gameObject:SetActive(true)
	else
		self.autoOpenToggle.gameObject:SetActive(false)
		self.tips_view.gameObject:SetActive(false)
	end
end


local darkColor = Color(133/255, 133/255, 133/255)
local normalColor = Color(183/255, 195/255, 230/255)

function openroom_ui:SetHideRidToggleEnable(value)
	if value then
		componentGet(self.hideRidToggle.transform,"BoxCollider").enabled = true
		subComponentGet(self.hideRidToggle.transform,"Background","UISprite").spriteName = "create_03"
		subComponentGet(self.hideRidToggle.transform,"lab_noselect","UILabel").color = normalColor
	else
		componentGet(self.hideRidToggle.transform,"BoxCollider").enabled = false
		subComponentGet(self.hideRidToggle.transform,"Background","UISprite").spriteName = "icon_38"
		subComponentGet(self.hideRidToggle.transform,"lab_noselect","UILabel").color = darkColor
	end
end

function openroom_ui:SetAutoOpenToggleEnable(value)
	if value then
		componentGet(self.autoOpenToggle.transform,"BoxCollider").enabled = true
		subComponentGet(self.autoOpenToggle.transform,"Background","UISprite").spriteName = "create_03"
		subComponentGet(self.autoOpenToggle.transform,"lab_noselect","UILabel").color = normalColor
	else
		componentGet(self.autoOpenToggle.transform,"BoxCollider").enabled = false
		subComponentGet(self.autoOpenToggle.transform,"Background","UISprite").spriteName = "icon_38"
		subComponentGet(self.autoOpenToggle.transform,"lab_noselect","UILabel").color = darkColor
	end
end

function openroom_ui:OnCreateBtnClick()
	ui_sound_mgr.PlayButtonClick()
	if self.curGameGid and self.curGameGid~=0 then
	    local tables,newPanelTable = self.content:GetSelect() 
	    --tables.gid = self.curGameGid
	    tables.gid = 11
	    tables.ishide = self:GetHideRidValue()
	    tables.autocreate = self:GetAutoOpenValue()
	    -- 待整理
		if self.curGameGid == ENUM_GAME_TYPE.TYPE_XIAMEN_MJ or self.curGameGid == ENUM_GAME_TYPE.TYPE_QUANZHOU_MJ then
			tables.bsupportju = tables.bsupportke == 1 and 0 or 1
		end

		-- 临时处理，中途加入
		tables.bMidJoin = 1

		tables.rounds = 10
		tables.maxfan = 1
		tables.buyhorse = false
		tables.addColor = 0
		tables.joker = 0
		tables.leadership = false
		tables.pnum = 2
		tables.costtype = 1
		tables.nReadyTimeOut = 5
		tables.nChooseCardTypeTimeOut = 60		
		if self.clubGameGidList and self.cid then
			tables.cid = self.cid
			join_room_ctrl.CreateClubRoom(tables)
		else
	    	join_room_ctrl.CreateRoom(tables)   
	    end

	    self:SavePanelTable(newPanelTable)

	    self:close()
	end
end

function openroom_ui:SavePanelTable(newPanelTable,notPlayerPrefsId)
    -- 记忆
    if not notPlayerPrefsId then
	    if not (PlayerPrefs.GetString(global_define.CUR_GAME_ID,"") == tostring(self.curGameGid)) then
	    	if PlayerPrefs.HasKey(global_define.CUR_GAME_ID) then
		    	PlayerPrefs.SetString(global_define.NEXT_GAME_ID, PlayerPrefs.GetString(global_define.CUR_GAME_ID))
		    end
		    PlayerPrefs.SetString(global_define.CUR_GAME_ID, self.curGameGid)
	    end
	end

    local str= json.encode(newPanelTable)
    local prefs_str
	if self:IsClub() then
	 	prefs_str = global_define.ClubCreateRoomPlayerPrefs
	else
		prefs_str = global_define.CreateRoomPlayerPrefs
	end
    PlayerPrefs.SetString(prefs_str..self.curGameGid,str)

    if self.isOfficial then
	    -- PlayerPrefs.SetString(global_define.HideRoomNumFlag, (self:GetHideRidValue() and 1) or 0)
	else
		PlayerPrefs.SetString(global_define.ClubHideRoomNumFlag, (self:GetHideRidValue() and 1) or 0)
	end
end

function openroom_ui:GetHideRidValue()
	if self.hideRidToggle then
		return self.hideRidToggle.value
	end
	return false
end

function openroom_ui:GetAutoOpenValue()
	if self.autoOpenToggle then
		return self.autoOpenToggle.value
	end
	return false
end

----------------- 右侧 开放设置 相关 -----------------

return openroom_ui
