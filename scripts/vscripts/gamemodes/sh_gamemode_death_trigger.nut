global function IsDeathTriggerGameMode
global function ShGameMode_DeathTrigger_Init

global function ShGameMode_DeathTrigger_DeathFieldCircleWaitThread
global function ShGameMode_DeathTrigger_RegisterNetworking

#if CLIENT
global function ShGameMode_DeathTrigger_ServerCallback_AnnouncementSplash
global function ShGameMode_DeathTrigger_ServerCallback_ReduceRingTime
global function ShGameMode_DeathTrigger_ServerCallback_UpdateRui
global function ShGameMode_DeathTrigger_UpdateElimTrackers
#endif

#if CLIENT
const asset ASSET_ANNOUNCEMENT_ICON = $"rui/gamemodes/salvo_war_games/war_games_icon"
#endif

const int MAX_REDUCE_SECOND = 180
const float MAX_PRESHRINK_DURATION = 240.0

const string NETWORKVAR_DEATHTRIGGER_MATCHSTARTTIME = "DeathTrigger_MatchStartTime"

#if SERVER
                                                
                                                 
                                            
#endif

                    
const string HUD_MATCH_TIME_REDUCE_WARNING_1P = "UI_WarGames_DeathTrigger_BarShrink"
const string HUD_BODYCOUNT_CLIMBS_WARNING_1P = "ui_ingame_markedfordeath_playerunmarked"
                    

#if DEV
const bool DEATH_TRIGGER_MODE_DEBUG = false
#endif       

struct
{
	#if SERVER
		                           
		                             
		                             
		                                
		                                      
		                         
		                        
		                                
	#endif
} file

void function ShGameMode_DeathTrigger_Init()
{
	if ( !IsDeathTriggerGameMode() )
	{
		return
	}

	#if SERVER
		                                                         
		                                                                          
		                                                                           
		                                                                                        
		                                                                                                                                         
		                                                                          
		                                                                                  
		                                                                                 
		                                                                                  
		                                                                                  
		                                                                             
	#endif

	RegisterSignal( "DeathTrigger_ApplyDeathsToRoundTime" )

	AddCallback_GameStateEnter( eGameState.Playing, DeathTrigger_OnGameState_Playing )

	#if CLIENT
		CircleBannerAnnouncementsEnable( false )
		SURVIVAL_SetGameStateAssetOverrideCallback( DeathTrigger_OverrideGameStateRUI )
	#endif

	AddCallback_EntitiesDidLoad( DeathTrigger_EntitiesDidLoad )

}

void function DeathTrigger_EntitiesDidLoad()
{
	thread __EntitiesDidLoad()
}

void function __EntitiesDidLoad()
{
	SurvivalCommentary_SetHost( eSurvivalHostType.AI )
}

void function ShGameMode_DeathTrigger_RegisterNetworking()
{
	if ( !IsDeathTriggerGameMode() )
		return

	Remote_RegisterClientFunction( "ShGameMode_DeathTrigger_ServerCallback_UpdateRui", "bool" )
	Remote_RegisterClientFunction( "ShGameMode_DeathTrigger_ServerCallback_ReduceRingTime", "int", 0, MAX_REDUCE_SECOND )
	Remote_RegisterClientFunction( "ShGameMode_DeathTrigger_ServerCallback_AnnouncementSplash" )
	Remote_RegisterClientFunction( "ShGameMode_DeathTrigger_UpdateElimTrackers" )

	RegisterNetworkedVariable( NETWORKVAR_DEATHTRIGGER_MATCHSTARTTIME, SNDC_GLOBAL, SNVT_TIME, -1 )
	RegisterNetworkedVariable( "DeathTrigger_currentElims", SNDC_GLOBAL, SNVT_INT, -1 )
	RegisterNetworkedVariable( "DeathTrigger_totalElimsNeeded", SNDC_GLOBAL, SNVT_INT, -1 )


}

void function DeathTrigger_OnGameState_Playing()
{
	#if DEV
		if ( DEATH_TRIGGER_MODE_DEBUG )
		{
			printf("DeathTrigger_OnGameState_Playing()")
		}
	#endif

	#if SERVER
		                           
	#endif
}

