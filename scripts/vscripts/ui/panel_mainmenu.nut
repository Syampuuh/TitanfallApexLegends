
global function InitMainMenuPanel
global function StartSearchForPartyServer
global function StopSearchForPartyServer
global function IsSearchingForPartyServer
global function SetLaunchState
global function PrelaunchValidateAndLaunch


global function UICodeCallback_GetOnPartyServer

#if XBOX_PROG
global function UICodeCallback_JoiningInvite
global function UICodeCallback_OnJoinFailed
#endif

#if DURANGO_PROG
global function UICodeCallback_OnStartedUserSignIn
global function UICodeCallback_OnFailedUserSignIn
global function UICodeCallback_OnCompletedUserSignIn
global function UICodeCallback_OnUserSignOut
#endif

#if DEV
global function DEV_ToggleRuiIssuesDemo
#endif

const bool SPINNER_DEBUG_INFO = PC_PROG

struct
{
	var                menu
	var                panel
	var                status
	var                launchButton
	void functionref() launchButtonActivateFunc = null
	var                statusDetails
	bool               statusDetailsVisiblity = false
	                                       
	bool               working = false
	bool               searching = false
	bool			   hasReconnectFile = false
	bool               isNucleusProcessActive = false
	var				   serverSearchMessage
	var				   serverSearchError
	bool				needsEAAccountRegistration = false

	#if XBOX_PROG
		bool forceProfileSelect = false
	#endif             

	float startTime = 0
} file

#if SPINNER_DEBUG_INFO
void function SetSpinnerDebugInfo( string message )
{
	if ( GetConVarBool( "spinner_debug_info" ) )
	{
		Assert( file.working )
		SetLaunchState( eLaunchState.WORKING, message )
	}
}
#endif

void function InitMainMenuPanel( var panel )
{
	RegisterSignal( "EndPrelaunchValidation" )
	RegisterSignal( "EndSearchForPartyServerTimeout" )
	RegisterSignal( "SetLaunchState" )
	RegisterSignal( "MainMenu_Think" )

	file.panel = GetPanel( "MainMenuPanel" )
	file.menu = GetParentMenu( file.panel )

#if DEV
	AddMenuThinkFunc( file.menu, MainMenuPanelAutomationThink )
#endif       

	AddPanelEventHandler( file.panel, eUIEvent.PANEL_SHOW, OnMainMenuPanel_Show )
	AddPanelEventHandler( file.panel, eUIEvent.PANEL_HIDE, OnMainMenuPanel_Hide )

	file.launchButton = Hud_GetChild( panel, "LaunchButton" )
	Hud_AddEventHandler( file.launchButton, UIE_CLICK, LaunchButton_OnActivate )

	file.status = Hud_GetRui( Hud_GetChild( panel, "Status" ) )
	file.statusDetails = Hud_GetRui( Hud_GetChild( file.panel, "StatusDetails" ) )
	file.serverSearchMessage = Hud_GetChild( file.panel, "ServerSearchMessage" )
	file.serverSearchError = Hud_GetChild( file.panel, "ServerSearchError" )
	
#if NX_PROG
	                                                                                                    
	                                                                                                                        
	RuiSetBool( file.status, "forceBiggerForRenderingProperlyOnNX", true )
#endif 

	                                                                                                                     

	#if DEV
		if ( GetBugReproNum() == 233677 )
		{
			AddPanelFooterOption( panel, LEFT, BUTTON_Y, true, "", "" )
			var footerButtons = Hud_GetChild( file.menu, "FooterButtons" )
			var leftRuiFooterButton0 = Hud_GetChild( footerButtons, "LeftRuiFooterButton0" )
			thread DEV_TestFooterTextWidths( leftRuiFooterButton0 )
		}
	#endif       

	#if PC_PROG
		AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_EXIT_TO_DESKTOP", "#B_BUTTON_EXIT_TO_DESKTOP", null, IsExitToDesktopFooterValid )
		AddPanelFooterOption( panel, LEFT, KEY_TAB, false, "", "#DATACENTER_DOWNLOADING", OpenDataCenterDialog, IsDataCenterFooterVisible, UpdateDataCenterFooter )
	#endif           
	AddPanelFooterOption( panel, LEFT, BUTTON_STICK_RIGHT, false, "#DATACENTER_DOWNLOADING", "", OpenDataCenterDialog, IsDataCenterFooterVisible, UpdateDataCenterFooter )

	file.hasReconnectFile = TryLoadReconnectFromLocalStorage()
	#if PC_PROG
		AddPanelFooterOption( panel, LEFT, KEY_Q, true, "", "#BUTTON_RETRY_CONNECT", RetryConnect_OnActivate, IsRetryConnectFooterValid )
	#endif
	AddPanelFooterOption( panel, LEFT, BUTTON_X, true, "#BUTTON_RETRY_CONNECT", "", RetryConnect_OnActivate, IsRetryConnectFooterValid )

	AddPanelFooterOption( panel, LEFT, BUTTON_START, true, "#START_BUTTON_ACCESSIBLITY", "#BUTTON_ACCESSIBLITY", Accessibility_OnActivate, IsAccessibilityFooterValid )

	#if DURANGO_PROG
		AddPanelFooterOption( panel, LEFT, BUTTON_Y, true, "#Y_BUTTON_SWITCH_PROFILE", "", SwitchProfile_OnActivate, IsSwitchProfileFooterValid )
	#endif

	#if CONSOLE_PROG
		AddMenuVarChangeHandler( "CONSOLE_isSignedIn", UpdateFooterOptions )
		AddMenuVarChangeHandler( "CONSOLE_isSignedIn", UpdateSignedInState )
	#endif                
}

