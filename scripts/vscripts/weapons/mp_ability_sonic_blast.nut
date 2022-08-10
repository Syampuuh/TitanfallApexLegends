global function OnWeaponActivate_ability_sonic_blast
global function OnWeaponDeactivate_ability_sonic_blast
global function OnWeaponTossReleaseAnimEvent_weapon_sonic_blast
global function OnWeaponAttemptOffhandSwitch_weapon_sonic_blast
global function OnWeaponTossPrep_weapon_sonic_blast
global function OnWeaponTossCancel_weapon_sonic_blast
global function MpAbilitySonicBlast_Init
global function GetSonicBlastSilenceDuration
global function GetSonicBlastRange
                            
                                          
                                 

const asset SONIC_BLAST_FX_IMPACT = $"P_wpn_foa_kickup_dust"
const asset SONIC_BLAST_FX_CAST_FP = $"P_wpn_foa_cast_FP"
const asset SONIC_BLAST_FX_WARNING_BEAM = $"P_wpn_foa_beam_warning"
const asset SONIC_BLAST_FX_WARNING_RADIUS = $"P_wpn_foa_radius_MDL_start"
const asset SONIC_BLAST_FX_FRIENDLY_RADIUS = $"P_wpn_foa_radius_MDL_start_friend"
const asset SONIC_BLAST_FX_ENEMY_RADIUS = $"P_wpn_foa_radius_MDL_start_enemy"
const asset SONIC_BLAST_FX_RADIUS = $"P_wpn_foa_radius_MDL"
const asset SONIC_BLAST_FX_HOLD_1P = $"P_wpn_foa_blast_hold"
const asset SONIC_BLAST_FX_HOLD_3P = $"P_wpn_foa_blast_hold_3p"
const asset SONIC_BLAST_FX_TRACER = $"P_foa_warning_mover_spiral"
const asset FX_DRONE_TARGET = $"P_ar_foa_lockon"

const string SONIC_BLAST_MOVER_SCRIPTNAME = "seer_tactical_mover"

#if CLIENT
global function ServerCallback_ApplyScreenShake
global function ServerCallback_DoDamageIndicator
global function ServerToClient_ShowHealthRUI
global function ServerToClient_SpawnedSonicBlast
#endif         

global function ShouldBlastHitVictim
                            
                                             
                                                           
                                
global const float SONIC_BLAST_RADIUS = 200.0
      
global const float SONIC_BLAST_IN_FRONT_START_DISTANCE = 20.0

                            
                                
                                             
                                
const float SONAR_DURATION = 8.0
const float SILENCE_DURATION = 1.25
      
const float SONIC_BLAST_PROJECTILE_TRAVEL_TIME = 0.5
const float SONIC_BLAST_DEBUG_DRAW_SPHERE_DURATION = 3.75

const int SONIC_BLAST_DAMAGE_AMOUNT = 5
const int SONIC_BLAST_RADIUS_FX_SPACING = 200
                            
                                         
                                 
                                                                                                                                                                                         
                                                           

#if DEV
const bool SONIC_BLAST_DEBUG = false
const bool SONIC_BLAST_AUDIO_DEBUG = false
#endif      

global const string SONIC_BLAST_THREAT_TARGETNAME = "sonic_blast_threat"
const string SONIC_BLAST_MOVESPEED_MOD_NAME = "seer_tac_movespeed_modifier"
const string SONIC_BLAST_3P = "Seer_Tac_Detonate_3p"                                         
const string SONIC_INITIAL_BLAST_1P = "Seer_Tac_Projectile_3p"                                                         
const string SONIC_INITIAL_BLAST_3P = "Seer_Tac_Projectile_3p"                                                         
const string SONIC_BLAST_INITIAL_CHARGE_1P = "Seer_Tac_Deploy_1p"                             
const string SONIC_BLAST_INITIAL_CHARGE_3P = "Seer_Tac_Deploy_3p"                                   
const string SONIC_BLAST_DISORIENT_1P = "Seer_Tac_Tinnitus_Loop_1p"
const string SONIC_BLAST_SECOND_CHARGE_1P = "Seer_Tac_Shot_1p"                            
const string SONIC_BLAST_SECOND_CHARGE_3P = "Seer_Tac_Shot_3p"                             
const string SONIC_BLAST_CYLINDER_FORM_3P = "Seer_Tac_Cylinder_Form_3p"                                                
const string SONIC_BLAST_TARGET_ACQUIRED_SOUND = "Seer_AcquireTarget_1P"

