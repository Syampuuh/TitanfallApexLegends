global function InitDeathScreenMenu

               
global function UI_OpenDeathScreenMenu
global function UI_CloseDeathScreenMenu
global function UI_EnableDeathScreenTab
global function UI_SwitchToDeathScreenTab
global function UI_SetDeathScreenTabTitle
global function UI_DeathScreenUpdateHeader
global function UI_DeathScreenHideTabs
global function UI_DeathScreenSetRespawnStatus
global function UI_DeathScreenSetSpectateTargetCount
global function UI_DeathScreenSetCanReportRecapPlayer
global function UI_DeathScreenSetObserverMode
global function UI_DeathScreenSetBlockPlayer
global function UI_SetCanShowGladCard
global function UI_SetShouldShowSkip
global function UI_SetIsEliminiated
global function UI_DeathScreenFadeInBlur
global function UI_SetAllowGladCard

global function DeathScreenIsOpen
global function DeathScreenOnReportButtonClick
global function DeathScreenOnBlockButtonClick
global function DeathScreenTryToggleGladCard
global function DeathScreenPingRespawn
global function DeathScreenSpectateNext
global function DeathScreenSkipDeathCam
global function DeathScreenSkipRecap
global function DeathScreenUpdateCursor
global function DeathScreenGetHeader

global function InitDeathScreenPanelFooter

#if DEV
global function ShowBanner
#endif

struct
{
	var       menu
	bool      tabsInitialized
	float     menuOpenTime
	bool      isGladCardShowing = true	                            
	bool      canShowGladCard = true	                   
	bool      canReportRecapPlayer
	int       observerMode
	string    blockEAID
	string    blockHardware
	bool      shouldShowSkip
	bool      isEliminated
	int       respawnStatus
	int       spectateTargetCount
	bool      allowGladCard = true
	InputDef& gladCardToggleInputData

} file


void function InitDeathScreenMenu( var newMenuArg )                                               
{
	var menu = GetMenu( "DeathScreenMenu" )
	file.menu = menu

	SetMenuReceivesCommands( file.menu, true )
	DeathScreen_AddPassthroughCommandsToMenu( menu )                                            

	AddUICallback_UIShutdown( DeathScreenMenu_Shutdown )
	AddUICallback_OnResolutionChanged( DeathScreenMenu_OnResolutionChanged )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, DeathScreenMenuOnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, DeathScreenMenuOnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, DeathScreenMenuOnNavBack )
	AddMenuEventHandler( menu, eUIEvent.MENU_INPUT_MODE_CHANGED, OnSurvivalInventory_OnInputModeChange )

	HudElem_SetChildRuiArg( Hud_GetChild( menu, "TabsCommon" ), "Background", "bgColor", <0, 0, 1>, eRuiArgType.VECTOR )
	HudElem_SetChildRuiArg( Hud_GetChild( menu, "TabsCommon" ), "Background", "bgAlpha", 1.6, eRuiArgType.FLOAT )

	SetTabRightSound( menu, "UI_InGame_InventoryTab_Select" )
	SetTabLeftSound( menu, "UI_InGame_InventoryTab_Select" )


}


