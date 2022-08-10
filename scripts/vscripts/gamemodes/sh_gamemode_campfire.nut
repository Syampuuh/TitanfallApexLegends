                         
global function Campfire_Init
global function Campfire_RegisterNetworking
global function Campfire_IsModeActive

#if SERVER
                                  
                                      
                                           
                            
#endif


const asset CAMPFIRE_RADIUS_FX = $"P_campfire_radius"
const asset CAMPFIRE_HOLO_FX = $"P_campfire_holo"
const asset FX_HEAL_HEALED3P = $"P_heal_3p_loop"
global const string CAMPFIRE_TARGET_NAME = "prop_campfire"

const string CAMPFIRE_LOOP_SOUND_1P = "CampFire_AOE_Bubble_1P"
const string CAMPFIRE_LOOP_SOUND_3P = "CampFire_AOE_Bubble_3P"

const string CAMPFIRE_HEAL_START_1P = "CampFire_Healing_Start_1P"
const string CAMPFIRE_HEAL_LOOP_1P = "CampFire_Healing_Loop_1P"
const string CAMPFIRE_HEAL_END_1P = "CampFire_Healing_End_1P"

const string CAMPFIRE_HEAL_START_3P = "CampFire_Healing_Start_3P"
const string CAMPFIRE_HEAL_LOOP_3P = "CampFire_Healing_Loop_3P"
const string CAMPFIRE_HEAL_END_3P = "CampFire_Healing_End_3P"

const asset CAMPFIRE_MODEL = $"mdl/Robots/mobile_hardpoint/mobile_hardpoint_static.rmdl"
const asset CAMPFIRE_ICON = $"rui/hud/gametype_icons/survival/campfire"
const asset CAMPFIRE_ICON_SMALL = $"rui/hud/gametype_icons/survival/crafting_small_alternate"

const float CAMPFIRE_RADIUS = 512.0
const float USE_TIME_INFINITE = -1.0

const string CAMPFIRE_REGEN_SOURCE = "campfire"

struct CampfireData
{
	float radius = CAMPFIRE_RADIUS
}

struct {
	array<entity>					campfireList

	#if SERVER
		                            	              

		                   				                              
		                  				                                 
		                     			               
		                     			                    

		                   				                  
	#endif

	#if CLIENT
		var								localRui
		float							lastDamageTime
		bool							isInCampfire = false
	#endif
} file




                          
void function Campfire_Init()
{
	if ( !GetCurrentPlaylistVarBool( "is_campfire_mode", false ) )
		return

	PrecacheParticleSystem( CAMPFIRE_RADIUS_FX )
	PrecacheParticleSystem( CAMPFIRE_HOLO_FX )
	PrecacheParticleSystem( FX_HEAL_HEALED3P )

	#if SERVER
		                                                                 
		                                                          
		                                                    

		                                                     
		                                              
		                                        

		                                                                           
		                                                       
	#endif

	#if CLIENT
		AddCreateCallback( "prop_script", OnCampfireCreated )
		StatusEffect_RegisterEnabledCallback( eStatusEffect.in_campfire_radius, Campfire_InRadius_Enabled )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.in_campfire_radius, Campfire_InRadius_Disabled )
		AddLocalPlayerTookDamageCallback( OnPlayerDamaged )

		AddCallback_LocalClientPlayerSpawned( Campfire_OnLocalClientPlayerSpawned )
		AddCallback_GameStateEnter( eGameState.Playing, Campfire_OnGameStatePlaying )

		if ( GetCurrentPlaylistVarBool( "campfire_should_display_on_minimap", true ) )
		{
			RegisterMinimapPackages()
			SetMapFeatureItem( 1000, "#CAMPFIRE_NAME", "#CAMPFIRE_DESC", CAMPFIRE_ICON )
		}

		RegisterSignal( "Campfire_InsideRadius" )
		RegisterSignal( "Campfire_OutsideRadius" )
	#endif
}

void function Campfire_RegisterNetworking()
{
	if ( !GetCurrentPlaylistVarBool( "is_campfire_mode", false ) )
		return
}

bool function Campfire_IsModeActive()
{
	return GetCurrentPlaylistVarBool( "is_campfire_mode", false )
}





