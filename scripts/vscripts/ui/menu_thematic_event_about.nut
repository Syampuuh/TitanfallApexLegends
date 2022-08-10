global function ThematicEventAboutPage_Init

struct {
	var menu
	var infoPanel
} file

void function ThematicEventAboutPage_Init( var newMenuArg )
{
	file.menu = newMenuArg
	AddMenuEventHandler( newMenuArg, eUIEvent.MENU_OPEN, ThematicEventAboutPage_OnOpen )
	AddMenuEventHandler( newMenuArg, eUIEvent.MENU_CLOSE, ThematicEventAboutPage_OnClose )

	file.infoPanel = Hud_GetChild( file.menu, "InfoPanel" )

	AddMenuFooterOption( newMenuArg, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}

void function ThematicEventAboutPage_OnOpen()
{
	ItemFlavor ornull activeThemeShopEvent = GetActiveThemedShopEvent( GetUnixTimestamp() )
	if ( activeThemeShopEvent == null )
		return
	expect ItemFlavor( activeThemeShopEvent )

	HudElem_SetRuiArg( file.infoPanel, "eventName", ThemedShopEvent_GetTabText( activeThemeShopEvent ) )
	HudElem_SetRuiArg( file.infoPanel, "headerIcon", ThemedShopEvent_GetHeaderIcon( activeThemeShopEvent ) )
	HudElem_SetRuiArg( file.infoPanel, "specialTextCol", SrgbToLinear( ThemedShopEvent_GetAboutPageSpecialTextColor( activeThemeShopEvent ) ) )
	HudElem_SetRuiArg( file.infoPanel, "bgPatternImage", ThemedShopEvent_GetHeaderIcon( activeThemeShopEvent ) )

	array<string> aboutLines = ThemedShopEvent_GetAboutText( activeThemeShopEvent, GRX_IsOfferRestricted() )
	Assert( aboutLines.len() < 7, "Rui about_collection_event does not support more than 6 lines." )

	foreach ( int lineIdx, string line in aboutLines )
	{
		if ( line == "" )
			continue

		string aboutLine = "%@embedded_bullet_point%" + Localize( line )
		HudElem_SetRuiArg( file.infoPanel, "aboutLine" + lineIdx, aboutLine )
	}
}

void function ThematicEventAboutPage_OnClose()
{
	RunClientScript( "UIToClient_StopBattlePassScene" )
}
