global function ShCommsMenu_Init

#if CLIENT
global function CommsMenu_HandleKeyInput
global function ClientCodeCallback_OpenChatWheel
global function SetHintTextOnHudElem

global function PingSecondPageIsEnabled
global function AddCallback_OnCommsMenuStateChanged
global function IsCommsMenuActive

global function CommsMenu_GetMenuForNewPing
global function CommsMenu_ExecuteSelectionIfValid
global function CommsMenu_CanUseMenu
global function CommsMenu_OpenMenuTo
global function CommsMenu_Shutdown
global function CommsMenu_OpenMenuForNewPing
global function CommsMenu_OpenMenuForPingReply
global function CommsMenu_HasValidSelection
global function CommsMenu_ExecuteSelection
global function CommsMenu_GetCurrentCommsMenu
global function CommsMenu_GetMenuRui
global function CommsMenu_RefreshData
                        
                                           
      

global function PerformQuipAtSlot
global function PerformFavoredQuipAtSlot
#endif

#if SERVER
                                                          
#endif

#if CLIENT
global enum eWheelInputType
{
	NONE,
	USE,
	EQUIP,
	REQUEST,
                
	CRAFT,
      

	_count
}

global enum eCommsMenuStyle
{
	PING_MENU,
	PINGREPLY_MENU,
	CHAT_MENU,
	INVENTORY_HEALTH_MENU,
	ORDNANCE_MENU,
	SKYDIVE_EMOTE_MENU,

                
	CRAFTING,
      

	_assertion_marker,

	_count
}

                
Assert( eCommsMenuStyle._assertion_marker == 7 )                            
      

                 
                                                                            
      

global enum eChatPage
{
	INVALID = -1,
	  

	DEFAULT,
	PREMATCH,
	BLEEDING_OUT,

	  
	PING_MAIN_1,
	PING_MAIN_2,
	PING_SKYDIVE,

	  
	PINGREPLY_DEFAULT,

	  
	INVENTORY_HEALTH,
	ORDNANCE_LIST,

	SKYDIVE_EMOTES,

                
	CRAFTING,
                   
	               
        
      
                      
           
      

	_count
}

const string WHEEL_SOUND_ON_OPEN = "UI_MapPing_Menu_Open_1P"
const string WHEEL_SOUND_ON_CLOSE = "menu_back"
const string WHEEL_SOUND_ON_FOCUS = "menu_focus"
const string WHEEL_SOUND_ON_EXECUTE = "menu_accept"
const string WHEEL_SOUND_ON_DENIED = "menu_deny"

                
	global const string WHEEL_SOUND_ON_FOCUS_CRAFTING = "Crafting_Replicator_Menu_Hover"
	global const string WHEEL_SOUND_ON_DENIED_CRAFTING = "Crafting_Replicator_Menu_Deny"
      

#endif   

global const int WHEEL_HEAL_AUTO = -1

                       

struct
{
	#if CLIENT
		var menuRui
		var menuRuiLastShutdown
		int commsMenuStyle                      

		array< void functionref(bool menuOpen) > onCommsMenuStateChangedCallbacks
	#endif          
} file

                       
                  
                       

const string CHAT_MENU_BIND_COMMAND = "+scriptCommand1"

void function ShCommsMenu_Init()
{
	Remote_RegisterServerFunction( "ClientCallback_SetSelectedHealthPickupType", "int", INT_MIN, INT_MAX )

	#if CLIENT
		AddOnDeathCallback( "player", OnDeathCallback )
		AddScoreboardShowCallback( DestroyCommsMenu )
		AddCallback_KillReplayStarted( DestroyCommsMenu )
		AddCallback_GameStateEnter( eGameState.WinnerDetermined, DestroyCommsMenu )
		AddCallback_GameStateEnter( eGameState.Prematch, DestroyCommsMenu )
		AddCallback_ClientOnPlayerConnectionStateChanged( OnPlayerConnectionStateChanged )
		AddCallback_OnPlayerDisconnected( OnPlayerDisconnected )


		AddCallback_OnBleedoutStarted( OnBleedoutStarted )
		AddCallback_OnBleedoutEnded( OnBleedoutEnded )

		AddCallback_OnPlayerMatchStateChanged( OnPlayerMatchStateChanged )

		RegisterConCommandTriggeredCallback( CHAT_MENU_BIND_COMMAND, ChatMenuButton_Down )
		RegisterConCommandTriggeredCallback( "-" + CHAT_MENU_BIND_COMMAND.slice( 1 ), ChatMenuButton_Up )
	#endif          
}

#if CLIENT
bool function PingSecondPageIsEnabled()
{
	return GetCurrentPlaylistVarBool( "ping_second_page_enabled", true )
}

bool function WeaponInspectFromChatPageEnabled()
{
	return GetCurrentPlaylistVarBool( "weapon_inspect_from_page_enabled", true )
}


void function AddCallback_OnCommsMenuStateChanged( void functionref(bool) func )
{
	file.onCommsMenuStateChangedCallbacks.append( func )
}

void function CommsMenu_Shutdown( bool makeSound )
{
	if ( !IsCommsMenuActive() )
		return

	DestroyCommsMenu()

	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return

	if ( !MenuStyleIsFastFadeIn( file.commsMenuStyle ) )
		StopSoundOnEntity( player, WHEEL_SOUND_ON_OPEN )

	if ( makeSound )
		EmitSoundOnEntity( player, WHEEL_SOUND_ON_CLOSE )
}

void function ChatMenuButton_Down( entity player )
{
	if ( !CommsMenu_CanUseMenu( player ) )
		return

	if ( IsCommsMenuActive() )
	{
		if ( CommsMenu_HasValidSelection() )
		{
			CommsMenu_ExecuteSelection( eWheelInputType.NONE )
		}
		CommsMenu_Shutdown( true )
		player.SetLookStickDebounce()
		return
	}

	if ( TryOnscreenPromptFunction( player, "quickchat" ) )
		return

	int ms = PlayerMatchState_GetFor( player )

	if ( !IsFiringRangeGameMode() )
	{
		if ( ms < ePlayerMatchState.SKYDIVE_PRELAUNCH )
			return
	}
	else if ( FiringRange_IsPlayerInFinale() )
	{
		return
	}

	int chatPage = eChatPage.DEFAULT

	if ( GetCurrentPlaylistVarBool( "survival_quick_chat_enabled", true ) )
	{
		CommsMenu_OpenMenuTo( player, chatPage, eCommsMenuStyle.CHAT_MENU )
	}
}

void function ChatMenuButton_Up( entity player )
{
	if ( !IsCommsMenuActive() )
		return
	if ( file.commsMenuStyle != eCommsMenuStyle.CHAT_MENU )
		return

	CommsMenu_ExecuteSelectionIfValid( player, eCommsMenuStyle.CHAT_MENU )
}

void function CommsMenu_ExecuteSelectionIfValid( entity player, int requiredCommsMenuStyle )
{
	if ( file.commsMenuStyle != requiredCommsMenuStyle )
		return

	if ( CommsMenu_HasValidSelection() )
	{
		CommsMenu_ExecuteSelection( eWheelInputType.NONE )
		CommsMenu_Shutdown( true )
	}

	player.SetLookStickDebounce()
}

int function CommsMenu_GetMenuForNewPing( entity player )
{
	int chatPage = eChatPage.PING_MAIN_1

	int ms = PlayerMatchState_GetFor( player )

	if ( (ms == ePlayerMatchState.SKYDIVE_PRELAUNCH) || (ms == ePlayerMatchState.SKYDIVE_FALLING) )
	{
		chatPage = eChatPage.PING_SKYDIVE
	}
	else if ( Bleedout_IsBleedingOut( player ) )
	{
		chatPage = eChatPage.BLEEDING_OUT
	}

	return chatPage
}

void function CommsMenu_OpenMenuForNewPing( entity player, vector targetPos )
{
	int chatPage = eChatPage.PING_MAIN_1

	int ms = PlayerMatchState_GetFor( player )
	if ( (ms == ePlayerMatchState.SKYDIVE_PRELAUNCH) || (ms == ePlayerMatchState.SKYDIVE_FALLING) )
		chatPage = eChatPage.PING_SKYDIVE
	else if ( Bleedout_IsBleedingOut( player ) )
		chatPage = eChatPage.BLEEDING_OUT
	CommsMenu_OpenMenuTo( player, chatPage, eCommsMenuStyle.PING_MENU )

	if ( file.menuRui != null )
		RuiSetFloat3( file.menuRui, "targetPos", targetPos )
}

