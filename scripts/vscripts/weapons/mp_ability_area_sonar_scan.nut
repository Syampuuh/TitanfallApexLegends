global function MpAbilityAreaSonarScan_Init

global function OnWeaponActivate_ability_area_sonar_scan
global function OnWeaponPrimaryAttackAnimEvent_ability_area_sonar_scan

#if SERVER
                                                               
                                                 
                                                 
                                              
#endif

const asset FLASHEFFECT    = $"P_sonar_bloodhound"
const asset EYEEFFECT    = $"P_sonar_bloodhound_eyes"
const asset AREA_SCAN_ACTIVATION_SCREEN_FX = $"P_sonar"
const asset FX_SONAR_TARGET = $"P_ar_target_sonar"

const int AREA_SCAN_SKIN_INDEX = 9

const float AREA_SONAR_SCAN_RADIUS = 3000.0
const float AREA_SONAR_SCAN_HUD_FEEDBACK_DURATION = 3.0
const float AREA_SONAR_SCAN_CONE_FOV = 125.0

const bool AREA_SONAR_PERF_TESTING = false


struct
{
	int colorCorrection
	int screeFxHandle
	float areaSonarScanDuration
	float areaSonarScanRadius
	float areaSonarScanRadiusSqr
	float areaSonarScanFOV


#if SERVER
	                                   
	                                                            


	                                         
#endif
} file

void function MpAbilityAreaSonarScan_Init()
{
	PrecacheParticleSystem( FLASHEFFECT )
	PrecacheParticleSystem( EYEEFFECT )
	PrecacheParticleSystem( FX_SONAR_TARGET )

	file.areaSonarScanDuration = GetCurrentPlaylistVarFloat( "bloodhound_scan_duration", 3.0 )
	file.areaSonarScanRadius = GetCurrentPlaylistVarFloat( "area_sonar_scan_radius_override", AREA_SONAR_SCAN_RADIUS )
	file.areaSonarScanRadiusSqr = file.areaSonarScanRadius * file.areaSonarScanRadius
	file.areaSonarScanFOV = GetCurrentPlaylistVarFloat( "bloodhound_scan_cone_fov", AREA_SONAR_SCAN_CONE_FOV )

	#if CLIENT
		PrecacheParticleSystem( AREA_SCAN_ACTIVATION_SCREEN_FX )
		file.colorCorrection = ColorCorrection_Register( "materials/correction/area_sonar_scan.raw_hdr" )

		StatusEffect_RegisterEnabledCallback( eStatusEffect.sonar_pulse_visuals, AreaSonarScan_StartScreenEffect )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.sonar_pulse_visuals, AreaSonarScan_StopScreenEffect )
	#endif         

	RegisterSignal( "AreaSonarScan_Activated" )

}

void function OnWeaponActivate_ability_area_sonar_scan( entity weapon )
{
}

var function OnWeaponPrimaryAttackAnimEvent_ability_area_sonar_scan( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	                                              
	entity weaponOwner = weapon.GetWeaponOwner()
	Assert ( weaponOwner.IsPlayer() )
	
#if CLIENT
	EmitSoundOnPS5Controller( "/host/SonarScan_ButtonPress_1p_2ch_v1_01.wav", "/host/wpn_light_vib_single.wav" )
#endif

	#if SERVER
		                                                                                  
		                                                                                                 
		                                                                                                                      
		                                                                                      
	#endif         

	#if CLIENT
  		                             
  			                                                          
	#endif         

	PlayerUsedOffhand( weaponOwner, weapon )

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )
}



float function AreaSonarScan_GetConeFOV()
{
	return file.areaSonarScanFOV
}

