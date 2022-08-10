global function Sh_Loot_Vault_Panel_Init
global function GetVaultKeyPlayerNetBoolFromItemRef
global function SetVaultPanelMinimapObj
global function GetVaultPanelMinimapObj
global function SetVaultPanelOpenMinimapObj
global function VaultPanel_GetBestMinimapObjs
global function VaultPanel_GetAllMinimapObjs

global function IsVaultDoor
global function IsVaultPanel
global function GetVaultPanelFromDoor
global function GetVaultDoorForHitEnt
global function GetVaultPanelForLoot
global function IsVaultPanelLocked
global function GetUniqueVaultData
global function GetUniqueVaultDataByLootItem

global function VaultPanel_GetTeammateWithKey
global function GetNameOfTeammateWithVaultKey

global function ForceVaultOpen

#if SERVER
                                        
                                                
                                

                                    
                                      
                                      
                                        
                                          
                                            
                                               

                  
                                          
      
#endif

#if SERVER && DEV
                              
#endif

const string LOOT_VAULT_PANEL_SCRIPTNAME = "LootVaultPanel"
const string LOOT_VAULT_DOOR_SCRIPTNAME = "LootVaultDoor"
const string LOOT_VAULT_DOOR_SCRIPTNAME_RIGHT = "LootVaultDoorRight"

                  
const string SHIP_VAULT_PANEL_SCRIPTNAME = "ShipVaultPanel"
const string SHIP_VAULT_DOOR_SCRIPTNAME = "ShipVaultDoor"
const string SHIP_VAULT_BODY_SCRIPTNAME = "ship_vault_corpse"

const asset SHIP_VAULT_PANEL_OPEN_FX = $"P_door_lock_IMC_open"
const asset SHIP_VAULT_PANEL_LOCKED_FX = $"P_door_lock_IMC_locked"
                        

const string LOOT_VAULT_AUDIO_OPEN = "LootVault_Open"
const string LOOT_VAULT_AUDIO_ACCESS = "LootVault_Access"
const string LOOT_VAULT_AUDIO_STATUSBAR = "LootVault_StatusBar"
const string VAULT_ALARM_SOUND = "Loba_Ultimate_Staff_VaultAlarm"

const float PANEL_TO_DOOR_RADIUS_SQR = 15000.0
const float VAULT_PANEL_USE_TIME = 3.0

const float DATAVAULT_WAYPOINT_DURATION = 10.0
const float DATAVAULT_WAYPOINT_REVEAL_DELAY = 3.0

enum ePanelState
{
	LOCKED,
	UNLOCKING,
	UNLOCKED
}

struct VaultData
{
	entity panel
	int    panelState = ePanelState.LOCKED

	array<entity> vaultDoors

	#if SERVER
                    
			                    
			                  
                          
		                                                   
		                   
	#endif         

	entity minimapObj
	entity openMinimapObj
}

global struct UniqueVaultData
{
	string 	panelScriptName
	string	vaultKeylootType
	string	hasVaultKeyString

	string 	hintVaultUnlocking
	string 	hintVaultKeyNeeded
	string 	hintVaultKeyUse
	string 	hintVaultNeedTimestamp
	string	vaultUITitleString

	string 	bcGotVaultKey
	string 	bcVaultOpened

	int 	commsPingVault
	int		commsPingVaultOpen
	int		commsPingVaultHasKeySquad
	int 	commsPingVaultHasKeySelf

	int 	pingVault
	int 	pingTypeReveal
	int		pingVaultHasKeySelf
	int		pingVaultHasKeySquad
	string	pingVaultReveal

	float	lootToPanelDistSqr
	vector	alarmVFXVec
	vector	alarmVFXAngle
	asset 	vaultAlarmVFX

	string onOpenPinEvent
	string onPickupPinEvent
}

