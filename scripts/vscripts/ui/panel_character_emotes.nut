global function InitCharacterEmotesPanel
global function CharacterEmotesPanel_SetHintSub

struct SectionDef
{
	var button
	var panel
	var listPanel
	int index
}

struct
{
	var panel
	var headerRui

	array<SectionDef> sections
	int               activeSectionIndex = 0
	table<int, array<int> > sectionToFilters
	table<int, bool functionref() > sectionIsValidFunc

	ItemFlavor ornull lastNewnessCharacter
} file

void function InitCharacterEmotesPanel( var panel )
{
	file.panel = panel
	file.headerRui = Hud_GetRui( Hud_GetChild( panel, "Header" ) )

	SetPanelTabTitle( panel, "#SOCIAL_WHEEL" )
	RuiSetString( file.headerRui, "title", "" )
	RuiSetString( file.headerRui, "collected", "" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, EmotesPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, EmotesPanel_OnHide )
	RegisterButtonPressedCallback( BUTTON_DPAD_RIGHT, EmotesPanel_OnNavRight )

	AddCallback_OnTopLevelCustomizeContextChanged( panel, EmotesPanel_OnCustomizeContextChanged )

	int buttonNum = 0

	   
	  	                  
	  	                                                                   
	  	                                      
	  	                                                                     
	  	                                                   
	  	                         
	  	                                        
	  	                                                                        
	  	                               
	  	           
	   

	{
		SectionDef section
		section.button = Hud_GetChild( panel, "SectionButton" + buttonNum )
		Hud_SetVisible( section.button, true )
		HudElem_SetRuiArg( section.button, "buttonText", Localize( "#EMOTES" ) )
		section.panel = Hud_GetChild( panel, "BoxesPanel" )
		section.listPanel = Hud_GetChild( section.panel, "QuipList" )
		section.index = buttonNum
		file.sectionToFilters[ buttonNum ] <- [ eItemType.character_emote ]
		file.sectionIsValidFunc[ buttonNum ] <- null
		Hud_AddEventHandler( section.button, UIE_CLICK, SectionButton_Activate )
		file.sections.append( section )
		Hud_SetNavLeft( section.listPanel, section.button )
		buttonNum++
	}

	{
		SectionDef section
		section.button = Hud_GetChild( panel, "SectionButton" + buttonNum )
		Hud_SetVisible( section.button, true )
		HudElem_SetRuiArg( section.button, "buttonText", Localize( "#HOLOS" ) )
		section.panel = Hud_GetChild( panel, "BoxesPanel" )
		section.listPanel = Hud_GetChild( section.panel, "QuipList" )
		section.index = buttonNum
		file.sectionToFilters[ buttonNum ] <- [ eItemType.emote_icon ]
		file.sectionIsValidFunc[ buttonNum ] <- null
		Hud_AddEventHandler( section.button, UIE_CLICK, SectionButton_Activate )
		file.sections.append( section )
		Hud_SetNavLeft( section.listPanel, section.button )
		buttonNum++
	}

	{
		SectionDef section
		section.button = Hud_GetChild( panel, "SectionButton" + buttonNum )
		Hud_SetVisible( section.button, true )
		HudElem_SetRuiArg( section.button, "buttonText", Localize( "#QUIPS" ) )
		section.panel = Hud_GetChild( panel, "LinePanel" )
		section.listPanel = Hud_GetChild( section.panel, "QuipList" )
		section.index = buttonNum
		file.sectionToFilters[ buttonNum ] <- [ eItemType.gladiator_card_kill_quip, eItemType.gladiator_card_intro_quip ]
		file.sectionIsValidFunc[ buttonNum ] <- null
		Hud_AddEventHandler( section.button, UIE_CLICK, SectionButton_Activate )
		file.sections.append( section )
		Hud_SetNavLeft( section.listPanel, section.button )
		buttonNum++
	}

	{
		SectionDef section
		section.button = Hud_GetChild( panel, "SectionButton" + buttonNum )
		Hud_SetVisible( section.button, true )
		HudElem_SetRuiArg( section.button, "buttonText", Localize( "#SKYDIVE_EMOTES" ) )
		section.panel = Hud_GetChild( panel, "SkydiveEmotesPanel" )
		section.listPanel = Hud_GetChild( section.panel, "SkydiveEmotesList" )
		section.index = buttonNum
		file.sectionToFilters[ buttonNum ] <- [ eItemType.skydive_emote ]
		file.sectionIsValidFunc[ buttonNum ] <- HasEquippableSkydiveEmotes
		Hud_AddEventHandler( section.button, UIE_CLICK, SectionButton_Activate )
		file.sections.append( section )
		Hud_SetNavLeft( section.listPanel, section.button )
		buttonNum++
	}

	HudElem_SetRuiArg( Hud_GetChild( file.panel, "HintMKB" ), "textBreakWidth", 400.0 )
	HudElem_SetRuiArg( Hud_GetChild( file.panel, "HintGamepad" ), "textBreakWidth", 400.0 )
}

