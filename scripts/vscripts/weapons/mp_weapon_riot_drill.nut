global function MpWeaponRiotDrill_Init

global function OnWeaponActivate_riot_drill
global function OnWeaponDeactivate_riot_drill
                                                      
global function OnWeaponTossCancel_weapon_riot_drill
global function OnWeaponTossReleaseAnimEvent_weapon_riot_drill
global function OnProjectileCollision_weapon_riot_drill

global function CodeCallback_BreachTraceEarlyExitOnEnt
global function CodeCallback_BreachTraceIsValidPos

#if SERVER
                                            
                                             
#endif

#if CLIENT
global function ServerCallback_CancelPlacement
global function OnClientAnimEvent_weapon_riot_drill
#endif

global const string RIOT_DRILL_SCRIPT_NAME = "riot_drill_spike"
global const string RIOT_DRILL_DANGERZONE_TARGETNAME = "riot_drill_dangerzone_threat"
const string RIOT_DRILL_MOVER_SCRIPTNAME = "riot_drill_mover"

                         
const float WALL_THICKNESS_MAX 			= 512.0			                        
const float WALL_THICKNESS_MIN 			= 0.18
const float MAX_RANGE 					= 1750.0		                                                                                                                                                              

                      
const float RIOT_DRILL_FIRE_DELAY 	= 1.0			                                                                              
const float RIOT_DRILL_DURATION 	= 8.0			                              
const float RIOT_DRILL_BLAST_LENGTH = 224.0			                            
const float RIOT_DRILL_BLAST_RADIUS = 130.0			                            
const int	RIOT_DRILL_DAMAGE 		= 4				                  
const int 	RIOT_DRILL_IMPACT_DAMAGE = 5			                                                        
const int	RIOT_DRILL_STUCK_DAMAGE = 1				                                  
const float RIOT_DRILL_DAMAGE_TICK 	= 0.2			                      

         
const asset RIOT_DRILL_SPIKE 					= $"mdl/props/madmaggie_tactical_drill_bit/madmaggie_tactical_drill_bit.rmdl"
const asset RIOT_DRILL_DRILL		 			= $"mdl/props/madmaggie_tactical_drill_bit/madmaggie_tactical_drill_bit.rmdl"
const asset RIOT_DRILL_DRILL_FIZZLE		 		= $"mdl/robots/drone_frag/drone_frag.rmdl"

                
const asset RIOT_DRILL_EMPTY_MODEL				= $"mdl/dev/empty_model.rmdl"
const asset RIOT_DRILL_PLACEMENT_ENTER 			= $"_none_FX_test"
const asset RIOT_DRILL_PLACEMENT_EXIT 			= $"_none_FX_test"
const asset RIOT_DRILL_BLAST_BEAM_FX 			= $"P_mm_breach_beam"
const asset RIOT_DRILL_BLAST_BEAM_WARN_FX 		= $"P_mm_breach_beam_warn"
const asset RIOT_DRILL_AOE_WARNING_01_FX 		= $"P_mm_breach_exit"
const asset RIOT_DRILL_FRONT_FX 				= $"P_mm_breach_enter"
const asset RIOT_DRILL_SPRAY_TEST_CONE	 		= $"_none_FX_test"
const asset RIOT_DRILL_SPRAY_TEST_COLUMN 		= $"_none_FX_test"
const asset RIOT_DRILL_DECAL					= $"P_mm_breach_decal"
const asset RIOT_DRILL_DAMAGE_FX_1P				= $"fissure_breach_CH_hex_flash"
const asset RIOT_DRILL_FIZZLE_EXPLODE_FX		= $"fissure_breach_fizzle_explosion"
const asset RIOT_DRILL_FIZZLE_SPARKS_FX			= $"fissure_breach_fizzle_spray"
const asset RIOT_DRILL_ENTER_FX_DEFAULT			= $"P_mm_breach_imp_enter_default"
const vector RIOT_DRILL_PLACEMENT_VALID_COLOR 	= <128, 188, 255>
const vector RIOT_DRILL_PLACEMENT_CAUTION_COLOR = <255, 200, 40>
const vector RIOT_DRILL_PLACEMENT_ERROR_COLOR 	= <255, 40, 40>

             
const string RIOT_DRILL_DAMAGE_SOUND_1P 		= "flesh_thermiteburn_3p_vs_1p"					                  
const string RIOT_DRILL_DAMAGE_SOUND_3P 		= "flesh_thermiteburn_3p_vs_3p"				                               
const string RIOT_DRILL_EXIT_DRILLING 			= "Maggie_Tac_Drill_Exit_Drilling"
const string RIOT_DRILL_ENTRANCE_DRILLING 		= "Maggie_Tac_Drill_Entrance_Drilling"                             

