global function ShWeaponCosmetics_LevelInit

global function Loadout_WeaponSkin
global function WeaponSkin_GetWorldModel
global function WeaponSkin_GetViewModel
global function WeaponSkin_GetSkinName
global function WeaponSkin_GetCamoIndex
global function WeaponSkin_GetHackyRUISchemeIdentifier
global function WeaponSkin_DoesReactToKills
global function WeaponSkin_GetReactToKillsLevelCount
global function WeaponSkin_GetReactToKillsDataForLevel
global function WeaponSkin_GetReactToKillsLevelIndexForKillCount
global function WeaponSkin_GetSortOrdinal
global function WeaponSkin_GetWeaponFlavor
global function WeaponSkin_GetVideo
#if(false)

#endif
#if(CLIENT)
global function WeaponSkin_Apply
#endif
#if DEV && CLIENT 
global function DEV_TestWeaponSkinData
#endif


//
//
//
//
//
//
global struct WeaponReactiveKillsData
{
	int           killCount
	string        killSoundEvent1p
	string        killSoundEvent3p
	string        persistentSoundEvent1p
	string        persistentSoundEvent3p
	array<asset>  killFX1PList
	array<asset>  killFX3PList
	array<string> killFXAttachmentList
	array<asset>  persistentFX1PList
	array<asset>  persistentFX3PList
	array<string> persistentFXAttachmentList
}


//
//
//
//
//
struct FileStruct_LifetimeLevel
{
	table<ItemFlavor, LoadoutEntry>             loadoutWeaponSkinSlotMap
	table<ItemFlavor, table<ItemFlavor, bool> > weaponSkinSetMap
	table<ItemFlavor, ItemFlavor>               skinWeaponMap

	table<ItemFlavor, int> cosmeticFlavorSortOrdinalMap

	#if(CLIENT)
		table<ItemFlavor, table<asset, int> > weaponModelLegendaryIndexMapMap
		table<ItemFlavor, int>                weaponSkinLegendaryIndexMap
	#endif
}
FileStruct_LifetimeLevel& fileLevel

struct
{
	array< void functionref(entity, ItemFlavor, ItemFlavor) > callbacks_UpdatePlayerWeaponCosmetics
} file

//
//
//
//
//
void function ShWeaponCosmetics_LevelInit()
{
	FileStruct_LifetimeLevel newFileLevel
	fileLevel = newFileLevel

	AddCallback_OnItemFlavorRegistered( eItemType.loot_main_weapon, OnItemFlavorRegistered_LootMainWeapon )
	//
}


void function OnItemFlavorRegistered_LootMainWeapon( ItemFlavor weaponFlavor )
{
	//
	{
		array<ItemFlavor> skinList = RegisterReferencedItemFlavorsFromArray( weaponFlavor, "skins", "flavor" )
		fileLevel.weaponSkinSetMap[weaponFlavor] <- MakeItemFlavorSet( skinList, fileLevel.cosmeticFlavorSortOrdinalMap )
		foreach( ItemFlavor skin in skinList )
		{
			fileLevel.skinWeaponMap[skin] <- weaponFlavor
			SetupWeaponSkin( skin )
		}

		LoadoutEntry entry = RegisterLoadoutSlot( eLoadoutEntryType.ITEM_FLAVOR, "weapon_skin_for_" + ItemFlavor_GetGUIDString( weaponFlavor ) )
		entry.pdefSectionKey = "weapon " + ItemFlavor_GetGUIDString( weaponFlavor )
		entry.DEV_category = "weapon_skins"
		entry.DEV_name = ItemFlavor_GetHumanReadableRef( weaponFlavor ) + " Skin"
		entry.defaultItemFlavor = skinList[0]
		entry.validItemFlavorList = skinList
		entry.isSlotLocked = bool function( EHI playerEHI ) {
			return !IsLobby()
		}
		entry.networkTo = eLoadoutNetworking.PLAYER_EXCLUSIVE
		#if(false)














#endif
		AddCallback_ItemFlavorLoadoutSlotDidChange_AnyPlayer( entry, void function( EHI playerEHI, ItemFlavor skin ) : ( weaponFlavor, entry ) {
			#if(false)

#endif
		} )
		fileLevel.loadoutWeaponSkinSlotMap[weaponFlavor] <- entry
	}
}