global const UniqueVaultData LOOT_VAULT_DATA = {
	panelScriptName				= LOOT_VAULT_PANEL_SCRIPTNAME,
	vaultKeylootType			= "data_knife",
	hasVaultKeyString			= "hasDataKnife",

	hintVaultUnlocking 			= "#HINT_VAULT_UNLOCKING",
	hintVaultKeyNeeded 			= "#HINT_VAULT_NEED",
	hintVaultKeyUse				= "#HINT_VAULT_USE",
	hintVaultNeedTimestamp		= "#HINT_VAULT_NEED_TIMESTAMP",
	vaultUITitleString			= "#LOOT_VAULT_UI_TITLE",

	bcGotVaultKey				= "bc_vaultKeyGot",
	bcVaultOpened				= "bc_vaultOpened",

	commsPingVault				= eCommsAction.PING_LOOT_VAULT,
	commsPingVaultOpen			= eCommsAction.PING_LOOT_VAULT_OPEN,
	commsPingVaultHasKeySquad 	= eCommsAction.PING_LOOT_VAULT_HAS_KEY_SQUAD,
	commsPingVaultHasKeySelf	= eCommsAction.PING_LOOT_VAULT_HAS_KEY_SELF,

	pingVault					= ePingType.LOOT_VAULT,
	pingTypeReveal				= ePingType.LOOT_VAULT_REVEAL,
	pingVaultHasKeySelf			= ePingType.LOOT_VAULT_HAS_KEY_SELF,
	pingVaultHasKeySquad		= ePingType.LOOT_VAULT_HAS_KEY_SQUAD,
	pingVaultReveal				= "#PING_LOOT_VAULT_REVEAL",

	lootToPanelDistSqr 			= 800000.0,
	alarmVFXVec					= < 0, 0, 0 >,
	alarmVFXAngle				= < 0, -90, 0 >,
	vaultAlarmVFX				= $"P_vault_door_alarm"

	onOpenPinEvent					= "MapToy_loot_vault_open"
	onPickupPinEvent				= "MapToy_loot_vault_key_pickup"
}

                  
global const UniqueVaultData SHIP_VAULT_DATA = {
	panelScriptName				= SHIP_VAULT_PANEL_SCRIPTNAME,
	vaultKeylootType			= "ship_keycard",
	hasVaultKeyString			= "hasShipKeycard",

	hintVaultUnlocking 			= "#HINT_SHIP_VAULT_UNLOCKING",
	hintVaultKeyNeeded 			= "#HINT_SHIP_VAULT_NEED",
	hintVaultKeyUse				= "#HINT_SHIP_VAULT_USE",
	hintVaultNeedTimestamp		= "#HINT_SHIP_VAULT_NEED_TIMESTAMP",
	vaultUITitleString			= "#SHIP_VAULT_UI_TITLE",

	bcGotVaultKey				= "bc_keyCardGot",
	bcVaultOpened				= "bc_vaultOpened",

	commsPingVault				= eCommsAction.PING_SHIP_VAULT,
	commsPingVaultOpen			= eCommsAction.PING_LOOT_VAULT_OPEN,
	commsPingVaultHasKeySquad 	= eCommsAction.PING_SHIP_VAULT_HAS_KEY_SQUAD,
	commsPingVaultHasKeySelf	= eCommsAction.PING_SHIP_VAULT_HAS_KEY_SELF,

	pingVault					= ePingType.SHIP_VAULT,
	pingTypeReveal				= ePingType.SHIP_VAULT_REVEAL,
	pingVaultHasKeySelf			= ePingType.SHIP_VAULT_HAS_KEY_SELF,
	pingVaultHasKeySquad		= ePingType.SHIP_VAULT_HAS_KEY_SQUAD,
	pingVaultReveal				= "#PING_SHIP_VAULT_REVEAL",

	lootToPanelDistSqr 			= 1000000.0,
	alarmVFXVec					= < -5, 0, 0 >,
	alarmVFXAngle				= < 0, 180, 0 >,
	vaultAlarmVFX				= $"P_vault_door_alarm_oly_mu1"

	onOpenPinEvent					= "MapToy_ship_vault_open"
	onPickupPinEvent				= "MapToy_ship_vault_key_pickup"
}
                        

struct
{
	array< void functionref( VaultData, int ) > vaultPanelUnlockingStateCallbacks
	array< void functionref( VaultData, int ) > vaultPanelUnlockedStateCallbacks

	array< entity >				vaultDoors
	array< VaultData > 			vaultControlPanels
	array< UniqueVaultData > 	uniqueVaultDatas =
	[
		LOOT_VAULT_DATA,
                   
		SHIP_VAULT_DATA
                         
	]

	#if SERVER
                    
			               		                
        
		              			              
		               			           
		      					        
	#endif
} file


