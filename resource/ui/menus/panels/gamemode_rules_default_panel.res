resource/ui/menus/panels/gamemode_rules_default_panel.res
{
	Anchor
    {
        ControlName				Label
        xpos					0
        ypos					0
        wide               f0
        tall               f0
        labelText				""
        visible				    1
        bgcolor_override        "0 0 0 0"
        paintbackground         1
        proportionalToParent    1
    }
	Details1
    {
        ControlName				RuiPanel
        classname               "AboutGameModeDetails"
        wide				    420
        wide_nx_handheld        470			[$NX || $NX_UI_PC]
        ypos_nx_handheld        110			[$NX || $NX_UI_PC] 
        tall					450

        visible				    1
        pin_to_sibling			Anchor
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP
        rui                     "ui/about_game_details.rpak"
    }
    Details2
    {
        ControlName				RuiPanel
        classname               "AboutGameModeDetails"
        wide				    420
        wide_nx_handheld		470			[$NX || $NX_UI_PC]
        tall					450
        xpos                    10
        visible				    1
        rui                     "ui/about_game_details.rpak"

        pin_to_sibling			Details1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    Details3
    {
        ControlName				RuiPanel
        classname               "AboutGameModeDetails"
        wide				    420
        wide_nx_handheld		470			[$NX || $NX_UI_PC]
        tall					450
        xpos                    10
        visible				    1
        rui                     "ui/about_game_details.rpak"

        pin_to_sibling			Details2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    Details4
    {
        ControlName				RuiPanel
        classname               "AboutGameModeDetails"
        wide				    420
        wide_nx_handheld		470			[$NX || $NX_UI_PC] 
        tall					450
        xpos                    10
        visible				    1
        rui                     "ui/about_game_details.rpak"

        pin_to_sibling			Details3
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
}