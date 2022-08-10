global function UserInfoPanels_LevelInit
                                      


struct SingleCurrencyBalanceElement
{
	var         element
	ItemFlavor& currency
}

struct FileStruct_LifetimeLevel
{
	table<var, bool>                    activeUserInfoPanelSet
	array<SingleCurrencyBalanceElement> singleCurrencyBalanceElementList
}
FileStruct_LifetimeLevel& fileLevel

void function UserInfoPanels_LevelInit()
{
	FileStruct_LifetimeLevel newFileLevel
	fileLevel = newFileLevel

	                              
	AddCallbackOrMaybeCallNow_OnAllItemFlavorsRegistered( SetupUserInfoPanels )
}

                                              
   
  	  
   


void function SetupUserInfoPanelToolTips( int currency1, int currency2, int currency3 )
{
	ToolTipData ttd
	ttd.tooltipStyle = eTooltipStyle.CURRENCY
	ttd.actionHint1 = FormatAndLocalizeNumber( "1", float( currency1 ), true )
	ttd.actionHint2 = FormatAndLocalizeNumber( "1", float( currency2 ), true )
	ttd.actionHint3 = FormatAndLocalizeNumber( "1", float( currency3 ), true )

	int nextExpirationAmount = GRX_GetNextCurrencyExpirationAmt()
	if( nextExpirationAmount > 0 )
		ttd.descText = Localize( "#CURRENCIES_TOOLTIP_EXPIRATION", nextExpirationAmount, ( GRX_GetNextCurrencyExpirationTime() - GetUnixTimestamp() ) / SECONDS_PER_DAY )
	else
		ttd.descText = ""

	foreach ( var menu in uiGlobal.allMenus )
	{
		array<var> userInfoElemList = GetElementsByClassname( menu, "UserInfo" )

		foreach ( var elem in userInfoElemList )
			Hud_SetToolTipData( elem, ttd )
	}
}


void function SetupUserInfoPanels()
{
	foreach ( var menu in uiGlobal.allMenus )
	{
		array<var> userInfoElemList = GetElementsByClassname( menu, "UserInfo" )

		if ( userInfoElemList.len() > 0 )
		{
			foreach ( var elem in userInfoElemList )
			{
				var rui = Hud_GetRui( elem )
				RuiSetImage( rui, "symbol1", ItemFlavor_GetIcon( GRX_CURRENCIES[GRX_CURRENCY_PREMIUM] ) )
				RuiSetImage( rui, "symbol2", ItemFlavor_GetIcon( GRX_CURRENCIES[GRX_CURRENCY_CREDITS] ) )
				RuiSetImage( rui, "symbol3", ItemFlavor_GetIcon( GRX_CURRENCIES[GRX_CURRENCY_CRAFTING] ) )

				fileLevel.activeUserInfoPanelSet[elem] <- true            
			}

			                                                                                         
			  	                                       
			  		                                              
			     
			  
			                                                                                          
			  	                                       
			  		                                             
			     
		}
	}

	table<string, int> singleCurrencyElementTypesTable = {
		["PremiumBalance"] = GRX_CURRENCY_PREMIUM,
		["CreditBalance"] = GRX_CURRENCY_CREDITS,
		["CraftingBalance"] = GRX_CURRENCY_CRAFTING,
	}
	foreach( string classname, int currencyIndex in singleCurrencyElementTypesTable )
	{
		ItemFlavor currency = GRX_CURRENCIES[currencyIndex]
		foreach ( var elem in GetElementsByClassnameForMenus( classname, uiGlobal.allMenus ) )
		{
			var rui = Hud_GetRui( elem )
			RuiSetImage( rui, "symbol", ItemFlavor_GetIcon( currency ) )

			SingleCurrencyBalanceElement scbe
			scbe.element = elem
			scbe.currency = currency
			fileLevel.singleCurrencyBalanceElementList.append( scbe )
		}
	}

	AddCallbackAndCallNow_OnGRXInventoryStateChanged( UpdateActiveUserInfoPanels )
	AddCallbackAndCallNow_OnGRXOffersRefreshed( UpdateActiveUserInfoPanels )
}


void function UpdateActiveUserInfoPanels()
{
	bool isReady = GRX_IsInventoryReady() && GRX_AreOffersReady()
	int premiumBalance, creditsBalance, craftingBalance
	if ( isReady )
	{
		premiumBalance = GRXCurrency_GetPlayerBalance( GetLocalClientPlayer(), GRX_CURRENCIES[GRX_CURRENCY_PREMIUM] )
		creditsBalance = GRXCurrency_GetPlayerBalance( GetLocalClientPlayer(), GRX_CURRENCIES[GRX_CURRENCY_CREDITS] )
		craftingBalance = GRXCurrency_GetPlayerBalance( GetLocalClientPlayer(), GRX_CURRENCIES[GRX_CURRENCY_CRAFTING] )
	}

	foreach( var elem, bool unused in fileLevel.activeUserInfoPanelSet )
	{
		var rui = Hud_GetRui( elem )
		                                                  
		RuiSetBool( rui, "isQuerying", !isReady )

		if ( isReady )
		{
			#if DEV
				RuiSetBool( rui, "hasUnknownItems", GetConVarBool( "grx_hasUnknownItems" ) )
			#endif
			RuiSetString( rui, "count1",  FormatAndLocalizeNumber( "1", float( premiumBalance ), true ) )
			RuiSetString( rui, "count2", LocalizeAndShortenNumber_Float( float( creditsBalance ) ) )
			RuiSetString( rui, "count3", LocalizeAndShortenNumber_Float( float( craftingBalance ) ) )
		}
	}

	foreach( SingleCurrencyBalanceElement scbe in fileLevel.singleCurrencyBalanceElementList )
	{
		var rui = Hud_GetRui( scbe.element )
		RuiSetBool( rui, "isQuerying", !isReady )

		if ( isReady )
			RuiSetInt( rui, "count", GRXCurrency_GetPlayerBalance( GetLocalClientPlayer(), scbe.currency ) )
	}

	SetupUserInfoPanelToolTips( premiumBalance, creditsBalance, craftingBalance )
}


                                      
 
	                                                       

	              
	 
		                             
		             
		 
			                                                       
			                                                    
			                                                       
			                                                           
			                                                             
			                                                                                 

			                                                                    
			 
				                            
				                                      
				                                                
			 
		 

		                             
	 
   
