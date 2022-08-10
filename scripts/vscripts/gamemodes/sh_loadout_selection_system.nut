                                                                                                            
                                                                                                                                                   
                                                                          

                                                                                                                                                                                
                                                                                                                                                                              
                                                                                                                                                                                
                                                                                                                                                                               
                                                    

                                                                                                      
                                     
                                                                                                                                                                          
                                                           

                   
                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                               
                                                                                                                                           

                                                                                                                                           
                                                                                                                                     

                                                                                                                           
                                                                                                                                                                             
                                                                                                                                                          


#if CLIENT || SERVER
global function LoadoutSelection_Init
global function LoadoutSelection_RegisterNetworking
#endif                    

#if SERVER
                                                             
                                                                
                                                              
                                                                   
                                                                        
                                                                                  
                                                                  
                                                              
                                                          
                                                                      
#endif          

#if CLIENT
global function UICallback_LoadoutSelection_BindOpticSlotButton
global function UICallback_LoadoutSelection_BindWeaponElement
global function UICallback_LoadoutSelection_OnRequestOpenScopeSelection
global function ServerCallback_LoadoutSelection_FinishedProcessingClickEvent
global function ServerCallback_LoadoutSelection_SetActiveLoadoutNameForSlot
global function ServerCallback_LoadoutSelection_UpdateLoadoutInfo
global function ServerCallback_LoadoutSelection_UpdateSelectedLoadoutInfo
global function UICallback_LoadoutSelection_OnOpticSlotButtonClick
global function UICallback_LoadoutSelection_OpticSelectDialogueClose
global function UICallback_LoadoutSelection_BindWeaponRui
global function UICallback_LoadoutSelection_BindItemIcon
global function UICallback_LoadoutSelection_SetConsumablesCountRui
global function LoadoutSelection_GetItemIcon
global function LoadoutSelection_GetWeaponLootTeir
global function LoadoutSelection_RefreshAllUILoadoutInfo
const string SOUND_SELECT_OPTIC = "ui_arenas_ingame_inventory_Select_Optic"
#endif          

#if UI
global function LoadoutSelection_UpdateLoadoutInfo_UI
global function LoadoutSelection_SetSelectedLoadoutSlotIndex_UI
global function LoadoutSelection_GetSelectedLoadoutSlotIndex_UI
#endif      

global function IsUsingLoadoutSelectionSystem
global function LoadoutSelection_GetWeaponCountByLoadoutIndex
                          
                                                            
                                                           
                                

global const int LOADOUTSELECTION_MAX_LOADOUT_COUNT_REGULAR = 6
                          
                                                                
                                                                 
                                                                                                                                                                                                   
     
global const int LOADOUTSELECTION_MAX_TOTAL_LOADOUT_SLOTS = LOADOUTSELECTION_MAX_LOADOUT_COUNT_REGULAR
                                

global const int LOADOUTSELECTION_MAX_WEAPONS_PER_LOADOUT = 2
global const int LOADOUTSELECTION_MAX_CONSUMABLES_PER_LOADOUT = 5
global const int LOADOUTSELECTION_MAX_SCOPE_INDEX = 9

#if CLIENT || UI
global function LoadoutSelection_GetLocalizedLoadoutHeader
global function LoadoutSelection_GetLoadoutSlotTypeForLoadoutIndex
global function LoadoutSelection_GetSelectedLoadoutSlotIndex_CL_UI
#endif                

#if CLIENT || SERVER
global function LoadoutSelection_GetWeaponSetStringForTier
global function LoadoutSelection_GetLoadoutContentsByLoadoutSlotIndex
global function LoadoutSelection_GetAvailableWeaponUpgradesForWeaponRef
global function LoadoutSelection_GetAvailableLoadoutCount

const string LOADOUTSELECTION_ROTATION_OVERRIDE_KEY = "rotation"
const string LOADOUTSELECTION_LOADOUT_OVERRIDE_KEY = "loadout"
const string LOADOUTSELECTION_WEAPONDATA_OVERRIDE_KEY = "weapondata"
const asset LOADOUTSELECTION_ROTATIONS_DATATABLE = $"datatable/loadoutselection_loadout_rotations.rpak"
const asset LOADOUTSELECTION_LOADOUTS_DATATABLE = $"datatable/loadoutselection_selectable_loadouts.rpak"
const asset LOADOUTSELECTION_WEAPON_DATA_DATATABLE = $"datatable/loadoutselection_weapon_data.rpak"
                      
                                                                                                          
                                                                                                           
      
                    
                                                                                      
                                                                                       
      

const array<string> LOADOUTSELECTION_WEAPON_SET_STRINGS_FOR_TIER = [ WEAPON_LOCKEDSET_SUFFIX_WHITESET, WEAPON_LOCKEDSET_SUFFIX_WHITESET, WEAPON_LOCKEDSET_SUFFIX_BLUESET, WEAPON_LOCKEDSET_SUFFIX_PURPLESET, WEAPON_LOCKEDSET_SUFFIX_GOLD ]

                                                                                                                                                              
                                                           
                                                                                                                                                                            
                                                                                                                                                         
global enum eLoadoutSelectionExclusivity
{
	NONE,
	RARITY,
	ALL,
	_count
}

                                                                                                                                                                                          
                       
                        
                         
                        
                            
global enum eLoadoutSelectionRotationStyle
{
	GAME,
	HOURLY,
	DAILY,
	WEEKLY,
	PERMANENT,
	_count
}
#endif                    

                                                                                        
                                          
                                
                                 
global enum eLoadoutSelectionSlotType
{
	INVALID,
	REGULAR,
                          
          
           
                                

	_count
}

#if CLIENT || SERVER
struct LoadoutSelectionItem
{
	string ref
	asset icon
	string name
	string desc
}

struct LoadoutSelectionLoadoutContents
{
	string loadoutNameText
	array< LoadoutSelectionItem > weaponLoadoutSelectionItemsInLoadout
	array< string > weaponsInLoadout
	string weaponLoadoutString
	int weaponExclusivityStyle
	string consumablesLoadoutString
	array< string > consumablesInLoadout
	array< LoadoutSelectionItem > consumableLoadoutSelectionItemsInLoadout
	int consumableExclusivityStyle
	array< string > equipmentInLoadout
	int equipmentExclusivityStyle
	#if SERVER
		                                                         
		                                                         
	#endif          
	#if CLIENT
		table < int, int > weaponIndexToScopePreferenceTable
	#endif          

}

struct LoadoutSelectionCategory
{
	int index
	string loadoutSlot
	int rotationStyle
	int loadoutSlotType

	table< string, LoadoutSelectionLoadoutContents > loadoutContentsByNameTable
	array< string > loadoutContentNames
	string activeLoadoutName = ""
}
#endif                    

struct {
	#if SERVER
		                  
		                                                 
		                                                 
		                                                                      
		                                                                     
		                                                                             
		                                                                                
		                                                                              
	#endif          
	#if CLIENT || SERVER
		asset rotationsDatatable = LOADOUTSELECTION_ROTATIONS_DATATABLE
		asset loadoutsDatatable = LOADOUTSELECTION_LOADOUTS_DATATABLE
		asset weaponDataDatatable = LOADOUTSELECTION_WEAPON_DATA_DATATABLE
		table<int, LoadoutSelectionCategory > loadoutSlotIndexToCategoryDataTable
		array<LoadoutSelectionCategory> loadoutCategories
		bool areLoadoutsPopulated = false
		table< int, WeaponLoadout > loadoutSlotIndexToWeaponLoadoutTable
		table<string, array<string> > weaponUpgrades
		table<string, array<string> > weaponOptics
	#endif                    

	                                                  
	table < int, int > loadoutSlotIndexToWeaponCountTable
	table < int, string > loadoutSlotIndexToHeaderTable
	table < int, int > loadoutSlotIndexToLoadoutTypeTable

	#if CLIENT || UI
		int playerSelectedLoadout = 0
	#endif                

	#if CLIENT
		int selectedLoadoutForOptic = -1
		bool isProcessingClickEvent = false
	#endif          
} file

#if CLIENT || SERVER
void function LoadoutSelection_Init()
{
	if ( !IsUsingLoadoutSelectionSystem() )
		return

	LoadoutSelection_SetDatatableAssets()
	LoadoutSelection_InitWeaponData()
	LoadoutSelection_RegisterLoadoutData()
	LoadoutSelection_RegisterLoadoutDistribution()

	#if SERVER
		                                        
	#endif          
	LoadoutSelection_PopulateLoadouts()
	#if SERVER
		                                                                                                                                                                          
		                                                            
		                                                  
		                                                           
	#endif          

	Remote_RegisterUIFunction( "LoadoutSelectionMenu_OpenLoadoutMenu", "bool" )
	Remote_RegisterUIFunction( "LoadoutSelectionMenu_CloseLoadoutMenu" )
}
#endif                    

bool function IsUsingLoadoutSelectionSystem()
{
	return GetCurrentPlaylistVarBool( "loadoutselection_enable_loadouts", false )
}

bool function LoadoutSelection_ShouldAvoidDuplicateWeaponsInLoadoutRotation()
{
	return GetCurrentPlaylistVarBool( "loadoutselection_avoid_duplicate_weapons_in_loadouts", false )
}

                          
                                                            
 
                                                                                        
 

                                                           
 
                                                                                       
 
                                


