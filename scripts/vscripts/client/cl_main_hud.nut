untyped

global function ClMainHud_Init

global function InitChatHUD
global function UpdateChatHUDVisibility

global function MainHud_TurnOff_RUI

global function MainHud_AddClient
global function SetCrosshairPriorityState
global function ClearCrosshairPriority
global function UpdateMainHudVisibility
global function ClientCodeCallback_ControllerModeChanged
global function UpdateMainHudFromCEFlags
global function UpdatePlayerStatusCounts
global function UpdateCoreFX
global function InitCrosshair
global function GetHudStatus
global function DEV_DebugHudStatusThread
global function ShouldOnlyShowMinimap
global function SetAllHudVisExceptMinimap


#if DEV
global function Dev_SetDefaultHUD
#endif

global function IsWatchingReplay

global const MAX_ACTIVE_TRAPS_DISPLAYED = 5
global const VGUI_CLOSED = 0
global const VGUI_CLOSING = 1
global const VGUI_OPEN = 2
global const VGUI_OPENING = 3

global const TEAM_ICON_IMC = $"ui/scoreboard_imc_logo"
global const TEAM_ICON_MILITIA = $"ui/scoreboard_mcorp_logo"

const float OFFHAND_ALERT_ICON_ANIMRATE = 0.35
const float OFFHAND_ALERT_ICON_SCALE = 4.5

const bool ALWAYS_SHOW_BOOST_MOBILITY_BAR = true


struct HudVisibilityStatus
{
	bool mainHud
	bool permanentHud
	bool targetInfoHud
}

struct
{
	table      crosshairPriorityLevel
	array<int> crosshairPriorityOrder

	int iconIdx = 0

	var  rodeoRUI                                                                 
	bool trackingDoF = false
	bool onlyShowMinimap = false
} file

void function ClMainHud_Init()
{
	if ( IsMenuLevel() )
		return

	PrecacheHUDMaterial( TEAM_ICON_IMC )
	PrecacheHUDMaterial( TEAM_ICON_MILITIA )

	RegisterSignal( "MainHud_TurnOn" )
	RegisterSignal( "MainHud_TurnOff" )
	RegisterSignal( "UpdateWeapons" )
	RegisterSignal( "ResetWeapons" )
	RegisterSignal( "UpdateShieldBar" )
	RegisterSignal( "PlayerUsedAbility" )
	RegisterSignal( "UpdateTitanBuildBar" )
	RegisterSignal( "ControllerModeChanged" )
	RegisterSignal( "ActivateTitanCore" )
	RegisterSignal( "AttritionPoints" )
	RegisterSignal( "AttritionPopup" )
	RegisterSignal( "UpdateLastTitanStanding" )
	RegisterSignal( "UpdateMobilityBarVisibility" )
	RegisterSignal( "UpdateFriendlyRodeoTitanShieldHealth" )
	RegisterSignal( "DisableShieldBar" )
	RegisterSignal( "MonitorGrappleMobilityBarState" )
	RegisterSignal( "StopBossIntro" )
	RegisterSignal( "ClearDoF" )

	AddCreateCallback( "titan_cockpit", HudInit )

	AddCallback_OnGameStateChanged( UpdateMainHudFromGameState )
	AddCallback_OnPlayerLifeStateChanged( UpdateMainHudFromLifeState )

	AddOnSpectatorUiStateChanged( OnSpectatorUiStateChanged )

	AddCinematicEventFlagChangedCallback( CE_FLAG_EMBARK, CinematicEventUpdateDoF )
	AddCinematicEventFlagChangedCallback( CE_FLAG_EXECUTION, CinematicEventUpdateDoF )

	StatusEffect_RegisterEnabledCallback( eStatusEffect.titan_damage_amp, DamageAmpEnabled )
	StatusEffect_RegisterDisabledCallback( eStatusEffect.titan_damage_amp, DamageAmpDisabled )

	StatusEffect_RegisterEnabledCallback( eStatusEffect.damageAmpFXOnly, DamageAmpEnabled )
	StatusEffect_RegisterDisabledCallback( eStatusEffect.damageAmpFXOnly, DamageAmpDisabled )

	StatusEffect_RegisterEnabledCallback( eStatusEffect.emp, ScreenEmpEnabled )
	StatusEffect_RegisterDisabledCallback( eStatusEffect.emp, ScreenEmpDisabled )

	AddCallback_OnSettingsUpdated( UpdateShowButtonHintsConvarCache )
	AddCallback_OnSettingsUpdated( UpdateAccessibilityChatHintEnabledCache )
	UpdateShowButtonHintsConvarCache()
	UpdateAccessibilityChatHintEnabledCache()


	if ( !GetConVarBool( "toggle_on_jump_to_deactivate_changed" ) )
	{
		SetConVarBool( "toggle_on_jump_to_deactivate", IsControllerModeActive() ? true : false )
		SetConVarBool( "toggle_on_jump_to_deactivate_changed", false )
	}
}


