untyped

global function InitDevMenu
#if DEV
global function DEV_InitLoadoutDevSubMenu
global function SetupDevCommand           
global function SetupDevFunc           
global function SetupDevMenu
global function ChangeToThisMenu
global function RepeatLastDevCommand
global function UpdatePrecachedSPWeapons
global function RunCodeDevCommandByAlias
global function DEV_ExecBoundDevMenuCommand
global function DEV_InitCodeDevMenu
global function DevMenu_ToggleBG
#endif

global function ServerCallback_OpenDevMenu

                                                                     

global function AddLevelDevCommand

const string DEV_MENU_NAME = "[LEVEL]"

struct DevMenuPage
{
	void functionref()      devMenuFunc
	void functionref( var ) devMenuFuncWithOpParm
	var                     devMenuOpParm
}

struct DevCommand
{
	string                  label
	string                  command
	var                     opParm
	void functionref( var ) func
	bool                    isAMenuCommand = false
}


struct
{
	array<DevMenuPage> pageHistory = []
	DevMenuPage &      currentPage
	var                header
	array<var>         buttons
	array<table>       actionBlocks
	array<DevCommand>  devCommands
	DevCommand&        lastDevCommand
	bool               lastDevCommandAssigned
	string             lastDevCommandLabel
	string             lastDevCommandLabelInProgress
	bool               precachedWeapons

	DevCommand& focusedCmd
	bool        focusedCmdIsAssigned

	DevCommand boundCmd
	bool       boundCmdIsAssigned

	var footerHelpTxtLabel

	bool                      initializingCodeDevMenu = false
	string                    codeDevMenuPrefix = DEV_MENU_NAME + "/"
	table<string, DevCommand> codeDevMenuCommands

	array<DevCommand> levelSpecificCommands = []

	var menu
	var bg
} file

function Dummy_Untyped( param )
{

}


void function InitDevMenu( var newMenuArg )
                                              
{
	#if DEV
		var menu = GetMenu( "DevMenu" )

		AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenDevMenu )

		file.header = Hud_GetChild( menu, "MenuTitle" )
		file.buttons = GetElementsByClassname( menu, "DevButtonClass" )
		foreach ( button in file.buttons )
		{
			Hud_AddEventHandler( button, UIE_CLICK, OnDevButton_Activate )
			Hud_AddEventHandler( button, UIE_GET_FOCUS, OnDevButton_GetFocus )
			Hud_AddEventHandler( button, UIE_LOSE_FOCUS, OnDevButton_LoseFocus )

			RuiSetString( Hud_GetRui( button ), "buttonText", "" )
			Hud_SetEnabled( button, false )
		}

		AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "%[B_BUTTON|]% Back", "Back" )
		AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, BackOnePage_Activate )
		AddMenuFooterOption( menu, LEFT, BUTTON_Y, true, "%[Y_BUTTON|]% Repeat Last Dev Command:", "Repeat Last Dev Command:", RepeatLastCommand_Activate )
		AddMenuFooterOption( menu, LEFT, BUTTON_BACK, true, "%[BACK|]% Bind Selection to Gamepad", "", BindCommandToGamepad_Activate )
		file.footerHelpTxtLabel = GetElementsByClassname( menu, "FooterHelpTxt" )[0]

		RegisterSignal( "DEV_InitCodeDevMenu" )
		AddUICallback_LevelLoadingFinished( DEV_InitCodeDevMenu )
		AddUICallback_LevelShutdown( ClearCodeDevMenu )
		                 
		file.menu = menu
		file.bg = Hud_GetChild( menu, "BlackBackground" )

	#endif
}

void function AddLevelDevCommand( string label, string command )
{
	#if DEV
		string codeDevMenuAlias = DEV_MENU_NAME + "/" + label
		DevMenu_Alias_DEV( codeDevMenuAlias, command )

		DevCommand cmd
		cmd.label = label
		cmd.command = command
		file.levelSpecificCommands.append( cmd )
	#endif
}

void function ServerCallback_OpenDevMenu()
{
	#if DEV
		AdvanceMenu( GetMenu( "DevMenu" ) )
	#endif
}

#if DEV
void function OnOpenDevMenu()
{
	file.pageHistory.clear()
	file.currentPage.devMenuFunc = null
	file.currentPage.devMenuFuncWithOpParm = null
	file.currentPage.devMenuOpParm = null
	file.lastDevCommandLabelInProgress = ""

	SetDevMenu_MP()

	                           
}


                                         
   
  	                                   
  	                                          
  	                                                                        
  	                                                                                      
  	                                                                                              
  	                                                   
   