enum eBreachPlacementResult
{
	SUCCESS = BREACH_TRACE_RESULT_SUCCESS,
	FAILED_WALL_TOO_THIN = BREACH_TRACE_RESULT_WALL_TOO_THIN,
	FAILED_WALL_TOO_THICK = BREACH_TRACE_RESULT_WALL_TOO_THICK,
	FAILED_OUT_OF_RANGE = BREACH_TRACE_RESULT_COUNT + 1,
	FAILED_SAFETY_CATCH = BREACH_TRACE_RESULT_INVALID_END_POINT,
	FAILED_GENERIC = BREACH_TRACE_RESULT_FAILURE,
}

global struct RiotDrillPlacementInfo
{
	vector startOrigin
	vector startAngles
	vector startSurfaceNormal
	vector endSurfaceNormal
	int    placementResult
	bool   hide
	entity hitEnt

	vector endOrigin
	vector endAngles
}

struct RiotDrillSystem
{
	entity riotDrillStart
	entity riotDrillEnd
	entity riotDrillDrillMover
	entity riotDrillDrillModel
	entity riotDrillStuckEntity
	entity damageTrigger
	entity riotDrillSoundDummy

	vector dangerZoneOrigin
	vector dangerZoneAngle
	vector breachAngle

	RiotDrillPlacementInfo& placementInfo
}

struct
{
	bool balance_riotDrillAllowThick
	bool balance_riotDrillAllowOutRange
	bool balance_riotDrillProjCollision
	float balance_riotDrillDelay
	float balance_riotDrillDuration
	int balance_riotDrillDamage
	int balance_riotDrillImpactDamage
	int balance_riotDrillStuckDamage
	float balance_riotDrillMaxThickness
	float balance_riotDrillRadius
	float balance_riotDrillLength
	float balance_riotDrillRange
	bool balance_riotDrillAfterDeath
	bool balance_riotDrillPlayerCollide

	array<string> shieldScriptNames
	array<string> bounceOffSpecialCaseNames

	#if CLIENT
		bool breachChargeDeployed = false
		var depthRui
	#endif

	table riotDrillDamageParams 		= { damageSourceId = eDamageSourceId.mp_weapon_concussive_breach, damageType = DMG_BURN, scriptType = DF_BULLET }             
	table riotDrillImpactDamageParams 	= { damageSourceId = eDamageSourceId.mp_weapon_concussive_breach, scriptType = DF_BULLET }             

	                    
	bool fxOption_hideModels
	float fxOption_impactTableFXEnterRefire
	float fxOption_impactTableFXExitRefire
}
file

