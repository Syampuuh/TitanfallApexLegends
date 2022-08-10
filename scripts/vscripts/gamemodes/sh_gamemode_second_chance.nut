global function IsSecondChanceGameMode

#if CLIENT || SERVER
global function ShGameMode_SecondChance_Init
global function ShGameMode_SecondChance_RegisterNetworking

global function ShGameMode_SecondChance_CanTeammateStillRespawn
global function ShGameMode_SecondChance_CanPlayerStillRespawn
#endif

#if SERVER
                                                                
#endif

#if CLIENT
global function ShGameMode_SecondChance_ServerCallback_PlayerLaunchedFromPlane
global function ShGameMode_SecondChance_ServerCallback_OnPlayerKilled
global function ShGameMode_SecondChance_ServerCallback_OnPlayerRespawned
global function ShGameMode_SecondChance_ServerCallback_OnTeammateRespawned

                       
global function ShGameMode_SecondChance_ServerCallback_EnableSelfReleasePrompt
global function ShGameMode_SecondChance_ServerCallback_DisableSelfReleasePrompt
global function ShGameMode_SecondChance_ServerCallback_ToggleSelfReleasePressed
global function ShGameMode_SecondChance_ServerCallback_ConfirmSelfReleasePressed
global function ShGameMode_SecondChance_ServerCallback_ShowSelfReleasePrompt
global function ShGameMode_SecondChance_ServerCallback_HideSelfReleasePrompt
#endif

#if DEV && (CLIENT || SERVER)
global function DEV_SecondChance_ToggleInfiniteRespawn
#endif

#if CLIENT || SERVER
const asset FX_BOMBARDMENT_MARKER = $"P_second_chance_death_marker"

const string RESPAWN_MARKER_SOUND = "Gameplay_WarGames_SecondChanceBeacon_LP"
const string SECOND_CHANCE_MOVER_SCRIPTNAME = "secondchance_mover"
#endif

#if DEV
const bool SECOND_CHANCE_MODE_DEBUG = false
#endif       

#if CLIENT || SERVER
enum eSecondChancePlayerState
{
	CANT_RESPAWN, 		                                                                         
	HAS_RESPAWN_TOKEN,
	IS_RESPAWNING,
	NO_RESPAWN_TOKEN
}
#endif

#if CLIENT
const asset ASSET_ANNOUNCEMENT_ICON = $"rui/gamemodes/salvo_war_games/war_games_icon"
#endif

#if SERVER
                                            
#endif

#if CLIENT || SERVER
struct StoredPlayerData
{
	string armorRef = ""
	int ultimateCharge = 0
	ItemFlavor& ultimateItemFlavor
}


struct {
	table<EHI, int>						playerToRespawnState 		                     

	#if SERVER
		                      			                			              
		                                                  			                       
		                     			                        	                             
	#endif

	#if CLIENT
		var								localSelfReleasePromptRui
		array<var>						SquadRespawnTokenRuis
		var								playerRespawnTokenRui
	#endif

	#if DEV
		bool							infiniteRespawn = false
	#endif
} file
#endif
  

                                                                           
                                                                           

                    			    

                                                                           
                                                                           

  

#if CLIENT || SERVER
void function ShGameMode_SecondChance_Init()
{
	if ( !IsSecondChanceGameMode() )
	{
		#if DEV
			if ( SECOND_CHANCE_MODE_DEBUG )
			{
				printf("ShGameMode_SecondChance_Init: Game mode disabled. See playlist vars!")
			}
		#endif
		return
	}

	PrecacheParticleSystem( FX_BOMBARDMENT_MARKER )

	#if CLIENT
		AddCreateCallback( "player", SecondChance_OnPlayerCreated )
		AddCallback_OnViewPlayerChanged( SecondChance_OnViewPlayerChanged )
		AddScoreboardShowCallback( SecondChance_OnScoreboardShow )
		AddScoreboardHideCallback( SecondChance_OnScoreboardHide )
		AddCallback_OnPlayerDisconnected( SecondChance_OnPlayerDisconnected )
		AddCallback_OnTeamUnitFrameDestroyed( SecondChance_OnTeamUnitFrameDestroyed )
	#endif

	#if SERVER
		                                                                       
		                                                                                                 
		                                                                                                                 
		                                                                                                                  
		                                                                                                 
		                                                               
		                                                                                        
		                                                                                               
		                                                                              
		                                                                     
	#endif

	AddCallback_EntitiesDidLoad( SecondChance_EntitiesDidLoad )
}

