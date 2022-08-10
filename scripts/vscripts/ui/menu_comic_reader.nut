#if CLIENT
global function UIToClient_LoadPanelImages
global function UIToClient_ReleaseAllLoadedPakHandles
global function UIToClient_SetPanelImage
global function ClInitComicReaderMenu
#endif

#if UI
global function InitComicReaderMenu
global function ComicReaderMenu_OpenTo
                                                        
                                              
#if DEV
global function ComicReaderMenu_TestOpen
global function ComicReaderMenu_ReloadCurrent
#endif       



const int[10] CONTINUE_BUTTONS = [BUTTON_A, BUTTON_SHOULDER_RIGHT, MOUSE_LEFT, MOUSE_WHEEL_DOWN, KEY_SPACE, KEY_RIGHT, KEY_DOWN, STICK1_RIGHT, BUTTON_DPAD_DOWN, BUTTON_DPAD_RIGHT]
const int[9] PREV_BUTTONS = [BUTTON_SHOULDER_LEFT, MOUSE_RIGHT, MOUSE_WHEEL_UP, KEY_LEFT, KEY_UP, STICK1_LEFT, BUTTON_DPAD_UP, BUTTON_DPAD_LEFT, BUTTON_X]

const int QUEUE_CLEAR = 0
const int QUEUE_FORWARD = 1
const int QUEUE_BACKWARD = 2
const float PANEL_TRANSITION_DURATION = 1.0                                        
const float PANEL_TRANSITION_BLOCK_TIME = 0.5                                        
const float PANEL_FADE_IN_BLOCK = 1.5                                                                     
const float CLOSE_READER_WAIT_TIME = 1.0                                                                                  

const int MAX_DIALOGUE_LINES = 7
const int NUM_READER_PANELS = 4

                                                                
enum eBubbleType
{
	TOP_LEFT,   
	TOP_RIGHT,   
	BOTTOM_LEFT,   
	BOTTOM_RIGHT,   
	TOP,   
	BOTTOM,   
	HEADER,                                  
	LEFT,   
	RIGHT,   
	LOCATION,   
	RADIO,   
	NARATOR,                                                 
	SFX,                                            
	_count
}

enum eSoundTiming
{
	PAGE_OPEN,
	_count
}

global struct BubbleDialogue
{
	string dialogue
	float  offsetX
	float  offsetY
	int    width
	int    height
	int    bubbleType
	bool   hideTail
	float  placementFrac
	float  tailScale = 1.0
	               
}

global struct ComicPanel
{
	asset                 panelImage
	int                   imageWidth
	int                   imageHeight
	float				  offsetX
	float				  offsetY
	array<BubbleDialogue> bubbleDialogueArray
	bool                  isTitle
	int				  	  groupId

	int   borderWidth
	int   borderHeight
	float borderOffsetX
	float borderOffsetY

	struct
	{
		string ambientTrack
		string musicTrack

		array<string>[eSoundTiming._count] playSounds
		array<string>                      stopSounds

		string[eSoundTiming._count] playLoopingSoundA
		string[eSoundTiming._count] playLoopingSoundB
		string[eSoundTiming._count] playLoopingSoundC
		bool                        doStopLoopingSoundA
		bool                        doStopLoopingSoundB
		bool                        doStopLoopingSoundC
	} sounds

	int pageID = -1
	int panelID = -1
}

global struct ReaderRui
{
	var  rui
	int  panelIndex = -1
	bool isTransitioningOut = false
}
#endif     

struct
{
	#if UI
		array<ReaderRui>	readerRuis
		var                 backgroundRui
		table<var, var>     ruiToElementMap
		table<int, int>     s_panelsForPage
		array<ComicPanel>   s_panels
		var                 s_menu

		                                                                          
		                                                                                                 
		ItemFlavor quest
		int        pageIndex

		bool  s_registeredButtons = false
		float s_openedTime = 0.0

		array<asset>       s_arrayOfDataToLoadOnOpen
		int                s_startPageIndex
		int                s_startPanelIndex
		bool               s_comicComplet
		void functionref() s_onNavigatingBackFunc = null

		int   s_screenOpenNumber = -1
		int   s_panelIndex
		bool  s_transition
		float s_transitionStartTime
		int   s_transitionQueue = QUEUE_CLEAR

		                
		float pin_viewStartTime

		#if DEV
			bool                  panelEditMode = false
			bool                  panelEditModeRegistered = false
			int                   panelEdit_currentLineIndex = 0
			array<BubbleDialogue> panelEdit_data
		#endif

	#endif     

	#if CLIENT
		                             
		table<int, PakHandle> pakHandles
	#endif         

} file

#if CLIENT
void function ClInitComicReaderMenu()
{
	RegisterSignal( "LoadPanelTitle" )
	RegisterSignal( "StopWaitingForPakLoad" )
}
#endif         



#if UI
void function InitComicReaderMenu( var newMenuArg )
{
	var menu = newMenuArg
	Hud_SetAboveBlur( menu, true )
	file.s_menu = menu

	SetGamepadCursorEnabled( menu, false )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnMenuOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnMenuClose )

	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnMenuShow )
	AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, OnMenuHide )

	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnNavigateBack )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_NEXT", "#A_BUTTON_NEXT" )
	AddMenuFooterOption( menu, LEFT, BUTTON_X, true, "#X_BUTTON_PREVIOUS", "#X_BUTTON_PREVIOUS", null, HasPreviousPanel )

	#if DEV
		AddMenuFooterOption( menu, LEFT, BUTTON_STICK_RIGHT, true, "EDIT MODE", "EDIT MODE", TggleEditMode )
	#endif
}


void function OnMenuOpen()
{

}


void function OnMenuShow()
{
	SetBlurEnabled( true )
	file.s_openedTime = UITime()

	UI_SetPresentationType( ePresentationType.BATTLE_PASS_3 )
	RunClientScript( "ClearBattlePassItem" )

	RegisterButtons()

	InitPagesForMenuOpen()

	UpdateFooterOptions()
}

array<int> EDIT_BUTTONS = [ KEY_LEFT, KEY_UP, KEY_DOWN, KEY_RIGHT, KEY_SPACE, KEY_TAB, KEY_BACKSPACE ]

void function RegisterButtons()
{
	if ( !file.s_registeredButtons )
	{
		#if DEV
			if ( file.panelEditMode && !file.panelEditModeRegistered )
			{
				file.panelEditModeRegistered = true

				foreach ( int buttonId in EDIT_BUTTONS )
				{
					RegisterButtonPressedCallback( buttonId, void function( var button ) : ( buttonId )
					{
						OnEditButtonPressed( button, buttonId )
					} )
				}
			}
		#endif

		foreach ( button in CONTINUE_BUTTONS )
		{
			#if DEV
				if ( file.panelEditMode )
				{
					if ( EDIT_BUTTONS.contains( button ) )
						continue
				}
			#endif

			RegisterButtonPressedCallback( button, OnPressedNext )
		}
		foreach ( button in PREV_BUTTONS )
		{
			#if DEV
				if ( file.panelEditMode )
				{
					if ( EDIT_BUTTONS.contains( button ) )
						continue
				}
			#endif

			RegisterButtonPressedCallback( button, OnPressedPrevious )
		}
		file.s_registeredButtons = true
	}
}

