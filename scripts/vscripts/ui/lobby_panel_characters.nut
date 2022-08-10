global function InitCharactersPanel

global function JumpToCharactersTab
global function JumpToCharacterCustomize

struct
{
	var                    panel
	var                    characterSelectInfoRui
	array<var>             buttons
	table<var, ItemFlavor> buttonToCharacter
	ItemFlavor ornull	   presentedCharacter
} file

void function InitCharactersPanel( var panel )
{
	file.panel = panel
	file.characterSelectInfoRui = Hud_GetRui( Hud_GetChild( file.panel, "CharacterSelectInfo" ) )
	file.buttons = GetPanelElementsByClassname( panel, "CharacterButtonClass" )

	SetPanelTabTitle( panel, "#LEGENDS" )
	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, CharactersPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, CharactersPanel_OnHide )
	AddPanelEventHandler_FocusChanged( panel, CharactersPanel_OnFocusChanged )

	foreach ( button in file.buttons )
	{
		Hud_AddEventHandler( button, UIE_CLICK, CharacterButton_OnActivate )
		Hud_AddEventHandler( button, UIE_CLICKRIGHT, CharacterButton_OnRightClick )
		Hud_AddEventHandler( button, UIE_MIDDLECLICK, CharacterButton_OnMiddleClick )

	}

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_Y, true, "#BUTTON_MARK_ALL_AS_SEEN_GAMEPAD", "#BUTTON_MARK_ALL_AS_SEEN_MOUSE", MarkAllCharacterItemsAsViewed, CharacterButtonNotFocused )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_SELECT", "", null, IsCharacterButtonFocused )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_TOGGLE_LOADOUT", "#X_BUTTON_TOGGLE_LOADOUT", OpenFocusedCharacterSkillsDialog, IsCharacterButtonFocused )
	AddPanelFooterOption( panel, RIGHT, BUTTON_Y, false, "#Y_BUTTON_UNLOCK", "#Y_BUTTON_UNLOCK", OpenPurchaseCharacterDialogFromFocus, IsReadyAndFocusedCharacterLocked )
	AddPanelFooterOption( panel, RIGHT, BUTTON_Y, false, "#Y_BUTTON_SET_FEATURED", "#Y_BUTTON_SET_FEATURED", SetFeaturedCharacterFromFocus, IsReadyAndNonfeaturedCharacterButtonFocused )
}


bool function IsReadyAndFocusedCharacterLocked()
{
	if ( !GRX_IsInventoryReady() )
		return false

	var focus = GetFocus()

	if ( focus in file.buttonToCharacter )
		return !Character_IsCharacterOwnedByPlayer( file.buttonToCharacter[focus] )

	return false
}


bool function IsReadyAndNonfeaturedCharacterButtonFocused()
{
	if ( !GRX_IsInventoryReady() )
		return false

	var focus = GetFocus()

	if ( focus in file.buttonToCharacter )
		return file.buttonToCharacter[focus] != LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_Character() )

	return false
}

bool function CharacterButtonNotFocused()
{
	return !IsCharacterButtonFocused()
}


bool function IsCharacterButtonFocused()
{
	if ( file.buttons.contains( GetFocus() ) )
		return true

	return false
}


void function SetFeaturedCharacter( ItemFlavor character )
{
	if ( !Character_IsCharacterOwnedByPlayer( character ) )
		return

	foreach ( button in file.buttons )
	{
		if ( button in file.buttonToCharacter )
			Hud_SetSelected( button, file.buttonToCharacter[button] == character )
	}

	Newness_IfNecessaryMarkItemFlavorAsNoLongerNewAndInformServer( character )
	RequestSetItemFlavorLoadoutSlot( LocalClientEHI(), Loadout_Character(), character )

	EmitUISound( "UI_Menu_Legend_SetFeatured" )
}

