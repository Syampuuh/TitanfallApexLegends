global function CharacterLoadouts_Init
global function CharacterLoadouts_GetWeaponLoadoutArray
global function CharacterLoadouts_GetConsumableLoadoutArray
global function CharacterLoadouts_GetEquipmentLoadoutArray
global function CharacterLoadouts_SetIdenticalLoadoutIndex

global function ParseWeaponLoadoutText
global function ParseEquipmentLoadoutText
global function ParseConsumableLoadoutText

#if SERVER
                                                                     
                                                           
                                                              
                                                               
#endif

global struct WeaponLoadout {
	array< string > weaponRefs
	table< string, array< string > > weaponAttachmentsByWeapon
}

struct {
	table< string, WeaponLoadout >				   characterFlavorToWeaponLoadout
	table< string, array<string> >                 characterFlavorToConsumableLoadout
	table< string, array<string> >                 characterFlavorToEquipmentLoadout

	array<string>								   	weaponLoadoutDefault
	array<string>								  	consumableLoadoutDefault
	array<string>							   		equipmentLoadoutDefault
	array<string>								   	loadoutDisplayIgnoreItemsDefault

	table< string, array<string> >				   characterFlavorToDisplayedWeaponLoadout
	table< string, array<string> >                 characterFlavorToDisplayedConsumableLoadout
	table< string, array<string> >                 characterFlavorToDisplayedEquipmentLoadout

	int identicalLoadoutIndex = -1

	#if CLIENT
		var           loadoutInfoRui = null
		array<var>    loadoutRuiElements
		table<int,string> characterClassToLoadoutNameTable

		bool		  isDetailsPanelShowing = false
		bool          is16x10 = false
	#endif
} file

