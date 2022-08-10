global function ShMythics_LevelInit

global function RegisterMythicBundlesForCharacter

global function Mythics_CharacterHasMythic
global function Mythics_SkinHasCustomExecution
global function Mythics_GetChallengeForCharacter
global function Mythics_IsItemFlavorMythicSkin
global function Mythics_GetSkinTierForCharacter
global function Mythics_GetItemTierForSkin
global function Mythics_GetSkinTierIntForSkin
global function Mythics_GetAllSkinsFromBase
global function Mythics_GetChallengeGUIDForSkinGUID
global function Mythics_GetChallengeForSkin
global function Mythics_GetNumTiersUnlockedForSkin
global function Mythics_GetCustomExecutionForCharacterOrSkin
global function Mythics_GetCharacterForSkin
global function Mythics_GetStoreImageForCharacter
global function Mythics_GetSkinBaseNameForCharacter

#if UI
global function Mythics_ToggleTrackChallenge
global function Mythics_UpdateTrackingButton
#endif
struct FileStruct_LifetimeLevel
{
	table< int, int > mythicSkinsGUIDToCustomExecutionGUID
	table< int, int > mythicCharactersGUIDToChallengesGUID

	table< int, array< int > > charactersGUIDToMythicSkinGUIDs
	table< int, array< asset > > charactersGUIDToStoreImages
	table< int, string > charactersGUIDToSkinBaseName
	ItemFlavor ornull currentChallenge
}
FileStruct_LifetimeLevel& fileLevel

const int CHALLENGE_SORT_ORDINAL = 0                                                      
const int FINAL_TIER = 3

void function ShMythics_LevelInit()
{
	FileStruct_LifetimeLevel newFileLevel
	fileLevel = newFileLevel
}

void function RegisterMythicBundlesForCharacter( ItemFlavor characterClass )
{
	int characterGUID = ItemFlavor_GetGUID( characterClass )

	array<ItemFlavor> mythicBundlesList = RegisterReferencedItemFlavorsFromArray( characterClass, "mythicBundles", "flavor" )

	Assert ( mythicBundlesList.len() <= 1, "Character " + ItemFlavor_GetHumanReadableRef( characterClass ) + " has more than one Mythic bundle registered." )

	if ( mythicBundlesList.len() == 0 )
		return

	ItemFlavor mythicBundleFlav = mythicBundlesList[0]
	asset mythicBundleAsset = ItemFlavor_GetAsset( mythicBundleFlav )
	var settingsBlock = GetSettingsBlockForAsset( mythicBundleAsset )
	asset challengeAsset = GetSettingsBlockAsset( settingsBlock, "challengeAsset" )
	asset executionAsset = GetSettingsBlockAsset( settingsBlock, "executionAsset" )
	var skinDataArray = GetSettingsBlockArray( settingsBlock, "skinsByTier" )

	array< asset > skinAssets
	array< int > skinGUIDs
	int tierIdx = 1
	int preRegGUID
	foreach ( var skinBlock in IterateSettingsArray( skinDataArray ) )
	{
		asset entryAsset = GetSettingsBlockAsset( skinBlock, "skinAsset" )
		skinAssets.append( entryAsset )
		skinGUIDs.append( GetUniqueIdForSettingsAsset( entryAsset ) )

		if ( tierIdx == 1 )
		{
			preRegGUID = GetUniqueIdForSettingsAsset( entryAsset )
		}
		else if ( tierIdx == FINAL_TIER )
		{
			int skinGUID = GetUniqueIdForSettingsAsset( entryAsset )
			fileLevel.mythicSkinsGUIDToCustomExecutionGUID[ skinGUID ] <- GetUniqueIdForSettingsAsset( executionAsset )
		}

		tierIdx++
	}

	if ( tierIdx > 1 )
	{
		fileLevel.charactersGUIDToMythicSkinGUIDs[ characterGUID ] <- skinGUIDs
	}

	foreach ( var storeImage in IterateSettingsArray( GetSettingsBlockArray( settingsBlock, "storeImagesByTier" ) ) )
	{
		asset entryAsset = GetSettingsBlockAsset( storeImage, "storeImage" )

		if( !( characterGUID in fileLevel.charactersGUIDToStoreImages ) )
			fileLevel.charactersGUIDToStoreImages[ characterGUID ] <- []

		fileLevel.charactersGUIDToStoreImages[ characterGUID ].append( entryAsset )
	}

	ItemFlavor ornull challengeFlavOrNull = RegisterItemFlavorFromSettingsAsset( challengeAsset )
	if ( challengeFlavOrNull != null )
	{
		ItemFlavor challengeFlav = expect ItemFlavor( challengeFlavOrNull )
		RegisterChallengeSource( challengeFlav, mythicBundleFlav, CHALLENGE_SORT_ORDINAL )

		table<string, string> metaData = ItemFlavor_GetMetaData( challengeFlav )

		metaData[ HAS_MYTHIC_PREREQ ] <- string( preRegGUID )

		fileLevel.mythicCharactersGUIDToChallengesGUID[ characterGUID ] <- ItemFlavor_GetGUID( challengeFlav )
	}

	fileLevel.charactersGUIDToSkinBaseName[ characterGUID ] <- GetSettingsBlockString( settingsBlock, "baseSkinName" )
}

