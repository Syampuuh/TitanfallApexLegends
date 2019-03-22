global function BirdClusterSharedInit

#if(false)





//
#endif //
#if(CLIENT)
	global function BirdClusterPointSpawned
#endif //

const vector TRACKING_ICON_OFFSET = <0,0,16>
const vector TRACKING_ICON_OFFSET_SHORT = <0,0,8>

const CLUSTER_SPAWN_MIN_RADIUS = 32
const CLUSTER_SPAWN_MAX_RADIUS = 192
const CLUSTER_TRIGGER_RADIUS = 512
const CLUSTER_TRIGGER_HEIGHT = 128
const CLUSTER_TRIGGER_DEPTH = 64
const CLUSTER_MAX_DIST = 2500
const CLUSTER_MID_DIST = 1500
const CLUSTER_MIN_DIST = 512
const CLUSTER_MAX_DIST_SQR = CLUSTER_MAX_DIST * CLUSTER_MAX_DIST
const CLUSTER_MID_DIST_SQR = CLUSTER_MID_DIST * CLUSTER_MID_DIST
const CLUSTER_MIN_DIST_SQR = CLUSTER_MIN_DIST * CLUSTER_MIN_DIST
const CLUSTER_NEAR_DIST_SQR = 768 * 768
const CLUSTER_LIFETIME = 60
const CLUSTER_ITERATION_INTERVAL = 0.25
const CLUSTER_SIZE_THRESHOLD = 5
const CLUSTER_MAX_TAKEOFF_DELAY = 0.3
const bool CLUSTER_USE_FAKE = false
const bool CLUSTER_DEBUG_CLUSTER = false

global const asset CLUSTER_BIRD_MODEL = $"mdl/creatures/bird/bird.rmdl"
global const CLUSTER_BIRD_DISSOLVE_VFX = $"dissolve_bird"

#if(false)










#endif //

#if(CLIENT)
struct BirdClusterInfo
{
	array<entity> birdArray
	entity birdClusterMainEnt
	entity ownerPlayer
}
#endif //

struct
{
	#if(false)



//
#endif //
	#if(CLIENT)
		array< BirdClusterInfo > birdClusterInfoArray
	#endif //
} file

