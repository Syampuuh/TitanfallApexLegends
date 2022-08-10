global function InitPrivateMatchPostGameMenu

#if UI
global function IsPrivateMatchPostGameMenuValid
global function OpenPrivateMatchPostGameMenu
global function ClosePrivateMatchPostGameMenu
#endif

#if UI
global function InitSetTeamNameDialogMenu
global function DisplaySetTeamNameDialog
#endif

#if CLIENT
global function PrivateMatch_PopulatePostGame
global function PrivateMatch_PostGame_ToggleSortingMethod
#endif

const int TEAM_NAME_MIN_LENGTH = 3

struct PlacementStruct
{
	var           headerPanel
	var           listPanel
	int           teamIndex
	int			  teamPlacement
	int           teamSize
	int           teamDisplayNumber

	array<var>      _listButtons

	array<PrivateMatchStatsStruct> playerPlacementData
}

enum ePlacementSortingMethod
{
	BY_PLACEMENT,
	BY_TEAM_INDEX,

	_count
}

struct
{
	var menu

	var continueButton

	var decorationRui
	var menuHeaderRui

	var teamRosterPanel

	bool wasPartyMember = false                                                                                                                                                                                                                
	bool disableNavigateBack = false

	bool skippableWaitSkipped = false

	int xpChallengeTier = -1
	int xpChallengeValue = -1

	var    setTeamNameDialog
	int    setTeamNameDialog_teamIndex
	var    TextEntryCodeBox
	string setTeamNameDialog_teamName

	table< int, PlacementStruct > teamPlacement

	var sortingMethodButton
	int sortingMethod = ePlacementSortingMethod.BY_PLACEMENT
} file

void function InitPrivateMatchPostGameMenu( var menu )
{
	file.menu = menu
	file.teamRosterPanel = Hud_GetChild( menu, "PrivateMatchRosterPanel" )

	file.sortingMethodButton = Hud_GetChild( menu, "PostGameSortingButton" )

	#if UI
		file.menuHeaderRui = Hud_GetRui( Hud_GetChild( menu, "MenuHeader" ) )
		RuiSetString( file.menuHeaderRui, "menuName", "#MATCH_SUMMARY" )

		file.decorationRui = Hud_GetRui( Hud_GetChild( menu, "Decoration" ) )

		ToolTipData sortingToolTip
		sortingToolTip.descText = "#TOURNAMENT_POST_GAME_SORTING_TOOLTIP"
		Hud_SetToolTipData( file.sortingMethodButton, sortingToolTip )
		Hud_AddEventHandler( file.sortingMethodButton, UIE_CLICK, SortingMethodButton_OnClick )

		Hud_Show( file.teamRosterPanel )

		AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenPrivateMatchPostGameMenu )
		AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnShowPrivateMatchPostGameMenu )
		AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, OnHidePrivateMatchPostGameMenu )
		AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnClosePrivateMatchPostGameMenu )
		AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnNavigateBack )

		AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE", null, CanNavigateBack )
		AddMenuFooterOption( menu, LEFT, BUTTON_BACK, true, "", "", ClosePostGameMenu, CanNavigateBack )

		AddUICallback_OnLevelInit( void function() : ( menu )
		{
			Assert( CanRunClientScript() )
			RunClientScript( "InitPrivateMatchPostGameMenu", menu )
		} )
	#elseif CLIENT
		UpdateSortingButton()

		var panel = Hud_GetChild( menu, "PrivateMatchRosterPanel" )
		for ( int index; index < 20; index++ )
		{
			file.teamPlacement[TEAM_MULTITEAM_FIRST + index] <- CreateTeamPlacement( TEAM_MULTITEAM_FIRST + index, 3 )
		}

		                                                                                                
	#endif
}


#if CLIENT
PlacementStruct function CreateTeamPlacement( int teamIndex, int teamSize )
{
	PlacementStruct teamPlacement
	teamPlacement.teamIndex = teamIndex
	teamPlacement.teamSize = teamSize

	                                                                                    
	                                                                                  

	return teamPlacement
}


