untyped

global function InitDialogCommon
global function InitDialogMenu
global function InitDataCenterDialogMenu
global function SCBUI_PlayerConnectedOrDisconnected
global function LeaveMatchWithDialog
global function CancelMatchSearch
global function CancelRestartingMatchmaking
global function UpdateDialogFooterVisibility

global function OpenDialog
global function OpenDataCenterDialog
global function ShowMatchConnectDialog
global function LeaveDialog
global function LeavePartyDialog
global function OpenClubLeaveDialog
global function EndMatchDialog
                      
global function LeaveCustomMatchDialog
      

global function AddDialogButton
global function AddDialogButtonEx
global function AddDialogFooter
global function AddDialogPCBackButton

struct
{
	array<DialogButtonData> dialogButtonData
} file


void function InitDialogCommon( var menu )
{
	SetDialog( menu, true )

	array<var> msgElems = GetElementsByClassname( menu, "DialogMessageClass" )
	foreach ( elem in msgElems )
		Hud_EnableKeyBindingIcons( elem )

	if ( Hud_HasChild( menu, "DialogHeader" ) )
		Hud_EnableKeyBindingIcons( Hud_GetChild( menu, "DialogHeader" ) )

	AddEventHandlerToButtonClass( menu, "DialogButtonClass", UIE_GET_FOCUS, OnDialogButton_Focused )
	AddEventHandlerToButtonClass( menu, "DialogButtonClass", UIE_CLICK, OnDialogButton_Activate )

	InitDialogFooterButtons( menu )
}


void function InitDialogMenu( var newMenuArg )                                               
{
	var menu = GetMenu( "Dialog" )

	InitDialogCommon( menu )
	uiGlobal.menuData[ menu ].isDynamicHeight = true
}


void function InitDataCenterDialogMenu( var newMenuArg )                                               
{
	var menu = GetMenu( "DataCenterDialog" )

	InitDialogCommon( menu )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnDataCenterDialog_Close )
	AddEventHandlerToButton( menu, "ListDataCenters", UIE_CLICK, OnDataCenterButton_Activate )
}


void function InitDialogFooterButtons( var menu )
{
	var panel        = Hud_GetChild( menu, "DialogFooterButtons" )
	var PCBackButton = Hud_GetChild( panel, "MouseBackFooterButton" )
	Hud_AddEventHandler( PCBackButton, UIE_CLICK, OnBtnBackPressed )
}


void function OnDialogButton_Focused( var button )
{
	int buttonID = int( Hud_GetScriptID( button ) )

	if ( file.dialogButtonData[buttonID].focusMessage != "" )
	{
		var menu = Hud_GetParent( button )

		var messageElem = GetSingleElementByClassname( menu, "DialogMessageClass" )
		if ( messageElem )
			Hud_SetText( messageElem, file.dialogButtonData[buttonID].focusMessage )
	}
}


void function OnDialogButton_Activate( var button )
{
	if ( UITime() < uiGlobal.dialogInputEnableTime )
		return

	int buttonID = int( Hud_GetScriptID( button ) )

	Assert( file.dialogButtonData.len() > 0 )
	DialogButtonData btn = file.dialogButtonData[buttonID]
	if ( btn.isDisabled )
		return

	CloseActiveMenu()

	if ( btn.activateFunc != null )
		btn.activateFunc.call( this )
	else if ( btn.activateFuncEx != null )
		btn.activateFuncEx.call( this, btn.payload )
}

void function OnDataCenterButton_Activate( var button )
{
	printt( "Chose a data center" )
	EmitUISound( "ui_menu_accept" )
	CloseActiveMenu()
}


void function CancelConnect()
{
	MatchmakingCancel()
	Party_LeaveParty()
}


DialogButtonData function AddDialogButton( DialogData dialogData, string label, void functionref() activateFunc = null, string focusMessage = "", bool startFocused = false )
{
	DialogButtonData newButtonData
	newButtonData.label = label
	newButtonData.activateFunc = activateFunc
	newButtonData.focusMessage = focusMessage
	newButtonData.startFocused = startFocused

	dialogData.buttonData.append( newButtonData )
	return newButtonData
}


DialogButtonData function AddDialogButtonEx( DialogData dialogData, string label, void functionref( table payload ) activateFuncEx = null, string focusMessage = "", bool startFocused = false, table payload = {} )
{
	DialogButtonData newButtonData
	newButtonData.label = label
	newButtonData.activateFuncEx = activateFuncEx
	newButtonData.focusMessage = focusMessage
	newButtonData.startFocused = startFocused
	newButtonData.payload = payload

	dialogData.buttonData.append( newButtonData )
	return newButtonData
}


