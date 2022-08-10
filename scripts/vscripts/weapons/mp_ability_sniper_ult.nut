global function SniperUlt_Init
global function OnWeaponActivate_ability_sniper_ult
global function OnWeaponDeactivate_ability_sniper_ult
global function OnWeaponPrimaryAttack_ability_sniper_ult
global function OnWeaponAttemptOffhandSwitch_ability_sniper_ult
global function OnProjectileCollision_sniper_ult
global function OnWeaponStartZoomIn_ability_sniper_ult
global function OnWeaponStartZoomOut_ability_sniper_ult
global function OnWeaponZoomFOVToggle_ability_sniper_ult

global function SniperUlt_GetMarkedDuration

#if SERVER
                                                       
#endif

#if CLIENT
global function OnClientAnimEvent_ability_sniper_ult
#endif              


global const string SNIPERULT_WEAPON_NAME = "mp_ability_sniper_ult"
const string SNIPER_ULT_TOGGLE_ZOOMIN_1P = "weapon_vantageUlt_zoomin_1p"
const string SNIPER_ULT_TOGGLE_ZOOMOUT_1P = "weapon_vantageUlt_zoomout_1p"


                            
                 
global  const float SNIPERULT_HEALINGDENIED_DURATION = 15
                                                    
                                                        
  
  
                                                       
                                                        
                                                                                   
                                          


const float SNIPERULT_WHIZ_BY_SCAN_DURATION = 1
const float SNIPERULT_PLAYER_MARKED_DURATION = 10
const float SNIPERULT_VANTAGE_DMG_SCALE = 2
const float SNIPERULT_TEAM_DMG_SCALE = 1.15

                                                     
                                                
                                                                     

    
const asset FX_SNIPER_ULT_MARK = $"P_van_sniper_mark"
const asset FX_SNIPER_ULT_MARK_WHIZ_BY = $"P_van_sniper_mark_wizby"
const asset FX_SNUPER_ULT_MUZZLE_FLASH_1P = $"P_van_sniper_muzzleflash_FP"
const asset FX_SNUPER_ULT_MUZZLE_FLASH_3P = $"P_van_sniper_muzzleflash_3P"

       
const string SNIPERULT_MARKED_SOUND = "Vantage_Ult_TargetLock_1p"
const string SNIPERULT_MARKED_END_SOUND = "Vantage_Ult_TargetUnlock_1p"
const string SNIPERULT_MARKED_SOUND_TEAM = "Vantage_Ult_TargetLock_Squad_1p"
const string SNIPERULT_MARKED_END_SOUND_TEAM = "Vantage_Ult_TargetUnlock_Squad_1p"
const string SNIPERULT_MARKED_SOUND_VICTIM = "Vantage_Ult_TargetLock_Victim_1p"
const string SNIPERULT_MARKED_END_SOUND_VICTIM = "Vantage_Ult_TargetUnlock_Victim_1p"
const string SNIPERULT_ZOOM_IN = "weapon_vantageUlt_ads_in"
const string SNIPERULT_ZOOM_OUT = "weapon_vantageUlt_ads_out"

                                   
               
                                                         
                                                             
                                                             
                                           
                                                
                                                                                                            
                                


const bool SNIPERULT_DEBUG_DRAW = false

void function SniperUlt_Init()
{
	                                   
	               
	                                              
	                                           
	                                               

	PrecacheParticleSystem( FX_SNIPER_ULT_MARK )
	PrecacheParticleSystem( FX_SNIPER_ULT_MARK_WHIZ_BY )
	PrecacheParticleSystem( FX_SNUPER_ULT_MUZZLE_FLASH_1P )
	PrecacheParticleSystem( FX_SNUPER_ULT_MUZZLE_FLASH_3P )

	                               
	                                                               
	                                                            

	#if SERVER
		                                                                        
		                                                                                       
	#endif




	                
	#if CLIENT
		RegisterSignal( "SniperUlt_StopHealingDeniedFXSignal" )

		                
		StatusEffect_RegisterEnabledCallback( eStatusEffect.healing_denied, SniperUlt_HealingDenied_Start1PFX )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.healing_denied, SniperUlt_HealingDenied_Stop1PFX )
	#endif

	#if CLIENT
		                                                                                 
		SetConVarBool( "rope_visibility_fx_enable", true )

		RegisterSignal( "SniperUlt_Mark_StopSignal" )

		                
		StatusEffect_RegisterEnabledCallback( eStatusEffect.sonar_round_embedded, SniperUlt_Mark_Client_Start )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.sonar_round_embedded, SniperUlt_Mark_Client_Stop )
	#endif
}


