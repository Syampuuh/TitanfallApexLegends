untyped

globalize_all_functions

global const TRIG_FLAG_NONE = 0
global const TRIG_FLAG_PLAYERONLY = 0x0001
                                			        
                                      	        
                             				        
global const TRIG_FLAG_EXCLUSIVE = 0x0010                                                           
global const TRIG_FLAG_DEVDRAW = 0x0020
global const TRIG_FLAG_START_DISABLED = 0x0040
global const TRIG_FLAG_NO_PHASE_SHIFT = 0x0080
global const float MAP_EXTENTS = 128 * 128
  
                	        
                	          

global const TRIGGER_INTERNAL_SIGNAL = "OnTrigger"

global const CALCULATE_SEQUENCE_BLEND_TIME = -1.0

global const string SILENT_PLAYER_VOICE = "_silent"

global struct ArrayDistanceEntry
{
	float  distanceSqr
	entity ent
	vector origin
	vector angles
}

global struct GravityLandData
{
	array<vector> points
	TraceResults& traceResults
	float         elapsedTime
}

global struct LineSegment
{
	vector start
	vector end
}

global struct FirstPersonSequenceStruct
{
	string                     firstPersonAnim = ""
	string                     thirdPersonAnim = ""
	string                     firstPersonAnimIdle = ""
	string                     thirdPersonAnimIdle = ""
	string                     relativeAnim = ""
	string                     attachment = ""
	bool                       teleport = false
	bool                       noParent = false
	float                      blendTime = CALCULATE_SEQUENCE_BLEND_TIME
	float                      thirdPersonBlendInTime = -1.0
	float                      firstPersonBlendInTime = -1.0
	float                      firstPersonBlendOutTime = -1.0
	float                      thirdPersonBlendOutTime = -1.0
	bool                       noViewLerp = false
	bool                       hideProxy = false
	void functionref( entity ) viewConeFunction = null
	vector ornull              origin = null
	vector ornull              angles = null
	bool                       enablePlanting = false
	bool                       enableRelativeToGround = false
	bool                       enableCollision = false
	float                      setStartTime = -1                                                                                         
	float                      setInitialTime = 0.0                                                                                       
	bool                       useAnimatedRefAttachment = false                                                                     
	bool                       renderWithViewModels = false
	bool                       gravity = false                                     
	bool                       playerPushable = false
	array<string>              thirdPersonCameraAttachments = []
	bool                       thirdPersonCameraVisibilityChecks = false
	entity                     thirdPersonCameraEntity = null
	bool                       snapPlayerFeetToEyes = true
	bool                       prediction = false
	bool                       setVelocityOnEnd = false
	bool                       snapForLocalPlayer = false
}

global struct FrontRightDotProductsStruct
{
	float forwardDot = 0.0
	float rightDot = 0.0
}

global struct RaySphereIntersectStruct
{
	bool  result
	float enterFrac
	float leaveFrac
}

global struct FriendlyEnemyFXStruct
{
	entity friendlyColoredFX
	entity enemyColoredFX
	int    team
}

global enum eGradeFlags
{
	IS_OPEN = (1 << 0),
	IS_BUSY = (1 << 1),
	IS_OPEN_SECRET = (1 << 2),
	IS_LOCKED = (1 << 3),
}

global struct RingBuffer
{
	array<var> 	arr
	int        	readIdx
	int 		writeIdx
	int 		sizeMax
	int			sizeFilled
}

global struct RingBufferEntity
{
	array<entity>	arr
	int				readIdx
	int				writeIdx
	int				sizeMax
	int				sizeFilled
}

global struct UpdraftTriggerSettings
{
	float minShakeActivationHeight = 500.0                                                                       
	float maxShakeActivationHeight = 400.0                                                                                     
	float liftSpeed                = 300.0                   	                       
	float liftAcceleration         = 100.0                 		                                                     
	float liftExitDuration         = 2.5                   		                                                                                     
}

const array<string> ALLOWED_SCRIPT_PARENT_ENTS = [
	"hatch_bunker_entrance_model_z16",
	"hatch_bunker_entrance_model_z6",
	"hatch_bunker_entrance_model_z5",
	"hatch_bunker_entrance_model_z12",
	"hatch_bunker_entrance_model_z12_treasure",
]

struct RefEntAreaData
{
	vector areaMin
	vector areaMax
}

struct
{
	array<entity>                 invalidEntsForPlacingPermanentsOnto
	table<entity, RefEntAreaData> invalidAreasRelativeToEntForPlacingPermanentsOnto

	int functionref()            getNumTeamsRemainingCallback
	float functionref()			 getDeathCamTimeOverride
	float functionref()			 getDeathCamSpectateTimeOverride
	array<string>				 nonInstalledModsTracked

	UpdraftTriggerSettings&      updraftSettings = { ... }
} file

void function Utility_Shared_Init()
{
	PrecacheModel( $"mdl/weapons/arms/human_pov_cockpit.rmdl" )                                         

	RegisterSignal( TRIGGER_INTERNAL_SIGNAL )
	RegisterSignal( "devForcedWin" )
	RegisterSignal( "OnContinousUseStopped" )
	RegisterSignal( "OnChargeEnd" )
	RegisterSignal( "FadeModelIntensityOverTime" )
	RegisterSignal( "FadeModelColorOverTime" )
	RegisterSignal( "FadeModelAlphaOverTime" )

	#document( "IsAlive", "Returns true if the given ent is not null, and is alive." )
	#document( "ArrayWithin", "Remove ents from array that are out of range" )

	file.nonInstalledModsTracked = [ DRAGON_LMG_ENERGIZED_MOD ]
}


void function InitWeaponScripts()
{
	SmartAmmo_Init()

	                 
	ArcCannon_Init()
	Grenade_FileInit()
	Vortex_Init()
	Weapon_Cubemap_Init()

	  	          
	  		                                          
	  		                                           
	  	      

	MpAbilityShifter_Init()
	MpWeaponDefender_Init()
	MpWeaponSentinel_Init()
                   
                    
       
	                        
                      
                       
       
	MpWeaponBow_Init()
                         
                          
       
	MpWeaponDmr_Init()
                             
                             
       
                         
                                
       
	MpWeaponSniper_Init()
	MpWeaponLSTAR_Init()
                          
                          
       
	MpWeaponZipline_Init()
	MpWeaponAlternatorSMG_Init()
	MpWeaponShotgun_Init()

	MpWeaponThermiteGrenade_Init()
	MeleeWraithKunai_Init()
	MpWeaponWraithKunaiPrimary_Init()
	MeleeBloodhoundAxe_Init()
	MpWeaponBloodhoundAxePrimary_Init()
	MeleeCausticHammer_Init()
	MpWeaponCausticHammerPrimary_Init()
	MeleeLifelineBaton_Init()
	MpWeaponLifelineBatonPrimary_Init()
	MeleePathfinderGloves_Init()
	MpWeaponPathfinderGlovesPrimary_Init()
	MeleeOctaneKnife_Init()
	MpWeaponOctaneKnifePrimary_Init()
	MeleeMirageStatue_Init()
	MpWeaponMirageStatuePrimary_Init()
	MeleeWattsonGadget_Init()
	MpWeaponWattsonGadgetPrimary_Init()
	MeleeCryptoHeirloom_Init()
	MpWeaponCryptoHeirloomPrimary_Init()
                     
		MeleeValkyrieSpear_Init()
		MpWeaponValkyrieSpearPrimary_Init()
       
                     
                          
                                    
       
                     
                          
                                    
       
                     
                              
                                         
       
	MeleeGibraltarClub_Init()
	MpWeaponGibraltarClubPrimary_Init()
	MeleeRampartWrench_Init()
	MpWeaponRampartWrenchPrimary_Init()
	MeleeRevenantScythe_Init()
	MpWeaponRevenantScythePrimary_Init()
                  
		MeleeShadowsquadHands_Init()
		MpWeaponShadowsquadHandsPrimary_Init()
       
                
		MeleeBoxingRing_Init()
		MpWeaponMeleeBoxingRing_Init()
       

	MpAbilityGibraltarShield_Init()
	MpWeaponBubbleBunker_Init()

                  
                            
                                    
                           
                             
                           
                          
       

	MpWeaponEmoteProjector_Init()
                       
                           
                                                              
       
	MpWeaponGrenadeDefensiveBombardment_Init()

                    
                                        
                               
       

	MpAbilityHuntModeWeapon_Init()
	MpAbilityAreaSonarScan_Init()
	MpWeaponGrenadeGas_Init()
	MpWeaponDirtyBomb_Init()
	MpWeaponDeployableMedic_Init()
	MpWeaponIncapShield_Init()
	MpWeaponGrenadeBangalore_Init()
	MpWeaponGrenadeCreepingBombardment_Init()
	MpWeaponGrenadeCreepingBombardmentWeapon_Init()
	MpAbilityMirageUltimate_Init()
	MpAbilityCryptoDrone_Init()
	MpAbilityCryptoDroneEMP_Init()
	MpWeaponPhaseTunnel_Init()
	MpWeaponTeslaTrap_Init()
	MpWeaponTrophy_Init()
	MpAbilitySilence_Init()
	MpAbilityRevenantDeathTotem_Init()
	MpAbilitySharedSilence_Init()
	MpWeaponArcBolt_Init()
	MpWeaponPhaseBreach_Init()
	MpWeaponAshDataknife_Init()
                
                            
                              
                                      
                                  
       
	MpWeaponRiotDrill_Init()
	MpAbilityWreckingBall_Init()
	MpMaggieCommon_Init()
                          
                                 
       
	MpWeaponCoverWall_Init()
	MpWeaponMountedTurretPlaceable_Init()
	MpWeaponMountedTurretWeapon_Init()
	MpWeaponMobileHMG_Init()
                
                           
                               
       
                
                        
                              
       
              
                             
                               
       
                 
                                   
                               
                                     
       
                 
                               
                            
                            
       
	MpAbilityValkJets_Init()
	MpAbilityValkSkyward_Init()
	MpAbilityValkClusterMissile_Init()

              
                               
                             
       
                
                                 
                                    
                              
       
                 
                                
       

               
                             
                             
                            
       

                        
                            
                            
       

	MpWeaponBlackHole_Init()
	MpSpaceElevatorAbility_Init()


	MpWeaponClusterBombLauncher_Init()
	MpWeapon_Mortar_Ring_Init()
	MpWeapon_Mortar_Ring_Missile_Init()

	MpWeaponEchoLocator_Init()
	MpAbilitySonicBlast_Init()

                                 
                      
                        
                               
                         
                              
                             
                               
                                   
                                
                             
       

               
                           
                           
                            
       

                  
		MpAbilityShieldThrow_Init()
		MpAbilityArmoredLeap_Init()
		MpWeaponReviveShield_Init()
       

               
                                  
                                
                               
                                                                 
                                
       

                
		PassiveVantage_Init()
		SniperUlt_Init()
		Companion_Launch_Init()
		MpWeaponVantageRecall_Init()

		SniperRecon_Init()
		VantageCompanion_Init()

		            
		                                      
		                      
       

                
                  
                           
       

                 
                            
                         
                                  
                          
                          
                           
                          
                            
       

                    
                                
       

	MpWeapon3030_Init()
	MpWeaponDragon_LMG_Init()
                        
                           
       

                           
                              
       

                              
                                 
       

	VOID_RING_Init()
	MpWeaponCar_Init()

                            
                            
       

                               
                              
       

                        
                        
       

                           
                             
       

	MpWeaponBasicBolt_Init()
	MpWeaponLmg_Init()

	#if SERVER
		                    
	#endif

                   
                            
                                        
       

        
                            
       
}


void function TableDump( table Table, int depth = 0 )
{
	if ( depth > 4 )
		return

	foreach ( k, v in Table )
	{
		printl( "Key: " + k + " Value: " + v )
		if ( type( v ) == "table" && depth )
			TableDump( expect table( v ), depth + 1 )
	}
}

                                                  
 
	                                                           
	 
		                                                      
		                         
			        
		                                                                    
			        
		             
	 

	                                           
	           
   

entity function GetClosest( array<entity> entArray, vector origin, float maxdist = -1.0 )
{
	entity bestEnt
	float bestDistSqr = (999999.0 * 999999.0)

	for ( int i = 0; i < entArray.len(); i++ )
	{
		entity ent       = entArray[ i ]
		float newDistSqr = DistanceSqr( ent.GetOrigin(), origin )

		if ( newDistSqr < bestDistSqr )
		{
			bestEnt = ent
			bestDistSqr = newDistSqr
		}
	}

	if ( maxdist >= 0.0 )
	{
		if ( bestDistSqr > maxdist * maxdist )
			return null
	}

	return bestEnt
}


int function GetClosestVectorIndex( array<vector> vecArray, vector origin, bool is2D = false, float maxdist = -1.0 )
{
	int bestIndex     = -1
	float bestDistSqr = (999999.0 * 999999.0)

	for ( int idx = 0; idx < vecArray.len(); idx++ )
	{
		float distSqr = is2D ? Distance2DSqr( vecArray[idx], origin ) : DistanceSqr( vecArray[idx], origin )
		if ( distSqr < bestDistSqr )
		{
			bestIndex = idx
			bestDistSqr = distSqr
		}
	}

	if ( maxdist >= 0.0 )
	{
		if ( bestDistSqr > maxdist * maxdist )
			return -1
	}

	return bestIndex
}


entity function GetClosest2D( array<entity> entArray, vector origin, float maxdist = -1.0 )
{
	Assert( entArray.len() > 0, "Empty array!" )

	entity bestEnt    = entArray[ 0 ]
	float bestDistSqr = DistanceSqr( bestEnt.GetOrigin(), origin )

	for ( int i = 1; i < entArray.len(); i++ )
	{
		entity newEnt    = entArray[ i ]
		float newDistSqr = Length2DSqr( newEnt.GetOrigin() - origin )

		if ( newDistSqr < bestDistSqr )
		{
			bestEnt = newEnt
			bestDistSqr = newDistSqr
		}
	}

	if ( maxdist >= 0.0 )
	{
		if ( bestDistSqr > maxdist * maxdist )
			return null
	}

	return bestEnt
}


entity function GetClosestSpawner( array<entity> spawnerArray, vector origin, float maxdist = -1.0 )
{
	Assert( spawnerArray.len() > 0 )

	entity bestEnt = spawnerArray[ 0 ]

	var spawnerKVs       = bestEnt.GetSpawnEntityKeyValues()
	vector spawnerOrigin = StringToVector( string( spawnerKVs.origin ) )
	float bestDistSqr    = DistanceSqr( spawnerOrigin, origin )

	for ( int i = 1; i < spawnerArray.len(); i++ )
	{
		entity newEnt = spawnerArray[ i ]

		spawnerKVs = newEnt.GetSpawnEntityKeyValues()
		spawnerOrigin = StringToVector( string( spawnerKVs.origin ) )

		float newDistSqr = LengthSqr( spawnerOrigin - origin )

		if ( newDistSqr < bestDistSqr )
		{
			bestEnt = newEnt
			bestDistSqr = newDistSqr
		}
	}

	if ( maxdist >= 0.0 )
	{
		if ( bestDistSqr > maxdist * maxdist )
			return null
	}

	return bestEnt
}


entity function GetFarthestSpawner( array<entity> spawnerArray, vector origin, float maxdist = -1.0 )
{
	Assert( spawnerArray.len() > 0 )

	entity bestEnt = spawnerArray[ 0 ]

	var spawnerKVs       = bestEnt.GetSpawnEntityKeyValues()
	vector spawnerOrigin = StringToVector( string( spawnerKVs.origin ) )
	float bestDistSqr    = DistanceSqr( spawnerOrigin, origin )

	for ( int i = 1; i < spawnerArray.len(); i++ )
	{
		entity newEnt = spawnerArray[ i ]

		spawnerKVs = newEnt.GetSpawnEntityKeyValues()
		spawnerOrigin = StringToVector( string( spawnerKVs.origin ) )

		float newDistSqr = LengthSqr( spawnerOrigin - origin )

		if ( newDistSqr > bestDistSqr )
		{
			bestEnt = newEnt
			bestDistSqr = newDistSqr
		}
	}

	if ( maxdist >= 0.0 )
	{
		if ( bestDistSqr < maxdist * maxdist )
			return null
	}

	return bestEnt
}


bool function GameModeHasCapturePoints()
{
	#if CLIENT
		return clGlobal.hardpointStringIDs.len() > 0
	#elseif SERVER
		                                            
	#endif
}


entity function GetFarthest( array<entity> entArray, vector origin )
{
	Assert( entArray.len() > 0, "Empty array!" )

	entity bestEnt    = entArray[0]
	float bestDistSqr = DistanceSqr( bestEnt.GetOrigin(), origin )

	for ( int i = 1; i < entArray.len(); i++ )
	{
		entity newEnt    = entArray[ i ]
		float newDistSqr = DistanceSqr( newEnt.GetOrigin(), origin )

		if ( newDistSqr > bestDistSqr )
		{
			bestEnt = newEnt
			bestDistSqr = newDistSqr
		}
	}

	return bestEnt
}


vector function GetFarthestVector( array<vector> vecArray, vector origin )
{
	Assert( vecArray.len() > 0, "Empty array!" )

	vector bestPos    = vecArray[0]
	float bestDistSqr = DistanceSqr( bestPos, origin )

	for ( int i = 1; i < vecArray.len(); i++ )
	{
		vector newVec    = vecArray[ i ]
		float newDistSqr = DistanceSqr( newVec, origin )

		if ( newDistSqr > bestDistSqr )
		{
			bestPos = newVec
			bestDistSqr = newDistSqr
		}
	}

	return bestPos
}


int function GetClosestIndex( array<entity> Array, vector origin )
{
	Assert( Array.len() > 0 )

	int index     = 0
	float distSqr = LengthSqr( Array[ index ].GetOrigin() - origin )

	entity newEnt
	float newDistSqr
	for ( int i = 1; i < Array.len(); i++ )
	{
		newEnt = Array[ i ]
		newDistSqr = LengthSqr( newEnt.GetOrigin() - origin )

		if ( newDistSqr < distSqr )
		{
			index = i
			distSqr = newDistSqr
		}
	}

	return index
}

                                                                                           
table function StringToColors( string colorString, string delimiter = WHITESPACE_CHARACTERS )
{
	PerfStart( PerfIndexShared.StringToColors + SharedPerfIndexStart )
	array<string> tokens = split( colorString, delimiter )

	Assert( tokens.len() >= 3 )

	table Table = {}
	Table.r <- int( tokens[0] )
	Table.g <- int( tokens[1] )
	Table.b <- int( tokens[2] )

	if ( tokens.len() == 4 )
		Table.a <- int( tokens[3] )
	else
		Table.a <- 255

	PerfEnd( PerfIndexShared.StringToColors + SharedPerfIndexStart )
	return Table
}

                                                                        
function ColorStringToArray( string colorString )
{
	array<string> tokens = split( colorString, WHITESPACE_CHARACTERS )

	Assert( tokens.len() >= 3 && tokens.len() <= 4 )

	array colorArray
	foreach ( token in tokens )
		colorArray.append( int( token ) )

	return colorArray
}

string function StringArrayToString( array<string> arr )
{
	string res = "["
	for ( int i=0; i<arr.len(); i++ )
	{
		res += arr[i]
		if ( i < arr.len() - 1 )
			res += ", "
	}
	res += "]"

	return res
}

                                                                     
                                                              
                                                
                                                                    
                                  
float function EvaluatePolynomial( float x, array<float> coefficientArray )
{
	float sum = 0.0

	for ( int i = 0; i < coefficientArray.len() - 1; ++i )
		sum += coefficientArray[ i ] * pow( x, coefficientArray.len() - 1 - i )

	if ( coefficientArray.len() >= 1 )
		sum += coefficientArray[ coefficientArray.len() - 1 ]

	return sum
}


bool function GetReplayDisabled()
{
	return GetGlobalNonRewindNetBool( "replayDisabled" )
}

#if SERVER

                                                                                                   
 
	                                     
	 
		                                                                   
		           
	 

	                                                            
	 
		                                                                                                               
		            
	 

	                        
	 
		                                     
		                                     
		 
			                                                                                            
			            
		 
	 

	                          
	 
		                                                                                             
		            
	 

	                                                                                                                                                                    
	 
		                                                                                       
		            
	 

	                         
	 
		                                                                                     
		            
	 

	                             
	 
		                                                                              
		            
	 

	                                              
 

                                                 
                                                            
 
	                           
	 
		                                                                                                 
		            
	 

	                          
	 
		                                                                                            
		           
	 

	                       
	 
		                                                                                          
		           
	 

	                                                                          
	            
 
#endif              

table function ArrayValuesToTableKeys( arr )
{
	Assert( type( arr ) == "array", "Not an array" )

	table resultTable
	for ( int i = 0; i < arr.len(); ++ i )
	{
		resultTable[ arr[ i ] ] <- 1
	}

	return resultTable
}

                                  
 
	                                               

	                      
	                               
	                         
	                           
	 
		                                      
		                   
	 

	                  
   

var function TableRandom( table Table )
{
	array Array = []

	foreach ( entry, contents in Table )
	{
		Array.append( contents )
	}

	return Array.getrandom()
}


