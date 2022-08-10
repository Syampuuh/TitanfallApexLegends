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

global function Loadout_WeaponCharm
global function WeaponCharm_IsTheEmpty
global function WeaponCharm_GetCharmModel
global function WeaponCharm_GetAttachmentName
global function WeaponCharm_GetSortOrdinal
global function GetWeaponThatCharmIsCurrentlyEquippedToForPlayer

#if SERVER
                                                       
                                                   
#endif
#if SERVER || CLIENT
global function WeaponCosmetics_Apply
global function CodeCallback_GetWeaponSkin
#endif
#if DEV && CLIENT
global function DEV_TestWeaponSkinData
global function DEV_GetCharmForCurrentWeapon
global function DEV_SetCharmForCurrentWeapon
#endif
#if DEV && SERVER
                                           
#endif
#if CLIENT
global function GetCharmForWeaponEntity
global function DestroyCharmForWeaponEntity
#endif

#if CLIENT || UI
global function WeaponSkin_ShouldHideIfLocked
#endif

                      
                      
                      
                      
                      
  
global struct WeaponReactiveKillsData
{
	int                killCount
	string             killSoundEvent1p
	string             killSoundEvent3p
	string             persistentSoundEvent1p
	string             persistentSoundEvent3p
	float              emissiveIntensity
	array<asset>       killFX1PList
	array<asset>       killFX3PList
	array<string>      killFXAttachmentList
	array<asset>       persistentFX1PList
	array<asset>       persistentFX3PList
	array<string>      persistentFXAttachmentList
	table<string, int> bodygroupSubmodelIdxMap
	array<string>      weaponModsToAdd
	array<string>      weaponModsToRemove
	float 			   poseParameter
}


                       
                       
                       
                       
                       
struct FileStruct_LifetimeLevel
{

	table<ItemFlavor, LoadoutEntry>             loadoutWeaponSkinSlotMap

	table<ItemFlavor, LoadoutEntry>             loadoutWeaponCharmSlotMap

	table<ItemFlavor, int> cosmeticFlavorSortOrdinalMap

	#if SERVER || CLIENT
		table<ItemFlavor, table<asset, int> > weaponModelLegendaryIndexMapMap
		table<ItemFlavor, int>                weaponSkinLegendaryIndexMap
	#endif

	#if CLIENT
		table<entity, entity>    menuWeaponCharmEntityMap
	#endif
}
FileStruct_LifetimeLevel& fileLevel

struct
{
	array< void functionref(entity, ItemFlavor, ItemFlavor) > callbacks_UpdatePlayerWeaponCosmetics
} file

                        
                        
                        
                        
                        
void function ShWeaponCosmetics_LevelInit()
{
	FileStruct_LifetimeLevel newFileLevel
	fileLevel = newFileLevel

	AddCallback_OnItemFlavorRegistered( eItemType.loot_main_weapon, OnItemFlavorRegistered_LootMainWeapon )
	                                                                                                                                                                                                                 

	#if SERVER || CLIENT
	Remote_RegisterServerFunction( "ClientCallback_WeaponCosmeticsApply", "int", INT_MIN, INT_MAX )
	#endif
}