void function ComicReaderMenu_OpenTo( array<asset> dtAssetArray, int startPageIndex, int panelIndex = 0, bool complete = false )
{
	file.s_arrayOfDataToLoadOnOpen = dtAssetArray
	file.s_startPageIndex = startPageIndex
	file.s_startPanelIndex = panelIndex
	file.s_comicComplet = complete
	                                    
	AdvanceMenu( file.s_menu )
}

bool function HasPreviousPanel()
{
	return file.s_panelIndex != 0
}

ReaderRui function GetTopReaderRui()
{
	Assert( file.readerRuis.len() > 0 )

	int topPanelIndex = -1
	for ( int i = 0; i < file.readerRuis.len(); ++i )
	{
		if ( topPanelIndex == -1 ||
		     file.readerRuis[i].panelIndex > file.readerRuis[topPanelIndex].panelIndex )
		{
			topPanelIndex = i;
		}
	}

	return file.readerRuis[topPanelIndex]
}

array<ReaderRui> function GetAvailableReaderRuis()
{
	Assert( file.readerRuis.len() > 0 )
	
	array<ReaderRui> ret

	for ( int i = 0; i < file.readerRuis.len(); ++i )
	{
		if ( file.readerRuis[i].panelIndex == -1 )
		{
			ret.append( file.readerRuis[i] )
		}
	}

	return ret
}

void function UpdateReaderRuiZOrders()
{
	                                                    
	file.readerRuis.sort( int function( ReaderRui a, ReaderRui b ) : ()
	{
		if ( a.panelIndex > b.panelIndex )
		{
			return 1
		}
		else if ( a.panelIndex < b.panelIndex )
		{
			return -1
		}

		return 0
	} )

	for ( int i = 0; i < file.readerRuis.len(); ++i )
	{
		var panelElement = file.ruiToElementMap[ file.readerRuis[i].rui ]
		Hud_SetZ( panelElement, i )
	}
}

                                                                                                                
   
  	                                 
  	                                                  
  	                          
   

#if DEV
asset function CastStringToAsset( string val )
{
	return GetKeyValueAsAsset( { kn = val }, "kn" )
}
void function ComicReaderMenu_TestOpen( string seqPathName, int panelIndex = 0 )
{
	CloseAllMenus()
	string assetPath = format( "datatable/comic/%s.rpak", seqPathName )

	file.panelEditMode = true

	ComicReaderMenu_OpenTo( [CastStringToAsset( assetPath )], 0, panelIndex )
}
void function ComicReaderMenu_ReloadCurrent()
{
	CloseAllMenus()
	AdvanceMenu( file.s_menu )
}
#endif       


void function OnMenuClose()
{
	if ( s_latestAmbientTrack.len() > 0 )
		StopUISound( s_latestAmbientTrack )

	for ( int idx = 0; idx < s_latestLoopingTracks.len(); ++idx )
	{
		if ( s_latestLoopingTracks[idx].len() > 0 )
			StopUISound( s_latestLoopingTracks[idx] )
	}

	ComicPanel panel = file.s_panels[ file.s_panelIndex ]
	AddComicPinEvent( -1, -1, panel.pageID, panel.panelID )

	CancelCustomUIMusic()

	                          
	RunClientScript( "UIToClient_ReleaseAllLoadedPakHandles" )

                           
                                                  
                                     
      
}


void function OnMenuHide()
{
	DeregisterButtons()
}

void function DeregisterButtons()
{
	if ( file.s_registeredButtons )
	{
		foreach ( button in CONTINUE_BUTTONS )
		{
			#if DEV
				if ( file.panelEditMode )
				{
					if ( EDIT_BUTTONS.contains( button ) )
						continue
				}
			#endif

			DeregisterButtonPressedCallback( button, OnPressedNext )
		}
		foreach ( button in PREV_BUTTONS )
		{
			#if DEV
				if ( file.panelEditMode )
				{
					if ( EDIT_BUTTONS.contains( button ) )
						continue
				}
			#endif

			DeregisterButtonPressedCallback( button, OnPressedPrevious )
		}
		file.s_registeredButtons = false
	}
}

void function OnPressedNext( var button )
{
	if ( (UITime() - file.s_openedTime) < PANEL_FADE_IN_BLOCK )
		return                                                                                 

	if ( file.s_panelIndex >= file.s_panels.len() )
		return

	if ( file.s_transition )
	{
		if ( file.s_transitionQueue == QUEUE_CLEAR && (UITime() - file.s_transitionStartTime) > PANEL_TRANSITION_BLOCK_TIME )
		{
			file.s_transitionQueue = QUEUE_FORWARD
		}
		return
	}


	if ( file.s_panelIndex + 1 >= file.s_panels.len() )
	{
		                                                                                  
		file.s_transition = true

		                                                           
		thread function() : ()
		{
			file.s_transition = true
			file.s_transitionStartTime = 0
			file.s_transitionQueue = QUEUE_CLEAR

			EmitUISound( "ui_menu_openlootbox" )                            
			RuiSetGameTime( GetTopReaderRui().rui, "fadeOutStartTime", ClientTime() )
			wait CLOSE_READER_WAIT_TIME
			if ( GetActiveMenu() == file.s_menu )
				CloseActiveMenu()
		}()
		return
	}

	EmitUISound( "UI_Menu_SQ_Advance" )
	thread OnClickedToAdvance( true )
}

