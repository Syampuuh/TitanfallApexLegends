
global function OnWeaponPrimaryAttack_alternator_smg
global function MpWeaponAlternatorSMG_Init

#if(false)

#endif

#if(CLIENT)
	global function OnClientAnimEvent_alternator_smg
#endif


const ALTERNATOR_SMG_TRACER_FX = $"weapon_tracers_xo16_speed"

void function MpWeaponAlternatorSMG_Init()
{
	#if(CLIENT)
		PrecacheParticleSystem( ALTERNATOR_SMG_TRACER_FX )
	#endif
}

var function OnWeaponPrimaryAttack_alternator_smg( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return FireWeaponPlayerAndNPC( weapon, attackParams, true )
}

#if(false)




#endif

int function FireWeaponPlayerAndNPC( entity weapon, WeaponPrimaryAttackParams attackParams, bool playerFired )
{
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )
	int damageType = weapon.GetWeaponDamageFlags()
	//
	//
	//
	//
	//
	//
	//
	//
	weapon.FireWeaponBullet( attackParams.pos, attackParams.dir, 1, damageType )

	return 1
}

#if(CLIENT)
void function OnClientAnimEvent_alternator_smg( entity weapon, string name )
{
	GlobalClientEventHandler( weapon, name )
}
#endif