void function CharacterLoadouts_Init()
{
	if ( !IsCharacterLoadoutsEnabled() )
		return

	if ( GetCurrentPlaylistVarBool( "character_loadouts_identical", false ) )
		CharacterLoadouts_SetIdenticalLoadoutIndex( 0 )                   

	#if CLIENT
		if ( GetCurrentPlaylistVarBool( "character_loadouts_class_based", false ) )
			Init_CharacterClassToLoadoutNameTable()

	#endif

	SetDefaultLoadouts()

	PopulateCharacterLoadouts()

	#if SERVER
		                                                                  
		                                                      
	#endif

	#if CLIENT
		file.loadoutInfoRui = RuiCreate( $"ui/loadout_selection_info.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 1 )

		AddCallback_OnCharacterSelectMenuOpened( Callback_OnCharacterSelectOpened )
		AddCallback_OnCharacterSelectMenuClosed( Callback_OnCharacterSelectClosed )
		AddCallback_CharacterSelectMenu_OnCharacterFocused( Callback_OnCharacterFocusChanged )
		AddCallback_CharacterSelectMenu_OnCharacterLocked( Callback_OnCharacterLocked )
		AddCallback_OnCharacterSelectDetailsToggled( Callback_OnCharacterDetailsToggled )
	#endif
}

void function SetDefaultLoadouts()
{
	if ( GetCurrentPlaylistVarBool( "starter_kit_enabled", true ) )
	{
		string defaultweaponLoadoutsPlaylist    = GetCurrentPlaylistVarString( "default_loadout_weapons",
			"" )
		string defaultconsumableLoadoutPlaylist = GetCurrentPlaylistVarString( "default_loadout_consumables",
			"health_pickup_health_small:2 health_pickup_combo_small:2" )
		string defaultequipmentLoadoutPlaylist  = GetCurrentPlaylistVarString ( "default_loadout_equipment",
			"armor_pickup_lv1_evolving helmet_pickup_lv1 incapshield_pickup_lv1" )

		file.weaponLoadoutDefault = GetTrimmedSplitString( defaultweaponLoadoutsPlaylist, " " )
		file.consumableLoadoutDefault = GetTrimmedSplitString( defaultconsumableLoadoutPlaylist, " " )
		file.equipmentLoadoutDefault = GetTrimmedSplitString( defaultequipmentLoadoutPlaylist, " " )

		file.loadoutDisplayIgnoreItemsDefault.extend( file.weaponLoadoutDefault )
		file.loadoutDisplayIgnoreItemsDefault.extend( file.equipmentLoadoutDefault )


		foreach ( itemType in file.consumableLoadoutDefault )
		{
			array<string> tokens = GetTrimmedSplitString( itemType, ":" )
			string itemRef       = tokens[0]

			file.loadoutDisplayIgnoreItemsDefault.append( itemRef )
		}
	}
	else
	{
		file.weaponLoadoutDefault = []
		file.consumableLoadoutDefault = []
		file.equipmentLoadoutDefault = []
		file.loadoutDisplayIgnoreItemsDefault = []
	}


}


bool function IsCharacterLoadoutsEnabled()
{
	if ( !GetCurrentPlaylistVarBool( "character_loadouts_enabled", true ) )
		return false

	int startTime = expect int( GetCurrentPlaylistVarTimestamp( "character_loadouts_enabled_unixTimeStart", UNIX_TIME_FALLBACK_2038 ) )
	int endTime   = expect int( GetCurrentPlaylistVarTimestamp( "character_loadouts_enabled_unixTimeEnd", UNIX_TIME_FALLBACK_2038 ) )

	if ( startTime != UNIX_TIME_FALLBACK_2038 )
	{
		int unixTimeNow = GetUnixTimestamp()
		if ( (unixTimeNow >= startTime) && (unixTimeNow < endTime) )
		{
			return true
		}
		else
		{
			return false
		}
	}

	return true
}


void function CharacterLoadouts_SetIdenticalLoadoutIndex( int index )
{
	                             
	                   
	                                                                                                                                                                        
	                                                                                                                        
	                                                                                                                     

	Assert( index > -1 )
	file.identicalLoadoutIndex = index
}

string function GetCharacterLoadoutRef( string characterRef )
{
	array<ItemFlavor> characterList = clone GetAllCharacters()
	characterList.sort( SortByMenuButtonIndex )

	                                            
	                                           
	                                            
	table<string, int> characterDefaultLoadoutList
	for( int i = 0; i<characterList.len(); i++ )
	{
		characterDefaultLoadoutList[ ItemFlavor_GetHumanReadableRef( characterList[i] ).tolower() ] <- i
	}

	int characterLoadoutRefInt = 0                                           
	if ( GetCurrentPlaylistVarBool( "character_loadouts_identical", false ) )
	{
		Assert( file.identicalLoadoutIndex != -1, "Need to call CharacterLoadouts_SetIdenticalLoadoutIndex() to define character loadout for match" )
		characterLoadoutRefInt = file.identicalLoadoutIndex
		return characterLoadoutRefInt.tostring()
	}
	else if ( characterRef in characterDefaultLoadoutList )
	{
		characterLoadoutRefInt = characterDefaultLoadoutList[ characterRef ]
	}

	                                                                      
	                                                                      
	                                                                       
	string unixTimeEventStartString = GetCurrentPlaylistVarString( "character_loadouts_daily_cycle_start_date", "" )
	if ( unixTimeEventStartString != "" )
	{
		int unixTimeNow = GetUnixTimestamp()
		int ornull unixTimeEventStart = DateTimeStringToUnixTimestamp( unixTimeEventStartString )
		if ( unixTimeEventStart == null )
		{
			Assert( 0, format( "Bad format in playlist for setting 'character_loadouts_daily_cycle_start_date': '%s'", unixTimeEventStartString ) )
			return characterLoadoutRefInt.tostring()
		}

		int maxCharacterLoadouts
		for( int i = 0; i<100; i++ )
		{
			string testVal = GetCurrentPlaylistVarString( "character_loadout_weapons_" + i, "NULL" )
			if ( testVal == "NULL" )
			{
				maxCharacterLoadouts = i
				break
			}
		}

		expect int( unixTimeEventStart )
		if ( unixTimeNow > unixTimeEventStart )                                                                         
		{
			int unixTimeSinceEventStarted = ( unixTimeNow - unixTimeEventStart )
			int daysSinceEventStarted =  int( floor( unixTimeSinceEventStarted / SECONDS_PER_DAY ) )
			                                              
			characterLoadoutRefInt = ( ( characterLoadoutRefInt + daysSinceEventStarted ) % maxCharacterLoadouts )
		}
	}

	return characterLoadoutRefInt.tostring()
}

WeaponLoadout function ParseWeaponLoadoutText( string loadoutText, bool useDefaultLoadout )
{
	WeaponLoadout weaponLoadout
	array< string > weaponLoadoutArray = []
	if ( loadoutText != "" )
		weaponLoadoutArray = GetTrimmedSplitString( loadoutText, " " )
	else if ( useDefaultLoadout )
		weaponLoadoutArray = file.weaponLoadoutDefault
	foreach( weapon in weaponLoadoutArray )
	{
		array<string> weaponTokens = GetTrimmedSplitString( weapon, ":" )
		string weaponRef           = weaponTokens[0]
		weaponLoadout.weaponRefs.append( weaponRef )

		weaponTokens.remove( 0 )
		array<string> attachmentsToAdd = weaponTokens

		weaponLoadout.weaponAttachmentsByWeapon[weaponRef] <- attachmentsToAdd
	}

	return weaponLoadout
}

array< string > function ParseEquipmentLoadoutText( string loadoutText, bool useDefaultLoadout, array<string> displayIgnoredItems )
{
	array<string> equipmentToAdd = []
	if ( loadoutText != "" )
		equipmentToAdd = GetTrimmedSplitString( loadoutText, " " )
	else if ( useDefaultLoadout )
		equipmentToAdd = file.equipmentLoadoutDefault

	if ( GetCurrentPlaylistVarBool( "should_give_lvl0_evo_armor", true ) )
	{
		bool give0Armor = true
		foreach ( string equipmentRef in equipmentToAdd )
		{
			if ( SURVIVAL_Loot_GetLootDataByRef( equipmentRef ).lootType == eLootType.ARMOR )
			{
				give0Armor = false
				break
			}
		}
		if ( give0Armor )
		{
			equipmentToAdd.append( "armor_pickup_lv0_evolving" )
			displayIgnoredItems.append( "armor_pickup_lv0_evolving" )
		}
	}

	return equipmentToAdd
}

array< string > function ParseConsumableLoadoutText( string loadoutText, bool useDefaultLoadout )
{
	array<string> consumableTokens = []
	if ( loadoutText != "" )
		consumableTokens = GetTrimmedSplitString( loadoutText, " " )
	else if ( useDefaultLoadout )
		consumableTokens = file.consumableLoadoutDefault
	array<string> consumablesToAdd
	foreach( itemType in consumableTokens )
	{
		array<string> tokens = GetTrimmedSplitString( itemType, ":" )
		string itemRef       = tokens[0]
		int numItems         = int( tokens[1] )

		for ( int i = 0; i < numItems; i++ )
		{
			consumablesToAdd.append( itemRef )
		}
	}

	return consumablesToAdd
}

void function PopulateCharacterLoadouts()
{
	array<ItemFlavor> characterList = GetAllCharacters()
	bool useClassBasedLoadout = GetCurrentPlaylistVarBool( "character_loadouts_class_based", false )
	table <int, string> characterClassToWeaponLoadoutTable
	table <int, string> characterClassToConsumableLoadoutTable
	table <int, string> characterClassToEquipmentLoadoutTable
	if ( useClassBasedLoadout )
	{
		string prefixWeapons = "class_loadout_weapons_"
		string prefixConsumables = "class_loadout_consumables_"
		string prefixEquipment = "class_loadout_equipment_"
		foreach ( key, value in eCharacterClassRole )
		{
			string keyString = key.tolower()
			string plString = prefixWeapons + keyString
			characterClassToWeaponLoadoutTable[ value ] <- GetCurrentPlaylistVarString( plString, "" )
			plString = prefixConsumables + keyString
			characterClassToConsumableLoadoutTable[ value ] <- GetCurrentPlaylistVarString( plString, "" )
			plString = prefixEquipment + keyString
			characterClassToEquipmentLoadoutTable[ value ] <- GetCurrentPlaylistVarString( plString, "" )
		}
	}

	foreach( character in characterList )
	{
		string characterRef = ItemFlavor_GetHumanReadableRef( character ).tolower()
		string characterLoadoutRef = GetCharacterLoadoutRef( characterRef )
		printf( "CHARACTER LOADOUT: Populating info for characterRef " + characterRef + " with matching loadout ref " + characterLoadoutRef )
		string weaponLoadoutsPlaylist
		string consumableLoadoutPlaylist
		string equipmentLoadoutPlaylist
		                                  
		if ( !useClassBasedLoadout )
		{
			weaponLoadoutsPlaylist    = GetCurrentPlaylistVarString( "character_loadout_weapons_" + characterLoadoutRef, "" )
			consumableLoadoutPlaylist = GetCurrentPlaylistVarString( "character_loadout_consumables_" + characterLoadoutRef, "" )
			equipmentLoadoutPlaylist  = GetCurrentPlaylistVarString ( "character_loadout_equipment_" + characterLoadoutRef, "" )
		}
		else                                              
		{
			int role = CharacterClass_GetRole( character )

			Assert( role in characterClassToWeaponLoadoutTable, "Attempting to populate WeaponLoadoutsPlaylist using a Character Class that is not in characterClassToWeaponLoadoutTable" )
			Assert( role in characterClassToConsumableLoadoutTable, "Attempting to populate consumableLoadoutPlaylist using a Character Class that is not in characterClassToConsumableLoadoutTable" )
			Assert( role in characterClassToEquipmentLoadoutTable, "Attempting to populate equipmentLoadoutPlaylist using a Character Class that is not in characterClassToEquipmentLoadoutTable" )
			weaponLoadoutsPlaylist    = characterClassToWeaponLoadoutTable[ role ]
			consumableLoadoutPlaylist = characterClassToConsumableLoadoutTable[ role ]
			equipmentLoadoutPlaylist  = characterClassToEquipmentLoadoutTable[ role ]
		}

		bool useDefaultLoadout = GetCurrentPlaylistVarBool( "character_loadout_use_default", true )

		string displayIgnoreItemsRaw = GetCurrentPlaylistVarString ( "character_loadout_display_ignore_items", "" )
		array<string> displayIgnoredItems
		if ( displayIgnoreItemsRaw != "" )
			displayIgnoredItems = GetTrimmedSplitString( displayIgnoreItemsRaw, " " )
		else if ( !GetCurrentPlaylistVarBool( "character_loadout_ignore_default", false ) )
			displayIgnoredItems = file.loadoutDisplayIgnoreItemsDefault

		                         
		file.characterFlavorToEquipmentLoadout[characterRef] <- ParseEquipmentLoadoutText( equipmentLoadoutPlaylist, useDefaultLoadout, displayIgnoredItems )
		array<string> equipmentToDisplay = []
		foreach ( string equipment in file.characterFlavorToEquipmentLoadout[characterRef] )
		{
			if ( !displayIgnoredItems.contains( equipment ) )
				equipmentToDisplay.append( equipment )
		}
		file.characterFlavorToDisplayedEquipmentLoadout[characterRef] <- equipmentToDisplay

		                      
		file.characterFlavorToWeaponLoadout[characterRef] <- ParseWeaponLoadoutText( weaponLoadoutsPlaylist, useDefaultLoadout )
		array<string> weaponsToDisplay
		foreach( string weaponRef in file.characterFlavorToWeaponLoadout[characterRef].weaponRefs )
		{
			if ( !displayIgnoredItems.contains( weaponRef ) )
				weaponsToDisplay.append( weaponRef )
		}
		file.characterFlavorToDisplayedWeaponLoadout[characterRef] <- weaponsToDisplay


		                          
		file.characterFlavorToConsumableLoadout[characterRef] <- ParseConsumableLoadoutText( consumableLoadoutPlaylist, useDefaultLoadout )
		array<string> consumablesToDisplay
		foreach( itemRef in file.characterFlavorToConsumableLoadout[characterRef] )
		{
			if ( !displayIgnoredItems.contains( itemRef ) )
				consumablesToDisplay.append( itemRef )
		}

		file.characterFlavorToDisplayedConsumableLoadout[characterRef] <- consumablesToDisplay
	}

	printf( "CHARACTER LOADOUTS: Character Loadouts populated" )
}

#if CLIENT
void function Init_CharacterClassToLoadoutNameTable()
{
	string prefix = "#CHARACTER_CLASS_LOADOUT_"
	foreach ( key, value in eCharacterClassRole )
	{
		string loadoutName = prefix + key.toupper()
		file.characterClassToLoadoutNameTable[ value ] <- loadoutName
	}
}
#endif          

#if SERVER
                                                                      
 
	                                                                                     

	                                                                                                             
		      

	                                                                         
	 
		                                                                     
	 
 


                                                
 
	                                                                                     
	                                                                                                         
		      

	                                     
 

                                                          
 
	                        
	 
		                                                                                                                                     
	 
 
#endif


#if SERVER
                                                                                                                        
 
	                                                                                                 
	                                                                                                    

	                                                                                              
		      

	                                                                                        
	                                                                            

	                                                             
	 
		                                                                                                              
		      
	 

	                                                                                                                      
	                                                                                                              
	                                                                                                                

	                                                                                              
 
#endif

#if SERVER
                                                                                                                                                                
 
	                                   
	                                                                                                                                                                                            

	                                                       
	                                                                              
	                                            

	                                              
	                                                 

	                                                                    
	 
		                                                                                                                                                                            
		                                     
			                                                           
		                                           
			                                 
		      
	 

	                                                          
	 
		                                              

		                                                            
		                         

		                                                                                                        

		                                                           
		 
			                       
			                                                       
			                      

			                       
			                                   
			                           
			 
				                                       
					        

				                                                     
				                                                                                                                                       
					                                                                 
			 
			                        

			                      

			                                                                              
			 
				                                                                                           
			 
		 

		                                                                                        
		 
			                                                                         
			                                                 
		 
		    
		 
			                                
			 
				                                                                         
			 
			                                                 

			                                               
			                                                   
			                                                             
			                                                
			                                       
			                         
			                                                                                                    
			                                                         
			                                                             

			                                      
			                                      
				                              
			                                                     
		 

		                             
		                                                                            
		                                         
		                                         
		 
			                                                                                
		 
		    
		 
			                               
			 
				                                                                                                                          
			 
		 

		                                          
		                                            
		 
			                                                                                    
		 
		    
		 
			                               
			 
				                                                                                                                            
			 
		 

		                                                            
			                                                                    
	 
 
#endif

#if SERVER
                                                                                                                
 
	                                        
	 
		                                                                     
	 

	                                                                   
	                                          
	 
		                                                         
		                                                                                         
		                                                                                      

		                                                        
			                                                                                                   
	 
 
#endif

#if SERVER
                                                                                                                  
 
	                                          
	 
		                                                      

		                                                               
		                                                  
		                                                       
		 
			        
		 

		                                                            
		                                          
		 
			                                                               
		 
	 
 
#endif


#if CLIENT
void function Callback_OnCharacterSelectOpened()
{
	file.is16x10 = GetNearestAspectRatio( GetScreenSize().width, GetScreenSize().height ) == 1.6

	RuiSetBool( file.loadoutInfoRui, "isVisible", true )
	RuiSetBool( file.loadoutInfoRui, "is16x10", file.is16x10 )

	ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( GetLocalClientPlayer() ), Loadout_Character() )
	DisplayLoadoutForCharacter( character )
}

