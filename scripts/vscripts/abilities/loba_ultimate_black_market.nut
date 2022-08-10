#if SERVER || CLIENT || UI
global function LobaUltimateBlackMarket_LevelInit

global function GetBlackMarketNearbyLootRadius
global function GetBlackMarketUseLimit
#endif

#if SERVER
                                           
                                            
                                    
                                              
                                               
                                                   
                                           
#endif

#if SERVER || CLIENT
global function OnWeaponRegenEnd_ability_black_market
global function OnWeaponAttemptOffhandSwitch_ability_black_market
global function OnWeaponActivate_ability_black_market
global function OnWeaponDeactivate_ability_black_market
global function OnWeaponPrimaryAttack_ability_black_market
#endif

#if CLIENT
global function GetBlackMarketUseCount
global function GetBlackMarketLastUseTime
global function GetBlackMarketUseItemRefs
global function ServerToClient_UpdateBlackMarketUseCount
global function BlackMarket_OnDeathBoxMenuOpened
#endif


#if SERVER || CLIENT
global const string BLACK_MARKET_SCRIPTNAME = "black_market"
global const string BLACK_MARKET_MOVER_SCRIPTNAME = "black_market_mover"
global const string BLACK_MARKET_HIGHLIGHT_PROXY_SCRIPTNAME = "black_market_highlight_proxy"
global const string BLACK_MARKET_CLOSE_CMD = "ClientCallback_CloseBlackMarket"
const string BLACK_MARKET_OPEN_CMD = "ClientCallback_OpenBlackMarket"

const asset BLACK_MARKET_MODEL = $"mdl/props/loba_loot_stick/loba_loot_stick.rmdl"
const asset BLACK_MARKET_PROXY_MODEL = $"mdl/fx/loba_staff_holo_stand.rmdl"


const asset BLACK_MARKET_RADIUS_FX = $"P_loba_staff_ar_ring"
const string BLACK_MARKET_PLACEMENT_IMPACT_TABLE = "black_market_placement"
const asset BLACK_MARKET_START_FX = $"P_loba_staff_ar_init"
const string BLACK_MARKET_START_IMPACT_TABLE = "black_market_activation"
const asset BLACK_MARKET_DESTRUCTION_FX = $"P_loba_staff_exp"
const string BLACK_MARKET_START_FRIENDLY_SOUND = "Loba_Ultimate_BlackMarket_Pulse"
const string BLACK_MARKET_START_ENEMY_SOUND = "Loba_Ultimate_BlackMarket_Pulse"
const asset BLACK_MARKET_WARP_BEAM_FX = $"P_item_warp_travel"

const float BLACK_MARKET_PLACEMENT_RANGE_MAX = 94
const float BLACK_MARKET_PLACEMENT_RANGE_MIN = 64
const float BLACK_MARKET_PLACEMENT_ANGLE_LIMIT = 0.74
const vector BLACK_MARKET_PLACEMENT_OFFSET = <0, 0, 0>
const vector BLACK_MARKET_BOUND_MINS = <-16, -16, 0>
const vector BLACK_MARKET_BOUND_MAXS = <16, 16, 80>
const vector BLACK_MARKET_PLACEMENT_DOWN_TRACE_OFFSET = <0, 0, 94>
const float BLACK_MARKET_PLACEMENT_MAX_GROUND_DIST = 12.0

const vector BLACK_MARKET_PLACEMENT_COLOR = <1, 1, 1>
const float BLACK_MARKET_PLACEMENT_PLAYER_ALPHA = 1.0
const float BLACK_MARKET_PLACEMENT_SPECTATOR_ALPHA = 0.2

const bool BLACK_MARKET_DEBUG = false
const bool BLACK_MARKET_DEBUG_DRAW_PLACEMENT = false

const vector BLACK_MARKET_PLACEMENT_SIGHT_CHECK_OFFSET = < 0, 0, 4 >
#endif


#if SERVER || CLIENT
struct PlacementInfo
{
	vector origin
	vector angles
	entity parentTo
	bool   success = false
	string failReason = ""
}
#endif


#if SERVER || CLIENT
struct BlackMarketPlayerUseData
{
	array<LootData> lootFlavs
	array<int>      lootCounts
	float           lastUseTime
}
#endif


struct {
	#if SERVER || CLIENT
		table< EHI, table< EHI, BlackMarketPlayerUseData > > byBlackMarket_byPlayer_useData
	#endif
	#if SERVER
		                                               
