global function PrivateMatch_Init
global function IsPrivateMatchLobby
global function PrivateMatch_RegisterNetworking
global function PrivateMatch_GetSelectedPlaylistName

#if SERVER || CLIENT
global function PrivateMatch_CanAssignPlayers
global function PrivateMatch_CanAssignSelf
global function PrivateMatch_CanRenameTeam
global function PrivateMatch_GetMaxTeamsForSelectedGamemode

                 
global function PrivateMatch_IsObserverHighlightEnabled
#endif

#if SERVER
                                              
                                               
                                                  

                 
                                       
                                                     
                                                      
                                                      

                                                               
                                                                   
                                                           
                                                            
                                                                      
                                                        

                                                        
                                                     
                                                           
                                                        
                                                      
                                                   
                                                        
                                                           
                                                             
                                                      
                                                      
                                                         
                                                        
                                                              
                                                          
                                                              

#endif


#if CLIENT
global function PrivateMatch_ClientFrame
global function PrivateMatch_GetPlayerTeamStats
global function PrivateMatch_GetTeamName

global function ServerCallback_EnableGameStatusMenu
global function ServerCallback_PrivateMatch_ManageHighlights
global function ServerCallback_PrivateMatch_SquadEliminated
global function PrivateMatch_OpenGameStatusMenu
global function PrivateMatch_ToggleHighlights
global function PrivateMatch_SortPlayersByName
global function PrivateMatch_ToggleSurveyRing

global function PrivateMatch_BeginStartMatch

global function PrivateMatch_ClientOnSquadEliminated
#endif

#if UI
global function PrivateMatch_CreateMatchEndEarlyDialog
#endif

global const string MAX_PLAYERS_PLAYLIST_VAR = "max_players"
global const string MAX_TEAMS_PLAYLIST_VAR = "max_teams"
global const int PRIVATEMATCH_ISREADY_BIT = 1
global const int PRIVATEMATCH_ISPRELOADING_BIT = 2

global const string CUSTOM_AIM_ASSIST_CONVAR_NAME = "sv_private_assist_style_override"
global const string GLOBAL_AIM_ASSIST_CONVAR_NAME = "sv_tournament_assist_style_override"
global const string CUSTOM_ANONYMOUS_MODE_CONVAR_NAME = "sv_tournament_anonymous_mode"
global const string OBSERVER_PRESET_TEAM_CONVAR_NAME = "cl_observer_preset_team"
global const string OBSERVER_PRESET_PLAYERSLOT_CONVAR_NAME = "cl_observer_preset_playerSlot"
global const string OBSERVER_PRESET_PLAYERHASH_CONVAR_NAME = "cl_observer_preset_playerHash"

const string WAYPOINTTYPE_PLAYERTEAMSTATS = "team_stats"

const int WP_STRING_INDEX_PLAYERNAME = 0
const int WP_STRING_INDEX_TEAMNAME = 1

const int WP_INT_INDEX_PLAYERINDEX = 0
const int WP_INT_INDEX_PLACEMENT = 1
const int WP_INT_INDEX_TEAMINDEX = 2
const int WP_INT_INDEX_PLAYERKILLS = 3
const int WP_INT_INDEX_PLAYERDAMAGE = 4
const int WP_INT_INDEX_SURVIVALTIME = 5
const int WP_INT_INDEX_PLAYERASSISTS = 6

global const int TEAM_SPECTATOR_MAX_PLAYERS = 10

const asset PM_CHAMPION_SCREEN = $"ui/private_match_champion_screen.rpak"

           
const string NV_OBSERVER_HIGHLIGHT_ENABLED = "PrivateMatch_Observer_HighlightEnabled"
const float PM_OBSERVER_HIGHLIGHT_TOGGLE_DEBOUNCE = 0.5

global struct RosterStruct
{
	var           headerPanel
	var           listPanel
	int           teamIndex
	int           teamSize
	int           teamDisplayNumber
	array<entity> playerRoster

	array<var>      _listButtons

	array<PrivateMatchStatsStruct> playerPlacementData
}

