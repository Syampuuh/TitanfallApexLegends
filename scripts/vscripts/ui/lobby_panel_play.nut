global function InitPlayPanel

global function IsPlayPanelCurrentlyTopLevel
global function PlayPanelUpdate
global function ClientToUI_PartyMemberJoinedOrLeft
global function GetModeSelectButton
global function GetLobbyChatBox

global function Lobby_GetPlaylists
global function Lobby_GetSelectedPlaylist
global function Lobby_IsPlaylistAvailable
global function Lobby_SetSelectedPlaylist
global function Lobby_OnGamemodeSelectV2Close

global function Lobby_GetPlaylistState
global function Lobby_GetPlaylistStateString

global function Lobby_UpdatePlayPanelPlaylists

global function CanInvite

global function UpdateLootBoxButton
#if(true)
global function PartyHasEliteAccess
global function ForceElitePlaylist
global function ForceNonElitePlaylist
#endif
global function PulseModeButton

#if(DEV)
global function DEV_PrintPartyInfo
global function DEV_PrintUserInfo
#endif

const string SOUND_START_MATCHMAKING_1P = "UI_Menu_ReadyUp_1P"
const string SOUND_STOP_MATCHMAKING_1P = "UI_Menu_ReadyUp_Cancel_1P"
const string SOUND_START_MATCHMAKING_3P = "UI_Menu_ReadyUp_3P"
const string SOUND_STOP_MATCHMAKING_3P = "UI_Menu_ReadyUp_Cancel_3P"

const float INVITE_LAST_TIMEOUT = 15.0
const float INVITE_LAST_PANEL_EXPIRATION = 1 * MINUTES_PER_HOUR * SECONDS_PER_MINUTE
global enum ePlaylistState
{
	AVAILABLE,
	NO_PLAYLIST,
	TRAINING_REQUIRED,
	PARTY_SIZE_OVER,
	LOCKED,
	#if(true)
		ELITE_ACCESS_REQUIRED,
	#endif
	_COUNT
}


const table< int, string > playlistStateMap = {
	[ ePlaylistState.NO_PLAYLIST ] = "#PLAYLIST_STATE_NO_PLAYLIST",
	[ ePlaylistState.TRAINING_REQUIRED ] = "#PLAYLIST_STATE_TRAINING_REQUIRED",
	[ ePlaylistState.AVAILABLE ] = "#PLAYLIST_STATE_AVAILABLE",
	[ ePlaylistState.PARTY_SIZE_OVER ] = "#PLAYLIST_STATE_PARTY_SIZE_OVER",
	[ ePlaylistState.LOCKED ] = "#PLAYLIST_STATE_LOCKED"
#if(true)
,[ ePlaylistState.ELITE_ACCESS_REQUIRED ] = "#PLAYLIST_STATE_ELITE_REQUIRED"
#endif
}

const string PLAYLIST_TRAINING = "survival_training"

struct
{
	var panel
	var chatBox
	var chatroomMenu
	var chatroomMenu_chatroomWidget

	var fillButton
	var modeButton
	var gamemodeSelectV2Button
	var readyButton
	var trainingButton
	var inviteFriendsButton0
	var inviteFriendsButton1
	var inviteLastPlayedHeader
	var inviteLastPlayedUnitFrame0
	var inviteLastPlayedUnitFrame1
	var friendButton0
	var friendButton1

	var selfButton

	var openLootBoxButton

	var hdTextureProgress

	int lastExpireTime

	string lastVisiblePlaylistValue

	array<string> playlists
	string        selectedPlaylist

	bool personInLeftSpot = false
	bool personInRightSlot = false

	Friend& friendInLeftSpot
	Friend& friendInRightSpot

	string lastPlayedPlayerPlatformUid0 = ""
	string lastPlayedPlayerHardware0 = ""
	string lastPlayedPlayerPlatformUid1 = ""
	string lastPlayedPlayerHardware1 = ""
	int    lastPlayedPlayerPersistenceIndex0 = -1
	int    lastPlayedPlayerPersistenceIndex1 = -1
	float  lastPlayedPlayerInviteSentTimestamp0 = -1
	float  lastPlayedPlayerInviteSentTimestamp1 = -1


	bool leftWasReady = false
	bool rightWasReady = false

	bool fullInstallNotification = false

	bool wasReady = false
} file

void function InitPlayPanel( var panel )
{
	file.panel = panel
	SetPanelTabTitle( panel, "#PLAY" )
	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, PlayPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, PlayPanel_OnHide )
	AddPanelEventHandler( panel, eUIEvent.PANEL_NAVBACK, PlayPanel_OnNavBack )

	SetPanelInputHandler( panel, BUTTON_Y, ReadyShortcut_OnActivate )

	file.fillButton = Hud_GetChild( panel, "FillButton" )
	Hud_AddEventHandler( file.fillButton, UIE_CLICK, FillButton_OnActivate )

	file.modeButton = Hud_GetChild( panel, "ModeButton" )
	Hud_AddEventHandler( file.modeButton, UIE_CLICK, ModeButton_OnActivate )

	file.gamemodeSelectV2Button = Hud_GetChild( panel, "GamemodeSelectV2Button" )
	Hud_AddEventHandler( file.gamemodeSelectV2Button, UIE_CLICK, GameModeSelectV2Button_OnActivate )
	Hud_AddEventHandler( file.gamemodeSelectV2Button, UIE_GET_FOCUS, GameModeSelectV2Button_OnGetFocus )
	Hud_AddEventHandler( file.gamemodeSelectV2Button, UIE_LOSE_FOCUS, GameModeSelectV2Button_OnLoseFocus )
	Hud_SetVisible( file.gamemodeSelectV2Button, false )

	file.readyButton = Hud_GetChild( panel, "ReadyButton" )
	Hud_AddEventHandler( file.readyButton, UIE_CLICK, ReadyButton_OnActivate )

	file.inviteFriendsButton0 = Hud_GetChild( panel, "InviteFriendsButton0" )
	Hud_AddEventHandler( file.inviteFriendsButton0, UIE_CLICK, InviteFriendsButton_OnActivate )

	file.inviteFriendsButton1 = Hud_GetChild( panel, "InviteFriendsButton1" )
	Hud_AddEventHandler( file.inviteFriendsButton1, UIE_CLICK, InviteFriendsButton_OnActivate )

	file.inviteLastPlayedHeader = Hud_GetChild( panel, "InviteLastSquadHeader" )
	Hud_Hide( file.inviteLastPlayedHeader )

	file.inviteLastPlayedUnitFrame0 = Hud_GetChild( panel, "InviteLastPlayedUnitframe0" )
	Hud_AddEventHandler( file.inviteLastPlayedUnitFrame0, UIE_CLICK, InviteLastPlayedButton_OnActivate )
	Hud_AddEventHandler( file.inviteLastPlayedUnitFrame0, UIE_CLICKRIGHT, InviteLastPlayedButton_OnRightClick )
	Hud_Hide( file.inviteLastPlayedUnitFrame0 )

	file.inviteLastPlayedUnitFrame1 = Hud_GetChild( panel, "InviteLastPlayedUnitframe1" )
	Hud_AddEventHandler( file.inviteLastPlayedUnitFrame1, UIE_CLICK, InviteLastPlayedButton_OnActivate )
	Hud_AddEventHandler( file.inviteLastPlayedUnitFrame1, UIE_CLICKRIGHT, InviteLastPlayedButton_OnRightClick )
	Hud_Hide( file.inviteLastPlayedUnitFrame1 )

	file.selfButton = Hud_GetChild( panel, "SelfButton" )
	Hud_AddEventHandler( file.selfButton, UIE_CLICK, FriendButton_OnActivate )

	file.friendButton0 = Hud_GetChild( panel, "FriendButton0" )
	Hud_AddEventHandler( file.friendButton0, UIE_CLICK, FriendButton_OnActivate )
	Hud_AddEventHandler( file.friendButton0, UIE_CLICKRIGHT, FriendButton_OnRightClick )

	file.friendButton1 = Hud_GetChild( panel, "FriendButton1" )
	Hud_AddEventHandler( file.friendButton1, UIE_CLICK, FriendButton_OnActivate )
	Hud_AddEventHandler( file.friendButton1, UIE_CLICKRIGHT, FriendButton_OnRightClick )

	file.openLootBoxButton = Hud_GetChild( panel, "OpenLootBoxButton" )
	HudElem_SetRuiArg( file.openLootBoxButton, "buttonText", Localize( "#OPEN_LOOT" ) )
	Hud_AddEventHandler( file.openLootBoxButton, UIE_CLICK, OpenLootBoxButton_OnActivate )

	#if(true)
		var allChallengesButton = Hud_GetChild( panel, "AllChallengesButton" )
		Hud_SetVisible( allChallengesButton, false )
		#if(false)





