global function MpAbilityValkSkyward_Init
global function OnWeaponAttemptOffhandSwitch_ability_valk_skyward
global function OnWeaponPrimaryAttack_ability_valk_skyward
global function OnWeaponActivate_ability_valk_skyward
global function OnWeaponDeactivate_ability_valk_skyward


#if CLIENT
global function ServerToClient_PlayPleaseWaitSound
global function UpdateValkFlightRui
global function DestroyValkLaunchRui
global function ServerToClient_ValkUltCanceled
global function ServerToClient_SetSkydiveAfterUlt
global function ServerToClient_RemoveFromPlayersWaiting
global function ClientCodeCallback_OnSkywardLaunchStateChanged
#endif

global function ValkUlt_Canceled_ClearOffhand
global function ValkUlt_Canceled_Keypress_Wrapper

global function ValkUlt_AllyCancel

global function GetValkUltMaxHeight

global function CodeCallback_PlayerSkywardDeployBegin
global function CodeCallback_PlayerSkywardLaunchBegin
global function CodeCallback_PlayerSkywardLaunchEnd

const asset SKYWARD_JUMPJETS_FRIENDLY = $"P_valk_jet_fly_ON"
const asset SKYWARD_JUMPJETS_ENEMY = $"P_valk_jet_fly_ON"
const asset SKYWARD_AFTERBURNER_FX = $"P_valk_launch_eng"
const asset SKYWARD_RADIUS_FX = $"P_radius_marker"
const float SKYWARD_LAUNCH_TIME = 5.0
const float SKYWARD_LAUNCH_TIME_ARENAS = 2.0
const float SKYWARD_LAUNCH_SLOW_TIME = 1.83
const float SKYWARD_LAUNCH_SLOW_TIME_ARENAS = 0.67
const float SKYWARD_TEAMMATE_ALIGN_TIME = 1


const float SKYWARD_ALLY_USE_DEBOUNCE_TIME = 1
const float SKYWARD_VALK_USE_DEBOUNCE_TIME = 0.5

const float SKYWARD_RADIUS = 300.0
const float SKYWARD_MAX_HEIGHT = 4500
const float SKYWARD_MAX_HEIGHT_ARENAS = 1800

const float SKYWARD_WAIT_TIME_BEFORE_LAUNCH = 2.0

const float SKYWARD_TRANSITION_TIME = 1.2
const float SKYWARD_TRANSITIOIN_SPEED_SCALE = 0.5

const string SKYWARD_PROXY_SCRIPT_NAME = "valk_ult_proxy"

const asset VALK_SKYWARD_USE_MODEL = $"mdl/humans_r5/pilots_r5/pilot_valkyrie/invisible_prop.rmdl"

                                                                                                                                          

const array<vector> attachPositions = [<-10, -50, -40>, <-10, 50, -40>, <-20, 50, -60>, <-20, -50, -60>]

struct
{
	#if CLIENT
		var countdownRui
		var launchRui
		var flightRui
	#endif
	float                 ultStartTime
	table<entity, bool>   isInLaunchingState
	table<entity, float>	 valkUltDebounce


	#if SERVER
		                                 
		                                   
		                                     
		                                              
		                  		                    
	#endif

} file

void function MpAbilityValkSkyward_Init()
{
	PrecacheParticleSystem( SKYWARD_JUMPJETS_FRIENDLY )
	PrecacheParticleSystem( SKYWARD_JUMPJETS_ENEMY )
	PrecacheParticleSystem( SKYWARD_AFTERBURNER_FX )
	PrecacheParticleSystem( SKYWARD_RADIUS_FX )
	PrecacheParticleSystem( $"P_valk_launch_engage" )
	PrecacheParticleSystem( $"P_valk_launch_eng" )

	PrecacheModel( VALK_SKYWARD_USE_MODEL )

	PrecacheMaterial( $"models/cable/valk_team_cable" )

	RegisterSignal( "OnSkywardLaunched" )
	RegisterSignal( "OnSkywardCanceled" )
	RegisterSignal( "OnSkywardDone" )
	RegisterSignal( "AllyCanceledSkyward" )
	RegisterSignal( "ValkUltAllyLaunchFinished" )
	RegisterSignal( "OnSkywardInterrupted" )

	                                                                                                                                   
	RegisterSignal( "OnSkywardDeployStateEnd" )

	Remote_RegisterClientFunction( "ServerToClient_PlayPleaseWaitSound", "entity" )
	Remote_RegisterClientFunction( "ServerToClient_ValkUltCanceled", "entity" )
	Remote_RegisterClientFunction( "ServerToClient_SetSkydiveAfterUlt", "entity", "bool" )
	Remote_RegisterClientFunction( "ServerToClient_RemoveFromPlayersWaiting", "entity", "entity" )


	#if SERVER
		                                                             
		                                                        
		                                                        
	#else
		StatusEffect_RegisterEnabledCallback( eStatusEffect.skyward_embark, ValkUlt_ShowEmbarkUI )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.skyward_embark, ValkUlt_DestroyEmbarkUI )
		AddCreateCallback( "prop_script", OnPropScriptCreated )
		AddCallback_PlayerClassChanged( OnPlayerClassChanged )
		AddOnSpectatorTargetChangedCallback( OnSpectatorTargetChanged )
	#endif

	AddCallback_GameStateEnter( eGameState.Resolution, ValkUlt_EnterGameStateResolution)
}

