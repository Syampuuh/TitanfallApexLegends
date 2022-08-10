global function ShGamemodeArenasBuySystemV2_Init
global function ShArenasBuy_RegisterNetworkingV2

#if SERVER
                                          
                              
                                     
                                        
                                            
                                              
                                              
                                                     
                                                   
                                                    

                                            

       
                                       
      

#endif

#if CLIENT
global function UICallback_Arenas_BindWeaponTab
global function UICallback_Arenas_BindWeaponButton
global function UICallback_Arenas_BindOpticSlotButton
global function UICallback_Arenas_BindBuyButton
global function UICallback_Arenas_BindEquipment
global function UICallback_Arenas_OnWeaponTabClick
global function UICallback_Arenas_OnBuyButtonClick
global function UICallback_Arenas_OnBuyButtonRightClick
global function UICallback_Arenas_OnBuyButtonMiddleClick
global function UICallback_Arenas_OnOpticSlotButtonClick
global function UICallback_Arenas_OpticSelectDialogueClose
global function UICallback_Arenas_BindUtilityTitle
global function UICallback_Arenas_OnShowDeathRecap
global function UICallback_Arenas_PingAirdropPreview
global function ServerCallback_RefreshMenu
global function ServerCallback_FinishedProcessingClickEvent
global function OnCurrentCashChanged
global function Arenas_OpenBuyMenu

const string SOUND_BUY 				= "ui_arenas_ingame_inventory_purchase"
const string SOUND_SELL 			= "ui_arenas_ingame_inventory_sell"
const string SOUND_BUY_UPGRADE_LV1	= "ui_arenas_ingame_inventory_upgrade_lv1"
const string SOUND_BUY_UPGRADE_LV2	= "ui_arenas_ingame_inventory_upgrade_lv2"
const string SOUND_BUY_UPGRADE_LV3	= "ui_arenas_ingame_inventory_upgrade_lv3"
const string SOUND_CHANGE_TAB		= "ui_arenas_ingame_inventory_tab"
const string SOUND_SELECT_OPTIC		= "ui_arenas_ingame_inventory_Select_Optic"
#endif

global function Arenas_GetItemCostByRef

const int ARENAS_WEAPON_UI_COLS = 4
const int ARENAS_WEAPON_UI_ROWS = 4
const int ARENAS_WEAPON_AVAILABLE_COLS = 3
const int ARENAS_WEAPON_AVAILABLE_ROWS = 4
const int ARENAS_MAX_EQUIPMENT = 11
const int ARENAS_STARTING_CASH = 500
const int ARENAS_MAX_WEAPON_TABS = 8

global const int ARENAS_ROUND_PER_LOSE_CASH = 200
global const int ARENAS_KILL_REWARD = 75
global const int ARENAS_CANISTER_REWARD = 200
const int		 ARENAS_MAX_CASH = 3500

const int		 ARENAS_MAX_ORDNANCE = 3
const int		 ARENAS_MAX_SYRINGES = 8
const int		 ARENAS_MAX_MEDKITS = 4
const int		 ARENAS_MAX_SHIELDCELLS = 8
const int		 ARENAS_MAX_SHIELDBATS = 4

struct ArenasStoreItem
{
	int index
	string ref

	string lootOrPerkRef
	int countToGive = 1
	int cost = 1
	asset icon
	string name
	string desc
	int passive = -1
	string mod = ""

	int startingCount = 0
	int maxCount = 0

	int category = -1
}

struct ArenasWeaponTab
{
	string name = ""
	array<string> weaponRefs
}

                                                      
struct ArenasPurchaseData
{
	bool menuOpen = false

	int heals
	int skills
	int upgrades
	int weapons
	int ordnance
}

struct
{
	table<string, ArenasStoreItem> storeData
	array<ArenasStoreItem> storeDataArray

	#if SERVER
		                                                          
		                                                                    
		                                                 
		                                     

		                                      
		                                    

		                                                    
	#endif

	array<string> primaryWeapons
	table<string, array<string> > weaponUpgrades
	table<string, array<string> > weaponOptics
	array<ArenasWeaponTab>	weaponTabs
	table<entity, int>	playerSelectedTabs

	#if CLIENT
		int			selectedTab = 0
		array<int> selectedItems
		int        selectedWeaponForOptic = -1
		bool       autoCloseMenuOnSelect = true
		bool       isProcessingClickEvent = false
		bool	   hasRegisteredToolTipCB = false

		var passiveRui
	#endif

	bool isDataInitialized = false
} file

void function ShGamemodeArenasBuySystemV2_Init()
{
	Arenas_InitData()

	RegisterSignal( "UpdatePassiveRui" )
	RegisterSignal( "BuyMenu_RestoreState" )

	Remote_RegisterServerFunction( "ClientCallback_Arenas_Select", "int", 0, 255 )
	Remote_RegisterServerFunction( "ClientCallback_Arenas_Unselect", "int", 0, 255 )
	Remote_RegisterServerFunction( "ClientCallback_Arenas_SetOptic", "int", 0, 255, "int", -1, 255 )
	Remote_RegisterServerFunction( "ClientCallback_Arenas_ChangeWeaponTab", "int", 0, 255 )
	Remote_RegisterServerFunction( "ClientCallback_Arenas_OnBuyMenuOpen" )
	Remote_RegisterServerFunction( "ClientCallback_Arenas_OnBuyMenuClose" )

	#if SERVER
		                                              
		                                                  
		                                                                    
		                                                             
		                                                               
		                                                                             

		                                    

		                                                                       
		                                                                
		                                                                              
		                                                                    

		                                                  
	#else
		AddCallback_OnClientScriptInit( Arenas_ClientScriptInit )
		AddCallback_PlayerClassChanged( OnPlayerClassChanged_Arenas )

		AddCallback_GameStateEnter( eGameState.Prematch, OnPrematch_Client )
		AddCallback_GameStateEnter( eGameState.Playing, OnGamePlaying_Client )
		AddCallback_GameStateEnter( eGameState.WaitingForPlayers, OnWaitingForPlayers_Client )

		AddCallback_OnWeaponStatusUpdate( Arenas_OnWeaponStatusUpdate )

		SetClearDeathRecapOnClose( false )
		                                                                                                                                       
		RunUIScript( "ClientToUI_Arenas_SetShowDeathRecapFooter", false )
	#endif
}

void function Arenas_InitData()
{
	if( file.isDataInitialized )
		return

	Arenas_InitStoreData()
	Arenas_InitWeaponData()
	Arenas_InitWeaponTabs()

	file.isDataInitialized = true
}

#if SERVER
                                                             
 
	                                                                                        
	                                                                            
	                                    
	                                                                                                     
	                                                       

	                
		      

	                                                                                          

	                                                      
	 
		                         
			                                                            
	 
 

                               
 
	                            
 

                                                
 
	                                      

	                       
	                                         
 

                                                         
 
	                                            
		                                      

	                                             
	 
		                       
		                                         
	 
 

                                                                      
 
	                                                                                        

	                                                                            

	                                    

	                                                                                                     
	                                                       
	                                                              

	                                                  

	                
		                                    

	                                                      

	                     
	 
		                               
		 
			                                                                  
		 
	 
	    
	 
		                               
		 
			                                                                  
		 
	 
 
#endif

int function GetAvailableWeaponColumns( )
{
	return GetCurrentPlaylistVarInt( "arenas_available_weapon_columns", ARENAS_WEAPON_AVAILABLE_COLS )
}

int function GetAvailableWeaponRows( )
{
	return GetCurrentPlaylistVarInt( "arenas_available_weapon_rows", ARENAS_WEAPON_AVAILABLE_ROWS )
}

void function ShArenasBuy_RegisterNetworkingV2()
{
	Remote_RegisterClientFunction( "ServerCallback_RefreshMenu" )
	Remote_RegisterClientFunction( "OnCurrentCashChanged", "entity" )
	Remote_RegisterClientFunction( "ServerCallback_FinishedProcessingClickEvent" )

	RegisterNetworkedVariable( "passiveCharges", SNDC_PLAYER_GLOBAL, SNVT_INT, 1 )
	RegisterNetworkedVariable( "ultimateCooldown", SNDC_PLAYER_EXCLUSIVE, SNVT_INT, 1 )
	#if CLIENT
		RegisterNetworkedVariableChangeCallback_int( "passiveCharges", OnBuyScreenVarUpdate )
		RegisterNetworkedVariableChangeCallback_int( "ultimateCooldown", OnBuyScreenVarUpdate )
	#endif

	int startingCash = GetCurrentPlaylistVarInt( "arenas_round_0_currency", ARENAS_STARTING_CASH )
	RegisterNetworkedVariable( "arenas_current_cash", SNDC_PLAYER_GLOBAL, SNVT_BIG_INT, startingCash )
	#if CLIENT
		RegisterNetworkedVariableChangeCallback_int( "arenas_current_cash",
			void function( entity player, int newVal ) : ()
			{
				OnCurrentCashChanged( player )
			}
		)
	#endif

	for( int i = 0; i < ARENAS_MAX_EQUIPMENT; ++i )
	{
		RegisterNetworkedVariable( "arenas_available_equipment_" + i, SNDC_GLOBAL, SNVT_INT, -1 )
	}
}

const asset ARENAS_ITEMS_DATATABLE = $"datatable/arenas/arenas_items.rpak"

void function Arenas_InitStoreData()
{
	var dataTable = GetDataTable( ARENAS_ITEMS_DATATABLE )
	int numRows = GetDataTableRowCount( dataTable )

	array<string> disabledWeapons = split( GetCurrentPlaylistVarString( "global_disabled_loot", "" ).tolower(), WHITESPACE_CHARACTERS )

	table<string, LootData> allLootData = SURVIVAL_Loot_GetLootDataTable()

	int index = 0

	foreach( ref, data in allLootData )
	{
		if( data.lootType != eLootType.MAINWEAPON || ref.find( WEAPON_LOCKEDSET_SUFFIX_GOLD ) >= 0 )
			continue

		if ( data.baseMods.contains( WEAPON_LOCKEDSET_MOD_CRATE ) )
			continue

		if( disabledWeapons.contains( data.baseWeapon ) )
			continue

		ArenasStoreItem item
		item.index = index++
		item.ref = ref
		item.lootOrPerkRef = ref
		item.name = GetWeaponInfoFileKeyField_GlobalString( data.baseWeapon, "shortprintname" )
		item.desc = data.desc
		item.icon = data.hudIcon

		if ( WeaponLootRefIsLockedSet( ref ) )
			item.category = eArenasPurchaseData.UPGRADE
		else
			item.category = eArenasPurchaseData.WEAPON

		file.storeData[ item.ref ] <- item
		file.storeDataArray.append( item )
	}

	for( int i = 0; i < numRows; ++i )
	{
		ArenasStoreItem item
		item.index = index++

		item.ref = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "ref" ) )
		item.lootOrPerkRef = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "lootOrPerkRef" ) )

		item.countToGive = GetDataTableInt( dataTable, i, GetDataTableColumnByName( dataTable, "numToGive" ) )
		item.cost = GetDataTableInt( dataTable, i, GetDataTableColumnByName( dataTable, "cost" ) )
		item.cost = GetCurrentPlaylistVarInt( "arenas_" + item.ref + "_cost_override", item.cost )

		if ( SURVIVAL_Loot_IsRefValid( item.lootOrPerkRef ) )
		{
			LootData data = SURVIVAL_Loot_GetLootDataByRef( item.lootOrPerkRef )
			item.name = data.pickupString
			item.desc = data.desc
			item.icon = data.hudIcon
		}

		string name = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "name" ) )
		item.name = name == "" ? item.name : name
		string desc = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "desc" ) )
		item.desc = desc == "" ? item.desc : desc
		asset icon = GetDataTableAsset( dataTable, i, GetDataTableColumnByName( dataTable, "icon" ) )
		item.icon = icon == $"" ? item.icon : icon

		string passiveString = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "passive" ) )
		if ( passiveString in ePassives )
		{
			item.passive = ePassives[ passiveString ]
		}

		string mod = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "mod" ) )
		item.mod = mod

		item.startingCount = GetDataTableInt( dataTable, i, GetDataTableColumnByName( dataTable, "startingCount" ) )
		item.maxCount = GetDataTableInt( dataTable, i, GetDataTableColumnByName( dataTable, "maxCount" ) )
		item.maxCount = GetCurrentPlaylistVarInt( "arenas_" + item.ref + "_cooldown", item.maxCount )

		string categoryName = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "category" ) )
		item.category       = GetCategoryEnumFromString( categoryName )

		file.storeData[ item.ref ] <- item
		file.storeDataArray.append( item )
	}
}

