global function MpAbilityRevenantDeathTotem_Init
global function DeathTotem_PlayerCanRecall
global function OnWeaponAttemptOffhandSwitch_ability_revenant_death_totem
global function OnWeaponActivate_ability_revenant_death_totem
global function OnWeaponDeactivate_ability_revenant_death_totem
                         
global function OnWeaponPrimaryAttack_ability_revenant_death_totem
const string ABILITY_USED_MOD = "ability_used_mod"
#if CLIENT
global function OnCreateClientOnlyModel_ability_revenant_death_totem
#endif
      
                       
          
                                  
                                  
      
      
#if SERVER
                                       
                                                  
                                      
                                              
                                             
                                         
                                      
#endif         

const string DEATH_TOTEM_MOVER_SCRIPTNAME = "death_totem_mover"

       
const asset DEATH_TOTEM_TOTEM_MDL = $"mdl/props/revenant_totem/revenant_totem.rmdl"                                                    
const asset DEATH_TOTEM_RADIUS_MDL = $"mdl/weapons_r5/ability_mark_recall/ability_mark_recall_ar_radius.rmdl"

const asset DEATH_TOTEM_RADIUS_FX = $"P_death_totem_init"
const asset DEATH_TOTEM_SHADOW_BODY_FX = $"P_Bshadow_body"
const asset DEATH_TOTEM_SHADOW_MARKER_FX = $"P_death_shadow_marker"
const asset DEATH_TOTEM_SHADOW_RECALL_FX = $"P_death_shadow_recall"
const asset DEATH_TOTEM_SHADOW_EYE_FX = $"P_BShadow_eye"
const asset DEATH_TOTEM_SHADOW_DEATH_FX = $"P_BShadow_death"
const asset DEATH_TOTEM_SHADOW_TIMER_FX = $"P_Bshadow_timer"
const asset DEATH_TOTEM_FX = $"P_death_totem"
const asset DEATH_TOTEM_FLASH_FX = $"P_death_totem_flash"
const asset DEATH_TOTEM_GROUND_FX = $"P_death_totem_ground"

         
const asset DEATH_TOTEM_BASE_MDL = $"mdl/Weapons/sentry_shield/sentry_shield_proj.rmdl"

const float DEATH_TOTEM_DESYNC_WARNING_INTERVAL = 2.0
const float DEATH_TOTEM_DISTORTION_RANGE_MIN_SQR = 2500 * 2500
const float DEATH_TOTEM_DISTORTION_RANGE_MAX_SQR = 3000 * 3000

const float DEATH_TOTEM_OUT_OF_RANGE_DESYNC_TIME = 5.0

            
const float DEATH_TOTEM_TOTEM_HEALTH = 150
global const string DEATH_TOTEM_TARGETNAME = "death_totem"
global const string DEATH_TOTEM_RECALL_SIGNAL = "DeathTotem_DeathTotemed"

                       
const float DEATH_TOTEM_DURATION = 30.0                                                                                                 
const int DEATH_TOTEM_MAX_SHADOW_HEALTH_AMOUNT = 100
const int DEATH_TOTEM_DEATH_PROTECTION_RECALL_REVIVE_HEALTH = 50

const float DEATH_TOTEM_EFFECT_DURATION_DEFAULT = 25.0
const float DEATH_TOTEM_EXPIRATION_WARNING_DELAY = 1.75
const float DEATH_TOTEM_EXPIRATION_WARNING_DELAY_3P = 4.0

const DECOY_FX = $"P_flag_fx_foe"

const float SCREEN_FX_STATUS_EFFECT_DURATION = 0.25
const float SCREEN_FX_STATUS_EFFECT_EASE_OUT_TIME = 0.25

#if CLIENT
const float DEATH_TOTEM_COLOR_CORRECTION_RANGE_MIN_SQR = 2500 * 2500
const float DEATH_TOTEM_COLOR_CORRECTION_RANGE_MAX_SQR = 3000 * 3000
const asset DEATH_TOTEM_TELEPORT_SCREEN_FX = $"P_training_teleport_FP"
const asset DEATH_TOTEM_SHADOW_SCREEN_FX = $"P_Bshadow_screen"
#endif         

const float IDEAL_TOTEM_DISTANCE = 72.0


       
const bool DEATH_TOTEM_DEBUG = false

struct DeathTotemPlacementInfo
{
	vector origin
	vector normal
	entity parentTo
}

struct TotemData
{
	#if SERVER
		                              
	#endif         
	array<entity> markedPlayerArray                                                     
}