#if SERVER
                                                  
 
                           
		                            
		 
			                                          
			      
		 
       

	                                                                            
		      

	                       
	 
		                             
			                                     
			          
			                                                    
			        
			                                                   
			          
			                                                     
			                 
			                                                    
			       
			                                                   
			                              
			                                                    
			                      
			                                                     
			                  
			                                                      
			         
			                                                     
			             
			                                                    
			            
			                                                     
			        
			                                                     
			           
			                                                    
			          
			                                                  
			                   
			                                                    
			                   
			                                                    
			           
			                                                   
			              
			                                                    
			                    
			                                                    
			     

		                     
			     
	 

	           
	              
	 
		                                                                          
		              
			     

		                                                        
		                       
			        

		                            
		                            
		                            
		                            


		                                                                  
		                                                  
	 

	                                                     
	                              
	 
		                                                                                         
		                                                                         
	 
 

                          
                                                 
 
	                                      

	                                                            
	                                             
	 
		                                                                  
	 
 
      

                                                                                                                                             
 
	                                                                                             
	                     
	                                               
	                                

                           
		                            
		 
			                                     
			               
		 
       

	                                                                                                 

	                 
	                      
	                                     

	                         
	                                 
 


                                                          
 
	                                        
	 
		                                                                                            
		                                      
	 

	                                                                  
	            
 


                                                             
 
	           
	                                  
	 
		                
		 
			                                   
			                                
		 
	      
	 
		               
		 
			                                                   
			                                                      

			                 
			                                 
				                               

			                                                                                                                                                                                          
			                                                               
			                                     
		 
	 

	                
	                                       
	 
		                                               
		                                       
			                 

		                                       
			                
	 
 


                                                   
 
	                                                                                     
		      

	                                                        
		      

	                               
	                               
	                                

	             

	                                            
	                                                                               
	                     
	                                               
	                                
	                                       

	                 
	                             
	                                     

	                         
	                                 
 


                                             
 
	                                                  
		      

	                                                   
	                                                      

	                 
	                                 
		                               

	                                     
	                                  

	                                        
	                                                   
	                                        
	                                     
	                                     
	                              
	                              
	                                      
	                        

	                                                   
	                                                  
	                                         

	                                                                                                                                                                                          
	                                                               
	                                     

                           
		                             
       
		 
			                                                                                                                                                                                      
		 
	                               

	                                                   
	                                      
	                                             
	                         
	                         

	                   
	                                                                                    
	                                                                        
	                                      
	                           
	                                          
	                                           
	                                                      
	                                                
	                               

	                        
	                                                       
	                                                                   
	                                 
	                                   
	                                               
	                             
	                                             
	                                       
	                           
	                       
	                                     
	                                          
	                                                                               
	                                                
	                                                         
	                                               
	                                                                                    
	                                             
		                                                
	                                                 
	                                 

	                               
 


                                                                   
 
	                            
		      

	                                                    
 

                                                                         
 
	                      
	                                             
	                          
	                            

	                                              
		                 
	   

	                 
	                                                   
	 
		                                                     
			                               
	 

	              
	 
		                         
		                                                                       
		                                                                                                  
		 
			                                    

			                                                                                        
			 
				                   
				                
			 
		 

		                                   
		 
			                                     
			                                   

			                
			 
				                 
				                 
			 
		 

		           
	 

	           
 

                                                                  
 
	                            
		      

	                                          

	                                     
	                                   
	                 
 

                                                                                               
 
	                                             
 

                                        
 
	                                     
	                                                                                     
	                                                         
		                                                                                                                     
 

                                      
 
	                     
	 
		                                     

		                                                    
		 
			                                                                     
			                                                  
		 

		                                               
		                                       
		 
			                                               
		 
	 
 

                                                  
                                                                                                                        
 
	                                           
		      

	                      

	                                 
	                                    
	 
		                   
		                                                                                                                   
		                         
		                                                 
		                                                                       
		                                                                      
		                         
		                                                 
		                                                                         
		                                                                        
		                             

	 

	                               
	                                    
	 
		                        
			      

		                                       

		                      
		                                                   
		 
			                                                                        
			                                                  
		 

		                                   
		                                                   
		                                                   
		                                                                     

		                                      
		                                                   
		                                                   
		                                                                       
	 
 

                                           
 
	                                                
	                                           
	                                          

	                      

	                           
	 
		                                                                                                                                                                           
		                                                                                                 
	 

	            
		                         
		 
			                          
				                      
		 
	 

	             
 

                                                                       
 
	  
 
#endif






#if CLIENT
void function OnCampfireCreated( entity target )
{
	if ( target.GetTargetName() != CAMPFIRE_TARGET_NAME )
		return

	file.campfireList.append( target )
}

void function CreateCampfireWorldIcon( entity campfire )
{
	entity localViewPlayer = GetLocalViewPlayer()
	vector pos             = campfire.GetOrigin() + (campfire.GetUpVector() * 100)
	var rui                = CreateCockpitRui( $"ui/survey_beacon_marker_icon.rpak", RuiCalculateDistanceSortKey( localViewPlayer.EyePosition(), pos ) )
	RuiSetImage( rui, "beaconImage", CAMPFIRE_ICON )
	RuiSetGameTime( rui, "startTime", Time() )
	RuiSetFloat3( rui, "pos", pos )
	RuiSetFloat( rui, "minAlphaDist", 1000 )
	RuiSetFloat( rui, "maxAlphaDist", 3000 )
	RuiKeepSortKeyUpdated( rui, true, "pos" )
}

