"resource/ui/menus/panels/panel_club_creation_search_tags.res"
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

    PanelTitle
    {
        ControlName             Label

        xpos                    -16
        xpos_nx_handheld        -160		[$NX || $NX_UI_PC]
        ypos                    0
        wide                    %100
        tall                    36
        tall_nx_handheld        67		[$NX || $NX_UI_PC]

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT

        labelText               "#CLUBTAG_LABEL_NAME"
		fontHeight_nx_handheld	45		[$NX || $NX_UI_PC]
    }

    SearchTagsGrid
    {
        ControlName             GridButtonListPanel

        xpos                    0
        xpos_nx_handheld        140		[$NX || $NX_UI_PC]
        ypos                    0
        ypos_nx_handheld        -12		[$NX|| $NX_UI_PC]

        pin_to_sibling          PanelTitle
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT

        columns                  1
        rows                     5
        buttonSpacing            2
        scrollbarSpacing         2
        scrollbarOnLeft          0
        tabPosition            1
        //selectOnDpadNav          1

        ButtonSettings
        {
            rui                      "ui/club_search_tag_button.rpak"
            clipRui                  1
            wide                     512
            tall                     48
            tall_nx_handheld         60		[$NX || $NX_UI_PC]
            cursorVelocityModifier   0.7
            //rightClickEvents         1
            //doubleClickEvents      1
            //middleClickEvents      1
            sound_focus              "UI_Menu_Focus_Small"
            sound_accept             ""
            sound_deny               ""
        }
    }
}