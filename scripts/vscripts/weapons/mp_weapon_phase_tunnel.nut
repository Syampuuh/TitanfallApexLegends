global function MpWeaponPhaseTunnel_Init
global function OnWeaponActivate_weapon_phase_tunnel
global function OnWeaponDeactivate_weapon_phase_tunnel
global function OnWeaponAttemptOffhandSwitch_weapon_phase_tunnel

global function OnWeaponChargeBegin_weapon_phase_tunnel
global function OnWeaponChargeEnd_weapon_phase_tunnel

global function OnWeaponPrimaryAttack_ability_phase_tunnel
#if(false)

#endif

const float CROUCH_HEIGHT = 48

const string SOUND_ACTIVATE_1P = "Wraith_PhaseGate_FirstGate_DeviceActivate_1p" //
const string SOUND_ACTIVATE_3P = "Wraith_PhaseGate_FirstGate_DeviceActivate_3p" //
const string SOUND_SUCCESS_1P = "Wraith_PhaseGate_FirstGate_Place_1p" //
const string SOUND_SUCCESS_3P = "Wraith_PhaseGate_FirstGate_Place_3p" //
const string SOUND_PREPORTAL_LOOP = "Wraith_PhaseGate_PrePortal_Loop" //
const string SOUND_PORTAL_OPEN = "Wraith_PhaseGate_Portal_Open" //
const string SOUND_PORTAL_LOOP = "Wraith_PhaseGate_Portal_Loop" //
const string SOUND_PORTAL_CLOSE = "Wraith_PhaseGate_Portal_Expire" //

global const string PHASETUNNEL_BLOCKER_SCRIPTNAME = "phase_tunnel_blocker"
global const string PHASETUNNEL_PRE_BLOCKER_SCRIPTNAME = "pre_phase_tunnel_blocker"

const float FRAME_TIME = 0.1

const asset PHASE_TUNNEL_3P_FX = $"P_ps_gauntlet_arm_3P"
const asset PHASE_TUNNEL_PREPLACE_FX = $"P_phasegate_pre_portal"
const asset PHASE_TUNNEL_FX = $"P_phasegate_portal"
const asset PHASE_TUNNEL_CROUCH_FX = $"P_phasegate_portal_rnd"
const asset PHASE_TUNNEL_ABILITY_ACTIVE_FX = $"P_phase_dash_start"
const asset PHASE_TUNNEL_1P_FX = $"P_phase_tunnel_player"

const float PHASE_TUNNEL_WEAPON_DRAW_DELAY = 0.75

const float PHASE_TUNNEL_TRIGGER_RADIUS = 16.0
const float PHASE_TUNNEL_TRIGGER_HEIGHT = 32.0
const float PHASE_TUNNEL_TRIGGER_HEIGHT_CROUCH = 16.0
const float PHASE_TUNNEL_TRIGGER_RADIUS_PROJECTILE = 42.0
const float PHASE_TUNNEL_TRIGGER_RADIUS_PROJECTILE_CROUCH = 24.0

//
const float PHASE_TUNNEL_PLACEMENT_HEIGHT_STANDING = 45.0
const float PHASE_TUNNEL_PLACEMENT_HEIGHT_CROUCHING = 20

//
const float PHASE_TUNNEL_LIFETIME = 60.0
const float PHASE_TUNNEL_TELEPORT_TRAVEL_TIME_MIN = 0.3
const float PHASE_TUNNEL_TELEPORT_TRAVEL_TIME_MAX = 2.0
const float PHASE_TUNNEL_TELEPORT_DBOUNCE = 0.5
const float PHASE_TUNNEL_TELEPORT_DBOUNCE_PROJECTILE = 1.0
const float PHASE_TUNNEL_PATH_FOLLOW_TICK = 0.1
const float PHASE_TUNNEL_PATH_SNAPSHOT_INTERVAL = 0.1

const float PHASE_TUNNEL_PLACEMENT_RADIUS 	= 4098.0
const float PHASE_TUNNEL_PLACEMENT_DIST		= 4098.0
const float PHASE_TUNNEL_MIN_PORTAL_DIST_SQR = 128.0 * 128.0
const float PHASE_TUNNEL_MIN_GEO_REVERSE_DIST = 48.0

const bool	PHASE_TUNNEL_DEBUG_DRAW_PROJECTILE_TELEPORT = false
const bool 	PHASE_TUNNEL_DEBUG_DRAW_PLAYER_TELEPORT = false

struct PhaseTunnelPathNodeData
{
	vector origin
	vector angles
	vector velocity
	bool wasInContextAction
	bool wasCrouched
	bool validExit
	float time
}