#if CLIENT || SERVER
                                                                                       
void function LoadoutSelection_SetDatatableAssets()
{
	                                                                                                                                     
	                                                                                                                                        
	                                                                                                                 

                       
                                      
   
                                                              
                                                            
   
       

                     
                       
  
                            
   
                                                    
                                                   
   
  
       

}

void function LoadoutSelection_RegisterNetworking()
{
	if ( !IsUsingLoadoutSelectionSystem() )
		return

	Remote_RegisterClientFunction( "ServerCallback_LoadoutSelection_FinishedProcessingClickEvent" )
	Remote_RegisterClientFunction( "ServerCallback_LoadoutSelection_SetActiveLoadoutNameForSlot", "string", "int", 0, LOADOUTSELECTION_MAX_TOTAL_LOADOUT_SLOTS + 1 )
	Remote_RegisterClientFunction( "ServerCallback_LoadoutSelection_UpdateLoadoutInfo", "int", 0, LOADOUTSELECTION_MAX_TOTAL_LOADOUT_SLOTS + 1, "string", "int", 0, LOADOUTSELECTION_MAX_WEAPONS_PER_LOADOUT + 1, "int", 0, eLoadoutSelectionSlotType._count, "int", -1, LOADOUTSELECTION_MAX_SCOPE_INDEX + 1, "int", -1, LOADOUTSELECTION_MAX_SCOPE_INDEX + 1 )
	Remote_RegisterClientFunction( "ServerCallback_LoadoutSelection_UpdateSelectedLoadoutInfo", "int", 0, LOADOUTSELECTION_MAX_TOTAL_LOADOUT_SLOTS + 1 )
	Remote_RegisterServerFunction( "ClientCallback_LoadoutSelection_OnLoadoutSelectMenuClose" )
	Remote_RegisterServerFunction( "ClientCallback_LoadoutSelection_OnLoadoutSelectMenuLoadoutSelected", "int", 0, LOADOUTSELECTION_MAX_TOTAL_LOADOUT_SLOTS + 1 )
	Remote_RegisterServerFunction( "ClientCallback_LoadoutSelection_SetOpticPreference", "int", 0, LOADOUTSELECTION_MAX_TOTAL_LOADOUT_SLOTS + 1, "int", 0, 2, "int", 0, LOADOUTSELECTION_MAX_SCOPE_INDEX + 1 )
	Remote_RegisterUIFunction( "LoadoutSelectionMenu_RefreshLoadouts", "int", 0, LOADOUTSELECTION_MAX_TOTAL_LOADOUT_SLOTS + 1, "int", 0, eLoadoutSelectionSlotType._count )
}

  
                                                                                                                            
                                                                                                                             
                                                                                                                           
                                                                                                                            
                                                                                                                             
                                                                                                                            
                      
  

                                                                                          
void function LoadoutSelection_RegisterLoadoutData()
{
	var dataTable = GetDataTable( file.rotationsDatatable )
	int numRows = minint( GetDataTableRowCount( dataTable ), LOADOUTSELECTION_MAX_TOTAL_LOADOUT_SLOTS )
	int index = 0
	int row = 0

	for ( int i = 0; i < numRows; i++ )
	{
		LoadoutSelectionCategory item
		row = i
		item.loadoutSlot = GetDataTableString( dataTable, row, GetDataTableColumnByName( dataTable, "loadoutSlot" ) )

		                                                       
		bool isSlotDisabled = GetCurrentPlaylistVarBool( "loadoutselection_dt_override_" + item.loadoutSlot + "_disable", false )
		if ( isSlotDisabled )
		{
			#if DEV
				printf( "LOADOUT SELECTION: RegisterLoadoutData skipping " + item.loadoutSlot + " because it is disabled through playlist vars" )
			#endif       

			continue
		}

		                                                                               
		string loadoutSlotToUseAsOverride = GetCurrentPlaylistVarString( "loadoutselection_dt_override_" + item.loadoutSlot + "_loadouts", "" )
		if ( loadoutSlotToUseAsOverride != "" )
		{
			#if DEV
				printf( "LOADOUT SELECTION: Overriding Loadout Slot: " + item.loadoutSlot + " with " + loadoutSlotToUseAsOverride )
			#endif       

			row = GetDataTableRowMatchingStringValue( dataTable, GetDataTableColumnByName( dataTable, "loadoutSlot" ), loadoutSlotToUseAsOverride )
			Assert( row > -1, "Attempted to override a Loadout Slot through playlist vars using an invalid Loadout Slot or a Slot that is not in the Rotations Datatable" )
			item.loadoutSlot = GetDataTableString( dataTable, row, GetDataTableColumnByName( dataTable, "loadoutSlot" ) )
		}

		item.index = index

		string loadoutSlotType = GetDataTableString( dataTable, row, GetDataTableColumnByName( dataTable, "loadoutSlotType" ) )
		item.loadoutSlotType = LoadoutSelection_GetLoadoutSlotTypeEnumFromString( loadoutSlotType )

		string rotationStyle = GetDataTableString( dataTable, row, GetDataTableColumnByName( dataTable, "rotationStyle" ) )
		item.rotationStyle = LoadoutSelection_GetRotationStyleEnumFromString( rotationStyle )
		string loadoutContentsString = GetDataTableString( dataTable, row, GetDataTableColumnByName( dataTable, "loadoutContentsList" ) )
		array<string> loadouts = GetTrimmedSplitString( loadoutContentsString, " " )
		foreach( loadout in loadouts )
		{
			                                                                           
			string loadoutToUseAsOverride = GetCurrentPlaylistVarString( "loadoutselection_dt_override_loadout_" + loadout, "" )
			if ( loadoutToUseAsOverride != "" )
			{
				#if DEV
					printf( "LOADOUT SELECTION: Overriding Loadout: " + loadout + " with " + loadoutToUseAsOverride )
				#endif       

				loadout = loadoutToUseAsOverride
			}

			LoadoutSelectionLoadoutContents newLoadoutStruct
			item.loadoutContentsByNameTable[loadout] <- newLoadoutStruct
			item.loadoutContentNames.append( loadout )
		}

		file.loadoutSlotIndexToCategoryDataTable[ index ] <- item
		file.loadoutCategories.append( item )
		index++
	}

	#if DEV
		printf( "LOADOUT SELECTION: RegisterLoadoutData Completed" )
	#endif       
}

                                                                                                                                 
void function LoadoutSelection_RegisterLoadoutDistribution()
{
	var distributionTable = GetDataTable( file.loadoutsDatatable )
	int numRows = GetDataTableRowCount( distributionTable )
	array<string> displayIgnoredItems
	array<string> loadoutsToDisable

	foreach ( item in file.loadoutCategories )
	{
		#if DEV
			printf( "LOADOUT SELECTION: Getting datatable for loadout " + item.loadoutSlot )
		#endif       

		foreach ( name, loadout in item.loadoutContentsByNameTable )
		{
			int startingRow = GetDataTableRowMatchingStringValue( distributionTable, GetDataTableColumnByName( distributionTable, "loadout" ), name )
			loadout.loadoutNameText = GetDataTableString( distributionTable, startingRow, GetDataTableColumnByName( distributionTable, "loadoutText" ) )
			string weaponExclusivityStyle = GetDataTableString( distributionTable, startingRow, GetDataTableColumnByName( distributionTable, "exclusivityStyleWeapons" ) )
			loadout.weaponExclusivityStyle = LoadoutSelection_GetExclusivityStyleEnumFromString( weaponExclusivityStyle )
			string consumableExclusivityStyle = GetDataTableString( distributionTable, startingRow, GetDataTableColumnByName( distributionTable, "exclusivityStyleConsumables" ) )
			loadout.consumableExclusivityStyle = LoadoutSelection_GetExclusivityStyleEnumFromString( consumableExclusivityStyle )
			string equipmentExclusivityStyle = GetDataTableString( distributionTable, startingRow, GetDataTableColumnByName( distributionTable, "exclusivityStyleEquipment" ) )
			loadout.equipmentExclusivityStyle = LoadoutSelection_GetExclusivityStyleEnumFromString( equipmentExclusivityStyle )

			bool didOverrideWeapons = false
			bool didOverrideConsumables = false
			bool didOverrideEquipment = false
			bool didDisableWeapon = false

			string loadoutNameTextOverride = GetCurrentPlaylistVarString( "loadoutselection_dt_override_loadout_" + name + "_name_text", "" )
			if ( loadoutNameTextOverride != "" )
			{
				loadout.loadoutNameText = loadoutNameTextOverride
			}
			                                                                        
			string loadoutPlaylistCheckWeapons = GetCurrentPlaylistVarString( "loadoutselection_dt_override_loadout_" + name + "_weapons", "" )
			if ( loadoutPlaylistCheckWeapons != "" )
			{
				loadout.weaponLoadoutString = loadoutPlaylistCheckWeapons
				array<string> weaponsInLoadout = GetTrimmedSplitString( loadoutPlaylistCheckWeapons, " " )
				foreach( weapon in weaponsInLoadout )
				{
					if ( LoadoutSelection_IsRefValidWeapon( weapon ) )
					{
						                                                                                              
						LootData data = SURVIVAL_Loot_GetLootDataByRef( weapon )
						if ( !SURVIVAL_Loot_IsRefDisabled( data.baseWeapon ) )
						{
							loadout.weaponsInLoadout.append( weapon )
						}
						else
						{
							didDisableWeapon = true
							Warning( "LOADOUT SELECTION: Attempting to override a weapon for loadout: " + name + " but the override weapon: " + data.baseWeapon + " is disabled (likely through playlist vars)" )
						}
					}
				}

				didOverrideWeapons = true
			}

			                                                                            
			string loadoutPlaylistCheckConsumables = GetCurrentPlaylistVarString( "loadoutselection_dt_override_loadout_" + name + "_consumables", "" )
			if ( loadoutPlaylistCheckConsumables != "" )
			{
				loadout.consumablesLoadoutString = loadoutPlaylistCheckConsumables
				array<string> consumablesInLoadout = ParseConsumableLoadoutText( loadoutPlaylistCheckConsumables, false )
				foreach( consumable in consumablesInLoadout )
				{
					if ( SURVIVAL_Loot_IsRefValid( consumable ) )
					{
						                                                                                                  
						if ( !SURVIVAL_Loot_IsRefDisabled( consumable ) )
							loadout.consumablesInLoadout.append( consumable )
					}
				}
				didOverrideConsumables = true
			}

			                                                                          
			string loadoutPlaylistCheckEquipment = GetCurrentPlaylistVarString( "loadoutselection_dt_override_loadout_" + name + "_equipment", "" )
			if ( loadoutPlaylistCheckEquipment != "" )
			{
				array<string> equipmentInLoadout = ParseEquipmentLoadoutText( loadoutPlaylistCheckEquipment, false, displayIgnoredItems )
				foreach( equipment in equipmentInLoadout )
				{
					if ( SURVIVAL_Loot_IsRefValid( equipment ) )
					{
						                                                                                                 
						if ( !SURVIVAL_Loot_IsRefDisabled( equipment ) )
							loadout.equipmentInLoadout.append( equipment )
					}
				}
				didOverrideEquipment = true
			}

			if ( startingRow == -1 )
				continue

			                                                                                                     
			if ( didOverrideWeapons && didOverrideConsumables && didOverrideEquipment )
				continue

			                                                                                                                             
			if ( didDisableWeapon )
			{
				loadoutsToDisable.append( name )
				continue
			}

			                         
			int currentRow = startingRow
			while ( ( currentRow < numRows && GetDataTableString( distributionTable, currentRow, GetDataTableColumnByName( distributionTable, "loadout" ) ) == "" ) || currentRow == startingRow )
			{
				string loadoutItem = GetDataTableString( distributionTable, currentRow, GetDataTableColumnByName( distributionTable, "contents" ) )
				if ( loadoutItem == "" || !SURVIVAL_Loot_IsRefValid( loadoutItem ) )
				{
					currentRow++
					continue
				}

				LootData data = SURVIVAL_Loot_GetLootDataByRef( loadoutItem )

				                                                        
				if ( !didOverrideWeapons && data.lootType == eLootType.MAINWEAPON )
				{
					                                                                                              
					if ( !SURVIVAL_Loot_IsRefDisabled( data.baseWeapon ) )
					{
						loadout.weaponsInLoadout.append( loadoutItem )

						if ( loadout.weaponLoadoutString == "" )
						{
							loadout.weaponLoadoutString = loadoutItem
						}
						else
						{
							loadout.weaponLoadoutString += " " + loadoutItem
						}
					}
					else
					{
						didDisableWeapon = true
					}
				}
				else if ( !didOverrideEquipment && ( data.lootType == eLootType.ARMOR || data.lootType == eLootType.BACKPACK || data.lootType == eLootType.INCAPSHIELD || data.lootType == eLootType.HELMET ) )
				{
					                                                                                                 
					if ( !SURVIVAL_Loot_IsRefDisabled( data.ref ) )
						loadout.equipmentInLoadout.append( loadoutItem )
				}
				else if ( !didOverrideConsumables )
				{
					                                                                                                  
					if ( !SURVIVAL_Loot_IsRefDisabled( data.ref ) )
					{
						loadout.consumablesInLoadout.append( loadoutItem )
						if ( loadout.consumablesLoadoutString == "" )
						{
							loadout.consumablesLoadoutString = loadoutItem
						}
						else
						{
							loadout.consumablesLoadoutString += " " + loadoutItem
						}
					}
				}
				                                                                                                                     
				if ( didDisableWeapon )
				{
					loadoutsToDisable.append( name )
					break
				}

				currentRow++
			}
		}
	}

	                                                                                               
	LoadoutSelection_RemoveLoadoutsWithDisabledWeaponsFromCategory( loadoutsToDisable )
}

                                                                                                                             
void function LoadoutSelection_RemoveLoadoutsWithDisabledWeaponsFromCategory( array<string> loadoutsToDisable )
{
	                               
	array< LoadoutSelectionCategory > loadoutCategories = clone file.loadoutCategories
	foreach ( name in loadoutsToDisable )
	{
		foreach ( loadoutCategory in loadoutCategories )
		{
			int loadoutCategoryIndex = loadoutCategory.index
			if ( name in file.loadoutCategories[ loadoutCategoryIndex ].loadoutContentsByNameTable )
				delete file.loadoutCategories[ loadoutCategoryIndex ].loadoutContentsByNameTable[ name ]

			if ( file.loadoutCategories[ loadoutCategoryIndex ].loadoutContentNames.contains( name ) )
				file.loadoutCategories[ loadoutCategoryIndex ].loadoutContentNames.removebyvalue( name )

			if ( file.loadoutCategories[ loadoutCategoryIndex ].activeLoadoutName == name )
				file.loadoutCategories[ loadoutCategoryIndex ].activeLoadoutName = ""
		}
	}

	                                              
	array< LoadoutSelectionCategory > emptyLoadoutCategories
	foreach ( loadoutCategory in file.loadoutCategories )
	{
		if ( loadoutCategory.loadoutContentNames.len() == 0 )
			emptyLoadoutCategories.append( loadoutCategory )
	}

	                                  
	if ( emptyLoadoutCategories.len() > 0 )
	{
		file.loadoutSlotIndexToCategoryDataTable.clear()

		foreach ( loadoutCategory in emptyLoadoutCategories )
		{
			if ( file.loadoutCategories.contains( loadoutCategory ) )
				file.loadoutCategories.removebyvalue( loadoutCategory )
		}

		                                                         
		for ( int index = 0; index < file.loadoutCategories.len(); index++ )
		{
			file.loadoutCategories[ index ].index = index
			file.loadoutSlotIndexToCategoryDataTable[ index ] <- file.loadoutCategories[ index ]
		}
	}
}

                                                                                                                   
void function LoadoutSelection_InitWeaponData()
{
	var dataTable    	= GetDataTable( file.weaponDataDatatable )
	int numRows      	= GetDataTableRowCount( dataTable )

	int col_weaponRef   = GetDataTableColumnByName( dataTable, "weaponRef" )
	int col_attachments = GetDataTableColumnByName( dataTable, "attachmentOverride" )
	int col_optics      = GetDataTableColumnByName( dataTable, "availableOptics" )
	int col_defaultOptic= GetDataTableColumnByName( dataTable, "defaultOptic" )

	for( int i = 0; i < numRows; ++i )
	{
		string weaponRef = strip( GetDataTableString( dataTable, i, col_weaponRef ) ).tolower()

		if ( weaponRef != "" )
		{
			if ( !( weaponRef in file.weaponUpgrades ) )
			{
				string upgrades = GetDataTableString( dataTable, i, col_attachments )
				upgrades = GetCurrentPlaylistVarString( "loadoutselection_" + weaponRef + "_attachment_override", upgrades )
				file.weaponUpgrades[ weaponRef ] <- split( upgrades, WHITESPACE_CHARACTERS )
				if( file.weaponUpgrades[ weaponRef ].len() == 0 )
					file.weaponUpgrades[ weaponRef ] = SURVIVAL_Weapon_GetBaseMods( weaponRef )

				string defaultOptic = GetDataTableString( dataTable, i, col_defaultOptic )
				if( defaultOptic != "" )
					ReplaceOpticInMods( file.weaponUpgrades[ weaponRef ], defaultOptic )
			}
			else
				Warning( "LoadoutSelection_InitWeaponData - weapon upgrades for %s already exists!", weaponRef )

			if ( !( weaponRef in file.weaponOptics ) )
			{
				string optics = GetDataTableString( dataTable, i, col_optics )
				optics = GetCurrentPlaylistVarString( "loadoutselection_" + weaponRef + "_optic_override", optics )
				file.weaponOptics[ weaponRef ] <- split( optics, WHITESPACE_CHARACTERS )
			}
			else
				Warning( "LoadoutSelection_InitWeaponData - available optics for %s already exists!", weaponRef )

		}
		else
		{
			Warning( "LoadoutSelection_InitWeaponData - Error reading LoadoutSelection_weapon_upgrades datatable. Expected weaponRef!" )
		}
	}
}

                                                                    
LoadoutSelectionItem function LoadoutSelection_GetLoadoutSelectionItemDataFromRef( string ref )
{
	table<string, LootData> allLootData = SURVIVAL_Loot_GetLootDataTable()
	LoadoutSelectionItem item
	if ( !( ref in allLootData ) )
		return item

	LootData data = allLootData[ ref ]
	item.ref = ref

	if( data.lootType == eLootType.MAINWEAPON )
	{
		item.name = GetWeaponInfoFileKeyField_GlobalString( data.baseWeapon, "shortprintname" )
	}
	else
	{
		item.name = ref
	}

	item.desc = data.desc
	item.icon = data.hudIcon
	return item
}

                                                                 
int function LoadoutSelection_GetExclusivityStyleEnumFromString( string input )
{
	int exclusivityStyle
	bool exclusivityStyleFound = false

	for ( int i = 0; i < eLoadoutSelectionExclusivity._count; i++ )
	{
		string enumStyle = GetEnumString( "eLoadoutSelectionExclusivity", i )
		if ( enumStyle == input )
		{
			exclusivityStyle = i
			exclusivityStyleFound = true
			break
		}
	}

	Assert( exclusivityStyleFound, "Loadout Selection System Exclusivity Style '" + input + "' is not a specified enumerator." )

	return exclusivityStyle
}

                                                                
int function LoadoutSelection_GetRotationStyleEnumFromString( string input )
{
	int rotationStyle
	bool rotationStyleFound = false

	for ( int i = 0; i < eLoadoutSelectionRotationStyle._count; i++ )
	{
		string enumStyle = GetEnumString( "eLoadoutSelectionRotationStyle", i )
		if ( enumStyle == input )
		{
			rotationStyle = i
			rotationStyleFound = true
			break
		}
	}
	Assert( rotationStyleFound, "Loadout Selection System Rotation Pattern '" + input + "' is not a specified enumerator." )

	return rotationStyle
}

                                                                   
int function LoadoutSelection_GetLoadoutSlotTypeEnumFromString( string input )
{
	int slotType
	bool slotTypeFound = false

	for ( int i = 0; i < eLoadoutSelectionSlotType._count; i++ )
	{
		string enumStyle = GetEnumString( "eLoadoutSelectionSlotType", i )
		if ( enumStyle == input )
		{
			slotType = i
			slotTypeFound = true
			break
		}
	}
	Assert( slotTypeFound, "Loadout Selection System Loadout Slot Type '" + input + "' is not a specified enumerator." )

	return slotType
}

                                                                            
array<string> function LoadoutSelection_GetAvailableWeaponUpgradesForWeaponRef( string weaponRef )
{
	array<string> availableUpgrades = []

	if ( weaponRef in file.weaponUpgrades )
		availableUpgrades = file.weaponUpgrades[ weaponRef ]

	return availableUpgrades
}
#endif                    