void function MainHud_AddClient( entity player )
{
	clGlobal.empScreenEffect = Hud.HudElement( "EMPScreenFX" )

	thread ClientHudInit( player )
}


void function HudInit( entity cockpit )
{
	entity player = GetLocalViewPlayer()
	thread MainHUD( cockpit, player )
	cockpit.SetCaptureScreenBeforeViewmodels( true )
}


void function MainHUD( entity cockpit, entity player )
{
	                                                                          
	                               
	                                
	  
	                                                              
	                                                                                                                                                 
	                    
	                                        
	thread MainHud_TurnOff_RUI( cockpit, true )

	HideFriendlyIndicatorAndCrosshairNames()

	cockpit.s.coreFXHandle <- null
	cockpit.s.pilotDamageAmpFXHandle <- null

	UpdateMainHudVisibility( player )

	if ( player == GetLocalClientPlayer() )
	{
		delaythread( 1.0 ) AnnouncementProcessQueue( player )
	}

	foreach ( callbackFunc in clGlobal.pilotHudCallbacks )
	{
		callbackFunc( cockpit, player )
	}

	cockpit.WaitSignal( "OnDestroy" )

	                    
}


void function DamageAmpEnabled( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( ent.IsTitan() )
		UpdateTitanDamageAmpFX( GetLocalPlayerFromSoul( ent ) )
	else
		UpdatePilotDamageAmpFX( ent )
}


void function DamageAmpDisabled( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( ent.IsTitan() )
		UpdateTitanDamageAmpFX( GetLocalPlayerFromSoul( ent ) )
	else
		UpdatePilotDamageAmpFX( ent )
}


void function UpdatePilotDamageAmpFX( entity player )
{
	if ( !IsValid( player ) )
		return

	if ( player != GetLocalViewPlayer() )
		return

	entity cockpit = player.GetCockpit()
	if ( !cockpit )
		return

	if ( !("pilotDamageAmpFXHandle" in cockpit.s) )
		return

	if ( cockpit.s.pilotDamageAmpFXHandle && EffectDoesExist( cockpit.s.pilotDamageAmpFXHandle ) )
	{
		EffectStop( cockpit.s.pilotDamageAmpFXHandle, false, true )                                
	}

	if ( StatusEffect_GetSeverity( player, eStatusEffect.damageAmpFXOnly ) > 0 )
	{
		cockpit.s.pilotDamageAmpFXHandle = StartParticleEffectOnEntity( cockpit, GetParticleSystemIndex( $"P_core_DMG_boost_screen" ), FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID )
	}
}


void function UpdateTitanDamageAmpFX( entity player )
{
	if ( !IsValid( player ) )
		return

	if ( player != GetLocalViewPlayer() )
		return

	entity cockpit = player.GetCockpit()
	if ( !cockpit )
		return

	if ( !("titanDamageAmpFXHandle" in cockpit.s) )
		return

	if ( cockpit.s.titanDamageAmpFXHandle && EffectDoesExist( cockpit.s.titanDamageAmpFXHandle ) )
	{
		EffectStop( cockpit.s.titanDamageAmpFXHandle, false, true )                                
	}

	entity soul = player.GetTitanSoul()
	if ( IsValid( soul ) && (StatusEffect_GetSeverity( soul, eStatusEffect.damageAmpFXOnly ) + StatusEffect_GetSeverity( soul, eStatusEffect.titan_damage_amp )) > 0 )
	{
		cockpit.s.titanDamageAmpFXHandle = StartParticleEffectOnEntity( cockpit, GetParticleSystemIndex( $"P_core_DMG_boost_screen" ), FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID )
	}
}


void function ScreenEmpEnabled( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	thread Chroma_EMPEffect()

	thread EmpStatusEffectThink( player )
}


