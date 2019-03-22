
global function MpWeaponGrenadeBangalore_Init
global function OnWeaponActivate_weapon_grenade_bangalore
global function OnProjectileCollision_weapon_grenade_bangalore
global function OnProjectileIgnite_weapon_grenade_bangalore
global function OnWeaponTossReleaseAnimEvent_weapon_grenade_bangalore

#if(CLIENT)
	global function OnClientAnimEvent_weapon_grenade_bangalore
#endif

global const string BANGALORE_SMOKESCREEN_SCRIPTNAME = "bangalore_smokescreen"

const asset FX_SMOKESCREEN_BANGALORE = $"P_smokescreen_FD"
const asset FX_SMOKEGRENADE_TRAIL = $"P_SmokeScreen_FD_trail"
const asset BANGALORE_SMOKE_MODEL = $"mdl/weapons/grenades/w_bangalore_canister_gas_projectile.rmdl"

const float BANGALORE_SMOKE_DURATION = 15.0
const float BANGALORE_SMOKE_MIN_EXPLODE_DIST_SQR = 512 * 512
const float BANGALORE_SMOKE_DISPERSAL_TIME = 3.0
const float BANGALORE_TACTICAL_AGAIN_TIME = 4.0

const bool BANGALORE_SMOKE_EXPLOSIONS = true
const asset SMOKE_SCREEN_FX = $"P_screen_smoke_bangalore_FP"

const asset FX_MUZZLE_FLASH_FP = $"P_wpn_mflash_bang_rocket_FP"
const asset FX_MUZZLE_FLASH_3P = $"P_wpn_mflash_bang_rocket"

struct
{
	#if(CLIENT)
		int colorCorrectionGas
	#endif //
	int smokeGasScreenFxId
} file

void function MpWeaponGrenadeBangalore_Init()
{
	PrecacheModel( BANGALORE_SMOKE_MODEL )
	PrecacheParticleSystem( FX_SMOKESCREEN_BANGALORE )
	PrecacheParticleSystem( FX_SMOKEGRENADE_TRAIL )
	PrecacheParticleSystem( FX_MUZZLE_FLASH_FP )
	PrecacheParticleSystem( FX_MUZZLE_FLASH_3P )

	file.smokeGasScreenFxId = PrecacheParticleSystem( SMOKE_SCREEN_FX )

	#if(false)

#endif //

	#if(CLIENT)
		RegisterSignal( "stop_smokescreen_screen_fx" )

		StatusEffect_RegisterEnabledCallback( eStatusEffect.smokescreen, BangaloreSmokescreenEffectEnabled )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.smokescreen, BangaloreSmokescreenEffectDisabled )

		file.colorCorrectionGas = ColorCorrection_Register( "materials/correction/smoke_cloud.raw_hdr" )
	#endif
}

void function OnWeaponActivate_weapon_grenade_bangalore( entity weapon )
{
}

var function OnWeaponTossReleaseAnimEvent_weapon_grenade_bangalore( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	#if(false)







#endif //
	return Grenade_OnWeaponTossReleaseAnimEvent( weapon, attackParams )
}

void function OnProjectileCollision_weapon_grenade_bangalore( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	entity player = projectile.GetOwner()
	if ( hitEnt == player )
		return

	if ( projectile.GrenadeHasIgnited() )
		return

	#if(false)

#endif //

	if ( LengthSqr( normal ) < 0.01 ) //
		normal = AnglesToForward( VectorToAngles( projectile.GetVelocity() ) )

	#if(false)

#endif //

	table collisionParams =
	{
		pos = pos,
		normal = normal,
		hitEnt = hitEnt,
		hitbox = hitbox
	}

	projectile.SetModel( $"mdl/dev/empty_model.rmdl" )
	bool result = PlantStickyEntity( projectile, collisionParams, normal )

	projectile.GrenadeIgnite()
	projectile.SetDoesExplode( false )
}

void function OnProjectileIgnite_weapon_grenade_bangalore( entity projectile )
{
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
















#endif //
}


#if(false)




//
















































































//








//
//




















//


















































//









#endif //

#if(CLIENT)
void function OnClientAnimEvent_weapon_grenade_bangalore( entity weapon, string name )
{
	GlobalClientEventHandler( weapon, name )

	if ( name == "muzzle_flash" )
	{
		weapon.PlayWeaponEffect( FX_MUZZLE_FLASH_FP, FX_MUZZLE_FLASH_3P, "muzzle_flash" )
	}

}

void function BangaloreSmokescreenEffectDisabled( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( ent != GetLocalViewPlayer() )
		return

	ent.Signal( "GasCloud_StopColorCorrection" )
	ent.Signal( "stop_smokescreen_screen_fx" )

	Chroma_EndSmokescreenEffect()
}

void function BangaloreSmokescreenEffectEnabled( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( ent != GetLocalViewPlayer() )
		return

	entity viewPlayer = ent
	viewPlayer.Signal( "stop_smokescreen_screen_fx" )

	thread UpdatePlayerScreenColorCorrection( viewPlayer, statusEffect, file.colorCorrectionGas )

	if ( !viewPlayer.IsTitan() )
	{
		int fxHandle = StartParticleEffectOnEntityWithPos( viewPlayer, file.smokeGasScreenFxId, FX_PATTACH_ABSORIGIN_FOLLOW, -1, viewPlayer.EyePosition(), <0,0,0> )
		EffectSetIsWithCockpit( fxHandle, true )

		Chroma_StartSmokescreenEffect()

		thread BangaloreSmokescreenEffectThread( viewPlayer, fxHandle, statusEffect )
	}
}

void function BangaloreSmokescreenEffectThread( entity ent, int fxHandle, int statusEffect )
{
	EndSignal( ent, "OnDeath" )
	EndSignal( ent, "stop_smokescreen_screen_fx" )

	OnThreadEnd(
		function() : ( fxHandle )
		{
			if ( !EffectDoesExist( fxHandle ) )
				return

			EffectStop( fxHandle, false, true )
		}
	)

	while( true )
	{
		float severity = StatusEffect_GetSeverity( ent, statusEffect )
		//

		if ( !EffectDoesExist( fxHandle ) )
			break

		EffectSetControlPointVector( fxHandle, 1, <severity,999,0> )
		WaitFrame()
	}
}

#endif //
