global function MpAbilityAreaSonarScan_Init

global function OnWeaponActivate_ability_area_sonar_scan
global function OnWeaponPrimaryAttackAnimEvent_ability_area_sonar_scan

#if(CLIENT)
global function ServerCallback_SonarAreaScanTarget
#endif //

const asset FLASHEFFECT    = $"P_sonar_bloodhound"
const asset EYEEFFECT    = $"P_sonar_bloodhound_eyes"
const asset AREA_SCAN_ACTIVATION_SCREEN_FX = $"P_sonar"
const asset FX_SONAR_TARGET = $"P_ar_target_sonar"

const int AREA_SCAN_SKIN_INDEX = 9

const float AREA_SONAR_SCAN_HUD_FEEDBACK_DURATION = 3.0
const float AREA_SONAR_SCAN_DURATION = 2.0
const float AREA_SONAR_SCAN_CONE_FOV = 90.0

struct
{
	int colorCorrection
	int screeFxHandle

#if(false)

#endif
} file

void function OnWeaponActivate_ability_area_sonar_scan( entity weapon )
{
}

var function OnWeaponPrimaryAttackAnimEvent_ability_area_sonar_scan( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	//
	entity weaponOwner = weapon.GetWeaponOwner()
	Assert ( weaponOwner.IsPlayer() )

	#if(false)
//


#endif //

	#if(CLIENT)
//
//
	#endif //

	PlayerUsedOffhand( weaponOwner, weapon )

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )
}

void function MpAbilityAreaSonarScan_Init()
{
	PrecacheParticleSystem( FLASHEFFECT )
	PrecacheParticleSystem( EYEEFFECT )
	PrecacheParticleSystem( FX_SONAR_TARGET )

	#if(CLIENT)
		PrecacheParticleSystem( AREA_SCAN_ACTIVATION_SCREEN_FX )
		file.colorCorrection = ColorCorrection_Register( "materials/correction/area_sonar_scan.raw_hdr" )

		StatusEffect_RegisterEnabledCallback( eStatusEffect.sonar_pulse_visuals, AreaSonarScan_StartScreenEffect )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.sonar_pulse_visuals, AreaSonarScan_StopScreenEffect )
	#endif //

	RegisterSignal( "AreaSonarScan_Activated" )

}

#if(false)




//



























//






//








//



//





//























//


//


























































//





//







//








//




//
















#endif

#if(CLIENT)

void function ServerCallback_SonarAreaScanTarget( entity sonarTarget, entity owner )
{
	if ( !IsValid( sonarTarget ) )
		return

	entity viewPlayer = GetLocalViewPlayer()
	int viewPlayerTeam = viewPlayer.GetTeam()
	int ownerTeam = owner.GetTeam()

	if ( sonarTarget == GetLocalViewPlayer() )
		thread CreateViemodelSonarFlash( sonarTarget )
	else if ( viewPlayerTeam == ownerTeam )
		thread CreateSonarCloneForEnt( sonarTarget, owner )
}

void function CreateViemodelSonarFlash( entity ent )
{
	EndSignal( ent, "OnDestroy" )

	entity viewModelArm = ent.GetViewModelArmsAttachment()
	entity viewModelEntity = ent.GetViewModelEntity()
	entity firstPersonProxy = ent.GetFirstPersonProxy()
	entity predictedFirstPersonProxy = ent.GetPredictedFirstPersonProxy()

	//
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

	wait 0.5 //

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

void function CreateSonarCloneForEnt( entity sonarTarget, entity owner )
{
	entity entClone = CreateClientSidePropDynamicClone( sonarTarget, sonarTarget.GetModelName() )
	if ( !IsValid( entClone ) ) //
		return

	EndSignal( entClone, "OnDestroy" )
	SonarPlayerCloneHighlight( entClone )

	int fxid = GetParticleSystemIndex( FX_SONAR_TARGET )
	int fxHandle = -1

	if ( owner == GetLocalViewPlayer() )
	{
		fxHandle = StartParticleEffectOnEntity( entClone, fxid, FX_PATTACH_POINT_FOLLOW_NOROTATE, entClone.LookupAttachment( "CHESTFOCUS" ) )
	}

	OnThreadEnd(
		function() : ( fxHandle )
		{
			if ( EffectDoesExist( fxHandle ) )
				EffectStop( fxHandle, true, true )
		}
	)

	wait AREA_SONAR_SCAN_DURATION
	entClone.Destroy()
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
	file.screeFxHandle = StartParticleEffectOnEntity( cockpit,indexD, FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
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

#endif //