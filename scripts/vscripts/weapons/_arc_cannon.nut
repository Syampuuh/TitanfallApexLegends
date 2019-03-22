untyped

global function ArcCannon_Init

global function ArcCannon_PrecacheFX
global function ArcCannon_Start
global function ArcCannon_Stop
global function ArcCannon_ChargeBegin
global function ArcCannon_ChargeEnd
global function FireArcCannon
global function ArcCannon_HideIdleEffect
#if(false)



#endif
global function GetArcCannonChargeFraction

global function IsEntANeutralMegaTurret
global function CreateArcCannonBeam


//
global const DEFAULT_ARC_CANNON_FOVDOT			= 0.98		//
global const DEFAULT_ARC_CANNON_FOVDOT_MISSILE	= 0.95		//
global const ARC_CANNON_RANGE_CHAIN				= 400		//
global const ARC_CANNON_TITAN_RANGE_CHAIN		= 900		//
global const ARC_CANNON_CHAIN_COUNT_MIN			= 5			//
global const ARC_CANNON_CHAIN_COUNT_MAX			= 5			//
global const ARC_CANNON_CHAIN_COUNT_NPC			= 2			//
global const ARC_CANNON_FORK_COUNT_MAX			= 1			//
global const ARC_CANNON_FORK_DELAY				= 0.1

global const ARC_CANNON_RANGE_CHAIN_BURN		= 400
global const ARC_CANNON_TITAN_RANGE_CHAIN_BURN	= 900
global const ARC_CANNON_CHAIN_COUNT_MIN_BURN	= 100		//
global const ARC_CANNON_CHAIN_COUNT_MAX_BURN	= 100		//
global const ARC_CANNON_CHAIN_COUNT_NPC_BURN	= 10		//
global const ARC_CANNON_FORK_COUNT_MAX_BURN		= 10		//
global const ARC_CANNON_BEAM_LIFETIME_BURN		= 1.0

//
global const ARC_CANNON_BOLT_RADIUS_MIN 		= 32		//
global const ARC_CANNON_BOLT_RADIUS_MAX 		= 640		//
global const ARC_CANNON_BOLT_WIDTH_MIN 			= 1			//
global const ARC_CANNON_BOLT_WIDTH_MAX 			= 26		//
global const ARC_CANNON_BOLT_WIDTH_NPC			= 8			//
global const ARC_CANNON_BEAM_COLOR				= "150 190 255"
global const ARC_CANNON_BEAM_LIFETIME			= 0.75

//
global const ARC_CANNON_TITAN_SCREEN_SFX 		= "Null_Remove_SoundHook"
global const ARC_CANNON_PILOT_SCREEN_SFX 		= "Null_Remove_SoundHook"
global const ARC_CANNON_EMP_DURATION_MIN 		= 0.1
global const ARC_CANNON_EMP_DURATION_MAX		= 1.8
global const ARC_CANNON_EMP_FADEOUT_DURATION	= 0.4
global const ARC_CANNON_SCREEN_EFFECTS_MIN 		= 0.01
global const ARC_CANNON_SCREEN_EFFECTS_MAX 		= 0.02
global const ARC_CANNON_SCREEN_THRESHOLD		= 0.3385
global const ARC_CANNON_3RD_PERSON_EFFECT_MIN_DURATION = 0.2

//
global const ARC_CANNON_DAMAGE_FALLOFF_SCALER		= 0.75		//
global const ARC_CANNON_DAMAGE_CHARGE_RATIO			= 0.85		//
global const ARC_CANNON_DAMAGE_CHARGE_RATIO_BURN	= 0.676		//
global const ARC_CANNON_CAPACITOR_CHARGE_RATIO		= 1.0

//
global const ARC_CANNON_TARGETS_MISSILES 			= 1			//

//
global const OVERCHARGE_MAX_SHIELD_DECAY       		= 0.2
global const OVERCHARGE_SHIELD_DECAY_MULTIPLIER 	= 0.04
global const OVERCHARGE_BONUS_CHARGE_FRACTION		= 0.05

global const SPLITTER_DAMAGE_FALLOFF_SCALER			= 0.6
global const SPLITTER_FORK_COUNT_MAX				= 10

global const ARC_CANNON_SIGNAL_DEACTIVATED	= "ArcCannonDeactivated"
global const ARC_CANNON_SIGNAL_CHARGEEND = "ArcCannonChargeEnd"

global const ARC_CANNON_BEAM_EFFECT = $"wpn_arc_cannon_beam"
global const ARC_CANNON_BEAM_EFFECT_MOD = $"wpn_arc_cannon_beam_mod"