entity s_focusWaypoint = null
void function CommsMenu_OpenMenuForPingReply( entity player, entity wp )
{
	CommsMenu_OpenMenuTo( player, eChatPage.PINGREPLY_DEFAULT, eCommsMenuStyle.PINGREPLY_MENU )

	if ( IsValid( wp ) )
	{
		if ( file.menuRui != null )
		{
			int wpt = wp.GetWaypointType()
			if ( wpt == eWaypoint.PING_LOOT )
			{
				entity lootItem = Waypoint_GetItemEntForLootWaypoint( wp )
				if ( IsValid( lootItem ) )
					RuiTrackFloat3( file.menuRui, "targetPos", lootItem, RUI_TRACK_ABSORIGIN_FOLLOW )
				else
					RuiSetFloat3( file.menuRui, "targetPos", <0, 0, 0> )
			}
			else if ( wpt == eWaypoint.PING_LOCATION )
			{
				RuiTrackFloat3( file.menuRui, "targetPos", wp, RUI_TRACK_ABSORIGIN_FOLLOW )
			}
			else
			{
			}
		}

		SetFocusedWaypointForced( wp )
		RuiSetBool( wp.wp.ruiHud, "hasWheelFocus", true )
		s_focusWaypoint = wp
	}
}

void function CommsMenu_OpenMenuTo( entity player, int chatPage, int commsMenuStyle, bool debounce = true )
{
	                             
	CommsMenu_Shutdown( true )

	file.commsMenuStyle = commsMenuStyle

	ResetViewInput()

	                                                                           
	if ( file.menuRuiLastShutdown != null )
	{
		RuiDestroyIfAlive( file.menuRuiLastShutdown )
		file.menuRuiLastShutdown = null
	}

	file.menuRui = CreateFullscreenRui( $"ui/comms_menu.rpak", RUI_SORT_SCREENFADE - 2 )

	HudInputContext inputContext
	inputContext.keyInputCallback = CommsMenu_HandleKeyInput

                
	bool shouldChangeMoveInputCallback = chatPage == eChatPage.SKYDIVE_EMOTES || chatPage == eChatPage.CRAFTING
     
                                                                          
      

	if ( shouldChangeMoveInputCallback )
	{
		inputContext.moveInputCallback = CommsMenu_HandleMoveInputControllerOnly
	}

	inputContext.viewInputCallback = CommsMenu_HandleViewInput
	inputContext.hudInputFlags = (HIF_BLOCK_WAYPOINT_FOCUS)
	HudInput_PushContext( inputContext )

	if ( debounce )
		player.SetLookStickDebounce()

	float soundDelay = MenuStyleIsFastFadeIn( file.commsMenuStyle ) ? 0.0 : 0.1
	EmitSoundOnEntityAfterDelay( GetLocalViewPlayer(), WHEEL_SOUND_ON_OPEN, soundDelay )

	ShowCommsMenu( chatPage )
}

int function GetEffectiveChoice()
{
	int effectiveChoice = s_currentChoice

	float delta = (Time() - s_latestValidChoiceTime)
	if ( delta < 0.15 )
		effectiveChoice = s_latestValidChoice

	effectiveChoice = ModifyEffectiveChoiceForCurrentMenu( effectiveChoice )

	return effectiveChoice
}

int function ModifyEffectiveChoiceForCurrentMenu( int choice )
{
	if ( file.commsMenuStyle == eCommsMenuStyle.SKYDIVE_EMOTE_MENU )
	{
		if ( choice < 0 )
			return RandomInt( s_currentMenuOptions.len() )
	}

	return choice
}

bool function CommsMenu_HasValidSelection()
{
	if ( !IsCommsMenuActive() )
		return false

	int choice = GetEffectiveChoice()
	if ( (choice < 0) || (choice >= s_currentMenuOptions.len()) )
		return false

	return true
}

bool function CommsMenu_ExecuteSelection( int wheelInputType )
{
	if ( !CommsMenu_HasValidSelection() )
		return false

	int choice       = GetEffectiveChoice()
	bool didAnything = MakeCommMenuSelection( choice, wheelInputType )
	return didAnything
}

enum eOptionType
{
	DO_NOTHING,

	COMMSACTION,
	NEW_PING,
	PING_REPLY,

	QUIP,
	SKYDIVE_EMOTE,
	HEALTHITEM_USE,
	ORDNANCE_EQUIP,
                
	CRAFT,
      
	WEAPON_INSPECT,
                      
           
      
	_count
}

struct CommsMenuOptionData
{
	int optionType

	int chatPage
	int commsAction

	int pingType

	int pingReply

	int healType

	int craftingIndex = -1
                      
                  
      
	ItemFlavor    ornull    emote
}

CommsMenuOptionData function MakeOption_NoOp()
{
	CommsMenuOptionData op
	op.optionType = eOptionType.DO_NOTHING
	return op
}

CommsMenuOptionData function MakeOption_CommsAction( int commsAction )
{
	CommsMenuOptionData op
	op.optionType = eOptionType.COMMSACTION
	op.commsAction = commsAction
	return op
}

                                   
CommsMenuOptionData function MakeOption_WeaponInspect()
{
	CommsMenuOptionData op
	op.optionType = eOptionType.WEAPON_INSPECT
	return op
}

CommsMenuOptionData function MakeOption_Quip( ItemFlavor quip, int index )
{
	CommsMenuOptionData op
	op.optionType = eOptionType.QUIP
	op.emote = quip
	op.healType = index
	return op
}

CommsMenuOptionData function MakeOption_SkydiveEmote( ItemFlavor quip, int index )
{
	CommsMenuOptionData op
	op.optionType = eOptionType.SKYDIVE_EMOTE
	op.emote = quip
	op.healType = index
	return op
}

CommsMenuOptionData function MakeOption_PingReply( int pingReply )
{
	CommsMenuOptionData op
	op.optionType = eOptionType.PING_REPLY
	op.pingReply = pingReply
	return op
}

CommsMenuOptionData function MakeOption_UseHealItem( int healType )
{
	CommsMenuOptionData op
	op.optionType = eOptionType.HEALTHITEM_USE
	op.healType = healType
	return op
}

CommsMenuOptionData function MakeOption_SwitchToOrdnance( int ordnanceIndex )
{
	CommsMenuOptionData op
	op.optionType = eOptionType.ORDNANCE_EQUIP
	op.healType = ordnanceIndex
	return op
}

CommsMenuOptionData function MakeOption_Ping( int pingType )
{
	CommsMenuOptionData op
	op.optionType = eOptionType.NEW_PING
	op.pingType = pingType
	return op
}

                
CommsMenuOptionData function MakeOption_CraftItem( int itemIndex )
{
	CommsMenuOptionData op
	op.optionType = eOptionType.CRAFT
	op.craftingIndex = itemIndex
	return op
}
      

                      
                                                                 
 
                       
                                      
                             
          
 
      

