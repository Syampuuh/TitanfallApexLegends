global function InitQuestPanel
global function ReadyUpWithQuestPlaylist
global function SeasonQuestTab_SetAutoOpenMissionButton
global function SCB_UpdateQuestPanelData

struct {
	table<var, array<BattlePassReward> > rewardButtonDataMap

	array<var> rewardButtons
	array<var> missionButtons
	array<var> completionRewardButtons

	bool callbacksAdded = false

	var panel
} file


void function InitQuestPanel( var panel )
{
	file.panel = panel

	SetupButtonEvents( panel )

	Hud_AddEventHandler( Hud_GetChild( panel, "IntroButton" ), UIE_CLICK, IntroButtonOnClick )

	SetPanelTabTitle( panel, "#EPISODES_TAB_TITLE" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, PanelEventOnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, PanelEventOnHide )
	AddPanelEventHandler_FocusChanged( panel, QuestPanel_OnFocusChanged )

	                                                  
	                                                                    
	                                                                      

	Hud_AddEventHandler( Hud_GetChild( panel, "PurchaseButton" ), UIE_CLICK, Quest_PurchaseButton_OnActivate )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_SELECT" )
}


void function PanelEventOnShow( var panel )
{
	UI_SetPresentationType( ePresentationType.QUEST_PANEL )
	RunClientScript( "ClearBattlePassItem" )

	                                          
	ItemFlavor ornull quest = SeasonQuest_GetActiveSeasonQuest( GetUnixTimestamp() )
	if ( quest == null )
	{
		Warning( "No season quest is active at this time." )
		return
	}
	expect ItemFlavor( quest )

	if ( !file.callbacksAdded )
	{
		AddCallbackAndCallNow_OnGRXOffersRefreshed( OnGRXStateChanged )
		AddCallbackAndCallNow_OnGRXInventoryStateChanged( OnGRXStateChanged )
		file.callbacksAdded = true
	}

	                                                                         
	var rui = Hud_GetRui( Hud_GetChild( panel, "QuestInfoBox" ) )
	RuiSetGameTime( rui, "startTime", ClientTime() )
	RuiSetImage( rui, "cornerImage", $"" )

	UpdatePanelData( panel )

	if ( s_autoOpenMissionButtonIndex >= 0 )
	{
		int doIndex = s_autoOpenMissionButtonIndex
		s_autoOpenMissionButtonIndex = -1
		MissionButtonOnClick( file.missionButtons[doIndex] )
	}

                          
	                                                    
	thread TryDisplayQuestFinalRewards()
      
}

int s_autoOpenMissionButtonIndex = -1
void function SeasonQuestTab_SetAutoOpenMissionButton( int buttonIndex )
{
	s_autoOpenMissionButtonIndex = buttonIndex
}


bool function ShouldPurchaseButtonBeVisible( ItemFlavor quest )
{
	entity player         = GetLocalClientPlayer()
                           
                                                                      

                         
              
      

	int boxesToPurchase = SeasonQuest_GetTreasurePacksMaxPurchableCountForPlayer( GetLocalClientPlayer(), quest )
	if ( boxesToPurchase <= 0 )
		return false
	if ( GRX_IsOfferRestricted() )
		return false
	return true
}


void function SCB_UpdateQuestPanelData()
{
	                                                             
	if ( IsValid( file.panel ) )
		UpdatePanelData( file.panel )
}


