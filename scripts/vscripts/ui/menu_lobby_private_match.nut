global function InitPrivateMatchLobbyMenu
global function PrivateMatch_SetSelectedPlaylist
global function PrivateMatch_RefreshPlaylistButtonName
global function PrivateMatch_PlaylistNameChanged
global function PrivateMatch_RefreshStartCountdown
global function PrivateMatch_SetLobbyChatVisible
global function PrivateMatch_SetPreloadingPlayers
global function UICodeCallback_PrivateMatchPreloadChanged

const string SIGNAL_LOBBY_UPDATE = "PrivateMatchLobbyMenuUpdate"

struct
{
	#if UI
		int  activePresentationType = ePresentationType.INACTIVE
	#endif      

	var    menu
	var    menuHeaderRui

	bool updatingLobbyUI = false
	bool inputsRegistered = false

	bool isReady = false
	bool isStarting = false
	bool isPreloading = false

	int preloadingPlayers = 0

	var teamRosterPanel
	var spectatorRosterPanel
	var unassignedRosterPanel
	var userControlsPanel
	var postGamePanel

	var readyLaunchButton
	var modeButton
	var gameMenuButton
	var postGameButton
	var teamSwapButton
	var teamRenameButton
	var adminOnlyButton
	var aimAssistButton
	var anonymousModeButton
	var kickTarget

	bool lastTeamSwapState = false
	bool lastTeamRenameState = false
	bool lastAdminOnlyChatState = false
	bool lastAimAssistState = false
	bool lastAnonymousModeState = false

	var textChat
	var chatInputLine
	var chatButtonIcon

	var mouseDragIcon
} file

