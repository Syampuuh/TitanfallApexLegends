global function SniperRecon_Init
global function SniperRecon_BeginThread
global function SniperRecon_EndThread
global function SniperReconUI_EndThread
global function SniperRecon_GetBestTarget
global function SniperRecon_IsTracking
#if SERVER
                                                      
#endif

#if CLIENT
global function CL_SniperRecon_UI_Thread
#endif
const float SNIPER_RECON_MAX_DISTANCE = 400 * METERS_TO_INCHES
const float SNIPER_RECON_MAX_DISTANCE_SQR = SNIPER_RECON_MAX_DISTANCE * SNIPER_RECON_MAX_DISTANCE
const float SNIPER_RECON_TRACKING_FOV = 3.5          
const float SNIPER_RECON_MAX_DISTANCE_FROM_TRACE_END = 7.5


const bool SNIPER_RECON_DEBUG = false
const bool SNIPER_RECON_PERF = false
const string SNIPER_RECON_TARGET_NETVAR = "sniperReconBestTarget"

const int SNIPER_RECON_TRACE_MASK = TRACE_MASK_VISIBLE                                         
const int SNIPER_RECON_TRACE_GROUP = TRACE_COLLISION_GROUP_NONE

       
const string SNIPER_RECON_TARGET_ACQUIRED_SOUND = "Vantage_Passive_TargetAquire_1p"
global const string SNIPER_RECON_UI_START_SOUND = "Vantage_Passive_UI_1p"


#if DEV
int dbg_TraceCount = 0
#endif

global struct PotentialTargetData
{
	entity target
	float score
}

enum ePlayerLiveState
{
	None = -1,
	Alive,
	Bleedout,
	CanBeRespawned
}

struct
{
	#if CLIENT
		var scopeRui
	#endif         

#if SERVER
	                                                                      
	                                         
#endif         

} file

void function SniperRecon_Init()
{
	RegisterSignal( "EndSniperRecon" )
	RegisterSignal( "EndSniperRecon_UI" )

	RegisterNetworkedVariable( SNIPER_RECON_TARGET_NETVAR, SNDC_PLAYER_EXCLUSIVE, SNVT_ENTITY )
}

            
                                                                                    
   
  	                                                     
  	 
  		                                                            
  		 
  			                                  
  			 
  				           
  			 
  		 
  	 
  	            
   
        

entity function SniperRecon_GetBestTarget( entity owner )
{
	if ( IsValid(owner) )
	{
		return owner.GetPlayerNetEnt( SNIPER_RECON_TARGET_NETVAR )
	}
	return null
}

void function SniperRecon_BeginThread( entity player, entity weapon, array <entity> targetExcludeList )
{
	#if SERVER
		                                                              
	#endif
}

void function SniperRecon_EndThread( entity player )
{
	player.Signal( "EndSniperRecon" )
}

void function SniperReconUI_EndThread( entity player )
{
	player.Signal( "EndSniperRecon_UI" )
}

bool function SniperRecon_IsTracking( entity owner )
{
	#if CLIENT
	if ( owner == GetLocalViewPlayer() )
	{
		if ( file.scopeRui != null )
			return true
	}
	#endif

	#if SERVER
	                                    
		           
	#endif

	return false
}