void function OnWeaponActivate_ability_sniper_ult( entity weapon )
{
	bool serverOrPredicted = IsServer() || ( InPrediction() && IsFirstTimePredicted() )
	if ( serverOrPredicted )
	{
		weapon.SetTargetingLaserEnabled( false )
	}

	#if SERVER
	                                      

	                             
	 
		                                                       
	 
	#endif
}

void function OnWeaponDeactivate_ability_sniper_ult( entity weapon )
{
	#if SERVER
		                                         
	#endif
}

#if SERVER
                                                                                                                                                                                                                                                           
                                                       
 
	                                                

	                         
		      

	                               

	                                      

	                             
	 
		                                  
		                                    

		                                                                         
		                    

		                             
		 
			                                                      
		 
	 
 
#endif


void function OnWeaponStartZoomIn_ability_sniper_ult( entity weapon )
{
	entity weaponOwner = weapon.GetWeaponOwner()

	if ( !IsValid( weaponOwner ) )
		return

	bool serverOrPredicted = IsServer() || ( InPrediction() && IsFirstTimePredicted() )
	if ( serverOrPredicted )
	{
		#if CLIENT
		if ( weaponOwner == GetLocalViewPlayer() )
		{
			StopSoundOnEntity( weapon, SNIPERULT_ZOOM_OUT )
		}
		#endif
		weapon.SetTargetingLaserEnabled( true )
	}
}

void function OnWeaponStartZoomOut_ability_sniper_ult( entity weapon )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	if ( !IsValid( weaponOwner ) )
		return

	bool serverOrPredicted = IsServer() || ( InPrediction() && IsFirstTimePredicted() )
	if ( serverOrPredicted )
	{
		#if CLIENT
		if ( weaponOwner == GetLocalViewPlayer() )
		{
			StopSoundOnEntity( weapon, SNIPERULT_ZOOM_IN )
			StopSoundOnEntity( weaponOwner, SNIPER_RECON_UI_START_SOUND )
		}
		#endif
		weapon.SetTargetingLaserEnabled( false )
	}
}

void function OnWeaponZoomFOVToggle_ability_sniper_ult( entity weapon, float targetFOV )
{
	#if CLIENT
		if ( weapon.GetOwner() != GetLocalViewPlayer() )
			return

		if ( targetFOV == weapon.GetWeaponSettingFloat( eWeaponVar.zoom_fov ) )             
		{
			EmitSoundOnEntity( weapon, SNIPER_ULT_TOGGLE_ZOOMOUT_1P )
			StopSoundOnEntity( weapon, SNIPER_ULT_TOGGLE_ZOOMIN_1P )
		}
		else           
		{
			EmitSoundOnEntity( weapon, SNIPER_ULT_TOGGLE_ZOOMIN_1P )
			StopSoundOnEntity( weapon, SNIPER_ULT_TOGGLE_ZOOMOUT_1P )
		}
	#endif
}


bool function OnWeaponChargeLevelIncreased_sniper_ult( entity weapon )
{
	if ( weapon.GetWeaponChargeLevel() == weapon.GetWeaponChargeLevelMax() )
	{
		entity player = weapon.GetWeaponOwner()
		if ( !IsValid( player ) )
			return true

		#if CLIENT
			string chargeCompleteSound = GetWeaponInfoFileKeyField_GlobalString( SNIPERULT_WEAPON_NAME, "charge_complete_sound_1p" )
			weapon.EmitWeaponSound_1p3p( chargeCompleteSound, "" )

			if ( IsValid( player ) && IsLocalClientPlayer( player ) )
			{
				Rumble_Play( "rumble_bow_max_charge", {} )
			}
		#endif

	}
	return true
}


