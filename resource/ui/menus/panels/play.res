"resource/ui/menus/panels/play.res"
{
    PanelFrame
    {
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
		visible				    0
        bgcolor_override        "0 0 0 64"
        paintbackground         1

        proportionalToParent    1
    }

	ChatRoomTextChat
	{
		ControlName				CBaseHudChat
		xpos					32
		wide					992
		tall					208
		visible 				1
		enabled					1

		destination				"chatroom"
		interactive				1
		chatBorderThickness		1
		messageModeAlwaysOn		1
        setUnusedScrollbarInvisible 1
		hideInputBox			1 [$GAMECONSOLE]
		font 					Default_27

		bgcolor_override 		"0 0 0 0"
		chatHistoryBgColor		"24 27 30 10"
		chatEntryBgColor		"24 27 30 100"
		chatEntryBgColorFocused	"24 27 30 120"

        pin_to_sibling			ReadyButton
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_RIGHT
	}

    FillButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        wide					384
        tall					38
        ypos                    16
        rui                     "ui/generic_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7

        navRight                   InviteFriendsButton0
        navDown                 ModeButton

        proportionalToParent    1

        pin_to_sibling			ModeButton
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

    ModeButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        wide					384
        tall					76
        ypos                    16
        rui                     "ui/generic_dropdown_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7
        sound_accept            "UI_Menu_SelectMode_Extend"

        navUp                   FillButton
        navDown                 ReadyButton

        proportionalToParent    1

        pin_to_sibling			ReadyButton
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

    ReadyButton
    {
        ControlName				RuiButton
        classname               "MenuButton MatchmakingStatusRui"
        wide					384
        tall					112
        rui                     "ui/generic_ready_button.rpak"
        labelText               ""
        visible					1
		cursorVelocityModifier  0.7

		navUp                   ModeButton

        proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT

        sound_focus             "UI_Menu_Focus_Large"
    }

    OpenLootBoxButton
    {
        ControlName             RuiButton
        classname               "MenuButton"
        wide                    256
        tall                    112
        xpos                    0
        ypos                    -16
        rui                     "ui/generic_loot_button.rpak"
        labelText               ""
        visible                 1
        cursorVelocityModifier  0.7

        proportionalToParent    1

        navLeft                 InviteFriendsButton1

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   TOP_RIGHT
        pin_to_sibling_corner   TOP_RIGHT

        sound_focus             "UI_Menu_Focus_Large"
        sound_accept            "UI_Menu_OpenLootBox"
    }

    InviteFriendsButton0
    {
        ControlName				RuiButton
        InheritProperties       InviteButton
        xpos                    -400
        ypos                    -90

        navRight                FriendButton0
        navLeft                 FillButton

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	CENTER
        pin_to_sibling_corner	CENTER
    }

    InviteFriendsButton1
    {
        ControlName				RuiButton
        InheritProperties       InviteButton
        xpos                    400
        ypos                    -90

        navLeft                 FriendButton1
        navRight                OpenLootBoxButton

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	CENTER
        pin_to_sibling_corner	CENTER
    }

    SelfButton
    {
        ControlName				RuiButton
        wide					340
        tall					100
        xpos                    0
        ypos                    -18
        rui                     "ui/lobby_friend_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7
        scriptID                -1
        rightClickEvents		0
        tabPosition             1

        navLeft                 FriendButton0
        navRight                FriendButton1

        proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
    }


    FriendButton0
    {
        ControlName				RuiButton
        wide					340
        tall					100
        xpos                    -480
        ypos                    -64
        rui                     "ui/lobby_friend_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7
        scriptID                0
        rightClickEvents		1

        navLeft                 InviteFriendsButton0
        navRight                SelfButton

        proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
    }

    FriendButton1
    {
        ControlName				RuiButton
        wide					340
        tall					100
        xpos                    480
        ypos                    -64
        rui                     "ui/lobby_friend_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7
        scriptID                1
        rightClickEvents		1

        navLeft                 SelfButton
        navRight                InviteFriendsButton1

        proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
    }

	HDTextureProgress
	{
		ControlName				RuiPanel
		xpos					0
		ypos					70
		zpos					10
		wide					300
		tall					24
		visible					1
		proportionalToParent    1
		rui 					"ui/lobby_hd_progress.rpak"

		pin_to_sibling			TabsCommon
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    //ChatroomPanel
    //{
    //    ControlName				CNestedPanel
    //    ypos					0
    //    wide					%100
    //    tall					308
    //    visible					1
    //    controlSettingsFile		"resource/ui/menus/panels/chatroom.res"
    //    proportionalToParent    1
    //    pin_to_sibling          PanelFrame
    //    pin_corner_to_sibling	BOTTOM_RIGHT
    //    pin_to_sibling_corner	BOTTOM_RIGHT
    //}

    //OpenInvitePanel
    //{
    //    ControlName				CNestedPanel
    //    xpos					c-300
    //    ypos					r670
    //    zpos					10
    //    wide					552
    //    tall					440
    //    visible					0
    //    controlSettingsFile		"resource/ui/menus/panels/community_openinvites.res"
    //}

    //InviteNetworkButton
    //{
    //    ControlName				RuiButton
    //    wide					320
    //    tall					80
    //    ypos                    16
    //    zpos                    3
    //    rui                     "ui/prototype_generic_button.rpak"
    //    labelText               ""
    //    visible					1
	//
    //    proportionalToParent    1
	//
    //    pin_to_sibling			InviteFriendsButton0
    //    pin_corner_to_sibling	TOP
    //    pin_to_sibling_corner	BOTTOM
    //}

    UserInfo
    {
        ControlName				CNestedPanel

        xpos                    0
        ypos                    0
        tall					500

        zpos					5
        wide					%28
        visible					0
        controlSettingsFile		"resource/ui/menus/panels/user_info.res"
        pin_to_sibling          PanelFrame
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
    }

    MatchDetails
    {
        ControlName				CNestedPanel
        xpos					650
        ypos					180
        wide					780
        tall					470
        visible					0
        controlSettingsFile		"resource/ui/menus/panels/match_info.res"
    }
}