array<CommsMenuOptionData> function BuildMenuOptions( int chatPage )
{
	array<CommsMenuOptionData> results
	entity player = GetLocalViewPlayer()
	switch ( chatPage )
	{
		case eChatPage.DEFAULT:
		case eChatPage.PING_MAIN_2:
		{
			EHI playerEHI = ToEHI( player )

			if ( !IsShowingVictorySequence() )
				results.append( MakeOption_CommsAction( eCommsAction.QUICKCHAT_CELEBRATE ) )

			if ( IsControllerModeActive() )
			{
				results.append( MakeOption_WeaponInspect() )
			}

			if ( !LoadoutSlot_IsReady( playerEHI, Loadout_Character() ) )
			{
				break
			}

			ItemFlavor character = LoadoutSlot_GetItemFlavor( playerEHI, Loadout_Character() )
			ItemFlavor ornull emptyQuip
			int quipsInWheel
			for ( int i = 0; i < MAX_QUIPS_EQUIPPED; i++ )
			{
				LoadoutEntry entry = Loadout_CharacterQuip( character, i )
				ItemFlavor quip    = LoadoutSlot_GetItemFlavor( playerEHI, entry )
				if ( !CharacterQuip_IsTheEmpty( quip ) )
				{
					if ( IsShowingVictorySequence() && ItemFlavor_GetType( quip ) != eItemType.character_emote )
						continue

					quipsInWheel++
					results.append( MakeOption_Quip( quip, i ) )
				}
				else
				{
					emptyQuip = quip
				}
			}

			if ( quipsInWheel == 0 && emptyQuip != null )
			{
				expect ItemFlavor( emptyQuip )
				results.append( MakeOption_Quip( emptyQuip, quipsInWheel ) )
			}
		}
			break

		case eChatPage.SKYDIVE_EMOTES:
			table<int, ItemFlavor> emotes = GetValidPlayerSkydiveEmotes( player )
			foreach ( index, emote in emotes )
			{
				if ( !SkydiveEmote_IsTheEmpty( emote ) )
					results.append( MakeOption_SkydiveEmote( emote, index ) )
			}
			break

		case eChatPage.PREMATCH:
		{
			results.append( MakeOption_NoOp() )
			results.append( MakeOption_NoOp() )
		}
			break

		case eChatPage.BLEEDING_OUT:
		{
			results.append( MakeOption_CommsAction( eCommsAction.QUICKCHAT_BLEEDOUT_HELP ) )
			results.append( MakeOption_Ping( ePingType.I_GO ) )
			results.append( MakeOption_Ping( ePingType.ENEMY_GENERAL ) )
			                                                                                      
		}
			break

		case eChatPage.PING_MAIN_1:
		{
			results.append( MakeOption_Ping( ePingType.WE_GO ) )
			results.append( MakeOption_Ping( ePingType.ENEMY_GENERAL ) )
			results.append( MakeOption_Ping( ePingType.I_LOOTING ) )
			results.append( MakeOption_Ping( ePingType.I_ATTACKING ) )
			results.append( MakeOption_Ping( ePingType.I_GO ) )
			results.append( MakeOption_Ping( ePingType.I_DEFENDING ) )
			results.append( MakeOption_Ping( ePingType.I_WATCHING ) )
			results.append( MakeOption_Ping( ePingType.AREA_VISITED ) )
		}
			break

		case eChatPage.PING_SKYDIVE:
		{
			results.append( MakeOption_Ping( ePingType.ENEMY_GENERAL ) )
			results.append( MakeOption_Ping( ePingType.I_GO ) )
			  			                                                    
		}
			break

		case eChatPage.INVENTORY_HEALTH:
		{
			if ( GetCurrentPlaylistVarBool( "auto_heal_option", false ) )
				results.append( MakeOption_UseHealItem( WHEEL_HEAL_AUTO ) )
			{
				results.append( MakeOption_UseHealItem( eHealthPickupType.COMBO_FULL ) )
				results.append( MakeOption_UseHealItem( eHealthPickupType.SHIELD_SMALL ) )
				results.append( MakeOption_UseHealItem( eHealthPickupType.SHIELD_LARGE ) )

                            
                                                                                              

                                                        
                                                                                         
                                                             
                                                                                          
        
                                                                                         
          

				results.append( MakeOption_UseHealItem( eHealthPickupType.HEALTH_SMALL ) )
				results.append( MakeOption_UseHealItem( eHealthPickupType.HEALTH_LARGE ) )
			}
			break
		}

		case eChatPage.ORDNANCE_LIST:
		{
			table<string, LootData> allLootData = SURVIVAL_Loot_GetLootDataTable()

			foreach ( data in allLootData )
			{
				if ( SURVIVAL_Loot_IsRefDisabled( data.ref ) )
					continue

				if ( !IsLootTypeValid( data.lootType ) )
					continue

				if ( data.lootType != eLootType.ORDNANCE )
					continue

				                                                                                                                           
				if ( data.conditional )
				{
					if ( !SURVIVAL_Loot_RunConditionalCheck( data.ref, player ) )
						continue
				}

				if ( data.isDynamic && SURVIVAL_CountItemsInInventory( player, data.ref ) == 0 )
					continue

				results.append( MakeOption_SwitchToOrdnance( data.index ) )
			}
		}
			break

		case eChatPage.PINGREPLY_DEFAULT:
		{
			array<int> pingReplies = Ping_GetOptionsForPendingReply( player )
			foreach ( int pingReply in pingReplies )
			{
				if ( (pingReply == ePingReply.BLANK) && (results.len() == 0) )
					continue

				results.append( MakeOption_PingReply( pingReply ) )
			}
		}
			break

                  
		case eChatPage.CRAFTING:
		{
			int counter = 0
			foreach( data in Crafting_GetCraftingDataArray() )
			{
				                   
				                                                                  
				 
					                                         
					 
						                                                 
						         
					 
				 
				       
				for ( int i = 0; i < data.numSlots; i++ )
				{
					results.append( MakeOption_CraftItem( counter ) )
					counter++
				}
			}
			break
		}
		                   
		                              
		 
			                
			                                                  
			 
				                                                                  
				 
					                                         
					 
						                                                 
						         
					 
				 
			 
			     
		 
		        
        
                        
                           
   
                                   
    
                                                     
    
   
        
	}

	return results
}

array<CommsMenuOptionData> s_currentMenuOptions
int s_currentChatPage = eChatPage.INVALID
int s_previousChatPage = eChatPage.INVALID

string[2] function GetPromptsForMenuOption( int index )
{
	string[2] promptTexts

	if ( (index < 0) || (index >= s_currentMenuOptions.len()) )
		return promptTexts
	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return promptTexts

	CommsMenuOptionData op = s_currentMenuOptions[index]
	switch( op.optionType )
	{
		case eOptionType.COMMSACTION:
			promptTexts[0] = GetMenuOptionTextForCommsAction( op.commsAction )
			break

		case eOptionType.QUIP:
		case eOptionType.SKYDIVE_EMOTE:
			promptTexts[0] = Localize( ItemFlavor_GetLongName( expect ItemFlavor( op.emote ) ) )
			break

		case eOptionType.NEW_PING:
			promptTexts[0] = Ping_GetMenuOptionTextForPing( op.pingType )
			break

		case eOptionType.PING_REPLY:
			entity wp = Ping_GetPendingPingReplyWaypoint()
			ReplyCommsActionInfo caInfo = Ping_GetCommsActionForWaypointReply( player, wp, op.pingReply )
			promptTexts[0] = GetMenuOptionTextForCommsAction( caInfo.commsAction )
			break

		case eOptionType.HEALTHITEM_USE:
			promptTexts[0] = GetNameForHealthItem( op.healType )
			promptTexts[1] = GetDescForHealthItem( op.healType )
			break

		case eOptionType.ORDNANCE_EQUIP:
		{
			if ( op.healType == -1 )
			{
				promptTexts[0] = "#MELEE"
			}
			else
			{
				LootData data = SURVIVAL_Loot_GetLootDataByIndex( op.healType )
				int count     = SURVIVAL_CountItemsInInventory( player, data.ref )
				promptTexts[0] = data.pickupString
				promptTexts[1] = SURVIVAL_Loot_GetDesc( data, player )
			}
			break
		}

		case eOptionType.WEAPON_INSPECT:
		{
			entity weapon 		= player.GetActiveWeapon( eActiveInventorySlot.mainHand )
			string wpnText 		= Localize("#INSPECT_WEAPON")
			LootData weaponData = SURVIVAL_GetLootDataFromWeapon( weapon )

			if ( IsValid( weapon ) )
			{
				int wpnType = weapon.GetWeaponType()
				if ( ( weapon.GetWeaponClassName() == "mp_weapon_melee_survival" ) || ( wpnType == WT_GADGET ) )
				{
					                            
					promptTexts[0] = wpnText
				}
				else
				{
					promptTexts[0] = wpnText
					promptTexts[1] = weaponData.pickupString
				}

			}
			break
		}

                  
		case eOptionType.CRAFT:
		{
			array<string> validItems = Crafting_GetLootDataFromIndex( op.craftingIndex, player )
			if ( validItems.len() > 0 )
			{
				if ( validItems[0] == "evo_points" )
				{
					promptTexts[0] = Localize( "#CRAFTING_EVO_POINTS" )
					promptTexts[1] = Localize( "#CRAFTING_EVO_POINTS_DESC", GetCurrentPlaylistVarInt( "crafting_override_evo_grant", CRAFTING_EVO_GRANT ) )

					LootData existingArmorData = EquipmentSlot_GetEquippedLootDataForSlot( GetLocalClientPlayer(), "armor" )
					if ( existingArmorData.ref.find( "evolving" ) == -1 )
					{
						promptTexts[1] = Localize( "#CRAFTING_EVO_POINTS_FAIL_DESC" )
					}
					else
					{
						if ( existingArmorData.tier >= 5 )
							promptTexts[1] = Localize( "#CRAFTING_EVO_POINTS_FAIL_DESC" )
					}
				}
                       
                                                  
     
                               
                                                            
     
          
				else
				{
					LootData data = SURVIVAL_Loot_GetLootDataByRef( validItems[0] )
					promptTexts[0] = Localize( data.pickupString )
					if ( data.passive == ePassives.INVALID )
					{
						promptTexts[1] = SURVIVAL_Loot_GetDesc( data, player )
					} else {
						promptTexts[1] = Localize( PASSIVE_DESCRIPTION_SHORT_MAP[data.passive] )
					}

					if ( validItems.len() > 1 && validItems[1] != "")
					{
						LootData altData = SURVIVAL_Loot_GetLootDataByRef( validItems[1] )
						promptTexts[1] = promptTexts[0] + " + " + Localize( altData.pickupString )
						promptTexts[0] = Localize( "#LOOT_CAT_AMMO" )
					}
				}
			}
			break
		}
        
                        
                             
                                               
                      
        
	}

	return promptTexts
}

