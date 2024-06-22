-- Dragón Furioso Audaz
local s,id=GetID()
function s.initial_effect(c)
    -- Efecto 1: Negar la adición de cartas desde el Deck del adversario a su mano
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DISABLE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.discon)
    e1:SetCost(s.discost)
    e1:SetTarget(s.distg)
    e1:SetOperation(s.disop)
    c:RegisterEffect(e1)
end

function s.discon(e,tp,eg,ep,ev,re,r,rp)
    local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_TOHAND)
    return ex and cp~=tp and Duel.IsChainDisablable(ev)
end

function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDiscardable() end
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end

function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not re:GetHandler():IsStatus(STATUS_DISABLED) end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end

function s.disop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateEffect(ev)
end