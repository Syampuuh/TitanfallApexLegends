global function InitCardBadgesPanel
global function CreateBadgeToolTip
global function GetBadgeCategoryName

enum eCardBadgeCategories                                                        
{
	MENU_BADGE_ACCOUNT,
	MENU_BADGE_RANKED,
	MENU_BADGE_SEASON,
	MENU_BADGE_EVENT,
	MENU_BADGE_LEGEND,
	MENU_BADGE_CLUB,
	MENU_BADGE_ARENAS,
}

const table<int,string> CARD_BADGE_CATEGORY_NAMES =
{
	[ eCardBadgeCategories.MENU_BADGE_ACCOUNT ] = "#MENU_BADGE_ACCOUNT",
	[ eCardBadgeCategories.MENU_BADGE_RANKED ]  = "#MENU_BADGE_RANKED",
	[ eCardBadgeCategories.MENU_BADGE_SEASON ]  = "#MENU_BADGE_SEASON",
	[ eCardBadgeCategories.MENU_BADGE_EVENT ]   = "#MENU_BADGE_EVENT",
	[ eCardBadgeCategories.MENU_BADGE_LEGEND ]  = "#MENU_BADGE_LEGEND",
	[ eCardBadgeCategories.MENU_BADGE_CLUB ]    = "#MENU_BADGE_CLUB",
	[ eCardBadgeCategories.MENU_BADGE_ARENAS ]  = "#MENU_BADGE_ARENAS",
}

struct
{
	var               panel
	var               listPanel
	bool			  hideAllLockedBadges
	array<ItemFlavor> cardBadgeList
	array<int>		  cardBadgeCategoryIndices
	table<int,int>    cardBadgeCategoryCount
	table<int,int>    cardBadgeCategoryUnlockCount
} file


void function InitCardBadgesPanel( var panel )
{
	file.panel = panel
	file.listPanel = Hud_GetChild( panel, "BadgeList" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, CardBadgesPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, CardBadgesPanel_OnHide )
	AddPanelEventHandler_FocusChanged( panel, CardBadgesPanel_OnFocusChanged )

	file.hideAllLockedBadges = false
	var hideLockedButton = Hud_GetChild( file.panel, "ToggleHideShowLocked" )
	HudElem_SetRuiArg( hideLockedButton, "showAll", true )
	Hud_AddEventHandler( hideLockedButton, UIE_CLICK, ToggleHideShowLockedBadges )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	                                                            
	                                                                                                                  
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK_LEGEND", "#X_BUTTON_UNLOCK_LEGEND", null, CustomizeMenus_IsFocusedItemParentItemLocked )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP", null, CustomizeMenus_IsFocusedItemEquippable )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_CLEAR", "#X_BUTTON_CLEAR", null, bool function () : ()
	{
		return ( CustomizeMenus_IsFocusedItemUnlocked() && !CustomizeMenus_IsFocusedItemEquippable() )
	} )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK", "#X_BUTTON_UNLOCK", null, CustomizeMenus_IsFocusedItemLocked )

	RegisterSignal( "StopCycleBadgePreviewImageThread" )

	file.cardBadgeCategoryCount.clear()
	file.cardBadgeCategoryUnlockCount.clear()
}


void function CardBadgesPanel_OnShow( var panel )
{
	CardBadgesPanel_Update( panel )
}


void function CardBadgesPanel_OnHide( var panel )
{
	CardBadgesPanel_Update( panel )
	Hud_ClearAllToolTips()
}


