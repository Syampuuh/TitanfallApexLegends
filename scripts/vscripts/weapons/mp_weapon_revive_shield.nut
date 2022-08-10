                 
global function MpWeaponReviveShield_Init

global function OnWeaponOwnerChanged_revive_shield
global function OnWeaponPrimaryAttack_revive_shield
global function OnWeaponPrimaryAttackAnimEvent_revive_shield
global function OnWeaponActivate_revive_shield
global function OnWeaponDeactivate_revive_shield

global function ReviveShield_GetMaxShieldHealthFromTier
global function IsEntNewcastleReviver
global function IsEntNewcastleReviveTarget

#if SERVER
                                          
                                                   
                                                        
                                             
                                                     
#endif
#if CLIENT
global function PassiveAxiom_BeginClientReviveShield_RUI

global function PassiveAxiom_ActivateKDShieldHUDMeter
global function PassiveAxiom_DeActivateKDShieldHUDMeter

global function ServerToClient_DisplayCancelNewcastleReviveHintForPlayer
global function ServerToClient_RemoveCancelNewcastleReviveHintForPlayer
#endif              

                                   
const bool REVIVE_SHIELD_DEBUG = false
const bool REVIVE_SHIELD_GIVES_KD_BONUS = true

const REVIVE_SHIELD_FX_WALL_FP 							= $"P_NC_down_shield_CP"
const REVIVE_SHIELD_FX_WALL 							= $"P_NC_down_shield_CP"
const REVIVE_SHIELD_FX_COL 								= $"mdl/fx/down_shield_NC.rmdl"
const REVIVE_SHIELD_FX_BREAK 							= $"P_NC_down_shield_break_CP"
const REVIVE_SHIELD_FX_ARM_BEAM							= $"P_NC_down_shield_arm_glow"

const string REVIVE_SHIELD_IMPACT_FX_TABLE 				= "newcastle_revive_jetwash"

const bool REVIVE_SHIELD_IS_FASTER_THAN_CROUCH			= true
const float REVIVE_SHIELD_MOVE_SLOW_SEVERITY 			= 0.05	                                                                                        
const float REVIVE_SHIELD_TURN_SLOW_SEVERITY 			= 0.3 	     
const float REVIVE_SHIELD_SPEED_BOOST_SEVERITY			= 0.25	  
const float REVIVE_TARGET_USE_DEBOUNCE 					= 0.3
const float AUTO_REVIVE_MAX_ALLOWED_DIST_FROM_GROUND 	= 200.0

const string KNOCKDOWN_SHIELD_BASIC 					= "incapshield_pickup_lv0"
const int BLEEDOUT_DISABLED_WEAPON_TYPES 				= WPT_ALL_EXCEPT_VIEWHANDS & ~WPT_INCAP_SHIELD

               
const int REVIVE_SHIELD_MAX_SHIELD_HEALTH_TIER_1 		= 200            
const int REVIVE_SHIELD_MAX_SHIELD_HEALTH_TIER_2 		= 300            
const int REVIVE_SHIELD_MAX_SHIELD_HEALTH_TIER_3 		= 500      

const string NEWCASTLE_REVIVE_SHIELD_HEALTH_NETVAR 		= "newcastleReviveShieldHP"

                        
const float SHIELD_REGEN_RATE_PER_SECOND 				= 8.5 				                                              

const string RECHARGING_START_SOUND 					= "CampFire_Healing_Start_1P"
const string RECHARGING_SHIELDS_SOUND 					= "CampFire_Healing_Loop_1P"
const string RECHARGING_COMPLETE_SOUND 					= "CampFire_Healing_End_1P"

const string RECHARGING_START_SOUND_3P 					= "CampFire_Healing_Start_3P"
const string RECHARGING_SHIELDS_SOUND_3P 				= "CampFire_Healing_Loop_3P"
const string RECHARGING_COMPLETE_SOUND_3P 				= "CampFire_Healing_End_3P"

const string SOUND_REVIVE_BASE_3P 						= "Newcastle_ReviveShield_OgRevive_3p"
const string SOUND_REVIVE_SHIELD_3P 					= "Newcastle_ReviveShield_Sustain_3p"
const string SOUND_REVIVE_SHIELD_1P 					= "Newcastle_ReviveShield_Sustain_1p"

