global function InitAllChallengesMenu
global function AllChallengesMenu_UpdateCategories
global function AllChallengesMenu_GetLastGroupButton
global function AllChallengesMenu_SetLastGroupButton
global function AllChallengesMenu_ActivateLastGroupButton
global function AllChallengesMenu_ForceClickSpecialEventButton

global function InitAllChallengesPanel

global function JumpToChallenges

const int MAX_CHALLENGE_CATEGORIES_PER_PAGE = 8
const int MAX_CHALLENGE_CATEGORIES_PER_PAGE_NX = 5
const int MAX_CHALLENGE_PER_PAGE = 8
const int MAX_CHALLENGE_PER_PAGE_NX = 5
const int DEFAULT_CHALLENGE_UIE = UIE_GET_FOCUS

struct ChallengePanelData
{
	array<var>                            largeGroupButtonArray
	array<var>                            claimedLargeButtons
	var                                   groupListPanel
	array<var>                            pinnedChallengeButtons
	var                                   challengesListPanel
	ChallengeGroupData ornull             activeGroup = null
	bool                                  isShown = false
	int 								  largeListButtonIdx = 0
	var									  dividerLine
}

struct
{
	var                            menu
	table<var, ChallengePanelData> panelData
	var                            decorationRui
	var                            titleRui
	var                            lastSelectedGroupButton
	table<var, ChallengeGroupData> buttonGroupMap
	ChallengeGroupData			   &defaultGroup

} file


void function InitAllChallengesMenu( var newMenuArg )
{
	                                                      
  
	                     
	                

	                                                                     
	                                                           

	                                                                         
	                                                                         
	                                                                           
	                                                                                          
  
}


void function InitAllChallengesPanel( var panel, bool isInventory )
{
	ChallengePanelData panelData

	panelData.groupListPanel = Hud_GetChild( panel, "CategoryList" )
	panelData.pinnedChallengeButtons.append( Hud_GetChild( panel, "PinnedChallenge" ) )
	panelData.pinnedChallengeButtons.append( Hud_GetChild( panel, "PinnedChallenge2" ) )
	panelData.challengesListPanel = Hud_GetChild( panel, "ChallengesList" )
	panelData.largeGroupButtonArray = []
	panelData.dividerLine = Hud_GetChild( panel, "DividerLine" )

	{
		int i=0
		while ( Hud_HasChild( panel, "CategoryLargeButton" + i ) )
		{
			panelData.largeGroupButtonArray.append( Hud_GetChild( panel, "CategoryLargeButton" + i ) )
			i++
		}
	}

	SetPanelTabTitle( panel, "#MENU_CHALLENGES" )
	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnChallengePanelShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnChallengePanelHide )
	AddUICallback_LevelShutdown( OnLevelShutdown )

	if ( isInventory )
	{
		InitInventoryFooter( panel )
	}
	else
	{
		AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	}

	file.panelData[ panel ] <- panelData
}


void function AllChallengesMenu_OnOpen()
{
	RuiSetGameTime( file.decorationRui, "initTime", ClientTime() )
	RuiSetString( file.titleRui, "title", Localize( "#CHALLENGE_FULL_MENU_TITLE" ).toupper() )

	var panel = Hud_GetChild( file.menu, "ChallengesPanel" )
	ShowPanel( panel )
	                                                        
	                         
}

void function MarkAllChallengeItemsAsViewed( var button )
{
	if ( MarkAllItemsOfTypeAsViewed( eItemTypeUICategory.CAL_EVENT ) )
		EmitUISound( "UI_Menu_Accept" )
	else
		EmitUISound( "UI_Menu_Deny" )
}