void function SectionButton_Activate( var button )
{
	Hud_SetSelected( button, true )

	var panel

	foreach ( sectionIndex, sectionDef in file.sections )
	{
		bool isActivated = sectionDef.button == button
		if ( isActivated )
		{
			panel = sectionDef.panel
			file.activeSectionIndex = sectionIndex
			if ( sectionIndex != 3 )                                   
				QuipPanel_SetItemTypeFilter( file.sectionToFilters[ sectionIndex ] )
		}

		Hud_SetSelected( sectionDef.button, isActivated )
	}

	ActivatePanel( panel )
}


void function ActivatePanel( var panel )
{
	HideVisibleSectionPanels()

	if ( panel )
	{
		ShowPanel( panel )
		FocusOnActiveListPanel()
	}
}


void function EmotesPanel_OnNavRight( var player )
{
	foreach ( sectionIndex, sectionDef in file.sections )
	{
		if ( Hud_IsFocused( sectionDef.button ) )
		{
			FocusOnActiveListPanel()
			break
		}
	}
}


void function FocusOnActiveListPanel()
{
	if ( file.sections.isvalidindex( file.activeSectionIndex ) )
	{
		var activeListPanel = file.sections[ file.activeSectionIndex ].listPanel
		var activeButton = file.sections[ file.activeSectionIndex ].button
		var selectedChild   = Hud_GetSelectedButton( activeListPanel )
		var buttonCount = Hud_GetButtonCount( activeListPanel )

		Hud_SetNavLeft( activeListPanel, activeButton )

		if ( !selectedChild )
		{
			int mostRecentSelectedIndex = Hud_GetMostRecentSelectedButtonIndex( activeListPanel )
			if ( mostRecentSelectedIndex >= 0 && mostRecentSelectedIndex < buttonCount )
				selectedChild = Hud_GetButton( activeListPanel, mostRecentSelectedIndex )
		}

		if ( !selectedChild && buttonCount > 0 )
			selectedChild = Hud_GetButton( activeListPanel, 0 )

		if ( selectedChild )
			Hud_SetFocused( selectedChild )
	}
}


void function HideVisibleSectionPanels()
{
	array<var> panels
	foreach ( sectionDef in file.sections )
		panels.append( sectionDef.panel )

	foreach ( panel in panels )
	{
		if ( Hud_IsVisible( panel ) )
			HidePanel( panel )
	}
}


void function EmotesPanel_OnShow( var panel )
{
	UI_SetPresentationType( ePresentationType.CHARACTER_QUIPS )

	file.activeSectionIndex = 0

	CharacterEmotesPanel_Update()

	                                            
	  	                                                                                                                                                        

	for ( int i = 0; i < MAX_FAVORED_QUIPS; i++ )
		AddCallback_ItemFlavorLoadoutSlotDidChange_SpecificPlayer( LocalClientEHI(), Loadout_FavoredQuip( GetTopLevelCustomizeContext(), i ), OnFavoredQuipChanged )

	CharacterEmotesPanel_SetHintSub( "#HINT_SOCIAL_ANTI_PEEK" )

	foreach ( sectionIndex, sectionDef in file.sections )
	{
		bool functionref() isValidFunc = file.sectionIsValidFunc[ sectionIndex ]

		if ( isValidFunc != null )
			Hud_SetVisible( sectionDef.button, isValidFunc() )
	}
}


