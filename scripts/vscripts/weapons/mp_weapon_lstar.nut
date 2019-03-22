
global function MpWeaponLSTAR_Init

global function OnWeaponPrimaryAttack_weapon_lstar
global function OnWeaponCooldown_weapon_lstar
global function OnWeaponActivate_weapon_lstar

#if(false)

#endif //


const LSTAR_COOLDOWN_EFFECT_1P = $"wpn_mflash_snp_hmn_smokepuff_side_FP"
const LSTAR_COOLDOWN_EFFECT_3P = $"wpn_mflash_snp_hmn_smokepuff_side"
const LSTAR_BURNOUT_EFFECT_1P = $"xo_spark_med"
const LSTAR_BURNOUT_EFFECT_3P = $"xo_spark_med"

const float LSTAR_OVERHEAT_WARNING_CHARGE_FRAC = 0.8

const string LSTAR_WARNING_SOUND_1P = "lstar_lowammowarning"
const string LSTAR_BURNOUT_SOUND_1P = "LSTAR_LensBurnout"
const string LSTAR_BURNOUT_SOUND_3P = "LSTAR_LensBurnout_3P"

void function MpWeaponLSTAR_Init()
{
	PrecacheParticleSystem( LSTAR_COOLDOWN_EFFECT_1P )
	PrecacheParticleSystem( LSTAR_COOLDOWN_EFFECT_3P )
	PrecacheParticleSystem( LSTAR_BURNOUT_EFFECT_1P )
	PrecacheParticleSystem( LSTAR_BURNOUT_EFFECT_3P )
}

var function OnWeaponPrimaryAttack_weapon_lstar( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return LSTARPrimaryAttack( weapon, attackParams, true )
}

#if(false)




#endif //

int function LSTARPrimaryAttack( entity weapon, WeaponPrimaryAttackParams attackParams, bool isPlayerFired )
{
	entity owner = weapon.GetOwner()

	#if(CLIENT)
	if ( !weapon.ShouldPredictProjectiles() )
		return 1

	//
	{
		if ( weapon.GetWeaponChargeFraction() >= LSTAR_OVERHEAT_WARNING_CHARGE_FRAC )
		{
			//
			if ( IsValid( owner ) && (Time() - weapon.w.lastFireTime >= GetSoundDuration( LSTAR_WARNING_SOUND_1P ) ) )
			{
				weapon.w.lastFireTime = Time()
				EmitSoundOnEntity( owner, LSTAR_WARNING_SOUND_1P )
			}
		}
	}
	#endif //

	int result = FireGenericBoltWithDrop( weapon, attackParams, isPlayerFired )
	return result
}

//
void function OnWeaponCooldown_weapon_lstar( entity weapon )
{
	//
	if ( weapon.GetWeaponChargeFraction() == 1.0 )  //
	{
		weapon.EmitWeaponSound_1p3p( LSTAR_BURNOUT_SOUND_1P, LSTAR_BURNOUT_SOUND_3P )
		weapon.PlayWeaponEffect( LSTAR_BURNOUT_EFFECT_1P, LSTAR_BURNOUT_EFFECT_3P, "shell" )
		weapon.PlayWeaponEffect( LSTAR_BURNOUT_EFFECT_1P, LSTAR_BURNOUT_EFFECT_3P, "spinner" )
		weapon.PlayWeaponEffect( LSTAR_BURNOUT_EFFECT_1P, LSTAR_BURNOUT_EFFECT_3P, "vent_cover_L" )
		weapon.PlayWeaponEffect( LSTAR_BURNOUT_EFFECT_1P, LSTAR_BURNOUT_EFFECT_3P, "vent_cover_R" )
	}
	//
	else
	{
		weapon.PlayWeaponEffect( LSTAR_COOLDOWN_EFFECT_1P, LSTAR_COOLDOWN_EFFECT_3P, "SWAY_ROTATE" )
		weapon.EmitWeaponSound_1p3p( "LSTAR_VentCooldown", "LSTAR_VentCooldown_3p" )
	}
}

#if(false)
//























#endif //

void function OnWeaponActivate_weapon_lstar( entity weapon )
{
	entity owner = weapon.GetOwner()
	if ( !owner.IsPlayer() )
		return

#if(false)

#endif //
}
