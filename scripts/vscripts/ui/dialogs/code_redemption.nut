global function InitCodeRedemptionDialog
global function UICodeCallback_CodeRedemptionRequestFinished
#if DEV
global function DEV_CodeRedemptionSuccessDialog
#endif

struct {
	var menu
	var codeTextEntry
	var codeTextEntryBG
	InputDef &redeemFooterButton
} file


void function InitCodeRedemptionDialog( var newMenuArg )
{
	var menu = newMenuArg
	file.menu = menu

	file.codeTextEntry = Hud_GetChild( menu, "CodeTextEntry" )
	file.codeTextEntryBG = Hud_GetChild( menu, "TextEntryBackground" )

	SetAllowControllerFooterClick( menu, true )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, CodeRedemptionDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, CodeRedemptionDialog_OnClose )

	file.redeemFooterButton = AddMenuFooterOption( menu, LEFT, BUTTON_Y, true, "#Y_BUTTON_REDEEM", "#Y_BUTTON_REDEEM", RedeemButton_OnActivate )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CANCEL", "#B_BUTTON_CANCEL", CodeRedemptionDialog_Cancel, CodeRedemption_CanRedeem )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE", CodeRedemptionDialog_Cancel, CodeRedemption_CannotRedeem )
}


void function CodeRedemptionDialog_OnOpen()
{
	var contentRui = Hud_GetRui( Hud_GetChild( file.menu, "ContentRui" ) )
	RuiSetString( contentRui, "statusText", "" )
	RuiSetString( contentRui, "messageText", "" )

	Hud_SetUTF8Text( file.codeTextEntry, "" )
	Hud_SetVisible( file.codeTextEntry, true )
	Hud_SetVisible( file.codeTextEntryBG, true )

	string headerText = ""
	string textEntryTitle = ""
	if( EADP_IsCodeRedemptionEnabled() )
	{
		headerText = "#REDEEM_CODE_TEXT"
		textEntryTitle = "#REDEEM_CODE_TEXT"
		Hud_SetEnabled( file.codeTextEntry, true )
		file.redeemFooterButton.clickable = true
	}
	else
	{
#if DEV && PC_PROG
		headerText = "Enable Origin to redeem codes in dev"
#else
		headerText = "#REDEEM_CODE_DISABLED"
#endif
		Hud_SetEnabled( file.codeTextEntry, false )
		file.redeemFooterButton.clickable = false
	}
	RuiSetString( contentRui, "headerText", headerText )
	Hud_SetTextEntryTitle( file.codeTextEntry, textEntryTitle )

	RegisterButtonPressedCallback( KEY_ENTER, RedeemButton_OnActivate )
}

void function CodeRedemptionDialog_OnClose()
{
	DeregisterButtonPressedCallback( KEY_ENTER, RedeemButton_OnActivate )
}


void function UICodeCallback_CodeRedemptionRequestFinished( int resultCode, string message, array<CodeRedemptionGrant> grants )
{
	if ( GetActiveMenu() != file.menu )
		return

	                                                                    
	bool wasCodeRedeemed = ( resultCode == CODE_REDEMPTION_RESULT_SUCCESS )
	string statusText = wasCodeRedeemed ? "#SUCCESS" : "#FAILED"
	file.redeemFooterButton.clickable = false
	UpdateFooterOptions()

	printf( "%s() - Result: %s, Error Message: %s ", FUNC_NAME(), Localize( statusText ), Localize( message ) )
	foreach( idx, grant in grants )
		printf( "grant %i - type: %i, alias: %s, qty: %i", idx, grant.type, grant.alias, grant.qty )

	Hud_SetVisible( file.codeTextEntry, false )
	Hud_SetVisible( file.codeTextEntryBG, false )
	var contentRui = Hud_GetRui( Hud_GetChild( file.menu, "ContentRui" ) )

	RuiSetString( contentRui, "statusText", statusText )
	RuiSetString( contentRui, "messageText", CodeRedemption_GetDisplayMessage( wasCodeRedeemed, message ) )

	if( wasCodeRedeemed && grants.len() > 0 )
	{
		CodeRedemption_DisplayGrantedItems( grants, true )
	}
}

void function CodeRedemption_DisplayGrantedItems( array<CodeRedemptionGrant> grants, bool markItemsAsNew )
{
	array<BattlePassReward> rewards
	foreach( grant in grants )
	{
		int grxIndex = GetGRXIndexByGRXRef( grant.alias )
		BattlePassReward info
		info.level = -1
		info.flav = GetItemFlavorByGRXIndex( grxIndex )
		info.quantity = grant.qty
		rewards.append( info )

		if ( markItemsAsNew )
		{
			int grxMode = ItemFlavor_GetGRXMode( info.flav )
			if ( grxMode == eItemFlavorGRXMode.REGULAR || grxMode == eItemFlavorGRXMode.NONE )
			{
				if ( !GRX_IsItemOwnedByPlayer( info.flav ) )
					Newness_TEMP_MarkItemAsNewAndInformServer( info.flav )
			}
		}
	}

	ShowRewardCeremonyDialog(
		"",
		"#REDEEM_CODE_REWARD_DIALOG_HEADER",
		"",
		rewards,
		true, 	                 
		false,	            
		false,	              
		true                 
	)
}

