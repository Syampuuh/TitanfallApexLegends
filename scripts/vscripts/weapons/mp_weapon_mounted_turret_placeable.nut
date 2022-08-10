global function MpWeaponMountedTurretPlaceable_Init

global function OnWeaponOwnerChanged_weapon_mounted_turret_placeable
global function OnWeaponAttemptOffhandSwitch_weapon_mounted_turret_placeable
global function OnWeaponPrimaryAttack_weapon_mounted_turret_placeable
global function OnWeaponActivate_weapon_mounted_turret_placeable
global function OnWeaponDeactivate_weapon_mounted_turret_placeable

global function MountedTurretPlaceable_SetEligibleForRefund

#if CLIENT
global function OnCreateClientOnlyModel_weapon_mounted_turret_placeable
global function ServerCallback_PlayTurretDestroyFX
#endif

#if SERVER
                                                           
                                              
                                                       
                                                       
                                                   
                                                                   
                                                                     
                                                                    
                                                                            
                                                                 
                                                     

                                             
#endif         

                                        
                                         

global enum eTurretClearUserReason
{
	TURRET_USE_FINISHED,
	TURRET_DESTROYED,
	TURRET_DISABLED,
	DEPLOYTHREADFINISHED,
	OTHERREASON,

	_count
}

const asset CAMERA_RIG = $"mdl/props/editor_ref_camera/editor_ref_camera.rmdl"

const asset MOUNTED_TURRET_PLACEABLE_MODEL = $"mdl/props/rampart_turret/rampart_turret.rmdl"
const asset MOUNTED_TURRET_PLACEABLE_SHIELD_COL_MODEL = $"mdl/fx/sentry_turret_shield.rmdl"
const asset MOUNTED_TURRET_PLACEABLE_SHIELD_FX = $"P_anti_titan_shield_3P"
const asset COLLISION_CYLINDER_MODEL = $"mdl/props/rampart_cover_wall_replacement/rampart_cover_wall_invisible_collision_40x15_phys.rmdl"
const asset MOUNTED_TURRET_VEHICLE_COLLISION_MODEL = $"mdl/props/rampart_turret_vehicle_clip/rampart_turret_vehicle_clip_static.rmdl"

global const string MOUNTED_TURRET_PLACEABLE_WEAPON_NAME = "mp_weapon_mounted_turret_placeable"
global const string MOUNTED_TURRET_PLACEABLE_SCRIPT_NAME = "mounted_turret_placeable"
const string MOUNTED_TURRET_PLACEABLE_ENT_NAME = "rampart_turret"

const int MOUNTED_TURRET_PLACEABLE_MAX_TURRETS = 3

const float MOUNTED_TURRET_PLACEABLE_NO_SPAWN_RADIUS = 256.0
const float MOUNTED_TURRET_PLACEABLE_ICON_HEIGHT = 48.0
const int MOUNTED_TURRET_PLACEABLE_MAX_HEALTH = 350

const float TURRET_AMMO_REFUND_ON_PICKUP_FRAC = 0.5

const float EMP_DISABLE_DURATION = 15

                       
const float MOUNTED_TURRET_PLACEABLE_PLACEMENT_RANGE_MAX = 92
const float MOUNTED_TURRET_PLACEABLE_PLACEMENT_RANGE_MIN = 32
const vector MOUNTED_TURRET_PLACEABLE_BOUND_MINS = <-8,-8,-8>
const vector MOUNTED_TURRET_PLACEABLE_BOMB_BOUND_MAXS = <8,8,8>
const vector MOUNTED_TURRET_PLACEABLE_PLACEMENT_TRACE_OFFSET = <0,0,128>
const float MOUNTED_TURRET_PLACEABLE_ANGLE_LIMIT = 0.55
const float MOUNTED_TURRET_PLACEABLE_PLACEMENT_MAX_HEIGHT_DELTA = 32.0


