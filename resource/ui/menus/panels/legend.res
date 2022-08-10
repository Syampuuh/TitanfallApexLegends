resource/ui/menus/panels/legend.res
{
    ToolTip
    {
        ControlName				RuiPanel
        InheritProperties       ToolTip
    }

    ScreenFrame
    {
        ControlName				ImagePanel
        xpos					0
        ypos					0
        wide					%100
        tall					%100
        visible					1
        enabled 				1
        scaleImage				1
        image					"vgui/HUD/white"
        drawColor				"0 0 0 150"
    }
	PanelFrame
    {
        ControlName				Label
        xpos					0
        ypos					0
        wide					1920
        tall					%100
        labelText				""
        visible				    1

        pin_to_sibling          ScreenFrame
        pin_corner_to_sibling   CENTER
        pin_to_sibling_corner   CENTER
    }
    CharacterSelectInfo
    {
        ControlName		        RuiPanel
        xpos                    -75
        ypos                    -220
        wide                    740
        tall                    153
        visible			        1
        rui                     "ui/character_select_info.rpak"

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

    GCard
    {
        ControlName             RuiPanel
        xpos					50
        ypos					0
        wide 					502
        wide_nx_handheld		0			[$NX || $NX_UI_PC]
        tall					866
        tall_nx_handheld		0			[$NX || $NX_UI_PC]
        rui 					"ui/gladiator_card_squadscreen.rpak"
        visible					1
        zpos					5

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }

    Ultimate
    {
        ControlName             RuiPanel
        xpos					0
        xpos_nx_handheld		175			[$NX || $NX_UI_PC]
        ypos					60
        wide 					400
        tall					320
        rui 					"ui/character_skill_display.rpak"
        visible					1
        zpos					5

        scriptID                "ultimate"

        pin_to_sibling			GCard
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	LEFT
    }

    Tactical
    {
        ControlName             RuiPanel
        xpos					75
        xpos_nx_handheld		235		[$NX || $NX_UI_PC]
        ypos					0
        wide 					400
        tall					320
        rui 					"ui/character_skill_display.rpak"
        visible					1
        zpos					5

        scriptID                "tactical"

        pin_to_sibling			Ultimate
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	LEFT
    }

    Passive
    {
        ControlName             RuiPanel
        xpos					75
        xpos_nx_handheld		235		[$NX || $NX_UI_PC]
        ypos					0
        wide 					400
        tall					320
        rui 					"ui/character_skill_display.rpak"
        visible					1
        zpos					5

        scriptID                "passive"

        pin_to_sibling			Tactical
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	LEFT
    }

    SpecialPerk
    {
        ControlName             RuiPanel
        xpos					0
        ypos					0
        ypos_nx_handheld		50		[$NX || $NX_UI_PC]
        wide 					400
        tall					320
        rui 					"ui/character_special_perk.rpak"
        visible					1
        zpos					5

        scriptID                "specialPerk"

        pin_to_sibling			Tactical
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	BOTTOM
    }
}
