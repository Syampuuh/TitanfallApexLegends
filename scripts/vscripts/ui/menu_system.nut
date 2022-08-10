global function InitSystemMenu
global function UpdateSystemMenu
global function OpenSystemMenu

global function ShouldDisplayOptInOptions
global function EnableCharacterChangeInFiringRange
global function IsOptInEnabled

struct ButtonData
{
	string             label
	void functionref() activateFunc
}

struct
{
	var menu

	array<var>        buttons
	array<ButtonData> buttonDatas

	ButtonData settingsButtonData
	ButtonData leaveMatchButtonData
	ButtonData endMatchButtonData
	ButtonData exitButtonData
	ButtonData lobbyReturnButtonData
	ButtonData nullButtonData
	ButtonData leavePartyData
	ButtonData leaveCustomMatchData
	ButtonData abandonMissionButtonData
	ButtonData changeCharacterButtonData
	ButtonData friendlyFireButtonData
                          
                                    
                                           
       
	ButtonData suicideButtonData

	bool enableChangeCharacterButton = true

	InputDef& qaFooter
	bool isOptInEnabled = false
} file

void function InitSystemMenu( var newMenuArg )                                               
{
	var menu = GetMenu( "SystemMenu" )
	Hud_SetAboveBlur( menu, true )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnSystemMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnSystemMenu_Close )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnSystemMenu_NavigateBack )


	file.buttons = GetElementsByClassname( menu, "SystemButtonClass" )
	file.buttonDatas.resize( file.buttons.len() )

	foreach ( index, button in file.buttons )
	{
		SetButtonData( index, file.nullButtonData )
		Hud_AddEventHandler( button, UIE_CLICK, OnButton_Activate )
	}

	file.settingsButtonData.label = "#SETTINGS"
	file.settingsButtonData.activateFunc = OpenSettingsMenu

	file.leaveMatchButtonData.label = "#LEAVE_MATCH"
	file.leaveMatchButtonData.activateFunc = LeaveDialog

	file.endMatchButtonData.label = "#TOURNAMENT_END_MATCH"
	file.endMatchButtonData.activateFunc = EndMatchDialog

	file.exitButtonData.label = "#EXIT_TO_DESKTOP"
	file.exitButtonData.activateFunc = OpenConfirmExitToDesktopDialog

	file.lobbyReturnButtonData.label = "#RETURN_TO_LOBBY"
	file.lobbyReturnButtonData.activateFunc = LeaveDialog

	file.leavePartyData.label = "#LEAVE_PARTY"
	file.leavePartyData.activateFunc = LeavePartyDialog

                       
		file.leaveCustomMatchData.label = "#CUSTOMMATCH_LEAVE"
		file.leaveCustomMatchData.activateFunc = LeaveCustomMatchDialog
       

	file.abandonMissionButtonData.label = "#QUEST_LEAVE_MATCH"
	file.abandonMissionButtonData.activateFunc = LeaveDialog

	file.changeCharacterButtonData.label = "#BUTTON_CHARACTER_CHANGE"
	file.changeCharacterButtonData.activateFunc = TryChangeCharacters

	file.friendlyFireButtonData.label = "#BUTTON_FRIENDLY_FIRE_TOGGLE"
	file.friendlyFireButtonData.activateFunc = ToggleFriendlyFire

                          
                                                                     
                                                                 

                                                                                     
                                                                               
       

	file.suicideButtonData.label = "#BUTTON_SUICIDE"
	file.suicideButtonData.activateFunc = TryRespawnAndChangeCharacters


	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	#if DEV
		AddMenuFooterOption( menu, LEFT, BUTTON_Y, true, "#Y_BUTTON_DEV_MENU", "#DEV_MENU", OpenDevMenu )
	#endif
	file.qaFooter = AddMenuFooterOption( menu, LEFT, BUTTON_X, true, "#X_BUTTON_QA", "QA", ToggleOptIn, ShouldDisplayOptInOptions )

	#if NX_PROG
		AddMenuFooterOption( menu, LEFT, BUTTON_STICK_RIGHT, true, "#BUTTON_VIEW_CINEMATIC", "#VIEW_CINEMATIC", ViewCinematic, IsLobby )
	#else
		AddMenuFooterOption( menu, RIGHT, BUTTON_STICK_RIGHT, true, "#BUTTON_VIEW_CINEMATIC", "", ViewCinematic, IsLobby )
		AddMenuFooterOption( menu, RIGHT, KEY_V, true, "", "#BUTTON_VIEW_CINEMATIC", ViewCinematic, IsLobby )
	#endif

	AddMenuFooterOption( menu, RIGHT, BUTTON_BACK, true, "#BUTTON_RETURN_TO_MAIN", "", ReturnToMain_OnActivate, IsLobby )
	AddMenuFooterOption( menu, RIGHT, KEY_R, true, "", "#BUTTON_RETURN_TO_MAIN", ReturnToMain_OnActivate, IsLobby )
}