int function GetCategoryEnumFromString( string categoryName )
{
	switch ( categoryName )
	{
		case "upgrade":
			return eArenasPurchaseData.UPGRADE
			break
		case "skills":
			return eArenasPurchaseData.SKILL
			break
		case "ordnance":
			return eArenasPurchaseData.ORDNANCE
			break
		case "heals":
			return eArenasPurchaseData.HEAL
			break
		case "weapon":
			return eArenasPurchaseData.WEAPON
			break
	}

	return -1
}

string function GetNextUpgradedWeaponRef( string weaponRef )
{
	if ( weaponRef.find( WEAPON_LOCKEDSET_SUFFIX_GOLD ) != -1 )
		return GetBaseWeaponRef( weaponRef ) + WEAPON_LOCKEDSET_SUFFIX_PURPLESET
	else if( weaponRef.find( WEAPON_LOCKEDSET_SUFFIX_PURPLESET ) != -1 )
		return weaponRef
	else if( weaponRef.find( WEAPON_LOCKEDSET_SUFFIX_BLUESET ) != -1 )
		return GetBaseWeaponRef( weaponRef ) + WEAPON_LOCKEDSET_SUFFIX_PURPLESET
	else if( weaponRef.find( WEAPON_LOCKEDSET_SUFFIX_WHITESET ) != -1 )
		return GetBaseWeaponRef( weaponRef ) + WEAPON_LOCKEDSET_SUFFIX_BLUESET

	return weaponRef + WEAPON_LOCKEDSET_SUFFIX_WHITESET
}

string function GetPrevUpgradedWeaponRef( string weaponRef )
{
	if ( weaponRef.find( WEAPON_LOCKEDSET_SUFFIX_GOLD ) != -1 )
		return GetBaseWeaponRef( weaponRef ) + WEAPON_LOCKEDSET_SUFFIX_PURPLESET
	else if( weaponRef.find( WEAPON_LOCKEDSET_SUFFIX_PURPLESET ) != -1 )
		return GetBaseWeaponRef( weaponRef ) + WEAPON_LOCKEDSET_SUFFIX_BLUESET
	else if( weaponRef.find( WEAPON_LOCKEDSET_SUFFIX_BLUESET ) != -1 )
		return GetBaseWeaponRef( weaponRef ) + WEAPON_LOCKEDSET_SUFFIX_WHITESET

	return GetBaseWeaponRef( weaponRef )
}

const asset ARENAS_WEAPON_DATA_DATATABLE = $"datatable/arenas/arenas_weapon_data.rpak"

void function Arenas_InitWeaponData()
{
	var dataTable    	= GetDataTable( ARENAS_WEAPON_DATA_DATATABLE )
	int numRows      	= GetDataTableRowCount( dataTable )

	int col_weaponRef   = GetDataTableColumnByName( dataTable, "weaponRef" )
	int col_startAmmo   = GetDataTableColumnByName( dataTable, "startingAmmo" )
	int col_cost        = GetDataTableColumnByName( dataTable, "cost" )
	int col_attachments = GetDataTableColumnByName( dataTable, "attachmentOverride" )
	int col_optics      = GetDataTableColumnByName( dataTable, "availableOptics" )
	int col_defaultOptic= GetDataTableColumnByName( dataTable, "defaultOptic" )

	for( int i = 0; i < numRows; ++i )
	{
		string weaponRef = strip( GetDataTableString( dataTable, i, col_weaponRef ) ).tolower()

		if( weaponRef != "" )
		{
			#if SERVER
				                                              
				 
					                                                                                      
					                                                                                                                                                 
				 
				    
					                                                                                           
			#endif

			if ( !(weaponRef in file.weaponUpgrades) )
			{
				string upgrades = GetDataTableString( dataTable, i, col_attachments )
				upgrades = GetCurrentPlaylistVarString( "arenas_" + weaponRef + "_attachment_override", upgrades )
				file.weaponUpgrades[ weaponRef ] <- split( upgrades, WHITESPACE_CHARACTERS )
				if( file.weaponUpgrades[ weaponRef ].len() == 0 )
					file.weaponUpgrades[ weaponRef ] = SURVIVAL_Weapon_GetBaseMods( weaponRef )

				string defaultOptic = GetDataTableString( dataTable, i, col_defaultOptic )
				if( defaultOptic != "" )
					ReplaceOpticInMods( file.weaponUpgrades[ weaponRef ], defaultOptic )
			}
			else
				Warning( "Arenas_InitWeaponUpgradeData - weapon upgrades for %s already exists!", weaponRef )

			if ( !(weaponRef in file.weaponOptics) )
			{
				string optics = GetDataTableString( dataTable, i, col_optics )
				optics = GetCurrentPlaylistVarString( "arenas_" + weaponRef + "_optic_override", optics )
				file.weaponOptics[ weaponRef ] <- split( optics, WHITESPACE_CHARACTERS )
			}
			else
				Warning( "Arenas_InitWeaponUpgradeData - available optics for %s already exists!", weaponRef )

			int cost = GetDataTableInt( dataTable, i, col_cost )
			if( weaponRef in file.storeData )
			{
				file.storeData[ weaponRef ].cost = GetCurrentPlaylistVarInt( "arenas_" + weaponRef + "_cost_override", GetDataTableInt( dataTable, i, col_cost ) )
			}
			else if( WeaponLootRefIsLockedSet( weaponRef ) )
			{
				string baseWeaponRef = GetBaseWeaponRef( weaponRef )
				if( baseWeaponRef in file.storeData )
				{
					ArenasStoreItem weaponUpgrade = clone file.storeData[ baseWeaponRef ]
					weaponUpgrade.ref = weaponRef
					weaponUpgrade.cost = GetDataTableInt( dataTable, i, col_cost )
					weaponUpgrade.cost = GetCurrentPlaylistVarInt( "arenas_" + weaponRef + "_cost_override", weaponUpgrade.cost )
					weaponUpgrade.index = file.storeDataArray.len()
					file.storeData[ weaponUpgrade.ref ] <- weaponUpgrade
					file.storeDataArray.append( weaponUpgrade )
				}
			}
		}
		else
		{
			Warning( "Arenas_InitWeaponUpgradeData - Error reading arenas_weapon_upgrades datatable. Expected weaponRef!" )
		}
	}
}

int function CompareWeaponCost( string a, string b )
{
	if( !(a in file.storeData) || !(b in file.storeData) )
		return 0

	if( file.storeData[ a ].cost > file.storeData[ b ].cost )
		return 1
	else if( file.storeData[ a ].cost < file.storeData[ b ].cost )
		return -1

	return 0
}

const asset ARENAS_WEAPON_TAB_DATATABLE = $"datatable/arenas/arenas_weapon_tabs.rpak"

void function Arenas_InitWeaponTabs()
{
	var dataTable    	= GetDataTable( ARENAS_WEAPON_TAB_DATATABLE )
	int numRows      	= GetDataTableRowCount( dataTable )

	int col_tab         = GetDataTableColumnByName( dataTable, "weaponTab" )
	int col_weapon      = GetDataTableColumnByName( dataTable, "weaponRef" )

	ArenasWeaponTab currentTab
	array<string> weapons
	for( int i = 0; i < numRows; ++i )
	{
		string tabRef = strip( GetDataTableString( dataTable, i, col_tab ) )
		if( tabRef != "" )
		{
			if( currentTab.name != "" && weapons.len() > 0 )
			{
				currentTab.weaponRefs = clone weapons
				currentTab.weaponRefs.sort( CompareWeaponCost )
				file.weaponTabs.append( clone currentTab )
			}

			weapons.clear()
			currentTab.name = tabRef
		}
		else if( currentTab.name != "" )
		{
			string weaponRef = strip( GetDataTableString( dataTable, i, col_weapon ) ).tolower()
			if( !weapons.contains( weaponRef ) )
			{
				weapons.append( weaponRef )
			}
			else
				Warning( "Arenas_InitWeaponTabs - Error reading arenas_weapon_tabs datatable. Weapon tab already contains ref: %s", weaponRef )
		}
		else
		{
			Warning( "Arenas_InitWeaponTabs - Error reading arenas_weapon_tabs datatable. Expected new tab!" )
		}
	}

	if( currentTab.name != "" && weapons.len() > 0 )
	{
		currentTab.weaponRefs = clone weapons
		currentTab.weaponRefs.sort( CompareWeaponCost )
		file.weaponTabs.append( clone currentTab )
	}

	                                          
	const string ARENAS_NO_TAB_OVERRIDE = "no_override"

	                           
	for( int i = 0; i < ARENAS_MAX_WEAPON_TABS; ++i )
	{
		string tabOverride = GetCurrentPlaylistVarString( "arenas_weapon_tab_" + i + "_override", ARENAS_NO_TAB_OVERRIDE )
		if( tabOverride == ARENAS_NO_TAB_OVERRIDE )
			continue

		array<string> weaponRefs = split( tabOverride, WHITESPACE_CHARACTERS )
		if( weaponRefs.len() == 0 )
		{
			currentTab.name = ""
		}
		else
		{
			currentTab.name = weaponRefs[ 0 ]
			weaponRefs.fastremove( 0 )
		}

		currentTab.weaponRefs = clone weaponRefs

		if( file.weaponTabs.len() > i )
			file.weaponTabs[ i ] = clone currentTab
		else
			file.weaponTabs.append( clone currentTab )
	}

	                   
	for( int i = file.weaponTabs.len() - 1; i >= 0; --i )
	{
		if( file.weaponTabs[ i ].name == "" || file.weaponTabs[ i ].weaponRefs.len() == 0 )
			file.weaponTabs.fastremove( i )
	}

}

