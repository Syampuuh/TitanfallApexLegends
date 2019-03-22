global function ShApexScreens_Init

#if(false)




#endif

#if(false)




#endif

#if(CLIENT)
global function ClApexScreens_DisableAllScreens
global function ClApexScreens_EnableAllScreens
global function ServerToClient_ApexScreenKillDataChanged
//
//
global function ClApexScreens_OnStaticPropRuiVisibilityChange
#endif

#if CLIENT && DEV 
global function DEV_CreatePerfectApexScreen
global function DEV_ToggleActiveApexScreenDebug
global function DEV_ToggleFloatyBitsPrototype
#endif

const float APEX_SCREEN_TRANSITION_IN_DURATION = 0.7 //

const float APEX_SCREEN_RANDOM_TINT_INTENSITY_MIN = 0.4
const float APEX_SCREEN_RANDOM_TINT_INTENSITY_MAX = 0.6
const vector[3] APEX_SCREEN_RANDOM_TINT_PALETTE = [
			<1.0, 1.0, 1.0> - <0.85, 0.87, 0.88>,
			<1.0, 1.0, 1.0> - <0.80, 0.95, 1.00>,
			<1.0, 1.0, 1.0> - <0.98, 1.00, 1.00>,
]


//
//


enum eApexScreenPosition
{
	//
	L = 0,
	C = 1,
	R = 2,

	_COUNT,
	DISABLED = -1,
}

global enum eApexScreenMode
{
	//
	OFF = 0,
	LOGO = 1,
	PLAYER_NAME_CHAMPION = 2,
	PLAYER_NAME_KILLLEADER = 3,
	GCARD_FRONT_CLEAN = 4,
	GCARD_FRONT_DETAILS = 5,
	GCARD_BACK = 6,
	UNUSED = 7,
	CIRCLE_STATE = 8,
	PLAYERS_REMAINING = 9,
	SQUADS_REMAINING = 10,
	ZONE_NAME = 11,
	ZONE_LOOT = 12,

	_COUNT,
	INVALID = -1,
}

global enum eApexScreenTransitionStyle
{
	//
	NONE = 0,
	SLIDE = 1,
	FADE_TO_BLACK = 2,
}


global enum eApexScreenMods
{
	RED = (1 << 0),
}


#if(CLIENT)
struct ApexScreenState
{
	var    rui
	int    magicId
	string mockup
	asset  ruiToCreate

	vector uvMin = <0.0, 0.0, 0.0>
	vector uvMax = <1.0, 1.0, 0.0>
	bool   sharesPropWithEnvironmentalRUI = false

	bool  visibleInPVS = false
	bool  isOutsideCircle = false
	int   currentMode
	float commenceTime

	int    position = -1
	vector spawnOrigin
	vector spawnForward
	vector spawnRight
	vector spawnUp
	float  spawnScale
	vector spawnMins
	vector spawnMaxs
	float  diagonalSize
	int    modBits = 0x00000000

	float                      currDistToSizeRatio = -1.0
	NestedGladiatorCardHandle& nestedGladiatorCard0Handle

	vector tint

	var    floatingTopo = null
	var    floatingRui = null
	var[3] floatingNestedBadgeRuiList = [null, null, null]
}
#endif


#if(CLIENT)
struct ApexScreenPositionMasterState
{
	float commenceTime = -1
	int   modeIndex = eApexScreenMode.LOGO
	int   transitionStyle = -1
	EHI   playerEHI
}
#endif


#if(false)





#endif


struct {
	#if(false)

#endif

	#if(CLIENT)
		ApexScreenPositionMasterState[eApexScreenPosition._COUNT] screenPositionMasterStates

		bool                        forceDisableScreens = false
		array<ApexScreenState>      staticScreenList
		bool                        allScreenUpdateQueued = false
		table<int, ApexScreenState> magicIdScreenStateMap
		table<int, array<var> >     environmentalRUIListMapByMagicId
		int                         killScreenDamageSourceID = -1
		float                       killScreenDistance
		int                         killedPlayerGrade
		string                      killedPlayerName
		table                       signalDummy

