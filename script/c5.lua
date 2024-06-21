-- Dragón Furioso Audaz
local s,id=GetID()
function s.initial_effect(c)
    -- Efecto 1: Descarta esta carta desde tu mano para negar que el adversario añada cartas desde su Deck a la mano
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DISABLE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_TO_HAND)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.discon)
    e1:SetCost(s.discost)
    e1:SetTarget(s.distg)
    e1:SetOperation(s.disop)
    c:RegisterEffect(e1)
    -- Efecto 2: Activa desde el cementerio; destierra esta carta para que todos los monstruos en el campo sean tratados como monstruos de Tipo Dragón hasta el final del próximo turno, y solo se pueden realizar Invocaciones de Monstruos de Tipo Dragón.
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e2:SetCountLimit(1,id+100)
    e2:SetCondition(s.dragoncon)
    e2:SetTarget(s.dragontg)
    e2:SetOperation(s.dragonop)
    c:RegisterEffect(e2)
end

function s.discon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler())
end

function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end

function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,0,1-tp,LOCATION_DECK)
end

function s.disop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetDecktopGroup(1-tp,1)
    if #g>0 then
        Duel.DisableShuffleCheck()
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end

function s.dragoncon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,LOCATION_MZONE)>0
end

function s.dragontg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end

function s.dragonop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetTargetRange(1,0)
        e1:SetCode(EFFECT_CHANGE_RACE)
        e1:SetValue(RACE_DRAGON)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD)
        e2:SetCode(EFFECT_ONLY_BE_MATERIAL)
        e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e2:SetTargetRange(1,0)
        e2:SetValue(aux.NOT(aux.TargetBoolFunction(Card.IsRace,RACE_DRAGON)))
        e2:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e2,tp)
    end
end