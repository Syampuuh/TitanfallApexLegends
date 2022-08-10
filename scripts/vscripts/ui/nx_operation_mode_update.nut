#if NX_PROG || PC_PROG_NX_UI

#if UI
global function UICodeCallback_OperationModeChanged
#endif

#if CLIENT
global function ClientCodeCallback_OperationModeChanged
#endif

global function IsNxSwitchingMode

bool isNxSwitchingMode = false

#if UI
void function UICodeCallback_OperationModeChanged()
{
	if ( IsNxHandheldMode() )
		printt( "UIScript: Switching to Handheld" )
	else
		printt( "UIScript: Switching to Dock" )

	var activeMenu = GetActiveMenu()

	if ( activeMenu && GetActiveMenuName() == "CharacterSelectMenuNew" )
		RunClientScript( "CharacterSelect_UpdateMenuButtons" )

	if ( activeMenu && GetActiveMenuName() == "CustomizeCharacterMenu" )
		RunClientScript( "ClearBattlePassItem" )

	isNxSwitchingMode = true

	if ( activeMenu != null )
	{
		if ( uiGlobal.menuData[ activeMenu ].hideFunc != null )
			uiGlobal.menuData[ activeMenu ].hideFunc()

		if ( uiGlobal.menuData[ activeMenu ].showFunc != null )
			uiGlobal.menuData[ activeMenu ].showFunc()

		UpdateMenuTabs()
	}

	if ( uiGlobal.activePanels.len() != 0 )
	{
		var activePanel = uiGlobal.activePanels.top()
		HidePanelInternal( activePanel )
		ShowPanelInternal( activePanel )
	}

	isNxSwitchingMode = false

	printt( "UIScript: Switch Completed" )
}
#endif      

#if CLIENT
void function ClientCodeCallback_OperationModeChanged()
{
	if( Survival_IsInventoryOpen() )
	{
		printt( "ClientScript: Inventory Opened" )
	}

	printt( "ClientScript: Switch Completed" )
}
#endif          

bool function IsNxSwitchingMode()
{
	return isNxSwitchingMode
}
#endif                            