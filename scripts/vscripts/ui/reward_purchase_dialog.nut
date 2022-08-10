global function InitRewardPurchaseDialog
global function RewardPurchaseDialog

global struct RewardPurchaseDialogConfig
{
	int functionref()         maxPurchasableLevelsCallback = null
	int functionref()         startingPurchaseLevelIdxCallback = null
	string functionref( int ) purchaseButtonTextCallback = null
	ItemFlavor functionref() getPurchaseFlavCallback = null

	ToolTipData toolTipDataMaxPurchase

	array<BattlePassReward> functionref( int, int ) rewardsCallback = null

	int    levelIndexStart
	int    startQuantity
	string quantityText
	string headerText
	string titleText
	string descText
	string quantityTextPlural
	string titleTextPlural
	string descTextPlural
}

struct
{
	RewardPurchaseDialogConfig& rpdcfg
} file

struct
{
	var menu
	var rewardPanel
	var header
	var background

	var purchaseButton
	var inc1Button
	var inc5Button
	var dec1Button
	var dec5Button

	table<var, BattlePassReward> buttonToItem

	int purchaseQuantity = 1

	bool closeOnGetTopLevel = false

} s_rewardPurchaseDialog


void function InitRewardPurchaseDialog( var menu )
{
	s_rewardPurchaseDialog.menu = menu
	s_rewardPurchaseDialog.rewardPanel = Hud_GetChild( menu, "RewardList" )
	s_rewardPurchaseDialog.header = Hud_GetChild( menu, "Header" )
	s_rewardPurchaseDialog.background = Hud_GetChild( menu, "Background" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, RewardPurchaseDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, RewardPurchaseDialog_OnClose )

	AddMenuEventHandler( menu, eUIEvent.MENU_GET_TOP_LEVEL, RewardPurchaseDialog_OnGetTopLevel )

	s_rewardPurchaseDialog.purchaseButton = Hud_GetChild( menu, "PurchaseButton" )
	Hud_AddEventHandler( s_rewardPurchaseDialog.purchaseButton, UIE_CLICK, RewardPurchaseButton_OnActivate )

	s_rewardPurchaseDialog.inc1Button = Hud_GetChild( menu, "Inc1Button" )
	Hud_AddEventHandler( s_rewardPurchaseDialog.inc1Button, UIE_CLICK, void function( var btn ) {
		UpdatePurchaseQuantity( 1 )
	} )
	s_rewardPurchaseDialog.inc5Button = Hud_GetChild( menu, "Inc5Button" )
	Hud_AddEventHandler( s_rewardPurchaseDialog.inc5Button, UIE_CLICK, void function( var btn ) {
		UpdatePurchaseQuantity( 5 )
	} )

	s_rewardPurchaseDialog.dec1Button = Hud_GetChild( menu, "Dec1Button" )
	Hud_AddEventHandler( s_rewardPurchaseDialog.dec1Button, UIE_CLICK, void function( var btn ) {
		UpdatePurchaseQuantity( -1 )
	} )
	s_rewardPurchaseDialog.dec5Button = Hud_GetChild( menu, "Dec5Button" )
	Hud_AddEventHandler( s_rewardPurchaseDialog.dec5Button, UIE_CLICK, void function( var btn ) {
		UpdatePurchaseQuantity( -5 )
	} )

	RuiSetString( Hud_GetRui( s_rewardPurchaseDialog.inc1Button ), "buttonText", "+1" )
	RuiSetString( Hud_GetRui( s_rewardPurchaseDialog.inc5Button ), "buttonText", "+5" )
	RuiSetString( Hud_GetRui( s_rewardPurchaseDialog.dec1Button ), "buttonText", "-1" )
	RuiSetString( Hud_GetRui( s_rewardPurchaseDialog.dec5Button ), "buttonText", "-5" )
	RuiSetString( Hud_GetRui( s_rewardPurchaseDialog.inc1Button ), "gamepadBindText", Localize( "%[R_TRIGGER|]%" ) )
	RuiSetString( Hud_GetRui( s_rewardPurchaseDialog.inc5Button ), "gamepadBindText", Localize( "%[R_SHOULDER|]%" ) )
	RuiSetString( Hud_GetRui( s_rewardPurchaseDialog.dec1Button ), "gamepadBindText", Localize( "%[L_TRIGGER|]%" ) )
	RuiSetString( Hud_GetRui( s_rewardPurchaseDialog.dec5Button ), "gamepadBindText", Localize( "%[L_SHOULDER|]%" ) )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_PURCHASE", "", RewardPurchaseButton_OnActivate )
	AddMenuFooterOption( menu, LEFT, BUTTON_TRIGGER_RIGHT, true, "", "", void function( var btn ) {
		UpdatePurchaseQuantity( 1 )
	} )
	AddMenuFooterOption( menu, LEFT, BUTTON_TRIGGER_LEFT, true, "", "", void function( var btn ) {
		UpdatePurchaseQuantity( -1 )
	} )
	AddMenuFooterOption( menu, LEFT, BUTTON_SHOULDER_RIGHT, true, "", "", void function( var btn ) {
		UpdatePurchaseQuantity( 5 )
	} )
	AddMenuFooterOption( menu, LEFT, BUTTON_SHOULDER_LEFT, true, "", "", void function( var btn ) {
		UpdatePurchaseQuantity( -5 )
	} )
}


