global function InitPrivateMatchGameStatusMenu

#if UI
global function EnablePrivateMatchGameStatusMenu
global function IsPrivateMatchGameStatusMenuOpen
global function TogglePrivateMatchGameStatusMenu
global function OpenPrivateMatchGameStatusMenu
global function ClosePrivateMatchGameStatusMenu
global function SetChatModeButtonText
global function SetSpecatorChatModeState
global function SetChatTargetText
global function InitPrivateMatchRosterPanel
global function InitPrivateMatchSummaryPanel
global function InitPrivateMatchOverviewPanel
global function InitPrivateMatchAdminPanel
global function OnPrivateMatchStateChange
#endif

#if CLIENT
global function ServerCallback_PrivateMatch_OnEntityKilled
global function PrivateMatch_PopulateGameStatusMenu
global function PrivateMatch_GameStatus_GetPlayerButton
global function PrivateMatch_UpdateChatTarget
global function PrivateMatch_CycleAdminChatMode
global function PrivateMatch_ToggleAdminSpectatorChat
global function PrivateMatch_ToggleUpdatePlayerConnections
global function PrivateMatch_SquadEliminated
global function ClientCodeCallback_SpectatorGetOrderedTarget
#endif

const int TEAM_COUNT_PANEL_ONE 		= 2
const int TEAM_COUNT_PANEL_TWO 		= 7
const int TEAM_COUNT_PANEL_THREE 	= 11

const int MAX_TEAM_SIZE = 3
const int ROSTER_LIST_SIZE = 20                                                                                 

enum ePlayerHealthStatus
{
	PM_PLAYERSTATE_ALIVE,
	PM_PLAYERSTATE_BLEEDOUT,
	PM_PLAYERSTATE_DEAD,
	PM_PLAYERSTATE_REVIVING,
	PM_PLAYERSTATE_ELIMINATED,

	_count
}

enum eGameStatusPanel
{
	PM_GAMEPANEL_ROSTER,
	PM_GAMEPANEL_INGAME_SUMMARY,
	PM_GAMEPANEL_POSTGAME_SUMMARY,
	PM_GAMEPANEL_ADMIN,

	__count
}

struct TeamRosterStruct
{
	var           headerPanel
	var           listPanel
	table< var, int > connectionMap
	table< var, entity > buttonPlayerMap
}

struct TeamDetailsData
{
	int teamIndex
	int teamValue
	int teamKills
	int teamPlacement
	int playerAlive
	string teamName
}

struct PlayerData
{
	entity playerEntity
	asset characterPortrait 	= $"white"
	string playerName 			= ""
	int killCount 				= 0
}

struct TeamData
{
	array<PlayerData> players
	int placement = 0
}

struct AdminConfigData
{
	int chatMode
	bool spectatorChat
}

struct
{
	var menu

	var decorationRui
	var menuHeaderRui

	var teamRosterPanel
	var postGameSummaryPanel
	var inGameSummaryPanel
	var adminPanel

	var textChat
	var chatInputLine
	var chatButtonIcon

	var endMatchButton
	var chatModeButton
	var chatSpectCheckBox
	var chatTargetText

	bool enableMenu = false
	bool disableNavigateBack = false

	array< TeamRosterStruct > teamRosters
	array< int > teamIndices
	int lastPlayerCount = 0
	array< var > teamOverviewPanels

	int displayDirtyBit = 0
	table< int, TeamData > teamData
	table< string, PlayerData > playerData

	bool isInitialized = false
	bool tabsInitialized = false
	bool updateConnections = false

	bool inputsRegistered = false

	int maxTeamSize = MAX_TEAM_SIZE
	int overviewSizeTotal = 0

	AdminConfigData adminConfig
} file

