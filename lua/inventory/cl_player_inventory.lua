function Inventory:LockEntity(ent)
	netstream.Start("Inventory:LockEntity", ent)
end

function Inventory:UnLockEntity(ent)
	netstream.Start("Inventory:UnLockEntity", ent)
end
