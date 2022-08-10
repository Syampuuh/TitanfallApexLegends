global function InitClubsLogoEditorMenu

global function ClubsLogoEditor_OpenLogoEditor
global function ClubsLogoEditor_CloseLogoEditor

global function ClubLogoEditor_SetElementForActiveLayer
global function ClubLogoEditor_GetColorForActiveLayer
global function ClubLogoEditor_SetColorForActiveLayer

enum eLogoEditorScaleMode
{
	FREE,
	UNIFORM,
	_count
}

struct EditorLayer
{
	ClubLogoLayer layerData
	var           leftButton
	var           rightButton
	var           elementPanel
}

struct
{
	var menu
	var menuHeaderRui

	var        canvasPanel
	array<var> layerElementPanels

	var        topLayerSelector
	var        midLayerSelector
	var        baseLayerSelector
	array<var> layerSelectionPanels
	table< int, array<var> > layerToArrowButtons

	array<EditorLayer> editorLayers
	EditorLayer ornull activeLayer

	asset ornull selectedFrameMask

	var focusedLayerButton

	var submitLogoButton

	bool isSnapToGridEnabled = true

	bool changesMade = false
} file

void function InitClubsLogoEditorMenu( var menu )
{
	printf( "ClubsDebug: Init Club Logo Editor" )
	file.menu = GetMenu( "ClubsLogoEditorMenu" )

	file.menuHeaderRui = Hud_GetRui( Hud_GetChild( menu, "MenuHeader" ) )
	RuiSetString( file.menuHeaderRui, "menuName", "#CLUBS_LOGO_EDITOR_HEADER" )

	file.canvasPanel = Hud_GetChild( menu, "ClubLogoCanvasPanel" )
	Hud_Show( file.canvasPanel )
	for ( int layerIdx = 0; layerIdx < CLUB_LOGO_LAYER_MAX; layerIdx++ )
	{
		file.layerElementPanels.append( Hud_GetChild( file.canvasPanel, format( "LogoElement%02d", layerIdx ) ) )
		Hud_Hide( file.layerElementPanels[ layerIdx ] )
	}
	printf( "ClubsDebug: Init: Appended %i layer element panels to file", file.layerElementPanels.len() )

	file.topLayerSelector = Hud_GetChild( menu, "TopLayerSelector" )
	var topSelectorRui = Hud_GetRui( Hud_GetChild( file.topLayerSelector, "LayerSelector" ) )
	RuiSetString( topSelectorRui, "layerName", "#CLUBS_LOGO_EDITOR_LAYER_TOP" )
	file.midLayerSelector = Hud_GetChild( menu, "MidLayerSelector" )
	var midSelectorRui = Hud_GetRui( Hud_GetChild( file.midLayerSelector, "LayerSelector" ) )
	RuiSetString( midSelectorRui, "layerName", "#CLUBS_LOGO_EDITOR_LAYER_MIDDLE" )
	file.baseLayerSelector = Hud_GetChild( menu, "BaseLayerSelector" )
	var baseSelectorRui = Hud_GetRui( Hud_GetChild( file.baseLayerSelector, "LayerSelector" ) )
	RuiSetString( baseSelectorRui, "layerName", "#CLUBS_LOGO_EDITOR_LAYER_BOTTOM" )
	file.layerSelectionPanels.append( file.baseLayerSelector )
	file.layerSelectionPanels.append( file.midLayerSelector )
	file.layerSelectionPanels.append( file.topLayerSelector )

	foreach ( var panel in file.layerSelectionPanels )
	{
		var selectorButton = Hud_GetChild( panel, "LayerSelector" )
		Hud_AddEventHandler( selectorButton, UIE_CLICK, LayerSelector_OnActivate )
		                                                                                
		                                                                                  

		int index = file.layerSelectionPanels.find( panel )
		array<var> buttonArray
		var leftArrow = Hud_GetChild( panel, "LeftArrow" )
		buttonArray.append( leftArrow )
		Hud_AddEventHandler( leftArrow, UIE_CLICK, LeftArrowButton_OnActive )
		var rightArrow = Hud_GetChild( panel, "RightArrow" )
		buttonArray.append( rightArrow )
		Hud_AddEventHandler( rightArrow, UIE_CLICK, RightArrowButton_OnActive )
		file.layerToArrowButtons[index] <- buttonArray
	}

	file.submitLogoButton = Hud_GetChild( menu, "SubmitLogoButton" )
	var submitButtonRui = Hud_GetRui( file.submitLogoButton )
	RuiSetString( submitButtonRui, "buttonText", "#CLUBLOGOEDITOR_SUBMIT_BUTTON_NAME" )
	Hud_AddEventHandler( file.submitLogoButton, UIE_CLICK, SubmitLogoButton_OnActivate )

	RegisterSignal( "ClubLogoEditor_LoseTopLevel" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_GET_TOP_LEVEL, OnGainTopLevel )
	AddMenuEventHandler( menu, eUIEvent.MENU_LOSE_TOP_LEVEL, OnLoseTopLevel )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnNavigateBack )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE", null, CanNavigateBack )
	AddMenuFooterOption( menu, LEFT, BUTTON_X, true, "#CLUBLOGOEDITOR_KEY_COLOR_CONSOLE", "#CLUBLOGOEDITOR_KEY_COLOR_PC", OnSetPrimaryColor )
	AddMenuFooterOption( menu, LEFT, BUTTON_Y, true, "#CLUBLOGOEDITOR_KEY_COLOR02_CONSOLE", "#CLUBLOGOEDITOR_KEY_COLOR02_PC", OnSetSecondaryColor, CanSetSecondaryColor )
}


