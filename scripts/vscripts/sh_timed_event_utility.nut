                                                                                           

global function TimedEvents_Init

#if SERVER || CLIENT
	global function TimedEvents_RegisterTimedEvent
#endif

#if SERVER
	                                                    
	                                                 
#endif

#if DEV && SERVER
	                                                  
#endif                     




const float TIMED_EVENT_DISPLAY_BUFFER = 10.0
const string WAYPOINTTYPE_TIMEDEVENTTRACKER = "timed_event_tracker"

const INT_EVENTINDEX =			4
const GAMETIME_START_TIME = 	0
const GAMETIME_END_TIME = 		1
global const WAYPOINT_EVENT_STRING_AWARD = 			0

#if SERVER
                                                                  
                                                                   
#endif



                                                                                                                               
#if CLIENT
global struct TimedEventLocalClientData
{
	string eventName
	string eventDesc
	vector colorOverride
	bool shouldShowPreamble
	bool shouldHideUntilPrembleDone
	bool shouldHideTimer
	float eventEndTime                     
}
#endif


global struct TimedEventData
{
	#if SERVER
		                     
		                                     
		                                    			                                                                                                                                          
		                                           		                        
		      											               	                                                                                     
		      											               	                                                              
		      											           		                            
		    											                   	                    	                                                     

		                         						                                 
		    											                                    
	#endif

	#if CLIENT
		string eventName                                                                                    
		string eventDesc	                                                                                
		vector colorOverride                                                                               

		void functionref( entity, TimedEventLocalClientData )		infoOverrideFunctionThread
	#endif

	bool 	shouldHideUntilPrembleDone = false				                                               
	bool   	shouldShowPreamble = true				                                                  
	bool 	shouldHideTimer = false                                                                                                
}




struct
{
	array<TimedEventData>		timedEvents
	table<int, TimedEventData>	indexToTimedEvent
	table<TimedEventData, int>	timedEventToIndex

	#if SERVER
		                                     
		                                                      
		                                                 
		                                                                                
		                                                                                       
	#endif          

	#if CLIENT
		var 										timedEventRui
		table<int, entity>							indexToWaypoint
		table<entity, TimedEventLocalClientData >	waypointToLocalData
	#endif
}
file





                                                      
	                                                                                                           
	                                                                                               
  





void function TimedEvents_Init()
{
	#if SERVER || CLIENT
	if ( !GameMode_GetTimedEventsEnabled( GameRules_GetGameMode() ) )
		return
	#endif

	#if SERVER
		                                                 
		                                                    
		                                   
		                            
		                                                                                
		                                                                                  
	#endif

	#if CLIENT
		Waypoints_RegisterCustomType( WAYPOINTTYPE_TIMEDEVENTTRACKER, InstanceWPTimedEventTracker )
		AddCallback_GameStateEnter( eGameState.Playing, OnGamestatePlaying_TimedEvents_Client )
		AddCallback_GameStateEnter( eGameState.Epilogue, OnGamestateEpilogue_TimedEvents_Client )
	#endif
}







#if SERVER || CLIENT
void function TimedEvents_RegisterTimedEvent( TimedEventData data )
{
	if ( !GameMode_GetTimedEventsEnabled( GameRules_GetGameMode() ) )
		return

	int timedEventIndex = file.timedEvents.len()
	file.timedEvents.append( data )

	file.indexToTimedEvent[ timedEventIndex ] <- data
	file.timedEventToIndex[ data ] <- timedEventIndex
}
#endif


#if SERVER
                                                                         
                                                                                                                                                                                                                   
 
	                                                                 
		      

	                                                                                                                                                                                                                                 
	                                                                                                                                                                                                                                               

	                                                                                          
	                                                                                
	                                                        
	                                                                      
	                                    

	       
		                                                  
	             
 
#endif          

