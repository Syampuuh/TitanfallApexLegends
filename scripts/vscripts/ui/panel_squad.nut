global function InitSquadPanel
global function ClientCallback_SetStartTimeForRui
global function ClientCallback_UpdatePlayerOverlayButton

global function RegisterButtonForUID

struct SquadPanelData
{
	var panel
	table<var,bool> cardsInitialized
	array<var> gCards
}

struct SquadPlayerData
{
	string name
	string uid
	string hardware
	string eaid
	string unspoofedUid
}

struct
{
	table<var,SquadPanelData> squadPanels
	table<var,string> buttonToUID
	table<var, SquadPlayerData> buttonToPlayerData
} file


void function InitSquadPanel( var panel )
{
	SquadPanelData data
	data.gCards.append( Hud_GetChild( panel, "GCard0" ) )
	data.gCards.append( Hud_GetChild( panel, "GCard1" ) )
	data.gCards.append( Hud_GetChild( panel, "GCard2" ) )
	data.panel = panel
	foreach ( elem in data.gCards )
		data.cardsInitialized[ elem ] <- false

	file.squadPanels[ panel ] <- data

	int i
	foreach ( elem in file.squadPanels[ panel ].gCards )
	{
		var button
		if ( i > 0 )
		{
			{
				button = Hud_GetChild( panel, "TeammateMute"+i )
				AddButtonEventHandler( button, UIE_CLICK, OnMuteButtonClick )
				RuiSetImage( Hud_GetRui( button ), "unmuteIcon", $"rui/menu/lobby/icon_voicechat" )
				RuiSetImage( Hud_GetRui( button ), "muteIcon", $"rui/menu/lobby/icon_voicechat_muted" )
				ToolTipData d1
				d1.tooltipFlags = d1.tooltipFlags | eToolTipFlag.CLIENT_UPDATE
				d1.tooltipStyle = eTooltipStyle.DEFAULT
				Hud_SetToolTipData( button, d1 )
			}

			{
				button = Hud_GetChild( panel, "TeammateMutePing"+i )
				AddButtonEventHandler( button, UIE_CLICK, OnMutePingButtonClick )
				RuiSetImage( Hud_GetRui( button ), "unmuteIcon", $"rui/menu/lobby/icon_ping" )
				RuiSetImage( Hud_GetRui( button ), "muteIcon", $"rui/menu/lobby/icon_ping_muted" )
				ToolTipData d2
				d2.tooltipFlags = d2.tooltipFlags | eToolTipFlag.CLIENT_UPDATE
				d2.tooltipStyle = eTooltipStyle.DEFAULT
				Hud_SetToolTipData( button, d2 )
			}

			{
				button = Hud_GetChild( panel, "TeammateInvite"+i )
				AddButtonEventHandler( button, UIE_CLICK, OnInviteButtonClick )
				ToolTipData d4
				d4.tooltipFlags = d4.tooltipFlags | eToolTipFlag.CLIENT_UPDATE
				d4.tooltipStyle = eTooltipStyle.DEFAULT
				Hud_SetToolTipData( button, d4 )
			}

			{
				button = Hud_GetChild( panel, "TeammateReport"+i )
				AddButtonEventHandler( button, UIE_CLICK, OnReportButtonClick )
				RuiSetImage( Hud_GetRui( button ), "unmuteIcon", $"rui/menu/lobby/icon_report" )
				RuiSetImage( Hud_GetRui( button ), "muteIcon", $"rui/menu/lobby/icon_report" )
				ToolTipData d5
				d5.tooltipFlags = d5.tooltipFlags | eToolTipFlag.CLIENT_UPDATE
				d5.tooltipStyle = eTooltipStyle.DEFAULT
				Hud_SetToolTipData( button, d5 )
			}

			{
				button = Hud_GetChild( panel, "TeammateBlock"+i )
				AddButtonEventHandler( button, UIE_CLICK, OnBlockButtonClick )
				RuiSetImage( Hud_GetRui( button ), "unmuteIcon", $"rui/menu/crossplatform/blocked" )                                       
				RuiSetImage( Hud_GetRui( button ), "muteIcon", $"rui/menu/crossplatform/blocked" )
				ToolTipData d6
				d6.tooltipFlags = d6.tooltipFlags | eToolTipFlag.CLIENT_UPDATE
				d6.tooltipStyle = eTooltipStyle.DEFAULT
				Hud_SetToolTipData( button, d6 )
			}

			{
				button = Hud_GetChild( panel, "GCardOverlay"+i )

				RegisterButtonForUID( button )
			}
		}
		i++
	}

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnShowSquad )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnHideSquad )

	if ( !( uiGlobal.uiShutdownCallbacks.contains(SquadPanel_Shutdown) ) )
		AddUICallback_UIShutdown( SquadPanel_Shutdown )
}