void function AddDialogFooter( DialogData dialogData, string label )
{
	DialogFooterData newFooterData
	newFooterData.label = label

	dialogData.footerData.append( newFooterData )
}


void function AddDialogPCBackButton( DialogData dialogData )
{
	dialogData.showPCBackButton = true
}


void function DelayedSetFocusThread( var item, var thisMenu )
{
	WaitEndFrame()
	if ( GetActiveMenu() != thisMenu )
		return

	Hud_SetFocused( item )
}


void function OpenDialog( DialogData dialogData )
{
	if ( dialogData.noChoice || dialogData.noChoiceWithNavigateBack )
		dialogData.forceChoice = false

	if ( dialogData.inputDisableTime > 0 )
		uiGlobal.dialogInputEnableTime = UITime() + dialogData.inputDisableTime

	if ( dialogData.menu == null )
	{
		ConfirmDialogData confirmDialogData
		confirmDialogData.headerText = dialogData.header
		confirmDialogData.messageText = dialogData.message
		confirmDialogData.contextImage = dialogData.image

		if ( dialogData.buttonData.len() > 0 )
		{
			confirmDialogData.yesText = [dialogData.buttonData[0].label, dialogData.buttonData[0].label]

			confirmDialogData.resultCallback = void function ( int result ) : ( dialogData )
			{
				if ( dialogData.buttonData.len() != 1 )
				{
					if ( result != eDialogResult.YES )
						return
				}

				if (dialogData.buttonData.len() > 0 && dialogData.buttonData[0].activateFunc != null )
					dialogData.buttonData[0].activateFunc()
			}

			if ( dialogData.buttonData.len() < 2 )
				OpenOKDialogFromData( confirmDialogData )
			else
				OpenConfirmDialogFromData( confirmDialogData )
		}
		else
		{
			if ( dialogData.noChoice )
			{
				confirmDialogData.yesText = ["", ""]
				confirmDialogData.noText = ["", ""]
			}

			OpenOKDialogFromData( confirmDialogData )
		}
		return
	}

	var menu = GetMenu( "Dialog" )
	if ( dialogData.menu != null )
		menu = dialogData.menu

	var frameElem = Hud_GetChild( menu, "DialogFrame" )
	RuiSetImage( Hud_GetRui( frameElem ), "basicImage", $"rui/menu/common/dialog_gradient" )
	RuiSetFloat3( Hud_GetRui( frameElem ), "basicImageColor", <1, 1, 1> )

	                                                        
	if ( Hud_HasChild( menu, "DialogHeader" ) )
		Hud_SetText( Hud_GetChild( menu, "DialogHeader" ), dialogData.header )

	int messageHeight = 0

	var messageElem = GetSingleElementByClassname( menu, "DialogMessageClass" )
	if ( messageElem )
	{
		Hud_SetText( messageElem, dialogData.message )
		Hud_SetColor( messageElem, dialogData.messageColor )

		if ( dialogData.message != "" )
			messageHeight = Hud_GetHeight( messageElem )
	}

	if ( Hud_HasChild( menu, "DarkenBackground" ) )
	{
		if ( dialogData.darkenBackground )
			Hud_Show( Hud_GetChild( menu, "DarkenBackground" ) )
		else
			Hud_Hide( Hud_GetChild( menu, "DarkenBackground" ) )
	}

	var messageRuiElem = GetSingleElementByClassname( menu, "DialogMessageRuiClass" )
	if ( messageRuiElem )
	{
		RuiSetString( Hud_GetRui( messageRuiElem ), "messageText", dialogData.ruiMessage.message )
		RuiSetFloat3( Hud_GetRui( messageRuiElem ), "style1Color", dialogData.ruiMessage.style1Color )
		RuiSetFloat3( Hud_GetRui( messageRuiElem ), "style2Color", dialogData.ruiMessage.style2Color )
		RuiSetFloat3( Hud_GetRui( messageRuiElem ), "style3Color", dialogData.ruiMessage.style3Color )

		RuiSetFloat( Hud_GetRui( messageRuiElem ), "style1FontScale", dialogData.ruiMessage.style1FontScale )
		RuiSetFloat( Hud_GetRui( messageRuiElem ), "style2FontScale", dialogData.ruiMessage.style2FontScale )
		RuiSetFloat( Hud_GetRui( messageRuiElem ), "style3FontScale", dialogData.ruiMessage.style3FontScale )

		var rightImageRuiElem = GetSingleElementByClassname( menu, "DialogRightImageClass" )
		if ( rightImageRuiElem )
		{
			RuiSetImage( Hud_GetRui( rightImageRuiElem ), "basicImage", dialogData.rightImage )
		}

		if ( dialogData.useFullMessageHeight )
			messageHeight = Hud_GetHeight( messageRuiElem )
	}

	var spinnerElem = GetSingleElementByClassname( menu, "DialogSpinnerClass" )
	if ( spinnerElem )
		Hud_SetVisible( spinnerElem, dialogData.showSpinner )

	array<DialogFooterData> footerData

	bool forceNoButtonsOnTheBottom = (dialogData.noChoice || dialogData.noChoiceWithNavigateBack)
	if ( !forceNoButtonsOnTheBottom )
	{
		DialogFooterData defaultFooter1
		defaultFooter1.label = "#A_BUTTON_SELECT"
		footerData.append( defaultFooter1 )

		DialogFooterData defaultFooter2
		defaultFooter2.label = "#B_BUTTON_CANCEL"
		footerData.append( defaultFooter2 )

		if ( dialogData.footerData.len() )
			footerData = dialogData.footerData
	}

	array<DialogButtonData> buttonData = dialogData.buttonData
	array<var> buttons                 = GetElementsByClassname( menu, "DialogButtonClass" )
	int numChoices                     = buttonData.len()
	int numButtons                     = buttons.len()
	Assert( numButtons >= numChoices, "OpenDialog: can't have " + numChoices + " choices for only " + numButtons + " buttons." )

	file.dialogButtonData = buttonData

	int defaultButtonHeight = int( ContentScaledY( 40 ) )
	int buttonsHeight       = defaultButtonHeight * numChoices

	                                                
	foreach ( index, button in buttons )
	{
		var ruiButton = Hud_GetRui( button )

		if ( index < numChoices )
		{
			RuiSetString( ruiButton, "buttonText", file.dialogButtonData[ index ].label )
			if ( index in dialogData.coloredButton )
				RuiSetFloat3( ruiButton, "textColorOverride", <1, 0.7, 0.4> )
			else
				RuiSetFloat3( ruiButton, "textColorOverride", dialogData.buttonData[index].customColor )

			Hud_SetHeight( button, defaultButtonHeight )
			Hud_Show( button )

			if ( file.dialogButtonData[ index ].startFocused )
				thread DelayedSetFocusThread( button, menu )
		}
		else
		{
			Hud_Hide( button )
			Hud_SetHeight( button, 0 )
		}
	}

	                                               
	array<var> ruiFooterElems = GetElementsByClassname( menu, "LeftRuiFooterButtonClass" )
	foreach ( elem in ruiFooterElems )
	{
		int index = int( Hud_GetScriptID( elem ) )

		if ( index < footerData.len() )
		{
			SetFooterText( menu, LEFT, index, Localize( footerData[ index ].label ) )
		}
		else
		{
			Hud_Hide( elem )
		}
	}

	                                
	var dialogFooter = Hud_GetChild( menu, "DialogFooterButtons" )
	var PCBackButton = Hud_GetChild( dialogFooter, "MouseBackFooterButton" )
	if ( dialogData.showPCBackButton )
	{
		Hud_SetText( PCBackButton, Localize( "#BACK" ) )
		Hud_Show( PCBackButton )
	}
	else
	{
		Hud_SetText( PCBackButton, "" )
		Hud_Hide( PCBackButton )
	}

	var imageElem = GetSingleElementByClassname( menu, "DialogImageClass" )
	if ( imageElem )
	{
		if ( dialogData.image != $"" )
		{
			RuiSetImage( Hud_GetRui( imageElem ), "basicImage", dialogData.image )
			Hud_SetVisible( imageElem, true )
		}
		else
		{
			Hud_SetVisible( imageElem, false )
		}
	}

	if ( uiGlobal.menuData[ menu ].isDynamicHeight )
	{
		var dialogFrame          = Hud_GetChild( menu, "DialogFrame" )
		int baseDialogHeight     = int( ContentScaledY( 312 ) )
		int bottomButtonAdjust   = forceNoButtonsOnTheBottom ? int( ContentScaledY( -(BOTTOM_BUTTON_AREA_HEIGHT - BOTTOM_BUTTON_AREA_HEIGHT_WHENDISABLED) ) ) : 0
		int adjustedDialogHeight = baseDialogHeight + messageHeight + buttonsHeight + bottomButtonAdjust
		Hud_SetHeight( dialogFrame, adjustedDialogHeight )
	}

	uiGlobal.menuData[ menu ].dialogData = dialogData
	UpdateDialogFooterVisibility( menu, IsControllerModeActive() )

	AdvanceMenu( menu )

	if ( dialogData.timeoutDuration > 0 )
		thread CloseDialogAfterTimeout( menu, dialogData.timeoutDuration )
}


