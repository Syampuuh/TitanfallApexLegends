global function InitArenasSelectOpticDialog
global function ClientToUI_Arenas_OpenSelectOpticDialog
global function ClientToUI_Arenas_CloseSelectOpticDialog
global function SelectOptic_CancelButton_Activate

const string SOUND_OPEN_OPTIC_SELECTOR		= "ui_arenas_ingame_inventory_Optic_Selection_Open"

struct
{
	var menu
	var currentOptic
	array<var> buttons

} file

void function InitArenasSelectOpticDialog( var newMenuArg )
{
	var menu = newMenuArg
	file.menu = menu

	SetDialog( menu, true )
	SetClearBlur( menu, false )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, SelectOpticDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, SelectOpticDialog_OnClose )

	Hud_AddEventHandler( Hud_GetChild( menu, "DarkenBackground" ), UIE_CLICK, SelectOptic_CancelButton_Activate )
	file.currentOptic = Hud_GetChild( menu, "CurrentOptic" )

	file.buttons = GetElementsByClassname( file.menu, "OpticButton" )
	foreach ( button in file.buttons )
	{
		AddButtonEventHandler( button, UIE_CLICK, OnBuyButtonClick )
	}

	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#CLOSE" )
}

void function ClientToUI_Arenas_OpenSelectOpticDialog( int currentOpticIndex, int totalOptics )
{
	AdvanceMenu( file.menu )

	RunClientScript( "ServerCallback_FinishedProcessingClickEvent" )

	var currentOpticRui = Hud_GetRui( file.currentOptic )
	RuiSetFloat( currentOpticRui, "baseAlpha", 1.0 )
	RuiSetBool( currentOpticRui, "hasPreReq", true )

	if( currentOpticIndex >= 0 )
	{
		LootData currentOptic = SURVIVAL_Loot_GetLootDataByIndex( currentOpticIndex )
		RuiSetImage( currentOpticRui, "iconImage", currentOptic.hudIcon )
		RuiSetInt( currentOpticRui, "tier", currentOptic.tier )
	}
	else
	{
		RuiSetImage( currentOpticRui, "iconImage", $"rui/pilot_loadout/mods/empty_sight" )
		RuiSetInt( currentOpticRui, "tier", 0 )
	}

	var swapIcon = Hud_GetChild( file.menu, "SwapIcon" )

	const float ruiScreenWidth = 1920.0
	const float ruiScreenHeight = 1080.0

	UISize screen		= GetScreenSize()
	float xScale        = screen.width / ruiScreenWidth
	float yScale		= screen.height / ruiScreenHeight

	vector cursorPos = GetCursorPosition()

	Hud_SetX( swapIcon, (cursorPos.x - ruiScreenWidth * 0.5) * xScale )
	Hud_SetY( swapIcon, (cursorPos.y - ruiScreenHeight * 0.5) * yScale )

	float buttonSpacing = 68.0
	float heightOffset	= (float(totalOptics - 1) * buttonSpacing) / 2.0

	Hud_SetY( file.buttons[0], Hud_GetY( file.currentOptic ) - heightOffset * yScale )

	foreach( button in file.buttons )
		RunClientScript( "UICallback_Arenas_BindOpticSlotButton", button )
}

void function ClientToUI_Arenas_CloseSelectOpticDialog()
{
	if ( MenuStack_Contains( file.menu ) )
		UICodeCallback_NavigateBack()
}

void function SelectOptic_CancelButton_Activate( var button )
{
	UICodeCallback_NavigateBack()
}

void function SelectOpticDialog_OnOpen()
{
	EmitUISound( SOUND_OPEN_OPTIC_SELECTOR )
}

void function SelectOpticDialog_OnClose()
{
	RunClientScript( "UICallback_Arenas_OpticSelectDialogueClose" )
}

void function OnBuyButtonClick( var button )
{
	if ( GetActiveMenu() != file.menu )
		return

	if ( !IsFullyConnected() )
		return

	if ( IsLobby() )
		return

	RunClientScript( "UICallback_Arenas_OnOpticSlotButtonClick", button )
}