#if DEV
void function MainMenuPanelAutomationThink( var menu )
{
	if (AutomateUi())
	{
		printt("MainMenuPanelAutomationThink LaunchButton_OnActivate()")
		LaunchButton_OnActivate(null)
	}
}
#endif       

void function RetryConnect_OnActivate( var button )
{
	if ( IsRetryConnectFooterValid() )
	{
		EnableAutoRetryConnect()
		LaunchButton_OnActivate(null)
	}
}

bool function IsRetryConnectFooterValid()
{
	return !IsWorking() && !IsSearchingForPartyServer() && file.hasReconnectFile && !CanAutoRetryConnect()
}

#if PC_PROG
bool function IsExitToDesktopFooterValid()
{
	return !IsWorking() && !IsSearchingForPartyServer()
}
#endif           


bool function IsAccessibilityFooterValid()
{
	if ( !IsAccessibilityAvailable() )
		return false

	#if DURANGO_PROG
		return Console_IsSignedIn() && !IsWorking() && !IsSearchingForPartyServer()
	#else
		return !IsWorking() && !IsSearchingForPartyServer()
	#endif
}

bool function IsDataCenterFooterVisible()
{
	return !IsWorking() && !IsSearchingForPartyServer()
}


bool function IsDataCenterFooterClickable()
{
#if DEV
	bool hideDurationElapsed = true
#else           
	bool hideDurationElapsed = UITime() - file.startTime > 10.0
#endif                    

	#if DURANGO_PROG
		return Console_IsSignedIn() && !IsWorking() && !IsSearchingForPartyServer() && hideDurationElapsed
	#else
		return !IsWorking() && !IsSearchingForPartyServer() && hideDurationElapsed
	#endif
}

void function UpdateDataCenterFooter( InputDef footerData )
{
	string label = "#DATACENTER_DOWNLOADING"
	if ( !IsDatacenterMatchmakingOk() )
	{
		if ( IsSendingDatacenterPings() )
			label = Localize( "#DATACENTER_CALCULATING" )
		else
			label = Localize( label, GetDatacenterDownloadStatusCode() )
	}
	else
	{
		label = Localize( "#DATACENTER_INFO", GetDatacenterName(), GetDatacenterMinPing(), GetDatacenterPing(), GetDatacenterPacketLoss(), GetDatacenterSelectedReasonSymbol() )
		if ( IsDataCenterFooterClickable() )
			footerData.clickable = true
	}

	var elem = footerData.vguiElem
	Hud_SetText( elem, label )
	Hud_Show( elem )
}

void function OnMainMenuPanel_Show( var panel )
{
	file.startTime = UITime()

	AccessibilityHintReset()
	EnterLobbySurveyReset()

	thread MainMenu_Think()

	thread PrelaunchValidation( GetConVarBool( "autoConnect" ) )

	ExecCurrentGamepadButtonConfig()
	ExecCurrentGamepadStickConfig()
}

void function MainMenu_Think()
{
	Signal( uiGlobal.signalDummy, "MainMenu_Think" )
	EndSignal( uiGlobal.signalDummy, "MainMenu_Think" )

	while ( true )
	{
		                        
	    #if DEV
		    if ( GetBugReproNum() != 233677 )
	    #endif       
		UpdateFooterOptions()

		WaitFrame()
	}
}


void function PrelaunchValidateAndLaunch()
{
	printt( "*** PrelaunchValidateAndLaunch");
	thread PrelaunchValidation( true )
}