#if SERVER
                                           
 
	                                 
 

                                             
 
	                               
 
                                                
 
	                                  
 

                                                             
 
	                          

	                                       
	                                                                        
	                                                                      
 

                                                                                                                 
 
	       
	                              
		                                           
	      

	                            
	                              

	                                                                                                      
	                                                                                                       

	                                    
	                               
	                       

	                                              

	                                                                                                   
	                           	               
	                     			                            
	                           	   

	              
	                          
	                            
	 
       
		                              
			                                                
		      

		                                       
			                              
		    
			                           

		                                       
		 
			                                               
			                                                  
		 

		                                             
		 
			                             
		 

		                                             


		                                                    

		                                                            
		                                 
		 
			                                                     
		 

		                                      
		                           
		 
			                                                   
		 


       
		                              
			                                              
      
	 

	    
	 
		       
		                              
			                                                  
		      

		                                                                                                                                      
		                        
		                         
		                             
		                                        
		                             	               
		                       			                            
		                             	   


		                                
			                                                                                                     
		    
			                                                                                       

		                                                                                       

		                                                   

		       
			                              
				                                                
		      

	 

	                            
	 
		       
		                              
			                                                   
		      

		                                                                                                  
		                                       
		 
			                                              
			 
				                                                                            
				                                       
					                            

				                                                    
			 
		 

		       
		                              
			                                                 
		      
	 
	    
	 
		       
		                              
			                                                      
		      

		                                                                                                                                         
		                                                                                                  
		                                       
		 
			                                              
			  		                                          
		 

		       
		                              
			                                                    
		      
	 

	                                                                      
	                                                        
	   
	  	                               
	  	 
	  		                                                            
	  	 
	   



	            
		                                                       
		 
			                        
			 
				                                      
				 
					                                             
					                                                                          
				 
			 
			                                    
			 
				                                                                    
				                                                        
				   
				  	                               
				  	 
				  		                                                            
				  	 
				   

				                                                                   
				 
					                               
					                                  
					                                                                                                                         
				 
				                                                     
			 

			                          
				                 

		 
	 



	                                        

	                                           
		                                          

	                                                            
	                                        
	                                                                                                                                           

	                                         
		                                     

	                                                                                                                       
	                                                                                                                                                                  

	                                               
	                                                                                                                           
	                                                               

	                                                                                                 

	                                                                                                                   
	                                         
	                                                                                                                         


	       
	                              
	 
		                                        
		          
	 
	      

	                                 
 

                                                            
 
	                                                
	                            
	                              

	                          
	                                                         
	                                                              
	                                                

	                                                                                                   
	                                                                                                                                                                                                                                                                                                   
	                                       	                        
	                                 		                            
	                                  
	                                   
	                                       
	                                                  

	                                          

	            
		                                  
		 
			                                   
				                           
		 
	 

	                                
		                                                                                                               
	    
		                                                                                                 

	                                                                                                 

	                                                             

	                                 
 

                                                                                                                                                                                                     
 
	                             
	 
		                                    
		                                      
			                                                                                                                                                                          
	 
 

                                                                                                                                                                                                                                                          
 
	                                                      
		                                                  
 

                                                                                                                                                                                                                                                                  
 
	                                                                                                                              
	                                            
		      

	                                                  
		      

	                                                                            
	                                      
		                           

	                                                  
 

                                                                               
 
	                                                     
		      

	                                    
		      

	                       
		      

	                                                   
	                                                                     
	                                                                 
	                 
		      
	                               


	                                                                                                
	                                                                   
	                                                   
	                           
		      

	                                                                                                         
	                         
		      

	                                       
	 
		                                             
		                                                                           
	 

	                                                                                                                                                                          
		                             

	                                       
	                                               
	                                                                

	                                                   

	                                                                  

	                                 
	                                                                                         
	                                                                                                                   
 

                                                                             
 
	                                                       
		      

	                                      
		      

	                                              
		      

	                                                   
	                                                                       
	                                                                   
	                               
	                                 

	                                                                                                
	                                                                     
	                                                                                                             
	                         
		      

	                                         
	 
		                                             
		                                                                           
	 

	                                                                                                                                                                          
		                               

	                                     

	                                                            

	                                                                
 

                                                                             
 
	                                   
	                                                 
		      

	                                              
	 
		                                                
		                                                
	 
 

                                                              
 
	                           
	                                               
		            

	                   
		            

	                       
		            

	                                                                                                                                                                                                                                                                                                                              
		            

	                           
	                                                     
	                        
	 
		                          
		                                                           
			            
	 

	                                                                                                                                                                                                                                                     
		            

	                                                      
		            

	                         
		            

	           
 
