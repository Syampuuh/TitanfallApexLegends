#if CLIENT || UI
global function ShPassPanel_LevelInit
#endif

#if CLIENT
global function UIToClient_StartTempBattlePassPresentationBackground
global function UIToClient_StopTempBattlePassPresentationBackground
global function UIToClient_StopBattlePassScene
global function UIToClient_ItemPresentation
global function TempBattlePassPresentationBackground_Thread
global function InitBattlePassLights
global function BattlePassLightsOn
global function BattlePassLightsOff
global function ClearBattlePassItem
#endif

#if UI
global function InitPassPanel
global function UpdateRewardPanel
global function InitAboutBattlePass1Dialog

global function InitPassPurchaseMenu

global function GetNumPages

global function TryDisplayBattlePassAwards

global function InitBattlePassRewardButtonRui

global function Battlepass_ShouldShowLow

global function BattlePass_PopulateRewardButton
global function BattlePass_SetRewardButtonIconSettings
global function BattlePass_SetUnlockedString

global function ServerCallback_GotBPFromPremier

global function GetBattlePassRewardHeaderText
global function GetBattlePassRewardItemName

global function BattlePass_PurchaseButton_OnActivate
global function ShouldDisplayTallButton
global function GetCharacterIconToDisplay
#endif

#if CLIENT || UI
global function Season_GetLongName
global function Season_GetShortName
global function Season_GetTimeRemainingText
global function Season_GetSmallLogo
global function Season_GetLobbyButtonImage
global function Season_GetTitleTextColor
global function Season_GetHeaderTextColor
global function Season_GetTimeRemainingTextColor
global function Season_GetTabBarDefaultCol
global function Season_GetTabBarFocusedCol
global function Season_GetTabBarSelectedCol
global function Season_GetTabBGDefaultCol
global function Season_GetTabBGFocusedCol
global function Season_GetTabBGSelectedCol
#endif


                       
                       
                       
                       
                       
struct BattlePassPageData
{
	int startLevel
	int endLevel
}

#if CLIENT
const float BATTLEPASS_MODEL_ROTATE_SPEED = 15.0
#endif

struct FileStruct_LifetimeLevel
{
	#if CLIENT
		bool                         isTempBattlePassPresentationBackgroundThreadActive = false
		float                        rotateSpeed = BATTLEPASS_MODEL_ROTATE_SPEED
		string						 sceneRefName
		vector                       sceneRefOrigin
		vector                       sceneRefAngles
		entity                       mover
		array<entity>                models
		array<int>                	 fxs
		NestedGladiatorCardHandle&   bannerHandle
		var                          topo
		var                          rui
		array<entity>                stationaryLights
		table<entity, vector>        stationaryLightOffsets
		                                        
		                                         
		string                       playingPreviewAlias

		var loadscreenPreviewBox = null
	#endif
	#if UI
		int numCraftingMetalsInBattlePass = 0
		int numApexCoinsInBattlePass = 0
	#endif
	table signalDummy
	int   videoChannel = -1

}
FileStruct_LifetimeLevel& fileLevel


#if UI
const float CURSOR_DELAY_BASE = 0.3
const float CURSOR_DELAY_MED = 0.3
const float CURSOR_DELAY_FAST = 0.1

const int numBattlePassBulletPoints = 16

global struct RewardGroup
{
	int                     level
	array<BattlePassReward> rewards
}
struct RewardButtonData
{
	var               button
	var               footer
	int               rewardGroupSubIdx
	RewardGroup&      rewardGroup
	int               rewardSubIdx
	BattlePassReward& bpReward
}
#endif

struct
{
	#if UI
		int                                previousPage = -1
		int                                currentPage = -1
		array<RewardGroup>                 currentRewardGroups = []
		string ornull                      currentRewardButtonKey = null
		                                                       
		                                                          
		var                                rewardBarPanelHeader
		array<var>                         rewardButtonsFree
		array<var>                         rewardButtonsPremium
		table<var, RewardButtonData>       rewardButtonToDataMap
		table<string, RewardButtonData>    rewardKeyToRewardButtonDataMap
		array<var>                         rewardHeaders
		var                                rewardBarFooter
		bool                               rewardButtonFocusForced
		bool                               isShowingBattlePassProgress

		var nextPageButton
		var prevPageButton

		var invisiblePageLeftTriggerButton
		var invisiblePageRightTriggerButton

		var statusBox
		var purchaseBG
		var purchaseButton

		var levelReqButton
		var premiumReqButton

		var detailBox
		var loadscreenPreviewBox
		var loadscreenPreviewBoxOverlay

		int   lastStickState
		float stickRepeatAllowTime

		var focusedRewardButton
		int aboutVideoChannel
		var aboutPurchaseButton
		var aboutProgressButton

		table< ItemFlavor, table<int, BattlePassPageData> > pageDatas
	#endif

} file

#if UI
const int MAX_LEVELS_PER_PAGE = 8
const int REWARDS_PER_PAGE = 9
#endif

                         
                         
                         
                         
                         
#if CLIENT || UI
void function ShPassPanel_LevelInit()
{
	#if CLIENT
		RegisterSignal( "StopTempBattlePassPresentationBackgroundThread" )
		RegisterButtonPressedCallback( MOUSE_WHEEL_UP, OnMouseWheelUp )
		RegisterButtonPressedCallback( MOUSE_WHEEL_DOWN, OnMouseWheelDown )

		AddCallback_UIScriptReset( void function() {
			fileLevel.loadscreenPreviewBox = null               
		} )
	#endif
	#if UI
		if ( IsLobby() )                           
		{
			ItemFlavor ornull activeBattlePass = GetActiveBattlePass()

			if ( activeBattlePass != null )
				BuildPageDatas( expect ItemFlavor( activeBattlePass ) )
		}
	#endif
}
#endif


#if UI
void function InitPassPanel( var panel )
{
	RegisterSignal( "TryChangePageThread" )

	SetPanelTabTitle( panel, "#PASS" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnPanelShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnPanelHide )

	file.purchaseBG = Hud_GetChild( panel, "PurchaseBG" )

	file.purchaseButton = Hud_GetChild( panel, "PurchaseButton" )
	Hud_AddEventHandler( file.purchaseButton, UIE_CLICK, BattlePass_PurchaseButton_OnActivate )

	                                                                       
	                                                  
	                                                                             
	                                                     

	file.rewardBarPanelHeader = Hud_GetChild( panel, "RewardBarPanelHeader" )
	file.rewardHeaders = GetPanelElementsByClassname( file.rewardBarPanelHeader, "RewardFooter" )

	file.rewardButtonsFree = GetPanelElementsByClassname( file.rewardBarPanelHeader, "RewardButtonFree" )
	foreach ( int rewardButtonIdx, var rewardButton in file.rewardButtonsFree )
	{
		Hud_SetNavUp( rewardButton, file.purchaseButton )
		Hud_AddEventHandler( rewardButton, UIE_GET_FOCUS, BattlePass_RewardButtonFree_OnGetFocus )
		Hud_AddEventHandler( rewardButton, UIE_LOSE_FOCUS, BattlePass_RewardButtonFree_OnLoseFocus )
		Hud_AddEventHandler( rewardButton, UIE_CLICK, BattlePass_RewardButtonFree_OnActivate )
		Hud_AddEventHandler( rewardButton, UIE_CLICKRIGHT, BattlePass_RewardButtonFree_OnAltActivate )
	}

	file.rewardButtonsPremium = GetPanelElementsByClassname( file.rewardBarPanelHeader, "RewardButtonPremium" )
	foreach ( int rewardButtonIdx, var rewardButton in file.rewardButtonsPremium )
	{
		Hud_SetNavUp( rewardButton, file.rewardButtonsFree[ rewardButtonIdx ] )
		Hud_SetNavDown( file.rewardButtonsFree[ rewardButtonIdx ], rewardButton )
		Hud_AddEventHandler( rewardButton, UIE_GET_FOCUS, BattlePass_RewardButtonPremium_OnGetFocus )
		Hud_AddEventHandler( rewardButton, UIE_LOSE_FOCUS, BattlePass_RewardButtonPremium_OnLoseFocus )
		Hud_AddEventHandler( rewardButton, UIE_CLICK, BattlePass_RewardButtonPremium_OnActivate )
		Hud_AddEventHandler( rewardButton, UIE_CLICKRIGHT, BattlePass_RewardButtonPremium_OnAltActivate )
	}

	file.rewardBarFooter = Hud_GetChild( panel, "RewardBarFooter" )

	file.nextPageButton = Hud_GetChild( panel, "RewardBarNextButton" )
	file.prevPageButton = Hud_GetChild( panel, "RewardBarPrevButton" )
	var prevPageRui = Hud_GetRui( file.prevPageButton )
	RuiSetBool( prevPageRui, "flipHorizontal", true )

	Hud_AddEventHandler( file.nextPageButton, UIE_CLICK, BattlePass_PageForward )
	Hud_AddEventHandler( file.prevPageButton, UIE_CLICK, BattlePass_PageBackward )
	  	                 
	file.statusBox = Hud_GetChild( panel, "StatusBox" )

	Hud_AddEventHandler( Hud_GetChild( panel, "StatusBox" ), UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "BattlePassAboutPage1" ) ) )

	file.levelReqButton = Hud_GetChild( panel, "LevelReqButton" )
	file.premiumReqButton = Hud_GetChild( panel, "PremiumReqButton" )

	file.detailBox = Hud_GetChild( panel, "DetailsBox" )
	file.loadscreenPreviewBox = Hud_GetChild( panel, "LoadscreenPreviewBox" )
	file.loadscreenPreviewBoxOverlay = Hud_GetChild( panel, "LoadscreenPreviewBoxOverlay" )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_INSPECT", "#A_BUTTON_INSPECT", null, BattlePass_IsFocusedItemInspectable )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP", null, BattlePass_IsFocusedItemEquippable )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_BUY_UP_TO", "#X_BUTTON_BUY_UP_TO", null, BattlePass_CanBuyUpToFocusedItem )

	file.invisiblePageLeftTriggerButton = Hud_GetChild( file.rewardBarPanelHeader, "InvisiblePageLeftTriggerButton" )
	Hud_AddEventHandler( file.invisiblePageLeftTriggerButton, UIE_GET_FOCUS, void function( var button ) {
		BattlePass_PageBackward( button )
	} )
	file.invisiblePageRightTriggerButton = Hud_GetChild( file.rewardBarPanelHeader, "InvisiblePageRightTriggerButton" )
	Hud_AddEventHandler( file.invisiblePageRightTriggerButton, UIE_GET_FOCUS, void function( var button ) {
		BattlePass_PageForward( button )
	} )
}


string function GetRewardButtonKey( int levelNum, int rewardSubIdx )
{
	return format( "level%d:reward%d", levelNum, rewardSubIdx )
}

void function UpdateRewardPanel( array<RewardGroup> rewardGroups )
{
	int panelMaxWidth = Hud_GetBaseWidth( file.rewardBarPanelHeader )

	const int MAX_REWARD_BUTTONS = 15
	const int MAX_REWARD_FOOTERS = 15

	int thinDividers
	int thickDividers
	int numButtons = 0
	foreach ( rewardIdx, rewardGroup in rewardGroups )
	{
		if ( rewardGroup.rewards.len() == 0 )
			continue

		thinDividers += (rewardGroup.rewards.len() - 1)
		if ( rewardIdx < (rewardGroups.len() - 1) )
			thickDividers++

		numButtons += GetRewardsBoxSizeForGroup( rewardGroup )
	}

	Assert( file.rewardHeaders.len() == MAX_REWARD_FOOTERS )
	Assert( file.rewardButtonsFree.len() == MAX_REWARD_BUTTONS )
	Assert( file.rewardButtonsPremium.len() == MAX_REWARD_BUTTONS )

	file.rewardButtonsFree.sort( SortByScriptId )
	file.rewardButtonsPremium.sort( SortByScriptId )

	int buttonWidth = Hud_GetWidth( file.rewardButtonsFree[0] )

	foreach ( headerBox in file.rewardHeaders )
	{
		Hud_Hide( headerBox )
		Hud_SetEnabled( headerBox, false )
	}

	foreach ( rewardButton in file.rewardButtonsFree )
	{
		Hud_Hide( rewardButton )
		Hud_SetEnabled( rewardButton, false )
		Hud_SetSelected( rewardButton, false )
	}

	foreach ( rewardButton in file.rewardButtonsPremium )
	{
		Hud_Hide( rewardButton )
		Hud_SetEnabled( rewardButton, false )
		Hud_SetSelected( rewardButton, false )
	}

	file.rewardButtonToDataMap.clear()
	file.rewardKeyToRewardButtonDataMap.clear()

	                                                                             

	int thinPadding  = ContentScaledXAsInt( 4 )
	int thickPadding = ContentScaledXAsInt( 50 )

	if ( file.currentPage == 0 )
	{
		thickPadding = ContentScaledXAsInt( 56 )
	}

	int contentWidth       = (buttonWidth * numButtons) + (thinPadding * thinDividers) + (thickPadding * thickDividers)
	int minContentWidth    = (buttonWidth * 5) + (thinPadding * thinDividers) + (thickPadding * 4)
	                                                                                                                           
	bool hasPremiumPass    = false
	int battlePassLevelIdx = 0

	                                                       
	                                                          
	                                                                               

	ItemFlavor ornull activeBattlePass = GetPlayerLastActiveBattlePass( ToEHI( GetLocalClientPlayer() ) )
	bool hasActiveBattlePass           = activeBattlePass != null && GRX_IsInventoryReady()
	if ( hasActiveBattlePass )
	{
		expect ItemFlavor( activeBattlePass )
		hasPremiumPass = DoesPlayerOwnBattlePass( GetLocalClientPlayer(), activeBattlePass )
		battlePassLevelIdx = GetPlayerBattlePassLevel( GetLocalClientPlayer(), activeBattlePass, false )
	}

	array<RewardButtonData> rewardButtonDataList = []

	int offset    = 0
	int buttonIdx = 0
	int footerIdx = 0

	int numLevels
	foreach ( int rewardGroupSubIdx, RewardGroup rewardGroup in rewardGroups )
	{
		if ( rewardGroup.rewards.len() == 0 )
			continue

		numLevels++
	}

	foreach ( int rewardGroupSubIdx, RewardGroup rewardGroup in rewardGroups )
	{
		if ( rewardGroup.rewards.len() == 0 )
			continue

		var rewardFooter = file.rewardHeaders[footerIdx]
		Hud_SetX( rewardFooter, offset )
		var footerRui = Hud_GetRui( rewardFooter )
		RuiSetString( footerRui, "levelText", GetBattlePassDisplayLevel( rewardGroup.level ) )
		RuiSetInt( footerRui, "level", rewardGroup.level )
		Hud_Show( rewardFooter )
		Hud_SetEnabled( rewardFooter, true )

		array<RewardButtonData> rbd_freeArray
		array<RewardButtonData> rbd_premiumArray

		foreach ( int rewardSubIdx, BattlePassReward bpReward in rewardGroup.rewards )
		{
			RewardButtonData rbd
			rbd.footer = rewardFooter
			rbd.rewardGroupSubIdx = rewardGroupSubIdx
			rbd.rewardGroup = rewardGroup
			rbd.rewardSubIdx = rewardSubIdx
			rbd.bpReward = bpReward

			if ( bpReward.isPremium )
				rbd_premiumArray.append( rbd )
			else
				rbd_freeArray.append( rbd )
		}

		int footerWidth           = 0
		int numButtonsInThisLevel = maxint( rbd_freeArray.len(), rbd_premiumArray.len() )

		for ( int i = 0; i < numButtonsInThisLevel; i++ )
		{
			RewardButtonData rbd_free
			RewardButtonData rbd_premium
			BattlePassReward bpReward

			Hud_Hide( file.rewardButtonsFree[buttonIdx] )
			Hud_Hide( file.rewardButtonsPremium[buttonIdx] )

			if ( rbd_freeArray.len() > i )
			{
				rbd_free = rbd_freeArray[ i ]
				PopulateBattlePassButton( rbd_free, file.rewardButtonsFree[buttonIdx], rewardButtonDataList, hasActiveBattlePass, hasPremiumPass, battlePassLevelIdx, offset )
				bpReward = rbd_free.bpReward
			}

			if ( rbd_premiumArray.len() > i )
			{
				rbd_premium = rbd_premiumArray[ i ]
				PopulateBattlePassButton( rbd_premium, file.rewardButtonsPremium[buttonIdx], rewardButtonDataList, hasActiveBattlePass, hasPremiumPass, battlePassLevelIdx, offset )
				bpReward = rbd_premium.bpReward
			}

			bool isOwned = bpReward.level <= battlePassLevelIdx
			RuiSetBool( footerRui, "isOwned", isOwned )
			RuiSetInt( footerRui, "ownedLevel", battlePassLevelIdx )

			offset += buttonWidth
			footerWidth += buttonWidth

			if ( i < numButtonsInThisLevel - 1 )
			{
				offset += thinPadding
				footerWidth += thinPadding
			}
			else
			{
				offset += thickPadding
			}

			buttonIdx++
		}

		int margin = thickPadding
		Hud_SetWidth( rewardFooter, footerWidth + margin )
		Hud_SetX( rewardFooter, Hud_GetX( rewardFooter ) - int( margin * 0.5 ) )
		RuiSetBool( footerRui, "isLast", footerIdx >= numLevels - 1 )
		RuiSetBool( footerRui, "isFirst", footerIdx == 0 )
		footerIdx++
	}

	Hud_SetNavRight( file.rewardButtonsFree[buttonIdx - 1], file.invisiblePageRightTriggerButton )
	Hud_SetNavRight( file.rewardButtonsPremium[buttonIdx - 1], file.invisiblePageRightTriggerButton )

	var buttonToFocus

	if ( GetFocus() == file.invisiblePageLeftTriggerButton || GetFocus() == file.prevPageButton )
		buttonToFocus = file.rewardButtonsPremium[buttonIdx - 1]
	else if ( GetFocus() == file.invisiblePageRightTriggerButton || GetFocus() == file.nextPageButton )
		buttonToFocus = file.rewardButtonsPremium[0]

	if ( buttonToFocus != null )
	{
		if ( buttonToFocus != file.focusedRewardButton )
		{
			Hud_SetFocused( buttonToFocus )
		}
		else
		{
			BattlePass_RewardButton_OnLoseFocus( buttonToFocus )
			BattlePass_RewardButton_OnGetFocus( buttonToFocus )
		}
	}

	      
	   
	  	                            
	  	                             
	  	                                                       
	  	 
	  		                                                                    
	  		                                                                      
	  	 
	  
	  	                                    
	  	                                            
	  	 
	  		                                                                                                                
	  		                                                                              
	  	 
	  
	  	                                                                             
	  	                                                                                                                                                                                      
	  	                                                                                                
	   
}

void function PopulateBattlePassButton( RewardButtonData rbd, var rewardButton, array<RewardButtonData> rewardButtonDataList, bool hasActiveBattlePass, bool hasPremiumPass, int battlePassLevelIdx, int offset )
{
	rbd.button = rewardButton

	file.rewardButtonToDataMap[rewardButton] <- rbd
	file.rewardKeyToRewardButtonDataMap[GetRewardButtonKey( rbd.rewardGroup.level, rbd.rewardSubIdx )] <- rbd

	rewardButtonDataList.append( rbd )

	Hud_SetX( rewardButton, offset )
	Hud_SetEnabled( rewardButton, hasActiveBattlePass )

	BattlePassReward bpReward = rbd.bpReward

	bool isOwned = (!bpReward.isPremium || hasPremiumPass) && bpReward.level <= battlePassLevelIdx

	BattlePass_PopulateRewardButton( bpReward, rewardButton, isOwned, bpReward.isPremium )
}