void function RewardPurchaseDialog( RewardPurchaseDialogConfig rpdcfg )
{
	ItemFlavor purchaseFlav = rpdcfg.getPurchaseFlavCallback()

	if ( ItemFlavor_IsItemDisabledForGRX( purchaseFlav ) )
	{
		EmitUISound( "menu_deny" )
		return
	}

	file.rpdcfg = rpdcfg

	AdvanceMenu( GetMenu( "RewardPurchaseDialog" ) )
}


void function RewardPurchaseDialog_OnOpen()
{
	s_rewardPurchaseDialog.purchaseQuantity = 1

	if ( file.rpdcfg.startQuantity > 0 )
		s_rewardPurchaseDialog.purchaseQuantity = file.rpdcfg.startQuantity

	                                                                                                    
	                                                                 
	Hud_Show( s_rewardPurchaseDialog.rewardPanel )
	Hud_Show( s_rewardPurchaseDialog.header )
	Hud_Show( s_rewardPurchaseDialog.background )

	Hud_Show( s_rewardPurchaseDialog.purchaseButton )
	Hud_Show( s_rewardPurchaseDialog.inc1Button )
	Hud_Show( s_rewardPurchaseDialog.inc5Button )
	Hud_Show( s_rewardPurchaseDialog.dec1Button )
	Hud_Show( s_rewardPurchaseDialog.dec5Button )

	RewardPurchaseDialog_UpdateRewards()
}

void function RewardPurchaseDialog_OnClose()
{
	                                                                                                    
	                                                                 
	Hud_Hide( s_rewardPurchaseDialog.rewardPanel )
	Hud_Hide( s_rewardPurchaseDialog.header )
	Hud_Hide( s_rewardPurchaseDialog.background )

	Hud_Hide( s_rewardPurchaseDialog.purchaseButton )
	Hud_Hide( s_rewardPurchaseDialog.inc1Button )
	Hud_Hide( s_rewardPurchaseDialog.inc5Button )
	Hud_Hide( s_rewardPurchaseDialog.dec1Button )
	Hud_Hide( s_rewardPurchaseDialog.dec5Button )
}


void function RewardPurchaseDialog_OnGetTopLevel()
{
	if ( s_rewardPurchaseDialog.closeOnGetTopLevel )
	{
		s_rewardPurchaseDialog.closeOnGetTopLevel = false
		CloseActiveMenu()
	}
}