#if SERVER
                                                                                                  
 
	                               
	                               
	                                    

	                                     
	                                           

	                                                  
	 
		                                      
		                                                    
	 

	            
		                       
		 
			                                  
				                                   

			                                                          
		 
	 

	             
	 
		       
		                  
		                        
		 
			                                            
		 
		      

		                                             

		                                                                   


		                                           
		                                                   
		                                       
		                                        
		                                                                           
		                 
		                                                                 

		                                                 
		                                                                                                                                            

		                         
		 
			                          
			              
			                          

			       
			                                                                                             
			                                            

			        
			                                                                          
			                              

			               
			                                             
			                                 

			                               
			                                      
			                               

			                                                                            
			                             

			         
			                                                
			                                                                            
			                                 

			                                                                                                                           

		 

		                                          
		                                                                

		       
		                        
		 
			                                                            
			                                          
			          
		 
		      
		           
	 
 

                                         
 
	               
	                 
	 
		       
		       
			                              
			     
		       
			                              
			     
		       
			                              
			     
		       
		       
			                              
			     
		       
		       
			                              
			     
		       
		        
			                              
			     
		        
		 
			       
				                                                                                          
			      
			                              
			     
		 
	 
	            
 


                                                                         
 
	                        
		         
	                             
		        

	        
 


                                                                                                                                                                                                      
 
	                                         
	                                      
	 
		                                                 
		                 
			        

		                                                                                   
			        

		                              
			        

		                              
			        

		                                         
			        

		                        
		                                              
		 
			                                                                                  
			                  
		 

		                                                                                 

		                                                                                               
		          

		                                                                           

		                                      
			        

		                                                             
		                                          
		 
			                         
			 
				                                                                         
				                                                                           
			 
			        
		 



		                                   
		                                               
		                                   
		                                   
		                                   
		                                               
		                                  
		 
			                             
			                             
		 

		                                                          
		 
			                                                                              
			                                                                        
			                            
			 
				                   
				                   
				                          
			 
		 
		  
		                                                                        
		 
			                                                                                   
			                                                                              
			                               
			 

				                   
				                   
				                             
			 
		 

		                    
		 
			                         
			 
				                                                                        
				                                                                    
				                                                                
				                                                         
				                                                              
				                                                        
			 
			        
		 


		                   
		 
			                         
			 
				                                               
				                             
				 
					                                        
				 
				                      
				 
					                                
				 
				                        
				 
					                              
				 

				                                                        

				                                                                     
			 


			                              
			                          
			                          

			                                  

		 


	 

	                        
	                                
	 
		                                                                                         
		                                                           
		                                   

		                              
		                   
		                                        
		 
			       
			                
			      
			                                                                                                                                                        
			                                                                                                     
			                                                                                                                                                                                        
			                                                                                                                                                 
			 
				                            
				                              
				                         
				 
					                                                          
				 
			 
			                              
			 
				                                                                                   
				                                                         
			 

			                                                               
			 
				       
					                
				      
				                                                                                                                                 
				                                                                                                                                       
				 
					                            
					                              
					                         
					 
						                                                          
					 
				 
				                              
				 
					                                                                         
					                                                         
				 
			 

			                        
			                                                         
			 
				                                                                                  
				                  
			 
			                                                                             
			 
				       
					                
				      
				                                                                                                                                   
				                                                                                                                                         
				 
					                            
					                              
					                         
					 
						                                                          
					 
				 
				                              
				 
					                                                                           
					                                                         
				 
			 

			                         
				     

			                         
			 
				                                                                         
			 

		 
	 

	                 
 

#endif

float function GetReconInfoFOV( entity weapon )
{
	if ( !IsValid( weapon ) )
		return 0.0

	if ( (weapon.GetWeaponTypeFlags() & WPT_ULTIMATE) > 0 ||
					(weapon.GetWeaponTypeFlags() & WPT_VIEWHANDS ) > 0 )
		return 8.0

	if ( weapon.GetWeaponClassName() == KRABER_WEAPON_NAME )
		return 4.5

	string opticAttachment = GetInstalledWeaponAttachmentForPoint( weapon, "sight" )

	float reconInfoFOV = 0.0
	switch ( opticAttachment )
	{
		case "optic_cq_hcog_bruiser":
			reconInfoFOV = 5.0
			break
		case "optic_ranged_hcog":
			reconInfoFOV = 4.0
			break
		case "optic_ranged_aog_variable":
			reconInfoFOV = 7.5
			break
		case "optic_sniper":
			reconInfoFOV = 4.5
			break
		case "optic_sniper_variable":
		case "optic_sniper_threat":
			reconInfoFOV = 6.0
			break
		default:
			reconInfoFOV = 0.0
			break
	}

	return reconInfoFOV
}

