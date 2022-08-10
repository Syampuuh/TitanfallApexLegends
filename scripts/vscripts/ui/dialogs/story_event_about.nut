global function InitStoryEventAboutDialog
global function StoryEventAboutDialog_SetEvent

struct ChapterObjectiveItem
{
	ItemFlavor ornull challengeFlav
	int challengeTier = 0
	int challengeTotalTiers = 0
	string desc = ""

	int progress = 0
	int goal = 0
	float percentCompleted = 0

	bool isCompleted = false
	bool isTimeLocked = false

	ItemFlavorBag rewardsBag

}

struct RadioVignetteData
{
	string radioVignette = ""
	string radioVignetteMilesEvent = ""
}

struct ChapterItem
{
	array<ChapterObjectiveItem> objectives
	bool isTimeLocked = false
	int unlockTime = 0

	bool isPrologue
	bool isLocked = false
	string tag = ""
	int missionNumber = 0

	string title = ""
	string loreDesc = ""
	string prologueDesc = ""
	asset screenshot
	bool hasScreenshot = false
	bool isNew = false
	bool isCompleted = false
	string playlistName = ""

	RadioVignetteData radioVignetteData
}

struct
{
	bool 		pageInputsRegistered = false

	var       	menu
	var        	mainLayer
	var			overlayLayer
	var        	arrowLeft
	var 		arrowRight
	var 		finalReward
	array<var>  rewardButtons
	array<var>  radioVignette
	var 		rewardsPanel
	var			prologueButton

	float pin_viewStartTime

	ItemFlavor& event
	ItemFlavor& savedEvent


	int numVisibleChallenges
	int startAt 					= -1
	int lastStartAt 				= -1

	bool isPrologueCompleted		= false

	bool challengeButtonIsFocused	= false
	bool rewardButtonIsFocused		= false
	bool vignetteButtonIsFocused    = false

	int currentObjectiveIndex 		= -1                               
	int lastCurrentObjectiveIndex 	= -1                                             

	int focusedObjectiveIndex 		= -1                                      
	int lastFocusedObjectiveIndex 	= -1

	array<var>  challengeButtons
	array challengeGroups
	array<var>  playlistChallengeButtons

	table<var, BattlePassReward> rewardButtonToRewardFlavMap

	table<var, RadioVignetteData> rvButtonToRadioVignetteMap

	array<ChapterItem> chapters

	bool isOpen = false
} file

const int MAX_CHALLENGE_GROUPS_SHOWN = 4
const int PEAK_CHALLENGE_GROUPS_SHOWN = 1
const int MAX_REWARDS_SHOWN = 3

void function InitStoryEventAboutDialog( var menu )
{
	file.menu = menu
	file.mainLayer = Hud_GetChild( file.menu, "MainLayer" )
	file.overlayLayer = Hud_GetChild( file.menu, "OverlayLayer" )
	file.rewardsPanel = Hud_GetChild( file.menu, "RewardsPanel" )
	file.arrowLeft = Hud_GetChild( file.menu, "ArrowLeft" )
	file.arrowRight = Hud_GetChild( file.menu, "ArrowRight" )
	file.finalReward = Hud_GetChild( file.menu, "FinalRewardButton" )
	file.prologueButton = Hud_GetChild( file.rewardsPanel, "PrologueButton" )

	InitButtonRCP( file.mainLayer )

	AddMenuEventHandler( menu, eUIEvent.MENU_GET_TOP_LEVEL, OnGetTopLevel )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnNavigateBack )
	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnClose )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE" )
}


void function StoryEventAboutDialog_SetEvent( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_story_challenges )
	file.event = event
}


void function OnGetTopLevel()
{
	UI_SetPresentationType( ePresentationType.BATTLE_PASS )
}

void function OnOpen()
{
	file.isOpen = true
	ItemFlavor event = file.event
	Assert( IsItemFlavorStructValid( event ), "Must call StoryEventAboutDialog_SetEvent before opening the StoryEventAboutDialog menu!" )

	RegisterInput()

	                    
	file.challengeGroups = StoryEvent_GetChapters(file.event)
	file.numVisibleChallenges = file.challengeGroups.len()

	UpdateCurrentObjectiveIndex()
	file.focusedObjectiveIndex = file.currentObjectiveIndex

	float maxIndex = max(file.numVisibleChallenges - MAX_CHALLENGE_GROUPS_SHOWN, 0.0)
	file.startAt = int(Clamp(float(file.currentObjectiveIndex),0.0,maxIndex))

	thread Thread_OnUpdate()
}