void function OnItemFlavorRegistered_LootMainWeapon( ItemFlavor weaponFlavor )
{
	        
	{
		array<ItemFlavor> skinList = RegisterReferencedItemFlavorsFromArray( weaponFlavor, "skins", "flavor" )
		MakeItemFlavorSet( skinList, fileLevel.cosmeticFlavorSortOrdinalMap )
		foreach( ItemFlavor skin in skinList )
		{
			SetupWeaponSkin( skin )
		}

		LoadoutEntry entry = RegisterLoadoutSlot( eLoadoutEntryType.ITEM_FLAVOR, "weapon_skin_for_" + ItemFlavor_GetGUIDString( weaponFlavor ) )
		entry.pdefSectionKey = "weapon " + ItemFlavor_GetGUIDString( weaponFlavor )
		entry.DEV_category = "weapon_skins"
		entry.DEV_name = ItemFlavor_GetHumanReadableRef( weaponFlavor ) + " Skin"
		entry.defaultItemFlavor = skinList[1]
		entry.favoriteItemFlavor = skinList[0]
		entry.validItemFlavorList = skinList
		entry.isSlotLocked = bool function( EHI playerEHI ) {
			return !IsLobby()
		}
		entry.networkTo = eLoadoutNetworking.PLAYER_EXCLUSIVE
		entry.maxFavoriteCount = 8
		#if SERVER && DEV
			                                                                               
				                                             
				                                                                      

				                                                                                                                                             
					           

				                                                        
				 
					                                                     
						           
				 
				            
			 
		#endif
		AddCallback_ItemFlavorLoadoutSlotDidChange_AnyPlayer( entry, void function( EHI playerEHI, ItemFlavor skin ) : ( weaponFlavor, entry ) {
			#if SERVER
				                                                                       
			#endif
		} )
		fileLevel.loadoutWeaponSkinSlotMap[weaponFlavor] <- entry
	}

	         
	{
		array<ItemFlavor> charmList = RegisterReferencedItemFlavorsFromArray( weaponFlavor, "charms", "flavor" )
		MakeItemFlavorSet( charmList, fileLevel.cosmeticFlavorSortOrdinalMap )
		foreach( ItemFlavor charm in charmList )
		{
			SetupWeaponCharm( charm )
		}

		LoadoutEntry charmEntry = RegisterLoadoutSlot( eLoadoutEntryType.ITEM_FLAVOR, "weapon_charm_for_" + ItemFlavor_GetGUIDString( weaponFlavor ) )
		charmEntry.pdefSectionKey = "weapon " + ItemFlavor_GetGUIDString( weaponFlavor )
		charmEntry.DEV_category = "weapon_charms"
		charmEntry.DEV_name = ItemFlavor_GetHumanReadableRef( weaponFlavor ) + " Charm"
		charmEntry.defaultItemFlavor = charmList[0]
		charmEntry.validItemFlavorList = charmList
		charmEntry.isSlotLocked = bool function( EHI playerEHI ) {
			return !IsLobby()
		}
		charmEntry.networkTo = eLoadoutNetworking.PLAYER_EXCLUSIVE
		charmEntry.isItemFlavorUnlocked = bool function( EHI playerEHI, ItemFlavor flavor, bool shouldIgnoreGRX = false, bool shouldIgnoreOtherSlots = false ) : ( weaponFlavor ) {
			if ( !shouldIgnoreOtherSlots )
			{
				ItemFlavor ornull flavorCurrentWeaponEquippedTo = GetWeaponThatCharmIsCurrentlyEquippedToForPlayer( playerEHI, flavor )
				if ( flavorCurrentWeaponEquippedTo != null && flavorCurrentWeaponEquippedTo != weaponFlavor )
					return false
			}
			return IsItemFlavorGRXUnlockedForLoadoutSlot( playerEHI, flavor, shouldIgnoreGRX, shouldIgnoreOtherSlots )
		}

		#if SERVER && DEV
			                                                                                    
				                                             
				                                                                      

				                                                                                                                                             
					           

				                                                        
				 
					                                                     
						           
				 
				            
			 
		#endif

		AddCallback_ItemFlavorLoadoutSlotDidChange_AnyPlayer( charmEntry, void function( EHI playerEHI, ItemFlavor charm ) : ( weaponFlavor, charmEntry ) {
			#if SERVER
				                                                                        
			#endif
		} )

		fileLevel.loadoutWeaponCharmSlotMap[weaponFlavor] <- charmEntry
	}
}