void function UpdatePanelData( var panel )
{
	if ( !GRX_IsInventoryReady() )
	{
		Warning( "Marketplace wasn't ready when the quest panel was shown." )
		return
	}

	ItemFlavor ornull quest = SeasonQuest_GetActiveSeasonQuest( GetUnixTimestamp() )
	if ( quest == null )
	{
		Warning( "No season quest is active at this time." )
		return
	}
	expect ItemFlavor( quest )

	entity player  = GetLocalClientPlayer()
	int missionsRead  = SeasonQuest_GetMissionsCompletedForPlayer( player, quest )
	int totalMissions = SeasonQuest_GetMissionsMaxCount( quest )


                          
	                                                                                         
	bool haveStartedQuest = true
     
                                                                    
                                                                      
      

	                  
	{
		var button     = Hud_GetChild( panel, "PurchaseButton" )
		bool isVisible = ShouldPurchaseButtonBeVisible( quest )
		Hud_SetVisible( button, isVisible )
		Hud_SetEnabled( button, isVisible )
		RuiSetString( Hud_GetRui( button ), "buttonText", (isVisible ? "#QUEST_PURCHASE_TREASURE_BOX" : "#QUEST_PURCHASE_UNAVAILABLE") )
	}

	               
	{
		var rui = Hud_GetRui( Hud_GetChild( panel, "QuestInfoBox" ) )

		RuiSetImage( rui, "cornerImage", SeasonQuest_Tab_GetCornerImage( quest ) )

		RuiSetString( rui, "questTitle", ItemFlavor_GetShortName( quest ) )
		RuiSetString( rui, "questDescription", SeasonQuest_Tab_GetLongDesc( quest ) )
		RuiSetGameTime( rui, "treasureBoxNextUnlockTime", ClientTime() + TreasureBox_SecondsUntilNextPickup( player, quest ) )
		int treasureBoxesTotal     = SeasonQuest_GetTreasurePacksMaxCount( quest )
		int treasureBoxesOwned     = SeasonQuest_GetTreasurePacksCountForPlayer( player, quest )
		int treasureBoxesRemaining = treasureBoxesTotal - treasureBoxesOwned
		RuiSetInt( rui, "treasureBoxesTotal", treasureBoxesTotal )
		RuiSetInt( rui, "treasureBoxesOwned", treasureBoxesOwned )

		RuiSetInt( rui, "missionsDone", missionsRead )
		RuiSetInt( rui, "missionsTotalMax", totalMissions )
		RuiSetBool( rui, "haveStartedQuest", haveStartedQuest )

		                 
		file.rewardButtonDataMap.clear()
		UpdateRewardTrackButtons( panel, true, treasureBoxesRemaining )
		UpdateMissionProgress ( panel )
		UpdateRewardsButtons(panel, treasureBoxesRemaining )
	}

	                
	{
		var button = Hud_GetChild( panel, "IntroButton" )
		var rui    = Hud_GetRui( button )

		Hud_SetVisible( button, !haveStartedQuest )
		RuiSetString( rui, "buttonText", "#QUEST_BEGIN_BUTTON" )
	}
}

void function IntroButtonOnClick( var button )
{
	ItemFlavor ornull quest = SeasonQuest_GetActiveSeasonQuest( GetUnixTimestamp() )
	if ( quest == null )
		return
	expect ItemFlavor( quest )

	SeasonQuest_AcknowledgeHaveStartedQuest( quest )

	UpdatePanelData( file.panel )
}


void function PanelEventOnHide( var panel )
{
	if ( file.callbacksAdded )
	{
		RemoveCallback_OnGRXOffersRefreshed( OnGRXStateChanged )
		RemoveCallback_OnGRXInventoryStateChanged( OnGRXStateChanged )
		file.callbacksAdded = false
	}
}


void function ReadyUpWithQuestPlaylist( string playlistName )
{
	                   
	TabData lobbyTabData = GetTabDataForPanel( GetMenu( "LobbyMenu" ) )
	ActivateTab( lobbyTabData, Tab_GetTabIndexByBodyName( lobbyTabData, "PlayPanel" ) )

	Lobby_SetSelectedPlaylist( playlistName )
	ReadyShortcut_OnActivate( null )
}


void function MissionButtonOnClick( var button )
{
	int startPageIndex = file.missionButtons.find( button )

	ItemFlavor ornull quest = SeasonQuest_GetActiveSeasonQuest( GetUnixTimestamp() )
	if ( quest == null )
	{
		Warning( "No season quest is active at this time." )
		return
	}
	expect ItemFlavor( quest )

	int status = SeasonQuest_GetStatusForMissionIndex( GetLocalClientPlayer(), quest, startPageIndex )
	if ( status < eQuestMissionStatus.LAUNCHABLE )
		return

	if ( status >= eQuestMissionStatus.LAUNCHABLE )
	{
		SeasonQuest_AcknowledgeQuestMissionRead( quest, startPageIndex )
		LoreReaderMenu_OpenTo( SeasonQuest_GetLoreSequenceStoryChapterDataForMissionIndex( quest, startPageIndex ) )
		return
	}
}

void function QuestPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) )                  
		return

	if ( !newFocus || GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()
}

