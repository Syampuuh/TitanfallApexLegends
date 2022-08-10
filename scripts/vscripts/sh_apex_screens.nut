global function ShApexScreens_Init

#if SERVER
                                             
                                            
                                                              
                                                         
                                           
                                           
                                          
                                                           
                                                   
                                                       
                                                   
#endif

#if SERVER && DEV
                                       
                                                 
                                                   
                                     
#endif

#if CLIENT
global function ClApexScreens_DisableAllScreens
global function ClApexScreens_EnableAllScreens
global function ClApexScreens_IsDisabled
global function ServerToClient_ApexScreenKillDataChanged
global function ServerToClient_ApexScreenRefreshAll
                                             
                                                  
global function ClApexScreens_OnStaticPropRuiVisibilityChange
global function ClApexScreens_AddScreenOverride
global function ClApexScreens_GetCustomBannerScreen
global function ClApexScreens_PosInStaticBanner

global function ClApexScreens_SetCustomApexScreenBGAsset
global function ClApexScreens_SetCustomLogoTint
global function ClApexScreens_SetCustomLogoImage
global function ClApexScreens_SetCustomLogoSize
global function ClApexScreens_SetAnimatedLogoAsset
global function ClApexScreens_SetEventScreenOverride
#endif

global function GetCurrentPlaylistVarAsset

#if CLIENT && DEV
global function DEV_CreatePerfectApexScreen
global function DEV_ToggleActiveApexScreenDebug
#endif

global const string CUSTOM_BANNER_LEFT_SCRIPTNAME = "leftScreen_custom"
global const string CUSTOM_BANNER_CENTER_SCRIPTNAME = "centerScreen_custom"
global const string CUSTOM_BANNER_RIGHT_SCRIPTNAME = "rightScreen_custom"

const float APEX_SCREEN_TRANSITION_IN_DURATION = 0.7                                           

const float APEX_SCREEN_RANDOM_TINT_INTENSITY_MIN = 0.4
const float APEX_SCREEN_RANDOM_TINT_INTENSITY_MAX = 0.6
const vector[3] APEX_SCREEN_RANDOM_TINT_PALETTE = [
	<1.0, 1.0, 1.0> - <0.85, 0.87, 0.88>,
	<1.0, 1.0, 1.0> - <0.80, 0.95, 1.00>,
	<1.0, 1.0, 1.0> - <0.98, 1.00, 1.00>,
]

const asset BLANK_ASSET = $"ui/apex_screen_logo_only.rpak"

                                                         
                                                                                                                                                                          


global enum eApexScreenPosition
{
	                                    
	L = 0,
	C = 1,
	R = 2,
	_COUNT_BANNERTYPES,

	TV_LIKE = 3,

	DISABLED = -1,
}

global enum eApexScreenMode
{
	                                                    
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
	CAMERA_VIEW = 13,
	BG_NO_LOGO = 14,

	_COUNT,
	INVALID = -1,
}

global enum eApexScreenTransitionStyle
{
	                                                                
	NONE = 0,
	SLIDE = 1,
	FADE_TO_BLACK = 2,
}


global enum eApexScreenMods
{
	RED = (1 << 0),
}

global enum eApexScreenDisplayGroup
{
	DISPLAY_PLAYER,
	DISPLAY_PLAYER_SQUAD,
	DISPLAY_LOGOS,
	DISPLAY_CENTER_LOGO_ONLY,
	DISPLAY_RANDOM_PLAYERS
}

#if CLIENT
global struct ScreenOverrideInfo
{
	asset  ruiAsset
	string scriptNameRequired = ""
	bool   skipStandardVars

	  
	bool bindStartTimeVarToEventTimeA
	bool bindStartTimeVarToEventTimeB
	bool bindEventIntA

	struct
	{
		table<string, int>    ints
		table<string, float>  floats
		table<string, bool>   bools
		table<string, asset>  images
		table<string, string> strings
		table<string, vector> float3s
		table<string, vector> float2s
		table<string, float>  gametimes
	} vars
}
table<string, ScreenOverrideInfo> s_screenOverrides

global struct ApexScreenState
{
	var    rui

	var 	nestedRui

	int    magicId
	string mockup
	asset  ruiToCreate
	asset  ruiToCreateOrig
	asset  ruiLastCreated

	bool                overrideInfoIsValid = false
	ScreenOverrideInfo& overrideInfo

	vector uvMin = <0.0, 0.0, 0.0>
	vector uvMax = <1.0, 1.0, 0.0>
	bool   sharesPropWithEnvironmentalRUI = false

	bool  visibleInPVS = false
	bool  isOutsideCircle = false
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

	int updateSerialNum = 0
}
#endif


#if CLIENT
struct ApexScreenPositionMasterState
{
	float commenceTime = -1
	int   modeIndex = eApexScreenMode.LOGO
	int   transitionStyle = -1
	EHI   playerEHI
}
#endif


#if SERVER
                    
 
	                                  

 

                                     
 
	                     
	                                                       
	                                               
	                         
	                         
	                         
 
#endif


struct {
	#if SERVER && DEV
		                                   
	#endif

	#if SERVER
		                                                   
		                                                                      
		                               
	#endif

	#if CLIENT
		ApexScreenPositionMasterState[eApexScreenPosition._COUNT_BANNERTYPES] screenPositionMasterStates

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

		table<string, ApexScreenState> customBannerList

		bool DEV_activeScreenDebug = false

		asset bannerBGAssert = $"rui/rui_screens/banner_c"
		vector logoOverlayTint = < 1.0 , 1.0, 1.0 >
		vector logoSize = <562,407,0>
		asset logoImage = $"rui/rui_screens/apex_logo"
		asset animatedLogoAsset = $""

