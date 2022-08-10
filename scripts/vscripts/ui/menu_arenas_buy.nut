global function InitArenasBuyMenu

global function ClientToUI_Arenas_OpenBuyMenu
global function ClientToUI_Arenas_CloseBuyMenu
global function ClientToUI_Arenas_RefreshBuyMenu
global function ClientToUI_Arenas_UpdateAirdropPreview
global function ClientToUI_Arenas_SetRoundNumber
global function ClientToUI_Arenas_SetShowDeathRecapFooter

const int ROWS = 4
const int COLS = 5

struct
{
	var menu
	var buyInfo
	var airdropPreview
	var playerLoadout
	var squadMateLoadout0
	var squadMateLoadout1
	var abilityLabel
	var roundLabel
	var leftFrame
	var rightFrame

	int tabIndex = 0
	bool playIntroTransition = false
	bool isMouseMiddleRegistered = false
	bool showDeathRecapFooter = false

	array<var> weaponTabButtons
	array<var> weaponButtons
	array<var> buyButtons
	array<var> equipmentIcons
} file

void function InitArenasBuyMenu( var newMenuArg )                                               
{
	var menu = newMenuArg
	file.menu = menu

	#if !NX_PROG
		                                                            
		                                                                                                             
		                                                                                                             
		                                                                                                             
		SetMenuReceivesCommands( file.menu, true )
		Hud_SetCommandHandler( file.menu, OnCommandEvent )
	#endif

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnArenasBuyMenu_Open )
	                                                                                   
	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnArenasBuyMenu_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, OnArenasBuyMenu_Hide )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnArenasBuyMenu_Close )

	file.buyInfo 			= Hud_GetChild( file.menu, "ArenasTotalMaterials" )
	file.airdropPreview		= Hud_GetChild( file.menu, "AirdropPreview" )
	file.abilityLabel		= Hud_GetChild( file.menu, "Ability_Label" )
	file.roundLabel			= Hud_GetChild( file.menu, "Round_Label" )
	file.playerLoadout		= Hud_GetChild( file.menu, "Player_Loadout" )
	file.leftFrame 			= Hud_GetChild( file.menu, "LeftFrame" )
	file.rightFrame			= Hud_GetChild( file.menu, "RightFrame" )
	file.squadMateLoadout0	= Hud_GetChild( file.menu, "SquadMate_Loadout_0" )
	file.squadMateLoadout1	= Hud_GetChild( file.menu, "SquadMate_Loadout_1" )

	#if !NX_PROG
		Hud_SetCommandHandler( file.airdropPreview, OnAirdropPreviewCommand )
	#endif

	file.weaponTabButtons = GetElementsByClassname( file.menu, "ArenasWeaponTab" )
	foreach ( button in file.weaponTabButtons )
		AddButtonEventHandler( button, UIE_CLICK, OnWeaponTabClick )

	file.weaponButtons = GetElementsByClassname( file.menu, "ArenasWeaponButton" )
	foreach ( button in file.weaponButtons )
	{
		AddButtonEventHandler( button, UIE_CLICK, OnBuyButtonClick )
		AddButtonEventHandler( button, UIE_CLICKRIGHT, OnBuyButtonRightClick )
		                                                                          
	}

	file.buyButtons = GetElementsByClassname( file.menu, "ArenasBuyButton" )
	foreach ( button in file.buyButtons )
	{
		AddButtonEventHandler( button, UIE_CLICK, OnBuyButtonClick )
		AddButtonEventHandler( button, UIE_CLICKRIGHT, OnBuyButtonRightClick )
	}

	file.equipmentIcons = GetElementsByClassname( file.menu, "ArenasEquipment" )

	SetAllowControllerFooterClick( menu, true )
	UpdateBuyMenuFooterOptions()

	AddMenuVarChangeHandler( "isGamepadActive", UpdateTabPrompts )
	UpdateTabPrompts()
}

