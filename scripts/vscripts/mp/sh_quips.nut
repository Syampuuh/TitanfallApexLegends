global function ShQuips_LevelInit
global function RegisterEquippableQuipsForCharacter

global function CharacterQuip_IsTheEmpty

global function CharacterQuip_GetAnim3p
global function CharacterQuip_GetAnimLoop3p
global function CharacterQuip_GetCameraHeightOffset

global function CharacterQuip_UseHoloProjector
global function CharacterQuip_GetModelAsset
global function CharacterQuip_GetUseEffectColor2
global function CharacterQuip_GetEffectColor1
global function CharacterQuip_GetEffectColor2

#if CLIENT
global function PerformQuip
global function CharacterQuip_ShortenTextForCommsMenu
#endif

#if SERVER
                             
                                            
                                                   
#endif

#if CLIENT || UI
global function CreateNestedRuiForQuip
global function EmoteIcon_PopulateNestedRui
global function ItemFlavor_GetQuipArrayForCharacter
global function ItemFlavor_GetFavoredQuipArrayForCharacter
#endif

global function CharacterQuip_GetCharacterFlavor
global function CharacterQuip_GetAliasSubName
global function Loadout_CharacterQuip
global function Loadout_FavoredQuip
global function Loadout_FavoredQuipArrayForCharacter
global function Loadout_IsCharacterQuipLoadoutEntry
global function ItemFlavor_CanEquipToWheel

#if SERVER
                                     
#endif

global const int MAX_QUIPS_EQUIPPED = 8
global const int MAX_FAVORED_QUIPS = 4

const string  QUIP_LOADOUT_CATEGORY_NAME = "character_quips"

struct FileStruct_LifetimeLevel
{
	table<ItemFlavor, array<LoadoutEntry> >     loadoutCharacterQuipsSlotListMap
	table<ItemFlavor, array<LoadoutEntry> >	    loadoutCharacterFavoredQuipMap

	array<ItemFlavor> universalQuips
}
FileStruct_LifetimeLevel& fileLevel


void function ShQuips_LevelInit()
{
	FileStruct_LifetimeLevel newFileLevel
	fileLevel = newFileLevel
}

