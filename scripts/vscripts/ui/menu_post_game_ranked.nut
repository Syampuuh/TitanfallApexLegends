global function InitPostGameRankedMenu
global function OpenRankedSummary

const string POSTGAME_LINE_ITEM = "UI_Menu_MatchSummary_Ranked_XPBreakdown"
const string POSTGAME_XP_INCREASE = "UI_Menu_MatchSummary_Ranked_XPBar_Increase"
                                                                                   
const float PROGRESS_BAR_FILL_TIME = 5.0
const float PROGRESS_BAR_FILL_TIME_FAST = 2.0
const float LINE_DISPLAY_TIME = 0.75

struct
{
	var  menu
	var  continueButton
	var  menuHeaderRui
	bool showQuickVersion
	bool skippableWaitSkipped = false
	bool disableNavigateBack = true
	bool isFirstTime = false
	bool buttonsRegistered = false
	bool canUpdateXPBarEmblem = false
	var  barRuiToUpdate = null
} file

struct scoreLine
{
	string keyString = ""
	string valueString = ""
	vector color = <1,1,1>
	float  alpha = 1.0
	float rowHeight = 1.0
}

void function InitPostGameRankedMenu( var newMenuArg )                                               
{
	var menu = GetMenu( "PostGameRankedMenu" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnPostGameRankedMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnPostGameRankedMenu_Close )

	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnPostGameRankedMenu_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, OnPostGameRankedMenu_Hide )

	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnNavigateBack )

	file.continueButton = Hud_GetChild( menu, "ContinueButton" )

	Hud_AddEventHandler( file.continueButton, UIE_CLICK, OnContinue_Activate )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE", null, CanNavigateBack )
	AddMenuFooterOption( menu, LEFT, BUTTON_BACK, true, "", "", CloseRankedSummary, CanNavigateBack )

	RegisterSignal( "OnPostGameRankedMenu_Close" )


	file.menuHeaderRui = Hud_GetRui( Hud_GetChild( menu, "MenuHeader" ) )

	RuiSetString( file.menuHeaderRui, "menuName", "#MATCH_SUMMARY" )
}

void function OnPostGameRankedMenu_Open()
{
	Hud_Hide( Hud_GetChild( file.menu, "RewardDisplay" ) )
	Hud_Show( Hud_GetChild( file.menu, "BlackOut" ) )
	AddCallbackAndCallNow_UserInfoUpdated( Ranked_OnUserInfoUpdatedInPostGame )
}

void function OnPostGameRankedMenu_Show()
{
	thread _Show()
}

void function _Show()
{
	Signal( uiGlobal.signalDummy, "OnPostGameRankedMenu_Close" )
	EndSignal( uiGlobal.signalDummy, "OnPostGameRankedMenu_Close" )

	if ( !IsFullyConnected() )
		return

	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )

	float maxTimeToWaitForLoadScreen = UITime() + LOADSCREEN_FINISHED_MAX_WAIT_TIME
	while(  UITime() < maxTimeToWaitForLoadScreen && !IsLoadScreenFinished()  )                                                                                         
		WaitFrame()

	bool isFirstTime = GetPersistentVarAsInt( "showGameSummary" ) != 0
	if ( isFirstTime && TryOpenSurvey( eSurveyType.POSTGAME ) )
	{
		while ( IsDialog( GetActiveMenu() ) )
			WaitFrame()
	}

	Hud_Hide( Hud_GetChild( file.menu, "BlackOut" ) )

	var rui = Hud_GetRui( Hud_GetChild( file.menu, "SummaryBox" ) )
	RuiSetString( rui, "titleText", "#RANKED_TITLE" )

	ItemFlavor ornull rankedPeriod = GetActiveRankedPeriodByType( GetUnixTimestamp(), eItemType.calevent_rankedperiod )
	if ( rankedPeriod != null )
	{
		expect ItemFlavor( rankedPeriod )
		RuiSetString( rui, "subTitleText", ItemFlavor_GetShortName( rankedPeriod ) )
	}
	else
	{
		RuiSetString( rui, "subTitleText", "#RANKED_OFF_SEASON_SUBTITLE" )
	}

	var hudElem = Hud_GetChild( file.menu, "RankedProgressBar" )
	var barRui = Hud_GetRui( hudElem )
	RuiSetGameTime( barRui, "animStartTime", RUI_BADGAMETIME )

	RuiSetGameTime( Hud_GetRui( Hud_GetChild( file.menu, "XPEarned1" ) ), "startTime", ClientTime() + 999999 )


	if ( !file.buttonsRegistered )
	{
		RegisterButtonPressedCallback( BUTTON_A, OnContinue_Activate )
		RegisterButtonPressedCallback( KEY_SPACE, OnContinue_Activate )
		file.buttonsRegistered = true
	}

	var matchRankRui = Hud_GetRui( Hud_GetChild( file.menu, "MatchRank" ) )
	PopulateMatchRank( matchRankRui )

	thread AnimateXPBar( file.isFirstTime )
}