#if SERVER
                                                                                                           
                                                      
 
	                                       
		      

	                    
	                            
	                                                                                                         
	                                                                                                   
	 
		                                                                                                                                    

		                                      
		 
			                                                                                                         
			 
				                                                                                 
				                                                
					                                      
			 
		 
	 

	                        
	                                          
	 
		       
			                                                                                
		             

		                                                       
		                                          
		                                                                
			        

		                                                                                              
		                            
		                                                                                                                                        
		 
			                                             
			 
				                                         
					                               
			 
		 
		                                                                                                                                                                    
		 
			                                             
			 
				                                                                                                         
				 
					                                                                                                     
					                                                
						                                      
				 
			 
		 
		                                                      

		                                                                                    
		                                                                                                                                                                                                                                                
		                                                                             
		 
			                                                     
			 
				                                             
					                                   
			 
		 
		                                                      

		                               
		                                                                                                                                                                                                                                                            
		                                                                                                                           
		 
			                                                  
			 
				                                            
					                                  
			 
		   
		                                                                                                                        
		 
			                                                  
			 
				                                            
					                                                                                                                                                               
			 
		 
		  
		                                                      

	 

	                                                                    
	                                 
	 
		                                    
	 
 
#endif


  
                                                                                                                   
                                                                                                                    
                                                                                                                  
                                                                                                                   
                                                                                                                    
                                                                                                                   

                  
  