#if CLIENT
void function CL_SniperRecon_UI_Thread( entity owner )
{
	if ( owner != GetLocalViewPlayer() )
		return

	owner.Signal( "EndSniperRecon_UI" )                                       
	owner.EndSignal( "OnDestroy" )
	owner.EndSignal( "OnDeath" )
	owner.EndSignal( "EndSniperRecon_UI" )

	file.scopeRui = CreateFullscreenRui( $"ui/vantage_sniper_info.rpak" )
	EmitSoundOnEntity( owner, SNIPER_RECON_UI_START_SOUND )

	OnThreadEnd(
		function() : ( owner )
		{
			if ( file.scopeRui != null )
			{
				RuiSetGameTime( file.scopeRui, "endTime", Time() )
				file.scopeRui = null
			}
		}
	)

	entity previousTarget = null

	while( !GetPlayerIsEmoting( owner )
			&& !owner.Player_IsSkydiving()
			&& !owner.Player_IsSkywardLaunching()
	)
	{
		                                                              
		entity activeWeapon = owner.GetActiveWeapon( eActiveInventorySlot.mainHand )
		float reconInfoFOV = GetReconInfoFOV( activeWeapon )

		float outerCornerScale = reconInfoFOV/activeWeapon.GetWeaponSettingFloat(eWeaponVar.zoom_fov)
		float innerCornerScale = 5.0/ owner.GetFOV()

		float fireRate = activeWeapon.GetWeaponSettingFloat( eWeaponVar.fire_rate )
		float weaponFireDelay = 1.0

		if ( fireRate > 0 )
		{
			weaponFireDelay = 1.0 / fireRate
		}
		                                                                                                             
		weaponFireDelay += 0.3
		RuiSetFloat( file.scopeRui, "weaponFireDelay", weaponFireDelay )

		RuiTrackGameTime( file.scopeRui, "lastFireTime", activeWeapon, RUI_TRACK_WEAPON_LAST_PRIMARY_ATTACK_TIME )
		RuiSetFloat( file.scopeRui, "outerCornerScale", outerCornerScale )

		RuiSetFloat( file.scopeRui, "innerCornerScale", innerCornerScale )

		RuiSetFloat( file.scopeRui, "range", SNIPER_RECON_MAX_DISTANCE )

		float distanceToTarget = Distance( owner.EyePosition(), owner.GetCrosshairTraceEndPos() )
		RuiSetFloat( file.scopeRui, "crossDist", distanceToTarget )
		RuiSetBool( file.scopeRui, "outOfRange", false )

		if ( IsValid( activeWeapon ) )
			RuiSetBool( file.scopeRui, "isWeaponMelee", DoesWeaponTriggerMeleeAttack( activeWeapon ) )

		bool isSilenced = StatusEffect_GetSeverity( owner, eStatusEffect.silenced ) > 0
		RuiSetBool( file.scopeRui, "visible", !isSilenced )
		entity bestScopeTarget = owner.GetPlayerNetEnt( SNIPER_RECON_TARGET_NETVAR )

		                                                                                       
		if ( IsValid( bestScopeTarget ) )
		{
			int attachID = bestScopeTarget.LookupAttachment( "CHESTFOCUS" )
			                                                   
			vector bestScopeTargetLookupPosition = attachID != 0 ? bestScopeTarget.GetAttachmentOrigin( attachID ) : bestScopeTarget.GetWorldSpaceCenter()
			ScreenSpaceData screenSpaceData = GetScreenSpaceData( owner, bestScopeTargetLookupPosition )
			int screenWidth          = GetScreenSize().width

			int xScreenMid = screenWidth / 2
			int allowedDistFromCenter = int( xScreenMid * outerCornerScale )

			                                                                         
			if ( ( abs( screenSpaceData.deltaCenterX ) > allowedDistFromCenter ) || ( abs( screenSpaceData.deltaCenterY ) > allowedDistFromCenter ) )
			{
				bestScopeTarget = null
			}
		}

		if ( SNIPER_RECON_DEBUG )
		{
			if ( IsValid(bestScopeTarget) )
			{
				DebugDrawSphere( bestScopeTarget.GetWorldSpaceCenter(), 10, <0, 100, 255>, true, 0.1 )


				entity aaTarget = GetAimAssistCurrentTarget()
				if ( IsValid(aaTarget) && aaTarget != bestScopeTarget )
				{
					DebugDrawSphere( aaTarget.GetWorldSpaceCenter(), 15, COLOR_RED, true, 0.1 )
				}
			}
		}

		entity vantageTacWeapon = owner.GetOffhandWeapon( OFFHAND_TACTICAL )
		if ( IsValid( vantageTacWeapon) )
		{
			bool hasAmmo = vantageTacWeapon.GetWeaponPrimaryClipCount() >= vantageTacWeapon.GetAmmoPerShot()
			RuiSetBool( file.scopeRui, "hasAmmo", hasAmmo )
		}

		RuiSetBool( file.scopeRui, "hasTarget", IsValid(bestScopeTarget) )

		RuiSetString( file.scopeRui, "targetClass", "" )
		                                
		if ( IsValid(bestScopeTarget) )
		{
			if ( bestScopeTarget.IsPlayer() )
			{
				bool showTargetClass = GetCurrentPlaylistVarBool( "hawk_scope_show_targetClass", true )
				if ( showTargetClass )
				{
					ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( bestScopeTarget ), Loadout_Character() )
					string name = Localize( ItemFlavor_GetShortName( character ) )
					RuiSetString( file.scopeRui, "targetClass", name )
				}

				               
				array<entity> teamPlayers = GetPlayerArrayOfTeam( bestScopeTarget.GetTeam() )
				array<int> playerStates = [ ePlayerLiveState.None,
											ePlayerLiveState.None,
											ePlayerLiveState.None ]

				array<int> playerArmorTierStates = [ 0, 0, 0 ]

				int thisPlayerIndex = 1
				foreach (teammate in teamPlayers )
				{
					bool isAlive = IsAlive( teammate )
					bool isBleedingOut = Bleedout_IsBleedingOut( teammate )

					int playerArmorTier = EquipmentSlot_GetEquipmentTier( teammate, "armor" )
					int playerState = ePlayerLiveState.None
					if ( isAlive )
					{
						if ( isBleedingOut )
							playerState = ePlayerLiveState.Bleedout
						else
							playerState = ePlayerLiveState.Alive
					}
					else
					{
						if ( PlayerIsMarkedAsCanBeRespawned( teammate ) )
						{
							playerState = ePlayerLiveState.CanBeRespawned
						}
					}

					if ( teammate == bestScopeTarget )
					{
						playerStates[0] = playerState
						playerArmorTierStates[0] = playerArmorTier
					}
					else
					{
						if ( playerState != ePlayerLiveState.None )
						{
							if ( thisPlayerIndex <= 2 )
							{
								playerStates[thisPlayerIndex] = playerState
								playerArmorTierStates[thisPlayerIndex] = playerArmorTier
							}
							thisPlayerIndex++
						}
					}
				}

				for( int i = 0; i < 3; ++i )
				{
					RuiSetInt( file.scopeRui, "player" + i + "State", playerStates[i] )

					bool showArmorTier = GetCurrentPlaylistVarBool( "hawk_scope_show_armorTier", true )
					if ( showArmorTier )
						RuiSetInt( file.scopeRui, "player" + i + "ArmorTier", playerArmorTierStates[i] )
				}
			}
			else
			{
				bool showTargetClass = GetCurrentPlaylistVarBool( "hawk_scope_show_targetClass", true )
				if ( showTargetClass )
				{
					string displayName =  GetDisplayName( bestScopeTarget )
					RuiSetString( file.scopeRui, "targetClass", Localize( displayName ) )
				}
				RuiSetInt( file.scopeRui, "player0ArmorTier", 0 )
				RuiSetInt( file.scopeRui, "player1ArmorTier", 0 )
				RuiSetInt( file.scopeRui, "player2ArmorTier", 0 )
			}


			                
			int attachment = bestScopeTarget.LookupAttachment( "CHESTFOCUS" )
			if ( attachment <= 0 )
				attachment = bestScopeTarget.LookupAttachment( "REF" )

			RuiTrackFloat3( file.scopeRui, "targetPos", bestScopeTarget, RUI_TRACK_POINT_FOLLOW, attachment )
			RuiSetBool( file.scopeRui, "targetChanged", bestScopeTarget != previousTarget )
		}

		if ( bestScopeTarget != previousTarget )
		{
			if ( IsValid(bestScopeTarget) )
				EmitSoundOnEntity( owner, SNIPER_RECON_TARGET_ACQUIRED_SOUND )

			previousTarget = bestScopeTarget
		}

		WaitFrame()
	}
}

