--Void Raging Dragon
local s,id=GetID()
function s.initial_effect(c)
    --xyz summon
    Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(s.ffilter),4,3,s.ovfilter,aux.Stringid(id,0),3,s.xyzop)
    c:EnableReviveLimit()
    --Attach 1 "Raging Dragon" monster from GY when Xyz Summoned
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,1))
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(s.attachcon)
    e1:SetTarget(s.attachtg)
    e1:SetOperation(s.attachop)
    c:RegisterEffect(e1)
    --Negate activation
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,2))
    e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,id)
    e2:SetCondition(s.negcon)
    e2:SetCost(s.negcost)
    e2:SetTarget(s.negtg)
    e2:SetOperation(s.negop)
    c:RegisterEffect(e2)
end

function s.ffilter(c,fc,sumtype,tp)
    return c:IsSetCard(0x7c9,fc,sumtype,tp) and not c:IsCode(id)
end

function s.ovfilter(c,tp,lc)
    return c:IsFaceup() and c:GetRank()==4 and c:IsRace(RACE_DRAGON,lc,SUMMON_TYPE_XYZ,tp)
end

function s.xyzop(e,tp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
    Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
    return true
end

function s.attachcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end

function s.filter(c)
    return c:IsSetCard(0x7c9) and c:IsType(TYPE_MONSTER)
end

function s.attachtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,1,nil) end
end

function s.attachop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
        Duel.Overlay(c,g)
    end
end

function s.negcon(e,tp,eg,ep,ev,re,r,rp)
    return rp==1-tp and Duel.IsChainNegatable(ev)
end

function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end

function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end

function s.negop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end
