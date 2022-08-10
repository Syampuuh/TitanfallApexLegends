#if SERVER || CLIENT || UI
global function StoryChallengeEvents_Init
global function GetActiveStoryChallengeEvents
global function GetStoryChallengeEventIfActive
global function StoryChallengeEvent_GetStoryChallengesForPlayer
global function StoryChallengeEvent_GetActiveChallengesForPlayer
global function StoryChallengeEvent_IsChallengeAvailableForPlayer
global function StoryChallengeEvent_HasChallengesPopupBeenSeen
global function StoryChallengeEvent_GetHasChallengesPopupBeenSeenVarNameOrNull
global function StoryChallengeEvent_GetAutoplayDialogueDataForPlayer
global function StoryChallengeEvent_GetNonAutoplayDialogueDataForPlayer

global function StoryEvent_GetCurrentChapterChallenges
global function StoryEvent_GetChapters
global function StoryEvent_GetChaptersProgress
global function StoryEvent_GetActiveChapter
global function StoryEvent_GetChaptersCount
global function StoryEvent_GetChapterIsPrologue
global function StoryChallengeEvent_IsPrologueCompleted
global function StoryEvent_GetShowInChallengeBoxBool
global function StoryEvent_GetRadioVignetteBink
global function StoryEvent_GetRadioVignetteMilesEvent
#endif

#if SERVER
                                                           
#endif

#if UI
global function StoryEvent_GetHeaderIcon
global function StoryEvent_GetChapterHeaderImage
global function StoryEvent_GetChapterAboutBgImage
global function StoryEvent_OnLobbyPlayPanelSpecialChallengeClicked
global function StoryEvent_GetChapterTagString
global function StoryEvent_GetCompletionReward
global function StoryEvent_GetPrologueLobbyDesc
global function StoryEvent_GetPlaylistName
global function StoryEvent_PlayRadioVignetteForChapter
#endif
                       
                       
                       
                       
                       

#if SERVER
                                                         
#endif

#if SERVER || CLIENT || UI
global struct StoryEventRadioVignetteData
{
	string ornull	  radioVignetteBinkOrNull
	string ornull	  radioVignetteMilesOrNull
}

global struct StoryEventGroupChallengeData
{
	array<ItemFlavor> challengeFlavors
	string ornull     persistenceVarNameToUnlockOrNull
	int           	  persistenceVarCountToUnlock
	string ornull     persistenceVarNameHasSeenOrNull
	int               requiredStartDateUnixTime = -1
	bool			  isPrologue
	string ornull	  persistenceVarNamePrologueOrNull

	StoryEventRadioVignetteData vignetteData
}
#endif


#if SERVER || CLIENT || UI
global struct StoryEventDialogueData
{
	string        bodyText
	string        speakerName
	float         duration
	asset         speakerIcon
	string ornull persistenceVarNameToUnlockOrNull
	int           persistenceVarCountToUnlock
	string ornull persistenceVarNameHasSeenOrNull
	string ornull persistenceVarNameToHideOrNull
	int			  persistenceVarCountToHide
	array<string> audioAliases
	bool		  autoPlay = true


}
#endif


#if SERVER || CLIENT || UI
struct FileStruct_LifetimeLevel
{
	table< ItemFlavor, array<StoryEventGroupChallengeData> > eventChallengesDataMap
	table< ItemFlavor, array<StoryEventDialogueData> >       eventDialogueDataMap
	table< ItemFlavor, StoryEventGroupChallengeData >        challengeToEventDataMap
}
#endif
#if SERVER || CLIENT
FileStruct_LifetimeLevel fileLevel                             
#elseif UI
FileStruct_LifetimeLevel& fileLevel                             

struct {
	  
} fileVM                            
#endif




                         
                         
                         
                         
                         

