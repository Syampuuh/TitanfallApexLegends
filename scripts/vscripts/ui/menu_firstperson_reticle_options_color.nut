global function InitFirstPersonReticleOptionsColorPanel

struct
{
	var					panel

	var                	defaultColorBtn
	table<var, vector>  paletteColorBtns
	var                	previousColorBtn
	var                	applyMannualColorBtn
	var                	applyMannualColorBtnBG

	var                	RTextArea
	var                	GTextArea
	var                	BTextArea

	var 				H_Slider
	var 				SV_Slider

	var                	previousCurrentColorPane

	vector				defaultColor
	vector				currentColor
	vector				previousColor
	array<vector> 		palettes = [
		<235, 243, 0>,
		<7, 55, 255>,
		<255, 0, 194>,
		<0, 237, 187>,
	]

	bool 	isManuallyEnteringColor = false
	vector	manualColor

	bool registeredBindCallbacks = false

	float H_Progress = 0.0                         
	float SV_Progress = 0.0                                

	bool isOpen = false
	bool changingColorNotUsingSliders = false
} file

const float VALUE_MIN = 0.5
const float SATURATION_MAX = 1.0

void function InitFirstPersonReticleOptionsColorPanel( var panel )                                               
{
	file.panel = panel

	SetPanelTabTitle( panel, "#MENU_RETICLE_COLOR" )

	AddPanelEventHandler( file.panel, eUIEvent.PANEL_SHOW, OnShowPanel )
	AddPanelEventHandler( file.panel, eUIEvent.PANEL_HIDE, OnHidePanel )

	file.defaultColorBtn = Hud_GetChild( file.panel, "BtnDefaultColor" )
	file.previousColorBtn = Hud_GetChild( file.panel, "PreviousColorButton" )
	file.applyMannualColorBtn = Hud_GetChild( file.panel, "ApplyRGBButton" )
	file.applyMannualColorBtnBG = Hud_GetChild( file.panel, "ApplyRGBButtonBG" )

	                                     
	for( int i = 0; i < file.palettes.len(); i++ )
	{
		file.paletteColorBtns[Hud_GetChild( file.panel, format( "BtnPaletteColor%i", i ))] <- file.palettes[i]
	}


	file.H_Slider =  Hud_GetChild( Hud_GetChild( file.panel, "H_Slider" ), "PrgValue")
	file.SV_Slider =  Hud_GetChild( Hud_GetChild( file.panel, "SV_Slider" ), "PrgValue")

	RuiSetBool( Hud_GetRui(file.SV_Slider ), "isShade", true )

	file.RTextArea = Hud_GetChild( panel, "ColorRTextEntry" )
	AddButtonEventHandler( file.RTextArea, UIE_CHANGE, RGB_OnChanged )
	file.GTextArea = Hud_GetChild( panel, "ColorGTextEntry" )
	AddButtonEventHandler( file.GTextArea, UIE_CHANGE, RGB_OnChanged )
	file.BTextArea = Hud_GetChild( panel, "ColorBTextEntry" )
	AddButtonEventHandler( file.BTextArea, UIE_CHANGE, RGB_OnChanged )

	file.previousCurrentColorPane = Hud_GetChild( file.panel, "CurrentPreviousColor" )

	AddButtonEventHandler( file.defaultColorBtn, UIE_CLICK, OnDefaultColorButtonClicked )
	AddButtonEventHandler( file.previousColorBtn, UIE_CLICK, OnResetColorButtonClicked )
	AddButtonEventHandler( file.applyMannualColorBtn, UIE_CLICK, OnApplyManualColorButtonClicked )

	foreach( paletteBtn, color in file.paletteColorBtns )
	{
		AddButtonEventHandler( paletteBtn, UIE_CLICK, OnPaletteColorButtonClicked )
	}

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}

