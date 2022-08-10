global function InitCustomMatchSummaryPanel

const string DEFAULT_LAYOUT = SURVIVAL + "00"
const string CUSTOM_MATCH_SUMMARY_CHANGED_SIGNAL = "CustomMatch_SummaryChanged"

const int MAX_CACHE_SIZE = 8
const int MAX_TEAM_SIZE = 3                                                       

enum eSummaryType
{
	MATCH_FINISHED,
	MATCH_IN_PROGRESS,

	__count
}

struct SummaryLayout
{
	var panel
	int maxTeams
}

struct SummaryDisplayFilter
{
	int functionref( SummaryLayout layout, array<CustomMatch_MatchTeam> teams, int index ) DisplayUpdate
	void functionref( SummaryLayout layout, array<CustomMatch_MatchTeam> teams ) PostDisplayUpdate
}

struct CacheEntry
{
	int key
	CustomMatch_MatchSummary& value
}

struct
{
	var panel
	var matchSummary
	var historyGrid
	var noHistory
	var spinner

	string layoutStyle	                                   
	bool autoSelect		                                                                                      

	table<string, SummaryLayout> layouts
	table<string, SummaryDisplayFilter> filters

	array<CacheEntry> cache
} file

                                                                    
                           
                                                                    

void function InitCustomMatchSummaryPanel( var panel )
{
	file.panel       	= panel
	file.matchSummary	= Hud_GetChild( panel, "MatchSummary" )
	file.historyGrid	= Hud_GetChild( panel, "HistoryGrid" )
	file.noHistory		= Hud_GetChild( panel, "NoHistory" )
	file.spinner		= Hud_GetChild( panel, "Spinner" )
	AddSummaryLayouts()

	RegisterSignal( CUSTOM_MATCH_SUMMARY_CHANGED_SIGNAL )
	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, CustomMatchSummary_OnShow )
	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )

	AddCallback_OnCustomMatchStatsPushed( Callback_OnMatchStatsPushed )
	AddCallback_OnCustomMatchLobbyDataChanged( Callback_OnLobbyDataChanged )
}

void function AddSummaryLayouts()
{
	file.layouts.clear()
	AddSummaryLayout( SURVIVAL, "SurvivalSummary", 20 )
	AddSummaryLayout( GAMEMODE_ARENAS, "ArenasSummary", 2 )

	{
		SummaryDisplayFilter filter
		filter.DisplayUpdate = Survival_InProgress_Display
		filter.PostDisplayUpdate = Survival_InProgress_PostDisplay
		AddDisplayFilter( GetSummaryStyle( SURVIVAL, eSummaryType.MATCH_IN_PROGRESS ), filter )
	}
}

void function AddSummaryLayout( string gamemode, string panelName, int maxTeams )
{
	for ( int i = 0; i < eSummaryType.__count; ++i )
	{
		SummaryLayout layout

		layout.panel 				= Hud_GetChild( file.matchSummary, panelName + format( "%02u", i )  )
		layout.maxTeams 			= maxTeams

		file.layouts[ GetSummaryStyle( gamemode, i ) ] <- layout
	}
}

void function AddDisplayFilter( string layout, SummaryDisplayFilter filter )
{
	file.filters[ layout ] <- filter
}

                                                                    
                 
                                                                    

void function Callback_OnLobbyDataChanged( CustomMatch_LobbyState data )
{
	Callback_OnMatchSummaryChanged( data.matches )
}

void function Callback_OnMatchSummaryChanged( array<CustomMatch_MatchHistory> matches )
{
	Signal( file.historyGrid, CUSTOM_MATCH_SUMMARY_CHANGED_SIGNAL )
	thread RefreshHistory( matches )
}

void function Callback_OnMatchStatsPushed( int endTime, CustomMatch_MatchSummary summary )
{
	CacheEntry e
	e.key = endTime
	e.value = summary
	file.cache.push( e )
	DisplaySummary( summary )

	if ( file.cache.len() > MAX_CACHE_SIZE )
		file.cache.remove( 0 )
}

                                                                    
                  
                                                                    

void function CustomMatchSummary_OnShow( var panel )
{
	file.autoSelect = true
	foreach ( layout in file.layouts )
		Hud_Hide( layout.panel )
	Hud_SetVisible( file.noHistory, Hud_GetButtonCount( file.historyGrid ) == 0 )
	AutoSelectHistoryEntry()
}

