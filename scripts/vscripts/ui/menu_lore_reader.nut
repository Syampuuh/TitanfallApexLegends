global function InitLoreReaderMenu
global function LoreReaderMenu_OpenTo
global function LoreReaderMenu_OpenToWithNavigateBack
global function LoadLorePagesFromDataTable
global function LoreReader_GetLastOpenedDataAsset
#if DEV
global function LoreReaderMenu_TestOpen
#endif       

enum eSlot
{
	TOP,
	CENTER,
	BOTTOM,

	_count
}

enum ePageStep
{
	BLANK,
	TOP_FADE_IN,
	CENTER_FADE_IN,
	BOTTOM_FADE_IN,
	DONE,
	_count
}

enum eSoundTiming
{
	PAGE_OPEN,
	MIDDLE_LINE,
	BOTTOM_LINE,
	_count
}

global struct SpeakerLine
{
	bool enabled = false
	string character
	string textLine
	asset portrait
}
global struct LorePage
{
	string        titleText
	string        subTitleText
	string        narratorName
	asset         narratorPortrait
	string        dataText
	array<string> chatlogText

	struct
	{
		string ambientTrack
		string musicTrack

		array<string>[eSoundTiming._count] playSounds
		array<string>                      stopSounds

		string[eSoundTiming._count] playLoopingSoundA
		string[eSoundTiming._count] playLoopingSoundB
		string[eSoundTiming._count] playLoopingSoundC
		bool                        doStopLoopingSoundA
		bool                        doStopLoopingSoundB
		bool                        doStopLoopingSoundC
	} sounds

	string backgroundRef

	SpeakerLine[3] speakers

}

struct
{
	#if UI
		                
		float pin_viewStartTime
	#endif     

} file

array<LorePage> s_pages
var s_menu

void function InitLoreReaderMenu( var newMenuArg )
{
	var menu = newMenuArg
	Hud_SetAboveBlur( menu, true )
	s_menu = menu

	               

	SetGamepadCursorEnabled( menu, false )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnMenuOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnMenuClose )

	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnMenuShow )
	AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, OnMenuHide )

	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnNavigateBack )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_NEXT", "#A_BUTTON_NEXT" )
	AddMenuFooterOption( menu, LEFT, BUTTON_X, true, "#X_BUTTON_PREVIOUS", "#X_BUTTON_PREVIOUS", null, HasPrevious )
}

const int[10] CONTINUE_BUTTONS =	[BUTTON_A, BUTTON_SHOULDER_RIGHT, MOUSE_LEFT, MOUSE_WHEEL_DOWN, KEY_SPACE, KEY_RIGHT, KEY_DOWN, STICK1_RIGHT, BUTTON_DPAD_DOWN, BUTTON_DPAD_RIGHT]
const int[8] PREV_BUTTONS =		[BUTTON_SHOULDER_LEFT, MOUSE_RIGHT, MOUSE_WHEEL_UP, KEY_LEFT, KEY_UP, STICK1_LEFT, BUTTON_DPAD_UP, BUTTON_DPAD_LEFT]

bool s_registeredButtons = false
float s_openedTime = 0.0
void function OnMenuOpen()
{
}

void function OnMenuShow()
{
	SetBlurEnabled( true )
	s_openedTime = UITime()

	UI_SetPresentationType( ePresentationType.BATTLE_PASS_3 )
	RunClientScript( "ClearBattlePassItem" )

	if ( !s_registeredButtons )
	{
		foreach( button in CONTINUE_BUTTONS )
			RegisterButtonPressedCallback( button, OnPressedContinue )
		foreach( button in PREV_BUTTONS )
			RegisterButtonPressedCallback( button, OnPressedPrevious )
		s_registeredButtons = true
	}

	InitPagesForMenuOpen()

	UpdateOptInFooter()
}
void function LoreReaderMenu_OpenTo( asset dtAsset )
{
	s_dataToLoadOnOpen = dtAsset
	s_onNavigatingBackFunc = null
	AdvanceMenu( s_menu )
}
void function LoreReaderMenu_OpenToWithNavigateBack( asset dtAsset, void functionref() onNavigatingBackFunc )
{
	s_dataToLoadOnOpen = dtAsset
	s_onNavigatingBackFunc = onNavigatingBackFunc
	AdvanceMenu( s_menu )
}