void function ClubLogoEditor_SetLogo( ClubLogo logo )
{
	file.editorLayers.clear()

	foreach ( ClubLogoLayer logoLayer in logo.logoLayers )
	{
		EditorLayer editorLayer
		editorLayer.layerData.elementFlav = logoLayer.elementFlav
		editorLayer.layerData.elementType = logoLayer.elementType
		editorLayer.layerData.verticalOffset = logoLayer.verticalOffset
		editorLayer.layerData.primaryColorOverride = logoLayer.primaryColorOverride
		editorLayer.layerData.secondaryColorOverride = logoLayer.secondaryColorOverride
		editorLayer.layerData.secondaryColorAlpha = logoLayer.secondaryColorAlpha
		editorLayer.layerData.frameMask = logoLayer.frameMask
		editorLayer.layerData.rotation = logoLayer.rotation
		file.editorLayers.append( editorLayer )
	}

	file.editorLayers.reverse()

	file.activeLayer = file.editorLayers[ file.editorLayers.len() - 1 ]
	RefreshEditor()
}


void function OnOpen()
{
	printf( "ClubsDebug: OnShowLogoEditor" )

	RegisterLayerEditingInputs()
}


void function ClubsLogoEditor_OpenLogoEditor( ClubLogo logo )
{
	AdvanceMenu( file.menu )

	                                
	ClubLogo editorLogo
	if ( logo.logoLayers.len() > 0 )
		editorLogo = logo
	else
		editorLogo = GenerateRandomClubLogo()

	ClubLogoEditor_SetLogo( editorLogo )
}


void function ClubsLogoEditor_CloseLogoEditor()
{
	if ( GetActiveMenu() != file.menu )
		return

	CloseActiveMenu()
}


void function OnGainTopLevel()
{
	                
}

const float CLUB_LOGO_POS_MIN = -0.5
const float CLUB_LOGO_POS_MAX = 0.5
const float CLUB_LOGO_POS_STEP = 0.0125

const float CLUB_LOGO_SCALE_MIN = 0.1
const float CLUB_LOGO_SCALE_MAX = 1.5
const float CLUB_LOGO_SCALE_STEP = 0.025

const float CLUB_LOGO_ROT_STEP_DEG_MIN = 1
const float CLUB_LOGO_ROT_STEP_DEG_MAX = 45
const float CLUB_LOGO_ROT_STEP_GRIDSNAP_DEG = 45
const float CLUB_LOGO_ROT_GRIDSNAP_TIMESTEP = 0.5


