
local EffectList = {}

function GetStatusEffects()

	return EffectList

end

local BaseEffect = {
 
 Duration = 60,
 ThinkInterval = 0,
 Force = 1,
 OnStart = function(ent, data) end,
 OnAdjust = function(ply, data) end,
 OnEnd = function(ent, data, forced) end,
 Think = function(ent, data) end,

}

function RegisterStatusEffect(id, tbl, base)

	base = base or BaseEffect
	
	table.Inherit(tbl, base)
	
	EffectList[id] = tbl

end

local function LoadEffects()
	
	EffectList = {}

	hook.Run("LoadEffects") -- для аддонов

end

local Player = FindMetaTable("Player")

function Player:GetStatEffects()

	return self.StatEffects or {}

end

function Player:GetEffect(id)

	return self.StatEffects and self.StatEffects[id]

end

if CLIENT then LoadEffects() end

hook.Add("CreateWorld", "LoadEffects", LoadEffects)
hook.Add("OnReload", "ReloadEffects", LoadEffects)
