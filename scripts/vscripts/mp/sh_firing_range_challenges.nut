#if SERVER || CLIENT
global function ShFiringRangeChallenges_Init
global function FRC_RegisterChallenge
global function FRC_IsEnabled
#endif

#if SERVER

                                 
                               
                               
                                     
       
                                           
             
#endif

#if CLIENT
global function FRC_StartChallengeTimer
global function ServerCallback_FRC_UpdateState
global function ServerCallback_FRC_SetChallengeKey
global function ServerCallback_FRC_UpdateOutofBounds
global function ServerCallback_FRC_PostGameStats
#endif

const asset GUNRACK_MODEL = $"mdl/industrial/gun_rack_arm_down.rmdl"
const asset GUNRACK_BASE_MODEL = $"mdl/props/explosivehold_container_01/explosivehold_gunrackcap_01.rmdl"
const vector BASE_ORIGIN_OFFSET = <-10, 0, 0>
const vector BASE_ANGLE_OFFSET = <0, 180, 0>

const float POST_CHALLENGE_WAIT_TIME = 10.0
const int ACTIVE_CHALLENGE_WEAPON_FLAGS = WPT_TACTICAL | WPT_ULTIMATE | WPT_MELEE

const asset FRC_BORDER01_MDL = $"mdl/canyonlands/firingrange_perimetermarker_01.rmdl"
const asset FRC_BORDER02_MDL = $"mdl/canyonlands/firingrange_perimetermarker_02.rmdl"

const string FRC_SCORE_NETWORK_VAR = "firingRangeChallengeScore"

global enum eFiringRangeChallengeState
{
	FR_CHALLENGE_INACTIVE,
	FR_CHALLENGE_PENDING,
	FR_CHALLENGE_ACTIVE,
	FR_CHALLENGE_POST
}

global enum eFiringRangeChallengeType
{
	FR_CHALLENGE_TYPE_TARGETS_HIT,
	FR_CHALLENGE_TYPE_BEST_DAMAGE,
	FR_CHALLENGE_TYPE_BEST_TIME
}

global struct FiringRangeChallengeRegistrationData
{
	string           challengeName
	string           challengeInteractStr
	string		     challengeStartHint
	string           challengeKey
	vector           gunRackOrigin
	vector           gunRackAngles
	string           gunRackScriptName
	string           weaponRef
	array < string > weaponMods
	asset            weaponMdl
	asset		 	 rewardTracker

	int   challengeType
	float challengeTime = 0.0
	string borderName = ""
	int borderType = 0
	string outOfBoundsTriggerScriptName = ""

	StatTemplate& statTemplate

	vector playerTeleportPosition
	array <vector> squadSafePosition

	array < string > postGameStats

	void functionref( entity ) challengeSetupFunc
	void functionref( entity ) challengeStartFunc
	void functionref( int ) challengeCleanUpFunc
	void functionref( entity, bool ) challengePostFunc
}

struct FiringRangeChallengeRealmData
{
	int score = 0
	int challengeState = eFiringRangeChallengeState.FR_CHALLENGE_INACTIVE
	string challengeKey = ""
	array < entity > entsToClean
#if SERVER
	                          
	                       

	                           
	                         
	               
	                              
	                             
	   	                  

	                                 

	                       
	                  
	              
	                
	                    
#endif

	int target = 0

}

struct
{
	table < string, FiringRangeChallengeRegistrationData > registeredFiringRangeChallenges
	table< int,  FiringRangeChallengeRealmData > firingRangeChallengeDataByRealmTable
	table < string, vector > borderOriginByScriptNameTable

	#if CLIENT
		int score = 0
		int challengeState = eFiringRangeChallengeState.FR_CHALLENGE_INACTIVE
		string challengeKey = ""
		var challengeRui = null
		array< string > registeredChallengeWeaponScriptName
	#endif
} file


                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
  
                               
                            
                            
                            
                            
                            
                            
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    


