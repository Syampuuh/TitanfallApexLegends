global function InitModeSelectDialog

struct {
	var menu

	var modeSelectPopup
	var modeList
	var modeModList

	var closeButton

	table<var, string> buttonToMode
	table<var, string> buttonToModeMod
	table<string, bool> modeModIsActive
} file

void function InitModeSelectDialog( var newMenuArg )                                               
{
	var menu = GetMenu( "ModeSelectDialog" )
	file.menu = menu

	SetDialog( menu, true )
	SetClearBlur( menu, false )

	file.modeSelectPopup = Hud_GetChild( menu, "ModeSelectPopup" )
	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenModeSelectDialog )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnCloseModeSelectDialog )

	file.modeList = Hud_GetChild( file.modeSelectPopup, "ModeList" )
	file.modeModList = Hud_GetChild( file.modeSelectPopup, "ModeModList" )

	file.closeButton = Hud_GetChild( menu, "CloseButton" )
	Hud_AddEventHandler( file.closeButton, UIE_CLICK, OnCloseButton_Activate )
}

void function OnOpenModeSelectDialog()
{
	             
	foreach ( button, playlistName in file.buttonToMode )
		Hud_RemoveEventHandler( button, UIE_CLICK, OnModeButton_Activate )
	file.buttonToMode.clear()

	foreach ( button, playlistName in file.buttonToModeMod )
		Hud_RemoveEventHandler( button, UIE_CLICK, OnModeModButton_Activate )
	file.buttonToModeMod.clear()
	           

	var ownerButton = GetModeSelectButton()

	UIPos ownerPos   = REPLACEHud_GetAbsPos( ownerButton )
	UISize ownerSize = REPLACEHud_GetSize( ownerButton )

	array<string> playlists = Lobby_GetPlaylists()
	array<string> playlistMods = Lobby_GetPlaylistMods()

	Hud_InitGridButtons( file.modeList, playlists.len() )
	Hud_InitGridButtons( file.modeModList, playlistMods.len() )

	var scrollPanel = Hud_GetChild( file.modeList, "ScrollPanel" )
	var modScrollPanel = Hud_GetChild( file.modeModList, "ScrollPanel" )

	int SCROLLBAR_PX = 12
	int LABELHEIGHT = 40
	int PADDING = 8
	int MAX_ROWS = 10

	table<string, bool> oldModeModIsActive = clone file.modeModIsActive
	file.modeModIsActive.clear()

	if ( playlists.len() == 0 )
		return

	string selectedPlaylist = Lobby_GetSelectedPlaylist()
	bool foundSelectedPlaylist = false
	int buttonMaxHeight = 0
	for ( int i = 0; i < playlists.len(); i++ )
	{
		var button = Hud_GetChild( scrollPanel, ("GridButton" + i) )
		int buttonHeight = Hud_GetHeight( button )
		if ( buttonHeight > buttonMaxHeight )
			buttonMaxHeight = buttonHeight
		ModeButton_Init( button, playlists[i] )

		if ( selectedPlaylist == playlists[i] )
		{
			Hud_SetFocused( button )
			Hud_SetSelected( button, true )
			foundSelectedPlaylist = true
		}
	}

	if ( !foundSelectedPlaylist )
	{
		var button0	= Hud_GetChild( scrollPanel, "GridButton0" )
		Hud_SetFocused( button0 )
		Hud_SetSelected( button0, true )
	}

	for ( int i = 0; i < playlistMods.len(); i++ )
	{
		var button = Hud_GetChild( modScrollPanel, ("GridButton" + i) )
		string modName = playlistMods[i]
		bool wasActive = false
		if ( modName in oldModeModIsActive )
			wasActive = oldModeModIsActive[modName]
		ModeModButton_Init( button, modName, wasActive )
	}

	{                            
		int popupHeight		= minint( MAX_ROWS, playlists.len() ) * buttonMaxHeight
		int modeListWidth	= ownerSize.width + SCROLLBAR_PX 

		Hud_SetPos( file.modeSelectPopup, ownerPos.x, ownerPos.y - popupHeight )

		if ( playlistMods.len() == 0 )
		{
			Hud_SetSize( file.modeSelectPopup, ownerSize.width + SCROLLBAR_PX, popupHeight )
			Hud_SetSize( file.modeList, modeListWidth, popupHeight )
		}
		else
		{
			Hud_SetSize( file.modeSelectPopup, ownerSize.width * 2 + SCROLLBAR_PX * 2 + PADDING, popupHeight )
			Hud_SetSize( file.modeList, modeListWidth, popupHeight )
			var label = Hud_GetChild( file.modeSelectPopup, "ModeModListHeaderText" )
			Hud_SetPos( label, modeListWidth + PADDING, 0 )
			Hud_SetPos( file.modeModList, modeListWidth + PADDING, buttonMaxHeight )
			Hud_SetSize( file.modeModList, ownerSize.width + SCROLLBAR_PX, popupHeight - buttonMaxHeight )
		}
	}
}

