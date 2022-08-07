eMeta = eMeta or FindMetaTable("Entity")
BetterNW = BetterNW or {}
BetterNWPrivate = BetterNWPrivate or {}

local types = {
	["Table"] = {},
	["String"] = "",
	["Int"] = 0,
	["Angle"] = Angle(),
	["Vector"] = Vector(),
	["Entity"] = true,
	["Bool"] = true,
	["Var"] = nil,
}

for k, _ in pairs(types) do
	BetterNW[k] = BetterNW[k] or {}
	BetterNWPrivate[k] = BetterNWPrivate[k] or {}
end

local function GetId(ent)
	return ent:IsPlayer() and ent:SteamID() or ent:EntIndex()
end

local function SetBetter(Type, ent, name, var, private)
	if !types[Type] then Type = "Var" end
	local key = GetId(ent)
	if SERVER then
		if private then
			BetterNWPrivate[Type][key] = BetterNWPrivate[Type][key] or {}
			BetterNWPrivate[Type][key][name] = var
	
			if (!ent:IsPlayer() or (ent:IsPlayer() and ent:IsBot())) then return end
			AddLuaTask(netstream.Heavy(ent, "BetterNW", Type, key, name, var, private))
		else
			BetterNW[Type][key] = BetterNW[Type][key] or {}
			BetterNW[Type][key][name] = var

			if (ent:IsPlayer() and ent:IsBot()) then return end
			for _, ply in pairs(player.GetAll()) do
				AddLuaTask(netstream.Heavy(ply, "BetterNW", Type, key, name, var))
			end
		end
	elseif CLIENT then
		BetterNW[Type][key] = BetterNW[Type][key] or {}
		BetterNW[Type][key][name] = var
	end
end

local function GetBetter(Type, ent, name, fallback)
	if !types[Type] then Type = "Var" end
	if CLIENT then 
		if ent:IsPlayer() and ent:IsBot() then 
			return (fallback and fallback or types[Type]) 
		end 
	end
	local key = GetId(ent)
	if BetterNW[Type][key] and BetterNW[Type][key][name] then
		return BetterNW[Type][key][name]
	elseif BetterNWPrivate[Type][key] and BetterNWPrivate[Type][key][name] then
		return BetterNWPrivate[Type][key][name]
	else
		return fallback and fallback or types[Type]
	end
end
------------------------Set--------------------
function eMeta:SetBetterNWTable(name, Table, private)
	if istable(Table) then
		SetBetter("Table", self, name, Table, private)
	else
		MsgC( Color( 255, 0, 0 ), "[ERROR] ", Color( 255, 255, 255 ), "SetBetterNWTable: ", "Table expected, got ", Color( 0, 255, 0 ), type(Table), "\n" )
	end
end

function eMeta:SetBetterNWString(name, String, private)
	if isstring(String) then
		SetBetter("String", self, name, String, private)
	else
		MsgC( Color( 255, 0, 0 ), "[ERROR] ", Color( 255, 255, 255 ), "SetBetterNWString: ", "String expected, got ", Color( 0, 255, 0 ), type(String), "\n" )
	end
end

function eMeta:SetBetterNWInt(name, Int, private)
	if isnumber(Int) then
		SetBetter("Int", self, name, Int, private)
	else
		MsgC( Color( 255, 0, 0 ), "[ERROR] ", Color( 255, 255, 255 ), "SetBetterNWInt: ", "Int expected, got ", Color( 0, 255, 0 ), type(Int), "\n" )
	end
end

function eMeta:SetBetterNWAngle(name, Angle, private)
	if isangle(Angle) then
		SetBetter("Angle", self, name, Angle, private)
	else
		MsgC( Color( 255, 0, 0 ), "[ERROR] ", Color( 255, 255, 255 ), "SetBetterNWAngle: ", "Angle expected, got ", Color( 0, 255, 0 ), type(Angle), "\n" )
	end
end

function eMeta:SetBetterNWVector(name, Vector, private)
	if isvector(Vector) then
		SetBetter("Vector", self, name, Vector, private)
	else
		MsgC( Color( 255, 0, 0 ), "[ERROR] ", Color( 255, 255, 255 ), "SetBetterNWVector: ", "Vector expected, got ", Color( 0, 255, 0 ), type(Vector), "\n" )
	end
end

function eMeta:SetBetterNWEntity(name, Entity, private)
	if IsEntity(Entity) then
		SetBetter("Entity", self, name, Entity, private)
	else
		MsgC( Color( 255, 0, 0 ), "[ERROR] ", Color( 255, 255, 255 ), "SetBetterNWEntity: ", "Entity expected, got ", Color( 0, 255, 0 ), type(Entity), "\n" )
	end
end

function eMeta:SetBetterNWBool(name, Bool, private)
	if isbool(Bool) then 
		SetBetter("Bool", self, name, Bool, private)
	else
		MsgC( Color( 255, 0, 0 ), "[ERROR] ", Color( 255, 255, 255 ), "SetBetterNWBool: ", "Bool expected, got ", Color( 0, 255, 0 ), type(Bool), "\n" )
	end
end

function eMeta:SetBetterNWVar(name, Var, private)
	if IsValid(Var) then
		SetBetter("Var", self, name, Var, private)
	else
		MsgC( Color( 255, 0, 0 ), "[ERROR] ", Color( 255, 255, 255 ), "SetBetterNWVar: ", "Var expected, got ", Color( 0, 255, 0 ), "nil", "\n" )
	end
end

------------------------Get--------------------
function eMeta:GetBetterNWTable(name, fallback)
	return GetBetter("Table", self, name, fallback)
end

function eMeta:GetBetterNWString(name, fallback)
	return GetBetter("String", self, name, fallback)
end

function eMeta:GetBetterNWInt(name, fallback)
	return GetBetter("Int", self, name, fallback)
end

function eMeta:GetBetterNWAngle(name, fallback)
	return GetBetter("Angle", self, name, fallback)
end

function eMeta:GetBetterNWVector(name, fallback)
	return GetBetter("Vector", self, name, fallback)
end

function eMeta:GetBetterNWEntity(name, fallback)
	return GetBetter("Entity", self, name, fallback)
end

function eMeta:GetBetterNWBool(name, fallback)
	return GetBetter("Bool", self, name, fallback)
end

function eMeta:GetBetterNWVar(name, fallback)
	return GetBetter("Var", self, name, fallback)
end

if CLIENT then

	netstream.Hook("BetterNW", function(type, ent, name, var, private)
		if private then
			BetterNWPrivate[type][ent] = BetterNWPrivate[type][ent] or {}
			BetterNWPrivate[type][ent][name] = var
		else
			BetterNW[type][ent] = BetterNW[type][ent] or {}
			BetterNW[type][ent][name] = var
		end
	end)
	
	netstream.Hook("BetterNWSyncNewPlayer", function(type, data)
		BetterNW[type] = data
	end)

else

	hook.Add("PlayerIsLoaded", "BetterNWPlayerFullLoad", function(ply)
		if ply:IsBot() then return end
		for type, data in pairs(BetterNW) do
			AddLuaTask(netstream.Heavy(ply, "BetterNWSyncNewPlayer", type, data))
		end
	end)
	
	gameevent.Listen("player_disconnect")
	hook.Add("player_disconnect", "BetterNWplayer_disconnect", function(data)
		for _, v in pairs(BetterNW) do
			v[data.networkid] = nil
		end
	end)
	
	hook.Add("EntityRemoved", "BetterNWEntityRemoved", function(ent)
		for _, v in pairs(BetterNW) do
			v[ent:EntIndex()] = nil
		end
	end)

end