int function RandomWeightedIndex( array Array )
{
	int count = Array.len()
	Assert( count != 0, "Array is empty" )

	int sum     = int( (count * (count + 1)) / 2.0 )                                
	int randInt = RandomInt( sum )
	for ( int i = 0; i < count; i++ )
	{
		int rangeForThisIndex = count - i
		if ( randInt < rangeForThisIndex )
			return i

		randInt -= rangeForThisIndex
	}

	Assert( 0 )
	unreachable
}


bool function IsValid_ThisFrame( entity ent )
{
	if ( ent == null )
		return false

	return expect bool( ent.IsValidInternal() )
}


bool function IsAlive( entity ent )
{
	if ( ent == null )
		return false

	if ( !ent.IsValidInternal() )
		return false

	return ent.IsEntAlive()
}


vector function PositionOffsetFromEnt( entity ent, float offsetX, float offsetY, float offsetZ )
{
	vector angles = ent.GetAngles()
	vector origin = ent.GetOrigin()
	origin += AnglesToForward( angles ) * offsetX
	origin += AnglesToRight( angles ) * offsetY
	origin += AnglesToUp( angles ) * offsetZ
	return origin
}


vector function PositionOffsetFromOriginAngles( vector origin, vector angles, float offsetX, float offsetY, float offsetZ )
{
	origin += AnglesToForward( angles ) * offsetX
	origin += AnglesToRight( angles ) * offsetY
	origin += AnglesToUp( angles ) * offsetZ
	return origin
}


bool function IsMenuLevel()
{
	return IsLobby()
}


void function Dump( package, int depth = 0 )
{
	if ( depth > 6 )
		return

	foreach ( k, v in package )
	{
		for ( int i = 0; i < depth; i++ )
			print( "    " )

		if ( IsTable( package ) )
			printl( "Key: " + k + " Value: " + v )

		if ( IsArray( package ) )
			printl( "Index: " + k + " Value: " + v )

		if ( IsTable( v ) || IsArray( v ) )
			Dump( v, depth + 1 )
	}
}


array<int> function GetAllValidPlayerTeams()
{
	array<int> teams
	foreach ( player in GetPlayerArray() )
	{
		int t = player.GetTeam()
		if ( !teams.contains( t ) )
		{
			teams.append( t )
		}
	}
	return teams
}

array<int> function GetAllValidConnectedPlayerTeams()
{
	array<int> teams
	foreach ( player in GetPlayerArray() )
	{
	#if SERVER
		                               
			        
	#endif

		int t = player.GetTeam()
		if ( !teams.contains( t ) )
		{
			teams.append( t )
		}
	}
	return teams
}

int function GetOtherTeam( int team )
{
	if ( team == TEAM_SPECTATOR )
		return TEAM_UNASSIGNED

	array<int> teams = GetAllValidPlayerTeams()
	foreach ( t in teams )
	{
		if ( t != team )
			return t
	}

	Warning( "Used GetOtherTeam() with less than 2 teams" )
	return TEAM_UNASSIGNED
}


table<int, int> function GetPlayerTeamCountTable()
{
	array<entity> players = GetPlayerArray()
	table<int, int> resultTable

	foreach ( player in players )
	{
		int team = player.GetTeam()
		if ( team in resultTable )
		{
			++resultTable[ team ]
		}
		else
		{
			resultTable[ team ] <- 1
		}
	}

	return resultTable
}


bool function IsPlayerOnTeam( entity player, int teamNum )
{
	Assert( IsValid( player ) )

	array<entity> teamPlayerArray = GetPlayerArrayOfTeam( teamNum )
	return teamPlayerArray.contains( player )
}


float function VectorDot_PlayerToOrigin( entity player, vector targetOrigin )
{
	vector playerEyePosition = player.EyePosition()
	vector vecToEnt          = (targetOrigin - playerEyePosition)
	vecToEnt.Norm()

	                                           
	float dotVal = vecToEnt.Dot( player.GetViewVector() )
	return dotVal
}


float function VectorDot_DirectionToOrigin( entity player, vector direction, vector targetOrigin )
{
	vector playerEyePosition = player.EyePosition()
	vector vecToEnt          = (targetOrigin - playerEyePosition)
	vecToEnt.Norm()

	                                           
	float dotVal = DotProduct( vecToEnt, direction )
	return dotVal
}


void function WaitUntilWithinDistance( entity player, entity titan, float dist )
{
	float distSqr = dist * dist
	for ( ; ; )
	{
		if ( !IsAlive( titan ) )
			return

		if ( IsAlive( player ) )
		{
			if ( DistanceSqr( player.GetOrigin(), titan.GetOrigin() ) <= distSqr )
				return
		}
		wait 0.1
	}
}


void function WaitUntilBeyondDistance( entity player, entity titan, float dist )
{
	float distSqr = dist * dist
	for ( ; ; )
	{
		if ( !IsAlive( titan ) )
			return

		if ( IsAlive( player ) )
		{
			if ( DistanceSqr( player.GetOrigin(), titan.GetOrigin() ) > distSqr )
				return
		}
		wait 0.1
	}
}


bool function IsModelViewer()
{
	return GetMapName() == "mp_model_viewer"
}


                                      
  	                  				  
                               		  
                                	  
                                      

                                                      
float function Tween_Linear( float frac )
{
	Assert( frac >= 0.0 && frac <= 1.0 )
	return frac
}

                                                       
float function Tween_QuadEaseOut( float frac )
{
	Assert( frac >= 0.0 && frac <= 1.0 )
	return -1.0 * frac * (frac - 2)
}

                                                         
float function Tween_ExpoEaseOut( float frac )
{
	Assert( frac >= 0.0 && frac <= 1.0 )
	return -pow( 2.0, -10.0 * frac ) + 1.0
}

                      
float function Tween_QuadEaseIn( float frac )
{
	return 1 * frac * frac
}

                          
float function Tween_QuadEaseInOut( float frac )
{
	frac *= 2
	if ( frac < 1 )
		return 0.5 * frac * frac
	frac--
	return -0.5 * frac * (frac - 2) + 0.5
}


float function Tween_ExpoEaseIn( float frac )
{
	Assert( frac >= 0.0 && frac <= 1.0 )
	return pow( 2, 10 * (frac - 1) )
}


bool function LegalOrigin( vector origin )
{
	if ( fabs( origin.x ) > MAX_WORLD_COORD )
		return false

	if ( fabs( origin.y ) > MAX_WORLD_COORD )
		return false

	if ( fabs( origin.z ) > MAX_WORLD_COORD )
		return false

	return true
}


vector function AnglesOnSurface( vector surfaceNormal, vector playerVelocity )
{
	playerVelocity.Norm()
	vector right   = CrossProduct( playerVelocity, surfaceNormal )
	vector forward = CrossProduct( surfaceNormal, right )
	vector angles  = VectorToAngles( forward )
	angles.z = atan2( right.z, surfaceNormal.z ) * RAD_TO_DEG

	return angles
}


vector function ClampToWorldspace( vector origin )
{
	                                                                      
	origin.x = clamp( origin.x, -MAX_WORLD_COORD, MAX_WORLD_COORD )
	origin.y = clamp( origin.y, -MAX_WORLD_COORD, MAX_WORLD_COORD )
	origin.z = clamp( origin.z, -MAX_WORLD_COORD, MAX_WORLD_COORD )

	return origin
}


function UseReturnTrue( user, usee )
{
	return true
}


bool function ControlPanel_IsValidModel( entity controlPanel )
{
	array<string> validModels
	validModels.append( "mdl/communication/terminal_usable_imc_01.rmdl" )
	validModels.append( "mdl/communication/terminal_usable_imc_02.rmdl" )
	validModels.append( "mdl/props/terminal_usable_wall_01_animated/terminal_usable_wall_01_animated.rmdl" )
	validModels.append( "mdl/props/terminal_usable_cpit_01_animated/terminal_usable_cpit_01_animated.rmdl" )
	validModels.append( "mdl/props/pathfinder_beacon_radar/pathfinder_beacon_radar_animated.rmdl" )
	validModels.append( "mdl/props/specter_shack_control/specter_shack_control.rmdl" )

	return validModels.contains( string( controlPanel.GetModelName() ) )
}


bool function ControlPanel_CanUseFunction( entity playerUser, entity controlPanel, int useFlags )
{
	if ( Bleedout_IsBleedingOut( playerUser ) )
		return false

	bool canUseWhileParented = EntIsHoverVehicle( playerUser.GetParent() ) && StatusEffect_GetSeverity( playerUser, eStatusEffect.camera_view ) > 0.0	                           
	if ( IsValid( playerUser.GetParent() ) && !canUseWhileParented )
		return false

	entity activeWeapon = playerUser.GetActiveWeapon( eActiveInventorySlot.mainHand )
	if ( IsValid( activeWeapon ) )
	{
		if( activeWeapon.IsWeaponOffhand() )
		{
			var offhandAllowsPickups = activeWeapon.GetWeaponInfoFileKeyField( "offhand_allow_player_interact" )
			if ( !offhandAllowsPickups || offhandAllowsPickups <= 0 )
				return false
		}
	}

	                                                                    
	int maxAngleToAxisAllowedDegrees = 60

	vector playerEyePos = playerUser.EyePosition()
	int attachmentIndex = controlPanel.LookupAttachment( "PANEL_SCREEN_MIDDLE" )

	Assert( attachmentIndex != 0 )
	vector controlPanelScreenPosition = controlPanel.GetAttachmentOrigin( attachmentIndex )
	vector controlPanelScreenAngles   = controlPanel.GetAttachmentAngles( attachmentIndex )
	vector controlPanelScreenForward  = AnglesToForward( controlPanelScreenAngles )

	vector screenToPlayerEyes = Normalize( playerEyePos - controlPanelScreenPosition )

	return DotProduct( screenToPlayerEyes, controlPanelScreenForward ) > deg_cos( maxAngleToAxisAllowedDegrees )
}


bool function SentryTurret_CanUseFunction( entity playerUser, entity sentryTurret )
{
	                                                                    
	int maxAngleToAxisAllowedDegrees = 90

	vector playerEyePos = playerUser.EyePosition()
	int attachmentIndex = sentryTurret.LookupAttachment( "turret_player_use" )

	Assert( attachmentIndex != 0 )
	vector sentryTurretUsePosition = sentryTurret.GetAttachmentOrigin( attachmentIndex )
	vector sentryTurretUseAngles   = sentryTurret.GetAttachmentAngles( attachmentIndex )
	vector sentryTurretUseForward  = AnglesToForward( sentryTurretUseAngles )

	vector useToPlayerEyes = Normalize( playerEyePos - sentryTurretUsePosition )

	return DotProduct( useToPlayerEyes, sentryTurretUseForward ) > deg_cos( maxAngleToAxisAllowedDegrees )
}


void function ArrayRemoveInvalid( array<entity> ents )
{
	for ( int i = ents.len() - 1; i >= 0; i-- )
	{
		if ( !IsValid( ents[ i ] ) )
			ents.remove( i )
	}
}


bool function HasDamageStates( entity ent )
{
	if ( !IsValid( ent ) )
		return false
	return ("damageStateInfo" in ent.s)
}


FrontRightDotProductsStruct function GetFrontRightDots( entity baseEnt, entity relativeEnt, string optionalTag = "" )
{
	if ( optionalTag != "" )
	{
		int attachIndex = baseEnt.LookupAttachment( optionalTag )
		vector origin   = baseEnt.GetAttachmentOrigin( attachIndex )
		vector angles   = baseEnt.GetAttachmentAngles( attachIndex )
		angles.x = 0
		angles.z = 0
		vector forward = AnglesToForward( angles )
		vector right   = AnglesToRight( angles )

		vector targetOrg = relativeEnt.GetOrigin()
		vector vecToEnt  = (targetOrg - origin)
		  		                               
		vecToEnt.z = 0

		vecToEnt.Norm()


		FrontRightDotProductsStruct result
		result.forwardDot = DotProduct( vecToEnt, forward )
		result.rightDot = DotProduct( vecToEnt, right )

		                                
		                                                                      

		                     
		                                                                       

		                  
		                                                                    
		return result
	}

	vector targetOrg = relativeEnt.GetOrigin()
	vector origin    = baseEnt.GetOrigin()
	vector vecToEnt  = (targetOrg - origin)
	vecToEnt.Norm()

	FrontRightDotProductsStruct result
	result.forwardDot = vecToEnt.Dot( baseEnt.GetForwardVector() )
	result.rightDot = vecToEnt.Dot( baseEnt.GetRightVector() )
	return result
}


array<vector> function GetAllPointsOnBezier( array<vector> points, int numSegments, float debugDrawTime = 0.0 )
{
	Assert( points.len() >= 2 )
	Assert( numSegments > 0 )
	array<vector> curvePoints = []

	                                           
	if ( debugDrawTime )
	{
		for ( int i = 0; i < points.len() - 1; i++ )
			DebugDrawLine( points[i], points[i + 1], <150, 150, 150>, true, debugDrawTime )
	}

	for ( int i = 0; i < numSegments; i++ )
	{
		float t = float( i ) / (float( numSegments ) - 1.0)
		curvePoints.append( GetSinglePointOnBezier( points, t ) )
	}

	if ( debugDrawTime )
	{
		for ( int i = 0; i < curvePoints.len() - 1; i++ )
			DebugDrawLine( curvePoints[i], curvePoints[i + 1], <200, 0, 0>, true, debugDrawTime )
	}

	return curvePoints
}


vector function GetSinglePointOnBezier( array<vector> points, float t )
{
	                                                           

	array<vector> lastPoints = clone points
	for ( ; ; )
	{
		array<vector> newPoints = []
		for ( int i = 0; i < lastPoints.len() - 1; i++ )
			newPoints.append( lastPoints[i] + (lastPoints[i + 1] - lastPoints[i]) * t )

		if ( newPoints.len() == 1 )
			return newPoints[0]

		lastPoints = newPoints
	}

	unreachable
}


array< vector > function GetBezierOfPath( array< vector > path, int numSegments, float debugTime = 0.0 )
{
	Assert( path.len() >= 3 )
	int numNodesInPath = path.len()
	int idx_cur        = 0
	array< vector > nodeTangents
	array< vector > bezierPath

	for ( ; idx_cur < numNodesInPath - 1; idx_cur++ )
	{
		int idx_next   = (idx_cur + 1) % numNodesInPath
		int idx_next_2 = (idx_cur + 2) % numNodesInPath

		                                                    
		if ( idx_next < (numNodesInPath - 1) )
		{
			nodeTangents.append( GetBezierNodeTangent( path[ idx_next ], path[ idx_cur ], path[ idx_next_2 ] ) )

			                                                                                                                                         
			if ( idx_cur == 0 )
			{
				                                                  
				vector firstTangent = path[ idx_next ] + nodeTangents[ 0 ]
				                                                         
				firstTangent = path[ idx_cur ] - firstTangent
				nodeTangents.insert( 0, firstTangent )
			}
		}
		                                                                                                                   
		else
		{
			                                                  
			vector lastTangent = path[ idx_cur ] - nodeTangents[ idx_cur ]
			                                                        
			lastTangent = lastTangent - path[ idx_next ]
			nodeTangents.append( lastTangent )
		}

		array< vector > bezierPoints = GetAllPointsOnBezier( [ path[ idx_cur ], path[ idx_cur ] - nodeTangents[ idx_cur ], path[ idx_next ] + nodeTangents[ idx_next ], path[ idx_next ] ], numSegments, debugTime )

		                                                                                                                                              
		vector endPoint = bezierPoints.pop()
		bezierPath.extend( bezierPoints )

		                                                      
		if ( idx_cur >= (numNodesInPath - 2) )
			bezierPath.append( endPoint )
	}

	return bezierPath
}

                                                                    
array< vector > function GetBezierOfPathLoop( array< vector > path, int numSegments )
{
	int numNodesInPath = path.len()
	int idx_cur        = 0
	array< vector > nodeTangents
	array< vector > bezierPath

	nodeTangents.append( GetBezierNodeTangent( path[ 0 ], path[ (numNodesInPath - 1) ], path[ 1 ] ) )
	for ( ; idx_cur < numNodesInPath; idx_cur++ )
	{
		int idx_next   = (idx_cur + 1) % numNodesInPath
		int idx_next_2 = (idx_cur + 2) % numNodesInPath

		                                                    
		if ( idx_cur < (numNodesInPath - 1) )
		{
			nodeTangents.append( GetBezierNodeTangent( path[ idx_next ], path[ idx_cur ], path[ idx_next_2 ] ) )
		}

		array< vector > bezierPoints = GetAllPointsOnBezier( [ path[ idx_cur ], path[ idx_cur ] - nodeTangents[ idx_cur ], path[ idx_next ] + nodeTangents[ idx_next ], path[ idx_next ] ], numSegments )
		                                                                                                                                              
		bezierPoints.pop()
		bezierPath.extend( bezierPoints )
	}

	return bezierPath
}

                                                                   
                                                                              
vector function GetBezierNodeTangent( vector nodePos, vector predecessorPos, vector successorPos )
{
	vector preToNode       = nodePos - predecessorPos
	vector nodeToSuccessor = successorPos - nodePos

	float preToNodeLen       = Distance( nodePos, predecessorPos )
	float nodeToSuccessorLen = Distance( successorPos, nodePos )

	vector preToNodeNorm       = preToNode / preToNodeLen
	vector nodeToSuccessorNorm = nodeToSuccessor / nodeToSuccessorLen

	float angleToBisect = acos( DotProduct( preToNodeNorm, nodeToSuccessorNorm ) )
	angleToBisect = 180 - RadToDeg( angleToBisect )
	angleToBisect *= 0.5
	vector crossUp = Normalize( CrossProduct( preToNodeNorm, nodeToSuccessorNorm ) )
	if ( Length( crossUp ) == 0 )
	{
		printt( "!!! Cross up length is 0 !!!" )
		return < 0, 0, 0 >
	}
	vector bisectVector = VectorRotateAxis( preToNodeNorm, crossUp, angleToBisect )

	vector tangentDir = Normalize( CrossProduct( bisectVector, crossUp ) )
	float tangentDist = min( preToNodeLen, nodeToSuccessorLen ) * 0.5

	                                                                        
	return tangentDir * tangentDist
}


bool function GetDoomedState( entity ent )
{
	return false
}


bool function CoreAvailableDuringDoomState()
{
	return true
}


bool function HasAntiTitanWeapon( entity guy )
{
	foreach ( weapon in guy.GetMainWeapons() )
	{
		if ( weapon.GetWeaponType() == WT_ANTITITAN )
			return true
	}
	return false
}


float function GetTitanCoreActiveTime( entity player )
{
	entity weapon = player.GetOffhandWeapon( OFFHAND_EQUIPMENT )

	if ( !IsValid( weapon ) )
	{
		printt( "WARNING: tried to get core active time, but core weapon was invalid." )
		printt( "titan is alive? " + IsAlive( player ) )
		return 5.0           
	}

	return GetTitanCoreDurationFromWeapon( weapon )
}


float function GetTitanCoreChargeTime( entity player )
{
	entity weapon = player.GetOffhandWeapon( OFFHAND_EQUIPMENT )

	if ( !IsValid( weapon ) )
	{
		printt( "WARNING: tried to get core charge time, but core weapon was invalid." )
		printt( "titan is alive? " + IsAlive( player ) )
		return 1.0           
	}

	return GetTitanCoreChargeTimeFromWeapon( weapon )
}


float function GetTitanCoreChargeTimeFromWeapon( entity weapon )
{
	return expect float( weapon.GetWeaponInfoFileKeyField( "chargeup_time" ) )
}


float function GetTitanCoreBuildTimeFromWeapon( entity weapon )
{
	return weapon.GetWeaponSettingFloat( eWeaponVar.core_build_time )
}


float function GetTitanCoreDurationFromWeapon( entity weapon )
{
	float coreDuration = weapon.GetCoreDuration()

	entity player = weapon.GetWeaponOwner()

	return coreDuration
}


float function GetCoreBuildTime( entity titan )
{
	if ( titan.IsPlayer() )
		titan = GetTitanFromPlayer( titan )

	Assert( titan != null )

	entity coreWeapon = titan.GetOffhandWeapon( OFFHAND_EQUIPMENT )

	if ( !IsValid( coreWeapon ) )
	{
		                                                                             
		                                                 
		return 200.0           
	}


	return GetTitanCoreBuildTimeFromWeapon( coreWeapon )
}


string function GetCoreShortName( entity titan )
{
	entity coreWeapon = titan.GetOffhandWeapon( OFFHAND_EQUIPMENT )

	if ( !IsValid( coreWeapon ) )
	{
		printt( "WARNING: tried to get core name, but core weapon was invalid." )
		printt( "titan is alive? " + IsAlive( titan ) )
		return "#HUD_READY"
	}

	string name = coreWeapon.GetWeaponSettingString( eWeaponVar.shortprintname )
	return name
}