void function CloseDialogAfterTimeout( var menu, float delay )
{
	wait delay
	if ( GetActiveMenu() == menu )
		CloseActiveMenu()
}

const int BOTTOM_BUTTON_AREA_HEIGHT = 56
const int BOTTOM_BUTTON_AREA_HEIGHT_WHENDISABLED = 20

void function UpdateDialogFooterVisibility( var menu, bool isControllerModeActive )
{
	if ( ShouldUpdateMenuForDialogFooterVisibility( menu ) )
	{
		int defaultHeight              = int( ContentScaledY( BOTTOM_BUTTON_AREA_HEIGHT ) )
		string footerButtonElement     = "DialogFooterButtons"
		var dialogFooter               = Hud_GetChild( menu, footerButtonElement )
		var PCBackButton               = Hud_GetChild( dialogFooter, "MouseBackFooterButton" )
		bool isVisible                 = isControllerModeActive || Hud_IsVisible( PCBackButton )
		DialogData dialogData          = uiGlobal.menuData[ menu ].dialogData
		bool forceNoButtonsOnTheBottom = (dialogData.noChoice || dialogData.noChoiceWithNavigateBack)

		int newHeight = defaultHeight
		if ( !isVisible || forceNoButtonsOnTheBottom )
			newHeight = int( ContentScaledY( BOTTOM_BUTTON_AREA_HEIGHT_WHENDISABLED ) )

		Hud_SetHeight( dialogFooter, newHeight )
	}
}


