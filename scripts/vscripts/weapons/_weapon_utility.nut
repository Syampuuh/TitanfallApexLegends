untyped

                                                                                                     
global function WeaponUtility_Init

global function ApplyVectorSpread
global function DebugDrawMissilePath
global function DegreesToTarget
global function EntityCanHaveStickyEnts
global function EntityShouldStick
global function EntityShouldStickEx
global function GetVectorFromPositionToCrosshair
global function GetVelocityForDestOverTime
global function GetPlayerVelocityForDestOverTime
global function InitMissileForRandomDriftForVortexLow
global function IsPilotShotgunWeapon
global function PlantStickyEntity
global function PlantStickyEntityOnConsistentSurface
global function PlantStickyEntityThatBouncesOffWalls
global function PlantStickyEntityOnWorldThatBouncesOffWalls
global function EnergyChargeWeapon_OnWeaponChargeLevelIncreased
global function EnergyChargeWeapon_OnWeaponChargeBegin
global function EnergyChargeWeapon_OnWeaponChargeEnd
global function Fire_EnergyChargeWeapon
global function FireHitscanShotgunBlast
global function FireProjectileShotgunBlast
global function ProjectileShotgun_GetOuterSpread
global function ProjectileShotgun_GetInnerSpread
global function FireProjectileBlastPattern
global function FireGenericBoltWithDrop
global function OnWeaponPrimaryAttack_GenericBoltWithDrop_Player
global function OnWeaponActivate_updateViewmodelAmmo
global function WeaponCanCrit
global function GiveEMPStunStatusEffects
global function GetMaxTrackerCountForTitan
global function FireBallisticRoundWithDrop
global function DoesModExist
global function DoesModExistFromWeaponClassName
global function IsModActive
global function PlayerUsedOffhand
global function GetDistanceString
global function IsWeaponInSingleShotMode
global function IsWeaponInBurstMode
global function IsWeaponOffhand
global function IsWeaponInAutomaticMode
global function OnWeaponReadyToFire_ability_tactical
global function GetMeleeWeapon
global function OnWeaponRegenEndGeneric
global function Ultimate_OnWeaponRegenBegin
global function OnWeaponActivate_RUIColorSchemeOverrides
global function PlayDelayedShellEject
global function IsABaseGrenade
global function HandleDisappearingParent
global function SolveBallisticArc
global function AreAbilitiesSilenced
global function GetNeededEnergizeConsumableCount
global function HasEnoughEnergizeConsumable
global function OnWeaponEnergizedStart

#if SERVER
                             
                                           
                                                   
                                
                                                      
                                  
                                                          
                                            
                                                         
                                                    
                                                             
                                                             
                                                               
                                                         
                                    
                                       
                                       
                                      
                                                       
                                              
#endif

                         
#if SERVER
                                                            
                                                    
#endif              
#if CLIENT
global function UICallback_UpdateLaserSightColor
#endif              
                                   

global function Weapon_AddSingleCharge

#if CLIENT
global function ServerCallback_SetWeaponPreviewState
global function ServerCallback_KineticLoaderReloadedThroughSlide
global function ServerCallback_KineticLoaderReloadedThroughSlideEnd
#endif

global function OnWeaponTryEnergize

global function OnWeaponAttemptOffhandSwitch_Never
global function OnWeaponAttemptOffhandSwitch_NoZip

#if DEV
global function DevPrintAllStatusEffectsOnEnt
#endif           

#if SERVER
                                               
                                           
                                            
                                     
                                   
                                    
                                 
                                           
                                             
                                                       
                                                      
                                   
                                      
                      
                                                
                                               
                                                  
                                       
                                        
                                        
                                           
                                       
                                     
                                                 
                                        
                                                 
                                   
                                  

                         
                                                      
      

       
                                 
      

                                                                     

#endif         

#if CLIENT
global function GlobalClientEventHandler
global function UpdateViewmodelAmmo
global function IsOwnerViewPlayerFullyADSed
global function GetAmmoColorByType
global function TryCharacterButtonCommonReadyChecks
#endif         

global function ShouldShowADSScopeView
global function HasFullscreenScope

global function AddCallback_OnPlayerAddWeaponMod
global function AddCallback_OnPlayerRemoveWeaponMod

global function CodeCallback_OnPlayerAddedWeaponMod
global function CodeCallback_OnPlayerRemovedWeaponMod

global function EnergyChoke_OnWeaponModCommandCheckMods

#if CLIENT
global function DisplayCenterDotRui
#endif

global function IsTurretWeapon
global function IsHMGWeapon

#if SERVER || CLIENT
global function GetInfiniteAmmo
#if SERVER
                                        
                                        
                                          
       
                                       
      
#endif
global const string MOD_INFINITE_AMMO_CLIPS = "infinite_ammo_clips"
#endif

                                                                                                                                                      
global struct MarksmansTempoSettings
{
	int   requiredShots
	float graceTimeBuildup
	float graceTimeInTempo
	int  fadeoffMatchGraceTime
	float fadeoffOnPerfectMomentHit
	float fadeoffOnFire

	string weaponDeactivateSignal
}
global const string MOD_MARKSMANS_TEMPO = "hopup_marksmans_tempo"
global const string MOD_MARKSMANS_TEMPO_ACTIVE = "marksmans_tempo_active"
global const string MOD_MARKSMANS_TEMPO_BUILDUP = "marksmans_tempo_buildup"
global const string MARKSMANS_TEMPO_REQUIRED_SHOTS_SETTING = "marksmans_tempo_required_shots"
global const string MARKSMANS_TEMPO_GRACE_TIME_SETTING = "marksmans_tempo_grace_time"
global const string MARKSMANS_TEMPO_GRACE_TIME_IN_TEMPO_SETTING = "marksmans_tempo_grace_time_in_tempo"
global const string MARKSMANS_TEMPO_FADEOFF_MATCH_GRACE_TIME = "marksmans_tempo_fadeoff_match_grace_time"
global const string MARKSMANS_TEMPO_FADEOFF_ON_PERFECT_MOMENT_SETTING = "marksmans_tempo_fadeoff_on_perfect_moment"	                                                                                                                                      
global const string MARKSMANS_TEMPO_FADEOFF_ON_FIRE_SETTING = "marksmans_tempo_fadeoff_on_fire"
global const string MARKSMANS_TEMPO_FADEOFF_THREAD_ABORT = "marksmans_tempo_fadeoff_abort"
global const string ENERGIZE_STATUS_RUI_ABORT_SIGNAL = "EnergizRuiThinkAbortSignal"
global function MarksmansTempo_Validate
global function MarksmansTempo_OnActivate
global function MarksmansTempo_OnDeactivate
global function MarksmansTempo_AbortFadeoff
global function MarksmansTempo_SetPerfectTempoMoment
global function MarksmansTempo_OnFire
global function MarksmansTempo_RemoveTempo
global function MarksmansTempo_ClearTempo



global enum eShatterRoundsTypes
{
	STANDARD,
	SHATTER_TRI,

	_count
}
global const string SHATTER_ROUNDS_HOPUP_MOD = "hopup_shatter_rounds"
global const string SHATTER_ROUNDS_MOD = "altfire_shatter_rounds"
global const string SHATTER_ROUNDS_HIPFIRE_MOD = "shatter_rounds_hipfire"
global const string SHATTER_ROUNDS_THINK_END_SIGNAL = "shatter_rounds_think_end"
global const string SHATTER_ROUNDS_ADS_THINK_THREAD_ABORT_SIGNAL = "shatter_rounds_ads_think_end"
global function ShatterRounds_UpdateShatterRoundsThink
#if SERVER
                                      
#endif




global const string SMART_RELOAD_HOPUP = "hopup_smart_reload"
global const string LMG_FAST_RELOAD_MOD = "fast_reload_mod"
global const string LMG_OVERLOADED_AMMO_MOD = "overloaded_ammo"
global const string END_SMART_RELOAD = "end_smart_reload_functionality"
global const string ULTIMATE_ACTIVE_MOD_STRING = "ultimate_active"

const vector LOWAMMO_UI_COLOR = <0, 255, 0> / 255.0
const vector OVERLOADAMMO_UI_COLOR = <0, 200, 200> / 255.0
const vector OUTOFAMMO_UI_COLOR = <255, 65, 65> / 255.0
const vector NORMALAMMO_UI_COLOR = <0, 0, 0>

global const string OVERLOAD_AMMO_SETTING = "smart_reload_overload_ammo_required"
global const string LOW_AMMO_FAC_SETTING = "low_ammo_fraction"

global struct SmartReloadSettings
{
	int OverloadedAmmo
	float LowAmmoFrac
}

const int MIN_AMMO_REQUIRED = 0
const int MAX_AMMO_REQUIRED = 11

global function OnWeaponActivate_Smart_Reload
global function OnWeaponDeactivate_Smart_Reload
global function OnWeaponReload_Smart_Reload


global struct KineticLoaderSettings
{
	float  loadDelay
	float  additiveDelay
	float  maxDelay
	int    ammoToLoad
	string kineticLoaderSFX
}

global function OnWeaponActivate_Kinetic_Loader
global function OnWeaponDeactivate_Kinetic_Loader

global const string END_KINETIC_LOADER = "end_kinetic_loader_functionality"
global const string KINETIC_LOADER_HOPUP = "hopup_kinetic_loader"
global const string END_KINETIC_LOADER_CHOKE = "end_kinetic_loader_choke_functionality"

global const string KINETIC_LOAD_DELAY_SETTING = "kinetic_load_delay"
global const string KINETIC_LOAD_ADDITIVE_DELAY_SETTING = "kinetic_load_additive_delay"
global const string KINETIC_LOAD_MAX_DELAY_SETTING = "kinetic_load_max_delay"
global const string KINETIC_AMMO_TO_LOAD_SETTING = "kinetic_ammo_to_load"
global const string KINETIC_LOAD_SFX_SETTING = "kinetic_load_sfx"
#if CLIENT
global const string END_KINETIC_LOADER_RUI = "end_kinetic_loader_functionality"
#endif


                          
                                 
                                           
          
                                            
      
      

global const bool PROJECTILE_PREDICTED = true
global const bool PROJECTILE_NOT_PREDICTED = false

global const bool PROJECTILE_LAG_COMPENSATED = true
global const bool PROJECTILE_NOT_LAG_COMPENSATED = false

global const PRO_SCREEN_IDX_MATCH_KILLS = 1
global const PRO_SCREEN_IDX_AMMO_COUNTER_OVERRIDE_HACK = 2

global const int DAMAGEARROW_WP_INT_INDEX_ID = 0
global const int DAMAGEARROW_WP_INT_INDEX_TEAM = 1
global const int DAMAGEARROW_WP_INT_INDEX_VISIBILITY_TYPE = 2

global const int DAMAGEARROW_WP_ENT_OWNER = 0

#if SERVER
                                                               
#endif

const float DEFAULT_SHOTGUN_SPREAD_INNEREXCLUDE_FRAC = 0.4
const bool DEBUG_PROJECTILE_BLAST = false

const float EMP_SEVERITY_SLOWTURN = 0.7
const float EMP_SEVERITY_SLOWMOVE = 0.50
const float LASER_STUN_SEVERITY_SLOWTURN = 0.4
const float LASER_STUN_SEVERITY_SLOWMOVE = 0.30

global const asset FX_EMP_BODY_HUMAN = $"P_emp_body_human"
global const asset FX_EMP_BODY_TITAN = $"P_emp_body_titan"
const asset FX_VANGUARD_ENERGY_BODY_HUMAN = $"P_monarchBeam_body_human"
const asset FX_VANGUARD_ENERGY_BODY_TITAN = $"P_monarchBeam_body_titan"
const SOUND_EMP_REBOOT_SPARKS = "marvin_weld"
const FX_EMP_REBOOT_SPARKS = $"weld_spark_01_sparksfly"
const EMP_GRENADE_BEAM_EFFECT = $"wpn_arc_cannon_beam"
const DRONE_REBOOT_TIME = 5.0
const GUNSHIP_REBOOT_TIME = 5.0

const bool DEBUG_BURN_DAMAGE = false

const float BOUNCE_STUCK_DISTANCE = 5.0

const float GOLD_MAG_TIME_BEFORE_STOWED_RELOAD = 5.0

global const string ARROWS_UNSTICK_SIGNAL = "arrows_unstick"

global struct RadiusDamageData
{
	int   explosionDamage
	int   explosionDamageHeavyArmor
	float explosionRadius
	float explosionInnerRadius
}

global struct EnergyChargeWeaponData
{
	string fx_barrel_glow_attach
	asset  fx_barrel_glow_final_1p
	asset  fx_barrel_glow_final_3p
}

#if SERVER
                         
 
	                 
	                                           
	                     
	            
	                  
	            
	             
	            
	                      
	             
	               
	                
	              
	                   
	                
	                                                   
 

                      
 
	                     
	                  
 

                         
 
	                 
	                 
	               
	               
	                 
	                 
	                 
	                 
 
#endif

global struct ArcSolution
{
	bool valid
	vector fire_velocity
	float duration
}

struct
{
	#if SERVER

		                                                                                                                                                               
		                                                        
		                                                           

		                                          
		                                          

		                                             

		                             

		       
			                          
		      

		              						                     

	#else          
		var satchelHintRUI = null
	#endif

	array<void functionref( entity, entity, string )> playerAddWeaponModCallbacks
	array<void functionref( entity, entity, string )> playerRemoveWeaponModCallbacks
	table<string, array<void functionref( entity, string, bool )> > weaponModChangedCallbacks

	#if CLIENT
	bool reloadedThroughSlide = false
	int ammoToLoadTotal = 0
	#endif
} file

global int HOLO_PILOT_TRAIL_FX


                                                    
StringSet STICKY_CLASSES = {
	worldspawn = IN_SET,
	player = IN_SET,
	prop_dynamic = IN_SET,
	prop_script = IN_SET,
	prop_death_box = IN_SET,
	func_brush = IN_SET,
	func_brush_lightweight = IN_SET,
	phys_bone_follower = IN_SET,
	door_mover = IN_SET,
	prop_door = IN_SET,
	script_mover = IN_SET,
	player_vehicle = IN_SET,
	turret = IN_SET,
	prop_loot_grabber = IN_SET,
	prop_lootroller = IN_SET,
}

void function WeaponUtility_Init()
{
	level.trapChainReactClasses <- {}
	level.trapChainReactClasses[ "mp_weapon_frag_grenade" ]            <- true
	level.trapChainReactClasses[ "mp_weapon_satchel" ]                <- true
	level.trapChainReactClasses[ "mp_weapon_proximity_mine" ]        <- true
	level.trapChainReactClasses[ "mp_weapon_laser_mine" ]            <- true

	                             
	RegisterSignal( "OnKnifeStick" )
	RegisterSignal( "EMP_FX" )
	RegisterSignal( "ArcStunned" )
	RegisterSignal( "CleanupPlayerPermanents" )
	RegisterSignal( "PlayerChangedClass" )
	RegisterSignal( "OnSustainedDischargeEnd" )
	RegisterSignal( "EnergyWeapon_ChargeStart" )
	RegisterSignal( "EnergyWeapon_ChargeReleased" )
	RegisterSignal( "WeaponSignal_EnemyKilled" )

	RegisterSignal( "GoldMagPerkEnd" )

	RegisterSignal( MARKSMANS_TEMPO_FADEOFF_THREAD_ABORT )

	RegisterSignal ( END_SMART_RELOAD )

	RegisterSignal ( END_KINETIC_LOADER )
	RegisterSignal ( END_KINETIC_LOADER_CHOKE )
	Remote_RegisterClientFunction( "ServerCallback_KineticLoaderReloadedThroughSlide", "int", 0, 32 )
	Remote_RegisterClientFunction( "ServerCallback_KineticLoaderReloadedThroughSlideEnd" )
                           
                                                                 
                                    
                          
	Remote_RegisterServerFunction( "ClientCallback_UpdateLaserSightColor" )
                                    
	#if CLIENT
	RegisterSignal ( END_KINETIC_LOADER_RUI )
	#endif

	#if SERVER
	                                       
	#endif

	PrecacheParticleSystem( EMP_GRENADE_BEAM_EFFECT )
	PrecacheParticleSystem( FX_EMP_BODY_TITAN )
	PrecacheParticleSystem( FX_EMP_BODY_HUMAN )
	PrecacheParticleSystem( FX_VANGUARD_ENERGY_BODY_HUMAN )
	PrecacheParticleSystem( FX_VANGUARD_ENERGY_BODY_TITAN )
	PrecacheParticleSystem( FX_EMP_REBOOT_SPARKS )

	PrecacheImpactEffectTable( CLUSTER_ROCKET_FX_TABLE )

	#if SERVER
		                                                                                          
		                                                                                              
		                                                  
		                                                            
		                                                                  
		                                                             
		                                                                                 
		                                                                                        
		                                                                                       
		                                                                                           
		                                                                                           
                           
		                                                                                          
        
		                                                                                             
		                                              
		                                            
		                                                 
		                                                   

		                                                                                      
	#endif

	HOLO_PILOT_TRAIL_FX = PrecacheParticleSystem( $"P_ar_holopilot_trail" )

		RegisterSignal( SHATTER_ROUNDS_THINK_END_SIGNAL )
		#if SERVER
		                                                              
		#endif

		AddCallback_OnPlayerAddWeaponMod( ShatterRounds_OnPlayerAddedWeaponMod )
		AddCallback_OnPlayerRemoveWeaponMod( ShatterRounds_OnPlayerRemovedWeaponMod )
}

