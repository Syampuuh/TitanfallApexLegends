global function ShLootMarvin_Init

#if CLIENT
global function ServerCallback_PromptPingLootMarvin
#endif

#if SERVER
                                                  
                                                   
#endif

#if SERVER && DEV
                                 
                                  
                                       
#endif

global const string STORY_MARVIN_SCRIPTNAME = "story_marvin"
global const string LOOT_MARVIN_SCRIPTNAME = "loot_marvin"
const string ITEM_MARVIN_ARM_REF = "loot_marvin_arm"

const int MAX_NUM_MARVINS = 24
const int MAX_NUM_ARM_MARVINS = 5
const int MARVIN_DIST_BUFFER = 5000
const int MAX_LOOT_ITEMS_FROM_MARVIN = 3
const float DURATION_COOLDOWN = 90.0
const float DURATION_WAIT_FOR_PLAYERS_NEARBY = 30.0

const string WAYPOINTTYPE_COOLDOWN = "waypointType_MarvinCooldown"
const string WAYPOINTTYPE_SCREEN = "waypointType_MarvinScreen"
const string WAYPOINTTYPE_DISPERSE_LOOT_FX = "waypointType_MarvinLootFx"

const float SLOT_MACHINE_CYCLE_LENGTH = 0.3

const asset STORY_MARVIN_CSV_DIALOGUE = $"datatable/dialogue/story_marvin_dialogue.rpak"
const asset VFX_LOT_MARVIN_DISPERSE = $"P_marvin_loot_CP"
const asset VFX_LOT_MARVIN_SPARK_ARM = $"P_sparks_marvin_arm"

#if SERVER
                                          

                                                                    
                                                            
                                                                        
                                                               
                                                                         
                                                                  
                                                                        
                                                                     
                                                                           

                                                             
                                                                   

                                                                        
                                                                         
                                                                             
                                                                               
                                                                                
                                                                 
                                                            
                                                        

                                                                          
                                                             
                                                             

                                                          
                                                        
                                                

                                                        
                                               
#endif          


#if SERVER
                    
 
	    
	        
	        
	           
 
#endif

#if SERVER || CLIENT
global enum eMarvinState
{
	DISABLED,
	READY_FOR_POWERUP,
	POWERING_UP,
	ACTIVE,
	DISPENSING,
	POWERING_DOWN,
	PERMANENTLY_DISABLED,
}
#endif


#if SERVER
                 
 
	                 
	                  
	                               
	                            
	                                        
	                    
	              
	                    
	                                               
	                                    
	                 
 
#endif         


struct
{
	#if SERVER
		                                             
		                                       
	#else          
		var    chestScreenTopo
		var    chestScreenRui
		var    cooldownRui
		entity topPriorityLootMarvin
	#endif          
}file


                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
  
                               
                            
                            
                            
                            
                            
                            
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    


void function ShLootMarvin_Init()
{
	if( !IsSurvivalMode() )
	{
		#if SERVER
			                                                                           
			                                                                                                     
		#endif
		return
	}

	RegisterCSVDialogue( STORY_MARVIN_CSV_DIALOGUE )
	PrecacheParticleSystem( VFX_LOT_MARVIN_DISPERSE )
	PrecacheParticleSystem( VFX_LOT_MARVIN_SPARK_ARM )

	#if SERVER
		                                                      
		                                            
		                                            


		                                                                                                     
		                                                                             
	#endif

	#if CLIENT
		AddCallback_OnPlayerLifeStateChanged( OnPlayerLifeStateChanged )

		Waypoints_RegisterCustomType( WAYPOINTTYPE_COOLDOWN, InstanceMarvinCooldownCreatedWP )
		Waypoints_RegisterCustomType( WAYPOINTTYPE_SCREEN, InstanceMarvinScreenCreatedWP )
		Waypoints_RegisterCustomType( WAYPOINTTYPE_DISPERSE_LOOT_FX, InstanceDisperseLootFxCreatedWP )

		AddCreateCallback( "npc_marvin", ClOnMarvinSpawned )
	#endif
	AddCallback_EntitiesDidLoad( EntitiesDidLoad )
}


