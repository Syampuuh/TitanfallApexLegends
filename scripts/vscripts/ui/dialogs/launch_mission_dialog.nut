global function InitLaunchMissionDialog
global function OpenLaunchMissionDialog
global function InitMissionRewardButtons
global function SetupMissionRewardButtons

struct
{
	var menu
	var backgroundRui
	var infoRui
	int missionIndex
} file

void function InitLaunchMissionDialog( var menu )
{
	file.menu = menu

	SetDialog( menu, true )
	SetClearBlur( menu, false )
	SetGamepadCursorEnabled( menu, true )

	file.backgroundRui = Hud_GetRui( Hud_GetChild( file.menu, "Background" ) )
	file.infoRui = Hud_GetRui( Hud_GetChild( file.menu, "InfoRui" ) )

	  	                                                                                    

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, LaunchMissionDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, LaunchMissionDialog_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, LaunchMissionDialog_OnNavigateBack )

	Hud_AddEventHandler( Hud_GetChild( file.menu, "LaunchMissionButton" ), UIE_CLICK, LaunchButtonOnClick )
	Hud_AddEventHandler( Hud_GetChild( file.menu, "LoreButton" ), UIE_CLICK, LoreButtonOnClick )

	var closeButton = Hud_GetChild( menu, "CloseButton" )
	Hud_AddEventHandler( closeButton, UIE_CLICK, OnCloseButton_Activate )

	InitMissionRewardButtons( menu, "MissionRewardNoClick" )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#CLOSE" )
}

void function OnCloseButton_Activate( var button )
{
	CloseAllDialogs()
}

void function OpenLaunchMissionDialog( int missionIndex = 0 )
{
	file.missionIndex = missionIndex

	entity player = GetLocalClientPlayer()

	ItemFlavor ornull quest = SeasonQuest_GetActiveSeasonQuest( GetUnixTimestamp() )
	Assert( quest != null, "No season quest is active at this time." )
	expect ItemFlavor( quest )

	int missionsTotalMax = SeasonQuest_GetMissionsMaxCount( quest )
	bool finalMission = (missionIndex == (missionsTotalMax - 1))

	ItemFlavor mission = SeasonQuest_GetMissionForIndex( quest, missionIndex )
	Newness_IfNecessaryMarkItemFlavorAsNoLongerNewAndInformServer( mission )

	int status = SeasonQuest_GetStatusForMissionIndex( player, quest, missionIndex )
	bool missionCompleted = (status == eQuestMissionStatus.COMPLETED)

	string playlistName = SeasonQuest_GetPlaylistForMissionIndex( quest, missionIndex )
	int playlistMaxTeamSize = GetMaxTeamSizeForPlaylist( playlistName )

	             
	{
		string imageKey     = GetPlaylistVarString( playlistName, "image", "" )
		asset imageAsset    = GetImageFromImageMap( imageKey )
		RuiSetImage( file.infoRui, "mapImage", imageAsset )
		RuiSetString( file.infoRui, "missionName", GetPlaylistVarString( playlistName, "name", "" ) )
		RuiSetString( file.infoRui, "missionDesc", GetPlaylistVarString( playlistName, "description", "" ) )
		RuiSetInt( file.infoRui, "missionNumber", (missionIndex + 1) )
		RuiSetInt( file.infoRui, "maxTeamSize", playlistMaxTeamSize )
		RuiSetBool( file.infoRui, "isFinalMission", finalMission )

		UISize size
		size = REPLACEHud_GetSize( file.menu )
		RuiSetInt( file.backgroundRui, "screenWidth", size.width )
	}

	                
	{
		SetupMissionRewardButtons( file.menu, quest, missionIndex, "MissionRewardNoClick", missionCompleted, finalMission )
	}

	                
	{
		var launchButton		= Hud_GetChild( file.menu, "LaunchMissionButton" )
		var rui					= Hud_GetRui( launchButton )
		string launchButtonText	= ((status == eQuestMissionStatus.LAUNCHABLE) ? "#QUEST_LAUNCH_MISSION" : "#QUEST_RELAUNCH_MISSION")

		if ( !IsPartyLeader() )
		{
			ToolTipData toolTip
			toolTip.descText = "#QUEST_LAUNCH_MISSION_NOT_LEADER"
			toolTip.tooltipFlags = eToolTipFlag.SOLID
			Hud_SetToolTipData( launchButton, toolTip )
		}
		else if ( GetPartySize() > playlistMaxTeamSize )
		{
			ToolTipData toolTip
			toolTip.descText = "#PLAYLIST_STATE_PARTY_SIZE_OVER"
			toolTip.tooltipFlags = eToolTipFlag.SOLID
			Hud_SetToolTipData( launchButton, toolTip )
		}
		else
		{
			Hud_ClearToolTipData( launchButton )
		}

		RuiSetString( rui, "buttonText", launchButtonText )
	}

	              
	{
		var loreButton = Hud_GetChild( file.menu, "LoreButton" )

		Hud_SetVisible( loreButton, missionCompleted )
		                                                

		var loreRui = Hud_GetRui( loreButton )
		RuiSetAsset( loreRui, "icon", $"rui/menu/lobby/speech_bubble_icon" )
		RuiSetString( loreRui, "buttonText", "#QUEST_REPLAY_LORE" )
	}

	AdvanceMenu( file.menu )
}