#if SERVER
                               
 
	                                                                           
	                                                                                                                                                              
	                                                                                                                                                       
	                                                                                                                                                            
	                                                                                                                                                            
 
#endif

                                                                    

#if CLIENT
void function GlobalClientEventHandler( entity weapon, string name )
{
	if ( name == "ammo_update" )
		UpdateViewmodelAmmo( false, weapon )

	if ( name == "ammo_full" )
		UpdateViewmodelAmmo( true, weapon )
}

void function UpdateViewmodelAmmo( bool forceFull, entity weapon )
{
	Assert( weapon != null )                                                        

	if ( !IsValid( weapon ) )
		return
	if ( !IsLocalViewPlayer( weapon.GetWeaponOwner() ) )
		return

	int bodyGroupCount = weapon.GetWeaponSettingInt( eWeaponVar.bodygroup_ammo_index_count )
	if ( bodyGroupCount <= 0 )
		return

	int rounds                = weapon.GetWeaponPrimaryClipCount()
	int maxRoundsForClipSize  = weapon.GetWeaponPrimaryClipCountMax()
	int maxRoundsForBodyGroup = (bodyGroupCount - 1)
	int maxRounds             = minint( maxRoundsForClipSize, maxRoundsForBodyGroup )

	if ( forceFull || (rounds > maxRounds) )
		rounds = maxRounds

	                                             
	weapon.SetViewmodelAmmoModelIndex( rounds )
}
#endif              

void function OnWeaponActivate_updateViewmodelAmmo( entity weapon )
{
	#if CLIENT
		UpdateViewmodelAmmo( false, weapon )
	#endif              
}

                                    

void function OnWeaponActivate_RUIColorSchemeOverrides( entity weapon )
{
	#if SERVER
		                                                   
	#endif
}

#if SERVER
                                                                                                                             
 
	                                                   
 

                                                                                                               
                                                                                                               
                                                                        
 
	                         
		      

	           
	                                                                                  
	 
		                                                                        
		                                                          
	 

	                                                              
	                                                                                   
 
#endif

int function Fire_EnergyChargeWeapon( entity weapon, WeaponPrimaryAttackParams attackParams, EnergyChargeWeaponData chargeWeaponData, bool playerFired = true, float patternScale = 1.0, bool ignoreSpread = true )
{
	int chargeLevel = EnergyChargeWeapon_GetChargeLevel( weapon )
	                              
	if ( chargeLevel == 0 )
		return 0

	                                               
	float spreadChokeFrac = 1.0
	                                                                                                                         
	switch( chargeLevel )
	{
		case 1:
			spreadChokeFrac = expect float( weapon.GetWeaponInfoFileKeyField( "projectile_spread_choke_frac_1" ) )
			break

		case 2:
			spreadChokeFrac = expect float( weapon.GetWeaponInfoFileKeyField( "projectile_spread_choke_frac_2" ) )
			break

		case 3:
			spreadChokeFrac = expect float( weapon.GetWeaponInfoFileKeyField( "projectile_spread_choke_frac_3" ) )
			break

		case 4:
			spreadChokeFrac = expect float( weapon.GetWeaponInfoFileKeyField( "projectile_spread_choke_frac_4" ) )
			break

		default:
			Assert( false, "chargeLevel " + chargeLevel + " doesn't have matching weaponsetting for projectile_spread_choke_frac_" + chargeLevel )
	}
	patternScale *= spreadChokeFrac

	float speedScale = 1.0
	weapon.FireWeapon_Default( attackParams.pos, attackParams.dir, speedScale, patternScale, ignoreSpread )

	if ( weapon.IsChargeWeapon() )
		EnergyChargeWeapon_StopCharge( weapon, chargeWeaponData )

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}


int function EnergyChargeWeapon_GetChargeLevel( entity weapon )
{
	if ( !IsValid( weapon ) )
		return 0

	entity owner = weapon.GetWeaponOwner()
	if ( !IsValid( owner ) )
		return 0

	if ( !owner.IsPlayer() )
		return 1

	if ( !weapon.IsReadyToFire() )
		return 0

	if ( !weapon.IsChargeWeapon() )
		return 1

	int chargeLevel = weapon.GetWeaponChargeLevel()
	return chargeLevel
}


bool function EnergyChargeWeapon_OnWeaponChargeLevelIncreased( entity weapon, EnergyChargeWeaponData chargeWeaponData )
{
	#if CLIENT
		if ( InPrediction() && !IsFirstTimePredicted() )
			return true
#endif

#if SERVER
		                                                         
	#endif

	int level    = weapon.GetWeaponChargeLevel()
	int maxLevel = weapon.GetWeaponChargeLevelMax()

	string tickSound
	string tickSound_3p

	if ( level == maxLevel )
	{
		tickSound = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_leveltick_final" ) )
		tickSound_3p = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_leveltick_final_3p" ) )
	}
	else
	{
		switch ( level )
		{
			case 1:
				tickSound = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_leveltick_1" ) )
				tickSound_3p = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_leveltick_1_3p" ) )

				break

			case 2:
				if ( chargeWeaponData.fx_barrel_glow_attach != "" )
					weapon.PlayWeaponEffect( chargeWeaponData.fx_barrel_glow_final_1p, chargeWeaponData.fx_barrel_glow_final_3p, chargeWeaponData.fx_barrel_glow_attach )

				tickSound = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_leveltick_2" ) )
				tickSound_3p = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_leveltick_2_3p" ) )

				break

			case 3:
				tickSound = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_leveltick_3" ) )
				tickSound_3p = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_leveltick_3_3p" ) )
				break
		}
	}

	if ( tickSound != "" || tickSound_3p != "" )
		weapon.EmitWeaponSound_1p3p( tickSound, tickSound_3p )

	return true
}


