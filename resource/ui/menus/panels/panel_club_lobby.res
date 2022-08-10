"resource/ui/menus/panels/panel_club_lobby.res"
{
    Screen
    {
        ControlName				Label
        wide			        %100
        tall			        %100
        labelText				""
        visible					0
    }

    PanelFrame
    {
		ControlName				Label
		xpos					0
		ypos					0
		zpos                    -1
		cursorPriority          -1
		wide					%100
		tall					%100
		labelText				""
		visible				    0
        bgcolor_override        "0 0 0 64"
        paintbackground         1

        proportionalToParent    1
    }

    ToolTip
    {
        ControlName				RuiPanel
        InheritProperties       ToolTip
        zpos                    999
    }

    JoinRequestsPanel
    {
        ControlName             CNestedPanel
        wide                    %100
        tall                    64
        visible                 1
        controlSettingsFile     "resource/ui/menus/panels/panel_club_lobby_requests.res"

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   TOP
        pin_to_sibling_corner   TOP
    }

    ClubDetailsPanel
    {
        ControlName				CNestedPanel

        xpos                    -48
        ypos                    -136
        zpos                    1

        wide                    875
        tall                    250
        tall_nx_handheld        450		[$NX || $NX_UI_PC]

        visible					1
        controlSettingsFile		"resource/ui/menus/panels/panel_club_details.res"

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT
    }

    ClubDetailsRankTooltip
    {
        ControlName				CNestedPanel

        xpos                    0
        ypos                    0
        zpos                    10
        cursorPriority          10

        wide                    180
        tall                    75

        visible					1
        controlSettingsFile		"resource/ui/menus/panels/stats_tooltip_field.res"

        pin_to_sibling          ClubDetailsPanel
        pin_corner_to_sibling   BOTTOM_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
    }

    ClubDetailsPrivacyTooltip
    {
        ControlName				CNestedPanel

        xpos                    0
        ypos                    -60
        zpos                    10
        cursorPriority          10

        wide                    160
        tall                    50

        visible					1
        controlSettingsFile		"resource/ui/menus/panels/stats_tooltip_field.res"

        pin_to_sibling          ClubDetailsPanel
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT
    }

    ClubDetailsReqsTooltip
    {
        ControlName				CNestedPanel

        xpos                    6
        ypos                    0
        zpos                    10
        cursorPriority          10

        wide                    312
        tall                    50

        visible					1
        controlSettingsFile		"resource/ui/menus/panels/stats_tooltip_field.res"

        pin_to_sibling          ClubDetailsPrivacyTooltip
        pin_corner_to_sibling   LEFT
        pin_to_sibling_corner   RIGHT
    }

    ClubAdminControlsPanel
    {
        ControlName				CNestedPanel

        xpos                    -48
        xpos_nx_handheld        -10		[$NX || $NX_UI_PC]
		ypos                    0		[!$NX && !$NX_UI_PC]
		ypos			        -325	[$NX || $NX_UI_PC]
        zpos                    0

        wide                    875
        wide_nx_handheld		935		[$NX || $NX_UI_PC]
        tall                    480

        visible					1
        controlSettingsFile		"resource/ui/menus/panels/panel_club_admin_controls.res"

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   BOTTOM_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
    }

    ClubMemberListPanel
    {
        ControlName				CNestedPanel

        xpos                    -48
        ypos                    -136
        zpos                    10

        wide                    384
        tall                    638

        visible					1
        controlSettingsFile		"resource/ui/menus/panels/panel_club_lobby_member_list.res"

		proportionalToParent    1
        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   TOP_RIGHT
        pin_to_sibling_corner   TOP_RIGHT
    }

    ClubMemberListHeader
    {
        ControlName             RuiPanel
        rui                     "ui/club_member_list_header.rpak"

        ruiArgs
        {
            headerString         "#LOBBY_CLUB_MEMBERS_ONLINE_TITLE"
        }

        visible                 1

        wide                    385
        tall                    60

        xpos                    0
        ypos                    -1
        zpos                    0

        proportionalToParent    1
        pin_to_sibling          ClubMemberListPanel
        pin_corner_to_sibling   BOTTOM_LEFT
        pin_to_sibling_corner   TOP_LEFT
    }

    InviteReasonSwitch
    {
        ControlName             RuiButton

        wide                    385
        wide_nx_handheld        450		[$NX || $NX_UI_PC]
        tall                    60
        tall_nx_handheld        60      [$NX || $NX_UI_PC]
        xpos                    0
        xpos_nx_handheld        28		[$NX || $NX_UI_PC]
        ypos                    4
        ypos_nx_handheld        -10		[$NX || $NX_UI_PC]

        InheritProperties       SwitchButtonClubInvite
        style                   DialogListButton
        navLeft                 TabsCommon
        navDown                 InviteAllToPartyButton
        list
        {
            "#PARTY_INVITE_REASON_01_TRIOS"  0
            "#PARTY_INVITE_REASON_02_DUOS"      1
            "#PARTY_INVITE_REASON_03_ARENAS" 2
            "#PARTY_INVITE_REASON_04_RANKED"  3
            "#PARTY_INVITE_REASON_06_ANYMODE"  4
            "#PARTY_INVITE_REASON_07_GRINDING"  5
        }

        pin_to_sibling          ClubMemberListPanel
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT

        childGroupAlways        MultiChoiceButtonClubsInviteSelectorAlways

        proportionalToParent    1
    }

    InviteAllToPartyButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        wide					385
        wide_nx_handheld		450		[$NX || $NX_UI_PC]
        tall					50
        tall_nx_handheld		58		[$NX || $NX_UI_PC]
        xpos                    0
        ypos                    8
        ypos_nx_handheld		4	[$NX || $NX_UI_PC]
        zpos                    10
        rui                     "ui/club_invite_all_to_party_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7

		navLeft                 TabsCommon
        //navDown                   ModeButton

        proportionalToParent    1

        pin_to_sibling			InviteReasonSwitch
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT

        sound_focus             "UI_Menu_Focus_Large"
        sound_accept            "UI_Menu_Accept"
    }

    ClubEventTimeline
    {
        ControlName				Label
        wide					500
        tall					748
        xpos                    36
        ypos                    0
        zpos                    0
        labelText               ""
        textAlignment           "north"
        wrap                    1
        visible					1
        bgcolor_override        "30 32 47 192"
        paintbackground         0

        pin_to_sibling          ClubMemberListPanel
        pin_corner_to_sibling   TOP_RIGHT
        pin_to_sibling_corner   TOP_LEFT
    }

    ClubTabsBlur
    {
        ControlName				RuiPanel
        xpos                    0
        ypos					0
        wide					500
        tall					748

        rui                     "ui/clubs_panel_blur.rpak"
        ruiArgs
        {
            showFrame           "1"
        }

        visible					1

        proportionalToParent    1

        pin_to_sibling          ClubEventTimeline
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT
    }

    TabsCommon
    {
        ControlName				CNestedPanel
        classname				"TabsCommonClass"
        xpos                    -230
        ypos                    0
        ypos_nx_handheld        60           [$NX || $NX_UI_PC]
        zpos					1
        wide					f0
        tall					60
        visible					1
        controlSettingsFile		"resource/ui/menus/panels/tabs_club_lobby.res"

        pin_to_sibling			ClubEventTimeline
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
    }

    ClubEventTimelinePanel
    {
        ControlName				CNestedPanel
        classname               "TabPanelClass"

        xpos                    0
        ypos                    -60
        ypos_nx_handheld        0           [$NX || $NX_UI_PC]
        zpos                    0

        wide                    500
        tall                    688
        tall_nx_handheld        750         [$NX || $NX_UI_PC]

        visible					1
        controlSettingsFile		"resource/ui/menus/panels/panel_club_lobby_event_timeline.res"

        pin_to_sibling          ClubEventTimeline
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT
    }

    ClubChatPanel
    {
        ControlName				CNestedPanel
		classname               "TabPanelClass"

        xpos                    0
        ypos                    -60
        ypos_nx_handheld        0           [$NX || $NX_UI_PC]
        zpos                    0

        wide                    500
        tall                    688
        tall_nx_handheld        750         [$NX || $NX_UI_PC]

        visible					1
        controlSettingsFile		"resource/ui/menus/panels/panel_club_lobby_chat.res"

        pin_to_sibling          ClubEventTimeline
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT
    }

    TabPanelOutline
    {
        ControlName             RuiPanel
        rui                     "ui/club_lobby_tab_panel_outline.rpak"

        visible                 1

        wide                    500
        tall                    748

        xpos                    0
        ypos                    0
        zpos                    0

        proportionalToParent    1
        pin_to_sibling          ClubEventTimeline
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT
    }
}