void function RegisterEquippableQuipsForCharacter( ItemFlavor characterClass, array<ItemFlavor> quipList, array<ItemFlavor> characterEmotesList )
{
	foreach( int index, ItemFlavor quip in quipList )
	{
		if ( GetGlobalSettingsAsset( ItemFlavor_GetAsset( quip ), "parentItemFlavor" ) == "" )
		{
			fileLevel.universalQuips.append( quip )
		}

		#if CLIENT || SERVER
		if ( CharacterQuip_UseHoloProjector( quip ) )
		{
			PrecacheModel( CharacterQuip_GetModelAsset( quip ) )
		}
		#endif
	}

	fileLevel.loadoutCharacterQuipsSlotListMap[characterClass] <- []

	for ( int quipIndex = 0; quipIndex < MAX_QUIPS_EQUIPPED; quipIndex++ )
	{
		LoadoutEntry entry = RegisterLoadoutSlot( eLoadoutEntryType.ITEM_FLAVOR, "quips_" + quipIndex + "_for_" + ItemFlavor_GetGUIDString( characterClass ) )
		entry.pdefSectionKey = "character " + ItemFlavor_GetGUIDString( characterClass )
		entry.DEV_category = QUIP_LOADOUT_CATEGORY_NAME
		entry.DEV_name = ItemFlavor_GetHumanReadableRef( characterClass ) + " Quip " + quipIndex
		entry.validItemFlavorList = quipList
		entry.defaultItemFlavor = (quipIndex == 0 && characterEmotesList.len() > 0) ? characterEmotesList[0] : entry.validItemFlavorList[0]
		entry.isSlotLocked = bool function( EHI playerEHI ) {
			return !IsLobby()
		}

		#if SERVER
			                                                                                                   
			 
				                                                                                                                                        
				 

					                           
					                                                                                  

					                           
							                          
					 

					                                      
					 
						                                                                                                                                               
						 
							                                                                          
							 
								                               
							 
						 
					 

					                                       

					                                  
					 
						                             
					 

					               
				 
			 
		#endif

		entry.isActiveConditions = { [Loadout_Character()] = { [characterClass] = true, }, }
		entry.networkTo = eLoadoutNetworking.PLAYER_EXCLUSIVE
		                                                   
		fileLevel.loadoutCharacterQuipsSlotListMap[characterClass].append( entry )
	}

	fileLevel.loadoutCharacterFavoredQuipMap[characterClass] <- []

	for ( int favQuipIndex = 0; favQuipIndex < MAX_FAVORED_QUIPS; favQuipIndex++ )
	{
		LoadoutEntry entry = RegisterLoadoutSlot( eLoadoutEntryType.ITEM_FLAVOR, "favoredQuip_" + favQuipIndex + "_for_" + ItemFlavor_GetGUIDString( characterClass ) )
		entry.pdefSectionKey = "character " + ItemFlavor_GetGUIDString( characterClass )
		entry.DEV_category = "character_favored_quips"
		entry.DEV_name = ItemFlavor_GetHumanReadableRef( characterClass ) + " Favored Quip " + favQuipIndex
		entry.validItemFlavorList = quipList
		entry.defaultItemFlavor = entry.validItemFlavorList[0]
		entry.isSlotLocked = bool function( EHI playerEHI ) {
			return !IsLobby()
		}

		entry.isActiveConditions = { [Loadout_Character()] = { [characterClass] = true, }, }
		entry.networkTo = eLoadoutNetworking.PLAYER_EXCLUSIVE
		fileLevel.loadoutCharacterFavoredQuipMap[characterClass].append( entry )
	}
}


#if CLIENT
void function PerformQuip( entity player, int index )
{
	if ( !IsAlive( player ) )
		return

	ItemFlavor quip      = GetItemFlavorByGUID( index )

	CommsAction act
	act.index = eCommsAction.QUIP
	act.aliasSubname = CharacterQuip_GetAliasSubName( quip )
	act.hasCalm = false
	act.hasCalmFar = false
	act.hasUrgent = false
	act.hasUrgentFar = false

	CommsOptions opt
	opt.isFirstPerson = (player == GetLocalViewPlayer())
	opt.isFar = false
	opt.isUrgent = false
	opt.pauseQueue = player.GetTeam() == GetLocalViewPlayer().GetTeam()

	PlaySoundForCommsAction( player, null, act, opt )
}
#endif



#if SERVER || CLIENT || UI
LoadoutEntry function Loadout_CharacterQuip( ItemFlavor characterClass, int badgeIndex )
{
	return fileLevel.loadoutCharacterQuipsSlotListMap[characterClass][badgeIndex]
}

LoadoutEntry function Loadout_FavoredQuip( ItemFlavor characterClass, int badgeIndex )
{
	return fileLevel.loadoutCharacterFavoredQuipMap[characterClass][badgeIndex]
}

array<LoadoutEntry> function Loadout_QuipArrayForCharacter( ItemFlavor characterClass )
{
	return fileLevel.loadoutCharacterQuipsSlotListMap[characterClass]
}

array<LoadoutEntry> function Loadout_FavoredQuipArrayForCharacter( ItemFlavor characterClass )
{
	return fileLevel.loadoutCharacterFavoredQuipMap[characterClass]
}

bool function Loadout_IsCharacterQuipLoadoutEntry( LoadoutEntry entry )
{
	return entry.DEV_category == QUIP_LOADOUT_CATEGORY_NAME
}

string function CharacterQuip_GetAliasSubName( ItemFlavor flavor )
{
	AssertEmoteIsValid( flavor )

	return GetGlobalSettingsString( ItemFlavor_GetAsset( flavor ), "quickchatAliasSubName" )
}