void function OnClose()
{
	DeregisterInput()

	                
	file.isOpen = false
	ItemFlavor invalidItemFlav
	file.event = invalidItemFlav
	file.lastStartAt = -1
	file.startAt = -1
	file.focusedObjectiveIndex = -1
	file.lastFocusedObjectiveIndex = -1
	file.currentObjectiveIndex = -1
	file.lastCurrentObjectiveIndex = -1

	file.challengeButtons.clear()
	file.chapters.clear()
	file.rewardButtonToRewardFlavMap.clear()
}

void function RegisterInput()
{
	if ( file.pageInputsRegistered )
		return

	Hud_AddEventHandler( file.arrowRight, UIE_CLICK, StoryAbout_OnNavigateRight )
	RegisterButtonPressedCallback( MOUSE_WHEEL_DOWN, StoryAbout_OnNavigateRight )
	RegisterButtonPressedCallback( KEY_RIGHT, StoryAbout_OnNavigateRight )
	RegisterButtonPressedCallback( BUTTON_DPAD_RIGHT, StoryAbout_OnNavigateRight )
	RegisterButtonPressedCallback( BUTTON_SHOULDER_RIGHT, StoryAbout_OnNavigateRight )

	Hud_AddEventHandler( file.arrowLeft, UIE_CLICK, StoryAbout_OnNavigateLeft )
	RegisterButtonPressedCallback( MOUSE_WHEEL_UP, StoryAbout_OnNavigateLeft )
	RegisterButtonPressedCallback( KEY_LEFT, StoryAbout_OnNavigateLeft )
	RegisterButtonPressedCallback( BUTTON_DPAD_LEFT, StoryAbout_OnNavigateLeft )
	RegisterButtonPressedCallback( BUTTON_SHOULDER_LEFT, StoryAbout_OnNavigateLeft )

	for ( int challengeBtnIdx = 0; challengeBtnIdx < MAX_CHALLENGE_GROUPS_SHOWN + (PEAK_CHALLENGE_GROUPS_SHOWN * 2); challengeBtnIdx++ )
	{
		var challengeBtn = Hud_GetChild( file.rewardsPanel,  "Challenge" + challengeBtnIdx )
		bool isPeakButton = challengeBtnIdx == 0 || challengeBtnIdx > MAX_CHALLENGE_GROUPS_SHOWN
		file.challengeButtons.append( challengeBtn )

		var playlistChallengeBtn = Hud_GetChild( file.rewardsPanel,  "PlaylistChallenge" + challengeBtnIdx + "Button")
		file.playlistChallengeButtons.append(playlistChallengeBtn)

		Hud_AddEventHandler( playlistChallengeBtn, UIE_CLICK, PlaylistChangeButton_OnActivate )

		if(!isPeakButton)
		{
			Hud_AddEventHandler( challengeBtn, UIE_GET_FOCUS, ChallengeButton_OnFocus )
			Hud_AddEventHandler( challengeBtn, UIE_LOSE_FOCUS, ChallengeButton_OnUnFocus )
		}
		for ( int rewardBtnIdx = 0; rewardBtnIdx < MAX_REWARDS_SHOWN; rewardBtnIdx++ )
		{
			var rewardButton = Hud_GetChild( file.rewardsPanel, format( "Challenge%1dRewardButton%02d", challengeBtnIdx, rewardBtnIdx ) )
			if(!isPeakButton)
			{
				Hud_AddEventHandler( rewardButton, UIE_CLICK, RewardButton_OnActivate )
				Hud_AddEventHandler( rewardButton, UIE_GET_FOCUS, RewardButton_OnFocus )
				Hud_AddEventHandler( rewardButton, UIE_LOSE_FOCUS, RewardButton_OnUnFocus )
			}
			file.rewardButtons.append( rewardButton )
		}

		var rvButton = Hud_GetChild( file.rewardsPanel, format( "Challenge%1dRVButton", challengeBtnIdx ) )
		Hud_AddEventHandler( rvButton, UIE_CLICK, RVButton_OnActivate )
		Hud_AddEventHandler( rvButton, UIE_GET_FOCUS, RVButton_OnFocus )
		Hud_AddEventHandler( rvButton, UIE_LOSE_FOCUS, RVButton_OnUnFocus )
		file.radioVignette.append( rvButton )
	}

	Hud_AddEventHandler( file.finalReward, UIE_CLICK, RewardButton_OnActivate )

	Hud_AddEventHandler( file.prologueButton, UIE_CLICK, PrologueButton_OnActivate )


	file.pageInputsRegistered = true
}