void function RegisterMinimapPackages()
{
	RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.CAMPFIRE, MINIMAP_OBJECT_RUI, MinimapPackage_Campfire, FULLMAP_OBJECT_RUI, MinimapPackage_Campfire )
}

void function MinimapPackage_Campfire( entity ent, var rui )
{
	RuiSetImage( rui, "defaultIcon", CAMPFIRE_ICON )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
	RuiSetBool( rui, "useTeamColor", false )
}

void function Campfire_InRadius_Enabled( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( ent != GetLocalViewPlayer() )
		return

	entity cockpit = GetLocalViewPlayer().GetCockpit()
	if ( !IsValid( cockpit ) )
		return

	if ( !actuallyChanged )
		return

	ent.Signal( "Campfire_InsideRadius" )

	Campfire_HintEnabled()
	thread Campfire_1PSoundThread()
	file.isInCampfire = true
}

void function Campfire_InRadius_Disabled( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( ent != GetLocalViewPlayer() )
		return

	if ( !actuallyChanged )
		return

	ent.Signal( "Campfire_OutsideRadius" )

	Campfire_HintDisabled()
	file.isInCampfire = false
}

void function Campfire_OnLocalClientPlayerSpawned( entity player )
{
	thread Campfire_3PSoundThread()
}

void function Campfire_OnGameStatePlaying()
{
	if ( GetCurrentPlaylistName().find( "dev" ) != -1 )
	{
		Campfire_OnLocalClientPlayerSpawned( null )
	}
}

void function Campfire_HintEnabled()
{
	file.localRui = CreateCockpitPostFXRui( $"ui/campfire_hint.rpak", HUD_Z_BASE )
	RuiSetGameTime( file.localRui, "lastDamageTime", file.lastDamageTime )
	RuiTrackFloat( file.localRui, "bleedoutEndTime", GetLocalViewPlayer(), RUI_TRACK_SCRIPT_NETWORK_VAR, GetNetworkedVariableIndex( "bleedoutEndTime" ) )
}

void function Campfire_HintDisabled()
{
	if ( file.localRui != null )
		RuiDestroyIfAlive( file.localRui )

	file.localRui = null
}

void function OnPlayerDamaged( float damage, vector damageOrigin, int damageType, int damageSourceId, entity attacker )
{
	file.lastDamageTime = Time()

	if ( file.localRui != null )
		RuiSetGameTime( file.localRui, "lastDamageTime", Time() )
}


void function Campfire_1PSoundThread()
{
	entity player = GetLocalViewPlayer()
	player.EndSignal( "Campfire_OutsideRadius" )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )

	EmitSoundOnEntity( player, CAMPFIRE_LOOP_SOUND_1P )

	OnThreadEnd(
		function() : ( player )
		{
			StopSoundOnEntity( player, CAMPFIRE_LOOP_SOUND_1P )
		}
	)

	WaitForever()
}

void function Campfire_3PSoundThread()
{
	entity player = GetLocalViewPlayer()
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )

	entity mover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", player.GetOrigin(), <0, 0, 0> )
	EmitSoundOnEntity( mover, CAMPFIRE_LOOP_SOUND_3P )

	OnThreadEnd(
		function() : ( mover )
		{
			if ( !IsValid( mover ) )
				return

			StopSoundOnEntity( mover, CAMPFIRE_LOOP_SOUND_3P )
			mover.Destroy()
		}
	)

	while ( IsValid( player ) )
	{
		                                                              
		if ( file.isInCampfire )
		{
			mover.SetOrigin( <0,0,-50000> )
			WaitFrame()
			continue
		}

		if ( file.campfireList.len() <= 0 )
		{
			WaitFrame()
			continue
		}

		                                       
		entity closestCampfire = file.campfireList[0]
		if ( !IsValid( closestCampfire ) )
		{
			WaitFrame()
			continue
		}

		foreach( campfire in file.campfireList )
		{
			if ( !IsValid( campfire ) )
			{
				WaitFrame()
				continue
			}

			if ( Distance( player.GetOrigin(), closestCampfire.GetOrigin() ) > Distance( player.GetOrigin(), campfire.GetOrigin() ) )
				closestCampfire = campfire
		}

		if ( !IsValid( closestCampfire ) )
		{
			WaitFrame()
			continue
		}

		int radius = closestCampfire.GetShieldHealth()
		vector fwdToPlayer   = Normalize( player.GetOrigin() - closestCampfire.GetOrigin() )
		vector campfireEdgePos = closestCampfire.GetOrigin() + (fwdToPlayer * radius)

		if ( PositionIsInMapBounds( campfireEdgePos ) )
			mover.SetOrigin( campfireEdgePos )

		WaitFrame()
	}
}
#endif





      