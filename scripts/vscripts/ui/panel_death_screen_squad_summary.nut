global function InitDeathScreenSquadSummaryPanel
global function UI_UpdateSquadSummary

struct panelData
{
	var              panel
	table<var, bool> cardsInitialized
	array<var>       gCards
}

struct
{
	var                    panel
	table<var, panelData>  panelData
	table<var, string>     buttonToUID
	array<var>             buttons
} file


void function InitDeathScreenSquadSummaryPanel( var panel )
{
	AddUICallback_UIShutdown( SquadSummaryMenu_Shutdown )                             

	file.panel = panel

	panelData data
	data.gCards.append( Hud_GetChild( panel, "GCard0" ) )
	data.gCards.append( Hud_GetChild( panel, "GCard1" ) )
	data.gCards.append( Hud_GetChild( panel, "GCard2" ) )
	data.panel = panel
	foreach ( elem in data.gCards )
		data.cardsInitialized[ elem ] <- false

	file.panelData[ panel ] <- data

	int i
	foreach ( elem in file.panelData[ panel ].gCards )
	{
		var button
		if ( i > 0 )
		{
			{
				button = Hud_GetChild( panel, "TeammateMute" + i )
				AddButtonEventHandler( button, UIE_CLICK, OnMuteButtonClick )
				RuiSetImage( Hud_GetRui( button ), "unmuteIcon", $"rui/menu/lobby/icon_voicechat" )
				RuiSetImage( Hud_GetRui( button ), "muteIcon", $"rui/menu/lobby/icon_voicechat_muted" )
				ToolTipData d1
				d1.tooltipFlags = d1.tooltipFlags | eToolTipFlag.CLIENT_UPDATE
				d1.tooltipStyle = eTooltipStyle.DEFAULT
				Hud_SetToolTipData( button, d1 )
				file.buttons.append( button )
				AddButtonEventHandler( button, UIE_GET_FOCUS, OnButtonFocus )
				AddButtonEventHandler( button, UIE_LOSE_FOCUS, OnButtonFocus )
			}

			{
				button = Hud_GetChild( panel, "TeammateInvite" + i )
				AddButtonEventHandler( button, UIE_CLICK, OnInviteButtonClick )
				ToolTipData d4
				d4.tooltipFlags = d4.tooltipFlags | eToolTipFlag.CLIENT_UPDATE
				d4.tooltipStyle = eTooltipStyle.DEFAULT
				Hud_SetToolTipData( button, d4 )
				file.buttons.append( button )
				AddButtonEventHandler( button, UIE_GET_FOCUS, OnButtonFocus )
				AddButtonEventHandler( button, UIE_LOSE_FOCUS, OnButtonFocus )
			}

			{
				button = Hud_GetChild( panel, "TeammateReport" + i )
				AddButtonEventHandler( button, UIE_CLICK, OnReportButtonClick )
				RuiSetImage( Hud_GetRui( button ), "unmuteIcon", $"rui/menu/lobby/icon_report" )
				RuiSetImage( Hud_GetRui( button ), "muteIcon", $"rui/menu/lobby/icon_report" )
				ToolTipData d5
				d5.tooltipFlags = d5.tooltipFlags | eToolTipFlag.CLIENT_UPDATE
				d5.tooltipStyle = eTooltipStyle.DEFAULT
				Hud_SetToolTipData( button, d5 )
				file.buttons.append( button )
				AddButtonEventHandler( button, UIE_GET_FOCUS, OnButtonFocus )
				AddButtonEventHandler( button, UIE_LOSE_FOCUS, OnButtonFocus )
			}

			{
				button = Hud_GetChild( panel, "TeammateBlock" + i )
				AddButtonEventHandler( button, UIE_CLICK, OnBlockButtonClick )
				RuiSetImage( Hud_GetRui( button ), "unmuteIcon", $"rui/menu/crossplatform/blocked" )                                       
				RuiSetImage( Hud_GetRui( button ), "muteIcon", $"rui/menu/crossplatform/blocked" )
				ToolTipData d6
				d6.tooltipFlags = d6.tooltipFlags | eToolTipFlag.CLIENT_UPDATE
				d6.tooltipStyle = eTooltipStyle.DEFAULT
				Hud_SetToolTipData( button, d6 )
				file.buttons.append( button )
				AddButtonEventHandler( button, UIE_GET_FOCUS, OnButtonFocus )
				AddButtonEventHandler( button, UIE_LOSE_FOCUS, OnButtonFocus )
			}

			{
				button = Hud_GetChild( panel, "GCardOverlay" + i )
				AddButtonEventHandler( button, UIE_GET_FOCUS, OnButtonFocus )
				AddButtonEventHandler( button, UIE_LOSE_FOCUS, OnButtonFocus )
				file.buttons.append( button )
				RegisterButtonForUID( button )
			}
		}
		i++
	}

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, SquadSummaryOnOpenPanel )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, SquadSummaryOnClosePanel )

	InitDeathScreenPanelFooter( panel, eDeathScreenPanel.SQUAD_SUMMARY )
}