void function DeregisterInput()
{
	if ( !file.pageInputsRegistered )
		return

	Hud_RemoveEventHandler( file.arrowRight, UIE_CLICK, StoryAbout_OnNavigateRight )
	DeregisterButtonPressedCallback( KEY_RIGHT, StoryAbout_OnNavigateRight )
	DeregisterButtonPressedCallback( MOUSE_WHEEL_DOWN, StoryAbout_OnNavigateRight )
	DeregisterButtonPressedCallback( BUTTON_DPAD_RIGHT, StoryAbout_OnNavigateRight )
	DeregisterButtonPressedCallback( BUTTON_SHOULDER_RIGHT, StoryAbout_OnNavigateRight )

	Hud_RemoveEventHandler( file.arrowLeft, UIE_CLICK, StoryAbout_OnNavigateLeft )
	DeregisterButtonPressedCallback( MOUSE_WHEEL_UP, StoryAbout_OnNavigateLeft )
	DeregisterButtonPressedCallback( KEY_LEFT, StoryAbout_OnNavigateLeft )
	DeregisterButtonPressedCallback( BUTTON_DPAD_LEFT, StoryAbout_OnNavigateLeft )
	DeregisterButtonPressedCallback( BUTTON_SHOULDER_LEFT, StoryAbout_OnNavigateLeft )


	for ( int challengeBtnIdx = 0; challengeBtnIdx < MAX_CHALLENGE_GROUPS_SHOWN + (PEAK_CHALLENGE_GROUPS_SHOWN * 2); challengeBtnIdx++ )
	{
		var challengeBtn = Hud_GetChild( file.rewardsPanel,  "Challenge" + challengeBtnIdx )
		bool isPeakButton = challengeBtnIdx == 0 || challengeBtnIdx > MAX_CHALLENGE_GROUPS_SHOWN

		var playlistChallengeBtn = Hud_GetChild( file.rewardsPanel,  "PlaylistChallenge" + challengeBtnIdx + "Button")
		Hud_RemoveEventHandler( playlistChallengeBtn, UIE_CLICK, PlaylistChangeButton_OnActivate )


		if(!isPeakButton)
		{
			Hud_RemoveEventHandler( challengeBtn, UIE_GET_FOCUS, ChallengeButton_OnFocus )
			Hud_RemoveEventHandler( challengeBtn, UIE_LOSE_FOCUS, ChallengeButton_OnUnFocus )
		}
		for ( int rewardBtnIdx = 0; rewardBtnIdx < MAX_REWARDS_SHOWN; rewardBtnIdx++ )
		{
			var rewardButton = Hud_GetChild( file.rewardsPanel, format( "Challenge%1dRewardButton%02d", challengeBtnIdx, rewardBtnIdx ) )
			if(!isPeakButton)
			{
				Hud_RemoveEventHandler( rewardButton, UIE_CLICK, RewardButton_OnActivate )
				Hud_RemoveEventHandler( rewardButton, UIE_GET_FOCUS, RewardButton_OnFocus )
				Hud_RemoveEventHandler( rewardButton, UIE_LOSE_FOCUS, RewardButton_OnUnFocus )
			}
		}

		var rvButton = Hud_GetChild( file.rewardsPanel, format( "Challenge%1dRVButton", challengeBtnIdx ) )
		Hud_RemoveEventHandler( rvButton, UIE_CLICK, RVButton_OnActivate )
		Hud_RemoveEventHandler( rvButton, UIE_GET_FOCUS, RVButton_OnFocus )
		Hud_RemoveEventHandler( rvButton, UIE_LOSE_FOCUS, RVButton_OnUnFocus )
	}

	Hud_RemoveEventHandler( file.finalReward, UIE_CLICK, RewardButton_OnActivate )

	Hud_RemoveEventHandler( file.prologueButton, UIE_CLICK, PrologueButton_OnActivate )

	file.rewardButtons.clear()
	file.radioVignette.clear()
	file.pageInputsRegistered = false
}

void function OnNavigateBack()
{
	CloseActiveMenu()
}

void function Thread_OnUpdate()
{
	bool isFirstTime = true

	while(true)
	{

		if( !file.isOpen )
			break

		entity player = GetLocalClientPlayer()
		if( Challenge_IsChallengesStateInititated( player ) )
		{
			UpdateCurrentObjectiveIndex()
			if(file.focusedObjectiveIndex != file.lastFocusedObjectiveIndex || file.startAt != file.lastStartAt || file.currentObjectiveIndex != file.lastCurrentObjectiveIndex)
			{
				if(file.currentObjectiveIndex != file.lastCurrentObjectiveIndex)
				{
					file.startAt = (file.currentObjectiveIndex + MAX_CHALLENGE_GROUPS_SHOWN < file.numVisibleChallenges)? file.currentObjectiveIndex: file.numVisibleChallenges - MAX_CHALLENGE_GROUPS_SHOWN
				}

				AddStoryTrackerPinEvent(file.focusedObjectiveIndex, file.lastFocusedObjectiveIndex)

				PopulateData( player )

				if(!isFirstTime)
					PlayChallengeFocusAudio()
				else
					isFirstTime = false

				                                                                                                         
				                                                                                
				if(file.currentObjectiveIndex != file.lastCurrentObjectiveIndex)
					file.lastFocusedObjectiveIndex = file.currentObjectiveIndex
				else
					file.lastFocusedObjectiveIndex = file.focusedObjectiveIndex

				file.lastStartAt = file.startAt
				file.lastCurrentObjectiveIndex = file.currentObjectiveIndex

				OnUpdateChallengesRui( player )
				OnUpdateArrowsRui()
				OnUpdateHeaderRui( player )
			}
		}

		wait 0.1
	}
}