void function Sh_Loot_Vault_Panel_Init()
{
	if ( GetCurrentPlaylistVarBool( "loot_vaults_enabled", true ) == false )
		return

	PrecacheParticleSystem( LOOT_VAULT_DATA.vaultAlarmVFX )
                   
		PrecacheParticleSystem( SHIP_VAULT_DATA.vaultAlarmVFX )
		PrecacheParticleSystem( SHIP_VAULT_PANEL_OPEN_FX )
		PrecacheParticleSystem( SHIP_VAULT_PANEL_LOCKED_FX )
                         

	#if CLIENT
                    
			AddCreateCallback( "prop_dynamic", VaultDoorSpawned )
                          
		AddCreateCallback( "prop_dynamic", VaultPanelSpawned )
		AddCreateCallback( "prop_door", VaultDoorSpawned )
		RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.VAULT_PANEL, MINIMAP_OBJECT_RUI, MinimapPackage_VaultPanel, FULLMAP_OBJECT_RUI, MinimapPackage_VaultPanel )
		RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.VAULT_PANEL_OPEN, MINIMAP_OBJECT_RUI, MinimapPackage_VaultPanelOpen, FULLMAP_OBJECT_RUI, MinimapPackage_VaultPanelOpen )
	#endif         

	#if SERVER
                    
			                                                           
			                                                    
        
		                                                     
		                                                 

		                                                                                  
                    
			                                                                                  
        

		                                              

		                                                                                    
	#endif         

	LootVaultPanels_AddCallback_OnVaultPanelStateChangedToUnlocking( VaultPanelUnlocking )
}

#if SERVER
                  
                                                       
 
	                                                            
		      

	                                             
	                                                   
	                 
 
                        
#endif          

void function VaultPanelSpawned( entity panel )
{
	if ( !IsVaultPanel( panel ) )
		return

	VaultData data
	data.panel = panel

	UniqueVaultData uniqueData = GetUniqueVaultData( panel )

	#if SERVER
		                                                                
			                                                                                      
                    
		                                                                                                               
			                                                                                                                                                                                         
                          

		                  
		                                             
	#endif          

	file.vaultControlPanels.append( data )

	SetVaultPanelUsable( panel )
}

#if SERVER
                                                    
 
	                                
 

                                
 
	                                     
	 
		                                                                                      
		                                         
		                                                                           
		                                                
		                                            
		                                      
			                                    

		                                                                                          
		                                             
		                                                                                    
		                                                    
		                                                    
		                                      
			                                        
	 
 

                                              
 
	                                     
	 
		                                                    
		                                                  
		 
			                            
				                                          
		 
	 
 

                                                
 
	                                     
	 
		                                                    
		                                                  
		 
			                            
				                                    
		 
	 
 

                                                     
 
	                                                       
	                          
	 
		                     
			                                   
	 
 

                                                       
 
	                                                      
	                          
	 
		                     
			                             
	 
 

                                                         
 
	                                  

	           

	                                
 

                                                      
 
	                                                  
	 
		                                               
	 

	                                

	                                       
 

                                                             
 
	                         
		      

	                     
		      

	                                     
	 
		                        
			        

		                                    
		                                                                                  
		                                
	 
 

                                                         
 
	                                                  
	 
		                                           
		 
			                          
				                  
		 
	 
 
#endif          

void function VaultDoorSpawned( entity door )
{
	if ( !IsVaultDoor( door ) )
		return

	string doorScriptName = door.GetScriptName()
	if ( doorScriptName == LOOT_VAULT_DOOR_SCRIPTNAME || doorScriptName == LOOT_VAULT_DOOR_SCRIPTNAME_RIGHT)
	{
		door.SetSkin( 1 )
		#if SERVER
			                  
			                                   
			                      
			                            
			                          
			                        
			                            
		#endif          
	}

	file.vaultDoors.append( door )
}

#if SERVER
                               
 
	       
		                         
	             

	                                                
	 
                    
			                                                                     
			 
				                                       
				                                 
				                                                    

				                                                
			 
                          

		                                          
		 
			                                                                     
			 
				                                                                                              
					        

				                                              
			 
                     
			                                                                          
			 
				                                              

				                                                                         
				                                    
				                                                                    
				                                                                                                                      

				                                                                
				                             
				                                                                           
			 

                           

			                                             
			 
				       
					                                                                                     
				             

					                                   

				       
					                        
				             
			 
		 

		       
			                                                                                                                                                                                   
		             
	 
 
#endif          