const bool MOUNTED_TURRET_PLACEABLE_DEBUG_DRAW_PLACEMENT = false


     
const FX_EMP_TURRET					= $"P_emp_body_human"
const TURRET_BASE_DESTROYED_FX		= $"P_rampart_turret_base_dest"
const TURRET_GUN_DESTROYED_FX		= $"P_rampart_turret_dest"
const TURRET_DESTROYED_GUN_ATTACH	= "__illumPosition"
const TURRET_DAMAGE_FX_3P			= $"P_rampart_turret_dmg"
const TURRET_PLACEABLE_RANGE_FX 	= $"P_Rampart_Turret_Range_AR"

        
const TURRET_DAMAGED_3P 			= "Turret_Ignite_Burn"
const MOUNT_TURRET_1P 				= "weapon_sheilaturret_mount_1p"
const MOUNT_TURRET_3P				= "weapon_sheilaturret_mount_3p"
const DISMOUNT_TURRET_3P 			= "weapon_sheilaturret_dismount_3p"


           
const float TURRET_DESTROYED_CALLOUT_MIN_DIST = 1024

struct MountedTurretPlaceablePlacementInfo
{
	vector origin
	vector angles
	entity parentTo
	bool success = false
}

struct MountedTurretPlaceablePlayerPlacementData
{
	vector viewOrigin	                                                     
	vector viewForward	                                                      
	vector playerOrigin                                                       
	vector playerForward                                                        
}

struct
{
	#if SERVER
		                                     
		                                          
	#endif

	#if CLIENT
		bool isShowingPlacementFX
	#endif
	table< entity, bool > turretEligibleForRefund
	int maxNumTurretsDeployed
} file

void function MpWeaponMountedTurretPlaceable_Init()
{
	MountedTurretPlaceable_Precache()

	file.maxNumTurretsDeployed = GetCurrentPlaylistVarInt( "rampart_max_turrets_deployed", MOUNTED_TURRET_PLACEABLE_MAX_TURRETS )

	Remote_RegisterServerFunction( "ClientCallback_TryPickupMountedTurret", "entity" )

	#if SERVER
		                                                                                                                              
		                                                                                                                          
		                                                                               
		                                                          
		                                                             
		                                                                                    
	#endif          

	#if CLIENT
		            
		ModelFX_BeginData( "turretDamage", MOUNTED_TURRET_PLACEABLE_MODEL, "all", true )
		ModelFX_AddTagHealthFX( 0.50, "__illumPosition", TURRET_DAMAGE_FX_3P, false )
		ModelFX_EndData()

		RegisterConCommandTriggeredCallback( "+scriptCommand5", OnCharacterButtonPressed )
		AddCallback_UseEntGainFocus( MountedTurretPlaceable_OnGainFocus )
		AddCallback_UseEntLoseFocus( MountedTurretPlaceable_OnLoseFocus )

		RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.RAMPART_TURRET, MINIMAP_OBJECT_RUI, MinimapPackage_RampartGun, FULLMAP_OBJECT_RUI, MinimapPackage_RampartGun )
	#endif          
}

#if SERVER
                                                    
 
	                                                         
		                                

	                                              

	                             
		                                                          
 
#endif

void function MountedTurretPlaceable_Precache()
{
	RegisterSignal( "MountedTurretPlaceable_PickedUp" )
	RegisterSignal( "MountedTurretPlaceable_Active" )
	RegisterSignal( "MountedTurretPlaceable_PlayerLeave" )

	PrecacheModel( MOUNTED_TURRET_PLACEABLE_MODEL )
	PrecacheModel( MOUNTED_TURRET_PLACEABLE_SHIELD_COL_MODEL )
	PrecacheModel( CAMERA_RIG )
	PrecacheModel( COLLISION_CYLINDER_MODEL )
	PrecacheModel( MOUNTED_TURRET_VEHICLE_COLLISION_MODEL )

	PrecacheParticleSystem( MOUNTED_TURRET_PLACEABLE_SHIELD_FX )
	PrecacheParticleSystem( TURRET_DAMAGE_FX_3P )
	PrecacheParticleSystem( TURRET_BASE_DESTROYED_FX )
	PrecacheParticleSystem( TURRET_GUN_DESTROYED_FX )
	PrecacheParticleSystem( TURRET_PLACEABLE_RANGE_FX )

	#if SERVER
		                                                                                                             
	#endif

	#if CLIENT
		RegisterSignal( "MountedTurretPlaceable_StopPlacementProxy" )

		AddCreateCallback( "turret", MountedTurretPlaceable_OnTurretCreated )
		AddDestroyCallback( "turret", MountedTurretPlaceable_OnTurretDestroyed )
	#endif
}

void function OnWeaponOwnerChanged_weapon_mounted_turret_placeable( entity weapon, WeaponOwnerChangedParams changeParams )
{
	entity weaponOwner = weapon.GetWeaponOwner()

	if ( !IsValid( weaponOwner ) )
		return

	if ( !weaponOwner.IsPlayer() )
		return
}

