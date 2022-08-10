global function InitFindClubMemberDialog
global function CloseFindClubMemberDialog

global function OpenFindClubMemberDialog

global function FindClubMemberDialog_OnSearchResult

enum eFindClubMemberState
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

	int searchState = eFindClubMemberState.AWAIT_INPUT
} file


void function InitFindClubMemberDialog( var newMenuArg )
                                              
{
	var menu = newMenuArg
	file.menu = menu
	                         
	SetAllowControllerFooterClick( menu, true )

	file.nameTextEntry = Hud_GetChild( menu, "NameTextEntry" )
	file.resultsList = Hud_GetChild( menu, "ResultsList" )
	file.resultsBackground = Hud_GetChild( menu, "ResultsListBackground" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, FindClubMemberDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, FindClubMemberDialog_OnClose )

	file.searchButtonDef = AddMenuFooterOption( menu, LEFT, BUTTON_Y, true, "#Y_BUTTON_SEARCH", "#Y_BUTTON_SEARCH", FindClubMemberDialog_Search )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CANCEL", "#B_BUTTON_CANCEL", FindClubMemberDialog_Cancel )
}

void function OpenFindClubMemberDialog( var button )
{
	if ( !EADP_SocialEnabled() )
		return

	if ( !ClubIsValid() )
		return

	if ( ClubGetMyMemberRank() < CLUB_RANK_CAPTAIN )
		return

	if ( IsSocialPopupActive() )
		return

	EmitUISound( "UI_Menu_Accept" )

	AdvanceMenu( file.menu )
}

void function FindClubMemberDialog_OnOpen()
{
	var contentRui = Hud_GetRui( Hud_GetChild( file.menu, "ContentRui" ) )
	RuiSetString( contentRui, "headerText", "#CLUB_FIND_MEMBER" )

	Hud_SetUTF8Text( file.nameTextEntry, "" )
	Hud_SetFocused( file.nameTextEntry )
	Hud_SetTextEntryTitle( file.nameTextEntry, "#FIND_FRIEND" )

	FindClubMemberDialog_SetState( eFindClubMemberState.AWAIT_INPUT )

	RegisterInputs()

	thread FindClubMemberDialog_Update()
}

void function CloseFindClubMemberDialog()
{
	if ( GetActiveMenu() == file.menu )
		CloseActiveMenu()
}

void function FindClubMemberDialog_OnClose()
{
	DeregisterInputs()
}

void function RegisterInputs()
{
	                                                                        
	RegisterButtonPressedCallback( KEY_ENTER, FindClubMemberDialog_Search )
}

void function DeregisterInputs()
{
	                                                                          
	DeregisterButtonPressedCallback( KEY_ENTER, FindClubMemberDialog_Search )
}

void function ClearResults()
{
	foreach ( button, _ in file.buttonToResultMap )
		Hud_RemoveEventHandler( button, UIE_CLICK, ResultButton_OnActivate )

	file.buttonToResultMap.clear()

	Hud_InitGridButtons( file.resultsList, 0 )
}

void function FindClubMemberDialog_Update()
{
	while ( GetActiveMenu() == file.menu )
	{
		if ( file.searchState != eFindClubMemberState.SEARCHING )
		{
			string searchName = Hud_GetUTF8Text( file.nameTextEntry )
			if ( searchName.len() == 0 && file.searchState != eFindClubMemberState.AWAIT_INPUT )
				FindClubMemberDialog_SetState( eFindClubMemberState.AWAIT_INPUT )
			else if ( searchName.len() > 0 && file.searchState == eFindClubMemberState.AWAIT_INPUT )
				FindClubMemberDialog_SetState( eFindClubMemberState.INPUT_VALID )
			else if ( (file.searchState == eFindClubMemberState.SEARCH_FOUND || file.searchState == eFindClubMemberState.SEARCH_NOTFOUND) && searchName != file.lastSearchedName )
				FindClubMemberDialog_SetState( eFindClubMemberState.INPUT_VALID )
		}

		WaitFrame()
	}
}


