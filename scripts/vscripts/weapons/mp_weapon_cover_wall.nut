global function MpWeaponCoverWall_Init

global function OnWeaponPrimaryAttack_weapon_cover_wall
global function OnWeaponActivate_weapon_cover_wall
global function OnWeaponDeactivate_weapon_cover_wall
global function OnWeaponAttemptOffhandSwitch_weapon_cover_wall
#if CLIENT
global function OnCreateClientOnlyModel_weapon_cover_wall
#endif

#if SERVER
                                                 
                             
#endif

global function IsAmpedWallEnt

                                        
                                         

const string COVER_WALL_WEAPON_NAME = "mp_weapon_cover_wall"
const asset COVER_WALL_MODEL = $"mdl/props/rampart_cover_wall/rampart_cover_wall.rmdl"
const asset COLLISION_CYLINDER_MODEL = $"mdl/props/rampart_cover_wall_replacement/rampart_cover_wall_invisible_collision_120x10_phys.rmdl"

const int COVER_WALL_MAX_WALLS = 5

const float COVER_WALL_NO_SPAWN_RADIUS = 256.0
const float COVER_WALL_ICON_HEIGHT = 48.0
const int COVER_WALL_MAX_HEALTH = 400
const int COVER_WALL_STARTING_HEALTH = 45
global const string BASE_WALL_SCRIPT_NAME = "cover_wall"
const float AMPED_WALL_HEIGHT_OFFSET = 39.0
const float TIME_BEFORE_SWITCHING_FROM_MOBILE_HMG = 0.6

            
const float TIME_ELAPSED_BEFORE_ARM_EXTEND_BEGIN = 0.25
const float ARMOR_DEPLOY_DURATION = 0.5

                     
const float COVER_WALL_PLACEMENT_DELAY = 0.5

               
const float TIME_ELAPSED_BEFORE_ARM_EXTEND_BEGIN_MODIFIED = 0.1
const float ARMOR_DEPLOY_DURATION_MODIFIED = 0.3
const float COVER_WALL_PLACEMENT_DELAY_MODIFIED = 0.3
const int COVER_WALL_HIGHER_HEALTH = 120

                         
const float COVER_WALL_MAX_USE_DIST2_MOD = 64 * 64
const float COVER_WALL_PICKUP_TIME = 0.5
const bool COVER_WALL_USE_QUICK = true
const bool COVER_WALL_USE_ALT = true

                  
const float COVER_WALL_REPAIR_INTERVAL = 1.0
const int	COVER_WALL_REPAIR_AMOUNT = 20

const bool COVER_WALL_DEBUG_DRAW_PLACEMENT = false
const bool DEBUG_REPAIR_IS_ENABLED = false

                
global const string AMPED_WALL_SCRIPT_NAME = "amped_wall"
global const string AMPED_WALL_MOVER_SCRIPTNAME = "amped_wall_mover"
const string HEALTH_TICKS_SCRIPT_NAME = "health_ticks"

const float AMPED_WALL_BUILD_DELAY = 3.0
                                                                                                                                              

     
            
const BASE_WALL_DESTROYED_FX = $"P_rampart_wall_destroy"
const BASE_WALL_DAMAGE_STATE_TRANSITION_FX = $"P_rampart_wall_damaged"
const BASE_WALL_DAMAGE_STATE_PERSISTENT_FX = $"P_rampart_wall_damaged_idle"
const BASE_WALL_TAKE_DAMAGE_WHILE_HEALTH_LOW_FX = $"P_rampart_wall_damaged_hit"

            
const float FX_IMPACT_DURATION = 0.05
const DEPLOYABLE_SHIELD_FX_AMPED = $"P_rampart_shield_top"
const AMPED_WALL_DESTROYED_FX = $"P_rampart_amp_destroy"
const AMPED_WALL_PACKED_UP_FX = $"P_rampart_amp_end"

        
const WALL_PLACED_SFX_1P = "Wall_Place_1p"
const WALL_PLACED_SFX_3P = "Wall_Place_3p"
const WALL_LANDS_ON_GROUND = "Wall_Land_Default"