#if CLIENT
void function OnCreateClientOnlyModel_weapon_mounted_turret_placeable( entity weapon, entity model, bool validHighlight )
{
	if ( validHighlight )
	{
		DeployableModelHighlight( model )
		if (!file.isShowingPlacementFX)
			thread ShowPlacementFX( weapon, model )
	}
	else
	{
		DeployableModelInvalidHighlight( model )
	}
}

void function ShowPlacementFX( entity weapon, entity model )
{
	if ( !IsValid(weapon.GetOwner()) )
		return

	weapon.GetOwner().EndSignal( "MountedTurretPlaceable_StopPlacementProxy" )

	file.isShowingPlacementFX = true

	                                                                                                                                                                  
	                                                             

	OnThreadEnd(
		function() : (  )
		{
			file.isShowingPlacementFX = false

			                                         
			  	                                       
		}
	)

	WaitForever()
}

void function ServerCallback_PlayTurretDestroyFX( vector baseOrigin, vector baseAngles, vector gunOrigin, vector gunAngles )
{
	int baseFxID = GetParticleSystemIndex( TURRET_BASE_DESTROYED_FX )
	int gunFxID = GetParticleSystemIndex( TURRET_GUN_DESTROYED_FX )

	StartParticleEffectInWorld( baseFxID, baseOrigin, baseAngles )
	StartParticleEffectInWorld( gunFxID, gunOrigin, gunAngles )
}
#endif          

void function OnWeaponActivate_weapon_mounted_turret_placeable( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	weapon.w.startChargeTime = Time()

	Assert( ownerPlayer.IsPlayer() )
	#if CLIENT
		if ( ownerPlayer != GetLocalViewPlayer() )
			return

		AddPlayerHint( 120, 0, $"", "#WPN_MOUNTED_TURRET_PLAYER_DEPLOY_HINT" )

		if ( !InPrediction() )                             
			return
	#endif

	#if SERVER
		                                                                                                       
		                                              
		                                                                         
	#endif
}


void function OnWeaponDeactivate_weapon_mounted_turret_placeable( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )
	#if CLIENT
		if ( ownerPlayer != GetLocalViewPlayer() )
			return

		HidePlayerHint( "#WPN_MOUNTED_TURRET_PLAYER_DEPLOY_HINT" )

		if ( !InPrediction() )                             
			return
	#endif

	#if SERVER
		                                                                                                          
	#endif
}

var function OnWeaponPrimaryAttack_weapon_mounted_turret_placeable( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )

	                       
	if ( !weapon.ObjectPlacementHasValidSpot() )
	{
		weapon.DoDryfire()
		return 0
	}

	#if SERVER
		                                                 
		                                                 
		                                                   
		                                                                                     
	#endif

	#if CLIENT
		if( IsValid( GetCompassRui() ) )
			RuiSetFloat( GetCompassRui(), "turretAngle", weapon.GetObjectPlacementAngles().y )
	#endif

	PlayerUsedOffhand( ownerPlayer, weapon )
	return weapon.GetAmmoPerShot()
}

bool function OnWeaponAttemptOffhandSwitch_weapon_mounted_turret_placeable( entity weapon )
{
	int ammoReq = weapon.GetAmmoPerShot()
	int currAmmo = weapon.GetWeaponPrimaryClipCount()
	if ( currAmmo < ammoReq )
		return false

	entity player = weapon.GetWeaponOwner()
	if ( player.IsPhaseShifted() )
		return false

	if ( player.IsZiplining() )
		return false

	return true
}

