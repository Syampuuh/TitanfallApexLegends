                                                                                                                                                                                                      
global function MpWeaponSentinel_Init
global function OnWeaponActivate_weapon_sentinel
global function OnWeaponDeactivate_weapon_sentinel
global function OnWeaponPrimaryAttack_weapon_sentinel

global const string SENTINEL_USE_ENERGIZE_PLAYLIST_VAR = "sentinel_use_energize"
const string SENTINEL_SHOW_CROSSHAIR_ENERGIZE_PLAYLIST_VAR = "sentinel_show_crosshair_energize_status"

const string SENTINEL_CLASS_NAME = "mp_weapon_sentinel"

const string SENTINEL_DEACTIVATE_SIGNAL = "SentinelDeactivate"

const float SENTINEL_RECHAMBER_READY_TO_FIRE_FRAC = 50.0 / 63.0	                                                                 

const string ENERGIZED_MOD = "energized"

const string RECHAMBER_RUI_ABORT_SIGNAL = "SentinelRechamberRuiAbort"
const string RECHAMBER_RUI_END_EVENT_ANIM = "rechamber"
const string RECHAMBER_RUI_END_EVENT = "hide_rechamber_dot"

const asset ENERGIZED_CROSSHAIR_RUI = $"ui/crosshair_energize_status_sentinel.rpak"
const asset AMMO_ENERGIZED_ICON = $"rui/hud/gametype_icons/survival/sur_ammo_sniper_charged"
const asset ENERGIZE_UI_CONSUMABLE_ICON = $"rui/hud/loot/loot_stim_shield_small"

struct
{
	bool fileStructInitialized = false

	MarksmansTempoSettings& sentinelTempoSettings
} file

                                                                                         
  
  	                               
  
                                                                                         
void function MpWeaponSentinel_Init()
{
	PrecacheWeapon( SENTINEL_CLASS_NAME )

	RegisterSignal( SENTINEL_DEACTIVATE_SIGNAL )

	RegisterSignal( RECHAMBER_RUI_ABORT_SIGNAL )

	RegisterSignal( ENERGIZE_STATUS_RUI_ABORT_SIGNAL )	              

	#if SERVER
		                                         
	#endif         
}

void function OnWeaponActivate_weapon_sentinel( entity weapon )
{

	                                                                             
	if ( !file.fileStructInitialized )
	{
		file.fileStructInitialized = true

		MarksmansTempoSettings settings
		settings.requiredShots             = GetWeaponInfoFileKeyField_GlobalInt( SENTINEL_CLASS_NAME, MARKSMANS_TEMPO_REQUIRED_SHOTS_SETTING )
		settings.graceTimeBuildup          = GetWeaponInfoFileKeyField_GlobalFloat( SENTINEL_CLASS_NAME, MARKSMANS_TEMPO_GRACE_TIME_SETTING )
		settings.graceTimeInTempo          = GetWeaponInfoFileKeyField_GlobalFloat( SENTINEL_CLASS_NAME, MARKSMANS_TEMPO_GRACE_TIME_IN_TEMPO_SETTING  )
		settings.fadeoffMatchGraceTime 	   = GetWeaponInfoFileKeyField_GlobalInt( SENTINEL_CLASS_NAME, MARKSMANS_TEMPO_FADEOFF_MATCH_GRACE_TIME )
		settings.fadeoffOnPerfectMomentHit = GetWeaponInfoFileKeyField_GlobalFloat( SENTINEL_CLASS_NAME, MARKSMANS_TEMPO_FADEOFF_ON_PERFECT_MOMENT_SETTING )
		settings.fadeoffOnFire             = GetWeaponInfoFileKeyField_GlobalFloat( SENTINEL_CLASS_NAME, MARKSMANS_TEMPO_FADEOFF_ON_FIRE_SETTING )
		settings.weaponDeactivateSignal    = SENTINEL_DEACTIVATE_SIGNAL
		file.sentinelTempoSettings         = settings
	}

	thread MarksmansTempo_OnActivate( weapon, file.sentinelTempoSettings )

	if ( !GetCurrentPlaylistVarBool( SENTINEL_USE_ENERGIZE_PLAYLIST_VAR, true ) )
		return

	entity player = weapon.GetWeaponOwner()
	#if SERVER
		                                                             
			                                                   
	#endif

	#if CLIENT
		if ( IsValid( player ) )
		{
			int slot = GetSlotForWeapon( player, weapon )
			if ( slot >= 0 )
				weapon.w.activeOptic = SURVIVAL_GetWeaponAttachmentForPoint( player, slot, "sight" )
			else
				weapon.w.activeOptic = ""

			thread UpdateWeaponEnergizeRui( player, weapon, ENERGIZED_CROSSHAIR_RUI, ENERGIZE_UI_CONSUMABLE_ICON, AMMO_ENERGIZED_ICON )
		}
	#endif
}