const BASE_WALL_DAMAGE_STATE_TRANSITION_SFX = "Wall_Damage_ArmorBreak"
const BASE_WALL_DAMAGE_STATE_LOOP_SFX = "Wall_Rise_LowPulse_Damaged"
const BASE_WALL_DESTROYED_SFX = "Wall_Explode_Large"

const ARM_EXTEND_SERVO_SFX = "Wall_Rise_Start"
const AMPED_WALL_CHARGING_SEQUENCE_SFX = "Wall_Rise_LowPulse"
const AMPED_WALL_CHARGING_FINISHED_SFX = "Wall_ShieldAppear"
const AMPED_WALL_SHIELD_LOOP_SFX = "Wall_Shield_Sustain"
const AMPED_WALL_POWER_DOWN_SFX = "Wall_ShieldPowerDown"
const AMPED_WALL_BREAK_SFX_1P = "Wall_Shield_Break_1p"
const AMPED_WALL_BREAK_SFX_3P = "Wall_Shield_Break_3p"

           
const float WALL_DESTROYED_CALLOUT_MIN_DIST = 1024.0

      
const asset DEPLOYABLE_SHIELD_MODEL = $"mdl/fx/rampart_shield_cell.rmdl"
const asset HEALTH_TICKS_MODEL = $"mdl/fx/rampart_health_ticks.rmdl"

struct
{
	#if SERVER
	                                      
	                                                    
	#endif

	float ampedWallMaxHealth

	int shieldFxIndex
	int persistentDamageFxIndex

	table< entity, entity > ampedWallEntToShieldFX
} file

void function MpWeaponCoverWall_Init()
{
	Remote_RegisterServerFunction( "ClientCallback_TryPickupCoverWall", "entity" )

	#if SERVER
		                                                   

		                                                                          
		                                                                      
	#endif

	#if CLIENT
		RegisterConCommandTriggeredCallback( "+scriptCommand5", OnCharacterButtonPressed )

		AddCallback_UseEntGainFocus( CoverWall_OnGainFocus )
		AddCallback_UseEntLoseFocus( CoverWall_OnLoseFocus )


		RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.RAMPART_WALL, MINIMAP_OBJECT_RUI, MinimapPackage_RampartWall, FULLMAP_OBJECT_RUI, MinimapPackage_RampartWall )
	#endif

	file.ampedWallMaxHealth = GetCurrentPlaylistVarFloat( "rampart_amped_shield_health", 175.0 )

	CoverWall_Precache()
}

void function CoverWall_Precache()
{
	RegisterSignal( "CoverWall_PickedUp" )
	RegisterSignal( "CoverWall_OnContinousUseStopped" )

	PrecacheModel( COVER_WALL_MODEL )
	PrecacheModel( COLLISION_CYLINDER_MODEL )

	file.shieldFxIndex = PrecacheParticleSystem( DEPLOYABLE_SHIELD_FX_AMPED )
	PrecacheParticleSystem( AMPED_WALL_DESTROYED_FX )
	PrecacheParticleSystem( AMPED_WALL_PACKED_UP_FX )

	PrecacheParticleSystem( BASE_WALL_DESTROYED_FX )
	PrecacheParticleSystem( BASE_WALL_DAMAGE_STATE_TRANSITION_FX )
	file.persistentDamageFxIndex = PrecacheParticleSystem( BASE_WALL_DAMAGE_STATE_PERSISTENT_FX )
	PrecacheParticleSystem( BASE_WALL_TAKE_DAMAGE_WHILE_HEALTH_LOW_FX )

	PrecacheModel( DEPLOYABLE_SHIELD_MODEL )
	PrecacheModel( HEALTH_TICKS_MODEL )

	#if CLIENT
		AddCreateCallback( "prop_script", CoverWall_OnPropScriptCreated )
		AddDestroyCallback( "prop_script", CoverWall_OnPropScriptDestroyed )

		AddCallback_ModifyDamageFlyoutForScriptName( BASE_WALL_SCRIPT_NAME, CoverWall_OffsetDamageNumbersLower )
	#endif
}