const string SOUND_PILOT_INCAP_SHIELD_END_3P 			= "BleedOut_Shield_Break_3P"
const string SOUND_PILOT_INCAP_SHIELD_END_1P 			= "BleedOut_Shield_Break_1P"

const string REVIVE_SHIELD_SIGNAL_BEGIN_CHARGE			= "ReviveShieldBeginCharge"                           
const string REVIVE_SHIELD_SIGNAL_END_CHARGE			= "OnPassiveAxiom_ReviveShieldEnd"
const string REVIVE_SHIELD_SIGNAL_HP_TRACKING_COMPLETE 	= "ReviveShieldHPTrackingComplete"
const string REVIVE_SHIELD_SIGNAL_ON_DAMAGED			= "ReviveShield_OnDamaged"
const string REVIVE_SHIELD_SIGNAL_END_HUD_METER			= "ReviveShield_EndHUDMeter"
const string REVIVE_SHIELD_SIGNAL_AUTO_REVIVE_END		= "OnPassiveAxiom_AutoReviveEnd"

struct
{
	bool isReviveWithKDShieldValue = REVIVE_SHIELD_GIVES_KD_BONUS

	int reviveShield_HP_LV1			= REVIVE_SHIELD_MAX_SHIELD_HEALTH_TIER_1
	int reviveShield_HP_LV2			= REVIVE_SHIELD_MAX_SHIELD_HEALTH_TIER_2
	int reviveShield_HP_LV3			= REVIVE_SHIELD_MAX_SHIELD_HEALTH_TIER_3
	float reviveShield_RegenRate	= SHIELD_REGEN_RATE_PER_SECOND
	float reviveShield_MoveSlow		= REVIVE_SHIELD_MOVE_SLOW_SEVERITY
	float reviveShield_TurnSlow		= REVIVE_SHIELD_TURN_SLOW_SEVERITY
	float reviveShield_SpeedBoost	= REVIVE_SHIELD_SPEED_BOOST_SEVERITY

	bool isFasterThanCrouchSpeed	= REVIVE_SHIELD_IS_FASTER_THAN_CROUCH

	array<entity> reviveShieldEnts
	table<entity, bool> hasReviveShield = {}
	table<entity, string> reviveShieldRef = {}
	table<entity, bool> isReviveShieldRegen = {}
	table<entity, bool> isReviveIntro = {}
	table<entity, bool> isReviveHPTracking = {}

	#if SERVER
	                                       
	#endif

} file