		bool DEV_activeScreenDebug = false
		bool DEV_isFloatyBitsPrototypeEnabled = false
	#endif
} file


#if(CLIENT)
void function ShApexScreens_Init()
{
	#if(false)
#elseif(CLIENT)
		AddCallback_OnEnumStaticPropRui( OnEnumStaticPropRui )
	#endif

	if ( !IsLobby() && !GetCurrentPlaylistVarBool( "enable_apex_screens", true ) )
		return

	Remote_RegisterClientFunction( "ServerToClient_ApexScreenKillDataChanged", "int", 0, 512, "float", 0.0, 10000.0, 32, "int", 0, 32, "entity" )

	for ( int screenPosition = eApexScreenPosition.L; screenPosition <= eApexScreenPosition.R; screenPosition++ )
	{
		RegisterNetworkedVariable( format( "ApexScreensMasterState_Pos%d_CommenceTime", screenPosition ), SNDC_GLOBAL, SNVT_TIME, -1 )
		RegisterNetworkedVariable( format( "ApexScreensMasterState_Pos%d_ModeIndex", screenPosition ), SNDC_GLOBAL, SNVT_INT, -1 )
		RegisterNetworkedVariable( format( "ApexScreensMasterState_Pos%d_TransitionStyle", screenPosition ), SNDC_GLOBAL, SNVT_INT, -1 )
		RegisterNetworkedVariable( format( "ApexScreensMasterState_Pos%d_Player", screenPosition ), SNDC_GLOBAL, SNVT_BIG_INT, -1 )

		#if(CLIENT)
			RegisterNetworkedVariableChangeCallback_time( format( "ApexScreensMasterState_Pos%d_CommenceTime", screenPosition ), void function( entity unused, float old, float new, bool ac ) : (screenPosition) {
				file.screenPositionMasterStates[screenPosition].commenceTime = new
				UpdateAllScreensContent()
			} )
			RegisterNetworkedVariableChangeCallback_int( format( "ApexScreensMasterState_Pos%d_ModeIndex", screenPosition ), void function( entity unused, int old, int new, bool ac ) : (screenPosition) {
				file.screenPositionMasterStates[screenPosition].modeIndex = new
				UpdateAllScreensContent()
			} )
			RegisterNetworkedVariableChangeCallback_int( format( "ApexScreensMasterState_Pos%d_TransitionStyle", screenPosition ), void function( entity unused, int old, int new, bool ac ) : (screenPosition) {
				file.screenPositionMasterStates[screenPosition].transitionStyle = new
				UpdateAllScreensContent()
			} )
			RegisterNetworkedVariableChangeCallback_int( format( "ApexScreensMasterState_Pos%d_Player", screenPosition ), void function( entity unused, int old, int new, bool ac ) : (screenPosition) {
				file.screenPositionMasterStates[screenPosition].playerEHI = new
				UpdateAllScreensContent()
			} )
		#endif
	}

	#if(false)






#elseif(CLIENT)
		RegisterSignal( "UpdateScreenCards" )
		RegisterSignal( "ScreenOff" )

		AddCallback_OnStaticPropRUICreated( ClientStaticPropRUICreated )
	#endif

	//
}
#endif



//
//
//
//
//

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
//
//
//

#endif


#if(false)






//

#endif


#if(false)








//

#endif


#if(false)







//
//





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

































#endif


#if(false)





#endif


#if(false)








//
//
//





#endif


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


#if(CLIENT)
void function ClApexScreens_DisableAllScreens()
{
	Assert( !file.forceDisableScreens )
	file.forceDisableScreens = true
	UpdateAllScreensContent()
}
#endif


#if(CLIENT)
void function ClApexScreens_EnableAllScreens()
{
	Assert( file.forceDisableScreens )
	file.forceDisableScreens = false
	UpdateAllScreensContent()
}
#endif


