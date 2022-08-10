global function Cl_Survival_InventoryInit

global function Survival_SwapPrimary
global function Survival_SwapToMelee
global function Survival_SwapToOrdnance

global function ServerCallback_RefreshInventory
global function ResetInventoryMenu
global function OpenSurvivalInventory
global function OpenSurvivalGroundList

global function Survival_IsInventoryOpen
global function Survival_IsGroundlistOpen
global function Survival_GetDeathBox
global function Survival_GetDeathBoxItems
global function Survival_GetGroundListBehavior

global function BackpackAction
global function EquipmentAction
global function GroundAction
global function DispatchLootAction

global function GroundItemUpdate
global function OpenSwapForItem
global function UIToClient_UpdateInventoryDpadTooltipText

global function UICallback_BackpackOpened
global function UICallback_BackpackClosed

global function UIToClient_GroundlistOpened
global function UIToClient_GroundlistClosed

global function UICallback_UpdateInventoryButton
global function UICallback_OnInventoryButtonAction
global function UICallback_OnInventoryButtonAltAction
global function UICallback_PingInventoryItem

global function UICallback_UpdateEquipmentButton
global function UICallback_OnEquipmentButtonAction
global function UICallback_OnEquipmentButtonAltAction
global function UICallback_PingEquipmentItem

global function UICallback_PingRequestButton
global function UICallback_UpdateRequestButton

                            
global function UICallback_PingIsMyUltimateReady
                                  

global function UIToClient_UpdateGroundMenuHeader
global function UICallback_UpdateGroundItem
global function UICallback_GroundItemAction
global function UICallback_GroundItemAltAction
global function UICallback_PingGroundListItem
global function UICallback_AddVisibleItem

global function SetQuickSwapString
global function UICallback_UpdateQuickSwapItem
global function UICallback_OnQuickSwapItemClick
global function UICallback_OnQuickSwapItemClickRight

global function UICallback_UpdateQuickSwapItemButton
global function UICallback_AutoPickupFromDeathbox

global function UICallback_GetLootDataFromButton
global function UICallback_GetMouseDragAllowedFromButton
global function UICallback_OnInventoryMouseDrop

global function UIToClient_WeaponSwap
global function UICallback_UpdatePlayerInfo
global function UICallback_UpdateTeammateInfo
global function UICallback_UpdateUltimateInfo

global function UICallback_BlockPingForDuration

global function UICallback_EnableTriggerStrafing
global function UICallback_DisableTriggerStrafing

global function UpdateHealHint
global function GroundListResetNextFrame
global function GetCountForLootType
global function TryUpdateGroundList
global function TryResetGroundList
global function OnLocalPlayerPickedUpItem

global function IsOrdnanceEquipped

global enum eGroundListBehavior
{
	CONTENTS,
	NEARBY,
}

global enum eGroundLootPingedBy
{
	NOONE
	ANYONEELSE
	PLAYER
}

global enum eGroundListType
{
	DEATH_BOX,
	GRABBER,
	_COUNT
}

struct CurrentGroundListData
{
	entity deathBox
	int    behavior
	int    listType
}

struct GroundLootData
{
	LootData&         lootData
	array<int>        guids
	int               count
	bool              isUpgrade
	bool              isRelevant
	bool              isHeader
}

const float ULT_HINT_COOLDOWN = 90.0

struct {
	table<string, void functionref( entity, string )>         itemUseFunctions
	table<string, void functionref( entity, string, string )> specialItemUseFunctions
	table<int, void functionref( entity, string )>            itemTypeUseFunctions
	table<int, void functionref( entity, string, string )>    specialItemTypeUseFunctions

	array<GroundLootData> allGroundItems = []
	array<GroundLootData> filteredGroundItems = []


	bool backpackOpened = false
	bool groundlistOpened = false
	bool shouldResetGroundItems = true
	bool shouldUpdateGroundItems = false

	string                swapString
	CurrentGroundListData currentGroundListData

	float                 lastHealHintDisplayTime
	float				  lastUltHintDisplayTime
	table<string, string> triggerBinds

	array<entity> lastLoot
	array<int>    visibleItemIndices
} file


void function Cl_Survival_InventoryInit()
{
	                                                           
	                                                                    
                        
                                                                      
       
	file.itemTypeUseFunctions[ eLootType.HEALTH ] <- UseHealthPickupRefFromInventory
	file.itemTypeUseFunctions[ eLootType.ORDNANCE ] <- EquipOrdnance
	file.itemTypeUseFunctions[ eLootType.GADGET ] <- EquipGadget
	file.specialItemTypeUseFunctions[ eLootType.ATTACHMENT ] <- EquipAttachment

	file.lastUltHintDisplayTime = Time() - ULT_HINT_COOLDOWN

	RegisterSignal( "OpenSwapForItem" )
	RegisterSignal( "ResetInventoryMenu" )
	RegisterSignal( "BackpackClosed" )
	RegisterSignal( "GroundListClosed" )

	AddCallback_OnUpdateTooltip( eTooltipStyle.LOOT_PROMPT, OnUpdateLootPrompt )
	AddCallback_OnUpdateTooltip( eTooltipStyle.WEAPON_LOOT_PROMPT, OnUpdateLootPrompt )

	AddCallback_LocalPlayerPickedUpLoot( OnLocalPlayerPickedUpItem )

	AddLocalPlayerTookDamageCallback( TryCloseSurvivalInventoryFromDamage )
	AddLocalPlayerTookDamageCallback( ShowHealHint )
	AddCallback_OnPlayerConsumableInventoryChanged( ResetInventoryMenu )

                 
                                                                                 
      
}


void function ServerCallback_RefreshInventory()
{
	ResetInventoryMenu( GetLocalClientPlayer() )
}


void function ResetInventoryMenu( entity player )
{
	thread ResetInventoryMenuInternal( player )
}


void function ResetInventoryMenuInternal( entity player )
{
	clGlobal.levelEnt.Signal( "ResetInventoryMenu" )
	clGlobal.levelEnt.EndSignal( "ResetInventoryMenu" )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )

	WaitEndFrame()

	if ( IsWatchingReplay() )
		return

	if ( player != GetLocalClientPlayer() )
		return

	if ( player != GetLocalViewPlayer() )
		return

	PerfStart( PerfIndexClient.InventoryRefreshTotal )

	PerfStart( PerfIndexClient.InventoryRefreshStart )
	RunUIScript( "SurvivalInventoryMenu_BeginUpdate" )
	PerfEnd( PerfIndexClient.InventoryRefreshStart )
	RunUIScript( "SurvivalInventoryMenu_SetInventoryLimit", SURVIVAL_GetInventoryLimit( player ) )
	RunUIScript( "SurvivalInventoryMenu_SetInventoryLimitMax", SURVIVAL_GetMaxInventoryLimit( player ) )
	PerfStart( PerfIndexClient.InventoryRefreshEnd )
	RunUIScript( "SurvivalInventoryMenu_EndUpdate" )
	PerfEnd( PerfIndexClient.InventoryRefreshEnd )

	if ( player == GetLocalClientPlayer() && player == GetLocalViewPlayer() )
		UpdateHealHint( player )

                  
                                                      
                                                                                                  
                                                             

                                                                                
                                                          
                                                              
                                                               
                                                             

       

	PerfEnd( PerfIndexClient.InventoryRefreshTotal )
}


void function Survival_UseInventoryItem( string ref, string secondRef )
{
	if ( GetLocalViewPlayer() != GetLocalClientPlayer() )
		return

	LootData data = SURVIVAL_Loot_GetLootDataByRef( ref )
	int type      = data.lootType

	if ( ref in file.itemUseFunctions )
	{
		file.itemUseFunctions[ ref ]( GetLocalViewPlayer(), ref )
	}
	else if ( ref in file.specialItemUseFunctions )
	{
		file.specialItemTypeUseFunctions[ type ]( GetLocalViewPlayer(), ref, secondRef )
	}
	else if ( type in file.itemTypeUseFunctions )
	{
		file.itemTypeUseFunctions[ type ]( GetLocalViewPlayer(), ref )
	}
	else if ( type in file.specialItemTypeUseFunctions )
	{
		file.specialItemTypeUseFunctions[ type ]( GetLocalViewPlayer(), ref, secondRef )
	}

	ResetInventoryMenu( GetLocalViewPlayer() )
}


bool function Survival_DropInventoryItem( string ref, int num )
{
	entity player = GetLocalViewPlayer()

	if ( !Survival_PlayerCanDrop( player ) )
		return false

	entity deathbox = null
	if ( IsValid( file.currentGroundListData.deathBox ) && file.currentGroundListData.behavior == eGroundListBehavior.CONTENTS )
	{
		deathbox = file.currentGroundListData.deathBox
	}

	Remote_ServerCallFunction( "ClientCallback_Sur_DropBackpackItem", ref, num, deathbox )
	ResetInventoryMenu( player )

	return true
}


bool function Survival_DropEquipment( string ref )
{
	entity player = GetLocalViewPlayer()

	if ( !Survival_PlayerCanDrop( player ) )
		return false

	Remote_ServerCallFunction( "ClientCallback_Sur_DropEquipment", ref )
	ResetInventoryMenu( player )

	return true
}


bool function BackpackAction( int lootAction, string slotIndexString )
{
	int slotIndex = int( slotIndexString )

	entity player                                  = GetLocalClientPlayer()
	array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )
	int foundIndex                                 = -1

	foreach ( index, item in playerInventory )
	{
		if ( item.slot != slotIndex )
			continue

		foundIndex = index
		break
	}

	if ( foundIndex < 0 )
	{
		RunUIScript( "SurvivalMenu_AckAction" )
		return false
	}

	LootData lootData = SURVIVAL_Loot_GetLootDataByIndex( playerInventory[foundIndex].type )

	switch ( lootAction )
	{
		case eLootAction.DROP:
			int numToDrop = 1
			if ( lootData.lootType == eLootType.AMMO )
				numToDrop = minint( lootData.countPerDrop, playerInventory[foundIndex].count )
			return Survival_DropInventoryItem( lootData.ref, numToDrop )
			break

		case eLootAction.DROP_ALL:
			return Survival_DropInventoryItem( lootData.ref, playerInventory[foundIndex].count )
			break

			                                                 

		case eLootAction.ATTACH_TO_ACTIVE:
		case eLootAction.ATTACH_TO_STOWED:
			                             
			  	                                                    
			       
			Remote_ServerCallFunction( "ClientCallback_Sur_EquipAttachment", lootData.ref, -1 )
			        
			break

		case eLootAction.EQUIP:
			Survival_UseInventoryItem( lootData.ref, "" )
			RunUIScript( "SurvivalMenu_AckAction" )
			break

		case eLootAction.USE:
			Survival_UseInventoryItem( lootData.ref, "" )
			RunUIScript( "SurvivalMenu_AckAction" )
			break
	}

	return true
}


bool function EquipmentAction( int lootAction, string equipmentSlot )
{
	switch ( lootAction )
	{

                 
                                    
                                         
    
                                          
                                                                    
    
      

		case eLootAction.EQUIP:
			entity player = GetLocalClientPlayer()
			if ( player == GetLocalViewPlayer() )
			{
				string equipRef = EquipmentSlot_GetLootRefForSlot( player, equipmentSlot )
				if( SURVIVAL_Loot_GetLootDataByRef( equipRef ).lootType == eLootType.GADGET )
				{
					EquipGadget(player, equipRef)
					RunUIScript( "SurvivalMenu_AckAction" )
				}

				if ( EquipmentSlot_IsMainWeaponSlot( equipmentSlot ) )
				{
					EquipmentSlot es = Survival_GetEquipmentSlotDataByRef( equipmentSlot )
					int slot         = es.weaponSlot
					player.ClientCommand( "weaponSelectPrimary" + slot )
					return true
				}
			}
			break

		case eLootAction.DROP:
			return Survival_DropEquipment( equipmentSlot )
			break

		case eLootAction.REMOVE_TO_GROUND:
		case eLootAction.REMOVE:
			entity weaponEnt = GetBaseWeaponEntForEquipmentSlot( equipmentSlot )
			int weaponSlot = EquipmentSlot_GetWeaponSlotForEquipmentSlot( equipmentSlot )
			if ( IsValid( weaponEnt ) )
			{
				EquipmentSlot es = Survival_GetEquipmentSlotDataByRef( equipmentSlot )
				return Survival_UnequipAttachment( SURVIVAL_GetWeaponAttachmentForPoint( GetLocalViewPlayer(), weaponSlot, es.attachmentPoint ), weaponSlot, lootAction == eLootAction.REMOVE_TO_GROUND )
			}
			break

		case eLootAction.WEAPON_TRANSFER:
			entity weaponEnt = GetBaseWeaponEntForEquipmentSlot( equipmentSlot )
			int weaponSlot = EquipmentSlot_GetWeaponSlotForEquipmentSlot( equipmentSlot )
			if ( IsValid( weaponEnt ) )
			{
				EquipmentSlot es = Survival_GetEquipmentSlotDataByRef( equipmentSlot )
				return Survival_TransferAttachment( SURVIVAL_GetWeaponAttachmentForPoint( GetLocalViewPlayer(), weaponSlot, es.attachmentPoint ), weaponSlot )
			}
			break
	}

	return false
}


