  

#if SERVER || CLIENT || UI
global function ThemedShopEvents_Init
#endif


#if SERVER || CLIENT || UI
global function GetActiveThemedShopEvent
global function ThemedShopEvent_GetChallenges
global function ThemedShopEvent_GetHeaderIcon
global function ThemedShopEvent_HasWhatsNew
global function ThemedShopEvent_GetAssociatedPack
global function ThemedShopEvent_HasThemedShopTab
global function ThemedShopEvent_HasSpecialsTab
#endif

#if UI
global function ThemedShopEvent_GetTabText
global function ThemedShopEvent_GetGRXOfferLocation
global function ThemedShopEvent_GetTabBGDefaultCol
global function ThemedShopEvent_GetTabBarDefaultCol
global function ThemedShopEvent_GetTabBGFocusedCol
global function ThemedShopEvent_GetTabBarFocusedCol
global function ThemedShopEvent_GetTabBGSelectedCol
global function ThemedShopEvent_GetTabBarSelectedCol
global function ThemedShopEvent_GetItemButtonBGImage
global function ThemedShopEvent_GetItemGroupHeaderImage
global function ThemedShopEvent_GetItemGroupHeaderText
global function ThemedShopEvent_GetItemGroupHeaderTextColor
global function ThemedShopEvent_GetItemGroupBackgroundImage
global function ThemedShopEvent_GetSubtitleTextColor
global function ThemedShopEvent_GetLobbyButtonImage
global function ThemedShopEvent_GetTitleTextColor
global function ThemedShopEvent_HasLobbyTheme
global function ThemedShopEvent_GetPackOffer
global function ThemedShopEvent_GetAboutText
global function ThemedShopEvent_GetAboutPageSpecialTextColor
#endif


                      
                      
                      
                      
                      



                       
                       
                       
                       
                       

#if SERVER || CLIENT || UI
struct FileStruct_LifetimeLevel
{
	table<ItemFlavor, array<ItemFlavor> > eventChallengesMap
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
void function ThemedShopEvents_Init()
{
	#if UI
		FileStruct_LifetimeLevel newFileLevel
		fileLevel = newFileLevel
	#endif

	AddCallback_OnItemFlavorRegistered( eItemType.calevent_themedshop, void function( ItemFlavor ev ) {
		fileLevel.eventChallengesMap[ev] <- RegisterReferencedItemFlavorsFromArray( ev, "challenges", "flavor" )
		foreach ( int challengeSortOrdinal, ItemFlavor challengeFlav in fileLevel.eventChallengesMap[ev] )
			RegisterChallengeSource( challengeFlav, ev, challengeSortOrdinal )
	} )
}
#endif



                          
                          
                          
                          
                          

#if SERVER || CLIENT || UI
ItemFlavor ornull function GetActiveThemedShopEvent( int t )
{
	Assert( IsItemFlavorRegistrationFinished() )
	ItemFlavor ornull event = null
	foreach ( ItemFlavor ev in GetAllItemFlavorsOfType( eItemType.calevent_themedshop ) )
	{
		if ( !CalEvent_IsActive( ev, t ) )
			continue

		Assert( event == null, format( "Multiple themedshop events are active!! (%s, %s)", ItemFlavor_GetHumanReadableRef( expect ItemFlavor(event) ), ItemFlavor_GetHumanReadableRef( ev ) ) )
		event = ev
	}
	return event
}
#endif


#if SERVER || CLIENT || UI
array<ItemFlavor> function ThemedShopEvent_GetChallenges( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )

	return fileLevel.eventChallengesMap[event]
}
#endif


#if UI
string function ThemedShopEvent_GetTabText( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsString( ItemFlavor_GetAsset( event ), "tabText" )
}
#endif


#if UI
string function ThemedShopEvent_GetGRXOfferLocation( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsString( ItemFlavor_GetAsset( event ), "grxOfferLocation" )
}
#endif


#if UI
vector function ThemedShopEvent_GetTabBGDefaultCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "tabBGDefaultCol" )
}
#endif


#if UI
vector function ThemedShopEvent_GetTabBarDefaultCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "tabBarDefaultCol" )
}
#endif


#if UI
vector function ThemedShopEvent_GetTabBGFocusedCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "tabBGFocusedCol" )
}
#endif