table<var, void functionref( var button )> s_actionMap

void function InitMissionRewardButtons( var menu, string buttonClass )
{
	array<var> rewardButtonArray = GetPanelElementsByClassname( menu, buttonClass )
	foreach( var button in rewardButtonArray )
	{
		Hud_AddEventHandler( button, UIE_CLICK, void function( var button )
		{
			if ( !(button in s_actionMap) )
				return
			s_actionMap[button]( button )
		} )
	}
}

void function SetupMissionRewardButtons( var menu, ItemFlavor quest, int missionIndex, string buttonClass, bool missionCompleted, bool finalMission )
{
	array<var> rewardButtonArray = GetPanelElementsByClassname( menu, buttonClass )
	int buttonIndex = 0

	                 
	ItemFlavorBag rewardBag = SeasonQuest_GetMissionRewardsForIndex( quest, missionIndex )
	foreach( int index, ItemFlavor reward in rewardBag.flavors )
	{
		var button = rewardButtonArray[buttonIndex]
		BattlePassReward bpReward = ItemFlavorBagToBattlePassRewardByIndex( rewardBag, index )
		BattlePass_PopulateRewardButton( bpReward, button, missionCompleted, false )

		bool shouldObscure = ((ItemFlavor_GetType( reward ) == eItemType.weapon_charm) && finalMission && !missionCompleted && SHOW_UNKNOWN_ARTIFACTS )

		ToolTipData toolTip
		toolTip.titleText = GetBattlePassRewardHeaderText( ItemFlavorBagToBattlePassRewardByIndex( rewardBag, index ) )
		toolTip.descText = GetBattlePassRewardItemName( ItemFlavorBagToBattlePassRewardByIndex( rewardBag, index ) )
		toolTip.tooltipFlags = eToolTipFlag.SOLID
		if ( shouldObscure )
			toolTip.descText = "#QUEST_CHARM_UNKNOWN_REWARD_DESC"
		Hud_SetToolTipData( button, toolTip )

		s_actionMap[button] <- void function( var button ) : (menu, quest, missionIndex, bpReward, shouldObscure)
		{
			if ( shouldObscure )
				return
			if ( IsDialog( menu ) )
				CloseActiveMenu()
			EmitUISound( "ui_menu_accept" )
			RunClientScript( "ClearBattlePassItem" )
			SetGenericItemPresentationModeActiveWithNavBack( bpReward.flav, "#REWARD_LOCKEDBUTTON_HEADER", "#REWARD_LOCKEDBUTTON_SUBHEADER", void function() : (menu, missionIndex)
			{
				if ( menu == file.menu )
					SeasonQuestTab_SetAutoOpenMissionButton( missionIndex )
			} )
		}

		++buttonIndex
	}

	           
	if ( buttonIndex < rewardButtonArray.len() && !finalMission )
	{
		var button = rewardButtonArray[buttonIndex]

		PopulateRewardButtonWithArtifact( button, quest, missionIndex, missionCompleted )

		ToolTipData toolTip
		if ( !missionCompleted && SHOW_UNKNOWN_ARTIFACTS )
		{
			toolTip.titleText = "#QUEST_UNKNOWN_ARTIFACT_NAME"
			toolTip.descText = "#QUEST_UNKNOWN_ARTIFACT_DESC"
		}
		else
		{
			toolTip.titleText = "#QUEST_KNOWN_ARTIFACT_NAME"
			toolTip.descText = SeasonQuest_GetQuestItemNameForMissionIndex( quest, missionIndex )
		}
		toolTip.tooltipFlags = eToolTipFlag.SOLID
		Hud_SetToolTipData( button, toolTip )

		s_actionMap[button] <- void function( var button ) : (menu, quest, missionIndex, missionCompleted)
		{
			if ( missionCompleted )
			{
				if ( IsDialog( menu ) )
					CloseActiveMenu()
				EmitUISound( "ui_menu_accept" )
				asset lore = SeasonQuest_GetLoreSequenceQuestItemDataForMissionIndex( quest, missionIndex )
				if ( lore != $"" )
				{
					LoreReaderMenu_OpenToWithNavigateBack( lore, void function() : (menu, missionIndex)
					{
						if ( menu == file.menu )
							SeasonQuestTab_SetAutoOpenMissionButton( missionIndex )
					} )
				}
			}
		}

		++buttonIndex
	}

	       
	if ( buttonIndex < rewardButtonArray.len() )
	{
		var button = rewardButtonArray[buttonIndex]

		asset missionLoreData = SeasonQuest_GetLoreSequenceStoryChapterDataForMissionIndex( quest, missionIndex )
		PopulateRewardButtonWithLore( button, quest, missionCompleted )
		array<LorePage> pages = LoadLorePagesFromDataTable( missionLoreData )

		ToolTipData toolTip
		toolTip.titleText = Localize( "#QUEST_STORY_REWARD", Localize( pages[0].titleText ) )
		toolTip.descText = Localize( "#QUOTE_STRING", Localize( pages[0].subTitleText ) )
		toolTip.tooltipFlags = eToolTipFlag.SOLID
		Hud_SetToolTipData( button, toolTip )

		s_actionMap[button] <- void function( var button ) : (menu, quest, missionIndex, missionCompleted)
		{
			if ( missionCompleted )
			{
				if ( IsDialog( menu ) )
					CloseActiveMenu()
				EmitUISound( "ui_menu_accept" )
				asset lore = SeasonQuest_GetLoreSequenceStoryChapterDataForMissionIndex( quest, missionIndex )
				if ( lore != $"" )
				{
					LoreReaderMenu_OpenToWithNavigateBack( lore, void function() : (menu, missionIndex)
					{
						if ( menu == file.menu )
							SeasonQuestTab_SetAutoOpenMissionButton( missionIndex )
					} )
				}
			}
		}

		++buttonIndex
	}

	for( ; buttonIndex < rewardButtonArray.len(); ++buttonIndex )
	{
		var button = rewardButtonArray[buttonIndex]
		Hud_SetVisible( button, false )
		if ( button in s_actionMap )
			delete s_actionMap[button]
	}
}