void function EntitiesDidLoad()
{
	if( !IsSurvivalMode() )
		return

	int maxNumMarvins      = GetCurrentPlaylistVarInt( "marvins_max_num", MAX_NUM_MARVINS )
	int maxNumArmedMarvins = GetCurrentPlaylistVarInt( "marvins_max_num_armed", MAX_NUM_ARM_MARVINS )

	bool lootMarvinsEnabled    = GetCurrentPlaylistVarBool( "loot_marvins_enabled", true )
	float marvinDistanceBuffer = GetCurrentPlaylistVarFloat( "marvins_distance_buffer", MARVIN_DIST_BUFFER )

	#if SERVER
		                            
		                       

		                         
		 
			                              
			                              

			                                                    
			 
				                                
				                                         
					     

				                                                                        
				                                    

				                                            
				 
					                                                                                     
					 
						                              
						     
					 
				 

				                              
					        

				                   
				                        
				                                                                   

				                                                         

				                   
				                        
			 
		 

		                                           
			              

		                        

		                                                                              
	#endif         
}


#if SERVER
                                                            
 
	                       
	 
		             
		      
	 

	                                                                                      

	                                                                       
	 
		                          
			                                     

		             
	 
	    
	 
		                              
	 
 
#endif          


#if SERVER
                                                                                                        
 
	                                      
	                                      
	                                      

	                                                                             
 
#endif         


                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
  
                              
                              
                              
                              
                              
                              
                                    
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    


#if SERVER && DEV
                                                                
 
	                                   
	                                                            
	                                   
		      

	                                                                             
 
#endif                 


#if SERVER && DEV
                                  
 
	                                   
	                                                            
	                                   
		      

	                                                                                    
 
#endif                 


#if SERVER && DEV
                                       
 
	                              
	                                                                    
	 
		                        
		 
			                            
			 
				                                                                  
			 
			                              
			 
				                                                                   
				                        
			 
			    
			 
				                                                                    
			 
		 
	 

	                                                                                                         

	                                                             
 
#endif                 


#if SERVER
                                                                                     
 
	                              

	                                                                                 

	                                                                                                              
	                        
	                                                                                                                              

	                          
 
#endif

                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
  
                                                                          
                                                                           
                                                                     
                                                                            
                                                                           
                                                                           
                                                                          
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    


#if SERVER
                                                                                                                              
 
	                    
	 
		                                                                               
	 

	                                                                                          
	                                                                                                  
	                                        
	                       

	                                                                                      

	                                             

	  	                                             
	                                  
		                                    

	  	          
	               
	                               
	                               
	                                        

	            
	                                                                   
	                                                                 

	        
	                    
	 
		                         

		                                                 

		                  
		                                                                              
		                                                                                                     
		                                               
		                                                              
	 
	    
	 
		                                                                                                                  

		                       
		 
			                   
			                            
		 

		                  
		                                                                            
		                                                                                                     
		                                               
		                                                                               

		                                                 
		                                                                                     

		                                                             

		                                                                                              
		                                                                                   
		                                                                                   
	 
 
#endif         


#if CLIENT
void function ClOnMarvinSpawned( entity marvin )
{
	if ( marvin.GetScriptName() != LOOT_MARVIN_SCRIPTNAME )
		return

	AddEntityCallback_GetUseEntOverrideText( marvin, LootMarvinHintTextFunc )
}
#endif