#if SERVER
                                              
 
	                                                        
 

                                               
 
	                                                         
 

                                                          
 
	                                                 
	                        

	                                            

	                                                                                                                             
	                                                      
	                                      

	                                    
	 
		                                                                                                  
		 
			                                                                                                                  
			                                    
			 
				                                    
			 
			    
			 
				                                      
				                                
			 
		 
	 

	                                                                                      

	                                                                                                                                              
	 
		                                     
		 
			                          

			                                                                                           
			                                                        
			 
				                                                      
				 
					                                                                                                       
						        
				 

				                                   
				                                          

				                       
				                          
				                        
				 
					                                                           
					                        
					                                      
				 
				    
				 
					                             
					                              
						        

					                          
					                                      
				 

				                              			                              
				                                		                     
				                               
					                                                     

				                                            
				                                             
					                                    

				                                                    
				                                    
				 
					       
						                                                                
					             

					                                      
					                                        

					                               
					 
						                                                                      
					 

					                                                               

					                                                                                                    
					                                                           
				 
			 

			                                                      

			           
		 
	 
	                                                                                                         
	 
		       
			                                                                                                      
		             

		                                          
	 

	       
		                                                                       
	             

	                                                              
 

                                                                                                                                                                    
                                                                                                           
 
	                                                     
	                        
		      

	                                                 
	                                                                  

	                                                                                                                                                                                   

	                              
	                                                               

	                                                

	                                          
	                                                
		                     

	                 
	                                                                                           

	                                                                                                                            

	                                            
	                             
	 
		       
			                                                                               
		             

		                    

		                                
		                           
		                              
		                                              

		                             
		 
			                                                                                                                                             
			                                                                                                                                         
			                                      
			                                                                                                                                                                         
			 
				                    
				                        
				     
			 
			                                                           
			 
				     
			 
		 

		                                          
		 
			                                
			                             
				                             
		 

		                           
		 
			                               

			                                          
			                                                
				                     

			                     
		 

		                        
		 
			       
				                                                                  
			             

			                                                                   
			                                        
			                                                                      

			                                                                                                           
		 
		    
		 
			       
				                                                                                    
			             
		 
		       
			                                                                                                                 
		             

		                      
	 
 


                                                                                                                                     
 
	                                         
		                                      

	                                         
	                                                                  
	                                                               

	                                                                   
	                                                                    
	                                                             
	                                                         
	                                                    

	                                 
		           

	                                                      
	 
		                                                                                                            
			      
	 

	                                                  
 


                                                                                
 
	                                         
	                                                                  
	                                                               
	                           

	            
		                         
		 
			                    
				            
		 
	 

	                     

	                                      
		             
 


                                                    
 
	                                                           
 
#endif                     









#if CLIENT
void function InstanceWPTimedEventTracker( entity wp )
{
	if ( !IsValid( wp ) )
		return

	if ( wp.GetWaypointCustomType() != WAYPOINTTYPE_TIMEDEVENTTRACKER )
		return

	int index = wp.GetWaypointInt( INT_EVENTINDEX )
	file.indexToWaypoint[ index ] <- wp

	TimedEventData event = file.indexToTimedEvent[index]
	TimedEventLocalClientData localData
	localData.eventName = event.eventName
	localData.eventDesc = event.eventDesc
	localData.colorOverride = event.colorOverride
	localData.shouldShowPreamble = event.shouldShowPreamble
	localData.shouldHideUntilPrembleDone = event.shouldHideUntilPrembleDone
	localData.shouldHideTimer = event.shouldHideTimer
	localData.eventEndTime = 0

	file.waypointToLocalData[ wp ] <- localData

	if ( event.infoOverrideFunctionThread != null )
	{
		thread event.infoOverrideFunctionThread( wp, localData )
	}
}


void function OnGamestatePlaying_TimedEvents_Client()
{
	thread ManageTimedEventTracker( ClGameState_GetRui(), eGameState.Playing )
}


void function OnGamestateEpilogue_TimedEvents_Client()
{
	thread ManageTimedEventTracker( ClGameState_GetRui(), eGameState.Epilogue )
}


