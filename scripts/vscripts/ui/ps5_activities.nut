#if PS5_PROG


#if CLIENT
global function ClientCodeCallback_LeaveMatch
global function ClientCodeCallback_LeaveMatch_Reset_Values
global function ClientCodeCallback_LeaveMatch_SetConfirmed
global function ClientCodeCallback_LeaveMatch_SetCancelled
global function ClientCodeCallback_LeaveMatch_IsConfirmed
global function ClientCodeCallback_LeaveMatch_IsCancelled
global function ClientCodeCallback_IsGameOver
global bool bClientCodeCallback_LeaveMatch_WasConfirmed = false
global bool bClientCodeCallback_LeaveMatch_WasCancelled = false
global function ClientCodeCallback_LeavePartyDialog
global function ClientCodeCallback_LeavePartyDialog_Reset_Values
global function ClientCodeCallback_LeavePartyDialog_SetConfirmed
global function ClientCodeCallback_LeavePartyDialog_SetCancelled
global function ClientCodeCallback_LeavePartyDialog_IsConfirmed
global function ClientCodeCallback_LeavePartyDialog_IsCancelled
global bool bClientCodeCallback_LeavePartyDialog_WasConfirmed = false
global bool bClientCodeCallback_LeavePartyDialog_WasCancelled = false


void function ClientCodeCallback_LeaveMatch()
{
	RunUIScript( "ConfirmLeaveMatchDialog_Open" )
}

void function ClientCodeCallback_LeaveMatch_Reset_Values()
{
	bClientCodeCallback_LeaveMatch_WasConfirmed = false
	bClientCodeCallback_LeaveMatch_WasCancelled = false
}

void function ClientCodeCallback_LeaveMatch_SetConfirmed()
{
	bClientCodeCallback_LeaveMatch_WasConfirmed = true
}

void function ClientCodeCallback_LeaveMatch_SetCancelled()
{
	bClientCodeCallback_LeaveMatch_WasCancelled = true
}

bool function ClientCodeCallback_LeaveMatch_IsConfirmed()
{
	return bClientCodeCallback_LeaveMatch_WasConfirmed
}

bool function ClientCodeCallback_LeaveMatch_IsCancelled()
{
	return bClientCodeCallback_LeaveMatch_WasCancelled
}

void function ClientCodeCallback_LeavePartyDialog()
{
	RunUIScript( "LeavePartyDialog" )
}

void function ClientCodeCallback_LeavePartyDialog_Reset_Values()
{
	bClientCodeCallback_LeavePartyDialog_WasConfirmed = false
	bClientCodeCallback_LeavePartyDialog_WasCancelled = false
}

void function ClientCodeCallback_LeavePartyDialog_SetConfirmed()
{
	bClientCodeCallback_LeavePartyDialog_WasConfirmed = true
}

void function ClientCodeCallback_LeavePartyDialog_SetCancelled()
{
	bClientCodeCallback_LeavePartyDialog_WasCancelled = true
}

bool function ClientCodeCallback_LeavePartyDialog_IsConfirmed()
{
	return bClientCodeCallback_LeavePartyDialog_WasConfirmed
}

bool function ClientCodeCallback_LeavePartyDialog_IsCancelled()
{
	return bClientCodeCallback_LeavePartyDialog_WasCancelled
}

bool function ClientCodeCallback_IsGameOver()
{
	return GetGameState() > eGameState.WinnerDetermined
}

#endif

#if UI
global function UICodeCallback_ShouldEnableActivities

bool function UICodeCallback_ShouldEnableActivities()
{
	return IsTrainingCompleted() || IsExemptFromTraining()
}
#endif

#endif