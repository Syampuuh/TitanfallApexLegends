global function InitLobbyMenu
global function Lobby_SetTempSeasonExtensionButtonVisible

global function Lobby_IsInputBlocked
global function SetActiveLobbyPopup
global function ClearActiveLobbyPopup
global function HasActiveLobbyPopup
global function SetNewsButtonTooltip

                 
global function Lobby_EnableMinimapCoordsOnConnect
      

global struct LobbyPopup
{
	bool functionref( int inputID ) checkBlocksInput
	bool functionref( int inputID ) handleInput
	void functionref()              onClose
}

struct
{
	var  menu
	bool updatingLobbyUI = false
	bool inputsRegistered = false
	bool tabsInitialized = false
	bool newnessInitialized = false

	var postGameButton
	var newsButton
	var newsButtonStatusIcon
	var socialButton
	var gameMenuButton
	var bonusXp
	var tempSeasonExtensionButton
	var socialEventPopup
	var serverDebugID
	var dx12BetaText

	string previousRotationGroup
	int previousArenaRotationGroup = -1

	bool firstSessionEntry = true
	string lastPlayedAudioPlaylist = ""

	LobbyPopup ornull  activeLobbyPopup = null
	table< int, bool > isInputBlocked
} file

                 
void function Lobby_EnableMinimapCoordsOnConnect( string name )
{
	int forceWatermarkInLobby = GetCurrentPlaylistVarInt( "force_watermark_in_lobby", 0 )                               
	int forceHiddenWatermarkInLobby = GetCurrentPlaylistVarInt( "force_hidden_watermark_in_lobby", 0 )                               
	if ( (forceWatermarkInLobby == 0 && IsTakeHomeBuild()) || forceWatermarkInLobby == 1 )
	{
		var minimapCoords = Hud_GetChild( file.menu, "MinimapCoords" )
		Hud_SetVisible( minimapCoords, true )
		Hud_SetEnabled( minimapCoords, true )

		var minimapCoordsRui = Hud_GetRui( minimapCoords )
		InitializeMinimapCoords( minimapCoordsRui, true )
		RuiSetString( minimapCoordsRui, "name", name )

		float watermarkTextScale = GetCurrentPlaylistVarFloat( "watermark_text_scale", 0.5 )
		float watermarkAlphaScale = GetCurrentPlaylistVarFloat( "watermark_alpha_scale", 0.2 )
		RuiSetFloat( minimapCoordsRui, "watermarkTextScale", watermarkTextScale )
		RuiSetFloat( minimapCoordsRui, "watermarkAlphaScale", watermarkAlphaScale )
	}
	if ( (forceHiddenWatermarkInLobby == 0 && IsTakeHomeBuild()) || forceHiddenWatermarkInLobby == 1 )
	{
		var minimapID = Hud_GetChild( file.menu, "MinimapID" )
		Hud_SetVisible( minimapID, true )
		Hud_SetEnabled( minimapID, true )

		var minimapIDRui = Hud_GetRui( minimapID )
		RuiSetString( minimapIDRui, "name", GetPlayerName() )
		RuiSetString( minimapIDRui, "uid", GetUIDHex() )
	}
}

void function Lobby_RefreshMinimapCoords()
{
	if ( IsLobby() && IsFullyConnected() )
	{
		Lobby_EnableMinimapCoordsOnConnect( GetPlayerName() )
	}
}
      

void function InitLobbyMenu( var newMenuArg )
                                              