void function CardBadgesPanel_Update( var panel )
{
	var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )

	var hideLockedButton = Hud_GetChild( file.panel, "ToggleHideShowLocked" )
	HudElem_SetRuiArg( hideLockedButton, "showAll", file.hideAllLockedBadges ? false : true  )

	          
	foreach ( int flavIdx, ItemFlavor unused in file.cardBadgeList )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
		CustomizeButton_UnmarkForUpdating( button )
	}
	file.cardBadgeList.clear()
	file.cardBadgeCategoryIndices.clear()

	for ( int badgeIndex = 0; badgeIndex < GLADIATOR_CARDS_NUM_BADGES; badgeIndex++ )
		SendMenuGladCardPreviewCommand( eGladCardPreviewCommandType.BADGE, badgeIndex, null )

	                                  
	if ( IsPanelActive( file.panel ) )
	{
		ItemFlavor character = GetTopLevelCustomizeContext()
		int badgeIndex       = 0                         

		array<LoadoutEntry> entries
		LoadoutEntry entry
		for ( int i = 0; i < GLADIATOR_CARDS_NUM_BADGES; i++ )
		{
			entry = Loadout_GladiatorCardBadge( character, i )
			entries.append( entry )
		}

		file.cardBadgeList = clone GetValidItemFlavorsForLoadoutSlot( LocalClientEHI(), entry )
		FilterCategorizeAndSortBadges( character, file.cardBadgeList )

		Hud_InitGridButtons( file.listPanel, file.cardBadgeList.len() )
		Hud_InitGridButtonsCategories( file.listPanel, file.cardBadgeCategoryIndices )
		foreach ( int flavIdx, ItemFlavor flav in file.cardBadgeList )
		{
			var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
			CustomizeButton_UpdateAndMarkForUpdating( button, entries, flav, PreviewCardBadge, CanEquipCanBuyBadgeCheck )

			var rui = Hud_GetRui( button )
			RuiDestroyNestedIfAlive( rui, "badge" )
			CreateNestedGladiatorCardBadge( rui, "badge", LocalClientEHI(), flav, badgeIndex, character )

			ToolTipData toolTipData = CreateBadgeToolTip( flav, character )
			Hud_SetToolTipData( button, toolTipData )

			for ( int i = 0; i < file.cardBadgeCategoryIndices.len(); ++i )
			{
				if ( file.cardBadgeCategoryIndices[i] == flavIdx )
				{
					string cat = GetGlobalSettingsString( ItemFlavor_GetAsset( flav ), "badgeCategory" )
					int catIndex = GetBadgeCategoryIndexForName( cat )
					string lockUnlock = " "+file.cardBadgeCategoryUnlockCount[catIndex]+" / "+file.cardBadgeCategoryCount[catIndex]
					if ( catIndex == eCardBadgeCategories.MENU_BADGE_LEGEND )
						cat = Localize( ItemFlavor_GetLongName( character ) )
					else
						cat = Localize( CARD_BADGE_CATEGORY_NAMES[ catIndex ] )

					var category = Hud_GetChild( scrollPanel, "GridCategory" + i )
					HudElem_SetRuiArg( category, "label", cat )
					HudElem_SetRuiArg( category, "display", lockUnlock )
				}
			}
		}
	}

	Hud_ScrollToTop( file.listPanel )
}

                                                                                                                                               
                                                               
