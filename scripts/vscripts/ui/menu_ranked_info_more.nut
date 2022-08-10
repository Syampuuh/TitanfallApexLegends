global function InitRankedInfoMoreMenu
global function OpenRankedInfoMorePage

struct
{
	var menu
} file

void function InitRankedInfoMoreMenu( var newMenuArg )                                               
{
	var menu = GetMenu( "RankedInfoMoreMenu" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnRankedInfoMoreMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnRankedInfoMoreMenu_Close )

	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnRankedInfoMoreMenu_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, OnRankedInfoMoreMenu_Hide )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}

void function OpenRankedInfoMorePage( var button )
{
	AdvanceMenu( file.menu )
}

void function OnRankedInfoMoreMenu_Open()
{
	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )
	
	int currentScore                     = GetPlayerRankScore( GetLocalClientPlayer() )
	array<SharedRankedTierData> tiers    = Ranked_GetTiers()
	int ladderPosition                   = Ranked_GetLadderPosition( GetLocalClientPlayer() )
	SharedRankedDivisionData currentRank = GetCurrentRankedDivisionFromScoreAndLadderPosition( currentScore, ladderPosition )
	SharedRankedTierData currentTier     = currentRank.tier
	
	var mainRui = Hud_GetRui( Hud_GetChild( file.menu, "InfoMain" ) )
	
	                       
	                                     
	   
	  	                            
	  	                                 
	  	                                                                                                                
	  	                                                 
	   

	var rankedScoringTableRui = Hud_GetRui( Hud_GetChild( file.menu, "RankedScoringTable" ) )
	RuiSetInt( rankedScoringTableRui, "fourteenthPlaceRP", Ranked_GetPointsForPlacement( 14 ) )
	RuiSetInt( rankedScoringTableRui, "eleventhPlaceRP", Ranked_GetPointsForPlacement( 11 ) )
	RuiSetInt( rankedScoringTableRui, "tenthPlaceRP", Ranked_GetPointsForPlacement( 10 ) )
	RuiSetInt( rankedScoringTableRui, "eighthPlaceRP", Ranked_GetPointsForPlacement( 8 ) )
	RuiSetInt( rankedScoringTableRui, "sixthPlaceRP", Ranked_GetPointsForPlacement( 6 ) )
	RuiSetInt( rankedScoringTableRui, "fifthPlaceRP", Ranked_GetPointsForPlacement( 5 ) )	
	RuiSetInt( rankedScoringTableRui, "fourthPlaceRP", Ranked_GetPointsForPlacement( 4 ) )
	RuiSetInt( rankedScoringTableRui, "thirdPlaceRP", Ranked_GetPointsForPlacement( 3 ) )
	RuiSetInt( rankedScoringTableRui, "secondPlaceRP", Ranked_GetPointsForPlacement( 2 ) )
	RuiSetInt( rankedScoringTableRui, "firstPlaceRP", Ranked_GetPointsForPlacement( 1 ) )
	
	RuiSetInt( rankedScoringTableRui, "fourteenthPlaceKillAssistMultiplier", Ranked_GetPointsForKillsPlacement( 14 ) )
	RuiSetInt( rankedScoringTableRui, "eleventhPlaceKillAssistMultiplier", Ranked_GetPointsForKillsPlacement( 11 ) )
	RuiSetInt( rankedScoringTableRui, "ninthPlaceKillAssistMultiplier", Ranked_GetPointsForKillsPlacement( 9 ) )
	RuiSetInt( rankedScoringTableRui, "seventhPlaceKillAssistMultiplier", Ranked_GetPointsForKillsPlacement( 7 ) )
	RuiSetInt( rankedScoringTableRui, "sixthPlaceKillAssistMultiplier", Ranked_GetPointsForKillsPlacement( 6 ) )

	RuiSetInt( rankedScoringTableRui, "fifthPlaceKillAssistMultiplier", Ranked_GetPointsForKillsPlacement( 5 ) )
	RuiSetInt( rankedScoringTableRui, "fourthPlaceKillAssistMultiplier", Ranked_GetPointsForKillsPlacement( 4 ) )
	RuiSetInt( rankedScoringTableRui, "thirdPlaceKillAssistMultiplier", Ranked_GetPointsForKillsPlacement( 3 ) )
	RuiSetInt( rankedScoringTableRui, "secondPlaceKillAssistMultiplier", Ranked_GetPointsForKillsPlacement( 2 ) )
	RuiSetInt( rankedScoringTableRui, "firstPlaceKillAssistMultiplier", Ranked_GetPointsForKillsPlacement( 1 ) )

	                                                                                                                               
	                                                                                                                            
	                                                                                                                           
	                                                                                                                           
	  	                                                                                                                         
	
	
	
	var rankedIconRui = Hud_GetRui( Hud_GetChild( file.menu, "PanelArt" ) )
	RuiSetInt( rankedIconRui, "tier", currentTier.index )
	RuiSetImage( rankedIconRui, "tierBadgeIcon", currentTier.icon )
	RuiSetString( rankedIconRui, "emblemText" , ( currentRank.emblemDisplayMode == emblemDisplayMode.DISPLAY_DIVISION ) ? Localize( currentRank.emblemText ) : Localize( "#RANKED_POINTS_GENERIC", string( currentScore ) ) )
}

void function OnRankedInfoMoreMenu_Close()
{

}

void function OnRankedInfoMoreMenu_Show()
{

}

void function OnRankedInfoMoreMenu_Hide()
{

}