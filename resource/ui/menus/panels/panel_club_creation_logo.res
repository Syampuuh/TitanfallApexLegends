"resource/ui/menus/panels/panel_club_creation_logo.res"
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

    ClubLogoDisplay
    {
        ControlName             RuiPanel
        rui                     "ui/club_logo_anchor.rpak"

        visible                 1

        wide                    512
        tall                    512

        xpos                    0
        ypos                    -32
        zpos                    0

        proportionalToParent    1
        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   TOP
        pin_to_sibling_corner   TOP
    }

    LogoEditorButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        ypos                    64
        xpos_nx_handheld        50		[$NX || $NX_UI_PC]
        wide					192
        wide_nx_handheld		285		[$NX || $NX_UI_PC]
        tall					48
        rui                     "ui/generic_button.rpak"
        labelText               "Logo Editor"
        visible					1
        cursorVelocityModifier  0.7

        navRight                RandomizeLogoButton

        tabPostion              0

        proportionalToParent    1

        pin_to_sibling          ClubLogoDisplay
        pin_corner_to_sibling   BOTTOM_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT

        sound_focus             "UI_Menu_Focus_Large"
    }

    RandomizeLogoButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        ypos                    64
        xpos_nx_handheld        50		[$NX]
        wide					192
        wide_nx_handheld		285		[$NX]
        tall					48
        rui                     "ui/generic_button.rpak"
        labelText               "Random Logo"
        visible					1
        cursorVelocityModifier  0.7

		navLeft                 LogoEditorButton

        proportionalToParent    1

        pin_to_sibling          ClubLogoDisplay
        pin_corner_to_sibling   BOTTOM_RIGHT
        pin_to_sibling_corner   BOTTOM_RIGHT

        sound_focus             "UI_Menu_Focus_Large"
    }
}