void function PopulateData( entity player )
{
	file.chapters.clear()

	file.isPrologueCompleted = StoryChallengeEvent_IsPrologueCompleted(player,  file.event)
	array challengeGroups = file.challengeGroups
	bool eventHasNew = false

	foreach( int idx, var challengeGroup in challengeGroups )
	{
		ChapterItem chapter

		chapter.isLocked = IsChapterIndexLocked(idx)
		chapter.isTimeLocked = IsChapterTimeLocked( idx )
		chapter.tag = StoryEvent_GetChapterTagString( file.event, idx )
		chapter.missionNumber = idx
		chapter.title = GetSettingsBlockString( challengeGroup, "aboutTitle" )
		chapter.loreDesc = GetSettingsBlockString( challengeGroup, "aboutDesc" )
		chapter.screenshot = GetSettingsBlockAsset( challengeGroup, "aboutScreenshotImage" )
		chapter.playlistName = StoryEvent_GetPlaylistName( challengeGroup )

		if(chapter.screenshot != $"")
			chapter.hasScreenshot = true

		chapter.isPrologue = StoryEvent_GetChapterIsPrologue( challengeGroup )

		if(chapter.isTimeLocked){
			string requiredStartDate  = GetSettingsBlockString( challengeGroup, "requiredStartTime" )
			int ornull requiredStartDateUnixTimeOrNull = DateTimeStringToUnixTimestamp( requiredStartDate )

			expect int( requiredStartDateUnixTimeOrNull )

			int unixTimeNow = GetUnixTimestamp()
			chapter.unlockTime = requiredStartDateUnixTimeOrNull - unixTimeNow
		}

		array challenges = IterateSettingsArray( GetSettingsBlockArray( challengeGroup, "challenges" ) )

		if(!chapter.isPrologue)
			Assert( challenges.len() == 1, "Story UI only supports up to 1 challenge per challenge group right now" )

		if(chapter.isPrologue && file.isPrologueCompleted)
			chapter.prologueDesc = StoryEvent_GetPrologueLobbyDesc(challengeGroup)

		chapter.radioVignetteData.radioVignette = StoryEvent_GetRadioVignetteBink ( challengeGroup )
		chapter.radioVignetteData.radioVignetteMilesEvent = StoryEvent_GetRadioVignetteMilesEvent ( challengeGroup )

		int completedObjectives
		                            
		bool hasValidChallenge = false
		foreach ( var challengeBlock in challenges )
		{
			ChapterObjectiveItem objective

			ItemFlavor ornull challengeFlav = RegisterItemFlavorFromSettingsAsset( GetSettingsBlockAsset( challengeBlock, "challengeFlav" ) )
			objective.challengeFlav = challengeFlav

			if ( challengeFlav != null )
			{
				expect ItemFlavor( challengeFlav )
				                                                          
				if ( !chapter.isTimeLocked && file.isPrologueCompleted && DoesPlayerHaveChallenge( player, challengeFlav ) )
				{
					hasValidChallenge = true
					objective.challengeTier = Challenge_GetCurrentTier( player, challengeFlav )
					objective.challengeTotalTiers = Challenge_GetTierCount( challengeFlav )

					                                                                   
					if(objective.challengeTotalTiers == objective.challengeTier)
						objective.challengeTier = int(max(objective.challengeTier - 1, 0))

					objective.desc = Challenge_GetDescription( challengeFlav, objective.challengeTier )

					int progressVal = Challenge_GetProgressValue( player, challengeFlav, objective.challengeTier )
					int goalVal     = Challenge_GetGoalVal( challengeFlav, objective.challengeTier )

					objective.progress = Challenge_GetProgressValue( player, challengeFlav, objective.challengeTier )
					objective.goal = Challenge_GetGoalVal( challengeFlav, objective.challengeTier )
					objective.isCompleted = objective.progress == objective.goal
					objective.percentCompleted = float( objective.progress) / float( objective.goal )

					         
					ItemFlavorBag rewardsBag = Challenge_GetRewards(challengeFlav, objective.challengeTier )
					objective.rewardsBag.flavors = rewardsBag.flavors
					objective.rewardsBag.associatedError = rewardsBag.associatedError
					objective.rewardsBag.quantities = rewardsBag.quantities

					Assert( objective.rewardsBag.flavors.len() < 3 , "Story UI only supports up to 3 rewards per challenge group right now" )
				}
			}
			if(objective.isCompleted)
				completedObjectives++

			chapter.objectives.push( objective )
		}

		if( hasValidChallenge && !eventHasNew )
		{
			          
			string hasSeenVarName = GetSettingsBlockString( challengeGroup, "hasSeenAboutChallengesPersistentVarName")
			if ( hasSeenVarName != "" && !chapter.isLocked && !chapter.isTimeLocked)
			{
				bool isNew = player.GetPersistentVarAsInt(hasSeenVarName) == 0
				if( isNew )
				{
					chapter.isNew = isNew
					eventHasNew = true
				}
			}
		}

		if(!chapter.isPrologue)
			chapter.isCompleted = completedObjectives >= challenges.len()
		else
			chapter.isCompleted = file.isPrologueCompleted

		file.chapters.push( chapter )
	}

	if(eventHasNew)
		Remote_ServerCallFunction( "ClientCallback_SetStoryAboutActiveChapterSeen", file.event._____INTERNAL_humanReadableRef )
}