void function BattlePass_PopulateRewardButton( BattlePassReward bpReward, var rewardButton, bool isOwned, bool canUseTallButton, var ruiOverride = null )
{
	var btnRui
	if ( rewardButton != null )
		btnRui = Hud_GetRui( rewardButton )
	if ( ruiOverride != null )
		btnRui = ruiOverride

	Assert( btnRui != null )

	RuiSetBool( btnRui, "isOwned", isOwned )
	RuiSetBool( btnRui, "isPremium", bpReward.isPremium )

	int rarity = ItemFlavor_HasQuality( bpReward.flav ) ? ItemFlavor_GetQuality( bpReward.flav ) : 0
	RuiSetInt( btnRui, "rarity", rarity )

	asset rewardImage = CustomizeMenu_GetRewardButtonImage( bpReward.flav )
	RuiSetImage( btnRui, "buttonImage", rewardImage )
	                                                                                                                       
	RuiSetImage( btnRui, "buttonImageSecondLayer", $"" )
	RuiSetFloat2( btnRui, "buttonImageSecondLayerOffset", <0.0, 0.0, 0.0> )

	int itemType = ItemFlavor_GetType( bpReward.flav )

	if ( itemType == eItemType.account_pack )
		RuiSetBool( btnRui, "isLootBox", true )
	else
		RuiSetBool( btnRui, "isLootBox", false )

	RuiSetString( btnRui, "itemCountString", "" )
	if ( itemType == eItemType.account_currency )
	{
		RuiSetString( btnRui, "itemCountString", FormatAndLocalizeNumber( "1", float( bpReward.quantity ), true ) )
	}
	else if ( itemType == eItemType.account_pack )
	{
		if( float( bpReward.quantity ) > 1.0 )
			RuiSetString( btnRui, "itemCountString", FormatAndLocalizeNumber( "1", float( bpReward.quantity ), true ) )
	}

	RuiSetInt( btnRui, "bpLevel", bpReward.level )
	RuiSetBool( btnRui, "isRewardBar", false )
	RuiSetBool( btnRui, "showCharacterIcon", false )

	BattlePass_SetRewardButtonIconSettings( bpReward.flav, btnRui, rewardButton, canUseTallButton )

	RuiSetBool( btnRui, "forceShowRarityBG", ShouldForceShowRarityBG( bpReward.flav ) )

	if ( rewardButton != null )
		Hud_Show( rewardButton )
}

void function BattlePass_ForceFullIconForWeaponSkin( ItemFlavor flav, var btnRui, bool useTallButton, asset rewardImage )
{
	asset weaponIcon = WeaponItemFlavor_GetHudIcon( WeaponSkin_GetWeaponFlavor( flav ) )
	RuiSetBool( btnRui, "showCharacterIcon", weaponIcon != $"" )
	RuiSetImage( btnRui, "characterIcon", weaponIcon )

	RuiSetBool( btnRui, "forceFullIcon", true )
	RuiSetFloat2( btnRui, "characterIconSize", <60, 30, 0> )

	if ( !useTallButton )
	{
		                                                                                         
		                                                                                    
		RuiSetImage( btnRui, "buttonImage", $"white" )
		RuiSetImage( btnRui, "buttonImageSecondLayer", rewardImage )
		RuiSetFloat2( btnRui, "buttonImageSecondLayerOffset", <0.0, 0.16, 0.0> )
	}
}

void function BattlePass_SetRewardButtonIconSettings( ItemFlavor flav, var btnRui, var rewardButton, bool canUseTallButton )
{
	asset rewardImage = CustomizeMenu_GetRewardButtonImage( flav )

	if ( rewardButton != null )
		Hud_SetHeight( rewardButton, Hud_GetBaseHeight( rewardButton ) )

	RuiSetBool( btnRui, "forceFullIcon", false )
	if ( ShouldDisplayTallButton( flav ) )
	{
		if ( canUseTallButton )
		{
			if ( rewardButton != null )
				Hud_SetHeight( rewardButton, Hud_GetBaseHeight( rewardButton ) * 1.5 )
		}

		if ( ItemFlavor_GetType( flav ) != eItemType.character_skin )
		{
			asset icon = GetCharacterIconToDisplay( flav )
			RuiSetBool( btnRui, "showCharacterIcon", icon != $"" )
			RuiSetImage( btnRui, "characterIcon", icon )
			RuiSetFloat2( btnRui, "characterIconSize", <35, 35, 0> )

			if ( ItemFlavor_GetType( flav ) == eItemType.weapon_skin )
			{
				if ( icon != $"" && icon != rewardImage )
					BattlePass_ForceFullIconForWeaponSkin( flav, btnRui, canUseTallButton, rewardImage )
			}
		}
		else
		{
			RuiSetBool( btnRui, "forceFullIcon", true )
		}

		return
	}

	if ( ItemFlavor_GetType( flav ) == eItemType.weapon_skin && GetGlobalSettingsBool( ItemFlavor_GetAsset( flav ), "forceFullWeaponIcon" ) )
	{
		BattlePass_ForceFullIconForWeaponSkin( flav, btnRui, false, rewardImage )                                                                
		return
	}
}

bool function ShouldForceShowRarityBG( ItemFlavor flav )
{
	int itemType = ItemFlavor_GetType( flav )
	switch ( itemType )
	{
		case eItemType.weapon_skin:
		case eItemType.weapon_charm:
		case eItemType.character_skin:
		case eItemType.gladiator_card_frame:
		case eItemType.gladiator_card_stance:
		case eItemType.gladiator_card_intro_quip:
		case eItemType.gladiator_card_kill_quip:
		case eItemType.gladiator_card_stat_tracker:
		case eItemType.loadscreen:
		case eItemType.account_pack:
		case eItemType.voucher:
			return true
	}

	return false
}

asset function GetCharacterIconToDisplay( ItemFlavor flav )
{
	ItemFlavor ornull char = GetItemFlavorAssociatedCharacterOrWeapon( flav )

	if ( char != null )
	{
		expect ItemFlavor( char )
		asset icon = ItemFlavor_GetIcon( char )
		if ( icon != ItemFlavor_GetIcon( flav ) )
			return icon
	}

	return $""
}

bool function ShouldDisplayTallButton( ItemFlavor flav )
{
	int itemType = ItemFlavor_GetType( flav )

	switch ( itemType )
	{
		case eItemType.character_skin:
			                                                                                     
			                                                                                                  
			return ItemFlavor_GetIcon( flav ) != $""

		case eItemType.character_execution:
		case eItemType.gladiator_card_frame:
		case eItemType.gladiator_card_stance:
		case eItemType.gladiator_card_kill_quip:
		case eItemType.gladiator_card_intro_quip:
		case eItemType.character_emote:
		case eItemType.skydive_emote:
		case eItemType.emote_icon:
			return true

		case eItemType.weapon_skin:
			                                                                                                 
			                                                                       
			return ItemFlavor_GetQuality( flav ) >= eRarityTier.EPIC && ItemFlavor_GetIcon( flav ) != $""
	}

	return false
}

void function BattlePass_PageForward( var button )
{
	if ( GetActiveMenu() != GetMenu( "LobbyMenu" ) )
		return

	int oldPage = file.currentPage
	BattlePass_SetPage( file.currentPage + 1 )

	var focus = GetFocus()

	if ( focus != file.nextPageButton
	&& focus != file.prevPageButton
	&& focus != file.invisiblePageLeftTriggerButton
	&& focus != file.invisiblePageRightTriggerButton )
	{
		file.focusedRewardButton = null
		ForceVGUIFocusUpdate()
	}

	if ( oldPage != file.currentPage )
	{
		EmitUISound( "UI_Menu_BattlePass_LevelTab" )
	}
}


void function BattlePass_PageBackward( var button )
{
	if ( GetActiveMenu() != GetMenu( "LobbyMenu" ) )
		return

	int oldPage = file.currentPage
	BattlePass_SetPage( file.currentPage - 1 )

	var focus = GetFocus()

	if ( focus != file.nextPageButton
	&& focus != file.prevPageButton
	&& focus != file.invisiblePageLeftTriggerButton
	&& focus != file.invisiblePageRightTriggerButton )
	{
		file.focusedRewardButton = null
		ForceVGUIFocusUpdate()
	}

	if ( oldPage != file.currentPage )
	{
		EmitUISound( "UI_Menu_BattlePass_LevelTab" )
	}
}

void function BattlePass_PurchaseButton_OnActivate( var button )
{
	BattlePass_Purchase( button, 1 )
}


void function BattlePass_Purchase( var button, int startQuantity )
{
	ItemFlavor ornull activeBattlePass = GetPlayerActiveBattlePass( ToEHI( GetLocalClientPlayer() ) )
	if ( activeBattlePass == null || !GRX_IsInventoryReady() )
	{
		return
	}
	expect ItemFlavor( activeBattlePass )

	bool hasPremiumPass = DoesPlayerOwnBattlePass( GetLocalClientPlayer(), activeBattlePass )

	if ( !hasPremiumPass )
	{
		AdvanceMenu( GetMenu( "PassPurchaseMenu" ) )
	}
	else if ( GetPlayerBattlePassPurchasableLevels( ToEHI( GetLocalClientPlayer() ), activeBattlePass ) > 0 )
	{
		if ( ItemFlavor_IsItemDisabledForGRX( BattlePass_GetXPPurchaseFlav( activeBattlePass ) ) )
		{
			EmitUISound( "menu_deny" )
			return
		}

		RewardPurchaseDialogConfig rpdcfg

		rpdcfg.purchaseButtonTextCallback = string function( int purchaseQuantity ) : ( activeBattlePass ) {
			ItemFlavor xpPurchaseFlav              = BattlePass_GetXPPurchaseFlav( activeBattlePass )
			array<GRXScriptOffer> xpPurchaseOffers = GRX_GetItemDedicatedStoreOffers( xpPurchaseFlav, "battlepass" )
			Assert( xpPurchaseOffers.len() == 1 )
			if ( xpPurchaseOffers.len() < 1 )
			{
				Warning( "No offer for xp purchase for '%s'", ItemFlavor_GetHumanReadableRef( activeBattlePass ) )
				return ""
			}
			GRXScriptOffer xpPurchaseOffer = xpPurchaseOffers[0]
			Assert( xpPurchaseOffer.prices.len() == 1 )
			if ( xpPurchaseOffer.prices.len() < 1 )
				return ""

			return GRX_GetFormattedPrice( xpPurchaseOffer.prices[0], purchaseQuantity )
		}

		rpdcfg.maxPurchasableLevelsCallback = int function() : ( activeBattlePass ) {
			return GetPlayerBattlePassPurchasableLevels( ToEHI( GetLocalClientPlayer() ), activeBattlePass )
		}

		rpdcfg.startingPurchaseLevelIdxCallback = int function() : ( activeBattlePass ) {
			return GetPlayerBattlePassLevel( GetLocalClientPlayer(), activeBattlePass, false )
		}

		rpdcfg.rewardsCallback = array<BattlePassReward> function( int purchaseQuantity, int startingPurchaseLevelIdx ) : ( activeBattlePass ) {
			array<BattlePassReward> rewards
			for ( int index = 1; index <= purchaseQuantity; index++ )
				rewards.extend( GetBattlePassLevelRewards( activeBattlePass, startingPurchaseLevelIdx + index ) )
			return rewards
		}

		rpdcfg.getPurchaseFlavCallback = ItemFlavor function() : ( activeBattlePass ) {
			return BattlePass_GetXPPurchaseFlav( activeBattlePass )
		}


		rpdcfg.toolTipDataMaxPurchase.titleText = "#BATTLE_PASS_MAX_PURCHASE_LEVEL"
		rpdcfg.toolTipDataMaxPurchase.descText = "#BATTLE_PASS_MAX_PURCHASE_LEVEL_DESC"

		rpdcfg.levelIndexStart = 1
		rpdcfg.headerText = "#BATTLE_PASS_YOU_WILL_RECEIVE"
		rpdcfg.quantityText = "#BATTLE_PASS_PLUS_N_LEVEL"
		rpdcfg.titleText = "#BATTLE_PASS_PURCHASE_LEVEL"
		rpdcfg.descText = "#BATTLE_PASS_PURCHASE_LEVEL_DESC"
		rpdcfg.quantityTextPlural = "#BATTLE_PASS_PLUS_N_LEVELS"
		rpdcfg.titleTextPlural = "#BATTLE_PASS_PURCHASE_LEVEL"
		rpdcfg.descTextPlural = "#BATTLE_PASS_PURCHASE_LEVEL_DESC"
		rpdcfg.startQuantity = startQuantity

		RewardPurchaseDialog( rpdcfg )
	}
}

void function BattlePass_RewardButtonFree_OnGetFocus( var button )
{
	BattlePass_RewardButton_OnGetFocus( button )
}

void function BattlePass_RewardButtonFree_OnLoseFocus( var button )
{
	BattlePass_RewardButton_OnLoseFocus( button )
}

void function BattlePass_RewardButtonFree_OnActivate( var button )
{
	BattlePass_RewardButton_OnActivate( button )
}

void function BattlePass_RewardButtonFree_OnAltActivate( var button )
{
	BattlePass_RewardButton_OnAltActivate( button )
}

void function BattlePass_RewardButtonPremium_OnGetFocus( var button )
{
	BattlePass_RewardButton_OnGetFocus( button )
}

void function BattlePass_RewardButtonPremium_OnLoseFocus( var button )
{
	BattlePass_RewardButton_OnLoseFocus( button )
}

void function BattlePass_RewardButtonPremium_OnActivate( var button )
{
	BattlePass_RewardButton_OnActivate( button )
}

void function BattlePass_RewardButtonPremium_OnAltActivate( var button )
{
	BattlePass_RewardButton_OnAltActivate( button )
}

void function BattlePass_RewardButton_OnGetFocus( var button )
{
	Hud_SetNavDown( file.purchaseButton, button )

	if ( !(button in file.rewardButtonToDataMap) )
		return

	RewardButtonData rbd    = file.rewardButtonToDataMap[button]
	                                                                                                                          
	BattlePassReward reward = rbd.rewardGroup.rewards[rbd.rewardSubIdx]

	file.currentRewardButtonKey = GetRewardButtonKey( rbd.rewardGroup.level, rbd.rewardSubIdx )
	bool wasFocusForced = file.rewardButtonFocusForced
	file.rewardButtonFocusForced = false

	Hud_SetNavDown( file.purchaseButton, rbd.button )

	foreach ( var otherButton in file.rewardButtonsFree )
		Hud_SetSelected( otherButton, false )
	foreach ( var otherButton in file.rewardButtonsPremium )
		Hud_SetSelected( otherButton, false )

	Hud_SetSelected( button, true )

	ItemFlavor ornull activeBattlePass = GetPlayerLastActiveBattlePass( ToEHI( GetLocalClientPlayer() ) )
	if ( activeBattlePass == null || !GRX_IsInventoryReady() )
		return
	expect ItemFlavor( activeBattlePass )

	file.focusedRewardButton = button
	Hud_Show( file.detailBox )

	int battlePassLevel = GetPlayerBattlePassLevel( GetLocalClientPlayer(), activeBattlePass, false )
	bool hasPremiumPass = DoesPlayerOwnBattlePass( GetLocalClientPlayer(), activeBattlePass )

	string itemName = GetBattlePassRewardItemName( reward )
	int rarity      = ItemFlavor_HasQuality( reward.flav ) ? ItemFlavor_GetQuality( reward.flav ) : 0

	string itemDesc   = GetBattlePassRewardItemDesc( reward )
	string headerText = GetBattlePassRewardHeaderText( reward )

	HudElem_SetRuiArg( file.detailBox, "headerText", headerText )
	HudElem_SetRuiArg( file.detailBox, "titleText", itemName )
	HudElem_SetRuiArg( file.detailBox, "descText", itemDesc )
	HudElem_SetRuiArg( file.detailBox, "rarity", rarity )

	HudElem_SetRuiArg( file.detailBox, "rarityBulletText1", "" )
	HudElem_SetRuiArg( file.detailBox, "rarityBulletText2", "" )
	HudElem_SetRuiArg( file.detailBox, "rarityBulletText3", "" )
	HudElem_SetRuiArg( file.detailBox, "rarityPercentText1", "" )
	HudElem_SetRuiArg( file.detailBox, "rarityPercentText2", "" )
	HudElem_SetRuiArg( file.detailBox, "rarityPercentText3", "" )

	if ( ItemFlavor_GetType( reward.flav ) == eItemType.account_pack )
	{
		if ( rarity == 1 )
		{
			HudElem_SetRuiArg( file.detailBox, "rarityBulletText1", Localize( "#APEX_PACK_PROBABILITIES_RARE" ) )
		}
		else if ( rarity == 2 )
		{
			HudElem_SetRuiArg( file.detailBox, "rarityBulletText1", Localize( "#APEX_PACK_PROBABILITIES_EPIC" ) )
		}
		else if ( rarity == 3 )
		{
			HudElem_SetRuiArg( file.detailBox, "rarityBulletText1", Localize( "#APEX_PACK_PROBABILITIES_LEGENDARY" ) )
		}
	}

	HudElem_SetRuiArg( file.levelReqButton, "buttonText", Localize( "#BATTLE_PASS_LEVEL_REQUIRED", reward.level + 2 ) )
	HudElem_SetRuiArg( file.levelReqButton, "meetsRequirement", battlePassLevel >= reward.level + 1 )
	HudElem_SetRuiArg( file.levelReqButton, "isPremium", false )

	if ( reward.isPremium && hasPremiumPass )
	{
		HudElem_SetRuiArg( file.premiumReqButton, "buttonText", "#BATTLE_PASS_PREMIUM_REWARD" )
		HudElem_SetRuiArg( file.premiumReqButton, "meetsRequirement", true )
	}
	else if ( reward.isPremium && !hasPremiumPass )
	{
		HudElem_SetRuiArg( file.premiumReqButton, "buttonText", "#BATTLE_PASS_PREMIUM_REQUIRED" )
		HudElem_SetRuiArg( file.premiumReqButton, "meetsRequirement", false )
	}
	else
	{
		HudElem_SetRuiArg( file.premiumReqButton, "buttonText", "#BATTLE_PASS_FREE_REWARD" )
		HudElem_SetRuiArg( file.premiumReqButton, "meetsRequirement", true )
	}

	HudElem_SetRuiArg( file.premiumReqButton, "isPremium", reward.isPremium )

	bool isLoadScreen = (ItemFlavor_GetType( reward.flav ) == eItemType.loadscreen)
	Hud_SetVisible( file.loadscreenPreviewBox, isLoadScreen )
	Hud_SetVisible( file.loadscreenPreviewBoxOverlay, isLoadScreen )

	float scale = 1.0
	bool shouldPlayAudioPreview = !wasFocusForced
	RunClientScript( "UIToClient_ItemPresentation", ItemFlavor_GetGUID( reward.flav ), reward.level, scale, Battlepass_ShouldShowLow( reward.flav ), file.loadscreenPreviewBox, shouldPlayAudioPreview, "battlepass_right_ref" )

	UpdateBattlePassProgress( wasFocusForced, wasFocusForced )

	UpdateFooterOptions()                    
}