void function OnShowPanel( var panel )
{
	RegisterBindCallbacks()
	file.defaultColor = OptionsColor_GetDefaultColor( COLORID_RETICLE )
	file.currentColor = OptionsColor_GetCurrentColor( "reticle_color", file.defaultColor )
	file.previousColor = file.currentColor

	file.H_Progress = OptionsColor_RGBToHSV( file.currentColor ).hue / 360
	file.SV_Progress = OptionsColor_RGBToHSV( file.currentColor ).value / 360

	Hud_SliderControl_SetCurrentValue( Hud_GetChild( file.panel, "H_Slider" ), file.H_Progress )
	Hud_SliderControl_SetCurrentValue( Hud_GetChild( file.panel, "SV_Slider" ),  file.SV_Progress )

	file.changingColorNotUsingSliders = true
	{
		UpdateSaturationValueProgress()

		UpdateReticleColorOptions( file.currentColor )
		OptionsColor_UpdateColorSliders( file.panel, file.H_Slider, file.SV_Slider, file.currentColor, file.H_Progress, file.SV_Progress )
		UpdatePreviousColorBtn()
		UpdateRGBTextAreas( file.currentColor )

		Hud_SetColor( file.RTextArea, 255, 54, 54 )
		Hud_SetColor( file.GTextArea, 31, 255, 68 )
		Hud_SetColor( file.BTextArea, 57, 129, 255 )
	}
	file.changingColorNotUsingSliders = false

	file.isOpen = true
}


void function OnHidePanel( var panel )
{
	UpdateColor( file.currentColor, false, false)
	SaveCurrentColorToPlayerConfig();
	file.isOpen = false
	DeregisterBindCallbacks()
}

void function RegisterBindCallbacks()
{
	if(!file.registeredBindCallbacks)
	{
		file.registeredBindCallbacks = true

		Hud_AddEventHandler( Hud_GetChild( file.panel, "H_Slider" ), UIE_CHANGE, HueSliderSelector_OnChanged )
		Hud_AddEventHandler( Hud_GetChild( file.panel, "SV_Slider" ), UIE_CHANGE, ValueSliderSelector_OnChanged )

		RegisterButtonPressedCallback( BUTTON_Y, RestoreDefaultsButtonClicked )
		RegisterButtonPressedCallback( BUTTON_X, OnResetColorButtonClicked )
	}
}

void function DeregisterBindCallbacks()
{
	if(file.registeredBindCallbacks)
	{
		Hud_RemoveEventHandler(  Hud_GetChild( file.panel, "H_Slider" ), UIE_CHANGE, HueSliderSelector_OnChanged )
		Hud_RemoveEventHandler(  Hud_GetChild( file.panel, "SV_Slider" ), UIE_CHANGE, ValueSliderSelector_OnChanged )

		DeregisterButtonPressedCallback( BUTTON_Y, RestoreDefaultsButtonClicked )
		DeregisterButtonPressedCallback( BUTTON_X, OnResetColorButtonClicked )

		file.registeredBindCallbacks = false
	}
}

void function OnDefaultColorButtonClicked( var btn )
{
	RestoreDefaultsButtonClicked( btn )
}

void function OnPaletteColorButtonClicked( var btn )
{
	if( btn in file.paletteColorBtns)
	{
		file.changingColorNotUsingSliders = true
		UpdateColor(file.paletteColorBtns[btn], false, true)
	}
}

  
                                 
  
void function UpdateColor(vector color, bool validate = false, bool calculateSliderProgress = false)
{
	file.isManuallyEnteringColor = false
	if( file.isOpen )
	{
		if( validate )
			color = ColorPalette_ClampAndValidateColor( color )

		OverrideColor( color, "RETICLE" )
		file.currentColor = color

		if(calculateSliderProgress)
		{
			file.H_Progress = OptionsColor_RGBToHSV( color ).hue / 360
			UpdateSaturationValueProgress()
		}

		UpdateReticleColorOptions( file.currentColor )
		OptionsColor_UpdateColorSliders(file.panel, file.H_Slider, file.SV_Slider, file.currentColor, file.H_Progress, file.SV_Progress)
		UpdateRGBTextAreas( file.currentColor )
		UpdatePreviousColorBtn()
	}
	file.changingColorNotUsingSliders = false
}

