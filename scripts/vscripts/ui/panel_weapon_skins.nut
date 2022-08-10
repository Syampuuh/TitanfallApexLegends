global function InitWeaponSkinsPanel
global function WeaponSkinsPanel_SetWeapon

global function CharmsButton_Reset
global function CharmsMenuEnableOrDisable
global function IsCharmsMenuActive

struct PanelData
{
	var panel
	var weaponNameRui
	var ownedRui
	var listPanel
	var charmsButton

	ItemFlavor ornull weaponOrNull
	array<ItemFlavor> weaponSkinList
	array<ItemFlavor> weaponCharmList
}


struct
{
	table<var, PanelData> panelDataMap

	var         currentPanel = null
	ItemFlavor& currentWeapon
	ItemFlavor& currentWeaponSkin
	bool charmsMenuActive = false
} file


void function InitWeaponSkinsPanel( var panel )
{
	Assert( !(panel in file.panelDataMap) )
	PanelData pd
	file.panelDataMap[ panel ] <- pd

	pd.weaponNameRui = Hud_GetRui( Hud_GetChild( panel, "WeaponName" ) )

	pd.ownedRui = Hud_GetRui( Hud_GetChild( panel, "Owned" ) )
	RuiSetString( pd.ownedRui, "title", Localize( "#SKINS_OWNED" ).toupper() )

	pd.listPanel = Hud_GetChild( panel, "WeaponSkinList" )
	AddUICallback_InputModeChanged( OnInputModeChanged )

	pd.charmsButton = Hud_GetChild( panel, "CharmsButton" )
	Hud_SetVisible( pd.charmsButton, true )
	Hud_SetEnabled( pd.charmsButton, true )
	CharmsButton_Update( pd.charmsButton )
	AddButtonEventHandler( pd.charmsButton, UIE_CLICK, CharmsButton_OnClick )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, WeaponSkinsPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, WeaponSkinsPanel_OnHide )
	AddPanelEventHandler_FocusChanged( panel, WeaponSkinsPanel_OnFocusChanged )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_STICK_RIGHT, true, "#CONTROLLER_CHARMS_BUTTON", "#CHARMS_BUTTON", CharmsButton_OnRightStickClick, CharmsFooter_IsVisible )
	AddPanelFooterOption( panel, LEFT, BUTTON_STICK_RIGHT, true, "#CONTROLLER_SKINS_BUTTON", "#SKINS_BUTTON", CharmsButton_OnRightStickClick, SkinsFooter_IsVisible )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_SELECT", "", null, CustomizeMenus_IsFocusedItem )

	#if NX_PROG || PC_PROG_NX_UI
		AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP", null, CustomizeMenus_IsFocusedItemEquippable )
		AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK", "#X_BUTTON_UNLOCK", null, CustomizeMenus_IsFocusedItemLocked )
		AddPanelFooterOption( panel, LEFT, BUTTON_TRIGGER_LEFT, false, "#MENU_ZOOM_CONTROLS_GAMEPAD", "#MENU_ZOOM_CONTROLS", null, ZoomFooter_IsVisible )
	#else
		AddPanelFooterOption( panel, RIGHT, BUTTON_X, false, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP", null, CustomizeMenus_IsFocusedItemEquippable )
		AddPanelFooterOption( panel, RIGHT, BUTTON_X, false, "#X_BUTTON_UNLOCK", "#X_BUTTON_UNLOCK", null, CustomizeMenus_IsFocusedItemLocked )
		AddPanelFooterOption( panel, RIGHT, BUTTON_TRIGGER_LEFT, false, "#MENU_ZOOM_CONTROLS_GAMEPAD", "#MENU_ZOOM_CONTROLS", null, ZoomFooter_IsVisible )
	#endif

	void functionref( var ) func = (
		void function( var button ) : ()
		{
			var listPanel = file.panelDataMap[ file.currentPanel ].listPanel
			SetOrClearFavoriteFromFocus( listPanel )
		}
	)

	#if NX_PROG || PC_PROG_NX_UI
		AddPanelFooterOption( panel, LEFT, BUTTON_Y, false, "#Y_BUTTON_SET_FAVORITE", "#Y_BUTTON_SET_FAVORITE", func, CustomizeMenus_IsFocusedItemFavoriteable )
		AddPanelFooterOption( panel, LEFT, BUTTON_Y, false, "#Y_BUTTON_CLEAR_FAVORITE", "#Y_BUTTON_CLEAR_FAVORITE", func, CustomizeMenus_IsFocusedItemFavorite )
	#else
		AddPanelFooterOption( panel, RIGHT, BUTTON_Y, false, "#Y_BUTTON_SET_FAVORITE", "#Y_BUTTON_SET_FAVORITE", func, CustomizeMenus_IsFocusedItemFavoriteable )
		AddPanelFooterOption( panel, RIGHT, BUTTON_Y, false, "#Y_BUTTON_CLEAR_FAVORITE", "#Y_BUTTON_CLEAR_FAVORITE", func, CustomizeMenus_IsFocusedItemFavorite )
	#endif
	                                                                                                                              
	                                                                                              
}


