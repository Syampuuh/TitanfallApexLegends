                                                                                                               
                                                                                                               
  
  		                                                                                                                                                                                                                                                         
  		                                                                                                                                                                                                                                                                               
  		                                                                                                                                                                                                                                               
  		                                                                                                                                                                                                                                             
  		                                                                                                                                                                                                                                                                       
  		                                                                                                                                                                                                                                                     
  
  		                
  		                                  
  		           
  


global function ShGameModeExplore_IsActive
global function ShGameModeExplore_Init
global function ShGameModeExplore_RegisterNetworking

const string EXPLOREMODE_MOVER_SCRIPTNAME 		= "exploremode_mover"

#if CLIENT
	global function ShGameModeExplore_ServerCallbackAnnouncementSplash
	global function ShGameModeExplore_ServerCallbackClearAnnouncement
	global function ShGameModeExplore_UpdateDeathfieldUI

	const string EXPLOREMODESOUND_INTRO 			= "ui_ingame_shadowsquad_finalsquadmessage"
	const string EXPLOREMODESOUND_RING_CLOSING 		= "ui_ingame_shadowsquad_shipincoming"
	const string EXPLOREMODESOUND_EXIT 				= "UI_InGame_KillLeader"
#endif

#if SERVER && DEV

#endif

#if SERVER
	                                                    
	                                                
#endif

enum eGameModeExploreAnnounceType
{
	INTRO,
	RING_CLOSING,
	RING_CLOSING_LAST_TIME,
	DROPSHIP_ARRIVING,
	DROPSHIP_ARRIVING_LAST_TIME,
	DROPSHIP_EMBARKING,
	DROPSHIP_EMBARKING_LAST_TIME,

	_count
}

struct
{
	#if SERVER
		                  
		                   
		                         
		                              

		                
		                     
	#endif
	int planePassMax
}file


bool function ShGameModeExplore_IsActive()
{
	return GetCurrentPlaylistVarBool( "survival_explore_mode", false )
}


void function ShGameModeExplore_Init()
{
	if ( !ShGameModeExplore_IsActive() )
		return

	printf( "ShGameModeExplore_Init()" )

	file.planePassMax = GetCurrentPlaylistVarInt( "max_plane_passes", 3 )

	#if SERVER
		                        
		                                
		                                                                

		                                                                                             
		                                                                                         
		                                                                                       
	#endif          

	#if CLIENT
		AddCallback_GameStateEnter( eGameState.Resolution, OnGamestateResolution )
	#endif
}


        
void function ShGameModeExplore_RegisterNetworking()
{
	if ( !ShGameModeExplore_IsActive() )
		return

	printf( "ShGameModeExplore_RegisterNetworking()" )

	Remote_RegisterClientFunction( "ShGameModeExplore_ServerCallbackAnnouncementSplash", "int", 0, eGameModeExploreAnnounceType._count, "int", 0, 10 )
	Remote_RegisterClientFunction( "ShGameModeExplore_ServerCallbackClearAnnouncement" )
	Remote_RegisterClientFunction( "ShGameModeExplore_UpdateDeathfieldUI" )
}
            


#if SERVER
                                                                                    
 
	                                                                       
	                                 
		      

	                                                      
	                                                          
	 
		                                                   
			      
	 

	                                     
 


                                                                  
 
	                                        
	 
		                      
			              
	 
	                                                
	 
		                      
			              
	 
	                                                   
		                        

	                         
		      

	                                       
	 
		                            
		                                  
		           
	 

	                                    

	                                             

	                             
	                           
	                           
	                               
	                             
	                          
	                               
	                         
	                                        
	                                    

	                                                               
	                                           
	                                               
	                                                   
	                                            
	                                 

	           

                     
	                                                  
	 
		                                           
		           
	 
      

	                                  
	 
		                                 
		           
	 

	                                    
	 
		                                                                       
		           
	 
 