bool function ShouldUpdateMenuForDialogFooterVisibility( var menu )
{
	if ( menu == GetMenu( "Dialog" ) )
		return true

	return false
}


void function SCBUI_PlayerConnectedOrDisconnected( bool joinSound )
{
	if ( joinSound )
		EmitUISound( "PlayerJoinedLobby" )

	var menu = GetActiveMenu()
	if ( menu == null )
		return

	string menuName = Hud_GetHudName( menu )
	switch ( menuName )
	{
		default:
			break
	}
}


void function LeaveDialog()
{
	if ( !IsFullyConnected() )
		return

	DialogData dialogData
	dialogData.header = "#LEAVE_MATCH"
	dialogData.message = "#ARE_YOU_SURE_YOU_WANT_TO_LEAVE"
	dialogData.noChoiceWithNavigateBack = true
	dialogData.image = $"ui/menu/common/dialog_error"
	dialogData.darkenBackground = true

	  
	{
		if ( IsLobby() )
		{
			if ( IsPrivateMatchLobby() )
			{
				ConfirmLeaveMatchDialog_Open()
				return
			}

			AddDialogButton( dialogData, "#CANCEL_NO" )

			if ( !PartyHasMembers() || AmIPartyLeader() )
			{
				if ( AmIPartyLeader() && PartyHasMembers() )
					AddDialogButton( dialogData, "#YES_LEAVE_PARTY", LeaveParty )
				else
					AddDialogButton( dialogData, "#YES_RETURN_TO_TITLE_MENU", LeaveMatch_Disconnect )
			}
			else
			{
				Assert( PartyHasMembers() )
				Assert( !AmIPartyLeader() )
				AddDialogButton( dialogData, "#YES_LEAVE_PARTY", LeaveParty )
			}
		}
		else
		{
			ConfirmLeaveMatchDialog_Open()
			return
		}
	}

	OpenDialog( dialogData )
}


void function LeavePartyDialog()
{
	if ( !IsFullyConnected() )
		return

	if ( !AmIPartyMember() && !AmIPartyLeader() )
		return

	ConfirmDialogData data
	data.headerText = "#LEAVE_PARTY"
	data.messageText = "#LEAVE_PARTY_DESC"
	data.resultCallback = OnLeavePartyDialogResult

	OpenConfirmDialogFromData( data )
	AdvanceMenu( GetMenu( "ConfirmDialog" ) )
}

