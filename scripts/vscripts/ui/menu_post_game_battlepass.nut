global function InitPostGameBattlePassMenu
global function OpenPostGameBattlePassMenu

struct
{
	var menu
	var matchRank
	var matchSummaryBackground
	var matchSummaryChallengeList
	var matchSummary

	var continueButton
	var battlePassNextRewardButton

	array<var>              rewardButtonArray
	table<BattlePassReward> buttonToRewardTable

	bool isFirstTime

	bool postGameUpdateComplete = false

	int xpChallengeTier = -1
	int xpChallengeValue = -1

	bool buttonsRegistered = false
} file

struct PinnedXPAndStarsProgressBar
{
	var         rui
	ItemFlavor& progressBarFlavor
	int         tierStart
	int         startingPoints
	int         pointsToAddTotal
	int         challengesCompleted
	int         battlePassLevelsEarned
	int         challengeStarsAndXpEarned
	int         currentPassLevel
}


void function InitPostGameBattlePassMenu( var newMenuArg )
{
	file.menu = newMenuArg
	var menu = file.menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnPostGameBattlePassMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnPostGameBattlePassMenu_Close )

	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnPostGameBattlePassMenu_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, OnPostGameBattlePassMenu_Hide )

	                                                                                           
	                                                                           

  	                          
  	                               

	RegisterSignal( "ShowBPSummary" )

	file.matchRank = Hud_GetChild( file.menu, "MatchRank" )
	file.matchSummaryBackground = Hud_GetChild( menu, "MatchSummaryBackground" )
	file.matchSummaryChallengeList = Hud_GetChild( menu, "ChallengeList" )
	file.matchSummary = Hud_GetChild( menu, "MatchSummary" )

	file.battlePassNextRewardButton = Hud_GetChild( menu, "ChallengesNextBPReward" )
	Hud_AddEventHandler( file.battlePassNextRewardButton, UIE_CLICK, RewardButton_OnClick )

	file.rewardButtonArray = GetPanelElementsByClassname( menu, "RewardButton" )
	foreach ( var button in file.rewardButtonArray )
		Hud_AddEventHandler( button, UIE_CLICK, RewardButton_OnClick )



	file.continueButton = Hud_GetChild( menu, "ContinueButton" )
	Hud_AddEventHandler( file.continueButton, UIE_CLICK, OnContinue_Activate )

	var menuHeaderRui = Hud_GetRui( Hud_GetChild( menu, "MenuHeader" ) )
	RuiSetString( menuHeaderRui, "menuName", "#MATCH_SUMMARY" )

#if DEV
	AddMenuThinkFunc( newMenuArg, PostGameBattlePassAutomationThink )
#endif       
}


void function OpenPostGameBattlePassMenu( bool firstTime )
{
	                                                                                                                 
	                                                                                                        
	ItemFlavor ornull activePass = GetActiveBattlePass()
	if ( activePass != null )
	{
		expect ItemFlavor( activePass )
		ItemFlavor ornull starChallenge = GetBattlePassRecurringStarChallenge( activePass )
		if ( starChallenge != null )
		{
			expect ItemFlavor( starChallenge )
			if ( !Challenge_IsAssigned( GetLocalClientPlayer(), starChallenge ) )
				return
		}
	}

	bool forceFirstTime = false

	#if DEV
		forceFirstTime = GetBugReproNum() == 100
	#endif

	file.isFirstTime = firstTime || forceFirstTime
	AdvanceMenu( file.menu )
}


void function OnPostGameBattlePassMenu_Open()
{
	ClearGameBattlePassMenu()
}


void function OnPostGameBattlePassMenu_Close()
{
	ClearGameBattlePassMenu()
}


void function OnPostGameBattlePassMenu_Show()
{
                         
                                                             
      
		if ( IsLastPlaylistArenasMode() )
		{
			                                                             
			UI_SetPresentationType( ePresentationType.ARENAS_RANKED )
			Hud_Hide( Hud_GetChild( file.menu, "ScreenFrame" ) )
		}
		else
		{
			UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )
			Hud_Show( Hud_GetChild( file.menu, "ScreenFrame" ) )
		}
       

	if ( !file.buttonsRegistered )
	{
		RegisterButtonPressedCallback( BUTTON_A, OnContinue_Activate )
		RegisterButtonPressedCallback( KEY_SPACE, OnContinue_Activate )
		file.buttonsRegistered = true
	}

	                                                                                                 
	ItemFlavor ornull battlepass = GetActiveBattlePass()
	if ( battlepass == null )
		return                                      
	expect ItemFlavor( battlepass )

	UpdateMatchRankDisplay()
	UpdateSummaryBackground( battlepass )

	thread ShowChallengeProgression( battlepass )
}