void function SecondChance_EntitiesDidLoad()
{
	thread __EntitiesDidLoad()
}

void function __EntitiesDidLoad()
{
	SurvivalCommentary_SetHost( eSurvivalHostType.MAGGIE )
}

void function ShGameMode_SecondChance_RegisterNetworking()
{
	if ( !IsSecondChanceGameMode() )
	{
		return
	}

	Remote_RegisterClientFunction( "ShGameMode_SecondChance_ServerCallback_OnPlayerKilled", "entity" )
	Remote_RegisterClientFunction( "ShGameMode_SecondChance_ServerCallback_OnPlayerRespawned", "entity" )
	Remote_RegisterClientFunction( "ShGameMode_SecondChance_ServerCallback_OnTeammateRespawned", "entity" )
	Remote_RegisterClientFunction( "ShGameMode_SecondChance_ServerCallback_EnableSelfReleasePrompt" )
	Remote_RegisterClientFunction( "ShGameMode_SecondChance_ServerCallback_DisableSelfReleasePrompt" )
	Remote_RegisterClientFunction( "ShGameMode_SecondChance_ServerCallback_ShowSelfReleasePrompt" )
	Remote_RegisterClientFunction( "ShGameMode_SecondChance_ServerCallback_HideSelfReleasePrompt" )
	Remote_RegisterClientFunction( "ShGameMode_SecondChance_ServerCallback_ToggleSelfReleasePressed", "bool" )
	Remote_RegisterClientFunction( "ShGameMode_SecondChance_ServerCallback_ConfirmSelfReleasePressed" )
	Remote_RegisterClientFunction( "ShGameMode_SecondChance_ServerCallback_PlayerLaunchedFromPlane" )
}
#endif

#if SERVER
                                                             
 
	       
		                               
		 
			                                          
		 
	      

	                                                     
 
#endif

#if CLIENT
void function SecondChance_OnTeamUnitFrameDestroyed( int index )
{
	#if DEV
		if ( SECOND_CHANCE_MODE_DEBUG )
		{
			printf("SecondChance_OnTeamUnitFrameDestroyed()")
		}
	#endif

	                                                                                                           
	thread SecondChance_OnTeamUnitFrameDestroyed_Thread()
}

void function SecondChance_OnTeamUnitFrameDestroyed_Thread()
{
	WaitFrame()

	entity player = GetLocalViewPlayer()

	EHI playerEHI = ToEHI(player)
	if ( IsAlive( player ) && (playerEHI in file.playerToRespawnState) && file.playerToRespawnState[playerEHI] != eSecondChancePlayerState.IS_RESPAWNING )
	{
		SecondChance_HideRespawnTokenRUIs()
		SecondChance_UpdateRespawnTokenRUIs( GetLocalViewPlayer() )
	}
}

void function SecondChance_OnPlayerCreated( entity player )
{
	#if DEV
		if ( SECOND_CHANCE_MODE_DEBUG )
		{
			printf("SecondChance_OnPlayerCreated()")
		}
	#endif

	if ( GetGameState() >= eGameState.WinnerDetermined )
	{
		return
	}

	SecondChance_RegisterPlayerWithRespawnToken( player )
	if ( player == GetLocalClientPlayer() )
	{
		SecondChance_CreateRespawnTokenRUIs()
	}
}

void function SecondChance_OnViewPlayerChanged( entity newPlayerView )
{
	#if DEV
		if ( SECOND_CHANCE_MODE_DEBUG )
		{
			printf( "SecondChance_OnViewPlayerChanged()" )
		}
	#endif

	if ( !IsValid( newPlayerView ) )
	{
		return
	}

	#if DEV
		if ( SECOND_CHANCE_MODE_DEBUG )
		{
			printf( "SecondChance_OnViewPlayerChanged: player = " + newPlayerView.GetPlayerName() )
		}
	#endif

	if ( GetGameState() >= eGameState.WinnerDetermined )
	{
		SecondChance_DestroyRespawnTokenRUIs()
		return
	}

	SecondChance_UpdateRespawnTokenRUIs( newPlayerView )
}