void function SquadSummaryOnOpenPanel( var panel )
{
	                                                

	var menu = GetParentMenu( panel )
	var headerElement = Hud_GetChild( menu, "Header" )
	var headerDataElement = Hud_GetChild( panel, "Header" )
	RunClientScript( "UICallback_ShowSquadSummary", headerElement, headerDataElement )

	int i
	foreach ( cardElem in file.panelData[ panel ].gCards )
	{
		var muteButton
		var nullMutePingButton = null
		var inviteButton
		var nullInviteButton = null
		var reportButton
		var overlayButton
		var nullOverlayButton = null
		var nullDisconnectedElem = null
		var blockButton
		var obfuscatedID

		if ( i > 0 )
		{
			muteButton = Hud_GetChild( panel, "TeammateMute" + i )
			inviteButton = Hud_GetChild( panel, "TeammateInvite" + i )
			reportButton = Hud_GetChild( panel, "TeammateReport" + i )
			overlayButton = Hud_GetChild( panel, "GCardOverlay" + i )
			blockButton = Hud_GetChild( panel, "TeammateBlock"+i )
			obfuscatedID = Hud_GetChild( panel, "TeammateObfuscatedID"+i )

			Hud_ClearToolTipData( overlayButton )
		}

		                                                         

		RunClientScript( "UICallback_PopulatePlayerStatsRui", cardElem, i )

		int presentation = eGladCardPresentation.FRONT_CLEAN                        
		RunClientScript( "UICallback_PopulateClientGladCard", panel, cardElem, muteButton, nullMutePingButton, reportButton, blockButton, nullInviteButton, overlayButton, nullDisconnectedElem, obfuscatedID, i, ClientTime(), presentation )
		RunClientScript( "UICallback_UpdateGladCardVisibility", panel, cardElem, i )
		RunClientScript( "UICallback_PlayerStatusUpdateThread", panel, cardElem, muteButton, nullMutePingButton, reportButton, inviteButton, nullOverlayButton, nullDisconnectedElem, i )

		file.panelData[panel].cardsInitialized[cardElem] = true

		if ( Hud_GetHudName( cardElem ) == "GCard0" )
		{
			Hud_SetX( cardElem, 0 )
			if ( GetExpectedSquadSize( GetLocalClientPlayer() ) == 2 )
				Hud_SetX( cardElem, 201 )
		}

		i++
	}

	DeathScreenUpdateCursor()

	RunClientScript( "UICallback_SquadSummaryDisplayed" )
}


void function UI_UpdateSquadSummary()
{
	SquadSummaryOnOpenPanel( file.panel )
}

void function SquadSummaryOnClosePanel( var panel )
{
	RunClientScript( "UICallback_HideSquadSummary" )

	foreach ( elem in file.panelData[ panel ].gCards )
	{
		if ( file.panelData[panel].cardsInitialized[elem] )
		{
			RunClientScript( "UICallback_DestroyClientGladCardData", elem )
			file.panelData[panel].cardsInitialized[elem] = false
		}
	}
}


void function SquadSummaryMenu_Shutdown()
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


void function OnButtonFocus( var button )
{
	UpdateFooterOptions()
}


bool function IsNotFocusedOnAButton()
{
	return (file.buttons.contains( GetFocus() ))
}
