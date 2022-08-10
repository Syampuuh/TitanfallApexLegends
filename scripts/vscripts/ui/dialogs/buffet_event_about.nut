global function InitBuffetEventAboutDialog
global function BuffetEventAboutDialog_SetEvent

struct
{
	var        menu
	var        mainLayer
	array<var> modeButtons
	array<var> rewardButtons
	array<var> badgeButtons

	ItemFlavor& event

	table<var, ItemFlavorStack> rewardButtonItemMap
	table<var, bool>            rewardButtonIsOwnedMap
	table<var, int>             rewardButtonBadgeDataIntegerMap
} file

const int MODE_BUTTON_COUNT = 7
const int REWARD_BUTTON_COUNT = 22
const int BADGE_BUTTON_COUNT = 4

void function InitBuffetEventAboutDialog( var menu )
{
	file.menu = menu
	                         
	file.mainLayer = Hud_GetChild( file.menu, "MainLayer" )
	InitButtonRCP( file.mainLayer )

	for ( int modeBtnIdx = 0; modeBtnIdx < MODE_BUTTON_COUNT; modeBtnIdx++ )
	{
		var modeBtn = Hud_GetChild( menu, format( "ModeButton%02d", modeBtnIdx + 1 ) )
		file.modeButtons.append( modeBtn )
	}

	for ( int rewardBtnIdx = 0; rewardBtnIdx < REWARD_BUTTON_COUNT; rewardBtnIdx++ )
	{
		var rewardBtn = Hud_GetChild( menu, format( "RewardButton%02d", rewardBtnIdx + 1 ) )
		Hud_AddEventHandler( rewardBtn, UIE_CLICK, RewardButton_OnClick )
		file.rewardButtons.append( rewardBtn )
	}

	for ( int badgeBtnIdx = 0; badgeBtnIdx < BADGE_BUTTON_COUNT; badgeBtnIdx++ )
	{
		var badgeBtn = Hud_GetChild( menu, format( "BadgeButton%02d", badgeBtnIdx + 1 ) )
		file.badgeButtons.append( badgeBtn )
	}

	AddMenuEventHandler( menu, eUIEvent.MENU_GET_TOP_LEVEL, OnGetTopLevel )
	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnNavigateBack )
	#if NX_PROG
	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, Update_Layout )
	#endif

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE" )
	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_INSPECT", "#A_BUTTON_INSPECT", OnInspectFooterActivated, ShouldShowInspectFooter )
}


void function BuffetEventAboutDialog_SetEvent( ItemFlavor event )
{
	file.event = event
}


void function OnGetTopLevel()
{
	UI_SetPresentationType( ePresentationType.PLAY )
}