#if SERVER
                                                                     
 

	                                                                   
	 
		                                                                             

		                               
			      

		                                                                                
			      

		                                                    
			      
	 
	    
	 
		      
	 


	                                   
 

                                                                                                 
 
	                                                           
	                                                                                 
	                                             
	                                                    
	                                       
	                                       
	                                            
	                                                  
	                                         
	                                    
	                          
	                                       
 

                                                                                                                         
 
	                        
		      

	                                                                                                                                

	                          
		                                 

                      
	 
		                                    
		 
			                         
			                                                               
			                                                                                                            
			 
				                     
				      
			 
		 
	 
                            

	                                
	                                      

	                                    
	                                                                                         	                     
	                                                                       
	                                
	                                                               
	                                                            
	                                           
	                                          
	                                              
	                                                                 
	                                          
	                                                       
	                                                                  
	                                    
	                             
	                            
	                                         
	                                             
	                                         
	                                      
	                                 
	                                            
	                            

	                                                                                            
	                                                                              
	                                      
	                                          
	                                          

	                                                    
	 
		                        
			        

		                                          
	 

	                                           

	                                                                                                                                                                         
	                                                                             

	                                   
	                                                    

	                   
	                         
	                                               

	                                           

	                                                                    
	                                 
	 
		                                                    
		                                                                                            
		                                               
		                                                           
	 

	                                                                                          
	                                                                                            

	                                                                                                                   
	                                  
	                                                              
	                                                  

	                                                                                                                             

	                                                                                             
	                                                     

	                                                                   

	                                                        

	            
	                                               
		 
			                                              
				                                                                                                                                                

			                               

			                          
			 
				                                                                           
				                                                   
			 

			                       
			 
				                                                        
				 
					                                               
					 
						                                  
					 
				 
			 

			                             
			 
				                     
			 

		 
	 

	                                    
	                                                          

	                                                       

	                                           
	                                                                            
	                                                                                    

	                                                    

                 
                                     
       

	                                               

	                                                                   
	 
		                                                 
		                             
		 
			                                                                                                                
			                     
		 
	 

	                                                          
	                                                                       

	             
 

                                                                  
 
	                                                 
	                                    

	                        

	                                                            
	                                                         
	                                                    
	                          

	              
	 
		                                                 
		                                

		                                     

		                                                                
		                                                          

		                                                                                                                                                                                                                   
		                                                                                                                                                                               
		                              
		                         
		 
			                              
			                        
			 
				                                              

				                                                                                                                                                                                                                                             
				 
					                                       

					                                                                  
						                                                                    

					                                    
					                     
				 
			 
		 

		         
	 
 

                                                                                   
 
	                                                             
	                             
	                              
	                                         
	                                       
	                
	                            
 

                                                                     
 
	                                                
	                                    
	                                                          
	                                                        

	            
		                            
		 
			                             
			 
				                         
			 
		 
	 

	                                                                              

	             
	 

		                       
		                                                     
		                                       
		                                                 

		                                                                               

		                         
			        

		                                     
		                       
			        

		                                      
			        

		                                      
			        

		                                       
			        

		                                                                 
			        

		                                                               
		                                                                                       
	 
 

                                                                                
 
	                              
	                                
	                                                              
	                                     

	                                    
	
	                         

	                                       

	                             

	                                                
		      

	                                       
	                               

	                                                                  
	                                                                

	                                                                                                    
	                                                                                                        
	                                                                                                
	                                                                                                      
	                                                                                                

	                              

                      
	                                                                  
	                         
		                                                           
                            

	            
		                                    
		 
			                             
			 
				                        
				 
					                                                                         
						                                                                          
				 

				                                                                  
			 

			                        
			 
				                                                                                                       
				                                                                                                           
				                                                                                                   
				                                                                                                         
				                                                                                                   
				                                

				                                              
					                                                                                             
				    
					                                

				                                            
				                                            
			 
		 
	 

	             
 

                                                               
 
	                                                        
		                                
	                                                                                                
 

                                                                  
 
	                             
		                                              
 

                                                            
 
	                                     

	                                                                                                             

	                                            

	                                                             
	                                       
	                                       
	                           
	                                               
	                                  

	                            

	                           

	            
		                                
		 
			                    
			 
				            
			 
			                             
			 
				                                           
			 
		 
	 

	                                                                   

	                                        
		                                     

	                         
 


                                                                       
 
	                                              

	                                                                                  

	                             
	                                                          
 

                                                                                             
 
	                         
		      
	                            
		      

	                                  
	                                             
	 
		                                                                  
		                         
			                                                             
	 

	                    
 

                                                                                  
 
	                                                                                         
 
                                                                                    
 
	                                                                                      
 
                                                                                   
 
	                                                                                     
 
                                                                                           
 
	                                                                                          
 
                                                                                
 
	                                                                                 
 

                                                                     
 
	                                                                           

	                                           
		                                           

	        
 

                                                                                     
 
	                                                 
 

                                                                          
 
	                                           
 

                                                                          
 
	                                                                                        
	 
		                                                                       
	 
 

                                                                                                
 
	                                                                                                
	 
		                                        
		                                                  
	 
 

                                                                                
 
	                                                            
		                                      
 

                                                                        
 
	                                  
	                        
	 
		                                                           
	 
 

                                                                       
 
	                                                                                                  
 

                                                                                    
 
	                                                      

	                              
		      

	                           
		      

	                               
		      

	                                                              

	                                    
	                                                           
	 
		                                 
		 
			                                                                               

			                                 
			 

                                               
				                                              
				                                             
				                                                          
					                                                                           
					                                                         
					     
      
				        
					                                                     
			 
		 

		                             
		 
			                                                                           
			                                                         
		 
	 
	    
	 
		                                                     
	 
 

                                                                                        
 
	                                                      

	                              
		      

	                           
		      

	                               
		      

	                                                              

	                                                 
	                  
		      

	                                        
		                                                                    

	                                                                                                 
	 
		                                                                                                                                   
			                                                                
			                                                                                                                            
	 

	                                                                                                       
	 
		                                                             
		 
			                                                   

			                                         
			 
				                                                                                              

				                                                                                                 
					                                                  
			 
		 
	 

	                                                                        
	 
		                                        

		                                        
			                                                                                           
	 
 

                                                                    
 
	                                           
		                                           

		                                                                              
		                                                                  
		                                                                  

		                                             
		 
			                         
				        

			                                                                                                                        
		 

		                                                                                 

		                                     
		                     
			                    
			                                                                                             
			                                             
		 
			                                                                                                      
		 
 

                                                                                   
 
	                                                
		      

	                                                                                           
		      

	                                      
		      

	                                                   
		      

	                                

	                      
		      

	                                                              

	                                                                                        
		      

	                                            
	                 

	                                   
		                                                                                 

	                                              
		                                                   
			                        
			 
				                                       
			 
		   

		                                         
			                                 

		                                                      
		 
			                                                           

			                                              
			                                                        
			 
				                                                       
				                                                    
				                                                                                                 

				                                           
			 
		 

		                                                                    
			                                                                                                      

		                                                                 
	    
 