void function InitPrivateMatchLobbyMenu( var newMenuArg )
{
	printf( "PrivateMatchLobbyDebug: Init Private Match Lobby" )
	var menu = GetMenu( "PrivateMatchLobbyMenu" )
	file.menu = menu
	file.mouseDragIcon = Hud_GetChild( menu, "MouseDragIcon" )

	file.menuHeaderRui = Hud_GetRui( Hud_GetChild( menu, "MenuHeader" ) )
	RuiSetString( file.menuHeaderRui, "menuName", "#TOURNAMENT_LOBBY_HEADER" )

	AddUICallback_InputModeChanged( OnInputModeChanged )

	RegisterSignal( SIGNAL_LOBBY_UPDATE )

	AddMenuEventHandler( menu, eUIEvent.MENU_GET_TOP_LEVEL, OnGetTopLevel )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnPrivateMatchLobbyMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnPrivateMatchLobbyMenu_Close )

	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnPrivateMatchLobbyMenu_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, OnPrivateMatchLobbyMenu_Hide )

	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnPrivateMatchLobbyMenu_NavigateBack )

	AddMenuVarChangeHandler( "isFullyConnected", UpdateFooterOptions )
	AddMenuVarChangeHandler( "isPartyLeader", UpdateFooterOptions )

	var teamRosterPanel = Hud_GetChild( menu, "PrivateMatchRosterPanel" )
	file.teamRosterPanel = teamRosterPanel
	Hud_Show( file.teamRosterPanel )

	var spectatorRosterPanel = Hud_GetChild( menu, "PrivateMatchSpectatorPanel" )
	file.spectatorRosterPanel = spectatorRosterPanel
	Hud_Show( file.spectatorRosterPanel )

	file.textChat = Hud_GetChild( menu, "LobbyChatBox" )
	file.chatInputLine = Hud_GetChild( file.textChat, "ChatInputLine" )
	Hud_Show( file.textChat )

	var unassignedRosterPanel = Hud_GetChild( menu, "PrivateMatchUnassignedPlayersPanel" )
	file.unassignedRosterPanel = unassignedRosterPanel
	Hud_Show( file.unassignedRosterPanel )

	var userControlsPanel = Hud_GetChild( menu, "PrivateMatchUserControls" )
	file.userControlsPanel = userControlsPanel
	Hud_Show( file.userControlsPanel )

	var postGameButton = Hud_GetChild( userControlsPanel, "PrivateMatchPostGameButton" )
	file.postGameButton = postGameButton
	ToolTipData postGameToolTip
	postGameToolTip.descText = "#MATCH_SUMMARY"
	Hud_SetToolTipData( postGameButton, postGameToolTip )
	HudElem_SetRuiArg( postGameButton, "icon", $"rui/menu/lobby/postgame_icon" )
	HudElem_SetRuiArg( postGameButton, "shortcutText", "%[BACK|TAB]%" )
	Hud_AddEventHandler( postGameButton, UIE_CLICK, PrivateMatchPostGameButton_OnActivate )

	var readyLaunchButton = Hud_GetChild( userControlsPanel, "ReadyButton" )
	file.readyLaunchButton = readyLaunchButton
	Hud_AddEventHandler( file.readyLaunchButton, UIE_CLICK, ReadyLaunchButton_OnActivate )

	file.modeButton = Hud_GetChild( userControlsPanel, "ModeButton" )
	Hud_AddEventHandler( file.modeButton, UIE_CLICK, ModeSelectButton_OnActivate )

	file.teamSwapButton = Hud_GetChild( userControlsPanel, "PrivateMatchTeamSwapToggleButton" )
	ToolTipData teamSwapToolTip
	teamSwapToolTip.descText = "#TOURNAMENT_TEAM_SWAP_OFF"
	Hud_SetToolTipData( file.teamSwapButton, teamSwapToolTip )
	HudElem_SetRuiArg( file.teamSwapButton, "icon", $"rui/menu/lobby/settings_icon" )
	Hud_AddEventHandler( file.teamSwapButton, UIE_CLICK, TeamSwapButton_OnActivate )

	file.teamRenameButton = Hud_GetChild( userControlsPanel, "PrivateMatchTeamRenameToggleButton" )
	ToolTipData teamRenameToolTip
	teamRenameToolTip.descText = "#TOURNAMENT_TEAM_RENAME_OFF"
	Hud_SetToolTipData( file.teamRenameButton, teamRenameToolTip )
	HudElem_SetRuiArg( file.teamRenameButton, "buttonText", "[  | ]" )
	Hud_AddEventHandler( file.teamRenameButton, UIE_CLICK, TeamRenameButton_OnActivate )

	file.adminOnlyButton = Hud_GetChild( userControlsPanel, "PrivateMatchAdminOnlyChatToggleButton" )
	ToolTipData adminOnlyToolTip
	adminOnlyToolTip.descText = "#TOURNAMENT_ADMIN_ONLY_CHAT_OFF"
	Hud_SetToolTipData( file.adminOnlyButton, adminOnlyToolTip )
	HudElem_SetRuiArg( file.adminOnlyButton , "icon", $"rui/menu/lobby/icon_textchat" )
	Hud_AddEventHandler( file.adminOnlyButton, UIE_CLICK, AdminOnlyButton_OnActivate )

	file.aimAssistButton = Hud_GetChild( userControlsPanel, "PrivateMatchAimAssistToggleButton" )
	ToolTipData aimAssistToolTip
	aimAssistToolTip.descText = "#TOURNAMENT_AIM_ASSIST_OFF"
	Hud_SetToolTipData( file.aimAssistButton, aimAssistToolTip )
	Hud_AddEventHandler( file.aimAssistButton, UIE_CLICK, AimAssistButton_OnActivate )

	file.anonymousModeButton = Hud_GetChild( userControlsPanel, "PrivateMatchAnonymousModeToggleButton" )
	ToolTipData anonymousModeToolTip
	anonymousModeToolTip.descText = "#TOURNAMENT_ANONYMOUS_MODE_OFF"
	Hud_SetToolTipData( file.anonymousModeButton, anonymousModeToolTip )
	Hud_AddEventHandler( file.anonymousModeButton, UIE_CLICK, AnonymousModeButton_OnActivate )
	
	file.kickTarget = Hud_GetChild( menu, "KickButton")

	file.chatButtonIcon = Hud_GetChild( menu, "LobbyChatBoxIcon")

	AddMenuVarChangeHandler( "isFullyConnected", UpdateFooterOptions )
	AddMenuVarChangeHandler( "isPartyLeader", UpdateFooterOptions )
	#if DURANGO_PROG
		AddMenuVarChangeHandler( "DURANGO_canInviteFriends", UpdateFooterOptions )
		AddMenuVarChangeHandler( "DURANGO_isJoinable", UpdateFooterOptions )
	#elseif PLAYSTATION_PROG
		AddMenuVarChangeHandler( "PS4_canInviteFriends", UpdateFooterOptions )
	#elseif PC_PROG
		AddMenuVarChangeHandler( "ORIGIN_isEnabled", UpdateFooterOptions )
		AddMenuVarChangeHandler( "ORIGIN_isJoinable", UpdateFooterOptions )
	#endif

	RegisterSignal( "TEMP_UpdateCursorPosition" )
}


