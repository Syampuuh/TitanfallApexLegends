"resource/ui/menus/panels/panel_club_details_participation.res"
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

    ClubDetailsDisplay
    {
        ControlName             RuiPanel
        rui                     "ui/club_details.rpak"

        visible                 1

        wide                    875
        wide_nx_handheld        919			[$NX || $NX_UI_PC]
        tall                    248
        tall_nx_handheld        352			[$NX || $NX_UI_PC]

        xpos                    32
        ypos                    -32
        zpos                    0

        proportionalToParent    1
        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT
    }

    ViewAnnouncementButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        wide					275
        tall					35
        xpos                    -20
        rui                     "ui/club_read_announcement_button.rpak"
        labelText               ""
        visible					0
        cursorVelocityModifier  0.7

        navLeft                 ManageUsersButton
        //navDown                   ModeButton

        proportionalToParent    1

        pin_to_sibling			ClubDetailsDisplay
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM

        sound_focus             "UI_Menu_Focus_Large"
        sound_accept            "UI_Menu_GameMode_Select"
    }

    ClubLogoDisplay
    {
        ControlName             RuiPanel
        rui                     "ui/club_logo_anchor.rpak"

        ruiArgs
        {
            labelString         ""
        }

        visible                 1

        wide                    290
        wide_nx_handheld        350		[$NX || $NX_UI_PC]
        tall                    290
        tall_nx_handheld        350		[$NX || $NX_UI_PC]

        xpos                    32
        xpos_nx_handheld        325		[$NX || $NX_UI_PC]
        ypos                    48
        ypos_nx_handheld        28		[$NX || $NX_UI_PC]
        zpos                    5

        proportionalToParent    1
        pin_to_sibling          ClubDetailsDisplay
        pin_corner_to_sibling   TOP_RIGHT
        pin_to_sibling_corner   TOP_RIGHT
    }

    ToolTip
    {
        ControlName				RuiPanel
        InheritProperties       ToolTip
        zpos                    999
    }
}