void function PrivateMatch_PopulatePostGame( var menu )
{
	table< int, array< PrivateMatchStatsStruct > > teamPlacementMap
	for ( int playerIndex = 0; playerIndex < ABSOLUTE_MAX_TEAMS; playerIndex++ )
	{
		PrivateMatchStatsStruct ornull playerTeamStats = PrivateMatch_GetPlayerTeamStats( playerIndex )
		if ( playerTeamStats == null )
			continue

		expect PrivateMatchStatsStruct( playerTeamStats )

		int teamIndex = playerTeamStats.teamNum

		if ( !(teamIndex in teamPlacementMap) )
			teamPlacementMap[teamIndex] <- []

		teamPlacementMap[teamIndex].append( playerTeamStats )
	}

	PrivateMatch_TeamPlacement_Update( teamPlacementMap )
}


bool function PrivateMatch_TeamRoster_Configure( PlacementStruct teamPlacement, array<PrivateMatchStatsStruct> playerTeamStatsArray )
{
	int placement = -1
	foreach( PrivateMatchStatsStruct playerStats in playerTeamStatsArray )
	{
		                                                                                                                                                                     
		if ( playerStats.teamPlacement > placement )
			placement = playerStats.teamPlacement
	}

	                                                                                                         
	if ( placement != -1 )
	{
		teamPlacement.teamPlacement = placement
		                                                                                                                                   
	}
	if ( placement < 1 )
	{
		printt( "Tournament Mode: Post game team placement < 1" )
		return false
	}

	string teamName = PrivateMatch_GetTeamName( teamPlacement.teamIndex )

	string team = "Team"
	int placementIndex = teamPlacement.teamPlacement - 1
	int teamIndex = teamPlacement.teamIndex - TEAM_MULTITEAM_FIRST
	int ruiIndex = (file.sortingMethod == ePlacementSortingMethod.BY_PLACEMENT) ? placementIndex : teamIndex
	string panelIndex = ruiIndex < 10 ? "0" + string( ruiIndex ) : string( ruiIndex )
	string panelIndexName = team + panelIndex
	                                                                                                                                                                   

	teamPlacement.teamDisplayNumber = ruiIndex + 1
	printf( "PrivateMatchPostGameDebug: %s's data: Team Index: %i, Placement: %i, Display Number: %i (ruiIndex = %i)", teamName, teamPlacement.teamIndex, teamPlacement.teamPlacement, teamPlacement.teamDisplayNumber, ruiIndex )

	var teamPanel = Hud_GetChild( file.teamRosterPanel, panelIndexName )

	teamPlacement.headerPanel = Hud_GetChild( teamPanel, PRIVATE_MATCH_TEAM_HEADER_PANEL )
	teamPlacement.listPanel = Hud_GetChild( teamPanel, PRIVATE_MATCH_TEAM_BUTTON_PANEL )

	var buttonPanel = teamPlacement.listPanel
	int teamSize    = teamPlacement.teamSize

	HudElem_SetRuiArg( teamPlacement.headerPanel, "teamName", teamName )
	HudElem_SetRuiArg( teamPlacement.headerPanel, "teamNumber", teamPlacement.teamDisplayNumber )

	Hud_InitGridButtons( buttonPanel, teamSize )
	var scrollPanel = Hud_GetChild( buttonPanel, "ScrollPanel" )
	for ( int i = 0; i < teamSize; i++ )
	{
		var button = Hud_GetChild( scrollPanel, ("GridButton" + i) )
		if ( i == 0 )
		{
			int rosterHeight = (Hud_GetHeight( button ) * teamSize)
		}
		InitButtonRCP( button )
		HudElem_SetRuiArg( button, "buttonText", "" )
	}
	return true
}