void function DEV_InitCodeDevMenu()
{
	thread DEV_InitCodeDevMenu_Internal()
}


void function DEV_InitCodeDevMenu_Internal()
{
	Signal( uiGlobal.signalDummy, "DEV_InitCodeDevMenu" )
	EndSignal( uiGlobal.signalDummy, "DEV_InitCodeDevMenu" )

	while ( !IsFullyConnected() || !IsItemFlavorRegistrationFinished() )
	{
		WaitFrame()
	}

	file.initializingCodeDevMenu = true
	DevMenu_Alias_DEV( DEV_MENU_NAME, "" )
	DevMenu_Rm_DEV( DEV_MENU_NAME )
	OnOpenDevMenu()
	file.initializingCodeDevMenu = false

	  
	if ( IsPVEMode() || FreelanceSystemsAreEnabled() )
		PopulateFreelanceDevMenu()
}


void function ClearCodeDevMenu()
{
	DevMenu_Alias_DEV( DEV_MENU_NAME, "" )
	DevMenu_Rm_DEV( DEV_MENU_NAME )

	ClearFreelanceDevMenu()
}


void function UpdateDevMenuButtons()
{
	file.devCommands.clear()
	if ( developer() == 0 )
		return

	if ( file.initializingCodeDevMenu )
		return

	         
	{
		string titleText = file.lastDevCommandLabelInProgress
		if ( titleText == "" )
			titleText = ("Developer Menu    -    " + GetActiveLevel())
		Hud_SetText( file.header, titleText )
	}

	if ( file.currentPage.devMenuOpParm != null )
		file.currentPage.devMenuFuncWithOpParm( file.currentPage.devMenuOpParm )
	else
		file.currentPage.devMenuFunc()

	foreach ( index, button in file.buttons )
	{
		int buttonID = int( Hud_GetScriptID( button ) )

		if ( buttonID < file.devCommands.len() )
		{
			RuiSetString( Hud_GetRui( button ), "buttonText", file.devCommands[buttonID].label )
			Hud_SetEnabled( button, true )
		}
		else
		{
			RuiSetString( Hud_GetRui( button ), "buttonText", "" )
			Hud_SetEnabled( button, false )
		}

		if ( buttonID == 0 )
			Hud_SetFocused( button )
	}

	RefreshRepeatLastDevCommandPrompts()
}

void function SetDevMenu_MP()
{
	if ( file.initializingCodeDevMenu )
	{
		SetupDefaultDevCommandsMP()
		return
	}
	PushPageHistory()
	file.currentPage.devMenuFunc = SetupDefaultDevCommandsMP
	UpdateDevMenuButtons()
}


void function ChangeToThisMenu( void functionref() menuFunc )
{
	if ( file.initializingCodeDevMenu )
	{
		menuFunc()
		return
	}
	PushPageHistory()
	file.currentPage.devMenuFunc = menuFunc
	file.currentPage.devMenuFuncWithOpParm = null
	file.currentPage.devMenuOpParm = null
	UpdateDevMenuButtons()
}


void function ChangeToThisMenu_WithOpParm( void functionref( var ) menuFuncWithOpParm, opParm = null )
{
	if ( file.initializingCodeDevMenu )
	{
		menuFuncWithOpParm( opParm )
		return
	}

	PushPageHistory()
	file.currentPage.devMenuFunc = null
	file.currentPage.devMenuFuncWithOpParm = menuFuncWithOpParm
	file.currentPage.devMenuOpParm = opParm
	UpdateDevMenuButtons()
}

