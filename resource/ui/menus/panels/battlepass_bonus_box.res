"resource/ui/menus/panels/battlepass_bonus_box.res"
{
    PanelFrame
    {
        ControlName				RuiPanel
        xpos					160
        ypos					-20
        wide					546
        tall					85
        visible					1
        rui					    "ui/battle_pass_bonus_box.rpak"
        proportionalToParent    0
    }

	BonusButton1
	{
		ControlName				RuiButton
		classname               "RewardButton MenuButton"
		scriptId                0
		wide					75
        tall					85
		visible					1
        rui					    "ui/battle_pass_bonus_button.rpak"
        proportionalToParent    0
        enabled                 0

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	LEFT
        pin_to_sibling_corner	LEFT
	}

	BonusButton2
	{
		ControlName				RuiButton
		classname               "RewardButton MenuButton"
		scriptId                0
		wide					75
        tall					85
		visible					1
        rui					    "ui/battle_pass_bonus_button.rpak"
        proportionalToParent    0
        enabled                 0

        pin_to_sibling			BonusButton1
        pin_corner_to_sibling	LEFT
        pin_to_sibling_corner	RIGHT
	}

	BonusButton3
	{
		ControlName				RuiButton
		classname               "RewardButton MenuButton"
		scriptId                0
		wide					75
        tall					85
		visible					1
        rui					    "ui/battle_pass_bonus_button.rpak"
        proportionalToParent    0
        enabled                 0

        pin_to_sibling			BonusButton2
        pin_corner_to_sibling	LEFT
        pin_to_sibling_corner	RIGHT
	}

	BonusButton4
    {
        ControlName				RuiButton
		classname               "RewardButton MenuButton"
        scriptId                0
        wide					75
        tall					85
        visible					1
        rui					    "ui/battle_pass_bonus_button.rpak"
        proportionalToParent    0
        enabled                 0

        pin_to_sibling			BonusButton3
        pin_corner_to_sibling	LEFT
        pin_to_sibling_corner	RIGHT
    }

    BonusButton5
    {
        ControlName				RuiButton
        classname               RewardButton
        scriptId                0
        wide					75
        tall					85
        visible					1
        rui					    "ui/battle_pass_bonus_button.rpak"
        proportionalToParent    0
        enabled                 0

        pin_to_sibling			BonusButton4
        pin_corner_to_sibling	LEFT
        pin_to_sibling_corner	RIGHT
    }

    BonusButton6
    {
        ControlName				RuiButton
        classname               RewardButton
        scriptId                0
        wide					75
        tall					85
        visible					1
        rui					    "ui/battle_pass_bonus_button.rpak"
        proportionalToParent    0
        enabled                 0

        pin_to_sibling			BonusButton5
        pin_corner_to_sibling	LEFT
        pin_to_sibling_corner	RIGHT
    }

    BonusButton7
    {
        ControlName				RuiButton
        classname               RewardButton
        scriptId                0
        wide					75
        tall					85
        visible					1
        rui					    "ui/battle_pass_bonus_button.rpak"
        proportionalToParent    0
        enabled                 0

        pin_to_sibling			BonusButton6
        pin_corner_to_sibling	LEFT
        pin_to_sibling_corner	RIGHT
    }

	FrameButton
	{
		ControlName				RuiButton
        xpos					0
        ypos					0
        wide					%100
        tall					%100
		visible					1
        rui					    "ui/basic_image.rpak"
        proportionalToParent    1

        ruiArgs
        {
            basicImageAlpha     0.0
        }
	}
}