asset function CastStringToAsset( string val )
{
	return GetKeyValueAsAsset( { kn = val }, "kn" )
}

#if DEV
void function LoreReaderMenu_TestOpen( string seqPathName )
{
	string assetPath = format( "datatable/lore_sequence/%s.rpak", seqPathName )
	LoreReaderMenu_OpenTo( CastStringToAsset( assetPath ) )
}
#endif       


void function OnMenuClose()
{
	if ( s_latestAmbientTrack.len() > 0 )
		StopUISound( s_latestAmbientTrack )

	for( int idx = 0; idx < s_latestLoopingTracks.len(); ++idx )
	{
		if ( s_latestLoopingTracks[idx].len() > 0 )
			StopUISound( s_latestLoopingTracks[idx] )
	}

	CancelCustomUIMusic()
}

void function OnMenuHide()
{
	if ( s_registeredButtons )
	{
		foreach( button in CONTINUE_BUTTONS )
			DeregisterButtonPressedCallback( button, OnPressedContinue )
		foreach( button in PREV_BUTTONS )
			DeregisterButtonPressedCallback( button, OnPressedPrevious )
		s_registeredButtons = false
	}
}

void function OnPressedContinue( var button )
{
	if ( s_pageIndex >= s_pages.len() )
		return

	EmitUISound( "UI_Menu_SQ_Advance" )
	OnClickedToAdvance( true )
}
void function OnPressedPrevious( var button )
{
	if ( s_pageIndex <= 0 )
		return

	EmitUISound( "UI_Menu_SQ_Advance" )
	OnClickedToAdvance( false )
}

bool function HasPrevious()
{
	return s_pageIndex > 0
}

void function OnNavigateBack()
{
	Assert( GetActiveMenu() == s_menu )

	if ((UITime() - s_openedTime) < 1.0 )
		return

	if ( s_onNavigatingBackFunc != null )
		s_onNavigatingBackFunc()

	CloseActiveMenu()
}

void function UpdateOptInFooter()
{
	UpdateFooterOptions()
}

Assert( eSoundTiming._count == 3 )
int function ParseTimingKeyword( string keyWord )
{
	switch ( keyWord.tolower() )
	{
		case "":
		case "top":
		case "t":
			return eSoundTiming.PAGE_OPEN
		case "center":
		case "c":
			return eSoundTiming.MIDDLE_LINE
		case "bottom":
		case "b":
			return eSoundTiming.BOTTOM_LINE
	}

	Warning( "%s() - Unhandled timing keyword: '%s'", FUNC_NAME(), keyWord )
	return -1
}
bool function ParsePlaySoundCmd( LorePage page, string cmd, string argStr )
{
	int timing = eSoundTiming.PAGE_OPEN

	array<string> args = split( argStr, "| " )
	if ( args.len() > 1 )
	{
		timing = ParseTimingKeyword( args[1] )
		if ( timing < 0 )
			return false
	}

	switch( cmd )
	{
		case "playsound":
			page.sounds.playSounds[timing].append( args[0].tolower() )
			break
		case "playsoundloop_a":
			page.sounds.playLoopingSoundA[timing] = args[0].tolower()
			break
		case "playsoundloop_b":
			page.sounds.playLoopingSoundB[timing] = args[0].tolower()
			break
		case "playsoundloop_c":
			page.sounds.playLoopingSoundC[timing] = args[0].tolower()
			break
		default:
			Assert( false, ("Unhandled playsound cmd:" + cmd) )
	}
	return true
}

bool function ParseStopSoundCmd( LorePage page, string cmd, string argStr )
{
	array<string> args = split( argStr, "| " )

	switch( cmd )
	{
		case "stopsound":
			if ( (args.len() < 1) || (args[0].len() == 0) )
			{
				Warning( "%s() - Got '%s' command but no alias argument.", FUNC_NAME(), cmd )
				return false
			}
			page.sounds.stopSounds.append( args[0].tolower() )
			break
		case "stopsoundloop_a":
			if ( args.len() > 0 )
				Warning( "%s() - Command '%s' doesn't take arguments. Arg '%s' will be ignored.", FUNC_NAME(), cmd, args[0] )
			page.sounds.doStopLoopingSoundA = true
			break
		case "stopsoundloop_b":
			if ( args.len() > 0 )
				Warning( "%s() - Command '%s' doesn't take arguments. Arg '%s' will be ignored.", FUNC_NAME(), cmd, args[0] )
			page.sounds.doStopLoopingSoundB = true
			break
		case "stopsoundloop_c":
			if ( args.len() > 0 )
				Warning( "%s() - Command '%s' doesn't take arguments. Arg '%s' will be ignored.", FUNC_NAME(), cmd, args[0] )
			page.sounds.doStopLoopingSoundC = true
			break
		default:
			Assert( false, ("Unhandled stopsound cmd:" + cmd) )
	}
	return true
}

