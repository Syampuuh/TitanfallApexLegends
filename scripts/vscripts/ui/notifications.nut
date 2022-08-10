global function ShowNotification
global function InitNotificationsMenu

struct
{
	var menu
	var notificationBoxRui
} file

global string fakeBackEndError = ""
void function ShowNotification()
{
	BackendError backendError = GetBackendError()
	#if DEV
		if ( fakeBackEndError != "" )
		{
			backendError.errorString = fakeBackEndError
			fakeBackEndError = ""
		}
	#endif
	if ( backendError.errorString == "" && IsViewingNotification() )
		return

	if ( backendError.errorString != "" )
	{
		                                                                 
		thread ShowNotificationForABit( "#NOTIFICATION", backendError.errorString )

		if ( !IsLobby() && IsFullyConnected() )
			RunClientScript( "UIToClient_Notification", "#NOTIFICATION", backendError.errorString )
	}
	else
	{
		Hud_Hide( file.menu )
	}
}


void function ShowNotificationForABit( string titleText, string messageText )
{
	EndSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )

	RuiSetString( file.notificationBoxRui, "titleText", titleText )
	RuiSetString( file.notificationBoxRui, "messageText", messageText )
	
	#if NX_PROG
		RuiSetFloat( file.notificationBoxRui, "ifSwitch", 1.0 )
	#endif
	
	Hud_Show( file.menu )

	OnThreadEnd(
		function() : ()
		{
			Hud_Hide( file.menu )
			ShowNotification()
		}
	)

	float notificationWaitTime = GetConVarFloat( "notification_displayTime" )
	                                                                                       
	wait notificationWaitTime
	                                                                                            
}


bool function IsViewingNotification()
{
	return Hud_IsVisible( file.menu )
}


void function InitNotificationsMenu( var newMenuArg )                                               
{
	file.menu = GetMenu( "Notifications" )

	Hud_Hide( file.menu )
	Hud_SetAboveBlur( file.menu, true )
	file.notificationBoxRui = Hud_GetRui( Hud_GetChild( file.menu, "NotificationBox" ) )

	Assert( !IsViewingNotification() )
}