void function SetupDefaultDevCommandsMP()
{
	file.devCommands.clear()

	if ( IsSurvivalMenuEnabled() )
	{
		SetupDevMenu( "Change Character", SetDevMenu_SurvivalCharacter )
		SetupDevMenu( "Alter Loadout", SetDevMenu_AlterLoadout )
		SetupDevMenu( "Override Spawn Character", SetDevMenu_OverrideSpawnSurvivalCharacter )
		SetupDevMenu( "Survival", SetDevMenu_Survival )
		SetupDevMenu( "Survival Weapons", SetDevMenu_SurvivalLoot, "main_weapon" )
		SetupDevMenu( "Survival Attachments", SetDevMenu_SurvivalLoot, "attachment" )
		SetupDevMenu( "Survival Helmets", SetDevMenu_SurvivalLoot, "helmet" )
		SetupDevMenu( "Survival Armor", SetDevMenu_SurvivalLoot, "armor" )
		SetupDevMenu( "Survival Backpack", SetDevMenu_SurvivalLoot, "backpack" )
                    
                                                                             
        
		SetupDevMenu( "Survival Incap Shield", SetDevMenu_SurvivalLoot, "incapshield" )
		SetupDevMenu( "Survival Incap Shield Debugging", SetDevMenu_SurvivalIncapShieldBots )

		string itemsString = "ordnance ammo health custom_pickup"
		itemsString += " gadget"
                
			itemsString += " data_knife"
        
                     
			itemsString += " marvin_arm"
        
		SetupDevMenu( "Survival Items", SetDevMenu_SurvivalLoot, itemsString )

		SetupDevFunc( "Survival Loot Zone Preprocess", void function( var unused ) {
			ConfirmDialogData data
			data.headerText = "Run survival loot preprocess?"
			data.messageText = ""
			data.resultCallback = void function( int result ) {
				if ( result == eDialogResult.YES )
				{
					Dev_CommandLineAddParm( "-survival_preprocess", "" )
					ClientCommand( "reload" )       
				}
			}
			OpenConfirmDialogFromData( data )
		} )

		string cmdstr = "script " + GetActiveLevel().tolower()  + "_PathsPreprocess()"
		SetupDevCommand( "Map Paths Preprocess (function must be defined)", cmdstr )
	}

	if ( (GetConVarString( "mp_gamemode" ) == GAMEMODE_FREELANCE) )
		SetupDevMenu( "Freelance", SetDevMenu_Freelance )

	SetupDevMenu( "Respawn Player(s)", SetDevMenu_RespawnPlayers )
	SetupDevMenu( "Set Respawn Behaviour Override", SetDevMenu_RespawnOverride )
	SetupDevMenu( "Narrative Debug", SetDevMenu_NarrativeDebug )

	                                                                 
	                                                                         
	                                                                    


	SetupDevCommand( "Toggle Model Viewer", "script thread ToggleModelViewer()" )
	SetupDevCommand( "Toggle Outsource Viewer", "script thread OutsourceViewer_Toggle()" )
	                                                                       
	                                                            
	                                                                

	                                                            
	                                                                     

	                     
	   
	  	                                                        
	  	                                                                    
	  	                                                                                                                
	  	                                                                                                                  
	  	                                                              
	  	                                                     
	  	                                                                               
	   

	                                                                                         
	                                                                                                                                                                                              

	                                                                                                         
	SetupDevCommand( "DoF debug (ads)", "script_client ToggleDofDebug()" )

	                                                                                                          

	                                                                    
	                                                                            

	                                                                                                   

	                                                             
	                                                               

	                                                                                                       

	SetupDevCommand( "Summon Players to player 0", "script summonplayers()" )
	                                                                                       
	                                                                                                          
	                                                                                                                 
	                                                                                                       
	                                                                                                           
	SetupDevCommand( "Max Activity (Pilots)", "script SetMaxActivityMode(1)" )
	                                                                            
	                                                                                 
	SetupDevCommand( "Max Activity (Disabled)", "script SetMaxActivityMode(0)" )

	SetupDevCommand( "Toggle Skybox View", "script thread ToggleSkyboxView()" )
	SetupDevCommand( "Toggle HUD", "ToggleHUD" )
	                                                                              
	SetupDevCommand( "Map Metrics Toggle", "script_client GetLocalClientPlayer().ClientCommand( \"toggle map_metrics 0 1 2 3\" )" )
	SetupDevCommand( "Toggle Pain Death sound debug", "script TogglePainDeathDebug()" )
	SetupDevCommand( "Jump Randomly Forever", "script_client thread JumpRandomlyForever()" )

	SetupDevCommand( "Toggle Zeroing Mode", "script ToggleZeroingMode()" )
	SetupDevCommand( "Toggle Screen Alignment Tool", "script_client DEV_ToggleScreenAlignmentTool()" )

                 
	SetupDevCommand( "[CRAFTING] Airdrop Replicator at Player", "script Crafting_AirdropWorkbenchAtPlayer(gp()[0])" )
       
                      
	SetupDevCommand( "[HOVER VEHICLE] Spawn Hover Vehicle At Player", "script HoverVehicle_CreateForPlayer(gp()[0])" )
       

       
                                                    
      

	SetupDevMenu( "Prototypes", SetDevMenu_Prototypes )

	SetupDevMenu_SeasonQuests()


	foreach ( DevCommand cmd in file.levelSpecificCommands )
		SetupDevCommand( cmd.label, cmd.command )
}


