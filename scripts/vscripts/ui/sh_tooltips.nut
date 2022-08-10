global function Sh_InitToolTips
global function UpdateToolTipElement

global function Hud_SetToolTipData
global function Hud_ClearToolTipData
global function Hud_GetToolTipData
global function Hud_HasToolTipData
global function Hud_ClearAllToolTips

global function AddCallback_OnUpdateTooltip

global function _ToolTips_GetToolTipData
global function _ToolTips_SetToolTipData
global function _ToolTips_HasToolTipData
global function _ToolTips_ClearToolTipData

#if UI
global function ToolTips_AddMenu
global function ToolTips_MenuOpened
global function ToolTips_MenuClosed

global function ToolTips_SetMenuTooltipVisible
global function ToolTips_HideTooltipUntilRefocus

global function ClientToUI_Tooltip_MarkForClientUpdate
global function ClientToUI_Tooltip_Clear
#endif

                                              
const int TOOLTIP_HEIGHT = 192

struct ToolTipElementData
{
	var element
}

struct ToolTipInfo
{
	asset ruiAsset
	bool  hasActionText
}

struct ToolTipMenuData
{
	var menu
	var toolTip
	int toolTipFlags	                                               
}

struct {
	bool enabled = false

	asset currentTooltipRui
	var tooltipRui

	table< string, ToolTipMenuData > menusWithToolTips
	table< int, ToolTipInfo> tooltipInfos

	table< string, ToolTipData > _toolTipElements
	string                     lastFocusElement

	table< int, array<void functionref(int style, ToolTipData)> > onUpdateTooltipCallbacks
}
file

void function Sh_InitToolTips()
{
	file.enabled = GetConVarBool( "gameCursor_ModeActive" )

	#if UI
	UpdateTooltipRui( $"ui/generic_tooltip.rpak" )
	#endif

	ToolTipInfo tooltipInfo

	foreach ( style in eTooltipStyle )
	{
		file.onUpdateTooltipCallbacks[ style ] <- []
		file.tooltipInfos[ style ] <- clone tooltipInfo
	}

	int style

	style = eTooltipStyle.NONE
	file.tooltipInfos[ style ].ruiAsset = $"ui/empty_tooltip.rpak"
	file.tooltipInfos[ style ].hasActionText = false

	style = eTooltipStyle.DEFAULT
	file.tooltipInfos[ style ].ruiAsset = $"ui/generic_tooltip.rpak"
	file.tooltipInfos[ style ].hasActionText = true

	style = eTooltipStyle.LOOT_PROMPT
	file.tooltipInfos[ style ].ruiAsset = LOOT_PICKUP_HINT_DEFAULT_RUI
	file.tooltipInfos[ style ].hasActionText = false

	style = eTooltipStyle.WEAPON_LOOT_PROMPT
	file.tooltipInfos[ style ].ruiAsset = WEAPON_PICKUP_HINT_DEFAULT_RUI
	file.tooltipInfos[ style ].hasActionText = false

	style = eTooltipStyle.BUTTON_PROMPT
	file.tooltipInfos[ style ].ruiAsset = $"ui/button_tooltip.rpak"
	file.tooltipInfos[ style ].hasActionText = true

	style = eTooltipStyle.ACCESSIBLE
	file.tooltipInfos[ style ].ruiAsset = $"ui/accessibility_tooltip.rpak"
	file.tooltipInfos[ style ].hasActionText = true

	style = eTooltipStyle.CRAFTING_INFO
	file.tooltipInfos[ style ].ruiAsset = $"ui/crafting_info_tooltip.rpak"
	file.tooltipInfos[ style ].hasActionText = true

	style = eTooltipStyle.CURRENCY
	file.tooltipInfos[ style ].ruiAsset = $"ui/currency_tooltip.rpak"
	file.tooltipInfos[ style ].hasActionText = true

                       
	style = eTooltipStyle.ARENAS_SHOP_WEAPON
	file.tooltipInfos[ style ].ruiAsset = $"ui/arenas_weapon_tooltip.rpak"
	file.tooltipInfos[ style ].hasActionText = false
      

	style = eTooltipStyle.CLUB_MEMBER
	file.tooltipInfos[ style ].ruiAsset = $"ui/club_member_tooltip.rpak"
	file.tooltipInfos[ style ].hasActionText = true

	style = eTooltipStyle.GLADIATOR_CARD_BADGE
	file.tooltipInfos[ style ].ruiAsset = $"ui/gladiator_card_badge_tooltip.rpak"
	file.tooltipInfos[ style ].hasActionText = true

	style = eTooltipStyle.MINI_PROMO_APEX_PACK
	file.tooltipInfos[ style ].ruiAsset = $"ui/mini_promo_apex_pack_tooltip.rpak"
	file.tooltipInfos[ style ].hasActionText = true

                      
	style = eTooltipStyle.CUSTOM_MATCHES
	file.tooltipInfos[ style ].ruiAsset = $"ui/custom_match_tooltip.rpak"
	file.tooltipInfos[ style ].hasActionText = true
      
}