void function ShGameMode_SecondChance_ServerCallback_OnPlayerKilled( entity player )
{
	#if DEV
		if ( SECOND_CHANCE_MODE_DEBUG )
		{
			printf( "ShGameMode_SecondChance_ServerCallback_OnPlayerKilled()" )
		}
	#endif

	SecondChance_UpdatePlayerRespawnState( player )

	if ( player == GetLocalClientPlayer() )
	{
		SecondChance_HideRespawnTokenRUIs()
		ShGameMode_SecondChance_ServerCallback_DisableSelfReleasePrompt()
	}
	else if ( IsPlayerOnTeam( player, GetLocalViewPlayer().GetTeam() ) )
	{
		SecondChance_UpdateRespawnTokenRUIs( player )
	}
}
#endif

#if DEV && (CLIENT || SERVER)
void function DEV_SecondChance_ToggleInfiniteRespawn()
{
	file.infiniteRespawn = !file.infiniteRespawn
	if ( file.infiniteRespawn )
		printl("DEV_SecondChance_ToggleInfiniteRespawn: Toggled On!")
	else
		printl("DEV_SecondChance_ToggleInfiniteRespawn: Toggled Off!")
}
#endif

  

                                                                           
                                                                           

                    			          

                                                                           
                                                                           

  

#if CLIENT || SERVER
void function SecondChance_RegisterPlayerWithRespawnToken( entity player )
{
	#if DEV
		if ( SECOND_CHANCE_MODE_DEBUG )
		{
			printf("SecondChance_RegisterPlayerWithRespawnToken()")
		}
	#endif

	if ( !IsValid( player ) )
	{
		return
	}

	EHI playerEHI = ToEHI(player)
	if  ( !(playerEHI in file.playerToRespawnState) )
	{
		#if DEV
			if ( SECOND_CHANCE_MODE_DEBUG )
			{
				printf("SecondChance_RegisterPlayerWithRespawnToken: player = " + player.GetPlayerName() + " EHI = " + playerEHI)
			}
		#endif

		file.playerToRespawnState[playerEHI] <- eSecondChancePlayerState.CANT_RESPAWN
	}
}

bool function ShGameMode_SecondChance_CanPlayerStillRespawn( entity player )
{
	EHI playerEHI = ToEHI(player)
	if ( playerEHI in file.playerToRespawnState )
	{
		if ( file.playerToRespawnState[playerEHI] == eSecondChancePlayerState.HAS_RESPAWN_TOKEN || file.playerToRespawnState[playerEHI] == eSecondChancePlayerState.IS_RESPAWNING )
		{
			return true
		}
	}

	return false
}

bool function ShGameMode_SecondChance_CanTeammateStillRespawn( entity player )
{
	array<entity> teamPlayers = GetPlayerArrayOfTeam( player.GetTeam() )

	foreach ( teamPlayer in teamPlayers )
	{
		EHI teamPlayerEHI = ToEHI( teamPlayer )
		if ( file.playerToRespawnState[teamPlayerEHI] == eSecondChancePlayerState.HAS_RESPAWN_TOKEN || file.playerToRespawnState[teamPlayerEHI] == eSecondChancePlayerState.IS_RESPAWNING )
		{
			return true
		}
	}

	return false
}
#endif