string ornull function GetCoreOSConversationName( entity titan, string event )
{
	entity coreWeapon = titan.GetOffhandWeapon( OFFHAND_EQUIPMENT )

	if ( !IsValid( coreWeapon ) )
	{
		printt( "WARNING: tried to get core sound for " + event + ", but core weapon was invalid." )
		printt( "titan is alive? " + IsAlive( titan ) )
		return null
	}

	var alias = coreWeapon.GetWeaponInfoFileKeyField( "dialog_" + event )

	if ( alias == null )
		return null

	expect string( alias )

	return alias
}


entity function GetTitanFromPlayer( entity player )
{
	Assert( player.IsPlayer() )
	if ( player.IsTitan() )
		return player

	return player.GetPetTitan()
}


int function GetNuclearPayload( entity player )
{
	if ( !GetDoomedState( player ) )
		return 0

	int payload = 0

	return payload
}


entity function GetCloak( entity ent )
{
	return GetOffhand( ent, "mp_ability_cloak" )
}


entity function GetOffhand( entity ent, string classname )
{
	entity offhand = ent.GetOffhandWeapon( OFFHAND_LEFT )
	if ( IsValid( offhand ) && offhand.GetWeaponClassName() == classname )
		return offhand

	offhand = ent.GetOffhandWeapon( OFFHAND_RIGHT )
	if ( IsValid( offhand ) && offhand.GetWeaponClassName() == classname )
		return offhand

	return null
}


bool function IsCloaked( entity ent )
{
	return ent.IsCloaked( true )                                     
}


float function GetGameStateChangeTime()
{
	return GetGlobalNonRewindNetTime( "gameStateChangeTime" )
}


float function TimeSpentInCurrentState()
{
	return Time() - GetGameStateChangeTime()
}


float function DotToAngle( float dot )
{
	return acos( dot ) * RAD_TO_DEG
}


float function AngleToDot( float angle )
{
	return cos( angle * DEG_TO_RAD )
}


int function GetGameState()
{
	return GetGlobalNonRewindNetInt( "gameState" )
}


bool function GamePlaying()
{
	return GetGameState() == eGameState.Playing
}


bool function GameEpilogue()
{
	return GetGameState() == eGameState.Epilogue
}


bool function GamePlayingOrSuddenDeath()
{
	int gameState = GetGameState()
	return gameState == eGameState.Playing || gameState == eGameState.SuddenDeath
}


vector function VectorReflectionAcrossNormal( vector vec, vector normal )
{
	return (vec - normal * (2 * DotProduct( vec, normal )))
}

                                                                                       
array<entity> function ArrayFarthest( array<entity> entArray, vector origin )
{
	array<ArrayDistanceEntry> allResults = ArrayDistanceResults( entArray, origin )

	allResults.sort( DistanceCompareFarthest )

	array<entity> returnEntities

	foreach ( result in allResults )
		returnEntities.append( result.ent )

	                                       
	return returnEntities
}

                                                                                        
array<vector> function ArrayFarthestVector( array<vector> vecArray, vector origin )
{
	array<ArrayDistanceEntry> allResults = ArrayDistanceResultsVector( vecArray, origin )

	allResults.sort( DistanceCompareFarthest )

	array<vector> returnVecs

	foreach ( result in allResults )
		returnVecs.append( result.origin )

	return returnVecs
}

                                                                                         
array<entity> function ArrayClosest( array<entity> entArray, vector origin )
{
	array<ArrayDistanceEntry> allResults = ArrayDistanceResults( entArray, origin )

	allResults.sort( DistanceCompareClosest )

	array<entity> returnEntities

	foreach ( result in allResults )
		returnEntities.append( result.ent )

	return returnEntities
}

                                                                                        
array<vector> function ArrayClosestVector( array<vector> vecArray, vector origin )
{
	array<ArrayDistanceEntry> allResults = ArrayDistanceResultsVector( vecArray, origin )

	allResults.sort( DistanceCompareClosest )

	array<vector> returnVecs

	foreach ( result in allResults )
		returnVecs.append( result.origin )

	return returnVecs
}

                                                                                       
array<Point> function ArrayClosestPoint( array<Point> pointArray, vector origin )
{
	array<ArrayDistanceEntry> allResults = ArrayDistanceResultsPoint( pointArray, origin )

	allResults.sort( DistanceCompareClosest )

	array<Point> returnPoints

	foreach ( result in allResults )
	{
		Point point
		point.origin = result.origin
		point.angles = result.angles
		returnPoints.append( point )
	}

	return returnPoints
}


array<entity> function ArrayClosestWithinDistance( array<entity> entArray, vector origin, float maxDistance )
{
	array<ArrayDistanceEntry> allResults = ArrayDistanceResults( entArray, origin )
	float maxDistSq                      = maxDistance * maxDistance

	allResults.sort( DistanceCompareClosest )

	array<entity> returnEntities

	foreach ( result in allResults )
	{
		if ( result.distanceSqr > maxDistSq )
			break

		returnEntities.append( result.ent )
	}

	return returnEntities
}


array<vector> function ArrayClosestVectorWithinDistance( array<vector> vecArray, vector origin, float maxDistance )
{
	array<ArrayDistanceEntry> allResults = ArrayDistanceResultsVector( vecArray, origin )
	float maxDistSq                      = maxDistance * maxDistance

	allResults.sort( DistanceCompareClosest )

	array<vector> returnVecs

	foreach ( result in allResults )
	{
		if ( result.distanceSqr > maxDistSq )
			break

		returnVecs.append( result.origin )
	}

	return returnVecs
}


array<Point> function ArrayClosestPointWithinDistance( array<Point> pointArray, vector origin, float maxDistance )
{
	array<ArrayDistanceEntry> allResults = ArrayDistanceResultsPoint( pointArray, origin )
	float maxDistSq                      = maxDistance * maxDistance

	allResults.sort( DistanceCompareClosest )

	array<Point> returnPoints

	foreach ( result in allResults )
	{
		if ( result.distanceSqr > maxDistSq )
			break
		Point point
		point.origin = result.origin
		point.angles = result.angles
		returnPoints.append( point )
	}

	return returnPoints
}

                                                                                                     
array<entity> function ArrayClosest2D( array<entity> entArray, vector origin )
{
	array<ArrayDistanceEntry> allResults = ArrayDistance2DResults( entArray, origin )

	allResults.sort( DistanceCompareClosest )

	array<entity> returnEntities

	foreach ( result in allResults )
		returnEntities.append( result.ent )

	return returnEntities
}

                                                                                                     
array<vector> function ArrayClosest2DVector( array<vector> entArray, vector origin )
{
	array<ArrayDistanceEntry> allResults = ArrayDistance2DResultsVector( entArray, origin )

	allResults.sort( DistanceCompareClosest )

	array<vector> returnVecs

	foreach ( result in allResults )
		returnVecs.append( result.origin )

	return returnVecs
}


array<entity> function ArrayClosest2DWithinDistance( array<entity> entArray, vector origin, float maxDistance )
{
	array<ArrayDistanceEntry> allResults = ArrayDistance2DResults( entArray, origin )
	float maxDistSq                      = maxDistance * maxDistance

	allResults.sort( DistanceCompareClosest )

	array<entity> returnEntities

	foreach ( result in allResults )
	{
		if ( result.distanceSqr > maxDistSq )
			break

		returnEntities.append( result.ent )
	}

	return returnEntities
}

                                                                                                     
array<vector> function ArrayClosest2DVectorWithinDistance( array<vector> entArray, vector origin, float maxDistance )
{
	array<ArrayDistanceEntry> allResults = ArrayDistance2DResultsVector( entArray, origin )
	float maxDistSq                      = maxDistance * maxDistance

	allResults.sort( DistanceCompareClosest )

	array<vector> returnVecs

	foreach ( result in allResults )
	{
		if ( result.distanceSqr > maxDistSq )
			break

		returnVecs.append( result.origin )
	}

	return returnVecs
}


bool function ArrayEntityWithinDistance( array<entity> entArray, vector origin, float distance )
{
	float distSq = distance * distance
	foreach ( entity ent in entArray )
	{
		if ( DistanceSqr( ent.GetOrigin(), origin ) <= distSq )
			return true
	}
	return false
}


int function DistanceCompareClosest( ArrayDistanceEntry a, ArrayDistanceEntry b )
{
	if ( a.distanceSqr > b.distanceSqr )
		return 1
	else if ( a.distanceSqr < b.distanceSqr )
		return -1

	return 0
}


int function DistanceCompareFarthest( ArrayDistanceEntry a, ArrayDistanceEntry b )
{
	if ( a.distanceSqr < b.distanceSqr )
		return 1
	else if ( a.distanceSqr > b.distanceSqr )
		return -1

	return 0
}


array<ArrayDistanceEntry> function ArrayDistanceResults( array<entity> entArray, vector origin )
{
	array<ArrayDistanceEntry> allResults

	foreach ( ent in entArray )
	{
		ArrayDistanceEntry entry

		vector entOrigin = ent.GetOrigin()
		if ( IsSpawner( ent ) )
		{
			var spawnKVs = ent.GetSpawnEntityKeyValues()
			entOrigin = StringToVector( string( spawnKVs.origin ) )
		}
		entry.distanceSqr = DistanceSqr( entOrigin, origin )
		entry.ent = ent
		entry.origin = entOrigin

		allResults.append( entry )
	}

	return allResults
}


array<ArrayDistanceEntry> function ArrayDistanceResultsVector( array<vector> vecArray, vector origin )
{
	array<ArrayDistanceEntry> allResults

	foreach ( vec in vecArray )
	{
		ArrayDistanceEntry entry

		entry.distanceSqr = DistanceSqr( vec, origin )
		entry.ent = null
		entry.origin = vec

		allResults.append( entry )
	}

	return allResults
}


                                                                                                 
bool function PointWithinDistOfAnyPoint( Point point, array<Point> pointArray, float dist )
{
	float distSq = dist * dist
	foreach ( Point pt in pointArray )
	{
		if ( DistanceSqr( pt.origin, point.origin ) < distSq )
			return true
	}

	return false
}


array<ArrayDistanceEntry> function ArrayDistanceResultsPoint( array<Point> pointArray, vector origin )
{
	array<ArrayDistanceEntry> allResults

	foreach ( point in pointArray )
	{
		ArrayDistanceEntry entry

		entry.distanceSqr = DistanceSqr( point.origin, origin )
		entry.ent = null
		entry.origin = point.origin
		entry.angles = point.angles

		allResults.append( entry )
	}

	return allResults
}


array<ArrayDistanceEntry> function ArrayDistance2DResults( array<entity> entArray, vector origin )
{
	array<ArrayDistanceEntry> allResults

	foreach ( ent in entArray )
	{
		ArrayDistanceEntry entry

		vector entOrigin = ent.GetOrigin()

		entry.distanceSqr = Distance2DSqr( entOrigin, origin )
		entry.ent = ent
		entry.origin = entOrigin

		allResults.append( entry )
	}

	return allResults
}


array<ArrayDistanceEntry> function ArrayDistance2DResultsVector( array<vector> vecArray, vector origin )
{
	array<ArrayDistanceEntry> allResults

	foreach ( vec in vecArray )
	{
		ArrayDistanceEntry entry

		entry.distanceSqr = Distance2DSqr( vec, origin )
		entry.ent = null
		entry.origin = vec

		allResults.append( entry )
	}

	return allResults
}


GravityLandData function GetGravityLandData( vector startPos, vector parentVelocity, vector objectVelocity, float timeLimit, bool bDrawPath = false, int traceMask = TRACE_MASK_NPCWORLDSTATIC, float bDrawPathDuration = 0.0, array pathColor = [ 255, 255, 0 ] )
{
	GravityLandData returnData

	Assert( timeLimit > 0 )

	                             
	float timeElapsePerTrace = 0.1

	float sv_gravity   = 750.0
	float ent_gravity  = 1.0
	float gravityScale = 1.0

	vector traceStart = startPos
	vector traceEnd   = traceStart
	float traceFrac
	int traceCount    = 0

	objectVelocity += parentVelocity

	while ( returnData.elapsedTime <= timeLimit )
	{
		objectVelocity.z -= (ent_gravity * sv_gravity * timeElapsePerTrace * gravityScale)

		traceEnd += objectVelocity * timeElapsePerTrace
		returnData.points.append( traceEnd )
		if ( bDrawPath )
			DebugDrawLine( traceStart, traceEnd, <pathColor[0], pathColor[1], pathColor[2]>, false, bDrawPathDuration )

		traceFrac = TraceLineSimple( traceStart, traceEnd, null )
		traceCount++
		if ( traceFrac < 1.0 )
		{
			returnData.traceResults = TraceLine( traceStart, traceEnd, null, traceMask, TRACE_COLLISION_GROUP_NONE )
			return returnData
		}
		traceStart = traceEnd
		returnData.elapsedTime += timeElapsePerTrace
	}

	return returnData
}


float function GetPulseFrac( rate = 1, startTime = 0 )
{
	return (1 - cos( (Time() - startTime) * (rate * (2 * PI)) )) / 2
}


vector function StringToVector( string vecString, string delimiter = WHITESPACE_CHARACTERS )
{
	array<string> tokens = split( vecString, delimiter )

	Assert( tokens.len() >= 3 )

	return <float( tokens[0] ), float( tokens[1] ), float( tokens[2] )>
}


float function GetShieldHealthFrac( entity ent )
{
	if ( !IsAlive( ent ) )
		return 0.0

	int shieldHealth    = ent.GetShieldHealth()
	int shieldMaxHealth = ent.GetShieldHealthMax()

	if ( shieldMaxHealth == 0 )
		return 0.0

	return float( shieldHealth ) / float( shieldMaxHealth )
}


float function GetShieldHealthFracBeforeDamage( entity ent, int damage )
{
	if ( !IsAlive( ent ) )
		return 0.0

	int shieldHealth    = ent.GetShieldHealth() + damage
	int shieldMaxHealth = ent.GetShieldHealthMax()

	Assert( shieldHealth <= shieldMaxHealth )
	if ( shieldHealth > shieldMaxHealth )
		shieldHealth = shieldMaxHealth

	if ( shieldMaxHealth == 0 )
		return 0.0

	return float( shieldHealth ) / float( shieldMaxHealth )
}


vector function HackGetDeltaToRef( vector origin, vector angles, entity ent, string anim )
{
	AnimRefPoint animStartPos = ent.Anim_GetStartForRefPoint( anim, origin, angles )

	vector delta = origin - animStartPos.origin
	return origin + delta
}


vector function HackGetDeltaToRefOnPlane( vector origin, vector angles, entity ent, string anim, vector up )
{
	AnimRefPoint animStartPos = ent.Anim_GetStartForRefPoint( anim, origin, angles )

	vector delta       = origin - animStartPos.origin
	vector nDelta      = Normalize( delta )
	vector xProd       = CrossProduct( nDelta, up )
	vector G           = CrossProduct( up, xProd )
	vector planarDelta = G * DotProduct( delta, G )
	vector P           = origin + planarDelta

	                                                               
	                                                     

	return P
}


Point function HackGetPointToRef( vector origin, vector angles, entity ent, string anim )
{
	AnimRefPoint animStartPos = ent.Anim_GetStartForRefPoint( anim, origin, angles )

	Point point
	point.angles = ClampAngles( angles + (angles - animStartPos.angles) )
	point.origin = HackGetDeltaToRef( origin, point.angles, ent, anim )

	return point
}


TraceResults function GetViewTrace( entity ent )
{
	vector traceStart        = ent.EyePosition()
	vector traceEnd          = traceStart + (ent.GetPlayerOrNPCViewVector() * 56756)                                                    
	array<entity> ignoreEnts = [ ent ]

	return TraceLine( traceStart, traceEnd, ignoreEnts, TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )
}


void function ArrayRemoveDead( array<entity> entArray )
{
	for ( int i = entArray.len() - 1; i >= 0; i-- )
	{
		if ( !IsAlive( entArray[ i ] ) )
			entArray.remove( i )
	}
}


array<entity> function GetSortedPlayers( IntFromEntityCompare compareFunc, int team )
{
	array<entity> players

	if ( team )
		players = GetPlayerArrayOfTeam( team )
	else
		players = GetPlayerArray()

	players.sort( compareFunc )

	return players
}

#if R2_SCOREBOARD
                                                                                                
int function CompareKills( entity a, entity b )
{
	int aVal = a.GetPlayerGameStat( PGS_KILLS )
	int bVal = b.GetPlayerGameStat( PGS_KILLS )

	if ( aVal < bVal )
		return 1
	else if ( aVal > bVal )
		return -1

	aVal = a.GetPlayerGameStat( PGS_DEATHS )
	bVal = b.GetPlayerGameStat( PGS_DEATHS )

	if ( aVal > bVal )
		return 1
	else if ( aVal < bVal )
		return -1

	aVal = a.GetPlayerGameStat( PGS_TITAN_KILLS )
	bVal = b.GetPlayerGameStat( PGS_TITAN_KILLS )

	if ( aVal < bVal )
		return 1
	else if ( aVal > bVal )
		return -1

	aVal = a.GetPlayerGameStat( PGS_ASSISTS )
	bVal = b.GetPlayerGameStat( PGS_ASSISTS )

	if ( aVal < bVal )
		return 1
	else if ( aVal > bVal )
		return -1

	return 0
}

                                                                                                
int function CompareAssaultScore( entity a, entity b )
{
	int aVal = a.GetPlayerGameStat( PGS_ASSAULT_SCORE )
	int bVal = b.GetPlayerGameStat( PGS_ASSAULT_SCORE )

	if ( aVal < bVal )
		return 1
	else if ( aVal > bVal )
		return -1

	return 0
}


int function CompareScore( entity a, entity b )
{
	int aVal = a.GetPlayerGameStat( PGS_SCORE )
	int bVal = b.GetPlayerGameStat( PGS_SCORE )

	if ( aVal < bVal )
		return 1
	else if ( aVal > bVal )
		return -1

	return 0
}


int function CompareAssault( entity a, entity b )
{
	int aVal = a.GetPlayerGameStat( PGS_ASSAULT_SCORE )
	int bVal = b.GetPlayerGameStat( PGS_ASSAULT_SCORE )

	if ( aVal < bVal )
		return 1
	else if ( aVal > bVal )
		return -1

	return 0
}


int function CompareDefense( entity a, entity b )
{
	int aVal = a.GetPlayerGameStat( PGS_DEFENSE_SCORE )
	int bVal = b.GetPlayerGameStat( PGS_DEFENSE_SCORE )

	if ( aVal < bVal )
		return 1
	else if ( aVal > bVal )
		return -1

	return 0
}


int function CompareLTS( entity a, entity b )
{
	int result = CompareTitanKills( a, b )
	if ( result != 0 )
		return result

	int aVal = a.GetPlayerGameStat( PGS_ASSAULT_SCORE )
	int bVal = b.GetPlayerGameStat( PGS_ASSAULT_SCORE )

	if ( aVal < bVal )
		return 1
	else if ( aVal > bVal )
		return -1

	return 0
}


int function CompareCP( entity a, entity b )
{
	                                                                                               

	{
		int aVal = a.GetPlayerGameStat( PGS_ASSAULT_SCORE )
		int bVal = b.GetPlayerGameStat( PGS_ASSAULT_SCORE )

		aVal += a.GetPlayerGameStat( PGS_DEFENSE_SCORE )
		bVal += b.GetPlayerGameStat( PGS_DEFENSE_SCORE )

		if ( aVal < bVal )
			return 1
		else if ( aVal > bVal )
			return -1
	}

	                 
	{
		int aVal = a.GetPlayerGameStat( PGS_KILLS )
		int bVal = b.GetPlayerGameStat( PGS_KILLS )

		if ( aVal < bVal )
			return 1
		else if ( aVal > bVal )
			return -1
	}

	                 
	{
		int aVal = a.GetPlayerGameStat( PGS_TITAN_KILLS )
		int bVal = b.GetPlayerGameStat( PGS_TITAN_KILLS )

		if ( aVal < bVal )
			return 1
		else if ( aVal > bVal )
			return -1
	}

	            
	{
		int aVal = a.GetPlayerGameStat( PGS_DEATHS )
		int bVal = b.GetPlayerGameStat( PGS_DEATHS )

		if ( aVal < bVal )
			return -1
		else if ( aVal > bVal )
			return 1
	}

	return 0
}


int function CompareCTF( entity a, entity b )
{
	                                                                                                             

	                   
	int result = CompareAssault( a, b )
	if ( result != 0 )
		return result

	                  
	result = CompareDefense( a, b )
	if ( result != 0 )
		return result

	                 
	int aVal = a.GetPlayerGameStat( PGS_KILLS )
	int bVal = b.GetPlayerGameStat( PGS_KILLS )

	if ( aVal < bVal )
		return 1
	else if ( aVal > bVal )
		return -1

	                 
	aVal = a.GetPlayerGameStat( PGS_TITAN_KILLS )
	bVal = b.GetPlayerGameStat( PGS_TITAN_KILLS )

	if ( aVal < bVal )
		return 1
	else if ( aVal > bVal )
		return -1

	            
	aVal = a.GetPlayerGameStat( PGS_DEATHS )
	bVal = b.GetPlayerGameStat( PGS_DEATHS )

	if ( aVal < bVal )
		return -1
	else if ( aVal > bVal )
		return 1

	return 0
}