void function ScreenEmpDisabled( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	clGlobal.empScreenEffect.Hide()
}


void function EmpStatusEffectThink( entity player )
{
	clGlobal.empScreenEffect.Show()
	player.EndSignal( "OnDeath" )

	OnThreadEnd(
		function() : ()
		{
			clGlobal.empScreenEffect.Hide()
		}
	)

	while ( true )
	{
		float effectFrac = StatusEffect_GetSeverity( player, eStatusEffect.emp )

		clGlobal.empScreenEffect.SetAlpha( effectFrac * 255 )

		WaitFrame()
	}
}


void function UpdateCoreFX( entity player )
{
	if ( player != GetLocalViewPlayer() )
		return

	entity cockpit = player.GetCockpit()
	if ( !cockpit )
		return

	if ( cockpit.s.coreFXHandle && EffectDoesExist( cockpit.s.coreFXHandle ) )
	{
		EffectStop( cockpit.s.coreFXHandle, false, true )                                
	}
}


entity function Create_Hud( string cockpitType, entity cockpit, entity player )
{
	string attachment = "CAMERA_BASE"
	int attachId      = cockpit.LookupAttachment( attachment )

	vector origin = <0, 0, 0>
	vector angles = <0, 0, 0>

	origin += AnglesToForward( angles ) * COCKPIT_UI_XOFFSET
	table warpSettings = {
		xWarp = 42.0
		xScale = 1.22
		yWarp = 30.0
		yScale = 0.96
		viewDist = 1.0
	}

	origin += AnglesToRight( angles ) * (-COCKPIT_UI_WIDTH / 2)
	origin += AnglesToUp( angles ) * (-COCKPIT_UI_HEIGHT / 2)

	angles = AnglesCompose( angles, <0, -90, 90> )

	entity vgui = CreateClientsideVGuiScreen( cockpitType, VGUI_SCREEN_PASS_COCKPIT, origin, angles, COCKPIT_UI_WIDTH, COCKPIT_UI_HEIGHT )
	vgui.s.panel <- vgui.GetPanel()
	vgui.s.baseOrigin <- origin
	vgui.s.warpSettings <- warpSettings

	vgui.SetParent( cockpit, attachment )
	vgui.SetAttachOffsetOrigin( origin )
	vgui.SetAttachOffsetAngles( angles )

	return vgui
}


void function UpdateMinimapVisibility()
{
	entity player = GetLocalClientPlayer()

	if ( IsWatchingReplay() )
	{
		return
	}
	Minimap_UpdateMinimapVisibility( GetLocalViewPlayer() )
}


void function OnSpectatorUiStateChanged( int newState )
{
	if ( GetLocalClientPlayer().GetTeam() == TEAM_SPECTATOR )
	{
		if ( newState == SPEC_UI_STATE_SHOW_ONLY_MINIMAP )
		{
			SetAllHudVisExceptMinimap( false )
			file.onlyShowMinimap = true
		}
		else
		{
			SetAllHudVisExceptMinimap( true )
			file.onlyShowMinimap = false
		}
	}
}


bool function ShouldOnlyShowMinimap()
{
	return file.onlyShowMinimap
}


void function UpdatePlayerStatusCounts()
{
	if ( !GetCurrentPlaylistVarInt( "hud_score_enabled", 1 ) )
		return

	clGlobal.levelEnt.Signal( "UpdatePlayerStatusCounts" )                                    
}


void function UpdateMainHudFromCEFlags( entity player )
{
	UpdateMainHudVisibility( player )
}


void function UpdateMainHudFromGameState( int newVal )
{
	entity player = GetLocalViewPlayer()

	if ( IsValid( player ) )
		UpdateMainHudVisibility( player, 1.0 )
}


void function UpdateMainHudFromLifeState( entity player, int oldLifeState, int newLifeState )
{
	if ( player != GetLocalClientPlayer() && player != GetLocalViewPlayer() )
		return

	UpdateMainHudVisibility( player, 1.0 )

	if ( IsSpectating() && !IsAlive( player ) || IsAlive( player ) )                                                                                                                      
	{
		                                              
		RefreshUnitframesForPlayer( player )
	}
}