#if SERVER
                                                                                                                 
 
	                                          
	 
		      
	 

	                                                                                                                               
	                                        
	                                    
	 
		                                                                                                        
	 

	                               
	                                                                                                                                       
	 
		      
	 

	                                                        
	 
		      
	 

	                                                                                                                                               
 

                                                                                                                                            
 
	                                                                         

	                                

	                               

	                                                                                                                                                

	                                                                                  
	                                                                                                  
	                                                                                              
	 
		                                           
		 
			                                                              
			                          
		 
		    
		 
			                                                              
		 
	        
		                        
		                                                                         
		                                                                
		 
			                                                
			                                            
		 

		                                                                   
		                        
		                                          
		 
			                                                                 
		 

		                                                            
	 

	                  
	                                       

	                                  
	                                                               
	                                                                                         
	                                      

	                                                 

	                                                                           
	                     
	                                                               
	                                                                                             
	                                                                                     
	                                       

	                                                                 
	                                                                     

	       
		                            
			                                                                             
	     
		                                                                             
	      

	                                                                             
	                                                                           
	                                                  
	                                                                                                                              

	          

	                                           
		                        
		 
			                                          
			                                           
		 
	   

	          

	                        
	 
		      
	 

	                            

	                                        
	                                         
	 
		                                                                                                                
	 

	                                             

	                         
	                               
	                                                                                                                                    

	                                    

	                                  
	                         
	                                                                                                                                        
	                   
	                                        
	                 
	                      
	                    
	                        

	                            
	                                  

	                                        
	 
		                                                                                                                              
		 
			                                                                                                                                   
			 
				                                                                                                                       
			 
		 

		                                                          
		                     
		 
			                                                               
			                                                                      

			                                                         
				                                                                           

			                                                                              
		 

		                                      
	 

	                                                 
	                                                                   
	                                                          

	                                                                    

	                                                                                 
	                                         
	                                                   
	                                                                                  

	            
		                                   
		 
			                        
			 
				                    
			 

			                            
			 
				                    
			 

			                                          
			                                           
		 
	 

	            

	                                          
	                                  

	                    
	                                       
	                                            
	                           
	                                

	                          
	                    

	                                                          

	                                                                                  
 

                                                               
 
	                                                                       
	 
		                                                              
	 

	                                 

	       
		                            
			                                                                                    
	     
		                                                                                    
	      
 

                                                                
 
	                                     
	 
		                                                                         
		                                                
		 
			                                            
		 
		                                     
	 
 
#endif

#if CLIENT
void function ShGameMode_SecondChance_ServerCallback_OnPlayerRespawned( entity player )
{
	#if DEV
		if ( SECOND_CHANCE_MODE_DEBUG )
		{
			printf("ShGameMode_SecondChance_ServerCallback_OnPlayerRespawned()")
		}
	#endif

	EHI playerEHI = ToEHI(player)
	if  ( playerEHI in file.playerToRespawnState )
	{
		if ( file.playerToRespawnState[playerEHI] == eSecondChancePlayerState.IS_RESPAWNING )
		{
			file.playerToRespawnState[playerEHI] = eSecondChancePlayerState.NO_RESPAWN_TOKEN
		}
	}

	if ( player == GetLocalViewPlayer() )
	{
		SecondChance_UpdateRespawnTokenRUIs( GetLocalViewPlayer() )
	}
}

void function ShGameMode_SecondChance_ServerCallback_OnTeammateRespawned( entity player )
{
	#if DEV
		if ( SECOND_CHANCE_MODE_DEBUG )
		{
			printf("ShGameMode_SecondChance_ServerCallback_OnTeammateRespawned()")
		}
	#endif

	EHI playerEHI = ToEHI(player)
	if ( playerEHI in file.playerToRespawnState )
	{
		if ( file.playerToRespawnState[playerEHI] == eSecondChancePlayerState.IS_RESPAWNING )
		{
			file.playerToRespawnState[playerEHI] = eSecondChancePlayerState.NO_RESPAWN_TOKEN
		}
	}
}

void function SecondChance_OnPlayerDisconnected( entity player )
{
	#if DEV
		if ( SECOND_CHANCE_MODE_DEBUG )
		{
			printf("SecondChance_OnPlayerDisconnected()")
		}
	#endif

	if ( !IsValid( player ) )
	{
		return
	}

	EHI playerEHI = ToEHI(player)
	if ( playerEHI in file.playerToRespawnState )
	{
		file.playerToRespawnState[playerEHI] = eSecondChancePlayerState.NO_RESPAWN_TOKEN
	}

	if ( player == GetLocalViewPlayer() )
	{
		return
	}

	entity localViewPlayer = GetLocalViewPlayer()
	if ( !IsValid( localViewPlayer ) )
	{
		return
	}

	if ( IsPlayerOnTeam( player, GetLocalViewPlayer().GetTeam() ) && PlayerHasUnitFrame( player ) && GetUnitFrame( player ).index < file.SquadRespawnTokenRuis.len() )
	{
		if ( file.SquadRespawnTokenRuis[GetUnitFrame( player ).index] != null )
		{
			RuiSetBool( file.SquadRespawnTokenRuis[GetUnitFrame( player ).index], "isVisible", false )
		}
	}
}

