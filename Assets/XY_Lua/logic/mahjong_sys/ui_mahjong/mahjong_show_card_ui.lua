-- 吃胡花牌展示界面

local mahjong_show_card_ui = {}
local this = mahjong_show_card_ui

local NGUITools = NGUITools

local TypeEnum = 
{
	none = 0,
	hu = 1,
	chi = 2,
	hua = 3,
	huany = 4, -- 任意牌
}
-- 默认y
local defaultY = -70
local defaultHeight = 144
-- 右对齐起点
local baseX = 440

-- item 宽度
local chiItemWidth = 180
local huaItemWidth = 52
local huItemWidth = 120

local itemHeight = 76

-- 背景额外宽度
local bgWidthExt = 42
local huBgWidthExt = bgWidthExt + 114 + 20
local huaWidthExt = 55


local huMaxColumnNum = 6
local huaMaxColumnNum = 16


function this:SetTransform(transform)
	self.transform = transform
	self.gameObject = transform.gameObject
	self.gameObject:SetActive(true)

	self:InitUI()

	self:UpdateGridGo()
end


function this:InitUI()

	self.currentType = TypeEnum.none
	-- 背景
	self.bgImg = subComponentGet(self.transform, "view", typeof(UISprite))

	self.viewTr = self.bgImg.transform
	self.viewTr.gameObject:SetActive(false)

	-- 胡 图片
	self.huImgGo = child(self.transform, "view/huImg").gameObject
	self.anyCardGo = child(self.transform, "view/anycard").gameObject
	self.anyCardGo:SetActive(false)

	self.huGridGo = child(self.transform, "view/huGrid").gameObject
	self.chiGridGo = child(self.transform, "view/chiGrid").gameObject
	self.huaGridGo = child(self.transform, "view/huaGrid").gameObject

	self.huItemGo = child(self.transform, "view/huGrid/item").gameObject
	self.chiItemGo = child(self.transform, "view/chiGrid/item").gameObject
	self.huaItemGo = child(self.transform, "view/huaGrid/item").gameObject

	self.huItemList = {}
	self.chiItemList = {}
	self.huaItemList = {}

	table.insert(self.huItemList, self.huItemGo)
	table.insert(self.chiItemList, self.chiItemGo)
	table.insert(self.huaItemList, self.huaItemGo)

	self.huBtn = child(self.transform, "huBtn").gameObject
	self.huBtn:SetActive(false)
	addPressedCallbackSelf(self.huBtn.transform, "" ,self.OnHuBtnPressed, self)

	self.maskGo = child(self.transform, "mask").gameObject
	addClickCallbackSelf(self.maskGo, self.Hide, self)

	self.guoBtn = child(self.transform, "guoBtn").gameObject
	addClickCallbackSelf(self.guoBtn, self.OnGuoBtnClick, self)


	addClickCallbackSelf(self.chiItemGo, self.OnChiItemClick, self)

end

function this:OnHuBtnPressed( go, press)
	if not press then
		self:Hide()
	else
		self:ShowHu(roomdata_center.currentTingInfo)
	end
end

function this:OnGuoBtnClick()
	mahjong_play_sys.GiveUp()
	self.currentType = TypeEnum.none
	self:UpdateGridGo()
end

function this:OnChiItemClick(go)
	local idx = 1
	for i = 1, #self.chiItemList do
		if self.chiItemList[i] == go then
			idx = i
			break
		end
	end
	mahjong_play_sys.CollectReq(self.tmpChiCardList[idx])
	self.tmpChiCardList = nil
	self.currentType = TypeEnum.none
	self:Hide()
end




-- 设置grid 的隐藏显示
function this:UpdateGridGo()
	self.huGridGo:SetActive(self.currentType == TypeEnum.hu)
	self.huImgGo:SetActive(self.currentType == TypeEnum.hu or self.currentType == TypeEnum.huany)
	self.maskGo:SetActive(self.currentType == TypeEnum.hu or self.currentType == TypeEnum.huany)
	self.anyCardGo:SetActive(self.currentType == TypeEnum.huany)
	self.chiGridGo:SetActive(self.currentType == TypeEnum.chi)
	self.guoBtn:SetActive(self.currentType == TypeEnum.chi)
	self.huaGridGo:SetActive(self.currentType == TypeEnum.hua)
	self.viewTr.gameObject:SetActive(self.currentType ~= TypeEnum.none)
end




-- 重新排位置
function this:Reposition(gridGo)
	gridGo:GetComponent(typeof(UIGrid)):Reposition()
end


function this:UpdateChildList(itemList, dataList, parent, template, callback)
	local itemCount = #itemList
	local count = #dataList
	if count > itemCount then
		for i = 1, count - itemCount do
			local go = NGUITools.AddChild(parent, template)
			table.insert(itemList, go)
		end
	elseif count < itemCount then
		for i = count, itemCount do
			itemList[i]:SetActive(false)
		end
	end
	for i = 1, count do
		itemList[i]:SetActive(true)
		if callback ~= nil then
			callback(self, itemList[i], dataList[i])
		end
	end

	this:Reposition(parent)
