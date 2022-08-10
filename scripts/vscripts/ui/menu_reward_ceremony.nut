  

global function InitRewardCeremonyMenu
global function ShowRewardCeremonyDialog

#if DEV
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
	bool                    isForBattlePass
	bool                    isForQuest
	bool                    noShowLow

	table<var, BattlePassReward> buttonToItem
} file


void function InitRewardCeremonyMenu( var newMenuArg )
                                              
{
	var menu = GetMenu( "RewardCeremonyMenu" )
	file.menu = menu

	file.awardHeader = Hud_GetChild( menu, "Header" )
	file.awardPanel = Hud_GetChild( menu, "AwardsList" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, PassAwardsDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, PassAwardsDialog_OnClose )

	file.continueButton = Hud_GetChild( menu, "ContinueButton" )
	Hud_AddEventHandler( file.continueButton, UIE_CLICK, ContinueButton_OnActivate )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )

#if DEV
	AddMenuThinkFunc( newMenuArg, PassAwardsDialogAutomationThink )
#endif       
}


void function ShowRewardCeremonyDialog( string headerText, string titleText, string descText, array<BattlePassReward> awards, bool isForBattlePass, bool isForQuest, bool noShowLow, bool playSound )
{
	file.headerText = headerText
	file.titleText = titleText
	file.descText = descText
	file.displayAwards = clone awards
	file.isForBattlePass = isForBattlePass
	file.isForQuest = isForQuest
	file.noShowLow = noShowLow
	AdvanceMenu( GetMenu( "RewardCeremonyMenu" ) )

	if ( playSound )
	{
		ItemFlavor ornull activeBattlePass = GetActiveBattlePass()
		if ( activeBattlePass != null )
		{
			expect ItemFlavor( activeBattlePass )
			EmitUISound( GetGlobalSettingsString( ItemFlavor_GetAsset( activeBattlePass ), "levelUpSound" ) )
		}
	}
}


#if DEV
void function DEV_TestRewardCeremonyDialog( array<string> itemRefs, string headerText = "HEADER", string titleText = "TITLE", string descText = "DESC" )
{
	array<BattlePassReward> rewards
	foreach ( itemRef in itemRefs )
	{
		BattlePassReward info
		info.level = -1
		ItemFlavor flav = GetItemFlavorByHumanReadableRef( itemRef )
		if ( ItemFlavor_GetType( flav ) == eItemType.character )
		{
			ItemFlavor overrideSkin = GetDefaultItemFlavorForLoadoutSlot( EHI_null, Loadout_CharacterSkin( flav ) )
			info.flav = overrideSkin
		}
		else
		{
			info.flav = GetItemFlavorByHumanReadableRef( itemRef )
		}
		info.quantity = 1
		rewards.append( info )
	}

	bool isForBattlePass = true
	bool isForQuest = false

	ShowRewardCeremonyDialog(
		headerText,
		titleText,
		descText,
		rewards,
		isForBattlePass,
		isForQuest,
		true,
		true
	)
}
#endif


void function PassAwardsDialog_OnOpen()
{
	UI_SetPresentationType( ePresentationType.BATTLE_PASS )

	Assert( file.displayAwards.len() != 0 )

	if ( file.isForBattlePass )
	{
		ItemFlavor ornull bpFlav = GetPlayerLastActiveBattlePass( LocalClientEHI() )
		if ( bpFlav != null )
		{
			Remote_ServerCallFunction( "ClientCallback_UpdateBattlePassLastInfo", ItemFlavor_GetGUID( expect ItemFlavor(bpFlav) ) )
		}
	}

	RegisterButtonPressedCallback( BUTTON_A, ContinueButton_OnActivate )
	RegisterButtonPressedCallback( KEY_SPACE, ContinueButton_OnActivate )

	PassAwardsDialog_UpdateAwards()
}

#if DEV
void function PassAwardsDialogAutomationThink( var menu )
{
	if (AutomateUi())
	{
		printt("PassAwardsDialogAutomationThink ContinueButton_OnActivate()")
		ContinueButton_OnActivate(null)
	}
}
#endif       

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


void function PassAwardsDialog_UpdateAwards()
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

	bool showButtons = file.isForBattlePass || file.isForQuest
	if ( file.displayAwards.len() == 1 && ItemFlavor_GetType( file.displayAwards[0].flav ) == eItemType.account_currency )
		showButtons = true                                   

	int numButtons = numAwards
	if ( !showButtons )
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
		HudElem_SetRuiArg( awardButton, "itemCountString", "" )
		if ( bpReward.quantity > 1 || ItemFlavor_GetType( bpReward.flav ) == eItemType.account_currency )
		{
			rarity = 0
			HudElem_SetRuiArg( awardButton, "itemCountString", FormatAndLocalizeNumber( "1", float( bpReward.quantity ), true ) )
		}
		HudElem_SetRuiArg( awardButton, "rarity", rarity )
		RuiSetImage( Hud_GetRui( awardButton ), "buttonImage", CustomizeMenu_GetRewardButtonImage( bpReward.flav ) )

		if ( ItemFlavor_GetType( bpReward.flav ) == eItemType.account_pack )
			HudElem_SetRuiArg( awardButton, "isLootBox", true )
		else
			HudElem_SetRuiArg( awardButton, "isLootBox", false )

		BattlePass_PopulateRewardButton( bpReward, awardButton, true, false )

		Hud_AddEventHandler( awardButton, UIE_GET_FOCUS, PassAward_OnFocusAward )


		if ( index == 0 )
			PassAward_OnFocusAward( awardButton )
	}
}


void function PassAward_OnFocusAward( var button )
{
	ItemFlavor item = file.buttonToItem[button].flav
	int level       = file.buttonToItem[button].level

	PresentItem( item, level )
}


void function PresentItem( ItemFlavor item, int level )
{
	if ( ItemFlavor_GetType( item ) == eItemType.character )
	{
		ItemFlavor overrideSkin = GetDefaultItemFlavorForLoadoutSlot( EHI_null, Loadout_CharacterSkin( item ) )
		item = overrideSkin
	}

	bool showLow = (!file.noShowLow && (!file.isForBattlePass || Battlepass_ShouldShowLow( item )))
	showLow = showLow || ItemFlavor_GetType( item ) == eItemType.emote_icon || ItemFlavor_GetType( item ) == eItemType.character_skin

	RunClientScript( "UIToClient_ItemPresentation", ItemFlavor_GetGUID( item ), level, 1.21, showLow, Hud_GetChild( file.menu, "LoadscreenImage" ), true, "battlepass_center_ref" )
}