array<LorePage> function LoadLorePagesFromDataTable( asset dtAsset )
{
	var dt = GetDataTable( dtAsset )
	int columnCmd		= GetDataTableColumnByName( dt, "cmd" )
	int columnArgs		= GetDataTableColumnByName( dt, "args" )
	int columnSpeaker	= GetDataTableColumnByName( dt, "speaker" )
	int columnText		= GetDataTableColumnByName( dt, "text" )
	int columnEmotion	= GetDataTableColumnByName( dt, "emotion" )
	int columnDirection	= GetDataTableColumnByName( dt, "direction" )

	array<LorePage> pages

	LorePage page
	bool pageHasData = false
	int numRows = GetDataTableRowCount( dt )
	for ( int rowIdx = 0; rowIdx < numRows; rowIdx++ )
	{
		string cmd = GetDataTableString( dt, rowIdx, columnCmd )
		string argStr = GetDataTableString( dt, rowIdx, columnArgs )
		string speaker = GetDataTableString( dt, rowIdx, columnSpeaker )
		string text = GetDataTableString( dt, rowIdx, columnText )

		string lookDirection = "l"
		if(columnDirection > -1)
			lookDirection = GetDataTableString( dt, rowIdx, columnDirection )

		asset portrait

		printt("speaker", speaker)
		if ( speaker == "yoko" || speaker == "????" )
		{
			portrait = $"rui/menu/quest/lore_page/lore_page_portrait_waveform"
		}
		else if(columnEmotion > -1)
		{
			string emotion = GetDataTableString( dt, rowIdx, columnEmotion )
			if(emotion.len() > 0 && speaker.len() > 0)
				portrait = CastStringToAsset( $"rui/menu/quest/characters/" + speaker.tolower() + "_" + emotion.tolower() + "_" + lookDirection  )
		}


		bool isComment = (cmd.len() > 1) && (cmd.slice( 0, 2 ) == "//")
		if ( (cmd == "") || isComment )
		{
			if ( pageHasData )
			{
				pages.append( page )
				LorePage newPage
				page = newPage
				pageHasData = false
			}
			continue
		}

		bool hadError
		cmd = cmd.tolower()
		switch( cmd )
		{
			case "top":
			case "t":
				page.speakers[0].enabled = true
				page.speakers[0].character = speaker
				page.speakers[0].textLine = text
				page.speakers[0].portrait = portrait
				pageHasData = true
				break
			case "center":
			case "c":
				page.speakers[1].enabled = true
				page.speakers[1].character = speaker
				page.speakers[1].textLine = text
				page.speakers[1].portrait = portrait
				pageHasData = true
				break
			case "bottom":
			case "b":
				page.speakers[2].enabled = true
				page.speakers[2].character = speaker
				page.speakers[2].textLine = text
				page.speakers[2].portrait = portrait
				pageHasData = true
				break
			case "background":
				page.backgroundRef = argStr.tolower()
				pageHasData = true
				break
			case "musictrack":
				page.sounds.musicTrack = argStr
				pageHasData = true
				break
			case "ambienttrack":
				page.sounds.ambientTrack = argStr
				pageHasData = true
				break
			case "playsound":
			case "playsoundloop_a":
			case "playsoundloop_b":
			case "playsoundloop_c":
				if ( !ParsePlaySoundCmd( page, cmd, argStr ) )
					hadError = true
				pageHasData = true
				break
			case "stopsound":
			case "stopsoundloop_a":
			case "stopsoundloop_b":
			case "stopsoundloop_c":
				if ( !ParseStopSoundCmd( page, cmd, argStr ) )
					hadError = true
				pageHasData = true
				break
			case "datatext":
				page.dataText = text
				pageHasData = true
				break
			case "title":
				page.titleText = argStr
				pageHasData = true
				break
			case "subtitle":
				page.subTitleText = argStr
				pageHasData = true
				break
			case "narrator":
				page.narratorName = argStr
				page.narratorPortrait = portrait
				pageHasData = true
				break
			case "chatlog":
				page.chatlogText.append( text )
				pageHasData = true
				break
			default:
				hadError = true
		}

		if ( hadError )
		{
			string errMsg = format( "%s() - Unhandled command '%s' on row #%d of '%s'", FUNC_NAME(), cmd, rowIdx, string( dtAsset ) )
			Assert( 0, errMsg )
			Warning( "%s", errMsg )
			hadError = false
		}
	}

	if ( pageHasData )
		pages.append( page )

	if ( pages.len() == 0 )
	{
		page.titleText = "Empty Datatable!"
		page.subTitleText = string( dtAsset )
		pages.append( page )
	}

	return pages
}