void function PrelaunchValidation( bool autoContinue = false )
{
	printt( "*** PrelaunchValidation");
	EndSignal( uiGlobal.signalDummy, "EndPrelaunchValidation" )

	SetLaunchState( eLaunchState.WORKING )

#if SPINNER_DEBUG_INFO
	SetSpinnerDebugInfo( "PrelaunchValidation" )
#endif
	#if PC_PROG

		bool isPCPlatEnabled = PCPlat_IsEnabled()
		string platToken = PCPlat_IsSteam() ? "STEAM" : "ORIGIN"
		PrintLaunchDebugVal( "isPCPlatEnabled", isPCPlatEnabled )
		if ( !isPCPlatEnabled )
		{
			#if DEV
				if ( autoContinue )
					LaunchMP()
				else
					SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, "", Localize( "#MAINMENU_CONTINUE" ) )

				return
			#endif       

			SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, Localize( "#"+platToken+"_IS_OFFLINE" ), Localize( "#MAINMENU_RETRY" ) )
			return
		}

		bool isOriginConnected = isPCPlatEnabled ? PCPlat_IsOnline() : true
		PrintLaunchDebugVal( "isPCPlatConnected", isPCPlatEnabled )
		if ( !isOriginConnected )
		{
			SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, Localize( "#"+platToken+"_IS_OFFLINE" ), Localize( "#MAINMENU_RETRY" ) )
			return
		}

		bool isPCPlatLatest = PCPlat_IsUpToDate()
		PrintLaunchDebugVal( "isOriginLatest", isPCPlatLatest )
		if ( !isPCPlatLatest )
		{
			SetLaunchState( eLaunchState.CANT_CONTINUE, Localize( "#TITLE_UPDATE_AVAILABLE" ) )
			return
		}
	#endif           

	#if NX_PROG
		NX_StartConnection()
	#endif
		
	#if CONSOLE_PROG
		bool isOnline = Console_IsOnline()
		PrintLaunchDebugVal( "isOnline", isOnline )
		if ( !isOnline )
		{
			SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, Localize( "#INTERNET_NOT_FOUND" ), Localize( "#MAINMENU_RETRY" ) )
			return
		}
	#endif                

	bool hasLatestPatch = HasLatestPatch()
	PrintLaunchDebugVal( "hasLatestPatch", hasLatestPatch )
	if ( !hasLatestPatch )
	{
		SetLaunchState( eLaunchState.CANT_CONTINUE, Localize( "#TITLE_UPDATE_AVAILABLE" ) )
		return
	}

	#if PC_PROG
		bool isPCPlatAccountAvailable = true       
		PrintLaunchDebugVal( "isPCPlatAccountAvailable", isPCPlatAccountAvailable )
		if ( !isPCPlatAccountAvailable )
		{
			SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, Localize( "#"+platToken+"_ACCOUNT_IN_USE" ), Localize( "#MAINMENU_RETRY" ) )
			return
		}

		bool isPCPlatLoggedIn = true       
		PrintLaunchDebugVal( "isPCPlatLoggedIn", isPCPlatLoggedIn )
		if ( !isPCPlatLoggedIn )
		{
			SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, Localize( "#"+platToken+"_NOT_LOGGED_IN" ), Localize( "#MAINMENU_RETRY" ) )
			return
		}

		bool isPCPlatAgeApproved = MeetsAgeRequirements()
		PrintLaunchDebugVal( "isPCPlatAgeApproved", isPCPlatAgeApproved )
		if ( !isPCPlatAgeApproved )
		{
			SetLaunchState( eLaunchState.CANT_CONTINUE, Localize( "#MULTIPLAYER_AGE_RESTRICTED" ) )
			return
		}

		if ( PCPlat_IsSteam() )
		{
			if ( file.needsEAAccountRegistration )
			{
				file.needsEAAccountRegistration = false
				PCPlat_RegisterEAAccount()
			}

			while( !PCPlat_IsReady() )
			{
				if ( !PCPlat_IsOnline() )
				{
					SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, Localize( "#"+platToken+"_IS_OFFLINE" ), Localize( "#MAINMENU_RETRY" ) )
					return
				}

				if ( PCPlat_IsWaitingForEARegistration() )
				{
					file.needsEAAccountRegistration = true

					SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, Localize( "#STEAM_EA_ACCOUNT_REQUIRED"), Localize( "#STEAM_REGISTER_BUTTON" ) )
					return
				}

				int errorLevel = PCPlat_GetEALinkErrorLevel()
				if ( errorLevel != 0 )
				{
					SetLaunchState( eLaunchState.CANT_CONTINUE, Localize( "#STEAM_EA_ACCOUNT_ERROR" ) + "\nError: " + errorLevel )
					return
				}

				WaitFrame()
			}
		}

#if SPINNER_DEBUG_INFO
		SetSpinnerDebugInfo( "isPCPlatReady" )