void function InitDeathScreenPanelFooter( var panel, int panelID )
{
	                   
	AddPanelFooterOption( panel, RIGHT, BUTTON_START, true, "#BUTTON_OPEN_MENU", "#BUTTON_OPEN_MENU", DeathScreenTryOpenSystemMenu, DeathScreenShowMenuButton )
	AddPanelFooterOption( panel, RIGHT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK", null, DeathScreenShowNavBack )


	                  
	AddPanelFooterOption( panel, RIGHT, KEY_SPACE, true, "#BUTTON_LOBBY_RETURN", "#BUTTON_LOBBY_RETURN", DeathScreenLeaveGameDialog, DeathScreenShowLobbyButton )
	AddPanelFooterOption( panel, RIGHT, KEY_SPACE, true, "", "#SPACE_LOBBY_RETURN", DeathScreenLeaveGameDialog, DeathScreenShowLobbySpace )

	#if PC_PROG
		                                                  
		AddPanelFooterOption( panel, RIGHT, KEY_ENTER, false, "", "", UI_OnLoadoutButton_Enter )
	#endif

	                            
	switch( panelID )
	{
		case eDeathScreenPanel.DEATH_RECAP:
			AddPanelFooterOption( panel, RIGHT, BUTTON_STICK_RIGHT, true, "#BUTTON_REPORT_PLAYER", "#BUTTON_REPORT_PLAYER", DeathScreenOnReportButtonClick, DeathRecapCanReportPlayer )
			AddPanelFooterOption( panel, RIGHT, BUTTON_STICK_LEFT, true, "#BUTTON_BLOCK_PLAYER", "#BUTTON_BLOCK_PLAYER", DeathScreenOnBlockButtonClick, CanBlockPlayer )
                           
				AddPanelFooterOption( panel, LEFT, BUTTON_X, true, "#X_BUTTON_SKIP", "#X_BUTTON_SKIP", DeathScreenSkipRecap, CanSkipRecap )
         
			break

		case eDeathScreenPanel.SPECTATE:
			AddPanelFooterOption( panel, RIGHT, BUTTON_STICK_RIGHT, true, "#BUTTON_REPORT_PLAYER", "#BUTTON_REPORT_PLAYER", DeathScreenOnReportButtonClick, CanReportPlayer )
			                                                                                                                                              
			                                                                                                                                                              
			                
			AddPanelFooterOption( panel, LEFT, BUTTON_X, true, "#DEATH_SCREEN_NEXT_SPECTATE", "#DEATH_SCREEN_NEXT_SPECTATE", DeathScreenSpectateNext, DeathScreenCanChangeSpectateTarget )

			                      
			string gladCardMessageString = "#SPECTATE_HIDE_BANNER"
			if ( !IsGladCardShowing() )
				gladCardMessageString = "#SPECTATE_SHOW_BANNER"

			file.gladCardToggleInputData = AddPanelFooterOption( panel, LEFT, BUTTON_Y, true, gladCardMessageString, gladCardMessageString, DeathScreenTryToggleGladCard, AllowGladCard )

			AddPanelFooterOption( panel, LEFT, BUTTON_A, true, "#BUTTON_SKIP", "#BUTTON_SKIP", DeathScreenSkipDeathCam, CanSkipDeathCam )

			AddPanelFooterOption( panel, LEFT, BUTTON_A, true, "#HINT_PING_GLADIATOR_CARD", "#HINT_PING_GLADIATOR_CARD", DeathScreenPingRespawn, DeathScreenRespawnWaitingForPickup )
			AddPanelFooterOption( panel, LEFT, BUTTON_A, true, "#HINT_PING_RESPAWN_BEACON", "#HINT_PING_RESPAWN_BEACON", DeathScreenPingRespawn, DeathScreenRespawnWaitingForDelivery )
			break

		case eDeathScreenPanel.SQUAD_SUMMARY:
			break
		case eDeathScreenPanel.SCOREBOARD:

			break

		default:
			unreachable
	}

#if DEV
	AddMenuThinkFunc( Hud_GetParent( panel ), DeathScreenPanelFooterAutomationThink )
#endif       

#if NX_PROG || PC_PROG_NX_UI
	                                                                                  
	if( panelID !=  eDeathScreenPanel.SCOREBOARD )
	{
		UISize screenSize   = GetScreenSize()
		float resMultiplier = screenSize.height / 1080.0
		int width           = 900
		int height          = 200

		var chatbox = Hud_GetChild( panel, "LobbyChatBox" )

		Hud_SetSize( chatbox, width * resMultiplier, height * resMultiplier )
	}
#endif
}


void function DeathScreenMenuOnOpen()
{
	                                       
	bool showTabs = !Control_IsModeEnabled() || GetGameState() == eGameState.Resolution

	if ( !file.tabsInitialized )
	{
		TabData tabData = GetTabDataForPanel( file.menu )
		tabData.centerTabs = true

		AddTab( file.menu, Hud_GetChild( file.menu, "DeathScreenSpectate" ), "#DEATH_SCREEN_SPECTATE" )		    
		AddTab( file.menu, Hud_GetChild( file.menu, "DeathScreenRecap" ), "#DEATH_SCREEN_RECAP" )			    
		AddTab( file.menu, Hud_GetChild( file.menu, "DeathScreenGenericScoreboardPanel" ), "#TAB_SCOREBOARD" )
		AddTab( file.menu, Hud_GetChild( file.menu, "DeathScreenSquadSummary" ), "#DEATH_SCREEN_SUMMARY" )	    

		file.tabsInitialized = true
	}

	TabData tabData        = GetTabDataForPanel( file.menu )
	TabDef recapTab        = Tab_GetTabDefByBodyName( tabData, "DeathScreenRecap" )
	TabDef spectateTab     = Tab_GetTabDefByBodyName( tabData, "DeathScreenSpectate" )
	TabDef scoreboardTab   = Tab_GetTabDefByBodyName( tabData, "DeathScreenGenericScoreboardPanel" )
	TabDef squadSummaryTab = Tab_GetTabDefByBodyName( tabData, "DeathScreenSquadSummary" )

	spectateTab.title = "#DEATH_SCREEN_SPECTATE"

	SetTabDefEnabled( recapTab, false )
	SetTabDefEnabled( spectateTab, false )
	SetTabDefEnabled( scoreboardTab, false )
	SetTabDefEnabled( squadSummaryTab, false )

	SetTabDefVisible( recapTab, false )
	SetTabDefVisible( spectateTab, false )
	SetTabDefVisible( scoreboardTab, false )
	SetTabDefVisible( squadSummaryTab, false )

	UpdateMenuTabs()

	if( showTabs )
		Hud_Show( Hud_GetChild( file.menu, "TabsCommon" ) )
	else
		Hud_Hide( Hud_GetChild( file.menu, "TabsCommon" ) )


	SetTabNavigationEnabled( file.menu, true )

	var screenBlur = Hud_GetChild( file.menu, "ScreenBlur" )
	HudElem_SetRuiArg( screenBlur, "startTime", ClientTime(), eRuiArgType.GAMETIME )                                                                                           

  	                                         

	file.menuOpenTime = UITime()
	                               
	file.respawnStatus = 0
	file.spectateTargetCount = 0
	file.shouldShowSkip = true                                                   

	UISize screenSize = GetScreenSize()
	SetCursorPosition( <1920.0 * 0.5, 1080.0 * 0.5, 0> )

	                                                                                                                                                                                          
	RunClientScript( "UICallback_ToggleGladCard", file.isGladCardShowing )

	if( !IsPrivateMatch() )
	{
		RegisterButtonPressedCallback( BUTTON_DPAD_LEFT, UI_FullmapChallengeCategoryLeft )
		RegisterButtonPressedCallback( BUTTON_DPAD_RIGHT, UI_FullmapChallengeCategoryRight )
		RegisterButtonPressedCallback( KEY_Y, UI_FullmapChallengeCategoryRight )
	}

	#if DEV
		RegisterButtonPressedCallback( KEY_PAD_ENTER, DevExit )
	#endif

	UpdateFooterOptions()
}


void function DeathScreenMenuOnClose()
{
	TabData tabData = GetTabDataForPanel( file.menu )
	DeactivateTab( tabData )

	if( !IsPrivateMatch() )
	{
		DeregisterButtonPressedCallback( BUTTON_DPAD_LEFT, UI_FullmapChallengeCategoryLeft )
		DeregisterButtonPressedCallback( BUTTON_DPAD_RIGHT, UI_FullmapChallengeCategoryRight )
		DeregisterButtonPressedCallback( KEY_Y, UI_FullmapChallengeCategoryRight )
	}

	#if DEV
		DeregisterButtonPressedCallback( KEY_PAD_ENTER, DevExit )
	#endif

	if ( IsFullyConnected() )
		RunClientScript( "UICallback_CloseDeathScreenMenu" )
}


void function UI_OpenDeathScreenMenu( int tabIndex )
{
	                                                                  
	                                                                                                              
	CloseAllMenus()

	if ( !MenuStack_Contains( file.menu ) )
	{
		AdvanceMenu( file.menu )
		                                               
	}

	EnableDeathScreenTab_Internal( tabIndex, true )

	                                                                 
	TabData tabData = GetTabDataForPanel( file.menu )
	ActivateTab( tabData, tabIndex )
}


void function UI_CloseDeathScreenMenu()
{
	                                           

	if ( GetActiveMenu() == file.menu )
	{
		CloseActiveMenu()
	}
	else if ( MenuStack_Contains( file.menu ) )
	{
		if( IsDialog( GetActiveMenu() ) )
		{
			                                                                                                  
			CloseAllMenus()
		}
		else
		{
			                                                                                                                                                
			MenuStack_Remove( file.menu )
			DeathScreenMenuOnClose()
		}
	}
}


void function UI_EnableDeathScreenTab( int tabIndex, bool enable )
{
	                                                           
	EnableDeathScreenTab_Internal( tabIndex, enable )
}


void function EnableDeathScreenTab_Internal( int tabIndex, bool enable )
{
	if ( !MenuStack_Contains( file.menu ) )
		return

	string panelName
	switch( tabIndex )
	{
		case eDeathScreenPanel.DEATH_RECAP:
			panelName = "DeathScreenRecap"
			break

		case eDeathScreenPanel.SPECTATE:
			panelName = "DeathScreenSpectate"
			break

		case eDeathScreenPanel.SCOREBOARD:
			panelName = "DeathScreenGenericScoreboardPanel"
			break

		case eDeathScreenPanel.SQUAD_SUMMARY:
			panelName = "DeathScreenSquadSummary"
			break

		default:
			unreachable
			break
	}

	                                                                            


	TabData tabData        = GetTabDataForPanel( file.menu )
	TabDef squadSummaryTab = Tab_GetTabDefByBodyName( tabData, panelName )

	SetTabDefEnabled( squadSummaryTab, enable )
	SetTabDefVisible( squadSummaryTab, enable )

	if ( !enable && tabData.activeTabIdx == tabIndex )
	{
		                                                                                   
		DeactivateTab( tabData )
	}

}


void function UI_SwitchToDeathScreenTab( int tabIndex )
{
	                                                     

	if ( !MenuStack_Contains( file.menu ) )
		return

	EnableDeathScreenTab_Internal( tabIndex, true )

	TabData tabData = GetTabDataForPanel( file.menu )

	                                                                           

	if ( tabData.activeTabIdx != tabIndex )
		ActivateTab( tabData, tabIndex )
	      
	  	                                   
}


void function UI_DeathScreenFadeInBlur( bool fadeInBlur )
{
	float startTime = fadeInBlur ? ClientTime() : 0.0

	                                                                           

	var screenBlur = Hud_GetChild( file.menu, "ScreenBlur" )
	HudElem_SetRuiArg( screenBlur, "startTime", startTime, eRuiArgType.GAMETIME )
}


void function UI_SetDeathScreenTabTitle( int tabIndex, string title )
{
	                                           
	if ( !MenuStack_Contains( file.menu ) )
	{
		                                 
		return
	}

	string panelName
	switch( tabIndex )
	{
		case eDeathScreenPanel.DEATH_RECAP:
			panelName = "DeathScreenRecap"
			break

		case eDeathScreenPanel.SPECTATE:
			panelName = "DeathScreenSpectate"
			break

		case eDeathScreenPanel.SQUAD_SUMMARY:
			panelName = "DeathScreenSquadSummary"
			break

		default:
			unreachable
			break
	}

	TabData tabData = GetTabDataForPanel( file.menu )
	TabDef tabDef   = Tab_GetTabDefByBodyName( tabData, panelName )
	tabDef.title = title

	UpdateMenuTabs()
}


void function UI_SetCanShowGladCard( bool canShowGladCard )
{
	                                                        

	if ( file.canShowGladCard == canShowGladCard )
		return

	file.canShowGladCard = canShowGladCard
	UpdateFooterOptions()
}


void function UI_SetAllowGladCard( bool allowGladCard )
{
	                                                      


	if ( file.allowGladCard == allowGladCard )
		return

	file.allowGladCard = allowGladCard
	UpdateFooterOptions()
}


void function UI_SetShouldShowSkip( bool shouldShowSkip )
{
	                                                      
	file.shouldShowSkip = shouldShowSkip
	UpdateFooterOptions()
}


void function UI_SetIsEliminiated( bool isEliminated)
{
	                                                   
	file.isEliminated = isEliminated
	UpdateFooterOptions()
}


void function UI_DeathScreenSetRespawnStatus( int respawnStatus )
{
	file.respawnStatus = respawnStatus
	UpdateFooterOptions()
}


void function UI_DeathScreenSetSpectateTargetCount( int targetCount )
{
	                                                                   
	file.spectateTargetCount = targetCount
	UpdateFooterOptions()
}


void function UI_DeathScreenSetCanReportRecapPlayer( bool canReport )
{
	file.canReportRecapPlayer = canReport
	UpdateFooterOptions()
}


void function UI_DeathScreenSetObserverMode( int observerMode )
{
	file.observerMode = observerMode
	UpdateFooterOptions()
}


void function UI_DeathScreenSetBlockPlayer( string eaid, string hardware )
{
	printt( "#EADP UI_DeathScreenSetBlockPlayer", eaid, hardware )
	file.blockEAID = eaid
	file.blockHardware = hardware
	UpdateFooterOptions()
}


void function UI_DeathScreenUpdateHeader()
{
	                                            

	var headerElement = Hud_GetChild( file.menu, "Header" )
	RunClientScript( "UICallback_UpdateHeader", headerElement )
}

void function UI_DeathScreenHideTabs( bool hide )
{
	var tabElement = Hud_GetChild( file.menu, "TabsCommon" )
	Hud_SetVisible( tabElement, !hide )
}

void function UI_OnLoadoutButton_Enter( var button )
{
	                                 

	var panel   = _GetActiveTabPanel( file.menu )
	var chatbox = Hud_GetChild( panel, "LobbyChatBox" )

	if ( !HudChat_HasAnyMessageModeStoppedRecently() )
		Hud_StartMessageMode( chatbox )

	Hud_SetVisible( chatbox, true )
}


void function OnSurvivalInventory_OnInputModeChange()
{
}

var function DeathScreenGetHeader()
{
	return Hud_GetChild( file.menu, "Header" )
}


void function DeathScreenMenu_OnResolutionChanged()
{
	if ( IsFullyConnected() )
		RunClientScript( "UICallback_OnResolutionChange" )
}


void function DeathScreenMenu_Shutdown()
{
	if ( IsFullyConnected() )
		RunClientScript( "UICallback_DestroyAllClientGladCardData" )
	return
}


void function DeathScreenMenuOnNavBack()
{
	TabData tabData = GetTabDataForPanel( file.menu )
	{
		int tabIndex = GetMenuActiveTabIndex( file.menu )
		if ( tabIndex == eDeathScreenPanel.SPECTATE && GetGameState() < eGameState.Resolution )
		{
			if ( file.isEliminated && IsTabIndexEnabled( tabData, eDeathScreenPanel.SQUAD_SUMMARY ) )
			{
				ActivateTab( tabData, eDeathScreenPanel.SQUAD_SUMMARY )
			}
			else if ( InputIsButtonDown( KEY_ESCAPE ) )
			{
				OpenSystemMenu()
			}
		}
		else if ( ( tabIndex == eDeathScreenPanel.DEATH_RECAP || tabIndex == eDeathScreenPanel.SCOREBOARD ) && GetGameState() < eGameState.Resolution )
		{
			if ( file.isEliminated && IsTabIndexEnabled( tabData, eDeathScreenPanel.SQUAD_SUMMARY ) )
			{
				ActivateTab( tabData, eDeathScreenPanel.SQUAD_SUMMARY )
			}
                           
			else if( Control_IsModeEnabled() )
			{
				Remote_ServerCallFunction( "ClientCallback_SkipDeathCam" )
			}
         
			else
			{
				if( GetGameState() < eGameState.Playing )                                   
					UI_CloseDeathScreenMenu()
				else
					ActivateTab( tabData, eDeathScreenPanel.SPECTATE )
			}
		}
		else
		{
			if ( InputIsButtonDown( KEY_ESCAPE ) )
				OpenSystemMenu()
			else
				LeaveDialog()
		}
	}
}


void function DeathScreen_AddPassthroughCommandsToMenu( var menu )
{
	AddCommandForMenuToPassThrough( menu, "toggle_map" )
}


bool function DeathScreenShowLobbySpace()
{
	return DeathScreenCanLeaveMatch() && !( GetMenuActiveTabIndex( file.menu ) == eDeathScreenPanel.SQUAD_SUMMARY )
}


bool function DeathScreenShowLobbyButton()
{
	return DeathScreenCanLeaveMatch() && ( GetMenuActiveTabIndex( file.menu ) == eDeathScreenPanel.SQUAD_SUMMARY )
}


bool function DeathScreenCanLeaveMatch()
{
	                                         
	if ( GetGameState() >= eGameState.Resolution )
		return true

	                                                     
	if ( GetGameState() >= eGameState.WinnerDetermined )
		return false

	return file.isEliminated
}


bool function DeathScreenShowNavBack()
{
	return !CurrentTabIsDeadEnd() && GetGameState() < eGameState.Resolution
}


bool function DeathScreenShowMenuButton()
{
	return !DeathScreenCanLeaveMatch() && CurrentTabIsDeadEnd()
}


bool function CurrentTabIsDeadEnd()
{
	if ( file.isEliminated )
	{
		return ( GetMenuActiveTabIndex( file.menu ) == eDeathScreenPanel.SQUAD_SUMMARY )
	}

	return ( GetMenuActiveTabIndex( file.menu ) == eDeathScreenPanel.SPECTATE )
}


bool function DeathScreenRespawnWaitingForPickup()
{
	return file.respawnStatus == eRespawnStatus.WAITING_FOR_PICKUP
}


bool function DeathScreenRespawnWaitingForDelivery()
{
	return file.respawnStatus == eRespawnStatus.WAITING_FOR_DELIVERY
}


bool function DeathScreenCanChangeSpectateTarget()
{
	return file.spectateTargetCount	> 1
}


bool function DeathRecapCanReportPlayer()
{
	return GetReportStyle() != 0 && file.canReportRecapPlayer
}


bool function CanReportPlayer()
{
	return GetReportStyle() != 0 && !file.shouldShowSkip && file.observerMode == OBS_MODE_IN_EYE
}


void function DeathScreenPingRespawn( var button )
{
	RunClientScript( "UICallback_TryPingRespawn" )
}


void function DeathScreenLeaveGameDialog( var button )
{
	if ( DeathScreenCanLeaveMatch() )
		LeaveDialog()
}


bool function IsGladCardShowing()
{
	if ( !CanShowGladCard() )
		return false

	return file.isGladCardShowing
}


bool function CanShowGladCard()
{
	return file.canShowGladCard
}

bool function AllowGladCard()
{
	return file.allowGladCard
}


bool function CanSkipDeathCam()
{
	if ( GetGameState() > eGameState.Playing )
		return false

                         
	if ( IsFullyConnected() && Control_IsModeEnabled() )
		return false
       

                           
		if ( IsFullyConnected() && IsSecondChanceGameMode() )
			return false
       

	return file.shouldShowSkip
}

bool function CanSkipRecap()
{
	if ( GetGameState() > eGameState.Playing  )
		return false

                         
	if ( Control_IsModeEnabled() )
		return true
       


	return false
}

void function DeathScreenTryOpenSystemMenu( var panel )
{
	OpenSystemMenu()
}


bool function CanBlockPlayer()
{
	printt( "#EADP CanBlockPlayer", CrossplayUserOptIn(), file.blockHardware, file.blockEAID, EADP_IsBlockedByEAID( file.blockEAID ) )
	if ( !CrossplayUserOptIn() )
		return false

	if ( IsUserOnSamePlatform( file.blockHardware ) )  
		return false

	if ( file.blockEAID == "" )
		return false

	if ( EADP_IsBlockedByEAID( file.blockEAID ) )
		return false

	return true
}


void function DeathScreenOnBlockButtonClick( var button )
{
	printt( "#EADP DeathScreenOnBlockButtonClick" )
	if ( !CanBlockPlayer() )
		return

	if ( InputIsButtonDown( BUTTON_STICK_LEFT ) || InputIsButtonDown( GetPCBlockKey() ) )
	{
		thread RunClientScriptOnButtonHold( BUTTON_STICK_LEFT, GetPCBlockKey(), "UICallback_BlockPlayer" )
		return
	}
	else
	{
		                                    
		RunClientScript( "UICallback_BlockPlayer" )
	}
}


void function DeathScreenOnReportButtonClick( var button )
{
	if ( InputIsButtonDown( BUTTON_STICK_RIGHT ) || InputIsButtonDown( GetPCReportKey() ) )
	{
		thread RunClientScriptOnButtonHold( BUTTON_STICK_RIGHT, GetPCReportKey(), "UICallback_ReportPlayer" )
		return
	}
	else
	{
		                                    
		RunClientScript( "UICallback_ReportPlayer" )
	}
}


void function DeathScreenSpectateNext( var button )
{
	if ( DeathScreenCanChangeSpectateTarget() )
		SpectatorNextTarget()
}


void function DeathScreenTryToggleGladCard( var button )
{
	file.isGladCardShowing = !file.isGladCardShowing
	RunClientScript( "UICallback_ToggleGladCard", file.isGladCardShowing )

	string gladCardMessageString = "#SPECTATE_HIDE_BANNER"
	if ( !file.isGladCardShowing )
		gladCardMessageString = "#SPECTATE_SHOW_BANNER"

	file.gladCardToggleInputData.mouseLabel = gladCardMessageString
	file.gladCardToggleInputData.gamepadLabel = gladCardMessageString
	UpdateFooterLabels()
}


void function DeathScreenUpdateCursor()
{
	int tabIndex = GetMenuActiveTabIndex( file.menu )
	if ( tabIndex == eDeathScreenPanel.SPECTATE )
	{
		HideGameCursor()
		SetGamepadCursorEnabled( file.menu, false )
	}
	else if ( !IsGamepadCursorEnabled( file.menu ) )
	{
		                                                                              
		ShowGameCursor()
		SetCursorPosition( <1920.0 * 0.5, 1080.0 * 0.5, 0> )
		SetGamepadCursorEnabled( file.menu, true )
	}
}


void function DeathScreenSkipDeathCam( var button )
{
	                                         

	                                                                                              
	if ( CanSkipDeathCam () )
		Remote_ServerCallFunction( "ClientCallback_SkipDeathCam" )
}

void function DeathScreenSkipRecap( var button )
{
	                                         
	if ( CanSkipRecap () )
	{
		Remote_ServerCallFunction( "ClientCallback_SkipDeathCam" )
	}

}

void function RunClientScriptOnButtonHold( int consoleButtonID, int PCKeyID, string clientScriptCallback )
{
	float startTime = UITime()
	float duration  = 0.3
	float endTIme   = startTime + duration

	while ( ( InputIsButtonDown( consoleButtonID ) || InputIsButtonDown( PCKeyID ) ) && UITime() < endTIme )
	{
		WaitFrame()
	}

	if ( GetActiveMenu() != null )
	{
		if ( IsDialog( GetActiveMenu() ) )
			return
	}

	if ( UITime() >= endTIme && ( InputIsButtonDown( consoleButtonID ) || InputIsButtonDown( PCKeyID ) ) )
	{
		printt( "#EADP RunClientScriptOnButtonHold", clientScriptCallback )
		RunClientScript( clientScriptCallback )
		return
	}
}


bool function DeathScreenIsOpen()
{
	var activeMenu = GetActiveMenu()
	if ( activeMenu == file.menu )
		return true
	return false
}

void function UI_FullmapChallengeCategoryLeft( var unused )
{
	RunClientScript( "FullmapChallengeCategoryLeft", null )
}

void function UI_FullmapChallengeCategoryRight( var unused )
{
	RunClientScript( "FullmapChallengeCategoryRight", null )
}

#if DEV
void function DevExit( var button )
{
	CloseActiveMenu()
}

void function ShowBanner()
{
	                        

	var headerElement = Hud_GetChild( file.menu, "Header" )
	RunClientScript( "DEV_UICallback_UpdateHeader", headerElement )
}
#endif


#if DEV
void function DeathScreenPanelFooterAutomationThink( var menu )
{
	if ( AutomateUi() && DeathScreenShowLobbyButton() )
	{
		printt("DeathScreenPanelFooterAutomationThink DeathScreenLeaveGameDialog()")
		DeathScreenLeaveGameDialog( null )
	}
}
#endif       