void function OnSpectatorTargetChanged( entity player, entity prevTarget, entity newTarget )
{
	if ( player.GetTeam() != TEAM_SPECTATOR )
		return

	if ( IsValid( newTarget ) && PlayerHasPassive( newTarget, ePassives.PAS_VALK ) )
	{
		bool isPlayerInAir = newTarget.Player_IsSkydiving() || StatusEffect_GetSeverity( newTarget, eStatusEffect.skyward_embark ) > 0.0
		UpdateValkFlightRui( newTarget, isPlayerInAir )
	}
	else if ( IsValid( prevTarget ) && PlayerHasPassive( prevTarget, ePassives.PAS_VALK ) )
	{
		UpdateValkFlightRui( newTarget, false );
	}
}

                                                
void function OnPlayerClassChanged( entity player )
{
#if CLIENT
	if ( player != GetLocalViewPlayer() )
		return

	                                                                                    
	if ( !player.Player_IsSkydiving() )
		UpdateValkFlightRui( player, false )
#endif

	#if SERVER
		                                                     
		 
			                                          
				                                    

			                                             
				                                       
		 
	#endif

}


                                      
void function OnPostTakeDamage( entity owner, var damageInfo )
{
	if ( !IsThisPlayerInDeployState( owner ) )
		return

	#if SERVER
		                                                      
		                                                                             
		 
			                              
			 
				                                      
			 
			    
			 
				                                     
			 
		 
	#endif
}


bool function OnWeaponAttemptOffhandSwitch_ability_valk_skyward( entity weapon )
{
	entity owner = weapon.GetWeaponOwner()
	entity tactical = owner.GetOffhandWeapon( OFFHAND_TACTICAL )

	#if CLIENT
		if ( !PlayerHasPassive( owner, ePassives.PAS_VALK ) )
			return false

	#endif

	table<string, float> launchParams = Helper_GetLaunchParams()
	float fastUpSpeed     = (launchParams["totalUpDistance"] - launchParams["slowUpDistance"]) / launchParams["fastUpTime"]
	float transitionDist = fastUpSpeed * SKYWARD_TRANSITION_TIME * SKYWARD_TRANSITIOIN_SPEED_SCALE

	float traceDist      = GetValkUltMaxHeight() + 40 + transitionDist                                            

	TraceResults results = TraceHull( owner.GetOrigin(), owner.GetOrigin() + <0, 0, traceDist>, owner.GetPlayerMins(), owner.GetPlayerMaxs(), [ owner ], TRACE_MASK_PLAYERSOLID_BRUSHONLY , TRACE_COLLISION_GROUP_PLAYER_MOVEMENT )
	if ( results.fraction < 1.0 )	
	{

		if( IsValid( tactical ) && !tactical.IsBurstFireInProgress() )
		{
			owner.CancelOffhandWeapon( OFFHAND_TACTICAL )
		}

		#if CLIENT
			ValkUlt_ClearanceFailed( owner )
		#endif
		return false
	}

                 
		if ( GondolasAreActive() && IsPlayerInsideGondola( owner ) )
		{
			if( IsValid( tactical ) && !tactical.IsBurstFireInProgress() )
			{
				owner.CancelOffhandWeapon( OFFHAND_TACTICAL )
			}

			#if CLIENT
				ValkUlt_ClearanceFailed( owner )
			#endif
			return false
		}
       

	bool blockBecauseDebounce = false

	                                     
	if (owner in file.valkUltDebounce)
	{
		if (Time() < file.valkUltDebounce[owner] + SKYWARD_VALK_USE_DEBOUNCE_TIME)
		{
			blockBecauseDebounce = true
		}
	}

	if (blockBecauseDebounce)
		return false

	if (!owner.Player_IsSkywardLaunching())
	{
		file.valkUltDebounce[owner] <- Time()
	}

	                                            
	if ( tactical.IsBurstFireInProgress() )
		return false

	if ( owner.IsPhaseShifted() )
		return false

	if (HoverVehicle_IsPlayerInAnyVehicle(owner))
		return false

	if ( !owner.IsOnGround() )
		return false

	if ( owner.IsZiplining() )
		return false

	if ( StatusEffect_GetSeverity( owner, eStatusEffect.in_olympus_rift ) > 0.0 )
		return false

	if ( StatusEffect_GetSeverity( owner, eStatusEffect.in_black_hole_field ) > 0.0 )
		return false

	if ( owner.IsSlipping() )
		return false

	if( owner.Player_IsSkywardLaunching() )
		return false

	return true
}