void function InitPrivateMatchGameStatusMenu( var menu )
{
	file.menu = menu
	file.teamRosterPanel = Hud_GetChild( menu, "PrivateMatchRosterPanel" )
	file.inGameSummaryPanel = Hud_GetChild( menu, "PrivateMatchOverviewPanel" )
	file.postGameSummaryPanel = Hud_GetChild( menu, "PrivateMatchSummaryPanel" )
	file.adminPanel = Hud_GetChild( menu, "PrivateMatchAdminPanel" )

	#if UI
		file.menuHeaderRui = Hud_GetRui( Hud_GetChild( menu, "MenuHeader" ) )
		RuiSetString( file.menuHeaderRui, "menuName", "#TOURNAMENT_MATCH_STATUS" )

		AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenPrivateMatchGameStatusMenu )
		AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnShowPrivateMatchGameStatusMenu )
		AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, OnHidePrivateMatchGameStatusMenu )
		AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnClosePrivateMatchGameStatusMenu )
		AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnNavigateBack )

		AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE", null, CanNavigateBack )
		AddMenuFooterOption( menu, LEFT, BUTTON_BACK, true, "", "", ClosePrivateMatchGameStatusMenu, CanNavigateBack )

		AddCommandForMenuToPassThrough( menu, "toggle_inventory" )
		
		AddUICallback_OnLevelInit( void function() : ( menu )
		{
			Assert( CanRunClientScript() )
			RunClientScript( "InitPrivateMatchGameStatusMenu", menu )
		} )
		
		HudElem_SetChildRuiArg( Hud_GetChild( menu, "TabsCommon" ), "Background", "bgColor", <0, 0, 1>, eRuiArgType.VECTOR )
		HudElem_SetChildRuiArg( Hud_GetChild( menu, "TabsCommon" ), "Background", "bgAlpha", 1.6, eRuiArgType.FLOAT )

		SetTabRightSound( menu, "UI_InGame_InventoryTab_Select" )
		SetTabLeftSound( menu, "UI_InGame_InventoryTab_Select" )

		file.isInitialized = true
	#elseif CLIENT

		file.teamRosters.clear()
		int maxTeams = PrivateMatch_GetMaxTeamsForSelectedGamemode()
		for ( int index; index < ROSTER_LIST_SIZE; index++ )
		{
			string team          = "Team"
			string indexName     = index < 10 ? "0" + string( index ) : string( index )
			string teamIndexName = team + indexName
			var teamPanel = Hud_GetChild( file.teamRosterPanel, teamIndexName )

			if( index < maxTeams )
			{
				file.teamRosters.append( CreateTeamPlacement( teamPanel ) )
			}
			else
			{
				Hud_Hide( Hud_GetChild( teamPanel , PRIVATE_MATCH_TEAM_HEADER_PANEL ) )
				Hud_Hide( Hud_GetChild( teamPanel , PRIVATE_MATCH_TEAM_BUTTON_PANEL ) )
			}
		}

		if ( IsPrivateMatch() || IsPrivateMatchLobby() )
		{
			file.teamOverviewPanels.clear()

			file.overviewSizeTotal = 0
			SetupOverviewPanel( 1, TEAM_COUNT_PANEL_ONE, maxTeams )
			SetupOverviewPanel( 2, TEAM_COUNT_PANEL_TWO, maxTeams )
			SetupOverviewPanel( 3, TEAM_COUNT_PANEL_THREE, maxTeams )

			                                                                            
			if( GetGameState() >= eGameState.Playing )
			{
				RunUIScript( "EnablePrivateMatchGameStatusMenu", file.enableMenu )
			}

			if ( GetLocalClientPlayer().HasMatchAdminRole() )
			{
				file.adminConfig.chatMode = ACM_ALL_PLAYERS
				file.adminConfig.spectatorChat = true

				SwitchChatModeButtonText( ACM_ALL_PLAYERS )
				RunUIScript( "SetSpecatorChatModeState", true, true )

				                                             
				Remote_ServerCallFunction( "ClientCallback_PrivateMatchSetAdminConfig", file.adminConfig.chatMode, file.adminConfig.spectatorChat )
			}

			if ( !file.isInitialized )
			{
				AddOnSpectatorTargetChangedCallback( OnSpectateTargetChanged )

				AddCallback_OnPlayerMatchStateChanged( OnPlayerMatchStateChanged )

				                                                 
				AddCallback_GameStateEnter( eGameState.Playing, OnGameStateEnter_Playing )
				AddCallback_GameStateEnter( eGameState.WinnerDetermined, OnGameStateEnter_WinnerDetermined )
				SwitchChatModeButtonText( file.adminConfig.chatMode )

				PrivateMatch_RestoreDefaultPanels()                                  
				PrivateMatch_ClearTeamPresence()

				file.isInitialized = true
			}
		}
	#endif
}

#if UI
void function InitPrivateMatchRosterPanel( var panel )
{
}

void function RegisterInputs()
{
	if( file.inputsRegistered )
		return

	#if PC_PROG
	RegisterButtonPressedCallback( BUTTON_TRIGGER_RIGHT_FULL, FocusChat_OnActivate )
	#else
	RegisterButtonPressedCallback( BUTTON_TRIGGER_RIGHT_FULL, EnterText_OnActivate )
	#endif

	file.inputsRegistered = true
}

void function DeRegisterInputs()
{
	if ( !file.inputsRegistered )
		return

	#if PC_PROG
		DeregisterButtonPressedCallback( BUTTON_TRIGGER_RIGHT_FULL, FocusChat_OnActivate )
	#else
		DeregisterButtonPressedCallback( BUTTON_TRIGGER_RIGHT_FULL, EnterText_OnActivate )
	#endif

	file.inputsRegistered = false
}

void function FocusChat_OnActivate( var button )
{
	Hud_SetFocused( file.chatInputLine )
}

void function EnterText_OnActivate( var button )
{
	if ( !HudChat_HasAnyMessageModeStoppedRecently() && Hud_IsVisible( file.textChat ) )
		Hud_StartMessageMode( file.textChat )
}

void function EndMatchButton_OnActivate( var button )
{
	if ( IsDialog( GetActiveMenu() ) )
		return

	ConfirmDialogData data
	data.headerText = "#TOURNAMENT_END_MATCH_DIALOG_HEADER"
	data.messageText = "#TOURNAMENT_END_MATCH_DIALOG_MSG" 
	data.resultCallback = void function( int dialogResult ) 
	{
		if ( dialogResult == eDialogResult.YES )
		{
			ClosePrivateMatchGameStatusMenu( null )
			if ( HasMatchAdminRole() )
			{
				Remote_ServerCallFunction( "ClientCallback_PrivateMatchEndMatchEarly" )
			}
		}
	}

	OpenConfirmDialogFromData( data )
}

void function InitPrivateMatchSummaryPanel( var panel )
{
	var teamOneHeaderRui = Hud_GetRui( Hud_GetChild( panel, "TeamOverviewHeader01" ) )
	RuiSetString( teamOneHeaderRui, "kills", Localize( "#TOURNAMENT_SPECTATOR_TEAM_KILLS" ) )
	RuiSetString( teamOneHeaderRui, "teamName", Localize( "#TOURNAMENT_SPECTATOR_TEAM_NAME" ) )
	RuiSetString( teamOneHeaderRui, "playersAlive", Localize( "#TOURNAMENT_SPECTATOR_PLAYERS_ALIVE" ) )
}

