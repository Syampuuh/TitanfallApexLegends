global function OptionsColor_GetCurrentColor
global function OptionsColor_GetDefaultColor
global function OptionsColor_UpdateColorSliders

global function OptionsColor_RGBToHSV
global function OptionsColor_HSVToRGB
global function OptionsColor_VectorToHSV
global function OptionsColor_HSVToVector
global function OptionsColor_HasColorChanged


vector function OptionsColor_GetCurrentColor( string convar, vector defaultColor )
{
	array<string> currentColor = split( GetConVarString(convar), WHITESPACE_CHARACTERS )

	if(currentColor.len() == 3)                                                          
		return < int(currentColor[0]), int(currentColor[1]), int(currentColor[2]) >
	else
		return defaultColor

	unreachable
}
vector function OptionsColor_GetDefaultColor( int colorID )
{
	return ColorPalette_GetDefaultColorFromID( colorID )
}

void function OptionsColor_UpdateColorSliders( var panel, var H_Slider, var SV_Slider, vector currentColor, float H_Progress, float SV_Progress )
{

	var rui_H = Hud_GetRui( H_Slider )
	var rui_SV = Hud_GetRui( SV_Slider )

	                                                                           
	                                                                                                 
	HSV hueColor
	hueColor.hue = H_Progress * 360
	hueColor.saturation = 1.0
	hueColor.value = 1.0
	vector H_safeRGB = SrgbToLinear( OptionsColor_HSVToRGB( hueColor ) / 255.0 )

	                                                                  
	HSV currentHSVColor = OptionsColor_RGBToHSV( currentColor )
	currentHSVColor.hue = H_Progress * 360
	vector SV_safeRGB = SrgbToLinear( OptionsColor_HSVToRGB( currentHSVColor ) / 255.0 )

	              
	RuiSetFloat( rui_H , "progress", H_Progress )
	RuiSetColorAlpha( rui_H, "hueColor", H_safeRGB, 1.0  )
	Hud_SliderControl_SetCurrentValue( Hud_GetChild( panel, "H_Slider" ), H_Progress )

	               
	RuiSetFloat( rui_SV, "progress", SV_Progress )
	RuiSetColorAlpha( rui_SV, "hueColor", H_safeRGB, 1.0  )
	RuiSetColorAlpha( rui_SV, "selectedColor", SV_safeRGB, 1.0  )
	Hud_SliderControl_SetCurrentValue( Hud_GetChild( panel, "SV_Slider" ),  SV_Progress )
}


               
HSV function OptionsColor_RGBToHSV( vector rgb )
{
	HSV hsv
	vector hsvVec


	hsvVec = ColorPalette_RGBtoHSV( rgb )

	hsv = OptionsColor_VectorToHSV( hsvVec )

	return hsv
}

vector function OptionsColor_HSVToRGB( HSV hsv )
{
	vector rgb
	vector hsvVec

	hsvVec = OptionsColor_HSVToVector( hsv )
	rgb = ColorPalette_HSVtoRGB( hsvVec )

	return rgb
}

HSV function OptionsColor_VectorToHSV( vector vec )
{
	HSV hsv
	hsv.hue = vec.x
	hsv.saturation = vec.y
	hsv.value = vec.z
	return hsv
}
vector function OptionsColor_HSVToVector( HSV hsv )
{
	vector vec
	vec.x = hsv.hue
	vec.y = hsv.saturation
	vec.z = hsv.value
	return vec
}

bool function OptionsColor_HasColorChanged( vector previousColor, vector currentColor ){
	return previousColor.x != currentColor.x || previousColor.y != currentColor.y ||  previousColor.z != currentColor.z
}