void function Callback_OnCharacterSelectClosed()
{
	RuiSetBool( file.loadoutInfoRui, "isVisible", false )

	foreach( ruiAsset in file.loadoutRuiElements )
	{
		RuiDestroy( ruiAsset )
	}
	file.loadoutRuiElements.clear()

}

void function Callback_OnCharacterFocusChanged( ItemFlavor character )
{
	DisplayLoadoutForCharacter( character )
}

void function Callback_OnCharacterLocked( ItemFlavor character )
{
	DisplayLoadoutForCharacter( character )
}

void function Callback_OnCharacterDetailsToggled( bool isDetailsPanelVisible )
{
	if ( file.loadoutInfoRui == null )
		return

	file.isDetailsPanelShowing = !isDetailsPanelVisible

	RuiSetBool( file.loadoutInfoRui, "isDetailMode", !isDetailsPanelVisible )
	foreach( rui in file.loadoutRuiElements )
	{
		RuiSetBool( rui, "isDetailMode", !isDetailsPanelVisible )
	}
}

string function GetIdenticalLoadoutCharSelectPrefix()
{
	string playlistName = GetCurrentPlaylistName()
	if ( playlistName.find( "freelance" ) >= 0 )
		return ""

	return Localize( "#DEFAULT_CHAR_SELECT_LOADOUT_PREFIX" )
}

