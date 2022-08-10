                                                   
global function ShGameModeShadowRoyale_Init
global function Gamemode_ShadowRoyale_RegisterNetworking
#if SERVER
	                                           
#endif

#if CLIENT
	global function ServerCallback_ModeShadowRoyale_AnnouncementSplash
	global function ServerCallback_PlaySpectatorAnnouncer
	global function ServerCallback_PlayerRespawned
#endif

                                     		                                                            
                                      	                                                     

const asset ICON_SPAWN_SHADOW_ENEMY		= $"rui/gamemodes/shadow_squad/shadow_icon_spawn_temp"
const asset ICON_SPAWN_SHADOW_FRIEND	= $"rui/gamemodes/shadow_squad/shadow_icon_spawn"
const asset DEATH_SCREEN_RUI            = $"ui/header_data_shadow_squad.rpak"

global const array<string> SHADOW_ROYALE_DISABLED_BATTLE_CHATTER_EVENTS = [ "bc_killLeaderNew" ]

enum eShadowRoyaleMessage
{
	BLANK,
	SHADOW_LIVES_REMAINING,
	GAME_RULES_INTRO,
	GAME_RULES_LAND,
	REVENGE_KILL_KILLER,
	REVENGE_KILL_VICTIM,
	NO_MORE_SPAWNS_SOON,
	NO_MORE_SPAWNS,
	PETS_FOR_TEAMMATE,
	PETS_FOR_PLAYER,
	SHADOW_ABILITIES,
	PET_FRIENDLYFIRE

	_count
}

enum eShadowRoyaleSpectatorAudio
{
	TAUNT_SQUAD_WIPED,
	TAUNT_SQUAD_WIPED_REV,

	_count
}

enum eShadowAnnouncerCustom
{
	INITIAL_SKYDIVE,
	PLAYER_TOOK_REVENGE,
	SHADOW_RESPAWN_FIRST,
	SHADOW_RESPAWN,
}

struct
{
	#if SERVER
		                                
		                                    
	#endif
}file
  
                                                                           
                                                                           
                                                                           

                                                                        
                                                                     
                                                                     
                                                                     
                                                                     
                                                                     
                                                                     

                                                                           
                                                                           
                                                                           
  

        
void function ShGameModeShadowRoyale_Init()
{
	if ( !IsShadowRoyaleMode() )
		return

	AddCallback_EntitiesDidLoad( EntitiesDidLoad )

	#if SERVER
		                                            
		                                            
		                                                          
		                                                        
		                                                                           
		                                                                   
		                                                                             
		                                                                       
		                                                                     
		                                                          
		                                                                             
		                                                           
		                                                 
	#endif         

	#if CLIENT
		SetCustomScreenFadeAsset( $"ui/screen_fade_shadow_fall.rpak" )
		ClApexScreens_SetCustomApexScreenBGAsset( $"rui/rui_screens/banner_c_shadowfall" )
		ClApexScreens_SetCustomLogoTint( <1.0, 1.0, 1.0> )

		Survival_SetVictorySoundPackageFunction( GetVictorySoundPackage )
		AddCallback_GameStateEnter( eGameState.Playing, ShadowRoyale_OnPlaying )
		AddCallback_OnVictoryCharacterModelSpawned( OnVictoryCharacterModelSpawned )
		AddCallback_OnPingCreatedByAnyPlayer( OnPingCreatedByAnyPlayer_CustomReviveText )
	#endif         
}
            


        
void function Gamemode_ShadowRoyale_RegisterNetworking()
{
	if ( !IsShadowRoyaleMode() )
		return

	Remote_RegisterClientFunction( "ServerCallback_ModeShadowRoyale_AnnouncementSplash", "int", 0, eShadowRoyaleMessage._count )
	Remote_RegisterClientFunction( "ServerCallback_PlaySpectatorAnnouncer", "int", 0, eShadowRoyaleSpectatorAudio._count )
	Remote_RegisterClientFunction( "ServerCallback_PlayerRespawned", "entity" )
}
            

        
void function EntitiesDidLoad()
{
	if ( !IsShadowRoyaleMode() )
		return

	if ( IsMenuLevel() )
		return

	#if SERVER
		                                                 
		                                  
		 
			                     
				                                             
		 
	#endif         

	SurvivalCommentary_SetHost( eSurvivalHostType.NOC )
}
            