void function SecondChance_UpdatePlayerRespawnState( entity player )
{
	#if DEV
		if ( SECOND_CHANCE_MODE_DEBUG )
		{
			printf("SecondChance_UpdatePlayerRespawnState()")
		}
	#endif

	if ( !IsValid( player ) )
	{
		return
	}

	EHI playerEHI = ToEHI(player)
	if  ( playerEHI in file.playerToRespawnState )
	{
		if ( file.playerToRespawnState[playerEHI] == eSecondChancePlayerState.HAS_RESPAWN_TOKEN )
		{
			#if DEV
				if ( SECOND_CHANCE_MODE_DEBUG )
				{
					printf("SecondChance_UpdatePlayerRespawnState: Player name = " + player.GetPlayerName() + " State set to IS_RESPAWNING")
				}
			#endif
			file.playerToRespawnState[playerEHI] = eSecondChancePlayerState.IS_RESPAWNING
		} else if ( file.playerToRespawnState[playerEHI] == eSecondChancePlayerState.CANT_RESPAWN) {
			file.playerToRespawnState[playerEHI] = eSecondChancePlayerState.NO_RESPAWN_TOKEN
		}
	}
}

void function SecondChance_HideRespawnTokenRUIs()
{
	#if DEV
		if ( SECOND_CHANCE_MODE_DEBUG )
		{
			printf("SecondChance_HideRespawnTokenRUIs()")
		}
	#endif

	if ( file.playerRespawnTokenRui != null )
	{
		RuiSetBool( file.playerRespawnTokenRui, "isVisible", false )
	}

	for ( int i = 0; i < GetMaxTeamPlayers()-1; ++i )
	{
		if ( file.SquadRespawnTokenRuis[i] != null )
		{
			RuiSetBool( file.SquadRespawnTokenRuis[i], "isVisible", false )
		}
	}
}

void function SecondChance_UpdateRespawnTokenRUIs( entity player )
{
	#if DEV
		if ( SECOND_CHANCE_MODE_DEBUG )
		{
			printf("SecondChance_UpdateRespawnTokenRUIs()")
		}
	#endif

	array<entity> players = GetPlayerArrayOfTeam( player.GetTeam() )
	foreach ( entity teammate in players )
	{
		EHI teammateEHI = ToEHI(teammate)
		if  ( teammateEHI in file.playerToRespawnState )
		{
			if ( teammate == GetLocalViewPlayer() )
			{
				if ( file.playerRespawnTokenRui != null )
				{
					RuiSetBool( file.playerRespawnTokenRui, "isVisible", (file.playerToRespawnState[teammateEHI] <= eSecondChancePlayerState.HAS_RESPAWN_TOKEN ? true : false) )
				}
			} else {
				if ( PlayerHasUnitFrame( teammate ) && GetUnitFrame( teammate ).index < file.SquadRespawnTokenRuis.len() )
				{
					if ( file.SquadRespawnTokenRuis[GetUnitFrame( teammate ).index] != null )
					{
						RuiSetBool( file.SquadRespawnTokenRuis[GetUnitFrame( teammate ).index], "isVisible", (file.playerToRespawnState[teammateEHI] <= eSecondChancePlayerState.HAS_RESPAWN_TOKEN ? true : false) )
					}
				}
			}
		}
	}
}

