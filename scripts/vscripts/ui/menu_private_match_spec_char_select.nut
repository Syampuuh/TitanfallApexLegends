global function InitPrivateMatchSpectCharSelectMenu

#if UI
global function EnablePrivateMatchSpectCharSelectMenu
global function IsPrivateMatchSpectCharSelectMenuOpen
global function OpenPrivateMatchSpectCharSelectMenu
global function ClosePrivateMatchSpectCharSelectMenu
#endif

#if CLIENT
global function PrivateMatch_PopulateSpectCharSelectMenu
global function PrivateMatch_SpectCharSelect_ConfigurePlayerButton
#endif

struct TeamRosterStruct
{
	var           headerPanel
	var           listPanel
	int           teamIndex
	int			  teamPlacement
	int           teamDisplayNumber
}

struct
{
	var 		menu

	var 		decorationRui
	var 		menuHeaderRui

	bool 		enableMenu = false
	bool 		disableNavigateBack = false

	var 		countdownRui
	var			whiteFlash
	array<var>  progressBarRuis

	int 		lockStepIndex = -2
	int			maxTeamSize = 0
	table< int, TeamRosterStruct > teamRosters

	bool 		isInitialized = false
	bool		isButtonMappped = false

	table< entity, var > buttonPlayerMap

} file

void function InitPrivateMatchSpectCharSelectMenu( var newMenuArg )
{
	file.menu = newMenuArg

	file.whiteFlash = Hud_GetChild( newMenuArg, "WhiteFlash" )

	#if UI
		file.menuHeaderRui = Hud_GetRui( Hud_GetChild( newMenuArg, "MenuHeader" ) )

		RuiSetString( file.menuHeaderRui, "menuName", "#TOURNAMENT_SPECTATOR_CHARACTER_SELECTION" )

		AddMenuEventHandler( newMenuArg, eUIEvent.MENU_OPEN, OnOpenPrivateMatchSpectCharSelectMenu )
		AddMenuEventHandler( newMenuArg, eUIEvent.MENU_SHOW, OnShowPrivateMatchSpectCharSelectMenu )
		AddMenuEventHandler( newMenuArg, eUIEvent.MENU_HIDE, OnHidePrivateMatchSpectCharSelectMenu )
		AddMenuEventHandler( newMenuArg, eUIEvent.MENU_CLOSE, OnClosePrivateMatchSpectCharSelectMenu )
		AddUICallback_OnLevelInit( void function() : ( newMenuArg )
		{
			Assert( CanRunClientScript() )
			RunClientScript( "InitPrivateMatchSpectCharSelectMenu", newMenuArg )
		} )

	#elseif CLIENT
		int maxTeams = PrivateMatch_GetMaxTeamsForSelectedGamemode()
		const int MAX_TEAM_HEADERS = 20
		for ( int index; index < MAX_TEAM_HEADERS; index++ )
		{
			string team          = "Team"
			string indexName     = index < 10 ? "0" + string( index ) : string( index )
			string teamIndexName = team + indexName
			var teamPanel = Hud_GetChild( newMenuArg, teamIndexName )

			if ( index < maxTeams )
			{
				file.teamRosters[TEAM_MULTITEAM_FIRST + index] <- CreateTeamPlacement( TEAM_MULTITEAM_FIRST + index, teamPanel )
				Hud_Show( teamPanel )
			}
			else
			{
				Hud_Hide( teamPanel )
			}
		}

		if ( !file.isInitialized )
		{
			AddCallback_OnPlayerMatchStateChanged( OnPlayerMatchStateChanged )
			AddCallback_GameStateEnter( eGameState.PickLoadout, OnGameStateEnter_PickLoadout )
			AddCallback_ItemFlavorLoadoutSlotDidChange_AnyPlayer( Loadout_Character(), PrivateMatch_OnPlayerChangedCharacterClass )
		}

	#endif

	file.isInitialized = true
}

#if CLIENT

void function PrivateMatch_OnPlayerChangedCharacterClass( EHI playerEHI, ItemFlavor character )
{
	if ( file.enableMenu == false )
		return

	entity player = FromEHI( playerEHI )
	if ( player == null || !IsValid( player ) )
		return

	if( player in file.buttonPlayerMap )
		PrivateMatch_SpectCharSelect_ConfigurePlayerButton( file.buttonPlayerMap[player], player )
}

void function SpecOnLockStepPickIndexChanged()
{
	if ( file.enableMenu == false )
		return

	array<entity> players = GetPlayerArray()
	if ( players.len() == 0 )
		return

	foreach( player in players )
	{
		if( player in file.buttonPlayerMap )
			PrivateMatch_SpectCharSelect_ConfigurePlayerButton( file.buttonPlayerMap[player], player )
	}

	UpdateFooterRui()
}

