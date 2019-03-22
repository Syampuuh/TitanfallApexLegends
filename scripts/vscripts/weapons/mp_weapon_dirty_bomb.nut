
global function MpWeaponDirtyBomb_Init

global function OnWeaponTossReleaseAnimEvent_weapon_dirty_bomb
global function OnWeaponTossPrep_weapon_dirty_bomb

global function OnWeaponAttemptOffhandSwitch_weapon_dirty_bomb
global function OnWeaponPrimaryAttack_weapon_dirty_bomb
global function OnWeaponActivate_weapon_dirty_bomb
global function OnWeaponDeactivate_weapon_dirty_bomb

#if(false)

#endif

global const string DIRTY_BOMB_TARGETNAME = "caustic_trap"

const asset DIRTY_BOMB_CANISTER_MODEL = $"mdl/props/caustic_gas_tank/caustic_gas_tank.rmdl"

const asset DIRTY_BOMB_CANISTER_EXP_FX = $"P_meteor_trap_EXP"
const asset DIRTY_BOMB_CANISTER_FX_ALL = $"P_gastrap_start"

const int DIRTY_BOMB_MAX_GAS_CANISTERS = 6

const string DIRTY_BOMB_WARNING_SOUND 	= "weapon_vortex_gun_explosivewarningbeep"

const float DIRTY_BOMB_GAS_RADIUS = 256.0
const float DIRTY_BOMB_GAS_DURATION = 12.5
const float DIRTY_BOMB_DETECTION_RADIUS = 140.0

const float DIRTY_BOMB_THROW_POWER = 1.0
const float DIRTY_BOMB_GAS_FX_HEIGHT = 45.0
const float DIRTY_BOMB_GAS_CLOUD_HEIGHT = 48.0

//
const float DIRTY_BOMB_ACTIVATE_DELAY = 0.2
const float DIRTY_BOMB_PLACEMENT_RANGE_MAX = 64
const float DIRTY_BOMB_PLACEMENT_RANGE_MIN = 32
const vector DIRTY_BOMB_BOUND_MINS = <-8,-8,-8>
const vector DIRTY_BOMB_BOUND_MAXS = <8,8,8>
const vector DIRTY_BOMB_PLACEMENT_TRACE_OFFSET = <0,0,128>
const float DIRTY_BOMB_ANGLE_LIMIT = 0.55
const float DIRTY_BOMB_PLACEMENT_MAX_HEIGHT_DELTA = 20.0

const bool CAUSTIC_DEBUG_DRAW_PLACEMENT = false

struct DirtyBombPlacementInfo
{
	vector origin
	vector angles
	entity parentTo
	bool success = false
	bool doDeployAnim = true
}

struct DirtyBombPlayerPlacementData
{
	vector viewOrigin	//
	vector viewForward	//
	vector playerOrigin //
	vector playerForward //
}

struct
{
	#if(false)

#endif
} file

void function MpWeaponDirtyBomb_Init()
{
	DirtyBombPrecache()
}

void function DirtyBombPrecache()
{
	RegisterSignal( "DirtyBomb_Detonated" )
	RegisterSignal( "DirtyBomb_PickedUp" )
	RegisterSignal( "DirtyBomb_Disarmed" )
	RegisterSignal( "DirtyBomb_Active" )

	PrecacheParticleSystem( DIRTY_BOMB_CANISTER_EXP_FX )
	PrecacheParticleSystem( DIRTY_BOMB_CANISTER_FX_ALL )
	PrecacheModel( DIRTY_BOMB_CANISTER_MODEL )

	#if(CLIENT)
		RegisterSignal( "DirtyBomb_StopPlacementProxy" )
		StatusEffect_RegisterEnabledCallback( eStatusEffect.placing_caustic_barrel, DirtyBomb_OnBeginPlacement )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.placing_caustic_barrel, DirtyBomb_OnEndPlacement )

		AddCreateCallback( "prop_script", DirtyBomb_OnPropScriptCreated )
	#endif
}

void function OnWeaponActivate_weapon_dirty_bomb( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	weapon.w.startChargeTime = Time()

	Assert( ownerPlayer.IsPlayer() )
	#if(CLIENT)
		if ( !InPrediction() ) //
			return
	#endif

	int statusEffect = eStatusEffect.placing_caustic_barrel

	StatusEffect_AddEndless( ownerPlayer, statusEffect, 1.0 )

	#if(false)

#endif
}


void function OnWeaponDeactivate_weapon_dirty_bomb( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )
	#if(CLIENT)
		if ( !InPrediction() ) //
			return
	#endif
	StatusEffect_StopAllOfType( ownerPlayer, eStatusEffect.placing_caustic_barrel )

	#if(false)