#if CLIENT
void function ValkUlt_ClearanceFailed( entity player )
{
	AddPlayerHint( 1.0, 0.25, $"rui/hud/ultimate_icons/ultimate_valk", "#SKYWARD_CLEARANCE_FAIL" )
	EmitSoundOnEntity( player, "Valk_Hover_VerticalClearanceWarning_1P" )
}
#endif


void function OnWeaponActivate_ability_valk_skyward( entity weapon )
{
	entity owner = weapon.GetWeaponOwner()

                           
                     
           
                       
       
                                                       
      
	owner.Player_DeploySkywardLaunch( 20, 2.0 )


	#if SERVER
		                                                        
	#endif

	#if CLIENT
		if ( owner == GetLocalViewPlayer() )
		{
			weapon.w.valkAlliesWaitingForLaunch.clear()
			Rumble_Play( "rumble_stim_activate", {} )
		}

	#endif
}


void function OnWeaponDeactivate_ability_valk_skyward( entity weapon )
{
	entity owner = weapon.GetWeaponOwner()

	                                                                                                    
	                        

	Assert( owner.IsPlayer() )

	#if CLIENT
		if ( owner != GetLocalViewPlayer() )
			return
	#endif

	ValkUlt_Canceled( owner )

	                         
	   
	  	                                         
	  		                         
	   
}


var function OnWeaponPrimaryAttack_ability_valk_skyward( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity owner = weapon.GetWeaponOwner()

	if ( Time() < weapon.w.valkUltStartTime + SKYWARD_WAIT_TIME_BEFORE_LAUNCH )
	{
		#if SERVER
			                                             
			 
				                                           
			 

			                                                        
			 
				                                                                                   
			 

			                                          

		#endif
		return false

	}
	else
	{
		weapon.w.valkUltStartTime = Time()
	}
	                           
	{
		table<string, float> launchParams = Helper_GetLaunchParams()

		float totalUpTime     = launchParams["totalUpTime"]
		float slowUpTime      = launchParams["slowUpTime"]
		float fastUpTime      = launchParams["fastUpTime"]
		float totalUpDistance = launchParams["totalUpDistance"]
		float slowUpDistance  = launchParams["slowUpDistance"]

		if ( IsValid( owner ) )
		{
			                                                                                            
			                                                                                        
			owner.Player_BeginSkywardLaunch( slowUpDistance / slowUpTime, slowUpTime, (totalUpDistance - slowUpDistance) / fastUpTime, fastUpTime )
		}
	}

	PlayerUsedOffhand( owner, weapon )
	return weapon.GetAmmoPerShot()

}

                                                                                                                           
#if SERVER
                                                                            
 
	                         

	                     
	                    
	                     
	                          
	                   
	                                                                                               

	                                                           
	                                      
	                                    
	                                                                                       
	                                 

	             
	                                       
	 
		                                                                     
		                                                                 
	 

	                       
	                             
	                                                                  
	 
		                                                         
	 

	                                                              
	                                           
	                              

	                                                                                    
	                                                                  


	                                                                  
	 
		                                                   
		                           
		                                                              
		                                           
		                                         
		                                                 
		                                 
		                                
		                                   
		                                  
		                                          
		                                     
		                                                              
		                               
	 
	                                                              

	                                     


	                                                          
	 
		                                                                                                   

		                                                   
		                              
		                                        
		                    
		                                    
		               
		                          
		                         
		                                                                                                                               
		                                 

		                                                                
		                                                                 
	 

	                   
	                                  

	                                                  
	 
		                                                                                    
		                                                  
	 

	                     
	                      
	                                  

	            
		                        
		 
			                                                                                                     
			                     
			 
				                              
				                                                                             

				                                                                        
				                                        
				                                                                 
				 
					                                                            
				 
				                                                                                          
				                                                                                                
				                                                                                              

				                                                    

				                                        
				                          
					                  

				                                                                  
				                                                                
			 

			                                                                 
			                                     


			                                                                                                                           
			                                       
			 
				                              
			 

			                                                               
			                    
			 
				                                                     
				                                                      
			 
			                                
			 
				                                                                
				                                                                                                      

				                                                                 
			 
			    
			 
				                         
				                               

				                                                                               
				                                                                               
				                                    
				                                                                                       
			 
		 
	 
	                                                               
	                                                                          
	                                       

	                                                                                                                                                  

	                                                                                                                                               

	                             
	                                    
	                                    

	                                                      
	                                                                                      
	                                   

	                                                 
	                                                                                           
	 
		                                        
		                           
		                                        

		                                                                 
		 
			                                                            
		 
		                                                                                          
		                                                                                                
		                                                                                              

		                                        
		                          
			                  

		                                                                  
		                                                                
	 

	                                            
	                                 
	                                
	                                  
	                                 

	                                                          
	                                

	                        
	                                                  
	                                          
	                                          

	                                                                      
	                                           

	     
	                                                                      

	                        
	                                                                                        
	                           
	                                                                      

	                                                                                                                  
	                                      
	                                             

	                                                                       
	                                                         
	                                                       
	                                                      
	                                                                         
	                                                                     

	                                                              
	                  
	                                                
	 
		                         
			        

		                                                                    
		 
			                  
		 
		    
		 
			                  
		 
		                                                                                              
	 

	                                                   
	                

	                                                                     
	                                                                       
	                                                                                                   
	                                                    

	                                                     
	                                                                                                                                                                                   
	                             
	                                                                                                                                           
	                             

	                                                     
	                                   
	                                

	                                 
 