void function InitHeaderTitle( var panel, string headerName, string headerTitle, vector headerColor )
{
	var headerRui = Hud_GetRui( Hud_GetChild( panel, headerName ) )
	RuiSetString( headerRui, "title", Localize( headerTitle ) )
	RuiSetColorAlpha( headerRui, "backgroundColor", SrgbToLinear( headerColor ), 1.0 )
}

void function InitPrivateMatchOverviewPanel( var panel )
{
	InitHeaderTitle( panel, "AliveSquadsHeader", Localize( "#TOURNAMENT_SPECTATOR_ALIVE_TEAMS_HEADER" ), <36, 36, 36> / 255.0 )
	InitHeaderTitle( panel, "EliminatedSquadsHeader", Localize( "#TOURNAMENT_SPECTATOR_DEAD_TEAMS_HEADER" ), <121, 25, 26 > / 255.0 )

	var overviewGrid = Hud_GetChild( panel, "TeamOverview" )
	Hud_InitGridButtons( overviewGrid, 22 )

	                                                                       
	var scrollPanel = Hud_GetChild( overviewGrid, "ScrollPanel" )
	Hud_Hide( Hud_GetChild( scrollPanel, "GridButton0" ) )
}

void function InitPrivateMatchAdminPanel( var panel )
{
	AddUICallback_InputModeChanged( ControllerIconVisibilty )

	file.endMatchButton = Hud_GetChild( panel, "EndMatchButton" )
	HudElem_SetRuiArg( file.endMatchButton, "buttonText", Localize( "#TOURNAMENT_END_MATCH" ) )
	Hud_AddEventHandler( file.endMatchButton, UIE_CLICK, EndMatchButton_OnActivate )

	file.textChat = Hud_GetChild( panel, "AdminChatWindow" )
	file.chatInputLine = Hud_GetChild( file.textChat, "ChatInputLine" )

	file.chatButtonIcon = Hud_GetChild( panel, "AdminChatBoxIcon")

	file.chatModeButton = Hud_GetChild( panel, "AdminChatModeButton" )
	Hud_AddEventHandler( file.chatModeButton, UIE_CLICK, ChatModeButton_OnActivate )

	file.chatSpectCheckBox = Hud_GetChild( panel, "SpectatorChatCheckBox" )
	Hud_AddEventHandler( file.chatSpectCheckBox, UIE_CLICK, ChatSpectatorCheckBox_OnActivate )

	file.chatTargetText = Hud_GetChild( panel, "AdminChatTarget" )
}

void function SetChatModeButtonText( string newText )
{
	ToolTipData adminChatModeTooltip
	adminChatModeTooltip.descText = newText
	HudElem_SetRuiArg( file.chatModeButton, "buttonText", newText )
}


void function SetSpecatorChatModeState( bool isActive, bool isSelected )
{
	HudElem_SetRuiArg( file.chatSpectCheckBox, "isActive", isActive )
	HudElem_SetRuiArg( file.chatSpectCheckBox, "isSelected", isSelected )
}

void function SetChatTargetText( string target )
{
	if ( target != "" )
	{
		HudElem_SetRuiArg( file.chatTargetText, "targetText", Localize("#TOURNAMENT_SPECTATOR_CHAT_TARGET" ) + target )
	}
	else
	{
		HudElem_SetRuiArg( file.chatTargetText, "targetText", "" )
	}
}

void function ControllerIconVisibilty( bool controllerModeActive )
{
	Hud_SetEnabled( file.chatButtonIcon, controllerModeActive )
	Hud_SetVisible( file.chatButtonIcon, controllerModeActive )
}

#endif

#if CLIENT

void function DirtyAll()
{
	file.displayDirtyBit = ~0
}

                                                         
void function DirtyBit( int teamIdx )
{
	file.displayDirtyBit = file.displayDirtyBit | ( 1 << teamIdx )
}

                                                                      
void function DirtyPlayerBit( entity player )
{
	DirtyBit( player.GetTeam() )
}

void function PrivateMatch_SquadEliminated( int teamIdx, int placement )
{
	if ( teamIdx in file.teamData )
	{
		file.teamData[ teamIdx ].placement = placement
	}
	else
	{
		TeamData tData
		tData.placement = placement
		file.teamData[ teamIdx ] <- tData
		file.teamIndices.push( teamIdx )
		file.teamIndices.sort()
	}
	DirtyAll()
}

int function ClientCodeCallback_SpectatorGetOrderedTarget( int targetIndex, int teamIndex )
{
	if ( teamIndex in file.teamData )
	{
		array<PlayerData> tData = file.teamData[teamIndex].players
		if ( targetIndex < tData.len() )
		{
			PlayerData pData = tData[targetIndex]
			if ( IsValid( pData.playerEntity ) )
				return GetPlayerArrayOfTeam( pData.playerEntity.GetTeam() ).find( pData.playerEntity )
		}
	}

	return -1
}

void function SwitchChatModeButtonText( int chatMode )
{
	string chatModeText = ""
	switch ( chatMode )
	{
		case ACM_PLAYER:
		{
			chatModeText = Localize( "#TOURNAMENT_PLAYER_CHAT" ) 
		}
		break
		case ACM_TEAM:
		{
			chatModeText = Localize( "#TOURNAMENT_TEAM_CHAT" ) 
		}
		break
		case ACM_SPECTATORS:
		{
			chatModeText = Localize( "#TOURNAMENT_SPECTATOR_CHAT" ) 
		}
		break
		case ACM_ALL_PLAYERS:
		{
			chatModeText = Localize( "#TOURNAMENT_ALL_CHAT" ) 
		}
		break
	}

	RunUIScript( "SetChatModeButtonText", chatModeText )
}

