spawnmenu.AddContentType( "inventory_items", function( container, obj )
	local icon = vgui.Create( "ContentIcon", container )
	icon:SetName( obj.nicename )
	icon:SetMaterial( obj.material )
	icon.DoClick = function()
		netstream.Start("Inventory:CreateItemQMenu", obj.spawnname)
		surface.PlaySound( "ui/buttonclickrelease.wav" )
	end
	icon.OpenMenu = function( icon )

		local menu = DermaMenu()
			menu:AddOption( "Copy to Clipboard", function() SetClipboardText( obj.spawnname ) end )
		menu:Open()

	end
	
	if IsValid( container ) then
		container:Add( icon )
	end

	return icon

end )

hook.Add( "InventoryPopulateItems", "AddEntityContent", function( pnlContent, tree, node )

	local Categorised = {}
	-- Add this list into the tormoil
		for k, v in pairs( Inventory.Items ) do
			v.Category = v.Category or "Other"
			Categorised[ v.Category ] = Categorised[ v.Category ] or {}
			v.ClassName = k
			v.PrintName = v.Name
			table.insert( Categorised[ v.Category ], v )

		end
	--
	-- Add a tree node for each category
	--
	for CategoryName, v in SortedPairs( Categorised ) do

		-- Add a node to the tree
		local node = tree:AddNode( CategoryName, "icon16/bricks.png" )
		
			-- When we click on the node - populate it using this function
		node.DoPopulate = function( self )
			
			-- If we've already populated it - forget it.
			if self.PropPanel then return end
			
			-- Create the container panel
			self.PropPanel = vgui.Create( "ContentContainer", pnlContent )
			self.PropPanel:SetVisible( false )
			self.PropPanel:SetTriggerSpawnlistChange( false )
			
			for k, ent in SortedPairsByMemberValue( v, "PrintName" ) do
				
				spawnmenu.CreateContentIcon( "inventory_items", self.PropPanel, {
					nicename	= ent.PrintName or ent.ClassName,
					spawnname	= ent.Id,
					material	= ent.IconMat,
				} )
				
			end
			
		end
		
		-- If we click on the node populate it and switch to it.
		node.DoClick = function( self )
			
			self:DoPopulate()
			pnlContent:SwitchPanel( self.PropPanel )
			
		end

	end
	

end )

spawnmenu.AddCreationTab( "Inventory Items", function()
	local ctrl = vgui.Create( "SpawnmenuContentPanel" )
	ctrl:CallPopulateHook( "InventoryPopulateItems" )
	return ctrl
end, "icon16/server_chart.png", 150 )