void function GroundAction( int lootAction, string guid, bool isAltAction, bool actionFromMenu )
{
	int extraFlags = actionFromMenu ? PICKUP_FLAG_FROM_MENU : 0
	if ( isAltAction )
		extraFlags = extraFlags | PICKUP_FLAG_ALT

	int deathBoxEntIndex = -1
	if ( IsValid( file.currentGroundListData.deathBox ) )
	{
		deathBoxEntIndex = file.currentGroundListData.deathBox.GetEncodedEHandle()
	}

	entity lootEnt = GetEntityFromEncodedEHandle( int( guid ) )
	if ( !IsValid( lootEnt ) )
		return

	entity deathBox = GetEntityFromEncodedEHandle( deathBoxEntIndex )

	if ( lootEnt.GetNetworkedClassName() != "prop_survival" )
		return

	switch ( lootAction )
	{
		case eLootAction.PICKUP:
		case eLootAction.EQUIP:
		case eLootAction.SWAP:
			RunUIScript( "SurvivalMenu_AckAction" )
			Remote_ServerCallFunction( "ClientCallback_PickupSurvivalItem", lootEnt, extraFlags, deathBox )
			break

		case eLootAction.PICKUP_ALL:
			if ( IsValid( lootEnt ) )
			{
				Remote_ServerCallFunction( "ClientCallback_PickupAllSurvivalItem ", lootEnt.GetSurvivalInt(), false )
			}

			Remote_ServerCallFunction( "ClientCallback_PickupSurvivalItem ", lootEnt, 0, deathBox )
			break

		case eLootAction.ATTACH_TO_ACTIVE:
			Remote_ServerCallFunction( "ClientCallback_PickupSurvivalItem", lootEnt, (PICKUP_FLAG_ATTACH_ACTIVE_ONLY | extraFlags), deathBox )
			break

		case eLootAction.ATTACH_TO_STOWED:
			Remote_ServerCallFunction( "ClientCallback_PickupSurvivalItem", lootEnt, (PICKUP_FLAG_ATTACH_STOWED_ONLY | extraFlags), deathBox )
			break

		case eLootAction.CARRY:
			RunUIScript( "SurvivalMenu_AckAction" )
			break

		case eLootAction.USE:
			Remote_ServerCallFunction( "ClientCallback_UseSurvivalItem", lootEnt )
			break

		case eLootAction.DISMANTLE:
			Remote_ServerCallFunction( "ClientCallback_PickupSurvivalItem", lootEnt, PICKUP_FLAG_ALT, deathBox )
	}
}


void function UICallback_BackpackOpened()
{
	file.backpackOpened = true

	entity player = GetLocalClientPlayer()
	if ( player != GetLocalViewPlayer() )
		return

	if ( IsAlive( player ) )
		Remote_ServerCallFunction( "ClientCallback_BackpackOpened" )
}


void function UICallback_BackpackClosed()
{
	if ( !IsValidSignal( "BackpackClosed" ) )                                                          
			return

	entity oldDeathBoxEnt = file.currentGroundListData.deathBox
	file.currentGroundListData.deathBox = null
	file.backpackOpened = false
	file.groundlistOpened = false

	if ( !IsLobby() )
		clGlobal.levelEnt.Signal( "BackpackClosed" )

	entity player = GetLocalClientPlayer()
	if ( player != GetLocalViewPlayer() )
		return

	if ( IsAlive( player ) )
		Remote_ServerCallFunction( "ClientCallback_BackpackClosed" )

	if ( file.currentGroundListData.listType == eGroundListType.GRABBER && IsValid( oldDeathBoxEnt ) )
	{
		Remote_ServerCallFunction( BLACK_MARKET_CLOSE_CMD, oldDeathBoxEnt )
	}
}


void function UIToClient_GroundlistOpened()
{
	file.shouldResetGroundItems = true
	file.groundlistOpened = true

	entity player = GetLocalClientPlayer()
	if ( player != GetLocalViewPlayer() )
		return

	if ( IsAlive( player ) && GetGameState() >= eGameState.Prematch )
		Remote_ServerCallFunction( "ClientCallback_DeathboxOpened" )
}


void function UIToClient_GroundlistClosed()
{
	entity oldDeathBoxEnt = file.currentGroundListData.deathBox
	clGlobal.levelEnt.Signal( "GroundListClosed" )

	file.shouldResetGroundItems = true
	file.currentGroundListData.deathBox = null
	file.backpackOpened = false
	file.groundlistOpened = false
	entity player = GetLocalClientPlayer()
	if ( player != GetLocalViewPlayer() )
		return

	if ( IsAlive( player ) && GetGameState() >= eGameState.Prematch )
		Remote_ServerCallFunction( "ClientCallback_BackpackClosed" )

	if ( file.currentGroundListData.listType == eGroundListType.GRABBER && IsValid( oldDeathBoxEnt ) )
	{
		Remote_ServerCallFunction( BLACK_MARKET_CLOSE_CMD, oldDeathBoxEnt )
	}
}


bool function Survival_UnequipAttachment( string ref, int weaponSlot, bool removeToGround )
{
	if ( GetLocalViewPlayer() != GetLocalClientPlayer() )
		return false

	if ( !SURVIVAL_Loot_IsRefValid( ref ) )
		return false

	LootData data = SURVIVAL_Loot_GetLootDataByRef( ref )

               
	if ( data.noDrop )
	{
		removeToGround = false
	}
      

	Remote_ServerCallFunction( "ClientCallback_Sur_UnequipAttachment", ref, weaponSlot, removeToGround )
	return true
}


bool function Survival_TransferAttachment( string ref, int weaponSlot )
{
	if ( GetLocalViewPlayer() != GetLocalClientPlayer() )
		return false

	if ( !SURVIVAL_Loot_IsRefValid( ref ) )
		return false

	LootData data = SURVIVAL_Loot_GetLootDataByRef( ref )
	Remote_ServerCallFunction( "ClientCallback_Sur_TransferAttachment", ref, weaponSlot )
	return true
}


void function Survival_SwapPrimary()
{
	entity player = GetLocalViewPlayer()

	if ( !CanSwapWeapons( player ) )
		return

	thread WeaponCycle( player )
}


void function WeaponCycle( entity player )
{
	player.EndSignal( "OnDestroy" )

	player.ClientCommand( "invnext" )
}


void function Survival_SwapToMelee()
{
	entity player = GetLocalViewPlayer()

	if ( !CanSwapWeapons( player ) )
		return

	player.ClientCommand( "+ability 10" )
}


void function Survival_SwapToOrdnance()
{
	entity player = GetLocalViewPlayer()

	if ( !CanSwapWeapons( player ) )
		return

	player.ClientCommand( "weaponSelectOrdnance" )
}


bool function CanSwapWeapons( entity player )
{
	if ( player.IsTitan() )
		return false

	if ( !IsAlive( player ) )
		return false

	if ( !CanOpenInventoryInCurrentGameState() )
		return false

	if ( player.ContextAction_IsActive() && !player.ContextAction_IsRodeo() )
		return false

	if ( Bleedout_IsBleedingOut( player ) )
		return false

	return true
}


void function OpenSurvivalInventory( entity player, entity deathBox = null )
{
	if ( !player.GetPlayerNetBool( "inventoryEnabled" ) )
		return
	SurvivalMenu_Internal( player, "OpenSurvivalInventoryMenu", deathBox )
}


void function SurvivalMenu_Internal( entity player, string uiScriptFuncName, entity deathBox = null, int groundListBehavior = eGroundListBehavior.CONTENTS, int groundListType = eGroundListType.DEATH_BOX )
{
	if ( !CanOpenInventory( player ) )
		return

	ResetInventoryMenu( player )

	ServerCallback_ClearHints()
	player.ClientCommand( "-zoom" )
	CommsMenu_Shutdown( false )

	file.currentGroundListData.deathBox = deathBox
	file.currentGroundListData.behavior = groundListBehavior
	file.currentGroundListData.listType = groundListType

	RunUIScript( uiScriptFuncName )

	if ( IsValid( deathBox ) )
	{

		if ( uiScriptFuncName != "OpenSurvivalGroundListMenu" )
		{
			thread TrackCloseDeathBoxConditions( player, deathBox )
		}
	}
}

bool function CanOpenInventoryInCurrentGameState( )
{
	if( GamePlaying() || GetGameState() == eGameState.Epilogue )
		return true

	if( GetGameState() == eGameState.WaitingForPlayers )
		return true

	if(	GetGameState() == eGameState.Prematch && GetCurrentPlaylistVarBool( "allow_inventory_in_prematch", false ) )
		return true

	return false
}

bool function CanOpenInventory( entity player )
{
	if ( IsWatchingReplay() )
		return false

	if ( !IsAlive( player ) )
		return false

	if ( CharacterSelect_MenuIsOpen() )
		return false

	if ( !CanOpenInventoryInCurrentGameState() )
		return false

	if ( Bleedout_IsBleedingOut( player ) )
		return false

	if ( FiringRange_IsPlayerInFinale() )
		return false

	return true
}


void function TrackCloseDeathBoxConditions( entity player, entity deathBox )
{
	player.EndSignal( "OnDeath" )
	deathBox.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ()
		{
			if ( Survival_IsGroundlistOpen() )
			{
				RunUIScript( "TryCloseSurvivalInventory", null )
			}
		}
	)

	wait 0.5

	while ( Survival_IsGroundlistOpen() )
	{
		if ( Distance( player.GetOrigin(), deathBox.GetOrigin() ) > DEATH_BOX_MAX_DIST )
			return

		if ( file.currentGroundListData.behavior != eGroundListBehavior.NEARBY && file.filteredGroundItems.len() == 0 )
			return

                  
                                                                                 
         
        

		WaitFrame()
	}
}

void function OpenSurvivalGroundList( entity player, entity deathBox = null, int groundListBehavior = eGroundListBehavior.CONTENTS, int groundListType = eGroundListType.DEATH_BOX )
{
	string funcName = "OpenSurvivalGroundListMenu"
	SurvivalMenu_Internal( player, funcName, deathBox, groundListBehavior, groundListType )
}


void function UICallback_UpdateInventoryButton( var button, int position )
{
	entity player = GetLocalClientPlayer()

	var rui = Hud_GetRui( button )

	Hud_SetEnabled( button, true )
	Hud_SetSelected( button, false )
	RuiSetImage( rui, "iconImage", $"" )
	RuiSetInt( rui, "lootTier", 0 )
	RuiSetInt( rui, "count", 0 )
	Hud_ClearToolTipData( button )
	Hud_SetLocked( button, false )

	if ( IsLobby() )
		return

	if ( position >= SURVIVAL_GetInventoryLimit( player ) )
	{
		Hud_SetEnabled( button, false )
		return
	}

	array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )
	if ( playerInventory.len() <= position )
	{
		RunUIScript( "ClientToUI_Tooltip_Clear", button )
		return
	}

	ConsumableInventoryItem item = playerInventory[ position ]

	if ( !SURVIVAL_Loot_IsLootIndexValid( item.type ) )
	{
		RunUIScript( "ClientToUI_Tooltip_Clear", button )
		return
	}

	LootData lootData = SURVIVAL_Loot_GetLootDataByIndex( item.type )
	RuiSetImage( rui, "iconImage", lootData.hudIcon )
	RuiSetInt( rui, "lootTier", lootData.tier )
	RuiSetInt( rui, "count", item.count )
	RuiSetInt( rui, "maxCount", SURVIVAL_GetInventorySlotCountForPlayer( player, lootData ) )

	RuiSetBool( rui, "isInfinite", false )
	if ( PlayerHasPassive( player, ePassives.PAS_INFINITE_HEAL ) && lootData.lootType == eLootType.HEALTH )
	{
		RuiSetBool( rui, "isInfinite", true )
	}

	if ( lootData.lootType == eLootType.AMMO )
		RuiSetInt( rui, "numPerPip", lootData.countPerDrop )
	else
		RuiSetInt( rui, "numPerPip", 1 )

	UpdateLockStatusForBackpackItem( button, player, lootData )

	Hud_SetSelected( button, IsOrdnanceEquipped( player, lootData.ref ) )

	RunUIScript( "ClientToUI_Tooltip_MarkForClientUpdate", button, eTooltipStyle.LOOT_PROMPT )

	ToolTipData dt
	dt.tooltipStyle = eTooltipStyle.LOOT_PROMPT
	dt.lootPromptData.count = item.count
	dt.lootPromptData.index = item.type
	dt.lootPromptData.lootContext = eLootContext.BACKPACK
	dt.tooltipFlags = IsPingEnabledForPlayer( player ) ? dt.tooltipFlags : dt.tooltipFlags | eToolTipFlag.PING_DISSABLED

	Hud_SetToolTipData( button, dt )
}


void function UICallback_PingInventoryItem( var button, int position )
{
	entity player = GetLocalClientPlayer()
	array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )

	if ( playerInventory.len() <= position )
		return

	if ( IsLobby() )
		return

	int commsAction = GetCommsActionForBackpackItem( button, position )
	if ( commsAction != eCommsAction.BLANK )
	{
		EmitSoundOnEntity( player, PING_SOUND_DEFAULT )
		RunUIScript( "ClientToUI_SurvivalQuickInventory_MarkInventoryButtonPinged", button )
		Remote_ServerCallFunction( "ClientCallback_Quickchat", commsAction, eCommsFlags.NONE, null, "" )
	}
}


void function UICallback_OnInventoryButtonAction( var button, int position )
{
	if ( IsLobby() )
		return

	OnInventoryButtonAction( button, position, false )
}


void function UICallback_OnInventoryButtonAltAction( var button, int position )
{
	if ( IsLobby() )
		return

	OnInventoryButtonAction( button, position, true )
}


void function OnInventoryButtonAction( var button, int position, bool isAltAction )
{
	entity player = GetLocalClientPlayer()

	array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )
	if ( playerInventory.len() <= position )
		return

	ConsumableInventoryItem item = playerInventory[ position ]

	if ( !SURVIVAL_Loot_IsLootIndexValid( item.type ) )
		return

	LootData lootData = SURVIVAL_Loot_GetLootDataByIndex( item.type )
	bool didSomething = DispatchLootAction( eLootContext.BACKPACK, SURVIVAL_GetActionForBackpackItem( player, lootData, isAltAction ).action, position )
	if ( didSomething )
		RunUIScript( "ClientToUI_SurvivalQuickInventory_MarkInventoryButtonUsed", button )
}


void function UpdateLockStatusForBackpackItem( var button, entity player, LootData lootData )
{
	if ( !SURVIVAL_Loot_IsRefValid( lootData.ref ) )
		return

	Hud_SetLocked( button, SURVIVAL_IsLootIrrelevant( player, null, lootData, eLootContext.BACKPACK ) )
}

bool function IsItemEquipped_Gadget( entity player, string ref )
{
	if ( !player.IsTitan() )
	{
		entity ordnance = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_ANTI_TITAN )
		if( IsValid( ordnance ) && ordnance.GetWeaponClassName() == ref )
			return true

		entity gadget = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_GADGET )
		if( IsValid( gadget ) && gadget.GetWeaponClassName() == ref )
			return true
	}

	return false
}

bool function IsOrdnanceEquipped( entity player, string ref )
{
	if ( !player.IsTitan() && IsValid( player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_ANTI_TITAN ) ) )
	{
		return player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_ANTI_TITAN ).GetWeaponClassName() == ref
	}

	return false
}


