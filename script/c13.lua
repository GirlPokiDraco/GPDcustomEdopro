--Judgment Raging Dragon
local s,id=GetID()
function s.initial_effect(c)
    --Fusion materials
    c:EnableReviveLimit()
    Fusion.AddProcMixN(c,true,true,s.ffilter,3)
    --Banish all opponent's cards and deal damage
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(id,0))
    e0:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
    e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e0:SetCode(EVENT_SPSUMMON_SUCCESS)
    e0:SetProperty(EFFECT_FLAG_DELAY)
    e0:SetCountLimit(1,id)
    e0:SetCondition(s.rmcon)
    e0:SetTarget(s.rmtg)
    e0:SetOperation(s.rmop)
    c:RegisterEffect(e0)
    --If fusion summoned with 3 Dragon Fusion monsters
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_MATERIAL_CHECK)
    e1:SetValue(s.valcheck)
    e1:SetLabelObject(e0)
    c:RegisterEffect(e1)
    --Opponent cannot target your DRAGON monsters
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_DRAGON))
    e2:SetValue(aux.tgoval)
    c:RegisterEffect(e2)
    --Special summon 1 DRAGON monster from GY
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(s.sptg)
    e3:SetOperation(s.spop)
    c:RegisterEffect(e3)
end
s.listed_names={12}
function s.ffilter(c,fc,sumtype,tp)
    return c:IsRace(RACE_DRAGON,fc,sumtype,tp) and c:IsType(TYPE_FUSION)
end
function s.valcheck(e,c)
    if c:GetMaterialCount()==3 and c:GetMaterial():FilterCount(Card.IsRace,nil,RACE_DRAGON)==3 and c:GetMaterial():FilterCount(Card.IsType,nil,TYPE_FUSION)==3 then
        e:GetLabelObject():SetLabel(1)
    end
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and e:GetLabel()==1
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
    if chk==0 then return #g>0 end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,#g*300)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
    local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    if ct>0 then
        Duel.Damage(tp,ct*300,REASON_EFFECT,true)
        Duel.Damage(1-tp,ct*300,REASON_EFFECT,true)
        Duel.RDComplete()
    end
end
function s.spfilter(c,e,tp)
    return c:IsRace(RACE_DRAGON) and not c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
