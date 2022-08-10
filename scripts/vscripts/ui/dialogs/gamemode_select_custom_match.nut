global function CustomMatch_RefreshPlaylists
global function CustomMatch_SetGameMode
global function CustomMatch_SetSetting
global function CustomMatch_GetSetting
global function CustomMatch_HasSetting
global function CustomMatch_SubmitSettings
global function CustomMatch_RestoreSettings
global function CustomMatch_GetCategory
global function CustomMatch_GetMap
global function CustomMatch_GetPlaylist
global function CustomMatch_IsLocalAdmin
global function CustomMatch_GetLocalPlayerData
global function CustomMatch_GetTeam
global function CustomMatch_LockLocalSettings

global function AddCallback_OnCustomMatchPlaylistsUpdated
global function RemoveCallback_OnCustomMatchPlaylistsUpdated
global function AddCallback_OnCustomMatchGameModeChanged
global function RemoveCallback_OnCustomMatchGameModeChanged
global function AddCallback_OnCustomMatchSettingChanged
global function RemoveCallback_OnCustomMatchSettingChanged
global function AddCallback_OnCustomMatchPlayerDataChanged
global function RemoveCallback_OnCustomMatchPlayerDataChanged
global function AddCallback_OnCustomMatchLobbyDataChanged
global function RemoveCallback_OnCustomMatchLobbyDataChanged
global function AddCallback_OnCustomMatchStatsPushed
global function RemoveCallback_OnCustomMatchStatsPushed

global function CustomMatch_DataChanged
global function CustomMatch_PushMatchStats

global const string CUSTOM_MATCH_SETTING_PLAYLIST 			= "playlist"
global const string CUSTOM_MATCH_SETTING_LOBBY_NAME 		= "lobbyName"
global const string CUSTOM_MATCH_SETTING_CHAT_PERMISSION 	= "chatPermission"
global const string CUSTOM_MATCH_SETTING_RENAME_TEAM 		= "renameTeam"
global const string CUSTOM_MATCH_SETTING_SELF_ASSIGN 		= "selfAssign"
global const string CUSTOM_MATCH_SETTING_AIM_ASSIST 		= "aimAssist"
global const string CUSTOM_MATCH_SETTING_ANONYMOUS_MODE 	= "anonymousMode"
global const string CUSTOM_MATCH_SETTING_MATCH_STATUS 		= "matchStatus"

global const string CUSTOM_MATCH_CHAT_PERMISSION_ALL		= "0"
global const string CUSTOM_MATCH_CHAT_PERMISSION_ADMIN_ONLY = "1"

global const string CUSTOM_MATCH_STATUS_PREPARING			= "0"
global const string CUSTOM_MATCH_STATUS_MATCHMAKING			= "1"
global const string CUSTOM_MATCH_STATUS_GAME_FOUND			= "2"

global const int CUSTOM_MATCH_PLAYER_BIT_IS_READY			= ( 1 << 0 )
global const int CUSTOM_MATCH_PLAYER_BIT_IS_PRELOADING		= ( 1 << 1 )
global const int CUSTOM_MATCH_PLAYER_BIT_IS_MATCHMAKING		= ( 1 << 2 )

global const string CUSTOM_MATCH_MODE_VARIANT_DEFAULT				= "default"
global const string CUSTOM_MATCH_MODE_VARIANT_CUSTOM_ENDING			= "custom_ending_variant"
global const string CUSTOM_MATCH_MODE_VARIANT_NO_RING				= "no_ring_variant"
global const string CUSTOM_MATCH_MODE_VARIANT_TOURNAMENT			= "tournament_variant"

const string CM_DEFAULT_IMAGE = "trios"

const string CM_CATEGORY_COUNT = "custom_match_playlist_category_count"
const string CM_CATEGORY_NAME = "custom_match_playlist_category_%i_name"
const string CM_CATEGORY_IMAGE = "custom_match_playlist_category_%i_image"
const string CM_CATEGORY_LOGO = "custom_match_playlist_category_%i_logo"
const string CM_CATEGORY_SIZE = "custom_match_playlist_category_%i_count"
const string CM_CATEGORY_PLAYLIST = "custom_match_playlist_category_%i_entry_%i"