bool function ShouldPopulateRuiForIndex( int index )
{
	CommsMenuOptionData op = s_currentMenuOptions[index]
	switch( op.optionType )
	{
		case eOptionType.QUIP:
			ItemFlavor data = expect ItemFlavor( op.emote )
			int type = ItemFlavor_GetType( data )
			switch ( type )
			{
				case eItemType.emote_icon:
					return false
			}
			return false
	}

	return true
}

var function GetRuiForMenuOption( var mainRui, int index )
{
	CommsMenuOptionData op = s_currentMenuOptions[index]

	switch ( op.optionType )
	{
		case eOptionType.QUIP:
			ItemFlavor data = expect ItemFlavor( op.emote )
			return CreateNestedRuiForQuip( mainRui, "iconHandle" + index, data )

                  
		case eOptionType.CRAFT:
			                                         
			asset craftingAsset = $"ui/comms_menu_icon_crafting.rpak"
			return RuiCreateNested( mainRui, "iconHandle" + index, craftingAsset )
        

		case eOptionType.WEAPON_INSPECT:
			                                       
			asset weaponAsset = $"ui/comms_menu_icon_weapon_inspect.rpak"
			return RuiCreateNested( mainRui, "iconHandle" + index, weaponAsset )
	}

	return RuiCreateNested( mainRui, "iconHandle" + index, $"ui/comms_menu_icon_default.rpak" )
}

asset function GetIconForMenuOption( int index )
{
	if ( (index < 0) || (index >= s_currentMenuOptions.len()) )
		return $""

	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return $""

	CommsMenuOptionData op = s_currentMenuOptions[index]
	switch( op.optionType )
	{
		case eOptionType.COMMSACTION:
			return GetDefaultIconForCommsAction( op.commsAction )

		case eOptionType.SKYDIVE_EMOTE:
			ItemFlavor data = expect ItemFlavor( op.emote )
			return ItemFlavor_GetIcon( data )

		case eOptionType.QUIP:
			ItemFlavor data = expect ItemFlavor( op.emote )
			if ( CharacterQuip_IsTheEmpty( data ) )
				return $""
			int type = ItemFlavor_GetType( data )
			switch ( type )
			{
				case eItemType.gladiator_card_kill_quip:
				case eItemType.gladiator_card_intro_quip:
					return $""
			}
			return ItemFlavor_GetIcon( data )

		case eOptionType.NEW_PING:
		{
			entity targetEnt = Ping_GetPendingNewPingTargetEnt()
			return Ping_IconForPing_Hud( player, op.pingType, targetEnt, player )
		}

		case eOptionType.PING_REPLY:
		{
			entity wp                   = Ping_GetPendingPingReplyWaypoint()
			ReplyCommsActionInfo caInfo = Ping_GetCommsActionForWaypointReply( player, wp, op.pingReply )
			return GetDefaultIconForCommsAction( caInfo.commsAction )
		}

		case eOptionType.HEALTHITEM_USE:
		{
			return GetIconForHealthItem( op.healType )
		}

		case eOptionType.ORDNANCE_EQUIP:
		{
			if ( op.healType == -1 )
			{
				return $"rui/menu/dpad_comms/emoji/fist"
			}

			LootData data = SURVIVAL_Loot_GetLootDataByIndex( op.healType )
			return data.hudIcon
		}

		case eOptionType.WEAPON_INSPECT:
		{
			return $"rui/weapon_icons/r5/weapon_inspect"
		}
                        
                             
   
                                               
   
        
	}

	return $""
}


vector function GetIconColorForMenuOption( int index )
{
	if ( (index < 0) || (index >= s_currentMenuOptions.len()) )
		return <0, 0, 0>

	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return <0, 0, 0>

	CommsMenuOptionData op = s_currentMenuOptions[index]
	switch( op.optionType )
	{
		case eOptionType.NEW_PING:
		{
			entity targetEnt = Ping_GetPendingNewPingTargetEnt()

			ItemFlavor ornull pingFlavor = Ping_ItemFlavorForPing( GetLocalViewPlayer(), op.pingType, targetEnt )
			if ( pingFlavor != null )
			{
				expect ItemFlavor( pingFlavor )
				return PingFlavor_GetColor( pingFlavor, GetLocalViewPlayer().GetTeamMemberIndex() )
			}
			else
			{
				return Ping_IconColorForPing_Hud( op.pingType, true )
			}
		}
	}

	return <1, 1, 1>
}

asset function GetIconForHealthItem( int itemType )
{
	if ( WeaponDrivenConsumablesEnabled() )
	{
		ConsumableInfo info = Consumable_GetConsumableInfo( itemType )
		return info.lootData.hudIcon
	}
	else
	{
		if ( itemType ==  WHEEL_HEAL_AUTO )
			return $"rui/hud/gametype_icons/survival/health_pack_auto"

		HealthPickup kit = SURVIVAL_Loot_GetHealthKitDataFromStruct( itemType )
		return kit.lootData.hudIcon
	}

	unreachable
}


int function GetHealthItemTypeForWheelIndex( int wheelIndex )
{
	if ( wheelIndex == 0 )
		return eHealthPickupType.COMBO_FULL
	else if ( wheelIndex == 1 )
		return eHealthPickupType.SHIELD_LARGE
	else if ( wheelIndex == 2 )
		return eHealthPickupType.SHIELD_SMALL
	else if ( wheelIndex == 3 )
		return eHealthPickupType.HEALTH_LARGE
	else if ( wheelIndex == 4 )
		return eHealthPickupType.HEALTH_SMALL

	unreachable
}


string function GetCountStringForHealthItem( int itemType )
{
	entity player = GetLocalViewPlayer()
	return(string( GetCountForHealthItem( player, itemType ) ))
}


int function GetCountForHealthItem( entity player, int itemType )
{
	if ( itemType ==  WHEEL_HEAL_AUTO )
	{
		int totalHeals = SURVIVAL_Loot_GetTotalHealthItems( player )
		return totalHeals
	}

	string itemRef = ""

	if ( WeaponDrivenConsumablesEnabled() )
	{
		itemRef = Consumable_GetConsumableInfo( itemType ).lootData.ref
	}
	else
	{
		itemRef = SURVIVAL_Loot_GetHealthKitDataFromStruct( itemType ).lootData.ref
	}
                         
                                                       
  
                                                        
           
      
           
  
       
	return SURVIVAL_CountItemsInInventory( player, itemRef )
}

string function GetNameForHealthItem( int itemType )
{
	if ( itemType ==  WHEEL_HEAL_AUTO )
		return "Automatic"

	if ( WeaponDrivenConsumablesEnabled() )
	{
		ConsumableInfo info = Consumable_GetConsumableInfo( itemType )
		return Localize( info.lootData.pickupString )
	}
	else
	{
		HealthPickup kit = SURVIVAL_Loot_GetHealthKitDataFromStruct( itemType )
		return Localize( kit.lootData.pickupString )
	}
	unreachable
}


string function GetDescForHealthItem( int itemType )
{
	if ( itemType == WHEEL_HEAL_AUTO )
		return ""

	string desc = ""
	if ( WeaponDrivenConsumablesEnabled() )
	{
		ConsumableInfo info = Consumable_GetConsumableInfo( itemType )
		desc = SURVIVAL_Loot_GetDesc( info.lootData, GetLocalViewPlayer() )
	}
	else
	{
		HealthPickup kit = SURVIVAL_Loot_GetHealthKitDataFromStruct( itemType )
		desc = SURVIVAL_Loot_GetDesc( kit.lootData, GetLocalViewPlayer() )
	}

	return desc
}


bool function MenuStyleIsFastFadeIn( int menuStyle )
{
	switch ( file.commsMenuStyle )
	{
		case eCommsMenuStyle.CHAT_MENU:
		case eCommsMenuStyle.INVENTORY_HEALTH_MENU:
                  
		case eCommsMenuStyle.CRAFTING:
        
			return true
	}
	return false
}

bool function MenuStyleHasBlurredBackground( int menuStyle )
{
	switch( file.commsMenuStyle )
	{
                  
		case eCommsMenuStyle.CRAFTING:
			return true
        
		default:
			return false
	}
	return false
}