struct RecallData
{
	vector origin
	vector angles
	vector velocity
	entity holoMarker
	entity holoRadius
	entity holoRadiusUpper
	entity holoBase
	int    statusEffectID
	bool   wasCrouched
	bool   wasInContextAction
	entity totemProxy
}

struct
{
	#if SERVER
		                                           
	#endif         

	table < entity, TotemData > totemData
	float deathTotemBuffDuration
	bool  showEndOfBuffFX

	#if CLIENT
		bool hasMark = false
		bool hideUsePromptOverride = true
		var  deathProtectionStatusRui
	#endif         
} file

void function MpAbilityRevenantDeathTotem_Init()
{
	PrecacheModel( DEATH_TOTEM_BASE_MDL )
	PrecacheModel( DEATH_TOTEM_RADIUS_MDL )
	PrecacheModel( DEATH_TOTEM_TOTEM_MDL )
	PrecacheParticleSystem( DEATH_TOTEM_FX )
	PrecacheParticleSystem( DEATH_TOTEM_FLASH_FX )
	PrecacheParticleSystem( DEATH_TOTEM_GROUND_FX )
	PrecacheParticleSystem( DEATH_TOTEM_RADIUS_FX )
	PrecacheParticleSystem( DEATH_TOTEM_SHADOW_EYE_FX )
	PrecacheParticleSystem( DEATH_TOTEM_SHADOW_DEATH_FX )
	PrecacheParticleSystem( DEATH_TOTEM_SHADOW_MARKER_FX )
	PrecacheParticleSystem( DEATH_TOTEM_SHADOW_RECALL_FX )
	PrecacheParticleSystem( DEATH_TOTEM_SHADOW_BODY_FX )
	PrecacheParticleSystem( DEATH_TOTEM_SHADOW_TIMER_FX )

	RegisterSignal( "DeathTotem_ChangePlayerStance" )
	RegisterSignal( DEATH_TOTEM_RECALL_SIGNAL )
	RegisterSignal( "DeathTotem_ForceEnd" )
	RegisterSignal( "DeathTotem_Deploy" )
	RegisterSignal( "DeathTotem_EndShadowScreenFx" )
	RegisterSignal( "TotemDestroyed" )
	RegisterSignal( "DeathTotem_PreRecallPlayer" )
	RegisterSignal( "DeathTotem_Cancel" )
	RegisterSignal( "DeathTotem_RemoveWallClimbDisables" )

	#if CLIENT
		PrecacheParticleSystem( DEATH_TOTEM_TELEPORT_SCREEN_FX )
		PrecacheParticleSystem( DEATH_TOTEM_SHADOW_SCREEN_FX )
		StatusEffect_RegisterEnabledCallback( eStatusEffect.death_totem_visual_effect, DeathTotem_StartVisualEffect )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.death_totem_visual_effect, DeathTotem_StopVisualEffect )
		StatusEffect_RegisterEnabledCallback( eStatusEffect.death_totem_recall, DeathTotem_RecallVisualEffect )
		AddCallback_OnPlayerChangedTeam( DeathTotem_ChangedTeamHUDUpdate )
		AddCallback_PlayerClassChanged( DeathTotem_OnPlayerClassChanged )

		AddCreateCallback( "prop_script", DeathTotem_OnTotemCreated )
	#endif         

	file.deathTotemBuffDuration = GetCurrentPlaylistVarFloat( "revenant_totem_buff_duration", DEATH_TOTEM_EFFECT_DURATION_DEFAULT )
	file.showEndOfBuffFX = GetCurrentPlaylistVarBool( "revenant_totem_buff_use_ending_fx", true )
}


bool function OnWeaponAttemptOffhandSwitch_ability_revenant_death_totem( entity weapon )
{
	entity player = weapon.GetWeaponOwner()

	if ( player.IsTraversing() )
		return false

	if ( player.ContextAction_IsActive() )                                                                                                     
		return false

	if ( player.IsPhaseShifted() )
		return false

                     
	if ( HoverVehicle_IsPlayerInAnyVehicle( player ) && !HoverVehicle_PlayerIsDriving( player ) )
		return true

	if ( EntIsHoverVehicle( player.GetGroundEntity() ) )
		return false
                           

	return true
}

                         
#if CLIENT
void function OnCreateClientOnlyModel_ability_revenant_death_totem( entity weapon, entity model, bool validHighlight )
{
	if ( validHighlight )
		DeployableModelHighlight( model )
	else
		DeployableModelInvalidHighlight( model )
}
#endif

