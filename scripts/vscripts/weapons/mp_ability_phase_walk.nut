global function MpAbilityPhaseWalk_Init

global function OnWeaponActivate_ability_phase_walk
global function OnWeaponPrimaryAttack_ability_phase_walk
global function OnWeaponChargeBegin_ability_phase_walk
global function OnWeaponChargeEnd_ability_phase_walk

const float PHASE_WALK_PRE_TELL_TIME = 1.5
const asset PHASE_WALK_APPEAR_PRE_FX = $"P_phase_dash_pre_end_mdl"

void function MpAbilityPhaseWalk_Init()
{
	PrecacheParticleSystem( PHASE_WALK_APPEAR_PRE_FX )
}


void function OnWeaponActivate_ability_phase_walk( entity weapon )
{
	#if(false)





#endif
}


var function OnWeaponPrimaryAttack_ability_phase_walk( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity player = weapon.GetWeaponOwner()
	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}

bool function OnWeaponChargeBegin_ability_phase_walk( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	float chargeTime = weapon.GetWeaponSettingFloat( eWeaponVar.charge_time )
	#if(false)








#endif
	PhaseShift( player, 0, chargeTime, eShiftStyle.Balance )
	return true
}

#if(false)














//












#endif

void function OnWeaponChargeEnd_ability_phase_walk( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	#if(false)







//
#endif
}