-- Greed Raging Dragon
local s, id = GetID()

function s.initial_effect(c)
    -- Efecto de devolver al Deck y robar 2 cartas
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_TODECK + CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1, id)
    e1:SetTarget(s.tdrtg)
    e1:SetOperation(s.tdrop)
    c:RegisterEffect(e1)
    local e2 = e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)

    -- Restringir efecto a una vez por turno
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_LIMIT_ONCE)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e3)
end

function s.tdrtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsPlayerCanDraw(tp, 2) and (s.CanReturnToDeck(tp) or s.CanReturnToDeck(tp, true))
    end
    Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 5, PLAYER_ALL, 0)
    Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 2)
end

function s.tdrop(e, tp, eg, ep, ev, re, r, rp)
    local ct = 0
    if s.CanReturnToDeck(tp) then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
        local g = Duel.SelectMatchingCard(tp, s.tdfilter, tp, LOCATION_REMOVED, 0, 5, 5, nil, e, tp)
        if #g > 0 then
            Duel.SendtoDeck(g, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
            ct = #g
        end
    elseif s.CanReturnToDeck(tp, true) then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
        local g = Duel.SelectMatchingCard(tp, s.tdfilter, tp, LOCATION_GRAVE, 0, 5, 5, nil, e, tp)
        if #g > 0 then
            Duel.SendtoDeck(g, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
            ct = #g
        end
    end
    if ct > 0 then
        Duel.ShuffleDeck(tp)
        Duel.BreakEffect()
        Duel.Draw(tp, 2, REASON_EFFECT)
    end
end

function s.tdfilter(c, e, tp)
    return c:IsSetCard(0x7c9) and c:IsAbleToDeck()
end

function s.CanReturnToDeck(tp, removed)
    local loc = removed and LOCATION_REMOVED or LOCATION_GRAVE
    return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsSetCard, 0x7c9), tp, loc, 0, 5, nil)
end