#if DEV
void function OnEditButtonPressed( var button, int key )
{
	bool widthMode  = InputIsButtonDown( KEY_LALT )
	bool toggle     = InputIsButtonDown( KEY_LSHIFT )
	bool fracToggle = InputIsButtonDown( KEY_LCONTROL )
	float amount    = toggle ? 20.0 : 1.0

	int lineIdx = file.panelEdit_currentLineIndex

	switch ( key )
	{
		case KEY_LEFT:
			if ( fracToggle )
				file.panelEdit_data[ lineIdx ].placementFrac += amount * 0.01
			else if ( widthMode )
				file.panelEdit_data[ lineIdx ].width -= int( amount )
			else
				file.panelEdit_data[ lineIdx ].offsetX -= amount
			break

		case KEY_RIGHT:
			if ( fracToggle )
				file.panelEdit_data[ lineIdx ].placementFrac -= amount * 0.01
			else if ( widthMode )
				file.panelEdit_data[ lineIdx ].width += int( amount )
			else
				file.panelEdit_data[ lineIdx ].offsetX += amount
			break

		case KEY_UP:
			if ( fracToggle )
			{
				file.panelEdit_data[ lineIdx ].tailScale += amount * 0.01
				file.panelEdit_data[ lineIdx ].tailScale = max( file.panelEdit_data[ lineIdx ].tailScale, 1.0 )
			}
			else if ( !widthMode )
				file.panelEdit_data[ lineIdx ].offsetY -= amount
			break

		case KEY_DOWN:
			if ( fracToggle )
			{
				file.panelEdit_data[ lineIdx ].tailScale -= amount * 0.01
				file.panelEdit_data[ lineIdx ].tailScale = max( file.panelEdit_data[ lineIdx ].tailScale, 1.0 )
			}
			else if ( !widthMode )
				file.panelEdit_data[ lineIdx ].offsetY += amount
			break

		case KEY_TAB:
			ComicPanel panel = file.s_panels[file.s_panelIndex]

			if ( panel.bubbleDialogueArray.len() == 0 )
				break

			int line = (lineIdx + 1) % panel.bubbleDialogueArray.len()
			if ( toggle )
			{
				line = (lineIdx + panel.bubbleDialogueArray.len() - 1) % panel.bubbleDialogueArray.len()
			}

			PanelEdit_SetLine( line )
			break

		case KEY_SPACE:
			int bType = (file.panelEdit_data[ lineIdx ].bubbleType + 1) % eBubbleType._count
			if ( toggle )
			{
				bType = (file.panelEdit_data[ lineIdx ].bubbleType + eBubbleType._count - 1) % eBubbleType._count
			}

			file.panelEdit_data[ lineIdx ].bubbleType = bType
			break

		case KEY_BACKSPACE:
			file.panelEdit_data[ lineIdx ].hideTail = !file.panelEdit_data[ lineIdx ].hideTail
			break
	}

	for ( int i = 0; i < file.readerRuis.len(); ++i )
	{
		if ( file.readerRuis[i].panelIndex != -1 )
		{
			UpdatePanelRuiLines( file.readerRuis[i].panelIndex, file.readerRuis[i].rui )
		}
	}
}
#endif

void function OnPressedPrevious( var button )
{
	if ( (UITime() - file.s_openedTime) < 2.0 )
		return                                                                                 

	if ( file.s_panelIndex <= 0 )
		return

	if ( file.s_transition )
	{
		if ( file.s_transitionQueue == QUEUE_CLEAR && (UITime() - file.s_transitionStartTime) > PANEL_TRANSITION_BLOCK_TIME )
		{
			file.s_transitionQueue = QUEUE_BACKWARD
		}
		return
	}

	EmitUISound( "UI_Menu_SQ_Advance" )
	thread OnClickedToAdvance( false )
}


void function OnNavigateBack()
{
	Assert( GetActiveMenu() == file.s_menu )

	if ( (UITime() - file.s_openedTime) < 1.0 )
		return

	if ( file.s_onNavigatingBackFunc != null )
		file.s_onNavigatingBackFunc()

	CloseActiveMenu()
}


                                    
                                                   
   
  	                            
  	 
  		        
  		           
  		         
  			                             
  
  		              
  		         
  			                               
  
  		              
  		         
  			                               
  	 
  
  	                                                                        
  	         
   


bool function ParsePlaySoundCmd( ComicPanel page, string cmd, string argStr )
{
	int timing = eSoundTiming.PAGE_OPEN

	array<string> args = split( argStr, "| " )
	                       
	   
	  	                                      
	  	                 
	  		            
	   

	switch( cmd )
	{
		case "playsound":
			page.sounds.playSounds[timing].append( args[0].tolower() )
			break

		case "playsoundloop_a":
			page.sounds.playLoopingSoundA[timing] = args[0].tolower()
			break

		case "playsoundloop_b":
			page.sounds.playLoopingSoundB[timing] = args[0].tolower()
			break

		case "playsoundloop_c":
			page.sounds.playLoopingSoundC[timing] = args[0].tolower()
			break

		default:
			Assert( false, ("Unhandled playsound cmd:" + cmd) )
	}
	return true
}


bool function ParseStopSoundCmd( ComicPanel page, string cmd, string argStr )
{
	array<string> args = split( argStr, "| " )

	switch( cmd )
	{
		case "stopsound":
			if ( (args.len() < 1) || (args[0].len() == 0) )
			{
				Warning( "%s() - Got '%s' command but no alias argument.", FUNC_NAME(), cmd )
				return false
			}
			page.sounds.stopSounds.append( args[0].tolower() )
			break

		case "stopsoundloop_a":
			if ( args.len() > 0 )
				Warning( "%s() - Command '%s' doesn't take arguments. Arg '%s' will be ignored.", FUNC_NAME(), cmd, args[0] )
			page.sounds.doStopLoopingSoundA = true
			break

		case "stopsoundloop_b":
			if ( args.len() > 0 )
				Warning( "%s() - Command '%s' doesn't take arguments. Arg '%s' will be ignored.", FUNC_NAME(), cmd, args[0] )
			page.sounds.doStopLoopingSoundB = true
			break

		case "stopsoundloop_c":
			if ( args.len() > 0 )
				Warning( "%s() - Command '%s' doesn't take arguments. Arg '%s' will be ignored.", FUNC_NAME(), cmd, args[0] )
			page.sounds.doStopLoopingSoundC = true
			break

		default:
			Assert( false, ("Unhandled stopsound cmd:" + cmd) )
	}
	return true
}


ComicPanel function CreateEndPanelData( ComicPanel firstPanel )
{
	ComicPanel panel

	panel.panelImage = firstPanel.panelImage                                                                              
	panel.imageWidth = firstPanel.imageWidth
	panel.imageHeight = firstPanel.imageHeight
	panel.offsetX = 0
	panel.offsetY = 0
	panel.borderWidth = firstPanel.imageWidth
	panel.borderHeight = firstPanel.imageHeight
	panel.borderOffsetX = 0
	panel.borderOffsetY = 0
	panel.isTitle = true
	panel.groupId = 0
	panel.sounds.playSounds[eSoundTiming.PAGE_OPEN].append( "ui_menu_openlootbox" )

	BubbleDialogue dialogue
	dialogue.dialogue = file.s_comicComplet ? "#COMIC_THE_END" : "#COMIC_TO_BE_CONTINUED"
	dialogue.width = 1000
	dialogue.height = 0
	dialogue.offsetX = 0
	dialogue.offsetY = -20
	dialogue.bubbleType = eBubbleType.HEADER
	panel.bubbleDialogueArray.append( dialogue )

	return panel
}