const int INVALID_INDEX = -1

global struct CustomMatchPlaylist
{
	string 			playlistName
	int    			playlistIndex
	int				mapIndex
	int				categoryIndex
}

global struct CustomMatchMap
{
	string								displayName
	asset								displayImage
	int									categoryIndex
	table<string, CustomMatchPlaylist>	playlists
}

global struct CustomMatchCategory
{
	string 						displayName
	asset 						displayImage
	asset 						displayLogo
	array<CustomMatchMap>		maps
}

struct SettingValue
{
	string selected
	string applied
}

struct
{
	               
	CustomMatch_LobbyPlayer& localPlayerData

	             
	array< array<CustomMatch_LobbyPlayer> > teams

	                 
	CustomMatchCategory&			activeCategory
	array<CustomMatchCategory> 		categories
	array<CustomMatchMap>			maps
	array<CustomMatchPlaylist> 		playlists
	table<string, SettingValue>		settings

	            
	array< void functionref( array<CustomMatchCategory> ) > 	onPlaylistsUpdatedCallbacks
	array< void functionref( CustomMatchCategory ) > 			onGameModeChangedCallbacks
	table< string, array<void functionref( string, string )> > 	onSettingChangedCallbacks
	array< void functionref( CustomMatch_LobbyPlayer ) >		onPlayerDataChangedCallbacks
	array< void functionref( CustomMatch_LobbyState ) >			onLobbyDataChangedCallbacks
	array< void functionref( int, CustomMatch_MatchSummary ) >	onStatsPushedCallbacks

	                                                     
	bool localSettingsLocked

	                                                  
	bool hasSpecialAccess
} file

void function CustomMatch_RefreshPlaylists()
{
	file.categories.clear()
	file.maps.clear()
	file.playlists.clear()

	printf( "Retrieving custom match playlists..." )
	int totalCategoryCount = GetCurrentPlaylistVarInt( CM_CATEGORY_COUNT, 0 )
	Assert( totalCategoryCount > 0, "Custom Match: No game mode categories discovered." )

	for ( int catIdx = 0; catIdx < totalCategoryCount; catIdx++ )
	{
		int entryCount = GetCurrentPlaylistVarInt( format( CM_CATEGORY_SIZE, catIdx ), 0 )
		if ( entryCount == 0 )
			continue

		CustomMatchCategory category
		category.displayName = GetCurrentPlaylistVarString( format( CM_CATEGORY_NAME, catIdx ), "" )
		category.displayImage = GetImageFromImageMap( GetCurrentPlaylistVarString( format( CM_CATEGORY_IMAGE, catIdx ), CM_DEFAULT_IMAGE ) )
		category.displayLogo = GetKeyValueAsAsset( { kn = GetCurrentPlaylistVarString( format( CM_CATEGORY_LOGO, catIdx ), "" ) }, "kn" )
		for ( int entryIdx = 0; entryIdx < entryCount; entryIdx++ )
		{
			string playlistName = GetCurrentPlaylistVarString( format( CM_CATEGORY_PLAYLIST, catIdx, entryIdx ), "" )
			if ( playlistName == "" )
				continue

			bool isVisible = GetPlaylistVarInt( playlistName, "visible", 1 ) == 1
			if ( !isVisible )
				continue

			CustomMatchMap map = GetMap_internal( playlistName )
			category.maps.append( map )
			file.maps.append( map )
		}

		if ( category.maps.len() > 0 )
			file.categories.append( category )
	}

	printf( "Custom match playlists retrieved: %i", file.playlists.len() )
	Assert( file.categories.len(), "Unable to retrieve custom match categories." )
	if ( !file.categories.len() )
		return

	Invoke_OnCustomMatchPlaylistsUpdated( file.categories )
}