void function Quest_PurchaseButton_OnActivate( var button )
{
	ItemFlavor ornull quest = SeasonQuest_GetActiveSeasonQuest( GetUnixTimestamp() )
	if ( quest == null || !GRX_IsInventoryReady() )
	{
		return
	}
	expect ItemFlavor( quest )

	                                        
	if ( SeasonQuest_GetTreasurePacksMaxPurchableCountForPlayer( GetLocalClientPlayer(), quest ) <= 0 )
		return

	if ( ItemFlavor_IsItemDisabledForGRX( quest ) )
	{
		EmitUISound( "menu_deny" )
		return
	}

	RewardPurchaseDialogConfig rpdcfg

	rpdcfg.purchaseButtonTextCallback = string function( int purchaseQuantity ) : ( quest ) {
		ItemFlavor boxPurchaseFlav              = SeasonQuest_GetTreasureBoxPurchaseFlav( quest )
		ItemFlavorPurchasabilityInfo ifpi       = GRX_GetItemPurchasabilityInfo( boxPurchaseFlav )
		string grxOfferLocation                 = SeasonQuest_GetGRXOfferLocation( quest )
		array<GRXScriptOffer> boxPurchaseOffers = GRX_GetItemDedicatedStoreOffers( boxPurchaseFlav, grxOfferLocation )
		Assert( boxPurchaseOffers.len() == 1 )
		if ( boxPurchaseOffers.len() < 1 )
		{
			Warning( "No offer for treasure packs for '%s'", ItemFlavor_GetHumanReadableRef( quest ) )
			return ""
		}
		GRXScriptOffer boxPurchaseOffer = boxPurchaseOffers[0]
		Assert( boxPurchaseOffer.prices.len() == 1 )
		if ( boxPurchaseOffer.prices.len() < 1 )
			return ""

		return GRX_GetFormattedPrice( boxPurchaseOffer.prices[0], purchaseQuantity )
	}

	rpdcfg.maxPurchasableLevelsCallback = int function() : ( quest ) {
		return SeasonQuest_GetTreasurePacksMaxPurchableCountForPlayer( GetLocalClientPlayer(), quest )
	}

	rpdcfg.startingPurchaseLevelIdxCallback = int function() : ( quest ) {
		return SeasonQuest_GetTreasurePacksCountForPlayer( GetLocalClientPlayer(), quest )                                                  
	}

	rpdcfg.rewardsCallback = array<BattlePassReward> function( int purchaseQuantity, int startingPurchaseLevelIdx ) : ( quest ) {
		array<BattlePassReward> rewards

		for ( int idx = 0; idx < purchaseQuantity; idx++ )
		{
			int sequenceNumNext = (startingPurchaseLevelIdx + idx)

			int boxIndex = sequenceNumNext                                            

			ItemFlavorBag rewardBag = SeasonQuest_GetTreasurePackRewardsForIndex( quest, boxIndex )
			foreach ( int itemsIndex, ItemFlavor item in rewardBag.flavors )
			{
				if ( ItemFlavor_GetType( item ) == eItemType.grx_sentinel )
					continue

				BattlePassReward info = ItemFlavorBagToBattlePassRewardByIndex( rewardBag, itemsIndex )
				info.level = -1
				rewards.append( info )
			}
		}
		return rewards
	}

	rpdcfg.getPurchaseFlavCallback = ItemFlavor function() : ( quest ) {
		return SeasonQuest_GetTreasureBoxPurchaseFlav( quest )
	}

	int maxPacks = SeasonQuest_GetTreasurePacksMaxCount( quest )

	rpdcfg.toolTipDataMaxPurchase.titleText = "#TREASUREBOX_MAX_PURCHASE_LEVEL"
	rpdcfg.toolTipDataMaxPurchase.descText = "#TREASUREBOX_MAX_PURCHASE_LEVEL_DESC"

	rpdcfg.levelIndexStart = 0
	rpdcfg.headerText = "#TREASUREBOX_YOU_WILL_RECEIVE"
	rpdcfg.quantityText = "#TREASUREBOX_PLUS_N_LEVEL"
	rpdcfg.titleText = "#TREASUREBOX_PURCHASE_LEVEL"
	rpdcfg.descText = Localize( "#TREASUREBOX_PURCHASE_LEVEL_DESC", maxPacks )
	rpdcfg.quantityTextPlural = "#TREASUREBOX_PLUS_N_LEVELS"
	rpdcfg.titleTextPlural = "#TREASUREBOX_PURCHASE_LEVEL"
	rpdcfg.descTextPlural = Localize( "#TREASUREBOX_PURCHASE_LEVEL_DESC", maxPacks )

	RewardPurchaseDialog( rpdcfg )
}