global const ARC_CANNON_FX_TABLE = "exp_arc_cannon"

global const ArcCannonTargetClassnames = {
	[ "npc_drone" ] 			= true,
	[ "npc_dropship" ] 			= true,
	[ "npc_marvin" ] 			= true,
	[ "npc_prowler" ]			= true,
	[ "npc_soldier" ] 			= true,
	[ "npc_soldier_heavy" ] 	= true,
	[ "npc_soldier_shield" ]	= true,
	[ "npc_spectre" ] 			= true,
	[ "npc_stalker" ] 			= true,
	[ "npc_super_spectre" ]		= true,
	[ "npc_titan" ] 			= true,
	[ "npc_turret_floor" ] 		= true,
	[ "npc_turret_mega" ]		= true,
	[ "npc_turret_sentry" ] 	= true,
	[ "npc_frag_drone" ] 		= true,
	[ "player" ] 				= true,
	[ "prop_dynamic" ] 			= true,
	[ "prop_script" ] 			= true,
	[ "grenade_frag" ] 			= true,
	[ "rpg_missile" ] 			= true,
	[ "script_mover" ] 			= true,
	[ "turret" ] 				= true,
}

struct {
	array<string> missileCheckTargetnames = [
		//
		"Arc Ball"
	]
} file

void function ArcCannon_Init()
{
	RegisterSignal( ARC_CANNON_SIGNAL_DEACTIVATED )
	RegisterSignal( ARC_CANNON_SIGNAL_CHARGEEND )
	PrecacheParticleSystem( ARC_CANNON_BEAM_EFFECT )
	PrecacheParticleSystem( ARC_CANNON_BEAM_EFFECT_MOD )
	PrecacheImpactEffectTable( ARC_CANNON_FX_TABLE )

	#if(CLIENT)
		AddDestroyCallback( "mp_titanweapon_arc_cannon", ClientDestroyCallback_ArcCannon_Stop )
	#else
		level._arcCannonTargetsArrayID <- CreateScriptManagedEntArray()
	#endif

	PrecacheParticleSystem( $"impact_arc_cannon_titan" )
}

void function ArcCannon_PrecacheFX()
{
	PrecacheParticleSystem( $"wpn_arc_cannon_electricity_fp" )
	PrecacheParticleSystem( $"wpn_arc_cannon_electricity" )

	PrecacheParticleSystem( $"wpn_muzzleflash_arc_cannon_fp" )
	PrecacheParticleSystem( $"wpn_muzzleflash_arc_cannon" )
}

void function ArcCannon_Start( entity weapon )
{
	if ( !IsPilot( weapon.GetWeaponOwner() ) )
	{
		weapon.PlayWeaponEffectNoCull( $"wpn_arc_cannon_electricity_fp", $"wpn_arc_cannon_electricity", "muzzle_flash" )
		weapon.EmitWeaponSound( "arc_cannon_charged_loop" )
	}
	else
	{
		weapon.EmitWeaponSound_1p3p( "Arc_Rifle_charged_Loop_1P", "Arc_Rifle_charged_Loop_3P" )
	}
}

void function ArcCannon_Stop( entity weapon, entity player = null )
{
	weapon.Signal( ARC_CANNON_SIGNAL_DEACTIVATED )

	weapon.StopWeaponEffect( $"wpn_arc_cannon_electricity_fp", $"wpn_arc_cannon_electricity" )
	weapon.StopWeaponSound( "arc_cannon_charged_loop" )
}

void function ArcCannon_ChargeBegin( entity weapon )
{
	#if(false)









#endif

	#if(CLIENT)
		if ( !weapon.ShouldPredictProjectiles() )
			return

		entity weaponOwner = weapon.GetWeaponOwner()
		Assert( weaponOwner.IsPlayer() )
		weaponOwner.StartArcCannon()
	#endif
}

void function ArcCannon_ChargeEnd( entity weapon, entity player = null )
{
	#if(false)


#endif

	#if(CLIENT)
		if ( weapon.GetWeaponOwner() == GetLocalViewPlayer() )
		{
			entity weaponOwner
			if ( player != null )
				weaponOwner = player
			else
				weaponOwner = weapon.GetWeaponOwner()

			if ( IsValid( weaponOwner ) && weaponOwner.IsPlayer() )
				weaponOwner.StopArcCannon()
		}
	#endif
}

#if(false)
















//





//
















#endif