struct findBestSoundPositionData
{
	float fraction
	vector position
}

struct
{
	#if SERVER
		                                               
		                                         
	#endif         
	float sonicBlastRange
	float sonicBlastRangeSqr
	float sonicBlastRadius
	float sonicBlastRadiusSqr
	float sonicBlastSilenceDuration
	float sonicBlastSonarDuration
	float sonicBlastTubeLength
	bool sonicBlastDoesDamage
	bool sonicBlastInterrupts
                            
                        
                                 
                                    
                                         
                                  
                                 
	int sonicBlastDamage
} file

void function MpAbilitySonicBlast_Init()
{
	PrecacheParticleSystem( SONIC_BLAST_FX_IMPACT )
	PrecacheParticleSystem( SONIC_BLAST_FX_CAST_FP )
	PrecacheParticleSystem( SONIC_BLAST_FX_WARNING_BEAM )
	PrecacheParticleSystem( SONIC_BLAST_FX_RADIUS )
	PrecacheParticleSystem( SONIC_BLAST_FX_WARNING_RADIUS )
	PrecacheParticleSystem( SONIC_BLAST_FX_HOLD_1P )
	PrecacheParticleSystem( SONIC_BLAST_FX_HOLD_3P )
	PrecacheParticleSystem( SONIC_BLAST_FX_TRACER )
	PrecacheParticleSystem( SONIC_BLAST_FX_FRIENDLY_RADIUS )
	PrecacheParticleSystem( SONIC_BLAST_FX_ENEMY_RADIUS )
	PrecacheParticleSystem( FX_DRONE_TARGET )

	file.sonicBlastRange = GetSonicBlastRange()
	file.sonicBlastRangeSqr = pow( file.sonicBlastRange, 2 )
	file.sonicBlastRadius = GetSonicBlastRadius()
	file.sonicBlastRadiusSqr = pow( file.sonicBlastRadius, 2 )
	file.sonicBlastSilenceDuration = GetSonicBlastSilenceDuration()
	file.sonicBlastSonarDuration = GetSonicBlastSonarDuration()
	file.sonicBlastDoesDamage = GetSonicBlastDoesDamage()
	file.sonicBlastInterrupts = GetSonicBlastInterrupts()
	file.sonicBlastTubeLength = file.sonicBlastRadius * 4.175                                                                                                                                                            
	file.sonicBlastDamage = GetSonicBlastDamage()
                            
                                                                
                                                                          
                                                                              
                                                  
                                                                        
 
                                      
                                 

	RegisterSignal( "SonicBlastReleased" )
	RegisterSignal( "SonicBlastCancelled" )
}

void function OnWeaponActivate_ability_sonic_blast( entity weapon )
{
	entity weaponOwner = weapon.GetWeaponOwner()

	if ( IsValid( weaponOwner ) )
	{
		thread ChargeUpSound_Thread( weapon, weaponOwner )
	}
}

void function OnWeaponDeactivate_ability_sonic_blast( entity weapon )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	#if SERVER
		                             
	#endif

	if ( IsValid( weaponOwner ) )
	{
		weaponOwner.Signal( "EndHeartbeatSensorUI" )
	}
}

