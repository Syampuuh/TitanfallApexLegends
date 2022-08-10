
global function LoadoutSelectionMenu_InitLoadoutMenu
global function LoadoutSelectionMenu_RequestOpenLoadoutMenu
global function LoadoutSelectionMenu_OpenLoadoutMenu
global function LoadoutSelectionMenu_CloseLoadoutMenu
global function LoadoutSelectionMenu_IsLoadoutMenuOpen
global function LoadoutSelectionMenu_OnLoadoutSelectClick
global function LoadoutSelectionMenu_RefreshLoadouts
global function LoadoutSelectionMenu_GetLoadoutButtonByIndex
global function LoadoutSelectionMenu_GetWeaponElementByIndex
global function LoadoutSelectionMenu_ResetLoadoutButtons

const string LOADOUTSELECTIONMENU_LOADOUT_BUTTON = "LoadoutSelectButton"
const string LOADOUTSELECTIONMENU_LOADOUTWEAPON_BUTTON = "Loadout"
const int LOADOUTSSELECTIONMENU_LOADOUT_BUTTON_PADDING = 10
#if NX_PROG || PC_PROG_NX_UI
const int LOADOUTSSELECTIONMENU_LOADOUT_BUTTON_BASEOFFSET = -7
#else
const int LOADOUTSSELECTIONMENU_LOADOUT_BUTTON_BASEOFFSET = -90	
#endif

                          
                                                                                  
                                                                            
                                                                                   
                                                                             
                                

struct
{
	var menu
	bool isMouseMiddleRegistered = false
	int maxLoadoutCountRegular = -1
                           
                                  
                                   
                                 

	float menuOpenTime
	array <var> loadoutButtons
	array <var> loadoutWeaponElements
	table <var, var> loadoutWeaponElementToLoadoutButtonTable
	table <int, int> loadoutButtonIDToLoadoutIndex

	int focusedLoadout = -1
}
file

                           
                           
                           

void function LoadoutSelectionMenu_InitLoadoutMenu( var newMenuArg )
{
	                                                                                             
	if ( file.maxLoadoutCountRegular == -1 )
		file.maxLoadoutCountRegular = LOADOUTSELECTION_MAX_LOADOUT_COUNT_REGULAR

                           
                                           
                                                                             

                                            
                                                                               
                                 

	                             
	var menu = GetMenu( "LoadoutSelectionSystemLoadoutSelector" )
	file.menu = menu
	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, LoadoutSelectionMenu_OnLoadoutMenu_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, LoadoutSelectionMenu_OnLoadoutMenu_Hide )

	LoadoutSelectionMenu_ResetLoadoutButtons()

	AddMenuFooterOption( menu, LEFT, BUTTON_Y, false, "", "", LoadoutSelectionMenu_OnButtonYPress )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE", null )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, ControlLoadoutMenu_OnNavBack )
}

                                                                                                                  
bool function LoadoutSelectionMenu_IsLoadoutSelectionAvailable()
{
    bool isLoadoutSelectionAvailable = true

    if ( !IsFullyConnected() )
        return false

    if ( IsLobby() )
        return false

    if ( !IsUsingLoadoutSelectionSystem() )
        return false

    if ( GetGameState() < eGameState.Playing || GetGameState() > eGameState.WinnerDetermined )
        return false

    return isLoadoutSelectionAvailable
}

                                                                  
void function LoadoutSelectionMenu_OnLoadoutMenu_Show()
{
	if ( GetActiveMenu() != file.menu )
		return

	if ( !LoadoutSelectionMenu_IsLoadoutSelectionAvailable() )
		return
	LoadoutSelectionMenu_ResetLoadoutButtons()

	UpdateLoadouts()

	if ( !file.isMouseMiddleRegistered )
	{
		RegisterButtonPressedCallback( MOUSE_MIDDLE, LoadoutSelectionMenu_OnButtonYPress )
		file.isMouseMiddleRegistered = true
	}
	else
	{
		Warning( "LoadoutSelectionMenu_OnLoadoutMenu_Show - MOUSE_MIDDLE callback already registered" )
	}
}