	#endif
} file


#if SERVER || CLIENT || UI
void function LobaUltimateBlackMarket_LevelInit()
{
	#if SERVER || CLIENT
		PrecacheParticleSystem( BLACK_MARKET_RADIUS_FX )
		PrecacheImpactEffectTable( BLACK_MARKET_PLACEMENT_IMPACT_TABLE )
		PrecacheParticleSystem( BLACK_MARKET_START_FX )
		PrecacheImpactEffectTable( BLACK_MARKET_START_IMPACT_TABLE )
		PrecacheParticleSystem( BLACK_MARKET_DESTRUCTION_FX )
		PrecacheParticleSystem( BLACK_MARKET_WARP_BEAM_FX )
		PrecacheModel( BLACK_MARKET_MODEL )
		PrecacheModel( BLACK_MARKET_PROXY_MODEL )

		Remote_RegisterClientFunction( "ServerToClient_UpdateBlackMarketUseCount",
			"int", 0, INT_MAX,                       
			"int", 0, INT_MAX,                
			"int", 0, 255,                
			"int", 0, 4096,                  
			"int", 0, 4096                    
		)

		Remote_RegisterServerFunction( BLACK_MARKET_OPEN_CMD, "entity" )
		Remote_RegisterServerFunction( BLACK_MARKET_CLOSE_CMD, "entity" )
		Remote_RegisterServerFunction( "ClientCallback_TryPickupBlackMarket", "entity" )
	#endif

	#if SERVER
		                                                         
		                                                                                                  
		                                                                                              

		                                                                    
	#endif

	#if CLIENT
		AddCreateCallback( "prop_loot_grabber", OnPropScriptCreated )

		RegisterSignal( "BlackMarket_StopPlacementProxy" )
		                                     

		                                                                                                
		                                                                                                   

		RegisterDefaultMinimapPackage( "prop_loot_grabber", $"", void function( entity ent, var rui ) {} )
		RegisterMinimapPackage( "prop_loot_grabber", eMinimapObject_prop_script.BLACK_MARKET,
			MINIMAP_OBJ_AREA_RUI, void function( entity ent, var rui ) {
				SetupMapRui( ent, rui, false )
			},
			$"ui/in_world_minimap_objective_area.rpak", void function( entity ent, var rui ) {
				SetupMapRui( ent, rui, true )
			}
		)

		RegisterConCommandTriggeredCallback( "+scriptCommand5", OnCharacterButtonPressed )
	#endif
}
#endif


#if SERVER || CLIENT
void function OnWeaponRegenEnd_ability_black_market( entity weapon )
{
	OnWeaponRegenEndGeneric( weapon )
}
#endif


#if SERVER || CLIENT
bool function OnWeaponAttemptOffhandSwitch_ability_black_market( entity weapon )
{
	entity owner = weapon.GetWeaponOwner()
	if ( owner.IsPhaseShifted() )
		return false

	if ( weapon.GetAmmoPerShot() < weapon.GetWeaponPrimaryClipCount() )
		return false

	return true
}
#endif


#if SERVER || CLIENT
void function OnWeaponActivate_ability_black_market( entity weapon )
{
	entity owner = weapon.GetWeaponOwner()
	#if CLIENT
		if ( !InPrediction() || !IsFirstTimePredicted() )
			return

		OnBeginPlacement( weapon, owner )
	#endif
}
#endif


#if SERVER || CLIENT
void function OnWeaponDeactivate_ability_black_market( entity weapon )
{
	entity owner = weapon.GetWeaponOwner()
	#if CLIENT
		OnEndPlacement( owner )
		if ( !InPrediction() || !IsFirstTimePredicted() )
			return
	#endif
}
#endif


#if SERVER || CLIENT
var function OnWeaponPrimaryAttack_ability_black_market( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity owner = weapon.GetWeaponOwner()

	PlacementInfo placementInfo = GetPlacementInfo( owner )

	if ( !placementInfo.success )
		return 0

	#if SERVER
		                                                      
	#endif

	PlayerUsedOffhand( owner, weapon, true, null, {pos = placementInfo.origin} )

#if CLIENT
	if ( InPrediction() )
	{
		OnEndPlacement( owner )
	}
#endif

	return weapon.GetAmmoPerShot()
}
#endif