#if CLIENT
void function ShadowRoyale_OnPlaying()
{
	if ( GetCurrentPlaylistVarFloat( "shadow_spawn_pos_display_time", 5 ) > 0 )
	{
		SetMapFeatureItem( 1000, "#SHADOWROYALE_SHADOW_SPAWN_ENEMY", "#SHADOWROYALE_SHADOW_SPAWN_ENEMY_DESC", ICON_SPAWN_SHADOW_ENEMY )
		SetMapFeatureItem( 1000, "#SHADOWROYALE_SHADOW_SPAWN_FRIEND", "#SHADOWROYALE_SHADOW_SPAWN_FRIEND_DESC", ICON_SPAWN_SHADOW_FRIEND )
	}

	                                                                       
	DeathScreen_SetDataRuiAssetForGamemode( DEATH_SCREEN_RUI )
}
#endif         


  
                                                                                               
                                                                                               
                                                                                               

                                                                                         
                                                                                          
                                                                                    
                                                                                           
                                                                                          
                                                                                          
                                                                                         

                                                                                               
                                                                                               
                                                                                               
  

#if SERVER
                                                                                 
 
	                                                     

	                                            
	                                                                                            
	 
		                                           
		                                                                                 
	 

	                                                                              
		                                           
 
#endif         


#if SERVER
                                                                                
 
	                                                     


	                                            
	                                                                                          
	 
		                                       
		                                                                                      
	 

	                                                                              
		                                           

 
#endif         


#if SERVER
                                                  
 
	       

	                                           
		      

	                                              

	                                                           
		      


	                                           

	                          
	                                                    
	 
		                                                 
		                                                                         
			        

		                             
		                              
		                                                                  
	 

	                                                        
	                                 
	                      
	                              
	                         
	                                                  
	                                                                                                                                    

 
#endif         


#if SERVER
                                                                            
 
	                                     
	 
		                             
		                                                                                                     
		 
			                                                          
			                                                                                                               
			 
				                                                                                                         
				                              
				 
					                             
					        

					                         
						      

					                         
						      

					                                                                                             
					                                                                      
				   
			 

		 

	 

	                                                                                                                                                                                                           
	 
		                                                   
		                                      
		                                                                     
		                                      
		 
			                                   
			                                                       
		 
	 
	                     
		                                                          

	                                                    

	                 
	                
	                 
	                                       
	 
		                                                 
		                                                                                 
		                                                                                 
		                                                                              
		                                            
			                                                                              
	 

	                                                   
		                                         


	                                              

	                                                                                   
	 
		                              
		                                                                       
		                                 
			                                                                       

		                                                                                                     
	 

 
#endif         

#if SERVER
                                                                               
 
	                         
		      

	                   
	                                                        
	                                

	                                       
	                                      
	                                      
	                                                 
	                                                                                     
	                                                                                                     

	                     
	                    
	                     
	                                                                                        
	                                 
	                                   
	 
		           
		                                                                                          
		                                                                                                                                         
	 

	                                                                                          
	                           
	                                    
	 
		           
		                                                                                                                                                          
	 
 
#endif             


#if SERVER
                                                                   
 
	                         
		      

	                           
	                                          
	 
		                                                           
		 
			                                                                          
			                          
				                                                         
		 
		      
	 
 
#endif         



#if SERVER
                                                    
 
	                                          
		      

	                                            
		      

	                                   
	                    
	              

	                                                                                                    
	                                                                               
	                                                   
	                        
		                                                                     

	                         
	                                                                                                                 

	                                         
		                           

	                                             
		                            

	                                                        
		                           

	    
		                            

	                           
		                                                                                             

	                                                                    
	                                           
	                              
	 
		                             
		        
		                         
			      

		                              
		                                                                   
		                                                                                                                                 
	   

	                                                                  
	                               
		                                                                                   

	                                       

 
#endif         