void function OnLoseTopLevel()
{
	Signal( uiGlobal.signalDummy, "ClubLogoEditor_LoseTopLevel" )
}


void function OnClose()
{
	                          
	DeregisterLayerEditingInputs()
	file.activeLayer = null
}


void function ClubLogoEditor_SetElementForActiveLayer( ItemFlavor elementFlav )
{
	Assert( file.activeLayer != null, "Club Logo Editor: Attempted to assign an element to the active layer without the active layer being set" )

	EditorLayer activeLayer = expect EditorLayer( file.activeLayer )
	activeLayer.layerData.elementFlav = elementFlav

	RefreshEditor()
}


vector function ClubLogoEditor_GetColorForActiveLayer( int colorChannel )
{
	EditorLayer ornull activeLayer = file.activeLayer
	if ( activeLayer == null )
		return <0,0,0>

	expect EditorLayer( activeLayer )

	int layerIdx = file.editorLayers.find( activeLayer )

	if ( colorChannel == 0 )
		return activeLayer.layerData.primaryColorOverride
	else
		return activeLayer.layerData.secondaryColorOverride

	return <0,0,0>
}


void function ClubLogoEditor_SetColorForActiveLayer( vector colorVec, int colorChannel = 0 )
{
	Assert( file.activeLayer != null, "Club Logo Editor: Attempted to assign a color to the active layer without an active layer set" )

	EditorLayer activeLayer = expect EditorLayer( file.activeLayer )

	switch ( colorChannel )
	{
		case 1:
			activeLayer.layerData.secondaryColorOverride = colorVec
			break
		default:
			activeLayer.layerData.primaryColorOverride = colorVec
			break
	}

	file.changesMade = true

	RefreshEditor()
}


const float LOGO_RES_DEFAULT_H = 512.0
const float LOGO_RES_DEFAULT_V = 512.0

void function RefreshEditor()
{
	                                         

	if ( file.editorLayers.len() == 0 )
		return

	UpdateFooterOptions()

	foreach ( int layerIdx, var elementPanel in file.layerElementPanels )
	{
		int currentLayerCount = file.editorLayers.len()
		                                                                                                     
		var elementPanelRui = Hud_GetRui( elementPanel )

		if ( layerIdx < file.editorLayers.len() )
		{
			EditorLayer editorLayer = file.editorLayers[ layerIdx ]
			editorLayer.elementPanel = elementPanel

			Hud_Show( elementPanel )

			RuiSetFloat2( elementPanelRui, "actualRes", <LOGO_RES_DEFAULT_H, LOGO_RES_DEFAULT_V, 0> )
			RuiSetImage( elementPanelRui, "elementImage", ClubLogo_GetLogoElementImage( editorLayer.layerData.elementFlav ) )
			RuiSetFloat3( elementPanelRui, "primaryColorOverride", editorLayer.layerData.primaryColorOverride )

			asset ornull secondaryColorMask = ClubLogo_GetLogoSecondaryColorMask( editorLayer.layerData.elementFlav )
			if ( secondaryColorMask != null )
			{
				RuiSetImage( elementPanelRui, "secondaryColorMask", expect asset(secondaryColorMask) )
				RuiSetFloat3( elementPanelRui, "secondaryColorOverride", editorLayer.layerData.secondaryColorOverride )
				RuiSetFloat( elementPanelRui, "secondaryColorAlpha", 1.0 )
			}
			else
			{
				RuiSetFloat( elementPanelRui, "secondaryColorAlpha", 0.0 )
			}

			int logoType = ClubLogo_GetLogoElementType( editorLayer.layerData.elementFlav )
			if( logoType != eClubLogoElementType.CLUBLOGOTYPE_FRAME )
			{
				asset ornull frameMask = GetFrameMaskFromFrameLayer()
				if ( frameMask != null )
				{
					expect asset( frameMask )
					RuiSetImage( elementPanelRui, "frameMask", frameMask )
					file.editorLayers[layerIdx].layerData.frameMask = frameMask
				}

				if ( logoType == eClubLogoElementType.CLUBLOGOTYPE_EMBLEM )
				{
					float verticalOffset = GetVerticalOffsetFromFrameLayer()
					printf( "RefreshEditor(): ClubLogo_GetLogoVerticalOffset(): Setting vertical offset to %f", verticalOffset )
					RuiSetFloat( elementPanelRui, "verticalOffset", verticalOffset )
					file.editorLayers[layerIdx].layerData.verticalOffset = verticalOffset
				}
			}

			                                                                                  

			var layerSelectorPanel = file.layerSelectionPanels[ layerIdx ]
			ConfigureElementSelector( editorLayer, layerSelectorPanel )
		}
		else
		{
			Hud_Hide( elementPanel )
		}
	}
}


