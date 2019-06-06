//

global function InitRewardCeremonyMenu
global function ShowRewardCeremonyDialog

#if(DEV)
global function DEV_TestRewardCeremonyDialog
#endif


struct
{
	var menu
	var awardPanel
	var awardHeader
	var continueButton

	string                  headerText
	string                  titleText
	string                  descText
	array<BattlePassReward> displayAwards = []
	bool                    showRewardTrack

	table<var, BattlePassReward> buttonToItem

} file


void function InitRewardCeremonyMenu()
{
	var menu = GetMenu( "RewardCeremonyMenu" )

	file.awardHeader = Hud_GetChild( menu, "Header" )
	file.awardPanel = Hud_GetChild( menu, "AwardsList" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, PassAwardsDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, PassAwardsDialog_OnClose )

	file.continueButton = Hud_GetChild( menu, "ContinueButton" )
	Hud_AddEventHandler( file.continueButton, UIE_CLICK, ContinueButton_OnActivate )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}


void function ShowRewardCeremonyDialog( string headerText, string titleText, string descText, array<BattlePassReward> awards, bool showRewardTrack )
{
	file.headerText = headerText
	file.titleText = titleText
	file.descText = descText
	file.displayAwards = clone awards
	file.showRewardTrack = showRewardTrack
	AdvanceMenu( GetMenu( "RewardCeremonyMenu" ) )
}


#if(DEV)
void function DEV_TestRewardCeremonyDialog( string itemRef, string headerText = "HEADER", string titleText = "TITLE", string descText = "DESC" )
{
	BattlePassReward rewardInfo
	rewardInfo.level = -1
	rewardInfo.flav = GetItemFlavorByHumanReadableRef( itemRef )
	rewardInfo.quantity = 1
	ShowRewardCeremonyDialog(
		headerText,
		titleText,
		descText,
		[rewardInfo],
		false )
}
#endif


void function PassAwardsDialog_OnOpen()
{
	UI_SetPresentationType( ePresentationType.BATTLE_PASS )

	Assert( file.displayAwards.len() != 0 )

	ClientCommand( "UpdateBattlePassLastEarnedXP" )
	ClientCommand( "UpdateBattlePassLastPurchasedXP" )
	ClientCommand( "UpdateBattlePassLastSeenPremium" )

	RegisterButtonPressedCallback( BUTTON_A, ContinueButton_OnActivate )
	RegisterButtonPressedCallback( KEY_SPACE, ContinueButton_OnActivate )

	PassDialog_UpdateAwards()

	EmitUISound( "UI_Menu_BattlePass_LevelUp" )
}


void function ContinueButton_OnActivate( var button )
{
	CloseActiveMenu()
}


void function PassAwardsDialog_OnClose()
{
	file.displayAwards = []

	DeregisterButtonPressedCallback( BUTTON_A, ContinueButton_OnActivate )
	DeregisterButtonPressedCallback( KEY_SPACE, ContinueButton_OnActivate )
}


void function PassDialog_UpdateAwards()
{
	HudElem_SetRuiArg( file.awardHeader, "headerText", file.headerText )
	HudElem_SetRuiArg( file.awardHeader, "titleText", file.titleText )
	HudElem_SetRuiArg( file.awardHeader, "descText", file.descText )

	var scrollPanel = Hud_GetChild( file.awardPanel, "ScrollPanel" )

	foreach ( button, _ in file.buttonToItem )
	{
		Hud_RemoveEventHandler( button, UIE_GET_FOCUS, PassAward_OnFocusAward )
	}
	file.buttonToItem.clear()

	int numAwards = file.displayAwards.len()

	int numButtons = numAwards
	if ( !file.showRewardTrack )
	{
		numButtons = 0
		PresentItem( file.displayAwards[0].flav, file.displayAwards[0].level )
	}
	Hud_InitGridButtonsDetailed( file.awardPanel, numButtons, 1, maxint( 1, minint( numButtons, 8 ) ) )
	Hud_SetHeight( file.awardPanel, Hud_GetHeight( file.awardPanel ) * 1.3 )
	for ( int index = 0; index < numButtons; index++ )
	{
		var awardButton = Hud_GetChild( scrollPanel, "GridButton" + index )

		BattlePassReward bpReward = file.displayAwards[index]
		file.buttonToItem[awardButton] <- bpReward

		HudElem_SetRuiArg( awardButton, "isOwned", true )
		HudElem_SetRuiArg( awardButton, "isPremium", bpReward.isPremium )

		int rarity = ItemFlavor_HasQuality( bpReward.flav ) ? ItemFlavor_GetQuality( bpReward.flav ) : 0
		HudElem_SetRuiArg( awardButton, "rarity", rarity )
		RuiSetImage( Hud_GetRui( awardButton ), "buttonImage", GetImageForBattlePassReward( bpReward ) )

		if ( ItemFlavor_GetType( bpReward.flav ) == eItemType.account_pack )
			HudElem_SetRuiArg( awardButton, "isLootBox", true )

		HudElem_SetRuiArg( awardButton, "itemCountString", "" )
		if ( ItemFlavor_GetType( bpReward.flav ) == eItemType.account_currency )
			HudElem_SetRuiArg( awardButton, "itemCountString", string( bpReward.quantity ) )

		Hud_AddEventHandler( awardButton, UIE_GET_FOCUS, PassAward_OnFocusAward )

		if ( index == 0 )
			PassAward_OnFocusAward( awardButton )
	}
}


void function PassAward_OnFocusAward( var button )
{
	ItemFlavor item = file.buttonToItem[button].flav
	int level = file.buttonToItem[button].level
	PresentItem( item, level )
}


void function PresentItem( ItemFlavor item, int level )
{
	bool showLow = !file.showRewardTrack
	RunClientScript( "UIToClient_ItemPresentation", ItemFlavor_GetGUID( item ), level, showLow )
}