void function MpWeaponReviveShield_Init()
{
	PrecacheWeapon( "mp_weapon_revive_shield" )

	                          
	file.isReviveWithKDShieldValue 	= GetCurrentPlaylistVarBool( "axiom_revive_shield_vKDValue", REVIVE_SHIELD_GIVES_KD_BONUS )

	               
	file.reviveShield_HP_LV1			= GetCurrentPlaylistVarInt( "newcastle_revive_shield_HP_lv1", REVIVE_SHIELD_MAX_SHIELD_HEALTH_TIER_1 )
	file.reviveShield_HP_LV2			= GetCurrentPlaylistVarInt( "newcastle_revive_shield_HP_lv2", REVIVE_SHIELD_MAX_SHIELD_HEALTH_TIER_2 )
	file.reviveShield_HP_LV3			= GetCurrentPlaylistVarInt( "newcastle_revive_shield_HP_lv3", REVIVE_SHIELD_MAX_SHIELD_HEALTH_TIER_3 )
	file.reviveShield_RegenRate			= GetCurrentPlaylistVarFloat( "newcastle_revive_shield_regen_rate", SHIELD_REGEN_RATE_PER_SECOND )
	file.reviveShield_MoveSlow			= GetCurrentPlaylistVarFloat( "newcastle_revive_shield_move_slow_severity", REVIVE_SHIELD_MOVE_SLOW_SEVERITY )
	file.reviveShield_TurnSlow			= GetCurrentPlaylistVarFloat( "newcastle_revive_shield_turn_slow_severity", REVIVE_SHIELD_TURN_SLOW_SEVERITY )
	file.reviveShield_SpeedBoost		= GetCurrentPlaylistVarFloat( "newcastle_revive_shield_speed_boost_severity", REVIVE_SHIELD_SPEED_BOOST_SEVERITY )
	file.isFasterThanCrouchSpeed		= GetCurrentPlaylistVarBool( "newcastle_revive_shield_isFasterThanCrouchSpeed", REVIVE_SHIELD_IS_FASTER_THAN_CROUCH )

	PrecacheModel( REVIVE_SHIELD_FX_COL )

	PrecacheParticleSystem( REVIVE_SHIELD_FX_WALL_FP )
	PrecacheParticleSystem( REVIVE_SHIELD_FX_WALL )
	PrecacheParticleSystem( REVIVE_SHIELD_FX_BREAK )
	PrecacheParticleSystem( REVIVE_SHIELD_FX_ARM_BEAM )

	PrecacheImpactEffectTable( REVIVE_SHIELD_IMPACT_FX_TABLE )

	RegisterSignal( REVIVE_SHIELD_SIGNAL_BEGIN_CHARGE )
	RegisterSignal( REVIVE_SHIELD_SIGNAL_END_CHARGE )
	RegisterSignal( REVIVE_SHIELD_SIGNAL_HP_TRACKING_COMPLETE )
	RegisterSignal( REVIVE_SHIELD_SIGNAL_ON_DAMAGED )
	RegisterSignal( REVIVE_SHIELD_SIGNAL_END_HUD_METER )
	RegisterSignal( REVIVE_SHIELD_SIGNAL_AUTO_REVIVE_END )

	Remote_RegisterClientFunction( "PassiveAxiom_BeginClientReviveShield_RUI", "entity" )
	Remote_RegisterClientFunction( "PassiveAxiom_ActivateKDShieldHUDMeter", "entity" )
	Remote_RegisterClientFunction( "PassiveAxiom_DeActivateKDShieldHUDMeter", "entity" )

	AddCallback_OnPassiveChanged( ePassives.PAS_AXIOM, OnPassiveChanged )

	RegisterNetworkedVariable( NEWCASTLE_REVIVE_SHIELD_HEALTH_NETVAR, SNDC_PLAYER_EXCLUSIVE, SNVT_INT, -1 )

	Remote_RegisterServerFunction( "ClientCallback_Cancel_NewcastleRevive" )
	Remote_RegisterClientFunction( "ServerToClient_DisplayCancelNewcastleReviveHintForPlayer" )
	Remote_RegisterClientFunction( "ServerToClient_RemoveCancelNewcastleReviveHintForPlayer" )

	#if SERVER
		                                                                      
		                                                                                        
		                                                                           
	#endif

	#if CLIENT
		RegisterConCommandTriggeredCallback( "+toggle_duck", AttemptCancel_NewcastleRevive_Console )                                                
		RegisterConCommandTriggeredCallback( "+use", AttemptCancel_NewcastleRevive_PC )                
	#endif

	#if CLIENT || UI
		AddCallback_EditLootDesc( Axiom_EditKnockdownLootDesc )
	#endif

}

     
int function ReviveShield_GetMaxShieldHealthFromTier( int tier )
{
	int maxShieldHealth = IncapShield_GetMaxShieldHealthFromTier( tier )
	switch( tier )
	{
		case 0:

			return 0
		case 2:
			return file.reviveShield_HP_LV2
		case 3:
			return file.reviveShield_HP_LV3
		case 4:
			return file.reviveShield_HP_LV3
		default:
			return file.reviveShield_HP_LV1
	}

	unreachable
}


    


                         
#if SERVER || CLIENT
void function OnPassiveChanged( entity player, int passive, bool didHave, bool nowHas )
{
	if ( didHave == nowHas )
		return

#if SERVER
	              
		                                                           

	             
		                                                            
#endif

	#if CLIENT
		if( didHave )
			Signal( player, REVIVE_SHIELD_SIGNAL_END_HUD_METER )
	#endif
}
#endif