#if SERVER
                                                               
 
	                   

	                               
		      

	                                   

	                                                                                                    
	                                       
		      

	        

	                               
		      

	                                             

	                                                                                      

	                       
	                                                                                               

	               
	                                                                                                                                                   

	                                                
	                                             
	                                                
	                                                                                  
	                                  
	 
		                                                   
		                                
			        

		                                                              
		                                                                                        
		                                                                          
		                                        
		                                               
		                                                
		                                                          
		                                                  
		                              
	 

	                                                    
	                                                                     
		                                                                                                                              

	                                                
	                                                
	                                                
	                                                                                                                
	                              
	                                      
	 

		                        
			        

		                               
		                                                
			        

		                                                                                       
		                      
		                            
		                           
		                                           
		                                             
			                                                                                                                    
		                                       

	 

	            
		                          
		 
			                          
			 
				                    
					            
			 

			  
			                        
			 
				                    
				                
			 
			  
		 
	 

	                                
 
#endif         


#if SERVER
                             
 
	                                                                                                                                
 
#endif         


#if SERVER
                                  
 
	                                                            
	                                                                                                                     
 
#endif         

  
                                                                                               
                                                                                               
                                                                                               

                                                                                      
                                                                                       
                                                                                 
                                                                                 
                                                                                 
                                                                                       
                                                                                      

                                                                                               
                                                                                               
                                                                                               
  


#if SERVER
                                                                             
 
	                                                  
		                                                    

 
#endif         

#if SERVER
                                                            
 
	                         
		            

	                         
		            

	                         
		            

	                                              
		            

	                                  
		                                       

	                                          
		            

	                                                  
		           

	            
 
#endif         