CustomMatchMap function GetMap_internal( string rootPlaylist )
{
	CustomMatchMap map
	map.displayName  = GetPlaylistVarString( rootPlaylist, "name", "Custom Match Mode" )
	map.displayImage = GetThumbnailImageFromImageMap( GetPlaylistVarString( rootPlaylist, "panel_image", CM_DEFAULT_IMAGE ) )
	map.categoryIndex = file.categories.len()

	map.playlists[ CUSTOM_MATCH_MODE_VARIANT_DEFAULT ] <- GetPlaylist_internal( rootPlaylist )

	string playlist = GetPlaylistVarString( rootPlaylist, CUSTOM_MATCH_MODE_VARIANT_TOURNAMENT, "" )
	if ( playlist != "" )
		map.playlists[ CUSTOM_MATCH_MODE_VARIANT_TOURNAMENT ] <- GetPlaylist_internal( playlist )

	playlist = GetPlaylistVarString( rootPlaylist, CUSTOM_MATCH_MODE_VARIANT_NO_RING, "" )
	if ( playlist != "" )
		map.playlists[ CUSTOM_MATCH_MODE_VARIANT_NO_RING ] <- GetPlaylist_internal( playlist )

	playlist = GetPlaylistVarString( rootPlaylist, CUSTOM_MATCH_MODE_VARIANT_CUSTOM_ENDING, "" )
	if ( playlist != "" )
		map.playlists[ CUSTOM_MATCH_MODE_VARIANT_CUSTOM_ENDING ] <- GetPlaylist_internal( playlist )

	return map
}

CustomMatchPlaylist function GetPlaylist_internal( string playlistName )
{
	CustomMatchPlaylist playlist
	playlist.playlistName  = playlistName
	playlist.playlistIndex = GetPlaylistIndexForName( playlistName )
	playlist.categoryIndex = file.categories.len()
	playlist.mapIndex = file.maps.len()

	file.playlists.append( playlist )
	return playlist
}

void function CustomMatch_SetGameMode( CustomMatchCategory category )
{
	if ( file.activeCategory == category )
		return

	file.activeCategory = category
	Invoke_OnCustomMatchGameModeChanged( category )
}

void function CustomMatch_SetSetting( string setting, string value, bool forceUpdate = false )
{
	SettingValue settingValue
	if ( setting in file.settings )
		settingValue = file.settings[ setting ]
	else
		file.settings[ setting ] <- settingValue

	bool skipSelected = forceUpdate && file.localSettingsLocked
	if ( !skipSelected )
	{
		string oldValue = settingValue.selected
		settingValue.selected = value
		Invoke_OnCustomMatchSettingChange( setting, oldValue, value )
	}

	if ( forceUpdate )
		settingValue.applied = value
}

string function CustomMatch_GetSetting( string setting )
{
	Assert( setting in file.settings, format( "'%s' not found within custom match settings.", setting ) )
	return ( setting in file.settings ) ? file.settings[ setting ].applied : ""
}

bool function CustomMatch_HasSetting( string setting )
{
	return ( setting in file.settings )
}

void function CustomMatch_SubmitSettings()
{
#if UI
	Assert( CUSTOM_MATCH_SETTING_PLAYLIST in file.settings, "No custom match playlist has been selected." )

	CustomMatch_SettingsForUpdate update
	update.playlist 	= GetSetting( CUSTOM_MATCH_SETTING_PLAYLIST, "" )
	update.adminChat 	= GetBoolSetting( CUSTOM_MATCH_SETTING_CHAT_PERMISSION, false )
	update.teamRename 	= GetBoolSetting( CUSTOM_MATCH_SETTING_RENAME_TEAM, false )
	update.selfAssign 	= GetBoolSetting( CUSTOM_MATCH_SETTING_SELF_ASSIGN, true )
	update.aimAssist 	= GetBoolSetting( CUSTOM_MATCH_SETTING_AIM_ASSIST, true )
	update.anonMode 	= GetBoolSetting( CUSTOM_MATCH_SETTING_ANONYMOUS_MODE, false )
	CustomMatch_UpdateSettings( update )

	foreach ( string _, SettingValue settingValue in file.settings )
		settingValue.applied = settingValue.selected
#endif
}