		table< int, ScreenOverrideInfo > eventScreenOverrideByScreenPosTable
	#endif
} file


#if SERVER || CLIENT
const string NV_ApexScreensEventTimeA = "NV_ApexScreensEventTimeA"
const string NV_ApexScreensEventTimeB = "NV_ApexScreensEventTimeB"
const string NV_ApexScreensEventIntA = "NV_ApexScreensEventIntA"
void function ShApexScreens_Init()
{
	#if SERVER
		                                                                               
	#elseif CLIENT
		AddCallback_OnEnumStaticPropRui( OnEnumStaticPropRui )
	#endif

	if ( !GetCurrentPlaylistVarBool( "enable_apex_screens", true ) )
		return

	#if SERVER
		                               
		 
			                                             
		 

		 
			                                
			                                                            
			                       
			                                                                                 
		 

		 
			                                
			                                                                     
			                        
			                                                                                 
		 

		 
			                                
			                                                             
			                        
			                                                               
			                                                                
			                                                                       
		 

		 
			                                
			                                                                   
			                        
			                                                               
			                                                                       
		 

		 
			                                
			                                                             
			                        
			                                                                 
			                                                                  
			                                                                       
		 

		 
			                                
			                                                                   
			                        
			                                                                 
			                                                                       
		 
	#endif

	Remote_RegisterClientFunction( "ServerToClient_ApexScreenKillDataChanged", "int", 0, 512, "float", 0.0, 10000.0, 32, "int", 0, 32, "entity" )
	Remote_RegisterClientFunction( "ServerToClient_ApexScreenRefreshAll" )

	for ( int screenPosition = eApexScreenPosition.L; screenPosition <= eApexScreenPosition.R; screenPosition++ )
	{
		RegisterNetworkedVariable( format( "ApexScreensMasterState_Pos%d_CommenceTime", screenPosition ), SNDC_GLOBAL, SNVT_TIME, -1 )
		RegisterNetworkedVariable( format( "ApexScreensMasterState_Pos%d_ModeIndex", screenPosition ), SNDC_GLOBAL, SNVT_INT, -1 )
		RegisterNetworkedVariable( format( "ApexScreensMasterState_Pos%d_TransitionStyle", screenPosition ), SNDC_GLOBAL, SNVT_INT, -1 )
		RegisterNetworkedVariable( format( "ApexScreensMasterState_Pos%d_Player", screenPosition ), SNDC_GLOBAL, SNVT_BIG_INT, -1 )

		#if CLIENT
			RegisterNetworkedVariableChangeCallback_time( format( "ApexScreensMasterState_Pos%d_CommenceTime", screenPosition ), void function( entity unused, float new ) : (screenPosition) {
				file.screenPositionMasterStates[screenPosition].commenceTime = new
				UpdateAllScreensContent()
			} )
			RegisterNetworkedVariableChangeCallback_int( format( "ApexScreensMasterState_Pos%d_ModeIndex", screenPosition ), void function( entity unused, int new ) : (screenPosition) {
				file.screenPositionMasterStates[screenPosition].modeIndex = new
				UpdateAllScreensContent()
			} )
			RegisterNetworkedVariableChangeCallback_int( format( "ApexScreensMasterState_Pos%d_TransitionStyle", screenPosition ), void function( entity unused, int new ) : (screenPosition) {
				file.screenPositionMasterStates[screenPosition].transitionStyle = new
				UpdateAllScreensContent()
			} )
			RegisterNetworkedVariableChangeCallback_int( format( "ApexScreensMasterState_Pos%d_Player", screenPosition ), void function( entity unused, int new ) : (screenPosition) {
				file.screenPositionMasterStates[screenPosition].playerEHI = new
				UpdateAllScreensContent()
			} )
		#endif          
	}

	RegisterNetworkedVariable( NV_ApexScreensEventTimeA, SNDC_GLOBAL, SNVT_TIME, -1 )
	#if CLIENT
		RegisterNetworkedVariableChangeCallback_time( NV_ApexScreensEventTimeA, void function( entity unused, float newTime )
		{
			OnUpdateApexScreensEventTime( newTime )
		} )
	#endif          
	RegisterNetworkedVariable( NV_ApexScreensEventTimeB, SNDC_GLOBAL, SNVT_TIME, -1 )
	RegisterNetworkedVariable( NV_ApexScreensEventIntA, SNDC_GLOBAL, SNVT_INT, -1 )

	#if SERVER
		                                         

		                                                                                          
		                                                                                    

		                                                
	#elseif CLIENT
		RegisterSignal( "UpdateScreenCards" )
		RegisterSignal( "ScreenOff" )

		AddCallback_OnStaticPropRUICreated( ClientStaticPropRUICreated )
	#endif

	                                                                                  
}
#endif

#if SERVER
                                                       
 
	                                                  
 

                                                       
 
	                                                  
 

                                                   
 
	                                               
 

#endif          

asset function CastStringToAsset( string val )
{
	return GetKeyValueAsAsset( { kn = val }, "kn" )
}


asset function GetCurrentPlaylistVarAsset( string varName, asset defaultAsset = $"" )
{
	string assetRaw = GetCurrentPlaylistVarString( varName, "" )
	if ( assetRaw.len() == 0 )
		return defaultAsset

	return CastStringToAsset( assetRaw )
}

#if CLIENT
vector function CastStringToFloat3( string val )
{
	array<string> fields = split( val, ", " )
	float xx             = ((fields.len() > 0) ? float( fields[0] ) : 0.0)
	float yy             = ((fields.len() > 1) ? float( fields[1] ) : 0.0)
	float zz             = ((fields.len() > 2) ? float( fields[2] ) : 0.0)
	return <xx, yy, zz>
}