int function CompareSpeedball( entity a, entity b )
{
	                                                                                

	                 
	int aVal = a.GetPlayerGameStat( PGS_KILLS )
	int bVal = b.GetPlayerGameStat( PGS_KILLS )

	if ( aVal < bVal )
		return 1
	else if ( aVal > bVal )
		return -1

	                   
	int result = CompareAssault( a, b )
	if ( result != 0 )
		return result

	            
	aVal = a.GetPlayerGameStat( PGS_DEATHS )
	bVal = b.GetPlayerGameStat( PGS_DEATHS )

	if ( aVal < bVal )
		return -1
	else if ( aVal > bVal )
		return 1

	return 0
}


int function CompareMFD( entity a, entity b )
{
	                  
	int result = CompareAssault( a, b )
	if ( result != 0 )
		return result

	                     
	result = CompareDefense( a, b )
	if ( result != 0 )
		return result

	                 
	int aVal = a.GetPlayerGameStat( PGS_KILLS )
	int bVal = b.GetPlayerGameStat( PGS_KILLS )

	if ( aVal < bVal )
		return 1
	else if ( aVal > bVal )
		return -1

	                 
	aVal = a.GetPlayerGameStat( PGS_TITAN_KILLS )
	bVal = b.GetPlayerGameStat( PGS_TITAN_KILLS )

	if ( aVal < bVal )
		return 1
	else if ( aVal > bVal )
		return -1

	            
	aVal = a.GetPlayerGameStat( PGS_DEATHS )
	bVal = b.GetPlayerGameStat( PGS_DEATHS )

	if ( aVal < bVal )
		return -1
	else if ( aVal > bVal )
		return 1

	return 0
}


int function CompareScavenger( entity a, entity b )
{
	                  
	int result = CompareAssault( a, b )
	if ( result != 0 )
		return result

	                 
	int aVal = a.GetPlayerGameStat( PGS_KILLS )
	int bVal = b.GetPlayerGameStat( PGS_KILLS )

	if ( aVal < bVal )
		return 1
	else if ( aVal > bVal )
		return -1

	                 
	aVal = a.GetPlayerGameStat( PGS_TITAN_KILLS )
	bVal = b.GetPlayerGameStat( PGS_TITAN_KILLS )

	if ( aVal < bVal )
		return 1
	else if ( aVal > bVal )
		return -1

	            
	aVal = a.GetPlayerGameStat( PGS_DEATHS )
	bVal = b.GetPlayerGameStat( PGS_DEATHS )

	if ( aVal < bVal )
		return -1
	else if ( aVal > bVal )
		return 1

	return 0
}


int function CompareFW( entity a, entity b )
{
	                                                                                               

	{
		int aVal = a.GetPlayerGameStat( PGS_ASSAULT_SCORE )
		int bVal = b.GetPlayerGameStat( PGS_ASSAULT_SCORE )

		aVal += a.GetPlayerGameStat( PGS_DEFENSE_SCORE )
		bVal += b.GetPlayerGameStat( PGS_DEFENSE_SCORE )

		if ( aVal < bVal )
			return 1
		else if ( aVal > bVal )
			return -1
	}

	                 
	{
		int aVal = a.GetPlayerGameStat( PGS_KILLS )
		int bVal = b.GetPlayerGameStat( PGS_KILLS )

		if ( aVal < bVal )
			return 1
		else if ( aVal > bVal )
			return -1
	}

	                 
	{
		int aVal = a.GetPlayerGameStat( PGS_TITAN_KILLS )
		int bVal = b.GetPlayerGameStat( PGS_TITAN_KILLS )

		if ( aVal < bVal )
			return 1
		else if ( aVal > bVal )
			return -1
	}

	            
	{
		int aVal = a.GetPlayerGameStat( PGS_DEATHS )
		int bVal = b.GetPlayerGameStat( PGS_DEATHS )

		if ( aVal < bVal )
			return -1
		else if ( aVal > bVal )
			return 1
	}

	return 0
}


int function CompareHunter( entity a, entity b )
{
	                                                                                               

	{
		int aVal = a.GetPlayerGameStat( PGS_ASSAULT_SCORE )
		int bVal = b.GetPlayerGameStat( PGS_ASSAULT_SCORE )

		aVal += a.GetPlayerGameStat( PGS_DEFENSE_SCORE )
		bVal += b.GetPlayerGameStat( PGS_DEFENSE_SCORE )

		if ( aVal < bVal )
			return 1
		else if ( aVal > bVal )
			return -1
	}

	                 
	{
		int aVal = a.GetPlayerGameStat( PGS_KILLS )
		int bVal = b.GetPlayerGameStat( PGS_KILLS )

		if ( aVal < bVal )
			return 1
		else if ( aVal > bVal )
			return -1
	}

	                 
	{
		int aVal = a.GetPlayerGameStat( PGS_TITAN_KILLS )
		int bVal = b.GetPlayerGameStat( PGS_TITAN_KILLS )

		if ( aVal < bVal )
			return 1
		else if ( aVal > bVal )
			return -1
	}

	            
	{
		int aVal = a.GetPlayerGameStat( PGS_DEATHS )
		int bVal = b.GetPlayerGameStat( PGS_DEATHS )

		if ( aVal < bVal )
			return -1
		else if ( aVal > bVal )
			return 1
	}

	return 0
}

                                       
int function ScoreCompare_Freelance( entity a, entity b )
{
	int aVal = a.GetPlayerGameStat( PGS_KILLS )
	int bVal = b.GetPlayerGameStat( PGS_KILLS )

	if ( aVal < bVal )
		return 1
	else if ( aVal > bVal )
		return -1

	aVal = a.GetPlayerGameStat( PGS_DEATHS )
	bVal = b.GetPlayerGameStat( PGS_DEATHS )

	if ( aVal > bVal )
		return 1
	else if ( aVal < bVal )
		return -1

	aVal = a.GetPlayerGameStat( PGS_SCORE )
	bVal = b.GetPlayerGameStat( PGS_SCORE )

	if ( aVal < bVal )
		return 1
	else if ( aVal > bVal )
		return -1

	return 0
}

int function CompareFD( entity a, entity b )
{
	int aVal = a.GetPlayerGameStat( PGS_DETONATION_SCORE )
	int bVal = b.GetPlayerGameStat( PGS_DETONATION_SCORE )

	if ( aVal < bVal )
		return 1
	else if ( aVal > bVal )
		return -1

	return 0
}


int function CompareTitanKills( entity a, entity b )
{
	int aVal = a.GetPlayerGameStat( PGS_TITAN_KILLS )
	int bVal = b.GetPlayerGameStat( PGS_TITAN_KILLS )

	if ( aVal < bVal )
		return 1
	else if ( aVal > bVal )
		return -1

	return 0
}
#endif                     


int function CompareTeamScore( int teamA, int teamB )
{
	int aVal = GameRules_GetTeamScore( teamA )
	int bVal = GameRules_GetTeamScore( teamB )
                          
                       
   
                                          
                                          
   
       

	if ( aVal < bVal )
		return 1
	else if ( aVal > bVal )
		return -1

	                                                                   
	if ( teamA < teamB )
		return 1
	else
		return -1

	return 0
}


bool function IsHitEffectiveVsNonTitan( entity victim, int damageType )
{
	if ( damageType & DF_BULLET || damageType & DF_MAX_RANGE )
		return false

	return true
}


bool function IsPilot( entity ent )
{
	if ( !IsValid( ent ) )
		return false

	if ( !ent.IsPlayer() )
		return false

	if ( ent.IsTitan() )
		return false

	return true
}


array<entity> function ArrayWithin( array<entity> Array, vector origin, float maxDist )
{
	float maxDistSqr = maxDist * maxDist

	array<entity> resultArray = []
	foreach ( ent in Array )
	{
		float distSqr = DistanceSqr( origin, ent.GetOrigin() )
		if ( distSqr <= maxDistSqr )
			resultArray.append( ent )
	}
	return resultArray
}


array<vector> function VectorArrayWithin( array<vector> Array, vector origin, float maxDist )
{
	float maxDistSqr = maxDist * maxDist

	array<vector> resultArray = []
	foreach ( vector p in Array )
	{
		float distSqr = DistanceSqr( origin, p )
		if ( distSqr <= maxDistSqr )
			resultArray.append( p )
	}
	return resultArray
}


vector function ClampVectorToCube( vector vecStart, vector vec, vector cubeOrigin, float cubeSize )
{
	float halfCubeSize = cubeSize * 0.5
	vector cubeMins    = <-halfCubeSize, -halfCubeSize, -halfCubeSize>
	vector cubeMaxs    = <halfCubeSize, halfCubeSize, halfCubeSize>

	return ClampVectorToBox( vecStart, vec, cubeOrigin, cubeMins, cubeMaxs )
}


vector function ClampVectorToBox( vector vecStart, vector vec, vector cubeOrigin, vector cubeMins, vector cubeMaxs )
{
	float smallestClampScale = 1.0
	vector vecEnd            = vecStart + vec

	smallestClampScale = ClampVectorComponentToCubeMax( cubeOrigin.x, cubeMaxs.x, vecStart.x, vecEnd.x, vec.x, smallestClampScale )
	smallestClampScale = ClampVectorComponentToCubeMax( cubeOrigin.y, cubeMaxs.y, vecStart.y, vecEnd.y, vec.y, smallestClampScale )
	smallestClampScale = ClampVectorComponentToCubeMax( cubeOrigin.z, cubeMaxs.z, vecStart.z, vecEnd.z, vec.z, smallestClampScale )
	smallestClampScale = ClampVectorComponentToCubeMin( cubeOrigin.x, cubeMins.x, vecStart.x, vecEnd.x, vec.x, smallestClampScale )
	smallestClampScale = ClampVectorComponentToCubeMin( cubeOrigin.y, cubeMins.y, vecStart.y, vecEnd.y, vec.y, smallestClampScale )
	smallestClampScale = ClampVectorComponentToCubeMin( cubeOrigin.z, cubeMins.z, vecStart.z, vecEnd.z, vec.z, smallestClampScale )

	return vec * smallestClampScale
}


vector function ClampAnglesToAngles( vector angles, vector anglesMin, vector anglesMax )
{
	vector clampedAngles = <0, 0, 0>

	clampedAngles.x = GraphCapped( angles.x, anglesMin.x, anglesMax.x, anglesMin.x, anglesMax.x )
	clampedAngles.y = GraphCapped( angles.y, anglesMin.y, anglesMax.y, anglesMin.y, anglesMax.y )
	clampedAngles.z = GraphCapped( angles.z, anglesMin.z, anglesMax.z, anglesMin.z, anglesMax.z )

	return clampedAngles
}


float function ClampVectorComponentToCubeMax( float cubeOrigin, float cubeSize, float vecStart, float vecEnd, float vec, float smallestClampScale )
{
	float max       = cubeOrigin + cubeSize
	float clearance = fabs( vecStart - max )
	if ( vecEnd > max )
	{
		float scale = fabs( clearance / ((vecStart + vec) - vecStart) )
		if ( scale > 0 && scale < smallestClampScale )
			return scale
	}

	return smallestClampScale
}


float function ClampVectorComponentToCubeMin( float cubeOrigin, float cubeSize, float vecStart, float vecEnd, float vec, float smallestClampScale )
{
	float min       = cubeOrigin - cubeSize
	float clearance = fabs( min - vecStart )
	if ( vecEnd < min )
	{
		float scale = fabs( clearance / ((vecStart + vec) - vecStart) )
		if ( scale > 0 && scale < smallestClampScale )
			return scale
	}

	return smallestClampScale
}


bool function PointInCapsule( vector vecBottom, vector vecTop, float radius, vector point )
{
	return GetDistanceFromLineSegment( vecBottom, vecTop, point ) <= radius
}


bool function PointInCylinder( vector vecBottom, vector vecTop, float radius, vector point )
{
	if ( GetDistanceFromLineSegment( vecBottom, vecTop, point ) > radius )
		return false

	vector bottomVec     = Normalize( vecTop - vecBottom )
	vector pointToBottom = Normalize( point - vecBottom )

	vector topVec     = Normalize( vecBottom - vecTop )
	vector pointToTop = Normalize( point - vecTop )

	if ( DotProduct( bottomVec, pointToBottom ) < 0 )
		return false

	if ( DotProduct( topVec, pointToTop ) < 0.0 )
		return false

	return true
}


float function AngleDiff( float ang, float targetAng )
{
	float delta = (targetAng - ang) % 360.0
	if ( targetAng > ang )
	{
		if ( delta >= 180.0 )
			delta -= 360.0
	}
	else
	{
		if ( delta <= -180.0 )
			delta += 360.0
	}
	return delta
}


float function ClampAngle( float ang )
{
	while ( ang > 360 )
		ang -= 360
	while ( ang < 0 )
		ang += 360
	return ang
}


float function ClampAngle180( float ang )
{
	while ( ang > 180 )
		ang -= 180
	while ( ang < -180 )
		ang += 180
	return ang
}


vector function ClampAngles( vector ang )
{
	vector clampedAngles = < ClampAngle( ang.x ), ClampAngle( ang.y ), ClampAngle( ang.z ) >
	return clampedAngles
}


vector function ShortestRotation( vector ang, vector targetAng )
{
	return <AngleDiff( ang.x, targetAng.x ), AngleDiff( ang.y, targetAng.y ), AngleDiff( ang.z, targetAng.z )>
}


vector function GetAverageOriginOfEnts( array<entity> ents )
{
	Assert( ents.len() > 0, "Can not get average origin of empty ent array." )
	vector averageOrigin = <0, 0, 0>
	int originCount      = 0

	foreach ( entity ent in ents )
	{
		averageOrigin += ent.GetOrigin()
		originCount++
	}

	return (averageOrigin / originCount)
}


float function GetAverageValueInArray( array<float> values )
{
	Assert( values.len() > 0, "Can not get average of empty float array" )
	float sum
	foreach ( float value in values )
		sum += value
	return (sum / values.len())
}


int function GetWinningTeam()
{
	int currentWinningTeam = GetNetWinningTeam()
	if ( currentWinningTeam != -1 )
		return currentWinningTeam

	int maxScore    = 0
	int playerTeam
	int currentScore
	int winningTeam = TEAM_UNASSIGNED

	foreach ( player in GetPlayerArray() )
	{
		playerTeam = player.GetTeam()
		if ( IsRoundBased() )
			currentScore = GameRules_GetTeamScore2( playerTeam )
		else
			currentScore = GameRules_GetTeamScore( playerTeam )

		if ( currentScore == maxScore )                                                                   
			winningTeam = TEAM_UNASSIGNED

		if ( currentScore > maxScore )
		{
			maxScore = currentScore
			winningTeam = playerTeam
		}
	}

	return winningTeam
}


void function EmitSkyboxSoundAtPosition( vector positionInSkybox, string sound, float skyboxScale = 0.001, bool clamp = false )
{
	if ( IsServer() )
		clamp = true                                                  
	vector position = SkyboxToWorldPosition( positionInSkybox, skyboxScale, clamp )
	EmitSoundAtPosition( TEAM_UNASSIGNED, position, sound )
}


vector function SkyboxToWorldPosition( vector positionInSkybox, float skyboxScale = 0.001, bool clamp = true )
{
	Assert( skyboxScale > 0 )
	Assert( "skyboxCamOrigin" in level )

	vector position  = <0, 0, 0>
	vector skyOrigin = expect vector( level.skyboxCamOrigin )

	#if CLIENT
		position = (positionInSkybox - skyOrigin) * (1.0 / skyboxScale)

		if ( clamp )
		{
			entity localViewPlayer = GetLocalViewPlayer()
			Assert( localViewPlayer )
			vector localViewPlayerOrg = localViewPlayer.GetOrigin()

			position = localViewPlayerOrg + ClampVectorToCube( localViewPlayerOrg, position - localViewPlayerOrg, <0, 0, 0>, 32000.0 )
		}
	#else
		position = (positionInSkybox - skyOrigin) * (1.0 / skyboxScale)

		if ( clamp )
			position = ClampVectorToCube( <0, 0, 0>, position, <0, 0, 0>, 32000.0 )
	#endif          

	return position
}


void function FadeOutSoundOnEntityAfterDelay( entity ent, string soundAlias, float delay, float fadeTime )
{
	if ( !IsValid( ent ) )
		return

	ent.EndSignal( "OnDestroy" )
	wait delay
	FadeOutSoundOnEntity( ent, soundAlias, fadeTime )
}

                                                       
 
	                       
	                               
	 
		                    
	 

	                                              

	                               
	 
		                                                                      
			           
		                    
	 
   

float function GetGameEndTime()
{
	return GetGlobalNonRewindNetTime( "gameEndTime" )
}


float function GetGameStartTime()
{
	return GetGlobalNonRewindNetTime( "gameStartTime" )
}


float function GetRoundStartTime()
{
	return GetGlobalNonRewindNetTime( "roundStartTime" )
}


float function GetRoundEndTime()
{
	return GetGlobalNonRewindNetTime( "roundEndTime" )
}


bool function GetForcedDialogueOnly()
{
	return GetGlobalNonRewindNetBool( "forcedDialogueOnly" )
}


bool function IsMatchOver()
{
	float gameEndTime = GetGameEndTime()
	if ( IsRoundBased() && gameEndTime > 0.0 )
		return true
	else if ( !IsRoundBased() && gameEndTime > 0.0 && Time() > gameEndTime )
		return true

	return false
}


bool function IsRoundBased()
{
	return GetGlobalNonRewindNetBool( "roundBased" )
}

bool function IsLootRoundBased()
{
                        
	if ( ShGameModeExplore_IsActive() )
		return true
      
	return IsRoundBased()
}


int function GetRoundsPlayed()
{
	return GetGlobalNonRewindNetInt( "roundsPlayed" )
}


int function GetNetWinningTeam()
                                                  
{
	return GetGlobalNonRewindNetInt( "winningTeam" )
}


bool function IsEliminationBased()
{
	return GetCurrentPlaylistVarBool( "is_elimination_based", true )
}


bool function IsPilotEliminationBased()
{
	return true
}


void function __WarpInEffectShared( vector origin, vector angles, string sfx, float preWaitOverride = -1.0, entity ornull vehicle = null )
{
	float preWait   = 2.0
	float sfxWait   = 0.1
	float totalTime = WARPINFXTIME

	if ( sfx == "" )
		sfx = "dropship_warpin"

	if ( preWaitOverride >= 0.0 )
		wait preWaitOverride
	else
		wait preWait                                                                                                                                   

	#if CLIENT
		int fxIndex = GetParticleSystemIndex( FX_GUNSHIP_CRASH_EXPLOSION_ENTRANCE )
		StartParticleEffectInWorld( fxIndex, origin, angles )
	#else
		entity fx = PlayFX( FX_GUNSHIP_CRASH_EXPLOSION_ENTRANCE, origin, angles )
		fx.FXEnableRenderAlways()
		fx.DisableHibernation()
		if ( IsValid( vehicle ) )
		{
			fx.RemoveFromAllRealms()
			fx.AddToOtherEntitysRealms( expect entity ( vehicle ) )
		}
	#endif          

	wait sfxWait
	EmitSoundAtPosition( TEAM_UNASSIGNED, origin, sfx )

	wait totalTime - preWait - sfxWait
}


void function __WarpOutEffectShared( entity dropship )
{
	int attach    = dropship.LookupAttachment( "origin" )
	vector origin = dropship.GetAttachmentOrigin( attach )
	vector angles = dropship.GetAttachmentAngles( attach )

	#if CLIENT
		int fxIndex = GetParticleSystemIndex( FX_GUNSHIP_CRASH_EXPLOSION_EXIT )
		StartParticleEffectInWorld( fxIndex, origin, angles )
	#else
		entity fx = PlayFX( FX_GUNSHIP_CRASH_EXPLOSION_EXIT, origin, angles )
		fx.FXEnableRenderAlways()
		fx.DisableHibernation()
		if ( IsValid( dropship ) )
		{
			fx.RemoveFromAllRealms()
			fx.AddToOtherEntitysRealms( dropship )
		}
	#endif

	EmitSoundAtPosition( TEAM_UNASSIGNED, origin, "dropship_warpout" )
}


int function GetSwitchedSides()
{
	return GetGlobalNonRewindNetInt( "switchedSides" )
}


bool function IsSwitchSidesBased()
{
	return GetSwitchedSides() != -1
}


int function HasSwitchedSides()
                                                       
{
	return GetSwitchedSides()
}


bool function IsFirstRoundAfterSwitchingSides()
{
	if ( !IsSwitchSidesBased() )
		return false

	int switchedSide = GetSwitchedSides()

	if ( IsRoundBased() )
		return  switchedSide > 0 && GetRoundsPlayed() == switchedSide
	else
		return  switchedSide > 0

	unreachable
}


void function CamBlendFov( entity cam, float oldFov, float newFov, float transTime, float transAccel, float transDecel )
{
	if ( !IsValid( cam ) )
		return

	cam.EndSignal( "OnDestroy" )

	float currentTime = Time()
	float startTime   = currentTime
	float endTime     = startTime + transTime

	while ( endTime > currentTime )
	{
		float interp = Interpolate( startTime, endTime - startTime, transAccel, transDecel )
		cam.SetFOV( GraphCapped( interp, 0.0, 1.0, oldFov, newFov ) )
		wait(0.0)
		currentTime = Time()
	}
}