bool function Mythics_CharacterHasMythic( ItemFlavor character )
{
	Assert( IsItemFlavorStructValid( character ), eValidation.ASSERT )
	Assert( ItemFlavor_GetType( character ) == eItemType.character )

	int characterGUID = ItemFlavor_GetGUID( character )

	return ( characterGUID in fileLevel.mythicCharactersGUIDToChallengesGUID )
}

bool function Mythics_SkinHasCustomExecution( ItemFlavor skin )
{
	Assert( IsItemFlavorStructValid( skin ), eValidation.ASSERT )

	int skinGUID = GetUniqueIdForSettingsAsset( ItemFlavor_GetAsset( skin ) )

	return ( skinGUID in fileLevel.mythicSkinsGUIDToCustomExecutionGUID )
}

ItemFlavor function Mythics_GetCustomExecutionForCharacterOrSkin( ItemFlavor item )
{
	Assert( IsItemFlavorStructValid( item ), eValidation.ASSERT )
	Assert( ItemFlavor_GetType( item ) == eItemType.character || ItemFlavor_GetType( item ) == eItemType.character_skin )

	int skinGUID

	if ( ItemFlavor_GetType( item ) == eItemType.character )
	{
		int characterGUID = ItemFlavor_GetGUID( item )
		skinGUID = fileLevel.charactersGUIDToMythicSkinGUIDs[ characterGUID ][ FINAL_TIER - 1 ]
	}
	else                               
	{
		skinGUID = ItemFlavor_GetGUID( item )
	}

	int executionGUID = fileLevel.mythicSkinsGUIDToCustomExecutionGUID[ skinGUID ]

	Assert( IsValidItemFlavorGUID( executionGUID ) )
	Assert( ItemFlavor_GetType( GetItemFlavorByGUID( executionGUID ) ) == eItemType.character_execution )

	return GetItemFlavorByGUID( executionGUID )
}

ItemFlavor function Mythics_GetChallengeForCharacter( ItemFlavor character )
{
	Assert( IsItemFlavorStructValid( character ), eValidation.ASSERT )

	int characterGUID = ItemFlavor_GetGUID( character )
	int challengeGUID = fileLevel.mythicCharactersGUIDToChallengesGUID[ characterGUID ]

	Assert( IsValidItemFlavorGUID( challengeGUID ) )
	Assert( ItemFlavor_GetType( GetItemFlavorByGUID( challengeGUID ) ) == eItemType.challenge )

	return GetItemFlavorByGUID( challengeGUID )
}

bool function Mythics_IsItemFlavorMythicSkin( ItemFlavor item )
{
	return ItemFlavor_GetType( item ) == eItemType.character_skin && ItemFlavor_GetQuality( item ) == eRarityTier.HEIRLOOM
}

#if UI
void function Mythics_ToggleTrackChallenge( ItemFlavor challenge, var button, bool isSkinPanel = false )
{
	fileLevel.currentChallenge = challenge
	SettingsAssetGUID challengeGUID = ItemFlavor_GetGUID( challenge )
	var rui = Hud_GetRui( button )

	if ( IsChallengeValidAsFavorite( GetLocalClientPlayer(), challenge ) )
		Remote_ServerCallFunction( "ClientCallback_ToggleFavoriteChallenge", challengeGUID )
}

void function Mythics_UpdateTrackingButton()
{
	if ( fileLevel.currentChallenge == null )
		return

	var skinsPanel = GetPanel( "CharacterSkinsPanel" )
	var celebrationMenu = GetMenu( "LootBoxOpen" )

	var trackChallengeButton = Hud_GetChild( celebrationMenu, "TrackChallengeButton" )
	var mythicTrackingButton = Hud_GetChild( skinsPanel, "TrackMythicButton" )

	var skinPanelRui = Hud_GetRui( mythicTrackingButton )
	var celebrationMenuRui = Hud_GetRui( trackChallengeButton )


	bool isChallengeTracked = IsFavoriteChallenge( expect ItemFlavor( fileLevel.currentChallenge )  )

	RuiSetString( skinPanelRui, "descText", isChallengeTracked ? "#CHALLENGE_TRACKED"  : "#CHALLENGE_TRACK" )
	RuiSetString( skinPanelRui, "bigText", isChallengeTracked ? "`1%$rui/hud/check_selected%" : "`1%$rui/borders/key_border%" )
	HudElem_SetRuiArg( trackChallengeButton, "buttonText", isChallengeTracked ?  "#CHALLENGE_TRACKED" : "#CHALLENGE_TRACK")
	HudElem_SetRuiArg( trackChallengeButton, "isChallengeTracked", isChallengeTracked )

}
#endif