#endif          

bool function MountedTurretPlaceable_CanUse( entity player, entity ent, int useFlags )
{
	if ( IsValid( ent.GetDriver() ) )
	{
		return ent.GetDriver() == player
	}

	if ( ! SURVIVAL_PlayerAllowedToPickup( player ) )
		return false

	if ( !IsTurretEnabled( ent ) )
		return false

	if ( GradeFlagsHas( ent, eGradeFlags.IS_BUSY ) )
		return false

                      
	entity parentEnt = ent.GetParent()
	if ( EntIsHoverVehicle( parentEnt ) && HoverVehicle_IsHostileToTeam( parentEnt, player.GetTeam() ) )
		return false
                            

	int maxAngleToAxisAllowedDegrees = 100

	vector playerEyePos = player.EyePosition()
	int attachmentIndex = ent.LookupAttachment( "turret_player_use" )

	Assert( attachmentIndex != 0 )
	vector attachmentAngles   = ent.GetAttachmentAngles( attachmentIndex )
	vector attachmentAnglesToForward  = AnglesToForward( attachmentAngles )
	vector attachmentPos = ent.GetAttachmentOrigin( attachmentIndex ) + <0,0,48> + attachmentAnglesToForward*40

	vector attachmentToPlayerEyes = Normalize( playerEyePos - attachmentPos )

	bool playerEyesInPermittedZone = DotProduct( attachmentToPlayerEyes, attachmentAnglesToForward * -1 ) > deg_cos( maxAngleToAxisAllowedDegrees )
	bool playerLookingTowardsTurretEnough = DotProduct( player.GetViewForward(), -1 * attachmentToPlayerEyes ) > deg_cos( maxAngleToAxisAllowedDegrees / 2 )

	                                                                                                          
	TraceResults pathTraceResults = TraceLine( playerEyePos - <0,0,36>, attachmentPos, [player, ent], TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )
	bool pathToTurretUnobstructed = pathTraceResults.fraction < 1.0 ? false : true

	return playerEyesInPermittedZone && playerLookingTowardsTurretEnough && pathToTurretUnobstructed

}

void function MountedTurretPlaceable_SetEligibleForRefund( entity turretProxy, bool eligible )
{
	file.turretEligibleForRefund[ turretProxy ] <- eligible
}

                                
bool function CanReclaimTurret( entity turret )
{
	return false
}