void function AnimateXPBar( bool isFirstTime )
{

	#if DEV
		printf ("RANKED DEBUG: AnimateXPBarStart***** " )
	#endif

	EndSignal( uiGlobal.signalDummy, "OnPostGameRankedMenu_Close" )

	file.canUpdateXPBarEmblem = false

	entity player                         = GetLocalClientPlayer()
	int score                             = GetPlayerRankScore( player )
	int ladderPosition                    = Ranked_GetLadderPosition( player )
	                                                                       
	SharedRankedDivisionData currentRank  = GetCurrentRankedDivisionFromScoreAndLadderPosition( score, ladderPosition )
	int previousScore                     = expect int( GetRankedPersistenceData( player, "previousRankedScore" ) )
	SharedRankedDivisionData previousRank = GetCurrentRankedDivisionFromScore( previousScore )                                                                                                                         

	bool previousGameWasAbandonded = expect bool( GetPersistentVar( "lastGameRankedAbandon" ) )

	bool tierDemotion = (currentRank.index < previousRank.index) && (currentRank.tier != previousRank.tier)                                 
	bool wasNetDecreaseInRankedScore = previousScore >= score
	bool quick                       = !isFirstTime
	file.disableNavigateBack = !quick
	file.showQuickVersion = quick

	#if DEV
		printf ("RANKED DEBUG: ladderPosition: " + ladderPosition )
		printf ("RANKED DEBUG: currentScore: " + score  + " index: " + currentRank.index )
		printf ("RANKED DEBUG: previousScore:" + previousScore + " index: " + previousRank.index )
		printf ("RANKED DEBUG: previousGameWasAbandonded:" + previousGameWasAbandonded )
		printf ("RANKED DEBUG: tierDemotion:" + tierDemotion )
		printf ("RANKED DEBUG: wasNetDecreaseInRankedScore:" + wasNetDecreaseInRankedScore )
		printf ("RANKED DEBUG: quick: " + quick )
	#endif

	Hud_Show( file.continueButton )

	var rui = Hud_GetRui( Hud_GetChild( file.menu, "XPEarned1" ) )
	if ( IsRankedInSeason()  )
		RuiSetString( rui, "headerText", "#RANKED_TITLE_SCORE_REPORT" )
	else
		RuiSetString( rui, "headerText", "#RANKED_OFF_SEASON_TITLE_SCORE_REPORT" )

	if ( previousGameWasAbandonded )
		RuiSetString( rui, "headerText", "#RANKED_TITLE_ABANDON" )

	int entryCost = expect int ( GetRankedPersistenceData( player, "lastGameEntryCost" ) )

	int placement                 = GetPersistentVarAsInt( "lastGameRank" )
	int numKills                  = GetXPEventCount( player, eXPType.KILL )
	int numAssists                = expect int ( GetRankedPersistenceData( player, "lastGameAssistCount" ) )




	                     
	array < scoreLine > scoreLines

	                                                                                                
	scoreLine entryCostLine
	if ( previousRank.isLadderOnlyDivision || GetNextRankedDivisionFromScore( previousScore ) == null  )
	{
		entryCostLine.keyString = Localize( "#RANKED_ENTRY_COST", Localize( "#RANKED_ENTRY_COST_MASTER_APEX_PREDATOR" ) )
	}
	else
	{
		entryCostLine.keyString = Localize( "#RANKED_ENTRY_COST", Localize( previousRank.tier.name ) )
	}

	entryCostLine.valueString = string( entryCost )
	scoreLines.append( entryCostLine )

	                                                                                               
	scoreLine placementLine

	int placementScore = expect int( GetRankedPersistenceData( player, "lastGamePlacementScore" ) )
	placementLine.keyString = Localize( "#RANKED_MATCH_PLACEMENT" , placement )
	placementLine.valueString = previousGameWasAbandonded ? Localize( "#RANKED_SCORE_ABANDON", placementScore ) : string ( placementScore )

	scoreLines.append( placementLine )

	                                                                                                       

	scoreLine killScoreLine

	int numParticipation          = expect int ( GetRankedPersistenceData( player, "lastGameParticipationCount" ) )
	int killScore 				  = expect int ( GetRankedPersistenceData( player, "lastGameKillScore" ) )

	int pointsPerKillForPlacement = Ranked_GetPointsPerKillForPlacement( placement )

	int tierCount = Ranked_GetTiers().len()
	array<int> killsAssistsTier
	array<int> participationTier

	for (int i = 0 ; i < tierCount; i ++)
	{
		killsAssistsTier.append( GetPersistentVarAsInt("lastGameKillsAssistsCountByTier["+i+"]"))
		participationTier.append (GetPersistentVarAsInt("lastGameParticipationCountByTier["+i+"]"))
	}


	killScoreLine.keyString += Localize ( "#RANKED_KILL_RP_HEADER" , Ranked_GetPointsForKillsPlacement (placement) )

	string killsAssistsString = Localize( "#RANKED_KILL_SCORE_MULTI", numKills, numAssists )

	float additionalLineCount = 0
	int k = 0
	for (int i = 0 ; i < killsAssistsTier.len(); i++){
		if (killsAssistsTier[i] > 0)
		{
			k++
			if ( k == 5 || k == 1 )
			{
				k++
				additionalLineCount += 0.5

				killsAssistsString += "`2\n"
			}
			killsAssistsString += "   "
			killsAssistsString += Localize( "#RANKED_KILL_SCORE_" + i , killsAssistsTier[i])
		}
	}

	killsAssistsString += Localize( "#RANKED_KILL_SCORE_MULTI_2", numParticipation )

	k = 0
	for (int i = 0 ; i < participationTier.len(); i++){
		if (participationTier[i] > 0)
		{
			k++
			if ( k == 5 || k == 1 )
			{
				k++
				additionalLineCount += 0.5

				killsAssistsString += "`2\n"
			}
			killsAssistsString += "   "
			killsAssistsString += Localize( "#RANKED_KILL_SCORE_" + i , participationTier[i])
		}
	}
	printt("additionalLineCount", additionalLineCount)
	killScoreLine.keyString += killsAssistsString
	killScoreLine.rowHeight = 2.45 + additionalLineCount

	string killScoreString = previousGameWasAbandonded ? Localize( "#RANKED_SCORE_ABANDON", killScore ) : string ( killScore )
	killScoreLine.valueString = killScoreString

	scoreLines.append( killScoreLine )
	bool rankForgiveness = expect bool( GetPersistentVar( "lastGameRankedForgiveness" ) ) || expect bool( GetPersistentVar( "lastGameAbandonForgiveness" ) )
	Assert( !( previousGameWasAbandonded &&  rankForgiveness )  )                                                  

	int lastGameLossProtectionAdjustment = expect int ( GetRankedPersistenceData( player, "lastGameLossProtectionAdjustment" ) )
	if ( rankForgiveness && lastGameLossProtectionAdjustment != 0  )
	{
		scoreLine lossForgivenLine
		lossForgivenLine.keyString =  "#RANKED_FORGIVENESS"
		lossForgivenLine.valueString = string( lastGameLossProtectionAdjustment )
		scoreLines.append(lossForgivenLine)
	}
	else if ( previousGameWasAbandonded  )
	{
		int abandonPenalty = expect int( GetRankedPersistenceData( player, "lastGamePenaltyPointsForAbandoning" ) )

		scoreLine abandonPenalityLine
		abandonPenalityLine.keyString = "#RANKED_ABANDON_PENALTY"
		abandonPenalityLine.valueString = Localize( "#RANKED_SCORE_ABANDON", abandonPenalty )
		scoreLines.append(abandonPenalityLine)
	}

	int tierDerankingProtectionAdjustment = expect int (GetRankedPersistenceData( player, "lastGameTierDerankingProtectionAdjustment" ) )
	bool wasPromoted = currentRank.index > previousRank.index && ( !previousRank.isLadderOnlyDivision ) && score > previousScore

	if ( tierDerankingProtectionAdjustment > 0  )                                           
	{

		if ( tierDemotion )           
		{
			scoreLine abandonLine
			abandonLine.keyString = "#RANKED_TIER_DERANKING"
			abandonLine.valueString = string( score - previousScore + tierDerankingProtectionAdjustment)
			scoreLines.append(abandonLine)
		}
		else if ( wasPromoted )            
		{
			scoreLine promoteLine
			promoteLine.keyString = "#RANKED_TIER_PROMOTION_BONUS"
			promoteLine.valueString =  string( tierDerankingProtectionAdjustment )
			scoreLines.append(promoteLine)
		}
		else                      
		{
			scoreLine tierDemotionLine
			tierDemotionLine.keyString = "#RANKED_TIER_DERANKING_PROTECTION"
			tierDemotionLine.valueString =  string( tierDerankingProtectionAdjustment )
			scoreLines.append(tierDemotionLine)
		}
	}


	                       
	for (int i = 0 ; i < scoreLines.len(); i++)
	{
		RuiSetString ( rui, "line" + string ( i+1 ) + "KeyString", scoreLines[i].keyString )
		RuiSetString ( rui, "line" + string ( i+1 ) + "ValueString", scoreLines[i].valueString )
		RuiSetColorAlpha ( rui, "line" + string ( i+1 ) + "Color", scoreLines[i].color, scoreLines[i].alpha	 )
		RuiSetFloat ( rui, "line" + string ( i+1 ) + "RowHeight" , scoreLines[i].rowHeight )
	}
	                                                                                   

	RuiSetFloat( rui, "lineDisplayTime", LINE_DISPLAY_TIME )
	RuiSetFloat( rui, "startDelay", 0.0 )
	RuiSetGameTime( rui, "startTime", ClientTime() + 0.5 )

	int numLines = scoreLines.len()
	RuiSetInt( rui, "numLines", numLines )

	var scoreAdjustElem = Hud_GetChild( file.menu, "RankedScoreAdjustment" )
	var scoreAdjustRui = Hud_GetRui( scoreAdjustElem )
	var hudElem = Hud_GetChild( file.menu, "RankedProgressBar" )
	var barRui = Hud_GetRui( hudElem )
	RuiSetBool( barRui, "showPointsProgress", true )
	RuiSetGameTime( barRui, "animStartTime", RUI_BADGAMETIME )

	int adjust = 0
	if ( numLines == 4 )
		adjust = 15
	else if ( numLines == 5 )
		adjust = 30

	Hud_SetY( scoreAdjustElem, Hud_GetBaseY( scoreAdjustElem ) + adjust )

	int scoreAdjust = score-previousScore
	RuiSetInt( scoreAdjustRui, "scoreAdjustment", scoreAdjust )

	bool wasDemoted = currentRank.index < previousRank.index && ( !previousRank.isLadderOnlyDivision )

	bool isDemotionProtected = tierDerankingProtectionAdjustment > 0 && !wasDemoted && !rankForgiveness && !wasPromoted && currentRank.tier.allowsDemotion

	#if DEV
		printf ("RANKED DEBUG: tierDerankingProtectionAdjustment: " + tierDerankingProtectionAdjustment )
		printf ("RANKED DEBUG: isDemotionProtected: " + isDemotionProtected )
		printf ("RANKED DEBUG: wasDemoted: " + wasDemoted )
		printf ("RANKED DEBUG: rankForgiveness: " + rankForgiveness )
		printf ("RANKED DEBUG: wasPromoted: " + wasPromoted )
	#endif


	RuiSetBool( scoreAdjustRui, "demoted", wasDemoted)
	RuiSetBool( scoreAdjustRui, "inSeason", IsRankedInSeason() )

	if ( wasDemoted )
	{
		RuiSetString( scoreAdjustRui, "demotedRank", currentRank.divisionName )
	}

	if ( quick || wasNetDecreaseInRankedScore )
		InitRankedScoreBarRuiForDoubleBadge( barRui, score, ladderPosition )
	      
		                                                                              

	var demotionHudElem = Hud_GetChild( file.menu, "RankedDemotionProtection" )
	var protectionRui = Hud_GetRui( demotionHudElem )

	RuiDestroyNestedIfAlive( protectionRui, "rankedBadgeHandle0")
	CreateNestedRankedRui( protectionRui, currentRank.tier, "rankedBadgeHandle0", score, ladderPosition )

	                                                                                                                    
	SharedRankedTierData currentTier     = currentRank.tier
	RuiSetImage( protectionRui, "rankedIcon" , currentTier.icon )
	RuiSetString( protectionRui, "emblemText" , currentRank.emblemText )
	RuiSetInt ( protectionRui, "protectionCurrent" , GetDemotionProtectionBuffer ( player ) )
	SharedRanked_FillInRuiEmblemText( protectionRui, currentRank, score, ladderPosition  )

	#if DEV
		printf ("RANKED DEBUG: protectionCurrent: " + GetDemotionProtectionBuffer ( player ) )
	#endif


	if ( currentTier.isLadderOnlyTier  )                                                        
	{
		SharedRankedDivisionData scoreDivisionData = GetCurrentRankedDivisionFromScore( score )
		SharedRankedTierData scoreCurrentTier      = scoreDivisionData.tier
		RuiSetInt( protectionRui, "currentTierColorOffset", scoreCurrentTier.index + 1 )
	}
	else
	{
		RuiSetInt( protectionRui, "currentTierColorOffset", currentTier.index )
	}

	Hud_Hide( hudElem )
	Hud_Hide( scoreAdjustElem )
	Hud_Hide ( demotionHudElem )



	OnThreadEnd(
		function () : ( hudElem ,demotionHudElem , isDemotionProtected  )
		{
			Hud_Hide( Hud_GetChild( file.menu, "RewardDisplay" ) )
			Hud_Hide( Hud_GetChild( file.menu, "MovingBoxBG" ) )
			if (isDemotionProtected)
			{
				Hud_Show( demotionHudElem )
			}
			else
			{
				Hud_Show( hudElem )
			}
			file.disableNavigateBack = false
			file.canUpdateXPBarEmblem = true
			UpdateFooterOptions()
			StopUISoundByName( POSTGAME_XP_INCREASE )
		}
	)

	ResetSkippableWait()

	for ( int lineIndex = 0; lineIndex < numLines; lineIndex++ )
	{
		if ( IsSkippableWaitSkipped() )
			continue

		waitthread SkippableWait( LINE_DISPLAY_TIME, POSTGAME_LINE_ITEM )
	}

	RuiSetFloat( rui, "startDelay", -50.0 )
	RuiSetGameTime( rui, "startTime", ClientTime() - 9999.0 )

	Hud_Show( scoreAdjustElem )

	ResetSkippableWait()
	waitthread SkippableWait( LINE_DISPLAY_TIME, "UI_Menu_MatchSummary_Ranked_XPTotal" )

	if (isDemotionProtected)
	{
		Hud_Show( demotionHudElem )
	}
	else
	{
		Hud_Show( hudElem )
	}

	                                                                                                                                         
	int ranksToPopulate = ( currentRank.index - previousRank.index ) + 1                                                            
	if ( ranksToPopulate > 1 && currentRank.isLadderOnlyDivision )                                  
	{
		if( GetNextRankedDivisionFromScore( previousScore ) == null  )                                                                                                                  
			ranksToPopulate = 1
		else
			ranksToPopulate = 2                                          

	}

	int scoreStart = previousScore

	ladderPosition = Ranked_GetLadderPosition( GetLocalClientPlayer() )                                                                                                      
	                                                                                          

	if  (!quick && !wasNetDecreaseInRankedScore && !wasDemoted )                                                                            
	{
		InitRankedScoreBarRuiForDoubleBadge( barRui, scoreStart, ladderPosition )
		float delay = 0.25
		wait delay

		for ( int index = 0; index < ranksToPopulate; index++ )
		{
			file.canUpdateXPBarEmblem         = false                                                                        
			SharedRankedDivisionData rd_start = GetCurrentRankedDivisionFromScoreAndLadderPosition( scoreStart, ladderPosition )
			SharedRankedTierData startingTier = rd_start.tier
			SharedRankedDivisionData ornull nextDivision

			nextDivision = GetNextRankedDivisionFromScore( scoreStart )                                                                         

			int scoreEnd = scoreStart

			if ( nextDivision != null )
			{
				InitRankedScoreBarRuiForDoubleBadge( barRui, scoreStart, ladderPosition )
				expect SharedRankedDivisionData( nextDivision )
				SharedRankedTierData nextDivisionTier = nextDivision.tier

				scoreEnd = minint( score, nextDivision.scoreMin )

				float frac = float( abs( scoreEnd - scoreStart ) ) / float( abs( nextDivision.scoreMin - rd_start.scoreMin ) )   
				float animDuration = 2.0 * frac

				RuiSetGameTime( barRui, "animStartTime", ClientTime() + delay )
				RuiSetFloat( barRui, "animDuration", animDuration )                                                                                                                                                            
				RuiSetInt( barRui, "currentScore", scoreEnd )
				RuiSetInt( barRui, "animStartScore", scoreStart )

				waitthread SkippableWait( animDuration + 0.1, POSTGAME_XP_INCREASE )
				StopUISoundByName( POSTGAME_XP_INCREASE )

				if ( (index < ranksToPopulate -1 ) && isFirstTime )
				{
					wait 0.1

					Hud_Show( Hud_GetChild( file.menu, "MovingBoxBG" ) )
					Hud_Show( Hud_GetChild( file.menu, "RewardDisplay" ) )
					var rewardDisplayRui = Hud_GetRui( Hud_GetChild( file.menu, "RewardDisplay" ) )
					RuiDestroyNestedIfAlive( rewardDisplayRui, "levelUpAnimHandle" )

					float RANK_UP_TIME = 3.5

					if ( startingTier != nextDivisionTier )
					{
						if ( GetNextRankedDivisionFromScore( score ) == null )                                                                                      
						{
							ladderPosition = Ranked_GetLadderPosition( GetLocalClientPlayer() )
							                                                                                         
						}

						SharedRankedDivisionData promotedDivisionData = GetCurrentRankedDivisionFromScoreAndLadderPosition( score, ladderPosition )
						SharedRankedTierData promotedTierData         = promotedDivisionData.tier                                                                                   
						asset levelupRuiAsset                         = startingTier.levelUpRuiAsset

						                                                              
						if ( GetNextRankedDivisionFromScore( score ) == null )                                                                              
						{
							if ( !promotedDivisionData.isLadderOnlyDivision )
								levelupRuiAsset = promotedTierData.levelUpRuiAsset                                                        
						}

						var nestedRuiHandle = RuiCreateNested( rewardDisplayRui, "levelUpAnimHandle", levelupRuiAsset )

						RuiSetGameTime( nestedRuiHandle, "startTime", ClientTime() )
						RuiSetImage( nestedRuiHandle, "oldRank", startingTier.icon )
						RuiSetImage( nestedRuiHandle, "newRank", promotedTierData.icon )

						string sound = "UI_Menu_MatchSummary_Ranked_Promotion"
						if ( Ranked_GetNextTierData( nextDivisionTier ) == null )
							sound = "UI_Menu_MatchSummary_Ranked_PromotionApex"                                                            

						if ( nextDivisionTier.promotionAnnouncement != "" )
							PlayLobbyCharacterDialogue(  promotedTierData.promotionAnnouncement, 1.6  )

						EmitUISound( sound )
					}
					else
					{
						var nestedRuiHandle = RuiCreateNested( rewardDisplayRui, "levelUpAnimHandle", $"ui/rank_division_up_anim.rpak" )
						RuiSetGameTime( nestedRuiHandle, "startTime", ClientTime() )
						RuiSetString( nestedRuiHandle, "oldDivision", Localize(rd_start.emblemText))
						RuiSetString( nestedRuiHandle, "newDivision", Localize(nextDivision.emblemText))
						RuiSetImage( nestedRuiHandle, "rankEmblemImg", startingTier.icon )
						EmitUISound( "UI_Menu_MatchSummary_Ranked_RankUp" )

						PlayLobbyCharacterDialogue( "glad_rankUp", 1.6  )
					}

					wait RANK_UP_TIME + 0.1

					Hud_Hide( Hud_GetChild( file.menu, "MovingBoxBG" ) )
					Hud_Hide( Hud_GetChild( file.menu, "RewardDisplay" ) )
				}

				scoreStart = scoreEnd
			}

			                                                                              
			InitRankedScoreBarRuiForDoubleBadge( barRui, scoreEnd, ladderPosition )
		}

		                                                                                                                                                                
		                                                                                                                                                         

		InitRankedScoreBarRuiForDoubleBadge( barRui, score, Ranked_GetLadderPosition( GetLocalClientPlayer() ) )                                                                                                                                                   
	}

	if ( !quick && wasNetDecreaseInRankedScore && wasDemoted )
	{
		PlayLobbyCharacterDialogue( "glad_rankDown"  )                                       
	}

}