void function SetupRosterPanel( var panel )
{
	Hud_InitGridButtons( panel, file.maxTeamSize )
	var scrollPanel = Hud_GetChild( panel, "ScrollPanel" )
	for ( int i = 0; i < file.maxTeamSize; i++ )
	{
		var button = Hud_GetChild( scrollPanel, ("GridButton" + i) )
		InitButtonRCP( button )
		HudElem_SetRuiArg( button, "buttonText", "" )
		Hud_AddEventHandler( button, UIE_CLICK, OnRosterButton_Click )
	}
}

void function SetupOverviewPanel( int panelNum, int panelSize, int maxTeams )
{
	var teamOverview = Hud_GetChild( file.postGameSummaryPanel, "TeamOverview0" + panelNum )

	if ( maxTeams <= file.overviewSizeTotal )
	{
		Hud_Hide( teamOverview )
		return
	}

	Hud_Show( teamOverview )
	file.overviewSizeTotal += panelSize
	Hud_InitGridButtons( teamOverview, panelSize )
	var scrollPanel = Hud_GetChild( teamOverview, "ScrollPanel" )

	for ( int i = 0; i < panelSize; i++ )
	{
		var panel = Hud_GetChild( scrollPanel, "GridButton" + i )
		HudElem_SetRuiArg( panel, "teamPosition", file.teamOverviewPanels.len() + 1 )
		file.teamOverviewPanels.insert( file.teamOverviewPanels.len(), panel )
	}
}

TeamRosterStruct function CreateTeamPlacement( var panel )
{
	TeamRosterStruct teamPlacement
	teamPlacement.headerPanel = Hud_GetChild( panel, PRIVATE_MATCH_TEAM_HEADER_PANEL )
	Hud_Hide( teamPlacement.headerPanel )
	teamPlacement.listPanel = Hud_GetChild( panel, PRIVATE_MATCH_TEAM_BUTTON_PANEL )
	Hud_Hide( teamPlacement.listPanel )
	SetupRosterPanel( teamPlacement.listPanel  )

	return teamPlacement
}

void function ServerCallback_PrivateMatch_OnEntityKilled( entity attacker, entity victim )
{
	bool attackerIsPlayer = IsValid( attacker ) && attacker.IsPlayer()
	bool victimIsPlayer = IsValid( victim ) && victim.IsPlayer()

	                                                   
	if ( !victimIsPlayer )
		return

	                                              
	if ( attackerIsPlayer && ( attacker != victim ) )
	{
		string uid = attacker.GetPlatformUID()
		if ( uid in file.playerData )
		{
			DirtyPlayerBit( attacker )
		}
	}

	DirtyPlayerBit( victim )
}


int function SortPlayers( PlayerData a, PlayerData b )
{
	return a.playerName > b.playerName ? 1 : -1
}

int function SortTeams( TeamDetailsData a, TeamDetailsData b )
{
	if ( a.teamValue < b.teamValue )
		return 1

	if ( a.teamValue > b.teamValue )
		return -1

	return a.teamName > b.teamName ? 1 : -1
}

PlayerData function PrivateMatch_ExtractPlayerData( entity player )
{
	Assert( IsValid( player ) )

	PlayerData pData
	pData.playerEntity = player
	ItemFlavor character = LoadoutSlot_WaitForItemFlavor( ToEHI( player ), Loadout_Character() )
	pData.characterPortrait = CharacterClass_GetGalleryPortrait( character )
	pData.killCount = player.GetPlayerNetInt( "kills" )
	pData.playerName = player.GetPlayerNameWithClanTag()

	return pData
}

void function PrivateMatch_PopulateGameStatusMenu( var menu )
{
	if ( file.enableMenu == false )
		return

	DirtyAll()                                     
	thread UpdateTeamOverviewMenus()                                             
}

void function PrivateMatch_RestoreDefaultPanels()
{
	Hud_Hide( Hud_GetChild( file.inGameSummaryPanel, "EliminatedSquadsHeader" ) )

	{
		var overviewPanel  = Hud_GetChild( file.inGameSummaryPanel, "TeamOverview" )
		var scrollingPanel = Hud_GetChild( overviewPanel, "ScrollPanel" )
		for ( int i = 0; i < file.maxTeamSize + 2; ++i )
		{
			var button = Hud_GetChild( scrollingPanel, "GridButton" + i )
			HudElem_SetRuiArg( button, "teamPosition", 0 )
			Hud_Hide( button )
		}
	}

	{
		foreach ( panel in file.teamOverviewPanels )
		{
			Hud_Hide( panel )
		}
	}

	{
		foreach ( teamRoster in file.teamRosters )
		{
			Hud_Hide( teamRoster.listPanel )
			Hud_Hide( teamRoster.headerPanel )
		}
	}

	DirtyAll()
}

void function PrivateMatch_ClearTeamPresence()
{
	file.teamIndices.clear()
	file.teamData.clear()
	file.playerData.clear()
	DirtyAll()
}

void function PrivateMatch_UpdateTeamPresence()
{
	foreach( player in GetPlayerArray() )
	{
		if ( !IsValid( player ) )
			continue

		if ( player.IsObserver() )
			continue

		PlayerData pData
		if ( player.GetPlatformUID() in file.playerData )
		{
			pData = file.playerData[ player.GetPlatformUID() ]
			pData.playerEntity = player
		}
		else
		{
			pData = PrivateMatch_ExtractPlayerData( player )
			file.playerData[ player.GetPlatformUID() ] <- pData
		}

		TeamData tData
		if ( player.GetTeam() in file.teamData )
			tData = file.teamData[ player.GetTeam() ]
		else
		{
			file.teamData[ player.GetTeam() ] <- tData
			file.teamIndices.push( player.GetTeam() )
			file.teamIndices.sort()
			DirtyAll()
		}

		if ( !tData.players.contains( pData ) )
		{
			tData.players.append( pData )
			tData.players.sort( SortPlayers )
			DirtyPlayerBit( player )
		}
	}
}