bool function IsAvailableWeapon( entity player, string weaponRef )
{
	if( !SURVIVAL_Loot_IsRefValid( weaponRef ) )
		return false

	LootData lootData = SURVIVAL_Loot_GetLootDataByRef( weaponRef )
	return lootData.lootType == eLootType.MAINWEAPON
}

#if SERVER
                                                                      
 
	                                                                                      

	                                                
		      

	                                           
		      

	                                                   

	                                        
		      

	                                                     
	                               

	                                         
	 
		                                                        
		 
			                                                                                                               
		 
	 

	               
	 
		                                                                   
		                        
		 
			                                 
				                       
				     
			                               
				                     
				     
			                                  
				                       
				     
			                              
				                    
				     
			                                
				                      
				     
		 
	 

	                                                
	                              

	                                                                                      
	               
		                                                                       

	                                                                                           
 

                                                                        
 
	                                                                                      

	                                                
		      

	                                           
		      

	                                                   

	            

	                                           
	 
		                       

		                            
		 
			                                                                             
			                                                                                      
			 
				                                                           
					                      
				    
					                                                  

				     
			 
		 

		                       
			      

		                                                    
		                              

		                                   

		                                                        
		                                                         
			                                                                     

		                              
	 
	    
	 
		                                     
		 
			                                                              
			                          
			 
				                                                 
				                                                                           
				                                                                                           
				                                                                                                                                                                                     
				                                                                                                                                                                                                                               
			 
		 
		                                     
		 
			                                                                                        

			                                                                            

			                                                                                                        

			                                                      

			               
			 
				                                                                                                 
				 
					                                                                                          
				 
				    
				 
					        
				 

				                                                      
				 
					                               
					 
						                                                                  
					 
				 
			 
		 
		                                             
		 
			                                                           
			                        
			 
				                                                 
				                                     
			 

			                                                        
			 
				                                               
			 
		 
		                             
		 
			                                              
			 
				                                                 
				                                   
			 
		 
		                          
		 
			                                           
			 
				                                                 
				                                      
			 
		 
		                                                                                                                                           
		 
			                                                 
			                                                                                              

			                                            
			                                                                          
			                                                                            
			 
				                                                                     
					                                                                     
			 
		 

		                              
		                                                                     
	 

	               
	 
		                                                                   
		                        
		 
			                                 
				                       
				     
			                               
				                     
				     
			                                  
				                       
				     
			                              
				                    
				     
			                                
				                      
				     
		 
	 

	                                                                                             
 

                                                                                              
 
	                     
		      

	                                                                        

	                    

	                                                  
	 
		                                                                       
		                        
	 

	                            
	 
		                                                                             
		                       
		 
			                                                              

			                                                       
			 
				                                                                     
				                                        

				                                                                                               
				                                                           

				                                             
				                                                                                              

				                              

				                                                                             
				                                            

				                                                                                                     
				              

				     
			 
		 
	 
 

                                                                                          
 
	                                                    
	                              
 

                                    
 
	                                     
	 
		                                     
		                                                           
	 
	    
		                                                                       
 

                                       
 
	                                    
	 
		                                      
		                                                              
	 
	    
		                                                                     
 

                                                                  
 
	                                                 
		      

	                                                 

	                                  
	                      
	                              

	                                     
 

                                                   
 
	                                       
	                                          
	                             

	             
		                       
		 
			                                                  

			                        
			 
				                                                                                              
				                                
				                        

				                                         
					                                                       
			 
		 
	 

	             
 

                                                                   
 
	                                                  
		      

	                                       
 

                                                                            
 
	                              
	                                                                              
	 
		                                                      
			                                    
	 

	                                  
	 
		                                                
			                                                                        
	 
 

                                                              
 
	                                       
		                                   

	                                               
	 
		                                                        

		                     
		 
			                                         

			                                               
			 
				                                       
				                                                                                     
				                                                                                     
			 
		 

	 
 

                          
 
	                                     
	 
		                                                           
		              
		                 
		                
		                 
		               
	 
 

                             
 
	                                     
	 
		                                       

		                                  
	 
 

                                                       
 
	                                                                   
	                                   

	                                                                             
	                                                                                                                                                    
	 
		                                                                  
		                                                                                  
		                       

		                                    
		 
			                                       
				        

			                                                                        

			                                                                                                                                                  
				     
		 

		                             
		 
			                                                   
			 
				                                                                          
				 
					                                                                                                                                             
					                                                                                                
				 
			 
			    
			 
				                                                                                                
			 
		 
	 

	                    
	 
		                                                     

		                               
		 
			                                                                                                     
			                             
				                                                                                                
		 
	 

	                                                       
	 
		                                                         

		                      
		 
			                                                                             
			 
				                                                                                              
			 
		 
	 

	                                                                                           
	                                                                                           

	                                                           
	                                                                         
	                                                                                
	                                                                           
	                                                                               

 

                                                                    
 
	                                                    
		      

	                                                            
	                                            
		      

	                                                           
	                                           
		      

	                                                     

	                                          
	 
		                                                            
		                                         
		                                           
			                                                   

		                                                                                               
		                                   
	 
 

                                                                                                                                                  
 
	                                                                     
 

                                          
 
	                                                                                                                                                                                                                             
	                                          
	 
		                                                     
		                                                                
	 
 

                                                   
 
	                                                               
		                                                                       
 

                                                                                            
 
	                           
	                     
	                                                       
	                             
	 
		                         
		                           
	 
	                    
 

                                                                           
 
	                                                        
 

                                                                                                                                     
 
	                                   
	                          

	                                          
	 
		                                                         

		                                            
		 
			                                                                                     
			                                                           

			                                                  
			 
				                            
				 
					                                                                             
					                       
					 
						                                                              
						                                              
						 
							                                             
							                                                                                              
							     
						 
					 
				 
			 

			                                                                                                                                                  
			 
				                                                                  
			 
			    
			 
				                                                                             

				                                      
					                                                     

				                                          
				                                      

				                                                                                                            
			 

			              
		 
		    
		 
			                                                                                      
			                                                           

			                                   
		 
	 
	                              
	 
		                                   
		                                                                                    
	 
	                          
	 
		                                      
		                                                  
	 
	                                             
	 
		                                                         
	 
 

                                                            
 
	                                                                                                                                                         
	                                                     
 
#endif

bool function IsGoldUtilityItem( ArenasStoreItem item )
{
	return item.mod != "" || item.passive != -1
}

ArenasStoreItem function GetStoreDataByIndex( int index )
{
	return file.storeDataArray[ index ]
}

#if CLIENT
void function OnUnlockedItemChanged( entity player )
{

}

void function OnCurrentCashChanged( entity player )
{
	if( !IsValid( player ) )
		return

	if( player != GetLocalClientPlayer() )
		return

	                               
	if( player.GetPlayerNetInt( "arenas_current_cash" ) <= 0 && SURVIVAL_GetPrimaryWeapons( player ).len() >= 2 )
		RunUIScript( "ClientToUI_Arenas_CloseBuyMenu" )
	else
		RunUIScript( "ClientToUI_Arenas_RefreshBuyMenu" )
}

bool function IsStoreIndexSelected( entity player, int index )
{
	foreach( selectedIndex in file.selectedItems )
	{
		if( selectedIndex == index )
			return true
	}

	return false
}

int function Arenas_GetShopButtonIndex( entity player, string entVar )
{
	if( player == null )
		return -1

	if( entVar.find( "arenas_player_weapon" ) != -1 )
		return GetPlayerWeapon( player, entVar )
	else if( entVar.find( "arenas_player_tactical" ) != -1 )
		return GetGlobalNetInt( "arenas_available_equipment_1" )
	else if( entVar.find( "arenas_player_ultimate" ) != -1 )
		return GetGlobalNetInt( "arenas_available_equipment_2" )
	else if ( entVar.find( "arenas_available_weapon_" ) != -1 )
		return GetWeaponButtonIdx( player, entVar )
	else
		return GetGlobalNetInt( entVar )

	return -1
}

int function GetPlayerWeapon( entity player, string entVar )
{
	if( player == null )
		return -1

	int weaponIndex = -1
	if( entVar.find( "weapon_0" ) != -1 )
		weaponIndex = 0
	else if( entVar.find( "weapon_1" ) != -1 )
		weaponIndex = 1

	if( weaponIndex == -1 )
		return -1

	entity weapon = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 + weaponIndex )
	if( IsValid( weapon ) )
	{
		string weaponRef = GetNextUpgradedWeaponRef( GetWeaponClassNameWithLockedSet( weapon ) )
		if( weaponRef in file.storeData )
			return file.storeData[ weaponRef ].index
	}

	return -1
}

void function UICallback_Arenas_BindWeaponTab( var button )
{
	if ( IsLobby() )
		return

	entity player = GetLocalClientPlayer()

	Hud_ClearToolTipData( button )
	Hud_SetVisible( button, false )

	var rui = Hud_GetRui( button )

	string entVar = Hud_GetScriptID( button )
	string weaponTab = "arenas_weapon_tab_"

	int tabIndex = int( entVar.slice( weaponTab.len() ) )
	Hud_SetSelected( button, tabIndex == file.selectedTab )

	if( tabIndex < file.weaponTabs.len() )
	{
		Hud_SetVisible( button, true )
		RuiSetString( rui, "tabName", Localize( file.weaponTabs[ tabIndex ].name ) )
	}
}

ArenasStoreItem ornull function GetWeaponDataForButtonIndex( entity player, int searchIdx )
{
	array<string> weaponsInTab = file.weaponTabs[ file.selectedTab ].weaponRefs

	if ( weaponsInTab.len() <= searchIdx )
		return null

	array<entity> weapons
	array<string> baseWeaponRefs = [ "", "" ]
	weapons.append( player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 ) )
	weapons.append( player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 ) )

	for( int i = 0; i < weapons.len(); ++i )
	{
		if( IsValid( weapons[ i ] ) )
			baseWeaponRefs[i] = weapons[ i ].GetWeaponClassName()
	}

	array<ArenasStoreItem> items
	foreach ( ref in weaponsInTab )
	{
		                          
		if( !(ref in file.storeData) )
			continue

		ArenasStoreItem item = file.storeData[ ref ]

		for ( int i=0; i<baseWeaponRefs.len(); i++ )
		{
			if ( baseWeaponRefs[i] == ref )
			{
				string newRef = GetNextUpgradedWeaponRef( GetWeaponClassNameWithLockedSet( weapons[ i ] ) )
				item = file.storeData[ newRef ]
				break
			}
		}

		items.append( item )
	}

	if( items.len() <= searchIdx )
		return null

	return items[ searchIdx ]
}

int function GetWeaponButtonIdx( entity player, string entVar )
{
	int idx = -1

	if ( entVar.find( "arenas_available_weapon_" ) != -1 )
	{
		string subStr = entVar.slice( ( "arenas_available_weapon_" ).len(), entVar.len() )

		array<string> tokens = split( subStr, "_" )
		int row = int( tokens[0] )
		int col = int( tokens[1] )
		int searchIdx = (row * GetAvailableWeaponColumns()) + col

		ArenasStoreItem ornull item = GetWeaponDataForButtonIndex( player, searchIdx )
		if ( item != null )
		{
			expect ArenasStoreItem( item )
			idx = item.index
		}
	}

	return idx
}