void function CustomMatch_RestoreSettings()
{
	foreach ( string setting, SettingValue settingValue in file.settings )
	{
		CustomMatch_SetSetting( setting, settingValue.applied )
	}
}

CustomMatchCategory ornull function CustomMatch_GetCategory( int categoryIndex )
{
	if ( categoryIndex < file.categories.len() )
		return file.categories[ categoryIndex ]

	Assert( false, "Failed to locate custom match category \"" + categoryIndex + "\"." )
	return null
}

CustomMatchMap ornull function CustomMatch_GetMap( int mapIndex )
{
	if ( mapIndex < file.maps.len() )
		return file.maps[ mapIndex ]

	Assert( false, "Failed to locate custom match map \"" + mapIndex + "\"." )
	return null
}

CustomMatchPlaylist ornull function CustomMatch_GetPlaylist( string playlistName )
{
	if ( file.playlists.len() == 0 )
		CustomMatch_RefreshPlaylists()

	foreach ( CustomMatchPlaylist playlist in file.playlists )
		if ( playlist.playlistName == playlistName )
			return playlist

	Assert( false, "Failed to locate custom match playlist \"" + playlistName + "\"." )
	return null
}

bool function CustomMatch_IsLocalAdmin()
{
	                                                            
	return file.localPlayerData.isAdmin
}

CustomMatch_LobbyPlayer function CustomMatch_GetLocalPlayerData()
{
	return file.localPlayerData
}

array<CustomMatch_LobbyPlayer> function CustomMatch_GetTeam( int index )
{
	if ( index < file.teams.len() )
		return file.teams[ index ]

	Warning( "Index \"%i\" is not a valid custom match team.", index )
	return []
}

void function CustomMatch_LockLocalSettings( bool lock )
{
	file.localSettingsLocked = lock
}

string function GetSetting( string setting, string defaultValue = "" )
{
	return setting in file.settings ? file.settings[ setting ].selected : defaultValue
}

bool function GetBoolSetting( string setting, bool defaultValue = false )
{
	return setting in file.settings ? file.settings[ setting ].selected == "1" : defaultValue
}

void function AddCallback_OnCustomMatchPlaylistsUpdated( void functionref( array<CustomMatchCategory> ) callbackFunc )
{
	Assert( !file.onPlaylistsUpdatedCallbacks.contains( callbackFunc ), "Already added " + string( callbackFunc ) + " with AddCallback_OnCustomMatchPlaylistsUpdated" )
	file.onPlaylistsUpdatedCallbacks.append( callbackFunc )
}

void function RemoveCallback_OnCustomMatchPlaylistsUpdated( void functionref( array<CustomMatchCategory> ) callbackFunc )
{
	Assert( file.onPlaylistsUpdatedCallbacks.contains( callbackFunc ), "Callback " + string( callbackFunc ) + " does not exist." )
	file.onPlaylistsUpdatedCallbacks.fastremovebyvalue( callbackFunc )
}

void function Invoke_OnCustomMatchPlaylistsUpdated( array<CustomMatchCategory> data )
{
	foreach( callbackFunc in file.onPlaylistsUpdatedCallbacks )
		callbackFunc( data )
}

void function AddCallback_OnCustomMatchGameModeChanged( void functionref( CustomMatchCategory ) callbackFunc )
{
	Assert( !file.onGameModeChangedCallbacks.contains( callbackFunc ), "Already added " + string( callbackFunc ) + " with AddCallback_OnCustomMatchGameModeChanged" )
	file.onGameModeChangedCallbacks.append( callbackFunc )
}

