global function InitCustomMatchMapSelectPanel

struct
{
	var menuGrid
	CustomMatchPlaylist& playlist
} file

void function InitCustomMatchMapSelectPanel( var panel )
{
	file.menuGrid = Hud_GetChild( panel, "SelectMapGrid" )

	AddCallback_OnCustomMatchGameModeChanged( Callback_OnCustomGameModeChanged )
	AddCallback_OnCustomMatchSettingChanged( CUSTOM_MATCH_SETTING_PLAYLIST, Callback_OnPlaylistChanged )
}

void function Callback_OnCustomGameModeChanged( CustomMatchCategory category )
{
	Hud_InitGridButtons( file.menuGrid, category.maps.len() )
	foreach ( int i, CustomMatchMap map in category.maps )
	{
		var button = Hud_GetButton( file.menuGrid, i )

		HudElem_SetRuiArg( button, "modeNameText", map.displayName )
		HudElem_SetRuiArg( button, "modeImage", map.displayImage, eRuiArgType.IMAGE )

		Hud_ClearEventHandlers( button, UIE_CLICK )
		Hud_AddEventHandler( button, UIE_CLICK, void function( var button ) : ( map ) {
			MenuButton_OnClick( button, map )
		} )
	}

	if ( !CategoryContainsPlaylist( category, file.playlist ) )
		SelectPlaylist( GetPlaylist( category.maps[ 0 ], GetPlaylistVariantName( file.playlist ) ) )
}

void function Callback_OnPlaylistChanged( string setting, string value )
{
	SelectPlaylist( expect CustomMatchPlaylist( CustomMatch_GetPlaylist( value ) ) )
}

void function MenuButton_OnClick( var button, CustomMatchMap map )
{
	if ( !MapContainsPlaylist( map, file.playlist ) )
		SelectPlaylist( GetPlaylist( map, GetPlaylistVariantName( file.playlist ) ) )
}

void function SelectPlaylist( CustomMatchPlaylist playlist )
{
	file.playlist = playlist

	CustomMatchCategory category = expect CustomMatchCategory( CustomMatch_GetCategory( playlist.categoryIndex ) )
	CustomMatch_SetGameMode( category )

	int buttonCount = Hud_GetButtonCount( file.menuGrid )
	foreach ( int i, CustomMatchMap entry in category.maps )
	{
		if ( i >= buttonCount )
			continue

		var button = Hud_GetButton( file.menuGrid, i )
		Hud_SetChecked( button, MapContainsPlaylist( entry, playlist ) )
	}

	CustomMatch_SetSetting( CUSTOM_MATCH_SETTING_PLAYLIST, playlist.playlistName )
}

bool function MapContainsPlaylist( CustomMatchMap map, CustomMatchPlaylist playlist )
{
	foreach ( CustomMatchPlaylist entry in map.playlists )
		if ( entry.playlistIndex == playlist.playlistIndex )
			return true
	return false
}

bool function CategoryContainsPlaylist( CustomMatchCategory category, CustomMatchPlaylist playlist )
{
	foreach ( CustomMatchMap entry in category.maps )
		if ( MapContainsPlaylist( entry, playlist ) )
			return true
	return false
}

string function GetPlaylistVariantName( CustomMatchPlaylist playlist )
{
	CustomMatchMap map = expect CustomMatchMap( CustomMatch_GetMap( playlist.mapIndex ) )
	foreach ( string key, CustomMatchPlaylist value in map.playlists )
	{
		if ( value.playlistIndex == playlist.playlistIndex )
			return key
	}
	return CUSTOM_MATCH_MODE_VARIANT_DEFAULT
}

CustomMatchPlaylist function GetPlaylist( CustomMatchMap map, string variant )
{
	return map.playlists[ ( variant in map.playlists ) ? variant : CUSTOM_MATCH_MODE_VARIANT_DEFAULT ]
}