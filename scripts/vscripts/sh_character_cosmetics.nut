global function ShCharacterCosmetics_LevelInit

global function Loadout_CharacterSkin
global function Loadout_CharacterExecution
global function Loadout_CharacterIntroQuip
global function Loadout_CharacterKillQuip
#if SERVER || CLIENT
global function PlayIntroQuipThread
global function PlayKillQuipThread
#endif
global function CharacterExecution_IsNotEquippable
global function CharacterExecution_ShouldHideIfNotEquippable
global function CharacterExecution_GetCharacterFlavor
global function CharacterExecution_GetAttackerAnimSeq
global function CharacterExecution_GetVictimAnimSeq
global function CharacterExecution_GetExecutionVideo
global function CharacterExecution_GetAttackerPreviewAnimSeq
global function CharacterExecution_GetVictimPreviewAnimSeq
global function CharacterExecution_GetSortOrdinal
global function CharacterExecution_GetVictimOverrideExecution
global function CharacterClass_GetDefaultSkin
global function CharacterSkin_GetCharacterFlavor
global function CharacterSkin_GetBodyModel
global function CharacterSkin_GetArmsModel
global function CharacterSkin_GetSkinName
global function CharacterSkin_GetCamoIndex
global function CharacterSkin_GetSortOrdinal
global function CharacterSkin_GetCustomCharSelectIntroAnim
global function CharacterSkin_GetCustomCharSelectIdleAnim
global function CharacterSkin_GetCustomCharSelectReadyIntroAnim
global function CharacterSkin_GetCustomCharSelectReadyIdleAnim
global function CharacterSkin_HasCustomCharSelectAnims
global function CharacterSkin_GetMenuCustomLightData
global function CharacterSkin_HasMenuCustomLighting
global function CharacterSkin_GetCharacterSelectLabelColorOverride
global function CharacterSkin_HasStoryBlurb
global function CharacterSkin_GetStoryBlurbBodyText
global function CharacterSkin_GetSubQuality
global function CharacterKillQuip_GetCharacterFlavor
global function CharacterEmoteIcon_GetCharacterFlavor
global function CharacterKillQuip_GetVictimVoiceSoundEvent
global function CharacterKillQuip_GetStingSound
global function CharacterKillQuip_GetSortOrdinal
global function CharacterIntroQuip_GetCharacterFlavor
global function CharacterIntroQuip_GetVoiceSoundEvent
global function CharacterIntroQuip_GetStingSoundEvent
global function CharacterIntroQuip_GetSortOrdinal
#if SERVER || CLIENT
global function CharacterSkin_Apply
global function CharacterSkin_WaitForAndApplyFromLoadout
#endif

#if CLIENT
global function CharacterSkin_CheckBloodhoundRavenSkin
#endif

#if CLIENT || UI
global function CharacterSkin_ShouldHideIfLocked
#endif

#if DEV && CLIENT
global function DEV_TestCharacterSkinData
#endif

#if DEV && UI
       
                                          
      
#endif

                      
                      
                      
                      
                      
  

global const int MAX_FAVORITE_SKINS = 8

#if DEV
       
                                                                                                   
      
#endif

                       
                       
                       
                       
                       
struct FileStruct_LifetimeLevel
{
	table<ItemFlavor, LoadoutEntry>                     loadoutCharacterSkinSlotMap
	table<ItemFlavor, LoadoutEntry>                     loadoutCharacterExecutionSlotMap
	table<ItemFlavor, LoadoutEntry>                     loadoutCharacterIntroQuipSlotMap
	table<ItemFlavor, LoadoutEntry>                     loadoutCharacterKillQuipSlotMap

	table<ItemFlavor, ItemFlavor> defaultSkins

	table<ItemFlavor, int> cosmeticFlavorSortOrdinalMap
}
FileStruct_LifetimeLevel& fileLevel


                        
                        
                        
                        
                        
void function ShCharacterCosmetics_LevelInit()
{
	FileStruct_LifetimeLevel newFileLevel
	fileLevel = newFileLevel

	AddCallback_OnItemFlavorRegistered( eItemType.character, OnItemFlavorRegistered_Character )
}