void function LoadoutSelectionMenu_OnLoadoutMenu_Hide()
{
	if ( file.isMouseMiddleRegistered )
	{
		DeregisterButtonPressedCallback( MOUSE_MIDDLE, LoadoutSelectionMenu_OnButtonYPress )
		file.isMouseMiddleRegistered = false
	}
	else
	{
		Warning( "LoadoutSelectionMenu_OnLoadoutMenu_Hide - MOUSE_MIDDLE callback not registered" )
	}
}

                           
                           
                           

void function UpdateLoadouts()
{
	LoadoutSelectionMenu_RefreshLoadouts( file.maxLoadoutCountRegular, eLoadoutSelectionSlotType.REGULAR )

                           
                                                                                                          
                                                                                                            
                                 
}


                                                                                  
void function LoadoutSelectionMenu_RefreshLoadouts( int maxLoadouts, int loadoutSlotType )
{
	LoadoutSelectionMenu_UpdateMaxLoadoutCount( maxLoadouts, loadoutSlotType )
	int loadoutCount = LoadoutSelectionMenu_GetStoredMaxLoadoutCountForLoadoutSlot( loadoutSlotType )
	var firstLoadoutButton
	for ( int index = 0; index < loadoutCount; index++ )
	{
		var loadoutButton = Hud_GetChild( file.menu, LoadoutSelectionMenu_GetLoadoutButtonPrefix( loadoutSlotType ) + index )
		int loadoutIndex = LoadoutSelectionMenu_GetLoadoutIndexFromLoadoutButton( loadoutButton )

		string localizedHeader = LoadoutSelection_GetLocalizedLoadoutHeader( loadoutIndex )

		if( index == 0 )
			firstLoadoutButton = loadoutButton

		var rui = Hud_GetRui( loadoutButton )
		RuiSetString( rui, "name", localizedHeader )
		RuiSetBool( rui, "isEquipped", LoadoutSelection_GetSelectedLoadoutSlotIndex_UI() == loadoutIndex )

		                                                                                                    
		                                                                    

		                                                                                                 
		LoadoutSelectionMenu_UpdateWeaponElementsForLoadout( index, loadoutIndex, loadoutSlotType )

		                                                        
		for ( int consumableIndex = 0; consumableIndex < LOADOUTSELECTION_MAX_CONSUMABLES_PER_LOADOUT; consumableIndex++ )
		{
			var consumableIcon = Hud_GetChild( file.menu, LoadoutSelectionMenu_GetWeaponButtonPrefix( loadoutSlotType ) + index + "IconItem" + consumableIndex )
			RunClientScript( "UICallback_LoadoutSelection_BindItemIcon", consumableIcon, loadoutIndex, -1, consumableIndex )
		}

		if ( loadoutSlotType == eLoadoutSelectionSlotType.REGULAR )
		{
			if( index > 0 )
			{
				var previousLoadoutButton = Hud_GetChild( file.menu, LoadoutSelectionMenu_GetLoadoutButtonPrefix( loadoutSlotType ) + ( index - 1 ) )
				Hud_SetNavLeft( loadoutButton, previousLoadoutButton )
			}

			if( index < 5 && index < loadoutCount - 1 )
			{
				var nextLoadoutButton = Hud_GetChild( file.menu, LoadoutSelectionMenu_GetLoadoutButtonPrefix( loadoutSlotType ) + ( index + 1 ) )
				Hud_SetNavRight( loadoutButton, nextLoadoutButton )
			}
		}
	}

	if ( loadoutSlotType == eLoadoutSelectionSlotType.REGULAR && firstLoadoutButton != null )
	{
		float diff = float( LOADOUTSELECTION_MAX_LOADOUT_COUNT_REGULAR - loadoutCount )
		float sizePer = float( Hud_GetWidth( firstLoadoutButton ) )

		float offset = (diff / 2.0) * sizePer
		float offsetPadding = (diff > 0.0)? (	(diff / 2.0) * LOADOUTSSELECTIONMENU_LOADOUT_BUTTON_PADDING ): 0.0
		
		Hud_SetX( firstLoadoutButton, LOADOUTSSELECTIONMENU_LOADOUT_BUTTON_BASEOFFSET + ( -1.0 * (offset + offsetPadding)) )
	}
}

