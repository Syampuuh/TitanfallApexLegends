global function InitCharacterSkinsPanel

                                           

struct
{
	var               panel
	var               headerRui
	var               listPanel
	array<ItemFlavor> characterSkinList

	var equipButton
	var blurbPanel
	var heirloomButton

	var mythicPanel
	var mythicSelection
	var mythicLeftButton
	var mythicRightButton
	var mythicTrackingButton
	var mythicEquipButton
	var mythicGridButton

	int activeMythicSkinTier = 0
} file

void function InitCharacterSkinsPanel( var panel )
{
	file.panel = panel
	file.listPanel = Hud_GetChild( panel, "CharacterSkinList" )
	file.headerRui = Hud_GetRui( Hud_GetChild( panel, "Header" ) )

	SetPanelTabTitle( panel, "#SKINS" )
	RuiSetString( file.headerRui, "title", Localize( "#OWNED" ).toupper() )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, CharacterSkinsPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, CharacterSkinsPanel_OnHide )
	AddPanelEventHandler_FocusChanged( panel, CharacterSkinsPanel_OnFocusChanged )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_SELECT", "", null, CustomizeMenus_IsFocusedItem )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK_LEGEND", "#X_BUTTON_UNLOCK_LEGEND", null, CustomizeMenus_IsFocusedItemParentItemLocked )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP", null, CustomizeMenus_IsFocusedItemEquippable )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK", "#X_BUTTON_UNLOCK", null, CustomizeMenus_IsFocusedItemLocked )
	#if NX_PROG || PC_PROG_NX_UI
		AddPanelFooterOption( panel, LEFT, BUTTON_STICK_LEFT, false, "#MENU_ZOOM_CONTROLS_GAMEPAD", "#MENU_ZOOM_CONTROLS" )
	#else
		AddPanelFooterOption( panel, RIGHT, BUTTON_STICK_LEFT, false, "#MENU_ZOOM_CONTROLS_GAMEPAD", "#MENU_ZOOM_CONTROLS" )
	#endif
	var listPanel = file.listPanel
	void functionref( var ) func = (
		void function( var button ) : ( listPanel )
		{
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
	
	                                                                                                                                           
	                                                                                                                     
	                                                                                                                       
	                                                                                                                        

	file.heirloomButton = Hud_GetChild( panel, "EquipHeirloomButton" )
	HudElem_SetRuiArg( file.heirloomButton, "bigText", "" )
	HudElem_SetRuiArg( file.heirloomButton, "buttonText", "" )
	HudElem_SetRuiArg( file.heirloomButton, "descText", "" )
	Hud_AddEventHandler( file.heirloomButton, UIE_CLICK, CustomizeCharacterMenu_HeirloomButton_OnActivate )
	                                                     

	file.mythicEquipButton =  Hud_GetChild( panel, "EquipMythicButton" )
	HudElem_SetRuiArg( file.mythicEquipButton, "centerText", "EQUIP" )
	Hud_AddEventHandler( file.mythicEquipButton, UIE_CLICK, MythicEquipButton_OnActivate )

	file.mythicPanel = Hud_GetChild( panel, "MythicSkinInfo" )
	file.mythicSelection = Hud_GetChild( panel, "MythicSkinSelection" )
	file.mythicTrackingButton = Hud_GetChild( panel, "TrackMythicButton" )
	Hud_AddEventHandler( file.mythicTrackingButton, UIE_CLICK, MythicTrackingButton_OnClick )

	file.mythicLeftButton = Hud_GetChild( panel, "MythicSkinLeftButton" )
	Hud_AddEventHandler( file.mythicLeftButton, UIE_CLICK, LeftMythicSkinButton_OnActivate )
	file.mythicRightButton = Hud_GetChild( panel, "MythicSkinRightButton" )
	Hud_AddEventHandler( file.mythicRightButton, UIE_CLICK, RightMythicSkinButton_OnActivate )

	Hud_SetVisible( file.mythicSelection, false )
	Hud_SetVisible( file.mythicLeftButton, false )
	Hud_SetVisible( file.mythicRightButton, false )
	Hud_SetVisible( file.mythicTrackingButton, false )
	Hud_SetVisible( file.mythicPanel, false )

	file.equipButton = Hud_GetChild( panel, "ActionButton" )
	file.blurbPanel = Hud_GetChild( panel, "SkinBlurb" )

	Hud_SetVisible( file.blurbPanel, false )
}


void function CharacterSkinsPanel_OnShow( var panel )
{
	SetCurrentTabForPIN( Hud_GetHudName( panel ) )
	UI_SetPresentationType( ePresentationType.CHARACTER_SKIN )

	AddCallback_OnTopLevelCustomizeContextChanged( panel, CharacterSkinsPanel_Update )
	RunClientScript( "EnableModelTurn" )
	thread TrackIsOverScrollBar( file.listPanel )
	CharacterSkinsPanel_Update( panel )

	                                             
	AddCallback_ItemFlavorLoadoutSlotDidChange_SpecificPlayer( LocalClientEHI(), Loadout_MeleeSkin( GetTopLevelCustomizeContext() ), OnMeleeSkinChanged )
	CustomizeCharacterMenu_UpdateHeirloomButton()

	UpdateMythicTrackingButton()
	FocusOnMythicSkinIfAnyTierEquiped()
}


void function CharacterSkinsPanel_OnHide( var panel )
{
	RemoveCallback_OnTopLevelCustomizeContextChanged( panel, CharacterSkinsPanel_Update )
	Signal( uiGlobal.signalDummy, "TrackIsOverScrollBar" )
	RunClientScript( "EnableModelTurn" )
	CharacterSkinsPanel_Update( panel )

	                                                    
	RemoveCallback_ItemFlavorLoadoutSlotDidChange_SpecificPlayer( LocalClientEHI(), Loadout_MeleeSkin( GetTopLevelCustomizeContext() ), OnMeleeSkinChanged )
}


void function CharacterSkinsPanel_Update( var panel )
{
	var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )

	          
	foreach ( int flavIdx, ItemFlavor unused in file.characterSkinList )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
		CustomizeButton_UnmarkForUpdating( button )
	}
	file.characterSkinList.clear()

	CustomizeMenus_SetActionButton( null )

	RunMenuClientFunction( "ClearAllCharacterPreview" )

	Hud_SetVisible( file.blurbPanel, false )
	Hud_SetVisible( file.mythicPanel, false )
	Hud_SetVisible( file.mythicSelection, false )
	Hud_SetVisible( file.mythicLeftButton, false )
	Hud_SetVisible( file.mythicRightButton, false )
	Hud_SetVisible( file.mythicTrackingButton, false )

	void functionref( ItemFlavor, var ) customButtonUpdateFunc

	customButtonUpdateFunc = (void function( ItemFlavor itemFlav, var rui )
	{
		bool isMythic = Mythics_IsItemFlavorMythicSkin( itemFlav )
		if ( isMythic )
		{
			RuiSetInt( rui, "highestMythicTier", Mythics_GetNumTiersUnlockedForSkin( GetLocalClientPlayer(), itemFlav ) )
		}
		RuiSetBool( rui, "showMythicIcons", isMythic )
	})

	                                  
	if ( IsPanelActive( file.panel ) && IsTopLevelCustomizeContextValid() )
	{
		LoadoutEntry entry = Loadout_CharacterSkin( GetTopLevelCustomizeContext() )
		file.characterSkinList = GetLoadoutItemsSortedForMenu( entry, CharacterSkin_GetSortOrdinal )
		FilterCharacterSkinList( file.characterSkinList )

		Hud_InitGridButtons( file.listPanel, file.characterSkinList.len() )
		foreach ( int flavIdx, ItemFlavor flav in file.characterSkinList )
		{
			var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
			if( Mythics_IsItemFlavorMythicSkin( flav ) )
			{
				flav = expect ItemFlavor( Mythics_GetSkinTierForCharacter( GetTopLevelCustomizeContext(), file.activeMythicSkinTier ) )
				file.mythicGridButton = button
			}

			CustomizeButton_UpdateAndMarkForUpdating( button, [entry], flav, PreviewCharacterSkin, CanEquipCanBuyCharacterItemCheck,false, customButtonUpdateFunc )
		}

		CustomizeMenus_SetActionButton( Hud_GetChild( panel, "ActionButton" ) )
		RuiSetString( file.headerRui, "collected", CustomizeMenus_GetCollectedString( entry, file.characterSkinList , false, false ) )
	}
}