#if CLIENT
string function LootMarvinHintTextFunc( entity marvin )
{
	entity player = GetLocalViewPlayer()

	if ( GradeFlagsHas( marvin, eGradeFlags.IS_OPEN ) )
	{
		return "#LOOT_MARVIN_PROMPT_COOLDOWN"
	}
	else if ( GradeFlagsHas( marvin, eGradeFlags.IS_BUSY ) )
	{
		return "#LOOT_MARVIN_PROMPT_BUSY"
	}
	else if ( GradeFlagsHas( marvin, eGradeFlags.IS_LOCKED ) )
	{
		return "#LOOT_MARVIN_PROMPT_DISABLED"
	}
	else if ( DoesPlayerHaveMarvinArmInInventory( player ) )
	{
		return "#LOOT_MARVIN_PROMPT_USE_HAS_ARM"
	}

	return "#LOOT_MARVIN_PROMPT_USE"
}
#endif          


                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
  
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
                                                                                                              
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    


#if SERVER
                                                                                
 
	                                                    
 
#endif         


#if SERVER
                                                                         
 
	                                   
	                                                

	                              

	                    

	                                                 

	                           

	                  

	                                                                
	 
		                                                                         
			      

		                                                                                            

			                                                                                 
	 
 
#endif


#if SERVER || CLIENT
bool function IsPlayerPathfinder( entity player )
{
	ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_Character() )
	string characterRef  = ItemFlavor_GetHumanReadableRef( character ).tolower()

	if ( characterRef != "character_pathfinder" )
		return false

	return true
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


#if CLIENT
void function InstanceMarvinCooldownCreatedWP( entity wp )
{
	entity marvin = wp.GetWaypointEntity( 0 )
	marvin.ai.secondaryWaypoint = wp
}
#endif


#if SERVER
                                                                           
 
	                                                 
	                                                                       
	                                                       
	                                                           

	                                                                                         
	 
		                                               
			                                         
	 
 
#endif         

#if SERVER
                                                                          
 
	                                       
	 
		                                                

		                            
		 
			                                                            
			                                                         
			                                                         
			                                               

			                                 
				                         

			                                              

			                                                                                                                

			                      
			                                        
			                                        
			                                                  
			                                
			                                   
			                                   
			                                   
			                                   

			                                                     
		 

		                              
			                      

		                                    
			                            
		
		                                                                                                                                              

		                                     
	 
 
#endif         

#if SERVER
                                                                                                                                                         
 
	                                                                                              

	             
		                                                                                            

	             
 
#endif         


#if CLIENT
void function ServerCallback_PromptPingLootMarvin ( entity player )
{
	AddOnscreenPromptFunction( "quickchat", void function( entity player ) {
		Remote_ServerCallFunction("ClientCallback_PromptPingLootMarvin")
	}, 6.0, "#PING_LOOT_MARVIN")
}
#endif

#if SERVER
                                                                   
 
		                                              
 
#endif

#if SERVER
                                                                     
 

	                                                                  
	                          
	                                                                    
	 
		                                                                                 
			        

		                             
	 

	                              
		      

	                                                                                               
	                                         

	                                                      
	                    
	                                            
	 
		                                 

		                                                                       
		 
			                      
			     
		 

		                                                                                      
		 
			                      
			     
		 
	 

	                                
		      

	                                                                                  
	                                                                                                                                    
	                    
		                                                          
 
#endif

                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
  
                                                                                                            
                                                                                                      
                                                                                                      
                                                                                                          
                                                                                                      
                                                                                                      
                                                                                                            
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    

const int WAYPOINT_IDX_STARTTIME = 0
const int WAYPOINT_IDX_EMOTICON = 0
const int WAYPOINT_IDX_HAS_SETTLED = 1


#if SERVER || CLIENT
bool function DoesPlayerHaveMarvinArmInInventory( entity player )
{
	array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )
	foreach ( invItem in playerInventory )
	{
		LootData lootData = SURVIVAL_Loot_GetLootDataByIndex( invItem.type )

		if ( lootData.ref == ITEM_MARVIN_ARM_REF )
			return true
	}

	return false
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