#if(CLIENT)
void function UpdateAllScreensContent()
{
	if ( !GetCurrentPlaylistVarBool( "enable_apex_screens", true ) )
		return

	//

	if ( !IsValid( clGlobal.levelEnt ) )
		return //

	if ( file.allScreenUpdateQueued )
		return
	file.allScreenUpdateQueued = true

	thread UpdateAllScreensContentThread()
}
void function UpdateAllScreensContentThread()
{
	WaitEndFrame()
	file.allScreenUpdateQueued = false
	UpdateScreensContent( file.staticScreenList )
}
#endif


#if(CLIENT)
void function ClApexScreens_OnStaticPropRuiVisibilityChange( array<int> newlyVisible, array<int> newlyHidden )
{
	array<ApexScreenState> screensToUpdate = []

	foreach( int magicId in newlyHidden )
	{
		if ( !(magicId in file.magicIdScreenStateMap) )
			continue //

		ApexScreenState screen = file.magicIdScreenStateMap[magicId]

		Assert( screen.visibleInPVS )

		screen.visibleInPVS = false
		screensToUpdate.append( screen )
	}

	foreach( int magicId in newlyVisible )
	{
		if ( !(magicId in file.magicIdScreenStateMap) )
			continue //

		ApexScreenState screen = file.magicIdScreenStateMap[magicId]

		Assert( !screen.visibleInPVS )

		screen.visibleInPVS = true
		screensToUpdate.append( screen )
	}

	UpdateScreensContent( screensToUpdate )
}
#endif


#if CLIENT && DEV 
void function DEV_ToggleActiveApexScreenDebug()
{
	file.DEV_activeScreenDebug = !file.DEV_activeScreenDebug
	thread DEV_ActiveApexScreenDebugThread()
}
void function DEV_ActiveApexScreenDebugThread()
{
	RegisterSignal( "DEV_ActiveApexScreenDebugThread" )
	Signal( clGlobal.levelEnt, "DEV_ActiveApexScreenDebugThread" )
	EndSignal( clGlobal.levelEnt, "DEV_ActiveApexScreenDebugThread" )

	const float interval = 0.3

	while ( file.DEV_activeScreenDebug )
	{
		wait interval

		int totalCount = 0, activeCount = 0, activeTVCount = 0
		foreach( ApexScreenState screen in file.staticScreenList )
		{
			totalCount += 1

			if ( screen.visibleInPVS )
			{
				activeCount += 1
				DebugDrawRotatedBox( <0, 0, 0>, screen.spawnMins + <-1, -1, -3>, screen.spawnMaxs + <-1, -1, -3>, <0, 0, 0>, 140, 185, 255, true, interval + 0.1 )
			}
			else
			{
				DebugDrawRotatedBox( <0, 0, 0>, screen.spawnMins + <-1, -1, -3>, screen.spawnMaxs + <-1, -1, -3>, <0, 0, 0>, 25, 25, 80, true, interval + 0.1 )
			}
		}
		printt( "ACTIVE SCREEN COUNT: " + activeCount + " (of " + totalCount + ") (" + activeTVCount + " TVs)" )
	}
}
#endif


#if CLIENT && DEV 
void function DEV_ToggleFloatyBitsPrototype()
{
	file.DEV_isFloatyBitsPrototypeEnabled = !file.DEV_isFloatyBitsPrototypeEnabled
	UpdateAllScreensContent()
}
#endif