var function OnWeaponPrimaryAttack_ability_revenant_death_totem( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	                       
	if ( !weapon.ObjectPlacementHasValidSpot() )
	{
		weapon.DoDryfire()
		return 0
	}

	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )

                          
	bool serverOrPredicted = IsServer() || (InPrediction() && IsFirstTimePredicted())
	if ( serverOrPredicted )
	{
		weapon.AddMod( ABILITY_USED_MOD )
	}
                               

	thread DeathTotem_DisableWallClimbWhileDeployingTotem( ownerPlayer, weapon )

	#if SERVER
	                                                                

		                                                 
		                                                 
		                                                   
		                                                                                                                                                                             

		                        
			                               
	#endif

	return weapon.GetAmmoPerShot()
}

void function DeathTotem_DisableWallClimbWhileDeployingTotem( entity ownerPlayer, entity weapon )
{
	ownerPlayer.EndSignal( "OnDestroy" )
	ownerPlayer.EndSignal( "OnDeath" )
	weapon.EndSignal( "DeathTotem_RemoveWallClimbDisables" )
	weapon.EndSignal( "OnDestroy" )

	int wallClimbID = StatusEffect_AddEndless( ownerPlayer, eStatusEffect.disable_wall_run_and_double_jump, 1.0 )
	int wallHangID = StatusEffect_AddEndless( ownerPlayer, eStatusEffect.disable_automantle_hang, 1.0 )

	OnThreadEnd(
		function() : ( ownerPlayer, wallHangID, wallClimbID )
		{
			if( !IsValid( ownerPlayer ) )
				return

			if( StatusEffect_GetSeverity( ownerPlayer, eStatusEffect.disable_wall_run_and_double_jump ) > 0 )
				StatusEffect_Stop( ownerPlayer, wallClimbID )

			if( StatusEffect_GetSeverity( ownerPlayer, eStatusEffect.disable_automantle_hang ) > 0 )
				StatusEffect_Stop( ownerPlayer, wallHangID )
		}
	)

	WaitForever()
}

      

