global function InitClubAnnouncementDialog
global function OpenViewAnnouncementDialog
global function OpenSubmitAnnouncementDialog
global function CloseClubAnnouncementDialog

enum eDialogState
{
	VIEW,
	SUBMIT
}

const float ONE_BUTTON = 200.0
const float TWO_BUTTONS = 422.0
const int BUTTON_WIDTH = 200
const int BUTTON_MARGIN = 22

struct
{
	var menu
	var menuHeader
	var clubLogoAnchor
	var dialogContent
	var textEntry
	var textEntryBkg
	var footer
	int footerX
	int footerY
	ClubEvent& announcement

	string announceString

	int dialogState = eDialogState.VIEW

	bool hasTextChanged
} file

void function InitClubAnnouncementDialog( var menu )
{
	file.menu = menu
	SetDialog( menu, true )

	file.menuHeader = Hud_GetChild( menu, "DialogHeader" )
	file.clubLogoAnchor = Hud_GetChild( menu, "ClubLogoAnchor" )

	file.dialogContent = Hud_GetChild( menu, "DialogContent" )

	file.textEntry = Hud_GetChild( menu, "TextEntry" )
	AddButtonEventHandler( file.textEntry, UIE_CHANGE, AnnouncementText_OnChanged )
	file.textEntryBkg = Hud_GetChild( menu, "TextEntryBackground" )

	file.footer = Hud_GetChild( menu, "FooterButtons" )
	file.footerX = REPLACEHud_GetPos( file.footer ).x
	file.footerY = REPLACEHud_GetPos( file.footer ).y

	AddMenuEventHandler( file.menu, eUIEvent.MENU_OPEN, ClubAnnouncementDialog_OnOpen )
	AddMenuEventHandler( file.menu, eUIEvent.MENU_CLOSE, ClubAnnouncementDialog_OnClose )
}

void function OpenViewAnnouncementDialog()
{
	if ( !IsConnected() )
		return

	if ( !IsLobby() )
		return
	
	if ( IsDialog( GetActiveMenu() ) )
		return

	file.dialogState = eDialogState.VIEW

	ConfigureAnnouncementDialog()

	if ( file.announcement.eventText == "" )
		return

	var contentRui = Hud_GetRui( file.dialogContent )
	RuiSetString( contentRui, "messageText", file.announcement.eventText )

	string timeString = "[" + GetTimeString( file.announcement.eventTime ) + "]"
	string timeStampString = Localize( "#CLUB_ANNOUNCEMENT_TIMESTAMP", file.announcement.memberName, timeString )
	RuiSetString( contentRui, "timeStampText", timeStampString )

	Hud_Hide( file.textEntry )
	Hud_Hide( file.textEntryBkg )

	ConfigureFooters()
	AdvanceMenu( file.menu )
	                                                                                                                                                  
}

void function OpenSubmitAnnouncementDialog()
{
	if ( IsDialog( GetActiveMenu() ) )
		return

	int lastStickyTime = ClubGetStickyNote().eventTime
	int fakeTimeDays   = GetFakeTimeInSeconds()
	int currentTime    = GetUnixTimestamp() - fakeTimeDays
	int timeDelta      = currentTime - lastStickyTime
	int minutesPassed  = timeDelta/ 60
	if ( lastStickyTime > 0 )
	{
		if ( minutesPassed < CLUB_ANNOUNCE_COOLDOWN_MINUTES )
		{
			                                    
			                                   
			{
				Clubs_OpenClubAnnouncementCooldownDialog()
				return
			}
		}
	}

	file.dialogState = eDialogState.SUBMIT

	ConfigureAnnouncementDialog()

	var contentRui = Hud_GetRui( file.dialogContent )
	RuiSetString( contentRui, "messageText", "" )
	RuiSetString( contentRui, "timeStampText", "" )

	Hud_Show( file.textEntry )
	Hud_Show( file.textEntryBkg )
	Hud_SetUTF8Text( file.textEntry, Localize( "#CLUB_ANNOUNCEMENT_GUIDE" ) )

	file.hasTextChanged = false

	ConfigureFooters()
	AdvanceMenu( file.menu )
}

                                                     
   
  	                                                      
  	                                                       
  
  	                                     
  		      
  
  	                                                              
  
  	                          
  	                             
  
  	                          
  	                                                                                                                                                    
  	                                                                                                                                                                        
   