#if CLIENT || UI
string function Axiom_EditKnockdownLootDesc( string lootRef, entity player, string originalDesc )
{
	string finalDesc = originalDesc
	#if CLIENT
		                                                                          
		if (Crafting_IsPlayerAtWorkbench(player))
			return finalDesc
	#endif

	if ( SURVIVAL_Loot_GetLootDataByRef( lootRef ).lootType == eLootType.INCAPSHIELD
			&& IsValid( player )
			&& LoadoutSlot_IsReady( ToEHI( player ), Loadout_Character() )
			&& ItemFlavor_GetAsset( LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_Character() ) ) == $"settings/itemflav/character/newcastle.rpak" )
	{

		string desc = ""
		switch( lootRef )
		{
			case "incapshield_pickup_lv1":
				desc = Localize( "#SURVIVAL_PICKUP_INCAPSHIELD_LV1_HINT_NEWCASTLE" )
				break
			case "incapshield_pickup_lv2":
				desc = Localize( "#SURVIVAL_PICKUP_INCAPSHIELD_LV2_HINT_NEWCASTLE" )
				break
			case "incapshield_pickup_lv3":
				desc = Localize( "#SURVIVAL_PICKUP_INCAPSHIELD_LV3_HINT_NEWCASTLE" )
				break
			case "incapshield_pickup_lv4_selfrevive":
				desc = Localize( "#SURVIVAL_PICKUP_INCAPSHIELD_LV4_HINT_NEWCASTLE" )
				break
			default:
				desc = Localize( "#SURVIVAL_PICKUP_INCAPSHIELD_LV1_HINT_NEWCASTLE" )
				break
		}
		return desc
	}
	return finalDesc
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

#if SERVER
                                                                                                       
 
	                               
	                                 
	                                             
	                                                          
	                              
	                                

	             
	 
		                           
		 
			                                   
			                                                  
			                                                                                                                                                                     
			                                                                     
			                                  
			 
				                                  
				                                             
				                                                       
			 
		 

		           
	 
 
#endif

#if SERVER
                                                                              
 
	                                                      
	 
		                                                                     

		                               
			      

		                                    
		 
			                                           

			                                                                                                          
			                                      
				                                

			                                      
		 
		    
		 
			                                                                                                        
			                                                                                                          

			                                                                          

			                                                                     

			                                                                       
		 

		                                    
			                                                                                             
	 

 
#endif

#if SERVER
                                                                                     
 
	                               
	                                                   

	                                                                                                                                              
	                                                             

	            
		                                
		 
			                                               
				                                                  

			                       
				                                                                                        

			                        
				                                                                                               

			                                  
				                                   
		 
	 
	             

 
#endif

#if SERVER
                                                                                    
 
	                                   
	                                               
	                                
	                                                    

	                                                    
	                                
	                                

	            
		                                                 
		 
			                                                                                              
			                                                                                 
			                                                                     
		 
	 

	              
	 
		                                                                                        
		                                       
		                                              

		           
	 
 
#endif

var function OnWeaponPrimaryAttack_revive_shield( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return 0
}

var function OnWeaponPrimaryAttackAnimEvent_revive_shield( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return 0
}

void function OnWeaponOwnerChanged_revive_shield( entity weapon, WeaponOwnerChangedParams changeParams )
{
	#if SERVER
		                                         
		                          
			                                                                                                       
		    
			                
	#endif              
}

void function OnWeaponActivate_revive_shield( entity weapon )
{
	entity weaponOwner = weapon.GetWeaponOwner()
                            
                      
            
                        
        
    
                                
                                                                
    
       

	#if SERVER
		                                                     
		                              
		 
			                                      
			                      
			                                     
		 

		                              
			      

		                                                           
		 
			                                                
				                                                                 

			                                              
			 
				                                                                                            
			 
			    
			 
				                                                                                            
			 
		 

		                                                                                                                    
		                           
		 
			                          
				                                                                   

			      
		 

		                                         
		                        
		 
			                          
				                                                                    

			      
		 

		                    
		                    
		               			       
		            			                 
		                      	                                                   
		              			        
		        				             
		            			             
		                   		                 
		        				                      
		            			      
		                      	           

		                                                           

		                                                               
		                                   

		                          
			                                                                           

		                                                     

		                                          
		                                                                             
	#endif              
}

void function OnWeaponDeactivate_revive_shield( entity weapon )
{
	weapon.Signal( REVIVE_SHIELD_SIGNAL_END_CHARGE )

	#if SERVER
		                                                     
		                              
		 
			                      
			                                     
		 
	#endif              
}

