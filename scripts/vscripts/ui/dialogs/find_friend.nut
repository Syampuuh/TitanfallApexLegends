global function InitFindFriendDialog

global function FindFriendDialog_OnSearchResult

enum eFindFriendState
{
	AWAIT_INPUT,
	INPUT_VALID,
	SEARCHING,
	SEARCH_FOUND,
	SEARCH_NOTFOUND
}

struct {
	var menu

	var nameTextEntry
	var resultsList
	var resultsBackground

	InputDef &searchButtonDef
	var closeButton

	string lastSearchedName = ""

	table<var, EadpQuerryPlayerData> buttonToResultMap

	int searchState = eFindFriendState.AWAIT_INPUT
} file


void function InitFindFriendDialog( var newMenuArg )
                                              
{
	var menu = newMenuArg
	file.menu = menu

	file.nameTextEntry = Hud_GetChild( menu, "NameTextEntry" )
	file.resultsList = Hud_GetChild( menu, "ResultsList" )
	file.resultsBackground = Hud_GetChild( menu, "ResultsListBackground" )

	SetAllowControllerFooterClick( menu, true )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, FindFriendDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, FindFriendDialog_OnClose )

	file.searchButtonDef = AddMenuFooterOption( menu, LEFT, BUTTON_Y, true, "#Y_BUTTON_SEARCH", "#Y_BUTTON_SEARCH", FindFriendDialog_Search )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CANCEL", "#B_BUTTON_CANCEL", FindFriendDialog_Cancel )
}


void function FindFriendDialog_OnOpen()
{
	var contentRui = Hud_GetRui( Hud_GetChild( file.menu, "ContentRui" ) )
	RuiSetString( contentRui, "headerText", "#FIND_FRIEND" )
	RuiSetString( contentRui, "messageText", "#FIND_FRIEND_NOTICE" )


	Hud_SetUTF8Text( file.nameTextEntry, "" )
	Hud_SetTextEntryTitle( file.nameTextEntry, "#FIND_FRIEND" )
	                                      

	RegisterButtonPressedCallback( KEY_ENTER, FindFriendDialog_Search )

	FindFriendDialog_SetState( eFindFriendState.AWAIT_INPUT )

	thread FindFriendDialog_Update()

	thread function()
	{
		WaitEndFrame()
		Hud_SetFocused( file.nameTextEntry )
	}()
}

void function FindFriendDialog_OnClose()
{
	DeregisterButtonPressedCallback( KEY_ENTER, FindFriendDialog_Search )
}


void function ClearResults()
{
	foreach ( button, _ in file.buttonToResultMap )
	{
		Hud_RemoveEventHandler( button, UIE_CLICK, ResultButton_OnActivate )
		Hud_RemoveEventHandler( button, UIE_CLICKRIGHT, ResultButton_OnAlternate )
	}

	file.buttonToResultMap.clear()

	Hud_InitGridButtons( file.resultsList, 0 )
}

void function FindFriendDialog_Update()
{
	                                                                                             
	                                                                                                         
	while( MenuStack_Contains( file.menu ) )
	{
		if ( GetActiveMenu() == file.menu && file.searchState != eFindFriendState.SEARCHING )
		{
			string searchName = Hud_GetUTF8Text( file.nameTextEntry )
			if ( searchName.len() == 0 && file.searchState != eFindFriendState.AWAIT_INPUT )
				FindFriendDialog_SetState( eFindFriendState.AWAIT_INPUT )
			else if ( searchName.len() > 0 && file.searchState == eFindFriendState.AWAIT_INPUT )
				FindFriendDialog_SetState( eFindFriendState.INPUT_VALID )
			else if ( (file.searchState == eFindFriendState.SEARCH_FOUND || file.searchState == eFindFriendState.SEARCH_NOTFOUND) && searchName != file.lastSearchedName )
				FindFriendDialog_SetState( eFindFriendState.INPUT_VALID )
		}

		WaitFrame()
	}
}


void function FindFriendDialog_SetState( int state )
{
	if ( state == file.searchState )
		return

	HudElem_SetRuiArg( file.resultsBackground, "state", state )
	file.searchButtonDef.clickable = state == eFindFriendState.INPUT_VALID
	UpdateFooterOptions()

	switch ( state )
	{
		case eFindFriendState.AWAIT_INPUT:
			ClearResults()
			break

		case eFindFriendState.SEARCHING:
			ClearResults()
			break
	}

	file.searchState = state
}


void function FindFriendDialog_Search( var button )
{
	if ( file.searchState != eFindFriendState.INPUT_VALID )
		return

	string searchName = strip( Hud_GetUTF8Text( file.nameTextEntry ) )	                                              
	Hud_SetUTF8Text( file.nameTextEntry, searchName )

	printt( "EADP_SearchByName: " + searchName )
	EADP_SearchByName( searchName )

	file.lastSearchedName = searchName

	FindFriendDialog_SetState( eFindFriendState.SEARCHING )
}