bool function CharacterQuip_IsTheEmpty( ItemFlavor flavor )
{
	AssertEmoteIsValid( flavor )

	return ( GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "isTheEmpty" ) )
}

#if CLIENT || UI
array<ItemFlavor> function ItemFlavor_GetQuipArrayForCharacter( ItemFlavor characterClass, bool characterEmotesOnly = false )
{
	array<ItemFlavor> quips = []

	EHI playerEHI = LocalClientEHI()

	foreach ( LoadoutEntry entry in Loadout_QuipArrayForCharacter( characterClass ) )
	{
		ItemFlavor flav = LoadoutSlot_GetItemFlavor( playerEHI, entry )

		if ( characterEmotesOnly && ItemFlavor_GetType( flav ) != eItemType.character_emote )
			continue

		if ( ! CharacterQuip_IsTheEmpty( flav ) )
			quips.append( flav )
	}

	return quips
}
#endif                

#if CLIENT || UI
array<ItemFlavor> function ItemFlavor_GetFavoredQuipArrayForCharacter( ItemFlavor characterClass, bool characterEmotesOnly = false )
{
	array<ItemFlavor> favoredQuips = []

	EHI playerEHI = LocalClientEHI()

	foreach ( LoadoutEntry entry in Loadout_FavoredQuipArrayForCharacter( characterClass ) )
	{
		ItemFlavor flav = LoadoutSlot_GetItemFlavor( playerEHI, entry )

		if ( characterEmotesOnly && ItemFlavor_GetType( flav ) != eItemType.character_emote )
			continue

		if ( ! CharacterQuip_IsTheEmpty( flav ) )
			favoredQuips.append( flav )
	}

	return favoredQuips
}
#endif                

string function CharacterQuip_GetAnim3p( ItemFlavor flavor )
{
	AssertEmoteIsValid( flavor )

	return GetGlobalSettingsString( ItemFlavor_GetAsset( flavor ), "anim3p" )
}

string function CharacterQuip_GetAnimLoop3p( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.character_emote )

	return GetGlobalSettingsString( ItemFlavor_GetAsset( flavor ), "anim3pLoop" )
}

float function CharacterQuip_GetCameraHeightOffset( ItemFlavor flavor )
{
	Assert ( ItemFlavor_GetType( flavor ) == eItemType.character_emote )

	return GetGlobalSettingsFloat( ItemFlavor_GetAsset( flavor), "cameraHeightOffset" )
}

bool function CharacterQuip_UseHoloProjector( ItemFlavor flavor )
{
	AssertEmoteIsValid( flavor )

	return ( GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "useHoloProjector" ) )
}

void function AssertEmoteIsValid( ItemFlavor flavor )
{
	array<int> allowedList = [
		eItemType.gladiator_card_kill_quip,
		eItemType.gladiator_card_intro_quip,
		eItemType.emote_icon,
		eItemType.character_emote,
	]

	Assert( allowedList.contains( ItemFlavor_GetType( flavor ) ) )
}
#endif                          


#if SERVER
                                                                    
 
	                                           
 

                                                                            
 
	                                                  
 

                                                              
 
	                         
		      

	                                  
		      

	                               
	                                                                                      
	                                                                                                            

	                             
 

                                                                     
 
	                         
		      

	                                 
		      

	                               
	                                                                                      
	                                                                                                          

	                             
 

                                                             
 
	                         
		      

	                               
	                                                                                      

	                                         

	                   
		      

	                                                                  
		                                         

	                                              
		      

	                                             
	 
		                                             
	 

	                                                                
	                                                  
	 
		                                       
		 
			                                                                                                                 
			 
				                                                          
				                                                                
			 
		 
	 
 
#endif

bool function ItemFlavor_CanEquipToWheel( ItemFlavor item )
{
	switch ( ItemFlavor_GetType( item ) )
	{
		case eItemType.gladiator_card_kill_quip:
		case eItemType.gladiator_card_intro_quip:
		case eItemType.emote_icon:
		case eItemType.character_emote:
		case eItemType.skydive_emote:
			return true
	}

	return false
}