void function InitRankedScoreBarRuiForDoubleBadge( var rui, int score, int ladderPosition )
{
	for ( int i=0; i<5; i++ )
	{
		RuiDestroyNestedIfAlive( rui, "rankedBadgeHandle" + i )
	}

	RuiSetBool( rui, "forceDoubleBadge", true )

	SharedRankedDivisionData currentRank = GetCurrentRankedDivisionFromScoreAndLadderPosition( score, ladderPosition )
	SharedRankedTierData currentTier     = currentRank.tier

	RuiSetGameTime( rui, "animStartTime", RUI_BADGAMETIME )

	if ( currentTier.isLadderOnlyTier  )                                                        
	{
		SharedRankedDivisionData scoreDivisionData = GetCurrentRankedDivisionFromScore( score )
		SharedRankedTierData scoreCurrentTier      = scoreDivisionData.tier
		RuiSetInt( rui, "currentTierColorOffset", scoreCurrentTier.index + 1 )
	}
	else
	{
		RuiSetInt( rui, "currentTierColorOffset", currentTier.index )
	}

	                                    
	RuiSetImage( rui, "icon0" , currentTier.icon )
	RuiSetString( rui, "emblemText0" , currentRank.emblemText )
	RuiSetInt( rui, "badgeScore0", score )
	SharedRanked_FillInRuiEmblemText( rui, currentRank, score, ladderPosition, "0"  )
	CreateNestedRankedRui( rui, currentRank.tier, "rankedBadgeHandle0", score, ladderPosition )
	bool shouldUpdateRuiWithCommunityUserInfo = Ranked_ShouldUpdateWithComnunityUserInfo( score, ladderPosition )
	if ( shouldUpdateRuiWithCommunityUserInfo )
		file.barRuiToUpdate = rui

	RuiSetImage( rui, "icon3" , currentTier.icon )
	RuiSetString( rui, "emblemText3" , currentRank.emblemText )
	RuiSetInt( rui, "badgeScore3", currentRank.scoreMin )
	SharedRanked_FillInRuiEmblemText( rui, currentRank, score, ladderPosition, "3"  )
	CreateNestedRankedRui( rui, currentRank.tier, "rankedBadgeHandle3", score, ladderPosition )

	RuiSetInt( rui, "currentScore" , score )
	RuiSetInt( rui, "startScore" , currentRank.scoreMin )

	SharedRankedDivisionData ornull nextRank = GetNextRankedDivisionFromScore( score )


	RuiSetBool( rui, "showSingleBadge", nextRank == null )

	if ( nextRank != null )
	{		
		expect SharedRankedDivisionData( nextRank )
		SharedRankedTierData nextTier = nextRank.tier

		RuiSetBool( rui, "showSingleBadge", nextRank == currentRank )

		RuiSetInt( rui, "endScore" , nextRank.scoreMin )
		RuiSetString( rui, "emblemText4" , nextRank.emblemText  )
		RuiSetInt( rui, "badgeScore4", nextRank.scoreMin )
		RuiSetImage( rui, "icon4", nextTier.icon )
		RuiSetInt( rui, "nextTierColorOffset", nextTier.index )
		SharedRanked_FillInRuiEmblemText( rui, nextRank, nextRank.scoreMin, SHARED_RANKED_INVALID_LADDER_POSITION, "4"  )
		CreateNestedRankedRui( rui, nextRank.tier, "rankedBadgeHandle4", nextRank.scoreMin, SHARED_RANKED_INVALID_LADDER_POSITION )                                                                                      
	}
}