#endif          


                                                                                          
                                                                                          
  
  		                                                                                                                                                                                                     
  		                                                                                                                                                                                                                       
  		                                                                                                                                                                                                         
  		                                                                                                                                                                                                       
  		                                                                                                                                                                                                       
  		                                                                                                                                                                                               
  


#if SERVER
                                                                          
 
	                                                           
	                                                                                            
			                                                          
 


                                                   
 
	                           
 


                                                     
 
	                                                   

	                                
	                               
	                    
	                        
	                               
	                              

	                      
	                                 

	                               
	                            
	                                 

	                                      

	                   
	                             

	                            
	                                 
		                               
	                                  
		                                

	           
	                                    

	                                            
	 
		                         
			        

		                                                        

		                         
		 
			                                  
			                                              
			                                                          
			                                                              
		 

		                                                                 
		                                
			                         

		                                     
	 
	                                             
 


                                                          
 
	                                           

	                                    
	                    
	                                  
	                                       

	                                   

	                                                                                            
	                                                                                                                                             
 
#endif         


                                                                                          
                                                                                          
  
  		                                                                                                                                                                                                             
  		                                                                                                                                                                                                                      
  		                                                                                                                                                                                          
  		                                                                                                                                                                                          
  		                                                                                                                                                                                                      
  		                                                                                                                                                                                                 
  


#if SERVER
                                                                                                   
 
	                                                
	                                                                   

	                 
	 
		                                                                            
		                         

		                                              
	 
 


                                                     
 
	           

	                                            
	 
		                                                
			                                                                                                                                                                        
		    
			                                                                                                                                                              
	 
 


                                                                                                  
 
	                                                
	                                                                  

	                 
	 
		                                                                            
		                                                    
	 
	                      
	 
		                             

		                                                
		 
			                                            
				                                                                                                                                                                              
			                                        
		 
		    
		 
			                                            
				                                                                                                                                                                    
			                                        
		 
	 
 


                                               
 
	                                                       
	           

	                                            
	 
		                        
			                                     
	 

	           

	                                     
	 
		                                                                                            
		                             

	 

	                                                           
	                                              
 


                                               
 
	                                                       
	           

	                                            
	 
		                         
			        
		                                                        
	 

	                                                              
	                                                                                                                   
 
#endif         


                                                                                          
                                                                                          
  
  		                                                                                                                                                                                            
  		                                                                                                                                                                                                        
  		                                                                                                                                                                                
  		                                                                                                                                                                                
  		                                                                                                                                                                                        
  		                                                                                                                                                                                    
  


#if SERVER
                                                           
 
	                                                         
	           

	                                            
	 
		                                                
			                                                                                                                                                                             
		    
			                                                                                                                                                                   
	 

	                                  
 


                                                
 
	                                              

	                                
		                        

	                                     
	 
		                                                                                            
		                             
	 

	                                                                               
	                                          
	                         

	                                                                                                

	                                            
	                                                 
	                      
	                        
	                                    
	                                                                                             
	                         
	                         
	                
	                          
	                                 
	                                              
	                                     
	                                  
	                      
	                        
	            

	                      
	                           

	                                                                                            

	                                                         
 


                                                                                   
 
	                                                                            

	                      
	                    

	                                                                                                                                                                       
	                                         

	                                           
	                                               

	       

	                            
	 
		                                                                                          

		                           
		                                           
	 
 
#endif         


                                                                                          
                                                                                          
  
  		                                                                                                                                                                                      
  		                                                                                                                                                                                                      
  		                                                                                                                                                                                      
  		                                                                                                                                                                                            
  		                                                                                                                                                                                                              
  		                                                                                                                                                                                              
  


