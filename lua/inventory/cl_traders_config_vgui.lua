Inventory = Inventory or {}

function Inventory:OpenTradersConfig(traders)
	local ww, hh = ScrW(), ScrH()
	local coefx = (1/1920)*ww
	local coefy = (1/1080)*hh
	if IsValid(Inventory.TradersConfigMenu) then Inventory.TradersConfigMenu:Remove() end
	Inventory.TradersConfigMenu = vgui.Create("DButton")
	Inventory.TradersConfigMenu:SetPos(0, 0)
	Inventory.TradersConfigMenu:SetSize(ww, hh)
	Inventory.TradersConfigMenu:MakePopup()
	Inventory.TradersConfigMenu:SetText("")
	Inventory.TradersConfigMenu.Paint = function(w, h) end
	Inventory.TradersConfigMenu.DoClick = function()
		Inventory.TradersConfigMenu:Remove()
	end

	if IsValid(ConfigBlockFrame) then ConfigBlockFrame:Remove() end
	ConfigBlockFrame = vgui.Create("DFrame", Inventory.TradersConfigMenu)
	ConfigBlockFrame:SetPos(ww/2 - (1420 + 15) * coefx / 2, 15)
	ConfigBlockFrame:SetSize(1420 * coefx, 1050 * coefy)
	ConfigBlockFrame:SetTitle("")
	ConfigBlockFrame:ShowCloseButton(false)
	ConfigBlockFrame:SetDraggable(false)
	ConfigBlockFrame:MakePopup()
	ConfigBlockFrame.Paint = function(pnl, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Inventory.cfg.vgui.colors.backgrundColor)
		draw.StencilBlur(pnl, w, h)
	end

	local tradersScroller = vgui.Create( "DHorizontalScroller", ConfigBlockFrame )
	tradersScroller:SetPos(10 * coefx, 10 * coefy)
	tradersScroller:SetSize(1400 * coefx, 40 * coefy)
	tradersScroller:SetOverlap( -4 )
	
	function tradersScroller.btnLeft:Paint( w, h )
		draw.ShadowSimpleText("<", Inventory.cfg.vgui.fonts.theme30, w/2, h/2, Inventory.cfg.vgui.colors.mainTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	function tradersScroller.btnRight:Paint( w, h )
		draw.ShadowSimpleText(">", Inventory.cfg.vgui.fonts.theme30, w/2, h/2, Inventory.cfg.vgui.colors.mainTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	local selectedButton, tradersConfigBlock
	local isFirst = true
	for k, v in pairs(traders) do
		local button = vgui.Create("DButton", tradersScroller)
		button:SetSize(400, 38)
		button:SetText("")
		button.Paint = function(pnl, w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 200 ) )
			if pnl:IsHovered() or pnl.Selected then
				draw.RoundedBox(0, 0, 0, w, 1, Color(240,240,240,170) )
				draw.RoundedBox(0, 0, h-1, w, 1, Color(240,240,240,170) )
				draw.RoundedBox(0, 0, 0, 1, h, Color(240,240,240,170) )
				draw.RoundedBox(0, w-1, 0, 1, h, Color(240,240,240,170) )
				draw.SimpleText( k, Inventory.cfg.vgui.fonts.theme30, w/2, h/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText( k, Inventory.cfg.vgui.fonts.theme30, w/2, h/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end
		button.DoClick = function(pnl)
			if IsValid(selectedButton) then selectedButton.Selected = false end
			pnl.Selected = true
			selectedButton = pnl
			tradersConfigBlock:SetEntity(v)
			tradersConfigBlock:ReBuild()
		end
		tradersScroller:AddPanel( button )
		if isFirst then
			button.Selected = true
			selectedButton = button
			tradersConfigBlock = vgui.Create("InventoryTradersConfigBlock", ConfigBlockFrame)
			tradersConfigBlock:SetPos(5 * coefx, 10 * coefy + 5 + 40 * coefy)
			tradersConfigBlock:SetSize(1400 * coefx, ConfigBlockFrame:GetTall() - 10 * coefy - 5 - 40 * coefy - 20)
			tradersConfigBlock:SetEntity(v)
			tradersConfigBlock:SetSizeCoef(coefx, coefy)
			tradersConfigBlock:Build()
			tradersConfigBlock:ReBuild()
		end
		isFirst = false
	end
end

netstream.Hook("Inventory:OpenTradersConfig", function(traders)
	Inventory:OpenTradersConfig(traders)
end)