void function OnPostGameRankedMenu_Close()
{
	file.barRuiToUpdate = null
	RemoveCallback_UserInfoUpdated( Ranked_OnUserInfoUpdatedInPostGame )
}

void function OnContinue_Activate( var button )
{
	file.skippableWaitSkipped = true

	if ( !file.disableNavigateBack )
		CloseRankedSummary( null )

}

void function OnPostGameRankedMenu_Hide()
{
	Signal( uiGlobal.signalDummy, "OnPostGameRankedMenu_Close" )

	if ( file.buttonsRegistered )
	{
		DeregisterButtonPressedCallback( BUTTON_A, OnContinue_Activate )
		DeregisterButtonPressedCallback( KEY_SPACE, OnContinue_Activate )
		file.buttonsRegistered = false
	}
}

void function ResetSkippableWait()
{
	file.skippableWaitSkipped = false
}


bool function IsSkippableWaitSkipped()
{
	return file.skippableWaitSkipped || !file.disableNavigateBack
}


bool function SkippableWait( float waitTime, string uiSound = "" )
{
	if ( IsSkippableWaitSkipped() )
		return false

	if ( uiSound != "" )
		EmitUISound( uiSound )

	float startTime = UITime()
	while ( UITime() - startTime < waitTime )
	{
		if ( IsSkippableWaitSkipped() )
			return false

		WaitFrame()
	}

	return true
}