#if SERVER || CLIENT
void function ShFiringRangeChallenges_Init()
{
	if ( GetMapName() != "mp_rr_canyonlands_staging" )                                                  
		return

	if ( !IsFiringRangeGameMode() )
		return

	AddCallback_EntitiesDidLoad( EntitiesDidLoad )

	if ( !FRC_IsEnabled() )
		return

	RegisterNetworkedVariable( FRC_SCORE_NETWORK_VAR, SNDC_PLAYER_EXCLUSIVE, SNVT_BIG_INT, 0 )

	#if SERVER
		                                                            
		                                                 
		                                                                
		                                                    
		                                               
		                              
		                                    
		                                  
		                                  
		       
			                                  
		      

		                                               
	#endif

	#if CLIENT
		RegisterSignal("FRChallengeStarted")
		RegisterSignal("FRChallengeEnded")
		AddCreateCallback( "prop_script", FRChallenge_GunCreated )
		AddCinematicEventFlagChangedCallback( CE_FLAG_HIDE_MAIN_HUD_INSTANT, OnFirstDrawCinematicFlagChanged )
		RegisterSignal("FRChallengedEndMemoriesEffect")
		PrecacheParticleSystem( $"P_adrenaline_screen_CP" )

		RegisterNetVarIntChangeCallback( FRC_SCORE_NETWORK_VAR, FiringRangeChallengeScoreUpdated )
	#endif

	RegisterSignal("FRC_BackInBounds")
	RegisterSignal( "FRChallengeEnded" )

}

bool function FRC_IsEnabled()
{
	return GetCurrentPlaylistVarBool( "s12e04_EnableFRChallenges", false )
}

void function FRC_RegisterChallenge( string challengeKey, FiringRangeChallengeRegistrationData data )
{
	Assert( !(challengeKey in file.registeredFiringRangeChallenges) , "Another firing range challenge with key " + challengeKey + " already registered." )

	if ( !GetCurrentPlaylistVarBool( "FRC_" + challengeKey, true ) )
		return

	                                                                              
	file.registeredFiringRangeChallenges[ challengeKey ] <- data

	#if CLIENT
	file.registeredChallengeWeaponScriptName.append(challengeKey)
	#endif
}

void function EntitiesDidLoad()
{
	#if SERVER
	                                                                 
	 
		                                                                                                                            
		                                                        
		                    

		                                                                                                                                                                              
		                                    
		                                                                      
	 

	                                                                                       
	                                      
	 
		                                                                                   
		                
	 

	                                                                                       
	                                      
	 
		                                                                                   
		                
	 

	                                                                                       
	                                      
	 
		                                                                                   
		                
	 

	                                                             
	                                             
	 
		                                  
		                                                        
		                                               
	 

	                   
	#endif
}
#endif                    

