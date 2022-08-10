"resource/ui/menus/panels/custom_match_lobby_roster.res"
{
	PanelFrame
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
		bgcolor_override		"255 16 16 8"
		visible					0
		paintbackground			1
		proportionalToParent    1
	}

	RosterBg
	{
		ControlName				ImagePanel
		wide					%100
		tall					352
		visible					1
		proportionalToParent    1
        scaleImage				1
        image					"vgui/HUD/white"
        drawColor				"0 0 0 191"

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   BOTTOM
        pin_to_sibling_corner   BOTTOM
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    LobbyRosterButton00
    {
        ControlName             RuiButton
        rui                     "ui/custom_match_roster_tab_button.rpak"

        wide                    %50
        tall                    48
		proportionalToParent    1

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT

		scriptId                0
    }

    LobbyRosterButton01
    {
        ControlName             RuiButton
        rui                     "ui/custom_match_roster_tab_button.rpak"

        wide                    %50
        tall                    48
		proportionalToParent    1

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   TOP_RIGHT
        pin_to_sibling_corner   TOP_RIGHT

		scriptId                1
    }

    LobbyRoster00
    {
        ControlName             GridButtonListPanel

        xpos                    0
        ypos                    -36

		scriptId                0

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   BOTTOM
        pin_to_sibling_corner   BOTTOM

        columns                 1
        rows                    6
        buttonSpacing           2
        scrollbarSpacing        1
        scrollbarOnLeft         0
        selectOnDpadNav         1

        ButtonSettings
        {
            rui                     "ui/custom_match_team_roster_player.rpak"
            clipRui                 1
            wide                    272
            tall                    48
            cursorVelocityModifier  0.7
            rightClickEvents        1
            doubleClickEvents       1
            middleClickEvents       1
            sound_focus             "UI_Menu_Focus_Small"
            sound_accept            ""
            sound_deny              ""
        }
    }

    LobbyRoster01
    {
        ControlName             GridButtonListPanel

        xpos                    0
        ypos                    -36

		scriptId                1

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   BOTTOM
        pin_to_sibling_corner   BOTTOM

        columns                 1
        rows                    6
        buttonSpacing           2
        scrollbarSpacing        1
        scrollbarOnLeft         0
        selectOnDpadNav         1

        ButtonSettings
        {
            rui                     "ui/custom_match_team_roster_player.rpak"
            clipRui                 1
            wide                    272
            tall                    48
            cursorVelocityModifier  0.7
            rightClickEvents        1
            doubleClickEvents       1
            middleClickEvents       1
            sound_focus             "UI_Menu_Focus_Small"
            sound_accept            ""
            sound_deny              ""
        }
    }
}