void function UpdateBattlePassProgress( bool show, bool instant = false )
{
	if ( file.isShowingBattlePassProgress && show )
		return
	file.isShowingBattlePassProgress = show

	entity player = GetLocalClientPlayer()
	int playerEHI = ToEHI( player )
	ItemFlavor ornull activeBattlePass = GetPlayerLastActiveBattlePass( playerEHI )
	if ( activeBattlePass == null )
		return
	expect ItemFlavor( activeBattlePass )
	int currentBattlePassXP  = GetPlayerBattlePassXPProgress( playerEHI, activeBattlePass, false )
	int battlePassLevel      = GetBattlePassLevelForXP( activeBattlePass, currentBattlePassXP ) + 1
	bool battlePassCompleted = battlePassLevel >= (GetBattlePassMaxLevelIndex( activeBattlePass ) + 1)

	var rui = Hud_GetRui( file.detailBox )
	RuiSetBool( rui, "battlePassCompleted", battlePassCompleted )
	RuiSetGameTime( rui, "showBPProgressStartTime", instant ? -100.0 : ClientTime() )
	UpdateChallengeBoxHeaderBPProgress( player, rui )
	RuiSetBool( rui, "showBPProgress", show )

	SetSeasonColors( rui )
}


bool function Battlepass_ShouldShowLow( ItemFlavor flav )
{
	switch ( ItemFlavor_GetType( flav ) )
	{
		case eItemType.character_skin:
		case eItemType.gladiator_card_frame:
		case eItemType.emote_icon:
			return true
	}
	return false
}

void function BattlePass_RewardButton_OnLoseFocus( var button )
{
	if ( GetActiveMenu() == GetMenu( "LobbyMenu" ) )
		file.currentRewardButtonKey = null

	UpdateBattlePassProgress( true )
	UpdateFooterOptions()                    
}

void function BattlePass_FocusRewardButton( RewardButtonData rbd )
{
	                                                                                                                    

	file.currentRewardButtonKey = null
	if ( GetFocus() != rbd.button )
		Hud_SetFocused( rbd.button )
	else
		BattlePass_RewardButton_OnGetFocus( rbd.button )

	HudElem_SetRuiArg( rbd.button, "forceFocusShineMarker", RandomInt( INT_MAX ) )

	                                       
	  	              
	  	                                   
	  	                        
	                
}

void function BattlePass_RewardButton_OnActivate( var button )
{
	if ( GetActiveBattlePass() == null )
		return

	RewardButtonData rbd    = file.rewardButtonToDataMap[button]
	BattlePassReward reward = rbd.rewardGroup.rewards[rbd.rewardSubIdx]
	if ( ItemFlavor_GetType( reward.flav ) == eItemType.loadscreen )
	{
		LoadscreenPreviewMenu_SetLoadscreenToPreview( reward.flav )
		AdvanceMenu( GetMenu( "LoadscreenPreviewMenu" ) )
	}
	else if ( InspectItemTypePresentationSupported( reward.flav ) )
	{
		RunClientScript( "ClearBattlePassItem" )
		SetBattlePassItemPresentationModeActive( reward )
	}
}


void function BattlePass_RewardButton_OnAltActivate( var button )
{
	if ( GetActiveBattlePass() == null )
		return

	RewardButtonData rbd    = file.rewardButtonToDataMap[button]
	BattlePassReward reward = rbd.rewardGroup.rewards[rbd.rewardSubIdx]

	if ( BattlePass_CanEquipReward( reward ) )
	{
		ItemFlavor item           = reward.flav
		array<LoadoutEntry> entry = GetAppropriateLoadoutSlotsForItemFlavor( item )

		if ( entry.len() == 0 )
			return

		if ( entry.len() == 1 )
		{
			EmitUISound( "UI_Menu_Equip_Generic" )
			RequestSetItemFlavorLoadoutSlot( ToEHI( GetLocalClientPlayer() ), entry[ 0 ], item )
		}
		else
		{
			              
			OpenSelectSlotDialog( entry, item, GetItemFlavorAssociatedCharacterOrWeapon( item ),
				(void function( int index ) : ( entry, item )
				{
					EmitUISound( "UI_Menu_Equip_Generic" )
					RequestSetItemFlavorLoadoutSlot_WithDuplicatePrevention( ToEHI( GetLocalClientPlayer() ), entry, item, index )
				})
			)
		}
		return
	}

	entity player = GetLocalClientPlayer()
	ItemFlavor ornull activeBattlePass = GetPlayerLastActiveBattlePass( ToEHI( player ) )
	if ( activeBattlePass == null )
		return
	expect ItemFlavor( activeBattlePass )

	if ( BattlePass_CanBuyUpTo( player, activeBattlePass, rbd ) )
	{
		                                                      
		int currentLevel = GetPlayerBattlePassLevel( player, activeBattlePass, false )
		int maxPurchasable = GetPlayerBattlePassPurchasableLevels( ToEHI( player ), activeBattlePass )
		int purchaseLevels = rbd.rewardGroup.level - currentLevel
		Assert( purchaseLevels <= maxPurchasable )
		BattlePass_Purchase( null, purchaseLevels )
	}
}


bool function BattlePass_IsFocusedItemInspectable()
{
	var focusedPanel = GetFocus()
	if ( focusedPanel in file.rewardButtonToDataMap )
	{
		RewardButtonData rbd    = file.rewardButtonToDataMap[focusedPanel]
		BattlePassReward reward = rbd.rewardGroup.rewards[rbd.rewardSubIdx]
		return (ItemFlavor_GetType( reward.flav ) == eItemType.loadscreen || InspectItemTypePresentationSupported( reward.flav ))
	}
	return false
}


bool function BattlePass_CanBuyUpToFocusedItem()
{
	entity player = GetLocalClientPlayer()
	ItemFlavor ornull activeBattlePass = GetPlayerLastActiveBattlePass( ToEHI( player ) )
	if ( activeBattlePass == null )
		return false
	expect ItemFlavor( activeBattlePass )

	var focusedPanel = GetFocus()
	if ( focusedPanel in file.rewardButtonToDataMap )
	{
		RewardButtonData rbd = file.rewardButtonToDataMap[focusedPanel]
		return BattlePass_CanBuyUpTo( player, activeBattlePass, rbd )
	}

	return false
}


bool function BattlePass_CanBuyUpTo( entity player, ItemFlavor activeBattlePass, RewardButtonData rbd )
{
	if ( !GRX_IsInventoryReady( player ) )
		return false

	if ( !DoesPlayerOwnBattlePass( player, activeBattlePass ) )
		return false

	int level = rbd.rewardGroup.level
	int levelXP = GetBattlePassXPForLevel( activeBattlePass, level - 1 )
	int passXP = GetPlayerBattlePassXPProgress( ToEHI( player ), activeBattlePass )
	int maxPurchaseLevels = GetBattlePassMaxPurchaseLevels( activeBattlePass )

	if ( level > maxPurchaseLevels )
		return false

	return passXP < levelXP
}


bool function BattlePass_IsFocusedItemEquippable()
{
	var focusedPanel = GetFocus()
	if ( focusedPanel in file.rewardButtonToDataMap )
	{
		RewardButtonData rbd = file.rewardButtonToDataMap[focusedPanel]
		return BattlePass_CanEquipReward( rbd.rewardGroup.rewards[rbd.rewardSubIdx] )
	}
	return false
}


bool function BattlePass_CanEquipReward( BattlePassReward reward )
{
	ItemFlavor item                  = reward.flav
	int itemType                     = ItemFlavor_GetType( item )
	array<LoadoutEntry> loadoutSlots = GetAppropriateLoadoutSlotsForItemFlavor( item )

	if ( loadoutSlots.len() == 0 )
		return false

	foreach ( loadoutSlot in loadoutSlots)
	{
		bool isEquipped = (LoadoutSlot_GetItemFlavor( LocalClientEHI(), loadoutSlot ) == item)
		if ( isEquipped )
			return false
	}

	return GRX_IsItemOwnedByPlayer_AllowOutOfDateData( item )
}


string function GetBattlePassRewardHeaderText( BattlePassReward reward )
{
	string headerText = ItemFlavor_GetRewardShortDescription( reward.flav )
	if ( ItemFlavor_HasQuality( reward.flav ) )
	{
		string rarityName = ItemFlavor_GetQualityName( reward.flav )
		if ( headerText == "" )
			headerText = Localize( "#BATTLE_PASS_ITEM_HEADER", Localize( rarityName ) )
		else
			headerText = Localize( "#BATTLE_PASS_ITEM_HEADER_DESC", Localize( rarityName ), headerText )
	}

	return headerText
}


string function GetBattlePassRewardItemName( BattlePassReward reward )
{
	return ItemFlavor_GetLongName( reward.flav )
}


string function GetBattlePassRewardItemDesc( BattlePassReward reward )
{
	string itemDesc = ItemFlavor_GetLongDescription( reward.flav )
	if ( ItemFlavor_GetType( reward.flav ) == eItemType.account_currency )
	{
		if ( reward.flav == GetItemFlavorByAsset( $"settings/itemflav/grx_currency/crafting.rpak" ) )
			itemDesc = GetFormattedValueForCurrency( reward.quantity, GRX_CURRENCY_CRAFTING )
		else
			itemDesc = GetFormattedValueForCurrency( reward.quantity, GRX_CURRENCY_PREMIUM )
	}
	else if ( ItemFlavor_GetType( reward.flav ) == eItemType.voucher )
	{
		itemDesc = Localize( itemDesc, int( BATTLEPASS_XP_BOOST_AMOUNT * 100 ) )
	}

	return itemDesc
}


array<RewardGroup> function GetRewardGroupsForPage( int pageNumber )
{
	array<RewardGroup> rewardGroups

	ItemFlavor ornull activeBattlePass = GetPlayerLastActiveBattlePass( ToEHI( GetLocalClientPlayer() ) )
	if ( activeBattlePass == null )
		return rewardGroups
	expect ItemFlavor( activeBattlePass )

	int levelOffset    = GetLevelOffsetForPage( activeBattlePass, pageNumber )
	int endLevelOffset = GetLevelEndForPage( activeBattlePass, pageNumber )

	for ( int levelIdx = levelOffset; levelIdx < endLevelOffset; levelIdx++ )
	{
		RewardGroup rewardGroup
		rewardGroup.level = levelIdx
		rewardGroup.rewards = GetBattlePassLevelRewards( activeBattlePass, levelIdx )
		rewardGroups.append( rewardGroup )
	}

	return rewardGroups
}

int function GetRewardsBoxSizeForGroup( RewardGroup rewardGroup )
{
	int numFree
	int numPremium

	foreach ( reward in rewardGroup.rewards )
	{
		if ( reward.isPremium )
			numPremium++
		else
			numFree++
	}

	return maxint( numPremium, numFree )                             
}

int function GetRewardsCountForLevel( ItemFlavor activeBattlePass, int level )
{
	int numFree
	int numPremium

	array<BattlePassReward> rewards = GetBattlePassLevelRewards( activeBattlePass, level )

	foreach ( reward in rewards )
	{
		if ( reward.isPremium )
			numPremium++
		else
			numFree++
	}

	return maxint( numPremium, numFree )                             
}

int function GetLevelOffsetForPage( ItemFlavor activeBattlePass, int pageIdx )
{
	if ( activeBattlePass in file.pageDatas )
	{
		return file.pageDatas[ activeBattlePass ][ pageIdx ].startLevel
	}

	array<int> pageToLevelIdx = [0]
	int levelsInCurrentPage   = 0
	int rewardCount           = 0
	int maxLevel              = GetBattlePassMaxLevelIndex( activeBattlePass )
	for ( int levelIdx = 0; levelIdx < maxLevel; levelIdx++ )
	{
		int rewardsLen = GetRewardsCountForLevel( activeBattlePass, levelIdx )

		if ( rewardsLen > 0 )
			levelsInCurrentPage++

		if ( rewardCount + rewardsLen <= REWARDS_PER_PAGE && levelsInCurrentPage < MAX_LEVELS_PER_PAGE )
		{
			rewardCount += rewardsLen
		}
		else
		{
			pageToLevelIdx.append( levelIdx )
			rewardCount = rewardsLen
			levelsInCurrentPage = 0
		}
	}

	return pageToLevelIdx[pageIdx]
}


int function GetNumPages( ItemFlavor activeBattlePass )
{
	if ( activeBattlePass in file.pageDatas )
		return file.pageDatas[ activeBattlePass ].len()

	array<int> pageToLevelIdx = [0]
	int levelsInCurrentPage   = 0
	int rewardCount           = 0
	int maxLevel              = GetBattlePassMaxLevelIndex( activeBattlePass )
	for ( int levelIdx = 0; levelIdx < maxLevel; levelIdx++ )
	{
		int rewardsLen = GetRewardsCountForLevel( activeBattlePass, levelIdx )

		if ( rewardsLen > 0 )
			levelsInCurrentPage++

		if ( rewardCount + rewardsLen <= REWARDS_PER_PAGE && levelsInCurrentPage < MAX_LEVELS_PER_PAGE )
		{
			rewardCount += rewardsLen
		}
		else
		{
			pageToLevelIdx.append( levelIdx )
			rewardCount = rewardsLen
			levelsInCurrentPage = 0
		}
	}

	return pageToLevelIdx.len()
}


int function GetLevelEndForPage( ItemFlavor activeBattlePass, int pageIdx )
{
	if ( activeBattlePass in file.pageDatas )
	{
		return file.pageDatas[ activeBattlePass ][ pageIdx ].endLevel
	}

	int rewardCount = 0
	int levelIdx    = GetLevelOffsetForPage( activeBattlePass, pageIdx )
	for ( int i = 0 ; i < MAX_LEVELS_PER_PAGE && levelIdx <= GetBattlePassMaxLevelIndex( activeBattlePass ) && rewardCount < REWARDS_PER_PAGE; levelIdx++ )
	{
		int rewardsLen = GetRewardsCountForLevel( activeBattlePass, levelIdx )
		rewardCount += rewardsLen

		if ( rewardCount > REWARDS_PER_PAGE )
			return levelIdx

		if ( rewardsLen > 0 )
			i++
	}

	return levelIdx
}


array<RewardGroup> function GetEmptyRewardGroups()
{
	array<RewardGroup> rewardGroups
	BattlePassReward emptyReward

	for ( int levelIdx = 0; levelIdx < 10; levelIdx++ )
	{
		RewardGroup rewardGroup
		rewardGroup.level = levelIdx
		rewardGroup.rewards.append( emptyReward )
		if ( levelIdx % 2 )
		{
			rewardGroup.rewards.append( emptyReward )
		}
		rewardGroups.append( rewardGroup )
	}

	return rewardGroups
}

void function BattlePass_UpdatePageOnOpen()
{
	ItemFlavor ornull activeBattlePass = GetPlayerLastActiveBattlePass( ToEHI( GetLocalClientPlayer() ) )
	if ( activeBattlePass == null || !GRX_IsInventoryReady() )
	{
		BattlePass_SetPage( 0 )
		return
	}
	expect ItemFlavor( activeBattlePass )
	int currentLevel    = GetPlayerBattlePassLevel( GetLocalClientPlayer(), activeBattlePass, false ) + 1
	bool hasPremiumPass = DoesPlayerOwnBattlePass( GetLocalClientPlayer(), activeBattlePass )

	int desiredPageNum                 = -1
	string desiredFocusRewardButtonKey = ""

	if ( SeasonPanel_GetLastMenuNavDirectionTopLevel() == MENU_NAV_BACK && file.currentPage != -1 && file.currentRewardButtonKey != null && (expect string(file.currentRewardButtonKey) in file.rewardKeyToRewardButtonDataMap) )
	{
		desiredPageNum = file.currentPage
		desiredFocusRewardButtonKey = expect string(file.currentRewardButtonKey)
	}
	else
	{
		desiredPageNum = BattlePass_GetPageForLevel( activeBattlePass, currentLevel )
	}

	BattlePass_SetPage( desiredPageNum )
	if ( desiredFocusRewardButtonKey != "" )
	{
		BattlePass_FocusRewardButton( file.rewardKeyToRewardButtonDataMap[desiredFocusRewardButtonKey] )
	}
	else
	{
		Hud_SetFocused( file.rewardButtonsPremium[0] )
	}

	file.rewardButtonFocusForced = true
}

void function BuildPageDatas( ItemFlavor activeBattlePass )
{
	if ( activeBattlePass in file.pageDatas )
		delete file.pageDatas[ activeBattlePass ]

	int numPages = GetNumPages( activeBattlePass )

	table<int, BattlePassPageData> datas

	for ( int pageNum = 0 ; pageNum < numPages ; pageNum++ )
	{
		int startLevel = GetLevelOffsetForPage( activeBattlePass, pageNum )
		int endLevel   = GetLevelEndForPage( activeBattlePass, pageNum )
		BattlePassPageData pData
		pData.startLevel = startLevel
		pData.endLevel = endLevel
		datas[ pageNum ] <- pData
	}

	file.pageDatas[ activeBattlePass ] <- datas
}


void function CalculateBattlePassRewardCurrencies()
{
	                                                               
	if ( fileLevel.numApexCoinsInBattlePass != 0 && fileLevel.numCraftingMetalsInBattlePass != 0 )
		return

	ItemFlavor ornull activeBattlePass = GetActiveBattlePass()
	if ( activeBattlePass == null )
		return

	expect ItemFlavor( activeBattlePass )

	                            
	fileLevel.numApexCoinsInBattlePass = 0
	fileLevel.numCraftingMetalsInBattlePass = 0

	int maxLevel = GetBattlePassMaxLevelIndex( activeBattlePass ) + 1

	for ( int levelIndex = 0; levelIndex < maxLevel; levelIndex++ )
	{
		array<BattlePassReward> rewards = GetBattlePassLevelRewards( activeBattlePass, levelIndex )
		foreach ( BattlePassReward reward in rewards )
		{
			switch ( reward.flav )
			{
				case GRX_CURRENCIES[ GRX_CURRENCY_PREMIUM ]:
					fileLevel.numApexCoinsInBattlePass += reward.quantity
					break

				case GRX_CURRENCIES[ GRX_CURRENCY_CRAFTING ]:
					fileLevel.numCraftingMetalsInBattlePass += reward.quantity
					break

				default:
					break
			}
		}
	}
}


int function BattlePass_GetPageForLevel( ItemFlavor activeBattlePass, int level )
{
	int numPages = GetNumPages( activeBattlePass )
	for ( int pageNum = 0 ; pageNum < numPages ; pageNum++ )
	{
		int startLevel = GetLevelOffsetForPage( activeBattlePass, pageNum )
		int endLevel   = GetLevelEndForPage( activeBattlePass, pageNum )
		if ( level >= startLevel && level <= endLevel )
			return pageNum
	}

	return numPages
}


int function BattlePass_GetNextLevelWithReward( ItemFlavor activeBattlePass, int currentLevelIdx )
{
	int maxLevelIdx = GetBattlePassMaxLevelIndex( activeBattlePass )
	maxLevelIdx += 1                                                                                                                                       
	for ( int levelIdx = currentLevelIdx; levelIdx <= maxLevelIdx; levelIdx++ )
	{
		array<BattlePassReward> rewards = GetBattlePassLevelRewards( activeBattlePass, levelIdx, GetLocalClientPlayer() )
		if ( rewards.len() > 0 )
			return levelIdx
	}

	return minint( currentLevelIdx, maxLevelIdx )
}