bool function IsAmpedWallEnt( entity ent )
{
	return ent.GetScriptName() == AMPED_WALL_SCRIPT_NAME
}

entity function GetAmpedWallForBase( entity baseWall )
{
	foreach( entity ent in baseWall.GetLinkEntArray() )
	{
		if ( IsAmpedWallEnt( ent ) )
			return ent
	}

	return null
}

bool function CanReclaimWall( entity baseWall )
{
	entity ampedWall = GetAmpedWallForBase( baseWall )

	if ( !IsValid( baseWall ) )
		return false

	if ( !IsValid( ampedWall) )
	{
		if ( GetCurrentPlaylistVarBool( "rampart_higher_health", true ) )
			 {
				 if ( baseWall.GetMaxHealth() != COVER_WALL_HIGHER_HEALTH )
					 return false
			 }
		else
			 {
				 if ( baseWall.GetMaxHealth() != COVER_WALL_STARTING_HEALTH )
					 return false
			 }
	}

	if ( baseWall.GetHealth() <= 0 )
		return false

	if ( IsValid( ampedWall ) && ampedWall.GetHealth() <= 0 )
		return false

	if ( baseWall.GetHealth() < baseWall.GetMaxHealth() )
		return false

	if ( IsValid( ampedWall ) && ampedWall.GetHealth() < ampedWall.GetMaxHealth() )
		return false

	return true
}


void function OnWeaponActivate_weapon_cover_wall( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	weapon.w.startChargeTime = Time()

	Assert( ownerPlayer.IsPlayer() )
	#if CLIENT
	if ( ownerPlayer != GetLocalViewPlayer() )
		return

	string hintText = IsControllerModeActive() ? "#WPN_COVER_WALL_PLAYER_DEPLOY_HINT" : "#WPN_COVER_WALL_PLAYER_DEPLOY_HINT_PC"
	AddPlayerHint( 120, 0, $"", hintText )

	if ( !InPrediction() )                             
		return
	#endif
}


void function OnWeaponDeactivate_weapon_cover_wall( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )
	#if CLIENT
	if ( ownerPlayer != GetLocalViewPlayer() )
		return

	HidePlayerHint( "#WPN_COVER_WALL_PLAYER_DEPLOY_HINT" )
	HidePlayerHint( "#WPN_COVER_WALL_PLAYER_DEPLOY_HINT_PC" )

	if ( !InPrediction() )                             
		return
	#endif
}

bool function OnWeaponAttemptOffhandSwitch_weapon_cover_wall( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	if ( player.IsZiplining() )
		return false

	entity activeWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	entity ultWeapon = player.GetOffhandWeapon( OFFHAND_ULTIMATE )
	entity placementWeapon = player.GetOffhandWeapon( OFFHAND_ORDNANCE )

	if( IsValid( ultWeapon ) && ultWeapon.GetWeaponClassName() == MOBILE_HMG_WEAPON_NAME && IsValid( placementWeapon ) && placementWeapon.GetWeaponClassName() == MOUNTED_TURRET_PLACEABLE_WEAPON_NAME
			&& ( activeWeapon == ultWeapon || activeWeapon == placementWeapon ) )
	{
		float timeSinceStart = Time() - ultWeapon.w.startChargeTime
		if( timeSinceStart < GetCurrentPlaylistVarFloat( "cover_wall_switch_from_ult_delay", TIME_BEFORE_SWITCHING_FROM_MOBILE_HMG ) )
			return false
	}

	return true
}

#if CLIENT
void function OnCreateClientOnlyModel_weapon_cover_wall( entity weapon, entity model, bool validHighlight )
{
	if ( validHighlight )
	{
		DeployableModelHighlight( model )
	}
	else
	{
		DeployableModelInvalidHighlight( model )
	}
}

vector function CoverWall_OffsetDamageNumbersLower( entity wall, vector damageFlyoutPosition )
{
	return ( damageFlyoutPosition - < 0, 0, wall.GetBoundingMaxs().z/2.0 > )
}
#endif