#if CLIENT || SERVER
                                                
LoadoutSelectionLoadoutContents function LoadoutSelection_GenerateLoadoutByLoadoutSlot( int loadoutIndex )
{
	Assert( loadoutIndex in file.loadoutSlotIndexToCategoryDataTable, "Running LoadoutSelection_GenerateLoadoutByLoadoutSlot and " + loadoutIndex + " is not a key for the file.loadoutSlotIndexToCategoryDataTable table" )
	LoadoutSelectionCategory loadoutCategory = file.loadoutSlotIndexToCategoryDataTable[ loadoutIndex ]
	LoadoutSelectionLoadoutContents loadout
	string activeLoadoutName
	#if SERVER
		                                                                                   
		                                                     
		                                     
		 
			                        
				                                                                                                                                       
		 
	#endif          
	#if CLIENT
		if ( loadoutCategory.activeLoadoutName == "" )
			return loadout

		activeLoadoutName = loadoutCategory.activeLoadoutName
	#endif          

	loadout = loadoutCategory.loadoutContentsByNameTable[ activeLoadoutName ]

	foreach( weapon in loadout.weaponsInLoadout )
	{
		LoadoutSelectionItem weaponItem = LoadoutSelection_GetLoadoutSelectionItemDataFromRef( weapon )
		loadout.weaponLoadoutSelectionItemsInLoadout.append( weaponItem )
	}

	foreach( consumable in loadout.consumablesInLoadout )
	{
		if ( SURVIVAL_Loot_IsRefValid( consumable ) )
		{
			LootData consumableData = SURVIVAL_Loot_GetLootDataByRef( consumable )
			if ( consumableData.lootType == eLootType.HEALTH )                                    
				continue
			LoadoutSelectionItem consumableItem = LoadoutSelection_GetLoadoutSelectionItemDataFromRef( consumable )
			loadout.consumableLoadoutSelectionItemsInLoadout.append( consumableItem )
		}
	}

	return loadout
}

                                                                 
void function LoadoutSelection_PopulateLoadouts()
{
	                                                                                                                            
	if ( file.areLoadoutsPopulated )
		return

	#if CLIENT
	if ( !IsValid( GetLocalClientPlayer() ) )
		return
	#endif          

	int loadoutIndex = 0
	bool didLoadoutCategoryFailToPopulate = false
	foreach ( loadoutCategory in file.loadoutCategories )
	{
		loadoutIndex = loadoutCategory.index
		                                                     
		LoadoutSelectionLoadoutContents loadout = LoadoutSelection_GenerateLoadoutByLoadoutSlot( loadoutIndex )
		file.loadoutSlotIndexToWeaponLoadoutTable[ loadoutIndex ] <- ParseWeaponLoadoutText( loadout.weaponLoadoutString, false )

		#if SERVER
			                                                         
			                                                                                             

			                                                      
			                                                                                          
		#endif          

		                                         
		file.loadoutSlotIndexToHeaderTable[ loadoutIndex ] <- loadout.loadoutNameText

		                                       
		file.loadoutSlotIndexToLoadoutTypeTable[ loadoutIndex ] <- loadoutCategory.loadoutSlotType

		                                                                                                                                          
		if ( loadout.weaponLoadoutSelectionItemsInLoadout.len() <= 0 )
			didLoadoutCategoryFailToPopulate = true

		file.loadoutSlotIndexToWeaponCountTable[ loadoutIndex ] <- loadout.weaponLoadoutSelectionItemsInLoadout.len()
	}
	
	if ( !didLoadoutCategoryFailToPopulate )
		file.areLoadoutsPopulated = true

	#if SERVER
		                                              
		                                     
		 
			                        
			 
				                                                    
			 
		 
	#endif          
}

                                                          
WeaponLoadout function LoadoutSelection_GetWeaponLoadoutByLoadoutSlotIndex( int loadoutIndex )
{
	WeaponLoadout loadout
	if ( loadoutIndex in file.loadoutSlotIndexToWeaponLoadoutTable )
	loadout = file.loadoutSlotIndexToWeaponLoadoutTable[ loadoutIndex ]

	return loadout
}

                                                                                     
string function LoadoutSelection_GetWeaponSetStringForTier( int tier )
{
	return LOADOUTSELECTION_WEAPON_SET_STRINGS_FOR_TIER[ tier ]
}

                                                                
string function LoadoutSelection_GetWeaponRefByIndex( int loadoutIndex, int weaponIndex )
{
	WeaponLoadout weaponLoadoutData = LoadoutSelection_GetWeaponLoadoutByLoadoutSlotIndex( loadoutIndex )
	array<string> weaponRefs = weaponLoadoutData.weaponRefs
	Assert( weaponRefs.len() >= weaponIndex, "LoadoutSelection_GetWeaponRefByIndex the weapon index passed from the menu " + weaponIndex + " is greater than the number of weapon refs " + weaponRefs.len() + " in slot " + loadoutIndex )
	return weaponRefs[weaponIndex]
}
#endif                    

#if SERVER
                                                            
                                                                                                    
 
	                                                                                             
		      

	                                                         
 

                                                              
                                                                                 
 
	             

	                        
	 
		                      
		 
			                                                  
				                                                 
		 
		                               
		 
			                                       
				                                                         
		 
	 

	            
 
#endif          

#if CLIENT || UI
                                                                    
int function LoadoutSelection_GetSelectedLoadoutSlotIndex_CL_UI()
{
	return file.playerSelectedLoadout
}
#endif                