void function EnergyChargeWeapon_StopCharge( entity weapon, EnergyChargeWeaponData chargeWeaponData )
{
	if ( chargeWeaponData.fx_barrel_glow_attach != "" )
		weapon.StopWeaponEffect( chargeWeaponData.fx_barrel_glow_final_1p, chargeWeaponData.fx_barrel_glow_final_3p )

	weapon.StopWeaponSound( expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_loop" ) ) )
	weapon.StopWeaponSound( expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_loop_3p" ) ) )

	#if CLIENT
		                                                                                                                               
		float chargeTime          = weapon.GetWeaponSettingFloat( eWeaponVar.charge_time )
		int chargeLevels          = weapon.GetWeaponSettingInt( eWeaponVar.charge_levels )
		int chargeLevelBase       = weapon.GetWeaponSettingInt( eWeaponVar.charge_level_base )
		float chargeLevelsReduced   = (chargeLevels - chargeLevelBase).tofloat()
		float weaponMinChargeTime = 0.0

		if ( chargeLevelsReduced > 0.0 )
		{
			weaponMinChargeTime = chargeTime / chargeLevelsReduced
		}

		if ( Time() - weapon.w.startChargeTime >= weaponMinChargeTime )
		{
			weapon.EmitWeaponSound( expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_end" ) ) )
		}
	#elseif SERVER
		                                      
		                       
		 
			                                                                                                                                   
		 
	#endif
}


bool function EnergyChargeWeapon_OnWeaponChargeBegin( entity weapon )
{
	weapon.Signal( "EnergyWeapon_ChargeStart" )

	if ( weapon.GetWeaponChargeFraction() == 0 )
	{
		weapon.w.startChargeTime = Time()

		string chargeStart    = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_start" ) )
		string chargeStart_3p = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_start_3p" ) )
		weapon.EmitWeaponSound_1p3p( chargeStart, chargeStart_3p )
	}

	string chargeLoop    = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_loop" ) )
	string chargeLoop_3p = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_loop_3p" ) )
	weapon.EmitWeaponSound_1p3p( chargeLoop, chargeLoop_3p )

	return true
}


void function EnergyChargeWeapon_OnWeaponChargeEnd( entity weapon, EnergyChargeWeaponData chargeWeaponData )
{
	                       
	weapon.Signal( "EnergyWeapon_ChargeReleased" )

	thread EnergyChargeWeapon_StopCharge_Think( weapon, chargeWeaponData )
}


void function EnergyChargeWeapon_StopCharge_Think( entity weapon, EnergyChargeWeaponData chargeWeaponData )
{
	weapon.EndSignal( "OnDestroy" )
	weapon.EndSignal( "EnergyWeapon_ChargeStart" )
	weapon.EndSignal( "EnergyWeapon_ChargeReleased" )

	while ( 1 )
	{
		WaitFrame()

		if ( EnergyChargeWeapon_GetChargeLevel( weapon ) <= 1 )
			break
	}

	EnergyChargeWeapon_StopCharge( weapon, chargeWeaponData )
}


void function FireHitscanShotgunBlast( entity weapon, vector pos, vector dir, int numBlasts, int damageType, float damageScaler = 1.0, float ornull maxAngle = null, float ornull maxDistance = null )
{
	Assert( numBlasts > 0 )
	int numBlastsOriginal = numBlasts

	  
	              
		                                                                            
		                                                                            
		                                                                      
	  

	if ( maxDistance == null )
		maxDistance = weapon.GetMaxDamageFarDist()
	expect float( maxDistance )

	if ( maxAngle == null )
		maxAngle = weapon.GetAttackSpreadAngle() * 0.5
	expect float( maxAngle )

	entity owner                  = weapon.GetWeaponOwner()
	array<entity> ignoredEntities = [ owner ]
	int traceMask                 = TRACE_MASK_SHOT
	int visConeFlags              = VIS_CONE_ENTS_TEST_HITBOXES | VIS_CONE_ENTS_CHECK_SOLID_BODY_HIT | VIS_CONE_ENTS_APPOX_CLOSEST_HITBOX | VIS_CONE_RETURN_HIT_VORTEX

	entity antilagPlayer
	if ( owner.IsPlayer() )
	{
		if ( owner.IsPhaseShifted() )
			return

		antilagPlayer = owner
	}

	                  
	Assert( maxAngle > 0.0, "JFS returning out at this instance. We need to investigate when a valid mp_titanweapon_laser_lite weapon returns 0 spread" )
	if ( maxAngle == 0.0 )
		return

	array<VisibleEntityInCone> results = FindVisibleEntitiesInCone( pos, dir, maxDistance, (maxAngle * 1.1), ignoredEntities, traceMask, visConeFlags, antilagPlayer, weapon )
	foreach ( result in results )
	{
		float angleToHitbox = 0.0
		if ( !result.solidBodyHit )
			angleToHitbox = DegreesToTarget( pos, dir, result.approxClosestHitboxPos )

		numBlasts -= HitscanShotgunBlastDamageEntity( weapon, pos, dir, result, angleToHitbox, maxAngle, numBlasts, damageType, damageScaler )
		if ( numBlasts <= 0 )
			break
	}

	                                                                                     
	owner = weapon.GetWeaponOwner()
	if ( !IsValid( owner ) )
		return

	                                                           
	const int MAX_TRACERS = 16
	bool didHitAnything   = ((numBlastsOriginal - numBlasts) != 0)
	bool doTraceBrushOnly = (!didHitAnything)
	if ( numBlasts > 0 )
	{
		WeaponFireBulletSpecialParams fireBulletParams
		fireBulletParams.pos = pos
		fireBulletParams.dir = dir
		fireBulletParams.bulletCount = minint( numBlasts, MAX_TRACERS )
		fireBulletParams.scriptDamageType = damageType
		fireBulletParams.skipAntiLag = false
		fireBulletParams.dontApplySpread = false
		fireBulletParams.doDryFire = true
		fireBulletParams.noImpact = false
		fireBulletParams.noTracer = false
		fireBulletParams.activeShot = false
		fireBulletParams.doTraceBrushOnly = doTraceBrushOnly
		weapon.FireWeaponBullet_Special( fireBulletParams )
	}
}


vector function ApplyVectorSpread( vector vecShotDirection, float spreadDegrees, float bias = 1.0 )
{
	vector angles   = VectorToAngles( vecShotDirection )
	vector vecUp    = AnglesToUp( angles )
	vector vecRight = AnglesToRight( angles )

	float sinDeg = deg_sin( spreadDegrees / 2.0 )

	                               
	float x
	float y
	float z

	if ( bias > 1.0 )
		bias = 1.0
	else if ( bias < 0.0 )
		bias = 0.0

	                                                                        
	float shotBiasMin = -1.0
	float shotBiasMax = 1.0

	                                                      
	float shotBias = ((shotBiasMax - shotBiasMin) * bias) + shotBiasMin
	float flatness = (fabs( shotBias ) * 0.5)

	while ( true )
	{
		x = RandomFloatRange( -1.0, 1.0 ) * flatness + RandomFloatRange( -1.0, 1.0 ) * (1 - flatness)
		y = RandomFloatRange( -1.0, 1.0 ) * flatness + RandomFloatRange( -1.0, 1.0 ) * (1 - flatness)
		if ( shotBias < 0 )
		{
			x = (x >= 0) ? 1.0 - x : -1.0 - x
			y = (y >= 0) ? 1.0 - y : -1.0 - y
		}
		z = x * x + y * y

		if ( z <= 1 )
			break
	}

	vector addX        = vecRight * (x * sinDeg)
	vector addY        = vecUp * (y * sinDeg)
	vector m_vecResult = vecShotDirection + addX + addY

	return m_vecResult
}


float function DegreesToTarget( vector origin, vector forward, vector targetPos )
{
	vector dirToTarget = targetPos - origin
	dirToTarget = Normalize( dirToTarget )
	float dot         = DotProduct( forward, dirToTarget )
	float degToTarget = (acos( dot ) * 180 / PI)

	return degToTarget
}


const SHOTGUN_ANGLE_MIN_FRACTION = 0.1
const SHOTGUN_ANGLE_MAX_FRACTION = 1.0
const SHOTGUN_DAMAGE_SCALE_AT_MIN_ANGLE = 0.8
const SHOTGUN_DAMAGE_SCALE_AT_MAX_ANGLE = 0.1

int function HitscanShotgunBlastDamageEntity( entity weapon, vector barrelPos, vector barrelVec, VisibleEntityInCone result, float angle, float maxAngle, int numPellets, int damageType, float damageScaler )
{
	entity target = result.ent

	                                                                         
	if ( !target.IsTitan() && damageScaler > 1 )
		damageScaler = max( damageScaler * 0.4, 1.5 )

	entity owner = weapon.GetWeaponOwner()
	                        
	if ( !IsValid( target ) || !IsValid( owner ) )
		return 0

	                                                           
	vector hitLocation = result.visiblePosition
	vector vecToEnt    = (hitLocation - barrelPos)
	vecToEnt.Norm()
	if ( Length( vecToEnt ) == 0 )
		vecToEnt = barrelVec

	                                                                                                                            
	WeaponFireBulletSpecialParams fireBulletParams
	fireBulletParams.pos = barrelPos
	fireBulletParams.dir = vecToEnt
	fireBulletParams.bulletCount = 1
	fireBulletParams.scriptDamageType = damageType
	fireBulletParams.skipAntiLag = true
	fireBulletParams.dontApplySpread = true
	fireBulletParams.doDryFire = true
	fireBulletParams.noImpact = false
	fireBulletParams.noTracer = false
	fireBulletParams.activeShot = false
	fireBulletParams.doTraceBrushOnly = false
	weapon.FireWeaponBullet_Special( fireBulletParams )                                                      

	#if SERVER
		                                                    
		                                                           

		                                                               
			                       

		                                
		                                                                                           

		                                                                  
		                                              
		                                                                                                                                                        
		 
			                          
			                                                                                                                           
		 

		                      
		                  
		  	                                                                                                                                                                                         

		                                                                                                                                                                                                       
		                                                                  
		                                                                                                                                                                       

		                                                   
		                                                                                
		                                                                   
		                                                

		                                               

		  
		                                                                                        
		                                                                                  
		                                                                                                                                                                                                                                                                            
		                               
			                                                             

		                         
		                                                     
		                                             
		                                         
		                                             
		                                                                                       
		                                                           
		                      
	#endif              

	return 1
}


void function FireProjectileShotgunBlast( entity weapon, WeaponPrimaryAttackParams attackParams, bool playerFired, float outerSpread, float innerSpread, int numProjectiles )
{
	vector vecFwd   = attackParams.dir
	vector vecRight = AnglesToRight( VectorToAngles( attackParams.dir ) )

	array<vector> spreadVecs = GetProjectileShotgunBlastVectors( attackParams.pos, vecFwd, vecRight, outerSpread, innerSpread, numProjectiles )

	for ( int i = 0; i < spreadVecs.len(); i++ )
	{
		vector spreadVec = spreadVecs[i]
		attackParams.dir = spreadVec

		bool ignoreSpread = true                                                                                                                      
		bool deferred     = i > (spreadVecs.len() / 2)
		entity bolt       = FireBallisticRoundWithDrop( weapon, attackParams.pos, attackParams.dir, playerFired, ignoreSpread, i, deferred )
	}
}


array<vector> function GetProjectileShotgunBlastVectors( vector pos, vector forward, vector right, float outerSpread, float innerSpead, int numSegments )
{
	#if DEBUG_PROJECTILE_BLAST
		                                                               
		                       
		                       
	#endif

	int numRadialSegments = numSegments - 1

	float degPerSegment = 360.0 / numRadialSegments
	array<vector> randVecs

	                                               
	for ( int i = 0 ; i < numRadialSegments ; i++ )
	{
		vector randVec = VectorRotateAxis( forward, right, RandomFloatRange( innerSpead, outerSpread ) )
		randVec = VectorRotateAxis( randVec, forward, RandomFloatRange( degPerSegment * i, degPerSegment * (i + 1) ) )
		randVec.Norm()
		randVecs.append( randVec )

		#if DEBUG_PROJECTILE_BLAST
			                                                                
			                                                                   
			               
			                            

			                                                                 
			                                                                   
			               
			                            
		#endif
	}

	                    
	                                  
	                                                                                
	                                                                      
	                

	                                                               
	randVecs.append( forward )

	#if DEBUG_PROJECTILE_BLAST
		                                               
		 
			                                    
			                                                                                                  
			                                    
			                                                                                                  

			                                                
			                                                
			                                                
		 

		                                  
		 
			                                                                
		 
	#endif

	return randVecs
}


float function ProjectileShotgun_GetOuterSpread( entity weapon )
{
	return weapon.GetAttackSpreadAngle()
}


float function ProjectileShotgun_GetInnerSpread( entity weapon )
{
	float innerSpread = 0

	var innerSpreadVar = expect float ornull( weapon.GetWeaponInfoFileKeyField( "shotgun_spread_radial_innerexclude" ) )
	if ( innerSpreadVar == null )
		innerSpread = ProjectileShotgun_GetOuterSpread( weapon ) * DEFAULT_SHOTGUN_SPREAD_INNEREXCLUDE_FRAC
	else
		innerSpread = expect float ( weapon.GetWeaponInfoFileKeyField( "shotgun_spread_radial_innerexclude" ) )

	return innerSpread
}


void function FireProjectileBlastPattern( entity weapon, WeaponPrimaryAttackParams attackParams, bool playerFired, array<vector> blastPattern, float patternScale = 1.0, bool ignoreSpread = true )
{
	if ( !IsValid( weapon ) )
		return

	int projectilesPerShot = weapon.GetProjectilesPerShot()
	int patternLength      = blastPattern.len()
	Assert( projectilesPerShot <= patternLength, "Not enough blast pattern points (" + patternLength + ") for " + projectilesPerShot + " projectiles per shot" )

	float defaultPatternScale = expect float( weapon.GetWeaponInfoFileKeyField( "projectile_blast_pattern_default_scale" ) )
	patternScale *= defaultPatternScale
	#if DEBUG_PROJECTILE_BLAST
		                                                     
	#endif

	array<vector> scaledBlastPattern = clone blastPattern

	if ( patternScale != 1.0 )
	{
		for ( int i = 0; i < scaledBlastPattern.len(); i++ )
		{
			scaledBlastPattern[i] *= patternScale
		}
	}

	float patternZeroDistance = expect float( weapon.GetWeaponInfoFileKeyField( "projectile_blast_pattern_zero_distance" ) )

	array<vector> spreadVecs = GetProjectileBlastPatternVectors( attackParams, scaledBlastPattern, patternZeroDistance )

	for ( int i = 0; i < projectilesPerShot; i++ )
	{
		vector spreadVec = spreadVecs[i]
		attackParams.dir = spreadVec

		bool deferred = i > (spreadVecs.len() / 2)
		entity bolt   = FireBallisticRoundWithDrop( weapon, attackParams.pos, attackParams.dir, playerFired, ignoreSpread, i, deferred )
	}
}


array<vector> function GetProjectileBlastPatternVectors( WeaponPrimaryAttackParams attackParams, array<vector> blastPattern, float patternZeroDistance )
{
	vector startPos            = attackParams.pos
	vector forward             = attackParams.dir
	vector right               = AnglesToRight( VectorToAngles( attackParams.dir ) )
	vector up                  = AnglesToUp( VectorToAngles( forward ) )
	vector patternCenterAtZero = startPos + (forward * patternZeroDistance)

	array<vector> patternVecs

	foreach ( offsetVec in blastPattern )
	{
		vector offsetPos = patternCenterAtZero + (right * offsetVec.x)
		offsetPos += (up * offsetVec.y)

		vector vecToTarget = Normalize( offsetPos - startPos )
		patternVecs.append( vecToTarget )

		#if DEBUG_PROJECTILE_BLAST
			                                                          
		#endif
	}

	return patternVecs
}


entity function FireBallisticRoundWithDrop( entity weapon, vector pos, vector dir, bool isPlayerFired, bool ignoreSpread, int projectileIndex, bool deferred )
{
	int boltSpeed   = int( weapon.GetWeaponSettingFloat( eWeaponVar.projectile_launch_speed ) )
	int damageFlags = weapon.GetWeaponDamageFlags()

	float boltGravity  = 0.0
	vector originalDir = dir
	if ( weapon.GetWeaponSettingBool( eWeaponVar.bolt_gravity_enabled ) )
	{
		var zeroDistance = weapon.GetWeaponSettingFloat( eWeaponVar.bolt_zero_distance )
		if ( zeroDistance == null )
			zeroDistance = 4096.0

		expect float( zeroDistance )

		boltGravity = weapon.GetWeaponSettingFloat( eWeaponVar.projectile_gravity_scale )
		float worldGravity = GetConVarFloat( "sv_gravity" ) * boltGravity
		float time         = zeroDistance / float( boltSpeed )

		if ( DEBUG_BULLET_DROP <= 1 )
			dir += (GetZVelocityForDistOverTime( zeroDistance, time, worldGravity ) / boltSpeed)
	}

	WeaponFireBoltParams fireBoltParams
	fireBoltParams.pos = pos
	fireBoltParams.dir = dir
	fireBoltParams.speed = 1
	fireBoltParams.scriptTouchDamageType = damageFlags
	fireBoltParams.scriptExplosionDamageType = damageFlags
	fireBoltParams.clientPredicted = isPlayerFired
	fireBoltParams.additionalRandomSeed = 0
	fireBoltParams.dontApplySpread = ignoreSpread
	fireBoltParams.projectileIndex = projectileIndex
	fireBoltParams.deferred = deferred
	entity bolt = weapon.FireWeaponBoltAndReturnEntity( fireBoltParams )

	#if CLIENT
		Chroma_FiredWeapon( weapon )
	#endif

	return bolt
}


string function GetDistanceString( float distInches )
{
	float distFeet   = distInches / 12.0
	float distYards  = distInches / 36.0
	float distMeters = distInches / 39.3701

	return format( "%.2fm %.2fy %.2ff %.2fin", distMeters, distYards, distFeet, distInches )
}


vector function GetZVelocityForDistOverTime( float distance, float duration, float gravity )
{
	vector startPoint = <0, 0, 0>
	vector endPoint   = <distance, 0, 0>

	float vox = distance / duration
	float voz = 0.5 * gravity * duration * duration / duration
	return <0, 0, voz>

	                                                    
	                                                    
	                                                                                          
	                        
}


int function FireGenericBoltWithDrop( entity weapon, WeaponPrimaryAttackParams attackParams, bool isPlayerFired )
{
	#if CLIENT
		if ( !weapon.ShouldPredictProjectiles() )
			return 1
	#endif              

	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	const float PROJ_SPEED_SCALE = 1
	const float PROJ_GRAVITY = 1
	int damageFlags = weapon.GetWeaponDamageFlags()
	WeaponFireBoltParams fireBoltParams
	fireBoltParams.pos = attackParams.pos
	fireBoltParams.dir = attackParams.dir
	fireBoltParams.speed = PROJ_SPEED_SCALE
	fireBoltParams.scriptTouchDamageType = damageFlags
	fireBoltParams.scriptExplosionDamageType = damageFlags
	fireBoltParams.clientPredicted = isPlayerFired
	fireBoltParams.additionalRandomSeed = 0
	entity bolt = weapon.FireWeaponBoltAndReturnEntity( fireBoltParams )
	if ( bolt != null )
	{
		bolt.kv.gravity = PROJ_GRAVITY
		bolt.kv.rendercolor = "0 0 0"
		bolt.kv.renderamt = 0
		bolt.kv.fadedist = 1
	}
	#if CLIENT
		Chroma_FiredWeapon( weapon )
	#endif


	return 1
}


var function OnWeaponPrimaryAttack_GenericBoltWithDrop_Player( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return FireGenericBoltWithDrop( weapon, attackParams, true )
}


var function OnWeaponPrimaryAttack_EPG( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	WeaponFireMissileParams fireMissileParams
	fireMissileParams.pos = attackParams.pos
	fireMissileParams.dir = attackParams.dir
	fireMissileParams.speed = 1
	fireMissileParams.scriptTouchDamageType = damageTypes.largeCaliberExp
	fireMissileParams.scriptExplosionDamageType = damageTypes.largeCaliberExp
	fireMissileParams.doRandomVelocAndThinkVars = false
	fireMissileParams.clientPredicted = false
	entity missile = weapon.FireWeaponMissile( fireMissileParams )
	if ( missile )
	{
		EmitSoundOnEntity( missile, "Weapon_Sidwinder_Projectile" )
		missile.InitMissileForRandomDriftFromWeaponSettings( attackParams.pos, attackParams.dir )
	}

	return missile
}


bool function PlantStickyEntityOnWorldThatBouncesOffWalls( entity ent, DeployableCollisionParams collisionParams, float bounceDot, vector angleOffset = <0, 0, 0>, bool ignoreHullTrace = false )
{
	entity hitEnt = collisionParams.hitEnt
	if ( HitEntIsValidToStick( hitEnt ) )
	{
		float dot = collisionParams.normal.Dot( <0, 0, 1> )

		if ( dot < bounceDot )
		{
			#if SERVER
				                                            
				 
					                                          
					            
				 

				                                                                  
				                                          

				                                   
					            
			#else
				return false
			#endif
		}

		return PlantStickyEntity( ent, collisionParams, angleOffset, ignoreHullTrace )
	}

	return false
}

bool function HitEntIsValidToStick( hitEnt )
{
	if ( !hitEnt || !IsValid( hitEnt ) )
		return false
	
	if ( hitEnt.IsWorld() )
		return true
	if ( hitEnt.HasPusherAncestor() )
		return true
	if ( hitEnt.IsFuncBrush() )
		return true

	return false
}

#if DEV
const bool DEBUG_SURFACE_TEST = false
const float DEBUG_SURFACE_TEST_TIME = 20
#endif
const float SURFACE_TEST_TRACE_LENGTH = 66

bool function PlantStickyEntityOnConsistentSurface( entity projectile, DeployableCollisionParams collisionParams, float consistentDotThreshold, float size, vector angleOffset = <0, 0, 0> )
{
	bool surfaceIsConsistent = true

	                                                                                                      
	vector forward = CrossProduct( collisionParams.normal, <1, 0, 0> )                                                                         
	if ( Length( forward ) == 0.0 )
	{
		forward = CrossProduct( collisionParams.normal, <0, 0, 1> )
	}
	vector surfaceAngles = AnglesOnSurface( collisionParams.normal, forward )
	vector right         = AnglesToRight( surfaceAngles )

	#if DEV
		if ( DEBUG_SURFACE_TEST )
		{
			                                                                                                   
			                                                                                                
			 DebugDrawArrow( collisionParams.pos, collisionParams.pos + collisionParams.normal * SURFACE_TEST_TRACE_LENGTH / 2, 10, COLOR_GREEN, true, DEBUG_SURFACE_TEST_TIME )
		}
	#endif

	int goodHitCount            = 0
	array<vector> testPositions = [ <-1, -1, 0>, <-1, 1, 0>, <1, 1, 0>, <1, -1, 0> ]
	for ( int i = 0; i < testPositions.len(); ++i )
	{
		vector testPos = testPositions[i]

		vector origin    = collisionParams.pos + collisionParams.normal * size
		vector endOrigin = origin + forward * testPos.x * size + right * testPos.y * size - collisionParams.normal * SURFACE_TEST_TRACE_LENGTH

		#if DEV
			if ( DEBUG_SURFACE_TEST )
			{
				DebugDrawArrow( origin, endOrigin, 5, COLOR_CYAN, true, DEBUG_SURFACE_TEST_TIME )
			}
		#endif
		TraceResults traceResult = TraceLine( origin, endOrigin, [ projectile ], TRACE_MASK_NPCWORLDSTATIC, TRACE_COLLISION_GROUP_NONE )

		if ( traceResult.fraction < 1.0 )                      
		{
			float dot = traceResult.surfaceNormal.Dot( collisionParams.normal )
			if ( dot < consistentDotThreshold )
			{
				surfaceIsConsistent = false
				#if DEV
					if ( DEBUG_SURFACE_TEST )
					{
						DebugDrawArrow( traceResult.endPos, traceResult.endPos + traceResult.surfaceNormal * 20, 5, <255, 100, 0>, true, DEBUG_SURFACE_TEST_TIME )
					}
				#endif
			}
			else
			{
				goodHitCount++
				#if DEV
					if ( DEBUG_SURFACE_TEST )
					{
						DebugDrawArrow( traceResult.endPos, traceResult.endPos + traceResult.surfaceNormal * 20, 5, <100, 255, 0>, true, DEBUG_SURFACE_TEST_TIME )
					}
				#endif
			}
		}
		else
		{
			surfaceIsConsistent = false
			break
		}
	}


	if ( !surfaceIsConsistent )
	{
		#if SERVER
			                                
			 
				                                         
					                                                         

				                                                                                                                      
					                                                                    
			 
		#endif

		return false
	}

	return PlantStickyEntity( projectile, collisionParams, angleOffset )
}

bool function PlantStickyEntityThatBouncesOffWalls( entity projectile, DeployableCollisionParams cp, float bounceDot, vector angleOffset = <0, 0, 0> )
{
                     
	if ( (cp.deployableFlags & eDeployableFlags.VEHICLES_LARGE_DEPLOYABLE) && EntIsHoverVehicle( cp.hitEnt ) )
		return PlantStickyEntity_LargeDeployableOnVehicle( projectile, cp, angleOffset )
                           

	float dot = cp.normal.Dot( <0, 0, 1> )
	if ( dot < bounceDot )
	{
		#if SERVER
			                                
			 
				                                         
					                                            
				                                                                                                                      
					                                                       
			 
		#endif
		return false
	}

	#if SERVER
		                              
		                                                          
		                                                           
		                                                                                                                                                          
		                                              
		                                               
		 
			            
		 
	#endif

	return PlantStickyEntity( projectile, cp, angleOffset )
}


#if DEV
const bool DEBUG_DRAW_PLANT_STICKY = false
#endif

bool function PlantStickyEntity( entity ent, DeployableCollisionParams cp, vector angleOffset = <0, 0, 0>, bool ignoreHullTrace = false, bool moveOnNoHitTrace = true )
{
	if ( !EntityShouldStickEx( ent, cp ) )
		return false
	Assert( !ent.IsMarkedForDeletion(), "" )
	Assert( !cp.hitEnt.IsMarkedForDeletion(), "" )

	                                                                                       
	Assert( LengthSqr( cp.normal ) > FLT_EPSILON , "PlantStickyEntity: normal vector " + cp.normal + " is a zero vector. Entity: '" + ent + "' is sticking to HitEnt: '" + cp.hitEnt + "' at position: " + cp.pos )
	vector plantAngles = AnglesCompose( VectorToAngles( cp.normal ), angleOffset )
	vector plantPosition
	if ( ignoreHullTrace )
	{
		plantPosition = cp.pos
	}
	else
	{
		#if DEV
		if ( DEBUG_DRAW_PLANT_STICKY )
		{
			DebugDrawSphere( cp.pos, 5, COLOR_YELLOW, false, 60 )
			DebugDrawArrow( cp.pos, cp.pos + cp.normal*20, 10, COLOR_YELLOW, false, 60 )
		}
		#endif
		vector traceDir    = cp.normal * -1
		vector mins        = cp.ignoreHullSize ? ZERO_VECTOR: ent.GetBoundingMins()
		vector maxs        = cp.ignoreHullSize ? ZERO_VECTOR: ent.GetBoundingMaxs()
		vector entPos 	   = cp.pos
		int traceMask 	   = (ent.IsProjectile() && ent.GetProjectileWeaponSettingBool( eWeaponVar.grenade_use_mask_ability )) ? TRACE_MASK_ABILITY : TRACE_MASK_SHOT
		array<entity> ignoreEnts = [ent]
		if ( ent.IsProjectile() && ent.proj.ignoreOwnerForPlaceStickyEnt && IsValid( ent.GetOwner() ) )
			ignoreEnts.append( ent.GetOwner() )

		TraceResults trace
		if( ( cp.hitEnt.IsPlayer() || cp.hitEnt.IsNPC() ) && ent.IsProjectile() && ent.ProjectileGetWeaponClassName() == "mp_weapon_cluster_bomb_launcher" )
		{
			vector center = cp.hitEnt.GetWorldSpaceCenter()
			center.z = entPos.z
			trace = TraceLineHighDetail( entPos, center, ignoreEnts, traceMask, TRACE_COLLISION_GROUP_NONE )
		}
		else if( cp.highDetailTrace || ( ent.IsProjectile() && ent.proj.useHighDetailCollisionTraceForPlaceStickyEnt ) )
		{
			trace = TraceHullHighDetail( entPos, ( entPos + ( traceDir * cp.traceLength ) ), mins, maxs, ignoreEnts, ( traceMask & ~CONTENTS_HITBOX ), TRACE_COLLISION_GROUP_NONE, cp.normal )
		}
		else
		{
			trace = TraceHull( entPos, ( entPos + ( traceDir * cp.traceLength ) ), mins, maxs, ignoreEnts, ( traceMask & ~CONTENTS_HITBOX ), TRACE_COLLISION_GROUP_NONE, cp.normal )
		}

		if( moveOnNoHitTrace || trace.fraction < 1.0 )
		{
			plantPosition = trace.endPos
		
			#if DEV
			if ( DEBUG_DRAW_PLANT_STICKY )
			{
				DebugDrawSphere( plantPosition, 3, COLOR_RED, false, 60 )
			}
			#endif
		}
		else
		{
			plantPosition = cp.pos
			
			#if DEV
			if ( DEBUG_DRAW_PLANT_STICKY )
			{
				DebugDrawSphere( plantPosition, 3, COLOR_BLUE, false, 60 )
			}
			#endif
		}

		if ( !LegalOrigin( plantPosition ) )
			return false

		if ( trace.startSolid && IsValid( trace.hitEnt ) && !trace.hitEnt.IsWorld() && ent.IsProjectile() && ent.GetProjectileWeaponSettingBool( eWeaponVar.grenade_mover_destroy_when_planted ) )
		{
			#if SERVER
				             
			#endif
			return false
		}
	}

	if ( IsOriginInvalidForPlacingPermanentOnto( plantPosition ) )
		return false

	#if SERVER
		                                 
		                               
		                         
			                         
	#else
		ent.SetOrigin( plantPosition )
		ent.SetAngles( plantAngles )
	#endif
	ent.SetVelocity( <0, 0, 0> )

	                                                                                                  
	if ( !EntityShouldStickEx( ent, cp ) )
		return false
	Assert( !ent.IsMarkedForDeletion(), "" )
	Assert( !cp.hitEnt.IsMarkedForDeletion(), "" )

	                                                              
	if ( cp.hitEnt.IsWorld() )
	{
		ent.SetVelocity( <0, 0, 0> )
		ent.StopPhysics()
	}
	else
	{
		if ( cp.hitBox > 0 )
			ent.SetParentWithHitbox( cp.hitEnt, cp.hitBox, true )
		else
			ent.SetParent( cp.hitEnt )	                                                                 

		if ( cp.hitEnt.IsPlayer() )
			thread HandleDisappearingParent( ent, cp.hitEnt )
	}

	CommonOnSuccessfulStickyPlant( ent, cp )
	return true
}

void function CommonOnSuccessfulStickyPlant( entity ent, DeployableCollisionParams cp )
{
	if ( IsABaseGrenade( ent ) )
	{
		ent.MarkAsAttached()
		ent.AddGrenadeStatusFlag( GSF_PLANTED )
	}
	if ( ent.IsProjectile() )
	{
		ent.proj.isPlanted = true
		if ( ent.proj.deployFunc != null )
			ent.proj.deployFunc( ent, cp )
	}
}

                     
bool function PlantStickyEntity_LargeDeployableOnVehicle( entity ent, DeployableCollisionParams cp, vector angleOffset = <0, 0, 0> )
{
	if ( !HoverVehicle_AttachEntToNearestAbilityAttachment( ent, cp.hitEnt, false, false, <0,0,0> ) )
		return false
	CommonOnSuccessfulStickyPlant( ent, cp )
	return true
}
                           

#if SERVER
                                         
 
	                                   
 
#endif

bool function IsABaseGrenade( entity ent )
{
	#if CLIENT
		return (ent instanceof C_BaseGrenade)
	#else
		return (ent instanceof CBaseGrenade)
	#endif
}

#if SERVER
                                                                      
 
	                                
	                            

	            
		                    
		 
			                     
				                 
		 
	 

	                                                                       
 
#else
void function HandleDisappearingParent( entity ent, entity parentEnt )
{
	parentEnt.EndSignal( "OnDeath" )
	ent.EndSignal( "OnDestroy" )

	parentEnt.WaitSignal( "StartPhaseShift", "DeathTotem_PreRecallPlayer" )

	ent.ClearParent()
}
#endif

string function GetClassnamefromStickyHitEnt( entity hitEnt )
{
	string ornull classNameRaw = hitEnt.GetNetworkedClassName()
	return ((classNameRaw == null) ? "" : expect string( classNameRaw ))
}

bool function EntityShouldStickEx( entity stickyEnt, DeployableCollisionParams params )
{
	entity hitEnt = params.hitEnt
	if ( !EntityCanHaveStickyEnts( stickyEnt, hitEnt ) )
		return false

	string className = GetClassnamefromStickyHitEnt( hitEnt )
	if ( className == "prop_door" )
	{
		float normal = ((params.normal == <0,0,0>) ? 0.0 : params.normal.Dot( UP_VECTOR ))
		if ( normal > DOT_60DEGREE )
			return false
	}

	if ( stickyEnt.IsMarkedForDeletion() )
		return false
	if ( hitEnt.IsMarkedForDeletion() )
		return false
	if ( hitEnt == stickyEnt )
		return false
	if ( hitEnt == stickyEnt.GetParent() )
		return false

                     
	if ( (params.deployableFlags & eDeployableFlags.VEHICLES_NO_STICK) && (className == "player_vehicle") )
		return false
                           

	if ( hitEnt.GetScriptName() == DIRTY_BOMB_TARGETNAME && params.hitBox == 0 )
		return false

	return true
}
bool function EntityShouldStick( entity stickyEnt, entity hitEnt )
{
	DeployableCollisionParams params
	params.hitEnt = hitEnt
	return EntityShouldStickEx( stickyEnt, params )
}

bool function EntityCanHaveStickyEnts( entity stickyEnt, entity ent )
{
	if ( !IsValid( ent ) )
		return false

	if ( ent.GetModelName() == $"" )                                                                        
		return false

	                                                                                             
	if ( ent.IsProjectile() )
		return false

	string stickyEntWeaponClassName = ""

#if SERVER
	                                       
#else
	if ( stickyEnt instanceof C_Projectile )
#endif
	{
		stickyEntWeaponClassName = stickyEnt.ProjectileGetWeaponClassName()
	}

	var entClassname = ent.GetNetworkedClassName()
	if ( entClassname == null )
		return false

	if ( entClassname == "prop_lootroller" && stickyEntWeaponClassName != "" )
		return true

	                                               
	if ( ent.GetScriptName() == WRECKING_BALL_BALL_SCRIPT_NAME )
		return true
	                                                                                                    
	if ( stickyEnt.GetScriptName() == RIOT_DRILL_SCRIPT_NAME )
		return true

	                                                           
	if ( ent.GetScriptName() == MOBILE_SHIELD_SCRIPTNAME )
		return MobileShield_IsAllowedStickyEnt( ent, stickyEnt, stickyEntWeaponClassName )

                       
		                                                                                                                       
		if ( entClassname == "phys_bone_follower" && IsValid( ent.GetOwner() ) )
		{
			entity cannonEnt = ent.GetOwner()

			if ( cannonEnt.GetScriptName() == GetEnumString( "eSkydiveLauncherType", eSkydiveLauncherType.GRAVITY_CANNON ) )
			{
				                                                                                                                                                                                                                                                                        
				                                                                                                                                                                      
				if ( INVALID_GRAVITY_CANNON_PLACEABLES.contains( stickyEntWeaponClassName ) )
				{
					return false
				}
			}
		}
       

	if ( !(string( entClassname ) in STICKY_CLASSES) && !ent.IsNPC() )
		return false

	#if SERVER
		                                     
		 
			                                                                                        
				            
		 
	#endif

	if ( stickyEntWeaponClassName != "" )
	{
		                     
		                                                                                                            
		  	            

		if ( ent.IsPlayer() && (GetWeaponInfoFileKeyField_Global( stickyEntWeaponClassName, "stick_pilot" ) == 0) )
			return false
		if ( ent.IsNPC() && (GetWeaponInfoFileKeyField_Global( stickyEntWeaponClassName, "stick_npc" ) == 0) )
			return false
		if ( (ent.GetScriptName() == CRYPTO_DRONE_SCRIPTNAME ) && (GetWeaponInfoFileKeyField_Global( stickyEntWeaponClassName, "stick_drone" ) == 0) )
			return false
	}

	#if SERVER
		                              
			            
	#endif          

	return true
}


#if DEV
void function ShowExplosionRadiusOnExplode( entity ent )
{
	ent.WaitSignal( "OnDestroy" )

	float innerRadius = expect float( ent.GetWeaponInfoFileKeyField( "explosion_inner_radius" ) )
	float outerRadius = expect float( ent.GetWeaponInfoFileKeyField( "explosionradius" ) )

	vector org    = ent.GetOrigin()
	vector angles = <0, 0, 0>
	thread DebugDrawCircle( org, angles, innerRadius, <255, 255, 51>, true, 3.0 )
	thread DebugDrawCircle( org, angles, outerRadius, COLOR_WHITE, true, 3.0 )
}
#endif       


#if SERVER
                                                 
                                                                                                                                                                                                 
 
	                                                                                                                        
	                                 

	                                      
	                                       
	               
	                

	              
	 
		                          
			      

		                                            
		                                             
		                                              

		                                                   
			        

		                             
		                          
		 
			                                              
			 
				                                              
				 
					                                                    
					 
						                                           
						 
							                       
							     
						 
					 
				 
			 
			    
			 
				                                                              
				 
					                                     
						                        
					    
						                                                           
				 
				    
				 
					                       
				 
			 
		 

		                       
			                                                                                                               

		                         
			     
	 

	                          
		      

	                                                                                                                               

	                                  
	 
		                                                     

		                   
			             
	 
	                                                                                                 
	 
		               
		                               
			                                                     
		    
			                                           

		                                                                

		                                                    
		 
			                       
			                                      
		 
	 

	                          
		      
	
               
                                                                                           
  
                           
                     
                              
                                     
                                                   
                                   

                                      
  
     
       
	                           
	 
		                                                                                                           
		                 
	 
	    
	 
		                                                    
	 
 

                                                               
 
	                                                                                                          

	                                
		            

	                             
 

                                                         
 
	                                                                

	                

	                   
		            

	                  
 

                                  
                                                                    
 
	                                
	                                                        
	                         
		                 
 

                                                                         
 
	                        
		                                             

	                                                                                                                   

	                                                
 

                                                                               
 
	                                            
	                                                                        
		      

	                                                         
	                      
		      

	                 
	                                       
		                                
	                                                   
		                                      

	                       
		      

	                                             
 
#endif          

bool function WeaponCanCrit( entity weapon )
{
	                                                                   
	if ( !weapon )
		return false

	return weapon.GetWeaponSettingBool( eWeaponVar.critical_hit )
}


vector function GetVectorFromPositionToCrosshair( entity player, vector startPos )
{
	Assert( IsValid( player ) )

	                          
	vector traceStart        = player.EyePosition()
	vector traceEnd          = traceStart + (player.GetViewVector() * 20000)
	array<entity> ignoreEnts = [ player ]
	TraceResults traceResult = TraceLine( traceStart, traceEnd, ignoreEnts, TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )

	                                                   
	vector vec = traceResult.endPos - startPos
	vec = Normalize( vec )
	return vec
}

  
                                                                      
 
	                                                
	                              
	                              
 
  

void function InitMissileForRandomDriftForVortexHigh( entity missile, vector startPos, vector startDir )
{
	missile.InitMissileForRandomDrift( startPos, startDir, 8, 2.5, 0, 0, 100, 100, 0 )
}


void function InitMissileForRandomDriftForVortexLow( entity missile, vector startPos, vector startDir )
{
	missile.InitMissileForRandomDrift( startPos, startDir, 0.3, 0.085, 0, 0, 0.5, 0.5, 0 )
}

  
                                                                 
 
	                                                             

	                                                                                                        
	                                                                                                        

	                                                                                                            
	                                                                                                            

	                                                                                                                
	                                        
		                                 
	                                                                                                                
	                                        
		                                 
 

                          
 
	                                                                         
 

                                                                          
 
	                                                            
	                                                             
	                                                                               

	                                               

	                     

	                                             

	                                                                                     
	                                                                                     

	                                   
	                             

	                                                                                         
	                                                                                        

	                              
	                           
	                      
	                      
	                   
	                      
	            

	          
 

                                                                                                                    
                                                                      
 
	                                                                                     
	                                 
		                            

	                   
	                                                                                                                                                                                    
 

                                                                                                                                      
 
	                           
	                                                                             

	                                                                                   
	                                                             
	                                                            
	                                
	 
		                            
		                                                                 
		                                                                     
		                                        
		                                        

		                           

		              
		                                
			                                                                      

		                                                                         

		                                                                
		                   
		  	                                                                                                                                      

		                                        
		                             
		                            
			                                 
		    
			                                   

		                            
		 
			                                                                          
		 

		                                                             
		                                                                                            

		                                             
		                      
		            
	 

	          
 
  

#if SERVER
                                                                                                                             
 
	                        
		      

	                              

	                                          
	                 
	                 
	                   
	                             

	                                                                                           
	                                                                                    
	                       
	 
		                                                                                       
		                                                                                                             
	 
	    
	 
		                                                                                           
		                                                                                                                 
	 

	                                              

	                                   
	                                                                                                                    
	                                     
	                                                
	                                   
	                                                                 
	                                           

	                                        
	                             
	 
		                                                
			                                                                                                                                                                         
	 

	                                                                   
	                                                                   
	         

	                          
	 
		                                                                                                                        
		                                                                                                     
	 

	            
		                                    
		 
			                    
				                
			                         
		 
	 

	                           
		                   

	                                                                                                                                                 
 

                                                              
                                                                                                                                         
                                                     
                                                              
                                                                                                                                                                                            
 
	                              

	                                     
	                                                          
	                                    

	                                       
		                                                          

	                       
	 
		                                         
		                                                    
	 

	                                     
	                                       

	                                                                                                         

	            
		                                    
		 
			                             
		 
	 

	                         
	               
	                          
	              
	                                                   
	                                                                         

	                                 
	                                             
	 
		                                                                                                                                               
		           
	 

	                            
 

                                                                                                                                                                                                   
 
	                                            
	                                                                  

	                                                 
	                                                
	                                           
	                                           
	                                               
	                                           
	                                            
	                                              
	                                               

	                 
	              
	                  
	              
	             
	                      
	              
	              

	                                                     

	                                                               
	                                                                    
	                                     
	                                                              
	                                                                                             

	            
		                                
		 
			                                 
			 
				                                           
				 
					                    
						            
				 
				                         
			 
		 
	 

	                                                                                    
	 
		                                               
		                                 
		                                                                      
		                           
		                        
		                                                                                   

		                                                  
		                   
		 
			                          
			                        
		 

		                                               

		                                                                                                          
		                                       

		                           

		         

		                          

		          
			                   
			      
			          
			       
			                 
			            
			            
			                                   
			                   
			       
			                      
			                           
			                          

		                                           
			                                                   
	 
 


                                                   
 
	                                                    
	                                                                                 
	                                                        
	                               
	                               
	                                           
	                                                             

	                                   
	                                  
	                                  

	                                
	                             
	                                                                   

	                                                                         
	                                   

	                   
 
#endif          

vector function GetVelocityForDestOverTime( vector startPoint, vector endPoint, float duration )
{
	const GRAVITY = 750

	float vox = (endPoint.x - startPoint.x) / duration
	float voy = (endPoint.y - startPoint.y) / duration
	float voz = (endPoint.z + 0.5 * GRAVITY * duration * duration - startPoint.z) / duration

	return <vox, voy, voz>
}


vector function GetPlayerVelocityForDestOverTime( vector startPoint, vector endPoint, float duration )
{
	                                                                      

	float gravityScale = GetGlobalSettingsFloat( DEFAULT_PILOT_SETTINGS, "gravityScale" )
	float GRAVITY      = 750 * gravityScale                                  

	float vox = (endPoint.x - startPoint.x) / duration
	float voy = (endPoint.y - startPoint.y) / duration
	float voz = (endPoint.z + 0.5 * GRAVITY * duration * duration - startPoint.z) / duration

	return <vox, voy, voz>
}

#if CLIENT

bool function IsOwnerViewPlayerFullyADSed( entity weapon )
{
	entity owner = weapon.GetOwner()
	if ( !IsValid( owner ) )
		return false

	if ( !owner.IsPlayer() )
		return false

	if ( owner != GetLocalViewPlayer() )
		return false

	float zoomFrac = owner.GetZoomFrac()
	if ( zoomFrac < 1.0 )
		return false

	return true
}
#endif          


void function DebugDrawMissilePath( entity missile )
{
	EndSignal( missile, "OnDestroy" )
	vector lastPos = missile.GetOrigin()
	while ( true )
	{
		WaitFrame()
		if ( !IsValid( missile ) )
			return
		DebugDrawLine( lastPos, missile.GetOrigin(), COLOR_GREEN, true, 20.0 )
		lastPos = missile.GetOrigin()
	}
}


bool function IsPilotShotgunWeapon( string weaponName )
{
	if ( IsWeaponKeyFieldDefined( weaponName, "weaponSubClass" ) && GetWeaponInfoFileKeyField_GlobalString( weaponName, "weaponSubClass" ) == "shotgun" )
		return true

	return false
}




#if SERVER
                                                              
 
	                                                                                                                                         
	                                   
	           

	                                    

	                                             
		      

	                                                                                                
	                       
	 
		                                     

		                                                                           
		                              
		                        
		 
			                                                                                      
				        

			                              
		 

		                                                       
		                       
		 
			                                        
			                                   
			 
				             
				              

				                    
					     
			 
		 
	 
 

                                                           
 
	                                                             
 

                                                              
 
	                                                                            
	                        
	 
		             
	 
 

                                                  
 
	                                                                    
		        

	         
 

                                                         
 
	                                                                    
		        

	         
 
#endif         


void function GiveEMPStunStatusEffects( entity target, float duration, float fadeoutDuration = 0.5, float slowTurn = EMP_SEVERITY_SLOWTURN, float slowMove = EMP_SEVERITY_SLOWMOVE )
{
	#if SERVER
		                        
		 
			                                                                           
			 
				                                           
			 

			                                                     
		 

		                                                                                                              
		                                                                                                              

		                        
		 
			                                                                  
			                                                                  
		 
	#endif
}

#if DEV
string ornull function FindEnumNameForValue( table searchTable, int searchVal )
{
	foreach ( string keyname, int value in searchTable )
	{
		if ( value == searchVal )
			return keyname
	}
	return null
}

void function DevPrintAllStatusEffectsOnEnt( entity ent )
{
	printt( "Effects:", ent )
	array<float> effects = StatusEffect_GetAllSeverity( ent )
	int length           = effects.len()
	int found            = 0
	for ( int idx = 0; idx < length; idx++ )
	{
		float severity = effects[idx]
		if ( severity <= 0.0 )
			continue
		string ornull name = FindEnumNameForValue( eStatusEffect, idx )
		Assert( name )
		expect string( name )
		printt( " eStatusEffect." + name + ": " + severity )
		found++
	}
	printt( found + " effects active.\n" )
}
#endif           

entity function GetMeleeWeapon( entity player )
{
	array<entity> weapons = player.GetMainWeapons()
	foreach ( weaponEnt in weapons )
	{
		if ( weaponEnt.IsWeaponMelee() )
			return weaponEnt
	}

	return null
}


#if SERVER
                                                  
 
	                                      
	                                                                                                                    
	 
		                                                                      
			                        
	 
	    
	 
		                       
	 
 

                                                                
 
	                                                 
	                                                   
 

                                                                
 
	                                             
	                                              
	 
		                                      
		                                     
		           
	 
	            
 

                                                                        
 
	                                                   
	 
		                                                  
			                             
	 

	                                                                 
	                                                                                  
 

                                                   
 
	                                           
	                                   
	                                                                                                                                               
	                                             
		                             
 

                                                
 
	                                           
	                                   
	                                                                                                                                        
	                                             
		                             
 

                                                          
 
	                                             
	                                                                                                                                                                            
	                                                       
	 
		                                                   
			                             
	 
 

                                                            
 
	                                             
	                                                                                                                                                                
	                                                       
	 
		                                                   
			                             
	 
 

                                                                      
 
	                                           
	                                      
	                                                                                                                      
	                                                                                                                             
	                                         

	                             
 

                                                                     
 
	                                           
	                                      
	                                                                                                                     
	                                                                                                                                                                         
	                                                                                                                                                                     
	                                       

	                             
 

                                                           
 
	                                               
	                                            

	              
 

                                                                  
 
	                                                 
 


                                                                           
 
	                                                                       
		            

	                      
		            

	                                   
		            

	                             
		            

	                              
		            

	                                               
	                                       
		            

	           
 

                                                                   
 
	                     
	 
		                                               
		 
			           
		 
		    
		 
			                                               
		 
	 

	            
 

                                                             
 
	                                     

	                          

	                                        
		                                                  
	   

	                                           
 

                                                                                                                                                                                                                                                                  
 
	                      
		      

	                                                                           
		      

	                                                        
	                            
		      

	                                                                             
	               
	            

	                    
	 
		                       
		                
	 
	                                                                                                                
	 
		                  
		                
		                                                         
		 
			                                                               
		 
	 
                                
                            
  
                    
                  
                                                           
   
                                                                  
   
  
      
	                          
	 
		                  
		                
		                                                         
		 
			                                                               
			                                              
		 
	 
	                          
	 
		                  
		                
	 
	                             
	 
		              
		                
	 
	                             
	 
		                                                 
			      

		                                                
			      

		                
		                
		                                                                 
	 
	                            
	 
		              
		                
		                                                                 
	 
                     
	                                    
	 
		              
		                
	 
      

	                          

	                
	 
		                                                            
		                                               
		                           
		 
			                                                              
			                                        
			 
				                                              
				                                                                                      
				                                                
				                                                                                                                                                              
			 
			                                           
		 
	 

	                                                                      
		                                                   

	                                                                                                                                                      
	                                                      
	                                                                                                                                                  
		      

	                     
	 
		                                                                      
	 
	                         
	 
		                                           
		                                                             
		                                        
	 
	                             
	 
		                                       
	 
	                              
	 
		                                                             
		                                                                      
		                        
		                                                                  
		 
			                                                                                             
			                                          
		 
		    
			                                                 
	 
	                         
	 
		                                          
	 

	                                        
	 
		                                                                                                                           
			                                                                     
	 
 

                                                                                                              
                                              
                                                                                               
 
	                      
		      

	                          
	                            

	                              
		                       

	                                                                           
		      

	                
	                
	                                  
	                                     
	                     
	                   

	                                                        
	                                    
	                                                        
	                    
	 
		                 
			                                   
			                               
			                              
			     

		                   
			                                     
			                                 
			                                
			     

		        
			                                               
	 

	                                                        
	                               
	                                                        
	                         
	                      


	                                                                     
	  
	                                    
	                     


	                                                        

	                                              
	                                  
	  


	                                                    
	                                   
	                       
	                                                                                             

	                           
		                          

	                                        

	               

	                                      
	                                    
	                        
	                                                                                              

	                           
		                         

	                       
 

                                                                                                              
                                              
                                                                              
 
	                      
		      

	                          
	                            

	                                     
	             
	                   
	               
	                 
	            
	                
	                     

	                                                        
	                                    
	                                                        
	                    
	 
		                 
			                                                 
				      
			                                                
				      
			                     
			                  
			                              
			                                               
			     

		                   
			                     
			                
			                                
			                                               
			     

		        
			                                               
	 

	                                                        
	                                     
	                                                        
	                                                                           
	                                        

	                                 
	 
		                                            
		                        


		                                                                     
		                                      
		                                      

		            
			                                              
			 
				                          
					                                 
				                     
					                                        
			 
		 

		                    
	 
 

                                                                                                      
 
	                      
		      

	                      
	                            
	                          
	                                  
	                         

	                              

	                                               
	                                          

	               
	                    
	 
		                                                                                                   
		                                                                                                                            
		                        
	 

	            
		                              
		 
			                          
			 
				                      
			 

			                     
				                                                        
		 
	 

	                
	 
		                                                        

                     
		                               
			                            
      

		             
	 
	    
	 
		                                                                           

		                                      
		                         
		                          
		 
			                           
			 
				                    
				 
					                     
					                          
						                       

					                     
						                                                        
				 
			 
			                                  
			 
				                      
				                                                                           
				                    
			 

			           
		 
	 
 

                                                                      
 
 

                                                           
 
	                                 

	                                    
	                                                  
	                                    
 

                                                           
 
	                                                                 
	                                                                  
		           

	                            
		            

	           
 

                                                                                                     
 
	                                
	                                   

	                              
		      

	                                                        
	              
	              
	                     

	                              
	 
		         		                                      
		         		                  
		                                                
	 
	    
	 
		                                                                                                         
		                        
		                                        
			                                          
		               	                                                                 
		         		                                                                                                                               
		                                                              
		                                                                                                                                                                                            
	 

	                          
		                                       

	                                                                       
	                                                           

	                                                                                         
	 
		                                          
		                                                                                    
	 
	    
	 
		                                                                                 
	 

	                                                                                       
	                                                                       
 

                                                                 
 
	                                      
		      

	                        
	                        

	                                                    
	                                                      
	                                                                
	                             
	                      

	                                                       
	                                          
	                                                           
	                           
	                                              
	                                                                                                                   
	 
		                                       
	 

	                        

	                       
	                                                  
	                                                         
	                                                       
 


                                                                    
 
	                     
	                                                   
	 
		                                                                             
		 
			                                             
			                                                
			                                    
				                          
		 
	 

	              
 

                                                
 
                         
	                              
                                   
 

                                                                                              
 
	                          

	                                                                                     
	                                    
		      

	                              
 

                                                                                                                                      
 
	                                                                     
 

                                                                                                   
 
	                         
		      

	                               

	                   
		                                                                                                      

	                                     
	                            

	                                   
	 
		                                                  
		                                         

		                                         
	 

	                       
		      

	                                   
	 
		                                                
		                         
			        

		                                                    

		                                                                                       
		 
			                                 
				                                                     
				     

			                              
			                                      
			                                       
			                                    

				                       
				 
					                                                                                   
						                                                                                                                         
					    
						                                         
				 
				    
				 
					                                                                                   
						                                                                                                                         
					    
						                                         
				 
				     

			                                    
				                       
					                                                                               
				    
					                                                                               
				     

			        
				                                                                                   
				     
		 
	 
 
#endif         


void function PlayerUsedOffhand( entity player, entity offhandWeapon, bool sendPINEvent = true, entity trackedProjectile = null, table pinAdditionalData = {} )
{
	#if SERVER
		                                                                                                                                                        

		                                                         
		 
			                             
		 

		                                   
		 
			                                                
			                         
				        

			                              
				        

			                       
				                                                  
			    
				                                                  
			                                         

			      
			                   
			 
				                                                      
				                                
					                                                                                                    
				                                     
					                                                                                                    
			 

			      
		 

	#endif          

	#if CLIENT
		if ( offhandWeapon == player.GetOffhandWeapon( OFFHAND_ULTIMATE ) )
		{
			if ( offhandWeapon.GetWeaponSettingFloat( eWeaponVar.regen_ammo_refill_rate ) == 0 )
				UltimateWeaponStateSet( eUltimateState.CHARGING )
			else
				UltimateWeaponStateSet( eUltimateState.ACTIVE )
		}
		Chroma_PlayerUsedAbility( player, offhandWeapon )
	#endif         
}


void function AddCallback_OnPlayerAddWeaponMod( void functionref( entity, entity, string ) callbackFunc )
{
	file.playerAddWeaponModCallbacks.append( callbackFunc )
}


void function AddCallback_OnPlayerRemoveWeaponMod( void functionref( entity, entity, string ) callbackFunc )
{
	file.playerRemoveWeaponModCallbacks.append( callbackFunc )
}


void function CodeCallback_OnPlayerAddedWeaponMod( entity player, entity weapon, string mod )
{
	if ( !IsValid( player ) )
		return

	if ( !IsValid( weapon ) )
		return

	foreach ( callback in file.playerAddWeaponModCallbacks )
	{
		callback( player, weapon, mod )
	}

	                                                                        

	bool modAdded = true
	RunWeaponModChangedCallbacks( weapon, mod, modAdded )

	#if SERVER
		                                                                           
		                                                                                  
	#endif
}


void function CodeCallback_OnPlayerRemovedWeaponMod( entity player, entity weapon, string mod )
{
	if ( !IsValid( player ) )
		return

	if ( !IsValid( weapon ) )
		return

	foreach ( callback in file.playerRemoveWeaponModCallbacks )
	{
		callback( player, weapon, mod )
	}

	                                                                            

	bool modAdded = false
	RunWeaponModChangedCallbacks( weapon, mod, modAdded )

	#if SERVER
		                                                                           
		                                                                                  
	#endif
}

                                                 
void function RunWeaponModChangedCallbacks( entity weapon, string mod, bool modAdded )
{
	string className = weapon.GetWeaponClassName()
	if ( !(className in file.weaponModChangedCallbacks) )
		return

	foreach ( callbackFunc in file.weaponModChangedCallbacks[className] )
		callbackFunc( weapon, mod, modAdded )
}

#if SERVER
                                                 
 
	                            
		           

	                                                                                                                                       
	                                                                                                            

	                                        
 


                                                            
 
	                    
	 
		                     
		 
			                                                                        
			                                                                          
		 
		    
		 
			                                                       
		 
	 
	    
	 
		                     
		 
			                                                                        
			                                                                          
		 
		    
		 
			                                                       
		 
	 
 

                                                                 
 
	                                                                  
	 
		                                                         
		                        
		 
			                                       
			        
		 

		                      
		 
			                                                                          
			                                       
		 
	 
 

                                                              
 
	                    
	                         
	                                                                                                                  
	                                          
 

                                                                  
 
	                                  
	                                 
		          

	                              
	                
	                 
	                 
	          
 

                                                             
 
	                                                
	                          
	                                         
	                     
		                                                                 
	                
 

                                                                        
 
	                                                
	                          
	                                                
	                     
		                                                                 
	                
 

                                                                                     
 
	                                  
	             
	                   
 


                                                                                                        
 
	                     
		               

	                         
		      

	                                       
	                         
		      

	                                                    

	                                                   
	                             
	                            
		                                                
			              

	                       
		                                        

	                                     
	                                                     
		                                                                                         

	                                                    

	                                                                        
	                           
	 
		                  
		                                     
	 
 

                                                       
 
	                         
		      

	                                       
	                         
		      

	                                     
	                                                     
		                                                                                  

	                                                    

	                                          
 

                                                         
 
	                                     

	                                                  
	                
		                                              
	                     
		                                              

	               
 

                                                                                                                          
 
	                                                           
		                                                     

	                                                                      
 

                                                                                                                       
 
	                          

	                                                 
	                     
	                                                                                                                                                            
	                         
	 
		                                    
		                                              
		                                              
	 
	                          
	                                     
	                                                

	                               
	                             
	                                  

	            
		                             
		 
			                    

			                      
				              
		 
	 

	           
	 
		                                                                       
		                               

		                               
		 
			                                                                                 
			 
				                                                            
			 
		 

		           
	 
 

                         
                                                                
                                                                                        
 
                                             
                                                                                                                                              
        

                                
                                                                      
                                                                                                        
                                                                                                      
                                                                                                               
                                                                                                                                     
                                                                                                                         
                                                                                                               

                                         
                                                                                       

                                                                            
 
                                   

                                                       

                                                                                      
 
	                                            
	                                                                                                                                            
		      

	                               
	                                                                           
	                                                                                                       
	                                                                                                     
	                                                                                                              
	                                                                                                                                    
	                                                                                                                        
	                                                                                                              

	                                        
	                                                                                      

	                                                                           
 

                                                 
 
	                      
		            

	                           
		            

	                    
 

                                                                                                                  
 
	                          
	 
		                                                                             
		                                                               
	 
	                                                                  
	 
		                                                               
	 
 

                                                                    
 
	                                                          
	                           

	                          
	                                                

	                                                                                                                                 

	                                 
	 
		                             
		                                                                                                                    
		                                 
		 
			                               
			                                                                                                                    
		 
	 

	                                   
		           

	            
 

                                                                                                                              
 
	                          
	 
		                                                                             
		                                                                        
	 
	                                                                           
	 
		                                                                        
	 
 

                                                                                              
 
	                                                                                                                            
 

                                                                                                       
 
	                                    
		            

	                                           
	                                                     
		                                                                  
			            

	           
 

                                                                                                                     
 
	                     
	                   
	                           
	                        
	                                                       
	                                                                      
	                                                                    
	                                                            
	                                 

	                                      

	                            
		                                             
		                                       
		                                               
		                                                                          
	      

	                              
		                                    
 

                                                                                                                              
 
	                                                         
	 
		                                                               
		      
	 

	                                                          
	                            
		                                                
	                                        
	                                                         

	                                                               
 

                                                                          
 
	                            
		         

	                            
		        

	        
 

                                                                              
 
	                                             

	                            
		                                                                                        
	      
 

                                                  
 
	                          
	                            

	                               

	            
		                     
		 
			                            
				                                        
			      

			                     
				                                
		 
	 

	                                                  
	 
		                                           

		                                                                              
		 
			                   

			                              
			 
				                     
				                               

				                               
				                                                                    
				                       
				 
					                           
					                                 

					                            
						                                                                                                   
					      
				 
			 
			                                                                 
			 
				                                  
				                                        
				                             

				                            
					                                                                                                
				      
			 

			                      
			 
				                     
				 
					                                                      
						                                                                                    
				 

				                                                                                                        

				                                                                       
				                                
					     
			 
		 

		                      
		                                                           
			                                         

		           
	 
 

                                                                                                               
 
       
	                                              
	 
		                                            
	 
      
	                                                                                                      
 

                                                                                         
 
	                                                                         
 

                                                                       
 
	                             
 

                                                        
 
	                                   
 

                                           
 
	                      
 

                                                              
 
	                           

	                 
		                              
 


       
                                 
 
	                              
		      

	                                   

	                         
	 
		                                                   
		                                                 
		                                                      

		                          

		                             
	 
	    
	 
		                                                   
		                                                 
		                                                      

		                         

		                                
	 
 
            


#endif          

int function GetMaxTrackerCountForTitan( entity titan )
{
	array<entity> primaryWeapons = titan.GetMainWeapons()
	if ( primaryWeapons.len() > 0 && IsValid( primaryWeapons[0] ) )
	{
		if ( primaryWeapons[0].HasMod( "pas_lotech_helper" ) )
			return 4
	}

	return 3
}


bool function DoesModExist( entity weapon, string modName )
{
	array<string> mods = GetWeaponMods_Global( weapon.GetWeaponClassName() )
	return mods.contains( modName )
}


bool function DoesModExistFromWeaponClassName( string weaponName, string modName )
{
	array<string> mods = GetWeaponMods_Global( weaponName )
	return mods.contains( modName )
}


bool function IsModActive( entity weapon, string modName )
{
	array<string> activeMods = weapon.GetMods()
	return activeMods.contains( modName )
}


bool function IsWeaponInSingleShotMode( entity weapon )
{
	if ( weapon.GetWeaponSettingBool( eWeaponVar.attack_button_presses_melee ) )
		return false

	if ( !weapon.GetWeaponSettingBool( eWeaponVar.is_semi_auto ) )
		return false

	return weapon.GetWeaponSettingInt( eWeaponVar.burst_fire_count ) == 0
}


bool function IsWeaponInBurstMode( entity weapon )
{
	return weapon.GetWeaponSettingInt( eWeaponVar.burst_fire_count ) > 1
}


bool function IsWeaponOffhand( entity weapon )
{
	switch( weapon.GetWeaponSettingEnum( eWeaponVar.fire_mode, eWeaponFireMode ) )
	{
		case eWeaponFireMode.offhand:
		case eWeaponFireMode.offhandInstant:
		case eWeaponFireMode.offhandHybrid:
			return true
	}
	return false
}


bool function IsWeaponInAutomaticMode( entity weapon )
{
	return !weapon.GetWeaponSettingBool( eWeaponVar.is_semi_auto )
}


bool function OnWeaponAttemptOffhandSwitch_Never( entity weapon )
{
	return false
}

bool function OnWeaponAttemptOffhandSwitch_NoZip( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	if ( player.IsZiplining() )
		return false

	return true
}


#if CLIENT
void function ServerCallback_SetWeaponPreviewState( bool newState )
{
	#if DEV
		entity player = GetLocalClientPlayer()

		if ( newState )
		{
			printt( "Weapon Skin Preview Enabled" )
			player.ClientCommand( "bind LEFT \"WeaponPreviewPrevSkin\"" )
			player.ClientCommand( "bind RIGHT \"WeaponPreviewNextSkin\"" )
			player.ClientCommand( "bind UP \"WeaponPreviewNextCamo\"" )
			player.ClientCommand( "bind DOWN \"WeaponPreviewPrevCamo\"" )

			player.ClientCommand( "bind_held LEFT weapon_inspect" )
		}
		else
		{
			player.ClientCommand( "bind LEFT \"+ability 12\"" )
			player.ClientCommand( "bind RIGHT \"+ability 13\"" )
			player.ClientCommand( "bind UP \"+ability 10\"" )
			player.ClientCommand( "bind DOWN \"+ability 11\"" )

			SetStandardAbilityBindingsForPilot( player )
			printt( "Weapon Skin Preview Disabled" )
		}
	#endif
}
#endif

void function OnWeaponReadyToFire_ability_tactical( entity weapon )
{
	#if SERVER
		                                                                        
	#endif
}


void function OnWeaponRegenEndGeneric( entity weapon )
{
	#if SERVER
		                         
			      
		                                       
	#endif
	#if CLIENT
		entity owner = weapon.GetWeaponOwner()
		if ( !IsValid( owner ) || !owner.IsPlayer() )
			return
		if ( owner.GetOffhandWeapon( OFFHAND_ULTIMATE ) == weapon )
			Chroma_UltimateReady()
	#endif
}


void function Ultimate_OnWeaponRegenBegin( entity weapon )
{
	#if CLIENT
		UltimateWeaponStateSet( eUltimateState.CHARGING )
	#endif
}

#if SERVER
                                                            
 
	                                      
	                                             
		      

	                                
		      

	                              
		      

	                                                           
		                                                      
	                                                                
		                                             
 
#endif

void function PlayDelayedShellEject( entity weapon, float time, int count = 1, bool persistent = false )
{
	AssertIsNewThread()

	weapon.EndSignal( "OnDestroy" )

	asset vmShell      = weapon.GetWeaponSettingAsset( eWeaponVar.fx_shell_eject_view )
	asset worldShell   = weapon.GetWeaponSettingAsset( eWeaponVar.fx_shell_eject_world )
	string shellAttach = weapon.GetWeaponSettingString( eWeaponVar.fx_shell_eject_attach )

	if ( shellAttach == "" )
		return

	for ( int i = 0; i < count; i++ )
	{
		wait time

		if ( !IsValid( weapon ) )
			return
		entity viewmodel = weapon.GetWeaponViewmodel()
		if ( !IsValid( viewmodel ) )
			return
		weapon.PlayWeaponEffect( vmShell, worldShell, shellAttach, persistent )
	}
}



#if SERVER
                                                           
 
	                                                                                     
	                                    
		      

	                                 
 
#endif         


#if SERVER
                                                   
 
	                                 
	                                                                   

	                                                
	 
		                       
		                                        

		                             
		                                                                                                  
		                                                                
		                                                               
		                                                            
		                                                                
		                                                    

		                                                             
		 
			                                                                
			                             
		 
		    
		 
			                                                                
			                                                                                          
		 

		                                  
	 

	                                         
	 
		                                                
	 
	    
	 
		                                                 
	 

	                                                                              
	                                                                                   
	                                                                                  
	 
		                                            
			                                                                                                                  
		    
			                                                                                                                   
	 
 
#endif         


#if SERVER
                                                      
 
	                                                              
	 
		                                                                    

		                                               
		 
			                                          

			                            
				        

			             
			                              
			 
				                                                           
			 
			    
			 
				                                                                   
			 
			                                               

			                                
			 
				                                                                                  
				 
					                                                                         
				 
				    
				 
					                                                                         
					                                                                                  
				 
			 

			                                   
			                                                                                     
				                                                                

			                                    
			                                                                                      
				                                                                  

			                                                
				                                                        
		 

		                                       
	 

	                                                                                                             
	                                                                 
	 
		                                                       
		                                                                         
		                                          
	 
	                                             
	 
		                                                                                              
	 

	                                                                          
 

                                      
                                                                                                                            
 
	                                             
	 
		                                                              

		                                                                                        

		                                                             
		                                                                   
		 
			                                                                        
			                                                             
			                                                  
			 
				                                   
				                                 
			 
		 

		                                                                              
		                                                                                  
		                                                                    
		                                                                                       
		                         
		 
			                                                                          
			                                                   
			 
				                                 
				                                                                                                      
			 
		 
	 
 

                                                                                 
 
	                               
	                               
	                                    

	                        
	                         
	             
	 
		                                                                                
		                          
			      
		                                                                 
		                                                  
			      

		                                                
		                                                                                                                                
		                                                                     
		                       
		                                                                           
		                                          
		 
			                                                                                
			                          
				      
			                                                                 
			                                                  
				      

			                                                 
			                                                  
			                                                        
			                                                                                                                                     
			                                             

			                                                                                              
			                  
				                            

			                                       
				                           
				                   
			 
				                                     
			 
			                                                                                                                          
			 
				                                                   
				 
					                                                                         
					                                                                           

					                                                                                                                          
					                                                                                              

					                  
					 
						                   
							                                                                     
						    
							                                                                         
					 
					                        
					 
						                                                         
					 

					                                                                           
					                                                                                 
					                                
				 
				                                   
			 
			           
		 

		                                                                                                                                                   
		                                   
		           
	 
 

                                                     
 
	                    
		      

	                                                              

	                                                                           
		                                  
 


                         
                                                     
                                                     
                                                     

                                                                                                                               
 
	                        
		      

	                         
		      

	                         
		      

	                                                                                                                  
	 
		                                                                                               
	 
	                                                                                                                                
	 
		                                                                                                
	 
 

                                                                   
 
	                              
 
                                   
#endif         

#if CLIENT
                         
void function UICallback_UpdateLaserSightColor()
{
	Remote_ServerCallFunction( "ClientCallback_UpdateLaserSightColor" )
}
                                   

bool function TryCharacterButtonCommonReadyChecks( entity player )
{
	if ( player != GetLocalViewPlayer() )
		return false
	if ( player != GetLocalClientPlayer() )
		return false
	if ( IsControllerModeActive() )
	{
		if ( TryOnscreenPromptFunction( player, "quickchat" ) )
			return false
	}
                     
	if ( HoverVehicle_PlayerIsDriving( player ) )
		return false
      

	return true
}
#endif          

                                                   
bool function ShouldShowADSScopeView( entity weapon )
{
	if ( !IsValid( weapon ) )
		return false

	if ( !HasFullscreenScope( weapon ) )
		return false

	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( player ) )
		return false

	if ( player.GetZoomFrac() < weapon.GetWeaponSettingFloat( eWeaponVar.ads_fov_zoomfrac_end ) )
		return false

	return true
}


bool function HasFullscreenScope( entity weapon )
{
	if ( !IsValid( weapon ) )
		return false

	if ( weapon.GetWeaponSettingInt( eWeaponVar.bodygroup_ads_scope_set ) <= 0 )
		return false

	if ( weapon.GetWeaponInfoFileKeyField( "bodygroup_ads_scope_name" ) == null )
		return false

	return true
}

#if CLIENT
vector function GetAmmoColorByType( string ammoType )
{
	int colorID  = ammoColors[ammoType]
	vector color = GetKeyColor( colorID ) / 255.0
	return color
}
#endif


bool function EnergyChoke_OnWeaponModCommandCheckMods( entity player, entity weapon, string mod, bool isAdd )
{
	weapon.ForceChargeEndNoAttack()
	weapon.Signal( END_KINETIC_LOADER_CHOKE )
	weapon.RemoveMod( "kinetic_choke" )
	if ( isAdd && weapon.HasMod( KINETIC_LOADER_HOPUP ) && mod == "choke")
	{
		if( !weapon.HasMod( "hopup_kinetic_choke" ) )
		{
			weapon.AddMod( "hopup_kinetic_choke" )
			thread KineticLoaderChokeFunctionality_ServerThink( player, weapon )
		}
	}
	else if ( !isAdd && weapon.HasMod( KINETIC_LOADER_HOPUP ) && mod == "choke")
	{
		weapon.RemoveMod( "hopup_kinetic_choke" )
	}
	return true
}

#if SERVER
                                                      
 
	                                                         
	                          
	 
		                                
		 
			                                  
			 
				                                 
				                                       
			 
			    
			 
				                                                           
				                              
				 
					                                       
					                                
					 
						                                                   
					 
				 
			 
		 
	 
 
#endif

                                                                                                                                                                 
ArcSolution function SolveBallisticArc( vector launchOrigin, float launchSpeed, vector targetOrigin, float gravity, bool lowAngle = true )
{
	ArcSolution as

	             
	                      
	                                 
	  
	                                                                                  
	                                                                                   
	                                                                                       
	                                                                                             
	                                                                                       
	                                               
	  
	                                 
	                                                                                   
	                                                                                                                           
	                     

	vector diff = targetOrigin - launchOrigin
	vector diffXZ =FlattenVec( diff );
	float groundDist = Length( diffXZ );

	float speed2 = launchSpeed*launchSpeed;
	float speed4 = launchSpeed*launchSpeed*launchSpeed*launchSpeed;
	float y = diff.z;
	float x = groundDist;
	float gx = gravity*x;

	float root = speed4 - gravity*(gravity*x*x + 2*y*speed2);

	              
	if (root < 0)
		return as;

	as.valid = true
	root = sqrt( root );

	float lowAng = atan2(speed2 - root, gx)
	float highAng = atan2(speed2 + root, gx)

	float goodAngle = ( lowAngle ) ? lowAng : highAng

	vector groundDir = Normalize( diffXZ )
	as.fire_velocity = ( groundDir * cos( goodAngle ) *launchSpeed ) + ( < 0, 0, 1 > * sin( goodAngle ) * launchSpeed )
	float groundSpeed = Length( FlattenVec( as.fire_velocity ) )
	groundSpeed = ( groundSpeed > 0 ) ? groundSpeed : 1.0
	as.duration = groundDist / groundSpeed

	return as;
}

void function Weapon_AddSingleCharge( entity weapon )
{
	int ammoReq = weapon.GetAmmoPerShot()
	int maxClip = weapon.GetWeaponPrimaryClipCountMax()
	int fullAdd = weapon.GetWeaponPrimaryClipCount() + ammoReq
	int newClip = minint( maxClip, fullAdd )
	weapon.SetWeaponPrimaryClipCount( newClip )

	if ( fullAdd > maxClip )
	{
		int diff = fullAdd - maxClip
		int maxAmmo = weapon.GetWeaponPrimaryAmmoCountMax( AMMOSOURCE_STOCKPILE )
		int fullAmmoAdd = weapon.GetWeaponPrimaryAmmoCount( AMMOSOURCE_STOCKPILE ) + diff
		int newAmmo = minint( maxAmmo, fullAmmoAdd )
		weapon.SetWeaponPrimaryAmmoCount( AMMOSOURCE_STOCKPILE, newAmmo )
	}
}

#if SERVER || CLIENT
bool function AreAbilitiesSilenced( entity player )
{
	if ( !IsValid( player ) )
		return true

	if ( StatusEffect_GetSeverity( player, eStatusEffect.silenced ) )
		return true
	if ( StatusEffect_GetSeverity( player, eStatusEffect.is_boxing ) )
		return true

	return false
}
#endif

int function GetNeededEnergizeConsumableCount( entity weapon, entity player )
{
	string weaponRef = weapon.GetWeaponClassName()
	string consumableRef = GetWeaponInfoFileKeyField_GlobalString ( weaponRef, "energized_consumable" )
	int consumableRequiredCount = GetWeaponInfoFileKeyField_GlobalInt ( weaponRef, "energized_consumable_needed_amount" )

	int requiredCountWithPassive = consumableRequiredCount
	                                                      
	{
		if ( consumableRef == "health_pickup_combo_small" )
			requiredCountWithPassive = player.HasPassive( ePassives.PAS_BONUS_SMALL_HEAL ) ? maxint( 0, consumableRequiredCount - 1 ) : consumableRequiredCount
	}

	return requiredCountWithPassive
}

bool function HasEnoughEnergizeConsumable( entity weapon, entity player )
{
	string weaponRef = weapon.GetWeaponClassName()
	string consumableRef = GetWeaponInfoFileKeyField_GlobalString ( weaponRef, "energized_consumable" )
	int consumableRequiredCount = GetNeededEnergizeConsumableCount( weapon, player )
	int consumableCurrentCount = SURVIVAL_CountItemsInInventory( player, consumableRef )
	return consumableCurrentCount >= consumableRequiredCount
}

bool function OnWeaponTryEnergize( entity weapon, entity player )
{
	if ( !IsValid( player ) )
		return false

	if ( !IsValid( weapon ) )
		return false

	if( !HasEnoughEnergizeConsumable( weapon, player ) )
	{
		#if CLIENT
		string weaponName = weapon.GetWeaponClassName()
		int consumableRequiredCount = GetNeededEnergizeConsumableCount( weapon, player )
		string consumableName = GetWeaponInfoFileKeyField_GlobalString( weaponName, consumableRequiredCount > 1 ? "energized_consumable_name_plural" : "energized_consumable_name_singular" )
		string pingStringData = GetWeaponInfoFileKeyField_GlobalString ( weaponName, "energized_consumable_required_hint" )

		                                                                                  
		if( weaponName == "mp_weapon_dragon_lmg"  )
			AnnouncementMessageRight( player, Localize( pingStringData, Localize( consumableName ) ) )
		else
			AnnouncementMessageRight( player, Localize( pingStringData, consumableRequiredCount, Localize( consumableName ) ) )

		string commsData = GetWeaponInfoFileKeyField_GlobalString ( weaponName, "energized_comms" )
		Quickchat( player, eCommsAction[commsData] )
		#endif

		return false
	}

	return true
}

void function OnWeaponEnergizedStart( entity weapon, entity player )
{
	if ( !IsValid( weapon ) )
		return

	string weaponRef = weapon.GetWeaponClassName()
	string consumableRef = GetWeaponInfoFileKeyField_GlobalString ( weaponRef, "energized_consumable" )
	int consumableRequiredCount = GetNeededEnergizeConsumableCount( weapon, player )
	SURVIVAL_RemoveFromPlayerInventory( player, consumableRef, consumableRequiredCount )
}

#if CLIENT
void function DisplayCenterDotRui( entity weapon, string abortSignal, float appearDelay, float duration, float dotAlpha, float fadeInDuration, float fadeOutDuration )
{
	AssertIsNewThread()
	if ( !IsValid( weapon ) )
		return
	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( player ) )
		return

	player.EndSignal( "OnDeath" )
	weapon.EndSignal( "OnDestroy" )
	weapon.EndSignal( abortSignal )

	var rui = CreateCockpitPostFXRui( $"ui/crosshair_single_dot_helper.rpak" )
	RuiSetBool( rui, "isActive", false )

	OnThreadEnd(
		function() : ( rui, weapon, player )
		{
			RuiDestroy( rui )
		}
	)

	wait appearDelay

	if ( !IsValid( weapon ) )
		return

	float endTime = Time() + duration

	RuiSetBool( rui, "isActive", true )
	RuiSetFloat( rui, "birthTime", Time() )
	RuiSetFloat( rui, "deathTime", endTime )
	RuiSetFloat( rui, "dotAlpha", dotAlpha )
	RuiSetFloat( rui, "fadeInDuration", fadeInDuration )
	RuiSetFloat( rui, "fadeOutDuration", fadeOutDuration )

	while ( Time() < endTime )
	{
		WaitFrame()
	}

	RuiSetBool( rui, "isActive", false )
}
#endif

                                                                                         
  
  	               
  
                                                                                         
          
                                                                                                                                                      
          

bool function MarksmansTempo_Validate( entity weapon, MarksmansTempoSettings settings )
{
	#if CLIENT
		if ( !InPrediction() )
			return weapon.HasMod( MOD_MARKSMANS_TEMPO )
	#endif

	if ( !weapon.HasMod( MOD_MARKSMANS_TEMPO ) )
	{
		MarksmansTempo_RemoveTempo( weapon, settings )
		return false
	}

	return true
}

void function MarksmansTempo_OnActivate( entity weapon, MarksmansTempoSettings settings )
{
	AssertIsNewThread()
	weapon.EndSignal( "OnDestroy" )

	#if CLIENT
		if ( !InPrediction() )
			return
	#endif

	#if SERVER
		                                                                          
			                                                                
		                                                                           
			                                                                 
	#endif

	WaitFrame()	                                                                                                                                              

	bool valid = MarksmansTempo_Validate( weapon, settings )
	#if SERVER
	            
	 
		                                                       
		                         
	 
	#endif

}

void function MarksmansTempo_OnDeactivate( entity weapon, MarksmansTempoSettings settings )
{
	#if CLIENT
	if ( !InPrediction() )
		return
	#endif

	if ( MarksmansTempo_Validate( weapon, settings ) )
		MarksmansTempo_ClearTempo( weapon, settings )
}

void function MarksmansTempo_AbortFadeoff( entity weapon, MarksmansTempoSettings settings )
{
	weapon.Signal( MARKSMANS_TEMPO_FADEOFF_THREAD_ABORT )
}

void function MarksmansTempo_SetPerfectTempoMoment( entity weapon, MarksmansTempoSettings settings, entity player, float time, bool useOnPerfectMomentFadeoff )
{
	#if CLIENT
		if ( !InPrediction() )
			return
	#endif

	if ( weapon.HasMod( MOD_MARKSMANS_TEMPO ) && (!IsClient() || InPrediction()) )
	{
		weapon.SetScriptTime1( time )

		if ( useOnPerfectMomentFadeoff )
		{
			weapon.Signal( MARKSMANS_TEMPO_FADEOFF_THREAD_ABORT )
			float fadeoffDelay = time - Time()
			float fadeoffTime
			if ( settings.fadeoffMatchGraceTime > 0 )
				fadeoffTime = weapon.HasMod( MOD_MARKSMANS_TEMPO_ACTIVE ) ? settings.graceTimeInTempo : settings.graceTimeBuildup
			else
				fadeoffTime = settings.fadeoffOnPerfectMomentHit
			thread MarksmansTempo_Fadeoff( weapon, settings, fadeoffTime + fadeoffDelay )
		}
	}
}

void function MarksmansTempo_Fadeoff( entity weapon, MarksmansTempoSettings settings, float fadeTime )
{
	AssertIsNewThread()
	weapon.EndSignal( "OnDestroy" )
	weapon.EndSignal( settings.weaponDeactivateSignal )
	weapon.EndSignal( MARKSMANS_TEMPO_FADEOFF_THREAD_ABORT )

	wait fadeTime
	MarksmansTempo_ClearTempo( weapon, settings )
}

void function MarksmansTempo_OnFire( entity weapon, MarksmansTempoSettings settings, bool useOnFireFadeoff )
{
	#if CLIENT
		if ( !InPrediction() )
			return
	#endif

	weapon.RemoveMod( MOD_MARKSMANS_TEMPO_BUILDUP )
	weapon.Signal( MARKSMANS_TEMPO_FADEOFF_THREAD_ABORT )
	if ( MarksmansTempo_Validate( weapon, settings ) )
	{
		float graceTime = weapon.HasMod( MOD_MARKSMANS_TEMPO_ACTIVE ) ? settings.graceTimeInTempo : settings.graceTimeBuildup
		if ( Time() <= weapon.GetScriptTime1() + graceTime  )
		{
			int newShotCount = minint( weapon.GetScriptInt1() + 1, settings.requiredShots )
			weapon.SetScriptInt1( newShotCount )
			if ( newShotCount >= settings.requiredShots )
			{
				weapon.AddMod( MOD_MARKSMANS_TEMPO_ACTIVE )
			}

			if ( !weapon.HasMod( MOD_MARKSMANS_TEMPO_ACTIVE ) )
			{
				weapon.AddMod( MOD_MARKSMANS_TEMPO_BUILDUP )
			}

			if ( useOnFireFadeoff )
				thread MarksmansTempo_Fadeoff( weapon, settings, settings.fadeoffOnFire )
		}
		else
		{
			MarksmansTempo_ClearTempo( weapon, settings )
		}
	}
}

void function MarksmansTempo_ClearTempo( entity weapon, MarksmansTempoSettings settings )
{
	#if CLIENT
		if ( !InPrediction() )
			return
	#endif

	weapon.SetScriptInt1( 0 )
	MarksmansTempo_ClearMods( weapon )
}

void function MarksmansTempo_RemoveTempo( entity weapon, MarksmansTempoSettings settings )
{
	#if CLIENT
		if ( !InPrediction() )
			return
	#endif

	weapon.SetScriptInt1( -1 )                                                                                                               
	MarksmansTempo_ClearMods( weapon )
}

void function MarksmansTempo_ClearMods( entity weapon )
{
	weapon.RemoveMod( MOD_MARKSMANS_TEMPO_ACTIVE )
	weapon.RemoveMod( MOD_MARKSMANS_TEMPO_BUILDUP )
}



                                                                                         
  
  	              
  
                                                                                         
          
                                                                                                                                  
          
                                                                                
void function ShatterRounds_OnPlayerAddedWeaponMod( entity player, entity weapon, string mod )
{
	if ( mod != SHATTER_ROUNDS_HIPFIRE_MOD )
		return

	if ( !IsValid( weapon ) )
		return

	ShatterRounds_AddShatterRounds( weapon )
}

                                                                                
void function ShatterRounds_OnPlayerRemovedWeaponMod( entity player, entity weapon, string mod )
{
	if ( mod != SHATTER_ROUNDS_HIPFIRE_MOD )
		return

	if ( !IsValid( weapon ) )
		return

	ShatterRounds_RemoveShatterRounds( weapon )
}

                                                                                                                     
void function ShatterRounds_UpdateShatterRoundsThink( entity weapon )
{
	AssertIsNewThread()
	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( player ) )
		return

	player.EndSignal( "OnDeath" )
	weapon.EndSignal( SHATTER_ROUNDS_THINK_END_SIGNAL )
	weapon.EndSignal( "OnDestroy" )

	Assert( eShatterRoundsTypes._count == 2 )

	WaitFrame()		                                                                                                                                                             

	int curState = -1
	while ( true )
	{
		if ( !IsValid( player ) || !IsValid( weapon ) )
			return

		if ( weapon.HasMod( SHATTER_ROUNDS_HIPFIRE_MOD ) && curState != 0 )
		{
			ShatterRounds_AddShatterRounds( weapon )
			curState = 0
		}
		else if ( !weapon.HasMod( SHATTER_ROUNDS_HIPFIRE_MOD ) && curState != 1 )
		{
			ShatterRounds_RemoveShatterRounds( weapon )
			curState = 1
		}

		WaitFrame()
	}
}