void function MpWeaponRiotDrill_Init()
{
	PrecacheParticleSystem( RIOT_DRILL_FRONT_FX )
	PrecacheParticleSystem( RIOT_DRILL_AOE_WARNING_01_FX )
	PrecacheParticleSystem( RIOT_DRILL_SPRAY_TEST_CONE )
	PrecacheParticleSystem( RIOT_DRILL_SPRAY_TEST_COLUMN )
	PrecacheParticleSystem( RIOT_DRILL_BLAST_BEAM_FX )
	PrecacheParticleSystem( RIOT_DRILL_BLAST_BEAM_WARN_FX )
	PrecacheParticleSystem( RIOT_DRILL_PLACEMENT_ENTER )
	PrecacheParticleSystem( RIOT_DRILL_PLACEMENT_EXIT )
	PrecacheParticleSystem( RIOT_DRILL_DAMAGE_FX_1P )
	PrecacheParticleSystem( RIOT_DRILL_DECAL )
	PrecacheParticleSystem( RIOT_DRILL_FIZZLE_EXPLODE_FX )
	PrecacheParticleSystem( RIOT_DRILL_FIZZLE_SPARKS_FX )
	PrecacheParticleSystem( RIOT_DRILL_ENTER_FX_DEFAULT )

	PrecacheModel( RIOT_DRILL_SPIKE )
	PrecacheModel( RIOT_DRILL_DRILL )
	PrecacheModel( RIOT_DRILL_DRILL_FIZZLE )
	PrecacheModel( RIOT_DRILL_EMPTY_MODEL )

	RegisterSignal( "DeployableBreachChargePlacement_End" )
	RegisterSignal( "RiotDrill_TempAnimWindDown" )
	RegisterSignal( "RiotDrill_StuckEntDissolving" )

	file.balance_riotDrillAfterDeath	= GetCurrentPlaylistVarBool( "breaching_spike_after_death_override", true )										                                                                  
	file.balance_riotDrillAllowThick 	= GetCurrentPlaylistVarBool( "breaching_spike_allow_thick_override", true )										                                                                                    
	file.balance_riotDrillAllowOutRange = GetCurrentPlaylistVarBool( "breaching_spike_allow_out_range_override", true )									                                                                                    
	file.balance_riotDrillProjCollision = GetCurrentPlaylistVarBool( "breaching_spike_allow_projectile_collision_override", true )						                                                                                                       
	file.balance_riotDrillDelay 		= max( GetCurrentPlaylistVarFloat( "breaching_spike_delay_override", RIOT_DRILL_FIRE_DELAY ), 0.25 )		                                          
	file.balance_riotDrillDuration 		= max( GetCurrentPlaylistVarFloat( "riot_drill_duration_override", RIOT_DRILL_DURATION ), 0.0 )			                              
	file.balance_riotDrillDamage 		= maxint( GetCurrentPlaylistVarInt( "breaching_spike_damage_override", RIOT_DRILL_DAMAGE ), 0 )				                                     
	file.balance_riotDrillImpactDamage	= maxint( GetCurrentPlaylistVarInt( "breaching_spike_impact_damage_override", RIOT_DRILL_IMPACT_DAMAGE ), 0 )		                                                 
	file.balance_riotDrillStuckDamage 	= maxint( GetCurrentPlaylistVarInt( "breaching_spike_stuck_damage_override", RIOT_DRILL_STUCK_DAMAGE ), 0 )		                                   
	file.balance_riotDrillMaxThickness 	= max( GetCurrentPlaylistVarFloat( "breaching_spike_max_thickness_override", WALL_THICKNESS_MAX ), 400.0 )		                                                                                   
	file.balance_riotDrillRadius 		= max( GetCurrentPlaylistVarFloat( "breaching_spike_radius_override", RIOT_DRILL_BLAST_RADIUS ), 64.0 )		                            
	file.balance_riotDrillLength 		= max( GetCurrentPlaylistVarFloat( "breaching_spike_length_override", RIOT_DRILL_BLAST_LENGTH ), 64.0 )		                            
	file.balance_riotDrillRange 		= GetCurrentPlaylistVarFloat( "breaching_spike_range_override", MAX_RANGE )										                                                           
	file.balance_riotDrillPlayerCollide = GetCurrentPlaylistVarBool( "breaching_spike_allow_player_collision_override", true )							                                                                 

	                                   
	file.fxOption_hideModels				= GetCurrentPlaylistVarBool( "breaching_spike_hide_models", true )
	file.fxOption_impactTableFXEnterRefire	= GetCurrentPlaylistVarFloat( "breaching_spike_impact_fx_enter_refire", 0.2 )
	file.fxOption_impactTableFXExitRefire	= GetCurrentPlaylistVarFloat( "breaching_spike_impact_fx_exit_refire", 0.2 )

                  
	file.shieldScriptNames.append( MOBILE_SHIELD_SCRIPTNAME )
       
	file.shieldScriptNames.append( BUBBLE_SHIELD_SCRIPTNAME )
	file.shieldScriptNames.append( AMPED_WALL_SCRIPT_NAME )
	file.shieldScriptNames.append( ECHO_LOCATOR_SCRIPT_NAME )

	file.bounceOffSpecialCaseNames.append( "pathfinder_tt_ring_shield" )
	file.bounceOffSpecialCaseNames.append( DEATHBOX_FLYER_SCRIPT_NAME )

	#if SERVER
		                                              
		                                              
		                                             

		  
		                                                                       
		                                                                                              
	#endif

	#if CLIENT
		AddTargetNameCreateCallback( RIOT_DRILL_DANGERZONE_TARGETNAME, RiotDrill_AddThreatIndicator )
	#endif         

	Remote_RegisterServerFunction( "ClientCallback_DrillError_On" )
	Remote_RegisterServerFunction( "ClientCallback_DrillError_Off" )

	Remote_RegisterClientFunction( "ServerCallback_CancelPlacement", "entity" )
}

void function RestoreRiotDrillAmmo( entity owner )
{
	if ( IsAlive( owner ) )
	{
		entity weapon = owner.GetOffhandWeapon( OFFHAND_SPECIAL )
		if ( IsValid( weapon ) && weapon.GetWeaponClassName() == "mp_weapon_riot_drill" )
			Weapon_AddSingleCharge( weapon )
	}
}

