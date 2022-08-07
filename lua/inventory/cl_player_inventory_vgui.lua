Inventory = Inventory or {}

function Inventory:OpenPlayerInventory(container)
	local ww, hh = ScrW(), ScrH()
	local coefx = (1/1920)*ww
	local coefy = (1/1080)*hh
	if IsValid(Inventory.PlayerInventoryMenu) then Inventory.PlayerInventoryMenu:Remove() end
	Inventory.PlayerInventoryMenu = vgui.Create("DButton")
	Inventory.PlayerInventoryMenu:SetPos(0, 0)
	Inventory.PlayerInventoryMenu:SetSize(ww, hh)
	Inventory.PlayerInventoryMenu:MakePopup()
	Inventory.PlayerInventoryMenu:SetText("")
	Inventory.PlayerInventoryMenu.Paint = function(w, h) end
	Inventory.PlayerInventoryMenu.DoClick = function()
		Inventory.PlayerInventoryMenu:Remove()
	end
	Inventory.PlayerInventoryMenu.OnRemove = function(pnl)
		if (IsValid(container) and !container.IsPlayerBox) then
			Inventory:UnLockEntity(container)
		end
	end

	TooltipTitlePanel = vgui.Create( "DLabel", Inventory.PlayerInventoryMenu)
	TooltipTitlePanel:SetDrawOnTop(true)
	TooltipTitlePanel:SetSize( 278, 256 )
	TooltipTitlePanel:SetPos( ww, hh )
	TooltipTitlePanel:SetFont(Inventory.cfg.vgui.fonts.symbol30)
	TooltipTitlePanel:SetWrap(true)
	TooltipTitlePanel:SetVisible( false )
	TooltipTitlePanel:SetText("")
	TooltipTitlePanel.Think = function( pnl )
		local x, y = input.GetCursorPos()
		if (x + pnl:GetWide() >= ww ) then
			x = x - pnl:GetWide()
		end
		if (y + pnl:GetTall() + TooltipDescPanel:GetTall() + (TooltipEffectsDescPanel:IsVisible() and TooltipEffectsDescPanel:GetTall() or 0) >= hh) then
			y = y - pnl:GetTall() - TooltipDescPanel:GetTall() - (TooltipEffectsDescPanel:IsVisible() and TooltipEffectsDescPanel:GetTall() or 0)
		end
		pnl:SetPos( x + 15, y + 15)
		TooltipDescPanel:SetPos( x + 15, y + 15 + TooltipTitlePanel:GetTall())
		TooltipEffectsDescPanel:SetPos( x + 15, y + 15 + TooltipTitlePanel:GetTall() + 5 + TooltipDescPanel:GetTall())
	end

	TooltipDescPanel = vgui.Create( "DLabel", Inventory.PlayerInventoryMenu)
	TooltipDescPanel:SetDrawOnTop(true)
	TooltipDescPanel:SetSize( 278, 256 )
	TooltipDescPanel:SetPos( ww, hh)
	TooltipDescPanel:SetFont(Inventory.cfg.vgui.fonts.symbol20)
	TooltipDescPanel:SetWrap(true)
	TooltipDescPanel:SetVisible( false )
	TooltipDescPanel:SetText("")

	TooltipEffectsDescPanel = vgui.Create( "DLabel", Inventory.PlayerInventoryMenu)
	TooltipEffectsDescPanel:SetDrawOnTop(true)
	TooltipEffectsDescPanel:SetSize( 278, 256 )
	TooltipEffectsDescPanel:SetPos( ww, hh)
	TooltipEffectsDescPanel:SetVisible( false )
	TooltipEffectsDescPanel:SetText("")
	TooltipEffectsDescPanel.Paint = function(pnl, w, h)
		if !istable(pnl.EffectsDesc) then return end
		local index = 0
		local color
		for k, v in ipairs(pnl.EffectsDesc) do
			if v.state == 1 then
				color = Inventory.cfg.vgui.colors.greenColor
			elseif v.state == 3 then
				color = Inventory.cfg.vgui.colors.redColor
			else
				color = Inventory.cfg.vgui.colors.mainTextColor
			end
			draw.ShadowSimpleText(v.title, Inventory.cfg.vgui.fonts.theme20, 5, 18*index, Inventory.cfg.vgui.colors.mainTextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.ShadowSimpleText(v.value, Inventory.cfg.vgui.fonts.theme20, w - 30, 18*index, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.ShadowSimpleText(v.unit, Inventory.cfg.vgui.fonts.theme20, w - 5, 18*index, Inventory.cfg.vgui.colors.mainTextColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			index = index + 1
		end
		pnl:SetSize(w, 18*index)
	end
	Inventory.PlayerInventoryMenu.Think = function( pan )
		local button = vgui.GetHoveredPanel() 
		if button then 
			if button.TooltipTitle then
				if button.TooltipDesc then
					TooltipTitlePanel:SetVisible( true )
					TooltipDescPanel:SetVisible( true )
					TooltipTitlePanel:SetText(button.TooltipTitle)
					TooltipTitlePanel:SizeToContentsY()
					TooltipDescPanel:SetText(button.TooltipDesc)
					TooltipDescPanel:SizeToContentsY()
					if button.TooltipEffectsDesc then
						TooltipEffectsDescPanel:SetVisible( true )
						TooltipEffectsDescPanel.EffectsDesc = button.TooltipEffectsDesc
					else
						TooltipEffectsDescPanel:SetVisible( false )
					end
				end
			else
				TooltipTitlePanel:SetVisible( false ) 
				TooltipDescPanel:SetVisible( false )
				TooltipEffectsDescPanel:SetVisible( false )
			end
		else
			TooltipTitlePanel:SetVisible( false ) 
			TooltipDescPanel:SetVisible( false )
			TooltipEffectsDescPanel:SetVisible( false )
		end
	end

	if IsValid(PlayerBlockFrame) then PlayerBlockFrame:Remove() end
	PlayerBlockFrame = vgui.Create("DFrame", Inventory.PlayerInventoryMenu)
	PlayerBlockFrame:SetPos(ww - (620 + 15) * coefx, 15)
	PlayerBlockFrame:SetSize(620 * coefx, 1050 * coefy)
	PlayerBlockFrame:SetTitle("")
	PlayerBlockFrame:ShowCloseButton(false)
	PlayerBlockFrame:SetDraggable(false)
	PlayerBlockFrame:MakePopup()
	PlayerBlockFrame.Paint = function(pnl, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Inventory.cfg.vgui.colors.backgrundColor)
		draw.StencilBlur(pnl, w, h)
	end

	local playerInfo = vgui.Create("InventoryInfoBlock", PlayerBlockFrame)
	playerInfo:SetPos(10 * coefx, 10 * coefy)
	playerInfo:SetSize(405 * coefx, 140 * coefy)
	playerInfo:SetSizeCoef(coefx, coefy)
	playerInfo:SetEntity(LocalPlayer())

	local pInfoX, pInfoY = playerInfo:GetPos()
	local pInfoW, pInfoH = playerInfo:GetSize()
	local playerCommunityIcon = vgui.Create("InventoryCommunityIconBlock", PlayerBlockFrame)
	playerCommunityIcon:SetPos(10 * coefx + pInfoX + pInfoW, pInfoY)
	playerCommunityIcon:SetSize(185 * coefx, 140 * coefy)
	playerCommunityIcon:SetSizeCoef(coefx, coefy)
	playerCommunityIcon:SetEntity(LocalPlayer())

	local playerInventory = vgui.Create("InventoryInventoryBlock", PlayerBlockFrame)
	playerInventory:SetEntity(LocalPlayer())
	playerInventory:SetPos(10 * coefx, 10 * coefy + pInfoH + pInfoY)
	playerInventory:SetSize(595 * coefx, 835 * coefy)
	playerInventory:SetInTrade(container and container:IsNextBot())
	playerInventory:SetSizeCoef(coefx, coefy)
	playerInventory:Build()

	local pIventoryX, pIventoryY = playerInventory:GetPos()
	local pIventoryW, pIventoryH = playerInventory:GetSize()
	local playerBottom = vgui.Create("InventoryBottomBlock", PlayerBlockFrame)
	playerBottom:SetPos(10 * coefx, 10 * coefy + pIventoryH + pIventoryY)
	playerBottom:SetSize(600 * coefx, 35 * coefy)
	playerBottom:SetSizeCoef(coefx, coefy)
	playerBottom:SetEntity(LocalPlayer())
	playerBottom:Build()

	if IsValid(AmmunationBlockFrame) then AmmunationBlockFrame:Remove() end
	AmmunationBlockFrame = vgui.Create("DFrame", Inventory.PlayerInventoryMenu)
	AmmunationBlockFrame:SetPos(ww - (620 + 15) * coefx * 2, 15)
	AmmunationBlockFrame:SetSize(620 * coefx, 1050 * coefy)
	AmmunationBlockFrame:SetTitle("")
	AmmunationBlockFrame:ShowCloseButton(false)
	AmmunationBlockFrame:SetDraggable(false)
	AmmunationBlockFrame:MakePopup()
	AmmunationBlockFrame.Paint = function(pnl, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Inventory.cfg.vgui.colors.backgrundColor)
		draw.StencilBlur(pnl, w, h)
	end

	local playerAmmunationBlock = vgui.Create("InventoryAmmunationBlock", AmmunationBlockFrame)
	playerAmmunationBlock:SetPos(10 * coefx, 10 * coefy)
	playerAmmunationBlock:SetSize(600 * coefx, 480 * coefy)
	playerAmmunationBlock:SetEntity(LocalPlayer())
	playerAmmunationBlock:SetSizeCoef(coefx, coefy)
	playerAmmunationBlock:Build()
	
	local pAmmunationX, pAmmunationY = playerAmmunationBlock:GetPos()
	local pAmmunationW, pAmmunationH = playerAmmunationBlock:GetSize()
	local playerQuickSlotsBlock = vgui.Create("InventoryQuickSlotsBlock", AmmunationBlockFrame)
	playerQuickSlotsBlock:SetPos(15 * coefx, pAmmunationY + pAmmunationH + 5 * coefy)
	playerQuickSlotsBlock:SetSize(600 * coefx, 105 * coefy)
	playerQuickSlotsBlock:SetEntity(LocalPlayer())
	playerQuickSlotsBlock:SetSizeCoef(coefx, coefy)
	playerQuickSlotsBlock:Build()
	
	local pFastSlotsX, pFastSlotsY = playerQuickSlotsBlock:GetPos()
	local pFastSlotsW, pFastSlotsH = playerQuickSlotsBlock:GetSize()
	local playerArtSlotsBlock = vgui.Create("InventoryArtSlotsBlock", AmmunationBlockFrame)
	playerArtSlotsBlock:SetPos(12 * coefx, pFastSlotsY + pFastSlotsH + 5 * coefy)
	playerArtSlotsBlock:SetSize(600 * coefx, 105 * coefy)
	playerArtSlotsBlock:SetEntity(LocalPlayer())
	playerArtSlotsBlock:SetSizeCoef(coefx, coefy)
	playerArtSlotsBlock:Build()
	
	local pArtSlotsX, pArtSlotsY = playerArtSlotsBlock:GetPos()
	local pArtSlotsW, pArtSlotsH = playerArtSlotsBlock:GetSize()
	//local playerStatusBlock = vgui.Create("InventoryStatusBlock", AmmunationBlockFrame)
	//playerStatusBlock:SetPos(10 * coefx, pArtSlotsY + pArtSlotsH + 5 * coefy)
	//playerStatusBlock:SetSize(600 * coefx, 70 * coefy)
	//playerStatusBlock:SetSizeCoef(coefx, coefy)
	
	//local pStatusX, pStatusY = playerStatusBlock:GetPos()
	//local pStatusW, pStatusH = playerStatusBlock:GetSize()
	local playerArmorInfoBlock = vgui.Create("InventoryArmorInfoBlock", AmmunationBlockFrame)
	playerArmorInfoBlock:SetPos(10 * coefx, pArtSlotsY + pArtSlotsH + 5 * coefy)
	playerArmorInfoBlock:SetSize(600 * coefx, 290 * coefy)
	playerArmorInfoBlock:SetSizeCoef(coefx, coefy)
	
	local pArmorInfoX, pArmorInfoY = playerArmorInfoBlock:GetPos()
	local pArmorInfoW, pArmorInfoH = playerArmorInfoBlock:GetSize()
	local playerAmmunationBottom = vgui.Create("InventoryBottomBlock", AmmunationBlockFrame)
	playerAmmunationBottom:SetPos(10 * coefx, pArmorInfoY + pArmorInfoH + 5 * coefy)
	playerAmmunationBottom:SetSize(600 * coefx, 35 * coefy)
	playerAmmunationBottom:SetIsAmmunation(true)
	playerAmmunationBottom:SetSizeCoef(coefx, coefy)
	playerAmmunationBottom:Build()

	if IsValid(container) then
		if IsValid(ContainerBlockFrame) then ContainerBlockFrame:Remove() end
		ContainerBlockFrame = vgui.Create("DFrame", Inventory.PlayerInventoryMenu)
		ContainerBlockFrame:SetPos(ww - (620 + 15) * coefx * 3, 15)
		ContainerBlockFrame:SetSize(620 * coefx, 1050 * coefy)
		ContainerBlockFrame:SetTitle("")
		ContainerBlockFrame:ShowCloseButton(false)
		ContainerBlockFrame:SetDraggable(false)
		ContainerBlockFrame:MakePopup()
		ContainerBlockFrame.Paint = function(pnl, w, h)
			draw.RoundedBox(0, 0, 0, w, h, Inventory.cfg.vgui.colors.backgrundColor)
			draw.StencilBlur(pnl, w, h)
		end

		local containerCommunityIcon = vgui.Create("InventoryCommunityIconBlock", ContainerBlockFrame)
		containerCommunityIcon:SetPos(10 * coefx, 10 * coefy)
		containerCommunityIcon:SetSize(185 * coefx, 140 * coefy)
		containerCommunityIcon:SetSizeCoef(coefx, coefy)
		containerCommunityIcon:SetEntity(container:IsNextBot() and container or LocalPlayer())
		containerCommunityIcon:SetIsPlayerBox(container.IsPlayerBox)
		containerCommunityIcon:SetIsContainer(container.IsContainer)
		
		local cInfoX, cInfoY = containerCommunityIcon:GetPos()
		local cInfoW, cInfoH = containerCommunityIcon:GetSize()
		local containerInfo = vgui.Create("InventoryInfoBlock", ContainerBlockFrame)
		containerInfo:SetPos(10 * coefx + cInfoX + cInfoW, cInfoY)
		containerInfo:SetSize(405 * coefx, 140 * coefy)
		containerInfo:SetSizeCoef(coefx, coefy)
		containerInfo:SetEntity(container:IsNextBot() and container or LocalPlayer())
		containerInfo:SetIsPlayerBox(container.IsPlayerBox)
		containerInfo:SetIsContainer(container.IsContainer)
	
		local containerInventory = vgui.Create("InventoryInventoryBlock", ContainerBlockFrame)
		containerInventory:SetEntity(container.IsPlayerBox and LocalPlayer() or container)
		containerInventory:SetPos(10 * coefx, cInfoH + cInfoY + 10 * coefy)
		containerInventory:SetSize(595 * coefx, 835 * coefy)
		containerInventory:SetSizeCoef(coefx, coefy)
		containerInventory:SetIsPlayerBox(container.IsPlayerBox)
		containerInventory:SetIsNPC(container:IsNextBot())
		containerInventory:Build()
	
		local cIventoryX, cIventoryY = containerInventory:GetPos()
		local cIventoryW, cIventoryH = containerInventory:GetSize()
		local containerBottom = vgui.Create("InventoryBottomBlock", ContainerBlockFrame)
		containerBottom:SetPos(10 * coefx, 10 * coefy + cIventoryH + cIventoryY)
		containerBottom:SetSize(600 * coefx, 35 * coefy)
		containerBottom:SetIsContainer(true)
		containerBottom:SetSizeCoef(coefx, coefy)
		containerBottom:SetEntity(container)
		containerBottom:SetIsPlayerBox(container.IsPlayerBox)
		containerBottom:Build()
	end
end

netstream.Hook("Inventory:OpenPlayerInventory", function(container)
	Inventory:OpenPlayerInventory(container)
end)