void function CamFollowEnt( entity cam, entity ent, float duration, vector offset = <0, 0, 0>, string attachment = "", bool isInSkybox = false )
{
	if ( !IsValid( cam ) )
		return

	cam.EndSignal( "OnDestroy" )

	vector camOrg = <0, 0, 0>

	vector targetPos  = <0, 0, 0>
	float currentTime = Time()
	float startTime   = currentTime
	float endTime     = startTime + duration
	vector diff       = <0, 0, 0>
	int attachID      = ent.LookupAttachment( attachment )

	while ( endTime > currentTime )
	{
		camOrg = cam.GetOrigin()

		if ( attachID <= 0 )
			targetPos = ent.GetOrigin()
		else
			targetPos = ent.GetAttachmentOrigin( attachID )

		if ( isInSkybox )
			targetPos = SkyboxToWorldPosition( targetPos )
		diff = (targetPos + offset) - camOrg

		cam.SetAngles( VectorToAngles( diff ) )

		wait(0.0)

		currentTime = Time()
	}
}


void function CamFacePos( entity cam, vector pos, float duration )
{
	if ( !IsValid( cam ) )
		return

	cam.EndSignal( "OnDestroy" )

	float currentTime = Time()
	float startTime   = currentTime
	float endTime     = startTime + duration
	vector diff       = <0, 0, 0>

	while ( endTime > currentTime )
	{
		diff = pos - cam.GetOrigin()

		cam.SetAngles( VectorToAngles( diff ) )

		wait(0.0)

		currentTime = Time()
	}
}


void function CamBlendFromFollowToAng( entity cam, entity ent, vector endAng, float transTime, float transAccel, float transDecel )
{
	if ( !IsValid( cam ) )
		return

	cam.EndSignal( "OnDestroy" )

	vector camOrg = cam.GetOrigin()

	float currentTime = Time()
	float startTime   = currentTime
	float endTime     = startTime + transTime

	while ( endTime > currentTime )
	{
		vector diff        = ent.GetOrigin() - camOrg
		vector anglesToEnt = VectorToAngles( diff )

		float frac = Interpolate( startTime, endTime - startTime, transAccel, transDecel )

		vector newAngs = anglesToEnt + ShortestRotation( anglesToEnt, endAng ) * frac

		cam.SetAngles( newAngs )

		wait(0.0)

		currentTime = Time()
	}
}


void function CamBlendFromPosToPos( entity cam, vector startPos, vector endPos, float transTime, float transAccel, float transDecel )
{
	if ( !IsValid( cam ) )
		return

	cam.EndSignal( "OnDestroy" )

	float currentTime = Time()
	float startTime   = currentTime
	float endTime     = startTime + transTime
	vector diff       = endPos - startPos

	while ( endTime > currentTime )
	{
		float frac = Interpolate( startTime, endTime - startTime, transAccel, transDecel )

		vector newAngs = startPos + diff * frac

		cam.SetOrigin( newAngs )

		wait(0.0)

		currentTime = Time()
	}
}


void function CamBlendFromAngToAng( entity cam, vector startAng, vector endAng, float transTime, float transAccel, float transDecel )
{
	if ( !IsValid( cam ) )
		return

	cam.EndSignal( "OnDestroy" )

	float currentTime = Time()
	float startTime   = currentTime
	float endTime     = startTime + transTime

	while ( endTime > currentTime )
	{
		float frac = Interpolate( startTime, endTime - startTime, transAccel, transDecel )

		vector newAngs = startAng + ShortestRotation( startAng, endAng ) * frac

		cam.SetAngles( newAngs )

		wait(0.0)

		currentTime = Time()
	}
}


int function AddBitMask( int bitsExisting, int bitsToAdd )
{
	return bitsExisting | bitsToAdd
}


int function RemoveBitMask( int bitsExisting, int bitsToRemove )
{
	return bitsExisting & (~bitsToRemove)
}


bool function HasBitMask( int bitsExisting, int bitsToCheck )
{
	int bitsCommon = bitsExisting & bitsToCheck
	return bitsCommon == bitsToCheck
}


void function SetDeathCamTimeOverride( float functionref() func )
{
	file.getDeathCamTimeOverride = func
}

float function GetDeathCamLength( entity player )
{
	if ( file.getDeathCamTimeOverride != null )
		return file.getDeathCamTimeOverride()

	                                                       
	if ( GetGameState() < eGameState.Playing )
		return DEATHCAM_TIME_SHORT

	return DEATHCAM_TIME
}

void function SetDeathCamSpectateTimeOverride( float functionref() func )
{
	file.getDeathCamSpectateTimeOverride = func
}

float function GetDeathCamSpectateLength()
{
	if ( file.getDeathCamSpectateTimeOverride != null )
		return file.getDeathCamSpectateTimeOverride()

	return 0
}

float function GetRespawnButtonCamTime( entity player )
{
	const float RESPAWN_BUTTON_BUFFER = 0.0
	return DEATHCAM_TIME + RESPAWN_BUTTON_BUFFER
}


float function GetKillReplayAfterTime( entity player )
{
	if ( !GamePlayingOrSuddenDeath() )
		return KILL_REPLAY_AFTER_KILL_TIME_SHORT

	return KILL_REPLAY_AFTER_KILL_TIME
}


bool function IntroPreviewOn()
{
	int bugnum = GetBugReproNum()
	switch ( bugnum )
	{
		case 1337:
		case 13371:
		case 13372:
		case 13373:
		case 1338:
		case 13381:
		case 13382:
		case 13383:
			return true
	}

	return false
}


bool function EntHasModelSet( entity ent )
{
	asset modelName = ent.GetModelName()

	if ( modelName == $"" || modelName == $"?" )
		return false

	return true
}

#if SERVER
                                                                                                                    
 
	                            
	                                                 
 
#endif


void function AddCallback_OnUseEntity_ClientServer( entity ent, void functionref( entity, entity, int ) callbackFunc )
{
	ent.e.onUseEntityCallbacks.append( callbackFunc )
}


void function RemoveCallback_OnUseEntity( entity ent, void functionref( entity, entity, int ) callbackFunc )
{
	int ornull funcPos = ent.e.onUseEntityCallbacks.find( callbackFunc )
	Assert( funcPos != null, "Cannot remove " + string( callbackFunc ) + " that was not added to entity" )
	ent.e.onUseEntityCallbacks.remove( expect int( funcPos ) )
	#if SERVER
		                           
	#endif
}


bool function IsFragDrone( entity npc )
{
	return npc.GetNetworkedClassName() == "npc_frag_drone"
}


bool function IsVortexSphere( entity ent )
{
	return ent.GetNetworkedClassName() == "vortex_sphere"
}


bool function IsPlayerWaypoint( entity ent )
{
	return ent.GetNetworkedClassName() == "player_waypoint"
}


bool function PointIsWithinBounds( vector point, vector mins, vector maxs )
{
	Assert( mins.x < maxs.x )
	Assert( mins.y < maxs.y )
	Assert( mins.z < maxs.z )

	return ((point.z >= mins.z && point.z <= maxs.z) &&
	(point.x >= mins.x && point.x <= maxs.x) &&
	(point.y >= mins.y && point.y <= maxs.y))
}


vector ornull function IntersectRayAABB( vector rayStartIn, vector rayDirIn, vector minsIn, vector maxsIn )
{
	float[3] rayStart
	rayStart[0] = rayStartIn.x
	rayStart[1] = rayStartIn.y
	rayStart[2] = rayStartIn.z
	float[3] rayDir
	rayDir[0] = rayDirIn.x
	rayDir[1] = rayDirIn.y
	rayDir[2] = rayDirIn.z
	float[3] mins
	mins[0] = minsIn.x
	mins[1] = minsIn.y
	mins[2] = minsIn.z
	float[3] maxs
	maxs[0] = maxsIn.x
	maxs[1] = maxsIn.y
	maxs[2] = maxsIn.z

	float[3] hit
	bool inside = true
	float[3] quadrant
	float[3] candidatePlane
	float[3] maxT
	for ( int dim = 0; dim < 3; dim ++ )
	{
		if ( rayStart[dim] < mins[dim] )
		{
			quadrant[dim] = -1
			candidatePlane[dim] = mins[dim]
			inside = false
		}
		else if ( rayStart[dim] > maxs[dim] )
		{
			quadrant[dim] = 1
			candidatePlane[dim] = maxs[dim]
			inside = false
		}
		else
		{
			quadrant[dim] = 0
		}
	}

	if ( inside )
	{
		return rayStartIn
	}

	for ( int dim = 0; dim < 3; dim ++ )
	{
		if ( quadrant[dim] != 0 && (rayDir[dim] < -0.00001 || rayDir[dim] > 0.00001) )
		{
			maxT[dim] = (candidatePlane[dim] - rayStart[dim]) / rayDir[dim]
		}
		else
		{
			maxT[dim] = -1.0
		}
	}

	int whichPlane = 0
	for ( int dim = 0; dim < 3; dim ++ )
	{
		if ( maxT[whichPlane] < maxT[dim] )
			whichPlane = dim
	}

	if ( maxT[whichPlane] < 0.0 )
		return null

	for ( int dim = 0; dim < 3; dim ++ )
	{
		if ( whichPlane != dim )
		{
			hit[dim] = rayStart[dim] + maxT[whichPlane] * rayDir[dim]
			if ( hit[dim] < mins[dim] || hit[dim] > maxs[dim] )
				return null
		}
		else
		{
			hit[dim] = candidatePlane[dim]
		}
	}
	return <hit[0], hit[1], hit[2]>
}


int function GetSpStartIndex()
{
	                                                                          
	int index = GetBugReproNum()

	if ( index < 0 )
		return 0

	return index
}

                             
array<entity> function GetAllSoldiers()
{
	return GetNPCArrayByClass( "npc_soldier" )
}


int function GameTeams_GetNumLivingPlayers( int teamIndex = TEAM_ANY )
{
	int noOfLivingPlayers = 0

	array<entity> players
	if ( teamIndex == TEAM_ANY )
		players = GetPlayerArray()
	else
		players = GetPlayerArrayOfTeam( teamIndex )

	foreach ( player in players )
	{
		if ( !IsAlive( player ) )
			continue

		++noOfLivingPlayers
	}

	return noOfLivingPlayers
}


bool function GameTeams_TeamHasDeadPlayers( int team )
{
	array<entity> teamPlayers = GetPlayerArrayOfTeam( team )
	foreach ( entity teamPlayer in teamPlayers )
	{
		if ( !IsAlive( teamPlayer ) )
			return true
	}
	return false
}

typedef EntitiesDidLoadCallbackType void functionref()
array<EntitiesDidLoadCallbackType> _EntitiesDidLoadTypedCallbacks

void function RunCallbacks_EntitiesDidLoad()
{
	                                            
	if ( "forcedReloading" in level )
		return

	foreach ( callback in _EntitiesDidLoadTypedCallbacks )
	{
		thread callback()
	}
}


void function AddCallback_EntitiesDidLoad( EntitiesDidLoadCallbackType callback )
{
	_EntitiesDidLoadTypedCallbacks.append( callback )
}

void function AddCallback_GetNumTeamsRemaining( int functionref() callbackFunc )
{
	file.getNumTeamsRemainingCallback = callbackFunc
}

bool function IsTitanNPC( entity ent )
{
	return ent.IsTitan() && ent.IsNPC()
}


entity function InflictorOwner( entity inflictor )
{
	if ( IsValid( inflictor ) )
	{
		entity inflictorOwner = inflictor.GetOwner()
		if ( IsValid( inflictorOwner ) )
			inflictor = inflictorOwner
	}

	return inflictor
}


bool function IsPlayerControlledSpectre( entity ent )
{
	return ent.GetNetworkedClassName() == "npc_spectre" && ent.GetBossPlayer() != null
}


bool function IsPlayerControlledTurret( entity ent )
{
	return IsTurret( ent ) && ent.GetBossPlayer() != null
}


bool function TitanShieldDecayEnabled()
{
	return (GetCurrentPlaylistVarInt( "titan_shield_decay", 0 ) == 1)
}


bool function TitanShieldRegenEnabled()
{
	return (GetCurrentPlaylistVarInt( "titan_shield_regen", 1 ) == 1)
}


bool function DoomStateDisabled()
{
	return (GetCurrentPlaylistVarString( "titan_doomstate_variation", "default" ) == "disabled" || GetCurrentPlaylistVarString( "titan_doomstate_variation", "default" ) == "lastsegment")
}


bool function NoWeaponDoomState()
{
	return (GetCurrentPlaylistVarString( "titan_doomstate_variation", "default" ) == "noweapon")
}


entity function GetPetTitanOwner( entity titan )
{
	array<entity> players = GetPlayerArray()
	entity foundPlayer
	foreach ( player in players )
	{
		if ( player.GetPetTitan() == titan )
		{
			Assert( foundPlayer == null, player + " and " + foundPlayer + " both own " + titan )
			foundPlayer = player
		}
	}

	return foundPlayer
}


entity function GetSoulFromPlayer( entity player )
{
	return null
}


string function GetPlayerBodyType( entity player )
{
	return player.GetPlayerSettingString( "weaponClass" )
}


string function GetPlayerVoice( entity player )
{
	return player.GetPlayerSettingString( "voice" )
}


void function SetTeam( entity ent, int team )
{
	#if CLIENT
		ent.Code_SetTeam( team )
	#else
		if ( ent.IsPlayer() )
		{
			ent.Code_SetTeam( team )
			SetTeam_EquipmentAndAbilities( ent, team )
		}
		else if ( ent.IsNPC() )
		{
			int currentTeam               = ent.GetTeam()
			bool alreadyAssignedValidTeam = (currentTeam == TEAM_IMC || currentTeam == TEAM_MILITIA)

			ent.Code_SetTeam( team )

			if ( ent.GetModelName() == $"" )
				return

			if ( IsGrunt( ent ) || IsSpectre( ent ) )
			{
				int eHandle = ent.GetEncodedEHandle()

				array<entity> players = GetPlayerArray()
				foreach ( player in players )
				{
					Remote_CallFunction_Replay( player, "ServerCallback_UpdateOverheadIconForNPC", eHandle )
				}
			}
			else if ( IsShieldDrone( ent ) )
			{
				if ( team == 0 )
				{
					                                       
					ent.SetUsable()
				}
				else
				{
					                                          
					ent.SetUsableByGroup( "friendlies pilot" )
				}
			}
		}
		else
		{
			ent.Code_SetTeam( team )
		}
	#endif
}


void function SetAllPlayersToTeam( int teamNum = 5 )
{
	array< entity > allPlayers = GetPlayerArray()
	foreach( player in allPlayers )
	{
		if( IsValid( player ) )
			SetTeam( player, teamNum )
	}
}

void function SetPlayersToTeam( int minNdx, int maxNdx, int teamNum = 5 )
{
	Assert( minNdx <= maxNdx, format( "ERROR: %s(): minNdx needs to be <= maxNdx." ))

	array< entity > allPlayers = GetPlayerArray()

	Assert( minNdx <= allPlayers.len(), format( "ERROR: %s(): minNdx needs to be <= # of all players." ))

	for( int i = minNdx; i <= maxNdx; i++ )
	{
		if( IsValid( allPlayers[i] ) )
			SetTeam( allPlayers[i], teamNum )
	}
}


void function PrintTraceResults( TraceResults results )
{
	printt( "TraceResults: " )
	printt( "=========================" )
	printt( "hitEnt: " + results.hitEnt )
	printt( "endPos: " + results.endPos )
	printt( "surfaceNormal: " + results.surfaceNormal )
	printt( "surfaceName: " + results.surfaceName )
	printt( "fraction: " + results.fraction )
	printt( "fractionLeftSolid: " + results.fractionLeftSolid )
	printt( "hitGroup: " + results.hitGroup )
	printt( "startSolid: " + results.startSolid )
	printt( "allSolid: " + results.allSolid )
	printt( "hitSky: " + results.hitSky )
	printt( "contents: " + results.contents )
	printt( "=========================" )
}


bool function PROTO_AlternateDoomedState()
{
	return (GetCurrentPlaylistVarInt( "infinite_doomed_state", 1 ) == 1)
}


bool function PROTO_VariableRegenDelay()
{
	return (GetCurrentPlaylistVarInt( "variable_regen_delay", 1 ) == 1)
}


bool function TitanDamageRewardsTitanCoreTime()
{
	if ( GetCurrentPlaylistVarInt( "titan_core_from_titan_damage", 1 ) != 0 )
		return true
	return false
}


vector function ClampToMap( vector pos )
{
	return IterateAxis( pos, LimitAxisToMapExtents )
}


vector function IterateAxis( vector pos, float functionref( float ) func )
{
	pos.x = func( pos.x )
	pos.y = func( pos.y )
	pos.z = func( pos.z )
	return pos
}


float function LimitAxisToMapExtents( float axisVal )
{
	if ( axisVal >= MAP_EXTENTS )
		axisVal = MAP_EXTENTS - 1
	else if ( axisVal <= -MAP_EXTENTS )
		axisVal = -(MAP_EXTENTS - 1)
	return axisVal
}


bool function PilotSpawnOntoTitanIsEnabledInPlaylist( entity player )
{
	if ( GetCurrentPlaylistVarInt( "titan_spawn_deploy_enabled", 0 ) != 0 )
		return true
	return false
}


bool function PlayerCanSpawnIntoTitan( entity player )
{
	if ( !PilotSpawnOntoTitanIsEnabledInPlaylist( player ) )
		return false

	entity titan = player.GetPetTitan()

	if ( !IsAlive( titan ) )
		return false

	if ( GetDoomedState( titan ) )
		return false

	if ( titan.ContextAction_IsActive() )
		return false

	return false                                                   
}


array<vector> function EntitiesToOrigins( array<entity> ents )
{
	array<vector> origins

	foreach ( ent in ents )
	{
		origins.append( ent.GetOrigin() )
	}

	return origins
}


vector function GetMedianOriginOfEntities( array<entity> ents )
{
	array<vector> origins = EntitiesToOrigins( ents )
	return GetMedianOrigin( origins )
}


vector function GetMedianOrigin( array<vector> origins )
{
	if ( origins.len() == 1 )
		return origins[0]

	vector median

	int middleIndex1
	int middleIndex2

	if ( IsEven( origins.len() ) )
	{
		middleIndex1 = origins.len() / 2
		middleIndex2 = middleIndex1
	}
	else
	{
		middleIndex1 = int( floor( origins.len() / 2.0 ) )
		middleIndex2 = middleIndex1 + 1
	}

	origins.sort( CompareVecX )
	median.x = (origins[ middleIndex1 ].x + origins[ middleIndex2 ].x) / 2.0

	origins.sort( CompareVecY )
	median.y = (origins[ middleIndex1 ].y + origins[ middleIndex2 ].y) / 2.0

	origins.sort( CompareVecZ )
	median.z = (origins[ middleIndex1 ].z + origins[ middleIndex2 ].z) / 2.0

	return median
}


int function CompareVecX( vector a, vector b )
{
	if ( a.x > b.x )
		return 1

	return -1
}


int function CompareVecY( vector a, vector b )
{
	if ( a.y > b.y )
		return 1

	return -1
}


int function CompareVecZ( vector a, vector b )
{
	if ( a.z > b.z )
		return 1

	return -1
}


float function GetFractionAlongPath( array<entity> nodes, vector p )
{
	float totalDistance = GetPathDistance( nodes )

	                                                     
	int closestSegment = -1
	float closestDist  = 9999
	for ( int i = 0; i < nodes.len() - 1; i++ )
	{
		float dist = GetDistanceSqrFromLineSegment( nodes[i].GetOrigin(), nodes[i + 1].GetOrigin(), p )
		if ( closestSegment < 0 || dist < closestDist )
		{
			closestSegment = i
			closestDist = dist
		}
	}
	Assert( closestSegment >= 0 )
	Assert( closestSegment < nodes.len() - 1 )

	                                                   
	float distTraveled = 0.0
	for ( int i = 0; i < closestSegment; i++ )
	{
		                                                                                          
		distTraveled += Distance( nodes[i].GetOrigin(), nodes[i + 1].GetOrigin() )
	}

	                                               
	vector closestPointOnSegment = GetClosestPointOnLineSegment( nodes[closestSegment].GetOrigin(), nodes[closestSegment + 1].GetOrigin(), p )
	                                                                                                    
	distTraveled += Distance( nodes[closestSegment].GetOrigin(), closestPointOnSegment )

	return clamp( distTraveled / totalDistance, 0.0, 1.0 )
}


float function GetPathDistance( array<entity> nodes )
{
	float totalDist = 0.0
	for ( int i = 0; i < nodes.len() - 1; i++ )
	{
		                                                                     
		totalDist += Distance( nodes[i].GetOrigin(), nodes[i + 1].GetOrigin() )
	}
	                                                                                  

	return totalDist
}