void function UICallback_Arenas_BindWeaponButton( var button )
{
	if ( IsLobby() )
		return

	entity player = GetLocalClientPlayer()

	Hud_ClearToolTipData( button )
	Hud_SetSelected( button, false )

	var rui = Hud_GetRui( button )

	string entVar = Hud_GetScriptID( button )

	int idx = Arenas_GetShopButtonIndex( player, entVar )

	_Arenas_BindWeaponButton( player, button, rui, idx, entVar )
}

void function _Arenas_BindWeaponButton( entity player, var button, var rui, int idx, string entVar )
{
	RuiSetString( rui, "weaponName", "" )
	RuiSetBool( rui, "wasOwned", false )
	RuiSetImage( rui, "iconImage", $"" )
	RuiSetImage( rui, "ammoTypeImage", $"" )
	RuiSetInt( rui, "lootTier", 0 )
	RuiSetInt( rui, "startLootTier", 0 )
	RuiSetInt( rui, "cost", -1 )
	RuiSetInt( rui, "sellPrice", -1 )
	RuiSetBool( rui, "hasPreReq", true )
	RuiSetBool( rui, "isLockedSet", false )
	RuiSetBool( rui, "isPlayerLoadoutButton", entVar.find( "player" ) != -1 )
	RuiSetBool( rui, "barrelAllowed", false )
	RuiSetBool( rui, "magAllowed", false )
	RuiSetBool( rui, "sightAllowed", false )
	RuiSetBool( rui, "gripAllowed", false )
	RuiSetBool( rui, "hopupAllowed", false )
	RuiSetBool( rui, "hopupMultiAAllowed", false )
	RuiSetBool( rui, "hopupMultiBAllowed", false )

	if ( button != null )
	{
		Hud_SetWidth( button, Hud_GetBaseWidth( button ) )
		Hud_SetVisible( button, true )
		Hud_SetLocked( button, true )
	}

	if ( idx == -1 )
		return

	ArenasStoreItem item = GetStoreDataByIndex( idx )

	bool owned = false
	bool selected = false
	bool hasPreReq = true
	bool canAfford = true
	bool wasOwned = false

	string prevRef = GetPrevUpgradedWeaponRef( item.lootOrPerkRef )

	if ( player != null )
	{
		if( entVar.find( "weapon" ) != -1 )
		{
			for( int i = 0; i < 2; ++i )
			{
				entity weapon = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 + i )
				if( IsValid( weapon ) )
				{
					string weaponRef = GetWeaponClassNameWithLockedSet( weapon )
					if( weapon.w.isGoldset )
						weaponRef = GetBaseWeaponRef( weaponRef ) + WEAPON_LOCKEDSET_SUFFIX_PURPLESET

					if( item.ref == weaponRef )
					{
						owned = true
						break
					}
				}
			}

			if( owned && GetNextUpgradedWeaponRef( item.lootOrPerkRef ) == item.lootOrPerkRef )
				prevRef = item.lootOrPerkRef

			if( prevRef in file.storeData && IsStoreIndexSelected( player, file.storeData[ prevRef ].index ) )
				selected = true
		}

		hasPreReq = DoesPlayerHavePreReq( player, item.ref, entVar )
		canAfford = CanPlayerAfford( player, item.ref )
		wasOwned = owned
	}

	RuiSetBool( rui, "hasPreReq", hasPreReq )
	RuiSetBool( rui, "canAfford", canAfford )
	RuiSetBool( rui, "wasOwned", wasOwned )
	RuiSetInt( rui, "cost", GetArenasStoreItemCost( player, item.ref ) )

	if( selected )
		RuiSetInt( rui, "sellPrice", GetArenasStoreItemCost( player, prevRef ) )

	RuiSetImage( rui, "iconImage", item.icon )

	if ( SURVIVAL_Loot_IsRefValid( item.lootOrPerkRef ) )
	{
		LootData data = SURVIVAL_Loot_GetLootDataByRef( item.lootOrPerkRef )
		LootData prevData = SURVIVAL_Loot_GetLootDataByRef( prevRef )
		RuiSetInt( rui, "lootTier", WeaponLootRefIsLockedSet( item.lootOrPerkRef ) ? data.tier : 0 )
		RuiSetBool( rui, "isLockedSet", WeaponLootRefIsLockedSet( item.lootOrPerkRef ) )

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

			RuiSetBool( rui, "barrelAllowed", false )
			RuiSetBool( rui, "magAllowed", false )
			RuiSetBool( rui, "sightAllowed", false )
			RuiSetBool( rui, "gripAllowed", false )
			RuiSetBool( rui, "hopupAllowed", false )
			RuiSetBool( rui, "hopupMultiAAllowed", false )
			RuiSetBool( rui, "hopupMultiBAllowed", false )

			for( int i = 0; i < baseWeaponData.supportedAttachments.len(); ++i )
			{
				string attachment = baseWeaponData.supportedAttachments[i]
				if( attachment == "hopupMulti_a" )
					attachment = "hopupMultiA"
				else if( attachment == "hopupMulti_b" )
					attachment = "hopupMultiB"

				RuiSetBool( rui, attachment + "Allowed", true )
				RuiSetBool( rui, attachment + "Empty", true )
				RuiSetBool( rui, attachment + "UpgradeEmpty", true )
				RuiSetInt( rui, attachment + "Slot", i )

				string attachmentStyle = GetAttachmentPointStyle( baseWeaponData.supportedAttachments[i], baseWeaponData.ref )

				                                                                    
				                                                                                            
				if( attachmentStyle == "grip" && ( baseWeaponData.lootTags.contains( "sniper" ) || baseWeaponData.lootTags.contains( "marksman" ) ) )
					attachmentStyle = "stock_sniper"

				RuiSetImage( rui, attachment + "Icon", emptyAttachmentSlotImages[attachmentStyle] )
				RuiSetImage( rui, attachment + "UpgradeIcon", emptyAttachmentSlotImages[attachmentStyle] )
			}

			if( prevRef in file.weaponUpgrades )
			{
				array<string> upgrades = file.weaponUpgrades[ prevRef ]
				int attachIndex = 0
				for( int i = 0; i < upgrades.len(); ++i )
				{
					if( !SURVIVAL_Loot_IsRefValid( upgrades[i] ) )
						continue

					LootData lootData  = SURVIVAL_Loot_GetLootDataByRef( upgrades[i] )
					string attachStyle = GetAttachPointForAttachmentOnWeapon( prevRef, upgrades[i] )

					if( attachStyle == "hopupMulti_a" )
						attachStyle = "hopupMultiA"
					else if( attachStyle == "hopupMulti_b" )
						attachStyle = "hopupMultiB"

					if( attachStyle == "" )
						continue

					RuiSetBool( rui, attachStyle + "Empty", false )
					RuiSetImage( rui, attachStyle + "Icon", lootData.hudIcon )

					attachIndex++
				}
			}

			if( item.lootOrPerkRef in file.weaponUpgrades )
			{
				array<string> upgrades = file.weaponUpgrades[ item.lootOrPerkRef ]
				int attachIndex = 0
				for( int i = 0; i < upgrades.len(); ++i )
				{
					if( !SURVIVAL_Loot_IsRefValid( upgrades[i] ) )
						continue

					LootData lootData  = SURVIVAL_Loot_GetLootDataByRef( upgrades[i] )
					string attachStyle = GetAttachPointForAttachmentOnWeapon( item.lootOrPerkRef, upgrades[i] )

					if( attachStyle == "hopupMulti_a" )
						attachStyle = "hopupMultiA"
					else if( attachStyle == "hopupMulti_b" )
						attachStyle = "hopupMultiB"

					if( attachStyle == "" )
						continue

					RuiSetImage( rui, attachStyle + "UpgradeIcon", lootData.hudIcon )
					RuiSetBool( rui, attachStyle + "UpgradeEmpty", false )

					attachIndex++
				}
			}
		}
	}

	if ( button != null )
	{
		bool locked = false
		if( player != null )
		{
			if( IsStoreIndexSelected( player, item.index ) )
				selected = true

			if( IsAvailableWeapon( player, item.ref ) )
			{
				if( IsValid( player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 ) ) && IsValid( player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 ) ) )
					locked = !selected

				if( !hasPreReq || (wasOwned && !selected ) )
					locked = true
			}
		}

		Hud_SetSelected( button, selected )
		Hud_SetLocked( button, locked )
	}
}

array<string> function GetAvailableOptics( int index, bool unlockedOnly = false )
{
	array<string> availableOptics = [ "" ]
	if ( index == -1 )
		return availableOptics

	ArenasStoreItem weaponItem = GetStoreDataByIndex( index )
	if ( !SURVIVAL_Loot_IsRefValid( weaponItem.lootOrPerkRef ) )
		return availableOptics

	LootData weaponData = SURVIVAL_Loot_GetLootDataByRef( weaponItem.lootOrPerkRef )

	array<string> suffixes = [ "", WEAPON_LOCKEDSET_SUFFIX_WHITESET, WEAPON_LOCKEDSET_SUFFIX_BLUESET, WEAPON_LOCKEDSET_SUFFIX_PURPLESET ]
	foreach ( suffix in suffixes )
	{
		string weaponRef = weaponData.baseWeapon + suffix
		if ( weaponRef in file.weaponOptics )
			availableOptics.extend( file.weaponOptics[ weaponRef ] )

		if ( unlockedOnly && weaponItem.lootOrPerkRef == weaponRef )
			break
	}

	return availableOptics
}

                                                                                       
void function SetPreferredOptic( string itemRef )
{
	if( !IsAvailableWeapon( GetLocalClientPlayer(), itemRef ) )
		return

	string optic = ""
	for ( int i = 0; i < file.weaponUpgrades[ itemRef ].len(); ++i )
	{
		if ( !SURVIVAL_Loot_IsRefValid( file.weaponUpgrades[ itemRef ][i] ) )
			continue

		LootData attachData = SURVIVAL_Loot_GetLootDataByRef( file.weaponUpgrades[ itemRef ][i] )
		if ( attachData.attachmentStyle.find( "sight" ) >= 0 )
		{
			optic = file.weaponUpgrades[ itemRef ][i]
			break
		}
	}

	int opticIndex = -1
	if( optic != "" && SURVIVAL_Loot_IsRefValid( optic ) )
	{
		LootData newOpticData = SURVIVAL_Loot_GetLootDataByRef( optic )
		opticIndex = newOpticData.index
	}

	LootData weaponData = SURVIVAL_Loot_GetLootDataByRef( itemRef )
	Remote_ServerCallFunction( "ClientCallback_Arenas_SetOptic", weaponData.index, opticIndex )
}

