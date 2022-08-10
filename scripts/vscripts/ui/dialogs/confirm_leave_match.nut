global function InitConfirmLeaveMatchDialog
global function ConfirmLeaveMatchDialog_Open
global function ConfirmLeaveMatchDialog_SetPlayerCanBeRespawned

struct
{
	var menu
	var contentRui
	bool playerCanBeRespawned
	bool penaltyMayBeActive
	int penaltyLength
	bool hasShownRespawnWarningString
	float nextAllowCloseTime
	float nextAllowConfirmTime
	string warningString = "#ARE_YOU_SURE_YOU_WANT_TO_LEAVE"
} file

void function InitConfirmLeaveMatchDialog( var newMenuArg )                                               
{
	var menu = GetMenu( "ConfirmLeaveMatchDialog" )
	file.menu = menu

	SetDialog( menu, true )
	SetGamepadCursorEnabled( menu, false )

	file.contentRui = Hud_GetRui( Hud_GetChild( file.menu, "ContentRui" ) )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, ConfirmLeaveMatchDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, ConfirmLeaveMatchDialog_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, ConfirmLeaveMatchDialog_OnNavigateBack )

	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_YES", "#YES", Confirm )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CANCEL", "#B_BUTTON_CANCEL" )
}

void function Confirm( var button )
{
	if ( UITime() < file.nextAllowConfirmTime )
		return

	if ( IsFullyConnected() )
	{
		RunClientScript( "UICallback_QueryPlayerCanBeRespawned" )

		if ( file.playerCanBeRespawned && !file.hasShownRespawnWarningString )
		{
			file.nextAllowConfirmTime = UITime() + 0.5               
			file.hasShownRespawnWarningString = true
			EmitUISound( "ui_ingame_markedfordeath_playermarked" )
			SetWarningString( "#YOU_CAN_STILL_BE_RESPAWNED" )
			return
		}
	}

	if ( GetActiveMenu() == file.menu )
		CloseActiveMenu()

	LeaveMatchWithDialog()
}

void function ConfirmLeaveMatchDialog_OnOpen()
{
	SetWarningString( file.warningString )
}

void function ConfirmLeaveMatchDialog_OnClose()
{
}

void function ConfirmLeaveMatchDialog_SetPlayerCanBeRespawned( bool playerCanBeRespawned, bool penaltyMayBeActive, int penaltyLength )
{
	file.playerCanBeRespawned = playerCanBeRespawned
	file.penaltyMayBeActive = penaltyMayBeActive
	file.penaltyLength = penaltyLength
}

void function SetWarningString( string newStr )
{
	file.warningString = newStr
	RuiSetString( file.contentRui, "headerText", Localize( file.warningString ).toupper() )
}

void function ConfirmLeaveMatchDialog_Open()
{
	RunClientScript( "UICallback_QueryPlayerCanBeRespawned" )

	ConfirmDialogData data
	data.headerText = "#LEAVE_MATCH"

	if ( file.playerCanBeRespawned )
	{
		if ( file.penaltyMayBeActive )
		{
			data.messageText = "#YOU_CAN_STILL_BE_RESPAWNED_LEAVE_PENALTY"
			data.extendedUseYes = true
			data.yesText = ["#A_BUTTON_HOLD_YES", "#HOLD_YES"]
			data.timePenaltyWarning = float( file.penaltyLength )
		}
		else
		{
			data.messageText = "#YOU_CAN_STILL_BE_RESPAWNED"
		}

		data.contextImage = $"rui/hud/gametype_icons/survival/dna_station"
	}
	else if ( file.penaltyMayBeActive )
	{
		data.messageText = "#ARE_YOU_SURE_YOU_WANT_TO_LEAVE_PENALTY"
		data.extendedUseYes = true
		data.yesText = ["#A_BUTTON_HOLD_YES", "#HOLD_YES"]
		data.timePenaltyWarning = float( file.penaltyLength )
	}
	else if ( IsSurvivalTraining() || IsFiringRangeGameMode() )
	{
		data.headerText = "#RETURN_TO_LOBBY"
		data.messageText = "#LEAVE_QUESTION"
	}
	else if ( IsPVEMode() )
	{
		data.headerText = "#QUEST_LEAVE_MATCH"
		data.messageText = "#QUEST_LEAVE_ARE_YOU_SURE"
	}
	else
	{
		data.messageText = "#ARE_YOU_SURE_YOU_WANT_TO_LEAVE"
	}

	data.resultCallback = OnLeaveMatchDialogResult

	OpenConfirmDialogFromData( data )
}


void function OnLeaveMatchDialogResult( int result )
{
	if ( result != eDialogResult.YES )
	{
#if PS5_PROG
		                                                                 
		RunClientScript( "ClientCodeCallback_LeaveMatch_SetCancelled" )
#endif

		file.nextAllowCloseTime = UITime() + 0.1
		return
	}

#if PS5_PROG
	                                                         
	RunClientScript( "ClientCodeCallback_LeaveMatch_SetConfirmed" )
#endif

	LeaveMatchWithDialog()
}


void function ConfirmLeaveMatchDialog_OnNavigateBack()
{
	file.nextAllowCloseTime = UITime() + 0.1
	CloseActiveMenu()
}