#if SERVER

                                     
                                     
                                     

                                                                                                                         
 
	                                                                                           
	 
		                             
		      
	 

	                                             
	                                            
	                   
	                                
	                                                                              
	                                                                             

	                                      
	                                 
	                                           

	              
	                                                                                                                                                                                   
	                                                          
	                                       
	                                              

	                                                                            
	                                                                                                                                   
	                                                                                                                     
	                                                                                                 
	 
		                                                                                                                                                    
		                                                       
	 
	    
	 
		                                                                                                         
	 
	                                                            
	                              
	                                                                          
	                                                                             
	                                                   

	            
	                                                                                                                  
	                                                
	                       
	                                            
	                                                                   

	                               
	                                                                                                                                                               
	                                                       
	                                            

	                                   
		                                                            

	                                             
	 
		                                                      
		 
			                                      
		 
		    
		 
			                                                                            
			                             
			                            
			                                 
			      
		 
		                                

		                          
			                              

		                                 
	 

	                                                          

	                                                                                                        

	                                                                     
	                                                                      

	                 
	                                                

	                                        
		                                          

	            
		                                      
		 

			                       
			 
				                                                          
				                                                                             
					                                                    
			 

			                                 
				                          

			                                   
			 
				                                                          
				                                                              
			 
			                                        
				                                 

			                                     
			 
				                       
					               
			 
		 
	 

	                                

	                                         

	                                            
 

                                                                                                 
 
	                                      
	                                                                          

	                         

	                                     
	 
		                                                                                                                                                      
			                                                                    
	 

	                                                         

	                                     
	 
		                                                                                                                                                                       
			                                                                    
	 
 

                                                                       
 
	                                                                                       
	                                                   

	                             
		                                     

	            
		                                 
		 
			                                   
				                                                   
		 
	 

	                                               
	                                          

	                                                                     
	                                      

	                                                                           
	                                      

	                                                                   

	                                                              

	                                                                       
	                                      
 

                                                                                                         
 
	                                      

	                                 
	                                 
	                              
	                                            
	                                           
	                                             
	                                           
	                                   
	                              
	                                          
	                                  
	                                             
	                                        
	                                           
	                       

	                                                   
 

                                                                        
 
	                                           
		      

	                                                              
		      

	                                            
	 
		                                              
		 
			                                                            
			     
		 

		        
	 
 

                                                               
 
	                                                     
	                                                               

	                                          
	 
		                                                             
		                                                 
	 

	                                               
	                                               
	                                                       

	                              
		      

	                                           
	                                                   
	                               
	                                                         
	                                                               
	                           
	                              
	                              
	                             
	                                              
	                                   
	                                      
	                                        
	                                     

	                                     

	                        
	                           
	                                    

	                                                          

	                                                                                                                                                    

	                                                                                                                                                                                           
	                                                                                                                                                                                   

	                                                              
	                                                                                         
	                                                                                                                                                                            

	            
		                                      
		 
			                                    
				                                                                     

			                                  
				                                                               

			                         
				                 

			                         
			 
				                     
					             
			 
		 
	 

	                                                      
	                                                                    
	 
		                                                               
		                                                                                           
			                                          

		                                 
		 
			                                   
			                                                                                 
			 
				                                                                                                         
			 
			    
			 
				                                     
				                                                          

				                                                                                                                    
				                                                                                                                                                  
				                                                                                                                                                               
				                                                                                                     

				                                                               
					        

				                                                                                                    
			 
			                     
			 
				                                                                     
				                                                                       
			 
			    
			 
				                                                    
			 
		 
		                           
	 
 

                                                                                
 
	                                                                                            

	                                                          
	                                     

	                                
		                     
		                                                          
		                                                                                            
		                                                                                             
		                             
	 

	                                        
	 
		                               
		                              

		                                                                                                                                                               

		                                    
			           
	 

	            
 

                          
                          
                          

                                                                       
 
	                                              
	                                                   

	           
	                                                                                                         
		                                                                                      
	                                        

	                  
	                                                   
	                                                 

	                                                                     
	                                                                             
	                                             
	                                          
		                                                          
	                                     

	                                                              
	                                    
	                                                                 
	                                                              
	                                                                   
	                                                                
	                                  
	                                       
	                                          
		                                                    
	                               
	                                            
	                                                                               

	            
	                                                                           
	                                                                                                                                                         

	                                                                 
	                                                                         
	                                                
	                                          
		                                                      
	                                 

	                                                          
	                                
	                                                             
	                                                          
	                                                                    
	                                                        
	                              
	                                   
	                                                 
	                                          
		                                                
	                           
	                                            
	                                                                        

	                                                           
 

                                                                          
 
	                                                                                                           
	                    

	                                            
	                                            

	                                                                      
	             	                                                                                                                   
	                                   
	                                                              
	                      

	                                                                                        
	 
		                                                                                                          
			                                                                 
		                                  
		                                                               
		                             
	 

	             
 

                                                                
 
	                               

	                                              
	                                                   

	                                                                                                                    
	                                                  
	                           
	                                      

	            
		                       
		 
			                        
				                
		 
	 

	                                   
 

                                                                                     
 
	                                                    
	                              
	                                                
	                             
	                                 
	                                  
	                           
	                                      
	                                  
	                                             
	                             

	                                                   

	                                                     
	        

	                                                                                                  
	                              
		                                                                                                                                                     

	        

	                              
		                      
 

                                                           
 
	                         
		      

	                                                           
	                                                           
		                              
 

                                                            
 
	                         
		      

	                                                           
	                                                          
		                                 
 

                                                                       
                                                                 
 
	                                                                                  
	  	                                  
	  		      
 
#endif         

#if CLIENT

                              
                              
                              