void function JumpToChallenges()
{
	while ( GetActiveMenu() != GetMenu( "LobbyMenu" ) )
		CloseActiveMenu()

	TabData lobbyTabData = GetTabDataForPanel( GetMenu( "LobbyMenu" ) )
	int index            = Tab_GetTabIndexByBodyName( lobbyTabData, "SeasonPanel" )
	if ( lobbyTabData.activeTabIdx != index )
		ActivateTab( lobbyTabData, index )

	TabDef seasonTabDef   = Tab_GetTabDefByBodyName( lobbyTabData, "SeasonPanel" )
	TabData seasonTabData = GetTabDataForPanel( seasonTabDef.panel )
	index = Tab_GetTabIndexByBodyName( seasonTabData, "ChallengesPanel" )
	if ( seasonTabData.activeTabIdx != index )
		ActivateTab( seasonTabData, index )
}


void function AllChallengesMenu_OnShow()
{
	UI_SetPresentationType( ePresentationType.BATTLE_PASS_3 )
}


void function OnChallengePanelShow( var panel )
{
	if ( IsLobby() )
	{
		RunClientScript( "ClearBattlePassItem" )
		UI_SetPresentationType( ePresentationType.BATTLE_PASS_3 )
	}

	AllChallengesMenu_UpdateCategories( true )
}


void function OnChallengePanelHide( var panel )
{
	AllChallengesMenu_UpdateCategories( false )
}

void function OnLevelShutdown()
{
	file.lastSelectedGroupButton = null
}

void function AllChallengesMenu_OnClose()
{
	if ( !IsValid( GetLocalClientPlayer() ) )
		return

	AllChallengesMenu_UpdateActiveGroup()
}


void function AllChallengesMenu_OnNavigateBack()
{
	Assert( GetActiveMenu() == file.menu )
	CloseActiveMenu()
}


