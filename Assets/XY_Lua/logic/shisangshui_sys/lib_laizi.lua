-- 加载 slot/change_card
--local LibBase = import(".lib_base")
--local LibLaiZi = class("LibLaiZi", LibBase)
LibLaiZi = {}
function LibLaiZi:ctor()
    --癞子牌值
    self.stLaiZiValues = {} 
end

function LibLaiZi:CreateInit(strSlotName)
    return true
end

function LibLaiZi:OnGameStart()
    self.stLaiZiValues = {}
    --支持鬼牌  就默认加上
    --if GGameCfg.GameSetting.bSupportGhostCard then
        table.insert(self.stLaiZiValues, 15)
    --end
end

function LibLaiZi:GetLaiZiValues()
    return self.stLaiZiValues
end

function LibLaiZi:AddLaiZiValues(nLaiZiValue)
	if self.stLaiZiValues == nil then
		LibLaiZi:OnGameStart()
	end
    if nLaiZiValue > 0  and nLaiZiValue <= 15 then
        table.insert(self.stLaiZiValues, nLaiZiValue)
    end
end

--是否是癞子牌 参数nValue是牌值而不是一张牌
function LibLaiZi:IsLaiZi(nValue)
	if self.stLaiZiValues == nil then
		LibLaiZi:OnGameStart()
	end
    local bRet = false
    for i=1,#self.stLaiZiValues do
        if self.stLaiZiValues[i] == nValue then
            bRet = true
            break
        end
    end
    return bRet
end