#if DEV
void function PostGameBattlePassAutomationThink( var menu )
{
	if (AutomateUi())
	{
		printt("PostGameBattlePassAutomationThink OnContinue_Activate()")
		OnContinue_Activate(null)
	}
}
#endif       

const int CHALLENGES_BEFORE_SCROLL = 8
const float CHALLENGES_DISPLAY_DELAY = 0.4
const float CHALLENGES_DISPLAY_MIN_DElAY = 0.05

struct matchSummaryData
{
	array<ItemFlavor> rewardArray
	int               starsEarned
	int               battlePassLevelGained
	int               RewardsEarned
}

void function ShowChallengeProgression( ItemFlavor battlePass )
{
	                                                                                     
	Signal( uiGlobal.signalDummy, "ShowBPSummary" )
	EndSignal( uiGlobal.signalDummy, "ShowBPSummary" )

	                                                                                      
	                                                                                                                   
	if ( file.postGameUpdateComplete )
		return

	entity player = GetLocalClientPlayer()

	OnThreadEnd(
		function () : ()
		{
			                                                                       
			UpdateFooterOptions()
		}
	)

	                                                             
	Hud_SetVisible( Hud_GetChild( file.menu, "ContinueButton" ), false )

	#if DEV
		wait 0.5                                                               
	#endif

	waitthread WaitToUpdateUntilReady( player )

	var matchSummaryRui = Hud_GetRui( file.matchSummary )
	SetSeasonColors( matchSummaryRui )

	                                                      
	Hud_SetVisible( file.matchSummary, true )
	Hud_SetVisible( file.battlePassNextRewardButton, true )

	                                  
	foreach ( var button in file.rewardButtonArray )
		Hud_SetVisible( button, false )

	bool instantUpdate = !file.isFirstTime

	                                                                                         
	int currentRealPassProgress = GetPlayerBattlePassXPProgress( ToEHI( player ), battlePass )

	array<ChallengeProgressData> challengeProgressDataArray = GetPlayerChallengesWithNewProgress( player )
	int finalRowCount                                       = GetRowsInChallengeProgressDataArray( challengeProgressDataArray )
	var scrollPanel                                         = Hud_GetChild( file.matchSummaryChallengeList, "ScrollPanel" )

	                                                 
	int previousPassProgress = GetPlayerBattlePassXPProgress( ToEHI( player ), battlePass, true )
	                                                                                                          
	previousPassProgress += GetStarChallengeProgressStartLastMatch( player, battlePass )
	int startLastMatchPassLevel = GetBattlePassLevelForXP( battlePass, previousPassProgress )

	int progressToCompletePreviousPassLevel = GetTotalXPToCompletePassLevel( battlePass, startLastMatchPassLevel - 1 )
	int passMaxLevel                        = GetBattlePassMaxLevelIndex( battlePass )

	                      
	                                         
	  	                                                      
	      
	  	                                                                                 

	int currentPassLevel         = startLastMatchPassLevel      
	int nextPassLevel            = currentPassLevel < passMaxLevel ? currentPassLevel + 1 : currentPassLevel
	int progressTowardsNextLevel = previousPassProgress - progressToCompletePreviousPassLevel

	bool ownBattlePass    = DoesPlayerOwnBattlePass( player, battlePass )
	bool playLevelUpAudio = false

	int earnedStars    = 0
	int gainedLevels   = 0
	int archivedPrizes = 0

	RuiSetBool( matchSummaryRui, "supressAnimation", true )

	                                    
	{
		SetBattlePassLevelReward( battlePass, file.battlePassNextRewardButton, nextPassLevel, ownBattlePass )
		SetBattlePassLevelBadgeForLevel( player, matchSummaryRui, battlePass, currentPassLevel + 1, currentPassLevel >= passMaxLevel )
		UpdatePostGameValues( matchSummaryRui, progressTowardsNextLevel, earnedStars, gainedLevels, archivedPrizes )
	}

	if ( !instantUpdate )
		wait 0.5

	int archiveButtonIndex = 0
	int rowIndex           = 0                                                                                                 
	foreach ( ChallengeProgressData baseChallengeData in challengeProgressDataArray )
	{
		array<ChallengeProgressData> groupArray = [baseChallengeData]
		bool grouped                            = baseChallengeData.groupArray.len() != 0
		if ( grouped )
			groupArray.extend( baseChallengeData.groupArray )

		foreach ( int index, ChallengeProgressData challengeData in groupArray )
		{
			bool updateNeeded
			int battlePassLevel = currentPassLevel                              
			bool challengeIsIndented = grouped && index > 0

			rowIndex++

			Hud_InitGridButtons( file.matchSummaryChallengeList, rowIndex )
			var button = Hud_GetChild( scrollPanel, "GridButton" + (rowIndex - 1) )
			UpdateChallengeProgressbutton( player, button, challengeData, challengeIsIndented, rowIndex )


			if ( challengeData.isTierCompleted )
			{
				var rui = Hud_GetRui( button )
				RuiSetGameTime( rui, "flareRewardStartTime", ClientTime() )

				ItemFlavorBag challengeRewardsBag = Challenge_GetRewards( challengeData.challengeFlav, challengeData.tier )
				foreach ( int bagIndex, ItemFlavor reward in challengeRewardsBag.flavors )
				{
					int quantity       = challengeRewardsBag.quantities[ bagIndex ]
					int rewardItemType = ItemFlavor_GetType( reward )

					                              
					if ( rewardItemType == eItemType.voucher )
					{
						int bpLevels = Voucher_GetEffectBattlepassLevels( reward ) * quantity
						int stars    = Voucher_GetEffectBattlepassStars( reward ) * quantity

						earnedStars += stars                    

						                               
						currentPassLevel = minint( passMaxLevel, currentPassLevel + bpLevels )                                    
						nextPassLevel = currentPassLevel + 1                                                                            

						if ( stars > 0 )
						{
							stars += progressTowardsNextLevel                                              
							while ( true )
							{
								int curr                    = GetTotalXPToCompletePassLevel( battlePass, currentPassLevel )
								int prev                    = GetTotalXPToCompletePassLevel( battlePass, currentPassLevel - 1 )
								int progressNeededToLevelUp = curr - prev                                                                             

								if ( stars < progressNeededToLevelUp )
									break                                                         

								currentPassLevel = minint( passMaxLevel, currentPassLevel + 1 )                                    
								nextPassLevel = currentPassLevel + 1                                                                            

								bpLevels++
								stars = stars - progressNeededToLevelUp                                 
							}
							progressTowardsNextLevel = stars                               
							updateNeeded = true
						}

						gainedLevels += bpLevels                    
						if ( bpLevels > 0 )
						{
							playLevelUpAudio = true
							if ( !instantUpdate && rowIndex <= CHALLENGES_BEFORE_SCROLL )
							{
								EmitUISound( GetGlobalSettingsString( ItemFlavor_GetAsset( battlePass ), "levelUpSound" ) )
								playLevelUpAudio = false
							}
							updateNeeded = true
						}

						for ( int gIndex = 0; gIndex < bpLevels; gIndex++ )
						{
							int rewardsAdded = AddBattlePassRewardsToArchive( battlePass, battlePassLevel + 1, archiveButtonIndex, ownBattlePass )

							battlePassLevel++
							archiveButtonIndex += rewardsAdded
							archivedPrizes += rewardsAdded                           
						}
					}

					                                                  
					if ( challengeData.isEventChallenge && challengeData.isEventMain )
					{
						                                

						                                                                                              
						if ( rewardItemType == eItemType.gladiator_card_badge && quantity == 0 )
							quantity = 1

						                                                                   
						if ( rewardItemType == eItemType.account_currency )
							quantity = 1

						BattlePassReward rewardData = ItemFlavorBagToBattlePassRewardByIndex( challengeRewardsBag, bagIndex )
						for ( int rewardIndex = 0; rewardIndex < quantity; rewardIndex++ )
						{
							if ( archiveButtonIndex >= file.rewardButtonArray.len() )
							{
								Warning( "Post Game Menu ran out of buttons to show rewards on" )
								continue                          
							}

							var rewardButton = file.rewardButtonArray[ archiveButtonIndex ]
							BattlePass_PopulateRewardButton( rewardData, rewardButton, false, true, null )

							if ( InspectItemTypePresentationSupported( rewardData.flav ) )
								AssignRewardToButton( rewardButton, rewardData )

							archiveButtonIndex++
							archivedPrizes++                           
							updateNeeded = true
						}
					}
				}
			}

			if ( updateNeeded && !instantUpdate )
			{
				RuiSetBool( matchSummaryRui, "supressAnimation", false )

				SetBattlePassLevelReward( battlePass, file.battlePassNextRewardButton, nextPassLevel, ownBattlePass )
				SetBattlePassLevelBadgeForLevel( player, matchSummaryRui, battlePass, currentPassLevel + 1, currentPassLevel >= passMaxLevel )
				UpdatePostGameValues( matchSummaryRui, progressTowardsNextLevel, earnedStars, gainedLevels, archivedPrizes )
			}

			                                                                     
			if ( !instantUpdate )
			{
				bool onScreen = rowIndex <= CHALLENGES_BEFORE_SCROLL
				string soundStr = onScreen ? "UI_Menu_MatchSummary_ChallengeBreakdown_Onscreen" : "UI_Menu_MatchSummary_ChallengeBreakdown_OffScreen"
				EmitUISound( soundStr )

				wait onScreen ? CHALLENGES_DISPLAY_DELAY : CHALLENGES_DISPLAY_MIN_DElAY
			}
		}
	}

	if ( instantUpdate )
	{
		RuiSetBool( matchSummaryRui, "supressAnimation", false )

		SetBattlePassLevelReward( battlePass, file.battlePassNextRewardButton, nextPassLevel, ownBattlePass )
		SetBattlePassLevelBadgeForLevel( player, matchSummaryRui, battlePass, currentPassLevel + 1, currentPassLevel >= passMaxLevel )
		UpdatePostGameValues( matchSummaryRui, progressTowardsNextLevel, earnedStars, gainedLevels, archivedPrizes )
	}

	if ( playLevelUpAudio )
	{
		EmitUISound( GetGlobalSettingsString( ItemFlavor_GetAsset( battlePass ), "levelUpSound" ) )
	}

	file.postGameUpdateComplete = true
	Hud_SetVisible( file.continueButton, true )

	                                                                             
	if ( file.isFirstTime )
		thread TryDisplayBattlePassAwards( true )
}