asset s_dataToLoadOnOpen = $""
asset s_lastOpenedData = $""
void functionref() s_onNavigatingBackFunc = null
void function InitPagesForMenuOpen()
{
	s_pages.clear()
	if ( s_dataToLoadOnOpen == $"" )
	{
		LorePage page
		page.titleText = FUNC_NAME()
		page.subTitleText = "No datatable to load."
		s_pages.append( page )
	}
	else
	{
		s_pages = LoadLorePagesFromDataTable( s_dataToLoadOnOpen )
	}
	s_lastOpenedData = s_dataToLoadOnOpen

	var rui = Hud_GetRui( Hud_GetChild( s_menu, "LoreReaderScreen" ) )
	UpdateBackgroundLoadscreen( "" )

	s_latestMusicTrack = ""
	s_latestAmbientTrack = ""

	for( int idx = 0; idx < s_latestLoopingTracks.len(); ++idx )
		s_latestLoopingTracks[idx] = ""

	s_prevTopCharacter = ""
	s_prevBottomCharacter = ""
	SetUpNewPage( 0 )

	s_lastScreenOpenTime = UITime()
	++s_screenOpenNumber
	file.pin_viewStartTime = UITime()
	RuiSetInt( rui, "screenOpenNumber", s_screenOpenNumber )
  
}

asset function LoreReader_GetLastOpenedDataAsset()
{
	return s_lastOpenedData
}

void function UpdateBackgroundLoadscreen( string backgroundRef )
{
	var rui = Hud_GetRui( Hud_GetChild( s_menu, "LoreReaderScreen" ) )

	vector shiftLayerColor = SrgbToLinear( <0, 59, 93> / 255.0 )
	float shiftLayerColorA = 0.90
	vector bleedLayerColor = SrgbToLinear( <255, 255, 255> / 255.0 )
	float bleedLayerColorA = 0.03
	vector scanLayerColor = SrgbToLinear( <255, 255, 255> / 255.0 )
	float scanLayerColorA = 0.93
	float finalDarkeningAlpha = 0.57

	                 
	switch( backgroundRef )
	{
		case "":
			finalDarkeningAlpha = 1.0
			break
		case "loadscreen_s05bp_06":
			bleedLayerColorA = 0.15
			break
	}

	RuiSetColorAlpha( rui, "shiftLayerColor", shiftLayerColor, shiftLayerColorA )
	RuiSetColorAlpha( rui, "bleedLayerColor", bleedLayerColor, bleedLayerColorA )
	RuiSetColorAlpha( rui, "scanLayerColor", scanLayerColor, scanLayerColorA )
	RuiSetFloat( rui, "finalDarkeningAlpha", finalDarkeningAlpha )

	if ( backgroundRef.len() > 0 )
	{
		RunClientScript( "UpdateLoadscreenPreviewMaterial", Hud_GetChild( s_menu, "LoreReaderScreen" ), null, ItemFlavor_GetGUID( GetItemFlavorByHumanReadableRef( backgroundRef ) ) )
	}
	else
	{
		RuiSetImage( rui, "loadscreenImage", $"" )
		RuiSetBool( rui, "loadscreenImageIsReady", false )
	}
}