void function BattlePass_SetPage( int pageNumber )
{
	ItemFlavor ornull activeBattlePass = GetActiveBattlePass()
	if ( activeBattlePass == null )
	{
		file.currentPage = 0
		return
	}

	expect ItemFlavor( activeBattlePass )

	int numPages = GetNumPages( activeBattlePass )
	pageNumber = ClampInt( pageNumber, 0, numPages - 1 )

	if ( file.currentPage == pageNumber )
	{
		#if NX_PROG || PC_PROG_NX_UI
		UpdateRewardPanel( file.currentRewardGroups )
		#endif
		return
	}

	file.previousPage = file.currentPage
	file.currentPage = pageNumber

	file.currentRewardGroups = GetRewardGroupsForPage( pageNumber )

	UpdateRewardPanel( file.currentRewardGroups )
	bool prevPageAvailable = (pageNumber > 0)
	bool nextPageButton    = (pageNumber < numPages - 1)
	Hud_SetVisible( file.prevPageButton, prevPageAvailable )
	Hud_SetEnabled( file.invisiblePageLeftTriggerButton, prevPageAvailable )
	Hud_SetVisible( file.nextPageButton, nextPageButton )
	Hud_SetEnabled( file.invisiblePageRightTriggerButton, nextPageButton )

	int startLevel = GetLevelOffsetForPage( activeBattlePass, pageNumber )
	int endLevel   = GetLevelEndForPage( activeBattlePass, pageNumber )

	HudElem_SetRuiArg( file.rewardBarFooter, "currentPage", pageNumber )
	HudElem_SetRuiArg( file.rewardBarFooter, "levelRangeText", Localize( "#BATTLE_PASS_LEVEL_RANGE", startLevel + 1, endLevel ) )
	HudElem_SetRuiArg( file.rewardBarFooter, "numPages", GetNumPages( activeBattlePass ) )
	
	foreach ( button in file.rewardButtonsPremium )
	{
		HudElem_SetRuiArg( button, "forceFocusShineMarker", RandomInt( INT_MAX ) )
	}

	foreach ( button in file.rewardButtonsFree )
	{
		HudElem_SetRuiArg( button, "forceFocusShineMarker", RandomInt( INT_MAX ) )
	}
}
#endif


#if UI
void function OnPanelShow( var panel )
{
	RegisterStickMovedCallback( ANALOG_RIGHT_X, TryChangePageFromRS )

	UI_SetPresentationType( ePresentationType.BATTLE_PASS_3 )
	                                                                                  

	RegisterButtonPressedCallback( MOUSE_WHEEL_DOWN, BattlePass_PageForward )
	RegisterButtonPressedCallback( MOUSE_WHEEL_UP, BattlePass_PageBackward )
	                                                                               
	                                                                               

	file.isShowingBattlePassProgress = false
	UpdateBattlePassProgress( true, true )

	BattlePass_UpdatePageOnOpen()
	BattlePass_UpdateStatus()
	BattlePass_UpdatePurchaseButton( file.purchaseButton )

	CalculateBattlePassRewardCurrencies()

	AddCallbackAndCallNow_OnGRXOffersRefreshed( OnGRXStateChanged )
	AddCallbackAndCallNow_OnGRXInventoryStateChanged( OnGRXStateChanged )

	HudElem_SetRuiArg( file.detailBox, "useSmallFont", ShouldUseSmallFont() )
	HudElem_SetRuiArg( file.statusBox, "timeRemainingOffsetY", GetTimeRemainingOffsetY() )
	                                       
}

bool function ShouldUseSmallFont()
{
	switch ( GetLanguage() )
	{
		case "german":
			return true
	}

	return false
}

float function GetTimeRemainingOffsetY()
{
	switch ( GetLanguage() )
	{
		case "japanese":
			return 8.0
	}

	return 2.0
}

void function OnPanelHide( var panel )
{
	Signal( uiGlobal.signalDummy, "TryChangePageThread" )
	DeregisterStickMovedCallback( ANALOG_RIGHT_X, TryChangePageFromRS )

	                                                                          

	DeregisterButtonPressedCallback( MOUSE_WHEEL_DOWN, BattlePass_PageForward )
	DeregisterButtonPressedCallback( MOUSE_WHEEL_UP, BattlePass_PageBackward )
	                                                                                 
	                                                                                 

	RemoveCallback_OnGRXOffersRefreshed( OnGRXStateChanged )
	RemoveCallback_OnGRXInventoryStateChanged( OnGRXStateChanged )

	RunClientScript( "ClearBattlePassItem" )
}

void function TryChangePageFromRS( ... )
{
	float stickDeflection = expect float( vargv[1] )
	                                                

	int stickState = eStickState.NEUTRAL
	if ( stickDeflection > 0.25 )
		stickState = eStickState.RIGHT
	else if ( stickDeflection < -0.25 )
		stickState = eStickState.LEFT

	if ( stickState != file.lastStickState )
	{
		file.stickRepeatAllowTime = UITime()
		file.lastStickState = stickState
		thread TryChangePageThread( stickState )
	}
	else
	{
		file.lastStickState = stickState
	}
}

void function TryChangePageThread( int stickState )
{
	Signal( uiGlobal.signalDummy, "TryChangePageThread" )
	EndSignal( uiGlobal.signalDummy, "TryChangePageThread" )

	if ( stickState == eStickState.NEUTRAL )
		return

	int times = 0

	while ( stickState == file.lastStickState )
	{
		if ( file.stickRepeatAllowTime <= UITime() )
		{
			if ( stickState == eStickState.RIGHT )
			{
				                        
				BattlePass_PageForward( null )
			}
			else if ( stickState == eStickState.LEFT )
			{
				                       
				BattlePass_PageBackward( null )
			}

			file.stickRepeatAllowTime = UITime() + GetPageDelay( times )
			times++
		}

		WaitFrame()
	}
}

float function GetPageDelay( int repeatCount )
{
	if ( repeatCount > 2 )
		return CURSOR_DELAY_FAST
	if ( repeatCount > 0 )
		return CURSOR_DELAY_MED

	return CURSOR_DELAY_BASE
}

void function OnGRXStateChanged()
{
	bool ready = GRX_IsInventoryReady() && GRX_AreOffersReady()

	if ( !ready )
		return

	thread TryDisplayBattlePassAwards( true )
}


void function BattlePass_UpdatePurchaseButton( var button, bool showUpsell = true )
{
	ItemFlavor ornull activeBattlePass = GetPlayerActiveBattlePass( ToEHI( GetLocalClientPlayer() ) )
	if ( activeBattlePass == null || !GRX_IsInventoryReady() )
	{
		Hud_SetEnabled( button, false )
		Hud_SetVisible( button, false )
		HudElem_SetRuiArg( button, "buttonText", "#COMING_SOON" )
		return
	}

	expect ItemFlavor( activeBattlePass )

	Hud_SetEnabled( button, true )
	Hud_SetVisible( button, true )
	Hud_SetLocked( button, false )
	Hud_ClearToolTipData( button )

	HudElem_SetRuiArg( button, "showUnlockedString", false )

	if ( GRX_IsItemOwnedByPlayer( activeBattlePass ) )
	{
		HudElem_SetRuiArg( button, "buttonText", "#BATTLE_PASS_BUTTON_PURCHASE_XP" )

		if ( GetPlayerBattlePassPurchasableLevels( ToEHI( GetLocalClientPlayer() ), activeBattlePass ) == 0 )
		{
			Hud_SetLocked( button, true )
			ToolTipData toolTipData
			toolTipData.titleText = "#BATTLE_PASS_MAX_PURCHASE_LEVEL"
			toolTipData.descText = "#BATTLE_PASS_MAX_PURCHASE_LEVEL_DESC"
			Hud_SetToolTipData( button, toolTipData )
		}
	}
	else
	{
		HudElem_SetRuiArg( button, "buttonText", "#BATTLE_PASS_BUTTON_PURCHASE" )

		int level = GetPlayerBattlePassLevel( GetLocalClientPlayer(), activeBattlePass, false )

		if ( level > 0 )
		{
			ToolTipData toolTipData
			toolTipData.titleText = "#BATTLE_PASS_BUTTON_PURCHASE"
			toolTipData.descText = "#BUTTON_BATTLE_PASS_PURCHASE_DESC"
			Hud_SetToolTipData( button, toolTipData )
		}

		if ( showUpsell )
		{
			if ( level > 10 )
			{
				HudElem_SetRuiArg( button, "showUnlockedString", true )

				Hud_SetY( button, -1 * int(Hud_GetHeight( file.purchaseBG ) * 0.15) )

				BattlePass_SetUnlockedString( button, level )
			}
			else
			{
				Hud_SetY( button, 0 )
			}
		}
	}
}

void function BattlePass_SetUnlockedString( var button, int level )
{
	int numRares       = GetNumPremiumRewardsOfTypeUpToLevel( level, eRarityTier.RARE, [ eItemType.account_currency, eItemType.account_currency_bundle ] )
	int numEpics       = GetNumPremiumRewardsOfTypeUpToLevel( level, eRarityTier.EPIC, [ eItemType.account_currency, eItemType.account_currency_bundle ] )
	int numLegendaries = GetNumPremiumRewardsOfTypeUpToLevel( level, eRarityTier.LEGENDARY, [ eItemType.account_currency, eItemType.account_currency_bundle ] )

	ItemFlavor apexCoins        = GRX_CURRENCIES[ GRX_CURRENCY_PREMIUM ]
	ItemFlavor craftingCurrency = GRX_CURRENCIES[ GRX_CURRENCY_CRAFTING ]

	int numCoins    = GetNumPremiumRewardsOfTypeUpToLevel( level, -1, [], [ apexCoins ] )
	int numCrafting = GetNumPremiumRewardsOfTypeUpToLevel( level, -1, [], [ craftingCurrency ] )

	printt( "numRares " + numRares )
	printt( "numEpics " + numEpics )
	printt( "numLegendaries " + numLegendaries )
	printt( "numCoins " + numCoins )
	printt( "numCrafting " + numCrafting )

	const int MAX_UNLOCK_THINGS = 5
	const int MAX_COLOR_TIERS = 3

	array<string> unlockedStrings
	int colorTiersUsed
	if ( colorTiersUsed < MAX_COLOR_TIERS && unlockedStrings.len() < MAX_UNLOCK_THINGS && numLegendaries > 0 )
	{
		int quality = eRarityTier.LEGENDARY
		int count   = numLegendaries
		unlockedStrings.append( Localize( "#BATTLEPASS_DISPLAY_QUANTITY_QUALITY", count, Localize( ItemQuality_GetQualityName( quality ) ), (colorTiersUsed + 1) ) )
		HudElem_SetRuiArg( button, "unlockedStringColorTier" + (colorTiersUsed + 1), quality )
		HudElem_SetRuiArg( button, "altStyle" + (colorTiersUsed + 1) + "Color", SrgbToLinear( GetKeyColor( COLORID_MENU_TEXT_LOOT_TIER0, quality + 1 ) / 255.0 ) )
		colorTiersUsed++
	}

	if ( colorTiersUsed < MAX_COLOR_TIERS && unlockedStrings.len() < MAX_UNLOCK_THINGS && numEpics > 0 )
	{
		int quality = eRarityTier.EPIC
		int count   = numEpics
		unlockedStrings.append( Localize( "#BATTLEPASS_DISPLAY_QUANTITY_QUALITY", count, Localize( ItemQuality_GetQualityName( quality ) ), (colorTiersUsed + 1) ) )
		HudElem_SetRuiArg( button, "unlockedStringColorTier" + (colorTiersUsed + 1), quality )
		HudElem_SetRuiArg( button, "altStyle" + (colorTiersUsed + 1) + "Color", SrgbToLinear( GetKeyColor( COLORID_MENU_TEXT_LOOT_TIER0, quality + 1 ) / 255.0 ) )
		colorTiersUsed++
	}

	if ( colorTiersUsed < MAX_COLOR_TIERS && unlockedStrings.len() < MAX_UNLOCK_THINGS && numRares > 0 )
	{
		int quality = eRarityTier.RARE
		int count   = numRares
		unlockedStrings.append( Localize( "#BATTLEPASS_DISPLAY_QUANTITY_QUALITY", count, Localize( ItemQuality_GetQualityName( quality ) ), (colorTiersUsed + 1) ) )
		HudElem_SetRuiArg( button, "unlockedStringColorTier" + (colorTiersUsed + 1), quality )
		HudElem_SetRuiArg( button, "altStyle" + (colorTiersUsed + 1) + "Color", SrgbToLinear( GetKeyColor( COLORID_MENU_TEXT_LOOT_TIER0, quality + 1 ) / 255.0 ) )
		colorTiersUsed++
	}

	if ( unlockedStrings.len() < MAX_UNLOCK_THINGS && numCoins > 0 )
	{
		int count          = numCoins
		string imageString = ItemFlavor_GetIcon( apexCoins )
		unlockedStrings.append( Localize( "#BATTLEPASS_DISPLAY_QUANTITY_CURRENCY", "%$" + imageString + "%", count, 0 ) )
	}

	if ( unlockedStrings.len() < MAX_UNLOCK_THINGS && numCrafting > 0 )
	{
		int count          = numCrafting
		string imageString = ItemFlavor_GetIcon( craftingCurrency )
		unlockedStrings.append( Localize( "#BATTLEPASS_DISPLAY_QUANTITY_CURRENCY", "%$" + imageString + "%", count, 0 ) )
	}

	int stringCount = unlockedStrings.len()
	while ( unlockedStrings.len() < MAX_UNLOCK_THINGS )
		unlockedStrings.append( "" )

	string unlockedString = Localize( "#BATTLEPASS_REWARDS_DISPLAY_" + stringCount, unlockedStrings[0], unlockedStrings[1], unlockedStrings[2], unlockedStrings[3], unlockedStrings[4] )

	HudElem_SetRuiArg( button, "unlockedString", unlockedString )
}

int function GetNumPremiumRewardsOfTypeUpToLevel( int endLevel, int tier, array<int> excludeItemTypes = [], array<ItemFlavor> onlyMatchItemFlavs = [] )
{
	ItemFlavor ornull activeBattlePass = GetActiveBattlePass()

	if ( activeBattlePass == null )
		return 0

	expect ItemFlavor( activeBattlePass )

	int count

	for ( int levelIdx = 0; levelIdx <= endLevel; levelIdx++ )
	{
		array<BattlePassReward> rewards = GetBattlePassLevelRewards( activeBattlePass, levelIdx )
		foreach ( reward in rewards )
		{
			if ( reward.isPremium )
			{
				if ( (tier == -1 || ItemFlavor_GetQuality( reward.flav ) == tier)
				&& (
				(onlyMatchItemFlavs.len() == 0 && !excludeItemTypes.contains( ItemFlavor_GetType( reward.flav ) ))
				|| (onlyMatchItemFlavs.len() > 0 && onlyMatchItemFlavs.contains( reward.flav ))
				)
				)
				{
					printt( ItemFlavor_GetHumanReadableRef( reward.flav ) )
					count += reward.quantity
				}
			}
		}
	}

	return count
}

void function BattlePass_UpdateStatus()
{
	ItemFlavor ornull activeBattlePass = GetPlayerLastActiveBattlePass( ToEHI( GetLocalClientPlayer() ) )
	bool hasActiveBattlePass           = activeBattlePass != null

	if ( !hasActiveBattlePass )
		return

	expect ItemFlavor(activeBattlePass)

	int currentBattlePassXP = GetPlayerBattlePassXPProgress( ToEHI( GetLocalClientPlayer() ), activeBattlePass, false )

	int ending_passLevel = GetBattlePassLevelForXP( activeBattlePass, currentBattlePassXP )
	int ending_passXP    = GetTotalXPToCompletePassLevel( activeBattlePass, ending_passLevel - 1 )

	int ending_nextPassLevelXP
	if ( ending_passLevel > GetBattlePassMaxLevelIndex( activeBattlePass ) )
		ending_nextPassLevelXP = ending_passXP
	else
		ending_nextPassLevelXP = GetTotalXPToCompletePassLevel( activeBattlePass, ending_passLevel )

	int xpToCompleteLevel = ending_nextPassLevelXP - ending_passXP
	int xpForLevel        = currentBattlePassXP - ending_passXP

	Assert( currentBattlePassXP >= ending_passXP )
	Assert( currentBattlePassXP <= ending_nextPassLevelXP )
	float ending_passLevelFrac = GraphCapped( currentBattlePassXP, ending_passXP, ending_nextPassLevelXP, 0.0, 1.0 )

	                                                                                                 
	                                                                             
	  
	                                                                                                                                              
	                                                                                

	ItemFlavor currentSeason = GetLatestSeason( GetUnixTimestamp() )
	int seasonEndUnixTime    = CalEvent_GetFinishUnixTime( currentSeason )
	int remainingSeasonTime  = seasonEndUnixTime - GetUnixTimestamp()

	if ( remainingSeasonTime > 0 )
	{
		DisplayTime dt = SecondsToDHMS( remainingSeasonTime )
		HudElem_SetRuiArg( file.statusBox, "timeRemainingText", Localize( "#DAYS_REMAINING", string( dt.days ), string( dt.hours ) ) )
	}
	else
	{
		HudElem_SetRuiArg( file.statusBox, "timeRemainingText", Localize( "#BATTLE_PASS_SEASON_ENDED" ) )
	}

	HudElem_SetRuiArg( file.statusBox, "seasonNameText", ItemFlavor_GetLongName( activeBattlePass ) )
	HudElem_SetRuiArg( file.statusBox, "seasonNumberText", Localize( ItemFlavor_GetShortName( activeBattlePass ) ) )
	HudElem_SetRuiArg( file.statusBox, "smallLogo", GetGlobalSettingsAsset( ItemFlavor_GetAsset( activeBattlePass ), "smallLogo" ), eRuiArgType.IMAGE )
	HudElem_SetRuiArg( file.statusBox, "bannerImage", GetGlobalSettingsAsset( ItemFlavor_GetAsset( activeBattlePass ), "bannerImage" ), eRuiArgType.IMAGE )

	ItemFlavor dummy
	ItemFlavor bpLevelBadge = GetBattlePassProgressBadge( activeBattlePass )

	RuiDestroyNestedIfAlive( Hud_GetRui( file.purchaseBG ), "currentBadgeHandle" )
	CreateNestedGladiatorCardBadge( Hud_GetRui( file.purchaseBG ), "currentBadgeHandle", ToEHI( GetLocalClientPlayer() ), bpLevelBadge, 0, dummy, ending_passLevel + 1 )
}
#endif


#if UI
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

} s_passPurchaseXPDialog
#endif


#if UI
void function InitBattlePassRewardButtonRui( var rui, BattlePassReward bpReward )
{
	ItemFlavor ornull activeBattlePass = GetPlayerLastActiveBattlePass( ToEHI( GetLocalClientPlayer() ) )
	bool hasActiveBattlePass           = activeBattlePass != null && GRX_IsInventoryReady()
	bool hasPremiumPass                = false
	int battlePassLevel                = 0
	if ( hasActiveBattlePass )
	{
		expect ItemFlavor( activeBattlePass )
		hasPremiumPass = DoesPlayerOwnBattlePass( GetLocalClientPlayer(), activeBattlePass )
		battlePassLevel = GetPlayerBattlePassLevel( GetLocalClientPlayer(), activeBattlePass, false )
	}

	bool isOwned = (!bpReward.isPremium || hasPremiumPass) && bpReward.level < battlePassLevel
	RuiSetBool( rui, "isOwned", isOwned )
	RuiSetBool( rui, "isPremium", bpReward.isPremium )

	int rarity = ItemFlavor_HasQuality( bpReward.flav ) ? ItemFlavor_GetQuality( bpReward.flav ) : 0
	RuiSetInt( rui, "rarity", rarity )
	RuiSetImage( rui, "buttonImage", CustomizeMenu_GetRewardButtonImage( bpReward.flav ) )
	RuiSetImage( rui, "buttonImageSecondLayer", $"" )
	RuiSetFloat2( rui, "buttonImageSecondLayerOffset", <0.0, 0.0, 0.0> )

	if ( ItemFlavor_GetType( bpReward.flav ) == eItemType.account_pack )
		RuiSetBool( rui, "isLootBox", true )
	else
		RuiSetBool( rui, "isLootBox", false )

	RuiSetString( rui, "itemCountString", "" )
	if ( ItemFlavor_GetType( bpReward.flav ) == eItemType.account_currency )
		RuiSetString( rui, "itemCountString", FormatAndLocalizeNumber( "1", float( bpReward.quantity ), true ) )
}
#endif