#if CLIENT
VictorySoundPackage function GetVictorySoundPackage()
{
	VictorySoundPackage victorySoundPackage
	float randomFloat = RandomFloatRange( 0, 1 )
	bool isSoloWin = false
	bool isRevenantInSquad = false
	bool oneHumanRemaining = false
	int playersOnPodium
	int shadowsOnPodium
	LoadoutEntry loadoutSlotCharacter = Loadout_Character()

	                                                      
	                                                    
	                                                      
	foreach ( SquadSummaryPlayerData data in GetWinnerSquadSummaryData().playerData )
	{
		if ( !LoadoutSlot_IsReady( data.eHandle, loadoutSlotCharacter ) )
			continue

		ItemFlavor character = LoadoutSlot_GetItemFlavor( data.eHandle, loadoutSlotCharacter )
		string characterName = ItemFlavor_GetHumanReadableRef( character )
		if ( characterName == "character_revenant" )
			isRevenantInSquad = true

		entity playerEnt = GetEntityFromEncodedEHandle( data.eHandle )
		if ( IsPlayerShadowZombie( playerEnt ) )
			shadowsOnPodium++

		playersOnPodium++
	}

	if ( playersOnPodium == 1 )
		isSoloWin = true

	if ( ( playersOnPodium - shadowsOnPodium ) == 1 )
		oneHumanRemaining = true


	if ( isSoloWin && isRevenantInSquad )
	{
		                       
		                    
		                       
		victorySoundPackage.youAreChampPlural = "diag_ap_nocNotify_victorySquad_01_3p"                                                                                  
		victorySoundPackage.theyAreChampPlural = "diag_ap_nocNotify_winnerDecidedTrios_02_01_3p"                                                                         
		if ( randomFloat < 0.25 )
		{
			victorySoundPackage.youAreChampSingular = "diag_ap_nocnotify_legendwintriosrev_01_3p"                                                           
			victorySoundPackage.theyAreChampSingular = "diag_ap_nocnotify_legendwintriosrev_01_3p"                                                           
		}
		else if ( randomFloat >= 0.25 && randomFloat < 0.5 )
		{
			victorySoundPackage.youAreChampSingular = "diag_ap_nocNotify_winnerFoundRev_01_02_3p"                                                                 
			victorySoundPackage.theyAreChampSingular = "diag_ap_nocNotify_winnerFoundRev_02_01_3p"                                                                  
		}
		else if ( randomFloat >= 0.5 && randomFloat < 0.75 )
		{
			victorySoundPackage.youAreChampSingular = "diag_ap_nocNotify_winnerFoundRev_03_01_3p"                                                                                      
			victorySoundPackage.theyAreChampSingular = "diag_ap_nocNotify_winnerFoundRev_02_01_3p"                                                                  
		}
		else
		{
			victorySoundPackage.youAreChampSingular = "diag_ap_nocNotify_winnerFoundRev_03_02_3p"                                                                                      
			victorySoundPackage.theyAreChampSingular = "diag_ap_nocnotify_legendwintriosrev_01_3p"                                                           
		}

	}
	else if ( !isSoloWin && oneHumanRemaining )
	{
		                   
		                 
		                   
		victorySoundPackage.youAreChampPlural = "diag_ap_nocNotify_victorySquad_02_3p"                                                                   
		victorySoundPackage.youAreChampSingular = "diag_ap_nocNotify_victorySolo_03_3p"                                                                 
		victorySoundPackage.theyAreChampSingular = "diag_ap_nocNotify_victorySolo_02_3p"                                                                     
		if ( randomFloat < 0.25 )
		{
			victorySoundPackage.youAreChampPlural = "diag_ap_nocnotify_legendwintrios_01_3p"                                                          
			victorySoundPackage.theyAreChampPlural = "diag_ap_nocnotify_legendwintrios_01_3p"                                                          
		}
		else if ( randomFloat < 0.50 )
		{
			victorySoundPackage.youAreChampPlural = "diag_ap_nocnotify_legendwintrios_01_3p"                                                                               
			victorySoundPackage.theyAreChampPlural = "diag_ap_nocnotify_legendwintrios_01_3p"                                                                               
		}
		else if ( randomFloat < 0.75 )
		{
			victorySoundPackage.theyAreChampPlural = "diag_ap_nocNotify_winnerDecidedTrios_02_01_3p"                                                                         
		}
		else
		{
			victorySoundPackage.theyAreChampPlural = "diag_ap_nocNotify_victorySquad_04_3p"                                                                            
		}

	}
	else if ( randomFloat < 0.33 )
	{
		                            
		                           
		                            
		victorySoundPackage.youAreChampPlural = "diag_ap_nocNotify_victorySquad_01_3p"                                                                                  
		victorySoundPackage.youAreChampSingular = "diag_ap_nocNotify_victorySolo_03_3p"                                                                 
		victorySoundPackage.theyAreChampSingular = "diag_ap_nocNotify_victorySolo_01_3p"                                         
		victorySoundPackage.theyAreChampPlural = "diag_ap_nocNotify_winnerDecidedTrios_02_01_3p"                                                                         
	}
	else if ( randomFloat < 0.66 )
	{
		                            
		                           
		                            
		victorySoundPackage.youAreChampPlural = "diag_ap_nocNotify_victorySquad_02_3p"                                                                   
		victorySoundPackage.youAreChampSingular = "diag_ap_nocNotify_victorySolo_04_3p"                                                             
		victorySoundPackage.theyAreChampSingular = "diag_ap_nocNotify_victorySolo_02_3p"                                                                     
		victorySoundPackage.theyAreChampPlural = "diag_ap_nocNotify_winnerDecidedTrios_05_02_3p"                                                                      
	}
	else
	{
		                            
		                           
		                            
		victorySoundPackage.youAreChampPlural = "diag_ap_nocNotify_victorySquad_03_3p"                                            
		victorySoundPackage.youAreChampSingular = "diag_ap_nocNotify_victorySolo_05_3p"                                    
		victorySoundPackage.theyAreChampSingular = "diag_ap_nocNotify_victorySolo_01_3p"                                             
		victorySoundPackage.theyAreChampPlural = "diag_ap_nocNotify_victorySquad_04_3p"                                                                            
	}


	                                                       
	                                                                
	                                                       
	if ( isSoloWin && !isRevenantInSquad && randomFloat < 0.2 )
	{
		if ( CoinFlip() )
		{
			victorySoundPackage.theyAreChampSingular = "diag_ap_nocNotify_legendWin_01_3p"                                 
		}
		else
		{
			victorySoundPackage.theyAreChampSingular = "diag_ap_nocNotify_legendWin_02_3p"                                                 
		}
	}

	return victorySoundPackage
}
#endif          