void function SetDevMenu_LevelCommands( var _ )
{
	ChangeToThisMenu( SetupLevelDevCommands )
}


void function SetupLevelDevCommands()
{
	string activeLevel = GetActiveLevel()
	if ( activeLevel == "" )
		return

	switch ( activeLevel )
	{
		case "model_viewer":
			SetupDevCommand( "Toggle Rebreather Masks", "script ToggleRebreatherMasks()" )
			break
	}
}


void function SetDevMenu_SurvivalCharacter( var _ )
{
	thread ChangeToThisMenu( SetupChangeSurvivalCharacterClass )
}


void function DEV_InitLoadoutDevSubMenu()
{
	file.initializingCodeDevMenu = true
	string codeDevMenuPrefix = file.codeDevMenuPrefix
	                                          
	                                                 
	                                          
	                               
	file.codeDevMenuPrefix += "Alter Loadout/"
	DevMenu_Rm_DEV( file.codeDevMenuPrefix + "(Click to load this menu..)" )
	thread ChangeToThisMenu( SetupAlterLoadout )
	file.codeDevMenuPrefix = codeDevMenuPrefix
	file.initializingCodeDevMenu = false
}


void function SetDevMenu_AlterLoadout( var _ )
{
	if ( file.initializingCodeDevMenu )
	{
		        
		DevMenu_Alias_DEV( file.codeDevMenuPrefix + "(Click to load this menu..)", "script_ui DEV_InitLoadoutDevSubMenu()" )
	}
	else
	{
		thread ChangeToThisMenu( SetupAlterLoadout )
	}
}

void function SetupAlterLoadout()
{
	array<string> categories = []
	foreach ( LoadoutEntry entry in GetAllLoadoutSlots() )
	{
		if ( !categories.contains( entry.DEV_category ) )
			categories.append( entry.DEV_category )
	}
	categories.sort()
	foreach ( string category in categories )
	{
		SetupDevMenu( category, void function( var unused ) : ( category ) {
			thread ChangeToThisMenu( void function() : ( category ) {
				SetupAlterLoadout_CategoryScreen( category )
			} )
		} )
	}
}


void function SetupAlterLoadout_CategoryScreen( string category )
{
	array<LoadoutEntry> entries = clone GetAllLoadoutSlots()
	entries.sort( int function( LoadoutEntry a, LoadoutEntry b ) {
		if ( a.DEV_name < b.DEV_name )
			return -1
		if ( a.DEV_name > b.DEV_name )
			return 1
		return 0
	} )

	array<string> charactersUsed = []

	foreach ( LoadoutEntry entry in  entries )
	{
		if ( entry.DEV_category != category )
			continue

		string prefix = "character_"

		if ( entry.DEV_name.find( prefix ) == 0 )
		{
			string character = GetCharacterNameFromDEV_name( entry.DEV_name )

			if ( !charactersUsed.contains( character ) )
			{
				charactersUsed.append( character )
				SetupDevMenu( character, void function( var unused ) : ( category, character ) {
					thread ChangeToThisMenu( void function() : ( category, character ) {
						SetupAlterLoadout_CategoryScreenForCharacter( category, character )
					} )
				} )
			}
		}
		else
		{
			SetupDevMenu( entry.DEV_name, void function( var unused ) : ( entry ) {
				thread ChangeToThisMenu( void function() : ( entry ) {
					SetupAlterLoadout_SlotScreen_ByTier( entry )
				} )
			} )
		}
	}
}