void function BirdClusterSharedInit()
{
	bool birdClusterEnabled = GetCurrentPlaylistVarBool( "bloodhound_bird_cluster", true )
	if ( !birdClusterEnabled )
		return

	#if(false)




#endif
	#if(CLIENT)
		AddTargetNameCreateCallback( "bird_cluster_point", BirdClusterPointSpawned )
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

#if(false)

























//





//
































































#endif //

#if(CLIENT)
void function BirdClusterPointSpawned( entity info_target )
{
	__BirdClusterPointSpawned( info_target )
}

void function __BirdClusterPointSpawned( entity info_target )
{
	entity owner = info_target.GetOwner()
	if ( !IsValid( owner ) )
		return

	const array<string> BIRD_ANIM_ARRAY = ["Bird_eating_idle","Bird_casual_idle","Bird_cleaning_idle" ]

	entity mainEnt
	entity ownerPlayer

	if( owner.IsPlayer() )
	{
		mainEnt = info_target
		ownerPlayer = owner
	}
	else
	{
		mainEnt = owner
		ownerPlayer = mainEnt.GetOwner()
		if ( !IsValid( ownerPlayer ) )
			return
	}

	if ( GetLocalViewPlayer() != ownerPlayer )
		return

	BirdClusterInfo clusterInfo
	clusterInfo = CreateOrReturnExistingBirdClusterInfo( mainEnt, ownerPlayer )
	//

	entity bird = CreateClientSidePropDynamic( info_target.GetOrigin(), info_target.GetAngles(), CLUSTER_BIRD_MODEL )
	bird.SetFadeDistance( CLUSTER_MAX_DIST )

	int animIndex = clusterInfo.birdArray.len() % BIRD_ANIM_ARRAY.len()

	float duration = bird.GetSequenceDuration( BIRD_ANIM_ARRAY[ animIndex ] )
	float initialTime = RandomFloatRange( 0, duration )
	thread PlayAnim( bird, BIRD_ANIM_ARRAY[ animIndex ], null, null, 0.0, initialTime )

	//
	clusterInfo.birdArray.append( bird )
}

array<entity> function GetAllBrids()
{
	array<entity> birds
	foreach( cluster in file.birdClusterInfoArray )
		birds.extend( cluster.birdArray )

	return birds
}

BirdClusterInfo function CreateOrReturnExistingBirdClusterInfo( entity mainEnt, entity ownerPlayer )
{
	foreach( clusterInfo in file.birdClusterInfoArray )
	{
		if ( clusterInfo.birdClusterMainEnt == mainEnt )
			return clusterInfo
	}

	BirdClusterInfo newClusterInfo
	newClusterInfo.birdClusterMainEnt = mainEnt
	newClusterInfo.ownerPlayer = ownerPlayer

	file.birdClusterInfoArray.append( newClusterInfo )

	AddEntityDestroyedCallback( mainEnt, BirdClusterInfoOnDestroy )

	//

	return newClusterInfo
}

void function BirdClusterInfoOnDestroy( entity info_target )
{
	__BirdClusterInfoOnDestroy( info_target )
}

void function __BirdClusterInfoOnDestroy( entity info_target )
{
	BirdClusterInfo clusterInfo
	foreach( _clusterInfo in file.birdClusterInfoArray )
	{
		if ( _clusterInfo.birdClusterMainEnt == info_target )
			clusterInfo = _clusterInfo
	}

	if ( !IsValid( clusterInfo.ownerPlayer ) )
	{
		DeleteBirdCluster( clusterInfo )
		return	//
	}

	Assert( clusterInfo.birdClusterMainEnt == info_target )
	Assert( clusterInfo.ownerPlayer == GetLocalViewPlayer() )

	float distSqr = DistanceSqr( info_target.GetOrigin(), clusterInfo.ownerPlayer.GetOrigin() )

	//

	if ( distSqr > CLUSTER_MID_DIST_SQR )
	{
		//
		DeleteBirdCluster( clusterInfo )
		return
	}

	foreach( index, bird in clusterInfo.birdArray )
		thread BirdFlightThread( bird, index )

	//
	file.birdClusterInfoArray.fastremovebyvalue( clusterInfo )
}

void function BirdFlightThread( entity bird, int order )
{
	bird.EndSignal( "OnDestroy" )

	float delay = RandomFloatRange( 0, CLUSTER_MAX_TAKEOFF_DELAY * order )
	//
	wait delay

	float duration = bird.GetSequenceDuration( "Bird_react_fly_small" )
	Assert( duration > 2, "fly away anim must be more then 2 seconds long" )

	//

	entity refEnt = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", bird.GetOrigin(), bird.GetAngles() )
	bird.SetParent( refEnt )

	OnThreadEnd(
		function() : ( bird, refEnt )
		{
			if ( IsValid( refEnt ) )
				refEnt.Destroy()

			if ( IsValid( bird ) )
				bird.Destroy()
		}
	)


	thread PlayAnim( bird, "Bird_react_fly_small", refEnt )
	wait duration - 2.0

	int fxId = GetParticleSystemIndex( CLUSTER_BIRD_DISSOLVE_VFX )
	int fxHandle = StartParticleEffectOnEntity( bird, fxId, FX_PATTACH_ABSORIGIN_FOLLOW, 0 )
	waitthread fadeModelAlphaOutOverTime( bird, 1 )

	wait 1

	//
}


void function fadeModelAlphaOutOverTime( entity model, float duration )
{
	EndSignal( model, "OnDestroy" )

	float startTime = Time()
	float endTime = startTime + duration
	int startAlpha = 255
	int endAlpha = 0

	model.kv.rendermode = 4 //

	while ( Time() <= endTime )
	{
		float alphaResult = GraphCapped( Time(), startTime, endTime, startAlpha, endAlpha )
		model.kv.renderamt = alphaResult
		printt ("Alpha = " + alphaResult)
		WaitFrame()
	}
}


void function DeleteBirdCluster( BirdClusterInfo clusterInfo )
{
	foreach( bird in clusterInfo.birdArray )
	{
		if ( IsValid( bird ) )
			bird.Destroy()
	}

	file.birdClusterInfoArray.fastremovebyvalue( clusterInfo )
}
#endif //


