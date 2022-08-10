global function InitSelectSlotDefaultPanel

const int MAX_PURCHASE_BUTTONS = 8

struct
{
	var panel
	array<var> buttonList
	var displayItem
	var swapIcon

	bool badgeMode

} file

void function InitSelectSlotDefaultPanel( var panel )
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
	vector cp = SelectSlot_GetCursorPos()

	array< LoadoutEntry > loadoutEntries = SelectSlot_GetLoadoutEntries()

	SelectSlot_Common_AdjustButtons( panel, file.buttonList, file.displayItem, file.swapIcon )

	                                      

	file.badgeMode = false

	bool useShortButtons = false

	if ( loadoutEntries.len() > 0 )
	{
		ItemFlavor flavor = LoadoutSlot_GetItemFlavor( LocalClientEHI(), loadoutEntries[ 0 ] )

		int type = ItemFlavor_GetType( flavor )

		if ( type == eItemType.gladiator_card_badge )
			file.badgeMode = true
		else if ( type == eItemType.gladiator_card_kill_quip || type == eItemType.gladiator_card_intro_quip )
			useShortButtons = true
	}

	foreach ( button in file.buttonList )
	{
		if ( file.badgeMode )
			Hud_SetWidth( button, Hud_GetHeight( button ) )
		else
		{
			Hud_SetWidth( button, Hud_GetBaseWidth( button ) )

			if ( useShortButtons )
				Hud_SetHeight( button, Hud_GetBaseHeight( button ) * 0.7 )
			else
				Hud_SetHeight( button, Hud_GetBaseHeight( button ) )
		}
	}

	if ( file.badgeMode )
	{
		Hud_SetWidth( file.displayItem, Hud_GetBaseHeight( file.displayItem ) * 2 )
		Hud_SetHeight( file.displayItem, Hud_GetBaseHeight( file.displayItem ) * 2 )
	}
	else
	{
		Hud_SetWidth( file.displayItem, Hud_GetBaseWidth( file.displayItem ) )

		if ( useShortButtons )
			Hud_SetHeight( file.displayItem, Hud_GetBaseHeight( file.displayItem ) * 0.7 )
		else
			Hud_SetHeight( file.displayItem, Hud_GetBaseHeight( file.displayItem ) )
	}

	for ( int i=0; i<file.buttonList.len(); i++ )
	{
		var button = file.buttonList[ i ]
		UpdateFocusButton( button )
	}

	RuiDestroyNestedIfAlive( Hud_GetRui( file.displayItem ), "badgeUIHandle" )

	ApplyItemToButton( file.displayItem, SelectSlot_GetItem() )

	HudElem_SetRuiArg( file.displayItem, "bgVisible", !file.badgeMode )
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
	{
		UpdateFocusButton( bt )
	}
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
	int index = int(Hud_GetScriptID( button ))

	RuiDestroyNestedIfAlive( Hud_GetRui( button ), "badgeUIHandle" )

	if ( file.badgeMode )
	{
		ItemFlavor character = expect ItemFlavor( SelectSlot_GetCharacter() )
		HudElem_SetRuiArg( button, "buttonText", "" )
		CreateNestedGladiatorCardBadge( Hud_GetRui( button ), "badgeUIHandle", LocalClientEHI(), flavor, index, character )
	}
	else
	{
		string name = ItemFlavor_GetShortName( flavor )
		int type = ItemFlavor_GetType( flavor )
		if ( type == eItemType.gladiator_card_kill_quip || type == eItemType.gladiator_card_intro_quip || name == "" )
			name  = ItemFlavor_GetLongName( flavor )

		HudElem_SetRuiArg( button, "buttonText", name )
	}
}