#if SERVER
                                                   
 
	                                              
 
#endif             




#if SERVER
                                                                     
 
	                             
		      

	                             
		      

	                                          
		      

	                                                      
	                           
		      

	                           
		      

	                                        
		      

	                                          
	                                                                         
	                                                                                               
	                                                              

 
#endif             

  
                                                                                               
                                                                                               
                                                                                               

                                                                              
                                                                               
                                                                         
                                                                                
                                                                               
                                                                               
                                                                              

                                                                                               
                                                                                               
                                                                                               
  


#if SERVER
                                                                         
 
	                   
	         

	                                                   
		      

	                                                                   
 
#endif             


#if SERVER
                                                                
 
	                         
		            

	                         
		            

	                         
		            

	                     
		            

	                                     
		            

	                                               
		            

	           
 
#endif             


#if SERVER
                                                                    
 
	                                          
		      

	                                                                                                    
 
#endif         


#if SERVER
                                                                                        
 
	                   
	             
	                         
		      

	                                           
 
#endif         

#if SERVER
                                                  
 
	                                      
		                                           
 
#endif         

#if SERVER
                                                                      
 
	                   
	             
	                                
 
#endif         

#if SERVER
                                                        
 
	                                                                           
	                                                                             
	                                                 
		      

	                                                               
	                           
	                                    
	 
		       
		                     
		                                                       
		                      
		                                          
		 
			                            
				        

			                            
				        

			                                                                    
			     
		 
	   
 
#endif         

#if CLIENT || SERVER
bool function IsPlayerRevenant( entity player )
{
	if ( !IsValid( player ) )
		return false

	ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_Character() )
	string characterName = ItemFlavor_GetHumanReadableRef( character )
	if ( characterName != "character_revenant" )
		return false

	return true
}
#endif                   

#if SERVER
                                                                           
 
	                   
	                              
	                                                   
	                             

	                                                  

	                                                                                                     
	                                                              

	                            
	 
		                                            
			                                         
			                                     
			                                        
			                                                                   
			                                                                   
			                                                                   
			                                                                   
			                                                               
			                                                               
			                                                               
			                                                               
			                         
			     

		                                                 
			                       
			 
				                                                                 
				                                                                          
				                                                                          

				                                                              
				                                                                          
				                                                                          

				                                                 
				                                                                          
				                                                                          

				             
				                                                                                  
				                                                                                  
				                                         
				                                                                                  
				                                                                                  

				                         

				                   
				                                                      
			 
			    
			 
				                                            
				                                               
				 
					                                                
					                                                                                        
					                                                                  
					                                                         
					                                                                                                                            
					                                                                                                                        
					                                                                                                                        
				 
				    
				 
					                  
					                                                                               
					                                                                               
					                                                                               
					                                                                               
					                                                                               
					                                                                               
					                                                                               
					                                                       
					                                                                       
					                                                                       
					                                                                       
					                                             
					                                                                       
					                                                                       
					                               
					                                                                       
					                                                                       
				 

				                         
			 
			     


		                                           
			                          
			                                                                               
			                                                                               

			              
			                                                                               
			                                                                               
			                                                                               

			                       
			 
				                                                                           
				                                                                                  
				                                                                                  

				                                                      
				                                                                                  
				                                                                                  

				                                                       
				                                                                                  
				                                                                                  

				       
				                                                                  

			 
			    
			 
				                    
				                                                                               
				                                                                               
			 

			                         
			     

		                                                
			          
			                                                                               
			                                                                               
			                                                                               
			                                                                  
			                                                                  

			                         
			     
	 

	                                               

	                              
		                        

	                         
		      

	                                          
		      

	                                                           

	                                                                         
	 
		                                                                            

		                                                  
		 
			                             
			        
			                         
				      

			                                                                   
		   
	 

 
#endif         