#if SERVER
                                                                                 
 
	          			                                           
	               		                                      
	                   	                                            

	                  
		      

	                          
	 
		                                                                
			      

		                          
			                                                                                                                           
	 

	                                                           

	                          
		                                                                                         

	                                

	                     
		                                      

	                                       
	                                    

	                                             
	 
		                                 
		                                                                          

		                                                 

		                                               
		                     
		 
			                                                           

			         			                                                  
			             		                                            
			                   	                                         
			                   	                                         

			                                                                                           
			                                                                                                               

			                                                                                  
			                                                                                
		 
	 
 

                                                                       
 
	                
	                
	                                                

	                                                  
	                            
	 
		                          
			                                                         

		      
	 

	                                              
	                                                  
	                                                     
	                                                   

	                               
	                               
	                             
	                                            
	                                  

	                                                       
	                                                
	                                 
		           

	                          
		                                                         

	                                                                        

	            
	                                                    

	                                                 
	 
		        
	 

	                        
	                    
	        				        
	           				                       
	                     	       
	                     	      
	                  		                                            
	                   		              
	                  		                                           
	                                                              

	                                                
	 
		                                                     
	 

	      
	                                                                       
	                                                                         

	             
	         			                                                     
	             		                                        
	                   	                                         
	                   	                                         

	                                                                                                                  
	                                                                                                    

	                                                                                                                                             
	                                                                                                                 
	                                                                                                                                                  
	                                                                                                                  


	            
		                                                      
		 
			                          
				                                                         

			                           
			 
				                                                     

				                                                
					                   

				                                   
			 

			                        
			 
				                                                   
				                                                   

			 

			                         
			 
				                      
				                  
			 

		 
	 

	                   		                                     
	                   		                                               
	               			   
	                		              
	                                                 

	                	        
	                 	     

	              
	 
		                                            
		                                             
		                                  
			                                                                    
				                                   

		                                                            

		            		                                               
		                                                

		                                                   
		 
			                                                                        
			             
			                        
		 

		           
	 
 

#endif              


                                     
                                     
                                     

#if SERVER
                                                                                                                                                                                            
 
	                    
	                                                         
		        

	                       
		        

	                                                                              

	                   
 
#endif

#if SERVER
                                                                          
 
	                                                           
	                                                              
	                              
	                                

	                                                         
		      

	                         
		      

	                                       

	                                             
		                                         

	                                                                                 
	                                                                            

	                                                                      
	                        
	 
		                         
			      

		                                     
			                                     

		                                                                                          

		                                                               
		                     
		 
			     
		 

		           
	 

	                                                                             

	                                                                        
	                                         
	 
		                                        
		                                                                                        
	 

	                                         
	 
		                                      
		                         
		 
			                                                                                                                           
		 

	 

	            
		                       
		 
			                       
			 
				                                                 
				                                       
					                                      
			 

			                                     
				                                   

			                                    
			 
				                                                                                 
				                                                                            

				                                                                      
				                     
				 
					                                     
				 
			 

			                                        
				                                       

		 
	 

	                                     	     

	                       		                                    
	               				          
	                    		                                                            

	              
	 
		                                    
		 
			                    
			                                                               

			                                          
			                         
			 
				                      	                                                 
				 
					     
				 
				                                                                                   
				 
					                  
					                                                                         
					                         
						                                                                            
				 
			 

			                                    
			 
				                                                                                  
				                                     	                  
				 
					                              
					                                                      

					                                        
						                                          
				 
				                                                    
				 
					                                                                              
					                                                                                                                               

					            
					 
						                                                      
						                                        
							                                          
					 

					                    
					                                        
						                                            

					                                                      
					 
						                              
						                                                                       
						                                        
							                                         
					 

				 

			 
		 
		    
			     

		           
	 
 
#endif         

#if SERVER
                                                                                   
 
	                                
	                              
	                                            
	                                                                                                                     


	            
		                       
		 
			                                        
				                                          
		 
	 

	                                                                                                            

	                            
		      

	                                         
		      

	                                             

	                        
	                      

	                                                                                              

	            
		                        
		 
		 
	 

	                                  
	 
		                                      
		                  
		                                           

		                                         
			      

		                                                                                                                       
			      

		                                         
		                                              
		                                 
			                           

		                                                                                                    
		                                                                                                                                     

		                       
			                                                                                

		           
	 

	                                                                                 
	                                                                            

 
#endif         


                              
                              
                              


