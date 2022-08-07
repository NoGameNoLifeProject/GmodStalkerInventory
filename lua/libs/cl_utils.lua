local blur = Material("pp/blurscreen", "noclamp")
function draw.StencilBlur( panel, w, h )
	render.ClearStencil()
	render.SetStencilEnable( true )
	render.SetStencilReferenceValue( 1 )
	render.SetStencilTestMask( 1 )
	render.SetStencilWriteMask( 1 )

	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
	render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilZFailOperation( STENCILOPERATION_REPLACE )

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawRect( 0, 0, w, h )

	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilPassOperation( STENCILOPERATION_KEEP )
	render.SetStencilZFailOperation( STENCILOPERATION_KEEP )

		surface.SetMaterial( blur )
		surface.SetDrawColor( 255, 255, 255, 255 )

		for i = 0, 1, 0.33 do
			blur:SetFloat( '$blur', 5 *i )
			blur:Recompute()
			render.UpdateScreenEffectTexture()

			local x, y = panel:GetPos()

			surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
		end

	render.SetStencilEnable( false )
end

local color_white = Color(255,255,255,255)
function draw.RectangleCorners(w, h, color)
	color = color or color_white
	draw.RoundedBox(0, 0, 0, 10, 2, color_white)
	draw.RoundedBox(0, 0, 0, 2, 10, color_white)
	draw.RoundedBox(0, w-10, 0, w, 2, color_white)
	draw.RoundedBox(0, w-2, 0, w, 10, color_white)
	draw.RoundedBox(0, 0, h-10, 2, h, color_white)
	draw.RoundedBox(0, 0, h-2, 10, h, color_white)
	draw.RoundedBox(0, w-10, h-2, w, h, color_white)
	draw.RoundedBox(0, w-2, h-10, w, h, color_white)
end


function draw.DrawMaskRectangle(x, y, w, h, func)
	render.ClearStencil()
	render.SetStencilEnable(true)

	render.SetStencilWriteMask(1)
	render.SetStencilTestMask(1)

	render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
	render.SetStencilPassOperation(STENCILOPERATION_ZERO)
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
	render.SetStencilReferenceValue(1)

	surface.SetDrawColor(255, 255, 255, 255)
	draw.NoTexture()
	surface.DrawRect(x, y, w, h)
	//surface.DrawPoly(mask)

	render.SetStencilFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
	render.SetStencilReferenceValue(1)

	func()

	render.SetStencilEnable(false)
	render.ClearStencil()
end