bool function ZoomFooter_IsVisible()
{
	bool result = CharmsFooter_IsVisible()
	return result

	return true
}


bool function SkinsFooter_IsVisible()
{
	return IsCharmsMenuActive()
}

bool function CharmsFooter_IsVisible()
{
	bool result = IsCharmsMenuActive()
	return !result
}

bool function IsCharmsMenuActive()
{
	return file.charmsMenuActive
}

void function CharmsMenuEnableOrDisable()
{
	if ( file.charmsMenuActive )
	{
		UI_SetPresentationType( ePresentationType.WEAPON_SKIN )
		file.charmsMenuActive = false
	}
	else
	{
		UI_SetPresentationType( ePresentationType.WEAPON_CHARMS )
		file.charmsMenuActive = true
	}

	foreach ( var panel, PanelData pd in file.panelDataMap )
	{
		CharmsButton_Update( pd.charmsButton )
	}

	WeaponSkinsPanel_Update( file.currentPanel )
}

void function CharmsButton_Reset()
{
	file.charmsMenuActive = false

	foreach ( var panel, PanelData pd in file.panelDataMap )
	{
		CharmsButton_Update( pd.charmsButton )
	}
}

void function CharmsButton_Update( var button )
{
	string buttonText
	bool controllerActive = IsControllerModeActive()

	if ( file.charmsMenuActive )
	{
		buttonText = controllerActive ? "#CONTROLLER_SKINS_BUTTON" : "#SKINS_BUTTON"
		Hud_SetNew( button, false )
	}
	else
	{
		buttonText = controllerActive ? "#CONTROLLER_CHARMS_BUTTON" : "#CHARMS_BUTTON"
		int newCount = Newness_ReverseQuery_GetNewCount( NEWNESS_QUERIES.WeaponCharmButton )
		Hud_SetNew( button, newCount > 0 )
	}

	HudElem_SetRuiArg( button, "centerText", buttonText )
	UpdateFooterOptions()
}


void function CharmsButton_OnRightStickClick( var button )
{
	EmitUISound( "UI_Menu_accept" )
	CharmsButton_OnClick( button )
}

void function CharmsButton_OnClick( var button )
{
	CharmsMenuEnableOrDisable()
}

void function OnInputModeChanged( bool controllerModeActive )
{
	foreach ( var panel, PanelData pd in file.panelDataMap )
		CharmsButton_Update( pd.charmsButton )
}


void function WeaponSkinsPanel_SetWeapon( var panel, ItemFlavor ornull weaponFlavOrNull )
{
	PanelData pd = file.panelDataMap[panel]
	pd.weaponOrNull = weaponFlavOrNull
}


void function WeaponSkinsPanel_OnShow( var panel )
{
	bool charmsActive = file.charmsMenuActive

	if ( !charmsActive )
		RunClientScript( "UIToClient_ResetWeaponRotation" )

	RunClientScript( "EnableModelTurn" )

	file.currentPanel = panel

	                                                                                        
	                                                                                 
	                                                      

	thread TrackIsOverScrollBar( file.panelDataMap[panel].listPanel )

	WeaponSkinsPanel_Update( panel )
}


void function WeaponSkinsPanel_OnHide( var panel )
{
	                                                                                    
	Signal( uiGlobal.signalDummy, "TrackIsOverScrollBar" )

	RunClientScript( "EnableModelTurn" )
	WeaponSkinsPanel_Update( panel )
}