{
	var menu = GetMenu( "LobbyMenu" )
	file.menu = menu

	RegisterSignal( "LobbyMenuUpdate" )
	
                 
	AddUICallback_OnResolutionChanged( Lobby_RefreshMinimapCoords )
      

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnLobbyMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnLobbyMenu_Close )

	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnLobbyMenu_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, OnLobbyMenu_Hide )

	AddMenuEventHandler( menu, eUIEvent.MENU_GET_TOP_LEVEL, OnLobbyMenu_GetTopLevel )
	                                                                                     

	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnLobbyMenu_NavigateBack )

	AddMenuVarChangeHandler( "isFullyConnected", UpdateFooterOptions )
	AddMenuVarChangeHandler( "isPartyLeader", UpdateFooterOptions )
	#if DURANGO_PROG
		AddMenuVarChangeHandler( "DURANGO_canInviteFriends", UpdateFooterOptions )
		AddMenuVarChangeHandler( "DURANGO_isJoinable", UpdateFooterOptions )
	#elseif PLAYSTATION_PROG
		AddMenuVarChangeHandler( "PS4_canInviteFriends", UpdateFooterOptions )
	#elseif PC_PROG
		AddMenuVarChangeHandler( "ORIGIN_isEnabled", UpdateFooterOptions )
		AddMenuVarChangeHandler( "ORIGIN_isJoinable", UpdateFooterOptions )
	#elseif NX_PROG
		AddMenuVarChangeHandler( "NX_canInviteFriends", UpdateFooterOptions )
	#endif

	var postGameButton = Hud_GetChild( menu, "PostGameButton" )
	file.postGameButton = postGameButton
	ToolTipData postGameToolTip
	postGameToolTip.descText = "#MATCH_SUMMARY"
	Hud_SetToolTipData( postGameButton, postGameToolTip )
	HudElem_SetRuiArg( postGameButton, "icon", $"rui/menu/lobby/postgame_icon" )
	HudElem_SetRuiArg( postGameButton, "shortcutText", "%[BACK|TAB]%" )
	Hud_AddEventHandler( postGameButton, UIE_CLICK, PostGameButton_OnActivate )

	var newsButton = Hud_GetChild( menu, "NewsButton" )
	file.newsButton = newsButton
	file.newsButtonStatusIcon = Hud_GetChild( menu, "NewsButtonStatusIcon" )
	ToolTipData newsToolTip
	newsToolTip.descText = "#NEWS"
	Hud_SetToolTipData( newsButton, newsToolTip )
	HudElem_SetRuiArg( newsButton, "icon", $"rui/menu/lobby/news_icon" )
	HudElem_SetRuiArg( newsButton, "shortcutText", "%[R_TRIGGER|ESCAPE]%" )
	Hud_AddEventHandler( newsButton, UIE_CLICK, NewsButton_OnActivate )

	var socialButton = Hud_GetChild( menu, "SocialButton" )
	file.socialButton = socialButton
	ToolTipData socialToolTip
	socialToolTip.descText = "#MENU_TITLE_FRIENDS"
	Hud_SetToolTipData( socialButton, socialToolTip )
	HudElem_SetRuiArg( socialButton, "icon", $"rui/menu/lobby/friends_icon" )
	HudElem_SetRuiArg( socialButton, "shortcutText", "%[STICK2|]%" )
	Hud_AddEventHandler( socialButton, UIE_CLICK, SocialButton_OnActivate )

	var gameMenuButton = Hud_GetChild( menu, "GameMenuButton" )
	file.gameMenuButton = gameMenuButton
	ToolTipData gameMenuToolTip
	gameMenuToolTip.descText = "#GAME_MENU"
	Hud_SetToolTipData( gameMenuButton, gameMenuToolTip )
	HudElem_SetRuiArg( gameMenuButton, "icon", $"rui/menu/lobby/settings_icon" )
	HudElem_SetRuiArg( gameMenuButton, "shortcutText", "%[START|ESCAPE]%" )
	Hud_AddEventHandler( gameMenuButton, UIE_CLICK, GameMenuButton_OnActivate )

	var bonusXp = Hud_GetChild( menu, "BonusXp" )
	file.bonusXp = bonusXp

	var tempSeasonExtensionButton = Hud_GetChild( menu, "TEMPTab0ButtonExtender" )
	file.tempSeasonExtensionButton = tempSeasonExtensionButton
	Hud_AddEventHandler( tempSeasonExtensionButton, UIE_CLICK, SeasonTab_OnActivate )

	var socialEventPopup = Hud_GetChild( menu, "SocialPopupPanel" )
	file.socialEventPopup = socialEventPopup

	var serverDebugID = Hud_GetChild( menu, "LobbyServerIDText" )
	file.serverDebugID = serverDebugID

	var dx12BetaText = Hud_GetChild( menu, "DirectX12BetaText" )
	file.dx12BetaText = dx12BetaText

	InitSocialEventPopup( socialEventPopup )

	PerfInitLabel( 1, "1" )
	PerfInitLabel( 2, "2" )
	PerfInitLabel( 3, "3" )
	PerfInitLabel( 4, "4" )
	PerfInitLabel( 5, "5" )
	PerfInitLabel( 6, "6" )
}