void function OnOpen()
{
	ItemFlavor event = file.event
	Assert( IsItemFlavorStructValid( event ), "Must call BuffetEventAboutDialog_SetEvent before opening the BuffetEventAboutDialog menu!" )

	HudElem_SetRuiArg( file.mainLayer, "bgImage", BuffetEvent_GetAboutPageBGImage( event ), eRuiArgType.IMAGE )
	HudElem_SetRuiArg( file.mainLayer, "bigIcon", BuffetEvent_GetAboutPageBigIcon( event ), eRuiArgType.IMAGE )
	HudElem_SetRuiArg( file.mainLayer, "barImage", BuffetEvent_GetAboutPageBarImage( event ), eRuiArgType.IMAGE )
	HudElem_SetRuiArg( file.mainLayer, "lineImage", BuffetEvent_GetAboutPageLineImage( event ), eRuiArgType.IMAGE )
	HudElem_SetRuiArg( file.mainLayer, "title", BuffetEvent_GetAboutPageTitleText( event ) )
	HudElem_SetRuiArg( file.mainLayer, "desc", BuffetEvent_GetAboutPageDescText( event ) )
	HudElem_SetRuiArg( file.mainLayer, "scoreTitle", BuffetEvent_GetAboutPageScoreTitleText( event ) )
	HudElem_SetRuiArg( file.mainLayer, "bgCol", SrgbToLinear( BuffetEvent_GetAboutPageBGCol( event ) ) )
	HudElem_SetRuiArg( file.mainLayer, "themeCol", SrgbToLinear( BuffetEvent_GetAboutPageThemeCol( event ) ) )
	HudElem_SetRuiArg( file.mainLayer, "headerCol", SrgbToLinear( BuffetEvent_GetAboutPageHeaderCol( event ) ) )
	HudElem_SetRuiArg( file.mainLayer, "bodyCol", SrgbToLinear( BuffetEvent_GetAboutPageBodyCol( event ) ) )
	HudElem_SetRuiArg( file.mainLayer, "barTextCol", SrgbToLinear( BuffetEvent_GetAboutPageBarTextCol( event ) ) )
	HudElem_SetRuiArg( file.mainLayer, "barTextOwnedCol", SrgbToLinear( BuffetEvent_GetAboutPageBarTextOwnedCol( event ) ) )
	HudElem_SetRuiArg( file.mainLayer, "scoreLabelCol", SrgbToLinear( BuffetEvent_GetAboutPageScoreLabelCol( event ) ) )
	HudElem_SetRuiArg( file.mainLayer, "scoreCol", SrgbToLinear( BuffetEvent_GetAboutPageScoreCol( event ) ) )

	BuffetEventModesAndChallengesData bemacd = BuffetEvent_GetModesAndChallengesData( event )

	if ( bemacd.modes.len() > MODE_BUTTON_COUNT )
		Warning( "Not enough mode buttons for the buffet event (%d > %d", bemacd.modes.len(), MODE_BUTTON_COUNT )

	table<string, TimestampRange> modeScheduleSoonestBlockMap
	array<string> scheduledModes
	foreach ( string modeName in bemacd.modes )
	{
		PlaylistScheduleData scheduleData = Playlist_GetScheduleData( modeName )
		TimestampRange ornull block
		if ( scheduleData.currentBlock != null )
			block = scheduleData.currentBlock
		else if ( scheduleData.nextBlock != null )
			block = scheduleData.nextBlock
		else if ( scheduleData.blocks.len() > 0 )
			block = scheduleData.blocks.top()

		if ( block != null )
		{
			scheduledModes.append( modeName )
			modeScheduleSoonestBlockMap[modeName] <- expect TimestampRange(block)
		}
	}
	scheduledModes.sort( int function( string modeA, string modeB ) : (modeScheduleSoonestBlockMap) {
		return modeScheduleSoonestBlockMap[modeA].startUnixTime - modeScheduleSoonestBlockMap[modeB].startUnixTime
	} )

	bool showModes = BuffetEvent_GetAboutPageShowsModes( event )

	for ( int modeIdx = 0; modeIdx < MODE_BUTTON_COUNT; modeIdx++ )
	{
		var modeBtn = file.modeButtons[modeIdx]
		if ( !showModes || modeIdx >= scheduledModes.len() )
		{
			Hud_Hide( modeBtn )
			continue
		}
		Hud_Show( modeBtn )

		string modeName              = scheduledModes[modeIdx]
		TimestampRange scheduleBlock = modeScheduleSoonestBlockMap[modeName]

		HudElem_SetRuiArg( modeBtn, "modeName", GetPlaylistVarString( modeName, "name", "" ) )
		HudElem_SetRuiArg( modeBtn, "themeCol", SrgbToLinear( BuffetEvent_GetAboutPageThemeCol( event ) ) )
		HudElem_SetRuiArg( modeBtn, "bodyCol", SrgbToLinear( BuffetEvent_GetAboutPageBodyCol( event ) ) )

		string imageKey = GetPlaylistVarString( modeName, "about_screen_image", "" )
		asset imageAsset
		if ( imageKey == "" )
			imageAsset = $"white"
		                                                    
		  	                                                 
		else Warning( "Playlist '%s' has invalid value for 'image': %s", modeName, imageKey )
		HudElem_SetRuiArg( modeBtn, "modeIcon", imageAsset, eRuiArgType.IMAGE )

		int utNow                           = GetUnixTimestamp()
		DisplayTime availabilityDisplayTime = SecondsToDHMS( scheduleBlock.startUnixTime - utNow + SECONDS_PER_HOUR )
		TimeParts availabilityTimeParts     = GetUnixTimeParts( scheduleBlock.startUnixTime - utNow + SECONDS_PER_HOUR )

		TimeParts startTimeParts = GetUnixTimeParts( scheduleBlock.startUnixTime )
		                                                                                               
		                                                                             
		TimeParts endTimeParts   = GetUnixTimeParts( scheduleBlock.endUnixTime )
		                                                                                           
		                                                                         

		int state = (utNow < scheduleBlock.startUnixTime ? 1            
		: utNow < scheduleBlock.endUnixTime ? 0           
		: -1        
		)
		HudElem_SetRuiArg( modeBtn, "scheduleState", state )

		ToolTipData toolTipData
		string nameString        = GetPlaylistVarString( modeName, "name", "" )
		string aboutString       = GetPlaylistVarString( modeName, "about_text", "" )
		bool doesHideFutureModes = GetCurrentPlaylistVarBool( "hide_future_buffet_modes", false )
		if ( state == 1 )            
		{
			HudElem_SetRuiArg( modeBtn, "doesHideFutureModes", doesHideFutureModes )

			if ( availabilityDisplayTime.days > 1 )
				HudElem_SetRuiArg( modeBtn, "scheduleAvailability", Localize( "#S03E03_UNLOCKS_IN_DAYS", availabilityDisplayTime.days ) )
			else if ( availabilityDisplayTime.days == 1 )
				HudElem_SetRuiArg( modeBtn, "scheduleAvailability", Localize( "#S03E03_UNLOCKS_IN_DAY", availabilityDisplayTime.days ) )
			else
				HudElem_SetRuiArg( modeBtn, "scheduleAvailability", Localize( "#S03E03_UNLOCKS_IN_HOURS", availabilityDisplayTime.hours ) )

			toolTipData.titleText = doesHideFutureModes ? "#S03E03_QUESTION_MARKS" : nameString
			toolTipData.descText = doesHideFutureModes ? "#S03E03_DETAILS_SOON" : aboutString
			toolTipData.actionHint1 = Localize( "#CHALLENGE_UNLOCKS_IN_DAYS_HOURS", availabilityDisplayTime.days, availabilityDisplayTime.hours )
		}
		else if ( state == 0 )           
		{
			HudElem_SetRuiArg( modeBtn, "scheduleAvailability", Localize( "#S03E03_AVAILABLE_NOW" ) )

			toolTipData.titleText = nameString
			toolTipData.descText = aboutString
			toolTipData.actionHint1 = "#MODE_SEARCH_TOOLTIP_HINT"
		}
		else if ( state == -1 )        
		{
			HudElem_SetRuiArg( modeBtn, "scheduleAvailability", Localize( "#S03E03_UNAVAILABLE_BUTTON" ) )

			toolTipData.titleText = nameString
			toolTipData.descText = aboutString
			toolTipData.actionHint1 = "#S03E03_UNAVAILABLE_HINT"
		}
		toolTipData.tooltipFlags = toolTipData.tooltipFlags | eToolTipFlag.INSTANT_FADE_IN
		Hud_SetToolTipData( modeBtn, toolTipData )
	}

	Update_Layout()
}