#if SERVER
                                 
 
	                                                                                        
	                                   
	 
		                                                                       
		                                                                       
	 

	                                                                                        
	                                   
	 
		                                                                       
		                                                                       
	 

	                                                                                        
	                                   
	 
		                                                                       
		                                                                       
	 
 

                                                                 
 
	                                                                 
	 
		                                                                      
		                                                                                                                               
	 
 

                                                              
 
	                                                                                       
	                                      
		             

	                                                                                       
	                                      
		             

	                                                                                       
	                                      
		             
 

                                                                                                                          
 
	                                       
	                                                              
	                                                                                 
		                                                    

	                                                              

	                                                                            
	                         
	                       
	                                 
	                               
	                                         

	                                                                      
	                                                                   

	                               
	                                    
 

                                                                                       
 
	                         
		      

	                                 
	                                     
	                                                 
 

                                                                       
 
	                                 

	                         
		      

	                      
		      

	                                         
	                         
		      

	                 

	                                                              
		      

	                                 

	                                                            
		      

	                                                                            
	                                                                      
	                                                                        
	                                                                                                                                 

	                                                                                                            
	                                                                    
	                                                                                                                                                    

	                                                                    
	                                     
	 
		                             
			        

		                                         
		                                                                                       
	 

	                                        

	                                      

	                                                      

	                                   
	                                                                                           
	                                                                                                                                                       
	                                                                                                                                                                             
	                                                                               
	                                                                          

	                                     
	 
		                             
			        

		                                          
	 

	                                                                                                                                                             
	                                   
 

                                                                    
 
	                                  
		      

	                             
	                           
	                           
	                               
	                             
	                          
	                               
	                         
	                                        
	                            

	                                                                             
	                                
	 
		                         
			        

		                                           
			                                      

		                                              

		                                    

		                                 
		 
			                               
			                                                          
		 
		    
		 
			                                                      
		 

		                                             
	 
 

                                                                                                                
 
	                                  
		      

	         
	                                                                             
	                                     
	 
		                                    
		 
			                                         
			                                   
		 
		    
		 
			                                      
			   
		 
	 
 

                                                                                              
 
	                         
		      

	                                                

	                                                                 
	                                                                                                  
	                                           
	                                              
	                         

	                                                                         
	                                                     
	 
		                                                                         
	 
 

                                                        
 
	                                                            
		      

	                                                                          
 

                                                                         
 
	                                                            
		      

	                                                                           
 

                                                                
 
	                                                            
		      

	                                                                                  
 

                                                      
 
	                                                            
		      

	                                                                                       
	 
		                        
			                    
	 
 

                                                   
 
	                                                            
		      

	                                                                                     
	 
		                     
			             
	 

	                                                                    
	                                                                         
 

                                                       
 
	                         
		      

	                                 

	                                                            
		      

	                                                                                                                                                          
	 
		                                                                           
	 
 

                                                                                  
 
	                         
		      

	                                 

	                                                            
		      

	                                                                                                                                                          
	 
		                                                                           
	 
 

                                                                                          
 
	                         
		      

	                                 

	                                                            
		      

	                                                                                                                                                          
	 
		                                                                           
	 
 

                                                  
 
	                         
		      

	                                 

	                                                            
		      

	                                                                                                                                                          
	 
		                                                                           
	 
 

                                                                                                       
 
	                        
		      

	                                 
	                                                              
		      

	                                                                                                                                                              
		      

	                                                                                                                        
	 
		                                                                           
	 
 

                                                                     
 
	           

	                      
		      

	                                                    
		      

	                             
	                       
		      

	                                
	                                                              
		      

	                                                                                                                          
	 
		                                                                                         
		                                                                              
			      

		                                                                             
			      

		                                                                          
	 
 

                                                  
 
	                                                              
		      

	                                                                                                                          
		      

	                                                                                     
	                                                                                 
	 
		                                                                                
	 
	    
	 
		                                       
	 

	                                

	                                                          
	                                                                  
	                                                                                                                  
	                                                           
	                                                                       
	                                                                    
	                                                              
	                                                                         
	                                                                       
	                                                               
	                                                             
	                                                           
	                                                                 

	                                                                
	                                                                                   

	                                                        
	                                     
	 
		                             
			        

		                                                            
			                                                        

		                                           
	 

	        

	                             
	 
                         
                                                                     
      
			                                                        
		                                    
		                                                               
		                                                                                                   
		                                                                                            
		                                              
		                                                       
	 

	                                                
	                                  
	                                  
	                           
	                                  
	                                      
	                                   

 	         
	                                     
	 
		                             
			        

		                    
		                                          

		                                                            
		 
			                                                                                               
			                                                                                          
			   
		 
	 

	                                                                    
	                                                                    
 

                                                                              
 
	                       
		      

	                                                          
		      

	                                                              

	                      
	 
		                                                                                  
		                            
		                          
		                                  
	 
	    
	 
		                                                                                  
		                            
		                          
		                                  
	 
 

                                                     
 
	                                
	                                      
	                                       
 

                                          
 
	                          
		            

	                                 

	                                                            
		            

	                                                                                     

	                                                              
		            

	                                                                                                                                                                         
	                                                                                                                   

	                                                                                                                            
	 

		                                                                                   
			                                                                                    

		                                                                                           
		           
	 
	    
	 
		                                                                                   
			                                                                                     

		                                                                                        
		            
	 

	           
 

                                            
 
	                          
		      

	                                 

	                                                            
		      

	                                                                                     
	                                                                                                                 

	                      
	                                                                    
	 
		                                                     
		                            
		                       
		                                            
		                                            
	 
 


                                                         
 
	                        
		      

	                                 
	                                                            
		      

	                                                                                     
	                                                                            
		      

	                                                              
		      

	                
	 
		                                                      
			                                       
			                                    
			     
		                                                     
			     
		                                                    
			                                                                               
			                                     
			                                                                                         
			     
		                                                  
			                                        
			     
	 

	                                                                       
	                         
		                                                                                

	                                                           
	                                                              
		                                     
 

                                                              
 
	                         
		      

	                                                            
		      

	                                                                                             
	                                                                      
	                              
	 
		                                    
			                                                        
	 
 

                                                      
 
	                                    
	                       

	                                 
	                                                         
	 
		                                                                          
			                                                            
			                                                        
			                                                          
			                                                             
		 
	 

	                        
		                                       

	                             

	                                                                                                                          
	                                                                                   
 

                                                                        
 
	                          
		      

	                                 
	                                                            
		      

	                                                                                                                        
		      

	                                                                                                                                
	 
		                                                           
	 
	                                                                                                                                     
	 
		                                                                
	 

	                                                           
	                                                                 

	                                     
	 
		                                                               
	 

	                                                                                                       
 

                                                
 
	                                                            
		            

	                                                                                                                            
 

       
                                           
 
	                                                    
 
             