void function ViewCinematic( var button )
{
	CloseActiveMenu()
	#if NX_PROG
		string videoName = "intro_720p"
	#else
		string videoName = "intro"
	#endif
	thread PlayVideoMenu( false, videoName, "Apex_Opening_Movie", eVideoSkipRule.INSTANT )
}

void function TryChangeCharacters()
{
	if ( !file.enableChangeCharacterButton )
		return

	RunClientScript( "UICallback_OpenCharacterSelectNewMenu" )
}

void function ToggleFriendlyFire()
{
	Remote_ServerCallFunction( "ClientCallback_firingrange_toggle_friendlyfire" )
}

                         
                                   
 
                                                                              
 

                                          
 
                                                            
 
      

void function TryRespawnAndChangeCharacters()
{
	RunClientScript( "UICallback_DieAndChangeCharacters" )
}

void function EnableCharacterChangeInFiringRange( bool enable )
{
	file.enableChangeCharacterButton = enable
	UpdateSystemMenu()
}


void function OnSystemMenu_Open()
{
	UpdateSystemMenu()
	SetBlurEnabled( true )

	UpdateOptInFooter()
}


void function UpdateSystemMenu()
{
	foreach ( index, button in file.buttons )
		SetButtonData( index, file.nullButtonData )

	int buttonIndex = 0
	if ( IsConnected() && !IsLobby() )
	{
		                                     
		SetCursorPosition( <1920.0 * 0.5, 1080.0 * 0.5, 0> )

		SetButtonData( buttonIndex++, file.settingsButtonData )
		{
			if ( IsPVEMode() )
				SetButtonData( buttonIndex++, file.abandonMissionButtonData )
			else if ( IsSurvivalTraining() || IsFiringRangeGameMode() )
				SetButtonData( buttonIndex++, file.lobbyReturnButtonData )
			else
				SetButtonData( buttonIndex++, file.leaveMatchButtonData )
		}

		if ( IsFiringRangeGameMode() )
		{
			if ( file.enableChangeCharacterButton )
				SetButtonData( buttonIndex++, file.changeCharacterButtonData )

			if ( (GetTeamSize( GetTeam() ) > 1) && FiringRangeHasFriendlyFire() )
				SetButtonData( buttonIndex++, file.friendlyFireButtonData )

                            
                                        
                                                                 

                                       
                                                                        
         
		}

		int gameState = GetGameState()
		bool playingOrSuddenDeath = ( gameState == eGameState.Playing )  || ( gameState == eGameState.SuddenDeath )
		if ( IsPrivateMatch() && HasMatchAdminRole() && playingOrSuddenDeath )
			SetButtonData( buttonIndex++, file.endMatchButtonData )

                          
			if ( Control_IsModeEnabled() && gameState == eGameState.Playing )
				SetButtonData( buttonIndex++, file.suicideButtonData )
        
	}
	else
	{
		if ( AmIPartyMember() || AmIPartyLeader() && GetPartySize() > 1 )
			SetButtonData( buttonIndex++, file.leavePartyData )
                        
			if ( MenuStack_Contains( GetMenu( "CustomMatchLobbyMenu" ) ) )
				SetButtonData( buttonIndex++, file.leaveCustomMatchData )
        
		SetButtonData( buttonIndex++, file.settingsButtonData )
		#if PC_PROG
			SetButtonData( buttonIndex++, file.exitButtonData )
		#endif
		if ( IsPrivateMatchLobby() )
			SetButtonData( buttonIndex++, file.leaveMatchButtonData )
	}

	const int maxNumButtons = 4;
	for( int i = 0; i < maxNumButtons; i++ )
	{
		if( i > 0 && i < buttonIndex)
			Hud_SetNavUp( file.buttons[i], file.buttons[i - 1] )
		else
			Hud_SetNavUp( file.buttons[i], null )

		if( i < (buttonIndex - 1) )
			Hud_SetNavDown( file.buttons[i], file.buttons[i + 1] )
		else
			Hud_SetNavDown( file.buttons[i], null )
	}

	var dataCenterElem = Hud_GetChild( file.menu, "DataCenter" )
	Hud_SetText( dataCenterElem, Localize( "#SYSTEM_DATACENTER", GetDatacenterName(), GetDatacenterPing(), GetDatacenterSelectedReasonSymbol() ) )
}


