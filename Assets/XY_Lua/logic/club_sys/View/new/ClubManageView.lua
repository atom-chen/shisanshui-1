local base = require "logic/framework/ui/uibase/ui_view_base"
local Item = class("Item", base)

function Item:InitView()
	-- self.titleLabel = subComponentGet(self.transform,"title", typeof(UILabel))
	-- self.desLabel = subComponentGet(self.transform,"des", typeof(UILabel))
	-- self.iconGo = child(self.gameObject, "icon").gameObject
	-- addClickCallbackSelf(self.gameObject, self.OnClick, self)
end

function Item:OnClick()
	if self.callback ~= nil then
		self.callback(self.target, self)
	end
end

function Item:SetInfo(index, word1, word2)
	self.index = index
	self.desLabel.text = ""--LanguageMgr.GetWord(word1)
	self.titleLabel.text = ""--LanguageMgr.GetWord(word2)
end

function Item:SetCallback(callback, target)
	self.callback = callback
	self.target = target
end

function Item:SetSelect(value)
	if value == 1 then
		self.iconGo:SetActive(true)
	else
		self.iconGo:SetActive(false)
	end
end


local ClubManageView = class("ClubManageView", base)
local cfg = 
{	
		-- 内容，提示，  字段
	[1] = {10211, 10201, 10221, "public"},
	[2] = {10212, 10202, 10222, "allcosthost"},
	[3] = {10213, 10203, 10223, "mcactuser"},
	[4] = {10214, 10204, 10224, "mcosthost"},
}

function ClubManageView:SetInfo(clubInfo)
	if clubInfo == nil then
		return
	end
	self.clubInfo = clubInfo
	self:RefreshView()
end
function ClubManageView:SetAgent(_isAgent)
	self._isAgent = _isAgent
end

function ClubManageView:RefreshView()
	log("ClubManageView:RefreshView")
	local isManager = ClubModel.agentInfo ~= nil and self.model.currentClubInfo.nickname == data_center.GetLoginRetInfo().nickname and ClubModel.agentInfo.agent ~= 0
	self.member:SetActive(not isManager)
	self.own:SetActive(isManager)
	if isManager then
		log(ClubModel.agentInfo)
		subComponentGet(self.transform,"own/total", typeof(UILabel)).text = "总额："..ClubModel.agentInfo.income
		subComponentGet(self.transform,"own/cash", typeof(UILabel)).text = "已提取额："..ClubModel.agentInfo.casha
		subComponentGet(self.transform,"own/left", typeof(UILabel)).text = "余额："..(ClubModel.agentInfo.income - ClubModel.agentInfo.casha)
	end
	if self.clubInfo ~= ClubModel.currentClubInfo then
		self.clubInfo =  ClubModel.currentClubInfo 
	end
	if self.clubInfo == nil then
		return
	end
	log(self.clubInfo)
	self.content.text = "亲友圈ID："..self.clubInfo.shid
	self.content0.text = ""..self.clubInfo.shid
	-- for i = 1, 4 do
	-- 	if self.clubInfo.cfg == nil then
	-- 		self.itemList[i]:SetSelect(false)
	-- 	else
	-- 		self.itemList[i]:SetSelect(self.clubInfo.cfg[cfg[i][4]])
	-- 	end

	-- 	--代理商隐藏“展示俱乐部”
	-- 	local item = self.itemList[i]
	-- 	if item then
	-- 		self.moveUpTbl = self.moveUpTbl or {}
	-- 		if i==1 then
	-- 			item.gameObject:SetActive(not self._isAgent)
	-- 			self.firstItemPos = item.transform.localPosition
	-- 		elseif self.firstItemPos then
	-- 			local itemPos = item.transform.localPosition
	-- 			self.itemMoveY = self.itemMoveY or (self.firstItemPos.y -itemPos.y)

	-- 			local managerLabel = self:GetGameObject("scroll/managerLabel")
	-- 			if managerLabel then
	-- 				local curValue = managerLabel.transform.localPosition
	-- 				if self._isAgent then
	-- 					--上移
	-- 					if not self.moveUpTbl[10] then
	-- 						self.moveUpTbl[10] = true
	-- 						managerLabel.transform.localPosition = Vector3(curValue.x, curValue.y +self.itemMoveY, curValue.z)
	-- 					end
	-- 				elseif self.moveUpTbl[10] then
	-- 					--恢复
	-- 					self.moveUpTbl[10] = false
	-- 					managerLabel.transform.localPosition = Vector3(curValue.x, curValue.y -self.itemMoveY, curValue.z)
	-- 				end
	-- 			end

	-- 			if self._isAgent then
	-- 				--上移
	-- 				if not self.moveUpTbl[i] then
	-- 					self.moveUpTbl[i] = true
	-- 					item.transform.localPosition = Vector3(itemPos.x, itemPos.y +self.itemMoveY, itemPos.z)
	-- 				end
	-- 			elseif self.moveUpTbl[i] then
	-- 				--恢复
	-- 				self.moveUpTbl[i] = false
	-- 				item.transform.localPosition = Vector3(itemPos.x, itemPos.y -self.itemMoveY, itemPos.z)
	-- 			end
	-- 		end
	-- 	end
	-- end
