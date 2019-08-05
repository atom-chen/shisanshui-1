--local LibBase = import(".lib_base")
--local LibNormalCardLogic = class("LibNormalCardLogic", LibBase)
require "logic/shisangshui_sys/card_define"
LibNormalCardLogic = {}
function LibNormalCardLogic:ctor()
end

function LibNormalCardLogic:CreateInit(strSlotName)
    return true
end

function LibNormalCardLogic:OnGameStart()
end

--移除
function LibNormalCardLogic:RemoveCard(srcCards, rmCards)
    if type(srcCards) ~= "table" then
        return
    end
    if type(rmCards) ~= "table" then
        return
    end
    if #srcCards == 0 or #rmCards == 0 then
        return
    end

    for i, v in ipairs(rmCards) do
        --Array.RemoveOne(srcCards, v)
		table.remove(srcCards, i)
    end
end

--按值升序 2-14(A)
function LibNormalCardLogic:Sort(cards)
    -- --LOG_DEBUG("LibNormalCardLogic:Sort..before, cards: %s\n", TableToString(cards))
    if not cards.isSorted then
        table.sort(cards, function(a,b)
            local valueA,colorA = GetCardValue(a), GetCardColor(a)
            local valueB,colorB = GetCardValue(b), GetCardColor(b)
            if valueA == valueB then
                return colorA < colorB
            else
                return valueA < valueB
            end
        end)
        cards.isSorted = true
    end
    -- LOG_DEBUG("LibNormalCardLogic:Sort..end, cards: %s\n", TableToString(cards))
end
--分花色排序 花色相同按值升序
function LibNormalCardLogic:Sort_By_Color(cards)
    -- LOG_DEBUG("LibNormalCardLogic:Sort_By_Color..before, cards: %s\n", TableToString(cards))
    table.sort(cards, function(a,b)
        local valueA,colorA = GetCardValue(a), GetCardColor(a)
        local valueB,colorB = GetCardValue(b), GetCardColor(b)
        if colorA == colorB then
            return valueA < valueB
        else
            return colorA < colorB
        end
    end)
    cards.isSorted = false
    -- LOG_DEBUG("LibNormalCardLogic:Sort_By_Color..end, cards: %s\n", TableToString(cards))
end

--有几张不同点数的牌
function LibNormalCardLogic:Uniqc(cards)
    self:Sort(cards)
    local n, uniq, val = 0, 0, 0
    for _,v in ipairs(cards) do
        val = GetCardValue(v)
        if val ~= uniq then
            uniq = val
            n = n + 1
        end
    end
    return n
end

--是否是同花
function LibNormalCardLogic:IsFlush(cards)
    if #cards == 0 then
        return false
    end
    -- LOG_DEBUG("LibNormalCardLogic:IsFlush.., cards: %s\n", TableToString(cards))

    print("cards[1]--------------------------------------------"..tostring(cards[1]))
    local color = GetCardColor(cards[1])
    for i=2, #cards do
        if color ~= GetCardColor(cards[i]) then
            return false
        end
    end
    return true
end