void function ChargeUpSound_Thread( entity weapon, entity weaponOwner )
{
	Assert( IsNewThread(), "Must be threaded off" )
	weapon.EndSignal( "OnPrimaryAttack" )
	weaponOwner.EndSignal( "OnDeath" )
	weaponOwner.EndSignal( "OnDestroy" )
	weaponOwner.EndSignal( "BleedOut_OnStartDying" )

	#if CLIENT
	if ( weaponOwner != GetLocalViewPlayer() )
	{
		return
	}
	#endif         

	#if SERVER
	                                                                                          
	#endif         

	#if CLIENT
	EmitSoundOnEntity( weaponOwner, SONIC_BLAST_INITIAL_CHARGE_1P )
	#endif         

	OnThreadEnd(
		function() : (  weaponOwner )
		{
			if ( IsValid( weaponOwner ) )
			{
				#if SERVER
				                                                               
				#endif

				#if CLIENT
				StopSoundOnEntity( weaponOwner, SONIC_BLAST_INITIAL_CHARGE_1P )
				#endif
			}
		}
	)

	WaitForever()
}

bool function OnWeaponAttemptOffhandSwitch_weapon_sonic_blast( entity weapon )
{
	int ammoReq  = weapon.GetAmmoPerShot()
	int currAmmo = weapon.GetWeaponPrimaryClipCount()
	if ( currAmmo < ammoReq )
		return false

	entity player = weapon.GetWeaponOwner()
	if ( player.IsPhaseShifted() )
		return false

	return true
}


var function OnWeaponTossCancel_weapon_sonic_blast( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	weaponOwner.Signal( "EndHeartbeatSensorUI" )
	weaponOwner.Signal( "SonicBlastCancelled" )

	#if SERVER
		                             
	#endif

	return 0
}

void function OnWeaponTossPrep_weapon_sonic_blast( entity weapon, WeaponTossPrepParams prepParams )
{
	weapon.PlayWeaponEffect( SONIC_BLAST_FX_HOLD_1P, SONIC_BLAST_FX_HOLD_3P, "R_HAND" )
	weapon.PlayWeaponEffect( SONIC_BLAST_FX_HOLD_1P, SONIC_BLAST_FX_HOLD_3P, "L_HAND" )

	#if SERVER
		                                                                                                       
		                                            
		                                                                                                                                                                                           
		                                                                                                                                                                                           
		                                              
		                                              
		                                                                                              
		                                                                                              
		                                         
		                                                     
		                                                     
		                                                                  
	#endif
	#if CLIENT
	entity weaponOwner = weapon.GetWeaponOwner()
	if ( weaponOwner == GetLocalViewPlayer() )
	{
		thread DoHeartbeatSensorUI_Thread( weaponOwner )
	}
	#endif         
}

#if SERVER
                                                  
 
	                                            
	 
		                                                            
		 
			                    
			 
				            
			 
		 

		                                          
	 
 

                                                                                  
 
	                                                 
	                             
	                               
	                                        
	                                         

	                        
		      

	            
		                       
		 
			                                                                           
			 
				       
				                        
				 
					                                                        
				 
				            
				                                                  
			 
		 
	 

	                                                                                
	                                                                                               

	                                                                            
	 
		       
		                        
		 
			                                                      
		 
		            
		                                               
	 

	             
 
#endif

#if CLIENT
void function DoHeartbeatSensorUI_Thread( entity player )
{
	Assert ( IsNewThread(), "Must be threaded off." )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "SonicBlastReleased" )
	player.EndSignal( "EndHeartbeatSensorUI" )

	OnThreadEnd(
		function() : ( player )
		{
			DeactivateHeartbeatSensor( player, true )
			player.Signal( "EndHeartbeatSensorUI" )
		}
	)

	entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	float pulloutTime = weapon.GetWeaponSettingFloat( eWeaponVar.toss_pullout_time )

	wait pulloutTime * 1.1                                                                         

	InitializeHeartbeatSensorUI( player )
	ActivateHeartbeatSensor( player, true )

	WaitForever()
}
#endif         