#endif          

#if CLIENT
void function ServerCallback_FRC_UpdateState( int state )
{
	switch ( state )
	{
		case eFiringRangeChallengeState.FR_CHALLENGE_INACTIVE:
			entity player = GetLocalViewPlayer()
			Signal( player, "FRChallengeEnded" )
			file.score = 0
			EnableEmoteProjector ( true )
			break
		case eFiringRangeChallengeState.FR_CHALLENGE_PENDING:
			thread FRC_CreatePendingChallengeUI()
			EnableEmoteProjector ( false )
			break
		case eFiringRangeChallengeState.FR_CHALLENGE_ACTIVE:
			thread FRC_StartChallengeTimer()
			break
		case eFiringRangeChallengeState.FR_CHALLENGE_POST:
			                                          
			                    
			break
	}

	file.challengeState = state
}

void function ServerCallback_FRC_SetChallengeKey( string challengeKey )
{
	file.challengeKey = challengeKey
}

void function ServerCallback_FRC_UpdateOutofBounds( bool outOfBounds, float timer )
{
	entity player = GetLocalViewPlayer()
	if ( !IsValid ( player ) )
		return

	if ( !outOfBounds )
		Signal( player, "FRC_BackInBounds" )
	else
	{
		thread function() : ( outOfBounds, timer, player )
		{
			EndSignal( player, "OnDestroy" )
			EndSignal( player, "FRChallengeEnded")
			EndSignal( player, "FRC_BackInBounds" )

			OnThreadEnd(
				function() : ()
				{
					if ( file.challengeRui != null )
						RuiSetFloat( file.challengeRui, "oOBTimer", -1 )
				}
			)

			if ( file.challengeRui != null )
				RuiSetFloat( file.challengeRui, "oOBTimer", timer )

			wait timer
		}()
	}
}