#endif

                                                                                                
#if SERVER
                                             
 
	                                                                                                                               
	                                     
	                                          
 

                                                                                         
 
	                         
	                                                                      
	                                      

	                                                                                
	                                                                                  

	                      
	                             
	                               
	                                      
	                                    
	                                                                                       

	                     
	                      
	                                  
	                            

	                
	                                     

	                                                                                                                                                        
	                                  
	                                                                                      
	                                                                                                                                       
	                                                     
	 
		                                               
	 
	                                                           
	 
		                                            
	 

	                                          
	                                                                                                 

	                            
	                  
	                                                          
		                                 

	                                                         
		                                                    

	                              
	                                            
	 
		                                            
		                                    
	 

	                                        
	                                                
	                                               
	                                                    

	                                                     

	                                                                        

	                                                                   
	                                                              

	                 
	                         
	                                 
	                                                                                                                                                   
	                       
	                            
	                                      



	                                                                  
	 
		                           
		                                           
		                                         
		                                                 

		                                 
		                                
		                                  
		                                 

		                                          
		                                     
		                                                              
	 

	                     
	                                                                  
	 
		                                                         
	 


	            
		                                                   
		 
			                                       
				                                       

			                     
			 
				                                                                           

				                                                              
				                                                              

				                                                                                              
				                                                             

				                                     
					                                           
			 


			                           
			 
				                        
					                
			 
			    
			 
				                                   
				 
					                           
				 
			 

			                                
			 
				                                
				                                                                                               
			 
			    
			 
				                                                                                                      
				                                                                                                
				                                                                                  
				                     
				 
					                                     
						                                           

					                                                        
					                               

					                                    
					                                                                                       
				 
			 

			                                                                                             
			                                
			                      
			 
				                                                     
				 
					                                              
				 
				                                                          
				 
					                                           
				 
			 
		 
	 
	                                       

	                                                                       

	                                   
	                                                                           
	                                                                          

	                                                                 
	 
		                                                            
	 

	                                    
	                                    

	                                                              
	                                                              

	                                   
	                                                                                      


	                                             
	                                             

	                                                         
	                                                            

	                                               
	                                              
	                                              

	                  


	                                                                 
	                
	                                                                                                                                                        
	                                  
	                                       
	                                                 
	                          

	                                   
	                                
 
#endif

#if SERVER
                                                
 
	                         
	                              
	           
	                                      
	 
		                                                                                       
		                                                                                             
		                                                                                           
	 
 
#endif

                                                                          
#if SERVER
                                                                
 
	                                                                             
	                                            

	                                                                          
	                                                                           

	            
		                     
		 
			                                                      
			                                                       
		 
	 

	                         
	 
		                                                                                                                                                 
		                                                                   
		        
	 
 
#endif

                                                
#if CLIENT
void function ValkUlt_ShowEmbarkUI( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	if ( !PlayerHasPassive( player, ePassives.PAS_VALK ) )
		return

	UpdateValkFlightRui( player, true )
	file.countdownRui = CreateFullscreenRui( $"ui/skyward_embark.rpak" )
	thread ValkUlt_ChargeBarSounds( player, SKYWARD_WAIT_TIME_BEFORE_LAUNCH )

	entity weapon = player.GetOffhandWeapon ( OFFHAND_ULTIMATE )
	RuiSetGameTime( file.countdownRui, "startTime", weapon.w.valkUltStartTime )
	RuiSetGameTime( file.countdownRui, "endTime", weapon.w.valkUltStartTime + SKYWARD_WAIT_TIME_BEFORE_LAUNCH + 0.1 )
}
#endif          

                       
#if CLIENT
void function ValkUlt_ChargeBarSounds( entity valk, float chargeTime )
{
	EndSignal( valk, "OnDestroy" )
	EndSignal( valk, "OnSkywardCanceled" )
	EndSignal( valk, "BleedOut_OnStartDying" )
	EmitSoundOnEntity( valk, "Valk_Ultimate_ProgressBar_Charging" )
	OnThreadEnd(
		function() : ( valk )
		{
			StopSoundOnEntity( valk, "Valk_Ultimate_ProgressBar_Charging" )
			if ( valk.Player_IsSkywardLaunching() )
				EmitSoundOnEntity( valk, "Valk_Ultimate_ProgressBar_Complete" )
		}
	)
	Wait( chargeTime )
}
#endif

                                                  
#if CLIENT
void function ValkUlt_DestroyEmbarkUI( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	if ( file.countdownRui != null )
	{
		RuiDestroyIfAlive( file.countdownRui )
		file.countdownRui = null
	}

	if ( !player.Player_IsSkywardLaunching() )
	{
		UpdateValkFlightRui( player, false )
	}
}
#endif

                                                              
#if CLIENT
void function ServerToClient_PlayPleaseWaitSound( entity player )
{
	EmitSoundOnEntity( player, "Menu.Invalid" )
}
#endif