#if CLIENT
void function ServerCallback_ModeShadowRoyale_AnnouncementSplash( int messageIndex )
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return

	float duration = 8.0
	string messageText
	string subText
	vector titleColor = <0, 0, 0>
	asset icon = $""
	asset leftIcon = $"rui/gamemodes/shadow_squad/shadow_icon_orange"
	asset rightIcon = $"rui/gamemodes/shadow_squad/shadow_icon_orange"
	                                                            
	                                                             
	string soundAlias = "ui_ingame_shadowsquad_finalsquadmessage"                         

	int style = ANNOUNCEMENT_STYLE_SWEEP

	switch( messageIndex )
	{
		case eShadowRoyaleMessage.BLANK:
			messageText = ""
			subText = ""
			duration = 0.0
			break
		case eShadowRoyaleMessage.SHADOW_LIVES_REMAINING:
			messageText = "#SHADOWROYALE_RESPAWNING"
			int count = RespawnNearSquad_GetRemainingRespawnsForPlayer( GetLocalViewPlayer() )
			string textBase = "#SHADOWROYALE_RETRIES_NONE"
			if ( count > 1 )
				textBase = "#SHADOWROYALE_RETRIES_PLURAL"
			else if ( count == 1 )
				textBase = "#SHADOWROYALE_RETRIES_ONE"
			else if ( count == -1 )
				textBase = "#SHADOWROYALE_RETRIES_INFINITE"

			subText = Localize( textBase, string( count ) )
			duration = 8.0
			                                           
			soundAlias = "ui_ingame_shadowsquad_shipincoming"
			                                  
			break
		case eShadowRoyaleMessage.GAME_RULES_INTRO:
			messageText = "#SHADOWROYALE_RULES_TITLE"
			subText = "#SHADOWROYALE_RULES_SUB"
			duration = 16.0
			break
		case eShadowRoyaleMessage.REVENGE_KILL_KILLER:
			messageText = "#SHADOW_SQUAD_REVENGE_KILL_KILLER"
			subText = "#SHADOW_SQUAD_REVENGE_KILL_KILLER_SUB"
			soundAlias = "UI_InGame_ShadowSquad_RevengeKill"
			titleColor = <128, 30, 0>
			duration = 4.0
			break
		case eShadowRoyaleMessage.REVENGE_KILL_VICTIM:
			messageText = "#SHADOW_SQUAD_REVENGE_KILL_VICTIM"
			subText = "#SHADOW_SQUAD_REVENGE_KILL_VICTIM_SUB"
			soundAlias = "ui_ingame_shadowsquad_finalsquadmessage"
			titleColor = <128, 30, 0>
			duration = 4.0
			break
		case eShadowRoyaleMessage.NO_MORE_SPAWNS_SOON:
			messageText = "#SHADOWROYALE_NO_RESPAWNS_SOON"
			soundAlias = "ui_callerid_chime_friendly"
			style = ANNOUNCEMENT_STYLE_QUICK
			duration = 10.0
			break
		case eShadowRoyaleMessage.PETS_FOR_TEAMMATE:
			messageText = "#SHADOWROYALE_PROWLERS_FOR_TEAMMATE_TITLE"
			subText = "#SHADOWROYALE_PROWLERS_FOR_TEAMMATE_DESC"
			soundAlias = "ui_ingame_shadowsquad_finalsquadmessage"
			titleColor = <128, 30, 0>
			duration = 8.0
			break
		case eShadowRoyaleMessage.PETS_FOR_PLAYER:
			messageText = "#SHADOWROYALE_PROWLER_FOR_PLAYER_TITLE"
			subText = "#SHADOWROYALE_PROWLER_FOR_PLAYER_DESC"
			soundAlias = "ui_ingame_shadowsquad_finalsquadmessage"
			titleColor = <128, 30, 0>
			duration = 8.0
			break
		case eShadowRoyaleMessage.SHADOW_ABILITIES:
			int diceRoll = RandomIntRange( 1, 9 )
			messageText = "#SHADOW_HINT_ABILITIES_SHORT_" + diceRoll.tostring()
			soundAlias = "SQ_UI_InGame_Checkpoint"
			style = ANNOUNCEMENT_STYLE_QUICK
			duration = 8.0
			break
		case eShadowRoyaleMessage.PET_FRIENDLYFIRE:
			messageText = "#SHADOWROYALE_PET_FRIENDLYFIRE"
			soundAlias = "SQ_UI_InGame_Checkpoint"
			style = ANNOUNCEMENT_STYLE_QUICK
			duration = 6.0
			break
		case eShadowRoyaleMessage.NO_MORE_SPAWNS:
			messageText = "#SHADOWROYALE_NO_RESPAWNS_TITLE"
			subText = "#SHADOWROYALE_NO_RESPAWNS_SUB"
			soundAlias = "ui_ingame_shadowsquad_finalsquadmessage"
			duration = 8.0
			break

		default:
			Assert( 0, "Unhandled messageIndex: " + messageIndex )
	}

	AnnouncementMessageSweepShadowRoyale( style, player, messageText, subText, titleColor, soundAlias, duration, icon, leftIcon, rightIcon )
}
#endif         


