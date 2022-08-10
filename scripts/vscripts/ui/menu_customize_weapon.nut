global function InitCustomizeWeaponMenu

struct
{
	var        menu
	var        decorationRui
	var        titleRui
	array<var> weaponTabBodyPanelList

	array<ItemFlavor> weaponList
} file


void function InitCustomizeWeaponMenu( var newMenuArg )                                               
{
	var menu = GetMenu( "CustomizeWeaponMenu" )
	file.menu = menu

	SetTabRightSound( menu, "UI_Menu_ArmoryTab_Select" )
	SetTabLeftSound( menu, "UI_Menu_ArmoryTab_Select" )

	file.decorationRui = Hud_GetRui( Hud_GetChild( menu, "Decoration" ) )
	file.titleRui = Hud_GetRui( Hud_GetChild( menu, "Title" ) )

	file.weaponTabBodyPanelList = [
		Hud_GetChild( menu, "WeaponSkinsPanel0" )
		Hud_GetChild( menu, "WeaponSkinsPanel1" )
		Hud_GetChild( menu, "WeaponSkinsPanel2" )
		Hud_GetChild( menu, "WeaponSkinsPanel3" )
		Hud_GetChild( menu, "WeaponSkinsPanel4" )
		Hud_GetChild( menu, "WeaponSkinsPanel5" )
	]

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, CustomizeWeaponMenu_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, CustomizeWeaponMenu_OnShow )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, CustomizeWeaponMenu_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, CustomizeWeaponMenu_OnNavigateBack )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_SELECT", "" )
	AddMenuFooterOption( menu, LEFT, BUTTON_X, true, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP", null, CustomizeMenus_IsFocusedItemEquippable )
	AddMenuFooterOption( menu, LEFT, BUTTON_X, true, "#X_BUTTON_UNLOCK", "#X_BUTTON_UNLOCK", null, CustomizeMenus_IsFocusedItemLocked )
}


void function CustomizeWeaponMenu_OnOpen()
{
	                                                                      

	RuiSetGameTime( file.decorationRui, "initTime", ClientTime() )
	RuiSetString( file.titleRui, "title", Localize( ItemFlavor_GetLongName( GetTopLevelCustomizeContext() ) ).toupper() )

	AddCallback_OnTopLevelCustomizeContextChanged( file.menu, CustomizeWeaponMenu_Update )
	CustomizeWeaponMenu_Update( file.menu )

	TabData tabData = GetTabDataForPanel( file.menu )
	tabData.centerTabs = true
	if ( GetLastMenuNavDirection() == MENU_NAV_FORWARD )
	{
		ActivateTab( tabData, 0 )
	}
	      
	  	                                                            
}


void function CustomizeWeaponMenu_OnShow()
{
	UI_SetPresentationType( ePresentationType.WEAPON_SKIN )
}


void function CustomizeWeaponMenu_OnClose()
{
	RemoveCallback_OnTopLevelCustomizeContextChanged( file.menu, CustomizeWeaponMenu_Update )
	CustomizeWeaponMenu_Update( file.menu )
}


void function CustomizeWeaponMenu_Update( var menu )
{
	for ( int panelIdx = 0; panelIdx < file.weaponTabBodyPanelList.len(); panelIdx++ )
	{
		var tabBodyPanel = file.weaponTabBodyPanelList[panelIdx]
		WeaponSkinsPanel_SetWeapon( tabBodyPanel, null )
		if ( panelIdx < file.weaponList.len() )
		{
			ItemFlavor weapon = file.weaponList[panelIdx]
			Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.WeaponTab[weapon], OnNewnessQueryChangedUpdatePanelTab, tabBodyPanel )
		}
	}
	file.weaponList.clear()

	CharmsButton_Reset()

	ClearTabs( menu )

	                                   
	if ( GetActiveMenu() == menu )
	{
		ItemFlavor category = GetTopLevelCustomizeContext()
		file.weaponList = GetWeaponsInCategory( category )

		foreach ( int weaponIdx, ItemFlavor weapon in file.weaponList )
		{
			var tabBodyPanel = file.weaponTabBodyPanelList[weaponIdx]

			float tabBarLeftOffsetFracIfVisible = 0.0        
			AddTab( menu, tabBodyPanel, Localize( ItemFlavor_GetShortName( weapon ) ).toupper(), false, tabBarLeftOffsetFracIfVisible )

			WeaponSkinsPanel_SetWeapon( tabBodyPanel, weapon )
			Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.WeaponTab[weapon], OnNewnessQueryChangedUpdatePanelTab, tabBodyPanel )
		}
	}

	UpdateMenuTabs()
}


void function CustomizeWeaponMenu_OnNavigateBack()
{
	Assert( GetActiveMenu() == file.menu )

	if ( IsCharmsMenuActive() )
	{
		CharmsMenuEnableOrDisable()
		return
	}

	CloseActiveMenu()
}


