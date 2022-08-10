global function InitArenasRankedInfoMenu
global function OpenArenasRankedInfoPage
global function InitArenasRankedScoreBarRui

#if DEV
global function ArenasTestScoreBar
#endif

struct
{
	var               menu
	var               aboutPanel
	var               aboutPanelCloseButton
} file

void function InitArenasRankedInfoMenu( var newMenuArg )                                               
{
	var menu = GetMenu( "ArenasRankedInfoMenu" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnArenasRankedInfoMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnArenasRankedInfoMenu_Close )

	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnArenasRankedInfoMenu_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, OnArenasRankedInfoMenu_Hide )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddMenuFooterOption( menu, LEFT, BUTTON_Y, true, "#Y_BUTTON_VIEW_REWARDS", "#VIEW_REWARDS", OnViewRewards, ShouldShowRewards )
	
	                                                                                                  
	                                                      

	file.aboutPanel = Hud_GetChild( menu, "MoreInfoPanel" )
	file.aboutPanelCloseButton = Hud_GetChild( menu, "MoreInfoCloseButton" )
	HideArenasRankedInfoPage( null )

	Hud_AddEventHandler( Hud_GetChild( menu, "MoreInfoButton" ), UIE_CLICK, ShowArenasRankedAboutPanel )
	Hud_AddEventHandler( Hud_GetChild( menu, "MoreInfoCloseButton" ), UIE_CLICK, HideArenasRankedInfoPage )
}

void function OpenArenasRankedInfoPage( var button )
{
	AdvanceMenu( file.menu )
}

void function ShowArenasRankedAboutPanel( var button )
{
	Hud_Show( file.aboutPanel )
	Hud_Show( file.aboutPanelCloseButton )
}

void function HideArenasRankedInfoPage( var button )
{
	Hud_Hide( file.aboutPanel )
	Hud_Hide( file.aboutPanelCloseButton )
}

void function OnArenasRankedInfoMenu_Open()
{
	PrintFunc()
	UI_SetPresentationType( ePresentationType.ARENAS_RANKED )

	entity player = GetLocalClientPlayer()

	int currentScore                     = GetPlayerArenasRankScore( player )
	array<SharedRankedTierData> tiers    = ArenasRanked_GetTiers()
	int ladderPosition                   = ArenasRanked_GetLadderPosition( player  )
	SharedRankedDivisionData currentRank = GetCurrentArenasRankedDivisionFromScoreAndLadderPosition( currentScore, ladderPosition )
	SharedRankedTierData currentTier     = currentRank.tier

	array< SharedRankedDivisionData > divisionData =  ArenasRanked_GetRankedDivisionDataForTier( currentRank.tier )

	array<var> panels = GetElementsByClassname( file.menu, "RankedInfoPanel" )

	foreach ( panel in panels )
	{
		InitArenasRankedInfoPanel( panel, tiers )
	}

	var mainRui = Hud_GetRui( Hud_GetChild( file.menu, "InfoMain" ) )
	if ( currentTier.isLadderOnlyTier  )                                                        
	{
		SharedRankedDivisionData scoreDivisionData = GetCurrentArenasRankedDivisionFromScore( currentScore )
		SharedRankedTierData scoreCurrentTier      = scoreDivisionData.tier
		RuiSetInt( mainRui, "currentTierColorOffset", scoreCurrentTier.index + 1 )
	}
	else
	{
		RuiSetInt( mainRui, "currentTierColorOffset", currentTier.index )
	}

	bool hasFinishedPlacement = ArenasRanked_HasFinishedPlacementMatches( player )
	if( hasFinishedPlacement )
		RuiSetInt( mainRui, "currentScore", currentScore )
	else
		RuiSetInt( mainRui, "currentScore", ArenasRanked_GetNumPlacementMatchesCompleted( player ) )

	RuiSetInt( mainRui, "numPlacementMatchesRequired", ArenasRanked_GetNumPlacementMatchesRequired() )
	RuiSetBool( mainRui, "inSeason", IsArenasRankedInSeason() )
	RuiSetBool( mainRui, "inPlacement", !hasFinishedPlacement )
	RuiSetString( mainRui, "currentRankString", currentRank.divisionName )

	var scoreBarRui = Hud_GetRui( Hud_GetChild( file.menu, "RankedProgressBar" ) )
	InitArenasRankedScoreBarRui( scoreBarRui, currentScore, ArenasRanked_GetLadderPosition( player ) )
}