float function GetPathDistance_VectorArray( array<vector> nodes, bool isLoopingPath )
{
	float totalDist = 0.0
	int end_iter    = nodes.len()
	int numNodes    = end_iter

	if ( !isLoopingPath )
		end_iter -= 1

	for ( int i = 0; i < end_iter; i++ )
	{
		int idx_next = (i + 1) % numNodes
		totalDist += Distance( nodes[i], nodes[idx_next] )
	}

	return totalDist
}


array<float> function GetPathDistancesFromIdxArray_VectorArray( array<vector> nodes, array<int> distanceIdxArray, bool isLoopingPath )
{
	float totalDist = 0.0
	array<float> results
	int end_iter    = nodes.len()
	int numNodes    = end_iter

	int idx_curDistanceIdx
	int numRequestedDistances = distanceIdxArray.len()
	Assert( numRequestedDistances > 0, "No path distances given! 0 indexes received!" )

	for ( int i = 0; i < end_iter; i++ )
	{
		if ( i == distanceIdxArray[ idx_curDistanceIdx ] )
		{
			results.append( totalDist )
			idx_curDistanceIdx++
			if ( idx_curDistanceIdx == numRequestedDistances )
				break
		}

		int idx_next = (i + 1) % numNodes
		totalDist += Distance( nodes[i], nodes[idx_next] )
	}
	return results
}


void function WaittillAnimDone( entity animatingEnt )
{
	waitthread WaittillAnimDone_Thread( animatingEnt )
}


void function WaittillAnimDone_Thread( entity animatingEnt )
{
	if ( animatingEnt.IsPlayer() )
		animatingEnt.EndSignal( "OnDestroy" )

	animatingEnt.EndSignal( "OnAnimationInterrupted" )
	animatingEnt.WaitSignal( "OnAnimationDone" )
}


array<entity> function GetEntityLinkChain( entity startNode )
{
	Assert( IsValid( startNode ) )
	array<entity> nodes
	nodes.append( startNode )
	while ( true )
	{
		entity nextNode = nodes[nodes.len() - 1].GetLinkEnt()
		if ( !IsValid( nextNode ) )
			break
		nodes.append( nextNode )
	}
	return nodes
}


float function HealthRatio( entity ent )
{
	int health    = ent.GetHealth()
	int maxHealth = ent.GetMaxHealth()
	return float( health ) / maxHealth
}


vector function GetPointOnPathForFraction( array<entity> nodes, float frac )
{
	Assert( frac >= 0 )

	float totalPathDist = GetPathDistance( nodes )
	float distRemaining = totalPathDist * frac
	vector point        = nodes[0].GetOrigin()

	for ( int i = 0; i < nodes.len() - 1; i++ )
	{
		float segmentDist = Distance( nodes[i].GetOrigin(), nodes[i + 1].GetOrigin() )
		if ( segmentDist <= distRemaining )
		{
			                        
			distRemaining -= segmentDist
			point = nodes[i + 1].GetOrigin()
		}
		else
		{
			                                          
			vector dirVec = Normalize( nodes[i + 1].GetOrigin() - nodes[i].GetOrigin() )
			point = nodes[i].GetOrigin() + (dirVec * distRemaining)
			distRemaining = 0
		}
		if ( distRemaining <= 0 )
			break
	}

	if ( frac > 1.0 && distRemaining > 0 )
	{
		vector dirVec = Normalize( nodes[nodes.len() - 1].GetOrigin() - nodes[nodes.len() - 2].GetOrigin() )
		point = nodes[nodes.len() - 1].GetOrigin() + (dirVec * distRemaining)
	}

	return point
}


vector function GetPointOnPathForFraction_VectorArray( array<vector> nodes, float frac )
{
	Assert( frac >= 0 )

	float totalPathDist = GetPathDistance_VectorArray( nodes, false )
	float distRemaining = totalPathDist * frac
	vector point        = nodes[0]

	for ( int i = 0; i < nodes.len() - 1; i++ )
	{
		float segmentDist = Distance( nodes[i], nodes[i + 1] )
		if ( segmentDist <= distRemaining )
		{
			                        
			distRemaining -= segmentDist
			point = nodes[i + 1]
		}
		else
		{
			                                          
			vector dirVec = Normalize( nodes[i + 1] - nodes[i] )
			point = nodes[i] + (dirVec * distRemaining)
			distRemaining = 0
		}
		if ( distRemaining <= 0 )
			break
	}

	if ( frac > 1.0 && distRemaining > 0 )
	{
		vector dirVec = Normalize( nodes[nodes.len() - 1] - nodes[nodes.len() - 2] )
		point = nodes[nodes.len() - 1] + (dirVec * distRemaining)
	}

	return point
}

                                                                                                             
                                                                                                      
array<vector> function GetPointsOnLoopingPathForFraction_Simple( array<vector> path, array<float> fracArray )
{
	float totalDist  = GetPathDistance_VectorArray( path, true )
	int numPathNodes = path.len()
	return GetPointsOnLoopingPathForFraction( path, totalDist, numPathNodes, fracArray )
}


array<vector> function GetPointsOnLoopingPathForFraction( array<vector> path, float totalPathDist, int numPathNodes, array<float> fracArray )
{
	Assert( fracArray.len() > 0 )
	Assert( fracArray.top() <= 1.0, "Fracs must be within [0, 1]!" )

	array<vector> results
	float totalDistTraveled = 0
	float curDistRemaining  = totalPathDist * fracArray[ 0 ]
	int numRemainingFracs   = fracArray.len()
	int frac_idx            = 0

	for ( int path_idx = 0; path_idx < numPathNodes; path_idx++ )
	{
		float curFracArrayValue = fracArray[ frac_idx ]
		Assert( fracArray[ frac_idx ] >= 0 )

		                       
		int path_idx_next      = (path_idx + 1) % numPathNodes
		bool fracFoundThisLoop = false

		float segmentDist = Distance( path[path_idx], path[path_idx_next] )
		if ( segmentDist <= curDistRemaining )
		{
			if ( segmentDist == curDistRemaining )
			{
				fracFoundThisLoop = true
				results.append( path[path_idx_next] )
			}
			else
			{
				                        
				curDistRemaining -= segmentDist
				totalDistTraveled += segmentDist
			}
		}
		else
		{
			                                          
			vector dirVec = Normalize( path[path_idx_next] - path[path_idx] )
			results.append( path[path_idx] + (dirVec * curDistRemaining) )

			fracFoundThisLoop = true
		}

		if ( fracFoundThisLoop )
		{
			numRemainingFracs--
			frac_idx++
			path_idx--
			if ( numRemainingFracs <= 0 )
				break
			else
				curDistRemaining = (totalPathDist * fracArray[ frac_idx ]) - totalDistTraveled
		}
	}

	return results
}


array<vector> function GetPointsOnCircle( vector origin, vector angles, float radius, int segments = 16 )
{
	vector start
	vector end

	float degrees                = 360.0 / float( segments )
	array<vector> pointsOnCircle = []

	for ( int i = 0; i < segments; i++ )
	{
		vector angles2 = AnglesCompose( angles, <0, degrees * i, 0> )
		vector forward = AnglesToForward( angles2 )
		end = origin + (forward * radius)

		pointsOnCircle.append( end )

		start = end
	}

	return pointsOnCircle
}

#if SERVER
                                           
 
	                                    
 

                                              
 
	                                     
 
#endif


string function GetDroneType( entity npc )
{
	return expect string( npc.Dev_GetAISettingByKeyField( "drone_type" ) )
}

float function Round( float num, float decimalPoints )
{
	float retVal = num
	if ( decimalPoints >= 0 )
	{
		float factor = pow(10, decimalPoints)
		retVal *= factor
		retVal = floor( retVal + 0.5 )
		retVal /= factor

	}
	return retVal
}

vector function FlattenVec( vector vec )
{
	return <vec.x, vec.y, 0>
}


vector function FlattenAngles( vector angles )
{
	return <0, angles.y, 0>
}


bool function IsDropship( entity ent )
{
	#if CLIENT
		if ( !ent.IsNPC() )
			return false
	#endif

	return ent.GetNetworkedClassName() == "npc_dropship"
}


bool function IsSpecialist( entity ent )
{
	return ent.IsNPC() && ent.IsMechanical() && ent.GetNetworkedClassName() == "npc_soldier"
}


bool function IsGrunt( entity ent )
{
	return ent.IsNPC() && !ent.IsMechanical() && !IsCreature( ent ) && ent.GetNetworkedClassName() == "npc_soldier"
}


bool function IsMarvin( entity ent )
{
	return ent.IsNPC() && ent.GetAIClass() == AIC_MARVIN
}


bool function IsCreature( entity ent )
{
	if ( !ent.IsNPC() )
		return false

	if ( !IsValid( ent ) )
		return false

	string aiSettings = ent.GetAISettingsName()
	if ( aiSettings == "" )
		return false

	if ( Dev_GetAISettingByKeyField_Global( aiSettings, "creature" ) == 1 )
		return true

	return false
}


bool function IsSpectre( entity ent )
{
	return ent.IsNPC() && ent.GetAIClass() == AIC_SPECTRE
}


bool function IsWorldSpawn( entity ent )
{
	return ent.GetNetworkedClassName() == "worldspawn"
}


bool function IsSuperSpectre( entity ent )
{
	return ent.GetNetworkedClassName() == "npc_super_spectre"
}


bool function IsAndroidNPC( entity ent )
{
	return (IsSpectre( ent ) || IsStalker( ent ) || IsMarvin( ent ))
}

bool function IsBiologicalNPC( entity ent )
{
                                 
                   
             
       
	return (IsProwler( ent ) || IsSpider( ent ))
}

bool function IsStalker( entity ent )
{
	return ent.IsNPC() && (ent.GetAIClass() == AIC_STALKER || ent.GetAIClass() == AIC_STALKER_CRAWLING)
}


bool function IsProwler( entity ent )
{
	return ent.GetNetworkedClassName() == "npc_prowler"
}

bool function IsSpider( entity ent )
{
                                 
                   
              
       
	return ent.GetNetworkedClassName() == "npc_spider" || ent.GetNetworkedClassName() == "npc_spider_ranged"
}
                                
                                    
 
                                                                
 
      

bool function IsAirDrone( entity ent )
{
	return ent.GetNetworkedClassName() == "npc_drone"
}


bool function IsAttackDrone( entity ent )
{
	return (ent.IsNPC() && !ent.IsNonCombatAI() && IsAirDrone( ent ))
}


bool function IsGunship( entity ent )
{
	return ent.GetNetworkedClassName() == "npc_gunship"
}


bool function IsTrainingDummie( entity ent )
{
	return ent.GetNetworkedClassName() == "npc_dummie"
}

bool function IsCombatNPC( entity ent )
{
	return ( ent.IsNPC() && !ent.IsNonCombatAI() )
}

bool function IsMinion( entity ent )
{
	if ( IsGrunt( ent ) )
		return true

	if ( IsSpectre( ent ) )
		return true

	return false
}


bool function IsShieldDrone( entity ent )
{
	if ( ent.GetNetworkedClassName() != "npc_drone" )
		return false

	return GetDroneType( ent ) == "drone_type_shield"
}


bool function IsEnvDecoy( entity ent )
{
	return ent.GetNetworkedClassName() == "env_decoy"
}


#if SERVER
                                  
 
	                                                            
 

                                      
 
	                                   
 
#endif

bool function CanNPCDoDamageOnBehalfOfPlayer( entity ent )
{
	if (!IsValid(ent))
		return false

                                
                   
             
      
                 
                                                     
             
      
              
                                                  
             
      
	return false
}

RaySphereIntersectStruct function IntersectRayWithSphere( vector rayStart, vector rayEnd, vector sphereOrigin, float sphereRadius )
{
	RaySphereIntersectStruct intersection

	vector vecSphereToRay = rayStart - sphereOrigin

	vector vecRayDelta = rayEnd - rayStart
	float a            = DotProduct( vecRayDelta, vecRayDelta )

	if ( a == 0.0 )
	{
		intersection.result = LengthSqr( vecSphereToRay ) <= sphereRadius * sphereRadius
		intersection.enterFrac = 0.0
		intersection.leaveFrac = 0.0
		return intersection
	}

	float b       = 2 * DotProduct( vecSphereToRay, vecRayDelta )
	float c       = DotProduct( vecSphereToRay, vecSphereToRay ) - sphereRadius * sphereRadius
	float discrim = b * b - 4 * a * c
	if ( discrim < 0.0 )
	{
		intersection.result = false
		return intersection
	}

	discrim = sqrt( discrim )
	float oo2a = 0.5 / a
	intersection.enterFrac = (- b - discrim) * oo2a
	intersection.leaveFrac = (- b + discrim) * oo2a

	if ( (intersection.enterFrac > 1.0) || (intersection.leaveFrac < 0.0) )
	{
		intersection.result = false
		return intersection
	}

	if ( intersection.enterFrac < 0.0 )
		intersection.enterFrac = 0.0
	if ( intersection.leaveFrac > 1.0 )
		intersection.leaveFrac = 1.0

	intersection.result = true
	return intersection
}


table function GetTableFromString( string inString )
{
	if ( inString.len() > 0 )
		return expect table( getconsttable()[ inString ] )

	return {}
}


int function GetWeaponDamageNear( entity weapon, entity victim )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	if ( weaponOwner.IsNPC() )
	{
		if ( victim.GetArmorType() == ARMOR_TYPE_HEAVY )
			return weapon.GetWeaponSettingInt( eWeaponVar.npc_damage_near_value_titanarmor )
		else
			return weapon.GetWeaponSettingInt( eWeaponVar.npc_damage_near_value )
	}
	else
	{
		if ( victim.GetArmorType() == ARMOR_TYPE_HEAVY )
			return weapon.GetWeaponSettingInt( eWeaponVar.damage_near_value_titanarmor )
		else
			return weapon.GetWeaponSettingInt( eWeaponVar.damage_near_value )
	}

	unreachable
}


void function PrintFirstPersonSequenceStruct( FirstPersonSequenceStruct fpsStruct )
{
	printt( "Printing FirstPersonSequenceStruct:" )

	printt( "firstPersonAnim: " + fpsStruct.firstPersonAnim )
	printt( "thirdPersonAnim: " + fpsStruct.thirdPersonAnim )
	printt( "firstPersonAnimIdle: " + fpsStruct.firstPersonAnimIdle )
	printt( "thirdPersonAnimIdle: " + fpsStruct.thirdPersonAnimIdle )
	printt( "relativeAnim: " + fpsStruct.relativeAnim )
	printt( "attachment: " + fpsStruct.attachment )
	printt( "teleport: " + fpsStruct.teleport )
	printt( "noParent: " + fpsStruct.noParent )
	printt( "blendTime: " + fpsStruct.blendTime )
	printt( "noViewLerp: " + fpsStruct.noViewLerp )
	printt( "hideProxy: " + fpsStruct.hideProxy )
	printt( "viewConeFunction: " + string( fpsStruct.viewConeFunction ) )
	printt( "origin: " + string( fpsStruct.origin ) )
	printt( "angles: " + string( fpsStruct.angles ) )
	printt( "enablePlanting: " + fpsStruct.enablePlanting )
	printt( "setStartTime: " + fpsStruct.setStartTime )
	printt( "setInitialTime: " + fpsStruct.setInitialTime )
	printt( "useAnimatedRefAttachment: " + fpsStruct.useAnimatedRefAttachment )
	printt( "renderWithViewModels: " + fpsStruct.renderWithViewModels )
	printt( "gravity: " + fpsStruct.gravity )
}


void function WaitSignalOrTimeout( entity ent, float timeout, string signal1, string signal2 = "", string signal3 = "" )
{
	Assert( IsValid( ent ) )

	ent.EndSignal( signal1 )

	if ( signal2 != "" )
		ent.EndSignal( signal2 )

	if ( signal3 != "" )
		ent.EndSignal( signal3 )

	wait(timeout)
}


void function AddWaitMultipleSignal( table signalTable, string signalToWait, string signalToReturn )
{
	EndSignal( signalTable, signalToReturn )
	WaitSignal( signalTable, signalToWait )

	Signal( signalTable, signalToReturn, { addWaitSignal = signalToWait } )
}


string function GetWaitMultipleSignal( table signalTable, array<string> signalsToWait, string signalToReturn )
{
	foreach ( string signalToWait in signalsToWait )
		thread AddWaitMultipleSignal( signalTable, signalToWait, signalToReturn )

	table results = WaitSignal( signalTable, signalToReturn )

	string finalSignal = expect string( results.addWaitSignal )
	return finalSignal
}


void function AddWaitMultipleSignal_Entity( entity signalEnt, string signalToWait, string signalToReturn )
{
	EndSignal( signalEnt, signalToReturn )
	WaitSignal( signalEnt, signalToWait )

	Signal( signalEnt, signalToReturn, { addWaitSignal = signalToWait } )
}


string function GetWaitMultipleSignal_Entity( entity signalEnt, array<string> signalsToWait, string signalToReturn )
{
	foreach ( string signalToWait in signalsToWait )
		thread AddWaitMultipleSignal_Entity( signalEnt, signalToWait, signalToReturn )

	table results = WaitSignal( signalEnt, signalToReturn )

	string finalSignal = expect string( results.addWaitSignal )
	return finalSignal
}


LineSegment function GetShortestLineSegmentConnectingLineSegments( vector p1, vector p2, vector p3, vector p4 )
{
	                                                                                                                             
	                                                           
	                                                                                                                         

	                         
	                         
	                         
	                         
	vector p13 = p1 - p3
	vector p21 = p2 - p1
	vector p43 = p4 - p3

	if ( Length( p43 ) < 1.0 )
	{
		LineSegment out
		out.start = GetClosestPointOnLine( p1, p2, p3 )
		out.end = p3
		return out
	}

	if ( Length( p21 ) < 1.0 )
	{
		LineSegment out
		out.start = p1
		out.end = GetClosestPointOnLine( p3, p4, p1 )
		return out
	}

	float d1343 = p13.x * p43.x + p13.y * p43.y + p13.z * p43.z
	float d4321 = p43.x * p21.x + p43.y * p21.y + p43.z * p21.z
	float d1321 = p13.x * p21.x + p13.y * p21.y + p13.z * p21.z
	float d4343 = p43.x * p43.x + p43.y * p43.y + p43.z * p43.z
	float d2121 = p21.x * p21.x + p21.y * p21.y + p21.z * p21.z

	float denom = d2121 * d4343 - d4321 * d4321
	if ( denom <= 0.01 )
	{
		                     
		LineSegment out
		out.start = p2

		if ( Length( p2 - p3 ) < Length( p2 - p4 ) )
			out.end = p3
		else
			out.end = p4

		return out
	}
	float numer = d1343 * d4321 - d1321 * d4343

	float mua = numer / denom
	float mub = (d1343 + d4321 * (mua)) / d4343

	LineSegment out
	out.start = <p1.x + mua * p21.x, p1.y + mua * p21.y, p1.z + mua * p21.z>
	out.end = <p3.x + mub * p43.x, p3.y + mub * p43.y, p3.z + mub * p43.z>
	return out
}


vector function GetClosestPointToLineSegments( vector line1Point1, vector line1Point2, vector line2Point1, vector line2Point2 )
{
	LineSegment seg = GetShortestLineSegmentConnectingLineSegments( line1Point1, line1Point2, line2Point1, line2Point2 )
	return (seg.start + seg.end) / 2.0
}


float function GetClosestDistanceBetweenLineSegments( vector line1Point1, vector line1Point2, vector line2Point1, vector line2Point2 )
{
	LineSegment seg = GetShortestLineSegmentConnectingLineSegments( line1Point1, line1Point2, line2Point1, line2Point2 )
	return Distance( seg.start, seg.end )
}


bool function PlayerCanSee( entity player, entity ent, bool doTrace, float degrees )
{
	float minDot = deg_cos( degrees )

	             
	float dot = DotProduct( Normalize( ent.GetWorldSpaceCenter() - player.EyePosition() ), player.GetViewVector() )
	if ( dot < minDot )
		return false

	                   
	if ( doTrace )
	{
		TraceResults trace = TraceLine( player.EyePosition(), ent.GetWorldSpaceCenter(), null, TRACE_MASK_BLOCKLOS, TRACE_COLLISION_GROUP_NONE )
		if ( trace.hitEnt == ent || trace.fraction >= 0.99 )
			return true
		else
			return false
	}
	else
		return true

	Assert( 0, "shouldn't ever get here" )
	unreachable
}

bool function PlayerCanSeePos( entity player, vector pos, bool doTrace, float degrees )
{
	float minDot = deg_cos( degrees )
	float dot    = DotProduct( Normalize( pos - player.EyePosition() ), player.GetViewVector() )
	if ( dot < minDot )
		return false

	if ( doTrace )
	{
		TraceResults trace = TraceLine( player.EyePosition(), pos, null, TRACE_MASK_BLOCKLOS, TRACE_COLLISION_GROUP_NONE )
		if ( trace.fraction < 0.99 )
			return false
	}

	return true
}


bool function VectorsFacingSameDirection( vector v1, vector v2, float degreesThreshold )
{
	float minDot = deg_cos( degreesThreshold )
	float dot    = DotProduct( Normalize( v1 ), Normalize( v2 ) )
	return (dot >= minDot)
}


