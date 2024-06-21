-- Dragón Furioso Audaz
local s,id=GetID()
function s.initial_effect(c)
    -- Efecto de Descarte para Negar
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_NEGATE)
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
    -- Check if it's the opponent's effect that adds cards from their Deck to their hand
    return rp~=tp and Duel.GetCurrentChain()>1 and re:IsHasType(EFFECT_TYPE_ACTIVATE) 
        and Duel.IsChainNegatable(ev) and re:GetHandler():IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
end

function s.negateCost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end

function s.negateTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end

function s.negateOperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
    -- Get the cards added by your opponent's effect
    local addedCards=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_DECK)
    if #addedCards>0 then
        -- Send the added cards to the Graveyard
        Duel.SendtoGrave(addedCards,REASON_EFFECT)
    end
end