int function Mythics_GetSkinTierIntForSkin( ItemFlavor skin )
{
	Assert( IsItemFlavorStructValid( skin ), eValidation.ASSERT )

	int skinGUID =  ItemFlavor_GetGUID( skin )
	int characterGUID = ItemFlavor_GetGUID( expect ItemFlavor( GetItemFlavorAssociatedCharacterOrWeapon( skin ) ) )

	for ( int tier = 1;  tier <= FINAL_TIER; tier++ )
	{
		if ( fileLevel.charactersGUIDToMythicSkinGUIDs[ characterGUID ][tier-1] == skinGUID)
			return tier
	}
	return -1
}

array<ItemFlavor> function Mythics_GetAllSkinsFromBase( ItemFlavor baseSkin )
{
	Assert( ItemFlavor_GetType( baseSkin ) == eItemType.character_skin )

	array<ItemFlavor> mythicSkins

	ItemFlavor character = expect ItemFlavor( GetItemFlavorAssociatedCharacterOrWeapon( baseSkin ) )
	int characterGUID = ItemFlavor_GetGUID( character )

	if ( !( characterGUID in fileLevel.charactersGUIDToMythicSkinGUIDs ) )
		return mythicSkins

	foreach ( int skinGUID in fileLevel.charactersGUIDToMythicSkinGUIDs[ characterGUID ] )
	{
		mythicSkins.append( GetItemFlavorByGUID( skinGUID ) )
	}

	return mythicSkins
}

ItemFlavor ornull function Mythics_GetItemTierForSkin( ItemFlavor skin, int tier )
{
	Assert( ItemFlavor_GetType( skin ) == eItemType.character_skin )

	ItemFlavor character = Mythics_GetCharacterForSkin( skin )

	if ( tier == FINAL_TIER )
		return Mythics_GetCustomExecutionForCharacterOrSkin( character )

	return Mythics_GetSkinTierForCharacter ( character , tier )
}

ItemFlavor ornull function Mythics_GetSkinTierForCharacter( ItemFlavor character, int tier )
{
	Assert( IsItemFlavorStructValid( character ), eValidation.ASSERT )

	int characterGUID = ItemFlavor_GetGUID( character )
	int skinGUID

	if( characterGUID in fileLevel.charactersGUIDToMythicSkinGUIDs && fileLevel.charactersGUIDToMythicSkinGUIDs[ characterGUID ].len() > tier )
		skinGUID = fileLevel.charactersGUIDToMythicSkinGUIDs[ characterGUID ][tier]
	else
		return null

	Assert( IsValidItemFlavorGUID( skinGUID ) )
	Assert( ItemFlavor_GetType( GetItemFlavorByGUID( skinGUID ) ) == eItemType.character_skin )

	return GetItemFlavorByGUID( skinGUID )
}

ItemFlavor function Mythics_GetCharacterForSkin( ItemFlavor skin )
{
	Assert( IsItemFlavorStructValid( skin ), eValidation.ASSERT )

	int skinGUID =  ItemFlavor_GetGUID( skin )
	ItemFlavor character = expect ItemFlavor( GetItemFlavorAssociatedCharacterOrWeapon( skin ) )
	return character
}

SettingsAssetGUID function Mythics_GetChallengeGUIDForSkinGUID( SettingsAssetGUID skinGUID )
{
	ItemFlavor skin             = GetItemFlavorByGUID( skinGUID )
	ItemFlavor character = Mythics_GetCharacterForSkin( skin )
	ItemFlavor challenge = Mythics_GetChallengeForCharacter( character )
	SettingsAssetGUID challengeGUID = ItemFlavor_GetGUID( challenge )
	return challengeGUID

}

ItemFlavor function Mythics_GetChallengeForSkin( ItemFlavor skin )
{
	Assert( ItemFlavor_GetType( skin ) == eItemType.character_skin )

	return Mythics_GetChallengeForCharacter( Mythics_GetCharacterForSkin ( skin ) )
}

int function Mythics_GetNumTiersUnlockedForSkin( entity player, ItemFlavor skin )
{
	if ( !IsValid( player ) )
		return 0

	ItemFlavor MythicChallenge = Mythics_GetChallengeForSkin( skin )

	if ( !DoesPlayerHaveChallenge( player, MythicChallenge ) )
	{
		print("Checked mythic skin tier but player does not have challenge")
		return 0
	}

	return 1 + Challenge_GetCurrentTier( player, MythicChallenge )
}

asset function Mythics_GetStoreImageForCharacter( ItemFlavor character, int tier )
{
	Assert( IsItemFlavorStructValid( character ), eValidation.ASSERT )
	return fileLevel.charactersGUIDToStoreImages[ ItemFlavor_GetGUID( character ) ][ tier ]
}

string function Mythics_GetSkinBaseNameForCharacter( ItemFlavor character )
{
	Assert( IsItemFlavorStructValid( character ), eValidation.ASSERT )
	return fileLevel.charactersGUIDToSkinBaseName[ ItemFlavor_GetGUID( character ) ]
}