#if SERVER
                                                                
 
	                         
		      

	                           
	 
		                                                                                       
		                           
		                
		                                                            
		 
			                            
				        

			                            
				        

			                          
				                                                   
			    
				                                                     

			                                                     
		 
	 
 
#endif         




#if SERVER
                                                                     
 
	                         
		      

	                         
		      

	                                             
	                                                                                              

 
#endif         



#if CLIENT
void function AnnouncementMessageSweepShadowRoyale( int style, entity player, string messageText, string subText, vector titleColor, string soundAlias, float duration, asset icon = $"", asset leftIcon = $"", asset rightIcon = $"" )
{
	AnnouncementData announcement = Announcement_Create( messageText )
	announcement.drawOverScreenFade = true
	Announcement_SetSubText( announcement, subText )
	Announcement_SetHideOnDeath( announcement, true )
	Announcement_SetDuration( announcement, duration )
	Announcement_SetPurge( announcement, true )
	Announcement_SetStyle( announcement, style )
	Announcement_SetSoundAlias( announcement, soundAlias )
	Announcement_SetTitleColor( announcement, titleColor )
	Announcement_SetIcon( announcement, icon )
	Announcement_SetLeftIcon( announcement, leftIcon )
	Announcement_SetRightIcon( announcement, rightIcon )
	AnnouncementFromClass( player, announcement )
}
#endif         

#if SERVER
                                           
 
	                            
		      

	                                                         
	 
		                         
			        

		                                                                
	 
 
#endif          