void function ManageTimedEventTracker( var gameStateRui, int gamestate )
{
	#if DEV
		printf( "Timed Events: starting management thread on client for gamestate " + gamestate )
	#endif       

	if ( file.timedEventRui != null )
		return

	int numTrackers = 5                          
	array<var>		trackerRuis
	table<entity, int> assignedWaypoints

	var trackerContainer = RuiCreateNested( gameStateRui, "timedEventTracker", $"ui/timed_event_tracker_container.rpak" )
	file.timedEventRui = trackerContainer

	for( int i = 0; i<numTrackers; i++ )
	{
		var eventRui = RuiCreateNested( trackerContainer, "tracker" + i, $"ui/timed_event_tracker.rpak" )
		trackerRuis.append( eventRui )
	}


	while ( GetGameState() == gamestate )
	{
		array<entity> waypointsAssignedThisFrame

		                         
		table<entity, int> indexTrackerCopy = clone assignedWaypoints
		foreach( wp, index in indexTrackerCopy )
		{

			if ( !IsValid( wp ) && file.waypointToLocalData[ wp ].eventEndTime == 0 )
				file.waypointToLocalData[ wp ].eventEndTime = Time() + 0.5                                       
			else if ( !IsValid( wp ) && Time() > file.waypointToLocalData[ wp ].eventEndTime )
				delete assignedWaypoints[ wp ]
		}

		                                               
		foreach( index, wp in file.indexToWaypoint )
		{
			if ( !( wp in assignedWaypoints ) && IsValid( wp ) )
			{
				assignedWaypoints[ wp ] <- index
				waypointsAssignedThisFrame.append( wp )
			}
		}

		                          
		int i = 0
		foreach( wp, index in assignedWaypoints )
		{
			if ( i >= trackerRuis.len() )
				break

			var rui = trackerRuis[i]
			TimedEventLocalClientData localData = file.waypointToLocalData[ wp ]

			if ( IsValid( wp ) )
			{
				if ( !localData.shouldShowPreamble && Time() < wp.GetWaypointGametime( GAMETIME_START_TIME ) )
					continue
			}

			RuiSetBool( rui, "shouldShow", true )
			RuiSetString( rui, "eventName", localData.eventName )
			RuiSetString( rui, "eventDesc", localData.eventDesc )
			RuiSetBool( rui, "shouldShowPreamble", localData.shouldShowPreamble )
			RuiSetBool( rui, "shouldHideUntilPrembleDone", localData.shouldHideUntilPrembleDone )
			RuiSetBool( rui, "shouldHideTimer", localData.shouldHideTimer )
			RuiSetFloat3( rui, "colorOverride", SrgbToLinear( localData.colorOverride / 255.0 ) )
			RuiSetFloat( rui, "animateOutEndTime", localData.eventEndTime )

			if ( IsValid( wp ) )
			{
				RuiSetString( rui, "award", wp.GetWaypointString( WAYPOINT_EVENT_STRING_AWARD ))
				RuiSetGameTime( rui, "startTime", wp.GetWaypointGametime( GAMETIME_START_TIME ) )
				RuiSetGameTime( rui, "endTime", wp.GetWaypointGametime( GAMETIME_END_TIME ) )
			}

			i++
		}

		for( int j = i; j < trackerRuis.len(); j++ )
		{
			var rui = trackerRuis[j]
			RuiSetBool( rui, "shouldShow", false )
			RuiSetFloat3( rui, "colorOverride", <1,1,1> )
		}


		RuiSetInt( trackerContainer, "numTrackersShown", i )


		WaitFrame()
	}

	                               
	for( int i = 0; i<numTrackers; i++ )
	{
		RuiDestroyNestedIfAlive( trackerContainer, "tracker" + i )
	}
	trackerRuis.clear()

	               
	RuiDestroyNestedIfAlive( gameStateRui, "timedEventTracker" )
	file.timedEventRui = null
}
#endif


#if DEV && SERVER
                                                        

                                      
                           
 
	        
	        
                     
     
                           
	       

	      
 

                                                                                                 
 
	                                                                  
	 
		                                                                                                                                                   
	 

	                                                                                                                      
	                                                  
	 
		                               
		      
	 

	                                          
	 
		                                                                                                                     
		      
	 

	                                                    
	                                                                                                                 
 
#endif                     