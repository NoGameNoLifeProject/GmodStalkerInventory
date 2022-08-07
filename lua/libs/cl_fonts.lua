//Перенесено из основного гейммода
FONT_THEME = "MatterhornCTT"
FONT_GUI = "Roboto"
FONT_PAINT = "Graffiti1CTT"
FONT_SYMBOL = "Marlett"
FONT_PDA = "Verdana"

if not system.IsWindows() then

	FONT_PAINT = FONT_PDA

end

local fonts = {}

function Font(font, size, weight, symbol)
	
	assert(isstring(font), "font must be a string")
	assert(isnumber(size), "size must be a number")

	weight = weight or 300

	local name = font.."."..size.."."..weight

	if fonts[name] then return name end
	fonts[name] = true

	surface.CreateFont(name, {

		font = font,
		extended = true,
		size = size,
		weight = weight,
		symbol = symbol,
		
	})

	return name

end