void function FindFriendDialog_OnSearchResult( int error, string errorReason, array<EadpQuerryPlayerData> results )
{
	if ( file.searchState != eFindFriendState.SEARCHING )
		return

	if ( GetActiveMenu() != file.menu )
		return

	if ( !results.len() )
	{
		HudElem_SetRuiArg( file.resultsBackground, "noResultsText", Localize(  errorReason,  error ) )
		FindFriendDialog_SetState( eFindFriendState.SEARCH_NOTFOUND )
		return
	}

	FindFriendDialog_SetState( eFindFriendState.SEARCH_FOUND )

	Hud_InitGridButtons( file.resultsList, results.len() )

	var scrollPanel = Hud_GetChild( file.resultsList, "ScrollPanel" )
	foreach ( index, result in results )
	{
		var resultButton = Hud_GetChild( scrollPanel, "GridButton" + index )
		Hud_AddEventHandler( resultButton, UIE_CLICK, ResultButton_OnActivate )
		Hud_AddEventHandler( resultButton, UIE_CLICKRIGHT, ResultButton_OnAlternate )

		string nameString = CrossplayUserOptIn() ? Localize( PlatformIDToIconString( result.hardware ) ) + "   " + result.name : ""
		if ( EADP_IsBlockedByEAID( result.eaid ) )
			nameString = Localize( "#CROSSPLAY_EADP_BLOCK", nameString )
		else if ( EADP_IsFriendByEAID( result.eaid ) )
			nameString = Localize( "#CROSSPLAY_EADP_FRIEND", nameString )


		HudElem_SetRuiArg( resultButton, "buttonText", nameString )

		file.buttonToResultMap[resultButton] <- result

		ToolTipData toolTipData
		toolTipData.tooltipStyle = eTooltipStyle.BUTTON_PROMPT
		toolTipData.actionHint1 = "#CROSSPLAY_A_BUTTON_FRIEND_REQUEST"

		if ( EADP_IsBlockedByEAID( result.eaid ) )
			toolTipData.actionHint1 = "CROSSPLAY_X_BUTTON_FRIEND_UNBLOCK"
		else if ( EADP_IsFriendByEAID( result.eaid ) )
			toolTipData.actionHint1 = "CROSSPLAY_X_BUTTON_UNFRIEND"


		Hud_SetToolTipData( resultButton, toolTipData )
	}

	                                                                                                                                 
	Hud_SetFocused( file.menu )
}


void function ResultButton_OnActivate( var button )
{
	if ( EADP_IsBlockedByEAID( file.buttonToResultMap[button].eaid ) )
		return

	if ( EADP_IsFriendByEAID( file.buttonToResultMap[button].eaid ) )
	{
		                        
		                                                  
		                                                                                                                
		  
		                              
		return
	}

	printt( "EADP_InviteFriendByEAID: " + file.buttonToResultMap[button].eaid + " (" + file.buttonToResultMap[button].name + ")" )

	int hardward = GetHardwareFromName( GetUnspoofedPlayerHardware() )
	if ( hardward == file.buttonToResultMap[button].hardware )
	{
		                                                                        
		if ( file.buttonToResultMap[button].hardware == HARDWARE_PC )
			DoInviteToBeFriend( file.buttonToResultMap[button].eaid )                                          
		else
			EADP_InviteFriendByEAID( file.buttonToResultMap[button].eaid )
	}
	else
	{
		EADP_InviteFriendByEAID( file.buttonToResultMap[button].eaid )
	}

	ConfirmDialogData data
	data.headerText = "#FRIEND_INVITE_DIALOG_HEADER"
	data.messageText = Localize( "#FRIEND_INVITE_DIALOG_MSG_INVITE_SENT", file.buttonToResultMap[button].name )
	                                
	data.resultCallback = void function( int dialogResult ) : (button) { FindFriendDialog_Cancel( button ) }

	OpenOKDialogFromData( data )

	thread function()
	{
		WaitEndFrame()
		Hud_SetFocused( GetActiveMenu() )
	}()
}

void function ResultButton_OnAlternate( var button )
{
	if ( EADP_IsBlockedByEAID( file.buttonToResultMap[button].eaid ) )
	{
		ConfirmDialogData data
		data.headerText = "#UNBLOCK_DIALOG_HEADER"
		data.messageText = Localize( "#UNBLOCK_DIALOG_MSG", file.buttonToResultMap[button].name )
		data.resultCallback = void function( int dialogResult ) : (button) {
			if ( dialogResult == eDialogResult.YES )
			{
				printt( "EADP_UnBlockByEAID: " + file.buttonToResultMap[button].eaid + " (" + file.buttonToResultMap[button].name + ")" )
				EADP_UnBlockByEAID( file.buttonToResultMap[button].eaid )
				FindFriendDialog_Cancel( button )                                 

			}
		}

		OpenConfirmDialogFromData( data )
	}
	else if ( EADP_IsFriendByEAID( file.buttonToResultMap[button].eaid ) )
	{
		ConfirmDialogData dialogData
		dialogData.headerText = "#UNFRIEND_DIALOG_HEADER"
		dialogData.messageText = Localize( "#UNFRIEND_DIALOG_MSG", file.buttonToResultMap[button].name )
		dialogData.contextImage = $"ui/menu/common/dialog_notice"
		dialogData.resultCallback = void function( int dialogResult ) : (button) {
			if ( dialogResult == eDialogResult.YES )
			{
				printt( "EADP_UnFriendByEAID: " + file.buttonToResultMap[button].eaid + " (" + file.buttonToResultMap[button].name + ")" )
				EADP_UnFriendByEAID( file.buttonToResultMap[button].eaid  )
				FindFriendDialog_Cancel( button )                                 
			}
		}

		OpenConfirmDialogFromData( dialogData )
	}
}


void function FindFriendDialog_Cancel( var button )
{
	CloseAllToTargetMenu( file.menu )
	CloseActiveMenu()
}