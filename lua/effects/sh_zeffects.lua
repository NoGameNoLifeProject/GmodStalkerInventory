--[[
Указаны только использующиеся режимом вары.
Можно добавлять и свои.

RegisterStatusEffect("example", {
	Duration = 1, -- Используется, если не установлено методом ENT:GiveStatEffect. Если 0, то бесконечно.
	ThinkInterval = 0, --Задержка между вызовами Think. Если 0, то отключается.
	Force = 1, -- Сила эффекта
	OnStart = function(ply, data) end, -- Шаред
	OnAdjust = function(ply, data) end, -- Шаред
	OnEnd = function(ply, data, forced) end, -- Шаред
	Think = function(ply, data) end, -- Сервер

	data в функциях:
		EndTime - Время окончания эффекта
		Force - Сила эффекта
		AdjustForce - (в функции Adjust) изменение силы эффекта
})
]]--

RegisterStatusEffect("bleeding", { // Кровотечение
	Duration = 10,
	ThinkInterval = 1,
	Force = 1,
	Think = function(ply, data)
		ply:TakeDamage(data.Force, ply)
	end,
})

RegisterStatusEffect("psi", { // Пси
	Duration = 1,
	ThinkInterval = 10,
	Force = 1,
	Think = function(ply, data)
		ply:PsyAttack(data.Force, 10)
	end,
})

RegisterStatusEffect("radiation", { // Радиация
	Duration = 1,
	ThinkInterval = 1,
	Force = 1,
	OnStart = function(ply, data) 
		ply:Infect(data.Force)
	end,
	OnAdjust = function(ply, data)
		if data.AdjustForce > 0 then
			ply:Infect(data.AdjustForce)
		else
			ply:Cure(math.abs(data.AdjustForce))
		end
	end,
	OnEnd = function(ply, data, forced) 
		ply:Cure()
	end,
})

RegisterStatusEffect("regeneration", { // Регенерация
	Duration = 1,
	ThinkInterval = 1,
	Force = 1,
	Think = function(ply, data)
		ply:SetHealth(math.min(ply:Health() + data.Force, ply:GetMaxHealth()))
	end,
})

RegisterStatusEffect("burn", { // Ожог
	Duration = 1,
	ThinkInterval = 1,
	Force = 1,
	Think = function(ply, data)
		local damage = DamageInfo()
		damage:SetDamage( data.Force )
		damage:SetAttacker( ply )
		damage:SetDamageType( DMG_BURN ) 
		ply:TakeDamageInfo( damage )
	end,
})

RegisterStatusEffect("chemical", { // Хим. Ожог
	Duration = 1,
	ThinkInterval = 1,
	Force = 1,
	Think = function(ply, data)
		local damage = DamageInfo()
		damage:SetDamage( data.Force )
		damage:SetAttacker( ply )
		damage:SetDamageType( DMG_POISON ) 
		ply:TakeDamageInfo( damage )
	end,
})

RegisterStatusEffect("electroshock", { // Электрошок
	Duration = 1,
	ThinkInterval = 1,
	Force = 1,
	Think = function(ply, data)
		local damage = DamageInfo()
		damage:SetDamage( data.Force )
		damage:SetAttacker( ply )
		damage:SetDamageType( DMG_SHOCK ) 
		ply:TakeDamageInfo( damage )
	end,
})

RegisterStatusEffect("stamina", { // Баф выносливости
	Duration = 1,
	ThinkInterval = 1,
	Force = 1,
	OnStart = function(ply, data) 
		ply:SetBetterNWInt("AdditionalStaminaReplenish", ply:GetBetterNWInt("AdditionalStaminaReplenish", 0) + data.Force)
	end,
	OnAdjust = function(ply, data) 
		ply:SetBetterNWInt("AdditionalStaminaReplenish", ply:GetBetterNWInt("AdditionalStaminaReplenish", 0) + data.AdjustForce)
	end,
	OnEnd = function(ply, data, forced) 
		ply:SetBetterNWInt("AdditionalStaminaReplenish", ply:GetBetterNWInt("AdditionalStaminaReplenish", 0) - data.Force)
	end,
})


RegisterStatusEffect("weight", { // Макс переносимый вес
	Duration = 1,
	ThinkInterval = 1,
	Force = 1,
	OnStart = function(ply, data) 
		ply:SetNWFloat("Inventory:MaxWeight", ply:GetNWFloat("Inventory:MaxWeight", Inventory.cfg.defaultMaxWeight) + data.Force)
	end,
	OnAdjust = function(ply, data) 
		ply:SetNWFloat("Inventory:MaxWeight", ply:GetNWFloat("Inventory:MaxWeight", Inventory.cfg.defaultMaxWeight) + data.AdjustForce)
	end,
	OnEnd = function(ply, data, forced) 
		ply:SetNWFloat("Inventory:MaxWeight", ply:GetNWFloat("Inventory:MaxWeight", Inventory.cfg.defaultMaxWeight) - data.Force)
	end,
})