bool function DispatchLootAction( int lootContext, int lootAction, var param, bool isAltAction = false, bool actionFromMenu = true )
{
	if ( lootAction == eLootAction.NONE )
		return false

	switch ( lootContext )
	{
		case eLootContext.BACKPACK:
			return BackpackAction( lootAction, string( param ) )

		case eLootContext.EQUIPMENT:
			return EquipmentAction( lootAction, string( param ) )

		case eLootContext.GROUND:
			GroundAction( lootAction, string( param ), isAltAction, actionFromMenu )
			return true
	}

	return false
}


int function GetCommsActionForBackpackItem( var button, int position )
{
	entity player = GetLocalClientPlayer()
	array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )
	if ( ( position < playerInventory.len() ) && ( position >= 0 ) )
	{
		ConsumableInventoryItem item = playerInventory[ position ]
		LootData lootData = SURVIVAL_Loot_GetLootDataByIndex( item.type )

		if (lootData.lootType == eLootType.AMMO)
		{
			switch ( AmmoType_GetTypeFromRef( lootData.ref ) )
			{
				case eAmmoPoolType.bullet:
					return eCommsAction.INVENTORY_NEED_AMMO_BULLET

				case eAmmoPoolType.special:
					return eCommsAction.INVENTORY_NEED_AMMO_SPECIAL

				case eAmmoPoolType.highcal:
					return eCommsAction.INVENTORY_NEED_AMMO_HIGHCAL

				case eAmmoPoolType.shotgun:
					return eCommsAction.INVENTORY_NEED_AMMO_SHOTGUN

				case eAmmoPoolType.sniper:
					return eCommsAction.INVENTORY_NEED_AMMO_SNIPER
				case eAmmoPoolType.arrows:
					return eCommsAction.INVENTORY_NEED_AMMO_ARROWS
			}
		}
	}

	return eCommsAction.BLANK
}

void function UICallback_UpdateRequestButton( var button )
{
	if ( IsLobby() )
		return

	entity player        = GetLocalClientPlayer()
	var rui              = Hud_GetRui( button )
	string requestButton = Hud_GetScriptID( button )

	LootData loot = EquipmentSlot_GetEquippedLootDataForSlot ( player, requestButton )


	Hud_Hide( button )
	Hud_ClearToolTipData( button )

	if ( !SURVIVAL_Loot_IsRefValid( loot.ref ) )
		return

	string weaponName = loot.baseWeapon

                     
	                                                                                                     
	if (weaponName == "mp_weapon_dragon_lmg")
		return
      

	if ( GetWeaponInfoFileKeyField_GlobalInt_WithDefault ( weaponName, "has_energized", 0 ) == 1 )
	{
		string energizedConsumableData = GetWeaponInfoFileKeyField_GlobalString ( weaponName, "energized_consumable" )
		string pingStringData = GetWeaponInfoFileKeyField_GlobalString ( weaponName, "energized_ping_string" )
		string commsData = GetWeaponInfoFileKeyField_GlobalString ( weaponName, "energized_comms" )

		LootData ordanenceData = SURVIVAL_Loot_GetLootDataByRef ( energizedConsumableData )

		RuiSetImage( rui, "iconImage", ordanenceData.hudIcon )
		RuiSetString( rui, "iconName", Localize ( pingStringData ) )
		Hud_Show( button )

		ToolTipData dt
		PopulateTooltipWithTitleAndDesc( ordanenceData, dt )

		dt.commsAction = eCommsAction[ commsData ]

		dt.tooltipFlags = IsPingEnabledForPlayer( player ) ? dt.tooltipFlags : dt.tooltipFlags | eToolTipFlag.PING_DISSABLED

		Hud_SetToolTipData( button, dt )
		RunUIScript( "ClientToUI_Tooltip_MarkForClientUpdate", button, eTooltipStyle.DEFAULT )

	}
}

void function UICallback_UpdateEquipmentButton( var button )
{
	entity player        = GetLocalClientPlayer()
	var rui              = Hud_GetRui( button )
	string equipmentSlot = Hud_GetScriptID( button )

	if ( !EquipmentSlot_IsValidForPlayer( equipmentSlot, player ) )
	{
		Hud_Hide( button )
		return
	}

	Hud_Show( button )
	LootData data    = EquipmentSlot_GetEquippedLootDataForSlot( player, equipmentSlot )
	string equipment = data.ref

	RuiSetImage( rui, "iconImage", GetEmptyEquipmentImage( equipmentSlot ) )
	RuiSetInt( rui, "lootTier", 0 )
	RuiSetInt( rui, "count", 0 )
	RuiSetString( rui, "passiveText", "" )
	RuiSetImage( rui, "ammoTypeImage", $"" )
	Hud_ClearToolTipData( button )
	RuiSetBool( rui, "hasAltAmmo", false )
	RuiSetImage( rui, "altAmmoIcon", $"" )
	RuiSetInt( rui, "altMaxAmmo", 0 )
	if ( IsLobby() )
		return

	EquipmentSlot es = Survival_GetEquipmentSlotDataByRef( equipmentSlot )

	if ( es.weaponSlot >= 0 )
		RuiSetImage( rui, "iconImage", $"" )

	if ( equipment == "" )
	{
		int tooltipFlags = IsPingEnabledForPlayer( player ) && !GetCurrentPlaylistVarBool( "disable_empty_slot_ping", false ) ? 0 : eToolTipFlag.PING_DISSABLED
		RunUIScript( "SurvivalQuickInventory_SetEmptyTooltipForSlot", button, Localize( "#TOOLTIP_EMPTY_PROMPT", Localize( es.title ) ), eCommsAction.BLANK, tooltipFlags )
	}
	else
	{
		EquipmentButtonInit( button, equipmentSlot, data, 0 )
	}

	LootData gadgetLootData = EquipmentSlot_GetEquippedLootDataForSlot( player, "gadgetslot" )
	string equipRef         = EquipmentSlot_GetLootRefForSlot( player, "gadgetslot" )
	if( equipment == equipRef )
	{
		entity gadgetWeapon = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_GADGET )
		if( IsValid( gadgetWeapon ) && SURVIVAL_Loot_IsRefValid( gadgetLootData.ref ) )
		{
			if ( gadgetWeapon.GetWeaponPrimaryClipCount()  > 0 )
			{
				RuiSetInt( rui, "maxCount", gadgetWeapon.GetWeaponPrimaryClipCountMax() )
				RuiSetInt( rui, "count", gadgetWeapon.GetWeaponPrimaryClipCount() )
				RuiSetInt( rui, "numPerPip", 1 )
			}
		}
	}

	if ( EquipmentSlot_IsAttachmentSlot( equipmentSlot ) )
	{
		string attachmentPoint = EquipmentSlot_GetAttachmentPointForSlot( equipmentSlot )
		EquipmentSlot esWeapon = Survival_GetEquipmentSlotDataByRef( es.attachmentWeaponSlot )
		entity weapon          = player.GetNormalWeapon( esWeapon.weaponSlot )

		LootData wData = SURVIVAL_GetLootDataFromWeapon( weapon )
		                                                     
		RuiSetBool( rui, "isFullyKitted", SURVIVAL_IsAttachmentPointLocked( wData.ref, attachmentPoint ) )
		RuiSetBool( rui, "showBrackets", true )

		if ( IsValid( weapon ) && SURVIVAL_Loot_IsRefValid( wData.ref ) && AttachmentPointSupported( attachmentPoint, wData.ref ) )
		{
			Hud_SetEnabled( button, true )
			Hud_SetWidth( button, Hud_GetBaseWidth( button ) )
			if ( equipment == "" )
			{
				string attachmentStyle = GetAttachmentPointStyle( attachmentPoint, wData.ref )
				RuiSetImage( rui, "iconImage", emptyAttachmentSlotImages[attachmentStyle] )
			}
			else
			{
				RuiSetInt( rui, "count", 1 )

				if ( SURVIVAL_IsAttachmentPointLocked( wData.ref, attachmentPoint ) )
				{
					RuiSetInt( rui, "lootTier", wData.tier )
				}
			}
		}
		else
		{
			RuiSetImage( rui, "iconImage", $"" )
			RuiSetInt( rui, "lootTier", 0 )
			Hud_SetWidth( button, 0 )
			Hud_SetEnabled( button, false )
			RunUIScript( "ClientToUI_Tooltip_Clear", button )
		}
	}

	if ( es.weaponSlot >= 0 )
	{
		int slot = SURVIVAL_GetActiveWeaponSlot( player )
		if ( slot < 0 )
			slot = 0

		RuiSetString( rui, "weaponSlotString", "#MENU_WEAPON_SLOT" + es.weaponSlot )
		RuiSetString( rui, "weaponSlotStringConsole", "#MENU_WEAPON_SLOT_CONSOLE" + es.weaponSlot )

		RuiSetString( rui, "weaponName", "" )
		RuiSetString( rui, "skinName", "" )
		RuiSetInt( rui, "skinTier", 0 )
		RuiSetInt( rui, "count", 0 )

                    
			RuiSetBool( rui, "isPaintballWeapon", false )
        

		entity weapon = player.GetNormalWeapon( es.weaponSlot )

		int skinTier    = 0
		string skinName = ""

		string charmName = ""

		if ( IsValid( weapon ) )
		{
			RuiSetInt( rui, "count", weapon.UsesClipsForAmmo() ? weapon.GetWeaponPrimaryClipCount() : player.AmmoPool_GetCount( weapon.GetWeaponAmmoPoolType() ) )

			RuiSetString( rui, "weaponName", data.pickupString )

                     
				if ( weapon.HasMod( WEAPON_LOCKEDSET_MOD_BLUEPAINTBALL ) || weapon.HasMod( WEAPON_LOCKEDSET_MOD_PURPLEPAINTBALL ) || weapon.HasMod( WEAPON_LOCKEDSET_MOD_GOLDPAINTBALL ) )
					RuiSetBool( rui, "isPaintballWeapon", true )
         

			ItemFlavor ornull weaponItemOrNull = GetWeaponItemFlavorByClass( weapon.GetWeaponClassName() )
			if ( weaponItemOrNull != null )
			{
				expect ItemFlavor(weaponItemOrNull)

				if ( IsValidItemFlavorNetworkIndex( weapon.GetGrade(), eValidation.DONT_ASSERT ) )
				{
					ItemFlavor weaponSkin = GetItemFlavorByNetworkIndex( weapon.GetGrade() )
					RuiSetString( rui, "skinName", ItemFlavor_GetLongName( weaponSkin ) )
					if ( ItemFlavor_HasQuality( weaponSkin ) )
						RuiSetInt( rui, "skinTier", ItemFlavor_GetQuality( weaponSkin ) + 1 )

					ItemFlavor ornull weaponSkinOrNull = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_WeaponSkin( weaponItemOrNull ) )
					if ( weaponSkinOrNull != null && weaponSkinOrNull != weaponSkin )
					{
						expect ItemFlavor( weaponSkinOrNull )
						if ( ItemFlavor_HasQuality( weaponSkinOrNull ) )
						{
							skinTier = ItemFlavor_GetQuality( weaponSkinOrNull ) + 1
							skinName = ItemFlavor_GetLongName( weaponSkinOrNull )
						}
					}
				}

				if ( IsValidItemFlavorNetworkIndex( weapon.GetWeaponCharmIndex(), eValidation.DONT_ASSERT ) )
				{
					ItemFlavor weaponCharm              = GetItemFlavorByNetworkIndex( weapon.GetWeaponCharmIndex() )
					ItemFlavor ornull weaponCharmOrNull = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_WeaponCharm( weaponItemOrNull ) )
					if ( weaponCharmOrNull != null && weaponCharmOrNull != weaponCharm )
					{
						expect ItemFlavor( weaponCharmOrNull )
						charmName = ItemFlavor_GetLongName( weaponCharmOrNull )
					}
				}
			}

			RunUIScript( "SurvivalQuickInventory_UpdateEquipmentForActiveWeapon", slot )
			RunUIScript( "SurvivalQuickInventory_UpdateWeaponSlot", es.weaponSlot, skinTier, skinName, charmName )
		}
	}
}


void function EquipmentButtonInit( var button, string equipmentSlot, LootData lootData, int count )
{
	entity player = GetLocalClientPlayer()
	var rui       = Hud_GetRui( button )
	RuiSetImage( rui, "iconImage", lootData.hudIcon )
	RuiSetInt( rui, "lootTier", lootData.tier )
	RuiSetInt( rui, "count", count )
	RuiSetBool( rui, "dimIcon", SURVIVAL_EquipmentPretendsToBeBlank( lootData.ref ) )

	                                              
	  	                                                                      
	                                                                                     
	RuiSetString( rui, "passiveText", "" )                                

	bool isMainWeapon = EquipmentSlot_IsMainWeaponSlot( equipmentSlot )

	if ( isMainWeapon )
	{
		asset icon      = lootData.fakeAmmoIcon
		entity weapon   = player.GetNormalWeapon( Survival_GetEquipmentSlotDataByRef( equipmentSlot ).weaponSlot )
		string ammoTypeRef = AmmoType_GetRefFromIndex( weapon.GetWeaponAmmoPoolType() )

		if ( SURVIVAL_Loot_IsRefValid( ammoTypeRef ) && IsValid( weapon ) && weapon.GetWeaponSettingBool( eWeaponVar.uses_ammo_pool ) )
		{
			LootData ammoData = SURVIVAL_Loot_GetLootDataByRef( ammoTypeRef )
			icon = ammoData.hudIcon
		}
		RuiSetImage( rui, "ammoTypeImage", icon )
		Weapon_UpdateAltAmmoRui(rui, player, weapon, false)
	}

	ToolTipData dt
	PopulateTooltipWithTitleAndDesc( lootData, dt )
	LootRef lootRef = SURVIVAL_CreateLootRef( lootData, null )

	LootActionStruct asMain = SURVIVAL_BuildStringForAction( player, eLootContext.EQUIPMENT, lootRef, false, true )
	SURVIVAL_UpdateStringForEquipmentAction( player, equipmentSlot, asMain, lootRef )
	LootActionStruct asAlt = SURVIVAL_BuildStringForAction( player, eLootContext.EQUIPMENT, lootRef, true, true )
	SURVIVAL_UpdateStringForEquipmentAction( player, equipmentSlot, asAlt, lootRef )

	dt.actionHint1 = Localize( asMain.displayString ).toupper()
	dt.actionHint2 = Localize( asAlt.displayString ).toupper()

	dt.commsAction = GetCommsActionForEquipmentSlot( equipmentSlot )

	dt.tooltipFlags = IsPingEnabledForPlayer( player ) ? dt.tooltipFlags : dt.tooltipFlags | eToolTipFlag.PING_DISSABLED

	Hud_SetToolTipData( button, dt )
	RunUIScript( "ClientToUI_Tooltip_MarkForClientUpdate", button, eTooltipStyle.DEFAULT )
}