asset ornull function GetFrameMaskFromFrameLayer()
{
	ItemFlavor frameFlav
	foreach ( EditorLayer editorLayer in file.editorLayers )
	{
		if ( ClubLogo_GetLogoElementType( editorLayer.layerData.elementFlav ) == eClubLogoElementType.CLUBLOGOTYPE_FRAME )
		{
			frameFlav = editorLayer.layerData.elementFlav
			break
		}
	}

	return ClubLogo_GetLogoFrameMask( frameFlav )
}


float function GetVerticalOffsetFromFrameLayer()
{
	float offset
	foreach ( EditorLayer editorLayer in file.editorLayers )
	{
		if ( ClubLogo_GetLogoElementType( editorLayer.layerData.elementFlav ) == eClubLogoElementType.CLUBLOGOTYPE_FRAME )
		{
			offset = ClubLogo_GetLogoVerticalOffset( editorLayer.layerData.elementFlav )
			editorLayer.layerData.verticalOffset = offset
			printf( "ClubLogo_GetLogoVerticalOffset(): Frame found, offset = %f", offset )
			break
		}
	}

	return offset
}


void function ConfigureElementSelector( EditorLayer editorLayer, var layerSelectorPanel )
{
	ItemFlavor selectedFlav = editorLayer.layerData.elementFlav
	int elementType = ClubLogo_GetLogoElementType( selectedFlav )
	                                                                                               
	var selectorRui         = Hud_GetRui( Hud_GetChild( layerSelectorPanel, "LayerSelector" ) )

	bool isActiveLayer = (file.activeLayer == editorLayer)
	RuiSetBool( selectorRui, "isActiveLayer", isActiveLayer )

	RuiSetImage( selectorRui, "selectedElementImage", ClubLogo_GetLogoElementImage( selectedFlav ) )
	RuiSetFloat3( selectorRui, "colorOverride", editorLayer.layerData.primaryColorOverride )
	RuiSetString( selectorRui, "selectedElementName", ClubLogo_GetLogoElementName( selectedFlav ) )
	asset ornull secondaryColorMask = ClubLogo_GetLogoSecondaryColorMask( editorLayer.layerData.elementFlav )
	if ( secondaryColorMask != null )
	{
		RuiSetImage( selectorRui, "selectedElementSecondaryColorMask", expect asset( secondaryColorMask ) )
		RuiSetFloat3( selectorRui, "secondaryColorOverride", editorLayer.layerData.secondaryColorOverride )
		RuiSetFloat( selectorRui, "selectedElementSecondaryColorAlpha", 1.0 )
	}
	else
	{
		RuiSetFloat( selectorRui, "selectedElementSecondaryColorAlpha", 0.0 )
	}

	if( ClubLogo_GetLogoElementType( editorLayer.layerData.elementFlav ) != eClubLogoElementType.CLUBLOGOTYPE_FRAME )
	{
		asset ornull frameMask = GetFrameMaskFromFrameLayer()
		if ( frameMask != null )
			RuiSetImage( selectorRui, "frameMask", expect asset( frameMask ) )
	}

	if( ClubLogo_GetLogoElementType( editorLayer.layerData.elementFlav ) == eClubLogoElementType.CLUBLOGOTYPE_EMBLEM )
	{
		RuiSetFloat( selectorRui, "scaleMultiplier", 1.75 )
	}

	array<ItemFlavor> allLogoFlavs = GetAllClubLogoElementFlavorsOfType( elementType )                                 
	                                                                                        
	int flavIndex                  = allLogoFlavs.find( selectedFlav )
	                        
	   
	  	                                                                                                       
	  	             
	   

	int prevFlavIndex = flavIndex - 1
	if ( prevFlavIndex < 0 )
		prevFlavIndex = allLogoFlavs.len() - 1

	RuiSetImage( selectorRui, "previousElementImage00", ClubLogo_GetLogoElementImage( allLogoFlavs[prevFlavIndex] ) )
	asset ornull secondaryColorMaskPrev00 = ClubLogo_GetLogoSecondaryColorMask( allLogoFlavs[prevFlavIndex] )
	if ( secondaryColorMaskPrev00 != null )
	{
		RuiSetImage( selectorRui, "previousElementSecondaryColorMask00", expect asset( secondaryColorMaskPrev00 ) )
		RuiSetFloat( selectorRui, "previousElementSecondaryAlpha00", 1.0 )
	}
	else
	{
		RuiSetFloat( selectorRui, "previousElementSecondaryAlpha00", 0.0 )
	}

	prevFlavIndex--
	if ( prevFlavIndex < 0 )
		prevFlavIndex = allLogoFlavs.len() - 1

	RuiSetImage( selectorRui, "previousElementImage01", ClubLogo_GetLogoElementImage( allLogoFlavs[prevFlavIndex] ) )
	asset ornull secondaryColorMaskPrev01 = ClubLogo_GetLogoSecondaryColorMask( allLogoFlavs[prevFlavIndex] )
	if ( secondaryColorMaskPrev01 != null )
	{
		RuiSetImage( selectorRui, "previousElementSecondaryColorMask01", expect asset( secondaryColorMaskPrev01 ) )
		RuiSetFloat( selectorRui, "previousElementSecondaryAlpha01", 1.0 )
	}
	else
	{
		RuiSetFloat( selectorRui, "previousElementSecondaryAlpha01", 0.0 )
	}

	int nextFlavIndex = flavIndex + 1
	if ( nextFlavIndex >= allLogoFlavs.len() )
		nextFlavIndex = 0

	printf( "ConfigureElementSelector(): nextElement00: %s (index: %i / %i)", ClubLogo_GetLogoElementName( allLogoFlavs[nextFlavIndex] ), nextFlavIndex, (allLogoFlavs.len()-1) )
	RuiSetImage( selectorRui, "nextElementImage00", ClubLogo_GetLogoElementImage( allLogoFlavs[nextFlavIndex] ) )
	asset ornull secondaryColorMaskNext00 = ClubLogo_GetLogoSecondaryColorMask( allLogoFlavs[nextFlavIndex] )
	if ( secondaryColorMaskNext00 != null )
	{
		RuiSetImage( selectorRui, "nextElementSecondaryColorMask00", expect asset( secondaryColorMaskNext00 ) )
		RuiSetFloat( selectorRui, "nextElementSecondaryAlpha00", 1.0 )
	}
	else
	{
		RuiSetFloat( selectorRui, "nextElementSecondaryAlpha00", 0.0 )
	}

	nextFlavIndex++
	if ( nextFlavIndex >= allLogoFlavs.len() )
		nextFlavIndex = 0

	printf( "ConfigureElementSelector(): nextElement01: %s (index: %i / %i)", ClubLogo_GetLogoElementName( allLogoFlavs[nextFlavIndex] ), nextFlavIndex, (allLogoFlavs.len()-1) )
	RuiSetImage( selectorRui, "nextElementImage01", ClubLogo_GetLogoElementImage( allLogoFlavs[nextFlavIndex] ) )
	asset ornull secondaryColorMaskNext01 = ClubLogo_GetLogoSecondaryColorMask( allLogoFlavs[nextFlavIndex] )
	if ( secondaryColorMaskNext01 != null )
	{
		RuiSetImage( selectorRui, "nextElementSecondaryColorMask01", expect asset( secondaryColorMaskNext01 ) )
		RuiSetFloat( selectorRui, "nextElementSecondaryAlpha01", 1.0 )
	}
	else
	{
		RuiSetFloat( selectorRui, "nextElementSecondaryAlpha01", 0.0 )
	}

	array<var> arrowButtons = file.layerToArrowButtons[ file.layerSelectionPanels.find(layerSelectorPanel) ]
	foreach( var arrowButton in arrowButtons )
	{
		var rui = Hud_GetRui( arrowButton )
		RuiSetBool( rui, "isActiveLayer", isActiveLayer )
	}
}