vector function GetRelativeDelta( vector origin, entity ref, string attachment = "" )
{
	vector pos
	vector right
	vector forward
	vector up

	if ( attachment != "" )
	{
		int attachID = ref.LookupAttachment( attachment )
		pos = ref.GetAttachmentOrigin( attachID )
		vector angles = ref.GetAttachmentAngles( attachID )
		right = AnglesToRight( angles )
		forward = AnglesToForward( angles )
		up = AnglesToUp( angles )
	}
	else
	{
		pos = ref.GetOrigin()
		right = ref.GetRightVector()
		forward = ref.GetForwardVector()
		up = ref.GetUpVector()
	}

	vector x = GetClosestPointOnLineSegment( pos + right * -16384, pos + right * 16384, origin )
	vector y = GetClosestPointOnLineSegment( pos + forward * -16384, pos + forward * 16384, origin )
	vector z = GetClosestPointOnLineSegment( pos + up * -16384, pos + up * 16384, origin )

	float distx = Distance( pos, x )
	float disty = Distance( pos, y )
	float distz = Distance( pos, z )

	if ( DotProduct( x - pos, right ) < 0 )
		distx *= -1
	if ( DotProduct( y - pos, forward ) < 0 )
		disty *= -1
	if ( DotProduct( z - pos, up ) < 0 )
		distz *= -1

	return <distx, disty, distz>
}


vector function OffsetPointRelativeToVector( vector point, vector offset, vector forward )
{
	vector angles = VectorToAngles( forward )
	vector right  = AnglesToRight( angles )
	vector up     = AnglesToUp( angles )
	return point + (right * offset.x) + (forward * offset.y) + (up * offset.z)
}

#if SERVER
                                              
 
	       
		                               
		 
			                                                                    
			                            
			          
		 
	      

	                                            
		                                       

	                                      
		                                                           
	    
		                                             

	           
 
#endif          


bool function PlayerHasWeapon( entity player, string weaponName )
{
	array<entity> weapons = player.GetMainWeapons()
	weapons.extend( player.GetOffhandWeapons() )

	foreach ( weapon in weapons )
	{
		if ( weapon.GetWeaponClassName() == weaponName )
			return true
	}

	return false
}


bool function PlayerCanUseWeapon( entity player, string weaponClass )
{
	return ((player.IsTitan() && weaponClass == "titan") || (!player.IsTitan() && weaponClass == "human"))
}


string function GetEditorClass( entity ent )
{
	if ( ent.HasKey( "editorclass" ) )
		return ent.GetValueForKey( "editorclass" )

	return ""
}


void function DebugDrawLineFromEntToPos( entity ent, vector pos, int r, int g, int b, bool throughGeo, float duration )
{
	EndSignal( ent, "OnDestroy" )
	float endTime = Time() + duration
	while( Time() <= endTime )
	{
		DebugDrawLine( ent.GetOrigin(), pos, <r, g, b>, throughGeo, 0.1 )
		wait 0.05
	}
}


bool function PlayerIsInADS( entity player, bool checkMelee = true )
{
	entity activeWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )

	if ( !IsValid( activeWeapon ) )
		return false

	if ( checkMelee )
	{
		if ( activeWeapon.GetWeaponSettingBool( eWeaponVar.attack_button_presses_melee ) )
			return false
	}

	return activeWeapon.IsWeaponAdsButtonPressed() || activeWeapon.IsWeaponInAds()
}


      
              

#if SERVER
                                                                        
 
	                                                                                      
 
                                                         
 
	                                           
 
                                                           
 
	                                            
 
#endif          

bool function GradeFlagsHas( entity ent, int gradeFlags )
{
	return ((ent.GetGrade() & gradeFlags) != 0)
}


                                                    
   
  	                  
  	                                                        
  		                             
  	    
  		                       
  
  	                              
  	 
  		                                                                                                          
  			          
  	 
  
  	         
   

array<string> function GetValidLootModsInstalled( entity weapon )
{
	string weaponName = GetWeaponClassName( weapon )

	if ( !SURVIVAL_Loot_IsRefValid( weaponName ) )
		return []

	if ( SURVIVAL_Weapon_IsAttachmentLocked( weaponName ) )
		return []

	array<string> mods = GetWeaponMods( weapon )
	array<string> validMods

	foreach ( mod in mods )
	{
		if ( SURVIVAL_Loot_IsRefValid( mod ) )                                         
			validMods.append( mod )
	}

	return validMods
}


array<string> function GetNonInstallableWeaponMods( entity weapon )
{
	string weaponName = GetWeaponClassName( weapon )

	if ( weapon.GetNetworkedClassName() != "prop_survival" && !SURVIVAL_Loot_IsRefValid( weaponName ) )
		return weapon.GetMods()

	bool isAttachmentLocked = SURVIVAL_Weapon_IsAttachmentLocked( weaponName )

	array<string> mods = GetWeaponMods( weapon )
	array<string> foundMods
	array<string> installedMods

	foreach ( mod in mods )
	{
		if ( !CanAttachToWeapon( mod, weaponName ) || isAttachmentLocked )
			foundMods.append( mod )
		else
			installedMods.append( mod )
	}

	VerifyToggleMods( foundMods )

	return foundMods
}

array<string> function GetNonInstallableTrackableWeaponMods( entity weapon )
{
	string weaponName = GetWeaponClassName( weapon )

	if ( weapon.GetNetworkedClassName() != "prop_survival" && !SURVIVAL_Loot_IsRefValid( weaponName ) )
		return weapon.GetMods()

	bool isAttachmentLocked = SURVIVAL_Weapon_IsAttachmentLocked( weaponName )

	array<string> mods = GetWeaponMods( weapon )
	array<string> trackedMods

	foreach ( mod in mods )
	{
		if ( ( !CanAttachToWeapon( mod, weaponName ) || isAttachmentLocked ) && file.nonInstalledModsTracked.contains( mod ) )
			trackedMods.append( mod )
	}

	return trackedMods
}

string function GetWeaponClassName( entity weaponOrProp )
{
	string weaponName
	if ( weaponOrProp.GetNetworkedClassName() == "prop_survival" )
	{
		LootData data = SURVIVAL_Loot_GetLootDataByIndex( weaponOrProp.GetSurvivalInt() )
		weaponName = data.ref
	}
	else
	{
		weaponName = weaponOrProp.GetWeaponClassName()
	}

	return weaponName
}


array<string> function GetWeaponMods( entity weaponOrProp )
{
	array<string> mods
	if ( weaponOrProp.GetNetworkedClassName() == "prop_survival" )
		mods = weaponOrProp.GetWeaponMods()
	else
		mods = weaponOrProp.GetMods()

	return mods
}


LineSegment function ClampLineSegmentToWorldBounds2D( vector p0, vector p1, float padding = 0 )
{
	float max               = MAX_WORLD_COORD - 2 - padding
	LineSegment lineSegment = ClampLineSegmentToRectangle2D( p0, p1, <-max, -max, 0>, <max, max, 0> )

	lineSegment.start = < lineSegment.start.x, lineSegment.start.y, p0.z >
	lineSegment.end = < lineSegment.end.x, lineSegment.end.y, p1.z >

	return lineSegment
}


LineSegment function ClampLineSegmentToRectangle2D( vector p0, vector p1, vector rectP0, vector rectP1 )
{
	vector topLeft     = rectP0
	vector bottomLeft  = <rectP0.x, rectP1.y, 0>
	vector topRight    = <rectP1.x, rectP0.y, 0>
	vector bottomRight = rectP1

	vector newP0 = <p0.x, p0.y, 0>
	vector newP1 = <p1.x, p1.y, 0>

	       
	if ( Do2DLinesIntersect( p0, p1, topLeft, bottomLeft ) )
	{
		if ( p0.x < topLeft.x )
			newP0 = Get2DLineIntersection( p0, p1, topLeft, bottomLeft )
		if ( p1.x < topLeft.x )
			newP1 = Get2DLineIntersection( p0, p1, topLeft, bottomLeft )
	}

	        
	if ( Do2DLinesIntersect( p0, p1, topRight, bottomRight ) )
	{
		if ( p0.x > bottomRight.x )
			newP0 = Get2DLineIntersection( p0, p1, topRight, bottomRight )
		if ( p1.x > bottomRight.x )
			newP1 = Get2DLineIntersection( p0, p1, topRight, bottomRight )
	}

	      
	if ( Do2DLinesIntersect( p0, p1, topLeft, topRight ) )
	{
		if ( p0.y < topLeft.y )
			newP0 = Get2DLineIntersection( p0, p1, topLeft, topRight )
		if ( p1.y < topLeft.y )
			newP1 = Get2DLineIntersection( p0, p1, topLeft, topRight )
	}

	         
	if ( Do2DLinesIntersect( p0, p1, bottomLeft, bottomRight ) )
	{
		if ( p0.y > bottomRight.y )
			newP0 = Get2DLineIntersection( p0, p1, bottomLeft, bottomRight )
		if ( p1.y > bottomRight.y )
			newP1 = Get2DLineIntersection( p0, p1, bottomLeft, bottomRight )
	}

	LineSegment lineSegment
	lineSegment.start = newP0
	lineSegment.end = newP1

	return lineSegment
}


bool function Do2DLinesIntersect( vector A, vector B, vector C, vector D )
{
	float ax = B.x - A.x                          
	float ay = B.y - A.y                         

	float bx = C.x - D.x                                    
	float by = C.y - D.y                                  

	float dx = C.x - A.x                      
	float dy = C.y - A.y

	float det = ax * by - ay * bx

	if ( fabs( det ) < 0.001 )
		return false

	if ( ax * dy - ay * dx == 0 )
		return false

	float r = (dx * by - dy * bx) / det
	float s = (ax * dy - ay * dx) / det

	return !(r < 0 || r > 1 || s < 0 || s > 1)
}


vector function Get2DLineIntersection( vector A, vector B, vector C, vector D )
{
	float dy1 = B.y - A.y
	float dx1 = B.x - A.x
	float dy2 = D.y - C.y
	float dx2 = D.x - C.x
	float x   = ((C.y - A.y) * dx1 * dx2 + dy1 * dx2 * A.x - dy2 * dx1 * C.x) / (dy1 * dx2 - dy2 * dx1)
	float y   = A.y + (fabs( 0.0 - dx1 ) > 0.00001 ? (dy1 / dx1) * (x - A.x) : 0.0)
	vector p  = <x, y, 0>
	return p
}


int function GetSlotForWeapon( entity player, entity weapon )
{
	array<int> slots = [ WEAPON_INVENTORY_SLOT_PRIMARY_0, WEAPON_INVENTORY_SLOT_PRIMARY_1, WEAPON_INVENTORY_SLOT_ANTI_TITAN ]
	foreach ( slot in slots )
	{
		if ( player.GetNormalWeapon( slot ) == weapon )
			return slot
	}

	return -1
}


bool function CanAttachToWeapon( string attachment, string weaponName )
{
	if ( weaponName == "" )
		return false

	if ( !SURVIVAL_Loot_IsRefValid( weaponName ) )
		return false

	if ( !SURVIVAL_Loot_IsRefValid( attachment ) )
		return false

	if ( SURVIVAL_Weapon_IsAttachmentLocked( weaponName ) && !IsArenaMode() )
	{
		if ( SURVIVAL_IsAttachmentPointLocked( weaponName, GetAttachPointForAttachmentOnWeapon( weaponName, attachment ) ) )
			return false

		weaponName = GetBaseWeaponRef( weaponName )
	}

	AttachmentData aData = GetAttachmentData( attachment )

	return (aData.compatibleWeapons.contains( weaponName ))
}


string function GetBaseWeaponRef( string weaponRef )
{
                                 
                                                                   
                                                                                            
       
	if ( weaponRef.find( WEAPON_LOCKEDSET_SUFFIX_GOLDPAINTBALL ) != -1 )
		return weaponRef.slice( 0, weaponRef.len() - (WEAPON_LOCKEDSET_SUFFIX_GOLDPAINTBALL.len()) )
	if ( weaponRef.find( WEAPON_LOCKEDSET_SUFFIX_GOLD ) != -1 )
		return weaponRef.slice( 0, weaponRef.len() - (WEAPON_LOCKEDSET_SUFFIX_GOLD.len()) )
	if ( weaponRef.find( WEAPON_LOCKEDSET_SUFFIX_WHITESET ) != -1 )
		return weaponRef.slice( 0, weaponRef.len() - (WEAPON_LOCKEDSET_SUFFIX_WHITESET.len()) )
	if ( weaponRef.find( WEAPON_LOCKEDSET_SUFFIX_BLUESET ) != -1 )
		return weaponRef.slice( 0, weaponRef.len() - (WEAPON_LOCKEDSET_SUFFIX_BLUESET.len()) )
	if ( weaponRef.find( WEAPON_LOCKEDSET_SUFFIX_PURPLESET ) != -1 )
		return weaponRef.slice( 0, weaponRef.len() - (WEAPON_LOCKEDSET_SUFFIX_PURPLESET.len()) )
	if ( weaponRef.find( WEAPON_LOCKEDSET_SUFFIX_PURPLEPAINTBALL ) != -1 )
		return weaponRef.slice( 0, weaponRef.len() - (WEAPON_LOCKEDSET_SUFFIX_PURPLEPAINTBALL.len()) )
	if ( weaponRef.find( WEAPON_LOCKEDSET_SUFFIX_BLUEPAINTBALL ) != -1 )
		return weaponRef.slice( 0, weaponRef.len() - (WEAPON_LOCKEDSET_SUFFIX_BLUEPAINTBALL.len()) )
	return weaponRef
}

bool function AttachmentPointSupported( string attachmentPoint, string weaponName )
{
	LootData weaponData = SURVIVAL_Loot_GetLootDataByRef( weaponName )

	array<string> allAttachPoints = weaponData.supportedAttachments
	return allAttachPoints.contains( attachmentPoint )
}

string function GetAttachmentPointStyle( string attachmentPoint, string weaponName )
{
	switch ( attachmentPoint )
	{
		case "sight":
			break

		case "grip":
			array<LootData> attachments = SURVIVAL_Loot_GetByType( eLootType.ATTACHMENT )
			foreach ( attachmentData in attachments )
			{
				if ( !CanAttachmentEquipToAttachPoint( attachmentData.ref, "grip" ) )
					continue

				if ( !CanAttachToWeapon( attachmentData.ref, weaponName ) )
					continue

				return attachmentData.attachmentStyle
			}
			break

		case "barrel":
			array<LootData> attachments = SURVIVAL_Loot_GetByType( eLootType.ATTACHMENT )
			foreach ( attachmentData in attachments )
			{
				if ( !CanAttachmentEquipToAttachPoint( attachmentData.ref, "barrel" ) )
					continue

				if ( !CanAttachToWeapon( attachmentData.ref, weaponName ) )
					continue

				return attachmentData.attachmentStyle
			}

			break

		case "mag":
			LootData weaponData = SURVIVAL_Loot_GetLootDataByRef( weaponName )
			if ( weaponData.ammoType == "bullet" )
				return "mag_straight"
			if ( weaponData.ammoType == "special" || weaponData.ammoType == "arrows" )
				return "mag_energy"
			if ( weaponData.ammoType == "shotgun" )
				return "mag_shotgun"
			if ( weaponData.ammoType == "sniper" )
				return "mag_sniper"
            if ( weaponData.ref == "mp_weapon_car" )
                return "mag_car"

			break

		case "hopup":
		case "hopupMulti_a":
		case "hopupMulti_b":
			array<LootData> attachments = SURVIVAL_Loot_GetByType( eLootType.ATTACHMENT )
			string attachmentStyle = ""
			bool moreThanOneHopup = false
			foreach ( attachmentData in attachments )
			{
				if ( !CanAttachmentEquipToAttachPoint( attachmentData.ref, attachmentPoint ) )
					continue

				if ( !CanAttachToWeapon( attachmentData.ref, weaponName ) )
					continue

				if ( attachmentStyle != "" && !attachmentData.lootTags.contains( "FakeHopup" ) )
				{
					moreThanOneHopup = true
					break
				}

				if ( !attachmentData.lootTags.contains( "FakeHopup" ) )
					attachmentStyle = attachmentData.attachmentStyle
			}

			if ( moreThanOneHopup )
				return attachmentPoint
			else if ( attachmentStyle != "" )
				return attachmentStyle

			break
	}

	return attachmentPoint
}


array<string> function GetAttachmentsForPoint( string attachmentPoint, string weaponName )
{
	array<string> attachmentRefs
	switch ( attachmentPoint )
	{
		case "hopup":
		case "hopupMulti_a":
		case "hopupMulti_b":
			array<LootData> attachments = SURVIVAL_Loot_GetByType( eLootType.ATTACHMENT )
			foreach ( attachmentData in attachments )
			{
				if ( !CanAttachmentEquipToAttachPoint( attachmentData.ref, attachmentPoint ) )
					continue

				if ( !CanAttachToWeapon( attachmentData.ref, weaponName ) )
					continue

				if ( attachmentData.lootTags.contains ( "FakeHopup" ) )
					continue

				attachmentRefs.append( attachmentData.ref )
			}
			break

		default:
			Assert( 0, "attachmentPoint " + attachmentPoint + " is not supported, but could be." )
	}

	return attachmentRefs
}


bool function HasWeapon( entity ent, string weaponClassName, array<string> mods = [], bool checkMods = true )
{
	Assert( ent.IsPlayer() || ent.IsNPC() )

	array<entity> weaponArray = ent.GetMainWeapons()
	foreach ( weapon in weaponArray )
	{
		if ( weapon.GetWeaponClassName() == weaponClassName )
		{
			if ( !checkMods )
				return true

			if ( WeaponHasSameMods( weapon, mods ) )
				return true
		}
	}

	return false
}


bool function WeaponHasSameMods( entity weapon, array<string> mods = [] )
{
	array hasMods = clone mods
	foreach ( mod in weapon.GetMods() )
	{
		hasMods.removebyvalue( mod )
	}

	                         
	return hasMods.len() == 0
}


int function SortLowestFloat( float a, float b )
{
	if ( a > b )
		return 1

	if ( a < b )
		return -1

	return 0
}


int function SortLowestInt( int a, int b )
{
	if ( a > b )
		return 1

	if ( a < b )
		return -1

	return 0
}


bool function TeamHasBots( int team )
{
	array<entity> teammates = GetPlayerArrayOfTeam( team )
	foreach ( player in teammates )
	{
		if ( player.IsBot() )
			return true
	}

	return false
}


array<int> function GetTeamsForPlayers( array<entity> playersToUse )
{
	array<int> results
	foreach ( player in playersToUse )
	{
		int team = player.GetTeam()
		if ( !results.contains( team ) )
			results.append( team )
	}

	return results
}


int function GetNumTeamsRemaining()
{
	if ( file.getNumTeamsRemainingCallback != null )
	{
		return file.getNumTeamsRemainingCallback()
	}

	return GetTeamsForPlayers( GetPlayerArray_AliveConnected() ).len()
}


int function GetNumTeamsExisting()
{
	return GetTeamsForPlayers( GetPlayerArray() ).len()
}


array<entity> function GetFriendlySquadArrayForPlayer( entity player )
{
	int team = player.GetTeam()
	if ( IsTeamRabid( team ) )
		return [player]

	return GetPlayerArrayOfTeam( team )
}


array<entity> function GetFriendlySquadArrayForPlayer_AliveConnected( entity player )
{
	int team = player.GetTeam()
	if ( IsTeamRabid( team ) )
	{
		if ( !IsAlive( player ) )
			return []
		#if SERVER
			                               
				         
		#endif
		return [player]
	}

	return GetPlayerArrayOfTeam_AliveConnected( team )
}


array<entity> function GetPlayerArrayOfTeam_AliveConnected( int team )
{
	return GetFilteredArray_Connected( GetPlayerArrayOfTeam_Alive( team ) )
}


array<entity> function GetPlayerArrayOfTeam_AliveNotBleedingOut( int team )
{
	return GetFilteredArray_NotBleedingOut( GetPlayerArrayOfTeam_Alive( team ) )
}


array<entity> function GetPlayerArrayOfTeam_Connected( int team )
{
	return GetFilteredArray_Connected( GetPlayerArrayOfTeam( team ) )
}


array<entity> function GetPlayerArray_AliveConnected()
{
	return GetFilteredArray_Connected( GetPlayerArray_Alive() )
}


array<entity> function GetFilteredArray_Connected( array<entity> playerArray )
{
	array<entity> results
	foreach ( player in playerArray )
	{
		#if SERVER
			                               
				        
		#endif
		results.append( player )
	}

	return results
}


array<entity> function GetFilteredArray_NotBleedingOut( array<entity> playerArray )
{
	array<entity> results
	foreach ( player in playerArray )
	{
		Bleedout_IsBleedingOut( player )
		continue
		results.append( player )
	}

	return results
}


array<entity> function GetPlayerArray_ConnectedNotSpectatorTeam()
{
	array<entity> results
	array<entity> playerArray = GetPlayerArray()
	foreach ( player in playerArray )
	{
		#if SERVER
			                               
				        
		#endif
		if ( player.GetTeam() == TEAM_SPECTATOR )
			continue

		results.append( player )
	}

	return results
}


