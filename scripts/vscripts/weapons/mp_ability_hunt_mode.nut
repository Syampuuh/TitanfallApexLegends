global function OnWeaponPrimaryAttack_hunt_mode
global function MpAbilityHuntModeWeapon_Init
global function MpAbilityHuntModeWeapon_OnWeaponTossPrep
global function OnWeaponDeactivate_hunt_mode
                                        
          
                                   
      
      

#if DEV && CLIENT
global function GetBloodhoundColorCorrectionID
#endif                

const float HUNT_MODE_DURATION = 30.0
const float HUNT_MODE_KNOCKDOWN_TIME_BONUS = 5.0
const asset HUNT_MODE_ACTIVATION_SCREEN_FX = $"P_hunt_screen"
const asset HUNT_MODE_BODY_FX = $"P_hunt_body"

struct
{
	#if CLIENT
		int colorCorrection = -1
	#endif         
	#if SERVER
		                                     
		                                     
	#endif
} file

void function MpAbilityHuntModeWeapon_Init()
{
	#if SERVER
		                                           
		                                                                                                                       
		                                                                                                

		                                                                                 
	#endif         

	RegisterSignal( "HuntMode_ForceAbilityStop" )
	RegisterSignal( "HuntMode_End" )
	AddCallback_GameStateEnter( eGameState.WinnerDetermined, StopHuntMode )

	#if CLIENT
		RegisterSignal( "HuntMode_StopColorCorrection" )
		RegisterSignal( "HuntMode_StopActivationScreenFX" )
		                                                                                                 
		file.colorCorrection = ColorCorrection_Register( "materials/correction/ability_hunt_mode.raw_hdr" )
		PrecacheParticleSystem( HUNT_MODE_ACTIVATION_SCREEN_FX )
		StatusEffect_RegisterEnabledCallback( eStatusEffect.hunt_mode, HuntMode_StartEffect )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.hunt_mode, HuntMode_StopEffect )
		StatusEffect_RegisterEnabledCallback( eStatusEffect.hunt_mode_visuals, HuntMode_StartVisualEffect )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.hunt_mode_visuals, HuntMode_StopVisualEffect )
	#endif

}

#if SERVER
                                                                                       
 
	           
	                           
		      

	                                                                                        
	                                                                 
	 
		                                        
		 
			                                                         
			                                            
			                                                               
			                                                                       
			                                                                                                              
			                                                                                                       

                                    
                        
    
                                                                         
                                                                      
                                                                         
                                 
                                                        
    
        
		 
	 

	                                                                                                  
	 
		                                                             
		                                                                     
	 
 

                                                            
 
	                                                                                                            
	                                                                                                         
	                                                                                                               
	                                                                                                                                                                                                  
	                        
 

                                                                                              
 
	                                                                                        
	                                                                 
	 
		                                                         
		                                            
		                                                               
		                                                                       
		                                                                                                              
		                                                                                                       

                                  
                      
  
                                                                     
                                                                    
                                                                       
                               
                                                      
  
      
	 

	                                                                                                  
	 
		                                                             
		                                                                     
	 
 

                                        
                                                  
 
                          
              

                                                                                       
                                                                
  
                                                           
                                            
                                                               
                                                                       
                                                                                                              
                                                                                                       
             
  

             
 
      
#endif         


void function MpAbilityHuntModeWeapon_OnWeaponTossPrep( entity weapon, WeaponTossPrepParams prepParams )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	weapon.SetScriptTime0( 0.0 )

	#if SERVER
		                                                                                   

		                              
		                            
		                                               

		                                                                
		                           
		                                                                                                               
	#endif
}


var function OnWeaponPrimaryAttack_hunt_mode( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	Assert ( weaponOwner.IsPlayer() )

	                    
	HuntMode_Start( weaponOwner )

	PlayerUsedOffhand( weaponOwner, weapon )

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )
}


void function OnWeaponDeactivate_hunt_mode( entity weapon )
{
	entity weaponOwner = weapon.GetWeaponOwner()

	#if SERVER
		                           
		                           
		                                                 
	#endif         
}


void function HuntMode_Start( entity player )
{
	array<int> ids = []
	ids.append( StatusEffect_AddEndless( player, eStatusEffect.threat_vision, 1.0 ) )
	ids.append( StatusEffect_AddEndless( player, eStatusEffect.speed_boost, 0.15 ) )

	ids.append( StatusEffect_AddTimed( player, eStatusEffect.hunt_mode, 1.0, HUNT_MODE_DURATION, HUNT_MODE_DURATION ) )
	ids.append( StatusEffect_AddTimed( player, eStatusEffect.hunt_mode_visuals, 1.0, HUNT_MODE_DURATION, 5.0 ) )

	#if SERVER
		                                      
			                                                           
		    
			                                                            
		                                                                               
		                                                                               

		                                           
		                                                  

		                            
		 
			                                     
		 

	#endif
}


void function EndThreadOn_HuntCommon( entity player )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "HuntMode_ForceAbilityStop" )
	player.EndSignal( "BleedOut_OnStartDying" )

	#if SERVER
		                                        
	#endif          
}