#if CLIENT
void function InstanceDisperseLootFxCreatedWP( entity wp )
{
	entity marvin  = wp.GetWaypointEntity( 0 )
	int lootRarity = wp.GetWaypointInt( 0 ) + 1

	int particleIdx    = GetParticleSystemIndex( VFX_LOT_MARVIN_DISPERSE )
	int vfxAttachIdx   = marvin.LookupAttachment( "SCREEN_CENTER" )
	int fxHandle       = StartParticleEffectOnEntity( marvin, particleIdx, FX_PATTACH_POINT_FOLLOW, vfxAttachIdx )
	vector rarityColor = GetFXRarityColorForTier( lootRarity )
	EffectSetControlPointVector( fxHandle, 1, rarityColor )
}
#endif


#if SERVER
                                                                     
 
	                              
	                                               

	                                                      

	            
		                             
		 
			                                    
				                            

			                                                      
		 
	 

	                                                                                                                                     

	                                                                                    
	                                                                                                                 
	                                                                                                                                                        

	                                             
	                                                                      
	                                                  
	                                                 

	                                                                                   
	                                                                

	             
	 
		                                                                        

		                          

		                                                        

		                                                                              
		                                            

		                                                  
			     
	 

	                                                                
	                                 
	                                                      

	             
 
#endif          


#if CLIENT
void function InstanceMarvinScreenCreatedWP( entity wp )
{
	entity marvin = wp.GetWaypointEntity( 0 )

	                          
	 
		                                        
		      
	   

	marvin.ai.primaryWaypoint = wp
}

                                                       
 
	                                         
	                           
	 
		       
			                                              
		      
		                                  
		           
	 
	                              
   

#endif


#if SERVER
                                                       
 
	                          

	                                     
		                                 

	                                  
	 
		                         
			                                            
			     

		                             
			                                            
			     

		                             
			                                        
			     
	 

	                         
 
#endif         

                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
  
                            
                           
                           
                           
                           
                           
                            
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    


#if CLIENT
void function OnPlayerLifeStateChanged( entity player, int oldState, int newState )
{
	if ( player == GetLocalViewPlayer() )
	{
		if ( newState != LIFE_ALIVE )
		{

		}
		else if ( IsValid( player ) )
		{
			thread SetTopPriorityLootMarvin( player )
			thread TrackNearestChestScreen( player )
			thread TrackNearestCooldownIndicator( player )
		}
	}
}
#endif


#if CLIENT
void function TrackNearestChestScreen( entity player )
{
	const float MAYA_SCREEN_WIDTH = 5.686
	const float MAYA_SCREEN_HEIGHT = 4.512
	const asset SCREEN_RUI_ASSET = $"ui/marvin_chest_slot_machine.rpak"

	EndSignal( player, "OnDeath" )

	if ( file.chestScreenTopo == null )
		file.chestScreenTopo = CreateRUITopology_Worldspace( <0, 0, 0>, <0, 0, 0>, MAYA_SCREEN_WIDTH, MAYA_SCREEN_HEIGHT )

	if ( file.chestScreenRui == null )
		file.chestScreenRui = RuiCreate( SCREEN_RUI_ASSET, file.chestScreenTopo, RUI_DRAW_WORLD, 0 )

	float cycleLength = GetCurrentPlaylistVarFloat( "marvin_slot_cycle_length", SLOT_MACHINE_CYCLE_LENGTH )
	RuiSetFloat( file.chestScreenRui, "cycleLength", cycleLength )
	RuiSetBool( file.chestScreenRui, "isVisible", false )

	OnThreadEnd(
		function () : ()
		{
			RuiSetBool( file.chestScreenRui, "isVisible", false )
		}
	)

	while( true )
	{
		if ( IsValid( file.topPriorityLootMarvin ) && IsValid( file.topPriorityLootMarvin.ai.primaryWaypoint ) )
		{
			entity wp = file.topPriorityLootMarvin.ai.primaryWaypoint
			RuiTopology_SetParent( file.chestScreenTopo, file.topPriorityLootMarvin, "SCREEN_CENTER" )

			RuiSetGameTime( file.chestScreenRui, "startCycleTime", wp.GetWaypointGametime( WAYPOINT_IDX_STARTTIME ) )
			RuiSetBool( file.chestScreenRui, "isVisible", true )
			RuiSetInt( file.chestScreenRui, "emotionIdx", wp.GetWaypointInt( WAYPOINT_IDX_EMOTICON ) )

			if ( wp.GetWaypointInt( WAYPOINT_IDX_HAS_SETTLED ) > 0 )
			{
				RuiSetBool( file.chestScreenRui, "shouldStop", true )
			}
			else
			{
				RuiSetBool( file.chestScreenRui, "shouldStop", false )
			}

			RuiSetGameTime( file.chestScreenRui, "startCycleTime", wp.GetWaypointGametime( WAYPOINT_IDX_STARTTIME ) )
		}
		else
		{
			RuiSetBool( file.chestScreenRui, "isVisible", false )
		}

		WaitFrame()
	}
}
#endif