struct
{
	string		selectedPlaylist = ""
	int			playlistMaxTeams
	int			playlistTeamSize
	int			lastObserverCommand = -1
	PrivateMatchChatConfigStruct chatConfig
	
	table< int, PrivateMatchStatsStruct > privateMatchStats

	array<int> teamFinalPlacementArray = []

	bool 		cachedAimAssistOverride = false

	table signalDummy = {}
} file



void function PrivateMatch_Init()
{
	if ( !IsPrivateMatch() && !IsPrivateMatchLobby() )
		return

	array<string> privateMatchPlaylists = GetVisiblePlaylistNames( true )

	#if SERVER
		                                                           
		                                                      
		                                                                                      
		                                                                        
		                                                                                              

		                                                           

		                                                                                     

		                                                                                 

		                         

		                                                    
	#endif         

	#if CLIENT
		Waypoints_RegisterCustomType( WAYPOINTTYPE_PLAYERTEAMSTATS, InstancePlayerTeamStats )
		AddOnSpectatorTargetChangedCallback( OnSpectatorTargetChanged )
		AddFreeCamSpectateStartedCallback( OnSpectatorModeChanged )
		AddFreeCamSpectateEndedCallback( OnSpectatorModeChanged )
		RegisterConCommandTriggeredCallback( "toggle_observer_highlight", PrivateMatch_ToggleHighlights )
		RegisterConCommandTriggeredCallback( "toggle_observer_ring_survey", PrivateMatch_ToggleSurveyRing )
	#endif
		
	#if CLIENT || SERVER
	
		              
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchKickPlayer", "entity" )
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchSetPlayerTeam", "entity", "int", TEAM_UNASSIGNED, TEAM_MULTITEAM_LAST )
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchToggleStartMatch" )
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchSetStartMatch", "bool" )
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchToggleReady" )
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchSetReady", "bool" )
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchSetPreloading", "bool" )
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchToggleAssignSelf" )
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchToggleTeamRenaming" )
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchToggleAdminOnlyChat" )
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchToggleAimAssist" )
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchToggleAnonymousMode" )
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchSetTeamName", "int", 0, INT_MAX, "string" )
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchSetPlaylist", "string" )
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchSetAdminConfig", "int", 0, ACM_COUNT, "bool" )
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchEndMatchEarly" )
	
		                 
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchChangeObserverTarget", "entity" )
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchToggleObserverHighlights" )
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchToggleSurveyRing" )
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchRefreshSurveyRing" )
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchReportObserverTargetChanged" )
		Remote_RegisterServerFunction( "ClientCallback_RefreshObserverHighlights" )
	#endif

	int maxTeams
}