void function AllChallengesMenu_UpdateCategories( bool ornull isShown )
{
	foreach ( var button, ChallengeGroupData group in file.buttonGroupMap )
	{
		                                                                                                                                                 
		Hud_RemoveEventHandler( button, DEFAULT_CHALLENGE_UIE, GroupButton_OnSelect )
	}
	file.buttonGroupMap.clear()

	foreach ( panel, panelData in file.panelData )
	{
		panelData.activeGroup = null
		panelData.claimedLargeButtons.clear()
		panelData.claimedLargeButtons.resize( eChallengeTimeSpanKind.len(), null )

		if ( isShown != null )
			panelData.isShown = expect bool(isShown)

		if ( panelData.isShown )
		{
			array<ChallengeGroupData> groupData = GetPlayerChallengeGroupData( GetLocalClientPlayer() )

			var groupScrollPanel = Hud_GetChild( panelData.groupListPanel, "ScrollPanel" )

			ItemFlavor currentSeason = GetLatestSeason( GetUnixTimestamp() )
			int seasonStartUnixTime  = CalEvent_GetStartUnixTime( currentSeason )
			int seasonEndUnixTime    = CalEvent_GetFinishUnixTime( currentSeason )
			int weekCount            = (seasonEndUnixTime - seasonStartUnixTime) / SECONDS_PER_WEEK
			int currentWeek          = GetCurrentBattlePassWeek()

			ItemFlavor ornull activePass = GetActiveBattlePass()
			int numWeeksOfWeeklies       = 0
			if ( activePass != null )
			{
				expect ItemFlavor( activePass )
				numWeeksOfWeeklies = GetNumBattlePassChallengesWeeks( activePass )
			}

			array<var> usedButtons

			var dailyButton                    = null
			var weeklyRecurringButton          = null
			var eventButton                    = null
			ItemFlavor ornull eventFlav        = null
			int listButtonIdx                  = 0
			int largeListButtonIdx             = 0

			panelData.largeListButtonIdx = 0
			foreach ( button in panelData.largeGroupButtonArray )
				Hud_Hide( button )

			                                            
			foreach ( int groupIdx, ChallengeGroupData group in groupData )
			{
				var button
				if ( group.timeSpanKind == eChallengeTimeSpanKind.DAILY )
				{
					file.defaultGroup = group
					if ( activePass != null )
					{
						button = ClaimLargeGroupButton( panelData, group.timeSpanKind )
						dailyButton = button
						int remainingDuration = GetPersistentVarAsInt( "dailyExpirationTime" ) - Daily_GetCurrentTime()
						RuiSetGameTime( Hud_GetRui( button ), "expireTime", remainingDuration > 0 ? ClientTime() + remainingDuration : RUI_BADGAMETIME )
					}
					else                                                            
					{
						foreach ( i, pinnedChallengeButton in panelData.pinnedChallengeButtons )
							Hud_SetVisible( pinnedChallengeButton, false )
					}
				}
				else if ( group.timeSpanKind == eChallengeTimeSpanKind.SEASON_WEEKLY_RECURRING )
				{
					if ( activePass != null )
					{
						bool shouldShow = BattlePass_WeeklyRecurringResetsEveryWeek( expect ItemFlavor( activePass ) )

						if ( shouldShow )
						{
							button = ClaimLargeGroupButton( panelData, group.timeSpanKind )
							int remainingDuration = GetCurrentBattlePassWeekExpirationTime() - GetUnixTimestamp()
							RuiSetGameTime( Hud_GetRui( button ), "expireTime", remainingDuration > 0 ? ClientTime() + remainingDuration : RUI_BADGAMETIME )
						}
						else
						{
							continue
						}
					}
				}
				else if ( group.timeSpanKind == eChallengeTimeSpanKind.EVENT )
				{
					button = ClaimLargeGroupButton( panelData, group.timeSpanKind )
					eventButton = button
					int remainingDuration = 0
					if ( group.challenges.len() > 0 )
					{
						eventFlav = Challenge_GetSource( group.challenges[0] )
						expect ItemFlavor(eventFlav)
						Assert( ItemFlavor_GetType( eventFlav ) == eItemType.calevent_collection
						|| ItemFlavor_GetType( eventFlav ) == eItemType.calevent_themedshop
						|| ItemFlavor_GetType( eventFlav ) == eItemType.calevent_buffet )
						remainingDuration = CalEvent_GetFinishUnixTime( eventFlav ) - GetUnixTimestamp()
						group.groupName = Localize( ItemFlavor_GetShortName( eventFlav ) )
					}
					RuiSetGameTime( Hud_GetRui( button ), "expireTime", remainingDuration > 0 ? ClientTime() + remainingDuration : RUI_BADGAMETIME )
				}
				else if ( group.timeSpanKind == eChallengeTimeSpanKind.EVENT_SPECIAL )
				{
					if ( group.challenges.len() > 0 )
					{
						button = ClaimLargeGroupButton( panelData, group.timeSpanKind )
						ItemFlavor specialEventFlav = Challenge_GetSource( group.challenges[0] )
						Assert( ItemFlavor_GetType( specialEventFlav ) == eItemType.calevent_story_challenges )
						int remainingDuration = CalEvent_GetFinishUnixTime( specialEventFlav ) - GetUnixTimestamp()
						group.groupName = Localize( ItemFlavor_GetShortName( specialEventFlav ) )
						RuiSetGameTime( Hud_GetRui( button ), "expireTime", remainingDuration > 0 ? ClientTime() + remainingDuration : RUI_BADGAMETIME )
					}
					else
					{
						continue
					}
				}
				else if ( group.timeSpanKind == eChallengeTimeSpanKind.FAVORITE )
				{
					if ( group.challenges.len() > 0 )
					{
						button          = ClaimLargeGroupButton( panelData, group.timeSpanKind )
						group.groupName = Localize( "#CATEGORY_FAVORITES" )
						RuiSetGameTime( Hud_GetRui( button ), "expireTime", RUI_BADGAMETIME )
						HudElem_SetRuiArg( button, "isTrackedCategory", true )
					}
				}
				else
				{
					continue
				}

				                                                                                                                                                                    
				if ( button == null )
					continue

				Hud_SetSelected( button, false )
				Hud_AddEventHandler( button, DEFAULT_CHALLENGE_UIE, GroupButton_OnSelect )
				file.buttonGroupMap[ button ] <- group

				HudElem_SetRuiArg( button, "categoryName", group.groupName )
				HudElem_SetRuiArg( button, "challengeTotalNum", group.challenges.len() )
				HudElem_SetRuiArg( button, "challengeCompleteNum", group.completedChallenges )

				bool isAnyChallengeNew = false
				bool hasFavorites = false
				foreach ( ItemFlavor challenge in group.challenges )
				{
					if ( Newness_IsItemFlavorNew( challenge ) )
						isAnyChallengeNew = true
					if ( IsFavoriteChallenge( challenge ) )
						hasFavorites = true
				}
				Hud_SetNew( button, isAnyChallengeNew )
				if ( group.timeSpanKind == eChallengeTimeSpanKind.FAVORITE )
					hasFavorites = false
				HudElem_SetRuiArg( button, "hasFavorites", hasFavorites )

				usedButtons.append( button )
				                                                                                                                                                        
			}

			if ( eventButton != null )
			{
				Hud_SetEnabled( eventButton, eventFlav != null )
			}

			int maxChallengeCategoriesPerPage_NX = MAX_CHALLENGE_CATEGORIES_PER_PAGE_NX - 1
			int maxChallengeCategoriesPerPage    = MAX_CHALLENGE_CATEGORIES_PER_PAGE - 1

			                                                                                                                                                                                        
			if ( numWeeksOfWeeklies > 0 )
			{
				#if NX_PROG || PC_PROG_NX_UI
					if ( IsNxHandheldMode() )
					{
						Hud_InitGridButtonsDetailed( panelData.groupListPanel, numWeeksOfWeeklies, maxChallengeCategoriesPerPage_NX, 1 )
					}
					else
					{
						Hud_InitGridButtonsDetailed( panelData.groupListPanel, numWeeksOfWeeklies, maxChallengeCategoriesPerPage, 1 )
					}
				#else
					Hud_InitGridButtonsDetailed( panelData.groupListPanel, numWeeksOfWeeklies, maxChallengeCategoriesPerPage, 1 )
				#endif

				AllChallengesMenu_UpdateDpadNav( panel, panelData )

				foreach ( int groupIdx, ChallengeGroupData group in groupData )
				{
					var button
					if ( group.timeSpanKind == eChallengeTimeSpanKind.SEASON_WEEKLY )
					{
						button = Hud_GetChild( groupScrollPanel, "GridButton" + listButtonIdx )
						Hud_SetEnabled( button, true )
						listButtonIdx++
					}
					else
					{
						continue
					}

					Hud_SetSelected( button, false )
					Hud_AddEventHandler( button, DEFAULT_CHALLENGE_UIE, GroupButton_OnSelect )
					file.buttonGroupMap[ button ] <- group

					HudElem_SetRuiArg( button, "categoryName", group.groupName )
					HudElem_SetRuiArg( button, "challengeTotalNum", group.challenges.len() )
					HudElem_SetRuiArg( button, "challengeCompleteNum", group.completedChallenges )
					RuiSetGameTime( Hud_GetRui( button ), "revealTime", RUI_BADGAMETIME )

					bool isAnyChallengeNew = false
					bool hasFavorites = false
					foreach ( ItemFlavor challenge in group.challenges )
					{
						if ( Newness_IsItemFlavorNew( challenge ) )
							isAnyChallengeNew = true
						if ( IsFavoriteChallenge( challenge ) )
							hasFavorites = true
					}
					Hud_SetNew( button, isAnyChallengeNew )
					HudElem_SetRuiArg( button, "hasFavorites", hasFavorites )

					usedButtons.append( button )
					                                                                                                                                                        
				}

				int weekOffsetIndex = 0
				for ( int i = listButtonIdx ; i < numWeeksOfWeeklies ; i++ )
				{
					var button = Hud_GetChild( groupScrollPanel, "GridButton" + i )
					if ( usedButtons.contains( button ) )
						continue

					int revealDuration = (GetCurrentBattlePassWeekExpirationTime() - GetUnixTimestamp()) + (SECONDS_PER_WEEK * weekOffsetIndex)
					weekOffsetIndex++

					Hud_SetEnabled( button, false )
					HudElem_SetRuiArg( button, "categoryName", Localize( "#CHALLENGE_GROUP_WEEKLY", i + 1 ) )
					RuiSetGameTime( Hud_GetRui( button ), "revealTime", revealDuration > 0 ? ClientTime() + revealDuration : RUI_BADGAMETIME )
				}
			}

			if ( eventButton != null )
			{
				Hud_SetEnabled( eventButton, eventFlav != null )
			}

			if ( file.lastSelectedGroupButton != null )
			{
				GroupButton_OnSelect( file.lastSelectedGroupButton )
			}
			else if ( eventButton != null && eventFlav != null )
			{
				GroupButton_OnSelect( eventButton )
			}
			else if ( dailyButton != null )
			{
				GroupButton_OnSelect( dailyButton )
			}
			else if ( weeklyRecurringButton != null && Hud_IsVisible( weeklyRecurringButton ) )
			{
				GroupButton_OnSelect( weeklyRecurringButton )
			}
		}
	}
}

