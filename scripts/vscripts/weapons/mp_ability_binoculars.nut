global function MpAbility_Tactical_Binoculars_Init
global function OnWeaponPrimaryAttack_ability_tactical_binoculars
global function OnWeaponActivate_ability_tactical_binoculars
global function OnWeaponDeactivate_ability_tactical_binoculars
global function OnWeaponAttemptOffhandSwitch_ability_tactical_binoculars

#if CLIENT
global function ServerToClient_ShowRangeRUI
#endif         

#if SERVER
                                                        
#endif

const asset BINOCULAR_FX_3P = $"P_scope_glint"

const string BINOCULAR_ACTIVATE_1P_SOUND = "Fuse_Binocs_Deploy_1p"
const string BINOCULAR_ACTIVATE_3P_SOUND = "Fuse_Binocs_Deploy_3p"
const string BINOCULAR_DEACTIVATE_1P_SOUND = "Fuse_Binocs_Away_1p"
const string BINOCULAR_DEACTIVATE_3P_SOUND = "Fuse_Binocs_Away_3p"
const string BINOCULAR_TAG_ENEMY_SOUND = "Fuse_Binocs_Tag_Enemy_1p"

const string BINOCULAR_NOAMMO_AUDIO_CLICK = "rifle_dryfire"

const float BINOCULAR_TRACKING_DURATION = 8.0
const float BINOCULAR_TARGET_ACQUISITION_TIME = 1.0
const float BINOCULAR_TARGET_GRACE_ACQUISITION_TIME = 0.1
                                                                      
                                     
const float BINOCULAR_TRACKING_FOV = 2.5
const float BINOCULAR_SONAR_PULSE_BUFFER = 600

const bool BINOCS_DEBUG = false

struct
{
	#if CLIENT
		int colorCorrection
	#endif         

	table < entity, array <entity> > ownerTargetTrackingList
} file

void function MpAbility_Tactical_Binoculars_Init()
{
	PrecacheParticleSystem( BINOCULAR_FX_3P )
	#if CLIENT
		file.colorCorrection = ColorCorrection_Register( "materials/correction/area_sonar_scan.raw_hdr" )
	#endif


	Remote_RegisterServerFunction("ClientCallback_AttemptScanButtonCallback" )
	#if CLIENT
		                                                                                                
	#endif

	RegisterSignal( "SpotterSightStop" )
}


bool function OnWeaponAttemptOffhandSwitch_ability_tactical_binoculars( entity weapon )
{
	                                        
	                                                   
	                           
	  	            

	entity player = weapon.GetWeaponOwner()

	entity activeWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	entity hawkTacWeapon = player.GetOffhandWeapon( OFFHAND_TACTICAL )
	bool isInTactical = activeWeapon == hawkTacWeapon
	if ( ScopeTracking_IsTracking( player ) && !isInTactical )
	{
		            
		  	                                                                          
		  	                                                         
		        

		              

		int ammoUsed = Binoculars_AttemptScan( player, weapon )

		return false

	}

	                                                           
	                               
	   
	            
	  	                                                             
	  	                                                         
	        
	  	            
	   

	return true
}

void function OnWeaponActivate_ability_tactical_binoculars(entity weapon)
{
            
  	                                      
  	                                                      
        

	#if CLIENT
	if ( InPrediction() )
	#endif
	{
		weapon.SetForcedADS()
	}

	entity owner = weapon.GetWeaponOwner()
	Assert( owner.IsPlayer() )
	#if SERVER
		                                                                            
	#endif

	#if CLIENT
		if ( owner != GetLocalViewPlayer() )
			return

		EmitSoundOnEntity(owner, BINOCULAR_ACTIVATE_1P_SOUND)

		ColorCorrection_SetExclusive( file.colorCorrection, true )
		ColorCorrection_SetWeight( file.colorCorrection, 1.0 )
	#endif

	if ( !( owner in file.ownerTargetTrackingList) )
	{
		array<entity> targets
		file.ownerTargetTrackingList[owner] <- targets
	}

	thread TacticalBinoculars_FXThread( owner , weapon )
	thread ScopeTracking_Thread( owner, weapon, BINOCULAR_TRACKING_FOV, false, true,file.ownerTargetTrackingList[owner]  )
}

void function OnWeaponDeactivate_ability_tactical_binoculars(entity weapon)
{
	#if CLIENT
	if ( InPrediction() )
	#endif
	{
		weapon.ClearForcedADS()
	}

	entity owner = weapon.GetWeaponOwner()
	Assert( owner.IsPlayer() )
	#if SERVER
		                                                                              
	#endif

	#if CLIENT
		if ( owner != GetLocalViewPlayer() )
			return
		EmitSoundOnEntity(owner, BINOCULAR_DEACTIVATE_1P_SOUND)

		ColorCorrection_SetWeight( file.colorCorrection, 0.0 )
		ColorCorrection_SetExclusive( file.colorCorrection, false )
	#endif          

	owner.Signal( "SpotterSightStop" )
	ScopeTracking_EndThread( owner )
}