var function OnWeaponPrimaryAttack_weapon_cover_wall( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	                       
	if ( !weapon.ObjectPlacementHasValidSpot() )
	{
		weapon.DoDryfire()
		return 0
	}

	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )

	#if SERVER
		                                                 
		                                                 
		                                                   
		                                                                
	#endif

	PlayerUsedOffhand( ownerPlayer, weapon )
	return weapon.GetAmmoPerShot()
}

void function PlaceWallWithoutHolstering( entity player )
{
	entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )

	if ( weapon.GetWeaponClassName() != COVER_WALL_WEAPON_NAME )
		return

	if ( weapon.GetWeaponPrimaryClipCount() > weapon.GetAmmoPerShot() )
	{
		WeaponPrimaryAttackParams dummy
		weapon.SetWeaponPrimaryClipCount( weapon.GetWeaponPrimaryClipCount() - expect int ( OnWeaponPrimaryAttack_weapon_cover_wall( weapon, dummy ) ) )
	}
}


#if SERVER
                                                        
 
	                                                                   
	 
		                                                                             

		                               
			      

		                                                                  
			      

		                                                    
			      
	 
 

                                                                                             
 
	                        
		      

	                                                                               

	                          
		                           

	                                                                                       

	                               
	                                   
	                                            

	                            

	                              

	                                                                 
	 
		                                                  
		                                               
	 
	    
	 
		                                                    
		                                                 
	 


	                                         
	                                        
	                                          
	                                         

	                                                
	                                         
	                                                 

	                           
	                                     
	                                       
	                                           
	                                       
	                          
	                                 
	                                    
	                               
	                                          

	                                                        
	                                                       
	                               

	                                                                                                   

	                                  
	                                                                           
	                                         
	                                         
	                                          

	                                                                                                                                                                         
	                                                                            

	                                                 

	                 
	                       

	                                                            
	                                                               

	                                                                                         

	                                                                                                     
	                                
	                                                            
	                                                

	                                                             
	                                                                     

                    
	                                           
       

	                     
	                                                  
	                                                                                                                                                           
	                                                               

	                                                                                                                                                                                                                                 
	                                                   

	                                                      

	                        
	                                         
	                                                                                                                   
	 
		                                             
		                             
		 
			                                  
		 
	 

                 
                                    
       

	         
	                                                                     
	                                                                       
	                                                    

	            
	                                                                                             
	                                                                    

	     
	                                                      

	            
	                                                       
		 
			                               

			                          
				                  

			                                            
				                                                                                                                                                

			                                              
			                       
			 
				                                                    
				 
					                                         
					 
						                              
						                                          
					 
				 
			 

			                                                     
			 
				                                                                
					                                                            

				                                                     
			 

			                        
				                                                               

			                           
			 
				                                
				 
					                    

					                                                  

					                                                                      

					                                                                                                          
						                                                                                                    

					                                
				 
				    
				 
					                   
				 
			 
		 
	 

	                                                                                  
	                                                         
	                                                     

	                                                

	                                                                                     

	                                                                 
	 
		                                        
	 
	    
	 
		                               
	 

	                                                               

	                                                    

	             
 

                                                              
 
	                                                 
	                                  

	                        

	                   
	                           
	                        
	                     
	                                                                             

	              
	 
		                                                 
		                              

		                                         
		                                   

		                                                                                             
		                                                                                            

		                                                                                                                                                                                       
		                                                                                                            
		                                                                                                          
		                              
		                                                  
		 
			                              
			                        
			 
				                                              

				                                                                                                                                                                                                                                             
				 
					                                
					                   
				 
			 
		 

		        
	 
 

                                                                                 
 
	                                                                               
	                                         
	                                                             
	                             
	                              
	                                         
	                                       
	                
	                          
 

                                                                                
 
	                                  
	                                           

	                                                               

	                                                                                                 

	            
		                         
		 
			                          
			 
				                                                               
				                                                   
			 

		 
	 

	                                                                 
	 
		                                                  
	 
	    
	 
		                                         
	 

	                                                                             
	                                                                           
	                                                   

	                                                                 
	 
		                                                                                               
	 
	    
	 
		                                                                             
	 

	                                                                            

	                                                                 
	 
		                                   
	 
	    
	 
		                          
	 

	                                                 
	                                      

	                               
	 
		                                                                                                       
	 
 

                                                                                            
 
	                  
	                                  

	                                                               

	                                
	                                                  

	                                                                                                                                
	                                                          

	                                   

	                                                               
	                                                                             
	                                           
	                                       
	                                    
	                                 
	                                                                           
	                                       
	                
	                                         
	                                        
	                                                 
	                                              
	                                         

	                               
	                                             

	                                                                      
	                                                                      
	                                                 

	                               

                     
	                                           
       

	                                                           

	                                                             
	                                                                     

	                                             

	                                      
	                                          
	                                                                                 

	                                                                               

	                                 
	                                               

	                                  
	                                                     

	                                                                          
	                                                                        
	                                                                        

	                                                             
	                                                            
	                                                            

	                                                                                               
	                                                                                                                                                                                      

	                              
	                                            

	                                                                     

	                                                    

	                                                     

	                                              

	                                                                 
	 
		                                                                                                 
	 
	    
	 
		                                                                                                   
	 

	            
		                                                           
		 
			                                                          

			                                               
				                                               

			                          
			 
				                           
				 
					                                                            
					                                                                                                    
					                                                                                        
					                   
				 
			 

			                          
			 
				                      
			 

			                             
				                     
		 
	 

	             
 

                                                        
 
	                                                 
 

                                                               
 
	                            
		      

	                                                     
		      

	  	                      
	          
		                                   
		                       
		 
			                                                
		 
	      

	                                                          
	                                                   

	                                  

	                       

	                                                   
 

                                                            
 
	                                  
	                                                   

	                       

	                                                   
 

          
                                                                               
 
	                                                
		      

	                                                                            
		      

	                                      
		      

	                                                   
		      

	                                            

	                                         
	 
		                                     
	 
 
      

                                                                                                                         
 
	                             
	                                
	                                  
	                                     
	                                        

	                 
	                       

	                                                                                                        

	           
	 
		                               
		 
			                      
			 
				                                                  
			 
		 
	 

	                        
	                                                                                                                                                                                     
		           

	                                                                                                                                                  
		                     
 

                                                           
 
	                                                     
	                                                                               
	                                                                                  

	                                      
 

                                                                
 
	                                                           

	                                              
	                                          
		            

	                                       
		            

	                                                                             
	                                                            
		            

	                                 
	 
		                                
	 

	           
 

                                                           
 
	                                                        

	                      
		                                     
 

                                                                     
 
	                                                      

	                            
		      

	                           
		      

	                               
		      

	                                                                         
		      

	                                                              

	                                  
	                                                           
	 
		                                 
		 
			                                                                               

			                                 
			 

                                               
				                                              
				                                             
				                                                          
					                                                             
					                                                         
					     
      

				        
					                            
						                                                             
					                                                     
			 
		 

		                             
		 
			                                                             
			                                                         
		 

	 
	    
	 
		                                                       
		 
			                                                         
		 
		    
		 
			                                                     
		 
	 

                 
                                 
                                                                               
       
 

                                                                         
 
	                                                      
	                                                  

	                            
		      

	                           
		      

	                               
		      

	                                                                         
		      

	                                                              

	                                                                                                                                                    
	 
		                                                         
		 
			                                                                                                 
			                                                                                                                                                              
			                                                                     

			                                                                                                                       
			 
				                                                                                                                                           

				                                  
				                                                 

				                                                              
			 

			                                                               
		 
		    
		 
			                                                                                                                                                                   
		 
	 

	                                                          
	 
		                                                                                                                                 
			                                                                                            
			                                                                                                                            
	 

	  	                      
	          
		                                   
		 
			                                   
			                       
			 
				                                                                                      
			 
		 
	      

	                                                                      
	 
		                                    

		                                      
			                                                                                          

		                                                
		                                                   
		                                                                                                    
		                             
		 
			                     
				        

			                                      
			 
				                   
				                                               
			 
		 
	 
 

                                                                
 
	                                                                                                                                                
	                                                                                      

	                                   
	                     
		                    
		                                                                                         
		                                                    
		                                                 
	 
		                                                                                                     
	 
 

                                                                     
 
	              

	                                                                               
	                       
	                                                 

	                  
		      

	                                                                   
	 
		                                                                      
			                  
	 

	                                                                                 
		                                                

	                        
		                                                         

	                                                        
 

                                                                         
 
	                                                                               
	                       
	                                                 

	                  
		      

	  	                      
	          
		                                                                    
		 
			                                   
			                       
			 
				                                                                                      
			 
		 
	      

	                                                                                             

	                  

	                                                      
	                           
		      

	                                       

	                                                              
	 
		                                                                            
			                                                                                                                                                                                                                 

	 
	                               
	 
		                                                           
		                                                                          

		                         
			                                                         

		                                                                                                                                 
			                                                                                                                           
			                                                                                                                            
	 

	                                                                       
	 
		                                                          
		                                              
	 

	                         
	 
		                                                                                                                                                

		                                                                            
		 
			                                                                                           
		 

		                          
		 
			                                                                            
			                                                                                                              
		 
		    
		 
			                                                                                      
		 

		                                                           
			                                                                                         
	 

	                                                                     
 

                                                                    
 
	                  

	                                                   
	 
		                                                        
		 
			                   
		 
	 

	                              
		      

	                                              
	                                                                        


	                                                                               
	 
		                                       

	 
	    
	 
		                                      
	 

	                                          
	 
		                                    
			                                                                                 
		    
			                                                                                 
	 
 