#if(CLIENT)
void function UpdateScreensContent( array<ApexScreenState> screenList )
{
	foreach( ApexScreenState screen in screenList )
	{
		bool shouldShow = true

		if ( file.forceDisableScreens )
			shouldShow = false
		else if ( !screen.visibleInPVS )
			shouldShow = false
		else if ( screen.position == eApexScreenPosition.DISABLED )
			shouldShow = false
		else if ( screen.isOutsideCircle )
			shouldShow = false

		if ( shouldShow )
		{
			if ( screen.rui == null )
			{
				screen.rui = CreateApexScreenRUIElement( screen )
				if ( screen.rui != null )
				{
					screen.nestedGladiatorCard0Handle = CreateNestedGladiatorCard( screen.rui, "card0", eGladCardDisplaySituation.APEX_SCREEN_STILL, eGladCardPresentation.OFF )
				}
				else
				{
					shouldShow = false
				}
			}
		}
		else if ( screen.rui != null )
		{
			screen.commenceTime = -1.0
			Signal( screen, "ScreenOff" ) //

			CleanupNestedGladiatorCard( screen.nestedGladiatorCard0Handle )
			RuiDestroyIfAlive( screen.rui )
			screen.rui = null
		}

		bool shouldShowFloatyBit = (shouldShow && file.DEV_isFloatyBitsPrototypeEnabled)
		if ( shouldShowFloatyBit )
		{
			if ( screen.floatingRui == null )
			{
				float ruiWidth  = 800.0, ruiHeight = 800.0
				float ruiAspect = ruiWidth / ruiHeight

				float downOffset = 520.0//
				float gap        = 50.0

				vector floatyForward = screen.spawnRight //
				vector floatyRight   = screen.spawnForward //
				vector floatyUp      = -screen.spawnUp //
				vector floatyCenter  = screen.spawnOrigin
				floatyCenter += -downOffset * screen.spawnUp * screen.spawnScale
				floatyCenter += gap * floatyForward * screen.spawnScale

				DebugDrawAxis( floatyCenter, VectorToAngles( floatyForward ), 5.0 )

				float floatyWidth = 360.0 * screen.spawnScale

				float floatyHeight = floatyWidth / ruiAspect
				screen.floatingTopo = RuiTopology_CreatePlane(
							floatyCenter - 0.5 * floatyRight * floatyWidth - 0.5 * floatyUp * floatyHeight,
							floatyRight * floatyWidth, floatyUp * floatyHeight, false
				)

				//
				//
				//
				//
				//
				//
				//
				//
				//
				//
				//
				//
				//
				//

				screen.floatingRui = RuiCreate( $"ui/apex_screen_floaty_thing.rpak", screen.floatingTopo, RUI_DRAW_WORLD, 0 )
				RuiKeepSortKeyUpdated( screen.floatingRui, true, "pos" )
				RuiSetFloat3( screen.floatingRui, "pos", screen.spawnOrigin )
			}
		}
		else if ( screen.floatingRui != null )
		{
			foreach ( int badgeIndex, var nestedRui in screen.floatingNestedBadgeRuiList )
			{
				if ( nestedRui != null )
				{
					RuiDestroyNested( screen.floatingRui, "badge" + badgeIndex + "Instance" )
					screen.floatingNestedBadgeRuiList[badgeIndex] = null
				}
			}
			RuiDestroy( screen.floatingRui )
			screen.floatingRui = null
			RuiTopology_Destroy( screen.floatingTopo )
			screen.floatingTopo = null
		}

		if ( !shouldShow )
			continue

		ApexScreenPositionMasterState masterState = file.screenPositionMasterStates[screen.position]
		float desiredCommenceTime                 = masterState.commenceTime
		int desiredMode                           = masterState.modeIndex
		int desiredTransitionStyle                = masterState.transitionStyle
		EHI desiredPlayerEHI                      = masterState.playerEHI

		bool didChange = false
		if ( desiredCommenceTime != screen.commenceTime )
		{
			didChange = true
			screen.commenceTime = desiredCommenceTime
			screen.currentMode = desiredMode
		}

		if ( didChange )
		{
			RuiSetGameTime( screen.rui, "commenceTime", desiredCommenceTime )
			RuiSetInt( screen.rui, "modeIndex", desiredMode )
			RuiSetInt( screen.rui, "transitionStyle", desiredTransitionStyle )

			int gcardPresentation = eGladCardPresentation.OFF
			bool shouldShowName   = true
			int lifestateOverride = eGladCardLifestateOverride.NONE

			if ( desiredMode == eApexScreenMode.OFF )
			{
				//
			}
			else if ( desiredMode == eApexScreenMode.LOGO )
			{
				//
			}
			else if ( desiredMode == eApexScreenMode.PLAYER_NAME_CHAMPION )
			{
				//
			}
			else if ( desiredMode == eApexScreenMode.PLAYER_NAME_KILLLEADER )
			{
				//
			}
			else if ( desiredMode == eApexScreenMode.GCARD_FRONT_CLEAN )
			{
				gcardPresentation = eGladCardPresentation.FRONT_CLEAN
			}
			else if ( desiredMode == eApexScreenMode.GCARD_FRONT_DETAILS )
			{
				gcardPresentation = eGladCardPresentation.FRONT_DETAILS
			}
			else if ( desiredMode == eApexScreenMode.GCARD_BACK )
			{
				gcardPresentation = eGladCardPresentation.BACK
			}
			else if ( desiredMode == eApexScreenMode.UNUSED )
			{
				//
			}
			else if ( desiredMode == eApexScreenMode.CIRCLE_STATE )
			{
				//
			}
			else if ( desiredMode == eApexScreenMode.PLAYERS_REMAINING )
			{
				//
			}
			else if ( desiredMode == eApexScreenMode.SQUADS_REMAINING )
			{
				//
			}
			else if ( desiredMode == eApexScreenMode.ZONE_NAME )
			{
				//
			}
			else if ( desiredMode == eApexScreenMode.ZONE_LOOT )
			{
				//
			}

			if ( gcardPresentation == eGladCardPresentation.FRONT_DETAILS && file.DEV_isFloatyBitsPrototypeEnabled )
				gcardPresentation = eGladCardPresentation.PROTO_FRONT_DETAILS_NO_BADGES

			thread UpdateScreenDetails( screen, desiredTransitionStyle, gcardPresentation, desiredPlayerEHI, lifestateOverride )
		}
	}
}
#endif


