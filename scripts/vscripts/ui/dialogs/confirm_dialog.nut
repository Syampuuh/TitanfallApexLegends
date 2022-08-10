global function InitConfirmDialog
global function InitOKDialog
global function InitTextEntryDialog

global function OpenConfirmDialogFromData
global function OpenABDialogFromData
global function OpenOKDialogFromData
global function OpenTextEntryDialogFromData

const float CONFIRMATION_DELAY_WAIT = 0.2

enum eDialogType
{
	CONFIRM,
	AB,
	OK,
	TEXT_ENTRY
}

global enum eDialogResult
{
	CANCEL
	YES
	NO
}

struct
{
	var confirmMenu
	var okMenu
	var textEntryMenu
	var contentRui
	float openedAt

	ConfirmDialogData ornull showDialogData
	array<ConfirmDialogData> showDialogDataQueue
} file

void function InitConfirmDialog( var newMenuArg )                                               
{
	var menu = GetMenu( "ConfirmDialog" )
	file.confirmMenu = menu

	SetDialog( menu, true )
	SetGamepadCursorEnabled( menu, false )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, Dialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, ConfirmDialog_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, ConfirmDialog_OnNavigateBack )

#if DEV
	AddMenuThinkFunc( newMenuArg, ConfirmDialogAutomationThink )
#endif       
}


void function InitOKDialog( var newMenuArg )                                               
{
	var menu = GetMenu( "OKDialog" )
	file.okMenu = menu

	SetDialog( menu, true )
	SetGamepadCursorEnabled( menu, false )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, Dialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, ConfirmDialog_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, ConfirmDialog_OnNavigateBack )

#if DEV
	AddMenuThinkFunc( newMenuArg, ConfirmDialogAutomationThink )
#endif       
}

void function InitTextEntryDialog( var menu )
{
	file.textEntryMenu = menu

	SetDialog( menu, true )
	SetGamepadCursorEnabled( menu, true )
	SetAllowControllerFooterClick( menu, true )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, Dialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, ConfirmDialog_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, ConfirmDialog_OnNavigateBack )

#if DEV
	AddMenuThinkFunc( menu, ConfirmDialogAutomationThink )
#endif       
}


void function OpenConfirmDialogFromData( ConfirmDialogData dialogData )
{
	Assert( dialogData.resultCallback != null, "resultCallback == null; this dialog won't do anything" )

	dialogData.dialogType = eDialogType.CONFIRM
	dialogData.__menu = file.confirmMenu
	TryShowDialog( dialogData )
}


void function OpenABDialogFromData( ConfirmDialogData dialogData )
{
	Assert( dialogData.resultCallback != null, "resultCallback == null; this dialog won't do anything" )

	dialogData.dialogType = eDialogType.AB
	dialogData.__menu     = file.confirmMenu
	TryShowDialog( dialogData )
}


void function OpenOKDialogFromData( ConfirmDialogData dialogData )
{
	dialogData.dialogType = eDialogType.OK
	dialogData.__menu = file.okMenu
	TryShowDialog( dialogData )
}

void function OpenTextEntryDialogFromData( ConfirmDialogData dialogData, void functionref( string ) textConfirmationCallback )
{
	void functionref( int ) resultCallback = dialogData.resultCallback

	dialogData.dialogType = eDialogType.TEXT_ENTRY
	dialogData.__menu = file.textEntryMenu
	dialogData.resultCallback = void function( int result ) : ( resultCallback, textConfirmationCallback )
	{
		if ( result == eDialogResult.YES )
			textConfirmationCallback( Hud_GetUTF8Text( Hud_GetChild( file.textEntryMenu, "TextEntry" ) ) )

		if ( resultCallback != null )
			resultCallback( result )
	}
	TryShowDialog( dialogData )
}

void function TryShowDialog( ConfirmDialogData dialogData )
{
	ConfirmDialogData ornull active = file.showDialogData
	if ( file.showDialogData == null )
	{
		file.showDialogData = dialogData
		AdvanceDialogMenu( dialogData )
	}
	else
	{
		file.showDialogDataQueue.push(dialogData)
	}
}

void function DelayConfirmationCallback( InputDef input )
{
	float enableAfter = file.openedAt + _confirmData().dialogConfirmDelay
	do {
		float remaining = enableAfter - UITime()
		input.clickable = remaining <= 0.0
		if ( !input.clickable )
		{
			Hud_SetText( input.vguiElem, string( ceil( remaining ) ) )
			wait CONFIRMATION_DELAY_WAIT
		}
	} while( !input.clickable )

	input.updateFunc = null
	UpdateFooterLabels()
}

