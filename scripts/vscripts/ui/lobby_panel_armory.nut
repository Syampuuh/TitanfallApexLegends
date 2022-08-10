global function InitArmoryPanel

struct
{
	var                       panel
	array<var>                allButtons
	array<var>                weaponCategoryButtons
	table<var, ItemFlavor>    buttonToCategory

                
                   
                      
	var miscCustomizeButton
} file


void function InitArmoryPanel( var panel )
{
	file.panel = panel
	file.weaponCategoryButtons = GetPanelElementsByClassname( panel, "WeaponCategoryButtonClass" )
	Assert( file.weaponCategoryButtons.len() == 7 )

	SetPanelTabTitle( panel, "#LOADOUT" )
	Hud_SetY( file.weaponCategoryButtons[0], 120 )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, ArmoryPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, ArmoryPanel_OnHide )
	AddPanelEventHandler_FocusChanged( panel, ArmoryPanel_OnFocusChanged )

	foreach ( button in file.weaponCategoryButtons )
	{
		Hud_AddEventHandler( button, UIE_GET_FOCUS, CategoryButton_OnGetFocus )
		Hud_AddEventHandler( button, UIE_CLICK, CategoryButton_OnActivate )
	}

	file.allButtons = clone( file.weaponCategoryButtons )

                
                                                              
                                                                                 
                                              
                      

	file.miscCustomizeButton = Hud_GetChild( panel, "MiscCustomizeButton" )
	Hud_AddEventHandler( file.miscCustomizeButton, UIE_CLICK, MiscCustomizeButton_OnActivate )
	file.allButtons.append( file.miscCustomizeButton )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_Y, true, "#BUTTON_MARK_ALL_AS_SEEN_GAMEPAD", "#BUTTON_MARK_ALL_AS_SEEN_MOUSE", MarkAllArmoryItemsAsViewed, ButtonNotFocused )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_SELECT", "", null, IsButtonFocused )
}


bool function IsButtonFocused()
{
	if ( file.allButtons.contains( GetFocus() ) )
		return true

	return false
}


bool function ButtonNotFocused()
{
	return !IsButtonFocused()
}


void function ArmoryPanel_OnShow( var panel )
{
	file.buttonToCategory.clear()

	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )

	array<ItemFlavor> categories = GetAllWeaponCategories()

	foreach ( index, button in file.weaponCategoryButtons )
		CategoryButton_Init( button, categories[index] )

                
                                           
                      
	MiscCustomizeButton_Init( file.miscCustomizeButton )
}


void function ArmoryPanel_OnHide( var panel )
{
	if ( NEWNESS_QUERIES.isValid )
	{
		foreach ( var button, ItemFlavor category in file.buttonToCategory )
		{
			if ( category in NEWNESS_QUERIES.WeaponCategoryButton )                                                    
				Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.WeaponCategoryButton[ category ], OnNewnessQueryChangedUpdateButton, button )
		}
	}

                
                                                                                                                                  
                      
	Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.GameCustomizationButton, OnNewnessQueryChangedUpdateButton, file.miscCustomizeButton )

	file.buttonToCategory.clear()
}


void function ArmoryPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) )                  
		return

	if ( !newFocus || GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()
}


void function CategoryButton_Init( var button, ItemFlavor category )
{
	                                                                                                       
	                             

	var rui = Hud_GetRui( button )
	RuiSetString( rui, "buttonText", Localize( ItemFlavor_GetLongName( category ) ).toupper() )
	RuiSetImage( rui, "buttonImage", ItemFlavor_GetIcon( category ) )
	RuiSetInt( rui, "numPips", GetWeaponsInCategory( category ).len() )

	file.buttonToCategory[button] <- category

	Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.WeaponCategoryButton[ category ], OnNewnessQueryChangedUpdateButton, button )
}


                
                                               
 
                               
                                                                     
                                                                                        
                               

                                                                                                                            
 
                      


void function MiscCustomizeButton_Init( var button )
{
	                                                                                                
	                   

	var rui = Hud_GetRui( button )
	RuiSetString( rui, "buttonText", Localize( "#MISC_CUSTOMIZATION" ).toupper() )
	RuiSetImage( rui, "buttonImage", $"rui/menu/buttons/weapon_categories/icons_misc" )
	RuiSetInt( rui, "numPips", 3 )

	Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.GameCustomizationButton, OnNewnessQueryChangedUpdateButton, button )
}


void function MarkAllArmoryItemsAsViewed( var button )
{
	bool weaponMarkSuccess = MarkAllItemsOfTypeAsViewed( eItemTypeUICategory.WEAPON_LOADOUT )
	bool miscMarkSuccess = MarkAllItemsOfTypeAsViewed( eItemTypeUICategory.MISC_LOADOUT )

	if ( weaponMarkSuccess || miscMarkSuccess )
		EmitUISound( "UI_Menu_Accept" )
	else
		EmitUISound( "UI_Menu_Deny" )
}


void function CategoryButton_OnGetFocus( var button )
{
	if ( !( button in file.buttonToCategory ) )
		return

	ItemFlavor category = file.buttonToCategory[button]

	printt( ItemFlavor_GetHumanReadableRef( category ) )
}


void function CategoryButton_OnActivate( var button )
{
	if ( !( button in file.buttonToCategory ) )
		return

	ItemFlavor category = file.buttonToCategory[button]
	SetTopLevelCustomizeContext( category )

	AdvanceMenu( GetMenu( "CustomizeWeaponMenu" ) )
}

                
                                                     
 
                                                                                                                                                                  
                                         

                                                     
 
                      


void function MiscCustomizeButton_OnActivate( var button )
{
	AdvanceMenu( GetMenu( "MiscCustomizeMenu" ) )
}