void function SetupScreenOverridesFromPlaylist_S3Tease()
{
	for ( int overrideIdx = 0; overrideIdx < 5; ++overrideIdx )
	{
		                             
		string keyName = format( "apexscreen_tv_override_%d", overrideIdx )
		if ( !GetCurrentPlaylistVarBool( keyName, false ) )
			continue

		SetupScreenOverridesFromPlaylists( keyName )
	}
}

void function SetupScreenOverridesFromPlaylists( string playlistKey )
{
	ScreenOverrideInfo newInfo
	newInfo.scriptNameRequired = GetCurrentPlaylistVarString( format( "%s_scriptname", playlistKey ), "" )
	newInfo.ruiAsset = CastStringToAsset( GetCurrentPlaylistVarString( format( "%s_rui", playlistKey ), "" ) )
	newInfo.skipStandardVars = GetCurrentPlaylistVarBool( format( "%s_skip_standard_vars", playlistKey ), false )
	newInfo.bindStartTimeVarToEventTimeA = GetCurrentPlaylistVarBool( format( "%s_bind_startTime_var_to_event_a", playlistKey ), false )
	newInfo.bindStartTimeVarToEventTimeB = GetCurrentPlaylistVarBool( format( "%s_bind_startTime_var_to_event_b", playlistKey ), false )

	for ( int varIdx = 0; varIdx < 10; ++varIdx )
	{
		string varPlaylistKey = format( "%s_var%d", playlistKey, varIdx )
		string val            = GetCurrentPlaylistVarString( varPlaylistKey, "" )
		if ( val.len() == 0 )
			continue

		array<string> splitVals = split( val, "~" )
		Assert( (splitVals.len() == 3), format( "Key '%s' with val '%s' only has %d/3 fields.", varPlaylistKey, val, splitVals.len() ) )
		switch( splitVals[0] )
		{
			case "int":
				newInfo.vars.ints[splitVals[1]] <- int( splitVals[2] )
				break

			case "float":
				newInfo.vars.floats[splitVals[1]] <- float( splitVals[2] )
				break

			case "bool":
				newInfo.vars.bools[splitVals[1]] <- ((int( splitVals[2] ) != 0) || (splitVals[2] == "true"))
				break

			case "string":
				newInfo.vars.strings[splitVals[1]] <- splitVals[2]
				break

			case "image":
				newInfo.vars.images[splitVals[1]] <- CastStringToAsset( splitVals[2] )
				break

			case "float3":
				newInfo.vars.float3s[splitVals[1]] <- CastStringToFloat3( splitVals[2] )
				break

			case "float2":
				newInfo.vars.float2s[splitVals[1]] <- CastStringToFloat3( splitVals[2] )
				break

			default:
				Assert( false, format( "Unhandled field type '%s'.", splitVals[0] ) )
				break
		}
	}
}

void function ClApexScreens_AddScreenOverride( ScreenOverrideInfo newInfo )
{
	s_screenOverrides[newInfo.scriptNameRequired] <- newInfo
}


ApexScreenState function ClApexScreens_GetCustomBannerScreen( string teaseScreenKey )
{
	return file.customBannerList[ teaseScreenKey ]
}
#endif          


    
    
                                 
    
    

#if SERVER
                                                                                                           
 
	       
		                                  
			      
	      

	                                                                                                                      
	                                                                                                                      
	                                                                                                                      
	                              
 
#endif


#if SERVER
                                             
 
	       
		                                  
			      
	      
	                      
	                                                                                                                 
	                                                                                                                 
	                                                                                                                 
	                                
 
#endif


#if SERVER
                                                                                                                                                                           
 
	       
		                                  
			      
	      

	                                                                
		      

	                                                     
		                                                                                                                                                                 

	                      
	                                                                                                         
	                                                                                                                        
	                                                                                                         
	                                
 
#endif


#if SERVER
                                                         
 
	       
		                                  
			      
	      
	           
 
#endif


#if SERVER
                                                                                                             
 
	                                                                
		      

	                                                                 
	                                                                                                 
	                                                                                           
	                                                                                                            
	                                                                                                         
 
#endif


#if SERVER
                                 
 
	                
		      

	                                                                         
	 
		                                                                                                            
		                  
		                    
	 

	                              
 
#endif


#if SERVER
                                                
 
	                              
 
#endif


#if SERVER
                                             
 
	                              
 
#endif


#if SERVER
                                         
 
	                                                   
 
                                     
 
	                                                                     

	                           
	                                                      

	                                                                
		      

	       
		                                  
			      
	      

	                    

	                                                  

	                      
	           
	              
	 
		                                      
		 
			       
			                              
		 

		                                   

		                                          
		 
			                                     
			                                     
		 

		                   
		 
			                                                                                                                           
			 
				        
				        
			 
			                                                                

			                                                              
		 

		                                      

		                           
		 
			                                                    
				                                           
				                            
				 
					        
					     
				 

				                                                

				                                            
				                                          
				                                                                               
				 
					                                         

					                                                               
					 
						                                                                                     

						                                      
							        

						                                              
							        

						                                     
						                                                              
					 
				 
				                                                       
				                                               

				                                                                                                                                           
				                                                                                                                                           
				                                                                                                                                           
				                  
				     

			                                           
				                              
				     

			                                            
				                                                       
				                                                                                                

				                                                                                                         
				                                                                                                      
				                                                                                               

				                                       
				 
					                                                                                                
					                                                                                                
					                                                                                                
					                  
				 
				    
				 
					                    
				 
				     

			                                                  
				                                                       
				                                                                                                

				                                                                                                    

				                                       
				 
					                                     
					 
						                 
						                                                                                                                                   
					 
					                                     
					 
						                 
						                                                                                                                                   
						                                                                                                                                  
					 
					    
					 
						                                                                                                                                  
						                                                                                                                          
						                                                                                                                                  
					 
					                  
				 
				    
				 
					                    
				 
				     
		 

		     
	 
 

                                             
 
	                 
	             
 

                               
 
	                                                                                          

	                                                                                                          
	                                                                                                                      
	                                                                                                          
 