void function ShatterRounds_AddShatterRounds( entity weapon )
{
	#if SERVER
		                                                                
			                                                       
	#endif
	#if CLIENT
		if ( weapon.GetWeaponClassName() == "mp_weapon_bow" )
			WeaponBow_UpdateArrowColor( weapon, eShatterRoundsTypes.SHATTER_TRI )

	#endif
}

void function ShatterRounds_RemoveShatterRounds( entity weapon )
{
	#if SERVER
		                                                             
			                                                    
	#endif
	#if CLIENT
		if ( weapon.GetWeaponClassName() == "mp_weapon_bow" )
			WeaponBow_UpdateArrowColor( weapon, eShatterRoundsTypes.STANDARD )
	#endif
}
#if SERVER
                                                                     
 
	                   
	                             
	                               
	                                                                

	            
		                               
		 
			                        
				                                              
		 
	 

	              
	 
		                                               
			      

			                                                                           
		 
			                                                  
			 
				                                              
				                                           
			 
		 
		                                                         
		 
			                                           
			                                        
		 

		                                                 
		 
			      
		 

		           
	 
 
#endif

#if SERVER
                                                                                                                                
 
	                        
		      

	                         
		      

	                         
		      

	                                             
	 
		                                             
		 
			                                                
		 
	 

 
#endif

                      
void function OnWeaponActivate_Smart_Reload ( entity weapon, SmartReloadSettings settings )
{
	if ( !IsValid( weapon ) )
		return

	entity player = weapon.GetWeaponOwner()

	if ( IsValid( player ) )
	{
		#if CLIENT
		int slot = GetSlotForWeapon( player, weapon )
		if ( slot >= 0 )
			weapon.w.activeOptic = SURVIVAL_GetWeaponAttachmentForPoint( player, slot, "sight" )
		else
			weapon.w.activeOptic = ""
		#endif
		ApplySmartReloadFunctionality ( player, weapon, settings )
	}
}

