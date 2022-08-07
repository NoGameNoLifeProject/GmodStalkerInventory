Inventory = Inventory or {}

function Inventory:LoadFile(path)
    local filename = path:GetFileFromFilename()
    filename = filename ~= "" and filename or path

    local CL    = filename:StartWith("cl_")
    local SV    = filename:StartWith("sv_")
    local SH    = filename:StartWith("sh_")

    if (SERVER) then
        if (CL or SH) then
            AddCSLuaFile(path); 
        end
        if (SV or SH) then 
            include(path);
        end
    elseif (CL or SH) then
        include(path);
    end
end

function Inventory:LoadDirectory(dir)
    local files, folders = file.Find(dir .. "/*", "LUA")

    for _, v in ipairs(files) do 
        self:LoadFile(dir .. "/" .. v)
    end

    for _, v in ipairs(folders) do 
        self:LoadDirectory(dir .. "/" .. v)
    end
end

Inventory:LoadFile("sh_config.lua")
Inventory:LoadDirectory("libs")
Inventory:LoadDirectory("inventory")
Inventory:LoadDirectory("items")
Inventory:LoadDirectory("stamina")
Inventory:LoadDirectory("effects")
Inventory:LoadFile("cl_items_tab.lua")