void function SetupWeaponCharm( ItemFlavor charm )
{
	string charmModel = WeaponCharm_GetCharmModel( charm )

	#if SERVER || CLIENT
		if ( charmModel != "" )
			RegisterModel( charmModel )
	#endif
}

void function SetupWeaponSkin( ItemFlavor skin )
{
	if ( ItemFlavor_IsTheFavoriteSentinel( skin ) )
		return

	asset worldModel = WeaponSkin_GetWorldModel( skin )
	asset viewModel  = WeaponSkin_GetViewModel( skin )

	#if SERVER || CLIENT
		if ( worldModel != $"" )
			PrecacheModel( worldModel )
		if ( viewModel != $"" )
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


                          
                          
                          
                          
                          
LoadoutEntry function Loadout_WeaponSkin( ItemFlavor weaponFlavor )
{
	return fileLevel.loadoutWeaponSkinSlotMap[weaponFlavor]
}

LoadoutEntry function Loadout_WeaponCharm( ItemFlavor weaponFlavor )
{
	return fileLevel.loadoutWeaponCharmSlotMap[weaponFlavor]
}


bool function WeaponCharm_IsTheEmpty( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.weapon_charm )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "isTheEmpty" )
}

string function WeaponCharm_GetCharmModel( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.weapon_charm )

	string charmName = GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "charmModel" )
	if ( charmName == $"" )
		return charmName;
	return charmName + ".rmdl"
}

string function WeaponCharm_GetAttachmentName( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.weapon_charm )

	return GetGlobalSettingsString( ItemFlavor_GetAsset( flavor ), "attachmentName" )
}

int function WeaponCharm_GetSortOrdinal( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.weapon_charm )

	return fileLevel.cosmeticFlavorSortOrdinalMap[flavor]
}


ItemFlavor ornull function GetWeaponThatCharmIsCurrentlyEquippedToForPlayer( EHI playerEHI, ItemFlavor charmFlav )
{
	if ( WeaponCharm_IsTheEmpty( charmFlav ) )
		return null

	foreach ( ItemFlavor weaponFlav in GetAllWeaponItemFlavors() )
	{
		LoadoutEntry otherEntry = Loadout_WeaponCharm( weaponFlav )

		if ( LoadoutSlot_GetItemFlavor_ForValidation( playerEHI, otherEntry ) == charmFlav )
			return weaponFlav
	}

	return null
}


int function WeaponSkin_GetSortOrdinal( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.weapon_skin )

	return fileLevel.cosmeticFlavorSortOrdinalMap[flavor]
}

#if DEV && CLIENT
void function DEV_SetCharmForCurrentWeapon( asset charmModel, string attachmentName )
{
	entity player = GetLocalClientPlayer()
	PrecacheModel( charmModel )
	if ( IsValid( player ) )
	{
		entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
		if ( IsValid( weapon ) )
			weapon.SetWeaponCharm( charmModel, attachmentName )
		else
			printt( "Error: No active weapon to attach the charm to." )
	}
	else
	{
		printt( "Error: No valid local player. Can't attach charm to the active weapon." )
	}
}

entity function DEV_GetCharmForCurrentWeapon()
{
	entity player = GetLocalClientPlayer()
	entity charm  = null
	if ( IsValid( player ) )
	{
		entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
		if ( IsValid( weapon ) )
			charm = weapon.GetCurrentWeaponCharm()
		else
			printt( "Error: No active wpeaon to get the current charm." )
	}
	else
	{
		printt( "Error: No valid local player. Can't get charm for the active wepaon." )
	}
	return charm
}
#endif                     

#if SERVER && DEV
                                                                                                        
 
	                                               

	                        
	 
		                        
		 
			                           
			                                                                       
			                        
				                                                   
			    
				                                                           
		 
		    
		 
			                                                    
		 
	 
	    
	 
		                                                                                          
	 
 
#endif


                   
                   
                   
                   
                   
#if SERVER
                                                                                                        
 
	       
		                                                                      

		                                                   
		 
			                                                     
			 
				                                                              
					                                               

				                                                               
					                                               
			 
		 

		                                                                                                                                             
		 
			                                                              
				                                                                                   

			                                                               
				                                                                                   
		 
	      

	                                                                     
		                                              
 

                                                                                                                      
 
	                                                                                                                                                                           
	                                                                 
 
#endif          