void function OnClientAnimEvent_weapon_riot_drill( entity weapon, string name )
{
	if ( !IsValid( weapon ) )
		return

	const float SHAKE_AMPLITUDE = 3.0
	const float SHAKE_FREQUENCY = 50.0
	const float SHAKE_DURATION = 0.35
	const vector SHAKE_DIRECTION = < 0.0, 0.0, 0.0 >

	if ( name == "riot_drill_screen_shake" )
		ClientScreenShake( SHAKE_AMPLITUDE, SHAKE_FREQUENCY, SHAKE_DURATION, SHAKE_DIRECTION )
}

void function ServerCallback_CancelPlacement( entity player )
{
	player.Signal( "DeployableBreachChargePlacement_End" )
}

void function SetBreachChargeDeployed( bool state )
{
	file.breachChargeDeployed = state
}

void function DestroyBreachChargeProxy( entity ent )
{
	Assert( IsNewThread(), "Must be threaded off" )
	EndSignal( ent, "OnDestroy" )

	if ( file.breachChargeDeployed )
		wait 0.225

	ent.Destroy()
}

void function RiotDrill_OnPropScriptCreated( entity ent )
{
	switch ( ent.GetScriptName() )
	{
		case "concussive_breach_marker":
			thread RiotDrill_CreateHUDMarker( ent )
			break
	}
}

void function RiotDrill_CreateHUDMarker( entity marker )
{
	entity localClientPlayer = GetLocalClientPlayer()

	EndSignal( marker, "OnDestroy" )

	if ( !GamePlayingOrSuddenDeath() )
		return

	var topology = CreateRUITopology_Worldspace( <0,0,0>, <0,0,0>, 32, 32 )
	var ruiPlane = RuiCreate( $"ui/concussive_breach_timer.rpak", topology, RUI_DRAW_WORLD, 0 )
	RuiTopology_SetParent( topology, marker )

	RuiSetGameTime( ruiPlane, "startTime", Time() )
	RuiSetFloat( ruiPlane, "lifeTime", file.balance_riotDrillDuration )

	OnThreadEnd(
		function() : ( ruiPlane, topology )
		{
			RuiDestroy( ruiPlane )
			RuiTopology_Destroy( topology )
		}
	)

	WaitForever()
}

