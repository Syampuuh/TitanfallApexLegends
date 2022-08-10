global function MapZones_SharedInit
global function MapZones_RegisterNetworking
global function MapZones_RegisterDataTable
global function GetZoneNameForZoneId
global function GetZoneMiniMapNameForZoneId
global function MapZones_GetZoneIdForTriggerName
global function GetDevNameForZoneId

#if CLIENT
global function SCB_OnPlayerEntersMapZone
global function MapZones_ZoneIntroText
global function MapZones_ZoneIntroTextFullscreenWithSubtext
global function MapZones_GetChromaBackgroundForZoneId
#endif

#if SERVER
                                         
                                                     
                                             
                                          
                                              
                                       
                                                 
                                            
                                               
                                                
                                               
                                                 
                                        
                                                  
                                                    
                                                   
  
                                          
                                           
                                                  
                                                 
                                        
  
                                      
  

                                                     
                                                    

               
                                              
                     
#endif          

#if (SERVER && DEV)
                                    
                                         
                            
                                      
#endif                   

global struct ZonePopulationInfo
{
	int playersInside = 0
	int playersNearby = 0
}

global enum eZonePop
{
	NO_PLAYERS_AROUND,
	PLAYERS_NEARBY,
	PLAYERS_INSIDE,

	_count
}

#if SERVER
                                                              
#endif          

struct
{
	bool mapZonesInitialized = false
	var mapZonesDataTable
	table<int, int> calculatedZoneTiers

	#if SERVER
		                                            
	#endif
} file

const int INVALID_ZONE_ID = -1

string function GetDevNameForZoneId( int zoneId )
{
	return GetDataTableString( file.mapZonesDataTable, zoneId, GetDataTableColumnByName( file.mapZonesDataTable, "triggerName" ) )
}

const string EDITOR_CLASSNAME_ZONE_TRIGGER = "trigger_pve_zone"
void function MapZones_SharedInit()
{
#if SERVER
	                                                                                                 

	                                              

	                                                        
	                                                 

	                                             
#endif          
}

const string FUNCNAME_OnPlayerEntersZone = "SCB_OnPlayerEntersMapZone"
void function MapZones_RegisterNetworking()
{
	Remote_RegisterClientFunction( FUNCNAME_OnPlayerEntersZone, "int", 0, 128, "int", 0, 4 )
}

void function MapZones_RegisterDataTable( asset dataTableAsset )
{
	file.mapZonesDataTable = GetDataTable( dataTableAsset )
	file.mapZonesInitialized = true
}

string function GetZoneMiniMapNameForZoneId( int zoneId )
{
	Assert( zoneId < GetDataTableRowCount( file.mapZonesDataTable ) )
	string zoneName = GetDataTableString( file.mapZonesDataTable, zoneId, GetDataTableColumnByName( file.mapZonesDataTable, "miniMapName" ) )
	return zoneName
}

string function GetZoneNameForZoneId( int zoneId )
{
	Assert( zoneId < GetDataTableRowCount( file.mapZonesDataTable ) )
	string zoneName = GetDataTableString( file.mapZonesDataTable, zoneId, GetDataTableColumnByName( file.mapZonesDataTable, "zoneName" ) )
	return zoneName
}

string function MapZones_GetChromaBackgroundForZoneId( int zoneId )
{
	int column = GetDataTableColumnByName( file.mapZonesDataTable, "chroma" )
	if ( column < 0 )
		return ""

	string chroma = GetDataTableString( file.mapZonesDataTable, zoneId, column )
	return chroma
}

int function MapZones_GetZoneIdForTriggerName( string triggerName )
{
	int zoneId = GetDataTableRowMatchingStringValue( file.mapZonesDataTable, GetDataTableColumnByName( file.mapZonesDataTable, "triggerName" ), triggerName )
	return zoneId
}

string function GetZoneGroupForZoneId( int zoneId )
{
	Assert( zoneId < GetDataTableRowCount( file.mapZonesDataTable ) )

	string name = ""
	int column = GetDataTableColumnByName( file.mapZonesDataTable, "zoneGroup" )
	if ( column >= 0 )
		name = GetDataTableString( file.mapZonesDataTable, zoneId, column )

	if ( name.len() == 0 )
		return GetZoneNameForZoneId( zoneId )
	return name
}