#if SERVER
                                                             
                                                                                                   
 
	                            
	                                                                   
		                                                                      

	              
 

                                                              
                                                                                                    
 
	                            
	                                                                    
		                                                                       

	              
 
#endif          

#if CLIENT
                                                                          
void function ServerCallback_LoadoutSelection_SetActiveLoadoutNameForSlot( string activeLoadoutName, int loadoutCategoryIndex )
{
	if ( loadoutCategoryIndex < file.loadoutCategories.len() )
		file.loadoutCategories[ loadoutCategoryIndex ].activeLoadoutName = activeLoadoutName
}
#endif          

                                                     
int function LoadoutSelection_GetWeaponCountByLoadoutIndex( int loadoutIndex )
{
	int weaponCount = 0
	if ( loadoutIndex in file.loadoutSlotIndexToWeaponCountTable )
		weaponCount = file.loadoutSlotIndexToWeaponCountTable[ loadoutIndex ]

	return weaponCount
}

#if SERVER
                                                                                     
                                                
 
	                                                                      
 

                                            
                                                                                    
 
	                                               
	                               

	                                    
	 
		                                   
		        
	 

	                                          
	 
		                                                 
		                                                           
		 
			                        
			 
				                                                                                                                                     
			 
		 
		    
		 
			        
		 
	 
 

                                               
                                                                                                        
 
	                                                   
	                 
	                                                                   
	                                                                  
	 
		                                                                                                                                                                        
		                                                                                      
		                                                             

		                                                                                                                                              
		                                                    
			                                                                                                          

		                                                           
	 

	                                                
	                                                                                                                                
	                                     

	                                                                                         
	                                                                                                                                                      
	                                

	                                                                    
	                                                                                                           
	                                                                                         
	                                                                                        
	                                                                                         

	                   
	                                                               
	 
		                                    
	 
	                                                                   
	 
		                                   
	 
	                                                                    
	 
		                                    
	 
	                                                                  
	 
		                                           
	 

	                                                                                  

	                                                                                                                                                                                       
	                                                                      
		                                                                                                          

	                                                           
 

                                                                        
                                                                                                                                            
 
	                                         
	                                                                                                                        
	                            
	                              
	                                              
	                                              
	 
		                                       
		 
			                                                    
			                                                                     
			 
				                                                                               
				                                                        
				 
					                                              
					                                       
						                             
				 
			 
		 
	 

	                                                                                                   
	                            
	                                
	                                                                                                     
	 
		                               
		                                                                      
		                                                                            
		 
			                                                                                       
			                                                        
			 
				                                              
				                                      
					                              
			 

			                               
			 
				                     
				                          
				     
			 
		 
	 

	                                                 
	                          
		                    

	                                                                                                            
	                                                         
	 
		                                                             
		 
			                               
			                                                                      
			                                                                            
			 
				                                                                                       
				                                                        
				 
					                                              
					                                      
						                              
				 

				                               
				 
					                     
					                          
					     
				 
			 
		 
	 

	                                                                                                                
	                    
 

                                                                                                          
                                                                                              
 
	                                                                            
	                                                               
 

                                                                                                   
                                                                                                 
 
	                                                                               
	                                                                  
 

                                                                                     
                                                                                               
 
	                                                                             
	                                                                
 

                                                                             
                                                                                                                                                                                                                                
 
	                         
		      

	                                                                                

	                 
	                       
		                                                                                                                                

	                        
		      

	                   
	                                                                                                                                  


	                                                                         
	                                                             
	                                                                 
	                                                                       
	                                                                            

	                                     
	 
		                                       
		 
			                                                                        
			                             
		 
		    
		 
			      
		 

	 

	                                       
	 
		                                       
		 
			                                                                          
			                               
		 
		    
		 
			      
		 

	 

	                                                                                                
	                                                                                       
	                                 
	 
		                                                    
		 
			                                                            
		 
	 
	    
	 
		                                               
		 
			                                                            
		 
	 

	                                                                                              

	                                                        
 

                                                          
                                                                             
 
	                         
		      

	                                                                                
	                                
	                                                    
	 
		                                                                                                                                 
		                                                              
		                                                                                                                                                                                       
		                                                          
		                                                                                                     
	 

	                               
	                                                        
	                                                  
	 
		                                                                  
		 
			                                                                                         

			                                                                                                
			                                                          
		 
	 
	    
	 
		                                                                                                 
		                                                           
	 
 
#endif          

  
                                                                                                                 
                                                                                                                  
                                                                                                                
                                                                                                                 
                                                                                                                  
                                                                                                                 

                    
  
#if SERVER
                                                                                      
                                                                                       
 
		                                                                                 
		                        
		 
			                                                                       
				              

			                                                            
		 
 

                                                                                                       
                                                                                                                  
 
	                                                                                           
		      

	                                                                          
	                                                    

	                        
	 
		                                                                                                  
		                                                                     
			              
	 
 

                                                                                          
                                                                                                   
                                                                         
 
	                         
		      

	                    
	                                               

                           
                                                            
                              
                               
                                 

	                                                     
	 
		                                    
		                                                                                                                       
		                                                          
		                         
		                         

		                                                                    
			                                                                                

		                                                                    
			                                                                                

		                                                                                                                                                                                                                                                              

                            
                                                                               
    
                  
                          
    

                                                                                
    
                  
                           
    
                                  
	 

	                                                                                                                         

                           
                                                      
                                                                                                                                     

                                                       
                                                                                                                                       
                                 

	                                                                                                                                                                   

	                                                                                       
	                                                                    
	 
		              
	 
 
#endif          

#if UI
                                                                                                                                                       
void function LoadoutSelection_UpdateLoadoutInfo_UI( int loadoutIndex, string loadoutHeaderText, int weaponCount, int loadoutType )
{
	file.loadoutSlotIndexToHeaderTable[ loadoutIndex ] <- loadoutHeaderText
	file.loadoutSlotIndexToWeaponCountTable[ loadoutIndex ] <- weaponCount
	file.loadoutSlotIndexToLoadoutTypeTable[ loadoutIndex ] <- loadoutType
}

                                                        
void function LoadoutSelection_SetSelectedLoadoutSlotIndex_UI( int loadoutIndex )
{
	if ( loadoutIndex < 0 || loadoutIndex >= LOADOUTSELECTION_MAX_TOTAL_LOADOUT_SLOTS )
		return

	file.playerSelectedLoadout = loadoutIndex
}

int function LoadoutSelection_GetSelectedLoadoutSlotIndex_UI()
{
	return file.playerSelectedLoadout
}
#endif      

#if CLIENT || UI
                                              
string function LoadoutSelection_GetLocalizedLoadoutHeader( int loadoutSlotIndex )
{
	string header = ""

	if ( !( loadoutSlotIndex in file.loadoutSlotIndexToHeaderTable ) )
		return header

	return Localize( file.loadoutSlotIndexToHeaderTable[ loadoutSlotIndex ] )
}

                                                                                                 
int function LoadoutSelection_GetLoadoutSlotTypeForLoadoutIndex( int loadoutSlotIndex )
{
	int slotType = eLoadoutSelectionSlotType.INVALID

	if ( loadoutSlotIndex in file.loadoutSlotIndexToLoadoutTypeTable )
		slotType = file.loadoutSlotIndexToLoadoutTypeTable[ loadoutSlotIndex ]

	return slotType
}
#endif                

#if CLIENT
                                                                                                                            
void function ServerCallback_LoadoutSelection_UpdateLoadoutInfo( int loadoutIndex, string loadoutHeaderText, int weaponCount, int loadoutType, int weapon0ScopePref, int weapon1ScopePref )
{
	file.loadoutSlotIndexToHeaderTable[ loadoutIndex ] <- loadoutHeaderText
	file.loadoutSlotIndexToWeaponCountTable[ loadoutIndex ] <- weaponCount
	file.loadoutSlotIndexToLoadoutTypeTable[ loadoutIndex ] <- loadoutType

	LoadoutSelectionLoadoutContents	data = LoadoutSelection_GetLoadoutContentsByLoadoutSlotIndex( loadoutIndex )
	if ( weapon0ScopePref > -1 && weapon0ScopePref <= LOADOUTSELECTION_MAX_SCOPE_INDEX )
		data.weaponIndexToScopePreferenceTable[ 0 ] <- weapon0ScopePref

	if ( weapon1ScopePref > -1 && weapon1ScopePref <= LOADOUTSELECTION_MAX_SCOPE_INDEX )
		data.weaponIndexToScopePreferenceTable[ 1 ] <- weapon1ScopePref

	RunUIScript( "LoadoutSelection_UpdateLoadoutInfo_UI", loadoutIndex, loadoutHeaderText, weaponCount, loadoutType )
}

                                                                                                                                 
                                                                                                                                                            