var function ClaimLargeGroupButton( ChallengePanelData panelData, int timeSpanKind )
{
	Assert( panelData.claimedLargeButtons[timeSpanKind]  == null, "Button for " + timeSpanKind + " already exists" )                                                                                                                                                                                                                                        
	var button = panelData.largeGroupButtonArray[ panelData.largeListButtonIdx++ ]
	panelData.claimedLargeButtons[timeSpanKind] = button
	Hud_SetPinSibling( panelData.groupListPanel, Hud_GetHudName( button ) )
	Hud_Show( button )
	return button
}

void function AllChallengesMenu_ForceClickSpecialEventButton( int timeSpanKind )
{
	var specialEventButton

	foreach ( panel, panelData in file.panelData )
	{
		if ( panelData.isShown )
		{
			specialEventButton = panelData.claimedLargeButtons[ timeSpanKind ]
			if ( specialEventButton != null )
			{
				break
			}
		}
	}

	if ( specialEventButton != null )
	{
		GroupButton_OnSelect( specialEventButton )
	}
	else
	{
		Assert( 0, "Special Event Challenges button is not valid." )
	}
}


void function GroupButton_OnSelect( var button )
{
	                                         
	                                             
	if ( !( button in file.buttonGroupMap ) )
	{
		foreach ( panel, panelData in file.panelData )
			panelData.activeGroup = file.defaultGroup

		AllChallengesMenu_UpdateActiveGroup()
		return
	}

	Assert( button in file.buttonGroupMap )

	foreach ( panel, panelData in file.panelData )
		panelData.activeGroup = file.buttonGroupMap[ button ]

	file.lastSelectedGroupButton = button
	AllChallengesMenu_UpdateActiveGroup()
	Hud_SetNew( button, false )
}