#if SERVER || CLIENT
PlacementInfo function GetPlacementInfo( entity player )
{
	PlacementInfo info
	info.success = true

	vector eyePos            = player.EyePosition()
	vector viewVec           = player.GetViewVector()
	vector angles            = < 0, VectorToAngles( viewVec ).y, 0 >
	vector up                = <0, 0, 1>
	float hullWidth          = BLACK_MARKET_BOUND_MAXS.x - BLACK_MARKET_BOUND_MINS.x
	float hullHeight         = BLACK_MARKET_BOUND_MAXS.z - BLACK_MARKET_BOUND_MINS.z
	array<entity> ignoreEnts = []

	float range = BLACK_MARKET_PLACEMENT_RANGE_MAX

	TraceResults viewTraceResults = TraceLine(
		eyePos,
		eyePos + player.GetViewVector() * (BLACK_MARKET_PLACEMENT_RANGE_MAX + 0.5 * hullWidth),
		ignoreEnts, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_NONE, player )

	TraceResults fwdResults = TraceHull(
		viewTraceResults.endPos - 0.5 * (BLACK_MARKET_PLACEMENT_RANGE_MAX - BLACK_MARKET_PLACEMENT_RANGE_MIN) * viewVec,
		viewTraceResults.endPos - 0.5 * hullWidth * viewVec,
		BLACK_MARKET_BOUND_MINS, BLACK_MARKET_BOUND_MAXS,
		ignoreEnts, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_NONE, up, player )

	TraceResults downResults = TraceHull(
		fwdResults.endPos - 1.0 * viewVec,
		fwdResults.endPos - 1.0 * viewVec - BLACK_MARKET_PLACEMENT_DOWN_TRACE_OFFSET,
		BLACK_MARKET_BOUND_MINS, BLACK_MARKET_BOUND_MAXS,
		ignoreEnts, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_NONE, up, player )

	info.origin = downResults.endPos
	info.angles = AnglesCompose( angles, <0, 180, 0> )

	#if BLACK_MARKET_DEBUG_DRAW_PLACEMENT
		                                                                                                                                         
		                                                                                                                                   
		                                                                                                                                                 
		                                                                                                              
		                                                                                           
		                                                                                                                                                                     
		                                                                                                                                                   
	#endif

	if ( info.success && downResults.fraction > 0.99 )
	{
		info.success = false           
		info.failReason = ""
	}

	if ( info.success && downResults.startSolid )
	{
		info.success = false                               
		info.failReason = "#PLAYER_DEPLOY_FAIL_HINT_START_SOLID"
	}

	info.parentTo = null
	if ( info.success )
	{
		if ( IsValid( downResults.hitEnt ) && CanScriptPlaceableBePlacedOn( downResults.hitEnt ) )
		{
			if ( IsEntInvalidForPlacingPermanentOnto( downResults.hitEnt ) )
			{
				info.success = false
			}
			else if ( ShouldScriptedPlaceableParentTo( downResults.hitEnt ) )
			{
				info.parentTo = downResults.hitEnt
			}
		}
		else
		{
			info.success = false                                                        
			info.failReason = "#PLAYER_DEPLOY_FAIL_HINT_INVALID_PARENT"
		}
	}

	if ( info.success )
	{
		if ( IsOriginInvalidForPlacingPermanentOnto( downResults.endPos ) )
		{
			info.success = false
		}
	}

	if ( info.success )
	{
		TraceResults upResults = TraceHull( info.origin, info.origin, BLACK_MARKET_BOUND_MINS, BLACK_MARKET_BOUND_MAXS, ignoreEnts, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_NONE, up, player )
		if ( upResults.startSolid )
		{
			info.success = false
			info.failReason = "#PLAYER_DEPLOY_FAIL_HINT_OBSTRUCTED"
		}
	}

	if ( info.success && !PlayerCanSeePos( player, info.origin + BLACK_MARKET_PLACEMENT_SIGHT_CHECK_OFFSET, true, 90 ) )
	{
		info.success = false
		info.failReason = "#PLAYER_DEPLOY_FAIL_HINT_CANNOT_SEE"
	}

	if ( info.success && DotProduct( downResults.surfaceNormal, up ) < BLACK_MARKET_PLACEMENT_ANGLE_LIMIT )
	{
		info.success = false
		info.failReason = "#PLAYER_DEPLOY_FAIL_HINT_TOO_STEEP"
	}

	if ( info.success )
	{
		if ( IsOriginInvalidForPlacingPermanentOnto( info.origin ) )
		{
			info.success = false
			info.failReason = "#PLAYER_DEPLOY_FAIL_HINT_OBSTRUCTED"
		}
	}

	if ( info.success )
	{
		vector onSurfaceAngles = AnglesOnSurface( downResults.surfaceNormal, AnglesToForward( angles ) )
		vector osaForward      = AnglesToForward( onSurfaceAngles )
		vector osaUp           = AnglesToUp( onSurfaceAngles )
		vector osaRight        = AnglesToRight( onSurfaceAngles )

		float length = Length( BLACK_MARKET_BOUND_MINS )

		array< vector > groundTestOffsets = [
			Normalize( osaRight + osaForward ) * length,
			Normalize( -osaRight + osaForward ) * length,
			Normalize( osaRight + -osaForward ) * length,
			Normalize( -osaRight + -osaForward ) * length
		]

		#if BLACK_MARKET_DEBUG_DRAW_PLACEMENT
			                                                                                                         
			                                                                                                            
		#endif

		                                                     
		foreach ( vector testOffset in groundTestOffsets )
		{
			vector testPos           = info.origin + testOffset
			TraceResults traceResult = TraceLine(
				testPos + (osaUp * BLACK_MARKET_PLACEMENT_MAX_GROUND_DIST),
				testPos + (osaUp * -BLACK_MARKET_PLACEMENT_MAX_GROUND_DIST),
				ignoreEnts, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_NONE )

			#if BLACK_MARKET_DEBUG_DRAW_PLACEMENT
				                                                                                                                                        
			#endif

			if ( traceResult.fraction == 1.0 )
			{
				info.success = false
				info.failReason = "#PLAYER_DEPLOY_FAIL_HINT_TOO_UNEVEN"
				break
			}
		}
	}

	                                                                                                                                     

	info.origin += BLACK_MARKET_PLACEMENT_OFFSET

	return info
}
#endif