#endif
		Hud_AddEventHandler( allChallengesButton, UIE_CLICK, AllChallengesButton_OnActivate )
	#endif

	AddMenuVarChangeHandler( "isMatchmaking", UpdateLobbyButtons )

	file.chatBox = Hud_GetChild( panel, "ChatRoomTextChat" )
	file.hdTextureProgress = Hud_GetChild( panel, "HDTextureProgress" )

	InitMiniPromo( Hud_GetChild( panel, "MiniPromo" ) )

	RegisterSignal( "UpdateFriendButtons" )

	#if(true)
		var eliteBadge = Hud_GetChild( file.panel, "EliteBadge" )
		Hud_AddEventHandler( eliteBadge, UIE_CLICK, OpenEliteIntroMenuNonAnimated )
	#endif

	#if(false)


#endif
}


bool function IsPlayPanelCurrentlyTopLevel()
{
	return GetActiveMenu() == GetMenu( "LobbyMenu" ) && IsPanelActive( file.panel )
}


void function UpdateLastPlayedPlayerInfo()
{
	array<string> curPartyMemberUids
	file.lastPlayedPlayerPlatformUid0 = ""
	file.lastPlayedPlayerHardware0 = ""
	file.lastPlayedPlayerPersistenceIndex0 = -1

	file.lastPlayedPlayerPlatformUid1 = ""
	file.lastPlayedPlayerHardware1 = ""
	file.lastPlayedPlayerPersistenceIndex1 = -1


	if ( !IsPersistenceAvailable() || !InviteLastPlayedPanelShouldBeVisible() )
	{
		return
	}

	int maxTrackedSquadMembers = PersistenceGetArrayCount( "lastGameSquadStats" )
	foreach ( index, member in GetParty().members )
	{
		curPartyMemberUids.append( member.uid )
	}

	for ( int i = 0; i < maxTrackedSquadMembers; i++ )
	{
		string lastPlayedPlayerUid      = expect string( GetPersistentVar( "lastGameSquadStats[" + i + "].platformUid" ) )
		string lastPlayedPlayerHardware = expect string( GetPersistentVar( "lastGameSquadStats[" + i + "].hardware" ) )

		if ( lastPlayedPlayerUid == "" || lastPlayedPlayerHardware == "" )
		{
			continue
		}

		if ( !curPartyMemberUids.contains( lastPlayedPlayerUid ) )
		{
			if ( file.lastPlayedPlayerPlatformUid0 == "" )
			{
				file.lastPlayedPlayerPlatformUid0 = lastPlayedPlayerUid
				file.lastPlayedPlayerHardware0 = lastPlayedPlayerHardware
				file.lastPlayedPlayerPersistenceIndex0 = i
			}
			else if ( file.lastPlayedPlayerPlatformUid1 == "" && lastPlayedPlayerUid != file.lastPlayedPlayerPlatformUid0 )
			{
				file.lastPlayedPlayerPlatformUid1 = lastPlayedPlayerUid
				file.lastPlayedPlayerHardware1 = lastPlayedPlayerHardware
				file.lastPlayedPlayerPersistenceIndex1 = i
			}
		}
	}
}


bool function InviteLastPlayedPanelShouldBeVisible()
{
	if ( GetUnixTimestamp() - GetPersistentVarAsInt( "lastGameTime" ) > INVITE_LAST_PANEL_EXPIRATION )
		return false

	if ( GetPersistentVarAsInt( "lastGamePlayers" ) == 0 && GetPersistentVarAsInt( "lastGameSquads" ) == 0 )
		return false

	return true
}


bool function PlayerIsInMatch( string playerPlatformUid, string playerHardware )
{
	CommunityUserInfo ornull userInfoOrNull = GetUserInfo( playerHardware, playerPlatformUid )
	if ( userInfoOrNull != null )
	{
		CommunityUserInfo userInfo = expect CommunityUserInfo(userInfoOrNull)
		return userInfo.charData[ePlayerStryderCharDataArraySlots.PLAYER_IN_MATCH] == 1
	}
	return false
}


var function GetModeSelectButton()
{
	return file.modeButton
}


var function GetLobbyChatBox()
{
	return file.chatBox
}


void function PlayPanel_OnShow( var panel )
{
	if ( IsFullyConnected() )
	{
		AccessibilityHint( eAccessibilityHint.LOBBY_CHAT )
		Lobby_UpdatePlayPanelPlaylists()
	}

	UpdateFillButtonVisibility()
	UpdateLobbyButtons()

	if ( file.chatroomMenu )
	{
		Hud_Hide( file.chatroomMenu )
		Hud_Hide( file.chatroomMenu_chatroomWidget )
	}
	AddCallbackAndCallNow_OnGRXInventoryStateChanged( UpdatePlayPanelGRXDependantElements )
	AddCallbackAndCallNow_OnGRXInventoryStateChanged( UpdateFriendButtons )
	AddCallbackAndCallNow_RemoteMatchInfoUpdated( OnRemoteMatchInfoUpdated )

	ClientCommand( "ViewingMainLobbyPage" )

	StartMiniPromo()

	UI_SetPresentationType( ePresentationType.PLAY )
	#if(true)
		thread TryPopupEliteMessage()
	#endif

	bool newPlaylistSelect = GamemodeSelectV2_IsEnabled()
	if ( newPlaylistSelect )
	{
		Hud_SetNavUp( file.readyButton, file.gamemodeSelectV2Button )
	}
	else
	{
		Hud_SetNavUp( file.readyButton, file.modeButton )
	}

	thread TryRunDialogFlowThread()
}


#if(true)
void function TryPopupEliteMessage()
{
	WaitEndFrame()

	if ( GetActiveMenu() == GetMenu( "LobbyMenu" ) && IsPanelActive( file.panel ) )
	{
		if ( GetPersistentVar( "lossForgivenessMessage" ) != eLossForgivenessReason.NONE )
		{
			OpenLossForgivenessDialog( GetPersistentVarAsInt( "lossForgivenessMessage" ) )
		}
		else if ( GetPersistentVar( "eliteTutorialState" ) == eEliteTutorialState.SHOW_FORGIVENESS )
		{
			OpenEliteForgivenessDialog()
		}
	}
}
#endif

void function UpdateLobbyButtons()
{
	if ( !IsConnected() )
		return

	UpdateFillButton()
	UpdateReadyButton()
	UpdateModeButton()
	UpdateFriendButtons()
	UpdateLastPlayedButtons()
	UpdatePlaylistBadges()
}


void function UpdateHDTextureProgress()
{
	//
	HudElem_SetRuiArg( file.hdTextureProgress, "hdTextureProgress", GetGameFullyInstalledProgress() )
	HudElem_SetRuiArg( file.hdTextureProgress, "hdTextureNeedsReboot", HasNonFullyInstalledAssetsLoaded() )

	if ( ShowDownloadCompleteDialog() )
	{
		ConfirmDialogData data
		data.headerText = "#TEXTURE_STREAM_REBOOT_HEADER"
		data.messageText = "#TEXTURE_STREAM_REBOOT_MESSAGE"
		data.yesText = ["#TEXTURE_STREAM_REBOOT", "#TEXTURE_STREAM_REBOOT_PC"]
		data.noText = ["#B_BUTTON_CANCEL", "#CANCEL"]

		data.resultCallback = void function ( int result ) : ()
		{
			if ( result == eDialogResult.YES )
			{
				//
				ClientCommand( "disconnect" )
			}

			return
		}

		OpenConfirmDialogFromData( data )
		file.fullInstallNotification = true
	}
}