void function UpdateBuyMenuFooterOptions( )
{
	ClearMenuFooterOptions( file.menu )

	AddMenuFooterOption( file.menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#CLOSE" )
	AddMenuFooterOption( file.menu, LEFT, KEY_TAB, false, "", "", OnArenasClosePressed )
	AddMenuFooterOption( file.menu, LEFT, BUTTON_Y, false, "", "", OnButtonYPress )
	AddMenuFooterOption( file.menu, LEFT, BUTTON_SHOULDER_LEFT, true, "", "", OnPreviousTab )
	AddMenuFooterOption( file.menu, LEFT, BUTTON_SHOULDER_RIGHT, true, "", "", OnNextTab )

	if( file.showDeathRecapFooter )
		AddMenuFooterOption( file.menu, LEFT, KEY_SPACE, true, "#DEATH_RECAP_HEADER", "#DEATH_RECAP_HEADER", OnShowDeathRecap )

#if PC_PROG
	AddMenuFooterOption( file.menu, RIGHT, KEY_ENTER, true, "", "", UI_OnLoadoutButton_Enter )
#endif
}

void function ClientToUI_Arenas_OpenBuyMenu( bool playIntroTransition )
{
	file.playIntroTransition = playIntroTransition
	CloseAllMenus()
	AdvanceMenu( file.menu )
}

void function OnArenasBuyMenu_Open()
{
	RunClientScript( "UIToClient_ArenasBuyMenuOpen" )

	if( file.playIntroTransition )
		thread _PlayIntroTransition()
}

void function OnArenasBuyMenu_Show()
{
	ClientToUI_Arenas_RefreshBuyMenu()
	RunClientScript( "UIToClient_ArenasBuyMenuShow" )

	if( !file.isMouseMiddleRegistered )
	{
		RegisterButtonPressedCallback( MOUSE_MIDDLE, OnButtonYPress )
		file.isMouseMiddleRegistered = true
	}
	else
	{
		Warning( "OnArenasBuyMenu_Show - MOUSE_MIDDLE callback already registered" )
	}
}

void function OnArenasBuyMenu_Hide()
{
	RunClientScript( "UIToClient_ArenasBuyMenuHide" )

	if( file.isMouseMiddleRegistered )
	{
		DeregisterButtonPressedCallback( MOUSE_MIDDLE, OnButtonYPress )
		file.isMouseMiddleRegistered = false
	}
	else
	{
		Warning( "OnArenasBuyMenu_Hide - MOUSE_MIDDLE callback not registered" )
	}
}

void function OnArenasBuyMenu_Close()
{
	RunClientScript( "UIToClient_ArenasBuyMenuClose" )
	file.playIntroTransition = false
}

void function OnArenasBuyMenu_NavBack()
{
}

void function OnArenasClosePressed( var button )
{
	ClientToUI_Arenas_CloseBuyMenu()
}

void function OnCommandEvent( var element, string binding )
{
	if ( binding == "+use" )
	{
		ClientToUI_Arenas_CloseBuyMenu()
	}
}

void function OnAirdropPreviewCommand( var element, string binding )
{
	if ( IsLobby() )
		return

	if ( binding == "+ping" )
	{
		if ( IsFullyConnected() )
			RunClientScript( "UICallback_Arenas_PingAirdropPreview", element )
	}
}

void function ClientToUI_Arenas_CloseBuyMenu()
{
	if ( MenuStack_Contains( file.menu ) )
	{
		CloseAllMenus()
	}
}

void function ClientToUI_Arenas_RefreshBuyMenu()
{
	if ( GetActiveMenu() != file.menu )
		return

	if ( !IsFullyConnected() )
		return

	if ( IsLobby() )
		return

	Arenas_UpdateCash( file.buyInfo )

	foreach ( button in file.weaponTabButtons )
	{
		RunClientScript( "UICallback_Arenas_BindWeaponTab", button )
	}

	foreach ( button in file.weaponButtons )
	{
		RunClientScript( "UICallback_Arenas_BindWeaponButton", button )
	}

	foreach ( button in file.buyButtons )
	{
		RunClientScript( "UICallback_Arenas_BindBuyButton", button )
	}

	foreach ( equipment in file.equipmentIcons )
	{
		RunClientScript( "UICallback_Arenas_BindEquipment", equipment )
	}

	ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( GetLocalClientPlayer() ), Loadout_Character() )
	RuiSetString( Hud_GetRui( file.abilityLabel ), "labelText", Localize( "#ARENAS_SHOP_LEGEND_ABILITIES", Localize( ItemFlavor_GetLongName( character ) ).toupper() ) )
	RuiSetImage( Hud_GetRui( file.leftFrame ), "basicImage", $"rui/arenas/arenas_store_purchase_frame_l" )
	RuiSetImage( Hud_GetRui( file.rightFrame ), "basicImage", $"rui/arenas/arenas_store_purchase_frame_r" )
	RuiSetBool( Hud_GetRui( Hud_GetChild( file.menu, "NarratorImage" ) ), "isVisible", false )

	Arenas_UpdateMenuInfo( file.playerLoadout, file.squadMateLoadout0, file.squadMateLoadout1 )

	ForceVGUIFocusUpdate()
}

