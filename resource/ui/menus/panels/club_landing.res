"resource/ui/menus/panels/club_landing.res"
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

    ClubDiscoveryPanel
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/panel_club_discovery.res"

        xpos                        0
        ypos                        0

        wide                        1920
        tall                        %100
        proportionalToParent        1

        pin_to_sibling              PanelFrame
        pin_corner_to_sibling       CENTER
        pin_to_sibling_corner       CENTER

        visible                     0
    }

    ClubLobbyPanel
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/panel_club_lobby.res"

        xpos                        0
        ypos                        0

        wide                        1920
        tall                        %100
        proportionalToParent        1

        pin_to_sibling              PanelFrame
        pin_corner_to_sibling       CENTER
        pin_to_sibling_corner       CENTER

        visible                     1
    }

    ClubLobbySpinner
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/panel_club_loading.res"

        xpos                        0
        ypos                        0

        wide                        %100
        tall                        %100
        proportionalToParent        1

        pin_to_sibling              PanelFrame
        pin_corner_to_sibling       CENTER
        pin_to_sibling_corner       CENTER

        visible                     1
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    PopupMessage
    {
        ControlName				RuiButton
        wide        650
        tall        170
        ypos        -38
        rui         "ui/bp_popup_widget.rpak"

        visible     0
        enabled     1
        zpos        100

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP
    }
}