ToolTipData function CreateBadgeToolTip( ItemFlavor badge, ItemFlavor ornull character )
{
	ToolTipData toolTipData
	toolTipData.tooltipStyle = eTooltipStyle.GLADIATOR_CARD_BADGE
	toolTipData.titleText = Localize( ItemFlavor_GetLongName( badge ) )

	                                                                                                                                                                                                    
	string categoryName = GetBadgeCategoryName( badge )
	array<GladCardBadgeTierData> tierDataList = GladiatorCardBadge_GetTierDataList( badge )
	string badgeHint                          = GladiatorCardBadge_IsCharacterBadge( badge ) ? Localize( "#CHARACTER_BADGE", Localize( ItemFlavor_GetLongName( expect ItemFlavor( character ) ) ) ) : Localize( "#ACCOUNT_BADGE", categoryName )

	string unlockStatRef = GladiatorCardBadge_GetUnlockStatRef( badge, character )
	if ( tierDataList.len() > 1 && unlockStatRef != ACCOUNT_BADGE_STAT )
	{
		int currTierIdx = GetPlayerBadgeDataInteger( LocalClientEHI(), badge, 0, character )
		int nextOrMaxTierIdx = minint( currTierIdx + 1, tierDataList.len() - 1 )
		int progressCount = 0

		if ( IsValidStatEntryRef( unlockStatRef ) )
		{
			StatEntry stat = GetStatEntryByRef( unlockStatRef )
			entity player = FromEHI( LocalClientEHI() )
			progressCount = GetStat_Int( player, stat, eStatGetWhen.CURRENT )
		}

		bool shouldShowProgress = ( progressCount > 0 )
		string goalStr = ""
		if ( !shouldShowProgress )
			nextOrMaxTierIdx = 0

		foreach ( int tierIdx, GladCardBadgeTierData tierData in tierDataList )
		{
			if ( tierIdx > 0 )
				goalStr += " | "

			if ( currTierIdx == tierIdx )
				goalStr += "`3"

			goalStr += string(tierData.unlocksAt)

			if ( currTierIdx == tierIdx )
				goalStr += "`2"
		}

		if ( shouldShowProgress )
			toolTipData.actionHint1 = Localize( "#BADGE_TIER_PROGRESS", progressCount, tierDataList[nextOrMaxTierIdx].unlocksAt )
		toolTipData.actionHint2 = Localize( "#BADGE_TIER", currTierIdx + 1, tierDataList.len() ) + "`2 - " + goalStr
		toolTipData.actionHint3 = badgeHint

		int displayTierIdx      = maxint( 0, currTierIdx )
		float unlockRequirement = tierDataList[displayTierIdx].unlocksAt
		toolTipData.descText = Localize( ItemFlavor_GetShortDescription( badge ), format( "`2%s`0", string(unlockRequirement) ) )
	}
	else
	{
		if ( tierDataList.len() == 1 && tierDataList[0].unlocksAt > 0 )
		{
			if ( IsValidStatEntryRef( unlockStatRef ) )
			{
				StatEntry se = GetStatEntryByRef( unlockStatRef )
				bool good     = true
				int currVal = 0
				float goalVal = tierDataList[0].unlocksAt

				if ( goalVal == 1 )
					good = false
				else
					currVal = GetStat_Int( GetLocalClientPlayer(), se )

				if ( good )
					toolTipData.actionHint1 = format( "%s / %s", string(currVal), string(goalVal) )
			}
			else if ( ItemFlavor_GetGRXMode( badge ) == eItemFlavorGRXMode.REGULAR )
			{
				                                        
				if ( GetGlobalSettingsAsset( ItemFlavor_GetAsset( badge ), "parentItemFlavor" ) != "" )
				{
					asset parentAsset = GetGlobalSettingsAsset( ItemFlavor_GetAsset( badge ), "parentItemFlavor" )
					                                                                               
					if ( IsValidItemFlavorSettingsAsset( parentAsset ) )
					{
						ItemFlavor parentChallengeFlav = GetItemFlavorByAsset( parentAsset )
						                                                                                                                                                                        
						if ( ItemFlavor_GetType( parentChallengeFlav ) == eItemType.challenge )
						{
							entity player = FromEHI( LocalClientEHI() )
							if ( Challenge_IsAssigned( player, parentChallengeFlav ) )
							{
								int tier = 0                                              
								int challengeProgressvalue = Challenge_GetProgressValue( player, parentChallengeFlav, tier )
								int challengeGoalValue = Challenge_GetGoalVal( parentChallengeFlav, tier )
								if ( challengeGoalValue > 1 && !Challenge_IsComplete( player, parentChallengeFlav ) )
									toolTipData.actionHint1 = format( "%s / %s", string(challengeProgressvalue), string(challengeGoalValue) )
							}
						}
					}
				}
			}
		}

		toolTipData.descText = Localize( ItemFlavor_GetShortDescription( badge ) )

		toolTipData.actionHint2 = badgeHint
	}
	toolTipData.tooltipFlags = toolTipData.tooltipFlags | eToolTipFlag.INSTANT_FADE_IN

	return toolTipData
}


void function CardBadgesPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) )                  
		return
	if ( GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()

	if ( IsValid( oldFocus ) && Hud_GetParent( oldFocus ) == Hud_GetChild( file.listPanel, "ScrollPanel" ) )
	{
		Signal( oldFocus, "StopCycleBadgePreviewImageThread" )
	}
	if ( IsValid( newFocus ) && Hud_GetParent( newFocus ) == Hud_GetChild( file.listPanel, "ScrollPanel" ) )
	{
		thread CycleBadgePreviewImageThread( newFocus )
	}
}