#if SERVER || CLIENT || UI
void function StoryChallengeEvents_Init()
{
	#if UI
		FileStruct_LifetimeLevel newFileLevel
		fileLevel = newFileLevel
	#endif

	AddCallback_OnItemFlavorRegistered( eItemType.calevent_story_challenges, void function( ItemFlavor ev ) {
		             
		int challengeSortOrdinal = 1
		array<StoryEventGroupChallengeData> challengeGroupDatas
		bool hasPrologue = false

		foreach ( var challengeGroupBlock in IterateSettingsAssetArray( ItemFlavor_GetAsset( ev ), "challengeGroups" ) )
		{
			StoryEventGroupChallengeData data

			string persistenceVarNameToUnlock = GetSettingsBlockString( challengeGroupBlock, "requiredChallengesPersistentVarName" )
			string persistenceVarNameHasSeen  = GetSettingsBlockString( challengeGroupBlock, "hasSeenChallengesPersistentVarName" )
			string requiredStartDate          = GetSettingsBlockString( challengeGroupBlock, "requiredStartTime" )
			data.persistenceVarCountToUnlock = GetSettingsBlockInt( challengeGroupBlock, "requiredChallengesPersistentVarNameCount" )
			data.isPrologue					= GetSettingsBlockBool( challengeGroupBlock, "isPrologue" )

			                         
			if ( persistenceVarNameToUnlock != "" )
			{
				Assert( PersistenceGetVarHandle( persistenceVarNameToUnlock ) != null, "Invalid challenge required persistence variable name: " + persistenceVarNameToUnlock )
				data.persistenceVarNameToUnlockOrNull = persistenceVarNameToUnlock
			}
			else
			{
				data.persistenceVarNameToUnlockOrNull = null
			}

			                           
			if ( persistenceVarNameHasSeen != "" )
			{
				Assert( PersistenceGetVarHandle( persistenceVarNameHasSeen ) != null, "Invalid challenge required persistence variable name: " + persistenceVarNameHasSeen )
				data.persistenceVarNameHasSeenOrNull = persistenceVarNameHasSeen
			}
			else
			{
				data.persistenceVarNameHasSeenOrNull = null
			}

			                      
			if ( requiredStartDate != "" )
			{
				int ornull requiredStartDateUnixTimeOrNull = DateTimeStringToUnixTimestamp( requiredStartDate )
				if ( requiredStartDateUnixTimeOrNull != null )
				{
					data.requiredStartDateUnixTime = expect int( requiredStartDateUnixTimeOrNull )
				}
				else
				{
					Assert( requiredStartDateUnixTimeOrNull != null, "Invalid challenge group required start time: " + requiredStartDate )
				}
			}

			if ( data.isPrologue )
			{
				Assert( !hasPrologue, "Cannot have more than one prologue" )
				string prologuePersistentVarName = GetSettingsBlockString( challengeGroupBlock, "prologuePersistentVarName" )
				Assert( prologuePersistentVarName != "", "Cannot have a prologue step without prologuePersistentVarName" )
				Assert( PersistenceGetVarHandle( prologuePersistentVarName ) != null, "Invalid prologuePersistentVarName for prologue: " + persistenceVarNameHasSeen )
				data.persistenceVarNamePrologueOrNull = prologuePersistentVarName
				hasPrologue = true
				challengeGroupDatas.append( data )
			}
			else
			{
				                                 
				foreach ( var challengeBlock in IterateSettingsArray( GetSettingsBlockArray( challengeGroupBlock, "challenges" ) ) )
				{
					ItemFlavor ornull challengeFlavOrNull = RegisterItemFlavorFromSettingsAsset( GetSettingsBlockAsset( challengeBlock, "challengeFlav" ) )
					if ( challengeFlavOrNull != null )
					{
						ItemFlavor challengeFlav = expect ItemFlavor( challengeFlavOrNull )

						RegisterChallengeSource( challengeFlav, ev, challengeSortOrdinal )
						challengeSortOrdinal++

						data.challengeFlavors.append( challengeFlav )
						fileLevel.challengeToEventDataMap[ challengeFlav ] <- data
					}
					else Warning( "StoryChallenge event '%s' refers to bad challenge asset: %s", ItemFlavor_GetHumanReadableRef( ev ), string( GetSettingsBlockAsset( challengeBlock, "flavor" ) ) )
				}

				if ( data.challengeFlavors.len() > 0 )
				{
					challengeGroupDatas.append( data )
				}
				else Warning( "StoryChallenge event '%s' has a group with no valid challenges", ItemFlavor_GetHumanReadableRef( ev ) )
			}
		}

		fileLevel.eventChallengesDataMap[ev] <- challengeGroupDatas

		                    
		array<StoryEventDialogueData> dialogueDatas

		foreach ( var dialogueBlock in IterateSettingsAssetArray( ItemFlavor_GetAsset( ev ), "dialogueMessages" ) )
		{
			StoryEventDialogueData data
			data.bodyText = GetSettingsBlockString( dialogueBlock, "dialogueBodyText" )
			data.speakerName = GetSettingsBlockString( dialogueBlock, "dialogueSpeakerName" )
			data.duration = GetSettingsBlockFloat( dialogueBlock, "dialogueDuration" )
			data.speakerIcon = GetSettingsBlockAsset( dialogueBlock, "dialogueSpeakerIcon" )

			string persistenceVarNameToUnlock = GetSettingsBlockString( dialogueBlock, "dialoguePersistentVarNameToUnlock" )
			data.persistenceVarCountToUnlock = GetSettingsBlockInt( dialogueBlock, "dialoguePersistentVarNameToUnlockCount" )
			string persistenceVarNameHasSeen = GetSettingsBlockString( dialogueBlock, "dialoguePersistentVarNameHasSeen" )
			string persistenceVarNameToHide  = GetSettingsBlockString( dialogueBlock, "dialoguePersistentVarNameToHide" )
			data.autoPlay = GetSettingsBlockBool( dialogueBlock, "dialogueAutoPlay" )
			data.persistenceVarCountToHide = GetSettingsBlockInt( dialogueBlock, "dialoguePersistentVarNameToHideCount" )

			                         
			if ( persistenceVarNameToUnlock != "" )
			{
				Assert( PersistenceGetVarHandle( persistenceVarNameToUnlock ) != null, "Invalid dialogue message persistence var name to unlock: " + persistenceVarNameToUnlock )
				data.persistenceVarNameToUnlockOrNull = persistenceVarNameToUnlock
			}
			else
			{
				data.persistenceVarNameToUnlockOrNull = null
			}

			                           
			if ( persistenceVarNameHasSeen != "" )
			{
				Assert( PersistenceGetVarHandle( persistenceVarNameHasSeen ) != null, "Invalid dialogue message persistence var name to hide: " + persistenceVarNameHasSeen )
				data.persistenceVarNameHasSeenOrNull = persistenceVarNameHasSeen
			}
			else
			{
				data.persistenceVarNameHasSeenOrNull = null
			}

			                              
			if ( persistenceVarNameToHide != "" )
			{
				Assert( PersistenceGetVarHandle( persistenceVarNameToHide ) != null, "Invalid dialogue message persistence var name to hide: " + persistenceVarNameToHide )
				data.persistenceVarNameToHideOrNull = persistenceVarNameToHide
			}
			else
			{
				data.persistenceVarNameToHideOrNull = null
			}

			float soundDuration = 0.0
			foreach ( var audioBlock in IterateSettingsArray( GetSettingsBlockArray( dialogueBlock, "dialogueAudioAliases" ) ) )
			{
				string dialogueAlias = GetSettingsBlockString( audioBlock, "dialogueAudioAlias" )

				#if CLIENT || UI
					if ( dialogueAlias != "" )
					{
						soundDuration += GetSoundDuration( dialogueAlias )
						data.audioAliases.append( dialogueAlias )
					}
				#endif
			}

			#if CLIENT || UI
				if ( soundDuration > 0.0 )
					data.duration = soundDuration
			#endif

			dialogueDatas.append( data )
		}

		fileLevel.eventDialogueDataMap[ev] <- dialogueDatas
	} )
}
#endif



                          
                          
                          
                          
                          