void function UpdateFillButtonVisibility()
{
	if ( GetCurrentPlaylistVarBool( "enable_teamNoFill", false ) )
	{
		Hud_SetVisible( file.fillButton, true )
		Hud_SetNavUp( file.modeButton, file.fillButton )
		Hud_SetNavDown( file.inviteFriendsButton0, file.fillButton )
		Hud_SetNavLeft( file.inviteFriendsButton0, file.fillButton )
	}
	else
	{
		Hud_SetVisible( file.fillButton, false )
		Hud_SetNavUp( file.modeButton, file.inviteFriendsButton0 )

		var buttonToLink = file.modeButton
		if ( GamemodeSelectV2_IsEnabled() )
			buttonToLink = file.gamemodeSelectV2Button

		Hud_SetNavDown( file.inviteFriendsButton0, buttonToLink )
		Hud_SetNavLeft( file.inviteFriendsButton0, buttonToLink )
	}
}


void function UpdateLastSquadDpadNav()
{
	var buttonBeneathLastSquadPanel = file.modeButton

	if ( Hud_IsVisible( file.fillButton ) )
	{
		buttonBeneathLastSquadPanel = file.fillButton
	}

	bool isVisibleButton0 = Hud_IsVisible( file.inviteLastPlayedUnitFrame0 )
	bool isVisibleButton1 = Hud_IsVisible( file.inviteLastPlayedUnitFrame1 )

	if ( isVisibleButton0 )
	{
		Hud_SetNavDown( file.inviteLastPlayedUnitFrame0, buttonBeneathLastSquadPanel )
		Hud_SetNavUp( buttonBeneathLastSquadPanel, file.inviteLastPlayedUnitFrame0 )
		Hud_SetNavLeft( file.inviteFriendsButton0, file.inviteLastPlayedUnitFrame0 )
		Hud_SetNavRight( file.inviteLastPlayedUnitFrame0, file.inviteFriendsButton0 )

		if ( isVisibleButton1 )
		{
			Hud_SetNavDown( file.inviteLastPlayedUnitFrame1, buttonBeneathLastSquadPanel )
			Hud_SetNavUp( buttonBeneathLastSquadPanel, file.inviteLastPlayedUnitFrame1 )

			Hud_SetNavDown( file.inviteLastPlayedUnitFrame0, file.inviteLastPlayedUnitFrame1 )
		}
	}
	else
	{
		Hud_SetNavUp( buttonBeneathLastSquadPanel, file.inviteFriendsButton0 )
		Hud_SetNavDown( file.inviteFriendsButton0, buttonBeneathLastSquadPanel )
		Hud_SetNavLeft( file.inviteFriendsButton0, buttonBeneathLastSquadPanel )
		Hud_SetNavRight( buttonBeneathLastSquadPanel, file.inviteFriendsButton0 )
	}
}


bool function ShowDownloadCompleteDialog()
{
	if ( GetGameFullyInstalledProgress() != 1 )
		return false

	if ( !HasNonFullyInstalledAssetsLoaded() )
		return false

	if ( file.fullInstallNotification )
		return false

	if ( GetActiveMenu() != GetMenu( "LobbyMenu" ) )
		return false

	if ( GetPersistentVar( "showGameSummary" ) && IsPostGameMenuValid( true ) )
		return false

	return true
}


array<string> function Lobby_GetPlaylists()
{
	return file.playlists
}


string function Lobby_GetSelectedPlaylist()
{
	return file.selectedPlaylist
}


bool function Lobby_IsPlaylistAvailable( string playlistName )
{
	return Lobby_GetPlaylistState( playlistName ) == ePlaylistState.AVAILABLE
}


void function Lobby_SetSelectedPlaylist( string playlistName )
{
	printt( "Lobby_SetSelectedPlaylist " + playlistName )
	file.selectedPlaylist = playlistName
	UpdateLobbyButtons()

	if ( playlistName.len() > 0 )
		SetMatchmakingPlaylist( playlistName )
}


void function PlayPanel_OnHide( var panel )
{
	Signal( uiGlobal.signalDummy, "UpdateFriendButtons" )
	RemoveCallback_OnGRXInventoryStateChanged( UpdatePlayPanelGRXDependantElements )
	RemoveCallback_OnGRXInventoryStateChanged( UpdateFriendButtons )
	RemoveCallback_RemoteMatchInfoUpdated( OnRemoteMatchInfoUpdated )

	StopMiniPromo()
}


void function UpdateFriendButton( var rui, PartyMember info, bool inMatch )
{
	Party party = GetParty()

	RuiSetString( rui, "playerName", info.name )
	RuiSetBool( rui, "isLeader", party.originatorUID == info.uid && GetPartySize() > 1 )
	RuiSetBool( rui, "isReady", info.ready )
	RuiSetBool( rui, "inMatch", inMatch )
	if ( inMatch )
	{
		RuiSetString( rui, "footerText", "#PROMPT_IN_MATCH" )
	}
	else
	{
		RuiSetString( rui, "footerText", "" )
	}

	thread KeepMicIconUpdated( info, rui )

	CommunityUserInfo ornull userInfo = GetCommunityUserInfo( info.hardware, info.uid )
	if ( userInfo == null )
	{
		RuiSetFloat( rui, "accountXPFrac", 0.0 )
		RuiSetString( rui, "accountLevel", "" )

		int accountLevel = 0
		if ( info.uid == GetPlayerUID() && IsPersistenceAvailable() )
			accountLevel = GetAccountLevelForXP( GetPersistentVarAsInt( "xp" ) )

		RuiSetString( rui, "accountLevel", GetAccountDisplayLevel( accountLevel ) )
		RuiSetImage( rui, "accountBadge", GetAccountDisplayBadge( accountLevel ) )
	}
	else
	{
		expect CommunityUserInfo( userInfo )
		RuiSetFloat( rui, "accountXPFrac", userInfo.charData[ePlayerStryderCharDataArraySlots.ACCOUNT_PROGRESS_INT] / 100.0 )
		RuiSetString( rui, "accountLevel", GetAccountDisplayLevel( userInfo.charData[ePlayerStryderCharDataArraySlots.ACCOUNT_LEVEL] ) )
		RuiSetImage( rui, "accountBadge", GetAccountDisplayBadge( userInfo.charData[ePlayerStryderCharDataArraySlots.ACCOUNT_LEVEL] ) )
	}
}


void function KeepMicIconUpdated( PartyMember info, var rui )
{
	EndSignal( uiGlobal.signalDummy, "UpdateFriendButtons" )

	while ( 1 )
	{
		RuiSetInt( rui, "micStatus", GetChatroomMicStatus( info.uid ) )
		WaitFrame()
	}
}