void function SetRuiOptionsForChatPage( var rui, int chatPage )
{
	string labelText        = ""
	string backText         = "#BUTTON_WHEEL_CANCEL"
	string promptText       = "#A_BUTTON_ACCEPT"
	string nextPageText     = ""
	bool showNextPageText   = false
	bool shouldShowLine     = false
	vector outerCircleColor = <0.0, 0.0, 0.0>

	switch( chatPage )
	{
		case eChatPage.DEFAULT:
		case eChatPage.PREMATCH:
		case eChatPage.BLEEDING_OUT:
			labelText = "#COMMS_QUICK_CHAT"
			promptText = "#COMMS_USE"
			backText = "#COMMS_BACK"
			outerCircleColor = <25, 0, 15>
			break

		case eChatPage.PING_MAIN_1:
			labelText = "#COMMS_PING"
			promptText = " "
			showNextPageText = PingSecondPageIsEnabled()
			nextPageText = "#COMMS_NEXT"
			backText = "#COMMS_BACK"
			shouldShowLine = true
			outerCircleColor = <0, 0, 21>
			break

		case eChatPage.PING_MAIN_2:
			labelText = "#COMMS_QUICK_CHAT"
			promptText = " "
			showNextPageText = s_previousChatPage != eChatPage.INVALID
			nextPageText = "#COMMS_PREV"
			backText = "#COMMS_BACK"
			shouldShowLine = true
			outerCircleColor = <25, 32, 25>
			break

		case eChatPage.PING_SKYDIVE:
			labelText = "#COMMS_PING"
			promptText = " "
			showNextPageText = PingSecondPageIsEnabled()
			nextPageText = "#COMMS_NEXT"
			shouldShowLine = true
			outerCircleColor = <0, 0, 21>
			break

		case eChatPage.PINGREPLY_DEFAULT:
			shouldShowLine = true
			promptText = " "
			outerCircleColor = <0, 15, 32>
			break

		case eChatPage.INVENTORY_HEALTH:
			labelText = "#COMMS_HEALTH_KITS"
			                                  
			  	                          
			      
			promptText = "#LOOT_USE"
			outerCircleColor = <25, 0, 15>
			break

		case eChatPage.ORDNANCE_LIST:
			labelText = "#COMMS_ORDNANCE"
			promptText = "#LOOT_EQUIP"
			break

		case eChatPage.SKYDIVE_EMOTES:
			labelText = "#COMMS_SKYDIVE_EMOTES"
			promptText = "#LOOT_USE"
			break
                  
		case eChatPage.CRAFTING:
			RuiSetString( file.menuRui, "lowerHeader", Localize( "#CRAFTING_BALANCE", Crafting_GetPlayerCraftingMaterials( GetLocalClientPlayer() ) ) )
			RuiSetString( file.menuRui, "headerText", Crafting_GetWorkbenchTitleString() )
			RuiSetString( file.menuRui, "descText", Crafting_GetWorkbenchDescString() )
			labelText = "#CRAFTING_WORKBENCH"
			promptText = "#CRAFTING_USE"

			                   
			                                                                                       
			 
				                                                           
					        

				                       
				                               
			 
			        

			outerCircleColor = <25, 0, 15>
			break

			                   
		                              
			                                                                                                                                           
			                                                                           
			                                                                           
			                                 
			                            

			                                                                                       
			 
				                                                           
					        

				                       
				                               
			 


			                              
			     
			        
        

                        
                           
                             
                              
        
	}

	RuiSetString( rui, "labelText", labelText )
	RuiSetString( rui, "promptText", promptText )
	RuiSetString( rui, "backText", backText )
	RuiSetBool( rui, "shouldShowLine", shouldShowLine )
	RuiSetBool( rui, "showNextPageText", showNextPageText )
	RuiSetString( rui, "nextPageText", nextPageText )
	RuiSetFloat3( rui, "outerCircleColor", SrgbToLinear( outerCircleColor / 255.0 ) )                                                                           
}

const int MAX_COMMS_MENU_OPTIONS = 11
void function ShowCommsMenu( int chatPage )
{
	RunUIScript( "ClientToUI_SetCommsMenuOpen", true )

	var rui = file.menuRui

	array<CommsMenuOptionData> options = BuildMenuOptions( chatPage )
	s_currentMenuOptions = options
	s_previousChatPage = s_currentChatPage
	s_currentChatPage = chatPage

	SetRuiOptionsForChatPage( rui, chatPage )

	int optionCount = options.len()

	for ( int idx = 0; idx < MAX_COMMS_MENU_OPTIONS; ++idx )
	{
		RuiDestroyNestedIfAlive( rui, "iconHandle" + idx )

		if ( idx >= s_currentMenuOptions.len() )
			continue

		var nestedRui = GetRuiForMenuOption( rui, idx )

		bool shouldPopulate = ShouldPopulateRuiForIndex( idx )
		if ( !shouldPopulate )
			continue
		asset icon       = GetIconForMenuOption( idx )
		vector iconColor = SrgbToLinear( GetIconColorForMenuOption( idx ) )
		RuiSetImage( nestedRui, "icon", icon )
		RuiSetInt( nestedRui, "tier", 0 )
		RuiSetFloat3( nestedRui, "iconColor", iconColor )
		RuiSetString( nestedRui, "centerText", "" )

		CommsMenuOptionData op = s_currentMenuOptions[idx]
		if ( op.emote != null )
		{
			ItemFlavor flav = expect ItemFlavor( op.emote )
			string txt      = CharacterQuip_ShortenTextForCommsMenu( flav )
			RuiSetString( nestedRui, "centerText", txt )
		}

		if ( chatPage == eChatPage.INVENTORY_HEALTH )
		{
			string countText = GetCountStringForHealthItem( options[idx].healType )
			if ( PlayerHasPassive( GetLocalViewPlayer(), ePassives.PAS_INFINITE_HEAL ) && countText != "0" )
				countText = "%$models/weapons/attachments/infinity_symbol%"

                  
				if ( StatusEffect_GetSeverity( GetLocalViewPlayer(), eStatusEffect.healing_denied ) )
				{
					bool isBlocked = Consumable_IsShieldItem( options[idx].healType )
					RuiSetBool( nestedRui, "isBlocked", isBlocked )
				}
         

			RuiSetString( nestedRui, "text", countText )
			int tier      = -1
			int itemCount = GetCountForHealthItem( GetLocalViewPlayer(), options[idx].healType )
			if ( itemCount > 0 )
			{
				                                    
				  	                                                                                      
				      
				tier = 0
			}

			RuiSetInt( nestedRui, "tier", tier )
			RuiSetBool( nestedRui, "isEnabled", itemCount > 0 )
		}
		else if ( chatPage == eChatPage.ORDNANCE_LIST )
		{
			int index = options[idx].healType

			if ( index != -1 )
			{
				LootData data    = SURVIVAL_Loot_GetLootDataByIndex( index )
				int itemCount    = SURVIVAL_CountItemsInInventory( GetLocalViewPlayer(), data.ref )
				string countText = string( itemCount )
				RuiSetString( nestedRui, "text", countText )

				int tier = -1
				if ( itemCount > 0 )
					tier = 0
				RuiSetInt( nestedRui, "tier", tier )
				RuiSetBool( nestedRui, "isEnabled", itemCount > 0 )
			}
		}
                  
		else if ( chatPage == eChatPage.CRAFTING )
		{
			int index = options[idx].craftingIndex
			Crafting_PopulateItemRuiAtIndex( nestedRui, index )
		}
		                   
		                                                
		 
			                                      
			                                                   
		 
		        
        
	}

	RuiSetInt( rui, "optionCount", options.len() )
	RuiSetInt( rui, "commMenuType", chatPage )

	foreach ( func in file.onCommsMenuStateChangedCallbacks )
		func( true )

	RuiSetBool( rui, "doFastFadeIn", MenuStyleIsFastFadeIn( file.commsMenuStyle ) )
	RuiSetBool( rui, "shouldBlurBackground", MenuStyleHasBlurredBackground( file.commsMenuStyle ) )

	if ( (chatPage == eChatPage.INVENTORY_HEALTH) )
	{
		entity player = GetLocalViewPlayer()

		int healthPickupType = Survival_Health_GetSelectedHealthPickupType()

		RuiSetInt( rui, "selectedSlot", -1 )
		for ( int idx = 0; idx < options.len(); ++idx )
		{
			if ( options[idx].healType != healthPickupType )
				continue

			RuiSetInt( rui, "selectedSlot", idx )
			break
		}
	}
	else if ( (chatPage == eChatPage.ORDNANCE_LIST) )
	{
		entity player      = GetLocalViewPlayer()
		entity weapon      = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_ANTI_TITAN )
		string equippedRef = IsValid( weapon ) ? weapon.GetWeaponClassName() : ""

		int healthPickupType = Survival_Health_GetSelectedHealthPickupType()

		RuiSetInt( rui, "selectedSlot", -1 )
		for ( int idx = 0; idx < options.len(); ++idx )
		{
			int index = options[idx].healType
			if ( index <= -1 )
				continue

			LootData data = SURVIVAL_Loot_GetLootDataByIndex( index )
			if ( data.ref != equippedRef )
				continue

			if ( SURVIVAL_CountItemsInInventory( player, data.ref ) == 0 )
				continue

			RuiSetInt( rui, "selectedSlot", idx )
			break
		}
	}
}