void function OnLobbyMenu_Open()
{
	if ( !file.tabsInitialized )
	{
		array<var> panels = GetAllMenuPanels( file.menu )
		foreach ( panel in panels )
		{
			AddTab( file.menu, panel, GetPanelTabTitle( panel ) )
		}

		TabData tabData = GetTabDataForPanel( file.menu )

		tabData.customFirstTabButton = true
		tabData.groupNavHints = true
		tabData.activeTabIdx = GetLobbyDefaultTabIndex()

		file.tabsInitialized = true
	}

	if ( GetLastMenuNavDirection() == MENU_NAV_FORWARD )
	{
		TabData tabData = GetTabDataForPanel( file.menu )
		ActivateTab( tabData, GetLobbyDefaultTabIndex() )
	}
	else
	{
		TabData tabData = GetTabDataForPanel( file.menu )
		ActivateTab( tabData, tabData.activeTabIdx )
	}

	UpdateNewnessCallbacks()

	thread UpdateLobbyUI()

	Lobby_UpdatePlayPanelPlaylists()

	AddCallbackAndCallNow_OnGRXOffersRefreshed( OnGRXStateChanged )
	AddCallbackAndCallNow_OnGRXInventoryStateChanged( OnGRXStateChanged )
}


void function Lobby_SetTempSeasonExtensionButtonVisible( bool state )
{
	Hud_SetVisible( file.tempSeasonExtensionButton, state )
}


void function OnLobbyMenu_Show()
{
	thread LobbyMenuUpdate()
	SocialEventUpdate()
	RegisterInputs()
	Chroma_Lobby()
}


void function OnLobbyMenu_GetTopLevel()
{
	thread TryRunDialogFlowThread()
}


void function OnLobbyMenu_Hide()
{
	Signal( uiGlobal.signalDummy, "LobbyMenuUpdate" )
	ClearActiveLobbyPopup()
	DeregisterInputs()
}


void function OnLobbyMenu_Close()
{
	ClearActiveLobbyPopup()
	ClearNewnessCallbacks()
	DeregisterInputs()

	RemoveCallback_OnGRXOffersRefreshed( OnGRXStateChanged )
	RemoveCallback_OnGRXInventoryStateChanged( OnGRXStateChanged )
}


void function OnGRXStateChanged()
{
	bool ready = GRX_IsInventoryReady() && GRX_AreOffersReady()

	array<var> panels = [
		GetPanel( "SeasonPanel" ),
		GetPanel( "CharactersPanel" ),
		GetPanel( "ArmoryPanel" ),
		GetPanel( "StorePanel" ),
	]

	foreach ( var panel in panels )
	{
		SetPanelTabEnabled( panel, ready )
	}

	TabData tabData     = GetTabDataForPanel( file.menu )
	TabDef seasonTabDef = Tab_GetTabDefByBodyName( tabData, "SeasonPanel" )

	ItemFlavor season = GetLatestSeason( GetUnixTimestamp() )
	HudElem_SetRuiArg( seasonTabDef.button, "seasonHeader", Season_GetShortName( season ) )
	HudElem_SetRuiArg( seasonTabDef.button, "seasonTitle", "#SEASON_HUB" )
	HudElem_SetRuiArg( seasonTabDef.button, "seasonDate", Season_GetTimeRemainingText( season ) )
	HudElem_SetRuiArg( seasonTabDef.button, "smallLogo", Season_GetSmallLogo( season ), eRuiArgType.IMAGE )
	HudElem_SetRuiArg( seasonTabDef.button, "bannerImage", Season_GetLobbyButtonImage( season ), eRuiArgType.IMAGE )

	HudElem_SetRuiArg( seasonTabDef.button, "titleTextColor", Season_GetTitleTextColor( season ), eRuiArgType.COLOR )
	HudElem_SetRuiArg( seasonTabDef.button, "headerTextColor", Season_GetHeaderTextColor( season ), eRuiArgType.COLOR )
	HudElem_SetRuiArg( seasonTabDef.button, "timeRemainingTextColor", Season_GetTimeRemainingTextColor( season ), eRuiArgType.COLOR )
	
	#if NX_PROG || PC_PROG_NX_UI
		HudElem_SetRuiArg( seasonTabDef.button, "tabsNXOffset", 1.0, eRuiArgType.FLOAT )
	#endif
	
	seasonTabDef.useCustomColors = true
	seasonTabDef.customDefaultBGCol = Season_GetTabBGDefaultCol( season )
	seasonTabDef.customDefaultBarCol = Season_GetTabBarDefaultCol( season )
	seasonTabDef.customFocusedBGCol = Season_GetTabBGFocusedCol( season )
	seasonTabDef.customFocusedBarCol = Season_GetTabBarFocusedCol( season )
	seasonTabDef.customSelectedBGCol = Season_GetTabBGSelectedCol( season )
	seasonTabDef.customSelectedBarCol = Season_GetTabBarSelectedCol( season )

	if ( ready )
	{
		if ( ShouldShowPremiumCurrencyDialog() )
			ShowPremiumCurrencyDialog( false )

		ItemFlavor ornull activeCollectionEvent = GetActiveCollectionEvent( GetUnixTimestamp() )
		bool haveActiveCollectionEvent          = (activeCollectionEvent != null)
		ItemFlavor ornull activeThemedShopEvent = GetActiveThemedShopEvent( GetUnixTimestamp() )
		bool haveActiveThemedShopEvent          = (activeThemedShopEvent != null)

		if ( haveActiveCollectionEvent )
		{
			expect ItemFlavor( activeCollectionEvent )
			if ( CollectionEvent_HasLobbyTheme( activeCollectionEvent ) )
			{
				HudElem_SetRuiArg( seasonTabDef.button, "seasonHeader", "#COLLECTION_EVENT" )
				HudElem_SetRuiArg( seasonTabDef.button, "seasonTitle", CollectionEvent_GetFrontTabText( activeCollectionEvent ) )
				HudElem_SetRuiArg( seasonTabDef.button, "seasonDate", CalEvent_GetTimeRemainingText( activeCollectionEvent ) )
				                                                                                                         
				                                                                                                                           

				                                                                                                                   
				                                                                                                                     
			}
		}
		else if ( haveActiveThemedShopEvent )
		{
			expect ItemFlavor( activeThemedShopEvent )
			if ( ThemedShopEvent_HasLobbyTheme( activeThemedShopEvent ) )
			{
				HudElem_SetRuiArg( seasonTabDef.button, "seasonHeader", "#CURRENT_EVENT" )
				HudElem_SetRuiArg( seasonTabDef.button, "seasonTitle", ThemedShopEvent_GetTabText( activeThemedShopEvent ) )
				HudElem_SetRuiArg( seasonTabDef.button, "seasonDate", CalEvent_GetTimeRemainingText( activeThemedShopEvent ) )
				                                                                                                                                  
			}
		}
	}
}