void function LoadoutSelection_RefreshAllUILoadoutInfo()
{
	string loadoutHeaderText
	int weaponCount
	int loadoutType
	int loadoutIndex

	foreach ( loadoutCategory in file.loadoutCategories )
	{
		loadoutHeaderText = ""
		weaponCount = -1
		loadoutType = eLoadoutSelectionSlotType.INVALID
		loadoutIndex = loadoutCategory.index

		if ( loadoutIndex in file.loadoutSlotIndexToHeaderTable )
		{
			loadoutHeaderText = file.loadoutSlotIndexToHeaderTable[ loadoutIndex ]
		}

		if ( loadoutIndex in file.loadoutSlotIndexToWeaponCountTable )
		{
			weaponCount = file.loadoutSlotIndexToWeaponCountTable[ loadoutIndex ]
		}

		if ( loadoutIndex in file.loadoutSlotIndexToLoadoutTypeTable )
		{
			loadoutType = file.loadoutSlotIndexToLoadoutTypeTable[ loadoutIndex ]
		}

		if ( loadoutType != eLoadoutSelectionSlotType.INVALID && weaponCount != -1 && loadoutHeaderText != "")
			RunUIScript( "LoadoutSelection_UpdateLoadoutInfo_UI", loadoutIndex, loadoutHeaderText, weaponCount, loadoutType )
	}

	RunUIScript( "LoadoutSelectionMenu_ResetLoadoutButtons" )
}

                                                                                                                                 
void function ServerCallback_LoadoutSelection_UpdateSelectedLoadoutInfo( int selectedLoadout )
{
	if ( selectedLoadout < 0 || selectedLoadout >= LOADOUTSELECTION_MAX_TOTAL_LOADOUT_SLOTS )
		return

	file.playerSelectedLoadout = selectedLoadout
	RunUIScript( "LoadoutSelection_SetSelectedLoadoutSlotIndex_UI", selectedLoadout )
}

                                                                                                          
void function UICallback_LoadoutSelection_BindWeaponRui( var element, int loadoutIndex, int weaponIndex )
{
	if ( weaponIndex == -1 || loadoutIndex == -1 )
		return

	if ( IsLobby() )
		return

	var rui = Hud_GetRui( element )
	if ( !IsValid( rui ) )
		return

	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return

	Hud_ClearToolTipData( element )
	string entVar = Hud_GetScriptID( element )

	LoadoutSelectionLoadoutContents	data = LoadoutSelection_GetLoadoutContentsByLoadoutSlotIndex( loadoutIndex )
	int opticsIndex = -1

	if ( weaponIndex in data.weaponIndexToScopePreferenceTable  )
		opticsIndex = data.weaponIndexToScopePreferenceTable[ weaponIndex ]

	thread LoadoutSelection_BindWeaponButton_Thread( player, element, rui, loadoutIndex, weaponIndex, entVar, opticsIndex )
}

                                                                                                 
void function LoadoutSelection_BindWeaponButton_Thread( entity player, var element, var rui, int loadoutIndex, int weaponIndex, string entVar, int opticsIndex )
{
	Assert( IsNewThread(), "Must be threaded off" )
	player.EndSignal( "OnDestroy" )

	RuiSetString( rui, "weaponName", "" )
	RuiSetImage( rui, "iconImage", $"" )
	RuiSetImage( rui, "ammoTypeImage", $"" )
	RuiSetInt( rui, "lootTier", 0 )
	RuiSetBool( rui, "barrelAllowed", false )
	RuiSetBool( rui, "magAllowed", false )
	RuiSetBool( rui, "sightAllowed", false )
	RuiSetBool( rui, "gripAllowed", false )
	RuiSetBool( rui, "hopupMultiAAllowed", false )
	RuiSetBool( rui, "hopupMultiBAllowed", false )

	if ( weaponIndex == -1 || loadoutIndex == -1 )
		return

	while ( !file.areLoadoutsPopulated )
	{
		LoadoutSelection_PopulateLoadouts()
		wait 1.0
	}

	if ( !IsValid( rui ) )
		return

	LoadoutSelectionLoadoutContents loadoutContents = LoadoutSelection_GetLoadoutContentsByLoadoutSlotIndex( loadoutIndex )

	if ( LoadoutSelection_GetWeaponCountByLoadoutIndex( loadoutIndex ) == 0 )
		return

	LoadoutSelectionItem item
	if ( LoadoutSelection_GetWeaponCountByLoadoutIndex( loadoutIndex ) > weaponIndex )
	{
		item = loadoutContents.weaponLoadoutSelectionItemsInLoadout[ weaponIndex ]
	}
	else
	{
		return
	}

	RuiSetImage( rui, "iconImage", item.icon )
	if ( element != null )
	{
		Hud_SetWidth( element, Hud_GetBaseWidth( element ) )
		Hud_SetVisible( element, true )
	}

	if ( SURVIVAL_Loot_IsRefValid( item.ref ) )
	{
		LootData data = SURVIVAL_Loot_GetLootDataByRef( item.ref )
		bool isLockedSet = WeaponLootRefIsLockedSet( item.ref )
		int lootTier = isLockedSet ? data.tier : 0
		RuiSetInt( rui, "lootTier", lootTier )

		if ( data.lootType == eLootType.MAINWEAPON )
		{
			LootData baseWeaponData = SURVIVAL_Loot_GetLootDataByRef( data.baseWeapon )
			string ammoType = GetWeaponAmmoType( data.baseWeapon )
			if ( GetWeaponInfoFileKeyField_GlobalBool( data.baseWeapon, "uses_ammo_pool" ) )
			{
				LootData ammoData = SURVIVAL_Loot_GetLootDataByRef( ammoType )
				RuiSetImage( rui, "ammoTypeImage", ammoData.hudIcon )
			}

			RuiSetString( rui, "weaponName", data.pickupString )

			if ( lootTier == 0 )
			{
				int attachIndex = 0
				for( int i = 0; i < baseWeaponData.supportedAttachments.len(); ++i )
				{
					string attachment = baseWeaponData.supportedAttachments[i]
					if( attachment == "hopupMulti_a" )
						attachment = "hopupMultiA"
					else if( attachment == "hopupMulti_b" )
						attachment = "hopupMultiB"

					RuiSetBool( rui, attachment + "Allowed", true )
					RuiSetInt( rui, attachment + "Slot", i )


					string attachStyle = GetAttachmentPointStyle( baseWeaponData.supportedAttachments[i], baseWeaponData.ref )

					                                                                    
					                                                                                            
					if( attachStyle == "grip" && ( baseWeaponData.lootTags.contains( "sniper" ) || baseWeaponData.lootTags.contains( "marksman" ) ) )
						attachStyle = "stock_sniper"

					RuiSetImage( rui, attachment + "Icon", emptyAttachmentSlotImages[attachStyle] )

					if ( attachStyle != "sight" )                                                    
						attachIndex++
				}
			}
			else if ( item.ref in file.weaponUpgrades )
			{
				array<string> upgrades = file.weaponUpgrades[ item.ref ]
				int attachIndex = 0
				for( int i = 0; i < upgrades.len(); ++i )
				{
					if( !SURVIVAL_Loot_IsRefValid( upgrades[i] ) )
						continue

					LootData lootData  = SURVIVAL_Loot_GetLootDataByRef( upgrades[i] )
					string attachStyle = GetAttachPointForAttachmentOnWeapon( item.ref, upgrades[i] )

					if( attachStyle == "hopupMulti_a" )
						attachStyle = "hopupMultiA"
					else if( attachStyle == "hopupMulti_b" )
						attachStyle = "hopupMultiB"

					if( attachStyle == "" )
						continue

					if ( attachStyle == "sight" )
					{
						if ( opticsIndex > -1 && opticsIndex <= LOADOUTSELECTION_MAX_SCOPE_INDEX )
						{
							array<string> optics = LoadoutSelection_GetAvailableOptics( loadoutIndex, weaponIndex, true )
							if ( opticsIndex < optics.len() )
							{
								if ( SURVIVAL_Loot_IsRefValid( optics[ opticsIndex ] ) )
								{
									lootData = SURVIVAL_Loot_GetLootDataByRef( optics[ opticsIndex ] )
								}
								else if ( optics[ opticsIndex ] == "" )
								{
									RuiSetImage( rui, attachStyle + "Icon", $"rui/pilot_loadout/mods/empty_sight" )
									RuiSetBool( rui, attachStyle + "Allowed", true )
									RuiSetInt( rui, attachStyle + "Slot", attachIndex )
									RuiSetInt( rui, attachStyle + "Tier", 0 )
									continue
								}
							}
						}
					}

					RuiSetImage( rui, attachStyle + "Icon", lootData.hudIcon )
					RuiSetBool( rui, attachStyle + "Allowed", true )
					RuiSetInt( rui, attachStyle + "Slot", attachIndex )
					RuiSetInt( rui, attachStyle + "Tier", lootData.tier )
					if ( attachStyle != "sight" )                                                    
						attachIndex++
				}
			}
		}
	}
}

                                                
void function UICallback_LoadoutSelection_SetConsumablesCountRui( var element, int loadoutIndex )
{
	LoadoutSelectionLoadoutContents loadoutContents = LoadoutSelection_GetLoadoutContentsByLoadoutSlotIndex( loadoutIndex )

	array< LoadoutSelectionItem > ConsumablesInLoadout = loadoutContents.consumableLoadoutSelectionItemsInLoadout

	var rui = Hud_GetRui( element )
	if ( !IsValid( rui ) )
		return

	RuiSetInt( rui, "consumablesCount", ConsumablesInLoadout.len() )
}

                                                         
void function UICallback_LoadoutSelection_BindItemIcon( var icon, int loadoutIndex, int weaponIndex, int consumableIndex )
{
	if ( IsLobby() )
		return

	if ( icon == null )
		return

	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return

	var rui = Hud_GetRui( icon )
	if ( !IsValid( rui ) )
		return

	thread LoadoutSelection_BindItemIcon_Thread( player, icon, rui, loadoutIndex, weaponIndex, consumableIndex )
}

                                                                                      
void function LoadoutSelection_BindItemIcon_Thread( entity player, var icon, var rui, int loadoutIndex, int weaponIndex, int consumableIndex )
{
	Assert( IsNewThread(), "Must be threaded off" )
	player.EndSignal( "OnDestroy" )
	RuiSetImage( rui, "basicImage", $"" )

	while ( !file.areLoadoutsPopulated )
	{
		LoadoutSelection_PopulateLoadouts()
		wait 1.0
	}

	                                 
	if ( loadoutIndex < 0 || loadoutIndex >= LOADOUTSELECTION_MAX_TOTAL_LOADOUT_SLOTS )
		return

	if ( icon == null )
		return

	LoadoutSelectionLoadoutContents loadoutContents = LoadoutSelection_GetLoadoutContentsByLoadoutSlotIndex( loadoutIndex )
	LoadoutSelectionItem item

	if ( weaponIndex >= 0 )                     
	{
		if ( LoadoutSelection_GetWeaponCountByLoadoutIndex( loadoutIndex ) == 0 )
			return


		if ( LoadoutSelection_GetWeaponCountByLoadoutIndex( loadoutIndex ) > weaponIndex )
		{
			item = loadoutContents.weaponLoadoutSelectionItemsInLoadout[ weaponIndex ]
			RuiSetImage( rui, "basicImage", item.icon )
			Hud_SetVisible( icon, true )
		}
	}
	else if ( consumableIndex >= 0 )                         
	{
		array< LoadoutSelectionItem > ConsumablesInLoadout = loadoutContents.consumableLoadoutSelectionItemsInLoadout

		if ( ConsumablesInLoadout.len() == 0 )
			return


		if ( ConsumablesInLoadout.len() > consumableIndex )
		{
			item = ConsumablesInLoadout[ consumableIndex ]
			RuiSetImage( rui, "basicImage", item.icon )
			Hud_SetVisible( icon, true )
		}
	}
}

                                                                                                                                                
asset function LoadoutSelection_GetItemIcon( int loadoutIndex, int weaponIndex, int consumableIndex )
{
	asset image = $""

	                                  
	if ( loadoutIndex < 0 || loadoutIndex >= LOADOUTSELECTION_MAX_TOTAL_LOADOUT_SLOTS )
		return image

	LoadoutSelectionLoadoutContents loadoutContents = LoadoutSelection_GetLoadoutContentsByLoadoutSlotIndex( loadoutIndex )
	LoadoutSelectionItem item

	if ( weaponIndex >= 0 )                     
	{
		if ( LoadoutSelection_GetWeaponCountByLoadoutIndex( loadoutIndex ) == 0 )
		{
			LoadoutSelection_PopulateLoadouts()
			loadoutContents = LoadoutSelection_GetLoadoutContentsByLoadoutSlotIndex( loadoutIndex )
		}

		if ( LoadoutSelection_GetWeaponCountByLoadoutIndex( loadoutIndex ) > weaponIndex )
			item = loadoutContents.weaponLoadoutSelectionItemsInLoadout[ weaponIndex ]
	}
	else if ( consumableIndex >= 0 )                         
	{
		array< LoadoutSelectionItem > ConsumablesInLoadout = loadoutContents.consumableLoadoutSelectionItemsInLoadout

		if ( ConsumablesInLoadout.len() == 0 )
		{
			LoadoutSelection_PopulateLoadouts()
			loadoutContents = LoadoutSelection_GetLoadoutContentsByLoadoutSlotIndex( loadoutIndex )
			ConsumablesInLoadout = loadoutContents.consumableLoadoutSelectionItemsInLoadout
		}

		if ( ConsumablesInLoadout.len() > 0 )
			item = ConsumablesInLoadout[ consumableIndex ]
	}

	image = item.icon
	return image
}

                                                                                                                                                
int function LoadoutSelection_GetWeaponLootTeir( int loadoutIndex, int weaponIndex )
{
	int lootTier = 0

	                                  
	if ( loadoutIndex < 0 || loadoutIndex >= LOADOUTSELECTION_MAX_TOTAL_LOADOUT_SLOTS )
		return lootTier

	LoadoutSelectionLoadoutContents loadoutContents = LoadoutSelection_GetLoadoutContentsByLoadoutSlotIndex( loadoutIndex )
	LoadoutSelectionItem item

	if ( weaponIndex >= 0 )                     
	{
		if ( LoadoutSelection_GetWeaponCountByLoadoutIndex( loadoutIndex ) == 0 )
		{
			LoadoutSelection_PopulateLoadouts()
			loadoutContents = LoadoutSelection_GetLoadoutContentsByLoadoutSlotIndex( loadoutIndex )
		}

		if ( LoadoutSelection_GetWeaponCountByLoadoutIndex( loadoutIndex ) > weaponIndex )
			item = loadoutContents.weaponLoadoutSelectionItemsInLoadout[ weaponIndex ]
	}

	if ( SURVIVAL_Loot_IsRefValid( item.ref ) )
	{
		LootData data = SURVIVAL_Loot_GetLootDataByRef( item.ref )
		bool isLockedSet = WeaponLootRefIsLockedSet( item.ref )
		lootTier = isLockedSet ? data.tier : 0
	}

	return lootTier
}
#endif          

  
                                         
                                          
                                        
                                         
                                          
                                         

         
  