void function PopulateTooltipWithTitleAndDesc( LootData lootData, ToolTipData dt )
{
	dt.tooltipFlags = dt.tooltipFlags | eToolTipFlag.SOLID
	dt.titleText = SURVIVAL_Loot_GetPickupString( lootData, GetLocalViewPlayer() )
	dt.descText = SURVIVAL_Loot_GetDesc( lootData, GetLocalViewPlayer() )
}


void function UICallback_OnEquipmentButtonAction( var button )
{
	if ( IsLobby() )
		return

	OnEquipmentButtonAction( button, false )
}


void function UICallback_OnEquipmentButtonAltAction( var button, bool fromExtendedUse )
{
	if ( IsLobby() )
		return

	OnEquipmentButtonAction( button, true, fromExtendedUse )
}


void function OnEquipmentButtonAction( var button, bool isAltAction, bool fromExtendedUse = false )
{
	entity player = GetLocalClientPlayer()

	string equipmentType = Hud_GetScriptID( button )
	LootData data        = EquipmentSlot_GetEquippedLootDataForSlot( player, equipmentType )
	string equipmentRef  = data.ref
	if ( equipmentRef == "" || SURVIVAL_EquipmentPretendsToBeBlank( equipmentRef ) )
		return

	LootData lootData   = SURVIVAL_Loot_GetLootDataByRef( equipmentRef )
	LootActionStruct as = SURVIVAL_GetActionForEquipment( player, lootData, isAltAction )
	LootRef lootRef     = SURVIVAL_CreateLootRef( lootData, null )

	SURVIVAL_UpdateStringForEquipmentAction( player, equipmentType, as, lootRef )
	if ( as.action == eLootAction.DROP && lootData.lootType == eLootType.MAINWEAPON && !fromExtendedUse )
	{
		RunUIScript( "ClientCallback_StartEquipmentExtendedUse", button, 0.4 )
	}
	else
	{
		bool didSomething = DispatchLootAction( eLootContext.EQUIPMENT, as.action, equipmentType )
		if ( didSomething )
			RunUIScript( "ClientToUI_SurvivalQuickInventory_MarkInventoryButtonUsed", button )
	}
}

                            
void function UICallback_PingIsMyUltimateReady( var button )
{
	if ( IsLobby() )
		return

	entity player = GetLocalClientPlayer()
	int commsAction = GetCommsActionForUltReady( player )
	if ( commsAction == eCommsAction.BLANK )
		return

	EmitSoundOnEntity( player, PING_SOUND_DEFAULT )
	RunUIScript( "ClientToUI_SurvivalQuickInventory_MarkInventoryButtonPinged", button )

	entity ultimate = player.GetOffhandWeapon( OFFHAND_ULTIMATE )
	PIN_UltimateReadyPing( player, GetEnumString( "eCommsAction", commsAction ).tolower(), ultimate != null )
	Quickchat( player, commsAction, ultimate )
}
                                  

void function UICallback_PingRequestButton ( var button )
{
	if ( IsLobby() )
		return

	entity player    = GetLocalClientPlayer()
	string requestButton = Hud_GetScriptID( button )

	LootData loot = EquipmentSlot_GetEquippedLootDataForSlot ( player, requestButton )


	if ( !SURVIVAL_Loot_IsRefValid( loot.ref ) )
		return

	string weaponName = loot.baseWeapon

	if ( GetWeaponInfoFileKeyField_GlobalInt_WithDefault ( weaponName, "has_energized", 0 ) == 1 )
	{
		EmitSoundOnEntity( player, PING_SOUND_DEFAULT )
		string commsData = GetWeaponInfoFileKeyField_GlobalString ( weaponName, "energized_comms" )

		Quickchat( player, eCommsAction [ commsData ] )
	}
}

void function UICallback_PingEquipmentItem( var button )
{
	if ( IsLobby() )
		return

	entity player    = GetLocalClientPlayer()
	string equipSlot = Hud_GetScriptID( button )
	int commsAction  = GetCommsActionForEquipmentSlot( equipSlot )
	if ( commsAction == eCommsAction.BLANK )
		return

	EmitSoundOnEntity( player, PING_SOUND_DEFAULT )
	RunUIScript( "ClientToUI_SurvivalQuickInventory_MarkInventoryButtonPinged", button )

	Remote_ServerCallFunction( "ClientCallback_Quickchat_UI", commsAction, eCommsFlags.NONE, equipSlot )
}


int function GetCommsActionForEquipmentSlot( string equipSlot )
{
	entity player       = GetLocalClientPlayer()
	LootData data       = EquipmentSlot_GetEquippedLootDataForSlot( player, equipSlot )
	string equipmentRef = data.ref
	bool isEmpty        = (equipmentRef == "" || SURVIVAL_EquipmentPretendsToBeBlank( equipmentRef ) )

	return Survival_GetCommsActionForEquipmentSlot( equipSlot, equipmentRef, isEmpty )
}


int function SortByAmmoThenTierThenPriority( GroundLootData a, GroundLootData b )
{
	if ( a.lootData.lootType == eLootType.AMMO && b.lootData.lootType != eLootType.AMMO )
		return -1
	else if ( a.lootData.lootType != eLootType.AMMO && b.lootData.lootType == eLootType.AMMO )
		return 1

	if ( a.lootData.lootType == eLootType.MAINWEAPON && b.lootData.lootType != eLootType.MAINWEAPON )
		return -1
	else if ( a.lootData.lootType != eLootType.MAINWEAPON && b.lootData.lootType == eLootType.MAINWEAPON )
		return 1

	return SortByTierThenPriority( a, b )
}


int function SortByTierThenPriority( GroundLootData a, GroundLootData b )
{
	int aPriority = GetPriorityForLootType( a.lootData )
	int bPriority = GetPriorityForLootType( b.lootData )

	if ( a.lootData.tier > b.lootData.tier )
		return -1
	if ( a.lootData.tier < b.lootData.tier )
		return 1

	if ( aPriority < bPriority )
		return -1
	else if ( aPriority > bPriority )
		return 1

	if ( a.lootData.lootType < b.lootData.lootType )
		return -1
	if ( a.lootData.lootType > b.lootData.lootType )
		return 1

	if ( a.guids.len() > b.guids.len() )
		return -1
	if ( a.guids.len() < b.guids.len() )
		return 1

	return 0
}


int function SortByPriorityThenTierForGroundLoot( GroundLootData a, GroundLootData b )
{
	int aPriority = GetPriorityForLootType( a.lootData )
	int bPriority = GetPriorityForLootType( b.lootData )

	if ( aPriority < bPriority )
		return -1
	else if ( aPriority > bPriority )
		return 1

	if ( a.lootData.lootType < b.lootData.lootType )
		return -1
	if ( a.lootData.lootType > b.lootData.lootType )
		return 1

	if ( a.lootData.tier > b.lootData.tier )
		return -1
	if ( a.lootData.tier < b.lootData.tier )
		return 1


	return 0
}


void function UICallback_EnableTriggerStrafing()
{
	                                                                             
	                                                                             
	  
	                                                                        
	                                                                         
}


void function UICallback_DisableTriggerStrafing()
{
	                                                                            
	                                                                            
	  
	                                                      
	                                                      
}


void function UIToClient_UpdateGroundMenuHeader( var elem )
{
	var rui     = Hud_GetRui( elem )
	string text = "#PLAYER_ITEMS"

	if ( file.currentGroundListData.behavior == eGroundListBehavior.NEARBY )
	{
		text = "#NEARBY_ITEMS"
	}
	else if ( IsValid( file.currentGroundListData.deathBox ) && file.currentGroundListData.behavior == eGroundListBehavior.CONTENTS )
	{
		string overrideName = file.currentGroundListData.deathBox.GetCustomOwnerName()
		if ( overrideName != "" )
		{
			text = Localize( "#PLAYERS_ITEMS", overrideName )
		}
		else
		{
			EHI ornull ehi = GetDeathBoxOwnerEHI( file.currentGroundListData.deathBox )
			if ( ehi != null )
			{
				expect EHI( ehi )
				if ( EHIHasValidScriptStruct( ehi ) )
				{
					string playerName = GetPlayerNameFromEHI( ehi )
					text = Localize( "#PLAYERS_ITEMS", playerName )
				}
			}
		}
	}

	RuiSetString( rui, "headerText", text )
}


void function UICallback_UpdateGroundItem( var button, int position )
{
	entity player = GetLocalClientPlayer()
	var rui       = Hud_GetRui( button )
	Hud_ClearToolTipData( button )

	if ( IsLobby() )
		return

	if ( position >= file.filteredGroundItems.len() )
		return

	GroundLootData groundLootData = file.filteredGroundItems[position]

	Hud_SetLocked( button, false )
	Hud_SetEnabled( button, !groundLootData.isHeader )                                                        

	RuiSetImage( rui, "iconImage", $"" )
	RuiSetInt( rui, "lootTier", 0 )
	RuiSetInt( rui, "count", 0 )
	RuiSetInt( rui, "lootType", 0 )
	RuiSetBool( rui, "isPinged", false )
	RuiSetBool( rui, "showWhenEmpty", false )
	RuiSetImage( rui, "ammoTypeImage", $"" )
	RuiSetBool( rui, "isUpgrade", false )

	RuiSetBool( rui, "isHeader", groundLootData.isHeader )

	if ( groundLootData.isHeader )
	{
		RuiSetImage( rui, "iconImage", groundLootData.lootData.hudIcon )
		RuiSetString( rui, "buttonText", groundLootData.lootData.pickupString )
		return
	}

	entity ent = GetEntFromGroundLootData( groundLootData )

	if ( !IsValid( ent ) )
	{
		Hud_SetEnabled( button, false )
		return
	}

	bool isMainWeapon = (groundLootData.lootData.lootType == eLootType.MAINWEAPON)

	bool isPinged          = false
	bool isPingedByUs      = false
	int groundLootPingedBy = GetGroundLootPingedBy( groundLootData )
	if ( groundLootPingedBy == eGroundLootPingedBy.PLAYER )
	{
		isPingedByUs = true
		isPinged = true
	}
	else if ( groundLootPingedBy == eGroundLootPingedBy.ANYONEELSE )
		isPinged = true

	RuiSetString( rui, "buttonText", SURVIVAL_Loot_GetPickupString( groundLootData.lootData, player ) )
	RuiSetImage( rui, "iconImage", groundLootData.lootData.hudIcon )
	RuiSetInt( rui, "lootTier", groundLootData.lootData.tier )
	RuiSetInt( rui, "count", groundLootData.count )
	RuiSetInt( rui, "lootType", groundLootData.lootData.lootType )
	RuiSetBool( rui, "isPinged", isPinged )
	RuiSetImage( rui, "ammoTypeImage", $"" )

	if ( isMainWeapon )
	{
		string ammoType = groundLootData.lootData.ammoType
		asset icon      = $""
		if ( SURVIVAL_Loot_IsRefValid( ammoType ) && ent.GetWeaponSettingBool( eWeaponVar.uses_ammo_pool ) )
		{
			LootData ammoData = SURVIVAL_Loot_GetLootDataByRef( ammoType )
			icon = ammoData.hudIcon
		}
		RuiSetImage( rui, "ammoTypeImage", icon )
	}

	Hud_SetLocked( button, !groundLootData.isRelevant )
	RuiSetBool( rui, "isUpgrade", groundLootData.isUpgrade )

	ToolTipData dt
	dt.tooltipStyle = isMainWeapon ? eTooltipStyle.WEAPON_LOOT_PROMPT : eTooltipStyle.LOOT_PROMPT

	if ( groundLootData.guids.len() > 0 )
		dt.lootPromptData.guid = groundLootData.guids[0]

	dt.lootPromptData.count = groundLootData.count
	dt.lootPromptData.index = groundLootData.lootData.index
	dt.lootPromptData.lootContext = eLootContext.GROUND
	dt.lootPromptData.isPinged = isPinged
	dt.lootPromptData.isPingedByUs = isPingedByUs
	dt.lootPromptData.property = GetPropSurvivalMainPropertyFromEnt( ent )
	dt.tooltipFlags = IsPingEnabledForPlayer( player ) ? dt.tooltipFlags : dt.tooltipFlags | eToolTipFlag.PING_DISSABLED

	if ( isMainWeapon )
		dt.lootPromptData.mods = ent.GetWeaponMods()

	Hud_SetToolTipData( button, dt )

	RunUIScript( "ClientToUI_Tooltip_MarkForClientUpdate", button, groundLootData.lootData.lootType == eLootType.MAINWEAPON ? eTooltipStyle.WEAPON_LOOT_PROMPT : eTooltipStyle.LOOT_PROMPT )
}


bool function IsGroundLootPinged( GroundLootData grounLootData, entity player = null )
{
	foreach ( guid in grounLootData.guids )
	{
		entity ent = GetEntityFromEncodedEHandle( guid )
		if ( IsValid( ent ) )
		{
			if ( player == null )
			{
				if ( Waypoint_LootItemIsBeingPingedByAnyone( ent ) )
					return true
			}
			else
			{
				entity pingWaypoint = Waypoint_GetWaypointForLootItemPingedByPlayer( ent, player )
				if ( IsValid( pingWaypoint ) )
					return true
			}
		}
	}

	return false
}


int function GetGroundLootPingedBy( GroundLootData grounLootData )
{
	foreach ( guid in grounLootData.guids )
	{
		entity ent = GetEntityFromEncodedEHandle( guid )
		if ( IsValid( ent ) )
		{
			entity pingWaypoint = Waypoint_GetWaypointForLootItemPingedByPlayer( ent, GetLocalClientPlayer() )
			if ( IsValid( pingWaypoint ) )
				return eGroundLootPingedBy.PLAYER

			if ( Waypoint_LootItemIsBeingPingedByAnyone( ent ) )
				return eGroundLootPingedBy.ANYONEELSE
		}
	}

	return eGroundLootPingedBy.NOONE
}