void function CommsMenu_RefreshData()
{
	if ( file.menuRui == null )
		return

	switch ( file.commsMenuStyle )
	{
                
		case eCommsMenuStyle.CRAFTING:
			RuiSetString( file.menuRui, "lowerHeader", Localize( "#CRAFTING_BALANCE", Crafting_GetPlayerCraftingMaterials( GetLocalClientPlayer() ) ) )
			RuiSetString( file.menuRui, "descText", Crafting_GetWorkbenchDescString() )
			break
                          
	}
}

void function ClientCodeCallback_OpenChatWheel()
{
	ChatMenuButton_Down( GetLocalClientPlayer() )
}

float s_pageSwitchTime = 0.0
const float BUTTON_PAIR_ACTIVITION_TIME = 0.25
bool function CommsMenu_HandleKeyInput( int key )
{
	Assert( IsCommsMenuActive() )


	if ( PingSecondPageIsEnabled() )
	{
		bool isPageButton = IsControllerModeActive() ? ButtonIsBoundToAction( key, "+weaponcycle" ) : ButtonIsBoundToAction( key, "+jump" )

		array<int> pagesAllowedToGoToChat =
		[
			eChatPage.PING_MAIN_1,
			eChatPage.PING_SKYDIVE,
		]

		if ( isPageButton )
		{
			float timeSinceLastPageSwitch = (Time() - s_pageSwitchTime)
			if ( (timeSinceLastPageSwitch > 0.1) && (file.commsMenuStyle == eCommsMenuStyle.PING_MENU) )
			{
				entity player = GetLocalViewPlayer()
				int nextPage  = eChatPage.INVALID

				if ( pagesAllowedToGoToChat.contains( s_currentChatPage ) )
				{
					nextPage = eChatPage.PING_MAIN_2
				}
				else if ( s_currentChatPage == eChatPage.PING_MAIN_2 )
				{
					nextPage = s_previousChatPage
				}

				if ( nextPage != eChatPage.INVALID )
				{
					ResetViewInput()
					EmitSoundOnEntity( player, WHEEL_SOUND_ON_CLOSE )
					ShowCommsMenu( nextPage )
					s_pageSwitchTime = Time()
					return true
				}
			}
		}
		                   
		                                                                                       
		 
			                                                           
				        

			                                           
			 
				                   
			 

			                   
			 
				                                                           
				                                                                                           
				 
					                                    
					                                 

					                                                                   
					 
						                                   
					 
					                                                         
					 
						                             
					 

					                                    
					 
						                
						                                                 
						                         
						                         
						           
					 
				 
			 
		 
		        
	}




	bool shouldExecute    = false
	bool shouldCancelMenu = false
	int choice            = -1

	int executeType = eWheelInputType.NONE

	if ( file.commsMenuStyle == eCommsMenuStyle.CRAFTING )
	{
		switch ( key )
		{
			case BUTTON_A:
			case MOUSE_LEFT:
				executeType = eWheelInputType.USE
				break

			case BUTTON_B:
			case KEY_ESCAPE:
			case MOUSE_RIGHT:
				shouldCancelMenu = true
				break
		}
	}
	else
	{
		switch ( key )
		{
			case KEY_1:
				choice = 0
				break

			case KEY_2:
				choice = 1
				break

			case KEY_3:
				choice = 2
				break

			case KEY_4:
				choice = 3
				break

			case KEY_5:
				choice = 4
				break

			case KEY_6:
				choice = 5
				break

			case KEY_7:
				choice = 6
				break

			case KEY_8:
				choice = 7
				break

			case BUTTON_A:
			case MOUSE_LEFT:
				executeType = eWheelInputType.USE
				break

			case BUTTON_X:
				executeType = eWheelInputType.EQUIP
				break

			case BUTTON_B:
			case KEY_ESCAPE:
			case MOUSE_RIGHT:
				shouldCancelMenu = true
				break
		}
	}

	if ( ButtonIsBoundToPing( key ) && file.commsMenuStyle != eCommsMenuStyle.CRAFTING )
	{
		executeType = eWheelInputType.REQUEST
	}

	if ( IsValidChoice( choice ) && executeType == eWheelInputType.NONE )
	{
		SetCurrentChoice( choice )
		executeType = eWheelInputType.USE
	}

                
	if ( file.commsMenuStyle == eCommsMenuStyle.CRAFTING )
	{
		shouldExecute = ((file.commsMenuStyle == eCommsMenuStyle.CRAFTING) && executeType == eWheelInputType.USE)
	} else {
      
		shouldExecute = executeType != eWheelInputType.NONE
		shouldExecute = shouldExecute || ((file.commsMenuStyle == eCommsMenuStyle.CHAT_MENU) && ButtonIsBoundToAction( key, CHAT_MENU_BIND_COMMAND ))
		shouldExecute = shouldExecute || ((file.commsMenuStyle == eCommsMenuStyle.PING_MENU) && ButtonIsBoundToAction( key, "+ping" ))
		shouldExecute = shouldExecute || ((file.commsMenuStyle == eCommsMenuStyle.PINGREPLY_MENU) && ButtonIsBoundToAction( key, "+ping" ))
		shouldExecute = shouldExecute || ((file.commsMenuStyle == eCommsMenuStyle.INVENTORY_HEALTH_MENU) && ButtonIsBoundToAction( key, HEALTHKIT_BIND_COMMAND ))
		shouldExecute = shouldExecute || ((file.commsMenuStyle == eCommsMenuStyle.SKYDIVE_EMOTE_MENU) && executeType == eWheelInputType.USE)
                
	}
      

	shouldCancelMenu = shouldCancelMenu || ((file.commsMenuStyle == eCommsMenuStyle.CHAT_MENU) && ButtonIsBoundToAction( key, CHAT_MENU_BIND_COMMAND ))

	if ( shouldExecute )
	{
		if ( CommsMenu_HasValidSelection() )
		{
			bool didAnything = CommsMenu_ExecuteSelection( executeType )
			if ( didAnything )
				CommsMenu_Shutdown( false )

			return true
		}

		shouldCancelMenu = true
	}

	if ( shouldCancelMenu )
	{
		Ping_Interrupt()
		CommsMenu_Shutdown( true )

		entity player = GetLocalViewPlayer()
		if ( IsValid( player ) )
			EmitSoundOnEntity( player, WHEEL_SOUND_ON_CLOSE )

		if ( (file.commsMenuStyle == eCommsMenuStyle.PING_MENU || file.commsMenuStyle == eCommsMenuStyle.PINGREPLY_MENU)
		&& ButtonIsBoundToAction( key, "+offhand1" ) && Time() - s_latestViewInputResetTime < BUTTON_PAIR_ACTIVITION_TIME )
			return false

		return true
	}

	return false
}

int s_currentChoice = -1
int s_latestValidChoice = -1
float s_latestValidChoiceTime = -1000.0
float s_latestViewInputResetTime = -1000.0

void function ResetViewInput()
{
	s_currentChoice = -1
	s_latestValidChoice = -1
	s_latestValidChoiceTime = -1000.0
	s_latestViewInputResetTime = Time()

	ResetMouseInput()
}
void function SetCurrentChoice( int choice )
{
	if ( file.menuRui != null )
	{
		RuiSetInt( file.menuRui, "focusedSlot", choice )

		string[2] promptTexts = GetPromptsForMenuOption( choice )
		RuiSetString( file.menuRui, "focusedText", promptTexts[0] )
		RuiSetString( file.menuRui, "focusedDescText", promptTexts[1] )
	}

	if ( choice >= 0 )
	{
		s_latestValidChoice = choice
		s_latestValidChoiceTime = Time()
	}
	s_currentChoice = choice

	if ( s_currentChatPage == eChatPage.INVENTORY_HEALTH )
	{
		SetRuiOptionsForChatPage( file.menuRui, s_currentChatPage )

		if ( s_currentChoice < 0 )
		{
			OverrideHUDHealthFractions( GetLocalClientPlayer() )
		}
		else
		{
			CommsMenuOptionData op = s_currentMenuOptions[s_currentChoice]

			string lootRef
			if ( WeaponDrivenConsumablesEnabled() )
			{
				ConsumableInfo kitInfo                   = Consumable_GetConsumableInfo( op.healType )
				TargetKitHealthAmounts targetHealAmounts = Consumable_PredictConsumableUse( GetLocalClientPlayer(), kitInfo )
				OverrideHUDHealthFractions( GetLocalClientPlayer(), targetHealAmounts.targetHealth, targetHealAmounts.targetShields )
				lootRef = kitInfo.lootData.ref
			}
			else
			{
				HealthPickup healthKit                   = SURVIVAL_Loot_GetHealthKitDataFromStruct( op.healType )
				TargetKitHealthAmounts targetHealAmounts = PredictHealthPackUse( GetLocalClientPlayer(), healthKit )
				OverrideHUDHealthFractions( GetLocalClientPlayer(), targetHealAmounts.targetHealth, targetHealAmounts.targetShields )
				lootRef = healthKit.lootData.ref
			}

			int count = SURVIVAL_CountItemsInInventory( GetLocalViewPlayer(), lootRef )
			if ( count == 0 )
				RuiSetString( file.menuRui, "promptText", "#PING_PROMPT_REQUEST" )
		}
	}
}
bool function IsValidChoice( int choice )
{
	                                                               
	return choice >= 0 && choice < s_currentMenuOptions.len()
}