void function PrivateMatch_RegisterNetworking()
{
	RegisterNetworkedVariable( "canAssignPlayers", SNDC_GLOBAL, SNVT_BOOL, false )
	RegisterNetworkedVariable( "canAssignSelf", SNDC_GLOBAL, SNVT_BOOL, true )
	RegisterNetworkedVariable( "adminOnlyChat", SNDC_GLOBAL, SNVT_BOOL, true )
	RegisterNetworkedVariable( "canPlayersRenameTeams", SNDC_GLOBAL, SNVT_BOOL, false )
	RegisterNetworkedVariable( "readiness", SNDC_PLAYER_GLOBAL, SNVT_BIG_INT, 0 )
	RegisterNetworkedVariable( "selectedPlaylistIndex", SNDC_GLOBAL, SNVT_INT, -1 )
	RegisterNetworkedVariable( "startCountdown", SNDC_GLOBAL, SNVT_INT, -1 )
	RegisterNetworkedVariable( "lastSquadEliminated", SNDC_GLOBAL, SNVT_INT, -1 )

	Remote_RegisterClientFunction( "ServerCallback_EnableGameStatusMenu", "bool" )
	Remote_RegisterClientFunction( "ServerCallback_PrivateMatch_ManageHighlights" )
	Remote_RegisterClientFunction( "ServerCallback_PrivateMatch_SquadEliminated", "int", TEAM_INVALID, 60, "int", 0, 60 )
	RegisterNetworkedVariable( NV_OBSERVER_HIGHLIGHT_ENABLED, SNDC_PLAYER_GLOBAL, SNVT_BOOL, false )


	#if CLIENT || SERVER
		RegisterNetworkedVariable( NV_OBSERVER_SURVERY_RING_ENABLED, SNDC_PLAYER_GLOBAL, SNVT_BOOL, false )
	#endif

	#if SERVER
		                              
		                                       
	#endif

	#if CLIENT
		RegisterNetVarIntChangeCallback( "selectedPlaylistIndex", OnSelectedPlaylistIndexChanged )
		RegisterNetVarIntChangeCallback( "startCountdown", OnStartCountdownChanged )

		RegisterNetVarBoolChangeCallback( NV_OBSERVER_HIGHLIGHT_ENABLED, ObserverHighlightEnableChanged )

		AddCallback_OnGameStateChanged( PrivateMatch_OnGameStateChanged )
		RegisterNetVarIntChangeCallback( "lastSquadEliminated", PrivateMatch_ClientOnSquadEliminated )
	#endif
}

#if CLIENT

string function PrivateMatch_GetTeamName( int teamIndex )
{
	Assert( teamIndex >= TEAM_MULTITEAM_FIRST )
	string teamName = GameRules_GetTeamName( teamIndex )
	return teamName != "" ? teamName : Localize( "#TEAM_NUMBERED", teamIndex - 1 )
}

void function PrivateMatch_BeginStartMatch()
{
	if( !HasMatchAdminRole() || PrivateMatch_IsCountdownRunning() )
		return

	                                                                                    
	                                                                  
	  	                                                                             
	int maxTeams = PrivateMatch_GetMaxTeamsForSelectedGamemode()
	for ( int i = TEAM_MULTITEAM_FIRST; i < TEAM_MULTITEAM_FIRST + maxTeams; ++i )
	{
		if( PrivateMatch_GetTeamName( i ) != GameRules_GetTeamName( i ) )
		{
			Remote_ServerCallFunction( "ClientCallback_PrivateMatchSetTeamName", i, PrivateMatch_GetTeamName( i ) )
		}
	}

	if( !PrivateMatch_IsCountdownRunning() )
		Remote_ServerCallFunction( "ClientCallback_PrivateMatchToggleStartMatch" )
}

int function PrivateMatch_SortPlayersByName( entity a, entity b )
{
	if ( a.GetPlayerName() > b.GetPlayerName() )
		return 1

	if ( a.GetPlayerName() < b.GetPlayerName() )
		return -1

	return 0
}

void function PrivateMatch_ClientFrame()
{
	PerfStart( PerfIndexClient.PrivateLobbyThread )
	array<entity> players = GetPlayerArrayIncludingSpectators()

	table< int, array< entity > > teamPlayersMap
	foreach ( player in players )
	{
		if ( !(player.GetTeam() in teamPlayersMap) )
			teamPlayersMap[player.GetTeam()] <- []

		teamPlayersMap[player.GetTeam()].append( player )
	}

	foreach ( teamIndex, teamRoster in teamPlayersMap )
	{
		teamPlayersMap[teamIndex].sort( PrivateMatch_SortPlayersByName )
	}

	PrivateMatch_TeamRosters_Update( teamPlayersMap )

	PerfEnd( PerfIndexClient.PrivateLobbyThread )
}

