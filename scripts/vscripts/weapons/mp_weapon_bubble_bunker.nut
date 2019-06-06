global function MpWeaponBubbleBunker_Init

global function OnWeaponTossReleaseAnimEvent_WeaponBubbleBunker
global function OnWeaponAttemptOffhandSwitch_WeaponBubbleBunker
global function OnWeaponTossPrep_WeaponBubbleBunker

const float BUBBLE_BUNKER_DEPLOY_DELAY = 1.0
const float BUBBLE_BUNKER_DURATION_WARNING = 5.0

const bool BUBBLE_BUNKER_DAMAGE_ENEMIES = false

const float BUBBLE_BUNKER_ANGLE_LIMIT = 0.55

const asset BUBBLE_BUNKER_BEAM_FX = $"P_wpn_BBunker_beam"
const asset BUBBLE_BUNKER_BEAM_END_FX = $"P_wpn_BBunker_beam_end"
const asset BUBBLE_BUNKER_SHIELD_FX = $"P_wpn_BBunker_shield"
const asset BUBBLE_BUNKER_SHIELD_COLLISION_MODEL = $"mdl/fx/bb_shield.rmdl"
const asset BUBBLE_BUNKER_SHIELD_PROJECTILE = $"mdl/props/gibraltar_bubbleshield/gibraltar_bubbleshield.rmdl"

const string BUBBLE_BUNKER_SOUND_ENDING = "Gibraltar_BubbleShield_Ending"
const string BUBBLE_BUNKER_SOUND_FINISH = "Gibraltar_BubbleShield_Deactivate"

struct FriendlyEnemyFXStruct
{
	entity friendlyColoredFX
	entity enemyColoredFX
	int team
}

void function MpWeaponBubbleBunker_Init()
{
	PrecacheParticleSystem( BUBBLE_BUNKER_BEAM_END_FX )
	PrecacheParticleSystem( BUBBLE_BUNKER_BEAM_FX )
	PrecacheParticleSystem( BUBBLE_BUNKER_SHIELD_FX )
	PrecacheModel( BUBBLE_BUNKER_SHIELD_COLLISION_MODEL )
	PrecacheModel( BUBBLE_BUNKER_SHIELD_PROJECTILE )

	#if(false)
//

#endif
}

bool function OnWeaponAttemptOffhandSwitch_WeaponBubbleBunker( entity weapon )
{
	int ammoReq = weapon.GetAmmoPerShot()
	int currAmmo = weapon.GetWeaponPrimaryClipCount()
	if ( currAmmo < ammoReq )
		return false

	entity player = weapon.GetWeaponOwner()
	if ( player.IsPhaseShifted() )
		return false

	return true
}

var function OnWeaponTossReleaseAnimEvent_WeaponBubbleBunker( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	int ammoReq = weapon.GetAmmoPerShot()
	weapon.EmitWeaponSound_1p3p( GetGrenadeThrowSound_1p( weapon ), GetGrenadeThrowSound_3p( weapon ) )

	entity deployable = ThrowDeployable( weapon, attackParams, DEPLOYABLE_THROW_POWER, OnBubbleBunkerPlanted )
	if ( deployable )
	{
		entity player = weapon.GetWeaponOwner()
		PlayerUsedOffhand( player, weapon, true, deployable )

		#if(false)









#endif

		#if(false)

#endif

	}

	return ammoReq
}

void function OnWeaponTossPrep_WeaponBubbleBunker( entity weapon, WeaponTossPrepParams prepParams )
{
	weapon.EmitWeaponSound_1p3p( GetGrenadeDeploySound_1p( weapon ), GetGrenadeDeploySound_3p( weapon ) )

	#if(false)


#endif
}

void function OnBubbleBunkerPlanted( entity projectile )
{
	#if(false)































//




















//

















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



































//
























#endif