void function CharacterSkinsPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) )                  
		return
	if ( GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()

	if ( IsControllerModeActive() )
		CustomizeMenus_UpdateActionContext( newFocus )
}


void function PreviewCharacterSkin( ItemFlavor flav )
{
	#if DEV
		if ( InputIsButtonDown( KEY_LSHIFT ) )
		{
			string locedName = Localize( ItemFlavor_GetLongName( flav ) )
			printt( "\"" + locedName + "\" grx ref is: " + GetGlobalSettingsString( ItemFlavor_GetAsset( flav ), "grxRef" ) )
			printt( "\"" + locedName + "\" body model is: " +  CharacterSkin_GetBodyModel( flav ) )

		}
	#endif       

	                   
	if ( CharacterSkin_HasStoryBlurb( flav ) )
	{
		Hud_SetVisible( file.blurbPanel, true )
		ItemFlavor characterFlav = CharacterSkin_GetCharacterFlavor( flav )

		asset portraitImage = ItemFlavor_GetIcon( characterFlav )
		CharacterHudUltimateColorData colorData = CharacterClass_GetHudUltimateColorData( characterFlav )

		var rui = Hud_GetRui( file.blurbPanel )
		RuiSetString( rui, "characterName", ItemFlavor_GetShortName( characterFlav ) )
		RuiSetString( rui, "skinNameText", ItemFlavor_GetLongName( flav ) )
		RuiSetString( rui, "bodyText", CharacterSkin_GetStoryBlurbBodyText( flav ) )
		RuiSetImage( rui, "portraitIcon", portraitImage )
		RuiSetFloat3( rui, "characterColor", SrgbToLinear( colorData.ultimateColor ) )
		RuiSetGameTime( rui, "startTime", ClientTime() )
	}
	else
	{
		Hud_SetVisible( file.blurbPanel, false )
	}

	if( Mythics_IsItemFlavorMythicSkin( flav ) )
	{
		Hud_SetVisible( file.mythicPanel, true )
		Hud_SetVisible( file.mythicSelection, true )
		Hud_SetVisible( file.mythicLeftButton, true )
		Hud_SetVisible( file.mythicRightButton, true )
		UpdateMythicSkinInfo()
		flav = expect ItemFlavor( Mythics_GetItemTierForSkin( flav, file.activeMythicSkinTier ) )
	}
	else
	{
		Hud_SetVisible( file.mythicPanel, false )
		Hud_SetVisible( file.mythicSelection, false )
		Hud_SetVisible( file.mythicLeftButton, false )
		Hud_SetVisible( file.mythicRightButton, false )
		Hud_SetVisible( file.mythicTrackingButton, false )
	}

	RunClientScript( "UIToClient_PreviewCharacterSkinFromCharacterSkinPanel", ItemFlavor_GetNetworkIndex( flav ), ItemFlavor_GetNetworkIndex( GetTopLevelCustomizeContext() ) )
}