void function ServerCallback_FRC_PostGameStats( int shotsFired, int damageDone, int shotsHit, int critShotsHit )
{
	if ( file.challengeRui == null )
		return

	float accuracy = ( shotsFired > 0 )? float (shotsHit) / float(shotsFired) * 100.0: 0.0
	RuiSetInt( file.challengeRui, "totalStatRows", 4)                               

	var nestedRui = RuiCreateNested( file.challengeRui, "stat" + 0 + "NestedHandle", $"ui/fr_challenge_stat_float.rpak" )
	RuiSetString( nestedRui, "label", Localize("#FR_CHALLENGE_PG_STAT_1") )
	RuiSetFloat( nestedRui, "value", accuracy )

	nestedRui = RuiCreateNested( file.challengeRui, "stat" + 1 + "NestedHandle", $"ui/fr_challenge_stat_int.rpak" )
	RuiSetString( nestedRui, "label", Localize("#FR_CHALLENGE_PG_STAT_4") )
	RuiSetInt( nestedRui, "value", shotsHit )

	nestedRui = RuiCreateNested( file.challengeRui, "stat" + 2 + "NestedHandle", $"ui/fr_challenge_stat_int.rpak" )
	RuiSetString( nestedRui, "label", Localize("#FR_CHALLENGE_PG_STAT_3") )
	RuiSetInt( nestedRui, "value", damageDone )

	nestedRui = RuiCreateNested( file.challengeRui, "stat" + 3 + "NestedHandle", $"ui/fr_challenge_stat_int.rpak" )
	RuiSetString( nestedRui, "label", Localize("#FR_CHALLENGE_PG_STAT_2") )
	RuiSetInt( nestedRui, "value", critShotsHit )
}

void function FRC_CreatePendingChallengeUI()
{
	entity player = GetLocalViewPlayer()
	EndSignal( player, "OnDestroy" )
	EndSignal( player, "FRChallengeEnded")

	var rui = CreateFullscreenRui( $"ui/tutorial_hint_line.rpak" )
	RuiSetString( rui, "buttonText", "" )
	RuiSetString( rui, "gamepadButtonText", "")
	RuiSetString( rui, "hintText", "#CHALLENGE_START_HINT" )
	RuiSetInt( rui, "hintOffset", 0 )
	RuiSetBool( rui, "hideWithMenus", true )

	if ( file.challengeKey in file.registeredFiringRangeChallenges )
	{
		RuiSetString( rui, "hintText", file.registeredFiringRangeChallenges[file.challengeKey].challengeStartHint )

		int currentBest = FRC_GetChallengeStat( player, file.registeredFiringRangeChallenges[file.challengeKey].statTemplate )
		if ( currentBest > 0 )
		{
			string hint = ""
			switch ( file.registeredFiringRangeChallenges[file.challengeKey].challengeType )
			{
				case eFiringRangeChallengeType.FR_CHALLENGE_TYPE_BEST_DAMAGE:
					hint = format( Localize("#FR_CHALLENGE_DMG_GOAL_HINT"), string(currentBest) )
					break
				case eFiringRangeChallengeType.FR_CHALLENGE_TYPE_TARGETS_HIT:
					hint = format( Localize("#FR_CHALLENGE_TARGET_GOAL_HINT"), string(currentBest) )
					break
				default:
					break
			}
			RuiSetString( rui, "subText", hint )
		}
	}
	else
	{
		RuiSetString( rui, "hintText", "#FR_CHALLENGE_TARGET_HINT" )
	}

	OnThreadEnd(
		function() : ( rui )
		{
			if ( IsValid( rui ) )
				RuiDestroyIfAlive( rui )
		}
	)

	WaitSignal( player, "FRChallengeStarted")

	RuiSetBool( rui, "hintCompleted", true )

	wait 1.0
}