void function UpdateNewnessCallbacks()
{
	ClearNewnessCallbacks()

	Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.SeasonTab, OnNewnessQueryChangedUpdatePanelTab, GetPanel( "SeasonPanel" ) )
	Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.GladiatorTab, OnNewnessQueryChangedUpdatePanelTab, GetPanel( "CharactersPanel" ) )
	Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.ArmoryTab, OnNewnessQueryChangedUpdatePanelTab, GetPanel( "ArmoryPanel" ) )
	Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.StoreTab, OnNewnessQueryChangedUpdatePanelTab, GetPanel( "StorePanel" ) )
	file.newnessInitialized = true
}


void function ClearNewnessCallbacks()
{
	if ( !file.newnessInitialized )
		return

	Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.SeasonTab, OnNewnessQueryChangedUpdatePanelTab, GetPanel( "SeasonPanel" ) )
	Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.GladiatorTab, OnNewnessQueryChangedUpdatePanelTab, GetPanel( "CharactersPanel" ) )
	Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.ArmoryTab, OnNewnessQueryChangedUpdatePanelTab, GetPanel( "ArmoryPanel" ) )
	Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.StoreTab, OnNewnessQueryChangedUpdatePanelTab, GetPanel( "StorePanel" ) )
	file.newnessInitialized = false
}


void function UpdateLobbyUI()
{
	if ( file.updatingLobbyUI )
		return

	file.updatingLobbyUI = true

	thread UpdateMatchmakingStatus()

	WaitSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )
	file.updatingLobbyUI = false
}


void function LobbyMenuUpdate()
{
	Signal( uiGlobal.signalDummy, "LobbyMenuUpdate" )
	EndSignal( uiGlobal.signalDummy, "LobbyMenuUpdate" )
	EndSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )

	while ( true )
	{
		PlayPanelUpdate()
		UpdateCornerButtons()
		UpdateTabs()
		TrackPlaylistRotation()
		HandleCrossplayPartyInvalid()
		UpdateBonusXP()

		WaitFrame()
	}
}