TeamRosterStruct function CreateTeamPlacement( int teamIndex, var panel )
{
	TeamRosterStruct teamPlacement
	teamPlacement.teamIndex = teamIndex
	teamPlacement.teamDisplayNumber = teamIndex - 1

	teamPlacement.headerPanel = Hud_GetChild( panel, PRIVATE_MATCH_TEAM_HEADER_PANEL )
	teamPlacement.listPanel = Hud_GetChild( panel, PRIVATE_MATCH_TEAM_BUTTON_PANEL )

	return teamPlacement
}

void function PrivateMatch_PopulateSpectCharSelectMenu( var menu )
{
	FooterRui()
	                                                  
	thread OnPrivateMatchSpectCharSelectMenuThink()
}

void function PrivateMatch_SpectCharSelect_TeamRoster_Configure( TeamRosterStruct teamRoster, string teamName )
{
	var buttonPanel = teamRoster.listPanel

	HudElem_SetRuiArg( teamRoster.headerPanel, "teamName", teamName )
	HudElem_SetRuiArg( teamRoster.headerPanel, "teamNumber", teamRoster.teamDisplayNumber )

	Hud_InitGridButtons( buttonPanel, MAX_TEAM_PLAYERS )
	var scrollPanel = Hud_GetChild( buttonPanel, "ScrollPanel" )
	for ( int i = 0; i < MAX_TEAM_PLAYERS; i++ )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + i )
		HudElem_SetRuiArg( button, "buttonText", "" )
		HudElem_SetRuiArg( button, "playerPortrait", "white" )
		HudElem_SetRuiArg( button, "portraitText", "-" )
	}
}

int function SortPlayers( entity a, entity b )
{
	int aStepIndex = a.GetPlayerNetInt( CHARACTER_SELECT_NETVAR_LOCK_STEP_PLAYER_INDEX )
	int bStepIndex = b.GetPlayerNetInt( CHARACTER_SELECT_NETVAR_LOCK_STEP_PLAYER_INDEX )

	if ( aStepIndex > bStepIndex )
		return 1

	if ( aStepIndex < bStepIndex )
		return -1

	return 0
}

void function PrivateMatch_SpectCharSelect_TeamRoster_Update()
{
	if ( file.teamRosters.len() == 0 )
		return

	array<entity> allPlayers = GetPlayerArray()
	if ( allPlayers.len() == 0 )
		return

	table< int, array<entity> > teamPlayersMap
	foreach( player in allPlayers )
	{
		int teamIndex = player.GetTeam()

		if ( !(teamIndex in teamPlayersMap) )
		{
			teamPlayersMap[teamIndex] <- []
		}

		teamPlayersMap[teamIndex].append( player )
	}

	foreach ( teamIndex, teamRoster in file.teamRosters )
	{
		array<entity> players
		if ( teamIndex in teamPlayersMap )
		{
			players = teamPlayersMap[teamIndex]

			if( players.len()  > file.maxTeamSize )
			{
				file.maxTeamSize = players.len()
			}
		}

		players.sort( SortPlayers )

		string teamName = PrivateMatch_GetTeamName( teamRoster.teamIndex )

		PrivateMatch_SpectCharSelect_TeamRoster_Configure( teamRoster, teamName )

		HudElem_SetRuiArg( teamRoster.headerPanel, "teamName", teamName )
		HudElem_SetRuiArg( teamRoster.headerPanel, "teamNumber", teamRoster.teamDisplayNumber )

		var scrollPanel = Hud_GetChild( teamRoster.listPanel, "ScrollPanel" )
		Assert( players.len() <= MAX_TEAM_PLAYERS )
		for ( int playerIndex = 0; playerIndex < MAX_TEAM_PLAYERS; playerIndex++ )
		{
			var button = Hud_GetChild( scrollPanel, ("GridButton" + playerIndex) )
			if ( playerIndex < players.len() )
			{
				file.buttonPlayerMap[ players[playerIndex] ] <- button
				PrivateMatch_SpectCharSelect_ConfigurePlayerButton( button, players[playerIndex] )
			}
			else
			{
				HudElem_SetRuiArg( button, "buttonText", "" )
			}
		}
	}
}