int function FireArcCannon( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	float baseCharge = GetWeaponChargeFrac( weapon ) //
	float charge = clamp( baseCharge * ( 1 / GetArcCannonChargeFraction( weapon ) ), 0.0, 1.0 )
	float newVolume = GraphCapped( charge, 0.25, 1.0, 0.0, 1.0 )

	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	weapon.PlayWeaponEffect( $"wpn_muzzleflash_arc_cannon_fp", $"wpn_muzzleflash_arc_cannon", "muzzle_flash" )

	string attachmentName = "muzzle_flash"
	int attachmentIndex = weapon.LookupAttachment( attachmentName )
	Assert( attachmentIndex >= 0 )
	vector muzzleOrigin = weapon.GetAttachmentOrigin( attachmentIndex )

	//

	table firstTargetInfo = GetFirstArcCannonTarget( weapon, attackParams )
	if ( !IsValid( firstTargetInfo.target ) )
		FireArcNoTargets( weapon, attackParams, muzzleOrigin )
	else
		FireArcWithTargets( weapon, firstTargetInfo, attackParams, muzzleOrigin )

	return 1
}

table function GetFirstArcCannonTarget( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity owner 				= weapon.GetWeaponOwner()
	float coneHeight 			= weapon.GetMaxDamageFarDist()

	float angleToAxis 			= 2.0 //
	array<entity> ignoredEntities = [ owner, weapon ]
	int traceMask 				= TRACE_MASK_SHOT
	int flags					= VIS_CONE_ENTS_TEST_HITBOXES
	entity antilagPlayer		= null
	if ( owner.IsPlayer() )
	{
		angleToAxis = weapon.GetAttackSpreadAngle() * 0.11
		antilagPlayer = owner
	}

	int ownerTeam = owner.GetTeam()

	//
	//
	table firstTargetInfo = {}
	firstTargetInfo.target <- null
	firstTargetInfo.hitLocation <- null

	for ( int i = 0; i < 2; i++ )
	{
		bool missileCheck = i == 0
		float coneAngle = angleToAxis
		if ( missileCheck && owner.IsPlayer() ) //
			coneAngle *= 8.0

		coneAngle = clamp( coneAngle, 0.1, 89.9 )

		array<VisibleEntityInCone> results = FindVisibleEntitiesInCone( attackParams.pos, attackParams.dir, coneHeight, coneAngle, ignoredEntities, traceMask, flags, antilagPlayer )
		foreach ( result in results )
		{
			entity visibleEnt = result.ent

			if ( !IsValid( visibleEnt ) )
				continue

			if ( visibleEnt.IsPhaseShifted() )
				continue

			local classname = visibleEnt.GetNetworkedClassName()

			if ( !( classname in ArcCannonTargetClassnames ) )
				continue

			if ( "GetTeam" in visibleEnt )
			{
				int visibleEntTeam = visibleEnt.GetTeam()
				if ( visibleEntTeam == ownerTeam )
					continue
				if ( IsEntANeutralMegaTurret( visibleEnt, ownerTeam ) )
					continue
			}

			expect string( classname )
			string targetname = visibleEnt.GetTargetName()

			if ( missileCheck && ( classname != "rpg_missile" && !file.missileCheckTargetnames.contains( targetname ) ) )
				continue

			if ( !missileCheck && ( classname == "rpg_missile" || file.missileCheckTargetnames.contains( targetname ) ) )
				continue

			firstTargetInfo.target = visibleEnt
			firstTargetInfo.hitLocation = result.visiblePosition
			break
		}
	}
	//
	WeaponFireBulletSpecialParams fireBulletParams
	fireBulletParams.pos = attackParams.pos
	fireBulletParams.dir = attackParams.dir
	fireBulletParams.bulletCount = 1
	fireBulletParams.scriptDamageType = 0
	fireBulletParams.skipAntiLag = true
	fireBulletParams.dontApplySpread = true
	fireBulletParams.doDryFire = true
	fireBulletParams.noImpact = true
	fireBulletParams.noTracer = true
	fireBulletParams.activeShot = false
	fireBulletParams.doTraceBrushOnly = false
	weapon.FireWeaponBullet_Special( fireBulletParams )

	return firstTargetInfo
}