string function GetDisplayName( entity displayObject )
{
	string displayName = displayObject.GetTitleForUI()
	string scriptName = displayObject.GetScriptName()
	if ( displayName == "" )
	{
		bool notFound     = false
		switch( scriptName )
		{
			case CRYPTO_DRONE_SCRIPTNAME:
				displayName = "#PROMPT_PING_CRYPTO_DRONE_SHORT"
				break

			case DEATHBOX_FLYER_SCRIPT_NAME:
				displayName = "#PROMPT_PING_FLYER_SHORT"
				break
			case FIRING_RANGE_DUMMIE_SCRIPT_NAME:
			case FIRING_RANGE_COMBAT_DUMMIE_SCRIPT_NAME:
				displayName = "#SURVIVAL_TRAINING_DUMMIE_NAME"
				break

			case DECOY_SCRIPTNAME:
			case CONTROLLED_DECOY_SCRIPTNAME:
			case MIRAGE_DECOY_DROP_SCRIPTNAME:
				displayName = "#DECOY"
				break

			default:
				notFound = true
				displayName = "#HUD_UNKNOWN"
				#if DEV
				printt( "Unknown display name for scriptname: " + scriptName + " for entity: " + displayObject )
				#endif
		}
	}

	#if DEV
	if ( displayName == "" )
	{
		printt( "Unknown display name for entity: " + displayObject + " ,scriptname: "  + scriptName )
	}
	#endif

	return displayName
}

#endif