void function UpdateMythicSkinInfo()
{
	ItemFlavor characterFlav = GetTopLevelCustomizeContext()
	asset portraitImage = ItemFlavor_GetIcon( characterFlav )
	ItemFlavor challenge = Mythics_GetChallengeForCharacter( characterFlav )

	var rui = Hud_GetRui( file.mythicPanel )
	RuiSetInt( rui, "activeTierIndex", file.activeMythicSkinTier + 1 )

	if(  file.activeMythicSkinTier - 1 < 0 )
		RuiSetString( rui, "challengeTierDesc", "#MYTHIC_SKIN_UNLOCK_DESC" )
	else
		RuiSetString( rui, "challengeTierDesc", Challenge_GetDescription( challenge, file.activeMythicSkinTier - 1 ) )

	entity player = GetLocalClientPlayer()


	int currentTier = -1
	int currentProgress = -1
	int goalProgress = -1

	if ( DoesPlayerHaveChallenge( player, challenge ) )
	{
		currentTier = Challenge_GetCurrentTier( player, challenge )

		if( !Challenge_IsComplete( player, challenge ) )
		{
			currentProgress = Challenge_GetProgressValue( player, challenge, currentTier )
			goalProgress    = Challenge_GetGoalVal( challenge, currentTier )
		}
	}
	else
	{
		print("Player has mythic skin but does not have the challenge to go with it")
	}

	bool showProgressBar = true
	bool showTick = true
	bool isTier1Completed = currentTier > 0

	ItemFlavor characterSkin = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_CharacterSkin( characterFlav ) )
	ItemFlavor previewSkin = expect ItemFlavor( Mythics_GetSkinTierForCharacter( characterFlav, file.activeMythicSkinTier ) )
	bool isEquiped = ( characterSkin == previewSkin )
	Hud_SetVisible( file.equipButton, !isEquiped )

	switch ( file.activeMythicSkinTier )
	{
		case 0:
			showProgressBar = false
			Hud_SetVisible( file.mythicTrackingButton, false )
			break

		case 1:

			showTick = isTier1Completed
			showProgressBar = !showTick
			Hud_SetVisible( file.equipButton, isTier1Completed && !isEquiped )
			Hud_SetVisible( file.mythicTrackingButton, !isTier1Completed )
			break

		case 2:
			bool isTier2Completed = DoesPlayerHaveChallenge( player, challenge ) ? Challenge_IsComplete( player, challenge ) : false
			showTick = isTier2Completed
			showProgressBar = isTier1Completed ? !isTier2Completed : false
			Hud_SetVisible( file.mythicTrackingButton, !isTier2Completed )
			Hud_SetVisible( file.equipButton, isTier2Completed && !isEquiped )
			break

		default:
			break
	}

	RuiSetInt( rui, "challengeTierProgress", currentProgress )
	RuiSetInt( rui, "challengeTierGoal", goalProgress )
	RuiSetBool( rui, "showProgressBar", showProgressBar )
	RuiSetBool( rui, "showTickbox", showTick )
	RuiSetImage( rui, "portraitIcon", portraitImage )

	var ruisel = Hud_GetRui( file.mythicSelection )
	RuiSetInt( ruisel, "selectionID", file.activeMythicSkinTier )
}