void function OnGetTopLevel()
{

	if ( IsPrivateMatchLobby() )
		UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )
}


void function OnPrivateMatchLobbyMenu_Open()
{
}


void function OnPrivateMatchLobbyMenu_Show()
{
	RegisterInputs()

	Chroma_Lobby()

	bool hasAdminRole = HasMatchAdminRole()

	OnInputModeChanged( IsControllerModeActive() )

	Hud_SetEnabled( file.modeButton, hasAdminRole )
	Hud_SetEnabled( file.teamSwapButton, hasAdminRole )
	Hud_SetEnabled( file.anonymousModeButton, hasAdminRole )
	Hud_SetEnabled( file.kickTarget, hasAdminRole )
	Hud_SetVisible( file.kickTarget, hasAdminRole )

	thread OnPrivateMatchLobbyThink()
}

void function OnInputModeChanged( bool controllerModeActive )
{
	UpdateReadyButtonText( controllerModeActive )
	ControllerIconVisibilty( controllerModeActive )
}

void function ControllerIconVisibilty( bool controllerModeActive )
{
	Hud_SetEnabled( file.chatButtonIcon, controllerModeActive )
	Hud_SetVisible( file.chatButtonIcon, controllerModeActive )
}

void function OnPrivateMatchLobbyThink()
{
	Signal( uiGlobal.signalDummy, "TEMP_UpdateCursorPosition" )
	EndSignal( uiGlobal.signalDummy, "TEMP_UpdateCursorPosition" )
	
	while ( true )
	{
		if ( CanRunClientScript() )
		{
			RunClientScript( "PrivateMatch_ClientFrame" )

			PrivateMatch_RefreshPlaylistButtonName()

			if ( GetGlobalNetBool( "canAssignSelf" ) != file.lastTeamSwapState )
			{
				ToolTipData teamSwapToolTip
				teamSwapToolTip.descText = GetGlobalNetBool( "canAssignSelf" ) ? "#TOURNAMENT_TEAM_SWAP_ON" : "#TOURNAMENT_TEAM_SWAP_OFF"
				Hud_SetToolTipData( file.teamSwapButton, teamSwapToolTip )
				file.lastTeamSwapState = GetGlobalNetBool( "canAssignSelf" )
			}

			if ( GetGlobalNetBool( "canPlayersRenameTeams" ) != file.lastTeamRenameState )
			{
				ToolTipData teamRenameToolTip
				teamRenameToolTip.descText = GetGlobalNetBool( "canPlayersRenameTeams" ) ? "#TOURNAMENT_TEAM_RENAME_ON" : "#TOURNAMENT_TEAM_RENAME_OFF"
				Hud_SetToolTipData( file.teamRenameButton, teamRenameToolTip )
				file.lastTeamRenameState = GetGlobalNetBool( "canPlayersRenameTeams" )
			}

			if ( GetGlobalNetBool( "adminOnlyChat" ) != file.lastAdminOnlyChatState )
			{
				bool isAdminOnly = GetGlobalNetBool( "adminOnlyChat" )
				ToolTipData adminOnlyChatToolTip
				adminOnlyChatToolTip.descText = isAdminOnly ? "#TOURNAMENT_ADMIN_ONLY_CHAT_ON" : "#TOURNAMENT_ADMIN_ONLY_CHAT_OFF"
				Hud_SetToolTipData( file.adminOnlyButton, adminOnlyChatToolTip )
				file.lastAdminOnlyChatState = isAdminOnly

				if ( !HasMatchAdminRole() )
					SetChatTextBoxVisible( !isAdminOnly )
			}

			bool aimAssistOn = GetConVarBool( CUSTOM_AIM_ASSIST_CONVAR_NAME )
			if ( aimAssistOn != file.lastAimAssistState )
			{
				ToolTipData aimAssistToolTip
				aimAssistToolTip.descText = aimAssistOn ? "#TOURNAMENT_AIM_ASSIST_ON" : "#TOURNAMENT_AIM_ASSIST_OFF"
				Hud_SetToolTipData( file.aimAssistButton, aimAssistToolTip )
				file.lastAimAssistState = aimAssistOn
			}

			bool anonymousModeActive = GetConVarBool( CUSTOM_ANONYMOUS_MODE_CONVAR_NAME )
			if ( anonymousModeActive != file.lastAnonymousModeState )
			{
				AnonymousMode_OnChange( file.lastAnonymousModeState, anonymousModeActive )
				file.lastAnonymousModeState = anonymousModeActive
			}
		}

		WaitFrame()
	}
}


