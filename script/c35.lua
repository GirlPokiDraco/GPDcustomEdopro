--Raging Dragon Secret Fusion
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e1=Fusion.CreateSummonEff{handler=c,matfilter=Fusion.OnFieldMat,extrafil=s.fextra,extratg=s.extratg}
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
    e1:SetCountLimit(1, id)  -- Limitar a una vez por turno
    e1:SetCost(s.cost)  -- Añadir el coste de 1000 LP
    c:RegisterEffect(e1)
end

function s.fextra(e,tp,mg)
    return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsFaceup),tp,0,LOCATION_ONFIELD,nil)
end

function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
    if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
        Duel.SetChainLimit(aux.FALSE)
    end
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,1000) end
    Duel.PayLPCost(tp,1000)
end