void function UICallback_Arenas_BindOpticSlotButton( var button )
{
	if ( IsLobby() )
		return

	if ( file.selectedWeaponForOptic == -1 )
		return

	var rui        = Hud_GetRui( button )
	int opticIndex = int(Hud_GetScriptID( button ))

	array<string> optics = GetAvailableOptics( file.selectedWeaponForOptic )

	if ( opticIndex >= optics.len() )
	{
		RuiSetFloat( rui, "baseAlpha", 0.0 )
		return
	}

	array<string> unlockedOptics = GetAvailableOptics( file.selectedWeaponForOptic, true )

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
}

void function UICallback_Arenas_BindBuyButton( var button )
{
	if ( IsLobby() )
		return

	entity player = GetLocalClientPlayer()

	Hud_ClearToolTipData( button )
	Hud_SetSelected( button, false )
	Hud_SetVisible( button, false )

	var rui = Hud_GetRui( button )

	string entVar = Hud_GetScriptID( button )

	int idx = Arenas_GetShopButtonIndex( player, entVar )
	_Arenas_BindBuyButtonV2( player, button, rui, idx, entVar )
}

void function _Arenas_BindBuyButtonV2( entity player, var button, var rui, int idx, string entVar )
{
	RuiSetString( rui, "weaponName", "" )
	RuiSetBool( rui, "wasOwned", false )
	RuiSetImage( rui, "iconImage", $"" )
	RuiSetImage( rui, "ammoTypeImage", $"" )
	RuiSetInt( rui, "lootTier", 0 )
	RuiSetInt( rui, "count", 0 )
	RuiSetInt( rui, "cost", -1 )
	RuiSetBool( rui, "hasPreReq", true )
	RuiSetBool( rui, "isLockedSet", false )
	RuiSetBool( rui, "isPlayerLoadoutButton", entVar.find( "player" ) != -1 )

	#if NX_PROG
		{
			RuiSetFloat( rui, "isNX", 1.0 )
		}
	#endif

	if ( idx == -1 )
		return

	if ( button != null )
	{
		Hud_SetWidth( button, Hud_GetBaseWidth( button ) )
		Hud_SetVisible( button, true )
	}

	ArenasStoreItem item = GetStoreDataByIndex( idx )

	bool owned = false
	bool selected = false
	bool hasPreReq = true
	bool canAfford = true
	bool wasOwned = false
	bool ownsMaxItems = false
	bool onCooldown = false

	if ( player != null )
	{
		if( item.passive != -1 && player.HasPassive( item.passive ) )
		{
			owned = true
		}
		else if ( item.ref == "tactical_upgrade" || item.ref == "arenas_full_ultimate" )
		{
			int slot = OFFHAND_TACTICAL
			switch ( item.ref )
			{
				case "tactical_upgrade":
					slot = OFFHAND_TACTICAL
					entity ability = player.GetOffhandWeapon( slot )
					owned = ability.GetWeaponPrimaryAmmoCount( AMMOSOURCE_STOCKPILE ) == ability.GetWeaponPrimaryAmmoCountMax( AMMOSOURCE_STOCKPILE )
					break
				case "arenas_full_ultimate":
					slot = OFFHAND_ULTIMATE
					entity ability = player.GetOffhandWeapon( slot )
					owned = ability.GetWeaponPrimaryClipCount() == ability.GetWeaponPrimaryClipCountMax()
					break
			}

		}
		else if ( item.ref == "buy_passive" )
		{
			owned = PlayerHasCharacterPassive( player )
		}

		hasPreReq = DoesPlayerHavePreReq( player, item.ref, entVar )
		canAfford = CanPlayerAfford( player, item.ref )
		wasOwned = owned
	}

	RuiSetBool( rui, "hasPreReq", hasPreReq )
	RuiSetBool( rui, "canAfford", canAfford )
	RuiSetBool( rui, "wasOwned", wasOwned )
	RuiSetBool( rui, "ownsMaxItems", ownsMaxItems )
	RuiSetInt( rui, "cost", GetArenasStoreItemCost( player, item.ref ) )

	if ( item.ref == "arenas_full_ultimate" )
	{
		RuiSetInt( rui, "stock", player.GetPlayerNetInt( "ultimateCooldown" ) )

		onCooldown = !(hasPreReq && ( player.GetPlayerNetInt( "ultimateCooldown" ) <= 0 || owned ))
		RuiSetBool( rui, "hasPreReq", !onCooldown )
	}

	_Arenas_BindBuyButtonV2_PopulateInfoOnly( player, button, rui, idx )

	if ( button != null )
	{
		bool locked = false
		if( player != null )
		{
			if( IsStoreIndexSelected( player, item.index ) )
				selected = true

			if( SURVIVAL_Loot_IsRefValid( item.lootOrPerkRef ) )
			{
				ownsMaxItems = DoesPlayerOwnMaxItems( player, item.ref )
			}
		}

		RuiSetBool( rui, "ownsMaxItems", ownsMaxItems )

		Hud_SetSelected( button, selected )
		Hud_SetLocked( button, locked )

		ToolTipData td
		td.titleText = Localize( item.name )
		td.descText = Localize( item.desc )
		td.tooltipStyle = eTooltipStyle.DEFAULT

		                                                    
		if( !locked && !wasOwned && !ownsMaxItems && !onCooldown && canAfford )
			td.actionHint1 = Localize( "#ARENAS_BUY" ) + " "

		if( selected )
			td.actionHint1 = td.actionHint1 + Localize( "#ARENAS_SELL" )
		                        
		  	                                                  

		if( !hasPreReq )
		{
			td.titleText = Localize( "LOCKED - " + td.titleText )
		}

		if( item.ref == "tactical_upgrade" )
		{
			ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_Character() )
			ItemFlavor tac = CharacterClass_GetTacticalAbility( character )

			td.titleText = Localize( ItemFlavor_GetShortName( tac ) )
			td.descText = Localize( ItemFlavor_GetShortDescription( tac ) )
			RuiSetString( rui, "weaponName", td.titleText )
		}

		if( item.ref == "arenas_full_ultimate" )
		{
			ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_Character() )
			ItemFlavor ult = CharacterClass_GetUltimateAbility( character )

			td.titleText = Localize( ItemFlavor_GetShortName( ult ) )
			td.descText = Localize( ItemFlavor_GetShortDescription( ult ) )

			RuiSetString( rui, "weaponName", td.titleText )

			if ( onCooldown )
				td.actionHint1 = Localize( "#ARENAS_ON_COOLDOWN", GetArenasStoreItemPurchaseLimit( player, "arenas_full_ultimate" ) )
		}

		if( item.ref == "buy_passive" )
		{
			ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_Character() )
			ItemFlavor pas = CharacterClass_GetPassiveAbilities( character )[ 0 ]

			td.titleText = Localize( ItemFlavor_GetShortName( pas ) )
			td.descText = Localize( ItemFlavor_GetShortDescription( pas ) )
			RuiSetString( rui, "weaponName", td.titleText )
		}

		RunUIScript( "ClientToUI_Tooltip_MarkForClientUpdate", button, eTooltipStyle.DEFAULT )

		Hud_SetToolTipData( button,td )
	}
}

void function _Arenas_BindBuyButtonV2_PopulateInfoOnly( entity player, var button, var rui, int idx )
{
	ArenasStoreItem item = GetStoreDataByIndex( idx )

	RuiSetBool( rui, "isTacticalButton", false )
	RuiSetImage( rui, "iconImage", item.icon )

	#if NX_PROG
		{
			RuiSetFloat( rui, "isNX", 1.0 )
		}
	#endif

	if ( SURVIVAL_Loot_IsRefValid( item.lootOrPerkRef ) )
	{
		LootData data = SURVIVAL_Loot_GetLootDataByRef( item.lootOrPerkRef )
		RuiSetInt( rui, "lootTier", data.tier )

		if( player != null )
		{
			RuiSetInt( rui, "count", SURVIVAL_CountItemsInInventory( player, data.ref ) )
			RuiSetBool( rui, "showWhenEmpty", true )
		}

		if( data.lootType == eLootType.ORDNANCE )
		{
			RuiSetInt( rui, "maxCount", Arenas_GetMaxOrdnance( player ) )
		}
		else if( data.lootType == eLootType.HEALTH )
		{
			int itemMax = 0
			if( item.lootOrPerkRef == "health_pickup_health_small" )
				itemMax = GetCurrentPlaylistVarInt( "arenas_max_syringes", ARENAS_MAX_SYRINGES )
			else if( item.lootOrPerkRef == "health_pickup_health_large" )
				itemMax = GetCurrentPlaylistVarInt( "arenas_max_medkits", ARENAS_MAX_MEDKITS )
			else if( item.lootOrPerkRef == "health_pickup_combo_small" )
				itemMax = GetCurrentPlaylistVarInt( "arenas_max_shield_cells", ARENAS_MAX_SHIELDCELLS )
			else if( item.lootOrPerkRef == "health_pickup_combo_large" )
				itemMax = GetCurrentPlaylistVarInt( "arenas_max_shield_batteries", ARENAS_MAX_SHIELDBATS )

			RuiSetInt( rui, "maxCount", itemMax )
		}
	}
	else if( IsGoldUtilityItem( item ) )
	{
		RuiSetInt( rui, "lootTier", 4 )
		RuiSetInt( rui, "count", PlayerHasPassive( player, item.passive ) ? 1 : 0 )
		RuiSetInt( rui, "maxCount", 1 )
	}
	else if ( item.ref == "tactical_upgrade" || item.ref == "arenas_full_ultimate" )
	{
		RuiSetBool( rui, "isTacticalButton", true )

		if( player != null )
		{
			ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_Character() )
			ItemFlavor ability

			int slot = OFFHAND_TACTICAL
			int tier = eLootTier.RARE
			bool useStockpile

			switch ( item.ref )
			{
				case "tactical_upgrade":
					ability = CharacterClass_GetTacticalAbility( character )
					slot = OFFHAND_TACTICAL
					useStockpile = true
					break
				case "arenas_full_ultimate":
					ability = CharacterClass_GetUltimateAbility( character )
					slot = OFFHAND_ULTIMATE
					tier = eLootTier.LEGENDARY
					useStockpile = false
					break
			}

			RuiSetImage( rui, "iconImage", ItemFlavor_GetIcon( ability ) )
			entity weapon = player.GetOffhandWeapon( slot )
			int burstCount = maxint( 1 , weapon.GetWeaponSettingInt( eWeaponVar.burst_fire_count ) )
			int ammoPerShot = weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
			int count = ( ( useStockpile ? weapon.GetWeaponPrimaryAmmoCount( AMMOSOURCE_STOCKPILE ) :  0 ) + weapon.GetWeaponPrimaryClipCount() ) / ( ammoPerShot * burstCount )
			int maxCount = ( ( useStockpile ? weapon.GetWeaponPrimaryAmmoCountMax( AMMOSOURCE_STOCKPILE ) : 0 ) + weapon.GetWeaponPrimaryClipCountMax() ) / ( ammoPerShot * burstCount )
			RuiSetInt( rui, "count", count )
			RuiSetInt( rui, "maxCount", maxCount )
			RuiSetInt( rui, "lootTier", tier )
		}
	}
	else if ( item.ref == "buy_passive" )
	{
		RuiSetBool( rui, "isTacticalButton", true )

		if( player != null )
		{
			ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_Character() )
			ItemFlavor ability   = CharacterClass_GetPassiveAbilities( character )[ 0 ]

			RuiSetImage( rui, "iconImage", ItemFlavor_GetIcon( ability ) )

			string passiveString = GetGlobalSettingsString( ItemFlavor_GetAsset( ability ), "passiveScriptRef" )
			ArenasStoreItem passiveData = file.storeData[ passiveString ]

			bool hasPassive = PlayerHasPassive( player, CharacterAbility_GetPassiveIndex( ability ) )
			int cost = passiveData.cost
			if ( cost == 0 )
			{
				RuiSetInt( rui, "count", hasPassive ? 1 : 0 )
				RuiSetInt( rui, "maxCount", 1 )
			}
			else
			{
				RuiSetInt( rui, "count", player.GetPlayerNetInt( "passiveCharges" ) )
				RuiSetInt( rui, "maxCount", passiveData.maxCount )
			}

			RuiSetInt( rui, "lootTier", eLootTier.RARE )
		}
	}
}