var function OnWeaponTossReleaseAnimEvent_weapon_sonic_blast( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	Assert ( weaponOwner.IsPlayer() )
	weapon.Signal( "OnPrimaryAttack" )

	#if SERVER
	                                                     
	                                         
	#elseif CLIENT
	if ( weaponOwner == GetLocalViewPlayer() )
	{
		int weaponOwnerTeam = weaponOwner.GetTeam()
		vector startPos = weaponOwner.GetWorldSpaceCenter() + ( weaponOwner.GetViewVector() * SONIC_BLAST_IN_FRONT_START_DISTANCE )
		float blastDelay =  GetWeaponInfoFileKeyField_GlobalFloat( weapon.GetWeaponClassName(), "sonic_blast_delay" )
		                                                                                                        
		if ( InPrediction() && IsFirstTimePredicted() )
		{
			var secondChargeSoundHandle = EmitSoundAtPosition( weaponOwnerTeam, startPos, SONIC_BLAST_SECOND_CHARGE_1P )
		}
	}
	#endif         

	weaponOwner.Signal( "SonicBlastReleased" )

	weapon.StopWeaponEffect( SONIC_BLAST_FX_HOLD_1P, SONIC_BLAST_FX_HOLD_3P)
	weapon.StopWeaponEffect( SONIC_BLAST_FX_HOLD_1P, SONIC_BLAST_FX_HOLD_3P)

	if ( weaponOwner.IsPlayer() )
		PlayerUsedOffhand( weaponOwner, weapon )

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}