void function SetupWeaponSkin( ItemFlavor skin )
{
	asset worldModel = WeaponSkin_GetWorldModel( skin )
	asset viewModel  = WeaponSkin_GetViewModel( skin )

	#if(CLIENT)
		PrecacheModel( worldModel )
		PrecacheModel( viewModel )

		ItemFlavor weaponFlavor = WeaponSkin_GetWeaponFlavor( skin )

		if ( !(weaponFlavor in fileLevel.weaponModelLegendaryIndexMapMap) )
			fileLevel.weaponModelLegendaryIndexMapMap[weaponFlavor] <- {}

		table<asset, int> weaponLegendaryIndexMap = fileLevel.weaponModelLegendaryIndexMapMap[weaponFlavor]

		if ( !(worldModel in weaponLegendaryIndexMap) )
		{
			int skinLegendaryIndex = weaponLegendaryIndexMap.len()
			weaponLegendaryIndexMap[worldModel] <- skinLegendaryIndex

			SetWeaponLegendaryModel( WeaponItemFlavor_GetClassname( weaponFlavor ), skinLegendaryIndex, viewModel, worldModel )
		}

		fileLevel.weaponSkinLegendaryIndexMap[skin] <- weaponLegendaryIndexMap[worldModel]

		//
		if ( WeaponSkin_DoesReactToKills( skin ) )
		{
			for ( int levelIdx = 0; levelIdx < WeaponSkin_GetReactToKillsLevelCount( skin ); levelIdx++ )
			{
				WeaponReactiveKillsData rtked = WeaponSkin_GetReactToKillsDataForLevel( skin, levelIdx )
				foreach ( asset fx in rtked.killFX1PList )
					if ( fx != $"" )
						PrecacheParticleSystem( fx )

				foreach ( asset fx in rtked.persistentFX1PList )
					if ( fx != $"" )
						PrecacheParticleSystem( fx )

				foreach ( asset fx in rtked.killFX3PList )
					if ( fx != $"" )
						PrecacheParticleSystem( fx )

				foreach ( asset fx in rtked.persistentFX3PList )
					if ( fx != $"" )
						PrecacheParticleSystem( fx )
			}
		}
	#endif
}


//
//
//
//
//
LoadoutEntry function Loadout_WeaponSkin( ItemFlavor weaponFlavor )
{
	return fileLevel.loadoutWeaponSkinSlotMap[weaponFlavor]
}


//
//
//
//
//
#if(false)
























#endif //


ItemFlavor function WeaponSkin_GetWeaponFlavor( ItemFlavor skin )
{
	Assert( ItemFlavor_GetType( skin ) == eItemType.weapon_skin )

	return fileLevel.skinWeaponMap[skin]
}


asset function WeaponSkin_GetWorldModel( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.weapon_skin )

	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "worldModel" )
}


asset function WeaponSkin_GetViewModel( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.weapon_skin )

	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "viewModel" )
}


string function WeaponSkin_GetSkinName( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.weapon_skin )

	return GetGlobalSettingsString( ItemFlavor_GetAsset( flavor ), "skinName" )
}


int function WeaponSkin_GetCamoIndex( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.weapon_skin )

	return GetGlobalSettingsInt( ItemFlavor_GetAsset( flavor ), "camoIndex" )
}


int function WeaponSkin_GetHackyRUISchemeIdentifier( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.weapon_skin )

	return GetGlobalSettingsInt( ItemFlavor_GetAsset( flavor ), "hackyRUISchemeIdentifier" )
}


bool function WeaponSkin_DoesReactToKills( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.weapon_skin )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "featureReactsToKills" )
}


int function WeaponSkin_GetReactToKillsLevelCount( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.weapon_skin )
	Assert( WeaponSkin_DoesReactToKills( flavor ) )

	var skinBlock = GetSettingsBlockForAsset( ItemFlavor_GetAsset( flavor ) )
	return GetSettingsArraySize( GetSettingsBlockArray( skinBlock, "featureReactsToKillsLevels" ) )
}