#if CLIENT
void function ServerToClient_ValkUltCanceled( entity player )
{
	player.Signal( "OnSkywardCanceled" )
}
#endif

#if CLIENT
void function ServerToClient_SetSkydiveAfterUlt( entity player, bool inSkydive )
{
	if ( !IsValid ( player ) )
		return

	player.p.inSkydiveAfterUlt = inSkydive
}
#endif

#if CLIENT
void function ServerToClient_RemoveFromPlayersWaiting( entity player, entity weapon )
{
	if ( !IsValid( weapon ) )
		return

	weapon.w.valkAlliesWaitingForLaunch.fastremovebyvalue( player )
}
#endif

void function ValkUlt_Canceled_Keypress_Wrapper( entity owner )
{
	bool blockBecauseDebounce = false

	                                     
	if (owner in file.valkUltDebounce)
	{
		if (Time() < (file.valkUltDebounce[owner] + SKYWARD_VALK_USE_DEBOUNCE_TIME))
		{
			blockBecauseDebounce = true
		}
		else
		{

		}
	}

	if (blockBecauseDebounce)
		return

	file.valkUltDebounce[owner] <- Time()
	ValkUlt_Canceled_ClearOffhand( owner )

}


void function ValkUlt_Canceled_ClearOffhand( entity player )
{
	if ( !IsValid ( player ) )
		return

	if ( IsValid( player ) && IsAlive( player ) )
	{
		player.ClearOffhand( eActiveInventorySlot.mainHand )
	}
}

void function ValkUlt_Canceled( entity player )
{
	if ( !IsThisPlayerInDeployState( player ) )
		return

	player.Signal( "OnSkywardCanceled" )

	#if CLIENT
		UpdateValkFlightRui( player, false )
	#endif


	entity offhandWeapon = player.GetOffhandWeapon( OFFHAND_ULTIMATE )

	if ( !IsValid( offhandWeapon ) )
		return

	string weaponName = offhandWeapon.GetWeaponClassName()
	if ( weaponName != "mp_ability_valk_skyward" )
		return


	float refundAmount = 0.75

	if ( IsArenaMode() )
		refundAmount = 1.0

                            
        if ( Control_IsModeEnabled() )
            refundAmount = 1.0
                                  

	if ( IsValid( offhandWeapon ) )
		offhandWeapon.SetWeaponPrimaryClipCount( int( offhandWeapon.GetWeaponPrimaryClipCountMax() * refundAmount ) )
}

                                                                         
                                                                         
                                                                         

#if CLIENT
                                                       
void function OnPropScriptCreated( entity proxy )
{
	if ( proxy.GetScriptName() != SKYWARD_PROXY_SCRIPT_NAME )
		return

	SetCallback_CanUseEntityCallback( proxy, ValkUlt_CanUseAlly )
	AddEntityCallback_GetUseEntOverrideText( proxy, ValkUlt_UseOverrideText )
}
#endif

#if CLIENT
                                             
string function ValkUlt_UseOverrideText( entity proxy )
{
	entity user = GetLocalClientPlayer()
	entity valk = proxy.GetOwner()

	if ( IsPlayerAttachedToValkUlt( user, proxy ) )
	{
		return "#SKYWARD_ALLY_CANCEL_PROMPT"
	}

	if ( user == valk || !ValkUlt_CanUseAlly( user, proxy, 0 ) )
		return ""


	return "#SKYWARD_ALLY_USE_PROMPT"

}
#endif

                                 
bool function ValkUlt_CanUseAlly( entity ally, entity proxy, int useFlags )
{
	entity valk = proxy.GetParent()

	                                   
	if( ally.Player_IsSkywardLaunching() && !IsPlayerAttachedToValkUlt( ally, proxy ) )
		return false

	                       
	if ( StatusEffect_GetSeverity( ally, eStatusEffect.placing_phase_tunnel ) != 0 )
		return false

	if ( Bleedout_IsBleedingOut( ally ) )
		return false

	if ( !ally.Player_IsSkywardLaunching() )
	{
		if ( ally.Player_IsSkydiving() )
			return false

		if ( !ally.IsOnGround() )
			return false
	}

	if ( Crafting_IsPlayerAtWorkbench( ally ) )
		return false

	if ( ally.p.isInExtendedUse )
		return false

	if ( ally == valk )
	{
		return false
	}

	if ( IsEnemyTeam( ally.GetTeam(), valk.GetTeam() ) )
	{
		return false
	}

	entity weapon = valk.GetOffhandWeapon( OFFHAND_ULTIMATE )

	if ( Time() < ally.p.nextAllowUseValkUltTime )
		return false

	if ( GetPlayerIsEmoting( ally ) )
		return false

	if ( ally.ContextAction_IsActive() )
		return false

	if ( ally.IsPhaseShiftedOrPending() )
		return false

	if ( weapon.w.valkAlliesWaitingForLaunch.len() >= 2 )
		return false

	return true
}