void function ApplySmartReloadFunctionality ( entity player, entity weapon, SmartReloadSettings settings )
{
#if SERVER
	                                                                             
#endif
#if CLIENT
	thread ApplySmartReloadFunctionality_ClientThink ( player, weapon, settings )
#endif
}

void function OnWeaponReload_Smart_Reload ( entity weapon, int milestoneIndex )
{
	LootData weaponLootData = SURVIVAL_Loot_GetLootDataByRef( weapon.GetWeaponClassName() )

	SmartReloadSettings settings
	settings.OverloadedAmmo				 = GetWeaponInfoFileKeyField_GlobalInt( weaponLootData.baseWeapon, OVERLOAD_AMMO_SETTING )

	entity player = weapon.GetWeaponOwner()
	int clipCount = weapon.GetWeaponPrimaryClipCount()
	int maxClipCount = weapon.GetWeaponPrimaryClipCountMax ()
	int maxClipWithoutOverloadedAmmo = maxClipCount - settings.OverloadedAmmo
	int overFlowAmmo = clipCount - maxClipWithoutOverloadedAmmo
	string ammoType = AmmoType_GetRefFromIndex( weapon.GetWeaponAmmoPoolType() )
	int ammoPoolType = eAmmoPoolType[ ammoType ]


	if ( !weapon.HasMod( SMART_RELOAD_HOPUP ) )
	{
		weapon.RemoveMod( LMG_OVERLOADED_AMMO_MOD )
		weapon.RemoveMod( LMG_FAST_RELOAD_MOD )
	}

	if ( weapon.HasMod( LMG_FAST_RELOAD_MOD ) )
	{
		#if CLIENT
		if ( !IsValid( player ) || !IsLocalViewPlayer( player ) )
			return

		EmitSoundOnEntity( player, "UI_InGame_BoostedLoader_Reload" )
		#endif
	}
	else
	{
		#if SERVER
		                                                                                               
		 
			                                                                                        

			                                                                  
			                      
			 
				                                                                                                      
				                                                                

				                                                        
				                                               
			 
			    
			 
				                                                            
				                                                                      
			 
		 
		#endif

		weapon.RemoveMod( LMG_OVERLOADED_AMMO_MOD )
	}
}