#if SERVER
                         
                                                                                                   
     
                                                                   
      
 
	                        
		      

	                                   
	                                      
	                                      

                          
		                                            
		                                                                                            
		                                                                           
			                                          
      
                                   
       
	                                         
	                               
	                                            
	                                                                                      
	                               
	                              
	                           
	                                         
	                                         
	                                                  
	                                         
	                                                   
	                                   
	                                        
	                                 
	                                
	                                           
	                           
	                                           

	                                                                                                                                                                         
	                                                                             

	                                          
	                                                    
	                                          
	                                                                                                                         
	                                                                                                                                             
	                                                             

	                                                 	                  

                           
                                                                                 
                      
                                    
                                 
       
	                                    
	                            
	                                
	                          
	 
		                                
	 
	                                                 
	                             
	                                            

	                                                                 
	                               
		                                                  

	            

	                       
	 
		                                                                         
		                           
		                             
	 
	    
	 
		                  
	 

	                                                                                                                                                                                             
                          
		                                                                                                                                                                         
      
                                                                            
                                                                                                                                                                                
       
	                           

	                   
	                   
	                                                                    
	                                         

	            
		                                                       
		 
			                       
			 
				                                                         
				 
					                                                                   
					 
						                                                   
						 
							                                       
						 
					 
				 

				                                                                 
				                               
					                                                     

				                            
				 
					                                                                                    
					                                                                
					                                              
					 
						                                           
					 
					                        
				 

				                    
				 
					                
					                
				 
				                          
				 
					                      
					                      
				 
			 

			                                                  
		 
	 

	                          

                 
                                     
       


	                                                        
	                                                                   
	                                                                            

	                              

	                                                                                                                                                              

	                                                      
	                                                                  
	                                                                           

	                                                                    
	                                                                            
	                                          
	                                   
	                                 
	                                    
	                                                  

	                                                                                                                                             
	                                                             
	                                                                
	                      
	                                                                                                                                                                                                                  
	                                                                              
	                                                                      
	                                                                         

	                           
	                           
	                                                                                     

	                                                   

                    
	                                            
       

	                                                   
	                           
	                                            
	 
		                                                                                    
		                                                                
		                                       
		           
	 
 

                                                                
 
	                                                 
	                                   

	                        

	              
	 
		                                                 
		                               

		                                        
		                                                     

		                                                                                                                                                                         
		                         
		 
			                        
			 
				                                                                    
				                            
			 

			                              
			                        
			 
				                                              

				                                    
				                                          
				                                  
				                                    
				                                              
				                                    
				 
				 
					                               
					 
						                                         
						                       
						 
							                                                          
							                        
							 
								                                                                                                                               
								                          


                                  
                                                         
              
								 
									                                                                                                                                                                                                           
									                                                                                                    
									                                                                                                                                                                  
									                                                                         
								 
							 
							    
							 
								                                                                                                                                                                                        
							 
						 
					 

					                                                     
					     
				 
			 
		 
		    
		 
			                        
				                                                                        
		 

		               
	 
 

                                                                       
 
	            
		                                 
		 
			                       
			 
				               
			 
			                            
			 
				                                   
				                    
			 
		 
	 

	                            
	 
		                                   
		                                         
		                     
		                                                      
		                                                            
		                                                                                                             
		 
			                                                          
			                                                     
		 
		    
		 
			                                                         
			                                                     
		 
		                                           
		                                              
		                                                      
		                              

		                                                            
	 
 

                                                                            
 
	                                                      
	                           
		      

	                                       
	                                     
	                                    

	                                                                    
	 
		                                         
		      
	 

	                                                        
	                            
		      

	                                                                       
	                                       
	                                                                                                       
	 
		                                         
		      
	 
 

                                                                                
 
	                                                      
	                           
		      

	                                   
	                                    

	                                                      
	                  
		      

	                                   
	                      
	 
		                                         
		                         
		                                         

		                                            
		 
			                                                                   
		 
		                             
		 
			                                                                      
			                               
			 
				                          
				                                                                               
			 
		 


		                                     
	 

	                                                              
	                                                        
	 
		                                                                                                 
			                                                                
			                                                                                                                            
	 
 

                                                                 
 
	                                           
	 
		                                             
		                                        

		                                         
	 

	                                                 
 

                                                      
 
	                                                                                                    
	                               
	                                            
	                                                              
	                                                                  
	                                                                  
	                                                                   
	                                                                  
	                                                
	                                                                                                    

	                                                                                                               
	                                  

	                                         
	                                      
	 
		                                           
		 
			                 
			                                     
		 
	 

	                                 

	                                                                                                      

	                                                                                         
	                                                                                                            
	                                                                 


	                                           
	                                          
	                                                              
	                                           

                 
		                                        
		                                                                                                       
			                                             
       

	                                       
	                                             
	                                                                                                   

	                                                                             
		                                              

	                                                                                                     

	                                         
	 
		                            
	 

	                               
		                      

	                                           

	                                                    

	                  
	 
		                                        
		                                                                                                                       

	 
	    
	 
		                                       
		                                                                                    
	 

	                                          
	                        
	 
		                                                              
		                                                         
		                                                          
	 

	                                                                                                                       


	                                                                            
	                                        
	 
		                                         
		                                                                                                          
		                                                                                                                                                                                                     
	 

	                        
	 
		                                         
		                                                                                
		                                                                 
		                                                                           

	 

	                                

	                             

	                                                                                             
	                                                                                                 
	                                                                                               

	                                                 
		                                                                                                           

	                                                                                                                                               
	                                                                          

	                                   
	                                                                                                      
	                                          

	                                                          

	                          
	                                   
 

                                                                        
 
	                                

	            
		                       
		 
			                        
				                          
		 
	 

	                        

	                                     
 

                                                                                                     
 
	                                                                                                        
	                                
	                           
	                                       

	                                                                                                                                                                               
	                                                                                           

	        

	                    
	                                                         

	             

	               
	               
 

                                                             
 
	                                                                                                                                                       

	                                                           
	                                     

	                                                            
	                                   
	 
		                                                                     
		                                                  
	 

	                                                            
	                            
		                      
	                                                            
	                            
		                    
	                                                                      
	                                 
		                         
	                                                        
	                          
		                  

	                                    
 

                                                                                                         
 
	                             

	                           
	                                                                                                        
	                                  
	                        
	                     
	                                    
	                        
	                             
	                      
	                                                   
	                             

	                                      

	                                                                                                
	                         
	                       
	                                                    
	                      
	           

	                                                                                                                                                              
	                                                                                       
		                                     

	                                                   
	                                                  
	                                                        
	                                                       
	                                                                                                  
	                           
	                             
	                                         

	                                                                                                                        
	                                        

	                           
	                                                                                                                               
	                                              
	                                 
	                             
	                                  

	                                                       
	                                                             
	                                                            
	                                                                                                       
	                                
	                                  
	                                              

	                                                                                                                        
	                                             

	                                
	                                                                                                                               
	                                                   
	                                        
	                                  
	                                       

	                                                                              
	 
		                                                                                                                  
	 
	    
	 
		                 
		                      
	 

	                       
	                            
	                                      
	                    
 

                                                                  
 
	                                    
	                                  
	                                    
	                                       
	                                    
	                           
	                                                                 
	                                            
	                         
	                                  
	                                          
	                             

	                                  
	                                                  

	                                                                
	                                                             
	                                                                    
	                                   

	                                                     

	                                      
	                          
	 
		                         

		                           
		                           
		                                  
		 
			                          
			 
				                
				                     
				     
			 

			                 
			 
				                     
				     
			 
		 

		                                         
		                                                                                 
		 
			                                                                              
			                                                   
			                                                                

			                                                     
		 

		                                  
	 

	                                                                                                                                                                              

	                                                        
	                              
	                                 
 

                                                                            
                                                                                    
 
	                                                 
	                               
	                             
	                                             
	                                         
	                                   

	                        
	                                                                                                           
	                                      
	                                                                                 
	                                    
		                                

	                                         
	                            
	 
		                                           
	 

	                                                                                       

	                                       

	              
	                                                                                                                                                                                    
	                                                                                 
	                          

	               
	                                             
	 
		                                                                                                                                                                               
		                                                                                  
		                           
	 

	               
	                                             
	 
		                                                                                                                                                                               
		                                                                                  
		                           
	 

	                                                                                               
	                                                                                                  
	                                                                                       

	            
		                                                    
		 
			                         
			 
				                     
				                     
			 
			                          
			 
				                      
				                      
			 
			                          
			 
				                      
				                      
			 
			                        
			 
				                                        

				                                    
				 
					                                        
				 

				                                                                 
				                                                                       
				                                                                                            
				                        
				                                                                                          
				                                      
			 
		 
	 
	                                                                                                       
	                                                                                                    
	                              

	                           
	 
		                                                                                                                                                                                             
		                                                   
		                           
		                                                                                    

		                                                                                    

		            
			                         
			 
				                          
				 
					                      
					                      
				 
			 
		 
	 

	                                                                                   

	                                                                                                                                       
	                                         
 



          
                                                            
 
	                                              
	                                            
	                                             
	                                                                                        
	                                                                                                           
	                                   

	                                      
	                                               
	                                      

	                                
 
               


          
                                                     
 
	                                                        
	                  
	 
		                         
		                   
	 
	                                                                     
	 
		                                 
	 
 
               



          
                                                             
 
	                                                                                        
	                                                          
	                                                                        

	                                       
	                                   
 
               

                                                      
 
	                                                 
	                                                 
	                              
	                                                    
	                       
	                                                                      
	            
		                                          
		 
			                        
			 
				                        
				                                              
			 
		 
	 
	        
 

                                                     
 
	                                                 
	                                                 
	                              
	                                                    
	                   
	                                                                    
	            
		                                         
		 
			                        
			 
				                     
				                                             
			 
		 
	 
	        
 



                                                                                    
 
	                                                 

	                             
	                               
	                                             
	                                         
	                                   

	                              

	            
		                       
		 
			                        
				                                                                      
		 
	 

	                         
	              
	 
		           
		                                                      
		                                                      
		                                                                                     

		                                                      
		 
			                    
			 
				                                                                                       
				                   
			 

			                                                      
			                                                                       
			                                                                                                                                                                
			                                            
			 
				                                      
			 
		 
		    
		 
			                        
			                                                                   
			                    
		 
	 
 

                                                                          
 
	                            
	                                               

	                                         
	                  
	                                                                                                                                                                             
	 
		                                                                                                                                                                                
		                                                        
	 

	            
		                                           
		 
			                             
				                     

			                               
				                       
		 
	 

	             
 

