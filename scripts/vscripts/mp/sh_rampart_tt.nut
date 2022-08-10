global function Rampart_TT_Init
global function IsRampartTTPanelLocked
global function GetRampartTTPanelForLoot
global function CheckRampartTTMuralLegends

#if SERVER
                                                    
#endif          

                         
global const string VEND_PANEL = "rampart_tt_vend_panel"
const string VEND_WEAPON_TARGET = "rampart_tt_vend_weapon_target"
const string VEND_SHIELD = "rampart_tt_vend_shield"
const string VEND_BLOCKER_VOLUME = "rampart_tt_vend_blocker"
const string VEND_SHIELD_AMBGENERIC = "rampart_tt_vend_shield_ambGen"
const string VEND_INST_BLUE = "rampart_tt_vend_blue"
const string VEND_INST_PURPLE = "rampart_tt_vend_purple"
const string VEND_INST_GOLD = "rampart_tt_vend_gold"
const string VEND_LOOT_TABLE_BLUE = "rampart_tt_blue_weapons"
const string VEND_LOOT_TABLE_PURPLE = "rampart_tt_purple_weapons"
const string VEND_LOOT_TABLE_GOLD = "rampart_tt_gold_weapons"
global const string VEND_SPAWNED_WEAPON =  "rampart_tt_vend_spawnedWeapon"
const string VEND_SPAWNED_AMMO =  "rampart_tt_vend_spawnedAmmo"
const float DISTANCE_PANEL_TO_LOOT_SQR = 3500
const string ALARM_SFX_POSITION = "rampart_tt_alarm_sfx_pos"
const string ALARM_VFX_POSITION = "rampart_tt_alarm_vfx_pos"
const float VEND_PICKUP_GRACE_PERIOD = 5.0


const string SFX_ALARM = "Loba_Ultimate_Staff_VaultAlarm"
const string SFX_PANEL_DENY = "menu_deny"
const string SFX_PANEL_SUCCESS = "ui_menu_store_purchase_success"
const string SFX_PANEL_LOOP = "survival_titan_linking_loop"
const string SFX_PANEL_SPEAKER = "diag_mp_rampart_tt_vendMachine"
const string SFX_VEND_POWERDOWN = "VendingMachine_Shield_PowerDown"
const string SFX_VEND_SUSTAIN = "VendingMachine_Shield_Sustain"

const asset VFX_SHIELD_DISABLE = $"P_rampart_vendit_shield_disable"
const asset VFX_ALARM_LIGHT = $"P_vault_door_alarm_oly_mu1_sm"
const string VFX_ALARM_LIGHT_NAME = "rampart_tt_vfx_alarm_light"
const asset MODEL_VEND_SHIELD = $"mdl/desertlands/rampart_tt_vendit_01_energyfield_01.rmdl"

             
const string RAMPART_LORE_DATAPAD = "rampart_tt_datapad"
const array <string> SFX_DATAPAD_BANG = [ "diag_mp_bangalore_rtt_a1_1_3p", "diag_mp_bangalore_rtt_a1_2_3p", "diag_mp_bangalore_rtt_a1_3_3p" ]
const array <string> SFX_DATAPAD_BLISK = ["diag_mp_blisk_rtt_a1_1_3p", "diag_mp_blisk_rtt_a1_2_3p" ]
const array <string> SFX_DATAPAD_FRANCIS = [ "diag_mp_francis_rtt_a1_1_3p", "diag_mp_francis_rtt_a1_2_3p" ]
const array <string> SFX_DATAPAD_GIBRALTAR = [ "diag_mp_gibraltar_rtt_a1_1_3p", "diag_mp_gibraltar_rtt_a1_2_3p" ]
const array <string> SFX_DATAPAD_MIRAGE = [ "diag_mp_mirage_rtt_a1_1_3p", "diag_mp_mirage_rtt_a1_2_3p", "diag_mp_mirage_rtt_a1_3_3p" ]
const array <string> SFX_DATAPAD_SEER = [ "diag_mp_seer_rtt_a1_1_3p","diag_mp_seer_rtt_a1_2_3p" ]
const array <string> SFX_DATAPAD_VALK = [ "diag_mp_valkyrie_rtt_a1_1_3p","diag_mp_valkyrie_rtt_a1_2_3p","diag_mp_valkyrie_rtt_a1_3_3p" ]

const string RAMPART_LORE_MENSIGN = "rampart_tt_lore_mensign"
const string RAMPART_LORE_SHOPSIGN = "rampart_tt_lore_shopsign"
const string RAMPART_LORE_PORTRAIT = "rampart_tt_lore_portrait"
const string RAMPART_LORE_SISTER = "rampart_tt_lore_sister"