void function InstancePlayerTeamStats( entity wp )
{
	PrivateMatchStatsStruct privateMatchStats
	privateMatchStats.platformUid = wp.GetWaypointGroupName()
	privateMatchStats.playerName = wp.GetWaypointString( WP_STRING_INDEX_PLAYERNAME )
	privateMatchStats.teamName = wp.GetWaypointString( WP_STRING_INDEX_TEAMNAME )
	privateMatchStats.teamPlacement = wp.GetWaypointInt( WP_INT_INDEX_PLACEMENT )
	privateMatchStats.teamNum = wp.GetWaypointInt( WP_INT_INDEX_TEAMINDEX )
	privateMatchStats.kills = wp.GetWaypointInt( WP_INT_INDEX_PLAYERKILLS )
	privateMatchStats.damageDealt = wp.GetWaypointInt( WP_INT_INDEX_PLAYERDAMAGE )
	privateMatchStats.survivalTime = wp.GetWaypointInt( WP_INT_INDEX_SURVIVALTIME )
	privateMatchStats.assists = wp.GetWaypointInt( WP_INT_INDEX_PLAYERASSISTS )

	int playerIndex = wp.GetWaypointInt( WP_INT_INDEX_PLAYERINDEX )
	file.privateMatchStats[playerIndex] <- privateMatchStats
}


PrivateMatchStatsStruct ornull function PrivateMatch_GetPlayerTeamStats( int playerIndex )
{
	if ( !(playerIndex in file.privateMatchStats) )
		return null

	return file.privateMatchStats[playerIndex]
}

void function ServerCallback_EnableGameStatusMenu( bool doEnable )
{
	RunUIScript( "EnablePrivateMatchGameStatusMenu", doEnable )

	if ( doEnable == false )
		RunUIScript( "ClosePrivateMatchGameStatusMenu", null )
}

void function PrivateMatch_OpenGameStatusMenu()
{
	if ( GetLocalClientPlayer().GetTeam() == TEAM_SPECTATOR )
		RunUIScript( "OpenPrivateMatchGameStatusMenu", null )
}

void function PrivateMatch_ToggleHighlights( entity player )
{
	if ( player.GetTeam() == TEAM_SPECTATOR )
	{
		Remote_ServerCallFunction( "ClientCallback_PrivateMatchToggleObserverHighlights" )
	}
}

void function PrivateMatch_ToggleSurveyRing( entity player )
{
	if( player.GetTeam() == TEAM_SPECTATOR )
	{
		printt( "OBS_SURVEY: toggling Ring Survey for observer "+player )
		Remote_ServerCallFunction( "ClientCallback_PrivateMatchToggleSurveyRing" )
	}
}

#endif         

#if SERVER
                                                                       
 
	                                      
	 
		                                                                       
			                                  
	 
 
#endif

void function PrivateMatch_SetUpTeamRosters( string playlistName )
{
	file.selectedPlaylist = playlistName
	#if SERVER
		                                                                                   
	#endif

	int maxPlayers = GetPlaylistVarInt( file.selectedPlaylist, MAX_PLAYERS_PLAYLIST_VAR, 60 )
	file.playlistMaxTeams = GetPlaylistVarInt( file.selectedPlaylist, MAX_TEAMS_PLAYLIST_VAR, 20 )
	file.playlistTeamSize = maxPlayers / file.playlistMaxTeams

	#if SERVER
		                                                                                                                                                            
		                                                          
			                              
	#endif

	                                                                                                                                      
}