#if SERVER || CLIENT || UI
array<ItemFlavor> function GetActiveStoryChallengeEvents( int t )
{
	Assert( IsItemFlavorRegistrationFinished() )
	array<ItemFlavor> events
	foreach ( ItemFlavor ev in GetAllItemFlavorsOfType( eItemType.calevent_story_challenges ) )
	{
		if ( !CalEvent_IsActive( ev, t ) )
			continue

		events.push( ev )
	}
	return events
}

ItemFlavor ornull function GetStoryChallengeEventIfActive( int t, string challenge_name )
{
	Assert( IsItemFlavorRegistrationFinished() )
	foreach ( ItemFlavor ev in GetAllItemFlavorsOfType( eItemType.calevent_story_challenges ) )
	{
		if ( ItemFlavor_GetHumanReadableRef( ev ) == challenge_name )
		{
			if ( CalEvent_IsActive( ev, t ) )
			{
				return ev
			}
			return null
		}
	}
	return null
}
#endif


#if SERVER || CLIENT || UI
array<ItemFlavor> function StoryChallengeEvent_GetStoryChallengesForPlayer( ItemFlavor event, entity player )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_story_challenges )

	array<ItemFlavor> appropriateChallenges

	if ( !CalEvent_IsActive( event, GetUnixTimestamp() ) )
		return appropriateChallenges

	foreach ( StoryEventGroupChallengeData groupData in fileLevel.eventChallengesDataMap[ event ] )
	{
		appropriateChallenges.extend( groupData.challengeFlavors )
	}

	return appropriateChallenges
}
#endif