void function DeployableBreachChargePlacementThink( entity player )
{
	EndSignal( player, "DeployableBreachChargePlacement_End", "OnDeath", "OnDestroy", SIGNAL_BLEEDOUT_STATE_CHANGED )

	const vector COLOR_DEPTH_UNKNOWN	= <255, 122, 0>
	const vector COLOR_DEPTH_START 		= <255, 122, 0>
	const vector COLOR_DEPTH_MID 		= <255, 210, 73>
	const vector COLOR_DEPTH_END 		= <255, 255, 255>

	asset breachStartModel				= RIOT_DRILL_SPIKE
	asset breachDrillModel				= RIOT_DRILL_DRILL
	string breachStartModelAttachment	= "muzzle_flash"
	string breachDrillModelAttachment	= "ORIGIN"

	if ( file.fxOption_hideModels )
	{
		breachStartModel = RIOT_DRILL_EMPTY_MODEL
		breachDrillModel = RIOT_DRILL_EMPTY_MODEL
		breachStartModelAttachment = "ORIGIN"
		breachDrillModelAttachment = "ORIGIN"
	}

	entity breachCharge_startProxy = CreateBreachChargeProxy( breachStartModel )
	breachCharge_startProxy.EnableRenderAlways()
	breachCharge_startProxy.Show()

	int placementFXhandle_Enter = StartParticleEffectOnEntity( breachCharge_startProxy, GetParticleSystemIndex( RIOT_DRILL_PLACEMENT_ENTER ),
		FX_PATTACH_POINT_FOLLOW, breachCharge_startProxy.LookupAttachment( breachStartModelAttachment ) )

	entity breachCharge_endProxy = CreateBreachChargeProxy( breachDrillModel )
	breachCharge_endProxy.EnableRenderAlways()
	breachCharge_endProxy.Show()

	int placementFXhandle_Exit = StartParticleEffectOnEntity( breachCharge_endProxy, GetParticleSystemIndex( RIOT_DRILL_PLACEMENT_EXIT ),
		FX_PATTACH_POINT_FOLLOW, breachCharge_endProxy.LookupAttachment( breachDrillModelAttachment ) )
	EffectSetControlPointVector( placementFXhandle_Exit, 1, ( RIOT_DRILL_PLACEMENT_VALID_COLOR / 255.0 ) )

	EffectAddTrackingForControlPoint( placementFXhandle_Enter, 1, breachCharge_endProxy, FX_PATTACH_POINT_FOLLOW, breachCharge_endProxy.LookupAttachment( breachDrillModelAttachment ), <0,0,0> )

	file.depthRui = CreateFullscreenRui( $"ui/mm_riot_drill.rpak" )

	OnThreadEnd(
		function() : ( breachCharge_startProxy, breachCharge_endProxy, placementFXhandle_Enter, placementFXhandle_Exit )
		{
			CleanupFXHandle( placementFXhandle_Enter, true, false )
			CleanupFXHandle( placementFXhandle_Exit, true, false )

			if ( IsValid( breachCharge_startProxy ) )
				thread DestroyBreachChargeProxy( breachCharge_startProxy )

			if ( IsValid( breachCharge_endProxy ) )
				thread DestroyBreachChargeProxy( breachCharge_endProxy )

			Remote_ServerCallFunction( "ClientCallback_DrillError_Off" )

			if ( file.depthRui != null )
			{
				RuiDestroyIfAlive( file.depthRui )
				file.depthRui = null
			}
		}
	)

	int currentResult = -1

	while ( player.IsUsingOffhandWeapon( eActiveInventorySlot.altHand ) )
	{
		RiotDrillPlacementInfo placementInfo = GetRiotDrillPlacementInfo( player, [] )

		vector forward = AnglesToForward( placementInfo.startAngles )

		breachCharge_startProxy.SetOrigin( placementInfo.startOrigin + ( forward * -15.0 ) )
		breachCharge_startProxy.SetAngles( AnglesCompose( placementInfo.startAngles, <90,0,0> ) )

		breachCharge_endProxy.SetOrigin( placementInfo.endOrigin + ( -30.0 * AnglesToUp( AnglesCompose( placementInfo.endAngles, <-90,0,0> ) ) ) )
		breachCharge_endProxy.SetAngles( AnglesCompose( placementInfo.endAngles, -<90,0,0> ) )

		vector placementColor

		if ( placementInfo.placementResult == eBreachPlacementResult.SUCCESS )
			placementColor = ( RIOT_DRILL_PLACEMENT_VALID_COLOR / 255.0 )
		else if ( placementInfo.placementResult == eBreachPlacementResult.FAILED_WALL_TOO_THICK && file.balance_riotDrillAllowThick )
			placementColor = ( RIOT_DRILL_PLACEMENT_CAUTION_COLOR / 255.0 )
		else
			placementColor = ( RIOT_DRILL_PLACEMENT_ERROR_COLOR / 255.0 )

		if ( EffectDoesExist( placementFXhandle_Enter ) )
			EffectSetControlPointVector( placementFXhandle_Enter, 1, placementColor )
		
		currentResult = placementInfo.placementResult

		if ( placementInfo.hide || placementInfo.placementResult == eBreachPlacementResult.FAILED_GENERIC )
		{
			breachCharge_startProxy.Hide()
			breachCharge_endProxy.Hide()
		}
		else
		{
			float distance = Distance( placementInfo.startOrigin, placementInfo.endOrigin )
			float distanceFrac = distance / file.balance_riotDrillMaxThickness
			vector color = GetTriLerpColor( distanceFrac, COLOR_DEPTH_END, COLOR_DEPTH_MID, COLOR_DEPTH_START, 0.6, 0.3 )

			if ( placementInfo.placementResult == eBreachPlacementResult.FAILED_OUT_OF_RANGE
				|| placementInfo.placementResult == eBreachPlacementResult.FAILED_WALL_TOO_THICK
				|| placementInfo.placementResult == eBreachPlacementResult.FAILED_SAFETY_CATCH )
			{
				color = COLOR_DEPTH_UNKNOWN
				distance = -1.0
				breachCharge_startProxy.Hide()
				breachCharge_endProxy.Hide()
				Remote_ServerCallFunction( "ClientCallback_DrillError_On" )
			}
			                                                                                         
			   
			  	                           
			  	                
			  	                              
			  	                            
			   
			else
			{
				breachCharge_startProxy.Show()
				breachCharge_endProxy.Show()
				Remote_ServerCallFunction( "ClientCallback_DrillError_Off" )
			}

			RuiSetFloat( file.depthRui, "depth", distance )
			RuiSetFloat3( file.depthRui, "infoTextColorRGB", ( color / 255.0 ) )

			DeployableModelHighlight( breachCharge_endProxy )
		}
		WaitFrame()
	}
}

entity function CreateBreachChargeProxy( asset modelName )
{
	entity breachCharge = CreateClientSidePropDynamic( <0, 0, 0>, <0, 0, 0>, modelName )
	breachCharge.kv.renderamt = 255
	breachCharge.kv.rendermode = 3
	breachCharge.kv.rendercolor = "255 255 255 255"

	breachCharge.Anim_Play( "ref" )
	breachCharge.Hide()

	return breachCharge
}

void function RiotDrill_AddThreatIndicator( entity dangerZone )
{
	entity player = GetLocalViewPlayer()

	entity owner = dangerZone.GetOwner()
	int team = player.GetTeam()
	int dangerZoneTeam = player.GetTeam()

	if( IsEnemyTeam( team, dangerZoneTeam ) || ( player == owner ) )
		ShowGrenadeArrow( player, dangerZone, file.balance_riotDrillLength, 0, false, eThreatIndicatorVisibility.INDICATOR_SHOW_TO_ALL, ( 60.0 * dangerZone.GetUpVector() ) )
}