void function UpdatePostGameValues( var rui, int progressTowardsNextLevel, int earnedStars, int gainedLevels, int archivedPrizes )
{
	RuiSetInt( rui, "bpStarCount", progressTowardsNextLevel )
	RuiSetInt( rui, "earnedStars", earnedStars )
	RuiSetInt( rui, "gainedLevels", gainedLevels )
	RuiSetInt( rui, "archivedPrizes", archivedPrizes )
}


void function AssignRewardToButton( var button, BattlePassReward rewardData )
{
	                 
	  	                              

	ToolTipData toolTipData
	toolTipData.tooltipStyle = eTooltipStyle.BUTTON_PROMPT

	void functionref(var) clickHandler
	toolTipData.actionHint1 = "#VIEW_REWARD_TOOLTIP"

	Hud_SetToolTipData( button, toolTipData )
	file.buttonToRewardTable[ button ] <- rewardData
}


void function UpdateChallengeProgressbutton( entity player, var button, ChallengeProgressData challengeData, bool challengeIsIndented, int rowIndex )
{
	var rui = Hud_GetRui( button )

	RuiSetBool( rui, "isVisible", true )

	ItemFlavor challengeFlav = challengeData.challengeFlav
	int tierCount            = Challenge_GetTierCount( challengeFlav )                                                               
	int activeTier           = challengeData.tier
	bool isTierComplete      = challengeData.isTierCompleted
                  
	bool isAlt				 = challengeData.isAlt
       

	                                             
	bool isInfinite = false
	if ( activeTier == tierCount - 1 )
		isInfinite = Challenge_LastTierIsInfinite( challengeFlav )

	int startProgress = challengeData.startProgress
	int endProgress   = challengeData.endProgress
	int goalProgress  = challengeData.goalProgress

	vector progressBarColor  = SrgbToLinear( <255, 85, 33> / 255.0 )
	vector progressTextColor = SrgbToLinear( <253, 152, 123> / 255.0 )

	                                                      
	if ( challengeData.isEventChallenge )
	{
		ItemFlavor eventFlav = Challenge_GetSource( challengeData.challengeFlav )
		progressBarColor = BuffetEvent_GetProgressBarCol( eventFlav )
		progressTextColor = BuffetEvent_GetProgressBarTextCol( eventFlav )
	}
	else if ( challengeData.isPinned )
	{
		progressBarColor = SrgbToLinear( <255, 215, 55> / 255.0 )
		progressTextColor = SrgbToLinear( <254, 227, 113> / 255.0 )
	}


	               
	RuiSetFloat3( rui, "progressBarColor", progressBarColor )
	RuiSetFloat3( rui, "progressTextColor", progressTextColor )
	RuiSetBool( rui, "challengeIsIndented", challengeIsIndented )
                  
	RuiSetString( rui, "challengeTierDesc", Challenge_GetDescription( challengeFlav, activeTier, isAlt ) )
      
                                                                                                
       

	#if DEV
		bool doDebug = (InputIsButtonDown( KEY_LSHIFT ) && InputIsButtonDown( KEY_LCONTROL )) || (InputIsButtonDown( BUTTON_TRIGGER_LEFT_FULL ) && InputIsButtonDown( BUTTON_B ))
		if ( doDebug )
		{
			printt( "#challenge --", ItemFlavor_GetHumanReadableRef( challengeFlav ) )
			RuiSetString( rui, "challengeTierDesc", ItemFlavor_GetHumanReadableRef( challengeFlav ) + " | " + activeTier )
		}
	#endif

	SetSeasonColors( rui )

	RuiSetInt( rui, "challengeTierStart", startProgress )
	RuiSetInt( rui, "challengeTierProgress", endProgress )
	RuiSetInt( rui, "challengeTierGoal", goalProgress )
	RuiSetBool( rui, "challengeCompleted", isTierComplete )

	RuiSetInt( rui, "challengeTiersCount", tierCount )
	RuiSetInt( rui, "challengeActiveTierIdx", activeTier )
	RuiSetBool( rui, "challengeIsInfinite", isInfinite )

	RuiSetGameTime( rui, "flareRewardStartTime", RUI_BADGAMETIME )

                  
	int gameMode = Challenge_GetGameMode( challengeFlav, isAlt )
      
                                                      
       
	RuiSetString( rui, "challengeModeTag", Challenge_GetGameModeTag( gameMode ) )
	RuiSetFloat3( rui, "challengeModeTagColor", Challenge_GetGameModeTagColor( gameMode ) )

	                      
	bool showDiagonalWeapons                  = true                                                           
	bool shouldUseBadgeRuis                   = false                                                  
	array<ChallengeRewardDisplayData> rewards = GetChallengeRewardDisplayData( challengeFlav, activeTier, showDiagonalWeapons, shouldUseBadgeRuis, true )
	if ( rewards.len() >= MAX_REWARDS_PER_CHALLENGE_TIER )
		Warning( "Too many rewards for one challenge: " + ItemFlavor_GetHumanReadableRef( challengeFlav ) )

	for ( int rewardIdx = 0; rewardIdx < maxint( rewards.len(), MAX_REWARDS_PER_CHALLENGE_TIER ); rewardIdx++ )
	{
		string ruiArgPrefix = "challengeTierReward" + rewardIdx
		if ( rewardIdx < rewards.len() )
			SetRuiArgsForChallengeReward( rui, ruiArgPrefix, rewards[ rewardIdx ] )
		else
			SetRuiArgsForChallengeReward( rui, ruiArgPrefix, null )
	}
}


