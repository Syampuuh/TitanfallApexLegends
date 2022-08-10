global function InitPostGameArenasRankedMenu
global function OpenArenasRankedSummary

const string POSTGAME_LINE_ITEM = "UI_Menu_MatchSummary_Ranked_XPBreakdown"
const string POSTGAME_XP_INCREASE = "UI_Menu_MatchSummary_Ranked_XPBar_Increase"
                                                                                   
const float PROGRESS_BAR_FILL_TIME = 5.0
const float PROGRESS_BAR_FILL_TIME_FAST = 2.0
const float LINE_DISPLAY_TIME = 0.75
const float ANIM_DURATION_SCALE = 4.0

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

void function InitPostGameArenasRankedMenu( var newMenuArg )
                                              
{
	var menu = GetMenu( "PostGameArenasRankedMenu" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnPostGameArenasRankedMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnPostGameArenasRankedMenu_Close )

	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnPostGameArenasRankedMenu_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, OnPostGameArenasRankedMenu_Hide )

	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnNavigateBack )

	file.continueButton = Hud_GetChild( menu, "ContinueButton" )

	Hud_AddEventHandler( file.continueButton, UIE_CLICK, OnContinue_Activate )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE", null, CanNavigateBack )
	AddMenuFooterOption( menu, LEFT, BUTTON_BACK, true, "", "", CloseArenasRankedSummary, CanNavigateBack )

	RegisterSignal( "OnPostGameArenasRankedMenu_Close" )


	file.menuHeaderRui = Hud_GetRui( Hud_GetChild( menu, "MenuHeader" ) )

	RuiSetString( file.menuHeaderRui, "menuName", "#MATCH_SUMMARY" )
}


void function OnPostGameArenasRankedMenu_Open()
{
	Hud_Hide( Hud_GetChild( file.menu, "RewardDisplay" ) )
	Hud_Show( Hud_GetChild( file.menu, "BlackOut" ) )
	AddCallbackAndCallNow_UserInfoUpdated( ArenasRanked_OnUserInfoUpdatedInPostGame )
}


void function OnPostGameArenasRankedMenu_Show()
{
	thread _Show()
}

void function _Show()
{
	Signal( uiGlobal.signalDummy, "OnPostGameArenasRankedMenu_Close" )
	EndSignal( uiGlobal.signalDummy, "OnPostGameArenasRankedMenu_Close" )

	if ( !IsFullyConnected() )
		return

	UI_SetPresentationType( ePresentationType.ARENAS_RANKED )

	float maxTimeToWaitForLoadScreen = UITime() + LOADSCREEN_FINISHED_MAX_WAIT_TIME
	while( UITime() < maxTimeToWaitForLoadScreen && !IsLoadScreenFinished() )                                                                                         
		WaitFrame()

	bool isFirstTime = GetPersistentVarAsInt( "showGameSummary" ) != 0
	if ( isFirstTime && TryOpenSurvey( eSurveyType.POSTGAME ) )
	{
		while ( IsDialog( GetActiveMenu() ) )
			WaitFrame()
	}

	Hud_Hide( Hud_GetChild( file.menu, "BlackOut" ) )

	var rui = Hud_GetRui( Hud_GetChild( file.menu, "SummaryBox" ) )
	RuiSetString( rui, "titleText", "#ARENAS_RANKED_TITLE" )

	ItemFlavor ornull arenasRankedPeriod = GetActiveRankedPeriodByType( GetUnixTimestamp(), eItemType.calevent_arenas_ranked_period )
	if ( arenasRankedPeriod != null )
	{
		expect ItemFlavor( arenasRankedPeriod )
		RuiSetString( rui, "subTitleText", ItemFlavor_GetShortName( arenasRankedPeriod ) )
	}
	else
	{
		RuiSetString( rui, "subTitleText", "#RANKED_OFF_SEASON_SUBTITLE" )
	}

	var hudElem = Hud_GetChild( file.menu, "ArenasRankedProgressBar" )
	var barRui  = Hud_GetRui( hudElem )
	RuiSetGameTime( barRui, "animStartTime", RUI_BADGAMETIME )

	                                                                                                            

	if ( !file.buttonsRegistered )
	{
		RegisterButtonPressedCallback( BUTTON_A, OnContinue_Activate )
		RegisterButtonPressedCallback( KEY_SPACE, OnContinue_Activate )
		file.buttonsRegistered = true
	}

	var matchRankRui = Hud_GetRui( Hud_GetChild( file.menu, "MatchArenasRank" ) )
	PopulateMatchRank( matchRankRui )

	thread AnimateXPBar( file.isFirstTime )
}