const string SFX_LORE_MENSIGN = "bc_mirage_rrtReactMSign"
const string SFX_LORE_SHOPSIGN = "bc_rampart_rrtReactSign"
const string SFX_LORE_PORTRAIT = "bc_rampart_rrtReactPortrait"
const string SFX_LORE_SISTER = "bc_rampart_rrtReactSister"

const array <string> RAMPART_TT_S10_MURAL_LEGENDS = [ "character_bloodhound",
													  "character_gibraltar",
													  "character_bangalore",
													  "character_caustic",
													  "character_lifeline",
													  "character_mirage",
													  "character_pathfinder",
													  "character_wraith",
													  "character_octane",
													  "character_wattson",
													  "character_crypto",
													  "character_revenant",
													  "character_loba",
													  "character_rampart",
													  "character_horizon",
													  "character_fuse",
													  "character_valkyrie",
													  "character_seer" ]
struct
{
	entity alarm_sfxPos
	bool alarmActive = false
	float alarmTime
	array < array <string> > datapadDialogue = []

	float vendPickupGracePeriod
}file


                                      
                                      
                                      
                                      
                                      
                                      
                                      
                                      
                                      
                                      
                                      
                                      
                                      
                                      
                                      
void function Rampart_TT_Init()
{
	PrecacheParticleSystem( VFX_SHIELD_DISABLE )
	PrecacheParticleSystem( VFX_ALARM_LIGHT )
	PrecacheModel( MODEL_VEND_SHIELD )

	#if SERVER
	                                              
	                                                        

	                                                                                                                   
	#endif         

	#if CLIENT
	AddCreateCallback( "prop_dynamic", OnPanelCreated )
	AddCreateCallback( "prop_dynamic", OnLoreCreated )
	#endif          
}

                        
#if SERVER
                               
 
	                            
		      

	                     
	                                                            

	                 
	                 

	                           
	                        
	 
		                 
	 
 
#endif         

                                   
#if SERVER
                                  
 
		                      
		                                                                
		                            
			                  

		                 
 
#endif         

                                             
#if SERVER || CLIENT
bool function RampartHasStock()
{
	return GetCurrentPlaylistVarBool( "rampart_tt_stocked", true )
}
#endif                   




                                                                                       
                                                                                       
                                                                                       
                                                                                       
                                                                                       
                                                                                       
                                                                                       
                                                                                       
                                                                                       
                                                                                       
                                                                                       
                                                                                       
                                                                                       
                                                                                       
                                                                                       

#if SERVER
                               
 
	                   
	                                                                 
	 
		                                                                  
		                           
		 
			                  
			                            
		 
		                              
		 
			                                         

			                 
			                                              
			                                                                                                    
			                  
			                                             

			                                                         
			                                                      

			                 
			                                                     
			 
				                                                    
				 
					                       
					 
						                  
						 
							                    
							 
								                                                       
								     
							 

							                      
							 
								                                                         
								     
							 

							                    
							 
								                                                       
								     
							 
						 
					 
				 
				                                                                      
				 
					                       
					 
						                                               
						                         

						                          
						                                                     
						                                                        
						                                           
						                             
						                                                  
						                           
						                             
					 
					    
					 
						                            
					 
				 
			 
		 
	 
 
#endif         

#if CLIENT
void function OnPanelCreated( entity panel )
{
	if ( panel.GetScriptName() != VEND_PANEL )
		return

	AddCallback_OnUseEntity_ClientServer( panel, Vend_OnUse )
	SetCallback_CanUseEntityCallback( panel, Vend_CanUse )
	AddEntityCallback_GetUseEntOverrideText( panel, Vend_UseTextOverride )
}
#endif          

bool function Vend_CanUse( entity player, entity panel, int useFlags)
{
	if ( !SURVIVAL_PlayerCanUse_AnimatedInteraction( player, panel ) )
		return false

	return true
}

#if CLIENT
string function Vend_UseTextOverride( entity panel )
{
	entity player = GetLocalViewPlayer()
	if ( !IsValid (player) )
	{
		return ""
	}

	string str = Localize( "#RAMPART_TT_BUY", Vend_GetCost( panel ) )
	return str
}
#endif         

                      
void function Vend_OnUse( entity panel, entity player, int useInputFlags )
{
	if( Vend_CostCheck( panel, player ) )
	{
		if ( useInputFlags & USE_INPUT_LONG )
		{
			thread Vend_UseThink_Thread( panel, player )
		}
	}
	else
	{
		#if SERVER
		                                                              
		#endif          
	}
}

                   
void function Vend_UseThink_Thread( entity ent, entity playerUser )
{
	ExtendedUseSettings settings
	settings.duration = 0.3

	#if SERVER
	                                              
	#endif         

	#if CLIENT || UI
	settings.icon = $""
	settings.hint = Localize( "#RAMPART_TT_BUYING" )
	settings.displayRui = $"ui/extended_use_hint.rpak"
	settings.displayRuiFunc = Vend_DisplayRui
	settings.loopSound = SFX_PANEL_LOOP
	#endif               

	ent.EndSignal( "OnDestroy" )
	playerUser.EndSignal( "OnDeath" )

	waitthread ExtendedUse( ent, playerUser, settings )
}

            
#if CLIENT || UI
void function Vend_DisplayRui( entity ent, entity player, var rui, ExtendedUseSettings settings )
{
	RuiSetString( rui, "holdButtonHint", settings.holdHint )
	RuiSetString( rui, "hintText", settings.hint )
	RuiSetGameTime( rui, "startTime", Time() )
	RuiSetGameTime( rui, "endTime", Time() + settings.duration )
}
#endif               

         
#if SERVER
                                                                                                  
 
	             
	                                                     
	 
		                                                     
		 
			                                           
			                                                                      
			                                                             
			                                 
			                                     
			                                                                   
			     
		 
	 
 