bool function CanNavigateBack()
{
	return file.disableNavigateBack != true
}


void function OnNavigateBack()
{
	if ( !CanNavigateBack() )
		return

	CloseRankedSummary( null )
}

void function CloseRankedSummary( var button )
{
	if ( GetActiveMenu() == file.menu )
		thread CloseActiveMenu()
}

void function OpenRankedSummary( bool firstTime )
{
	file.isFirstTime = firstTime
	AdvanceMenu( file.menu )
}

void function Ranked_OnUserInfoUpdatedInPostGame( string hardware, string id )
{
	if ( !IsConnected() )
		return

	if ( !IsLobby() )
		return

	if ( hardware == "" && id == "" )
		return

	CommunityUserInfo ornull cui = GetUserInfo( hardware, id )

	if ( cui == null )
		return

	if ( !file.canUpdateXPBarEmblem )                                                                                   
		return

	expect CommunityUserInfo( cui )

	if ( cui.hardware == GetUnspoofedPlayerHardware() && cui.uid == GetPlayerUID() )                                      
	{
		if ( file.barRuiToUpdate != null  )                                                                                                                                
		{
			InitRankedScoreBarRuiForDoubleBadge( file.barRuiToUpdate, cui.rankScore, cui.rankedLadderPos )
		}
	}
}