void function RemoveCallback_OnCustomMatchGameModeChanged( void functionref( CustomMatchCategory ) callbackFunc )
{
	Assert( file.onGameModeChangedCallbacks.contains( callbackFunc ), "Callback " + string( callbackFunc ) + " does not exist." )
	file.onGameModeChangedCallbacks.fastremovebyvalue( callbackFunc )
}

void function Invoke_OnCustomMatchGameModeChanged( CustomMatchCategory data )
{
	foreach( callbackFunc in file.onGameModeChangedCallbacks )
		callbackFunc( data )
}

void function AddCallback_OnCustomMatchSettingChanged( string setting, void functionref( string, string ) callbackFunc )
{
	if ( setting in file.onSettingChangedCallbacks )
	{
		Assert( !file.onSettingChangedCallbacks[setting].contains( callbackFunc ), "Already added " + string( callbackFunc ) + " with AddCallback_OnCustomMatchSettingChanged" )
		file.onSettingChangedCallbacks[setting].append( callbackFunc )
	}
	else
	{
		file.onSettingChangedCallbacks[setting] <- [ callbackFunc ]
	}
}

void function RemoveCallback_OnCustomMatchSettingChanged( string setting, void functionref( string, string ) callbackFunc )
{
	Assert( setting in file.onSettingChangedCallbacks, "Callback " + string( callbackFunc ) + " does not exist." )
	Assert( file.onSettingChangedCallbacks[setting].contains( callbackFunc ), "Callback " + string( callbackFunc ) + " does not exist." )
	file.onSettingChangedCallbacks[setting].fastremovebyvalue( callbackFunc )
}

void function Invoke_OnCustomMatchSettingChange( string setting, string oldData, string newData )
{
	if( oldData != newData )
		if ( setting in file.onSettingChangedCallbacks )
			foreach ( callbackFunc in file.onSettingChangedCallbacks[ setting ] )
				callbackFunc( setting, newData )
}

void function AddCallback_OnCustomMatchPlayerDataChanged( void functionref( CustomMatch_LobbyPlayer ) callbackFunc )
{
	Assert( !file.onPlayerDataChangedCallbacks.contains( callbackFunc ), "Already added " + string( callbackFunc ) + " with AddCallback_OnCustomMatchPlayerDataChanged" )
	file.onPlayerDataChangedCallbacks.append( callbackFunc )
}

void function RemoveCallback_OnCustomMatchPlayerDataChanged( void functionref( CustomMatch_LobbyPlayer ) callbackFunc )
{
	Assert( file.onPlayerDataChangedCallbacks.contains( callbackFunc ), "Callback " + string( callbackFunc ) + " does not exist." )
	file.onPlayerDataChangedCallbacks.fastremovebyvalue( callbackFunc )
}

void function Invoke_OnCustomMatchPlayerDataChanged( CustomMatch_LobbyPlayer data )
{
	foreach( callbackFunc in file.onPlayerDataChangedCallbacks )
		callbackFunc( data )
}

void function AddCallback_OnCustomMatchLobbyDataChanged( void functionref( CustomMatch_LobbyState ) callbackFunc )
{
	Assert( !file.onLobbyDataChangedCallbacks.contains( callbackFunc ), "Already added " + string( callbackFunc ) + " with AddCallback_OnCustomMatchLobbyDataChanged" )
	file.onLobbyDataChangedCallbacks.append( callbackFunc )
}

void function RemoveCallback_OnCustomMatchLobbyDataChanged( void functionref( CustomMatch_LobbyState ) callbackFunc )
{
	Assert( file.onLobbyDataChangedCallbacks.contains( callbackFunc ), "Callback " + string( callbackFunc ) + " does not exist." )
	file.onLobbyDataChangedCallbacks.fastremovebyvalue( callbackFunc )
}

void function Invoke_OnCustomMatchLobbyDataChanged( CustomMatch_LobbyState data )
{
	foreach( callbackFunc in file.onLobbyDataChangedCallbacks )
		callbackFunc( data )
}

