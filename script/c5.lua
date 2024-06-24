-- Dragón Furioso Audaz
local s,id=GetID()
function s.initial_effect(c)
    -- Efecto: Descartar esta carta para evitar que el oponente añada o robe cartas fuera de su fase de robo durante este turno
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DISABLE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.discon)
    e1:SetCost(s.discost)
    e1:SetOperation(s.disop)
    c:RegisterEffect(e1)
    if not s.global_check then
        s.global_check=true
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_PHASE_START+PHASE_BATTLE+PHASE_MAIN1+PHASE_MAIN2+PHASE_END)
        ge1:SetOperation(s.check_op)
        Duel.RegisterEffect(ge1,0)
    end
end

function s.discon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp and e:GetHandler():IsDiscardable()
end

function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end

function s.disop(e,tp,eg,ep,ev,re,r,rp)
    Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end

function s.check_op(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFlagEffect(tp,id)==0 then return end
    Duel.ResetFlagEffect(tp,id)
    local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
    if #g>0 then
        Duel.ConfirmCards(1-tp,g)
        if g:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then
            Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
        end
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_ADD_DECK_MONSTER)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_DRAW)
    Duel.RegisterEffect(e2,tp)
end