#if SERVER
                                                                                                                                
 
	                                             
	 
			                                     
			 
				                                                                                     
				                            

				                                                                                                                  
				                                                                                                               

				                                 

				                                                 
			 
		 
 

#endif
void function OnWeaponDeactivate_Smart_Reload ( entity weapon )
{
	weapon.Signal ( END_SMART_RELOAD )
	entity player = weapon.GetWeaponOwner()

	if( !IsValid( weapon ) || !IsValid( player) )
		return

	#if SERVER
	                                                                                                                               
	 
		                                           
		                                                                                  
	 
	#endif
}

void function ApplySmartReloadFunctionality_ClientThink ( entity player, entity weapon, SmartReloadSettings settings )
{
	#if CLIENT
		AssertIsNewThread()
		weapon.EndSignal( "OnDestroy" )
		weapon.EndSignal( END_SMART_RELOAD )

		if ( !IsValid( player ) || !IsLocalViewPlayer( player ) )
			return
		player.EndSignal( "OnDeath" )

		vector lowAmmoColor      = SrgbToLinear( LOWAMMO_UI_COLOR )
		vector normalAmmoColor   = SrgbToLinear( NORMALAMMO_UI_COLOR )
		vector overloadAmmoColor = SrgbToLinear( OVERLOADAMMO_UI_COLOR )
		vector outofAmmoColor    = SrgbToLinear( OUTOFAMMO_UI_COLOR )

		int clipCount
		int maxClipCount
		int overloadClipCount
		int maxAmmoRequiredCount
		float clipCountFrac = 1.0
		float offset = 0.05
		var rui = ClWeaponStatus_GetWeaponHudRui( player )
		var reloadRui = GetAmmoStatusHintRui()
		var crosshairRui = CreateCockpitPostFXRui( $"ui/ammo_status_hint.rpak", HUD_Z_BASE )
		var chargeBarRui = CreateCockpitPostFXRui( $"ui/crosshair_reload_hopup_bar.rpak" )

		OnThreadEnd(
			function() : ( player, weapon, rui, reloadRui, crosshairRui, chargeBarRui )
			{
				RuiDestroy( crosshairRui )
				RuiDestroy( chargeBarRui )
				RuiSetBool( reloadRui, "showHopupReloadIcon", false )
				RuiSetFloat3( rui, "ammoGlowColor", SrgbToLinear( NORMALAMMO_UI_COLOR ) )
			}
		)

		while ( true )
		{
			clipCount = weapon.GetWeaponPrimaryClipCount()
			maxClipCount = weapon.GetWeaponPrimaryClipCountMax()
			overloadClipCount = maxClipCount - settings.OverloadedAmmo
			maxAmmoRequiredCount = int( maxClipCount * settings.LowAmmoFrac)
			clipCountFrac = float( clipCount) / float( maxClipCount )

			if ( weapon.HasMod( LMG_FAST_RELOAD_MOD ) && weapon.IsReloading() )
			{
				RuiSetFloat3( chargeBarRui, "bracketColor", normalAmmoColor )
				RuiSetBool( crosshairRui, "showFastReloadText", true )
				RuiSetBool( crosshairRui, "showHopupReloadBG", true )
				RuiSetBool( reloadRui, "showHopupReloadIcon", false )
			}
			else if ( weapon.HasMod( SMART_RELOAD_HOPUP ) && weapon.HasMod( LMG_OVERLOADED_AMMO_MOD ) && clipCount > overloadClipCount )
			{
				RuiSetFloat3( rui, "ammoGlowColor", overloadAmmoColor )
				RuiSetFloat3( chargeBarRui, "bracketColor", overloadAmmoColor )
				RuiSetBool( crosshairRui, "showFastReloadText", false )
				RuiSetBool( crosshairRui, "showHopupReloadBG", false )
				RuiSetBool( reloadRui, "showHopupReloadIcon", false )
				RuiSetBool( chargeBarRui, "showExtraAmmo", true )
			}
			else if ( weapon.HasMod( SMART_RELOAD_HOPUP ) && clipCount > MIN_AMMO_REQUIRED && clipCount <= maxAmmoRequiredCount )
			{
				RuiSetFloat3( rui, "ammoGlowColor", lowAmmoColor )
				RuiSetFloat3( chargeBarRui, "bracketColor", lowAmmoColor )
				RuiSetBool( reloadRui, "showHopupReloadIcon", true )
				RuiSetBool( crosshairRui, "showFastReloadText", false )
				RuiSetBool( crosshairRui, "showHopupReloadBG", false )
			}
			else if ( weapon.HasMod( SMART_RELOAD_HOPUP ) && clipCount == 0 )
			{
				RuiSetFloat3( chargeBarRui, "bracketColor", outofAmmoColor )
				RuiSetBool( crosshairRui, "showFastReloadText", false )
				RuiSetBool( reloadRui, "showHopupReloadIcon", false )
				RuiSetBool( crosshairRui, "showHopupReloadBG", false )
				RuiSetBool( chargeBarRui, "showExtraAmmo", false )
			}
			else
			{
				RuiSetFloat3( chargeBarRui, "bracketColor", normalAmmoColor )
				RuiSetFloat3( rui, "ammoGlowColor", normalAmmoColor )
				RuiSetBool( crosshairRui, "showFastReloadText", false )
				RuiSetBool( reloadRui, "showHopupReloadIcon", false )
				RuiSetBool( crosshairRui, "showHopupReloadBG", false )
				RuiSetBool( chargeBarRui, "showExtraAmmo", false )
			}

			if ( weapon.HasMod( SMART_RELOAD_HOPUP ) )
			{
				RuiSetBool( chargeBarRui, "isActive", true )
				RuiSetFloat( chargeBarRui, "energizeFrac", clipCountFrac )
				RuiSetFloat( chargeBarRui, "adsFrac", player.GetZoomFrac() )

				switch ( weapon.w.activeOptic )
				{
					case "":	            
					offset = 0.05
					break
					case "optic_cq_hcog_classic":
						offset = 0.08
						break
					case "optic_cq_holosight":
						offset = 0.11
						break
					case "optic_cq_hcog_bruiser":
						offset = 0.09
						break
					case "optic_cq_holosight_variable":
						offset = 0.09
						break
					case "optic_ranged_hcog":
						offset = 0.11
						break
					case "optic_ranged_aog_variable":
						offset = 0.14
						break
					case "optic_cq_threat":
						offset = 0.07
						break
				}
				RuiSetFloat( chargeBarRui, "offset", offset )
			}
			WaitFrame()
		}
	#endif
}