void function PrivateMatch_GameStatus_Update( int dirtyBit )
{
	if ( dirtyBit == 0 )
		return

	array< TeamDetailsData > teamOrderArray
	foreach ( teamIndex, tData in file.teamData )
	{
		TeamDetailsData tDetails
		tDetails.teamIndex = teamIndex
		tDetails.teamName = PrivateMatch_GetTeamName( teamIndex )
		tDetails.teamPlacement = tData.placement
		tDetails.playerAlive = 0
		tDetails.teamKills = 0

		foreach ( pData in tData.players )
		{
			if( IsValid( pData.playerEntity ) )
			{
				if ( tData.placement == 0 && IsAlive( pData.playerEntity ) )
					tDetails.playerAlive++

				pData.killCount = pData.playerEntity.GetPlayerNetInt( "kills" )
			}

			tDetails.teamKills += pData.killCount
		}

		tDetails.teamValue = ( tDetails.playerAlive * 1000 ) + tDetails.teamKills - ( tDetails.teamPlacement * 100000 )
		teamOrderArray.append( tDetails )
	}

	teamOrderArray.sort( SortTeams )

	PrivateMatch_GameStatus_MidGame_Configure( teamOrderArray )
	PrivateMatch_GameStatus_PostGame_Configure( teamOrderArray )
}

void function PrivateMatch_GameStatus_MidGame_Configure( array<TeamDetailsData> teamOrderArray )
{
	foreach ( int i, panel in file.teamOverviewPanels )
	{
		if ( i < teamOrderArray.len() )
			thread PrivateMatch_GameStatus_TeamDetails_Configure( panel, teamOrderArray[i], true )
		else
			Hud_Hide( panel )
	}
}

void function PrivateMatch_GameStatus_PostGame_Configure( array<TeamDetailsData> teamOrderArray )
{
	                                                                                           
	                                                                                        
	int[22] gridIdxBinding = [
		0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20,
		1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21
	]

	bool showElimHeader = false
	var overviewPanel = Hud_GetChild( file.inGameSummaryPanel, "TeamOverview" )
	var scrollPanel = Hud_GetChild( overviewPanel, "ScrollPanel" )
	for ( int i = 0; i < ROSTER_LIST_SIZE; ++i )
	{
		int buttonIdx = showElimHeader ? gridIdxBinding[i + 2] : gridIdxBinding[i + 1]
		if ( i < teamOrderArray.len() )
		{
			TeamDetailsData team = teamOrderArray[i]
			if ( !showElimHeader && team.playerAlive == 0 )
			{
				PrivateMatch_GameStatus_ElimHeader_Configure( buttonIdx, scrollPanel )
				showElimHeader = true
				buttonIdx      = gridIdxBinding[i + 2]
			}

			var button = Hud_GetChild( scrollPanel, "GridButton" + buttonIdx )
			HudElem_SetRuiArg( button, "teamPosition", teamOrderArray[i].teamPlacement )
			thread PrivateMatch_GameStatus_TeamDetails_Configure( button, teamOrderArray[i] )
		}
		else
		{
			Hud_Hide( Hud_GetChild( scrollPanel, "GridButton" + buttonIdx ) )
		}
	}

	if ( !showElimHeader )
		Hud_Hide( Hud_GetChild( scrollPanel, "GridButton21" ) )
}

void function PrivateMatch_GameStatus_ElimHeader_Configure ( int idxLocation, var buttonPanel )
{
	var elimHeader = Hud_GetChild( file.inGameSummaryPanel, "EliminatedSquadsHeader" )
	Hud_Show( elimHeader )

	var button = Hud_GetChild( buttonPanel, "GridButton" + idxLocation )
	Hud_Hide( button )

	UIPos pos1 = REPLACEHud_GetAbsPos( button )
	UIPos pos2 = REPLACEHud_GetAbsPos( file.inGameSummaryPanel )
	Hud_SetPos( elimHeader, pos2.x - pos1.x, pos2.y - pos1.y )
}

void function PrivateMatch_GameStatus_TeamDetails_Configure( var panel, TeamDetailsData tData, bool postGame = false )
{
	array<PlayerData> teamPlayers = file.teamData[ tData.teamIndex ].players
	Hud_Show( panel )

	var panelRui = Hud_GetRui( panel )
	RuiSetString( panelRui, "teamName", tData.teamName )
	RuiSetInt( panelRui, "playersAlive", tData.playerAlive )
	RuiSetInt( panelRui, "kills", tData.teamKills )

	int idx = 0
	foreach ( int i, pData in teamPlayers )
	{
		if ( i < file.maxTeamSize )
		{
			RuiSetImage( panelRui, "playerImage" + i, pData.characterPortrait )
			RuiSetBool( panelRui, "playerAlive" + i, postGame || ( IsValid( pData.playerEntity ) && IsAlive( pData.playerEntity ) ) )
			idx = i
		}
	}

	for ( ++idx; idx < file.maxTeamSize; ++idx )
	{
		RuiSetImage( panelRui, "playerImage" + idx, $"" )
		RuiSetBool( panelRui, "playerAlive" + idx, false )
	}
}