void function UpdateMainHudVisibility( entity player, float duration = 0.0 )
{
	int ceFlags = player.GetCinematicEventFlags()

	HudVisibilityStatus hudStatus  = GetHudStatus( player )
	bool shouldBeVisible           = hudStatus.mainHud
	bool shouldBeVisiblePermanent  = hudStatus.permanentHud
	bool shouldBeVisibleTargetInfo = hudStatus.targetInfoHud

	if ( shouldBeVisiblePermanent )
		ShowPermanentHudTopo()
	else
		HidePermanentHudTopo()

	if ( shouldBeVisible )
		ShowFriendlyIndicatorAndCrosshairNames()
	else
		HideFriendlyIndicatorAndCrosshairNames()

	if ( ShouldOnlyShowMinimap() )
	{
		SetAllHudVisExceptMinimap( false )
		return
	}

	entity cockpit = player.GetCockpit()
	if ( !cockpit )
		return

	  
		                                    
		                
			      

		                                                                                                           
	  
	bool isVisible        = cockpit.e.hudVisible
	bool hideHudInstantly = true                                                                                       

	if ( !shouldBeVisible )
		thread MainHud_TurnOff_RUI( cockpit, hideHudInstantly )
	else
		thread MainHud_TurnOn_RUI( cockpit )

	                                      
	   
	  	                                                            
	  	                    
	  	 
	  		              
	  		                               
	  			              
	  		                                       
	  			              
	  	 
	  
	  	                                                                                                                                                                                                                                     
	   
	                                           
	   
	  	                     
	  	                                                            
	  
	  	                    
	  		              
	  
	  	                                                                                                                                                                                                                                    
	   

	if ( shouldBeVisibleTargetInfo )
		ShowTargetInfoHudTopo()
	else
		HideTargetInfoHudTopo()
}


void function MainHud_TurnOn( entity vgui, float duration, float xWarp, float xScale, float yWarp, float yScale, float viewDist )
{
	vgui.EndSignal( "OnDestroy" )

	vgui.Signal( "MainHud_TurnOn" )
	vgui.EndSignal( "MainHud_TurnOn" )
	vgui.EndSignal( "MainHud_TurnOff" )

	if ( vgui.s.enabledState == VGUI_OPEN || vgui.s.enabledState == VGUI_OPENING )
		return

	vgui.s.enabledState = VGUI_OPENING

	                                                                           

	if ( !IsWatchingReplay() )
	{
		vgui.s.panel.WarpGlobalSettings( xWarp, 0, yWarp, 0, viewDist )
		                                                                        

		float xTimeScale = 0
		float yTimeScale = 0
		float startTime  = Time()

		while ( yTimeScale < 1.0 )
		{
			xTimeScale = expect float( Anim_EaseIn( GraphCapped( Time() - startTime, 0.0, duration / 2, 0.0, 1.0 ) ) )
			yTimeScale = expect float( Anim_EaseIn( GraphCapped( Time() - startTime, duration / 4, duration, 0.01, 1.0 ) ) )

			                                                                                           
			                                                 
			                                           
			vgui.s.panel.WarpGlobalSettings( xWarp, xScale * xTimeScale, yWarp, yScale * yTimeScale, viewDist )
			WaitFrame()
		}
	}

	                                                        
	vgui.s.panel.WarpGlobalSettings( xWarp, xScale, yWarp, yScale, viewDist )
	vgui.s.enabledState = VGUI_OPEN
}


void function MainHud_TurnOn_RUI( entity cockpit, bool instant = false )
{
	clGlobal.levelEnt.Signal( "MainHud_TurnOn" )
	clGlobal.levelEnt.EndSignal( "MainHud_TurnOn" )
	clGlobal.levelEnt.EndSignal( "MainHud_TurnOff" )

	UpdateFullscreenTopology( clGlobal.topoFullscreenHud, true )

	cockpit.e.hudVisible = true
}


