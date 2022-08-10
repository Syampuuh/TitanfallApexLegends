global function InitRerollDialog
global function OpenRerollDialog
global function OpenPurchaseRerollDialog

const string CHALLENGE_REROLL_SOUND = "UI_Menu_Challenge_ReRoll"

struct
{
	var menu
	var contentRui

	var buttonBR
	var buttonArenas

	ItemFlavor& rerollChallenge
	var sourceChallengeButton
	var sourceChallengeMenu
} file

void function InitRerollDialog( var newMenuArg )
{
	file.menu = newMenuArg

	SetDialog( file.menu, true )

	file.contentRui = Hud_GetRui( Hud_GetChild( file.menu, "ContentRui" ) )

	AddMenuEventHandler( file.menu, eUIEvent.MENU_OPEN, RerollDialog_OnOpen )
	AddMenuEventHandler( file.menu, eUIEvent.MENU_CLOSE, RerollDialog_OnClose )
	AddMenuEventHandler( file.menu, eUIEvent.MENU_NAVIGATE_BACK, RerollDialog_OnNavigateBack )

	AddMenuFooterOption( file.menu, LEFT, BUTTON_A, false, "#A_BUTTON_ACCEPT", "" )
	AddMenuFooterOption( file.menu, LEFT, BUTTON_B, false, "#B_BUTTON_CLOSE", "#CLOSE" )

	file.buttonArenas = Hud_GetChild( file.menu, "RerollArenasButton" )
	AddButtonEventHandler( file.buttonArenas, UIE_CLICK, void function( var button ) : () {
		RerollDialog_OnClickRerollButton( eChallengeGameMode.ARENAS )
	} )
	RuiSetImage( Hud_GetRui( file.buttonArenas ), "icon", $"rui/rui_screens/arenas_logo" )

	file.buttonBR = Hud_GetChild( file.menu, "RerollBRButton" )
	AddButtonEventHandler( file.buttonBR, UIE_CLICK, void function( var button ) : () {
		RerollDialog_OnClickRerollButton( eChallengeGameMode.BATTLE_ROYALE )
	} )
	RuiSetImage( Hud_GetRui( file.buttonBR ), "icon", $"rui/rui_screens/apex_symbol" )

	var closeButton = Hud_GetChild( file.menu, "CloseButton" )
	RuiSetString( Hud_GetRui( closeButton ), "buttonText", "#B_BUTTON_CANCEL" )
	AddButtonEventHandler( closeButton, UIE_CLICK, void function( var button ) : () {
		CloseActiveMenu()
	} )
}

void function RerollDialog_OnClickRerollButton( int challengeType )
{
	ItemFlavor ornull activeBattlePass = GetActiveBattlePass()

	if ( !GRX_IsInventoryReady() )
		return

	if ( activeBattlePass == null )
		return

	if ( !GRX_IsInventoryReady() )
		return

	if ( !GRX_AreOffersReady() )
		return

	expect ItemFlavor( activeBattlePass )
	ItemFlavor rerollFlav = BattlePass_GetRerollFlav( activeBattlePass )

	if ( ItemFlavor_IsItemDisabledForGRX( rerollFlav ) )
		return

	ItemFlavor challenge = file.rerollChallenge
	var clickedButton = file.sourceChallengeButton
	var sourceMenu = file.sourceChallengeMenu

	int tier             = Challenge_GetCurrentTier( GetLocalClientPlayer(), challenge )
	string challengeText = Challenge_GetDescription( challenge, tier )
	challengeText = StripRuiStringFormatting( challengeText )

	if ( challengeType != -1 )
	{
		int numTokens         = GRX_GetConsumableCount( ItemFlavor_GetGRXIndex( rerollFlav ) )
		string persistenceKey = "challengeRerollsUsed"
		int tokensUsed        = GetPersistentVarAsInt( persistenceKey )

		Assert( tokensUsed <= numTokens )

		int currentDailyRerollCount = GetPersistentVarAsInt( "dailyRerollCount" )
		int numNeeded               = CHALLENGE_REROLL_COSTS[ minint( currentDailyRerollCount, CHALLENGE_REROLL_COSTS.len() - 1 ) ]

		if ( GetActiveMenu() == file.menu )
			CloseActiveMenu()

		if ( numTokens - tokensUsed < numNeeded )
		{
			ItemFlavorPurchasabilityInfo ifpi = GRX_GetItemPurchasabilityInfo( challenge )

			GRXScriptOffer offer
			array<GRXScriptOffer> offers
			foreach ( string location, array<GRXScriptOffer> locationOfferList in ifpi.locationToDedicatedStoreOffersMap )
				foreach ( GRXScriptOffer locationOffer in locationOfferList )
					offers.append( locationOffer )

			var rui = Hud_GetRui( clickedButton )
			PurchaseDialogConfig pdc
			pdc.flav = rerollFlav
			pdc.messageOverride = Localize( "#PURCHASE_REROLL_MSG", Localize( challengeText ) )
			pdc.quantity = numNeeded
			pdc.markAsNew = false
			pdc.onPurchaseResultCallback = void function( bool wasSuccessful ) : ( challenge, rui, sourceMenu, challengeType ) {
				if ( sourceMenu == null )
					JumpToChallenges()

				if ( wasSuccessful )
				{
					Remote_ServerCallFunction( "ClientCallback_Challenge_ReRoll", ItemFlavor_GetGUID( challenge ), challengeType )
					delaythread( 1.65 ) ShimmerChallenge( rui, sourceMenu )
				}
			}

			PurchaseDialog( pdc )
		}
		else
		{
			if ( sourceMenu == null )
				JumpToChallenges()

			Remote_ServerCallFunction( "ClientCallback_Challenge_ReRoll", ItemFlavor_GetGUID( challenge ), challengeType )
			var rui = Hud_GetRui( clickedButton )
			ShimmerChallenge( rui, sourceMenu )
		}
	}
}