void function PrivateMatch_SpectCharSelect_ConfigurePlayerButton( var button, entity player )
{
	if ( !IsValid( player ) || player == null )
		return

	if ( !IsValid( button ) || button == null )
		return

	var buttonRui = Hud_GetRui( button )

	string playerName = ""
	playerName = player.GetPlayerNameWithClanTag()
	RuiSetString( buttonRui, "buttonText", playerName )

	asset characterPortrait = $"white"
	bool loadoutReady = LoadoutSlot_IsReady( ToEHI( player ), Loadout_Character() )
	if ( loadoutReady && player.GetPlayerNetBool( CHARACTER_SELECT_NETVAR_HAS_LOCKED_IN_CHARACTER ) )
	{
		ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_Character() )
		characterPortrait = CharacterClass_GetCharacterLockedPortrait( character )
		if ( characterPortrait == $"" )
			characterPortrait = CharacterClass_GetCharacterSelectPortrait( character )
		RuiSetImage( buttonRui, "playerPortrait", characterPortrait )
		RuiSetString( buttonRui, "portraitText", "" )
		return
	}

	int lockStepIndex = GetGlobalNetInt( CHARACTER_SELECT_NETVAR_LOCK_STEP_INDEX )
	int playerLockStepIndex = player.GetPlayerNetInt( CHARACTER_SELECT_NETVAR_LOCK_STEP_PLAYER_INDEX )

	if ( lockStepIndex > -1 )
	{
		if( lockStepIndex == playerLockStepIndex )
		{
			RuiSetString( buttonRui, "portraitText", "?" )
			return
		}
		else if ( loadoutReady && lockStepIndex > playerLockStepIndex )
		{
			ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_Character() )
			characterPortrait = CharacterClass_GetGalleryPortrait( character )
			RuiSetImage( buttonRui, "playerPortrait", characterPortrait )
			RuiSetString( buttonRui, "portraitText", "" )
			return
		}

	}

	RuiSetString( buttonRui, "portraitText", "-" )
}

void function OnGameStateEnter_PickLoadout()
{
	thread TryEnablePrivateMatchSpectCharSelectMenu( GetLocalClientPlayer() )
}

void function OnPlayerMatchStateChanged( entity player, int newState )
{
	if ( player.GetTeam() != TEAM_SPECTATOR )
		return

	if ( newState == ePlayerMatchState.STAGING_AREA && file.enableMenu == false )
	{
		RunUIScript( "EnablePrivateMatchSpectCharSelectMenu", true )
		file.enableMenu = true
	}

	if ( newState > ePlayerMatchState.STAGING_AREA && file.enableMenu )
	{
		DisablePrivateMatchSpectCharSelectMenu()
	}
}

void function DisablePrivateMatchSpectCharSelectMenu()
{
	file.enableMenu = false

	RunUIScript( "ClosePrivateMatchSpectCharSelectMenu" )

	if ( file.countdownRui != null )
	{
		RuiDestroyIfAlive( file.countdownRui )
		file.countdownRui = null
	}

	                  
	foreach( var rui in file.progressBarRuis )
		RuiDestroyIfAlive( rui )
	file.progressBarRuis = []
}

void function TryEnablePrivateMatchSpectCharSelectMenu( entity player )
{
	FlagWait( "ClientInitComplete" )

	if ( !IsPrivateMatch() )
		return

	if ( PlayerMatchState_GetFor( GetLocalClientPlayer() ) == ePlayerMatchState.STAGING_AREA )
		return

	if ( player.GetTeam() != TEAM_SPECTATOR )
		return

	if ( file.enableMenu == true )
		return

	Chroma_BeginCharacterSelect()

	while( GetGlobalNetBool( "characterSelectionReady" ) == false )
		WaitFrame()

	RunUIScript( "EnablePrivateMatchSpectCharSelectMenu", true )
	file.enableMenu = true
	PrivateMatch_PopulateSpectCharSelectMenu( file.menu )

	thread FlashScreenWhite()

	float gameStartTime = GetGlobalNetTime( "pickLoadoutGamestateEndTime" )
	thread CloseCharacterSelectMenuAtTime( gameStartTime )

	while( Time() < GetGlobalNetTime( "championSquadPresentationStartTime" ) )
		WaitFrame()

	DisablePrivateMatchSpectCharSelectMenu()

	if ( GetCurrentPlaylistVarInt( "survival_enable_gladiator_intros", 1 ) == 1 )
		thread DoChampionSquadCardsPresentation("pickLoadoutGamestateEndTime")
}

void function FlashScreenWhite( float holdTime = 0.5, float fadeOutDuration = 1.5 )
{
	if ( !IsValid( file.whiteFlash ) )
		return

	OnThreadEnd(
		void function() : ()
		{
			if ( !IsValid( file.whiteFlash ) )
				return

			Hud_Hide( file.whiteFlash )
		}
	)

	Hud_SetEnabled( file.whiteFlash, false )
	Hud_SetAlpha( file.whiteFlash, 255 )
	Hud_Show( file.whiteFlash )

	wait holdTime

	if ( !IsValid( file.whiteFlash ) )
		return

	Hud_FadeOverTime( file.whiteFlash, 0, fadeOutDuration )

	wait fadeOutDuration
}