void function SetupAlterLoadout_CategoryScreenForCharacter( string category, string character )
{
	array<LoadoutEntry> entries = clone GetAllLoadoutSlots()
	entries.sort( int function( LoadoutEntry a, LoadoutEntry b ) {
		if ( a.DEV_name < b.DEV_name )
			return -1
		if ( a.DEV_name > b.DEV_name )
			return 1
		return 0
	} )

	array< LoadoutEntry > entriesToUse

	foreach ( LoadoutEntry entry in entries )
	{
		if ( entry.DEV_category != category )
			continue

		string entryCharacter = GetCharacterNameFromDEV_name( entry.DEV_name )

		if ( entryCharacter != character )
			continue

		entriesToUse.append( entry )
	}


	if ( entriesToUse.len() > 1 )
	{
		foreach ( LoadoutEntry entry in entriesToUse )
		{
			SetupDevMenu( entry.DEV_name, void function( var unused ) : ( entry ) {
				thread ChangeToThisMenu( void function() : ( entry ) {
					SetupAlterLoadout_SlotScreen( entry )
				} )
			} )
		}
	}
	else if ( entriesToUse.len() == 1 )
	{
		LoadoutEntry entry = entriesToUse[ 0 ]
		SetupAlterLoadout_SlotScreen( entry )
	}
}

string function GetCharacterNameFromDEV_name( string DEV_name )
{
	string prefix = "character_"
	return split( DEV_name.slice( prefix.len() ), WHITESPACE_CHARACTERS )[ 0 ]
}

void function SetupAlterLoadout_SlotScreen_ByTier( LoadoutEntry entry )
{
	foreach ( int tier in eLootTier )
	{
		if ( tier == eLootTier._count )
			continue

		int rarity = tier - 1

		string name = DEV_GetEnumStringSafe( "eRarityTier", rarity )
		SetupDevMenu( name, void function( var unused ) : ( entry, rarity ) {
			thread ChangeToThisMenu( void function() : ( entry, rarity ) {
				SetupAlterLoadout_SlotScreen( entry, rarity )
			} )
		} )
	}
}

void function SetupAlterLoadout_SlotScreen( LoadoutEntry entry, int qualityFilter = -99 )
{
	                   
	                         
	   
	  	                                                                  
	  		                                                                    
	  	   
	   

	array<ItemFlavor> flavors = clone DEV_GetValidItemFlavorsForLoadoutSlotForDev( LocalClientEHI(), entry )
	flavors.sort( int function( ItemFlavor a, ItemFlavor b ) {
		string textA = Localize( ItemFlavor_GetLongName( a ) )
		string textB = Localize( ItemFlavor_GetLongName( b ) )

		if ( ItemFlavor_GetType( a ) > ItemFlavor_GetType( b ) )
			return 1

		if ( ItemFlavor_GetType( a ) < ItemFlavor_GetType( b ) )
			return -1

		if ( textA == "" )
			return -1

		if ( textB == "" )
			return 1

		                                                                                                                                                                      
		if ( textA.slice( 0, 1 ) == "[" && textB.slice( 0, 1 ) != "[" )
			return -1

		if ( textA.slice( 0, 1 ) != "[" && textB.slice( 0, 1 ) == "[" )
			return 1

		if ( textA < textB )
			return -1

		if ( textA > textB )
			return 1

		return 0
	} )

	foreach ( ItemFlavor flav in flavors )
	{
		if ( qualityFilter != -99 )
		{
			if ( !ItemFlavor_HasQuality( flav ) )
			{
				if ( qualityFilter != -1 )
					continue
			}
			else
			{
				if ( ItemFlavor_GetQuality( flav ) != qualityFilter )
					continue
			}
		}


		SetupDevFunc( "[" + Localize( ItemFlavor_GetTypeName( flav ) ) + "]  " + Localize( ItemFlavor_GetLongName( flav ) ), void function( var unused ) : ( entry, flav ) {
			DEV_RequestSetItemFlavorLoadoutSlot( LocalClientEHI(), entry, flav )
		} )
	}
}

void function DevMenu_ToggleBG()
{
	if ( Hud_IsVisible( file.bg ) )
	{
		Hud_Hide( file.bg )
	}
	else
	{
		Hud_Show( file.bg )
	}
}

void function SetDevMenu_OverrideSpawnSurvivalCharacter( var _ )
{
	thread ChangeToThisMenu( SetupOverrideSpawnSurvivalCharacter )
}


void function SetDevMenu_Survival( var _ )
{
	thread ChangeToThisMenu( SetupSurvival )
}


void function SetDevMenu_SurvivalLoot( var categories )
{
	thread ChangeToThisMenu_WithOpParm( SetupSurvivalLoot, categories )
}