var function OnWeaponPrimaryAttack_ability_sniper_ult( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	int ammoUsed = weapon.GetAmmoPerShot()

	if ( weapon.GetWeaponPrimaryClipCount() == weapon.GetWeaponPrimaryClipCountMax() )
	{
		PlayerUsedOffhand( weapon.GetOwner(), weapon )
	}

	bool shouldCreateProjectile = false
	if ( IsServer() || weapon.ShouldPredictProjectiles() )
		shouldCreateProjectile = true

	if ( shouldCreateProjectile )
	{
		entity projectile = FireBallisticRoundWithDrop( weapon, attackParams.pos, attackParams.dir, true, false, 0, false )
		projectile.proj.savedOrigin = attackParams.pos
		projectile.proj.savedDir    = attackParams.dir

		weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.1 )

		weapon.PlayWeaponEffect( FX_SNUPER_ULT_MUZZLE_FLASH_1P, FX_SNUPER_ULT_MUZZLE_FLASH_3P, "muzzle_flash" )
	}
	#if SERVER
	                                  
	                                                                                                                                                        
	#endif

	return ammoUsed
}


bool function OnWeaponAttemptOffhandSwitch_ability_sniper_ult( entity weapon )
{
	return true
}


void function OnProjectileCollision_sniper_ult( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical, bool isPassthrough )
{
		                                                             
		if ( !IsValid( hitEnt ) )
			return

		entity projectileOwner = projectile.GetOwner()
		if ( !IsValid( projectileOwner ) )
			return



		                                                         
		                                                                  

		                                                                           

	#if SERVER
		                                                    
		                                                   
		                                           
		                                        

		                                                                         

		                                                                                              

		                             
		 
			                       
				        

			                                                 
			  	        
			  
			                                                                                   
			   
			  	                           
			  	        
			   

			                                                                                                           
			                                                                           
			                             
				        

			                                

			                                                                                   
			                        
				                                                                                       
		 

	#endif
}

float function SniperUlt_GetMarkedDuration()
{
	float duration = GetCurrentPlaylistVarFloat( "sniperult_marked_duration", SNIPERULT_PLAYER_MARKED_DURATION )
	return duration
}



#if SERVER

                                                                                      
 

	                                                                    

	                                 
	 
		                                                        
			                                           
		                                                                                      
		 
			                                                                                                     
			                                                              
		 

		      
	 

	                         
		      

	                                                      
	              
	                                       
	 
		                                              
		 
			                                                                   
			 

				                                                        
				 
					                      
					                                            
					 
						                                                                                                           
						                                                                 
						                                               
					 
				 
				    
				 
					                        
					                                                                                                     
					                                                              
				 
			 
		 
	 


	                                                                                                  
		      

	                  
	                                                        
		      

	                                                                         

	                                                                                     


	                                                             

	                                                                                   
	                                              
	                                                                       
	                                                                                   

	                    
	                                                                 
 

                                                                    
 
	                                
		      

	                                                      

	                                                                                                        

	                             
	 
		                                                                 
		                                                        
		 
			                                                                                                           
			                                                                 
		 
		    
		 
			                        
			                                                                                                     
			                                                              
		 
	 

	                                              

	                                                                                       

	                                                   
	 
		                                                                 
	 

 

                                                                                          
 
	                               

	                                                                                                                                                                                                    
	                                    
	                                                       

	                                                                       
	                                                                                                      


	            
		                                        
		 
			                        
			 
				                        
				 
					                    
				 

				                         
				 
					                                                                             
					                                                                                                          
				 
			 
		 
	 
	                                   
	                                                                                    
	 
		           
	 
 



                                                                                          
 
	                              
	 
		                                                
	 
	    
	 
		                                                                
	 
 

                                                                                           
 
	                                
	                               

	                                   
	                                                

	                                                                                                                                                                                                         
	                                          
	                                                             

	            
		                                     
		 
			                        
				                               

			                              
			 
				                          
			 
		 
	 

	                                                                     
	 
		           
	 
 


                                                                                               
 
	                                
	                               

	                                       
	                              
	                                                                  


	            
		                                                 
		 
			                        
			 
				                                            
			 
		 
	 

	                                 
	                                                
	 
		           
	 
 

                                                                                                     
 
	                                   
	                                                                                 
	 
		                              
		                                                                                       
	 
	    
	 
		                                                                           
	 
 

                                                                                                           
 
	                                  
	                               
	                             

	                                       
	                                          

	                                                                                                                
	                                                                                                                                                                                                    
	                                    
	                                                       

	                                                                       
	                                                                                                      


	                
		                                                                      

	                                

	            
		                                                                       
		 
			                        
			 
				                              
				                                     
				                                         
				                                        

				                        
				 
					                    
				 

				                         
				 
					                                                                            
					                                                                                                          

					                  
						                                                
				 

				                                               

				                                                                    
				                                   
				 
					                                  
				 
			 
		 
	 
	                                   
	                                                                                    
	 
		                           
			                                                                                        

		           
	 
 


                
                                                                                                              
 
	                               

	                                                                                             
	            
		                                           
		 
			                        
			 
				                                               
			 
		 
	 

	             
 

          
                                                                              
 
	                                                     

	                         
	 
		              
			                                                  
		    
			                                                  
	 
 
      