#endif         

                                  
                                  
                                  

                                                                                     
var function OnWeaponTossCancel_weapon_riot_drill( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity player = weapon.GetOwner()

	#if SERVER
		                                                                              
	#endif

	return 0
}

var function OnWeaponTossReleaseAnimEvent_weapon_riot_drill( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity player = weapon.GetOwner()

	RiotDrillPlacementInfo placementInfo = GetRiotDrillPlacementInfo( weapon.GetOwner(), [] )
	bool resultIsAllowedThickBreach = file.balance_riotDrillAllowThick && ( placementInfo.placementResult == eBreachPlacementResult.FAILED_WALL_TOO_THICK )
	bool resultIsAllowedOutRangeBreach = file.balance_riotDrillAllowOutRange && ( placementInfo.placementResult == eBreachPlacementResult.FAILED_OUT_OF_RANGE )
	bool resultIsAllowedPlayerTarget = file.balance_riotDrillPlayerCollide && ( placementInfo.placementResult == eBreachPlacementResult.FAILED_SAFETY_CATCH )

	if ( ( placementInfo.placementResult != eBreachPlacementResult.SUCCESS ) )
	{
		if ( !resultIsAllowedThickBreach && !resultIsAllowedOutRangeBreach && !resultIsAllowedPlayerTarget )
		{
			weapon.DoDryfire()
			return 0
		}
	}

	bool ignite = false
	#if SERVER
		                                          
		 
			             
		 
		    
		 
			                                                                                  
			 
				                                                                               
				                                                                                            
				                                                 
			 
			    
			 
				                                                                      
				                                                                                                   
			 
		 
		                                                              
	#else         
		SetBreachChargeDeployed( true )
		player.Signal( "DeployableBreachChargePlacement_End" )
	#endif         

	var result = RiotDrill_FireProjectile( weapon, attackParams, ignite )
	return result
}

                                                            
int function RiotDrill_FireProjectile( entity weapon, WeaponPrimaryAttackParams attackParams, bool ignite )
{
	weapon.EmitWeaponSound_1p3p( GetGrenadeThrowSound_1p( weapon ), GetGrenadeThrowSound_3p( weapon ) )
	bool projectilePredicted      = PROJECTILE_PREDICTED
	bool projectileLagCompensated = PROJECTILE_LAG_COMPENSATED
	#if SERVER
		                                        
		 
			                           
			                                
		 
	#endif
	entity grenade     = Grenade_Launch( weapon, attackParams.pos, (attackParams.dir), projectilePredicted, projectileLagCompensated, false )
	entity weaponOwner = weapon.GetWeaponOwner()
	weaponOwner.Signal( "ThrowGrenade" )

	PlayerUsedOffhand( weaponOwner, weapon, true, grenade )

	if ( IsValid( grenade ) )
	{
		grenade.proj.savedDir = weaponOwner.GetViewForward()
		grenade.proj.savedOrigin = grenade.GetOrigin()
	}
	#if SERVER
	                         
	 
		                                                                                      
		             
		 
			                       
			                               
		 
	 
	#endif

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}

void function OnWeaponActivate_riot_drill( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )

	#if CLIENT
		SetBreachChargeDeployed( false )
		if ( !InPrediction() )                             
			return
		if ( ownerPlayer == GetLocalViewPlayer() )
			thread DeployableBreachChargePlacementThink( ownerPlayer )
	#endif
}
void function OnWeaponDeactivate_riot_drill( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )

	#if CLIENT
		if ( !InPrediction() )                             
			return
		if ( ownerPlayer == GetLocalViewPlayer() )
			ownerPlayer.Signal( "DeployableBreachChargePlacement_End" )
	#endif

	#if SERVER
		                                        
	#endif
}

void function OnProjectileCollision_weapon_riot_drill( entity projectile, vector pos, vector normal, entity hitEnt, int hitBox, bool isCritical, bool isPassthrough )
{
	bool isBounceTarget = ( hitEnt.IsPlayer() || hitEnt.IsNPC() || file.bounceOffSpecialCaseNames.contains( hitEnt.GetScriptName() ) )
	                                                                   
	                                                                                                          
	entity hitEntParent = hitEnt.GetParent()
	if ( IsValid( hitEntParent ) )
		isBounceTarget = isBounceTarget || hitEntParent.IsPlayer() || hitEntParent.IsNPC()

#if SERVER
	                                          

	                        
	 
		                                                                  
		                                                                                                             
			      

		                               
		 
			                                                                                                                   
			                              
		 
	 
#endif

	if ( file.balance_riotDrillPlayerCollide && isBounceTarget )
		return

#if SERVER
	                                                                            
	 
		                                     

		                                            
		                                           
		                                

		                           
		                                                                                                      
		                                                                          
		                                              
		                                                                            
		                                                 
		               	                             

		                                                                                                                                                        
		                                                                        

		                                                                      
		                                                                                             
			      

		                                    
		                        
			      

		                                    
		                                               
		                                                 
		                                                             
		                                                              
		                         
		                                          

		                                                                                                       
		                                                                         

		                                                               
		 
			                                         
			                                                                                                                            
			                                                          
		 

		                      
		                                                                           
		 
			                              
			      
		 

		                                                                                           
	 

	                    
#endif

#if CLIENT
	projectile.SetVelocity( <0, 0, 0> )
	projectile.StopPhysics()
#endif
}

                                   
                                   
                                   