bool function IsAValidPageStep( int step, LorePage page )
{
	Assert( step >= 0 )
	switch( step )
	{
		case ePageStep.BLANK:
			return true
		case ePageStep.TOP_FADE_IN:
			return (((page.speakers[eSlot.TOP].textLine.len() > 0)) || (page.dataText.len() > 0) || (page.titleText.len() > 0) || (page.subTitleText.len() > 0) || (page.chatlogText.len() > 0) )
		case ePageStep.CENTER_FADE_IN:
			return (page.speakers[eSlot.CENTER].textLine.len() > 0)
		case ePageStep.BOTTOM_FADE_IN:
			return (page.speakers[eSlot.BOTTOM].textLine.len() > 0)
		case ePageStep.DONE:
			return true
	}

	return false
}
int function GetNextPageStep( int step, LorePage page )
{
	for ( int nextStep = (step + 1); nextStep <= ePageStep.DONE; ++nextStep )
	{
		if ( IsAValidPageStep( nextStep, page ) )
			return nextStep
	}

	return ePageStep._count
}

void function HandleNewPageStep( int step, LorePage page )
{
	switch ( step )
	{
		case ePageStep.CENTER_FADE_IN:
			foreach ( sound in page.sounds.playSounds[eSoundTiming.MIDDLE_LINE] )
				EmitUISound( sound )
			UpdateIfNewLoopingTrackA( page.sounds.playLoopingSoundA[eSoundTiming.MIDDLE_LINE] )
			UpdateIfNewLoopingTrackB( page.sounds.playLoopingSoundB[eSoundTiming.MIDDLE_LINE] )
			UpdateIfNewLoopingTrackC( page.sounds.playLoopingSoundC[eSoundTiming.MIDDLE_LINE] )
			break
		case ePageStep.BOTTOM_FADE_IN:
			foreach ( sound in page.sounds.playSounds[eSoundTiming.BOTTOM_LINE] )
				EmitUISound( sound )
			UpdateIfNewLoopingTrackA( page.sounds.playLoopingSoundA[eSoundTiming.BOTTOM_LINE] )
			UpdateIfNewLoopingTrackB( page.sounds.playLoopingSoundB[eSoundTiming.BOTTOM_LINE] )
			UpdateIfNewLoopingTrackC( page.sounds.playLoopingSoundC[eSoundTiming.BOTTOM_LINE] )
			break
	}
}

const int MAX_CHATLOG_LINES = 25
void function SetChatlogText( var rui, int index, string text )
{
	Assert( index >= 0 )
	Assert( index < MAX_CHATLOG_LINES )
	string varName = format( "chatlog%02d", index )
	RuiSetString( rui, varName, text )
}

void function UpdateIfNewMusicTrack( string alias )
{
	if ( alias.len() == 0 )
		return
	if ( s_latestMusicTrack == alias )
		return

	s_latestMusicTrack = alias
	PlayCustomUIMusic( alias )
}

void function UpdateIfNewAmbientTrack( string alias )
{
	if ( alias.len() == 0 )
		return
	if ( s_latestAmbientTrack == alias )
		return

	if ( s_latestAmbientTrack.len() > 0 )
		StopUISound( s_latestAmbientTrack )
	s_latestAmbientTrack = alias
	EmitUISound( alias )
}

void function UpdateIfNewLoopingTrack_( string alias, int idx )
{
	if ( alias.len() == 0 )
		return
	if ( s_latestLoopingTracks[idx] == alias )
		return

	if ( s_latestLoopingTracks[idx].len() > 0 )
		StopUISound( s_latestLoopingTracks[idx] )
	s_latestLoopingTracks[idx] = alias
	EmitUISound( alias )
}
void function UpdateIfNewLoopingTrackA( string alias )
{
	UpdateIfNewLoopingTrack_( alias, 0 )
}
void function UpdateIfNewLoopingTrackB( string alias )
{
	UpdateIfNewLoopingTrack_( alias, 1 )
}
void function UpdateIfNewLoopingTrackC( string alias )
{
	UpdateIfNewLoopingTrack_( alias, 2 )
}

void function StopLoopingTrack_( int idx )
{
	if ( s_latestLoopingTracks[idx].len() == 0 )
		return
	StopUISound( s_latestLoopingTracks[idx] )
	s_latestLoopingTracks[idx] = ""
}
void function StopLoopingTrackA()
{
	StopLoopingTrack_( 0 )
}
void function StopLoopingTrackB()
{
	StopLoopingTrack_( 1 )
}
void function StopLoopingTrackC()
{
	StopLoopingTrack_( 2 )
}