void function OnUpdateChallengesRui( entity player )
{
	ItemFlavor event = file.event
	Assert( IsItemFlavorStructValid( event ), "Must call StoryEventAboutDialog_SetEvent before opening the StoryEventAboutDialog menu!" )

	file.rewardButtonToRewardFlavMap.clear()
	file.rvButtonToRadioVignetteMap.clear()
	foreach( var button in file.rewardButtons )
	{
		Hud_SetEnabled( button, false )
		Hud_SetVisible( button, false  )
	}

	foreach( var button in file.challengeButtons)
	{
		Hud_SetEnabled( button, false )
		Hud_SetVisible( button, false  )
	}

	foreach ( var button in file.radioVignette )
	{
		Hud_SetEnabled( button, false )
		Hud_SetVisible( button, false )
	}

	foreach ( var button in file.playlistChallengeButtons )
	{
		Hud_SetEnabled( button, false )
		Hud_SetVisible( button, false  )
	}
	                                
	Hud_SetVisible( file.prologueButton, !file.isPrologueCompleted )

	int challengeButton = (file.startAt == 0)? PEAK_CHALLENGE_GROUPS_SHOWN: 0
	foreach( int idx, ChapterItem chapter  in file.chapters )
	{
		var button = Hud_GetChild( file.rewardsPanel, "Challenge" + (challengeButton ) )
		var rui    = Hud_GetRui( button )

		bool isPeekLeft = IsPeakingLeft()
		bool IsVisible = isPeekLeft? file.startAt - PEAK_CHALLENGE_GROUPS_SHOWN <= idx : file.startAt <= idx

		if( IsVisible && challengeButton < MAX_CHALLENGE_GROUPS_SHOWN + (PEAK_CHALLENGE_GROUPS_SHOWN * 2) )
		{

			RuiSetInt( rui, "missionNumber", chapter.missionNumber )
			RuiSetString( rui, "tag", chapter.tag )

			string previousTag = ""
			if(idx > 0)
				previousTag = Localize(file.chapters[idx - 1].tag, file.chapters[idx - 1].missionNumber )
			RuiSetString( rui, "previousTag", previousTag )
			RuiSetBool( rui, "isSelected", idx == file.focusedObjectiveIndex )
			RuiSetBool( rui, "isTimeLocked", chapter.isTimeLocked )
			RuiSetBool( rui, "isLocked", chapter.isLocked )
			RuiSetInt( rui, "unlockTime", chapter.unlockTime )
			RuiSetBool( rui, "isNew", chapter.isNew )
			RuiSetBool( rui, "isCompleted", chapter.isCompleted )

			var playlistButton = Hud_GetChild( file.rewardsPanel, "PlaylistChallenge" + challengeButton + "Button" )
			if( chapter.playlistName != "" && !chapter.isLocked && !chapter.isTimeLocked )
			{
				bool isPartyLeader = IsPartyLeader()
				Hud_SetEnabled( playlistButton, isPartyLeader )
				Hud_SetVisible( playlistButton, true )

				ToolTipData toolTipData
				toolTipData.titleText = ""
				toolTipData.descText = "#QUEST_LAUNCH_MISSION_NOT_LEADER"
				toolTipData.actionHint1 = ""

				if( !isPartyLeader )
					Hud_SetToolTipData( playlistButton, toolTipData )
			}

			if(chapter.isNew)
				RuiSetWallTimeWithNow( rui, "animateStartTime" )
			else
				RuiSetWallTimeBad( rui,"animateStartTime")


			if(chapter.isPrologue)
			{
				Hud_SetVisible( button, true )
				Hud_SetEnabled( button,  !chapter.isLocked && !chapter.isTimeLocked && !IsChallengeIndexPeaking(challengeButton) )
				RuiSetString( rui, "desc", chapter.prologueDesc )
				RuiSetBool( rui, "isCompleted", file.isPrologueCompleted )
				RuiSetFloat( rui, "challenge1Progress", (file.isPrologueCompleted)? 1.0: 0.0 )

				challengeButton++
			}
			else
			{
				foreach ( ChapterObjectiveItem objective in chapter.objectives )                             
				{
					Hud_SetVisible( button, true )
					Hud_SetEnabled( button,  !chapter.isLocked && !chapter.isTimeLocked && !IsChallengeIndexPeaking(challengeButton) )

					RuiSetFloat( rui, "challenge1Progress", objective.percentCompleted )
					RuiSetString( rui, "desc", objective.desc )
					foreach ( int bagIndex, ItemFlavor reward in objective.rewardsBag.flavors )
					{

						if( idx >=  file.chapters.len() - 1  && bagIndex >= objective.rewardsBag.flavors.len() - 1 )
							break

						var rewardButton = Hud_GetChild( file.rewardsPanel, format( "Challenge%1dRewardButton%02d", challengeButton, bagIndex ) )
						Hud_SetEnabled( rewardButton, true )
						Hud_SetVisible( rewardButton, true  )

						BattlePassReward bpReward = ItemFlavorBagToBattlePassRewardByIndex( objective.rewardsBag, bagIndex )
						file.rewardButtonToRewardFlavMap[rewardButton] <- bpReward
						BattlePass_PopulateRewardButton( bpReward, rewardButton, objective.isCompleted, false )

					}

					if ( chapter.radioVignetteData.radioVignette != "" && objective.percentCompleted >= 1.0)
					{
						var rvButton = Hud_GetChild( file.rewardsPanel, format( "Challenge%1dRVButton", challengeButton ) )
						                           
						Hud_SetEnabled( rvButton, true )
						Hud_SetVisible( rvButton, true  )
						var btnRui
						if ( rvButton != null )
							btnRui = Hud_GetRui( rvButton )
						file.rvButtonToRadioVignetteMap[ rvButton ] <- chapter.radioVignetteData
					}

					challengeButton++
				}
			}
		}
	}


	ItemFlavorBag rewardBag = StoryEvent_GetCompletionReward( event )
	if(rewardBag.flavors.len() > 0)
	{
		BattlePassReward bpReward = ItemFlavorBagToBattlePassRewardByIndex( rewardBag, 0 )
		file.rewardButtonToRewardFlavMap[file.finalReward] <- bpReward
	}

	                             
	bool HadFinalReward = file.finalReward in file.rewardButtonToRewardFlavMap
	Hud_SetVisible( file.finalReward, HadFinalReward )
	if( HadFinalReward )
	{
		BattlePass_PopulateRewardButton( file.rewardButtonToRewardFlavMap[file.finalReward],file.finalReward , IsStoryComplete( player ), true )
	}
}

