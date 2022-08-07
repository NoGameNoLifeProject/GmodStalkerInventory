
--[[
DEVELOPMENTAL VERSION;
VERSION 1.2.2
Copyright thelastpenguin™
	You may use this for any purpose as long as:
	-	You don't remove this copyright notice.
	-	You don't claim this to be your own.
	-	You properly credit the author, thelastpenguin™, if you publish your work based on (and/or using) this.
	If you modify the code for any purpose, the above still applies to the modified code.
	The author is not held responsible for any damages incured from the use of pon, you use it at your own risk.
DATA TYPES SUPPORTED:
 - tables  - 		k,v - pointers
 - strings - 		k,v - pointers
 - numbers -		k,v
 - booleans- 		k,v
 - Vectors - 		k,v
 - Angles  -		k,v
 - Entities- 		k,v
 - Players - 		k,v
CHANGE LOG
V 1.1.0
 - Added Vehicle, NPC, NextBot, Player, Weapon
V 1.2.0
 - Added custom handling for k,v tables without any array component.
V 1.2.1
 - fixed deserialization bug.
THANKS TO...
 - VERCAS for the inspiration.
]]


local pon = {};
_G.pon = pon;

local type, count = type, table.Count ;
local tonumber = tonumber ;
local format = string.format;
do
	local type, count = type, table.Count ;
	local tonumber = tonumber ;
	local format = string.format;

	local encode = {};

	local tryCache ;

	local cacheSize = 0;

	encode['table'] = function( self, tbl, output, cache )

		if( cache[ tbl ] )then
			output[ #output + 1 ] = format('(%x)',  cache[tbl] );
			return ;
		else
			cacheSize = cacheSize + 1;
			cache[ tbl ] = cacheSize;
		end


    local first = next(tbl, nil)
    local predictedNumeric = 1
    local lastKey = nil
    -- starts with a numeric dealio
    if first == 1 then
      output[#output + 1] = '{'

      for k,v in next, tbl do
        if k == predictedNumeric then
          predictedNumeric = predictedNumeric + 1

          local tv = type(v)
          if tv == 'string' then
            local pid = cache[v]
            if pid then
              output[#output + 1] = format('(%x)', pid)
            else
              cacheSize = cacheSize + 1
              cache[v] = cacheSize
              self.string(self, v, output, cache)
            end
          else
            self[tv](self, v, output, cache)
          end

        else
          break
        end
      end

			predictedNumeric = predictedNumeric - 1
    else
      predictedNumeric = nil
    end

    if predictedNumeric == nil then
      output[#output + 1] = '[' -- no array component
    else
      output[#output + 1] = '~' -- array component came first so shit needs to happen
    end

    for k, v in next, tbl, predictedNumeric do
      local tk, tv = type(k), type(v)

      -- WRITE KEY
      if tk == 'string' then
        local pid = cache[ k ];
        if( pid )then
          output[ #output + 1 ] = format('(%x)',  pid );
        else
          cacheSize = cacheSize + 1;
          cache[ k ] = cacheSize;

          self.string( self, k, output, cache );
        end
      else
        self[tk](self, k, output, cache)
      end

      -- WRITE VALUE
      if( tv == 'string' )then
        local pid = cache[ v ];
        if( pid )then
          output[ #output + 1 ] = format('(%x)',  pid );
        else
          cacheSize = cacheSize + 1;
          cache[ v ] = cacheSize;

          self.string( self, v, output, cache );
        end
      else
        self[ tv ]( self, v, output, cache );
      end
    end

    output[#output + 1] = '}'
	end
	--    ENCODE STRING
	local gsub = string.gsub ;
	encode['string'] = function( self, str, output )
		--if tryCache( str, output ) then return end
		local estr, count = gsub( str, ";", "\\;");
		if( count == 0 )then
			output[ #output + 1 ] = '\''..str..';';
		else
			output[ #output + 1 ] = '"'..estr..'";';
		end
	end
	--    ENCODE NUMBER
	encode['number'] = function( self, num, output )
		if num%1 == 0 then
			if num < 0 then
				output[ #output + 1 ] = format( 'x%x;', -num );
			else
				output[ #output + 1 ] = format('X%x;', num );
			end
		else
			output[ #output + 1 ] = tonumber( num )..';';
		end
	end
	--    ENCODE BOOLEAN
	encode['boolean'] = function( self, val, output )
		output[ #output + 1 ] = val and 't' or 'f'
	end
	--    ENCODE VECTOR
	encode['Vector'] = function( self, val, output )
		output[ #output + 1 ] = ('v'..val.x..','..val.y)..(','..val.z..';');
	end
	--    ENCODE ANGLE
	encode['Angle'] = function( self, val, output )
		output[ #output + 1 ] = ('a'..val.p..','..val.y)..(','..val.r..';');
	end
	encode['Entity'] = function( self, val, output )
		output[ #output + 1] = 'E'..(IsValid( val ) and (val:EntIndex( )..';') or '#');
	end
	encode['Player']  = encode['Entity'];
	encode['Vehicle'] = encode['Entity'];
	encode['Weapon']  = encode['Entity'];
	encode['NPC']     = encode['Entity'];
	encode['NextBot'] = encode['Entity'];
	encode['PhysObj'] = encode['Entity'];

	encode['nil'] = function()
		output[ #output + 1 ] = '?';
	end
	encode.__index = function( key )
		ErrorNoHalt('Type: '..key..' can not be encoded. Encoded as as pass-over value.');
		return encode['nil'];
	end

	do
		local empty, concat = table.Empty, table.concat ;
		function pon.encode( tbl )
			local output = {};
			cacheSize = 0;
			encode[ 'table' ]( encode, tbl, output, {} );
			local res = concat( output );

			return res;
		end
	end
end

do
	local tonumber = tonumber ;
	local find, sub, gsub, Explode = string.find, string.sub, string.gsub, string.Explode ;
	local Vector, Angle, Entity = Vector, Angle, Entity ;

	local decode = {};
	decode['{'] = function( self, index, str, cache )

		local cur = {};
		cache[ #cache + 1 ] = cur;

		local k, v, tk, tv = 1, nil, nil, nil;
		while( true )do
			tv = sub( str, index, index );
			if( not tv or tv == '~' )then
				index = index + 1;
				break ;
			end
			if( tv == '}' )then
				return index + 1, cur;
			end

			-- READ THE VALUE
			index = index + 1;
			index, v = self[ tv ]( self, index, str, cache );
			cur[ k ] = v;

			k = k + 1;
		end

		while( true )do
			tk = sub( str, index, index );
			if( not tk or tk == '}' )then
				index = index + 1;
				break ;
			end

			-- READ THE KEY

			index = index + 1;
			index, k = self[ tk ]( self, index, str, cache );

			-- READ THE VALUE
			tv = sub( str, index, index );
			index = index + 1;
			index, v = self[ tv ]( self, index, str, cache );

			cur[ k ] = v;
		end

		return index, cur;
	end
	decode['['] = function( self, index, str, cache )

		local cur = {};
		cache[ #cache + 1 ] = cur;

		local k, v, tk, tv = 1, nil, nil, nil;
		while( true )do
			tk = sub( str, index, index );
			if( not tk or tk == '}' )then
				index = index + 1;
				break ;
			end

			-- READ THE KEY
			index = index + 1;
			index, k = self[ tk ]( self, index, str, cache );
			if not k then continue end

			-- READ THE VALUE
			tv = sub( str, index, index );
			index = index + 1;
			if not self[tv] then
				print('did not find type: '..tv)
			end
			index, v = self[ tv ]( self, index, str, cache );

			cur[ k ] = v;
		end

		return index, cur;
	end

	-- STRING
	decode['"'] = function( self, index, str, cache )
		local finish = find( str, '";', index, true );
		local res = gsub( sub( str, index, finish - 1 ), '\\;', ';' );
		index = finish + 2;

		cache[ #cache + 1 ] = res;
		return index, res;
	end
	-- STRING NO ESCAPING NEEDED
	decode['\''] = function( self, index, str, cache )
		local finish = find( str, ';', index, true );
		local res = sub( str, index, finish - 1 )
		index = finish + 1;

		cache[ #cache + 1 ] = res;
		return index, res;
	end

	-- NUMBER
	decode['n'] = function( self, index, str, cache )
		index = index - 1;
		local finish = find( str, ';', index, true );
		local num = tonumber( sub( str, index, finish - 1 ) );
		index = finish + 1;
		return index, num;
	end
	decode['0'] = decode['n'];
	decode['1'] = decode['n'];
	decode['2'] = decode['n'];
	decode['3'] = decode['n'];
	decode['4'] = decode['n'];
	decode['5'] = decode['n'];
	decode['6'] = decode['n'];
	decode['7'] = decode['n'];
	decode['8'] = decode['n'];
	decode['9'] = decode['n'];
	decode['-'] = decode['n'];
	-- positive hex
	decode['X'] = function( self, index, str, cache )
		local finish = find( str, ';', index, true );
		local num = tonumber( sub( str, index, finish - 1), 16 );
		index = finish + 1;
		return index, num;
	end
	-- negative hex
	decode['x'] = function( self, index, str, cache )
		local finish = find( str, ';', index, true );
		local num = -tonumber( sub( str, index, finish - 1), 16 );
		index = finish + 1;
		return index, num;
	end

	-- POINTER
	decode['('] = function( self, index, str, cache )
		local finish = find( str, ')', index, true );
		local num = tonumber( sub( str, index, finish - 1), 16 );
		index = finish + 1;
		return index, cache[ num ];
	end

	-- BOOLEAN. ONE DATA TYPE FOR YES, ANOTHER FOR NO.
	decode[ 't' ] = function( self, index )
		return index, true;
	end
	decode[ 'f' ] = function( self, index )
		return index, false;
	end

	-- VECTOR
	decode[ 'v' ] = function( self, index, str, cache )
		local finish =  find( str, ';', index, true );
		local vecStr = sub( str, index, finish - 1 );
		index = finish + 1; -- update the index.
		local segs = Explode( ',', vecStr, false );
		return index, Vector( tonumber( segs[1] ), tonumber( segs[2] ), tonumber( segs[3] ) );
	end
	-- ANGLE
	decode[ 'a' ] = function( self, index, str, cache )
		local finish =  find( str, ';', index, true );
		local angStr = sub( str, index, finish - 1 );
		index = finish + 1; -- update the index.
		local segs = Explode( ',', angStr, false );
		return index, Angle( tonumber( segs[1] ), tonumber( segs[2] ), tonumber( segs[3] ) );
	end
	-- ENTITY
	decode[ 'E' ] = function( self, index, str, cache )
		if( str[index] == '#' )then
			index = index + 1;
			return index, NULL ;
		else
			local finish = find( str, ';', index, true );
			local num = tonumber( sub( str, index, finish - 1 ) );
			index = finish + 1;
			return index, Entity( num );
		end
	end
	-- PLAYER
	decode[ 'P' ] = function( self, index, str, cache )
		local finish = find( str, ';', index, true );
		local num = tonumber( sub( str, index, finish - 1 ) );
		index = finish + 1;
		return index, Entity( num ) or NULL;
	end
	-- NIL
	decode['?'] = function( self, index, str, cache )
		return index + 1, nil;
	end


	function pon.decode( data )
		local _, res = decode[sub(data,1,1)]( decode, 2, data, {});
		return res;
	end
end

--[[
	NetStream - 2.1.0
	Alexander Grist-Hucker
	http://www.revotech.org

	Credits to:
		thelastpenguin for pON.
		https://github.com/thelastpenguin/gLUA-Library/tree/master/pON
--]]

local _player, util, type, pcall, pairs, ErrorNoHalt, net = player, util, type, pcall, pairs, ErrorNoHalt, net

netstream = netstream or {}

local stored = netstream.stored or {}
netstream.stored = stored

local cache = netstream.cache or {}
netstream.cache = cache

if (DBugR) then
	DBugR.Profilers.Netstream = table.Copy(DBugR.SP)
	DBugR.Profilers.Netstream.CChan = ""
	DBugR.Profilers.Netstream.Name = "Netstream"
	DBugR.Profilers.Netstream.Type = SERVICE_PROVIDER_TYPE_NET

	DBugR.Profilers.NetstreamPerf = table.Copy(DBugR.SP)
	DBugR.Profilers.NetstreamPerf.Name = "Netstream"
	DBugR.Profilers.NetstreamPerf.Type = SERVICE_PROVIDER_TYPE_CPU
end

-- A function to split data for a data stream.
function netstream.Split(data)
	local index = 1
	local result = {}
	local buffer = {}

	for i = 0, string.len(data) do
		buffer[#buffer + 1] = string.sub(data, i, i)

		if (#buffer == 32768) then
			result[#result + 1] = table.concat(buffer)
				index = index + 1
			buffer = {}
		end
	end

	result[#result + 1] = table.concat(buffer)

	return result
end

--[[
	@codebase Shared
	@details A function to hook a data stream.
	@param String A unique identifier.
	@param Function The datastream callback.
--]]
function netstream.Hook(name, Callback)
	stored[name] = Callback
end

if (DBugR) then
	local oldDS = netstream.Hook

	for name, func in pairs(stored) do
		stored[name] = nil

		oldDS(name, DBugR.Util.Func.AttachProfiler(func, function(time)
			DBugR.Profilers.NetstreamPerf:AddPerformanceData(tostring(name), time, func)
		end))
	end

	netstream.Hook = DBugR.Util.Func.AddDetourM(netstream.Hook, function(name, func, ...)
		func = DBugR.Util.Func.AttachProfiler(func, function(time)
			DBugR.Profilers.NetstreamPerf:AddPerformanceData(tostring(name), time, func)
		end)

		return name, func, ...
	end)
end

if (SERVER) then
	util.AddNetworkString("NetStreamDS")
	util.AddNetworkString("NetStreamHeavy")

	-- A function to start a net stream.
	function netstream.Start(player, name, ...)
		local recipients = {}
		local bShouldSend = false

		if (!istable(player)) then
			if (!player) then
				player = _player.GetAll()
			else
				player = {player}
			end
		end

		for k, v in ipairs(player) do
			if (type(v) == "Player") then
				recipients[#recipients + 1] = v

				bShouldSend = true
			end
		end

		local encodedData = pon.encode({...})

		if (encodedData and #encodedData > 0 and bShouldSend) then
			net.Start("NetStreamDS")
				net.WriteString(name)
				net.WriteUInt(#encodedData, 32)
				net.WriteData(encodedData, #encodedData)
			net.Send(recipients)
		end
	end

	if (DBugR) then
		netstream.Start = DBugR.Util.Func.AddDetour(netstream.Start, function(player, name, ...)
			local encodedData = pon.encode({...})

			DBugR.Profilers.Netstream:AddNetData(name, #encodedData)
		end)
	end

	-- A function to start a > 64KB net stream.
	function netstream.Heavy(player, name, ...)
		local recipients = {}
		local bShouldSend = false

		if (!istable(player)) then
			if (!player) then
				player = _player.GetAll()
			else
				player = {player}
			end
		end

		for k, v in ipairs(player) do
			if (type(v) == "Player") then
				recipients[#recipients + 1] = v

				bShouldSend = true
			end
		end

		local encodedData = pon.encode({...})
		local split = netstream.Split(encodedData)

		if (encodedData and #encodedData > 0 and bShouldSend) then
			for k, v in ipairs(split) do
				net.Start("NetStreamHeavy")
					net.WriteString(name)
					net.WriteUInt(#v, 32)
					net.WriteData(v, #v)
					net.WriteUInt(k, 8)
					net.WriteUInt(#split, 8)
				net.Send(recipients)
			end
		end
	end

	-- A function to listen for a request.
	function netstream.Listen(name, Callback)
		netstream.Hook(name, function(player, data)
			local bShouldReply, reply = Callback(player, data)

			if (bShouldReply) then
				netstream.Start(player, name, reply)
			end
		end)
	end

	net.Receive("NetStreamDS", function(length, player)
		local NS_DS_NAME = net.ReadString()
		local NS_DS_LENGTH = net.ReadUInt(32)
		local NS_DS_DATA = net.ReadData(NS_DS_LENGTH)

		if (NS_DS_NAME and NS_DS_DATA and NS_DS_LENGTH) then
			player.nsDataStreamName = NS_DS_NAME
			player.nsDataStreamData = ""

			if (player.nsDataStreamName and player.nsDataStreamData) then
				player.nsDataStreamData = NS_DS_DATA

				if (stored[player.nsDataStreamName]) then
					local bStatus, value = pcall(pon.decode, player.nsDataStreamData)

					if (bStatus) then
						stored[player.nsDataStreamName](player, unpack(value))
					else
						ErrorNoHalt("NetStream: '"..NS_DS_NAME.."'\n"..value.."\n")
					end
				end

				player.nsDataStreamName = nil
				player.nsDataStreamData = nil
			end
		end

		NS_DS_NAME, NS_DS_DATA, NS_DS_LENGTH = nil, nil, nil
	end)

	net.Receive("NetStreamHeavy", function(length, player)
		local NS_DS_NAME = net.ReadString()
		local NS_DS_LENGTH = net.ReadUInt(32)
		local NS_DS_DATA = net.ReadData(NS_DS_LENGTH)
		local NS_DS_PIECE = net.ReadUInt(8)
		local NS_DS_TOTAL = net.ReadUInt(8)

		if (NS_DS_NAME and NS_DS_DATA and NS_DS_LENGTH) then
			player.nsDataStreamName = NS_DS_NAME
			player.nsDataStreamData = ""

			if (!cache[player.nsDataStreamName]) then
				cache[player.nsDataStreamName] = ""
			end

			if (player.nsDataStreamName and player.nsDataStreamData) then
				player.nsDataStreamData = NS_DS_DATA

				if (NS_DS_PIECE < NS_DS_TOTAL) then
					if (NS_DS_PIECE == 1) then
						cache[player.nsDataStreamName] = ""
					end

					cache[player.nsDataStreamName] = cache[player.nsDataStreamName]..player.nsDataStreamData
				else
					cache[player.nsDataStreamName] = cache[player.nsDataStreamName]..player.nsDataStreamData

					if (stored[player.nsDataStreamName]) then
						local bStatus, value = pcall(pon.decode, cache[player.nsDataStreamName])

						if (bStatus) then
							stored[player.nsDataStreamName](player, unpack(value))
						else
							ErrorNoHalt("NetStream: '"..NS_DS_NAME.."'\n"..value.."\n")
						end
					end

					cache[player.nsDataStreamName] = nil
					player.nsDataStreamName = nil
					player.nsDataStreamData = nil
				end
			end
		end

		NS_DS_NAME, NS_DS_DATA, NS_DS_LENGTH, NS_DS_PIECE, NS_DS_TOTAL = nil, nil, nil, nil, nil
	end)
else
	-- A function to start a net stream.
	function netstream.Start(name, ...)
		local encodedData = pon.encode({...})

		if (encodedData and #encodedData > 0) then
			net.Start("NetStreamDS")
				net.WriteString(name)
				net.WriteUInt(#encodedData, 32)
				net.WriteData(encodedData, #encodedData)
			net.SendToServer()
		end
	end

	if (DBugR) then
		netstream.Start = DBugR.Util.Func.AddDetour(netstream.Start, function(name, ...)
			local encodedData = pon.encode({...})

			DBugR.Profilers.Netstream:AddNetData(name, #encodedData)
		end)
	end

	-- A function to start a net stream.
	function netstream.Heavy(name, ...)
		local dataTable = {...}
		local encodedData = pon.encode(dataTable)
		local split = netstream.Split(encodedData)

		if (encodedData and #encodedData > 0) then
			for k, v in ipairs(split) do
				net.Start("NetStreamHeavy")
					net.WriteString(name)
					net.WriteUInt(#v, 32)
					net.WriteData(v, #v)
					net.WriteUInt(k, 8)
					net.WriteUInt(#split, 8)
				net.SendToServer()
			end
		end
	end

	-- A function to send a request.
	function netstream.Request(name, data, Callback)
		netstream.Hook(name, Callback)		
		netstream.Start(name, data)
	end

	net.Receive("NetStreamDS", function(length)
		local NS_DS_NAME = net.ReadString()
		local NS_DS_LENGTH = net.ReadUInt(32)
		local NS_DS_DATA = net.ReadData(NS_DS_LENGTH)

		if (NS_DS_NAME and NS_DS_DATA and NS_DS_LENGTH) then
			if (stored[NS_DS_NAME]) then
				local bStatus, value = pcall(pon.decode, NS_DS_DATA)

				if (bStatus) then
					stored[NS_DS_NAME](unpack(value))
				else
					ErrorNoHalt("NetStream: '"..NS_DS_NAME.."'\n"..value.."\n")
				end
			end
		end

		NS_DS_NAME, NS_DS_DATA, NS_DS_LENGTH = nil, nil, nil
	end)

	net.Receive("NetStreamHeavy", function(length)
		local NS_DS_NAME = net.ReadString()
		local NS_DS_LENGTH = net.ReadUInt(32)
		local NS_DS_DATA = net.ReadData(NS_DS_LENGTH)
		local NS_DS_PIECE = net.ReadUInt(8)
		local NS_DS_TOTAL = net.ReadUInt(8)

		if (!cache[NS_DS_NAME]) then
			cache[NS_DS_NAME] = ""
		end

		if (NS_DS_NAME and NS_DS_DATA and NS_DS_LENGTH) then
			if (NS_DS_PIECE < NS_DS_TOTAL) then
				if (NS_DS_PIECE == 1) then
					cache[NS_DS_NAME] = ""
				end

				cache[NS_DS_NAME] = cache[NS_DS_NAME]..NS_DS_DATA
			else
				cache[NS_DS_NAME] = cache[NS_DS_NAME]..NS_DS_DATA

				if (stored[NS_DS_NAME]) then
					local bStatus, value = pcall(pon.decode, cache[NS_DS_NAME])

					if (bStatus) then
						stored[NS_DS_NAME](unpack(value))
					else
						ErrorNoHalt("NetStream Heavy: '"..NS_DS_NAME.."'\n"..value.."\n")
					end

					cache[NS_DS_NAME] = nil
				end
			end
		end

		NS_DS_NAME, NS_DS_DATA, NS_DS_LENGTH, NS_DS_PIECE, NS_DS_TOTAL = nil, nil, nil, nil, nil
	end)
end