#if SERVER || CLIENT || UI
array<ItemFlavor> function StoryChallengeEvent_GetActiveChallengesForPlayer( ItemFlavor event, entity player )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_story_challenges )

	array<ItemFlavor> appropriateChallenges

	foreach ( StoryEventGroupChallengeData groupData in fileLevel.eventChallengesDataMap[ event ] )
	{
		bool challengesGroupIsUnlockedFromPersistence = groupData.persistenceVarNameToUnlockOrNull == null || player.GetPersistentVarAsInt( expect string( groupData.persistenceVarNameToUnlockOrNull ) ) >= groupData.persistenceVarCountToUnlock

		if ( !challengesGroupIsUnlockedFromPersistence )
			continue

		bool challengesGroupIsUnlockedFromDate = groupData.requiredStartDateUnixTime < UNIX_TIME_FALLBACK_1970 || GetUnixTimestamp() >= groupData.requiredStartDateUnixTime

		if ( !challengesGroupIsUnlockedFromDate )
			continue

		appropriateChallenges.extend( groupData.challengeFlavors )
	}

	return appropriateChallenges
}
#endif

#if SERVER || CLIENT || UI
bool function StoryChallengeEvent_IsChallengeAvailableForPlayer( ItemFlavor event, ItemFlavor challenge, entity player )
{
	if ( !(challenge in fileLevel.challengeToEventDataMap) )
		return false

	StoryEventGroupChallengeData data = fileLevel.challengeToEventDataMap[ challenge ]
	bool challengesGroupIsUnlockedFromDate = data.requiredStartDateUnixTime < UNIX_TIME_FALLBACK_1970 || GetUnixTimestamp() >= data.requiredStartDateUnixTime

	if ( !challengesGroupIsUnlockedFromDate )
		return false

	return true
}
#endif

#if UI
void function StoryEvent_PlayRadioVignetteForChapter( int chapter )
{
	                                                                                   
	ItemFlavor event = GetItemFlavorByHumanReadableRef( "calevent_s12e04_s12e04_story_challenges" )
	var challengeGroupBlock  = StoryEvent_GetChapters( event )[chapter]
	string radioVignetteBink = StoryEvent_GetRadioVignetteBink ( challengeGroupBlock )
	string radioVignetteMiles = StoryEvent_GetRadioVignetteMilesEvent ( challengeGroupBlock )

	thread PlayVideoMenu( false, radioVignetteBink, radioVignetteMiles, eVideoSkipRule.INSTANT, StoryEvent_OnRadioVignetteFinished )
}

void function StoryEvent_OnRadioVignetteFinished()
{
	Remote_ServerCallFunction( "StoryEvent_OnRadioVignetteFinishedLobbyKick" )
}
#endif

#if SERVER
                                                                          
 
	                            
	 
		                                  
	 
	    
	 
		                           
		                                
	 
 
#endif

#if SERVER
                                                                                               
 
	                          
		      

	                                                                                                               
	                                     
	 
		                                                                                                                     
		      
	 

	                                                                                                                                   
	 
		                            
			        

		                                                                                                                                                                                                                                          

		                                                
			        

		                                                                                                                                                                   

		                                         
			        

		                                                         
		 
			                                                                                                                         
			     
		 

		                                                                                        
		                                                   
	 

 
#endif


