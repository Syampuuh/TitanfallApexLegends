global function InitTeamsScoreboardPanel

global function UI_SetScoreboardTeamData
global function UI_ClearLocalPlayerToolTip
global function UI_ToggleReportTooltip

struct PlayerButtonData
{
	int teamId
	int row
}

struct PanelGroupData
{
	array< var > playerButtons

	array< var > teamPlayers
	array< var > teamHeaders
	array< var > teamFrames

	int teams
	int playersPerTeam
	int localPlayersTeam
	int gamemode

	float teamWidth
	float teamHeight
	int teamsPerRow
	int maxFittableRows

	float firstTeamOffsetX
	float firstTeamOffsetY

	float vPadding
	float hPadding

	int lastLastPlayerRow = -1
}

struct
{
	var menu
	var panel

	array<int> teams
	table< var , PanelGroupData > panels
	table< var , PlayerButtonData > playerButtonData

} file

enum scoreboardHeaderTypes
{
	DEFAULT,
	CONTROL,
	ARENA,
                         
           
       
	TINY,
                       
                
       
}

array< string > scoreboardHeaderClasses = [
	"TeamHeader",
	"ControlHeader",
	"ArenaHeader",
                         
                  
       
	"TinyHeader"
                       
                       
       
]

const int PLAYERS_Y_PADDING_OFFSET = 1
  
                             
  

void function InitTeamsScoreboardPanel( var panel )
{
	file.panel = panel
	file.menu = GetParentMenu( panel )

	SetPanelTabTitle( file.panel, "#TAB_SCOREBOARD" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnShowScoreboardPanel )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnHideScoreboardPanel )


	array<var> teamPlayers = GetPanelElementsByClassname( panel, "TeamPlayer" )

	foreach( var teamPlayer in teamPlayers)
		Hud_AddKeyPressHandler( teamPlayer, PlayerButton_OnKeyPress )

	var parentMenu = GetParentMenu( panel )
	if( parentMenu == GetMenu( "DeathScreenMenu" ) )                                              
		InitDeathScreenPanelFooter( panel, eDeathScreenPanel.SCOREBOARD)
	else
		AddPanelFooterOption( panel, LEFT, BUTTON_B, false, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}

void function OnShowScoreboardPanel( var panel )
{
	PanelGroupData data
	file.panels[panel] <- data

	RunClientScript( "ClientCallback_Teams_SetScoreboardData", panel )

	if( DeathScreenIsOpen() )
		RunClientScript( "UICallback_ShowScoreboard", DeathScreenGetHeader() )
}

void function OnHideScoreboardPanel( var panel )
{
	foreach( var playerButton in file.panels[panel].playerButtons)
	{
		Hud_ClearToolTipData( playerButton )
	}

	file.panels[panel].playerButtons.clear()                   
	file.playerButtonData.clear()
	RunClientScript( "ClientCallback_Teams_CloseScoreboard" )
}

float function GetTeamMinWidth( var panel, float maxFillWidth )
{
	float hPadding = file.panels[panel].hPadding
	int teams = file.panels[panel].teams
	int playersPerTeam = file.panels[panel].playersPerTeam
	int maxFittableRows = file.panels[panel].maxFittableRows

	int teamsPerRow = GetTotalTeamsPerRow( panel )

	float screenSizeYFrac =  GetScreenSize().height / 1080.0
	return max( ( ( maxFillWidth - ( hPadding * teamsPerRow) ) / teamsPerRow), 345.0 * screenSizeYFrac )                                                              
}


int function GetTotalTeamsPerRow( var panel  )
{
	int teams = file.panels[panel].teams
	int playersPerTeam = file.panels[panel].playersPerTeam
	int maxFittableRows = file.panels[panel].maxFittableRows

	if( file.panels[panel].gamemode == 4 )
		return teams

	return int( max( ceil( float( teams ) / float( maxFittableRows ) ), 1.0 ) )
}