void function UpdateFocusedLoadoutButtonGroups()
{
	UpdateFocusedLoadout( eLoadoutSelectionSlotType.REGULAR )

                           
                                                      
                                                             

                                                       
                                                              
                                 
}

void function UpdateFocusedLoadout( int loadoutSlotType )
{
	int loadoutCount = LoadoutSelectionMenu_GetStoredMaxLoadoutCountForLoadoutSlot( loadoutSlotType )

	for ( int index = 0; index < loadoutCount; index++ )
	{
		var loadoutButton = Hud_GetChild( file.menu, LoadoutSelectionMenu_GetLoadoutButtonPrefix( loadoutSlotType ) + index )
		int loadoutIndex = LoadoutSelectionMenu_GetLoadoutIndexFromLoadoutButton( loadoutButton )

		var rui = Hud_GetRui( loadoutButton )
	}
}

                                                                                                                
void function LoadoutSelectionMenu_UpdateMaxLoadoutCount( int maxLoadouts, int loadoutType )
{
	bool shouldUpdateMaxVal = maxLoadouts != file.maxLoadoutCountRegular ? true : false

                           
                                                                                                            
                                                                                  

                                                                                                             
                                                                                   
                                 

	if ( shouldUpdateMaxVal )
	{
		                                                                
		int loadoutButtonCount = LoadoutSelectionMenu_GetLoadoutButtonCountByLoadoutSlotType( loadoutType )

		if ( loadoutType != eLoadoutSelectionSlotType.REGULAR )
		{
                             
                                                                                                              
                                               

                                                                                                               
                                                
                                   

		}
		else
		{
			file.maxLoadoutCountRegular = maxLoadouts
		}

		                                                                                    
		if ( loadoutButtonCount != maxLoadouts )
			LoadoutSelectionMenu_ResetLoadoutButtons()
	}
}

                                                                                                                    
                                                                                                          