void function IncrementActiveLayerSelectedFlav( int incrementAmount = 1 )
{
	EditorLayer ornull activeLayer = file.activeLayer
	if ( activeLayer == null )
	{
		return
	}
	expect EditorLayer( activeLayer )

	int elementType = ClubLogo_GetLogoElementType( activeLayer.layerData.elementFlav )
	array<ItemFlavor> allLogoFlavs = GetAllClubLogoElementFlavorsOfType( elementType )                                 
	Assert( incrementAmount <= allLogoFlavs.len(), "Club Logo: Attempted to jump to Logo ItemFlavor with too large of an increment" )

	int flavIndex = allLogoFlavs.find( activeLayer.layerData.elementFlav )
	int newIndex  = flavIndex + incrementAmount

	                                                                                    
	if ( newIndex >= allLogoFlavs.len() )
	{
		newIndex = newIndex - allLogoFlavs.len()
	}
	else if ( newIndex < 0 )
	{
		newIndex = abs( newIndex + allLogoFlavs.len() )
	}

	file.editorLayers[ file.editorLayers.find( activeLayer ) ].layerData.elementFlav = allLogoFlavs[newIndex]

	RefreshEditor()
}


void function LayerSelector_OnActivate( var button )
{
	int index = file.layerSelectionPanels.find( Hud_GetParent( button ) )
	if ( index == -1 )
		return

	if ( file.activeLayer != file.editorLayers[index] )
	{
		file.activeLayer = file.editorLayers[index]
	}

	file.changesMade = true

	UpdateFooterOptions()
	RefreshEditor()
}