void function SaveCurrentColorToPlayerConfig()
{
	SetConVarString( "reticle_color", format( "%i %i %i", int(file.currentColor.x) , int(file.currentColor.y) ,  int(file.currentColor.z)) )
}

  
                                                                          
  
void function UpdateRGBTextAreas( vector currentColor )
{
	Hud_SetVisible(file.applyMannualColorBtn, file.isManuallyEnteringColor)
	Hud_SetVisible(file.applyMannualColorBtnBG, file.isManuallyEnteringColor)

	string RText = Hud_GetUTF8Text( file.RTextArea )
	if( RText != string( currentColor.x ) || RText == "" )
		Hud_SetUTF8Text( file.RTextArea, ""  + currentColor.x )

	string GText = Hud_GetUTF8Text( file.GTextArea )
	if( GText != string( currentColor.y ) || GText == "" )
		Hud_SetUTF8Text( file.GTextArea, ""  + currentColor.y )

	string BText = Hud_GetUTF8Text( file.BTextArea )
	if( BText != string( currentColor.z ) || BText == "" )
		Hud_SetUTF8Text( file.BTextArea, ""  + currentColor.z )
}

  
                                                           
  
void function UpdateReticleColorOptions( vector currentColor )
{
	RuiSetFloat3(  Hud_GetRui( file.defaultColorBtn ), "paletteColor", file.defaultColor )

	RuiSetColorAlpha(  Hud_GetRui( file.previousCurrentColorPane ), "previousColor", file.previousColor, 1.0)
	RuiSetColorAlpha(  Hud_GetRui( file.previousCurrentColorPane ), "currentColor", currentColor, 1.0)

	foreach( paletteBtn, color in file.paletteColorBtns )
	{
		RuiSetFloat3(  Hud_GetRui( paletteBtn ), "paletteColor", color)
	}
}

void function UpdatePreviousColorBtn()
{
	Hud_SetVisible(file.previousColorBtn, OptionsColor_HasColorChanged(file.previousColor, file.currentColor))
}

void function UpdateSaturationValueProgress()
{
	                                                                                           
	                                                                                               
	  

	HSV updateSaturationValueProgress = OptionsColor_RGBToHSV( file.currentColor )

	if( updateSaturationValueProgress.value > updateSaturationValueProgress.saturation )
	{
		file.SV_Progress =  1.0 - ( ( max( updateSaturationValueProgress.saturation - ( 1.0 - SATURATION_MAX), 0.0) / SATURATION_MAX ) / 2.0 )
	}
	else
	{
		file.SV_Progress = (max(( updateSaturationValueProgress.value - VALUE_MIN), 0 ) )
	}
}

void function HueSliderSelector_OnChanged( var button )
{
	float value = Hud_SliderControl_GetCurrentValue(button)

	                                                      
	HSV currentColor = OptionsColor_RGBToHSV( file.currentColor )
	HSV newColor
	{
		newColor.hue        = value * 360
		newColor.saturation = currentColor.saturation
		newColor.value      = currentColor.value
	}
	file.H_Progress = value
	if( !file.changingColorNotUsingSliders )
		UpdateColor(OptionsColor_HSVToRGB( newColor ), false, false)
}

void function ValueSliderSelector_OnChanged( var button )
{
	float value = ( Hud_SliderControl_GetCurrentValue(button) )
	                                                         
	                                                          
	HSV currentColor = OptionsColor_RGBToHSV( file.currentColor )
	float centerPoint = 0.5

	HSV newColor
	{
		newColor.hue        = file.H_Progress * 360
		newColor.saturation = (value <= centerPoint )? 1.0: 1 - ( ((value - 0.5) * 2)  * SATURATION_MAX )
		newColor.value      = (value > centerPoint )? 1.0: VALUE_MIN + ( ( value * 2 ) * ( 1 - VALUE_MIN ) )
	}

	file.SV_Progress = Hud_SliderControl_GetCurrentValue(button)
	if( !file.changingColorNotUsingSliders )
		UpdateColor( OptionsColor_HSVToRGB( newColor ), false, false )
}