#endif
		while ( true )
		{
			bool isPCPlatReady = PCPlat_IsReady()
			PrintLaunchDebugVal( "isPCPlatReady", isPCPlatReady )
			if ( isPCPlatReady )
				break

			WaitFrame()
		}
	#endif           

	#if PLAYSTATION_PROG
		WaitFrame()                                    

		if ( PS4_isNetworkingDown() )
		{
			printt( "PS4 - networking is down" )
			SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, Localize( "#PSN_CANNOT_CONNECT" ), Localize( "#MAINMENU_RETRY" ) )
			return
		}

		if ( !PS4_isUserNetworkingEnabled() )
		{
			PS4_ScheduleUserNetworkingEnabledTest()
#if SPINNER_DEBUG_INFO
			SetSpinnerDebugInfo( "PS4_isUserNetworkingResolved" )
#endif
			WaitFrame()
			if ( !PS4_isUserNetworkingResolved() )
			{
				printt( "PS4 - networking isn't resolved yet" )
				while ( !PS4_isUserNetworkingResolved() )
					WaitFrame()
			}
		}

		int netStatus = PS4_getUserNetworkingResolution()

		bool isPSNConnected
		if ( netStatus == PS4_NETWORK_STATUS_NOT_LOGGED_IN )
			isPSNConnected = false
		else
			isPSNConnected = Ps4_PSN_Is_Loggedin()
		PrintLaunchDebugVal( "isPSNConnected", isPSNConnected )
		if ( !isPSNConnected )
		{
			if ( autoContinue )
				thread PS4_PSNSignIn()
			else
				SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, "", Localize( "#MAINMENU_CONTINUE" ) )
			return
		}

		bool isAgeApproved
		if ( netStatus == PS4_NETWORK_STATUS_AGE_RESTRICTION )
			isAgeApproved = false
		else
			isAgeApproved = !PS4_is_NetworkStatusAgeRestriction()
		PrintLaunchDebugVal( "isAgeApproved", isAgeApproved )
		if ( !isAgeApproved )
		{
			SetLaunchState( eLaunchState.CANT_CONTINUE, Localize( "#MULTIPLAYER_AGE_RESTRICTED" ) )
			return
		}

		bool isPSNError = netStatus == PS4_NETWORK_STATUS_IN_ERROR
		PrintLaunchDebugVal( "isPSNError", isPSNError )
		if ( isPSNError )
		{
			SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, Localize( "#PSN_HAD_ERROR" ), Localize( "#MAINMENU_RETRY" ) )
			return
		}

		                                                                                                                                                                                        
		if ( !PS4_isUserNetworkingEnabled() )
		{
			SetLaunchState( eLaunchState.CANT_CONTINUE, Localize( "#PSN_NOT_ALLOWED" ) )
			return
		}
	#endif                    

	#if XBOX_PROG
		bool isSignedIn = Console_IsSignedIn()                                                                                                                                                    
		bool isProfileSelectRequired = file.forceProfileSelect
		PrintLaunchDebugVal( "isSignedIn", isSignedIn )
		PrintLaunchDebugVal( "isProfileSelectRequired", isProfileSelectRequired )
		PrintLaunchDebugVal( "autoContinue", autoContinue )
		if ( !isSignedIn || isProfileSelectRequired )
		{
			file.forceProfileSelect = false

			if ( autoContinue )
			{
				Xbox_ShowAccountPicker()
			}
			else
			{
				SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, "", Localize( "#MAINMENU_SIGN_IN" ) )
			}
			return
		}

		bool isGuest = Xbox_IsGuest()
		PrintLaunchDebugVal( "isGuest", isGuest )
		if ( isGuest )
		{
			if ( autoContinue )
			{
				Xbox_ShowAccountPicker()
			}
			else
			{
				SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, Localize( "#GUESTS_NOT_SUPPORTED" ), Localize( "#MAINMENU_SIGN_IN" ) )
			}
			return
		}
	#endif             

	#if NX_PROG
		if ( !NX_IsNetworkLoginFinished() )
		{
			printt( "Switch Network Connection" )
#if SPINNER_DEBUG_INFO
			SetSpinnerDebugInfo( "NX_IsNetworkLoginFinished" )
#endif
			while ( !NX_IsNetworkLoginFinished() )
				WaitFrame()
		}
		
		isOnline = Console_IsOnline()
		PrintLaunchDebugVal( "isOnline", isOnline )
		if ( !isOnline )
		{
			SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, Localize( "#INTERNET_NOT_FOUND" ), Localize( "#MAINMENU_RETRY" ) )
			return
		}
		
	#endif           
	bool hasPermission = HasPermission()
	PrintLaunchDebugVal( "hasPermission", hasPermission )
	if ( !hasPermission )
	{
		#if DURANGO_PROG
			if ( autoContinue )
			{
				thread XB1_PermissionsDialog()
				SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, Localize( "#MULTIPLAYER_NOT_AVAILABLE" ), Localize( "#MAINMENU_CONTINUE" ) )        
			}
			else
			{
				SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, "", Localize( "#MAINMENU_SIGN_IN" ) )
			}
		#elseif NX_PROG
			SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, Localize( "#MULTIPLAYER_NOT_AVAILABLE" ), Localize( "#MAINMENU_SIGN_IN" ) )
		#else
			SetLaunchState( eLaunchState.CANT_CONTINUE, Localize( "#MULTIPLAYER_NOT_AVAILABLE" ) )
		#endif
		return
	}

	#if PS5_PROG                                            
		bool hasPlus = PS_CheckPlus_Allowed()
		PrintLaunchDebugVal( "hasPlus", hasPlus )
	
		if ( !hasPlus )
		{
			PS_CheckPlus_Schedule()
		#if SPINNER_DEBUG_INFO
			SetSpinnerDebugInfo( "PS_CheckPlus_Running" )
		#endif
			while ( PS_CheckPlus_Running() )
				WaitFrame()
			hasPlus = PS_CheckPlus_Allowed()
			PrintLaunchDebugVal( "hasPlus", hasPlus )
	
			if ( !hasPlus )
			{
				if ( PS_CheckPlus_GetLastRequestResults() != 0 )
				{
					SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, Localize( "#PSN_HAD_ERROR" ), Localize( "#MAINMENU_RETRY" ) )
					return
				}
	
				if ( autoContinue )
					thread PS_PlusSignUp()
				else
					SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, "", Localize( "#MAINMENU_CONTINUE" ) )
				return
			}
		}
	#endif            