void function LayerSelector_OnGetFocus( var button )
{
	printf( "%s()", FUNC_NAME() )
	int index = file.layerSelectionPanels.find( Hud_GetParent( button ) )
	if ( index == -1 )
		return

	if ( !Hud_IsFocused( button ) )
		Hud_SetFocused( button )

	foreach ( var arrowButton in file.layerToArrowButtons[index] )
	{
		                                                                                                       
		if ( !Hud_IsFocused( arrowButton ) )
			Hud_SetFocused( arrowButton )
	}
}

void function LayerSelector_OnLoseFocus( var button )
{
	printf( "%s()", FUNC_NAME() )
	int index = file.layerSelectionPanels.find( Hud_GetParent( button ) )
	if ( index == -1 )
		return

	if ( Hud_IsFocused( button ) )
		Hud_SetFocused( button )

	foreach ( var arrowButton in file.layerToArrowButtons[index] )
	{
		if ( Hud_IsFocused( arrowButton ) )
			Hud_SetFocused( arrowButton )
	}
}


void function LayerSelector_OnRightClick( var button )
{
	                                                         
	int index = file.layerSelectionPanels.find( Hud_GetParent( button ) )
	if ( index == -1 )
		return

	EditorLayer ornull activeLayer = file.activeLayer
	if ( activeLayer == null )
		return

	expect EditorLayer( activeLayer )

	if ( activeLayer != file.editorLayers[index] )
	{
		file.activeLayer = file.editorLayers[index]
	}

	                                                                            
	ClubLogos_OpenColorSelectionMenu( file.layerSelectionPanels[index], activeLayer.layerData )
}


void function LeftArrowButton_OnActive( var button )
{
	if ( GetActiveMenu() != file.menu )
		return

	int index
	foreach( int panelIdx, array<var> buttonArray in file.layerToArrowButtons )
	{
		if ( buttonArray.contains( button ) )
		{
			index = panelIdx
			break
		}
	}

	if ( file.activeLayer == file.editorLayers[index] )
	{
		IncrementActiveLayerSelectedFlav( -1 )
	}
	else
	{
		file.activeLayer = file.editorLayers[index]
		IncrementActiveLayerSelectedFlav( -1 )
	}
}


