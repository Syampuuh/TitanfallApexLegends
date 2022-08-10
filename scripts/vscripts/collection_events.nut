  

#if SERVER || CLIENT || UI
global function CollectionEvents_Init
#endif


#if SERVER || CLIENT || UI
global function GetActiveCollectionEvent
global function CollectionEvent_GetChallenges                                
global function CollectionEvent_GetFrontPageRewardBoxTitle
global function CollectionEvent_GetCollectionName
                                              
                                                        
global function CollectionEvent_GetMainPackFlav
global function CollectionEvent_GetMainPackShortPluralName
global function CollectionEvent_GetMainPackImage
                                                 
                                                            
global function CollectionEvent_GetFrontPageGRXOfferLocation
                                                         
global function CollectionEvent_GetRewardGroups
global function CollectionEvent_GetAboutText                                
global function CollectionEvent_GetMainIcon
global function CollectionEvent_GetMainThemeCol
global function CollectionEvent_GetFrontPageBGTintCol
global function CollectionEvent_GetFrontPageTitleCol
global function CollectionEvent_GetFrontPageSubtitleCol
global function CollectionEvent_GetFrontPageTimeRemainingCol
                                                         
                                                             
                                                             
global function CollectionEvent_GetBGPatternImage
global function CollectionEvent_GetBGTabPatternImage
global function CollectionEvent_GetTabBGDefaultCol                                 
global function CollectionEvent_GetTabBarDefaultCol                                
global function CollectionEvent_GetTabBGFocusedCol                                
global function CollectionEvent_GetTabBarFocusedCol                                
global function CollectionEvent_GetTabBGSelectedCol                                
global function CollectionEvent_GetTabBarSelectedCol                                
global function CollectionEvent_GetAboutPageSpecialTextCol                                
global function CollectionEvent_GetHeaderIcon                                
#endif

                                                      
#if SERVER || CLIENT || UI
global function HeirloomEvent_GetItemCount
global function HeirloomEvent_GetCurrentRemainingItemCount
global function HeirloomEvent_GetPrimaryCompletionRewardItem
global function HeirloomEvent_GetCompletionRewardPack
global function HeirloomEvent_GetCompletionSequenceName
global function HeirloomEvent_AwardHeirloomShards
global function HeirloomEvent_IsRewardMythicSkin
#endif

#if UI
global function HeirloomEvent_GetHeirloomButtonImage
global function HeirloomEvent_GetMythicButtonImage
global function HeirloomEvent_GetHeirloomHeaderText
global function HeirloomEvent_GetHeirloomUnlockDesc
#endif
                      


#if CLIENT || UI
global function CollectionEvent_GetFrontTabText
#endif

#if SERVER || UI
global function CollectionEvent_GetCurrentMaxEventPackPurchaseCount
                                                                          
#endif

#if UI
                                                  
global function CollectionEvent_GetHeaderTextColor
global function CollectionEvent_GetPackOffer                                
global function CollectionEvent_GetLobbyButtonImage                                
global function CollectionEvent_GetTitleTextColor                                
global function CollectionEvent_HasLobbyTheme                                
#endif

#if SERVER
                                                      
#endif


                      
                      
                      
                      
                      

#if SERVER || CLIENT || UI
global struct CollectionEventRewardGroup
{
	string ref
	int    quality = -1
	                        
	                           

	array<ItemFlavor> rewards
}
#endif

global const array< int > HEIRLOOM_EVENTS = [ eItemType.calevent_collection, eItemType.calevent_themedshop ]

                       
                       
                       
                       
                       

#if SERVER || CLIENT || UI
struct FileStruct_LifetimeLevel
{
	#if SERVER
		                             
		                                 
	#endif

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
void function CollectionEvents_Init()
{
	#if UI
		FileStruct_LifetimeLevel newFileLevel
		fileLevel = newFileLevel
	#endif

	AddCallback_OnItemFlavorRegistered( eItemType.calevent_collection, void function( ItemFlavor ev ) {
		fileLevel.eventChallengesMap[ev] <- RegisterReferencedItemFlavorsFromArray( ev, "challenges", "flavor" )
		foreach ( int challengeSortOrdinal, ItemFlavor challengeFlav in fileLevel.eventChallengesMap[ev] )
			RegisterChallengeSource( challengeFlav, ev, challengeSortOrdinal )
	} )

	#if SERVER
		                                                                                    
		                                                                        
	#endif
}
#endif



                          
                          
                          
                          
                          

#if SERVER || CLIENT || UI
ItemFlavor ornull function GetActiveCollectionEvent( int t )
{
	Assert( IsItemFlavorRegistrationFinished() )
	ItemFlavor ornull event = null
	foreach ( ItemFlavor ev in GetAllItemFlavorsOfType( eItemType.calevent_collection ) )
	{
		if ( !CalEvent_IsActive( ev, t ) )
			continue

		Assert( event == null, format( "Multiple collection events are active!! (%s, %s)", ItemFlavor_GetHumanReadableRef( expect ItemFlavor(event) ), ItemFlavor_GetHumanReadableRef( ev ) ) )
		event = ev
	}
	return event
}
#endif


#if SERVER || CLIENT || UI
array<ItemFlavor> function CollectionEvent_GetLoginRewards( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )

	array<ItemFlavor> rewards = []
	foreach ( var rewardBlock in IterateSettingsAssetArray( ItemFlavor_GetAsset( event ), "loginRewards" ) )
	{
		asset rewardAsset = GetSettingsBlockAsset( rewardBlock, "flavor" )
		if ( IsValidItemFlavorSettingsAsset( rewardAsset ) )
			rewards.append( GetItemFlavorByAsset( rewardAsset ) )
	}
	return rewards
}
#endif


#if SERVER || CLIENT || UI
array<ItemFlavor> function CollectionEvent_GetChallenges( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )

	return fileLevel.eventChallengesMap[event]
}
#endif


#if SERVER || CLIENT || UI
string function CollectionEvent_GetFrontPageRewardBoxTitle( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsString( ItemFlavor_GetAsset( event ), "frontPageRewardBoxTitle" )
}
#endif

#if SERVER || CLIENT || UI
string function CollectionEvent_GetCollectionName( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsString( ItemFlavor_GetAsset( event ), "collectionName" )
}
#endif


                            
                                                                  
   
  	                                                                      
  	                                                                           
   
        


                            
                                                                            
   
  	                                                                      
  	                                                                                     
   
        


#if SERVER || CLIENT || UI
ItemFlavor function CollectionEvent_GetMainPackFlav( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetItemFlavorByAsset( GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "mainPackFlav" ) )
}
#endif


#if SERVER || CLIENT || UI
string function CollectionEvent_GetMainPackShortPluralName( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsString( ItemFlavor_GetAsset( event ), "mainPackShortPluralName" )
}
#endif


#if SERVER || CLIENT || UI
asset function CollectionEvent_GetMainPackImage( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "mainPackImage" )
}
#endif


#if SERVER || CLIENT || UI
bool function HeirloomEvent_AwardHeirloomShards( ItemFlavor event )
{
	Assert( HEIRLOOM_EVENTS.contains( ItemFlavor_GetType( event ) ) )
	return GetGlobalSettingsBool( ItemFlavor_GetAsset( event ), "awardHeirloomShards" )
}
#endif


#if SERVER || CLIENT || UI
ItemFlavor function HeirloomEvent_GetPrimaryCompletionRewardItem( ItemFlavor event )
{
	Assert( HEIRLOOM_EVENTS.contains( ItemFlavor_GetType( event ) ) )

	if ( HeirloomEvent_AwardHeirloomShards( event ) )
		return GetItemFlavorByAsset( $"settings/itemflav/currency_bundle/heirloom.rpak" )

	return GetItemFlavorByAsset( GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "primaryCompletionRewardItem" ) )
}
#endif

#if SERVER || CLIENT || UI
bool function HeirloomEvent_IsRewardMythicSkin( ItemFlavor event )
{
	ItemFlavor primaryRewardItem =  HeirloomEvent_GetPrimaryCompletionRewardItem( event )
	return Mythics_IsItemFlavorMythicSkin( primaryRewardItem )
}
#endif


#if SERVER || CLIENT || UI
ItemFlavor function HeirloomEvent_GetCompletionRewardPack( ItemFlavor event )
{
	Assert( HEIRLOOM_EVENTS.contains( ItemFlavor_GetType( event ) ) )

	if ( HeirloomEvent_AwardHeirloomShards( event ) )
		return GetItemFlavorByAsset( $"settings/itemflav/pack/heirloom_shards.rpak" )

	return GetItemFlavorByAsset( GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "completionRewardPack" ) )
}
#endif


#if SERVER || CLIENT || UI
string function HeirloomEvent_GetCompletionSequenceName( ItemFlavor event )
{
	Assert( HEIRLOOM_EVENTS.contains( ItemFlavor_GetType( event ) ) )
	return GetGlobalSettingsString( ItemFlavor_GetAsset( event ), "completionSequenceName" )
}
#endif


                            
                                                                         
   
  	                                                                      
  	                                                                                                     
   
        


                            
                                                                             
   
  	                                                                      
  	                                                                                      
   
        