void function UpdateFriendButtons()
{
	Signal( uiGlobal.signalDummy, "UpdateFriendButtons" )

	Hud_SetVisible( file.inviteFriendsButton0, !file.personInLeftSpot )
	Hud_SetVisible( file.inviteFriendsButton1, !file.personInRightSlot )

	Hud_SetVisible( file.friendButton0, false )
	Hud_SetVisible( file.friendButton1, false )

	int count = GetInGameFriendCount( true )
	RuiSetInt( Hud_GetRui( file.inviteFriendsButton0 ), "onlineFriendCount", count )
	RuiSetInt( Hud_GetRui( file.inviteFriendsButton1 ), "onlineFriendCount", count )

	Party party = GetParty()
	foreach ( PartyMember partyMember in party.members )
	{
		if ( partyMember.uid == GetPlayerUID() )
		{
			ToolTipData toolTipData
			toolTipData.tooltipStyle = eTooltipStyle.BUTTON_PROMPT
			toolTipData.actionHint1 = "#A_BUTTON_INSPECT"
			Hud_SetToolTipData( file.selfButton, toolTipData )

			var friendRui = Hud_GetRui( file.selfButton )
			UpdateFriendButton( friendRui, partyMember, false )
		}
		else if ( partyMember.uid == file.friendInLeftSpot.id )
		{
			ToolTipData toolTipData
			toolTipData.tooltipStyle = eTooltipStyle.BUTTON_PROMPT
			toolTipData.actionHint1 = "#A_BUTTON_INSPECT"
			toolTipData.actionHint2 = IsPlayerVoiceMutedForUID( partyMember.uid ) ? "#X_BUTTON_UNMUTE" : "#X_BUTTON_MUTE"
			Hud_SetToolTipData( file.friendButton0, toolTipData )

			var friendRui = Hud_GetRui( file.friendButton0 )
			UpdateFriendButton( friendRui, partyMember, file.friendInLeftSpot.ingame )
			Hud_SetVisible( file.friendButton0, true )
			if ( file.leftWasReady != partyMember.ready )
				EmitUISound( partyMember.ready ? SOUND_START_MATCHMAKING_3P : SOUND_STOP_MATCHMAKING_3P )

			file.leftWasReady = partyMember.ready
		}
		else if ( partyMember.uid == file.friendInRightSpot.id )
		{
			ToolTipData toolTipData
			toolTipData.tooltipStyle = eTooltipStyle.BUTTON_PROMPT
			toolTipData.actionHint1 = "#A_BUTTON_INSPECT"
			toolTipData.actionHint2 = IsPlayerVoiceMutedForUID( partyMember.uid ) ? "#X_BUTTON_UNMUTE" : "#X_BUTTON_MUTE"
			Hud_SetToolTipData( file.friendButton1, toolTipData )

			var friendRui = Hud_GetRui( file.friendButton1 )
			UpdateFriendButton( friendRui, partyMember, file.friendInRightSpot.ingame )
			Hud_SetVisible( file.friendButton1, true )

			if ( file.rightWasReady != partyMember.ready )
				EmitUISound( partyMember.ready ? SOUND_START_MATCHMAKING_3P : SOUND_STOP_MATCHMAKING_3P )

			file.rightWasReady = partyMember.ready
		}
	}

	ToolTipData toolTipData
	toolTipData.titleText = "#INVITE"
	toolTipData.descText = "#INVITE_HINT"

	entity player = GetUIPlayer()
	if ( IsLocalClientEHIValid() && IsValid( player ) )
	{
		bool hasPremiumPass                = false
		ItemFlavor ornull activeBattlePass = GetPlayerActiveBattlePass( ToEHI( player ) )
		bool hasActiveBattlePass           = activeBattlePass != null
		if ( hasActiveBattlePass && GRX_IsInventoryReady() )
		{
			expect ItemFlavor( activeBattlePass )
			hasPremiumPass = DoesPlayerOwnBattlePass( player, activeBattlePass )
			if ( hasPremiumPass )
				toolTipData.descText = Localize( "#INVITE_HINT_BP", GetPlayerBattlePassXPBoostPercent( ToEHI( player ), activeBattlePass ) )
		}
	}

	#if(PC_PROG)
		if ( !Origin_IsOverlayAvailable() && !GetCurrentPlaylistVarBool( "social_menu_enabled", true ) )
		{
			toolTipData.descText = "#ORIGIN_INGAME_REQUIRED"
			Hud_SetLocked( file.inviteFriendsButton0, true )
			Hud_SetLocked( file.inviteFriendsButton1, true )
		}
	#endif //

	Hud_SetToolTipData( file.inviteFriendsButton0, toolTipData )
	Hud_SetToolTipData( file.inviteFriendsButton1, toolTipData )
}


void function UpdatePlaylistBadges()
{
	int currentStreak = 0

	bool newPlaylistSelect = GamemodeSelectV2_IsEnabled()

	#if(true)
		currentStreak = GetCurrentEliteStreak( GetUIPlayer() )
		bool shouldShowEliteBadge = IsElitePlaylist( file.selectedPlaylist )
	#endif

	#if(false)













#endif

	#if(true)
		var eliteBadge = Hud_GetChild( file.panel, "EliteBadge" )
		Hud_SetVisible( eliteBadge, false )

		if ( newPlaylistSelect )
		{
			Hud_SetPinSibling( eliteBadge, Hud_GetHudName( file.gamemodeSelectV2Button ) )
		}
		else
		{
			Hud_SetPinSibling( eliteBadge, Hud_GetHudName( file.modeButton ) )
		}
	#endif

	var msgLabel = Hud_GetChild( file.panel, "PlaylistNotificationMessage" )
	Hud_SetVisible( msgLabel, false )

	if ( newPlaylistSelect )
	{
		Hud_SetPinSibling( msgLabel, Hud_GetHudName( file.gamemodeSelectV2Button ) )
	}
	else
	{
		Hud_SetPinSibling( msgLabel, Hud_GetHudName( file.modeButton ) )
	}

#if(false)
































#endif

	#if(true)
		if ( shouldShowEliteBadge )
		{
			Hud_SetVisible( eliteBadge, shouldShowEliteBadge )

			var rui = Hud_GetRui( eliteBadge )

			RuiSetInt( rui, "streak", currentStreak )

			if ( IsFullyConnected() )
				RuiSetBool( rui, "eliteForgiveness", expect bool( GetPersistentVar( "hasEliteForgiveness" ) ) )

			int maxStreak = GetMaxEliteStreak( GetUIPlayer() )
			ToolTipData tooltip
			tooltip.titleText = Localize( "#ELITE_TOOLTIP_INFO", currentStreak )
			tooltip.descText = Localize( "#ELITE_TOOLTIP_INFO_2", maxStreak )
			Hud_SetToolTipData( eliteBadge, tooltip )
		}
		else if ( PartyHasEliteAccess() )
		{
			bool foundElitePlaylist = false

			foreach ( playlist in GetVisiblePlaylistNames() )
			{
				if ( IsElitePlaylist( playlist ) )
				{
					foundElitePlaylist = true
					break
				}
			}

			if ( foundElitePlaylist )
				Hud_SetVisible( msgLabel, true )
		}
	#endif
}