UniqueVaultData function GetUniqueVaultData( entity panel )
{
	UniqueVaultData data

	if ( IsValid( panel ) )
	{
		if ( panel.GetScriptName() == LOOT_VAULT_PANEL_SCRIPTNAME )
			data = LOOT_VAULT_DATA
                    
		else if ( panel.GetScriptName() == SHIP_VAULT_PANEL_SCRIPTNAME )
			data = SHIP_VAULT_DATA
                          
	}

	return data
}


UniqueVaultData function GetUniqueVaultDataByLootItem( int lootType )
{
	UniqueVaultData data

	if ( lootType == eLootType.DATAKNIFE )
		data = LOOT_VAULT_DATA
                   
	else if ( lootType == eLootType.SHIPKEYCARD )
		data = SHIP_VAULT_DATA
                         

	return data
}


UniqueVaultData function GetVaultTypeByPanelData( VaultData panelData )
{
	UniqueVaultData data

	entity door = panelData.vaultDoors.top()
	string doorScriptName = door.GetScriptName()

	if ( doorScriptName == LOOT_VAULT_DOOR_SCRIPTNAME || doorScriptName == LOOT_VAULT_DOOR_SCRIPTNAME_RIGHT )
		data = LOOT_VAULT_DATA
                   
	else if ( doorScriptName == SHIP_VAULT_DOOR_SCRIPTNAME )
		data = SHIP_VAULT_DATA
                         

	return data
}


bool function HasVaultKey( entity player )
{
	if ( player.GetPlayerNetBool( "hasDataKnife" ) )
		return true
                   
	else if ( GetCurrentPlaylistVarBool( "loot_vaults_enabled", true ) && player.GetPlayerNetBool( "hasShipKeycard" ) )
		return true
                         

	return false
}

string function GetVaultKeyPlayerNetBoolFromItemRef( string ref )
{
	string hasVaultKeyString

	if ( ref == "data_knife" )
		hasVaultKeyString = "hasDataKnife"
                   
	else if ( ref == "ship_keycard" )
		hasVaultKeyString = "hasShipKeycard"
                         

	return hasVaultKeyString
}


void function SetVaultPanelState( VaultData panelData, int panelState )
{
	if ( panelState == panelData.panelState )
		return

	printf( "LootVaultPanelDebug: Changing panel state from %i to %i.", panelData.panelState, panelState )

	panelData.panelState = panelState

	switch ( panelState )
	{
		case ePanelState.LOCKED:
			return

		case ePanelState.UNLOCKING:
			LootVaultPanelState_Unlocking( panelData, panelState )

		case ePanelState.UNLOCKED:
			LootVaultPanelState_Unlocked( panelData, panelState )

		default:
			return
	}
}


void function LootVaultPanels_AddCallback_OnVaultPanelStateChangedToUnlocking( void functionref( VaultData, int ) callbackFunc )
{
	Assert( !file.vaultPanelUnlockingStateCallbacks.contains( callbackFunc ), "Already added " + string( callbackFunc ) + " with LootVaultPanels_AddCallback_OnVaultPanelStateChanged" )
	file.vaultPanelUnlockingStateCallbacks.append( callbackFunc )
}


void function LootVaultPanelState_Unlocking( VaultData panelData, int panelState )
{
	foreach ( func in file.vaultPanelUnlockingStateCallbacks )
		func( panelData, panelData.panelState )
}

#if SERVER
                                                                                                                               
 
	                                                                                                                                                                                   
	                                                            
 
#endif

void function LootVaultPanelState_Unlocked( VaultData panelData, int panelState )
{
	foreach ( func in file.vaultPanelUnlockedStateCallbacks )
		func( panelData, panelData.panelState )
}


bool function LootVaultPanel_CanUseFunction( entity playerUser, entity panel, int useFlags )
{
	if ( Bleedout_IsBleedingOut( playerUser ) )
		return false

	if ( playerUser.ContextAction_IsActive() )
		return false

	entity activeWeapon = playerUser.GetActiveWeapon( eActiveInventorySlot.mainHand )
	if ( IsValid( activeWeapon ) && activeWeapon.IsWeaponOffhand() )
		return false

	if ( panel.e.isBusy )
		return false

	if ( GetVaultPanelDataFromEntity( panel ).panelState != ePanelState.LOCKED )
		return false

	return true
}