void function SecondChance_CreateRespawnTokenRUIs()
{
	#if DEV
		if ( SECOND_CHANCE_MODE_DEBUG )
		{
			printf("SecondChance_CreateRespawnTokenRUIs()")
		}
	#endif

	if ( IsValid( file.playerRespawnTokenRui ) )
	{
		return
	}

	file.playerRespawnTokenRui = RuiCreate( $"ui/secondchance_respawntoken_hint.rpak", clGlobal.topoFullscreenFullMap, FULLMAP_RUI_DRAW_LAYER, 9000 )
	RuiSetInt( file.playerRespawnTokenRui, "squadSlot", -1 )

	for ( int i = 0; i < GetMaxTeamPlayers()-1; ++i )
	{
		file.SquadRespawnTokenRuis.append( RuiCreate( $"ui/secondchance_respawntoken_hint.rpak", clGlobal.topoFullscreenFullMap, FULLMAP_RUI_DRAW_LAYER, 9000 ) )
		RuiSetInt( file.SquadRespawnTokenRuis[i], "squadSlot", i )
		InitHUDRui( file.SquadRespawnTokenRuis[i], false )
	}
}

void function SecondChance_DestroyRespawnTokenRUIs()
{
	#if DEV
		if ( SECOND_CHANCE_MODE_DEBUG )
		{
			printf("SecondChance_DestroyRespawnTokenRUIs()")
		}
	#endif

	if ( file.playerRespawnTokenRui != null )
	{
		RuiDestroyIfAlive( file.playerRespawnTokenRui )
		file.playerRespawnTokenRui = null
	}

	for ( int i = 0; i < GetMaxTeamPlayers()-1; ++i )
	{
		if ( file.SquadRespawnTokenRuis[i] != null )
		{
			RuiDestroyIfAlive( file.SquadRespawnTokenRuis[i] )
			file.SquadRespawnTokenRuis[i] = null
		}
	}
}
#endif

  

                                                                           
                                                                           

                    			                    

                                                                           
                                                                           

  

#if SERVER
                                                                                                                           
 
	                               

	                                              
	 
		                                                                                         
		 
			       
				                               
				 
					                                                                                         
				 
			      

			                                                                                   
			                                                                         
			                                                 

			                                                                                                         

			                                                            
		 
	 
 

                                                                                                    
 
	       
		                               
		 
			                                                                 
		 
	      

	                         
	 
		      
	 

	                                                                                                          
 

                                                                                                           
 
	       
		                               
		 
			                                                                        
		 
	      

	                         
	 
		      
	 

	                                                                                                       
 

                                                                                                             
 
	       
		                               
		 
			                                                                          
		 
	      

	                         
	 
		      
	 

	                                                                                                       
 

                                                                          
 
	                             
	                                           
	                                       
	                                           

	                                           
		                        
		 
			                                                          
		 
	   

	                                                                                  
	              
	 
		                                                  
		 
			     
		 

		           
	 

	                  

	                                  

	                        
	              
	 
		                                               
		                                              
		                                               
		 
		 
			             
			 
				                                                                              
				                                                                                                                
				            
				                  
			 

			                                             
			 
				     
			 
		                     
			                                                          
			                                                                                                                 
			             
		 

		           
	 

	                                                          
	                                                                                 
	                                                                                                           
	        
	                                                       
 

                                                               
 
	                                                                                         
 
#endif

#if CLIENT
void function ShGameMode_SecondChance_ServerCallback_EnableSelfReleasePrompt()
{
	file.localSelfReleasePromptRui = CreateCockpitPostFXRui( $"ui/secondchance_selfrelease_message.rpak", FULLMAP_Z_BASE )
}

void function ShGameMode_SecondChance_ServerCallback_DisableSelfReleasePrompt()
{
	#if DEV
		if ( SECOND_CHANCE_MODE_DEBUG )
		{
			printf("ShGameMode_SecondChance_ServerCallback_DisableSelfReleasePrompt()")
		}
	#endif

	if ( file.localSelfReleasePromptRui != null )
	{
		RuiDestroyIfAlive( file.localSelfReleasePromptRui )
		file.localSelfReleasePromptRui = null
	}
}

void function ShGameMode_SecondChance_ServerCallback_HideSelfReleasePrompt()
{
	if ( file.localSelfReleasePromptRui != null )
	{
		RuiSetBool( file.localSelfReleasePromptRui, "isVisible", false )
	}
}

void function ShGameMode_SecondChance_ServerCallback_ShowSelfReleasePrompt()
{
	if ( file.localSelfReleasePromptRui != null )
	{
		RuiSetBool( file.localSelfReleasePromptRui, "isVisible", true )
	}
}

