global function InitCustomMatchModeSelectPanel

struct
{
	var menuGrid
} file

void function InitCustomMatchModeSelectPanel( var panel )
{
	file.menuGrid = Hud_GetChild( panel, "SelectModeGrid" )

	AddCallback_OnCustomMatchPlaylistsUpdated( Callback_OnPlaylistsUpdated )
	AddCallback_OnCustomMatchGameModeChanged( Callback_OnCustomGameModeChanged )
}

void function Callback_OnPlaylistsUpdated( array<CustomMatchCategory> categories )
{
	Hud_InitGridButtons( file.menuGrid, categories.len() )
	foreach ( int i, CustomMatchCategory category in categories )
	{
		var button = Hud_GetButton( file.menuGrid, i )

		HudElem_SetRuiArg( button, "modeNameText", category.displayName )
		HudElem_SetRuiArg( button, "modeImage", category.displayImage, eRuiArgType.IMAGE )

		Hud_ClearEventHandlers( button, UIE_CLICK )
		Hud_AddEventHandler( button, UIE_CLICK, void function( var button ) : ( category ) {
			MenuButton_OnClick( button, category )
		} )
	}
}

void function Callback_OnCustomGameModeChanged( CustomMatchCategory category )
{
	int categoryIndex = category.maps[ 0 ].playlists[ CUSTOM_MATCH_MODE_VARIANT_DEFAULT ].categoryIndex
	int buttonCount = Hud_GetButtonCount( file.menuGrid )
	for ( int i = 0; i < buttonCount; ++i )
	{
		var button = Hud_GetButton( file.menuGrid, i )
		Hud_SetChecked( button, i == categoryIndex )
	}
}

void function MenuButton_OnClick( var button, CustomMatchCategory category )
{
	CustomMatch_SetGameMode( category )
}