#endif          

bool function CoverWall_CanUse( entity player, entity ent, int useFlags )
{
	if ( ! IsValid( player ) )
		return false

                
                                                         
             
      

	entity weapon = player.GetOffhandWeapon( OFFHAND_TACTICAL )
	if ( !IsValid( weapon ) || weapon.GetWeaponClassName() != COVER_WALL_WEAPON_NAME )
		return false

	bool currentlyInPlacementMode = IsValid( player.GetActiveWeapon( eActiveInventorySlot.mainHand ) )
			&& player.GetActiveWeapon( eActiveInventorySlot.mainHand ).GetWeaponClassName() == COVER_WALL_WEAPON_NAME

	TraceResults viewTrace = GetViewTrace( player )

	return ent.GetOwner() == player &&
			viewTrace.hitEnt == ent &&
			( currentlyInPlacementMode || SURVIVAL_PlayerAllowedToPickup( player ) ) &&
			! GradeFlagsHas( ent, eGradeFlags.IS_BUSY )
}

#if CLIENT
void function CoverWall_OnPropScriptCreated( entity ent )
{
	if ( ent.GetScriptName() == BASE_WALL_SCRIPT_NAME )
	{
		                                                           
		AddEntityCallback_GetUseEntOverrideText( ent, CoverWall_UseTextOverride )
		AddCallback_OnUseEntity_ClientServer( ent, CoverWall_OnUseWall )
		                                         
	}
}