#if UI

void function InitAboutBattlePass1Dialog( var newMenuArg )
                                              
{
	var menu = newMenuArg
	SetDialog( menu, true )
	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, AboutBattlePass1Dialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, AboutBattlePass1Dialog_OnClose )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )

	file.aboutProgressButton = Hud_GetChild( menu, "CurrentProgress" )
	AddButtonEventHandler( file.aboutProgressButton, UIE_CLICK, AboutProgressButton_OnClick )


	file.aboutPurchaseButton = Hud_GetChild( menu, "PurchaseButton" )
	AddButtonEventHandler( file.aboutPurchaseButton, UIE_CLICK, AboutPurchaseButton_OnClick )
}

void function AboutPurchaseButton_OnClick( var button )
{
	ItemFlavor ornull activeBattlePass = GetPlayerActiveBattlePass( ToEHI( GetLocalClientPlayer() ) )
	if ( activeBattlePass == null || !GRX_IsInventoryReady() )
	{
		return
	}
	expect ItemFlavor( activeBattlePass )

	bool hasPremiumPass = DoesPlayerOwnBattlePass( GetLocalClientPlayer(), activeBattlePass )

	if ( !hasPremiumPass )
	{
		CloseActiveMenu()
		SetCurrentTabForPIN( "PassPanel" )                                     
		AdvanceMenu( GetMenu( "PassPurchaseMenu" ) )
	}
}

void function AboutProgressButton_OnClick( var button )
{
	JumpToSeasonTab( "PassPanel" )
}

void function AboutBattlePass1Dialog_OnOpen()
{
	var menu                = GetMenu( "BattlePassAboutPage1" )
	var rui                 = Hud_GetRui( Hud_GetChild( menu, "InfoPanel" ) )
	bool showPurchaseButton = true

	RegisterButtonPressedCallback( KEY_SPACE, AboutProgressButton_OnClick )

	ItemFlavor ornull activeBattlePass = GetActiveBattlePass()
	if ( activeBattlePass == null )
	{
		showPurchaseButton = false
		activeBattlePass = GetPlayerLastActiveBattlePass( ToEHI( GetLocalClientPlayer() ) )
		if ( activeBattlePass == null )
			return
	}

	expect ItemFlavor( activeBattlePass )
	var infoPanel = Hud_GetChild( menu, "InfoPanel" )

	bool passOwned = GRX_IsItemOwnedByPlayer( activeBattlePass )
	asset battlePassAsset = ItemFlavor_GetAsset( activeBattlePass )

	int buttonWidth = Hud_GetWidth( file.aboutProgressButton )
	float scaleFactor = buttonWidth/425.0
	Hud_SetX( file.aboutProgressButton, passOwned ? -172*scaleFactor : 75*scaleFactor )
	Hud_SetX( file.aboutPurchaseButton, 250*scaleFactor )
	RuiSetImage( rui, "logo", GetGlobalSettingsAsset( battlePassAsset , "largeLogo" ) )
	RuiSetString( rui, "battlePassName", GetGlobalSettingsStringAsAsset( battlePassAsset, "aboutPurchaseTitle" ) )	

	Hud_SetVisible( file.aboutPurchaseButton, !passOwned && showPurchaseButton )
}

void function AboutBattlePass1Dialog_OnClose()
{
	DeregisterButtonPressedCallback( KEY_SPACE, AboutProgressButton_OnClick )
	SocialEventUpdate()
}

#endif


#if UI
void function ShowRewardTable( var button )
{
	  
}
#endif


#if CLIENT
void function UIToClient_StartTempBattlePassPresentationBackground( asset bgImage )
{
	                                                                         
	if ( fileLevel.isTempBattlePassPresentationBackgroundThreadActive )
		return
	thread TempBattlePassPresentationBackground_Thread( bgImage )
}
#endif


#if CLIENT
void function UIToClient_StopTempBattlePassPresentationBackground()
{
	                                                                        
	Signal( fileLevel.signalDummy, "StopTempBattlePassPresentationBackgroundThread" )
	                       
}
#endif


#if CLIENT
void function UIToClient_StopBattlePassScene()
{
	ClearBattlePassItem()
}
#endif


#if CLIENT
                          
   
  	                 
  	                 
  	                    
   
struct CarouselColumnState
{
	int    level = -1
	var    topo
	var    rui
	var    columnClickZonePanel
	entity reward1Model
	var    reward1DetailsPanel
	entity reward2Model
	var    reward2DetailsPanel
	entity light
	float  growSize = 0.0
}


void function TempBattlePassPresentationBackground_Thread( asset bgImage )
{
	Signal( fileLevel.signalDummy, "StopTempBattlePassPresentationBackgroundThread" )             
	EndSignal( fileLevel.signalDummy, "StopTempBattlePassPresentationBackgroundThread" )

	fileLevel.isTempBattlePassPresentationBackgroundThreadActive = true

	entity cam = clGlobal.menuCamera
	                                                                                                      
	                                                                                                                        
	                  

	float camSceneDist = 100.0
	vector camOrg      = cam.GetOrigin()
	vector camAng      = cam.GetAngles()
	vector camForward  = AnglesToForward( camAng )
	vector camRight    = AnglesToRight( camAng )
	vector camUp       = AnglesToUp( camAng )

	float lol          = 0.2
	vector bgCenterPos = camOrg + 600.0 * camForward - lol * 1920.0 * 0.5 * camRight + lol * 1080.0 * 0.5 * camUp
	var bgTopo         = RuiTopology_CreatePlane( bgCenterPos, lol * 1920.0 * camRight, lol * 1080.0 * -camUp, false )
	                                                     
	var bgRui          = RuiCreate( $"ui/lobby_battlepass_temp_bg.rpak", bgTopo, RUI_DRAW_WORLD, 10000 )
	                                           
	RuiSetImage( bgRui, "bgImage", bgImage )
	                                             

	entity bgModel = CreateClientSidePropDynamic( bgCenterPos + 50.0 * camForward, -camForward, $"mdl/menu/loot_ceremony_stat_tracker_bg.rmdl" )
	bgModel.MakeSafeForUIScriptHack()
	bgModel.SetModelScale( 20.0 )

	OnThreadEnd( function() : ( bgTopo, bgRui, bgModel ) {
		fileLevel.isTempBattlePassPresentationBackgroundThreadActive = false

		RuiDestroy( bgRui )
		RuiTopology_Destroy( bgTopo )
		if ( IsValid( bgModel ) )
			bgModel.Destroy()
	} )

	WaitForever()
}
#endif


#if CLIENT
void function OnMouseWheelUp( entity unused )
{
	  
}
#endif


#if CLIENT
void function OnMouseWheelDown( entity unused )
{
	  
}
#endif

#if UI
struct
{
	var menu
	var rewardPanel
	var passPurchaseButton
	var bundlePurchaseButton
	var backgroundsPanel
	var passBanner
	var overlayPanel
	var seasonLogoBox
	var offersBorders

	bool closeOnGetTopLevel = false
} s_passPurchaseMenu

void function InitPassPurchaseMenu( var newMenuArg )
                                              
{
	var menu = GetMenu( "PassPurchaseMenu" )
	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, PassPurchaseMenu_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_GET_TOP_LEVEL, PassPurchaseMenu_OnGetTopLevel )

	s_passPurchaseMenu.menu = menu
	s_passPurchaseMenu.passPurchaseButton = Hud_GetChild( menu, "PassPurchaseButton" )
	s_passPurchaseMenu.bundlePurchaseButton = Hud_GetChild( menu, "BundlePurchaseButton" )

	s_passPurchaseMenu.backgroundsPanel = Hud_GetChild( menu, "Backgrounds" )
	s_passPurchaseMenu.passBanner = Hud_GetChild( menu, "HeaderBanner" )
	Hud_AddEventHandler( s_passPurchaseMenu.passPurchaseButton, UIE_GET_FOCUS, PassPurchaseButton_OnFocus )
	Hud_AddEventHandler( s_passPurchaseMenu.passPurchaseButton, UIE_LOSE_FOCUS, PassPurchaseButton_OnLoseFocus )
	Hud_AddEventHandler( s_passPurchaseMenu.bundlePurchaseButton, UIE_GET_FOCUS, BundlePurchaseButton_OnFocus )
	Hud_AddEventHandler( s_passPurchaseMenu.bundlePurchaseButton, UIE_LOSE_FOCUS, BundlePurchaseButton_OnLoseFocus )

	Hud_AddEventHandler( s_passPurchaseMenu.passPurchaseButton, UIE_CLICK, PassPurchaseButton_OnActivate )
	Hud_AddEventHandler( s_passPurchaseMenu.bundlePurchaseButton, UIE_CLICK, BundlePurchaseButton_OnActivate )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}
void function PassPurchaseButton_OnFocus( var button )
{
	HudElem_SetRuiArg( s_passPurchaseMenu.backgroundsPanel, "isPremiumFocused", true)
	Hud_SetLocked( s_passPurchaseMenu.bundlePurchaseButton, true )
}
 
void function PassPurchaseButton_OnLoseFocus( var button )
{
	HudElem_SetRuiArg( s_passPurchaseMenu.backgroundsPanel, "isPremiumFocused", false)
	Hud_SetLocked( s_passPurchaseMenu.bundlePurchaseButton, false )
}

void function PassPurchaseButton_OnActivate( var button )
{
	ItemFlavor ornull activeBattlePass = GetPlayerActiveBattlePass( ToEHI( GetLocalClientPlayer() ) )
	if ( activeBattlePass == null || !GRX_IsInventoryReady() )
		return

	expect ItemFlavor( activeBattlePass )

	if ( !CanPlayerPurchaseBattlePass( GetLocalClientPlayer(), activeBattlePass ) )
		return

	ItemFlavor purchasePack = BattlePass_GetBasicPurchasePack( activeBattlePass )
	if ( !GRX_GetItemPurchasabilityInfo( purchasePack ).isPurchasableAtAll )
		return

	PurchaseDialogConfig pdc
	pdc.flav = purchasePack
	pdc.quantity = 1
	pdc.onPurchaseResultCallback = OnBattlePassPurchaseResults
	pdc.purchaseSoundOverride = "UI_Menu_BattlePass_Purchase"
	PurchaseDialog( pdc )
}

void function BundlePurchaseButton_OnFocus( var button )
{
	HudElem_SetRuiArg( s_passPurchaseMenu.backgroundsPanel, "isBundleFocused", true)
	Hud_SetLocked( s_passPurchaseMenu.passPurchaseButton, true )
}

void function BundlePurchaseButton_OnLoseFocus( var button )
{
	HudElem_SetRuiArg( s_passPurchaseMenu.backgroundsPanel, "isBundleFocused", false)
	Hud_SetLocked( s_passPurchaseMenu.passPurchaseButton, false )
}

void function BundlePurchaseButton_OnActivate( var button )
{
	ItemFlavor ornull activeBattlePass = GetPlayerActiveBattlePass( ToEHI( GetLocalClientPlayer() ) )
	if ( activeBattlePass == null || !GRX_IsInventoryReady() )
		return

	expect ItemFlavor( activeBattlePass )

	if ( !CanPlayerPurchaseBattlePass( GetLocalClientPlayer(), activeBattlePass ) )
		return

	if ( GetPlayerBattlePassPurchasableLevels( ToEHI( GetLocalClientPlayer() ), activeBattlePass ) < 25 )
		return

	ItemFlavor purchasePack = BattlePass_GetBundlePurchasePack( activeBattlePass )
	if ( !GRX_GetItemPurchasabilityInfo( purchasePack ).isPurchasableAtAll )
		return

	PurchaseDialogConfig pdc
	pdc.flav = purchasePack
	pdc.quantity = 1
	pdc.onPurchaseResultCallback = OnBattlePassPurchaseResults
	pdc.purchaseSoundOverride = "UI_Menu_BattlePass_Purchase"
	PurchaseDialog( pdc )
}


void function PassPurchaseMenu_OnOpen()
{
	SetCurrentTabForPIN( "PassPanel" )                                     

	RunClientScript( "ClearBattlePassItem" )
	UI_SetPresentationType( ePresentationType.BATTLE_PASS )

	ItemFlavor ornull activeBattlePass = GetPlayerActiveBattlePass( ToEHI( GetLocalClientPlayer() ) )
	if ( activeBattlePass == null || !GRX_IsInventoryReady() )
		return

	expect ItemFlavor( activeBattlePass )
	asset battlePassAsset = ItemFlavor_GetAsset( activeBattlePass )
	bool offerRestricted  = GRX_IsOfferRestricted( GetLocalClientPlayer() )

	var rui = Hud_GetRui( s_passPurchaseMenu.passBanner )
	RuiSetString( rui, "seasonName", GetGlobalSettingsStringAsAsset( battlePassAsset, "aboutPurchaseTitle" ) )
	HudElem_SetRuiArg( s_passPurchaseMenu.bundlePurchaseButton, "isBonusFrame", true )
	
	UpdatePassPurchaseButtons()
}


void function PassPurchaseMenu_OnGetTopLevel()
{
	if ( s_passPurchaseMenu.closeOnGetTopLevel )
	{
		s_passPurchaseMenu.closeOnGetTopLevel = false
		CloseActiveMenu()
	}
}


void function UpdatePassPurchaseButtons()
{
	Assert( GRX_IsInventoryReady() )

	ItemFlavor ornull activeBattlePass = GetPlayerActiveBattlePass( ToEHI( GetLocalClientPlayer() ) )
	if ( activeBattlePass == null || !GRX_IsInventoryReady() )
		return
	expect ItemFlavor( activeBattlePass )

	        
	ItemFlavor basicPurchaseFlav = BattlePass_GetBasicPurchasePack( activeBattlePass )
	var basicButton              = Hud_GetRui( s_passPurchaseMenu.passPurchaseButton )
	RuiSetAsset( basicButton, "backgroundImage", ItemFlavor_GetIcon( basicPurchaseFlav ) )
	RuiSetString( basicButton, "offerTitle", ItemFlavor_GetShortName( basicPurchaseFlav ) )
	RuiSetString( basicButton, "offerDesc", ItemFlavor_GetLongDescription( basicPurchaseFlav ) )

	array<GRXScriptOffer> basicPurchaseOffers = GRX_GetItemDedicatedStoreOffers( basicPurchaseFlav, "battlepass" )
	                                          
	if ( basicPurchaseOffers.len() == 1 )
	{
		GRXScriptOffer basicPurchaseOffer = basicPurchaseOffers[0]
		Assert( basicPurchaseOffer.prices.len() == 1 )
		if ( basicPurchaseOffer.prices.len() == 1 )
		{
			RuiSetString( basicButton, "price", GRX_GetFormattedPrice( basicPurchaseOffer.prices[0] ) )
		}
		else Warning( "Expected 1 price for basic pack offer of '%s'", ItemFlavor_GetHumanReadableRef( activeBattlePass ) )
	}
	else
	{
		Warning( "Expected 1 offer for basic pack of '%s'", ItemFlavor_GetHumanReadableRef( activeBattlePass ) )

		foreach ( offer in basicPurchaseOffers )
			printt("UpdatePassPurchaseButtons - offer in basic battle pass is" + offer.offerAlias)
	}


	         
	ItemFlavor bundlePurchaseFlav = BattlePass_GetBundlePurchasePack( activeBattlePass )
	var bundleButton              = Hud_GetRui( s_passPurchaseMenu.bundlePurchaseButton )
	RuiSetAsset( bundleButton, "backgroundImage", ItemFlavor_GetIcon( bundlePurchaseFlav ) )
	RuiSetString( bundleButton, "offerTitle", ItemFlavor_GetShortName( bundlePurchaseFlav ) )
	RuiSetString( bundleButton, "offerDesc", ItemFlavor_GetLongDescription( bundlePurchaseFlav ) )

	array<GRXScriptOffer> bundlePurchaseOffers = GRX_GetItemDedicatedStoreOffers( bundlePurchaseFlav, "battlepass" )
	                                           
	if ( bundlePurchaseOffers.len() == 1 )
	{
		GRXScriptOffer bundlePurchaseOffer = bundlePurchaseOffers[0]
		Assert( bundlePurchaseOffer.prices.len() == 1 )
		if ( bundlePurchaseOffer.prices.len() == 1 )
		{
			RuiSetString( bundleButton, "price", GRX_GetFormattedPrice( bundlePurchaseOffer.prices[0] ) )
		}
		else Warning( "Expected 1 price for bundle pack offer of '%s'", ItemFlavor_GetHumanReadableRef( activeBattlePass ) )
	}
	else Warning( "Expected 1 offer for bundle pack of '%s'", ItemFlavor_GetHumanReadableRef( activeBattlePass ) )

	bool canPurchaseBundle = GetPlayerBattlePassPurchasableLevels( ToEHI( GetLocalClientPlayer() ), activeBattlePass ) >= 25

	Hud_SetLocked( s_passPurchaseMenu.bundlePurchaseButton, !canPurchaseBundle )
	if ( !canPurchaseBundle )
	{
		ToolTipData toolTipData
		toolTipData.titleText = "#BATTLE_PASS_BUNDLE_PROTECT"
		toolTipData.descText = "#BATTLE_PASS_BUNDLE_PROTECT_DESC"
		Hud_SetToolTipData( s_passPurchaseMenu.bundlePurchaseButton, toolTipData )
	}
	else
	{
		Hud_ClearToolTipData( s_passPurchaseMenu.bundlePurchaseButton )
	}
}

void function OnBattlePassPurchaseResults( bool wasSuccessful )
{
	if ( wasSuccessful )
	{
		s_passPurchaseMenu.closeOnGetTopLevel = true
	}
}
#endif      

#if UI
bool function TryDisplayBattlePassAwards( bool playSound = false )
{
	WaitEndFrame()

	bool ready = GRX_IsInventoryReady() && GRX_AreOffersReady()
	if ( !ready )
		return false

	EHI playerEHI                      = ToEHI( GetLocalClientPlayer() )
	ItemFlavor ornull activeBattlePass = GetPlayerLastActiveBattlePass( ToEHI( GetLocalClientPlayer() ) )
	if ( activeBattlePass == null || !GRX_IsInventoryReady() )
		return false

	expect ItemFlavor( activeBattlePass )

	int currentXP       = GetPlayerBattlePassXPProgress( playerEHI, activeBattlePass )
	int lastSeenXP      = GetPlayerBattlePassLastSeenXP( playerEHI, activeBattlePass )
	bool hasPremiumPass = DoesPlayerOwnBattlePass( GetLocalClientPlayer(), activeBattlePass )
	bool hadPremiumPass = GetPlayerBattlePassLastSeenPremium( playerEHI, activeBattlePass )

	if ( currentXP == lastSeenXP && hasPremiumPass == hadPremiumPass )
		return false

	if ( IsDialog( GetActiveMenu() ) )
		return false

	int lastLevel    = GetBattlePassLevelForXP( activeBattlePass, lastSeenXP ) + 1
	int currentLevel = GetBattlePassLevelForXP( activeBattlePass, currentXP )

	if ( currentXP == 0 && lastSeenXP == 0 )
		lastLevel = 0                                                                         

	array<BattlePassReward> allAwards
	array<BattlePassReward> freeAwards
	for ( int levelIdx = lastLevel; levelIdx <= currentLevel; levelIdx++ )
	{
		array<BattlePassReward> awardsForLevel = GetBattlePassLevelRewards( activeBattlePass, levelIdx )
		foreach ( award in awardsForLevel )
		{
			if ( award.isPremium )
				continue

			freeAwards.append( award )
		}
	}

	allAwards.extend( freeAwards )

	if ( hasPremiumPass )
	{
		array<BattlePassReward> premiumAwards

		for ( int levelIdx = lastLevel; levelIdx <= currentLevel; levelIdx++ )
		{
			array<BattlePassReward> awardsForLevel = GetBattlePassLevelRewards( activeBattlePass, levelIdx )
			foreach ( award in awardsForLevel )
			{
				if ( !award.isPremium )
					continue

				premiumAwards.append( award )
			}
		}

		allAwards.extend( premiumAwards )
	}

	if ( allAwards.len() == 0 )
		return false

	allAwards.sort( SortByAwardLevel )

	file.currentPage = -1                                       

	ShowRewardCeremonyDialog(
		"",
		Localize( "#BATTLE_PASS_REACHED_LEVEL", GetBattlePassDisplayLevel( currentLevel ) ),
		"",
		allAwards,
		true,
		false,
		false,
		playSound )

	return true
}