void function OnItemFlavorRegistered_Character( ItemFlavor characterClass )
{
	        
	{
		array<ItemFlavor> skinList = RegisterReferencedItemFlavorsFromArray( characterClass, "skins", "flavor" )
		foreach( ItemFlavor skin in skinList )
		{
			SetupCharacterSkin( skin )

			if ( characterClass != GetItemFlavorByAsset( CHARACTER_RANDOM ) && !( characterClass in fileLevel.defaultSkins ) && !ItemFlavor_IsTheFavoriteSentinel( skin ) )
				fileLevel.defaultSkins[characterClass] <- skin
		}
		Assert( characterClass == GetItemFlavorByAsset( CHARACTER_RANDOM ) || characterClass in fileLevel.defaultSkins, "No default skin found for: " + ItemFlavor_GetHumanReadableRef( characterClass ) )

		MakeItemFlavorSet( skinList, fileLevel.cosmeticFlavorSortOrdinalMap )

		LoadoutEntry entry = RegisterLoadoutSlot( eLoadoutEntryType.ITEM_FLAVOR, "character_skin_for_" + ItemFlavor_GetGUIDString( characterClass ) )
		entry.pdefSectionKey = "character " + ItemFlavor_GetGUIDString( characterClass )
		entry.DEV_category = "character_skins"
		entry.DEV_name = ItemFlavor_GetHumanReadableRef( characterClass ) + " Skin"
		entry.stryderCharDataArrayIndex = ePlayerStryderCharDataArraySlots.CHARACTER_SKIN
		entry.defaultItemFlavor = skinList[1]
		entry.favoriteItemFlavor = skinList[0]
		entry.validItemFlavorList = skinList
		entry.maxFavoriteCount = 8
		entry.isSlotLocked = bool function( EHI playerEHI ) {
			#if SERVER
				                                              
					                                                              
			#endif          
				return !IsLobby()
		}
		entry.isActiveConditions = { [Loadout_Character()] = { [characterClass] = true, }, }
		entry.networkTo = eLoadoutNetworking.PLAYER_GLOBAL
		entry.networkVarName = "CharacterSkin"
		#if CLIENT
			if ( IsLobby() )
			{
				AddCallback_ItemFlavorLoadoutSlotDidChange_AnyPlayer( entry, void function( EHI playerEHI, ItemFlavor skin ) {
					UpdateMenuCharacterModel( FromEHI( playerEHI ) )
				} )
			}
		#endif
		fileLevel.loadoutCharacterSkinSlotMap[characterClass] <- entry
	}

	             
	{
		array<ItemFlavor> executionsList = RegisterReferencedItemFlavorsFromArray( characterClass, "executions", "flavor" )

		MakeItemFlavorSet( executionsList, fileLevel.cosmeticFlavorSortOrdinalMap )

		LoadoutEntry entry = RegisterLoadoutSlot( eLoadoutEntryType.ITEM_FLAVOR, "character_execution_for_" + ItemFlavor_GetGUIDString( characterClass ) )
		entry.pdefSectionKey = "character " + ItemFlavor_GetGUIDString( characterClass )
		entry.DEV_category = "character_executions"
		entry.DEV_name = ItemFlavor_GetHumanReadableRef( characterClass ) + " Execution"
		entry.defaultItemFlavor = executionsList[0]
		entry.validItemFlavorList = executionsList
		entry.isSlotLocked = bool function( EHI playerEHI ) {
			return !IsLobby()
		}
		entry.isItemFlavorUnlocked = (bool function( EHI playerEHI, ItemFlavor execution, bool shouldIgnoreGRX = false, bool shouldIgnoreOtherSlots = false ) {
			if( GetGlobalSettingsBool( ItemFlavor_GetAsset( execution ) , "isNotEquippable" ) )
				return false
			return IsItemFlavorGRXUnlockedForLoadoutSlot( playerEHI, execution, shouldIgnoreGRX, shouldIgnoreOtherSlots )
		})
		entry.isActiveConditions = { [Loadout_Character()] = { [characterClass] = true, }, }
		entry.networkTo = eLoadoutNetworking.PLAYER_EXCLUSIVE
		fileLevel.loadoutCharacterExecutionSlotMap[characterClass] <- entry
	}

	array<ItemFlavor> allEmotes

	              
	{
		array<ItemFlavor> quipList = RegisterReferencedItemFlavorsFromArray( characterClass, "introQuips", "flavor" )
		MakeItemFlavorSet( quipList, fileLevel.cosmeticFlavorSortOrdinalMap )

		LoadoutEntry entry = RegisterLoadoutSlot( eLoadoutEntryType.ITEM_FLAVOR, "character_intro_quip_for_" + ItemFlavor_GetGUIDString( characterClass ) )
		entry.pdefSectionKey = "character " + ItemFlavor_GetGUIDString( characterClass )
		entry.DEV_category = "character_intro_quips"
		entry.DEV_name = ItemFlavor_GetHumanReadableRef( characterClass ) + " Intro Quip"
		entry.stryderCharDataArrayIndex = ePlayerStryderCharDataArraySlots.CHARACTER_INTRO_QUIP
		entry.defaultItemFlavor = quipList[0]
		entry.validItemFlavorList = quipList
		entry.isSlotLocked = bool function( EHI playerEHI ) {
			return !IsLobby()
		}
		entry.isActiveConditions = { [Loadout_Character()] = { [characterClass] = true, }, }
		entry.networkTo = eLoadoutNetworking.PLAYER_GLOBAL
		entry.networkVarName = "IntroQuip"
		fileLevel.loadoutCharacterIntroQuipSlotMap[characterClass] <- entry

		allEmotes.extend( quipList )
	}

	             
	{
		array<ItemFlavor> quipList = RegisterReferencedItemFlavorsFromArray( characterClass, "killQuips", "flavor" )
		MakeItemFlavorSet( quipList, fileLevel.cosmeticFlavorSortOrdinalMap )

		LoadoutEntry entry = RegisterLoadoutSlot( eLoadoutEntryType.ITEM_FLAVOR, "character_kill_quip_for_" + ItemFlavor_GetGUIDString( characterClass ) )
		entry.pdefSectionKey = "character " + ItemFlavor_GetGUIDString( characterClass )
		entry.DEV_category = "character_kill_quips"
		entry.DEV_name = ItemFlavor_GetHumanReadableRef( characterClass ) + " Kill Quip"
		entry.defaultItemFlavor = quipList[0]
		entry.validItemFlavorList = quipList
		entry.isSlotLocked = bool function( EHI playerEHI ) {
			return !IsLobby()
		}
		entry.isActiveConditions = { [Loadout_Character()] = { [characterClass] = true, }, }
		entry.networkTo = eLoadoutNetworking.PLAYER_GLOBAL
		entry.networkVarName = "KillQuip"
		fileLevel.loadoutCharacterKillQuipSlotMap[characterClass] <- entry

		allEmotes.extend( quipList )
	}

	{
		array<ItemFlavor> quipList = RegisterReferencedItemFlavorsFromArray( characterClass, "emoteIcons", "flavor" )
		MakeItemFlavorSet( quipList, fileLevel.cosmeticFlavorSortOrdinalMap )
		allEmotes.extend( quipList )
	}

	array<ItemFlavor> emotesList = RegisterReferencedItemFlavorsFromArray( characterClass, "emotes", "flavor" )
	MakeItemFlavorSet( emotesList, fileLevel.cosmeticFlavorSortOrdinalMap )
	allEmotes.extend( emotesList )

	                                    
	RegisterEquippableQuipsForCharacter( characterClass, allEmotes, emotesList )

	                 
	RegisterSkydiveEmotesForCharacter( characterClass )

	                         
	RegisterMythicBundlesForCharacter( characterClass )

}