ItemFlavor function WeaponSkin_GetWeaponFlavor( ItemFlavor skin )
{
	Assert( ItemFlavor_GetType( skin ) == eItemType.weapon_skin )

	Assert( GetGlobalSettingsAsset( ItemFlavor_GetAsset( skin ), "parentItemFlavor" ) != "", "No parentItemFlavor for skin "+ ItemFlavor_GetHumanReadableRef( skin ) )

	return GetItemFlavorByAsset( GetGlobalSettingsAsset( ItemFlavor_GetAsset( skin ), "parentItemFlavor" ) )
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

	var skinBlock = ItemFlavor_GetSettingsBlock( flavor )
	return GetSettingsArraySize( GetSettingsBlockArray( skinBlock, "featureReactsToKillsLevels" ) )
}


WeaponReactiveKillsData function WeaponSkin_GetReactToKillsDataForLevel( ItemFlavor flavor, int levelIdx )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.weapon_skin )
	Assert( WeaponSkin_DoesReactToKills( flavor ) )

	var skinBlock           = ItemFlavor_GetSettingsBlock( flavor )
	var reactsToKillsLevels = GetSettingsBlockArray( skinBlock, "featureReactsToKillsLevels" )
	Assert( levelIdx < GetSettingsArraySize( reactsToKillsLevels ) )
	var levelBlock = GetSettingsArrayElem( reactsToKillsLevels, levelIdx )

	WeaponReactiveKillsData rtked
	rtked.killCount = GetSettingsBlockInt( levelBlock, "killCount" )
	rtked.killSoundEvent1p = GetSettingsBlockString( levelBlock, "killSoundEvent1p" )
	rtked.killSoundEvent3p = GetSettingsBlockString( levelBlock, "killSoundEvent3p" )
	rtked.persistentSoundEvent1p = GetSettingsBlockString( levelBlock, "persistentSoundEvent1p" )
	rtked.persistentSoundEvent3p = GetSettingsBlockString( levelBlock, "persistentSoundEvent3p" )
	rtked.emissiveIntensity = GetSettingsBlockFloat( levelBlock, "emissiveIntensity" )
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
	foreach ( var bodygroupChangeBlock in IterateSettingsArray( GetSettingsBlockArray( levelBlock, "bodygroupChangeList" ) ) )
	{
		string name     = GetSettingsBlockString( bodygroupChangeBlock, "bodygroupName" )
		int submodelIdx = GetSettingsBlockInt( bodygroupChangeBlock, "submodelIdx" )
		rtked.bodygroupSubmodelIdxMap[name] <- submodelIdx
	}
	foreach ( var weaponModBlock in IterateSettingsArray( GetSettingsBlockArray( levelBlock, "weaponModListAdd" ) ) )
	{
		rtked.weaponModsToAdd.append( GetSettingsBlockString( weaponModBlock, "weaponMod" ) )
	}
	foreach ( var weaponModBlock in IterateSettingsArray( GetSettingsBlockArray( levelBlock, "weaponModListRemove" ) ) )
	{
		rtked.weaponModsToRemove.append( GetSettingsBlockString( weaponModBlock, "weaponMod" ) )
	}
	rtked.poseParameter = GetSettingsBlockFloat( levelBlock, "poseParameter" )
	return rtked
}