#endif          

void function DeathTotem_UseTotem( entity player, entity totemProxy )
{
	if ( !DeathTotem_PlayerCanRecall( player ) )
	{
		DeathTotem_MarkLocation( player, totemProxy )
	}
}


void function DeathTotem_MarkLocation( entity player, entity totemProxy )
{
	Assert( !DeathTotem_PlayerCanRecall( player ), "Player already has marked location." )

	int statusEffectID = StatusEffect_AddTimed( player, eStatusEffect.death_totem_visual_effect, 1.0, file.deathTotemBuffDuration, 0.0 )

	#if SERVER
		                          
			                      

		                                                                     
		                                                                                                     
		                                             

		               
		                                
		                                
		                                    
		                                      
		                                                         
		                                    
		                            
		                                                                  
		                                     

		                        
		 
			                                                                                             
			                                                                                                                      
		 

		                                                               
	#endif          
}


bool function DeathTotem_PlayerCanRecall( entity player )
{
	bool canRecall = false
	#if SERVER
		                                                                
	#else
		canRecall = file.hasMark && IsAlive( player )
	#endif         

	return canRecall
}


bool function DeathTotem_CanUseTotem( entity player, entity ent, int useFlags )
{
	if ( !IsValid( player ) )
		return false

	if ( DeathTotem_PlayerCanRecall( player ) )
		return false

	if ( Bleedout_IsBleedingOut( player ) )
		return false

	if ( player.IsPhaseShifted() )
		return false

	array <entity> activeWeapons = player.GetAllActiveWeapons()
	if ( activeWeapons.len() == 1 )
	{
		entity activeWeapon = activeWeapons[0]
		if ( IsValid( activeWeapon ) )
		{
			if ( activeWeapon.GetWeaponTypeFlags() & WPT_CONSUMABLE )
				return false
		}
	}

	return true
}