void function CycleBadgePreviewImageThread( var button )
{
	EndSignal( button, "StopCycleBadgePreviewImageThread" )

	ItemFlavor badgeFlav                      = CustomizeButton_GetItemFlavor( button )
	array<GladCardBadgeTierData> tierDataList = GladiatorCardBadge_GetTierDataList( badgeFlav )
	if ( tierDataList.len() <= 1 )
		return

	if ( ItemFlavor_GetHumanReadableRef( badgeFlav ) == ACCOUNT_BADGE_NAME )
		return

	int tierIndex = 0

	OnThreadEnd( void function() : ( button, badgeFlav ) {
		if ( IsValid( button ) )
		{
			int badgeIndex       = GetCardPropertyIndex()
			var rui              = Hud_GetRui( button )
			RuiDestroyNestedIfAlive( rui, "badge" )
			if ( IsTopLevelCustomizeContextValid() )
			{
				ItemFlavor character = GetTopLevelCustomizeContext()
				CreateNestedGladiatorCardBadge( rui, "badge", LocalClientEHI(), badgeFlav, badgeIndex, character, null )
			}
		}
	} )

	while ( IsValid( button ) && Hud_IsFocused( button ) && IsTopLevelCustomizeContextValid() )
	{
		ItemFlavor character = GetTopLevelCustomizeContext()
		var rui              = Hud_GetRui( button )
		RuiDestroyNestedIfAlive( rui, "badge" )
		CreateNestedGladiatorCardBadge( rui, "badge", LocalClientEHI(), badgeFlav, -1, character, tierIndex )

		wait 1.1

		tierIndex++
		if ( tierIndex >= tierDataList.len() )
			tierIndex = 0
	}
}


void function PreviewCardBadge( ItemFlavor flav )
{
	int badgeIndex = GetCardPropertyIndex()
	SendMenuGladCardPreviewCommand( eGladCardPreviewCommandType.BADGE, badgeIndex, flav )
}


int function CanEquipCanBuyBadgeCheck( ItemFlavor unused )
{
	int status = CanEquipCanBuyCharacterItemCheck( unused )
	if ( status == eItemCanEquipCanBuyStatus.CAN_EQUIP_CAN_BUY )
		return eItemCanEquipCanBuyStatus.CAN_EQUIP_CANNOT_BUY
	return status
}