#if SERVER || CLIENT || UI
string function CollectionEvent_GetFrontPageGRXOfferLocation( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsString( ItemFlavor_GetAsset( event ), "frontGRXOfferLocation" )
}
#endif


                            
                                                                             
   
  	                                                                      
  	                                                                                      
   
        


#if SERVER || CLIENT || UI
array<CollectionEventRewardGroup> function CollectionEvent_GetRewardGroups( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )

	array<CollectionEventRewardGroup> groups = []
	foreach ( var groupBlock in IterateSettingsAssetArray( ItemFlavor_GetAsset( event ), "rewardGroups" ) )
	{
		CollectionEventRewardGroup group
		group.ref = GetSettingsBlockString( groupBlock, "ref" )
		group.quality = eRarityTier[GetSettingsBlockString( groupBlock, "quality" )]
		                                                                                 
		                                                                                       
		foreach ( var rewardBlock in IterateSettingsArray( GetSettingsBlockArray( groupBlock, "rewards" ) ) )
			group.rewards.append( GetItemFlavorByAsset( GetSettingsBlockAsset( rewardBlock, "flavor" ) ) )

		groups.append( group )
	}
	return groups
}
#endif


#if SERVER || CLIENT || UI
array<string> function CollectionEvent_GetAboutText( ItemFlavor event, bool restricted )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )

	array<string> aboutText = []
	string key              = (restricted ? "aboutTextRestricted" : "aboutTextStandard")
	foreach ( var aboutBlock in IterateSettingsAssetArray( ItemFlavor_GetAsset( event ), key ) )
		aboutText.append( GetSettingsBlockString( aboutBlock, "text" ) )
	return aboutText
}
#endif


#if SERVER || CLIENT || UI
void function CollectionEvent_GetMainIcon( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
}
#endif


#if SERVER || CLIENT || UI
vector function CollectionEvent_GetMainThemeCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "mainThemeCol" )
}
#endif


#if SERVER || CLIENT || UI
vector function CollectionEvent_GetFrontPageBGTintCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "frontPageBGTintCol" )
}
#endif


#if SERVER || CLIENT || UI
vector function CollectionEvent_GetFrontPageTitleCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "frontPageTitleCol" )
}
#endif


#if SERVER || CLIENT || UI
vector function CollectionEvent_GetFrontPageSubtitleCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "frontPageSubtitleCol" )
}
#endif


#if SERVER || CLIENT || UI
vector function CollectionEvent_GetFrontPageTimeRemainingCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "frontPageTimeRemainingCol" )
}
#endif


                            
                                                                             
   
  	                                                                      
  	                                                                                      
   
        


                            
                                                                                 
   
  	                                                                      
  	                                                                                          
   
        


                            
                                                                                 
   
  	                                                                      
  	                                                                                          
   
        


#if CLIENT || UI
string function CollectionEvent_GetFrontTabText( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return ItemFlavor_GetShortName( event )
}
#endif


#if SERVER || CLIENT || UI
vector function CollectionEvent_GetTabBGDefaultCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "tabBGDefaultCol" )
}
#endif


#if SERVER || CLIENT || UI
vector function CollectionEvent_GetTabBarDefaultCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "tabBarDefaultCol" )
}
#endif


#if SERVER || CLIENT || UI
vector function CollectionEvent_GetTabBGFocusedCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "tabBGFocusedCol" )
}
#endif


#if SERVER || CLIENT || UI
vector function CollectionEvent_GetTabBarFocusedCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "tabBarFocusedCol" )
}
#endif


#if SERVER || CLIENT || UI
vector function CollectionEvent_GetTabBGSelectedCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "tabBGSelectedCol" )
}
#endif


#if SERVER || CLIENT || UI
vector function CollectionEvent_GetTabBarSelectedCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "tabBarSelectedCol" )
}
#endif


#if SERVER || CLIENT || UI
vector function CollectionEvent_GetAboutPageSpecialTextCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "aboutPageSpecialTextCol" )
}
#endif




#if SERVER || CLIENT || UI
asset function CollectionEvent_GetBGPatternImage( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "bgPatternImage" )
}
#endif

#if SERVER || CLIENT || UI
asset function CollectionEvent_GetBGTabPatternImage( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "bgTabPatternImage" )
}
#endif


#if SERVER || CLIENT || UI
asset function CollectionEvent_GetHeaderIcon( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "headerIcon" )
}
#endif


#if UI
asset function HeirloomEvent_GetHeirloomButtonImage( ItemFlavor event )
{
	Assert( HEIRLOOM_EVENTS.contains( ItemFlavor_GetType( event ) ) )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "heirloomButtonImage" )
}
#endif

