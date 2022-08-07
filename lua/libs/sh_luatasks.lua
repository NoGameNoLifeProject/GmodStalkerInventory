//Перенесено из основного гейммода
tasks = {}
local stack = {}

function AddLuaTask(func)

	if !isfunction(func) then return end

	table.insert(stack, #stack+1, func)

end

function LuaTasksCount()

	return #stack

end

hook.Add("Tick", "Tasks:Tick", function()

	if !next(stack) then return end

	local func = table.remove(stack, 1)
	if !isfunction(func) then return end
	
	pcall(func) 

end)