void function WaitToUpdateUntilReady( entity player )
{
	                                                              
	bool showRankedSummary = GetPersistentVarAsInt( "showRankedSummary" ) != 0
	if ( showRankedSummary )
	{
		WaitFrame()                                                                        
		while( GetActiveMenu() != file.menu )
		{
			WaitFrame()
		}
	}

	if ( !showRankedSummary && file.isFirstTime && TryOpenSurvey( eSurveyType.POSTGAME ) )
	{
		while ( IsDialog( GetActiveMenu() ) )
		{
			WaitFrame()
		}
	}

	                                                           
	while ( !GRX_IsInventoryReady( player ) || !Challenge_IsChallengesStateInititated( player ) )
	{
		WaitFrame()
	}
}


int function AddBattlePassRewardsToArchive( ItemFlavor battlePass, int battlePassLevel, int archiveButtonIndex, bool ownBattlePass )
{
	BattlePassReward ornull rewardToShow
	array<BattlePassReward> rewards = GetBattlePassLevelRewards( battlePass, battlePassLevel )                            

	int earnedBPRewards = 0
	foreach ( reward in rewards )
	{
		if ( archiveButtonIndex >= file.rewardButtonArray.len() )
		{
			Warning( "Post Game Menu ran out of buttons to show rewards on" )
			continue                          
		}

		if ( ( reward.isPremium && ownBattlePass ) || !reward.isPremium )
		{
			var rewardButton = file.rewardButtonArray[ archiveButtonIndex ]
			BattlePass_PopulateRewardButton( reward, rewardButton, false, true, null )

			if ( InspectItemTypePresentationSupported( reward.flav ) )
				AssignRewardToButton( rewardButton, reward )

			archiveButtonIndex++
			earnedBPRewards++
		}
	}

	return earnedBPRewards
}