#endif


#if SERVER && DEV
                                                 
 
	                                                          
	                                                                                     
 
#endif


#if SERVER && DEV
                                                   
 
	                                  

	                                          

	                           

	                                                                                                                                                                   
	                                                                                                                           
	                                                                                                                                                                   

	                                                                                                                                                
	                                                                                                                                           
	                                                                                                                                    
 
#endif


#if SERVER && DEV
                                                           
 
                                                                    
              

	                                                                                                      
	            
	                      
		                                                      
	                         
		                                                            
	                         
		                                                            
	                                   
		                                                 
	    
		                   

	                                          
	                         
	                          
		                          

	                        

	                           
	                                                                                                                                                             
	                                                                                                                        
	                                                                                                                                                             

	                                                                             
 
#endif



    
    
                                        
    
    

            
                                                            
   
  	                   
  
  	                                      
  	                         
   
        
  
  
            
                                                                           
   
  	                   
  
  	                
  	 
  		                                               
  
  		                                               
  
  		                                               
  	 
  	                         
   
        


#if CLIENT
void function ClApexScreens_DisableAllScreens()
{
	Assert( !file.forceDisableScreens )
	file.forceDisableScreens = true
	UpdateAllScreensContent()
}
#endif


#if CLIENT
void function ClApexScreens_EnableAllScreens()
{
	Assert( file.forceDisableScreens )
	file.forceDisableScreens = false
	UpdateAllScreensContent()
}
#endif

#if CLIENT
bool function ClApexScreens_IsDisabled()
           
{
	return file.forceDisableScreens
}
#endif