#if SERVER || CLIENT || UI
bool function StoryChallengeEvent_HasChallengesPopupBeenSeen( ItemFlavor challenge, entity player )
{
	Assert( ItemFlavor_GetType( challenge ) == eItemType.challenge )

	StoryEventGroupChallengeData data = fileLevel.challengeToEventDataMap[ challenge ]

	if ( data.persistenceVarNameHasSeenOrNull != null && player.GetPersistentVarAsInt( expect string ( data.persistenceVarNameHasSeenOrNull ) ) > 0 )
		return true

	return false
}
#endif


#if SERVER || CLIENT || UI
string ornull function StoryChallengeEvent_GetHasChallengesPopupBeenSeenVarNameOrNull( ItemFlavor challenge, entity player )
{
	Assert( ItemFlavor_GetType( challenge ) == eItemType.challenge )

	StoryEventGroupChallengeData data = fileLevel.challengeToEventDataMap[ challenge ]

	return data.persistenceVarNameHasSeenOrNull
}
#endif


#if SERVER || CLIENT || UI
                              
array<StoryEventDialogueData> function StoryChallengeEvent_GetAutoplayDialogueDataForPlayer( ItemFlavor event, entity player )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_story_challenges )

	array<StoryEventDialogueData> appropriateDialogueDatas

	foreach ( StoryEventDialogueData data in fileLevel.eventDialogueDataMap[ event ] )
	{
		if ( !data.autoPlay )
			continue

		bool isUnlocked = data.persistenceVarNameToUnlockOrNull == null || player.GetPersistentVarAsInt( expect string( data.persistenceVarNameToUnlockOrNull ) ) >= data.persistenceVarCountToUnlock

		bool shouldHide = data.persistenceVarNameToHideOrNull != null && player.GetPersistentVarAsInt( expect string( data.persistenceVarNameToHideOrNull ) ) >= data.persistenceVarCountToHide

		if ( !isUnlocked || shouldHide )
			continue

		appropriateDialogueDatas.append( data )
	}

	return appropriateDialogueDatas
}
#endif                          


#if SERVER || CLIENT || UI
                                  
StoryEventDialogueData function StoryChallengeEvent_GetNonAutoplayDialogueDataForPlayer( ItemFlavor event, entity player )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_story_challenges )

	foreach ( StoryEventDialogueData data in fileLevel.eventDialogueDataMap[ event ] )
	{
		if ( data.autoPlay )
			continue

		bool isUnlocked = data.persistenceVarNameToUnlockOrNull == null || player.GetPersistentVarAsInt( expect string( data.persistenceVarNameToUnlockOrNull ) ) >= data.persistenceVarCountToUnlock

		bool shouldHide = data.persistenceVarNameToHideOrNull != null && player.GetPersistentVarAsInt( expect string( data.persistenceVarNameToHideOrNull ) ) >= data.persistenceVarCountToHide

		if ( !isUnlocked || shouldHide )
			continue

		return data
	}


	StoryEventDialogueData emptyStoryEventDialogueData
	return emptyStoryEventDialogueData
}

array<ItemFlavor> function StoryEvent_GetCurrentChapterChallenges( entity player, ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_story_challenges )

	array<ItemFlavor> result
	                 
	var challengeGroupBlock  = StoryEvent_GetChapters( event )[StoryEvent_GetActiveChapter( player, event )]

	foreach ( var challenges in IterateSettingsArray( GetSettingsBlockArray( challengeGroupBlock, "challenges" ) ) )
	{
		ItemFlavor ornull challengeFlavOrNull = RegisterItemFlavorFromSettingsAsset( GetSettingsBlockAsset( challenges, "challengeFlav" ) )
		ItemFlavor challengeFlav = expect ItemFlavor( challengeFlavOrNull )

		result.append(challengeFlav)
	}
	return result
}

array function StoryEvent_GetChapters( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_story_challenges )
	return IterateSettingsAssetArray( ItemFlavor_GetAsset( event ), "challengeGroups" )
}

int function StoryEvent_GetChaptersCount( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_story_challenges )
	return StoryEvent_GetChapters(event).len()
}