void function PrivateMatch_TeamPlacement_Update( table< int, array< PrivateMatchStatsStruct > > teamPlacementMap )
{
	if ( file.teamPlacement.len() == 0 )
		return

	int playlistMaxTeams = GetCurrentPlaylistVarInt( "max_teams", 20 )
	array<int> emptyTeamIndices
	foreach ( teamIndex, teamPlacement in file.teamPlacement )
	{
		if ( ( teamIndex - TEAM_MULTITEAM_FIRST ) >= playlistMaxTeams )
		{
			continue
		}

		array<PrivateMatchStatsStruct> playerTeamStatsArray
		if ( teamIndex in teamPlacementMap )
		{
			playerTeamStatsArray = teamPlacementMap[teamIndex]
		}
		else
		{
			printf( "PrivateMatchPostGameDebug: Reporting empty team roster (team index %i). Setting placement to %i (%i + %i)", teamPlacement.teamIndex, teamPlacementMap.len() + emptyTeamIndices.len(), teamPlacementMap.len(), emptyTeamIndices.len() )
			teamPlacement.teamPlacement = teamPlacementMap.len() + emptyTeamIndices.len()
			emptyTeamIndices.append( teamIndex )
		}

		if ( !PrivateMatch_TeamRoster_Configure( teamPlacement, playerTeamStatsArray ) )
		{
			continue
		}

		var scrollPanel = Hud_GetChild( teamPlacement.listPanel, "ScrollPanel" )
		Assert( playerTeamStatsArray.len() <= teamPlacement.teamSize )
		for ( int playerIndex = 0; playerIndex < teamPlacement.teamSize; playerIndex++ )
		{
			var button = Hud_GetChild( scrollPanel, ("GridButton" + playerIndex) )
			if ( playerIndex < playerTeamStatsArray.len() )
			{
				                                                                                                               
				HudElem_SetRuiArg( teamPlacement.headerPanel, "teamName", playerTeamStatsArray[playerIndex].teamName )

				HudElem_SetRuiArg( button, "buttonText", playerTeamStatsArray[playerIndex].playerName )
				HudElem_SetRuiArg( button, "rightText", ( "`1KILL: " + playerTeamStatsArray[playerIndex].kills + " `0- `2DMG: " + playerTeamStatsArray[playerIndex].damageDealt ) )
			}
			else
			{
				HudElem_SetRuiArg( button, "buttonText", "" )
				HudElem_SetRuiArg( button, "rightText", "" )
			}
		}
	}

	                                                                   
	   
	  	                                                                 
	  	                                             
	  	 
	  		                                                   
	  		                                   
	  		                                    
	  		 
	  			                                                    
	  		 
	  
	  		                                                             
	  		                                     
	  		                                       
	  
	  		                                                                            
	  		                                                                       
	  		                                                              
	  	 
	   
}

void function PrivateMatch_PostGame_ToggleSortingMethod()
{
	int currentMethod = file.sortingMethod

	if ( currentMethod == ePlacementSortingMethod.BY_PLACEMENT )
		file.sortingMethod = ePlacementSortingMethod.BY_TEAM_INDEX
	else
		file.sortingMethod = ePlacementSortingMethod.BY_PLACEMENT

	UpdateSortingButton()
	PrivateMatch_PopulatePostGame( file.menu )
}

void function UpdateSortingButton()
{
	var button = file.sortingMethodButton

	string text = (file.sortingMethod == ePlacementSortingMethod.BY_PLACEMENT) ? Localize("#TOURNAMENT_POST_GAME_SORTING_PLACEMENT") : Localize("#TOURNAMENT_POST_GAME_SORTING_TEAMINDEX")

	HudElem_SetRuiArg( button, "buttonText", text )
}
#endif         


#if UI
void function OnOpenPrivateMatchPostGameMenu()
{
	if ( !IsFullyConnected() )
	{
		CloseActiveMenu()
		return
	}

	RunClientScript( "PrivateMatch_PopulatePostGame", file.menu )
}


void function OnShowPrivateMatchPostGameMenu()
{
	                                                             

	                                              
	  
		                                      
		 
			                             
			                                                                           
			                                       

			                                                    
			                                     
			                                                                                  

			                                                                                                                
			                                                                      
			                                                                                                  
		 
	  
}


void function OnHidePrivateMatchPostGameMenu()
{
	                                             
}


void function OnClosePrivateMatchPostGameMenu()
{
	                                      
}

bool function CanNavigateBack()
{
	return file.disableNavigateBack != true
}

void function OnNavigateBack()
{
	ClosePrivateMatchPostGameMenu( null )
}


bool function IsPrivateMatchPostGameMenuValid( bool checkTime = false )
{
	                                                                                                                  
	  	            
	  
	                                  
	  	            
	  
	                                                                                                          
	  	            

	return true
}


void function OpenPrivateMatchPostGameMenu( var button )
{
	Assert( IsPrivateMatchPostGameMenuValid() )

	AdvanceMenu( file.menu )
}


void function ClosePrivateMatchPostGameMenu( var button )
{
	if ( GetActiveMenu() == file.menu )
		thread CloseActiveMenu()
}
#endif


#if UI

void function InitSetTeamNameDialogMenu( var menu )
{
	file.setTeamNameDialog = menu

	SetDialog( menu, true )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, SetTeamName_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, SetTeamName_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, SetTeamName_OnNavigateBack )

	var panel = Hud_GetChild( file.setTeamNameDialog, "SetTeamNameBox" )
	RegisterSignal( Hud_GetHudName( panel ) )
	file.TextEntryCodeBox = Hud_GetChild( panel, "TextEntryCode" )
	InitTextEntry( panel, RenameTeamOnTextEntry )
}

