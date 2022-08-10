global function InitClubsLogoColorSelectionMenu

global function ClubLogos_OpenColorSelectionMenu

struct
{
	var menu
	var menuHeaderRui

	var           elementDisplay
	ClubLogoLayer& selectedElement

	var                         grid
	table< int, array<vector> > colorSwatches
	table< var, vector >        buttonToColor

	int selectedColorChannel = -1

	var closeButton
} file

void function InitClubsLogoColorSelectionMenu( var menu )
{
	printf( "ClubsDebug: InitClubsLogoColorSelectionMenu()" )
	file.menu = menu

	SetPopup( menu, true )

	                                                                       
	                                                                            

	file.grid = Hud_GetChild( file.menu, "ClubColorsGrid" )

	file.elementDisplay = Hud_GetChild( file.menu, "LayerElementDisplay" )

	file.closeButton = Hud_GetChild( file.menu, "CloseButton" )
	Hud_AddEventHandler( file.closeButton, UIE_CLICK, CloseButton_OnClick )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, ColorSelection_OnShow )
	AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, ColorSelection_OnHide )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnNavigateBack )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE", null, CanNavigateBack )
}

void function ClubLogos_OpenColorSelectionMenu( var parentSelector, ClubLogoLayer logoLayer, int colorChannel = -1 )
{
	AdvanceMenu( file.menu )

	file.selectedColorChannel = colorChannel

	SetElementDisplay( parentSelector, logoLayer )
}

void function ColorSelection_OnShow()
{
	table< int, array<vector> > colorSwatches = ClubLogo_GetLogoColorTable()
	int colorBtnCount = ClubLogo_GetColorSwatchCount( colorSwatches )

	printf( "ClubsDebug: ColorSelection_OnShow(), initializing %i Color Swatch Buttons", colorBtnCount )

	int btnIdx = 0
	Hud_InitGridButtons( file.grid, colorBtnCount )
	var scrollPanel = Hud_GetChild( file.grid, "ScrollPanel" )
	foreach( int colorIndex, array<vector> shade in colorSwatches )
	{
		for ( int i = 0; i < shade.len(); i++ )
		{
			var button = Hud_GetChild( scrollPanel, format("GridButton%d", btnIdx) )
			InitButtonRCP( button )
			InitColorButton( button, colorSwatches[ colorIndex ][ i ] )
			btnIdx++
		}
	}

	Hud_SetSelected( Hud_GetChild( scrollPanel, "GridButton0" ), true )
}

void function ColorSelection_OnHide()
{
	                                
	file.selectedColorChannel = -1
}