struct PhaseTunnelPathData
{
	float                            pathDistance 	= 0
	float                            pathTime		= 0
	array< PhaseTunnelPathNodeData > pathNodes
}

struct PhaseTunnelPortalData
{
	vector                           startOrigin
	vector                           startAngles
	entity                           portalFX
	vector                           endOrigin
	vector                           endAngles
	bool							 crouchPortal
	PhaseTunnelPathData&			pathData
}

struct PhaseTunnelData
{
	entity                 tunnelEnt
	int                    activeUsers = 0
	table< entity, float > entPhaseTime
	PhaseTunnelPortalData& startPortal
	PhaseTunnelPortalData& endPortal
}

struct
{
	#if(false)






#endif //
} file

void function MpWeaponPhaseTunnel_Init()
{
	PrecacheParticleSystem( PHASE_TUNNEL_PREPLACE_FX )
	PrecacheParticleSystem( PHASE_TUNNEL_FX )
	PrecacheParticleSystem( PHASE_TUNNEL_CROUCH_FX )
	PrecacheParticleSystem( PHASE_TUNNEL_ABILITY_ACTIVE_FX )
	PrecacheParticleSystem( PHASE_TUNNEL_1P_FX )
	PrecacheParticleSystem( PHASE_TUNNEL_3P_FX )

	AddCallback_PlayerCanUseZipline( PhaseTunnel_CanUseZipline )

	#if(false)




#endif //

	#if(CLIENT)
		RegisterSignal( "EndTunnelVisual" )

		AddCreateCallback( "prop_script", PhaseTunnel_OnPropScriptCreated )
		StatusEffect_RegisterEnabledCallback( eStatusEffect.placing_phase_tunnel, PhaseTunnel_OnBeginPlacement)
		StatusEffect_RegisterDisabledCallback( eStatusEffect.placing_phase_tunnel, PhaseTunnel_OnEndPlacement )

		StatusEffect_RegisterEnabledCallback( eStatusEffect.phase_tunnel_visual, TunnelVisualsEnabled )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.phase_tunnel_visual, TunnelVisualsDisabled )

		AddCreateCallback( PLAYER_WAYPOINT_CLASSNAME, PlayerWaypoint_CreateCallback )
	#endif
}


void function OnWeaponActivate_weapon_phase_tunnel( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )

	float raise_time = weapon.GetWeaponSettingFloat( eWeaponVar.raise_time )

	#if(false)


#endif

	#if(CLIENT)
		if ( !InPrediction() ) //
			return

		EmitSoundOnEntity( ownerPlayer, SOUND_ACTIVATE_1P )
		//
	#endif

	StatusEffect_AddTimed( ownerPlayer, eStatusEffect.move_slow, 0.8, raise_time, raise_time )
}

void function OnWeaponDeactivate_weapon_phase_tunnel( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )
	#if(CLIENT)
		if ( !InPrediction() ) //
			return

		//
	#endif
}

bool function OnWeaponAttemptOffhandSwitch_weapon_phase_tunnel( entity weapon )
{
	int ammoReq = weapon.GetAmmoPerShot()
	int currAmmo = weapon.GetWeaponPrimaryClipCount()
	if ( currAmmo < ammoReq )
		return false

	entity player = weapon.GetWeaponOwner()
	if ( player.IsPhaseShifted() )
		return false

	if ( player.IsZiplining() )
		return false

	return true
}

bool function OnWeaponChargeBegin_weapon_phase_tunnel( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	float shiftTime = PHASE_TUNNEL_PLACEMENT_DURATION

	//

	if ( IsAlive( player ) )
	{
		if ( player.IsPlayer() )
		{
			PlayerUsedOffhand( player, weapon, false )
			int attachIndex = player.LookupAttachment( "R_FOREARM" )

			Assert( attachIndex > 0 )
			if ( attachIndex == 0 )
			{
				return false
			}

			#if(false)










#elseif(CLIENT)
				AddPlayerHint( PHASE_TUNNEL_PLACEMENT_DURATION, 0, $"", "#WPN_PHASE_TUNNEL_PLAYER_DEPLOY_STOP_HINT" )
				HidePlayerHint( "#WPN_PHASE_TUNNEL_PLAYER_DEPLOY_START_HINT" )
				EmitSoundOnEntity( player, "Wraith_PhaseGate_GauntletArcs_1p" )
			#endif
		}
		//
	}
	return true
}

void function OnWeaponChargeEnd_weapon_phase_tunnel( entity weapon )
{
	entity player = weapon.GetWeaponOwner()

	//

	#if(CLIENT)
		HidePlayerHint( "#WPN_PHASE_TUNNEL_PLAYER_DEPLOY_STOP_HINT" )
		StopSoundOnEntity( player, "Wraith_PhaseGate_GauntletArcs_1p" )
	#endif //

#if(false)















#endif
}