void function MainHud_TurnOff( entity vgui, float duration, float xWarp, float xScale, float yWarp, float yScale, float viewDist )
{
	vgui.EndSignal( "OnDestroy" )

	vgui.Signal( "MainHud_TurnOff" )
	vgui.EndSignal( "MainHud_TurnOff" )
	vgui.EndSignal( "MainHud_TurnOn" )

	if ( vgui.s.enabledState == VGUI_CLOSED || vgui.s.enabledState == VGUI_CLOSING )
		return

	vgui.s.enabledState = VGUI_CLOSING

	vgui.s.panel.WarpGlobalSettings( xWarp, xScale, yWarp, yScale, viewDist )
	                                                        

	float xTimeScale = 1.0
	float yTimeScale = 1.0
	float startTime  = Time()

	while ( xTimeScale > 0.0 )
	{
		xTimeScale = expect float( Anim_EaseOut( GraphCapped( Time() - startTime, duration * 0.1, duration, 1.0, 0.0 ) ) )
		yTimeScale = expect float( Anim_EaseOut( GraphCapped( Time() - startTime, 0.0, duration * 0.5, 1.0, 0.01 ) ) )

		                                                                                  
		vgui.s.panel.WarpGlobalSettings( xWarp, xScale * xTimeScale, yWarp, yScale * yTimeScale, viewDist )
		WaitFrame()
	}

	                                                                        
	vgui.s.panel.WarpGlobalSettings( xWarp, 0, yWarp, 0, viewDist )

	vgui.s.enabledState = VGUI_CLOSED
}


void function MainHud_TurnOff_RUI( entity cockpit, bool instant = false )
{
	clGlobal.levelEnt.Signal( "MainHud_TurnOff" )
	clGlobal.levelEnt.EndSignal( "MainHud_TurnOff" )
	clGlobal.levelEnt.EndSignal( "MainHud_TurnOn" )

	UISize screenSize              = GetScreenSize()
	UISize scaledVirtualScreenSize = GetScaledVirtualScreenSize( GetCurrentVirtualScreenSize( true ), GetScreenSize() )

	                                                                       
	                                                                           

	                 
	   
	  	                                                                       
	  	                             
	  	                                
	  
	  	                        
	  	                                                                    
	  
	  	              
	  	 
	  		                   
	  
	  		                      
	  			     
	  
	  		                                    
	  
	  		                                                                                      
	  		 
	  			                  
	  			              
	  		 
	  
	  		                                                        
	  		                                                         
	  		                                                                                             
	  
	  		           
	  	 
	   

	cockpit.e.hudVisible = false
	RuiTopology_UpdatePos( clGlobal.topoFullscreenHud, <0, 0, 0>, <0, 0, 0>, <0, 0, 0> )
}


void function HidePermanentHudTopo()
{
	RuiTopology_UpdatePos( clGlobal.topoFullscreenHudPermanent, <0, 0, 0>, <0, 0, 0>, <0, 0, 0> )
}


void function ShowPermanentHudTopo()
{
	UpdateFullscreenTopology( clGlobal.topoFullscreenHudPermanent, true )
}


void function HideTargetInfoHudTopo()
{
	RuiTopology_UpdatePos( clGlobal.topFullscreenTargetInfo, <0, 0, 0>, <0, 0, 0>, <0, 0, 0> )
}


void function ShowTargetInfoHudTopo()
{
	UpdateFullscreenTopology( clGlobal.topFullscreenTargetInfo, true )
}


void function InitCrosshair()
{
	                                                                                                                                       
	                                                                                                    
	file.crosshairPriorityOrder.append( crosshairPriorityLevel.ROUND_WINNING_KILL_REPLAY )
	file.crosshairPriorityOrder.append( crosshairPriorityLevel.MENU )
	file.crosshairPriorityOrder.append( crosshairPriorityLevel.PREMATCH )
	file.crosshairPriorityOrder.append( crosshairPriorityLevel.TITANHUD )
	file.crosshairPriorityOrder.append( crosshairPriorityLevel.DEFAULT )

	foreach ( priority in file.crosshairPriorityOrder )
		file.crosshairPriorityLevel[priority] <- null

	                   
	file.crosshairPriorityLevel[crosshairPriorityLevel.DEFAULT] = CROSSHAIR_STATE_SHOW_ALL
	UpdateCrosshairState()
}


void function SetCrosshairPriorityState( int priority, int state )
{
	Assert( priority != crosshairPriorityLevel.DEFAULT, "Default crosshair state priority level should never be changed." )

	file.crosshairPriorityLevel[priority] = state

	UpdateCrosshairState()
}


void function UpdateCrosshairState()
{
	foreach ( priority in file.crosshairPriorityOrder )
	{
		if ( priority in file.crosshairPriorityLevel && file.crosshairPriorityLevel[priority] != null )
		{
			Crosshair_SetState( file.crosshairPriorityLevel[priority] )
			return
		}
	}
}