int function WeaponSkin_GetReactToKillsLevelIndexForKillCount( ItemFlavor flavor, int killCount )
{
	                                                            
	Assert( ItemFlavor_GetType( flavor ) == eItemType.weapon_skin )
	Assert( WeaponSkin_DoesReactToKills( flavor ) )

	var skinBlock = ItemFlavor_GetSettingsBlock( flavor )

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

#if CLIENT || UI
bool function WeaponSkin_ShouldHideIfLocked( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.weapon_skin )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "shouldHideIfLocked" )
}
#endif


const bool CHARM_DEBUG = false
#if SERVER || CLIENT
void function WeaponCosmetics_Apply( entity ent, ItemFlavor ornull skinOrNull, ItemFlavor ornull charmOrNull )
{
	if ( skinOrNull != null )
	{
		ItemFlavor skin = expect ItemFlavor( skinOrNull )
		Assert( ItemFlavor_GetType( skin ) == eItemType.weapon_skin )

		#if SERVER
			                                                                                                  
				                                              
		#endif

		ent.e.__itemFlavorNetworkId = ItemFlavor_GetNetworkIndex( skin )
		ent.SetSkin( 0 )                                                                                                                                                         

		#if SERVER
			                                                     
			 
				                                                                                                

				                                                                                                 
			 
			                                                    
			 
				                                                                                                                           
				                                                
				                                                                         

				                                                                        
			 
			    
			 
				                                                                                                              
			 
		#elseif CLIENT
			Assert( ent.IsClientOnly(), ent + " isn't client only" )
			Assert( ent.GetCodeClassName() == "dynamicprop", ent + " has classname \"" + ent.GetCodeClassName() + "\" instead of \"dynamicprop\"" )

			ent.SetModel( WeaponSkin_GetViewModel( skin ) )                                                                             
		#endif

		int skinIndex = ent.GetSkinIndexByName( WeaponSkin_GetSkinName( skin ) )
		int camoIndex = WeaponSkin_GetCamoIndex( skin )

		if ( skinIndex == -1 )
		{
			skinIndex = 0
			camoIndex = 0
		}

		if ( camoIndex >= CAMO_SKIN_COUNT )
		{
			Assert ( false, "Tried to set camoIndex of " + string(camoIndex) + " but the maximum index is " + string(CAMO_SKIN_COUNT) )
			camoIndex = 0
		}

		ent.SetSkin( skinIndex )
		ent.SetCamo( camoIndex )

		#if SERVER
			                                               
				                                               
		#endif
	}

	if ( charmOrNull != null )
	{
		ItemFlavor charm = expect ItemFlavor( charmOrNull )
		Assert( ItemFlavor_GetType( charm ) == eItemType.weapon_charm )
		string charmModel = WeaponCharm_GetCharmModel( charm )
		string attachmentName = WeaponCharm_GetAttachmentName( charm )

		ent.e.charmItemFlavorNetworkId = ItemFlavor_GetNetworkIndex( charm )

		#if SERVER
			                                               
			 
				                  
					                                                                                                                                                                                                      

				                                                         
				                       
					                                                
				    
					                      
			 
			                                                          
			 
				                                                                                                               
			 
		#elseif CLIENT
			Assert( ent.IsClientOnly(), ent + " isn't client only" )
			Assert( ent.GetCodeClassName() == "dynamicprop", ent + " has classname \"" + ent.GetCodeClassName() + "\" instead of \"dynamicprop\"" )

			if ( CHARM_DEBUG )
				printt( "CHARM_DEBUG: Setting weapon charm " + ItemFlavor_GetHumanReadableRef( charm ) + " for weapon " + ent + " ( " + ent.GetModelName() + " ) (client)" )

			DestroyCharmForWeaponEntity( ent )
			if ( charmModel != "" )
			{
				entity charmEnt = CreateClientSidePropDynamicCharm( ent.GetOrigin(), ent.GetAngles(), charmModel )
				charmEnt.MakeSafeForUIScriptHack()
				charmEnt.kv.renderamt = ent.kv.renderamt
				if ( ent.IsHidden() )
					charmEnt.Hide()
				charmEnt.SetParent( ent, attachmentName, false )
				charmEnt.SetModelScale( ent.GetModelScale() )

				fileLevel.menuWeaponCharmEntityMap[ent] <- charmEnt

				AddEntityDestroyedCallback( charmEnt, 
					void function ( entity charmEnt ) : ( ent ) 
					{
						if ( ent in fileLevel.menuWeaponCharmEntityMap )
						{
							delete fileLevel.menuWeaponCharmEntityMap[ent]
						}
					} 
				)
			}
		#endif
	}
}