void function SquadPanel_Shutdown()
{
	if ( IsFullyConnected() )
		RunClientScript( "UICallback_DestroyAllClientGladCardData" )
}


void function OnMuteButtonClick( var button )
{
	RunClientScript( "UICallback_ToggleMute", button )
}


void function OnMutePingButtonClick( var button )
{
	RunClientScript( "UICallback_ToggleMutePing", button )
}


void function OnInviteButtonClick( var button )
{
	if ( Hud_IsSelected( button ) )
		return

	RunClientScript( "UICallback_InviteSquadMate", button )
}


void function OnReportButtonClick( var button )
{
	RunClientScript( "UICallback_ReportSquadMate", button )
}


void function OnBlockButtonClick( var button )
{
	printt( "#EADP OnBlockButtonClick" )
	RunClientScript( "UICallback_BlockSquadMate", button )
}


void function OnShowSquad( var panel )
{
	SurvivalInventory_SetBGVisible( true )

	int i
	foreach ( elem in file.squadPanels[ panel ].gCards )
	{
		var muteButton
		var mutePingButton
		var inviteButton
		var nullInviteButton = null
		var reportButton
		var overlayButton
		var disconnectedElem
		var blockButton
		var obfuscatedID

		if ( i > 0 )
		{
			muteButton = Hud_GetChild( panel, "TeammateMute"+i )
			mutePingButton = Hud_GetChild( panel, "TeammateMutePing"+i )
			inviteButton = Hud_GetChild( panel, "TeammateInvite"+i )
			reportButton = Hud_GetChild( panel, "TeammateReport"+i )
			overlayButton = Hud_GetChild( panel, "GCardOverlay"+i )
			disconnectedElem = Hud_GetChild( panel, "TeammateDisconnected"+i )
			blockButton = Hud_GetChild( panel, "TeammateBlock"+i )
			obfuscatedID = Hud_GetChild( panel, "TeammateObfuscatedID"+i )

			Hud_ClearToolTipData( overlayButton )
		}

		RunClientScript( "UICallback_PopulateClientGladCard", panel, elem, muteButton, mutePingButton, reportButton, blockButton, nullInviteButton, overlayButton, disconnectedElem, obfuscatedID, i, ClientTime(), eGladCardPresentation.FULL_BOX )
		RunClientScript( "UICallback_UpdateGladCardVisibility", panel, elem, i )
		file.squadPanels[panel].cardsInitialized[elem] = true

		i++
	}
}


void function ClientCallback_UpdatePlayerOverlayButton( var panel, var overlayButton, string name, string uid, string hardware, string eaid, string unspoofedUid, int buttonIndex )
{
	AssignPlayerToButton( overlayButton, name, uid, hardware, eaid, unspoofedUid )

	if ( uid == "" || hardware == "" )
	{
		Hud_Hide( overlayButton )
		return
	}
	else
	{
		Hud_Show( overlayButton )
	}

	bool canAddFriend = CanSendFriendRequest( GetLocalClientPlayer() ) && !EADP_IsFriendByEAID( eaid )
	bool canInviteParty = CanInviteSquadMate( uid ) && CanInviteToparty() == 0

	printt( "eaid", eaid, "is friend", EADP_IsFriendByEAID( eaid ), canAddFriend, canInviteParty )

	if ( canAddFriend )
	{
		                                                                                                                          
		CommunityFriends friends = GetFriendInfo()
		foreach ( id in friends.ids )
		{
			if ( uid == id )
			{
				canAddFriend = false
				break
			}
		}
	}

	if ( canInviteParty || canAddFriend )
	{
		ToolTipData td
		td.tooltipStyle = eTooltipStyle.DEFAULT
		td.titleText = ""
		td.descText = name
		td.actionHint2 = canInviteParty ? "#CLICK_INVITE_PARTY" : ""
		td.actionHint1 = canAddFriend ? "#RCLICK_INVITE_FRIEND" : ""
		Hud_SetToolTipData( overlayButton, td )
	}
}