void function UpdateLastPlayedButtons()
{
	UpdateLastPlayedPlayerInfo()

	bool isVisibleButton0 = file.lastPlayedPlayerPlatformUid0 != "" && !PlayerIsInMatch( file.lastPlayedPlayerHardware0, file.lastPlayedPlayerPlatformUid0 )
	bool isVisibleButton1 = file.lastPlayedPlayerPlatformUid1 != "" && !PlayerIsInMatch( file.lastPlayedPlayerHardware1, file.lastPlayedPlayerPlatformUid1 )

	bool shouldUpdateDpadNav = false

	if ( isVisibleButton0 != Hud_IsVisible( file.inviteLastPlayedUnitFrame0 ) || isVisibleButton1 != Hud_IsVisible( file.inviteLastPlayedUnitFrame1 ) )
	{
		shouldUpdateDpadNav = true
	}

	isVisibleButton0 = isVisibleButton0 && CanInvite()
	isVisibleButton1 = isVisibleButton1 && CanInvite()

	if ( isVisibleButton0 )
	{
		if ( file.lastPlayedPlayerPersistenceIndex0 == -1 )
			return

		string namePlayer0 = expect string( GetPersistentVar( "lastGameSquadStats[" + file.lastPlayedPlayerPersistenceIndex0 + "].playerName" ) )
		HudElem_SetRuiArg( file.inviteLastPlayedUnitFrame0, "name", namePlayer0 )

		string characterGUIDString = string( GetPersistentVar( "lastGameSquadStats[" + file.lastPlayedPlayerPersistenceIndex0 + "].character" ) )
		int characterGUID          = ConvertItemFlavorGUIDStringToGUID( characterGUIDString )
		if ( IsValidItemFlavorGUID( characterGUID ) )
		{
			ItemFlavor squadCharacterClass = GetItemFlavorByGUID( characterGUID )
			HudElem_SetRuiArg( file.inviteLastPlayedUnitFrame0, "icon", CharacterClass_GetGalleryPortrait( squadCharacterClass ), eRuiArgType.IMAGE )
		}

		if ( Time() - file.lastPlayedPlayerInviteSentTimestamp0 > INVITE_LAST_TIMEOUT )
		{
			HudElem_SetRuiArg( file.inviteLastPlayedUnitFrame0, "unitframeFooterText", "#INVITE_PLAYER_UNITFRAME" )
			Hud_SetLocked( file.inviteLastPlayedUnitFrame0, false )
		}
	}

	Hud_SetVisible( file.inviteLastPlayedUnitFrame0, isVisibleButton0 )


	if ( isVisibleButton1 )
	{
		if ( file.lastPlayedPlayerPersistenceIndex1 == -1 )
			return

		string namePlayer1 = expect string( GetPersistentVar( "lastGameSquadStats[" + file.lastPlayedPlayerPersistenceIndex1 + "].playerName" ) )
		HudElem_SetRuiArg( file.inviteLastPlayedUnitFrame1, "name", namePlayer1 )

		string characterGUIDString = string( GetPersistentVar( "lastGameSquadStats[" + file.lastPlayedPlayerPersistenceIndex1 + "].character" ) )
		int characterGUID          = ConvertItemFlavorGUIDStringToGUID( characterGUIDString )
		if ( IsValidItemFlavorGUID( characterGUID ) )
		{
			ItemFlavor squadCharacterClass = GetItemFlavorByGUID( characterGUID )
			HudElem_SetRuiArg( file.inviteLastPlayedUnitFrame1, "icon", CharacterClass_GetGalleryPortrait( squadCharacterClass ), eRuiArgType.IMAGE )
		}

		if ( Time() - file.lastPlayedPlayerInviteSentTimestamp1 > INVITE_LAST_TIMEOUT )
		{
			HudElem_SetRuiArg( file.inviteLastPlayedUnitFrame1, "unitframeFooterText", "#INVITE_PLAYER_UNITFRAME" )
			Hud_SetLocked( file.inviteLastPlayedUnitFrame1, false )
		}
	}

	Hud_SetVisible( file.inviteLastPlayedUnitFrame1, isVisibleButton1 )
	Hud_SetVisible( file.inviteLastPlayedHeader, isVisibleButton0 || isVisibleButton1 )

	if ( shouldUpdateDpadNav )
	{
		UpdateLastSquadDpadNav()
	}

	//

	ToolTipData toolTipData0
	toolTipData0.tooltipStyle = eTooltipStyle.BUTTON_PROMPT

	ToolTipData toolTipData1
	toolTipData1.tooltipStyle = eTooltipStyle.BUTTON_PROMPT

	if ( Time() - file.lastPlayedPlayerInviteSentTimestamp0 > INVITE_LAST_TIMEOUT )
	{
		toolTipData0.actionHint1 = "#A_BUTTON_INVITE"
		toolTipData0.actionHint2 = "#X_BUTTON_INSPECT"
		Hud_SetToolTipData( file.inviteLastPlayedUnitFrame0, toolTipData0 )
	}
	else if ( Time() - file.lastPlayedPlayerInviteSentTimestamp0 <= INVITE_LAST_TIMEOUT )
	{
		toolTipData0.actionHint1 = "#X_BUTTON_INSPECT"
		Hud_SetToolTipData( file.inviteLastPlayedUnitFrame0, toolTipData0 )
	}

	if ( Time() - file.lastPlayedPlayerInviteSentTimestamp1 > INVITE_LAST_TIMEOUT )
	{
		toolTipData1.actionHint1 = "#A_BUTTON_INVITE"
		toolTipData1.actionHint2 = "#X_BUTTON_INSPECT"
		Hud_SetToolTipData( file.inviteLastPlayedUnitFrame1, toolTipData1 )
	}
	else if ( Time() - file.lastPlayedPlayerInviteSentTimestamp1 <= INVITE_LAST_TIMEOUT )
	{
		toolTipData1.actionHint1 = "#X_BUTTON_INSPECT"
		Hud_SetToolTipData( file.inviteLastPlayedUnitFrame1, toolTipData1 )
	}
}


void function ClientToUI_PartyMemberJoinedOrLeft( string leftSpotUID, string leftSpotHardware, string leftSpotName, bool leftSpotInMatch, string rightSpotUID, string rightSpotHardware, string rightSpotName, bool rightSpotInMatch )
{
	bool personInLeftSpot  = leftSpotUID.len() > 0
	bool persinInRightSpot = rightSpotUID.len() > 0

	file.friendInLeftSpot.id = leftSpotUID
	file.friendInLeftSpot.hardware = leftSpotHardware
	file.friendInLeftSpot.name = leftSpotName
	file.friendInLeftSpot.ingame = leftSpotInMatch

	file.friendInRightSpot.id = rightSpotUID
	file.friendInRightSpot.hardware = rightSpotHardware
	file.friendInRightSpot.name = rightSpotName
	file.friendInRightSpot.ingame = rightSpotInMatch

	file.personInLeftSpot = personInLeftSpot
	file.personInRightSlot = persinInRightSpot

	file.leftWasReady = file.leftWasReady && personInLeftSpot
	file.rightWasReady = file.rightWasReady && persinInRightSpot

	UpdateLobbyButtons()
}


bool function CanActivateReadyButton()
{
	if ( IsConnectingToMatch() )
		return false

	//
	//
	if ( GetActiveMenu() == GetMenu( "ModeSelectDialog" ) )
		return false

	bool isReady = GetConVarBool( "party_readyToSearch" )

	//
	if ( isReady )
		return true

	if ( !Lobby_IsPlaylistAvailable( GetSelectedPlaylist() ) )
		return false

	if ( Player_GetRemainingMatchmakingDelay( GetUIPlayer() ) > 0 )
		return false

	return true
}


string function GetSelectedPlaylist()
{
	return IsPartyLeader() ? file.selectedPlaylist : GetParty().playlistName
}


int function Lobby_GetPlaylistState( string playlistName )
{
	if ( playlistName == "" )
		return ePlaylistState.NO_PLAYLIST

	if ( !CompletedTraining() && playlistName != PLAYLIST_TRAINING && GetPartySize() == 1 )
		return ePlaylistState.TRAINING_REQUIRED

	if ( GetPartySize() > GetMaxTeamSizeForPlaylist( playlistName ) )
		return ePlaylistState.PARTY_SIZE_OVER

	#if(true)
		if ( IsElitePlaylist( playlistName ) && !PartyHasEliteAccess() )
			return ePlaylistState.ELITE_ACCESS_REQUIRED
	#endif

	return ePlaylistState.AVAILABLE
}


string function Lobby_GetPlaylistStateString( int playlistState )
{
	if ( Player_GetRemainingMatchmakingDelay( GetUIPlayer() ) > 0 )
	{
		return "#MATCHMAKING_PENALTY_DESC"
	}

	return playlistStateMap[playlistState]
}