#if SERVER
                                                                          
 
	                                                 
	                               

	                                           

	                                                                                                                                                                         
	                                                                                      
	                                                  
	                                                                 
	                                                     
	                                                     
	                                                       
	                                                                        

	                                                                                                             

	                             
	 
		                                                                                                                                                   
	 

	             
	                                                                                                                                                    
	                                               
	                                                       

	       
		                        
		 
			                                                    
			                                                                                                        
			                                                                                                     
		 
	            

	                                                                                        

	                                                                                      

	                                                                                                                
	                                              
	                               
	                                  
	                                   
	                                   
	                                      
	                                        
	                                                  
	                                    

	                                                                                                  
	                                                          
	 
		                                         
	 

	            
		                        
		 
			                         
				                 
		 
	 

	                                                               
	                                                                                                         
	                                                  
	                                                                                   

	                                                                      
	                                                                                                                                                           
	                                               

	                                                                                       

	            
		                            
		 
			                             
				                     
		 
	 

	                                                                                                         

	                                          
	                                                            
	 
		                                                                                                                                             
	 

	        

	                                                                                                                                                                                                             
	                                                                                                                                                
	                                                                                       

	                     

	       
	                        
	 
		                                                               
	 
	            
	                                                                                                                                                       

	       
		                        
		 
			                                                                  
		 
	            

	                                                          

	                     

	                                         
	 
		                              
			        

		                            
			        

		                                                                                                 
		 
			                                                            
			               
		 
	 

	               
	 
		                             
		 
			                                                                                            

                               
                                           
    
                                         
                                                        

                                                                                                            

                                               
    
                                    
		 
	 
 

                                                                  
 
	                                       
		      
		
	                          
		      
		
	                                      
		      

	                           
		      

	                                                         
		      

	                                                                                                                                                                            
	                                                                                                                      
	                                                                     
	   
	  	                         
	  		      
	  
	  	                              
	   
 

                                                                                                                                     
 
	                                                
	                                                                              
	                                                                                                                                                 
	                                                                              

	                                                                                                                                                     
	                                                                                 
	                                            
	                                                                 

	                                                                                                                                               
	                                                                              
	                                         
	                                                           

	                                                    
	                                                       
	                                                    

	                                                                    
	                                                                       
	                                                                    
 

                                                                      
 
	                         
	                                          
 

                                                                                                      
 
	                                    

	                                                                                                      
	                                         

	                                                                                                                                                          
	                                                                 
	 
		                                
		 
			                                                                                                                                                                                                                                                                                                                         

			                                                                                                                
			                              
			 
				                         
				 
					      
				 
			 
		 
		    
		 
			                                                                                                                                        
			                        
			 
				                                                       
			 
			                                                                                                                           
			                                                                    
		 

		               
		 
                               
                                 
    
                                                                                                                                         
    
       
    
                                                                           
                                                                                                                                             
    
                                   
			                                                                                                                                     
         
		 
	 

	                                                                                   

	                                                  
	 
		                                                                                           
		                               
		 
			                                                                                                        
		 
	 

	                        
	 
		                                                     

		                                                                         
		                                                                                                         
	 
 

                                                                                          
 
	                                                 

	                      
	                                               
	 
		      
	 

	                             
	                               

	                                     
	                       
	                     
	                        
	                                 
                            
                         
                                                                               

                                        
  
                                                                  
  
     
  
                                                                                                                            
                                            
   
                                                                                    
                                                                                                              
   

                                                                                                                                                                                      
                                 
                                                            
  
                                
	                                                                
      

	                      

	                        
	 
		                                                                                                                                                                                                                                                    
		                   
		                                                                                                                 
	 

	            
		                                                             
		 

			                      
			 
                               
                                           
     
                                               
     
        
     
                                
      
                             
      
     
                                   
				                                          
         
			 
		 
	 

	                                                                                                                                              
	                          
	 
		                                                                                
		                   
		 
			                      
			 
                                
                                           
     
                                               
     
         
     
                                               
      
                                            
      
     
                                
      
                                                              
      
     
         
				                                          
          

				                       
			 
		 
		    
		 
			                       
			 
                                
                                           
     
                                                                     
     
        
     
                                               
      
                                            
      
                                                                  
       
                                                            
                                                                                        
                                                                                             
       
      
     
                                                               
     
         
				                                                                
          

				                      
			 
		 

		           
	 
 

                            
                                                                                                           
 
                                                  
                              
                                
                                          

             
                                                 
   
                                             
   
  

              
 
                                 

                                                                                    
 
	                                                 
	                             
	                               

	            
		                              
		 
			                        
				                                  
		 
	 

	          
 

                                                                                              
 
	                                                 
	                             
	                               

	            
		                                    
		 
			                        
				                               
		 
	 

	          
 
                                                                                                                                                                                      
 
	                                                                 
	                                                                                                                                                

	                                               
	                                                                                   

	              
	                                                                                                                                             
	                                              

	                                                                                                                                              
	                                                

	                                                                                                                                                               
	                                                       
	                                                         
 

                                                                                    
 
	                                                                                      
	                                                                                                              
 

                                                                                
 
	                                                                                          
 
#endif         

bool function ShouldBlastHitVictim( vector startPos, vector blastVector, vector blastVecNormalized, entity victim, int weaponOwnerTeam )
{
	if ( IsValid( victim ) && ( victim.IsPlayer() || victim.IsPlayerDecoy() || IsTrainingDummie( victim ) || IsCombatNPC( victim ) ) )
	{
		vector blastToPlayer = Normalize( victim.GetWorldSpaceCenter() - startPos )

		                                    
		if ( DotProduct( blastVecNormalized, blastToPlayer ) > 0.0 )
		{
			if ( !IsFriendlyTeam( victim.GetTeam(), weaponOwnerTeam ) )
			{
				                                                                                                                                                                                    
				vector projection = GetClosestPointOnLineSegment( startPos, blastVector, victim.EyePosition() )
				float distance = Distance( projection, victim.EyePosition() )

				bool passedDistanceCheck = ( distance <= file.sonicBlastRadius )

                                
                                                                                          
                               
     
                                                                                                                  
                                                                                        

                                                                        
     
                                     

				if ( passedDistanceCheck )
				{
					return true
				}
			}
		}
	}

	return false
}

#if CLIENT
void function ServerCallback_ApplyScreenShake( entity player, vector victimToSonicOriginNormalized )
{
	if ( player == GetLocalViewPlayer() )
	{
		ClientScreenShake( 2.75, 5, 0.75, ZERO_VECTOR )
	}
}