void function UICallback_GroundItemAction( var button, int position, bool fromExtendedUse )
{
	entity player = GetLocalClientPlayer()

	if ( IsLobby() )
		return

	if ( position >= file.filteredGroundItems.len() )
		return

	GroundLootData groundLootData = file.filteredGroundItems[position]

	if ( groundLootData.guids.len() == 0 )
		return

	bool isInventoryFull = SURVIVAL_AddToPlayerInventory( player, groundLootData.lootData.ref ) == 0

	entity ent = GetEntFromGroundLootData( groundLootData )

	LootRef lootRef  = SURVIVAL_CreateLootRef( groundLootData.lootData, ent )
	int groundAction = SURVIVAL_GetActionForGroundItem( player, lootRef, false ).action

	if ( groundAction == eLootAction.SWAP && !fromExtendedUse )
	{
		RunUIScript( "ClientToUI_StartGroundItemExtendedUse", "ground", button, position, 0.4 )
	}
	else if ( isInventoryFull && (groundAction == eLootAction.PICKUP) && (lootRef.lootData.ref != "s4t_item0") )
	{
		file.swapString = Localize( groundLootData.lootData.pickupString )
		RunUIScript( "ClientToUI_GroundItem_OpenQuickSwap", button, groundLootData.guids[0] )
	}
	else
	{
		bool didSomething = DispatchLootAction( eLootContext.GROUND, groundAction, groundLootData.guids.top() )
		if ( didSomething )
			RunUIScript( "ClientToUI_SurvivalQuickInventory_MarkInventoryButtonUsed", button )
	}
}


void function UICallback_GroundItemAltAction( var button, int position )
{
	if ( IsLobby() )
		return

	if ( position >= file.filteredGroundItems.len() )
		return

	entity player                 = GetLocalClientPlayer()
	GroundLootData groundLootData = file.filteredGroundItems[position]

	if ( groundLootData.guids.len() == 0 )
		return

	entity ent = GetEntFromGroundLootData( groundLootData )

	LootRef lootRef = SURVIVAL_CreateLootRef( groundLootData.lootData, ent )

	bool isInventoryFull = SURVIVAL_AddToPlayerInventory( player, groundLootData.lootData.ref ) == 0

	int groundAction = SURVIVAL_GetActionForGroundItem( player, lootRef, true ).action

	if ( isInventoryFull && groundAction == eLootAction.PICKUP )
	{
		file.swapString = Localize( groundLootData.lootData.pickupString )
		RunUIScript( "ClientToUI_GroundItem_OpenQuickSwap", button, groundLootData.guids[0] )
	}
	else
	{
		bool didSomething = DispatchLootAction( eLootContext.GROUND, SURVIVAL_GetActionForGroundItem( player, lootRef, true ).action, groundLootData.guids.top(), true, false )
		if ( didSomething )
			RunUIScript( "ClientToUI_SurvivalQuickInventory_MarkInventoryButtonUsed", button )
	}
}


void function UICallback_PingGroundListItem( var button, int position )
{
	entity player = GetLocalClientPlayer()

	if ( IsLobby() )
		return

	if ( position >= file.filteredGroundItems.len() )
		return

	GroundLootData groundLootData = file.filteredGroundItems[position]

	if ( groundLootData.guids.len() == 0 )
		return

	PingGroundLoot( GetEntityFromEncodedEHandle( groundLootData.guids.top() ), Survival_GetDeathBox() )
}


void function UICallback_AddVisibleItem( int index )
{
	file.visibleItemIndices.append( index )
}


void function SetQuickSwapString( string str )
{
	file.swapString = str
}


void function UICallback_UpdateQuickSwapItem( var button, int position )
{
	entity player = GetLocalClientPlayer()
	var rui       = Hud_GetRui( button )

	Hud_SetSelected( button, false )
	Hud_SetLocked( button, false )
	RuiSetImage( rui, "iconImage", $"" )
	RuiSetInt( rui, "lootTier", 0 )
	RuiSetInt( rui, "count", 0 )

	if ( IsLobby() )
		return

	if ( position >= SURVIVAL_GetInventoryLimit( player ) )
	{
		Hud_ClearToolTipData( button )
		Hud_SetEnabled( button, false )
		return
	}

	Hud_SetEnabled( button, true )

	array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )
	if ( playerInventory.len() <= position )
	{
		RunUIScript( "ClientToUI_Tooltip_Clear", button )
		return
	}

	ConsumableInventoryItem item = playerInventory[position]

	LootData lootData = SURVIVAL_Loot_GetLootDataByIndex( item.type )
	RuiSetImage( rui, "iconImage", lootData.hudIcon )
	RuiSetInt( rui, "lootTier", lootData.tier )
	RuiSetInt( rui, "count", item.count )
	RuiSetInt( rui, "maxCount", SURVIVAL_GetInventorySlotCountForPlayer( player, lootData ) )

	RuiSetBool( rui, "isInfinite", false )
	if ( PlayerHasPassive( player, ePassives.PAS_INFINITE_HEAL ) && lootData.lootType == eLootType.HEALTH )
	{
		RuiSetBool( rui, "isInfinite", true )
	}

	if ( lootData.lootType == eLootType.AMMO )
		RuiSetInt( rui, "numPerPip", lootData.countPerDrop )
	else
		RuiSetInt( rui, "numPerPip", 1 )

	ToolTipData toolTipData
	toolTipData.titleText = lootData.pickupString
	toolTipData.descText = SURVIVAL_Loot_GetDesc( lootData, player )
	toolTipData.actionHint1 = Localize( "#LOOT_SWAP", file.swapString ).toupper()
	toolTipData.tooltipFlags = IsPingEnabledForPlayer( player ) ? toolTipData.tooltipFlags : toolTipData.tooltipFlags | eToolTipFlag.PING_DISSABLED

	if ( Survival_PlayerCanDrop( player ) )
		toolTipData.actionHint2 = Localize( "#LOOT_ALT_DROP" ).toupper()

	Hud_SetToolTipData( button, toolTipData )
	RunUIScript( "ClientToUI_Tooltip_MarkForClientUpdate", button, eTooltipStyle.DEFAULT )

	Hud_SetSelected( button, IsOrdnanceEquipped( player, lootData.ref ) )
	Hud_SetLocked( button, SURVIVAL_IsLootIrrelevant( player, null, lootData, eLootContext.BACKPACK ) )
}


void function UICallback_OnQuickSwapItemClick( var button, int position )
{
	if ( IsLobby() )
		return

	entity player                                  = GetLocalClientPlayer()
	array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )

	int slot = -1
	if ( playerInventory.len() > position )
	{
		slot = position
	}

	int deathBoxEntIndex = -1
	if ( IsValid( file.currentGroundListData.deathBox ) && file.currentGroundListData.behavior == eGroundListBehavior.CONTENTS )
	{
		deathBoxEntIndex = file.currentGroundListData.deathBox.GetEncodedEHandle()
	}

	RunUIScript( "SurvivalQuickSwapMenu_DoQuickSwap", slot, deathBoxEntIndex )
}


void function UICallback_OnQuickSwapItemClickRight( var button, int position )
{
	if ( IsLobby() )
		return

	entity player                                  = GetLocalClientPlayer()
	array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )
	if ( playerInventory.len() <= position )
	{
		return
	}

	BackpackAction( eLootAction.DROP, string( position ) )
}


void function UICallback_UpdateQuickSwapItemButton( var button, int guid )
{
	if ( guid < 0 )
		return

	entity loot = GetEntityFromEncodedEHandle( guid )

	if ( !IsValid( loot ) )
		return

	if ( loot.GetNetworkedClassName() != "prop_survival" )
		return

	int lootIdx = loot.GetSurvivalInt()

	if ( !SURVIVAL_Loot_IsLootIndexValid( lootIdx ) )
		return

	LootData lootData = SURVIVAL_Loot_GetLootDataByIndex( lootIdx )

	entity player = GetLocalClientPlayer()
	var rui       = Hud_GetRui( button )
	Hud_ClearToolTipData( button )

	if ( IsLobby() )
		return

	string passiveName
	string passiveDesc

	int count = loot.GetClipCount()

	file.swapString = Localize( lootData.pickupString )

	bool isMainWeapon = (lootData.lootType == eLootType.MAINWEAPON)

	RuiSetString( rui, "buttonText", SURVIVAL_Loot_GetDesc( lootData, player ) )
	RuiSetImage( rui, "iconImage", lootData.hudIcon )
	RuiSetInt( rui, "lootTier", lootData.tier )
	RuiSetInt( rui, "count", count )
	RuiSetInt( rui, "lootType", lootData.lootType )

	RuiSetBool( rui, "isInfinite", false )
	if ( PlayerHasPassive( player, ePassives.PAS_INFINITE_HEAL ) && lootData.lootType == eLootType.HEALTH )
	{
		RuiSetBool( rui, "isInfinite", true )
	}

	LootRef lootRef = SURVIVAL_CreateLootRef( lootData, null )

	RuiSetImage( rui, "ammoTypeImage", $"" )

	if ( isMainWeapon )
	{
		string ammoType = lootData.ammoType
		asset icon      = lootData.fakeAmmoIcon
		if ( SURVIVAL_Loot_IsRefValid( ammoType ) && loot.GetWeaponSettingBool( eWeaponVar.uses_ammo_pool ) )
		{
			LootData ammoData = SURVIVAL_Loot_GetLootDataByRef( ammoType )
			icon = ammoData.hudIcon
		}
		RuiSetImage( rui, "ammoTypeImage", icon )
	}
}


void function OpenSwapForItem( string ref, string guid )
{
	Signal( clGlobal.levelEnt, "OpenSwapForItem" )
	EndSignal( clGlobal.levelEnt, "OpenSwapForItem" )

	if ( !CanOpenInventory( GetLocalClientPlayer() ) )
		return

	RunUIScript( "SurvivalQuickInventory_OpenSwapForItem", guid )
}


void function UICallback_AutoPickupFromDeathbox()
{
	if ( IsLobby() )
		return

	if ( IsValid( file.currentGroundListData.deathBox ) )
		Remote_ServerCallFunction( "ClientCallback_AutoPickupFromDeathbox", file.currentGroundListData.deathBox )
}


bool function FilteredGroundItemsContains( string ref )
{
	for ( int i = 0; i < file.filteredGroundItems.len(); i++ )
	{
		GroundLootData item = file.filteredGroundItems[i]
		if ( item.lootData.ref == ref )
			return true
	}

	return false
}


void function OnUpdateLootPrompt( int style, ToolTipData dt )
{
	UpdateLootTooltip( dt )
}


void function UpdateLootTooltip( ToolTipData dt )
{
	int index       = dt.lootPromptData.index
	int count       = dt.lootPromptData.count
	int entIndex    = dt.lootPromptData.guid
	int lootContext = dt.lootPromptData.lootContext
	int property    = dt.lootPromptData.property

	entity ent
	if ( entIndex != -1 )
		ent = GetEntityFromEncodedEHandle( entIndex )

	LootData data   = SURVIVAL_Loot_GetLootDataByIndex( index )
	LootRef lootRef = SURVIVAL_CreateLootRef( data, ent )
	lootRef.count = count
	lootRef.lootProperty = property

	entity player = GetLocalViewPlayer()

	var rui = GetTooltipRui()
	RuiSetBool( rui, "isInDeathBox", dt.lootPromptData.isInDeathBox )
	RuiSetBool( rui, "isTooltip", true )
	RuiSetBool( rui, "isPinged", dt.lootPromptData.isPinged )
	RuiSetBool( rui, "isPingedByUs", dt.lootPromptData.isPingedByUs )

	UpdateLootRuiWithData( player, rui, data, lootContext, lootRef, true )

	RuiSetBool( rui, "canPing", ( lootContext == eLootContext.GROUND ) || ( data.lootType == eLootType.AMMO ) && IsPingEnabledForPlayer( player ) )
	RuiSetBool( rui, "isVisible", (dt.tooltipFlags & eToolTipFlag.HIDDEN) == 0 )
}


void function UIToClient_UpdateInventoryDpadTooltipText( string ref, string emptySlotText, string equipmentSlot )
{
	entity player = GetLocalViewPlayer()

	if ( SURVIVAL_Loot_IsRefValid( ref ) )
	{
		LootActionStruct asMain
		LootActionStruct asAlt
		LootData lootData = SURVIVAL_Loot_GetLootDataByRef( ref )
		LootRef lootRef   = SURVIVAL_CreateLootRef( lootData, null )
		LootTypeData lt   = GetLootTypeData( lootData.lootType )

		string itemTitle         = ""
		string backpackAction    = ""
		string backpackAltAction = ""
		string specialPrompt     = ""
		string commsPrompt       = ""

		if ( EquipmentSlot_IsValidEquipmentSlot( equipmentSlot ) )
		{
			asMain = SURVIVAL_BuildStringForAction( player, eLootContext.EQUIPMENT, lootRef, false, true )
			SURVIVAL_UpdateStringForEquipmentAction( player, equipmentSlot, asMain, lootRef )
			asAlt = SURVIVAL_BuildStringForAction( player, eLootContext.EQUIPMENT, lootRef, true, true )
			SURVIVAL_UpdateStringForEquipmentAction( player, equipmentSlot, asAlt, lootRef )

			EquipmentSlot es = Survival_GetEquipmentSlotDataByRef( equipmentSlot )

			if ( es.weaponSlot == 0 )
				itemTitle = Localize( "#MENU_WEAPON_SLOT_CONSOLE0" ) + " - "
			else if ( es.weaponSlot == 1 )
				itemTitle = Localize( "#MENU_WEAPON_SLOT_CONSOLE1" ) + " - "

			if ( EquipmentSlot_IsAttachmentSlot( equipmentSlot ) )
				specialPrompt = Localize( "#INVENTORY_SELECT_WEAPON" )
		}
		else
		{
			asMain = SURVIVAL_BuildStringForAction( player, eLootContext.BACKPACK, lootRef, false, true )
			asAlt = SURVIVAL_BuildStringForAction( player, eLootContext.BACKPACK, lootRef, true, true )
		}

		backpackAction = asMain.displayString
		backpackAltAction = asAlt.displayString
		itemTitle += lootData.pickupString

		if ( lootData.lootType == eLootType.MAINWEAPON )
		{
			specialPrompt = Localize( "#INVENTORY_MANAGE_ATTACHMENTS" )
			commsPrompt = IsControllerModeActive() ? "#PING_PROMPT_REQUEST_AMMO_GAMEPAD" : "#PING_PROMPT_REQUEST_AMMO"
			commsPrompt = Localize( commsPrompt )
		}

		RunUIScript( "ClientToUI_UpdateInventoryDpadTooltip", itemTitle, backpackAction, backpackAltAction, commsPrompt, specialPrompt )
	}
	else              
	{
		string specialPrompt = ""
		if ( EquipmentSlot_IsValidEquipmentSlot( equipmentSlot ) && EquipmentSlot_IsAttachmentSlot( equipmentSlot ) )
			specialPrompt = Localize( "#INVENTORY_SELECT_WEAPON" )

		string commsPrompt = IsControllerModeActive() ? "#PING_PROMPT_REQUEST_GAMEPAD" : "#PING_PROMPT_REQUEST"
		commsPrompt = Localize( commsPrompt )
		RunUIScript( "ClientToUI_UpdateInventoryDpadTooltip", emptySlotText, "", "", commsPrompt, specialPrompt )
	}
}