void function SetButtonData( int buttonIndex, ButtonData buttonData )
{
	file.buttonDatas[buttonIndex] = buttonData

	var rui = Hud_GetRui( file.buttons[buttonIndex] )
	RHud_SetText( file.buttons[buttonIndex], buttonData.label )

	if ( buttonData.label == "" )
		Hud_SetVisible( file.buttons[buttonIndex], false )
	else
		Hud_SetVisible( file.buttons[buttonIndex], true )
}


void function OnSystemMenu_Close()
{
}


void function OnSystemMenu_NavigateBack()
{
	Assert( GetActiveMenu() == file.menu )
	CloseActiveMenu()
}


void function OnButton_Activate( var button )
{
	if ( GetActiveMenu() == file.menu )
		CloseActiveMenu()

	int buttonIndex = int( Hud_GetScriptID( button ) )

	file.buttonDatas[buttonIndex].activateFunc()
}

void function OpenSystemMenu()
{
	AdvanceMenu( file.menu )
}

void function OpenSettingsMenu()
{
	AdvanceMenu( GetMenu( "MiscMenu" ) )
}

                  
void function ReturnToMain_OnActivate( var button )
{
	ConfirmDialogData data
	data.headerText = "#EXIT_TO_MAIN"
	data.messageText = ""
	data.resultCallback = OnReturnToMainMenu
	                                                                          

	OpenConfirmDialogFromData( data )
	AdvanceMenu( GetMenu( "ConfirmDialog" ) )
}

void function OnReturnToMainMenu( int result )
{
	if ( result == eDialogResult.YES )
	{
		LeaveMatch()
		ClientCommand( "disconnect" )
	}
}
        


void function ToggleOptIn( var button )
{
	file.isOptInEnabled = !file.isOptInEnabled

	if ( GetActiveMenu() == file.menu )
		CloseActiveMenu()
}


bool function ShouldDisplayOptInOptions()
{
	if ( !IsFullyConnected() )
		return false

	if ( GRX_IsInventoryReady() && (GRX_HasItem( GRX_DEV_ITEM ) || GRX_HasItem( GRX_QA_ITEM )) )
		return true

	return GetGlobalNetBool( "isOptInServer" )
}


void function UpdateOptInFooter()
{
	if ( file.isOptInEnabled )
	{
		file.qaFooter.gamepadLabel = "#X_BUTTON_HIDE_OPT_IN"
		file.qaFooter.mouseLabel = "#HIDE_OPT_IN"
	}
	else
	{
		file.qaFooter.gamepadLabel = "#X_BUTTON_SHOW_OPT_IN"
		file.qaFooter.mouseLabel = "#SHOW_OPT_IN"
	}

	UpdateFooterOptions()
}


bool function IsOptInEnabled()
{
	return file.isOptInEnabled
}