void function FRC_StartChallengeTimer()
{
	entity player = GetLocalViewPlayer()
	EndSignal( player, "OnDestroy" )
	Signal( player, "FRChallengeStarted" )
	file.challengeRui    = CreateCockpitPostFXRui( $"ui/fr_challenge_timer.rpak", 0 )

	if ( !(file.challengeKey in file.registeredFiringRangeChallenges) )
		return

	float challengeTime = file.registeredFiringRangeChallenges[file.challengeKey].challengeTime

	switch ( file.registeredFiringRangeChallenges[file.challengeKey].challengeType )
	{
		case eFiringRangeChallengeType.FR_CHALLENGE_TYPE_BEST_DAMAGE:
			RuiSetString( file.challengeRui,  "challengeScoreText", "#CHALLENGE_TARGETS_DAMAGE" )
			break
		case eFiringRangeChallengeType.FR_CHALLENGE_TYPE_TARGETS_HIT:
			RuiSetString( file.challengeRui,  "challengeScoreText", "#CHALLENGE_TARGETS_HIT" )
			break
		case eFiringRangeChallengeType.FR_CHALLENGE_TYPE_BEST_TIME:
		default:
			RuiSetString( file.challengeRui,  "challengeScoreText", "" )
			break
	}

	int currentBest = FRC_GetChallengeStat( player, file.registeredFiringRangeChallenges[file.challengeKey].statTemplate )

	if ( file.registeredFiringRangeChallenges[file.challengeKey].challengeName != "" )
	{
		RuiSetString( file.challengeRui, "altIconText", file.registeredFiringRangeChallenges[file.challengeKey].challengeName )
		RuiSetString( file.challengeRui, "challengeTitle", file.registeredFiringRangeChallenges[file.challengeKey].challengeName )
	}

	RuiSetGameTime( file.challengeRui, "countdownGoalTime", Time() + challengeTime )
	RuiSetFloat( file.challengeRui, "timeOutTime", POST_CHALLENGE_WAIT_TIME )
	RuiSetInt( file.challengeRui, "target", currentBest )

	OnThreadEnd(
		function() : ()
		{
			RuiDestroyIfAlive( file.challengeRui )
			file.challengeRui = null
		}
	)

	WaitSignal( player, "FRChallengeEnded")
}

void function FiringRangeChallengeScoreUpdated( entity player, int newVal )
{
	file.score = newVal

	if ( file.challengeRui != null )
		RuiSetInt( file.challengeRui, "challengeProgress", file.score )
}

void function OnFirstDrawCinematicFlagChanged( entity player )
{
	int ceFlags = player.GetCinematicEventFlags()
	if ( ceFlags & CE_FLAG_HIDE_MAIN_HUD_INSTANT )
	{
		Crosshair_SetState( CROSSHAIR_STATE_HIDE_ALL )
		ServerCallback_SetCommsDialogueEnabled( 0 )
	}
	else
	{
		Crosshair_SetState( CROSSHAIR_STATE_SHOW_ALL )
		ServerCallback_SetCommsDialogueEnabled( 1 )
	}
}

void function FRChallenge_GunCreated( entity ent )
{
	if ( file.registeredChallengeWeaponScriptName.find( ent.GetScriptName() ) != -1 )
	{
		AddEntityCallback_GetUseEntOverrideText( ent, FRC_ChallengeGunTextOverride )
	}
}

string function FRC_ChallengeGunTextOverride( entity gun )
{
	entity player = GetLocalViewPlayer()
	if ( !IsValid(player) )
		return ""

	string challengeKey = gun.GetScriptName()
	if ( !(challengeKey in file.registeredFiringRangeChallenges) )
		return ""

	if ( !( FRC_CanCharacterPickup( player, gun ) ) )
		return "#FRC_CHALLENGE_CHAR_DISABLED_INTR"

	return file.registeredFiringRangeChallenges[challengeKey].challengeInteractStr
}
#endif