void function UICallback_Arenas_BindEquipment( var button )
{
	if ( IsLobby() )
		return

	entity player = GetLocalClientPlayer()

	Hud_ClearToolTipData( button )
	Hud_SetSelected( button, false )
	Hud_SetVisible( button, false )

	var rui = Hud_GetRui( button )

	string entVar = Hud_GetScriptID( button )

	LootData equippedData
	if( entVar.find( "helmet" ) != -1 )
		equippedData = EquipmentSlot_GetEquippedLootDataForSlot( player, "helmet" )
	else if( entVar.find( "armor" ) != -1 )
		equippedData = EquipmentSlot_GetEquippedLootDataForSlot( player, "armor" )
	else
		return

	Hud_SetVisible( button, true )

	RuiSetInt( rui, "count", 1 )
	RuiSetInt( rui, "maxCount", 1 )
	RuiSetInt( rui, "lootTier", equippedData.tier )
	RuiSetImage( rui, "iconImage", equippedData.hudIcon )
}

void function UICallback_Arenas_BindUtilityTitle( var button )
{
	if ( IsLobby() )
		return

	entity player = GetLocalClientPlayer()

	var rui = Hud_GetRui( button )
	ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_Character() )
	asset icon = CharacterClass_GetGalleryPortrait( character )
	RuiSetImage( rui, "characterIcon", icon )
}

void function UICallback_Arenas_OnWeaponTabClick( var button )
{
	if( IsLobby() )
		return

	entity player = GetLocalClientPlayer()

	string entVar = Hud_GetScriptID( button )
	string weaponTab = "arenas_weapon_tab_"

	int tabIndex = int( entVar.slice( weaponTab.len() ) )
	file.selectedTab = tabIndex

	EmitSoundOnEntity( GetLocalClientPlayer(), SOUND_CHANGE_TAB )
	RunUIScript( "ClientToUI_Arenas_RefreshBuyMenu" )
	                                                                                
}

void function UICallback_Arenas_OnBuyButtonClick( var button )
{
	if ( IsLobby() || Hud_IsLocked( button ) || file.isProcessingClickEvent )
		return

	entity player = GetLocalClientPlayer()

	string entVar = Hud_GetScriptID( button )

	int idx = Arenas_GetShopButtonIndex( player, entVar )

	if ( idx == -1 )
		return

	ArenasStoreItem item = GetStoreDataByIndex( idx )

	if( IsAvailableWeapon( player, item.ref ) && IsStoreIndexSelected( player, idx ) )
		return

	if ( !CanPlayerBuy( player, item.ref ) )
		return

	if( item.passive != -1 && player.HasPassive( item.passive ) )
		return

	file.selectedItems.append( idx )
	file.isProcessingClickEvent = true

	string buySoundEvent = SOUND_BUY
	if( IsAvailableWeapon( player, item.ref ) )
	{
		if ( item.ref.find( WEAPON_LOCKEDSET_SUFFIX_WHITESET ) != -1 )
			buySoundEvent = SOUND_BUY_UPGRADE_LV1
		else if ( item.ref.find( WEAPON_LOCKEDSET_SUFFIX_BLUESET ) != -1 )
			buySoundEvent = SOUND_BUY_UPGRADE_LV2
		else if ( item.ref.find( WEAPON_LOCKEDSET_SUFFIX_PURPLESET ) != -1 )
			buySoundEvent = SOUND_BUY_UPGRADE_LV3
	}

	EmitSoundOnEntity( GetLocalClientPlayer(), buySoundEvent )

	Remote_ServerCallFunction( "ClientCallback_Arenas_Select", idx )
	SetPreferredOptic( item.ref )
}

void function UICallback_Arenas_OnBuyButtonRightClick( var button )
{
	if ( IsLobby() || Hud_IsLocked( button ) || file.isProcessingClickEvent )
		return

	entity player = GetLocalClientPlayer()

	string entVar = Hud_GetScriptID( button )

	int idx = Arenas_GetShopButtonIndex( player, entVar )

	if ( idx == -1 )
		return

	int indexToRemove = idx

	ArenasStoreItem item = GetStoreDataByIndex( idx )
	if( IsAvailableWeapon( player, item.lootOrPerkRef ) )
	{
		string prevRef = GetPrevUpgradedWeaponRef( item.lootOrPerkRef )
		if ( GetNextUpgradedWeaponRef( item.lootOrPerkRef ) == item.lootOrPerkRef )
		{
			bool owned    = false
			for( int i = 0; i < 2; ++i )
			{
				entity weapon = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 + i )
				if ( IsValid( weapon ) )
				{
					if ( item.lootOrPerkRef == GetWeaponClassNameWithLockedSet( weapon ) )
					{
						owned = true
						break
					}
				}
			}

			if ( owned )
				prevRef = item.lootOrPerkRef
		}

		if ( !(prevRef in file.storeData) )
			return

		if ( !IsStoreIndexSelected( player, file.storeData[ prevRef ].index ) )
			return

		indexToRemove = file.storeData[ prevRef ].index
	}
	else if( !IsStoreIndexSelected( player, idx ) )
		return

	for( int i = 0; i < file.selectedItems.len(); ++i )
	{
		if( file.selectedItems[ i ] == indexToRemove )
		{
			file.selectedItems.fastremove( i )
			break
		}
	}

	file.isProcessingClickEvent = true
	EmitSoundOnEntity( GetLocalClientPlayer(), SOUND_SELL )
	Remote_ServerCallFunction( "ClientCallback_Arenas_Unselect", idx )

	                                                                                                                     
	                                                                            
	if( IsAvailableWeapon( player, item.lootOrPerkRef ) )
	{
		string unselectRef = ""

		for( int i = 0; i < 2; ++i )
		{
			entity weapon = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 + i )
			if( IsValid( weapon ) && weapon.GetWeaponClassName() == GetBaseWeaponRef( item.ref ) )
			{
				if( GetWeaponClassNameWithLockedSet( weapon ) == item.ref )
					unselectRef = item.ref
				else
					unselectRef = GetPrevUpgradedWeaponRef( item.ref )

				break
			}
		}

		if( unselectRef == "" )
			return

		string prevRef = GetPrevUpgradedWeaponRef( unselectRef )
		if( prevRef != unselectRef && prevRef in file.storeData )
			SetPreferredOptic( prevRef )
	}
}

void function UICallback_Arenas_OnBuyButtonMiddleClick( var button )
{
	if ( IsLobby() || Hud_IsLocked( button ) || file.isProcessingClickEvent )
		return

	entity player = GetLocalClientPlayer()

	string entVar = Hud_GetScriptID( button )

	int idx = Arenas_GetShopButtonIndex( player, entVar)

	if ( idx == -1 )
		return

	ArenasStoreItem item = GetStoreDataByIndex( idx )
	bool ownedCurrent    = false
	bool ownedPrev       = false

	string prevRef = GetPrevUpgradedWeaponRef( item.ref )

	for ( int i = 0; i < 2; ++i )
	{
		entity weapon = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 + i )
		if ( IsValid( weapon ) )
		{
			string weaponRef = GetWeaponClassNameWithLockedSet( weapon )

			if ( prevRef == weaponRef )
			{
				ownedPrev = true
				break
			}
			else if ( item.ref == weaponRef )
			{
				ownedCurrent = true
				break
			}
		}
	}

	if ( !ownedPrev && !ownedCurrent )
		return

	if ( ownedPrev )
	{
		if ( !(prevRef in file.storeData) )
			return

		item = file.storeData[ prevRef ]
	}

	if ( !(item.lootOrPerkRef in file.weaponUpgrades) )
		return

	array<string> optics = GetAvailableOptics( item.index )
	if ( optics.len() <= 1 )
		return

	int opticLootIndex = -1
	foreach ( upgrade in file.weaponUpgrades[ item.lootOrPerkRef ] )
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
	file.selectedWeaponForOptic = item.index
	RunUIScript( "ClientToUI_Arenas_OpenSelectOpticDialog", opticLootIndex, optics.len() )
}

void function UICallback_Arenas_OnOpticSlotButtonClick( var button )
{
	if ( file.selectedWeaponForOptic == -1 || Hud_IsLocked( button ) )
		return

	entity player        = GetLocalClientPlayer()
	int opticIndex       = int(Hud_GetScriptID( button ))
	array<string> optics = GetAvailableOptics( file.selectedWeaponForOptic )

	if ( opticIndex >= optics.len() )
		return

	ArenasStoreItem item = GetStoreDataByIndex( file.selectedWeaponForOptic )

	LootData currentWeaponData = SURVIVAL_Loot_GetLootDataByRef( item.lootOrPerkRef )
	entity currentWeapon       = null

	for ( int i = 0; i < 2; ++i )
	{
		entity weapon = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 + i )
		if ( IsValid( weapon ) )
		{
			LootData weaponData = SURVIVAL_GetLootDataFromWeapon( weapon )
			if ( weaponData.baseWeapon == currentWeaponData.baseWeapon )
			{
				currentWeapon = weapon
				break
			}
		}
	}

	if ( !IsValid( currentWeapon ) )
		return

	int opticLootIndex = -1
	bool replacedOptic = false

	for ( int i = 0; i < file.weaponUpgrades[ item.lootOrPerkRef ].len(); ++i )
	{
		if ( !SURVIVAL_Loot_IsRefValid( file.weaponUpgrades[ item.lootOrPerkRef ][i] ) )
			continue

		LootData attachData = SURVIVAL_Loot_GetLootDataByRef( file.weaponUpgrades[ item.lootOrPerkRef ][i] )
		if ( attachData.attachmentStyle.find( "sight" ) >= 0 )
		{
			if( SURVIVAL_Loot_IsRefValid( optics[opticIndex] ) )
			{
				file.weaponUpgrades[ item.lootOrPerkRef ][i] = optics[opticIndex]
				LootData newOpticData = SURVIVAL_Loot_GetLootDataByRef( optics[opticIndex] )
				opticLootIndex = newOpticData.index
			}
			else
				file.weaponUpgrades[ item.lootOrPerkRef ].remove( i )

			replacedOptic = true
			break
		}
	}

	if( !replacedOptic && SURVIVAL_Loot_IsRefValid( optics[opticIndex] ) )
	{
		file.weaponUpgrades[ item.lootOrPerkRef ].append( optics[opticIndex] )
		LootData newOpticData = SURVIVAL_Loot_GetLootDataByRef( optics[opticIndex] )
		opticLootIndex = newOpticData.index
	}

	EmitSoundOnEntity( GetLocalClientPlayer(), SOUND_SELECT_OPTIC )
	Remote_ServerCallFunction( "ClientCallback_Arenas_SetOptic", currentWeaponData.index, opticLootIndex )
	RunUIScript( "ClientToUI_Arenas_CloseSelectOpticDialog" )
	RunUIScript( "ClientToUI_Arenas_RefreshBuyMenu" )
}