void function DeathTotem_OnTotemUse( entity totemProxy, entity player, int useInputFlags )
{
	if ( useInputFlags & USE_INPUT_DEFAULT )
	{
		bool canPlayerRecall = DeathTotem_PlayerCanRecall( player )

		                                                                                       
		if ( file.totemData[ totemProxy ].markedPlayerArray.contains( player ) && !canPlayerRecall )
			return

		if ( !canPlayerRecall )
		{
			file.totemData[ totemProxy ].markedPlayerArray.append( player )
		}

		DeathTotem_UseTotem( player, totemProxy )

		#if CLIENT
			thread HideUsePromptOverrideThink( player )
		#endif
	}
}

#if CLIENT
                                                                                                                                                                      
void function HideUsePromptOverrideThink( entity player )
{
	player.EndSignal( "OnDestroy" )

	file.hideUsePromptOverride = true

	wait 2.0

	file.hideUsePromptOverride = false
}

void function DeathTotem_OnTotemCreated( entity ent )
{
	if ( ent.GetTargetName() == DEATH_TOTEM_TARGETNAME )
	{
		                   
		TotemData totemData
		file.totemData[ ent ] <- totemData

		SetCallback_CanUseEntityCallback( ent, DeathTotem_CanUseTotem )
		AddCallback_OnUseEntity_ClientServer( ent, DeathTotem_OnTotemUse )
		AddEntityCallback_GetUseEntOverrideText( ent, DeathTotem_UseTextOverride )
		AddEntityDestroyedCallback( ent, DeathTotem_OnTotemDestroyed )
	}
}

string function DeathTotem_UseTextOverride( entity ent )
{
	entity player = GetLocalViewPlayer()
	if ( DeathTotem_PlayerCanRecall( player ) )
	{
		return ""
	}
	else
	{
		if ( file.hideUsePromptOverride )
			return ""
		else if ( file.totemData[ ent ].markedPlayerArray.contains( player ) )
			return "#DEATH_TOTEM_TOTEM_USED"
		else
			return "#DEATH_TOTEM_TOTEM_USE"
	}

	return ""
}

void function DeathTotem_OnTotemDestroyed( entity totem )
{
	                                                                                                                                                  
	                                                                                                                                          
	if ( IsValid( totem ) && totem.GetBossPlayer() == GetLocalViewPlayer() )
		UltimateWeaponStateSet( eUltimateState.CHARGING )
}

                       
                                              
 
                                                               
                                                             
                                                                                  
                                                                                                                                           
                                                                                                                                                   
 

                                  
 
                                                                
 
      

void function DeathTotem_StartVisualEffect( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged )
		return

	RefreshTeamDeathTotemHUD()

	if ( ent != GetLocalViewPlayer() )
		return

	if ( !IsValid( ent ) )
		return

	                                                            

	file.hasMark = true
	file.deathProtectionStatusRui = CreateFullscreenRui( $"ui/death_protection_status.rpak" )

                        
                                                                       
   
                       
   
                                                                               
   
                            
   
      
   
                                                                                           
                                                                                                                                                        
                                                                                                                                                     
   
      
		RuiSetFloat( file.deathProtectionStatusRui, "maxDuration", file.deathTotemBuffDuration )
		RuiTrackFloat( file.deathProtectionStatusRui, "timeRemaining", ent, RUI_TRACK_STATUS_EFFECT_TIME_REMAINING, eStatusEffect.death_totem_visual_effect )
		RuiTrackInt( file.deathProtectionStatusRui, "gameState", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "gameState" ) )
                             


	entity cockpit = ent.GetCockpit()
	if ( !IsValid( cockpit ) )
		return

	thread ShadowScreenFXThink( ent, cockpit )
}

void function DeathTotem_OnPlayerClassChanged( entity player )
{
	RefreshTeamDeathTotemHUD()
}

void function DeathTotem_ChangedTeamHUDUpdate( entity player, int oldTeam, int newTeam )
{
	RefreshTeamDeathTotemHUD()
}