void function ClearCrosshairPriority( int priority )
{
	Assert( priority != crosshairPriorityLevel.DEFAULT, "Default crosshair state priority level should never be cleared." )

	if ( priority in file.crosshairPriorityLevel )
		file.crosshairPriorityLevel[priority] = null

	UpdateCrosshairState()
}


void function ClientCodeCallback_ControllerModeChanged( bool controllerModeEnabled )
{
	entity player = GetLocalClientPlayer()
	if ( IsValid( player ) )
		player.Signal( "ControllerModeChanged" )

	if ( !GetConVarBool( "toggle_on_jump_to_deactivate_changed" ) )
	{
		SetConVarBool( "toggle_on_jump_to_deactivate", IsControllerModeActive() ? true : false )
		SetConVarBool( "toggle_on_jump_to_deactivate_changed", false )
	}
}


void function DrawAttentionToTestMap( var elem )
{
	for ( ; ; )
	{
		wait 120
		Hud_SetPos( elem, -1700, -1400 )
		Hud_ReturnToBasePosOverTime( elem, 4, 2 )
	}
}


void function ClientHudInit( entity player )
{
	Assert( player == GetLocalClientPlayer() )

	#if DEV
		HudElement( "Dev_Info1" ).Hide()
		HudElement( "Dev_Info2" ).Hide()
		HudElement( "Dev_Info3" ).Hide()
		{
			if ( IsTestMap() && !IsPVEMode() )
			{
				var elem = HudElement( "Dev_Info3" )
				Hud_SetText( elem, "Test Map" )
				Hud_Show( elem )

				                        
				 
					                      
					                         
					                  
					                       
					                 
					              
					                                
						                                    
						     
					        
						                                     
						     
				   
			}
		}
	#endif       
}


void function CinematicEventUpdateDoF( entity player )
{
	if ( player != GetLocalClientPlayer() )
		return

	if ( ShouldHaveFarDoF( player ) )
	{
		                                      
		if ( !file.trackingDoF )
			thread TrackDoF( player )
	}
	else
	{
		player.Signal( "ClearDoF" )
		                                   
	}
}


void function TrackDoF( entity player )
{
	file.trackingDoF = true
	player.EndSignal( "OnDeath" )
	player.EndSignal( "ClearDoF" )

	OnThreadEnd(
		function() : ()
		{
			file.trackingDoF = false
			DoF_LerpNearDepthToDefault( 1.0 )
			DoF_LerpFarDepthToDefault( 1.0 )
		}
	)

	float tick = 0.25

	while ( 1 )
	{
		float playerDist    = Distance2D( player.CameraPosition(), player.GetOrigin() )
		float distToCamNear = playerDist
		float distToCamFar  = distToCamNear

		entity target = GetTitanFromPlayer( player )

		if ( !IsValid( target ) && player.GetObserverMode() == OBS_MODE_CHASE )
		{
			target = player.GetObserverTarget()
		}

		if ( !IsValid( target ) && player.ContextAction_IsMeleeExecutionTarget() )
		{
			entity targetParent = player.GetParent()
			if ( IsValid( targetParent ) )
				target = targetParent
		}

		if ( IsValid( target ) && target != player )
		{
			float targetDist = Distance( player.CameraPosition(), target.EyePosition() )
			distToCamFar  = max( playerDist, targetDist )
			distToCamNear = min( playerDist, targetDist )
		}

		float farDepthScalerA = 1
		float farDepthScalerB = 3

		if ( IsValid( target ) )
		{
			farDepthScalerA = 2
			farDepthScalerB = 10
		}

		float nearDepthStart = 0
		float nearDepthEnd   = clamp( min( 50, distToCamNear - 100 ), 0, 50 )
		DoF_LerpNearDepth( nearDepthStart, nearDepthEnd, tick )
		float farDepthStart = distToCamFar + distToCamFar * farDepthScalerA
		float farDepthEnd   = distToCamFar + distToCamFar * farDepthScalerB
		DoF_LerpFarDepth( farDepthStart, farDepthEnd, tick )

		wait tick
	}
}


bool function ShouldHaveFarDoF( entity player )
{
	int ceFlags = player.GetCinematicEventFlags()

	if ( ceFlags & CE_FLAG_EMBARK )
		return true

	if ( ceFlags & CE_FLAG_EXECUTION )
		return true

	return false
}