void function OnPrivateMatchLobbyMenu_Hide()
{
	DeregisterInputs()
	Signal( uiGlobal.signalDummy, "TEMP_UpdateCursorPosition" )
}


void function OnPrivateMatchLobbyMenu_Close()
{
	DeregisterInputs()
	Signal( uiGlobal.signalDummy, "TEMP_UpdateCursorPosition" )
}


void function PrivateMatch_SetSelectedPlaylist( string playlistName )
{
	Remote_ServerCallFunction( "ClientCallback_PrivateMatchSetPlaylist", playlistName )
}

void function PrivateMatch_SetPreloadingPlayers( int preloadingPlayerCount )
{
	file.preloadingPlayers = preloadingPlayerCount
	UpdateReadyButtonText( IsControllerModeActive() )
}

void function PrivateMatch_PlaylistNameChanged()
{
	if ( !IsPrivateMatchLobby() )
		return

	if ( !CanRunClientScript() )
		return

	SetMatchmakingPlaylist( PrivateMatch_GetSelectedPlaylistName() )
	PrivateMatch_RefreshPlaylistButtonName()
}

void function PrivateMatch_RefreshPlaylistButtonName()
{
	string playlistName = PrivateMatch_GetSelectedPlaylistName()

	int maxTeams = GetPlaylistVarInt( playlistName, MAX_TEAMS_PLAYLIST_VAR, 20 )

	for ( int i=0 ; i<20; i++ )
	{
		string teamString = string( i )
		if ( i < 10 )
			teamString = "0" + teamString
		var teamPanel = Hud_GetChild( file.teamRosterPanel, "Team" + teamString )

		if ( i >= maxTeams )
			Hud_Hide( teamPanel )
		else
			Hud_Show( teamPanel )
	}

	if( !file.modeButton )
		return

	string displayName = "#SELECT_PLAYLIST"
	
	displayName = playlistName != "" ? GetPlaylistVarString( playlistName, "name", "#SELECT_PLAYLIST" ) : "#SELECT_PLAYLIST"
	                                                                                                           

	HudElem_SetRuiArg( file.modeButton, "buttonText", Localize( displayName ) )

}

void function PrivateMatch_RefreshStartCountdown( int newVal )
{
	if( newVal > 0 )
	{
		if ( HasMatchAdminRole() )
		{
			string countdownString = format( "%s %d", Localize( IsControllerModeActive() ? "#B_BUTTON_TOURNAMENT_STARTING_IN" : "#TOURNAMENT_STARTING_IN" ), newVal )
			HudElem_SetRuiArg( file.readyLaunchButton, "buttonText", countdownString )
		}
		else
		{
			string countdownString = format( "%s %d", Localize( "#TOURNAMENT_STARTING_IN" ), newVal )
			HudElem_SetRuiArg( file.readyLaunchButton, "buttonText", countdownString )
		}
		file.isStarting = true
	}
	else if( newVal == 0 )
	{
		HudElem_SetRuiArg( file.readyLaunchButton, "buttonText", Localize( "#TOURNAMENT_STARTING_NOW" ) )
		file.isStarting = true
	}
	else if( newVal < 0 )
	{
		file.isStarting = false
		UpdateReadyButtonText( IsControllerModeActive() )
	}
}

void function PrivateMatchLobbyMenuUpdate()
{
	Signal( uiGlobal.signalDummy, SIGNAL_LOBBY_UPDATE )
	EndSignal( uiGlobal.signalDummy, SIGNAL_LOBBY_UPDATE )
	EndSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )

	                
	   
	  	                 
	  	                     
	  	            
	  	           
	   
}