void function MarkAllCharacterItemsAsViewed( var button )
{
	if ( MarkAllItemsOfTypeAsViewed( eItemTypeUICategory.CHARACTER ) )
		EmitUISound( "UI_Menu_Accept" )
	else
		EmitUISound( "UI_Menu_Deny" )
}

void function OpenPurchaseCharacterDialogFromFocus( var button )
{
	if ( IsSocialPopupActive() )
		return

	var focus = GetFocus()

	OpenPurchaseCharacterDialogFromButton( focus )
}

void function OpenPurchaseCharacterDialogFromButton( var button )
{
	if ( button in file.buttonToCharacter )
	{
		PurchaseDialogConfig pdc
		pdc.flav = file.buttonToCharacter[button]
		pdc.quantity = 1
		PurchaseDialog( pdc )
	}

	EmitUISound( "menu_accept" )

}

void function SetFeaturedCharacterFromButton( var button )
{
	if ( button in file.buttonToCharacter )
		SetFeaturedCharacter( file.buttonToCharacter[button] )
}

void function SetFeaturedCharacterFromFocus( var button )
{
	if ( IsSocialPopupActive() )
		return

	var focus = GetFocus()

	SetFeaturedCharacterFromButton( focus )
}


void function OpenFocusedCharacterSkillsDialog( var button )
{
	var focus = GetFocus()

	if ( file.buttons.contains( focus ) )
		OpenCharacterSkillsDialog( file.buttonToCharacter[focus] )
}

void function InitCharacterButtons()
{
	file.buttonToCharacter.clear()

	foreach ( button in file.buttons )
		Hud_SetVisible( button, false )

	array<ItemFlavor> characters
	foreach ( ItemFlavor itemFlav in GetAllCharacters() )
	{
		bool isAvailable = IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_Character(), itemFlav )
		if ( !isAvailable )
		{
			if ( !ItemFlavor_ShouldBeVisible( itemFlav, GetLocalClientPlayer() ) )
				continue
		}

		characters.append( itemFlav )
	}

	array<ItemFlavor> orderedCharacters = GetCharacterButtonOrder( characters, file.buttons.len() )
	array<var> characterButtons

	foreach ( index, character in orderedCharacters )
	{
		var button = file.buttons[index]
		CharacterButton_Init( button, character )
		characterButtons.append( button )
	}

	array< array<var> > buttonRows = GetCharacterButtonRows( characterButtons )
	LayoutCharacterButtons( buttonRows )
}


void function CharacterButton_Init( var button, ItemFlavor character )
{
	file.buttonToCharacter[button] <- character

	                                                                                                   
	                                                    
	bool isLocked   = IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_Character(), character )
	bool isSelected = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_Character() ) == character

	Hud_SetVisible( button, true )
	                             
	Hud_SetLocked( button, !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_Character(), character ) )
	Hud_SetSelected( button, isSelected )

	RuiSetString( Hud_GetRui( button ), "buttonText", Localize( ItemFlavor_GetLongName( character ) ).toupper() )
	RuiSetImage( Hud_GetRui( button ), "buttonImage", CharacterClass_GetGalleryPortrait( character ) )
	RuiSetImage( Hud_GetRui( button ), "bgImage", CharacterClass_GetGalleryPortraitBackground( character ) )
	RuiSetImage( Hud_GetRui( button ), "roleImage", CharacterClass_GetCharacterRoleImage( character ) )
	                                                                                     

             
                                                                        
  
                             
                                                                                                      
                                                                                                   
                                                                                                     
                                                                                                        
                                                                                                   
                                                                                                         

                                         
                        
   
                                                                  
   
  
      

	Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.CharacterButton[character], OnNewnessQueryChangedUpdateButton, button )
}


void function CharactersPanel_OnShow( var panel )
{
	UI_SetPresentationType( ePresentationType.CHARACTER_SELECT )

	ItemFlavor character = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_Character() )
	SetTopLevelCustomizeContext( character )
#if NX_PROG || PC_PROG_NX_UI
	file.presentedCharacter = null