string function MapZones_GetZoneStatsRef( int zoneId )
{
	if ( !file.mapZonesInitialized )
		return ""

	Assert( zoneId < GetDataTableRowCount( file.mapZonesDataTable ) )
	if ( zoneId < 0 )
		return ""

	string statsRef = ""
	int column = GetDataTableColumnByName( file.mapZonesDataTable, "statsRef" )
	if ( column >= 0 )
		statsRef = GetDataTableString( file.mapZonesDataTable, zoneId, column )

	return statsRef
}

#if SERVER

               
 
	                      
	   		           
	                          

	                  

	                 
	                 

	                                   

	          
	               
	                

	               
 
                                

               
                                                         
 
	                   

	                                 
	 
		                          
			                                            
	 

	          
 
                     


                                                                  
 
	                         
		      
	                                     
	                                  
 

                                                   
 
	                                     
	                                  
 

                               
 
       
	                         
             

	                                
		      

	                          
 

                                 
 
	                                             

	                                      
	 
		                                 
		 

			                                                                
				        

			                                             
				        

			                                                                  
			                                                               
		 
		           
	 

	                                           
	 
		                                      
			        

		                                           
		 
			                                                             
				        

			                                                                                          
			                                                                                          
		 
	 
 

                                                      
 
	                                      
	 
		                                            
			                
	 

	         
 

                                                          
 
	                 
	                          
	                                      
	 
		                                                          
		                      
			        

		                    
		               
	 

	               
 

                                                                  
 
	                                               
	                  
		             

	                                             
 

                                                            
 
	                               
		         

	                                 
	                                                   
 

                                                        
 
	                               
		           

	                                 
	                     
 

                                                  
 
	                               
		         

	                                 
	                  
 

                                                                              
 
	                                                
	 
		                     
	 
 

                                                                           
 
	                               

	                         
	                                 
	                                       
	                                       
	             
 

                                                          
 
	                               
		         

	                                 
	                   
 

                                                                       
 
	                   
	                                           
	 
		                                      
			                    
	 

	          
 

                                                                  
 
	                                                                                
 

                                                            
 
	                               

	                                 
	                      
 

                                                                           
 
	                       
	                            
	 
		                                 
		                                           
		 
			                                     
				        
			                                          
				        
			                                 
		 
	 
	                   
 

                                                    
 
	                                        
	                                        
	                            

	                          
 

                                                  
 
	                                        
	                                                    
	                                  
	 
		                           
			                   
	 
	                 
 

                                               
 
	                                 
	                                
	 
		                             
		      
	 

	                                                       
	                                                              
	                                
	 
		                                                              
		                             
		      
	 

	                                                                                                                          
	                              
	 
		                                                                                                         
	 

	           
	                         
	                                

	                                  
	                                      
	                                          
	                                    
	                                        
	                                       
	                                   
	                                       
	                                     
	                                     
	                                                                 

	                        
	                  
	                                            
	                                              
	                                                

	                                                

	                                                          
	 
		                                                                     
			        

		                                                                   
		                                                                         
		                                           
	 
 

                                
 
	                                
		        

	                                                     
 

                                            
 
	                   
	                                      
	 
		                                 
			                       
	 

	          
 


                                                                                                 
 
	                                
	                           
	                                
		      

	                               
		                                            
 

                                   
                                           
 
	                                         
		      
	                                
 

                                                          
 
	                                                
		      

	                                                 
	                                               
	 
		                                           
		                           
		                          
	 
	                     
	                    

	                                        
 

                                                             
 
	                                                   

	                                 
	                                               
	 
		                                           
		                           
		                          
	 
	                     
	                    

	                               

	                                                    
 

                                                
 
	                                             
	 
		                                    
			        

		                                                       
		                                      
			                                
	 

	                           
 

                                                                                  
 
	                                            
		      

	                                 
	                                            
	                               
	                                   
 

                                                                     
 
	                                           
		                                                           
	                          
 

                                                               
 
	                                 
	                                                        
 

                                                  
 
	                                        
	                                    
		                                              
 

                                                                   
 
	                                   
	                  
		                                                                                                       
 

                                                                     
 
	                                                             
	                                               

	                                        

	                                                                                                       

	                                         
	                                        
	 
		                                     
		                                     
		                                  
		                                       
	 
 

                                                     
 
	                         
		      

	                               

	                                                 
		                                               

	                                                     
		      

	                                                  
	 
		                                             
		                            
		         
	 

	            
		                       
		 
			                       
				      

			                                              
		 
	 

 

                                                     
 
	                                 
	                           
		                              
	                           
		                              
	                                 
 

                                                              
 
	                                        
	                            
	 
		                                                  
		                        
			                 
	 
	              
 

                                                                        
 
	                         
		              

	                      
	                                
	 
		                                                     
		                            
	 
	                                                
	             
 

                                                                           
 
	                                         
	                   
	                             
	 
		                                                            
		                 
			        
		             
	 

	         
 
