"resource/ui/menus/panels/panel_club_request_details.res"
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

    ScreenBlur
    {
        ControlName				RuiPanel
        xpos                    0
        ypos					0
        wide					%100
        tall					%100
        rui                     "ui/clubs_panel_blur.rpak"

        ruiArgs
        {
            showFrame           "1"
        }

        visible					1

        proportionalToParent    1

        //pin_to_sibling          PanelFrame
        //pin_corner_to_sibling   TOP_LEFT
        //pin_to_sibling_corner   TOP_LEFT
    }

    //UserNameHeader
    //{
    //    ControlName             RuiPanel
    //    xpos                    -32
    //    ypos                    -24
    //    zpos                    4
    //    wide                    550
    //    tall                    64
    //    rui                     "ui/club_user_mgmt_header.rpak"
	//
    //    pin_to_sibling			PanelFrame
    //    pin_corner_to_sibling	TOP_LEFT
    //    pin_to_sibling_corner	TOP_LEFT
    //}

    //AcceptButton
    //{
    //    ControlName				RuiButton
    //    classname               "MenuButton"
    //    wide					272
    //    tall					55
    //    xpos                    0
    //    ypos                    16
    //    rui                     "ui/generic_button.rpak"
    //    labelText               ""
    //    visible					1
    //    cursorVelocityModifier  0.7
	//
    //    navDown                 DenyButton
	//
    //    proportionalToParent    1
	//
    //    pin_to_sibling						DenyButton
    //    pin_corner_to_sibling				BOTTOM
    //    pin_to_sibling_corner				TOP
	//
    //    sound_focus             "UI_Menu_Focus_Large"
    //    sound_accept            "UI_Menu_OpenLootBox"
    //}

    //DenyButton
    //{
    //    ControlName				RuiButton
    //    classname               "MenuButton"
    //    wide					272
    //    tall					55
    //    xpos                    -32
    //    ypos                    -24
    //    rui                     "ui/generic_button.rpak"
    //    labelText               ""
    //    visible					1
    //    cursorVelocityModifier  0.7
	//
    //    navUp                   AcceptButton
	//
    //    proportionalToParent    1
	//
    //    pin_to_sibling						PanelFrame
    //    pin_corner_to_sibling				BOTTOM_LEFT
    //    pin_to_sibling_corner				BOTTOM_LEFT
	//
    //    sound_focus             "UI_Menu_Focus_Large"
    //    sound_accept            "UI_Menu_OpenLootBox"
    //}

    UserGladCard
    {
        ControlName			RuiPanel

        xpos                   0
        xpos_nx_handheld       -118   [$NX || $NX_UI_PC]
        ypos                   0
        ypos_nx_handheld       120    [$NX || $NX_UI_PC]
        zpos                    2

        wide					850//800
        wide_nx_handheld		895//845    [$NX || $NX_UI_PC]
        tall					850//800
        tall_nx_handheld		940//890    [$NX || $NX_UI_PC]
        rui                    "ui/combined_card.rpak"
        visible					1

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   CENTER
        pin_to_sibling_corner   CENTER
    }
}