bool function ShouldHideHudForDeadPlayer( entity player )
{
	if ( IsAlive( player ) )
		return false

	entity localPlayer = GetLocalClientPlayer()
	if ( localPlayer.GetTeam() == TEAM_SPECTATOR )
		return false

	if ( !localPlayer.IsObserver() )
		return true

	entity obsTarget = localPlayer.GetObserverTarget()
	if ( obsTarget == localPlayer )
		return true

	if ( obsTarget == null && !IsObserverModeValidWithoutObserverTarget( localPlayer ) )
		return true

	                                                                    
	return false
}


bool function ShouldMainHudBeVisible( entity player )
{
	int ceFlags = player.GetCinematicEventFlags()

	if ( ceFlags & CE_FLAG_EMBARK )
		return false

	if ( ceFlags & CE_FLAG_DISEMBARK )
		return false

	if ( ceFlags & CE_FLAG_INTRO )
		return false

	if ( ceFlags & CE_FLAG_CLASSIC_MP_SPAWNING )
		return false

	if ( ceFlags & CE_FLAG_HIDE_MAIN_HUD )
		return false

	if ( ceFlags & CE_FLAG_HIDE_MAIN_HUD_INSTANT )
		return false

	if ( ceFlags & CE_FLAG_EOG_STAT_DISPLAY )
		return false

	if ( ceFlags & CE_FLAG_TITAN_3P_CAM && !IsSpectating() )
		return false

	if ( clGlobal.isSoloDialogMenuOpen )
		return false

	entity viewEntity = GetViewEntity()
	if ( IsValid( viewEntity ) && viewEntity.IsNPC() )
		return false

	if ( ShouldHideHudForDeadPlayer( player ) )
		return false

	if ( IsViewingSquadSummary() || IsViewingDeathRecap() )
		return false

	if ( Scoreboard_IsVisible() )
		return false

	int gameState = GetGameState()
	switch( gameState )
	{
		case eGameState.WaitingForCustomStart:
		case eGameState.WaitingForPlayers:
			break

		case eGameState.PickLoadout:
			return false

		case eGameState.Prematch:
			if ( !GetCurrentPlaylistVarBool( "show_hud_in_prematch", false ) )
				return false
			else
				break

		case eGameState.Playing:
		case eGameState.SuddenDeath:
		case eGameState.SwitchingSides:
		case eGameState.Epilogue:
			break

		case eGameState.WinnerDetermined:
		case eGameState.Resolution:
		case eGameState.Postmatch:
			return false
	}

	#if DEV
		if ( IsModelViewerActive() )
			return false
	#if PC_PROG
		if ( OutsourceViewer_IsActive() )
			return false
	#endif               
	#endif           

	return true
}


HudVisibilityStatus function GetHudStatus( entity player )
{
	bool showMainHud      = ShouldMainHudBeVisible( player )
	bool showPermanentHud = ShouldPermanentHudBeVisible( player )

	HudVisibilityStatus hudStatus
	hudStatus.mainHud       = showMainHud
	hudStatus.targetInfoHud = showPermanentHud
	hudStatus.permanentHud  = showPermanentHud

	return hudStatus
}


void function DEV_DebugHudStatusThread()
{
	RegisterSignal( "DEV_DebugHudStatusThread" )
	Signal( clGlobal.signalDummy, "DEV_DebugHudStatusThread" )
	EndSignal( clGlobal.signalDummy, "DEV_DebugHudStatusThread" )

	while ( true )
	{
		HudVisibilityStatus hudStatus = GetHudStatus( GetLocalViewPlayer() )

		DebugScreenText( 0.90, 0.5, format( "mainHud: %s", hudStatus.mainHud ? "ON" : "OFF" ) )
		DebugScreenText( 0.90, 0.512, format( "permanentHud: %s", hudStatus.permanentHud ? "ON" : "OFF" ) )

		WaitFrame()
	}
}