#endif              


#if CLIENT
var s_zoneIntroRui = null
void function MapZones_ZoneIntroText_( entity player, string zoneDisplayName, int zoneTier, string zoneDisplaySubText, bool doFullscreenRui )
{
	if ( GetGlobalNetBool( "isMapZoneDisplayTextDisabled" ) )
		return

	if ( s_zoneIntroRui != null )
		RuiDestroyIfAlive( s_zoneIntroRui )

	var rui
	if ( doFullscreenRui )
		rui = CreateFullscreenRui( $"ui/map_zone_intro_title.rpak", 0 )
	else
		rui = CreateCockpitRui( $"ui/map_zone_intro_title.rpak", 0 )

	string currentPlaylist = GetCurrentPlaylistName()

	RuiSetString( rui, "titleText", zoneDisplayName )
	if ( GetPlaylistVarBool( currentPlaylist, "loot_display_zone_tier", true ) )
	{
		RuiSetString( rui, "subTextDefault", zoneDisplaySubText )
		RuiSetInt( rui, "zoneTier", zoneTier )
	}
	RuiSetBool( rui, "minimapIsDisabled", MiniMapIsDisabled() )
	s_zoneIntroRui = rui
}
void function MapZones_ZoneIntroText( entity player, string zoneDisplayName, int zoneTier )
{
	MapZones_ZoneIntroText_( player, zoneDisplayName, zoneTier, "", false )
}
void function MapZones_ZoneIntroTextFullscreenWithSubtext( entity player, string zoneDisplayName, int zoneTier, string subText )
{
	MapZones_ZoneIntroText_( player, zoneDisplayName, zoneTier, subText, true )
}

array<string> s_lastZoneDisplayNames = ["", ""]
int s_lastZoneDisplayNameIndex = -1
void function SCB_OnPlayerEntersMapZone( int zoneId, int zoneTier )
{
	entity player = GetLocalViewPlayer()

	Chroma_SetPlayerZone( zoneId )

	int ceFlags = player.GetCinematicEventFlags()
	if ( ceFlags & (CE_FLAG_HIDE_MAIN_HUD | CE_FLAG_INTRO) )
		return

	string zoneDisplayName = GetZoneNameForZoneId( zoneId )
	if ( s_lastZoneDisplayNames.contains( zoneDisplayName ) )
		return
	if ( zoneDisplayName.len() == 0 )
		return

	if ( IsPVEMode() )
		zoneTier = 0
	if ( IsPVEMode() || (zoneTier > 1) )
		ClientMusic_RequestStingerForNewZone( zoneId )

	MapZones_ZoneIntroText( player, zoneDisplayName, zoneTier )
	s_lastZoneDisplayNameIndex = ((s_lastZoneDisplayNameIndex + 1) % s_lastZoneDisplayNames.len())
	s_lastZoneDisplayNames[s_lastZoneDisplayNameIndex] = zoneDisplayName
}
#endif          



#if (SERVER && DEV)
                                         
 
	                                
		                                         
	                                                                                                                                                  
 

                                       
 
	                                        

	                     
	 
		                
		                                   
		 
			                                                            
			                                                   
			                                                         

			                                             
			                                        

			                      
				                                              
			                    
				                                          

			                        
				                                                      
			    
				            
		 
		                                    
	 

	                  
	 
		                
		                                                              
		 
			                               
				        

			                                 
			                                                         
				        

			                                                                                                      

			                                              
			                                              
			                                               
			                                               
			                                               
			                                                                               
		 
		                                   
	 
 

                                    
 
	                                                  
	                                                           
	 
		                              
			        
		                                

		                                   
		                                                                                                                                                                                                                                           

		                         
		                                                  
			                                                                                                                
		                                          
		            
	 
 

                             
                                         
 
	                                    
 

                                                
 
	                                                            
	                                 
	                                                           
 

                                                 
 
	                     
	                                
	 
		                                                                            
	 
	    
	 
		                                                                           
		                  
		 
			                                           
			 
				                                                                          
				                    
			 
		 
	 
	            
 

                                
 
	              
	 
		                       
		 
			                         
		 

		           
	 
 

#endif                       
