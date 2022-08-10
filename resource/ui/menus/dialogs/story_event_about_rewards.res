resource/ui/menus/dialogs/story_event_about_rewards_track.res
{

	//Challenge 0 LEFT peak
	Challenge0
	{
		ControlName				RuiButton

		rightClickEvents		1
		scriptId                12
		wide					370
		tall					227
		xpos                    -273
		ypos                    0
		zpos                    6
		visible					0
        rui					    "ui/story_event_about_button.rpak"
        sound_focus             ""
        sound_accept            ""

		clipRui					1
		clip                    1

        cursorPriority          1

	}
	 PlaylistChallenge0Button
    {
        ControlName			    RuiButton
        zpos			        14
        wide			        187
        tall			        35
        xpos                    -1
        ypos                    -10
        visible			        1
        labelText               ""
        rui					    "ui/story_event_start_button.rpak"
        ruiArgs
        {
            buttonText          "#CHALLENGES_STORY_LAUNCH_PLAYLIST"
        }

		clipRui					1
		clip                    1

        cursorPriority          2
        proportionalToParent    1
        sound_focus             "UI_Menu_Focus_Small"
        sound_accept            "UI_Menu_StoryEvent_Level_Select"
        cursorVelocityModifier  0.7
        pin_to_sibling			Challenge0
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	TOP_RIGHT
    }
	Challenge0RewardButton00
    {
        ControlName				RuiButton
        rui                     "ui/quest_reward_button.rpak"

        xpos                    -9
        ypos                    -8
        zpos                    7
        wide					51
        tall					51

        visible                 0

		clipRui					1
		clip                    1
		scriptID                0

        sound_accept            ""
        pin_to_sibling			Challenge0
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
    }
    Challenge0RewardButton01
    {
        ControlName				RuiButton
        rui                     "ui/quest_reward_button.rpak"

        xpos                    3
        ypos                    0
        zpos                    7
        wide					51
        tall					51

        visible                 0

		clipRui					1
		clip                    1
		scriptID                0

        sound_accept            ""
        pin_to_sibling			Challenge0RewardButton00
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
    Challenge0RewardButton02
    {
        ControlName				RuiButton
        rui                     "ui/quest_reward_button.rpak"

        xpos                    3
        ypos                    0
        zpos                    7
        wide					51
        tall					51

        visible                 0

		clipRui					1
		clip                    1
		scriptID                0

        sound_accept            ""
        pin_to_sibling			Challenge0RewardButton01
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
    Challenge0RVButton
    {
        ControlName				RuiButton
        rui                     "ui/quest_vignette_button.rpak"

        xpos                    -9
        ypos                    -8
        zpos                    7
        wide					54
        tall					53

        visible                 0

        clipRui					1
        clip                    1
        scriptID                0

        sound_accept            ""
        cursorPriority          2
        pin_to_sibling			Challenge0
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
    //Challenge 1
    Challenge1
    {
        ControlName				RuiButton

        rightClickEvents		1
        scriptId                12
		wide					370
		tall					227

        xpos                    4
        ypos                    0
        zpos                    6
        visible					0
        rui					    "ui/story_event_about_button.rpak"
        sound_focus             ""
        sound_accept            ""

        cursorPriority          1

		clipRui					1
		clip                    1

        pin_to_sibling			Challenge0
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_RIGHT
    }
    PlaylistChallenge1Button
    {
        ControlName			    RuiButton
        zpos			        14
        wide			        187
        tall			        35
        xpos                    -1
        ypos                    -10
        visible			        1
        labelText               ""
        rui					    "ui/story_event_start_button.rpak"
        ruiArgs
        {
            buttonText          "#CHALLENGES_STORY_LAUNCH_PLAYLIST"
        }

		clipRui					1
		clip                    1

        cursorPriority          2
        proportionalToParent    1
        sound_focus             "UI_Menu_Focus_Small"
        sound_accept            "UI_Menu_StoryEvent_Level_Select"
        cursorVelocityModifier  0.7
        pin_to_sibling			Challenge1
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	TOP_RIGHT
    }
    PrologueButton
    {
        ControlName			    RuiButton
        zpos			        14
        wide			        330
        tall			        68
        xpos                    -20
        ypos                    -91
        visible			        1
        labelText               ""
        rui					    "ui/generic_icon_button.rpak"
        ruiArgs
        {
            buttonText          "#CHALLENGES_STORY_START"
        }
        cursorPriority          2
        proportionalToParent    1
        sound_focus             "UI_Menu_Focus_Small"
        sound_accept            "UI_Menu_StoryEvent_Level_Select"
        cursorVelocityModifier  0.7
        pin_to_sibling			Challenge1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
    Challenge1RewardButton00
    {
        ControlName				RuiButton
        rui                     "ui/quest_reward_button.rpak"

        xpos                    -9
        ypos                    -8
        zpos                    7
        wide					51
        tall					51

        visible                 0

		clipRui					1
		clip                    1
		scriptID                1

        sound_accept            ""
        cursorPriority          2
        pin_to_sibling			Challenge1
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
    }
    Challenge1RewardButton01
    {
        ControlName				RuiButton
        rui                     "ui/quest_reward_button.rpak"

        xpos                    3
        ypos                    0
        zpos                    7
        wide					51
        tall					51

        visible                 0

		clipRui					1
		clip                    1
		scriptID                1

        sound_accept            ""
        cursorPriority          2
        pin_to_sibling			Challenge1RewardButton00
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
    Challenge1RewardButton02
    {
        ControlName				RuiButton
        rui                     "ui/quest_reward_button.rpak"

        xpos                    3
        ypos                    0
        zpos                    7
        wide					51
        tall					51

        visible                 0

		clipRui					1
		clip                    1
		scriptID                1

        sound_accept            ""
        cursorPriority          2
        pin_to_sibling			Challenge1RewardButton01
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
    Challenge1RVButton
    {
        ControlName				RuiButton
        rui                     "ui/quest_vignette_button.rpak"

        xpos                    -9
        ypos                    -8
        zpos                    7
        wide					54
        tall					53

        visible                 0

        clipRui					1
        clip                    1
        scriptID                1

        sound_accept            ""
        cursorPriority          2
        pin_to_sibling			Challenge1
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
    //challenge2
    Challenge2
    {
        ControlName				RuiButton

        rightClickEvents		1
        scriptId                12
		wide					370
		tall					227
        xpos                    4
        ypos                    0
        zpos                    6
        visible					0
        rui					    "ui/story_event_about_button.rpak"
        sound_focus             ""
        sound_accept            ""

        cursorPriority          1

		clipRui					1
		clip                    1

        pin_to_sibling			Challenge1
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_RIGHT
    }
    PlaylistChallenge2Button
    {
        ControlName			    RuiButton
        zpos			        14
        wide			        187
        tall			        35
        xpos                    -1
        ypos                    -10
        visible			        1
        labelText               ""
        rui					    "ui/story_event_start_button.rpak"
        ruiArgs
        {
            buttonText          "#CHALLENGES_STORY_LAUNCH_PLAYLIST"
        }

		clipRui					1
		clip                    1

        cursorPriority          2
        proportionalToParent    1
        sound_focus             "UI_Menu_Focus_Small"
        sound_accept            "UI_Menu_StoryEvent_Level_Select"
        cursorVelocityModifier  0.7
        pin_to_sibling			Challenge2
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	TOP_RIGHT
    }
    Challenge2RewardButton00
    {
        ControlName				RuiButton
        rui                     "ui/quest_reward_button.rpak"

        xpos                    -9
        ypos                    -8
        zpos                    7
        wide					51
        tall					51

        visible                 0

		clipRui					1
		clip                    1
		scriptID                2

        sound_accept            ""
        cursorPriority          2
        pin_to_sibling			Challenge2
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
    }
    Challenge2RewardButton01
    {
        ControlName				RuiButton
        rui                     "ui/quest_reward_button.rpak"

        xpos                    3
        ypos                    0
        zpos                    7
        wide					51
        tall					51

        visible                 0

		clipRui					1
		clip                    1
		scriptID                2

        sound_accept            ""
        cursorPriority          2
        pin_to_sibling			Challenge2RewardButton00
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
    Challenge2RewardButton02
    {
        ControlName				RuiButton
        rui                     "ui/quest_reward_button.rpak"

        xpos                    3
        ypos                    0
        zpos                    7
        wide					51
        tall					51

        visible                 0

		clipRui					1
		clip                    1
		scriptID                2

        sound_accept            ""
        cursorPriority          2
        pin_to_sibling			Challenge2RewardButton01
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
    Challenge2RVButton
    {
        ControlName				RuiButton
        rui                     "ui/quest_vignette_button.rpak"

        xpos                    -9
        ypos                    -8
        zpos                    7
        wide					54
        tall					53

        visible                 0

        clipRui					1
        clip                    1
        scriptID                2

        sound_accept            ""
        cursorPriority          2
        pin_to_sibling			Challenge2
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    //challenge 3
    Challenge3
    {
        ControlName				RuiButton

        rightClickEvents		1
        scriptId                12
		wide					370
		tall					227
        xpos                    4
        ypos                    0
        zpos                    6
        visible					0
        rui					    "ui/story_event_about_button.rpak"
        //sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""

        cursorPriority          1

		clipRui					1
		clip                    1

        pin_to_sibling			Challenge2
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_RIGHT
    }
    PlaylistChallenge3Button
    {
        ControlName			    RuiButton
        zpos			        14
        wide			        187
        tall			        35
        xpos                    -1
        ypos                    -10
        visible			        1
        labelText               ""
        rui					    "ui/story_event_start_button.rpak"
        ruiArgs
        {
            buttonText          "#CHALLENGES_STORY_LAUNCH_PLAYLIST"
        }

		clipRui					1
		clip                    1

        cursorPriority          2
        proportionalToParent    1
        sound_focus             "UI_Menu_Focus_Small"
        sound_accept            "UI_Menu_StoryEvent_Level_Select"
        cursorVelocityModifier  0.7
        pin_to_sibling			Challenge3
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	TOP_RIGHT
    }
	Challenge3RewardButton00
    {
        ControlName				RuiButton
        rui                     "ui/quest_reward_button.rpak"

        xpos                    -9
        ypos                    -8
        zpos                    7
        wide					51
        tall					51

        visible                 0

		clipRui					1
		clip                    1
		scriptID                3

        sound_accept            ""
        cursorPriority          2
        pin_to_sibling			Challenge3
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
    }
    Challenge3RewardButton01
    {
        ControlName				RuiButton
        rui                     "ui/quest_reward_button.rpak"

        xpos                    3
        ypos                    0
        zpos                    7
        wide					51
        tall					51

        visible                 0

		clipRui					1
		clip                    1
		scriptID                3

        sound_accept            ""
        cursorPriority          2
        pin_to_sibling			Challenge3RewardButton00
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
    Challenge3RewardButton02
    {
        ControlName				RuiButton
        rui                     "ui/quest_reward_button.rpak"

        xpos                    3
        ypos                    0
        zpos                    7
        wide					51
        tall					51

        visible                 0

		clipRui					1
		clip                    1
		scriptID                3

        sound_accept            ""
        cursorPriority          2
        pin_to_sibling			Challenge3RewardButton01
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
    Challenge3RVButton
    {
        ControlName				RuiButton
        rui                     "ui/quest_vignette_button.rpak"

        xpos                    -9
        ypos                    -8
        zpos                    7
        wide					54
        tall					53

        visible                 0

        clipRui					1
        clip                    1
        scriptID                3

        sound_accept            ""
        cursorPriority          2
        pin_to_sibling			Challenge3
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
	//challenge 4
    Challenge4
    {
        ControlName				RuiButton

        rightClickEvents		1
        scriptId                12
		wide					370
		tall					227
        xpos                    4
        ypos                    0
        zpos                    6
        visible					0
        rui					    "ui/story_event_about_button.rpak"
        //sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""

        cursorPriority          1

		clipRui					1
		clip                    1

        pin_to_sibling			Challenge3
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_RIGHT
    }
    PlaylistChallenge4Button
    {
        ControlName			    RuiButton
        zpos			        14
        wide			        187
        tall			        35
        xpos                    -1
        ypos                    -10
        visible			        1
        labelText               ""
        rui					    "ui/story_event_start_button.rpak"
        ruiArgs
        {
            buttonText          "#CHALLENGES_STORY_LAUNCH_PLAYLIST"
        }

		clipRui					1
		clip                    1

        cursorPriority          2
        proportionalToParent    1
        sound_focus             "UI_Menu_Focus_Small"
        sound_accept            "UI_Menu_StoryEvent_Level_Select"
        cursorVelocityModifier  0.7
        pin_to_sibling			Challenge4
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	TOP_RIGHT
    }
	Challenge4RewardButton00
    {
        ControlName				RuiButton
        rui                     "ui/quest_reward_button.rpak"

        xpos                    -9
        ypos                    -8
        zpos                    7
        wide					51
        tall					51

        visible                 0

		clipRui					1
		clip                    1
		scriptID                4

        sound_accept            ""
        cursorPriority          2
        pin_to_sibling			Challenge4
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
    }
    Challenge4RewardButton01
    {
        ControlName				RuiButton
        rui                     "ui/quest_reward_button.rpak"

        xpos                    3
        ypos                    0
        zpos                    7
        wide					51
        tall					51

        visible                 0

		clipRui					1
		clip                    1
		scriptID                4

        sound_accept            ""
        cursorPriority          2
        pin_to_sibling			Challenge4RewardButton00
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
    Challenge4RewardButton02
    {
        ControlName				RuiButton
        rui                     "ui/quest_reward_button.rpak"

        xpos                    3
        ypos                    0
        zpos                    7
        wide					51
        tall					51

        visible                 0

		clipRui					1
		clip                    1
		scriptID                4

        sound_accept            ""
        cursorPriority          2
        pin_to_sibling			Challenge4RewardButton01
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
    Challenge4RVButton
    {
        ControlName				RuiButton
        rui                     "ui/quest_vignette_button.rpak"

        xpos                    -9
        ypos                    -8
        zpos                    7
        wide					54
        tall					53

        visible                 0

        clipRui					1
        clip                    1
        scriptID                4

        sound_accept            ""
        cursorPriority          2
        pin_to_sibling			Challenge4
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
    //challenge 5
    Challenge5
    {
        ControlName				RuiButton

        rightClickEvents		1
        scriptId                12
		wide					370
		tall					227
        xpos                    4
        ypos                    0
        zpos                    6
        visible					0
        rui					    "ui/story_event_about_button.rpak"
        //sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""

        cursorPriority          1

		clipRui					1
		clip                    1

        pin_to_sibling			Challenge4
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_RIGHT
    }
    PlaylistChallenge5Button
    {
        ControlName			    RuiButton
        zpos			        14
        wide			        187
        tall			        35
        xpos                    -1
        ypos                    -10
        visible			        1
        labelText               ""
        rui					    "ui/story_event_start_button.rpak"
        ruiArgs
        {
            buttonText          "#CHALLENGES_STORY_LAUNCH_PLAYLIST"
        }

		clipRui					1
		clip                    1

        cursorPriority          2
        proportionalToParent    1
        sound_focus             "UI_Menu_Focus_Small"
        sound_accept            "UI_Menu_StoryEvent_Level_Select"
        cursorVelocityModifier  0.7
        pin_to_sibling			Challenge5
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	TOP_RIGHT
    }
    Challenge5RewardButton00
    {
        ControlName				RuiButton
        rui                     "ui/quest_reward_button.rpak"

        xpos                    -9
        ypos                    -8
        zpos                    7
        wide					51
        tall					51

        visible                 0

		clipRui					1
		clip                    1
		scriptID                5

        sound_accept            ""
        cursorPriority          2
        pin_to_sibling			Challenge5
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
    }
    Challenge5RewardButton01
    {
        ControlName				RuiButton
        rui                     "ui/quest_reward_button.rpak"

        xpos                    3
        ypos                    0
        zpos                    7
        wide					51
        tall					51

        visible                 0

		clipRui					1
		clip                    1
		scriptID                5

        sound_accept            ""
        cursorPriority          2
        pin_to_sibling			Challenge5RewardButton00
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
    Challenge5RewardButton02
    {
        ControlName				RuiButton
        rui                     "ui/quest_reward_button.rpak"

        xpos                    3
        ypos                    0
        zpos                    7
        wide					51
        tall					51

        visible                 0

		clipRui					1
		clip                    1
		scriptID                5

        sound_accept            ""
        cursorPriority          2
        pin_to_sibling			Challenge5RewardButton01
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
    Challenge5RVButton
    {
        ControlName				RuiButton
        rui                     "ui/quest_vignette_button.rpak"

        xpos                    -9
        ypos                    -8
        zpos                    7
        wide					54
        tall					53

        visible                 0

        clipRui					1
        clip                    1
        scriptID                5

        sound_accept            ""
        cursorPriority          2
        pin_to_sibling			Challenge5
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
}