void function ServerCallback_DoDamageIndicator( entity player, entity attacker )
{
	if ( IsValid( player ) && IsValid( attacker ) )
	{
		if ( player == GetLocalViewPlayer() )
		{
			vector damageOrigin = attacker.GetWorldSpaceCenter() + ( attacker.GetViewVector() * SONIC_BLAST_IN_FRONT_START_DISTANCE )
			DamageIndicators( damageOrigin, attacker, eDamageSourceId.mp_ability_sonic_blast )
		}
	}
}


void function ServerToClient_ShowHealthRUI( entity owner, entity victim, float duration )
{
	thread ServerToClient_ShowHealthRUI_Thread( owner, victim, duration )
}

void function ServerToClient_ShowHealthRUI_Thread( entity owner, entity victim, float duration )
{
	Assert ( IsNewThread(), "Must be threaded off." )

	if ( !IsValid( victim ) )
		return

	victim.EndSignal( "OnDestroy" )
	victim.EndSignal( "OnDeath" )

	float endTime = Time() + duration
	bool visible = true

	#if DEV
	if ( SONIC_BLAST_DEBUG )
	{
		printt("ServerToClient_ShowHealthRUI_Thread - Showing HP Bars for " + victim.GetPlayerName())
	}
	#endif      

	OnThreadEnd(
		function() : ( owner, victim )
		{
			ReconScan_RemoveHudForTarget( owner, victim )
		}
	)

	var rui = ReconScan_ShowHudForTarget( owner, victim, false )

	if ( rui != null && victim.IsPlayer() )
	{
		RuiTrackFloat( rui, "bleedoutEndTime", victim, RUI_TRACK_SCRIPT_NETWORK_VAR, GetNetworkedVariableIndex( "bleedoutEndTime" ) )
	}

	while ( Time() < endTime )
	{
		bool phaseShifted = victim.IsPlayer() ? victim.IsPhaseShiftedOrPending() : false

		if ( phaseShifted )
		{
			if ( visible )
			{
				RuiSetBool( rui, "isVisible", false )
				visible = false
			}
		}
		else
		{
			if ( !visible )
			{
				RuiSetBool( rui, "isVisible", true )
				visible = true
			}
		}

		WaitFrame()
	}
}

void function ServerToClient_SpawnedSonicBlast( entity ownerPlayer, int ownerTeam, vector startPos, vector blastVector, float detonationTime )
{
	entity localViewPlayer = GetLocalViewPlayer()
	bool isEnemy           = IsEnemyTeam( ownerTeam, localViewPlayer.GetTeam() )

	var formSound = EmitSoundFromLine( startPos, blastVector, SONIC_BLAST_CYLINDER_FORM_3P )

	if ( isEnemy && ( localViewPlayer != ownerPlayer) )
	{
		thread DoSonicBlastThreatIndicator_Thread( localViewPlayer, startPos, blastVector, detonationTime )
	}

	thread DoClientSideDetonationSound_Thread( detonationTime, startPos, blastVector )
}

