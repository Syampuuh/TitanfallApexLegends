global function LoadoutSelectionOptics_InitSelectOpticDialog
global function ClientToUI_LoadoutSelectionOptics_OpenSelectOpticDialog
global function ClientToUI_LoadoutSelectionOptics_CloseSelectOpticDialog
global function LoadoutSelectionOptics_CancelButton_Activate

const string SOUND_OPEN_OPTIC_SELECTOR		= "ui_arenas_ingame_inventory_Optic_Selection_Open"

struct
{
	var menu
	var currentLoadoutButton
	array<var> weapon0OpticButtons
	array<var> weapon1OpticButtons

	int currentLoadoutIndex = -1

} file

void function LoadoutSelectionOptics_InitSelectOpticDialog( var newMenuArg )
{
	var menu = newMenuArg
	file.menu = menu

	SetDialog( menu, true )
	SetClearBlur( menu, false )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, SelectOpticDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, SelectOpticDialog_OnClose )

	Hud_AddEventHandler( Hud_GetChild( menu, "DarkenBackground" ), UIE_CLICK, LoadoutSelectionOptics_CancelButton_Activate )

	file.weapon0OpticButtons = GetElementsByClassname( file.menu, "Weapon0OpticButton" )
	foreach ( button in file.weapon0OpticButtons )
	{
		AddButtonEventHandler( button, UIE_CLICK, OnConfirmButtonClick )
	}

	file.weapon1OpticButtons = GetElementsByClassname( file.menu, "Weapon1OpticButton" )
	foreach ( button in file.weapon1OpticButtons )
	{
		AddButtonEventHandler( button, UIE_CLICK, OnConfirmButtonClick )
	}

	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#CLOSE" )
}

void function ClientToUI_LoadoutSelectionOptics_OpenSelectOpticDialog( int loadoutIndex )
{
	AdvanceMenu( file.menu )

	RunClientScript( "ServerCallback_LoadoutSelection_FinishedProcessingClickEvent" )

	const float ruiScreenWidth = 1920.0
	const float ruiScreenHeight = 1080.0

	UISize screen		= GetScreenSize()
	float xScale        = screen.width / ruiScreenWidth
	float yScale		= screen.height / ruiScreenHeight

	int widgetHeight = Hud_GetHeight( Hud_GetChild( file.menu, "OpticPane" ) )
	int widgetWidth = Hud_GetWidth( Hud_GetChild( file.menu, "OpticPane" ) )


	float xBounds = ( ( screen.width ) / 2 ) - ( ( widgetWidth ) / 2.0 )
	float yBounds = ( ( screen.height ) / 2 ) - ( ( widgetHeight ) / 2.0 )

	vector cursorPos = GetCursorPosition()

	                           
	var opticAnchor = Hud_GetChild( file.menu, "OpticAnchor" )
	Hud_SetX( opticAnchor, clamp( ( cursorPos.x - ruiScreenWidth  * 0.5 ) * xScale, -1 * xBounds, xBounds ) )
	Hud_SetY( opticAnchor, clamp( ( cursorPos.y - ruiScreenHeight * 0.5 ) * yScale , -1 * yBounds, yBounds ) )

	var opticPane = Hud_GetChild( file.menu, "OpticPane" )
	var rui = Hud_GetRui( opticPane )
	string loadoutName = LoadoutSelection_GetLocalizedLoadoutHeader( loadoutIndex )
	RuiSetString( rui, "name", loadoutName )


	          
	foreach( button in file.weapon0OpticButtons )
		RunClientScript( "UICallback_LoadoutSelection_BindOpticSlotButton", button, 0 )

	RunClientScript( "UICallback_LoadoutSelection_BindWeaponElement", Hud_GetChild( file.menu, "Weapon0" ), 0 )

	          
	foreach( button in file.weapon1OpticButtons )
		RunClientScript( "UICallback_LoadoutSelection_BindOpticSlotButton", button, 1 )

	RunClientScript( "UICallback_LoadoutSelection_BindWeaponElement", Hud_GetChild( file.menu, "Weapon1" ), 1 )

	             
	file.currentLoadoutButton = LoadoutSelectionMenu_GetLoadoutButtonByIndex( loadoutIndex )
	file.currentLoadoutIndex = loadoutIndex
}

void function ClientToUI_LoadoutSelectionOptics_CloseSelectOpticDialog()
{
	if ( MenuStack_Contains( file.menu ) )
		UICodeCallback_NavigateBack()
}

void function LoadoutSelectionOptics_CancelButton_Activate( var button )
{
	UICodeCallback_NavigateBack()
}

void function SelectOpticDialog_OnOpen()
{
	EmitUISound( SOUND_OPEN_OPTIC_SELECTOR )
}

void function SelectOpticDialog_OnClose()
{
	RunClientScript( "UICallback_LoadoutSelection_OpticSelectDialogueClose" )
}

void function OnConfirmButtonClick( var button )
{
	if ( GetActiveMenu() != file.menu )
		return

	if ( !IsFullyConnected() )
		return

	if ( IsLobby() )
		return

	int weaponIndex = -1

	if ( file.weapon0OpticButtons.contains( button ) )
		weaponIndex = 0
	else if ( file.weapon1OpticButtons.contains( button ) )
		weaponIndex = 1

	var currentWeaponElement = LoadoutSelectionMenu_GetWeaponElementByIndex( file.currentLoadoutIndex, weaponIndex )
	RunClientScript( "UICallback_LoadoutSelection_OnOpticSlotButtonClick", button, file.currentLoadoutButton, weaponIndex, currentWeaponElement )

	array<var> opticButtons = (weaponIndex == 0)?  file.weapon0OpticButtons:  file.weapon1OpticButtons
	foreach( opticButton in opticButtons )
		RunClientScript( "UICallback_LoadoutSelection_BindOpticSlotButton", opticButton, weaponIndex)

}
