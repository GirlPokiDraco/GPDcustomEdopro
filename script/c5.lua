-- Dragón Furioso Audaz
local s,id=GetID()
function s.initial_effect(c)
    -- Efecto 1: Negar efectos
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

    -- Efecto 2: Invocación Especial desde el Cementerio como nivel 4 una vez por turno
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,id+100)
    e2:SetTarget(s.sptg2)
    e2:SetOperation(s.spop2)
    c:RegisterEffect(e2)
end

function s.check(ev,re)
    return function(category,checkloc)
        if not checkloc and re:IsHasCategory(category) then return true end
        local ex1,g1,gc1,dp1,dv1=Duel.GetOperationInfo(ev,category)
        local ex2,g2,gc2,dp2,dv2=Duel.GetPossibleOperationInfo(ev,category)
        if not (ex1 or ex2) then return false end
        if category==CATEGORY_DRAW or category==CATEGORY_DECKDES then return true end
        local g=Group.CreateGroup()
        if g1 then g:Merge(g1) end
        if g2 then g:Merge(g2) end
        return (((dv1 or 0)|(dv2 or 0))&LOCATION_DECK)~=0 or (#g>0 and g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK))
    end
end

function s.discon(e,tp,eg,ep,ev,re,r,rp)
    if re:GetHandler():IsDisabled() or not Duel.IsChainDisablable(ev) then return false end
    local checkfunc=s.check(ev,re)
    return checkfunc(CATEGORY_TOHAND,true) or checkfunc(CATEGORY_SPECIAL_SUMMON,true)
        or checkfunc(CATEGORY_TOGRAVE,true) or checkfunc(CATEGORY_DRAW,true) or checkfunc(CATEGORY_DRAW,false)
        or checkfunc(CATEGORY_SEARCH,false) or checkfunc(CATEGORY_DECKDES,true) or checkfunc(CATEGORY_DECKDES,false)
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

function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function s.spop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
        if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
            -- Cambiar el nivel del monstruo invocado a 4
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
            e1:SetRange(LOCATION_MZONE)
            e1:SetCode(EFFECT_CHANGE_LEVEL)
            e1:SetValue(4)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            c:RegisterEffect(e1,true)
        end
    end
end