const table<string, string> EADPErrorCodesToDisplayMessage =
{
	CODE_REDEMPTION_CODE_USED = 				"#REDEEM_CODE_ERROR_USED"
	CODE_REDEMPTION_CODE_RUN_OUT = 				"#REDEEM_CODE_ERROR_USED"
	CODE_REDEMPTION_CODE_EXPIRED = 				"#REDEEM_CODE_ERROR_EXPIRED"
	CODE_REDEMPTION_THROTTLING = 				"#REDEEM_CODE_ERROR_LIMIT_REACHED"
	CODE_REDEMPTION_CODE_NOT_FOUND = 			"#REDEEM_CODE_ERROR_INVALID"
	CODE_REDEMPTION_CODE_NOT_ACTIVATED = 		"#REDEEM_CODE_ERROR_INVALID"
	CODE_REDEMPTION_CODE_DISABLED = 			"#REDEEM_CODE_ERROR_INVALID"
	CODE_REDEMPTION_CONFIG_ERROR = 				"#REDEEM_CODE_ERROR_INVALID"
	CODE_REDEMPTION_INVALID_PERSONA = 			"#REDEEM_CODE_ERROR_INVALID"
	CODE_REDEMPTION_INTERNAL_ERROR = 			"#REDEEM_CODE_ERROR_INVALID"
	CODE_REDEMPTION_UNKNOWN_ERROR = 			"#REDEEM_CODE_ERROR_INVALID"
	CODE_REDEMPTION_NOTHING_CAN_BE_FULFILLED = 	"#REDEEM_CODE_ERROR_ALL_ITEMS_OWNED"
	MARKETPLACE_INVALID_BANK_TRANSACTION =		"#REDEEM_CODE_ERROR_INVALID"
	MARKETPLACE_BANNED_ACCOUNT = 				"#REDEEM_CODE_ERROR_INVALID"
	MARKETPLACE_ITEM_QUANTITY_LIMIT_EXCEEDED =	"#REDEEM_CODE_ERROR_ITEM_LIMIT"
}

string function CodeRedemption_GetDisplayMessage( bool wasCodeRedeemed, string eadpErrorMessage )
{
	string displayMessage = ""
	if( wasCodeRedeemed )
		displayMessage = ""
	else if ( eadpErrorMessage in EADPErrorCodesToDisplayMessage )
		displayMessage = EADPErrorCodesToDisplayMessage[eadpErrorMessage]
	else
		displayMessage = eadpErrorMessage

	return displayMessage
}

void function CodeRedemptionDialog_AttemptRedeem()
{
	if( !EADP_IsCodeRedemptionEnabled() )
		return

	string code = strip( Hud_GetUTF8Text( file.codeTextEntry ) )                                          
	Hud_SetUTF8Text( file.codeTextEntry, code )

	printt( "EADP_RedeemCode:", code )
	EADP_RedeemCode( code )
}


void function RedeemButton_OnActivate( var button )
{
	if ( CodeRedemption_CanRedeem() )
		CodeRedemptionDialog_AttemptRedeem()
}

void function CodeRedemptionDialog_Cancel( var button )
{
	CloseAllToTargetMenu( file.menu )
	CloseActiveMenu()
}

                                         
bool function CodeRedemption_CanRedeem()
{
	return EADP_IsCodeRedemptionEnabled() && file.redeemFooterButton.clickable
}
bool function CodeRedemption_CannotRedeem()
{
	return !CodeRedemption_CanRedeem()
}


#if DEV
                                                                                                                 
const array<string> redeemTestFlavs =
[
	"character_skin_rampart_legendary_04",
	"character_skin_crypto_legendary_01",
	"character_skin_wraith_season02_event02_legendary_01",
	"loadscreen_s03bp_05",
	"battlepass_season09_purchased_xp",
	"crafting"
]
                                                                                                               
void function DEV_CodeRedemptionSuccessDialog( bool markItemsAsNew = false, array<string> itemRefs = redeemTestFlavs )
{
	array<CodeRedemptionGrant> grants
	foreach ( itemRef in itemRefs )
	{
		CodeRedemptionGrant testGrant
		testGrant.alias = itemRef
		testGrant.qty = 1
		grants.append( testGrant )
	}

	CodeRedemption_DisplayGrantedItems( grants, markItemsAsNew )
}
#endif