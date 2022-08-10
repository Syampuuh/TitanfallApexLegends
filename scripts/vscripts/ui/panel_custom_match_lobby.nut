global function InitCustomMatchLobbyPanel
global function CustomMatchLobby_OnDragPlayer
global function CustomMatchLobby_OnSetTeamNameOpenOrClose

struct
{
	var panel
	var startButton
	var dragIcon
	var dragTarget
	var chatTarget

	bool setTeamNameIsOpen = false

	bool chatEnabled	= false
	bool isReady		= false
	bool isMatchmaking 	= false
	bool canAction		= false
	bool selfAssign		= false
	int teamIndex		= TEAM_UNASSIGNED
} file

void function InitCustomMatchLobbyPanel( var panel )
{
	file.panel = panel
	file.dragIcon = Hud_GetChild( panel, "MouseDragIcon" )
	file.startButton = Hud_GetChild( panel, "StartButton" )
	file.chatTarget = Hud_GetChild( panel, "ChatPanel" )

	AddUICallback_InputModeChanged( UICallback_InputModeChanged )

	AddButtonEventHandler( file.startButton, UIE_CLICK, StartMatch_OnClick )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, CustomMatchLobby_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, CustomMatchLobby_OnHide )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_DPAD_LEFT, true, "#CUSTOM_MATCH_HOLD_LEAVE_TEAM", "#CUSTOM_MATCH_LEAVE_TEAM", JoinUnassigned_OnClick, JoinUnassigned_CanClick )
	AddPanelFooterOption( panel, LEFT, BUTTON_DPAD_RIGHT, true, "#CUSTOM_MATCH_HOLD_JOIN_SPECTATOR", "#CUSTOM_MATCH_JOIN_SPECTATOR", JoinSpectators_OnClick, JoinSpectators_CanClick )

	AddCallback_OnCustomMatchPlayerDataChanged( Callback_OnPlayerDataChanged )
	AddCallback_OnCustomMatchSettingChanged( CUSTOM_MATCH_SETTING_SELF_ASSIGN, Callback_OnSelfAssignChanged )
	AddCallback_OnCustomMatchSettingChanged( CUSTOM_MATCH_SETTING_CHAT_PERMISSION, Callback_OnChatPermissionChanged )
	AddCallback_OnCustomMatchSettingChanged( CUSTOM_MATCH_SETTING_MATCH_STATUS, Callback_OnMatchStatusChanged )

	Hud_Show( Hud_GetChild( panel, "LobbyRosterPanel" ) )
	Hud_Show( Hud_GetChild( panel, "PlayerRosterPanel" ) )
}

void function UICallback_InputModeChanged( bool controllerModeActive )
{
	if ( IsLobby() && CustomMatch_IsInCustomMatch() )
		InputModeChanged( controllerModeActive )
}

void function InputModeChanged( bool controllerModeActive )
{
	if ( CustomMatch_IsLocalAdmin() && !file.isMatchmaking )
		HudElem_SetRuiArg( file.startButton, "buttonText", controllerModeActive ? "#Y_BUTTON_START_MATCH" : "#START_MATCH" )
	else if ( !CustomMatch_IsLocalAdmin() && !file.isReady )
		HudElem_SetRuiArg( file.startButton, "buttonText", controllerModeActive ? "#Y_BUTTON_READY" : "#READY" )
	else
		HudElem_SetRuiArg( file.startButton, "buttonText", controllerModeActive ? "#B_BUTTON_CANCEL" : "#CANCEL" )
}

void function CustomMatchLobby_OnShow( var panel )
{
	RegisterButtonPressedCallback( BUTTON_Y, StartMatch_OnClick )
	RegisterButtonPressedCallback( KEY_Q, JoinUnassigned_OnClick )
}

void function CustomMatchLobby_OnHide( var panel )
{
	DeregisterButtonPressedCallback( BUTTON_Y, StartMatch_OnClick )
	DeregisterButtonPressedCallback( KEY_Q, JoinUnassigned_OnClick )
}

bool function StartMatch_CanClick()
{
	return !IsDialog( GetActiveMenu() )
}

void function StartMatch_OnClick( var button )
{
	if ( !StartMatch_CanClick() )
		return

	if ( CustomMatch_IsLocalAdmin() )
		CustomMatch_SetMatchmaking( !file.isMatchmaking )
	else
		CustomMatch_SetReady( !file.isReady )
}