#endif
}


var function OnWeaponPrimaryAttack_weapon_dirty_bomb( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )

	asset model = DIRTY_BOMB_CANISTER_MODEL

	entity proxy = CreateProxyBombModel( model )
	DirtyBombPlacementInfo placementInfo = GetDirtyBombPlacementInfo( ownerPlayer, proxy )
	proxy.Destroy()

	if ( !placementInfo.success )
	{
		#if(CLIENT)
		EmitSoundOnEntity( ownerPlayer, "Wpn_ArcTrap_Beep" )
		#endif
		return 0
	}
	#if(false)






#endif

	PlayerUsedOffhand( ownerPlayer, weapon, true, null, {pos = placementInfo.origin} )
	return weapon.GetAmmoPerShot()
}

bool function OnWeaponAttemptOffhandSwitch_weapon_dirty_bomb( entity weapon )
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
//











//









//













































//
//



















//



































#endif //

#if(CLIENT)
	void function DirtyBomb_OnPropScriptCreated( entity ent )
	{
		switch ( ent.GetScriptName() )
		{
			case DIRTY_BOMB_TARGETNAME:
				AddEntityCallback_GetUseEntOverrideText( ent, DirtyBomb_UseTextOverride )
				//
			break
		}
	}

	string function DirtyBomb_UseTextOverride( entity ent )
	{
		entity player = GetLocalViewPlayer()

		if ( player.IsTitan() )
			return "#WPN_DIRTY_BOMB_NO_INTERACTION"

		if ( player == ent.GetBossPlayer() )
		{
			return ""
		}

		//
		//
		//
		//

		return "#WPN_DIRTY_BOMB_NO_INTERACTION"
	}

	void function DirtyBomb_CreateBombHUDMarker( entity bomb )
	{
		entity localClientPlayer = GetLocalClientPlayer()

		bomb.EndSignal( "OnDestroy" )

		if ( !ShouldShowBombIcon( localClientPlayer, bomb ) )
			return

		vector pos = bomb.GetOrigin() + <0,0,DIRTY_BOMB_GAS_CLOUD_HEIGHT>
		var rui = CreateCockpitRui( $"ui/dirty_bomb_marker_icons.rpak", RuiCalculateDistanceSortKey( localClientPlayer.EyePosition(), pos ) )
		RuiSetGameTime( rui, "startTime", Time() )
		RuiTrackFloat( rui, "healthFrac", bomb, RUI_TRACK_HEALTH )
		RuiTrackFloat3( rui, "pos", bomb, RUI_TRACK_POINT_FOLLOW, bomb.LookupAttachment( "fx_top" ) )
		RuiKeepSortKeyUpdated( rui, true, "pos" )

		RuiSetImage( rui, "bombImage", $"rui/hud/gametype_icons/raid/bomb_icon_friendly" )
		RuiSetImage( rui, "triggeredImage", $"rui/pilot_loadout/ordnance/electric_smoke" )

		OnThreadEnd(
		function() : ( rui )
		{
			RuiDestroy( rui )
		}
		)

		WaitForever()
	}

bool function ShouldShowBombIcon( entity localPlayer, entity bomb )
{
	if ( !GamePlayingOrSuddenDeath() )
		return false

	//
	//
	entity owner = bomb.GetBossPlayer()
	if ( !IsValid( owner ) )
		return false

	if ( localPlayer.GetTeam() != owner.GetTeam() )
		return false

	return true
}

void function DirtyBomb_OnBeginPlacement( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	thread DirtyBombPlacement( player )
}

void function DirtyBomb_OnEndPlacement( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	player.Signal( "DirtyBomb_StopPlacementProxy" )
}