#if SERVER
                                  
 
	                                         

	                              
		       
			                               
			 
				                                          
			 
		      

		                                                                              
	   

	                                                                                                                                                                                                                          
	              
	 
		                                                                 
		                                   
		 
			                  
			                                                                     

			                                         
			 
				                               

			 
		 

		           
	 
 

                                           
 
	                                                   

	                                                                 

	                         
	                                                          
	 
		                        
	 

	                                                                                                                  
	                                                                                                                        
	                                                                            


	                                
	 
		                                   
	 

	                                                           

	                                  
	                                                                            
	                                                            
	                                     
	                                                                    


	                                           
	                                      
	 
		                        
		 
			                                                                                     
		 
	 


	                               
		      

	       
		                               
		 
			                                                                                                                                  
		 
	      

	                                                       
	                                             
	 
		                               
		                                                                                                                                        
		                                                                                                   
		                                  
		 
			                                                                                                             

		 
		                                                 
		                                                   
	 
 

                                                                                 
 
	       
		                               
		 
			                                       
		 
	      
	                                

	                                                             
	                            
		                                             

	                                                                    
	                              

	                                      
	 
		                        
		 
			                                                                                                   
		 
	 

	                             
 

                                                                                           
 
	       
		                               
		 
			                                       
		 
	      

	                                          
	                  

	                                      
	 
		                        
		 
			                                                                                    
		 
	 

	                             
 

                                                          
 
	                                                                  

	                                                                     

	       
		                              
			                               
			 
				                                                                                                                             
			 
		   
	      

	                                      
	 
		                                                             
	 

	        

	       
	                               
	 
		                                                                                                                      
	 
	      

	                                                                   
 

                                                     
 
	                                       
	 
		                             
		                              

		       
			                               
			 
				                                  
			 
		      

		                                      
		 
			                        
			 
				                                                                                                     
			 
		 
	 
 

                                                               
 
	       
		                               
		 
			                                            
		 
	      

	                                                                                                                
 

                                                                     
 
	                         
		      

	                                                                                                    
 
#endif          

#if CLIENT
void function DeathTrigger_OverrideGameStateRUI()
{
	#if DEV
		if ( DEATH_TRIGGER_MODE_DEBUG )
		{
			printf("[CLIENT] DeathTrigger_OverrideGameStateRUI()")
		}
	#endif

	ClGameState_RegisterGameStateAsset( $"ui/gamestate_info_death_trigger.rpak" )
	ClGameState_RegisterGameStateFullmapAsset( $"ui/gamestate_info_fullmap_death_trigger.rpak" )

}
                      
void function ShGameMode_DeathTrigger_ServerCallback_ReduceRingTime( int secondsToRemove )
{
	#if DEV
		if ( DEATH_TRIGGER_MODE_DEBUG )
		{
			printf("[CLIENT] ShGameMode_DeathTrigger_ServerCallback_ReduceRingTime()")
		}
	#endif

	secondsToRemove = ClampInt( secondsToRemove, 0, MAX_REDUCE_SECOND )

	float now = Time()

	RuiSetInt( ClGameState_GetRui(), "newDeathsTotal", secondsToRemove )
	RuiSetGameTime( ClGameState_GetRui(), "lastDeathTime", now )
	if ( IsValid( GetCameraCircleStatusRui() ) )
	{
		RuiSetInt( GetCameraCircleStatusRui(), "newDeathsTotal", secondsToRemove )
		RuiSetGameTime( GetCameraCircleStatusRui(), "lastDeathTime", now )
	}
	RuiSetInt( GetFullmapGamestateRui(), "newDeathsTotal", secondsToRemove )
	RuiSetGameTime( GetFullmapGamestateRui(), "lastDeathTime", now )
}