void function DisplayLoadoutForCharacter( ItemFlavor character )
{
	string characterRef = ItemFlavor_GetHumanReadableRef( character ).tolower()

	                     
	foreach( ruiAsset in file.loadoutRuiElements )
	{
		RuiDestroy( ruiAsset )
	}
	file.loadoutRuiElements.clear()

	bool shouldShowLoadout = file.characterFlavorToDisplayedWeaponLoadout[characterRef].len() > 0 ||
	file.characterFlavorToDisplayedConsumableLoadout[characterRef].len() > 0 ||
	file.characterFlavorToDisplayedEquipmentLoadout[characterRef].len() > 0

	                                                    
	if ( !shouldShowLoadout )
	{
		RuiSetBool( file.loadoutInfoRui, "isVisible", false )
		return
	}
	else
	{
		RuiSetBool( file.loadoutInfoRui, "isVisible", true )
	}

	if ( GetCurrentPlaylistVarBool( "character_loadouts_identical", false ) )
	{
		RuiSetString( file.loadoutInfoRui, "characterLoadoutName", GetIdenticalLoadoutCharSelectPrefix() )
	}
	else if ( GetCurrentPlaylistVarBool( "character_loadouts_class_based", false ) )
	{
		int role = CharacterClass_GetRole( character )
		Assert( role in file.characterClassToLoadoutNameTable[ role ], "Attempting to DisplayLoadoutForCharacter using a Character Class that is not in characterClassToLoadoutNameTable" )
		RuiSetString( file.loadoutInfoRui, "characterLoadoutName", Localize( file.characterClassToLoadoutNameTable[ role ] ) )
	}
	else
	{
		RuiSetString( file.loadoutInfoRui, "characterLoadoutName", Localize( "#" + characterRef + "_NAME" ) )
	}

	                           
	for ( int i = 0; i < file.characterFlavorToDisplayedWeaponLoadout[characterRef].len(); i++ )
	{
		string weaponRef    = file.characterFlavorToDisplayedWeaponLoadout[characterRef][i]
		LootData weaponData = SURVIVAL_Loot_GetLootDataByRef( weaponRef )
		var weaponRuiAsset  = RuiCreate( $"ui/loadout_selection_icon_weapon.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 1 )

		RuiSetBool( weaponRuiAsset, "isDetailMode", file.isDetailsPanelShowing )
		RuiSetAsset( weaponRuiAsset, "iconImage", weaponData.hudIcon )
		RuiSetInt( weaponRuiAsset, "weaponIndex", i )
		if ( ShouldShrinkWeaponIcon( weaponRef ) )
			RuiSetFloat2( weaponRuiAsset, "iconSize", <150, 75, 0.0> )

		string ammoRef = GetWeaponAmmoType( weaponRef )
		if ( ammoRef != "" )
		{
			                                   
			LootData ammoData = SURVIVAL_Loot_GetLootDataByRef( ammoRef )
			RuiSetAsset( weaponRuiAsset, "ammoImage", ammoData.hudIcon )
		}

		RuiSetString( weaponRuiAsset, "weaponName", Localize( "#WPN_" + weaponData.baseWeapon.slice(10) + "_SHORT" ) )

		file.loadoutRuiElements.append( weaponRuiAsset )

		                                 
		array<string> attachmentRefs
		if( !SURVIVAL_Weapon_IsAttachmentLocked ( weaponRef ) )
		{
			attachmentRefs = file.characterFlavorToWeaponLoadout[characterRef].weaponAttachmentsByWeapon[weaponRef]
		}
		else
		{
			attachmentRefs = SURVIVAL_Weapon_GetBaseMods( weaponRef )
		}
		int attachmentSlot = 0
		for ( int j = 0; j < attachmentRefs.len(); j++ )
		{
			if ( !SURVIVAL_Loot_IsRefValid( attachmentRefs[j] ) )
				continue
			LootData attachmentData = SURVIVAL_Loot_GetLootDataByRef( attachmentRefs[j] )
			var attachmentRuiAsset  = RuiCreate( $"ui/loadout_selection_icon_attachment.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 1 )

			RuiSetBool( attachmentRuiAsset, "isDetailMode", file.isDetailsPanelShowing )
			RuiSetAsset( attachmentRuiAsset, "iconImage", attachmentData.hudIcon )
			RuiSetInt( attachmentRuiAsset, "attachmentIndex", attachmentSlot )
			RuiSetInt( attachmentRuiAsset, "weaponIndex", i )
			RuiSetInt( attachmentRuiAsset, "lootTier", attachmentData.tier )

			attachmentSlot++

			file.loadoutRuiElements.append( attachmentRuiAsset )
		}
	}

	                    
	for ( int i = 0; i < file.characterFlavorToDisplayedEquipmentLoadout[characterRef].len(); i++ )
	{
		string equipmentRef    = file.characterFlavorToDisplayedEquipmentLoadout[characterRef][i]
		LootData equipmentData = SURVIVAL_Loot_GetLootDataByRef( equipmentRef )
		var equipmentRuiAsset  = RuiCreate( $"ui/loadout_selection_icon_equipment.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 1 )

		RuiSetBool( equipmentRuiAsset, "isDetailMode", file.isDetailsPanelShowing )
		RuiSetAsset( equipmentRuiAsset, "iconImage", equipmentData.hudIcon )
		RuiSetInt( equipmentRuiAsset, "lootTier", equipmentData.tier )
		RuiSetInt( equipmentRuiAsset, "equipmentIndex", i )

		file.loadoutRuiElements.append( equipmentRuiAsset )
	}

	                      
	table<string, int> trackedConsumableCount
	table<string, var> trackConsumableRuiAssets
	int consumableCounter = 0
	int equipmentIndex = -1
	for ( int i = 0; i < file.characterFlavorToDisplayedConsumableLoadout[characterRef].len(); i++ )
	{
		string consumableRef    = file.characterFlavorToDisplayedConsumableLoadout[characterRef][i]

		if ( consumableRef in trackedConsumableCount )
		{
			trackedConsumableCount[consumableRef]++
			RuiSetInt( trackConsumableRuiAssets[consumableRef], "itemCount", trackedConsumableCount[consumableRef] )
		}
		else
		{
			LootData consumableData = SURVIVAL_Loot_GetLootDataByRef( consumableRef )
			var consumableRuiAsset  = RuiCreate( $"ui/loadout_selection_icon_equipment.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 1 )
			if ( equipmentIndex == -1 )
				equipmentIndex = i
			else
				equipmentIndex++
			RuiSetBool( consumableRuiAsset, "isDetailMode", file.isDetailsPanelShowing )
			RuiSetAsset( consumableRuiAsset, "iconImage", consumableData.hudIcon )
			RuiSetInt( consumableRuiAsset, "lootTier", consumableData.tier )
			RuiSetInt( consumableRuiAsset, "equipmentIndex", equipmentIndex )
			RuiSetBool( consumableRuiAsset, "isConsumable", true )

			trackedConsumableCount[consumableRef] <- 1
			trackConsumableRuiAssets[consumableRef] <- consumableRuiAsset

			file.loadoutRuiElements.append( consumableRuiAsset )
			consumableCounter++
		}
	}

	foreach( ruiAsset in file.loadoutRuiElements )
		RuiSetBool( ruiAsset, "is16x10", file.is16x10 )

}

bool function ShouldShrinkWeaponIcon( string weaponRef )
{
	                                          
		             

	return false
}
#endif



array<string> function CharacterLoadouts_GetWeaponLoadoutArray( ItemFlavor character )
{
	return file.characterFlavorToWeaponLoadout[ItemFlavor_GetHumanReadableRef( character ).tolower()].weaponRefs
}

array<string> function CharacterLoadouts_GetConsumableLoadoutArray( ItemFlavor character )
{
	return file.characterFlavorToConsumableLoadout[ItemFlavor_GetHumanReadableRef( character ).tolower()]
}

array<string> function CharacterLoadouts_GetEquipmentLoadoutArray( ItemFlavor character )
{
	return file.characterFlavorToEquipmentLoadout[ItemFlavor_GetHumanReadableRef( character ).tolower()]
}