void function SetBattlePassLevelReward( ItemFlavor battlePass, var button, int nextPassLevel, bool ownBattlePass )
{
	BattlePassReward ornull battlePassReward = TrySetBattlePassRewardOnButton( button, battlePass, nextPassLevel, false )
	                                                                                           

	if ( battlePassReward != null )
	{
		expect BattlePassReward( battlePassReward )
		AssignRewardToButton( button, battlePassReward )
		if ( ShouldDisplayTallButton( battlePassReward.flav ) )
		{
			Hud_ReturnToBasePos( button )
		}
		else
		{
			UIPos basePos = REPLACEHud_GetBasePos( button )
			Hud_SetPos( button, basePos.x, basePos.y - 20 )
		}
	}
	else
	{
		Hud_SetVisible( button, false )
	}
	
}


void function UpdateSummaryBackground( ItemFlavor battlePass )
{
	string bpLongName = ItemFlavor_GetShortName( battlePass )

	HudElem_SetRuiArg( file.matchSummaryBackground, "titleText", "#CHALLENGE_FULL_MENU_TITLE" )
	HudElem_SetRuiArg( file.matchSummaryBackground, "subTitleText", bpLongName )
}


void function UpdateMatchRankDisplay()
{
	var matchRankRui = Hud_GetRui( file.matchRank )
	PopulateMatchRank( matchRankRui )
}