#if CLIENT
void function ShGameModeExplore_ServerCallbackAnnouncementSplash( int messageIndex, int currentPass )
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return

	printf( "ShGameModeExplore_ServerCallbackAnnouncementSplash() - %i", messageIndex )

	string messageText = ""
	string subText     = ""
	float duration     = 8.0
	int style          = ANNOUNCEMENT_STYLE_SWEEP
	string soundAlias  = ""
	vector titleColor  = <0, 0, 0>

	  	                                                                          
	if ( messageIndex == eGameModeExploreAnnounceType.INTRO )
	{
		messageText = "#EXPLOREMODE_NAME"
		subText     = Localize( "#EXPLOREMODE_DESC_INGAME", currentPass, file.planePassMax )
		soundAlias  = EXPLOREMODESOUND_INTRO
	}
	else if ( messageIndex == eGameModeExploreAnnounceType.RING_CLOSING )
	{
		messageText = "#EXPLOREMODE_ANNOUNCE_RINGS"
		subText 	= "#EXPLOREMODE_ANNOUNCE_RINGS_SUB_A"
		soundAlias 	= EXPLOREMODESOUND_RING_CLOSING
	}
	else if ( messageIndex == eGameModeExploreAnnounceType.RING_CLOSING_LAST_TIME )
	{
		messageText = "#EXPLOREMODE_ANNOUNCE_RINGS"
		subText 	= "#EXPLOREMODE_ANNOUNCE_RINGS_SUB_B"
		soundAlias 	= EXPLOREMODESOUND_RING_CLOSING
	}
	else if ( messageIndex == eGameModeExploreAnnounceType.DROPSHIP_ARRIVING )
	{
		messageText = "#EXPLOREMODE_ANNOUNCE_DROPSHIP_IN"
		subText 	= "#EXPLOREMODE_ANNOUNCE_DROPSHIP_IN_SUB_A"
		duration 	= 8.0
		soundAlias 	= EXPLOREMODESOUND_EXIT
	}
	else if ( messageIndex == eGameModeExploreAnnounceType.DROPSHIP_ARRIVING_LAST_TIME )
	{
		messageText = "#EXPLOREMODE_ANNOUNCE_DROPSHIP_IN"
		subText 	= "#EXPLOREMODE_ANNOUNCE_DROPSHIP_IN_SUB_B"
		duration 	= 8.0
		soundAlias 	= EXPLOREMODESOUND_EXIT
	}
	else if ( messageIndex == eGameModeExploreAnnounceType.DROPSHIP_EMBARKING )
	{
		Minimap_DeathFieldDisableDraw()
		                              

		messageText = "#EXPLOREMODE_ANNOUNCE_DROPSHIP_OUT"
		subText 	= "#EXPLOREMODE_ANNOUNCE_DROPSHIP_OUT_SUB_A"
		duration 	= 5.0
		soundAlias 	= EXPLOREMODESOUND_EXIT
	}
	else if ( messageIndex == eGameModeExploreAnnounceType.DROPSHIP_EMBARKING_LAST_TIME )
	{
		CircleAnnouncementsEnable( false )

		messageText = "#EXPLOREMODE_ANNOUNCE_DROPSHIP_OUT"
		subText 	= "#EXPLOREMODE_ANNOUNCE_DROPSHIP_OUT_SUB_B"
		duration 	= 5.0
		soundAlias 	= EXPLOREMODESOUND_EXIT
	}

	AnnouncementData announcement = Announcement_Create( messageText )
	announcement.drawOverScreenFade = true
	Announcement_SetSubText( announcement, subText )
	Announcement_SetHideOnDeath( announcement, true )
	Announcement_SetDuration( announcement, duration )
	Announcement_SetPurge( announcement, true )
	Announcement_SetStyle( announcement, style )
	Announcement_SetSoundAlias( announcement, soundAlias )
	Announcement_SetTitleColor( announcement, titleColor )
	AnnouncementFromClass( player, announcement )
}


void function ShGameModeExplore_ServerCallbackClearAnnouncement()
{
	ClearAnnouncements()
}

void function ShGameModeExplore_UpdateDeathfieldUI()
{
	UpdateFullmapRuiTracks()
}

void function OnGamestateResolution()
{
	if ( CanGetLocalPlayer() )
		ScreenFade( GetLocalViewPlayer(), 0, 0, 0, 255, 0.5, 0, FFADE_OUT | FFADE_STAYOUT )

	Remote_ServerCallFunction( "ClientCallback_LeaveMatch" )
}

#endif         