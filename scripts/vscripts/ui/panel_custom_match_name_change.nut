global function InitCustomMatchChangeNamePanel

struct
{
	var nameText
	var nameTextEntry

	bool inputRegistered = false
} file

void function InitCustomMatchChangeNamePanel( var panel )
{
	file.nameText = Hud_GetChild( panel, "LobbyName" )

	file.nameTextEntry = Hud_GetChild( panel, "LobbyNameChange" )
	Hud_AddEventHandler( file.nameTextEntry, UIE_GET_FOCUS, TextEntry_OnGainFocus )
	Hud_AddEventHandler( file.nameTextEntry, UIE_LOSE_FOCUS, TextEntry_OnLoseFocus )

	var button = Hud_GetChild( panel, "ChangeButton" )
	AddButtonEventHandler( button, UIE_CLICK, Button_OnClick )
}

void function Button_OnClick( var button )
{
	bool toggleOn = !Hud_IsVisible( file.nameTextEntry )
	Hud_SetVisible( file.nameTextEntry, toggleOn )
	if( toggleOn )
		Hud_SetFocused( file.nameTextEntry )
}


void function TextEntry_OnGainFocus( var textEntry )
{
	Hud_SetVisible( file.nameText, false )
	if( !file.inputRegistered )
		RegisterButtonPressedCallback( KEY_ENTER, TextEntry_OnEnterPressed )
	file.inputRegistered = true
}

void function TextEntry_OnLoseFocus( var textEntry )
{
	string text = Hud_GetUTF8Text( textEntry )
	HudElem_SetRuiArg( file.nameText, "text", text )
	CustomMatch_SetSetting( CUSTOM_MATCH_SETTING_LOBBY_NAME, text )

	Hud_SetVisible( file.nameText, true )
	Hud_SetVisible( file.nameTextEntry, false )

	if( file.inputRegistered )
		DeregisterButtonPressedCallback( KEY_ENTER, TextEntry_OnEnterPressed )
	file.inputRegistered = false
}

void function TextEntry_OnEnterPressed( var _ )
{
	Hud_SetVisible( file.nameTextEntry, false )
}