int function SortByAwardLevel( BattlePassReward a, BattlePassReward b )
{
	if ( a.level > b.level )
		return 1
	else if ( a.level < b.level )
		return -1

	if ( a.isPremium && !b.isPremium )
		return 1
	else if ( b.isPremium && !a.isPremium )
		return -1

	return 0
}

#endif


#if CLIENT
void function UIToClient_ItemPresentation( SettingsAssetGUID itemFlavorGUID, int level, float scale, bool showLow, var loadscreenPreviewBox, bool shouldPlayAudioPreview, string sceneRefName, bool isNXHH = false, bool isThemedEvent = false )
{
	ItemFlavor flav = GetItemFlavorByGUID( itemFlavorGUID )
	int itemType = ItemFlavor_GetType( flav )
	entity sceneRef = GetEntByScriptName( sceneRefName )

	fileLevel.sceneRefName = sceneRefName
	fileLevel.sceneRefOrigin = sceneRef.GetOrigin()

	bool showEmoteBase = true

	if ( sceneRefName == "battlepass_right_ref" )
	{
		if ( fabs( float( GetScreenSize().width ) / float( GetScreenSize().height ) - (16.0 / 10.0) ) < 0.07 )
			fileLevel.sceneRefOrigin += <0, 25, 0>

		if ( itemType == eItemType.character_emote )
			scale *= 0.7
	}
	else if ( sceneRefName == "battlepass_center_ref" )
	{
		                              
		                                                                                                                                          
		if ( itemType == eItemType.emote_icon )
			fileLevel.sceneRefOrigin += <5, 0, 14>
		else if ( itemType == eItemType.character_emote )
			scale *= 0.7
	}
	else if ( sceneRefName == "collection_event_ref" )
	{
		                                   
		                                                                                                                                          
		if ( itemType == eItemType.emote_icon )
			fileLevel.sceneRefOrigin += <0, 105, -33>                                                                                             
	}

	if ( showLow )
	{
		if ( sceneRefName == "battlepass_center_ref" )
			fileLevel.sceneRefOrigin += <0, 0, -10.5>
		else
			fileLevel.sceneRefOrigin += <0, 0, -2>
	}

	if ( sceneRefName == "battlepass_right_ref" || sceneRefName == "battlepass_center_ref" )
	{
		MoveLightsToSceneRef( sceneRef )
	}
	else if ( sceneRefName == "collection_event_ref" )
	{
		                                    
		if ( itemType == eItemType.character_skin )
		{
			fileLevel.sceneRefOrigin += <0, 0, -10>
		}
		else if ( itemType == eItemType.gladiator_card_stance || itemType == eItemType.gladiator_card_frame )
		{
			fileLevel.sceneRefOrigin += <0, 0, 1>
			scale *= 0.8
		}
		else if ( itemType == eItemType.character_emote )
		{
			fileLevel.sceneRefOrigin += <0, 0, 6>
			scale *= 0.58
			showEmoteBase = false
		}
	}

#if NX_PROG || PC_PROG_NX_UI
	if ( sceneRefName == "customize_character_emote_quip_ref" )
	{
		                                                  
		fileLevel.sceneRefOrigin += <10, 0, 0>
	}

	if ( sceneRefName == "customize_character_emotes_ref" )
	{
		if ( !isNXHH )
		{
			                                                    
			fileLevel.sceneRefOrigin += <0, 60, 20>
		}
	}
	
	if ( sceneRefName == "collection_event_ref" )
	{
		if ( isNXHH && itemType == eItemType.emote_icon )
		{
			fileLevel.sceneRefOrigin += <15, 0, 30>
		}
	}
#endif

	                                                                             
	                                                                                   
	if ( isThemedEvent )
	{
		fileLevel.sceneRefOrigin += <-21, 0, -7>
		if ( !showLow )
			fileLevel.sceneRefOrigin += <0, 0, 5>

		if ( itemType == eItemType.gladiator_card_stat_tracker )
			fileLevel.sceneRefOrigin += <0, 0, 8>
		else if ( itemType == eItemType.gladiator_card_stance)
			fileLevel.sceneRefOrigin += <-2, 0, 8>
		else if ( itemType == eItemType.gladiator_card_frame )
			fileLevel.sceneRefOrigin += <-2, 0, 10>
		else if ( itemType == eItemType.emote_icon )
			fileLevel.sceneRefOrigin += <-5, 90, 0>
		else if ( itemType == eItemType.weapon_skin )
			fileLevel.sceneRefOrigin += <5, 0, 5>
		else if ( itemType == eItemType.character_skin )
			fileLevel.sceneRefOrigin += CharacterClass_GetThematicPreviewOffset( CharacterSkin_GetCharacterFlavor( flav ) )

		                                      
#if NX_PROG || PC_PROG_NX_UI		
		                                       
		if ( isNXHH && itemType == eItemType.emote_icon )
		{
			fileLevel.sceneRefOrigin += <-15, 80, 0>
		}
#endif
		
	}

	fileLevel.sceneRefAngles = sceneRef.GetAngles()

	ShowBattlepassItem( flav, level, scale, loadscreenPreviewBox, shouldPlayAudioPreview, showLow, showEmoteBase )

	                                                                                
	                                                                        

	                                                                                       
}

void function MoveLightsToSceneRef( entity sceneRef )
{
	foreach ( light in fileLevel.stationaryLights )
	{
		light.SetOrigin( sceneRef.GetOrigin() + fileLevel.stationaryLightOffsets[ light ] )
		light.SetTweakLightOrigin( sceneRef.GetOrigin() + fileLevel.stationaryLightOffsets[ light ] )
	}
}

void function ShowBattlepassItem( ItemFlavor item, int level, float scale, var loadscreenPreviewBox, bool shouldPlayAudioPreview, bool showLow = false, bool showEmoteBase = true )
{
	fileLevel.loadscreenPreviewBox = loadscreenPreviewBox                                                                       

	ClearBattlePassItem()

	fileLevel.loadscreenPreviewBox = loadscreenPreviewBox

	int itemType = ItemFlavor_GetType( item )

	switch ( itemType )
	{
		case eItemType.account_currency:
		case eItemType.account_currency_bundle:
			ShowBattlePassItem_Currency( item, scale )
			break

		case eItemType.account_pack:
			ShowBattlePassItem_ApexPack( item, scale )
			break

		case eItemType.character_skin:
			ShowBattlePassItem_CharacterSkin( item, scale )
			break

		case eItemType.character_execution:
			ShowBattlePassItem_Execution( item, scale )
			break

		case eItemType.weapon_skin:
			asset video = WeaponSkin_GetVideo( item )
			if ( video != $"" )
				ShowBattlePassItem_WeaponSkinVideo( item, scale, video )
			else
				ShowBattlePassItem_WeaponSkin( item, scale )
			break

		case eItemType.weapon_charm:
			ShowBattlePassItem_WeaponCharm( item, scale )
			break

		case eItemType.melee_skin:
			ShowBattlePassItem_MeleeSkin( item, scale )
			break

		case eItemType.gladiator_card_stance:
		case eItemType.gladiator_card_frame:
			ShowBattlePassItem_Banner( item, scale )
			break

		case eItemType.gladiator_card_intro_quip:
		case eItemType.gladiator_card_kill_quip:
			ShowBattlePassItem_Quip( item, scale, shouldPlayAudioPreview )
			break

		case eItemType.gladiator_card_stat_tracker:
			ShowBattlePassItem_StatTracker( item, scale )
			break

		case eItemType.voucher:
			ShowBattlePassItem_Voucher( item, scale )
			break

		case eItemType.gladiator_card_badge:
			ShowBattlePassItem_Badge( item, scale, level )
			break

		case eItemType.music_pack:
			ShowBattlePassItem_MusicPack( item, scale, shouldPlayAudioPreview )
			break

		case eItemType.loadscreen:
			ShowBattlePassItem_Loadscreen( item, scale )
			break

		case eItemType.skydive_emote:
			ShowBattlePassItem_SkydiveEmote( item, scale )
			break

		case eItemType.emote_icon:
			ShowBattlePassItem_EmoteIcon( item, scale, showLow )
			break

		case eItemType.character_emote:
			ShowBattlePassItem_Emote( item, scale, showEmoteBase )
			break

		case eItemType.quest_mission:
			ShowBattlePassItem_QuestMission( item, scale )
			break

                       
		case eItemType.quest_comic:
			ShowBattlePassItem_QuestComicPage( item, scale )
			break
      

		case eItemType.battlepass_purchased_xp:
			thread ShowBattlePassItem_Level( item, scale )
			break

		case eItemType.character:
			thread ShowBattlePassItem_Character( item, scale )
			break

                
                         
                                     
        
                      

		default:
			Warning( "Battle Pass reward item type not supported: " + DEV_GetEnumStringSafe( "eItemType", itemType ) )
			ShowBattlePassItem_Unknown( item, scale )
			break
	}
}
#endif          

#if CLIENT
void function ClearBattlePassItem()
{
	foreach ( model in fileLevel.models )
	{
		if ( IsValid( model ) )
		{
			foreach ( entity ent in GetEntityAndAllChildren( model ) )
			{
				if ( IsValid( ent ) )
					ent.Destroy()
			}
		}
	}
	fileLevel.models.clear()

	foreach ( fx in fileLevel.fxs )
	{
		if ( EffectDoesExist( fx ) )
		{
			EffectStop( fx, true, true )
		}
	}
	fileLevel.fxs.clear()

	if ( IsValid( fileLevel.mover ) )
		fileLevel.mover.Destroy()

	CleanupNestedGladiatorCard( fileLevel.bannerHandle )

	if ( fileLevel.rui != null )
		RuiDestroyIfAlive( fileLevel.rui )

	if ( fileLevel.topo != null )
	{
		RuiTopology_Destroy( fileLevel.topo )
		fileLevel.topo = null
	}

	if ( fileLevel.videoChannel != -1 )
	{
		ReleaseVideoChannel( fileLevel.videoChannel )
		fileLevel.videoChannel = -1
	}

	if ( fileLevel.playingPreviewAlias != "" )
		StopSoundOnEntity( GetLocalClientPlayer(), fileLevel.playingPreviewAlias )

	if ( IsValid( fileLevel.loadscreenPreviewBox ) )
	{
		UpdateLoadscreenPreviewMaterial( fileLevel.loadscreenPreviewBox, null, 0 )
		fileLevel.loadscreenPreviewBox = null
	}
}

void function ShowBattlePassItem_ApexPack( ItemFlavor item, float scale )
{
	vector origin = fileLevel.sceneRefOrigin + <0, 0, 10.0>
	vector angles = fileLevel.sceneRefAngles

	entity mover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", origin, angles )
	mover.MakeSafeForUIScriptHack()

	asset tickAsset = GRXPack_GetTickModel( item )
	string tickSkin = GRXPack_GetTickModelSkin( item )
	entity model    = CreateClientSidePropDynamic( origin, AnglesCompose( angles, <0, 135, 0> ), tickAsset )
	model.MakeSafeForUIScriptHack()
	model.SetModelScale( scale * 0.60 )
	model.SetParent( mover )
	model.SetSkin( model.GetSkinIndexByName( tickSkin ) )

	mover.NonPhysicsRotate( <0, 0, -1>, fileLevel.rotateSpeed )

	vector flashColor = ItemFlavor_GetQualityColor( item ) / 255
	thread FlashMenuModel( model, eMenuModelFlashType.BATTLEPASS, flashColor )

	fileLevel.mover = mover
	fileLevel.models.append( model )
}


void function ShowBattlePassItem_CharacterSkin( ItemFlavor item, float scale )
{
	ItemFlavor char = CharacterSkin_GetCharacterFlavor( item )
	vector origin   = fileLevel.sceneRefOrigin + <0, 0, 4.0> - 0.6 * CharacterClass_GetMenuZoomOffset( char )
	vector angles   = fileLevel.sceneRefAngles

	entity mover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", origin, angles )
	mover.MakeSafeForUIScriptHack()

	entity model = CreateClientSidePropDynamic( origin, angles, $"mdl/dev/empty_model.rmdl" )


	                                            
	if ( fileLevel.sceneRefName == "battlepass_center_ref" )
		model.SetLightingOrigin( <11328, 2612, 28> )                         


	CharacterSkin_Apply( model, item )
	model.MakeSafeForUIScriptHack()
	model.SetModelScale( scale * 0.75 )
	model.SetParent( mover )
	                                                                     
	thread MoverPendulum( mover )

	thread PlayAnim( model, "ACT_MP_MENU_LOOT_CEREMONY_IDLE", mover )

	vector flashColor = ItemFlavor_GetQualityColor( item ) / 255
	thread FlashMenuModel( model, eMenuModelFlashType.BATTLEPASS, flashColor )

	fileLevel.mover = mover
	fileLevel.models.append( model )
}

void function MoverPendulum( entity mover )
{
	vector baseAngles = mover.GetAngles()
	bool firstTime    = false
	float dir         = 1
	float delta       = 30.0
	const float MOVE_TIME = 10.0

	while ( IsValid( mover ) )
	{
		float scalar   = firstTime ? 0.5 : 1.0
		float moveTime = MOVE_TIME * scalar
		mover.NonPhysicsRotateTo( baseAngles - (dir * <0, delta, 0>), moveTime, 0.5 * scalar, 0.5 * scalar )
		firstTime = false
		dir *= -1
		wait moveTime
	}
}

void function ShowBattlePassItem_Execution( ItemFlavor item, float scale )
{
	const float BATTLEPASS_EXECUTION_Z_OFFSET = 12.0
	const vector BATTLEPASS_EXECUTION_LOCAL_ANGLES = <0, 15, 0>
	const float BATTLEPASS_EXECUTION_SCALE = 0.8

	                     
	ItemFlavor attackerCharacter = CharacterExecution_GetCharacterFlavor( item )
	ItemFlavor characterSkin     = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_CharacterSkin( attackerCharacter ) )

	asset attackerAnimSeq = CharacterExecution_GetAttackerPreviewAnimSeq( item )
	asset victimAnimSeq   = CharacterExecution_GetVictimPreviewAnimSeq( item )

	               
	vector origin = fileLevel.sceneRefOrigin + <0, 0, BATTLEPASS_EXECUTION_Z_OFFSET>
	vector angles = AnglesCompose( fileLevel.sceneRefAngles, BATTLEPASS_EXECUTION_LOCAL_ANGLES )

	entity mover         = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", origin, angles )
	entity attackerModel = CreateClientSidePropDynamic( origin, angles, $"mdl/dev/empty_model.rmdl" )
	entity victimModel   = CreateClientSidePropDynamic( origin, angles, $"mdl/dev/empty_model.rmdl" )

	CharacterSkin_Apply( attackerModel, characterSkin )
	victimModel.SetModel( $"mdl/humans/class/medium/dummy_v20_base_w.rmdl" )

	          
	bool attackerHasSequence = attackerModel.Anim_HasSequence( attackerAnimSeq )
	bool victimHasSequence   = victimModel.Anim_HasSequence( victimAnimSeq )

	if ( !attackerHasSequence || !victimHasSequence )
	{
		asset attackerPlayerSettings = CharacterClass_GetSetFile( attackerCharacter )
		string attackerRigWeight     = GetGlobalSettingsString( attackerPlayerSettings, "bodyModelRigWeight" )
		string attackerAnim          = "mp_pt_execution_" + attackerRigWeight + "_attacker_loot"

		attackerModel.Anim_Play( attackerAnim )
		victimModel.Anim_Play( "mp_pt_execution_default_victim_loot" )
		Warning( "Couldn't find menu idles for execution reward: " + DEV_DescItemFlavor( item ) + ". Using fallback anims." )
		if ( !attackerHasSequence )
			Warning( "ATTACKER could not find sequence: " + attackerAnimSeq )
		if ( !victimHasSequence )
			Warning( "VICTIM could not find sequence: " + victimAnimSeq )
	}
	else
	{
		attackerModel.Anim_Play( attackerAnimSeq )
		victimModel.Anim_Play( victimAnimSeq )
	}

	mover.MakeSafeForUIScriptHack()

	attackerModel.MakeSafeForUIScriptHack()
	attackerModel.SetParent( mover )

	victimModel.MakeSafeForUIScriptHack()
	victimModel.SetParent( mover )

	       
	attackerModel.SetModelScale( scale * BATTLEPASS_EXECUTION_SCALE )
	victimModel.SetModelScale( scale * BATTLEPASS_EXECUTION_SCALE )

	vector flashColor = ItemFlavor_GetQualityColor( item ) / 255
	thread FlashMenuModel( attackerModel, eMenuModelFlashType.BATTLEPASS, flashColor )
	thread FlashMenuModel( victimModel, eMenuModelFlashType.BATTLEPASS, flashColor )

	fileLevel.mover = mover
	fileLevel.models.append( attackerModel )
	fileLevel.models.append( victimModel )
}


void function ShowBattlePassItem_WeaponSkin( ItemFlavor item, float scale )
{
	const vector BATTLEPASS_WEAPON_SKIN_LOCAL_ANGLES = <5, -45, 0>

	vector origin = fileLevel.sceneRefOrigin + <0, 0, 29.0>
	vector angles = fileLevel.sceneRefAngles

	                
	ItemFlavor weaponFlavor = WeaponSkin_GetWeaponFlavor( item )

	entity mover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", origin, angles )
	mover.MakeSafeForUIScriptHack()

	float weaponItemScale = WeaponItemFlavor_GetBattlePassScale( weaponFlavor )
	entity weaponModel    = CreateClientSidePropDynamic( origin, AnglesCompose( angles, BATTLEPASS_WEAPON_SKIN_LOCAL_ANGLES ), $"mdl/dev/empty_model.rmdl" )
	WeaponCosmetics_Apply( weaponModel, item, null )

	bool isReactive = WeaponSkin_DoesReactToKills( item )
	if ( isReactive )
		MenuWeaponModel_ApplyReactiveSkinBodyGroup( item, weaponFlavor, weaponModel )
	else
		ShowDefaultBodygroupsOnFakeWeapon( weaponModel, WeaponItemFlavor_GetClassname( weaponFlavor ) )

	MenuWeaponModel_ClearReactiveEffects( weaponModel )
	if ( isReactive )
		MenuWeaponModel_StartReactiveEffects( weaponModel, item )

	weaponModel.MakeSafeForUIScriptHack()
	weaponModel.SetVisibleForLocalPlayer( 0 )
	weaponModel.Anim_SetPaused( true )
	weaponModel.SetModelScale( scale * weaponItemScale * 0.75 )
	weaponModel.SetParent( mover )

	         
	weaponModel.SetLocalOrigin( GetAttachmentOriginOffset( weaponModel, "MENU_ROTATE", BATTLEPASS_WEAPON_SKIN_LOCAL_ANGLES ) )
	weaponModel.SetLocalAngles( BATTLEPASS_WEAPON_SKIN_LOCAL_ANGLES )

	mover.NonPhysicsRotate( <0, 0, -1>, fileLevel.rotateSpeed )

	vector flashColor = ItemFlavor_GetQualityColor( item ) / 255
	thread FlashMenuModel( weaponModel, eMenuModelFlashType.BATTLEPASS, flashColor )

	fileLevel.mover = mover
	fileLevel.models.append( weaponModel )
}