void function Dialog_OnOpen()
{
	Assert( file.showDialogData != null )
	file.openedAt = UITime()

	ClearMenuFooterOptions( _confirmData().__menu )
	var contentRui = Hud_GetRui( Hud_GetChild( _confirmData().__menu, "ContentRui" ) )
	RuiSetString( contentRui, "headerText", _confirmData().headerText )
	RuiSetString( contentRui, "messageText", _confirmData().messageText )
	RuiSetAsset( contentRui, "contextImage", _confirmData().contextImage )

	                                                                                                 
	RuiSetFloat( contentRui, "delayPenaltyWarnTime", _confirmData().timePenaltyWarning )
	RuiSetGameTime( contentRui, "endTime", _confirmData().timerEndTime )

	switch ( _confirmData().dialogType )
	{
		case eDialogType.CONFIRM:
			bool clickable                          = _confirmData().dialogConfirmDelay <= 0.0
			void functionref( InputDef ) updateFunc = clickable ? null : DelayConfirmationCallback

			AddMenuFooterOption( _confirmData().__menu, LEFT, BUTTON_A, clickable, _confirmData().yesText[0], _confirmData().yesText[1], ConfirmDialog_Yes, null, updateFunc )
			AddMenuFooterOption( _confirmData().__menu, LEFT, BUTTON_B, true, _confirmData().noText[0], _confirmData().noText[1], ConfirmDialog_No )
			break
		case eDialogType.AB:
		case eDialogType.TEXT_ENTRY:
			AddMenuFooterOption( _confirmData().__menu, LEFT, BUTTON_X, true, _confirmData().yesText[0], _confirmData().yesText[1], ConfirmDialog_Yes )
			AddMenuFooterOption( _confirmData().__menu, LEFT, BUTTON_Y, true, _confirmData().noText[0], _confirmData().noText[1], ConfirmDialog_No )
			break
		default:
			if ( _confirmData().yesText[0] != "" )
				AddMenuFooterOption( _confirmData().__menu, LEFT, BUTTON_B, true, _confirmData().okText[0], _confirmData().okText[1], ConfirmDialog_Yes )
			break
	}
}

#if DEV
void function ConfirmDialogAutomationThink( var menu )
{
	if (AutomateUi())
	{
		printt("ConfirmDialogAutomationThink ConfirmDialog_Yes()")
		ConfirmDialog_Yes(null)
	}
}
#endif       


ConfirmDialogData function _confirmData()
{
	Assert( file.showDialogData != null )
	return expect ConfirmDialogData( file.showDialogData )
}


void function ConfirmDialog_OnClose()
{
	file.showDialogData = null
	CheckQueue()
}


void function ConfirmDialog_OnNavigateBack()
{
	ConfirmDialogData confirmData = _confirmData()
	CloseActiveMenu()
	if ( confirmData.resultCallback != null )
		confirmData.resultCallback( eDialogResult.CANCEL )
}


void function ConfirmDialog_Yes( var button )
{
	                                                                                                     
	if ( file.showDialogData == null )
		return

	ConfirmDialogData confirmData = _confirmData()

	if ( confirmData.extendedUseYes )
	{
		var holdToUseElem = Hud_GetChild( confirmData.__menu, "HoldToUseElem" )
		bool requiresButtonFocus = false
		float duration = 1.2
		StartMenuExtendedUse( button, holdToUseElem, duration, requiresButtonFocus, void function( bool success ) : ( button ) {
			if ( success )
				ConfirmDialog_Yes_PassThrough( button )
		} )
	}
	else
	{
		ConfirmDialog_Yes_PassThrough( button )
	}
}

void function ConfirmDialog_Yes_PassThrough( var button )
{
	                                                                                                     
	if ( file.showDialogData == null )
		return

	ConfirmDialogData confirmData = _confirmData()

	var menu = GetActiveMenu()
	if ( GetActiveMenu() == confirmData.__menu )
		CloseActiveMenu()

	if ( confirmData.resultCallback != null )
		confirmData.resultCallback( eDialogResult.YES )
}


void function ConfirmDialog_No( var button )
{
	                                                                                                     
	if ( file.showDialogData == null )
		return

	ConfirmDialogData confirmData = _confirmData()
	if ( GetActiveMenu() == confirmData.__menu )
		CloseActiveMenu()

	if ( confirmData.resultCallback != null )
		confirmData.resultCallback( eDialogResult.NO )
}

void function CheckQueue()
{
	if ( file.showDialogDataQueue.len() > 0 )
	{
		ConfirmDialogData poppedData = file.showDialogDataQueue.remove(0)
		file.showDialogData = poppedData
		AdvanceDialogMenu( poppedData )
	}
}

void function AdvanceDialogMenu( ConfirmDialogData dialogData )
{
	switch ( dialogData.dialogType )
	{
		case eDialogType.OK:
			AdvanceMenu( GetMenu( "OKDialog" ) )
			break
		case eDialogType.AB:
			AdvanceMenu( GetMenu( "ConfirmDialog" ) )
			break
		case eDialogType.CONFIRM:
			AdvanceMenu( GetMenu( "ConfirmDialog" ) )
			break
		case eDialogType.TEXT_ENTRY:
			Hud_SetUTF8Text( Hud_GetChild( file.textEntryMenu, "TextEntry" ), "" )
			AdvanceMenu( GetMenu( "TextEntryDialog" ) )
			break
		default:
			Warning( "Unknown Dialog type" )
			break
	}
}