void function LoadoutSelectionMenu_ResetLoadoutButtons()
{
	LoadoutSelectionMenu_RemoveAllButtons()

	int loadoutSlotIndex = 0
                           
                                  
                                   
                                 

	                                     
	for ( int i = 0; i < LOADOUTSELECTION_MAX_TOTAL_LOADOUT_SLOTS; i++ )
	{
		int loadoutSlotType = LoadoutSelection_GetLoadoutSlotTypeForLoadoutIndex( i )

		if ( loadoutSlotType == eLoadoutSelectionSlotType.INVALID )
		{
			continue
		}
		else if ( loadoutSlotType == eLoadoutSelectionSlotType.REGULAR )
		{
			LoadoutSelectionMenu_SetupLoadoutButton( loadoutSlotIndex, i, loadoutSlotType )
			loadoutSlotIndex++
		}
                           
                                                                                                                    
   
                                                                                          
                             
   
                                                                                                                      
   
                                                                                           
                              
   
                                 
	}
}

                                                
void function LoadoutSelectionMenu_RemoveAllButtons()
{
	                             
	array< var > loadoutButtons = clone file.loadoutButtons
	foreach ( var loadoutButton in loadoutButtons )
	{
		                                   
		Hud_RemoveEventHandler( loadoutButton, UIE_CLICK, LoadoutSelectionMenu_OnLoadoutSelectClick )
		Hud_SetVisible( loadoutButton, false )
		if ( file.loadoutButtons.contains( loadoutButton ) )
			file.loadoutButtons.removebyvalue( loadoutButton )

		int loadoutButtonScriptId = int( Hud_GetScriptID( loadoutButton ) )
		if ( loadoutButtonScriptId in file.loadoutButtonIDToLoadoutIndex )
			delete file.loadoutButtonIDToLoadoutIndex[ loadoutButtonScriptId ]
	}

	                             
	array< var > loadoutWeaponElements = clone file.loadoutWeaponElements
	foreach ( var weaponElement in loadoutWeaponElements )
	{
		Hud_SetVisible( weaponElement, false )
		file.loadoutWeaponElements.removebyvalue( weaponElement )

		if ( weaponElement in file.loadoutWeaponElementToLoadoutButtonTable )
			delete file.loadoutWeaponElementToLoadoutButtonTable[ weaponElement ]
	}
}

                                             
void function LoadoutSelectionMenu_SetupLoadoutButton( int index, int loadoutIndex, int loadoutSlotType )
{
	                                                                                                     
	int maxLoadouts = LoadoutSelectionMenu_GetStoredMaxLoadoutCountForLoadoutSlot( loadoutSlotType )
	if ( index >= maxLoadouts )
		return

	var loadoutButton = Hud_GetChild( file.menu, LoadoutSelectionMenu_GetLoadoutButtonPrefix( loadoutSlotType ) + index )
	Hud_AddEventHandler( loadoutButton, UIE_CLICK, LoadoutSelectionMenu_OnLoadoutSelectClick )
	file.loadoutButtons.append( loadoutButton )
	file.loadoutButtonIDToLoadoutIndex[ int( Hud_GetScriptID( loadoutButton ) ) ] <- loadoutIndex
	Hud_SetVisible( loadoutButton, true )


	for ( int j = 0; j < LOADOUTSELECTION_MAX_WEAPONS_PER_LOADOUT; j++ )
	{
		var loadoutWeaponElement = Hud_GetChild( file.menu, LoadoutSelectionMenu_GetWeaponButtonPrefix( loadoutSlotType ) + index + "Weapon" + j )

		file.loadoutWeaponElements.append( loadoutWeaponElement )
		file.loadoutWeaponElementToLoadoutButtonTable[ loadoutWeaponElement ] <- loadoutButton
		Hud_SetVisible( loadoutWeaponElement, true )
	}
}

                                                                                                            
void function LoadoutSelectionMenu_OnLoadoutSelectClick( var button )
{
	if ( GetActiveMenu() != file.menu )
		return

	int loadoutIndex
	                                                                                                                                                                                               
	if ( button in file.loadoutWeaponElementToLoadoutButtonTable )
	{
		loadoutIndex = LoadoutSelectionMenu_GetLoadoutIndexFromLoadoutButton( file.loadoutWeaponElementToLoadoutButtonTable[ button ] )
	}
	else
	{
		loadoutIndex = LoadoutSelectionMenu_GetLoadoutIndexFromLoadoutButton( button )
	}

	if ( IsUsingLoadoutSelectionSystem() )
		Remote_ServerCallFunction( "ClientCallback_LoadoutSelection_OnLoadoutSelectMenuLoadoutSelected", loadoutIndex )

	LoadoutSelectionMenu_CloseLoadoutMenu()
}

                           
                           
                           

                                                                                           
void function LoadoutSelectionMenu_UpdateWeaponElementsForLoadout( int index, int loadoutIndex, int loadoutSlotType )
{
	int weaponCountForLoadout = LoadoutSelection_GetWeaponCountByLoadoutIndex( loadoutIndex )

	for ( int weaponIndex = 0; weaponIndex < LOADOUTSELECTION_MAX_WEAPONS_PER_LOADOUT; weaponIndex++ )
	{
		if ( weaponIndex < weaponCountForLoadout )
		{
			                                                                                     
			var weaponButton = Hud_GetChild( file.menu, LoadoutSelectionMenu_GetWeaponButtonPrefix( loadoutSlotType ) + index + "Weapon" + weaponIndex )
			RunClientScript( "UICallback_LoadoutSelection_BindWeaponRui", weaponButton, loadoutIndex, weaponIndex )
		}
		else
		{
			                           
			LoadoutSelectionMenu_RemoveWeaponElement( index, weaponIndex, loadoutSlotType )
		}
	}
}

                                     
void function LoadoutSelectionMenu_RemoveWeaponElement( int index, int weaponIndex, int loadoutSlotType )
{
	var loadoutWeaponElement = Hud_GetChild( file.menu, LoadoutSelectionMenu_GetWeaponButtonPrefix( loadoutSlotType ) + index + "Weapon" + weaponIndex )
	if ( !( file.loadoutWeaponElements.contains( loadoutWeaponElement ) ) )
		return

	Hud_SetVisible( loadoutWeaponElement, false )
	file.loadoutWeaponElements.removebyvalue( loadoutWeaponElement )

	if ( loadoutWeaponElement in file.loadoutWeaponElementToLoadoutButtonTable )
		delete file.loadoutWeaponElementToLoadoutButtonTable[ loadoutWeaponElement ]
}

                                                        
var function LoadoutSelectionMenu_GetWeaponElementByIndex( int loadoutIndex, int weaponIndex )
{
	var weaponElement = null
	int loadoutSlotType = LoadoutSelection_GetLoadoutSlotTypeForLoadoutIndex( loadoutIndex )
	int loadoutSlotIndex = 0

	for ( int index = 0; index < loadoutIndex; index++ )
	{
		int currentSlotType  = LoadoutSelection_GetLoadoutSlotTypeForLoadoutIndex( index )
		if ( currentSlotType == loadoutSlotType )
			loadoutSlotIndex++
	}

	if ( loadoutSlotIndex < LoadoutSelectionMenu_GetLoadoutButtonCountByLoadoutSlotType( loadoutSlotType ) && loadoutSlotIndex >= 0 && weaponIndex >= 0 && weaponIndex < LOADOUTSELECTION_MAX_WEAPONS_PER_LOADOUT )
		weaponElement = Hud_GetChild( file.menu, LoadoutSelectionMenu_GetWeaponButtonPrefix( loadoutSlotType ) + loadoutSlotIndex + "Weapon" + weaponIndex )

	return weaponElement
}

                                                        
var function LoadoutSelectionMenu_GetLoadoutButtonByIndex( int loadoutIndex )
{
	var loadoutButton = null
	int loadoutSlotType = LoadoutSelection_GetLoadoutSlotTypeForLoadoutIndex( loadoutIndex )
	int loadoutSlotIndex = 0

	for ( int index = 0; index < loadoutIndex; index++ )
	{
		int currentSlotType  = LoadoutSelection_GetLoadoutSlotTypeForLoadoutIndex( index )
		if ( currentSlotType == loadoutSlotType )
			loadoutSlotIndex++
	}

	if ( loadoutSlotIndex < LoadoutSelectionMenu_GetLoadoutButtonCountByLoadoutSlotType( loadoutSlotType ) && loadoutSlotIndex >= 0)
		loadoutButton = Hud_GetChild( file.menu, LoadoutSelectionMenu_GetLoadoutButtonPrefix( loadoutSlotType ) + loadoutSlotIndex )

	return loadoutButton
}

                           
                           
                           

                                                                                                                                   
void function LoadoutSelectionMenu_RequestOpenLoadoutMenu( var button )
{
	LoadoutSelectionMenu_OpenLoadoutMenu( false )
}

                       
void function LoadoutSelectionMenu_OpenLoadoutMenu( bool isBrowseMode )
{
    if ( !LoadoutSelectionMenu_IsLoadoutSelectionAvailable() )
        return
	
	if ( GetActiveMenu() != file.menu && MenuStack_GetLength() != 0 && !isBrowseMode )
		CloseActiveMenu()

	if ( !MenuStack_Contains( file.menu ) )
	{
		AdvanceMenu( file.menu )
		file.menuOpenTime = UITime()
	}
#if NX_PROG
	SetConVarBool( "nx_is_control_spawn_menu_open", true )
#endif
	
}

                         
void function LoadoutSelectionMenu_CloseLoadoutMenu()
{
	if ( LoadoutSelectionMenu_IsLoadoutSelectionAvailable() )
		ClientToUI_LoadoutSelectionOptics_CloseSelectOpticDialog()

	if ( GetActiveMenu() == file.menu )
	{
		CloseActiveMenu()
	}
	else if ( MenuStack_Contains( file.menu ) )
	{
		MenuStack_Remove( file.menu )
	}

	if ( LoadoutSelectionMenu_IsLoadoutSelectionAvailable() )
	{
		Remote_ServerCallFunction( "ClientCallback_LoadoutSelection_OnLoadoutSelectMenuClose" )

		if ( CanRunClientScript() && Control_IsModeEnabled() )
			RunClientScript( "UICallback_Control_Loadouts_OnClosed" )
	}
}