void function GroundItemUpdate( entity player, array<entity> loot )
{
	loot.sort()
	if ( file.shouldResetGroundItems )
	{
		GroundItemsInit( player, loot )

		if ( GetCurrentPlaylistVarBool( "deathbox_diff_enabled", true ) )
		{
			file.shouldResetGroundItems = false
		}

		file.shouldUpdateGroundItems = true
	}
	else
	{
		                                    
		if ( file.lastLoot.len() == loot.len() )
		{
			int length = loot.len()
			for ( int i = 0; i < length; i++ )
			{
				if ( file.lastLoot[i] != loot[i] )
				{
					file.shouldUpdateGroundItems = true
					break
				}
			}
		}
		else
		{
			file.shouldUpdateGroundItems = true
		}

		if ( file.shouldUpdateGroundItems )
		{
			GroundItemsDiff( player, loot )
		}
	}

	file.lastLoot = loot

	if ( file.shouldUpdateGroundItems )
	{
		RunUIScript( "SurvivalGroundItem_SetGroundItemCount", file.filteredGroundItems.len() )
		foreach ( index, item in file.filteredGroundItems )
		{
			RunUIScript( "SurvivalGroundItem_SetGroundItemHeader", index, item.isHeader )
		}
	}

	file.visibleItemIndices.clear()
	file.shouldUpdateGroundItems = false
}


void function GroundItemsDiff( entity player, array<entity> loot )
{
	IntSet indicesInList

	foreach ( index, gd in file.filteredGroundItems )
	{
		gd.guids.clear()

		bool found       = false
		int currentCount = 0
		foreach ( item in loot )
		{
			if ( item.GetNetworkedClassName() != "prop_survival" )
				continue

			if ( gd.lootData.index == item.GetSurvivalInt() )
			{
				currentCount += item.GetClipCount()
				found = true
				gd.guids.append( item.GetEncodedEHandle() )
			}
		}

		gd.count = currentCount
		indicesInList[gd.lootData.index] <- IN_SET
	}

	table<string, GroundLootData> extras
	bool showUpgrades = GetCurrentPlaylistVarBool( "deathbox_show_upgrades", false )

	foreach ( item in loot )
	{
		if ( item.GetNetworkedClassName() != "prop_survival" )
			continue

		if ( !(item.GetSurvivalInt() in indicesInList) )
		{
			LootData data = SURVIVAL_Loot_GetLootDataByIndex( item.GetSurvivalInt() )
			GroundLootData gd
			gd.lootData = data

			if ( data.ref in extras )
				gd = extras[ data.ref ]
			else
			{
				extras[ data.ref ] <- gd

				if ( showUpgrades && SURVIVAL_IsLootAnUpgrade( player, item, gd.lootData, eLootContext.GROUND ) )
				{
					gd.isRelevant = true
					gd.isUpgrade = true
				}
				else if ( SURVIVAL_IsLootIrrelevant( player, item, gd.lootData, eLootContext.GROUND ) )
				{
					gd.isRelevant = false
					gd.isUpgrade = false
				}
				else
				{
					gd.isRelevant = true
					gd.isUpgrade = false
				}
			}


			gd.count += item.GetClipCount()
			gd.guids.append( item.GetEncodedEHandle() )
		}
	}

	foreach ( gd in extras )
		file.filteredGroundItems.append( gd )
}


void function GroundItemsInit( entity player, array<entity> loot )
{
	file.filteredGroundItems.clear()

	array<GroundLootData> upgradeItems
	array<GroundLootData> unusableItems
	array<GroundLootData> relevantItems
	table<string, GroundLootData> allItems

	for ( int groundIndex = 0; groundIndex < loot.len(); groundIndex++ )
	{
		entity item = loot[groundIndex]

		if ( item.GetNetworkedClassName() != "prop_survival" )
			continue

		LootData data = SURVIVAL_Loot_GetLootDataByIndex( item.GetSurvivalInt() )

		GroundLootData gd

		if ( data.ref in allItems )
			gd = allItems[ data.ref ]
		else
			allItems[ data.ref ] <- gd

		gd.lootData = data
		gd.count += item.GetClipCount()
		gd.guids.append( item.GetEncodedEHandle() )
	}

	bool sortByType    = GetCurrentPlaylistVarBool( "deathbox_sort_by_type", true )
	bool showUpgrades  = !sortByType && GetCurrentPlaylistVarBool( "deathbox_show_upgrades", true )
	bool splitUnusable = !sortByType && GetCurrentPlaylistVarBool( "deathbox_split_unusable", true )

	foreach ( gd in allItems )
	{
		entity ent = GetEntFromGroundLootData( gd )

		if ( showUpgrades && SURVIVAL_IsLootAnUpgrade( player, ent, gd.lootData, eLootContext.GROUND ) )
		{
			gd.isRelevant = true
			gd.isUpgrade = true
			upgradeItems.append( gd )
		}
		else if ( SURVIVAL_IsLootIrrelevant( player, ent, gd.lootData, eLootContext.GROUND ) )
		{
			gd.isRelevant = false
			gd.isUpgrade = false
			if ( splitUnusable )
				unusableItems.append( gd )
			else
				relevantItems.append( gd )
		}
		else
		{
			gd.isRelevant = true
			gd.isUpgrade = false
			relevantItems.append( gd )
		}
	}

	if ( sortByType )
	{
		upgradeItems.sort( SortByPriorityThenTierForGroundLoot )
		relevantItems.sort( SortByPriorityThenTierForGroundLoot )
		unusableItems.sort( SortByPriorityThenTierForGroundLoot )
	}
	else
	{
		upgradeItems.sort( SortByAmmoThenTierThenPriority )
		relevantItems.sort( SortByAmmoThenTierThenPriority )
		unusableItems.sort( SortByAmmoThenTierThenPriority )
	}

	if ( upgradeItems.len() > 0 )
	{
		file.filteredGroundItems.append( CreateHeaderData( "#HEADER_UPGRADES", $"rui/pilot_loadout/kit/titan_cowboy_filled" ) )
	}
	file.filteredGroundItems.extend( upgradeItems )

	if ( splitUnusable && relevantItems.len() > 0 )
	{
		file.filteredGroundItems.append( CreateHeaderData( "#HEADER_USEABLE", $"" ) )
	}
	file.filteredGroundItems.extend( relevantItems )

	if ( splitUnusable && unusableItems.len() > 0 )
	{
		file.filteredGroundItems.append( CreateHeaderData( "#HEADER_UNUSEABLE", $"rui/menu/common/button_unbuyable" ) )
	}
	file.filteredGroundItems.extend( unusableItems )

	if ( !splitUnusable && sortByType && file.filteredGroundItems.len() > 1 )
	{
		int lastLootCat = -1
		for ( int i = file.filteredGroundItems.len() - 1; i >= -1; i-- )
		{
			GroundLootData gd
			int cat = -1

			if ( i >= 0 )
			{
				gd = file.filteredGroundItems[i]
				cat = GetPriorityForLootType( gd.lootData )
			}

			if ( lastLootCat != cat )
			{
				if ( lastLootCat != -1 )
				{
					file.filteredGroundItems.insert( i + 1, CreateHeaderData( GetCategoryTitleFromPriority( lastLootCat ), $"" ) )
				}

				lastLootCat = cat
			}
		}
	}
}


GroundLootData function CreateHeaderData( string title, asset icon )
{
	GroundLootData gd
	gd.isHeader = true
	LootData data
	data.pickupString = title
	data.hudIcon = icon
	gd.lootData = data
	return gd
}


bool function Survival_IsInventoryOpen()
{
	return file.backpackOpened
}


bool function Survival_IsGroundlistOpen()
{
	return file.groundlistOpened
}


void function ShowHealHint( float damage, vector damageOrigin, int damageType, int damageSourceId, entity attacker )
{
	if ( GetLocalClientPlayer() != GetLocalViewPlayer() )
		return

	UpdateHealHint( GetLocalClientPlayer() )
}


void function UpdateHealHint( entity player )
{
	const float HINT_DURATION = 5.0
	if ( ShouldShowHealHint( player ) )
	{
		if ( Time() - file.lastHealHintDisplayTime < 10.0 )
			return

		if ( CanDeployHealDrone( player ) && player.GetHealth() < player.GetMaxHealth() && StatusEffect_GetSeverity( player, eStatusEffect.silenced ) == 0.0 )
		{
			AddPlayerHint( HINT_DURATION, 0.25, $"", "#SURVIVAL_MEDIC_HEAL_HINT" )
			file.lastHealHintDisplayTime = Time()
			return
		}

		int kitType

		kitType = Consumable_GetLocalViewPlayerSelectedConsumableType()
		ConsumableInfo kitInfo = Consumable_GetConsumableInfo( kitType )

		if ( Consumable_IsCurrentSelectedConsumableTypeUseful() && SURVIVAL_CountItemsInInventory( player, kitInfo.lootData.ref ) > 0 )
		{
			AddPlayerHint( HINT_DURATION, 0.25, $"", "#SURVIVAL_HEAL_HINT_CROSSHAIR", Localize( kitInfo.lootData.pickupString ) )
			file.lastHealHintDisplayTime = Time()
		}
	}
	else if ( ShouldShowUltHint( player ) )
	{
		float timeSinceUltHint = Time() - file.lastUltHintDisplayTime
		if ( timeSinceUltHint < ULT_HINT_COOLDOWN )
			return

		entity ultWeapon = GetLocalClientPlayer().GetOffhandWeapon( OFFHAND_ULTIMATE )

		ConsumableInfo kitInfo = Consumable_GetConsumableInfo( eConsumableType.ULTIMATE )

		float maxUltChargeFracForHint = 1.0 - ( kitInfo.ultimateAmount / 100.0 )


		if ( Consumable_CanUseUltAccel( GetLocalClientPlayer() ) )
		{
			float ultChargeFrac = ultWeapon.GetWeaponPrimaryClipCount() / float( ultWeapon.GetWeaponPrimaryClipCountMax() )

			if ( ultChargeFrac < maxUltChargeFracForHint && !GetLocalClientPlayer().Player_IsSkywardLaunching() && ( GetUltimateWeaponState() != eUltimateState.ACTIVE ) && SURVIVAL_CountItemsInInventory( GetLocalClientPlayer(), kitInfo.lootData.ref ) > 0 )
			{
				if ( IsControllerModeActive() )
					AddPlayerHint( HINT_DURATION, 0.25, $"", "#SURVIVAL_ULT_ACCEL_HINT_CONTROLLER", Localize( kitInfo.lootData.pickupString ) )
				else
					AddPlayerHint( HINT_DURATION, 0.25, $"", "#SURVIVAL_ULT_ACCEL_HINT_PC", Localize( kitInfo.lootData.pickupString ) )

				file.lastUltHintDisplayTime = Time()
			}
		}

	}
	else
	{
		HidePlayerHint( "#SURVIVAL_HEAL_HINT_CROSSHAIR" )
		HidePlayerHint( "#SURVIVAL_MEDIC_HEAL_HINT" )
		HidePlayerHint( "#SURVIVAL_ULT_ACCEL_HINT_CONTROLLER" )
		HidePlayerHint( "#SURVIVAL_ULT_ACCEL_HINT_PC" )
	}
}


bool function ShouldShowHealHint( entity player )
{
	if ( !IsAlive( player ) )
		return false

	if ( Bleedout_IsBleedingOut( player ) )
		return false

	if ( GetGameState() == eGameState.WinnerDetermined || GetGameState() > eGameState.Epilogue )
		return false

	float shieldHealthFrac = GetShieldHealthFrac( player )
	float healthFrac       = GetHealthFrac( player )
	if ( (!player.GetShieldHealthMax() || shieldHealthFrac > 0.25) && healthFrac > 0.5 )
		return false


	int kitType = Consumable_GetLocalViewPlayerSelectedConsumableType()
	if ( kitType == -1 )
		kitType = Consumable_GetBestConsumableTypeForPlayer( player, 0, 0 )

	if ( !Consumable_CanUseConsumable( player, kitType, false ) && !CanDeployHealDrone( player ) )
		return false

	PotentialHealData healData = Consumable_CreatePotentialHealData( player, kitType )
	if ( healData.totalAppliedHeal < 75 && (healData.totalAppliedHeal > 25 && healData.overHeal >= 100) )
		return false

	if ( player.GetPlayerNetBool( "isHealing" ) )
		return false

	return true


	unreachable
}

bool function ShouldShowUltHint( entity player )
{
	if ( !IsAlive( player ) )
		return false

	if ( Bleedout_IsBleedingOut( player ) )
		return false

	if ( GetGameState() == eGameState.WinnerDetermined || GetGameState() > eGameState.Epilogue )
		return false

	int kitType = eConsumableType.ULTIMATE

	if ( !Consumable_CanUseConsumable( player, kitType, false ) )
		return false

	if ( player.GetPlayerNetBool( "isHealing" ) )
		return false

	return true


	unreachable
}


void function UseHealthPickupRefFromInventory( entity player, string ref )
{
	if ( WeaponDrivenConsumablesEnabled() )
	{
		Consumable_UseItemByRef( player, ref )
	}
	else
	{
		int itemType = SURVIVAL_Loot_GetHealthPickupTypeFromRef( ref )

		if ( !Survival_CanUseHealthPack( player, itemType ) )
			return

		Survival_UseHealthPack( player, ref )
	}
}


                       
                                                          
 
                        
        

                          
        

                                             
        

                                        
        

                                                                                                                                                            
                                                                           

                                                 
        

                                                      
        

                                   
                                                                                                                             
                                                                       
 
      


void function EquipOrdnance( entity player, string ref )
{
	if ( player.IsTitan() )
		return

	if ( !IsAlive( player ) )
		return

	if ( !CanOpenInventoryInCurrentGameState() )
		return

	if ( Bleedout_IsBleedingOut( player ) )
		return

	Remote_ServerCallFunction( "ClientCallback_Sur_EquipOrdnance", ref )

	ServerCallback_ClearHints()
}