void function ApplySmartReloadFunctionality_ServerThink ( entity player, entity weapon, SmartReloadSettings settings )
{
	#if SERVER
		                   
		                               
		                                    
		                             

		              
		 
			                                                  
			                                                         
			                                                                    
			                                                              

			                                                                                                                
			 
				                                    
				                                        
			 
			                                                                                                                             
				                                           
			    
				                                       

			           
		 
	#endif
}

bool function IsTurretWeapon( entity weapon )
{
	if( !IsValid( weapon ) || !weapon.IsWeaponX() )
		return false

	return ( GetWeaponInfoFileKeyField_GlobalInt_WithDefault( weapon.GetWeaponClassName(), "is_turret_weapon" , 0 ) == 1 )
}

bool function IsHMGWeapon( entity weapon )
{
	if( !IsValid( weapon ) || !weapon.IsWeaponX() )
		return false

	return ( GetWeaponInfoFileKeyField_GlobalInt_WithDefault( weapon.GetWeaponClassName(), "is_hmg_weapon" , 0 ) == 1 )
}


void function OnWeaponActivate_Kinetic_Loader( entity weapon)
{
	if ( !IsValid( weapon ) )
		return

	if( !weapon.IsWeaponX() )
		return

	entity player = weapon.GetWeaponOwner()

	if ( IsValid( player ) )
	{
		if ( weapon.HasMod ( KINETIC_LOADER_HOPUP ) )
		{
			#if CLIENT
			if ( InPrediction() )
			#endif
			{
				                                                            
				if ( weapon.HasMod( "hopup_kinetic_choke" ) && weapon.HasMod( "kinetic_choke" ) )
				{
						weapon.RemoveMod( "kinetic_choke" )
				}
			}

			ApplyKineticLoaderFunctionality( player, weapon )
		}

	}
}