#if CLIENT || UI
string function CharacterQuip_ShortenTextForCommsMenu( ItemFlavor flav )
{
	string txt = ""

	int itemType = ItemFlavor_GetType( flav )
	if ( itemType == eItemType.gladiator_card_kill_quip || itemType == eItemType.gladiator_card_intro_quip )
	{
		txt = Localize( ItemFlavor_GetLongName( flav ) )

		int WORD_MAX_LEN = 11
		int TEXT_MAX_LEN = 26
		int TEXT_MAX_LEN_W_DOTS = TEXT_MAX_LEN - 2
#if CLIENT
		txt = CondenseText( txt, WORD_MAX_LEN, TEXT_MAX_LEN )
#endif
	}
	return txt
}


var function CreateNestedRuiForQuip( var baseRui, string argName, ItemFlavor quip )
{
	int itemType = ItemFlavor_GetType( quip )

	switch ( itemType )
	{
		case eItemType.emote_icon:
			var rui = RuiCreateNested( baseRui, argName, $"ui/comms_menu_icon_projector.rpak" )
			EmoteIcon_PopulateNestedRui( rui, quip, null )
			return rui
	}

	var nestedRui = RuiCreateNested( baseRui, argName, $"ui/comms_menu_icon_default.rpak" )
	RuiSetImage( nestedRui, "icon", ItemFlavor_GetIcon( quip ) )
	RuiSetBool( nestedRui, "centerTextUseTierColor", itemType == eItemType.gladiator_card_intro_quip || itemType == eItemType.gladiator_card_kill_quip )
	RuiSetInt( nestedRui, "tier", ItemFlavor_GetQuality( quip, 0 ) + 1 )
	RuiSetString( nestedRui, "centerText", CharacterQuip_ShortenTextForCommsMenu( quip ) )

	return nestedRui
}


void function EmoteIcon_PopulateNestedRui( var rui, ItemFlavor item, int ornull overrideDataInt )
{
	asset ruiAsset = $"ui/basic_image.rpak"
	var nested = RuiCreateNested( rui, "ruiHandle", ruiAsset )
	asset icon = ItemFlavor_GetIcon( item )

	RuiSetInt( rui, "tier", ItemFlavor_GetQuality( item, 0 ) + 1 )
	RuiSetImage( nested, "basicImage", icon )
}
#endif                


asset function CharacterQuip_GetModelAsset( ItemFlavor item )
{
	Assert( ItemFlavor_GetType( item ) == eItemType.emote_icon )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( item ), "holoProjectorSprayModel" )
}

bool function CharacterQuip_GetUseEffectColor2( ItemFlavor item )
{
	Assert( ItemFlavor_GetType( item ) == eItemType.emote_icon )
	return GetGlobalSettingsBool( ItemFlavor_GetAsset( item ), "holoProjectorUseEffectColor2" )
}

vector function CharacterQuip_GetEffectColor1( ItemFlavor item )
{
	Assert( ItemFlavor_GetType( item ) == eItemType.emote_icon )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( item ), "holoProjectorEffectColor1" )
}

vector function CharacterQuip_GetEffectColor2( ItemFlavor item )
{
	Assert( ItemFlavor_GetType( item ) == eItemType.emote_icon )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( item ), "holoProjectorEffectColor2" )
}


ItemFlavor ornull function CharacterQuip_GetCharacterFlavor( ItemFlavor item )
{
	if ( fileLevel.universalQuips.contains( item ) )
		return null

	Assert( GetGlobalSettingsAsset( ItemFlavor_GetAsset( item ), "parentItemFlavor" ) != "" )

	return GetItemFlavorByAsset( GetGlobalSettingsAsset( ItemFlavor_GetAsset( item ), "parentItemFlavor" ) )
}