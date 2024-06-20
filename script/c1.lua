-- Darkness Raging Dragon
local s,id=GetID()

function s.initial_effect(c)
    -- Add 1 "Raging Dragon" card from Deck to hand
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,1))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1,{id,1})
    e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e1:SetTarget(s.thtg)
    e1:SetOperation(s.thop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)

    -- Special Summon from Graveyard when used as Fusion or Link Material
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_BE_MATERIAL)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCondition(s.spcon)
    e3:SetCost(s.spcost)
    e3:SetTarget(s.sptg)
    e3:SetOperation(s.spop)
    c:RegisterEffect(e3)
end

s.listed_series={0x7c9}

-- Filter for searching "Raging Dragon" cards in Deck
function s.filter(c)
    return c:IsSetCard(0x7c9) and not c:IsCode(id) and c:IsAbleToHand()
end

-- Effect to add "Raging Dragon" card from Deck to hand
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

-- Condition to check if used as Fusion or Link Material
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsLocation(LOCATION_GRAVE) and (r & (REASON_FUSION + REASON_LINK)) ~= 0
end

-- Cost to send a card to Graveyard
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end

-- Target for Special Summon from Graveyard
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

-- Special Summon operation from Graveyard
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
    end
end