void function UpdateBonusXP()
{
	float boostCount 		= 0.0
	Party party = GetParty()

	foreach ( member in party.members )
	{
		boostCount += Clamp(member.boostCount * 0.1, 0.0, 3.0)
	}

	int rarity = 3
	int boostPercentage =  int(boostCount * 100)
	bool isVisible = boostCount > 0

	if( isVisible )
	{
		ToolTipData bonusXpTooltip
		bonusXpTooltip.titleText = Localize( "#BONUS_XP_TITLE" )
		bonusXpTooltip.rarity    = 3
		bonusXpTooltip.descText  = Localize( "#BONUS_XP_DESC", boostPercentage )
		Hud_SetToolTipData( file.bonusXp, bonusXpTooltip )
	}
	else
	{
		Hud_ClearToolTipData(file.bonusXp)
	}


	var rui = Hud_GetRui( file.bonusXp )
	RuiSetBool(rui, "isVisible", isVisible)
	RuiSetInt(rui, "rarity", rarity)
	RuiSetInt(rui, "boostPercentage", boostPercentage)

	var playPanel           = GetPanel( "PlayPanel" )
	bool isPlayPanelActive  = IsTabPanelActive( playPanel )

	Hud_SetVisible( file.bonusXp, isVisible && isPlayPanelActive )
}

void function HandleCrossplayPartyInvalid()
{
	                                                                             
	if ( GetPersistentVar( "showGameSummary" ) && IsPostGameMenuValid( true ) )
		return

	if ( CrossplayUserOptIn() || GetPartySize() == 1 )
		return

	if( IsDialog( GetActiveMenu() ) )
		return

	                                                                                            
	string hardware   = GetUnspoofedPlayerHardware()
	Party myParty     = GetParty()
	foreach ( p in myParty.members )
	{
		if ( hardware != p.hardware )
		{
			LeaveParty()

			ConfirmDialogData data
			data.headerText = "#CROSSPLAY_DIALOG_INVALID_PARTY_HEADER"
			data.messageText = Localize( "#CROSSPLAY_DIALOG_INVALID_PARTY_MSG" )

			OpenOKDialogFromData( data )
			break
		}
	}
}


void function TrackPlaylistRotation()
{
	if ( file.previousRotationGroup == "" )
		file.previousRotationGroup = GetPlaylistRotationGroup()

	if ( file.previousArenaRotationGroup == -1 )
		file.previousArenaRotationGroup = GetPlaylistActiveMapRotationIndex( "survival_arenas" )

	if ( file.previousRotationGroup != GetPlaylistRotationGroup() || file.previousArenaRotationGroup != GetPlaylistActiveMapRotationIndex( "survival_arenas" ))
	{
		file.previousRotationGroup = GetPlaylistRotationGroup()
		file.previousArenaRotationGroup = GetPlaylistActiveMapRotationIndex( "survival_arenas" )

		if ( IsModeSelectMenuOpen() )
		{
			                            
			                              
			if ( PrivateMatchMapSelect_IsEnabled() )
				UpdatePrivateMatchMapSelectDialog()
			else if ( GamemodeSelect_IsEnabled() )
				UpdateOpenModeSelectDialog()
		}
	}

	string selectedPlaylist = Lobby_GetSelectedPlaylist()
	string rotationGroup    = GetPlaylistVarString( selectedPlaylist, "playlist_rotation_group", "" )
	if ( ! Lobby_IsPlaylistAvailable( selectedPlaylist ) && ! AreWeMatchmaking() && rotationGroup != "" )
	{
		                                            
		                                                                           
		string uiSlot      = GetPlaylistVarString( selectedPlaylist, "ui_slot", "" )
		string newPlaylist = GetCurrentPlaylistInUiSlot( uiSlot )
		if ( newPlaylist == "" || !Lobby_IsPlaylistAvailable( newPlaylist ) )
			newPlaylist = GetDefaultPlaylist()

		string mapChangeAlias = GetPlaylistVarString( newPlaylist, "map_change_VO_alias", "" )
		if ( mapChangeAlias != "" && file.lastPlayedAudioPlaylist != mapChangeAlias )
		{
			file.lastPlayedAudioPlaylist = mapChangeAlias
			PlayLobbyCharacterDialogue( mapChangeAlias )
		}
		Lobby_SetSelectedPlaylist( newPlaylist )
	}
}