void function SetupCharacterSkin( ItemFlavor skin )
{
	#if SERVER || CLIENT
		if ( !ItemFlavor_IsTheFavoriteSentinel( skin ) )
		{
			PrecacheModel( CharacterSkin_GetBodyModel( skin ) )
			PrecacheModel( CharacterSkin_GetArmsModel( skin ) )
		}
	#endif
}


                          
                          
                          
                          
                          

LoadoutEntry function Loadout_CharacterSkin( ItemFlavor characterClass )
{
	return fileLevel.loadoutCharacterSkinSlotMap[characterClass]
}


LoadoutEntry function Loadout_CharacterExecution( ItemFlavor characterClass )
{
	return fileLevel.loadoutCharacterExecutionSlotMap[characterClass]
}


LoadoutEntry function Loadout_CharacterIntroQuip( ItemFlavor characterClass )
{
	return fileLevel.loadoutCharacterIntroQuipSlotMap[characterClass]
}


LoadoutEntry function Loadout_CharacterKillQuip( ItemFlavor characterClass )
{
	return fileLevel.loadoutCharacterKillQuipSlotMap[characterClass]
}


#if SERVER || CLIENT
void function PlayIntroQuipThread( entity emitter, EHI playerEHI, entity exceptionPlayer = null )
{
	EndSignal( emitter, "OnDestroy" )
	#if CLIENT
		Timeout timeout = BeginTimeout( 4.0 )
		EndSignal( timeout, "Timeout" )
	#endif
	ItemFlavor character = LoadoutSlot_WaitForItemFlavor( playerEHI, Loadout_Character() )
	ItemFlavor quip      = LoadoutSlot_WaitForItemFlavor( playerEHI, Loadout_CharacterIntroQuip( character ) )
	#if CLIENT
		CancelTimeoutIfAlive( timeout )
	#endif

	string quipAlias = CharacterIntroQuip_GetVoiceSoundEvent( quip )
	PlayQuip( quipAlias, emitter, playerEHI, exceptionPlayer )
}
#endif


