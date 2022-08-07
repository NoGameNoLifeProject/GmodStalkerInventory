Inventory = Inventory or {}
Inventory.Utils = Inventory.Utils or {}

local len = string.len
local sub = string.sub
local random = math.random

local function scramble(s)
	local n = ""
	for i=1,len(s) do
		local l = len(s)
		if l > 1 then
			local r = random(1,l)
			n = n .. sub(s,r,r)
			s = sub(s, 1, r-1) .. sub(s,r+1, l)
		else
			n = n..s
		end
	end
	return n
end

//Мне нужен генератор гуида, а придумывать мне было лень. Я хз откуда это, но я его когда то сохранил, наверное сойдет
function Inventory.Utils:GenerateGuid(a,b)
	local h = ""
	local k = scramble("Zuf2txeXAOHqj8ySD4Wo3LbIgnN5vhadpFzPCmB0VQGwK9l1UciRrTMEsJY6k7")
	for i=1,a do
		for l=1,b do
			local r = random(1,len(k))
			h=h..sub(k,r,r)
		end
		h=h.."-"
	end
	return sub(h,1,len(h)-1)
end