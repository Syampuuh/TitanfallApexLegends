global function InitPromoData
global function GetPromoImage
global function OpenPromoLink

#if DEV
global function DEV_PrintUMPromoData
#endif       


struct
{
	table<string, asset> imageMap
} file


void function InitPromoData()
{
	var dataTable = GetDataTable( $"datatable/promo_images.rpak" )
	for ( int i = 0; i < GetDataTableRowCount( dataTable ); i++ )
	{
		string name = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "name" ) ).tolower()
		asset image = GetDataTableAsset( dataTable, i, GetDataTableColumnByName( dataTable, "image" ) )
		if ( name != "" )
			file.imageMap[name] <- image
	}
}


asset function GetPromoImage( string identifier )
{
	identifier = identifier.tolower()

	asset image
	if ( identifier in file.imageMap )
		image = file.imageMap[identifier]
	else
		image = $"rui/promo/apex_title_blue"

	return image
}

void function OpenPromoLink( string linkType, string link )
{
	                                                                      
	if ( linkType == "battlepass" )
	{
		EmitUISound( "UI_Menu_Accept" )
		JumpToSeasonTab( "PassPanel" )
	}
	else if ( linkType == "storecharacter" )
	{
		EmitUISound( "UI_Menu_Accept" )
		if ( IsValidItemFlavorHumanReadableRef( link ) )
		{
			ItemFlavor character = GetItemFlavorByHumanReadableRef( link )
			if ( GRX_IsItemOwnedByPlayer( character ) )
				JumpToCharactersTab()
			else
				JumpToCharacterCustomize( character )
		}
		else
		{
			JumpToCharactersTab()
		}
	}
	else if ( linkType == "storeskin" )
	{
		EmitUISound( "UI_Menu_Accept" )
		if ( IsValidItemFlavorHumanReadableRef( link ) )
		{
			ItemFlavor skin = GetItemFlavorByHumanReadableRef( link )
			if ( GRX_IsItemOwnedByPlayer( skin ) )
				JumpToStoreTab()
			else
				JumpToStoreSkin( skin )
		}
		else
		{
			JumpToStoreTab()
		}
	}
	else if ( linkType == "themedstoreskin" )
	{
		EmitUISound( "UI_Menu_Accept" )
		ItemFlavor ornull activeThemedShopEvent = GetActiveThemedShopEvent( GetUnixTimestamp() )
		if ( activeThemedShopEvent != null )
		{
			if( link != "" )
				JumpToThemeShopOffer( link )
			else
				JumpToSeasonTab( "ThemedShopPanel" )
		}
		else
			JumpToStoreTab()
	}
	else if ( linkType == "collectionevent" )
	{
		EmitUISound( "UI_Menu_Accept" )
		ItemFlavor ornull activeCollectionEvent = GetActiveCollectionEvent( GetUnixTimestamp() )
		if ( activeCollectionEvent != null )
			JumpToSeasonTab( "CollectionEventPanel" )
		else
			JumpToStoreTab()
	}
	else if ( linkType == "url" )
	{
		EmitUISound( "UI_Menu_Accept" )
		LaunchExternalWebBrowser( link, WEBBROWSER_FLAG_NONE )
	}
	else if ( linkType == "storeoffer" )
	{
		EmitUISound( "UI_Menu_Accept" )
		JumpToStoreOffer( link )
	}
	else if ( linkType == "whatsnew" )
	{
		EmitUISound( "UI_Menu_Accept" )
		JumpToSeasonTab( "WhatsNewPanel" )
	}
	else if ( linkType == "storyevent" )
	{
		EmitUISound( "UI_Menu_Accept" )

		array<ItemFlavor> storyChallengeEvents  = GetActiveStoryChallengeEvents( GetUnixTimestamp() )
		if ( storyChallengeEvents.len() <= 0 )
			return

		StoryEventAboutDialog_SetEvent( storyChallengeEvents[0] )
		AdvanceMenu( GetMenu( "StoryEventAboutDialog" ) )
	}
	else if ( linkType == "storespecials" )
	{
		EmitUISound( "UI_Menu_Accept" )
		JumpToStoreSpecials()
	}
}

#if DEV
void function DEV_PrintUMPromoData()
{
	UMData um = EADP_UM_GetPromoData()
	printt( "triggerId:", um.triggerId )
	printt( "triggerName:", um.triggerName )
	foreach( int i, UMAction action in um.actions )
	{
		printt( i, "action name:", action.name )
		printt( i, "action trackingId:", action.trackingId )
		foreach( int j, UMItem item in action.items )
		{
			printt( j, "item type:", item.type, "- name:", item.name )
			printt( j, "item value:", item.value )
			foreach( int k, UMAttribute attr in item.attributes )
			{
				printt( k, "attr key:", attr.key )
				printt( k, "attr value:", attr.value )
			}
		}
	}
}
#endif       