#if SERVER
                                                              
 
	                               

	                                 
		                                 
	    
		                                  
 



                                                             
 
	                               
	
	                                                                                 
	                                 
		                                 
	    
		                                  
 


                                            
 
	                             
		      

	                                                                     
	                                                                                                

	                                
 


                                                                            
 
	                             
		      

	                                                
	                                       
	                                           
 


                                                                                          
 
	                             
		      

	                                  
		      

	                                                  
		      

	                                                                                   

	                                             
	                                                  
 

                                                                                                           
 
	                             
		      

	                                                                           
		      

	                                                               
		      

	                                 
		      

	                                                                                                                                
		      

	                                                                                                    
	                                                                                                
		      

	                                  
 

                                                                                                        
 
	                             
		      

	                                                       
		      

	                                       
		      

	                                               
 

                          
 
	                                                             
	 
		                                              
		 
			                                                                                                            
			                                   
			 
				            
					      

				            
					                                                                          
					        

				              
				        
					     
			 
		 

		                                                                 
		                                           
		                                      
		                                       
	 

	                                                    
	                                                                                                                   
	 
		                                         
		                                                               
		                                                                                                                
		                                                    
	 
	                      

	                         
		
	                                                   

	                                                                                        
	                               
	                                                                     
	                                                                           
	                                               
	 
		                                                               
	 
	                              
	                                                    
 

                                           
 
	                                                                 

	                                                                            

	                                                                  
	 
		                                              
		      
	 
	
	             
 

                                                                          
 
	                             
		      

	                                  
		      

	                                                           
		      
		
	                                       
	 
		                
		                                                              
		                                       
		      
	 

	                                     
	
	      
 

                                                                                      
 
	                             
		      

	                                  
		      

	                                                           
		      

	                                       
	 
		              
			      
		                                                              
		                                       
		      
	 

	              
		                                     

	      
 

                                                                     
 
	                             
		      

	                                                
	                                      
	                                           
 

                                                                                 
 
	                             
		      

	                                                
	               
		                                      
	    
		                                       
	                                           
 

                                                                                      
 
	                             
		      

	                                                
	               
		                                           
	    
		                                            
	                                           
 


                                                                          
 
	                             
		      

	                                                                         
 


                                                                            
 
	                             
		      

	                                                                                         
 

                                                                             
 
	                                                           
		      

	                                                        
	                                
 

                                                                         
 
	                                                            
		      

	                                                                          
	                                                                   
 

                                                                             
 
	                                                            
		      

	                                                                    
	                                                             
 

                                                
 
	                                     
	                                              
	                                         
 

                                                                                             
 
	                                               
		      

	                         
		      

	                                         
		      

	                                                                                                             
	                                  
 

                                                                                                          
 
	                                  
		      

	                                         
		      

	                                             
	                               
	                                         

	                   
	 
		              
		 
			                                          
			                                                                                        
			     
		 
		                
		 
			                                          
			                                                                                               
			     
		 
		        
		 
			                            
			     
		 
	 

	                                                           
 

                                                                       
 
	                        
	 
		                                                                
		      
	 

	                                  
	 
		                                                                
		      
	 

	                                                    
	 
		                                                                         
		      
	 

	                                                                                                                
	                                           
	                                     
	      
 

                                                                                      
 
	                                  
		      
		
	                                                       
		      
		
	                                    
 


                                               
 
	                        
		      

	                     
	 
		                                                           
		 
			      
		 
	 

	                                             
	 
		                         
		                                
	 

	                                                                                                                                   
	                                             
	 
		                                         
		 
			                                                                                  
		 

		                                          
	 
 


                                          
 
	                           
 


                                      
 
	                                                 

	                                                                
	 
		                                 
		 
			                                                    
		 
	 

	                                             
	 
		                                         
		 
			                                                                                    
			                                                

			                                                    
			                                                                                 
		 
	 
 


                                       
 
	                                     
	                                                                                                                                        
	 
		                            
		                                       
	 
 


                                                                
 
	                                                                                   

	                                                         
		                                                               

	                                     
 


                                       
 
	                                                                                                                                                    

	                                       
	                                                          

	                   
	                                                                                          
	 
		                                                                                                   

		                           
		 
			        
		 

		                                                       

		                                                             
		                                                    

		                                                              
		 
			                                         
			                                                           
			                                                                                               
			                                                 
			                                                     
			                                                           
			                                                             
			                                                 
			                                               
			                                                         
			                                                               
			                                                                 
			                                                               
			                                                       
			                                                             
			                                                               
			                                      
			                                     
			                                                                        
			                                                              

			                                                                                                                                                                                                                                                              
			                                                      

			             
		 
	 

	                        
	 
		                                                                                               
		      
	 
	                           
 


                                                                       
 
	                                          
	                                         
	                 
	 
		                                                   
		                                                           
		                                                             
		                                                                  
		                                                                   
		                                               
		                                                     
		                                                                               
		                                                                   
		                                                               
	 

	                        
 


                                      
 
	                                                                            
	 
		                                                                               
		                                       
			        

		                                                                      
		                                                            
		                                                                
		                                                                        
		                                                                          
		                                                                  
		                                                                        
		                                                                  
		                                                                            
		                                                                
		            
	 
 


                                              
 
	                                                                            
	 
		  
				 
					                                                                            
					                                              
				 
		  

		                                                                               
		                                       
		 
			                                              
			                                     
			                                       
			                                         
			                                                            
			        
		 

		                                                       
	 
 


                                                                                                   
 
	                                                                 
	                                                        
	                                                                                
	                                                                            
	                                                          
	                                                                            
	                                                                      
	                                                                      
	                                                                             
	                                                                              
	                                                                          
	         
 

                                                
 
	                                                   
	                                                   

	                                                         
		                                         
			                                                                                                                                                  
 
