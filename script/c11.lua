--Raging Dragon Fusion

local s, id = GetID()

function s.initial_effect(c)
    -- Activate
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0, TIMING_MAIN_END)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end

function s.filter1(c, e)
    return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_DRAGON) and c:IsCanBeFusionMaterial() and c:IsLocation(LOCATION_DECK) and c:IsAbleToGrave()
end

function s.filter2(c, e)
    return c:IsType(TYPE_FUSION) and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_FUSION, PLAYER_NONE, false, false)
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.filter1, tp, LOCATION_DECK, 0, 1, nil, e)
            and Duel.IsExistingMatchingCard(s.filter2, tp, LOCATION_EXTRA, 0, 1, nil, e)
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA)
end

function s.operation(e, tp, eg, ep, ev, re, r, rp)
    local ftg = Duel.SelectMatchingCard(tp, s.filter1, tp, LOCATION_DECK, 0, 1, 1, nil, e):GetFirst()
    if not ftg then return end
    local ftc = Duel.SelectMatchingCard(tp, s.filter2, tp, LOCATION_EXTRA, 0, 1, 1, nil, e):GetFirst()
    if not ftc then return end
    local fmat = Group.FromCards(ftg)
    ftc:SetMaterial(fmat)
    Duel.SendtoGrave(fmat, REASON_EFFECT + REASON_MATERIAL + REASON_FUSION)
    Duel.BreakEffect()
    Duel.SpecialSummon(ftc, SUMMON_TYPE_FUSION, tp, tp, false, false, POS_FACEUP)
end
