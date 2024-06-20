-- Raging Dragon Fusion
local s,id=GetID()

function s.initial_effect(c)
    -- Fusion Summon
    c:RegisterEffect(Fusion.CreateSummonEff(c,aux.FilterBoolFunction(Card.IsSetCard,0x7c9),Fusion.SelectFusionMaterial(Card.IsAbleToGraveAsCost)))

    -- Salvage
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCost(s.thcost)
    e2:SetTarget(s.thtg)
    e2:SetOperation(s.thop)
    c:RegisterEffect(e2)
end

s.listed_series={0x7c9}

-- Function to select Fusion Materials from the Deck and the Graveyard
function Fusion.SelectFusionMaterial(filter)
    return function(c,mg)
        local mg1=Duel.GetMatchingGroup(Card.IsCanBeFusionMaterial,c:GetControler(),LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK,0,c)
        return mg1:Filter(Fusion.MatchMaterialFunction(c),nil,mg1,mg)
    end
end

-- Salvage Effect
function s.thfilter(c)
    return c:IsSetCard(0x7c9) and c:IsMonster() and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end

function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE|LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_GRAVE|LOCATION_MZONE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,c)
    end
end
