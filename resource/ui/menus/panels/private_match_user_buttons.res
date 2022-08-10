"resource/ui/menus/panels/private_match_user_buttons.res"
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
    ReadyButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        wide					288
        tall					112
        rui                     "ui/generic_desc_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7

        navDown                   ModeButton

        proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT

        sound_focus             "UI_Menu_Focus_Large"
    }

    ModeButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        ypos                    16
        wide					288
        tall					60
        rui                     "ui/generic_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7

        navUp                   ReadyButton

        proportionalToParent    1

        pin_to_sibling			ReadyButton
        pin_corner_to_sibling	BOTTOM
        pin_to_sibling_corner	TOP

        sound_focus             "UI_Menu_Focus_Large"
    }

    PrivateMatchPostGameButton
    {
        ControlName				RuiButton
        InheritProperties		CornerButton
        zpos                    5

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
    }

    PrivateMatchTeamSwapToggleButton
    {
        ControlName				RuiButton
        InheritProperties		CornerButton
        xpos                    16
        zpos                    5

        pin_to_sibling			PrivateMatchPostGameButton
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    PrivateMatchTeamRenameToggleButton
    {
        ControlName				RuiButton
        InheritProperties		CornerButton
        xpos                    16
        zpos                    5

        pin_to_sibling			PrivateMatchTeamSwapToggleButton
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    PrivateMatchAdminOnlyChatToggleButton
    {
        ControlName				RuiButton
        InheritProperties		CornerButton
        xpos                    16
        zpos                    5

        pin_to_sibling			PrivateMatchTeamRenameToggleButton
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    PrivateMatchAimAssistToggleButton
    {
        ControlName             RuiButton
        InheritProperties       CornerButton
        xpos                    16
        zpos                    5

        pin_to_sibling          PrivateMatchAdminOnlyChatToggleButton
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    PrivateMatchAnonymousModeToggleButton
    {
        ControlName             RuiButton
        InheritProperties       CornerButton
        xpos                    16
        zpos                    5

        pin_to_sibling          PrivateMatchAimAssistToggleButton
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
}