#endif         


string function PrivateMatch_GetSelectedPlaylistName()
{
	int playlistIndex = GetGlobalNetInt( "selectedPlaylistIndex" )
	if ( playlistIndex > 0 )
	{
		string ornull playlistName = GetPlaylistName( playlistIndex )
		return playlistName != null ? expect string( playlistName ) : ""
	}

	return ""
}


bool function IsPrivateMatchLobby()
{
	#if UI
		                                
		if ( !IsConnected() )
			return false
	#endif

	if ( !IsPrivateMatch() )
	{
		if ( GetCurrentPlaylistName() != "private_match" )                
			return false
	}

	string mapName

	#if UI
		mapName = GetActiveLevel()
	#else
		mapName = GetMapName()
	#endif

	return IsLobbyMapName( mapName )
}

#if SERVER || CLIENT
bool function PrivateMatch_IsCountdownRunning()
{
	return GetGlobalNetInt( "startCountdown" ) >= 0
}

bool function PrivateMatch_CanAssignPlayers( entity player )
{
	if( PrivateMatch_IsCountdownRunning() )
		return false

	if ( player.HasMatchAdminRole() )
		return true

	return GetGlobalNetBool( "canAssignPlayers" )
}

bool function PrivateMatch_CanAssignSelf( entity player )
{
	if( PrivateMatch_IsCountdownRunning() )
		return false

	if ( player.HasMatchAdminRole() )
		return true

	return GetGlobalNetBool( "canAssignSelf" )
}

bool function PrivateMatch_CanRenameTeam( entity player, int teamIndex )
{
	if ( player.HasMatchAdminRole() )
		return true

	if ( player.GetTeam() != teamIndex )
		return false

	return GetGlobalNetBool( "canPlayersRenameTeams" )
}
#endif

#if CLIENT
void function OnSelectedPlaylistIndexChanged( entity player, int newIndex )
{
	if ( !IsPrivateMatchLobby() )
		return

	                                                                                     
	RunUIScript( "PrivateMatch_PlaylistNameChanged" )
}

void function OnStartCountdownChanged( entity player, int newVal )
{
	if ( !IsPrivateMatchLobby() )
		return
		
	RunUIScript( "PrivateMatch_RefreshStartCountdown", newVal )
}
#endif         

                                                                                                              
  
                                    
  
                                                                                                              