void function OnVaultPanelUse( entity panel, entity playerUser, int useInputFlags )
{
	if ( !(useInputFlags & USE_INPUT_LONG) )
		return

	UniqueVaultData data = GetUniqueVaultData( panel )

	if ( !HasVaultKey( playerUser ) )
		return

	ExtendedUseSettings settings

	settings.duration = VAULT_PANEL_USE_TIME
	settings.useInputFlag = IN_USE_LONG
	settings.successSound = LOOT_VAULT_AUDIO_ACCESS
	settings.successFunc = VaultPanelUseSuccess

	#if CLIENT
		settings.loopSound = LOOT_VAULT_AUDIO_STATUSBAR
		settings.displayRuiFunc = DisplayRuiForLootVaultPanel
		settings.displayRui = $"ui/health_use_progress.rpak"
		settings.icon = $"rui/hud/gametype_icons/survival/data_knife"
		settings.hint = data.hintVaultUnlocking
	#endif         

	#if SERVER
		                            
		                               
		                             
	#endif         

	thread ExtendedUse( panel, playerUser, settings )
}


void function ForceVaultOpen( entity panel )
{
	VaultData panelData = GetVaultPanelDataFromEntity( panel )

	if ( panelData.panelState != ePanelState.UNLOCKING )
		SetVaultPanelState( panelData, ePanelState.UNLOCKING )
}


void function VaultPanelUseSuccess( entity panel, entity player, ExtendedUseSettings settings )
{
	VaultData panelData = GetVaultPanelDataFromEntity( panel )
	UniqueVaultData data = GetUniqueVaultData( panel )

	#if SERVER
		                                                                      
		                                                                           
		 
			                                                                                              
			                                  
		 

		                                                                                       
		                                                              
	#endif

	if ( panelData.panelState != ePanelState.UNLOCKING )
		SetVaultPanelState( panelData, ePanelState.UNLOCKING )
}


void function VaultPanelUnlocking( VaultData panelData, int panelState )
{
	if ( panelState != ePanelState.UNLOCKING )
		return

	#if SERVER
		                             
	#endif         

	thread HideVaultPanel_Thread( panelData )
}

#if SERVER
                                                                       
 
	                                         
		      

	                                                                

	                                        
		                                                          

	                                            
	                                 
	 
		                                                                               
			                                           
	 
 


                                                               
 
	                                                                            

	                         
	 
		                         
		      
	 

	                    
		      
	                                                     
 

                  
                                                                   
 
	                            
	 
		                                                    
		                             
		                                       

		                                                   
			                      
				                               
		   

		                                  
		                              
		                        
	   
 
                        
#endif          

void function HideVaultPanel_Thread( VaultData panelData )
{
	VaultData savedData = GetVaultPanelDataFromEntity( panelData.panel )

	#if SERVER
		                                                         

		                                                                     
		 
			                            
			                                                
		 
                    
		                                                                          
		 
			                                                            
			        
			                            

			                                         
				                                     

			                                                                                                                                                                                                              

			                                                                                
			                                
			                          
		 
                          
	#endif          

	wait 2.0

	SetVaultPanelState( savedData, ePanelState.UNLOCKED )
}

#if CLIENT
string function VaultPanel_TextOverride( entity panel )
{
	UniqueVaultData data = GetUniqueVaultData( panel )

	entity player = GetLocalViewPlayer()
	string textOverride 

	int currentUnixTime           = GetUnixTimestamp()
	int ornull keyAccessTimeStamp = GetCurrentPlaylistVarTimestamp( "loot_vault_key_availability_unixtime", 1566864000 )
	if ( keyAccessTimeStamp != null )
	{
		if ( currentUnixTime < expect int( keyAccessTimeStamp ) )
		{
			int timeDelta        = expect int(keyAccessTimeStamp) - currentUnixTime
			TimeParts timeParts  = GetUnixTimeParts( timeDelta )
			string timeString    = GetDaysHoursMinutesSecondsString( timeDelta )

			textOverride = Localize( data.hintVaultNeedTimestamp, timeString )
		}
	}

	if ( IsVaultPanelLocked( panel ) )
	{
		if ( HasVaultKey( player ) )
			textOverride = data.hintVaultKeyUse
		else
			textOverride = data.hintVaultKeyNeeded
	}

	return textOverride
}


void function DisplayRuiForLootVaultPanel( entity ent, entity player, var rui, ExtendedUseSettings settings )
{
	DisplayRuiForLootVaultPanel_Internal( rui, settings.icon, Time(), Time() + settings.duration, settings.hint )
}


