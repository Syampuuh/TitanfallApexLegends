global function InitPrivateMatchGamemodeSelectDialog

const string PL_PM = "private_match"
const string PM_CATEGORY_COUNT = "private_match_playlist_category_count"
const string PM_CATEGORY = "private_match_playlist_category_"
const string CATEGORY_GRID = "GameModeCategoryGrid"
const int TOTAL_CATEGORY_COUNT = 4                                                                                                                  

struct PrivateMatchGameMode
{
	string playlistName
	int    playlistIndex
	string displayName
}

struct {
	var menu
	var closeButton
	var selectionPanel

	int                                       totalCategoryCount
	array<var> categoryListPanels
	array<string> categoryNames
	table< int, array<PrivateMatchGameMode> > categoryPlaylists
	array<void functionref()> allGameModesGatheredCallbacks
	array<var> gamemodeButtons
	table< var, string > buttonToPlaylistNameMap

	array<var>         modeSelectButtonList
	table<var, string> selectButtonPlaylistNameMap
	var                rankedRUIToUpdate = null

                        
	var                arenasRUIToUpdate = null
       

	bool showVideo
} file

void function InitPrivateMatchGamemodeSelectDialog( var newMenuArg )
                                              
{
	var menu = GetMenu( "PrivateMatchGamemodeSelectDialog" )
	file.menu = menu

	SetDialog( menu, true )
	SetClearBlur( menu, false )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenModeSelectDialog )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnCloseModeSelectDialog )

	file.closeButton = Hud_GetChild( menu, "CloseButton" )
	Hud_AddEventHandler( file.closeButton, UIE_CLICK, OnCloseButton_Activate )

	for ( int categoryIdx = 0; categoryIdx < TOTAL_CATEGORY_COUNT; categoryIdx++ )
	{
		string catName = "GameModeCategoryListPanel" + categoryIdx
		var categoryList = Hud_GetChild( menu, catName )
		file.categoryListPanels.append( categoryList )
	}

	AddCallback_OnAllGameModesGathered( OnAllGamemodeCategoryPlaylistsGathered )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#CLOSE" )
	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_SELECT" )
}


void function GatherGamemodeCategoryPlaylists()
{
	file.categoryPlaylists.clear()

	int totalCategoryCount = GetPlaylistVarInt( PL_PM, PM_CATEGORY_COUNT, TOTAL_CATEGORY_COUNT )
	Assert( totalCategoryCount <= TOTAL_CATEGORY_COUNT, "Private Match: Too many game mode categories for menu to display" )
	file.totalCategoryCount = totalCategoryCount

	for ( int catIdx = 0; catIdx < totalCategoryCount; catIdx++ )
	{
		string categoryString = PM_CATEGORY + catIdx
		int entryCount        = GetPlaylistVarInt( PL_PM, categoryString + "_count", 0 )
		if ( entryCount == 0 )
		{
			continue
		}

		string categoryName = GetPlaylistVarString( PL_PM, categoryString + "_name", "" )
		file.categoryNames.append( categoryName )

		for ( int entryIdx = 0; entryIdx < entryCount; entryIdx++ )
		{
			string entryString = categoryString + "_entry_" + entryIdx
			string playlistName = GetPlaylistVarString( PL_PM, entryString, "" )
			if ( playlistName == "" )
				continue

			bool isVisible = GetPlaylistVarInt( playlistName, "visible", 1 ) == 1
			if ( !isVisible )
				continue

			PrivateMatchGameMode gameMode
			gameMode.playlistName = playlistName
			gameMode.playlistIndex = GetPlaylistIndexForName( playlistName )
			gameMode.displayName = GetPlaylistVarString( playlistName, "name", "Private Match Mode" )

			if ( catIdx in file.categoryPlaylists )
				file.categoryPlaylists[ catIdx ].append( gameMode )
			else
				file.categoryPlaylists[ catIdx ] <- [ gameMode ]
		}
	}

	foreach( callbackFunc in file.allGameModesGatheredCallbacks )
		callbackFunc()
}