#if CLIENT
void function OnVictoryCharacterModelSpawned( entity characterModel, ItemFlavor character, int eHandle )
{
	if ( !IsValid( characterModel ) )
		return

	entity playerEnt = GetEntityFromEncodedEHandle( eHandle )

	if ( !IsValid( playerEnt ) )
		return

	if ( !IsPlayerShadowZombie( playerEnt ) )
		return

	                                              
	                                              
	                                             
	ItemFlavor skin = GetDefaultItemFlavorForLoadoutSlot( eHandle, Loadout_CharacterSkin( character ) )
	CharacterSkin_Apply( characterModel, skin )

	                                              
	                                      
	                                             
	if (  characterModel.GetSkinIndexByName( "ShadowSqaud" ) != -1 )
		characterModel.SetSkin( characterModel.GetSkinIndexByName( "ShadowSqaud" ) )
	else
		characterModel.kv.rendercolor = <0, 0, 0>

	                                              
	                                                     
	                                            
	int FX_BODY = StartParticleEffectOnEntity( characterModel, GetParticleSystemIndex( FX_SHADOW_TRAIL ), FX_PATTACH_POINT_FOLLOW, characterModel.LookupAttachment( "CHESTFOCUS" ) )
	int FX_EYE_L = StartParticleEffectOnEntity( characterModel, GetParticleSystemIndex( FX_SHADOW_FORM_EYEGLOW ), FX_PATTACH_POINT_FOLLOW, characterModel.LookupAttachment( "EYE_L" ) )
	int FX_EYE_R = StartParticleEffectOnEntity( characterModel, GetParticleSystemIndex( FX_SHADOW_FORM_EYEGLOW ), FX_PATTACH_POINT_FOLLOW, characterModel.LookupAttachment( "EYE_R" ) )
}
#endif         

#if CLIENT
void function ServerCallback_PlayerRespawned( entity respawnedPlayer )
{
	if ( !IsValid( respawnedPlayer ) )
		return

	respawnedPlayer.SetTargetInfoIcon( ICON_SPAWN_SHADOW_FRIEND )
}
#endif          

#if CLIENT
void function ServerCallback_PlaySpectatorAnnouncer( int spectatorAudioIndex )
{
	                                      
	                                     
	                                      
	entity clientPlayer = GetLocalClientPlayer()
	if ( !IsValid( clientPlayer ) )
		return

	if ( GetGameState() != eGameState.Playing )
		return

	string dialogueRef

	                             
	                            
	                             
	switch ( spectatorAudioIndex )
	{
		case eShadowRoyaleSpectatorAudio.TAUNT_SQUAD_WIPED:
			                                                                  
			dialogueRef = PickCommentaryLineFromBucket( eSurvivalCommentaryBucket.SHADOW_PLAYER_DEATH_FINAL )
			                                                                         
			                                                                         
			                                                                         
			                                                                         
			                                                                         
			                                                                         
			                                                                         
			break

		case eShadowRoyaleSpectatorAudio.TAUNT_SQUAD_WIPED_REV:
			                                      
			dialogueRef = PickCommentaryLineFromBucket( eSurvivalCommentaryBucket.SHADOW_PLAYER_DEATH_FINAL_REV )
			break

		default:
			dialogueRef = ""
			break
	}

	if ( dialogueRef == "" )
		return

	string milesAlias = GetAnyDialogueAliasFromName( dialogueRef )
	thread EmitSoundOnEntityDelayed( clientPlayer, milesAlias, 1.0 )

}
#endif         


#if CLIENT
void function OnPingCreatedByAnyPlayer_CustomReviveText( entity pingingPlayer, int pingType, entity focusEnt, vector pingLoc, entity wayPoint )
{
	if ( pingType != ePingType.BLEEDOUT )
		return

	entity localPlayer = GetLocalClientPlayer()

	if ( !IsValid( localPlayer ) )
		return

	                                  
		        

	if ( !AreTeammatesShadowZombiesOrRespawning( pingingPlayer ) )
		return

	if ( wayPoint.wp.ruiHud != null )
	{
		string reviveMessage = Localize( "#REVIVE" ).toupper() + " " + Localize( "#SHADOWROYALE_LAST_LIVING_PLAYER" ).toupper()
		RuiSetString( wayPoint.wp.ruiHud, "topLabelText", reviveMessage )
	}
}
#endif         

        
void function EmitSoundOnEntityDelayed( entity player, string alias, float delay )
{
	wait delay

	if ( !IsValid( player ) )
		return

	if ( GetGameState() != eGameState.Playing )
		return


	EmitSoundOnEntity( player, alias )
}
            