bool function CanJoinTeam( int index )
{
	return !IsDialog( GetActiveMenu() ) && file.selfAssign && ( file.teamIndex != index ) && !ActionsLocked()
}

bool function JoinSpectators_CanClick()
{
	return CanJoinTeam( TEAM_SPECTATOR )
}

void function JoinSpectators_OnClick( var button )
{
	if ( !JoinSpectators_CanClick() )
		return

	if ( InputIsButtonDown( BUTTON_DPAD_RIGHT ) )
		thread OnHold_internal( BUTTON_DPAD_RIGHT, TEAM_SPECTATOR )
	else
		CustomMatch_SetTeam( TEAM_SPECTATOR, GetPlayerHardware(), GetPlayerUID() )
}

bool function JoinUnassigned_CanClick()
{
	return CanJoinTeam( TEAM_UNASSIGNED )
}

void function JoinUnassigned_OnClick( var button )
{
	if ( !JoinUnassigned_CanClick() )
		return

	if ( InputIsButtonDown( BUTTON_DPAD_LEFT ) )
		thread OnHold_internal( BUTTON_DPAD_LEFT, TEAM_UNASSIGNED )
	else
		CustomMatch_SetTeam( TEAM_UNASSIGNED, GetPlayerHardware(), GetPlayerUID() )
}

void function Callback_OnPlayerDataChanged( CustomMatch_LobbyPlayer playerData )
{
	file.teamIndex = playerData.team
	file.isReady = ( playerData.flags & CUSTOM_MATCH_PLAYER_BIT_IS_READY ) != 0
	Hud_SetEnabled( file.startButton, playerData.team != TEAM_UNASSIGNED )
	UpdateFooterOptions()
	InputModeChanged( IsControllerModeActive() )
}

const string ON = "1"
void function Callback_OnSelfAssignChanged( string _, string value )
{
	file.selfAssign = ( value == ON ) || CustomMatch_IsLocalAdmin()
	UpdateFooterOptions()
}

void function CustomMatchLobby_OnSetTeamNameOpenOrClose( bool open )
{
	file.setTeamNameIsOpen = open
	Callback_OnChatPermissionChanged( "", file.chatEnabled ? CUSTOM_MATCH_CHAT_PERMISSION_ALL : CUSTOM_MATCH_CHAT_PERMISSION_ADMIN_ONLY )

}

void function Callback_OnChatPermissionChanged( string _, string value )
{
	file.chatEnabled = ( value != CUSTOM_MATCH_CHAT_PERMISSION_ADMIN_ONLY ) || CustomMatch_IsLocalAdmin()
	bool chatEnabled = file.chatEnabled && !file.setTeamNameIsOpen

	var chatInputLine = Hud_GetChild( file.chatTarget, "ChatInputLine" )

	Hud_SetEnabled( file.chatTarget, chatEnabled )
	Hud_SetVisible( file.chatTarget, chatEnabled )
	Hud_SetEnabled( chatInputLine, chatEnabled )
	Hud_SetVisible( chatInputLine, chatEnabled )
	Hud_SetEnabled( Hud_GetChild( chatInputLine, "ChatInputPrompt" ), chatEnabled )
	Hud_SetVisible( Hud_GetChild( chatInputLine, "ChatInputPrompt" ), chatEnabled )
	Hud_SetEnabled( Hud_GetChild( chatInputLine, "ChatInputTextEntry" ), chatEnabled )
	Hud_SetVisible( Hud_GetChild( chatInputLine, "ChatInputTextEntry" ), chatEnabled )

	var chatHistory = Hud_GetChild( file.chatTarget, "HudChatHistory" )

	UIPos inputPos = REPLACEHud_GetPos( chatInputLine )
	UISize inputSize = REPLACEHud_GetSize( chatInputLine )
	UIPos historyPos = REPLACEHud_GetPos( chatHistory )

	int historyHeight = inputPos.y - historyPos.y
	Hud_SetHeight( chatHistory, chatEnabled ? historyHeight : historyHeight + inputSize.height )
}

void function Callback_OnMatchStatusChanged( string _, string value )
{
	file.canAction = ( value == CUSTOM_MATCH_STATUS_PREPARING )
	file.isMatchmaking = ( value == CUSTOM_MATCH_STATUS_MATCHMAKING )
	InputModeChanged( IsControllerModeActive() )
	UpdateFooterOptions()
}