void function RewardPurchaseDialog_UpdateRewards()
{
	int startingPurchaseLevelIdx = file.rpdcfg.startingPurchaseLevelIdxCallback()
	int maxPurchasableLevels     = file.rpdcfg.maxPurchasableLevelsCallback()

	if ( s_rewardPurchaseDialog.purchaseQuantity == maxPurchasableLevels )
	{
		Hud_SetToolTipData( s_rewardPurchaseDialog.inc1Button, file.rpdcfg.toolTipDataMaxPurchase )
		Hud_SetToolTipData( s_rewardPurchaseDialog.inc5Button, file.rpdcfg.toolTipDataMaxPurchase )
	}
	else
	{
		Hud_ClearToolTipData( s_rewardPurchaseDialog.inc1Button )
		Hud_ClearToolTipData( s_rewardPurchaseDialog.inc5Button )
	}

	if ( s_rewardPurchaseDialog.purchaseQuantity == 1 )
	{
		HudElem_SetRuiArg( s_rewardPurchaseDialog.purchaseButton, "quantityText", Localize( file.rpdcfg.quantityText, s_rewardPurchaseDialog.purchaseQuantity ) )
		HudElem_SetRuiArg( s_rewardPurchaseDialog.header, "titleText", Localize( file.rpdcfg.titleText, s_rewardPurchaseDialog.purchaseQuantity ) )
		HudElem_SetRuiArg( s_rewardPurchaseDialog.header, "descText", Localize( file.rpdcfg.descText, s_rewardPurchaseDialog.purchaseQuantity, (startingPurchaseLevelIdx + file.rpdcfg.levelIndexStart) + s_rewardPurchaseDialog.purchaseQuantity ) )
		HudElem_SetRuiArg( s_rewardPurchaseDialog.background, "headerText", file.rpdcfg.headerText )
	}
	else
	{
		HudElem_SetRuiArg( s_rewardPurchaseDialog.purchaseButton, "quantityText", Localize( file.rpdcfg.quantityTextPlural, s_rewardPurchaseDialog.purchaseQuantity ) )
		HudElem_SetRuiArg( s_rewardPurchaseDialog.header, "titleText", Localize( file.rpdcfg.titleTextPlural, s_rewardPurchaseDialog.purchaseQuantity ) )
		HudElem_SetRuiArg( s_rewardPurchaseDialog.header, "descText", Localize( file.rpdcfg.descTextPlural, s_rewardPurchaseDialog.purchaseQuantity, (startingPurchaseLevelIdx + file.rpdcfg.levelIndexStart) + s_rewardPurchaseDialog.purchaseQuantity ) )
		HudElem_SetRuiArg( s_rewardPurchaseDialog.background, "headerText", file.rpdcfg.headerText )
	}

	string purchaseButtonText = file.rpdcfg.purchaseButtonTextCallback( s_rewardPurchaseDialog.purchaseQuantity )
	HudElem_SetRuiArg( s_rewardPurchaseDialog.purchaseButton, "buttonText", purchaseButtonText )

	array<BattlePassReward> rewards = file.rpdcfg.rewardsCallback( s_rewardPurchaseDialog.purchaseQuantity, startingPurchaseLevelIdx )

	var scrollPanel = Hud_GetChild( s_rewardPurchaseDialog.rewardPanel, "ScrollPanel" )

	s_rewardPurchaseDialog.buttonToItem.clear()

	int numRewards = rewards.len()

	Hud_InitGridButtonsDetailed( s_rewardPurchaseDialog.rewardPanel, numRewards, 2, minint( numRewards, 5 ) )
	for ( int index = 0; index < numRewards; index++ )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + index )

		BattlePassReward bpReward = rewards[ rewards.len() - 1 - index]
		s_rewardPurchaseDialog.buttonToItem[button] <- bpReward

		BattlePass_PopulateRewardButton( bpReward, button, true, false )

		ToolTipData toolTip
		toolTip.titleText = GetBattlePassRewardHeaderText( bpReward )
		toolTip.descText = GetBattlePassRewardItemName( bpReward )
		toolTip.rarity =  ItemFlavor_GetQuality( bpReward.flav )
		Hud_SetToolTipData( button, toolTip )
	}
}


void function RewardPurchaseButton_OnActivate( var something )
{
	if ( Hud_IsLocked( s_rewardPurchaseDialog.purchaseButton ) )
		return

	var focus = GetFocus()
	if ( focus == s_rewardPurchaseDialog.inc1Button || focus == s_rewardPurchaseDialog.inc5Button || focus == s_rewardPurchaseDialog.dec1Button || focus == s_rewardPurchaseDialog.dec5Button )
		return

	ItemFlavor purchaseFlav = file.rpdcfg.getPurchaseFlavCallback()

	if ( !GRX_GetItemPurchasabilityInfo( purchaseFlav ).isPurchasableAtAll )
	{
		Warning( "Expected offer in '%s'", ItemFlavor_GetHumanReadableRef( purchaseFlav ) )
		return
	}

	if ( IsDialog( GetActiveMenu() ) )
		CloseActiveMenu()

	PurchaseDialogConfig pdc
	pdc.flav = purchaseFlav
	pdc.quantity = s_rewardPurchaseDialog.purchaseQuantity
	pdc.markAsNew = false
	pdc.onPurchaseResultCallback = OnRewardPurchaseResult
	PurchaseDialog( pdc )
}


void function OnRewardPurchaseResult( bool wasSuccessful )
{
	if ( wasSuccessful )
		s_rewardPurchaseDialog.closeOnGetTopLevel = true
}


void function UpdatePurchaseQuantity( int delta )
{
	if ( delta == 0 )
		return

	if ( delta > 0 )
	{
		if ( !IsFullyConnected() )                                                                                   
			return

		int maxPurchasableLevels = file.rpdcfg.maxPurchasableLevelsCallback()
		s_rewardPurchaseDialog.purchaseQuantity = minint( s_rewardPurchaseDialog.purchaseQuantity + delta, maxPurchasableLevels )
	}
	else
	{
		s_rewardPurchaseDialog.purchaseQuantity = maxint( s_rewardPurchaseDialog.purchaseQuantity + delta, 1 )
	}

	RewardPurchaseDialog_UpdateRewards()
	EmitUISound( "UI_Menu_BattlePass_LevelIncreaseTab" )
}