#if CLIENT
void function PassiveAxiom_ActivateKDShieldHUDMeter( entity player )
{
	if ( player != GetLocalClientPlayer() )
		return

	thread CL_PassiveAxiom_KDShieldChargeRUI_Thread( player )
}

void function PassiveAxiom_DeActivateKDShieldHUDMeter( entity player )
{
	if ( player != GetLocalClientPlayer() )
		return

	Signal( player, REVIVE_SHIELD_SIGNAL_END_HUD_METER )
}
#endif         

#if CLIENT
void function CL_PassiveAxiom_KDShieldChargeRUI_Thread( entity player )
{
	EndSignal( player, REVIVE_SHIELD_SIGNAL_END_HUD_METER )
	EndSignal( player, "OnDeath" )
	EndSignal( player, "OnDestroy" )

	if ( !IsValid( GetLocalClientPlayer() ) )
		return

	array<var> ruis
	var rui = CreateCockpitRui( $"ui/passive_kd_shield_charge.rpak", HUD_Z_BASE )

	ruis.append( rui )

	OnThreadEnd(
		function() : ( ruis )
		{
			foreach ( rui in ruis )
				RuiDestroyIfAlive( rui )
		}
	)

	float shieldHealth = player.GetPlayerNetInt( NEWCASTLE_REVIVE_SHIELD_HEALTH_NETVAR ).tofloat()
	float maxShieldHealth = 0.0
	int incapShieldTier = EquipmentSlot_GetEquipmentTier( player, "incapshield" )
	if( incapShieldTier > 0 )
	{
		LootData lootData = EquipmentSlot_GetEquippedLootDataForSlot( player, "incapshield" )

		maxShieldHealth = float( ReviveShield_GetMaxShieldHealthFromTier( incapShieldTier ) )
		RuiSetInt( rui, "shieldTier", incapShieldTier )
	}

	RuiSetFloat( rui, "shieldHealth", shieldHealth )
	RuiSetFloat( rui, "maxShieldHealth", maxShieldHealth )

	RuiTrackFloat( rui, "bleedoutEndTime", player, RUI_TRACK_SCRIPT_NETWORK_VAR, GetNetworkedVariableIndex( "bleedoutEndTime" ) )
	RuiTrackFloat( rui, "reviveEndTime", player, RUI_TRACK_SCRIPT_NETWORK_VAR, GetNetworkedVariableIndex( "reviveEndTime" ) )

	while ( IsValid( rui ) )
	{
		shieldHealth = player.GetPlayerNetInt( NEWCASTLE_REVIVE_SHIELD_HEALTH_NETVAR ).tofloat()

		RuiSetFloat( rui, "shieldHealth", shieldHealth )
		RuiSetFloat( rui, "maxShieldHealth", maxShieldHealth )
		incapShieldTier = EquipmentSlot_GetEquipmentTier( player, "incapshield" )
		if( incapShieldTier > 0 )
		{
			maxShieldHealth = float( ReviveShield_GetMaxShieldHealthFromTier( incapShieldTier ) )
			RuiSetInt( rui, "shieldTier", incapShieldTier )
		}

		bool isWeaponInspect = false
		entity viewWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
		if( IsValid( viewWeapon ) )
		{
			if ( viewWeapon.GetWeaponActivity() == ACT_VM_WEAPON_INSPECT )
				isWeaponInspect = true
		}

		RuiSetBool( rui, "weaponInspect", isWeaponInspect )
		WaitFrame()
	}
}
#endif         


#if CLIENT
void function PassiveAxiom_BeginClientReviveShield_RUI( entity reviver )
{
	if ( reviver != GetLocalClientPlayer() )
		return

	entity weapon = reviver.GetActiveWeapon( eActiveInventorySlot.mainHand  )

	LootData basicShield = SURVIVAL_Loot_GetLootDataByRef( "incapshield_pickup_lv0" )
	string equipSlot = GetLootTypeData( basicShield.lootType ).equipmentSlot

	string equipRef = EquipmentSlot_GetLootRefForSlot( reviver, equipSlot )
	if ( equipRef == "" )
		return

	thread CL_PassiveAxiom_KDShieldReviveChargeRUI_Thread( reviver, weapon )
}
#endif             