void function SetDevMenu_SurvivalIncapShieldBots( var _ )
{
	thread ChangeToThisMenu( SetupSurvivalIncapShieldBot )
}



void function ChangeToThisMenu_PrecacheWeapons( void functionref() menuFunc )
{
	if ( file.initializingCodeDevMenu )
	{
		menuFunc()
		return
	}

	waitthread PrecacheWeaponsIfNecessary()

	PushPageHistory()
	file.currentPage.devMenuFunc = menuFunc
	file.currentPage.devMenuFuncWithOpParm = null
	file.currentPage.devMenuOpParm = null
	UpdateDevMenuButtons()
}


void function ChangeToThisMenu_PrecacheWeapons_WithOpParm( void functionref( var ) menuFuncWithOpParm, opParm = null )
{
	if ( file.initializingCodeDevMenu )
	{
		menuFuncWithOpParm( opParm )
		return
	}

	waitthread PrecacheWeaponsIfNecessary()

	PushPageHistory()
	file.currentPage.devMenuFunc = null
	file.currentPage.devMenuFuncWithOpParm = menuFuncWithOpParm
	file.currentPage.devMenuOpParm = opParm
	UpdateDevMenuButtons()
}


void function PrecacheWeaponsIfNecessary()
{
	if ( file.precachedWeapons )
		return

	file.precachedWeapons = true
	CloseAllMenus()

	DisablePrecacheErrors()
	wait 0.1
	ClientCommand( "script PrecacheSPWeapons()" )
	wait 0.1
	ClientCommand( "script_client PrecacheSPWeapons()" )
	wait 0.1
	RestorePrecacheErrors()

	AdvanceMenu( GetMenu( "DevMenu" ) )
}


void function UpdatePrecachedSPWeapons()
{
	file.precachedWeapons = true
}

void function SetDevMenu_RespawnPlayers( var _ )
{
	ChangeToThisMenu( SetupRespawnPlayersDevMenu )
}


void function SetupRespawnPlayersDevMenu()
{
	SetupDevCommand( "Respawn me", "respawn" )
	SetupDevCommand( "Respawn all players", "respawn all" )
	SetupDevCommand( "Respawn all dead players", "respawn alldead" )
	SetupDevCommand( "Respawn random player", "respawn random" )
	SetupDevCommand( "Respawn random dead player", "respawn randomdead" )
	SetupDevCommand( "Respawn bots", "respawn bots" )
	SetupDevCommand( "Respawn dead bots", "respawn deadbots" )
	SetupDevCommand( "Respawn my teammates", "respawn allies" )
	SetupDevCommand( "Respawn my enemies", "respawn enemies" )
	                                        
	   
	  	                                                                                                 
	   
}


void function SetDevMenu_RespawnOverride( var _ )
{
	ChangeToThisMenu( SetupRespawnOverrideDevMenu )
}

void function SetDevMenu_NarrativeDebug ( var _ )
{
	ChangeToThisMenu( SetupNarrativeDebugDevMenu )
}

void function SetupNarrativeDebugDevMenu()
{
	SetupDevMenu( "Dynamic Dialogue Debug", SetDevMenu_DynamicDialogueDebug )
}

void function SetDevMenu_DynamicDialogueDebug( var _ )
{
	ChangeToThisMenu( SetupDynamicDialogueDebug )
}

void function SetupDynamicDialogueDebug()
{
	array<AmbientConversationData> convos = clone GetAllAmbientDialogue()
	foreach (AmbientConversationData convo in convos)
	{
		string command = "script DEV_SetupForAmbientConversation(\"" + GetPlayerUID() + "\", \"" + convo.convoName + "\")"
		SetupDevCommand("Set up for: " + convo.convoName, command)
	}
}


void function SetupRespawnOverrideDevMenu()
{
	SetupDevCommand( "Use gamemode behaviour", "set_respawn_override off" )
	SetupDevCommand( "Override: Allow all respawning", "set_respawn_override allow" )
	SetupDevCommand( "Override: Deny all respawning", "set_respawn_override deny" )
	SetupDevCommand( "Override: Allow bot respawning", "set_respawn_override allowbots" )
}


void function SetDevMenu_ThreatTracker( var _ )
{
	ChangeToThisMenu( SetupThreatTrackerDevMenu )
}