void function UICallback_Arenas_OpticSelectDialogueClose()
{
	file.selectedWeaponForOptic = -1
}

#endif


int function Arenas_GetMaxOrdnance( entity player )
{
	int maxOrdnance = GetCurrentPlaylistVarInt( "arenas_max_ordnance", ARENAS_MAX_ORDNANCE )
	if( PlayerHasPassive( player, ePassives.PAS_FUSE ) )
		maxOrdnance *= 2

	return maxOrdnance
}

bool function PlayerHasRequiredWeapon( entity player, string ref )
{
	if( !( ref in file.storeData ) )
		return false

	string lootRef = file.storeData[ ref ].lootOrPerkRef

	if( !SURVIVAL_Loot_IsRefValid( lootRef ) )
		return true

	LootData data = SURVIVAL_Loot_GetLootDataByRef( lootRef )
	if( data.lootType == eLootType.MAINWEAPON )
	{
		if ( WeaponLootRefIsLockedSet( lootRef ) )
		{
			string prevRef = GetPrevUpgradedWeaponRef( lootRef )

			array<entity> weapons = [ player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 ), player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 ) ]
			foreach ( w in weapons )
			{
				if ( !IsValid( w ) )
					continue

				if ( GetWeaponClassNameWithLockedSet( w ) == prevRef )
					return true
			}

			return false
		}
	}

	return true
}

bool function DoesPlayerOwnMaxItems( entity player, string ref )
{
	if( !( ref in file.storeData ) )
		return false

	string lootRef = file.storeData[ ref ].lootOrPerkRef

	if( !SURVIVAL_Loot_IsRefValid( lootRef ) )
		return false

	LootData data = SURVIVAL_Loot_GetLootDataByRef( lootRef )
	if( data.lootType == eLootType.ORDNANCE )
	{
		int ordnanceCount = 0
		array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )
		foreach( invItem in playerInventory )
		{
			LootData invData = SURVIVAL_Loot_GetLootDataByIndex( invItem.type )
			if( invData.lootType != eLootType.ORDNANCE )
				continue

			ordnanceCount += invItem.count
		}

		return ordnanceCount >= Arenas_GetMaxOrdnance( player )
	}
	else if( data.lootType == eLootType.HEALTH )
	{
		int itemCount = 0
		array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )
		foreach( invItem in playerInventory )
		{
			LootData invData = SURVIVAL_Loot_GetLootDataByIndex( invItem.type )
			if( invData.ref != lootRef )
				continue

			itemCount += invItem.count
		}

		int itemMax = 0
		if( lootRef == "health_pickup_health_small" )
			itemMax = GetCurrentPlaylistVarInt( "arenas_max_syringes", ARENAS_MAX_SYRINGES )
		else if( lootRef == "health_pickup_health_large" )
			itemMax = GetCurrentPlaylistVarInt( "arenas_max_medkits", ARENAS_MAX_MEDKITS )
		else if( lootRef == "health_pickup_combo_small" )
			itemMax = GetCurrentPlaylistVarInt( "arenas_max_shield_cells", ARENAS_MAX_SHIELDCELLS )
		else if( lootRef == "health_pickup_combo_large" )
			itemMax = GetCurrentPlaylistVarInt( "arenas_max_shield_batteries", ARENAS_MAX_SHIELDBATS )

		return itemCount >= itemMax
	}

	return false
}

bool function DoesPlayerHavePreReq( entity player, string ref, string entVar )
{
	                                       
	   
	  	           
	   

	return true
}

int function GetArenasStoreItemPurchaseLimit( entity player, string ref )
{
	string refToUse = ref
	if ( ref == "tactical_upgrade" || ref == "arenas_full_ultimate" )
		refToUse = GetOffhandWeaponRef( player, ref )
	else if ( ref == "buy_passive" )
	{
		ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_Character() )

		ItemFlavor passive = CharacterClass_GetPassiveAbilities( character )[ 0 ]

		refToUse = GetGlobalSettingsString( ItemFlavor_GetAsset( passive ), "passiveScriptRef" )
	}

	if( !( refToUse in file.storeData ) )
	{
		Warning( "GetArenasStoreItemCost - ref %s not found in store", ref )
		return 0
	}

	return file.storeData[ refToUse ].maxCount
}

int function GetArenasStoreItemCost( entity player, string ref )
{
	string refToUse = ref
	if ( ref == "tactical_upgrade" || ref == "arenas_full_ultimate" )
		refToUse = GetOffhandWeaponRef( player, ref )
	else if ( ref == "buy_passive" )
	{
		ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_Character() )

		ItemFlavor passive = CharacterClass_GetPassiveAbilities( character )[ 0 ]

		refToUse = GetGlobalSettingsString( ItemFlavor_GetAsset( passive ), "passiveScriptRef" )
	}

	if( !( refToUse in file.storeData ) )
	{
		Warning( "GetArenasStoreItemCost - ref %s not found in store", refToUse )
		return 0
	}

	return file.storeData[ refToUse ].cost
}

int function Arenas_GetItemCostByRef( entity player, string itemRef )
{
	string refToUse = itemRef
	if ( itemRef == "tactical_upgrade" || itemRef == "arenas_full_ultimate" )
		refToUse = GetOffhandWeaponRef( player, itemRef )
	else if ( itemRef == "buy_passive" )
	{
		ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_Character() )

		ItemFlavor passive = CharacterClass_GetPassiveAbilities( character )[ 0 ]

		refToUse = GetGlobalSettingsString( ItemFlavor_GetAsset( passive ), "passiveScriptRef" )
	}

	if( refToUse in file.storeData )
		return file.storeData[ refToUse ].cost

	foreach( item in file.storeData )
	{
		if( item.lootOrPerkRef == refToUse )
			return item.cost

		if( item.passive != -1 && GetEnumString( "ePassives", item.passive ) == refToUse )
			return item.cost
	}

	return 0
}

string function GetOffhandWeaponRef( entity player, string ref )
{
	if ( ref == "tactical_upgrade" || ref == "arenas_full_ultimate" )
	{
		int slot
		switch ( ref )
		{
			case "tactical_upgrade":
				slot = OFFHAND_TACTICAL
				break

			case "arenas_full_ultimate":
				slot = OFFHAND_ULTIMATE
				break
		}
		entity ability = player.GetOffhandWeapon( slot )
		return ability.GetWeaponClassName()
	}

	return ref
}

bool function CanPlayerBuy( entity player, string ref )
{
	if( !CanPlayerAfford( player, ref ) )
		return false

	if( IsPlayerMaxedOut( player, ref ) )
		return false

	if( DoesPlayerOwnMaxItems( player, ref ) )
		return false

	if ( !PlayerHasRequiredWeapon( player, ref ) )
		return false

	return true
}

bool function IsPlayerMaxedOut( entity player, string ref )
{
	if ( ref == "tactical_upgrade" || ref == "arenas_full_ultimate" )
	{
		int slot = OFFHAND_TACTICAL
		switch ( ref )
		{
			case "tactical_upgrade":
				slot = OFFHAND_TACTICAL
				entity ability = player.GetOffhandWeapon( slot )
				return (ability.GetWeaponPrimaryAmmoCount( AMMOSOURCE_STOCKPILE ) == ability.GetWeaponPrimaryAmmoCountMax( AMMOSOURCE_STOCKPILE ) )
				break
			case "arenas_full_ultimate":
				slot = OFFHAND_ULTIMATE
				entity ability = player.GetOffhandWeapon( slot )
				return (ability.GetWeaponPrimaryClipCount() == ability.GetWeaponPrimaryClipCountMax()) || player.GetPlayerNetInt( "ultimateCooldown" ) > 0
				break
		}

		unreachable
	}
	else if ( ref == "buy_passive" )
	{
		return PlayerHasCharacterPassive( player )
	}

	return false
}

bool function CanPlayerAfford( entity player, string ref )
{
	if ( player.GetPlayerNetInt( "arenas_current_cash" ) < GetArenasStoreItemCost( player, ref ) )
		return false

	return true
}

bool function PlayerHasCharacterPassive( entity player )
{
	bool owned = false

	ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_Character() )

	array<ItemFlavor> passives = CharacterClass_GetPassiveAbilities( character )

	foreach ( passive in passives )
	{
		if ( PlayerHasPassive( player, CharacterAbility_GetPassiveIndex( passive ) ) )
		{
			string passiveString = GetGlobalSettingsString( ItemFlavor_GetAsset( passive ), "passiveScriptRef" )
			ArenasStoreItem passiveData = file.storeData[ passiveString ]

			owned = passiveData.cost == 0 || player.GetPlayerNetInt( "passiveCharges" ) >= passiveData.maxCount
			break
		}
	}

	return owned
}

#if CLIENT
void function ServerCallback_RefreshMenu( )
{
	RunUIScript( "ClientToUI_Arenas_RefreshBuyMenu" )
}

void function ServerCallback_FinishedProcessingClickEvent()
{
	file.isProcessingClickEvent = false
}

void function UICallback_Arenas_OnShowDeathRecap()
{
	RunUIScript( "UI_DeathScreenHideTabs", true )                                                                                                                              
	DeathScreen_SetSkipDeathRecapAnimation( true )
	ShowDeathScreen( eDeathScreenPanel.DEATH_RECAP )
	EnableDeathScreenTab( eDeathScreenPanel.SQUAD_SUMMARY, false )
	EnableDeathScreenTab( eDeathScreenPanel.SPECTATE, false )
	thread _WaitForDeathScreenClosed()
}

void function UICallback_Arenas_PingAirdropPreview( var element )
{
	if ( IsLobby() )
		return

	Remote_ServerCallFunction( "ClientCallback_Quickchat", eCommsAction.PING_GO_CAREPACKAGE, eCommsFlags.FORCE_FAR, null, "" )
}

void function _WaitForDeathScreenClosed()
{
	EndSignal( GetLocalClientPlayer(), "DeathScreenMenuClosed" )

	OnThreadEnd(
		function() : ()
		{
			Arenas_TryOpenBuyMenu()
		}
	)

	WaitForever()
}

void function Arenas_OpenBuyMenu( float endTime, bool playIntroTransition = false )
{
	file.autoCloseMenuOnSelect = true
	thread _OpenBuyMenu( endTime, playIntroTransition )
}