#if SERVER || CLIENT
void function PlayKillQuipThread( entity emitter, EHI playerEHI, entity exceptionPlayer = null, float delay = 0.0 )
{
	EndSignal( emitter, "OnDestroy" )

	wait delay

	#if CLIENT
		Timeout timeout = BeginTimeout( 4.0 )
		EndSignal( timeout, "Timeout" )
	#endif
	ItemFlavor character = LoadoutSlot_WaitForItemFlavor( playerEHI, Loadout_Character() )
	ItemFlavor quip      = LoadoutSlot_WaitForItemFlavor( playerEHI, Loadout_CharacterKillQuip( character ) )
	#if CLIENT
		CancelTimeoutIfAlive( timeout )
	#endif

	string quipAlias = CharacterKillQuip_GetVictimVoiceSoundEvent( quip )
	PlayQuip( quipAlias, emitter, playerEHI, exceptionPlayer )
}
#endif


#if SERVER || CLIENT
void function PlayQuip( string quipAlias, entity emitter, EHI playerEHI, entity exceptionPlayer )
{
	Assert( IsValid( emitter ) )
	if ( !IsValid( emitter ) )
		return

	if ( quipAlias != "" )
	{
		#if SERVER
			                              
				                                       
			    
				                                                                      
		#else
			var quipHandle = EmitSoundOnEntity( emitter, quipAlias )
			SetPlayThroughKillReplay( quipHandle )
		#endif
	}
}
#endif


                                                           
ItemFlavor function CharacterClass_GetDefaultSkin( ItemFlavor character )
{
	Assert( ItemFlavor_GetType( character ) == eItemType.character )

	return fileLevel.defaultSkins[character]
}


asset function CharacterSkin_GetBodyModel( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.character_skin )

	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "bodyModel" )
}


asset function CharacterSkin_GetArmsModel( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.character_skin )

	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "armsModel" )
}


string function CharacterSkin_GetSkinName( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.character_skin )

	return GetGlobalSettingsString( ItemFlavor_GetAsset( flavor ), "skinName" )
}


int function CharacterSkin_GetCamoIndex( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.character_skin )

	return GetGlobalSettingsInt( ItemFlavor_GetAsset( flavor ), "camoIndex" )
}


