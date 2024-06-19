--Supreme Raging Dragon
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,true,true,aux.FilterBoolFunctionEx(Card.IsRace,RACE_DRAGON),2)
	--Activation Limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetCondition(s.actcon)
	c:RegisterEffect(e1)
		--change position
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_DEFCHANGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.postg)
	e2:SetOperation(s.posop)
	c:RegisterEffect(e2)
	--banish
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e3:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e3)

end
s.listed_series={0x7c9}
function s.actcon(e)
	local a=Duel.GetAttacker()
	return a and a:IsControler(e:GetHandlerPlayer()) and a:IsSetCard(0x7c9)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsTurnPlayer(1-tp)
end
--check for attack pos monster
function s.atkfilter(c)
	return c:IsMonster() and (c:IsType(TYPE_NORMAL) or c:IsSetCard(0x7c9))
end
function s.posfilter(c,tp)
	if c:IsFaceup() and c:IsAttackPos() and c:IsCanChangePosition() then
		local att=0
		for gc in aux.Next(Duel.GetMatchingGroup(s.atkfilter,tp,LOCATION_GRAVE,0,nil)) do
			att=att|gc:GetAttribute()
		end
		return c:GetAttribute()&att~=0
	end
end
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.posfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.posfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,s.posfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
end
function s.posop(e,tp,ev,eg,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsAttackPos() and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		if tc:IsPosition(POS_FACEUP_DEFENSE) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_DEFENSE)
			e1:SetValue(-1000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
end
end
end