int function GetTotalFittableRows( var panel, int vSpaceTakenByHeaders, int vSpaceTakenByPlayers, float avialableHeight )
{
	float vPadding = file.panels[panel].vPadding
	int teamVerticalSpace = vSpaceTakenByHeaders + vSpaceTakenByPlayers + int( vPadding )

	return int( max( floor( avialableHeight / teamVerticalSpace ), 1 ) )                                       
}

float function GetTeamMaxFillWidth( var panel )
{
	int teams = file.panels[panel].teams
	int playersPerTeam = file.panels[panel].playersPerTeam
	int maxFittableRows = file.panels[panel].maxFittableRows
	int mode = file.panels[panel].gamemode

	float screenSizeXFrac =  GetScreenSize().width / 1920.0
	float screenSizeYFrac =  GetScreenSize().height / 1080.0
	float screenWidth = min( GetScreenSize().width, 1920 * screenSizeYFrac )
	float width = 0

	int teamsPerRow = GetTotalTeamsPerRow( panel )

	                            
	if(mode == 4)
		return screenWidth * 0.9

	switch( teamsPerRow )
	{
		case 1:
			width = screenWidth * 0.45
			break
		case 2:
			width = screenWidth * 0.62                                                            
			break
		case 3:
		default:
			width = screenWidth * 0.9
			break
	}
	return width
}

                                                                            
void function HideAll( var panel)
{
	                 
	array<var> items = GetPanelElementsByClassname( panel, scoreboardHeaderClasses[scoreboardHeaderTypes.DEFAULT] )
	foreach( var item in items)
		Hud_SetVisible( item, false )

	                 
	items = GetPanelElementsByClassname( panel, scoreboardHeaderClasses[scoreboardHeaderTypes.CONTROL] )
	foreach( var item in items)
		Hud_SetVisible( item, false )

	                
	items = GetPanelElementsByClassname( panel, scoreboardHeaderClasses[scoreboardHeaderTypes.ARENA] )
	foreach( var item in items)
		Hud_SetVisible( item, false )

	              
	items = GetPanelElementsByClassname( panel, scoreboardHeaderClasses[scoreboardHeaderTypes.TINY] )
	foreach( var item in items)
		Hud_SetVisible( item, false )

                         
                  
                                                                                                       
                             
                                
       

                       
                   
                                                                                                             
                             
                                
       


	         
	items = GetPanelElementsByClassname( panel, "TeamPlayer" )
	foreach( var item in items)
		Hud_SetVisible( item, false )

	        
	items = GetPanelElementsByClassname( panel, "TeamFrameGeneric" )
	foreach( var item in items)
		Hud_SetVisible( item, false )

	items = GetPanelElementsByClassname( panel, "TeamFrameTiny" )
	foreach( var item in items)
		Hud_SetVisible( item, false )
}

bool function ShouldUseTinyMode( var panel )
{
	int teams = file.panels[panel].teams
	return teams > 10
}

string function GetHeaderClassName( var panel )
{
	int gamemode = file.panels[panel].gamemode
	int teams = file.panels[panel].teams
	string className = scoreboardHeaderClasses[scoreboardHeaderTypes.DEFAULT]

	switch(gamemode)
	{
		case 0:
			if( ShouldUseTinyMode( panel ) )
				className = scoreboardHeaderClasses[scoreboardHeaderTypes.TINY]
			else
				className = scoreboardHeaderClasses[scoreboardHeaderTypes.DEFAULT]
			break
		case 1:
			className = scoreboardHeaderClasses[scoreboardHeaderTypes.ARENA]
			break
		case 2:
			className = scoreboardHeaderClasses[scoreboardHeaderTypes.CONTROL]
			break
                          
         
                                                                      
        
        
                        
         
                                                                            
        
        
	}

	return className
}