int function StoryEvent_GetChaptersProgress( entity player, ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_story_challenges )

	if ( !IsValid ( player ) )
		return 0

	int chapter = 0
	array chapters = StoryEvent_GetChapters(event)

	foreach ( int idx, var challengeGroupBlock in chapters )
	{
		int completedChallenges = 0
		array challenges  = IterateSettingsArray( GetSettingsBlockArray( challengeGroupBlock, "challenges" ) )
		string requiredStartDate  = GetSettingsBlockString( challengeGroupBlock, "requiredStartTime" )


		int ornull requiredStartDateUnixTimeOrNull = DateTimeStringToUnixTimestamp( requiredStartDate )

		if ( requiredStartDateUnixTimeOrNull == null )
			Assert( 0, "Null value in playlist for setting 'requiredStartTime'" )

		expect int( requiredStartDateUnixTimeOrNull )

		if ( requiredStartDateUnixTimeOrNull < UNIX_TIME_FALLBACK_1970 || GetUnixTimestamp() >= requiredStartDateUnixTimeOrNull )
		{
			if(StoryEvent_GetChapterIsPrologue( chapters[idx] ))
			{
				if( StoryEvent_GetChapterPrologueCompleteBool( player, chapters[idx]) )
					chapter++
			}
			else if(chapter == idx)
			{
				foreach ( var challengeBlock in challenges )
				{
					ItemFlavor ornull challengeFlavOrNull = RegisterItemFlavorFromSettingsAsset( GetSettingsBlockAsset( challengeBlock, "challengeFlav" ) )
					if ( challengeFlavOrNull != null )
					{
						ItemFlavor challengeFlav = expect ItemFlavor( challengeFlavOrNull )
						if( DoesPlayerHaveChallenge( player, challengeFlav ))
						{
							if ( Challenge_IsComplete( player, challengeFlav ) )
								completedChallenges++
						}
					}
					else Warning( "StoryChallenge event '%s' refers to bad challenge asset: %s", ItemFlavor_GetHumanReadableRef( event ), string( GetSettingsBlockAsset( challengeBlock, "flavor" ) ) )

					if(completedChallenges >= challenges.len())
						chapter++
				}
			}
		}
	}

	return chapter
}

int function StoryEvent_GetActiveChapter( entity player, ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_story_challenges )
	if ( !IsValid ( player ) )
		return 0

	int chapter = 0
	array chapters = StoryEvent_GetChapters(event)

	foreach ( int idx, var challengeGroupBlock in chapters )
	{
		int completedChallenges = 0
		array challenges  = IterateSettingsArray( GetSettingsBlockArray( challengeGroupBlock, "challenges" ) )
		string requiredStartDate  = GetSettingsBlockString( challengeGroupBlock, "requiredStartTime" )
		int ornull requiredStartDateUnixTimeOrNull = DateTimeStringToUnixTimestamp( requiredStartDate )

		if ( requiredStartDateUnixTimeOrNull == null )
			Assert( 0, "Null value in playlist for setting 'requiredStartTime'" )

		expect int( requiredStartDateUnixTimeOrNull )

		if ( requiredStartDateUnixTimeOrNull < UNIX_TIME_FALLBACK_1970 || GetUnixTimestamp() >= requiredStartDateUnixTimeOrNull )
		{

			if(StoryEvent_GetChapterIsPrologue( chapters[idx] ))
			{
				if( StoryEvent_GetChapterPrologueCompleteBool( player, chapters[idx]) )
				{
					chapter++
				}
			}
			else if(chapter == idx)
			{

				foreach ( var challengeBlock in challenges )
				{
					ItemFlavor ornull challengeFlavOrNull = RegisterItemFlavorFromSettingsAsset( GetSettingsBlockAsset( challengeBlock, "challengeFlav" ) )
					if ( challengeFlavOrNull != null )
					{
						ItemFlavor challengeFlav = expect ItemFlavor( challengeFlavOrNull )
						if( DoesPlayerHaveChallenge( player, challengeFlav ) ){
							if ( Challenge_IsComplete( player, challengeFlav ) )
								completedChallenges++
						}
					}
					else
						Warning( "StoryChallenge event '%s' refers to bad challenge asset: %s", ItemFlavor_GetHumanReadableRef( event ), string( GetSettingsBlockAsset( challengeBlock, "flavor" ) ) )

					if ( completedChallenges >= challenges.len() )
					{
						chapter++
					}
				}
			}

		}
		else if(idx == chapter )
		{
			chapter = int( max(chapter - 1 , 0.0) )
			break
		}
	}

	             
	if(chapter >= chapters.len())
		chapter = chapters.len() -1

	return chapter
}
bool function StoryEvent_GetChapterIsPrologue ( var chapter )
{
	return GetSettingsBlockBool( chapter, "isPrologue" )
}
bool function StoryEvent_GetChapterPrologueCompleteBool ( entity player, var chapter )
{
	if ( !IsValid ( player ) )
		return false

	if( !StoryEvent_GetChapterIsPrologue( chapter ) )
		return true
	else
		return (player.GetPersistentVarAsInt(GetSettingsBlockString( chapter, "prologuePersistentVarName" )) == 0)? false: true

	return false
}
bool function StoryChallengeEvent_IsPrologueCompleted( entity player, ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_story_challenges )

	if ( !IsValid ( player ) )
		return false

	array chapters = StoryEvent_GetChapters( event )
	int activeChapter = StoryEvent_GetActiveChapter( player, event )

	if( chapters.len() > 0 ){
		return StoryEvent_GetChapterPrologueCompleteBool( player,chapters[activeChapter])
	}

	return false
}
bool function StoryEvent_GetShowInChallengeBoxBool ( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_story_challenges )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( event ), "showInChallengeBox" )
}
string function StoryEvent_GetRadioVignetteBink ( var chapter )
{
	return GetSettingsBlockString( chapter, "radioVignetteBk" )
}
string function StoryEvent_GetRadioVignetteMilesEvent ( var chapter )
{
	return GetSettingsBlockString( chapter, "radioVignetteMilesEvent" )
}
#endif                          