#if SERVER
                                                                          
 
	                                       
		      

	                              
	                                                            
		      

	                                                                                                                        
		      

	                                                                           
		      

	                                                                                                    
		      

	                                                             
 

                                                                          
 
	                                       
		      

	                              
	                                                            
		      

	                                                                                                                        
		      

	                                                                           
		      

	                                                                                                    
		      

	                                                            
 


                                                                                                   
 
	                              
	                                                                                     

	                                                                          
	 
		                                                                                                  
		                                                                            

		                                               
		                                                                
			                          

		                                           

		                                                                   

		                                                                     
	 
	                                                                               
	 
		                                

		                                                                                                                                            
		                                                                   
	 

	                                                                             
 

                                                                                     
 
	                                
	                                       
	                                       

	                                                                                                            

	            
		                       
		 
			                        
				                                                                                         
		 
	 

	                        

	                                                                            
		      

	                                                                                                                                        
		      

	                                                                                  
 

                                                                                                                                       
 
	                         
		      

	                                 

	                                                            
		      

	                                                                                                                        
		      

	                                    
	                                                                                                 
	 
		                                                              
	 

	                              
	                                                             
 
#endif

#if SERVER || CLIENT
int function FRC_GetChallengeStat( entity player, StatTemplate template )
{
	if ( !IsValid ( player ) )
		return 0

	return GetStat_Int( player, ResolveStatEntry( template ) )
}
#endif

#if SERVER || CLIENT
bool function FRC_CanPickUpWeaponPlayerStatusCheck ( entity player )
{
	if ( player.Anim_IsActive() )
		return false
	if ( player.ContextAction_IsBusy() )
		return false
	if ( player.ContextAction_IsActive() )
		return false
	if ( !player.IsOnGround() )
		return false
	if ( player.IsCrouched() )
		return false
	if ( player.IsSliding() )
		return false
	if ( player.IsTraversing() )
		return false
	if ( player.IsMantling() )
		return false
	if ( player.IsWallRunning() )
		return false
	if ( player.IsWallHanging() )
		return false
	if ( player.IsPhaseShifted() )
		return false
	if ( player.Player_IsSkywardFollowing() )
		return false
	if ( player.Player_IsSkywardLaunching() )
		return false
	if ( StatusEffect_GetSeverity( player, eStatusEffect.placing_phase_tunnel ) )
		return false
	if ( player.GetParent() != null )
		return false
	if ( player.GetPlayerNetBool( "isHealing" ) )
		return false
	if ( player.IsUsingOffhandWeapon( eActiveInventorySlot.mainHand ) )
		return false
	if ( player.IsUsingOffhandWeapon( eActiveInventorySlot.altHand ) )
		return false
	if ( !IsAlive( player ) )
		return false
	if( Bleedout_IsBleedingOut( player ) )
		return false

	return true
}

bool function FRC_GenericCanPickUpWeapon( entity player, entity weapon, int useFlags)
{
	if ( !IsValid ( player ) )
		return false

	if ( !IsValid ( weapon ) )
		return false

	if ( !FRC_CanPickUpWeaponPlayerStatusCheck( player ) )
		return false

	int realm = player.GetRealms()[0]
	if ( (realm in file.firingRangeChallengeDataByRealmTable) && (file.firingRangeChallengeDataByRealmTable[realm].challengeState != eFiringRangeChallengeState.FR_CHALLENGE_INACTIVE) )
		return false

	if ( !FRC_CanCharacterPickup( player, weapon ) )
		return false

	return true
}

bool function FRC_CanPickUpWeapon( entity player, entity weapon, int useFlags )
{
	if ( !IsValid ( player ) )
		return false

	if ( !FRC_CanPickUpWeaponPlayerStatusCheck( player ) )
		return false

	return true
}

bool function FRC_CanCharacterPickup( entity player, entity weapon )
{
	if ( !IsValid ( player ) )
		return false

	if ( !IsValid ( weapon ) )
		return false

	string weaponScriptName = weapon.GetScriptName()
	string disabledCharsOverride = GetCurrentPlaylistVarString( "FRC_" + weaponScriptName + "_disabled_chars", "" )
	if ( disabledCharsOverride ==  "" )
		return true

	array<string> disabledChars = []
	disabledChars.extend( split( disabledCharsOverride, WHITESPACE_CHARACTERS ) )
	ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_Character() )
	string characterRef  = ItemFlavor_GetHumanReadableRef( character ).tolower()

	if ( disabledChars.contains( characterRef ) )
		return false

	return true
}
#endif

