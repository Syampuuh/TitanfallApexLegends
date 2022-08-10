"resource/ui/menus/panels/panel_club_details.res"
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
        wide_nx_handheld        919			[$NX]
        tall                    248
        tall_nx_handheld        352			[$NX]

        xpos                    0
        xpos_nx_handheld        35			[$NX]
        ypos                    0
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
        wide_nx_handheld		480			[$NX]
        tall					35
        tall_nx_handheld		47			[$NX]
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

        sound_focus             "UI_Menu_Focus"
        sound_accept            "UI_Menu_Accept"
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

        wide                    270
        wide_nx_handheld        220		[$NX]
        tall                    270
        tall_nx_handheld        220		[$NX]

        xpos                    -8
        xpos_nx_handheld        -60		[$NX]
        ypos                    0
        ypos_nx_handheld        80		[$NX]
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