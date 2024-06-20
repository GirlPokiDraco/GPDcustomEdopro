-- Greed Raging Dragon
local s,id=GetID()
function s.initial_effect(c)
    --shuffle & draw (when summoned)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,1))
    e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,id)
    e1:SetTarget(s.drtg1)
    e1:SetOperation(s.drop1)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    --shuffle & draw (when sent to GY)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
    e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e3:SetCountLimit(1,id+100)
    e3:SetCondition(s.drcon2)
    e3:SetTarget(s.drtg2)
    e3:SetOperation(s.drop2)
    c:RegisterEffect(e3)
end

function s.tdfilter1(c)
    return (c:IsSetCard(0x7c9) or c:IsSetCard(0x7c9)) and c:IsAbleToDeck()
end

function s.tdfilter2(c)
    return c:IsSetCard(0x7c9) and c:IsAbleToDeck()
end

function s.drtg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.IsExistingMatchingCard(s.tdfilter1,tp,LOCATION_GRAVE,0,5,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,5,tp,LOCATION_GRAVE)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end

function s.drop1(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(s.tdfilter1,tp,LOCATION_GRAVE,0,nil)
    if #g>=5 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local sg=g:Select(tp,5,5,nil)
        Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
        Duel.BreakEffect()
        Duel.Draw(tp,2,REASON_EFFECT)
    end
end

function s.drcon2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_EFFECT+REASON_COST) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

function s.drtg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.IsExistingMatchingCard(s.tdfilter2,tp,LOCATION_REMOVED,0,5,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,5,tp,LOCATION_REMOVED)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end

function s.drop2(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(s.tdfilter2,tp,LOCATION_REMOVED,0,nil)
    if #g>=5 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local sg=g:Select(tp,5,5,nil)
        Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
        Duel.BreakEffect()
        Duel.Draw(tp,2,REASON_EFFECT)
    end
end