void function CharacterEmotesPanel_SetHintSub( string hintSub )
{
	if ( hintSub != "" )
		hintSub = "\n\n" + Localize( hintSub )

	RunClientScript( "SetHintTextOnHudElem", Hud_GetChild( file.panel, "HintMKB" ), "#HINT_SOCIAL_WHEEL_MKB", hintSub )
	RunClientScript( "SetHintTextOnHudElem", Hud_GetChild( file.panel, "HintGamepad" ), "#HINT_SOCIAL_WHEEL_GAMEPAD", hintSub )
}


                                                                  
   
   


void function OnFavoredQuipChanged( EHI playerEHI, ItemFlavor flavor )
{
	UpdateFooterOptions()
}


void function EmotesPanel_OnCustomizeContextChanged( var panel )
{
	if ( !IsPanelActive( file.panel ) )
		return

	CharacterEmotesPanel_Update()
}


void function CharacterEmotesPanel_Update()
{
	SectionButton_Activate( file.sections[file.activeSectionIndex].button )
	UpdateNewnessCallbacks()

	ItemFlavor character = GetTopLevelCustomizeContext()
	ItemFlavor characterSkin = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_CharacterSkin( character ) )
	RunClientScript( "UIToClient_PreviewCharacterSkin", ItemFlavor_GetNetworkIndex( characterSkin ), ItemFlavor_GetNetworkIndex( character ) )
}


void function EmotesPanel_OnHide( var panel )
{
	ClearNewnessCallbacks()
	HideVisibleSectionPanels()

	RunClientScript( "ClearBattlePassItem" )

	                                            
	  	                                                                                                                                                           

	for ( int i = 0; i < MAX_FAVORED_QUIPS; i++ )
		RemoveCallback_ItemFlavorLoadoutSlotDidChange_SpecificPlayer( LocalClientEHI(), Loadout_FavoredQuip( GetTopLevelCustomizeContext(), i ), OnFavoredQuipChanged )
}


void function UpdateNewnessCallbacks()
{
	if ( !IsTopLevelCustomizeContextValid() )
		return

	ClearNewnessCallbacks()

	ItemFlavor character = GetTopLevelCustomizeContext()
	foreach ( section in file.sections )
	{
		table<ItemFlavor, Newness_ReverseQuery> ornull q = GetNewnessQueryForSection( section )
		if ( q != null )
		{
			expect table<ItemFlavor, Newness_ReverseQuery>( q )
			Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( q[character], OnNewnessQueryChangedUpdateButton, section.button )
		}
	}
	file.lastNewnessCharacter = character
}


void function ClearNewnessCallbacks()
{
	if ( file.lastNewnessCharacter == null )
		return

	foreach ( section in file.sections )
	{
		table<ItemFlavor, Newness_ReverseQuery> ornull q = GetNewnessQueryForSection( section )
		if ( q != null )
		{
			expect table<ItemFlavor, Newness_ReverseQuery>( q )
			Newness_RemoveCallback_OnRerverseQueryUpdated( q[expect ItemFlavor( file.lastNewnessCharacter )], OnNewnessQueryChangedUpdateButton, section.button )
		}
	}
	file.lastNewnessCharacter = null
}


table<ItemFlavor, Newness_ReverseQuery> ornull function GetNewnessQueryForSection( SectionDef section )
{
	             
	if ( file.sectionToFilters[ section.index ].contains( eItemType.emote_icon ) )
		return NEWNESS_QUERIES.CharacterEmotesHolospraySectionButton
	else if ( file.sectionToFilters[ section.index ].contains( eItemType.skydive_emote ) )
		return NEWNESS_QUERIES.CharacterEmotesSkydiveEmotesSectionButton
	else if ( file.sectionToFilters[ section.index ].contains( eItemType.character_emote ) )
		return NEWNESS_QUERIES.CharacterEmotesStandingEmotesSectionButton

	return null
}
