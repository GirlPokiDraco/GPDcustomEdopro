-- Raging Dragon Secret Fusion
local s, id = GetID()

function s.initial_effect(c)
    -- Activate
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0, TIMINGS_CHECK_MONSTER_E)
    e1:SetCondition(s.ntcon)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    e1:SetCost(s.cost) -- Aquí se establece el costo
    c:RegisterEffect(e1)
end

function s.fextra(e, tp, mg)
    return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsFaceup), tp, 0, LOCATION_ONFIELD, nil)
end

function s.extratg(e, tp, eg, ep, ev, re, r, rp, chk)
    if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
        Duel.SetChainLimit(aux.FALSE)
    end
end

function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.CheckLPCost(tp, 1000) end -- Costo de 1000 LP
    Duel.PayLPCost(tp, 1000)
end