void function OnMeleeSkinChanged( EHI playerEHI, ItemFlavor flavor )
{
	CustomizeCharacterMenu_UpdateHeirloomButton()
}

ItemFlavor ornull function GetMeleeHeirloom( ItemFlavor character )
{
	LoadoutEntry entry = Loadout_MeleeSkin( GetTopLevelCustomizeContext() )
	array<ItemFlavor> melees = GetValidItemFlavorsForLoadoutSlot( LocalClientEHI(), entry )

	foreach ( meleeFlav in melees )
	{
		if ( ItemFlavor_GetQuality( meleeFlav ) == eRarityTier.HEIRLOOM )
		{
			return meleeFlav
		}
	}

	return null
}

void function CustomizeCharacterMenu_UpdateHeirloomButton()
{
	LoadoutEntry entry = Loadout_MeleeSkin( GetTopLevelCustomizeContext() )
	ItemFlavor ornull meleeHeirloom = GetMeleeHeirloom( GetTopLevelCustomizeContext() )
	if ( meleeHeirloom != null )
	{
		expect ItemFlavor( meleeHeirloom )

		Hud_Show( file.heirloomButton )

		bool isEquipped = (LoadoutSlot_GetItemFlavor( LocalClientEHI(), entry ) == meleeHeirloom)
		bool isEquippable = IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), entry, meleeHeirloom )
		string meleeName = ItemFlavor_GetLongName( meleeHeirloom )

		Hud_SetLocked( file.heirloomButton, !isEquippable )
		Hud_ClearToolTipData( file.heirloomButton )

		HudElem_SetRuiArg( file.heirloomButton, "buttonText", Localize( meleeName ) )
		if ( !isEquippable )
		{
			HudElem_SetRuiArg( file.heirloomButton, "descText", Localize( "#MENU_ITEM_LOCKED" ) )
			HudElem_SetRuiArg( file.heirloomButton, "bigText", "`1%$rui/menu/store/reqs_locked%" )
			Hud_Hide( file.heirloomButton )
		}
		else if ( isEquipped )
		{
			HudElem_SetRuiArg( file.heirloomButton, "descText", Localize( "#EQUIPPED_LOOT_REWARD" ) )
			HudElem_SetRuiArg( file.heirloomButton, "bigText", "`1%$rui/hud/check_selected%" )
		}
		else
		{
			HudElem_SetRuiArg( file.heirloomButton, "descText", Localize( "#EQUIP_LOOT_REWARD" ) )
			HudElem_SetRuiArg( file.heirloomButton, "bigText", "`1%$rui/borders/key_border%" )
		}
	}
	else
	{
		Hud_Hide( file.heirloomButton )
	}
}

void function CustomizeCharacterMenu_HeirloomButton_OnActivate( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	LoadoutEntry entry = Loadout_MeleeSkin( GetTopLevelCustomizeContext() )
	ItemFlavor ornull meleeHeirloom = GetMeleeHeirloom( GetTopLevelCustomizeContext() )

	if ( meleeHeirloom == null )
		return

	array<ItemFlavor> meleeSkinList = RegisterReferencedItemFlavorsFromArray( GetTopLevelCustomizeContext(), "meleeSkins", "flavor" )
	Assert( meleeSkinList.len() == 2 )

	ItemFlavor context = GetTopLevelCustomizeContext()
	ItemFlavor meleeToEquip

	foreach ( meleeFlav in meleeSkinList )
	{
		bool isEquipped = (LoadoutSlot_GetItemFlavor( LocalClientEHI(), entry ) == meleeFlav )
		if ( !isEquipped )
		{
			meleeToEquip = meleeFlav
			break
		}
	}

	PIN_Customization( context, meleeToEquip, "equip" )
	RequestSetItemFlavorLoadoutSlot( LocalClientEHI(), entry, meleeToEquip )
}