void function OnWeaponDeactivate_Kinetic_Loader( entity weapon )
{
	weapon.Signal( END_KINETIC_LOADER )
	weapon.Signal( END_KINETIC_LOADER_CHOKE )

	#if CLIENT
	weapon.Signal( END_KINETIC_LOADER_RUI )
	#endif
}

void function ApplyKineticLoaderFunctionality( entity player, entity weapon )
{
	weapon.Signal( END_KINETIC_LOADER )
	weapon.Signal( END_KINETIC_LOADER_CHOKE )

	#if SERVER
		                                                               
		                                                                    
	#endif

	#if CLIENT
		weapon.Signal( END_KINETIC_LOADER_RUI )
		thread ApplyKineticLoader_ClientThink( player, weapon )
	#endif
}

void function KineticLoaderChokeFunctionality_ServerThink( entity player, entity weapon )
{
	#if SERVER
		                             
		                               
		                                            

		           

		                                               
			      

		                                                
		 
			                                             
			 
				                                   
				     
			 

			                                                
			 
				                                             
				 
					                                                                         

					                     
					 
						                                 
						 
							                               

							                                        
								                                
						 
					 
					                           
					 
						                                   
						     
					 
				 
				           
			 
			                        
			                                                                                                  
			 
				           
			 
			                               
			    
			 
				                                  
				 
					                                                                  
				 
				           
			 
		 
	#endif
}
void function KineticLoaderFunctionality_ServerThink( entity player, entity weapon )
{
	#if SERVER
		                             
		                               
		                                      

		                                              
			      

		                                                                            
		                                            

		                                                                                       

		                              
		                  				                                                                                                    
		                      			                                                                                                             
		                 				                                                                                                        
		                   				                                                                                                     
		                          		                                                                                                 

		         
		                                    
		                       

		                                               
		 
			                                                                                        
			                         
			 
				                

				                                              
					      

				                                             
				                                                                                                                          
				 

					                                            
					                                                                                                                                                                      

					                                         
					                                                            
					                                                                                      

					                                                                                 
					 

						                                                                          

						                                                    
						                    
							                                                                    

						                
						                                                                                   

						                                                                                                          
						 
							                                   
						 

						                                                                   
						                                                                                                            

						                
						       
						                                                                                                    
					 
				 
			 
			                        
			                              
			 
				           
			 
			                               
			    
			 
				         
				                              
				                   
				                                                                                              
				           
			 
		 
	#endif
}
void function KineticLoaderChokeGraceWindow_ServerThink( entity player, entity weapon )
{
	#if SERVER
		                             
		                               
		                                            
		                                             
		                        

		                                             
			      

		                                                
		 
			                                                                                      
			 
				                                   
				     
			 

			                                                                    
			 
				                                            
				 
					                                
				 
			 

			                         
				     

			                                                       
			 
				                         
				 
					     
				 
				    
				 
					                                                                         

					                     
					 
						                                 
						 
							                                       
								                                   

							     
						 
					 
					                           
					 
						                                   
						     
					 

					           
				 
			 
			    
			 
				           
			 
		 
	#endif
}

#if SERVER
                                                                                                                                  
 
	                        
		      

	                         
		      

	                         
		      

	                                                                                                                     
	 
		                                            

		                                          
	 

	                                       
	 
		                                                                  
		 
			                                             
				                                      
		 


	 
	                                               
	 
		                                        
		                                   

		                                            
	 

 

#endif

#if CLIENT
void function ServerCallback_KineticLoaderReloadedThroughSlide( int ammoToLoadTotal )
{
	file.ammoToLoadTotal = ammoToLoadTotal
	file.reloadedThroughSlide = true
}
void function ServerCallback_KineticLoaderReloadedThroughSlideEnd()
{
	file.ammoToLoadTotal = 0
	file.reloadedThroughSlide = false
}
#endif

void function ApplyKineticLoader_ClientThink( entity player, entity weapon )
{
	#if CLIENT
		AssertIsNewThread()
		weapon.EndSignal( "OnDestroy" )
		weapon.EndSignal( END_KINETIC_LOADER_RUI )

		if ( !IsValid( player ) || !IsLocalViewPlayer( player ) )
			return

		player.EndSignal( "OnDeath" )

		vector lowAmmoColor      = SrgbToLinear( OVERLOADAMMO_UI_COLOR )
		vector normalAmmoColor   = SrgbToLinear( NORMALAMMO_UI_COLOR )

		var rui = ClWeaponStatus_GetWeaponHudRui( player )
		var crosshairRui = CreateCockpitPostFXRui( $"ui/ammo_status_hint.rpak", HUD_Z_BASE )

		OnThreadEnd(
			function() : ( player, weapon, crosshairRui )
			{
				RuiDestroy( crosshairRui )
				file.ammoToLoadTotal = 0
				file.reloadedThroughSlide = false
			}
		)

		if (!IsValid( weapon ) || !IsValid( player ) )
			return

		while ( IsValid( weapon ) && IsValid( player ))
		{
			if ( file.reloadedThroughSlide )
			{
				string ammoToLoadSting = Localize( "#WPN_HOPUP_KINETIC_LOADER_RELOAD_HINT", file.ammoToLoadTotal )
				RuiSetString( crosshairRui, "ammoToLoadString", ammoToLoadSting )
				RuiSetFloat3( rui, "ammoGlowColor", lowAmmoColor )
				RuiSetBool( crosshairRui, "showKineticReloadText", true )
				RuiSetBool( crosshairRui, "showHopupKineticReloadBG", true )
			}
			else
			{
				RuiSetFloat3( rui, "ammoGlowColor", normalAmmoColor )
				RuiSetBool( crosshairRui, "showKineticReloadText", false )
				RuiSetBool( crosshairRui, "showHopupKineticReloadBG", false )
			}

			WaitFrame()
		}
	#endif
}

                          
                                                   
 
                          
        

                                                                
                                                             

                        
        

                                            
   
                                             
                                                                               
                                               
                                                

                                              
                                                                                                                                                     

                                           
                                                                
                                                                                        

                                                                                                      
   
                             
                       
                                                                          

                        
                                                                                      

             
                                                                                            
                                                                          
         
   
  

 


                                              
 
           
                                           
                                                                                  
       
 
      

               
#if SERVER || CLIENT
bool function GetInfiniteAmmo( entity weapon )
{
	                         
	return weapon.HasMod( MOD_INFINITE_AMMO_CLIPS )
}

#if SERVER
                                                                                                                                                          
 
	                                                                             
		            

	                                                                                                  
 

                                                                                                                                                                                    
 
	                               
		            

	                                         
	                                                                              

	                       
		                                                                                                        

	                            
 

                                                                                                                                                                                      
 
	                               
		            

	                                                 
	                                                                                              
	                                                                                                               

	                       
		                                                                                                                

	                                    

 

                                                                                                                            
 
	                          
	                                                                                                        
	                                              
	 
		                                              
		                                                 
			        
		                                                                                                              
	 
	                                                                                                                
 

                                                                                                                                             
 
	       
		                                        
	      

	                                                

	                                                                                            
	                  
	 
		                                             

		                                                                                                        
		                                                                                                       
		                                                                                                       

		                         
		                                    
		 
			                                                                                                           
			                                                           
				                    
			    
				                   
		 

		                                                                           
		                            
		 
			                                                                           
			                                                   
				                    
			    
				                   
		 

		                         
		 
			                                                                                      
			                                          
				                    
			                                                            
				                   
		 

		                                                                       
		                        
			                    

		                                       
		                           
		 
			                                               
			 
				                                                                     
				                    
				                   
			 
			    
				                    
		 
	 
	    
	 
		                                                             
		                           
		 
			                    
		 
	 

	                                                                                                  
	                                                 

	                                   
	                   
	 
		                       
		 
			                   
				                                        
			                                                     
				                                                                                              
		 

		                                                
			                                        

		                       
			                                                                                                                     

		                                                                                       
			                                                             

		                                                                                  
	 
	    
	 
		                                               
			                                           

		                       
		 
			                   
				                                                                                                        
			                                                     
			 
				                                                                                             
				                                        
			 
		 
		                                                                      
			                                                                        

		                                                                                  
	 

	                                
 

       
                                                                                                             
 
	                                                                                        
 

                                                             
 
	                                                
	                                                      
	                                                                                                        
	                                                                                                       
	                                                                                                       
	                           			                        
	                          			                       
	                          			                       
	                        			                                              
 
      

#endif

#endif               