void function AllChallengesMenu_UpdateActiveGroup()
{
	foreach ( panel, panelData in file.panelData )
	{
		                                                
		foreach ( var button, ChallengeGroupData buttonGroup in file.buttonGroupMap )
			Hud_SetSelected( button, buttonGroup == panelData.activeGroup )

		if ( panelData.activeGroup == null )
			continue

		ChallengeGroupData group = expect ChallengeGroupData(panelData.activeGroup)

		var challengesScrollPanel  = Hud_GetChild( panelData.challengesListPanel, "ScrollPanel" )
		int numChallengesToDisplay = 0

		array<ItemFlavor> pinnedChallenges = GetPinnedChallenges()
		array<ItemFlavor> challengesToDisplay = clone group.challenges

		if ( group.timeSpanKind == eChallengeTimeSpanKind.EVENT )
		{
			if ( group.event != null )
			{
				ItemFlavor event = expect ItemFlavor( group.event )
				BuffetEventModesAndChallengesData bData = BuffetEvent_GetModesAndChallengesData( event )
				if ( bData.mainChallengeFlav != null )
				{
					ItemFlavor main = expect ItemFlavor( bData.mainChallengeFlav )
					pinnedChallenges = [ main ]
					Newness_IfNecessaryMarkItemFlavorAsNoLongerNewAndInformServer( main )
					challengesToDisplay.removebyvalue( main )
				}
			}
		}

		if ( group.timeSpanKind == eChallengeTimeSpanKind.EVENT_HIDDEN )
		{
			if ( group.event != null )
			{
				ItemFlavor event = expect ItemFlavor( group.event )
				BuffetEventModesAndChallengesData bData = BuffetEvent_GetModesAndChallengesData( event )
				foreach ( ItemFlavor hiddenChallenge in bData.hiddenChallenges )
				{
					challengesToDisplay.removebyvalue( hiddenChallenge )
				}
			}
		}

		foreach ( ItemFlavor challenge in challengesToDisplay )
		{
			if ( !Challenge_IsPinned( challenge ) )
				numChallengesToDisplay++
		}

#if NX_PROG || PC_PROG_NX_UI
		if ( IsNxHandheldMode() )
		{
			Hud_InitGridButtonsDetailed( panelData.challengesListPanel, numChallengesToDisplay, MAX_CHALLENGE_PER_PAGE_NX, 1 )
		}
		else
		{
			Hud_InitGridButtonsDetailed( panelData.challengesListPanel, numChallengesToDisplay, MAX_CHALLENGE_PER_PAGE, 1 )
		}
#else
		Hud_InitGridButtonsDetailed( panelData.challengesListPanel, numChallengesToDisplay, MAX_CHALLENGE_PER_PAGE, 1 )
#endif

		foreach ( i, pinnedChallengeButton in panelData.pinnedChallengeButtons )
		{
			bool isVisible = pinnedChallenges.len() > i
			Hud_SetVisible( pinnedChallengeButton, isVisible )
			Hud_SetHeight( pinnedChallengeButton, isVisible ? Hud_GetBaseHeight( pinnedChallengeButton ): 0 )
		}

		foreach ( i, pinnedChallengeButton in panelData.pinnedChallengeButtons )
		{
			if ( i < pinnedChallenges.len() )
				PutChallengeOnFullChallengeWidget( pinnedChallengeButton, pinnedChallenges[i], true )
		}

		int buttonIndex = 0
		foreach ( ItemFlavor challenge in challengesToDisplay )
		{
			Newness_IfNecessaryMarkItemFlavorAsNoLongerNewAndInformServer( challenge )

			if ( Challenge_IsPinned( challenge ) )
				continue

			var listItem = Hud_GetChild( challengesScrollPanel, "GridButton" + buttonIndex )
			PutChallengeOnFullChallengeWidget( listItem, challenge, false )
			buttonIndex++
		}
	}
}