#if UI
void function ToolTips_AddMenu( var menu )
{
	if ( !Hud_HasChild( menu, "ToolTip" ) )
		return

	ToolTipMenuData menuData
	menuData.menu = menu

	file.menusWithToolTips[string(menu)] <- menuData

	menuData.toolTip = Hud_GetChild( menu, "ToolTip" )

	                                                                                 
	                                             
	   
	  	                                              
	  	                                                                
	  	                                                                  
	  
	  	                              
	  	                             
	  
	  	                                                          
	   

	AddMenuThinkFunc( menu, OnToolTipMenuThink )
}


void function ToolTips_MenuOpened( var menu )
{
	if ( !(string( menu ) in file.menusWithToolTips) )
		return

	ToolTipMenuData menuData = file.menusWithToolTips[string(menu)]

	if ( !GetConVarBool( "gameCursor_ModeActive" ) )
	{
		return
	}
}


void function ToolTips_MenuClosed( var menu )
{
	if ( !(string( menu ) in file.menusWithToolTips) )
		return

	ToolTipMenuData menuData = file.menusWithToolTips[string(menu)]
}


void function ToolTips_SetMenuTooltipVisible( var panel, bool visible )
{
	var menu = panel
	while ( ( menu != null ) && !( string( menu ) in file.menusWithToolTips ) )
	{
		menu = Hud_GetParent( menu )
	}

	if ( string( menu ) in file.menusWithToolTips )
	{
		ToolTipMenuData menuData = file.menusWithToolTips[ string( menu ) ]
		UpdateTooltipFlag( menuData, eToolTipFlag.HIDDEN, !visible )
	}
	else
	{
		Warning( "No tooltip found for panel: %s", string( panel ) )
	}
}

void function UpdateTooltipFlag( ToolTipMenuData menuData, int flag, bool enabled )
{
	menuData.toolTipFlags = enabled ? ( menuData.toolTipFlags | flag ) : ( menuData.toolTipFlags & ~flag )
}

  
                                              
 
	                                                      

	                                                                 
	                                                       
	  	      

	                      

 


                                               
 
	                                                      
	                              
 
  

var s_hideElement = null
void function ToolTips_HideTooltipUntilRefocus( var element )
{
	s_hideElement = element
}

                                                                                                                          
void function OnToolTipMenuThink( var menu )
{
	ToolTipMenuData menuData = file.menusWithToolTips[string(menu)]

	if ( menuData.toolTipFlags & eToolTipFlag.HIDDEN )
	{
		s_hideElement = null
		HideTooltipRui();
		return
	}

	var focusElement = GetMouseFocus()
	if ( focusElement == null || !Hud_HasToolTipData( focusElement ) )
	{
		s_hideElement = null
		HideTooltipRui();
		return
	}

	if ( (s_hideElement != null) && (s_hideElement == focusElement) )
	{
		HideTooltipRui();
		return
	}
	s_hideElement = null

	UpdateToolTipElement( menuData.toolTip, focusElement )

	                                        
}

var function UpdateTooltipRui( asset ruiAsset )
{
	if ( file.currentTooltipRui == ruiAsset )
		return

	file.currentTooltipRui = ruiAsset
	file.tooltipRui = SetTooltipRui( string( ruiAsset ) )
}
#endif

void function Hud_SetToolTipData( var element, ToolTipData toolTipData )
{
	_ToolTips_SetToolTipData( element, toolTipData )
}

void function Hud_ClearAllToolTips()
{
	file._toolTipElements.clear()
}

void function Hud_ClearToolTipData( var element )
{
	_ToolTips_ClearToolTipData( element )
}

ToolTipData function Hud_GetToolTipData( var element )
{
	return _ToolTips_GetToolTipData( element )
}

bool function Hud_HasToolTipData( var element )
{
	return _ToolTips_HasToolTipData( element )
}

void function _ToolTips_SetToolTipData( var element, ToolTipData toolTipData )
{
	if ( !(string(element) in file._toolTipElements) )
		file._toolTipElements[string(element)] <- toolTipData

	file._toolTipElements[string(element)] = toolTipData
}

ToolTipData function _ToolTips_GetToolTipData( var element )
{
	ToolTipData emptyToolTip
	emptyToolTip.tooltipStyle = eTooltipStyle.NONE

	if ( !(string(element) in file._toolTipElements) )
		return emptyToolTip

	return file._toolTipElements[string(element)]
}

bool function _ToolTips_HasToolTipData( var element )
{
	return (string(element) in file._toolTipElements)
}

void function _ToolTips_ClearToolTipData( var element )
{
	if ( !(string(element) in file._toolTipElements) )
		return

	delete file._toolTipElements[string(element)]
}