void function CoverWall_OnPropScriptDestroyed( entity ent )
{
	if ( !IsValid( ent ) )
		return

	if ( ent.GetScriptName() == BASE_WALL_SCRIPT_NAME )
	{
		CustomUsePrompt_ClearForEntity( ent )
	}
}

void function OnCharacterButtonPressed( entity player )
{
	entity useEnt = player.GetUsePromptEntity()
	if ( !IsValid( useEnt ) || useEnt.GetScriptName() != BASE_WALL_SCRIPT_NAME )
		return

	if ( useEnt.GetOwner() != player )
		return

	CustomUsePrompt_SetLastUsedTime( Time() )

	Remote_ServerCallFunction( "ClientCallback_TryPickupCoverWall", useEnt )
}

string function CoverWall_UseTextOverride( entity ent )
{
	entity player = GetLocalViewPlayer()

	entity weapon = player.GetOffhandWeapon( OFFHAND_TACTICAL )
	if ( player.IsTitan() || !CoverWall_CanUse( player, ent, USE_FLAG_NONE ) || !IsValid( weapon ) || weapon.GetWeaponClassName() != COVER_WALL_WEAPON_NAME )
	{
		CustomUsePrompt_Hide()
	}
	else if ( player == ent.GetOwner() )
	{
		CustomUsePrompt_Show( ent )
		CustomUsePrompt_SetSourcePos( ent.GetOrigin() + < 0, 0, 30 > )

		if ( CanReclaimWall( ent ) )
		{
			CustomUsePrompt_SetText( Localize("#WPN_COVER_WALL_DYNAMIC_RECLAIM") )
			CustomUsePrompt_SetHintImage( $"rui/hud/character_abilities/rampart_cover_pickup" )
			CustomUsePrompt_SetLineColor( <0.0, 1.0, 1.0> )
		}
		else
		{
			CustomUsePrompt_SetText( Localize("#WPN_COVER_WALL_DYNAMIC_DESTROY") )
			                                                                                      
			CustomUsePrompt_SetHintImage( $"" )
			CustomUsePrompt_SetLineColor( <1.0, 0.5, 0.0> )
		}

		if ( PlayerIsInADS( player ) )
			CustomUsePrompt_ShowSourcePos( false )
		else
			CustomUsePrompt_ShowSourcePos( true )
	}

	return ""
}

