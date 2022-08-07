netstream.Hook("StatusEffects", function(str, dur, force)
	local effs = GetStatusEffects()
	local ply = LocalPlayer()
	ply.StatEffects = istable(ply.StatEffects) and ply.StatEffects or {}

	if str == "_CLEAR" then

		for k, data in pairs(ply.StatEffects) do
		
			local eff = effs[k]

			eff.OnEnd(ply, data, true)

		end

		ply.StatEffects = {}
		return

	end

	if !effs[str] then return end

	local eff = effs[str]

	util.Switch(dur, {

		[-1] = function()
		
			if !ply.StatEffects[str] then return end

			eff.OnEnd(ply, {EndTime = CurTime(), Force = force})
			ply.StatEffects[str] = nil
		
		end,

		[-2] = function()
		
			if !ent.StatEffects[str] then return end

			eff.OnEnd(ply, {EndTime = CurTime(), Force = force}, true)
			ply.StatEffects[str] = nil
		
		end,

	}, function()
	
		eff.OnStart(ply, {EndTime = CurTime() + dur, Force = force})
		ply.StatEffects[str] = {EndTime = CurTime() + dur, Force = force}
	
	end)
end)

netstream.Hook("StatusEffectsAdjust", function(id, dur, force)
	local effs = GetStatusEffects()
	local ply = LocalPlayer()
	ply.StatEffects = ply.StatEffects or {}
	if !effs[id] then return end
	local eff = effs[id]
	local data = {EndTime = ply.StatEffects[id].EndTime + dur, Force = ply.StatEffects[id].Force + force, AdjustForce = force or 0}
	ply.StatEffects[id] = data
	eff.OnAdjust(ply, data)
end)