#endif



#if CLIENT

void function OnClientAnimEvent_ability_sniper_ult( entity weapon, string name )
{
	GlobalClientEventHandler( weapon, name )

	if ( name == "muzzle_flash" )
	{
		if ( IsOwnerViewPlayerFullyADSed( weapon ) )
			return

		  		                                                                                                                  
		  		                                                                                                                  
	}
}
#endif




                
#if CLIENT
void function SniperUlt_HealingDenied_Start1PFX( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return

	entity viewPlayer = GetLocalViewPlayer()

	int fxHandle
	                                                                                                                                                                                 
	                                          
	  
	                                                       
	  
	                                                                    
	  
	                                                                              

	EmitSoundOnEntity( viewPlayer, "wattson_tactical_g" )

	thread SniperUlt_HealingDenied_1PFXThread( viewPlayer, fxHandle )
}

void function  SniperUlt_HealingDenied_1PFXThread( entity player, int fxHandle )
{
	player.EndSignal( "SniperUlt_StopHealingDeniedFXSignal" )
	player.EndSignal( "OnDeath" )

	OnThreadEnd(
		function() : ( fxHandle, player  )
		{
			if ( !EffectDoesExist( fxHandle ) )
				return

			EffectStop( fxHandle, false, true )
		}
	)
}

void function SniperUlt_HealingDenied_Stop1PFX( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return

	entity viewPlayer = GetLocalViewPlayer()


	EmitSoundOnEntity( viewPlayer, "wattson_tactical_g_enemy" )

	                                                                            

	ent.Signal( "SniperUlt_StopHealingDeniedFXSignal" )
}



void function SniperUlt_Mark_Client_Start( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return

	entity viewPlayer = GetLocalViewPlayer()

	int fxHandle
	                                                                                                                                                                                 
	                                          
	                                                       

	EmitSoundOnEntity( viewPlayer, SNIPERULT_MARKED_SOUND_VICTIM )


	                            

	thread SniperUlt_Mark_Client_Thread( viewPlayer, fxHandle )
}

void function SniperUlt_Mark_Client_Thread( entity player, int fxHandle )
{
	player.EndSignal( "SniperUlt_Mark_StopSignal" )
	player.EndSignal( "OnDeath" )

	OnThreadEnd(
		function() : ( fxHandle, player )
		{
			if ( !EffectDoesExist( fxHandle ) )
				return

			EffectStop( fxHandle, false, true )

			                          
			   
			  	                                                                        
			   
		}
	)

	while ( true )
	{
		WaitFrame()
	}
}

void function SniperUlt_Mark_Client_Stop( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return

	entity viewPlayer = GetLocalViewPlayer()

	EmitSoundOnEntity( viewPlayer, SNIPERULT_MARKED_END_SOUND_VICTIM )

	                           
	ent.Signal( "SniperUlt_Mark_StopSignal" )
}
#endif