void function UpdateToolTipElement( var toolTipElement, var focusElement )
{
	if ( !Hud_HasToolTipData( focusElement ) )
		return

	ToolTipData dt = Hud_GetToolTipData( focusElement )

	foreach ( func in file.onUpdateTooltipCallbacks[dt.tooltipStyle] )
	{
		func( dt.tooltipStyle, dt )
	}

	asset ruiAsset = file.tooltipInfos[ dt.tooltipStyle ].ruiAsset

	#if UI
		UpdateTooltipRui( ruiAsset )
		ShowTooltipRui()

		if ( dt.tooltipFlags & eToolTipFlag.CLIENT_UPDATE )
		{
			if ( IsFullyConnected() )
				RunClientScript( "UpdateToolTipElement", toolTipElement, focusElement )
			return
		}
	#endif

	if ( dt.tooltipFlags & eToolTipFlag.HIDDEN )
	{
		HideTooltipRui()
		return
	}

	switch ( dt.commsAction )
	{
		case eCommsAction.INVENTORY_NEED_AMMO_BULLET:
		case eCommsAction.INVENTORY_NEED_AMMO_SPECIAL:
		case eCommsAction.INVENTORY_NEED_AMMO_HIGHCAL:
		case eCommsAction.INVENTORY_NEED_AMMO_SHOTGUN:
                     
                                                  
      
		case eCommsAction.INVENTORY_NEED_AMMO_SNIPER:
		case eCommsAction.INVENTORY_NEED_AMMO_ARROWS:
			dt.commsPromptDefault = IsControllerModeActive() ? "#PING_PROMPT_REQUEST_AMMO_GAMEPAD" : "#PING_PROMPT_REQUEST_AMMO"
	}

	string commsPrompt = dt.commsPromptDefault
	if ( (dt.tooltipFlags & eToolTipFlag.EMPTY_SLOT) || (dt.commsAction != eCommsAction.BLANK) && commsPrompt == "" )
		commsPrompt = IsControllerModeActive() ? "#PING_PROMPT_REQUEST_GAMEPAD" : "#PING_PROMPT_REQUEST"

	var rui = GetTooltipRui()

	if ( file.tooltipInfos[ dt.tooltipStyle ].hasActionText )
	{
		array<string> actionList
		if ( dt.actionHint1 != "" )
			actionList.append( dt.actionHint1 )
		if ( dt.actionHint2 != "" )
			actionList.append( dt.actionHint2 )
		if ( dt.actionHint3 != "" )
			actionList.append( dt.actionHint3 )

		RuiSetString( rui, "titleText", dt.titleText )
		RuiSetString( rui, "descText", dt.descText )
		RuiSetString( rui, "actionText1", actionList.len() > 0 ? actionList[0] : "" )
		RuiSetString( rui, "actionText2", actionList.len() > 1 ? actionList[1] : ""  )
		RuiSetString( rui, "actionText3", actionList.len() > 2 ? actionList[2] : ""  )
		RuiSetString( rui, "commsPrompt", commsPrompt )
		RuiSetInt( rui, "tooltipFlags", dt.tooltipFlags )

		if ( file.lastFocusElement != string(focusElement) )
			RuiSetGameTime( rui, "changeTime", ClientTime() )

		file.lastFocusElement = string(focusElement)
	}
	if ( dt.tooltipStyle == eTooltipStyle.DEFAULT )
	{
		RuiSetInt( rui, "rarity", dt.rarity )
	}

	if ( dt.tooltipStyle == eTooltipStyle.CLUB_MEMBER )
	{
		RuiSetInt( rui, "memberRank", dt.clubMemberData.memberRank )
		RuiSetBool( rui, "isOnline", dt.clubMemberData.isOnline )
		RuiSetBool( rui, "isInGame", dt.clubMemberData.isInGame )
		RuiSetBool( rui, "isInMatch", dt.clubMemberData.isInMatch )
	}

                      
	if ( dt.tooltipStyle == eTooltipStyle.CUSTOM_MATCHES )
	{
		RuiSetBool( rui, "isAdmin", dt.customMatchData.isAdmin )
		RuiSetInt( rui, "adminActions", dt.customMatchData.isAdmin ? dt.customMatchData.adminActions : 0 )
		RuiSetInt( rui, "actionEnabledMask", dt.customMatchData.actionEnabledMask )
	}
      
}

void function AddCallback_OnUpdateTooltip( int style, void functionref(int style, ToolTipData) func )
{
	Assert( !file.onUpdateTooltipCallbacks[ style ].contains( func ) )

	file.onUpdateTooltipCallbacks[ style ].append( func )
}





#if UI
void function ClientToUI_Tooltip_MarkForClientUpdate( var button, int style )
{
	ToolTipData dt
	dt.tooltipFlags = dt.tooltipFlags | eToolTipFlag.CLIENT_UPDATE
	dt.tooltipStyle = style
	Hud_SetToolTipData( button, dt )
}
#endif


#if UI
void function ClientToUI_Tooltip_Clear( var button )
{
	Hud_ClearToolTipData( button )
}
#endif


