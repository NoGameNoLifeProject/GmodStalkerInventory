function pMeta:SetupStamina()
	self.RunSpeed = self:GetRunSpeed()
	self.WalkSpeed = self:GetWalkSpeed()
	self.JumpPower = self:GetJumpPower()
	self.IsRunning = false
	self.LastRun = CurTime()
	self:SetBetterNWInt("Stamina", self:GetMaxStamina())
	self:SetBetterNWBool("CanJump", true)
	self.StaminaNextThink = CurTime() + Stamina.Cfg.ThinkTime
end

function pMeta:AddStamina(Amount)
	self:SetBetterNWInt("Stamina", math.Clamp(self:GetBetterNWInt("Stamina") + Amount, 0, self:GetMaxStamina()))
end

function pMeta:ToggleJump(Toggle)
	self:SetBetterNWBool("CanJump", Toggle)
end

function pMeta:SetMaxStamina(Amount)
	self:SetBetterNWInt("MaxStamina", math.Max(Amount, 0))
end

hook.Add("PlayerLoadout", "StaminaPlayerLoadout", function(ply)
	ply:SetupStamina()
end)

hook.Add( "KeyPress", "StaminaKeyPreStamina", function( ply, key )
	if (key != IN_SPEED and key != IN_JUMP) or ply:GetMoveType() == MOVETYPE_NOCLIP or !ply:Alive() or ply:InVehicle() then return end

	if key == IN_JUMP and ply:IsOnGround() and ply:GetJumpPower() > 0 then
		if ply:GetStamina() < Stamina.Cfg.JumpCost then
			ply:ToggleJump(false)
			ply:SetJumpPower(0)
		end
		if Stamina.Cfg.JumpCost <= ply:GetStamina() and ply:GetCanJump() then
			ply:AddStamina(-Stamina.Cfg.JumpCost)
			ply.LastRun = CurTime()
		end
		return
	end
	
	if key == IN_SPEED then
		if ply:GetStamina() < Stamina.Cfg.MinStaminaToRun then
			ply.IsRunning = false	
			ply:SetRunSpeed(ply:GetWalkSpeed())
		else
			ply.LastRun = CurTime()
			ply.IsRunning = true
			ply:AddStamina(-Stamina.Cfg.RunStaminaReduction)
		end
	end
end)

hook.Add( "KeyRelease", "StaminaKeyRelease", function( ply, key )
	if key == IN_SPEED and ply.IsRunning then
		ply.IsRunning = false
	end
end)
	
hook.Add( "PlayerPostThink", "StaminaThink", function( ply )
	if ply.StaminaNextThink and ply.StaminaNextThink < CurTime() then
		if !ply:Alive() then return end
		local inventory = ply:GetBetterNWTable("Inventory")
		if !inventory.Info then return end
		local weight = inventory.Info.Weight
		local maxWeight = ply:GetNWFloat("Inventory:MaxWeight", Inventory.cfg.defaultMaxWeight)
		local additionalReduction = Stamina.Cfg.RunStaminaReductionWeightCoef * math.Remap(weight, 0, maxWeight, 0, Inventory.cfg.defaultMaxWeight)
		local canRun = weight < maxWeight
		local canWalk = true
		if !canRun then
			if weight - maxWeight > 5 then
				canWalk = false
			end
		end

		if ply.IsRunning then
			if ply:GetStamina() > Stamina.Cfg.MinStaminaToRun and canRun then
				ply:AddStamina(-Stamina.Cfg.RunStaminaReduction - additionalReduction)
				ply:SetRunSpeed(ply.RunSpeed)
				ply.LastRun = CurTime()
			else
				if canWalk then
					ply:SetRunSpeed(ply:GetWalkSpeed())
				else
					ply:SetRunSpeed(1)
				end
				ply.IsRunning = false
			end
		end

		if canWalk then
			ply:SetWalkSpeed(ply.WalkSpeed)
		else
			ply:SetWalkSpeed(1)
		end
		
		if !ply.IsRunning and (ply.LastRun + Stamina.Cfg.TimeBeforeReplenish) < CurTime() then
			local additionalStaminaReplenish = ply:GetBetterNWInt("AdditionalStaminaReplenish", 0)
			ply:AddStamina(Stamina.Cfg.Replenish + additionalStaminaReplenish)
			if ply:GetStamina() > Stamina.Cfg.MinStaminaToRun then
				ply:SetRunSpeed(ply.RunSpeed)
				if ply:GetCurrentCommand():KeyDown(IN_SPEED) then
					ply.IsRunning = true
				end
			end
			if ply:GetStamina() > Stamina.Cfg.JumpCost then
				ply:ToggleJump(true)
				ply:SetJumpPower(ply.JumpPower)
			end
		end
		ply.StaminaNextThink = (ply.StaminaNextThink or CurTime()) + Stamina.Cfg.ThinkTime
	end
end)