array<ComicPanel> function LoadComicPanelsFromDataTable( asset dtAsset, int pageIndex )
{
	var dt                  = GetDataTable( dtAsset )
	int columnCmd           = GetDataTableColumnByName( dt, "cmd" )
	int columnImage         = GetDataTableColumnByName( dt, "image" )
	int columnArgs          = GetDataTableColumnByName( dt, "args" )
	int columnOffsetX       = GetDataTableColumnByName( dt, "offsetx" )
	int columnOffsetY       = GetDataTableColumnByName( dt, "offsety" )
	int columnWidth         = GetDataTableColumnByName( dt, "width" )
	int columnHeight        = GetDataTableColumnByName( dt, "height" )
	int columnBubbleType      = GetDataTableColumnByName( dt, "bubbletype" )
	int columnPlacementFrac   = GetDataTableColumnByName( dt, "placementFrac" )
	int columnBubbleTailHide  = GetDataTableColumnByName( dt, "hideTail" )
	int columnBubbleTailScale = GetDataTableColumnByName( dt, "tailScale" )

	int columnBorderWidth   = GetDataTableColumnByName( dt, "borderWidth" )
	int columnBorderHeight  = GetDataTableColumnByName( dt, "borderHeight" )
	int columnBorderOffsetX = GetDataTableColumnByName( dt, "borderOffsetx" )
	int columnBorderOffsetY = GetDataTableColumnByName( dt, "borderOffsety" )

	array<ComicPanel> panels

	ComicPanel panel
	bool panelHasData = false
	int numRows       = GetDataTableRowCount( dt )
	bool firstPanel   = true
	for ( int rowIdx = 0; rowIdx < numRows; rowIdx++ )
	{
		string cmd            = GetDataTableString( dt, rowIdx, columnCmd )
		asset image           = GetDataTableAsset( dt, rowIdx, columnImage )
		string argStr         = GetDataTableString( dt, rowIdx, columnArgs )
		int width             = GetDataTableInt( dt, rowIdx, columnWidth )
		int height            = GetDataTableInt( dt, rowIdx, columnHeight )
		float offsetX         = GetDataTableFloat( dt, rowIdx, columnOffsetX )
		float offsetY         = GetDataTableFloat( dt, rowIdx, columnOffsetY )
		int bubbleType        = GetDataTableInt( dt, rowIdx, columnBubbleType )
		float placementFrac   = GetDataTableFloat( dt, rowIdx, columnPlacementFrac )
		bool hideTail         = GetDataTableBool( dt, rowIdx, columnBubbleTailHide )
		float bubbleTailScale = GetDataTableFloat( dt, rowIdx, columnBubbleTailScale )

		int borderWidth     = GetDataTableInt( dt, rowIdx, columnBorderWidth )
		int borderHeight    = GetDataTableInt( dt, rowIdx, columnBorderHeight )
		float borderOffsetX = GetDataTableFloat( dt, rowIdx, columnBorderOffsetX )
		float borderOffsetY = GetDataTableFloat( dt, rowIdx, columnBorderOffsetY )

		bool isComment = (cmd.len() > 1) && (cmd.slice( 0, 2 ) == "//")
		if ( (cmd == "") || isComment )
		{
			if ( panelHasData )
			{
				                                   
				panels.append( panel )
				ComicPanel newPanel
				panel = newPanel
				panelHasData = false
			}
			continue
		}

		bool hadError
		cmd = cmd.tolower()
		switch( cmd )
		{
			case "panel":
				panel.panelImage = image
				panel.imageWidth = width
				panel.imageHeight = height
				panel.offsetX = offsetX
				panel.offsetY = offsetY
				panel.isTitle = firstPanel
				panel.groupId = bubbleType                                                                  
				panel.pageID = pageIndex
				panel.panelID = panels.len()

				panel.borderWidth = borderWidth ? borderWidth : width
				panel.borderHeight = borderHeight ? borderHeight : height
				panel.borderOffsetX = borderOffsetX ? borderOffsetX : 0.0
				panel.borderOffsetY = borderOffsetY ? borderOffsetY : 0.0

				firstPanel = false
				Assert( width > 0, "A panel row in data table " + string( dtAsset ) + " has invalid width: " + string( width ) )
				Assert( height > 0, "A panel row in data table " + string( dtAsset ) + " has invalid height: " + string( height ) )
				panelHasData = true
				break

			case "text":
				BubbleDialogue dialogue
				dialogue.dialogue = argStr
				dialogue.width = width
				dialogue.height = height
				dialogue.offsetX = offsetX
				dialogue.offsetY = offsetY
				dialogue.bubbleType = bubbleType
				dialogue.placementFrac = placementFrac
				dialogue.hideTail = hideTail
				dialogue.tailScale = bubbleTailScale <= 0 ? 1.0 : bubbleTailScale

				panel.bubbleDialogueArray.append( dialogue )
				Assert( panel.bubbleDialogueArray.len() <= MAX_DIALOGUE_LINES, "More then " + MAX_DIALOGUE_LINES + " dialogue lines for one panel in data table " + string( dtAsset ) )
				panelHasData = true
				break

				             

			case "musictrack":
				panel.sounds.musicTrack = argStr
				panelHasData = true
				break

			case "ambienttrack":
				panel.sounds.ambientTrack = argStr
				panelHasData = true
				break

			case "playsound":
			case "playsoundloop_a":
			case "playsoundloop_b":
			case "playsoundloop_c":
				if ( !ParsePlaySoundCmd( panel, cmd, argStr ) )
					hadError = true
				panelHasData = true
				break

			case "stopsound":
			case "stopsoundloop_a":
			case "stopsoundloop_b":
			case "stopsoundloop_c":
				if ( !ParseStopSoundCmd( panel, cmd, argStr ) )
					hadError = true
				panelHasData = true
				break

			default:
				hadError = true
		}

		if ( hadError )
		{
			string errMsg = format( "%s() - Unhandled command '%s' on row #%d of '%s'", FUNC_NAME(), cmd, rowIdx, string( dtAsset ) )
			Assert( 0, errMsg )
			Warning( "%s", errMsg )
			hadError = false
		}
	}

	if ( panelHasData )
		panels.append( panel )

	if ( panels.len() == 0 )
	{
		panels.append( panel )
	}

	return panels
}