string function GetFrameClassName( var panel )
{
	if( ShouldUseTinyMode(panel ) )
		return "TeamFrameTiny"

	return "TeamFrameGeneric"
}

                                                               
void function CheckHeaderCountRestraints( var panel )
{
	array<var> teamHeaders = file.panels[panel].teamHeaders
	array<var> teamPlayers = file.panels[panel].teamPlayers
	array<var> teamFrames = file.panels[panel].teamFrames
	int teams = file.panels[panel].teams
	int playersPerTeam = file.panels[panel].playersPerTeam

	int playersNeeded = teams * playersPerTeam

	Assert( !( playersNeeded > teamPlayers.len() ), "To many players in mode for scoreboard to support. Add more Player Buttons in teams_scoreboard.res" )
	Assert( !( teams > teamHeaders.len() ), "To many teams in mode for scoreboard to support. Add more Team Headers in teams_scoreboard.res" )
	if( !ShouldUseTinyMode( panel ) )
		Assert( !( teams > teamFrames.len() ), "To many teams in mode for scoreboard to support. Add more Team Frames in teams_scoreboard.res" )
}

float function GetHPadding( var panel )
{

	float screenSizeFrac = GetScreenSize().height / 1080.0
	if( ShouldUseTinyMode(panel ) )
		return 22.0 * screenSizeFrac

	return 35.0 * screenSizeFrac
}

float function GetVPadding( var panel )
{
	int gamemode = file.panels[panel].gamemode

	float screenSizeFrac = GetScreenSize().height / 1080.0
	if( ShouldUseTinyMode(panel ) )
		return 22.0 * screenSizeFrac

	return 25.0 * screenSizeFrac
}