#if CLIENT
void function TrackNearestCooldownIndicator( entity player )
{
	EndSignal( player, "OnDeath" )

	if ( file.cooldownRui == null )
	{
		file.cooldownRui = CreateCockpitRui( $"ui/wattson_ult_cooldown_timer_world.rpak", 1 )
		RuiSetFloat3( file.cooldownRui, "worldPosOffset", <0, 0, 0> )
		RuiSetBool( file.cooldownRui, "shouldDesaturate", true )
	}

	OnThreadEnd(
		function () : ()
		{
			RuiSetBool( file.cooldownRui, "isVisible", false )
		}
	)

	while( true )
	{
		if ( IsValid( file.topPriorityLootMarvin ) && IsValid( file.topPriorityLootMarvin.ai.secondaryWaypoint ) )
		{
			entity wp = file.topPriorityLootMarvin.ai.secondaryWaypoint
			RuiTrackFloat3( file.cooldownRui, "worldPos", wp, RUI_TRACK_ABSORIGIN_FOLLOW )
			RuiSetGameTime( file.cooldownRui, "startTime", wp.GetWaypointGametime( 0 ) )
			RuiSetGameTime( file.cooldownRui, "endTime", wp.GetWaypointGametime( 1 ) )

			bool canTrace = false
			bool isFar    = Distance( player.EyePosition(), wp.GetOrigin() ) > 700.0
			if ( !isFar )
			{
				TraceResults results = TraceLine( player.EyePosition(), wp.GetOrigin(), [player], TRACE_MASK_VISIBLE, TRACE_COLLISION_GROUP_NONE )
				canTrace = results.fraction > 0.95
			}

			if ( isFar || !canTrace )
			{
				RuiSetBool( file.cooldownRui, "isVisible", false )
			}
			else
			{
				RuiSetBool( file.cooldownRui, "isVisible", true )
			}
		}
		else
		{
			RuiSetBool( file.cooldownRui, "isVisible", false )
		}

		WaitFrame()
	}
}
#endif


#if CLIENT
void function SetTopPriorityLootMarvin( entity player )
{
	EndSignal( player, "OnDeath" )
	EndSignal( player, "OnDestroy" )

	while( true )
	{
		array<entity> allMarvins = GetEntArrayByScriptName( LOOT_MARVIN_SCRIPTNAME )
		array<entity> validMarvins

		foreach ( entity marvin in allMarvins )
		{
			if ( !IsAlive( marvin ) )
				continue

			                                                  
			float dot    = DotProduct( AnglesToForward( player.CameraAngles() ), Normalize( marvin.GetOrigin() - player.CameraPosition() ) )
			float scalar = GetFovScalar( player )

			float minDot  = cos( DEG_TO_RAD * DEFAULT_FOV * 1.3 * scalar )
			bool isInView = dot > minDot

			if ( isInView )
				validMarvins.append( marvin )
		}

		array<ArrayDistanceEntry> allResults = ArrayDistanceResults( validMarvins, player.GetOrigin() )
		allResults.sort( DistanceCompareClosest )

		if ( allResults.len() > 0 )
			file.topPriorityLootMarvin = allResults[ 0 ].ent

		wait 0.2
	}
}
#endif