void function ShowBattlePassItem_WeaponCharm( ItemFlavor item, float scale )
{
	vector origin = fileLevel.sceneRefOrigin + <0, 0, 42>
	vector angles = fileLevel.sceneRefAngles

	entity mover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", origin, angles )
	mover.MakeSafeForUIScriptHack()

	entity model = CreateClientSidePropDynamicCharm( origin, AnglesCompose( angles, <0, 270, 0> ), WeaponCharm_GetCharmModel( item ) )
	model.MakeSafeForUIScriptHack()
	model.SetModelScale( scale * 18 )
	model.SetParent( mover )
	thread MoverPendulum( mover )

	vector flashColor = ItemFlavor_GetQualityColor( item ) / 255
	thread FlashMenuModel( model, eMenuModelFlashType.BATTLEPASS, flashColor )

	fileLevel.mover = mover
	fileLevel.models.append( model )
}


void function ShowBattlePassItem_MeleeSkin( ItemFlavor item, float scale )
{
	vector origin = fileLevel.sceneRefOrigin + <0, 0, 29.0>
	vector angles = fileLevel.sceneRefAngles

	entity mover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", origin, angles )
	mover.MakeSafeForUIScriptHack()

	vector extraRotation = MeleeSkin_GetMenuModelRotation( item )
	entity model         = CreateClientSidePropDynamic( origin, AnglesCompose( angles, extraRotation ), MeleeSkin_GetMenuModel( item ) )
	model.MakeSafeForUIScriptHack()
	model.SetVisibleForLocalPlayer( 0 )

	asset animSeq = MeleeSkin_GetMenuAnimSeq( item )
	if ( animSeq != $"" )
		model.Anim_Play( animSeq )

	model.SetModelScale( scale * WeaponItemFlavor_GetBattlePassScale( item ) )
	model.SetParent( mover )

	model.SetLocalOrigin( GetAttachmentOriginOffset( model, "MENU_ROTATE", extraRotation ) )
	model.SetLocalAngles( extraRotation )

	mover.NonPhysicsRotate( <0, 0, -1>, fileLevel.rotateSpeed )

	vector flashColor = ItemFlavor_GetQualityColor( item ) / 255
	thread FlashMenuModel( model, eMenuModelFlashType.BATTLEPASS, flashColor )

	fileLevel.mover = mover
	fileLevel.models.append( model )
}


void function ShowBattlePassItem_Banner( ItemFlavor item, float scale )
{
	int itemType = ItemFlavor_GetType( item )
	Assert( itemType == eItemType.gladiator_card_frame || itemType == eItemType.gladiator_card_stance )

	const float BATTLEPASS_BANNER_WIDTH = 528.0
	const float BATTLEPASS_BANNER_HEIGHT = 912.0
	const float BATTLEPASS_BANNER_SCALE = 0.08
	const float BATTLEPASS_BANNER_Z_OFFSET = -4.0

	entity player = GetLocalClientPlayer()
	vector origin = fileLevel.sceneRefOrigin + <0, 0, BATTLEPASS_BANNER_Z_OFFSET>
	vector angles = AnglesCompose( fileLevel.sceneRefAngles, <0, 180, 0> )

	float width  = scale * BATTLEPASS_BANNER_WIDTH * BATTLEPASS_BANNER_SCALE
	float height = scale * BATTLEPASS_BANNER_HEIGHT * BATTLEPASS_BANNER_SCALE

	var topo = CreateRUITopology_Worldspace( origin + <0, 0, height * 0.5>, angles, width, height )
	var rui  = RuiCreate( $"ui/loot_ceremony_glad_card.rpak", topo, RUI_DRAW_VIEW_MODEL, 0 )

	int gcardPresentation
	if ( itemType == eItemType.gladiator_card_frame )
		gcardPresentation = eGladCardPresentation.FRONT_CLEAN
	else
		gcardPresentation = eGladCardPresentation.FRONT_STANCE_ONLY

	NestedGladiatorCardHandle nestedGCHandleFront = CreateNestedGladiatorCard( rui, "card", eGladCardDisplaySituation.MENU_LOOT_CEREMONY_ANIMATED, gcardPresentation )
	ChangeNestedGladiatorCardOwner( nestedGCHandleFront, ToEHI( player ) )

	if ( itemType == eItemType.gladiator_card_frame )
	{
		ItemFlavor ornull character = GladiatorCardFrame_GetCharacterFlavor( item )
		if ( character == null )
			character = GetRandomGoodItemFlavorForLoadoutSlot( ToEHI( player ), Loadout_Character() )

		expect ItemFlavor( character )
		SetNestedGladiatorCardOverrideCharacter( nestedGCHandleFront, character )
		SetNestedGladiatorCardOverrideFrame( nestedGCHandleFront, item )
	}
	else
	{
		ItemFlavor character = GladiatorCardStance_GetCharacterFlavor( item )
		SetNestedGladiatorCardOverrideCharacter( nestedGCHandleFront, character )
		SetNestedGladiatorCardOverrideStance( nestedGCHandleFront, item )

		ItemFlavor characterDefaultFrame = GetDefaultItemFlavorForLoadoutSlot( EHI_null, Loadout_GladiatorCardFrame( character ) )
		SetNestedGladiatorCardOverrideFrame( nestedGCHandleFront, characterDefaultFrame )                          
	}

	RuiSetBool( rui, "battlepass", true )
	RuiSetInt( rui, "rarity", ItemFlavor_GetQuality( item ) )

	fileLevel.topo = topo
	fileLevel.rui = rui
	fileLevel.bannerHandle = nestedGCHandleFront
}

void function ShowBattlePassItem_EmoteIcon( ItemFlavor item, float scale, bool showLow )
{
	asset EMOTE_ICON_BASE_MODEL = HOLO_SPRAY_BASE                                                                                          

	vector angles = fileLevel.sceneRefAngles

	#if NX_PROG || PC_PROG_NX_UI
		vector origin = fileLevel.sceneRefOrigin - (AnglesToForward( angles ) * ( (1.0 - scale) ) ) + (AnglesToRight( angles ) * ((1.0 - scale)) * -28) + <0, 0, -25>
	#else
		vector origin = fileLevel.sceneRefOrigin - (AnglesToForward( angles ) * ( (1.0 - scale) * 100) ) + (AnglesToRight( angles ) * ((1.0 - scale) * -12))

		if ( showLow )
			origin -= <0,0,32>
	#endif

	entity model = CreateClientSidePropDynamic( origin, angles, EMOTE_ICON_BASE_MODEL )
	model.MakeSafeForUIScriptHack()
	model.SetModelScale( scale )
	model.SetDoDestroyCallback( true )

	thread CreateClientSideEmoteIcon( model, ItemFlavor_GetGUID( item ), Time(), true )

	vector fwd = AnglesToForward( angles )
	vector backerOrg = origin + <0,0,64>

	entity backer = CreateClientsideScriptMover( $"mdl/levels_terrain/mp_lobby/holospray_backdrop_godray_01.rmdl", backerOrg - (fwd*5), angles + <180,0,0> )
	backer.MakeSafeForUIScriptHack()
	backer.SetModelScale( 4.0 )
	backer.SetParent( model )

	fileLevel.models.append( model )
}


void function ShowBattlePassItem_Emote( ItemFlavor item, float scale, bool showBase = true )
{
	ItemFlavor ornull char = CharacterQuip_GetCharacterFlavor( item )

	if ( char == null )
		char = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_Character() )

	expect ItemFlavor( char )

	ItemFlavor skin = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_CharacterSkin( char ) )

	vector angles = fileLevel.sceneRefAngles
	vector origin = fileLevel.sceneRefOrigin - CharacterClass_GetMenuZoomOffset( char )

	entity mover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", origin, angles )
	mover.MakeSafeForUIScriptHack()

	entity model = CreateClientSidePropDynamic( origin, angles, $"mdl/dev/empty_model.rmdl" )
	CharacterSkin_Apply( model, skin )
	model.MakeSafeForUIScriptHack()
	model.SetModelScale( scale )
	model.SetParent( mover )

	int fx
	if(showBase)
	{
		fx = StartParticleEffectInWorldWithHandle( GetParticleSystemIndex( CHARACTER_BASE_EFFECT ), mover.GetOrigin() + <0, 0, -1.2>, <-2.2, 0, 0> )
		EffectSetControlPointVector( fx, 1, ItemFlavor_GetQualityColor( item ) )
	}

	thread ModelPerformEmote( model, item, mover, false )

	fileLevel.mover = mover
	fileLevel.models.append( model )
	if(showBase)
		fileLevel.fxs.append( fx )
}


void function ShowBattlePassItem_Quip( ItemFlavor item, float scale, bool shouldPlayAudioPreview )
{
	int itemType = ItemFlavor_GetType( item )
	Assert( itemType == eItemType.gladiator_card_intro_quip || itemType == eItemType.gladiator_card_kill_quip )

	const float BATTLEPASS_QUIP_WIDTH = 390.0
	const float BATTLEPASS_QUIP_HEIGHT = 208.0
	const float BATTLEPASS_QUIP_SCALE_NX = 0.11
	const float BATTLEPASS_QUIP_SCALE = 0.091
	const float BATTLEPASS_QUIP_Z_OFFSET = 20.5
	const asset BATTLEPASS_QUIP_BG_MODEL = $"mdl/menu/loot_ceremony_quip_bg.rmdl"

	vector origin = fileLevel.sceneRefOrigin + <0, 0, BATTLEPASS_QUIP_Z_OFFSET>

	vector angles        = fileLevel.sceneRefAngles
	vector placardAngles = VectorToAngles( AnglesToForward( angles ) * -1 )

	                                        
	#if NX_PROG || PC_PROG_NX_UI
		float width  = scale * BATTLEPASS_QUIP_WIDTH * BATTLEPASS_QUIP_SCALE_NX
		float height = scale * BATTLEPASS_QUIP_HEIGHT * BATTLEPASS_QUIP_SCALE_NX
	#else
		float width  = scale * BATTLEPASS_QUIP_WIDTH * BATTLEPASS_QUIP_SCALE
		float height = scale * BATTLEPASS_QUIP_HEIGHT * BATTLEPASS_QUIP_SCALE
	#endif

	entity model = CreateClientSidePropDynamic( origin, angles, BATTLEPASS_QUIP_BG_MODEL )
	model.MakeSafeForUIScriptHack()
 
	#if NX_PROG || PC_PROG_NX_UI
		model.SetModelScale( scale * BATTLEPASS_QUIP_SCALE_NX )
	#else
		model.SetModelScale( scale * BATTLEPASS_QUIP_SCALE )
	#endif

	var topo         = CreateRUITopology_Worldspace( origin + <0, 0, (height * 0.5)>, placardAngles, width, height )
	var rui
	ItemFlavor quipCharacter
	string labelText
	string quipAlias = ""

	if ( itemType == eItemType.gladiator_card_intro_quip )
	{
		        
		rui = RuiCreate( $"ui/loot_reward_intro_quip.rpak", topo, RUI_DRAW_WORLD, 0 )
		quipCharacter = CharacterIntroQuip_GetCharacterFlavor( item )
		labelText = "#LOOT_QUIP_INTRO"
		quipAlias = CharacterIntroQuip_GetVoiceSoundEvent( item )
	}
	else
	{
		       
		rui = RuiCreate( $"ui/loot_reward_kill_quip.rpak", topo, RUI_DRAW_WORLD, 0 )
		quipCharacter = CharacterKillQuip_GetCharacterFlavor( item )
		labelText = "#LOOT_QUIP_KILL"
		quipAlias = CharacterKillQuip_GetVictimVoiceSoundEvent( item )
	}

	RuiSetBool( rui, "isVisible", true )
	RuiSetBool( rui, "battlepass", true )
	RuiSetInt( rui, "rarity", ItemFlavor_GetQuality( item ) )
	RuiSetImage( rui, "portraitImage", CharacterClass_GetGalleryPortrait( quipCharacter ) )
	RuiSetString( rui, "quipTypeText", labelText )
	RuiTrackFloat( rui, "level", null, RUI_TRACK_SOUND_METER, 0 )

	fileLevel.models.append( model )
	fileLevel.topo = topo
	fileLevel.rui = rui

	                     
	if ( quipAlias != "" && shouldPlayAudioPreview )
	{
		fileLevel.playingPreviewAlias = quipAlias
		EmitSoundOnEntity( GetLocalClientPlayer(), quipAlias )
	}
}


void function ShowBattlePassItem_StatTracker( ItemFlavor item, float scale )
{
	const float BATTLEPASS_STAT_TRACKER_WIDTH = 594.0
	const float BATTLEPASS_STAT_TRACKER_HEIGHT = 230.0
	const float BATTLEPASS_STAT_TRACKER_SCALE = 0.06
	const asset BATTLEPASS_STAT_TRACKER_BG_MODEL = $"mdl/menu/loot_ceremony_stat_tracker_bg.rmdl"

	vector origin        = fileLevel.sceneRefOrigin + <0, 0, 23>
	vector angles        = fileLevel.sceneRefAngles
	vector placardAngles = VectorToAngles( AnglesToForward( angles ) * -1 )

	                                        
	float width = BATTLEPASS_STAT_TRACKER_WIDTH
	width *= scale
	width *= BATTLEPASS_STAT_TRACKER_SCALE
	float height = BATTLEPASS_STAT_TRACKER_HEIGHT
	height *= scale
	height *= BATTLEPASS_STAT_TRACKER_SCALE

	var topo = CreateRUITopology_Worldspace( origin + <0, 0, (height * 0.5)>, placardAngles, width, height )
	var rui  = RuiCreate( $"ui/loot_ceremony_stat_tracker.rpak", topo, RUI_DRAW_WORLD, 0 )

	entity model = CreateClientSidePropDynamic( origin, angles, BATTLEPASS_STAT_TRACKER_BG_MODEL )
	model.MakeSafeForUIScriptHack()
	model.SetModelScale( scale * BATTLEPASS_STAT_TRACKER_SCALE )

	ItemFlavor ornull character = GladiatorCardStatTracker_GetCharacterFlavor( item )
	if ( character == null )                                  
		character = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_Character() )

	RuiSetBool( rui, "isVisible", true )
	RuiSetBool( rui, "battlepass", true )
	UpdateRuiWithStatTrackerData( rui, "tracker", LocalClientEHI(), character, -1, item, null, true )
	RuiSetColorAlpha( rui, "trackerColor0", GladiatorCardStatTracker_GetColor0( item ), 1.0 )
	RuiSetInt( rui, "rarity", ItemFlavor_GetQuality( item ) )

	fileLevel.models.append( model )
	fileLevel.topo = topo
	fileLevel.rui = rui
}


void function ShowBattlePassItem_Badge( ItemFlavor item, float scale, int level )
{
	const float BATTLEPASS_BADGE_WIDTH = 670.0
	const float BATTLEPASS_BADGE_HEIGHT = 670.0
	const float BATTLEPASS_BADGE_SCALE = 0.06

	vector origin        = fileLevel.sceneRefOrigin + <0, 0, 30>
	vector angles        = fileLevel.sceneRefAngles
	vector placardAngles = VectorToAngles( AnglesToForward( angles ) * -1 )

	float width  = scale * BATTLEPASS_BADGE_WIDTH * BATTLEPASS_BADGE_SCALE
	float height = scale * BATTLEPASS_BADGE_HEIGHT * BATTLEPASS_BADGE_SCALE

	var topo = CreateRUITopology_Worldspace( origin, placardAngles, width, height )
	var rui  = RuiCreate( $"ui/world_space_badge.rpak", topo, RUI_DRAW_VIEW_MODEL, 0 )
	ItemFlavor dummy
	CreateNestedGladiatorCardBadge( rui, "badge", LocalClientEHI(), item, 0, dummy, level == -1 ? 0 : level + 2 )
	RuiSetBool( rui, "isVisible", true )
	RuiSetBool( rui, "battlepass", true )

	fileLevel.topo = topo
	fileLevel.rui = rui
}


void function ShowBattlePassItem_Currency( ItemFlavor item, float scale )
{
	int itemType = ItemFlavor_GetType( item )
	Assert( itemType == eItemType.account_currency || itemType == eItemType.account_currency_bundle )

	asset modelAsset = $"mdl/dev/empty_model.rmdl"
	float modelScale = 1.0
	int rarity       = 0
	if ( ItemFlavor_HasQuality( item ) )
		rarity = ItemFlavor_GetQuality( item )

	if ( ItemFlavor_GetType( item ) == eItemType.account_currency )
	{
		if ( item == GRX_CURRENCIES[GRX_CURRENCY_CRAFTING] )
		{
			modelAsset = BATTLEPASS_MODEL_CRAFTING_METALS
			modelScale = 1.5
		}
		else
		{
			modelAsset = GRXCurrency_GetPreviewModel( item )
		}
	}
	else
	{
		asset itemAsset = ItemFlavor_GetAsset( item )
		Assert( itemAsset == $"settings/itemflav/currency_bundle/crafting_common.rpak" ||
		itemAsset == $"settings/itemflav/currency_bundle/crafting_rare.rpak" ||
		itemAsset == $"settings/itemflav/currency_bundle/crafting_epic.rpak" ||
		itemAsset == $"settings/itemflav/currency_bundle/crafting_legendary.rpak" ||
		itemAsset == $"settings/itemflav/currency_bundle/heirloom.rpak" )

		switch ( rarity )
		{
			case 0:
				modelAsset = CURRENCY_MODEL_COMMON
				break

			case 1:
				modelAsset = CURRENCY_MODEL_RARE
				break

			case 2:
				modelAsset = CURRENCY_MODEL_EPIC
				break

			case 3:
				modelAsset = CURRENCY_MODEL_LEGENDARY
				break

			case 4:
				ItemFlavor currencyFlav = GRXCurrencyBundle_GetCurrencyFlav( item )
				modelAsset = GRXCurrency_GetPreviewModel( currencyFlav )
				break

			default: Assert( false )
		}

		modelScale = 1.5
	}

	vector origin = fileLevel.sceneRefOrigin + <0, 0, 29>
	vector angles = fileLevel.sceneRefAngles

	entity mover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", origin, angles )
	mover.MakeSafeForUIScriptHack()

	entity model = CreateClientSidePropDynamic( origin, AnglesCompose( angles, <0, 32, 0> ), modelAsset )
	model.MakeSafeForUIScriptHack()
	model.SetModelScale( scale * modelScale )
	model.SetParent( mover )

	mover.NonPhysicsRotate( <0, 0, -1>, fileLevel.rotateSpeed )

	vector flashColor = ItemFlavor_GetQualityColor( item ) / 255
	thread FlashMenuModel( model, eMenuModelFlashType.BATTLEPASS, flashColor )

	fileLevel.mover = mover
	fileLevel.models.append( model )
}

