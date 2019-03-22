global function OnWeaponPrimaryAttack_holopilot
global function OnWeaponChargeLevelIncreased_holopilot
global function PlayerCanUseDecoy

global const int DECOY_FADE_DISTANCE = 16000 //
global const float DECOY_DURATION = 15.0
const float ULTIMATE_DECOY_DURATION = 5.0

global const vector HOLOPILOT_ANGLE_SEGMENT = <0,60,0>
global function Decoy_Init

const DECOY_AR_MARKER = $"P_ar_ping_squad_CP"
const float DECOY_TRACE_DIST = 5000.0

#if(false)








#endif //

const DECOY_FLAG_FX = $"P_flag_fx_foe"
const HOLO_EMITTER_CHARGE_FX_1P = $"P_mirage_holo_emitter_glow_FP"
const HOLO_EMITTER_CHARGE_FX_3P = $"P_mirage_emitter_flash"
const asset DECOY_TRIGGERED_ICON = $"rui/hud/tactical_icons/tactical_mirage_in_world"

struct
{
	table<entity, int> playerToDecoysActiveTable //
} file


void function Decoy_Init()
{
	#if(false)




#else
	PrecacheParticleSystem( DECOY_AR_MARKER )
	#endif
}

#if(false)


//






















//





















//

//





//





//




//

#endif //


var function OnWeaponPrimaryAttack_holopilot( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	Assert( weaponOwner.IsPlayer() )

	if ( !PlayerCanUseDecoy( weaponOwner ) )
		return 0

	int chargeLevel = weapon.IsChargeWeapon() ? weapon.GetWeaponChargeLevel() : 1
	if ( weapon.GetWeaponChargeLevelMax() > 1 )
		chargeLevel *= 2 //
	//
#if(false)





#else
	if ( chargeLevel == 1 )
		CreateARIndicator( weaponOwner )
#endif

	PlayerUsedOffhand( weaponOwner, weapon )

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire ) //
}

#if(CLIENT)
void function CreateARIndicator( entity player )
{
	vector eyePos = player.EyePosition()
	vector viewVector = player.GetViewVector()
	TraceResults trace = TraceLine( eyePos, eyePos + (viewVector * DECOY_TRACE_DIST), player, TRACE_MASK_SOLID_BRUSHONLY, TRACE_COLLISION_GROUP_NONE )
	if ( trace.fraction < 1.0 )
	{
		trace = TraceLine( trace.endPos, trace.endPos + <0,0,-2000 * trace.fraction >, player, TRACE_MASK_SOLID_BRUSHONLY, TRACE_COLLISION_GROUP_NONE )
		int arID = GetParticleSystemIndex( DECOY_AR_MARKER )
		int fxHandle = StartParticleEffectInWorldWithHandle( arID, trace.endPos, trace.surfaceNormal )
		EffectSetControlPointVector( fxHandle, 1, FRIENDLY_COLOR_FX )
		thread DestroyAfterTime( fxHandle, 1.0 )
	}
}

void function DestroyAfterTime( int fxHandle, float time )
{
	OnThreadEnd(
		function() : ( fxHandle )
		{
			if ( !EffectDoesExist( fxHandle ) )
				return

			EffectStop( fxHandle, true, true )
		}
	)
	wait( time )
}
#endif

#if(false)






















//






//









//
//
//
//




























//






/*







*/

































































//






//






//
//




//
//





















































































































//


























#endif //

bool function PlayerCanUseDecoy( entity ownerPlayer ) //
{
	if ( !ownerPlayer.IsZiplining() )
	{
		if ( ownerPlayer.IsTraversing() )
			return false

		if ( ownerPlayer.ContextAction_IsActive() ) //
			return false
	}

	float angleCheckParam = GetCurrentPlaylistVarFloat( "mirageabilitycheck", 0.99 )

	if ( ownerPlayer.GetViewVector().Dot( <0, 0, -1> ) > angleCheckParam )
		return false

	//

	return true
}

bool function OnWeaponChargeLevelIncreased_holopilot( entity weapon )
{
	#if(CLIENT)
		if ( InPrediction() && !IsFirstTimePredicted() )
			return true
	#endif

	int level = weapon.GetWeaponChargeLevel()
	int maxLevel = weapon.GetWeaponChargeLevelMax()

	if ( level == maxLevel )
	{
		if ( weapon.HasMod( "disguise" ) )
		{
		//
		//
		}
		else
		{
		//
			weapon.PlayWeaponEffect( HOLO_EMITTER_CHARGE_FX_1P, HOLO_EMITTER_CHARGE_FX_3P, "FX_EMITTER_L_01" )

		}
	}
	else
	{
		switch ( level )
		{
			case 1:
			//
			//
			//

			case 2:
			//
			//
			//
		}
	}

	return true
}