void function AnimateXPBar( bool isFirstTime )
{
	EndSignal( uiGlobal.signalDummy, "OnPostGameArenasRankedMenu_Close" )
	EndSignal( uiGlobal.signalDummy, "LevelShutdown" )

	file.canUpdateXPBarEmblem = false

	entity player                               = GetLocalClientPlayer()
	int score                                   = GetPlayerArenasRankScore( player )
	int ladderPosition                          = ArenasRanked_GetLadderPosition( GetLocalClientPlayer() )
	int previousScore                           = expect int( GetArenasRankedPersistenceData( player, "previousArenasRankedScore" ) )

	                                                                       
	SharedRankedDivisionData currentArenasRank  = GetCurrentArenasRankedDivisionFromScoreAndLadderPosition( score, ladderPosition )
	SharedRankedDivisionData previousArenasRank = GetCurrentArenasRankedDivisionFromScore( previousScore )                                                                                                                         

	bool previousGameWasAbandonded = expect bool( GetPersistentVar( "lastGameRankedAbandon" ) )

	bool lastPlacementMatch = previousScore == ARENAS_RANKED_PLACEMENT_SCORE && score >= ARENAS_RANKED_MIN_SCORE
	bool wasNetDecreaseInArenasRankedScore = previousScore >= score
	bool quick                       = !isFirstTime
	file.disableNavigateBack = !quick
	file.showQuickVersion    = quick

	Hud_Show( file.continueButton )

	var xpEarnedRui = Hud_GetRui( Hud_GetChild( file.menu, "XPEarned1" ) )
	if ( IsArenasRankedInSeason() )
	{
		if( previousScore >= ARENAS_RANKED_MIN_SCORE )
			RuiSetString( xpEarnedRui, "headerText", "#RANKED_TITLE_SCORE_REPORT" )
		else
			RuiSetString( xpEarnedRui, "headerText", "#ARENAS_RANKED_PLACEMENT_HEADER" )
	}
	else
		RuiSetString( xpEarnedRui, "headerText", "#RANKED_OFF_SEASON_TITLE_SCORE_REPORT" )

	if ( previousGameWasAbandonded )
		RuiSetString( xpEarnedRui, "headerText", "#RANKED_TITLE_ABANDON" )

	var scoreAdjustElem = Hud_GetChild( file.menu, "ArenasRankedScoreAdjustment" )
	var scoreAdjustRui  = Hud_GetRui( scoreAdjustElem )
	var hudElem         = Hud_GetChild( file.menu, "ArenasRankedProgressBar" )
	var barRui          = Hud_GetRui( hudElem )
	RuiSetBool( barRui, "showPointsProgress", true )
	RuiSetGameTime( barRui, "animStartTime", RUI_BADGAMETIME )
	RuiSetBool( barRui, "inPlacement", previousScore == ARENAS_RANKED_PLACEMENT_SCORE )
	RuiSetBool( barRui, "lastPlacementMatch", lastPlacementMatch )

	int adjust = 0
  
	                    
		           
	                         
		           
  

	const float ruiScreenHeight = 1080.0
	UISize screen		= GetScreenSize()
	float yScale		= screen.height / ruiScreenHeight

	int progressBarYOffset = previousScore >= ARENAS_RANKED_MIN_SCORE ? 0 : int(-125.0 * yScale)
	Hud_SetY( hudElem, Hud_GetBaseY( hudElem ) + progressBarYOffset )
	Hud_SetY( scoreAdjustElem, Hud_GetBaseY( scoreAdjustElem ) + adjust )

	int scoreAdjust = score - previousScore
	RuiSetInt( scoreAdjustRui, "scoreAdjustment", scoreAdjust )

	bool wasDemoted = currentArenasRank.index < previousArenasRank.index && (!previousArenasRank.isLadderOnlyDivision)

	RuiSetBool( scoreAdjustRui, "demoted", wasDemoted )
	RuiSetBool( scoreAdjustRui, "inSeason", IsArenasRankedInSeason() )
	RuiSetBool( scoreAdjustRui, "inPlacement", previousScore == ARENAS_RANKED_PLACEMENT_SCORE )
	RuiSetBool( scoreAdjustRui, "lastPlacementMatch", lastPlacementMatch )

	if ( wasDemoted )
	{
		RuiSetString( scoreAdjustRui, "demotedRank", currentArenasRank.divisionName )
	}

	if ( quick || wasNetDecreaseInArenasRankedScore )
		InitArenasRankedScoreBarRuiForDoubleBadge( barRui, score, ladderPosition )
	else if ( lastPlacementMatch )
		InitArenasRankedScoreBarRuiForDoubleBadge( barRui, previousScore, ladderPosition )


	if ( !lastPlacementMatch )
		Hud_Hide( hudElem )
	Hud_Hide( scoreAdjustElem )

	OnThreadEnd(
		function () : ( hudElem )
		{
			Hud_Hide( Hud_GetChild( file.menu, "RewardDisplay" ) )
			Hud_Hide( Hud_GetChild( file.menu, "MovingBoxBG" ) )
			Hud_Show( hudElem )
			file.disableNavigateBack  = false
			file.canUpdateXPBarEmblem = true
			UpdateFooterOptions()
			StopUISoundByName( POSTGAME_XP_INCREASE )
		}
	)

	ResetSkippableWait()

	Hud_Show( scoreAdjustElem )

	ResetSkippableWait()
	waitthread SkippableWait( LINE_DISPLAY_TIME, "UI_Menu_MatchSummary_Ranked_XPTotal" )

	Hud_Show( hudElem )
	                                                                                                                                         
	int arenasRanksToPopulate = (currentArenasRank.index - previousArenasRank.index) + 1                                                            
	if ( arenasRanksToPopulate > 1 && currentArenasRank.isLadderOnlyDivision )                                  
	{
		if ( GetNextArenasRankedDivisionFromScore( previousScore ) == null )                                                                                                                  
			arenasRanksToPopulate = 1
		else
			arenasRanksToPopulate = 2                                          
	}

	int scoreStart = previousScore

	ladderPosition = ArenasRanked_GetLadderPosition( GetLocalClientPlayer() )                                                                                                      
	                                                                                          

	if ( !quick && !wasDemoted )                                                                            
	{
		InitArenasRankedScoreBarRuiForDoubleBadge( barRui, scoreStart, ladderPosition )
		float delay = 0.25
		wait delay

		for ( int index = 0; index < arenasRanksToPopulate; index++ )
		{
			file.canUpdateXPBarEmblem         = false                                                                        
			SharedRankedDivisionData rd_start = GetCurrentArenasRankedDivisionFromScoreAndLadderPosition( scoreStart, ladderPosition )
			SharedRankedTierData startingTier = rd_start.tier
			SharedRankedDivisionData ornull nextDivision

			if( lastPlacementMatch )
				nextDivision = GetNextArenasRankedDivisionFromScore( score )
			else
				nextDivision = GetNextArenasRankedDivisionFromScore( scoreStart )                                                                         

			int scoreEnd = scoreStart

			if ( nextDivision != null )
			{
				InitArenasRankedScoreBarRuiForDoubleBadge( barRui, scoreStart, ladderPosition )
				expect SharedRankedDivisionData( nextDivision )
				SharedRankedTierData nextDivisionTier = nextDivision.tier

				scoreEnd = minint( score, nextDivision.scoreMin )

				float maxScoreDelta	= float( abs( nextDivision.scoreMin - rd_start.scoreMin ) )
				float frac			= fabs( maxScoreDelta - 0.0 ) < FLT_EPSILON ? 0.0 : float( abs( scoreEnd - scoreStart ) ) / maxScoreDelta
				float animDuration	= ANIM_DURATION_SCALE * frac

				if( !lastPlacementMatch )
				{
					RuiSetGameTime( barRui, "animStartTime", ClientTime() + delay )
					RuiSetFloat( barRui, "animDuration", animDuration )                                                                                                                                                            
					RuiSetInt( barRui, "currentScore", scoreEnd )
					RuiSetInt( barRui, "animStartScore", scoreStart )
				}

				waitthread SkippableWait( animDuration + 0.1, POSTGAME_XP_INCREASE )
				StopUISoundByName( POSTGAME_XP_INCREASE )

				if ( (index < arenasRanksToPopulate - 1) && isFirstTime )
				{
					wait 0.1

					Hud_Show( Hud_GetChild( file.menu, "MovingBoxBG" ) )
					Hud_Show( Hud_GetChild( file.menu, "RewardDisplay" ) )
					var rewardDisplayRui = Hud_GetRui( Hud_GetChild( file.menu, "RewardDisplay" ) )
					RuiDestroyNestedIfAlive( rewardDisplayRui, "levelUpAnimHandle" )

					float RANK_UP_TIME = 3.5

					if ( startingTier != nextDivisionTier )
					{
						if ( GetNextArenasRankedDivisionFromScore( score ) == null )                                                                                      
						{
							ladderPosition = ArenasRanked_GetLadderPosition( GetLocalClientPlayer() )
							                                                                                         
						}

						SharedRankedDivisionData promotedDivisionData = GetCurrentArenasRankedDivisionFromScoreAndLadderPosition( score, ladderPosition )
						SharedRankedTierData promotedTierData         = promotedDivisionData.tier                                                                                   
						asset levelupRuiAsset                         = startingTier.levelUpRuiAsset

						                                                              
						if ( GetNextArenasRankedDivisionFromScore( score ) == null )                                                                              
						{
							if ( !promotedDivisionData.isLadderOnlyDivision )
								levelupRuiAsset = promotedTierData.levelUpRuiAsset                                                        
						}

						var nestedRuiHandle = RuiCreateNested( rewardDisplayRui, "levelUpAnimHandle", levelupRuiAsset )

						RuiSetGameTime( nestedRuiHandle, "startTime", ClientTime() )
						if( startingTier.scoreMin > ARENAS_RANKED_PLACEMENT_SCORE )
							RuiSetImage( nestedRuiHandle, "oldRank", startingTier.icon )
						else
							RuiSetString( nestedRuiHandle, "tierText", Localize( promotedDivisionData.emblemText ) )
						RuiSetImage( nestedRuiHandle, "newRank", promotedTierData.icon )

						string sound = "UI_Menu_MatchSummary_Ranked_Promotion"
						if ( ArenasRanked_GetNextTierData( nextDivisionTier ) == null )
							sound = "UI_Menu_MatchSummary_Ranked_PromotionApex"                                                            

						if ( nextDivisionTier.promotionAnnouncement != "" )
							PlayLobbyCharacterDialogue( promotedTierData.promotionAnnouncement, 1.6 )

						EmitUISound( sound )
					}
					else
					{
						                                                      
						var nestedRuiHandle = RuiCreateNested( rewardDisplayRui, "levelUpAnimHandle", $"ui/rank_division_up_anim.rpak" )
						RuiSetGameTime( nestedRuiHandle, "startTime", ClientTime() )
						RuiSetString( nestedRuiHandle, "oldDivision", Localize( rd_start.emblemText ) )
						RuiSetString( nestedRuiHandle, "newDivision", Localize( nextDivision.emblemText ) )
						RuiSetImage( nestedRuiHandle, "rankEmblemImg", startingTier.icon )
						EmitUISound( "UI_Menu_MatchSummary_Ranked_RankUp" )

						                                                                                                    
						PlayLobbyCharacterDialogue( "glad_rankUp", 1.6 )
					}

					wait RANK_UP_TIME + 0.1

					if( lastPlacementMatch )
					{
						RuiSetString( xpEarnedRui, "headerText", "#RANKED_TITLE_SCORE_REPORT" )
						Hud_SetY( hudElem, Hud_GetBaseY( hudElem ) )
						RuiSetBool( scoreAdjustRui, "inPlacement", false )
					}

					Hud_Hide( Hud_GetChild( file.menu, "MovingBoxBG" ) )
					Hud_Hide( Hud_GetChild( file.menu, "RewardDisplay" ) )

					if ( lastPlacementMatch )
						break
				}

				scoreStart = scoreEnd
			}

			                                                                              
			InitArenasRankedScoreBarRuiForDoubleBadge( barRui, scoreEnd, ladderPosition )
		}

		                                                                                                                                                                      
		                                                                                                                                                               

		InitArenasRankedScoreBarRuiForDoubleBadge( barRui, score, ArenasRanked_GetLadderPosition( GetLocalClientPlayer() ) )                                                                                                                                                   
	}

	if ( !quick && wasNetDecreaseInArenasRankedScore && wasDemoted )
	{
		                                                                                                    
		PlayLobbyCharacterDialogue( "glad_rankDown" )                                       
	}
}