vector s_mousePad
void function ResetMouseInput()
{
	s_mousePad = <0, 0, 0>
}
vector function ProcessMouseInput( float deltaX, float deltaY )
{
	float MAX_BOUNDS = 200.0

	s_mousePad = <s_mousePad.x + deltaX, s_mousePad.y + deltaY, 0.0>

	                   
	{
		float lenRaw = Length( s_mousePad )
		if ( lenRaw > MAX_BOUNDS )
			s_mousePad = (s_mousePad / lenRaw * MAX_BOUNDS)
	}

	float lenNow = Length( s_mousePad )
	if ( lenNow < 25.0 )
	{
		                                                                
		return <0, 0, 0>
	}

	vector result = (s_mousePad / Length( s_mousePad ))
	                                                                                                                                                          
	return result
}


bool function CommsMenu_HandleMoveInputControllerOnly( float x, float y )
{
	if ( IsControllerModeActive() )
		CommsMenu_HandleViewInput( x, y )

	return false
}

bool function CommsMenu_HandleViewInput( float x, float y )
{
	                                              
	{
		float lockoutTime            = IsControllerModeActive() ? 0.0 : 0.01
		float deltaSinceInputStarted = (Time() - s_latestViewInputResetTime)
		if ( deltaSinceInputStarted < lockoutTime )
			return false
	}

	int optionCount = s_currentMenuOptions.len()
	int choice      = -1

	                                                                                         
	float lenCutoff = IsControllerModeActive() ? ((s_currentChoice < 0) ? 0.8 : 0.4) : ((s_currentChoice < 0) ? 0.8 : 0.4)

	RuiSetFloat2( file.menuRui, "inputVec", <0, 0, 0> )
	vector inputVec = IsControllerModeActive() ? <x, y, 0.0> : ProcessMouseInput( x, y )
	float inputLen  = Length( inputVec )
	if ( optionCount <= 0 )
	{
		choice = -1
	}
	else if ( inputLen > lenCutoff )
	{
		float circle = 2.0 * PI
		float angle  = atan2( inputVec.x, inputVec.y )                                            
		if ( angle < 0.0 )
			angle += circle

		float slotWidth = (circle / float( optionCount ))
		angle += slotWidth * 0.5

		choice = (int( (angle / circle) * optionCount ) % optionCount)

		                                                                            

		vector ruiInputVec = IsControllerModeActive() ? Normalize( inputVec ) : inputVec
		RuiSetFloat2( file.menuRui, "inputVec", Normalize( inputVec ) )
	}
	else
	{
		if ( IsControllerModeActive() )
			choice = s_currentChoice      
		else
			choice = s_currentChoice
	}

	if ( (choice >= 0) && (choice != s_currentChoice) )
	{
		entity player = GetLocalViewPlayer()
                  
		if ( CommsMenu_GetCurrentCommsMenu() == eCommsMenuStyle.CRAFTING )
			EmitSoundOnEntity( player, WHEEL_SOUND_ON_FOCUS_CRAFTING )
		else
        
			EmitSoundOnEntity( player, WHEEL_SOUND_ON_FOCUS )
	}

	SetCurrentChoice( choice )
	return true
}

bool function MakeCommMenuSelection( int choice, int wheelInputType )
{
	CommsMenuOptionData op = s_currentMenuOptions[choice]
	switch( op.optionType )
	{
		case eOptionType.COMMSACTION:
		{
			HandleCommsActionPick( op.commsAction, choice )
			return true
		}

		case eOptionType.WEAPON_INSPECT:
		{
			HandleWeaponInspectSelection()
			return true
		}

		case eOptionType.QUIP:
		{
			HandleQuipPick( expect ItemFlavor( op.emote ), op.healType )
			return true
		}

		case eOptionType.SKYDIVE_EMOTE:
		{
			entity player = GetLocalViewPlayer()

			EmitSoundOnEntity( player, WHEEL_SOUND_ON_EXECUTE )

			Remote_ServerCallFunction( "ClientCallback_SkydiveEmote", op.healType )
			return true
		}

		case eOptionType.NEW_PING:
		{
			Ping_ExecutePendingNewPingWithOverride( op.pingType , CommsMenu_GetMenuForNewPing(GetLocalClientPlayer()))
			return true
		}

		case eOptionType.PING_REPLY:
		{
			Ping_ExecutePendingPingReplyWithOverride( op.pingReply )
			return true
		}

		case eOptionType.HEALTHITEM_USE:
		{
			if ( wheelInputType == eWheelInputType.USE )
			{
				HandleHealthItemUse( op.healType )
			}
			else if ( wheelInputType == eWheelInputType.REQUEST )
			{
				HealthPickup pickup   = SURVIVAL_Loot_GetHealthKitDataFromStruct( op.healType )
				int kitCat            = SURVIVAL_Loot_GetHealthPickupCategoryFromData( pickup )
				bool useShieldRequest = (kitCat == eHealthPickupCategory.SHIELD)

				if ( WeaponDrivenConsumablesEnabled() )
				{
					ConsumableInfo info = Consumable_GetConsumableInfo( op.healType )
					useShieldRequest = (info.healAmount == 0 && info.shieldAmount > 0)
				}

				if ( useShieldRequest )
					Quickchat( GetLocalViewPlayer(), eCommsAction.INVENTORY_NEED_SHIELDS )
				else
					Quickchat( GetLocalViewPlayer(), eCommsAction.INVENTORY_NEED_HEALTH )

				return false                        
			}
			else if ( wheelInputType == eWheelInputType.NONE && HealthkitWheelUseOnRelease() )
			{
				HandleHealthItemUse( op.healType )
			}

			HandleHealthItemSelection( op.healType )
			return true
		}

		case eOptionType.ORDNANCE_EQUIP:
		{
			HandleOrdnanceSelection( op.healType )
			return true
		}

                 
		case eOptionType.CRAFT:
		{
			bool retVal = Crafting_OnMenuItemSelected( op.craftingIndex, file.menuRui )
			if ( !retVal )
				EmitSoundOnEntity( GetLocalViewPlayer(), WHEEL_SOUND_ON_DENIED_CRAFTING )
			return retVal
		}
       
                       
                             
   
                                                                                  
                                                                      
              
   
       
	}

	return false
}

void function PerformQuipAtSlot( int index )
{
	EHI playerEHI = LocalClientEHI()

	ItemFlavor character = LoadoutSlot_GetItemFlavor( playerEHI, Loadout_Character() )

	LoadoutEntry entry = Loadout_CharacterQuip( character, index )
	ItemFlavor quip    = LoadoutSlot_GetItemFlavor( playerEHI, entry )
	if ( !CharacterQuip_IsTheEmpty( quip ) )
	{
		HandleQuipPick( quip, index )
	}
}

void function PerformFavoredQuipAtSlot( int index )
{
	EHI playerEHI = LocalClientEHI()

	ItemFlavor character = LoadoutSlot_GetItemFlavor( playerEHI, Loadout_Character() )

	LoadoutEntry entry = Loadout_FavoredQuip( character, index )
	ItemFlavor quip    = LoadoutSlot_GetItemFlavor( playerEHI, entry )
	if ( !CharacterQuip_IsTheEmpty( quip ) )
	{
		HandleFavoredQuipPick( quip, index )
	}
}

