global function InitClubsLogoElementSelectionMenu

global function ClubLogos_OpenElementSelectionMenu

struct
{
	var                      menu
	var                      menuHeaderRui
	var                      grid
	table< var, ItemFlavor > buttonToElementFlav
} file

void function InitClubsLogoElementSelectionMenu( var menu )
{
	printf( "ClubsDebug: InitClubsLogoElementSelectionPanel()" )
	file.menu = menu

	file.menuHeaderRui = Hud_GetRui( Hud_GetChild( menu, "MenuHeader" ) )
	RuiSetString( file.menuHeaderRui, "menuName", "#CLUBLOGOELEMENT_SELECTION" )

	file.grid = Hud_GetChild( file.menu, "ClubElementsGrid" )
	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, ElementSelection_OnShow )
	AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, ElementSelection_OnHide )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnNavigateBack )
}

void function ClubLogos_OpenElementSelectionMenu()
{
	AdvanceMenu( file.menu )
}

void function ElementSelection_OnShow()
{
	array<ItemFlavor> logoElements = GetAllClubLogoElementFlavors()

	int elementBtnCount = logoElements.len()
	Hud_InitGridButtons( file.grid, elementBtnCount )
	var scrollPanel = Hud_GetChild( file.grid, "ScrollPanel" )
	for ( int buttonIdx = 0; buttonIdx < elementBtnCount; buttonIdx++ )
	{
		var button = Hud_GetChild( scrollPanel, ("GridButton" + buttonIdx) )
		InitButtonRCP( button )
		InitElementButton( button, logoElements[buttonIdx] )
	}
}

void function ElementSelection_OnHide()
{
	                                  
}

void function InitElementButton( var button, ItemFlavor elementFlav )
{
	var buttonRui    = Hud_GetRui( button )
	asset layerImage = ClubLogo_GetLogoElementImage( elementFlav )
	string layerName = ClubLogo_GetLogoElementName( elementFlav )
	RuiSetImage( buttonRui, "elementImage", layerImage )
	HudElem_SetRuiArg( button, "alphaOverride", 1.0 )

	ToolTipData toolTipData
	toolTipData.descText = layerName
	Hud_SetToolTipData( button, toolTipData )

	bool isButtonMapped = (button in file.buttonToElementFlav)
	if ( !isButtonMapped )
	{
		printf( "ClubsDebug: InitElementButton: Button mapped to element %s (%s)", string(elementFlav), ClubLogo_GetLogoElementName( elementFlav ) )
		file.buttonToElementFlav[button] <- elementFlav
		Hud_AddEventHandler( button, UIE_CLICK, ElementButton_OnClick )
	}
}

void function ElementButton_OnClick( var button )
{
	Assert( button in file.buttonToElementFlav, "Club Logo Editor (Element Selection): Attempted to retrieve element from unmapped button" )
	ItemFlavor elementFlav = file.buttonToElementFlav[ button ]
	printf( "ClubsDebug: ElementButton_OnClick: Button = %s, ElementFlav = %s", string( button ), string( elementFlav ) )
	ClubLogoEditor_SetElementForActiveLayer( file.buttonToElementFlav[ button ] )

	                                                                                                                                               
	thread WaitFrameThenCloseMenu()
}

void function WaitFrameThenCloseMenu()
{
	WaitFrame()
	CloseElementSelectionMenu( null )
}

void function CloseElementSelectionMenu( var button )
{
	if ( GetActiveMenu() == file.menu )
		thread CloseActiveMenu()
}

void function OnNavigateBack()
{
	return
}