void function InitPagesForMenuOpen()
{
	file.s_panels.clear()
	if ( file.s_arrayOfDataToLoadOnOpen.len() == 0 )
	{
		                                    
		ComicPanel panel
		file.s_panels.append( panel )
	}
	else
	{
		foreach ( int pageIndex, asset dtAsset in file.s_arrayOfDataToLoadOnOpen )
		{
			array<ComicPanel> panelArray = LoadComicPanelsFromDataTable( dtAsset, pageIndex )
			file.s_panelsForPage[pageIndex] <- panelArray.len()
			file.s_panels.extend( panelArray )
		}
	}

	file.s_panels.append( CreateEndPanelData( file.s_panels[0] ) )

	file.readerRuis.clear()
	for ( int i = 0; i < NUM_READER_PANELS; ++i )
	{
		var readerElem = Hud_GetChild( file.s_menu, "ComicReaderScreen" + (i + 1) )
		var rui = Hud_GetRui( readerElem )

		ReaderRui readerRui
		readerRui.rui = rui
		file.readerRuis.append( readerRui )

		file.ruiToElementMap[rui] <- readerElem
	}

	file.backgroundRui = Hud_GetRui( Hud_GetChild( file.s_menu, "ComicReaderBackground" ) )

	s_latestMusicTrack = ""
	s_latestAmbientTrack = ""

	for ( int idx = 0; idx < s_latestLoopingTracks.len(); ++idx )
		s_latestLoopingTracks[idx] = ""

	int panelDataIndex = GetPanelDataIndexOfPanelIndexForPage( file.s_startPageIndex, file.s_startPanelIndex )
	file.s_panelIndex = panelDataIndex

	                                                    
	              
	                                                    
	ComicPanel pData = file.s_panels[ file.s_panelIndex ]
	float sizeMultiplier = GetAdjustedSizeMultiplier( pData )
	BubbleDialogue diag
	diag.offsetX = pData.imageWidth * sizeMultiplier * 0.5
	diag.offsetY = pData.imageHeight * sizeMultiplier * 0.5
	diag.width = 600
	diag.height = 600
	diag.placementFrac = 0.45
	diag.bubbleType = eBubbleType.BOTTOM
	diag.dialogue = (file.s_panelIndex == 0)? Localize( "#COMIC_PROLOGUE_CREDITS" ): Localize( "#COMIC_CREDITS" )
	diag.hideTail = true
	pData.bubbleDialogueArray.append( diag )
	                                                    


	file.s_transition = false
	file.s_transitionStartTime = 0
	file.s_transitionQueue = QUEUE_CLEAR

	#if DEV
		if ( file.panelEditMode )
		{
			PanelEdit_SetLine( 0 )
			PanelEdit_Update( panelDataIndex )
		}
	#endif

	for ( int i = 0; i < file.readerRuis.len(); ++i )
	{
		HidePanelRui( file.readerRuis[i] )
	}

	ReaderRui firstReaderRui = GetAvailableReaderRuis()[0]

	LoadPanelImages( int( max( file.s_panelIndex - 1, 0 ) ), int( min( file.s_panelIndex + 1, file.s_panels.len() -1 ) ) )
	UpdatePanelRui( file.s_panelIndex, firstReaderRui, true, false )
	UpdateReaderRuiZOrders()
	UpdateBackgroundRui( file.s_panelIndex )
	UpdateAudio( file.s_panelIndex )

	file.pin_viewStartTime = UITime()
	AddComicPinEvent( file.s_startPageIndex, file.s_startPanelIndex, -1, -1 )

	                          
	RuiSetGameTime( firstReaderRui.rui, "fadeInStartTime", ClientTime() )

	file.s_screenOpenNumber++
}


int function GetPanelDataIndexOfPanelIndexForPage( int pageIndex, int panelIndex )
{
	int panelDataIndex = 0
	for ( int index = 0; index < pageIndex; index++ )
	{
		panelDataIndex += file.s_panelsForPage[ index ]
	}

	return panelDataIndex + panelIndex
}


void function UpdateIfNewMusicTrack( string alias )
{
	if ( alias.len() == 0 )
		return
	if ( s_latestMusicTrack == alias )
		return

	s_latestMusicTrack = alias
	PlayCustomUIMusic( alias )
}


void function UpdateIfNewAmbientTrack( string alias )
{
	if ( alias.len() == 0 )
		return
	if ( s_latestAmbientTrack == alias )
		return

	if ( s_latestAmbientTrack.len() > 0 )
		StopUISound( s_latestAmbientTrack )
	s_latestAmbientTrack = alias
	EmitUISound( alias )
}


void function UpdateIfNewLoopingTrack_( string alias, int idx )
{
	if ( alias.len() == 0 )
		return
	if ( s_latestLoopingTracks[idx] == alias )
		return

	if ( s_latestLoopingTracks[idx].len() > 0 )
		StopUISound( s_latestLoopingTracks[idx] )
	s_latestLoopingTracks[idx] = alias
	EmitUISound( alias )
}


void function UpdateIfNewLoopingTrackA( string alias )
{
	UpdateIfNewLoopingTrack_( alias, 0 )
}


void function UpdateIfNewLoopingTrackB( string alias )
{
	UpdateIfNewLoopingTrack_( alias, 1 )
}


void function UpdateIfNewLoopingTrackC( string alias )
{
	UpdateIfNewLoopingTrack_( alias, 2 )
}


void function StopLoopingTrack_( int idx )
{
	if ( s_latestLoopingTracks[idx].len() == 0 )
		return
	StopUISound( s_latestLoopingTracks[idx] )
	s_latestLoopingTracks[idx] = ""
}


void function StopLoopingTrackA()
{
	StopLoopingTrack_( 0 )
}


void function StopLoopingTrackB()
{
	StopLoopingTrack_( 1 )
}


void function StopLoopingTrackC()
{
	StopLoopingTrack_( 2 )
}


string s_latestMusicTrack
string s_latestAmbientTrack
string[3] s_latestLoopingTracks
int s_chatlogProgress = 0
void function UpdateAudio( int panelIndex )
{
	ComicPanel panel = file.s_panels[panelIndex]

	foreach ( sound in panel.sounds.stopSounds )
		StopUISound( sound )
	if ( panel.sounds.doStopLoopingSoundA )
		StopLoopingTrackA()
	if ( panel.sounds.doStopLoopingSoundB )
		StopLoopingTrackB()
	if ( panel.sounds.doStopLoopingSoundC )
		StopLoopingTrackC()

	foreach ( sound in panel.sounds.playSounds[eSoundTiming.PAGE_OPEN] )
		EmitUISound( sound )
	UpdateIfNewMusicTrack( panel.sounds.musicTrack )
	UpdateIfNewAmbientTrack( panel.sounds.ambientTrack )
	UpdateIfNewLoopingTrackA( panel.sounds.playLoopingSoundA[eSoundTiming.PAGE_OPEN] )
	UpdateIfNewLoopingTrackB( panel.sounds.playLoopingSoundB[eSoundTiming.PAGE_OPEN] )
	UpdateIfNewLoopingTrackC( panel.sounds.playLoopingSoundC[eSoundTiming.PAGE_OPEN] )
}