void function FireArcNoTargets( entity weapon, WeaponPrimaryAttackParams attackParams, vector muzzleOrigin )
{
	Assert( IsValid( weapon ) )
	entity player = weapon.GetWeaponOwner()
	float chargeFrac = GetWeaponChargeFrac( weapon )
	vector beamVec = attackParams.dir * weapon.GetMaxDamageFarDist()
	vector playerEyePos = player.EyePosition()
	TraceResults traceResults = TraceLineHighDetail( playerEyePos, (playerEyePos + beamVec), weapon, (TRACE_MASK_PLAYERSOLID_BRUSHONLY | TRACE_MASK_BLOCKLOS), TRACE_COLLISION_GROUP_NONE )
	vector beamEnd = traceResults.endPos

	VortexBulletHit ornull vortexHit = VortexBulletHitCheck( player, playerEyePos, beamEnd )
	if ( vortexHit )
	{
		expect VortexBulletHit( vortexHit )
		#if(false)




//




//

//


#endif
		beamEnd = vortexHit.hitPos
	}

	float radius = Graph( chargeFrac, 0, 1, ARC_CANNON_BOLT_RADIUS_MIN, ARC_CANNON_BOLT_RADIUS_MAX )
	thread CreateArcCannonBeam( weapon, null, muzzleOrigin, beamEnd, player, ARC_CANNON_BEAM_LIFETIME, radius, 2, true )

	#if(false)

#endif
}

void function FireArcWithTargets( entity weapon, table firstTargetInfo, WeaponPrimaryAttackParams attackParams, vector muzzleOrigin )
{
	entity player = weapon.GetWeaponOwner()
	float chargeFrac = GetWeaponChargeFrac( weapon )
	float radius = Graph( chargeFrac, 0, 1, ARC_CANNON_BOLT_RADIUS_MIN, ARC_CANNON_BOLT_RADIUS_MAX )
	float boltWidth = Graph( chargeFrac, 0, 1, ARC_CANNON_BOLT_WIDTH_MIN, ARC_CANNON_BOLT_WIDTH_MAX )
	int maxChains
	int minChains

	if ( weapon.HasMod( "burn_mod_titan_arc_cannon" ) )
	{
		if ( player.IsNPC() )
			maxChains = ARC_CANNON_CHAIN_COUNT_NPC_BURN
		else
			maxChains = ARC_CANNON_CHAIN_COUNT_MAX_BURN

		minChains = ARC_CANNON_CHAIN_COUNT_MIN_BURN
	}
	else
	{
		if ( player.IsNPC() )
			maxChains = ARC_CANNON_CHAIN_COUNT_NPC
		else
			maxChains = ARC_CANNON_CHAIN_COUNT_MAX

		minChains = ARC_CANNON_CHAIN_COUNT_MIN
	}

	if ( !player.IsNPC() )
		maxChains = int( Graph( chargeFrac, 0, 1, minChains, maxChains ) )

	table zapInfo
	zapInfo.weapon 			<- weapon
	zapInfo.player 			<- player
	zapInfo.muzzleOrigin	<- muzzleOrigin
	zapInfo.radius			<- radius
	zapInfo.boltWidth		<- boltWidth
	zapInfo.maxChains		<- maxChains
	zapInfo.chargeFrac		<- chargeFrac
	zapInfo.zappedTargets 	<- {}
	zapInfo.zappedTargets[ firstTargetInfo.target ] <- true
	zapInfo.dmgSourceID 	<- weapon.GetDamageSourceID()
	int chainNum = 1
	thread ZapTargetRecursive( expect entity( firstTargetInfo.target), zapInfo, expect vector( zapInfo.muzzleOrigin ), expect vector( firstTargetInfo.hitLocation ), chainNum )
}

void function ZapTargetRecursive( entity target, table zapInfo, vector beamStartPos, vector ornull firstTargetBeamEndPos = null, int chainNum = 1 )
{
	if ( !IsValid( target ) )
		return

	if ( !IsValid( zapInfo.weapon ) )
		return

	Assert( target in zapInfo.zappedTargets )
	if ( chainNum > zapInfo.maxChains )
		return

	vector beamEndPos
	if ( firstTargetBeamEndPos == null )
		beamEndPos = target.GetWorldSpaceCenter()
	else
		beamEndPos = expect vector( firstTargetBeamEndPos )

	waitthread ZapTarget( zapInfo, target, beamStartPos, beamEndPos, chainNum )

	//
	#if(false)






//

//












//
//
//
//

#endif
}