RiotDrillPlacementInfo function GetRiotDrillPlacementInfo( entity player, array<entity> ignoreEnts, bool debugDrawTrace = false )
{
	int placementResult = eBreachPlacementResult.SUCCESS

	array<entity> ignoreArray = file.balance_riotDrillPlayerCollide ? [ player ] : GetPlayerArray()
	ignoreArray.extend( GetPlayerDecoyArray() )
	ignoreArray.extend( ignoreEnts )

	vector traceStart = player.EyePosition()
	vector traceEnd	= traceStart + ( player.GetViewVector() * file.balance_riotDrillRange )

	TraceResults traceResults = TraceLineHighDetail( traceStart, traceEnd, ignoreArray, TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE, player )
	entity testHitEnt = traceResults.hitEnt
	if ( IsValid( testHitEnt ) )
	{
		if ( IsValid( testHitEnt.GetParent() ) )
			testHitEnt = testHitEnt.GetParent()
	}

	if ( !IsValid( testHitEnt ) )
		placementResult = eBreachPlacementResult.FAILED_OUT_OF_RANGE
	else if ( testHitEnt.IsPlayer() || testHitEnt.IsNPC() || file.bounceOffSpecialCaseNames.contains( testHitEnt.GetScriptName() ) )
		placementResult = eBreachPlacementResult.FAILED_SAFETY_CATCH
	else if ( traceResults.hitEnt.GetPassThroughFlags() != 0 && ( CheckPassThroughDir( traceResults.hitEnt, traceResults.surfaceNormal, traceResults.endPos ) ) )
	{
		if ( ignoreEnts.len() == 0 )
			ignoreEnts = [ traceResults.hitEnt ]
		else
			ignoreEnts.append( traceResults.hitEnt )
		return GetRiotDrillPlacementInfo( player, ignoreEnts, debugDrawTrace )
	}

	RiotDrillPlacementInfo placementInfo
	placementInfo.startOrigin = traceResults.endPos
	placementInfo.startAngles = player.EyeAngles()
	placementInfo.startSurfaceNormal = traceResults.surfaceNormal
	placementInfo.placementResult = placementResult
	placementInfo.hide = false
	placementInfo.hitEnt = traceResults.hitEnt

	if ( placementInfo.placementResult == eBreachPlacementResult.SUCCESS)
		placementInfo.placementResult = FindEndSpikeLocation( placementInfo, debugDrawTrace )

	return placementInfo
}

int function FindEndSpikeLocation( RiotDrillPlacementInfo placementInfo, bool debugDrawTrace = false )
{
	const vector HULL_TRACE_MIN = <-4, -4, 0>
	const vector HULL_TRACE_MAX = <4, 4, 32>

	vector pos                             = placementInfo.startOrigin
	vector forward                         = AnglesToForward( placementInfo.startAngles )
	BreachTraceResults breachTraceTresults = BreachTrace( pos, forward, HULL_TRACE_MIN, HULL_TRACE_MAX )

	if ( breachTraceTresults.result == BREACH_TRACE_RESULT_SUCCESS )
	{
		placementInfo.endAngles        = placementInfo.startAngles
		placementInfo.endOrigin        = breachTraceTresults.endPos
		placementInfo.endSurfaceNormal = breachTraceTresults.surfaceNormal
	}
	else if ( breachTraceTresults.result == BREACH_TRACE_RESULT_WALL_TOO_THICK && file.balance_riotDrillAllowThick )
	{
		placementInfo.endAngles = placementInfo.startAngles
		placementInfo.endOrigin = placementInfo.startOrigin
	}

	return breachTraceTresults.result
}

bool function CodeCallback_BreachTraceEarlyExitOnEnt( entity ent )
{
	if ( IsValid( ent ) && file.shieldScriptNames.contains( ent.GetScriptName() ) )
	{
		return true
	}

	return false
}

bool function CodeCallback_BreachTraceIsValidPos( vector pos )
{
	#if SERVER
		                                                                                                 
		                                                                           
		                              
		 
			                                             
				            
		 
	#endif

	return true
}