void function ValkUlt_AllyUse( entity proxy, entity ally, int useInputFlags )
{
	                                                                           

	if ( ally.p.nextAllowUseValkUltTime > Time() )
		return

	if ( !ValkUlt_CanUseAlly( ally, proxy, useInputFlags ) )
		return

	entity valk = proxy.GetParent()
	if ( valk == ally )
	{
		return
	}

	#if SERVER
		                                                                                   
		 
			                          
			      
		 
	#endif

                           
                     
           
                       
      
                                                      
       

	entity weapon = valk.GetOffhandWeapon( OFFHAND_ULTIMATE )

	if ( weapon.w.valkAlliesWaitingForLaunch.len() > 2 )
		return

	#if SERVER
		                                                                                                                      
		                                                             
	#endif

	                                                                      
	weapon.w.valkAlliesWaitingForLaunch.append( ally )

	                                                                                                                 
	ally.p.nextAllowUseValkUltTime = Time() + SKYWARD_ALLY_USE_DEBOUNCE_TIME
}


                                                                             
void function ValkUlt_AllyCancel( entity ally )
{
	if ( ally.p.nextAllowUseValkUltTime > Time() )
		return

	if (file.isInLaunchingState[ally])
		ally.Player_StopFollowSkywardLaunch( true )

	ally.p.nextAllowUseValkUltTime = Time() + SKYWARD_ALLY_USE_DEBOUNCE_TIME

	#if SERVER
		                                     
		                                                                              
		                                                                                
	#endif
	ally.Signal( "AllyCanceledSkyward" )
}


                                                                     
                                                                     
                                                                     

void function CodeCallback_PlayerSkywardDeployBegin( entity owner )
{
	entity weapon = owner.GetOffhandWeapon ( OFFHAND_ULTIMATE )
	weapon.w.valkUltStartTime = Time()
	#if CLIENT
		if ( owner.HasPassive( ePassives.PAS_VALK ) )
		{
			if ( !(GetLocalViewPlayer() == owner) )
				return

			EmitSoundOnEntity( owner, "Valk_Ultimate_Activate_1P" )
			thread ValkUlt_ClientOnlyIdleLoop1P( owner )
			file.isInLaunchingState[owner] <- false
		}
	#endif
}


void function CodeCallback_PlayerSkywardLaunchBegin( entity owner )
{
	if ( !IsValid( owner ) )
		return

	#if SERVER
		                                   
	#endif

	#if CLIENT
		                                                                     
		                                                                               
		                                                         
		if ( owner.HasPassive( ePassives.PAS_VALK ) )
		{
			if ( !(GetLocalViewPlayer() == owner) )
				return

			file.isInLaunchingState[owner] <- true
			table<string, float> launchParams = Helper_GetLaunchParams()

			float totalUpTime     = launchParams["totalUpTime"]
			float slowUpTime      = launchParams["slowUpTime"]
			float fastUpTime      = launchParams["fastUpTime"]
			float totalUpDistance = launchParams["totalUpDistance"]
			float slowUpDistance  = launchParams["slowUpDistance"]

			thread ValkUlt_DoClientSoundsForLaunch( owner, slowUpTime, fastUpTime )
			thread UpdateLaunchRui( owner, totalUpDistance )
		}
		else
		{
			                                     
		}
	#endif
}


void function CodeCallback_PlayerSkywardLaunchEnd( entity owner, bool interrupted )
{
	if ( !IsValid( owner ) )
		return
	
	#if SERVER
		                                  
			      

		                                                      
		                              
		 
			                                                                    
			                  
			 
				                                      
			 
			    
			 
				                               
			 
		 
		    
		 
			                                           
			                  
			 
				                                      
			 
			    
			 
				                               
			 
		 
	#endif
}

#if CLIENT
void function ClientCodeCallback_OnSkywardLaunchStateChanged( entity owner, bool isInterrupted )
{
	if( owner != GetLocalClientPlayer() )
		return

	switch (owner.GetSkywardLaunchState())
	{
		case PLAYER_SKYWARD_LAUNCH_STATE_LAUNCH:
			owner.Signal( "OnSkywardLaunched" )
			break
		case PLAYER_SKYWARD_LAUNCH_STATE_NONE:
			file.isInLaunchingState[owner] <- false
			if ( isInterrupted )
			{
				owner.Signal( "OnSkywardInterrupted" )
			}
			else
			{
				owner.Signal( "OnSkywardDone" )
			}
			break
	}
}
#endif

                                                                                               
                                                                                               
                                                                                               


#if SERVER
                                                  
 
	                                              
		      

	                                      
	                                                                                           

	                                                                                                                                                        
	                                                                                                                                                   
	                                                   

	                                                     
	 
		                          
		               
		 
			                                                                 
		 
	 
 
#endif

#if SERVER
                                                                
 
	                                                                                               
	                                          
	                                       

	                                
	 
		                                                                
		                      
	 
 
#endif