void function InitArenasRankedScoreBarRui( var rui, int score, int ladderPosition )
{
	array<SharedRankedTierData> divisions = ArenasRanked_GetTiers()
	SharedRankedDivisionData currentRank  = GetCurrentArenasRankedDivisionFromScoreAndLadderPosition( score, ladderPosition )
	SharedRankedTierData currentTier      = currentRank.tier
	SharedRankedTierData ornull nextTier  = ArenasRanked_GetNextTierData( currentRank.tier )

	array< SharedRankedDivisionData > divisionData = ArenasRanked_GetRankedDivisionDataForTier ( currentRank.tier )

	RuiSetGameTime( rui, "animStartTime", RUI_BADGAMETIME )

	if ( currentTier.isLadderOnlyTier  )                                                        
	{
		SharedRankedDivisionData scoreDivisionData = GetCurrentArenasRankedDivisionFromScore( score )
		SharedRankedTierData scoreCurrentTier      = scoreDivisionData.tier
		RuiSetInt( rui, "currentTierColorOffset", scoreCurrentTier.index + 1 )
	}
	else
	{
		RuiSetInt( rui, "currentTierColorOffset", currentTier.index )
	}

	for ( int i=0; i<5; i++ )
	{
		RuiDestroyNestedIfAlive( rui, "rankedBadgeHandle" + i )
	}

	for ( int i=0; i<divisionData.len(); i++ )
	{
		SharedRankedDivisionData data = divisionData[ i ]
		RuiSetImage( rui, "icon" + i , currentTier.icon )
		RuiSetInt( rui, "badgeScore" + i, data.scoreMin )

		SharedRanked_FillInRuiEmblemText( rui, data, score, ladderPosition, string(i)  )
		var nestedRuiHandle = CreateNestedArenasRankedRui( rui, data.tier, "rankedBadgeHandle" + i, data.scoreMin, SHARED_RANKED_INVALID_LADDER_POSITION  )
	}

	RuiSetInt( rui, "currentScore" , score )
	RuiSetInt( rui, "startScore" , divisionData[0].scoreMin )

	if ( nextTier != null )
	{
		expect SharedRankedTierData( nextTier )

		if ( !nextTier.isLadderOnlyTier )
		{
			SharedRankedDivisionData firstRank = ArenasRanked_GetRankedDivisionDataForTier( nextTier )[0]

			RuiSetInt( rui, "endScore" , firstRank.scoreMin  )
			RuiSetString( rui, "emblemText4" , firstRank.emblemText  )
			RuiSetInt( rui, "badgeScore4", firstRank.scoreMin )
			RuiSetImage( rui, "icon4", nextTier.icon )
			SharedRanked_FillInRuiEmblemText( rui, firstRank, firstRank.scoreMin, ladderPosition, "4"  )
			var nestedRuiHandle = CreateNestedArenasRankedRui( rui, firstRank.tier, "rankedBadgeHandle4", firstRank.scoreMin, SHARED_RANKED_INVALID_LADDER_POSITION )
		}
	}

	                                                                    

	RuiSetBool( rui, "showSingleBadge", divisionData.len() == 1 )
}

