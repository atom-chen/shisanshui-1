--local LibBase = import(".lib_base")
--package.cpath = package.cpath .. ";" .. "../script_thirteen/clib/myLualib.so"
--local LibSpCardLogic = class("LibSpCardLogic", LibBase)
--local card_algrithm_test = require "card_algrithm_test"

LibSpCardLogic = {}
function LibSpCardLogic:ctor()
end

function LibSpCardLogic:CreateInit(strSlotName)
    return true
end

function LibSpCardLogic:OnGameStart()
end

--获取特殊牌型
function LibSpCardLogic:GetSpecialType(cards)
    if #cards ~= MAX_HAND_CARD_NUM then
        return GStars_Special_Type.PT_SP_NIL
    end
    local tempCards = Array.Clone(cards)

    --1.把癞子牌和普通牌分离
    local normalCards = {}
    local laiziCards = {}
    local deliveryCards = {}
    for _, v in ipairs(tempCards) do
        local nValue = GetCardValue(v)
        if LibLaiZi:IsLaiZi(nValue) then
            table.insert(laiziCards, v)
        else
            table.insert(normalCards, v)
            table.insert(deliveryCards, v)
        end
    end

    table.insert(deliveryCards, #laiziCards)
--    ("before test ---: %s\n", TableToString(deliveryCards))
    local result = card_algrithm_test.get_special_cards_type(deliveryCards)
--    ("after test result---: %d\n", result)
    if result == 0 then
        return GStars_Special_Type.PT_SP_NIL
    elseif result == 15 then
        return GStars_Special_Type.PT_SP_STRAIGHT_FLUSH
    elseif result == 14 then
        return GStars_Special_Type.PT_SP_STRAIGHT
    elseif result == 13 then
        return GStars_Special_Type.PT_SP_FOUR_THREE
    elseif result == 12 then
        return GStars_Special_Type.PT_SP_THREE_BOMB
    elseif result == 11 then
        return GStars_Special_Type.PT_SP_FIVE_AND_THREE_KING
    elseif result == 10 then
        return GStars_Special_Type.PT_SP_ALL_KING
    elseif result == 9 then
        return GStars_Special_Type.PT_SP_THREE_STRAIGHT_FLUSH
    elseif result == 8 then
        return GStars_Special_Type.PT_SP_SIX
    elseif result == 7 then
        return GStars_Special_Type.PT_SP_ALL_BIG
    elseif result == 6 then
        return GStars_Special_Type.PT_SP_ALL_SMALL
    elseif result == 5 then
        return GStars_Special_Type.PT_SP_SAME_SUIT
    elseif result == 4 then
        return GStars_Special_Type.PT_SP_FIVE_PAIR_AND_THREE
    elseif result == 3 then
        return GStars_Special_Type.PT_SP_SIX_PAIRS
    elseif result == 2 then
        return GStars_Special_Type.PT_SP_THREE_STRAIGHT
    elseif result == 1 then
        return GStars_Special_Type.PT_SP_THREE_FLUSH
    else
        return GStars_Special_Type.PT_SP_NIL
    end


--[[
    if #cards ~= MAX_HAND_CARD_NUM then
        return GStars_Special_Type.PT_SP_NIL
    end
    local tempCards = Array.Clone(cards)
    ("LibSpCardLogic:GetSpecialType...tempCards:%s",  TableToString(tempCards))

    if self:Check_Pt_Sp_Straight_Flush(tempCards) then
        return GStars_Special_Type.PT_SP_STRAIGHT_FLUSH

    elseif self:Check_Pt_Sp_Straight(tempCards) then
        return GStars_Special_Type.PT_SP_STRAIGHT

    elseif self:Check_Pt_Sp_Four_Three(tempCards) then
        return GStars_Special_Type.PT_SP_FOUR_THREE

    elseif self:Check_Pt_Sp_Three_Bomb(tempCards) then
        return GStars_Special_Type.PT_SP_THREE_BOMB

    elseif self:Check_Pt_Sp_Five_And_Three_King(tempCards) then
        return GStars_Special_Type.PT_SP_FIVE_AND_THREE_KING

    elseif self:Check_Pt_Sp_All_King(tempCards) then
        return GStars_Special_Type.PT_SP_ALL_KING

    elseif self:Check_Pt_Sp_Three_Straight_Flush(tempCards) then
        return GStars_Special_Type.PT_SP_THREE_STRAIGHT_FLUSH

    elseif self:Check_Pt_Sp_Six(tempCards) then
        return GStars_Special_Type.PT_SP_SIX

    elseif self:Check_Pt_Sp_All_Big(tempCards) then
        return GStars_Special_Type.PT_SP_ALL_BIG

    elseif self:Check_Pt_Sp_All_Small(tempCards) then
        return GStars_Special_Type.PT_SP_ALL_SMALL

    elseif self:Check_Pt_Sp_Same_Suit(tempCards) then
        return GStars_Special_Type.PT_SP_SAME_SUIT

    elseif self:Check_Pt_Sp_Five_Pair_And_Three(tempCards) then
        return GStars_Special_Type.PT_SP_FIVE_PAIR_AND_THREE

    elseif self:Check_Pt_Sp_Six_Pairs(tempCards) then
        return GStars_Special_Type.PT_SP_SIX_PAIRS

    elseif self:Check_Pt_Sp_Three_Straight(tempCards) then
        return GStars_Special_Type.PT_SP_THREE_STRAIGHT

    elseif self:Check_Pt_Sp_Three_Flush(tempCards) then
        return GStars_Special_Type.PT_SP_THREE_FLUSH

    else
        return GStars_Special_Type.PT_SP_NIL
    end
    --]]
end

--=========下面是特殊牌型判断================
--[[
--至尊清龙
function LibSpCardLogic:Check_Pt_Sp_Straight_Flush(cards)
   assert(#cards == MAX_HAND_CARD_NUM)
    if LibLaiziCardLogic:IsFlush_Laizi(cards) and LibLaiziCardLogic:IsStraight_Laizi(cards) then
        return true
    end
    return false
end

--一条龙
function LibSpCardLogic:Check_Pt_Sp_Straight(cards)
    assert(#cards == MAX_HAND_CARD_NUM)
    if LibLaiziCardLogic:IsStraight_Laizi(cards) then
        return true
    end
    return false    
end

--四套三条  4个3条
function LibSpCardLogic:Check_Pt_Sp_Four_Three(cards)
    --assert(#cards == MAX_HAND_CARD_NUM)
    local values = {}
    for i=2, 14 do
        values[i] = 0
    end

    for _, v in ipairs(cards) do
        local val = GetCardValue(v)
        ("Check_Pt_Sp_Four_Three...val:%d", val)
        values[val] = values[val] + 1
    end

    local count = 0
    for _, v in pairs(values) do
        if v >= 3 then
            count = count + 1
        end
    end
    if count == 4 then
        return true
    end
    return false
end

--三炸弹   3个铁枝
function LibSpCardLogic:Check_Pt_Sp_Three_Bomb(cards)
    --assert(#cards == MAX_HAND_CARD_NUM)
    local values = {}
    for i=2, 14 do
        values[i] = 0
    end

    for _, v in ipairs(cards) do
        local val = GetCardValue(v)
        ("Check_Pt_Sp_Three_Bomb...val:%d", val)
        values[val] = values[val] + 1
    end

    local count = 0
    for _, v in pairs(values) do
        if v >= 4 then
            count = count + 1
        end
    end
    if count == 3 then
        return true
    end
    return false
end

--三皇五帝 2个5同+3条
function LibSpCardLogic:Check_Pt_Sp_Five_And_Three_King(cards)
    --assert(#cards == MAX_HAND_CARD_NUM)
    local values = {}
    for i=2, 14 do
        values[i] = 0
    end

    for _, v in ipairs(cards) do
        local val = GetCardValue(v)
        ("Check_Pt_Sp_Five_And_Three_King...val:%d", val)
        values[val] = values[val] + 1
    end

    local count5, count3 = 0, 0
    for _, v in pairs(values) do
        if v >= 5 then
            count5 = count5 + 1
        end
        if v == 3 then
            count3 = count3 + 1
        end
    end
    if count5 == 2 and count3 == 1 then
        return true
    end
    return false
end

--十二皇族 12张牌全是J、Q、K、A，剩余一张可以是任意牌
function LibSpCardLogic:Check_Pt_Sp_All_King(cards)
    --assert(#cards == MAX_HAND_CARD_NUM)
    local count = 0
    for _,v in ipairs(cards) do
        local value = GetCardValue(v)
        if value < 11 then  --比J小
            count = count + 1
            if count >= 2 then
                return false
            end
        end
    end

    -- for _,v in ipairs(cards) do
    --     local value = GetCardValue(v)
    --     if value < 11 then  --比J小
    --         return false
    --     end
    -- end
    return true
end

--三同花顺
function LibSpCardLogic:Check_Pt_Sp_Three_Straight_Flush(cards)
    --assert(#cards == MAX_HAND_CARD_NUM)
    --出现三同花顺时，各花色数量只能为0,3,5,8,10,13(当等于13时为一条龙)
    --先按花色排序
    local flush = {}
    LibNormalCardLogic:Sort_By_Color(cards)
    --按花色分组
    for k, v in ipairs(cards) do
        local color = GetCardColor(v)
        if not flush[color] then
            flush[color] = {}
        end
        table.insert(flush[color], v)
    end

    for _, v in pairs(flush) do
        if not (#v == 0 or #v == 3 or #v == 5 or #v == 8 or #v == 10 or #v == 13) then
            return false
        end
        if #v == 3 or #v == 5 then
            if not LibNormalCardLogic:IsStraight(v) then
                return false
            end
        end

        if #v == 8 or #v == 10 then
            local pass1, pass2, pass3 = false, false, false
            --情况1 普通顺子
            local tempCards = Array.Clone(v)
            --1.先取一个顺子
            local bSuc, _ = LibNormalCardLogic:Get_Max_Pt_Straight_Normal(tempCards)
            --2.是顺子，再判断剩下的是否是顺子
            if bSuc and LibNormalCardLogic:IsStraight(tempCards) then
                pass1 = true
            end

            --情况2 A5432
            local tempCards = Array.Clone(v)
            local bSuc, _ = LibNormalCardLogic:Get_Max_Pt_Straight_A(tempCards, 5)
            if bSuc and LibNormalCardLogic:IsStraight(tempCards) then
                pass2 = true
            end

            --情况3 A32
            if #v == 8 then
                local tempCards = Array.Clone(v)
                local bSuc, _ = LibNormalCardLogic:Get_Max_Pt_Straight_A(tempCards, 3)
                if bSuc and LibNormalCardLogic:IsStraight(tempCards) then
                    pass3 = true
                end
            end
            
            --必须要满足以上中的一种
            if not (pass1 or pass2 or pass3) then
                return false
            end 
        end
    end
    return true
end

--六六大顺  6同
function LibSpCardLogic:Check_Pt_Sp_Six(cards)
    --assert(#cards == MAX_HAND_CARD_NUM)
    local values = {}
    for i=2, 14 do
        values[i] = 0
    end

    for _, v in ipairs(cards) do
        local val = GetCardValue(v)
        ("Check_Pt_Sp_Six...val:%d", val)
        values[val] = values[val] + 1
    end

    local count = 0
    for _, v in pairs(values) do
        if v == 6 then
            count = count + 1
        end
    end
    if count >= 1 then
        return true
    end
    return false
end

--全大
function LibSpCardLogic:Check_Pt_Sp_All_Big(cards)
    --assert(#cards == MAX_HAND_CARD_NUM)
       --1.把癞子牌和普通牌分离
    local normalCards = {}
    local laiziCards = {}
    for _, v in ipairs(cards) do
        local nValue = GetCardValue(v)
        if LibLaiZi:IsLaiZi(nValue) then
            table.insert(laiziCards, v)
        else
            table.insert(normalCards, v)
        end
    end
    for _,v in ipairs(cards) do
        local value = GetCardValue(v)
        if value < 8 then  --比8小
            return false
        end
    end
    return true
end

--全小
function LibSpCardLogic:Check_Pt_Sp_All_Small(cards)
    --assert(#cards == MAX_HAND_CARD_NUM)
    --1.把癞子牌和普通牌分离
    local normalCards = {}
    local laiziCards = {}
    for _, v in ipairs(cards) do
        local nValue = GetCardValue(v)
        if LibLaiZi:IsLaiZi(nValue) then
            table.insert(laiziCards, v)
        else
            table.insert(normalCards, v)
        end
    end
    for _,v in ipairs(normalCards) do
        local value = GetCardValue(v)
        if value > 8 then  --比8大
            return false
        end
    end
    return true
end

--凑一色 13张是黑色牌(梅花+黑桃) 或 是红色牌(方块+红心)
function LibSpCardLogic:Check_Pt_Sp_Same_Suit(cards)
    --assert(#cards == MAX_HAND_CARD_NUM)
    --1.把癞子牌和普通牌分离
    local normalCards = {}
    local laiziCards = {}
    for _, v in ipairs(cards) do
        local nValue = GetCardValue(v)
        if LibLaiZi:IsLaiZi(nValue) then
            table.insert(laiziCards, v)
        else
            table.insert(normalCards, v)
        end
    end
    local color1 = (bit.brshift(GetCardColor(normalCards[1]), 4)) % 2
    for _, v in pairs(normalCards) do
        local color2 = (bit.brshift(GetCardColor(v), 4)) % 2
        if color1 ~= color2 then
            return false
        end
    end
    return true
end

--五队冲三 5对+3条
function LibSpCardLogic:Check_Pt_Sp_Five_Pair_And_Three(cards)
    --assert(#cards == MAX_HAND_CARD_NUM)
    local values = {}
    for i=2, 14 do
        values[i] = 0
    end

    for _, v in ipairs(cards) do
        local val = GetCardValue(v)
        ("Check_Pt_Sp_Five_Pair_And_Three...val:%d", val)
        values[val] = values[val] + 1
    end

    local two, three = 0, 0
    for _, v in pairs(values) do
        if v == 2 then
            two = two + 1
        elseif v == 3 then
            three = three + 1
        end
    end
    if two == 5 and three == 1 then
        return true
    end
    return false
end

--六对半   6对+散牌
function LibSpCardLogic:Check_Pt_Sp_Six_Pairs(cards)
    --assert(#cards == MAX_HAND_CARD_NUM)
    local values = {}
    for i=2, 14 do
        values[i] = 0
    end

    for _, v in ipairs(cards) do
        local val = GetCardValue(v)
        ("Check_Pt_Sp_Six_Pairs...val:%d", val)
        values[val] = values[val] + 1
    end

    local count = 0
    for _, v in pairs(values) do
        --四条 算两对
        if v == 4 then
            count = count + 2
        end
        --对子 三条 算一对
        if v == 2 or v == 3 then
            count = count + 1
        end
    end

    if count == 6 then
        return true
    end
    return false
end

--三顺子
function LibSpCardLogic:Check_Pt_Sp_Three_Straight(cards)
    --assert(#cards == MAX_HAND_CARD_NUM)

    --根据牌值的数量 来不停的挖空 为0就不能组成顺子，因为没有那张牌
    local function Find_All_Straight(values)
        local t = {}
        --双层循环遍历 判断是否是顺子
        --找所有能组成顺子 A2345,23456。。。10JQKA
        for i=1, 10 do
            local straight = true
            for j=1, 5 do
                if values[i+j-1] == 0 then
                    straight = false
                    break
                end
            end
            --是顺子
            if straight then
                local values2 = Array.Clone(values)
                for k=1, 5 do
                    --数量-1 防止重用
                    values2[i+k-1] = values2[i+k-1] - 1

                    --对A做处理
                    if i + k - 1 == 1 then
                        values2[14] = values2[14] - 1
                    end
                    if i + k - 1 == 14 then
                        values2[1] = values2[1] - 1
                    end
                end

                local found = {}
                -- found.start = i
                found.values = values2
                table.insert(t, found)
            end
        end
        return t
    end

    --设置各个牌值的数量
    local values = {}   --[牌值]=数量
    for i=1, 14 do
        values[i] = 0
    end
    for _, v in ipairs(cards) do
        local val = GetCardValue(v)
        values[val] = values[val] + 1
    end
    values[1] = values[14]

    --第一组顺子
    local pattern1 = Find_All_Straight(values)
    for _, v in ipairs(pattern1) do
        --第二组顺子
        local pattern2 = Find_All_Straight(v.values)
        for _, v2 in ipairs(pattern2) do
            for i=1, 12 do
                local straight = true
                --第三组顺子
                for j=1, 3 do
                    if v2.values[i+j-1] == 0 then
                        straight = false
                        break
                    end
                end
                if straight then
                    return true
                end
            end
        end
    end

    return false
end

--三同花
function LibSpCardLogic:Check_Pt_Sp_Three_Flush(cards)
    --assert(#cards == MAX_HAND_CARD_NUM)
    --出现三同花时，各花色数量只能为0,3,5,8,10,13(当等于13时为一条龙)
    --先按花色排序
    local flush = {}
    LibNormalCardLogic:Sort_By_Color(cards)
    --按花色分组
    for k, v in ipairs(cards) do
        local color = GetCardColor(v)
        if not flush[color] then
            flush[color] = {}
        end
        table.insert(flush[color], v)
    end
    for _, v in pairs(flush) do
        if not (#v == 0 or #v == 3 or #v == 5 or #v == 8 or #v == 10 or #v == 13) then
            return false
        end
    end 
    return true  
end
]]