bool function PhaseTunnel_CanUseZipline( entity player,  entity zipline, vector ziplineClosestPoint )
{
	if ( StatusEffect_GetSeverity( player, eStatusEffect.placing_phase_tunnel ) )
		return false

	return true
}

#if(false)













#endif

var function OnWeaponPrimaryAttack_ability_phase_tunnel( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	//
	entity player = weapon.GetWeaponOwner()

	float shiftTime = PHASE_TUNNEL_PLACEMENT_DURATION

	if ( IsAlive( player ) )
	{
		#if(false)

#endif //
	}

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
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























/*






*/












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
void function PlayerWaypoint_CreateCallback( entity wp )
{
	int pingType = Waypoint_GetPingTypeForWaypoint( wp )

	int wpType = wp.GetWaypointType()

	if ( WaypointOwnerIsMuted( wp ) )
		return

	if ( pingType == ePingType.ABILITY_WORMHOLE && wpType == eWaypoint.PING_LOCATION )
	{
		thread TrackIsVisible( wp )
	}
}


//

//
//
//

//

void function TrackIsVisible( entity wp )
{
	entity viewPlayer = GetLocalViewPlayer()

	if ( !IsValid( viewPlayer ) )
		return

	viewPlayer.EndSignal( "OnDeath" )

	while( IsValid( wp ) )
	{
		if ( wp.wp.ruiHud != null )
		{
			RuiSetBool( wp.wp.ruiHud, "hideIcon", PlayerCanSeePos( viewPlayer, wp.GetOrigin(), true, 25.0 ) )
		}

		WaitFrame()
	}
}

void function PhaseTunnel_OnPropScriptCreated( entity ent )
{
	switch ( ent.GetScriptName() )
	{
		case "portal_marker":
			//
			break
	}
}

void function PhaseTunnel_CreateHUDMarker( entity portalMarker )
{
	//

	entity localClientPlayer = GetLocalClientPlayer()

	portalMarker.EndSignal( "OnDestroy" )

	if ( !PhaseTunnel_ShouldShowIcon( localClientPlayer, portalMarker ) )
		return

	vector pos = portalMarker.GetOrigin()
	var topology = CreateRUITopology_Worldspace( portalMarker.GetOrigin(), portalMarker.GetAngles(), 24, 24 )
	var ruiPlane = RuiCreate( $"ui/phase_tunnel_timer.rpak", topology, RUI_DRAW_WORLD, 0 )
	RuiSetGameTime( ruiPlane, "startTime", Time() )
	RuiSetFloat( ruiPlane, "lifeTime", PHASE_TUNNEL_LIFETIME )

	OnThreadEnd(
		function() : ( ruiPlane, topology )
		{
			RuiDestroy( ruiPlane )
			RuiTopology_Destroy( topology )
		}
	)

	WaitForever()
}

bool function PhaseTunnel_ShouldShowIcon( entity localPlayer, entity portalMarker )
{
	if ( !GamePlayingOrSuddenDeath() )
		return false

	//
	//

	//
	//

	return true
}

void function PhaseTunnel_OnBeginPlacement( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return
}

void function PhaseTunnel_OnEndPlacement( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

}

void function TunnelVisualsEnabled( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( ent != GetLocalViewPlayer() )
		return

	entity player = ent

	entity cockpit = player.GetCockpit()
	if ( !IsValid( cockpit ) )
		return

	int fxHandle = StartParticleEffectOnEntity( cockpit, GetParticleSystemIndex( PHASE_TUNNEL_1P_FX ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
	thread TunnelScreenFXThink( player, fxHandle, cockpit )
}

void function TunnelVisualsDisabled( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( ent != GetLocalViewPlayer() )
		return

	ent.Signal( "EndTunnelVisual" )
}

void function TunnelScreenFXThink( entity player, int fxHandle, entity cockpit )
{
	player.EndSignal( "EndTunnelVisual" )
	player.EndSignal( "OnDeath" )
	cockpit.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ( fxHandle )
		{
			if ( !EffectDoesExist( fxHandle ) )
				return

			EffectStop( fxHandle, false, true )
		}
	)

	for ( ;; )
	{
		float velocityX = Length( player.GetVelocity() )

		if ( !EffectDoesExist( fxHandle ) )
			break

		velocityX = GraphCapped( velocityX, 0.0, 360, 5, 200 )
		EffectSetControlPointVector( fxHandle, 1, <velocityX,999,0> )
		WaitFrame()
	}
}
#endif //