void function DirtyBombPlacement( entity player )
{
	player.EndSignal( "DirtyBomb_StopPlacementProxy" )

	entity bomb = CreateProxyBombModel( DIRTY_BOMB_CANISTER_MODEL )
	bomb.EnableRenderAlways()
	bomb.Show()
	DeployableModelHighlight( bomb )

	var placementRui = CreateCockpitRui( $"ui/generic_trap_placement.rpak", RuiCalculateDistanceSortKey( player.EyePosition(), bomb.GetOrigin() ) )
	int placementAttachment = bomb.LookupAttachment( "fx_top" )
	RuiSetBool( placementRui, "staticPosition", true )
	RuiSetInt( placementRui, "trapLimit", DIRTY_BOMB_MAX_GAS_CANISTERS )
	RuiTrackFloat3( placementRui, "mainTrapPos", bomb, RUI_TRACK_POINT_FOLLOW, placementAttachment )
	RuiKeepSortKeyUpdated( placementRui, true, "mainTrapPos" )
	RuiSetImage( placementRui, "trapIcon", $"rui/pilot_loadout/ordnance/electric_smoke" )

	OnThreadEnd(
		function() : ( bomb, placementRui )
		{
			if ( IsValid( bomb ) )
				bomb.Destroy()

			RuiDestroy( placementRui )
		}
	)

	while ( true )
	{
		DirtyBombPlacementInfo placementInfo = GetDirtyBombPlacementInfo( player, bomb )

		if ( !placementInfo.success )
			DeployableModelInvalidHighlight( bomb )
		else if ( placementInfo.success )
			DeployableModelHighlight( bomb )

		RuiSetBool( placementRui, "success", placementInfo.success )
		RuiSetInt( placementRui, "trapCount", DirtyBomb_GetOwnedTrapCountOnClient( player ) )

		bomb.SetOrigin( placementInfo.origin )
		bomb.SetAngles( placementInfo.angles )

		WaitFrame()
	}
}

int function DirtyBomb_GetOwnedTrapCountOnClient( entity player )
{
	int count
	array<entity> traps = GetEntArrayByScriptName( "dirty_bomb" )
	foreach ( entity trap in traps )
	{
		if ( trap.GetBossPlayer() == player )
			count++
	}

	return count
}

#endif //

entity function CreateProxyBombModel( asset modelName )
{
	#if(false)

#else
		entity proxy = CreateClientSidePropDynamic( <0,0,0>, <0,0,0>, modelName )
	#endif
	proxy.kv.renderamt = 255
	proxy.kv.rendermode = 3
	proxy.kv.rendercolor = "255 255 255 255"
	proxy.Hide()

	return proxy
}

DirtyBombPlacementInfo function GetDirtyBombPlacementInfo( entity player, entity bombModel )
{
	vector eyePos = player.EyePosition()
	vector viewVec = player.GetViewVector()
	vector angles = < 0, VectorToAngles( viewVec ).y, 0 >
	//

	float maxRange = DIRTY_BOMB_PLACEMENT_RANGE_MAX

	TraceResults viewTraceResults = TraceLine( eyePos, eyePos + player.GetViewVector() * (DIRTY_BOMB_PLACEMENT_RANGE_MAX * 2), [player, bombModel], TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_BLOCK_WEAPONS )
	if ( viewTraceResults.fraction < 1.0 )
	{
		float slope = fabs( viewTraceResults.surfaceNormal.x ) + fabs( viewTraceResults.surfaceNormal.y )
		if ( slope < 0.707 )
			maxRange = min( Distance2D( eyePos, viewTraceResults.endPos ), DIRTY_BOMB_PLACEMENT_RANGE_MAX )
	}

	vector idealPos = player.GetOrigin() + ( AnglesToForward( angles ) * DIRTY_BOMB_PLACEMENT_RANGE_MAX )

	vector fwdStart = eyePos + viewVec * min( DIRTY_BOMB_PLACEMENT_RANGE_MIN, maxRange )
	TraceResults fwdResults = TraceHull( fwdStart, eyePos + viewVec * maxRange, DIRTY_BOMB_BOUND_MINS, <30,30,1>, player, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_BLOCK_WEAPONS )
	TraceResults downResults = TraceHull( fwdResults.endPos, fwdResults.endPos - DIRTY_BOMB_PLACEMENT_TRACE_OFFSET, DIRTY_BOMB_BOUND_MINS, DIRTY_BOMB_BOUND_MAXS, player, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_BLOCK_WEAPONS )

	//
	//
	//
	//

	DirtyBombPlacementInfo placementInfo = DirtyBomb_GetPlacementInfoFromTraceResults( player, bombModel, downResults, viewTraceResults, idealPos )

	if ( !placementInfo.success )
	{
		//
		vector fallbackPos = fwdResults.endPos - ( viewVec * Length( DIRTY_BOMB_BOUND_MINS ) )
		TraceResults downFallbackResults = TraceHull( fallbackPos, fallbackPos - DIRTY_BOMB_PLACEMENT_TRACE_OFFSET, DIRTY_BOMB_BOUND_MINS, DIRTY_BOMB_BOUND_MAXS, [player, bombModel], TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_BLOCK_WEAPONS )

		//
		//
		//
		//

		placementInfo = DirtyBomb_GetPlacementInfoFromTraceResults( player, bombModel, downFallbackResults, viewTraceResults, idealPos )
	}

	return placementInfo
}