void function DisplayRuiForLootVaultPanel_Internal( var rui, asset icon, float startTime, float endTime, string hint )
{
	RuiSetBool( rui, "isVisible", true )
	RuiSetImage( rui, "icon", icon )
	RuiSetGameTime( rui, "startTime", startTime )
	RuiSetGameTime( rui, "endTime", endTime )
	RuiSetString( rui, "hintKeyboardMouse", hint )
	RuiSetString( rui, "hintController", hint )
}
#endif         

VaultData function GetVaultPanelDataFromEntity( entity panel )
{
	foreach ( panelData in file.vaultControlPanels )
	{
		if ( panelData.panel == panel )
			return panelData
	}

	Assert( false, "Invalid Loot Vault Panel ( " + string( panel ) + " )." )

	unreachable
}


void function SetVaultPanelUsable( entity panel )
{
	#if SERVER
		                 
		                                 
		                                           
		                                                              
	#endif         

	SetCallback_CanUseEntityCallback( panel, LootVaultPanel_CanUseFunction )

	#if CLIENT
		AddEntityCallback_GetUseEntOverrideText( panel, VaultPanel_TextOverride )
		AddCallback_OnUseEntity_ClientServer( panel, OnVaultPanelUse )
	#endif         
}


void function SetVaultPanelMinimapObj( entity panel, entity minimapObj )
{
	VaultData panelData = GetVaultPanelDataFromEntity( panel )

	panelData.minimapObj = minimapObj
}


void function SetVaultPanelOpenMinimapObj( entity panel, entity minimapObj )
{
	VaultData panelData = GetVaultPanelDataFromEntity( panel )

	panelData.openMinimapObj = minimapObj
}


entity function GetVaultPanelMinimapObj( entity panel )
{
	VaultData panelData = GetVaultPanelDataFromEntity( panel )

	return panelData.minimapObj
}


#if SERVER
                                                         
 
	                                                          

	                                      
		                              
 


                                                                                            
 
	                                                       

	                                                                                                                      

	                          

	         
 
#endif

bool function IsVaultDoor( entity ent )
{
	if ( !IsValid( ent ) )
		return false

	string scriptName = ent.GetScriptName()

	if ( scriptName == LOOT_VAULT_DOOR_SCRIPTNAME || scriptName == LOOT_VAULT_DOOR_SCRIPTNAME_RIGHT )
		return true

                   
		if ( scriptName == SHIP_VAULT_DOOR_SCRIPTNAME )
			return true

		entity parentEnt = ent.GetParent()
		if ( IsValid( parentEnt ) && parentEnt.GetScriptName() == SHIP_VAULT_PANEL_SCRIPTNAME )
			return true
                         

	return false
}


bool function IsVaultPanel( entity ent )
{
	if ( !IsValid( ent ) )
		return false

	if ( ent.GetScriptName() == LOOT_VAULT_PANEL_SCRIPTNAME )
		return true

                   
		if ( ent.GetScriptName() == SHIP_VAULT_PANEL_SCRIPTNAME )
			return true
                         

	return false
}


entity function GetVaultDoorForHitEnt( entity hitEnt )
{
	entity hitEntParent = hitEnt.GetParent()
	if ( !IsVaultDoor( hitEntParent ) )
		return null

	foreach ( vaultDoor in file.vaultDoors )
	{
		if ( vaultDoor == hitEntParent )
			return vaultDoor
	}
	return null

}

entity function GetVaultPanelFromDoor( entity door )
{
	foreach ( panelData in file.vaultControlPanels )
	{
		if ( !IsValid( panelData.panel ) )
			return null

		#if SERVER
			                                             
			 
				                        
					                      
			 
		#endif

		#if CLIENT
			if ( DistanceSqr( panelData.panel.GetOrigin(), door.GetOrigin() ) <= PANEL_TO_DOOR_RADIUS_SQR )
				return panelData.panel
		#endif
	}

	return null
}


bool function IsVaultPanelLocked( entity vaultPanel )
{
	return GradeFlagsHas( vaultPanel, eGradeFlags.IS_LOCKED )
}


entity function VaultPanel_GetTeammateWithKey( int teamIdx )
{
	array< entity > squad = GetPlayerArrayOfTeam( teamIdx )

	foreach ( player in squad )
	{
		if ( HasVaultKey( player ) )
			return player
	}

	return null
}


