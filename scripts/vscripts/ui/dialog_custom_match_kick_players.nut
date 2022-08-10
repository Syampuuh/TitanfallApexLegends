global function InitCustomMatchKickPlayersDialog
global function CustomMatch_ShowKickDialog

const int MIN_PLAYER_COUNT = 3

                                                             
                                                                                             
struct KickEntry
{
	string uid
	string hardware
}

struct
{
	var kickPlayersMenu
	var kickPlayersList
	InputDef& confirmDef

	array<KickEntry> kickEntries
	int selectionMask
} file

void function InitCustomMatchKickPlayersDialog( var menu )
{
	file.kickPlayersMenu = menu
	file.kickPlayersList = Hud_GetChild( menu, "PlayersList" )

	SetDialog( menu, true )

	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, KickPlayersDialog_OnNavigateBack )

	file.confirmDef = AddMenuFooterOption( menu, LEFT, BUTTON_Y, true, "", "", KickPlayersDialog_Confirm )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CANCEL", "#CANCEL", KickPlayersDialog_Cancel )
}

void function CustomMatch_ShowKickDialog( array<CustomMatch_LobbyPlayer> players, bool autoCheck = false )
{
	file.selectionMask = 0
	file.kickEntries.clear()

	Hud_InitGridButtons( file.kickPlayersList, int( max( players.len(), MIN_PLAYER_COUNT ) ) )
	foreach ( int i, CustomMatch_LobbyPlayer player in players )
	{
		var button = Hud_GetButton( file.kickPlayersList, i )
		ConfigurePlayerButton( button, i, player, autoCheck )
		AddKickEntry( player )
	}

	for ( int i = players.len(); i < MIN_PLAYER_COUNT; ++i )
	{
		var button = Hud_GetButton( file.kickPlayersList, i )
		ClearPlayerButton( button )
	}

	ConfigureConfirmButton()
	AdvanceMenu( file.kickPlayersMenu )
}

void function KickPlayersDialog_OnNavigateBack()
{
	CloseActiveMenu()
}

void function KickPlayersDialog_Confirm( var _ )
{
	if ( !AnySelected() )
		return

	foreach ( int i, KickEntry entry in file.kickEntries )
		if( IsSelected( i ) )
			CustomMatch_KickPlayer( entry.hardware, entry.uid )
	CloseActiveMenu()
}

void function KickPlayersDialog_Cancel( var _ )
{
	CloseActiveMenu()
}

void function KickPlayer_OnClick( var button, int index )
{
	ToggleSelected( index )
	Hud_SetChecked( button, IsSelected( index ) )
	ConfigureConfirmButton()
}

bool function IsSelected( int index )
{
	return ( file.selectionMask & ( 1 << index ) ) != 0
}

void function ToggleSelected( int index )
{
	if( IsSelected( index ) )
		file.selectionMask = file.selectionMask & ~( 1 << index )
	else
		file.selectionMask = file.selectionMask | ( 1 << index )
}

int function CountSelected()
{
	int count = 0
	int bitmask = file.selectionMask
	while ( bitmask )
	{
		count += bitmask & 1
		bitmask = bitmask >> 1
	}
	return count
}

bool function AnySelected()
{
	return file.selectionMask != 0
}

void function ConfigurePlayerButton( var button, int index, CustomMatch_LobbyPlayer player, bool autoCheck )
{
	bool isSelf = player.uid == GetPlayerUID()
	string platformString = PlatformIDToIconString( GetHardwareFromName( player.hardware ) )

	HudElem_SetRuiArg( button, "buttonText", player.name )
	HudElem_SetRuiArg( button, "platformString", platformString )
	HudElem_SetRuiArg( button, "isSelf", isSelf )
	HudElem_SetRuiArg( button, "isAdmin", player.isAdmin )

	Hud_ClearEventHandlers( button, UIE_CLICK )
	Hud_AddEventHandler( button, UIE_CLICK, void function ( var button ) : ( index ) { KickPlayer_OnClick( button, index ) } )

	Hud_SetEnabled( button, !isSelf )
	Hud_SetChecked( button, !isSelf && autoCheck )
	Hud_SetNew( button, false )

	if ( !isSelf && autoCheck )
		file.selectionMask = file.selectionMask | ( 1 << index )
}

void function ClearPlayerButton( var button )
{
	HudElem_SetRuiArg( button, "buttonText", "" )
	HudElem_SetRuiArg( button, "platformString", "" )
	HudElem_SetRuiArg( button, "isSelf", false )
	HudElem_SetRuiArg( button, "isAdmin", false )

	Hud_ClearEventHandlers( button, UIE_CLICK )

	Hud_SetEnabled( button, false )
	Hud_SetChecked( button, false )
	Hud_SetNew( button, false )
}

void function ConfigureConfirmButton()
{
	int selectedCount = CountSelected()
	file.confirmDef.mouseLabel = selectedCount == 1 ? "#KICK_PLAYER" : Localize( "#KICK_N_PLAYERS", selectedCount )
	file.confirmDef.gamepadLabel = selectedCount == 1 ? "#Y_BUTTON_KICK_PLAYER" : Localize( "#Y_BUTTON_KICK_N_PLAYERS", selectedCount )
	file.confirmDef.clickable = AnySelected()
	UpdateFooterOptions()
}

void function AddKickEntry( CustomMatch_LobbyPlayer player )
{
	KickEntry entry
	entry.uid = player.uid
	entry.hardware = player.hardware
	file.kickEntries.append( entry )
}