entity function GetJumpmasterForTeam( int team )
{
	entity jumpMaster

	array<entity> teammates = GetPlayerArrayOfTeam_Alive( team )
	foreach ( entity player in teammates )
	{
		if ( !player.GetPlayerNetBool( "playerInPlane" ) )
			continue

		if ( !player.GetPlayerNetBool( "isJumpingWithSquad" ) )
			continue

		if ( player.GetPlayerNetBool( "isJumpmaster" ) )
			return player
	}

	return jumpMaster
}


int function GetNumPlayersJumpingWithSquad( int team )
{
	int count               = 0
	array<entity> teammates = GetPlayerArrayOfTeam_Alive( team )
	foreach ( entity player in teammates )
	{
		if ( !player.GetPlayerNetBool( "playerInPlane" ) )
			continue

		if ( !player.GetPlayerNetBool( "isJumpingWithSquad" ) )
			continue

		count++
	}

	return count
}


void function DeleteAllByScriptName( string scriptName, string scriptGroup = "" )
{
	array <entity> ents = GetEntArrayByScriptName( scriptName )
	foreach ( ent in ents )
	{
		if ( !IsValid( ent ) )
			continue


		if ( scriptGroup != "" )
		{
			if ( ent.HasKey( "script_group" ) && ent.GetValueForKey( "script_group" ) == scriptGroup )
				ent.Destroy()
		}
		else
		{
			ent.Destroy()
			continue
		}
	}
}


void function DeleteAllByScriptNameWithLinkedEnts( string scriptName )
{
	                                                                     
	array <entity> ents = GetEntArrayByScriptName( scriptName )
	foreach ( ent in ents )
	{
		DeleteAllLinkedEnts( ent )
		if ( IsValid( ent ) )
			ent.Destroy()
	}
}


void function DeleteAllLinkedEnts( entity ent )
{
	array <entity> linkedEnts = ent.GetLinkEntArray()
	foreach ( linkedEnt in linkedEnts )
	{
		if ( IsValid( linkedEnt ) )
			linkedEnt.Destroy()
	}
}


void function PROTO_FadeModelIntensityOverTime( entity model, float duration = 1, float startIntensity = 1, float endIntensity = 10 )
{
	EndSignal( model, "OnDestroy" )

	Signal( model, "FadeModelIntensityOverTime" )
	EndSignal( model, "FadeModelIntensityOverTime" )

	float startTime       = Time()
	float endTime         = startTime + duration
	float intensityResult = startIntensity

	while ( Time() <= endTime )
	{
		intensityResult = GraphCapped( Time(), startTime, endTime, startIntensity, endIntensity )
		model.kv.intensity = intensityResult
		                                                                                                                                                                                                                  
		                                                        
		WaitFrame()
	}

	if ( intensityResult != endIntensity )
	{
		model.kv.intensity = endIntensity
		                                                  
	}
}


void function PROTO_FadeModelColorOverTime( entity model, float duration, vector startColor = < 255, 255, 255 >, vector endColor = < 0, 0, 0 > )
{
	EndSignal( model, "OnDestroy" )

	Signal( model, "FadeModelColorOverTime" )
	EndSignal( model, "FadeModelColorOverTime" )

	float startTime = Time()
	float endTime   = startTime + duration

	while ( Time() <= endTime )
	{
		vector colorResult = GraphCappedVector( Time(), startTime, endTime, startColor, endColor )
		string colorString = colorResult.x + " " + colorResult.y + " " + colorResult.z
		model.kv.rendercolor = colorString
		model.kv.renderamt = 255
		                                                
		WaitFrame()
	}

	string endColorString = endColor.x + " " + endColor.y + " " + endColor.z
	if ( model.kv.rendercolor != endColorString )
	{
		model.kv.rendercolor = endColorString
		                                                         
		                                                
	}
}


void function PROTO_FadeModelAlphaOverTime( entity ent, float duration, int startAlpha = 255, int endAlpha = 0 )
{
	EndSignal( ent, "OnDestroy" )

	Signal( ent, "FadeModelAlphaOverTime" )
	EndSignal( ent, "FadeModelAlphaOverTime" )

	OnThreadEnd( void function() : ( ent, endAlpha ) {
		if ( !IsValid( ent ) )
			return

		ent.kv.renderamt = endAlpha
		if ( endAlpha >= 255 )
			ent.kv.rendermode = 0
	} )

	ent.kv.rendermode = 4

	float startTime = Time()
	float endTime   = startTime + duration
	while ( Time() <= endTime )
	{
		ent.kv.renderamt = GraphCapped( Time(), startTime, endTime, startAlpha, endAlpha )
		WaitFrame()
	}
}

#if CLIENT
void function PROTO_FadeAlphaOverTimeOnEntityAndChildren( entity parentEnt, float duration, int startAlpha, int endAlpha, float delay )
{
	EndSignal( parentEnt, "OnDestroy" )

	Signal( parentEnt, "FadeModelAlphaOverTime" )
	EndSignal( parentEnt, "FadeModelAlphaOverTime" )

	                  
	parentEnt.kv.rendermode = 4
	parentEnt.kv.renderamt = startAlpha

	WaitFrame()                      

	array<entity> hierachy = GetEntityAndImmediateChildren( parentEnt )
	foreach ( entity hierachyEnt in hierachy )
	{
		hierachyEnt.kv.rendermode = 4
		hierachyEnt.kv.renderamt = startAlpha
		                    
	}

	wait delay

	OnThreadEnd( void function() : ( endAlpha, hierachy ) {
		foreach ( entity hierachyEnt in hierachy )
		{
			if ( !IsValid( hierachyEnt ) )
				continue

			hierachyEnt.kv.renderamt = endAlpha
			if ( endAlpha >= 255 )
				hierachyEnt.kv.rendermode = 0
		}
	} )

	WaitFrame()
	                                            
	   
	  	                              
	  		        
	  
	  	                  
	   

	foreach ( entity hierachyEnt in hierachy )
	{
		if ( !IsValid( hierachyEnt ) )
			continue

		hierachyEnt.kv.rendermode = 4
		hierachyEnt.kv.renderamt = startAlpha
	}

	float startTime = Time()
	float endTime   = startTime + duration
	while ( Time() <= endTime )
	{
		foreach ( entity hierachyEnt in hierachy )
		{
			if ( !IsValid( hierachyEnt ) )
				continue

			hierachyEnt.kv.renderamt = GraphCapped( Time(), startTime, endTime, startAlpha, endAlpha )
		}
		WaitFrame()
	}
}
#endif


array<entity> function GetEntityAndImmediateChildren( entity parentEnt )
{
	array<entity> out = []
	#if SERVER
		                                  
	#elseif CLIENT
		Assert( parentEnt.GetCodeClassName() == "dynamicprop" )

		out.extend( parentEnt.GetChildren() )
	#endif
	out.append( parentEnt )
	return out
}


array<entity> function GetEntityAndAllChildren( entity parentEnt )
{
	array<entity> entList = [ parentEnt ]
	int entIdx            = 0
	while ( entIdx < entList.len() )
	{
		entity ent = entList[entIdx]

		entIdx++

		if ( IsValid( ent ) )
			entList.extend( ent.GetChildren() )
	}
	return entList
}


void function KnockBackPlayer( entity player, vector pushDir, float scale, float time )
{
	player.KnockBack( pushDir * scale, time )
}

entity function GetPusherEnt( entity ent )
{
	entity pusher = ent
	while( IsValid( pusher ) && pusher.HasPusherAncestor() && !pusher.GetPusher() )
	{
		pusher = pusher.GetParent()
	}

	if ( IsValid( pusher ) && pusher.GetPusher() )
		return pusher

	return null
}

bool function PlayersInSameParty( entity player1, entity player2 )
{
	if ( player1.GetPartyLeaderClientIndex() < 0 )
		return false

	if ( player2.GetPartyLeaderClientIndex() < 0 )
		return false

	return (player1.GetPartyLeaderClientIndex() == player2.GetPartyLeaderClientIndex())
}


Point function CreatePoint( vector origin, vector angles )
{
	Point data
	data.origin = origin
	data.angles = angles
	return data
}


bool function IsFallLTM()
{
	return GetCurrentPlaylistVarInt( "mode_fall_ltm", 0 ) == 1
}


table<int, array<entity> > function ArrangePlayersByTeam( array<entity> players )
{
	table<int, array<entity> > out = {}
	foreach ( entity player in players )
	{
		int team = player.GetTeam()
		if ( team in out )
			out[team].append( player )
		else
			out[team] <- [ player ]
	}
	return out
}


vector function MapAngleToRadius( float angle, float radius )
{
	float offsetX = radius * cos( angle * (PI / 180) )
	float offsetY = radius * sin( angle * (PI / 180) )
	vector offset = (< offsetX, offsetY, 0 >)
	return offset
}


void function GivePlayerSettingsMods( entity player, array<string> additionalMods )
{
	#if CLIENT
		if ( !player.GetPredictable() )
			return
	#endif

	array<string> mods = player.GetPlayerSettingsMods()
	mods.extend( additionalMods )                     
	int oldMaxHealth = player.GetMaxHealth()
	int oldHealth    = player.GetHealth()

#if CLIENT
	if ( InPrediction() )
#endif
	{
		#if CLIENT
			Assert( additionalMods.len() == 1 )
		#endif
		if ( additionalMods.len() == 1 )
		{
			player.AddPlayerClassMod( additionalMods[ 0 ] )
		}
		else
		{
			#if SERVER
				                                                                    
			#endif
		}
	}

	#if SERVER
		                        
		 
			                                   
			                             
		 
		                                       
	#endif
}


void function TakePlayerSettingsMods( entity player, array<string> modsToTake )
{
	array<string> mods = player.GetPlayerSettingsMods()
	int oldMaxHealth = player.GetMaxHealth()
	int oldHealth    = player.GetHealth()

#if CLIENT
	if ( InPrediction() )
#endif
	{
		#if CLIENT
			Assert( modsToTake.len() == 1 )
		#endif
		if ( modsToTake.len() == 1 && mods.contains( modsToTake[ 0 ] ) )
		{
			player.RemovePlayerClassMod( modsToTake[ 0 ] )
		}
		else
		{
			foreach ( string modToTake in modsToTake )
				mods.fastremovebyvalue( modToTake )

			#if SERVER
				                                                                    
			#endif
		}
	}


	#if SERVER
		                        
		 
			                                   
			                             
		 
		                                       
	#endif
}


bool function Placement_IsHitEntScriptedPlaceable( entity hitEnt, int depth )
{
	if ( hitEnt.IsWorld() )
		return false

	var hitEntClassname = hitEnt.GetNetworkedClassName()
	if ( hitEntClassname == "func_brush" || hitEntClassname == "script_mover" || hitEntClassname == "func_brush_lightweight" )
	{
		return true
	}

	if ( ALLOWED_SCRIPT_PARENT_ENTS.contains( hitEnt.GetScriptName() ) )
	{
		return true
	}

	if ( depth > 0 )
	{
		if ( IsValid( hitEnt.GetParent() ) )
		{
			return Placement_IsHitEntScriptedPlaceable( hitEnt.GetParent(), depth - 1 )
		}
	}

	return false
}

#if SERVER
                                                      
 
	                                                 

	                       
		      

	                         
		      

	                   
	                                                                    

	           

	                        
	 
		                     
		                                             
	 

 

                                                                                 
 
	                                                 

	                                         
	          

	                                             
	 
		                                         
		                                     
	 

	                                          
	 
		                                      
		                                  
	 
 


                                                                                                                                                                   
 
	                                                               

	                                                                                                       
	                                         
	                                  
	                                                                 
	                                                                      

	                                
		                                                           

	                                       
	                                                       

	                             
	                                             
	                   

	              
 

                                                                                                                                                                
 
	                                                               

	                                                                                                    
	                                      
	                               
	                                                           
	                                                                

	                                
		                                                        

	                                    
	                                                    

	                             
	                                       
	                   

	              
 

                                                                                                                                                                                   
 
	                                                               

	                                                                                                       
	                                         
	                                  
	                                                                 
	                                                                                                       
	                                                                  
	                                       
	                                                       

	                                                                                                    
	                                      
	                               
	                                                           
	                                                                
	                                    
	                                                    

	                             
	                                             
	                                       
	                   

	              
 
#endif         


void function AddEntToInvalidEntsForPlacingPermanentsOnto( entity ent )
{
	Assert( !file.invalidEntsForPlacingPermanentsOnto.contains( ent ) )
	file.invalidEntsForPlacingPermanentsOnto.append( ent )
}


void function RemoveEntFromInvalidEntsForPlacingPermanentsOnto( entity ent )
{
	Assert( file.invalidEntsForPlacingPermanentsOnto.contains( ent ) )
	file.invalidEntsForPlacingPermanentsOnto.removebyvalue( ent )
}


bool function IsEntInvalidForPlacingPermanentOnto( entity ent )
{
	return file.invalidEntsForPlacingPermanentsOnto.contains( ent )
}


void function AddRefEntAreaToInvalidOriginsForPlacingPermanentsOnto( entity refEnt, vector areaMin, vector areaMax )
{
	Assert( !(refEnt in file.invalidAreasRelativeToEntForPlacingPermanentsOnto) )

	RefEntAreaData data
	data.areaMin = areaMin
	data.areaMax = areaMax

	file.invalidAreasRelativeToEntForPlacingPermanentsOnto[refEnt] <- data
}


void function RemoveRefEntAreaFromInvalidOriginsForPlacingPermanentsOnto( entity refEnt )
{
	if ( refEnt in file.invalidAreasRelativeToEntForPlacingPermanentsOnto )
	{
		delete file.invalidAreasRelativeToEntForPlacingPermanentsOnto[ refEnt ]
	}
	else
	{
		Assert( 0, "Ref ent is not in table of ref ent areas." )
	}
}


bool function IsOriginInvalidForPlacingPermanentOnto( vector origin )
{
	foreach ( entity refEnt, RefEntAreaData data in file.invalidAreasRelativeToEntForPlacingPermanentsOnto )
	{
		if ( !IsValid( refEnt ) )
			continue

		vector localPos = WorldPosToLocalPos_NoEnt( origin, refEnt.GetOrigin(), refEnt.GetAngles() )

		if ( localPos.x > data.areaMin.x && localPos.x < data.areaMax.x
		&& localPos.y > data.areaMin.y && localPos.y < data.areaMax.y
		&& localPos.z > data.areaMin.z && localPos.z < data.areaMax.z )
			return true
	}

	return false
}
int function GetWeaponIndex( entity player, entity weapon )
{
	array<int> primarySlots          = [ WEAPON_INVENTORY_SLOT_PRIMARY_0, WEAPON_INVENTORY_SLOT_PRIMARY_1 ]
	foreach ( slot in primarySlots )
	{
		if ( player.GetNormalWeapon( slot ) == weapon )
			return slot
	}
	return -1
}

#if SERVER
                                                                 
 
	                                                       
		      

	                            
	 
		                             

		                                                     
		                                  
		 
			                        
				                                                     
		   

		                                             
			           
	   
 
#endif

void function OverrideUpdraftTriggerSettings (  UpdraftTriggerSettings customSettings )
{
	file.updraftSettings = customSettings
}

void function OnEnterUpdraftTrigger( entity trigger, entity ent, float activationHeight )
{
	Assert( IsValid( trigger ) )
	Assert( IsValid( ent ) )

	if ( !ent.IsPlayer() )
		return

	float entZ = ent.GetOrigin().z

	ent.Player_EnterUpdraft( file.updraftSettings.minShakeActivationHeight + entZ, entZ - file.updraftSettings.maxShakeActivationHeight, activationHeight, file.updraftSettings.liftSpeed, file.updraftSettings.liftAcceleration, file.updraftSettings.liftExitDuration );
}

void function OnLeaveUpdraftTrigger( entity trigger, entity ent )
{
	if ( !IsValid( trigger ) )
		return

	if ( !IsValid( ent ) )
		return

	if ( !ent.IsPlayer() )
		return

	ent.Player_LeaveUpdraft()
}


                               
RingBuffer function RingBuffer_Init( int maxSize )
{
	RingBuffer rb
	rb.arr     = []
	rb.arr.resize( maxSize, null )
	rb.readIdx = 0
	rb.writeIdx = 0
	rb.sizeMax = maxSize
	rb.sizeFilled = 0

	return rb
}

void function RingBuffer_Clear( RingBuffer buffer )
{
	buffer.arr = []
	buffer.arr.resize( buffer.sizeMax, null )
	buffer.readIdx = 0
	buffer.writeIdx = 0
	buffer.sizeFilled = 0
}

int function RingBuffer_GetSizeFilled( RingBuffer buffer )
{
	return buffer.sizeFilled
}

int function RingBuffer_GetSizeMax( RingBuffer buffer )
{
	return buffer.sizeMax
}

bool function RingBuffer_IsFull( RingBuffer buffer )
{
	return buffer.sizeFilled >= buffer.arr.len()
}

bool function RingBuffer_IsEmpty( RingBuffer buffer )
{
	return buffer.sizeFilled == 0
}

                                                                                           
void function RingBuffer_Enqueue( RingBuffer buffer, var item )
{
	buffer.arr[ buffer.writeIdx ] = item
	buffer.writeIdx = (buffer.writeIdx + 1) % buffer.sizeMax
	buffer.sizeFilled = minint( buffer.sizeFilled + 1, buffer.sizeMax )
}

                                      
var function RingBuffer_Dequeue( RingBuffer buffer )
{
	var res = buffer.arr[ buffer.readIdx ]
	buffer.readIdx = (buffer.readIdx + 1) % buffer.sizeMax
	buffer.sizeFilled = maxint( buffer.sizeFilled - 1, 0 )

	return res
}


                             
RingBufferEntity function RingBufferEntity_Init( int maxSize )
{
	RingBufferEntity rb
	rb.arr     = []
	rb.arr.resize( maxSize, null )
	rb.readIdx = 0
	rb.writeIdx = 0
	rb.sizeMax = maxSize
	rb.sizeFilled = 0

	return rb
}

void function RingBufferEntity_Clear( RingBufferEntity buffer )
{
	buffer.arr = []
	buffer.arr.resize( buffer.sizeMax, null )
	buffer.readIdx = 0
	buffer.writeIdx = 0
	buffer.sizeFilled = 0
}

int function RingBufferEntity_GetSizeFilled( RingBufferEntity buffer )
{
	return buffer.sizeFilled
}

int function RingBufferEntity_GetSizeMax( RingBufferEntity buffer )
{
	return buffer.sizeMax
}

bool function RingBufferEntity_IsFull( RingBufferEntity buffer )
{
	return buffer.sizeFilled >= buffer.sizeMax
}

bool function RingBufferEntity_IsEmpty( RingBufferEntity buffer )
{
	return buffer.sizeFilled == 0
}

                                                                                           
void function RingBufferEntity_Enqueue( RingBufferEntity buffer, entity item )
{
	buffer.arr[ buffer.writeIdx ] = item
	buffer.writeIdx = (buffer.writeIdx + 1) % buffer.sizeMax
	buffer.sizeFilled = minint( buffer.sizeFilled + 1, buffer.sizeMax )
}

                                      
entity function RingBufferEntity_Dequeue( RingBufferEntity buffer )
{
	entity res = buffer.arr[ buffer.readIdx ]
	buffer.readIdx = (buffer.readIdx + 1) % buffer.sizeMax
	buffer.sizeFilled = maxint( buffer.sizeFilled - 1, 0 )

	return res
}

void function ManageJitterVFX_Thread()
{
	float intervalA = 10.0
	float intervalB = 0.2
	int cycles = 0
	int seedInt = 3910
	var seed = CreateRandomSeed( seedInt )

	string playlistName = GetCurrentPlaylistName()
	float phaseOneFast_Lower = GetPlaylistVarFloat( playlistName, "phaseEngine_one_fast_lower",  0.05 )
	float phaseOneFast_Upper = GetPlaylistVarFloat( playlistName, "phaseEngine_one_fast_upper",  0.2 )
	float phaseOneSlow_Lower = GetPlaylistVarFloat( playlistName, "phaseEngine_one_slow_lower",  10.0 )
	float phaseOneSlow_Upper = GetPlaylistVarFloat( playlistName, "phaseEngine_one_slow_upper",  20.0 )
	float phaseTwo_Lower = GetPlaylistVarFloat( playlistName, "phaseEngine_two_lower",  0.1 )
	float phaseTwo_Upper = GetPlaylistVarFloat( playlistName, "phaseEngine_two_upper",  0.4 )

	while( true )
	{
		++cycles
		SetConVarInt( "glitch_aberrationScale", 10 )
		wait intervalA
		if( cycles % 5 == 0 )
		{
			intervalA = RandomFloatRangeSeeded( seed, phaseOneFast_Lower, phaseOneFast_Upper )
		}
		else
		{
			intervalA = RandomFloatRangeSeeded( seed, phaseOneSlow_Lower, phaseOneSlow_Upper )
		}
		#if DEV
			                             
		#endif
		SetConVarInt( "glitch_aberrationScale", 80 )
		wait intervalB
		#if DEV
			                             
		#endif
		intervalB = RandomFloatRangeSeeded( seed, phaseTwo_Lower, phaseTwo_Upper )
	}
}