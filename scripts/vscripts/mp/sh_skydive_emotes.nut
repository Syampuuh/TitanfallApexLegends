global function ShSkydiveEmotes_LevelInit

global function RegisterSkydiveEmotesForCharacter
global function Loadout_SkydiveEmote
global function GetValidPlayerSkydiveEmotes
global function GetPlayerSkydiveEmote

#if SERVER
                                                             
#endif

global function SkydiveEmote_IsTheEmpty
global function SkydiveEmote_GetCharacterFlavor
global function SkydiveEmote_GetAnimSeq
global function SkydiveEmote_GetVideo
global function SkydiveEmote_GetBcEvent
global function SkydiveEmote_GetSortOrdinal

#if CLIENT || UI
global function CreateNestedRuiForSkydiveEmote
#endif

global const int NUM_SKYDIVE_EMOTE_SLOTS = 8

struct FileStruct_LifetimeLevel
{
	table<ItemFlavor, array<LoadoutEntry> >     loadoutCharacterSkydiveEmoteSlotMap
	table<ItemFlavor, int>                      skydiveEmoteSortOrdinalMap
}
FileStruct_LifetimeLevel& fileLevel


void function ShSkydiveEmotes_LevelInit()
{
	FileStruct_LifetimeLevel newFileLevel
	fileLevel = newFileLevel

	#if SERVER
	                                                                        
	 
		                                                                                       
	 
	#endif
}


void function RegisterSkydiveEmotesForCharacter( ItemFlavor characterClass )
{
	array<ItemFlavor> skydiveEmotesList = RegisterReferencedItemFlavorsFromArray( characterClass, "skydiveEmotes", "flavor" )
	MakeItemFlavorSet( skydiveEmotesList, fileLevel.skydiveEmoteSortOrdinalMap )

	fileLevel.loadoutCharacterSkydiveEmoteSlotMap[characterClass] <- []

	for ( int i = 0; i < NUM_SKYDIVE_EMOTE_SLOTS; i++ )
	{
		LoadoutEntry entry = RegisterLoadoutSlot( eLoadoutEntryType.ITEM_FLAVOR, "character_skydive_emote_" + i + "_for_" + ItemFlavor_GetGUIDString( characterClass ) )
		entry.pdefSectionKey = "character " + ItemFlavor_GetGUIDString( characterClass )
		entry.DEV_category = "character_skydive_emotes"
		entry.DEV_name = ItemFlavor_GetHumanReadableRef( characterClass ) + " Skydive Emote " + i
		entry.defaultItemFlavor = skydiveEmotesList[0]
		entry.validItemFlavorList = skydiveEmotesList
		entry.isSlotLocked = bool function( EHI playerEHI ) {
			return !IsLobby()
		}
		            
		  	                                                                                                                                           
		  		                 
		  		 
		  			                                            
		  			                                                     
		  				                                                                                                                 
		  					                                         
		  
		  			                                      
		  				                                 
		  
		  			                           
		  		 
		  
		  		               
		  	 
		        
		entry.isActiveConditions = { [Loadout_Character()] = { [characterClass] = true, }, }
		entry.networkTo = eLoadoutNetworking.PLAYER_EXCLUSIVE
		fileLevel.loadoutCharacterSkydiveEmoteSlotMap[characterClass].append( entry )
	}
}


LoadoutEntry function Loadout_SkydiveEmote( ItemFlavor characterClass, int index )
{
	return fileLevel.loadoutCharacterSkydiveEmoteSlotMap[characterClass][ index ]
}


table<int, ItemFlavor> function GetValidPlayerSkydiveEmotes( entity player )
{
	table<int, ItemFlavor> emotes
	for ( int i = 0; i < NUM_SKYDIVE_EMOTE_SLOTS; i++ )
	{
		ItemFlavor flav = GetPlayerSkydiveEmote( player, i )
		if ( !SkydiveEmote_IsTheEmpty( flav ) )
			emotes[i] <- flav
	}

	return emotes
}


ItemFlavor function GetPlayerSkydiveEmote( entity player, int index )
{
	EHI playerEHI              = ToEHI( player )
	LoadoutEntry characterSlot = Loadout_Character()

	if ( LoadoutSlot_IsReady( playerEHI, characterSlot ) )
	{
		ItemFlavor character          = LoadoutSlot_GetItemFlavor( playerEHI, characterSlot )
		LoadoutEntry skydiveEmoteSlot = Loadout_SkydiveEmote( character, index )

		if ( LoadoutSlot_IsReady( playerEHI, skydiveEmoteSlot ) )
			return LoadoutSlot_GetItemFlavor( playerEHI, skydiveEmoteSlot )
	}

	return GetItemFlavorByAsset( $"settings/itemflav/skydive_emote/_empty.rpak" )
}


bool function SkydiveEmote_IsTheEmpty( ItemFlavor item )
{
	Assert( ItemFlavor_GetType( item ) == eItemType.skydive_emote )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( item ), "isTheEmpty" )
}


ItemFlavor function SkydiveEmote_GetCharacterFlavor( ItemFlavor item )
{
	Assert( ItemFlavor_GetType( item ) == eItemType.skydive_emote )
	Assert( GetGlobalSettingsAsset( ItemFlavor_GetAsset( item ), "parentItemFlavor" ) != "" )

	return GetItemFlavorByAsset( GetGlobalSettingsAsset( ItemFlavor_GetAsset( item ), "parentItemFlavor" ) )
}


asset function SkydiveEmote_GetAnimSeq( ItemFlavor item )
{
	Assert( ItemFlavor_GetType( item ) == eItemType.skydive_emote )

	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( item ), "animSequence" )
}


asset function SkydiveEmote_GetVideo( ItemFlavor item )
{
	Assert( ItemFlavor_GetType( item ) == eItemType.skydive_emote )

	return GetGlobalSettingsStringAsAsset( ItemFlavor_GetAsset( item ), "video" )
}


string function SkydiveEmote_GetBcEvent( ItemFlavor item )
{
	Assert( ItemFlavor_GetType( item ) == eItemType.skydive_emote )

	return GetGlobalSettingsString( ItemFlavor_GetAsset( item ), "bcEvent" )
}


int function SkydiveEmote_GetSortOrdinal( ItemFlavor item )
{
	Assert( ItemFlavor_GetType( item ) == eItemType.skydive_emote )

	return fileLevel.skydiveEmoteSortOrdinalMap[item]
}

#if SERVER
                                                                            
 
	                                     
	 
		                                     
		                                                          
		                                                                                          
	 
 
#endif


#if CLIENT || UI
var function CreateNestedRuiForSkydiveEmote( var baseRui, string argName, ItemFlavor item )
{
	var nestedRui = RuiCreateNested( baseRui, argName, $"ui/comms_menu_icon_default.rpak" )

	RuiSetImage( nestedRui, "icon", ItemFlavor_GetIcon( item ) )
	RuiSetBool( nestedRui, "showBackground", false )

	return nestedRui
}
#endif                