void function LaunchButtonOnClick( var button )
{
	Assert( file.missionIndex != -1 )

	if ( !IsPartyLeader() )
		return

	ItemFlavor ornull quest = SeasonQuest_GetActiveSeasonQuest( GetUnixTimestamp() )
	Assert( quest != null, "No season quest is active at this time." )
	expect ItemFlavor( quest )

	int missionIndex = file.missionIndex
	string playlistName = SeasonQuest_GetPlaylistForMissionIndex( quest, missionIndex )
	int playlistMaxTeamSize = GetMaxTeamSizeForPlaylist( playlistName )
	if ( GetPartySize() > playlistMaxTeamSize )
		return

	CloseActiveMenu()                                        
	ReadyUpWithQuestPlaylist( SeasonQuest_GetPlaylistForMissionIndex( quest, missionIndex ) )
}


void function LoreButtonOnClick( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	Assert( file.missionIndex != -1 )

	ItemFlavor ornull quest = SeasonQuest_GetActiveSeasonQuest( GetUnixTimestamp() )
	Assert( quest != null, "No season quest is active at this time." )
	expect ItemFlavor( quest )

	int missionIndex = file.missionIndex
	CloseActiveMenu()                                        
	asset lore = SeasonQuest_GetLoreSequenceStoryChapterDataForMissionIndex( quest, missionIndex )
	if ( lore != $"" )
	{
		LoreReaderMenu_OpenToWithNavigateBack( lore, void function() : (missionIndex)
		{
			SeasonQuestTab_SetAutoOpenMissionButton( missionIndex )
		} )
	}
}


void function LaunchMissionDialog_OnOpen()
{
	EmitUISound( "UI_Menu_Legend_Details" )
}


void function LaunchMissionDialog_OnClose()
{
	file.missionIndex = -1
}


void function LaunchMissionDialog_OnNavigateBack()
{
	CloseActiveMenu()
}