int function Binoculars_AttemptScan( entity player, entity weapon )
{
	int primaryClipCount = weapon.GetWeaponPrimaryClipCount()
	if (  primaryClipCount >= weapon.GetAmmoPerShot() )
	{
		entity bestTarget = ScopeTracking_GetBestTarget( player )

		if ( IsValid( bestTarget ) )
		{
			if ( BINOCS_DEBUG )
			{
				DebugDrawSphere( bestTarget.GetWorldSpaceCenter(), 15, COLOR_CYAN, true, BINOCULAR_TRACKING_DURATION )
			}
			thread TacticalBinoculars_TrackPlayerThread( weapon.GetOwner(), bestTarget )

			#if SERVER
				                                                                                                               
				                                                                             
				                                                                                                                                                                                          

				                                                          
				 
					                                                      
					                                                                                   
					                               
					 
						                                                                                                       
					 

				 
			#endif

			PlayerUsedOffhand( player, weapon )
			int ammoPerShot = weapon.GetAmmoPerShot()
			int newAmmo = primaryClipCount - ammoPerShot
			weapon.SetWeaponPrimaryClipCount( newAmmo )

			return ammoPerShot
		}
		else
		{
			#if CLIENT
				AddPlayerHint( 1.5, 0.25, $"", "No valid target in reticle" )
				EmitSoundOnEntity( player, "ui_survival_lootpickupdeny" )
			#endif
		}
	}
	else
	{

		weapon.EmitWeaponSound_1p3p( BINOCULAR_NOAMMO_AUDIO_CLICK, "" )
	}

	return 0
}


var function OnWeaponPrimaryAttack_ability_tactical_binoculars( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity owner = weapon.GetOwner()
	Assert( owner.IsPlayer() )

	int ammoUsed = Binoculars_AttemptScan( owner, weapon )

	return ammoUsed
}

#if CLIENT
void function AttemptScanButtonCallback( entity player )
{
	if ( player != GetLocalViewPlayer() )
		return

	if( player.HasPassive( ePassives.PAS_VANTAGE ) )
	{
		                                                                               
		                                                                
		if ( !ScopeTracking_IsTracking( player ) )
			return

		entity bestTarget = ScopeTracking_GetBestTarget( player )
		if ( !IsValid( bestTarget ) )
		{
			AddPlayerHint( 1.5, 0.25, $"", "No valid target in reticle" )
			EmitSoundOnEntity( player, "Survival_UI_Ability_NotReady" )
			return
		}

		Remote_ServerCallFunction( "ClientCallback_AttemptScanButtonCallback" )
	}
}
#endif

#if SERVER
                                                                       
 
	                                     
		      

	                                                
	 
		                                         
		 
			                                                                  
			                               
			 
				                                               
			 
		 
	 
 
#endif

void function TacticalBinoculars_FXThread( entity owner, entity weapon )
{
	owner.EndSignal( "OnDestroy" )
	owner.EndSignal( "SpotterSightStop" )

	#if SERVER
		                                                                                                                                                                             
		                                           

		            
			                               
			 
				                         
				 
					                     
					                 
				 
			 
		 
	#endif         

	WaitForever()
}

void function TacticalBinoculars_TrackPlayerThread(entity owner, entity target)
{
	owner.EndSignal( "OnDestroy" )
	target.EndSignal( "OnDestroy" )

	#if CLIENT
		EmitSoundOnEntity(owner, BINOCULAR_TAG_ENEMY_SOUND)
	#endif

	if (owner in file.ownerTargetTrackingList)
		file.ownerTargetTrackingList[owner].append(target)

	vantageTargetTrackingList[owner].append(target)
	#if SERVER
		                                                 
		                                                                
	#endif

	OnThreadEnd(
		function() : ( owner, target )
		{
			#if SERVER
				                                                 
				                        
				 
					                                          
				 
			#endif

			if (owner in file.ownerTargetTrackingList && file.ownerTargetTrackingList[owner].contains(target))
				file.ownerTargetTrackingList[owner].removebyvalue(target)


			if (vantageTargetTrackingList[owner].contains(target))
				vantageTargetTrackingList[owner].removebyvalue(target)
		}
	)

	wait BINOCULAR_TRACKING_DURATION
}

#if SERVER
                                                                                                                                                                                              
 
	                             
	 
		                                    
		                                      
			                                                                                                                                                                  
	 
 

#endif

#if CLIENT

void function ServerToClient_ShowRangeRUI( entity victim, float duration )
{
	thread ServerToClient_ShowRangeRUI_Thread( victim, duration )
}

void function ServerToClient_ShowRangeRUI_Thread( entity victim, float duration )
{
	Assert ( IsNewThread(), "Must be threaded off." )
	victim.EndSignal( "OnDestroy" )
	victim.EndSignal( "OnDeath" )

	#if DEV
		if ( BINOCS_DEBUG )
		{
			printt("ServerToClient_ShowRangeRUI_Thread - Showing HP Bars for " + victim.GetPlayerName())
		}
	#endif      

	OnThreadEnd(
		function() : (  victim )
		{
			entity localViewPlayer = GetLocalViewPlayer()
			if ( IsValid( localViewPlayer ) )
			{
				ReconScan_RemoveHudForTarget( localViewPlayer, victim )
			}
		}
	)

	var rui = ReconScan_ShowHudForTarget( GetLocalViewPlayer(), victim )

	if ( rui != null && victim.IsPlayer() )
	{
		RuiSetBool ( rui, "showRange", true )
	}

	wait duration
}

#endif