void function PrivateMatch_GameStatus_TeamRoster_Update( int dirtyBit )
{
	if ( dirtyBit == 0 )
		return

	if ( file.teamRosterPanel == null )
		return

	if ( file.enableMenu == false )
		return

	int nextSlotIdx = -1
	foreach ( teamIndex in file.teamIndices )
	{
		++nextSlotIdx
		if ( ( dirtyBit & ( 1 << teamIndex ) ) == 0 )
			continue

		if(nextSlotIdx > file.teamRosters.len())
		{
			Warning("PrivateMatch_GameStatus_TeamRoster_Update: More teamIndices than teamRosters, skipping slotIndex "+string(nextSlotIdx)+" and teamIndex "+string(teamIndex))
			continue
		}

		TeamRosterStruct teamRoster = file.teamRosters[nextSlotIdx]
		string teamName = PrivateMatch_GetTeamName( teamIndex )

		Hud_Show( teamRoster.listPanel )
		Hud_Show( teamRoster.headerPanel )

		HudElem_SetRuiArg( teamRoster.headerPanel, "teamName", teamName )
		HudElem_SetRuiArg( teamRoster.headerPanel, "teamNumber", teamIndex - 1 )

		var scrollPanel = Hud_GetChild( teamRoster.listPanel, "ScrollPanel" )

		array<PlayerData> teamPlayers = file.teamData[ teamIndex ].players
		for ( int i = 0; i < file.maxTeamSize; ++i )
		{
			PlayerData pData
			if ( i < teamPlayers.len() )
				pData = teamPlayers[i]

			var button = Hud_GetChild( scrollPanel, "GridButton" + i )
			teamRoster.buttonPlayerMap[ button ] <- pData.playerEntity
			thread PrivateMatch_GameStatus_ConfigurePlayerButton( button, pData )
		}
	}

	                         
	for ( ++nextSlotIdx; nextSlotIdx < file.teamRosters.len(); ++nextSlotIdx )
	{
		TeamRosterStruct teamRoster = file.teamRosters[ nextSlotIdx ]
		Hud_Hide( teamRoster.listPanel )
		Hud_Hide( teamRoster.headerPanel )
	}
}

void function PrivateMatch_GameStatus_ConfigurePlayerButton( var button, PlayerData pData )
{
	var buttonRui = Hud_GetRui( button )
	if ( IsValid( pData.playerEntity ) )
	{
		RuiSetInt( buttonRui, "playerState", GetPlayerHealthStatus( pData.playerEntity ) )
		RuiSetBool( buttonRui, "isObserveTarget", GetLocalClientPlayer().GetObserverTarget() == pData.playerEntity )
		RuiSetInt( buttonRui, "connectionQuality", pData.playerEntity.GetConnectionQualityIndex() )
		RuiSetBool( buttonRui, "isConnectionQualityWidgetVisible", true )
	}
	else
	{
		RuiSetInt( buttonRui, "playerState", ePlayerHealthStatus.PM_PLAYERSTATE_ELIMINATED )
		RuiSetBool( buttonRui, "isObserveTarget", false )
		RuiSetInt( buttonRui, "connectionQuality", 5 )
		RuiSetBool( buttonRui, "isConnectionQualityWidgetVisible", false )
	}

	RuiSetString( buttonRui, "buttonText",  pData.playerName )
	RuiSetImage( buttonRui, "playerPortrait", pData.characterPortrait )
	RuiSetInt( buttonRui, "killCount", pData.killCount )
}

var function PrivateMatch_GameStatus_GetPlayerButton( entity player )
{
	foreach ( teamRoster in file.teamRosters )
	{
		foreach ( var button, entity buttonPlayer in teamRoster.buttonPlayerMap )
		{
			if ( !IsValid( button ) || !IsValid( buttonPlayer ) )
				continue

			if ( buttonPlayer == player )
			{
				return button
			}
		}
	}
}

void function OnRosterButton_Click( var button )
{
	entity observerTarget = null
	foreach ( teamRoster in file.teamRosters )
	{
		if ( button in teamRoster.buttonPlayerMap )
			observerTarget = teamRoster.buttonPlayerMap[ button ]
	}

	if ( !IsValid( observerTarget ) )
		return

	if ( !IsAlive( observerTarget ) )
		return

	if ( GetLocalClientPlayer().GetObserverTarget() == observerTarget )
		return

	Remote_ServerCallFunction( "ClientCallback_PrivateMatchChangeObserverTarget", observerTarget )
	RunUIScript( "ClosePrivateMatchGameStatusMenu", null )
}

void function RefreshEntityReference( entity player )
{
	if ( IsValid( player ) && player.IsPlayer() )
	{
		                                                                                              
		string uid = player.GetPlatformUID()
		if ( uid in file.playerData )
			file.playerData[uid].playerEntity = player

		                                                  
		DirtyPlayerBit( player )
	}
}

                                                                                              
void function OnSpectateTargetChanged( entity spectatingPlayer, entity oldSpectatorTarget, entity newSpectatorTarget )
{
	RefreshEntityReference( oldSpectatorTarget )
	RefreshEntityReference( newSpectatorTarget )
}

