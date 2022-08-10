"resource/ui/menus/panels/panel_club_admin_controls.res"
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
		visible				    1
        bgcolor_override        "0 0 0 64"
        paintbackground         0

        proportionalToParent    1
    }

    EditClubButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        wide					277
        wide_nx_handheld		240		[$NX || $NX_UI_PC]
        tall					48
        xpos                    0
        ypos                    0

        rui                     "ui/generic_button.rpak"
        labelText               ""
        visible					0
        cursorVelocityModifier  0.7

        //navDown                   ModeButton
        navRight                ManageUsersButton

        proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT

        sound_focus             "UI_Menu_Focus_Large"
    }

    ManageUsersButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        wide					277
        wide_nx_handheld		330		[$NX || $NX_UI_PC]
        tall					48
        xpos                    22
        xpos_nx_handheld        12		[$NX || $NX_UI_PC]
        rui                     "ui/generic_button.rpak"
        labelText               ""
        visible					0
        cursorVelocityModifier  0.7

		navLeft                 EditClubButton
		navUp                   ViewAnnouncementButton
		navRight                SubmitAnnouncementButton
        //navDown                   ModeButton

        proportionalToParent    1

        pin_to_sibling			EditClubButton
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_RIGHT

        sound_focus             "UI_Menu_Focus_Large"
    }

    SubmitAnnouncementButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        wide					277
        wide_nx_handheld		340		[$NX || $NX_UI_PC]
        tall					48
        xpos                    22
        xpos_nx_handheld        12		[$NX || $NX_UI_PC]
        rui                     "ui/generic_button.rpak"
        labelText               ""
        visible					0
        cursorVelocityModifier  0.7

        navLeft                 ManageUsersButton
        navUp                   ViewAnnouncementButton
        //navDown                   ModeButton

        proportionalToParent    1

        pin_to_sibling			ManageUsersButton
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_RIGHT

        sound_focus             "UI_Menu_Focus_Large"
    }
}