void function UpdateCornerButtons()
{
	var playPanel           = GetPanel( "PlayPanel" )
	bool isPlayPanelActive  = IsTabPanelActive( playPanel )
	var postGameButton      = Hud_GetChild( file.menu, "PostGameButton" )
	bool showPostGameButton = isPlayPanelActive && IsPostGameMenuValid()
	Hud_SetVisible( postGameButton, showPostGameButton )
	if ( showPostGameButton )
		Hud_SetX( postGameButton, Hud_GetBaseX( postGameButton ) )
	else
		Hud_SetX( postGameButton, Hud_GetBaseX( postGameButton ) - Hud_GetWidth( postGameButton ) - Hud_GetBaseX( postGameButton ) )

	Hud_SetVisible( file.newsButton, isPlayPanelActive )
	Hud_SetVisible( file.newsButtonStatusIcon, isPlayPanelActive )
	Hud_SetVisible( file.socialButton, isPlayPanelActive )
	Hud_SetVisible( file.gameMenuButton, isPlayPanelActive )
	Hud_SetVisible( file.bonusXp, isPlayPanelActive )

	var accessibilityHint = Hud_GetChild( playPanel, "AccessibilityHint" )
	Hud_SetVisible( accessibilityHint, isPlayPanelActive && IsAccessibilityChatHintEnabled() && !VoiceIsRestricted() && (GetPartySize() > 1) )

	Hud_SetEnabled( file.gameMenuButton, !IsDialog( GetActiveMenu() ) )

	int count = GetOnlineFriendCount( )
	if ( count > 0 )
	{
		HudElem_SetRuiArg( file.socialButton, "buttonText", "" + count )
		Hud_SetWidth( file.socialButton, Hud_GetBaseWidth( file.socialButton ) * 2 )
		InitButtonRCP( file.socialButton )
	}
	else
	{
		HudElem_SetRuiArg( file.socialButton, "buttonText", "" )
		Hud_ReturnToBaseSize( file.socialButton )
		InitButtonRCP( file.socialButton )
	}

	Hud_SetPinSibling(file.bonusXp, "PostGameButton")

	string str = (( IsNetGraphEnabled() && isPlayPanelActive ) ? Localize( "#NETGRAPH_SERVERID", GetServerDebugId() ) : "")
	Hud_SetText( file.serverDebugID, str )

	Hud_SetText( file.dx12BetaText, IsDirectX12Beta() ? Localize( "#DIRECTX12_BETA" ) : "" )
}


void function UpdateTabs()
{
	if ( IsFullyConnected() )
	{
		                                                                      
	}            
}


void function RegisterInputs()
{
	if ( file.inputsRegistered )
		return

	RegisterButtonPressedCallback( BUTTON_START, GameMenuButton_OnActivate )
	RegisterButtonPressedCallback( BUTTON_BACK, PostGameButton_OnActivate )
	RegisterButtonPressedCallback( BUTTON_X, ButtonX_OnActivate )
	RegisterButtonPressedCallback( BUTTON_Y, ButtonY_OnActivate )
	RegisterButtonPressedCallback( BUTTON_STICK_LEFT, ButtonStickL_OnActivate )
	RegisterButtonPressedCallback( KEY_Y, KeyY_OnActivate )
	RegisterButtonPressedCallback( KEY_N, KeyN_OnActivate )
	RegisterButtonPressedCallback( KEY_B, KeyB_OnActivate )

	RegisterButtonPressedCallback( KEY_TAB, SeasonTab_OnActivate )
	RegisterButtonPressedCallback( KEY_ENTER, OnLobbyMenu_FocusChat )
	RegisterButtonPressedCallback( BUTTON_TRIGGER_RIGHT, NewsButton_OnActivate )
	RegisterButtonPressedCallback( BUTTON_STICK_RIGHT, SocialButton_OnActivate )
	file.inputsRegistered = true
}


void function DeregisterInputs()
{
	if ( !file.inputsRegistered )
		return

	DeregisterButtonPressedCallback( BUTTON_START, GameMenuButton_OnActivate )
	DeregisterButtonPressedCallback( BUTTON_BACK, PostGameButton_OnActivate )
	DeregisterButtonPressedCallback( BUTTON_X, ButtonX_OnActivate )
	DeregisterButtonPressedCallback( BUTTON_Y, ButtonY_OnActivate )
	DeregisterButtonPressedCallback( BUTTON_STICK_LEFT, ButtonStickL_OnActivate )
	DeregisterButtonPressedCallback( KEY_Y, KeyY_OnActivate )
	DeregisterButtonPressedCallback( KEY_N, KeyN_OnActivate )
	DeregisterButtonPressedCallback( KEY_B, KeyB_OnActivate )

	DeregisterButtonPressedCallback( KEY_TAB, SeasonTab_OnActivate )
	DeregisterButtonPressedCallback( KEY_ENTER, OnLobbyMenu_FocusChat )
	DeregisterButtonPressedCallback( BUTTON_TRIGGER_RIGHT, NewsButton_OnActivate )
	DeregisterButtonPressedCallback( BUTTON_STICK_RIGHT, SocialButton_OnActivate )
	file.inputsRegistered = false
}


