-- Greed Raging Dragon
local s, id = GetID()
function s.initial_effect(c)
    -- Shuffle & draw
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 1))
    e1:SetCategory(CATEGORY_TODECK + CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY + EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1, id)
    e1:SetTarget(s.drtg)
    e1:SetOperation(s.drop)
    c:RegisterEffect(e1)
    local e2 = e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
end
s.listed_series = {0x7c9}
function s.tdfilter(c, e)
    return c:IsSetCard(0x7c9) and c:IsAbleToDeck() and c:IsCanBeEffectTarget(e)
end
function s.drtg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then return false end
    local tg = Duel.GetMatchingGroup(s.tdfilter, tp, LOCATION_REMOVED, 0, nil, e)
    if chk == 0 then return Duel.IsPlayerCanDraw(tp, 2)
            and aux.SelectUnselectGroup(tg, e, tp, 5, 5, aux.dncheck, 0) end
    local g = aux.SelectUnselectGroup(tg, e, tp, 5, 5, aux.dncheck, 1, tp, HINTMSG_TODECK)
    Duel.SetTargetCard(g)
    Duel.SetOperationInfo(0, CATEGORY_TODECK, g, #g, 0, 0)
    Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 2)
end
function s.drop(e, tp, eg, ep, ev, re, r, rp)
    local tg = Duel.GetTargetCards(e)
    if #tg <= 0 then return end
    Duel.SendtoDeck(tg, nil, 0, REASON_EFFECT)
    local g = Duel.GetOperatedGroup()
    if g:IsExists(Card.IsLocation, 1, nil, LOCATION_DECK) then Duel.ShuffleDeck(tp) end
    local ct = g:FilterCount(Card.IsLocation, nil, LOCATION_DECK + LOCATION_EXTRA)
    if ct > 0 then
        Duel.BreakEffect()
        Duel.Draw(tp, 2, REASON_EFFECT)
    end
end