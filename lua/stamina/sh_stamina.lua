Stamina = Stamina or {}

Stamina.Cfg	= {}

Stamina.Cfg.MinStaminaToRun					= 2.5
Stamina.Cfg.JumpCost						= 8
Stamina.Cfg.RunStaminaReduction 			= 4
Stamina.Cfg.RunStaminaReductionWeightCoef 	= 0.2 // +0.2 to reduction every kg
Stamina.Cfg.ThinkTime 						= 1
Stamina.Cfg.Replenish						= 6
Stamina.Cfg.TimeBeforeReplenish 			= 5
Stamina.Cfg.MaxStamina 						= 100

function pMeta:GetStamina()
	return self:GetBetterNWInt("Stamina")
end

function pMeta:GetMaxStamina()
	return self:GetBetterNWInt("MaxStamina", Stamina.Cfg.MaxStamina)
end

function pMeta:GetCanJump()
	return self:GetBetterNWBool("CanJump")
end
