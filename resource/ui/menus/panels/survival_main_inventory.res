Resource/UI/menus/panels/survival_main_inventory.res
{
    PanelFrame
    {
		ControlName				ImagePanel
		wide					f0
		tall					f0
		visible				    0
        scaleImage				1
        image					"vgui/HUD/white"
        drawColor				"255 255 255 15"

        proportionalToParent    1
    }

    Helmet
    {
        ControlName             RuiButton
        InheritProperties       SurvivalEquipmentButton

        classname               "SurvivalEquipment"
        scriptID                "helmet"

        wide                    94
        wide_nx_handheld        119			[$NX || $NX_UI_PC]
        tall                    120
        tall_nx_handheld        152			[$NX || $NX_UI_PC]

        rightClickEvents        1

        xpos                    8
        ypos                    0

        navUp                   GridButton1x1
        navRight                Armor

        pin_to_sibling          Armor
        pin_corner_to_sibling   RIGHT
        pin_to_sibling_corner   LEFT
    }

    Armor
    {
        ControlName             RuiButton
        InheritProperties       SurvivalEquipmentButton

        classname               "SurvivalEquipment"
        scriptID                "armor"

        wide                    94
        wide_nx_handheld        119			[$NX || $NX_UI_PC]
        tall                    120
        tall_nx_handheld        152			[$NX || $NX_UI_PC]

        rightClickEvents        1

        xpos                    8
        ypos                    0

        navUp                   GridButton1x2
        navLeft                 Helmet
        navRight                IncapShield

        pin_to_sibling          IncapShield
        pin_corner_to_sibling   RIGHT
        pin_to_sibling_corner   LEFT
    }

    IncapShield
    {
        ControlName             RuiButton
        InheritProperties       SurvivalEquipmentButton

        classname               "SurvivalEquipment"
        scriptID                "incapshield"
        visible                 1


        wide                    94
        wide_nx_handheld        119			[$NX || $NX_UI_PC]
        tall                    120
        tall_nx_handheld        152			[$NX || $NX_UI_PC]

        rightClickEvents        1

        xpos                    8
        ypos                    25
        ypos_nx_handheld        0			[$NX || $NX_UI_PC]

        navUp                   GridButton1x3
        navLeft                 Armor
        navRight                BackPack

        pin_to_sibling          BackpackGrid
        pin_corner_to_sibling   TOP
        pin_to_sibling_corner   BOTTOM
    }
    BackPack
    {
        ControlName             RuiButton
        InheritProperties       SurvivalEquipmentButton

        classname               "SurvivalEquipment"
        scriptID                "backpack"

        wide                    94
        wide_nx_handheld        119			[$NX || $NX_UI_PC]
        tall                    120
        tall_nx_handheld        152			[$NX || $NX_UI_PC]

        rightClickEvents        1

        xpos                    8
        ypos                    0

        navUp                   GridButton1x4
        navLeft                 IncapShield
        navRight                GadgetSlot
                  
                                         
      

                            
                                                   
      

        pin_to_sibling          IncapShield
        pin_corner_to_sibling   LEFT
        pin_to_sibling_corner   RIGHT
    }

                  
             
     
                                         
                                                       

                                                   
                                           

                                  
                                                        
                                          

                                 

                                 
                                 

                                             
                                        

                                        
                                    
                                     
     
      

    GadgetSlot
    {
        ControlName             RuiButton
        InheritProperties       SurvivalEquipmentButton

        classname               "SurvivalEquipment"
        scriptID                "gadgetslot"

        wide                    94
        wide_nx_handheld        119			[$NX || $NX_UI_PC]
        tall                    120
        tall_nx_handheld        152			[$NX || $NX_UI_PC]

        rightClickEvents        1
                                    
                                   
              
        xpos                    100
        xpos_nx_handheld        38			[$NX || $NX_UI_PC]
        ypos                    0

        navUp                   GridButton1x5
        navLeft                 BackPack
        
		pin_to_sibling          BackPack
        pin_corner_to_sibling   LEFT
        pin_to_sibling_corner   RIGHT
    }
                            
                       
     
                                         
                                                       

                                                   
                                                 

                                  
                                                        
                                   
                                                        
                                          

                                 

                                  
                                 

                                             
                                        

                                        
                                    
                                     
     
      

    MainWeapon0
    {
        ControlName             RuiButton
        InheritProperties       SurvivalWeaponButtonWide

        wide					510
        wide_nx_handheld		640			[$NX || $NX_UI_PC]
        tall					310
        tall_nx_handheld		390			[$NX || $NX_UI_PC]

        classname               "SurvivalEquipment"
        scriptID                "main_weapon0"

        navUp                   MainWeapon0_Barrel
        navDown                 GridButton0x0
        navRight                MainWeapon1

        rightClickEvents        1

        xpos                    -40
        xpos_nx_handheld        -20			[$NX || $NX_UI_PC]
        ypos                    -80
        ypos_nx_handheld        -45			[$NX || $NX_UI_PC]
        zpos                    1

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   BOTTOM_RIGHT
        pin_to_sibling_corner   CENTER
    }

    MainWeaponReskin0
    {
        ControlName             RuiButton
        InheritProperties       SurvivalWeaponButtonWide
        rui						"ui/survival_weapon_reskin_button.rpak"

        wide					64
        tall					64

        scriptID                "0"

        xpos                    0
        ypos                    -8
        zpos                    4
        visible                 0
        cursorPriority          1

        pin_to_sibling          MainWeapon0
        pin_corner_to_sibling   TOP_RIGHT
        pin_to_sibling_corner   TOP_RIGHT
    }

    MainWeaponChargeUp0
    {
        ControlName             RuiButton
        InheritProperties       SurvivalAttachmentButton
        rui						"ui/survival_weapon_chargeup_ping_button.rpak"

        wide					84
        tall					84

		classname               "RequestButton"
        scriptID                "main_weapon0"

        xpos                    -12
        ypos                    -40
        zpos                    3
        visible                 0
        cursorPriority          1

        navDown                 MainWeapon0

        pin_to_sibling          MainWeapon0
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT
    }

    MainWeapon0_Name
    {
        ControlName				Label
        wide                    224
        labelText				"Spitfire"
        visible                 0

        ypos                    72
        pin_to_sibling          MainWeapon0
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
    }

    MainWeapon0_Barrel
    {
        ControlName             RuiButton
        InheritProperties       SurvivalAttachmentButton

        wide					75
        tall					75

        classname               "SurvivalEquipment"
        scriptID                "main_weapon0_barrel"

        rightClickEvents        1

        navRight                MainWeapon0_Mag
        navDown                 MainWeapon0

        ypos                    -8
        xpos                    -8
        zpos                    3
        cursorPriority          1

        pin_to_sibling          MainWeapon0
        pin_corner_to_sibling   BOTTOM_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
    }

    MainWeapon0_Mag
    {
        ControlName             RuiButton
        InheritProperties       SurvivalAttachmentButton

        wide					75
        tall					75

        classname               "SurvivalEquipment"
        scriptID                "main_weapon0_mag"

        rightClickEvents        1

        navLeft                 MainWeapon0_Barrel
        navRight                MainWeapon0_Sight
        navDown                 MainWeapon0

        xpos                    4
        ypos                    0
        zpos                    3
        cursorPriority          1

        pin_to_sibling          MainWeapon0_Barrel
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_RIGHT
    }

    MainWeapon0_Sight
    {
        ControlName             RuiButton
        InheritProperties       SurvivalAttachmentButton

        wide					75
        tall					75

        classname               "SurvivalEquipment"
        scriptID                "main_weapon0_sight"

        rightClickEvents        1

        navLeft                 MainWeapon0_Mag
        navRight                MainWeapon0_Grip
        navDown                 MainWeapon0

        xpos                    4
        ypos                    0
        zpos                    3
        cursorPriority          1

        pin_to_sibling          MainWeapon0_Mag
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_RIGHT
    }

    MainWeapon0_Grip
    {
        ControlName             RuiButton
        InheritProperties       SurvivalAttachmentButton

        wide					75
        tall					75

        classname               "SurvivalEquipment"
        scriptID                "main_weapon0_grip"

        rightClickEvents        1

        navLeft                 MainWeapon0_Sight
        navRight                MainWeapon0_Hopup
        navDown                 MainWeapon0

        xpos                    4
        ypos                    0
        zpos                    3
        cursorPriority          1

        pin_to_sibling          MainWeapon0_Sight
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_RIGHT
    }

    MainWeapon0_Hopup
    {
        ControlName             RuiButton
        InheritProperties       SurvivalAttachmentButton

        wide					75
        tall					75

        classname               "SurvivalEquipment"
        scriptID                "main_weapon0_hopup"

        rightClickEvents        1

        navLeft                 MainWeapon0_Grip
        navDown                 MainWeapon0
        navRight                MainWeapon0_HopupMulti_a

        xpos                    4
        ypos                    0
        zpos                    3
        cursorPriority          1

        pin_to_sibling          MainWeapon0_Grip
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_RIGHT
    }

    MainWeapon0_HopupMulti_a
    {
        ControlName             RuiButton
        InheritProperties       SurvivalAttachmentButton

        wide					75
        tall					75

        classname               "SurvivalEquipment"
        scriptID                "main_weapon0_hopupMulti_a"

        rightClickEvents        1

        navLeft                 MainWeapon0_Hopup
        navDown                 MainWeapon0
        navRight                MainWeapon0_HopupMulti_b

        xpos                    4
        ypos                    0
        zpos                    3
        cursorPriority          1

        pin_to_sibling          MainWeapon0_Hopup
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_RIGHT
    }

    MainWeapon0_HopupMulti_b
    {
        ControlName             RuiButton
        InheritProperties       SurvivalAttachmentButton

        wide					75
        tall					75

        classname               "SurvivalEquipment"
        scriptID                "main_weapon0_hopupMulti_b"

        rightClickEvents        1

        navLeft                 MainWeapon0_HopupMulti_a
        navDown                 MainWeapon0

        xpos                    4
        ypos                    0
        zpos                    3
        cursorPriority          1

        pin_to_sibling          MainWeapon0_HopupMulti_a
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_RIGHT
    }

    MainWeapon1
    {
        ControlName             RuiButton
        InheritProperties       SurvivalWeaponButtonWide

        wide					510
        wide_nx_handheld		640			[$NX || $NX_UI_PC]
        tall					310
        tall_nx_handheld		390			[$NX || $NX_UI_PC]

        classname               "SurvivalEquipment"
        scriptID                "main_weapon1"

        rightClickEvents        1

        navUp                   MainWeapon1_Barrel
        navDown                 GridButton0x0
        navLeft                 MainWeapon0

        xpos                    40
        xpos_nx_handheld        20			[$NX || $NX_UI_PC]
        ypos                    -80
        ypos_nx_handheld        -45			[$NX|| $NX_UI_PC]
        zpos                    1

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   BOTTOM_LEFT
        pin_to_sibling_corner   CENTER
    }

    MainWeaponReskin1
    {
        ControlName             RuiButton
        InheritProperties       SurvivalWeaponButtonWide
        rui						"ui/survival_weapon_reskin_button.rpak"

        wide					64
        tall					64

        scriptID                "1"

        xpos                    0
        ypos                    -8
        zpos                    4
        visible                 0
        cursorPriority          1

        pin_to_sibling          MainWeapon1
        pin_corner_to_sibling   TOP_RIGHT
        pin_to_sibling_corner   TOP_RIGHT
    }

	MainWeaponChargeUp1
    {
        ControlName             RuiButton
        InheritProperties       SurvivalWeaponButtonWide
        rui						"ui/survival_weapon_chargeup_ping_button.rpak"

        wide					84
        tall					84

		classname               "RequestButton"
        scriptID                "main_weapon1"

        xpos                    -12
        ypos                    -40
        zpos                    3
        visible                 0
        cursorPriority          1

        pin_to_sibling          MainWeapon1
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT
    }

    MainWeapon1_Barrel
    {
        ControlName             RuiButton
        InheritProperties       SurvivalAttachmentButton

        wide					75
        tall					75

        classname               "SurvivalEquipment"
        scriptID                "main_weapon1_barrel"

        rightClickEvents        1

        navDown                 MainWeapon1
        navRight                MainWeapon1_Mag

        ypos                    -8
        xpos                    -8
        zpos                    3
        cursorPriority          1

        pin_to_sibling          MainWeapon1
        pin_corner_to_sibling   BOTTOM_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
    }

    MainWeapon1_Mag
    {
        ControlName             RuiButton
        InheritProperties       SurvivalAttachmentButton

        wide					75
        tall					75

        classname               "SurvivalEquipment"
        scriptID                "main_weapon1_mag"

        rightClickEvents        1

        navDown                 MainWeapon1
        navLeft                 MainWeapon1_Barrel
        navRight                MainWeapon1_Sight

        xpos                    4
        ypos                    0
        zpos                    3
        cursorPriority          1

        pin_to_sibling          MainWeapon1_Barrel
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_RIGHT
    }

    MainWeapon1_Sight
    {
        ControlName             RuiButton
        InheritProperties       SurvivalAttachmentButton

        wide					75
        tall					75

        classname               "SurvivalEquipment"
        scriptID                "main_weapon1_sight"

        rightClickEvents        1

        navDown                 MainWeapon1
        navLeft                 MainWeapon1_Mag
        navRight                MainWeapon1_Grip

        xpos                    4
        ypos                    0
        zpos                    3
        cursorPriority          1

        pin_to_sibling          MainWeapon1_Mag
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_RIGHT
    }

    MainWeapon1_Grip
    {
        ControlName             RuiButton
        InheritProperties       SurvivalAttachmentButton

        wide					75
        tall					75

        classname               "SurvivalEquipment"
        scriptID                "main_weapon1_grip"

        rightClickEvents        1

        navDown                 MainWeapon1
        navLeft                 MainWeapon1_Sight
        navRight                MainWeapon1_Hopup

        xpos                    4
        ypos                    0
        zpos                    3
        cursorPriority          1

        pin_to_sibling          MainWeapon1_Sight
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_RIGHT
    }

    MainWeapon1_Hopup
    {
        ControlName             RuiButton
        InheritProperties       SurvivalAttachmentButton

        wide					75
        tall					75

        classname               "SurvivalEquipment"
        scriptID                "main_weapon1_hopup"

        rightClickEvents        1

        navDown                 MainWeapon1
        navLeft                 MainWeapon1_Grip

        xpos                    4
        ypos                    0
        zpos                    3
        cursorPriority          1

        pin_to_sibling          MainWeapon1_Grip
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_RIGHT
    }

    MainWeapon1_HopupMulti_a
    {
        ControlName             RuiButton
        InheritProperties       SurvivalAttachmentButton

        wide					75
        tall					75

        classname               "SurvivalEquipment"
        scriptID                "main_weapon1_hopupMulti_a"

        rightClickEvents        1

        navLeft                 MainWeapon1_Hopup
        navDown                 MainWeapon1
        navRight                MainWeapon1_HopupMulti_b

        xpos                    4
        ypos                    0
        zpos                    3
        cursorPriority          1

        pin_to_sibling          MainWeapon1_Hopup
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_RIGHT
    }

    MainWeapon1_HopupMulti_b
    {
        ControlName             RuiButton
        InheritProperties       SurvivalAttachmentButton

        wide					75
        tall					75

        classname               "SurvivalEquipment"
        scriptID                "main_weapon1_hopupMulti_b"

        rightClickEvents        1

        navLeft                 MainWeapon1_HopupMulti_a
        navDown                 MainWeapon1

        xpos                    4
        ypos                    0
        zpos                    3
        cursorPriority          1

        pin_to_sibling          MainWeapon1_HopupMulti_a
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_RIGHT
    }

                 
               
     
                                         
                                                        

                           
                           

                                                   
                                              

                                 

                                  
                                                       
                                 
                                 

                                           
                                    
                                     
     
      

	BackpackGrid
	{
		ControlName				CNestedPanel
        ypos_nx_handheld		20			[$NX || $NX_UI_PC]
        xpos_nx_handheld		50			[$NX || $NX_UI_PC]

		wide					1000
        wide_nx_handheld		1143		[$NX || $NX_UI_PC]
		tall					220
		tall_nx_handheld		280			[$NX || $NX_UI_PC]
		visible					1
		enabled                 1
		tabPosition				1
		controlSettingsFile		"Resource/UI/menus/panels/survival_quick_inventory_grid.res"

        xpos                    0
        ypos                    50
        zpos                    2


        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   TOP
        pin_to_sibling_corner   CENTER
	}


    StowedWeaponAnchor
    {
        ControlName             ImagePanel
        visible				    0
        scaleImage				1
        image					"vgui/HUD/white"
        drawColor				"0 0 0 0"
        wide					320
        tall					140

        xpos                    500
        ypos                    -50

        pin_to_sibling          Backpack
        pin_corner_to_sibling   BOTTOM_LEFT
        pin_to_sibling_corner   BOTTOM_RIGHT
    }

    MainWeaponAnchor
    {
        ControlName             ImagePanel
        visible				    0
        scaleImage				1
        image					"vgui/HUD/white"
        drawColor				"0 0 0 0"
        wide					320
        tall					140

        xpos                    0
        ypos                    120

        pin_to_sibling          StowedWeaponAnchor
        pin_corner_to_sibling   BOTTOM
        pin_to_sibling_corner   TOP
    }

    MouseDropInventory
    {
        ControlName             RuiButton

        wide					840
        wide_nx_handheld		914			[$NX || $NX_UI_PC]
		tall					230
		tall_nx_handheld		280			[$NX || $NX_UI_PC]

        classname               "DropSlot"
        scriptID                "inventory"
        rui                     "ui/inventory_drop_slot.rpak"

        xpos                    0
        ypos                    -13
        zpos                    100

        visible                 0
        enabled                 0

        pin_to_sibling          BackpackGrid
        pin_corner_to_sibling   CENTER
        pin_to_sibling_corner   CENTER
    }

    InventoryBracketL
    {
        ControlName             RuiPanel

        wide					13
        wide_nx_handheld		17			[$NX || $NX_UI_PC]
		tall					240
		tall_nx_handheld		280			[$NX || $NX_UI_PC]

        rui                     "ui/basic_image.rpak"

        xpos                    10
        ypos                    -13
        ypos_nx_handheld        -26			[$NX || $NX_UI_PC]
        zpos                    0

        visible                 1
        enabled                 0
        scaleImage              1

        pin_to_sibling          BackpackGrid
        pin_corner_to_sibling   RIGHT
        pin_to_sibling_corner   LEFT
    }

    InventoryBracketR
    {
        ControlName             RuiPanel

        wide					13
        wide_nx_handheld		17			[$NX || $NX_UI_PC]
		tall					240
		tall_nx_handheld		280			[$NX || $NX_UI_PC]

        rui                     "ui/basic_image.rpak"

        xpos                    10
        ypos                    -13
        ypos_nx_handheld        -26			[$NX || $NX_UI_PC]
        zpos                    0

        visible                 1
        enabled                 0
        scaleImage              1

        pin_to_sibling          BackpackGrid
        pin_corner_to_sibling   LEFT
        pin_to_sibling_corner   RIGHT
    }

    BackerInventoryBG
    {
        ControlName             RuiPanel

        wide					816
        wide_nx_handheld		930			[$NX || $NX_UI_PC]
		tall					220
		tall_nx_handheld		280			[$NX || $NX_UI_PC]

        rui                     "ui/basic_image.rpak"

        xpos                    0
        ypos                    -13
        ypos_nx_handheld		-26			[$NX || $NX_UI_PC]
        zpos                    0

        visible                 1
        enabled                 0
        scaleImage              1

        pin_to_sibling          BackpackGrid
        pin_corner_to_sibling   CENTER
        pin_to_sibling_corner   CENTER
    }

    BackerInventory
    {
        ControlName             RuiPanel

        wide					440
        wide_nx_handheld		914			[$NX || $NX_UI_PC]
		tall					220
		tall_nx_handheld		280			[$NX || $NX_UI_PC]

        rui                     "ui/basic_masked_image.rpak"

        xpos                    0
        ypos                    0
        zpos                    0

        visible                 1
        enabled                 0
        scaleImage              1

        pin_to_sibling          BackerInventoryBG
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT
    }

    BackerInventory2
    {
        ControlName             RuiPanel

        wide					440
        wide_nx_handheld		914			[$NX || $NX_UI_PC]
		tall					220
		tall_nx_handheld		280			[$NX || $NX_UI_PC]

        rui                     "ui/basic_masked_image.rpak"

        xpos                    0
        ypos                    0
        zpos                    0

        visible                 1
        enabled                 0
        scaleImage              1

        pin_to_sibling          BackerInventoryBG
        pin_corner_to_sibling   BOTTOM_RIGHT
        pin_to_sibling_corner   BOTTOM_RIGHT
    }

    MouseDropMainWeapon0
    {
        ControlName             RuiButton

        wide					522
        wide_nx_handheld		663			[$NX || $NX_UI_PC]
        tall					302
        tall_nx_handheld		384			[$NX|| $NX_UI_PC]

        classname               "DropSlot"
        scriptID                "main_weapon0"
        rui                     "ui/inventory_drop_slot.rpak"

        xpos                    6
        ypos                    6
        zpos                    100

        visible                 0
        enabled                 0

        pin_to_sibling          MainWeapon0
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT
    }

    MouseDropMainWeapon1
    {
        ControlName             RuiButton

        wide					522
        wide_nx_handheld		663			[$NX || $NX_UI_PC]
        tall					302
        tall_nx_handheld		384			[$NX || $NX_UI_PC]

        classname               "DropSlot"
        scriptID                "main_weapon1"
        rui                     "ui/inventory_drop_slot.rpak"

        xpos                    6
        ypos                    6
        zpos                    100

        visible                 0
        enabled                 0

        pin_to_sibling          MainWeapon1
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT
    }

                 
                        
     
                                         

                    
                    

                                          
                                              
                                                             

                                 
                                 
                                   

                                 
                                 

                                           
                                        
                                        
     
      

    MouseDropGroundLeft
    {
        ControlName             RuiButton

        wide					250
        tall					f0

        classname               "DropSlot"
        scriptID                "ground"
        rui                     "ui/inventory_drop_slot.rpak"

        xpos                    0
        ypos                    0
        zpos                    100

        visible                 0
        enabled                 0

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT
    }

    MouseDropGroundRight
    {
        ControlName             RuiButton

        wide					250
        tall					f0

        classname               "DropSlot"
        scriptID                "ground"
        rui                     "ui/inventory_drop_slot.rpak"

        xpos                    0
        ypos                    0
        zpos                    100

        visible                 0
        enabled                 0

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   TOP_RIGHT
        pin_to_sibling_corner   TOP_RIGHT
    }

    PlayerInfo
    {
	    ControlName				RuiPanel
        ypos                    28
        ypos_nx_handheld        -20			[$NX || $NX_UI_PC]
		xpos                    50
        wide					468
        tall					91
        visible					1
        enabled 				1
        scaleImage				1
        rui                     "ui/inventory_player_info.rpak"
        zpos                    20

        pin_to_sibling						BackpackGrid
        pin_corner_to_sibling				TOP_RIGHT
        pin_to_sibling_corner				BOTTOM_LEFT
    }

    TeammateInfo1
    {
	    ControlName				RuiPanel

	    scriptID                1

        ypos                    50
        ypos_nx_handheld        35			[$NX || $NX_UI_PC]
        xpos                    0
        xpos_nx_handheld        100			[$NX || $NX_UI_PC]
        wide					440
        wide_nx_handheld		704			[$NX || $NX_UI_PC]
        tall					50
        tall_nx_handheld		80			[$NX || $NX_UI_PC]
        visible					1
        enabled 				1
        scaleImage				1
        rui                     "ui/unitframe_survival_inventory.rpak"
        zpos                    20

        pin_to_sibling			PlayerInfo
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

    TeammateInfo0
    {
	    ControlName				RuiPanel

	    scriptID                0

        ypos                    10
        ypos_nx_handheld        35			[$NX || $NX_UI_PC]
        xpos                    0
        wide					440
        wide_nx_handheld		704			[$NX|| $NX_UI_PC]
        tall					50
        tall_nx_handheld		80			[$NX|| $NX_UI_PC]
        visible					1
        enabled 				1
        scaleImage				1
        rui                     "ui/unitframe_survival_inventory.rpak"
        zpos                    20

        pin_to_sibling			TeammateInfo1
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

    PlayerUltimate
    {
                              
			ControlName				RuiButton
       
                            
                                    

        ypos                    17
        ypos_nx_handheld        40		[$NX || $NX_UI_PC]
        xpos                    80
        wide					130
        tall					109
        visible					1
        enabled 				1
        scaleImage				0
        rui                     "ui/inventory_ultimate_ability.rpak"
        zpos                    20

        pin_to_sibling			BackpackGrid
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_RIGHT
    }

    GearBracketL
    {
        ControlName             RuiPanel

        wide					13
        wide_nx_handheld		17			[$NX || $NX_UI_PC]
		tall					110
		tall_nx_handheld		140			[$NX || $NX_UI_PC ]

        rui                     "ui/basic_image.rpak"

        xpos                    10
        ypos                    -13
        zpos                    0

        visible                 1
        enabled                 0
        scaleImage              1

        pin_to_sibling          Helmet
        pin_corner_to_sibling   RIGHT
        pin_to_sibling_corner   LEFT
    }

    GearBracketR
    {
        ControlName             RuiPanel

        wide					13
        wide_nx_handheld		17			[$NX || $NX_UI_PC]
		tall					110
		tall_nx_handheld		140			[$NX|| $NX_UI_PC]

        rui                     "ui/basic_image.rpak"

        xpos                    10
        ypos                    -13
        zpos                    0

        visible                 1
        enabled                 0
        scaleImage              1

                  
                                         
     
		pin_to_sibling			BackPack
      
        pin_corner_to_sibling   LEFT
        pin_to_sibling_corner   RIGHT
    }
}