#if SPINNER_DEBUG_INFO
	SetSpinnerDebugInfo( "isAuthenticatedByStryder" )
#endif
	float startTime = UITime()
	while ( true )
	{
		bool isAuthenticatedByStryder = IsStryderAuthenticated()
		PrintLaunchDebugVal( "isAuthenticatedByStryder", isAuthenticatedByStryder )

		if ( isAuthenticatedByStryder )
			break
		if ( UITime() - startTime > 10.0 )
		{
			#if CONSOLE_PROG
				SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, Localize( "#INTERNET_NOT_FOUND" ), Localize( "#MAINMENU_RETRY" ) )
			#else
				SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, Localize( "#ORIGIN_IS_OFFLINE" ), Localize( "#MAINMENU_RETRY" ) )
			#endif
			return
		}

		WaitFrame()
	}

	bool isMPAllowedByStryder = IsStryderAllowingMP()
	PrintLaunchDebugVal( "isMPAllowedByStryder", isMPAllowedByStryder )
	if ( !isMPAllowedByStryder )
	{
		string unavailableString = "#MULTIPLAYER_NOT_AVAILABLE"
		if ( IsPlayerLoggedInToMultipleMachines() )
			unavailableString = "#MULTIPLAYER_NOT_AVAILABLE_MULTIPLE_LOGIN"

		SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, Localize( unavailableString ), Localize( "#MAINMENU_RETRY" ) )
		return
	}

	#if CONSOLE_PROG
	bool isEasdkRequired = Easdk_is_required()
	bool isEasdkLoggedIn = Easdk_is_loggedin()
	PrintLaunchDebugVal( "isEasdkRequired", isEasdkRequired )
	PrintLaunchDebugVal( "isEasdkLoggedIn", isEasdkLoggedIn )
	if ( isEasdkRequired && !isEasdkLoggedIn )
	{
		if ( autoContinue )
			thread NucleusLogin()
		else
			SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, "", Localize( "#MAINMENU_CONTINUE" ) )
		return
	}
	#endif                

	if ( autoContinue )
		LaunchMP()
	else
		SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, "", Localize( "#MAINMENU_CONTINUE" ) )
}


void function OnMainMenuPanel_Hide( var panel )
{
	Signal( uiGlobal.signalDummy, "MainMenu_Think" )
	Signal( uiGlobal.signalDummy, "EndPrelaunchValidation" )
	file.working = false
	file.searching = false
	#if XBOX_PROG
		file.forceProfileSelect = false
	#endif             
}


void function SetLaunchState( int launchState, string details = "", string prompt = "" )
{
	printt( "*** SetLaunchState *** launchState: " + GetEnumString( "eLaunchState", launchState ) + " details: \"" + details + "\" prompt: \"" + prompt + "\"" )

	if ( launchState == eLaunchState.WAIT_TO_CONTINUE )
	{
		printt( "*** Setting LaunchButton_OnActivate ***  PrelaunchValidateAndLaunch")
		file.launchButtonActivateFunc = PrelaunchValidateAndLaunch
		AccessibilityHint( eAccessibilityHint.LAUNCH_TO_LOBBY )
	}
	else
	{
		printt( "*** Setting LaunchButton_OnActivate ***  NULL")
		file.launchButtonActivateFunc = null
	}

	Hud_SetVisible( file.launchButton, launchState == eLaunchState.WAIT_TO_CONTINUE )

	RuiSetString( file.status, "prompt", prompt )
	RuiSetBool( file.status, "showPrompt", prompt != "" )

	file.working = launchState == eLaunchState.WORKING
	RuiSetBool( file.status, "showSpinner", file.working )

	thread ShowStatusMessagesAfterDelay()

	if ( details == "" )
		details = GetConVarString( "rspn_motd" )

	if ( details != "" )
		RuiSetString( file.statusDetails, "details", details )

	bool lastStatusDetailsVisiblity = file.statusDetailsVisiblity
	file.statusDetailsVisiblity = details != ""

	if ( file.statusDetailsVisiblity == true || ( file.statusDetailsVisiblity == false && lastStatusDetailsVisiblity != false ) )
	{
		RuiSetBool( file.statusDetails, "ruiVisible", file.statusDetailsVisiblity )
		RuiSetGameTime( file.statusDetails, "initTime", ClientTime() )
	}

	UpdateSignedInState()
	UpdateFooterOptions()
}