#if SERVER || CLIENT
void function CharacterSkin_Apply( entity ent, ItemFlavor skin )
{
	Assert( ItemFlavor_GetType( skin ) == eItemType.character_skin )

	if ( IsFiringRangeGameMode() )
	{
		printt( "FiringRangeDebug: ApplyAppropriateCharacterSkin called for " + ent )
	}

	asset bodyModel = CharacterSkin_GetBodyModel( skin )
	asset armsModel = CharacterSkin_GetArmsModel( skin )

	ent.SetSkin( 0 )                                                                                                                                                         
	ent.SetModel( bodyModel )

	int skinIndex = ent.GetSkinIndexByName( CharacterSkin_GetSkinName( skin ) )
	int camoIndex = CharacterSkin_GetCamoIndex( skin )

	if ( skinIndex == -1 )
	{
		skinIndex = 0
		camoIndex = 0
	}

	ent.SetSkin( skinIndex )
	ent.SetCamo( camoIndex )

	#if SERVER
		                     
		 
			                                     
			                                     
		 
	#endif          
}
#endif                    


#if SERVER || CLIENT
void function CharacterSkin_WaitForAndApplyFromLoadout( entity player, entity targetEnt )
{
	ItemFlavor character = LoadoutSlot_WaitForItemFlavor( ToEHI( player ), Loadout_Character() )
	if ( !IsValid( player ) || !IsValid( targetEnt ) )
		return

	ItemFlavor characterSkin = LoadoutSlot_WaitForItemFlavor( ToEHI( player ), Loadout_CharacterSkin( character ) )
	if ( !IsValid( player ) || !IsValid( targetEnt ) )
		return

	CharacterSkin_Apply( targetEnt, characterSkin )
}
#endif


int function CharacterSkin_GetSortOrdinal( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.character_skin )

	return fileLevel.cosmeticFlavorSortOrdinalMap[flavor]
}


ItemFlavor function CharacterSkin_GetCharacterFlavor( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.character_skin )

	Assert( GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "parentItemFlavor" ) != "" )

	return GetItemFlavorByAsset( GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "parentItemFlavor" ) )
}


asset function CharacterSkin_GetCustomCharSelectIntroAnim( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.character_skin )

	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "customCharSelectIntroAnim" )
}


asset function CharacterSkin_GetCustomCharSelectIdleAnim( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.character_skin )

	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "customCharSelectIdleAnim" )
}


asset function CharacterSkin_GetCustomCharSelectReadyIntroAnim( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.character_skin )

	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "customCharSelectReadyIntroAnim" )
}


asset function CharacterSkin_GetCustomCharSelectReadyIdleAnim( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.character_skin )

	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "customCharSelectReadyIdleAnim" )
}


bool function CharacterSkin_HasCustomCharSelectAnims( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.character_skin )

	return ( CharacterSkin_GetCustomCharSelectIntroAnim( flavor ) != $"" && CharacterSkin_GetCustomCharSelectIdleAnim( flavor ) != $"" && CharacterSkin_GetCustomCharSelectReadyIntroAnim( flavor ) != $"" && CharacterSkin_GetCustomCharSelectReadyIdleAnim( flavor ) != $"" )
}