bool function ShouldPermanentHudBeVisible( entity player )
{
	if ( IsViewingSquadSummary() || IsViewingDeathRecap() )
		return false

	                                                                     
	int gameState = GetGameState()
	switch( gameState )
	{
		case eGameState.WaitingForCustomStart:
		case eGameState.WaitingForPlayers:
			break

		case eGameState.PickLoadout:
			return false

		case eGameState.Prematch:
			if ( !GetCurrentPlaylistVarBool( "show_hud_in_prematch", false ) )
				return false
			else
				break

		case eGameState.Playing:
		case eGameState.SuddenDeath:
		case eGameState.SwitchingSides:
		case eGameState.Epilogue:
			break

		case eGameState.WinnerDetermined:
		case eGameState.Resolution:
		case eGameState.Postmatch:
			return false
	}

	if ( Scoreboard_IsVisible() )
		return false

	{
		int ceFlags = player.GetCinematicEventFlags()

		                        
		if ( ceFlags & CE_FLAG_TITAN_3P_CAM && !IsSpectating() )
			return false

		if ( ceFlags & CE_FLAG_HIDE_PERMANENT_HUD )
			return false
	}

	if ( ShouldHideHudForDeadPlayer( player ) && !Control_IsModeEnabled() )
		return false

	#if DEV
		if ( IsModelViewerActive() )
			return false
	#if PC_PROG
		if ( OutsourceViewer_IsActive() )
			return false
	#endif               
	#endif           

	return true
}


bool function IsObserverModeValidWithoutObserverTarget( entity player )
{
	switch( player.GetObserverMode() )
	{
		case OBS_MODE_STATIC:
		case OBS_MODE_STATIC_LOCKED:
			return true
	}

	return false
}


void function InitChatHUD()
{
	UpdateChatHUDVisibility()

	if ( IsLobby() )
		return

	UISize screenSize   = GetScreenSize()
	float resMultiplier = screenSize.height / 1080.0
	int width           = 630
	int height          = 200

	Hud_SetSize( HudElement( "IngameTextChat" ), width * resMultiplier, height * resMultiplier )
}


void function UpdateChatHUDVisibility()
{
	var chat = HudElement( "IngameTextChat" )

	Hud_SetAboveBlur( chat, true )

	if ( IsLobby() || clGlobal.isMenuOpen )
		Hud_Hide( chat )
	else
		Hud_Show( chat )

	var hint = HudElement( "AccessibilityHint" )

	int gamestate = GetGameState()

	if ( IsLobby() || clGlobal.isMenuOpen || !IsAccessibilityChatHintEnabled() || GetPlayerArrayOfTeam( GetLocalClientPlayer().GetTeam() ).len() < 2 || VoiceIsRestricted() || gamestate == eGameState.PickLoadout )
		Hud_Hide( hint )
	else
		Hud_Show( hint )
}


bool function IsWatchingReplay()
{
	if ( IsWatchingKillReplay() )
		return true

	if ( IsWatchingSpecReplay() )
		return true

	return false
}


void function SetAllHudVisExceptMinimap( bool toggle )
{
	RuiSetBool( GetPilotRui(), "isVisible", toggle )
	RuiSetBool( ClGameState_GetRui(), "isVisible", toggle )
	RuiSetBool( GetDpadMenuRui(), "isVisible", toggle )
	RuiSetBool( GetWeaponRui(), "isVisible", toggle )
	RuiSetBool( GetTacticalRui(), "isVisible", toggle )
	RuiSetBool( GetUltimateRui(), "isVisible", toggle )

	foreach ( unitFrame in GetTeamUnitFrames() )
	{
		RuiSetBool( unitFrame.rui, "isVisible", toggle )
	}

	if ( GetCompassRui() != null )
		RuiSetBool( GetCompassRui(), "isVisible", toggle )

	Obituary_SetEnabled( toggle )
	Obituary_ClearObituary()
}

#if DEV
                                                           
void function Dev_SetDefaultHUD( bool toggle )
{
	RuiSetBool( GetPilotRui(), "isVisible", toggle )
	RuiSetBool( ClGameState_GetRui(), "isVisible", toggle )
	RuiSetBool( GetDpadMenuRui(), "isVisible", toggle )
	RuiSetBool( GetWeaponRui(), "isVisible", toggle )
	RuiSetBool( GetTacticalRui(), "isVisible", toggle )
	RuiSetBool( GetUltimateRui(), "isVisible", toggle )

	foreach ( unitFrame in GetTeamUnitFrames() )
	{
		RuiSetBool( unitFrame.rui, "isVisible", toggle )
	}

	if ( GetCompassRui() != null )
		RuiSetBool( GetCompassRui(), "isVisible", toggle )
}
#endif