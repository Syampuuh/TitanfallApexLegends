"resource/ui/menus/panels/private_match_team_roster.res"
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

	ToolTip
    {
        ControlName				RuiPanel
        InheritProperties       ToolTip
        zpos                    999
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    TeamHeader
    {
        ControlName             RuiButton

        xpos                    0
        ypos                    0
        zpos                    1

        wide                    272
        tall                    48
        rui                     "ui/private_match_team_roster_header.rpak"
        rightClickEvents        1
        doubleClickEvents       1

        ruiArgs
        {
            teamNumber          0
            showTeamNumber      1
            teamName            "Spectator"
        }

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT

        visible                 1
    }

    TeamPlayerRoster
    {
        ControlName             GridButtonListPanel

        xpos                    -8
        ypos                    0

        pin_to_sibling          TeamHeader
        pin_corner_to_sibling   TOP
        pin_to_sibling_corner   BOTTOM

        columns                 1
        rows                    5
        buttonSpacing           2
        scrollbarSpacing        1
        scrollbarOnLeft         1
        selectOnDpadNav         1

        ButtonSettings
        {
            rui                     "ui/private_match_team_roster_player.rpak"
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