void function EquipGadget( entity player, string ref )
{
	if ( player.IsTitan() )
		return

	if ( !IsAlive( player ) )
		return

	if ( !CanOpenInventoryInCurrentGameState() )
		return

	if ( Bleedout_IsBleedingOut( player ) )
		return

	Remote_ServerCallFunction( "ClientCallback_Sur_EquipGadget", ref )

	ServerCallback_ClearHints()
}

void function EquipAttachment( entity player, string item, string weaponName )
{
	if ( player.IsTitan() )
		return

	if ( !IsAlive( player ) )
		return

	if ( !CanOpenInventoryInCurrentGameState() )
		return

	if ( player.ContextAction_IsActive() && !player.ContextAction_IsRodeo() )
		return

	if ( Bleedout_IsBleedingOut( player ) )
		return

	                             
	  	                                            
	       
	Remote_ServerCallFunction( "ClientCallback_Sur_EquipAttachment", item, -1)
	        

	ServerCallback_ClearHints()
}


entity function GetBaseWeaponEntForEquipmentSlot( string equipmentSlot )
{
	int slot = EquipmentSlot_GetWeaponSlotForEquipmentSlot( equipmentSlot )

	if ( slot >= 0 )
		return GetLocalClientPlayer().GetNormalWeapon( slot )

	return null
}


entity function Survival_GetDeathBox()
{
	return file.currentGroundListData.deathBox
}


int function Survival_GetGroundListBehavior()
{
	return file.currentGroundListData.behavior
}


array<entity> function Survival_GetDeathBoxItems()
{
	if ( !IsValid( file.currentGroundListData.deathBox ) || file.currentGroundListData.behavior == eGroundListBehavior.NEARBY )
		return []

	return file.currentGroundListData.deathBox.GetLinkEntArray()
}


void function TryCloseSurvivalInventoryFromDamage( float damage, vector damageOrigin, int damageType, int damageSourceId, entity attacker )
{
	if ( GetLocalClientPlayer() == GetLocalViewPlayer() )
	{
		if ( GetConVarBool( "player_setting_damage_closes_deathbox_menu" ) )
		{
			if ( IsValid( attacker ) && (attacker.IsNPC() || attacker.IsPlayer()) )
				RunUIScript( "TryCloseSurvivalInventoryFromDamage", null )
		}
	}
}


entity function GetEntFromGroundLootData( GroundLootData groundLootData )
{
	entity ent
	for ( int i = 0; i < groundLootData.guids.len() && !IsValid( ent ); i++ )
	{
		ent = GetEntityFromEncodedEHandle( groundLootData.guids[i] )
	}
	return ent
}


void function UICallback_GetLootDataFromButton( var button, int position )
{
	RunUIScript( "ClientCallback_SetTempButtonRef", "" )

	entity player = GetLocalClientPlayer()
	string ref

	if ( position > -1 )
	{
		if ( position >= SURVIVAL_GetInventoryLimit( player ) )
			return

		array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )
		if ( playerInventory.len() <= position )
			return

		ConsumableInventoryItem item = playerInventory[ position ]
		LootData lootData            = SURVIVAL_Loot_GetLootDataByIndex( item.type )

		ref = lootData.ref
	}
	else
	{
		string equipmentSlot = Hud_GetScriptID( button )

		LootData data = EquipmentSlot_GetEquippedLootDataForSlot( player, equipmentSlot )

		ref = data.ref
	}

	RunUIScript( "ClientCallback_SetTempButtonRef", ref )
}


void function UICallback_GetMouseDragAllowedFromButton( var button, int position )
{
	entity player = GetLocalClientPlayer()
	bool allowed  = true

	if ( position > -1 )
	{
		if ( position >= SURVIVAL_GetInventoryLimit( player ) )
		{
			allowed = false
		}
		else
		{
			array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )
			if ( playerInventory.len() <= position )
				allowed = false
		}
	}
	else
	{
		string equipmentSlot = Hud_GetScriptID( button )
		if ( EquipmentSlot_IsValidEquipmentSlot( equipmentSlot ) && EquipmentSlot_IsAttachmentSlot( equipmentSlot ) )
		{
			EquipmentSlot es = Survival_GetEquipmentSlotDataByRef( equipmentSlot )
			EquipmentSlot ws = Survival_GetEquipmentSlotDataByRef( es.attachmentWeaponSlot )

			LootData wData = EquipmentSlot_GetEquippedLootDataForSlot( player, ws.ref )
			if ( !SURVIVAL_Loot_IsRefValid( wData.ref ) || SURVIVAL_IsAttachmentPointLocked( wData.ref, es.attachmentPoint ) )
			{
				allowed = false
			}
		}
	}

	RunUIScript( "ClientCallback_SetTempBoolMouseDragAllowed", allowed )
}

                                                                            
void function UICallback_OnInventoryMouseDrop( var dropButton, var sourcePanel, var sourceButton, int sourceIndex, bool initOnly )
{
	if ( initOnly )
		Hud_SetLocked( dropButton, false )

	string sourceEquipmentSlot
	if ( sourceIndex > -1 )
		sourceEquipmentSlot = "inventory"
	else
		sourceEquipmentSlot = Hud_GetScriptID( sourceButton )

	string dropEquipmentSlot = Hud_GetScriptID( dropButton )

	string sourceEquipmentWeaponSlot

	if ( EquipmentSlot_IsValidEquipmentSlot( sourceEquipmentSlot ) )
	{
		if ( EquipmentSlot_IsAttachmentSlot( sourceEquipmentSlot ) )
		{
			EquipmentSlot es = Survival_GetEquipmentSlotDataByRef( sourceEquipmentSlot )
			sourceEquipmentWeaponSlot = es.attachmentWeaponSlot
		}
	}
	entity player = GetLocalClientPlayer()

	if ( EquipmentSlot_IsValidEquipmentSlot( dropEquipmentSlot ) )
	{
		EquipmentSlot des = Survival_GetEquipmentSlotDataByRef( dropEquipmentSlot )

		if ( des.passiveRequired != -1 )
			Hud_SetVisible( dropButton, PlayerHasPassive( player, des.passiveRequired ) )
	}

	                                   
	if ( dropEquipmentSlot == sourceEquipmentSlot || dropEquipmentSlot == sourceEquipmentWeaponSlot )
		return

	if ( initOnly )
		Hud_SetLocked( dropButton, true )


	LootData data

	if ( sourceIndex > -1 )
	{
		if ( sourceIndex >= SURVIVAL_GetInventoryLimit( player ) )
			return

		array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )
		if ( playerInventory.len() <= sourceIndex )
			return

		ConsumableInventoryItem item = playerInventory[ sourceIndex ]
		data = SURVIVAL_Loot_GetLootDataByIndex( item.type )
	}
	else
	{
		string equipmentSlot = Hud_GetScriptID( sourceButton )

		data = EquipmentSlot_GetEquippedLootDataForSlot( player, equipmentSlot )
	}

	              
	if ( EquipmentSlot_IsValidEquipmentSlot( dropEquipmentSlot ) )
	{
		if ( EquipmentSlot_IsMainWeaponSlot( dropEquipmentSlot ) )
		{
			LootData dropSlotData = EquipmentSlot_GetEquippedLootDataForSlot( player, dropEquipmentSlot )
			EquipmentSlot es      = Survival_GetEquipmentSlotDataByRef( dropEquipmentSlot )

			if ( data.lootType == eLootType.ATTACHMENT )
			{
				if ( EquipmentSlot_IsValidEquipmentSlot( sourceEquipmentSlot ) )
				{
					if ( EquipmentSlot_IsAttachmentSlot( sourceEquipmentSlot ) )
					{
						if ( CanAttachToWeapon( data.ref, dropSlotData.ref ) )
						{
							if ( initOnly )
								Hud_SetLocked( dropButton, false )
							else
								EquipmentAction( eLootAction.WEAPON_TRANSFER, sourceEquipmentSlot )
						}
					}
				}
				else if ( sourceEquipmentSlot == "inventory" )
				{
					if ( CanAttachToWeapon( data.ref, dropSlotData.ref ) )
					{
						if ( initOnly )
							Hud_SetLocked( dropButton, false )
						else
							Remote_ServerCallFunction( "ClientCallback_Sur_EquipAttachment", data.ref, es.weaponSlot )
					}
				}
			}
			else if ( EquipmentSlot_IsValidEquipmentSlot( sourceEquipmentSlot ) )
			{
				if ( EquipmentSlot_IsMainWeaponSlot( sourceEquipmentSlot ) )
				{
					if ( initOnly )
						Hud_SetLocked( dropButton, false )
					else
						Remote_ServerCallFunction( "ClientCallback_Sur_SwapPrimaryPositions" )
				}
                     
                                                     
     
                    
                                        
         
                                                                                            
     
          
			}
		}
                 
                                                 
   
                                                                               

                                                                   
    
                                                                                 
                                                                
     
                    
                                        
         
                                                                                            
     
    
   
      
	}
	else if ( dropEquipmentSlot == "inventory" )
	{
		if ( EquipmentSlot_IsAttachmentSlot( sourceEquipmentSlot ) )
		{
			if ( SURVIVAL_AddToPlayerInventory( player, data.ref ) > 0 )
			{
				if ( initOnly )
					Hud_SetLocked( dropButton, false )
				else
					EquipmentAction( eLootAction.REMOVE, sourceEquipmentSlot )
			}
		}
	}
	else if ( dropEquipmentSlot == "ground" )
	{
		if ( EquipmentSlot_IsValidEquipmentSlot( sourceEquipmentSlot ) )
		{
			if ( initOnly )
				Hud_SetLocked( dropButton, false )
			else if ( !EquipmentSlot_IsAttachmentSlot( sourceEquipmentSlot ) )
				EquipmentAction( eLootAction.DROP, sourceEquipmentSlot )
			else
				EquipmentAction( eLootAction.REMOVE_TO_GROUND, sourceEquipmentSlot )
		}
		else if ( sourceEquipmentSlot == "inventory" )
		{
			if ( initOnly )
				Hud_SetLocked( dropButton, false )
			else
				BackpackAction( eLootAction.DROP_ALL, string( sourceIndex ) )
		}
	}
}


void function UIToClient_WeaponSwap()
{
	entity player = GetLocalViewPlayer()

	if ( player != GetLocalClientPlayer() )
		return

	thread WeaponSwap( player )
}


void function WeaponSwap( entity player )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )

	player.ClientCommand( "invnext" )
}

void function OnLocalPlayerPickedUpItem( entity player, LootData data, int lootAction )
{
	TryResetGroundList( player, data, lootAction )

	if ( IsValid( player ) )
		EmitSoundOnEntity( player, data.pickupSound_1p )
}

void function TryResetGroundList( entity player, LootData data, int lootAction )
{
	if ( file.groundlistOpened )
		GroundListResetNextFrame()
}


void function TryUpdateGroundList()
{
	if ( file.groundlistOpened )
		file.shouldUpdateGroundItems = true
}


void function GroundListResetNextFrame()
{
	file.shouldResetGroundItems = true
}


void function UICallback_UpdatePlayerInfo( var elem )
{
	var rui = Hud_GetRui( elem )

	entity player = GetLocalClientPlayer()

	if ( GetBugReproNum() == 54268 )
		SURVIVAL_PopulatePlayerInfoRui( player, rui )
	else
		thread TEMP_UpdatePlayerRui( rui, player )
}


void function UICallback_UpdateTeammateInfo( var elem )
{
	var rui           = Hud_GetRui( elem )
	int teammateIndex = int( Hud_GetScriptID( elem ) )

	entity player = GetLocalClientPlayer()

	array<entity> team = GetPlayerArrayOfTeam( player.GetTeam() )
	team.fastremovebyvalue( player )

                  
		                                             
		if ( IsFallLTM() )
			team.clear()
       

	if ( teammateIndex < team.len() )
	{
		Hud_SetHeight( elem, Hud_GetBaseHeight( elem ) )
		Hud_Show( elem )
	}
	else
	{
		Hud_SetHeight( elem, 0 )
		Hud_Hide( elem )
		return
	}

	entity ent = team[teammateIndex]

	if ( GetBugReproNum() == 54268 )
		thread SetUnitFrameDataFromOwner( rui, ent, player )
	else
		thread TEMP_UpdateTeammateRui( rui, ent, player )
}


void function UICallback_UpdateUltimateInfo( var elem )
{
	var rui = Hud_GetRui( elem )

	entity player = GetLocalClientPlayer()

	thread TEMP_UpdateUltimateInfo( rui, player )

                             
	{
		entity ultWeapon = player.GetOffhandWeapon( OFFHAND_ULTIMATE )
		string ultName = (IsValid( ultWeapon ) ? string( ultWeapon.GetWeaponPrintName() ) : "")
		RunUIScript( "ClientToUI_UpdateInventoryUltimateTooltip", elem, ultName )
	}
                                   
}


void function TEMP_UpdateUltimateInfo( var rui, entity player )
{
	player.EndSignal( "OnDestroy" )
	clGlobal.levelEnt.EndSignal( "BackpackClosed" )

	int slot = OFFHAND_INVENTORY

	float PROTO_storedAmmoRegenRate = -1.0

	while ( 1 )
	{
		if ( IsAlive( player ) )
		{
			entity weapon = player.GetOffhandWeapon( slot )
			if ( IsValid( weapon ) )
			{
				thread UpdateInventoryUltimateRui( rui, player, weapon )

				float currentAmmoRegenRate = weapon.GetWeaponSettingFloat( eWeaponVar.regen_ammo_refill_rate )
				if ( currentAmmoRegenRate != PROTO_storedAmmoRegenRate )
				{
					RuiSetFloat( rui, "refillRate", currentAmmoRegenRate )
					PROTO_storedAmmoRegenRate = currentAmmoRegenRate
				}
			}
			else
			{
				RuiSetBool( rui, "isVisible", false )
			}
		}
		WaitFrame()
	}
}