end


-- 暂时不缓存  动态获取组件  如果效率太低 可以考虑缓存组件

function this:CardValueSetter(go, card)
	local sp = subComponentGet(go.transform, "mjIcon", typeof(UISprite))
	if sp ~= nil then
		sp.spriteName = card .. "_hand"
	end
	local isJin = roomdata_center.jin == card
	child(go.transform, "jinIcon").gameObject:SetActive(isJin)
end

function this:ChiValueSetter(go, chiList)
	for i = 1, #chiList do
		local paiTr = child(go.transform, "paiItem" .. i)
		if paiTr ~= nil then
			self:CardValueSetter(paiTr.gameObject, chiList[i])
		end
	end

	addClickCallbackSelf(go, self.OnChiItemClick, self)
end

-- {"nCard":21, "nFan":10, "nLeft":2}
function this:HuValueSetter(go, huInfo)
	local paiTr = child(go.transform, "paiItem")
	self:CardValueSetter(paiTr.gameObject, huInfo.nCard)
	local fanNum = subComponentGet(go.transform, "fanNum", typeof(UILabel))
	if fanNum ~= nil then
		-- $符号 代表番字
		fanNum.text = huInfo.nFan .. "$"
	end

	local leftCardNum = subComponentGet(go.transform, "leftCardNum", typeof(UILabel))
	if leftCardNum ~= nil then
		leftCardNum.text = huInfo.nLeft .. "张"
	end
end

function this:UpdateBgSizeAndPos(x, y, width, height)
	self.viewTr.localPosition = Vector3(x,y,0)
	self.bgImg.width = width
	self.bgImg.height = height or defaultHeight
end

function this:Show()
	self.viewTr.gameObject:SetActive(true)
	self:UpdateGridGo()
end


-- 外部接口

function this:ShowHu(huInfo)
	if huInfo == nil then
		return
	end
	local flag = huInfo[1]
	local width = 0
	local height = 0
	local y = defaultY
	-- 任意牌
	if flag == 1 then
		self.currentType = TypeEnum.huany
		width = 336
		height = defaultHeight
	else
		self.currentType = TypeEnum.hu
		
		self:UpdateChildList(self.huItemList, huInfo[2], self.huGridGo, self.huItemGo, self.HuValueSetter)

		local itemCount = #huInfo[2]
	
		local row = math.ceil(itemCount / huMaxColumnNum) - 1
		height = row * itemHeight + defaultHeight
		y = y + row * itemHeight

		if row > 0 then
			itemCount = huMaxColumnNum
		end
		width = huBgWidthExt + itemCount * huItemWidth
	end
	self:Show()
	self:UpdateBgSizeAndPos(baseX - width, y, width, height)
end

--[{12,3,4}, {33,22,4}]
function this:ShowChi(cardList)
	if cardList == nil or #cardList == 0 then
		return
	end
	self.currentType = TypeEnum.chi
	self:Show()
	self:UpdateChildList(self.chiItemList, cardList, self.chiGridGo, self.chiItemGo, self.ChiValueSetter)
	local width = bgWidthExt * 2 + #cardList * chiItemWidth
	self:UpdateBgSizeAndPos(baseX - width, defaultY, width, defaultHeight)
	self.tmpChiCardList = cardList
	-- self:Reposition(self.chiGridGo)
end

function this:ShowHuBtn(value)
	self.huBtn:SetActive(value)
end

function this:ShowHua(pos, cards, viewSeat)
	if cards == nil or #cards == 0 then
		return
	end
	self.currentType = TypeEnum.hua
	self:Show()
	self:UpdateChildList(self.huaItemList, cards, self.huaGridGo, self.huaItemGo, self.CardValueSetter)

	if viewSeat == 2 and roomdata_center.MaxPlayer() == 2 then
		viewSeat = 3
	end

	local itemCount = #cards
	local row = math.ceil(itemCount / huaMaxColumnNum) - 1
	local diffHeight = row * itemHeight
	local height = diffHeight + defaultHeight

	if row > 0 then
		itemCount = huaMaxColumnNum
	end
	local width = huaWidthExt * 2 + itemCount * huaItemWidth

	local x = 0
	local y = 0
	if viewSeat == 1 then
		x = pos.x - 20
		y = pos.y + 180 + diffHeight
	elseif viewSeat ==2 then
		x = pos.x - width - 60
		y = pos.y + 77
	elseif viewSeat == 3 then
		x = pos.x - 20
		y = pos.y - 20
	elseif viewSeat == 4 then
		x = pos.x + 80
		y = pos.y + 77
	end
	self:UpdateBgSizeAndPos(x ,y ,width, height)
end


function this:Hide()
	self.viewTr.gameObject:SetActive(false)
	self.guoBtn:SetActive(false)
end

function this:HideIfNotChi()
	if self.currentType == TypeEnum.chi then
		return
	end
	this:Hide()
end

return mahjong_show_card_ui