void function OnGRXStateChanged()
{
	bool ready = GRX_IsInventoryReady() && GRX_AreOffersReady() && IsPersistenceAvailable()

	if ( !ready )
		return

	var panel = GetActiveMenu()
	if ( panel == file.panel )
		UpdatePanelData( panel )

	thread TryDisplayTreasureBoxRewards()
}

void function SetupButtonEvents( var panel )
{
	var rewardsPanel = Hud_GetChild( panel, "RewardsPanel" )
	file.rewardButtons = GetPanelElementsByClassname( rewardsPanel, "RewardButton" )

	foreach ( int i, var button in file.rewardButtons )
	{
		Hud_AddEventHandler( button, UIE_CLICK, QuestPanel_RewardButton_OnActivate )
	}

	file.missionButtons = GetPanelElementsByClassname( panel, "MissionSelect" )
	foreach ( var button in file.missionButtons )
	{
		Hud_AddEventHandler( button, UIE_CLICK, MissionButtonOnClick )
	}

	file.completionRewardButtons = GetPanelElementsByClassname( panel, "CompletionReward" )
	foreach ( var button in file.completionRewardButtons )
	{
		Hud_AddEventHandler( button, UIE_CLICK, QuestPanel_RewardButton_OnActivate )
	}
}


void function QuestPanel_RewardButton_OnActivate( var button )
{
	if ( !(button in file.rewardButtonDataMap) )
		return

	if ( Hud_IsLocked( button ) )
		return

	foreach ( bpReward in file.rewardButtonDataMap[ button ] )
	{
		if ( ItemFlavor_GetType( bpReward.flav ) == eItemType.loadscreen )
		{
			LoadscreenPreviewMenu_SetLoadscreenToPreview( bpReward.flav )
			AdvanceMenu( GetMenu( "LoadscreenPreviewMenu" ) )
			return
		}
		else if ( ItemFlavor_GetType( bpReward.flav ) == eItemType.voucher )
		{
			return
		}
		else if ( InspectItemTypePresentationSupported( bpReward.flav ) )
		{
			RunClientScript( "ClearBattlePassItem" )
			SetTreasurePackItemPresentationModeActive( bpReward )
			return
		}
	}
}

void function UpdateMissionProgress( var panel )
{
	ItemFlavor ornull quest = SeasonQuest_GetActiveSeasonQuest( GetUnixTimestamp() )
	if ( quest == null )
	{
		foreach ( button in file.missionButtons )
		{
			Hud_SetVisible( button, false )
		}
		return
	}
	expect ItemFlavor( quest )

	entity player = GetLocalClientPlayer()

	int missionsCount = SeasonQuest_GetMissionsMaxCount( quest )
	bool firstNewMission = false

	                                                   
	foreach ( int missionIndex, var missionPageButton in file.missionButtons )
	{
		if ( missionIndex >= missionsCount )
		{
			Hud_SetVisible( missionPageButton, false )
			continue
		}
		Hud_SetVisible( missionPageButton, true )

		var btnRui = Hud_GetRui( missionPageButton )

		RuiSetBool( btnRui, "artifactButton", false )
		RuiSetInt( btnRui, "missionStatus", eQuestMissionStatus.INVALID )
		RuiSetImage( btnRui, "buttonImage", $"" )
		RuiSetString( btnRui, "buttonText", $"" )

		                                                                  
		int missionStatus = SeasonQuest_GetStatusForMissionIndex( player, quest, missionIndex )

		RuiSetImage( btnRui, "buttonImage", SeasonQuest_GetQuestItemIconForMissionIndex( quest, missionIndex ) )
		RuiSetString( btnRui, "buttonText", SeasonQuest_GetQuestItemNameForMissionIndex( quest, missionIndex ) )

		RuiSetInt( btnRui, "missionStatus", missionStatus )
		printt("missionPageStatus:", missionStatus)
		RuiSetBool( btnRui, "firstNewMission", false )
		if ( !firstNewMission && (missionStatus != eQuestMissionStatus.LOCKED) && (missionStatus != eQuestMissionStatus.COMPLETED) )
		{
			RuiSetBool( btnRui, "firstNewMission", true )
			firstNewMission = true
		}


		float unlockTime = ClientTime() + (SeasonQuest_GetUnlockTimeForMissionIndex( quest, missionIndex ) - GetUnixTimestamp())
		RuiSetGameTime( btnRui, "unlockTime", unlockTime )

		Hud_SetLocked( missionPageButton, missionStatus < eQuestMissionStatus.LAUNCHABLE )
		Hud_SetEnabled( missionPageButton, (missionStatus < eQuestMissionStatus.LAUNCHABLE)? false: true )
	}
}