void function InitArenasRankedInfoPanel( var panel, array<SharedRankedTierData> tiers )
{
	array<SharedRankedTierData> infoTiers = clone tiers
	int scriptID                          = int( Hud_GetScriptID( panel ) )

	ItemFlavor currentRankedPeriod = GetLatestRankedPeriodByType( GetUnixTimestamp(), eItemType.calevent_arenas_ranked_period )
	string rankedGUIDString = ItemFlavor_GetGUIDString( currentRankedPeriod )
	if ( ArenasRanked_PeriodHasLadderOnlyDivision( rankedGUIDString )  )
	{
		SharedRankedDivisionData ladderOnlyDivision = ArenasRanked_GetHistoricalLadderOnlyDivision( rankedGUIDString  )
		SharedRankedTierData ladderOnlyTier         = ladderOnlyDivision.tier
		infoTiers.append( ladderOnlyTier  )
	}
	if ( scriptID >= infoTiers.len() )
	{
		Hud_Hide( panel )
		return
	}

	for( int i = 0; i < infoTiers.len(); ++i )
	{
		if( infoTiers[i].scoreMin == ARENAS_RANKED_PLACEMENT_SCORE )
		{
			infoTiers.remove( i )
			break
		}
	}

	Hud_Show( panel )

	SharedRankedTierData rankedTier = infoTiers[scriptID]
	var rui                         = Hud_GetRui( panel )

	int ladderPosition = ArenasRanked_GetLadderPosition( GetLocalClientPlayer() )

	SharedRankedDivisionData currentRank = GetCurrentArenasRankedDivisionFromScoreAndLadderPosition( GetPlayerArenasRankScore( GetLocalClientPlayer() ), ladderPosition )

	RuiSetString( rui, "name", rankedTier.name )
	RuiSetInt( rui, "minScore", rankedTier.scoreMin )
	RuiSetInt( rui, "rankTier", scriptID )
	RuiSetImage( rui, "bgImage", rankedTier.bgImage )
	RuiSetBool( rui, "isLocked", rankedTier.index > currentRank.tier.index )

	RuiSetBool( rui, "isCurrent", currentRank.tier == rankedTier )

	if (  rankedTier.isLadderOnlyTier )
	{
		RuiSetBool( rui, "isLadderOnlyTier", rankedTier.isLadderOnlyTier  )
		RuiSetInt( rui, "numPlayersOnLadder", ArenasRanked_GetNumPlayersOnLadder()  )
	}

	var myParent = Hud_GetParent( panel )

	for ( int i=0; i < rankedTier.rewards.len(); i++ )
	{
		SharedRankedReward reward = rankedTier.rewards[i]
		var button                = Hud_GetChild( myParent, "RewardButton" + scriptID + "_" + i )

		var btRui = Hud_GetRui( button )
		RuiSetImage( btRui, "buttonImage", reward.previewIcon )
		RuiSetInt( btRui, "tier", scriptID )
		RuiSetBool( btRui, "showBox", reward.previewIconShowBox )
		RuiSetBool( btRui, "isLocked", rankedTier.index > currentRank.tier.index )

		ToolTipData ttd
		ttd.titleText = reward.previewName
		ttd.descText = "#RANKED_REWARD"
		Hud_SetToolTipData( button, ttd )

		if ( GetCurrentPlaylistVarBool( "arenas_ranked_reward_show_button", false ) )
			Hud_Show( button )
		else
			Hud_Hide( button )

		int idx = (i+1)

		if ( GetCurrentPlaylistVarBool( "arenas_ranked_reward_show_text", true ) )
		{
			string tierName = string( rankedTier.index )
			string rewardString = GetCurrentPlaylistVarString( "arenas_ranked_reward_override_" + tierName + "_" + idx, reward.previewName )
			RuiSetString( rui, "rewardString" + idx, rewardString )
		}
		else
			RuiSetString( rui, "rewardString" + idx, "" )
	}
}

void function OnArenasRankedInfoMenu_Close()
{
}

void function OnArenasRankedInfoMenu_Show()
{
}

void function OnArenasRankedInfoMenu_Hide()
{
}

void function ArenasTestScoreBar( int startScore = 370, int endScore = 450  )
{
	var scoreBarRui = Hud_GetRui( Hud_GetChild( file.menu, "RankedProgressBar" ) )
	RuiSetGameTime( scoreBarRui, "animStartTime", ClientTime() )
	RuiSetInt( scoreBarRui, "animStartScore", startScore )
	RuiSetInt( scoreBarRui, "currentScore", endScore )

}

void function OnViewRewards( var button )
{
	string creditsURL = Localize( GetCurrentPlaylistVarString( "show_arenas_ranked_rewards_link", "https://www.ea.com/games/apex-legends" ) )
	LaunchExternalWebBrowser( creditsURL, WEBBROWSER_FLAG_NONE )
}

bool function ShouldShowRewards()
{
	return GetCurrentPlaylistVarString( "show_arenas_ranked_rewards_link", "" ) != ""
}

void function moreInfoButton_OnActivate( var button )
{
	if ( IsDialog( GetActiveMenu() ) )
		return

	thread OnRankedMenu_RankedMoreInfo( button )
}

void function OnRankedMenu_RankedMoreInfo( var button )
{
	var savedMenu = GetActiveMenu()

	if ( savedMenu == GetActiveMenu() )
	{		
		thread ShowMoreInfo( button )		
	}
}


void function ShowMoreInfo( var button )
{
	OpenRankedInfoMorePage( button )
}
