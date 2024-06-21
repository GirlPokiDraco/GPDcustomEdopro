local s,id=GetID()
function s.initial_effect(c)
    -- Efecto de Descarte para Negar
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.negateCondition)
	e1:SetCost(s.negateCost)
	e1:SetTarget(s.negateTarget)
	e1:SetOperation(s.negateOperation)
	c:RegisterEffect(e1)
end

function s.negateCondition(e,tp,eg,ep,ev,re,r,rp)
    -- Verificar si la activación del adversario añade cartas desde su Deck a su mano
    return rp~=tp and Duel.IsChainDisablable(ev) and Duel.GetCurrentChain()>1 
        and re:GetHandler():IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) 
        and re:IsHasType(EFFECT_TYPE_ACTIVATE) 
        and (re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_MONSTER))
end

function s.negateCost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end

function s.negateTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end

function s.negateOperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end