#if SERVER
                                                   
 
	                             
	                                               
	                                  

	                                                   
	                             
	                                         
	                                            
	                                         
	                                                                                                                                                                
	                                       
	                                   
	                                        
	                                        
	                                   
	                                       
	                                                                 
	                                                                                    
		                                            
	   
	                                                                                    
		                                            
	   
	                        
	                                           

	            
		                        
		 
			                 
		 
	 

	                                    

	             
 

                                                               
 
	                              
	                                

	           
	 
		                                      
		           
	 
 

                                                                               
 
	                                    
	                                               
 

                                                                               
 
	                                               
 

                                                                                
 
	                                
	                            
	                                  
	                                                    
	                                       

	                                          
		      

	                          

	                         
		      

	                                                             
		      

	                     
	                       

	            
		                                    
		 
			                     
			 
				                     
				 
					                                                   
				 
			 
		 
	 

	                        
	 
		                                                                    
			      

		                    
		 
			                                                
			 
				                    
				                                                                      
			 
		 
		    
		 
			                                                 
			 
				                     
				                                                   
			 
		 

		           
	 
 

                                                                
 
	                                     

	                                    
	                                      

	                                  
	                                                  
	                                          

	                   
		            

	                                                                                                                      

	                              
		            

	           
 

                                                                           
 
	                                                

	                                

	                     
	                        

	                                                                
	                                                              
	                                                                                    

                        
		                            
       

	                                                                           
	 
		                                                        
		                                               
		 
			                                     
			                                         
			                      
		 

                         
		                                                           
		 
			                                                                                 
			                                                                                          
			                 
			                 

			                                                                 
			 
				                     
				             
			 
			    
			 
				                                                          
				                                                                                                                 
			 

			                                                      
			                                                                            
			                          
		 
        
	 

	                                                                               
	                                                                                                                                    
	            
		                                                                            
		 
			                                                    
			 
				                                                        
				                                              
				 
					                                                
					                                         
				 
			 

			                        
			 
                           
					                                                        
					 
						                                                         
						                                                                               
					 
          

				                               

				                     
					                               
			 
		 
	 

	                                               
	 
		           
	 
 

                                                         
 
	                                                 
	                                

	                                                        
	                                                              

	                                                                                                                 

	                                                                         
	                                                                           

	                           
	                                                                                       
	                                           
		                                               

	                                      

	            
		                                 
		 
			                          
				                      

			                        
			 
				                                                     
				                                                     
			 
		 
	 

	                         
	                         
	                                               
	 
		                                                                                      
		 
			                   

			                                                     
			                                                     

			                                                                        
			                                                                          
		 

		                                                                                     
		 
			                    

			                                                                         
			                                                                           

			                                                    
			                                                    
		 
		           
	 

 

#endif         

#if CLIENT
void function HuntMode_UpdatePlayerScreenColorCorrection( entity player )
{
	Assert ( IsNewThread(), "Must be threaded off." )
	Assert ( player == GetLocalViewPlayer() )

	EndThreadOn_HuntCommon( player )
	player.EndSignal( "HuntMode_StopColorCorrection" )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ( player )
		{
			ColorCorrection_SetWeight( file.colorCorrection, 0.0 )
			ColorCorrection_SetExclusive( file.colorCorrection, false )
		}
	)

	ColorCorrection_SetExclusive( file.colorCorrection, true )
	ColorCorrection_SetWeight( file.colorCorrection, 1.0 )

	const FOV_SCALE = 1.2
	const LERP_IN_TIME = 0.0125                                                                         
	float startTime = Time()

	while ( true )
	{
		float weight = StatusEffect_GetSeverity( player, eStatusEffect.hunt_mode_visuals )
		                  
		weight = GraphCapped( Time() - startTime, 0, LERP_IN_TIME, 0, weight )

		ColorCorrection_SetWeight( file.colorCorrection, weight )

		WaitFrame()
	}
}

void function HuntMode_StartEffect( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return
}

void function HuntMode_StopEffect( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return
}

void function HuntMode_StartVisualEffect( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return

	GfxDesaturate( true )
	Chroma_StartHuntMode()
	thread HuntMode_UpdatePlayerScreenColorCorrection( ent )
	thread HuntMode_PlayActivationScreenFX( ent )
}

void function HuntMode_StopVisualEffect( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return

	GfxDesaturate( false )
	Chroma_EndHuntMode()
	ent.Signal( "HuntMode_StopColorCorrection" )
	ent.Signal( "HuntMode_StopActivationScreenFX" )
}

void function HuntMode_PlayActivationScreenFX( entity clientPlayer )
{
	Assert ( IsNewThread(), "Must be threaded off." )
	EndThreadOn_HuntCommon( clientPlayer )

	entity viewPlayer = GetLocalViewPlayer()
	int fxid          = GetParticleSystemIndex( HUNT_MODE_ACTIVATION_SCREEN_FX )

	int fxHandle = StartParticleEffectOnEntity( viewPlayer, fxid, FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID )
	EffectSetIsWithCockpit( fxHandle, true )
	Effects_SetParticleFlag( fxHandle, PARTICLE_SCRIPT_FLAG_NO_DESATURATE, true )


	OnThreadEnd(
		function() : ( clientPlayer, fxHandle )
		{
			if ( IsValid( clientPlayer ) && IsAlive( clientPlayer ) )
			{
				if ( EffectDoesExist( fxHandle ) )
					EffectStop( fxHandle, false, true )
			}
		}
	)

	clientPlayer.WaitSignal( "HuntMode_StopActivationScreenFX" )
}

#endif         

void function StopHuntMode()
{
	#if CLIENT
		entity player = GetLocalViewPlayer()
		player.Signal( "HuntMode_ForceAbilityStop" )
	#else
		array<entity> playerArray = GetPlayerArray()
		foreach ( player in playerArray )
			player.Signal( "HuntMode_ForceAbilityStop" )
	#endif
}

#if DEV && CLIENT
int function GetBloodhoundColorCorrectionID()
{
	return file.colorCorrection
}
#endif                