void function UpdateRewardsButtons(var panel, int treasureBoxesRemaining)
{
	ItemFlavor ornull quest = SeasonQuest_GetActiveSeasonQuest( GetUnixTimestamp() )
	if ( quest == null )
	{
		return
	}
	expect ItemFlavor( quest )

	                              
	var completionRewardButton1
	var completionRewardButton2
	var completionRewardButton3
	bool hideBackground = false
	bool hasTreasureBoxs = treasureBoxesRemaining > 0
	Hud_SetVisible( Hud_GetChild( panel, "CompletionRewardButton1" ), hasTreasureBoxs )
	Hud_SetVisible( Hud_GetChild( panel, "CompletionRewardButton2" ), hasTreasureBoxs )
	Hud_SetVisible( Hud_GetChild( panel, "CompletionRewardButton3" ), hasTreasureBoxs )
	Hud_SetVisible( Hud_GetChild( panel, "CompletionRewardBigButton1" ), !hasTreasureBoxs )
	Hud_SetVisible( Hud_GetChild( panel, "CompletionRewardBigButton2" ), !hasTreasureBoxs )
	Hud_SetVisible( Hud_GetChild( panel, "CompletionRewardBigButton3" ), !hasTreasureBoxs )

	if(hasTreasureBoxs)
	{
		completionRewardButton1 = Hud_GetChild( panel, "CompletionRewardButton1" )
		completionRewardButton2 = Hud_GetChild( panel, "CompletionRewardButton2" )
		completionRewardButton3 = Hud_GetChild( panel, "CompletionRewardButton3" )
		hideBackground = true
	}
	else
	{
		completionRewardButton1 = Hud_GetChild( panel, "CompletionRewardBigButton1" )
		completionRewardButton2 = Hud_GetChild( panel, "CompletionRewardBigButton2" )
		completionRewardButton3 = Hud_GetChild( panel, "CompletionRewardBigButton3" )
		hideBackground = false
	}


	ItemFlavorBag rewardBag = SeasonQuest_GetCompletionRewards( quest )

	if ( rewardBag.flavors.len() > 0 )
	{
		BattlePassReward reward = ItemFlavorBagToBattlePassRewardByIndex( rewardBag, 0 )
		file.rewardButtonDataMap[ completionRewardButton1 ] <- [ reward ]
		BattlePass_PopulateRewardButton( reward, completionRewardButton1, !hasTreasureBoxs, false )

		var rui1 = Hud_GetRui( completionRewardButton1 )
		RuiSetBool( rui1, "hideBackground", hideBackground )

		ToolTipData toolTip1
		toolTip1.titleText = GetBattlePassRewardHeaderText( reward )
		toolTip1.descText = GetBattlePassRewardItemName( reward )
		toolTip1.tooltipFlags = eToolTipFlag.SOLID
		toolTip1.rarity = ItemFlavor_GetQuality( reward.flav )
		Hud_SetToolTipData( completionRewardButton1, toolTip1 )
	}
	else
	{
		Hud_SetVisible( completionRewardButton1, false )
		Warning( "%s() - rewardbag len is only %d, expected more.", FUNC_NAME(), rewardBag.flavors.len() )
	}

	if ( rewardBag.flavors.len() > 1 )
	{
		BattlePassReward reward = ItemFlavorBagToBattlePassRewardByIndex( rewardBag, 1 )
		file.rewardButtonDataMap[ completionRewardButton2 ] <- [ reward ]
		BattlePass_PopulateRewardButton( reward, completionRewardButton2, !hasTreasureBoxs, false )

		var rui1 = Hud_GetRui( completionRewardButton2 )
		RuiSetBool( rui1, "hideBackground", hideBackground )

		ToolTipData toolTip2
		toolTip2.titleText = GetBattlePassRewardHeaderText( reward )
		toolTip2.descText = GetBattlePassRewardItemName( reward )
		toolTip2.tooltipFlags = eToolTipFlag.SOLID
		toolTip2.rarity = ItemFlavor_GetQuality( reward.flav )
		Hud_SetToolTipData( completionRewardButton2, toolTip2 )
	}
	else
	{
		Hud_SetVisible( completionRewardButton2, false )
	}

	if ( rewardBag.flavors.len() > 2 )
	{
		BattlePassReward reward = ItemFlavorBagToBattlePassRewardByIndex( rewardBag, 2 )
		file.rewardButtonDataMap[ completionRewardButton3 ] <- [ reward ]
		BattlePass_PopulateRewardButton( reward, completionRewardButton3, !hasTreasureBoxs, false )

		var rui1 = Hud_GetRui( completionRewardButton3 )
		RuiSetBool( rui1, "hideBackground", hideBackground )

		ToolTipData toolTip3
		toolTip3.titleText = GetBattlePassRewardHeaderText( reward )
		toolTip3.descText = GetBattlePassRewardItemName( reward )
		toolTip3.tooltipFlags = eToolTipFlag.SOLID
		toolTip3.rarity = ItemFlavor_GetQuality( reward.flav )
		Hud_SetToolTipData( completionRewardButton3, toolTip3 )
	}
	else
	{
		Hud_SetVisible( completionRewardButton3, false )
	}

}

                          
void function UpdateLockedMissionsPanel( var panel, bool haveStartedQuest )
{
	                                                                                                    

	bool isLocked = false
	var lockedComicsPanel = Hud_GetChild( panel, "LockedComicsPanel" )

	ItemFlavor ornull quest = SeasonQuest_GetActiveSeasonQuest( GetUnixTimestamp() )
	if ( quest != null )
	{
		expect ItemFlavor( quest )

		const SECOND_COMIC_GROUP_INDEX = 3
		int unlockTime = SeasonQuest_GetUnlockTimeForComicIndex( quest, SECOND_COMIC_GROUP_INDEX )
		if ( unlockTime != INT_MAX )
		{
			int theTime = GetUnixTimestamp()
			isLocked = theTime < unlockTime

			foreach ( int comicPageIndex, var comicPageButton in file.missionButtons )
			{
				if ( comicPageIndex >= SECOND_COMIC_GROUP_INDEX )
				{
					Hud_SetEnabled( comicPageButton, !isLocked )

					var rui = Hud_GetRui( comicPageButton )
					RuiSetBool( rui, "isInTimeLockedGroup", isLocked )
				}
			}

			if ( isLocked )
			{
				TimeParts unlockTimeParts = GetUnixTimeParts( unlockTime )
				string month = Localize( MONTH_NAMES[unlockTimeParts.month - 1] ).toupper()
				string date = string( unlockTimeParts.day )

				var rui = Hud_GetRui( lockedComicsPanel )
				string unlockDateString = Localize( "#QUEST_UNLOCK_DAY_MONTH", month, date )

				RuiSetString( rui, "unlockDateString", unlockDateString )
			}
		}
	}

	Hud_SetVisible( lockedComicsPanel, isLocked && haveStartedQuest )
}
      