void function InitArenasRankedScoreBarRuiForDoubleBadge( var rui, int score, int ladderPosition )
{
	for ( int i = 0; i < 5; i++ )
	{
		RuiDestroyNestedIfAlive( rui, "rankedBadgeHandle" + i )
	}

	RuiSetBool( rui, "forceDoubleBadge", true )

	SharedRankedDivisionData currentArenasRank = GetCurrentArenasRankedDivisionFromScoreAndLadderPosition( score, ladderPosition )
	SharedRankedTierData currentTier           = currentArenasRank.tier

	RuiSetGameTime( rui, "animStartTime", RUI_BADGAMETIME )

	if ( currentTier.isLadderOnlyTier )                                                        
	{
		SharedRankedDivisionData scoreDivisionData = GetCurrentArenasRankedDivisionFromScore( score )
		SharedRankedTierData scoreCurrentTier      = scoreDivisionData.tier
		RuiSetInt( rui, "currentTierColorOffset", scoreCurrentTier.index + 1 )
	}
	else
	{
		RuiSetInt( rui, "currentTierColorOffset", currentTier.index )
	}

	                                    
	RuiSetImage( rui, "icon0", currentTier.icon )
	RuiSetString( rui, "emblemText0", currentArenasRank.emblemText )
	RuiSetInt( rui, "badgeScore0", score )
	SharedRanked_FillInRuiEmblemText( rui, currentArenasRank, score, ladderPosition, "0" )
	var badgeRui = CreateNestedArenasRankedRui( rui, currentArenasRank.tier, "rankedBadgeHandle0", score, ladderPosition )
	bool shouldUpdateRuiWithCommunityUserInfo = ArenasRanked_ShouldUpdateWithComnunityUserInfo( score, ladderPosition )
	if ( shouldUpdateRuiWithCommunityUserInfo )
		file.barRuiToUpdate = rui

	RuiSetImage( rui, "icon3", currentTier.icon )
	RuiSetString( rui, "emblemText3", currentArenasRank.emblemText )
	RuiSetInt( rui, "badgeScore3", currentArenasRank.scoreMin )
	SharedRanked_FillInRuiEmblemText( rui, currentArenasRank, score, ladderPosition, "3" )
	CreateNestedArenasRankedRui( rui, currentArenasRank.tier, "rankedBadgeHandle3", score, ladderPosition )

	if( score >= ARENAS_RANKED_MIN_SCORE )
	{
		RuiSetInt( rui, "currentScore", score )
	}
	else
	{
		entity player = GetLocalClientPlayer()
		if( !ArenasRanked_HasFinishedPlacementMatches( player ) )
		{
			RuiSetInt( rui, "currentScore", ArenasRanked_GetNumPlacementMatchesCompleted( player ) )
			RuiSetInt( rui, "endScore", ArenasRanked_GetNumPlacementMatchesRequired() )
		}

		RuiSetBool( rui, "inPlacement", !ArenasRanked_HasFinishedPlacementMatches( player ) )
		RuiSetFloat( badgeRui, "badgeScale", 3.0 )

		int currentUnixTime                  = GetUnixTimestamp()
		ItemFlavor latestRankedPeriod = GetLatestRankedPeriodByType( currentUnixTime, eItemType.calevent_arenas_ranked_period )
		bool firstSplit = !SharedRankedPeriod_HasSplits( latestRankedPeriod ) || SharedRankedPeriod_IsFirstSplitActive( latestRankedPeriod )
		RuiSetBool( rui, "firstSplit", firstSplit )

	}

	RuiSetInt( rui, "startScore", currentArenasRank.scoreMin )

	SharedRankedDivisionData ornull nextArenasRank = GetNextArenasRankedDivisionFromScore( score )

	RuiSetBool( rui, "showSingleBadge", nextArenasRank == null )

	if ( nextArenasRank != null )
	{
		expect SharedRankedDivisionData( nextArenasRank )
		SharedRankedTierData nextTier = nextArenasRank.tier

		RuiSetBool( rui, "showSingleBadge", nextArenasRank == currentArenasRank )

		RuiSetInt( rui, "endScore", nextArenasRank.scoreMin )
		RuiSetString( rui, "emblemText4", nextArenasRank.emblemText )
		RuiSetInt( rui, "badgeScore4", nextArenasRank.scoreMin )
		RuiSetImage( rui, "icon4", nextTier.icon )
		RuiSetInt( rui, "nextTierColorOffset", nextTier.index )
		SharedRanked_FillInRuiEmblemText( rui, nextArenasRank, nextArenasRank.scoreMin, SHARED_RANKED_INVALID_LADDER_POSITION, "4" )
		CreateNestedArenasRankedRui( rui, nextArenasRank.tier, "rankedBadgeHandle4", nextArenasRank.scoreMin, SHARED_RANKED_INVALID_LADDER_POSITION )                                                                                      
	}
}


void function OnPostGameArenasRankedMenu_Close()
{
	file.barRuiToUpdate = null
	RemoveCallback_UserInfoUpdated( ArenasRanked_OnUserInfoUpdatedInPostGame )
}


void function OnContinue_Activate( var button )
{
	file.skippableWaitSkipped = true

	if ( !file.disableNavigateBack )
		CloseArenasRankedSummary( null )
}


void function OnPostGameArenasRankedMenu_Hide()
{
	Signal( uiGlobal.signalDummy, "OnPostGameArenasRankedMenu_Close" )

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

	CloseArenasRankedSummary( null )
}


void function CloseArenasRankedSummary( var button )
{
	if ( GetActiveMenu() == file.menu )
		thread CloseActiveMenu()
}


void function OpenArenasRankedSummary( bool firstTime )
{
	file.isFirstTime = firstTime
	AdvanceMenu( file.menu )
}


void function ArenasRanked_OnUserInfoUpdatedInPostGame( string hardware, string id )
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
		if ( file.barRuiToUpdate != null )                                                                                                                                
		{
			InitArenasRankedScoreBarRuiForDoubleBadge( file.barRuiToUpdate, cui.arenaScore, cui.arenaLadderPos )
		}
	}
}