#if CLIENT
void function UpdateAllScreensContent()
{
	if ( !GetCurrentPlaylistVarBool( "enable_apex_screens", true ) )
		return

	                                                           

	if ( !IsValid( clGlobal.levelEnt ) )
		return                                                                

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

  
void function OnUpdateApexScreensEventTime( float newTime )
{
	printf( "%s() - New time: %.2f", FUNC_NAME(), newTime )

	if ( newTime < 0 )
	{
		bool didChange = false
		foreach ( ApexScreenState screen in file.staticScreenList )
		{
			if ( screen.ruiToCreateOrig != $"" )
			{
				screen.overrideInfoIsValid = false
				screen.ruiToCreate = screen.ruiToCreateOrig
				didChange = true
			}
		}

		if ( didChange )
			UpdateAllScreensContent()
		return
	}

	foreach ( ApexScreenState screen in file.staticScreenList )
	{

		if ( !(screen.position in file.eventScreenOverrideByScreenPosTable) )
			continue

		ScreenOverrideInfo screenOverrideInfo = file.eventScreenOverrideByScreenPosTable[ screen.position ]

		screen.overrideInfoIsValid = true

		if ( screen.ruiToCreateOrig == $"" )
			screen.ruiToCreateOrig = screen.ruiToCreate

		screen.overrideInfo = screenOverrideInfo
		screen.ruiToCreate = screenOverrideInfo.ruiAsset
		screen.overrideInfo.vars.gametimes["eventTriggerTime"] <- GetGlobalNetTime( NV_ApexScreensEventTimeA )
	}

	UpdateAllScreensContent()
}

void function ClApexScreens_OnStaticPropRuiVisibilityChange( array<int> newlyVisible, array<int> newlyHidden )
{
	array<ApexScreenState> screensToUpdate = []

	foreach ( int magicId in newlyHidden )
	{
		if ( !(magicId in file.magicIdScreenStateMap) )
			continue                      

		ApexScreenState screen = file.magicIdScreenStateMap[magicId]

		Assert( screen.visibleInPVS )

		screen.visibleInPVS = false
		screensToUpdate.append( screen )
	}

	foreach ( int magicId in newlyVisible )
	{
		if ( !(magicId in file.magicIdScreenStateMap) )
			continue                      

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
		foreach ( ApexScreenState screen in file.staticScreenList )
		{
			totalCount += 1

			if ( screen.visibleInPVS )
			{
				activeCount += 1
				DebugDrawRotatedBox( <0, 0, 0>, screen.spawnMins + <-1, -1, -3>, screen.spawnMaxs + <-1, -1, -3>, <0, 0, 0>, <140, 185, 255>, true, interval + 0.1 )
			}
			else
			{
				DebugDrawRotatedBox( <0, 0, 0>, screen.spawnMins + <-1, -1, -3>, screen.spawnMaxs + <-1, -1, -3>, <0, 0, 0>, <25, 25, 80>, true, interval + 0.1 )
			}
		}
		printt( "ACTIVE SCREEN COUNT: " + activeCount + " (of " + totalCount + ") (" + activeTVCount + " TVs)" )
	}
}
#endif


#if CLIENT
bool function ClApexScreens_PosInStaticBanner( vector pos )
{
	foreach ( magicId, screen in file.magicIdScreenStateMap )
	{
		if ( !screen.visibleInPVS )
			continue

		if ( PointIsWithinBounds( pos, screen.spawnMins, screen.spawnMaxs ) )
		{
			return true
		}
	}
	return false
}

var function CreateBlankApexScreenRUIElement( ApexScreenState screen )
{
	var rui

	if ( screen.magicId != -1 )
	{
		StaticPropRui propStaticRuiInfo
		propStaticRuiInfo.ruiName = BLANK_ASSET
		propStaticRuiInfo.magicId = screen.magicId
		rui = RuiCreateOnStaticProp( propStaticRuiInfo )

		screen.ruiLastCreated = BLANK_ASSET

		RuiSetFloat2( rui, "uvMin", screen.uvMin )
		RuiSetFloat2( rui, "uvMax", screen.uvMax )

		return rui
	}

	return null
}

void function RuiDestroyIfAliveDelay_Thread( var rui, float delayTime )
{
	OnThreadEnd(
		function() : ( rui )
		{
			RuiDestroyIfAlive( rui )
		}
	)

	wait delayTime
}

struct DelayedScreenContentData
{
	int              serialNum
	ApexScreenState& screen
	float            modeChangeTime
	int              transitionStyle
	int              gcardPresentation
	EHI              playerEHI
	int              lifestateOverride
}

void function UpdateScreensContent( array<ApexScreenState> screenList )
{
	array<DelayedScreenContentData> delayedData = []

	entity localViewPlayer = GetLocalViewPlayer()
	bool isCrypto          = PlayerHasPassive( localViewPlayer, ePassives.PAS_CRYPTO )
	bool inCamera          = IsPlayerInCryptoDroneCameraView( localViewPlayer )
	foreach ( ApexScreenState screen in screenList )
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

		bool needShutdown = ((screen.rui != null && screen.ruiLastCreated != BLANK_ASSET) && (!shouldShow || (screen.ruiToCreate != screen.ruiLastCreated)))
		if ( needShutdown )
		{
			screen.commenceTime = -1.0
			Signal( screen, "ScreenOff" )                                                      

			CleanupNestedGladiatorCard( screen.nestedGladiatorCard0Handle )

			if ( screen.nestedRui != null )
			{
				RuiDestroyNestedIfAlive( screen.rui, "animatedLogoHandle" )
				screen.nestedRui = null
			}

			#if NX_PROG
				thread RuiDestroyIfAliveDelay_Thread( screen.rui, 0.4 )
				screen.rui = CreateBlankApexScreenRUIElement( screen )
				if( screen.rui != null )
					RuiSetGameTime( screen.rui, "transitionInStartTime", Time() )
			#else
				RuiDestroyIfAlive( screen.rui )
				screen.rui = null
			#endif
		}

		bool doStandardVars = (!screen.overrideInfoIsValid || !screen.overrideInfo.skipStandardVars)

		bool needStartup = (shouldShow && (screen.rui == null || screen.ruiLastCreated == BLANK_ASSET))

		if ( needStartup )
		{
			#if NX_PROG
				if ( screen.rui != null )
				{
					RuiDestroyIfAlive( screen.rui )
				}
			#endif

			screen.rui = CreateApexScreenRUIElement( screen )
			if ( screen.rui != null )
			{
				if ( doStandardVars )
					screen.nestedGladiatorCard0Handle = CreateNestedGladiatorCard( screen.rui, "card0", eGladCardDisplaySituation.APEX_SCREEN_STILL, eGladCardPresentation.OFF )
			}
			else
			{
				shouldShow = false
			}

			#if NX_PROG
				var tmpRui = CreateBlankApexScreenRUIElement( screen )
				if( tmpRui != null )
					RuiSetGameTime( tmpRui, "transitionOutStartTime", Time() )
				thread RuiDestroyIfAliveDelay_Thread( tmpRui, 0.4 )

				screen.ruiLastCreated = screen.ruiToCreate
			#endif
		}

		if ( !shouldShow )
			continue
		if ( !doStandardVars )
			continue
		#if NX_PROG
			if ( screen.ruiLastCreated == BLANK_ASSET )
				continue
		#endif

		ApexScreenPositionMasterState masterState = file.screenPositionMasterStates[screen.position]
		float desiredCommenceTime                 = masterState.commenceTime
		int desiredMode                           = masterState.modeIndex
		int desiredTransitionStyle                = masterState.transitionStyle
		EHI desiredPlayerEHI                      = masterState.playerEHI

		if ( desiredCommenceTime == screen.commenceTime && !inCamera )
			continue

		if ( isCrypto )
			RuiSetFloat( screen.rui, "cryptoHintAlpha", 1.0 )
		else
			RuiSetFloat( screen.rui, "cryptoHintAlpha", 0.0 )

		if ( inCamera )
		{
			desiredMode = eApexScreenMode.CAMERA_VIEW
			desiredTransitionStyle = eApexScreenTransitionStyle.NONE
			desiredCommenceTime = -1
		}

		screen.commenceTime = desiredCommenceTime

		RuiSetGameTime( screen.rui, "commenceTime", desiredCommenceTime )
		RuiSetInt( screen.rui, "modeIndex", desiredMode )
		RuiSetInt( screen.rui, "transitionStyle", desiredTransitionStyle )

		int lifestateOverride = eGladCardLifestateOverride.NONE
		int gcardPresentation = GetGCardPresentationForApexScreenMode( desiredMode )

		screen.updateSerialNum = modint( screen.updateSerialNum + 1, INT_MAX )

		DelayedScreenContentData dscd
		dscd.serialNum = screen.updateSerialNum
		dscd.modeChangeTime = screen.commenceTime
		if ( dscd.transitionStyle != eApexScreenTransitionStyle.NONE )
			dscd.modeChangeTime += APEX_SCREEN_TRANSITION_IN_DURATION
		dscd.screen = screen
		dscd.transitionStyle = desiredTransitionStyle
		dscd.gcardPresentation = gcardPresentation
		dscd.playerEHI = desiredPlayerEHI
		dscd.lifestateOverride = lifestateOverride
		delayedData.append( dscd )
	}

	thread (void function() : (delayedData) {
		delayedData.sort( int function( DelayedScreenContentData a, DelayedScreenContentData b ) {
			return (a.modeChangeTime == b.modeChangeTime) ? 0 : (a.modeChangeTime < b.modeChangeTime) ? -1 : 1
		} )
		foreach ( DelayedScreenContentData dscd in delayedData )
		{
			if ( dscd.screen.updateSerialNum != dscd.serialNum )
				continue

			if ( dscd.modeChangeTime - Time() > 0.02 )
				wait (dscd.modeChangeTime - Time())

			if ( dscd.screen.updateSerialNum != dscd.serialNum )
				continue

			                                                                                                       
			if ( dscd.screen.rui == null )
				continue

			UpdateScreenDetails( dscd.screen, dscd.modeChangeTime, dscd.transitionStyle, dscd.gcardPresentation, dscd.playerEHI, dscd.lifestateOverride )
		}
	})()
}
#endif