void function RefreshTeamDeathTotemHUD()
{
	entity localViewPlayer  = GetLocalViewPlayer()
	array<entity> teammates = GetPlayerArrayOfTeam( localViewPlayer.GetTeam() )
	foreach ( ent in teammates )
	{
		if ( StatusEffect_GetSeverity( ent, eStatusEffect.death_totem_visual_effect ) == 0.0 )
			continue

		if ( ent == localViewPlayer )
		{
			SetCustomPlayerInfoShadowFormState( localViewPlayer, true )
			SetCustomPlayerInfoColor( localViewPlayer, <245, 81, 35 > )
		}
		else
		{
			SetUnitFrameShadowFormState( ent, true )
			SetUnitFrameCustomColor( ent, <245, 81, 35 > )
		}
	}
}

void function DeathTotem_StopVisualEffect( entity ent, int statusEffect, bool actuallyChanged )
{
	                         
	  	      

	entity localViewPlayer = GetLocalViewPlayer()

	if ( !IsValid( localViewPlayer ) )
		return

	if ( localViewPlayer.GetTeam() == ent.GetTeam() )
	{
		if ( ent == localViewPlayer )
		{
			SetCustomPlayerInfoShadowFormState( localViewPlayer, false )
			ClearCustomPlayerInfoColor( localViewPlayer )
		}
		else
		{
			SetUnitFrameShadowFormState( ent, false )
			ClearUnitFrameCustomColor( ent )
		}
	}

	if ( ent != GetLocalViewPlayer() )
		return

	                                                             
	if ( file.deathProtectionStatusRui != null )
		RuiDestroyIfAlive( file.deathProtectionStatusRui )
	file.deathProtectionStatusRui = null

	file.hasMark = false
	ent.Signal( "DeathTotem_EndShadowScreenFx" )
}

void function ShadowScreenFXThink( entity player, entity cockpit )
{
	player.EndSignal( "OnDeath" )
	cockpit.EndSignal( "OnDestroy" )

	int fxHandle = StartParticleEffectOnEntity( cockpit, GetParticleSystemIndex( DEATH_TOTEM_SHADOW_SCREEN_FX ), FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID )
	EffectSetIsWithCockpit( fxHandle, true )
	vector controlPoint = <1, 1, 1>
	EffectSetControlPointVector( fxHandle, 1, controlPoint )

	EmitSoundOnEntity( player, "DeathProtection_Activate_1p" )                       
	EmitSoundOnEntity( player, "DeathProtection_Loop_1p" )                     

	player.WaitSignal( "DeathTotem_EndShadowScreenFx" )

	StopSoundOnEntity( player, "DeathProtection_Loop_1p" )
	EmitSoundOnEntity( player, "DeathProtection_End_1p" )                
	if ( EffectDoesExist( fxHandle ) )
		EffectStop( fxHandle, false, true )
}

void function DeathTotem_RecallVisualEffect( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged )
		return

	if ( ent != GetLocalViewPlayer() )
		return

	thread DeathTotem_PlayRecallScreenFX( ent )
}

void function DeathTotem_PlayRecallScreenFX( entity clientPlayer )
{
	Assert ( IsNewThread(), "Must be threaded off." )
	clientPlayer.EndSignal( "OnDeath" )
	clientPlayer.EndSignal( "OnDestroy" )

	entity player = GetLocalViewPlayer()
	int indexD    = GetParticleSystemIndex( DEATH_TOTEM_TELEPORT_SCREEN_FX )
	int fxID      = -1

	if ( IsValid( player.GetCockpit() ) )
	{
		fxID = StartParticleEffectOnEntityWithPos( player, indexD, FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID, player.EyePosition(), <0, 0, 0> )
		EffectSetIsWithCockpit( fxID, true )
		EffectSetControlPointVector( fxID, 1, <1.0, 999, 0> )
	}

	OnThreadEnd(
		function() : ( clientPlayer, fxID )
		{
			if ( IsValid( clientPlayer ) )
			{
				if ( fxID > -1 )
				{
					EffectStop( fxID, false, true )
				}
			}
		}
	)

	wait 0.25
}
#endif         

void function OnWeaponActivate_ability_revenant_death_totem( entity weapon )
{
	entity weaponOwner = weapon.GetWeaponOwner()

                          
	bool serverOrPredicted = IsServer() || (InPrediction() && IsFirstTimePredicted())
	if ( serverOrPredicted )
	{
		weapon.RemoveMod( ABILITY_USED_MOD )
	}
       

	#if SERVER
		                                                                              
                            
                                                       
        
		                                                     
		                           
	#endif

#if CLIENT
	if ( weaponOwner == GetLocalViewPlayer() )
#endif
	{
		PlayerUsedOffhand( weaponOwner, weapon )
	}
}