void function ShowStatusMessagesAfterDelay()
{
	Signal( uiGlobal.signalDummy, "SetLaunchState" )
	EndSignal( uiGlobal.signalDummy, "SetLaunchState" )

	if ( !IsWorking() )
		return

	wait 5.0

	if ( !IsWorking() )
		return

	OnThreadEnd(
		function() : (  )
		{
			Hud_SetVisible( file.serverSearchMessage, false )
			Hud_SetVisible( file.serverSearchError, false )
		}
	)

	Hud_SetVisible( file.serverSearchMessage, true )
	Hud_SetVisible( file.serverSearchError, true )

	WaitForever()
}


bool function IsWorking()
{
	return file.working
}


void function StartSearchForPartyServer()
{
	#if DURANGO_PROG
		                                                                               
		                                                                              
		                                                        
		Durango_LeaveParty()
	#endif                

	SearchForPartyServer()
	SetLaunchState( eLaunchState.WORKING )
	file.searching = true

#if SPINNER_DEBUG_INFO
	SetSpinnerDebugInfo( "SearchForPartyServer" )
#endif

	UpdateSignedInState()
	UpdateFooterOptions()

	thread SearchForPartyServerTimeout()
}


void function SearchForPartyServerTimeout()
{
	EndSignal( uiGlobal.signalDummy, "EndSearchForPartyServerTimeout" )

	Hud_SetAutoText( file.serverSearchMessage, "", HATT_MATCHMAKING_EMPTY_SERVER_SEARCH_STATE, 0 )
	Hud_SetAutoText( file.serverSearchError, "", HATT_MATCHMAKING_EMPTY_SERVER_SEARCH_ERROR, 0 )

	string noServers              = Localize( "#MATCHMAKING_NOSERVERS" )
	string serverError            = Localize( "#MATCHMAKING_SERVERERROR" )
	string localError             = Localize( "#MATCHMAKING_LOCALERROR" )
	string lastValidSearchMessage = ""
	string lastValidSearchError   = ""
	float startTime               = UITime()

	while ( UITime() - startTime < 30.0 )
	{
		string searchMessage = Hud_GetUTF8Text( file.serverSearchMessage )
		string searchError = Hud_GetUTF8Text( file.serverSearchError )
		                                                                        

		                                  
		if ( ClientIsPreCaching() )
		{
			startTime = UITime()
		}

		if ( searchMessage == noServers || searchMessage == serverError || searchMessage == localError )
		{
			lastValidSearchMessage = searchMessage
			lastValidSearchError = searchError
		}

		WaitFrame()
	}
	                                                                                                            

	string details
	if ( (lastValidSearchMessage == serverError || lastValidSearchMessage == localError) && lastValidSearchError != "" )
		details = Localize( "#UNABLE_TO_CONNECT_ERRORCODE", lastValidSearchError )
	else
		details = Localize( "#UNABLE_TO_CONNECT" )

	thread StopSearchForPartyServer( details, Localize( "#MAINMENU_RETRY" ) )
}


void function StopSearchForPartyServer( string details, string prompt )
{
	Signal( uiGlobal.signalDummy, "EndSearchForPartyServerTimeout" )

	MatchmakingCancel()
	Party_LeaveParty()
	SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, details, prompt )
	file.searching = false

	UpdateSignedInState()
	UpdateFooterOptions()
}


bool function IsSearchingForPartyServer()
{
	return file.searching
}

#if XBOX_PROG
void function UICodeCallback_JoiningInvite()
{
	printt( "UICodeCallback_JoiningInvite" )
	SetLaunchState( eLaunchState.WORKING )

#if SPINNER_DEBUG_INFO
	SetSpinnerDebugInfo( "JoiningInvite" )
#endif
}

void function UICodeCallback_OnJoinFailed()
{
	printt( "UICodeCallback_OnFailedUserSignIn" )
	SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, "", Localize( "#MAINMENU_CONTINUE" ))
}
#endif

#if DURANGO_PROG
void function UICodeCallback_OnStartedUserSignIn()
{
	printt( "UICodeCallback_OnStartedUserSignIn" )
	SetLaunchState( eLaunchState.WORKING )

#if SPINNER_DEBUG_INFO
	SetSpinnerDebugInfo( "OnStartedUserSignIn" )
#endif
}