#if CLIENT
int function GetGCardPresentationForApexScreenMode( int screenMode )
{
	switch( screenMode )
	{
		case eApexScreenMode.GCARD_FRONT_CLEAN:
			return eGladCardPresentation.FRONT_CLEAN

		case eApexScreenMode.GCARD_FRONT_DETAILS:
			return eGladCardPresentation.FRONT_DETAILS

		case eApexScreenMode.GCARD_BACK:
			return eGladCardPresentation.BACK
	}

	return eGladCardPresentation.OFF
}
#endif


#if CLIENT
void function UpdateScreenDetails( ApexScreenState screen, float modeChangeTime, int transitionStyle, int gcardPresentation, EHI playerEHI, int lifestateOverride )
{
	string playerName = ""
	if ( EHIHasValidScriptStruct( playerEHI ) )
		playerName = GetPlayerNameUnlessAnonymized( playerEHI )                           
	RuiSetString( screen.rui, "playerName", playerName )

	entity player = FromEHI( playerEHI )                         
	if ( IsValid( player ) )
		RuiTrackInt( screen.rui, "playerKillCount", player, RUI_TRACK_SCRIPT_NETWORK_VAR_INT, GetNetworkedVariableIndex( "kills" ) )

	RuiSetFloat( screen.rui, "xpBonusAmount", XpEventTypeData_GetAmount( eXPType.KILL_CHAMPION_MEMBER ) )

	ChangeNestedGladiatorCardPresentation( screen.nestedGladiatorCard0Handle, gcardPresentation )
	ChangeNestedGladiatorCardOwner( screen.nestedGladiatorCard0Handle, playerEHI, modeChangeTime, lifestateOverride )
}
#endif


#if CLIENT
void function ClientStaticPropRUICreated( StaticPropRui propRui, var ruiInstance )
{
	if ( !(propRui.magicId in file.environmentalRUIListMapByMagicId) )
	{
		file.environmentalRUIListMapByMagicId[propRui.magicId] <- []
	}
	file.environmentalRUIListMapByMagicId[propRui.magicId].append( ruiInstance )
}
#endif


#if CLIENT
void function SetupForHorizontalTVScreen( StaticPropRui staticPropRuiInfo, ApexScreenState apexScreen )
{
	if ( staticPropRuiInfo.scriptName in s_screenOverrides )
	{
		apexScreen.overrideInfo = s_screenOverrides[staticPropRuiInfo.scriptName]
		apexScreen.overrideInfoIsValid = true
		apexScreen.ruiToCreate = apexScreen.overrideInfo.ruiAsset
		apexScreen.position = eApexScreenPosition.TV_LIKE
		return
	}

	apexScreen.position = eApexScreenPosition.DISABLED
}


void function SetupForVerticalBannerScreen( StaticPropRui staticPropRuiInfo, ApexScreenState apexScreen )
{
	if ( staticPropRuiInfo.scriptName in s_screenOverrides )
	{
		apexScreen.overrideInfo = s_screenOverrides[staticPropRuiInfo.scriptName]
		apexScreen.overrideInfoIsValid = true
		apexScreen.ruiToCreate = apexScreen.overrideInfo.ruiAsset

		if ( apexScreen.position > eApexScreenPosition._COUNT_BANNERTYPES )
			apexScreen.position = eApexScreenPosition.TV_LIKE

		return
	}

	                                                    
}