const float SECONDS_PER_DEATH = 1.0                                         
void function ShGameMode_DeathTrigger_ServerCallback_UpdateRui( bool isEnabled )
{
	#if DEV
		if ( DEATH_TRIGGER_MODE_DEBUG )
		{
			printf("[CLIENT] ShGameMode_DeathTrigger_ServerCallback_UpdateRui() isEnabled = " + isEnabled)
		}
	#endif



	if ( isEnabled == true )
	{
		int currentDeathFieldStage = SURVIVAL_GetCurrentDeathFieldStage()

		float nextCircleStartTime = GetGlobalNetTime( "nextCircleStartTime" )

		#if DEV
			if ( DEATH_TRIGGER_MODE_DEBUG )
			{
				printf("[CLIENT] ShGameMode_DeathTrigger_ServerCallback_UpdateRui() NextCircleStartTime = " + nextCircleStartTime)
			}
		#endif

		ShGameMode_DeathTrigger_UpdateElimTrackers()

		RuiSetFloat( ClGameState_GetRui(), "secondsPerDeath", SECONDS_PER_DEATH )
		RuiSetGameTime( ClGameState_GetRui(), "circleStartTimeCache", nextCircleStartTime )
		if ( IsValid( GetCameraCircleStatusRui() ) )
		{
			RuiSetFloat( ClGameState_GetRui(), "secondsPerDeath", SECONDS_PER_DEATH )
			RuiSetGameTime( GetCameraCircleStatusRui(), "circleStartTimeCache", nextCircleStartTime )
		}
		RuiSetFloat( ClGameState_GetRui(), "secondsPerDeath", SECONDS_PER_DEATH )
		RuiSetGameTime( GetFullmapGamestateRui(), "circleStartTimeCache", nextCircleStartTime )
	}

	if ( isEnabled == true )
	{
		DeathTrigger_DisplayRoundTimerUI( true )
	} else {
		thread DeathTrigger_HideRoundTimerAfterDelay_Thread()
	}
}

void function DeathTrigger_HideRoundTimerAfterDelay_Thread()
{
	wait 1.0
	DeathTrigger_DisplayRoundTimerUI( false )
}

void function DeathTrigger_DisplayRoundTimerUI( bool isVisible )                                                                                                  
{
	RuiSetBool( ClGameState_GetRui(), "shouldShowDeathTriggerRoundTimer", isVisible )
	if ( IsValid( GetCameraCircleStatusRui() ) )
	{
		RuiSetBool( GetCameraCircleStatusRui(), "shouldShowDeathTriggerRoundTimer", isVisible )
	}
	RuiSetBool( GetFullmapGamestateRui(), "shouldShowDeathTriggerRoundTimer", isVisible )
}

void function DeathTrigger_WarningSplash()
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return

	AnnouncementData announcement = Announcement_Create( "#WAR_GAMESMODE_DEATH_TRIGGER_WARNING" )
	announcement.drawOverScreenFade = true
	Announcement_SetHideOnDeath( announcement, true )
	Announcement_SetDuration( announcement, 4.0 )
	Announcement_SetPurge( announcement, true )
	Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_SWEEP )                           
	Announcement_SetSoundAlias( announcement, HUD_BODYCOUNT_CLIMBS_WARNING_1P )
	Announcement_SetTitleColor( announcement, <1, 0, 0> )
	AnnouncementFromClass( player, announcement )
}


void function ShGameMode_DeathTrigger_ServerCallback_AnnouncementSplash()
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return

	AnnouncementData announcement = Announcement_Create( "#WAR_GAMESMODE_DEATH_TRIGGER" )
	announcement.drawOverScreenFade = true
	Announcement_SetSubText( announcement, "#WAR_GAMESMODE_DEATH_TRIGGER_DESC" )
	Announcement_SetHideOnDeath( announcement, true )
	Announcement_SetDuration( announcement, 16.0 )
	Announcement_SetPurge( announcement, true )
	Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_SWEEP )
	Announcement_SetSoundAlias( announcement, SFX_HUD_ANNOUNCE_QUICK )
	Announcement_SetTitleColor( announcement, <0, 0, 0> )
	AnnouncementFromClass( player, announcement )
}

void function ShGameMode_DeathTrigger_UpdateElimTrackers()
{
	var rui = ClGameState_GetRui()
	RuiSetInt( rui, "currentElims" , GetGlobalNetInt( "DeathTrigger_currentElims" ))
	RuiSetInt( rui, "totalElimsNeeded" , GetGlobalNetInt( "DeathTrigger_totalElimsNeeded" ))
}
#endif

void function ShGameMode_DeathTrigger_DeathFieldCircleWaitThread( float waitTime )
{
	                                                                                                
	while ( Time() <  GetGlobalNetTime( "nextCircleStartTime" ) )
	{
		WaitFrame()
	}
}



bool function IsDeathTriggerGameMode()
{
	return GetCurrentPlaylistVarBool( "is_death_trigger_mode", false )
}