void function OnUpdateArrowsRui()
{
	Hud_SetVisible( file.arrowLeft, file.startAt >= PEAK_CHALLENGE_GROUPS_SHOWN && file.isPrologueCompleted )
	Hud_SetVisible( file.arrowRight, file.startAt + MAX_CHALLENGE_GROUPS_SHOWN  < file.numVisibleChallenges && file.isPrologueCompleted )
}

void function OnUpdateHeaderRui( entity player )
{
	ItemFlavor event = file.event
	Assert( IsItemFlavorStructValid( event ), "Must call StoryEventAboutDialog_SetEvent before opening the StoryEventAboutDialog menu!" )

	HudElem_SetRuiArg( file.mainLayer, "bgImage", StoryEvent_GetChapterAboutBgImage( event ), eRuiArgType.IMAGE )
	HudElem_SetRuiArg( file.overlayLayer, "bgImage", StoryEvent_GetChapterAboutBgImage( event ), eRuiArgType.IMAGE )

	if(file.focusedObjectiveIndex >= 0 && file.chapters.len() > file.focusedObjectiveIndex)
	{
		var rui = Hud_GetRui( file.mainLayer )

		RuiSetString( rui, "title", file.chapters[file.focusedObjectiveIndex].title )
		RuiSetString( rui, "desc",  file.chapters[file.focusedObjectiveIndex].loreDesc)
		RuiSetBool( rui, "isLocked",  file.chapters[file.focusedObjectiveIndex].isLocked )
		RuiSetString( rui, "tag", file.chapters[file.focusedObjectiveIndex].tag )
		RuiSetInt( rui, "missionNumber", file.chapters[file.focusedObjectiveIndex].missionNumber )
		RuiSetBool( rui, "isCompleted", file.chapters[file.focusedObjectiveIndex].isCompleted )

		rui = Hud_GetRui( file.overlayLayer )
		RuiSetImage( rui, "screenshotImage",  file.chapters[file.focusedObjectiveIndex].screenshot )
		RuiSetBool( rui, "isCompleted",  IsStoryComplete( player ) )
		RuiSetInt( rui, "missionNumber", file.chapters[file.focusedObjectiveIndex].missionNumber )
		RuiSetBool( rui, "hasScreenshot",  file.chapters[file.focusedObjectiveIndex].hasScreenshot )
	}
}