void function RGB_OnChanged( var button )
{
	file.isManuallyEnteringColor = true
	           
	float R = min(float( Hud_GetUTF8Text( file.RTextArea ) ), 255)
	float G = min(float( Hud_GetUTF8Text( file.GTextArea ) ), 255)
	float B = min(float( Hud_GetUTF8Text( file.BTextArea ) ), 255)
	file.manualColor = < R, G, B>

	UpdateReticleColorOptions( file.manualColor )
	UpdateRGBTextAreas( file.manualColor )
}

void function OnResetColorButtonClicked( var btn )
{
	if(OptionsColor_HasColorChanged( file.previousColor, file.currentColor ))
	{
		ConfirmDialogData data
		data.headerText = "#REVERT_CUSTOM_RETICLE_CHANGES"
		data.messageText = "#REVERT_CUSTOM_RETICLE_CHANGES_DESC"
		data.resultCallback = OnResetColorDialogResult

		OpenConfirmDialogFromData( data )
		AdvanceMenu( GetMenu( "ConfirmDialog" ) )
	}
}

void function RestoreDefaultsButtonClicked( var button )
{
	ConfirmDialogData data
	data.headerText = "#RESTORE_CUSTOM_RETICLE_DEFAULTS"
	data.messageText = "#RESTORE_CUSTOM_RETICLE_DEFAULTS_DESC"
	data.resultCallback = OnRestoreDefaultsDialogResult

	OpenConfirmDialogFromData( data )
	AdvanceMenu( GetMenu( "ConfirmDialog" ) )
}

void function OnApplyManualColorButtonClicked ( var btn )
{
	vector validatedColor = ColorPalette_ClampAndValidateColor( file.manualColor )
	                       
	OptionsColor_UpdateColorSliders(file.panel, file.H_Slider, file.SV_Slider, file.currentColor, file.H_Progress, file.SV_Progress)
	if ( validatedColor.x != file.manualColor.x 		||
			validatedColor.y != file.manualColor.y 		||
			validatedColor.z != file.manualColor.z  	||
			file.currentColor.x != file.manualColor.x 	||
			file.currentColor.y != file.manualColor.y 	||
			file.currentColor.z != file.manualColor.z )
	{
		ConfirmDialogData data
		data.headerText = "#APPLY_MANUAL_CUSTOM_RETICLE_CHANGES"
		data.messageText = "#APPLY_MANUAL_CUSTOM_RETICLE_CHANGES_DESC"
		data.resultCallback = OnApplyManualColor

		OpenConfirmDialogFromData( data )
		AdvanceMenu( GetMenu( "ConfirmDialog" ) )
	}
	else
	{
		file.changingColorNotUsingSliders = true
		UpdateColor( validatedColor, true, true )
		SaveCurrentColorToPlayerConfig();
	}
}

void function OnRestoreDefaultsDialogResult( int result )
{
	switch ( result )
	{
		case eDialogResult.YES:
			file.changingColorNotUsingSliders = true
			UpdateColor( file.defaultColor, false, true )
			SaveCurrentColorToPlayerConfig();
	}
}

void function OnResetColorDialogResult( int result )
{
	switch ( result )
	{
		case eDialogResult.YES:
			file.changingColorNotUsingSliders = true
			UpdateColor( file.previousColor, false, true )
			SaveCurrentColorToPlayerConfig();
	}
}

void function OnApplyManualColor( int result )
{
	switch ( result )
	{
		case eDialogResult.YES:
			file.changingColorNotUsingSliders = true
			UpdateColor( file.manualColor, true, true )
			SaveCurrentColorToPlayerConfig();
	}
}