void function CloseCharacterSelectMenuAtTime( float closeTimeStamp )
{
	while ( Time() < closeTimeStamp - SCREEN_COVER_TRANSITION_OUT_DURATION - 0.1 )
		WaitFrame()

	waitthread ScreenCoverTransition( Time() + CharSelect_GetOutroTransitionDuration() )

	FlashGameWindow()
}

void function OnPrivateMatchSpectCharSelectMenuThink()
{
	file.lockStepIndex = GetGlobalNetInt( CHARACTER_SELECT_NETVAR_LOCK_STEP_INDEX )

	while ( true )
	{
		if ( GetGlobalNetInt( CHARACTER_SELECT_NETVAR_LOCK_STEP_INDEX ) != file.lockStepIndex )
		{
			if( file.isButtonMappped == false )
			{
				file.isButtonMappped = true
				PrivateMatch_SpectCharSelect_TeamRoster_Update()
			}

			file.lockStepIndex = GetGlobalNetInt( CHARACTER_SELECT_NETVAR_LOCK_STEP_INDEX )
			SpecOnLockStepPickIndexChanged()
		}

		if( !file.enableMenu )
			return

		WaitFrame()
	}
}

void function UpdateFooterRui()
{
	for ( int i = 0 ; i < file.progressBarRuis.len() ; i++ )
	{
		var rui = file.progressBarRuis[i]

		RuiSetInt( rui, "numPlayers", file.maxTeamSize )
		RuiSetGameTime( rui, "countdownEndTime", GetGlobalNetTime( "pickLoadoutGamestateStartTime" ) )

		if ( i == file.lockStepIndex )
		{
			RuiSetGameTime( rui, "selectingStartTime" , GetGlobalNetTime( CHARACTER_SELECT_NETVAR_LOCK_STEP_START_TIME ) )
			RuiSetGameTime( rui, "selectingEndTime", GetGlobalNetTime( CHARACTER_SELECT_NETVAR_LOCK_STEP_END_TIME ) )
		}
		else if ( i < file.lockStepIndex )
		{
			RuiSetGameTime( rui, "selectingStartTime", 0.0 )
			RuiSetGameTime( rui, "selectingEndTime", 0.0 )
		}
	}
}

void function FooterRui()
{
	if( file.progressBarRuis.len() > 0 )
		return

	float startTime = Time()

	for ( int i = 0 ; i < MAX_TEAM_PLAYERS ; i++ )
	{
		var rui = CreateFullscreenRui( $"ui/private_match_character_select_progress_bar.rpak", 300 )

		UISize screenSize = GetScreenSize()
		float aspectRatio = float( screenSize.width ) / float( screenSize.height )
		RuiSetResolution( rui, 1080.0 * aspectRatio, 1080.0 )

		RuiSetInt( rui, "playerIndex", i )

		UISize virtualSize = GetScreenSize()                                      
		RuiSetFloat2( rui, "virtualRes", <1080.0 * aspectRatio, 1080.0, 0> )
		
		file.progressBarRuis.append( rui )
	}
}

#endif         


#if UI
void function OnOpenPrivateMatchSpectCharSelectMenu()
{
	if ( !IsFullyConnected() )
	{
		CloseActiveMenu()
		return
	}
	
	RunClientScript( "PrivateMatch_PopulateSpectCharSelectMenu", file.menu )
}


void function OnShowPrivateMatchSpectCharSelectMenu()
{
	SetMenuReceivesCommands( file.menu, PROTO_Survival_DoInventoryMenusUseCommands() && !IsControllerModeActive() )
}

void function OnHidePrivateMatchSpectCharSelectMenu()
{
	                                             
}


void function OnClosePrivateMatchSpectCharSelectMenu()
{
}


void function EnablePrivateMatchSpectCharSelectMenu( bool doEnable )
{
	file.enableMenu = doEnable
	if ( file.enableMenu == true )
	{
		AdvanceMenu( file.menu )
	}
}


bool function IsPrivateMatchSpectCharSelectMenuOpen()
{
	return GetActiveMenu() == file.menu
}

void function OpenPrivateMatchSpectCharSelectMenu( var button )
{
	if ( !IsPrivateMatch() )
		return

	if ( file.enableMenu == false )
		return

	CloseAllMenus()
	AdvanceMenu( file.menu )
}

void function ClosePrivateMatchSpectCharSelectMenu()
{
	if ( GetActiveMenu() == file.menu )
		thread CloseActiveMenu()
}
#endif     