string s_latestMusicTrack
string s_latestAmbientTrack
string[3] s_latestLoopingTracks
int s_chatlogProgress = 0
void function SetUpNewPage( int pageIndex )
{
	s_pageIndex = pageIndex

	var rui = Hud_GetRui( Hud_GetChild( s_menu, "LoreReaderScreen" ) )

	LorePage page = s_pages[pageIndex]
	foreach ( int slot, SpeakerLine line in page.speakers )
	{
		if ( line.textLine.len() > 0 )
		{
			SetCharacterInfoForSlot( rui, slot, line.character, line.portrait )
			SetTextLineForSlot( rui, slot, line.textLine, line.character )
		}
		else
		{
			ClearCharacterInfoSlot( rui, slot )
			SetTextLineForSlot( rui, slot, "", "" )
		}
	}

	SetNarratorInfo( rui, page.narratorName, page.narratorPortrait )

	RuiSetBool( rui, "doFadeOut", false )

	string titleText = ""
	if ( (page.titleText.len() > 0) && (page.subTitleText.len() > 0) )
		titleText = Localize( "#LORE_TITLETEXT_FORMAT_WITH_SUBTITLE", Localize( page.titleText ), Localize( page.subTitleText ) )
	else if ( (page.titleText.len() > 0) && (page.subTitleText.len() == 0) )
		titleText = Localize( "#LORE_TITLETEXT_FORMAT_NO_SUBTITLE", Localize( page.titleText ) )
	else if ( page.subTitleText.len() > 0 )
		titleText = Localize( "#LORE_TITLETEXT_FORMAT_ONLY_SUBTITLE", Localize( page.subTitleText ) )
	RuiSetString( rui, "titleText", titleText )

	RuiSetString( rui, "dataText", page.dataText )

	s_chatlogProgress = 0
	for ( int idx = 0; idx < MAX_CHATLOG_LINES; ++idx )
		SetChatlogText( rui, idx, "" )

	if ( page.backgroundRef.len() > 0 )
		UpdateBackgroundLoadscreen( page.backgroundRef )

	          
	{
		foreach ( sound in page.sounds.stopSounds )
			StopUISound( sound )
		if ( page.sounds.doStopLoopingSoundA )
			StopLoopingTrackA()
		if ( page.sounds.doStopLoopingSoundB )
			StopLoopingTrackB()
		if ( page.sounds.doStopLoopingSoundC )
			StopLoopingTrackC()

		foreach ( sound in page.sounds.playSounds[eSoundTiming.PAGE_OPEN] )
			EmitUISound( sound )
		UpdateIfNewMusicTrack( page.sounds.musicTrack )
		UpdateIfNewAmbientTrack( page.sounds.ambientTrack )
		UpdateIfNewLoopingTrackA( page.sounds.playLoopingSoundA[eSoundTiming.PAGE_OPEN] )
		UpdateIfNewLoopingTrackB( page.sounds.playLoopingSoundB[eSoundTiming.PAGE_OPEN] )
		UpdateIfNewLoopingTrackC( page.sounds.playLoopingSoundC[eSoundTiming.PAGE_OPEN] )
	}

	s_visStep = GetNextPageStep( ePageStep.BLANK, s_pages[pageIndex] )
	HandleNewPageStep( s_visStep, s_pages[pageIndex] )
	RuiSetInt( rui, "visStep", s_visStep )
	RuiSetInt( rui, "pageNumber", pageIndex )
	RuiSetInt( rui, "pageNumberCount", s_pages.len() )

	                                                                                                                          
	{
		string topCharacter = page.speakers[0].character
		string bottomCharacter = page.speakers[2].character
		bool instantTop = ((topCharacter.len() > 0) && (topCharacter == s_prevTopCharacter))
		bool instantBottom = ((bottomCharacter.len() > 0) && (bottomCharacter == s_prevBottomCharacter) && (page.speakers[0].textLine.len() == 0) && (page.speakers[1].textLine.len() == 0))
		RuiSetBool( rui, "topPortraitInstantShow", instantTop )
		RuiSetBool( rui, "bottomPortraitInstantShow", instantBottom )
		s_prevTopCharacter = topCharacter
		s_prevBottomCharacter = bottomCharacter
	}
}