void function UpdateReadyButton()
{
	bool isLeader = IsPartyLeader()

	bool isReady      = GetConVarBool( "party_readyToSearch" )
	int remainingTime = Player_GetRemainingMatchmakingDelay( GetUIPlayer() )
	bool hasPenalty   = remainingTime > 0

	string buttonText
	if ( hasPenalty )
	{
		buttonText = "#MATCHMAKING_PENALTY"
		if ( file.lastExpireTime != GetCurrentTimeForPersistence() + remainingTime )
		{
			HudElem_SetRuiArg( file.readyButton, "expireTime", float( int( Time() ) + remainingTime ), eRuiArgType.GAMETIME )
			file.lastExpireTime = GetCurrentTimeForPersistence() + remainingTime
		}
	}
	else
	{
		if ( isReady )
			buttonText = IsControllerModeActive() ? "#B_BUTTON_CANCEL" : "#CANCEL"
		else
			buttonText = IsControllerModeActive() ? "#Y_BUTTON_READY" : "#READY"

		HudElem_SetRuiArg( file.readyButton, "expireTime", RUI_BADGAMETIME, eRuiArgType.GAMETIME )
	}

	HudElem_SetRuiArg( file.readyButton, "isLeader", isLeader ) //
	HudElem_SetRuiArg( file.readyButton, "isReady", isReady )
	HudElem_SetRuiArg( file.readyButton, "buttonText", Localize( buttonText ) )

	Hud_SetLocked( file.readyButton, !CanActivateReadyButton() )

	if ( !CanActivateReadyButton() )
	{
		ToolTipData toolTipData
		toolTipData.titleText = IsConnectingToMatch() ? "#UNAVAILABLE" : "#READY_UNAVAILABLE"
		toolTipData.descText = IsConnectingToMatch() ? "#LOADINGPROGRESS_CONNECTING" : Lobby_GetPlaylistStateString( Lobby_GetPlaylistState( GetSelectedPlaylist() ) )

		Hud_SetToolTipData( file.readyButton, toolTipData )
	}
	else
	{
		Hud_ClearToolTipData( file.readyButton )
	}
}


bool function CanActivateModeButton()
{
	bool isReady  = GetConVarBool( "party_readyToSearch" )
	bool isLeader = IsPartyLeader()

	return !isReady && isLeader
}


void function UpdateModeButton()
{
	if ( !IsConnected() )
		return

	string visiblePlaylistValue = GetConVarString( "match_visiblePlaylists" )
	if ( visiblePlaylistValue != file.lastVisiblePlaylistValue )
	{
		Lobby_UpdatePlayPanelPlaylists()
		file.lastVisiblePlaylistValue = visiblePlaylistValue
	}

	Hud_SetLocked( file.modeButton, !CanActivateModeButton() )

	bool isReady = GetConVarBool( "party_readyToSearch" )
	Hud_SetEnabled( file.modeButton, !isReady && CanActivateModeButton() )
	HudElem_SetRuiArg( file.modeButton, "isReady", isReady )
	HudElem_SetRuiArg( file.gamemodeSelectV2Button, "isReady", isReady )

	if ( file.wasReady != isReady )
	{
		UISize screenSize = GetScreenSize()

		int maxDist = int( screenSize.height * 0.08 )

		int x = Hud_GetX( file.modeButton )
		int y = isReady ? Hud_GetBaseY( file.modeButton ) + maxDist : Hud_GetBaseY( file.modeButton )

		int currentY = Hud_GetY( file.modeButton )
		int diff     = abs( currentY - y )

		float duration = 0.15 * (float( diff ) / float( maxDist ))

		Hud_MoveOverTime( file.modeButton, x, y, 0.15 )

		file.wasReady = isReady
	}

	bool isLeader = IsPartyLeader()

	string playlistName        = isLeader ? file.selectedPlaylist : GetParty().playlistName
	string invalidPlaylistText = isLeader ? "#SELECT_PLAYLIST" : "#PARTY_LEADER_CHOICE"

	string name = GetPlaylistVarString( playlistName, "name", invalidPlaylistText )
	HudElem_SetRuiArg( file.modeButton, "buttonText", Localize( name ) )

	bool useGamemodeSelectV2 = GamemodeSelectV2_IsEnabled() && !(ShouldDisplayOptInOptions() && uiGlobal.isOptInEnabled)
	Hud_SetVisible( file.modeButton, !useGamemodeSelectV2 )
	Hud_SetVisible( file.gamemodeSelectV2Button, useGamemodeSelectV2 )
	RuiSetBool( Hud_GetRui( file.readyButton ), "showReadyFrame", !useGamemodeSelectV2 )
	if ( useGamemodeSelectV2 )
	{
		GamemodeSelectV2_UpdateSelectButton( file.gamemodeSelectV2Button, playlistName )
		HudElem_SetRuiArg( file.gamemodeSelectV2Button, "alwaysShowDesc", true )
		HudElem_SetRuiArg( file.gamemodeSelectV2Button, "isPartyLeader", isLeader )

		HudElem_SetRuiArg( file.gamemodeSelectV2Button, "modeLockedReason", "" )
		Hud_SetLocked( file.gamemodeSelectV2Button, !CanActivateModeButton() )
	}
}


void function UpdateFillButton()
{
	if ( !IsConnected() )
		return

	bool supportsNoFill = DoesPlaylistSupportNoFillTeams( Lobby_GetSelectedPlaylist() )

	if ( GetConVarBool( "match_teamNoFill" ) && !supportsNoFill )
		SetConVarBool( "match_teamNoFill", false )

	bool isNoFill = GetConVarBool( "match_teamNoFill" )

	if ( isNoFill )
		HudElem_SetRuiArg( file.fillButton, "buttonText", Localize( "#MATCH_TEAM_NO_FILL" ) )
	else
		HudElem_SetRuiArg( file.fillButton, "buttonText", Localize( "#MATCH_TEAM_FILL" ) )

	Hud_SetLocked( file.fillButton, !IsPartyLeader() || AreWeMatchmaking() || !supportsNoFill )
}


void function FillButton_OnActivate( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	if ( GetConVarBool( "match_teamNoFill" ) )
		ClientCommand( "match_teamNoFill 0" )
	else
		ClientCommand( "match_teamNoFill 1" )
}


void function ModeButton_OnActivate( var button )
{
	if ( Hud_IsLocked( button ) || !CanActivateModeButton() )
		return

	AdvanceMenu( GetMenu( "ModeSelectDialog" ) )
}


void function GameModeSelectV2Button_OnActivate( var button )
{
	if ( Hud_IsLocked( button ) || !CanActivateModeButton() )
		return

	Hud_SetVisible( file.gamemodeSelectV2Button, false )
	Hud_SetVisible( file.readyButton, false )
	AdvanceMenu( GetMenu( "GamemodeSelectV2Dialog" ) )
}


void function GameModeSelectV2Button_OnGetFocus( var button )
{
	GamemodeSelectV2_PlayVideo( button, file.selectedPlaylist )
}


void function GameModeSelectV2Button_OnLoseFocus( var button )
{
	//
}


void function Lobby_OnGamemodeSelectV2Close()
{
	Hud_SetVisible( file.gamemodeSelectV2Button, true )
	Hud_SetVisible( file.readyButton, true )
}


void function PlayPanel_OnNavBack( var panel )
{
	if ( !IsControllerModeActive() )
		return

	bool isReady = GetConVarBool( "party_readyToSearch" )
	if ( !AreWeMatchmaking() && !isReady )
		return

	CancelMatchmaking()
	ClientCommand( "CancelMatchSearch" )
}


void function ReadyShortcut_OnActivate( var panel )
{
	if ( AreWeMatchmaking() )
		return

	ReadyButton_OnActivate( file.readyButton )
}