void function AllChallengesMenu_UpdateDpadNav( var panel, ChallengePanelData panelData )
{
	var categoryScrollPanel = Hud_GetChild( panelData.groupListPanel, "ScrollPanel" )

	                                         
	if ( !Hud_HasChild( categoryScrollPanel, "GridButton0" ) )
		return

	Hud_SetNavUp( Hud_GetChild( categoryScrollPanel, "GridButton0" ), panelData.largeGroupButtonArray[ panelData.largeListButtonIdx-1 ] )
	Hud_SetNavDown( panelData.largeGroupButtonArray[ panelData.largeListButtonIdx-1 ], Hud_GetChild( categoryScrollPanel, "GridButton0" ) )
}


void function PutChallengeOnFullChallengeWidget( var button, ItemFlavor challenge, bool useAltColor )
{
	Hud_ClearToolTipData( button )
	var rui = Hud_GetRui( button )

	vector progressBarColor  = useAltColor ? SrgbToLinear( <255, 215, 55> / 255.0 ) : SrgbToLinear( <255, 85, 33> / 255.0 )
	vector progressTextColor = useAltColor ? SrgbToLinear( <254, 227, 113> / 255.0 ) : SrgbToLinear( <253, 152, 123> / 255.0 )

	int timeSpan = Challenge_GetTimeSpanKind( challenge )
	bool mythicSkinEnabled = false
	if ( timeSpan == eChallengeTimeSpanKind.EVENT )
	{
		ItemFlavor eventFlav = Challenge_GetSource( challenge )
		progressBarColor = BuffetEvent_GetProgressBarCol( eventFlav )
		progressTextColor = BuffetEvent_GetProgressBarTextCol( eventFlav )
	}
	else if ( timeSpan == eChallengeTimeSpanKind.MYTHIC )
	{
		mythicSkinEnabled = true


	}

	int displayTier = Challenge_GetCurrentTier( GetLocalClientPlayer(), challenge )
                  
	bool isEitherOrChallenge = Challenge_IsEitherOr( challenge )

	RuiSetBool( rui, "hasEitherOr", isEitherOrChallenge )
       

	RuiSetFloat3( rui, "progressBarColor", progressBarColor )
	RuiSetFloat3( rui, "progressTextColor", progressTextColor )

	array<int> gameModes

                  
	if( isEitherOrChallenge )
	{
		gameModes = Challenge_EitherOr_GetGameModes( challenge )
	}
	else
       
	{
		gameModes.append( Challenge_GetGameMode( challenge ) )
	}

	foreach( int idx, int gameMode in gameModes)
	{
		string modifier = ( idx > 0 ) ? "Alt": ""
		RuiSetString( rui, "challenge" + modifier + "ModeTag", Challenge_GetGameModeTag( gameMode ) )
		RuiSetFloat3( rui, "challenge" + modifier + "ModeTagColor", Challenge_GetGameModeTagColor( gameMode ) )
	}

	if ( Challenge_IsComplete( GetLocalClientPlayer(), challenge ) )
		displayTier -= 1

	int rewardBPLevels        = 0
	bool rewardsForActiveTier = true
	for ( int tier = displayTier; tier < Challenge_GetTierCount( challenge ); tier++ )
	{
		rewardBPLevels = Challenge_GetBattlepassLevelsReward( challenge, tier )
		if ( rewardBPLevels > 0 )
		{
			rewardsForActiveTier = (tier == displayTier)
			break
		}
	}

	RuiSetBool( rui, "showMythicIndicator", mythicSkinEnabled )

	if ( mythicSkinEnabled )
		RuiSetInt( rui, "activeMythicTier", displayTier + 1 )

                  
		SetRuiArgsForChallengeTier( rui, "challenge", challenge, null, 1, 0, isEitherOrChallenge )
      
                                                                       
       
	RuiSetBool( rui, "challengeIsFavorite", IsFavoriteChallenge( challenge ) )
	RuiSetBool( rui, "challengeCanClickToReroll", false )

#if NX_PROG
	RuiSetImage( rui, "nxCyanTint", IsFavoriteChallenge( challenge ) ? $"white" : $"" )
#endif

	if ( IsLobby() )
	{
		bool isChallengeComplete = Challenge_IsComplete( GetLocalClientPlayer(), challenge )
		bool canReroll = Challenge_CanRerollChallenge( challenge ) && !isChallengeComplete
		if ( canReroll )
		{
			RuiSetBool( rui, "challengeCanClickToReroll", true )
		}

		bool allowSetFavorites = true
		MaybeAddChallengeClickEventToButton( null, button, challenge, displayTier, canReroll, isChallengeComplete, allowSetFavorites )
	}
}


void function AllChallengesMenu_ActivateLastGroupButton()
{
	if ( file.lastSelectedGroupButton != null && ( file.lastSelectedGroupButton in file.buttonGroupMap ) )
		GroupButton_OnSelect( file.lastSelectedGroupButton )
}


var function AllChallengesMenu_GetLastGroupButton()
{
	return file.lastSelectedGroupButton
}


void function AllChallengesMenu_SetLastGroupButton( var button )
{
	file.lastSelectedGroupButton = button
}