int function CodeCallback_GetWeaponSkin( entity weapon )
{
	if ( !GetConVarBool( "enable_code_weapon_reactive" ) )
		return 0

	if ( !IsValid( weapon ) )
		return 0

	int weaponGrade = weapon.GetGrade()
	if ( !IsValidItemFlavorNetworkIndex( weaponGrade, eValidation.DONT_ASSERT ) )
	{
		printt( "Debugging CodeCallback_GetWeaponSkin: Not a valid item flavor network id: " + weaponGrade + " weapon name: " + weapon.GetWeaponClassName() )
		return 0
	}

	ItemFlavor weaponSkin = GetItemFlavorByNetworkIndex( weaponGrade )
	int flavorType = ItemFlavor_GetType( weaponSkin )

	Assert( flavorType == eItemType.weapon_skin, "Debugging CodeCallback_GetWeaponSkin: For weapon " + weapon.GetWeaponClassName() +
		": Itemflavor " + ItemFlavor_GetHumanReadableRef( weaponSkin ) + " is not a valid skin asset. GUID: " +  ItemFlavor_GetGUIDString( weaponSkin ) +  " Type: " + flavorType + " NetworkIndex: " + ItemFlavor_GetNetworkIndex( weaponSkin ) )

	if ( !GetGlobalSettingsBool( ItemFlavor_GetAsset( weaponSkin ), "featureReactsToKills" ) )
		return 0

	return ItemFlavor_GetGUID( weaponSkin )
}

#endif                    


#if CLIENT
entity function GetCharmForWeaponEntity( entity weapEnt )
{
	Assert( IsValid( weapEnt ) )
	Assert( weapEnt.IsClientOnly(), weapEnt + " isn't client only" )
	Assert( weapEnt.GetCodeClassName() == "dynamicprop", weapEnt + " has classname \"" + weapEnt.GetCodeClassName() + "\" instead of \"dynamicprop\"" )

	entity charmEnt = null
	if ( weapEnt in fileLevel.menuWeaponCharmEntityMap )
		charmEnt = fileLevel.menuWeaponCharmEntityMap[weapEnt]

	return charmEnt
}

void function DestroyCharmForWeaponEntity( entity weapEnt )
{
	Assert( IsValid( weapEnt ) )
	Assert( weapEnt.IsClientOnly(), weapEnt + " isn't client only" )
	Assert( weapEnt.GetCodeClassName() == "dynamicprop", weapEnt + " has classname \"" + weapEnt.GetCodeClassName() + "\" instead of \"dynamicprop\"" )

	if ( weapEnt in fileLevel.menuWeaponCharmEntityMap )
	{
		entity charmEnt = fileLevel.menuWeaponCharmEntityMap[weapEnt]
		delete fileLevel.menuWeaponCharmEntityMap[weapEnt]

		if ( IsValid( charmEnt ) )
			charmEnt.Destroy()
	}
}

#endif

#if SERVER
                                                                            
 
	                                                                                                                 
		      

	                           
		      

	                                                                             
	                                                          
	                         
		      

	                                          
	                                          
	                                                                                               
	                               
	 
		                                                                                                                          
		                                                                                                                            
	 

	                                                            
		                                                                    
 

#endif


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
			WeaponCosmetics_Apply( model, skin, null )
		}
	}

	model.Destroy()
}
#endif                 