void function FindClubMemberDialog_SetState( int state )
{
	if ( state == file.searchState )
		return

	HudElem_SetRuiArg( file.resultsBackground, "state", state )
	file.searchButtonDef.clickable = state == eFindClubMemberState.INPUT_VALID
	UpdateFooterOptions()

	switch ( state )
	{
		case eFindClubMemberState.AWAIT_INPUT:
			ClearResults()
			break

		case eFindClubMemberState.SEARCHING:
			ClearResults()
			break
	}

	file.searchState = state
}


void function FindClubMemberDialog_Search( var button )
{
	string searchName = Hud_GetUTF8Text( file.nameTextEntry )
	printt( "EADP_SearchByName: " + searchName )
	EADP_SearchByName( searchName )

	file.lastSearchedName = searchName

	FindClubMemberDialog_SetState( eFindClubMemberState.SEARCHING )
}


void function FindClubMemberDialog_OnSearchResult( int error, string errorReason, array<EadpQuerryPlayerData> results )
{
	if ( file.searchState != eFindClubMemberState.SEARCHING )
		return

	if ( GetActiveMenu() != file.menu )
		return

	if ( !results.len() )
	{
		if( errorReason == "#PLAYER_SEARCH_HTTP_ERROR" )
		{
			HudElem_SetRuiArg( file.resultsBackground, "noResultsText", Localize( "#PLAYER_SEARCH_ERROR_GENERIC" ) )
			HudElem_SetRuiArg( file.resultsBackground, "noResultsSubText", Localize(  errorReason,  error ) )
			FindClubMemberDialog_SetState( eFindClubMemberState.SEARCH_NOTFOUND )
		}
		else
		{
			HudElem_SetRuiArg( file.resultsBackground, "noResultsText", Localize( errorReason,  error ) )
			FindClubMemberDialog_SetState( eFindClubMemberState.SEARCH_NOTFOUND )
		}
		return
	}

	array<EadpQuerryPlayerData> finalResults
	foreach ( index, result in results )
	{
		                                                                                                                                            
		  	        

		if ( !Clubs_IsUserAClubmate( result.eaid ) )
			finalResults.append( result )
	}

	if ( finalResults.len() == 0 )
		return

	FindClubMemberDialog_SetState( eFindClubMemberState.SEARCH_FOUND )

	Hud_InitGridButtons( file.resultsList, finalResults.len() )

	var scrollPanel = Hud_GetChild( file.resultsList, "ScrollPanel" )
	foreach ( index, result in finalResults )
	{
		var resultButton = Hud_GetChild( scrollPanel, "GridButton" + index )
		Hud_AddEventHandler( resultButton, UIE_CLICK, ResultButton_OnActivate )

		string platformString = CrossplayUserOptIn() ? Localize( PlatformIDToIconString( result.hardware ) ) + " " + result.name : ""
		HudElem_SetRuiArg( resultButton, "buttonText", platformString )

		file.buttonToResultMap[resultButton] <- result
	}
}


void function ResultButton_OnActivate( var button )
{
	                                                                                                                                      
	PIN_Club_Invite( ClubGetHeader(), "club", file.buttonToResultMap[button].eaid )
	ClubInviteUser( file.buttonToResultMap[button].eaid )

	ConfirmDialogData data
	data.headerText = "#CLUB_INVITE_DIALOG_HEADER"
	data.messageText = Localize( "#CLUB_FIND_INVITE_SENT_DIALOG", file.buttonToResultMap[button].name )
	data.resultCallback = void function( int dialogResult ) : (button) { FindClubMemberDialog_Cancel( button ) }

	OpenOKDialogFromData( data )

	thread function()
	{
		WaitEndFrame()
		Hud_SetFocused( GetActiveMenu() )
	}()
}


void function FindClubMemberDialog_Cancel( var button )
{
	CloseAllToTargetMenu( file.menu )
	CloseActiveMenu()
}