bool function OnEnumStaticPropRui( StaticPropRui staticPropRuiInfo )
{
	if ( !GetCurrentPlaylistVarBool( "enable_apex_screens", true ) )
		return (staticPropRuiInfo.mockupName.find( "apex_screen" ) != -1)
	                                                                                                                                                                                                                       

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
	apexScreen.ruiToCreate = $"ui/apex_screen.rpak"
	apexScreen.mockup = staticPropRuiInfo.mockupName
	apexScreen.diagonalSize = Distance( staticPropRuiInfo.spawnMins, staticPropRuiInfo.spawnMaxs )

	float tintIntensity = RandomFloatRange( APEX_SCREEN_RANDOM_TINT_INTENSITY_MIN, APEX_SCREEN_RANDOM_TINT_INTENSITY_MAX )
	apexScreen.tint = tintIntensity * APEX_SCREEN_RANDOM_TINT_PALETTE[RandomInt( APEX_SCREEN_RANDOM_TINT_PALETTE.len() )]

	if ( "apex_screen_mods" in staticPropRuiInfo.args )
	{
		string modsStr = staticPropRuiInfo.args.apex_screen_mods
		apexScreen.modBits = 0
		foreach ( string modKey in GetTrimmedSplitString( modsStr, "," ) )
		{
			if ( modKey.toupper() in eApexScreenMods )
				apexScreen.modBits = apexScreen.modBits | eApexScreenMods[modKey.toupper()]
			else
				Warning( "Apex screen at " + apexScreen.spawnOrigin + " has unknown mod '" + modKey.toupper() + "' (" + modsStr + ")" )
		}
	}

	                                                                                                                                                                
	                                                                                         
	bool needsScreenPositionSetup = true
	switch( staticPropRuiInfo.modelName )
	{
		case "mdl/olympus/path_tt_screen_01_off.rmdl":
		case "mdl/eden/beacon_small_screen_02_off.rmdl":
		case "mdl/olympus\\path_tt_screen_01_off.rmdl":
		case "mdl/eden\\beacon_small_screen_02_off.rmdl":
			apexScreen.uvMin = <0.0, 0.295, 0.0>
			apexScreen.uvMax = <1.0, 0.705, 0.0>
			SetupForHorizontalTVScreen( staticPropRuiInfo, apexScreen )
			needsScreenPositionSetup = false
			break

		case "mdl/thunderdome/apex_screen_05.rmdl":
		case "mdl/thunderdome\\apex_screen_05.rmdl":
			apexScreen.uvMin = <0.235, 0.0, 0.0>
			apexScreen.uvMax = <0.765, 1.0, 0.0>
			break

		case "mdl/thunderdome/survival_modular_flexscreens_01.rmdl":
		case "mdl/thunderdome/survival_modular_flexscreens_02.rmdl":
		case "mdl/thunderdome/survival_modular_flexscreens_03.rmdl":
		case "mdl/thunderdome/survival_modular_flexscreens_04.rmdl":
		case "mdl/thunderdome\\survival_modular_flexscreens_01.rmdl":
		case "mdl/thunderdome\\survival_modular_flexscreens_02.rmdl":
		case "mdl/thunderdome\\survival_modular_flexscreens_03.rmdl":
		case "mdl/thunderdome\\survival_modular_flexscreens_04.rmdl":
			apexScreen.uvMin = <0.323, 0.0, 0.0>
			apexScreen.uvMax = <0.684, 1.0, 0.0>
			break

		case "mdl/thunderdome/survival_modular_flexscreens_05.rmdl":
		case "mdl/thunderdome\\survival_modular_flexscreens_05.rmdl":
			apexScreen.uvMin = <0.0, 0.215, 0.0>
			apexScreen.uvMax = <1.0, 0.785, 0.0>
			break

		default:
			return false                                                                                  
			                                                  
			                               
			                                    
			                                    
			break
	}

	if ( needsScreenPositionSetup )
	{
		float uvWidth           = (apexScreen.uvMax.x - apexScreen.uvMin.x)
		float uvHeight          = (apexScreen.uvMax.y - apexScreen.uvMin.y)
		float screenAspectRatio = (uvHeight < 0.0001) ? 0.0 : uvWidth / uvHeight
		bool isVertical         = (screenAspectRatio < 1.1)
		if ( !isVertical )
		{
			                                                         
			apexScreen.position = eApexScreenPosition.DISABLED
		}
		else
		{
			switch( staticPropRuiInfo.scriptName )
			{
				case "leftScreen":
					apexScreen.position = eApexScreenPosition.L
					break

				case CUSTOM_BANNER_LEFT_SCRIPTNAME:
					apexScreen.position = eApexScreenPosition.L
					SetupForVerticalBannerScreen( staticPropRuiInfo, apexScreen )
					file.customBannerList["left"] <- apexScreen
					break

				case "rightScreen":
					apexScreen.position = eApexScreenPosition.R
					break

				case CUSTOM_BANNER_RIGHT_SCRIPTNAME:
					apexScreen.position = eApexScreenPosition.R
					SetupForVerticalBannerScreen( staticPropRuiInfo, apexScreen )
					file.customBannerList["right"] <- apexScreen
					break

				case CUSTOM_BANNER_CENTER_SCRIPTNAME:
					apexScreen.position = eApexScreenPosition.C
					SetupForVerticalBannerScreen( staticPropRuiInfo, apexScreen )
					file.customBannerList["center"] <- apexScreen
					break

				default:
					apexScreen.position = eApexScreenPosition.C
					break
			}
		}
	}

	Assert( string( apexScreen.ruiToCreate ) != "" )

	file.staticScreenList.append( apexScreen )
	file.magicIdScreenStateMap[apexScreen.magicId] <- apexScreen

	if ( apexScreen.sharesPropWithEnvironmentalRUI )
		return false                                                                                                                 

	return true
}
#endif