#if CLIENT
void function ValkUlt_ClientOnlyIdleLoop1P( entity owner )
{
	EndSignal( owner, "OnDeath", "OnDestroy", "BleedOut_OnStartDying", "OnSkywardCanceled", "OnSkywardInterrupted", "OnSkywardLaunched",
		"OnSkywardDeployStateEnd" )
	                                            
	                                         
	                                                                                                                   

	EmitSoundOnEntity( owner, "Valk_Ultimate_Idle_Loop_1P" )
	OnThreadEnd(
		function() : ( owner )
		{
			StopSoundOnEntity( owner, "Valk_Ultimate_Idle_Loop_1P" )
		}
	)
	while( owner.Player_IsSkywardLaunching() )
	{
		WaitFrame()
	}
	                                     
}
#endif

#if SERVER
                                                                                                                                 
 
	                                          
	                                                                                  

	                                                        
	                                                         

	                                                     
	                     
	                            

	            
		                                                  
		 
			                                  

			                          
				                                   
		 
	 
	                  
	                                                      
	                          
	                  
 
#endif

#if CLIENT
void function ValkUlt_DoClientSoundsForLaunch( entity owner, float slowUpTime, float fastUpTime )
{
	EndSignal( owner, "OnDeath", "OnDestroy", "OnSkywardDone", "OnSkywardInterrupted" )
	EmitSoundOnEntity( owner, "Valk_Ultimate_BuildUp_1P" )
	OnThreadEnd(
		function() : ( owner )
		{
			StopSoundOnEntity( owner, "Valk_Ultimate_BuildUp_1P" )
			StopSoundOnEntity( owner, "Valk_Ultimate_BlastOff_1P" )
		}
	)

	Wait( slowUpTime )
	EmitSoundOnEntity( owner, "Valk_Ultimate_BlastOff_1P" )
	Wait( fastUpTime )
}
#endif

                                                                    
                                                                    
                                                                    

#if CLIENT
  
                                                                 
   
void function UpdateLaunchRui( entity owner, float totalUpDistance )
{
	owner.EndSignal( "OnDeath" )
	owner.EndSignal( "BleedOut_OnStartDying" )
	owner.EndSignal( "OnSkywardInterrupted" )

	file.launchRui = CreateFullscreenRui( $"ui/skyward_launch.rpak" )
	thread Valk_EnableHudColorCorrection()
	RuiSetFloat( file.launchRui, "seaHeight", GetSeaHeightForDisplay() )
	RuiTrackFloat3( file.launchRui, "playerPos", owner, RUI_TRACK_ABSORIGIN_FOLLOW )
	RuiSetFloat( file.launchRui, "maxHeight", totalUpDistance )

	OnThreadEnd ( function() : ( owner )
	{
		DestroyValkLaunchRui()
		UpdateValkFlightRui( owner, false )
	} )

	while( true )
	{
		if ( file.launchRui )
		{
			RuiSetFloat3( file.launchRui, "cameraAngle", owner.CameraAngles() )
			RuiSetFloat( file.launchRui, "seaHeight", GetSeaHeightForDisplay() )
			RuiSetBool( file.launchRui, "isFullmapOpen", Fullmap_IsVisible() || IsScoreboardShown())
		}
		WaitFrame()
	}
}
  
                                                                                     
                                                              
   
bool function DestroyValkLaunchRui()
{
	if ( file.launchRui )
	{
		RuiDestroyIfAlive( file.launchRui )
		file.launchRui = null
		return true
	}
	return false
}
#endif

void function UpdateValkFlightRui( entity player, bool isInAir )
{
	#if CLIENT
		bool isValk = false
		if ( LoadoutSlot_IsReady( ToEHI( player ), Loadout_Character() ) )
			isValk = ItemFlavor_GetAsset( LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_Character() ) ) == VALK_ITEMFLAVOR

		bool showValkRui = isInAir && isValk

		RuiSetBool( GetDpadMenuRui(), "isValkAirborn", showValkRui )
		RuiSetBool( GetWeaponRui(), "isValkAirborn", showValkRui )
		RuiSetBool( GetTacticalRui(), "isValkAirborn", showValkRui )
		RuiSetBool( GetUltimateRui(), "isValkAirborn", showValkRui )
		RuiSetBool( GetMinimapFrameRui(), "isValkAirborn", showValkRui )
		RuiSetBool( GetMinimapYouRui(), "isValkAirborn", showValkRui )
		if ( Valk_GetJetPackRui() != null )
			RuiSetBool( Valk_GetJetPackRui(), "isValkAirborn", showValkRui )

		if ( showValkRui )
			thread Valk_EnableHudColorCorrection()
		else
			thread Valk_DisableHudColorCorrection()

		if ( !IsArenaMode() && IsValid( GetCompassRui() ) )
			RuiSetBool( GetCompassRui(), "isValkAirborn", showValkRui )

		if ( isValk )
		{
			if ( isInAir && file.flightRui == null )
			{
				file.flightRui = CreatePermanentCockpitRui( $"ui/valk_flight.rpak" )
				RuiTrackFloat3( file.flightRui, "playerAngles", GetLocalViewPlayer(), RUI_TRACK_CAMANGLES_FOLLOW )
			}
			else if ( file.flightRui != null && !isInAir )
			{
				RuiSetBool( file.flightRui, "isFinished", true )
				file.flightRui = null
				DestroyValkLaunchRui()
			}
		}
		else
		{
			DestroyAllValkRui()
		}
	#endif
}