--是否是顺子
function LibNormalCardLogic:IsStraight(cards)
    self:Sort(cards)
    -- LOG_DEBUG("LibNormalCardLogic:IsStraight.., cards: %s\n", TableToString(cards))

    local v1, vn = GetCardValue(cards[1]), GetCardValue(cards[#cards])
    if v1 ~= 2 and vn ~= 14 then
        --普通顺子
        if vn - v1 ~= #cards - 1 then
            return false
        end

        local tempV1 = v1
        for i=2, #cards do
            local tempV2 = GetCardValue(cards[i])
            if tempV2 - tempV1 ~= 1 then
                return false
            end
            tempV1 = tempV2
        end
        return true
    else
        --2 3 4 5 A
        local tempV1 = v1
        for i=2, #cards-1 do
            local tempV2 = GetCardValue(cards[i])
            if tempV2 - tempV1 ~= 1 then
                return false
            end
            tempV1 = tempV2
        end
        return true
    end
end

--各墩牌的类型
function LibNormalCardLogic:GetCardType(cards)
    local cardType = GStars_Normal_Type.PT_ERROR
    local tempCards = LibNormalCardLogic:clone(cards)
    --LOG_DEBUG("LibNormalCardLogic:GetCardType.., cards: %s\n", TableToString(cards))

    if #tempCards == 3 then
        --前墩
        local n = self:Uniqc(tempCards)
        if n == 1 then
            cardType = GStars_Normal_Type.PT_THREE
        elseif n == 2 then
            cardType = GStars_Normal_Type.PT_ONE_PAIR
        elseif n == 3 then
            cardType = GStars_Normal_Type.PT_SINGLE
        else
            cardType = GStars_Normal_Type.PT_ERROR
        end
    elseif #tempCards == 5 then
        --中墩 后墩
        local bFlush = self:IsFlush(tempCards)
        local bStraight = self:IsStraight(tempCards)
        if bFlush then
            --判断是否是同花顺
            if bStraight then
                cardType = GStars_Normal_Type.PT_STRAIGHT_FLUSH
            else
                cardType = GStars_Normal_Type.PT_FLUSH
            end
        elseif bStraight then
            cardType = GStars_Normal_Type.PT_STRAIGHT
        else
            local n = self:Uniqc(tempCards)
            if n == 1 then
                cardType = GStars_Normal_Type.PT_FIVE
            elseif n == 2 then
                local v1 = GetCardValue(tempCards[1])
                local v2 = GetCardValue(tempCards[2])
                local v4 = GetCardValue(tempCards[4])
                local v5 = GetCardValue(tempCards[5])
                if v1 == v2 and v4 == v5 then
                    cardType = GStars_Normal_Type.PT_FULL_HOUSE
                else
                    cardType = GStars_Normal_Type.PT_FOUR
                end
            elseif n == 3 then
                local v1 = GetCardValue(tempCards[1])
                local v2 = GetCardValue(tempCards[2])
                local v3 = GetCardValue(tempCards[3])
                local v4 = GetCardValue(tempCards[4])
                local v5 = GetCardValue(tempCards[5])
                if v1 == v3 or v2 == v4 or v3 == v5 then
                    cardType = GStars_Normal_Type.PT_THREE
                else
                    cardType = GStars_Normal_Type.PT_TWO_PAIR
                end
            elseif n == 4 then
                cardType = GStars_Normal_Type.PT_ONE_PAIR
            elseif n == 5 then
                cardType = GStars_Normal_Type.PT_SINGLE
            else
                cardType = GStars_Normal_Type.PT_ERROR
            end
        end
    else
        cardType = GStars_Normal_Type.PT_ERROR
    end

    --LOG_DEBUG("LibNormalCardLogic:GetCardType.., cardType: %d\n", cardType)
    return cardType
end

--普通牌型比牌
function LibNormalCardLogic:CompareCards(cardsA, cardsB)
    --LOG_DEBUG("LibNormalCardLogic:CompareCards.., cardsA: %s, cardsB: %s\n", TableToString(cardsA), TableToString(cardsB))
    local tempA = LibNormalCardLogic:clone(cardsA)
    local tempB = LibNormalCardLogic:clone(cardsB)
    local type1 = self:GetCardType(tempA)
    local type2 = self:GetCardType(tempB)
    --LOG_DEBUG("LibNormalCardLogic:CompareCards.., type1: %d, type1: %d\n", type1, type2)

    if type1 == type2 then
        if type1 == GStars_Normal_Type.PT_ONE_PAIR then
            local p1 = self:GetPairValue(tempA)
            local p2 = self:GetPairValue(tempB)
            if p1 ~= p2 then
                return p1 - p2
            end

        elseif type1 == GStars_Normal_Type.PT_TWO_PAIR then
            --先比较大对子，大对子相等比较小对子
            local pa1, pb1 = self:GetPairValue(tempA)
            local pa2, pb2 = self:GetPairValue(tempB)
            local n = pb1 - pb2
            if n == 0 then
                n = pa1 - pa2
            end
            if n ~= 0 then
                return n
            end

        elseif type1 == GStars_Normal_Type.PT_THREE
            or type1 == GStars_Normal_Type.PT_FULL_HOUSE
            or type1 == GStars_Normal_Type.PT_FOUR then
            --只需要比较中间这张牌
            local p1 = GetCardValue(tempA[3])
            local p2 = GetCardValue(tempB[3])
            if p1 ~= p2 then
                return p1 - p2
            end
        elseif type1 == GStars_Normal_Type.PT_FLUSH then
            --水庄 比较对同花
--            if GGameCfg.GameSetting.bSupportWaterBanker then
                local pa1, pb1 = self:GetPairValue(tempA)
                local pa2, pb2 = self:GetPairValue(tempB)
                --先比大对子  再比小对 最后比单张大小
                local n = pb1 - pb2
                if n == 0 then
                    n = pa1 - pa2
                end
                --LOG_DEBUG("flush compare,  n= %d", n)
                if n ~= 0 then
                    return n
 --               end 
            end
        end
        --比单张
        return self:CompareSingle(tempA, tempB)
    else
        return type1 - type2
    end
end

--返回值0表示没对子, 值是按从小到大返回的
function LibNormalCardLogic:GetPairValue(cards)
    self:Sort(cards)
    local ret = {}
    local tempVal = nil
    for _, v in ipairs(cards) do
        local val = GetCardValue(v)
        if tempVal == val and ret[#ret] ~= val then
            table.insert(ret, val)
        else
            tempVal = val
        end
    end

    --LOG_DEBUG("LibNormalCardLogic:GetPairValue..ret: %s\n", vardump(ret))
    --return table.unpack(ret)
    return (ret[1] or 0), (ret[2] or 0)
end

--比较散牌：从大到小 一对一比较
function LibNormalCardLogic:CompareSingle(cardsA, cardsB)
    if #cardsA == 0 and #cardsB == 0 then
        return 0
    elseif #cardsA == 0 then
        return -1
    elseif #cardsB == 0 then
        return 1
    end

    self:Sort(cardsA)
    self:Sort(cardsB)

    local va = GetCardValue(cardsA[#cardsA])
    local vb = GetCardValue(cardsB[#cardsB])
    local n = va - vb
    if n ~= 0 then
        return n
    else
        table.remove(cardsA)
        table.remove(cardsB)
        return self:CompareSingle(cardsA, cardsB) 
    end
end

--特殊牌型比牌
function LibNormalCardLogic:CompareSpecialType(spTypeA, spTypeB)
end





--==================配牌库 普通牌型=========================
--获取最大5张牌
function LibNormalCardLogic:GetMaxFiveCard(cards)
    --LOG_DEBUG("LibNormalCardLogic:GetMaxFiveCard..before, cards: %s\n", TableToString(cards))

    if #cards < 5 then
        LOG_ERROR(" LibNormalCardLogic:GetMaxFiveCard Failed.Card is not enough %d", #cards);
        return nil
    end
    --5同
    local suc, t = self:Get_Max_Pt_Five(cards)
    if suc then
        return t
    end

    --同花顺
    local suc, t = self:Get_Max_Pt_Straight_Flush(cards)
    if suc then
        return t
    end

    --铁枝
    local suc, t = self:Get_Max_Pt_Four(cards)
    if suc then
        local _, tempCard = self:Get_Max_Pt_Single(cards)
        table.insert(t, tempCard)
        return t
    end

    --葫芦
    local suc, t = self:Get_Max_Pt_Full_Hosue(cards)
    if suc then
        return t
    end

    --同花
    local suc, t = self:Get_Max_Pt_Flush(cards)
    if suc then
        return t
    end

    --顺子
    local suc, t = self:Get_Max_Pt_Straight(cards)
    if suc then
        return t
    end

    --三条
    local suc, t = self:Get_Max_Pt_Three(cards)
    if suc then
        for i=1, 2 do
            local _, tempCard = self:Get_Max_Pt_Single(cards)
            table.insert(t, tempCard)
        end
        return t
    end

    --两对
    local suc, t = self:Get_Max_Pt_Two_Pair(cards)
    if suc then
        local _, tempCard = self:Get_Max_Pt_Single(cards)
        table.insert(t, tempCard)
        return t
    end

    --一对
    local suc, t = self:Get_Max_Pt_One_Pair(cards)
    if suc then
        for i=1, 3 do
            local _, tempCard = self:Get_Max_Pt_Single(cards)
            table.insert(t, tempCard)
        end
        return t
    end

    --乌龙
    local t = {}
    for i=1, 5 do
        local _, tempCard = self:Get_Max_Pt_Single(cards)
        table.insert(t, tempCard)
    end

    --LOG_DEBUG("LibNormalCardLogic:GetMaxFiveCard..end, cards: %s\n", TableToString(cards))
    --LOG_DEBUG("LibNormalCardLogic:GetMaxFiveCard..get table t: %s\n", TableToString(t))
    return t
end

--获取最大3张牌
function LibNormalCardLogic:GetMaxThreeCard(cards)
    --LOG_DEBUG("LibNormalCardLogic:GetMaxThreeCard..before, cards: %s\n", TableToString(cards))
    if #cards < 3 then
        LOG_ERROR(" LibNormalCardLogic:GetMaxThreeCard Failed.Card is not enough %d", #cards);
        return nil
    end
    --三条
    local suc, t = self:Get_Max_Pt_Three(cards)
    if suc then
        return t
    end

    --一对
    local suc, t = self:Get_Max_Pt_One_Pair(cards)
    if suc then
        local _, tempCard = self:Get_Max_Pt_Single(cards)
        table.insert(t, tempCard)
        return t
    end

    --乌龙
    local t = {}
    for i=1, 3 do
        local _, tempCard = self:Get_Max_Pt_Single(cards)
        table.insert(t, tempCard)
    end

    --LOG_DEBUG("LibNormalCardLogic:GetMaxThreeCard..end, cards: %s\n", TableToString(cards))
    --LOG_DEBUG("LibNormalCardLogic:GetMaxThreeCard..get table t: %s\n", TableToString(t))
    return t
end

--====下面是配牌函数=========
--5同
function LibNormalCardLogic:Get_Max_Pt_Five(cards)
    --LOG_DEBUG("Get_Max_Pt_Five..before, cards: %s\n", TableToString(cards))
    if (type(cards) ~= "table") then
        return false
    end
    if #cards < 5 then
        return false
    end
    self:Sort(cards)

    for i = #cards - 4, 1 , -1 do
        local v1 = GetCardValue(cards[i])
        local v2 = GetCardValue(cards[i+1])
        local v3 = GetCardValue(cards[i+2])
        local v4 = GetCardValue(cards[i+3])
        local v5 = GetCardValue(cards[i+4])

        if v1 == v2 and v1 == v3 and v1 == v4 and v1 == v5 then
            local t = {}
            for k=1,5 do
                table.insert(t,table.remove(cards,i))
            end
            --LOG_DEBUG("Get_Max_Pt_Five..end, cards: %s\n", TableToString(cards))
            --LOG_DEBUG("Get_Max_Pt_Five..get table t: %s\n", TableToString(t))
            return true, t
        end
    end
    return false
end

--同花顺
function LibNormalCardLogic:Get_Max_Pt_Straight_Flush(cards)
    --LOG_DEBUG("Get_Max_Pt_Straight_Flush..before, cards: %s\n", TableToString(cards))
    if (type(cards) ~= "table") then
        return false
    end
    if #cards < 5 then
        return false
    end
    --先按花色排序
    local flush = {}
    self:Sort_By_Color(cards)
    --按花色分组
    for k, v in ipairs(cards) do
        local color = GetCardColor(v)
        if not flush[color] then
            flush[color] = {}
        end
        table.insert(flush[color], v)
    end
    --
    local bFound = false
    local temp = nil
    for _, v in pairs(flush) do
        --LOG_DEBUG("Get_Max_Pt_Straight_Flush..color, cards: %s\n", TableToString(v))
        local bSuc, t = self:Get_Max_Pt_Straight(v)
        if bSuc then
            if temp then
                --比较 找最大的顺子
                local nRet = self:CompareCards(temp, t)
                if nRet < 0 then
                    temp = t
                end
            else
                temp = t
            end
            bFound = true
        end
    end
    if bFound then
        self:RemoveCard(cards, temp)
    end

    --LOG_DEBUG("Get_Max_Pt_Straight_Flush..end, cards: %s\n", TableToString(cards))
    if bFound then
        --LOG_DEBUG("Get_Max_Pt_Straight_Flush..get table t: %s\n", TableToString(temp))
    end

    return bFound, temp
end

--铁枝 (只拿4张相同的 剩下的一张 再处理)
function LibNormalCardLogic:Get_Max_Pt_Four(cards)
    --LOG_DEBUG("Get_Max_Pt_Four..before, cards: %s\n", TableToString(cards))
    if (type(cards) ~= "table") then
        return false
    end
    if #cards < 4 then
        return false
    end
    self:Sort(cards)
    for i = #cards - 3, 1 , -1 do
        local v1 = GetCardValue(cards[i])
        local v2 = GetCardValue(cards[i+1])
        local v3 = GetCardValue(cards[i+2])
        local v4 = GetCardValue(cards[i+3])

        if v1 == v2 and v1 == v3 and v1 == v4 then
            local t = {}
            for k=1,4 do
                table.insert(t,table.remove(cards,i))
            end
            --LOG_DEBUG("Get_Max_Pt_Four..end, cards: %s\n", TableToString(cards))
            --LOG_DEBUG("Get_Max_Pt_Four..get table t: %s\n", TableToString(t))
            return true, t
        end
    end
    return false
end

--葫芦
function LibNormalCardLogic:Get_Max_Pt_Full_Hosue(cards)
    --LOG_DEBUG("Get_Max_Pt_Full_Hosue..before, cards: %s\n", TableToString(cards))
    if (type(cards) ~= "table") then
        return false
    end
    if #cards < 5 then
        return false
    end
    -- 3+2
    local tempCards = LibNormalCardLogic:clone(cards)
    local bSuc1 = self:Get_Max_Pt_Three(tempCards)
    local bSuc2 = false
    if bSuc1 then
        bSuc2 = self:Get_Max_Pt_One_Pair(tempCards)
    end
    if bSuc1 and bSuc2 then
        local bSuc1, c1 = self:Get_Max_Pt_Three(cards)
        local bSuc2, c2 = self:Get_Max_Pt_One_Pair(cards)
        for _, v in ipairs(c2) do
            table.insert(c1, v)
        end
        --LOG_DEBUG("Get_Max_Pt_Full_Hosue..end, cards: %s\n", TableToString(cards))
        --LOG_DEBUG("Get_Max_Pt_Full_Hosue..get table t: %s\n", TableToString(c1))
        return true, c1
    end
    return false
end

--同花
function LibNormalCardLogic:Get_Max_Pt_Flush(cards)
    --LOG_DEBUG("Get_Max_Pt_Flush..before, cards: %s\n", TableToString(cards))
    if (type(cards) ~= "table") then
        return false
    end
    if #cards < 5 then
        return false
    end
    --先按花色排序
    local flush = {}
    self:Sort_By_Color(cards)
    --按花色分组
    for k, v in ipairs(cards) do
        local color = GetCardColor(v)
        if not flush[color] then
            flush[color] = {}
        end
        table.insert(flush[color], v)
    end
    --再遍历找同花
    local bFound = false
    local t = {}
    for _, v in pairs(flush) do
        local len = #v
        if len >= 5 then
            table.insert(t, v[len])
            table.insert(t, v[len-1])
            table.insert(t, v[len-2])
            table.insert(t, v[len-3])
            table.insert(t, v[len-4])
            bFound = true
            break
        end
    end
    if bFound then
        self:RemoveCard(cards, t)
    end  

    --LOG_DEBUG("Get_Max_Pt_Flush..end, cards: %s\n", TableToString(cards))
    if bFound then
        --LOG_DEBUG("Get_Max_Pt_Flush..get table t: %s\n", TableToString(t))
    end  

    return bFound, t
end

--顺子 10JQKA > A2345 > 910JQK > ...> 23456
function LibNormalCardLogic:Get_Max_Pt_Straight(cards)
    --LOG_DEBUG("Get_Max_Pt_Straight..before, cards: %s\n", TableToString(cards))
    if (type(cards) ~= "table") then
        return false
    end
    if #cards < 5 then
        return false
    end

    local tempCards = LibNormalCardLogic:clone(cards) 
    local bSuc1, t1 = self:Get_Max_Pt_Straight_Normal(tempCards)
    if bSuc1 and GetCardValue(t1[1]) == 14 then
        --10JQKA
        --LOG_DEBUG("Get_Max_Pt_Straight..end, cards: %s\n", TableToString(cards))
        --LOG_DEBUG("Get_Max_Pt_Straight..get table t1: %s\n", TableToString(t1))
        self:RemoveCard(cards, t1)
        return true, t1
    end

    --2345A
    local tempCards = LibNormalCardLogic:clone(cards) 
    local bSuc2, t2 = self:Get_Max_Pt_Straight_A(tempCards, 5)
    if bSuc2 then
        --LOG_DEBUG("Get_Max_Pt_Straight..end, cards: %s\n", TableToString(cards))
        --LOG_DEBUG("Get_Max_Pt_Straight..get table t2: %s\n", TableToString(t2))
        self:RemoveCard(cards, t2)
        return true, t2
    end

    if bSuc1 then
        --LOG_DEBUG("Get_Max_Pt_Straight..end, cards: %s\n", TableToString(cards))
        --LOG_DEBUG("Get_Max_Pt_Straight..get table t3: %s\n", TableToString(t1))
        self:RemoveCard(cards, t1)
        return true, t1
    end

    --LOG_DEBUG("Get_Max_Pt_Straight..end, cards: %s\n", TableToString(cards))
    return false
end

--普通顺子 不包括A2345
function LibNormalCardLogic:Get_Max_Pt_Straight_Normal(cards)
    --LOG_DEBUG("Get_Max_Pt_Straight_Normal..before, cards: %s\n", TableToString(cards))
    if (type(cards) ~= "table") then
        return false
    end
    if #cards < 5 then
        return false
    end

    self:Sort(cards)
    --遍历找到能组成顺子的 开始和结束位置
    --24 34 35 26 36 37 18 1D
    local bSuc1 = false
    local t = {}
    local len = #cards
    
    local nLastValue = GetCardValue(cards[len])
    table.insert(t, cards[len])
    for i=len-1, 1, -1 do
        local nValue = GetCardValue(cards[i])
        --值相同则跳过这张牌
        if nLastValue ~= nValue then
            if nLastValue ~= nValue + 1 then
                t = {}
                table.insert(t, cards[i])
            else
                table.insert(t, cards[i])
            end
        end
        nLastValue = nValue
        if #t >= 5 then
            bSuc1 = true
            break
        end
    end
    if bSuc1 then
        --从牌库移除
        self:RemoveCard(cards, t)
    end

    --LOG_DEBUG("Get_Max_Pt_Straight_Normal..end, cards: %s\n", TableToString(cards))
    if bSuc1 then
        --LOG_DEBUG("Get_Max_Pt_Straight_Normal..get table t: %s\n", TableToString(t))
    end

    return bSuc1, t
end

--A2345 顺子中第二大  nFindValue必须填，5则是找A2345, 3则是找A23
function LibNormalCardLogic:Get_Max_Pt_Straight_A(cards, nFindValue)
    --LOG_DEBUG("Get_Max_Pt_Straight_A..before, nFindValue: %d, cards: %s\n", nFindValue, TableToString(cards))
    if (type(cards) ~= "table") then
        return false
    end
    if #cards < 5 then
        return false
    end
    if nFindValue == nil then
        return false
    end

    self:Sort(cards)

    local len = #cards
    if GetCardValue(cards[len]) ~= 14 then
        return false
    end

    local t = {}
    table.insert(t, cards[len])
    for i=len, 1, -1 do
        --找5432
        if nFindValue == GetCardValue(cards[i]) then
            nFindValue = nFindValue - 1
            table.insert(t, cards[i])
            if nFindValue == 1 then
                break
            end
        end
    end
    if nFindValue ~= 1 then
        return false
    end
    if nFindValue ~= 1 then
        return false
    end

    --从牌库移除
    self:RemoveCard(cards, t)

    --LOG_DEBUG("Get_Max_Pt_Straight_A..end, nFindValue: %d, cards: %s\n", nFindValue, TableToString(cards))
    --LOG_DEBUG("Get_Max_Pt_Straight_A..get table nFindValue: %d, t: %s\n", nFindValue, TableToString(t))

    return true, t
end

--3条
function LibNormalCardLogic:Get_Max_Pt_Three(cards)
    --LOG_DEBUG("Get_Max_Pt_Three..before, cards: %s\n", TableToString(cards))
    if (type(cards) ~= "table") then
        return false
    end
    if #cards < 3 then
        return false
    end
    self:Sort(cards)
    for i = #cards - 2, 1 , -1 do
        local v1 = GetCardValue(cards[i])
        local v2 = GetCardValue(cards[i+1])
        local v3 = GetCardValue(cards[i+2])

        if v1 == v2 and v1 == v3 then
            local t = {}
            for k=1,3 do
                table.insert(t,table.remove(cards,i))
            end
            --LOG_DEBUG("Get_Max_Pt_Three..end, cards: %s\n", TableToString(cards))
            --LOG_DEBUG("Get_Max_Pt_Three..get table t: %s\n", TableToString(t))
            return true, t
        end
    end
    --LOG_DEBUG("Get_Max_Pt_Three..end, cards: %s\n", TableToString(cards))
    return false
end

--两对
function LibNormalCardLogic:Get_Max_Pt_Two_Pair(cards)
    --LOG_DEBUG("Get_Max_Pt_Two_Pair..before, cards: %s\n", TableToString(cards))
    if (type(cards) ~= "table") then
        return false
    end
    if #cards < 4 then
        return false
    end
    local tempCards = LibNormalCardLogic:clone(cards)
    local bSuc1 = self:Get_Max_Pt_One_Pair(tempCards)
    local bSuc2 = self:Get_Max_Pt_One_Pair(tempCards)
    if bSuc1 and bSuc2 then
        local bSuc1, c1 = self:Get_Max_Pt_One_Pair(cards)
        local bSuc2, c2 = self:Get_Max_Pt_One_Pair(cards)
        for _, v in ipairs(c2) do
            table.insert(c1, v)
        end
        --LOG_DEBUG("Get_Max_Pt_Two_Pair..end, cards: %s\n", TableToString(cards))
        --LOG_DEBUG("Get_Max_Pt_Two_Pair..get table t: %s\n", TableToString(c1))
        return true, c1
    end
    --LOG_DEBUG("Get_Max_Pt_Two_Pair..end, cards: %s\n", TableToString(cards))
    return false
end

--一对
function LibNormalCardLogic:Get_Max_Pt_One_Pair(cards)
    --LOG_DEBUG("Get_Max_Pt_One_Pair..before, cards: %s\n", TableToString(cards))
    if (type(cards) ~= "table") then
        return false
    end
    if #cards < 2 then
        return false
    end
    self:Sort(cards)
    for i = #cards - 1, 1 , -1 do
        local v1 = GetCardValue(cards[i])
        local v2 = GetCardValue(cards[i+1])

        if v1 == v2 then
            local t = {}
            for k=1,2 do
                table.insert(t,table.remove(cards,i))
            end
            --LOG_DEBUG("Get_Max_Pt_One_Pair..end, cards: %s\n", TableToString(cards))
            --LOG_DEBUG("Get_Max_Pt_One_Pair..get table t: %s\n", TableToString(t))
            return true, t
        end
    end
    --LOG_DEBUG("Get_Max_Pt_One_Pair..end, cards: %s\n", TableToString(cards))
    return false
end

--散牌
function LibNormalCardLogic:Get_Max_Pt_Single(cards)
    --LOG_DEBUG("Get_Max_Pt_Single..before, cards: %s\n", TableToString(cards))
    if (type(cards) ~= "table") then
        return false
    end
    if #cards == 0 then
        return false
    end

    self:Sort(cards)
    return true,table.remove(cards,#cards)
end

function LibNormalCardLogic:clone( object )
    local lookup_table = {}
    local function copyObj( object )
        if type( object ) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs( object ) do
            new_table[copyObj( key )] = copyObj( value )
        end
        return setmetatable( new_table, getmetatable( object ) )
    end
    return copyObj( object )
end

--[[
GStars_Normal_Type = {
    PT_ERROR = 0,
    PT_SINGLE = 1,                          --散牌(乌龙)    
    PT_ONE_PAIR = 2,                        --一对
    PT_TWO_PAIR = 3,                        --两对
    PT_THREE = 4,                           --三条
    PT_STRAIGHT = 5,                        --顺子
    PT_FLUSH = 6,                           --同花
    PT_FULL_HOUSE = 7,                      --葫芦
    PT_FOUR = 8,                            --铁支(炸弹)
    PT_STRAIGHT_FLUSH = 9,                  --同花顺
    PT_FIVE = 10,                           -- 五同
}
--]]
function LibNormalCardLogic:RemoveCardTable(srcCards, rmCards)
    if type(srcCards) ~= "table" then
        return
    end
    if type(rmCards) ~= "table" then
        return
    end
    if #srcCards == 0 or #rmCards == 0 then
        return
    end

    for i = #srcCards, 1 -1 do
        for k, v in ipairs(rmCards) do
			if v == srcCards[i] then
				table.remove(srcCards, i)
			end
		end
    end
	return srcCards
end

function LibNormalCardLogic: Get_All_Card_Type(cards)
	local card_Type = {}
	
	local card_max_tbl = {	[GStars_Normal_Type.PT_FIVE] = self:Get_Max_Pt_Five(cards),
							[GStars_Normal_Type.PT_STRAIGHT_FLUSH] = self:Get_Max_Pt_Straight_Flush(cards),
							[GStars_Normal_Type.PT_FOUR] = self:Get_Max_Pt_Straight_Flush(cards),
							[GStars_Normal_Type.PT_FULL_HOUSE] = self:Get_Max_Pt_Straight_Flush(cards),
							[GStars_Normal_Type.PT_FLUSH] = self:Get_Max_Pt_Straight_Flush(cards),
							[GStars_Normal_Type.PT_STRAIGHT] = self:Get_Max_Pt_Straight_Flush(cards),
							[GStars_Normal_Type.PT_THREE] = self:Get_Max_Pt_Straight_Flush(cards),
							[GStars_Normal_Type.PT_TWO_PAIR] = self:Get_Max_Pt_Straight_Flush(cards),
							[GStars_Normal_Type.PT_ONE_PAIR] = self:Get_Max_Pt_Straight_Flush(cards)}
	
	for i = GStars_Normal_Type.PT_FIVE, 1, -1 do
		local judge temp = card_max_tbl.i(cards)
		if temp ~= nil then
			print("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb")
		end
	end
	if temp ~= nil then
		self:RemoveCardTable(cards, temp)
	end
end