void function UICodeCallback_OnFailedUserSignIn()
{
	printt( "UICodeCallback_OnFailedUserSignIn" )
	SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, "", Localize( "#MAINMENU_SIGN_IN" ) )
}

void function UICodeCallback_OnCompletedUserSignIn()
{
	printt( "UICodeCallback_OnCompletedUserSignIn" )
	SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, "", Localize( "#MAINMENU_CONTINUE" ) )
}

void function UICodeCallback_OnUserSignOut()
{
	printt( "UICodeCallback_OnUserSignOut" )
	SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, "", Localize( "#MAINMENU_SIGN_IN" ) )
}

void function XB1_PermissionsDialog()
{
	Durango_VerifyMultiplayerPermissions()

	if ( !Console_HasPermissionToPlayMultiplayer() )
		file.forceProfileSelect = true

	                                         
	                              
}
#endif                


#if PLAYSTATION_PROG
                                                                       
void function PS4_PSNSignIn()
{
	if ( Ps4_LoginDialog_Schedule() )
	{
#if SPINNER_DEBUG_INFO
		SetSpinnerDebugInfo( "Ps4_LoginDialog_Running" )
#endif
		while ( Ps4_LoginDialog_Running() )
			WaitFrame()

		                                                                                      

		PS4_ScheduleUserNetworkingEnabledTest()
		WaitFrame()
		if ( !PS4_isUserNetworkingResolved() )
		{
			                                                 
#if SPINNER_DEBUG_INFO
			SetSpinnerDebugInfo( "PS4_isUserNetworkingResolved" )
#endif
			while ( !PS4_isUserNetworkingResolved() )
				WaitFrame()
		}

		                                                                                                  
		                                                                                                                               

		                                                                                                                                                                                                               
		if ( !PS4_isUserNetworkingEnabled() && PS4_getUserNetworkingResolution() != PS4_NETWORK_STATUS_AGE_RESTRICTION )
		{
			                                                     
			SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, Localize( "#PS4_DISCONNECT_NOT_SIGNED_IN_TO_PSN" ), Localize( "#MAINMENU_SIGN_IN" ) )
		}
		else
		{		
			                                                                                                          
			                                                                                  

			bool isPSNConnected
			if ( PS4_getUserNetworkingResolution() == PS4_NETWORK_STATUS_NOT_LOGGED_IN )
			{
				isPSNConnected = false
			}
			else
			{
				float endTime = UITime() + 10
				while ( !Ps4_PSN_Is_Loggedin() && UITime() < endTime )
					WaitFrame()

				isPSNConnected = Ps4_PSN_Is_Loggedin()
			}

			PrintLaunchDebugVal( "isPSNConnected", isPSNConnected )
			if ( !isPSNConnected )
				SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, Localize( "#PS4_DISCONNECT_NOT_SIGNED_IN_TO_PSN" ), Localize( "#MAINMENU_SIGN_IN" ) )
			else
				PrelaunchValidateAndLaunch()
		}
	}
}


void function PS_PlusSignUp()
{
	if ( PS_ScreenPlusDialog_Schedule() )
	{
#if SPINNER_DEBUG_INFO
		SetSpinnerDebugInfo( "PS_ScreenPlusDialog_Running" )
#endif
		while ( PS_ScreenPlusDialog_Running() )
			WaitFrame()

		PS_CheckPlus_Schedule()
#if SPINNER_DEBUG_INFO
		SetSpinnerDebugInfo( "PS_CheckPlus_Running" )
#endif
		while ( PS_CheckPlus_Running() )
			WaitFrame()
		bool hasPlus = PS_CheckPlus_Allowed()
		PrintLaunchDebugVal( "hasPlus", hasPlus )

		if ( !hasPlus )
			SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, Localize( "#PSN_MUST_BE_PLUS_USER" ), Localize( "#MAINMENU_CONTINUE" ) )
		else
			PrelaunchValidateAndLaunch()
	}
}
#endif                    

void function LaunchButton_OnActivate( var button )
{
	if ( file.launchButtonActivateFunc == null )
	{
		printt( "*** LaunchButton_OnActivate ***  Null")
		return
	}

	printt( "*** LaunchButton_OnActivate ***", string( file.launchButtonActivateFunc ) )
	thread file.launchButtonActivateFunc()
}


void function UICodeCallback_GetOnPartyServer()
{
	SetLaunchingState( eLaunching.MULTIPLAYER_INVITE )
	PrelaunchValidateAndLaunch()
}


bool function IsStryderAuthenticated()
{
	return GetConVarInt( "mp_allowed" ) != -1
}


bool function IsStryderAllowingMP()
{
	return GetConVarInt( "mp_allowed" ) == 1
}


                                                                                   
bool function HasLatestPatch()
{
	#if PS4_PROG
		if ( PS4_getUserNetworkingErrorStatus() == -2141913073 )                                       
			return false
	#endif            

	return true
}