void function ReadyButton_OnActivate( var button )
{
	if ( Hud_IsLocked( file.readyButton ) || !CanActivateReadyButton() )
		return

	bool isReady                   = GetConVarBool( "party_readyToSearch" )
	bool requireConsensusForSearch = GetConVarBool( "party_requireConsensusForSearch" )

	if ( AreWeMatchmaking() || isReady )
	{
		CancelMatchmaking()
		ClientCommand( "CancelMatchSearch" )
		EmitUISound( SOUND_STOP_MATCHMAKING_1P )
	}
	else
	{
		if ( !IsGameFullyInstalled() || HasNonFullyInstalledAssetsLoaded() )
		{
			ConfirmDialogData data
			data.headerText = "#TEXTURE_STREAM_HEADER"
			data.messageText = Localize( "#TEXTURE_STREAM_MESSAGE", floor( GetGameFullyInstalledProgress() * 100 ) )
			data.yesText = ["#TEXTURE_STREAM_PLAY", "#TEXTURE_STREAM_PLAY_PC"]
			data.noText = ["#TEXTURE_STREAM_WAIT", "#TEXTURE_STREAM_WAIT_PC"]
			if ( GetGameFullyInstalledProgress() >= 1 && HasNonFullyInstalledAssetsLoaded() )
			{
				//
				data.headerText = "#TEXTURE_STREAM_REBOOT_HEADER"
				data.messageText = "#TEXTURE_STREAM_REBOOT_MESSAGE"
				data.yesText = ["#TEXTURE_STREAM_REBOOT", "#TEXTURE_STREAM_REBOOT_PC"]
				data.noText = ["#TEXTURE_STREAM_PLAY_ON_NO", "#TEXTURE_STREAM_PLAY_PC"]
			}

			data.resultCallback = void function ( int result ) : ()
			{
				if ( GetGameFullyInstalledProgress() >= 1 && HasNonFullyInstalledAssetsLoaded() )
				{
					//
					if ( result == eDialogResult.YES )
					{
						//
						ClientCommand( "disconnect" )
						return
					}
				}
				else if ( result != eDialogResult.YES )
				{
					//
					return

				}

				//
				ReadyButtonActivate()
			}

			if ( !IsDialog( GetActiveMenu() ) )
				OpenConfirmDialogFromData( data )
			return
		}

		bool isLeader = IsPartyLeader()

		if ( isLeader && ShouldShowLowPopDialog( file.selectedPlaylist ) )
		{
			OpenLowPopDialog( ReadyButtonActivateForDataCenter )
		}
		else
		{
			ReadyButtonActivate()
		}
	}
}


void function ReadyButtonActivateForDataCenter( int datacenterIndex )
{
	LowPop_SetRankedDatacenter( datacenterIndex )
	ReadyButtonActivate()
}


void function ReadyButtonActivate()
{
	if ( Hud_IsLocked( file.readyButton ) || !CanActivateReadyButton() )
		return

	else
	{
		EmitUISound( SOUND_START_MATCHMAKING_1P )

		if ( GetConVarBool( "match_teamNoFill" ) && DoesPlaylistSupportNoFillTeams( file.selectedPlaylist ) )
			StartMatchmakingWithNoFillTeams( file.selectedPlaylist )
		else
			StartMatchmakingStandard( file.selectedPlaylist )
	}
}


void function InviteFriendsButton_OnActivate( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	#if(PC_PROG)
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

	thread CreatePartyAndInviteFriends()
}


void function InviteLastPlayedButton_OnActivate( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	int scriptID = int( Hud_GetScriptID( button ) )

	#if(PC_PROG)
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


	if ( scriptID == 0 )
	{
		InvitePlayerByUID ( file.lastPlayedPlayerPlatformUid0 )
		file.lastPlayedPlayerInviteSentTimestamp0 = Time()
		HudElem_SetRuiArg( button, "unitframeFooterText", "#INVITE_PLAYER_INVITED" )
		Hud_SetLocked( button, true )
	}
	else if ( scriptID == 1 )
	{
		InvitePlayerByUID ( file.lastPlayedPlayerPlatformUid1 )
		file.lastPlayedPlayerInviteSentTimestamp1 = Time()
		HudElem_SetRuiArg( button, "unitframeFooterText", "#INVITE_PLAYER_INVITED" )
		Hud_SetLocked( button, true )
	}
}


void function InviteLastPlayedButton_OnRightClick( var button )
{
	int scriptID = int( Hud_GetScriptID( button ) )

	Friend friend

	if ( scriptID == 0 )
	{
		friend.name = expect string( GetPersistentVar( "lastGameSquadStats[" + file.lastPlayedPlayerPersistenceIndex0 + "].playerName" ) )
		friend.hardware = file.lastPlayedPlayerHardware0
		friend.id = file.lastPlayedPlayerPlatformUid0
	}

	if ( scriptID == 1 )
	{
		friend.name = expect string( GetPersistentVar( "lastGameSquadStats[" + file.lastPlayedPlayerPersistenceIndex1 + "].playerName" ) )
		friend.hardware = file.lastPlayedPlayerHardware1
		friend.id = file.lastPlayedPlayerPlatformUid1
	}

	if ( friend.id == "" )
		return

	InspectFriend( friend )
}


void function InvitePlayerByUID( string platformUID )
{
	array<string> ids
	ids.append( platformUID )

	printt( " InviteFriend id:", ids[0] )
	DoInviteToParty( ids )
}


void function FriendButton_OnActivate( var button )
{
	int scriptID = int( Hud_GetScriptID( button ) )
	if ( scriptID == -1 )
	{
		Friend friend
		friend.status = eFriendStatus.ONLINE_INGAME
		friend.name = GetPlayerName()
		friend.hardware = ""
		friend.ingame = true
		friend.id = GetPlayerUID()

		Party party = GetParty()
		friend.presence = Localize( "#PARTY_N_N", party.numClaimedSlots, party.numSlots )
		friend.inparty = party.numClaimedSlots > 0

		InspectFriend( friend )
	}
	else
	{
		InspectFriend( scriptID == 0 ? file.friendInLeftSpot : file.friendInRightSpot )
	}
}


void function FriendButton_OnRightClick( var button )
{
	int scriptID = int( Hud_GetScriptID( button ) )

	if ( scriptID == 0 )
		TogglePlayerVoiceMutedForUID( file.friendInLeftSpot.id )
	else
		TogglePlayerVoiceMutedForUID( file.friendInRightSpot.id )
}


void function CreatePartyAndInviteFriends()
{
	if ( CanInvite() )
	{
		while ( !PartyHasMembers() && !AmIPartyLeader() )
		{
			printt( "creating a party in CreatePartyAndInviteFriends" )
			ClientCommand( "createparty" )
			WaitFrameOrUntilLevelLoaded()
		}

		InviteFriends()
	}
	else
	{
		printt( "Not inviting friends - CanInvite() returned false" )
	}
}


void function InviteRoomButton_OnActivate( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	entity player = GetUIPlayer()

	if ( !DoesCurrentCommunitySupportInvites() )
	{
		//
		return
	}

	SendOpenInvite( true )
}


void function OpenLootBoxButton_OnActivate( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	OnLobbyOpenLootBoxMenu_ButtonPress()
}


void function UpdatePlayPanelGRXDependantElements()
{
	bool isReady = GRX_IsInventoryReady()

	int lootBoxCount = 0
	if ( isReady )
		lootBoxCount = GRX_GetTotalPackCount()

	Hud_SetVisible( file.openLootBoxButton, lootBoxCount > 0 )

	UpdateLootBoxButton( file.openLootBoxButton )

	#if(true)
		UpdateLobbyChallengeMenu()
	#endif
}


void function UpdateLootBoxButton( var button )
{
	string buttonText
	string descText
	int lootBoxCount
	int nextRarity

	if ( GRX_IsInventoryReady() )
	{
		lootBoxCount = GRX_GetTotalPackCount()
		buttonText = lootBoxCount == 1 ? "#LOOT_BOX" : "#LOOT_BOXES"
		descText = "#LOOT_REMAINING"
		nextRarity = GetNextLootBoxRarity()
	}
	else
	{
		lootBoxCount = 0
		buttonText = "#LOOT_BOXES"
		descText = "#UNAVAILABLE"
		nextRarity = -1
	}

	HudElem_SetRuiArg( button, "bigText", string( lootBoxCount ) )
	HudElem_SetRuiArg( button, "buttonText", buttonText )
	HudElem_SetRuiArg( button, "descText", descText )
	HudElem_SetRuiArg( button, "lootBoxCount", lootBoxCount )
	HudElem_SetRuiArg( button, "badLuckProtectionActive", GRX_IsBadLuckProtectionActive() )
	HudElem_SetRuiArg( button, "descTextRarity", nextRarity )

	Hud_SetLocked( button, lootBoxCount == 0 )
}