#if CLIENT
void function DestroyAllValkRui()
{
	if ( GetDpadMenuRui() != null )
		RuiSetBool( GetDpadMenuRui(), "isValkAirborn", false )
	if ( GetWeaponRui() != null )
		RuiSetBool( GetWeaponRui(), "isValkAirborn", false )
	if ( GetTacticalRui() != null )
		RuiSetBool( GetTacticalRui(), "isValkAirborn", false )
	if ( GetUltimateRui() != null )
		RuiSetBool( GetUltimateRui(), "isValkAirborn", false )
	if ( Valk_GetJetPackRui() != null )
		RuiSetBool( Valk_GetJetPackRui(), "isValkAirborn", false )
	if ( GetMinimapFrameRui() != null )
		RuiSetBool( GetMinimapFrameRui(), "isValkAirborn", false )
	if ( file.countdownRui != null )
		RuiDestroyIfAlive( file.countdownRui )

	DestroyValkLaunchRui()

	if ( file.flightRui != null )
	{
		RuiSetBool( file.flightRui, "isFinished", true )
		RuiDestroyIfAlive( file.flightRui )
	}
	thread Valk_DisableHudColorCorrection()
	file.flightRui    = null
	file.launchRui    = null
	file.countdownRui = null
}

#endif

#if SERVER
                                                   
 
	                         
		      

	                                          
		      

	                             
	                                          
		                                    

	                                             
		                                       
 
#endif

                                                                                 
                                                                                 
                                                                                 

array<float> function GetValkLaunchTimes()
{
	array<float> launchTimes

	if ( !IsArenaMode() )
	{
		launchTimes.append( GetCurrentPlaylistVarFloat( "valk_ult_launch_time", SKYWARD_LAUNCH_TIME ) )
		launchTimes.append( GetCurrentPlaylistVarFloat( "valk_ult_slow_up_time", SKYWARD_LAUNCH_SLOW_TIME ) )
	}
	else
	{
		launchTimes.append( GetCurrentPlaylistVarFloat( "valk_ult_launch_time", SKYWARD_LAUNCH_TIME_ARENAS ) )
		launchTimes.append( GetCurrentPlaylistVarFloat( "valk_ult_slow_up_time", SKYWARD_LAUNCH_SLOW_TIME_ARENAS ) )
	}

	return launchTimes
}


table<string, float> function Helper_GetLaunchParams()
{
	table<string, float> res
	float totalUpTime     = GetValkLaunchTimes()[0]
	float slowUpTime      = GetValkLaunchTimes()[1]
	float fastUpTime      = totalUpTime - slowUpTime
	float totalUpDistance = GetValkUltMaxHeight()
	float slowUpDistance  = (1.0 / 20.0) * totalUpDistance

	                         
	res["totalUpTime"] <- totalUpTime
	res["slowUpTime"] <- slowUpTime
	res["fastUpTime"] <- fastUpTime
	res["totalUpDistance"] <- totalUpDistance
	res["slowUpDistance"] <- slowUpDistance

	return res
}


bool function IsPlayerAttachedToValkUlt( entity player, entity valkUlt )
{
	if ( IsValid( player.GetParent() ) && player.GetParent() == valkUlt.GetParent() )
		return true

	return false
}


bool function IsThisPlayerInLaunchingState( entity player )
{
	if ( !(player in file.isInLaunchingState) )
		return false

	return file.isInLaunchingState[player]
}


bool function IsThisPlayerInDeployState( entity player )
{
	if ( !player.Player_IsSkywardLaunching() )
		return false

	return !IsThisPlayerInLaunchingState( player )
}


float function GetValkUltMaxHeight()
{
	float totalUpDistance

	if ( !IsArenaMode() )
		totalUpDistance = GetCurrentPlaylistVarFloat( "valk_ult_up_distance", SKYWARD_MAX_HEIGHT )
	else
		totalUpDistance = GetCurrentPlaylistVarFloat( "valk_ult_up_distance_arenas", SKYWARD_MAX_HEIGHT_ARENAS )

	return totalUpDistance
}

#if SERVER
                                                                                                           
 
	                             
		                  

	             
	                                          
	 
		                              
			        
		                        
			     
		       
	 

	                               
	                                            

	                     
		              

	             

 
#endif          

bool function ValkUlt_CanUseZipline( entity player, entity zipline, vector ziplineClosestPoint )
{
	if ( player.Player_IsSkywardLaunching() )
		return false

	return true
}


void function ValkUlt_EnterGameStateResolution()
{
	#if CLIENT
		UpdateValkFlightRui( GetLocalViewPlayer(), false )
	#endif

	#if SERVER
		                                            
		 
			                                          
				                                    

			                                                  
				                                       
		 
	#endif
}
