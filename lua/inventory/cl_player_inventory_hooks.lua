Inventory = Inventory or {}

hook.Add("HUDPaint", "Inventory:HUDPaint", function()
	local inventory = LocalPlayer():GetBetterNWTable("Inventory")
	for i = 1, 4 do
		if inventory.CustomSlots and inventory.CustomSlots.QuickSlots[i] then
			local item = inventory.CustomSlots.QuickSlots[i]
			local itemTable = Inventory:GetItemByID(item.ID)
			surface.SetMaterial( Material(itemTable.IconMat) )
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawTexturedRect( 50+65*(i-1), ScrH() - 100, 48, 48 )
			draw.ShadowSimpleText("x"..item.Amount, Inventory.cfg.vgui.fonts.theme30, 50+65*(i-1), ScrH() - 50, Inventory.cfg.vgui.colors.mainTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			draw.ShadowSimpleText("F "..i, Inventory.cfg.vgui.fonts.theme30, 90+65*(i-1), ScrH() - 65, Inventory.cfg.vgui.colors.mainTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		end
	end

	local playerEffects = LocalPlayer():GetStatEffects()
	if table.IsEmpty(playerEffects) then return end
	local ind = 0
	for k, v in pairs(playerEffects) do
		local force = math.Round(math.Remap(v.Force, 0, 10, 1, 4))
		force = force <= 4 and force or 4
		if (Inventory.cfg.effectsIcons[k] and Inventory.cfg.effectsIcons[k][force]) then
			surface.SetMaterial( Inventory.cfg.effectsIcons[k][force] )
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawTexturedRect( ScrW() - 70, ScrH() - 240 - 65*ind, 48, 48 )
			ind = ind + 1
		end
	end
end)


local lasttime  = CurTime()
hook.Add( "Think", "Inventory:PressButtonThink", function(ply)
    if (input.IsKeyDown( KEY_I ) or input.IsKeyDown( KEY_TAB )) and (IsValid(Inventory.PlayerInventoryMenu) or (!vgui.CursorVisible() and !gui.IsConsoleVisible() and !(_IsPDAActive))) then
    	if lasttime+1 < CurTime() then
			lasttime = CurTime()
			if IsValid(Inventory.PlayerInventoryMenu) then 
				Inventory.PlayerInventoryMenu:Remove()
			else
				Inventory:OpenPlayerInventory()
			end
        end
    elseif input.IsKeyDown( KEY_F1  ) then
		if lasttime+1 < CurTime() then
			lasttime = CurTime()
			netstream.Start("Inventory:UseInventoryItem", nil, 1, nil, 1)
		end
    elseif input.IsKeyDown( KEY_F2  ) then
		if lasttime+1 < CurTime() then
			lasttime = CurTime()
			netstream.Start("Inventory:UseInventoryItem", nil, 1, nil, 2)
		end
    elseif input.IsKeyDown( KEY_F3  ) then
		if lasttime+1 < CurTime() then
			lasttime = CurTime()
			netstream.Start("Inventory:UseInventoryItem", nil, 1, nil, 3)
		end
    elseif input.IsKeyDown( KEY_F4  ) then
		if lasttime+1 < CurTime() then
			lasttime = CurTime()
			netstream.Start("Inventory:UseInventoryItem", nil, 1, nil, 4)
		end
	end
end)

hook.Add( "KeyPress", "Inventory:RagdollUse", function( ply, key )
	if ply:Alive() then   
    	if key == IN_USE then 
    		local tr = ply:GetEyeTrace( )
    		if IsValid( tr.Entity ) and tr.Entity:GetClass( ) == "prop_ragdoll" and !Inventory:IsEntityLocked(tr.Entity) and tr.HitPos:Distance(ply:EyePos()) < 120 and tr.Entity:GetBetterNWTable("Inventory") then
    			Inventory:LockEntity(tr.Entity)
    			netstream.Start("Inventory:SyncEntityInventory", tr.Entity, true)
    		end
    	end
    end
end)

hook.Add( "Think", "PlayerIsLoaded", function()
	if IsValid( LocalPlayer() ) then
		hook.Remove( "Think", "PlayerIsLoaded" )
		netstream.Start("PlayerIsLoaded")
	end
end)