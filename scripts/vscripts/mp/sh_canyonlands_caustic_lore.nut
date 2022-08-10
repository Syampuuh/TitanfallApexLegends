#if SERVER
                                           
#endif

#if CLIENT
global function ClCanyonLandsCausticLore_Init
#endif


const string PANEL_DENY_SFX = "Caustic_TT_Screen_Deny"

const string LAB_DOOR_SCRIPTNAME = "CausticLabDoor"
const string LAB_ACCESS_PANEL_SCRIPTNAME = "CausticLabAccess"

struct
{
	array< entity > labDoors
	array< entity > labAccessPanels
} file


#if SERVER
                                           
 
	                                                         
	                                               
 
#endif


#if CLIENT
void function ClCanyonLandsCausticLore_Init()
{
	AddCreateCallback( "prop_dynamic", LabAccessPanelSpawned )
	AddCreateCallback( "prop_door", LabDoorSpawned )
}
#endif


void function LabAccessPanelSpawned( entity panel )
{
	if ( !IsValidLabAccessPanelEnt( panel ) )
		return

	file.labAccessPanels.append( panel )

	#if SERVER
		                  
	#endif         

	SetLabAccessPanelUsable( panel )
}

void function SetLabAccessPanelUsable ( entity panel )
{
	#if SERVER
		                 
		                                 
		                                           
		                                                                  
	#endif         

	#if CLIENT
		AddCallback_OnUseEntity_ClientServer( panel, OnLabAccessPanelUse )
		AddEntityCallback_GetUseEntOverrideText( panel, OnLabAccessTextOverride )
	#endif         
}

void function OnLabAccessPanelUse( entity panel, entity playerUser, int useInputFlags )
{
	ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( playerUser ), Loadout_Character() )
	string characterRef  = ItemFlavor_GetHumanReadableRef( character ).tolower()
	if ( characterRef != "character_caustic" && characterRef != "character_wattson" )
	{
		#if CLIENT
			EmitSoundOnEntity( panel, PANEL_DENY_SFX )
		#endif
		return
	}


	#if CLIENT
		EmitSoundOnEntity( panel, "lootVault_Access" )
	#endif

	#if SERVER
	                                               
	 
		                         
		                        
	 

	                                 
	 
		                            
	 
	#endif
}

#if CLIENT
string function OnLabAccessTextOverride( entity ent )
{
	entity player = GetLocalViewPlayer()
	if ( !IsValid (player) )
	{
		return ""
	}

	ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_Character() )
	string characterRef  = ItemFlavor_GetHumanReadableRef( character ).tolower()
	if ( characterRef != "character_caustic" && characterRef != "character_wattson" )
	{
		return "#CAUSTIC_LAB_ACCESS_REQUIREMENT"
	}

	return "#CAUSTIC_LAB_ACCESS_USE"
}
#endif

bool function IsValidLabAccessPanelEnt ( entity ent )
{
	if ( ent.GetScriptName() == LAB_ACCESS_PANEL_SCRIPTNAME )
		return true

	return false
}

void function LabDoorSpawned( entity door )
{
	if ( !IsValidLabDoorEnt( door ) )
		return

	#if SERVER
		                 
		                  
		                                   
		                      
		                            
		                
	#endif         

	file.labDoors.append( door )
}

bool function IsValidLabDoorEnt( entity ent )
{
	if ( !IsDoor( ent ) )
		return false

	string scriptName = ent.GetScriptName()
	if ( scriptName != LAB_DOOR_SCRIPTNAME )
		return false

	return true
}