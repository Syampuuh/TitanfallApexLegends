global function Armor_ShieldRegen_IsUsingShieldRegen

global function Armor_ShieldRegen_Init
global function Armor_ShieldRegen_RegisterNetworking

#if SERVER
                                                              
#endif

#if CLIENT
global function Armor_ShieldRegen_ServerCallback_RegenTriggerEvent
global function Armor_ShieldRegen_ServerCallback_RegenCancelEvent
#endif

#if DEV
const bool SHIELD_REGEN_DEBUG = false
#endif       

const float DEFAULT_SHIELD_REGEN_DELAY_TIME = 8.0                                                          
const float DEFAULT_SHIELD_REGEN_BREAK_DELAY_TIME = 16.0                                                                      
const float SHIELD_REGEN_PREEMPTIVE_TIME = 0.25

#if SERVER
                                                                                                      
#endif

                    
#if SERVER
                 
                                                                                           
                
                                                                                            
                    
                                                                                                         

                 
                                                                                                          
                
                                                                                                           
                    
                                                                                                            
#endif
                    

                  
#if SERVER
                        
                                                                                           
                    
                                                                                                           
#endif
                  

struct
{
	var armorShieldRegenRui
	float shieldRegenDelayTime
	float shieldRegenBreakDelayTime
	#if SERVER
		                           
	#endif
} file

void function Armor_ShieldRegen_Init()
{
	#if DEV
		if ( SHIELD_REGEN_DEBUG )
		{
			printf("Armor_ShieldRegen_Init()")
		}
	#endif

	if ( !Armor_ShieldRegen_IsUsingShieldRegen() )
	{
		#if DEV
			if ( SHIELD_REGEN_DEBUG )
			{
				printf("Armor_ShieldRegen_Init: Shield Regen disabled. See playlist vars!")
			}
		#endif
		return
	}

	#if SERVER
		                                                                    
		                                                                               
		                                                                            
		                                                                              
		                                                                           
		                                                                                                                            
	#endif

	RegisterSignal( "Armor_ShieldRegen_OnDamaged" )
	RegisterSignal( "Armor_ShieldRegen_OnDisconnect" )
	file.shieldRegenDelayTime = GetCurrentPlaylistVarFloat( "shield_regen_delay_time", DEFAULT_SHIELD_REGEN_DELAY_TIME )
	file.shieldRegenBreakDelayTime = GetCurrentPlaylistVarFloat( "shield_regen_break_delay_time", DEFAULT_SHIELD_REGEN_BREAK_DELAY_TIME )
	#if CLIENT
		AddCallback_OnPlayerDisconnected( Armor_ShieldRegen_OnPlayerDisconnected )
		AddCreateCallback( "player", Armor_ShieldRegen_OnPlayerSpawned )
		AddCallback_GameStateEnter( eGameState.Postmatch, Armor_ShieldRegen_OnGameState_Ending )
	#endif
}

void function Armor_ShieldRegen_RegisterNetworking()
{
	if ( !Armor_ShieldRegen_IsUsingShieldRegen() )
		return

	Remote_RegisterClientFunction( "Armor_ShieldRegen_ServerCallback_RegenTriggerEvent", "bool" )
	Remote_RegisterClientFunction( "Armor_ShieldRegen_ServerCallback_RegenCancelEvent" )
}

#if SERVER
                                                                  
 
	       
		                         
			                                               
	      

	                         
		      

	                                                                                     
		                                                                            
 

                                                                     
 
	       
		                         
			                                                  
	      

	                                                 

	                                                                                
		                                                                               
 

                                                                                
 
	       
		                         
			                                             
	      

	                                                                                                                                          
	                                                                                                                                     
	 
		       
			                         
				                                                                                      
		      
		      
	 

	                                       
	 
		       
			                         
				                                                                                
		      
		      
	 

	                                                             
	 
		       
			                         
				                                                                                
		      
		      
	 

	                                                                      
 

                                                                
 
	       
		                         
			                                             
	      

	                                                                     
 

                                                                                             
 
	       
		                         
			                                                   
	      

	                                              

	                               
	                             
	                                           
	                                                 
	                                                    

	                                                                                                        

	                                      
		       
			                         
				                                                             
		      

		                                                                                            
	   

	                                                                         

	                 
	 
		                                            

		                                    
		 
			                                           
		 

		                        
		                                             
		 
			                                                              
				     

			           
		 
	 

                                       
		                                                                          
		 
			       
				                         
					                                                                                                             
			      
			           
		 
       

	                                                              
	 
		                     
		                                                              
		                                                          

		                                                                                                             
		                                                                             
		                      

		                                           
			       
				                         
					                                                             
			      

			                                                                                            

			                     
				                 

			                                                     
			                                                        
		   

		                                                                            
		                                                                       

		                                                                              
		                                                                         

		                        
		                                                                 
		 
			                                      
			                  
			                                                                                                                                   
			                                                                  

			                       
			 
				                                         
			 

			                                                                 
			                                
			 
				                        
				                                                         
				                                                  
			 

			           
		 

		                                                                               
		                                                                          
	 
 

                                                                                                                                                                     
 
	       
		                         
			                                                                         
	      

	                                                     

	                       
		      

	                                       
	 
		                                                              
			                                                                      
	 
 

                                                                    
 
	       
		                         
			                                              
	      

	                                                                                     
		                                                                            

	                                                             
 

                                                                           
 
	                                                                                                                                            

	                         
		      

	                                                              
		      

	                                                                      
 
