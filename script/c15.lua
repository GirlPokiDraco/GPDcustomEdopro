--Abyss Raging Dragon
local s,id=GetID()
function s.initial_effect(c)
    --Add to hand when sent to the Graveyard
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetCondition(s.thcon)
    e1:SetTarget(s.thtg)
    e1:SetOperation(s.thop)
    e1:SetCountLimit(1,id)
    c:RegisterEffect(e1)
    
    --Fusion Summon Dragon-type using this card and another card
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
    e2:SetTarget(s.fustg)
    e2:SetOperation(s.fusop)
    e2:SetCountLimit(1,{id,1})
    c:RegisterEffect(e2)
end

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD)
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
    end
end

function s.fusfilter1(c,e)
    return c:IsCode(15) and (not c:IsLocation(LOCATION_HAND) or not c:IsStatus(STATUS_BATTLE_DESTROYED))
end

function s.fusfilter2(c,e,tp,m,f,chkf)
    return c:IsType(TYPE_FUSION) and c:IsRace(RACE_DRAGON) and (not f or f(c))
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end

function s.fustg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local chkf=tp
        local mg1=Duel.GetFusionMaterial(tp):Filter(s.fusfilter1,nil,e)
        local res=Duel.IsExistingMatchingCard(s.fusfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
        if not res then
            local mg2=Duel.GetMatchingGroup(s.fusfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,e)
            mg1:Merge(mg2)
            res=Duel.IsExistingMatchingCard(s.fusfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
        end
        return res
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function s.fusop(e,tp,eg,ep,ev,re,r,rp)
    local chkf=tp
    local mg1=Duel.GetFusionMaterial(tp):Filter(s.fusfilter1,nil,e)
    local sg1=Duel.GetMatchingGroup(s.fusfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
    if sg1:GetCount()>0 then
        local mg2=Duel.GetMatchingGroup(s.fusfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,e)
        mg1:Merge(mg2)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tg=sg1:Select(tp,1,1,nil)
        local tc=tg:GetFirst()
        if tc then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
            local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
            if not mat1 then return end
            mat1:RemoveCard(e:GetHandler()) -- Remove "Abyss Raging Dragon" from materials
            tc:SetMaterial(mat1)
            Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
            Duel.BreakEffect()
            Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
            tc:CompleteProcedure()
        end
    end
end