void function ClearGameBattlePassMenu()
{
	                                            
	var matchRankRui    = Hud_GetRui( file.matchRank )
	var backgroundRui   = Hud_GetRui( file.matchSummaryBackground )
	var matchSummaryRui = Hud_GetRui( file.matchSummary )

	RuiSetInt( matchRankRui, "squadRank", 0 )
	RuiSetInt( matchRankRui, "totalPlayers", 0 )
	RuiSetString( matchRankRui, "lastPlayedText", "" )

	RuiSetString( backgroundRui, "titleText", "" )
	RuiSetString( backgroundRui, "subTitleText", "" )

	RuiDestroyNestedIfAlive( matchSummaryRui, "headerBadgeHandle" )
	RuiSetInt( matchSummaryRui, "earnedStars", -1 )
	RuiSetInt( matchSummaryRui, "gainedLevels", -1 )
	RuiSetInt( matchSummaryRui, "archivedPrizes", -1 )

	RuiSetInt( matchSummaryRui, "archivedPrizes", -1 )
	RuiSetFloat3( matchSummaryRui, "seasonColor", <1, 1, 1> )
	RuiSetFloat3( matchSummaryRui, "seasonBGColor", <1, 1, 1> )

	Hud_InitGridButtons( file.matchSummaryChallengeList, 0 )                               

	Hud_SetVisible( file.matchSummary, false )
	Hud_SetVisible( file.battlePassNextRewardButton, false )

	foreach ( var button in file.rewardButtonArray )
		Hud_SetVisible( button, false )

	                                 
	file.buttonToRewardTable.clear()

	file.postGameUpdateComplete = false
}


void function RewardButton_OnClick( var button )
{
	if ( !file.postGameUpdateComplete )
		return

	if ( button in file.buttonToRewardTable )
	{
		BattlePassReward rewardData = file.buttonToRewardTable[ button ]

		SetChallengeRewardPresentationModeActive( rewardData.flav, rewardData.quantity, -1, "#CHALLENGE_REWARD", "", true )
	}
}


void function OnPostGameBattlePassMenu_Hide()
{
	if ( file.buttonsRegistered )
	{
		DeregisterButtonPressedCallback( BUTTON_A, OnContinue_Activate )
		DeregisterButtonPressedCallback( KEY_SPACE, OnContinue_Activate )
		file.buttonsRegistered = false
	}

	if ( !file.postGameUpdateComplete )
		Signal( uiGlobal.signalDummy, "ShowBPSummary" )
}


void function OnContinue_Activate( var button )
{
	if ( GetActiveMenu() == file.menu )
		CloseActiveMenu()
}

  
             
                              
 
	                         
		      

	                           
 
  