void function RightArrowButton_OnActive( var button )
{
	if ( GetActiveMenu() != file.menu )
		return

	int index
	foreach( int panelIdx, array<var> buttonArray in file.layerToArrowButtons )
	{
		if ( buttonArray.contains( button ) )
		{
			index = panelIdx
			break
		}
	}

	if ( file.activeLayer == file.editorLayers[index] )
	{
		IncrementActiveLayerSelectedFlav( 1 )
	}
	else
	{
		file.activeLayer = file.editorLayers[index]
		IncrementActiveLayerSelectedFlav( 1 )
	}
}


void function RegisterLayerEditingInputs()
{
	RegisterButtonPressedCallback( BUTTON_DPAD_UP, OnDPadUpPressed )
	RegisterButtonPressedCallback( BUTTON_DPAD_DOWN, OnDpadDownPressed )
	RegisterButtonPressedCallback( BUTTON_DPAD_LEFT, OnDpadLeftPressed )
	RegisterButtonPressedCallback( BUTTON_DPAD_RIGHT, OnDpadRightPressed )
}


void function DeregisterLayerEditingInputs()
{
	DeregisterButtonPressedCallback( BUTTON_DPAD_UP, OnDPadUpPressed )
	DeregisterButtonPressedCallback( BUTTON_DPAD_DOWN, OnDpadDownPressed )
	DeregisterButtonPressedCallback( BUTTON_DPAD_LEFT, OnDpadLeftPressed )
	DeregisterButtonPressedCallback( BUTTON_DPAD_RIGHT, OnDpadRightPressed )
}


void function SubmitLogoButton_OnActivate( var button )
{
	ClubLogo newLogo
	asset frameMask
	float verticalOffset

	foreach ( EditorLayer layer in file.editorLayers )
	{
		ClubLogoLayer logoLayer
		logoLayer.elementFlav = layer.layerData.elementFlav
		logoLayer.primaryColorOverride = layer.layerData.primaryColorOverride
		logoLayer.secondaryColorOverride = layer.layerData.secondaryColorOverride
		logoLayer.secondaryColorAlpha = layer.layerData.secondaryColorAlpha
		logoLayer.verticalOffset = layer.layerData.verticalOffset
		logoLayer.frameMask = layer.layerData.frameMask
		                                               

		if ( ClubLogo_GetLogoElementType( logoLayer.elementFlav ) == eClubLogoElementType.CLUBLOGOTYPE_FRAME )
		{
			frameMask = logoLayer.frameMask
			verticalOffset = logoLayer.verticalOffset
		}

		newLogo.logoLayers.append( logoLayer )
	}

	newLogo.logoLayers.reverse()

	ClubCreation_SetClubLogoFromEditor( newLogo )
}


void function OnSetPrimaryColor( var button )
{
	                                                 

	EditorLayer ornull activeLayer = file.activeLayer
	if ( activeLayer == null )
		return

	expect EditorLayer( activeLayer )

	int layerIdx = file.editorLayers.find( activeLayer )

	if ( ClubLogo_GetLogoElementType( activeLayer.layerData.elementFlav ) == eClubLogoElementType.CLUBLOGOTYPE_FRAME )
	{
		printf( "LogoColorDebug: Setting channel 0 for Frame type logo element" )
		ClubLogos_OpenColorSelectionMenu( file.layerSelectionPanels[layerIdx], activeLayer.layerData, 0 )
	}
	else
	{
		printf( "LogoColorDebug: Setting channel 1 for non-frame logo element" )
		ClubLogos_OpenColorSelectionMenu( file.layerSelectionPanels[layerIdx], activeLayer.layerData, 1 )
	}
}


bool function CanSetPrimaryColor()
{
	return true
}