void function UpdateBackgroundRui( int panelIndex )
{
	                                 
	if ( !IsFullyConnected() )
		return

	ItemFlavor ornull quest = SeasonQuest_GetActiveSeasonQuest( GetUnixTimestamp() )
	RuiSetString( file.backgroundRui, "titleText", "" )

	if ( quest != null )
	{
		expect ItemFlavor( quest )
		RuiSetString( file.backgroundRui, "titleText", Localize( ItemFlavor_GetShortName( quest ) ) )
		#if DEV
			if ( file.panelEditMode )
				RuiSetString( file.backgroundRui, "titleText", "EDIT MODE!!!" )
		#endif
	}

	RuiSetInt( file.backgroundRui, "currentPanel", panelIndex + 1 )
	RuiSetInt( file.backgroundRui, "panelCount", file.s_panels.len() - 1 )
	  	                                                                         
}


void function UpdatePanelRui( int panelIndex, ReaderRui readerRui, bool isForward, bool isTransitionOut )
{
	readerRui.panelIndex = panelIndex
	readerRui.isTransitioningOut = isTransitionOut

	ComicPanel panel = file.s_panels[panelIndex]
	var rui = readerRui.rui

	RuiSetBool( rui, "isVisible", true )

	ReaderRui topReader = GetTopReaderRui()
	RuiSetGameTime( topReader.rui, "fadeInStartTime", RUI_BADGAMETIME )
	RuiSetGameTime( topReader.rui, "fadeOutStartTime", RUI_BADGAMETIME )

	RuiSetGameTime( rui, "transitionStartTime", file.s_transition ? ClientTime() : RUI_BADGAMETIME )
	RuiSetBool( rui, "isForward", isForward )
	RuiSetBool( rui, "isTransitionOut", isTransitionOut )

	var panelElement = file.ruiToElementMap[rui]
	RunClientScript( "UIToClient_SetPanelImage", panelElement, panelIndex, panel.panelImage )

	float sizeMultiplier = GetAdjustedSizeMultiplier( panel )
	vector imageSize = <float( panel.imageWidth ), float( panel.imageHeight ), 0> * sizeMultiplier
	vector offset = <panel.offsetX, panel.offsetY, 0> * sizeMultiplier
	vector borderSize = <float( panel.borderWidth ), float( panel.borderHeight ), 0> * sizeMultiplier
	vector borderOffset = <panel.borderOffsetX, panel.borderOffsetY, 0> * sizeMultiplier

	RuiSetFloat2( rui, "panelImageSize", imageSize )
	RuiSetFloat2( rui, "panelOffset", offset )
	RuiSetFloat2( rui, "borderSize", borderSize )
	RuiSetFloat2( rui, "borderOffset", borderOffset )

	RuiSetBool( rui, "isTitlePage", panel.isTitle )

	UpdatePanelRuiLines( panelIndex, rui )
}


float function GetAdjustedSizeMultiplier( ComicPanel panel )
{
	const float MAX_PANEL_WIDTH = 1400
	const float MAX_PANEL_HEIGHT = 750

	float width = float( panel.imageWidth )
	float height = float( panel.imageHeight )

	float adjustedImageWidth  = width
	float adjustedImageHeight = height
	float multiplier = 1

	if ( adjustedImageWidth > MAX_PANEL_WIDTH )
	{
		multiplier = MAX_PANEL_WIDTH / width
		adjustedImageWidth *= multiplier
		adjustedImageHeight *= multiplier
	}

	if ( adjustedImageHeight > MAX_PANEL_HEIGHT )
	{
		multiplier = MAX_PANEL_HEIGHT / height
		adjustedImageWidth *= multiplier
		adjustedImageHeight *= multiplier
	}

	return multiplier
}


void function UpdatePanelRuiLines( int panelIndex, var rui )
{
	ComicPanel panel = file.s_panels[panelIndex]

	#if DEV
		if ( file.panelEditMode )
			printt( "--------------------------------" )
	#endif

	for ( int lineIndex = 0; lineIndex < MAX_DIALOGUE_LINES; lineIndex++ )
	{
		RuiDestroyNestedIfAlive( rui, format( "speechBubbleHandle%02d", lineIndex + 1 ) )

		BubbleDialogue dialogue

		if ( panel.bubbleDialogueArray.len() > lineIndex )
		{
			dialogue = panel.bubbleDialogueArray[lineIndex]

			asset nestedAsset = $"ui/basic_speech_bubble.rpak"
			if ( dialogue.bubbleType == eBubbleType.SFX )
				nestedAsset = $"ui/sfx_text.rpak"
			#if DEV
				if ( file.panelEditMode )
				{
					BubbleDialogue dialogueEdit = file.panelEdit_data[ lineIndex ]
					if ( dialogueEdit.bubbleType == eBubbleType.SFX )
						nestedAsset = $"ui/sfx_text.rpak"
				}
			#endif

			var nestedRui = RuiCreateNested( rui, format( "speechBubbleHandle%02d", lineIndex + 1 ), nestedAsset )

			                         
			RuiSetInt( nestedRui, "bubbleType", dialogue.bubbleType )
			RuiSetString( nestedRui, "bubbleText", dialogue.dialogue )
			RuiSetFloat( nestedRui, "bubbleTextWidth", float( dialogue.width ) )
			RuiSetFloat2( nestedRui, "bubblePlacement", <dialogue.offsetX, dialogue.offsetY, 0> )
			RuiSetFloat( nestedRui, "bubblePlacementFrac", dialogue.placementFrac )
			RuiSetFloat( nestedRui, "bubbleTailScale", dialogue.tailScale )
			RuiSetBool( nestedRui, "bubbleHideTail", dialogue.hideTail )

			RuiSetColorAlpha( nestedRui, "borderColor", <0, 0, 0>, 1 )
			RuiSetColorAlpha( nestedRui, "fillColor", <1, 1, 1>, 1 )
			RuiSetColorAlpha( nestedRui, "textColor", <0, 0, 0>, 1 )
			RuiSetFloat2( nestedRui, "panelImageSize", <panel.imageWidth, panel.imageHeight, 0> )
			#if DEV
				RuiSetBool( nestedRui, "isEditMode", file.panelEditMode )
			#endif

			#if DEV
				if ( file.panelEditMode )
				{
					BubbleDialogue dialogueEdit = file.panelEdit_data[ lineIndex ]

					RuiSetInt( nestedRui, "bubbleType", dialogueEdit.bubbleType )
					RuiSetFloat( nestedRui, "bubbleTextWidth", float( file.panelEdit_data[ lineIndex ].width ) )
					RuiSetFloat2( nestedRui, "bubblePlacement", <file.panelEdit_data[ lineIndex ].offsetX, dialogueEdit.offsetY, 0> )
					RuiSetFloat( nestedRui, "bubblePlacementFrac", dialogueEdit.placementFrac )
					RuiSetFloat( nestedRui, "bubbleTailScale", dialogueEdit.tailScale )
					RuiSetBool( nestedRui, "bubbleHideTail", dialogueEdit.hideTail )

					printt( "\t\tTEXT,," + dialogue.dialogue + "," + dialogueEdit.width + ",," + dialogueEdit.offsetX + "," + dialogueEdit.offsetY + "," + dialogueEdit.bubbleType + "," + dialogueEdit.placementFrac + "," + dialogueEdit.hideTail + "," + dialogueEdit.tailScale )
				}
			#endif
		}
	}

	#if DEV
		if ( file.panelEditMode )
		{
			printt( "--------------------------------" )
			RuiSetInt( rui, "editModeCurrentIdx", file.panelEdit_currentLineIndex + 1 )
		}
		else
		{
			RuiSetInt( rui, "editModeCurrentIdx", 0 )
		}
	#endif
}