void function FilterCategorizeAndSortBadges( ItemFlavor character, array<ItemFlavor> badgeList )
{
	table<ItemFlavor, int> equippedBadgeSet
	for ( int iterBadgeIndex = 0; iterBadgeIndex < GLADIATOR_CARDS_NUM_BADGES; iterBadgeIndex++ )
	{
		LoadoutEntry badgeSlot = Loadout_GladiatorCardBadge( character, iterBadgeIndex )
		if ( LoadoutSlot_IsReady( LocalClientEHI(), badgeSlot ) )
		{
			ItemFlavor badge = LoadoutSlot_GetItemFlavor( LocalClientEHI(), badgeSlot )
			equippedBadgeSet[badge] <- iterBadgeIndex
		}
	}
	for ( int i = badgeList.len() - 1; i >= 0; i-- )
	{
		if ( !ShouldDisplayBadge( badgeList[i], equippedBadgeSet, character ) )
			badgeList.remove( i )
	}

	badgeList.sort( int function( ItemFlavor a, ItemFlavor b ) : ( equippedBadgeSet ) {
		bool a_isEquipped = (a in equippedBadgeSet)
		bool b_isEquipped = (b in equippedBadgeSet)
		if ( a_isEquipped != b_isEquipped )
			return (a_isEquipped ? -1 : 1)

		int aso = GladiatorCardBadge_GetSortOrdinal( a )
		int bso = GladiatorCardBadge_GetSortOrdinal( b )
		return aso - bso
	} )

	                                                                                                                                                       
	badgeList.sort( int function( ItemFlavor a, ItemFlavor b ) {
		if ( GetGlobalSettingsString( ItemFlavor_GetAsset( a ), "badgeCategory" ) > GetGlobalSettingsString( ItemFlavor_GetAsset( b ), "badgeCategory" ) )
		{
			return 1
		}
		else if ( GetGlobalSettingsString( ItemFlavor_GetAsset( a ), "badgeCategory" ) < GetGlobalSettingsString( ItemFlavor_GetAsset( b ), "badgeCategory" ) )
		{
			return -1
		}
		else if ( GetGlobalSettingsString( ItemFlavor_GetAsset( a ), "badgeCategory" ) == GetGlobalSettingsString( ItemFlavor_GetAsset( b ), "badgeCategory" ) )
		{
			if ( ItemFlavor_GetHumanReadableRef( a )  > ItemFlavor_GetHumanReadableRef( b ) )
				return 1
			if ( ItemFlavor_GetHumanReadableRef( b )  > ItemFlavor_GetHumanReadableRef( a ) )
				return -1
		}
		return 0
	} )

	int prevCatIndex = -1
	                                                                                                    
	foreach ( cat in eCardBadgeCategories )
	{
		if ( !( cat in file.cardBadgeCategoryCount ) )
			file.cardBadgeCategoryCount[cat] <- 0
		else
			file.cardBadgeCategoryCount[cat] = 0

		if ( !( cat in file.cardBadgeCategoryUnlockCount ) )
			file.cardBadgeCategoryUnlockCount[cat] <- 0
		else
			file.cardBadgeCategoryUnlockCount[cat] = 0
	}
	                                                                                                                                                                                
	for ( int i = 0; i < badgeList.len(); i++ )
	{
		string curCat = GetGlobalSettingsString( ItemFlavor_GetAsset( badgeList[i] ), "badgeCategory" )
		int curCatIndex = GetBadgeCategoryIndexForName(curCat)

		if ( curCatIndex in file.cardBadgeCategoryCount && ( !GladiatorCardBadge_ShouldHideIfLocked( badgeList[i] ) || IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_GladiatorCardBadge( character, 0 ), badgeList[i] ) ) )
			file.cardBadgeCategoryCount[curCatIndex]++

		if ( IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_GladiatorCardBadge( character, 0 ), badgeList[i] ) )
		{
			if ( curCatIndex in file.cardBadgeCategoryUnlockCount )
				file.cardBadgeCategoryUnlockCount[curCatIndex]++
		}

		if ( curCatIndex != prevCatIndex )
		{
			file.cardBadgeCategoryIndices.append( i )
			prevCatIndex = curCatIndex
		}
	}
}


bool function ShouldDisplayBadge( ItemFlavor badge, table<ItemFlavor, int> equippedBadgeSet, ItemFlavor character )
{
	if ( GladiatorCardBadge_ShouldHideIfLocked( badge ) || file.hideAllLockedBadges )
	{
		if ( !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_GladiatorCardBadge( character, 0 ), badge ) )
			return false
	}

	if ( GladiatorCardBadge_IsTheEmpty( badge ) )
		return false

	return true
}

void function ToggleHideShowLockedBadges( var button )
{
	file.hideAllLockedBadges = !file.hideAllLockedBadges
	CardBadgesPanel_Update( Hud_GetParent( button ) )
	Hud_ScrollToTop( file.listPanel )
}

int function GetBadgeCategoryIndexForName( string name )
{
	for ( int i = 0; i < CARD_BADGE_CATEGORY_NAMES.len(); i++ )
	{
		if ( CARD_BADGE_CATEGORY_NAMES[i].find( name ) != -1 )
			return i
	}

	return 0
}

string function GetBadgeCategoryName( ItemFlavor badge )
{
	string categoryName = GetGlobalSettingsString( ItemFlavor_GetAsset( badge ), "badgeCategory" )
	int catIndex = GetBadgeCategoryIndexForName( categoryName )
	categoryName = Localize( CARD_BADGE_CATEGORY_NAMES[ catIndex ] )

	return categoryName
}