#if CLIENT
void function OnBeginPlacement( entity weapon, entity player )
{
	if ( player != GetLocalViewPlayer() )
		return

	thread PlacementProxyThread( weapon, player )
}
#endif


#if CLIENT
void function OnEndPlacement( entity player )
{
	if ( player != GetLocalViewPlayer() )
		return

	player.Signal( "BlackMarket_StopPlacementProxy" )
}
#endif


#if CLIENT
void function PlacementProxyThread( entity weapon, entity player )
{
	weapon.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "BlackMarket_StopPlacementProxy" )

	entity proxy = CreateClientSidePropDynamic( <0, 0, 0>, <0, 0, 0>, BLACK_MARKET_PROXY_MODEL )
	proxy.EnableRenderAlways()
	proxy.kv.rendermode = 3
	proxy.kv.renderamt = 1
	DeployableModelHighlight( proxy )
	                                                   

	float lootGrabDist = GetBlackMarketNearbyLootRadius()

	proxy.e.clientEntMinimapClassName = "prop_loot_grabber"
	proxy.e.clientEntMinimapCustomState = eMinimapObject_prop_script.BLACK_MARKET
	proxy.e.clientEntMinimapFlags = MINIMAP_FLAG_VISIBILITY_SHOW
	proxy.e.clientEntMinimapScale = lootGrabDist / 16384.0
	proxy.e.clientEntMinimapZOrder = MINIMAP_Z_OBJECT
	thread MinimapObjectThread( proxy )

	int proxyRadiusFx = StartParticleEffectOnEntity( proxy, GetParticleSystemIndex( BLACK_MARKET_RADIUS_FX ), FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID )
	EffectSetControlPointVector( proxyRadiusFx, 1, <lootGrabDist, 0, 0> )

	string[1] displayedHint = [""]

	OnThreadEnd( void function() : ( proxy, proxyRadiusFx, displayedHint ) {
		if ( EffectDoesExist( proxyRadiusFx ) )
			EffectStop( proxyRadiusFx, false, true )

		if ( IsValid( proxy ) )
			proxy.Destroy()

		if ( displayedHint[0] != "" )
			HidePlayerHint( displayedHint[0] )
	} )

	PlacementInfo placementInfo
	while ( true )
	{
		placementInfo = GetPlacementInfo( player )

		proxy.SetOrigin( placementInfo.origin )
		proxy.SetAngles( placementInfo.angles )
		if ( IsValid( placementInfo.parentTo ) )
			proxy.SetParent( placementInfo.parentTo, "", true )
		proxy.SetOrigin( placementInfo.origin )
		proxy.SetAngles( placementInfo.angles )

		string hint
		if ( placementInfo.success )
		{
			hint = "#LOBA_ULT_BLACK_MARKET_DEPLOY_HINT"
			DeployableModelHighlight( proxy )
			                                                                                    
		}
		else
		{
			hint = placementInfo.failReason
			DeployableModelInvalidHighlight( proxy )
			                                                                                   
		}

		if ( hint != displayedHint[0] )
		{
			if ( displayedHint[0] != "" )
				HidePlayerHint( displayedHint[0] )
			if ( hint != "" )
				AddPlayerHint( 60.0, 0, $"", hint )
			displayedHint[0] = hint
		}

		WaitFrame()
	}
}
#endif