bool function IsChapterTimeLocked( int idx )
{
	if(file.challengeGroups.len() > idx){
		var challengeGroup = file.challengeGroups[idx]
		string requiredStartDate  = GetSettingsBlockString( challengeGroup, "requiredStartTime" )
		int ornull requiredStartDateUnixTimeOrNull = DateTimeStringToUnixTimestamp( requiredStartDate )
		if ( requiredStartDateUnixTimeOrNull == null )
			Assert( 0, format( "Bad format in playlist for setting: '%s'", requiredStartDateUnixTimeOrNull ) )

		expect int( requiredStartDateUnixTimeOrNull )

		return !( GetUnixTimestamp() >= requiredStartDateUnixTimeOrNull )
	}
	return true
}

bool function IsPeakingLeft(){
	return file.startAt > 0
}

bool function IsChallengeIndexPeaking( int idx ){
	return idx < PEAK_CHALLENGE_GROUPS_SHOWN || idx > MAX_CHALLENGE_GROUPS_SHOWN
}

bool function IsChapterIndexLocked( int idx ) {
	return idx > file.currentObjectiveIndex
}

void function UpdateCurrentObjectiveIndex()
{
	ItemFlavor event = file.event
	Assert( IsItemFlavorStructValid( event ), "Must call StoryEventAboutDialog_SetEvent before opening the StoryEventAboutDialog menu!" )

	entity player = GetLocalClientPlayer()
	file.currentObjectiveIndex = StoryEvent_GetActiveChapter( player, event )
}

void function RewardButton_OnActivate( var btn )
{
	if ( !(btn in file.rewardButtonToRewardFlavMap) )
		return

	if ( Hud_IsLocked( btn ) || !Hud_IsEnabled( btn ) )
		return

	BattlePassReward rewardFlav = file.rewardButtonToRewardFlavMap[btn]

	if ( ItemFlavor_GetType( rewardFlav.flav ) == eItemType.loadscreen )
	{
		EmitUISound( "UI_Menu_Accept" )
		LoadscreenPreviewMenu_SetLoadscreenToPreview( rewardFlav.flav )
		AdvanceMenu( GetMenu( "LoadscreenPreviewMenu" ) )
		return
	}
	else if ( ItemFlavor_GetType( rewardFlav.flav ) == eItemType.voucher )
	{
		return
	}
	else if ( InspectItemTypePresentationSupported( rewardFlav.flav ) )
	{
		EmitUISound( "UI_Menu_Accept" )
		RunClientScript( "ClearBattlePassItem" )
		SetTreasurePackItemPresentationModeActive( rewardFlav )
		return
	}
}

void function RewardButton_OnFocus ( var button )
{
	if ( !(button in file.rewardButtonToRewardFlavMap) )
		return

	if ( Hud_IsLocked( button ) || !Hud_IsEnabled( button ) && !file.isPrologueCompleted )
		return

	int challengeButton = int(Hud_GetScriptID( button ))

	int index = file.startAt + challengeButton
	index = (IsPeakingLeft())? index - PEAK_CHALLENGE_GROUPS_SHOWN: index

	if( file.chapters[index].isLocked || file.chapters[index].isTimeLocked )
		return

	file.rewardButtonIsFocused = true
	file.focusedObjectiveIndex = (IsPeakingLeft())? challengeButton: challengeButton - PEAK_CHALLENGE_GROUPS_SHOWN
}

void function RewardButton_OnUnFocus ( var button )
{
	if ( !(button in file.rewardButtonToRewardFlavMap) )
		return

	if ( Hud_IsLocked( button ) || !Hud_IsEnabled( button ) )
		return

	file.rewardButtonIsFocused = false
}

void function RVButton_OnActivate( var btn )
{
	if ( !(btn in file.rvButtonToRadioVignetteMap) )
		return

	if ( Hud_IsLocked( btn ) || !Hud_IsEnabled( btn ) )
		return

	RadioVignetteData data = file.rvButtonToRadioVignetteMap[btn]

	if ( data.radioVignette == "" || data.radioVignetteMilesEvent == "" )
		return

	file.savedEvent = file.event
	CloseActiveMenu()
	thread PlayVideoMenu( false, data.radioVignette, data.radioVignetteMilesEvent, eVideoSkipRule.INSTANT, Vignette_OnVideoComplete )
}