void function InitTextEntry( var panel, void functionref( string entryCode ) activateCallback )
{
	var connectButton = Hud_GetChild( panel, "ConnectButton" )
	Hud_AddEventHandler( connectButton, UIE_CLICK, SaveButton_OnClick )
	HudElem_SetRuiArg( connectButton, "buttonText", "#TOURNAMENT_SAVE_TEAM_NAME" )

	var frame = Hud_GetChild( panel, "ConnectBoxFrame" )
	HudElem_SetRuiArg( frame, "titleText", "#TOURNAMENT_RENAME_TEAM" )
	HudElem_SetRuiArg( frame, "subtitleText", "#TOURNAMENT_TEAM_NAME" )
	InitButtonRCP( frame )

	var textEntry = file.TextEntryCodeBox

	Hud_AddEventHandler( connectButton, UIE_CLICK, void function( var button ) : ( textEntry, activateCallback ) {
		string entryCode = Hud_GetUTF8Text( file.TextEntryCodeBox )
		activateCallback( entryCode )
	} )
}

void function DisplaySetTeamNameDialog( int teamIndex, string teamName )
{
	file.setTeamNameDialog_teamIndex = teamIndex
	file.setTeamNameDialog_teamName = teamName

	AdvanceMenu( file.setTeamNameDialog )
}

void function SetTeamName_OnOpen()
{
	PrivateMatch_SetLobbyChatVisible( false )
	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )

	Hud_SetEnabled( file.TextEntryCodeBox, true )
	Hud_SetFocused( file.TextEntryCodeBox )
	Hud_SetUTF8Text( file.TextEntryCodeBox, file.setTeamNameDialog_teamName )
	Hud_SetTextEntryTitle( file.TextEntryCodeBox, "#TOURNAMENT_TEAM_NAME" )
	RegisterButtonPressedCallback( KEY_ENTER, SaveButton_OnClick )

	thread TournamentSetTeamNameMenu_Update( Hud_GetChild( file.setTeamNameDialog, "SetTeamNameBox" ) )
}

void function TournamentSetTeamNameMenu_Update( var panel )
{
	string signalName = Hud_GetHudName( panel )

	Signal( uiGlobal.signalDummy, signalName )
	EndSignal( uiGlobal.signalDummy, signalName )

	var textEntry     = Hud_GetChild( panel, "TextEntryCode" )
	var connectButton = Hud_GetChild( panel, "ConnectButton" )

	while ( true )
	{
		string entryCode = Hud_GetUTF8Text( textEntry )
		Hud_SetEnabled( connectButton, entryCode.len() >= TEAM_NAME_MIN_LENGTH )

		WaitFrame()
	}
}

void function RenameTeamOnTextEntry( string entryCode )
{
	file.setTeamNameDialog_teamName = entryCode

	Hud_SetUTF8Text( file.TextEntryCodeBox, entryCode )

	if ( CanRunClientScript() )
		RunClientScript( "SetTeamName_OnOnSave", file.setTeamNameDialog_teamIndex, entryCode )

	if ( GetActiveMenu() == file.setTeamNameDialog )
		CloseActiveMenu()
}


void function SaveButton_OnClick( var button )
{
	PrivateMatch_SetLobbyChatVisible( true )
	string newTeamName = Hud_GetUTF8Text( file.TextEntryCodeBox )
	if ( CanRunClientScript() )
		RunClientScript( "SetTeamName_OnOnSave", file.setTeamNameDialog_teamIndex, newTeamName )

	if ( GetActiveMenu() == file.setTeamNameDialog )
		CloseActiveMenu()
}


void function SetTeamName_OnClose()
{
	DeregisterButtonPressedCallback( KEY_ENTER, SaveButton_OnClick )

	Signal( uiGlobal.signalDummy, Hud_GetHudName(  Hud_GetChild( file.setTeamNameDialog, "SetTeamNameBox" ) ) )
}


void function SetTeamName_OnNavigateBack()
{
	CloseActiveMenu()
}

void function SortingMethodButton_OnClick( var button )
{
	if ( CanRunClientScript() )
		RunClientScript( "PrivateMatch_PostGame_ToggleSortingMethod" )
}
#endif