#if(CLIENT)
void function UpdateScreenDetails( ApexScreenState screen, int transitionStyle, int gcardPresentation, EHI playerEHI, int lifestateOverride )
{
	Signal( screen, "UpdateScreenCards" )
	EndSignal( screen, "UpdateScreenCards" )
	EndSignal( screen, "ScreenOff" )

	float modeChangeTime = screen.commenceTime
	if ( transitionStyle != eApexScreenTransitionStyle.NONE )
		modeChangeTime += APEX_SCREEN_TRANSITION_IN_DURATION

	if ( modeChangeTime - Time() > 0.02 )
		wait (modeChangeTime - Time())

	//

	string playerName = ""
	if ( EHIHasValidScriptStruct( playerEHI ) )
		playerName = EHI_GetName( playerEHI )
	//
	//
	//
	//
	//
	//
	//
	RuiSetString( screen.rui, "playerName", playerName )

	entity player = FromEHI( playerEHI ) //
	if ( IsValid( player ) )
		RuiTrackInt( screen.rui, "playerKillCount", player, RUI_TRACK_SCRIPT_NETWORK_VAR_INT, GetNetworkedVariableIndex( "kills" ) )

	RuiSetFloat( screen.rui, "xpBonusAmount", XpEventTypeData_GetAmount( XP_TYPE.KILL_CHAMPION_MEMBER ) )

	ChangeNestedGladiatorCardPresentation( screen.nestedGladiatorCard0Handle, gcardPresentation )
	ChangeNestedGladiatorCardOwner( screen.nestedGladiatorCard0Handle, playerEHI, modeChangeTime, lifestateOverride )

	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
}
#endif


#if(CLIENT)
void function ClientStaticPropRUICreated( StaticPropRui propRui, var ruiInstance )
{
	if ( !(propRui.magicId in file.environmentalRUIListMapByMagicId) )
	{
		file.environmentalRUIListMapByMagicId[propRui.magicId] <- []
	}
	file.environmentalRUIListMapByMagicId[propRui.magicId].append( ruiInstance )
}
#endif