#endif         


                                                                                                 
#if SERVER
                                                                                    
 
	                                                
	                                                                 
	                                                               

	                                 
	                                                         
	                                                             
	                                     

	                     
	                                                                                                     
	                                              
	                                                        
	                                        
	                                                                    


	                     
	                                                            
	 
		                                                                                                  
		                                          
		                                                      
		                                      
		                                          
	 
 
#endif         

#if SERVER
                                                                     
 
	                  
	                   
	                                               
	                                             
	                                              

	                            

	                                                     
	 
		                                           
		                     
		 
			                 
			 
				          
				                                                      
				                                                     
				                          
				                                                      
				                                       
				                                                     
				                       

				                 
				     
			 
			                         
			 
				                                        
				 
					                                                                     
				 
				                                       
				     
			 
			                       
			 
				                                        
				 
					                                                                     
				 
				                                       
				     
			 
			                            
			 
				                 
				     
			 
		 
	 
 
#endif         

#if SERVER
                                                 
 
	                                                      
	                                                     
	 
		                                                    
		 
			                 
			                                             
		 
	 
 
#endif         


                                               
bool function Vend_CostCheck( entity panel, entity player )
{
	if( Crafting_IsEnabled() && Crafting_GetPlayerCraftingMaterials( player ) >= Vend_GetCost( panel ) )
	{
		return true
	}

	      
	return false
}

                                             
int function Vend_GetCost( entity panel )
{
	string instName = panel.GetInstanceName()
	int value
	switch( instName )
	{
		case VEND_INST_BLUE:
		{
			value = 50
			break
		}
		case VEND_INST_PURPLE:
		{
			value = 75
			break
		}
		case VEND_INST_GOLD:
		{
			value = 100
			break
		}
	}
	return value
}

                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      

                                                    
bool function IsRampartTTPanelLocked ( entity vendPanel )
{
	return GradeFlagsHas( vendPanel, eGradeFlags.IS_LOCKED )
}

                                    
entity function GetRampartTTPanelForLoot( entity lootEnt )
{
	array<entity> linkedEnts = lootEnt.GetLinkParentArray()
	if ( linkedEnts.len() > 0 )
	{
		foreach (entity linkedEnt in linkedEnts)
		{
			if ( linkedEnt.GetScriptName() == VEND_PANEL )
			{
				return linkedEnt
			}
		}
	}

	    
	                                                                                       
	                                                                                      
	                                                                                      
	                               
	   
	vector lootLocation = lootEnt.GetOrigin()

	foreach (entity panel in GetEntArrayByScriptName( VEND_PANEL ))
	{
		foreach ( entity child in panel.GetLinkEntArray() )
		{
			if ( child.GetOrigin() == lootLocation )
				return panel
		}
	}

	return null
}

                              
#if SERVER
                                                                                                 
 
	                                 
	                                                    
		      

	                                                                               
	                                                                                         
		      

	                                   

	                                                           
	                                                              

	                        
		                                            

	                            
	                                                                  
	                                                             
	                                     
	                                                   
	                                         
	                 

	           

	                      
	                        
	 
		                                         

		                                                     
		                                    
		                                         
		                                      
		                                      
		                                               
		                                                  
		                                      
		                                                        
		                                                                
		                                                                   
		                                                                                                                                                                                                                    
	 

	             
	                                               
	                     
	 
		             
		                     
	 
 
#endif         

#if SERVER
                                   
 
	                                                          

	            
	                       

	                           
	                                               
	 
		             
		                                                                                

		                   
		                                                                                
		 
			                  
			                                                                                                                                                                             
			                                               
			                                                 
		 

		        
		                    
		                                                                                 
		 
			                     
		 
		        
	 

	                                              
	                
	                                                               

	                     
	                                                                                 
	 
		                     
	 

	             
	                        
 
#endif         

