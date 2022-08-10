"resource/ui/menus/panels/panel_club_lobby_member_list.res"
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
        bgcolor_override        "30 32 47 192"
        paintbackground         0

        proportionalToParent    1
    }

    MemberListGrid
    {
        ControlName             GridButtonListPanel

        xpos                    0
        ypos                    -10

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT

        columns                  1
        rows                     9
        buttonSpacing            10
        scrollbarSpacing         2
        scrollbarOnLeft          0
        //tabPosition            1
        selectOnDpadNav          1

        ButtonSettings
        {
            rui                      "ui/club_member_button.rpak"
            clipRui                  1
            wide                     375
            tall                     60
            cursorVelocityModifier   0.7
            rightClickEvents         1
            //doubleClickEvents      1
            //middleClickEvents      1
            sound_focus              "UI_Menu_Focus_Small"
            sound_accept             "UI_Menu_InviteFriend_Send"
            sound_deny               ""
        }
    }
}