#if SERVER
                                       
 
	                            
		      

	                        
		      

	                                                                                
	                                                                                             
	                                                            

	                                                                                                        
	 
		                                                                 
		                                                                
		                                            
		                                                                                                                       

		                                       
		 
			                                                                                                                             
			                                                 
		 
	 

	                                 
	                                                                                 
 

                                                                      
 
	                                         
		      

	                                                   
		                                                                                                                                              
 

                                                                                               
 
	                        
		           

	                                                                                                
	                                            

	                                                
		           

	                                                                                                         
		                                                                                                                                                       

	                                                  
	           
 

                                                                                    
 
	                                                                                                    

	                                                          
	 
		                                                  
	 
	    
	 
		                                                 
	 
 

                                                                            
 
	                                          
		      

	                                            
 

                                                                             
 
	                                          
		      

	                                       
 

                                                                                       
 
	                                               
	                                                                             
		      

	                                                                                                                                                             
 

                                                                      
 
	                           
		      

	                                     
	                                     
		      

	                                                          
		      

	                                                                                               
	                                                                

	                                                  
	                                                                                      
 

                                                                       
 
	                           
		      

	                                     
	                                     
		      

	                                                           
		      

	                                                                                                

	                                                                 

	                                                                                      
	                                                  
 

                                                                         
 
	                                           
		      

	                                                  
 

                                                                       
 
	                           
		      

	                                     
	                                     
		      

	                                                                                                 

	                                                  
	                              
	                                              
		                                                   

	                      
	                                 
	 
		                                 
		                                 
		 
			                               
				                                                                        
			    
				                                                                                   

			                
		 
	 

	                                                                                      
 
#endif         

#if SERVER || CLIENT
bool function PrivateMatch_IsObserverHighlightEnabled( entity observer )
{
	if ( !IsValid( observer ) )
		return false

	if ( !observer.IsPlayer() )
		return false

	if ( observer.GetTeam() != TEAM_SPECTATOR )
		return false

	return observer.GetPlayerNetBool( NV_OBSERVER_HIGHLIGHT_ENABLED )
}
#endif

#if UI
void function PrivateMatch_CreateMatchEndEarlyDialog()
{
	DialogData dialogData
	dialogData.header = Localize( "GAMEMODE_ENDED" )
	dialogData.message = Localize( "#TOURNAMENT_END_MATCH_EARLY" )
	dialogData.darkenBackground = true
	dialogData.noChoiceWithNavigateBack = true
	dialogData.noChoice = true
	dialogData.useFullMessageHeight = true
	OpenDialog( dialogData )
}
#endif

#if CLIENT
void function ObserverHighlightEnableChanged( entity observer, bool newValue )
{
	if ( observer.GetTeam() != TEAM_SPECTATOR )
		return

	if ( observer == GetLocalClientPlayer() )
	{
		if ( newValue == true )
			Obituary_Print_Localized( Localize( "#TOURNAMENT_OBSERVER_HIGHLIGHT_ENABLED" ) )
		else if ( newValue == false )
			Obituary_Print_Localized( Localize( "#TOURNAMENT_OBSERVER_HIGHLIGHT_DISABLED" ) )
	}

	array<entity> players = GetPlayerArray_Alive()
	foreach ( player in players )
	{
		ManageHighlightEntity( player )
	}
}

                                                             
   
  	                                        
  	                                           
  		      
  
  	                                                               
  	                                                                     
   

void function ServerCallback_PrivateMatch_ManageHighlights()
{
	printf( "ObserverHighlightDebug: Managing observer highlights for observer %s", GetLocalClientPlayer().GetPlayerName() )

	array<entity> players = GetPlayerArray_Alive()
	foreach ( player in players )
	{
		ManageHighlightEntity( player )
	}
}

void function ServerCallback_PrivateMatch_SquadEliminated( int teamIdx, int placement )
{
	PrivateMatch_SquadEliminated( teamIdx, placement )
}

void function OnSpectatorTargetChanged( entity observer, entity prevTarget, entity newTarget )
{
	if ( observer.GetTeam() != TEAM_SPECTATOR )
		return

	if ( IsValid( newTarget ) && ( newTarget.IsPlayer() || newTarget.IsBot() ) && (newTarget != prevTarget) )
	{
		printf( "PrivateMatchObserver: Observer %s changed target to %s", observer.GetPINNucleusPid(), newTarget.GetPINNucleusPid() )
		Remote_ServerCallFunction( "ClientCallback_PrivateMatchReportObserverTargetChanged" )
		Remote_ServerCallFunction( "ClientCallback_PrivateMatchRefreshSurveyRing" )
		PrivateMatch_UpdateChatTarget()
		ShowTeamNameInHud()
	}
	else
	{
		HideTeamNameInHud()
	}

	Remote_ServerCallFunction( "ClientCallback_RefreshObserverHighlights" )

	                                                  
}