#if SERVER
                                               
                              
 
	                                                                 
	 
		                                     
		 
			                  
			                 
			                                              
			                                                                                                    
		 
	 
 
#endif         

#if SERVER
                                                
                               
 
	                                                                 
	 
		                                     
		 
			                  
			                   
		 
	 
 
#endif         

                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      
                                                      

#if SERVER
                               
 
	                
	                                                                             
	 
		                         
		                                                            
		                                                           
	 

	                             
	                                               
	                                                
	                                                  
	                                                    
	                                                 
	                                               
	                                               


	                                   
	                                                                             
	 
		                         
		                                                           
		                                                        
	 

	                              
	                                                                               
	 
		                          
		                                                            
		                                                         
	 

	                                   
	                                                                           
	 
		                        
		                                                          
		                                                       
	 
	                               
	                                                                               
	 
		                          
		                                                            
		                                                         
	 

 
#endif         

#if SERVER
                                              
 
	                   
	                                                
	                                                                                                      
	                                                                               
	                                                      
	                                       
 
#endif         

bool function DataPad_CanUse( entity player, entity datapad, int useFlags)
{
	if ( !SURVIVAL_PlayerCanUse_AnimatedInteraction( player, datapad ) )
		return false

	return true
}

#if SERVER
                                                                               
 
	                     
	                                         
 
#endif         

#if SERVER
                                                       
 
	            
	                                  
	 
		                                                              
	 
	    
	 
		            
	 

	                                                  
	 
		                                                   
		             
	 
	      

	                                             
	                                           
	                                    
	 
		                         
	 
 
#endif         

                                        
#if CLIENT
void function OnLoreCreated( entity loreEnt )
{
	switch( loreEnt.GetScriptName() )
	{
		case RAMPART_LORE_MENSIGN:
		{
			AddEntityCallback_GetUseEntOverrideText( loreEnt, MirageOnly_UseTextOverride )
			break
		}
		case RAMPART_LORE_PORTRAIT:
		{
			AddEntityCallback_GetUseEntOverrideText( loreEnt, RampartOnly_UseTextOverride )
			break
		}
		case RAMPART_LORE_SISTER:
		{
			AddEntityCallback_GetUseEntOverrideText( loreEnt, RampartOnly_UseTextOverride )
			break
		}
		case RAMPART_LORE_SHOPSIGN:
		{
			AddEntityCallback_GetUseEntOverrideText( loreEnt, RampartOnly_UseTextOverride )
			break
		}
		default:
		{
			return
		}
	}
}
#endif          

#if SERVER
                                          
 
	               
	                                            
	                                                                                                  
	                                                  
	                                   
 
#endif         

#if SERVER
                                                
 
	                            

	       
	                     
 
#endif         

bool function Lore_CanUse( entity player, entity loreEnt, int useFlags)
{
	if ( !SURVIVAL_PlayerCanUse_AnimatedInteraction( player, loreEnt ) )
		return false

	return true
}

#if CLIENT
string function MirageOnly_UseTextOverride( entity loreEnt )
{
	entity player = GetLocalViewPlayer()
	if ( !IsValid (player) )
	{
		return ""
	}

	ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_Character() )
	string characterRef  = ItemFlavor_GetHumanReadableRef( character ).tolower()
	if ( characterRef != "character_mirage" )
	{
		return "#RAMPART_TT_REQ_MIRAGE"
	}

	return "#RAMPART_TT_LORE_INTERACT"
}
#endif         

#if CLIENT
string function RampartOnly_UseTextOverride( entity loreEnt )
{
	entity player = GetLocalViewPlayer()
	if ( !IsValid (player) )
	{
		return ""
	}

	ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_Character() )
	string characterRef  = ItemFlavor_GetHumanReadableRef( character ).tolower()
	if ( characterRef != "character_rampart" )
	{
		return "#RAMPART_TT_REQ_RAMPART"
	}

	return "#RAMPART_TT_LORE_INTERACT"
}
#endif         

#if SERVER
                                                                                
 
	                                                                                            
	                                                                            
	                   

	                                          
	 
		                                  
		 
			                           
			 
				                                
				     
			 
			                           
			 
				                                
				     
			 
			                         
			 
				                              
				     
			 
			        
			 
				      
			 
		 
	 
	                                                                                                 
	 
		                               
	 
	    
	 
		      
	 

	              
	                     
	                                      
	                                                                        
 
#endif         

#if SERVER
                                                           
 
	                                                                                                                                                            
	                                      

	                
 
#endif         

bool function CheckRampartTTMuralLegends( entity player )
{
	                                                
	ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_Character() )
	string playerChar  = ItemFlavor_GetHumanReadableRef( character ).tolower()
	foreach ( validChar in RAMPART_TT_S10_MURAL_LEGENDS )
	{
		if( validChar == playerChar )
		{
			return true
		}
	}

	      
	return false
}