void function HandleQuipPick( ItemFlavor quip, int choice )
{
	entity player = GetLocalViewPlayer()

	if ( ItemFlavor_GetType( quip ) == eItemType.character_emote )
	{
		if ( CheckPlayerCanEmoteAndGiveFeedback( player ) )
			return
	}

	EmitSoundOnEntity( player, WHEEL_SOUND_ON_EXECUTE )

	Remote_ServerCallFunction( "ClientCallback_BroadcastQuip", choice )

	if ( CharacterQuip_UseHoloProjector( quip ) )
		ActivateEmoteProjector( player, quip )
}

bool function CheckPlayerCanEmoteAndGiveFeedback( entity player )
{
	int result = CheckPlayerCanEmote( player )
	if ( result == eCanEmoteCheckReults.FAIL_TOO_CLOSE_TO_WALL )
		AnnouncementMessageRight( player, Localize( "#EMOTE_HINT_FAILED_WALL" ) )

	return ( result != eCanEmoteCheckReults.SUCCESS )
}

void function HandleFavoredQuipPick( ItemFlavor quip, int choice )
{
	entity player = GetLocalViewPlayer()

	if ( ItemFlavor_GetType( quip ) == eItemType.character_emote )
	{
		if ( CheckPlayerCanEmoteAndGiveFeedback( player ) )
			return
	}

	EmitSoundOnEntity( player, WHEEL_SOUND_ON_EXECUTE )

	Remote_ServerCallFunction( "ClientCallback_BroadcastFavoredQuip", choice )

	if ( CharacterQuip_UseHoloProjector( quip ) )
		ActivateEmoteProjector( player, quip )
}

void function HandleCommsActionPick( int commsAction, int directionIndex )
{
	Assert( (commsAction >= 0) && (commsAction < eCommsAction._count) )

	EmitSoundOnEntity( GetLocalViewPlayer(), WHEEL_SOUND_ON_EXECUTE )
	Quickchat( GetLocalViewPlayer(), commsAction )
}

void function HandleHealthItemSelection( int healthPickupType )
{
	entity player = GetLocalViewPlayer()
                         
                                                                                                                 
  
                                         
   
                                                           
   
      
                                                                  
  
     
       
	if ( healthPickupType != -1 )
	{
		string kitRef = SURVIVAL_Loot_GetHealthPickupRefFromType( healthPickupType )
		if ( SURVIVAL_CountItemsInInventory( player, kitRef ) == 0 )
			return
	}

	EmitSoundOnEntity( GetLocalViewPlayer(), WHEEL_SOUND_ON_EXECUTE )

	if ( WeaponDrivenConsumablesEnabled() )
		Consumable_SetSelectedConsumableType( healthPickupType )
	else
		Survival_Health_SetSelectedHealthPickupType( healthPickupType )
}

bool function HandleHealthItemUse( int healthPickupType )
{
	entity player = GetLocalViewPlayer()

	if ( WeaponDrivenConsumablesEnabled() )
	{
		Consumable_UseItemByType( player, healthPickupType )
		return true
	}
	else
	{
		if ( !Survival_CanUseHealthPack( player, healthPickupType, true, true ) )
			return false

		Survival_UseHealthPack( player, SURVIVAL_Loot_GetHealthPickupRefFromType( healthPickupType ) )
		return true
	}

	unreachable
}

void function HandleOrdnanceSelection( int ordnanceIndex )
{
	entity player = GetLocalViewPlayer()

	LootData data
	if ( ordnanceIndex != -1 )
	{
		data = SURVIVAL_Loot_GetLootDataByIndex( ordnanceIndex )
		if ( SURVIVAL_CountItemsInInventory( player, data.ref ) == 0 )
			return
	}

	EmitSoundOnEntity( player, WHEEL_SOUND_ON_EXECUTE )

	Remote_ServerCallFunction( "ClientCallback_Sur_SwitchToOrdnance", ordnanceIndex, !OrdnanceWheelUseOnRelease() )
}

void function HandleWeaponInspectSelection( )
{
	if ( WeaponInspectFromChatPageEnabled() )
	{
		array<int> pagesAllowedToGoToInspect =
		[
			eChatPage.DEFAULT,
			eChatPage.PING_MAIN_2,
		]

		if ( pagesAllowedToGoToInspect.contains( s_currentChatPage )  )
		{
			entity player = GetLocalViewPlayer()
			if( IsValid( player ) )
			{
				CommsMenu_Shutdown( true )
				player.ClientCommand( "weapon_inspect" )
			}
		}
	}
}

void function OnDeathCallback( entity player )
{
	if ( IsLocalClientPlayer( player ) )
		DestroyCommsMenu()
}

void function OnBleedoutStarted( entity victim, float endTime )
{
	if ( victim != GetLocalViewPlayer() )
		return

	DestroyCommsMenu()
}

void function OnBleedoutEnded( entity victim )
{
	if ( victim != GetLocalViewPlayer() )
		return

	DestroyCommsMenu()
}

void function OnPlayerMatchStateChanged( entity player, int newValue )
{
	if ( player != GetLocalViewPlayer() )
		return

	DestroyCommsMenu()
}

void function OnPlayerConnectionStateChanged( entity player )
{
	if ( player != GetLocalClientPlayer() )
		return

	DestroyCommsMenu()
}

void function OnPlayerDisconnected( entity player )
{
	if ( player != GetLocalClientPlayer() )
		return

	DestroyCommsMenu()
}

void function DestroyCommsMenu()
{
	DestroyCommsMenu_( true )
}

void function DestroyCommsMenu_( bool instant )
{
	RunUIScript( "ClientToUI_SetCommsMenuOpen", false )

	if ( !IsCommsMenuActive() )
		return

                 
		if ( CommsMenu_GetCurrentCommsMenu() == eCommsMenuStyle.CRAFTING )
		{
			Crafting_OnWorkbenchMenuClosed( instant )
		}
       

	if ( file.commsMenuStyle == eCommsMenuStyle.PINGREPLY_MENU )
		SetFocusedWaypointForcedClear()

	if ( IsValid( s_focusWaypoint ) )
	{
		RuiSetBool( s_focusWaypoint.wp.ruiHud, "hasWheelFocus", false )
		s_focusWaypoint = null
	}

	if ( s_currentChatPage == eChatPage.INVENTORY_HEALTH )
		OverrideHUDHealthFractions( GetLocalClientPlayer() )

	s_currentChatPage = eChatPage.INVALID
	s_previousChatPage = eChatPage.INVALID

	RuiSetBool( file.menuRui, "isFinished", true )

	if ( instant )
	{
		RuiDestroy( file.menuRui )
		ReleaseHUDRui( file.menuRui )
	}
	else
		file.menuRuiLastShutdown = file.menuRui
	file.menuRui = null

	entity player = GetLocalViewPlayer()

	float deltaSinceInputStarted = (Time() - s_latestViewInputResetTime)
	if ( (s_latestValidChoice < 0) && (deltaSinceInputStarted < 0.35) )
		player.ClearLookStickDebounce()

	HudInput_PopContext()

	foreach ( func in file.onCommsMenuStateChangedCallbacks )
		func( false )
}

bool function IsCommsMenuActive()
{
	return (s_currentChatPage != eChatPage.INVALID)
}

bool function CommsMenu_CanUseMenu( entity player, int menuType = eChatPage.DEFAULT)
{
	if ( IsWatchingReplay() )
		return false

	if ( !IsAlive( player ) )
		return false

	if ( IsScoreboardShown() )
		return false

	if ( GetPlayerIs3pEmoting( player ) )
		return false

                 
		if ( Crafting_IsPlayerAtWorkbench( player ) && menuType != eChatPage.CRAFTING )
			return false
       

                             
		if ( ExplosiveHold_IsPlayerPlantingGrenade( player ) )
			return false
       

	if ( IsCommsMenuActive() )
		return false

                  
		if ( IsFallLTM() && IsPlayerShadowZombie( player ) )
			return false
       

	if ( GetGameState() > eGameState.Resolution )
		return false

	if ( IsPlayerInCryptoDroneCameraView( player ) )
		return false

	return true
}

int function CommsMenu_GetCurrentCommsMenu()
{
	return file.commsMenuStyle
}

var function CommsMenu_GetMenuRui()
{
	return file.menuRui
}
                        
                                                                        
 
                                                                                           
                                                                                                   
             

                                                                                                    
             

                                                                                                   
             

             
 
      
#endif          

#if SERVER
                                                                                               
 
	                          
	 
		                                  
		                                    
                          
                                                
                                                 
                                                
        
		                                    
		                                    
		                                    
			                                                                      
			      

		                     
			                                                        
			      

		        
			                                                             
			      
	 

	           
 
#endif

#if CLIENT
void function SetHintTextOnHudElem( var hudElem, string text, string subtext )
{
	RuiSetString( Hud_GetRui( hudElem ), "buttonText", Localize( text, Localize( subtext ) ) )
}
#endif                               