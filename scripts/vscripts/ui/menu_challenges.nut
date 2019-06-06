#if(true)//

global function InitAllChallengesMenu

const int MAX_CHALLENGE_CATEGORIES_PER_PAGE = 14
const int MAX_CHALLENGE_PER_PAGE = 9

struct
{
	var menu
	var decorationRui
	var titleRui
	var categoryListPanel
	var challengesListPanel
	table<var,ChallengeGroupData> categoryButtonMap
} file

void function InitAllChallengesMenu()
{
	var menu = GetMenu( "AllChallengesMenu" )
	file.menu = menu

	file.decorationRui = Hud_GetRui( Hud_GetChild( menu, "Decoration" ) )
	file.titleRui = Hud_GetRui( Hud_GetChild( menu, "Title" ) )
	file.categoryListPanel = Hud_GetChild( menu, "CategoryList" )
	file.challengesListPanel = Hud_GetChild( menu, "ChallengesList" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, AllChallengesMenu_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, AllChallengesMenu_OnShow )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, AllChallengesMenu_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, AllChallengesMenu_OnNavigateBack )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_SELECT", "" )
}


void function AllChallengesMenu_OnOpen()
{
	RuiSetGameTime( file.decorationRui, "initTime", Time() )
	RuiSetString( file.titleRui, "title", Localize( "#CHALLENGE_FULL_MENU_TITLE" ).toupper() )
}


void function AllChallengesMenu_OnShow()
{
	UI_SetPresentationType( ePresentationType.CHARACTER_CARD )

	AllChallengesMenu_UpdateCategories()

	foreach( button, group in file.categoryButtonMap )
		Hud_AddEventHandler( button, UIE_CLICK, AllChallengesMenu_OnCategoryActivated )
}


void function AllChallengesMenu_OnClose()
{
	foreach( button, group in file.categoryButtonMap )
		Hud_RemoveEventHandler( button, UIE_CLICK, AllChallengesMenu_OnCategoryActivated )
}


void function AllChallengesMenu_OnNavigateBack()
{
	Assert( GetActiveMenu() == file.menu )
	CloseActiveMenu()
}


void function AllChallengesMenu_UpdateCategories()
{
	array<ChallengeGroupData> groupData = GetChallengeGroupData()

	var categoryScrollPanel = Hud_GetChild( file.categoryListPanel, "ScrollPanel" )
	Hud_InitGridButtonsDetailed( file.categoryListPanel, groupData.len(), MAX_CHALLENGE_CATEGORIES_PER_PAGE, 1 )
	file.categoryButtonMap = {}

	foreach( int i, ChallengeGroupData group in groupData )
	{
		var button = Hud_GetChild( categoryScrollPanel, "GridButton" + i )
		file.categoryButtonMap[ button ] <- group

		HudElem_SetRuiArg( button, "categoryName", group.groupName )
		HudElem_SetRuiArg( button, "challengeTotalNum", group.challenges.len() )
		HudElem_SetRuiArg( button, "challengeCompleteNum", group.completedChallenges )
		//

		if ( i == 0 )
			AllChallengesMenu_OnCategoryActivated( button )
	}
}


void function AllChallengesMenu_OnCategoryActivated( var button )
{
	//

	Assert( button in file.categoryButtonMap )
	ChallengeGroupData group = file.categoryButtonMap[ button ]

	//
	foreach( var _button, ChallengeGroupData data in file.categoryButtonMap )
		HudElem_SetRuiArg( _button, "isSelected", button == _button )

	var challengesScrollPanel = Hud_GetChild( file.challengesListPanel, "ScrollPanel" )
	Hud_InitGridButtonsDetailed( file.challengesListPanel, group.challenges.len(), MAX_CHALLENGE_PER_PAGE, 1 )

	foreach( int i, ItemFlavor challenge in group.challenges )
	{
		var listItem = Hud_GetChild( challengesScrollPanel, "GridButton" + i )

		int activeTier = Challenge_GetCurrentTier( GetUIPlayer(), challenge )
		int challengeGoal = Challenge_GetGoalVal( challenge, activeTier )
		int challengeProgress = Challenge_GetProgressValue( GetUIPlayer(), challenge, activeTier )

		HudElem_SetRuiArg( listItem, "challengeText", Challenge_GetDescription( challenge, activeTier ) )
		HudElem_SetRuiArg( listItem, "challengeProgress", challengeProgress )
		HudElem_SetRuiArg( listItem, "challengeGoal", challengeGoal )
		HudElem_SetRuiArg( listItem, "rewardString", Localize( "#CHALLENGE_XP_REWARD_STRING", Challenge_GetXPReward( challenge, activeTier ) ) )
		HudElem_SetRuiArg( listItem, "tierCount", Challenge_GetTierCount( challenge ) )
		HudElem_SetRuiArg( listItem, "activeTier", activeTier )
	}
}


/*



































*/






#endif //