void function _OpenBuyMenu( float endTime, bool playIntroTransition )
{
	if ( Time() >= endTime )
		return

	RunUIScript( "ClientToUI_Arenas_OpenBuyMenu", playIntroTransition )

	while ( Time() < endTime )
	{
		WaitFrame()
	}

	RunUIScript( "ClientToUI_Arenas_CloseBuyMenu" )
}

void function OnPrematch_Client()
{
	RunUIScript( "UI_DeathScreenHideTabs", true )
}

void function OnGamePlaying_Client()
{
	file.selectedItems.clear()
	file.isProcessingClickEvent = false
	RunUIScript( "UI_DeathScreenHideTabs", false )
}

void function OnWaitingForPlayers_Client()
{
	if( !file.hasRegisteredToolTipCB )
	{
		file.hasRegisteredToolTipCB = true
		AddCallback_OnUpdateTooltip( eTooltipStyle.ARENAS_SHOP_WEAPON, OnUpdateTooltip )
	}
}

void function OnUpdateTooltip( int style, ToolTipData dt )
{
	if( dt.lootPromptData.index == -1 )
		return

	ArenasStoreItem item = GetStoreDataByIndex( dt.lootPromptData.index )

	var rui = GetTooltipRui()

	array<string> actionList
	if ( dt.actionHint1 != "" )
		actionList.append( dt.actionHint1 )
	if ( dt.actionHint2 != "" )
		actionList.append( dt.actionHint2 )
	if ( dt.actionHint3 != "" )
		actionList.append( dt.actionHint3 )

	entity player = GetLocalClientPlayer()
	bool owned = false
	if ( SURVIVAL_Loot_IsRefValid( item.lootOrPerkRef ) )
	{
		LootData data     = SURVIVAL_Loot_GetLootDataByRef( item.lootOrPerkRef )
		LootData baseWeaponData = SURVIVAL_Loot_GetLootDataByRef( data.baseWeapon )

		RuiSetInt( rui, "lootTier", WeaponLootRefIsLockedSet( item.lootOrPerkRef ) ? data.tier : 0 )
		RuiSetBool( rui, "isLockedSet", WeaponLootRefIsLockedSet( item.lootOrPerkRef ) )

		string prevRef = GetPrevUpgradedWeaponRef( item.lootOrPerkRef )

		for( int i = 0; i < 2; ++i )
		{
			entity weapon = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 + i )
			if( IsValid( weapon ) )
			{
				string weaponRef = GetWeaponClassNameWithLockedSet( weapon )

				LootData weaponRefData = SURVIVAL_Loot_GetLootDataByRef( weaponRef )
				if( weaponRefData.lootTags.contains( WEAPON_LOCKEDSET_MOD_GOLD ) )
					weaponRef = GetBaseWeaponRef( weaponRef ) + WEAPON_LOCKEDSET_SUFFIX_PURPLESET

				if( item.ref == weaponRef )
				{
					owned = true
					break
				}
			}
		}

		string nextRef = GetNextUpgradedWeaponRef( item.lootOrPerkRef )
		if( owned && nextRef == item.lootOrPerkRef )
			prevRef = item.lootOrPerkRef

		RuiSetBool( rui, "barrelAllowed", false )
		RuiSetBool( rui, "magAllowed", false )
		RuiSetBool( rui, "sightAllowed", false )
		RuiSetBool( rui, "gripAllowed", false )
		RuiSetBool( rui, "hopupAllowed", false )
		RuiSetBool( rui, "hopupMultiAAllowed", false )
		RuiSetBool( rui, "hopupMultiBAllowed", false )

		for( int i = 0; i < baseWeaponData.supportedAttachments.len(); ++i )
		{
			string attachment = baseWeaponData.supportedAttachments[i]
			if( attachment == "hopupMulti_a" )
				attachment = "hopupMultiA"
			else if( attachment == "hopupMulti_b" )
				attachment = "hopupMultiB"

			RuiSetBool( rui, attachment + "Allowed", true )
			RuiSetBool( rui, attachment + "Empty", true )
			RuiSetBool( rui, attachment + "UpgradeEmpty", true )
			RuiSetInt( rui, attachment + "Slot", i )

			string attachmentStyle = GetAttachmentPointStyle( baseWeaponData.supportedAttachments[i], baseWeaponData.baseWeapon )
			RuiSetImage( rui, attachment + "Icon", emptyAttachmentSlotImages[attachmentStyle] )
			RuiSetImage( rui, attachment + "UpgradeIcon", emptyAttachmentSlotImages[attachmentStyle] )
		}

		if( prevRef in file.weaponUpgrades )
		{
			array<string> upgrades = file.weaponUpgrades[ prevRef ]
			int attachIndex = 0
			for( int i = 0; i < upgrades.len(); ++i )
			{
				if( !SURVIVAL_Loot_IsRefValid( upgrades[i] ) )
					continue

				LootData attachData = SURVIVAL_Loot_GetLootDataByRef( upgrades[i] )
				string attachStyle = ""
				if ( attachData.attachmentStyle.find( "barrel" ) >= 0 )
					attachStyle = "barrel"
				else if ( attachData.attachmentStyle.find( "mag" ) >= 0 )
					attachStyle = "mag"
				else if ( attachData.attachmentStyle.find( "sight" ) >= 0 )
					attachStyle = "sight"
				else if ( attachData.attachmentStyle.find( "stock" ) >= 0 )
					attachStyle = "grip"
				else if ( attachData.attachmentStyle.find( "hopupMulti_a" ) >= 0 )
					attachStyle = "hopupMultiA"
				else if ( attachData.attachmentStyle.find( "hopupMulti_b" ) >= 0 )
					attachStyle = "hopupMultiB"
				else if ( attachData.attachmentStyle.find( "hopup" ) >= 0 )
					attachStyle = "hopup"

				if( attachStyle == "" )
					continue

				RuiSetImage( rui, attachStyle + "Icon", attachData.hudIcon )
				RuiSetBool( rui, attachStyle + "Empty", false )

				attachIndex++
			}
		}

		if( item.lootOrPerkRef in file.weaponUpgrades )
		{
			array<string> upgrades = file.weaponUpgrades[ item.lootOrPerkRef ]
			int attachIndex = 0
			for( int i = 0; i < upgrades.len(); ++i )
			{
				if( !SURVIVAL_Loot_IsRefValid( upgrades[i] ) )
					continue

				LootData attachData = SURVIVAL_Loot_GetLootDataByRef( upgrades[i] )
				string attachStyle = ""
				if ( attachData.attachmentStyle.find( "barrel" ) >= 0 )
					attachStyle = "barrel"
				else if ( attachData.attachmentStyle.find( "mag" ) >= 0 )
					attachStyle = "mag"
				else if ( attachData.attachmentStyle.find( "sight" ) >= 0 )
					attachStyle = "sight"
				else if ( attachData.attachmentStyle.find( "stock" ) >= 0 )
					attachStyle = "grip"
				else if ( attachData.attachmentStyle.find( "hopup" ) >= 0 )
					attachStyle = "hopup"

				if( attachStyle == "" )
					continue

				RuiSetImage( rui, attachStyle + "UpgradeIcon", attachData.hudIcon )
				RuiSetBool( rui, attachStyle + "UpgradeEmpty", false )

				attachIndex++
			}
		}
	}

	RuiSetImage( rui, "iconImage", item.icon )
	RuiSetString( rui, "weaponName", item.name )
	RuiSetString( rui, "actionText1", actionList.len() > 0 ? actionList[0] : "" )
	RuiSetString( rui, "actionText2", actionList.len() > 1 ? actionList[1] : "" )
	RuiSetString( rui, "actionText3", actionList.len() > 2 ? actionList[2] : "" )
	RuiSetBool( rui, "wasOwned", owned )
	RuiSetInt( rui, "cost", GetArenasStoreItemCost( player, item.ref ) )
	RuiSetBool( rui, "canAfford", CanPlayerAfford( player, item.ref ) )
}

void function Arenas_OnWeaponStatusUpdate( entity player, var rui, int slot )
{
	if ( slot == OFFHAND_TACTICAL )
	{
		entity weapon = player.GetOffhandWeapon( slot )
		if ( IsValid( weapon ) )
		{
			RuiSetInt( rui, "maxAmmo", weapon.GetWeaponSettingInt( eWeaponVar.ammo_stockpile_max ) )
			RuiSetInt( rui, "maxMagAmmo", weapon.GetWeaponSettingInt( eWeaponVar.ammo_clip_size ) )

			RuiTrackFloat( rui, "stockpileFrac", weapon, RUI_TRACK_WEAPON_REMAINING_AMMO_FRACTION )
			RuiSetBool( rui, "displayStockpileCharges", true )
		}
	}
}

void function Arenas_ClientScriptInit( entity player )
{
	if ( file.passiveRui == null )
	{
		file.passiveRui = CreateCockpitPostFXRui( SURVIVAL_HUD_DPAD_RUI, HUD_Z_BASE )
		RuiSetFloat2( file.passiveRui, "additionalOffset", < 66, -72, 0 > )
		RuiSetBool( file.passiveRui, "showButtonHints", false )
		RuiSetBool( file.passiveRui, "isVisible", false )
		RuiSetBool( file.passiveRui, "isIconAdditive", true )
	}

	if ( player == GetLocalViewPlayer() )
		UpdatePassiveRui( player )
}

void function OnPlayerClassChanged_Arenas( entity player )
{
	if ( player == GetLocalViewPlayer() )
		UpdatePassiveRui( player )
}

void function UpdatePassiveRui( entity player )
{
	if ( file.passiveRui == null )
		return

	if ( !IsLocalClientEHIValid() )
		return

	thread __UpdatePassiveRui( player )
}

void function __UpdatePassiveRui( entity player )
{
	player.Signal( "UpdatePassiveRui" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "UpdatePassiveRui" )

	ItemFlavor character = LoadoutSlot_WaitForItemFlavor( ToEHI( player ), Loadout_Character() )
	array<ItemFlavor> passives = CharacterClass_GetPassiveAbilities( character )
	ItemFlavor mainPassive = passives[0]

	string passiveRef = GetGlobalSettingsString( ItemFlavor_GetAsset( mainPassive ), "passiveScriptRef" )
	int cost = GetArenasStoreItemCost( player, passiveRef )

	if ( cost == 0 )
	{
		RuiSetBool( file.passiveRui, "isVisible", false )
		return
	}

	RuiSetBool( file.passiveRui, "isVisible", true )
	RuiSetImage( file.passiveRui, "selectedHealthPickupIcon", ItemFlavor_GetIcon( mainPassive ) )
	RuiSetInt( file.passiveRui, "selectedHealthPickupCount", player.GetPlayerNetInt( "passiveCharges" ) )
}

void function OnBuyScreenVarUpdate( entity player, int newVal )
{
	if ( player == GetLocalViewPlayer() )
		UpdatePassiveRui( player )
}

#endif          

#if DEV
#if SERVER
                                                      
 
	                                     
	 
		                                   
		                                                                     
	 
 
#endif
#endif