void function OnHideSquad( var panel )
{
	foreach ( elem in file.squadPanels[ panel ].gCards )
	{
		if ( file.squadPanels[panel].cardsInitialized[elem] )
		{
			RunClientScript( "UICallback_DestroyClientGladCardData", elem )
			file.squadPanels[panel].cardsInitialized[elem] = false
		}
	}
}


void function ClientCallback_SetStartTimeForRui( var elem, float delay )
{
	var rui = Hud_GetRui( elem )
	RuiSetGameTime( rui, "startTime", ClientTime() + delay )
}


void function OnOverlayClick( var button )
{
	SquadPlayerData playerData = GetPlayerDataForButton( button )

	if ( playerData.uid == "" )                                               
		return

	bool canInviteParty = CanInviteSquadMate( playerData.uid ) && CanInviteToparty() == 0

	if ( !canInviteParty )
		return

	ToolTipData td = Hud_GetToolTipData( button )
	td.actionHint2 = "#STATUS_PARTY_REQUEST_SENT"

	string hardware = GetUnspoofedPlayerHardware()
	if ( hardware == playerData.hardware )
	{
		                                                      
		DoInviteToParty( [ playerData.uid ] )
	}
	else if ( CrossplayEnabled() && playerData.eaid != "" )
	{
		                                      
		printt( " InviteEADPFriend id:", playerData.eaid )
		EADP_InviteToPlayByEAID( playerData.eaid , 0 )
	}
}


void function OnOverlayClickRight( var button )
{
	SquadPlayerData playerData = GetPlayerDataForButton( button )

	if ( playerData.uid == "" )
		return

	bool canAddFriend = CanSendFriendRequest( GetLocalClientPlayer() )

	if ( canAddFriend )
	{
		CommunityFriends friends = GetFriendInfo()
		foreach ( id in friends.ids )
		{
			if ( playerData.uid == id || playerData.unspoofedUid == id || EADP_IsFriendByEAID( playerData.eaid ) )
			{
				canAddFriend = false
				break
			}
		}
	}

	if ( !canAddFriend )
		return

	ToolTipData td = Hud_GetToolTipData( button )
	td.actionHint1 = "#STATUS_FRIEND_REQUEST_SENT"

	EmitUISound( "UI_Menu_InviteFriend_Send" )

	string hardware = GetUnspoofedPlayerHardware()
	if ( hardware == playerData.hardware )
	{
		DoInviteToBeFriend( playerData.unspoofedUid )
	}
	else if ( CrossplayEnabled() && playerData.eaid != "" )
	{
		                                      
		printt( "InviteEADPFriend id:", playerData.eaid )
		EADP_InviteFriendByEAID( playerData.eaid )
	}
}


void function RegisterButtonForUID( var button )
{
	AddButtonEventHandler( button, UIE_CLICK, OnOverlayClick )
	AddButtonEventHandler( button, UIE_CLICKRIGHT, OnOverlayClickRight )
	ToolTipData td
	td.tooltipFlags = td.tooltipFlags | eToolTipFlag.CLIENT_UPDATE
	td.tooltipStyle = eTooltipStyle.DEFAULT
	Hud_SetToolTipData( button, td )
	file.buttonToUID[ button ] <- ""
}


void function AssignPlayerToButton( var button, string name, string uid, string hardware, string eaid, string unspoofedUid )
{
	SquadPlayerData playerData
	playerData.name = name
	playerData.uid = uid
	playerData.hardware = hardware
	playerData.eaid = eaid
	playerData.unspoofedUid = unspoofedUid

	file.buttonToPlayerData[ button ] <- playerData
}


SquadPlayerData function GetPlayerDataForButton( var button )
{
	return file.buttonToPlayerData[ button ]
}