void function LoadPanelImages( int minPanelIndexToLoad, int maxPanelIndexToLoad )
{
	                                                                  
	for (int index = minPanelIndexToLoad + 1; index <= maxPanelIndexToLoad; ++index)
	{
		int panelIndex = index
		asset panelImage = file.s_panels.isvalidindex( index ) ? file.s_panels[index].panelImage : $""

		index -= 1
		asset prevImage = file.s_panels.isvalidindex( index ) ? file.s_panels[index].panelImage : $""

		index += 2
		asset nextImage = ( index <= maxPanelIndexToLoad && file.s_panels.isvalidindex( index ) ) ? file.s_panels[index].panelImage : $""

		int panelsBeforeToKeepLoaded = panelIndex - minPanelIndexToLoad
		int panelsAfterToKeepLoaded = maxPanelIndexToLoad - panelIndex
		RunClientScript( "UIToClient_LoadPanelImages", panelIndex, panelImage, prevImage, nextImage, panelsBeforeToKeepLoaded, panelsAfterToKeepLoaded )
	}
}
#endif     

#if CLIENT
void function UIToClient_LoadPanelImages( int panelIndex, asset panelImage, asset prevImage, asset nextImage, int panelsBeforeToKeepLoaded, int panelsAfterToKeepLoaded )
{
	array<asset> images = [prevImage, panelImage, nextImage]
	for ( int i = 0; i < 3; i++ )
	{
		if ( images[i] == $"" )
			continue                                     

		int pakIndex = panelIndex + (i - 1)
		if ( pakIndex in file.pakHandles )
			continue                                                              

		string rpak         = PanelImage_GetRPakName( images[ i ] )
		PakHandle pakHandle = RequestPakFile( rpak )
		file.pakHandles[pakIndex] <- pakHandle
		printt( "#PAK - request", pakIndex )
	}

	                                            
	foreach ( int index, pakHandle in clone file.pakHandles )
	{
		bool outOfRange = (index < panelIndex - panelsBeforeToKeepLoaded || index > panelIndex + panelsAfterToKeepLoaded)
		if ( outOfRange )
		{
			                                               
			printt( "#PAK - release", index )
			Signal( pakHandle, "StopWaitingForPakLoad" )
			ReleasePakFile( pakHandle )
			delete file.pakHandles[index]
		}
	}
#if DEV
	string pakString = "#PAK - Panels: ["

	foreach ( int index, pakHandle in file.pakHandles )
	{
		pakString += (index + ", ")
	}
	string finalPakString = pakString.slice(0, pakString.len() - 2) + "]"
	printt( finalPakString )
#endif
}

string function PanelImage_GetRPakName( asset imageAsset )
{
	array<string> assetStrParts = split( string(imageAsset), "/" )
	Assert( assetStrParts.len() == 2 )                                     
	Assert( assetStrParts[0] == "comic" )
	Assert( assetStrParts[1].find( "comic_" ) == 0 )
	return assetStrParts[1]
}

void function UIToClient_SetPanelImage( var panelElement, int panelIndex, asset panelImage )
{
	               
	if( panelIndex in file.pakHandles )
	{

		Signal( file.pakHandles[panelIndex], "StopWaitingForPakLoad" )


		thread function() : ( panelElement, panelIndex, panelImage )
		{
			EndSignal( file.pakHandles[panelIndex], "PakHandleReleased" )
			EndSignal( file.pakHandles[panelIndex], "StopWaitingForPakLoad" )

			table e
			e.done <- false
			OnThreadEnd(
				function() : ( e, panelIndex )
				{
					printt( "#PAK - SetPanelEnded", e.done ? "gracefully" : "abruptly", panelIndex )
				}
			)

			if ( !file.pakHandles[panelIndex].isAvailable )
			{
				printt( "#PAK Wait for PAK", panelIndex, panelElement )
				RuiSetBool( Hud_GetRui( panelElement ), "panelImageIsReady", false )
				WaitSignal( file.pakHandles[panelIndex], "PakFileLoaded" )
			}

			printt( "#PAK - set image", panelIndex, panelElement )
			RuiSetImage( Hud_GetRui( panelElement ), "panelImage", panelImage )
			RuiSetBool( Hud_GetRui( panelElement ), "panelImageIsReady", true )
			e.done = true
		}()
	}
}


void function UIToClient_ReleaseAllLoadedPakHandles()
{
	                                 
	array<PakHandle> unloadedHandles
	foreach ( int panelIndex, pakHandle in file.pakHandles )
	{
		if ( unloadedHandles.contains( pakHandle ) )
			continue
		else
			unloadedHandles.append( pakHandle )

		printt( "#PAK - total release ", panelIndex )
		Signal( pakHandle, "StopWaitingForPakLoad" )
		ReleasePakFile( pakHandle )
	}
	file.pakHandles.clear()
}
#endif         


#if UI
void function HidePanelRui( ReaderRui readerRui )
{
	RuiSetBool( readerRui.rui, "isVisible", false )
}