void function SetElementDisplay( var parentSelector, ClubLogoLayer logoLayer )
{
	UISize displaySize = REPLACEHud_GetSize( file.elementDisplay )
	UIPos ownerPos = REPLACEHud_GetAbsPos( parentSelector )
	UISize ownerSize = REPLACEHud_GetSize( parentSelector )

	int displayPosX = ownerPos.x + (ownerSize.width/2) - (displaySize.width/2)

	#if NX_PROG || PC_PROG_NX_UI
		if ( IsNxHandheldMode() )
		{
			Hud_SetPos( file.elementDisplay, displayPosX, ownerPos.y - 26.0 )
		}
		else
		{
			Hud_SetPos( file.elementDisplay, displayPosX, ownerPos.y )
		}
	#else
		Hud_SetPos( file.elementDisplay, displayPosX, ownerPos.y )
	#endif
	
	var elementDisplayRui = Hud_GetRui( file.elementDisplay )
	RuiSetImage( elementDisplayRui, "primaryElementImage", ClubLogo_GetLogoElementImage( logoLayer.elementFlav ) )
	RuiSetFloat3( elementDisplayRui, "primaryColorOverride", logoLayer.primaryColorOverride )

	asset ornull secondaryImage = ClubLogo_GetLogoSecondaryColorMask( logoLayer.elementFlav )
	if ( secondaryImage != null )
	{
		expect asset( secondaryImage )
		RuiSetImage( elementDisplayRui, "secondaryElementImage", secondaryImage )
		RuiSetFloat3( elementDisplayRui, "secondaryColorOverride", logoLayer.secondaryColorOverride )
	}

	if ( ClubLogo_GetLogoElementType( logoLayer.elementFlav ) == eClubLogoElementType.CLUBLOGOTYPE_EMBLEM )
	{
		RuiSetFloat( elementDisplayRui, "scaleMultiplier", 1.75 )
	}
	else
	{
		RuiSetFloat( elementDisplayRui, "scaleMultiplier", 1.0 )
	}

	var frame        = Hud_GetChild( file.menu, "ButtonFrame" )
	var background   = Hud_GetChild( file.menu, "ButtonBackground" )
	UISize frameSize = REPLACEHud_GetSize( frame )


	#if NX_PROG || PC_PROG_NX_UI
		if ( IsNxHandheldMode() )
		{
			int framePosX = 640
			Hud_SetPos( frame, framePosX, ownerPos.y )
			Hud_SetPos( background, framePosX, (ownerPos.y * 0.5) )
		}
		else
		{
			int framePosX = int(ownerPos.x - (frameSize.width*0.3))
			Hud_SetPos( frame, framePosX, ownerPos.y )
			Hud_SetPos( background, framePosX, ownerPos.y )
		}
	#else
		int framePosX = int(ownerPos.x - (frameSize.width*0.3))
		Hud_SetPos( frame, framePosX, ownerPos.y )
		Hud_SetPos( background, framePosX, ownerPos.y )
	#endif

	file.selectedElement = logoLayer
}

void function InitColorButton( var button, vector colorVec )
{
	var buttonRui    = Hud_GetRui( button )
	string colorName = Localize( "#CLUBLOGOEDITOR_COLOR_RGB", colorVec.x, colorVec.y, colorVec.z )
	RuiSetFloat3( buttonRui, "colorOverride", colorVec )

	ToolTipData toolTipData
	toolTipData.descText = colorName
	Hud_SetToolTipData( button, toolTipData )

	bool isButtonMapped = (button in file.buttonToColor)
	if ( !isButtonMapped )
	{
		                                                                                        
		file.buttonToColor[button] <- colorVec
		Hud_AddEventHandler( button, UIE_CLICK, ColorButton_OnClick )
	}

	thread SetSelectedColorThread( button )
}


void function SetSelectedColorThread( var button )
{
	                                                                                    
	while ( file.selectedColorChannel == -1 )
	{
		WaitFrame()
	}

	vector selectedColorVec = ClubLogoEditor_GetColorForActiveLayer( file.selectedColorChannel )
	                                                                                                                                                                       

	var buttonRui = Hud_GetRui( button )
	bool isSelectedColor = file.buttonToColor[button] == ClubLogoEditor_GetColorForActiveLayer( file.selectedColorChannel )
	RuiSetBool( buttonRui, "isSelected", isSelectedColor )
}


void function ColorButton_OnClick( var button )
{
	Assert( button in file.buttonToColor, "Club Logo Editor (Color Selection): Attempted to retrieve color from unmapped button" )
	vector color = file.buttonToColor[ button ]
	                                                                                                                    
	ClubLogoEditor_SetColorForActiveLayer( file.buttonToColor[ button ], file.selectedColorChannel )

	thread WaitFrameThenCloseMenu()
}

void function CloseButton_OnClick( var button )
{
	CloseColorSelectionMenu( null )
}

void function WaitFrameThenCloseMenu()
{
	                                                      
	WaitFrame()
	CloseColorSelectionMenu( null )
}

void function CloseColorSelectionMenu( var button )
{
	if ( GetActiveMenu() == file.menu )
		thread CloseActiveMenu()
}

bool function CanNavigateBack()
{
	return GetActiveMenu() == file.menu
}

void function OnNavigateBack()
{
	if ( !CanNavigateBack() )
		return

	CloseActiveMenu()
}