#if CLIENT
void function CL_PassiveAxiom_KDShieldReviveChargeRUI_Thread( entity player, entity weapon )
{
	EndSignal( player, REVIVE_SHIELD_SIGNAL_END_HUD_METER )
	EndSignal( player, REVIVE_SHIELD_SIGNAL_AUTO_REVIVE_END )
	weapon.EndSignal( "OnDestroy" )
	weapon.EndSignal( REVIVE_SHIELD_SIGNAL_END_CHARGE )

	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "Bleedout_OnRevive" )

	if ( !IsValid( GetLocalClientPlayer() ) )
		return

	array<var> ruis
	var rui = CreateCockpitPostFXRui( $"ui/passive_revive_shield_charge.rpak", HUD_Z_BASE )

	ruis.append( rui )

	OnThreadEnd(
		function() : ( ruis )
		{
			foreach ( rui in ruis )
				RuiDestroyIfAlive( rui )
		}
	)

	float maxShieldHealth = 0.0
	int incapShieldTier = EquipmentSlot_GetEquipmentTier( player, "incapshield" )
	if( incapShieldTier > 0 )
	{
		LootData lootData = EquipmentSlot_GetEquippedLootDataForSlot( player, "incapshield" )

		maxShieldHealth = float( ReviveShield_GetMaxShieldHealthFromTier( incapShieldTier ) )
		RuiSetInt( rui, "shieldTier", incapShieldTier )
	}

	float shieldHealth = player.GetPlayerNetInt( NEWCASTLE_REVIVE_SHIELD_HEALTH_NETVAR ).tofloat()

	RuiSetFloat( rui, "shieldHealth", shieldHealth )
	RuiSetFloat( rui, "maxShieldHealth", maxShieldHealth )

	RuiTrackFloat( rui, "bleedoutEndTime", player, RUI_TRACK_SCRIPT_NETWORK_VAR, GetNetworkedVariableIndex( "bleedoutEndTime" ) )
	RuiTrackFloat( rui, "reviveEndTime", player, RUI_TRACK_SCRIPT_NETWORK_VAR, GetNetworkedVariableIndex( "reviveEndTime" ) )

	while ( IsValid( rui ) )
	{
		shieldHealth = player.GetPlayerNetInt( NEWCASTLE_REVIVE_SHIELD_HEALTH_NETVAR ).tofloat()

		RuiSetFloat( rui, "shieldHealth", shieldHealth )
		RuiSetFloat( rui, "maxShieldHealth", maxShieldHealth )
		incapShieldTier = EquipmentSlot_GetEquipmentTier( player, "incapshield" )
		if( incapShieldTier > 0 )
		{
			maxShieldHealth = float( ReviveShield_GetMaxShieldHealthFromTier( incapShieldTier ) )
			RuiSetInt( rui, "shieldTier", incapShieldTier )
		}

		bool isVisible = true
		if ( AreAbilitiesSilenced( player ) )
			isVisible = false

		RuiSetBool( rui, "isVisible", isVisible )

		WaitFrame()
	}
}
#endif         


#if SERVER
                                                                            
 
	                                               
		      

	                                                               
 

                                                                                    
 
	                                             
	                              
	                                     
	                                            
	                                            
	                                               
	                                

	                           
	                               
	                                           

	                                                                                                                
	                                                                                                                                                                                            

	                      
	                          
	                       
	                       

	                                                                       
	                                                                                       
	                                   

	                       
	                                                           
	                 	                         
	              		                            
	                             
	 
		             	                            
		        		                              
	 

	                  	 		                                                                                         
	                        	                                                             

	                                                    
	                                                                               
	                                                                        

	                                                                    
	                    
	 
		                                                     
			                                
			                                
			                                 
		 

		                         
		 
			                                            
			 
				                     
				     
			 
		 
	 

	                                                                 
	                                                               
		                                                                          

	                                                                      
	                                                                                     

	                                                                                       

	                      

	                                                                  
	 
		                                                      
		                                 
		                                                     
		                                          
		                                              
		                                            
		                                                    
		                                    
		                                   
		                                      
		                                     
		                                            
		                                        
		                                                                 
		                                  
	 


	            
		                                                                                                           
		 
			                         
			 
				                                                 
				                                            

				                         
				                                               
				                                    
				                       
				                      
				                                  
				                                  

				                                            

				                                                           

				                                                                                                             
				 
					                                   

					                                                                            
					 
						                                                                                               
						                             
					 
					                                                                                 
					 
						                                                                                               
						                             
					 
					                                                              
					 
						                                                                                  

						                               
						 
							                                                             
							                                                                     
							               
							 
								                                                                                                
								                             
							 
						 
					 

					                              
					 
						                                                                                               
					 
				 
				    
				 
					                                                                              
				 

				                      
			 

			                                                                                   
				                                                      

		 
	 

	                          

 
#endif