void function History_OnClick( CustomMatch_MatchHistory matchHistory )
{
	file.autoSelect = false
	DisplayHistory( matchHistory )
}

                                                                    
                          
                                                                    

int function Survival_InProgress_Display( SummaryLayout layout, array<CustomMatch_MatchTeam> teams, int index )
{
	CustomMatch_MatchTeam previousTeam = teams[ int( max( index - 1, 0 ) ) ]
	CustomMatch_MatchTeam currentTeam = teams[ index ]

	bool previousHasPlaced = previousTeam.placement > 0
	bool currentHasPlaced = currentTeam.placement > 0

	if ( !previousHasPlaced && !currentHasPlaced )
		return index
	else if ( previousHasPlaced && currentHasPlaced )
		return index + 1

	var panel = GetTeamPanel( layout.panel, index )
	Hud_Hide( panel )

	var header = Hud_GetChild( layout.panel, "Header01" )
	Hud_Show( header )

	UIPos pos1 = REPLACEHud_GetAbsPos( panel )
	UIPos pos2 = REPLACEHud_GetAbsPos( layout.panel )
	Hud_SetPos( header, pos2.x - pos1.x, pos2.y - pos1.y )

	return index + 1
}

void function Survival_InProgress_PostDisplay( SummaryLayout layout, array<CustomMatch_MatchTeam> teams )
{
	CustomMatch_MatchTeam last = teams[ teams.len() - 1 ]
	bool hasPlaced = last.placement > 0
	if ( !hasPlaced )
	{
		Hud_Hide( Hud_GetChild( layout.panel, "Header01" ) )
		Hud_Hide( GetTeamPanel( layout.panel, layout.maxTeams ) )
	}
}

                                                                    
                           
                                                                    

void function RefreshHistory( array<CustomMatch_MatchHistory> matches )
{
	                                                              
	EndSignal( file.historyGrid, CUSTOM_MATCH_SUMMARY_CHANGED_SIGNAL )
	while ( !IsFullyConnected() )
	{
		WaitFrame()
	}

	int fakeTimeDays = GetFakeTimeInSeconds()
	float clTime = ClientTime()
	int unixTime = GetUnixTimestamp() - fakeTimeDays

	Hud_InitGridButtons( file.historyGrid, matches.len() )
	foreach( int i, CustomMatch_MatchHistory match in matches )
	{
		var button = Hud_GetButton( file.historyGrid, i )
		float gameTime = match.endTime > 0 ? ( clTime - ( unixTime - match.endTime ) ) : RUI_BADGAMETIME
		HudElem_SetRuiArg( button, "matchIndex", match.matchNumber )
		HudElem_SetRuiArg( button, "finishTime", gameTime, eRuiArgType.GAMETIME )

		Hud_ClearEventHandlers( button, UIE_CLICK )
		Hud_AddEventHandler( button, UIE_CLICK, void function( var _ ) : ( match ) { History_OnClick( match ) } )

		                               
		if ( Hud_IsSelected( button ) )
			Hud_HandleEvent( button, UIE_CLICK )
	}
	Hud_SetVisible( file.noHistory, Hud_GetButtonCount( file.historyGrid ) == 0 )

	if ( Hud_IsVisible( file.panel ) )
		AutoSelectHistoryEntry()
}

void function DisplayHistory( CustomMatch_MatchHistory matchHistory )
{
	Hud_Show( file.spinner )
	SetSummaryLayoutVisible( file.layoutStyle, false )

	foreach ( CacheEntry e in file.cache )
	{
		if ( matchHistory.endTime == e.key )
		{
			DisplaySummary( e.value )
			return
		}
	}
	CustomMatch_GetMatchStats( matchHistory.endTime )
}

void function DisplaySummary( CustomMatch_MatchSummary summary )
{
	int summaryType = summary.inProgress ? eSummaryType.MATCH_IN_PROGRESS : eSummaryType.MATCH_FINISHED
	file.layoutStyle = GetSummaryStyle( summary.gamemode, summaryType )
	SummaryLayout layout = GetSummaryLayout( file.layoutStyle )

	SummaryDisplayFilter filter
	if ( file.layoutStyle in file.filters )
		filter = file.filters[ file.layoutStyle ]

	UpdateDisplay( summary, layout, filter )
	SetSummaryLayoutVisible( file.layoutStyle, true )
	Hud_Hide( file.spinner )
}