void function WeaponSkinsPanel_Update( var panel )
{
	PanelData pd    = file.panelDataMap[panel]
	var scrollPanel = Hud_GetChild( pd.listPanel, "ScrollPanel" )

	          
	foreach ( int flavIdx, ItemFlavor unused in pd.weaponCharmList )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
		CustomizeButton_UnmarkForUpdating( button )
	}
	pd.weaponCharmList.clear()

	foreach ( int flavIdx, ItemFlavor unused in pd.weaponSkinList)
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
		CustomizeButton_UnmarkForUpdating( button )
	}
	pd.weaponSkinList.clear()

	CustomizeMenus_SetActionButton( null )

	               
	string ownedText = file.charmsMenuActive ? "#CHARMS_OWNED" : "#SKINS_OWNED"

	RuiSetString( pd.ownedRui, "title", Localize( ownedText ).toupper() )

	                                  
	if ( IsPanelActive( panel ) && pd.weaponOrNull != null )
	{
		file.currentWeapon = expect ItemFlavor(pd.weaponOrNull)
		LoadoutEntry entry
		array<ItemFlavor> itemList
		void functionref( ItemFlavor ) previewFunc
		void functionref( ItemFlavor, var ) customButtonUpdateFunc
		void functionref( ItemFlavor, void functionref() ) confirmationFunc
		bool ignoreDefaultItemForCount
		bool shouldIgnoreOtherSlots

		if ( file.charmsMenuActive )
		{
			entry = Loadout_WeaponCharm( file.currentWeapon )
			pd.weaponCharmList = GetLoadoutItemsSortedForMenu( entry, WeaponCharm_GetSortOrdinal )
			itemList = pd.weaponCharmList
			previewFunc = PreviewWeaponCharm
			customButtonUpdateFunc = (void function( ItemFlavor charmFlav, var rui )
			{
				                                                                      
				asset img = $""

				ItemFlavor ornull weaponFlavorOrNull = GetWeaponThatCharmIsCurrentlyEquippedToForPlayer( ToEHI( GetLocalClientPlayer() ), charmFlav )
				if ( weaponFlavorOrNull != null )
				{
					ItemFlavor weaponFlavorThatCharmIsEquippedTo = expect ItemFlavor( weaponFlavorOrNull )
					if ( weaponFlavorThatCharmIsEquippedTo != file.currentWeapon )
					{
						img = WeaponItemFlavor_GetHudIcon( weaponFlavorThatCharmIsEquippedTo )
						RuiSetBool( rui, "isEquipped", false )             
					}
				}


				RuiSetAsset( rui, "equippedCharmWeaponAsset", img )
			})
			confirmationFunc = (void function( ItemFlavor charmFlav, void functionref() proceedCb ) {
				                                                                                          
				ItemFlavor ornull charmCurrentWeaponFlav = GetWeaponThatCharmIsCurrentlyEquippedToForPlayer( LocalClientEHI(), charmFlav )
				if ( charmCurrentWeaponFlav == null || charmCurrentWeaponFlav == file.currentWeapon )
				{
					proceedCb()
					return
				}
				expect ItemFlavor(charmCurrentWeaponFlav)
				string localizedEquippedWeaponName = Localize( ItemFlavor_GetShortName( charmCurrentWeaponFlav ) )
				string localizedCurrentWeaponName = Localize( ItemFlavor_GetShortName( file.currentWeapon ) )

				ConfirmDialogData data
				data.headerText = Localize( "#CHARM_DIALOG", localizedEquippedWeaponName )
				data.messageText = Localize( "#CHARM_DIALOG_DESC", localizedCurrentWeaponName, localizedEquippedWeaponName )
				data.resultCallback = (void function( int result ) : ( charmCurrentWeaponFlav, proceedCb )
				{
					if ( result != eDialogResult.YES )
						return

					RequestSetItemFlavorLoadoutSlot( LocalClientEHI(), Loadout_WeaponCharm( charmCurrentWeaponFlav ), GetItemFlavorByAsset( $"settings/itemflav/weapon_charm/none.rpak" ) )

					proceedCb()
				})
				OpenConfirmDialogFromData( data )
			})
			ignoreDefaultItemForCount = true
			shouldIgnoreOtherSlots = true
		}
		else
		{
			entry = Loadout_WeaponSkin( file.currentWeapon )
			pd.weaponSkinList = GetLoadoutItemsSortedForMenu( entry, WeaponSkin_GetSortOrdinal )
			FilterWeaponSkinList( pd.weaponSkinList )
			itemList = pd.weaponSkinList
			previewFunc = PreviewWeaponSkin
			confirmationFunc = null
			ignoreDefaultItemForCount = false
			shouldIgnoreOtherSlots = false

			customButtonUpdateFunc = (void function( ItemFlavor charmFlav, var rui )
			{
				RuiSetAsset( rui, "equippedCharmWeaponAsset", $"" )
			})
		}

		RuiSetString( pd.weaponNameRui, "text", Localize( ItemFlavor_GetLongName( file.currentWeapon ) ).toupper() )
		RuiSetString( pd.ownedRui, "collected", CustomizeMenus_GetCollectedString( entry, itemList, ignoreDefaultItemForCount, shouldIgnoreOtherSlots ) )

		Hud_InitGridButtons( pd.listPanel, itemList.len() )

		foreach ( int flavIdx, ItemFlavor flav in itemList )
		{
			var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
			CustomizeButton_UpdateAndMarkForUpdating( button, [entry], flav, previewFunc, null, false, customButtonUpdateFunc, confirmationFunc )
		}

		CustomizeMenus_SetActionButton( Hud_GetChild( panel, "ActionButton" ) )
	}
}


