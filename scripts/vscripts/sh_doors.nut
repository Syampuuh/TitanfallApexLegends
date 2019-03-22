//
//
//
//
//
//
//
//
//
#if(false)





#endif

global function ShDoors_Init
global function IsDoor
global function GetAllPropDoors

#if(false)

#endif

global function CodeCallback_OnDoorInteraction

enum eDoorType
{
	MODEL,
	MOVER,
	PLAIN,
	SLIDING,
	BLOCKABLE,
	CODE,
}

struct
{
	#if(false)

#endif

	#if(false)

#endif //

	#if(CLIENT)
		array<entity> allPropDoors
	#endif //

} file

void function ShDoors_Init()
{
	#if(false)





//

















#endif
	#if(CLIENT)
		AddCreateCallback( "prop_dynamic", OnSomePropCreated )
		AddCreateCallback( "script_mover", OnSomePropCreated )
		AddCreateCallback( "door_mover", OnSomePropCreated )
		AddCreateCallback( "prop_door", OnCodeDoorCreated_Client )
		AddDestroyCallback( "prop_door", OnCodeDoorDestroyed_Client )
	#endif

	SurvivalDoorSliding_Init()
	BlockableDoor_Init()
}

bool function IsDoor( entity ent )
{
	return IsCodeDoor( ent )
}

array<entity> function GetAllPropDoors()
{
	#if(false)


#endif //

	#if(CLIENT)
		return file.allPropDoors
	#endif //
}

#if(false)









//







#endif

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