int function GetPlayerHealthStatus( entity player )
{
	int healthStatus = ePlayerHealthStatus.PM_PLAYERSTATE_ALIVE

	if ( !IsAlive( player ) )
	{
		int respawnStatus = GetRespawnStatus( player )
		switch ( respawnStatus )
		{
			case eRespawnStatus.PICKUP_DESTROYED:
			case eRespawnStatus.SQUAD_ELIMINATED:
				healthStatus = ePlayerHealthStatus.PM_PLAYERSTATE_ELIMINATED
				break

			case eRespawnStatus.WAITING_FOR_DELIVERY:
			case eRespawnStatus.WAITING_FOR_DROPPOD:
			case eRespawnStatus.WAITING_FOR_PICKUP:
			case eRespawnStatus.WAITING_FOR_RESPAWN:
				healthStatus = ePlayerHealthStatus.PM_PLAYERSTATE_DEAD
				break

			case eRespawnStatus.NONE:
			default:
				healthStatus = ePlayerHealthStatus.PM_PLAYERSTATE_ALIVE
				break
		}
	}

	if ( Bleedout_IsBleedingOut( player ) )
	{
		int bleedoutState = player.GetBleedoutState()

		switch ( bleedoutState )
		{
			case BS_BLEEDING_OUT:
			case BS_ENTERING_BLEEDOUT:
				healthStatus = ePlayerHealthStatus.PM_PLAYERSTATE_BLEEDOUT
				break

			case BS_EXITING_BLEEDOUT:
				healthStatus = ePlayerHealthStatus.PM_PLAYERSTATE_REVIVING
				break
		}
	}

	return healthStatus
}

void function OnGameStateEnter_Playing()
{
	DirtyAll()                                              
	TryEnablePrivateMatchGameStatusMenu()

	RunUIScript( "OnPrivateMatchStateChange", eGameState.Playing )
}

void function OnGameStateEnter_WinnerDetermined()
{
	RunUIScript( "OnPrivateMatchStateChange", eGameState.WinnerDetermined )
}

void function OnPlayerMatchStateChanged( entity player, int newState )
{
	if ( newState > ePlayerMatchState.SKYDIVE_PRELAUNCH )
	{
		DirtyAll()                                  
		TryEnablePrivateMatchGameStatusMenu()
	}
	else
	{
		PrivateMatch_RestoreDefaultPanels()                                  
		PrivateMatch_ClearTeamPresence()
	}
}

void function TryEnablePrivateMatchGameStatusMenu()
{
	if ( file.enableMenu )
		return

	if ( !IsPrivateMatch() )
		return

	if ( GetLocalClientPlayer().GetTeam() != TEAM_SPECTATOR )
		return

	if ( GetGameState() < eGameState.Playing )
		return

	RunUIScript( "EnablePrivateMatchGameStatusMenu", true )
	file.enableMenu = true

	PrivateMatch_PopulateGameStatusMenu( file.menu )
}

void function UpdateTeamOverviewMenus()
{
	while ( true )
	{
		PrivateMatch_UpdateTeamPresence()

		                                                                      
		int dirtyBit = file.displayDirtyBit
		file.displayDirtyBit = 0

		PrivateMatch_GameStatus_Update( dirtyBit )
		PrivateMatch_GameStatus_TeamRoster_Update( dirtyBit )

		wait 0.1
	}
}

void function PrivateMatch_UpdateChatTarget()
{
	int chatMode = file.adminConfig.chatMode

	entity observerTarget = GetLocalClientPlayer().GetObserverTarget()

	if( observerTarget == null )
	{
		RunUIScript( "SetChatTargetText", "" )
	}
	else if ( chatMode == ACM_PLAYER )
	{
		RunUIScript( "SetChatTargetText", observerTarget.GetPlayerName() )
	}
	else if ( chatMode == ACM_TEAM )
	{
		RunUIScript( "SetChatTargetText", PrivateMatch_GetTeamName( observerTarget.GetTeam() ) )
	}
	else
	{
		RunUIScript( "SetChatTargetText", "" )
	}

	Remote_ServerCallFunction( "ClientCallback_PrivateMatchSetAdminConfig", file.adminConfig.chatMode, file.adminConfig.spectatorChat )
}

void function PrivateMatch_CycleAdminChatMode()
{
	if ( !GetLocalClientPlayer().HasMatchAdminRole() )
		return

	if ( ++file.adminConfig.chatMode == ACM_COUNT )
		file.adminConfig.chatMode = 0

	SwitchChatModeButtonText( file.adminConfig.chatMode )
	PrivateMatch_UpdateChatTarget()

	RunUIScript( "SetSpecatorChatModeState", file.adminConfig.chatMode == ACM_ALL_PLAYERS, file.adminConfig.spectatorChat )
}

void function PrivateMatch_ToggleAdminSpectatorChat()
{
	if ( !GetLocalClientPlayer().HasMatchAdminRole() )
		return

	file.adminConfig.spectatorChat = !file.adminConfig.spectatorChat

	RunUIScript( "SetSpecatorChatModeState", file.adminConfig.chatMode == ACM_ALL_PLAYERS, file.adminConfig.spectatorChat )
	Remote_ServerCallFunction( "ClientCallback_PrivateMatchSetAdminConfig", file.adminConfig.chatMode, file.adminConfig.spectatorChat )
}

void function PrivateMatch_ToggleUpdatePlayerConnections( bool isActive )
{
	if ( isActive && file.updateConnections == false )
	{
		file.updateConnections = true
		thread UpdatePrivateMatchPlayerConnections()
	}
	else
	{
		file.updateConnections = false
	}
}

void function UpdatePrivateMatchPlayerConnections()
{
	while ( file.updateConnections )
	{
		foreach ( int idx, teamRoster in file.teamRosters )
		{
			foreach ( var button, entity buttonPlayer in teamRoster.buttonPlayerMap )
			{
				if ( IsValid( button ) )
				{
					int connectionQuality0 = ( button in teamRoster ) ? teamRoster.connectionMap[ button ] : -1
					int connectionQuality1 = IsValid( buttonPlayer ) ? buttonPlayer.GetConnectionQualityIndex() : 5

					if ( connectionQuality0 != connectionQuality1 )
					{
						teamRoster.connectionMap[ button ] <- connectionQuality1
						HudElem_SetRuiArg( button, "connectionQuality", connectionQuality1, eRuiArgType.INT )
						DirtyBit( TEAM_MULTITEAM_FIRST + idx )
					}
				}
			}
		}
		wait 1
	}
}