void function AddCallback_OnAllGameModesGathered( void functionref() callbackFunc )
{
	Assert( !file.allGameModesGatheredCallbacks.contains( callbackFunc ), "Already added " + string( callbackFunc ) + " with AddCallback_OnAllGameModesGathered" )
	file.allGameModesGatheredCallbacks.append( callbackFunc )
}


void function RemoveCallback_OnAllGameModesGathered( void functionref() callbackFunc )
{
	Assert( file.allGameModesGatheredCallbacks.contains( callbackFunc ), "Callback " + string( callbackFunc ) + " does not exist." )
	file.allGameModesGatheredCallbacks.fastremovebyvalue( callbackFunc )
}


void function OnAllGamemodeCategoryPlaylistsGathered()
{
	file.buttonToPlaylistNameMap.clear()

	for ( int i = 0; i < file.categoryListPanels.len(); i++ )
	{
		bool gridHasEntries = i in file.categoryPlaylists
		if ( gridHasEntries )
			ConfigureGameModeGrid( i )
	}
}


void function ConfigureGameModeGrid( int category )
{
	var gridPanel                         = file.categoryListPanels[ category ]
	array<PrivateMatchGameMode> gameModes = clone( file.categoryPlaylists[ category ] )

	var label = Hud_GetChild( gridPanel, "GameModeCategoryLabel" )
	Hud_SetText( label, Localize( file.categoryNames[category] ) )

	var modeGrid = Hud_GetChild( gridPanel, CATEGORY_GRID )
	int buttonCount = gameModes.len()

	Hud_InitGridButtons( modeGrid, buttonCount )
	var scrollPanel = Hud_GetChild( modeGrid, "ScrollPanel" )

	for ( int modeIndex = 0; modeIndex < buttonCount; modeIndex++ )
	{
		var button = Hud_GetChild( scrollPanel, format( "GridButton%d", modeIndex ) )
		InitGamemodeButton( button, gameModes[ modeIndex ] )
	}
}


void function InitGamemodeButton( var button, PrivateMatchGameMode gamemode )
{
	var rui = Hud_GetRui( button )
	RuiSetString( rui, "buttonText", gamemode.displayName )
	file.buttonToPlaylistNameMap[ button ] <- gamemode.playlistName

	Hud_AddEventHandler( button, UIE_CLICK, GamemodeButton_Activate )
}


void function OnOpenModeSelectDialog()
{
	SetModeSelectMenuOpen( true )

	UpdateOpenPrivateMatchModeSelectDialog()
}


void function UpdateOpenPrivateMatchModeSelectDialog()
{
	Hud_SetAboveBlur( GetMenu( "LobbyMenu" ), false )

	file.buttonToPlaylistNameMap.clear()
	GatherGamemodeCategoryPlaylists()
}


array<string> function GetPlaylistsInRegularSlots()
{
	array<string> playlistNames = GetVisiblePlaylistNames( IsPrivateMatchLobby() )
	array<string> regularList
	foreach ( string plName in playlistNames )
	{
		string uiSlot = GetPlaylistVarString( plName, "ui_slot", "" )

		if ( uiSlot.find( "regular" ) == 0 )
			regularList.append( plName )
	}

	return regularList
}


void function OnCloseModeSelectDialog()
{
	foreach( button, playlistName in file.buttonToPlaylistNameMap )
	{
		Hud_RemoveEventHandler( button, UIE_CLICK, GamemodeButton_Activate )
	}

	Hud_SetAboveBlur( GetMenu( "LobbyMenu" ), true )

	var modeSelectButton = GetModeSelectButton()
	Hud_SetSelected( modeSelectButton, false )
	Hud_SetFocused( modeSelectButton )

	SetModeSelectMenuOpen( false )

	Lobby_OnGamemodeSelectClose()
}


void function GamemodeButton_Activate( var button )
{
	if ( Hud_IsLocked( button ) )
	{
		EmitUISound( "menu_deny" )
		return
	}

	string playlistName = file.buttonToPlaylistNameMap[ button ]
	PrivateMatch_SetSelectedPlaylist( playlistName )

	CloseAllDialogs()
}


void function GamemodeButton_OnGetFocus( var button )
{
}


void function GamemodeButton_OnLoseFocus( var button )
{
}


void function OnCloseButton_Activate( var button )
{
	CloseAllDialogs()
}