void function DoClientSideDetonationSound_Thread( float detonationTime, vector startPos, vector blastVector )
{
	Assert ( IsNewThread(), "Must be threaded off." )
	
	float deltaTime = 0.0

	if ( detonationTime > Time() )
	{
		deltaTime = detonationTime - Time()
	}

	#if DEV
	if ( SONIC_BLAST_DEBUG )
	{
		printt(FUNC_NAME() + " deltaTime for blast: " + deltaTime )
	}
	#endif      

	wait deltaTime

	#if DEV
	if ( SONIC_BLAST_DEBUG )
	{
		printt( FUNC_NAME() + " Sonic Blast Detonation at: " + Time() )
	}
	#endif      

	EmitSoundFromLine( startPos, blastVector, SONIC_BLAST_3P )
}

                                                                                                                                                     
                                                                                                                    
 
	                     

	                                                                                          
	                                                             
	                                                                                                                                  
	                                                         

	                                                                                               
	                          
	 
		       
		                              
		 
			                                                       
		 
		            
		                          
		                        
		              
	 

	                                                 

	                                                                                             
	                                                                        
	 
		                              
		                                                                            
		                   
		                               
	 

	                                         
	                                           
	                   
	                                         

	                                                                          
	                                                  
	 
		                                              
		                                                                                                                            
		                                                       
		                                          

		                          
		 
			                                                           
			                                             
			 
				                                    
				                                    
				                                      
				                                
				       
					                              
					 
						                                                    
						                                                                        
					 
				            
			 
			    
			 
				       
				                              
				 
					                                                    
					                                                                        
				 
				            
			 
		 
		    
		 
			       
			                              
			 
				                                                   
			 
			            
		 
	 

	                                
	 
		                                                                             

		                                                                                                           
		                                                                         
		 
			                                                                                 
		 
		                                                                        
		                                                 
		 
			                                                                                 
		 
		                                                   
		    
		 
			       
			                              
			 
				                                                                                                                                 
				                                                                                                                                  
				                                                                                                                                                                                                      
				                                                                                                                                                                                                      
			 
			            

			                                                                                                                                                                                                                                                                                            

			       
			                              
			 
				                                                                                  
			 
			            

			                               
		 
	 
	    
	 
		                                                                  
		                          
		                        
	 


	       
	                              
	 
		                                                               
	 
	            

	              
   

void function DoSonicBlastThreatIndicator_Thread( entity victim, vector startPos, vector blastVector, float detonationTime )
{
	Assert ( IsNewThread(), "Must be threaded off." )
	victim.EndSignal( "OnDestroy" )

	vector projection = GetClosestPointOnLineSegment( startPos, blastVector, victim.EyePosition() )
	entity threatTarget = CreateClientSidePropDynamic( projection, <0,0,0>, $"mdl/dev/empty_model.rmdl" )

	OnThreadEnd(
		function() : (  threatTarget )
		{
			if ( IsValid( threatTarget ) )
			{
				threatTarget.Destroy()
			}
		}
	)

	threatTarget.SetScriptName( SONIC_BLAST_THREAT_TARGETNAME )
	ShowGrenadeArrow( victim, threatTarget, file.sonicBlastRadius, 0.0, false )

	while ( Time() < detonationTime )
	{
		projection = GetClosestPointOnLineSegment( startPos, blastVector, victim.EyePosition() )
		threatTarget.SetOrigin( projection )
		WaitFrame()
	}
}
#endif         
float function GetSonicBlastSonarDuration()
{
	return GetCurrentPlaylistVarFloat( "seer_tac_sonar_duration", SONAR_DURATION )
}

float function GetSonicBlastSilenceDuration()
{
	return GetCurrentPlaylistVarFloat( "seer_tac_silence_duration", SILENCE_DURATION )
}

float function GetSonicBlastRadius()
{
	return GetCurrentPlaylistVarFloat( "seer_tac_radius", SONIC_BLAST_RADIUS )
}

bool function GetSonicBlastDoesDamage()
{
	return GetCurrentPlaylistVarBool( "seer_tac_does_damage", false )
}

int function GetSonicBlastDamage()
{
	return GetCurrentPlaylistVarInt( "seer_tac_damage", SONIC_BLAST_DAMAGE_AMOUNT )
}
                            
                                          
 
                                                                      
 

                                                 
 
                                                                             
 

                                     
 
                                                              
 

                                                 
 
                                                                            
 

                                                  
 
                                                                                                       
 
                                 

bool function GetSonicBlastInterrupts()
{
                            
                                                                 
                                
	return GetCurrentPlaylistVarBool( "seer_tac_interrupts", true )
      
}

                                                                                                                                                                         
float function GetSonicBlastRange()
{
	return GetHeartbeatSensorRange()
}