#if CLIENT
	void function MountedTurretPlaceable_OnTurretCreated( entity ent )
	{
		switch ( ent.GetScriptName() )
		{
			case MOUNTED_TURRET_PLACEABLE_SCRIPT_NAME:
				SetCallback_CanUseEntityCallback( ent, MountedTurretPlaceable_CanUse )
				AddEntityCallback_GetUseEntOverrideText( ent, MountedTurretPlaceable_UseTextOverride )
				file.turretEligibleForRefund[ ent ] <- true
				                                                      
			break
		}
	}

	void function MountedTurretPlaceable_OnTurretDestroyed( entity ent )
	{
		if ( !IsValid( ent ) )
			return

		switch ( ent.GetScriptName() )
		{
			case MOUNTED_TURRET_PLACEABLE_SCRIPT_NAME:
				CustomUsePrompt_ClearForEntity( ent )
				break
		}
	}

	void function MountedTurretPlaceable_OnGainFocus( entity ent )
	{
		if ( !IsValid( ent ) )
			return

		if ( ent.GetScriptName() == MOUNTED_TURRET_PLACEABLE_SCRIPT_NAME )
		{
			CustomUsePrompt_Show( ent )
		}
	}

	void function MountedTurretPlaceable_OnLoseFocus( entity ent )
	{
		CustomUsePrompt_ClearForAny()
	}

	string function MountedTurretPlaceable_UseTextOverride( entity ent )
	{
		entity player = GetLocalViewPlayer()

		if ( !IsTurretEnabled( ent ) )
		{
			CustomUsePrompt_SetText( Localize("#WPN_MOUNTED_TURRET_PLACEABLE_DISABLED") )
			CustomUsePrompt_SetHintImage( $"" )
			CustomUsePrompt_ShowSourcePos( false )
		}
		else if ( !MountedTurretPlaceable_CanUse( player, ent, USE_FLAG_NONE ) || player.IsTitan() || GradeFlagsHas( ent, eGradeFlags.IS_BUSY ) )
		{
			CustomUsePrompt_SetText( Localize("#WPN_MOUNTED_TURRET_PLACEABLE_NO_INTERACTION") )
			CustomUsePrompt_SetHintImage( $"" )
			CustomUsePrompt_ShowSourcePos( false )
		}
		else if ( ent.GetOwner() == player )
		{
			CustomUsePrompt_SetSourcePos( ent.GetOrigin() + < 0, 0, 35 > )

			if ( CanReclaimTurret( ent ) )
			{
				CustomUsePrompt_SetText( Localize("#WPN_MOUNTED_TURRET_PLACEABLE_OWNER_RECLAIM") )
				CustomUsePrompt_SetAdditionalText( Localize( "#WPN_MOUNTED_TURRET_PLACEABLE_DYNAMIC" ) )
				CustomUsePrompt_SetHintImage( $"rui/hud/character_abilities/rampart_cover_pickup" )
				CustomUsePrompt_SetLineColor( <0.0, 1.0, 1.0> )
			}
			else
			{
				CustomUsePrompt_SetText( Localize("#WPN_MOUNTED_TURRET_PLACEABLE_OWNER_DESTROY") )
				CustomUsePrompt_SetAdditionalText( Localize( "#WPN_MOUNTED_TURRET_PLACEABLE_DYNAMIC" ) )
				                                                                                      
				CustomUsePrompt_SetHintImage( $"" )
				CustomUsePrompt_SetLineColor( <1.0, 0.5, 0.0> )
			}


			if ( PlayerIsInADS( player ) )
				CustomUsePrompt_ShowSourcePos( false )
			else
				CustomUsePrompt_ShowSourcePos( true )
		}
		else
		{
			CustomUsePrompt_SetSourcePos( ent.GetOrigin() + < 0, 0, 35 > )
			CustomUsePrompt_ShowSourcePos( true )
			CustomUsePrompt_SetText( Localize( "#WPN_MOUNTED_TURRET_PLACEABLE_DYNAMIC" ) )
		}

		return ""
	}

	void function OnCharacterButtonPressed( entity player )
	{
		entity useEnt = player.GetUsePromptEntity()
		if ( !IsValid( useEnt ) || useEnt.GetScriptName() != MOUNTED_TURRET_PLACEABLE_SCRIPT_NAME )
			return

		if ( useEnt.GetOwner() != player )
			return

		Remote_ServerCallFunction( "ClientCallback_TryPickupMountedTurret", useEnt )
	}

	void function MountedTurretPlaceable_CreateHUDMarker( entity turret )
	{
		entity localClientPlayer = GetLocalClientPlayer()

		turret.EndSignal( "OnDestroy" )

		if ( !MountedTurretPlaceable_ShouldShowIcon( localClientPlayer, turret ) )
			return

		vector pos = turret.GetOrigin() + <0,0,MOUNTED_TURRET_PLACEABLE_ICON_HEIGHT>
		var rui = CreateCockpitRui( $"ui/cover_wall_marker_icons.rpak", RuiCalculateDistanceSortKey( localClientPlayer.EyePosition(), pos ) )
		RuiTrackFloat( rui, "healthFrac", turret, RUI_TRACK_HEALTH )
		RuiTrackFloat3( rui, "pos", turret, RUI_TRACK_OVERHEAD_FOLLOW )
		RuiKeepSortKeyUpdated( rui, true, "pos" )

		OnThreadEnd(
		function() : ( rui )
		{
			RuiDestroy( rui )
		}
		)

		WaitForever()
	}

	bool function MountedTurretPlaceable_ShouldShowIcon( entity localPlayer, entity wall )
	{
		if ( !GamePlayingOrSuddenDeath() )
			return false

		                           
		  	            
		entity owner = wall.GetOwner()
		if ( !IsValid( owner ) )
			return false

		if ( localPlayer.GetTeam() != owner.GetTeam() )
			return false

		return true
	}