void function UI_ClearLocalPlayerToolTip( var panel, int localPlayersRow )
{
	array<var> teamPlayers = file.panels[panel].teamPlayers

	if( file.panels[panel].lastLastPlayerRow != -1 )
	{
		int previous = ( file.panels[panel].localPlayersTeam * file.panels[panel].playersPerTeam ) + file.panels[panel].lastLastPlayerRow
		SetReportTooltip( teamPlayers[previous] )
	}
	int new = ( file.panels[panel].localPlayersTeam * file.panels[panel].playersPerTeam ) + localPlayersRow
	Hud_ClearToolTipData( teamPlayers[ new ] )

	file.panels[panel].lastLastPlayerRow = localPlayersRow
}

                                                                                   
void function UI_SetScoreboardTeamData( var panel, int teams, int playersPerTeam, int localPlayersTeam, int gamemode )                           
{
	file.panels[panel].teams = teams
	file.panels[panel].playersPerTeam = playersPerTeam
	file.panels[panel].localPlayersTeam = localPlayersTeam
	file.panels[panel].gamemode = gamemode
	file.panels[panel].vPadding = GetVPadding( panel )
	file.panels[panel].hPadding = GetHPadding( panel )
	HideAll( panel )

	file.panels[panel].teamFrames =  GetPanelElementsByClassname( panel, GetFrameClassName( panel ) )
	array<var> teamHeaders = GetPanelElementsByClassname( panel, GetHeaderClassName( panel ) )
	file.panels[panel].teamHeaders = teamHeaders
	array<var> teamPlayers = GetPanelElementsByClassname( panel, "TeamPlayer" )
	file.panels[panel].teamPlayers = teamPlayers

	CheckHeaderCountRestraints( panel )


	UISize screenSize = GetScreenSize()

	float screenSizeXFrac =  GetScreenSize().width / 1920.0
	float screenSizeYFrac =  GetScreenSize().height / 1080.0


	float tabsHeight = 85.0 * screenSizeYFrac
	float buttonLegendHeight = 65.0 * screenSizeYFrac

	float avialableHeight = screenSize.height - tabsHeight - buttonLegendHeight

	int headerHeight = Hud_GetHeight( teamHeaders[ 0 ] )
	int playersHeight = Hud_GetHeight( teamPlayers[ 0 ] ) * playersPerTeam + ( PLAYERS_Y_PADDING_OFFSET * ( playersPerTeam - 1 ) )

	                                                     
	int maxFittableRows = GetTotalFittableRows( panel, headerHeight, playersHeight, avialableHeight )
	file.panels[panel].maxFittableRows = maxFittableRows
	float totalPaddingsToUse = max(teams - 1, 0)
	float maxFillWidth = GetTeamMaxFillWidth( panel )
	float minTeamWidth = GetTeamMinWidth( panel, maxFillWidth )
	printt(maxFillWidth / teams , minTeamWidth, maxFillWidth)
	float teamWidth = clamp( maxFillWidth / teams , minTeamWidth, maxFillWidth )
	float teamHeight = float( headerHeight + playersHeight )
	file.panels[panel].teamWidth = teamWidth
	file.panels[panel].teamHeight = teamHeight

	int teamsPerRow = GetTotalTeamsPerRow( panel )
	float totalRows = ceil( float( teams ) / float( teamsPerRow ) )
	file.panels[panel].teamsPerRow = teamsPerRow                    
	file.panels[panel].firstTeamOffsetX = -1 * ( min( GetScreenSize().width , 1920 * screenSizeYFrac ) - ( teamsPerRow * teamWidth ) - ( max(teamsPerRow - 1, 0) * file.panels[panel].hPadding  ) ) / 2.0

	float vSpaceTakenByHeaders = headerHeight * totalRows
	float vSpaceTakenByPlayers = playersHeight * totalRows
	float vSpaceTakenByPadding = max(totalRows - 1, 0) * file.panels[panel].vPadding
	file.panels[panel].firstTeamOffsetY = -1 * ( tabsHeight + ( ( avialableHeight - vSpaceTakenByHeaders - vSpaceTakenByPlayers - vSpaceTakenByPadding ) / 2 ) )
	int teamsAdded = 0

	if( localPlayersTeam >= 0)
	{
		var teamHeader = UpdateTeamHeader( panel, localPlayersTeam, teamsAdded )

		for( int playerRow = 0; playerRow <= playersPerTeam - 1; playerRow++ )
		{
			UpdateTeamPlayer( panel, teamHeader, teamsAdded, localPlayersTeam, playerRow )
		}
		teamsAdded++
	}

	for( int teamIndex = 0; teamIndex < teams; teamIndex++ )
	{
		if( teamIndex ==  localPlayersTeam )
			continue

		var teamHeader = UpdateTeamHeader( panel, teamIndex, teamsAdded )

		for( int playerRow = 0; playerRow <= playersPerTeam - 1; playerRow++ )
		{
			UpdateTeamPlayer( panel, teamHeader,teamsAdded, teamIndex, playerRow )
		}
		teamsAdded++
	}

}

                                                                                                                                                           
var function UpdateTeamHeader( var panel, int teamIndex, int teamsAdded ){
	array<var> teamPlayers = GetPanelElementsByClassname( panel, "TeamPlayer" )

	int playersPerTeam = file.panels[panel].playersPerTeam
	int teamsPerRow = file.panels[panel].teamsPerRow
	float firstTeamOffsetX = file.panels[panel].firstTeamOffsetX
	float firstTeamOffsetY = file.panels[panel].firstTeamOffsetY
	float teamWidth = file.panels[panel].teamWidth
	array<var> teamHeaders = file.panels[panel].teamHeaders
	float vPadding = file.panels[panel].vPadding
	float hPadding = file.panels[panel].hPadding

	var teamHeader = teamHeaders[ teamsAdded ]
	Hud_SetWidth( teamHeader, teamWidth )
	Hud_SetVisible( teamHeader, true )

	if( teamsAdded != 0 )
	{
		if( teamsAdded % teamsPerRow == 0 )                       
		{
			float onRowNumber = floor( teamsAdded / teamsPerRow )
			float pinToRow = max( onRowNumber - 1.0, 0)
			int previousPlayerRowIndex = int( pinToRow * ( teamsPerRow * playersPerTeam ) + playersPerTeam - 1 )
			var previousFirstItemLastPlayer = teamPlayers[ previousPlayerRowIndex ]

			Hud_SetPinSibling( teamHeader, Hud_GetHudName( previousFirstItemLastPlayer ) )
			Hud_SetX( teamHeader,  0 )
			Hud_SetY( teamHeader, -1 * ( Hud_GetHeight( previousFirstItemLastPlayer ) + vPadding ) )
		}
		else
		{
			Hud_SetPinSibling( teamHeader, Hud_GetHudName( teamHeaders[ teamsAdded - 1 ] ) )
			Hud_SetX( teamHeader,  -1 * ( Hud_GetWidth( teamHeaders[ teamsAdded - 1 ] ) + hPadding ) )
			Hud_SetY( teamHeader, 0 )
		}
	}
	else
	{
		                                                                      
		Hud_SetX( teamHeader, firstTeamOffsetX )
		Hud_SetY( teamHeader, firstTeamOffsetY )
	}

	var teamFrame = UpdateTeamFrame( panel, teamHeader, teamsAdded )
	RunClientScript( "UICallback_ScoreboardMenu_BindTeamHeader", teamHeader, teamFrame, teamIndex, Hud_GetWidth( teamHeader ) )

	return teamHeader
}