void function UpdateRewardTrackButtons( var panel, bool startedQuest, int treasureBoxesRemaining )
{
	ItemFlavor ornull quest = SeasonQuest_GetActiveSeasonQuest( GetUnixTimestamp() )
	if ( quest == null )
		return
	expect ItemFlavor( quest )

	entity player 			= GetLocalClientPlayer()
	bool hasPickedUpTodays 	= TreasureBox_SecondsUntilNextPickup(player, quest) > 0

	int boxIndex          	= SeasonQuest_GetTreasurePacksCountForPlayer( GetLocalClientPlayer(), quest )

	int todaysIndex 		= (hasPickedUpTodays)? boxIndex - 1: boxIndex

	                      
	int rewardButtonMaxCount = file.rewardButtons.len()                          
	int maxBoxCount       = SeasonQuest_GetTreasurePacksMaxCount( quest )

	int gridIndex = todaysIndex

	int activeButtonCount = minint( rewardButtonMaxCount, maxBoxCount - gridIndex )
	int rewardIndex = gridIndex

	for ( int index = 0; index < rewardButtonMaxCount; index++ )
	{
		if ( index >= activeButtonCount || !startedQuest || treasureBoxesRemaining == 0 )
		{
			var button = file.rewardButtons[index]
			Hud_Hide( button )
			Hud_SetEnabled( button, false )
		}
		else
		{
			ItemFlavorBag rewardBag = SeasonQuest_GetTreasurePackRewardsForIndex( quest, gridIndex++ )                                                               
			var button  = file.rewardButtons[index]
			file.rewardButtonDataMap[ button ] <- []
			foreach ( int rIdx, ItemFlavor reward in rewardBag.flavors )
			{
				if ( ItemFlavor_GetType( reward ) == eItemType.grx_sentinel )
					continue

				if ( index >= rewardButtonMaxCount )
					break                   

				BattlePassReward bpReward = ItemFlavorBagToBattlePassRewardByIndex( rewardBag, rIdx )
				file.rewardButtonDataMap[ button ].append( bpReward )
			}

			bool isPeekButton = (index > 10 )

			foreach ( int rIdx, ItemFlavor reward in rewardBag.flavors )
			{
				if ( ItemFlavor_GetType( reward ) == eItemType.grx_sentinel )
					continue

				if ( index >= rewardButtonMaxCount )
					break                   


				bool isOwned = rewardIndex < todaysIndex || (hasPickedUpTodays && rewardIndex == todaysIndex)

				BattlePassReward bpReward = ItemFlavorBagToBattlePassRewardByIndex( rewardBag, rIdx )
				BattlePass_PopulateRewardButton( bpReward, button, isOwned, false )

				ToolTipData toolTip
				toolTip.titleText = GetBattlePassRewardHeaderText( bpReward )
				toolTip.descText = GetBattlePassRewardItemName( bpReward )
				toolTip.tooltipFlags = eToolTipFlag.SOLID
				toolTip.rarity = ItemFlavor_GetQuality( bpReward.flav )
				Hud_SetToolTipData( button, toolTip )

				var btnRui = Hud_GetRui( button )

				                                          
				const MIN_ALPHA = 0.3
				float baseAlpha = (isPeekButton) ?MIN_ALPHA: 1.0

				RuiSetFloat3( btnRui, "colorMult", <baseAlpha, baseAlpha, baseAlpha> )
				RuiSetBool( btnRui, "dualReward", false )

				                                                                             
				if ( rewardBag.flavors.len() == 2 )
				{
					ItemFlavor reward2 = rewardBag.flavors[1]

					RuiSetBool( btnRui, "dualReward", true )
					RuiSetBool( btnRui, "forceFullIcon", false )
					RuiSetBool( btnRui, "isOwned", isOwned )

					RuiSetImage( btnRui, "buttonImage", $"rui/menu/quest/reward_box_comic_side" )
					RuiSetImage( btnRui, "buttonImage2", $"rui/menu/quest/reward_box_charm_side" )

					int rarity = ItemFlavor_HasQuality( reward2 ) ? ItemFlavor_GetQuality( reward2 ) : 0
					RuiSetInt( btnRui, "rarity2", rarity )

					                     
					string rewardType1 = ItemFlavor_GetRewardShortDescription( reward )
					string rewardType2 = ItemFlavor_GetRewardShortDescription( reward2 )
					string rewardName1 = Localize( ItemFlavor_GetLongName( reward ) )
					string rewardName2 = Localize( ItemFlavor_GetLongName( reward2 ) )

					toolTip.titleText = Localize( "#QUEST_DUAL_REWARD_TOOLTIP_HEADER" )
					toolTip.descText = Localize( "#QUEST_DUAL_REWARD_TOOLTIP_DESC", rewardType1, rewardName1 ) + "\n" + Localize( "#QUEST_DUAL_REWARD_TOOLTIP_DESC", rewardType2, rewardName2 )
					toolTip.tooltipFlags = eToolTipFlag.SOLID
					Hud_SetToolTipData( button, toolTip )

					break                                                                                              
				}
			}
			rewardIndex ++
		}
	}
}


float function UI_Tween_QuadEaseOut( float frac )
{
	Assert( frac >= 0.0 && frac <= 1.0 )
	return -1.0 * frac * (frac - 2)
}