#if CLIENT
var function CreateApexScreenRUIElement( ApexScreenState screen )
{
	var rui
	if ( screen.magicId == -1 )
	{
		#if DEV
			float aspectRatio = 1.0      
			float height      = screen.diagonalSize / sqrt( 1.0 + pow( aspectRatio, 2.0 ) )
			float width       = aspectRatio * height
			vector origin     = screen.spawnOrigin                    
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
	screen.ruiLastCreated = screen.ruiToCreate

	vector basePos = screen.spawnOrigin
	basePos.z -= (screen.spawnMaxs.z - screen.spawnMins.z)

	                                                                        
	RuiSetFloat3( rui, "screenWorldPos", basePos )
	RuiSetFloat( rui, "screenScale", screen.spawnScale )
	RuiSetFloat2( rui, "uvMin", screen.uvMin )
	RuiSetFloat2( rui, "uvMax", screen.uvMax )
	RuiSetInt( rui, "screenPosition", screen.position )
	RuiSetInt( rui, "modBits", screen.modBits )
	RuiSetFloat3( rui, "tintColor", screen.tint )
	RuiSetFloat( rui, "tintIntensity", 1.0 )
	RuiSetInt( rui, "unixTimeStamp", GetUnixTimestamp() )
	RuiSetImage( rui, "overlayImg", file.bannerBGAssert )
	RuiSetImage( rui, "logoImage", file.logoImage )
	RuiSetFloat3( rui, "logoTint", file.logoOverlayTint )
	RuiSetFloat2( rui, "logoSize", file.logoSize )

	if ( file.animatedLogoAsset != $"" )
	{
		var nestedRui = RuiCreateNested( rui, "animatedLogoHandle", file.animatedLogoAsset )
		screen.nestedRui = nestedRui
	}

	if ( screen.sharesPropWithEnvironmentalRUI )
		RuiSetBool( rui, "sharesPropWithEnvironmentalRUI", true )

	RuiTrackInt( rui, "cameraNearbyEnemySquads", GetLocalViewPlayer(), RUI_TRACK_SCRIPT_NETWORK_VAR_INT, GetNetworkedVariableIndex( "cameraNearbyEnemySquads" ) )

	if ( screen.overrideInfoIsValid )
	{
		foreach ( string varName, int varValue in screen.overrideInfo.vars.ints )
			RuiSetInt( rui, varName, varValue )

		foreach ( string varName, float varValue in screen.overrideInfo.vars.floats )
			RuiSetFloat( rui, varName, varValue )

		foreach ( string varName, bool varValue in screen.overrideInfo.vars.bools )
			RuiSetBool( rui, varName, varValue )

		foreach ( string varName, string varValue in screen.overrideInfo.vars.strings )
			RuiSetString( rui, varName, varValue )

		foreach ( string varName, asset varValue in screen.overrideInfo.vars.images )
			RuiSetImage( rui, varName, varValue )

		foreach ( string varName, vector varValue in screen.overrideInfo.vars.float3s )
			RuiSetFloat3( rui, varName, varValue )

		foreach ( string varName, vector varValue in screen.overrideInfo.vars.float2s )
			RuiSetFloat2( rui, varName, varValue )

		foreach ( string varName, float varValue in screen.overrideInfo.vars.gametimes )
			RuiSetGameTime( rui, varName, varValue )

		if ( screen.overrideInfo.bindStartTimeVarToEventTimeA )
			RuiTrackFloat( rui, "startTime", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL, GetNetworkedVariableIndex( NV_ApexScreensEventTimeA ) )
		if ( screen.overrideInfo.bindStartTimeVarToEventTimeB )
			RuiTrackFloat( rui, "startTime", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL, GetNetworkedVariableIndex( NV_ApexScreensEventTimeB ) )
		if ( screen.overrideInfo.bindEventIntA )
			RuiTrackInt( rui, "intA", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( NV_ApexScreensEventIntA ) )
	}

	return rui
}

void function ClApexScreens_SetCustomApexScreenBGAsset( asset bg )
{
	file.bannerBGAssert = bg
}

void function ClApexScreens_SetCustomLogoTint( vector tint )
{
	file.logoOverlayTint = tint
}

void function ClApexScreens_SetCustomLogoImage( asset logo )
{
	file.logoImage = logo
}

void function ClApexScreens_SetCustomLogoSize( vector l_size )
{
	file.logoSize = l_size
}
void function ClApexScreens_SetAnimatedLogoAsset( asset ruiAsset )
{
	file.animatedLogoAsset = ruiAsset
}

void function ClApexScreens_SetEventScreenOverride( int position, ScreenOverrideInfo screenOverrideInfo )
{
	file.eventScreenOverrideByScreenPosTable[ position ] <- screenOverrideInfo
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



    
    
                    
    
    

#if CLIENT
void function ServerToClient_ApexScreenKillDataChanged( int damageSourceID, float distanceBetweenPlayers, int killedPlayerGrade, entity killedPlayer )
{
	file.killScreenDamageSourceID = damageSourceID
	file.killScreenDistance = floor( distanceBetweenPlayers / 12 )
	file.killedPlayerGrade = killedPlayerGrade

	if ( IsValid( killedPlayer ) )
		file.killedPlayerName = killedPlayer.GetPlayerName()

	UpdateAllScreensContent()
}

void function ServerToClient_ApexScreenRefreshAll()
{
	UpdateAllScreensContent()
}
#endif





    
    
                               
    
    

            
                            
   
  	                      
  	                          
  	                        
  	                           
  	                           
  	                         
  
  	                                     
  	                     
  	                     
  	                     
   
        
  
                                                                                        
   
  	                         
  	                        
  
  	          
  		                       
  		                    
  		                   
  		                                              
  		                                           
  		                         
  		                                              
  		                                              
  		                                       
  		                                         
  
  		                       
  		                    
  		                   
  		                                              
  		                                           
  		                         
  		                                              
  		                                              
  		                                       
  		                                         
  	      
   
  
            
                                                                                
   
  	                                       
  
  	 
  		                                               
  		                                                                     
  	 
  
  	                  
  
  	                    
  	                   
  
  	                 
  
  	       
   
        

#if SERVER
                                                                                                                   
 
	                                                      
 

                                                   
 
	                              
 

                                                                                         
 
	                                            
 

                                                                            
 
	                                            
 
#endif