void function PlayPanelUpdate()
{
	UpdateLobbyButtons()
	UpdateHDTextureProgress()
}


bool function ChatroomIsVisibleAndNotFocused()
{
	if ( !file.chatroomMenu )
		return false

	return Hud_IsVisible( file.chatroomMenu ) && !Hud_IsFocused( file.chatroomMenu_chatroomWidget )
}


bool function CanInvite()
{
	if ( Player_NextAvailableMatchmakingTime( GetUIPlayer() ) > 0 )
		return false

	if ( GetParty().amIInThis == false )
		return false

	if ( GetParty().numFreeSlots == 0 )
		return false

	#if(DURANGO_PROG)
		return (GetMenuVarBool( "isFullyConnected" ) && GetMenuVarBool( "DURANGO_canInviteFriends" ) && GetMenuVarBool( "DURANGO_isJoinable" ))
	#elseif(PS4_PROG)
		return GetMenuVarBool( "PS4_canInviteFriends" )
	#elseif(PC_PROG)
		return (GetMenuVarBool( "isFullyConnected" ) && GetMenuVarBool( "ORIGIN_isEnabled" ) && GetMenuVarBool( "ORIGIN_isJoinable" ))
	#endif
}


bool function CompletedTraining()
{
	if ( !IsFullyConnected() || !IsPersistenceAvailable() )
		return false

	if ( !GetVisiblePlaylistNames().contains( PLAYLIST_TRAINING ) )
		return true

	if ( GetCurrentPlaylistVarBool( "require_training", true ) )
		return GetPersistentVarAsInt( "trainingCompleted" ) > 0

	return true
}


void function OnRemoteMatchInfoUpdated()
{
	RemoteMatchInfo matchInfo = GetRemoteMatchInfo()
	if ( matchInfo.playlist == "" )
		return

	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
}


var function GetPartyMemberButton( string uid )
{
	if ( uid == GetPlayerUID() )
		return file.selfButton
	else if ( uid == file.friendInLeftSpot.id )
		return file.friendButton0
	else if ( uid == file.friendInRightSpot.id )
		return file.friendButton1

	return null
}

#if(DEV)
void function DEV_PrintPartyInfo()
{
	Party party = GetParty()
	printt( "party.partyType", party.partyType )
	printt( "party.playlistName", party.playlistName )
	printt( "party.originatorName", party.originatorName )
	printt( "party.originatorUID", party.originatorUID )
	printt( "party.numSlots", party.numSlots )
	printt( "party.numClaimedSlots", party.numClaimedSlots )
	printt( "party.numFreeSlots", party.numFreeSlots )
	printt( "party.timeLeft", party.timeLeft )
	printt( "party.amIInThis", party.amIInThis )
	printt( "party.amILeader", party.amILeader )
	printt( "party.searching", party.searching )

	foreach ( member in party.members )
	{
		printt( "\tmember.name", member.name )
		printt( "\tmember.uid", member.uid )
		printt( "\tmember.hardware", member.hardware )
		printt( "\tmember.ready", member.ready )

		CommunityUserInfo ornull userInfo = GetUserInfo( member.hardware, member.uid )
		if ( userInfo == null )
			continue

		expect CommunityUserInfo( userInfo )

		DEV_PrintUserInfo( userInfo, "\t\t" )
	}
}

void function DEV_PrintUserInfo( CommunityUserInfo userInfo, string prefix = "" )
{
	printt( prefix + "userInfo.hardware", userInfo.hardware )
	printt( prefix + "userInfo.uid", userInfo.uid )
	printt( prefix + "userInfo.name", userInfo.name )
	printt( prefix + "userInfo.kills", userInfo.kills )
	printt( prefix + "userInfo.wins", userInfo.wins )
	printt( prefix + "userInfo.matches", userInfo.matches )
	printt( prefix + "userInfo.eliteStreak", userInfo.eliteStreak )
	printt( prefix + "userInfo.lastCharIdx", userInfo.lastCharIdx )
	printt( prefix + "userInfo.isLivestreaming", userInfo.isLivestreaming )
	printt( prefix + "userInfo.isOnline", userInfo.isOnline )
	printt( prefix + "userInfo.isJoinable", userInfo.isJoinable )
	printt( prefix + "userInfo.privacySetting", userInfo.privacySetting )
	printt( prefix + "userInfo.partyFull", userInfo.partyFull )
	printt( prefix + "userInfo.partyInMatch", userInfo.partyInMatch )
	printt( prefix + "userInfo.lastServerChangeTime", userInfo.lastServerChangeTime )

	foreach ( int index, data in userInfo.charData )
	{
		printt( prefix + "\tuserInfo.charData[" + index + "]", data, "\t" + DEV_GetEnumStringSafe( "ePlayerStryderCharDataArraySlots", index ) )
	}
}
#endif


#if(true)
void function AllChallengesButton_OnActivate( var button )
{
	if ( IsDialog( GetActiveMenu() ) )
		return

	if ( !IsTabPanelActive( GetPanel( "PlayPanel" ) ) )
		return

	AdvanceMenu( GetMenu( "AllChallengesMenu" ) )
}
#endif


void function Lobby_UpdatePlayPanelPlaylists()
{
	file.playlists = GetVisiblePlaylistNames()
	Assert( file.playlists.len() > 0 )

	if ( !IsFullyConnected() )
		return

	if ( AreWeMatchmaking() )
		return

	if ( !CompletedTraining() && IsPartyLeader() && GetPartySize() == 1 )
	{
		Lobby_SetSelectedPlaylist( PLAYLIST_TRAINING )
		SetMatchmakingPlaylist( PLAYLIST_TRAINING ) //
	}
	else if ( !file.playlists.contains( file.selectedPlaylist ) || file.selectedPlaylist == PLAYLIST_TRAINING )
	{
		foreach ( playlist in file.playlists )
		{
			if ( playlist == PLAYLIST_TRAINING )
				continue

			Lobby_SetSelectedPlaylist( playlist )
			break
		}
	}

	#if(true)
		if ( PartyHasEliteAccess() )
		{
			if ( GetPersistentVar( "shouldForceElitePlaylist" ) )
				ForceElitePlaylist()
		}
		else if ( IsElitePlaylist( file.selectedPlaylist ) )
		{
			ForceNonElitePlaylist()
		}
	#endif
}


#if(true)
void function ForceElitePlaylist()
{
	printt( "ForceElitePlaylist" )
	foreach ( playlist in file.playlists )
	{
		if ( !IsElitePlaylist( playlist ) )
			continue

		Lobby_SetSelectedPlaylist( playlist )
		break
	}
}
#endif


#if(true)
void function ForceNonElitePlaylist()
{
	printt( "ForceNonElitePlaylist" )
	foreach ( playlist in file.playlists )
	{
		if ( IsElitePlaylist( playlist ) )
			continue

		Lobby_SetSelectedPlaylist( playlist )
		break
	}
}
#endif


#if(true)
bool function HasEliteAccess()
{
	if ( !IsFullyConnected() )
		return false

	return GetPersistentVarAsInt( "hasEliteAccess" ) > 0
}
#endif


#if(true)
bool function PartyHasEliteAccess()
{
	if ( !IsFullyConnected() )
		return false

	if ( HasEliteAccess() )
		return true

	if ( GetCurrentPlaylistVarBool( "elite_dev_playtest", false ) )
		return true

	Party party = GetParty()
	foreach ( member in party.members )
	{
		CommunityUserInfo ornull userInfoOrNull = GetUserInfo( member.hardware, member.uid )

		if ( userInfoOrNull != null )
		{
			CommunityUserInfo userInfo = expect CommunityUserInfo(userInfoOrNull)

			if ( userInfo.eliteStreak > 0 )
				return true
		}
	}

	return false
}
#endif


void function PulseModeButton()
{
	var rui = Hud_GetRui( file.modeButton )
	RuiSetGameTime( rui, "startPulseTime", Time() )
}