#if CLIENT
void function UICallback_LoadoutSelection_BindWeaponElement( var element, int selectedWeapon = -1 )
{
	if ( IsLobby() )
		return

	if ( file.selectedLoadoutForOptic == -1 || selectedWeapon == -1 )
		return

	if ( !file.areLoadoutsPopulated )
		return

	var rui = Hud_GetRui( element )

	RuiSetImage( rui, "iconImage", $"" )
	RuiSetInt( rui, "lootTier", -1 )
	RuiSetString( rui, "weaponName", "" )

	LoadoutSelectionLoadoutContents loadoutContents = LoadoutSelection_GetLoadoutContentsByLoadoutSlotIndex( file.selectedLoadoutForOptic )
	LoadoutSelectionItem item
	if ( LoadoutSelection_GetWeaponCountByLoadoutIndex( file.selectedLoadoutForOptic ) > selectedWeapon )
	{
		item = loadoutContents.weaponLoadoutSelectionItemsInLoadout[ selectedWeapon ]
	}
	else
	{
		return
	}

	RuiSetImage( rui, "iconImage", item.icon )
	if ( SURVIVAL_Loot_IsRefValid( item.ref ) )
	{
		LootData data = SURVIVAL_Loot_GetLootDataByRef( item.ref )
		bool isLockedSet = WeaponLootRefIsLockedSet( item.ref )
		int lootTier = isLockedSet ? data.tier : 0
		RuiSetInt( rui, "lootTier", lootTier )
		if ( data.lootType == eLootType.MAINWEAPON )
		{
			LootData baseWeaponData = SURVIVAL_Loot_GetLootDataByRef( data.baseWeapon )

			RuiSetString( rui, "weaponName", data.pickupString )
		}
	}

}
                                                                                                                                                   