void function OnLeavePartyDialogResult( int result )
{
	if ( result != eDialogResult.YES )
	{
#if PS5_PROG
		                                                                 
		RunClientScript( "ClientCodeCallback_LeavePartyDialog_SetCancelled" )
#endif

		return
	}

#if PS5_PROG
	                                                         
	RunClientScript( "ClientCodeCallback_LeavePartyDialog_SetConfirmed" )
#endif

	LeaveParty()
}


                      
void function LeaveCustomMatchDialog()
{
	if ( !IsFullyConnected() )
		return

	if ( !MenuStack_Contains( GetMenu( "CustomMatchLobbyMenu" ) ) )
		return

	ConfirmDialogData data
	data.headerText = "#CUSTOMMATCH_LEAVE"
	data.messageText = "#CUSTOMMATCH_LEAVE_DESC"
	data.resultCallback = OnLeaveCustomMatchDialogResult

	OpenConfirmDialogFromData( data )
	AdvanceMenu( GetMenu( "ConfirmDialog" ) )
}

void function OnLeaveCustomMatchDialogResult( int result )
{
	if ( result != eDialogResult.YES )
		return

	CustomMatch_LeaveLobby()
	CustomMatch_CloseLobbyMenu()
}
      


void function CancelRestartingMatchmaking()
{
	Signal( uiGlobal.signalDummy, "CancelRestartingMatchmaking" )
}


void function LeaveMatchWithDialog()
{
	LeaveMatch()
	ShowLeavingDialog( "#FINDING_PARTY_SERVER" )
}


void function LeaveMatchWithDialog_Freelance()
{
	LeaveMatch_Freelance()
	ShowLeavingDialog( "Connecting to hub..." )
}

void function LeaveMatchAndParty_Freelance()
{
	LeaveParty()
	LeaveMatchWithDialog_Freelance()
}


void function ShowLeavingDialog( string header )
{
	DialogData dialogData
	dialogData.header = header
	dialogData.showSpinner = true
	dialogData.noChoice = true

	OpenDialog( dialogData )
}


void function ShowMatchConnectDialog()
{
	DialogData dialogData
	dialogData.header = "#CONNECTING_SEARCHING"
	dialogData.showSpinner = true
	dialogData.forceChoice = true

	AddDialogButton( dialogData, "#CANCEL", CancelMatchSearch )

	AddDialogFooter( dialogData, "#A_BUTTON_SELECT" )

	OpenDialog( dialogData )
}


void function CancelMatchSearch()
{
	CancelMatchmaking()
	Remote_ServerCallFunction( "ClientCallback_CancelMatchSearch" )
}


void function LeaveMatch_Disconnect()
{
	StopMatchmaking()
	ClientCommand( "disconnect" )
	Party_LeaveParty()
}


void function OpenDataCenterDialog( var button )
{
	DialogData dialogData
	dialogData.menu = GetMenu( "DataCenterDialog" )
	dialogData.header = Localize( "#DATA_CENTERS", GetDatacenterSelectedReasonSymbol() )

	#if PC_PROG
		AddDialogButton( dialogData, "#DISMISS" )
	#endif           

	AddDialogFooter( dialogData, "#A_BUTTON_SELECT" )
	AddDialogFooter( dialogData, "#B_BUTTON_DISMISS_RUI" )

	OpenDialog( dialogData )

	SetMenuNavigationDisabled( false )
}

void function OnDataCenterDialog_Close()
{
	if ( GetActiveMenu() == GetMenu( "MainMenu" ) )
		SetMenuNavigationDisabled( true )
}

void function OpenClubLeaveDialog()
{
	if ( HasActiveLobbyPopup() )
		return

	EmitUISound( "UI_Menu_Accept" )

	ConfirmLeaveClubDialog_Open()
}


void function OnBtnBackPressed( var button )
{
	CloseActiveMenu()
}

void function EndMatchDialog()
{
	ConfirmDialogData data
	data.headerText = "#TOURNAMENT_END_MATCH_DIALOG_HEADER"
	data.messageText = "#TOURNAMENT_END_MATCH_DIALOG_MSG"
	data.dialogConfirmDelay = 3.0
	data.resultCallback = void function( int dialogResult )
	{
		switch ( dialogResult )
		{
			case eDialogResult.YES:
			{
				if ( HasMatchAdminRole() )
					Remote_ServerCallFunction( "ClientCallback_PrivateMatchEndMatchEarly" )
			}
		}
	}

	OpenConfirmDialogFromData( data )
}