void function UpdateReadyButtonText( bool isControllerModeActive )
{
	if ( HasMatchAdminRole() )
	{
		if( !Hud_IsEnabled( file.readyLaunchButton ) )
			Hud_SetEnabled( file.readyLaunchButton, true )
		if ( file.preloadingPlayers > 0 )
			HudElem_SetRuiArg( file.readyLaunchButton, "buttonDescText", Localize( "#PRIVATEMATCH_PLAYERS_PRELOADING", file.preloadingPlayers ) )
		else
			HudElem_SetRuiArg( file.readyLaunchButton, "buttonDescText", "" )
	}
	else
	{
		Hud_SetEnabled( file.readyLaunchButton, !file.isPreloading )
	}

	if ( file.isStarting )
		return

	if ( HasMatchAdminRole() )
	{
		HudElem_SetRuiArg( file.readyLaunchButton, "buttonText", Localize( isControllerModeActive ? "#Y_BUTTON_TOURNAMENT_START_MATCH" : "#TOURNAMENT_START_MATCH" ) )
	}
	else
	{
		string buttonText = ""
		if ( file.isPreloading )
		{
			buttonText = "#PENDING_PLAYER_STATUS_PRELOADING"
		}
		else
		{
			if ( isControllerModeActive )
				buttonText = file.isReady ? "#B_BUTTON_CANCEL" : "#Y_BUTTON_READY"
			else
				buttonText = "#READY"
		}
		HudElem_SetRuiArg( file.readyLaunchButton, "buttonText", Localize( buttonText ) )
		HudElem_SetRuiArg( file.readyLaunchButton, "buttonDescText", "" )
	}
}

void function FocusChat_OnActivate( var button )
{
	Hud_SetFocused( file.chatInputLine )
}

void function RegisterInputs()
{
	if ( file.inputsRegistered )
		return

	RegisterButtonPressedCallback( BUTTON_START, GameMenuButton_OnActivate )
	RegisterButtonPressedCallback( BUTTON_BACK, PrivateMatchPostGameButton_OnActivate )
	RegisterButtonPressedCallback( BUTTON_Y, ReadyLaunchButton_OnActivate )
	#if PC_PROG
		RegisterButtonPressedCallback( BUTTON_TRIGGER_RIGHT_FULL, FocusChat_OnActivate )
	#else
		RegisterButtonPressedCallback( BUTTON_TRIGGER_RIGHT_FULL, EnterText_OnActivate )
	#endif
	RegisterButtonPressedCallback( KEY_ENTER, FocusChat_OnActivate )
	                                                                     
	                                                                              
	                                                                              
	file.inputsRegistered = true
}


void function DeregisterInputs()
{
	if ( !file.inputsRegistered )
		return

	DeregisterButtonPressedCallback( BUTTON_START, GameMenuButton_OnActivate )
	DeregisterButtonPressedCallback( BUTTON_BACK, PrivateMatchPostGameButton_OnActivate )
	DeregisterButtonPressedCallback( BUTTON_Y, ReadyLaunchButton_OnActivate )
	#if PC_PROG
		DeregisterButtonPressedCallback( BUTTON_TRIGGER_RIGHT_FULL, FocusChat_OnActivate )
	#else
		DeregisterButtonPressedCallback( BUTTON_TRIGGER_RIGHT_FULL, EnterText_OnActivate )
	#endif
	DeregisterButtonPressedCallback( KEY_ENTER, FocusChat_OnActivate )
	                                                                       
	                                                                                
	                                                                                
	file.inputsRegistered = false
}


void function EnterText_OnActivate( var button )
{
	if ( !HudChat_HasAnyMessageModeStoppedRecently() && Hud_IsVisible( file.textChat ) )
		Hud_StartMessageMode( file.textChat )
}

void function PrivateMatch_SetLobbyChatVisible( bool visible )
{
	Hud_SetEnabled( file.textChat, visible )
	Hud_SetVisible( file.textChat, visible )


	Hud_SetEnabled( file.chatButtonIcon, visible )
	Hud_SetVisible( file.chatButtonIcon, visible )

	Hud_SetEnabled( file.chatInputLine, visible )
	Hud_SetVisible( file.chatInputLine, visible )

	SetChatTextBoxVisible( visible )
}

void function ReadyLaunchButton_OnActivate( var button )
{
	                                                                                                          
	if ( button == null && file.isStarting )
		return

	if ( HasMatchAdminRole() )
	{
		if ( file.isStarting )
			Remote_ServerCallFunction( "ClientCallback_PrivateMatchSetStartMatch", false )
		else
			RunClientScript( "PrivateMatch_BeginStartMatch" )
	}
	else
	{
		file.isReady = !file.isReady
		Remote_ServerCallFunction( "ClientCallback_PrivateMatchSetReady", file.isReady )
		UpdateReadyButtonText( IsControllerModeActive() )
	}
}