void function CoverWall_OnUseWall( entity wallProxy, entity player, int useFlags )
{
	if ( IsControllerModeActive() )
	{
		if ( ! ( useFlags & USE_INPUT_LONG ) )
		{
			thread IssueReloadCommand( player )
		}
	}
}

void function IssueReloadCommand( entity player )
{
	EndSignal( player, "OnDestroy" )

	player.ClientCommand( "+reload" )
	WaitFrame()
	player.ClientCommand( "-reload" )
}

void function CoverWall_CreateHUDMarker( entity wall )
{
	entity localClientPlayer = GetLocalClientPlayer()

	wall.EndSignal( "OnDestroy" )

	if ( !CoverWall_ShouldShowIcon( localClientPlayer, wall ) )
		return

	vector pos = wall.GetOrigin() + <0,0,COVER_WALL_ICON_HEIGHT>
	var rui = CreateCockpitRui( $"ui/cover_wall_marker_icons.rpak", RuiCalculateDistanceSortKey( localClientPlayer.EyePosition(), pos ) )
	RuiTrackFloat( rui, "healthFrac", wall, RUI_TRACK_HEALTH )
	RuiTrackFloat3( rui, "pos", wall, RUI_TRACK_OVERHEAD_FOLLOW )
	RuiKeepSortKeyUpdated( rui, true, "pos" )

	OnThreadEnd(
	function() : ( rui )
	{
		RuiDestroy( rui )
	}
	)

	WaitForever()
}

bool function CoverWall_ShouldShowIcon( entity localPlayer, entity wall )
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

void function CoverWall_OnGainFocus( entity ent )
{
	if ( !IsValid( ent ) )
		return

	if ( ent.GetScriptName() == BASE_WALL_SCRIPT_NAME )
	{
		CustomUsePrompt_Show( ent )
	}
}

void function CoverWall_OnLoseFocus( entity ent )
{
	CustomUsePrompt_ClearForAny()
}
#endif         

  
                                           
  

void function CoverWall_GiveBuff( entity trigger, entity player )
{
	#if SERVER
		                         
			      

		                                       
		 
			                                
		 
		    
		 
			                                   
		 

		                                                     
	#endif          
}

void function CoverWall_TakeBuff( entity trigger, entity player )
{
	#if SERVER
		                         
			      

		                                

		                                          
		 
			                                                     
		 
	#endif          
}

#if CLIENT
void function MinimapPackage_RampartWall( entity ent, var rui )
{
	#if MINIMAP_DEBUG
		printt( "Adding 'rui/hud/tactical_icons/tactical_rampart' icon to minimap" )
	#endif
	RuiSetImage( rui, "defaultIcon", $"rui/hud/tactical_icons/tactical_rampart" )
	RuiSetImage( rui, "clampedDefaultIcon", $"rui/hud/tactical_icons/tactical_rampart" )
	RuiSetBool( rui, "useTeamColor", false )
	RuiSetFloat( rui, "iconBlend", 0.0 )
}
#endif