bool function DoorsAreEnabled()
{
	return GetCurrentPlaylistVarBool( "survival_enable_doors", true ) //
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














#endif

#if(false)































#endif

#if(CLIENT)
void function OnSomePropCreated( entity prop )
{
	if ( prop.GetScriptName() == "survival_door_sliding" )
		SetCallback_CanUseEntityCallback( prop, Survival_DoorSliding_CanUseFunction )

	if ( prop.GetScriptName() == "survival_door_blockable" )
		OnBlockableDoorSpawned( prop )
}

void function OnCodeDoorCreated_Client( entity door )
{
	door.SetDoDestroyCallback( true )
	file.allPropDoors.append( door )
}

void function OnCodeDoorDestroyed_Client( entity door )
{
	file.allPropDoors.fastremovebyvalue( door )
}
#endif

#if(false)














#endif //

#if(false)


//









#endif

#if(false)






#endif

#if(false)






#endif

#if(false)


//
//













#endif

#if(false)

































//























//





//


































































#endif

bool function IsCodeDoor( entity door )
{
	if ( door.GetNetworkedClassName() == "prop_door" )
		return true
	return false
}


#if(false)


















//



















//








//




























//



//







//


























































//












































#endif



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

const float BLOCKABLE_DOOR_EXTRA_USE_DEBOUNCE = 0.21

const float BLOCKABLE_DOOR_CONSIDER_CLOSED_ANGLE = 4.0
const float BLOCKABLE_DOOR_PLAYER_HULL_DIAMETER = 32.0

const float BLOCKABLE_DOOR_TEMP_HARDCODED_DOOR_THICKNESS = 8.0
const float BLOCKABLE_DOOR_TEMP_HARDCODED_DOOR_LENGTH = 60.0
const float BLOCKABLE_DOOR_TEMP_HARDCODED_DOOR_HEIGHT = 108.0

const float BLOCKABLE_DOOR_TRACE_ANGLE_DELTA = 11.0
const float BLOCKABLE_DOOR_TRACE_EXTRA_THICKNESS = 3.8
const float BLOCKABLE_DOOR_TRACE_SWING_EDGE_INSET = 0.2
const float BLOCKABLE_DOOR_TRACE_HINGE_EDGE_INSET = 4.0//
const float BLOCKABLE_DOOR_TRACE_MAX_CAPSULE_GAP = 7.0
const float BLOCKABLE_DOOR_TRACE_HEIGHT_INSET = 9.0 //

const asset BLOCKABLE_DOOR_MODEL = $"mdl/door/door_104x64x8_elevatorstyle01_right_animated.rmdl"
const asset BLOCKABLE_DOOR_DAMAGED_MODEL = $"mdl/door/canyonlands_door_single_02_damaged.rmdl"
const asset BLOCKABLE_DOOR_DAMAGED_FX = $"P_door_damaged"
const asset BLOCKABLE_DOOR_DESTRUCTION_FX = $"P_door_breach"

const bool BLOCKABLE_DOOR_DEBUG = false


enum eDoorFlags
{
	GOAL_IS_OPEN = (1 << 0),
	GOAL_IS_CLOCKWISE = (1 << 1),
	IS_BUSY = (1 << 2),
}

#if(CLIENT)
void function BlockableDoor_Init()
{
	PrecacheModel( BLOCKABLE_DOOR_MODEL )
	PrecacheModel( BLOCKABLE_DOOR_DAMAGED_MODEL )
	PrecacheParticleSystem( BLOCKABLE_DOOR_DAMAGED_FX )
	PrecacheParticleSystem( BLOCKABLE_DOOR_DESTRUCTION_FX )
}
#endif

#if(CLIENT)
void function OnBlockableDoorSpawned( entity door )
{
	#if(false)


#elseif(CLIENT)
		SetCallback_CanUseEntityCallback( door, BlockableDoorCanUseCheck )
		AddEntityCallback_GetUseEntOverrideText( door, BlockableDoorUseTextOverride )
	#endif
}
#endif

enum eBlockableDoorNotch
{
	OPEN_ANTICLOCKWISE = -1,
	CLOSED = 0,
	OPEN_CLOCKWISE = 1
}

const table<int, vector> BLOCKABLE_DOOR_NOTCH_ROTATIONS = {
	[eBlockableDoorNotch.OPEN_ANTICLOCKWISE] = <0, 89.2, 0>,
	[eBlockableDoorNotch.CLOSED] = <0, 0, 0>,
	[eBlockableDoorNotch.OPEN_CLOCKWISE] = <0, -89.2, 0>,
}


#if(false)















#endif


#if(false)


//



//

//
//
//
//








#endif


#if(false)

















#endif

#if(false)











#endif

#if(false)




#endif


#if(false)

















//






























//
//
//



































//



































































#endif


#if(false)



//
//









#endif


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


#if(CLIENT)
bool function BlockableDoorCanUseCheck( entity player, entity door )
{
	//

	float doorUseRangeMax = 130.0
	float doorUseRangeMin = 30.0

	vector doorUsePos   = door.GetWorldSpaceCenter()
	vector playerToDoor = doorUsePos - player.EyePosition()

	float lookDot      = DotProduct( player.GetViewForward(), Normalize( playerToDoor ) )
	float doorUseRange = GraphCapped( lookDot, -1.0, 1.0, doorUseRangeMin, doorUseRangeMax )
	doorUseRange += GraphCapped( fabs( DotProduct( AnglesToRight( door.GetAngles() ), -playerToDoor ) ), 0.0, 1.0, 0.0, BLOCKABLE_DOOR_TEMP_HARDCODED_DOOR_LENGTH / 2.0 )

	#if(false)
//

#endif

	if ( LengthSqr( playerToDoor ) > doorUseRange * doorUseRange )
		return false

	vector moveRaw = <player.GetInputAxisForward(), -player.GetInputAxisRight(), 0>
	if ( LengthSqr( moveRaw ) > 0.2 )
	{
		vector moveIntention = RotateVector( Normalize( moveRaw ), <0, player.EyeAngles().y, 0> )
		for ( int sideIndex = 0; sideIndex < 2; sideIndex++ )
		{
			vector sidePoint                  = player.EyePosition() + CrossProduct( moveIntention, AnglesToUp( player.GetAngles() ) ) * player.GetBoundingMaxs().y * (sideIndex == 0 ? -1.0 : 1.0)
			vector ornull moveIntersectOrNull = GetIntersectionOfLineAndPlane( sidePoint, sidePoint + 1000.0 * moveIntention, door.GetOrigin(), AnglesToForward( door.GetAngles() ) )
			if ( moveIntersectOrNull != null )
			{
				#if(false)


#endif

				if ( DotProduct( moveIntention, Normalize( (expect vector(moveIntersectOrNull)) - sidePoint ) ) > 0.0 )
				{
					vector localMoveIntersect       = WorldPosToLocalPos( expect vector(moveIntersectOrNull), door )
					bool doesMoveIntentionIntersect = PointIsWithinBounds( localMoveIntersect, door.GetBoundingMins(), door.GetBoundingMaxs() )
					if ( doesMoveIntentionIntersect )
						return true
				}
			}
		}
	}

	vector ornull lookIntersectOrNull = GetIntersectionOfLineAndPlane( player.EyePosition(), player.EyePosition() + 1000.0 * player.GetViewVector(), door.GetOrigin(), AnglesToForward( door.GetAngles() ) )
	if ( lookDot > 0.0 && lookIntersectOrNull != null )
	{
		//
		vector localLookIntersect = WorldPosToLocalPos( expect vector(lookIntersectOrNull), door )
		bool doesLookIntersect    = PointIsWithinBounds( localLookIntersect, door.GetBoundingMins(), door.GetBoundingMaxs() )
		if ( doesLookIntersect )
			return true
	}

	return false
}
#endif


#if(CLIENT)
string function BlockableDoorUseTextOverride( entity door )
{
	//
	//

	if ( ShDoors_IsDoorGoalToOpen( door ) )
		return "#SURVIVAL_CLOSE_DOOR"

	return "#SURVIVAL_OPEN_DOOR"
}
#endif


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







































#endif


bool function CircleIntersectsArc(
		vector circleCenterIn, float circleRadius,
		vector arcCornerIn, float arcRadius, float arcStartAng, float arcEndAng )
{
	#if(false)

#endif
	bool intersect = true

	vector circleCenter = FlattenVector( circleCenterIn )
	vector arcCorner    = FlattenVector( arcCornerIn )

	//
	if ( AngleDiff( arcStartAng, arcEndAng ) > AngleDiff( arcEndAng, arcStartAng ) )
	{
		float temp = arcStartAng
		arcStartAng = arcEndAng
		arcEndAng = temp
	}

	vector startAngPlaneAlongDir        = AnglesToForward( <0, arcStartAng, 0> )
	vector startAngPlaneInnerDir        = -AnglesToRight( <0, arcStartAng, 0> )
	vector startAngPlaneClosestPoint    = GetClosestPointOnLine( arcCorner, arcCorner + startAngPlaneAlongDir, circleCenter )
	vector startAngPlaneCircleCenterDir = Normalize( startAngPlaneClosestPoint - circleCenter )
	float startAngPlaceCircleCenterDist = Distance2D( startAngPlaneClosestPoint, circleCenter )
	if ( DotProduct( startAngPlaneInnerDir, startAngPlaneCircleCenterDir ) < 0.0 && startAngPlaceCircleCenterDist > circleRadius )
	{
		#if(false)

#endif
		intersect = false
	}
	else
	{
		#if(false)

#endif
	}

	vector endAngPlaneAlongDir        = AnglesToForward( <0, arcEndAng, 0> )
	vector endAngPlaneInnerDir        = AnglesToRight( <0, arcEndAng, 0> )
	vector endAngPlaneClosestPoint    = GetClosestPointOnLine( arcCorner, arcCorner + endAngPlaneAlongDir, circleCenter )
	vector endAngPlaneCircleCenterDir = Normalize( endAngPlaneClosestPoint - circleCenter )
	float endAngPlaceCircleCenterDist = Distance2D( endAngPlaneClosestPoint, circleCenter )
	if ( DotProduct( endAngPlaneInnerDir, endAngPlaneCircleCenterDir ) < 0.0 && endAngPlaceCircleCenterDist > circleRadius )
	{
		#if(false)

#endif
		intersect = false
	}
	else
	{
		#if(false)

#endif
	}

	float arcCornerCircleCenterDist = Distance2D( arcCorner, circleCenter )
	if ( arcCornerCircleCenterDist > arcRadius + circleRadius )
	{
		#if(false)

#endif
		intersect = false
	}
	else
	{
		#if(false)

#endif
	}

	return intersect
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



#endif


#if(false)

















//
//


#endif


bool function ShDoors_IsDoorGoalToOpen( entity door )
{
	if ( door.GetNetworkedClassName() != "door_mover" )
		return false //

	return bool(door.GetDoorFlags() & eDoorFlags.GOAL_IS_OPEN)

}


bool function ShDoors_IsDoorBusy( entity door )
{
	if ( door.GetNetworkedClassName() != "door_mover" )
		return false //

	return bool(door.GetDoorFlags() & eDoorFlags.IS_BUSY)
}




/*






*/

const float SURVIVAL_SLIDING_DOOR_USE_RANGE = 80.0
const float SURVIVAL_SLIDING_DOOR_FACING_AWAY_USE_RANGE = 30.0

const float SURVIVAL_SLIDING_DOOR_USE_RANGE_SQUARED = SURVIVAL_SLIDING_DOOR_USE_RANGE * SURVIVAL_SLIDING_DOOR_USE_RANGE
const float SURVIVAL_SLIDING_DOOR_FACING_AWAY_USE_RANGE_SQUARED = SURVIVAL_SLIDING_DOOR_FACING_AWAY_USE_RANGE * SURVIVAL_SLIDING_DOOR_FACING_AWAY_USE_RANGE

const float SURVIVAL_SLIDING_DOOR_USE_HEIGHT = 64.0
const float SURVIVAL_SLIDING_DOOR_USE_NEGATIVE_HEIGHT = 32.0
const vector SURVIVAL_SLIDING_DOOR_ORIGIN_OFFSET = <0.0, 30.0, 0.0>

const bool SURVIVAL_SLIDING_DOOR_DEBUG_DRAW = false

const float SURVIVAL_SLIDING_DOOR_WAIT_TO_OPEN_FOR_COLLSIION_TIME = 0.3
const float SURVIVAL_SLIDING_DOOR_WAIT_TO_CLOSE_FOR_COLLSIION_TIME = 0.4
const float SURVIVAL_SLIDING_DOOR_CLOSE_WAIT_TIME = 0.5
const float SURVIVAL_SLIDING_DOOR_TICK_TIME = 1.0
const float SURVIVAL_SLIDING_DOOR_TOTAL_TICKS = 3
const bool SURVIVAL_SLIDING_DOOR_OPENS_WHEN_TOUCHED = true

const string SURVIVAL_SLIDING_DOOR_TICK_SOUND = "hud_match_start_timer_tick_1p"
const string SURVIVAL_SLIDING_DOOR_INTERACT_SOUND = "og_lastimosa_wrist_computer_confirm_short_3p"
const string SURVIVAL_SLIDING_DOOR_CANCEL_SOUND = "ui_networks_invitation_canceled"
const float SURVIVAL_SLIDING_DOOR_MINIMUM_DAMAGE = 11.0
const float SURVIVAL_SLIDING_DOOR_HEALTH = SURVIVAL_SLIDING_DOOR_MINIMUM_DAMAGE
const asset SURVIVAL_SLIDING_DOOR_DESTRUCTION_FX = $"P_door_breach"

struct SlidingDoorData
{
	int  numBlockers
	bool isClosing
	bool isOpen
	bool shouldPlayInteractSound = true
}
array<SlidingDoorData> PROTO_slidingDoorData

#if(CLIENT)
void function SurvivalDoorSliding_Init()
{
	PrecacheParticleSystem( SURVIVAL_SLIDING_DOOR_DESTRUCTION_FX )
}
#endif


#if(false)





#endif


#if(false)





















































//














































































#endif

#if(false)










#endif

#if(false)







#endif

#if(false)







#endif

#if(false)

























#endif

#if(false)














#endif

#if(false)

































//



#endif

#if(CLIENT)
bool function Survival_DoorSliding_CanUseFunction( entity playerUser, entity doorModel )
{
	float doorUseRangeSquared = SURVIVAL_SLIDING_DOOR_USE_RANGE_SQUARED
	float doorUseRange        = SURVIVAL_SLIDING_DOOR_USE_RANGE

	vector rotatedOffset = RotateVector( SURVIVAL_SLIDING_DOOR_ORIGIN_OFFSET, doorModel.GetAngles() )
	vector playerPos     = playerUser.GetOrigin()
	vector doorModelPos  = doorModel.GetOrigin() + rotatedOffset
	vector doorToPlayer  = playerPos - doorModelPos

	if ( doorToPlayer.z < -SURVIVAL_SLIDING_DOOR_USE_NEGATIVE_HEIGHT || doorToPlayer.z > SURVIVAL_SLIDING_DOOR_USE_HEIGHT )
		return false

	//
	doorToPlayer.z = 0.0

	//
	vector playerFacing = playerUser.GetViewForward()
	playerFacing.z = 0.0

	if ( DotProduct( playerFacing, doorToPlayer ) > 0 )
	{
		doorUseRange = SURVIVAL_SLIDING_DOOR_FACING_AWAY_USE_RANGE
		doorUseRangeSquared = SURVIVAL_SLIDING_DOOR_FACING_AWAY_USE_RANGE_SQUARED
	}

	if ( SURVIVAL_SLIDING_DOOR_DEBUG_DRAW )
	{
		DebugDrawLine( playerPos, doorModelPos, 200, 200, 50, true, 1.0 )
		DebugDrawTrigger( doorModelPos, doorUseRange, 200, 200, 50, 1.0, true )
	}

	float diffLengthSquared = LengthSqr( doorToPlayer )
	return diffLengthSquared <= doorUseRangeSquared
}
#endif


void function CodeCallback_OnDoorInteraction( entity door, entity user, entity oppositeDoor, bool opening )
{
	#if(false)





#endif
}