void function OnClickedToAdvance( bool isForward )
{
	int wantPanelIndex = isForward ? (file.s_panelIndex + 1) : (file.s_panelIndex - 1)

	if ( wantPanelIndex < 0 )
		return

	if ( file.s_panels.len() <= wantPanelIndex )
		return

	if ( wantPanelIndex != file.s_panelIndex )
	{
		int currentPanelIndex = file.s_panelIndex

		EndSignal( uiGlobal.signalDummy, "ActiveMenuChanged" )

		OnThreadEnd(
			function() : ( wantPanelIndex )
			{
				file.s_transition = false
				file.s_transitionStartTime = 0
				file.s_panelIndex = wantPanelIndex
				UpdateFooterOptions()

				for (int i = 0; i < file.readerRuis.len(); ++i)
				{
					if ( file.readerRuis[i].isTransitioningOut )
					{
						file.readerRuis[i].isTransitioningOut = false
						file.readerRuis[i].panelIndex = -1
					}
				}

				if ( file.s_transitionQueue == QUEUE_FORWARD )
					thread OnClickedToAdvance( true )
				else if ( file.s_transitionQueue == QUEUE_BACKWARD )
					thread OnClickedToAdvance( false )
				file.s_transitionQueue = QUEUE_CLEAR
			}
		)

		file.s_transition = true
		file.s_transitionStartTime = UITime()

		                                                                                  

		#if DEV
			if ( file.panelEditMode )
			{
				PanelEdit_SetLine( 0 )
				PanelEdit_Update( wantPanelIndex )
			}
		#endif

		                                                                                                              
		array<ReaderRui> availableReaders = GetAvailableReaderRuis()

		                                                       
		int currentPanelGroupId = file.s_panels[currentPanelIndex].groupId
		int wantPanelGroupId = file.s_panels[wantPanelIndex].groupId
		bool arePanelsGrouped = currentPanelGroupId > 0 && currentPanelGroupId == wantPanelGroupId

		                                   
		                                                                                                          
		                                                                             
		if ( !arePanelsGrouped )
		{
			for ( int i = 0; i < file.readerRuis.len(); ++i )
			{
				if ( file.readerRuis[i].panelIndex != -1 )
				{
					UpdatePanelRui( file.readerRuis[i].panelIndex, file.readerRuis[i], isForward, true )
				}
			}
		}
		else if ( !isForward )
		{
			for ( int i = 0; i < file.readerRuis.len(); ++i )
			{
				if ( currentPanelIndex == file.readerRuis[i].panelIndex )
				{
					UpdatePanelRui( currentPanelIndex, file.readerRuis[i], isForward, true )
					break
				}
			}
		}

		                                   
		                                                                                          
		                                                                                                                     
		if ( !isForward && wantPanelGroupId > 0 && wantPanelGroupId != currentPanelGroupId )
		{
			for (int i = wantPanelIndex; i >= 0; --i)
			{
				if ( file.s_panels[i].groupId == wantPanelGroupId )
				{
					ReaderRui readerRui = availableReaders.top()
					availableReaders.pop()
					UpdatePanelRui( i, readerRui, isForward, false )
				}
			}
		}
		else if ( isForward || !arePanelsGrouped )
		{
			UpdatePanelRui( wantPanelIndex, availableReaders[0], isForward, false )
		}

		                                                     
		                                                                                                
		UpdateReaderRuiZOrders()

		                                                          
		int minPanelIndexToLoad = int( max( wantPanelIndex - 1, 0 ) )
		int maxPanelIndexToLoad = int( min( wantPanelIndex + 1, file.s_panels.len() - 1 ) )

		                                                                                                                                                
		int minGroupId = file.s_panels[minPanelIndexToLoad].groupId
		if ( minGroupId > 0 )
		{
			for ( int i = minPanelIndexToLoad - 1; i >= 0; --i )
			{
				if ( file.s_panels[i].groupId == minGroupId )                                                                                                   
				{
					minPanelIndexToLoad = i
				}
				else
				{
					break;
				}
			}
		}

		#if DEV
			int prevMinPanelToLoad = wantPanelIndex - 1
			int maxSupportedPanels = file.readerRuis.len()
			int numPanels = prevMinPanelToLoad - minPanelIndexToLoad
			if ( prevMinPanelToLoad - minPanelIndexToLoad > maxSupportedPanels )
			{
				                                                                                     
				                                                                             
				                                                                                     
				                                                               
				                                                                                     
				Assert( 0, "Trying to find panels associated with panel #" + (prevMinPanelToLoad+1) + "(index: " + prevMinPanelToLoad +
				", " + file.s_panels[prevMinPanelToLoad].panelImage + ") but " + numPanels + " were found, exceeding " + maxSupportedPanels + " panels a page can show. Check 'Type Of speech bubble' on Panel Rows are uniquely grouped.  See script comments for more details." )
			}
		#endif

		LoadPanelImages( minPanelIndexToLoad, maxPanelIndexToLoad )

		UpdateBackgroundRui( wantPanelIndex )
		UpdateAudio( wantPanelIndex )

		{
			                
			ComicPanel wantPanel    = file.s_panels[wantPanelIndex]
			ComicPanel currentPanel = file.s_panels[currentPanelIndex]
			if ( wantPanelIndex == file.s_panels.len() - 1 )
			{
				                                                       
				AddComicPinEvent( -1, -1, currentPanel.pageID, currentPanel.panelID )
			}
			else
			{
				AddComicPinEvent( wantPanel.pageID, wantPanel.panelID, currentPanel.pageID, currentPanel.panelID )
			}
		}

		wait PANEL_TRANSITION_DURATION
	}
}


void function AddComicPinEvent( int pageIndex, int panelIndex, int previousPageIndex, int previousPanelIndex )
{
	if ( !IsConnected() )
		return

	int seasonNum     = GetActiveSeasonNumber()
	string currentID  = pageIndex == -1 ? "none" : format( "s%d_pg%d_panel%d", seasonNum, pageIndex, panelIndex )
	string previousID = previousPageIndex == -1 ? "none" : format( "s%d_pg%d_panel%d", seasonNum, previousPageIndex, previousPanelIndex )

	float timeToRead = UITime() - file.pin_viewStartTime
	PIN_ComicPageView( currentID, previousID, timeToRead )

	file.pin_viewStartTime = UITime()
}


#if DEV
void function PanelEdit_SetLine( int line )
{
	file.panelEdit_currentLineIndex = line
}

void function TggleEditMode( var button )
{
	DeregisterButtons()
	file.panelEditMode = !file.panelEditMode
	RegisterButtons()

	if ( file.panelEditMode )
	{
		PanelEdit_SetLine( 0 )
		PanelEdit_Update( file.s_panelIndex )
	}

	UpdateBackgroundRui( file.s_panelIndex )
}

void function PanelEdit_Update( int panelIndex )
{
	file.panelEdit_data.clear()

	for ( int lineIndex = 0; lineIndex < MAX_DIALOGUE_LINES; lineIndex++ )
	{
		BubbleDialogue data
		file.panelEdit_data.append( data )
	}

	ComicPanel panel = file.s_panels[ panelIndex ]

	for ( int lineIndex = 0; lineIndex < MAX_DIALOGUE_LINES; lineIndex++ )
	{
		BubbleDialogue dialogue
		if ( panel.bubbleDialogueArray.len() > lineIndex )
			dialogue = panel.bubbleDialogueArray[lineIndex]

		file.panelEdit_data[ lineIndex ].bubbleType = dialogue.bubbleType
		file.panelEdit_data[ lineIndex ].width = dialogue.width
		file.panelEdit_data[ lineIndex ].offsetX = dialogue.offsetX
		file.panelEdit_data[ lineIndex ].offsetY = dialogue.offsetY
		file.panelEdit_data[ lineIndex ].placementFrac = dialogue.placementFrac
		file.panelEdit_data[ lineIndex ].hideTail = dialogue.hideTail
		file.panelEdit_data[ lineIndex ].tailScale = dialogue.tailScale
	}
}
#endif

#endif     