CharacterMenuLightData function CharacterSkin_GetMenuCustomLightData( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.character_skin )
	CharacterMenuLightData data
	data.key_color =          GetGlobalSettingsVector( ItemFlavor_GetAsset( flavor ), "menuCustomLightColorKey" )
	data.key_brightness =     GetGlobalSettingsFloat( ItemFlavor_GetAsset( flavor ), "menuCustomLightBrightnessKey" )
	data.key_cone =           GetGlobalSettingsFloat( ItemFlavor_GetAsset( flavor ), "menuCustomLightConeKey" )
	data.key_innercone =      GetGlobalSettingsFloat( ItemFlavor_GetAsset( flavor ), "menuCustomLightInnerConeKey" )
	data.key_distance =       GetGlobalSettingsFloat( ItemFlavor_GetAsset( flavor ), "menuCustomLightDistanceKey" )
	data.key_halfbrightfrac = GetGlobalSettingsFloat( ItemFlavor_GetAsset( flavor ), "menuCustomLightHalfBrightFracKey" )
	data.key_specint =        GetGlobalSettingsFloat( ItemFlavor_GetAsset( flavor ), "menuCustomLightSpecIntKey" )
	data.key_pbrfalloff =     GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "menuCustomLightPbrFalloffKey" )
	data.key_castshadows =    GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "menuCustomLightCastShadowsKey" )
	data.fill_color =         GetGlobalSettingsVector( ItemFlavor_GetAsset( flavor ), "menuCustomLightColorFill" )
	data.fill_brightness =    GetGlobalSettingsFloat( ItemFlavor_GetAsset( flavor ), "menuCustomLightBrightnessFill" )
	data.fill_cone =          GetGlobalSettingsFloat( ItemFlavor_GetAsset( flavor ), "menuCustomLightConeFill" )
	data.fill_innercone =     GetGlobalSettingsFloat( ItemFlavor_GetAsset( flavor ), "menuCustomLightInnerConeFill" )
	data.fill_distance =      GetGlobalSettingsFloat( ItemFlavor_GetAsset( flavor ), "menuCustomLightDistanceFill" )
	data.fill_halfbrightfrac =GetGlobalSettingsFloat( ItemFlavor_GetAsset( flavor ), "menuCustomLightHalfBrightFracFill" )
	data.fill_specint =       GetGlobalSettingsFloat( ItemFlavor_GetAsset( flavor ), "menuCustomLightSpecIntFill" )
	data.fill_pbrfalloff =    GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "menuCustomLightPbrFalloffFill" )
	data.fill_castshadows =   GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "menuCustomLightCastShadowsFill" )
	data.rimL_color =         GetGlobalSettingsVector( ItemFlavor_GetAsset( flavor ), "menuCustomLightColorRimL" )
	data.rimL_brightness =    GetGlobalSettingsFloat( ItemFlavor_GetAsset( flavor ), "menuCustomLightBrightnessRimL" )
	data.rimL_cone =          GetGlobalSettingsFloat( ItemFlavor_GetAsset( flavor ), "menuCustomLightConeRimL" )
	data.rimL_innercone =     GetGlobalSettingsFloat( ItemFlavor_GetAsset( flavor ), "menuCustomLightInnerConeRimL" )
	data.rimL_distance =      GetGlobalSettingsFloat( ItemFlavor_GetAsset( flavor ), "menuCustomLightDistanceRimL" )
	data.rimL_halfbrightfrac =GetGlobalSettingsFloat( ItemFlavor_GetAsset( flavor ), "menuCustomLightHalfBrightFracRimL" )
	data.rimL_specint =       GetGlobalSettingsFloat( ItemFlavor_GetAsset( flavor ), "menuCustomLightSpecIntRimL" )
	data.rimL_pbrfalloff =    GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "menuCustomLightPbrFalloffRimL" )
	data.rimL_castshadows =   GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "menuCustomLightCastShadowsRimL" )
	data.rimR_color =         GetGlobalSettingsVector( ItemFlavor_GetAsset( flavor ), "menuCustomLightColorRimR" )
	data.rimR_brightness =    GetGlobalSettingsFloat( ItemFlavor_GetAsset( flavor ), "menuCustomLightBrightnessRimR" )
	data.rimR_cone =          GetGlobalSettingsFloat( ItemFlavor_GetAsset( flavor ), "menuCustomLightConeRimR" )
	data.rimR_innercone =     GetGlobalSettingsFloat( ItemFlavor_GetAsset( flavor ), "menuCustomLightInnerConeRimR" )
	data.rimR_distance =      GetGlobalSettingsFloat( ItemFlavor_GetAsset( flavor ), "menuCustomLightDistanceRimR" )
	data.rimR_halfbrightfrac =GetGlobalSettingsFloat( ItemFlavor_GetAsset( flavor ), "menuCustomLightHalfBrightFracRimR" )
	data.rimR_specint =       GetGlobalSettingsFloat( ItemFlavor_GetAsset( flavor ), "menuCustomLightSpecIntRimR" )
	data.rimR_pbrfalloff =    GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "menuCustomLightPbrFalloffRimR" )
	data.rimR_castshadows =   GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "menuCustomLightCastShadowsRimR" )
	data.animSeq =            GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "menuCustomLightAnimSeq" )
	return data
}