void function WeaponSkinsPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) )                  
		return
	if ( GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()

	if ( IsControllerModeActive() )
		CustomizeMenus_UpdateActionContext( newFocus )
}

void function PreviewWeaponCharm( ItemFlavor charmFlavor )
{
	#if DEV
		if ( InputIsButtonDown( KEY_LSHIFT ) )
		{
			string locedName = Localize( ItemFlavor_GetLongName( charmFlavor ) )
			printt( "\"" + locedName + "\" grx ref is: " + GetGlobalSettingsString( ItemFlavor_GetAsset( charmFlavor ), "grxRef" ) )
			printt( "\"" + locedName + "\" charm model is: " + WeaponCharm_GetCharmModel( charmFlavor ) )
		}
	#endif       

	ItemFlavor charmWeaponSkin = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_WeaponSkin( file.currentWeapon ) )
	int weaponSkinId           = ItemFlavor_GetNetworkIndex( charmWeaponSkin )
	int weaponCharmId          = ItemFlavor_GetNetworkIndex( charmFlavor )
	bool shouldHighlightWeapon = file.currentWeaponSkin == charmWeaponSkin ? false : true
	file.currentWeaponSkin = charmWeaponSkin

	RunClientScript( "UIToClient_PreviewWeaponSkin", weaponSkinId, weaponCharmId, shouldHighlightWeapon )
}

void function PreviewWeaponSkin( ItemFlavor weaponSkinFlavor )
{
	#if DEV
		if ( InputIsButtonDown( KEY_LSHIFT ) )
		{
			string locedName = Localize( ItemFlavor_GetLongName( weaponSkinFlavor ) )
			printt( "\"" + locedName + "\" grx ref is: " + GetGlobalSettingsString( ItemFlavor_GetAsset( weaponSkinFlavor ), "grxRef" ) )
			printt( "\"" + locedName + "\" world model is: " + WeaponSkin_GetWorldModel( weaponSkinFlavor ) )
		}
	#endif       

	ItemFlavor charmFlavor = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_WeaponCharm( WeaponSkin_GetWeaponFlavor( weaponSkinFlavor ) ) )
	int weaponCharmId      = ItemFlavor_GetNetworkIndex( charmFlavor )

	int weaponSkinId = ItemFlavor_GetNetworkIndex( weaponSkinFlavor )
	file.currentWeaponSkin = weaponSkinFlavor

	RunClientScript( "UIToClient_PreviewWeaponSkin", weaponSkinId, weaponCharmId, true )
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
	if ( WeaponSkin_ShouldHideIfLocked( weaponSkin ) )
	{
		LoadoutEntry entry = Loadout_WeaponSkin( WeaponSkin_GetWeaponFlavor( weaponSkin ) )
		if ( !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), entry, weaponSkin ) )
			return false
	}

	return true
}