void function ConfirmSubmitButton_OnActivate( var button )
{
	if ( !file.hasTextChanged )
		return

	file.announceString = Hud_GetUTF8Text( file.textEntry )
	if ( file.announceString.len() == 0 )
		return

	foreach( string illegalChar in ILLEGAL_CHAT_CHARS )
	{
		file.announceString = RegexpReplace( file.announceString, illegalChar, "" )
	}

	ClubChatStickyNote( file.announceString )
	SetLastViewedAnnouncementTimeToNow()
	EmitUISound( "UI_Menu_Clubs_SendAnnouncement" )
	CloseClubAnnouncementDialog()
}

void function CancelSubmitButton_OnActivate( var button )
{
	CloseClubAnnouncementDialog()
}

void function ConfigureAnnouncementDialog()
{
	file.announcement = ClubGetStickyNote()
	                                          
	  	      

	ClubHeader clubHeader = ClubGetHeader()
	string headerText = Localize( "#CLUB_ANNOUNCEMENT_TITLE", clubHeader.name )
	var contentRui = Hud_GetRui( file.dialogContent )
	RuiSetString( contentRui, "headerText", headerText )

	thread ConfigureClubLogoThread( clubHeader )
}

void function ConfigureClubLogoThread( ClubHeader clubHeader )
{
	WaitFrame()
	printf( "AnnouncementDebug: %s(): Converting logostring %s to logo", FUNC_NAME(), clubHeader.logoString )
	ClubLogo clubLogo = ClubLogo_ConvertLogoStringToLogo( clubHeader.logoString )
	var logoAnchorRui = Hud_GetRui( file.clubLogoAnchor )
	var logo = ClubLogoUI_CreateNestedClubLogo( logoAnchorRui, "clubLogo", clubLogo )
}

void function ConfigureFooters()
{
	int buttonCount
	if ( file.dialogState == eDialogState.VIEW )
	{
		                                         
		buttonCount = 1
		SetGamepadCursorEnabled( file.menu, false )
		SetAllowControllerFooterClick( file.menu, false )
	}
	else
	{
		                                          
		buttonCount = 2
		SetGamepadCursorEnabled( file.menu, true )
		SetAllowControllerFooterClick( file.menu, true )
	}

	UISize panelSize = REPLACEHud_GetSize( file.footer )
	UISize buttonSize = REPLACEHud_GetSize( Hud_GetChild( file.footer, "LeftRuiFooterButton0" ) )
	int marginSize = panelSize.width - (buttonSize.width*2)

	var parentObj    = Hud_GetParent( file.footer )
	UISize ownerSize = REPLACEHud_GetSize( parentObj )
	UIPos ownerPos   = REPLACEHud_GetAbsPos( parentObj )

	int xPos = ownerPos.x + ((buttonSize.width/2) + (marginSize/2))

	                                                      
	                                                                                                                                           
	                                                                                                                                              

	if ( file.dialogState == eDialogState.VIEW )
		Hud_SetPos( file.footer, xPos, file.footerY )
	else
		Hud_SetPos( file.footer, file.footerX, file.footerY )
}

void function ClubAnnouncementDialog_OnOpen()
{
	ClearMenuFooterOptions( file.menu )

	SetLastViewedAnnouncementTimeToNow()

	AddMenuFooterOption( file.menu, LEFT, BUTTON_A, true, "#A_BUTTON_ACCEPT", "#CLUB_ANNOUNCEMENT_ACCEPT", ConfirmViewedButton_OnActivate, IsInViewMode )

	AddMenuFooterOption( file.menu, LEFT, BUTTON_Y, true, "#CLUB_ANNOUNCEMENT_DIALOG_SUBMIT_CONSOLE", "#CLUB_ANNOUNCEMENT_DIALOG_SUBMIT", ConfirmSubmitButton_OnActivate, IsInSubmitMode )
	AddMenuFooterOption( file.menu, LEFT, BUTTON_B, true, "#CLUB_JOIN_REQUEST_CANCEL", "#CLUB_JOIN_REQUEST_CANCEL_PC", CancelSubmitButton_OnActivate, IsInSubmitMode )
}

void function ClubAnnouncementDialog_OnClose()
{
	SocialEventUpdate()
}

void function AnnouncementText_OnChanged( var button )
{
	if ( file.hasTextChanged == false )
		file.hasTextChanged = true
}

bool function IsInViewMode()
{
	return file.dialogState == eDialogState.VIEW
}

bool function CanSubmitAnnouncement()
{
	return IsInSubmitMode()
}

bool function IsInSubmitMode()
{
	return file.dialogState == eDialogState.SUBMIT
}

void function ConfirmViewedButton_OnActivate( var button )
{
	CloseClubAnnouncementDialog()
}

void function CloseClubAnnouncementDialog()
{
	if ( GetActiveMenu() != file.menu )
		return

	CloseActiveMenu()
}