void function OnCloseModeSelectDialog()
{
	var modeSelectButton = GetModeSelectButton()
	Hud_SetSelected( modeSelectButton, false )
	Hud_SetFocused( modeSelectButton )
}

void function ModeButton_Init( var button, string playlistName )
{
	var lobbyModeSelectButton = GetModeSelectButton()
	                                                                                                                                                         

	InitButtonRCP( button )
	var rui = Hud_GetRui( button )

	string name = GetPlaylistVarString( playlistName, "name", "#HUD_UNKNONWN" )
	RuiSetString( rui, "buttonText", Localize( name ) )

	bool isPlaylistAvailable = Lobby_IsPlaylistAvailable( playlistName )

	ToolTipData toolTipData
	if ( !isPlaylistAvailable )
	{
		toolTipData.titleText = "#PLAYLIST_UNAVAILABLE"
		toolTipData.descText = Lobby_GetPlaylistStateString( Lobby_GetPlaylistState( playlistName ) )
	}
	else
	{
		toolTipData.titleText = ""       
		toolTipData.descText = GetPlaylistVarString( playlistName, "description", "#HUD_UNKNOWN" )
	}
	Hud_SetToolTipData( button, toolTipData )

	Hud_SetLocked( button, !isPlaylistAvailable )
	Hud_AddEventHandler( button, UIE_CLICK, OnModeButton_Activate )
	file.buttonToMode[button] <- playlistName
}

void function OnModeButton_Activate( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	string playlistString = file.buttonToMode[button]
	printf( "Setting playlist %s\n", playlistString )
	Lobby_SetSelectedPlaylist( playlistString )
	CloseAllDialogs()
}

void function ModeModButton_Init( var button, string modName, bool isActive )
{
	InitButtonRCP( button )
	file.modeModIsActive[modName] <- isActive
	Hud_SetChecked( button, isActive )
	var rui = Hud_GetRui( button )

	string name = modName                                                                         
	RuiSetString( rui, "buttonText", name )                      

	{
		ToolTipData toolTipData
		toolTipData.titleText = name
		toolTipData.descText = "playlistMod +'" + name + "'"                                                                                

		Hud_SetToolTipData( button, toolTipData )
	}

	Hud_AddEventHandler( button, UIE_CLICK, OnModeModButton_Activate )
	file.buttonToModeMod[button] <- modName
}

void function OnModeModButton_Activate( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	{                      
		string modeModName = file.buttonToModeMod[button];
		bool newChecked = !Hud_IsChecked( button );
		printf( "OnModeModButton_Activate: %s setting %s.", modeModName, (newChecked) ? "true" : "false" )
		Hud_SetChecked( button, newChecked )
		file.modeModIsActive[modeModName] = newChecked
	}

	{                                        
		string modString = ""
		                                                                                                               
		array<string> playlistMods = Lobby_GetPlaylistMods()
		foreach( modeModName in playlistMods )
		{
			if ( file.modeModIsActive[modeModName] )
				modString = modString + "+" + modeModName
		}
		printf( "Setting playlistmods %s\n", modString )
		Lobby_SetSelectedPlaylistMods( modString )
	}
}

void function OnCloseButton_Activate( var button )
{
	CloseAllDialogs()
}