const float BUTTON_HOLD_DELAY = 0.3
void function OnHold_internal( int button, int teamIndex )
{
	float endTIme = UITime() + BUTTON_HOLD_DELAY

	while ( InputIsButtonDown( button ) && UITime() < endTIme )
	{
		WaitFrame()
	}

	if ( CanJoinTeam( teamIndex ) && InputIsButtonDown( button ) )
		CustomMatch_SetTeam( teamIndex, GetPlayerHardware(), GetPlayerUID() )
}

bool function ActionsLocked()
{
	return !file.canAction
}

                                                                    
             
                                                                    

void function CustomMatchLobby_OnDragPlayer( CustomMatch_LobbyPlayer player )
{
	if ( ActionsLocked() )
		return

	string platformString = PlatformIDToIconString( GetHardwareFromName( player.hardware ) )

	Hud_Show( file.dragIcon )
	HudElem_SetRuiArg( file.dragIcon, "buttonText", player.name )
	HudElem_SetRuiArg( file.dragIcon, "platformString", platformString )
	HudElem_SetRuiArg( file.dragIcon, "isAdmin", player.isAdmin )

	ToolTips_SetMenuTooltipVisible( file.panel, false )
	thread DragPlayer( player )
}

void function DragPlayer( CustomMatch_LobbyPlayer player )
{
	if ( !( InputIsButtonDown( MOUSE_LEFT ) || InputIsButtonDown( BUTTON_A ) ) )
	{
		DropPlayer( player )
		return
	}

	vector screenPos = ConvertCursorToScreenPos()
	UIPos parentPos = REPLACEHud_GetAbsPos( file.panel )
	Hud_SetPos( file.dragIcon,
		screenPos.x - ( Hud_GetWidth( file.dragIcon ) * 0.5 ) - parentPos.x,
		screenPos.y - ( Hud_GetHeight( file.dragIcon ) * 0.5 ) - parentPos.y )

	DragHover()
	WaitFrame()
	DragPlayer( player )
}

void function DragHover()
{
	var dragTarget = GetDragTarget()
	if ( dragTarget != file.dragTarget )
	{
		if( IsValid( file.dragTarget ) )
			HudElem_SetRuiArg( file.dragTarget, "isDragTarget", false )

		file.dragTarget = dragTarget

		if( IsValid( file.dragTarget ) )
			HudElem_SetRuiArg( file.dragTarget, "isDragTarget", true )
	}
}

void function DragStop()
{
	Hud_Hide( file.dragIcon )
	ToolTips_SetMenuTooltipVisible( file.panel, true )

	if( file.dragTarget != null )
		HudElem_SetRuiArg( file.dragTarget, "isDragTarget", false )
}

void function DropPlayer( CustomMatch_LobbyPlayer player )
{
	var dropTarget = GetDropTarget()
	if ( dropTarget )
	{
		int teamIndex = Hud_GetScriptID( dropTarget ).tointeger()
		if ( player.team != teamIndex )
			CustomMatch_SetTeam( teamIndex, player.hardware, player.uid )
	}
	DragStop()
}

var function GetDragTarget()
{
	var element = GetMouseFocus()
	while ( element && element != file.panel )
	{
		                                                                                    
		string name = Hud_GetHudName( element )
		name = name.slice( 0, name.len() - 2 )

		switch ( name )
		{
			case "Team":
				return Hud_GetChild( element, "TeamHeader" )
			case "LobbyRoster":
				return Hud_GetChild( Hud_GetParent( element ), format( "LobbyRosterButton%02u", Hud_GetScriptID( element ).tointeger() ))
			case "LobbyRosterButton":
				return element
			default:
				break
		}

		element = Hud_GetParent( element )
	}
	return null
}

var function GetDropTarget()
{
	var element = GetMouseFocus()
	while ( element && element != file.panel )
	{
		                                                                                    
		string name = Hud_GetHudName( element )
		name = name.slice( 0, name.len() - 2 )

		switch ( name )
		{
			case "Team":
			case "LobbyRoster":
			case "LobbyRosterButton":
				return element
			default:
				break
		}

		element = Hud_GetParent( element )
	}
	return null
}