#if(CLIENT)
bool function OnEnumStaticPropRui( StaticPropRui staticPropRuiInfo )
{
	if ( !GetCurrentPlaylistVarBool( "enable_apex_screens", true ) )
		return (staticPropRuiInfo.mockupName.find( "apex_screen" ) != -1)
	//

	ApexScreenState apexScreen
	apexScreen.magicId = staticPropRuiInfo.magicId
	apexScreen.rui = null
	apexScreen.spawnOrigin = staticPropRuiInfo.spawnOrigin
	apexScreen.spawnForward = Normalize( staticPropRuiInfo.spawnForward )
	apexScreen.spawnRight = Normalize( staticPropRuiInfo.spawnRight )
	apexScreen.spawnUp = Normalize( staticPropRuiInfo.spawnUp )
	apexScreen.spawnScale = Length( staticPropRuiInfo.spawnForward )
	apexScreen.spawnMins = staticPropRuiInfo.spawnMins
	apexScreen.spawnMaxs = staticPropRuiInfo.spawnMaxs
	apexScreen.ruiToCreate = $"ui/apex_screen.rpak" //
	apexScreen.mockup = staticPropRuiInfo.mockupName
	apexScreen.diagonalSize = Distance( staticPropRuiInfo.spawnMins, staticPropRuiInfo.spawnMaxs )

	float tintIntensity = RandomFloatRange( APEX_SCREEN_RANDOM_TINT_INTENSITY_MIN, APEX_SCREEN_RANDOM_TINT_INTENSITY_MAX )
	apexScreen.tint = tintIntensity * APEX_SCREEN_RANDOM_TINT_PALETTE[RandomInt( APEX_SCREEN_RANDOM_TINT_PALETTE.len() )]

	if ( "apex_screen_mods" in staticPropRuiInfo.args )
	{
		string modsStr = staticPropRuiInfo.args.apex_screen_mods
		apexScreen.modBits = 0
		foreach( string modKey in GetTrimmedSplitString( modsStr, "," ) )
		{
			if ( modKey.toupper() in eApexScreenMods )
				apexScreen.modBits = apexScreen.modBits | eApexScreenMods[modKey.toupper()]
			else
				Warning( "Apex screen at " + apexScreen.spawnOrigin + " has unknown mod '" + modKey.toupper() + "' (" + modsStr + ")" )
		}
	}

	switch( staticPropRuiInfo.modelName )
	{
		case "mdl/eden\\beacon_small_screen_02_off.rmdl":
			apexScreen.uvMin = <0.0, 0.295, 0.0>
			apexScreen.uvMax = <1.0, 0.705, 0.0>
			break

		case "mdl/thunderdome\\apex_screen_05.rmdl":
			apexScreen.uvMin = <0.235, 0.0, 0.0>
			apexScreen.uvMax = <0.765, 1.0, 0.0>
			break

		case "mdl/thunderdome\\survival_modular_flexscreens_01.rmdl":
		case "mdl/thunderdome\\survival_modular_flexscreens_02.rmdl":
		case "mdl/thunderdome\\survival_modular_flexscreens_03.rmdl":
		case "mdl/thunderdome\\survival_modular_flexscreens_04.rmdl":
			apexScreen.uvMin = <0.323, 0.0, 0.0>
			apexScreen.uvMax = <0.684, 1.0, 0.0>
			break

		case "mdl/thunderdome\\survival_modular_flexscreens_05.rmdl":
			apexScreen.uvMin = <0.0, 0.215, 0.0>
			apexScreen.uvMax = <1.0, 0.785, 0.0>
			break

		default:
			return false //
			//
			//
			//
			//
			break
	}

	float uvWidth           = (apexScreen.uvMax.x - apexScreen.uvMin.x)
	float uvHeight          = (apexScreen.uvMax.y - apexScreen.uvMin.y)
	float screenAspectRatio = (uvHeight < 0.0001) ? 0.0 : uvWidth / uvHeight
	bool isVertical         = (screenAspectRatio < 1.1)
	if ( !isVertical )
	{
		//
		apexScreen.position = eApexScreenPosition.DISABLED
	}
	else
	{
		switch( staticPropRuiInfo.scriptName )
		{
			case "leftScreen":
				apexScreen.position = eApexScreenPosition.L
				break

			case "rightScreen":
				apexScreen.position = eApexScreenPosition.R
				break

			default:
				apexScreen.position = eApexScreenPosition.C
				break
		}
	}

	Assert( string( apexScreen.ruiToCreate ) != "" )

	file.staticScreenList.append( apexScreen )
	file.magicIdScreenStateMap[apexScreen.magicId] <- apexScreen

	if ( apexScreen.sharesPropWithEnvironmentalRUI )
		return false //

	return true
}
#endif