#if UI
ItemFlavorBag function StoryEvent_GetCompletionReward( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_story_challenges )

	ItemFlavorBag rewards

	asset rewardAsset = GetGlobalSettingsAsset( ItemFlavor_GetAsset(event), "storyCompletionFlavor" )
	if ( !IsValidItemFlavorSettingsAsset( rewardAsset ) )
	{
		Warning( "Skipping completion reward  of story event")
	}
	else
	{
		rewards.flavors.append( GetItemFlavorByAsset( rewardAsset ) )
		rewards.quantities.append( GetGlobalSettingsInt( ItemFlavor_GetAsset( event ), "storyCompletionQuantity" ) )
	}
	return rewards
}
string function StoryEvent_GetPrologueLobbyDesc ( var chapter )
{
	Assert( StoryEvent_GetChapterIsPrologue(chapter) )
	return GetSettingsBlockString( chapter, "prologueLobbyDesc" )
}
string function StoryEvent_GetPlaylistName ( var chapter )
{
	return GetSettingsBlockString( chapter, "playlistName" )
}
asset function StoryEvent_GetHeaderIcon( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_story_challenges )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "headerIcon" )
}
asset function StoryEvent_GetChapterHeaderImage( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_story_challenges )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "eventChallengeHeaderImage" )
}

asset function StoryEvent_GetChapterAboutBgImage( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_story_challenges )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "storyEventAboutHeroImage" )
}

void function StoryEvent_OnLobbyPlayPanelSpecialChallengeClicked( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_story_challenges )

	Assert( IsLobby() )
	Assert( IsFullyConnected() )
	Assert( GetActiveMenu() == GetMenu( "LobbyMenu" ) )
	Assert( IsTabPanelActive( GetPanel( "PlayPanel" ) ) )

	StoryEventAboutDialog_SetEvent( event )
	AdvanceMenu( GetMenu( "StoryEventAboutDialog" ) )
}
string function StoryEvent_GetChapterTagString( ItemFlavor event, int idx )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_story_challenges )

	if( idx == 0 )
		return "#CHALLENGE_TAG_PROLOGUE"
	else if( idx == StoryEvent_GetChaptersCount(event) - 1 )
		return "#CHALLENGE_TAG_FINALE"
	else
		return "#CHALLENGE_TAG_MISSION"

	return ""
}
#endif