#if SERVER
                                                                                  
 
	                                    
	                                    

	                                                     

	                                                                                                 
	                                                                                 
	 
		                                                      
		                                                                                                                       
		 
			                                                 

			                                           
				                                                
					                             
						                     
				   
				                                              
					                                      
				                                                              
			    
		 
		                                       
		 
			                                            
		 
	 

	                  
	 
		                                                 
		                                                    
		                                                     

		                                                     
		                                
		                                     
		 
			                                             
			                                        
			                                                                              
			                                  
		 

		                                

		                               
		                               

		                                           
		                      
			                                                                         
		      

		                             
		                                       

		                                  
		                                  

		                                  
		                                                             

		                                                  

		                                
		                                                                
		                                                                   

		                                             

                  
                                            
        

                     
                                       
        

		                                                                             
		                                             
			                                                  
		                                                       

		                                                                                                                                                                         
		                                                                                        

		                                                            
		                                           
		                                                 

		                            

		                                                          
		                                                                                           
		                                                                                           
		                                                                                                               

		                                        
		 
			                                                                                 
			                                         
			                              
			                                                                
		 

		                                                                    
		                                  
		                               

		                                        

		                                           
		                                          
		                                             
		                                                                        
		                                                              

		                            
		                                        
		                                            

                     
		                                             
        

		                                         
			                                    

			                                       
			                                               
		    

		                                                                  
		                                                                      
		                                                                                         
	 

	                                
	 
		                                                                                                                                             
		                                                        

		                                           
		                                          

		                                                          
		                                                  
		                                              

		                                                           
		                                                            
		                                            
		                                                                                     
		                                                                                        

		                                          
		                                                                 
		                                                                 
	 

	                                                    

	                                     

	                                                                                  
		                       
			                                                            
		                             
			                     
		                                           
			                                   
	   

	                                                 

	                                
	                  
	                      
	                                              
	                  
	                   

	           

	                                                                      

	                       
	                                       
	                                                                       
	                                                    

	                                                          
	                       
		                                                                                                                      

	                                                                                              

	                                        
	                                                             
	                                

	                                                              

	                                                   

	                                                                                                                                              
	                                                                                          
	                                                                                                
	                                                                                                

	             
	 
                   
                                                                                                                                                                     
       
		                                                                            
        

		        
	 
 
#endif


#if CLIENT
void function ManageBlackMarketAmbientGeneric( entity ent )
{
	EndSignal( ent, "OnDestroy" )

	entity soundEmitter = CreateClientSideAmbientGeneric( ent.GetWorldSpaceCenter(), "Loba_Ultimate_Cane_Active_Loop", 2000 )
	soundEmitter.SetEnabled( true )
	CopyRealmsFromTo( ent, soundEmitter )
	soundEmitter.SetParent( ent, "", true, 0.0 )

	OnThreadEnd( function () : ( soundEmitter ) {
		if ( IsValid( soundEmitter ) )
			soundEmitter.Destroy()
	} )

	WaitForever()
}

void function OnPropScriptCreated( entity ent )
{
	if ( ent.GetScriptName() == BLACK_MARKET_SCRIPTNAME )
	{
		AddEntityCallback_GetUseEntOverrideText( ent, GetBlackMarketUsePromptText )
		SetCallback_CanUseEntityCallback( ent, CanUseBlackMarket )
		AddCallback_OnUseEntity_ClientServer( ent, OnBlackMarketUsed )
		SetCallback_ShouldUseBlockReloadCallback( ent, BlackMarket_ShouldUseBlockReload )

		thread ManageBlackMarketAmbientGeneric( ent )

		if ( GradeFlagsHas( ent, eGradeFlags.IS_BUSY ) )
			thread BlackMarketRumbleOnReadyThread( ent )
	}
	if ( ent.GetScriptName() == BLACK_MARKET_HIGHLIGHT_PROXY_SCRIPTNAME )
	{
		ManageHighlightEntity( ent )
	}
}
#endif