#endif         

bool function IsTurretEnabled( entity turret )
{
	#if SERVER
		                                     
			                                     
		    
			                                                                                
			            
	#endif

	#if CLIENT
		foreach ( entity linkedEnt in turret.GetLinkEntArray() )
		{
			if ( IsPlayerWaypoint( linkedEnt ) && linkedEnt.GetWaypointType() == eWaypoint.DEVICE_DISABLED )
				return false
		}

		return true
	#endif
}

#if 0		                
                                                                          
 
	          
		                                                               
	     
		                                                                         
	      
	                        
	                       
	                                        
	            

	            
 

                                                                                                                         
 
	                                    
	                                       
	                                                     
	                                   

	                                                             

	                                                                                                                                                                                                              
	                                      
	 
		                                                   
		                                                                                                 
		                    
			                                                                                                             
	 

	                                                                                               

	                                                 

	                                                                                                  
	                                                                                                                                                                                                 

	                                                    
	 
		                                                                   
		                                                                   
		                                                               
		                                                                                                                              
	 


	                                                                                                                                                                                                                                                                                  

	                                
	                                    
	 
		                                                                

		                                                                           
		 
			                          
		 
	 

	                                                                                                                                                                                             

	               
	                                                                                                                                                                      
	 
		                             
	 

	                                                                                                                      
	 
		                                                                                                                                                                                                                                
		                            
			              
	 

	                                                                      
	                              
	                                 
	 
		              	                                                       
		                                             
		                                      

		                                                                              
		 
			                       
			               
		 
	 

	              
	 
		                                           
		                                      
	 

	                           
		               

	                                           
	                                            
	 
		                                           
		                                               
		                                     

		                                                            

		                                     
			            
			                                  
			                                   
			                 
		 

		                                                  
		 
			                                                     
			                                                                                                                                                                                                                                                                                     

			                                                    
			 
				                                                                   
			 

			                                  
			 
				               
				     
			 
		 
	 

	                                       

	                               

	                                                                                                                           
	  	               
	                                                                                                         
		               

	                                                                                                                                                             
	                                                                                                                                         
		               

	                                                                                                                                                                           
	                                             
	                               
	                          
	                                  
	                                 

	                    
 
#endif         

#if CLIENT
void function MinimapPackage_RampartGun( entity ent, var rui )
{
	#if MINIMAP_DEBUG
		printt( "Adding 'rui/hud/ultimate_icons/ultimate_rampart' icon to minimap" )
	#endif
	RuiSetImage( rui, "defaultIcon", $"rui/hud/ultimate_icons/ultimate_rampart" )
	RuiSetImage( rui, "clampedDefaultIcon", $"rui/hud/ultimate_icons/ultimate_rampart" )
	RuiSetBool( rui, "useTeamColor", false )
	RuiSetFloat( rui, "iconBlend", 0.0 )
}
#endif