void function ClientToUI_Arenas_SetShowDeathRecapFooter( bool showDeathRecap )
{
	file.showDeathRecapFooter = showDeathRecap
	UpdateBuyMenuFooterOptions()
}

void function OnWeaponTabClick( var button )
{
	if ( GetActiveMenu() != file.menu )
		return

	if ( !IsFullyConnected() )
		return

	if ( IsLobby() )
		return

	file.tabIndex = file.weaponTabButtons.find( button )
	RunClientScript( "UICallback_Arenas_OnWeaponTabClick", button )
}

void function OnBuyButtonClick( var button )
{
	if ( GetActiveMenu() != file.menu )
		return

	if ( !IsFullyConnected() )
		return

	if ( IsLobby() )
		return

	RunClientScript( "UICallback_Arenas_OnBuyButtonClick", button )
}

void function OnBuyButtonRightClick( var button )
{
	if ( GetActiveMenu() != file.menu )
		return

	if ( !IsFullyConnected() )
		return

	if ( IsLobby() )
		return

	RunClientScript( "UICallback_Arenas_OnBuyButtonRightClick", button )
}

void function OnBuyButtonMiddleClick( var button )
{
	if ( GetActiveMenu() != file.menu )
		return

	if ( !IsFullyConnected() )
		return

	if ( IsLobby() )
		return

	RunClientScript( "UICallback_Arenas_OnBuyButtonMiddleClick", button )
}

void function OnButtonYPress( var menu )
{
	var focusButton = GetFocus()
	if( file.weaponButtons.contains( focusButton ) )
		OnBuyButtonMiddleClick( focusButton )
}

void function OnPreviousTab( var menu )
{
	int attempts = file.weaponTabButtons.len()
	while( attempts > 0 )
	{
		attempts -= 1
		file.tabIndex -= 1

		if( file.tabIndex < 0 )
			file.tabIndex = file.weaponTabButtons.len() - 1

		if( Hud_IsVisible( file.weaponTabButtons[ file.tabIndex ] ) )
		{
			RunClientScript( "UICallback_Arenas_OnWeaponTabClick", file.weaponTabButtons[ file.tabIndex ]  )
			break
		}
	}
}

void function OnNextTab( var menu )
{
	int attempts = file.weaponTabButtons.len()
	while( attempts > 0 )
	{
		attempts -= 1
		file.tabIndex = (file.tabIndex + 1) % file.weaponTabButtons.len()

		if( Hud_IsVisible( file.weaponTabButtons[ file.tabIndex ] ) )
		{
			RunClientScript( "UICallback_Arenas_OnWeaponTabClick", file.weaponTabButtons[ file.tabIndex ]  )
			break
		}
	}
}

void function OnShowDeathRecap( var menu )
{
	RunClientScript( "UICallback_Arenas_OnShowDeathRecap" )
}

