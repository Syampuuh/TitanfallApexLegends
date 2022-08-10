"resource/ui/menus/panels/panel_club_loading.res"
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
		zpos                    -1
		cursorPriority          -1
		wide					%100
		tall					%100
		labelText				""
		visible				    0
        bgcolor_override        "0 0 0 64"
        paintbackground         1

        proportionalToParent    1
    }

    ToolTip
    {
        ControlName				RuiPanel
        InheritProperties       ToolTip
        zpos                    999
    }

	Spinner
    {
        ControlName             RuiPanel
        rui                     "ui/club_tab_spinner.rpak"

        visible                 1

        wide                    128
        tall                    128

        xpos                    0
        ypos                    0
        zpos                    0

        proportionalToParent    1
        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   CENTER
        pin_to_sibling_corner   CENTER
    }
}