global function MpAbilityPhaseWalk_Init

global function OnWeaponActivate_ability_phase_walk
global function OnWeaponChargeBegin_ability_phase_walk
global function OnWeaponChargeEnd_ability_phase_walk

const string SOUND_ACTIVATE_1P = "pilot_phaseshift_firstarmraise_1p"                                                                                                                                                                                   
const string SOUND_ACTIVATE_3P = "pilot_phaseshift_firstarmraise_3p"                                                                                                                

const float PHASE_WALK_PRE_TELL_TIME = 1.5
const asset PHASE_WALK_APPEAR_PRE_FX = $"P_phase_dash_pre_end_mdl"

void function MpAbilityPhaseWalk_Init()
{
	PrecacheParticleSystem( PHASE_WALK_APPEAR_PRE_FX )
}


void function OnWeaponActivate_ability_phase_walk( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	float deploy_time = weapon.GetWeaponSettingFloat( eWeaponVar.deploy_time )

	#if SERVER
		                                                                                 

		                                                                                                              
			                                                              
	#endif

	if ( !weapon.HasMod( "ult_active" ) )
	{
		#if SERVER
			                                                                    
		#endif

		#if CLIENT
			if ( !InPrediction() )
				return

			EmitSoundOnEntity( player, SOUND_ACTIVATE_1P )
		#endif

		float amount = GetCurrentPlaylistVarFloat( "wraith_phase_walk_slow_amount", 0.2 )
		StatusEffect_AddTimed( player, eStatusEffect.move_slow, amount, deploy_time, deploy_time )
	}
}


#if SERVER
                                                   
 
	                                                                         

	                     

	                                        
	 
		                             
			        

		                                     
			        

		                                                      
		                                                       

		                           
			        

		                              

		                                                                  
		                                    

		                    
			        

		                                          
		                                                        

		                                              

		               
		                                                                  
		                                                                   
	 

	               
		                                                                                     
 
#endif

bool function OnWeaponChargeBegin_ability_phase_walk( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	float chargeTime = weapon.GetWeaponSettingFloat( eWeaponVar.charge_time )

	                                       
	{
		bool doStatus = true
		#if CLIENT
			if ( !InPrediction() )
				doStatus = false
		#endif

		if ( doStatus )
		{
			int speedHandle = StatusEffect_AddTimed( player, eStatusEffect.speed_boost, 0.3, chargeTime, chargeTime * 0.3 )

			#if SERVER
			                                            
			#endif
		}
	}

	#if SERVER
	                           

	                                           

	                                                 
	                                   

	                                                         

	#endif
	PhaseShift( player, 0, chargeTime, PHASETYPE_BALANCE )

	player.Signal( "WreckingBall_CleanupFX" )

	return true
}

#if SERVER
                                                                     
 
	                             
	                                         

	                                                                                                                                                    

	                                                      
	             

	                                        
	                                                
	                                                  

	                                                                                                           
	                                                                                  	                     
	                         

	            
	                               
		 
			                        
				                                                                                                                                                   
			                    
		 
	 
	                             
 
#endif

void function OnWeaponChargeEnd_ability_phase_walk( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	#if SERVER
		                                             
		                                            
		 
			                                   
		 
		                                                                                  
		                                                                
		                            
	#endif
}