void function UpdateTabPrompts( )
{
	var leftPrompt = Hud_GetChild( file.menu, "TabLeftPrompt" )
	var rightPrompt = Hud_GetChild( file.menu, "TabRightPrompt" )

	if( GetMenuVarBool( "isGamepadActive" ) )
	{
		RuiSetString( Hud_GetRui( leftPrompt ), "labelText", "#ARENAS_PREV_TAB" )
		RuiSetString( Hud_GetRui( rightPrompt ), "labelText", "#ARENAS_NEXT_TAB" )

		#if NX_PROG || PC_PROG_NX_UI
			if ( IsNxHandheldMode() )
			{
				RuiSetFloat( Hud_GetRui( leftPrompt ), "textHeight", 50.0 )
				RuiSetFloat( Hud_GetRui( rightPrompt ), "textHeight", 50.0 )
			}
		#endif
	}
	else
	{
		RuiSetString( Hud_GetRui( leftPrompt ), "labelText", "" )
		RuiSetString( Hud_GetRui( rightPrompt ), "labelText", "" )
	}
}

void function _PlayIntroTransition( )
{
	float startTime = UITime()
	const float transitionTime = 0.5
	const float startYOffset = -1000

	var shopAnchor = Hud_GetChild( file.menu, "Shop_Anchor" )
	array<var> fadeRuis = GetElementsByClassname( file.menu, "FadeInOnTransition" )

	Hud_SetY( shopAnchor, startYOffset )
	Hud_ReturnToBasePosOverTime( shopAnchor, transitionTime, INTERPOLATOR_DEACCEL )

	float elapsedTime = UITime() - startTime
	while( elapsedTime < transitionTime  )
	{
		float alpha = elapsedTime / transitionTime
		alpha = alpha * alpha * alpha                                                   

		foreach( fadeRui in fadeRuis )
			RuiSetFloat( Hud_GetRui( fadeRui ), "baseAlpha", alpha )

		WaitFrame()
		elapsedTime = UITime() - startTime
	}

	foreach( fadeRui in fadeRuis )
		RuiSetFloat( Hud_GetRui( fadeRui ), "baseAlpha", 1.0 )
}

void function Arenas_UpdateMenuInfo( var playerRui, var squadmateRui0, var squadmateRui1 )
{
	RunClientScript( "UICallback_Arenas_UpdateMenuInfo", playerRui, squadmateRui0, squadmateRui1 )
}

void function Arenas_UpdateCash( var rui )
{
	RunClientScript( "UICallback_Arenas_UpdateCash", rui )
}

void function ClientToUI_Arenas_SetRoundNumber( int roundNum )
{
	RuiSetString( Hud_GetRui( file.roundLabel ), "labelText", Localize( "#ARENAS_ROUND_NUM", roundNum ) )
}

void function ClientToUI_Arenas_UpdateAirdropPreview( int contentsID0, int contentsID1, int contentsID2 )
{
	var rui = Hud_GetRui( file.airdropPreview )
	array<int> contentIDs = [ contentsID0, contentsID1, contentsID2 ]
	for( int i = 0; i < contentIDs.len(); ++i )
	{
		if ( SURVIVAL_Loot_IsLootIndexValid( contentIDs[i] ) )
		{
			LootData data = SURVIVAL_Loot_GetLootDataByIndex( contentIDs[i] )
			RuiSetString( rui, "contentsName" + i, data.pickupString )
			RuiSetImage( rui, "contentsImage" + i, data.hudIcon)
			RuiSetInt( rui, "contentsTier" + i, data.tier )
		}
	}
}

void function UI_OnLoadoutButton_Enter( var button )
{
	var chatbox = Hud_GetChild( file.menu, "LobbyChatBox" )

	if ( !HudChat_HasAnyMessageModeStoppedRecently() )
		Hud_StartMessageMode( chatbox )

	Hud_SetVisible( chatbox, true )
}