global function InitWeaponSkinsPanel
global function WeaponSkinsPanel_SetWeapon

struct PanelData
{
	var panel
	var weaponNameRui
	var ownedRui
	var listPanel

	ItemFlavor ornull weaponOrNull
	array<ItemFlavor> weaponSkinList
}

struct
{
	table<var, PanelData> panelDataMap
} file


void function InitWeaponSkinsPanel( var panel )
{
	Assert( !(panel in file.panelDataMap) )
	PanelData pd
	file.panelDataMap[ panel ] <- pd

	pd.weaponNameRui = Hud_GetRui( Hud_GetChild( panel, "WeaponName" ) )

	pd.ownedRui = Hud_GetRui( Hud_GetChild( panel, "Owned" ) )
	RuiSetString( pd.ownedRui, "title", Localize( "#OWNED" ).toupper() )

	pd.listPanel = Hud_GetChild( panel, "WeaponSkinList" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, WeaponSkinsPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, WeaponSkinsPanel_OnHide )
	AddPanelEventHandler_FocusChanged( panel, WeaponSkinsPanel_OnFocusChanged )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_SELECT", "", null, CustomizeMenus_IsFocusedItem )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP", null, CustomizeMenus_IsFocusedItemEquippable )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK", "#X_BUTTON_UNLOCK", null, CustomizeMenus_IsFocusedItemLocked )
	//
	//
}


void function WeaponSkinsPanel_SetWeapon( var panel, ItemFlavor ornull weaponFlavOrNull )
{
	PanelData pd = file.panelDataMap[panel]
	pd.weaponOrNull = weaponFlavOrNull
}


void function WeaponSkinsPanel_OnShow( var panel )
{
	RunClientScript( "UIToClient_ResetWeaponRotation" )
	RunClientScript( "EnableModelTurn" )

	//
	//
	//

	thread TrackIsOverScrollBar( file.panelDataMap[panel].listPanel )

	WeaponSkinsPanel_Update( panel )
}


void function WeaponSkinsPanel_OnHide( var panel )
{
	//
	Signal( uiGlobal.signalDummy, "TrackIsOverScrollBar" )

	RunClientScript( "EnableModelTurn" )
	WeaponSkinsPanel_Update( panel )
}


void function WeaponSkinsPanel_Update( var panel )
{
	PanelData pd    = file.panelDataMap[panel]
	var scrollPanel = Hud_GetChild( pd.listPanel, "ScrollPanel" )

	//
	foreach ( int flavIdx, ItemFlavor unused in pd.weaponSkinList)
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
		CustomizeButton_UnmarkForUpdating( button )
	}
	pd.weaponSkinList.clear()

	CustomizeMenus_SetActionButton( null )

	//
	if ( IsPanelActive( panel ) && pd.weaponOrNull != null )
	{
		ItemFlavor weapon  = expect ItemFlavor(pd.weaponOrNull)
		LoadoutEntry entry = Loadout_WeaponSkin( weapon )
		pd.weaponSkinList = GetLoadoutItemsSortedForMenu( entry, WeaponSkin_GetSortOrdinal )
		FilterWeaponSkinList( pd.weaponSkinList )

		RuiSetString( pd.weaponNameRui, "text", Localize( ItemFlavor_GetLongName( weapon ) ).toupper() )
		RuiSetString( pd.ownedRui, "collected", CustomizeMenus_GetCollectedString( entry, pd.weaponSkinList ) )

		Hud_InitGridButtons( pd.listPanel, pd.weaponSkinList.len() )
		foreach ( int flavIdx, ItemFlavor flav in pd.weaponSkinList )
		{
			var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
			CustomizeButton_UpdateAndMarkForUpdating( button, entry, flav, PreviewWeaponSkin, null )
		}

		CustomizeMenus_SetActionButton( Hud_GetChild( panel, "ActionButton" ) )
	}
}


void function WeaponSkinsPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) ) //
		return
	if ( GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()
}


void function PreviewWeaponSkin( ItemFlavor flav )
{
	RunClientScript( "UIToClient_PreviewWeaponSkin", ItemFlavor_GetNetworkIndex_DEPRECATED( flav ) )
}

void function FilterWeaponSkinList( array<ItemFlavor> weaponSkinList )
{
	for ( int i = weaponSkinList.len() - 1; i >= 0; i-- )
	{
		if ( !ShouldDisplayWeaponSkin( weaponSkinList[i] ) )
			weaponSkinList.remove( i )
	}
}

bool function ShouldDisplayWeaponSkin( ItemFlavor weaponSkin )
{
	if ( GladiatorCardWeaponSkin_ShouldHideIfLocked( weaponSkin ) )
	{
		if ( !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_CharacterClass(), weaponSkin ) )
			return false
	}

	return true
}