WeaponReactiveKillsData function WeaponSkin_GetReactToKillsDataForLevel( ItemFlavor flavor, int levelIdx )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.weapon_skin )
	Assert( WeaponSkin_DoesReactToKills( flavor ) )

	var skinBlock           = GetSettingsBlockForAsset( ItemFlavor_GetAsset( flavor ) )
	var reactsToKillsLevels = GetSettingsBlockArray( skinBlock, "featureReactsToKillsLevels" )
	Assert( levelIdx < GetSettingsArraySize( reactsToKillsLevels ) )
	var levelBlock = GetSettingsArrayElem( reactsToKillsLevels, levelIdx )

	WeaponReactiveKillsData rtked
	rtked.killCount = GetSettingsBlockInt( levelBlock, "killCount" )
	rtked.killSoundEvent1p = GetSettingsBlockString( levelBlock, "killSoundEvent1p" )
	rtked.killSoundEvent3p = GetSettingsBlockString( levelBlock, "killSoundEvent3p" )
	rtked.persistentSoundEvent1p = GetSettingsBlockString( levelBlock, "persistentSoundEvent1p" )
	rtked.persistentSoundEvent3p = GetSettingsBlockString( levelBlock, "persistentSoundEvent3p" )
	foreach ( var killFXBlock in IterateSettingsArray( GetSettingsBlockArray( levelBlock, "killFXList" ) ) )
	{
		rtked.killFX1PList.append( GetSettingsBlockStringAsAsset( killFXBlock, "fx1p" ) )
		rtked.killFX3PList.append( GetSettingsBlockStringAsAsset( killFXBlock, "fx3p" ) )
		rtked.killFXAttachmentList.append( GetSettingsBlockString( killFXBlock, "attachment" ) )
	}
	foreach ( var persistentFXBlock in IterateSettingsArray( GetSettingsBlockArray( levelBlock, "persistentFXList" ) ) )
	{
		rtked.persistentFX1PList.append( GetSettingsBlockStringAsAsset( persistentFXBlock, "fx1p" ) )
		rtked.persistentFX3PList.append( GetSettingsBlockStringAsAsset( persistentFXBlock, "fx3p" ) )
		rtked.persistentFXAttachmentList.append( GetSettingsBlockString( persistentFXBlock, "attachment" ) )
	}
	return rtked
}


int function WeaponSkin_GetReactToKillsLevelIndexForKillCount( ItemFlavor flavor, int killCount )
{
	//
	Assert( ItemFlavor_GetType( flavor ) == eItemType.weapon_skin )
	Assert( WeaponSkin_DoesReactToKills( flavor ) )

	var skinBlock = GetSettingsBlockForAsset( ItemFlavor_GetAsset( flavor ) )

	var levelsArr = GetSettingsBlockArray( skinBlock, "featureReactsToKillsLevels" )
	for ( int levelIndex = GetSettingsArraySize( levelsArr ) - 1; levelIndex >= 0; levelIndex-- )
	{
		var levelBlock = GetSettingsArrayElem( levelsArr, levelIndex )
		if ( killCount >= GetSettingsBlockInt( levelBlock, "killCount" ) )
		{
			return levelIndex
		}
	}

	return -1
}


asset function WeaponSkin_GetVideo( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.weapon_skin )

	return GetGlobalSettingsStringAsAsset( ItemFlavor_GetAsset( flavor ), "video" )
}


#if(CLIENT)
void function WeaponSkin_Apply( entity ent, ItemFlavor skin )
{
	Assert( ItemFlavor_GetType( skin ) == eItemType.weapon_skin )

	ent.e.__itemFlavorNetworkId = ItemFlavor_GetNetworkIndex_DEPRECATED( skin )
	ent.SetSkin( 0 ) //

	#if(false)


//

//



//



//





#elseif(CLIENT)
		Assert( ent.IsClientOnly(), ent + " isn't client only" )
		Assert( ent.GetCodeClassName() == "dynamicprop", ent + " has classname \"" + ent.GetCodeClassName() + "\" instead of \"dynamicprop\"" )

		ent.SetModel( WeaponSkin_GetViewModel( skin ) ) //
	#endif

	int skinIndex = ent.GetSkinIndexByName( WeaponSkin_GetSkinName( skin ) )
	int camoIndex = WeaponSkin_GetCamoIndex( skin )

	if ( skinIndex == -1 )
	{
		skinIndex = 0
		camoIndex = 0
	}

	ent.SetSkin( skinIndex )
	ent.SetCamo( camoIndex )
}
#endif //


int function WeaponSkin_GetSortOrdinal( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.weapon_skin )

	return fileLevel.cosmeticFlavorSortOrdinalMap[flavor]
}


#if DEV && CLIENT 
void function DEV_TestWeaponSkinData()
{
	entity model = CreateClientSidePropDynamic( <0, 0, 0>, <0, 0, 0>, $"mdl/dev/empty_model.rmdl" )

	foreach ( weapon in GetAllWeaponItemFlavors() )
	{
		array<ItemFlavor> weaponSkins = GetValidItemFlavorsForLoadoutSlot( LocalClientEHI(), Loadout_WeaponSkin( weapon ) )

		foreach ( skin in weaponSkins )
		{
			printt( ItemFlavor_GetHumanReadableRef( skin ), "skinName:", WeaponSkin_GetSkinName( skin ) )
			WeaponSkin_Apply( model, skin )
		}
	}

	model.Destroy()
}
#endif //