void function SetupThreatTrackerDevMenu()
{
	SetupDevCommand( "Reload Threat Data", "fs_report_sync_opens 0; script ReloadScripts(); script ThreatTracker_ReloadThreatData()" )
	SetupDevCommand( "Threat Tracking ON", "script ThreatTracker_SetActive( true )" )
	SetupDevCommand( "Threat Tracking OFF", "script ThreatTracker_SetActive( false )" )
	SetupDevCommand( "Overhead Debug ON", "script ThreatTracker_DrawDebugOverheadText( true )" )
	SetupDevCommand( "Overhead Debug OFF", "script ThreatTracker_DrawDebugOverheadText( false )" )
	SetupDevCommand( "Console Debug Level 0", "script ThreatTracker_SetDebugLevel( 0 )" )
	SetupDevCommand( "Console Debug Level 1", "script ThreatTracker_SetDebugLevel( 1 )" )
	SetupDevCommand( "Console Debug Level 2", "script ThreatTracker_SetDebugLevel( 2 )" )
	SetupDevCommand( "Console Debug Level 3", "script ThreatTracker_SetDebugLevel( 3 )" )
}


void function SetDevMenu_HighVisNPCTest( var _ )
{
	ChangeToThisMenu( SetupHighVisNPCTest )
}


void function SetupHighVisNPCTest()
{
	SetupDevCommand( "Spawn at Crosshair", "script PROTO_SpawnHighVisNPCs()" )
	SetupDevCommand( "Delete Test NPCs", "script PROTO_DeleteHighVisNPCs()" )
	SetupDevCommand( "Use R5 Art Settings", "script PROTO_HighVisNPCs_SetTestEnv( \"r5\" )" )
	SetupDevCommand( "Use R2 Art Settings", "script PROTO_HighVisNPCs_SetTestEnv( \"r2\" )" )
}

void function SetDevMenu_Prototypes( var _ )
{
	thread ChangeToThisMenu( SetupPrototypesDevMenu )
}

       
                                            
 
                                               
 
      

void function SetDevMenu_Freelance( var _ )
{
	thread ChangeToThisMenu( SetupFreelanceDevMenu )
}


void function SetupFreelanceDevMenu()
{
	SetupDevCommand( "Spawn MatchCandy", "script DEV_SpawnCandyAtCrosshair()" )
	  
}

void function SetupPrototypesDevMenu()
{
                  
		SetupDevCommand( "Change to Shadow Zombie", "script DEV_GiveShadowZombieAbilities( gp()[0] )" )
       
}


void function RunCodeDevCommandByAlias( string alias )
{
	RunDevCommand( file.codeDevMenuCommands[alias], false )
}


void function SetupDevCommand( string label, string command )
{
	DevCommand cmd
	cmd.label = label
	cmd.command = command

	file.devCommands.append( cmd )
	if ( file.initializingCodeDevMenu )
	{
		string codeDevMenuAlias = file.codeDevMenuPrefix + label
		                                                                                                        
		                                                   
		DevMenu_Alias_DEV( codeDevMenuAlias, command )
	}
}


void function SetupDevFunc( string label, void functionref( var ) func, var opParm = null )
{
	DevCommand cmd
	cmd.label = label
	cmd.func = func
	cmd.opParm = opParm

	file.devCommands.append( cmd )
	if ( file.initializingCodeDevMenu )
	{
		string codeDevMenuAlias   = file.codeDevMenuPrefix + label
		string codeDevMenuCommand = format( "script_ui RunCodeDevCommandByAlias( \"%s\" )", codeDevMenuAlias )
		file.codeDevMenuCommands[codeDevMenuAlias] <- cmd
		DevMenu_Alias_DEV( codeDevMenuAlias, codeDevMenuCommand )
	}
}


void function SetupDevMenu( string label, void functionref( var ) func, var opParm = null )
{
	DevCommand cmd
	cmd.label = (label + "  ->")
	cmd.func = func
	cmd.opParm = opParm
	cmd.isAMenuCommand = true

	file.devCommands.append( cmd )

	if ( file.initializingCodeDevMenu )
	{
		string codeDevMenuPrefix = file.codeDevMenuPrefix
		file.codeDevMenuPrefix += label + "/"
		cmd.func( cmd.opParm )
		file.codeDevMenuPrefix = codeDevMenuPrefix
	}
}