#if SERVER
                                                                                      
 
	                                                       
		            

	                        
		            

	                                     
		            

	                                                                                    

	           
 
#endif         


#if SERVER
                                                                    
 
	                                                              
	                                 
	 
		                                               
		                                                                                              
		                                         

		                             
			                                                                                 
	 
 
#endif

#if CLIENT
void function AttemptCancel_NewcastleRevive_PC( entity player )
{
	if (!AttemptCancel_Allow(player) )
		return

	if( !IsControllerModeActive() )
		Remote_ServerCallFunction( "ClientCallback_Cancel_NewcastleRevive" )
}

void function AttemptCancel_NewcastleRevive_Console( entity player )
{
	if (!AttemptCancel_Allow(player) )
		return

	if( IsControllerModeActive() )
		Remote_ServerCallFunction( "ClientCallback_Cancel_NewcastleRevive" )

}

bool function AttemptCancel_Allow( entity player )
{
	if ( player != GetLocalViewPlayer() )
		return false
	if ( player != GetLocalClientPlayer() )
		return false
	if ( !PlayerHasPassive( player, ePassives.PAS_AXIOM ) )
		return false

	return true
}

void function ServerToClient_DisplayCancelNewcastleReviveHintForPlayer()
{
	thread _DisplayCancelNewcastleReviveHintForPlayer()
}

void function ServerToClient_RemoveCancelNewcastleReviveHintForPlayer()
{
	GetLocalViewPlayer().Signal( REVIVE_SHIELD_SIGNAL_AUTO_REVIVE_END )
}

void function _DisplayCancelNewcastleReviveHintForPlayer()
{
	entity player = GetLocalViewPlayer()

	if ( !IsValid( player ) )
		return

	EndSignal( player, "OnDeath" )
	EndSignal( player, REVIVE_SHIELD_SIGNAL_AUTO_REVIVE_END )
	if( IsControllerModeActive() )
	{
		AddPlayerHint( 6.5, 0.15, $"", "#NEWCASTLE_PASSIVE_CANCEL_REVIVE_HINT_CONSOLE" )
	}
	else
		AddPlayerHint( 6.5, 0.15, $"", "#NEWCASTLE_PASSIVE_CANCEL_REVIVE_HINT_PC" )

	OnThreadEnd(
		function() : ()
		{
			HidePlayerHint( "#NEWCASTLE_PASSIVE_CANCEL_REVIVE_HINT_PC" )
			HidePlayerHint( "#NEWCASTLE_PASSIVE_CANCEL_REVIVE_HINT_CONSOLE" )
		}
	)

	WaitForever()
}
#endif


#if SERVER
                                                                         
 
	                                
	                              

	                  
	 
		                    
		          
	 

	                        
		      

	                                            
	                                  
	                                
	                                                                                                                                   
 
#endif

bool function IsEntNewcastleReviver( entity ent )
{
	if( !( ent in file.isReviveIntro ) )
		return false

	if( file.isReviveIntro[ent] )
		return false

	if( ent.GetPlayerSettings() == $"settings/player/mp/pilot_survival_newcastle.rpak" && ent.ContextAction_IsReviving() )
		return true

	return false
}

bool function IsEntNewcastleReviveTarget( entity ent )
{
	if( !( ent.ContextAction_IsBeingRevived() ) )
		return false

	entity parentEnt = ent.GetParent()
	if( !IsValid( parentEnt ) )
		return false

	if( IsEntNewcastleReviver( parentEnt ) )
		return true

	return false
}

#if SERVER
                                                                              
 
	                             
	                           
	                                         
	                                         
	                                            
	                                                  

	                                
	                              
	                                                     

	            
		                    
		 
			                  
			 
				                                         
				                                                   
				                                                                                           
				                                      
				                                              
			 

		 
	 

	                                              

	             
 
#endif


      