#endif         


#if UI
void function TryInitializeGameStatusMenu()
{
	if ( !file.tabsInitialized )
	{
		TabData tabData = GetTabDataForPanel( file.menu )
		tabData.centerTabs = true
		AddTab( file.menu, Hud_GetChild( file.menu, "PrivateMatchRosterPanel" ), "#TOURNAMENT_TEAM_STATUS" )		    
		AddTab( file.menu, Hud_GetChild( file.menu, "PrivateMatchOverviewPanel" ), "#TOURNAMENT_MATCH_STATS" )		    
		AddTab( file.menu, Hud_GetChild( file.menu, "PrivateMatchSummaryPanel" ), "#TOURNAMENT_MATCH_STATS" )		    
		if ( HasMatchAdminRole() )
			AddTab( file.menu, Hud_GetChild( file.menu, "PrivateMatchAdminPanel" ), "#TOURNAMENT_ADMIN_CONTROLS" )	    

		file.tabsInitialized = true
	}
}

void function OnOpenPrivateMatchGameStatusMenu()
{
	if ( !IsFullyConnected() )
	{
		CloseActiveMenu()
		return
	}

	TryInitializeGameStatusMenu()

	TabData tabData        = GetTabDataForPanel( file.menu )
	TabDef rosterTab       = Tab_GetTabDefByBodyName( tabData, "PrivateMatchRosterPanel" )
	TabDef overviewTab     = Tab_GetTabDefByBodyName( tabData, "PrivateMatchOverviewPanel" )
	TabDef summaryTab      = Tab_GetTabDefByBodyName( tabData, "PrivateMatchSummaryPanel" )
	if ( HasMatchAdminRole() )
		TabDef adminTab       = Tab_GetTabDefByBodyName( tabData, "PrivateMatchAdminPanel" )

	UpdateMenuTabs()
	
	ActivateTab( tabData, eGameStatusPanel.PM_GAMEPANEL_ROSTER )
		
	SetTabNavigationEnabled( file.menu, true )

	RunClientScript( "PrivateMatch_PopulateGameStatusMenu", file.menu )

}

void function OnShowPrivateMatchGameStatusMenu()
{
	SetMenuReceivesCommands( file.menu, PROTO_Survival_DoInventoryMenusUseCommands() && !IsControllerModeActive() )
	if ( !HasMatchAdminRole() )
		return

	RegisterInputs()

	ControllerIconVisibilty( IsControllerModeActive() )

	RunClientScript( "PrivateMatch_ToggleUpdatePlayerConnections", true )
}

void function OnHidePrivateMatchGameStatusMenu()
{
	                                             
	if ( !HasMatchAdminRole() )
		return

	DeRegisterInputs()

	RunClientScript( "PrivateMatch_ToggleUpdatePlayerConnections", false )
}

void function OnPrivateMatchStateChange( int gameState )
{
	TryInitializeGameStatusMenu()

	TabData tabData        	= GetTabDataForPanel( file.menu )
	TabDef inGameSummary 	= Tab_GetTabDefByBodyName( tabData, "PrivateMatchOverviewPanel" )
	TabDef postGameSummary 	= Tab_GetTabDefByBodyName( tabData, "PrivateMatchSummaryPanel" )

	bool summaryActive 		= tabData.activeTabIdx == eGameStatusPanel.PM_GAMEPANEL_INGAME_SUMMARY

	bool midGame = gameState < eGameState.WinnerDetermined
	SetTabDefVisible( inGameSummary, midGame )
	SetTabDefVisible( postGameSummary, !midGame )

	if ( !midGame && summaryActive )
		ActivateTab( tabData, eGameStatusPanel.PM_GAMEPANEL_POSTGAME_SUMMARY )
}


void function OnClosePrivateMatchGameStatusMenu()
{
	if ( !HasMatchAdminRole() )
		return

	DeRegisterInputs()

	file.updateConnections = false
}


bool function CanNavigateBack()
{
	return file.disableNavigateBack != true
}


void function OnNavigateBack()
{
	ClosePrivateMatchGameStatusMenu( null )
}


void function EnablePrivateMatchGameStatusMenu( bool doEnable )
{
	file.enableMenu = doEnable
}


bool function IsPrivateMatchGameStatusMenuOpen()
{
	return GetActiveMenu() == file.menu
}

void function TogglePrivateMatchGameStatusMenu( var button )
{
	if ( !IsPrivateMatch() )
		return

	if ( GetActiveMenu() == file.menu )
		thread CloseActiveMenu()

	if ( file.enableMenu == true )
		AdvanceMenu( file.menu )
}


void function OpenPrivateMatchGameStatusMenu( var button )
{
	if ( !IsPrivateMatch() )
		return

	if ( file.enableMenu == false )
		return

	CloseAllMenus()
	AdvanceMenu( file.menu )
}

void function ChatModeButton_OnActivate( var button )
{
	if ( HasMatchAdminRole() )
	{
		RunClientScript( "PrivateMatch_CycleAdminChatMode" )
	}
}

void function ChatSpectatorCheckBox_OnActivate( var button )
{
	if ( HasMatchAdminRole() )
	{
		RunClientScript( "PrivateMatch_ToggleAdminSpectatorChat" )
	}
}

void function ClosePrivateMatchGameStatusMenu( var button )
{
	if ( GetActiveMenu() == file.menu )
		thread CloseActiveMenu()
}
#endif     

