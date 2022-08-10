"resource/ui/menus/panels/play.res"
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
		wide					%100
		tall					%100
		labelText				""
		visible				    0
        bgcolor_override        "0 0 0 64"
        paintbackground         1

        proportionalToParent    1
    }

    StoryEventButton0
    {
        ControlName				RuiButton
        InheritProperties       StoryButton
        visible					0
        xpos                    -375
        ypos                    350
        zpos                    3

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	CENTER
        pin_to_sibling_corner	CENTER
    }

	ChatRoomTextChat
	{
		ControlName				CBaseHudChat
		xpos					32
		ypos_nx_handheld		13		[$NX || $NX_UI_PC]
		wide					992
		wide_nx_handheld		900		[$NX || $NX_UI_PC]
		tall					230
		tall_nx_handheld		275		[$NX || $NX_UI_PC]
		visible 				1
		enabled					1

		destination				"chatroom"
		interactive				1
		chatBorderThickness		1
		messageModeAlwaysOn		1
        setUnusedScrollbarInvisible 1
		hideInputBox			1 [$GAMECONSOLE]
		font 					Default_27
		zpos                    2

		bgcolor_override 		"0 0 0 0"
		chatHistoryBgColor		"24 27 30 10"
		chatEntryBgColor		"24 27 30 100"
		chatEntryBgColorFocused	"24 27 30 120"

        pin_to_sibling			ReadyButton
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_RIGHT
	}

    AccessibilityHint
    {
        ControlName             RuiPanel
        classname               "MenuButton"
        wide                    300
        tall                    40
		ypos_nx_handheld		60		[$NX || $NX_UI_PC]
        visible                 1

        rui                     "ui/accessibility_hint.rpak"

        ruiArgs
        {
            buttonText          "#MENU_ACCESSIBILITY_CHAT_HINT" [!$PC]
            buttonText          "#MENU_ACCESSIBILITY_CHAT_HINT_PC" [$PC] // controller chat option only on console
            buttonTextPC        "#MENU_ACCESSIBILITY_CHAT_HINT_PC"
        }

        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling			ChatRoomTextChat
        pin_to_sibling_corner	TOP_LEFT
    }

    ModeButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        wide					367
        wide_nx_handheld		422		[$NX || $NX_UI_PC]
        tall					76
        tall_nx_handheld		87		[$NX || $NX_UI_PC]
        ypos                    16
        zpos                    10
        rui                     "ui/generic_dropdown_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7
        sound_accept            "UI_Menu_SelectMode_Extend"

        navUp                   InviteFriendsButton0
        navDown                 ReadyButton
        navRight                InviteFriendsButton0

        proportionalToParent    1

        pin_to_sibling			ReadyButton
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

    GamemodeSelectButton
    {
        ControlName				RuiButton
        classname               "MenuButton MatchmakingStatusRui"
        wide					367
        wide_nx_handheld		422  	 [$NX || $NX_UI_PC]
        tall					188
        tall_nx_handheld		216  	 [$NX || $NX_UI_PC]
        ypos                    13
        zpos                    10
        rui                     "ui/gamemode_select_lobby_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7
        sound_accept            "UI_Menu_SelectMode_Extend"

        navUp                   InviteFriendsButton0
        navDown                 ReadyButton
        navRight                InviteFriendsButton0

        proportionalToParent    1

        pin_to_sibling			ReadyButton
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

    FillButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        wide					367
        wide_nx_handheld		422		[$NX || $NX_UI_PC]
        tall					38
        tall_nx_handheld		44		[$NX || $NX_UI_PC]
        ypos                    16
        rui                     "ui/gamemode_nofill_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7

        navUp                   InviteFriendsButton0
        navRight                InviteFriendsButton0
        navDown                 AboutButton

        proportionalToParent    1

        pin_to_sibling			AboutButton
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

    RankedBadge
    {
        ControlName				RuiButton
        wide					367
        wide_nx_handheld		422  	 [$NX || $NX_UI_PC]
        tall					139
        tall_nx_handheld		160  	 [$NX || $NX_UI_PC]
        ypos                    0
        xpos                    0
        rui                     "ui/ranked_badge_lobby.rpak"
        labelText               ""
        visible					0

        navUp                   InviteFriendsButton0

        proportionalToParent    1

        pin_to_sibling			ModeButton
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

                       
    ArenasRankedBadge
    {
        ControlName				RuiButton
        wide					367
        wide_nx_handheld		422  	 [$NX || $NX_UI_PC]
        tall					139
        tall_nx_handheld		160  	 [$NX || $NX_UI_PC]
        ypos                    0
        xpos                    0
        rui                     "ui/arenas_ranked_badge_lobby.rpak"
        labelText               ""
        visible					0

        navUp                   InviteFriendsButton0

        proportionalToParent    1

        pin_to_sibling			ModeButton
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
      

    AboutButton
    {
        ControlName				RuiButton
        wide					280
        wide_nx_handheld		325		[$NX || $NX_UI_PC]
        tall					96
        tall_nx_handheld		111		[$NX || $NX_UI_PC]
        ypos                    5
        xpos                    0
        zpos                    20
        rui                     "ui/about_ltm_button.rpak"

        labelText               ""
        visible					1
        cursorVelocityModifier  0.7

        proportionalToParent    1

        pin_to_sibling			ModeButton
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

    PlaylistNotificationMessage
    {
        ControlName				RuiPanel

        wide					288
        tall					40

        ypos                    0
        xpos                    0
        zpos					3

        rui						"ui/menu_button_small.rpak"
        labelText               ""
        visible					0

        ruiArgs
        {
            buttonText "#APEX_ELITE_AVAILABLE"
            isSelected 1
        }

        enabled					1
        visible					1
        auto_wide_tocontents 	1
        behave_as_label         1
        ruiDefaultHeight        36
        fontHeight              32

        proportionalToParent    1

        pin_to_sibling			ModeButton
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

    ReadyButton
    {
        ControlName				RuiButton
        classname               "MenuButton MatchmakingStatusRui"
        wide					367
        wide_nx_handheld		422		[$NX || $NX_UI_PC]
        tall					112
        tall_nx_handheld		129		[$NX || $NX_UI_PC]
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

    FriendsAnchor
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

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	CENTER
        pin_to_sibling_corner	CENTER
    }

    ShiftedAnchor
    {
		ControlName				Label
		xpos					-312
		ypos					25
		wide					%100
		tall					%100
		labelText				""
		visible				    0
        bgcolor_override        "0 0 0 64"
        paintbackground         1

        proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	CENTER
        pin_to_sibling_corner	CENTER
    }

	LobbyDebugText
	{
	   ControlName				Label
	   auto_wide_tocontents		1
	   tall						27
	   visible					1
	   labelText				""
	   font						DefaultBold_40
	   allcaps					0
	   fgcolor_override			"255 0 255 255"
	   bgcolor_override			"70 70 70 255"
       paintbackground			1

       ypos						-2
       xpos						-135
       zpos						30

       pin_to_sibling			PanelFrame
       pin_corner_to_sibling	TOP_LEFT
       pin_to_sibling_corner	TOP
	}

    InviteFriendsButton0
    {
        ControlName				RuiButton
        InheritProperties       InviteButton
        xpos                    -374
        ypos                    -90

        navUp                   FriendButton0
        navRight                FriendButton0
        navLeft                 InviteLastPlayedUnitframe0

        pin_to_sibling			FriendsAnchor
        pin_corner_to_sibling	CENTER
        pin_to_sibling_corner	CENTER
    }

    InviteFriendsButton1
    {
        ControlName				RuiButton
        InheritProperties       InviteButton
        xpos                    374
        ypos                    -90

        navLeft                 FriendButton1
        navRight                MiniPromo

        pin_to_sibling			FriendsAnchor
        pin_corner_to_sibling	CENTER
        pin_to_sibling_corner	CENTER
    }

    InviteLastSquadHeader
	{
		ControlName				RuiPanel
		xpos_nx_handheld		-30			[$NX || $NX_UI_PC]
		ypos					-155
		ypos_nx_handheld		-305		[$NX || $NX_UI_PC]
		wide					245
		tall					24
		visible					1
        rui					    "ui/invite_last_squad_header.rpak"

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	LEFT
	}

    InviteLastPlayedUnitframe0
    {
        ControlName             RuiButton

        pin_to_sibling			InviteLastSquadHeader
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        rightClickEvents		1
        middleClickEvents       1

        ypos                    14
        xpos_nx_handheld        35		[$NX || $NX_UI_PC]

        navRight                InviteFriendsButton0
        navDown                 InviteLastPlayedUnitframe1

        scriptID                0

        wide                    245
        wide_nx_handheld        280		[$NX || $NX_UI_PC]
        tall                    47
        tall_nx_handheld        53		[$NX || $NX_UI_PC]

        rui					    "ui/unitframe_lobby_invite_last_squad.rpak"
    }

    InviteLastPlayedUnitframe1
    {
        ControlName             RuiButton

        pin_to_sibling			InviteLastPlayedUnitframe0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        rightClickEvents		1
        middleClickEvents       1

        ypos                    20
        ypos_nx_handheld        45		[$NX || $NX_UI_PC]

        navUp                   InviteLastPlayedUnitframe0
        navRight                InviteFriendsButton0
        navDown                 FillButton

        scriptID                1

        wide                    245
        wide_nx_handheld        280		[$NX || $NX_UI_PC]
        tall                    47
        tall_nx_handheld        53		[$NX || $NX_UI_PC]

        rui					    "ui/unitframe_lobby_invite_last_squad.rpak"
    }

    SelfButton
    {
        ControlName				RuiButton
        wide					340
        tall					88
        xpos                    0
        ypos                    -30
        ypos_nx_handheld        -18    [$NX || $NX_UI_PC]
        rui                     "ui/lobby_friend_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7
        scriptID                -1
        rightClickEvents		0
        tabPosition             1

        navDown                 FriendButton0
        navLeft                 FriendButton0
        navRight                FriendButton1

        proportionalToParent    1

        pin_to_sibling			FriendsAnchor
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
    }


    FriendButton0
    {
        ControlName				RuiButton
        wide					340
        tall					88
        xpos                    -376
        xpos_nx_handheld        -350	[$NX || $NX_UI_PC]
        ypos                    -74
        ypos_nx_handheld        -40		[$NX || $NX_UI_PC]
        rui                     "ui/lobby_friend_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7
        scriptID                0
        rightClickEvents		1

        navLeft                 InviteFriendsButton0
        navRight                SelfButton

        proportionalToParent    1

        pin_to_sibling			FriendsAnchor
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
    }

    FriendButton1
    {
        ControlName				RuiButton
        wide					340
        tall					88
        xpos                    376
        xpos_nx_handheld        350		[$NX || $NX_UI_PC]
        ypos                    -74
        ypos_nx_handheld        -40		[$NX || $NX_UI_PC]
        rui                     "ui/lobby_friend_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7
        scriptID                1
        rightClickEvents		1

        navLeft                 SelfButton
        navRight                InviteFriendsButton1

        proportionalToParent    1

        pin_to_sibling			FriendsAnchor
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
    }

	HDTextureProgress
	{
		ControlName				RuiPanel
		xpos					160
		ypos					46
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

    TopRightContentAnchor
    {
        ControlName				Label
        wide					353
        wide_nx_handheld		420		[$NX || $NX_UI_PC]
        tall					26
        tall_nx_handheld		20		[$NX || $NX_UI_PC]
        labelText               ""

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	TOP_RIGHT
    }

	ChallengesBounds // Used for cursor hit testing.
	{
		ControlName				Label
		wide					415
		tall					475
		xpos					10
		ypos					0
		zpos					-1
		visible					1
		clipToParent			0

		labelText				""

		pin_to_sibling			TopRightContentAnchor
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	ChallengesBox
    {
        ControlName				RuiButton
        wide					353
        wide_nx_handheld		380		[$NX || $NX_UI_PC]
        tall					136
        tall_nx_handheld		156		[$NX || $NX_UI_PC]
        visible					0
        rui					    "ui/lobby_challenge_box.rpak"
        zpos                    15
        sound_focus             ""
        sound_accept            ""

        pin_to_sibling			TopRightContentAnchor
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
    ChallengesTags
    {
        ControlName				RuiPanel
        xpos					0
        ypos					0
        zpos					10
        wide					353
	    wide_nx_handheld		380		[$NX || $NX_UI_PC]
	    tall					30
	    tall_nx_handheld		30		[$NX || $NX_UI_PC]
        visible					0
        rui 					"ui/lobby_challenge_box_tags.rpak"

        pin_to_sibling			ChallengesBox
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
	ChallengesBlur
    {
        ControlName				RuiPanel
        xpos					0
        ypos					0
        zpos					10
        wide					409
        tall					282
        tall_nx_handheld		355			[$NX || $NX_UI_PC]
        visible					0
        rui 					"ui/lobby_challenges_box_blur.rpak"

        pin_to_sibling			ChallengesBox
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

	ChallengesNextBPReward
	{
		ControlName				RuiButton
		wide					70
		tall					70
		xpos                    -35
		ypos                    0
		zpos                    20
		visible					1
        rui					    "ui/battle_pass_reward_button_v2.rpak"
		cursorPriority          1

        pin_to_sibling			ChallengesBox
        pin_corner_to_sibling	CENTER
        pin_to_sibling_corner	RIGHT
	}
	//story challenges
	StoryChallengeButton0
    {
        ControlName RuiButton

        pin_to_sibling			ChallengesBlur
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT

        xpos                    -23
        ypos                    -16
        zpos                    13
        wide					330
        wide_nx_handheld		380		[$NX || $NX_UI_PC]
        tall					125
        tall_nx_handheld		125		[$NX || $NX_UI_PC]
        visible                 0
        rui                     "ui/lobby_story_challenge_box_row.rpak"

        navDown                 StoryPrizeTrackButton

        //wide_nx_handheld		462  [$NX || $NX_UI_PC]
        //tall_nx_handheld		100  [$NX || $NX_UI_PC]

        sound_focus             ""
        sound_accept            ""
    }

	//buffet/weeklydaily/fav challenges
    ChallengeButton0
    {
        ControlName RuiButton

        pin_to_sibling			ChallengesTags
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
		zpos                    13
        wide					353
        wide_nx_handheld		380		[$NX || $NX_UI_PC]
        tall					50
        tall_nx_handheld		65		[$NX || $NX_UI_PC]
        visible                 0
        rui                     "ui/lobby_challenge_box_row.rpak"

        //wide_nx_handheld		462  [$NX || $NX_UI_PC]
        //tall_nx_handheld		100  [$NX || $NX_UI_PC]

        sound_focus             ""
        sound_accept            ""
    }

    ChallengeButton1
    {
        ControlName RuiButton

        pin_to_sibling          ChallengeButton0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
		zpos                    13
        wide					353
        wide_nx_handheld		380		[$NX || $NX_UI_PC]
        tall					50
        tall_nx_handheld		65		[$NX || $NX_UI_PC]
		cursorVelocityModifier  0.6

        visible                 0
        rui                     "ui/lobby_challenge_box_row.rpak"

        navDown                 ChallengeButton2

        //wide_nx_handheld		462   [$NX]
        //tall_nx_handheld		100   [$NX]

        sound_focus             ""
        sound_accept            ""
    }

    ChallengeButton2
    {
        ControlName RuiButton

        pin_to_sibling          ChallengeButton1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
		zpos                    13
        wide					353
        wide_nx_handheld		380		[$NX || $NX_UI_PC]
        tall					50
        tall_nx_handheld		65		[$NX || $NX_UI_PC]
		cursorVelocityModifier  0.6

        visible                 0
        rui                     "ui/lobby_challenge_box_row.rpak"

        navUp                   ChallengeButton1
        navDown                 ChallengeButton3

        //wide_nx_handheld		462   [$NX]
        //tall_nx_handheld		100   [$NX]

        sound_focus             ""
        sound_accept            ""
    }

    ChallengeButton3
    {
        ControlName RuiButton

        pin_to_sibling          ChallengeButton2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
		zpos                    13
        wide					353
        wide_nx_handheld		380		[$NX || $NX_UI_PC]
        tall					50
        tall_nx_handheld		65		[$NX || $NX_UI_PC]
		cursorVelocityModifier  0.6

        visible                 0
        rui                     "ui/lobby_challenge_box_row.rpak"

        navUp                   ChallengeButton2
        navDown                 ChallengeButton4

        //wide_nx_handheld		462   [$NX]
        //tall_nx_handheld		100   [$NX]

        sound_focus             ""
        sound_accept            ""
    }

    ChallengeButton4
    {
        ControlName RuiButton

        pin_to_sibling          ChallengeButton3
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
		zpos                    13
        wide					353
        wide_nx_handheld		380		[$NX || $NX_UI_PC]
        tall					50
        tall_nx_handheld		65		[$NX || $NX_UI_PC]
		cursorVelocityModifier  0.6

        visible                 0
        rui                     "ui/lobby_challenge_box_row.rpak"

        navUp                   ChallengeButton3
        navDown                 ChallengeCatergoryLeftButton

        //wide_nx_handheld		462   [$NX]
        //tall_nx_handheld		100   [$NX]

        sound_focus             ""
        sound_accept            ""
    }

    ChallengeCatergoryLeftButton
    {
        ControlName             RuiButton
		xpos                    8
		xpos_nx_handheld        10		[$NX || $NX_UI_PC]
		wide					54
        wide_nx_handheld		80		[$NX || $NX_UI_PC]
		tall					54
        tall_nx_handheld		70		[$NX || $NX_UI_PC]
        visible			        1

        rui					    "ui/challenge_category_arrow_button.rpak"
		ruiArgs
		{
			isRightOption       0
		}

        cursorVelocityModifier  0.5
        cursorPriority          1
		pin_to_sibling			ChallengeButton4
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT

        navUp                   ChallengeButton4
        navRight                ChallengeCatergoryRightButton
        navDown                 MiniPromo
    }

	ChallengeCatergorySelection
	{
		ControlName				RuiButton
		wide					213
        wide_nx_handheld		247		[$NX || $NX_UI_PC]
		tall					54
        tall_nx_handheld		70		[$NX || $NX_UI_PC]
		visible					1
		rui					    "ui/challenge_category_selection.rpak"
        sound_accept            ""

        cursorVelocityModifier  0.7
		pin_to_sibling			ChallengeCatergoryLeftButton
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

    ChallengeCatergoryRightButton
    {
        ControlName             RuiButton
		wide					54
        wide_nx_handheld		80		[$NX || $NX_UI_PC]
		tall					54
        tall_nx_handheld		70		[$NX || $NX_UI_PC]
        visible			        1

        rui					    "ui/challenge_category_arrow_button.rpak"
		ruiArgs
		{
			isRightOption       1
		}

        cursorVelocityModifier  0.5
        cursorPriority          1
		pin_to_sibling			ChallengeCatergorySelection
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT

        navUp                   ChallengeButton4
        navLeft                 ChallengeCatergoryLeftButton
        navRight                AllChallengesButton
        navDown                 EventPrizeTrackButton
    }

    AllChallengesButton
    {
        ControlName			    RuiButton
        zpos			        14
        wide			        90
        wide_nx_handheld		125		[$NX || $NX_UI_PC]
        tall			        54
        tall_nx_handheld		70		[$NX || $NX_UI_PC]
        visible			        0
        labelText               ""
        rui					    "ui/lobby_all_challenges_button.rpak"
        proportionalToParent    1
        cursorVelocityModifier  0.5
        cursorPriority          1
        pin_to_sibling			ChallengeCatergoryRightButton
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT

        navUp                   ChallengeButton4
        navLeft                 ChallengeCatergoryRightButton
        navDown                 EventPrizeTrackButton

        sound_focus             "UI_Menu_Focus_Small"
    }

	StoryPrizeTrackButton
    {
        ControlName			    RuiButton
        zpos			        14
        wide			        330
        wide_nx_handheld		415		[$NX || $NX_UI_PC]
        tall			        65
        xpos                    -30
        xpos_nx_handheld		-15		[$NX || $NX_UI_PC]
        ypos                    13
        ypos_nx_handheld		6		[$NX || $NX_UI_PC]
        visible			        0
        labelText               ""
        rui					    "ui/generic_icon_button.rpak"
        ruiArgs
        {
            buttonText          "#CHALLENGES_STORY_TRACKER"
        }
        cursorPriority          1
        proportionalToParent    1
        sound_focus             "UI_Menu_Focus_Small"
        sound_accept            "UI_Menu_StoryEventTab_Select"
        cursorVelocityModifier  0.7
        pin_to_sibling			ChallengeCatergoryLeftButton
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	TOP_LEFT

        navUp                   StoryChallengeButton0
        navDown                 ChallengeCatergoryLeftButton
    }

    EventPrizeTrackButton
    {
        ControlName			    RuiButton
        zpos			        14
        wide			        361
        wide_nx_handheld		435		[$NX || $NX_UI_PC]
        tall			        42
        tall_nx_handheld		50		[$NX || $NX_UI_PC]
		ypos                    3
        visible			        0
        labelText               ""
        rui					    "ui/lobby_buffet_event_prize_track_button.rpak"
		ruiArgs
        {
			buttonText          "#CHELLENGES_PRIZE_TRACKER"
        }
        cursorPriority          1
        proportionalToParent    1
        sound_focus             "UI_Menu_Focus_Small"
        cursorVelocityModifier  0.7
        pin_to_sibling			ChallengeCatergoryLeftButton
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT

        navUp                   ChallengeCatergoryRightButton
        navDown                 MiniPromo
    }

    MiniPromo
    {
        ControlName				RuiButton
        wide                    308
        wide_nx_handheld        375  	 	[$NX || $NX_UI_PC]
        tall                    106
        tall_nx_handheld        134   		[$NX || $NX_UI_PC]

		xpos                    -53
        xpos_nx_handheld        8   		[$NX || $NX_UI_PC]
        ypos_nx_handheld        635   		[$NX || $NX_UI_PC]

        rui                     "ui/mini_promo.rpak"
        visible					0
        cursorVelocityModifier  0.7

        proportionalToParent    1

        navUp                   EventPrizeTrackButton
        navLeft                 InviteFriendsButton1
        pin_to_sibling          TopRightContentAnchor
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT

        sound_focus             "UI_Menu_Focus_Large"
        sound_accept            ""
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    PopupMessage
    {
        ControlName				RuiButton
        wide        			650
        wide_nx_handheld       	813		[$NX || $NX_UI_PC]
        tall        			170
        tall_nx_handheld       	213		[$NX || $NX_UI_PC]
        ypos        			-38
        rui         			"ui/bp_popup_widget.rpak"

        visible     			0
        enabled     			1
        zpos        			100

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP
    }

	StoryEventsMessage
    {
		ControlName				RuiPanel
		xpos					590
		ypos					280
        ypos_nx_handheld       	130		[$NX || $NX_UI_PC]
		wide					%100
		tall					%100
		visible				    0
		rui					    "ui/ingame_dialogue_popup.rpak"

		ruiArgs
        {
        }

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	CENTER
        pin_to_sibling_corner	CENTER
    }
}