void function ShowBattlePassItem_XPBoost( ItemFlavor item, float scale )
{
	vector origin = fileLevel.sceneRefOrigin + <0, 0, 28.0>
	vector angles = fileLevel.sceneRefAngles

	entity mover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", origin, angles )
	mover.MakeSafeForUIScriptHack()

	entity model = CreateClientSidePropDynamic( origin, AnglesCompose( angles, <0, 32, 0> ), Voucher_GetModel( item ) )
	model.MakeSafeForUIScriptHack()
	model.SetParent( mover )
	model.SetModelScale( scale * 0.85 )

	mover.NonPhysicsRotate( <0, 0, -1>, fileLevel.rotateSpeed )

	vector flashColor = ItemFlavor_GetQualityColor( item ) / 255
	thread FlashMenuModel( model, eMenuModelFlashType.BATTLEPASS, flashColor )

	fileLevel.mover = mover
	fileLevel.models.append( model )
}

void function ShowBattlePassItem_QuestClue( ItemFlavor item, float scale )
{
	vector origin = fileLevel.sceneRefOrigin + <0, -260, 28.0>
	vector angles = fileLevel.sceneRefAngles

	entity mover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", origin, angles )
	mover.MakeSafeForUIScriptHack()

	entity model = CreateClientSidePropDynamic( origin, AnglesCompose( angles, <20, 32, 0> ), $"mdl/weapons_r5/misc_pve/s5_treasure_box/w_s5_treasure_box.rmdl" )
	model.MakeSafeForUIScriptHack()
	model.SetParent( mover )
	model.SetModelScale( scale * 0.85 )

	mover.NonPhysicsRotate( <0, 0, -1>, fileLevel.rotateSpeed )

	vector flashColor = ItemFlavor_GetQualityColor( item ) / 255
	thread FlashMenuModel( model, eMenuModelFlashType.BATTLEPASS, flashColor )

	fileLevel.mover = mover
	fileLevel.models.append( model )
}

void function ShowBattlePassItem_CPReward( ItemFlavor item, float scale )
{
	vector origin = fileLevel.sceneRefOrigin + <0, 0, 28.0>
	vector angles = fileLevel.sceneRefAngles

	entity mover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", origin, angles )
	mover.MakeSafeForUIScriptHack()

	entity model = CreateClientSidePropDynamic( origin, AnglesCompose( angles, <90, 32, 0> ), CHALLENGE_REWARD_MODEL )
	model.MakeSafeForUIScriptHack()
	model.SetParent( mover )
	model.SetModelScale( scale * 0.35 )

	mover.NonPhysicsRotate( <0, 0, -1>, fileLevel.rotateSpeed )

	if ( ItemFlavor_HasQuality( item ) )
	{
		vector flashColor = ItemFlavor_GetQualityColor( item ) / 255
		thread FlashMenuModel( model, eMenuModelFlashType.BATTLEPASS, flashColor )
	}

	fileLevel.mover = mover
	fileLevel.models.append( model )
}

void function ShowBattlePassItem_StarReward( ItemFlavor item, float scale )
{
	vector origin = fileLevel.sceneRefOrigin + <0, 0, 28.0>
	vector angles = fileLevel.sceneRefAngles

	entity mover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", origin, angles )
	mover.MakeSafeForUIScriptHack()

	entity model = CreateClientSidePropDynamic( origin, AnglesCompose( angles, <90, 32, 0> ), BATTLEPASS_STAR_REWARD_MODEL )
	model.MakeSafeForUIScriptHack()
	model.SetParent( mover )
	model.SetModelScale( scale * 0.35 )

	mover.NonPhysicsRotate( <0, 0, -1>, fileLevel.rotateSpeed )

	if ( ItemFlavor_HasQuality( item ) )
	{
		vector flashColor = ItemFlavor_GetQualityColor( item ) / 255
		thread FlashMenuModel( model, eMenuModelFlashType.BATTLEPASS, flashColor )
	}

	fileLevel.mover = mover
	fileLevel.models.append( model )
}

void function ShowBattlePassItem_Voucher( ItemFlavor item, float scale )
{
	if ( Voucher_GetEffectBattlepassStars( item ) )
		ShowBattlePassItem_StarReward( item, scale )
	else
		ShowBattlePassItem_XPBoost( item, scale )
}

const float BATTLEPASS_VIDEO_WIDTH = 600.0
const float BATTLEPASS_VIDEO_HEIGHT = 338.0

void function ShowBattlePassItem_WeaponSkinVideo( ItemFlavor item, float scale, asset video )
{
	const float BATTLEPASS_UNKNOWN_Z_OFFSET = 28

	                      
	vector origin = fileLevel.sceneRefOrigin + <0, 0, BATTLEPASS_UNKNOWN_Z_OFFSET>
	vector angles = VectorToAngles( AnglesToForward( fileLevel.sceneRefAngles ) * -1 )

	float width  = scale * BATTLEPASS_VIDEO_WIDTH / 14.0
	float height = scale * BATTLEPASS_VIDEO_HEIGHT / 14.0

	var topo = CreateRUITopology_Worldspace( origin, angles, width, height )
	var rui  = RuiCreate( $"ui/finisher_video.rpak", topo, RUI_DRAW_VIEW_MODEL, 0 )

	fileLevel.videoChannel = ReserveVideoChannel( BattlePassVideoOnFinished )
	RuiSetInt( rui, "channel", fileLevel.videoChannel )
	StartVideoOnChannel( fileLevel.videoChannel, video, true, 0.0 )

	fileLevel.topo = topo
	fileLevel.rui = rui
}


void function ShowBattlePassItem_MusicPack( ItemFlavor item, float scale, bool shouldPlayAudioPreview )
{
	int itemType = ItemFlavor_GetType( item )
	Assert( itemType == eItemType.music_pack )

	const float BATTLEPASS_QUIP_WIDTH = 390.0
	const float BATTLEPASS_QUIP_HEIGHT = 208.0
	const float BATTLEPASS_QUIP_SCALE = 0.091
	const float BATTLEPASS_QUIP_Z_OFFSET = 20.5
	const asset BATTLEPASS_QUIP_BG_MODEL = $"mdl/menu/loot_ceremony_quip_bg.rmdl"

	vector origin        = fileLevel.sceneRefOrigin + <0, 0, BATTLEPASS_QUIP_Z_OFFSET>
	vector angles        = fileLevel.sceneRefAngles
	vector placardAngles = VectorToAngles( AnglesToForward( angles ) * -1 )

	                                        
	float width  = scale * BATTLEPASS_QUIP_WIDTH * BATTLEPASS_QUIP_SCALE
	float height = scale * BATTLEPASS_QUIP_HEIGHT * BATTLEPASS_QUIP_SCALE

	entity model = CreateClientSidePropDynamic( origin, angles, BATTLEPASS_QUIP_BG_MODEL )
	model.MakeSafeForUIScriptHack()
	model.SetModelScale( scale * BATTLEPASS_QUIP_SCALE )

	var topo = CreateRUITopology_Worldspace( origin + <0, 0, (height * 0.5)>, placardAngles, width, height )
	var rui  = RuiCreate( $"ui/loot_reward_intro_quip.rpak", topo, RUI_DRAW_WORLD, 0 )

	string previewAlias = MusicPack_GetPreviewMusic( item )

	RuiSetBool( rui, "isVisible", true )
	RuiSetBool( rui, "battlepass", true )
	RuiSetInt( rui, "rarity", ItemFlavor_GetQuality( item ) )
	RuiSetImage( rui, "portraitImage", MusicPack_GetPortraitImage( item ) )
	RuiSetFloat( rui, "portraitBlend", MusicPack_GetPortraitBlend( item ) )
	RuiSetString( rui, "quipTypeText", "#MUSIC_PACK" )
	RuiTrackFloat( rui, "level", null, RUI_TRACK_SOUND_METER, 0 )

	fileLevel.models.append( model )
	fileLevel.topo = topo
	fileLevel.rui = rui

	                     
	if ( previewAlias != "" && shouldPlayAudioPreview )
	{
		fileLevel.playingPreviewAlias = previewAlias
		EmitSoundOnEntity( GetLocalClientPlayer(), previewAlias )
	}
}


void function ShowBattlePassItem_Loadscreen( ItemFlavor item, float scale )
{
	UpdateLoadscreenPreviewMaterial( fileLevel.loadscreenPreviewBox, null, ItemFlavor_GetGUID( item ) )
}


void function ShowBattlePassItem_SkydiveEmote( ItemFlavor item, float scale )
{
	const float BATTLEPASS_UNKNOWN_Z_OFFSET = 28

	                      
	vector origin = fileLevel.sceneRefOrigin + <0, 0, BATTLEPASS_UNKNOWN_Z_OFFSET>
	vector angles = VectorToAngles( AnglesToForward( fileLevel.sceneRefAngles ) * -1 )

	float width  = scale * BATTLEPASS_VIDEO_WIDTH / 14.0
	float height = scale * BATTLEPASS_VIDEO_HEIGHT / 14.0

	var topo = CreateRUITopology_Worldspace( origin, angles, width, height )
	var rui  = RuiCreate( $"ui/finisher_video.rpak", topo, RUI_DRAW_VIEW_MODEL, 0 )

	fileLevel.videoChannel = ReserveVideoChannel( BattlePassVideoOnFinished )
	RuiSetInt( rui, "channel", fileLevel.videoChannel )
	StartVideoOnChannel( fileLevel.videoChannel, SkydiveEmote_GetVideo( item ), true, 0.0 )

	fileLevel.topo = topo
	fileLevel.rui = rui
}


void function ShowBattlePassItem_QuestComicPage( ItemFlavor item, float scale )
{
	Assert( ItemFlavor_GetType( item ) == eItemType.quest_comic )

	const float BATTLEPASS_UNKNOWN_Z_OFFSET = 25

	                      
	vector origin = fileLevel.sceneRefOrigin + <0, 0, BATTLEPASS_UNKNOWN_Z_OFFSET>
	vector angles = VectorToAngles( AnglesToForward( fileLevel.sceneRefAngles ) * -1 )

	float width  = scale * BATTLEPASS_VIDEO_WIDTH / 16.0
	float height = scale * BATTLEPASS_VIDEO_HEIGHT / 16.0

	var topo = CreateRUITopology_Worldspace( origin, angles, width, height )
	var rui  = RuiCreate( $"ui/quest_reward_mission.rpak", topo, RUI_DRAW_VIEW_MODEL, 0 )

	var settingsBlock      = ItemFlavor_GetSettingsBlock( item )
	string comicPageName   = ItemFlavor_GetShortName( item )
	string comicPageDesc   = ItemFlavor_GetShortDescription( item )
	asset comicRewardImage = Comic_GetPreviewImage( item )

	RuiSetString( rui, "missionName", comicPageName )
	RuiSetString( rui, "missionDesc", comicPageDesc )
	RuiSetImage( rui, "missionImage", comicRewardImage )

	fileLevel.topo = topo
	fileLevel.rui = rui
}


void function ShowBattlePassItem_QuestMission( ItemFlavor item, float scale )
{
	Assert( ItemFlavor_GetType( item ) == eItemType.quest_mission )

	const float BATTLEPASS_UNKNOWN_Z_OFFSET = 25

	                      
	vector origin = fileLevel.sceneRefOrigin + <0, 0, BATTLEPASS_UNKNOWN_Z_OFFSET>
	vector angles = VectorToAngles( AnglesToForward( fileLevel.sceneRefAngles ) * -1 )

	float width  = scale * BATTLEPASS_VIDEO_WIDTH / 16.0
	float height = scale * BATTLEPASS_VIDEO_HEIGHT / 16.0

	var topo = CreateRUITopology_Worldspace( origin, angles, width, height )
	var rui  = RuiCreate( $"ui/quest_reward_mission.rpak", topo, RUI_DRAW_VIEW_MODEL, 0 )

	var settingsBlock   = ItemFlavor_GetSettingsBlock( item )
	string playlistName = GetSettingsBlockString( settingsBlock, "playlistName" )
	string missionName  = GetPlaylistVarString( playlistName, "name", "#PLAYLIST_UNAVAILABLE" )
	string missionDesc  = GetPlaylistVarString( playlistName, "description", "#HUD_UNKNOWN" )
	string imageKey     = GetPlaylistVarString( playlistName, "image", "" )
	asset missionImage  = GetImageFromImageMap( imageKey )

	RuiSetString( rui, "missionName", missionName )
	RuiSetString( rui, "missionDesc", missionDesc )
	RuiSetImage( rui, "missionImage", missionImage )

	fileLevel.topo = topo
	fileLevel.rui = rui
}


void function ShowBattlePassItem_Level( ItemFlavor item, float scale )
{
	vector origin = fileLevel.sceneRefOrigin + <0, 0, 28.0>
	vector angles = fileLevel.sceneRefAngles
	const asset BATTLEPASS_LEVEL_MODEL = $"mdl/menu/bp_badge.rmdl"

	entity mover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", origin, angles )
	mover.MakeSafeForUIScriptHack()

	entity model = CreateClientSidePropDynamic( origin, AnglesCompose( angles, <0, 32, 0> ), BATTLEPASS_LEVEL_MODEL )
	model.MakeSafeForUIScriptHack()
	model.SetParent( mover )
	model.SetModelScale( scale * 0.85 )
	mover.NonPhysicsRotate( <0, 0, -1>, fileLevel.rotateSpeed )

	fileLevel.mover = mover
	fileLevel.models.append( model )
}


void function ShowBattlePassItem_Character( ItemFlavor item, float scale )
{
	const float BATTLEPASS_UNKNOWN_Z_OFFSET = 25

	                      
	vector origin = fileLevel.sceneRefOrigin + <0, 0, BATTLEPASS_UNKNOWN_Z_OFFSET>
	vector angles = VectorToAngles( AnglesToForward( fileLevel.sceneRefAngles ) * -1 )

	float width  = scale * BATTLEPASS_VIDEO_WIDTH / 16.0
	float height = scale * BATTLEPASS_VIDEO_HEIGHT / 16.0

	var topo = CreateRUITopology_Worldspace( origin, angles, width, height )
	var rui  = RuiCreate( $"ui/loot_reward_character.rpak", topo, RUI_DRAW_WORLD, 0 )

	RuiSetString( rui, "bodyText", Localize( ItemFlavor_GetLongName( item ) ) )
	RuiSetString( rui, "titleText", Localize( "#LEGEND" ) )

	fileLevel.topo = topo
	fileLevel.rui = rui
}


                
                                                           
 
                                                      
                                         

                                                                                          
                                

                                                                                 
                                
                           
                         
                               

                                                                
                             
                            
                                                                                                          

                        
                                 
 
                      


void function ShowBattlePassItem_Unknown( ItemFlavor item, float scale )
{
	const float BATTLEPASS_UNKNOWN_Z_OFFSET = 25

	                      
	vector origin = fileLevel.sceneRefOrigin + <0, 0, BATTLEPASS_UNKNOWN_Z_OFFSET>
	vector angles = VectorToAngles( AnglesToForward( fileLevel.sceneRefAngles ) * -1 )

	float width  = scale * BATTLEPASS_VIDEO_WIDTH / 16.0
	float height = scale * BATTLEPASS_VIDEO_HEIGHT / 16.0

	var topo = CreateRUITopology_Worldspace( origin, angles, width, height )
	var rui  = RuiCreate( $"ui/loot_reward_temp.rpak", topo, RUI_DRAW_WORLD, 0 )

	RuiSetString( rui, "bodyText", Localize( ItemFlavor_GetLongName( item ) ) )

	fileLevel.topo = topo
	fileLevel.rui = rui
}


void function BattlePassVideoOnFinished( int channel )
{
}


                  
 
	                      
	                       
	                              
	                       
	                       
	                       
	                            
	                        
	                           
 

               
 
	                           
   


void function InitBattlePassLights()
{
	fileLevel.stationaryLights = GetEntArrayByScriptName( "battlepass_stationary_light" )
	fileLevel.stationaryLightOffsets.clear()

	entity ref = GetEntByScriptName( "battlepass_right_ref" )

	foreach ( light in fileLevel.stationaryLights )
	{
		fileLevel.stationaryLightOffsets[ light ] <- light.GetOrigin() - ref.GetOrigin()
	}

	                                            
	                                                                                          
	                                                                                          
	                                                                                          
	                                                                                          

	                                                                                 
}


void function BattlePassLightsOn()
{
	foreach ( light in fileLevel.stationaryLights )
		light.SetTweakLightUpdateShadowsEveryFrame( true )

	                                            

	              
	                        
	                   
	                          
	                   
	                  
	                   
	                        
	                    
	                      

	                 
	                              

	                                                                                                                                                 
	                                                                          

	                                                                               

	                                                               
	 
		                                           

		                                                                                         
		                                                                                 
		                                                                                 
		                                        
		                                        

		                                                      
		                                         
		                                                     
		                                                               
		                                                 
		                                                   
		                                              
		                                                             
		                                                     
		                                                            
		                                                                    
		                                          
	   
}

void function BattlePassLightsOff()
{
	foreach ( light in fileLevel.stationaryLights )
		light.SetTweakLightUpdateShadowsEveryFrame( false )

	                                            

	                                          
		                                

	                                               
	 
		                                                
		                                                        
		                                                                                        
	   
}
#endif          

#if UI
void function ServerCallback_GotBPFromPremier()
{
	thread _GotBPFromPremier()
}

void function _GotBPFromPremier()
{
	DialogData dialogData
	dialogData.header = "#BATTLEPASS_EA_ACCESS_PREMIUM_HEADER"
	dialogData.message = "#BATTLEPASS_EA_ACCESS_PREMIUM_BODY"
	dialogData.darkenBackground = true
	dialogData.noChoiceWithNavigateBack = true

	AddDialogButton( dialogData, "#CLOSE" )

	while ( IsDialog( GetActiveMenu() ) )
		WaitFrame()

	OpenDialog( dialogData )
}
#endif



#if CLIENT || UI
string function Season_GetLongName( ItemFlavor season )
{
	return ItemFlavor_GetLongName( season )
}


string function Season_GetShortName( ItemFlavor season )
{
	return Localize( ItemFlavor_GetShortName( season ) )
}


string function Season_GetTimeRemainingText( ItemFlavor season )
{
	int seasonEndUnixTime   = CalEvent_GetFinishUnixTime( season )
	int remainingSeasonTime = seasonEndUnixTime - GetUnixTimestamp()

	if ( remainingSeasonTime <= 0 )
		return Localize( "#BATTLE_PASS_SEASON_ENDED" )

	DisplayTime dt = SecondsToDHMS( remainingSeasonTime )
	return Localize( "#DAYS_REMAINING", string( dt.days ), string( dt.hours ) )
}


asset function Season_GetSmallLogo( ItemFlavor season )
{
	ItemFlavor pass = Season_GetBattlePass( season )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( pass ), "smallLogo" )
}


asset function Season_GetLobbyButtonImage( ItemFlavor season )
{
	ItemFlavor pass = Season_GetBattlePass( season )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( season ), "lobbyButtonImage" )
}


vector function Season_GetTitleTextColor( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_season )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "seasonTitleColor" )
}


vector function Season_GetHeaderTextColor( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_season )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "seasonHeaderColor" )
}


vector function Season_GetTimeRemainingTextColor( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_season )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "seasonTimeRemainingColor" )
}


vector function Season_GetTabBGDefaultCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_season )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "tabBGDefaultCol" )
}


vector function Season_GetTabBarDefaultCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_season )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "tabBarDefaultCol" )
}


vector function Season_GetTabBGFocusedCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_season )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "tabBGFocusedCol" )
}


vector function Season_GetTabBarFocusedCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_season )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "tabBarFocusedCol" )
}


vector function Season_GetTabBGSelectedCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_season )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "tabBGSelectedCol" )
}


vector function Season_GetTabBarSelectedCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_season )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "tabBarSelectedCol" )
}
#endif