void function SeasonTab_OnActivate( var button )
{
	TabData tabData = GetTabDataForPanel( file.menu )

	if ( !IsTabIndexEnabled( tabData, Tab_GetTabIndexByBodyName( tabData, "SeasonPanel" ) ) )
		return

	if ( IsDialog( GetActiveMenu() ) )
		return

	if ( !IsTabPanelActive( GetPanel( "PlayPanel" ) ) )
		return

	JumpToSeasonTab()
}

void function NewsButton_OnActivate( var button )
{
	if ( PromoDialog_CanShow() )
		AdvanceMenu( GetMenu( "PromoDialogUM" ) )
}


void function SocialButton_OnActivate( var button )
{
	if ( IsDialog( GetActiveMenu() ) )
		return

	if ( !IsTabPanelActive( GetPanel( "PlayPanel" ) ) )
		return

	#if PC_PROG
		if ( !MeetsAgeRequirements() )
		{
			ConfirmDialogData dialogData
			dialogData.headerText = "#UNAVAILABLE"
			dialogData.messageText = "#ORIGIN_UNDERAGE_ONLINE"
			dialogData.contextImage = $"ui/menu/common/dialog_notice"

			OpenOKDialogFromData( dialogData )
			return
		}
	#endif

	AdvanceMenu( GetMenu( "SocialMenu" ) )
}


void function GameMenuButton_OnActivate( var button )
{
	if ( InputIsButtonDown( BUTTON_STICK_LEFT ) )                             
		return

	if ( IsDialog( GetActiveMenu() ) )
		return

	AdvanceMenu( GetMenu( "SystemMenu" ) )
}


void function PostGameButton_OnActivate( var button )
{
	if ( IsDialog( GetActiveMenu() ) )
		return

	if ( !IsTabPanelActive( GetPanel( "PlayPanel" ) ) )
		return

	thread OnLobbyMenu_PostGameOrChat( button )
}


void function OnLobbyMenu_NavigateBack()
{
	                                                                     
	                                                                               
	   
	  	                       
	  	      
	   

	if ( GetMenuActiveTabIndex( file.menu ) == 1 )
	{
		if ( !IsControllerModeActive() )
			AdvanceMenu( GetMenu( "SystemMenu" ) )
	}
	else
	{
		TabData tabData = GetTabDataForPanel( file.menu )
		ActivateTab( tabData, GetLobbyDefaultTabIndex() )
		UpdateMenuTabs()
	}
}


int function GetLobbyDefaultTabIndex()
{
	TabData lobbyTabData = GetTabDataForPanel( GetMenu( "LobbyMenu" ) )
	return Tab_GetTabIndexByBodyName( lobbyTabData, "PlayPanel" )
}


void function OnLobbyMenu_PostGameOrChat( var button )
{
	var savedMenu = GetActiveMenu()

	#if CONSOLE_PROG
		const float HOLD_FOR_CHAT_DELAY = 1.0
		float startTime = UITime()
		while ( !VoiceIsRestricted() && (InputIsButtonDown( BUTTON_BACK ) || InputIsButtonDown( KEY_TAB ) && GetConVarInt( "hud_setting_accessibleChat" ) != 0) )
		{
			if ( UITime() - startTime > HOLD_FOR_CHAT_DELAY )
			{
				if ( GetPartySize() > 1 )
				{
					printt( "starting message mode", Hud_IsEnabled( GetLobbyChatBox() ) )
					Hud_StartMessageMode( GetLobbyChatBox() )
				}
				else
				{
					ConfirmDialogData dialogData
					dialogData.headerText = "#ACCESSIBILITY_NO_CHAT_HEADER"
					dialogData.messageText = "#ACCESSIBILITY_NO_CHAT_MESSAGE"
					dialogData.contextImage = $"ui/menu/common/dialog_notice"

					OpenOKDialogFromData( dialogData )
				}
				return
			}

			WaitFrame()
		}
	#endif

	if ( IsPostGameMenuValid() && savedMenu == GetActiveMenu() )
	{
		thread PostGameFlow()
	}
}