void function UICodeCallback_PrivateMatchPreloadChanged( bool isPreloading )
{
	file.isPreloading = isPreloading
	UpdateReadyButtonText( IsControllerModeActive() )

	if ( IsPrivateMatchLobby() && CanRunClientScript() )
		Remote_ServerCallFunction( "ClientCallback_PrivateMatchSetPreloading", isPreloading )
}


void function ModeSelectButton_OnActivate( var button )
{
	if ( !HasMatchAdminRole() )
		return

	AdvanceMenu( GetMenu( "PrivateMatchGamemodeSelectDialog" ) )
}

void function TeamSwapButton_OnActivate( var button )
{
	if ( !HasMatchAdminRole() )
		return

	Remote_ServerCallFunction( "ClientCallback_PrivateMatchToggleAssignSelf" )
}


void function TeamRenameButton_OnActivate( var button )
{
	if ( !HasMatchAdminRole() )
		return

	Remote_ServerCallFunction( "ClientCallback_PrivateMatchToggleTeamRenaming" )
}

void function AdminOnlyButton_OnActivate( var button )
{
	if ( !HasMatchAdminRole() )
		return
	
	Remote_ServerCallFunction( "ClientCallback_PrivateMatchToggleAdminOnlyChat" )
}

void function AimAssistButton_OnActivate( var button )
{
	if ( !HasMatchAdminRole() )
		return

	Remote_ServerCallFunction( "ClientCallback_PrivateMatchToggleAimAssist" )
}

void function AnonymousModeButton_OnActivate( var button )
{
	if ( !HasMatchAdminRole() )
		return

	Remote_ServerCallFunction( "ClientCallback_PrivateMatchToggleAnonymousMode" )
}

void function AnonymousMode_OnChange( bool oldValue, bool newValue )
{
	ToolTipData anonymousModeToolTip
	anonymousModeToolTip.descText = newValue ? "#TOURNAMENT_ANONYMOUS_MODE_ON" : "#TOURNAMENT_ANONYMOUS_MODE_OFF"
	Hud_SetToolTipData( file.anonymousModeButton, anonymousModeToolTip )
}

void function SetChatTextBoxVisible( bool visible )
{
	Hud_SetVisible( Hud_GetChild( file.chatInputLine, "ChatInputPrompt" ), visible )
	Hud_SetVisible( Hud_GetChild( file.chatInputLine, "ChatInputTextEntry" ), visible )

	var chatHistory = Hud_GetChild( file.textChat, "HudChatHistory" )
	Hud_SetVisible( chatHistory, visible )
	if ( visible )
	{
		Hud_SetHeight( chatHistory, 45 )
	}
	else
	{
		Hud_SetHeight( chatHistory, 65 )
	}
}


void function PrivateMatchPostGameButton_OnActivate( var button )
{
	if ( IsDialog( GetActiveMenu() ) )
		return

	                              
	   
	  	                                 
	   

	thread PrivateMatchPostGameFlow()
}


void function OnPrivateMatchLobbyMenu_NavigateBack()
{
	if ( IsControllerModeActive() )
	{
		if ( HasMatchAdminRole() )
		{
			Remote_ServerCallFunction( "ClientCallback_PrivateMatchSetStartMatch", false )
		}
		else
		{
			file.isReady = false
			Remote_ServerCallFunction( "ClientCallback_PrivateMatchSetReady", false )
			UpdateReadyButtonText( IsControllerModeActive() )
		}
	}
	else
		AdvanceMenu( GetMenu( "SystemMenu" ) )
}


void function GameMenuButton_OnActivate( var button )
{
	if ( InputIsButtonDown( BUTTON_STICK_LEFT ) )                             
		return

	if ( IsDialog( GetActiveMenu() ) )
		return

	AdvanceMenu( GetMenu( "SystemMenu" ) )
}


void function PrivateMatchPostGameFlow()
{
	OpenPrivateMatchPostGameMenu( null )
}

#if CLIENT
void function ServerCallback_UpdateModeButton( string modeName )
{
	string mode = modeName != "" ? modeName : "#PL_TOURNAMENT"
	HudElem_SetRuiArg( file.modeButton, "name", mode )
}
#endif