global function InitSelectSlotEmotesPanel

const int MAX_PURCHASE_BUTTONS = 8

struct
{
	var panel
	array<var> buttonList
	var displayItem
	var swapIcon
} file

void function InitSelectSlotEmotesPanel( var panel )
{
	file.panel = panel

	for ( int purchaseButtonIdx = 0; purchaseButtonIdx < MAX_PURCHASE_BUTTONS; purchaseButtonIdx++ )
	{
		var button = Hud_GetChild( panel, "PurchaseButton" + purchaseButtonIdx )

		Hud_AddEventHandler( button, UIE_CLICK, PurchaseButton_Activate )
		Hud_AddEventHandler( button, UIE_CLICKRIGHT, PurchaseButton_Activate )
		Hud_AddEventHandler( button, UIE_GET_FOCUS, PurchaseButton_OnFocus )
		Hud_AddEventHandler( button, UIE_LOSE_FOCUS, PurchaseButton_LoseFocus )

		file.buttonList.append( button )
	}

	Hud_AddEventHandler( Hud_GetChild( panel, "DarkenBackground" ), UIE_CLICK, SelectSlot_CancelButton_Activate )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, SelectSlotDefault_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, SelectSlotDefault_OnHide )

	file.displayItem = Hud_GetChild( panel, "DisplayItem" )
	file.swapIcon = Hud_GetChild( panel, "SwapIcon" )
	RuiSetImage( Hud_GetRui( file.swapIcon ), "basicImage", $"rui/hud/loot/loot_swap_icon" )
}

void function PurchaseButton_Activate( var button )
{
	int index = int(Hud_GetScriptID( button ))
	SelectSlot_GetEquipFunc()( index )
	CloseActiveMenu()
}

void function SelectSlotDefault_OnShow( var panel )
{
	SelectSlot_Common_AdjustButtons( panel, file.buttonList, file.displayItem, file.swapIcon )

	for ( int i=0; i<file.buttonList.len(); i++ )
	{
		var button = file.buttonList[ i ]
		UpdateFocusButton( button )
	}

	RuiDestroyNestedIfAlive( Hud_GetRui( file.displayItem ), "badgeUIHandle" )

	ApplyItemToButton( file.displayItem, SelectSlot_GetItem() )
}

void function SelectSlotDefault_OnHide( var panel )
{
}

void function PurchaseButton_OnFocus( var button )
{
	int index = int(Hud_GetScriptID( button ))

	array< LoadoutEntry > loadoutEntries = SelectSlot_GetLoadoutEntries()

	if ( index >= loadoutEntries.len() )
		return

	ApplyItemToButton( button, SelectSlot_GetItem() )

	ItemFlavor itemInButton = LoadoutSlot_GetItemFlavor( LocalClientEHI(), loadoutEntries[ index ] )

	for ( int i=0; i<loadoutEntries.len(); i++ )
	{
		var bt = file.buttonList[ i ]
		if ( bt == button )
			continue

		ItemFlavor flav = LoadoutSlot_GetItemFlavor( LocalClientEHI(), loadoutEntries[i] )
		if ( flav == SelectSlot_GetItem() )
		{
			ApplyItemToButton( bt, itemInButton )
		}
	}
}

void function PurchaseButton_LoseFocus( var button )
{
	foreach ( bt in file.buttonList )
		UpdateFocusButton( bt )
}

void function UpdateFocusButton( var button )
{
	int index = int(Hud_GetScriptID( button ))

	array< LoadoutEntry > loadoutEntries = SelectSlot_GetLoadoutEntries()

	if ( index < loadoutEntries.len() )
	{
		Hud_Show( button )

		ItemFlavor flavor = LoadoutSlot_GetItemFlavor( LocalClientEHI(), loadoutEntries[ index ] )

		ApplyItemToButton( button, flavor )
	}
	else
	{
		Hud_Hide( button )
	}
}

void function ApplyItemToButton( var button, ItemFlavor flavor )
{
	RuiDestroyNestedIfAlive( Hud_GetRui( button ), "badgeUIHandle" )

	string name = ItemFlavor_GetShortName( flavor )
	if ( name == "" )
		name = ItemFlavor_GetLongName( flavor )

	int itemType = ItemFlavor_GetType( flavor )
	if ( itemType == eItemType.gladiator_card_kill_quip || itemType == eItemType.gladiator_card_intro_quip )
		name = ItemFlavor_GetLongName( flavor )
	else
		CreateNestedRuiForQuip( Hud_GetRui( button ), "badgeUIHandle", flavor )

	HudElem_SetRuiArg( button, "buttonText", name )
}