#if CLIENT
void function BlackMarketRumbleOnReadyThread( entity ent )
{
	EndSignal( ent, "OnDestroy" )

	while ( GradeFlagsHas( ent, eGradeFlags.IS_BUSY ) )
		WaitFrame()

	Rumble_Play( "loba_ultimate_deploy", { position = ent.GetWorldSpaceCenter() } )
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


#if CLIENT
void function ServerToClient_UpdateBlackMarketUseCount( EncodedEHandle blackMarketEEH, EncodedEHandle userEEH, int useCount, int lootRefIdx, int lootRefCount )
{
	LootData lootFlav = SURVIVAL_Loot_GetLootDataByIndex( lootRefIdx )
	if (lootFlav.lootType != eLootType.AMMO)
		AddToBlackMarketPlayerUseData( blackMarketEEH, userEEH, useCount, lootRefIdx, lootRefCount )
}
#endif


#if SERVER || CLIENT
void function AddToBlackMarketPlayerUseData( EHI blackMarketEHI, EHI userEHI, int useCount, int lootRefIdx, int lootRefCount )
{
	Assert( SURVIVAL_Loot_IsLootIndexValid( lootRefIdx ) )
	LootData lootFlav = SURVIVAL_Loot_GetLootDataByIndex( lootRefIdx )

	if ( !(blackMarketEHI in file.byBlackMarket_byPlayer_useData) )
		file.byBlackMarket_byPlayer_useData[ blackMarketEHI ] <- {}

	BlackMarketPlayerUseData bmpud
	if ( userEHI in file.byBlackMarket_byPlayer_useData[ blackMarketEHI ] )
		bmpud = file.byBlackMarket_byPlayer_useData[ blackMarketEHI ][ userEHI ]
	else
		file.byBlackMarket_byPlayer_useData[ blackMarketEHI ][ userEHI ] <- bmpud

	if ( bmpud.lootFlavs.len() < useCount )
	{
		bmpud.lootFlavs.resize( useCount )
		bmpud.lootCounts.resize( useCount )
	}
	bmpud.lootFlavs[ useCount - 1 ] = lootFlav
	bmpud.lootCounts[ useCount - 1 ] += lootRefCount

	bmpud.lastUseTime = Time()

#if CLIENT
	if ( IsValid( GetLocalViewPlayer() ) && userEHI == GetLocalViewPlayer().GetEncodedEHandle() && useCount >= GetBlackMarketUseLimit() )
		EmitUISound( "Loba_Ultimate_BlackMarket_MaxedOut" )
#endif

#if CLIENT
	if ( IsValid( GetEntityFromEncodedEHandle( blackMarketEHI ) ) && IsValid( GetEntityFromEncodedEHandle( userEHI ) ) )
#endif
	{
		array<EHI> invalidBlackMarkets = []
		foreach ( EHI bm, table<EHI, BlackMarketPlayerUseData> perPlayerData in file.byBlackMarket_byPlayer_useData )
		{
			if ( !IsValid( FromEHI( bm ) ) )
				invalidBlackMarkets.append( bm )
		}
		foreach ( EHI bm in invalidBlackMarkets )
			delete file.byBlackMarket_byPlayer_useData[bm]
	}
}
#endif


#if SERVER
                                                         
 
	                                      
		                                

		                                                                                 
		 
			                           
				        

			                                                                                                                            
			 
				                              
					        

				                                
				 
					                                                       
					                                                              
					 
						                                                      
							        

						                                                                                  
							                                                              
							                                                           

						                                                          
					 
				 
			 
		 
	     
 
#endif


#if SERVER || CLIENT
float function GetBlackMarketLastUseTime( entity blackMarket, entity user )
{
	EHI blackMarketEHI = ToEHI( blackMarket )
	EHI userEHI        = ToEHI( user )

	if ( blackMarketEHI in file.byBlackMarket_byPlayer_useData )
	{
		if ( userEHI in file.byBlackMarket_byPlayer_useData[blackMarketEHI] )
			return file.byBlackMarket_byPlayer_useData[blackMarketEHI][userEHI].lastUseTime
	}

	return -9999.0
}
#endif


#if SERVER || CLIENT
int function GetBlackMarketUseCount( entity blackMarket, entity user )
{
	EHI blackMarketEHI = ToEHI( blackMarket )
	EHI userEHI        = ToEHI( user )

	if ( blackMarketEHI in file.byBlackMarket_byPlayer_useData )
	{
		if ( userEHI in file.byBlackMarket_byPlayer_useData[blackMarketEHI] )
			return file.byBlackMarket_byPlayer_useData[blackMarketEHI][userEHI].lootFlavs.len()
	}

	return 0
}
#endif


#if SERVER || CLIENT
array<LootRef> function GetBlackMarketUseItemRefs( entity blackMarket, entity user )
{
	EHI blackMarketEHI = ToEHI( blackMarket )
	EHI userEHI        = ToEHI( user )

	array<LootRef> lootRefs = []
	if ( blackMarketEHI in file.byBlackMarket_byPlayer_useData )
	{
		if ( userEHI in file.byBlackMarket_byPlayer_useData[blackMarketEHI] )
		{
			BlackMarketPlayerUseData data = file.byBlackMarket_byPlayer_useData[blackMarketEHI][userEHI]
			foreach ( int idx, LootData lootFlav in data.lootFlavs )
			{
				LootRef ref
				ref.lootData = lootFlav
				ref.count = data.lootCounts[idx]
				lootRefs.append( ref )
			}
		}
	}
	return lootRefs
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


#if CLIENT
void function BlackMarket_OnDeathBoxMenuOpened( entity device )
{
	thread (void function() : ( device ) {
		entity player = GetLocalViewPlayer()

		EndSignal( device, "OnDestroy" )
		EndSignal( player, "OnDeath" )

		float lootGrabDist = GetBlackMarketNearbyLootRadius()
		int radiusFx       = StartParticleEffectOnEntity( device, GetParticleSystemIndex( BLACK_MARKET_RADIUS_FX ), FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID )
		EffectSetControlPointVector( radiusFx, 1, <lootGrabDist, 0, 0> )

		OnThreadEnd( void function() : ( radiusFx ) {
			if ( EffectDoesExist( radiusFx ) )
				EffectStop( radiusFx, false, true )
		} )

		while ( Survival_GetDeathBox() == device )
			WaitFrame()
	})()
}
#endif


#if CLIENT
string function GetBlackMarketUsePromptText( entity device )
{
	if ( GradeFlagsHas( device, eGradeFlags.IS_BUSY ) )
	{
		if ( !device.e.blackMarket_haveSeenReady )
			return ""                                            
		else
			return ""              
	}

	device.e.blackMarket_haveSeenReady = true

	if ( device.GetOwner() == GetLocalClientPlayer() )
		return "#LOBA_ULT_BLACK_MARKET_USE_HINT_OWNER"

	return "#LOBA_ULT_BLACK_MARKET_USE_HINT"
}
#endif


#if SERVER || CLIENT
bool function CanUseBlackMarket( entity player, entity ent, int useFlags )
{
	return SURVIVAL_PlayerAllowedToPickup( player )
}
#endif

#if SERVER || CLIENT
bool function BlackMarket_ShouldUseBlockReload( entity player, entity ent )
{
	return false;
}
#endif


#if SERVER || CLIENT
void function OnBlackMarketUsed( entity blackMarket, entity player, int useInputFlags )
{
	if ( (useInputFlags & USE_INPUT_LONG) == 0 )
		return

	if ( ( useInputFlags & USE_INPUT_ALT ) == 1 )
		return

	#if CLIENT
		if ( Survival_IsGroundlistOpen() )
			return
	#endif

	if ( GradeFlagsHas( blackMarket, eGradeFlags.IS_BUSY ) )
		return

	thread (void function() : ( blackMarket, player ) {
		ExtendedUseSettings settings
		settings.duration = GetCurrentPlaylistVarFloat( "loba_ultimate_open_duration", 0.3 )
		settings.disableWeaponTypes = WPT_TACTICAL | WPT_ULTIMATE | WPT_CONSUMABLE
		settings.loopSound = "UI_Survival_PickupTicker"
		settings.successSound = ""
		#if SERVER
			                                 
			                          
		#elseif CLIENT
			settings.displayRui = $"ui/extended_use_hint.rpak"
			settings.displayRuiFunc = void function( entity blackMarket, entity player, var rui, ExtendedUseSettings settings )
			{
				RuiSetString( rui, "holdButtonHint", settings.holdHint )
				RuiSetString( rui, "hintText", settings.hint )
				RuiSetGameTime( rui, "startTime", Time() )
				RuiSetGameTime( rui, "endTime", Time() + settings.duration )
			}
			settings.icon = $""
			settings.hint = "#PROMPT_OPEN"
			settings.successFunc = void function( entity blackMarket, entity player, ExtendedUseSettings settings )
			{
				OpenSurvivalGroundList( player, blackMarket, eGroundListBehavior.NEARBY, eGroundListType.GRABBER )
				Remote_ServerCallFunction( BLACK_MARKET_OPEN_CMD, blackMarket )
			}
		#endif

		#if CLIENT
			EndSignal( clGlobal.levelEnt, "ClearSwapOnUseThread" )
		#endif
		EndSignal( blackMarket, "OnDestroy" )
		waitthread ExtendedUse( blackMarket, player, settings )
	})()
}
#endif


#if CLIENT
void function OnCharacterButtonPressed( entity player )
{
	entity useEnt = player.GetUsePromptEntity()
	if ( !IsValid( useEnt ) || useEnt.GetNetworkedClassName() != "prop_loot_grabber" )
		return

	if ( useEnt.GetOwner() != player )
		return

	Remote_ServerCallFunction( "ClientCallback_TryPickupBlackMarket", useEnt )
}
#endif


#if SERVER
                                                                                 
 
	                                                
		      

	                                                                                  
		      

	                                      
		      

	                                                   
		      

	                                            

	                                      
		                                           
			                        
				                
		   
		                                         
			                                 
		                                                         
	    
 
#endif


#if CLIENT
void function SetupMapRui( entity ent, var rui, bool isFullMap )
{
	RuiSetAsset( rui, "areaImage", $"rui/hud/character_abilities/loba_ult_map_circle" )
	RuiSetFloat( rui, "areaImageAlpha",
		GetLocalClientPlayer().GetTeam() == TEAM_SPECTATOR ? BLACK_MARKET_PLACEMENT_SPECTATOR_ALPHA : BLACK_MARKET_PLACEMENT_PLAYER_ALPHA )
	RuiSetImage( rui, "clampedImage", $"" )

	string areaColorArgName = "objColor"
	if ( !isFullMap )
	{
		RuiSetBool( rui, "useOverrideColor", true )
		areaColorArgName = "overrideColor"
	}
	RuiSetColorAlpha( rui, areaColorArgName, BLACK_MARKET_PLACEMENT_COLOR, 1 )

	if ( ent.IsClientOnly() )
	{
		RuiSetImage( rui, "centerImage", $"" )
		RuiSetFloat( rui, "objectRadius", ent.e.clientEntMinimapScale )
		thread PROTO_PulseMinimapRui( ent, rui, areaColorArgName )
	}
	else
	{
		RuiSetImage( rui, "centerImage", $"rui/hud/gametype_icons/survival/loba_ult_map_icon" )
		RuiTrackFloat( rui, "objectRadius", ent, RUI_TRACK_MINIMAP_SCALE )
	}
}
#endif

#if CLIENT
void function PROTO_PulseMinimapRui( entity ent, var rui, string argName )
{
	EndSignal( ent, "OnDestroy" )

	while ( true )
	{
		float v = 0.8 + 0.6 * sin( 1.15 * 2 * PI * Time() )
		RuiSetColorAlpha( rui, argName, <v, v, v>, v )
		WaitFrame()
	}
}
#endif


#if SERVER || CLIENT || UI
float function GetBlackMarketNearbyLootRadius()
{
	return GetCurrentPlaylistVarFloat( "loba_ultimate_nearby_loot_radius", 4500.0 )
}
#endif


#if SERVER || CLIENT || UI
int function GetBlackMarketUseLimit()
{
	if ( IsInfiniteAmmoEnabled() )
		return 99
	return GetCurrentPlaylistVarInt( "loba_ultimate_use_limit", 2 )
}
#endif


#if SERVER
                                                   
 
	                                            
 

                                                          
 
	                        
		                                            

	           

	                        
		                                         
 
#endif