void function Update_Layout()
{
	ItemFlavor event = file.event
	BuffetEventModesAndChallengesData bemacd = BuffetEvent_GetModesAndChallengesData( event )
	bool showModes = BuffetEvent_GetAboutPageShowsModes( event )	

	int numBadges = bemacd.badges.len()
	if ( numBadges > BADGE_BUTTON_COUNT )
		Warning( "Buffet event defines more badges than layout can show (%d > %d)", numBadges, BADGE_BUTTON_COUNT )

	entity player = GetLocalClientPlayer()
	EHI playerEHI = ToEHI( player )

	for ( int badgeIdx = 0; badgeIdx < BADGE_BUTTON_COUNT; badgeIdx++ )
	{
		var badgeBtn = file.badgeButtons[badgeIdx]
		if ( badgeIdx >= numBadges )
		{
			Hud_Hide( badgeBtn )
			continue
		}
		Hud_Show( badgeBtn )

		Hud_SetX( badgeBtn, ContentScaledXAsInt( bemacd.badges[badgeIdx].x ) )
		Hud_SetY( badgeBtn, ContentScaledYAsInt( bemacd.badges[badgeIdx].y ) )
		Hud_SetSize( badgeBtn, ContentScaledXAsInt( bemacd.badges[badgeIdx].size ), ContentScaledYAsInt( bemacd.badges[badgeIdx].size ) )

		ItemFlavor badge = bemacd.badges[badgeIdx].badge

		bool isLocked = true
		if ( ItemFlavor_GetGRXMode( badge ) != eItemFlavorGRXMode.NONE )
		{
			isLocked = !GRX_IsItemOwnedByPlayer( badge )
		}
		else
		{
			int currTierIdx = GetPlayerBadgeDataInteger( playerEHI, badge, 0, null )
			if ( currTierIdx >= 0 || IsEverythingUnlocked() )
				isLocked = false
		}

		HudElem_SetRuiArg( badgeBtn, "isLocked", isLocked )
		HudElem_SetRuiArg( badgeBtn, "checkMarkCol", SrgbToLinear( BuffetEvent_GetAboutPageCheckMarkCol( event ) ) )

		var parentRui = Hud_GetRui( badgeBtn )
		if ( parentRui != null )
			RuiDestroyNestedIfAlive( parentRui, "badgeHandle" )

		CreateNestedGladiatorCardBadge( parentRui, "badgeHandle", playerEHI, badge, 0 )

		ToolTipData toolTipData = CreateBadgeToolTip( badge, null )
		Hud_SetToolTipData( badgeBtn, toolTipData )
	}

	file.rewardButtonItemMap.clear()

	int rewardBtnIdx = 0
	if ( bemacd.mainChallengeFlav != null )
	{
		ItemFlavor mainChallenge = expect ItemFlavor(bemacd.mainChallengeFlav)
		int tierCount            = Challenge_GetTierCount( mainChallenge )
		int activeTierIdx        = Challenge_GetCurrentTier( player, mainChallenge )

		HudElem_SetRuiArg( file.mainLayer, "challengeTiersCount", tierCount )

		int prevGoal = 0
		for ( int tierIdx = 0; tierIdx < tierCount; tierIdx++ )
		{
			int goal = Challenge_GetGoalVal( mainChallenge, tierIdx )

			if ( tierIdx == activeTierIdx || (tierIdx == tierCount - 1 && activeTierIdx == tierCount) )
			{
				int progress = Challenge_GetProgressValue( player, mainChallenge, tierIdx )
				HudElem_SetRuiArg( file.mainLayer, "progressNum", progress )

				float progressBarFrac = (float(tierIdx) + float( progress - prevGoal ) / float( goal - prevGoal )) / float(tierCount)
				HudElem_SetRuiArg( file.mainLayer, "progressBarFrac", progressBarFrac )
			}

			HudElem_SetRuiArg( file.mainLayer, format( "challengeTier%02dGoal", tierIdx ), goal )

			bool showDiagonalWeapons                                 = false
			bool shouldUseBadgeRuis                                  = false
			int maxNumUntilCombineToPlus                             = 2
			array<ChallengeRewardDisplayData> tierRewardDisplayDatas = GetChallengeRewardDisplayData( mainChallenge, tierIdx,
				showDiagonalWeapons, shouldUseBadgeRuis, false )

			int bestRarityTier = eRarityTier.NONE
			foreach ( int crddIdx, ChallengeRewardDisplayData crdd in tierRewardDisplayDatas )
			{
				bestRarityTier = maxint( bestRarityTier, crdd.rarityTier )

				var rewardBtn = file.rewardButtons[rewardBtnIdx]
				rewardBtnIdx++

				bool isOwned = tierIdx < activeTierIdx
				HudElem_SetRuiArg( rewardBtn, "isOwned", isOwned )
				HudElem_SetRuiArg( rewardBtn, "rewardIdx", crddIdx )
				HudElem_SetRuiArg( rewardBtn, "unownedRewardBorderImage", BuffetEvent_GetAboutPageUnownedRewardBorderImage( event ), eRuiArgType.IMAGE )
				HudElem_SetRuiArg( rewardBtn, "ownedRewardBorderImage", BuffetEvent_GetAboutPageOwnedRewardBorderImage( event ), eRuiArgType.IMAGE )
				HudElem_SetRuiArg( rewardBtn, "lineImage", BuffetEvent_GetAboutPageLineImage( event ), eRuiArgType.IMAGE )
				HudElem_SetRuiArg( rewardBtn, "checkMarkCol", SrgbToLinear( BuffetEvent_GetAboutPageCheckMarkCol( event ) ) )
				                                                                                                       
				                                                                                                        

				Hud_Show( rewardBtn )

				const int PROGRESS_BAR_X_OFFSET = 60                                                                                                        
				const int PROGRESS_BAR_Y_OFFSET = 144 + 560
				const int PROGRESS_BAR_WIDTH = 1808
				const int BUTTON_SIZE = 74
				const int BUTTON_GAP = 12

				int btnX = int( PROGRESS_BAR_X_OFFSET + float(PROGRESS_BAR_WIDTH) / float(tierCount) * (1.0 + tierIdx) - (BUTTON_SIZE + BUTTON_GAP) )
				int btnY = PROGRESS_BAR_Y_OFFSET + 33 + (BUTTON_SIZE + BUTTON_GAP) * crddIdx

				Hud_SetPos( rewardBtn, ContentScaledXAsInt( -btnX ), ContentScaledYAsInt( -btnY ) )

				SetRuiArgsForChallengeReward( Hud_GetRui( rewardBtn ), "reward", crdd )

				                                         
				                                                                                                                                  
				if ( ItemFlavor_GetType( crdd.flav ) == eItemType.account_pack )
				{
					asset icon = ItemFlavor_GetIcon( crdd.flav )
					if ( icon != $"" )
					{
						var rui = Hud_GetRui( rewardBtn )
						RuiSetImage( rui, "rewardIcon", icon )
					}
				}

				file.rewardButtonItemMap[rewardBtn] <- MakeItemFlavorStack( crdd.flav, crdd.originalQuantity )
				file.rewardButtonIsOwnedMap[rewardBtn] <- (activeTierIdx > tierIdx)
				file.rewardButtonBadgeDataIntegerMap[rewardBtn] <- crdd.badgeTier

				ToolTipData toolTipData
				if ( crdd.displayQuantity > 1 )
					toolTipData.titleText = format( "%s %s", LocalizeNumber( string(crdd.displayQuantity), true ), Localize( ItemFlavor_GetLongName( crdd.flav ) ) )
				else
					toolTipData.titleText = Localize( ItemFlavor_GetLongName( crdd.flav ) )

				string itemDesc = ItemFlavor_GetShortDescription( crdd.flav )
				                                                                                                                                                 
				if ( ItemFlavor_GetType( crdd.flav ) == eItemType.voucher )
				{
					itemDesc = Localize( itemDesc, int( BATTLEPASS_XP_BOOST_AMOUNT * 100 ) )
				}
				else if ( itemDesc.find( "!UNLOCALIZED!" ) != -1 )
				{
					itemDesc = ""
				}
				toolTipData.descText = itemDesc

				if ( InspectItemTypePresentationSupported( crdd.flav ) )
				{
					toolTipData.actionHint1 = Localize( "#INSPECT_TOOLTIP" )
				}
				                                    
				toolTipData.tooltipFlags = toolTipData.tooltipFlags | eToolTipFlag.INSTANT_FADE_IN
				Hud_SetToolTipData( rewardBtn, toolTipData )
			}

			prevGoal = goal
		}
	}
	for ( ; rewardBtnIdx < REWARD_BUTTON_COUNT; rewardBtnIdx++ )
		Hud_Hide( file.rewardButtons[rewardBtnIdx] )
}

void function OnClose()
{
	ItemFlavor invalidItemFlav
	file.event = invalidItemFlav
}


void function OnNavigateBack()
{
	CloseActiveMenu()
}


void function RewardButton_OnClick( var button )
{
	ItemFlavor event = file.event

	Assert( button in file.rewardButtonItemMap )
	ItemFlavorStack what = file.rewardButtonItemMap[button]

	if ( !InspectItemTypePresentationSupported( what.flav ) )
		return

	SetChallengeRewardPresentationModeActive( what.flav, what.qty, file.rewardButtonBadgeDataIntegerMap[button],
		"#CHALLENGE_REWARD",
		ItemFlavor_GetShortName( event ),
		file.rewardButtonIsOwnedMap[button]
	)
}


bool function ShouldShowInspectFooter()
{
	return file.rewardButtons.contains( GetFocus() )
}


void function OnInspectFooterActivated( var button )
{
	  
}