void function OnWeaponDeactivate_weapon_sentinel( entity weapon )
{
	if ( !GetCurrentPlaylistVarBool( SENTINEL_USE_ENERGIZE_PLAYLIST_VAR, true ) )
		return

	weapon.Signal( SENTINEL_DEACTIVATE_SIGNAL )

	if ( IsServer() || ( IsClient() && InPrediction() && IsFirstTimePredicted()) )
		weapon.SetWeaponChargeFraction( 0.0 )

	MarksmansTempo_OnDeactivate( weapon, file.sentinelTempoSettings )
}

var function OnWeaponPrimaryAttack_weapon_sentinel( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( player ) )
		return 0

	weapon.FireWeapon_Default( attackParams.pos, attackParams.dir, 1.0, 1.0, false )

	int ammoPerShot = weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )

	if ( !GetCurrentPlaylistVarBool( SENTINEL_USE_ENERGIZE_PLAYLIST_VAR, true ) )
		return ammoPerShot

	#if CLIENT
		if ( InPrediction() && IsFirstTimePredicted() )
		{
			if ( weapon.GetWeaponPrimaryClipCount() > ammoPerShot && !HasFullscreenScope( weapon ) )
			{
				weapon.Signal( RECHAMBER_RUI_ABORT_SIGNAL )
				thread DisplayRechamberRui( weapon )
			}
		}
	#endif

	MarksmansTempo_OnFire( weapon, file.sentinelTempoSettings, false )		                                                                                             
	float rechamberDuration = weapon.GetWeaponSettingFloat( eWeaponVar.rechamber_time )
	float fireCooldown      = 1.0 / weapon.GetWeaponSettingFloat( eWeaponVar.fire_rate )
	float perfectMomentTime = Time() + fireCooldown + rechamberDuration * SENTINEL_RECHAMBER_READY_TO_FIRE_FRAC
	MarksmansTempo_SetPerfectTempoMoment( weapon, file.sentinelTempoSettings, player, perfectMomentTime, true )


	return ammoPerShot
}


                                                                                         
  
  	            
  
                                                                                         
#if CLIENT

void function DisplayRechamberRui( entity weapon )
{
	if ( !IsValid( weapon ) )
		return
	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( player ) )
		return
	player.EndSignal( "OnDeath" )
	weapon.EndSignal( "OnDestroy" )
	weapon.EndSignal( RECHAMBER_RUI_ABORT_SIGNAL )
	OnThreadEnd(
		function() : ( weapon )
		{
			if ( IsValid( weapon ) && weapon.w.sentinelEnergizeHintRui != null )
				RuiSetBool( weapon.w.sentinelEnergizeHintRui, "isRechambering", false)
		}
	)

	float fireRate = weapon.GetWeaponSettingFloat( eWeaponVar.fire_rate )
	if ( fireRate <= 0 )
		return
	wait 1.0 / fireRate

	if ( !IsValid( weapon ) )
		return

	if ( weapon.w.sentinelEnergizeHintRui != null )
		RuiSetBool( weapon.w.sentinelEnergizeHintRui, "isRechambering", true)

	float duration = weapon.GetWeaponSettingFloat( eWeaponVar.rechamber_time ) * 0.66                                         
	                                                                             
	                                                                                                            	                                                                                                                                  

	waitthread DisplayCenterDotRui( weapon, RECHAMBER_RUI_ABORT_SIGNAL, 0.0, duration, 0.5, 0.1, 0.2 )

	if ( IsValid( weapon ) && weapon.w.sentinelEnergizeHintRui != null )
		RuiSetBool( weapon.w.sentinelEnergizeHintRui, "isRechambering", false)
}


#endif         

                                                                                         
  
  	            
  
                                                                                         
#if SERVER

                                                          
 
	                                  
	                                         

	                              
	                                    
	                              
	                                    

	                                                                            
	                                                                                  
	                                                                            
	                                                                                  

	                 
		                      
	                    
		                         
	                 
		                      
	                    
		                         
 
#endif         