bool function LoadoutSelectionMenu_IsLoadoutMenuOpen()
{
	if ( MenuStack_Contains( file.menu ) )
		return true

	return false
}

                                                 
void function ControlLoadoutMenu_OnNavBack()
{
	LoadoutSelectionMenu_CloseLoadoutMenu()
}


                           
                           
                           

                                                                
void function LoadoutSelectionMenu_OnButtonYPress( var menu )
{
	var focusButton = GetFocus()
	if ( file.loadoutButtons.contains( focusButton ) )
		LoadoutSelectionMenu_OpenScopeMenu( focusButton )
}

                                                                                                                                                  
void function LoadoutSelectionMenu_OpenScopeMenu( var button )
{
	if ( GetActiveMenu() != file.menu )
		return

    if ( !LoadoutSelectionMenu_IsLoadoutSelectionAvailable() )
        return

	if ( file.loadoutButtons.contains( button ) )
	{
		int loadoutIndex = LoadoutSelectionMenu_GetLoadoutIndexFromLoadoutButton( button )

		                                                       
		RunClientScript( "UICallback_LoadoutSelection_OnRequestOpenScopeSelection", button, loadoutIndex )
	}
}



                           
                           
                           

                                
string function LoadoutSelectionMenu_GetLoadoutButtonPrefix( int loadoutSlotType )
{
	string prefix = ""

	switch ( loadoutSlotType )
	{
		case eLoadoutSelectionSlotType.REGULAR:
			prefix = LOADOUTSELECTIONMENU_LOADOUT_BUTTON
			break
                           
                                          
                                                       
        
                                           
                                                        
        
                                 

		default:
			break
	}

	return prefix
}

                               
string function LoadoutSelectionMenu_GetWeaponButtonPrefix( int loadoutSlotType )
{
	string prefix = ""

	switch ( loadoutSlotType )
	{
		case eLoadoutSelectionSlotType.REGULAR:
			prefix = LOADOUTSELECTIONMENU_LOADOUTWEAPON_BUTTON
			break
                           
                                          
                                                             
        
                                           
                                                              
        
                                 
		default:
			break
	}

	return prefix
}

                                                                                          
int function LoadoutSelectionMenu_GetLoadoutIndexFromLoadoutButton( var button )
{
	int loadoutIndex = -1
	int loadoutButtonScriptID = int( Hud_GetScriptID( button ) )
	if ( loadoutButtonScriptID in file.loadoutButtonIDToLoadoutIndex )
		loadoutIndex = file.loadoutButtonIDToLoadoutIndex[ loadoutButtonScriptID ]

	return loadoutIndex
}

                                                    
int function LoadoutSelectionMenu_GetStoredMaxLoadoutCountForLoadoutSlot( int loadoutSlotType )
{
	int loadoutCount = file.maxLoadoutCountRegular

                           
                            
   
                                           
                                               
         
                                            
                                                
         
           
         
   
                                 

	return loadoutCount
}

                                                      
int function LoadoutSelectionMenu_GetLoadoutButtonCountByLoadoutSlotType( int loadoutSlotType )
{
	int count = 0
	for ( int index = 0; index < file.loadoutButtons.len(); index++ )
	{
		if ( LoadoutSelection_GetLoadoutSlotTypeForLoadoutIndex( index ) == loadoutSlotType )
			count++
	}
	return count
}