void function AddCallback_OnCustomMatchStatsPushed( void functionref( int, CustomMatch_MatchSummary ) callbackFunc )
{
	Assert( !file.onStatsPushedCallbacks.contains( callbackFunc ), "Already added " + string( callbackFunc ) + " with AddCallback_OnCustomMatchStatsPushed" )
	file.onStatsPushedCallbacks.append( callbackFunc )
}

void function RemoveCallback_OnCustomMatchStatsPushed( void functionref( int, CustomMatch_MatchSummary ) callbackFunc )
{
	Assert( file.onStatsPushedCallbacks.contains( callbackFunc ), "Callback " + string( callbackFunc ) + " does not exist." )
	file.onStatsPushedCallbacks.fastremovebyvalue( callbackFunc )
}

void function Invoke_OnCustomMatchStatsPushed( int key, CustomMatch_MatchSummary data )
{
	foreach( callbackFunc in file.onStatsPushedCallbacks )
		callbackFunc( key, data )
}

void function CustomMatch_DataChanged( CustomMatch_LobbyState data )
{
	if ( data.selfIdx == INVALID_INDEX )
	{
		CustomMatch_CloseLobbyMenu( "#CUSTOM_MATCH_REMOVED_FROM_MATCH", "#CUSTOM_MATCH_REMOVED_FROM_MATCH_DESC" )
	}
	else
	{
		bool hasSpecialAccess = CustomMatch_HasSpecialAccess()
		if ( file.hasSpecialAccess != hasSpecialAccess )
		{
			file.hasSpecialAccess = hasSpecialAccess
			file.settings.clear()
		}

		SetPlayerData_internal( data.players[ data.selfIdx ] )		                                                              
		SetLobbySettings_internal( data )							                                    
		SetLobbyData_internal( data )								                                                     
	}
}

const string ON = "1"
const string OFF = "0"
void function SetLobbySettings_internal( CustomMatch_LobbyState lobbyData )
{
	SetLobbySetting_internal( CUSTOM_MATCH_SETTING_PLAYLIST,			lobbyData.playlist )
	SetLobbySetting_internal( CUSTOM_MATCH_SETTING_CHAT_PERMISSION,		lobbyData.adminChat 	? ON : OFF )
	SetLobbySetting_internal( CUSTOM_MATCH_SETTING_RENAME_TEAM, 		lobbyData.teamRename 	? ON : OFF )
	SetLobbySetting_internal( CUSTOM_MATCH_SETTING_SELF_ASSIGN,			lobbyData.selfAssign 	? ON : OFF )
	SetLobbySetting_internal( CUSTOM_MATCH_SETTING_AIM_ASSIST, 			lobbyData.aimAssist 	? ON : OFF )
	SetLobbySetting_internal( CUSTOM_MATCH_SETTING_ANONYMOUS_MODE,		lobbyData.anonMode 		? ON : OFF )
	SetLobbySetting_internal( CUSTOM_MATCH_SETTING_MATCH_STATUS,		lobbyData.matchState.tostring()    )
}

void function SetLobbySetting_internal( string setting, string value )
{
	CustomMatch_SetSetting( setting, value, true )
}

void function SetPlayerData_internal( CustomMatch_LobbyPlayer playerData )
{
	                                                                                         
	if ( file.localPlayerData.isAdmin != playerData.isAdmin )
		file.settings.clear()

	file.localPlayerData = playerData
	Invoke_OnCustomMatchPlayerDataChanged( playerData )
}

void function SetLobbyData_internal( CustomMatch_LobbyState data )
{
	                                                                                
	array< array< CustomMatch_LobbyPlayer > > teams
	teams.resize( data.maxTeams + TEAM_MULTITEAM_FIRST )
	foreach ( CustomMatch_LobbyPlayer player in data.players )
		teams[ player.team ].append( player )
	file.teams = teams

	Invoke_OnCustomMatchLobbyDataChanged( data )
}

void function CustomMatch_PushMatchStats( int endTime, CustomMatch_MatchSummary summary )
{
	Invoke_OnCustomMatchStatsPushed( endTime, summary )
}