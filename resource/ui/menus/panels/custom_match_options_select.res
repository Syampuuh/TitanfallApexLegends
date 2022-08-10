"resource/ui/menus/panels/custom_match_options_select.res"
{
    PanelFrame
    {
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
		visible				    0
        bgcolor_override        "0 0 255 32"
        paintbackground         1

        proportionalToParent    1
    }

    SelectOptionsSubHeader
    {
        ControlName             RuiPanel

        wide                    590
        wide_nx_handheld        740			[$NX || $NX_UI_PC]
        tall                    48
        clipRui                 1

        rui                     "ui/custom_match_settings_sub_header.rpak"
        ruiArgs
        {
            headerText          "#CUSTOM_MATCH_OPTIONS_SELECT"
        }

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT
    }

    SelectOptions
    {
        ControlName			    CNestedPanel

        wide                    590
        wide_nx_handheld        740			[$NX || $NX_UI_PC]
        tall                    676

        //visible                 0

        pin_to_sibling          SelectOptionsSubHeader
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT

        ScrollFrame
        {
            ControlName				ImagePanel
            InheritProperties       SettingsScrollFrame
        }

        ScrollBar
        {
            ControlName				RuiButton
            InheritProperties       SettingsScrollBar

            pin_to_sibling			ScrollFrame
            pin_corner_to_sibling	TOP_RIGHT
            pin_to_sibling_corner	TOP_RIGHT
        }

        OptionsPanel
        {
            ControlName				CNestedPanel
            InheritProperties       SettingsContentPanel
			tall                    1100 [!$NX && !$NX_UI_PC]
            tall                    1580 [$NX || $NX_UI_PC]
			tall_nx_handheld        2090 [$NX || $NX_UI_PC]

		    ChatPermissions
		    {
		        ControlName				RuiButton
		        InheritProperties		SwitchButton
		        style					DialogListButton
		        list
		        {
		            "#CUSTOM_MATCH_CHAT_MODE_ALL"       0
		            "#CUSTOM_MATCH_CHAT_MODE_ADMIN"		1
		        }

				wide                    590
				wide_nx_handheld        740			[$NX || $NX_UI_PC]
		        childGroupAlways        ChoiceButtonAlways

			    navDown					RenameTeam
                bubbleNavEvents         1
		    }

		    RenameTeam
		    {
		        ControlName				RuiButton
		        InheritProperties		SwitchButton
		        style					DialogListButton
		        list
		        {
		            "#SETTING_ON"       1
		            "#SETTING_OFF"		0
		        }

				wide                    590
				wide_nx_handheld        740			[$NX || $NX_UI_PC]
		        childGroupAlways        ChoiceButtonAlways

			    navUp					ChatPermissions
			    navDown					SelfAssign

			    pin_to_sibling			ChatPermissions
			    pin_corner_to_sibling	TOP_LEFT
			    pin_to_sibling_corner	BOTTOM_LEFT
		    }

		    SelfAssign
		    {
		        ControlName				RuiButton
		        InheritProperties		SwitchButton
		        style					DialogListButton
		        list
		        {
		            "#SETTING_ON"       1
		            "#SETTING_OFF"		0
		        }

				wide                    590
				wide_nx_handheld        740			[$NX || $NX_UI_PC]
		        childGroupAlways        ChoiceButtonAlways

			    navUp					RenameTeam
			    navDown					AimAssist

			    pin_to_sibling			RenameTeam
			    pin_corner_to_sibling	TOP_LEFT
			    pin_to_sibling_corner	BOTTOM_LEFT
		    }

		    AimAssist
		    {
		        ControlName				RuiButton
		        InheritProperties		SwitchButton
		        style					DialogListButton
		        list
		        {
		            "#SETTING_ON"       1
		            "#SETTING_OFF"		0
		        }

				wide                    590
				wide_nx_handheld        740			[$NX || $NX_UI_PC]
		        childGroupAlways        ChoiceButtonAlways

			    navUp					SelfAssign
			    navDown					AnonymousMode

			    pin_to_sibling			SelfAssign
			    pin_corner_to_sibling	TOP_LEFT
			    pin_to_sibling_corner	BOTTOM_LEFT
		    }

		    AnonymousMode
		    {
		        ControlName				RuiButton
		        InheritProperties		SwitchButton
		        style					DialogListButton
		        list
		        {
		            "#SETTING_ON"       1
		            "#SETTING_OFF"		0
		        }

				wide                    590
				wide_nx_handheld        740			[$NX || $NX_UI_PC]
		        childGroupAlways        ChoiceButtonAlways

			    navUp					AimAssist
			    navDown					ModeVariant

			    pin_to_sibling			AimAssist
			    pin_corner_to_sibling	TOP_LEFT
			    pin_to_sibling_corner	BOTTOM_LEFT
		    }

		    ModeVariant
		    {
		        ControlName				RuiButton
		        InheritProperties		SwitchButton
		        style					DialogListButton

				wide                    590
				wide_nx_handheld        740			[$NX || $NX_UI_PC]
		        childGroupAlways        MultiChoiceButtonAlways

			    navUp					AnonymousMode
                bubbleNavEvents         1

			    pin_to_sibling			AnonymousMode
			    pin_corner_to_sibling	TOP_LEFT
			    pin_to_sibling_corner	BOTTOM_LEFT
		    }
        }
    }
}