bool function CharacterSkin_HasMenuCustomLighting( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.character_skin )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "hasCustomCharSelectLighting" )
}


vector function CharacterSkin_GetCharacterSelectLabelColorOverride( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.character_skin )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( flavor ), "charSelectLabelColorOverride" )
}


bool function CharacterSkin_HasStoryBlurb( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.character_skin )

	return ( CharacterSkin_GetStoryBlurbBodyText( flavor ) != "" )
}


string function CharacterSkin_GetStoryBlurbBodyText( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.character_skin )

	return GetGlobalSettingsString( ItemFlavor_GetAsset( flavor ), "customSkinMenuBlurb" )
}

string function CharacterSkin_GetSubQuality( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.character_skin )

	return GetGlobalSettingsString( ItemFlavor_GetAsset( flavor ), "qualitySubTier" )
}

bool function CharacterExecution_IsNotEquippable( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.character_execution )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "isNotEquippable" )
}

bool function CharacterExecution_ShouldHideIfNotEquippable( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.character_execution )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "shouldHideIfNotEquippable" )
}


asset function CharacterExecution_GetAttackerAnimSeq( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.character_execution )

	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "attackerAnimSeq" )
}


asset function CharacterExecution_GetVictimAnimSeq( ItemFlavor flavor, ItemFlavor ornull victimCharacterFlav, string rigWeight )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.character_execution )

	if ( victimCharacterFlav != null )
	{
		asset victimChararacterAsset = ItemFlavor_GetAsset( expect ItemFlavor( victimCharacterFlav ) )
		var settingsBlock            = GetSettingsBlockForAsset( ItemFlavor_GetAsset( flavor ) )
		var perCharArray             = GetSettingsBlockArray( settingsBlock, "victimPerCharacterAnimSeq" )
		for ( int entryIdx = 0 ; entryIdx < GetSettingsArraySize( perCharArray ) ; entryIdx++ )
		{
			var entryBlock = GetSettingsArrayElem( perCharArray, entryIdx )

			if ( victimChararacterAsset == WORKAROUND_AssetAppend( GetSettingsBlockAsset( entryBlock, "characterRef" ), ".rpak" ) )
				return GetSettingsBlockAsset( entryBlock, "animSeq" )
		}
	}

	string key
	switch ( rigWeight )
	{
		case "light": key = "victimLightAnimSeq"; break;

		case "medium": key = "victimMediumAnimSeq"; break;

		case "heavy": key = "victimHeavyAnimSeq"; break;

		case "mediumNPC": key = "victimNPCMediumAnimSeq"; break;
	}

	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), key )
}


asset function CharacterExecution_GetExecutionVideo( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.character_execution )

	return GetGlobalSettingsStringAsAsset( ItemFlavor_GetAsset( flavor ), "video" )
}


asset function CharacterExecution_GetAttackerPreviewAnimSeq( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.character_execution )

	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "attackerPreviewAnimSeq" )
}


asset function CharacterExecution_GetVictimPreviewAnimSeq( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.character_execution )

	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "victimPreviewAnimSeq" )
}


int function CharacterExecution_GetSortOrdinal( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.character_execution )

	return fileLevel.cosmeticFlavorSortOrdinalMap[flavor]
}


ItemFlavor function CharacterExecution_GetCharacterFlavor( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.character_execution )

	Assert( GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "parentItemFlavor" ) != "" )

	return GetItemFlavorByAsset( GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "parentItemFlavor" ) )
}

ItemFlavor ornull function CharacterExecution_GetVictimOverrideExecution( ItemFlavor characterClass, ItemFlavor victimCharacterFlav )
{
	asset victimChararacterAsset = ItemFlavor_GetAsset( victimCharacterFlav )
	var settingsBlock            = GetSettingsBlockForAsset( ItemFlavor_GetAsset( characterClass ) )
	var executionsArray             = GetSettingsBlockArray( settingsBlock, "executions" )
	for ( int entryIdx = 0 ; entryIdx < GetSettingsArraySize( executionsArray ) ; entryIdx++ )
	{
		var entryBlock = GetSettingsArrayElem( executionsArray, entryIdx )
		asset executionCharRefAsset = GetSettingsBlockAsset( entryBlock, "characterRef" )

		if ( executionCharRefAsset != $"" )
		{
			if ( WORKAROUND_AssetAppend( executionCharRefAsset, ".rpak" ) ==  ItemFlavor_GetAsset(  victimCharacterFlav ) )
			{
				return GetItemFlavorByAsset( GetSettingsBlockAsset( entryBlock, "flavor" ) )
			}
		}
	}

	return null
}


