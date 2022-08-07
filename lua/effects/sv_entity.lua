
local INF = 0
local END = -1
local F_END = -2

local function SendEffect(ply, str, dur, force)
	if !IsValid(ply) then return end
	if !(str == "_CLEAR" || GetStatusEffects()[str]) then return end

	netstream.Start(ply, "StatusEffects", str, dur, force)
end

hook.Add("PlayerPostThink", "EffectsPlayerPostThink", function(ply)
	ply.StatEffects = ply.StatEffects or {}
	ply.StatEffectsThink = ply.StatEffectsThink or {}

	for id, data in pairs(ply.StatEffects) do
		
		local eff = GetStatusEffects()[id]
		if !eff then continue end

		local ct = CurTime()
		if data.EndTime ~= 0 && ct > data.EndTime then	
			SendEffect(ply, id, END, data.Force)
			eff.OnEnd(ply, data)
			
			ply.StatEffects[id] = nil
			ply.StatEffectsThink[id] = nil
			continue
		end

		if !ply.StatEffectsThink[id] then
			
			ply.StatEffectsThink[id] = 0

		end

		if ct < ply.StatEffectsThink[id] then return end
		
		eff.Think(ply, data)

		ply.StatEffectsThink[id] = ct + (eff.ThinkInterval or 0)
	
	end
end)

local Player = FindMetaTable("Player")

function Player:GiveStatEffect(id, duration, force)

	if !IsValid(self) then return end
	if self.EffectsImmunity then return end
	
	self.StatEffects = self.StatEffects or {}

	local eff = GetStatusEffects()[id]
	if !eff then return end

	if hook.Run("DoGiveStatEffect", self, id) then return end

	if self:GetEffect(id) then
		self:AdjustStatEffect(id, duration, force)
		return
	end
	
	duration = isnumber(duration) and duration or eff.Duration or 60
	force = force or 1
	local data = {EndTime = CurTime() + duration, Force = force}
	self.StatEffects[id] = data

	SendEffect(self, id, duration, force)
	eff.OnStart(self, data)

end

function Player:RemoveStatEffect(id)

	if !IsValid(self) then return end
	if self.EffectsImmunity then return end
	
	self.StatEffects = self.StatEffects or {}

	local eff = GetStatusEffects()[id]
	if !eff then return end

	if !self.StatEffects[id] then return end

	SendEffect(self, id, F_END, self.StatEffects[id].Force)
	eff.OnEnd(self, self.StatEffects[id], true)

	self.StatEffects[id] = nil

end

function Player:ClearStatEffects()

	if !IsValid(self) then return end
	if self.EffectsImmunity then return end
	
	self.StatEffects = self.StatEffects or {}
	local effs = GetStatusEffects()

	for k, data in pairs(self.StatEffects) do
		
		local eff = effs[k]

		eff.OnEnd(self, data, true)

		self.StatEffects[k] = nil
	
	end

	SendEffect(self, "_CLEAR")

end

function Player:AdjustStatEffect(id, dur, force)

	if !IsValid(self) then return end
	if self.EffectsImmunity then return end
	
	self.StatEffects = self.StatEffects or {}

	local eff = GetStatusEffects()[id]
	if !eff then return end

	if !self.StatEffects[id] then return end

	local data = {EndTime = self.StatEffects[id].EndTime + dur, Force = self.StatEffects[id].Force + force, AdjustForce = force or 0}
	self.StatEffects[id] = data
	eff.OnAdjust(self, data)
	netstream.Start(self, "StatusEffectsAdjust", id, dur, force)
end

hook.Add("PostPlayerDeath", "EffectsPostPlayerDeath", function(ply)
	ply:ClearStatEffects()
end)