void function OnSetSecondaryColor( var button )
{
	EditorLayer ornull activeLayer = file.activeLayer
	if ( activeLayer == null )
		return

	expect EditorLayer( activeLayer )

	int layerIdx = file.editorLayers.find( activeLayer )

	ClubLogos_OpenColorSelectionMenu( file.layerSelectionPanels[layerIdx], activeLayer.layerData, 0 )
}


bool function CanSetSecondaryColor()
{
	EditorLayer ornull activeLayer = file.activeLayer
	if ( activeLayer == null )
		return false
	expect EditorLayer( activeLayer )

	asset ornull secondaryMask = ClubLogo_GetLogoSecondaryColorMask( activeLayer.layerData.elementFlav )

	if ( secondaryMask == null )
		return false
	else
		expect asset( secondaryMask )

	return ( secondaryMask != $"" )
}


void function OnDPadUpPressed( var button )
{
	if ( GetActiveMenu() != file.menu )
		return

	                                                
	EditorLayer ornull activeLayer = file.activeLayer
	if ( activeLayer == null )
		return

	expect EditorLayer( activeLayer )

	int layerIdx = file.editorLayers.find( activeLayer )

	int nextLayer = layerIdx + 1
	if ( nextLayer >= file.editorLayers.len() )
		nextLayer = 0

	                                                                                             
	file.activeLayer = file.editorLayers[ nextLayer ]

	RefreshEditor()
}


void function OnDpadDownPressed( var button )
{
	if ( GetActiveMenu() != file.menu )
		return

	                                                  
	EditorLayer ornull activeLayer = file.activeLayer
	if ( activeLayer == null )
		return

	expect EditorLayer( activeLayer )

	int layerIdx = file.editorLayers.find( activeLayer )

	int nextLayer = layerIdx - 1
	if ( nextLayer < 0 )
		nextLayer = file.editorLayers.len() - 1

	                                                                                               
	file.activeLayer = file.editorLayers[ nextLayer ]

	RefreshEditor()
}


void function OnDpadLeftPressed( var button )
{
	if ( GetActiveMenu() != file.menu )
		return

	                                                  
	IncrementActiveLayerSelectedFlav( -1 )
}


void function OnDpadRightPressed( var button )
{
	if ( GetActiveMenu() != file.menu )
		return

	                                                   
	IncrementActiveLayerSelectedFlav( 1 )
}


bool function CanNavigateBack()
{
	return GetActiveMenu() == file.menu
}


void function OnNavigateBack()
{
	if ( !CanNavigateBack() )
		return

	if ( GetActiveMenu() != file.menu )
		return

	if ( file.changesMade )
	{
		OpenUnsavedChangesDialog()
		return
	}

	CloseActiveMenu()
}

void function OpenUnsavedChangesDialog()
{
	ConfirmDialogData data
	data.headerText = "#CLUB_CREATION_LOGO"
	data.messageText = "#CLUB_DIALOG_UNSAVED_CHANGES"
	data.resultCallback = OnUnsavedChangesDialogResult

	OpenConfirmDialogFromData( data )
}

void function OnUnsavedChangesDialogResult( int result )
{
	if ( result == eDialogResult.YES )
	{
		CloseActiveMenu()
	}
}


                                                        
                                     
   
  	                                 
  	                                                                           
  	                                                                                                                                      
  	                                                                                      
  
  	                                                                           
  	                                                                                                                                      
  	                                                                                      
  
  	                            
   
  
  
                                      
   
  	                                 
  	                                                                            
  	                                                                                                                                      
  	                                                                                      
  
  	                                                                            
  	                                                                                                                                      
  	                                                                                      
  
  	                            
   


                                           
   
  	                                 
  	                                  
  
  	                                                                                     
  	                                                                                                                                                           
  	                                                                                                           
  
  	                                                                                     
  	                                                                                                                                                           
  	                                                                                                           
  
  	                                             
  		                            
  
  	                        
  		                                             
  
  	                             
  		                                      
  
  	                             
   


float function RoundFloat( float number )
{
	float integral = floor( number )
	float decimal  = fabs( number % 1 )

	if ( decimal >= 0.5 )
		integral += signum( integral )

	return integral
}