bool function HasPermission()
{
	#if CONSOLE_PROG
		return Console_HasPermissionToPlayMultiplayer()                                                                                                                                   
	#endif

	return true
}


void function Accessibility_OnActivate( var button )
{
	#if DURANGO_PROG
		if ( !Console_IsSignedIn() )
			return
	#endif

	if ( IsDialog( GetActiveMenu() ) )
		return

	if ( !IsAccessibilityAvailable() )
		return

	AdvanceMenu( GetMenu( "AccessibilityDialog" ) )
}


void function OnConfirmDialogResult( int result )
{
	printt( result )
}


void function PrintLaunchDebugVal( string name, bool val )
{
	#if DEV
		printt( "*** PrelaunchValidation *** " + name + ": " + val )
	#endif       
}

#if CONSOLE_PROG
void function NucleusLogin()
{
	if ( file.isNucleusProcessActive )
		return

	file.isNucleusProcessActive = true
	OnThreadEnd( void function() {
		file.isNucleusProcessActive = false
	} )

	if ( !Easdk_is_loggedin() )
	{
		printt( "Easdk_is_loggedin is false 1." )
		WaitFrame();
		Easdk_login()
#if SPINNER_DEBUG_INFO
		SetSpinnerDebugInfo( "Easdk_is_logging_in" )
#endif
		while ( Easdk_is_logging_in() )
			WaitFrame()
	}

	if ( !Easdk_is_loggedin() )
	{
		string errorDetails
		if ( Eadpsdk_use() )
		{
			errorDetails = Localize( "#ORIGINSDK_UNKNOWN_EADP_ERROR", Eadpsdk_last_error_domain(), string(Eadpsdk_last_error_code()) )
		}
		else
		{
			switch ( Nucleussdk_last_error() )
			{
				case EA_Nucleus_kNcsErrorLoginCancelled:
					errorDetails = Localize( "#ORIGINSDK_NO_ACCOUNT" )
					break

				case EA_Nucleus_kNcsErrorServerError:
					errorDetails = Localize( "#ORIGINSDK_EA_NETWORK" )
					break

				case EA_Nucleus_kNcsErrorDeviceTokenError:
#if DURANGO_PROG
					errorDetails = Localize( "#ORIGINSDK_XBOX1_NETWORK" )
#elseif PLAYSTATION_PROG
					errorDetails = Localize( "#ORIGINSDK_PS4_NETWORK" )
#endif
					break

				default:
					errorDetails = Localize( "#ORIGINSDK_UNKNOWN_ERROR", string( Nucleussdk_last_error() ) )
					break
			}
		}

		SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, errorDetails, Localize( "#MAINMENU_RETRY" ) )
		return
	}
	else
	{
		PrelaunchValidateAndLaunch()
	}
}
#endif                

void function SwitchProfile_OnActivate( var button )
{
	#if DURANGO_PROG
		bool isOnline = Console_IsOnline()
		if ( !isOnline )
		{
			SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, Localize( "#INTERNET_NOT_FOUND" ), Localize( "#MAINMENU_RETRY" ) )
			return
		}

		                                                                                                          
		Xbox_ShowAccountPicker()
		Durango_GoToSplashScreen()
		SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, "", Localize( "#MAINMENU_SIGN_IN" ) )
	#endif
}


bool function IsSwitchProfileFooterValid()
{
	#if DURANGO_PROG
		return Console_IsSignedIn() && !IsWorking() && !IsSearchingForPartyServer()
	#else
		return false
	#endif
}


#if DEV
void function DEV_TestFooterTextWidths( var elem )
{
	while ( true )
	{
		Hud_SetText( elem, "testing" )
		wait 3
		Hud_SetText( elem, "testing longer" )
		wait 3
		Hud_SetText( elem, "testing even longer" )
		wait 3
		Hud_SetText( elem, "testing even more longer" )
		wait 3
		Hud_SetText( elem, "testing even more more more longer" )
		wait 3
		Hud_SetText( elem, "testing even more more more more more more longer" )
		wait 3
	}
}

void function DEV_ToggleRuiIssuesDemo( string elemName )
{
	var targetElem = Hud_GetChild( file.panel, elemName )

	array<var> elems
	elems.append( Hud_GetChild( file.panel, "RuiIssuesTransparency" ) )
	elems.append( Hud_GetChild( file.panel, "RuiIssuesSamplingBlur" ) )
	elems.append( Hud_GetChild( file.panel, "RuiIssues9SliceScaling" ) )

	foreach ( elem in elems )
	{
		if ( elem == targetElem )
			Hud_SetVisible( elem, !Hud_IsVisible( elem ) )
		else
			Hud_SetVisible( elem, false )
	}
}
#endif       