#endif
	PresentCharacter( character )

	InitCharacterButtons()
}


void function CharactersPanel_OnHide( var panel )
{
	if ( NEWNESS_QUERIES.isValid )
		foreach ( var button, ItemFlavor character in file.buttonToCharacter )
			if ( character in NEWNESS_QUERIES.CharacterButton )                            
				Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.CharacterButton[character], OnNewnessQueryChangedUpdateButton, button )

	SetTopLevelCustomizeContext( null )
	RunMenuClientFunction( "ClearAllCharacterPreview" )

	file.buttonToCharacter.clear()
}


void function CharactersPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) )                  
		return

	if ( !newFocus || GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()

	ItemFlavor character
	if ( file.buttons.contains( newFocus ) )
		character = file.buttonToCharacter[newFocus]
	else
		character = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_Character() )

	printt( ItemFlavor_GetHumanReadableRef( character ) )
	PresentCharacter( character )
}


void function CharacterButton_OnActivate( var button )
{
	ItemFlavor character = file.buttonToCharacter[button]
	SetTopLevelCustomizeContext( character )
	CustomizeCharacterMenu_SetCharacter( character )
	if ( Character_IsCharacterOwnedByPlayer( character ) )
		RequestSetItemFlavorLoadoutSlot( LocalClientEHI(), Loadout_Character(), character )                                                                                                                                                                                            
	Newness_IfNecessaryMarkItemFlavorAsNoLongerNewAndInformServer( character )
	EmitUISound( "UI_Menu_Legend_Select" )
	AdvanceMenu( GetMenu( "CustomizeCharacterMenu" ) )
}


void function CharacterButton_OnRightClick( var button )
{
	if ( IsSocialPopupActive() && IsControllerModeActive() )
		return

	OpenCharacterSkillsDialog( file.buttonToCharacter[button] )
}


void function CharacterButton_OnMiddleClick( var button )
{
	if ( Hud_IsLocked( button ) )
		OpenPurchaseCharacterDialogFromButton( button )
	else
		SetFeaturedCharacterFromButton( button )
}


void function PresentCharacter( ItemFlavor character )
{
	if ( file.presentedCharacter == character )
		return

	RuiSetString( file.characterSelectInfoRui, "nameText", Localize( ItemFlavor_GetLongName( character ) ).toupper() )
	RuiSetString( file.characterSelectInfoRui, "subtitleText", Localize( ItemFlavor_GetShortDescription( character ) ) )
	RuiSetGameTime( file.characterSelectInfoRui, "initTime", ClientTime() )

	ItemFlavor characterSkin = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_CharacterSkin( character ) )
	RunClientScript( "UIToClient_PreviewCharacterSkin", ItemFlavor_GetNetworkIndex( characterSkin ), ItemFlavor_GetNetworkIndex( character ) )

	file.presentedCharacter = character
}

void function JumpToCharactersTab()
{
	while ( GetActiveMenu() != GetMenu( "LobbyMenu" ) )
		CloseActiveMenu()

	TabData lobbyTabData = GetTabDataForPanel( GetMenu( "LobbyMenu" ) )
	ActivateTab( lobbyTabData, Tab_GetTabIndexByBodyName( lobbyTabData, "CharactersPanel" ) )
}

void function JumpToCharacterCustomize( ItemFlavor character )
{
	JumpToCharactersTab()

	SetTopLevelCustomizeContext( character )
	CustomizeCharacterMenu_SetCharacter( character )
	if ( Character_IsCharacterOwnedByPlayer( character ) )
		RequestSetItemFlavorLoadoutSlot( LocalClientEHI(), Loadout_Character(), character )                                                                                                                                                                                            
	Newness_IfNecessaryMarkItemFlavorAsNoLongerNewAndInformServer( character )
	EmitUISound( "UI_Menu_Legend_Select" )
	AdvanceMenu( GetMenu( "CustomizeCharacterMenu" ) )
}