void function PostGameFlow()
{
                        
		bool showArenasRankedSummary = GetPersistentVarAsInt( "showArenasRankedSummary" ) != 0
       
	bool showRankedSummary = GetPersistentVarAsInt( "showRankedSummary" ) != 0
	bool isFirstTime       = GetPersistentVarAsInt( "showGameSummary" ) != 0

	OpenPostGameMenu( null )

	if ( GetActiveBattlePass() != null )
	{
		OpenPostGameBattlePassMenu( isFirstTime )
	}

	if ( showRankedSummary )
	{
		OpenRankedSummary( isFirstTime )
	}

                        
		if ( showArenasRankedSummary )
		{
			Assert( !showRankedSummary, "trying to show both ranked and arenas ranked post game summaries. Persistence vars were probably set manually or via dev functions." )
			OpenArenasRankedSummary( true )
		}
       
}


void function OnLobbyMenu_FocusChat( var panel )
{
	#if PC_PROG
		if ( IsDialog( GetActiveMenu() ) )
			return

		if ( !IsTabPanelActive( GetPanel( "PlayPanel" ) ) )
			return

		if ( GetPartySize() > 1 )
		{
			var playPanel = Hud_GetChild( file.menu, "PlayPanel" )
			var textChat  = Hud_GetChild( playPanel, "ChatRoomTextChat" )
			Hud_SetFocused( Hud_GetChild( textChat, "ChatInputLine" ) )
		}
	#endif
}


bool function Lobby_IsInputBlocked( int inputID )
{
	if ( file.activeLobbyPopup == null )
		return false

	LobbyPopup ornull lobbyPopup = file.activeLobbyPopup
	expect LobbyPopup( lobbyPopup )
	return lobbyPopup.checkBlocksInput( inputID )
}


void function ButtonB_OnActivate( var button )
{
	DispatchLobbyPopupInput( BUTTON_B )
}


void function KeyEscape_OnActivate( var button )
{
	DispatchLobbyPopupInput( KEY_ESCAPE )
}


void function ButtonX_OnActivate( var button )
{
	DispatchLobbyPopupInput( BUTTON_X )
}


void function ButtonY_OnActivate( var button )
{
	DispatchLobbyPopupInput( BUTTON_Y )
}


void function ButtonStickL_OnActivate( var button )
{
	DispatchLobbyPopupInput( BUTTON_STICK_RIGHT )
}


void function KeyY_OnActivate( var button )
{
	DispatchLobbyPopupInput( KEY_Y )
}


void function KeyN_OnActivate( var button )
{
	DispatchLobbyPopupInput( KEY_N )
}


void function KeyB_OnActivate( var button )
{
	DispatchLobbyPopupInput( KEY_B )
}


void function DispatchLobbyPopupInput( int inputID )
{
	if ( file.activeLobbyPopup == null )
		return

	if ( IsDialog( GetActiveMenu() ) )
		return

	LobbyPopup ornull lobbyPopup = file.activeLobbyPopup
	expect LobbyPopup( lobbyPopup )
	lobbyPopup.handleInput( inputID )
}


void function SetActiveLobbyPopup( LobbyPopup popup )
{
	Assert( file.activeLobbyPopup == null )

	file.activeLobbyPopup = popup
}


bool function HasActiveLobbyPopup()
{
	return file.activeLobbyPopup != null
}


void function ClearActiveLobbyPopup()
{
	if ( file.activeLobbyPopup != null )
	{
		LobbyPopup ornull lobbyPopup = file.activeLobbyPopup
		expect LobbyPopup( lobbyPopup )

		file.activeLobbyPopup = null

		lobbyPopup.onClose()
	}
}


void function SetNewsButtonTooltip( int status )
{
	ToolTipData newsToolTip
	switch( status )
	{
		case UM_RESULT_HIGH_LATENCY:
			newsToolTip.descText = "#UM_TOOLTIP_STATUS_HIGH_LATENCY"
			HudElem_SetRuiArg( file.newsButtonStatusIcon, "icon", $"rui/menu/lobby/um_icon_high_latency" )
			break;
		case UM_RESULT_FAILURE:
			newsToolTip.descText = "#UM_TOOLTIP_STATUS_FAILURE"
			HudElem_SetRuiArg( file.newsButtonStatusIcon, "icon", $"rui/menu/lobby/um_icon_failure" )
			break;
		default:
			newsToolTip.descText = "#NEWS"
			HudElem_SetRuiArg( file.newsButtonStatusIcon, "icon", $"" )
			Hud_SetVisible( file.newsButtonStatusIcon, false )
			break;

	}
	Hud_SetToolTipData( file.newsButton, newsToolTip )
}