DirtyBombPlacementInfo function DirtyBomb_GetPlacementInfoFromTraceResults( entity player, entity bombModel, TraceResults hullTraceResults, TraceResults viewTraceResults, vector idealPos )
{
	vector viewVec = player.GetViewVector()
	vector angles  = < 0, VectorToAngles( viewVec ).y, 0 >

	bool isScriptedPlaceable = false
	if ( IsValid( hullTraceResults.hitEnt ) )
	{
		var hitEntClassname = hullTraceResults.hitEnt.GetNetworkedClassName()

		if ( hitEntClassname == "prop_script" )
		{
			if ( hullTraceResults.hitEnt.GetScriptPropFlags() == PROP_IS_VALID_FOR_TURRET_PLACEMENT )
				isScriptedPlaceable = true
		}
	}

	bool success = !hullTraceResults.startSolid && hullTraceResults.fraction < 1.0 && ( hullTraceResults.hitEnt.IsWorld() || hullTraceResults.hitEnt.GetNetworkedClassName() == "func_brush" || isScriptedPlaceable )

	entity parentTo
	if ( IsValid( hullTraceResults.hitEnt ) && hullTraceResults.hitEnt.GetNetworkedClassName() == "func_brush" )
	{
		parentTo = hullTraceResults.hitEnt
	}

	if ( hullTraceResults.startSolid && hullTraceResults.fraction < 1.0 && ( hullTraceResults.hitEnt.IsWorld() || isScriptedPlaceable ) )
	{
		TraceResults upResults = TraceHull( hullTraceResults.endPos, hullTraceResults.endPos, DIRTY_BOMB_BOUND_MINS, DIRTY_BOMB_BOUND_MAXS, player, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_BLOCK_WEAPONS )
		if ( !upResults.startSolid )
			success = true
	}

	if ( success )
	{
		bombModel.SetOrigin( hullTraceResults.endPos )
		bombModel.SetAngles( angles )
	}

	if ( !player.IsOnGround() )
		success = false

	//
	if ( success && hullTraceResults.fraction < 1.0 )
	{
		vector right = bombModel.GetRightVector()
		vector forward = bombModel.GetForwardVector()
		vector up = bombModel.GetUpVector()

		float length = Length( DIRTY_BOMB_BOUND_MINS )

		array< vector > groundTestOffsets = [
			Normalize( right + forward ) * length,
			Normalize( -right + forward ) * length,
			Normalize( right + -forward ) * length,
			Normalize( -right + -forward ) * length
		]

		foreach ( vector testOffset in groundTestOffsets )
		{
			vector testPos = bombModel.GetOrigin() + testOffset
			TraceResults traceResult = TraceLine( testPos + ( up * DIRTY_BOMB_PLACEMENT_MAX_HEIGHT_DELTA ), testPos + ( up * -DIRTY_BOMB_PLACEMENT_MAX_HEIGHT_DELTA ), [player, bombModel], TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_BLOCK_WEAPONS )

			if ( traceResult.fraction == 1.0 )
			{
				success = false
				break
			}
		}
	}

	//
	//
	if ( success && hullTraceResults.hitEnt != null && ( !hullTraceResults.hitEnt.IsWorld() && !isScriptedPlaceable ) )
	{
		//
		//
		success = false
	}

	//
	if ( success && !PlayerCanSeePos( player, hullTraceResults.endPos, false, 90 ) ) //
		success = false

	vector org = success ? hullTraceResults.endPos - <0,0,DIRTY_BOMB_BOUND_MAXS.z> : idealPos
	DirtyBombPlacementInfo placementInfo
	placementInfo.success = success
	placementInfo.origin = org
	placementInfo.angles = angles
	placementInfo.parentTo = parentTo

	return placementInfo
}

//
//
//

var function OnWeaponTossReleaseAnimEvent_weapon_dirty_bomb( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	int ammoReq = weapon.GetAmmoPerShot()
	weapon.EmitWeaponSound_1p3p( GetGrenadeThrowSound_1p( weapon ), GetGrenadeThrowSound_3p( weapon ) )

	entity deployable = ThrowDeployable( weapon, attackParams, DIRTY_BOMB_THROW_POWER, OnDirtyBombPlanted )
	if ( deployable )
	{
		entity player = weapon.GetWeaponOwner()
		PlayerUsedOffhand( player, weapon )

		#if(false)





#endif

		#if(false)

#endif

	}

	return ammoReq
}


void function OnWeaponTossPrep_weapon_dirty_bomb( entity weapon, WeaponTossPrepParams prepParams )
{
	weapon.EmitWeaponSound_1p3p( GetGrenadeDeploySound_1p( weapon ), GetGrenadeDeploySound_3p( weapon ) )
}

void function OnDirtyBombPlanted( entity projectile )
{
	#if(false)













#endif
}