#if UI
vector function ThemedShopEvent_GetTabBarFocusedCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "tabBarFocusedCol" )
}
#endif


#if UI
vector function ThemedShopEvent_GetTabBGSelectedCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "tabBGSelectedCol" )
}
#endif


#if UI
vector function ThemedShopEvent_GetTabBarSelectedCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "tabBarSelectedCol" )
}
#endif


#if UI
asset function ThemedShopEvent_GetItemButtonBGImage( ItemFlavor event, bool isHighlighted )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), isHighlighted ? "itemBtnHighlightedBGImage" : "itemBtnRegularBGImage" )
}
#endif


#if UI
asset function ThemedShopEvent_GetItemGroupHeaderImage( ItemFlavor event, int group )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "itemGroup" + string( group ) + "HeaderImage" )
}
#endif


#if UI
string function ThemedShopEvent_GetItemGroupHeaderText( ItemFlavor event, int group )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsString( ItemFlavor_GetAsset( event ), "itemGroup" + string( group ) + "HeaderText" )
}
#endif

#if UI
array<string> function ThemedShopEvent_GetAboutText( ItemFlavor event, bool restricted )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )

	array<string> aboutText = []
	string key = (restricted ? "aboutTextRestricted" : "aboutTextStandard")
	foreach ( var aboutBlock in IterateSettingsAssetArray( ItemFlavor_GetAsset( event ), key ) )
		aboutText.append( GetSettingsBlockString( aboutBlock, "text" ) )
	return aboutText
}
#endif

#if UI
vector function ThemedShopEvent_GetItemGroupHeaderTextColor( ItemFlavor event, int group )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "itemGroup" + string( group ) + "HeaderTextColor" )
}
#endif


#if UI
asset function ThemedShopEvent_GetItemGroupBackgroundImage( ItemFlavor event, int group )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "itemGroup" + string( group ) + "BGImage" )
}
#endif


#if UI
bool function ThemedShopEvent_HasLobbyTheme( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsBool( ItemFlavor_GetAsset( event ), "themeLobby" )
}
#endif

#if SERVER || CLIENT || UI
bool function ThemedShopEvent_HasWhatsNew( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsBool( ItemFlavor_GetAsset( event ), "whatsNewTab" )
}
#endif

#if SERVER || CLIENT || UI
asset function ThemedShopEvent_GetAssociatedPack( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "associatedPackFlav" )
}
#endif

#if SERVER || CLIENT || UI
bool function ThemedShopEvent_HasThemedShopTab( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsBool( ItemFlavor_GetAsset( event ), "themedShopTab" )
}
#endif

#if SERVER || CLIENT || UI
bool function ThemedShopEvent_HasSpecialsTab( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsBool( ItemFlavor_GetAsset( event ), "specialsTab" )
}
#endif

#if UI
asset function ThemedShopEvent_GetLobbyButtonImage( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "lobbyButtonImage" )
}
#endif


#if UI
vector function ThemedShopEvent_GetTitleTextColor( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "seasonTitleColor" )
}
#endif


#if UI
vector function ThemedShopEvent_GetSubtitleTextColor( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "seasonSubtitleColor" )
}
#endif

#if UI
vector function ThemedShopEvent_GetAboutPageSpecialTextColor( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "aboutPageSpecialTextColor" )
}
#endif

#if SERVER || CLIENT || UI
asset function ThemedShopEvent_GetHeaderIcon( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "headerIcon" )
}
#endif

#if UI
GRXScriptOffer ornull function ThemedShopEvent_GetPackOffer( ItemFlavor event )
{
	if ( GRX_IsOfferRestricted() )
		return null

	ItemFlavor packFlav          = GetItemFlavorByAsset( ThemedShopEvent_GetAssociatedPack( event ) )
	string offerLocation         = ThemedShopEvent_GetGRXOfferLocation( event )
	array<GRXScriptOffer> offers = GRX_GetItemDedicatedStoreOffers( packFlav, offerLocation )
	foreach( GRXScriptOffer offer in offers )
	{
		if ( offer.output.flavors.len() > 1 )
			continue
		if ( GRXOffer_ContainsEventThematicPack( offer ) )
			return offer
	}
	return null
}
#endif


                       
                       
                       
                       
                       

  



                   
                   
                   
                   
                   