void function UICallback_LoadoutSelection_BindOpticSlotButton( var button, int selectedWeapon = -1 )
{
	if ( IsLobby() )
		return

	if ( file.selectedLoadoutForOptic == -1 || selectedWeapon == -1 )
		return

	if ( !file.areLoadoutsPopulated )
		return

	var rui        = Hud_GetRui( button )
	int opticIndex = int( Hud_GetScriptID( button ))

	array<string> optics = LoadoutSelection_GetAvailableOptics( file.selectedLoadoutForOptic, selectedWeapon )

	if ( opticIndex >= optics.len() )
	{
		RuiSetFloat( rui, "baseAlpha", 0.0 )
		return
	}

	array<string> unlockedOptics = LoadoutSelection_GetAvailableOptics( file.selectedLoadoutForOptic, selectedWeapon, true )

	bool hasPreReq = opticIndex < unlockedOptics.len()
	Hud_SetLocked( button, !hasPreReq )


	if( SURVIVAL_Loot_IsRefValid( optics[opticIndex] ) )
	{
		LootData data = SURVIVAL_Loot_GetLootDataByRef( optics[opticIndex] )
		RuiSetImage( rui, "iconImage", data.hudIcon )
		RuiSetInt( rui, "tier", data.tier )
	}
	else
	{
		RuiSetImage( rui, "iconImage", $"rui/pilot_loadout/mods/empty_sight" )
		RuiSetInt( rui, "tier", 0 )
	}



	RuiSetFloat( rui, "baseAlpha", 1.0 )
	RuiSetBool( rui, "hasPreReq", hasPreReq )

	                                                     

	int equippedOptic = -1
	bool isActive = false

	LoadoutSelectionLoadoutContents loadoutContentsData = LoadoutSelection_GetLoadoutContentsByLoadoutSlotIndex( file.selectedLoadoutForOptic )

	if ( selectedWeapon in loadoutContentsData.weaponIndexToScopePreferenceTable  )
		equippedOptic = loadoutContentsData.weaponIndexToScopePreferenceTable[ selectedWeapon ]

	if(equippedOptic > -1)
		isActive = equippedOptic == opticIndex
	else
	{
		string weaponRef = LoadoutSelection_GetWeaponRefByIndex( file.selectedLoadoutForOptic, selectedWeapon )

		foreach ( upgrade in file.weaponUpgrades[ weaponRef ] )
		{
			if ( !SURVIVAL_Loot_IsRefValid( upgrade ) )
				continue

			LootData attachData = SURVIVAL_Loot_GetLootDataByRef( upgrade )
			if ( attachData.attachmentStyle.find( "sight" ) >= 0 )
			{
				equippedOptic = attachData.index
				break
			}
		}
		if ( SURVIVAL_Loot_IsRefValid( optics[opticIndex] ) )
		{
			LootData data = SURVIVAL_Loot_GetLootDataByRef( optics[opticIndex] )
			isActive = equippedOptic == data.index
		}
	}

	RuiSetBool( rui, "isActive", isActive )
}

                                                                                                                        
void function UICallback_LoadoutSelection_OnRequestOpenScopeSelection( var button, int loadoutIndex )
{
	if ( IsLobby() || Hud_IsLocked( button ) || file.isProcessingClickEvent )
		return

	entity player = GetLocalClientPlayer()

	if ( loadoutIndex == -1 )
		return

	string weaponRef0 = LoadoutSelection_GetWeaponRefByIndex( loadoutIndex, 0 )
	string weaponRef1 = LoadoutSelection_GetWeaponRefByIndex( loadoutIndex, 1 )


	if ( !( weaponRef0 in file.weaponUpgrades ) && !( weaponRef1 in file.weaponUpgrades ) )
		return

	array<string> Weapon0Optics = LoadoutSelection_GetAvailableOptics( loadoutIndex, 0, true )
	array<string> Weapon1Optics = LoadoutSelection_GetAvailableOptics( loadoutIndex, 1, true )

	if ( Weapon0Optics.len() <= 1 && Weapon1Optics.len() <= 1)
		return

	int opticLootIndex = -1
	foreach ( upgrade in file.weaponUpgrades[ weaponRef0 ] )
	{
		if ( !SURVIVAL_Loot_IsRefValid( upgrade ) )
			continue

		LootData attachData = SURVIVAL_Loot_GetLootDataByRef( upgrade )
		if ( attachData.attachmentStyle.find( "sight" ) >= 0 )
		{
			opticLootIndex = attachData.index
			break
		}
	}

	file.isProcessingClickEvent = true
	file.selectedLoadoutForOptic = loadoutIndex
	RunUIScript( "ClientToUI_LoadoutSelectionOptics_OpenSelectOpticDialog", loadoutIndex )
}

                                                                                                  
void function ServerCallback_LoadoutSelection_FinishedProcessingClickEvent()
{
	file.isProcessingClickEvent = false
}

                                                                                                                
void function UICallback_LoadoutSelection_OnOpticSlotButtonClick( var opticButton, var loadoutButton, int weaponIndex, var weaponButton )
{
	if ( file.selectedLoadoutForOptic == -1 || Hud_IsLocked( opticButton ) || weaponIndex == -1  )
		return

	                                                                                                    
	int loadoutIndex = file.selectedLoadoutForOptic

	entity player = GetLocalClientPlayer()
	int opticIndex = int( Hud_GetScriptID( opticButton ) )
	array<string> optics = LoadoutSelection_GetAvailableOptics( loadoutIndex, weaponIndex, true )

	                                                       
	if ( opticIndex >= optics.len() || opticIndex < 0 || opticIndex > LOADOUTSELECTION_MAX_SCOPE_INDEX )
		return

	string itemRef = LoadoutSelection_GetWeaponRefByIndex( loadoutIndex, weaponIndex )

	if ( SURVIVAL_Loot_IsRefValid( optics[ opticIndex ] ) || optics[ opticIndex ] == "" )
	{
		EmitSoundOnEntity( GetLocalClientPlayer(), SOUND_SELECT_OPTIC )

		                                                                                                                               
		LoadoutSelectionLoadoutContents	data = LoadoutSelection_GetLoadoutContentsByLoadoutSlotIndex( loadoutIndex )
		data.weaponIndexToScopePreferenceTable[ weaponIndex ] <- opticIndex

		                                                                                          
		Remote_ServerCallFunction( "ClientCallback_LoadoutSelection_SetOpticPreference", loadoutIndex, weaponIndex, opticIndex )

		if ( weaponButton != null )
		{
			var rui = Hud_GetRui( weaponButton )
			string entVar = Hud_GetScriptID( weaponButton )
			thread LoadoutSelection_BindWeaponButton_Thread( GetLocalClientPlayer(), weaponButton, rui, loadoutIndex, weaponIndex, entVar, opticIndex )
		}
	}
}

                                                                                                                        
void function UICallback_LoadoutSelection_OpticSelectDialogueClose()
{
	file.selectedLoadoutForOptic = -1
}
#endif          


#if SERVER
                                                                                                        
                                                                                                                                                               
 
	                         
		      

	                                                                        
	                                                                 
		      

	                                                       
	                                                                              
		      

	                                                 
	                                                                                             
		      

	                               	                                                                                       
	                                   
	 
		                                                                  
	 
	                                        
	 
		                                                                  
	 
 

                                                                                                                                                                                                         
                                                                                                         
 
	                                                                     
	                                               
		      

	                               	                                                                               
	                   

	                          
	 
		                                                         
		 
			                                                             
		 
	 
	                               
	 
		                                                         
		 
			                                                             
		 
	 
	                                                                                  
	                                                     
		      

	                 
	                                
	                          

	                                                                                            
	                      
	 
		                                                                                                   
		                                
		 
			                                                       
			 
				                                                                              
				                        
				                          
			 
			                                      
			 
				          
				                          
			 
		 
	 

	                                                           
	                           
	 
		                                                                  
		 
			                                                                         
				        

			                                                                                             
			                                                      
			 
				                                             
				     
			 
		 
	 

	                                                                                                   
	                                                                                                                                             
	                                          
	 
		                                                
			        

		                                                                     
		                                                      
		 
			                  
			 
				                    
			 
			    
			 
				                     
			 

			                    
			     
		 
	 

	                                   
	 
		                        
	 

	                                                                 
	                                            
	                                                                                                              
	                                         
	                                                                                                        
	                                                                
	                         


	                                                                                        
	                                                             
	                                                                 
	                                                                       
	                                                                            
	                                                                                                           
		                                                                                     

	                                                                                                               
		                                                                                       
 

                                             
                                                                                                                    
 
	                                                                                        
	 
		                                                                         
		                                                 
	 
	    
	 
		                                
		 
			                                                                         
		 
		                                                 

		                                               
		                                                                        
		 
			                                                   
			                                                             
			                                                
			                                       
			                         
			                                                                                                    
			                                                         
			                                                             

			                                      
			                                      
				                              
			                                                     
		 
	 
 
#endif          

#if CLIENT || SERVER
                                          
LoadoutSelectionLoadoutContents function LoadoutSelection_GetLoadoutContentsByLoadoutSlotIndex( int loadoutSlotIndex )
{
	LoadoutSelectionLoadoutContents	data
	if ( loadoutSlotIndex in file.loadoutSlotIndexToCategoryDataTable )
	{
		LoadoutSelectionCategory loadoutCategory = file.loadoutSlotIndexToCategoryDataTable[ loadoutSlotIndex ]
		string loadoutName = loadoutCategory.activeLoadoutName

		if ( loadoutName in loadoutCategory.loadoutContentsByNameTable )
			data = loadoutCategory.loadoutContentsByNameTable[loadoutName]
	}

	return data
}

                                                                                               
                                                                                                                                                                                                                                      
array<string> function LoadoutSelection_GetAvailableOptics( int loadoutIndex, int weaponIndex, bool unlockedOnly = false )
{
	array<string> availableOptics = [ "" ]
	if ( loadoutIndex == -1 || weaponIndex == -1 )
		return availableOptics

	string ref = LoadoutSelection_GetWeaponRefByIndex( loadoutIndex, weaponIndex )
	if ( !SURVIVAL_Loot_IsRefValid( ref ) )
		return availableOptics

	LootData weaponData = SURVIVAL_Loot_GetLootDataByRef( ref )

	array<string> suffixes = [ "", WEAPON_LOCKEDSET_SUFFIX_WHITESET, WEAPON_LOCKEDSET_SUFFIX_BLUESET, WEAPON_LOCKEDSET_SUFFIX_PURPLESET, WEAPON_LOCKEDSET_SUFFIX_GOLD ]
	foreach ( suffix in suffixes )
	{
		string weaponRef = weaponData.baseWeapon + suffix
		if ( weaponRef in file.weaponOptics )
			availableOptics.extend( file.weaponOptics[ weaponRef ] )

		if ( unlockedOnly && ref == weaponRef )
			break
	}

	return availableOptics
}
#endif                    

#if CLIENT || SERVER
int function LoadoutSelection_GetAvailableLoadoutCount()
{
	return file.loadoutCategories.len()
}
#endif                    

                                                                      
bool function LoadoutSelection_IsRefValidWeapon( string weaponRef )
{
	if( !SURVIVAL_Loot_IsRefValid( weaponRef ) )
		return false

	LootData lootData = SURVIVAL_Loot_GetLootDataByRef( weaponRef )
	return lootData.lootType == eLootType.MAINWEAPON
}