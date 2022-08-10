global function InitSelectSlotDialog
global function OpenSelectSlotDialog

global function SelectSlot_GetCursorPos
global function SelectSlot_GetItem
global function SelectSlot_GetCharacter
global function SelectSlot_GetLoadoutEntries
global function SelectSlot_GetEquipFunc

global function SelectSlot_CancelButton_Activate
global function SelectSlot_Common_AdjustButtons

struct
{
	var menu
	table<string,var> panels

	bool badgeMode

	vector 			cursorPos
	ItemFlavor& 	item
	ItemFlavor ornull 	character
	array< LoadoutEntry > loadoutEntries
	void functionref( int ) equipFunc
} file

void function InitSelectSlotDialog( var newMenuArg )
{
	var menu = newMenuArg
	file.menu = menu

	SetDialog( menu, true )
	SetClearBlur( menu, false )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, SelectSlotDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, SelectSlotDialog_OnClose )

	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#CLOSE" )

	file.panels[ "default" ] <- Hud_GetChild( menu, "SelectSlotDefault" )
	file.panels[ "emotes" ] <- Hud_GetChild( menu, "SelectSlotEmotes" )

	RegisterSignal( "TryOpenSelectSlotDialog" )
}

void function OpenSelectSlotDialog( array<LoadoutEntry> loadoutEntries, ItemFlavor item, ItemFlavor ornull character, void functionref( int ) equipFunc )
{
	file.item = item
	file.loadoutEntries = loadoutEntries
	file.equipFunc = equipFunc
	file.character = character

	thread __TryOpenSelectSlotDialog()
}

void function __TryOpenSelectSlotDialog()
{
	Signal( uiGlobal.signalDummy, "TryOpenSelectSlotDialog" )
	EndSignal( uiGlobal.signalDummy, "TryOpenSelectSlotDialog" )

	bool waited = false

	while ( IsDialog( GetActiveMenu() ) )
	{
		if ( GetActiveMenu() == file.menu )
			return

		WaitFrame()

		waited = true
	}

	file.cursorPos = GetCursorPosition()

	if ( waited )
		file.cursorPos = < 1920.0 / 2.0 , 1080.0 / 2.0, 0 >

	string panelName = "default"
	if ( file.loadoutEntries.len() > 0 && file.character != null )
	{
		LoadoutEntry slot1 = file.loadoutEntries[0]
		ItemFlavor character = expect ItemFlavor( file.character )

		if ( slot1 == Loadout_CharacterQuip( character, 0 ) || slot1 == Loadout_SkydiveEmote( character, 0 ) )
			panelName = "emotes"
	}

	AdvanceMenu( file.menu )

	foreach ( key, panel in file.panels )
	{
		if ( key == panelName )
			ShowPanel( panel )
		else
			HidePanel( panel )
	}
}

void function SelectSlot_CancelButton_Activate( var button )
{
	UICodeCallback_NavigateBack()
}

void function SelectSlotDialog_OnOpen()
{
}

void function SelectSlotDialog_OnClose()
{

}

vector function SelectSlot_GetCursorPos()
{
	return file.cursorPos
}

ItemFlavor function SelectSlot_GetItem()
{
	return file.item
}

ItemFlavor ornull function SelectSlot_GetCharacter()
{
	return file.character
}

array< LoadoutEntry > function SelectSlot_GetLoadoutEntries()
{
	return file.loadoutEntries
}

void functionref( int ) function SelectSlot_GetEquipFunc()
{
	return file.equipFunc
}

void function SelectSlot_Common_AdjustButtons( var panel, array<var> buttonList, var displayItem, var swapIcon )
{
	vector cp = SelectSlot_GetCursorPos()

	array< LoadoutEntry > loadoutEntries = SelectSlot_GetLoadoutEntries()

	UISize screen = GetScreenSize()

	float xScale       = screen.width / 1920.0
	float yScale       = screen.height / 1080.0
	float heightAdjust = (( Hud_GetHeight( buttonList[ 0 ] ) + Hud_GetY( buttonList[ 1 ] ) ) * float( loadoutEntries.len() ) * 0.5) - ( Hud_GetHeight( buttonList[ 0 ] ) * 0.5 )

	float xMargin = (Hud_GetWidth( buttonList[ 0 ] ) * 1.2) / xScale
	float yMargin = (Hud_GetHeight( buttonList[ 0 ] ) * float( loadoutEntries.len() ) * 0.5 * 1.2) / yScale

	vector cpAdjusted = <
	Clamp( cp.x, xMargin, 1920.0 - xMargin ),
	Clamp( cp.y, yMargin, 1080.0 - yMargin ),
	0
	>

	int xp = int(-xScale * cpAdjusted.x)
	int yp = int(-yScale * cpAdjusted.y)

	Hud_SetX( buttonList[ 0 ], xp - 0.0 - Hud_GetWidth( swapIcon ) )
	Hud_SetY( buttonList[ 0 ], yp + int( heightAdjust ) )

	Hud_SetX( displayItem, xp + 0.0 + Hud_GetWidth( swapIcon ) )
	Hud_SetY( displayItem, yp )

	Hud_SetX( swapIcon, xp )
	Hud_SetY( swapIcon, yp )
}