void function UpdateDisplay( CustomMatch_MatchSummary matchSummary, SummaryLayout layout, SummaryDisplayFilter filter )
{
	int teamCount = matchSummary.teams.len()
	if ( teamCount > layout.maxTeams )
	{
		Warning( "Layout \"%s\" does not support %i teams.", file.layoutStyle, teamCount )
		teamCount = layout.maxTeams
	}

	                                                           
	                                                                
	matchSummary.teams.sort( SortByPlacement )

	int panelIndex = 0
	foreach ( int i, CustomMatch_MatchTeam team in matchSummary.teams )
	{
		if ( i >= teamCount )
			continue

		if ( filter.DisplayUpdate != null )
			panelIndex = filter.DisplayUpdate( layout, matchSummary.teams, i )
		else
			panelIndex = i

		var panel = GetTeamPanel( layout.panel, panelIndex )
		Hud_Show( panel )
		ApplyTeamPanel( panel, team )
	}

	for ( int i = panelIndex + 1; i < layout.maxTeams; ++i )
		Hud_Hide( GetTeamPanel( layout.panel, i ) )

	if ( filter.PostDisplayUpdate != null )
		filter.PostDisplayUpdate( layout, matchSummary.teams )
}

void function SetSummaryLayoutVisible( string style, bool visible )
{
	if( style != "" )
		Hud_SetVisible( GetSummaryLayout( style ).panel, visible )
}

string function GetSummaryStyle( string gamemode, int type )
{
	return gamemode + format( "%02u", type )
}

SummaryLayout function GetSummaryLayout( string style )
{
	if ( file.layouts.len() == 0 )
	{
		Warning( "Custom match summary layouts missing: Restoring layouts." )
		AddSummaryLayouts()
	}

	if ( style == "" )
		return file.layouts[ DEFAULT_LAYOUT ]

	if ( style in file.layouts )
		return file.layouts[ style ]

	Warning( "No layout found for style \"" + style + "\"" )
	return file.layouts[ DEFAULT_LAYOUT ]
}

var function GetTeamPanel( var panel, int index )
{
	return Hud_GetChild( panel, format( "Team%02u", index ) )
}

int function SortByPlacement( CustomMatch_MatchTeam a, CustomMatch_MatchTeam b )
{
	return a.placement > b.placement ? 1 : -1
}

void function AutoSelectHistoryEntry()
{
	var selected = Hud_GetSelectedButton( file.historyGrid )
	if ( !file.autoSelect && IsValid( selected ) )
		return

	int count = Hud_GetButtonCount( file.historyGrid )
	if ( count )
	{
		if ( IsValid( selected ) )
			Hud_SetSelected( selected, false )

		var last = Hud_GetButton( file.historyGrid, count - 1 )
		Hud_HandleEvent( last, UIE_CLICK )
		Hud_SetSelected( last, true )
	}
}

void function ApplyTeamPanel( var panel, CustomMatch_MatchTeam team )
{
	int teamIndex = team.index - TEAM_MULTITEAM_FIRST
	string teamName = team.name == "" ? Localize( "#TEAM_NUMBERED", teamIndex + 1 ) : team.name
	HudElem_SetRuiArg( panel, "teamName", teamName )
	HudElem_SetRuiArg( panel, "kills", team.killCount )
	HudElem_SetRuiArg( panel, "teamPosition", team.placement )

	foreach ( int i, CustomMatch_MatchPlayer player in team.players )
	{
		if ( i >= MAX_TEAM_SIZE )
			continue

		ItemFlavor itemFlavor = GetItemFlavorByHumanReadableRef( player.character )
		Assert( ItemFlavor_GetType( itemFlavor ) == eItemType.character )
		if ( ItemFlavor_GetType( itemFlavor ) != eItemType.character )
		{
			Warning( "Match history reported an invalid player character: \"" + player.character + "\"." )
			continue
		}

		HudElem_SetRuiArg( panel, "playerImage" + i, CharacterClass_GetGalleryPortrait( itemFlavor ), eRuiArgType.IMAGE )
		HudElem_SetRuiArg( panel, "playerAlive" + i, player.status == 0 )
	}

	for ( int i = team.players.len(); i < MAX_TEAM_SIZE; ++i )
	{
		HudElem_SetRuiArg( panel, "playerImage" + i, $"", eRuiArgType.IMAGE )
		HudElem_SetRuiArg( panel, "playerAlive" + i, false )
	}
}