#endif

#if CLIENT
void function CreateViemodelSonarFlash( entity ent )
{
	EndSignal( ent, "OnDestroy" )

	entity viewModelArm = ent.GetViewModelArmsAttachment()
	entity viewModelEntity = ent.GetViewModelEntity()
	entity firstPersonProxy = ent.GetFirstPersonProxy()
	entity predictedFirstPersonProxy = ent.GetPredictedFirstPersonProxy()

	                                                                                                        
	vector highlightColor = <1,0,0>
	if ( StatusEffect_GetSeverity( ent, eStatusEffect.damage_received_multiplier ) > 0.0 )
		highlightColor = <1,0,0>

	if ( IsValid( viewModelArm ) )
		SonarViewModelHighlight( viewModelArm, highlightColor )

	if ( IsValid( viewModelEntity ) )
		SonarViewModelHighlight( viewModelEntity, highlightColor )

	if ( IsValid( firstPersonProxy ) )
		SonarViewModelHighlight( firstPersonProxy, highlightColor )

	if ( IsValid( predictedFirstPersonProxy ) )
		SonarViewModelHighlight( predictedFirstPersonProxy, highlightColor )

	EmitSoundOnEntity( ent, "HUD_MP_EnemySonarTag_Activated_1P" )

	wait 0.5                                                                    

	viewModelArm = ent.GetViewModelArmsAttachment()
	viewModelEntity = ent.GetViewModelEntity()
	firstPersonProxy = ent.GetFirstPersonProxy()
	predictedFirstPersonProxy = ent.GetPredictedFirstPersonProxy()

	if ( IsValid( viewModelArm ) )
		SonarViewModelClearHighlight( viewModelArm )

	if ( IsValid( viewModelEntity ) )
		SonarViewModelClearHighlight( viewModelEntity )

	if ( IsValid( firstPersonProxy ) )
		SonarViewModelClearHighlight( firstPersonProxy )

	if ( IsValid( predictedFirstPersonProxy ) )
		SonarViewModelClearHighlight( predictedFirstPersonProxy )
}

void function AreaSonarScan_StartScreenEffect( entity player, int statusEffect, bool actuallyChanged )
{
	entity localViewPlayer = GetLocalViewPlayer()
	if ( player != localViewPlayer )
		return

	entity cockpit = player.GetCockpit()
	if ( !cockpit )
		return

	int indexD        = GetParticleSystemIndex( AREA_SCAN_ACTIVATION_SCREEN_FX )
	file.screeFxHandle = StartParticleEffectOnEntity( cockpit,indexD, FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID )
	EffectSetIsWithCockpit( file.screeFxHandle, true )

	thread ColorCorrection_LerpWeight( file.colorCorrection, 0, 1, 0.5 )
}

void function AreaSonarScan_StopScreenEffect( entity player, int statusEffect, bool actuallyChanged )
{
	Assert( IsValid( player ) )

	entity localViewPlayer = GetLocalViewPlayer()
	if ( player != localViewPlayer )
		return

	if ( file.screeFxHandle > -1 )
	{
		EffectStop( file.screeFxHandle, false, true )
	}

	thread ColorCorrection_LerpWeight( file.colorCorrection, 1, 0, 0.5 )
}

void function ColorCorrection_LerpWeight( int colorCorrection, float startWeight, float endWeight, float lerpTime = 0 )
{
	float startTime = Time()
	float endTime = startTime + lerpTime
	ColorCorrection_SetExclusive( colorCorrection, true )

	while ( Time() <= endTime )
	{
		WaitFrame()
		float weight = GraphCapped( Time(), startTime, endTime, startWeight, endWeight )
		ColorCorrection_SetWeight( colorCorrection, weight )
	}

	ColorCorrection_SetWeight( colorCorrection, endWeight )
}

#endif         