end


function ClubManageView:InitView()
	self.model = ClubModel
	self.itemList = {}
	-- for i = 1, 4 do
	-- 	local go = child(self.gameObject,"scroll/item" .. i).gameObject
	-- 	local item = Item:create(go)
	-- 	item:SetInfo(i, cfg[i][1], cfg[i][2])
	-- 	item:SetSelect(false)
	-- 	item:SetCallback(self.OnItemClick, self)
	-- 	self.itemList[i] = item
	-- end

	self.member = child(self.gameObject, "member").gameObject
	self.own = child(self.gameObject, "own").gameObject
	self.content = subComponentGet(self.transform,"member/content", typeof(UILabel))
	self.content0 = subComponentGet(self.transform,"member/content0", typeof(UILabel))
	local closeBtn = child(self.gameObject, "closeBtn").gameObject
	addClickCallbackSelf(closeBtn, self.OnCloseClick, self)
	local exitBtn = child(self.gameObject, "member/exitBtn").gameObject
	addClickCallbackSelf(exitBtn, self.OnExitClubClick, self)
	local exitBtn = child(self.gameObject, "own/tixiantBtn").gameObject
	addClickCallbackSelf(exitBtn, self.tixiantBtnClick, self)
end

function ClubManageView:OnCloseClick()
	self:OnClose();
end

function ClubManageView:OnExitClubClick()
	--self.gameObject:SetActive(false)
	self.model:ReqQuitClub(self.clubInfo.cid)
end

function ClubManageView:tixiantBtnClick()
	ui_sound_mgr.PlaySoundClip("common/audio_button_click")
	local nameInput = subComponentGet(self.transform,"own/nameInput", typeof(UIInput))
	if nameInput.value == "" then
		fast_tip.Show("请输入姓名")
		return
	end
	local bankInput = subComponentGet(self.transform,"own/bankInput", typeof(UIInput))
	if bankInput.value == "" or not tonumber(bankInput.value) or tonumber(bankInput.value) < 100000000000 then
		fast_tip.Show("请输入正确的银行卡号")
		return
	end
	local branchBankInput = subComponentGet(self.transform,"own/branchBankInput", typeof(UIInput))
	if branchBankInput.value == "" then
		fast_tip.Show("请输入正确的银行分行")
		return
	end
	local phoneInput = subComponentGet(self.transform,"own/phoneInput", typeof(UIInput))
	if phoneInput.value == "" or not tonumber(phoneInput.value) or tonumber(phoneInput.value) < 10000000000 then
		fast_tip.Show("请输入正确的手机号码")
		return
	end
	local moneyNumInput = subComponentGet(self.transform,"own/moneyNumInput", typeof(UIInput))
	if moneyNumInput.value == "" or not tonumber(moneyNumInput.value) or tonumber(moneyNumInput.value) < 9 then
		fast_tip.Show("请输入正确的提现金额")
		return
	end
	self.model:exchangeClub(nameInput.value, bankInput.value,branchBankInput.value,phoneInput.value,moneyNumInput.value, 3, function(msg)
		if msg.ret == 0 then
			fast_tip.Show("提交成功,请等待管理员审核")
		else
			fast_tip.Show(msg.msg)
		end	
	end)
end

function ClubManageView:OnItemClick(item)
	local cfgS = self.clubInfo.cfg
	local key = cfg[item.index][4]
	local value = 0

	local oldValueTab = {}
	oldValueTab[1] = self.clubInfo.cid
	if cfgS ~= nil  then
		oldValueTab[2] = cfgS.public or 0
		oldValueTab[3] = cfgS.allcosthost or 0
		oldValueTab[4] = cfgS.mcactuser or 0
		oldValueTab[5] = cfgS.mcosthost or 0
		value = cfgS[key] or 0
	else
		oldValueTab[2] = 0
		oldValueTab[3] = 0
		oldValueTab[4] = 0
		oldValueTab[5] = 0
	end

	if value == 1 then
		oldValueTab[item.index + 1] = 0
		self.model:ReqSetClubConfig(unpack(oldValueTab))
	else
		oldValueTab[item.index + 1] = 1
		MessageBox.ShowYesNoBox("文字丢了",--LanguageMgr.GetWord(cfg[item.index][3], self.clubInfo.cname), 
			function()
				self.model:ReqSetClubConfig(unpack(oldValueTab))
			end)
	end
end




function ClubManageView:OnOpen()
	log("ClubManageView:OnOpen")
	self.gameObject:SetActive(true)
end

function ClubManageView:OnClose()
	self.gameObject:SetActive(false)
	log("ClubManageView:OnClose")
end

function ClubManageView:RegistEvent()
	Notifier.regist(GameEvent.OnClubInfoUpdate, self.RefreshView, self)
end

function ClubManageView:RemoveEvent()
	Notifier.remove(GameEvent.OnClubInfoUpdate, self.RefreshView, self)
end

return ClubManageView