"resource/ui/menus/panels/quest_rewards.res"
{
	////////////////////
	// REWARD BUTTONS //
	////////////////////

	//row 1
	RewardButton0
	{
		ControlName				RuiButton
		classname				RewardButton
		xpos					329
		ypos				    570

		navLeft                 TodaysReward
		navUp                   MissionButton0
		navRight                RewardButton1
		navDown                 RewardButton7

		wide					92
		tall					92
		visible					1
		enabled					1
		rui					    "ui/quest_reward_button.rpak"
		clipRui					1
		clip                    1

		cursorVelocityModifier  0.7
		sound_focus             "UI_Menu_Focus_Small"
		rightClickEvents		0
		doubleClickEvents       0
	}

	RewardButton1
	{
		ControlName				RuiButton
		classname				RewardButton
		pin_to_sibling			RewardButton0
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos					6
		ypos					0
		navUp                   MissionButton0
		navLeft                 RewardButton0
		navRight                RewardButton2
		navDown                 RewardButton8

		wide					92
        tall					92
		visible					1
		enabled					1
		rui					    "ui/quest_reward_button.rpak"
		clipRui					1
		clip                    1

		cursorVelocityModifier  0.7
		sound_focus             "UI_Menu_Focus_Small"
		rightClickEvents		0
		doubleClickEvents       0
	}

	RewardButton2
	{
		ControlName				RuiButton
		classname				RewardButton
		pin_to_sibling			RewardButton1
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos					6
		ypos					0

		navUp                   MissionButton0
		navLeft                 RewardButton1
		navRight                RewardButton3
		navDown                 RewardButton9

		wide					92
        tall					92
		visible					1
		enabled					1
		rui					    "ui/quest_reward_button.rpak"
		clipRui					1
		clip                    1

		cursorVelocityModifier  0.7
		sound_focus             "UI_Menu_Focus_Small"
		rightClickEvents		0
		doubleClickEvents       0
	}

	RewardButton3
	{
		ControlName				RuiButton
		classname				RewardButton
		pin_to_sibling			RewardButton2
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos					6
		ypos					0

		navUp                   MissionButton0
		navLeft                 RewardButton2
		navRight                RewardButton4
		navDown                 RewardButton10

		wide					92
        tall					92
		visible					1
		enabled					1
		rui					    "ui/quest_reward_button.rpak"
		clipRui					1
		clip                    1

		cursorVelocityModifier  0.7
		sound_focus             "UI_Menu_Focus_Small"
		rightClickEvents		0
		doubleClickEvents       0
	}

	RewardButton4
	{
		ControlName				RuiButton
		classname				RewardButton
		pin_to_sibling			RewardButton3
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos					6
		ypos					0

		navUp                   MissionButton0
		navLeft                 RewardButton3
		navRight                RewardButton5
		navDown                 RewardButton11

		wide					92
        tall					92
		visible					1
		enabled					1
		rui					    "ui/quest_reward_button.rpak"
		clipRui					1
		clip                    1

		cursorVelocityModifier  0.7
		sound_focus             "UI_Menu_Focus_Small"
		rightClickEvents		0
		doubleClickEvents       0
	}

	RewardButton5
	{
		ControlName				RuiButton
		classname				RewardButton
		pin_to_sibling			RewardButton4
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos					6
		ypos					0

		navUp                   MissionButton0
		navLeft                 RewardButton4
		navRight                RewardButton6
		navDown                 RewardButton12

		wide					92
        tall					92
		visible					1
		enabled					1
		rui					    "ui/quest_reward_button.rpak"
		clipRui					1
		clip                    1

		cursorVelocityModifier  0.7
		sound_focus             "UI_Menu_Focus_Small"
		rightClickEvents		0
		doubleClickEvents       0
	}

	RewardButton6
	{
		ControlName				RuiButton
		classname				RewardButton
		pin_to_sibling			RewardButton5
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos					6
		ypos					0

		navUp                   MissionButton0
		navLeft                 RewardButton5
		navRight                RewardButton7
		navDown                 RewardButton13

		wide					92
        tall					92
		visible					1
		enabled					1
		rui					    "ui/quest_reward_button.rpak"
		clipRui					1
		clip                    1

		cursorVelocityModifier  0.7
		sound_focus             "UI_Menu_Focus_Small"
		rightClickEvents		0
		doubleClickEvents       0
	}


	//row 2
	RewardButton7
    {
        ControlName				RuiButton
        classname				RewardButton
        pin_to_sibling			RewardButton6
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
        xpos					6
        ypos					0

        navUp                   RewardButton0
        navLeft                 RewardButton6
		navRight                RewardButton8
        navDown                 RewardButton14

		wide					92
        tall					92
        visible					1
        enabled					1
        rui					    "ui/quest_reward_button.rpak"
        clipRui					1
        clip                    1

        cursorVelocityModifier  0.7
        sound_focus             "UI_Menu_Focus_Small"
        rightClickEvents		0
        doubleClickEvents       0
    }
	RewardButton8
	{
		ControlName				RuiButton
		classname				RewardButton
		pin_to_sibling			RewardButton7
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
		xpos					6
        ypos					0

		navUp                   RewardButton1
        navLeft                 RewardButton7
        navRight                RewardButton9
        navDown                 RewardButton15

		wide					92
        tall					92
		visible					1
		enabled					1
		rui					    "ui/quest_reward_button.rpak"
		clipRui					1
		clip                    1

		cursorVelocityModifier  0.7
		sound_focus             "UI_Menu_Focus_Small"
		rightClickEvents		0
		doubleClickEvents       0
	}
	RewardButton9
    {
        ControlName				RuiButton
        classname				RewardButton
        pin_to_sibling			RewardButton8
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos					6
        ypos					0

		navUp                   RewardButton2
        navLeft                 RewardButton8
        navRight                RewardButton10
        navDown                 RewardButton16

		wide					92
        tall					92
        visible					1
        enabled					1
        rui					    "ui/quest_reward_button.rpak"
        clipRui					1
        clip                    1

        cursorVelocityModifier  0.7
        sound_focus             "UI_Menu_Focus_Small"
        rightClickEvents		0
        doubleClickEvents       0
    }
    RewardButton10
    {
        ControlName				RuiButton
        classname				RewardButton
        pin_to_sibling			RewardButton9
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos					6
        ypos					0

		navUp                   RewardButton3
        navLeft                 RewardButton9
        navRight                RewardButton11
        navDown                 RewardButton17

		wide					92
        tall					92
        visible					1
        enabled					1
        rui					    "ui/quest_reward_button.rpak"
        clipRui					1
        clip                    1

        cursorVelocityModifier  0.7
        sound_focus             "UI_Menu_Focus_Small"
        rightClickEvents		0
        doubleClickEvents       0
    }
    RewardButton11
    {
        ControlName				RuiButton
        classname				RewardButton
        pin_to_sibling			RewardButton10
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos					6
        ypos					0

        navLeft                 RewardButton10

        wide					92
        tall					92
        visible					1
        enabled					1
        rui					    "ui/quest_reward_button.rpak"
        clipRui					1
        clip                    1

        cursorVelocityModifier  0.7
        sound_focus             "UI_Menu_Focus_Small"
        rightClickEvents		0
        doubleClickEvents       0
    }
}