void function OnDevButton_Activate( var button )
{
	if ( level.ui.uiDisableDev )
	{
		Warning( "Dev commands disabled on matchmaking servers." )
		return
	}

	int buttonID   = int( Hud_GetScriptID( button ) )
	DevCommand cmd = file.devCommands[buttonID]

	RunDevCommand( cmd, false )
}


void function OnDevButton_GetFocus( var button )
{
	file.focusedCmdIsAssigned = false

	int buttonID = int( Hud_GetScriptID( button ) )
	if ( buttonID >= file.devCommands.len() )
		return

	if ( file.devCommands[buttonID].isAMenuCommand )
		return

	file.focusedCmd = file.devCommands[buttonID]
	file.focusedCmdIsAssigned = true
}


void function OnDevButton_LoseFocus( var button )
{
}


void function RunDevCommand( DevCommand cmd, bool isARepeat )
{
	if ( !isARepeat )
	{
		if ( file.lastDevCommandLabelInProgress.len() > 0 )
			file.lastDevCommandLabelInProgress += "  "
		file.lastDevCommandLabelInProgress += cmd.label

		if ( !cmd.isAMenuCommand )
		{
			file.lastDevCommand = cmd
			file.lastDevCommandAssigned = true
			file.lastDevCommandLabel = file.lastDevCommandLabelInProgress
		}
	}

	if ( cmd.command != "" )
	{
		ClientCommand( cmd.command )
		if ( IsLobby() )
		{
			CloseAllMenus()
			AdvanceMenu( GetMenu( "LobbyMenu" ) )
		}
		else
		{
			CloseAllMenus()
		}
	}
	else
	{
		cmd.func( cmd.opParm )
	}
}


void function RepeatLastDevCommand( var _ )
{
	if ( !file.lastDevCommandAssigned )
		return

	RunDevCommand( file.lastDevCommand, true )
}


void function RepeatLastCommand_Activate( var button )
{
	RepeatLastDevCommand( null )
}


void function PushPageHistory()
{
	DevMenuPage page = file.currentPage
	if ( page.devMenuFunc != null || page.devMenuFuncWithOpParm != null )
		file.pageHistory.push( clone page )
}


void function BackOnePage_Activate()
{
	if ( file.pageHistory.len() == 0 )
	{
		CloseActiveMenu()
		return
	}

	file.currentPage = file.pageHistory.pop()
	UpdateDevMenuButtons()
}


void function RefreshRepeatLastDevCommandPrompts()
{
	string newText = ""
	                                     
	{
		if ( file.lastDevCommandAssigned )
			newText = file.lastDevCommandLabel                                
		else
			newText = "<none>"
	}

	if ( AreOnDefaultDevCommandMenu() )
		file.lastDevCommandLabelInProgress = ""

	Hud_SetText( file.footerHelpTxtLabel, newText )
}


bool function AreOnDefaultDevCommandMenu()
{
	if ( file.currentPage.devMenuFunc == SetupDefaultDevCommandsMP )
		return true

	return false
}


void function BindCommandToGamepad_Activate( var button )
{
	if ( !BindCommandToGamepad_ShouldShow() )
		return

	           
	{
		string cmdText = "bind back \"script_ui DEV_ExecBoundDevMenuCommand()\""
		ClientCommand( cmdText )
	}

	file.boundCmd.command = file.focusedCmd.command
	file.boundCmd.isAMenuCommand = file.focusedCmd.isAMenuCommand
	file.boundCmd.label = file.focusedCmd.label
	file.boundCmd.func = file.focusedCmd.func
	file.boundCmd.opParm = file.focusedCmd.opParm
	file.boundCmdIsAssigned = true

	            
	{
		string fullName = ""
		if ( file.lastDevCommandLabelInProgress.len() > 0 )
			fullName = file.lastDevCommandLabelInProgress + " -> "
		fullName += file.focusedCmd.label

		string prompt = "Bound to gamepad BACK: " + fullName
		printt( prompt )
		                                                                           
		                          
		EmitUISound( "wpn_pickup_titanweapon_1p" )
	}

	CloseAllMenus()
}


bool function BindCommandToGamepad_ShouldShow()
{
	if ( !file.focusedCmdIsAssigned )
		return false
	if ( file.focusedCmd.command.len() == 0 )
		return false
	return true
}


void function DEV_ExecBoundDevMenuCommand()
{
	if ( !file.boundCmdIsAssigned )
		return

	RunDevCommand( file.boundCmd, true )
}
#endif