void function ShimmerChallenge( var rui, var menu )
{
	if ( menu == null )
		return

	if ( GetActiveMenu() != menu )
		return

	RuiSetGameTime( rui, "rerollAnimStartTime", ClientTime() )
	EmitUISound( CHALLENGE_REROLL_SOUND )
}

void function OpenPurchaseRerollDialog( ItemFlavor challenge, var sourceButton, var sourceMenu )
{
	file.rerollChallenge = challenge
	file.sourceChallengeButton = sourceButton
	file.sourceChallengeMenu = sourceMenu

	int tier             = Challenge_GetCurrentTier( GetLocalClientPlayer(), challenge )
	string challengeText = Challenge_GetDescription( challenge, tier )
	challengeText = StripRuiStringFormatting( challengeText )

	ConfirmDialogData data
	data.headerText = Localize( "#PURCHASE_REROLL_MSG", Localize( challengeText ) )
	data.messageText = "#REROLL_NO_CHOICE_MESSAGE"
	data.resultCallback = void function( int result ) {
		if ( result == eDialogResult.YES )
		{
			RerollDialog_OnClickRerollButton( eChallengeGameMode.ANY )
		}
	}
	OpenConfirmDialogFromData( data )
}

void function OpenRerollDialog( ItemFlavor challenge, var sourceButton, var sourceMenu )
{
	file.rerollChallenge = challenge
	file.sourceChallengeButton = sourceButton
	file.sourceChallengeMenu = sourceMenu

	AdvanceMenu( file.menu )
}

void function RerollDialog_OnOpen()
{
	ItemFlavor challenge = file.rerollChallenge

	ItemFlavor ornull activeBattlePass = GetActiveBattlePass()

	if ( !GRX_IsInventoryReady() )
		return

	if ( activeBattlePass == null )
		return

	if ( !GRX_IsInventoryReady() )
		return

	if ( !GRX_AreOffersReady() )
		return

	expect ItemFlavor( activeBattlePass )
	ItemFlavor rerollFlav = BattlePass_GetRerollFlav( activeBattlePass )

	int tier             = Challenge_GetCurrentTier( GetLocalClientPlayer(), challenge )
	string challengeText = Challenge_GetDescription( challenge, tier )
	challengeText = StripRuiStringFormatting( challengeText )

	RuiSetString( file.contentRui, "headerText", Localize( "#PURCHASE_REROLL_MSG", Localize( challengeText ) ) )
	RuiSetString( file.contentRui, "messageText", "#REROLL_SELECT_MESSAGE" )
}

void function RerollDialog_OnClose()
{
}


void function RerollDialog_OnNavigateBack()
{
	CloseActiveMenu()
}