void function OnSpectatorModeChanged( entity observer )
{
	Remote_ServerCallFunction( "ClientCallback_PrivateMatchRefreshSurveyRing" )
}

entity function GetObserverPresetTarget()
{
	string presetPlayerHash = GetConVarString( OBSERVER_PRESET_PLAYERHASH_CONVAR_NAME )
	if( presetPlayerHash != "" )
	{
		foreach( entity player in GetPlayerArray() )
		{
			if( player.GetHashedEadpUserIdStr() == presetPlayerHash )
				return player
		}
	}

	int presetTeam = GetConVarInt( OBSERVER_PRESET_TEAM_CONVAR_NAME )
	if( presetTeam < 0 )
		return null

	array<entity> teamPlayers = GetPlayerArrayOfTeam(presetTeam + TEAM_MULTITEAM_FIRST - 1)

	if( teamPlayers.len() == 0 )
		return null

	teamPlayers.sort( PrivateMatch_SortPlayersByName )

	int playerSlot = abs((GetConVarInt( OBSERVER_PRESET_PLAYERSLOT_CONVAR_NAME ) - 1) % teamPlayers.len())

	return teamPlayers[playerSlot]

}

void function PrivateMatch_OnGameStateChanged( int newVal )
{
	if ( !IsPrivateMatch() )
		return

	if( newVal == eGameState.Playing )
	{
		entity observerTarget = GetObserverPresetTarget()
		if( observerTarget != null )
			Remote_ServerCallFunction( "ClientCallback_PrivateMatchChangeObserverTarget", observerTarget )
	}
	else if ( newVal == eGameState.WinnerDetermined )
	{
		if( GameRules_GetTeamName( GetWinningTeam() ) != "Unassigned" )
		{
			SetChampionScreenRuiAsset( PM_CHAMPION_SCREEN )
			SetChampionScreenRuiAssetExtraFunc( ChampionScreenSetWinningTeamName )
		}
	}
	else if ( newVal == eGameState.Resolution )
	{
		if ( GameRules_GetTeamName( GetWinningTeam() ) == "Unassigned" )
		{
			RunUIScript( "PrivateMatch_CreateMatchEndEarlyDialog")
		}

		                                                                     
		                                                   
		bool aimAssistConfig = GetConVarBool( CUSTOM_AIM_ASSIST_CONVAR_NAME )
		if ( aimAssistConfig != file.cachedAimAssistOverride )
		{
			SetConVarBool( GLOBAL_AIM_ASSIST_CONVAR_NAME, file.cachedAimAssistOverride )
		}
	}
}

void function PrivateMatch_ClientOnSquadEliminated( entity player, int newVal )
{
	bool anonymousModeActive = GetConVarBool( CUSTOM_ANONYMOUS_MODE_CONVAR_NAME )
	if ( anonymousModeActive && GameRules_IsTeamIndexValid( newVal ) )
		Obituary_Print_Localized( Localize( "#SURVIVAL_OBITUARY_SQUADELIMINATED", PrivateMatch_GetTeamName( newVal ) ).toupper(), <255, 244, 79> )
}

void function ChampionScreenSetWinningTeamName( var rui )
{
	if ( !IsPrivateMatch() )
		return

	RuiSetString( rui, "winningTeamName", PrivateMatch_GetTeamName( GetWinningTeam() ).toupper() )
}
#endif         

#if SERVER || CLIENT
int function PrivateMatch_GetMaxTeamsForSelectedGamemode()
{
	int maxTeams
	switch( GameRules_GetGameMode() )
	{
		case GAMEMODE_ARENAS:
			maxTeams = 2
			break

		case GAMEMODE_CONTROL:
			maxTeams = 6
			break

		default:
			maxTeams = 20
			break
	}

	return maxTeams
}
#endif