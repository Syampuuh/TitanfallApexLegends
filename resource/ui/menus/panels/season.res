"resource/ui/menus/panels/season.res"
{
	PanelFrame
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
	    bgcolor_override		"70 30 30 255"
		visible					0
		paintbackground			1
		proportionalToParent    1
	}

    TabsCommon
    {
        ControlName				CNestedPanel
        classname				"TabsCommonClass"
        zpos					1
        wide					f0
        tall					72
        visible					1
        controlSettingsFile		"resource/ui/menus/panels/tabs_season.res"

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
    }

    WhatsNewPanel
    {
        ControlName				CNestedPanel
        classname				"TabPanelClass"
        ypos					-124
        wide					%100
        tall					804
        visible					0
        tabPosition             0
        controlSettingsFile		"resource/ui/menus/panels/whats_new.res"
		proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
    }

    CollectionEventPanel
    {
        ControlName				CNestedPanel
        classname				"TabPanelClass"
        ypos					-124
        wide					%100
        tall					804
        visible					0
        tabPosition             1
        controlSettingsFile		"resource/ui/menus/panels/store_collection_event.res"
		proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
    }

	ThemedShopPanel
    {
        ControlName				CNestedPanel
        ypos					-124
        wide					%100
        tall					804
        visible					0
        tabPosition             2
        controlSettingsFile		"resource/ui/menus/panels/store_themed_shop_event.res"
		proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
    }

	PassPanel
	{
		ControlName				CNestedPanel
		classname				"TabPanelClass"
        ypos					-124
        wide					%100
        tall					804
		visible					0
		controlSettingsFile		"resource/ui/menus/panels/battlepass.res"

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
	}

	QuestPanel
	{
		ControlName				CNestedPanel
        classname				"TabPanelClass"
        ypos					-124
        wide					%100
        tall					804
        visible					0
        tabPosition             2
		controlSettingsFile		"resource/ui/menus/panels/quest.res"
		proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
	}

	ChallengesPanel
	{
		ControlName				CNestedPanel
        classname				"TabPanelClass"
        ypos					-124
        wide					%100
        tall					804
		visible                 0
		enabled                 1
		controlSettingsFile		"resource/ui/menus/panels/challenges.res"
		proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
	}
}