var function UpdateTeamFrame( var panel, var teamHeader,  int teamIndex )
{
	array<var> teamFrames = file.panels[panel].teamFrames
	float teamHeight = file.panels[panel].teamHeight
	float teamWidth = file.panels[panel].teamWidth

	var treamFrame = teamFrames[ teamIndex ]

	Hud_SetVisible( treamFrame, true )
	Hud_SetPinSibling( treamFrame, Hud_GetHudName( teamHeader ) )
	Hud_SetWidth( treamFrame, teamWidth )
	Hud_SetHeight( treamFrame, teamHeight )

	return treamFrame
}

void function UpdateTeamPlayer( var panel, var teamHeader, int teamsAdded, int teamIndex, int playerRow )
{
	array<var> teamPlayers = GetPanelElementsByClassname( panel, "TeamPlayer" )
	int playersPerTeam = file.panels[panel].playersPerTeam
	float teamWidth = file.panels[panel].teamWidth

	int startAt = ( teamsAdded * playersPerTeam )
	int playerIndex = startAt + playerRow

	if( startAt + playerRow > teamPlayers.len() - 1 )
		return

	var teamPlayerButton = teamPlayers[ startAt + playerRow ]
	SetReportTooltip( teamPlayerButton )
	Hud_SetWidth( teamPlayerButton, teamWidth )
	Hud_SetVisible( teamPlayerButton, true )



	if( playerRow == 0 )
	{
		Hud_SetPinSibling( teamPlayerButton, Hud_GetHudName( teamHeader ) )
		Hud_SetX( teamPlayerButton, 0)
		Hud_SetY( teamPlayerButton,  ( -1 * Hud_GetHeight( teamHeader ) ) )
	}
	else
	{
		Hud_SetPinSibling( teamPlayerButton, Hud_GetHudName( teamPlayers[ playerIndex - 1 ] ) )
		Hud_SetX( teamPlayerButton, 0 )
		Hud_SetY( teamPlayerButton, ( -1 * Hud_GetHeight( teamPlayerButton ) ) - PLAYERS_Y_PADDING_OFFSET )
	}

	PlayerButtonData playerData
	playerData.row = playerRow
	playerData.teamId = teamIndex

	file.playerButtonData[ teamPlayerButton ] <- playerData
	file.panels[panel].playerButtons.append( teamPlayerButton )

	RunClientScript( "UICallback_ScoreboardMenu_BindTeamRow", panel, teamPlayerButton, teamIndex, playerRow, teamWidth )
}

void function SetReportTooltip( var button )
{
	ToolTipData toolTipData
	toolTipData.tooltipStyle = eTooltipStyle.BUTTON_PROMPT
	toolTipData.actionHint1  = "#X_BUTTON_REPORT"

	Hud_SetToolTipData( button, toolTipData )
}

void function UI_ToggleReportTooltip( var button, bool toggle )
{
	if( toggle )
		SetReportTooltip( button )
	else
		Hud_ClearToolTipData( button )
}

bool function PlayerButton_OnKeyPress( var button, int keyId, bool isDown )
{
	if ( !isDown )
		return false
	if ( keyId == MOUSE_RIGHT || keyId == BUTTON_X )
	{
		RunClientScript( "UICallback_Scoreboard_OnReportClicked", button, file.playerButtonData[button].teamId, file.playerButtonData[button].row )

		return true
	}

	return false
}
