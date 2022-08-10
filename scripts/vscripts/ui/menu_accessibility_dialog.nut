global function InitAccessibilityDialog
global function AccessibilityHint
global function AccessibilityHintReset

global enum eAccessibilityHint
{
	LAUNCH_TO_LOBBY
	LOBBY_CHAT
	_COUNT
}

struct {
	var  menu
	var  contentRui
	bool wasNarrationEnabled

	bool[eAccessibilityHint._COUNT] hasPlayed
} file

void function InitAccessibilityDialog( var newMenuArg )                                               
{
	var menu = GetMenu( "AccessibilityDialog" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenMenu )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnCloseMenu )

	SetDialog( menu, true )

	SetupAccessibilityButton( Hud_GetChild( menu, "SwchSubtitles" ), "#SUBTITLES", "#OPTIONS_MENU_SUBTITLES_DESC" )
	SetupAccessibilityButton( Hud_GetChild( menu, "SwchSubtitlesSize" ), "#SUBTITLE_SIZE", "#OPTIONS_MENU_SUBTITLE_SIZE_DESC" )
	SetupAccessibilityButton( Hud_GetChild( menu, "SwchAccessibility" ), "#MENU_CHAT_ACCESSIBILITY", "#OPTIONS_MENU_ACCESSIBILITY_DESC" )
	SetupAccessibilityButton( Hud_GetChild( menu, "SwchChatSpeechToText" ), "#MENU_CHAT_SPEECH_TO_TEXT", "#OPTIONS_MENU_CHAT_SPEECH_TO_TEXT_DESC" )
	SetupAccessibilityButton( Hud_GetChild( menu, "SwchChatTextToSpeech" ), "#MENU_CHAT_TEXT_TO_SPEECH", "#OPTIONS_MENU_CHAT_TEXT_TO_SPEECH_DESC" )

	file.contentRui = Hud_GetChild( file.menu, "ContentRui" )

	HudElem_SetRuiArg( file.contentRui, "headerText", "#MENU_ACCESSIBILITY" )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE", CloseActiveMenuButton )

	#if DURANGO_PROG || XB5_PROG || PS4_PROG || PS5_PROG

		int ttsConsoleSetting = Accessibility_TTS_SystemDefault()
		var ttsButton = Hud_GetChild( menu, "SwchChatTextToSpeech" )

		#if DURANGO_PROG || XB5_PROG
			if( ttsConsoleSetting == ACCESSIBILITY_STATE_ENABLED )
				Hud_ModifySelectionString( ttsButton, "0", "#SETTING_CONSOLE_DEFAULT_ON" )
			else if( ttsConsoleSetting == ACCESSIBILITY_STATE_DISABLED )
				Hud_ModifySelectionString( ttsButton, "0", "#SETTING_CONSOLE_DEFAULT_OFF" )
			else
				Hud_ModifySelectionString( ttsButton, "0", "#SETTING_CONSOLE_DEFAULT" )
		#elseif PS4_PROG || PS5_PROG
			if( ttsConsoleSetting == ACCESSIBILITY_STATE_ENABLED )
				Hud_ModifySelectionString( ttsButton, "0", "#SETTING_SYSTEM_DEFAULT_ON" )
			else if( ttsConsoleSetting == ACCESSIBILITY_STATE_DISABLED )
				Hud_ModifySelectionString( ttsButton, "0", "#SETTING_SYSTEM_DEFAULT_OFF" )
			else
				Hud_ModifySelectionString( ttsButton, "0", "#SETTING_SYSTEM_DEFAULT" )
		#endif

	#endif
}


void function OnOpenMenu()
{
	#if DURANGO_PROG
		HudElem_SetRuiArg( file.contentRui, "messageText", Localize( "#SIGNED_IN_AS_N", Durango_GetGameDisplayName() ) )
	#else
		HudElem_SetRuiArg( file.contentRui, "messageText", "#MENU_ACCESSIBILITY_DESC" )
	#endif

	file.wasNarrationEnabled = IsAccessibilityNarrationEnabled()
	SetCursorPosition( <1920.0 * 0.5, 1080.0 * 0.5, 0> )

	SetMenuNavigationDisabled( false )
}

void function OnCloseMenu()
{
	if ( IsAccessibilityNarrationEnabled() && !file.wasNarrationEnabled )
		AccessibilityHintReset()

	SavePlayerSettings()

	if ( GetActiveMenu() == GetMenu( "MainMenu" ) )
		SetMenuNavigationDisabled( true )
}


void function CloseActiveMenuButton( var unused )
{
	CloseActiveMenuNoParms()
}


void function SetupAccessibilityButton( var button, string buttonText, string description )
{
	SetButtonRuiText( button, buttonText )

	ToolTipData toolTipData
	toolTipData.titleText = buttonText
	toolTipData.descText = description
	toolTipData.tooltipStyle = eTooltipStyle.ACCESSIBLE
	Hud_SetToolTipData( button, toolTipData )
}


void function AccessibilityHintReset( int hintType = -1 )
{
	if ( hintType == -1 )
	{
		for ( int index = 0; index < file.hasPlayed.len(); index++ )
			file.hasPlayed[index] = false
	}
	else
	{
		file.hasPlayed[hintType] = false
	}
}


void function AccessibilityHint( int hintType )
{
	if ( !IsAccessibilityNarrationEnabled() )
		return

	switch ( hintType )
	{
		case eAccessibilityHint.LAUNCH_TO_LOBBY:
			if ( !file.hasPlayed[hintType] )
			{
				string text
				if ( !IsControllerModeActive() )
					text = "#ACCESSIBILITY_HINT_LAUNCH_TO_LOBBY_MOUSE"
				else if ( IsGamepadPS4() || IsGamepadPS5() )
					text = "#ACCESSIBILITY_HINT_LAUNCH_TO_LOBBY_X"
				else
					text = "#ACCESSIBILITY_HINT_LAUNCH_TO_LOBBY_A"

				PlayTextToSpeech( Localize( text ) )
				file.hasPlayed[hintType] = true
			}
			break
		case eAccessibilityHint.LOBBY_CHAT:
			if ( !file.hasPlayed[hintType] )
			{
				PlayTextToSpeech( Localize( "#ACCESSIBILITY_HINT_LOBBY_CHAT" ) )
				file.hasPlayed[hintType] = true
			}
			break
	}
}