void function ShGameMode_SecondChance_ServerCallback_ToggleSelfReleasePressed( bool bToggle )
{
	if ( file.localSelfReleasePromptRui != null )
	{
		RuiSetBool( file.localSelfReleasePromptRui, "isPressed", bToggle )
	}
}

void function ShGameMode_SecondChance_ServerCallback_ConfirmSelfReleasePressed()
{
	#if DEV
		if ( SECOND_CHANCE_MODE_DEBUG )
		{
			printf("ShGameMode_SecondChance_ServerCallback_ConfirmSelfReleasePressed()")
		}
	#endif

	if ( file.localSelfReleasePromptRui != null )
	{
		RuiSetGameTime( file.localSelfReleasePromptRui, "confirmTime", Time() )
		RuiSetBool( file.localSelfReleasePromptRui, "isPressed", false )
		RuiSetBool( file.localSelfReleasePromptRui, "confirm", true )
	}
}
#endif

  

                                                                           
                                                                           

                    			                  

                                                                           
                                                                           

  

#if SERVER
                                                                                           
 
	                                                                             
	                                                                                          
	                                                                              
	                                                                                    
	                                                                                         

	                     
	 
		                                                      
	 

	                                           
	 
		                                                                                            
		                                                   
	 

	                                                                                           
	                                           
	 
		                                                                              
		                                                                                
	        
		                                 
		                                                                                                      
		                                                     
		                                                        
			                                                                                
		        
			                                                                              
		 
	 
 

                                                                                                     
 
	                       
	                        
	                        
	                                       

	                                                                                          
	                                     
	 
		                                                                                        

		                                                                
		                                                     
		                                                                               
		                                                                                              
		                                  
		                                                                     
		                                                              
	 
 

                                                                           
 
	                    

	                                 
	 
		                                                                
		                                                                                       
		 
			                                                                  
		 
	 

	               
 

                                                                     
 
	                                                                                                         
 

                                                                   
 
	                         
		      

	                             
	                                                                                  
 

                                                        
 
	                                                    
	                               
	 
		                                                                           
		 
			            
		 
	 

	           
 

                                                               
 
	                                        
	             
	                               
	 
		                                                                                                       
		 
			       
		 
	 
	            
 

                                                
 
	                                        
	                  
	                               
	 
		                                                                                                       
		 
			                      
			                                
			 
				                      
			 
		 
	 
	                    
 
#endif

#if CLIENT
void function SecondChance_OnScoreboardShow()
{
	RuiSetBool( file.playerRespawnTokenRui, "isFullMapOpen", true )
}

void function SecondChance_OnScoreboardHide()
{
	RuiSetBool( file.playerRespawnTokenRui, "isFullMapOpen", false )
}

void function ShGameMode_SecondChance_ServerCallback_PlayerLaunchedFromPlane()
{
	SecondChance_UpdateRespawnTokenRUIs( GetLocalClientPlayer() )
	SecondChance_ServerCallback_AnnouncementSplash()
}

void function SecondChance_ServerCallback_AnnouncementSplash()
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
	{
		return
	}

	AnnouncementData announcement = Announcement_Create( "#WAR_GAMESMODE_SECOND_CHANCE" )
	announcement.drawOverScreenFade = true
	Announcement_SetSubText( announcement, "#WAR_GAMESMODE_SECOND_CHANCE_ABOUT" )
	Announcement_SetHideOnDeath( announcement, true )
	Announcement_SetDuration( announcement, 16.0 )
	Announcement_SetPurge( announcement, true )
	Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_SWEEP )
	Announcement_SetSoundAlias( announcement, SFX_HUD_ANNOUNCE_QUICK )
	Announcement_SetTitleColor( announcement, <0, 0, 0> )
	Announcement_SetIcon( announcement, $"" )
	Announcement_SetLeftIcon( announcement, ASSET_ANNOUNCEMENT_ICON )
	Announcement_SetRightIcon( announcement, ASSET_ANNOUNCEMENT_ICON )
	AnnouncementFromClass( player, announcement )
}
#endif

bool function IsSecondChanceGameMode()
{
	return GetCurrentPlaylistVarBool( "is_second_chance_mode", false )
}