string function GetNameOfTeammateWithVaultKey( int team )
{
	foreach ( player in GetPlayerArrayOfTeam( team ) )
	{
		if ( HasVaultKey( player ) )
			return player.GetPlayerName()
	}

	return ""
}


array< entity > function VaultPanel_GetBestMinimapObjs()
{
	array<entity> mapObjs
	foreach ( data in file.vaultControlPanels )
	{
		entity minimapObj
		if ( data.panelState == ePanelState.LOCKED )
			minimapObj = data.minimapObj
		else
			minimapObj = data.openMinimapObj

		if ( IsValid( minimapObj ) )
			mapObjs.append( minimapObj )
	}

	return mapObjs
}


array< entity > function VaultPanel_GetAllMinimapObjs()
{
	array<entity> mapObjs
	foreach ( data in file.vaultControlPanels )
	{
		mapObjs.append( data.minimapObj )
		mapObjs.append( data.openMinimapObj )
	}

	return mapObjs
}


entity function GetVaultPanelForLoot( entity lootEnt )
{
	foreach ( panelData in file.vaultControlPanels )
	{
		if ( !IsValid( panelData.panel ) )
			continue

		UniqueVaultData vaultData = GetUniqueVaultData( panelData.panel )

		vector lootEntToPanel = panelData.panel.GetOrigin() - lootEnt.GetOrigin()

		if ( LengthSqr( lootEntToPanel ) < vaultData.lootToPanelDistSqr )
		{
			if ( vaultData.panelScriptName == LOOT_VAULT_PANEL_SCRIPTNAME )
			{
				vector panelFwd = panelData.panel.GetRightVector()                                                                                                                                                 
				if ( DotProduct( panelFwd, Normalize( lootEntToPanel ) ) > 0 )
					return panelData.panel
			}
                     
			else if ( vaultData.panelScriptName == SHIP_VAULT_PANEL_SCRIPTNAME )
			{
				vector panelFwd = -panelData.panel.GetForwardVector()                                               
				if ( DotProduct( panelFwd, Normalize( lootEntToPanel ) ) > 0 )
					return panelData.panel
			}
                           
		}
	}

	return null
}

#if SERVER
                                                                                             
 
	                                      

	                                                  
	                                                                  
		      

	                                    

	                                                    
	                                                        
	                                                           

	                        
		                                            

	           

	                        
	 
		                                         

		                                                     
		                                    
		                                         
		                                      
		                                      
		                                               
		                                                  
		                                      
		                                                        
		                                                                
		                                                                   
		                                                                                                                                                                                                                            
	 

	                                                            

	                
	                                                       
		                           
			                   
		                            
			                                                  
	   

	        
	                        
	                                   
	 
		                                                  

		                                                    
			                                                  
			                                                                                                                    
		                                             

		        
		                   
		        
	 
 

                  
                                                         
 
	                               
	                  
	 
		                                                                                        
		                                                                            

		                                             
			                                                                                   
		                                               
			                                                                                
		                                                
			                                                                                 
	 
 
                        
#endif          


#if SERVER && DEV
                              
 
	                                                        
	 
		                                                            
			                                                                                             
	 
 
#endif                 

#if CLIENT
void function MinimapPackage_VaultPanel( entity ent, var rui )
{
	#if MINIMAP_DEBUG
		printt( "Adding 'rui/hud/gametype_icons/survival/data_knife_vault' icon to minimap" )
	#endif
	RuiSetImage( rui, "defaultIcon", $"rui/hud/gametype_icons/survival/data_knife_vault" )
	RuiSetFloat3( rui, "iconColor", (GetKeyColor( COLORID_LOOT_TIER5 ) / 255.0) )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
	RuiSetBool( rui, "useTeamColor", false )
}

void function MinimapPackage_VaultPanelOpen( entity ent, var rui )
{
	#if MINIMAP_DEBUG
		printt( "Adding 'rui/hud/gametype_icons/survival/data_knife_vault_open' icon to minimap" )
	#endif
	RuiSetImage( rui, "defaultIcon", $"rui/hud/gametype_icons/survival/data_knife_vault_open" )
	RuiSetImage( rui, "smallIcon", $"rui/hud/gametype_icons/survival/data_knife_vault_small" )
	RuiSetBool( rui, "hasSmallIcon", true )
	RuiSetFloat3( rui, "iconColor", (GetKeyColor( COLORID_LOOT_TIER5 ) / 255.0) )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
	RuiSetBool( rui, "useTeamColor", false )
}
#endif