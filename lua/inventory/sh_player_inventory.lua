Inventory = Inventory or {}

function pMeta:EmptyWeaponSlot()
	local inventory = self:GetBetterNWTable("Inventory") 
	if !istable(inventory.CustomSlots["FirstWeapon"]) then
		return "FirstWeapon"
	elseif !istable(inventory.CustomSlots["SecondWeapon"]) then
		return "SecondWeapon"
	end
	return false
end

function pMeta:HasRadio()
	local inventory = self:GetBetterNWTable("Inventory")
	return inventory.Categories["Other"]["radio"]
end

function pMeta:IsSlotEmpty(slot)
	local inventory = self:GetBetterNWTable("Inventory") 
	return !istable(inventory.CustomSlots[slot])
end

function pMeta:IsQuickSlotEmpty(slot)
	local inventory = self:GetBetterNWTable("Inventory") 
	return !istable(inventory.CustomSlots.QuickSlots[slot])
end

function pMeta:IsArtSlotEmpty(slot)
	local inventory = self:GetBetterNWTable("Inventory") 
	return !istable(inventory.CustomSlots.Artifacts[slot])
end

function Inventory:IsEntityLocked(ent)
	return ent:GetNWBool("IsLocked", false)
end