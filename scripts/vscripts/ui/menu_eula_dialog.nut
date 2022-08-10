global function InitEULADialog
global function OpenEULADialog
global function IsEULAAccepted
global function IsLobbyAndEULAAccepted

struct
{
	var menu
	var agreement
	var acknowledgement
	var footersPanel
	var parentMenuPanel
	var savedFocusItem
	int eulaVersion
	bool reviewing
	#if NX_PROG
	bool ShowingMustAccept
	var mustAcceptText
	#endif
} file


void function InitEULADialog( var newMenuArg )                                               
{
	var menu = GetMenu( "EULADialog" )
	file.menu = menu

	SetDialog( menu, true )
	SetGamepadCursorEnabled( menu, false )

	file.agreement = Hud_GetChild( menu, "Agreement" )
	file.acknowledgement = Hud_GetRui( Hud_GetChild( menu, "Acknowledgement" ) )
	file.footersPanel = Hud_GetChild( menu, "FooterButtons" )
	file.savedFocusItem = null

	#if NX_PROG
	file.mustAcceptText = Hud_GetChild(menu, "NXMustAcceptText")
	
	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_CONTINUE", "#A_BUTTON_ACCEPT", AcceptEULA, IsNotReviewingAndStandardVersionForNXAccept )
	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_CONTINUE", "#A_BUTTON_CONTINUE", AcceptEULA, IsNotReviewingAndEUVersionForNXAccept )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CANCEL", "#B_BUTTON_DECLINE", null, IsNotReviewingAndStandardVersion )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CANCEL", "#CANCEL", null, IsNotReviewingAndEUVersion )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#CLOSE", null, IsReviewing )
	#else	
	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_ACCEPT", "#A_BUTTON_ACCEPT", AcceptEULA, IsNotReviewingAndStandardVersion )
	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_CONTINUE", "#A_BUTTON_CONTINUE", AcceptEULA, IsNotReviewingAndEUVersion )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_DECLINE", "#B_BUTTON_DECLINE", null, IsNotReviewingAndStandardVersion )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CANCEL", "#CANCEL", null, IsNotReviewingAndEUVersion )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#CLOSE", null, IsReviewing )
	#endif

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, EULADialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, EULADialog_OnClose )
	#if NX_PROG
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnBackButtonPressed )
	file.ShowingMustAccept = false
	#endif
}


bool function IsReviewing()
{
	return file.reviewing
}


bool function IsEUVersion()
{
	return ShouldUserSeeEULAForEU()
}


bool function IsNotReviewingAndStandardVersion()
{
#if NX_PROG
	return !IsReviewing() && !IsEUVersion() && !file.ShowingMustAccept
#else
	return !IsReviewing() && !IsEUVersion()
#endif
}


bool function IsNotReviewingAndEUVersion()
{
#if NX_PROG
	return !IsReviewing() && IsEUVersion() && !file.ShowingMustAccept
#else
	return !IsReviewing() && IsEUVersion()
#endif
}

bool function IsNotReviewingAndStandardVersionForNXAccept()
{
	return !IsReviewing() && !IsEUVersion()
}


bool function IsNotReviewingAndEUVersionForNXAccept()
{
	return !IsReviewing() && IsEUVersion()
}


void function OpenEULADialog( bool review, var parentMenu = null, var focusItem = null )
{
	file.reviewing = review
	file.parentMenuPanel = parentMenu
	file.savedFocusItem = focusItem
	AdvanceMenu( file.menu )
}


void function EULADialog_OnOpen()
{
	file.eulaVersion = GetCurrentEULAVersion()

	if( file.reviewing && file.parentMenuPanel != null )
		ScrollPanel_SetActive( file.parentMenuPanel, false )

	                                                                                              
	RegisterStickMovedCallback( ANALOG_RIGHT_Y, FocusAgreementForScrolling )
	RegisterButtonPressedCallback( BUTTON_DPAD_UP, FocusAgreementForScrolling )
	RegisterButtonPressedCallback( BUTTON_DPAD_DOWN, FocusAgreementForScrolling )

	var frameElem = Hud_GetChild( file.menu, "DialogFrame" )
	RuiSetImage( Hud_GetRui( frameElem ), "basicImage", $"rui/menu/common/dialog_gradient" )

	int agreementHeight = IsReviewing() ? 480 : 410
	Hud_SetHeight( file.agreement, ContentScaledYAsInt( agreementHeight ) )

	string acknowledgementText = ""
	if ( !IsReviewing() )
	#if NX_PROG
		acknowledgementText = "#EULA_ACKNOWLEDGEMENT_NX"
	#else
		acknowledgementText = IsEUVersion() ? "#EULA_ACKNOWLEDGEMENT_EU" : "#EULA_ACKNOWLEDGEMENT"
	#endif
	RuiSetArg( file.acknowledgement, "acknowledgementText", Localize( acknowledgementText ) )

	int footerPanelWidth = IsReviewing() ? 200 : 422
	Hud_SetWidth( file.footersPanel, ContentScaledXAsInt( footerPanelWidth ) )
}


void function EULADialog_OnClose()
{
	if ( GetLaunchingState() )
	{
		if ( IsEULAAccepted() )
			PrelaunchValidateAndLaunch()
		else
			SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, "", Localize( "#MAINMENU_CONTINUE" ) )
	}

	if( file.reviewing && file.parentMenuPanel != null )
		ScrollPanel_SetActive( file.parentMenuPanel, true )

	DeregisterStickMovedCallback( ANALOG_RIGHT_Y, FocusAgreementForScrolling )
	DeregisterButtonPressedCallback( BUTTON_DPAD_UP, FocusAgreementForScrolling )
	DeregisterButtonPressedCallback( BUTTON_DPAD_DOWN, FocusAgreementForScrolling )

	if (file.savedFocusItem != null)
		Hud_SetFocused( file.savedFocusItem )
}


void function AcceptEULA( var button )
{
#if NX_PROG
	if(file.ShowingMustAccept)
	{
		Hud_SetVisible( file.agreement, true )
		Hud_SetVisible( file.mustAcceptText, false )
		string acknowledgementText = ""
		if ( !IsReviewing() )
			acknowledgementText = "#EULA_ACKNOWLEDGEMENT_NX"
		RuiSetArg( file.acknowledgement, "acknowledgementText", Localize( acknowledgementText ) )
		file.ShowingMustAccept = false
	}
	else
	{
		SetEULAVersionAccepted( file.eulaVersion )
		CloseActiveMenu()
	}
#else
	SetEULAVersionAccepted( file.eulaVersion )
	CloseActiveMenu()
#endif
}


bool function IsEULAAccepted()
{
	return GetEULAVersionAccepted() >= GetCurrentEULAVersion()
}


bool function IsLobbyAndEULAAccepted()
{
	return IsLobby() &&	IsEULAAccepted()
}

void function FocusAgreementForScrolling( ... )
{
	if( !Hud_IsFocused( file.agreement ) )
		Hud_SetFocused( file.agreement );
}

void function OnBackButtonPressed()
{
#if NX_PROG
	if( IsReviewing() )
	{
		CloseActiveMenu()
	}
	else if(!file.ShowingMustAccept)
	{
		Hud_SetVisible( file.agreement, false )
		RuiSetArg( file.acknowledgement, "acknowledgementText", "" )
		Hud_SetVisible( file.mustAcceptText, true )
		file.ShowingMustAccept = true
	}	
#endif
}