void function RVButton_OnFocus ( var button )
{
	if ( Hud_IsLocked( button ) || !Hud_IsEnabled( button ) )
		return

	int challengeButton = int(Hud_GetScriptID( button ))

	int index = file.startAt + challengeButton
	index = (IsPeakingLeft())? index - PEAK_CHALLENGE_GROUPS_SHOWN: index

	if( file.chapters[index].isLocked || file.chapters[index].isTimeLocked )
		return

	file.vignetteButtonIsFocused = true

	file.focusedObjectiveIndex = (IsPeakingLeft())? challengeButton: challengeButton - PEAK_CHALLENGE_GROUPS_SHOWN
}

void function RVButton_OnUnFocus ( var button )
{
	if ( Hud_IsLocked( button ) || !Hud_IsEnabled( button ) )
		return

	file.vignetteButtonIsFocused = false
}

void function Vignette_OnVideoComplete()
{
	if ( !IsConnected() )
		return

	file.event = file.savedEvent
	WaitFrame()
	AdvanceMenu( GetMenu( "StoryEventAboutDialog" ) )
}

void function ChallengeButton_OnFocus( var button )
{
	file.challengeButtonIsFocused = true
	int index = file.challengeButtons.find( button )
	file.focusedObjectiveIndex = file.startAt + index - PEAK_CHALLENGE_GROUPS_SHOWN

}

void function ChallengeButton_OnUnFocus( var button )
{
	file.challengeButtonIsFocused = false
	file.focusedObjectiveIndex = file.currentObjectiveIndex
}

void function PrologueButton_OnActivate( var btn )
{
	if ( Hud_IsLocked( btn ) || !Hud_IsEnabled( btn ) )
		return

	Remote_ServerCallFunction( "ClientCallback_MarkStoryPrologueCompleted", file.event._____INTERNAL_humanReadableRef )
	Remote_ServerCallFunction( "ClientCallback_RefereshEventChallenges" )
}

void function PlaylistChangeButton_OnActivate( var btn )
{
	if ( Hud_IsLocked( btn ) || !Hud_IsEnabled( btn ) || !IsPartyLeader() )
		return

	int index = file.playlistChallengeButtons.find( btn )
	int chapterIndex = file.startAt + (index - 1)

	if( chapterIndex < 0 )
		return

	string playlistName = file.chapters[chapterIndex].playlistName
	if( playlistName != "" )
	{
		Lobby_SetSelectedPlaylist( file.chapters[chapterIndex].playlistName )
		CloseActiveMenu()
	}
}

void function StoryAbout_OnNavigateLeft( var button ){
	if(file.startAt > 0 && file.isPrologueCompleted)
	{
		file.startAt--
		EmitUISound( "UI_Menu_BattlePass_Level_Focus" )

		if((file.challengeButtonIsFocused || file.rewardButtonIsFocused || file.vignetteButtonIsFocused) && !IsChapterTimeLocked( file.focusedObjectiveIndex - 1 ))
			file.focusedObjectiveIndex--
	}
}

void function StoryAbout_OnNavigateRight( var button ){
	if(file.startAt + (MAX_CHALLENGE_GROUPS_SHOWN )  < file.numVisibleChallenges && file.isPrologueCompleted)
	{
		file.startAt++
		EmitUISound( "UI_Menu_BattlePass_Level_Focus" )

		if((file.challengeButtonIsFocused || file.rewardButtonIsFocused || file.vignetteButtonIsFocused) && !IsChapterTimeLocked( file.focusedObjectiveIndex + 1 ))
			file.focusedObjectiveIndex++
	}
}

void function PlayChallengeFocusAudio()
{
	if(file.focusedObjectiveIndex != file.lastFocusedObjectiveIndex)
		PickChapterHoverAudio(file.focusedObjectiveIndex)
}

void function PickChapterHoverAudio(int index = 0)
{
	if(file.chapters.len() -1 >= index)
	{
		if(file.chapters[index].hasScreenshot)
			EmitUISound( "UI_Menu_StoryEvent_Level_FocusAnim" )
		else
			EmitUISound( "UI_Menu_StoryEvent_Level_Focus" )
	}
}

bool function IsStoryComplete( entity player ){
	return StoryEvent_GetChaptersProgress( player, file.event ) / StoryEvent_GetChaptersCount( file.event  ) >= 1.0
}

void function AddStoryTrackerPinEvent( int panelIndex, int previousPanelIndex )
{
	if ( !IsConnected() )
		return

	string eventName = ItemFlavor_GetHumanReadableRef(file.event);
	string currentID  = panelIndex == -1 ? "none" : eventName + "_panel" + panelIndex
	string previousID = previousPanelIndex == -1 ? "none" : eventName + "_panel" + previousPanelIndex

	float timeToRead = UITime() - file.pin_viewStartTime

	PIN_StoryTrackerPageView( currentID, previousID, timeToRead )

	file.pin_viewStartTime = UITime()
}