void function MythicEquipButton_OnActivate( var button )
{
	ItemFlavor character = GetTopLevelCustomizeContext()
	LoadoutEntry entry = Loadout_CharacterSkin( character )

	ItemFlavor characterSkin = LoadoutSlot_GetItemFlavor( LocalClientEHI(), entry )
	ItemFlavor previewSkin = expect ItemFlavor( Mythics_GetSkinTierForCharacter( character, file.activeMythicSkinTier ) )
	bool isEquiped = ( characterSkin == previewSkin )

	if( isEquiped )
		return

	PIN_Customization( character, previewSkin, "equip" )
	RequestSetItemFlavorLoadoutSlot( LocalClientEHI(), entry, previewSkin )
}

void function FilterCharacterSkinList( array<ItemFlavor> characterSkinList )
{
	for ( int i = characterSkinList.len() - 1; i >= 0; i-- )
	{
		if ( !ShouldDisplayCharacterSkin( characterSkinList[i] ) )
			characterSkinList.remove( i )
	}
}

bool function ShouldDisplayCharacterSkin( ItemFlavor characterSkin )
{
	if ( CharacterSkin_ShouldHideIfLocked( characterSkin ) )
	{
		LoadoutEntry entry = Loadout_CharacterSkin( CharacterSkin_GetCharacterFlavor( characterSkin ) )
		if ( !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), entry, characterSkin ) )
			return false
	}

	if ( Mythics_IsItemFlavorMythicSkin( characterSkin ) )
	{
		if ( Mythics_GetSkinTierIntForSkin( characterSkin ) > 1 )
			return false
	}

	return true
}


void function LeftMythicSkinButton_OnActivate( var button )
{
	if( file.activeMythicSkinTier <= 0 )
		return

	file.activeMythicSkinTier--

	ItemFlavor character = GetTopLevelCustomizeContext()

	CharacterSkinsPanel_Update( file.panel )
	CustomizeButton_OnClick( file.mythicGridButton )
	Mythics_PreviewSkinForCharacter( character, file.activeMythicSkinTier )
	UpdateMythicSkinInfo()

}

void function RightMythicSkinButton_OnActivate( var button )
{
	if( file.activeMythicSkinTier >= 2 )
		return

	file.activeMythicSkinTier++

	ItemFlavor character = GetTopLevelCustomizeContext()

	CharacterSkinsPanel_Update( file.panel )
	CustomizeButton_OnClick( file.mythicGridButton )
	Mythics_PreviewSkinForCharacter( character, file.activeMythicSkinTier )
	UpdateMythicSkinInfo()

}

void function MythicTrackingButton_OnClick( var button )
{
	ItemFlavor challenge = Mythics_GetChallengeForCharacter( GetTopLevelCustomizeContext() )
	Mythics_ToggleTrackChallenge( challenge, file.mythicTrackingButton, true )
}

void function Mythics_PreviewSkinForCharacter( ItemFlavor character, int tier )
{
	ItemFlavor flav = expect ItemFlavor( Mythics_GetSkinTierForCharacter( character, tier ) )
	RunClientScript( "UIToClient_PreviewStoreItem", ItemFlavor_GetGUID( flav ) )
}

void function UpdateMythicTrackingButton()
{
	ItemFlavor character = GetTopLevelCustomizeContext()
	if ( !Mythics_CharacterHasMythic( character ) )
		return

	ItemFlavor challenge = Mythics_GetChallengeForCharacter( character )
	var rui = Hud_GetRui( file.mythicTrackingButton )
	bool isChallengeTracked = IsFavoriteChallenge( challenge )

	RuiSetString( rui, "buttonText", "#CHALLENGE" )
	RuiSetString( rui, "descText", isChallengeTracked ? "#CHALLENGE_TRACKED" : "#CHALLENGE_TRACK" )
	RuiSetString( rui, "bigText", isChallengeTracked ? "`1%$rui/hud/check_selected%" : "`1%$rui/borders/key_border%" )
}

void function FocusOnMythicSkinIfAnyTierEquiped()
{
	ItemFlavor equippedSkin = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_CharacterSkin( GetTopLevelCustomizeContext() ) )
	if( Mythics_IsItemFlavorMythicSkin( equippedSkin ) )
		CustomizeButton_OnClick( file.mythicGridButton )
}