void function UpdateInventoryUltimateRui( var rui, entity player, entity weapon )
{
	                                                                                                  
	Assert ( IsNewThread(), "Must be threaded off." )

	RuiSetGameTime( rui, "hintTime", Time() )

	RuiSetBool( rui, "isTitan", player.IsTitan() )
	RuiSetBool( rui, "isReverseCharge", false )
	bool isPaused = weapon.HasMod( "survival_ammo_regen_paused" )
	RuiSetBool( rui, "isPaused", isPaused )
	RuiSetBool( rui, "isVisible", true )

	RuiSetFloat( rui, "chargeFrac", 0.0 )
	RuiSetFloat( rui, "useFrac", 0.0 )
	RuiSetFloat( rui, "chargeMaxFrac", 1.0 )
	RuiSetFloat( rui, "minFireFrac", 1.0 )
	RuiSetInt( rui, "segments", 1 )
	RuiSetFloat( rui, "refillRate", 1 )                                                                                                                  

	RuiSetImage( rui, "hudIcon", weapon.GetWeaponSettingAsset( eWeaponVar.hud_icon ) )

	RuiSetFloat( rui, "readyFrac", weapon.GetWeaponReadyToFireProgress() )
	                                                                              

	RuiSetFloat( rui, "chargeFracCaution", 0.0 )
	RuiSetFloat( rui, "chargeFracAlert", 0.0 )
	RuiSetFloat( rui, "chargeFracAlertSpeed", 16.0 )
	RuiSetFloat( rui, "chargeFracAlertScale", 1.0 )

	RuiSetInt( rui, "ammoMinToFire", weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire ) )

	ItemFlavor character                    = LoadoutSlot_WaitForItemFlavor( ToEHI( player ), Loadout_Character() )
	CharacterHudUltimateColorData colorData = CharacterClass_GetHudUltimateColorData( character )

	RuiSetColorAlpha( rui, "ultimateColor", SrgbToLinear( colorData.ultimateColor ), 1 )
	RuiSetColorAlpha( rui, "ultimateColorHighlight", SrgbToLinear( colorData.ultimateColorHighlight ), 1 )

	switch ( weapon.GetWeaponSettingEnum( eWeaponVar.cooldown_type, eWeaponCooldownType ) )
	{
		case eWeaponCooldownType.ammo_timed:
		case eWeaponCooldownType.ammo_instant:
		case eWeaponCooldownType.ammo_deployed:
			RuiSetFloat( rui, "readyFrac", 0.0 )

		case eWeaponCooldownType.ammo:
			int maxAmmoReady = weapon.UsesClipsForAmmo() ? weapon.GetWeaponSettingInt( eWeaponVar.ammo_clip_size ) : weapon.GetWeaponPrimaryAmmoCountMax( weapon.GetActiveAmmoSource() )
			int ammoPerShot = weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
			int ammoMinToFire = weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )

			if ( maxAmmoReady == 0 )
				maxAmmoReady = 1
			RuiSetFloat( rui, "minFireFrac", float( ammoMinToFire ) / float( maxAmmoReady ) )
			if ( ammoPerShot == 0 )
				ammoPerShot = 1
			RuiSetInt( rui, "segments", maxAmmoReady / ammoPerShot )

			RuiSetFloat( rui, "chargeFrac", float( weapon.GetWeaponPrimaryClipCount() ) / float( weapon.GetWeaponPrimaryClipCountMax() ) )

			RuiSetFloat( rui, "useFrac", StatusEffect_GetSeverity( weapon, eStatusEffect.simple_timer ) )
			break

		case eWeaponCooldownType.vortex_drain:
			RuiSetBool( rui, "isReverseCharge", true )
			RuiSetFloat( rui, "chargeFrac", 1.0 )
			RuiSetFloat( rui, "readyFrac", 0.0 )
			RuiSetFloat( rui, "minFireFrac", 0.0 )

			RuiSetFloat( rui, "chargeFrac", weapon.GetWeaponChargeFraction() )
			break

		default:
			Assert( false, "Unsupported cooldown_type: " + weapon.GetWeaponSettingEnum( eWeaponVar.cooldown_type, eWeaponCooldownType ) )
	}
}


void function TEMP_UpdatePlayerRui( var rui, entity player )
{
	printf( "EvoShieldDebug: Temp_UpdatePlayerRui called" )

	player.EndSignal( "OnDestroy" )
	clGlobal.levelEnt.EndSignal( "BackpackClosed" )

	ItemFlavor character = LoadoutSlot_WaitForItemFlavor( ToEHI( player ), Loadout_Character() )
	asset classIcon      = CharacterClass_GetGalleryPortrait( character )
	RuiSetImage( rui, "playerIcon", classIcon )

	RuiSetInt( rui, "micStatus", player.HasMic() ? 3 : -1 )                                

	while ( 1 )
	{
		foreach ( equipSlot, es in EquipmentSlot_GetAllEquipmentSlots() )
		{
			if ( es.trackingNetInt != "" )
			{
				LootData data = EquipmentSlot_GetEquippedLootDataForSlot( player, equipSlot )
				int tier      = data.tier
				asset hudIcon = data.hudIcon

				if ( data.lootType == eLootType.ARMOR )
				{
					bool isEvolving = EvolvingArmor_IsEquipmentEvolvingArmor( data.ref )
					RuiSetBool( rui, "isEvolvingShield", isEvolving )
					RuiSetInt( rui, "evolvingShieldKillCounter", EvolvingArmor_GetEvolutionProgress( player ) )
                                  
                                                       
          
						RuiSetBool( rui, "hasReducedShieldValues", false )
           
				}
				else if ( equipSlot == "armor" && data.ref == "" )
				{
					RuiSetBool( rui, "isEvolvingShield", false )
				}

				if ( es.unitFrameTierVar != "" )
				RuiSetInt( rui, es.unitFrameTierVar, tier )
				if ( es.unitFrameImageVar != "" )
				RuiSetImage( rui, es.unitFrameImageVar, hudIcon )
			}
		}

		RuiSetString( rui, "name", player.GetPlayerName() )
		RuiSetFloat( rui, "playerHealthFrac", GetHealthFrac( player ) )
		RuiSetFloat( rui, "playerShieldFrac", GetShieldHealthFrac( player ) )
		RuiSetInt( rui, "teamMemberIndex", player.GetTeamMemberIndex() )
		RuiSetInt( rui, "squadID", player.GetSquadID() )

		vector shieldFrac = < SURVIVAL_GetArmorShieldCapacity( 0 ) / 100.0,
		SURVIVAL_GetArmorShieldCapacity( 1 ) / 100.0,
		SURVIVAL_GetArmorShieldCapacity( 2 ) / 100.0 >

		RuiSetColorAlpha( rui, "shieldFrac", shieldFrac, float( SURVIVAL_GetArmorShieldCapacity( 3 ) ) )

		RuiSetFloat( rui, "playerTargetShieldFrac", StatusEffect_GetSeverity( player, eStatusEffect.target_shields ) )
		RuiSetFloat( rui, "playerTargetHealthFrac", StatusEffect_GetSeverity( player, eStatusEffect.target_health ) )
		RuiSetFloat( rui, "cameraViewFrac", StatusEffect_GetSeverity( player, eStatusEffect.camera_view ) )
		RuiSetBool( rui, "useShadowFormFrame", player.IsShadowForm() )

		RuiSetInt( rui, "micStatus", GetPlayerMicStatus( player ) )

		                                                            
		OverwriteWithCustomPlayerInfoTreatment( player, rui )

		WaitFrame()
	}
}


void function TEMP_UpdateTeammateRui( var rui, entity ent, entity localPlayer )
{
	ent.EndSignal( "OnDestroy" )
	clGlobal.levelEnt.EndSignal( "BackpackClosed" )
	clGlobal.levelEnt.EndSignal( "GroundListClosed" )
                         
		if ( Control_IsModeEnabled())
		{
			localPlayer.EndSignal( "Control_PlayerHasChosenRespawn" )
		}
       

	ItemFlavor character = LoadoutSlot_WaitForItemFlavor( ToEHI( ent ), Loadout_Character() )
	asset classIcon      = CharacterClass_GetGalleryPortrait( character )
	RuiSetImage( rui, "icon", classIcon )

	RuiSetInt( rui, "micStatus", ent.HasMic() ? 3 : -1 )                                

	bool weaponDrivenConsumables = WeaponDrivenConsumablesEnabled()

	while ( 1 )
	{
		foreach ( equipSlot, es in EquipmentSlot_GetAllEquipmentSlots() )
		{
			if ( es.trackingNetInt != "" )
			{
				LootData data = EquipmentSlot_GetEquippedLootDataForSlot( ent, equipSlot )
				int tier      = data.tier
				asset hudIcon = tier > 0 ? data.hudIcon : es.emptyImage

				if ( data.lootType == eLootType.ARMOR )
				{
					bool isEvolving = EvolvingArmor_IsEquipmentEvolvingArmor( data.ref )
					RuiSetBool( rui, "isEvolvingShield", isEvolving )
				}
                                 
                                                      
         
					RuiSetBool( rui, "hasReducedShieldValues", false )
          

				if ( es.unitFrameTierVar != "" )
				RuiSetInt( rui, es.unitFrameTierVar, tier )
				if ( es.unitFrameImageVar != "" )
				RuiSetImage( rui, es.unitFrameImageVar, hudIcon )
			}
		}

		RuiSetString( rui, "name", ent.GetPlayerName() )
		RuiSetFloat( rui, "healthFrac", GetHealthFrac( ent ) )
		RuiSetFloat( rui, "shieldFrac", GetShieldHealthFrac( ent ) )
		RuiSetFloat( rui, "targetHealthFrac", StatusEffect_GetSeverity( ent, eStatusEffect.target_health ) )
		RuiSetFloat( rui, "targetShieldFrac", StatusEffect_GetSeverity( ent, eStatusEffect.target_shields ) )
		RuiSetFloat( rui, "cameraViewFrac", StatusEffect_GetSeverity( ent, eStatusEffect.camera_view ) )
		RuiSetInt( rui, "teamMemberIndex", ent.GetTeamMemberIndex() )
		RuiSetInt( rui, "squadID", ent.GetSquadID() )
		RuiSetBool( rui, "disconnected", !ent.IsConnectionActive() )

                     
		RuiSetBool( rui, "isDriving", HoverVehicle_PlayerIsDriving( ent ) )
                           

		asset hudIcon = $""
		int kitType   = ent.GetPlayerNetInt( "healingKitTypeCurrentlyBeingUsed" )
		if ( kitType != -1 )
		{
			if ( weaponDrivenConsumables )
			{
				ConsumableInfo info = Consumable_GetConsumableInfo( kitType )
				LootData lootData   = info.lootData
				hudIcon = lootData.hudIcon
			}
			else
			{
				HealthPickup kitData = SURVIVAL_Loot_GetHealthKitDataFromStruct( kitType )
				LootData lootData    = kitData.lootData
				hudIcon = lootData.hudIcon
			}
		}
		RuiSetImage( rui, "healTypeIcon", hudIcon )
		RuiSetBool( rui, "consumablePanelVisible", hudIcon != $"" )

		RuiSetFloat( rui, "reviveEndTime", ent.GetPlayerNetTime( "reviveEndTime" ) )
		RuiSetInt( rui, "reviveType", ent.GetPlayerNetInt( "reviveType" ) )
		RuiSetFloat( rui, "bleedoutEndTime", ent.GetPlayerNetTime( "bleedoutEndTime" ) )
		RuiSetInt( rui, "respawnStatus", ent.GetPlayerNetInt( "respawnStatus" ) )
		RuiSetFloat( rui, "respawnStatusEndTime", ent.GetPlayerNetTime( "respawnStatusEndTime" ) )
		RuiSetBool( rui, "useShadowFormFrame", ent.IsShadowForm() )

		RuiSetInt( rui, "micStatus", GetPlayerMicStatus( ent ) )

		                                                                          
		RuiSetGameTime( rui, "realGameTime", Time() )
		RuiSetFloat( rui, "hackStartTime", ent.GetPlayerNetTime( "hackStartTime" ) )

		SetUnitFrameAmmoTypeIcons( rui, ent )
		OverwriteWithCustomUnitFrameInfo( ent, rui )

		WaitFrame()
	}
}


void function SetUnitFrameAmmoTypeIcons( var rui, entity player )
{
	for ( int i = 0; i < 2; i++ )
	{
		string ammoTypeIconBool = "showAmmoIcon0" + string( i )
		string ammoTypeIcon     = "ammoTypeIcon0" + string( i )

		asset hudIcon = $"white"

		entity weapon = player.GetNormalWeapon( i )
		if ( !IsValid( weapon ) )
		{
			hudIcon = $"white"

			RuiSetBool( rui, ammoTypeIconBool, false )
			RuiSetImage( rui, ammoTypeIcon, hudIcon )
		}
		else
		{
			string weaponRef    = weapon.GetWeaponClassName()
			LootData weaponData = SURVIVAL_Loot_GetLootDataByRef( weaponRef )
			string ammoType     = weaponData.ammoType
			if ( weapon.GetWeaponSettingBool( eWeaponVar.uses_ammo_pool ) )
			{
				LootData ammoData = SURVIVAL_Loot_GetLootDataByRef( ammoType )
				hudIcon = ammoData.hudIcon
			}
			else
				hudIcon = weaponData.fakeAmmoIcon

			RuiSetImage( rui, ammoTypeIcon, hudIcon )
			RuiSetBool( rui, ammoTypeIconBool, true )
		}
	}
}


void function UICallback_BlockPingForDuration( float duration )
{
	AddOnscreenPromptFunction( "ping", OnscreenPrompt_DoNothing, 0.5, "" )
}


void function OnscreenPrompt_DoNothing( entity player )
{

}


int function GetCountForLootType( int lootType )
{
	entity player                       = GetLocalViewPlayer()
	table<string, LootData> allLootData = SURVIVAL_Loot_GetLootDataTable()

	int typeCount = 0

	foreach ( data in allLootData )
	{
		if ( !IsLootTypeValid( data.lootType ) )
			continue

		if ( data.lootType != lootType )
			continue

		if ( SURVIVAL_CountItemsInInventory( player, data.ref ) == 0 )
			continue

		typeCount++
	}

	return typeCount
}
                 
                                                                     
 
                          
                                                                         
 

                                                     
 
                                                
                                       
 

                                                           
 
                                                      
        

                                                     

                                                                
  
                                                                                         

                           
                                         
   
                                         
                                                            
    
                                                                                
                                                
     
                                                    
      
                                                                      
                         
      
         
      
                                                                              
                         
                                                                
      
     
    
   

                     
         

                                                 
   
                                                                   

                                      
    
                                                             
                                                              
    

   
      
   
                                                                            
                                             
                                  
    
                                            
                                           
                                                              
    
                                                                                

   
  
 
      