string s_prevTopCharacter
string s_prevBottomCharacter
float s_lastScreenOpenTime
int s_screenOpenNumber = -1
int s_visStep = ePageStep.BLANK
int s_pageIndex
void function OnClickedToAdvance( bool isForward )
{
	const float SCREEN_OPEN_LOCKOUT_TIME = 0.5
	if ( (UITime() - s_lastScreenOpenTime) < SCREEN_OPEN_LOCKOUT_TIME )
		return

	var rui = Hud_GetRui( Hud_GetChild( s_menu, "LoreReaderScreen" ) )

	int wantPageIndex = s_pageIndex
	int currentPanelIndex = s_pageIndex
	int currentVisStep = s_visStep

	if ( isForward )
	{
		LorePage page = s_pages[s_pageIndex]
		if ( (s_visStep == ePageStep.TOP_FADE_IN) && (s_chatlogProgress < page.chatlogText.len() ) )
		{
			SetChatlogText( rui, s_chatlogProgress, page.chatlogText[s_chatlogProgress] )
			++s_chatlogProgress
		}
		else
		{
			s_visStep = GetNextPageStep( s_visStep, page )
			HandleNewPageStep( s_visStep, page )
			if ( s_visStep >= ePageStep.DONE )
			{
				wantPageIndex = (s_pageIndex + 1)
			}
		}
	}
	else
	{
		wantPageIndex = (s_pageIndex - 1)
	}

	if ( wantPageIndex != s_pageIndex )
	{
		if ( wantPageIndex >= s_pages.len() )
		{
			thread function() : (rui)
			{
				RuiSetBool( rui, "doFadeOut", true )
				wait 1.25
				if ( GetActiveMenu() == s_menu )
					CloseActiveMenu()
			}()
			return
		}

		SetUpNewPage( wantPageIndex )
	}


	{
		                
		if ( wantPageIndex == s_pages.len() - 1 )
		{
			                                                       
			AddQuestTextPinEvent( -1, -1, currentPanelIndex, currentVisStep )
		}
		else
		{
			AddQuestTextPinEvent( wantPageIndex, s_visStep, currentPanelIndex, currentVisStep )
		}
	}

	RuiSetInt( rui, "visStep", s_visStep )
	UpdateOptInFooter()
}

struct LoreCharacterInfo
{
	asset portraitImage = $""
	string nameText = ""
	bool isNPC = false
}
LoreCharacterInfo function GetLoreCharacterInfoForName( string nameRaw )
{
	LoreCharacterInfo info

	string name = nameRaw.tolower()

	string itemRef = format( "character_%s", name )
	if ( IsValidItemFlavorHumanReadableRef( itemRef ) )
	{
		ItemFlavor character = GetItemFlavorByHumanReadableRef( itemRef )

		info.portraitImage = CharacterClass_GetCharacterLockedPortrait( character )
		info.nameText = Localize( ItemFlavor_GetLongName( character ) ).toupper()
	}
	else if ( name == "yoko" )
	{
		info.portraitImage = $"rui/menu/quest/lore_page/lore_page_portrait_waveform"
		info.nameText = "#QUEST05_STORY_NPC_YOKO"
		info.isNPC = true
	}
	else if ( name == "leigh" )
	{
		info.nameText = "#QUEST11_STORY_NPC_LEIGH"
		info.isNPC = true
	}
	else if ( name == "duardo" )
	{
		info.nameText = "#QUEST12_STORY_NPC_DUARDO"
		info.isNPC = true
	}
	else if ( name == "????" )
	{
		info.portraitImage = $"rui/menu/quest/lore_page/lore_page_portrait_waveform"
		info.nameText = "#QUEST11_STORY_NPC_WAVEFORM_UNKNOWN"
		info.isNPC = true
	}
	else if ( name == "mercenary" )
	{
		info.portraitImage = $"rui/menu/quest/lore_page/lore_page_portrait_waveform"
		info.nameText = "#QUEST13_STORY_NPC_MERCENARY"
		info.isNPC = true
	}
	else if ( name == "mila" )
	{
		info.nameText = "#QUEST14_STORY_NPC_MILA"
		info.isNPC = true
	}
	else if ( name == "headmercenary" )
	{
		info.nameText = "#QUEST13_STORY_NPC_HEADMERCENARY"
		info.isNPC = true
	}
	else if ( name == "partygoer" )
	{
		info.portraitImage = $"rui/menu/quest/lore_page/lore_page_portrait_waveform"
		info.nameText = "#QUEST13_STORY_NPC_PARTY_GOER"
		info.isNPC = true
	}
	else if ( name == "vendor" )
	{
		info.portraitImage = $"rui/menu/quest/lore_page/lore_page_portrait_waveform"
		info.nameText = "#QUEST13_STORY_NPC_VENDOR"
		info.isNPC = true
	}
	else if ( name == "lamont" )
	{
		info.nameText = "#QUEST13_STORY_NPC_LAMONT"
		info.isNPC = true
	}
	else
	{
		info.portraitImage = $"white"
		info.nameText = format( "Unk:'%s'", name )
	}

	return info
}