void function OnWeaponDeactivate_ability_revenant_death_totem( entity weapon )
{
                          
           
                             
                                        
      
                                                        
                                        
       
     
	weapon.Signal( "DeathTotem_RemoveWallClimbDisables" )
      
}


#if SERVER
                                                        
 
	                                    
 
#endif


                                                                                                            
DeathTotemPlacementInfo function CalculateDeathTotemPosition( entity weaponOwner, entity totemProxy )
{
	vector startPos   = weaponOwner.GetWorldSpaceCenter()
	vector viewVector = weaponOwner.GetViewVector()
	if ( viewVector.z >= 0 )
		viewVector = FlattenVec( viewVector )

	vector upVector      = weaponOwner.GetUpVector()
	vector downVector    = upVector * - 1
	vector forwardVector = weaponOwner.GetForwardVector()
	float dot            = downVector.Dot( viewVector )
	float angle          = DotToAngle( dot )
	float idealDistance  = IDEAL_TOTEM_DISTANCE
	vector velocity      = weaponOwner.GetVelocity()
	float velocityDot    = forwardVector.Dot( weaponOwner.GetVelocity() )
	if ( velocityDot > 0 )
		idealDistance += GraphCapped( velocityDot, 0, 300, 0, IDEAL_TOTEM_DISTANCE * 2 )
	float height   = startPos.z - weaponOwner.GetOrigin().z
	float maxAngle = RAD_TO_DEG * atan( idealDistance / height )
	if ( angle > maxAngle )
	{
		viewVector = ClampViewVectorToMaxAngle( downVector, viewVector, maxAngle )
		angle = maxAngle
	}
	float magnitude           = idealDistance / deg_sin( angle )
	                                                                                                                                                  
	vector totemBoundMins = totemProxy.GetBoundingMins()
	vector totemBoundMaxs = totemProxy.GetBoundingMaxs()
	float rx = totemBoundMaxs.x - totemBoundMins.x
	float ry = totemBoundMaxs.y - totemBoundMins.y
	float diameter = max( rx, ry )
	float dx = (diameter - rx) * 0.5
	float dy = (diameter - ry) * 0.5
	totemBoundMins = < totemBoundMins.x - dx, totemBoundMins.y - dy, totemBoundMins.z >
	totemBoundMaxs = < totemBoundMaxs.x + dx, totemBoundMaxs.y + dy, totemBoundMaxs.z >

	TraceResults traceResults = TraceHull( startPos, startPos + viewVector * magnitude, totemBoundMins, totemBoundMaxs, [weaponOwner, totemProxy], TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER )
	                                                                          
	bool isUpwardSlope        = (IsValid( traceResults.hitEnt ) && traceResults.hitEnt.IsWorld()) && forwardVector.Dot( traceResults.surfaceNormal ) < -0.05
	if ( isUpwardSlope )
	{
		float slopeAngle   = 180 - RAD_TO_DEG * acos( forwardVector.Dot( traceResults.surfaceNormal ) )
		vector slopeVector = ClampViewVectorToMaxAngle( upVector, viewVector, angle )
		traceResults = TraceHull( startPos, startPos + slopeVector * magnitude, totemBoundMins, totemBoundMaxs, [weaponOwner, totemProxy], TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER )
		                                                                         
	}
	TraceResults traceResultsDown = TraceLine( traceResults.endPos, traceResults.endPos + <0, 0, -150>, [weaponOwner, totemProxy], TRACE_MASK_SOLID_BRUSHONLY, TRACE_COLLISION_GROUP_NONE )
	                                                                                                                                                                                                                       
	                                                                                                                                                                                                                                   

	DeathTotemPlacementInfo info
	if ( traceResultsDown.hitEnt == null )
	{
		info.origin = weaponOwner.GetOrigin() + forwardVector * 20
		info.parentTo = null
		info.normal = <0, 0, 0>
	}
	else
	{
		                                                                            
		info.origin = traceResultsDown.endPos
		info.parentTo = null
		info.normal = traceResultsDown.surfaceNormal
	}

	DeployableCollisionParams params
	params.hitEnt = traceResultsDown.hitEnt
	params.normal = traceResultsDown.surfaceNormal
	if ( EntityShouldStickEx( totemProxy, params ) && !traceResultsDown.hitEnt.IsWorld() )
		info.parentTo = traceResultsDown.hitEnt

	return info
}


vector function ClampViewVectorToMaxAngle( vector vec1, vector vec2, float angle )
{
	vector perpendicularVector = CrossProduct( CrossProduct( vec1, vec2 ), vec1 )
	perpendicularVector.Normalize()
	vector newVector = vec1 * deg_cos( angle ) + perpendicularVector * deg_sin( angle )
	return newVector
}