#if UI
asset function HeirloomEvent_GetMythicButtonImage( ItemFlavor event, int tier )
{
	Assert( HEIRLOOM_EVENTS.contains( ItemFlavor_GetType( event ) ) )

	if ( tier == 1 )
		return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "prestigeButtonImage2" )
	else if ( tier == 2 )
		return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "prestigeButtonImage3" )

	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "heirloomButtonImage" )
}
#endif


#if UI
string function HeirloomEvent_GetHeirloomHeaderText( ItemFlavor event )
{
	Assert( HEIRLOOM_EVENTS.contains( ItemFlavor_GetType( event ) ) )

	string headerText = "#COLLECTION_EVENT_HEIRLOOM_BOX_TITLE"
	if ( HeirloomEvent_AwardHeirloomShards( event ) )
		headerText = "#CURRENCY_HEIRLOOM_NAME_SHORT"
	else if ( HeirloomEvent_IsRewardMythicSkin( event ) )
		headerText = "#COLLECTION_EVENT_MYTHIC_BOX_TITLE"

	return Localize( headerText ).toupper()
}
#endif


#if UI
string function HeirloomEvent_GetHeirloomUnlockDesc( ItemFlavor event )
{
	Assert( HEIRLOOM_EVENTS.contains( ItemFlavor_GetType( event ) ) )
	return GetGlobalSettingsString( ItemFlavor_GetAsset( event ), "heirloomUnlockDesc" )
}
#endif

#if UI
bool function CollectionEvent_HasLobbyTheme( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsBool( ItemFlavor_GetAsset( event ), "themeLobby" )
}
#endif


#if UI
asset function CollectionEvent_GetLobbyButtonImage( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "lobbyButtonImage" )
}
#endif


#if UI
vector function CollectionEvent_GetTitleTextColor( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "seasonTitleColor" )
}
#endif


#if UI
vector function CollectionEvent_GetHeaderTextColor( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "seasonHeaderColor" )
}
#endif


#if SERVER || CLIENT || UI
int function HeirloomEvent_GetItemCount( ItemFlavor event, bool onlyOwned, entity player = null, bool dontCheckInventoryReady = false )
{
	Assert( dontCheckInventoryReady || !onlyOwned || ( player != null && GRX_IsInventoryReady( player ) ) )

	int count = 0
	array < ItemFlavor > eventItems
	if ( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	{
		eventItems = []
		array<CollectionEventRewardGroup> rewardGroups = CollectionEvent_GetRewardGroups( event )
		foreach ( CollectionEventRewardGroup rewardGroup in rewardGroups )
		{
			foreach ( ItemFlavor reward in rewardGroup.rewards )
			{
				eventItems.append( reward )
			}
		}
	}
	else if ( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	{
		eventItems = GRXPack_GetPackContents( GetItemFlavorByAsset( ThemedShopEvent_GetAssociatedPack( event ) ) )
	}

	foreach ( ItemFlavor item in eventItems )
	{
		                                                                                                                                                            
		#if SERVER
			                                                                          
				       

			                                                                                                                       
			                                                                                                                                                
				                                                          
		#endif
		#if CLIENT || UI
			if ( !onlyOwned || GRX_HasItem( ItemFlavor_GetGRXIndex( item ) ) )
				count++
		#endif
	}

	return count
}
#endif


#if SERVER || CLIENT || UI
int function HeirloomEvent_GetCurrentRemainingItemCount( ItemFlavor event, entity player )
{
	return HeirloomEvent_GetItemCount( event, false ) - HeirloomEvent_GetItemCount( event, true, player )
}
#endif


#if UI
GRXScriptOffer ornull function CollectionEvent_GetPackOffer( ItemFlavor event )
{
	if ( GRX_IsOfferRestricted() )
		return null

	ItemFlavor packFlav          = CollectionEvent_GetMainPackFlav( event )
	string offerLocation         = CollectionEvent_GetFrontPageGRXOfferLocation( event )
	array<GRXScriptOffer> offers = GRX_GetItemDedicatedStoreOffers( packFlav, offerLocation )
	return offers.len() > 0 ? offers[0] : null
}
#endif


#if SERVER || UI
int function CollectionEvent_GetCurrentMaxEventPackPurchaseCount( ItemFlavor event, entity player )
{
	#if SERVER
		                                      
			        
	#elseif UI
		if ( CollectionEvent_GetPackOffer( event ) == null )
			return 0
	#endif


	ItemFlavor packFlav = CollectionEvent_GetMainPackFlav( event )
	#if SERVER
		                                                                                   
	#elseif UI
		int ownedPackCount = GRX_GetPackCount( ItemFlavor_GetGRXIndex( packFlav ) )
	#endif

	return HeirloomEvent_GetCurrentRemainingItemCount( event, player ) - ownedPackCount
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