void function ZapTarget( table zapInfo, entity target, vector beamStartPos, vector beamEndPos, int chainNum = 1 )
{
	//

	bool firstBeam = ( chainNum == 1 )
	#if(false)




#endif

	thread CreateArcCannonBeam( expect entity( zapInfo.weapon ), target, beamStartPos, beamEndPos, expect entity( zapInfo.player ), ARC_CANNON_BEAM_LIFETIME, zapInfo.radius, 5, firstBeam )

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










#endif //
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



#endif //

bool function IsEntANeutralMegaTurret( entity ent, int playerTeam )
{
	if ( ent.GetNetworkedClassName() != "npc_turret_mega" )
		return false
	int entTeam = ent.GetTeam()
	if ( entTeam == playerTeam )
		return false
	if ( !IsEnemyTeam( playerTeam, entTeam ) )
		return true

	return false
}

void function ArcCannon_HideIdleEffect( entity weapon, float delay )
{
	bool weaponOwnerIsPilot = IsPilot( weapon.GetWeaponOwner() )
	weapon.EndSignal( ARC_CANNON_SIGNAL_DEACTIVATED )
	if ( weaponOwnerIsPilot == false )
	{
		weapon.StopWeaponEffect( $"wpn_arc_cannon_electricity_fp", $"wpn_arc_cannon_electricity" )
		weapon.StopWeaponSound( "arc_cannon_charged_loop" )
	}
	wait delay

	if ( !IsValid( weapon ) )
		return

	entity weaponOwner = weapon.GetWeaponOwner()
	//
	//
	if ( !IsValid( weaponOwner ) )
		return

	if ( weapon != weaponOwner.GetActiveWeapon( eActiveInventorySlot.mainHand ) )
		return

	if ( weaponOwnerIsPilot == false )
	{
		weapon.PlayWeaponEffectNoCull( $"wpn_arc_cannon_electricity_fp", $"wpn_arc_cannon_electricity", "muzzle_flash" )
		weapon.EmitWeaponSound( "arc_cannon_charged_loop" )
	}
	else
	{
		weapon.EmitWeaponSound_1p3p( "Arc_Rifle_charged_Loop_1P", "Arc_Rifle_charged_Loop_3P" )
	}
}

#if(false)
















































#endif //

//
void function CreateArcCannonBeam( entity weapon, entity target, vector startPos, vector endPos, entity player, float lifeDuration = ARC_CANNON_BEAM_LIFETIME, radius = 256, noiseAmplitude = 5, bool firstBeam = false )
{
	//
	//
	//
	if ( weapon.HasMod( "burn_mod_titan_arc_cannon" ) )
		lifeDuration = ARC_CANNON_BEAM_LIFETIME_BURN
	//
	#if(CLIENT)
		if ( firstBeam )
			thread CreateClientArcBeam( weapon, endPos, lifeDuration )
	#endif

	#if(false)
//















//








#endif
}

asset function GetBeamEffect( entity weapon )
{
	if ( weapon.HasMod( "burn_mod_titan_arc_cannon" ) )
		return ARC_CANNON_BEAM_EFFECT_MOD

	return ARC_CANNON_BEAM_EFFECT
}

#if(CLIENT)
void function CreateClientArcBeam( entity weapon, vector endPos, float lifeDuration )
{
	Assert( IsClient() )

	asset beamEffect = GetBeamEffect( weapon )

	//
	string tag = "muzzle_flash"
	if ( weapon.GetWeaponInfoFileKeyField( "client_tag_override" ) != null )
		tag = expect string( weapon.GetWeaponInfoFileKeyField( "client_tag_override" ) )

	int handle = weapon.PlayWeaponEffectReturnViewEffectHandle( beamEffect, $"", tag )
	if ( !EffectDoesExist( handle ) )
		return

	EffectSetControlPointVector( handle, 1, endPos )

	if ( weapon.HasMod( "burn_mod_titan_arc_cannon" ) )
		lifeDuration = ARC_CANNON_BEAM_LIFETIME_BURN

	wait( lifeDuration )

	if ( IsValid( weapon ) )
		weapon.StopWeaponEffect( beamEffect, $"" )
}

void function ClientDestroyCallback_ArcCannon_Stop( entity ent )
{
	ArcCannon_Stop( ent )
}
#endif //

float function GetArcCannonChargeFraction( entity weapon )
{
	if ( IsValid( weapon ) )
	{
		float chargeRatio = ARC_CANNON_DAMAGE_CHARGE_RATIO
		if ( weapon.HasMod( "capacitor" ) )
			chargeRatio = ARC_CANNON_CAPACITOR_CHARGE_RATIO
		if ( weapon.GetWeaponSettingBool( eWeaponVar.is_burn_mod ) )
			chargeRatio = ARC_CANNON_DAMAGE_CHARGE_RATIO_BURN
		return chargeRatio
	}

	return 0
}

float function GetWeaponChargeFrac( entity weapon )
{
	if ( weapon.IsChargeWeapon() )
		return weapon.GetWeaponChargeFraction()
	return 1.0
}