#endif

#if CLIENT
void function Armor_ShieldRegen_OnPlayerSpawned( entity player )
{
	#if DEV
		if ( SHIELD_REGEN_DEBUG )
			printf( "Armor_ShieldRegen_OnPlayerSpawned()" )
	#endif

	if ( player == GetLocalClientPlayer() )
		ShieldRegen_CreateShieldRegenUI()
}

void function Armor_ShieldRegen_OnPlayerDisconnected( entity player )
{
	#if DEV
		if ( SHIELD_REGEN_DEBUG )
			printf("Armor_ShieldRegen_OnPlayerDisconnected()")
	#endif

	if ( !IsValid( player ) )
		return

	player.Signal( "Armor_ShieldRegen_OnDisconnect" )
}

void function ShieldRegen_CreateShieldRegenUI()
{
	#if DEV
		if ( SHIELD_REGEN_DEBUG )
			printf("ShieldRegen_CreateShieldRegenUI()")
	#endif

	if ( IsValid( file.armorShieldRegenRui ) )
		return

	file.armorShieldRegenRui = CreateCockpitPostFXRui( $"ui/armor_shieldregen.rpak" , MINIMAP_Z_BASE )
	RuiSetFloat( file.armorShieldRegenRui, "maxRegenDelay", file.shieldRegenBreakDelayTime )
}

void function Armor_ShieldRegen_OnGameState_Ending()
{
	#if DEV
		if ( SHIELD_REGEN_DEBUG )
			printf("Armor_ShieldRegen_OnGameState_Ending()")
	#endif

	if ( !IsValid( file.armorShieldRegenRui ) )
		return

	RuiDestroyIfAlive( file.armorShieldRegenRui )
}

void function Armor_ShieldRegen_ServerCallback_RegenTriggerEvent( bool skipDelay )
{
	#if DEV
		if ( SHIELD_REGEN_DEBUG )
			printf("Armor_ShieldRegen_ServerCallback_RegenTriggerEvent()")
	#endif

	thread ShieldRegen_RegenTriggerNotice_Thread( skipDelay )
}

void function Armor_ShieldRegen_ServerCallback_RegenCancelEvent()
{
	#if DEV
		if ( SHIELD_REGEN_DEBUG )
			printf("Armor_ShieldRegen_ServerCallback_RegenCancelEvent()")
	#endif

	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return

	player.Signal( "Armor_ShieldRegen_OnDamaged" )
}


void function ShieldRegen_RegenTriggerNotice_Thread( bool skipDelay )
{
	#if DEV
		if ( SHIELD_REGEN_DEBUG )
			printf("ShieldRegen_RegenTriggerNotice_Thread()")
	#endif

	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return

	player.EndSignal( "OnDestroy" )
	player.EndSignal( "Armor_ShieldRegen_OnDamaged" )
	player.EndSignal( "Armor_ShieldRegen_OnDisconnect" )

	OnThreadEnd( function() : ( ) {
		#if DEV
			if ( SHIELD_REGEN_DEBUG )
				printf("ShieldRegen_RegenTriggerNotice: Thread End")
		#endif

		RuiSetBool( file.armorShieldRegenRui, "isDamaged", false )
		RuiSetFloat( file.armorShieldRegenRui, "regenDelay", 0.0 )
	} )

	float regenDelay = 0.0
	if ( !skipDelay )
	{
		regenDelay = file.shieldRegenDelayTime

		if ( player.GetShieldHealth() == 0 )
			regenDelay = file.shieldRegenBreakDelayTime
	}

	          
	int armorTier = EquipmentSlot_GetEquipmentTier( player, "armor" )
	vector color = GetFXRarityColorForTier( armorTier )

	RuiSetBool( file.armorShieldRegenRui, "isDamaged", true )
	RuiSetGameTime( file.armorShieldRegenRui, "lastDamageTime", Time() )
	RuiSetFloat( file.armorShieldRegenRui, "regenDelay", regenDelay )

	RuiSetFloat3( file.armorShieldRegenRui, "armorColor", <color.x/255.0, color.y/255.0, color.z/255.0> )

	if ( !skipDelay )
		wait( regenDelay - SHIELD_REGEN_PREEMPTIVE_TIME )                                                    

	while ( player.GetShieldHealth() != player.GetShieldHealthMax() )
	{
		WaitFrame()
	}

	RuiSetBool( file.armorShieldRegenRui, "isDamaged", false )
}
#endif

                                                  
bool function Armor_ShieldRegen_IsUsingShieldRegen()
{
	return GetCurrentPlaylistVarBool( "use_shield_regen", false )
}