bool function CharacterKillQuip_IsTheEmpty( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_kill_quip )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "isTheEmpty" )
}


string function CharacterKillQuip_GetVictimVoiceSoundEvent( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_kill_quip )

	return GetGlobalSettingsString( ItemFlavor_GetAsset( flavor ), "victimVoiceSoundEvent" )
}


string function CharacterKillQuip_GetStingSound( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_kill_quip )

	return GetGlobalSettingsString( ItemFlavor_GetAsset( flavor ), "stingSound" )
}


int function CharacterKillQuip_GetSortOrdinal( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_kill_quip )

	return fileLevel.cosmeticFlavorSortOrdinalMap[flavor]
}


ItemFlavor function CharacterKillQuip_GetCharacterFlavor( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_kill_quip )

	Assert( GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "parentItemFlavor" ) != "" )

	return GetItemFlavorByAsset( GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "parentItemFlavor" ) )
}


ItemFlavor ornull function CharacterEmoteIcon_GetCharacterFlavor( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.emote_icon )

	if ( GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "parentItemFlavor" ) == "" )
		return null

	return GetItemFlavorByAsset( GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "parentItemFlavor" ) )
}


bool function CharacterIntroQuip_IsTheEmpty( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_intro_quip )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "isTheEmpty" )
}


string function CharacterIntroQuip_GetVoiceSoundEvent( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_intro_quip )

	return GetGlobalSettingsString( ItemFlavor_GetAsset( flavor ), "voiceSound" )
}


string function CharacterIntroQuip_GetStingSoundEvent( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_intro_quip )

	return GetGlobalSettingsString( ItemFlavor_GetAsset( flavor ), "stingSound" )
}


int function CharacterIntroQuip_GetSortOrdinal( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_intro_quip )

	return fileLevel.cosmeticFlavorSortOrdinalMap[flavor]
}


ItemFlavor function CharacterIntroQuip_GetCharacterFlavor( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_intro_quip )

	Assert( GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "parentItemFlavor" ) != "" )

	return GetItemFlavorByAsset( GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "parentItemFlavor" ) )
}

#if CLIENT || UI
bool function CharacterSkin_ShouldHideIfLocked( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.character_skin )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "shouldHideIfLocked" )
}
#endif

#if CLIENT
void function CharacterSkin_CheckBloodhoundRavenSkin ( entity child, entity model )
{
	if ( IsValid( model ) )
	{
		if ( child.GetModelName() == BLOODHOUND_BIRD_MDL && ( IsLobby() || IsShowingVictorySequence() || CharacterSelect_MenuIsOpen()) )
		{
			child.SetSkin ( model.GetSkin() == 22 ? 2 : 0 )
		}
	}
}
#endif

#if DEV && CLIENT
void function DEV_TestCharacterSkinData()
{
	entity model = CreateClientSidePropDynamic( <0, 0, 0>, <0, 0, 0>, $"mdl/dev/empty_model.rmdl" )

	foreach ( character in GetAllCharacters() )
	{
		array<ItemFlavor> characterSkins = GetValidItemFlavorsForLoadoutSlot( LocalClientEHI(), Loadout_CharacterSkin( character ) )

		foreach ( skin in characterSkins )
		{
			printt( ItemFlavor_GetHumanReadableRef( skin ), "skinName:", CharacterSkin_GetSkinName( skin ) )
			CharacterSkin_Apply( model, skin )
		}
	}

	model.Destroy()
}
#endif                 

#if DEV && UI
       
                                          
 
                                                           
                                                                                    

                                                                                  
                                                                                                 
  
                                                                         
                                                                                                                                                                                            
  
 
      
#endif