#if(CLIENT)
var function CreateApexScreenRUIElement( ApexScreenState screen )
{
	var rui
	if ( screen.magicId == -1 )
	{
		#if(DEV)
			float aspectRatio = 1.0//
			float height      = screen.diagonalSize / sqrt( 1.0 + pow( aspectRatio, 2.0 ) )
			float width       = aspectRatio * height
			vector origin     = screen.spawnOrigin//
			var topo          = RuiTopology_CreatePlane( origin, <0, width, 0>, <0, 0, -height>, false )

			rui = RuiCreate( screen.ruiToCreate, topo, RUI_DRAW_WORLD, 32767 )
		#else
			return null
		#endif
	}
	else
	{
		StaticPropRui propStaticRuiInfo
		propStaticRuiInfo.ruiName = screen.ruiToCreate
		propStaticRuiInfo.magicId = screen.magicId
		rui = RuiCreateOnStaticProp( propStaticRuiInfo )
	}

	vector basePos = screen.spawnOrigin
	basePos.z -= (screen.spawnMaxs.z - screen.spawnMins.z)
	//
	RuiSetFloat3( rui, "screenWorldPos", basePos )
	RuiSetFloat( rui, "screenScale", screen.spawnScale )
	RuiSetFloat2( rui, "uvMin", screen.uvMin )
	RuiSetFloat2( rui, "uvMax", screen.uvMax )
	RuiSetInt( rui, "screenPosition", screen.position )
	RuiSetInt( rui, "modBits", screen.modBits )
	RuiSetFloat3( rui, "tintColor", screen.tint )
	RuiSetFloat( rui, "tintIntensity", 1.0 )

	if ( screen.sharesPropWithEnvironmentalRUI )
		RuiSetBool( rui, "sharesPropWithEnvironmentalRUI", true )

	//
	//

	return rui
}
#endif


#if CLIENT && DEV 
void function DEV_CreatePerfectApexScreen( vector origin, float diagonalSize, int screenPosition )
{
	ApexScreenState apexScreen
	apexScreen.magicId = -1
	apexScreen.rui = null
	apexScreen.spawnOrigin = origin
	apexScreen.ruiToCreate = $"ui/apex_screen.rpak"
	apexScreen.diagonalSize = diagonalSize
	apexScreen.position = screenPosition
	apexScreen.uvMin = <0.31, 0.0, 0.0>
	apexScreen.uvMax = <0.69, 1.0, 0.0>

	file.staticScreenList.append( apexScreen )

	UpdateScreensContent( [apexScreen] )
}
#endif



//
//
//
//
//

#if(CLIENT)
void function ServerToClient_ApexScreenKillDataChanged( int damageSourceID, float distanceBetweenPlayers, int killedPlayerGrade, entity killedPlayer )
{
	file.killScreenDamageSourceID = damageSourceID
	file.killScreenDistance = floor( distanceBetweenPlayers / 12 )
	file.killedPlayerGrade = killedPlayerGrade

	if ( IsValid( killedPlayer ) )
		file.killedPlayerName = killedPlayer.GetPlayerName()

	UpdateAllScreensContent()
}
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
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//