void function SetCharacterInfoForSlot( var rui, int slot, string speakerName, asset speakerPortrait = $""  )
{
	bool isNPC = false

	speakerName = speakerName.tolower()
	if ( speakerName == "" )
	{
		ClearCharacterInfoSlot( rui, slot )
		return
	}

	LoreCharacterInfo info = GetLoreCharacterInfoForName( speakerName )

	asset portraitImage = speakerPortrait
	if( speakerPortrait == $"" )
		portraitImage = info.portraitImage

	switch ( slot )
	{
		case eSlot.TOP:
			RuiSetBool( rui, "topPortraitEnabled", true )
			RuiSetImage( rui, "topPortraitButtonImage", portraitImage )
			RuiSetString( rui, "topPortraitButtonText", info.nameText )
			RuiSetBool( rui, "topPortraitIsNPC", info.isNPC )
			break
		case eSlot.CENTER:
			break
		case eSlot.BOTTOM:
			RuiSetBool( rui, "bottomPortraitEnabled", true )
			RuiSetImage( rui, "bottomPortraitButtonImage", portraitImage )
			RuiSetString( rui, "bottomPortraitButtonText", info.nameText )
			RuiSetBool( rui, "bottomPortraitIsNPC", info.isNPC )
			break
	}
}
void function ClearCharacterInfoSlot( var rui, int slot )
{
	switch ( slot )
	{
		case eSlot.TOP:
			RuiSetBool( rui, "topPortraitEnabled", false )
			break
		case eSlot.CENTER:
			break
		case eSlot.BOTTOM:
			RuiSetBool( rui, "bottomPortraitEnabled", false )
			break
	}
}

void function SetTextLineForSlot( var rui, int slot, string textLine, string speakerName )
{
	bool shouldBeQuoted = true
	if ( (speakerName == "") || (speakerName == "narrator") )
		shouldBeQuoted = false

	switch ( slot )
	{
		case eSlot.TOP:
			RuiSetString( rui, "topText", textLine )
			RuiSetBool( rui, "topTextDoQuote", shouldBeQuoted )
			break
		case eSlot.CENTER:
			RuiSetString( rui, "centerText", textLine )
			RuiSetBool( rui, "centerTextDoQuote", shouldBeQuoted )
			break
		case eSlot.BOTTOM:
			RuiSetString( rui, "bottomText", textLine )
			RuiSetBool( rui, "bottomTextDoQuote", shouldBeQuoted )
			break
	}
}

void function SetNarratorInfo( var rui, string narratorName, asset narratorPortrait = $"" )
{
	if ( narratorName == "" )
	{
		RuiSetImage( rui, "narratorPortraitImage", $"" )
		RuiSetBool( rui, "narratorPortraitEnabled", false )
		return
	}
	LoreCharacterInfo info = GetLoreCharacterInfoForName( narratorName )

	asset portraitImage = narratorPortrait
	if( narratorPortrait == $"" )
		portraitImage = info.portraitImage

	RuiSetImage( rui, "narratorPortraitImage", portraitImage )
	RuiSetBool( rui, "narratorPortraitEnabled", true )
}


void function AddQuestTextPinEvent( int pageIndex, int panelIndex, int previousPageIndex, int previousPanelIndex )
{
	if ( !IsConnected() )
		return

	int seasonNum     = GetActiveSeasonNumber()
	string currentID  = pageIndex == -1 ? "none" : format( "s%d_pg%d_panel%d", seasonNum, pageIndex, panelIndex )
	string previousID = previousPageIndex == -1 ? "none" : format( "s%d_pg%d_panel%d", seasonNum, previousPageIndex, previousPanelIndex )

	float timeToRead = UITime() - file.pin_viewStartTime
	PIN_QuestTextView( currentID, previousID, timeToRead )

	file.pin_viewStartTime = UITime()
}

