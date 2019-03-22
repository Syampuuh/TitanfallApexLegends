global function ShCarePackage_Init
global function GetCarePackagePlacementInfo
//
global function OnWeaponActivate_care_package
global function OnWeaponDeactivate_care_package
global function GetSkinForCarePackageModel

#if(CLIENT)
global function SetCarePackageDeployed
#endif //
#if(false)

#endif //

global const asset CARE_PACKAGE_AIRDROP_MODEL = $"mdl/vehicle/droppod_loot/droppod_loot_animated.rmdl"
global const string CARE_PACKAGE_IDLE = "droppod_loot_closed_idle"

global struct CarePackagePlacementInfo
{
	vector origin
	vector angles
	bool failed
	bool hide
}

struct
{
#if(CLIENT)
	bool carePackageDeployed
#endif
} file

/*























*/

void function ShCarePackage_Init()
{
	PrecacheModel( CARE_PACKAGE_AIRDROP_MODEL )

	#if(CLIENT)
		RegisterSignal( "DeployableCarePackagePlacement" )

		StatusEffect_RegisterEnabledCallback( eStatusEffect.placing_care_package, OnBeginPlacingCarePackage )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.placing_care_package, OnEndPlacingCarePackage )
	#endif

	#if(false)

#endif

	RegisterSignal( "DeploySentryTurret" )
}

#if(false)









#endif //

void function OnWeaponActivate_care_package( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )

	#if(CLIENT)
		SetCarePackageDeployed( false )
		if ( !InPrediction() ) //
			return
	#endif


	#if(false)

//
#endif
}


void function OnWeaponDeactivate_care_package( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )

	#if(CLIENT)
		if ( !InPrediction() ) //
			return
	#endif

	#if(false)

//
#endif
}

CarePackagePlacementInfo function GetCarePackagePlacementInfo( entity player )
{
	const MAX_UP_ANGLE = -20
	const MAX_DOWN_ANGLE = 75
	const VELOCITY_MULTIPLIER = 800
	const TRACE_TIME = 1.25
	const MIN_DIST_SQR = 72 * 72
	const PARENT_VELOCITY = <0,0,0>
	const SIGHT_TRACE_OFFSET = <0,0,48>

	bool failed = false
	bool hide = false

	CarePackagePlacementInfo placementInfo
	vector startPos    = player.EyePosition()
	vector flatForward = FlattenVector( player.GetViewVector() )
	vector placementAngles = ClampAngles( VectorToAngles( flatForward ) + <0,180,0> )

	vector eyeAngles = player.EyeAngles()
	float pitch = GraphCapped( eyeAngles.x, MAX_UP_ANGLE, MAX_DOWN_ANGLE, 0, 1 )
	pitch = PlacementEasing( pitch )

	float clampedPitch = GraphCapped( pitch, 0, 1, MAX_UP_ANGLE, MAX_DOWN_ANGLE )
	vector clampedEyeAngles = < clampedPitch, eyeAngles.y, eyeAngles.z >

	vector objectVelocity = AnglesToForward( clampedEyeAngles ) * VELOCITY_MULTIPLIER
	GravityLandData landData = GetGravityLandData( startPos, PARENT_VELOCITY, objectVelocity, TRACE_TIME, false )

	TraceResults traceResults = landData.traceResults

	vector origin = traceResults.endPos

	if ( !IsValid( traceResults.hitEnt ) )
	{
		origin = landData.points.top()
		failed = true
	}

	if ( DistanceSqr( player.GetOrigin(), origin ) < MIN_DIST_SQR )
	{
		failed = true
		hide = true
	}

	const bool IsCarePackage = true
	if ( !failed && !VerifyAirdropPoint( origin, placementAngles.y, IsCarePackage, player ) )
	{
		failed = true
	}

	placementInfo.origin = origin
	placementInfo.angles = placementAngles
	placementInfo.failed = failed
	placementInfo.hide = hide
	return placementInfo
}

float function PlacementEasing( float frac )
{
	//
	//

	Assert( frac >= 0.0 && frac <= 1.0 )

	const float CUT_POINT = 1
	const float DIVISIONS = 2
	const float MID_VALUE = 0.35

	frac *= DIVISIONS
	if ( frac < CUT_POINT )
		return Tween_QuadEaseOut( frac / CUT_POINT ) * MID_VALUE
	return MID_VALUE + Tween_QuadEaseIn( ( frac - CUT_POINT ) / ( DIVISIONS - CUT_POINT ) ) * ( 1 - MID_VALUE )
}

int function GetSkinForCarePackageModel( entity player )
{
	LoadoutEntry characterSlot = Loadout_CharacterClass()

	#if(DEV)
		if ( !LoadoutSlot_IsReady( ToEHI( player ), characterSlot ) )
			printt( "Need to get character for player, but the data is not available" )
	#endif

	ItemFlavor character = LoadoutSlot_WaitForItemFlavor( ToEHI( player ), characterSlot )
	string characterRef = ItemFlavor_GetHumanReadableRef( character )

	#if(DEV)
		printt( "got character", characterRef )
	#endif

	switch( characterRef )
	{
		#if(false)


#endif

		case "character_lifeline":
		default:
			return 1
	}
	//

	unreachable
}

#if(CLIENT)
void function OnBeginPlacingCarePackage( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	thread DeployableCarePackagePlacement( player, CARE_PACKAGE_AIRDROP_MODEL )
}

void function OnEndPlacingCarePackage( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	player.Signal( "DeployableCarePackagePlacement" )
}

void function DeployableCarePackagePlacement( entity player, asset carePackageModel )
{
	player.EndSignal( "DeployableCarePackagePlacement" )

	entity carePackage = CreateCarePackageProxy( carePackageModel )
	carePackage.EnableRenderAlways()
	carePackage.Show()
	DeployableModelHighlight( carePackage )

	carePackage.SetSkin( GetSkinForCarePackageModel( player ) )

	OnThreadEnd(
		function() : ( carePackage )
		{
			if ( IsValid( carePackage ) )
				thread DestroyCarePackageProxy( carePackage )

			HidePlayerHint( "#WPN_CARE_PACKAGE_PLAYER_HINT" )
		}
	)

	AddPlayerHint( 3.0, 0.25, $"", "#WPN_CARE_PACKAGE_PLAYER_HINT" )

	while ( true )
	{
		CarePackagePlacementInfo placementInfo = GetCarePackagePlacementInfo( player )

		carePackage.SetOrigin( placementInfo.origin )
		carePackage.SetAngles( placementInfo.angles )

		if ( !placementInfo.failed )
			DeployableModelHighlight( carePackage )
		else
			DeployableModelInvalidHighlight( carePackage )

		if ( placementInfo.hide )
			carePackage.Hide()
		else
			carePackage.Show()

		WaitFrame()
	}
}

entity function CreateCarePackageProxy( asset modelName ) //
{
	entity carePackage = CreateClientSidePropDynamic( <0,0,0>, <0,0,0>, modelName )
	carePackage.kv.renderamt = 255
	carePackage.kv.rendermode = 3
	carePackage.kv.rendercolor = "255 255 255 255"

	carePackage.Anim_Play( "ref" )
	carePackage.Hide()

	return carePackage
}

void function DestroyCarePackageProxy( entity ent )
{
	Assert( IsNewThread(), "Must be threaded off" )
	ent.EndSignal( "OnDestroy" )

	if ( file.carePackageDeployed )
		wait 0.225

	ent.Destroy()
}

void function SetCarePackageDeployed( bool state )
{
	file.carePackageDeployed = state
}
#endif